# overwatch

A private command center for working with Claude Code: task management, cognitive offloading, and a second brain. You talk to the agent; the agent keeps state in plain-text local files.

## System requirements

Built for the lowest-barrier way to run an agentic harness **securely on a macOS daily driver**:

- macOS
- [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/) (`sbx` CLI, free for local use)
- A Docker account and a Claude subscription

First time on this Mac? Install `sbx` and sign in with steps 1–3 of [`docs/sandbox-setup.md`](docs/sandbox-setup.md).

## Quickstart

**1. Start the sandbox** (terminal pane 1, from the repo root):

```
./scripts/run.sh
```

The first run creates the sandbox; later runs reattach to it. Exiting Claude stops the sandbox. First time only: type `/login` at the Claude prompt.

**2. Validate isolation** (terminal pane 2, while Claude is open):

```
./scripts/validate-sandbox.sh
```

Every line should say `PASS`.

**3. Onboard** (first time only, at the Claude prompt):

```
/onboard
```

A short interview, one question at a time. If you already have a context summary from another chat, you can paste it instead.

**4. Daily use** (at the Claude prompt):

| Command | When |
|---|---|
| `/checkin` | start of a session |
| `/rollover` | end of a session or day |
| `/compact` | monthly; the agent reminds you |

You can also just say "check in" or "wrap up."

## Privacy
`logbook/` and `archive/` hold personal state. They are **never committed or published**. This repo contains only the tooling.

## How it works
- **`CLAUDE.md`**: the agent's standing orders. Mounted read-only in the sandbox.
- **Skills** (`.claude/skills/`, also read-only): `onboard` (first-run interview), `checkin` (session sweep), `rollover` (save + weekly reset), `compact` (monthly condensing).
- **Memory tiers**, all agent-managed:

```
logbook/
  profile.yaml            durable facts about you
  state.yaml              hot: this week
  2026/
    2026-11/2026-11-08.md warm: daily logs, last ~4 weeks
    2026-10.md            cold: one compacted file per month
archive/
  2026/2026-10/<topic>.md optional high-value detail
```

`templates/` holds the empty starting files the agent copies during onboarding.

## Scripts
- `scripts/run.sh`: starts or reattaches to the sandbox, and stops it when you exit
- `scripts/validate-sandbox.sh`: verifies sandbox isolation from the host

## License
PolyForm Noncommercial 1.0.0. See `LICENSE`.
