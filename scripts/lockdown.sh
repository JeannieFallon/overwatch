#!/usr/bin/env bash
# Locks sandbox network egress to Anthropic inference only. Run on the HOST with Claude closed.
# Applies to every local sandbox, not just Overwatch.
# Safe to re-run: it rebuilds the network policy from scratch each time.
#   allow api.anthropic.com        inference
#   allow platform.claude.com      sign-in token refresh
#   deny  mcp-proxy.anthropic.com  claude.ai connectors (reachable without this rule)
set -euo pipefail

sbx policy reset --force   # clears all network rules and stops running sandboxes
echo "When asked for a network policy, choose: 3. Locked Down"
sbx policy allow network "api.anthropic.com,platform.claude.com"
sbx policy deny network "mcp-proxy.anthropic.com"

echo
echo "Current rules:"
sbx policy ls
