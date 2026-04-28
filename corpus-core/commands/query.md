---
description: Query the wiki under one of three postures — research, contradictor, synthesis. Trigger FR — interroger le wiki, consulter le wiki, rechercher dans le wiki, contredire une thèse, synthétiser ce qu'on sait.
argument-hint: [posture] [question]   e.g. "research What does the wiki say about X?"
---

**Pre-flight:**

```bash
CORPUS_VAULT="${CORPUS_VAULT:-$CLAUDE_PLUGIN_OPTION_VAULT_PATH}"
if [ -z "$CORPUS_VAULT" ]; then
  echo "No vault configured. Set CORPUS_VAULT (local dev) or configure the vaultPath userConfig option in the installed plugin (exposed as CLAUDE_PLUGIN_OPTION_VAULT_PATH). Neither is set. Run /init-vault <path> to scaffold a fresh vault, then export the path." >&2
  exit 1
fi
```

Verify `$CORPUS_VAULT/.corpus-vault` exists. If not, refuse and tell the owner to run `/init-vault <path>`. See `corpus-core/rules/08-vault-structure.md`.

Answer the owner's question against `$CORPUS_VAULT/wiki/`: $ARGUMENTS

Detect the posture (research | contradictor | synthesis) from the wording, OR honor an explicit posture token at the start of $ARGUMENTS:

- `research <question>` — retrieve what the wiki already says.
- `contradictor <target>` — attack the wiki, surface weaknesses.
- `synthesis <question>` — produce a statistical average across sources.

Follow `corpus-core/rules/05-query-postures.md`:

1. Read `wiki/index.md` first.
2. Read identified pages and adjacent ones.
3. Answer using **only** wiki content unless the owner explicitly invites outside knowledge.
4. Cite at the end: `Sources: [[page-1]], [[page-2]]`.
5. **File-back rules:**
   - Research producing a reusable lookup → file as wiki page with `type: reference`.
   - Contradictor → file as wiki page with `type: stress-test`. Delegate to the **contradictor** subagent.
   - Synthesis → write to `output/`, never to `wiki/`. Flag the output as a statistical average.
6. Append to `wiki/log.md`:
   ```
   ## [YYYY-MM-DD] query | <question summary>
   Posture: <research|contradictor|synthesis>
   Pages consulted: [[a]], [[b]]
   Filed as: [[result-page]]   (research/contradictor only)
   ```

Hard rules: never invent sources, never harmonize contradictions, never silently complete with training-data knowledge. See `corpus-core/rules/07-anti-lissage.md`.
