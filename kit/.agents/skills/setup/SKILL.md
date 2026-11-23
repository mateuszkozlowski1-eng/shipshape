---
name: setup
description: Fill in the Project section of AGENTS.md (stack, run/test/lint commands, where secrets live, sensitive areas) by inspecting the repository. Use once after adding Shipshape to a project, and again when the stack or commands change.
---

# Setup

Goal: the Project section of `AGENTS.md` is short, exact and true, so every later session starts from
facts instead of guesses.

## Steps

1. **Read what is there.** `README`, package and build files (`package.json`, `pyproject.toml`,
   `requirements.txt`, `go.mod`, `Cargo.toml`, `*.csproj`, `composer.json`, `Gemfile`...), scripts
   folders, CI config, `docker-compose`, framework config files.
2. **Find the commands** to run the app, run tests, lint/format and type check. Prefer the scripts
   the project already defines (`npm run test`, `make test`) over raw tool calls.
3. **Try the safe ones**: tests, lint, type check, build. Never run deploys, migrations, seed scripts
   or anything that talks to production. Note what passed, what failed and what is missing.
4. **Find the secrets.**
   - Where do they live (`.env`, `.env.local`, a secrets manager)?
   - Is that file in `.gitignore`? Check with `git ls-files` that no env file or key file is tracked.
     **If a secret is in git, stop and tell the user first**: deleting the file is not enough, the key
     must be rotated, because it stays in the history.
   - Is any secret used in frontend code or behind a public prefix (`NEXT_PUBLIC_`, `VITE_`...)?
5. **Name the sensitive areas**: authentication and authorization, payments and webhooks, user data,
   file uploads, database migrations, admin pages, endpoints that call paid APIs (AI models, SMS,
   email).
6. **Fill in the Project section** of `AGENTS.md`. One line each. Mark what you could not confirm
   with `(unverified)`.
7. **Report to the user** in a few lines: what you filled in, what failed, what you could not find.
   Ask only about what you could not work out yourself.

## If there are no tests

Say so plainly. Propose the smallest setup that fits the stack (one test runner, one example test for
an existing function) and wait for a yes before installing anything. Until tests exist, the `done`
skill relies on exact manual checks, which is weaker: say that too.

## If there is no git

Propose `git init` and a first commit before any other work. Small steps and safe rollbacks depend on
it.
