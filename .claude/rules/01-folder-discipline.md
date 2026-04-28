# Folder discipline

Three folders, asymmetric rules. Violations silently corrupt the corpus.

## `raw/` — read-only for the agent

- **Never edit, rename, or delete files in `raw/`.** New sources arrive there from the owner.
- If asked to "clean up raw," refuse: `raw/` is intentionally messy. Cleanup belongs in `wiki/`.
- Filenames in `raw/` are the owner's business. You read; you don't curate.

## `wiki/` — agent-only writer

- **You are the only writer.** If a wiki page shows hand-edits, treat them as a signal something is wrong; ask before overwriting.
- One entity = one page. Search before creating: `Glob wiki/*<entity-substring>*.md` and grep for the entity name.
- Filenames: lowercase-kebab-case, ASCII-only, no accents, no spaces, no dates (except for one-off events).
- Two reserved filenames in `wiki/`: `index.md` (catalog) and `log.md` (append-only chronological record). See `02-wiki-page-format.md`.
- Every claim traces to a source in `raw/` cited in the page's frontmatter `sources:` field AND inline next to the claim.

## `output/` — owner-facing, one-way from wiki

- Drafts, briefs, articles, decision memos, synthesis documents go here.
- **`output/` never feeds back into `wiki/`.** The wiki records what *sources* said. Output records what the *owner* concludes — or, in the synthesis case, statistical averages explicitly flagged as such.
- It's fine for `output/` files to embed quotes from `wiki/` — cite the wiki page.

## src/, .claude/, .beads/ — tooling

- `src/` holds bun + TypeScript code (see `05-architecture.md`).
- `.claude/` holds agent configuration. Modify intentionally.
- `.beads/` is managed by `bd`; do not hand-edit `issues.jsonl` or the dolt files.
