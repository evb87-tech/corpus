#!/usr/bin/env bash
set -euo pipefail

# run.sh — run validate-pack.sh against all fixtures and assert expected outcomes.
# Accept fixtures (accept-*.yaml)  → must exit 0.
# Reject fixtures (reject-*.yaml)  → must exit 1 AND stderr must contain the
#   substring from the first "# EXPECT: <substring>" comment in the fixture file.
#
# Usage: bash corpus-core/tests/pack-fixtures/run.sh
#   (run from repo root, or any directory — script resolves paths via $0)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
# Validator lives at corpus-core/bin/validate-pack.sh relative to worktree root
VALIDATOR="$SCRIPT_DIR/../../bin/validate-pack.sh"

if [[ ! -f "$VALIDATOR" ]]; then
  echo "ERROR: validator not found at $VALIDATOR" >&2
  exit 1
fi

PASS=0
FAIL=0

run_accept() {
  local fixture="$1"
  local name
  name="$(basename "$fixture")"
  local stderr_out
  if stderr_out="$(bash "$VALIDATOR" "$fixture" 2>&1)"; then
    echo "PASS  accept: $name"
    (( PASS++ )) || true
  else
    echo "FAIL  accept: $name (expected exit 0, got exit 1)"
    if [[ -n "$stderr_out" ]]; then
      echo "      stderr: $stderr_out"
    fi
    (( FAIL++ )) || true
  fi
}

run_reject() {
  local fixture="$1"
  local name
  name="$(basename "$fixture")"

  # Extract expected substring from "# EXPECT: ..." comment in fixture
  local expected
  expected="$(grep -m1 '^# EXPECT:' "$fixture" | sed 's/^# EXPECT: *//')" || true
  if [[ -z "$expected" ]]; then
    echo "FAIL  reject: $name (no # EXPECT: comment found in fixture)"
    (( FAIL++ )) || true
    return
  fi

  local stderr_out
  local exit_code=0
  stderr_out="$(bash "$VALIDATOR" "$fixture" 2>&1)" || exit_code=$?

  if [[ "$exit_code" -eq 0 ]]; then
    echo "FAIL  reject: $name (expected exit 1, got exit 0)"
    (( FAIL++ )) || true
    return
  fi

  if echo "$stderr_out" | grep -qF "$expected"; then
    echo "PASS  reject: $name"
    (( PASS++ )) || true
  else
    echo "FAIL  reject: $name (exit 1 ok, but stderr did not contain expected substring)"
    echo "      expected: $expected"
    echo "      stderr:   $stderr_out"
    (( FAIL++ )) || true
  fi
}

# ── Run all fixtures ──────────────────────────────────────────────────────────

for f in "$SCRIPT_DIR"/accept-*.yaml; do
  run_accept "$f"
done

for f in "$SCRIPT_DIR"/reject-*.yaml; do
  run_reject "$f"
done

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "Results: $PASS passed, $FAIL failed"

if [[ "$FAIL" -gt 0 ]]; then
  exit 1
fi
exit 0
