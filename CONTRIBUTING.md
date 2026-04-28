# Contributing to corpus

Thanks for the interest. This repo runs on a bead-driven workflow with diligent review. The full discipline lives in [`corpus-core/rules/10-contribution-workflow.md`](./corpus-core/rules/10-contribution-workflow.md). The short version:

## TL;DR

```bash
bd ready                                            # find a bead
bd update <id> --claim                              # claim it
git checkout -b feat/<id>-<slug>                    # branch
# implement, test
git push -u origin feat/<id>-<slug>                 # push
gh pr create --title "<id>: <title>" --body "..."   # PR
# review diligently — read every file, run tests, fix or push back
gh pr merge <N> --squash --delete-branch \
  --subject "<id>: <title>" --body "<why>"          # merge via GitHub
git checkout main && git pull
bd close <id> && bd dolt push
```

**Always merge through `gh pr merge --squash`, never `git merge --squash` locally.** Local merge lands the change but leaves the PR in "Closed" state instead of "Merged" — the commit ↔ PR link is lost and the audit trail breaks.

## Three rules that matter most

1. **One bead per branch, one branch per PR.** No god commits. If the work doesn't trace to a bead, file one before you start.
2. **Diligent review, never rubber-stamp.** Whether the author is a human, an agent, or a subagent: read every file, run the tests, fix small issues directly, push back on judgment calls. A merged PR with a known weakness is debt.
3. **Squash-merge to keep `main` linear.** One commit per bead. Commit message is `<id>: <title>` followed by a paragraph on what shipped and why.

## Issue tracking — beads

This repo tracks all work in [beads](https://github.com/dogmata-dev/beads). Issue prefix: `cor`. Backend: dolt (embedded). Sync remote: `origin`. Sync branch: `beads-sync`.

### Quick reference

```bash
bd ready                # find available work (no blockers)
bd list                 # list all open issues
bd show <id>            # view issue details + dependencies
bd create -t "title"    # create a new issue
bd update <id> --claim  # claim work
bd close <id>           # complete work
bd prime                # full command reference + session protocol
```

### Rules

- Use `bd` for **all** task tracking on this repo. Do not use markdown TODO lists or `TodoWrite` for cross-session work.
- Use `bd remember "<insight>" --key <key>` for persistent project knowledge instead of standalone memory files.
- File a bead **before** you start coding. If the work doesn't trace to a bead, file one first.
- When ending a session: ensure beads is exported and pushed (`bd dolt push`).

### Session-end protocol

1. File issues for any remaining work discovered.
2. Update issue status: close finished, update in-progress.
3. Push:
   ```bash
   git pull --rebase
   bd dolt push
   git push
   ```
4. Verify `git status` is clean and "up to date with origin."

If `bd dolt push` fails because the remote has no branches yet, it'll succeed after the first `git push`.

## Subagent dispatch

Agent-driven work uses subagents. Match the tier to the task:

- **Opus** for the hardest design and architecture (spec authoring, ADRs, cross-cutting reviews)
- **Sonnet** for judgment (feature implementation, code review, routine rule authoring) — default
- **Haiku** for mechanical work (renames, cross-ref updates, frontmatter edits, fixture generation)

When in doubt between two tiers, pick the larger one. The orchestrator's value is review discipline, not throughput.

## See also

- [`corpus-core/rules/10-contribution-workflow.md`](./corpus-core/rules/10-contribution-workflow.md) — full workflow spec
- [`CLAUDE.md`](./CLAUDE.md) — engine-wide rules and discipline
