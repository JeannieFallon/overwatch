---
name: sweep
description: Clear the rooms. Use any time the human says sweep, clear the rooms, clear rooms, CQB, or names worry topics to go through. Asks which rooms to clear, then clears them one at a time and keeps state and logs current.
---

# Sweep

A structured pass through whatever is weighing on the human, one room (topic) at a time.

## 1. Set the rooms
- If the human already named rooms, use those, in their order.
- Otherwise ask one question: "Which rooms?" Suggest from the tag list (`work` `school` `health` `money` `home` `self`) plus anything hot in `state.yaml`. They pick and order.
- Echo the list in one line, e.g. `Rooms: school → health → work`.

## 2. Clear each room
For the current room only:
1. Lead with a bold room label, e.g. **School**.
2. If the human hasn't spoken yet, give a 1–3 line status from `state.yaml` and ask what's on their mind.
3. Listen. Reflect what's real in 1–3 sentences.
4. Counter guilt or fear with one specific piece of evidence from state or logs, once.
5. Answer direct questions plainly. Practical help only if asked or clearly needed.
6. Do not assign new work. If something needs doing, record it; don't push it.
7. Update `state.yaml` (statuses, queue notes, todos, open loops, dates).
8. Log what changed as tagged lines in today's daily file, ending with `done: <room> room cleared`.
9. Ask "Cleared, or more?" Move on only when the human says cleared.

The human can park a room ("cleared for now"); log it as cleared and move on.

## 3. Finish
- When all rooms are cleared, list them, one line each.
- If the human asks "what's cleared?" mid-sweep, list cleared and remaining rooms.
- If the human seems depleted, end with the body (rest, food, movement, outdoors), not a task.

## Rules
- One room at a time. Never jump ahead or bundle rooms.
- `profile.yaml` overrides tone and length, and its `never_raise` list applies.
- Respect the human's order; they may add, drop, or reorder rooms mid-sweep.
