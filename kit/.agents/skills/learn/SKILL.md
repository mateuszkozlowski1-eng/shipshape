---
name: learn
description: Turn a mistake into a lesson the project keeps, so it does not happen twice. Propose it in LESSONS.md, let the user decide, then make it stick as a test, a check or a project rule. Use when the user corrects you ("you skipped the tests again"), when review finds the same problem a second time, after a bug whose cause you could repeat, and at handoff.
---

# Learn

Goal: every mistake is made once. The agent does not remember the last session; the project does, if
the lesson is written where the next agent will meet it.

## When to propose a lesson

- The user corrects how you work: "you skipped the tests again", "don't touch the migrations".
- `review` finds a problem **of the same kind** as an earlier finding or an earlier lesson.
- A bug's root cause was a wrong assumption, a missing check or a habit that will come back.
- A step needed three or more attempts, or hit the `debug` stop rule, for a reason that is not
  specific to this one bug.
- `done` showed that something was claimed but never verified.

Not a lesson: a one-off typo, a fact the code already makes obvious, a decision (that goes to
`DECISIONS.md` with the `decide` skill), or anything you already fixed with a test that prevents it.

## How

1. **Write it down as a proposal.** One line at the top of the list in `LESSONS.md`:
   `date — what went wrong, as a fact — the lesson — proposed`.
   The fact is concrete ("orders endpoint returned other users' orders"), not a mood ("be more careful").
   The lesson is something an agent can do or check, not a wish.
2. **Ask the user** in one line: the lesson, and where you suggest it should live (step 3).
   Don't adopt a lesson on your own. The user knows whether it was a one-off.
3. **Make it stick.** After a yes, put it in the strongest place that fits, in this order:
   1. **a test** that fails if the mistake happens again;
   2. **a check** the tools run: lint rule, type, pre-commit hook, CI step;
   3. **a line in `AGENTS.md`** under `## Project rules`, short and concrete;
   4. **a line in a skill's checklist** in this project (for example the review security checklist).

   Then set the status in `LESSONS.md` to `adopted → <where>`. After a no, set `dropped (<why>)`.
4. **Keep the rules short.** If `## Project rules` grows past about fifteen lines, propose merging or
   removing rules that a test or check now covers. Rules nobody reads protect nothing.

## Lessons for Shipshape itself

If a lesson is not about this project but about how agents work in general (a gap in a Shipshape skill,
a rule every project would want), tell the user. They can suggest it upstream with an issue at
https://github.com/mateuszkozlowski1-eng/shipshape/issues. Don't open the issue yourself.
