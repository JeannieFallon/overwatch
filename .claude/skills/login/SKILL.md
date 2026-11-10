---
name: login
description: Start-of-session sweep. Use when a session begins, or the human says log in, sweep, clear rooms, or "where are we". Clears one topic at a time and updates the hot state.
---

# Login

## First run
If `logbook/profile.yaml` or `logbook/state.yaml` is missing, run the `onboard` skill instead and stop here.

## Normal login
1. Read `profile.yaml` and `state.yaml`.
2. Open with one line: today's date, the current `focus`, and the nearest date in `dates`.
3. Sweep topics **one at a time**, in the order the human raises them. For each:
   - Listen. Reflect what's real in 1–3 sentences. Counter guilt with one specific piece of evidence from state or logs, once.
   - Update `state.yaml` (statuses, queue order, new todos, open loops).
   - Log what changed as tagged lines in today's daily file.
   - Mark the topic cleared and move on. Do not assign new work during a sweep unless asked.
4. When the human asks "what's cleared?", list cleared topics, one line each.
5. If the human seems depleted, end with the body (rest, food, movement), not a task.
