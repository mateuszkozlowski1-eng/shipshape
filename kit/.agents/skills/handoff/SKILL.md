---
name: handoff
description: Save where the work stands into PLAN.md so the next session or another agent can continue without re-discovering everything. Use at the end of a session, before switching tools or models, when the context is getting long, and when the user says "let's continue tomorrow".
---

# Handoff

Goal: the next session starts by reading one file and picks up exactly where this one stopped. Memory
of the conversation does not survive; files do.

## Steps

1. **Commit or park what works.** Working changes: run `done` and commit. Half-finished changes that
   do not work yet: leave them uncommitted and say so, or put them on a branch (`wip/<name>`); never
   commit broken code to the main branch.
2. **Update `PLAN.md`:**
   - each step's real status (`done`, `doing`, `blocked (why)`);
   - under a `## Handoff` heading at the bottom, replacing any older one:

   ```markdown
   ## Handoff (2026-03-02)

   Now: step 4, half done — the form saves, the email is not sent yet (src/lib/mail.ts).
   Next: wire up the email, then step 5.
   Watch out: the test DB must be running (`npm run db:test`); test `orders.spec.ts` is flaky, see note.
   Open questions for the user: should cancelled orders send an email?
   Not verified: the Safari layout.
   ```

   No `PLAN.md` because the work was small? Write the same few lines into a new one anyway.
3. **Record decisions** made in this session with `decide`, so they don't live only in the chat.
4. **Look back once.** Did the user correct you, did review find the same thing twice, did something
   take far longer than it should? Propose a lesson with `learn`. Nothing worth it? Skip this; don't
   invent lessons.
5. **Tell the user** in two or three lines what state things are in and how to resume:
   "Start the next session with: read PLAN.md and continue."

## Starting from a handoff

Read `AGENTS.md`, `PLAN.md` (the Handoff section first), `DECISIONS.md` and the `proposed` entries in
`LESSONS.md` (ask the user about them if they are still open). Check that what it says is
still true (`git status`, `git log -5`, run the tests) before building on it. Then continue with the
step named under **Next**.
