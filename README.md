# overwatch

Personal command center for working with Claude Code. Runs in a Docker sandbox and keeps state in plain-text logs, so context carries across sessions without manual summaries.

## Modules
- **logbook**: chronological state files (`logbook/<decade>/<year>/<month>/`). Grep-friendly. Personal data is never committed.

## Layout
- `sandbox/`: Dockerfile for the Claude Code container
- `logbook/`: state-file module
