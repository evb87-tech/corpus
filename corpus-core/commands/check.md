---
description: Run a structural + content-level lint pass over the wiki
---

**Pre-flight:** verify `$CORPUS_VAULT` is set and `$CORPUS_VAULT/.corpus-vault` exists. If not, refuse and tell the owner to run `/init-vault <path>` then `export CORPUS_VAULT=<path>`. See `corpus-core/rules/13-vault-structure.md`.

Run the maintenance protocol on `$CORPUS_VAULT/wiki/`. Delegate to the **librarian** subagent (see `corpus-core/agents/librarian.md`).

Full protocol: `corpus-core/rules/09-maintenance-check.md`. Cover **both** scopes:

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
