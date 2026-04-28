---
description: Ingest a source from raw/ into the wiki
argument-hint: <path-to-raw-file>
---

Ingest the source at `$ARGUMENTS` into the wiki.

Follow the ingestion protocol in `.claude/rules/03-ingestion-protocol.md`:

1. Read the source from `raw/`.
2. Extract every distinct entity (person, org, concept, framework, thesis, place, event).
3. For each entity:
   - If `wiki/<entity>.md` exists → update it; bump `updated:` frontmatter; append to `## Sources`.
   - Else → create from the template in `.claude/rules/02-wiki-page-format.md`.
4. Cite the source file inline next to every claim, and in the `## Sources` section.
5. Add `[[wikilinks]]` to related entities (links to non-existent pages are fine).
6. Surface contradictions — don't silently overwrite.
7. **Do not modify `raw/`.** **Do not write into `output/`.**

Report back briefly:
- Pages created
- Pages updated
- Contradictions surfaced
- Entities mentioned but skipped
