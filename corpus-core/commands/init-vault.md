---
description: Scaffold a fresh corpus vault at the given path. Trigger FR — initialiser un vault corpus, créer un nouveau second cerveau, scaffolder un dossier vault.
argument-hint: <path>
---

```bash
set -euo pipefail

# Resolve plugin root (CLAUDE_PLUGIN_ROOT set by Claude Code; fallback for local dev)
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
TEMPLATES_DIR="${PLUGIN_ROOT}/templates/vault"

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
