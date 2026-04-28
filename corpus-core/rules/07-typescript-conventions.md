# TypeScript conventions

## Strictness — already in `tsconfig.base.json`

`strict`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `noImplicitOverride`, `noFallthroughCasesInSwitch`, `verbatimModuleSyntax`, `isolatedModules`. Do not weaken these.

## Imports

- **Type-only imports**: use `import type` everywhere a value is not needed. `verbatimModuleSyntax` enforces it.
- **Path aliases** (`@features/*`, `@shared/*`) for cross-folder imports. Relative paths only within a folder.
- **No barrel files** (`index.ts` re-exporting everything) at the feature level — they hide cycles and bloat bundles. One barrel per layer at most, only if it has a clear purpose.

## Naming

- Files: `kebab-case.ts`. Test files: `kebab-case.test.ts`.
- Types and classes: `PascalCase`.
- Functions, variables: `camelCase`.
- Constants (true module-level immutables): `SCREAMING_SNAKE_CASE`.
- Avoid `I` prefix on interfaces (`UserRepository`, not `IUserRepository`).

## Domain code rules

- **No `any`.** No `as` casts that erase real type information. Use `unknown` and narrow.
- **No throwing for control flow.** Domain returns `Result<T, E>` types or discriminated unions for expected failures. Throw only on bugs (invariant violations).
- **Pure functions where possible.** A domain function that touches `Date.now()` or `Math.random()` is impure — inject a clock / RNG port.
- **No `node:*` imports in `domain/`.** Catches IO leaks at review time.

## Application code rules

- Use cases are **functions or classes whose dependencies are passed in** (constructor for classes, parameters for functions). No singletons, no module-level state.
- One use case per file. The filename matches the use case name (`ingest-source.ts` → `ingestSource(...)`).

## Infrastructure code rules

- Adapters are **the only place** allowed to import `node:fs`, `bun:`, network clients, parser libraries, etc.
- Each adapter implements a port (interface) defined in the feature's `application/` or `domain/`.
- Errors from third-party APIs are caught and translated into the feature's domain error types — never leaked upward as raw library exceptions.

## Lint — oxlint

Run `bun run lint`. Fix with `bun run lint:fix` for auto-fixable rules.

## Formatting — prettier

Run `bun run format`. CI runs `format:check`. Don't commit unformatted code.
