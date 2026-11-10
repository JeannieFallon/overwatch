---
name: logout
description: End-of-session or end-of-day save, and the weekly reset. Use when the human says roll over, wrap up, done for today, good night, or when a new week (Monday) has started since state.yaml was last updated.
---

# Logout

## Every logout
1. Make sure everything that happened this session is in today's daily log as tagged lines. Add missing lines; don't duplicate.
2. Refresh `logbook/state.yaml`:
   - `updated` = now.
   - `focus` = the single most important next thing.
   - Reorder `queue` by priority. Move finished items out (they live in the log as `done:` lines).
   - Keep `todos`, `open_loops`, `dates` current. Remove past dates.
3. Reply in one line: what tomorrow's first step is. Nothing else.

## Weekly reset (first logout or check-in after Sunday)
1. Set `week_of` to this Monday.
2. Drop anything in `state.yaml` that is done or no longer relevant; it is already in the logs.
3. Carry unfinished items forward unchanged. Do not re-prioritize without the human.
4. If any month is now older than ~1 month and not yet compacted, add a todo: "run compact for YYYY-MM".
