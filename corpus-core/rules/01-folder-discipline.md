# Folder discipline

Two repos, asymmetric rules.

## Engine repo (this directory)

The engine is **code, spec, agents, scaffolding**. It does NOT contain user content.

```
corpus/                         ← this repo
├── src/                        bun + TS code (init-vault, ingest, query, check, draft logic)
├── .claude/                    agent rules, agents, commands
│   ├── rules/
│   ├── agents/
│   └── commands/
├── .beads/                     issue tracker (engine bugs only)
├── CLAUDE.md / AGENTS.md       slim manifests
├── package.json + configs      bun, ts, oxlint, prettier
└── LICENSE / README.md
```

- **Never put user content (raw sources, compiled wiki pages, output drafts) in the engine repo.** That belongs in the vault.
- `.beads/` tracks engine work (`cor-1`, `cor-2`, ...). Vault-content TODOs do not go here — use Obsidian Tasks or a `vault/TODO.md`.
- `.claude/` is the agent configuration. Modify intentionally.

## Vault (separate directory, separate git repo)

The vault is **the user's second brain**. One per user. Tracked in the user's own (typically private) repo.

```
$CORPUS_VAULT/                  ← user's directory, NOT inside the engine repo
├── raw/                        captured sources (read-only for agents)
├── wiki/                       compiled pages (agent-only writes, French content)
├── output/                     deliverables (briefs, notes, syntheses)
├── .obsidian/                  Obsidian config (vault-local)
├── .gitignore                  vault-specific
└── README.md                   optional, owner's intro to their vault
```

The engine reads `$CORPUS_VAULT` from the environment. Refuse to operate if unset or pointing at a directory missing the vault marker (`wiki/index.md` plus a `.corpus-vault` sentinel file written by `init-vault`).

### `raw/` — read-only for the agent

- **Never edit, rename, or delete files in `raw/`.** New sources arrive there from the owner.
- If asked to "clean up raw," refuse: `raw/` is intentionally messy. Cleanup belongs in `wiki/`.
- Filenames in `raw/` are the owner's business. You read; you don't curate.

### `wiki/` — agent-only writer

- **You are the only writer.** If a wiki page shows hand-edits, treat them as a signal something is wrong; ask before overwriting.
- One entity = one page. Search before creating: `Glob $CORPUS_VAULT/wiki/*<entity-substring>*.md` and grep for the entity name.
- Filenames: lowercase-kebab-case, ASCII-only, no accents, no spaces, no dates (except for one-off events).
- Two reserved filenames: `wiki/index.md` (catalog) and `wiki/log.md` (append-only chronological record). See `02-wiki-page-format.md`.
- Every claim traces to a source in `raw/` cited in the page's frontmatter `sources:` field AND inline next to the claim.

### `output/` — owner-facing, one-way from wiki

- Drafts, briefs, articles, decision memos, synthesis documents go here.
- **`output/` never feeds back into `wiki/`.** The wiki records what *sources* said. Output records what the *owner* concludes — or, in the synthesis case, statistical averages explicitly flagged as such.
- It's fine for `output/` files to embed quotes from `wiki/` — cite the wiki page.

### `.obsidian/` — Obsidian config

- The vault is an Obsidian vault. `.obsidian/` holds themes, hotkeys, community plugins.
- Selective tracking: commit `community-plugins.json`, `app.json`, `core-plugins.json`. Gitignore `workspace.json`, `workspace-mobile.json` (machine-specific). See `08-vault-structure.md`.

## Mental model

The engine is **infrastructure**. The vault is **content**. Each is versioned in its own git history. Updating the engine never touches a vault; populating a vault never touches the engine. This separation is what lets the engine evolve as open-source while every user's vault stays private and theirs.
