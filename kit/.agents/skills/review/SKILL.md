---
name: review
description: Independent review of a finished change for correctness and security, done with fresh eyes from the diff alone, ending in a PASS or FIX verdict with concrete findings. Use after every step (the done skill calls it), before merging, and whenever the user asks for a review.
---

# Review

Goal: catch what the author could not see. The author knows what the code *should* do and reads that
into it. The reviewer sees only what the code *does*.

## Inputs, and what to leave out

Give the reviewer:

- the diff: `git diff` for uncommitted work, `git diff <base>...HEAD` for a branch, or
  `git show <commit>`;
- the step being reviewed (its line from `PLAN.md`, or the user's request);
- `AGENTS.md` and `DECISIONS.md`.

**Do not** give it the author's reasoning, notes, chat history or summary of "what I did". A review
anchored on the author's story confirms the story.

## Getting fresh eyes, whatever your tool

1. **Best:** a subagent or a separate agent with a fresh context, given only the inputs above.
2. **Good:** a new session or chat, given only the inputs above.
3. **Fallback:** the same agent. Then re-read the diff from the top as if you had never seen it,
   ignore your plan and notes, and look first for what would make the change wrong.

A different model than the one that wrote the code is a bonus, not a requirement. See
`docs/tools.md` in the Shipshape repository (https://github.com/mateuszkozlowski1-eng/shipshape) for how each tool starts a fresh agent.

## What to check

1. **Does it do the step?** All of it, nothing extra. Behaviour matches the request, not just the
   happy path.
2. **Tests.** Do they test the behaviour (would they fail if the change were wrong)? Are the important
   cases there? Was any test removed or weakened?
3. **Security.** In full for steps marked `⚠` or touching a sensitive area from `AGENTS.md`; a quick
   pass for the rest. Use `security-checklist.md` next to this file.
4. **Data.** Migrations safe to run and to roll back; deletes and updates scoped (no `DELETE` without
   `WHERE`); nothing that loses user data on an error.
5. **Fit.** Follows `DECISIONS.md` and the project's existing patterns; no second way of doing the same
   thing; no dependency added without a reason.
6. **Simplicity.** Code that could be much simpler, dead code, copy-paste that will drift apart.

## Output

```
Verdict: PASS | FIX

Findings:
1. [blocker] src/api/orders.ts:42 — any logged-in user can read any order.
   Scenario: user B calls GET /api/orders/<id of user A's order> → gets the full order.
   Fix: filter by owner (user_id = session user), return 404 otherwise.
2. [should] ...
3. [nit] ...

Not checked: <anything you could not assess, e.g. "did not run the app">
```

- `blocker`: wrong behaviour, security hole, data loss, broken build or tests. Any blocker → `FIX`.
- `should`: worth fixing now, but not dangerous.
- `nit`: style and taste. Keep these few.

Every blocker and should needs a **concrete scenario** (input or action → wrong result). No scenario,
no finding: "might be insecure" is not a finding. Don't pad the list; "no findings" is a valid review.

## After the review

The author fixes the blockers, then the reviewer looks again at **the fixes only**. Findings the author
disagrees with go to the user, with both views in one line each.
