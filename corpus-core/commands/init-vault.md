---
description: Scaffold a fresh corpus vault at the given path. Trigger FR — initialiser un vault corpus, créer un nouveau second cerveau, scaffolder un dossier vault.
argument-hint: <path>
---

```bash
set -euo pipefail
# Defensive glob behavior: empty matches return empty, never error.
shopt -u failglob 2>/dev/null || true
shopt -s nullglob 2>/dev/null || true

# 1. Argument validation FIRST — better UX than reporting an internal failure
#    when the user just typed `/init-vault` with no path.
if [ -z "${ARGUMENTS:-}" ]; then
  echo "Usage: /init-vault <path>"
  echo "Example: /init-vault ~/Documents/my-vault"
  exit 1
fi

# 2. Resolve the corpus-core plugin root + templates dir.
#
# Slash-command bodies execute via BashTool, which does NOT inherit
# CLAUDE_PLUGIN_ROOT from the slash-command harness. Search known install
# locations and validate each candidate by requiring a corpus-core plugin.json.
# This prevents picking up an unrelated `corpus-core/templates/vault` from a
# sibling repo or a stray subdirectory under cwd.
validate_corpus_core() {
  local root="$1"
  [ -d "$root/templates/vault" ] || return 1
  [ -f "$root/.claude-plugin/plugin.json" ] || return 1
  grep -q '"name"[[:space:]]*:[[:space:]]*"corpus-core"' "$root/.claude-plugin/plugin.json" || return 1
}

PLUGIN_ROOT=""

# 2a. Explicit env var (Claude Code sets this for hooks; rarely set in BashTool).
if [ -n "${CLAUDE_PLUGIN_ROOT:-}" ] && validate_corpus_core "$CLAUDE_PLUGIN_ROOT"; then
  PLUGIN_ROOT="$CLAUDE_PLUGIN_ROOT"
fi

# 2b. Marketplace cache, picking the LATEST version (sort -V).
if [ -z "$PLUGIN_ROOT" ]; then
  cache_matches=( "$HOME/.claude/plugins/cache/corpus/corpus-core"/*/templates/vault )
  if [ ${#cache_matches[@]} -gt 0 ]; then
    while IFS= read -r path; do
      candidate="$(cd "$path/../.." && pwd)"
      if validate_corpus_core "$candidate"; then
        PLUGIN_ROOT="$candidate"
        break
      fi
    done < <(printf '%s\n' "${cache_matches[@]}" | sort -V -r)
  fi
fi

# 2c. Marketplace clone (unversioned).
if [ -z "$PLUGIN_ROOT" ]; then
  candidate="$HOME/.claude/plugins/marketplaces/corpus/corpus-core"
  if validate_corpus_core "$candidate"; then
    PLUGIN_ROOT="$candidate"
  fi
fi

# 2d. Local dev: only when invoked from inside the corpus repo itself.
#     We REQUIRE the git root to validate as corpus-core, so we never pull
#     templates from an unrelated sibling project.
if [ -z "$PLUGIN_ROOT" ]; then
  git_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
  if [ -n "$git_root" ] && validate_corpus_core "$git_root/corpus-core"; then
    PLUGIN_ROOT="$git_root/corpus-core"
  fi
fi

if [ -z "$PLUGIN_ROOT" ]; then
  echo "Error: cannot locate the corpus-core plugin install."
  echo "  Searched (in order):"
  echo "    1. \$CLAUDE_PLUGIN_ROOT"
  echo "    2. ~/.claude/plugins/cache/corpus/corpus-core/<latest version>/"
  echo "    3. ~/.claude/plugins/marketplaces/corpus/corpus-core/"
  echo "    4. <git repo root>/corpus-core/  (only when run from the corpus repo)"
  echo "  Each candidate must contain templates/vault/ AND .claude-plugin/plugin.json"
  echo "  with \"name\": \"corpus-core\"."
  echo "  Fix: /plugin marketplace update corpus && /plugin install corpus-core@corpus"
  exit 1
fi

TEMPLATES_DIR="$PLUGIN_ROOT/templates/vault"

# 3. Resolve the vault path.
#
# We support `~` and `~/...` (substitute $HOME) and absolute/relative paths.
# We deliberately do NOT support `~user` — the literal string would otherwise
# be silently mangled by ${VAR/#~/$HOME}, producing a wrong path.
case "$ARGUMENTS" in
  "~"|"~/"*)
    VAULT_PATH="${HOME}${ARGUMENTS#\~}"
    ;;
  "~"*)
    echo "Error: ~user expansion is not supported. Use an absolute path or ~/ (your \$HOME)."
    exit 1
    ;;
  *)
    VAULT_PATH="$ARGUMENTS"
    ;;
esac
VAULT_PARENT="$(dirname "$VAULT_PATH")"
VAULT_BASE="$(basename "$VAULT_PATH")"
if [ ! -d "$VAULT_PARENT" ]; then
  echo "Error: parent directory does not exist: $VAULT_PARENT"
  exit 1
fi
VAULT_PATH="$(cd "$VAULT_PARENT" && pwd)/$VAULT_BASE"

# 4. Refuse if a vault already exists at the path.
if [ -f "${VAULT_PATH}/.corpus-vault" ]; then
  echo "Error: vault already exists at ${VAULT_PATH}"
  echo "  Marker: ${VAULT_PATH}/.corpus-vault"
  echo "  Run: export CORPUS_VAULT=${VAULT_PATH}"
  exit 1
fi

# 5. Refuse if the path exists and is non-empty (could be unrelated content,
#    or the rubble of a previous interrupted scaffold).
if [ -d "${VAULT_PATH}" ] && [ -n "$(ls -A "${VAULT_PATH}" 2>/dev/null)" ]; then
  echo "Error: directory not empty and not a corpus vault — pick a fresh path."
  echo "  Path: ${VAULT_PATH}"
  echo "  If a previous /init-vault was interrupted, remove the partial scaffold:"
  echo "    rm -rf '${VAULT_PATH}'"
  exit 1
fi

# 6. Atomic scaffold.
#    Stage in a sibling temp directory (same filesystem → mv is atomic) so
#    a ctrl-C never leaves a half-built vault at the target path.
STAGING="$(mktemp -d "${VAULT_PARENT}/.corpus-vault-staging-XXXXXX")"
trap 'rm -rf "$STAGING"' EXIT

mkdir -p \
  "$STAGING/raw" \
  "$STAGING/wiki" \
  "$STAGING/output" \
  "$STAGING/.obsidian"

cp -R "${TEMPLATES_DIR}/." "$STAGING/"

# If the target exists (created empty earlier or by a race), remove it first.
# rmdir only succeeds on empty dirs — protects against clobbering content.
if [ -d "$VAULT_PATH" ]; then
  rmdir "$VAULT_PATH" 2>/dev/null || {
    echo "Error: target became non-empty during scaffold: $VAULT_PATH"
    exit 1
  }
fi

mv "$STAGING" "$VAULT_PATH"
trap - EXIT

echo "Vault created: ${VAULT_PATH}"
echo "  export CORPUS_VAULT=${VAULT_PATH}"
echo "  Next: /ingest <source>  — drop a file into raw/ first."
```
