# AGENTS.md

Agent-agnostic instructions for any model working in this repository (Claude, GPT, Gemini, local models, etc.). For Claude-specific guidance, see [CLAUDE.md](./CLAUDE.md) — the rules below are the same in spirit.

## Repository purpose

`corpus` is a local, file-based **second brain**. Three folders carry the system:

- `raw/` — captured sources (read-only for agents)
- `wiki/` — compiled, structured knowledge (agents are the only writers)
- `output/` — user-facing deliverables (briefs, notes, articles)

The agent's role is to turn `raw/` into structured pages in `wiki/`, and to help the user produce `output/` artifacts that draw on `wiki/`.

## Hard rules

1. **Never modify `raw/`.** It is the inviolable source of truth.
2. **Only agents write to `wiki/`.** Do not let the user hand-edit it; if they ask, redirect them to `output/`.
3. **`output/` cannot feed back into `wiki/`.** The wiki records what sources said. Output records what the user concluded. Do not mix.
4. **One entity, one page.** Update existing pages; do not create duplicates.
5. **Cite every claim** in `wiki/` back to the originating file in `raw/`.
6. **Surface contradictions, do not resolve them silently.** Attribute conflicting claims to their respective sources.
7. **Markdown only.** Wikilinks in `[[kebab-case]]` form. Filenames lowercase-kebab-case.

## Workflow shapes

**Ingest a source:**
```
1. Read raw/<file>
2. Identify entities referenced
3. For each entity:
   - If wiki/<entity>.md exists → update
   - Else → create
4. Append source to the page's ## Sources section
5. Add [[wikilinks]] to related entities
```

**Draft an output:**
```
1. Read user's prompt
2. Pull relevant pages from wiki/
3. Write into output/<deliverable>.md
4. Flag wiki gaps; do NOT fill them from training-data knowledge
```

## Tooling

- Issue tracking: `bd` (beads), prefix `cor-`, sync branch `beads-sync`.
- Version control: git, remote `origin → github.com/evb87-tech/corpus`.
- License: MIT.

## What this project is NOT

- Not a software-engineering project. There is no application code.
- Not integrated with `dogmata` or any cloud service. The corpus is independent.
- Not a personal journal. The wiki is a faithful mirror of *sources*, not of the user's positions.

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
