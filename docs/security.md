# Security and privacy

Overwatch is a **personal daily log with no way to publish**. The sandbox reaches Anthropic's API for inference and nothing else.

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

## Verifying

`scripts/validate-sandbox.sh` checks every row from the host, outside the agent's reach: it makes real network requests and real write attempts from inside the sandbox, and reads the settings file the way the agent sees it. Every line should say `PASS`. Run it again any time you change the network policy, `run.sh`, or `.claude/`.

## Privacy

`logbook/` and `archive/` hold personal state. This repo contains only the tooling.

- **Never committed.** `.gitignore` lists `logbook/` and `archive/`. A directory pattern ignores everything beneath it, so any file or subfolder you add there (for example, a PDF dropped into `logbook/inbox/`) is ignored too. To confirm for any path:

  ```
  git check-ignore -v logbook/inbox/example.pdf
  ```

  Output naming a `.gitignore` line means git will skip it. No output means the file is **not** ignored.
- **Never published.** The sandbox has no network route except Anthropic's API.

## Known limits

- Everything the agent reads is sent to Anthropic's API for inference. That is the one destination, by design.
- The rest of the repo is writable from inside the sandbox, including `scripts/`, `.git/`, and `.gitignore`, which take effect on the host. Hardening is planned.
- The network policy is global: it applies to every local sandbox on the Mac.
