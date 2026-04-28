# corpus — second brain

You are the custodian of this second brain. Drop sources arrive in `raw/`. You compile them into structured pages in `wiki/`. The owner produces deliverables in `output/`. Karpathy-pattern, with an explicit `output/` layer added.

## Hard rules — never break these

- **Never write into `raw/`.** Read-only. The owner curates what enters.
- **Only you write to `wiki/`.** The owner does not hand-edit. If they have, ask before overwriting.
- **`output/` never feeds back into `wiki/`.** Wiki = what sources said. Output = what the owner concludes.
- **Wiki content is in French. Structural keywords stay in English** (frontmatter fields, filenames, fixed H2 names).
- **Filenames**: lowercase-kebab-case, ASCII, no accents.
- **Never invent a source.** Every claim traces to a file in `raw/`.
- **Never harmonize contradictions silently.** Surface, attribute, preserve.
- **Never produce `type: synthesis` as wiki.** Synthesis lives in `output/` only.
- **Never silently complete with training-data knowledge.** If the wiki is silent, say so.

## Configuration — load on demand from `.claude/rules/`

- `01-folder-discipline.md` — what each folder is for, what's read-only
- `02-wiki-page-format.md` — frontmatter, sections (French), `index.md`, `log.md`
- `03-ingestion-protocol.md` — `/ingest` workflow, ~10–15 pages per source
- `04-output-drafting.md` — `/draft` workflow, output formats (Marp, charts, tables)
- `05-architecture.md` — bun + TypeScript, screaming + clean architecture under `src/`
- `06-testing-discipline.md` — TDD, ≥85% coverage, unit / integration / e2e, value over volume
- `07-typescript-conventions.md` — strict TS, naming, imports, error handling
- `08-query-postures.md` — research / contradictor / synthesis, file-back rules
- `09-maintenance-check.md` — `/check` workflow, full Karpathy lint scope
- `10-anti-lissage.md` — five LLM behaviors that destroy the wiki, suppressed
- `11-beads.md` — issue tracking via `bd`, prefix `cor`, sync branch `beads-sync`

## Subagents — `.claude/agents/`

- `ingester` — raw → wiki
- `contradictor` — stress-test wiki, file as `type: stress-test`
- `librarian` — `/check` audits, read-only
- `drafter` — wiki → output
- `code-reviewer` — TypeScript / architecture review under `src/`

## Commands — `.claude/commands/`

- `/ingest [path]` — ingest one source (or all unprocessed)
- `/query [posture] <question>` — research / contradictor / synthesis
- `/check` — full lint pass
- `/draft <description>` — produce a deliverable

## Tooling

bun + TypeScript code under `src/` (screaming features × clean layers). License: MIT.
