# Contributing to corpus

Thanks for the interest. This repo runs on a bead-driven workflow with diligent review. The full discipline lives in [`.claude/rules/15-contribution-workflow.md`](./.claude/rules/15-contribution-workflow.md). The short version:

## TL;DR

```bash
bd ready                                   # find a bead
bd update <id> --claim                     # claim it
git checkout -b feat/<id>-<slug>           # branch
# implement, test
git push -u origin feat/<id>-<slug>        # PR
# review diligently — read every file, run tests, fix or push back
git checkout main && git merge --squash feat/<id>-<slug> && git commit -m "<id>: <title>"
git push && bd close <id> && bd dolt push
```

## Three rules that matter most

1. **One bead per branch, one branch per PR.** No god commits. If the work doesn't trace to a bead, file one before you start.
2. **Diligent review, never rubber-stamp.** Whether the author is a human, an agent, or a subagent: read every file, run the tests, fix small issues directly, push back on judgment calls. A merged PR with a known weakness is debt.
3. **Squash-merge to keep `main` linear.** One commit per bead. Commit message is `<id>: <title>` followed by a paragraph on what shipped and why.

## Issue tracking

We use [beads](https://github.com/dogmata-dev/beads). Issue prefix: `cor`. Backend: dolt. Sync: `bd dolt push`.

Run `bd prime` after a fresh clone or session restart for the full command reference.

## Subagent dispatch

Agent-driven work uses subagents:

- **Sonnet** for judgment (rule authoring, feature implementation, code review)
- **Haiku** for mechanical tasks (renames, frontmatter edits, fixture generation)

The orchestrator's value is review discipline, not throughput.

## See also

- [`.claude/rules/15-contribution-workflow.md`](./.claude/rules/15-contribution-workflow.md) — full workflow spec
- [`.claude/rules/11-beads.md`](./.claude/rules/11-beads.md) — beads commands and session protocol
- [`CLAUDE.md`](./CLAUDE.md) — engine-wide rules and discipline
