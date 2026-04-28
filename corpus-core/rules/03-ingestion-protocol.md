# Ingestion protocol — `/ingest`

> All paths below are relative to `$CORPUS_VAULT`. Refuse to operate if unset or the vault marker is missing. See [13-vault-structure.md](./13-vault-structure.md).

When the owner runs `/ingest` (or asks to "ingest raw/X"):

## 1. Identify pending sources

List every file in `raw/` that does not appear in any wiki page's `sources:` frontmatter field. Those are the unprocessed sources.

If the user names a specific file, scope the run to that file only.

## 2. For each new source

a. **Read it in full.** PDFs: use `Read` with `pages:` for large files. Audio/video: refuse — the owner must transcribe first.

b. **Identify entities**: persons, concepts, companies, frameworks, theses, places, events. Pick a canonical name per entity (lowercase-kebab-case, ASCII-safe, no accents).

c. **For each entity**:
- If `wiki/<canonical-name>.md` exists → **update it**: append the source to frontmatter `sources:`, enrich the `## Ce que disent les sources` section, create or strengthen `## Connexions`, flag conflicts under `## Contradictions`. Bump `last_updated`.
- Else → **create a new page** using the template in `02-wiki-page-format.md`. French content, English structural keywords.

## 3. Sweep links

After processing all sources, walk the modified pages and verify every `[[...]]` link points to an existing page. Broken links go in the final report — do not auto-fix.

## 4. Update `wiki/index.md`

Reflect new pages and edited summaries. Group by type. One scannable line per page.

## 5. Append to `wiki/log.md`

```markdown
## [YYYY-MM-DD] ingest | <source filename>
Pages touched: [[a]], [[b]], [[c]]
Contradictions flagged: <list or "none">
```

## 6. Final report

Tell the owner, briefly:
- Files ingested
- Pages created (list)
- Pages modified (list)
- Contradictions detected (list)
- Broken links (list)
- Entities mentioned but deliberately skipped (trivial mentions)

## Calibration

Karpathy notes that **a single source might touch 10–15 wiki pages**. If your run touches only 1–2, you're probably under-extracting entities; sweep the source again. If it touches 30+, you're probably creating pages for trivial mentions; consolidate.

## Language

Sources in `raw/` may be in any language (typically EN or FR). **Wiki page bodies are always in French.** If the source is in English, translate at ingestion: paraphrased claims, summaries, and connections go into French prose. Two carve-outs:

- **Verbatim quotes stay in their original language**, between guillemets `« … »` for FR or `"…"` for EN, with an inline citation. Translating a quote silently is a form of lissage — see `10-anti-lissage.md`.
- **Owner-authored sources** (personal notes, takeaways, positions): preserve the owner's exact phrasing in its original language. Anti-lissage rule 4 overrides the French-content rule for owner voice.

Structural keywords (frontmatter fields, fixed H2 names, filenames) remain English regardless.

## Non-negotiables

- **Do not modify `raw/`.**
- **Do not write into `output/` during ingestion.**
- **Do not invent sources.** If you cannot trace a claim to a file in `raw/`, do not write it.
- **Surface contradictions; do not resolve them silently.** Both claims, both attributed.
- **Preserve the owner's voice verbatim** when ingesting owner-authored sources. See `09-anti-lissage.md`.
