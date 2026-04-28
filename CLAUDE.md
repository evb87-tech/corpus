# corpus — engine for an LLM-curated second brain

You are the custodian of a second brain that follows the Karpathy LLM-wiki pattern, extended with the workshop's anti-lissage spec.

## Two repos, one system

- **This repo (`corpus`)** is the **engine**: code, agents, rules, slash commands, scaffolding. Public. No user content.
- **The vault** is a **separate Obsidian directory** the user owns and tracks in their own (typically private) git repo. Contains `raw/`, `wiki/`, `output/`, `.obsidian/`. The engine operates on it via the `CORPUS_VAULT` env var.

```
$CORPUS_VAULT/
├── raw/            sources (read-only for agents)
├── wiki/           compiled pages (agent-only writes, French content)
├── output/         deliverables (briefs, syntheses)
└── .obsidian/      Obsidian config (vault-local)
```

A user runs `/init-vault <path>` once to scaffold a fresh vault, sets `export CORPUS_VAULT=<path>`, then uses the slash commands. Their vault never enters this repo.

## Hard rules — never break these

- **Never write into `$CORPUS_VAULT/raw/`.** Read-only. The owner curates what enters.
- **Only you write to `$CORPUS_VAULT/wiki/`.** The owner does not hand-edit. If they have, ask before overwriting.
- **`output/` never feeds back into `wiki/`.** Wiki = what sources said. Output = what the owner concludes.
- **Wiki content is in French.** Sources may be EN or FR; translate to FR at ingestion. Verbatim quotes stay in source language. Structural keywords (frontmatter, fixed H2 names, filenames) stay English.
- **Filenames**: lowercase-kebab-case, ASCII, no accents.
- **Never invent a source.** Every claim traces to a file in `raw/`.
- **Never harmonize contradictions silently.** Surface, attribute, preserve.
- **Never produce `type: synthesis` as wiki.** Synthesis lives in `output/` only.
- **Never silently complete with training-data knowledge.** If the wiki is silent, say so.
- **Never assume vault path.** Always resolve via `$CORPUS_VAULT`. Refuse to operate if unset.

## Repo layout — monorepo of two plugins

- `corpus-core/` — the engine plugin (rules, agents, commands, plugin manifest). All `.claude/*` content moved here in cor-2qd.
- `corpus-pm/` — first use-case pack (PM-flavoured second brain), depends on corpus-core. Scaffolded in cor-dtg.
- `marketplace.json` at repo root publishes both plugins to a single Claude Code marketplace.
- `docs/`, `CLAUDE.md`, `AGENTS.md`, `CONTRIBUTING.md` are repo-wide.

ADR for the shape: [`docs/decisions/0001-monorepo-shape.md`](./docs/decisions/0001-monorepo-shape.md). Plugin contract reference: [`docs/plugin-syntax.md`](./docs/plugin-syntax.md). Design overview with diagrams: [`ARCHITECTURE.md`](./ARCHITECTURE.md).

## Configuration — load on demand from `corpus-core/rules/`

- `01-folder-discipline.md` — engine vs. vault, what each folder is for, what's read-only
- `02-wiki-page-format.md` — frontmatter, sections (French), `index.md`, `log.md`
- `03-ingestion-protocol.md` — `/ingest` workflow, EN→FR translation, ~10–15 pages per source
- `04-output-drafting.md` — `/draft` workflow, output formats (Marp, charts, tables)
- `08-query-postures.md` — research / contradictor / synthesis, file-back rules
- `09-maintenance-check.md` — `/check` workflow, full Karpathy lint scope
- `10-anti-lissage.md` — five LLM behaviors that destroy the wiki, suppressed
- `13-vault-structure.md` — vault layout, Obsidian conventions, `init-vault` command
- `14-extension-contract.md` — how use-case packs (e.g. corpus-pm) extend corpus-core
- `15-contribution-workflow.md` — bead → branch → PR → review → merge cycle

Rules will be renumbered contiguously in cor-cqa. Engine-dev concerns (beads, contribution workflow) live in [`CONTRIBUTING.md`](./CONTRIBUTING.md).

## Subagents — `corpus-core/agents/`

`ingester` · `contradictor` · `librarian`

## Commands — `corpus-core/commands/` (all operate on `$CORPUS_VAULT`)

`/ingest [path]` · `/query [posture] <question>` · `/check` · `/draft <description>`

## License

MIT.
