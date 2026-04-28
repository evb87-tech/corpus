#!/usr/bin/env bash
set -euo pipefail

# core-version.sh — print the running corpus-core version from plugin.json.
#
# Usage: core-version.sh
#   Prints the version string (e.g. "0.1.0") to stdout and exits 0.
#   Exits 1 on error.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_JSON="$SCRIPT_DIR/../.claude-plugin/plugin.json"

if [[ ! -f "$PLUGIN_JSON" ]]; then
  echo "Error: plugin.json not found at $PLUGIN_JSON" >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is not installed. Install jq: https://stedolan.github.io/jq/" >&2
  exit 1
fi

VERSION="$(jq -r '.version // ""' "$PLUGIN_JSON")"

if [[ -z "$VERSION" ]]; then
  echo "Error: version field is missing or empty in $PLUGIN_JSON" >&2
  exit 1
fi

echo "$VERSION"
