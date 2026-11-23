---
name: debug
description: Find and fix a bug by reproducing it first and testing one hypothesis at a time, with a hard stop after three failed attempts. Use for any error, crash, wrong result or "it worked yesterday", instead of guessing at patches.
---

# Debug

Goal: fix the cause, once. The usual failure is a loop of guesses, each adding a patch, until nobody
knows which change did what.

## Steps

1. **Reproduce.** Exact steps or input, what happens, what should happen. Get the real error message
   and stack trace, not a paraphrase. Can't reproduce? Gather evidence (logs, the request, the data,
   browser console) before touching code.
2. **Pin it with a test** when you can: a test that fails because of the bug. It proves the fix later
   and keeps the bug from coming back.
3. **Narrow it down.** Where does correct turn into wrong? Check inputs and outputs along the path.
   `git log` and `git diff` against the last known good version are often the fastest clue
   ("it worked yesterday" → what changed since?).
4. **One hypothesis at a time.** Write down the likely cause, then check it with **evidence** (a log
   line, a debugger, a query, a print) before changing code. Wrong? Undo any experiment and take the
   next hypothesis.
5. **Fix the cause, not the symptom.** Smallest change that removes the cause. If the cause is in a
   design decision, say so; don't pile workarounds on top.
6. **Prove it.** The test from step 2 passes, the full suite passes, the original reproduction now
   behaves. Remove debug logging. Then run `done`.

## Stop rule

After **three** failed fix attempts: stop. Revert the experiments (`git checkout -- <files>` or
`git stash`), and tell the user what you know: what you tried, what you ruled out, what you suspect
next. A fresh look (the user, a new session, a different model) beats attempt number four.

## Never

- Catching and swallowing the error so it "goes away".
- Switching off the check, validation, type or test that complains.
- Raising timeouts or adding retries without knowing why it is slow or failing.
- Deleting or loosening a test because it fails.
- Changing several things at once and keeping whatever "worked".
