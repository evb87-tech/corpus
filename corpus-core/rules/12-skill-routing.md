# Skill routing

When the user's request matches an available skill, invoke it via the Skill tool. When in doubt, invoke the skill.

## gstack skills

- Product ideas / brainstorming → `/office-hours`
- Strategy / scope → `/plan-ceo-review`
- Architecture → `/plan-eng-review`
- Design system / plan review → `/design-consultation` or `/plan-design-review`
- Full review pipeline → `/autoplan`
- Bugs / errors → `/investigate`
- QA / testing site behavior → `/qa` or `/qa-only`
- Code review / diff check → `/review`
- Visual polish → `/design-review`
- Ship / deploy / PR → `/ship` or `/land-and-deploy`
- Save progress → `/context-save`
- Resume context → `/context-restore`

## corpus-native commands

These are project-local, defined in `corpus-core/commands/`:

- `/ingest [path]` — ingest a raw source into the wiki
- `/query [posture] <question>` — research / contradictor / synthesis
- `/check` — full wiki lint pass (delegates to librarian)
- `/draft <description>` — produce a deliverable in `output/`

Corpus commands take precedence when the request is about the wiki itself. Use gstack skills for the engineering tooling around it (`src/`).
