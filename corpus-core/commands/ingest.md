---
description: Ingest a source from $CORPUS_VAULT/raw into the vault's wiki (delegates to the ingester subagent)
argument-hint: [path-to-raw-file or empty for "all unprocessed"]
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

Run the ingestion protocol on: $ARGUMENTS

If $ARGUMENTS is empty, ingest every file in `$CORPUS_VAULT/raw/` whose path does not appear in any wiki page's `sources:` frontmatter field. If $ARGUMENTS is a relative path, resolve it under `$CORPUS_VAULT/raw/`.

Delegate to the **ingester** subagent (see `corpus-core/agents/ingester.md`).

The full protocol is in `corpus-core/rules/03-ingestion-protocol.md`. Hard constraints:

- All paths below are relative to `$CORPUS_VAULT`.
- French content in wiki pages, English structural keywords. Sources may be EN or FR (translate at ingestion).
- One entity = one page. Update existing pages; do not duplicate.
- Cite every source in frontmatter `sources:` AND inline.
- Surface contradictions; do not resolve silently.
- Update `wiki/index.md` and append to `wiki/log.md`.
- **Never modify `raw/`. Never write into `output/`.**
- Anti-lissage: see `corpus-core/rules/07-anti-lissage.md`.

When done, report: files ingested, pages created, pages modified, contradictions detected, broken `[[links]]`, entities skipped.
