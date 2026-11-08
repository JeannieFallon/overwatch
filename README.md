# overwatch

A private command center for working with Claude Code: task management, cognitive offloading, and a second brain. You talk to the agent; the agent keeps state in plain-text local logs.

## System requirements

Built for the lowest-barrier way to run an agentic harness **securely on a macOS daily driver**:

- macOS
- [Docker Sandboxes](https://docs.docker.com/ai/sandboxes/) (`sbx` CLI, free for local use)
- A Docker account and a Claude subscription

Setup from scratch: [`docs/sandbox-setup.md`](docs/sandbox-setup.md)

## Privacy
`logbook/` holds personal state files. It is **never committed or published**. This repo contains only the tooling.

## Modules
- **logbook**: the agent's memory. One plain-text file per day (`logbook/<decade>/<year>/<year-month>/<year-month-day>.log`), created and maintained by the agent only. Humans interact through the agent, not the files.

## Sandbox
The agent runs in a Docker Sandbox: a microVM with its own kernel, default-deny network, and access to this folder only. See [`docs/sandbox-setup.md`](docs/sandbox-setup.md).

```
sbx run claude ~/Develop/overwatch
```

## Scripts
- `scripts/validate-sandbox.sh`: verifies sandbox isolation from the host

## License
PolyForm Noncommercial 1.0.0. See `LICENSE`.
