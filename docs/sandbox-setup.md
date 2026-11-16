# Sandbox setup

Overwatch runs Claude Code inside [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/): a microVM with its own Linux kernel, a default-deny network proxy, and access to the project folder only. This guide gets it running on a Mac from scratch.

## Requirements

- macOS daily driver
- [Homebrew](https://brew.sh)
- `git`
- A **Docker account** (the free Personal tier is enough)
- A **Claude subscription** that includes Claude Code, or an Anthropic API key

Docker Desktop is **not** required. The `sbx` CLI is standalone, and local sandboxes are free.

## 1. Update Homebrew

```bash
brew update && brew upgrade
```

## 2. Install the `sbx` CLI

```bash
brew trust docker/tap && brew install docker/tap/sbx
```

## 3. Create a Docker account and sign in

```bash
sbx login
```

This opens a browser. Sign in with Google, GitHub, or email.

Troubleshooting:
- **Username taken:** usernames allow only letters and numbers. Add a suffix like `dev` or `lab`.
- **Signed in as the wrong account:** the browser reuses a cached Docker session. Run `sbx logout`, sign out at [app.docker.com](https://app.docker.com), then run `sbx login` again.
- **Terminal hangs or the browser shows "not found" after sign-in:** press `Ctrl+C`, then run `sbx login` again. It completes immediately once the browser session exists.
- **Login fails right after creating an account:** check your email for a Docker verification link first.

## 4. Lock down the network

From a normal Mac terminal, with Claude closed:

```bash
scripts/lockdown.sh
```

When `sbx` asks for a network policy, choose **3. Locked Down** (default deny, nothing allowed). The script then allows only the two Anthropic hosts Overwatch needs and denies claude.ai connectors. See [`security.md`](security.md) for why.

The policy is global: it applies to every local sandbox on this Mac. If you already picked another policy (for example **2. Balanced**), just run the script again. It resets the policy and asks again. Re-run it any time; it rebuilds the policy from scratch.

## 5. Start the sandbox

Always start it with the launcher, from your clone of this repo:

```bash
scripts/run.sh
```

The launcher mounts the project read-write but `CLAUDE.md` and `.claude/` **read-only**, so the agent cannot change its own rules or skills. Mounts are fixed when the sandbox is created. If you ever started it another way, remove it first (`sbx rm claude-overwatch`) and re-run the launcher.

## 6. Sign in to Claude inside the sandbox

At the Claude Code prompt:

```
/login
```

Choose your Claude subscription and finish the browser sign-in.

To use an API key instead, store it on the host before starting. The key is injected at the network boundary and never enters the sandbox:

```bash
sbx secret set anthropic
```

Note: the sandbox ignores your Mac's `~/.claude`. Only project-level config (`CLAUDE.md`, `.claude/`) is visible inside.

## 7. Verify isolation

From a normal Mac terminal (not inside Claude), with the sandbox running:

```bash
scripts/validate-sandbox.sh
```

It checks the host filesystem, network egress (only Anthropic reachable), the read-only config mounts (with and without `sudo`), and that committed config is unchanged. Expected: all PASS. If a network check fails, re-run `scripts/lockdown.sh`.

## Everyday commands

```bash
scripts/run.sh               # start or re-attach
sbx ls                       # list sandboxes
sbx stop claude-overwatch    # stop (keeps state)
sbx rm claude-overwatch      # delete the VM and everything inside it, including the Claude login
sbx logout                   # sign out of Docker (stops local sandboxes)
```

Sandboxes keep running after you exit Claude Code. Stop or remove them when done.
