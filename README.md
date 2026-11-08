# overwatch

A private command center for working with Claude Code: task management, cognitive offloading, and a second brain. You talk to the agent; the agent keeps state in plain-text local files.

## System requirements

Built for the lowest-barrier way to run an agentic harness **securely on a macOS daily driver**:

- macOS
- [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/) (`sbx` CLI, free for local use)
- A Docker account and a Claude subscription

Setup from scratch: [`docs/sandbox-setup.md`](docs/sandbox-setup.md)

## Privacy
`logbook/` and `archive/` hold personal state. They are **never committed or published**. This repo contains only the tooling.

## How it works
- **`CLAUDE.md`**: the agent's standing orders.
- **Skills** (`.claude/skills/`): `checkin` (session sweep), `rollover` (save + weekly reset), `compact` (monthly condensing).
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

`templates/` holds the empty starting files the agent copies on first run.

## Run

```
scripts/run.sh
```

The agent can write the project folder, but `CLAUDE.md` and `.claude/` are mounted **read-only**: it cannot change its own rules or skills.

## Scripts
- `scripts/run.sh`: starts the sandbox with read-only config mounts
- `scripts/validate-sandbox.sh`: verifies isolation and read-only mounts from the host

## License
PolyForm Noncommercial 1.0.0. See `LICENSE`.
