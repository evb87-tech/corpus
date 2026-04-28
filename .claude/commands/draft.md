---
description: Draft an output document, pulling from the wiki
argument-hint: <description of what to draft>
---

Draft the deliverable described in: $ARGUMENTS

Follow `.claude/rules/04-output-drafting.md`:

1. Identify the entities and questions the deliverable touches.
2. Read relevant pages from `wiki/`. Use `Glob wiki/*.md` and `Grep` to find them.
3. Write into `output/`. Filename: `output/YYYY-MM-DD-<slug>.md` for dated work, `output/<slug>.md` for evergreen.
4. Cite wiki pages using `[[wiki/entity-name]]`.
5. **If a fact you want to write isn't in the wiki, stop and ask the user** before pulling from training-data knowledge.
6. **Never write into `wiki/`.** The wiki records what sources said; output records what the user concludes.

When done, list:
- The output file path
- Wiki pages cited
- Any gaps you flagged for the user
