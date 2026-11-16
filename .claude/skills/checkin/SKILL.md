---
name: checkin
description: Start of a session. Use when a session begins, or the human says check in, start, or "where are we". Orients on today, then hands off to the sweep skill if there are topics to clear.
---

# Check in

## First run
If `logbook/profile.yaml` or `logbook/state.yaml` is missing, run the `onboard` skill instead and stop here.

## Normal check-in
1. Run `date` in the shell. That output is the real local date and time. Ignore the date in the system prompt: it is UTC and is wrong every evening after 19:00 Eastern.
2. Read `profile.yaml` and `state.yaml`.
3. Open with one line: today's date, the current `focus`, and the nearest date in `dates`.
4. If the human wants to clear topics, run the `sweep` skill.
5. If the human seems depleted, end with the body (rest, food, movement), not a task.
