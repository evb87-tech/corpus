---
description: Scaffold a fresh corpus vault at the given path. Trigger FR — initialiser un vault corpus, créer un nouveau second cerveau, scaffolder un dossier vault.
argument-hint: <path>
---

```bash
set -euo pipefail

# Resolve plugin root.
#
# Claude Code sets CLAUDE_PLUGIN_ROOT for plugin scripts/hooks, but Bash blocks
# inside slash-command bodies are not always invoked with that env populated.
# Fall back to globbing the marketplace cache and known dev locations.
#
# Note: do NOT use $0 as a fallback — Claude Code's slash-command renderer
# substitutes $0 with the first positional argument before bash sees it.
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-}"
if [ -z "$PLUGIN_ROOT" ] || [ ! -d "$PLUGIN_ROOT/templates/vault" ]; then
  for candidate in \
    "$HOME/.claude/plugins/cache/corpus/corpus-core"/*/templates/vault \
    "$HOME/.claude/plugins/marketplaces/corpus/corpus-core/templates/vault" \
    "$(pwd)/corpus-core/templates/vault" \
    "$(git rev-parse --show-toplevel 2>/dev/null)/corpus-core/templates/vault"
  do
    if [ -d "$candidate" ]; then
      PLUGIN_ROOT="$(cd "$candidate/../.." && pwd)"
      break
    fi
  done
fi
TEMPLATES_DIR="${PLUGIN_ROOT}/templates/vault"

if [ ! -d "$TEMPLATES_DIR" ]; then
  echo "Error: cannot locate corpus-core templates."
  echo "  Looked under \$CLAUDE_PLUGIN_ROOT, ~/.claude/plugins/cache/corpus/corpus-core/<version>/templates/vault, and the local repo."
  echo "  If you installed corpus-core via the marketplace, set CLAUDE_PLUGIN_ROOT to the install path explicitly."
  exit 1
fi

# 1. Require an argument
if [ -z "${ARGUMENTS:-}" ]; then
  echo "Usage: /init-vault <path>"
  echo "Example: /init-vault ~/Documents/my-vault"
  exit 1
fi

# 2. Resolve absolute path (expand ~)
VAULT_PATH="${ARGUMENTS/#\~/$HOME}"
VAULT_PARENT="$(dirname "$VAULT_PATH")"
VAULT_BASE="$(basename "$VAULT_PATH")"
if [ ! -d "$VAULT_PARENT" ]; then
  echo "Error: parent directory does not exist: $VAULT_PARENT"
  exit 1
fi
VAULT_PATH="$(cd "$VAULT_PARENT" && pwd)/$VAULT_BASE"

# 3. Already a vault?
if [ -f "${VAULT_PATH}/.corpus-vault" ]; then
  echo "Error: vault already exists at ${VAULT_PATH}"
  echo "  Marker: ${VAULT_PATH}/.corpus-vault"
  echo "  Run \`export CORPUS_VAULT=${VAULT_PATH}\` to use it."
  exit 1
fi

# 4. Non-empty directory with no marker?
if [ -d "${VAULT_PATH}" ] && [ -n "$(ls -A "${VAULT_PATH}" 2>/dev/null)" ]; then
  echo "Error: directory not empty and not a corpus vault — pick a fresh path."
  echo "  Path: ${VAULT_PATH}"
  exit 1
fi

# 5. Happy path — scaffold
mkdir -p \
  "${VAULT_PATH}/raw" \
  "${VAULT_PATH}/wiki" \
  "${VAULT_PATH}/output" \
  "${VAULT_PATH}/.obsidian"

cp -R "${TEMPLATES_DIR}/." "${VAULT_PATH}/"

echo "Vault created: ${VAULT_PATH}"
echo "  export CORPUS_VAULT=${VAULT_PATH}"
echo "  Next: /ingest <source>  — drop a file into raw/ first."
```
