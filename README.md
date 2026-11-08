# overwatch

A private command center for working with Claude Code: task management, cognitive offloading, and a second brain. You talk to the agent; the agent keeps state in plain-text local files.

Overwatch is a **personal daily log with no way to publish**. The sandbox reaches Anthropic's API for inference and nothing else.

## System requirements

Built for the lowest-barrier way to run an agentic harness **securely on a macOS daily driver**:

- macOS
- [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/) (`sbx` CLI, free for local use)
- A Docker account and a Claude subscription

First time on this Mac? Install `sbx` and sign in with steps 1–3 of [`docs/sandbox-setup.md`](docs/sandbox-setup.md).

## Quickstart

**0. Lock down the network** (one time, from the repo root):

```
./scripts/lockdown.sh
```

When it asks for a network policy, choose **Locked Down**. The script then allows Anthropic's API and nothing else. This applies to every local sandbox on the Mac, and it's safe to re-run: it rebuilds the policy from scratch.

**1. Start the sandbox** (terminal pane 1):

```
./scripts/run.sh
```

The first run creates the sandbox; later runs reattach to it. Exiting Claude stops the sandbox. First time only: type `/login` at the Claude prompt.

**2. Validate isolation** (terminal pane 2, while Claude is open):

```
./scripts/validate-sandbox.sh
```

Every line should say `PASS`. Run it again any time you change the network policy, `run.sh`, or `.claude/`.

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
| **Network** | **`scripts/lockdown.sh`: Locked Down preset, two Anthropic hosts allowed** (our addition) | **reach anything but Anthropic: no GitHub, no package registries, no local network** |
| **Rules and skills** | **read-only mounts in `scripts/run.sh`** (our addition) | **edit `CLAUDE.md` or anything in `.claude/`** |
| **Anthropic-hosted extras** | **`.claude/settings.json`, read-only** (our addition) | **use web search or web fetch, publish artifacts, or call claude.ai connectors** |

**Why the network allowlist is two hosts.**
- `api.anthropic.com`: inference.
- `platform.claude.com`: refreshing the sign-in token.

`mcp-proxy.anthropic.com`, the route for claude.ai connectors, was still reachable under Locked Down, so `lockdown.sh` also denies it explicitly. A deny rule always beats an allow.

**Why the settings file is needed too.** Web search, artifacts, and claude.ai connectors run through Anthropic's own services, so a network allowlist alone can't tell them apart from inference. `.claude/settings.json` turns them off. It sits in the read-only `.claude/` mount, and none of the three can be switched back on by another settings file.

**Why the read-only mounts matter.** `CLAUDE.md` and the skills are the agent's instructions. A rule like "never edit your own rules" is only text, and an agent can ignore or rewrite text. The read-only mount moves that guarantee out of the prompt and into the filesystem: writes fail even with `sudo`. To change the rules, edit them on your Mac, then restart Claude.

`scripts/validate-sandbox.sh` checks every row from the host, outside the agent's reach: it makes real network requests and real write attempts from inside the sandbox, and reads the settings file the way the agent sees it.

**Known limits**
- Everything the agent reads is sent to Anthropic's API for inference. That is the one destination, by design.
- The rest of the repo is writable from inside the sandbox, including `scripts/`, `.git/`, and `.gitignore`, which take effect on the host. Hardening is planned.
- The network policy is global: it applies to every local sandbox on the Mac.

## Privacy
`logbook/` and `archive/` hold personal state. They are **never committed or published**, and the sandbox has no network route to publish them. This repo contains only the tooling.

## How it works
- **`CLAUDE.md`**: the agent's standing orders.
- **`.claude/settings.json`**: turns off web access, artifacts, and connectors.
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
- `scripts/lockdown.sh`: limits sandbox network access to Anthropic (run once)
- `scripts/run.sh`: starts or reattaches to the sandbox, and stops it when you exit
- `scripts/validate-sandbox.sh`: verifies every security boundary from the host

## License
PolyForm Noncommercial 1.0.0. See `LICENSE`.
