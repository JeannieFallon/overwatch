---
name: compact
description: Monthly compaction of cold history. Use when the human says compact, or a rollover todo asks to compact a month older than ~1 month. Condenses daily logs into one sparse month file and proposes archive items.
---

# Compact

Target: a month folder `logbook/YYYY/YYYY-MM/` whose last day is more than ~1 month ago.

1. Read that month's daily files.
2. Draft `logbook/YYYY/YYYY-MM.md`:
   - Header `# YYYY-MM`.
   - Keep only `decision`, key `done` milestones, and lasting `note`s. Drop routine, duplicates, and anything later superseded.
   - Same line format, date instead of time: `- 11-08 [school] done: OS practice exam passed`.
   - Aim for under ~40 lines per month.
3. List archive candidates: details too rich for one line but worth keeping (numbers, reasoning, plans). Ask the human one question: "Keep any of these in archive? (numbers, or none)".
4. For each approved item, write `archive/YYYY/YYYY-MM/<short-topic>.md` and add a pointer to the month file: `- 11-08 [money] note: retirement model → archive/2026/2026-11/retirement-model.md`.
5. Show the human the month file's line count and the archive files created. Only after they confirm, delete the daily folder `logbook/YYYY/YYYY-MM/`.
