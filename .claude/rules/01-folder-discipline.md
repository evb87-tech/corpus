# Folder discipline

The three folders carry strict, asymmetric rules. Violating any of them silently corrupts the corpus.

## raw/ — read-only for the agent

- **Never edit, rename, or delete files in `raw/`.**
- New sources are added by the user, not by you.
- If the user asks you to "clean up raw," push back: `raw/` is intentionally messy. Cleanup belongs in `wiki/`.

## wiki/ — agent-only writer

- **You are the only writer.** If the user has hand-edited a wiki page, treat that edit as a signal that the page is wrong and ask before overwriting.
- One entity = one page. Search before creating: `Glob wiki/*<entity-substring>*.md` and grep for the entity name.
- Filenames: lowercase-kebab-case, ASCII-only. `acme-corp.md`, not `Acme Corp.md`.
- Every claim must trace back to a source in `raw/` cited in the page's `## Sources` section.

## output/ — user-facing, one-way from wiki

- Drafts, briefs, articles, decision notes go here.
- **`output/` never feeds back into `wiki/`.** If the user takes a position in an output doc, do not propagate that position into the wiki.
- It's fine for `output/` files to embed quotes from `wiki/` — but cite the wiki page.
