#!/usr/bin/env bash
# sync-beads.sh — push the local .beads/issues.jsonl export to the orphan
# `beads-sync` branch, isolated from code branches.
#
# Why: every bd write operation rewrites .beads/issues.jsonl. If that file is
# tracked on main, every code PR conflicts on it. We keep issues.jsonl
# git-ignored on code branches and maintain it on a dedicated orphan branch.
#
# Usage:
#   corpus-core/bin/sync-beads.sh            # push current export to beads-sync
#   corpus-core/bin/sync-beads.sh --pull     # fetch beads-sync into local .beads/issues.jsonl

set -euo pipefail

BRANCH="beads-sync"
JSONL_PATH=".beads/issues.jsonl"
REMOTE="${BD_REMOTE:-origin}"

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

if [[ "${1:-}" == "--pull" ]]; then
  git fetch "$REMOTE" "$BRANCH":refs/remotes/"$REMOTE"/"$BRANCH" 2>/dev/null || {
    echo "no $REMOTE/$BRANCH yet — nothing to pull" >&2
    exit 0
  }
  git show "$REMOTE/$BRANCH":"$JSONL_PATH" > "$JSONL_PATH"
  echo "pulled $JSONL_PATH from $REMOTE/$BRANCH"
  exit 0
fi

if [[ ! -f "$JSONL_PATH" ]]; then
  echo "no $JSONL_PATH to sync — run a bd command first" >&2
  exit 1
fi

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

cp "$JSONL_PATH" "$TMPDIR/issues.jsonl"

WORKTREE="$TMPDIR/worktree"
git fetch "$REMOTE" "$BRANCH":refs/remotes/"$REMOTE"/"$BRANCH" 2>/dev/null || true

if git show-ref --verify --quiet "refs/remotes/$REMOTE/$BRANCH"; then
  git worktree add --detach "$WORKTREE" "refs/remotes/$REMOTE/$BRANCH" >/dev/null
  cd "$WORKTREE"
  git switch -c "$BRANCH" >/dev/null 2>&1 || git switch "$BRANCH" >/dev/null
else
  git worktree add --detach "$WORKTREE" >/dev/null
  cd "$WORKTREE"
  git checkout --orphan "$BRANCH" >/dev/null
  git rm -rf . >/dev/null 2>&1 || true
fi

mkdir -p .beads
cp "$TMPDIR/issues.jsonl" "$JSONL_PATH"

git add "$JSONL_PATH"

if git diff --cached --quiet; then
  echo "no changes to push to $BRANCH"
else
  git -c core.hooksPath=/dev/null commit -m "sync: update $JSONL_PATH from $(git -C "$REPO_ROOT" rev-parse --short HEAD)" >/dev/null
  git push "$REMOTE" "$BRANCH" >/dev/null
  echo "pushed $JSONL_PATH to $REMOTE/$BRANCH"
fi

cd "$REPO_ROOT"
git worktree remove --force "$WORKTREE" >/dev/null
