#!/usr/bin/env bash
# Start or reattach to the Overwatch sandbox, then stop it when you exit.
# First run creates it with CLAUDE.md and .claude/ mounted read-only.
# Mounts are fixed at creation: sbx rm claude-overwatch to change them.
set -euo pipefail

NAME="claude-overwatch"
REPO="$(cd "$(dirname "$0")/.." && pwd)"
status=0

if sbx ls | awk -v n="$NAME" '$1 == n { found = 1 } END { exit !found }'; then
  sbx run --name "$NAME" || status=$?
else
  sbx run --name "$NAME" claude "$REPO" "$REPO/CLAUDE.md:ro" "$REPO/.claude:ro" || status=$?
fi

sbx stop "$NAME" >/dev/null 2>&1 || true
echo "Sandbox $NAME stopped."
exit "$status"
