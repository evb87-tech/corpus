# Extension contract — how use-case packs extend corpus-core

`corpus-core` ships the wiki convention and the core verbs (`/init-vault`, `/ingest`, `/query`, `/check`, `/draft`). Use-case packs like `corpus-pm` extend the spec with new entity types, new review angles, and new ways to spawn structured beads issues — without forking corpus-core.

This rule defines the four contracts every pack must follow. A pack that respects them will work alongside any future pack and survive corpus-core upgrades within the same major version.

## Pack-as-plugin

Every pack is a Claude Code plugin in its own right. It declares its dependency on corpus-core in `.claude-plugin/plugin.json`:

```json
{
  "name": "corpus-pm",
  "version": "0.1.0",
  "dependencies": ["corpus-core"]
}
```

Installing the pack triggers corpus-core auto-install. Users see a single command: `claude plugin install corpus-pm`.

## 1. The pack manifest — `corpus-pack.yaml`

Every pack ships a `corpus-pack.yaml` at its plugin root (`${CLAUDE_PLUGIN_ROOT}/corpus-pack.yaml`). This is corpus-core's view of the pack — separate from `plugin.json`, which is Claude Code's view.

```yaml
name: corpus-pm
extends: corpus-core
core-version: ^0.1                # semver range; pack breaks if core's major changes

entity-types:
  - name: persona
    template: templates/persona.md
    sections: [Profil, Motivations, Frictions, Verbatims, Sources]
    extra-frontmatter: [pains, goals]
  - name: competitor
    template: templates/competitor.md
    sections: [Positionnement, Forces, Faiblesses, Last observed, Sources]
    extra-frontmatter: [last-observed]

review-angles:
  - name: strategy
    command: /pm-review-strategy
    agent: pm-strategist
    target-types: [prd, roadmap]
  - name: user
    command: /pm-review-user
    agent: pm-user-advocate
    target-types: [prd]

beads-handoffs:
  - name: pm-epic
    command: /pm-epic
    agent: pm-decomposer
    input-type: prd
    output-shape: epic-with-children
```

corpus-core's `/check` and `/ingest` read the merged registry across all installed packs at runtime.

## 2. Entity type extensions

A pack adds new values to the `type:` taxonomy in wiki frontmatter. corpus-core's base taxonomy is fixed: `person | concept | company | framework | thesis | case-study | reference | stress-test`. Packs append to it.

**Required for each new type:**

- A unique `name` (lowercase-kebab-case, must not collide with another pack or the core taxonomy).
- A page template under `${CLAUDE_PLUGIN_ROOT}/templates/<type>.md`. The template is the canonical skeleton the ingester writes when first creating a page of this type. Same shape as `02-wiki-page-format.md` (English frontmatter, French H2 sections, fixed section order).
- The fixed H2 section list. Cannot be a subset of corpus-core's universal sections (Résumé, Ce que disent les sources, Connexions, Contradictions, Questions ouvertes) — those are inherited and always present. Pack sections are added.
- Optional `extra-frontmatter` keys (lowercase-kebab-case). corpus-core's librarian validates that pages of this type carry these keys.

**What a pack cannot do:**

- Rename or reorder corpus-core's universal H2 sections.
- Override the language rule (wiki body in French, structural keywords in English).
- Bypass anti-lissage. Every rule in `07-anti-lissage.md` applies to pack-introduced pages identically.
- Override frontmatter requirements (`type`, `sources`, `last_updated` are mandatory regardless of pack).

## 3. Review angle extensions

A pack registers a review command that follows corpus-core's review primitive: **read a draft from `output/`, cite wiki pages, surface critiques, file findings as a wiki page with `type: stress-test`**.

**Required for each angle:**

- `name` (slug, used in `corpus-pack.yaml` and in the filed stress-test page's frontmatter).
- `command` slash entry (`commands/<name>.md`).
- `agent` subagent file (`agents/<agent-name>.md`). Reviews always run in a subagent — context isolation matters here.
- `target-types`: which output formats the angle applies to (`prd`, `roadmap`, `decision-memo`, etc.). corpus-core uses this to surface relevant angles when the owner has a draft open.

**Contract every review command must satisfy:**

1. Refuse if `$CORPUS_VAULT` is unset (standard pre-flight).
2. Read the draft from `output/`.
3. Read `wiki/index.md` and identified pages.
4. Cite every claim with `[[wiki-page]]`.
5. File findings as a wiki page with `type: stress-test` and frontmatter `review-angle: <name>` so `/check` can group them.
6. Append to `wiki/log.md` per `05-query-postures.md`.

**What review commands cannot do:**

- Modify the draft. Reviews are read-only on `output/`.
- Pull from training-data knowledge. If the wiki is silent, say so.
- File output as anything other than `type: stress-test`. Synthesis-style averaging across angles belongs in `output/` and is the orchestrator's job (e.g. `/pm-autoplan`).

## 4. Beads handoff extensions

A pack registers a command that turns an `output/` document into structured beads issues. corpus-core does not own beads logic; it documents the contract every handoff must respect.

**Required for each handoff:**

- `name` (slug).
- `command` slash entry.
- `agent` subagent (haiku-tier is fine; this work is mechanical).
- `input-type`: which output format the handoff consumes.
- `output-shape`: one of:
  - `single-issue` — one `bd create` per invocation.
  - `epic-with-children` — one epic, N children with dependencies.
  - `flat-batch` — N independent issues.

**Contract every handoff agent must satisfy:**

1. Read the input doc; refuse if format does not match `input-type`.
2. Use `bd create --validate` (or `bd config set validation.on-create warn` first). Every issue must carry `--description`, `--acceptance`, and where relevant `--design`.
3. Append a back-reference footer to every created issue: `Source: [[<input-doc-slug>]]`. Human readers must be able to trace from beads to the document that spawned them.
4. For `epic-with-children`: create the epic first, capture its ID, add children with `bd dep add <child> <epic>`.
5. Refuse to invent acceptance criteria not in the source. If the source is incomplete, return early with a list of gaps; do not paper over.
6. Output a final report listing every issue created, with `bd show <id>` URLs.

**What handoffs cannot do:**

- Modify the source document.
- Close existing issues.
- Re-open closed issues without explicit owner instruction.
- Skip `--validate`. The whole point is structured artifacts.

## 5. Pack discovery

corpus-core's `/check`, `/ingest`, and `/draft` need to know what entity types and contracts are valid. They discover installed packs at runtime.

**Discovery protocol:**

1. corpus-core enumerates plugins in the Claude Code plugins directory (path TBD per `cor-erd` verification — likely `${CLAUDE_PLUGINS_DIR}` or `~/.claude/plugins/`).
2. For each plugin, check if `<plugin-root>/corpus-pack.yaml` exists.
3. If yes, parse it. Verify `extends: corpus-core` and `core-version` matches the running corpus-core's major version (semver).
4. Merge the entity-types, review-angles, and beads-handoffs into the runtime registry.
5. On collision (two packs declare the same `entity-type` name), refuse to load the second one and surface the conflict to the owner. Pack authors are responsible for naming their types uniquely (consider a prefix: `pm:persona` if collisions become common).

**Performance note:** discovery runs once per command invocation. The merged registry fits in memory; no caching layer needed at v0 scale.

## 6. Versioning

corpus-core follows semver. Packs declare a `core-version` range in `corpus-pack.yaml`.

- **Patch bumps** (0.1.0 → 0.1.1): bug fixes, no contract changes. All packs continue to work.
- **Minor bumps** (0.1.x → 0.2.0): new contract surface added; existing surface unchanged. Packs with `core-version: ^0.1` continue to work.
- **Major bumps** (0.x → 1.0): breaking contract changes. Packs must update `core-version` and may need to migrate their manifest.

Pre-1.0, treat minor bumps as potentially breaking. Pin with `core-version: ~0.1` if you need stability across minor versions.

## 7. Worked example — corpus-pm in full

```yaml
# corpus-pm/corpus-pack.yaml
name: corpus-pm
extends: corpus-core
core-version: ^0.1

entity-types:
  - name: persona
    template: templates/persona.md
    sections: [Profil, Motivations, Frictions, Verbatims, Sources]
    extra-frontmatter: [pains, goals]
  - name: segment
    template: templates/segment.md
    sections: [Définition, Critères, Taille estimée, Personas associés, Sources]
  - name: competitor
    template: templates/competitor.md
    sections: [Positionnement, Forces, Faiblesses, Last observed, Sources]
    extra-frontmatter: [last-observed]
  - name: interview
    template: templates/interview.md
    sections: [Date, Profil interviewé, Verbatims, Insights, Sources]
    extra-frontmatter: [interview-date]
  - name: feature
    template: templates/feature.md
    sections: [Problème, Hypothèse de solution, Personas concernés, Décisions liées, Sources]
  - name: decision
    template: templates/decision.md
    sections: [Date, Question, Décision, Alternatives écartées, Personnes impliquées, Sources]
    extra-frontmatter: [decision-date]

review-angles:
  - name: strategy
    command: /pm-review-strategy
    agent: pm-strategist
    target-types: [prd, roadmap]
  - name: user
    command: /pm-review-user
    agent: pm-user-advocate
    target-types: [prd]
  - name: feasibility
    command: /pm-review-feasibility
    agent: null  # main thread
    target-types: [prd]

beads-handoffs:
  - name: pm-epic
    command: /pm-epic
    agent: pm-decomposer
    input-type: prd
    output-shape: epic-with-children
```

A reader of this manifest plus the four contract sections above can build a corpus pack from scratch, with corpus-core untouched. That is the test of whether the contract is real.

## What this rule does NOT cover

- Pack-contributed slash commands that are NOT review or beads handoff (e.g. `/pm-spec`, `/pm-brainstorm`). These are ordinary Claude Code commands; they live in the pack's `commands/` and follow no special corpus contract beyond writing into `output/` and respecting anti-lissage when reading wiki.
- Pack-contributed agents beyond the review/decomposer roles. Standard Claude Code subagents; the pack ships them in `agents/` and references them from its commands.
- Pack-contributed skills. Standard Claude Code skills under the pack's `skills/`. Reference inline from commands per the Anthropic plugin pattern.
- Cross-pack dependencies. v0 assumes packs depend only on corpus-core, not on each other. If `corpus-research` and `corpus-pm` both want a shared `persona` type, that's a pack-design problem — solved later by promoting common types into a `corpus-shared` pack or into corpus-core itself.
