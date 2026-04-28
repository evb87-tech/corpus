# 0001 — Monorepo for corpus-core + corpus-pm

**Date**: 2026-04-28
**Status**: ACCEPTED
**Bead**: cor-w53

## Decision

Ship corpus-core and corpus-pm as **two plugins in a single git repo** (this one: `evb87-tech/corpus`). Each plugin lives under its own subdirectory at the repo root:

```
corpus/
├── corpus-core/
│   ├── .claude-plugin/plugin.json
│   ├── commands/
│   ├── agents/
│   ├── skills/
│   └── rules/
├── corpus-pm/
│   ├── .claude-plugin/plugin.json     ← declares dependencies: ["corpus-core"]
│   ├── corpus-pack.yaml                ← extension manifest per rules/14
│   ├── commands/
│   ├── agents/
│   ├── skills/
│   └── templates/
├── docs/
├── CLAUDE.md
├── AGENTS.md
├── CONTRIBUTING.md
└── README.md
```

A single marketplace manifest publishes both plugins to the same Claude Code marketplace, satisfying the same-marketplace constraint discovered in cor-erd.

## Context

`corpus-erd` verified that the Claude Code plugin contract has a hard constraint: `dependencies` declared in plugin.json **must resolve within the same marketplace**, with no allowance for git URLs or local paths. Cross-marketplace resolution requires explicit allowlisting in the marketplace.json. Source: [Plugin dependencies](https://code.claude.com/docs/en/plugin-dependencies.md).

For corpus the design intent is: `claude plugin install corpus-pm` should auto-install corpus-core. That requires both to publish through the same marketplace. The repo shape decision is about **how we develop and version them**, not about what the user installs.

## Options considered

### A. Monorepo (CHOSEN)

One repo, two plugin subdirectories, one marketplace manifest, shared release process.

**Pros:**

- Cross-cutting changes (e.g. extending the extension contract in `corpus-core/rules/14-extension-contract.md` AND adopting it in `corpus-pm/corpus-pack.yaml`) land in a single PR. No coordination dance.
- Single CI configuration, single CHANGELOG, single beads tracker (`cor-` prefix already established).
- Simpler for first contributors: clone one repo, see both plugins side by side, learn the pattern by reading corpus-pm as the worked example of how to build against corpus-core.
- Single git history audits the co-evolution of the contract and its first consumer.

**Cons:**

- A future third-party pack author who wants to fork corpus-pm as a starting template drags the whole repo. Mitigated: we'll ship a `templates/pack-skeleton/` directory under corpus-core that scaffolds a fresh pack.

### B. Split repos

`evb87-tech/corpus-core` and `evb87-tech/corpus-pm`, each with its own plugin.json, deps, CI, beads, CHANGELOG.

**Pros:**

- Independent versioning. corpus-pm can ship 0.3.0 while corpus-core stays at 0.1.x.
- Cleaner forking story for future packs. `git clone evb87-tech/corpus-pm` is a real starting template.

**Cons:**

- Cross-cutting changes need two PRs and careful sequencing (land contract change in corpus-core, publish to marketplace, bump corpus-pm dep, land corpus-pm change). At v0 with one author, this is pure friction.
- Two beads trackers, two CI configs, two CHANGELOGs. Triples the meta-work for marginal gain.
- Doesn't actually help the user — install UX is identical.

## Why monorepo wins for v0

Three reasons:

1. **Velocity at v0 is paramount.** The audience is a small private community. Cross-cutting iteration speed matters more than independent versioning. We're going to change the extension contract many times before it stabilizes.
2. **The contract is unproven.** corpus-pm IS the test of `rules/14-extension-contract.md`. If the contract is wrong, both move together. Splitting them prematurely freezes a contract we haven't validated.
3. **Future split is cheap.** `git filter-branch` (or `git subtree split`) extracts a subdirectory's history into a new repo when corpus-pm's velocity diverges from corpus-core. We can re-evaluate at v1.

## Implications

Locks the layout for cor-2qd (plugin restructure):

- `src/` (current TS engine) is dropped per cor-7tf.
- `.claude/` content (rules, agents, commands) moves under `corpus-core/`.
- A new top-level `corpus-pm/` directory hosts the pack scaffold (cor-dtg).
- A `marketplace.json` at repo root publishes both plugins to a single Anthropic marketplace.

CI runs once, tests both. Beads stays at the repo root with prefix `cor-` covering both plugins.

## Revisiting

Re-evaluate this decision when:

- A second use-case pack (corpus-research, corpus-legal, etc.) needs independent release cadence from corpus-pm.
- A third-party adopts the extension contract and asks for a fork-friendly skeleton.
- The repo crosses ~50 contributors and per-plugin issue triage becomes unwieldy.

Until then: monorepo.
