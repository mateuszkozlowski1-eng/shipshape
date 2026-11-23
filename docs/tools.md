# Using Shipshape with your tool

Shipshape needs two things from a tool: **read `AGENTS.md`** at the start of a session, and ideally **start
a reviewer with a fresh context** for the review skill. Tools change fast; if something below is out
of date for your version, the universal fallback at the end always works.

## Claude Code

- **Rules:** Claude Code reads `CLAUDE.md`. Shipshape's `CLAUDE.md` contains `@AGENTS.md`, which imports the
  rules. If you already had a `CLAUDE.md`, add that line to it.
- **Skills:** Claude Code loads skills natively from `.claude/skills/`. Not required: `AGENTS.md`
  points to the files, and Claude opens them when a rule says so. If you want them as native skills
  (so they show up and trigger on their own), copy `.agents/skills/*` into `.claude/skills/`, or on
  macOS/Linux link them: `ln -s ../.agents/skills .claude/skills`.
- **Fresh eyes:** ask for a subagent: "Review the last commit with the review skill, in a subagent that
  gets only the diff, the step and AGENTS.md."

## OpenAI Codex (CLI, IDE extension, cloud)

- **Rules:** reads `AGENTS.md` natively.
- **Skills:** recent versions discover Agent Skills; `AGENTS.md` points to them either way.
- **Fresh eyes:** start a new task or session for the review, with the prompt from
  [prompts.md](prompts.md#review-in-a-fresh-session).

## Cursor

- **Rules:** reads `AGENTS.md` in the project root. Your existing `.cursor/rules` keep working next to
  it.
- **Fresh eyes:** open a new chat (not the one that wrote the code) and use the review prompt.

## GitHub Copilot (VS Code agent mode, coding agent)

- **Rules:** reads `AGENTS.md`. If you also use `.github/copilot-instructions.md`, add a line there:
  "Follow AGENTS.md."
- **Fresh eyes:** a new chat session with the review prompt. On pull requests, Copilot code review is
  a useful second opinion; it does not replace the security checklist.

## Gemini CLI

- **Rules:** Gemini CLI reads `GEMINI.md` by default. Either point it at `AGENTS.md` in its settings
  (the context file name setting in `.gemini/settings.json`), or create a `GEMINI.md` with one line:
  `Read AGENTS.md in this folder and follow it as your project instructions.`
- **Fresh eyes:** a new session with the review prompt.

## Aider

- **Rules:** start with `aider --read AGENTS.md`, or add `read: AGENTS.md` to `.aider.conf.yml` so it is
  always loaded.
- **Skills:** add the skill file you need with `/read .agents/skills/plan/SKILL.md`.
- **Fresh eyes:** run a second Aider session for the review, with the review prompt.

## Anything else (Windsurf, Cline, Zed, chat in a browser...)

Many tools read `AGENTS.md` by now. If yours doesn't, start each session with:

> Read AGENTS.md in the project root and follow it for this whole session.

For a fresh-eyes review in a plain chat, paste the review prompt from [prompts.md](prompts.md) together
with the output of `git diff`.

## Why a fresh context matters

An agent that just wrote the code remembers what it *meant* to do and reads that into the diff. A
reviewer who only has the diff, the step and the rules catches what is actually there. If your tool
can't start a separate agent, the review skill's fallback still helps: re-read the diff from the top,
ignore the plan, and look first for what would make it wrong.
