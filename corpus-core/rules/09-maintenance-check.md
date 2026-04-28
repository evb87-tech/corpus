# Maintenance — `/check`

> All paths below are relative to `$CORPUS_VAULT`. Refuse to operate if unset or the vault marker is missing. See [13-vault-structure.md](./13-vault-structure.md).

When the owner runs `/check`, run a structural lint of the wiki.

## Steps

1. **List every page** in `wiki/`.
2. **Verify every `[[...]]` link** points to an existing page.
3. **List orphan pages** — no other page links to them.
4. **List ultra-connected pages** — more than 20 incoming links. These are often concepts too broad and worth splitting.
5. **Detect stale pages** — `last_updated` older than 6 months AND no new source added since. Candidates for review.
6. **Verify `wiki/index.md`** is in sync with the actual page list and reflects the current type taxonomy.
7. **Append to `wiki/log.md`**:
   ```
   ## [YYYY-MM-DD] lint | full pass
   Orphans: N  Broken links: N  Stale (>6m): N  Ultra-connected: N
   ```
8. **Produce a structured report** to the owner.

## What `/check` does NOT do

- **Does not auto-fix.** This is a read-only audit. The owner decides what to repair.
- **Does not delete pages.** Even orphan ones — orphans are signals, not garbage.
- **Does not rewrite old pages to match new rules.** When the rules change (new section, renamed type), old pages keep their old shape. Forced consistency is dishonest; the trace of past compilation eras is part of the record.

## Heuristic flags worth reporting

- Pages where the `## Contradictions` section was added but is empty — possibly missed conflicts.
- Pages whose `sources:` list contains only one entry — possibly under-corroborated.
- Pages where the H1 in the body doesn't match the filename slug.
- Pages with H2 sections outside the canonical set (`Résumé`, `Ce que disent les sources`, `Connexions`, `Contradictions`, `Questions ouvertes`).

Report these as warnings, not errors. The owner adjudicates.

## Karpathy's full lint scope

Beyond the structural checks above, the lint operation in Karpathy's gist also surfaces **content-level signals**:

- **Important concepts lacking pages** — concepts repeatedly referenced in `[[wikilinks]]` but never created. List the missing slugs and the pages that mention them.
- **Stale claims superseded by newer sources** — a fact stated in an old page that a more recent source in `raw/` would update or contradict, but no one re-ingested. Spot-check by reading frontmatter `last_updated` against the newest source files in `raw/`.
- **Data gaps** — entities mentioned across many pages but with thin coverage on their own page (high incoming-link count + thin body).
- **Suggested investigations** — at the end of the lint report, propose 3–5 questions the wiki currently cannot answer well, and the kind of source that would fill the gap. This is advisory, not action.

These content-level signals are the high-value part of `/check`. Structural checks pass or fail mechanically; the content suggestions are where the librarian actually earns its keep.
