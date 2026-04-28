---
description: Run a structural + content-level lint pass over the wiki
---

Run the maintenance protocol on `wiki/`. Delegate to the **librarian** subagent (see `.claude/agents/librarian.md`).

Full protocol: `.claude/rules/09-maintenance-check.md`. Cover **both** scopes:

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
