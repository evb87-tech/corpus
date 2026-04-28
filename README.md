# corpus

The **engine** for an LLM-curated second brain. Karpathy gist pattern, extended with an anti-lissage spec and an explicit `output/` layer for deliverables.

## Two repos, one system

This repo (`corpus`) is the engine: agent rules, slash commands, scaffolding, code. **It contains no user content.**

User content lives in a separate **vault** — an Obsidian directory the user owns and tracks in their own (typically private) git repo. One vault per user.

```
$CORPUS_VAULT/                  ← your directory, your repo
├── raw/            captured sources (you drop, never sort)
├── wiki/           compiled knowledge (agent writes, you read)
├── output/         your deliverables (briefs, notes, articles)
├── .obsidian/      Obsidian config
└── .corpus-vault   marker file
```

The engine reads `$CORPUS_VAULT` from the environment to find your vault.

## Quick start

```bash
# 1. Clone the engine
git clone https://github.com/evb87-tech/corpus.git
cd corpus
bun install

# 2. Scaffold a vault somewhere outside this repo
bun run init-vault ~/Documents/my-corpus-vault

# 3. Point the engine at it
export CORPUS_VAULT=~/Documents/my-corpus-vault

# 4. Track your vault separately (private repo recommended)
cd $CORPUS_VAULT
git init && git remote add origin <your-private-repo-url>
```

From here, use the agent slash commands inside the engine repo:

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
- `05-architecture.md` — bun + TS, screaming + clean architecture
- `06-testing-discipline.md` — TDD, ≥85% coverage, three test layers
- `07-typescript-conventions.md` — strict TS, naming, imports
- `08-query-postures.md` — research / contradictor / synthesis
- `09-maintenance-check.md` — `/check` lint, full Karpathy scope
- `10-anti-lissage.md` — five LLM behaviors that destroy the wiki
- `11-beads.md` — issue tracking (engine-only)
- `12-skill-routing.md` — gstack + corpus command routing
- `13-vault-structure.md` — vault layout, Obsidian conventions, `init-vault`

[`CLAUDE.md`](./CLAUDE.md) and [`AGENTS.md`](./AGENTS.md) are the slim manifests that point at those rules.

## Hard rules (excerpt)

- Wiki content is in **French**. Sources may be EN or FR (translate at ingestion). Frontmatter and section names stay English.
- Never modify `raw/`. Never write into `output/` from ingestion. Never write into `wiki/` from drafting.
- Never invent a source. Never silently complete with training-data knowledge. Never harmonize contradictions.
- Never produce `type: synthesis` as a wiki page. Synthesis goes to `output/`.

## Tooling

- **Runtime:** bun ≥ 1.1
- **Language:** TypeScript (strict)
- **Tests:** bun test, ≥85% coverage, TDD, unit / integration / e2e
- **Issue tracking:** [beads](https://github.com/dogmata-dev/beads) (prefix `cor-`)
- **License:** MIT — see [LICENSE](./LICENSE)

## Inspired by

[Karpathy's LLM-wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f). Extended by the workshop with: explicit `output/` layer, three query postures (research / contradictor / synthesis), anti-lissage spec.
