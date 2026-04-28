#!/usr/bin/env bash
set -euo pipefail

# validate-pack.sh — validate a corpus-pack.yaml against the schema
# defined in corpus-core/rules/09-extension-contract.md
#
# Usage: validate-pack.sh <path-to-corpus-pack.yaml>
# Exit 0: valid. Exit 1: invalid (errors on stderr).

PACK_FILE="${1:-}"

if [[ -z "$PACK_FILE" ]]; then
  echo "Usage: $0 <path-to-corpus-pack.yaml>" >&2
  exit 1
fi

if [[ ! -f "$PACK_FILE" ]]; then
  echo "Error: file not found: $PACK_FILE" >&2
  exit 1
fi

if ! command -v yq >/dev/null 2>&1; then
  echo "Error: yq is not installed. Install Mike Farah's Go yq: https://github.com/mikefarah/yq" >&2
  exit 1
fi

ERRORS=()

# ── Helper: append an error ─────────────────────────────────────────────────
err() {
  ERRORS+=("$1")
}

# ── Helper: iterate indices of an array field ────────────────────────────────
# Usage: for i in $(array_indices '.field-name'); do ...
# Returns nothing (not even 0) when the array is empty, so the loop body
# is skipped correctly.
array_indices() {
  local count
  count="$(yq eval "${1} | length" "$PACK_FILE")"
  if [[ "$count" -gt 0 ]] 2>/dev/null; then
    seq 0 $(( count - 1 ))
  fi
}

# ── 1. Top-level required fields ─────────────────────────────────────────────

NAME="$(yq eval '.name // ""' "$PACK_FILE")"
if [[ -z "$NAME" ]]; then
  err "name: required top-level field is missing or empty"
fi

EXTENDS="$(yq eval '.extends // ""' "$PACK_FILE")"
if [[ -z "$EXTENDS" ]]; then
  err "extends: required top-level field is missing or empty"
elif [[ "$EXTENDS" != "corpus-core" ]]; then
  err "extends: must be 'corpus-core', got '${EXTENDS}'"
fi

CORE_VERSION="$(yq eval '.core-version // ""' "$PACK_FILE")"
if [[ -z "$CORE_VERSION" ]]; then
  err "core-version: required top-level field is missing or empty"
else
  # Semver range: optional operator (^, ~, >=, <=, >, <, =) followed by
  # major(.minor(.patch)?)? with optional -prerelease and +build.
  SEMVER_RE='^(\^|~|>=|<=|>|<|=)?[0-9]+(\.[0-9]+){0,2}(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$'
  if [[ ! "$CORE_VERSION" =~ $SEMVER_RE ]]; then
    err "core-version: must be a semver range (e.g. '^0.1', '~1.2.3', '>=0.5'); got '${CORE_VERSION}'"
  fi
fi

# ── 2. entity-types ──────────────────────────────────────────────────────────

ET_TYPE="$(yq eval '.entity-types | tag' "$PACK_FILE")"
if [[ "$ET_TYPE" != "!!seq" ]]; then
  err "entity-types: required top-level array is missing or not an array"
else
  for i in $(array_indices '.entity-types'); do
    ET_NAME="$(yq eval ".entity-types[${i}].name // \"\"" "$PACK_FILE")"
    if [[ -z "$ET_NAME" ]]; then
      err "entity-types[${i}].name: required string field is missing or empty"
    fi

    ET_TEMPLATE="$(yq eval ".entity-types[${i}].template // \"\"" "$PACK_FILE")"
    if [[ -z "$ET_TEMPLATE" ]]; then
      err "entity-types[${i}].template: required string field is missing or empty"
    fi

    ET_SECTIONS="$(yq eval ".entity-types[${i}].sections | tag" "$PACK_FILE")"
    if [[ "$ET_SECTIONS" != "!!seq" ]]; then
      err "entity-types[${i}].sections: required array field is missing or not an array"
    fi

    ET_EXTRA="$(yq eval ".entity-types[${i}].extra-frontmatter | tag" "$PACK_FILE")"
    if [[ "$ET_EXTRA" != "!!seq" ]]; then
      err "entity-types[${i}].extra-frontmatter: required array field is missing or not an array"
    fi
  done
fi

# ── 3. review-angles ─────────────────────────────────────────────────────────

RA_TYPE="$(yq eval '.review-angles | tag' "$PACK_FILE")"
if [[ "$RA_TYPE" != "!!seq" ]]; then
  err "review-angles: required top-level array is missing or not an array"
else
  for i in $(array_indices '.review-angles'); do
    RA_NAME="$(yq eval ".review-angles[${i}].name // \"\"" "$PACK_FILE")"
    if [[ -z "$RA_NAME" ]]; then
      err "review-angles[${i}].name: required string field is missing or empty"
    fi

    RA_CMD="$(yq eval ".review-angles[${i}].command // \"\"" "$PACK_FILE")"
    if [[ -z "$RA_CMD" ]]; then
      err "review-angles[${i}].command: required string field is missing or empty"
    elif [[ "$RA_CMD" != /* ]]; then
      err "review-angles[${i}].command: must start with '/', got '${RA_CMD}'"
    fi

    # agent: optional, may be null — no validation needed

    RA_TYPES="$(yq eval ".review-angles[${i}].target-types | tag" "$PACK_FILE")"
    if [[ "$RA_TYPES" != "!!seq" ]]; then
      err "review-angles[${i}].target-types: required array field is missing or not an array"
    fi
  done
fi

# ── 4. beads-handoffs ────────────────────────────────────────────────────────

BH_TYPE="$(yq eval '.beads-handoffs | tag' "$PACK_FILE")"
if [[ "$BH_TYPE" != "!!seq" ]]; then
  err "beads-handoffs: required top-level array is missing or not an array"
else
  for i in $(array_indices '.beads-handoffs'); do
    BH_NAME="$(yq eval ".beads-handoffs[${i}].name // \"\"" "$PACK_FILE")"
    if [[ -z "$BH_NAME" ]]; then
      err "beads-handoffs[${i}].name: required string field is missing or empty"
    fi

    BH_CMD="$(yq eval ".beads-handoffs[${i}].command // \"\"" "$PACK_FILE")"
    if [[ -z "$BH_CMD" ]]; then
      err "beads-handoffs[${i}].command: required string field is missing or empty"
    elif [[ "$BH_CMD" != /* ]]; then
      err "beads-handoffs[${i}].command: must start with '/', got '${BH_CMD}'"
    fi

    # agent: optional — no validation needed

    BH_INPUT="$(yq eval ".beads-handoffs[${i}].input-type // \"\"" "$PACK_FILE")"
    if [[ -z "$BH_INPUT" ]]; then
      err "beads-handoffs[${i}].input-type: required string field is missing or empty"
    fi

    BH_OUTPUT="$(yq eval ".beads-handoffs[${i}].output-shape // \"\"" "$PACK_FILE")"
    if [[ -z "$BH_OUTPUT" ]]; then
      err "beads-handoffs[${i}].output-shape: required string field is missing or empty"
    elif [[ "$BH_OUTPUT" != "single-issue" && "$BH_OUTPUT" != "epic-with-children" && "$BH_OUTPUT" != "flat-batch" ]]; then
      err "beads-handoffs[${i}].output-shape: must be one of single-issue, epic-with-children, flat-batch; got '${BH_OUTPUT}'"
    fi
  done
fi

# ── Result ───────────────────────────────────────────────────────────────────

if [[ ${#ERRORS[@]} -eq 0 ]]; then
  exit 0
fi

for e in "${ERRORS[@]}"; do
  echo "$e" >&2
done
exit 1
