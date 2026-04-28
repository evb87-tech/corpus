# Claude Code plugin syntax — verified facts for corpus

This is the locked-in reference for how corpus uses the Claude Code plugin contract. Compiled from the official docs at `code.claude.com/docs/en/` (verified 2026-04-28 in cor-erd). When in doubt, defer to the linked source.

## 1. `${CLAUDE_PLUGIN_ROOT}` expansion

Expands inline anywhere it appears in:

- skill content (`SKILL.md`, referenced markdown)
- agent content (`agents/*.md`)
- hook commands (`hooks/hooks.json`)
- monitor commands (`monitors/monitors.json`)
- MCP server configs (`.mcp.json`)
- LSP server configs (`.lsp.json`)

Also exported as an env var to hook processes and MCP/LSP subprocesses.

**For corpus this means**: command files can use `@${CLAUDE_PLUGIN_ROOT}/rules/foo.md` in markdown @-imports directly. No `!cat ${CLAUDE_PLUGIN_ROOT}/...` shell wrapper required.

Source: [Plugins reference — Environment variables](https://code.claude.com/docs/en/plugins-reference.md#environment-variables).

## 2. `userConfig` runtime exposure

Two mechanisms:

1. **Substitution syntax** — `${user_config.KEY}` works inside MCP/LSP configs, hook commands, monitor commands, and (for non-sensitive keys only) skill and agent content.
2. **Env var to subprocesses** — every value is exported to plugin subprocesses as `CLAUDE_PLUGIN_OPTION_<KEY>`. Both sensitive and non-sensitive.

Non-sensitive values are also persisted in `settings.json` under `pluginConfigs[<plugin-id>].options`.

**There is no auto-exported `$CORPUS_VAULT`.** If we want a `vaultPath` userConfig value to surface as `$CORPUS_VAULT` for the agent's preflight checks, the plugin must ship a `SessionStart` hook that runs:

```bash
export CORPUS_VAULT="$CLAUDE_PLUGIN_OPTION_VAULT_PATH"
```

This is the chosen pattern. Documented in `cor-dyo` (init-vault) and the preflight stanza in each command.

Source: [Plugins reference — User configuration](https://code.claude.com/docs/en/plugins-reference.md#user-configuration).

## 3. Lifecycle hooks

Plugin install does NOT trigger any lifecycle code. The 22 documented hook events are all session-runtime events: `SessionStart`, `SessionEnd`, `PreToolUse`, `PostToolUse`, etc. **No `OnInstall`, `OnEnable`, `PostInstall`.**

**For corpus this means**: we cannot prompt the user to scaffold a vault at install. The first-run pattern is:

1. User runs `claude plugin install corpus-core`.
2. First time the user opens a session with corpus-core enabled, a `SessionStart` hook checks for `$CORPUS_VAULT` and a `.corpus-vault` marker.
3. If missing, the hook surfaces a one-line "run `/init-vault <path>` to scaffold a vault" message.

Source: [Plugins reference — Hooks](https://code.claude.com/docs/en/plugins-reference.md#hooks).

## 4. Dependency auto-install

`claude plugin install <plugin-A>` auto-pulls every plugin listed in plugin-A's `plugin.json` `dependencies` array. Two forms accepted:

```json
"dependencies": ["plugin-B"]
```

or

```json
"dependencies": [{"name": "plugin-B", "version": "^0.1"}]
```

**Constraints:**

- Dependencies must resolve within the same marketplace, OR cross-marketplace resolution must be explicitly allowlisted in `marketplace.json`.
- `dependencies` accepts plugin names only. **No git URLs. No local paths.**

**For corpus this means**: corpus-core and corpus-pm must ship in the same marketplace. The single-install UX (`claude plugin install corpus-pm` pulls corpus-core automatically) requires both plugins published together. This pins the answer to cor-w53 (monorepo vs split repos): one repo with two plugin subdirectories so they ship to the same marketplace as a unit, OR two repos but a shared marketplace manifest. Implementation choice in cor-w53.

Source: [Plugin dependencies](https://code.claude.com/docs/en/plugin-dependencies.md).

## 5. Cross-plugin runtime introspection — UNDOCUMENTED

**There is no official API for "list installed plugins" or "read another plugin's manifest at runtime."** The only documented runtime references to other plugins are at install/load time, internal to Claude Code.

**For corpus this means**: the pack discovery protocol in `corpus-core/rules/09-extension-contract.md` cannot rely on a built-in API. Implementation in cor-7el must glob a known cache path:

```bash
~/.claude/plugins/cache/*/corpus-pack.yaml
```

This path is documented as the cache location for marketplace-installed plugins. No `${CLAUDE_PLUGINS_DIR}` variable exists; the path is hardcoded.

**Risk**: if Anthropic moves the cache location, pack discovery breaks until cor-7el is updated. Mitigation: file a `/feedback` request for a `${CLAUDE_PLUGINS_DIR}` variable or runtime `plugin list --json` API. Until then, accept the brittleness — no fallback exists.

Source: [Plugins reference — Plugin caching and file resolution](https://code.claude.com/docs/en/plugins-reference.md#plugin-caching-and-file-resolution).

## What's locked in vs. what's pending

| Question                                | Status     | Unblocks                |
| --------------------------------------- | ---------- | ----------------------- |
| `${CLAUDE_PLUGIN_ROOT}` in @-imports    | ✅ locked  | cor-2qd (plugin layout) |
| `userConfig` → `$CORPUS_VAULT`          | ✅ locked  | cor-dyo (init-vault)    |
| No install hooks; SessionStart fallback | ✅ locked  | cor-dyo, cor-2qd        |
| Dependency auto-install                 | ✅ locked  | cor-w53 (repo shape)    |
| Cross-plugin introspection              | ⚠ glob workaround | cor-7el (pack discovery runtime) |

cor-erd is closeable. cor-7el carries a known risk that's documented above.
