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

## Security boundaries

Docker Sandboxes runs Claude Code with no per-action permission prompts (`--dangerously-skip-permissions`, shown as "bypass permissions on"). That's by design: safety comes from what the agent **cannot reach**, not from asking before each step.

| Boundary | Enforced by | The agent cannot |
|---|---|---|
| Kernel | Docker Sandboxes microVM | touch macOS processes or the host kernel |
| Filesystem | sbx workspace mount | see anything outside this repo: no home folder, no `~/.ssh` |
| Network | sbx Balanced policy (default deny) | reach arbitrary sites or your local network |
| **Rules and skills** | **read-only mounts in `scripts/run.sh`** (our addition) | **edit `CLAUDE.md` or anything in `.claude/`** |

**Why the read-only mounts matter.** `CLAUDE.md` and the skills are the agent's instructions. A rule like "never edit your own rules" is only text, and an agent can ignore or rewrite text. The read-only mount moves that guarantee out of the prompt and into the filesystem: writes fail even with `sudo`. To change the rules, edit them on your Mac, then restart Claude.

`scripts/validate-sandbox.sh` checks every row from the host, outside the agent's reach, including real write attempts against the read-only files.

**Known limits**
- The rest of the repo is writable from inside the sandbox, including `scripts/`, `.git/`, and `.gitignore`, which take effect on the host. Hardening is planned.
- The Balanced policy allows common developer sites. Tighter egress is planned.

## Privacy
`logbook/` and `archive/` hold personal state. They are **never committed or published**. This repo contains only the tooling.

## How it works
- **`CLAUDE.md`**: the agent's standing orders.
- **Skills** (`.claude/skills/`): `onboard` (first-run interview), `checkin` (session sweep), `rollover` (save + weekly reset), `compact` (monthly condensing).
- **Memory**: three agent-managed tiers plus an optional archive. Full design: [`docs/memory.md`](docs/memory.md).

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

## Docs
- [`docs/sandbox-setup.md`](docs/sandbox-setup.md): installing `sbx` and signing in
- [`docs/memory.md`](docs/memory.md): the memory model

## Scripts
- `scripts/run.sh`: starts or reattaches to the sandbox, and stops it when you exit
- `scripts/validate-sandbox.sh`: verifies sandbox isolation from the host

## License
PolyForm Noncommercial 1.0.0. See `LICENSE`.
