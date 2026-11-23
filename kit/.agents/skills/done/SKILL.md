---
name: done
description: Checklist to run before saying a step or task is done — proves it works, reviews and cleans the diff, and reports honestly what was and was not verified. Use every time before telling the user something is finished, fixed or working.
---

# Done

"Done" is a claim. This skill turns it into evidence. Run it before every "finished", "fixed" or
"works".

## Checklist

1. **It ran.** The changed behaviour was exercised in this session:
   - New or changed behaviour has a test that **would fail without your change**. A test that passes
     either way proves nothing.
   - No test framework? Do the exact manual check from the plan (command, URL, clicks) and write down
     what you saw.
2. **Nothing else broke.** Run the full test suite, lint, type check and build from `AGENTS.md`. A
   failure you did not cause still gets reported, not hidden.
3. **Read your own diff** (`git diff`) as if someone else wrote it:
   - leftover debug output, commented-out code, stray `TODO`s, temporary files;
   - changes unrelated to the step;
   - secrets, real personal data, hard-coded URLs or credentials;
   - tests deleted, skipped or weakened to make the suite pass. Never allowed without the user's
     explicit yes.
4. **The unhappy paths.** For the code you touched: empty input, invalid input, a logged-out user,
   another user's data, a network or service failure. Handled, or consciously out of scope?
5. **Review.** Run the `review` skill on the change, with fresh eyes if your tool allows. Fix every
   blocker before you go on.
6. **Paperwork.** Update the step's status in `PLAN.md`. Run `decide` if you decided something, and
   `learn` if the user had to correct you or review caught a repeated mistake.
7. **Commit** with a message that says what changed and why, if the user lets you commit.

## Report

Tell the user, in a few lines:

- what changed (behaviour, not file names);
- how you verified it (which tests, which manual check);
- what is **not** verified or not handled yet.

Never write "should work", "probably fixed" or "tests should pass". Either you ran it and say so, or
you didn't and say that.
