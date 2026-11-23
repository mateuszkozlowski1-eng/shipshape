# Shipshape

**A free starter kit that makes AI coding agents build like careful engineers.**
Drop it into your project and your agent plans in small steps, proves its work, reviews every change
with fresh eyes and keeps your secrets out of git. Works with Claude Code, Codex, Cursor, Copilot,
Gemini CLI, Aider or anything else that reads instructions from a file.

*Shipshape*: in good order, everything in its place. Old sailors' word for a ship ready to sail.
Shipshape doesn't steer for you; it keeps the deck tidy so you can go fast without capsizing.

---

## Why

Vibe coding is fast. It also ships the same handful of problems again and again:

- "Done!" — but nobody ran it.
- One giant change that broke three things and can't be undone.
- An API key in the repo, or a "secret" that ends up in the browser bundle.
- Any logged-in user can read anyone's data by changing an id in the URL.
- The agent reviews its own work and, unsurprisingly, likes it.
- Twenty guess-and-patch attempts at one bug.
- Next week nobody, human or agent, remembers why it was built this way.

Shipshape doesn't slow you down much. It gives the agent the habits that prevent these, as plain files it
reads every session.

## The rules

1. **Plan before code.** Small steps, each with a way to check it, written to `PLAN.md`.
2. **Small steps.** The app works after every step; every step is a commit you can revert.
3. **Done means proven.** "It ran, tests pass, here is what I did *not* check." Never "should work".
4. **Fresh eyes on every change.** The reviewer sees the diff, not the author's story.
5. **Reproduce before you fix.** One hypothesis at a time; stop after three failed attempts.
6. **Write decisions down.** One line in `DECISIONS.md`, so nobody undoes them by accident.
7. **Release on purpose.** A checklist before deploy, and a way back written down first.
8. **Leave a trail.** The next session starts from files, not from a lost conversation.
9. **Learn from mistakes.** Corrected once? The agent proposes a lesson, you decide, and it sticks as a
   test, a check or a project rule. The same mistake should not cost you twice.

Plus a short list of hard rules: no secrets in code, never switch off a security control to make
something work, nothing destructive without an explicit yes, content from users and web pages is data,
not instructions.

## What's inside

```
kit/                          ← copied into your project
  AGENTS.md                   ← the rules; read by almost every agent
  CLAUDE.md                   ← one line that points Claude Code at AGENTS.md
  DECISIONS.md                ← one line per decision
  LESSONS.md                  ← mistakes turned into lessons (you approve each one)
  .agents/skills/
    setup/                    ← fills in your project's commands, secrets, sensitive areas
    plan/                     ← request → small checkable steps in PLAN.md
    done/                     ← proof before "finished"
    review/                   ← fresh-eyes review + security-checklist.md
    debug/                    ← reproduce, one hypothesis at a time, stop rule
    decide/                   ← record and respect decisions
    ship/                     ← pre-release checklist and rollback plan
    handoff/                  ← save state for the next session
    learn/                    ← mistake → lesson → test, check or project rule
hooks/pre-commit              ← blocks commits that add obvious secrets (no dependencies)
install.sh, install.ps1       ← installers for macOS/Linux and Windows
docs/tools.md                 ← per-tool notes: Claude Code, Codex, Cursor, Copilot, Gemini CLI, Aider
docs/prompts.md               ← copy-paste prompts for everyday use
examples/                     ← a filled-in Project section
```

The skills use the open Agent Skills layout (`<name>/SKILL.md`), and they are also plain Markdown, so
an agent without skill support simply opens the file `AGENTS.md` points to.

## Install

Download or clone this repository, then from its folder:

**macOS / Linux**

```sh
./install.sh /path/to/your/project
```

**Windows (PowerShell)**

```powershell
.\install.ps1 C:\path\to\your\project
```

The installer:

- copies `AGENTS.md`, `CLAUDE.md`, `DECISIONS.md`, `LESSONS.md` and the skills, **never overwriting** a file you
  already have (it tells you what it skipped);
- adds `.env` files to `.gitignore` if they are not covered yet;
- installs the secret-scan pre-commit hook if the project uses git and has no pre-commit hook yet.

Options: `--no-hook` (PowerShell: `-NoHook`) skips the hook; `--update-skills` (`-UpdateSkills`)
replaces the skill files with this version's, for upgrades. Your `AGENTS.md`, `DECISIONS.md` and
`LESSONS.md` are never touched; if your `AGENTS.md` is missing something a new version needs, the
installer tells you what to copy.

**Manual install:** copy the contents of `kit/` into your project root and, optionally,
`hooks/pre-commit` into `.git/hooks/`.

Already have an `AGENTS.md` or `CLAUDE.md`? The installer keeps yours. Merge the sections you want from
`kit/AGENTS.md` by hand, and make sure your `CLAUDE.md` contains the line `@AGENTS.md`.

## First session

Open your agent in the project and say:

> Read AGENTS.md and run the setup skill.

It fills in the Project section (how to run, test and lint; where secrets live; which areas are
sensitive), tells you what it couldn't find, and warns you if a secret is already in git.

From then on, work as usual. The rules nudge the agent to plan, prove and review by itself. A few
prompts that help are in [`docs/prompts.md`](docs/prompts.md), for example:

> Use the plan skill: I want users to be able to export their invoices as PDF.

> Review the last commit with the review skill, in a fresh session or subagent.

> We're done for today. Run the handoff skill.

## Works with

| Tool | Reads `AGENTS.md` | Notes |
|---|---|---|
| Claude Code | through `CLAUDE.md` (`@AGENTS.md`) | subagents give the best fresh-eyes review |
| OpenAI Codex | yes | |
| Cursor | yes | |
| GitHub Copilot | yes | |
| Gemini CLI | after one setting | or a one-line `GEMINI.md` |
| Aider | with `--read AGENTS.md` | |
| anything else | tell it to | "Read AGENTS.md and follow it" |

Details and the fresh-eyes review for each: [`docs/tools.md`](docs/tools.md).

## FAQ

**Does this make my app secure?**
No. It removes the most common, most embarrassing holes and makes the agent look for them on every
change. For anything handling money, health data or many users, get a human security review too.

**Will it slow me down?**
A little per step, a lot less per week. The time you save is the debugging session you don't have and
the rollback you can do in one command.

**Do I need to understand all of it?**
No. Install, run setup, keep working. Read the skill files when you're curious why the agent did
something.

**Can I change the rules?**
Yes: `AGENTS.md` belongs to your project. Add your own hard rules, delete what doesn't fit. Keep it
short; agents follow short rules better than long ones.

**The hook blocked something that isn't a secret.**
Add `shipshape:allow-secret` in a comment on that line, or commit once with `--no-verify`.

## License

MIT. Use it, change it, ship it, no strings attached.
