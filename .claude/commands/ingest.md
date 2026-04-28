---
description: Ingest a source from raw/ into the wiki (delegates to the ingester subagent)
argument-hint: [path-to-raw-file or empty for "all unprocessed"]
---

Run the ingestion protocol on: $ARGUMENTS

If $ARGUMENTS is empty, ingest every file in `raw/` whose path does not appear in any wiki page's `sources:` frontmatter field.

Delegate to the **ingester** subagent (see `.claude/agents/ingester.md`).

The full protocol is in `.claude/rules/03-ingestion-protocol.md`. Hard constraints:

- French content in wiki pages, English structural keywords.
- One entity = one page. Update existing pages; do not duplicate.
- Cite every source in frontmatter `sources:` AND inline.
- Surface contradictions; do not resolve silently.
- Update `wiki/index.md` and append to `wiki/log.md`.
- **Never modify `raw/`. Never write into `output/`.**
- Anti-lissage: see `.claude/rules/10-anti-lissage.md`.

When done, report: files ingested, pages created, pages modified, contradictions detected, broken `[[links]]`, entities skipped.
