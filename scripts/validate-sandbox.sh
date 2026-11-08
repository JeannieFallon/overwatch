#!/usr/bin/env bash
# Validates sandbox isolation from the HOST. Usage: validate-sandbox.sh [sandbox-name]
set -u
SBX="${1:-claude-overwatch}"
REPO="$(cd "$(dirname "$0")/.." && pwd)"
pass=0; fail=0
ok(){ echo "PASS  $1"; pass=$((pass+1)); }
bad(){ echo "FAIL  $1"; fail=$((fail+1)); }
skip(){ echo "SKIP  $1"; }
inbox(){ sbx exec "$SBX" sh -c "$1" 2>/dev/null; }
# 403 = sandbox proxy refused, 000 = no connection
blocked(){ [ "$1" = "403" ] || [ "$1" = "000" ]; }

# Preflight: abort (never pass) if we can't reach the sandbox
inbox 'command -v curl >/dev/null' || { echo "ABORT: cannot exec into '$SBX' (stopped?) or curl missing"; exit 2; }

echo "== 1. Host filesystem =="
[ "$(inbox 'uname -s')" = "Linux" ] && ok "separate Linux kernel" || bad "kernel is not Linux"
rel="${REPO#$HOME/}"; top="${rel%%/*}"
seen=$(inbox "ls -A '$HOME'")
[ "$seen" = "$top" ] && ok "host home shows only mount path ($top)" || bad "host home exposes: $seen"
parent="$(dirname "$REPO")"
seen=$(inbox "ls -A '$parent'")
[ "$seen" = "$(basename "$REPO")" ] && ok "parent dir shows only this repo" || bad "parent dir exposes: $seen"
[ "$(inbox "test -e '$HOME/.ssh' && echo YES || echo NO")" = "NO" ] && ok "~/.ssh not visible" || bad "~/.ssh visible or check failed"

echo "== 2. Network egress =="
code=$(inbox 'curl -s -o /dev/null -w "%{http_code}" -m 5 https://example.org')
blocked "$code" && ok "example.org blocked (HTTP $code)" || bad "example.org reachable (HTTP $code)"
GW=$(route -n get default 2>/dev/null | awk '/gateway/{print $2}')
if [ -n "$GW" ]; then
  code=$(inbox "curl -s -o /dev/null -w '%{http_code}' -m 3 http://$GW")
  blocked "$code" && ok "LAN gateway $GW blocked (HTTP $code)" || bad "LAN gateway $GW reachable (HTTP $code)"
fi
code=$(inbox 'curl -s -o /dev/null -w "%{http_code}" -m 5 https://api.anthropic.com/v1/models')
if [ -n "$code" ] && ! blocked "$code"; then
  ok "Anthropic API reachable (server answered, HTTP $code)"
else
  bad "Anthropic API blocked or unreachable (HTTP ${code:-none})"
fi

echo "== 3. Agent config/skills unchanged (host-side git check) =="
tracked=$(git -C "$REPO" ls-files -- .claude CLAUDE.md 2>/dev/null)
if [ -z "$tracked" ] && [ ! -e "$REPO/.claude" ] && [ ! -e "$REPO/CLAUDE.md" ]; then
  skip "no .claude/ or CLAUDE.md yet — nothing to protect"
else
  changed=$(git -C "$REPO" status --porcelain -- .claude CLAUDE.md 2>/dev/null)
  [ -z "$changed" ] && ok "no changes to .claude/ or CLAUDE.md" || { bad "config changed:"; echo "$changed"; }
fi

echo; echo "Result: $pass passed, $fail failed"; [ "$fail" -eq 0 ]
