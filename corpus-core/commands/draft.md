---
description: Draft an output document, pulling from the wiki. Trigger FR — rédiger un livrable, draft un document, produire un brief, générer une synthèse à partir du wiki.
argument-hint: <description of what to draft>
---

**Pre-flight:**

```bash
CORPUS_VAULT="${CORPUS_VAULT:-$CLAUDE_PLUGIN_OPTION_VAULT_PATH}"
if [ -z "$CORPUS_VAULT" ]; then
  echo "No vault configured. Set CORPUS_VAULT (local dev) or configure the vaultPath userConfig option in the installed plugin (exposed as CLAUDE_PLUGIN_OPTION_VAULT_PATH). Neither is set. Run /init-vault <path> to scaffold a fresh vault, then export the path." >&2
  exit 1
fi
```

Verify `$CORPUS_VAULT/.corpus-vault` exists. If not, refuse and tell the owner to run `/init-vault <path>`. See `corpus-core/rules/08-vault-structure.md`.

Draft the deliverable described in: $ARGUMENTS

Follow `corpus-core/rules/04-output-drafting.md`. All paths below are relative to `$CORPUS_VAULT`:

1. Identify the entities and questions the deliverable touches.
2. Read relevant pages from `wiki/`. Use `Glob $CORPUS_VAULT/wiki/*.md` and `Grep` to find them.
3. Write into `output/`. Filename: `output/YYYY-MM-DD-<slug>.md` for dated work, `output/<slug>.md` for evergreen.
4. Cite wiki pages using `[[wiki/entity-name]]`.
5. **If a fact you want to write isn't in the wiki, stop and ask the user** before pulling from training-data knowledge.
6. **Never write into `wiki/`.** The wiki records what sources said; output records what the user concludes.

When done, list:
- The output file path
- Wiki pages cited
- Any gaps you flagged for the user
