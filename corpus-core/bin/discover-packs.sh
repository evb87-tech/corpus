#!/usr/bin/env bash
set -euo pipefail

# discover-packs.sh — scan installed pack manifests, validate each via
# validate-pack.sh, check for cross-pack name collisions, and emit a merged
# registry as JSON on stdout.
#
# Usage: discover-packs.sh
#   (run from any directory; resolves paths automatically)
#
# Input scanning (tiered fallback):
#   1. CLAUDE_PLUGIN_PATHS (colon-separated dirs) — explicit override.
#   2. ~/.claude/plugins/cache/ — Claude Code's installed-plugin cache. This is
#      where /plugin install puts marketplace plugins, so this is the production
#      lookup path when /ingest, /check, etc. run inside a Claude Code session
#      that does not happen to be in a git repo.
#   3. Repo root via git rev-parse --show-toplevel — last-ditch dev fallback,
#      only useful when working on the corpus repo itself.
#
# Exit 0: registry emitted on stdout.
# Exit 1: validation failure or collision (details on stderr).

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VALIDATOR="$SCRIPT_DIR/validate-pack.sh"
CORE_VERSION_SCRIPT="$SCRIPT_DIR/core-version.sh"

if [[ ! -f "$VALIDATOR" ]]; then
  echo "Error: validate-pack.sh not found at $VALIDATOR" >&2
  exit 1
fi

if [[ ! -f "$CORE_VERSION_SCRIPT" ]]; then
  echo "Error: core-version.sh not found at $CORE_VERSION_SCRIPT" >&2
  exit 1
fi

if ! command -v yq >/dev/null 2>&1; then
  echo "Error: yq is not installed. Install Mike Farah's Go yq: https://github.com/mikefarah/yq" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is not installed. Install jq: https://stedolan.github.io/jq/" >&2
  exit 1
fi

# ── Locate search roots ───────────────────────────────────────────────────────

SEARCH_ROOTS=()
USING_PLUGIN_PATHS=0

if [[ -n "${CLAUDE_PLUGIN_PATHS:-}" ]]; then
  IFS=':' read -ra SEARCH_ROOTS <<< "$CLAUDE_PLUGIN_PATHS"
  USING_PLUGIN_PATHS=1
elif [[ -d "${HOME}/.claude/plugins/cache" ]]; then
  # Production fallback: Claude Code installs plugins under
  # ~/.claude/plugins/cache/<marketplace>/<plugin>/<version>/. Each leaf is a
  # plugin root that may contain corpus-pack.yaml.
  SEARCH_ROOTS=("${HOME}/.claude/plugins/cache")
elif REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  # Dev fallback: working inside the corpus repo itself.
  SEARCH_ROOTS=("$REPO_ROOT")
else
  echo "Error: no search root available (CLAUDE_PLUGIN_PATHS unset, no plugin cache at ~/.claude/plugins/cache, not inside a git repo)" >&2
  exit 1
fi

# ── Find all corpus-pack.yaml files ──────────────────────────────────────────

MANIFESTS=()
for root in "${SEARCH_ROOTS[@]}"; do
  if [[ ! -d "$root" ]]; then
    echo "Error: search root does not exist: $root" >&2
    exit 1
  fi
  if [[ "$USING_PLUGIN_PATHS" -eq 1 ]]; then
    # Explicit plugin paths: scan each root directly (not recursive)
    while IFS= read -r manifest; do
      MANIFESTS+=("$manifest")
    done < <(find "$root" -name "corpus-pack.yaml" -type f 2>/dev/null | sort)
  else
    # Repo root fallback: exclude test fixture directories to avoid picking up
    # fixture manifests that are intentionally invalid.
    while IFS= read -r manifest; do
      MANIFESTS+=("$manifest")
    done < <(find "$root" -name "corpus-pack.yaml" -type f \
      -not -path "*/tests/*" \
      2>/dev/null | sort)
  fi
done

if [[ ${#MANIFESTS[@]} -eq 0 ]]; then
  # No packs found: emit empty registry
  jq -n '{
    "packs": [],
    "entity-types": [],
    "review-angles": [],
    "beads-handoffs": []
  }'
  exit 0
fi

# ── Validate each manifest via validate-pack.sh ───────────────────────────────

FAIL=0
for manifest in "${MANIFESTS[@]}"; do
  stderr_out="$(bash "$VALIDATOR" "$manifest" 2>&1)" || {
    echo "Error: pack validation failed: $manifest" >&2
    if [[ -n "$stderr_out" ]]; then
      echo "$stderr_out" >&2
    fi
    FAIL=1
  }
done

if [[ "$FAIL" -eq 1 ]]; then
  exit 1
fi

# ── Core-version compatibility check ─────────────────────────────────────────
# Resolve the running corpus-core version once, then check each pack's
# core-version range against it.

RUNNING_CORE_VERSION="$(bash "$CORE_VERSION_SCRIPT")"

# Load semver_satisfies (parser semantics documented in corpus-core/rules/09 §6).
SEMVER_LIB="$SCRIPT_DIR/semver.sh"
if [[ ! -f "$SEMVER_LIB" ]]; then
  echo "Error: semver.sh not found at $SEMVER_LIB" >&2
  exit 1
fi
# shellcheck disable=SC1090
source "$SEMVER_LIB"

VERSION_FAIL=0
for manifest in "${MANIFESTS[@]}"; do
  pack_name="$(yq eval '.name // ""' "$manifest")"
  pack_core_version="$(yq eval '.core-version // ""' "$manifest")"
  if [[ -n "$pack_core_version" ]]; then
    if ! semver_satisfies "$RUNNING_CORE_VERSION" "$pack_core_version"; then
      echo "Error: pack '${pack_name}' requires corpus-core ${pack_core_version} but running version is ${RUNNING_CORE_VERSION} (manifest: $manifest)" >&2
      VERSION_FAIL=1
    fi
  fi
done

if [[ "$VERSION_FAIL" -eq 1 ]]; then
  exit 1
fi

# ── Cross-pack collision check ─────────────────────────────────────────────────
# Build maps: name -> pack-file for each of the three extension arrays.

# Associative arrays: entity_type_owners["persona"] = "/path/to/corpus-pack.yaml"
declare -A entity_type_owners
declare -A review_angle_owners
declare -A beads_handoff_owners

COLLISION_FOUND=0

check_collision() {
  local -n owners_ref=$1   # nameref to associative array
  local kind="$2"
  local entry_name="$3"
  local pack_file="$4"

  if [[ -v "owners_ref[$entry_name]" ]]; then
    echo "Error: ${kind} collision on '${entry_name}': registered by both '${owners_ref[$entry_name]}' and '${pack_file}'" >&2
    COLLISION_FOUND=1
  else
    owners_ref["$entry_name"]="$pack_file"
  fi
}

for manifest in "${MANIFESTS[@]}"; do
  # entity-types
  et_count="$(yq eval '.entity-types | length' "$manifest")"
  if [[ "$et_count" -gt 0 ]] 2>/dev/null; then
    for i in $(seq 0 $(( et_count - 1 ))); do
      name="$(yq eval ".entity-types[${i}].name // \"\"" "$manifest")"
      [[ -n "$name" ]] && check_collision entity_type_owners "entity-types" "$name" "$manifest"
    done
  fi

  # review-angles
  ra_count="$(yq eval '.review-angles | length' "$manifest")"
  if [[ "$ra_count" -gt 0 ]] 2>/dev/null; then
    for i in $(seq 0 $(( ra_count - 1 ))); do
      name="$(yq eval ".review-angles[${i}].name // \"\"" "$manifest")"
      [[ -n "$name" ]] && check_collision review_angle_owners "review-angles" "$name" "$manifest"
    done
  fi

  # beads-handoffs
  bh_count="$(yq eval '.beads-handoffs | length' "$manifest")"
  if [[ "$bh_count" -gt 0 ]] 2>/dev/null; then
    for i in $(seq 0 $(( bh_count - 1 ))); do
      name="$(yq eval ".beads-handoffs[${i}].name // \"\"" "$manifest")"
      [[ -n "$name" ]] && check_collision beads_handoff_owners "beads-handoffs" "$name" "$manifest"
    done
  fi
done

if [[ "$COLLISION_FOUND" -eq 1 ]]; then
  exit 1
fi

# ── Build merged registry JSON ────────────────────────────────────────────────
# Strategy: accumulate JSON arrays with jq, then merge.

PACKS_JSON="[]"
ENTITY_TYPES_JSON="[]"
REVIEW_ANGLES_JSON="[]"
BEADS_HANDOFFS_JSON="[]"

for manifest in "${MANIFESTS[@]}"; do
  pack_name="$(yq eval '.name // ""' "$manifest")"
  pack_version="$(yq eval '.core-version // ""' "$manifest")"
  pack_path="$(dirname "$manifest")"

  # Add pack metadata entry
  pack_entry="$(jq -n \
    --arg name "$pack_name" \
    --arg version "$pack_version" \
    --arg path "$pack_path" \
    '{"name": $name, "version": $version, "path": $path}')"
  PACKS_JSON="$(jq -n --argjson arr "$PACKS_JSON" --argjson entry "$pack_entry" '$arr + [$entry]')"

  # Merge entity-types (convert YAML array to JSON, annotate each entry with pack name)
  et_json="$(yq eval -o=json '.entity-types // []' "$manifest")"
  et_json="$(jq --arg pack "$pack_name" '[.[] | . + {"_pack": $pack}]' <<< "$et_json")"
  ENTITY_TYPES_JSON="$(jq -n --argjson arr "$ENTITY_TYPES_JSON" --argjson entries "$et_json" '$arr + $entries')"

  # Merge review-angles
  ra_json="$(yq eval -o=json '.review-angles // []' "$manifest")"
  ra_json="$(jq --arg pack "$pack_name" '[.[] | . + {"_pack": $pack}]' <<< "$ra_json")"
  REVIEW_ANGLES_JSON="$(jq -n --argjson arr "$REVIEW_ANGLES_JSON" --argjson entries "$ra_json" '$arr + $entries')"

  # Merge beads-handoffs
  bh_json="$(yq eval -o=json '.beads-handoffs // []' "$manifest")"
  bh_json="$(jq --arg pack "$pack_name" '[.[] | . + {"_pack": $pack}]' <<< "$bh_json")"
  BEADS_HANDOFFS_JSON="$(jq -n --argjson arr "$BEADS_HANDOFFS_JSON" --argjson entries "$bh_json" '$arr + $entries')"
done

# ── Emit registry ─────────────────────────────────────────────────────────────

jq -n \
  --argjson packs       "$PACKS_JSON" \
  --argjson entity_types "$ENTITY_TYPES_JSON" \
  --argjson review_angles "$REVIEW_ANGLES_JSON" \
  --argjson beads_handoffs "$BEADS_HANDOFFS_JSON" \
  '{
    "packs":          $packs,
    "entity-types":   $entity_types,
    "review-angles":  $review_angles,
    "beads-handoffs": $beads_handoffs
  }'
