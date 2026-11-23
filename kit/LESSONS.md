# Lessons

What this project learned the hard way, so the same mistake does not happen twice. Agents propose
lessons; **the user decides** which ones stay. See `.agents/skills/learn/SKILL.md`.

Format, newest at the top:

```
- 2026-03-02 — <what went wrong, as a fact> — <the lesson> — <status>
```

Status is one of:

- `proposed`: waiting for the user's yes or no;
- `adopted → <where it lives now>`: for example `adopted → test orders.spec.ts`,
  `adopted → AGENTS.md project rules`, `adopted → review checklist`;
- `dropped (<why>)`: one-off, or not worth a rule. Kept so nobody proposes it again.

A lesson that only lives in this file is weak: agents read it only when a skill sends them here. The
strong ones end up as a test, a check or a line in `AGENTS.md`.

<!-- Example (delete it when you add your first real lesson):
- 2026-03-02 — Agent said the export was done, but the API tests were never run (user caught it) — run the full suite, API tests included, before "done" — adopted → AGENTS.md project rules
-->
