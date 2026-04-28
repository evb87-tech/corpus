---
description: Run a structural + content-level lint pass over the wiki
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

Run the maintenance protocol on `$CORPUS_VAULT/wiki/`. Delegate to the **librarian** subagent (see `corpus-core/agents/librarian.md`).

Full protocol: `corpus-core/rules/06-maintenance-check.md`. Cover **both** scopes:

**Structural (mechanical):**
- broken `[[wikilinks]]`
- orphan pages (no incoming links)
- ultra-connected pages (> 20 incoming links)
- stale (`last_updated` > 6 months and no new source since)
- `wiki/index.md` out of sync
- frontmatter / section / filename violations

**Content-level (Karpathy's full lint scope):**
- important concepts lacking pages
- stale claims superseded by newer raw sources
- data gaps (high incoming-link count, thin body)
- suggested investigations (3–5 open questions the wiki can't answer well)

Append a one-line summary to `wiki/log.md`. **Read-only** otherwise — do NOT auto-fix. Report findings; the owner decides.
