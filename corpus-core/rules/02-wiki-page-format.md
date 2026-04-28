# Wiki page format

> All paths below are relative to `$CORPUS_VAULT`. The engine refuses to operate if the env var is unset or the vault marker (`$CORPUS_VAULT/.corpus-vault`) is missing. See [08-vault-structure.md](./08-vault-structure.md).

Every page in `wiki/` follows this exact format. Deviations break querying and re-ingestion.

## Page template

```markdown
---
type: person | concept | company | framework | thesis | case-study | reference | stress-test
sources: [list of files from raw/ that contributed]
last_updated: YYYY-MM-DD
---

# Nom de l'entité

## Résumé
2 à 4 phrases qui définissent l'entité de manière discriminante.

## Ce que disent les sources
Points structurés par source. Chaque affirmation doit être traçable à une source précise.

## Connexions
- [[autre-page-1]] : nature du lien
- [[autre-page-2]] : nature du lien

## Contradictions
Si deux sources se contredisent, le conflit est listé ici explicitement.

## Questions ouvertes
Ce que les sources laissent sans réponse.
```

## Language rule

- **Wiki page content is in French.**
- **Structural keywords stay in English**: frontmatter field names (`type`, `sources`, `last_updated`), section names (`## Résumé`, etc. — wait, those are French; the H1 and frontmatter remain English), filenames.
- The H2 section names listed above (`Résumé`, `Ce que disent les sources`, `Connexions`, `Contradictions`, `Questions ouvertes`) are French and **fixed** — do not translate or rename them.
- Frontmatter field names (`type`, `sources`, `last_updated`) are English and fixed.

## Type taxonomy

- `person`, `concept`, `company`, `framework`, `thesis`, `case-study` — created by ingestion.
- `reference` — created by **research** queries that produce a reusable lookup (table, taxonomy). See `07-query-postures.md`.
- `stress-test` — created by **contradictor** queries. Strengthens the wiki by surfacing weaknesses.
- **Never create `type: synthesis` pages.** Synthesis goes to `output/` only. See `09-anti-lissage.md`.

## Reserved files

`wiki/index.md` and `wiki/log.md` are **not entity pages**. They carry no `type:`, no `sources:`, no `last_updated:` frontmatter, and `/check` skips them when validating the type taxonomy and frontmatter requirements. Their content rules are below.

### `wiki/index.md`

Content-oriented catalog of every wiki page, grouped by type. Updated on every ingest. One line per page: link, one-line summary, optional source count.

```markdown
# Wiki Index

## Persons
- [[andrej-karpathy]] : chercheur, à l'origine du pattern LLM wiki (5 sources)

## Concepts
- [[llm-wiki]] : pattern pour bases de connaissances personnelles via LLM (8 sources)

## References (from research queries)
- [[pkm-tools-comparison-2026]] : tableau comparatif des approches PKM mentionnées

## Stress-tests (from contradictor queries)
- [[llm-wiki-weaknesses]] : pages où le pattern est confronté à des contre-arguments
```

### `wiki/log.md`

Append-only chronological record. Each entry starts with `## [YYYY-MM-DD] <op> | <title>` so it parses with `grep "^## \[" wiki/log.md`.

```markdown
## [2026-04-20] ingest | karpathy-gist-llm-wiki.md
Pages touched: [[andrej-karpathy]], [[llm-wiki]], [[rag-limitations]]
Contradictions flagged: none

## [2026-04-20] query | Comment ce pattern se compare-t-il à NotebookLM ?
Pages consulted: [[llm-wiki]], [[notebooklm]]
Answer filed as: [[notebooklm-vs-llm-wiki-comparison]]

## [2026-04-21] lint | full pass
Orphans: 2  Broken links: 0  Stale (>6m): 1
```

## Hard rules

- **Frontmatter is required.** `type`, `sources`, `last_updated` minimum.
- **`last_updated` must be bumped on every edit.**
- **Wikilinks** to other wiki pages: `[[entity-name]]`. To raw sources: `[[raw/filename]]`.
- **Never delete a source citation** even if the claim is later overwritten — append, don't erase.
- **Quote the owner's voice verbatim** when sources in `raw/` are authored by the owner. See `09-anti-lissage.md`.
