#!/bin/bash
# Claude Code status line: user@host:dir, model (effort), context tokens used / window (%).
# Wire it up in ~/.claude/settings.json: "statusLine": {"type": "command", "command": "bash <repo>/scripts/statusline.sh"}
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
[ -z "$cwd" ] && cwd=$(pwd)
case "$cwd" in
  "$HOME") cwd="~" ;;
  "$HOME"/*) cwd="~${cwd#"$HOME"}" ;;
esac
model=$(echo "$input" | jq -r '.model.display_name // empty' 2>/dev/null)
mod=""
effort=$(echo "$input" | jq -r '.effort.level // empty' 2>/dev/null)
[ -n "$model" ] && mod=$(printf '  \033[1;35m%s\033[0m' "$model")
[ -n "$effort" ] && mod="$mod$(printf ' \033[0;35m(%s)\033[0m' "$effort")"
# context tokens: sum of the latest request's input-side usage, if this version provides it
tok=$(echo "$input" | jq -r '
  (.context_window.current_usage // empty
   | ((.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0))) // empty' 2>/dev/null)
size=$(echo "$input" | jq -r '.context_window.context_window_size // empty' 2>/dev/null)
ctx=""
if [ -n "$tok" ] && [ "$tok" != "0" ]; then
  k=$(( (tok + 500) / 1000 ))
  if [ -n "$size" ] && [ "$size" -gt 0 ] 2>/dev/null; then
    ctx=$(printf '  \033[0;37m%sk / %sk (%s%%)\033[0m' "$k" "$((size/1000))" "$((tok*100/size))")
  else
    ctx=$(printf '  \033[0;37m%sk tokens\033[0m' "$k")
  fi
fi
printf '\033[1;36m%s@%s\033[0m:\033[1;34m%s\033[0m%s' "$(whoami)" "$(uname -n)" "$cwd" "$mod$ctx"
