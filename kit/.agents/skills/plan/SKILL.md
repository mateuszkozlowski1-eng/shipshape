---
name: plan
description: Turn a request into small, checkable steps written to PLAN.md before writing code. Use for any feature, refactor or change bigger than a small fix, and whenever the work is likely to span more than one session.
---

# Plan

Goal: work that moves in small steps, each one leaving the app working and each one provably done.
The plan lives in `PLAN.md`, not in your memory, so a new session (or another agent) can pick it up.

## Steps

1. **Restate the goal** in one or two sentences, in the user's words. What must be true when we are
   finished?
2. **Ask only what changes the plan.** At most three questions, and only ones you cannot answer from
   the code, `AGENTS.md` or `DECISIONS.md`. For everything else pick a sensible default and write it
   down under Assumptions.
3. **Look before you plan.** Read the code the change touches and `DECISIONS.md`. Reuse what exists;
   don't plan a second way of doing something the project already does.
4. **Split into steps.** Each step:
   - is small: one sitting, a diff a person can read in a few minutes;
   - leaves the app working (no "step 3 of 5, everything is broken until step 5");
   - has a **check**: the test that proves it, or the exact manual steps and the expected result;
   - names the files or areas it touches.

   Order: what others depend on first (data model, shared types, API contracts), then the features on
   top, then polish. Put the riskiest unknown early, so a bad assumption shows up before you build on
   it.
5. **Mark sensitive steps** (auth, payments, user data, uploads, migrations, deletes, paid API calls)
   with `⚠`. They always get the security part of the review, and the user confirms them before they
   run against real data.
6. **Write `PLAN.md`** in this shape:

   ```markdown
   # Plan: <goal in a few words>

   Goal: <one or two sentences>
   Assumptions: <defaults you picked instead of asking>

   | # | Step | Check | Status |
   |---|------|-------|--------|
   | 1 | Add `orders` table and model | migration runs locally; model test passes | todo |
   | 2 | ⚠ Only the owner can read an order | test: user B gets 404 for user A's order | todo |

   Notes: <anything a fresh session must know>
   ```

   Status is one of `todo`, `doing`, `done`, `blocked (why)`.
7. **Show the user the plan** in a few lines and start, unless they asked to approve it first.

## While working

- One step at a time: set it to `doing`, build it, run `done` (which includes `review`), commit, set
  it to `done`.
- When the plan turns out wrong, update `PLAN.md` and tell the user in one line. Never drift away from
  the plan silently.
- Running out of context or ending the session? Run `handoff`.
- When the whole plan is done, delete `PLAN.md`, after moving anything worth keeping to
  `DECISIONS.md`.
