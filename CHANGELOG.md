# Changelog

## 0.2.0

- New `learn` skill and `LESSONS.md`: when the user corrects the agent or review finds the same
  mistake twice, the agent proposes a lesson; after the user's yes it becomes a test, a check or a
  line under the new `## Project rules` section of `AGENTS.md`. General lessons can go upstream as a
  Shipshape issue.
- `AGENTS.md`: rule 9 (Learn from mistakes), `learn` in the Skills table, `## Project rules` section.
- `review` reads `LESSONS.md` and flags repeated mistakes; `done`, `debug` and `handoff` call `learn`
  when it fits.
- Installers copy `LESSONS.md` (never overwriting) and point out when an existing `AGENTS.md` predates
  the learn skill.

**Upgrading from 0.1.0:** run the installer with `--update-skills` (`-UpdateSkills`), then copy rule 9,
the `learn` row and the `## Project rules` section from `kit/AGENTS.md` into your `AGENTS.md`.

## 0.1.0

First version: `AGENTS.md` rules, eight skills (setup, plan, done, review with security checklist,
debug, decide, ship, handoff), secret-scan pre-commit hook, installers for macOS/Linux and Windows,
per-tool notes and everyday prompts.
