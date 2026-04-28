# Output drafting

> All paths below are relative to `$CORPUS_VAULT`. Refuse to operate if unset or the vault marker is missing. See [13-vault-structure.md](./13-vault-structure.md).

When the owner asks for a brief, decision memo, article draft, meeting prep, or **synthesis**:

## Always write into `output/`

Never `wiki/`. Even if the owner says "add this to the wiki," push back: positions and conclusions belong in `output/`. The wiki is for what *sources* said.

## Pull from `wiki/` first

1. Read `wiki/index.md` to identify relevant pages.
2. Read those pages and adjacent ones if needed.
3. Cite wiki pages: `[[wiki/entity-name]]`.

## Flag wiki gaps

If you want to write a fact that no wiki page supports, **stop**. Tell the owner:
- (a) leave it out,
- (b) ask the owner to drop a source into `raw/` for ingestion,
- (c) cite training-data knowledge with an explicit `[unverified]` tag.

Never silently pull from training data into a deliverable.

## Filename convention

- `output/YYYY-MM-DD-<slug>.md` for dated work.
- `output/<slug>.md` for evergreen.

## Output formats

Karpathy explicitly supports a wider set of output formats beyond plain prose. All live in `output/`:

- **Markdown prose** — briefs, decision memos.
- **Comparison tables** — markdown tables aggregating across wiki pages (often produced by *research* posture; can be filed back as `type: reference` if the table is reusable).
- **Marp slide decks** — markdown with Marp directives. Filename `output/<slug>.marp.md`.
- **Charts** — generated via a script (e.g. `scripts/chart-<topic>.ts`) that emits a PNG/SVG to `output/<slug>.png`. The script lives in `scripts/`, the output in `output/`.
- **Canvas / mind-map** — Obsidian `.canvas` JSON files if the owner uses Obsidian.

The format choice belongs to the owner. Suggest one if the request is ambiguous; never silently switch formats.

## Synthesis is special

If the owner asks for a synthesis (an averaged view across multiple sources):
- Produce it in `output/`.
- **Flag it explicitly** at the top: `> Note: this is a statistical average across sources, not the owner's singular position.`
- **Never file it back as a wiki page.** Synthesis erases singular angles. See `09-anti-lissage.md`.

## When done

Report:
- Output file path
- Wiki pages cited
- Gaps flagged
- For synthesis output: confirm it is NOT being filed back into `wiki/`.
