# Architecture — bun + TypeScript, screaming + clean

## Stack

- Runtime: **bun** ≥ 1.1
- Language: **TypeScript** strict mode (see `tsconfig.base.json`)
- Test runner: **bun test** with coverage thresholds (see `06-testing-discipline.md`)
- Lint: **oxlint** (see `.oxlintrc.json`)
- Format: **prettier**

## Two architectural disciplines, layered

### 1. Screaming architecture — the file tree tells you what the system *does*

The top of `src/` reveals the **business intent**, not the framework:

```
src/
├── features/
│   ├── ingest/      ← raw/ → wiki/
│   ├── check/       ← wiki/ maintenance & lint
│   └── draft/       ← wiki/ → output/
├── shared/          ← cross-feature primitives
├── bin/             ← CLI entry points
└── main.ts          ← composition root (thin)
```

A new contributor reading `src/features/` should understand the *purpose* of corpus before reading any code. No `controllers/`, `services/`, `models/` at the top level — those are framework noise.

### 2. Clean architecture — inside each feature, dependencies point inward

```
features/<feature>/
├── domain/          ← entities, value objects, pure logic. NO IO. NO framework.
├── application/     ← use cases. Orchestrates domain via interfaces (ports).
└── infrastructure/  ← adapters: filesystem, git, parsers, network.
```

Dependency rule: **`domain` knows nothing. `application` depends on `domain` only. `infrastructure` depends on `application` and `domain`.** Never the reverse. Test this with imports — if `domain/` ever imports `node:fs` or anything from `infrastructure/`, the rule is broken.

`shared/` follows the same split: `shared/domain/` for cross-feature value objects, `shared/infrastructure/` for adapters used by multiple features.

## Path aliases

Defined in `tsconfig.json`:
- `@features/*` → `src/features/*`
- `@shared/*` → `src/shared/*`

Use aliases over relative `../../../` paths in everything except intra-folder imports.

## Composition root

`src/main.ts` and files under `src/bin/` are the **only** places allowed to instantiate concrete adapters and wire them into use cases. Domain and application code receives dependencies via constructors / function parameters — never via `new` of an infrastructure class.

## Scaling note

This wiki is designed for **~100 sources**. Past that threshold, Karpathy recommends switching from `wiki/index.md` lookup to **qmd** (Tobi Lütke's local hybrid BM25 + vector + LLM re-rank engine, available as an MCP server). Until then, the index is sufficient. Don't pre-build retrieval infrastructure you don't need.
