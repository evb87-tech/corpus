# Contribution workflow

How work moves through this repo. Encoded as a rule so humans, agents, and subagents follow the same discipline.

## TL;DR

1. Find a bead with `bd ready`. Claim it with `bd update <id> --claim`.
2. Branch: `feat/<bead-id>-<short-slug>`.
3. Implement. One bead per branch. One branch per PR.
4. Open a PR. Title format: `<bead-id>: <title>`.
5. Diligent review. Read every file. Run every test. Fix or push back.
6. Squash-merge when the bar is met. Close the bead. `bd dolt push`.

For commands and definitions, see `11-beads.md`.

## Bead → branch → PR → review → merge

### 1. Pick a bead

Run `bd ready`. Pick a P0 or P1 if any are ready; otherwise the highest-priority unblocked work.

If no bead exists for the work you're about to do, **stop and create one first**. Drive-by fixes that don't trace to a bead lose the audit trail and bypass the review discipline. The exceptions section below lists when this rule bends.

### 2. Claim and branch

```bash
bd update <id> --claim
git checkout main && git pull
git checkout -b feat/<id>-<short-slug>
```

The slug is 2–4 words, kebab-case, taken from the bead title. Example: `feat/cor-bvz-contribution-workflow`.

### 3. Implement

One bead per branch. If you discover scope expansion mid-work:

- Trivial (a typo, a missed import) → fix in the same branch, mention in the PR body.
- Non-trivial (a separate concern, a new abstraction, a different layer) → file a new bead, finish the current one.

Do not bundle unrelated changes. Reviewers have a context window.

### 4. Open the PR

PR title: `<bead-id>: <bead title>`. Example: `cor-bvz: Author contribution workflow rule + CONTRIBUTING.md`.

PR body covers:

- **What changed** — bullet list of meaningful changes, not a file diff narration.
- **Why this approach** — the design call, especially what was rejected.
- **How tested** — commands run, fixtures used, what proves the change works.
- **Bead** — link to `bd show <id>` output or paste the acceptance criteria.

A PR that doesn't tell the reviewer how to verify is not ready for review.

### 5. Review with diligence

Review is not a rubber stamp. The reviewer's job:

- **Read every changed file.** Not just the diff. Adjacent code matters for context.
- **Run the tests locally.** `bun run ci` or the equivalent gate. Coverage below 85% fails.
- **Run the feature.** If the change is a command, invoke it on a fixture vault. If it's a rule, read it as an essay and check it for internal consistency with the other rules.
- **Check it against the bead's acceptance criteria.** Every criterion ticked, or explicitly deferred to a follow-up bead.
- **Fix small issues directly.** Typos, formatting, an obvious naming improvement — push the fix to the PR branch, mention it in the review.
- **Push back on judgment calls.** Architecture, naming choices, missing edge cases, weak tests — leave a comment, request changes, do not merge.

A merged PR with a known weakness is debt. The bar is "I would defend this commit to a future contributor reading the log." If you can't defend it, don't merge it.

### 6. Squash-merge

When the bar is met:

```bash
git checkout main
git pull
git merge --squash feat/<id>-<short-slug>
git commit -m "<id>: <title>

<one-paragraph summary of what shipped and why>
"
git push
git branch -d feat/<id>-<short-slug>

bd close <id>
bd dolt push
```

Squash-merge keeps `main` linear and one-bead-per-commit. Branch history (work-in-progress commits, rebase fixups) is noise; the squashed commit message is the durable artifact.

## Subagent dispatch

Agent-driven work uses subagents for execution. Match the tier to the task. The orchestrator is responsible for choosing the right model — under-dispatching wastes hours of review on weak output, over-dispatching wastes tokens on work a smaller model handles cleanly.

### Opus — hardest design and architecture

Use Opus when the failure mode is "we ship a wrong abstraction and pay for it for months":

- Spec authoring (extension contracts, anti-lissage rules, ADRs that lock major decisions)
- Cross-cutting reviews where the judgment call is whether two systems compose cleanly
- Restructuring the rule taxonomy or rewriting a load-bearing rule
- Resolving a contradiction between two sources during ingestion when both authors are domain experts

Opus is the right tier when you'd rather burn tokens than have to rewrite the result.

### Sonnet — judgment work

Use Sonnet for tasks that require taste, design choices, reading code in context, or producing prose for human readers:

- Implementing a feature with non-obvious design calls
- Code review on a PR (read diffs, run tests, push back on weakness)
- Authoring or revising routine rules and docs
- Writing wiki pages (when ingestion involves real synthesis of source content)
- Producing FR-language deliverables where audience-appropriate phrasing matters

Sonnet is the default. Reach for Opus when the cost of being wrong is high; reach for Haiku when the work is mechanical.

### Haiku — mechanical work

Use Haiku for tasks where the output shape is fully specified and the cost of error is low:

- Renaming files per a defined scheme
- Updating cross-references after a renumber
- Bulk frontmatter edits across wiki pages
- Generating fixture data from a template
- Running structural lint and reporting findings (no judgment, just facts)

When in doubt between two tiers, pick the larger one. The premium is small; the cost of a bad judgment call compounds.

### What the orchestrator does

The agent acting as tech lead:

1. Picks the bead, creates the branch.
2. Dispatches a subagent with a self-contained brief: bead text, acceptance criteria, file paths, what NOT to touch.
3. **Reviews the subagent's output diligently per section 5.** Reads diffs. Runs tests. Fixes small issues directly. Pushes back on judgment calls — does not merge weak work.
4. Opens the PR, runs review against itself if no human is in the loop, merges when the bar is met.

Rubber-stamping a subagent's output is the failure mode. The orchestrator's value is review discipline, not throughput.

## Exceptions

Three cases bend the bead-first rule:

### Bootstrap

When the repo is being set up or restructured wholesale, sometimes a single commit lands work that touches many concerns and predates the bead system being applied to those concerns. Mark the commit message clearly: `baseline: <what>`. Use sparingly — once the bead system is live, every change traces to a bead.

### Hot-fix

A production-affecting bug that the user is encountering right now does not wait for a bead. Fix it on `main` (or a hot-fix branch if the codebase has a release process), then file a retroactive bead capturing the fix and the test that catches the regression. Hot-fixes without retroactive beads accumulate into untracked debt.

### Trivial typo

A single-character fix in a comment or docstring does not need a bead. A renamed variable does. The line: if it changes behavior or affects how a future reader interprets the code, it needs a bead.

## Why this discipline

Three failure modes the workflow prevents:

1. **God commits.** A single commit that does five things is unreviewable. The squash-merge-per-bead pattern enforces small, focused units.
2. **Untracked work.** A change without a bead has no acceptance criteria. Future contributors can't tell what "done" meant. Audit trail vanishes.
3. **Rubber-stamp review.** Reviewing your own (or a subagent's) work is hard. Encoding "read every file, run every test, fix or push back" as a rule means the reviewer has to actively choose to skip steps, instead of skipping them by default.

The cost is overhead per change. The payoff is a repo where every commit can be traced to its motivating bead, every merged PR met an explicit bar, and a new contributor can read the log and understand the project's evolution.

## See also

- `11-beads.md` — beads commands, prefix, sync workflow
- `12-skill-routing.md` — which skill or command handles which intent
