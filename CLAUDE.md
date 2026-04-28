# corpus — second brain

A local, file-based knowledge system. Three folders, one rule each. The agent (you) is the compiler that turns captured sources into a structured wiki.

Inspired by Karpathy's gist (raw → wiki → schema). This project adds an explicit **output/** layer that Karpathy mentions only in passing.

## Architecture

```
corpus/
├── CLAUDE.md      ← these instructions
├── AGENTS.md      ← agent-agnostic version of the same rules
├── raw/           ← user drops sources here. Sloppy by design.
├── wiki/          ← you (the agent) write here. One markdown page per entity.
└── output/        ← user produces deliverables here (briefs, notes, articles).
```

## The three folders

### `raw/` — the dump

The user's inbox. Articles, PDFs, podcast transcripts, meeting notes, OCR'd handwriting. **Nothing is sorted, tagged, or carefully named.** It is intentionally messy. The user rarely re-reads `raw/` directly.

You read from `raw/` to ingest. You never write back into it.

### `wiki/` — the compiled brain

The real second brain. **You are the only writer.** One markdown page per entity (person, company, concept, framework, thesis, case study). Pages link to each other with `[[entity-name]]` syntax (Obsidian-style).

The user does not hand-edit `wiki/`. If they did, the wiki would stop being a faithful mirror of what was actually read.

Key invariants:
- One entity = one page. If a new source mentions an existing entity, **update** the page, don't create a new one.
- Every claim cites its source by linking back to the originating file in `raw/`.
- Contradictions between sources are **surfaced**, not silently resolved. Note both, attribute both.
- Filenames are lowercase-kebab-case, ASCII-safe, no spaces.

### `output/` — the user's deliverables

Briefs, decision notes, article drafts, meeting prep. The user writes here, possibly with your help, drawing on `wiki/`.

**Hard rule: `wiki/` feeds `output/`. `output/` never pollutes `wiki/`.**

If the user takes a position in an output document, that position does not flow back into the wiki — the wiki is a record of what *sources said*, not what the user *concluded*. Mixing the two corrupts the corpus.

## Your job as the agent

When the user asks you to **ingest** (e.g. "process raw/foo.pdf"):

1. Read the source from `raw/`.
2. For each entity referenced (person, org, concept, etc.), find or create a page in `wiki/`.
3. Update the page with what this source adds. Cite the source file path.
4. If the source contradicts an existing claim, record the contradiction inline — don't overwrite.
5. Add `[[wikilinks]]` to related entities. If a linked page does not exist yet, that's fine — leave the link, the page will appear when that entity is next ingested.
6. **Never modify `raw/`.** Treat it as read-only.

When the user asks you to **draft** something (a brief, a note):

1. Write into `output/`, never into `wiki/`.
2. Pull from `wiki/` as primary context. Cite wiki pages.
3. If you find a gap in the wiki while drafting, flag it to the user — don't fill it from your own knowledge.

## Conventions

- **Markdown only.** No proprietary formats. The corpus must remain portable across editors and agents.
- **Wikilinks** use `[[kebab-case-name]]`. Display text optional: `[[kebab-case-name|Display Name]]`.
- **Source citations** in wiki pages: append a `## Sources` section listing the `raw/` files that contributed, with one-line summaries of what each added.
- **Filenames** in `wiki/` and `output/` are lowercase-kebab-case.

## Why this setup

1. **Capture and compilation are different cognitive acts.** `raw/` is for fast, judgment-free dumping. `wiki/` is for structured, rule-driven compilation. Merging them forces the agent to do both at once and risks corrupting stable pages on every re-ingest.
2. **Markdown + git = portability and reversibility.** Every ingestion can be a commit. Every agent change is reviewable. Drift is detectable. No platform lock-in.
3. **The output/wiki separation prevents the wiki from drifting from "what sources said" toward "what the user thinks."** This separation is what makes the corpus useful as a long-lived reference rather than a personal opinion log.

## Issue tracking

This repo uses [beads](https://github.com/dogmata-dev/beads) for issue tracking with prefix `cor-`. Use `bd create`, `bd list`, `bd show <id>` for backlog management. Beads syncs via the `beads-sync` git branch.


<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:ca08a54f -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

## Session Completion

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd dolt push
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
<!-- END BEADS INTEGRATION -->
