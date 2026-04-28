# Output drafting

When the user asks for a brief, note, article, decision memo, meeting prep, etc.:

## Always write into `output/`

Never `wiki/`. Even if the user says "add this to the wiki," push back: positions and conclusions belong in `output/`. The wiki is for what *sources* said.

## Pull from `wiki/` first

1. Identify the entities the deliverable touches.
2. Read their wiki pages.
3. Cite wiki pages in the output doc: `[[wiki/entity-name]]`.

## Flag wiki gaps

If you find yourself wanting to write a fact that isn't supported by any wiki page, **stop**. Tell the user: "I want to claim X, but no wiki page supports it. Should I (a) leave it out, (b) ask you to drop a source into raw/ for ingestion, or (c) cite my training-data knowledge with a `[unverified]` tag?"

Do not silently pull from your training data into a deliverable.

## Output filename convention

`output/YYYY-MM-DD-<slug>.md` for dated deliverables. `output/<slug>.md` for evergreen ones.

## What output is for

- Briefs the user will share with a client or team
- Decision memos that capture *the user's* judgment
- Article drafts where the user is the author
- Meeting prep where the user is the attendee

The user owns `output/`. You are a co-author here, not a sole writer.
