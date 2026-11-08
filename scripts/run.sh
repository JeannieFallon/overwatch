#!/usr/bin/env bash
# Launches (or re-attaches to) the Overwatch sandbox.
# Project folder: read-write. CLAUDE.md and .claude/: read-only mounts.
# Mounts are set at creation; to change them: sbx rm claude-overwatch, then re-run.
set -eu
REPO="$(cd "$(dirname "$0")/.." && pwd)"
NAME="claude-overwatch"
exec sbx run --name "$NAME" claude \
  "$REPO" \
  "$REPO/CLAUDE.md:ro" \
  "$REPO/.claude:ro" \
  "$@"
