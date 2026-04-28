# Wiki page format

Every page in `wiki/` follows this shape. Deviations make the corpus harder to query and re-ingest.

## Template

```markdown
---
type: person | org | concept | framework | thesis | case-study | event | place
aliases: [Alt Name 1, Alt Name 2]
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# <Display name>

One-paragraph summary of the entity, written in the agent's voice, citing the strongest source.

## Key facts

- **Field:** value [source: [[raw/2026-04-12-some-article]]]
- **Field:** value [source: [[raw/2026-04-15-podcast-transcript]]]

## Relations

- See also: [[other-entity]], [[another-entity]]
- Part of: [[parent-concept]]

## Notes

Free-form prose. When sources disagree, surface the disagreement:

> Source A claims X. Source B claims Y. Both are recorded; the user has not adjudicated.

## Sources

- `raw/2026-04-12-some-article.md` — first introduction of this entity; primary on background.
- `raw/2026-04-15-podcast-transcript.md` — adds the X/Y contradiction.
```

## Rules

- **Frontmatter is required.** `type`, `created`, `updated` minimum.
- **`updated` must be bumped on every edit.**
- **Source citations** appear inline (after each claim) AND in the `## Sources` list.
- **Never delete a source citation** even if the claim is later overwritten — append, don't erase.
- **Wikilinks** to other wiki pages: `[[entity-name]]`. Wikilinks to raw sources: `[[raw/filename]]`.
- **Do not include the user's opinions.** If a source quotes the user, that's fine; but the wiki records what *was said*, not what the user *concluded*.
