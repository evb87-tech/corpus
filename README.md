# corpus

A local, file-based second brain. Drop sources into `raw/`, let an AI agent compile them into a structured `wiki/`, produce deliverables in `output/`.

```
corpus/
├── CLAUDE.md   — instructions for Claude Code
├── AGENTS.md   — instructions for any agent
├── raw/        — captured sources (you drop, never sort)
├── wiki/       — compiled knowledge (agent writes, you read)
└── output/     — your deliverables (briefs, notes, articles)
```

Inspired by [Karpathy's gist](https://gist.github.com/karpathy) on raw → wiki → schema, with an explicit `output/` layer added.

## Usage

1. Drop a source (PDF, article, transcript) into `raw/`.
2. Ask the agent: *"Ingest raw/foo.pdf into the wiki."*
3. The agent reads the source and updates `wiki/` — one markdown page per entity, linked with `[[wikilinks]]`.
4. When you need to produce something, ask the agent to draft into `output/` using `wiki/` as context.

## Conventions

- Markdown only. Wikilinks: `[[kebab-case-name]]`.
- One entity = one page. Sources cited at the bottom of each wiki page.
- Contradictions between sources are surfaced, not silently resolved.
- `wiki/` ↔ `output/` is one-way: wiki feeds output, output never writes back.

## Tooling

- **Issue tracking:** [beads](https://github.com/dogmata-dev/beads) (prefix `cor-`), syncs via the `beads-sync` git branch.
- **License:** MIT.

## License

MIT — see [LICENSE](./LICENSE).
