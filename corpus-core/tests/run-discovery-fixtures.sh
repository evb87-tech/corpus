#!/usr/bin/env bash
set -euo pipefail

# run-discovery-fixtures.sh — run discover-packs.sh against each discovery
# fixture directory and assert expected outcomes.
#
# Fixture naming convention:
#   single-pack/              → must exit 0 and contain pack name in "packs" array
#   two-compatible-packs/     → must exit 0 and contain two entries in "packs"
#   collision-entity-type/    → must exit 1 and stderr must mention "entity-types collision"
#   collision-review-angle/   → must exit 1 and stderr must mention "review-angles collision"
#   invalid-pack/             → must exit 1 (validate-pack.sh rejects it)
#   incompatible-version/     → must exit 1 and stderr must name the offending pack
#   no-packs/                 → must exit 0 and emit empty arrays
#
# Usage: bash corpus-core/tests/run-discovery-fixtures.sh
#   (run from repo root, or any directory — script resolves paths via $0)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FIXTURES_DIR="$SCRIPT_DIR/discovery-fixtures"
DISCOVER="$SCRIPT_DIR/../bin/discover-packs.sh"

if [[ ! -f "$DISCOVER" ]]; then
  echo "ERROR: discover-packs.sh not found at $DISCOVER" >&2
  exit 1
fi

PASS=0
FAIL=0

# ── Helpers ───────────────────────────────────────────────────────────────────

pass() {
  echo "PASS  $1"
  (( PASS++ )) || true
}

fail() {
  echo "FAIL  $1"
  echo "      $2"
  (( FAIL++ )) || true
}

# run_discover <dir> → runs discover-packs.sh with CLAUDE_PLUGIN_PATHS set to dir
# Sets globals: DISCOVER_STDOUT, DISCOVER_STDERR, DISCOVER_EXIT
run_discover() {
  local dir="$1"
  DISCOVER_EXIT=0
  DISCOVER_STDOUT="$(CLAUDE_PLUGIN_PATHS="$dir" bash "$DISCOVER" 2>/tmp/discover-stderr.tmp)" || DISCOVER_EXIT=$?
  DISCOVER_STDERR="$(cat /tmp/discover-stderr.tmp)"
}

# ── Fixture: single-pack ──────────────────────────────────────────────────────

run_discover "$FIXTURES_DIR/single-pack"
if [[ "$DISCOVER_EXIT" -ne 0 ]]; then
  fail "single-pack: exit 0" "got exit $DISCOVER_EXIT; stderr: $DISCOVER_STDERR"
else
  # Must have 1 pack entry
  pack_count="$(echo "$DISCOVER_STDOUT" | jq '.packs | length')"
  if [[ "$pack_count" -eq 1 ]]; then
    pass "single-pack: exits 0, registry has 1 pack"
  else
    fail "single-pack: registry has 1 pack" "got $pack_count packs; stdout: $DISCOVER_STDOUT"
  fi
fi

# ── Fixture: two-compatible-packs ─────────────────────────────────────────────

run_discover "$FIXTURES_DIR/two-compatible-packs"
if [[ "$DISCOVER_EXIT" -ne 0 ]]; then
  fail "two-compatible-packs: exit 0" "got exit $DISCOVER_EXIT; stderr: $DISCOVER_STDERR"
else
  pack_count="$(echo "$DISCOVER_STDOUT" | jq '.packs | length')"
  et_count="$(echo "$DISCOVER_STDOUT" | jq '."entity-types" | length')"
  ra_count="$(echo "$DISCOVER_STDOUT" | jq '."review-angles" | length')"
  bh_count="$(echo "$DISCOVER_STDOUT" | jq '."beads-handoffs" | length')"
  if [[ "$pack_count" -eq 2 && "$et_count" -eq 2 && "$ra_count" -eq 2 && "$bh_count" -eq 2 ]]; then
    pass "two-compatible-packs: exits 0, registry has 2 packs + merged arrays"
  else
    fail "two-compatible-packs: expected 2 packs and merged arrays" \
      "packs=$pack_count entity-types=$et_count review-angles=$ra_count beads-handoffs=$bh_count"
  fi
fi

# ── Fixture: collision-entity-type ────────────────────────────────────────────

run_discover "$FIXTURES_DIR/collision-entity-type"
if [[ "$DISCOVER_EXIT" -eq 0 ]]; then
  fail "collision-entity-type: exit 1" "got exit 0 (collision not detected)"
else
  if echo "$DISCOVER_STDERR" | grep -qF "entity-types"; then
    pass "collision-entity-type: exits 1, stderr mentions entity-types"
  else
    fail "collision-entity-type: stderr mentions entity-types" \
      "stderr was: $DISCOVER_STDERR"
  fi
fi

# ── Fixture: collision-review-angle ───────────────────────────────────────────

run_discover "$FIXTURES_DIR/collision-review-angle"
if [[ "$DISCOVER_EXIT" -eq 0 ]]; then
  fail "collision-review-angle: exit 1" "got exit 0 (collision not detected)"
else
  if echo "$DISCOVER_STDERR" | grep -qF "review-angles"; then
    pass "collision-review-angle: exits 1, stderr mentions review-angles"
  else
    fail "collision-review-angle: stderr mentions review-angles" \
      "stderr was: $DISCOVER_STDERR"
  fi
fi

# ── Fixture: invalid-pack ─────────────────────────────────────────────────────

run_discover "$FIXTURES_DIR/invalid-pack"
if [[ "$DISCOVER_EXIT" -eq 0 ]]; then
  fail "invalid-pack: exit 1" "got exit 0 (invalid manifest was accepted)"
else
  if echo "$DISCOVER_STDERR" | grep -qF "validation failed"; then
    pass "invalid-pack: exits 1, stderr mentions validation failed"
  else
    fail "invalid-pack: stderr mentions validation failed" \
      "stderr was: $DISCOVER_STDERR"
  fi
fi

# ── Fixture: incompatible-version ────────────────────────────────────────────

run_discover "$FIXTURES_DIR/incompatible-version"
if [[ "$DISCOVER_EXIT" -eq 0 ]]; then
  fail "incompatible-version: exit 1" "got exit 0 (incompatible core-version not detected)"
else
  if echo "$DISCOVER_STDERR" | grep -qF "pack-incompat"; then
    pass "incompatible-version: exits 1, stderr names the pack (pack-incompat)"
  else
    fail "incompatible-version: stderr names the pack" \
      "stderr was: $DISCOVER_STDERR"
  fi
fi

# ── Fixture: no-packs ─────────────────────────────────────────────────────────

run_discover "$FIXTURES_DIR/no-packs"
if [[ "$DISCOVER_EXIT" -ne 0 ]]; then
  fail "no-packs: exit 0" "got exit $DISCOVER_EXIT; stderr: $DISCOVER_STDERR"
else
  pack_count="$(echo "$DISCOVER_STDOUT" | jq '.packs | length')"
  et_count="$(echo "$DISCOVER_STDOUT" | jq '."entity-types" | length')"
  ra_count="$(echo "$DISCOVER_STDOUT" | jq '."review-angles" | length')"
  bh_count="$(echo "$DISCOVER_STDOUT" | jq '."beads-handoffs" | length')"
  if [[ "$pack_count" -eq 0 && "$et_count" -eq 0 && "$ra_count" -eq 0 && "$bh_count" -eq 0 ]]; then
    pass "no-packs: exits 0, all arrays empty"
  else
    fail "no-packs: all arrays should be empty" \
      "packs=$pack_count entity-types=$et_count review-angles=$ra_count beads-handoffs=$bh_count"
  fi
fi

# ── Unit: semver_satisfies ────────────────────────────────────────────────────
# Direct unit tests against semver.sh. Fixtures alone can't exercise major-only
# ranges (^1, ~1) or cross-minor cases (^0.1 vs 0.2.0) because the running
# corpus-core version is fixed at discovery time. Lock down the parser's
# contract semantics (rules/09 §6) against future regressions.

SEMVER_LIB="$SCRIPT_DIR/../bin/semver.sh"
# shellcheck disable=SC1090
source "$SEMVER_LIB"

if declare -f semver_satisfies >/dev/null; then
  semver_case() {
    local desc="$1" version="$2" range="$3" expected="$4"
    local got="ok"
    semver_satisfies "$version" "$range" || got="fail"
    if [[ "$got" == "$expected" ]]; then
      pass "semver: $desc ($version vs $range → $expected)"
    else
      fail "semver: $desc ($version vs $range)" "expected $expected, got $got"
    fi
  }

  # Caret per corpus contract: same major, version >= range
  semver_case "caret major-only ^1 vs 1.0.0" "1.0.0" "^1" "ok"
  semver_case "caret major-only ^1 vs 1.5.3" "1.5.3" "^1" "ok"
  semver_case "caret major-only ^1 vs 2.0.0" "2.0.0" "^1" "fail"
  semver_case "caret major-only ^1 vs 0.9.9" "0.9.9" "^1" "fail"
  semver_case "caret 0.x accepts minor bumps ^0.1 vs 0.2.0" "0.2.0" "^0.1" "ok"
  semver_case "caret 0.x rejects major bumps ^0.1 vs 1.0.0" "1.0.0" "^0.1" "fail"
  semver_case "caret 0.x rejects below range ^0.2 vs 0.1.5" "0.1.5" "^0.2" "fail"
  semver_case "caret incompatible ^99.0.0 vs 0.1.0" "0.1.0" "^99.0.0" "fail"
  semver_case "caret happy path ^0.1.0 vs 0.1.0" "0.1.0" "^0.1.0" "ok"

  # Tilde: pins minor only when minor is explicit
  semver_case "tilde major-only ~1 vs 1.5.0" "1.5.0" "~1" "ok"
  semver_case "tilde major-only ~1 vs 2.0.0" "2.0.0" "~1" "fail"
  semver_case "tilde minor-pinned ~0.1 vs 0.1.5" "0.1.5" "~0.1" "ok"
  semver_case "tilde minor-pinned ~0.1 vs 0.2.0" "0.2.0" "~0.1" "fail"

  # Inequality operators
  semver_case ">=0.1.0 vs 0.1.0" "0.1.0" ">=0.1.0" "ok"
  semver_case ">=0.1.0 vs 0.0.9" "0.0.9" ">=0.1.0" "fail"
  semver_case "<1.0.0 vs 0.9.9" "0.9.9" "<1.0.0" "ok"
  semver_case "<1.0.0 vs 1.0.0" "1.0.0" "<1.0.0" "fail"

  # Exact match
  semver_case "exact 0.1.0 vs 0.1.0" "0.1.0" "0.1.0" "ok"
  semver_case "exact 0.1.0 vs 0.1.1" "0.1.1" "0.1.0" "fail"
else
  fail "semver_satisfies sourcing" "function not defined after sourcing semver.sh"
fi

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "Results: $PASS passed, $FAIL failed"

if [[ "$FAIL" -gt 0 ]]; then
  exit 1
fi
exit 0
