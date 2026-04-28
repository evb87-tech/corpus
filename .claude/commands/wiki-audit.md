---
description: Audit the wiki for broken links, missing sources, and convention drift
---

Run a structural audit of `wiki/`:

1. **Orphan wikilinks** — `[[targets]]` that don't resolve to a file in `wiki/`. List them with the page that references them.
2. **Missing frontmatter** — pages without `type`, `created`, or `updated` fields.
3. **Stale `updated:`** — pages where `updated:` is older than the latest commit touching that file.
4. **Uncited claims** — sections of body text without any source reference.
5. **Filename violations** — pages whose filename is not lowercase-kebab-case ASCII.
6. **Duplicate entities** — pages whose `aliases:` overlap with another page's name or aliases.

Report findings as a structured list. **Do not auto-fix.** This is a read-only audit; the user decides what to repair.
