# Vault structure

The **vault** is a separate Obsidian directory holding the user's second brain. The engine repo (`corpus`) does not contain a vault. Each user has their own.

## Required layout

```
$CORPUS_VAULT/
├── .corpus-vault          marker file (presence = "this is a corpus vault")
├── .obsidian/             Obsidian config
│   ├── app.json           (committed)
│   ├── core-plugins.json  (committed)
│   ├── community-plugins.json  (committed)
│   ├── hotkeys.json       (committed if non-machine-specific)
│   ├── workspace.json     (gitignored)
│   └── plugins/           (committed; community plugins)
├── .gitignore             vault-local, see template below
├── raw/
│   └── .gitkeep
├── wiki/
│   ├── index.md           catalog, agent-managed
│   ├── log.md             append-only chronological record
│   └── *.md               entity pages
├── output/
│   └── .gitkeep
└── README.md              optional owner intro
```

The `.corpus-vault` marker is a 0-byte sentinel written by `init-vault` so the engine can verify it's pointing at a real vault. Without it, all engine commands refuse to run.

## `init-vault` command

```bash
bun run init-vault ~/Documents/my-vault
```

Scaffolds the layout above:
- creates the directories
- writes `.corpus-vault` marker
- writes a starter `.gitignore` (see template below)
- writes empty `wiki/index.md` and `wiki/log.md` with the canonical headers
- writes a minimal `.obsidian/` (default theme, no community plugins; user customizes)
- writes a starter `README.md` explaining "this is a corpus vault"
- prints next steps: `export CORPUS_VAULT=~/Documents/my-vault` and `cd $CORPUS_VAULT && git init`

Idempotent: running it on an existing vault is a no-op (or asks before overwriting).

## Vault `.gitignore` template

```gitignore
# Obsidian — machine-specific
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.obsidian/cache

# OS
.DS_Store
.Trashed-*

# Editor swaps
*.swp
*.swo

# Drafts in progress (optional — comment out if you want to track them)
# output/.drafts/
```

Vaults do **not** gitignore `raw/`, `wiki/`, or `output/` — that would defeat the point. The vault repo's purpose is to track those.

## Obsidian conventions used by the spec

The wiki page format (see `02-wiki-page-format.md`) is Obsidian-native:

- `[[wikilinks]]` render as graph edges in Obsidian's graph view — `/check` orphan and ultra-connected detection lines up with what Obsidian shows visually.
- YAML frontmatter (`type`, `sources`, `last_updated`) is read by Obsidian's properties panel and indexable by Dataview.
- Fixed H2 sections (`Résumé`, `Ce que disent les sources`, `Connexions`, `Contradictions`, `Questions ouvertes`) work as a Templater template — owner can bind `Cmd+T` to insert a blank page skeleton.
- `wiki/index.md` is the human entry point in Obsidian; pin it as the homepage.

## Recommended community plugins

Not required, but the spec works well with:

- **Templater** — for the page skeleton template
- **Dataview** — to query the wiki by frontmatter (e.g. "all `type: thesis` pages updated in the last 30 days")
- **Tasks** — for vault-content TODOs (replaces engine-side beads for content work)
- **Periodic Notes** — if the owner uses daily notes alongside the wiki

The agent does not depend on any plugin. The vault must be readable as plain markdown by any tool.

## How agents reference the vault

All file paths in the agent rules are relative to `$CORPUS_VAULT`. When you read in any rule "wiki/index.md", interpret it as `$CORPUS_VAULT/wiki/index.md`. The agent must:

1. Resolve `$CORPUS_VAULT` from the environment.
2. Verify `$CORPUS_VAULT/.corpus-vault` exists.
3. Refuse to proceed otherwise. Tell the owner to run `bun run init-vault <path>` and `export CORPUS_VAULT=<path>`.

## Multiple vaults

Users may have multiple vaults (work, personal, research). They switch by exporting a different `CORPUS_VAULT`. The engine has no concept of "the active vault" beyond the env var — there's no global state.
