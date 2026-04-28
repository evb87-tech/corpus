# Testing discipline

Coverage is a side effect of good tests. The goal is **catching regressions on behavior the owner cares about**, not hitting a number.

## Mandatory bars

- **≥85%** line, function, statement coverage. Enforced in `bunfig.toml`. CI fails below.
- **TDD by default** for `domain/` and `application/`: red → green → refactor. Write the failing test first.
- **Three layers**, all required:
  - **Unit** — colocated `*.test.ts` next to the file they test. Fast, isolated, no IO.
  - **Integration** — under `__integration__/` per feature. Real adapters, real filesystem in tmpdirs, no network.
  - **End-to-end** — under `__e2e__/` per feature. Full CLI invocation against a fixture corpus.

## Layout

```
src/features/ingest/
├── domain/
│   ├── entity.ts
│   └── entity.test.ts            ← unit, TDD, NO IO
├── application/
│   ├── ingest-source.ts
│   └── ingest-source.test.ts     ← unit with fakes for ports
├── infrastructure/
│   ├── filesystem-source-reader.ts
│   └── filesystem-source-reader.test.ts  ← unit on the adapter
├── __integration__/
│   └── ingest-source.integration.test.ts  ← real fs in tmpdir
└── __e2e__/
    └── ingest-cli.e2e.test.ts             ← spawn the bin
```

## What makes a high-value test

A test earns its keep when it:

1. **Names a behavior, not a function.** `it("flags a contradiction when two sources disagree")`, not `it("calls detectConflict")`.
2. **Fails for one reason.** If a test breaks, the failure message points at the regression. Tests that assert ten things are five tests.
3. **Tests through the public surface** of the unit under test. Don't reach into private state to verify internals.
4. **Survives refactors.** If renaming a method or restructuring a class breaks the test without changing observable behavior, the test was coupled to implementation, not contract.
5. **Has a counter-example.** For every "happy path" test, write at least one test that proves the negative — what the code rejects, refuses, or errors on.

## What is NOT a high-value test

- Tests that exercise getters, setters, or constructors that hold no logic.
- Tests that mock the unit under test itself.
- Tests that mirror the implementation 1:1 (snapshot of internal calls).
- Tests that pass because they never assert (`expect(thing).toBeDefined()` on a mandatory return).
- Tests that exist purely to push the coverage number up.

If a test would be deleted with no loss when reading the test suite as documentation, do not write it.

## Fakes over mocks

Prefer **hand-rolled fakes** (in-memory implementations of the same port) over mocking libraries. A fake is reusable across tests, exercises the contract, and forces the port to stay small. Reach for `mock.module` only at adapter-test boundaries.

## Test data

- Domain tests use **builder functions** (`makeEntity({ overrides })`) over inline literals. Builders live next to the entity.
- Integration tests use **tmpdirs** (`fs.mkdtempSync`). Never write into `raw/`, `wiki/`, or `output/` from a test — those are sacred.
- E2E tests use a **fixture corpus** under `__fixtures__/<scenario>/` with its own `raw/`, `wiki/`, `output/`. Copied into a tmpdir per run.

## TDD rhythm for domain & application

1. Write the test that expresses the behavior. Run it. **It must fail for the right reason** (not a typo).
2. Write the smallest code that makes it pass.
3. Refactor under the green bar.
4. Move to the next behavior.

Skipping step 1 is not allowed in `domain/` and `application/`. Infrastructure adapters may be test-after when the third-party API shape is the source of truth.

## Property-based testing

Use **property-based tests** (`fast-check` or equivalent) where invariants are easy to state: parser round-trips, idempotence of operations, ordering invariants in `wiki/index.md`. One property test replaces dozens of example tests.

## CI gate

`bun run ci` runs format check → lint → typecheck → test with coverage. All four must pass. Coverage below 85% fails the run.

## When coverage is gamed

If a PR raises coverage by adding low-value tests (snapshots of internal state, getter tests, mock-call assertions), reject the PR. The bar is **value**, with coverage as a secondary signal.
