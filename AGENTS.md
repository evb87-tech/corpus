# AGENTS.md

Agent-agnostic instructions. For Claude-specific guidance, see [CLAUDE.md](./CLAUDE.md). The rules below are equivalent — only the loading convention differs (this file is read by Codex, Gemini CLI, Aider, OpenCode, etc.).

## Two repos, one system

- **This repo (`corpus`)** is the **engine**: code, agents, rules, slash commands, scaffolding. Public. No user content.
- **The vault** is a separate **Obsidian directory** the user owns and tracks in their own (typically private) git repo. Contains `raw/`, `wiki/`, `output/`, `.obsidian/`. The engine operates on it via the `CORPUS_VAULT` env var.

```
$CORPUS_VAULT/
├── raw/            sources (read-only for agents)
├── wiki/           compiled pages (agent-only writes, French content)
├── output/         deliverables (briefs, notes, syntheses)
└── .obsidian/      Obsidian config
```

A user runs `/init-vault <path>` once to scaffold a fresh vault, sets `export CORPUS_VAULT=<path>`, then uses the slash commands. Their vault never enters this repo.

## Hard rules

1. Never modify `$CORPUS_VAULT/raw/`. The owner curates what enters.
2. Only agents write to `$CORPUS_VAULT/wiki/`. The owner does not hand-edit.
3. `output/` never feeds back into `wiki/`.
4. Wiki content is in **French**; sources may be EN or FR (translate at ingestion). Structural keywords (frontmatter fields, filenames, fixed H2 names) stay in **English**.
5. One entity, one page in `wiki/`. Update; do not duplicate.
6. Cite every claim back to a file in `raw/`.
7. Surface contradictions; never harmonize silently.
8. Never invent a source. Never complete with training-data knowledge unless the owner explicitly asks.
9. Never produce `type: synthesis` as a wiki page. Synthesis goes to `output/` only.
10. Never assume the vault path. Resolve via `$CORPUS_VAULT`. Refuse to operate if unset.

## Repo layout — monorepo of two plugins

- `corpus-core/` — the engine plugin (rules, agents, commands, plugin manifest)
- `corpus-pm/` — first use-case pack, depends on corpus-core
- `marketplace.json` at repo root publishes both
- Repo-wide docs at `docs/`, `CLAUDE.md`, `AGENTS.md`, `CONTRIBUTING.md`

ADR for the shape: [`docs/decisions/0001-monorepo-shape.md`](./docs/decisions/0001-monorepo-shape.md). Plugin contract reference: [`docs/plugin-syntax.md`](./docs/plugin-syntax.md). Design overview with diagrams: [`ARCHITECTURE.md`](./ARCHITECTURE.md).

## Where the spec lives

All detail is in modular files loaded on demand:

- `corpus-core/rules/01-folder-discipline.md` ... `10-contribution-workflow.md`
- `corpus-core/agents/<name>.md` (subagent definitions, also readable by other agents as role specs)
- `corpus-core/commands/<name>.md` (slash commands: `/ingest`, `/query`, `/check`, `/draft`)

## Tooling

- Issue tracking: `bd` (beads, engine-only), prefix `cor`, sync branch `beads-sync`. See [`CONTRIBUTING.md`](./CONTRIBUTING.md).
- License: MIT
- Remote: `github.com/evb87-tech/corpus`

## What this project is NOT

- Not a software-engineering project. It's a Claude Code plugin: prompts, rules, agents, slash commands. No runtime code, no test suite, no build.
- Not integrated with `dogmata` or any cloud service. Independent.
- Not a vault. Not a wiki. Vaults live elsewhere, one per user.
- Not a personal journal. The wiki mirrors *sources*, not the owner's positions.
