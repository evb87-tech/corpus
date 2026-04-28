# Issue tracking — beads

This repo uses [beads](https://github.com/dogmata-dev/beads) for issue tracking.

## Quick reference

```bash
bd ready              # find available work
bd list               # list all open issues
bd show <id>          # view issue details
bd create -t "title"  # create a new issue
bd update <id> --claim # claim work
bd close <id>         # complete work
bd prime              # full command reference + session protocol
```

## Configuration

- **Issue prefix:** `cor` (issues named `cor-1`, `cor-2`, ...)
- **Backend:** dolt (embedded)
- **Sync branch:** `beads-sync`
- **Sync remote:** `origin`

## Rules

- Use `bd` for **all** task tracking on this repo. Do not use markdown TODO lists or `TodoWrite` for cross-session work.
- Use `bd remember <key> <value>` for persistent project knowledge instead of standalone memory files.
- When ending a session: ensure beads is exported and pushed.

## Session-end protocol

Beads injects a session-end protocol into agent contexts. The short version:

1. File issues for any remaining work discovered.
2. Run quality gates (`bun run ci`) if code changed.
3. Update issue status: close finished, update in-progress.
4. Push:
   ```bash
   git pull --rebase
   bd dolt push
   git push
   ```
5. Verify `git status` is clean and "up to date with origin."

If `bd dolt push` fails because the remote has no branches yet, it'll succeed after the first `git push`.
