---
name: onboard
description: One-time setup interview that creates logbook/profile.yaml and logbook/state.yaml. Use when either file is missing, or the human says onboard, set up, get started, or update my profile.
---

# Onboard

Goal: a usable profile and state in a few minutes, with as little effort from the human as possible. One question per message. Every question can be skipped.

## 1. Prepare
- If `logbook/profile.yaml` already exists, say so in one line and ask: "Update your profile, or check in instead?" Stop unless they choose update. On update, ask what changed and edit only that.
- Otherwise create `logbook/` and copy `templates/profile.yaml` → `logbook/profile.yaml` and `templates/state.yaml` → `logbook/state.yaml`. Never overwrite an existing file.

## 2. Fast path: paste
Ask: "Do you have a context summary to paste, like a YAML rollover from another chat? Paste it, or say no."

If they paste one, split it:
- Durable facts about the person → `profile.yaml`.
- Current tasks, upcoming dates, open loops → `state.yaml`.
- Dated past events → today's daily log as tagged lines.
- Drop anything stale: past dates, finished tasks.

Then go to step 4.

## 3. Interview (only if nothing was pasted)
Ask one at a time. Write each answer to its file right away, so stopping midway loses nothing.

1. "What should I call you?" → `name`
2. "What timezone are you in?" → `timezone` (IANA name, e.g. `America/New_York`; if they give a city, confirm your guess)
3. "How do you want me to talk to you? For example: short, bullets, one step at a time." → `communication`
4. "Anything I should never bring up?" → `never_raise`
5. "When you're stressed or overloaded, what actually helps?" → `what_works`
6. "Anything people suggest that doesn't help you?" → `what_doesnt`
7. "What's on your plate right now? Just list it." → `state.yaml` `queue` and `todos`, tagged from the CLAUDE.md tag list
8. "Any fixed dates coming up?" → `state.yaml` `dates`, soonest first
9. "What's the single most important next thing?" → `focus`

Keep the human's own words. Don't add facts they didn't say.

## 4. Finish
- Set `updated` and `week_of` in `state.yaml`.
- Add one line to today's daily log: `- HH:MM [overwatch] note: onboarded`.
- Reply with two lines only:
  1. What was saved, in one sentence.
  2. "From now on: /login to start a session, /logout to wrap up."
