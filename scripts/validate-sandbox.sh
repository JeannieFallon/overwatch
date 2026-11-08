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

echo "== 3. Read-only config mounts (real write attempts) =="
probe="$REPO/.ow-write-probe"
if [ "$(inbox "touch '$probe' && rm -f '$probe' && echo OK")" = "OK" ]; then
  ok "project folder writable (logbook works)"
else
  bad "project folder not writable"
fi
for who in "" "sudo"; do
  label=${who:+" (with sudo)"}
  if [ -e "$REPO/CLAUDE.md" ]; then
    r=$(inbox "$who touch '$REPO/CLAUDE.md' && echo WROTE || echo DENIED")
    [ "$r" = "DENIED" ] && ok "CLAUDE.md write refused$label" || bad "CLAUDE.md WRITABLE$label"
  else skip "CLAUDE.md does not exist"; fi
  if [ -d "$REPO/.claude" ]; then
    t="$REPO/.claude/.ow-write-probe"
    r=$(inbox "$who touch '$t' && echo WROTE || echo DENIED")
    if [ "$r" = "DENIED" ]; then ok ".claude/ write refused$label"
    else bad ".claude/ WRITABLE$label"; inbox "$who rm -f '$t'"; rm -f "$t"; fi
  else skip ".claude/ does not exist"; fi
done

echo; echo "Result: $pass passed, $fail failed"; [ "$fail" -eq 0 ]
