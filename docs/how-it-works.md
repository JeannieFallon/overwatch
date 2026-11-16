# How it works

## Files

- **`CLAUDE.md`**: the agent's standing orders.
- **`.claude/settings.json`**: turns off web access, artifacts, and connectors. See [`security.md`](security.md).
- **`.claude/skills/`**: the commands you type at the Claude prompt.
- **`templates/`**: the empty starting files the agent copies during onboarding.
- **`logbook/`, `archive/`**: your private state, managed by the agent. Layout and rules: [`memory-model.md`](memory-model.md).

## Skills

| Skill | What it does |
|---|---|
| `onboard` | first-run interview; creates your profile and this week's state |
| `login` | start of a session: today, current focus, nearest date |
| `sweep` | clear the rooms, one topic at a time |
| `logout` | writes the day's log and refreshes state; handles the weekly reset |
| `compact` | monthly: condenses old daily logs, proposes archive items |

## Scripts

- `scripts/lockdown.sh`: limits sandbox network access to Anthropic. Run once; safe to re-run, it rebuilds the policy from scratch. Applies to every local sandbox on the Mac.
- `scripts/run.sh`: starts or reattaches to the sandbox, and stops it when you exit.
- `scripts/validate-sandbox.sh`: verifies every security boundary from the host.
- `scripts/statusline.sh`: Claude Code status line showing the model, effort level, and context tokens used. Enable it inside the sandbox by setting `"statusLine": {"type": "command", "command": "bash <repo>/scripts/statusline.sh"}` in `~/.claude/settings.json`.
