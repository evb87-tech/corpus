# corpus

A Claude Code plugin for an LLM-curated second brain. You drop sources into a folder; Claude compiles them into a wiki you can query under three postures (research, contradictor, synthesis) and from which you draft deliverables. Karpathy's [LLM-wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) pattern, hardened with an anti-lissage spec and an explicit `output/` layer.

Wiki content is **French by default**, sources can be EN or FR (translated at ingestion). Built for francophone AI strategic thinkers; FR-first is a feature, not an accident.

## Shape: two plugins, one repo

This repo is a monorepo of two Claude Code plugins:

- **`corpus-core/`** — the engine. Rules, agents, slash commands, the anti-lissage spec. Use-case-agnostic.
- **`corpus-pm/`** — the first use-case pack: PM-flavoured second brain. Adds entity types, drafters, and prompts for product work. Depends on corpus-core (auto-installs as a marketplace dependency).

A single `marketplace.json` at the repo root publishes both. ADR for the shape: [`docs/decisions/0001-monorepo-shape.md`](./docs/decisions/0001-monorepo-shape.md). Plugin contract reference: [`docs/plugin-syntax.md`](./docs/plugin-syntax.md).

This repo contains **no user content**. The wiki and your sources live in a separate **vault** you own:

```
$CORPUS_VAULT/                  ← your directory, your private repo
├── raw/            captured sources (you drop, never sort)
├── wiki/           compiled knowledge (plugin writes, you read)
├── output/         your deliverables (briefs, notes, articles)
├── .obsidian/      Obsidian config
└── .corpus-vault   marker file
```

The plugin reads `$CORPUS_VAULT` from the environment to find your vault. One vault per user.

## Quick start

corpus ships as a Claude Code plugin. Once the marketplace is published (cor-NEW), install with:

```bash
claude plugin install corpus-core      # engine
claude plugin install corpus-pm        # PM use-case pack (auto-pulls corpus-core)
```

Until the marketplace is live, install from a local clone — see [docs/plugin-syntax.md](docs/plugin-syntax.md).

After install, scaffold a vault and point the plugin at it:

```bash
/init-vault ~/Documents/my-corpus-vault
export CORPUS_VAULT=~/Documents/my-corpus-vault
```

Then use the slash commands:

- `/ingest [path]` — read a source from `$CORPUS_VAULT/raw/`, compile entity pages in `$CORPUS_VAULT/wiki/`
- `/query [posture] <question>` — ask the wiki (research / contradictor / synthesis)
- `/check` — full lint pass over the wiki
- `/draft <description>` — produce a deliverable in `$CORPUS_VAULT/output/`

## Spec

The actual rules live in [`corpus-core/rules/`](corpus-core/rules/), loaded on demand:

- `01-folder-discipline.md` — engine vs. vault, what's read-only
- `02-wiki-page-format.md` — frontmatter, fixed sections, French content
- `03-ingestion-protocol.md` — `/ingest` workflow, EN→FR translation rule
- `04-output-drafting.md` — `/draft` workflow, output formats
- `08-query-postures.md` — research / contradictor / synthesis
- `09-maintenance-check.md` — `/check` lint, full Karpathy scope
- `10-anti-lissage.md` — five LLM behaviors that destroy the wiki
- `13-vault-structure.md` — vault layout, Obsidian conventions, `init-vault`
- `14-extension-contract.md` — how use-case packs extend corpus-core
- `15-contribution-workflow.md` — bead → branch → PR → review → merge

Rules will be renumbered contiguously in cor-cqa.

[`CLAUDE.md`](./CLAUDE.md) and [`AGENTS.md`](./AGENTS.md) are the slim manifests that point at those rules.

## Hard rules (excerpt)

- Wiki content is in **French**. Sources may be EN or FR (translate at ingestion). Frontmatter and section names stay English.
- Never modify `raw/`. Never write into `output/` from ingestion. Never write into `wiki/` from drafting.
- Never invent a source. Never silently complete with training-data knowledge. Never harmonize contradictions.
- Never produce `type: synthesis` as a wiki page. Synthesis goes to `output/`.

## Tooling

- **Runtime:** Claude Code (plugin format). No bun, no TypeScript, no build — corpus is prompts, rules, and slash commands.
- **Issue tracking:** [beads](https://github.com/dogmata-dev/beads) (prefix `cor-`). See [`CONTRIBUTING.md`](./CONTRIBUTING.md).
- **License:** MIT — see [LICENSE](./LICENSE).

## Inspired by

[Karpathy's LLM-wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f). Extended with: explicit `output/` layer, three query postures (research / contradictor / synthesis), anti-lissage spec.
