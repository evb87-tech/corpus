# Ingestion protocol

When the user says "ingest raw/X" or "process raw/X":

## 1. Read the source

Use the Read tool. If it's a PDF, use the `pages` argument for large files. If it's audio/video, the user must transcribe first — don't pretend to ingest binary you can't read.

## 2. Extract entities

List every distinct entity referenced: people, organizations, concepts, frameworks, theses, places, events. For each, pick a canonical name (kebab-case, lowercase, ASCII).

## 3. For each entity

```
exists = Glob wiki/<canonical-name>.md
if exists:
    read it
    update relevant sections, bump frontmatter `updated`, append to ## Sources
else:
    create new page from template
```

## 4. Cite

Every fact must cite the originating raw file, inline and in `## Sources`.

## 5. Surface contradictions

If the new source contradicts an existing claim, do not overwrite. Add a parallel claim, attribute both, and flag in the `## Notes` section.

## 6. Wikilink generously

Mention of another entity → `[[that-entity]]`. The wiki becomes useful through linkage. It's fine for a link to point to a not-yet-existing page; that page will appear when the entity is next ingested.

## 7. Report back

Tell the user, briefly:
- New pages created: list them
- Existing pages updated: list them
- Contradictions surfaced: list them
- Entities mentioned but not given pages (deliberately, e.g. trivial mentions): list them

Do **not** modify the source file in `raw/`. Do **not** write into `output/` during ingestion.
