# Everyday prompts

Short prompts that work in any tool once Shipshape is installed. The rules in `AGENTS.md` already push the
agent in this direction; these just say it out loud.

## Start

**First time in a project**

> Read AGENTS.md and run the setup skill.

**Every new session**

> Read AGENTS.md, PLAN.md and DECISIONS.md, check that PLAN.md still matches the code, then continue.

## Build

**A new feature**

> Use the plan skill: <what you want, in your own words>. Show me the plan, then build it step by step.

**Want to approve the plan first**

> Use the plan skill for: <feature>. Don't write code until I say go.

**Something small**

> <the change>. It's small, no plan needed, but run the done skill before you tell me it's finished.

## Check

**Before you trust "it's done"**

> Run the done skill and tell me exactly what you ran and what you didn't check.

### Review in a fresh session

Open a **new** session, chat or subagent (not the one that wrote the code) and paste:

> Use .agents/skills/review/SKILL.md to review this change. Get the diff with `git diff HEAD~1`
> (or: `git diff main...HEAD`). The step was: <one line from PLAN.md or your request>. Read AGENTS.md
> and DECISIONS.md. Don't look for the author's notes or plan. Give me the verdict and findings in the
> skill's format.

**Security pass on a risky area**

> Review <the login / payments / file upload / admin> code with the review skill, going through the
> whole security checklist, not only the last change.

## Fix

**A bug**

> Use the debug skill. What happens: <...>. What should happen: <...>. Steps to reproduce: <...>.

**The agent is going in circles**

> Stop. Revert the experiments, and tell me what you tried, what you ruled out and what you suspect.

## Decide, ship, stop

**Record a decision**

> Use the decide skill: we're going with <choice> because <reason>.

**Before going live**

> Run the ship skill for this release. Don't deploy; show me the checklist first.

**The agent made the same mistake again**

> You <skipped the API tests / touched the migrations / ...> again. Use the learn skill: propose a
> lesson and where it should live so it doesn't happen a third time.

**End of the day**

> Run the handoff skill.
