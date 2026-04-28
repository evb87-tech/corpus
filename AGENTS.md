# AGENTS.md

Agent-agnostic instructions. For Claude-specific guidance, see [CLAUDE.md](./CLAUDE.md). The rules below are equivalent — only the loading convention differs (this file is read by Codex, Gemini CLI, Aider, OpenCode, etc.).

## Project

`corpus` is a local file-based **second brain**. Three folders carry the system, plus `output/` which the workshop adds to Karpathy's pattern:

- `raw/` — captured sources (read-only for agents)
- `wiki/` — compiled, structured knowledge (agents are the only writers)
- `output/` — owner-facing deliverables (briefs, notes, syntheses)
- `src/` — bun + TypeScript tooling (screaming + clean architecture)

## Hard rules

1. Never modify `raw/`. The owner curates what enters.
2. Only agents write to `wiki/`. The owner does not hand-edit.
3. `output/` never feeds back into `wiki/`.
4. Wiki content is in **French**; structural keywords (frontmatter fields, filenames, fixed H2 names) in **English**.
5. One entity, one page in `wiki/`. Update; do not duplicate.
6. Cite every claim back to a file in `raw/`.
7. Surface contradictions; never harmonize silently.
8. Never invent a source. Never complete with training-data knowledge unless the owner explicitly asks.
9. Never produce `type: synthesis` as a wiki page. Synthesis goes to `output/` only.

## Where the spec lives

All detail is in modular files loaded on demand:

- `.claude/rules/01-folder-discipline.md` ... `11-beads.md`
- `.claude/agents/<name>.md` (subagent definitions, also readable by other agents as role specs)
- `.claude/commands/<name>.md` (slash commands: `/ingest`, `/query`, `/check`, `/draft`)

## Tooling

- Runtime: bun ≥ 1.1
- Language: TypeScript (strict)
- Tests: bun test, ≥85% coverage, TDD, three layers (unit / integration / e2e)
- Issue tracking: `bd` (beads), prefix `cor`, sync branch `beads-sync`
- License: MIT
- Remote: `github.com/evb87-tech/corpus`

## What this project is NOT

- Not a software-engineering project at heart — it's a knowledge system. The TS code in `src/` exists to automate ingestion / linting / drafting around the corpus.
- Not integrated with `dogmata` or any cloud service. Independent.
- Not a personal journal. The wiki mirrors *sources*, not the owner's positions.
