---
name: ship
description: Pre-release checklist before deploying or publishing — build, environment variables, migrations, backups, rollback, security basics and a smoke test after release. Use before the first deploy, before every release that changes data or auth, and whenever the user says "deploy", "go live" or "publish".
---

# Ship

Goal: release without surprises, and know how to undo it if something goes wrong. Deploying is the
user's call: prepare everything, show the checklist, and run the deploy only when they say so.

## Before the release

1. **Clean state.** All `PLAN.md` steps meant for this release are `done` and reviewed. Working tree
   committed. The full test suite, lint, type check and a production build pass **locally**.
2. **Final review.** Run `review` on everything since the last release
   (`git diff <last-release-tag>...HEAD`), with the security checklist in full. Blockers stop the
   release.
3. **Environment variables.** Every variable the code reads is set in the target environment, with
   production values (not test keys, not `localhost`). No secret has a public prefix. Compare the code
   against the hosting settings, not against memory.
4. **Data.**
   - Migrations: listed, reviewed, and applied in the right order relative to the code (usually
     migrations first, written so the old code still works with the new schema).
   - **Backup** of the production database exists and is recent, before any migration that changes or
     drops data.
   - Seed or test data is not going to production.
5. **Security basics in production.** Debug mode off, verbose errors off, test accounts removed or
   disabled, row-level security or security rules on, rate limits on paid and auth endpoints,
   HTTPS everywhere.
6. **Rollback plan, written before deploying.** How to go back: the previous deployment or tag, and
   what to do about migrations (down migration, restore from backup). One or two lines in the release
   notes.
7. **Release notes** for the user, in plain words: what changes for their users, what to watch.

Show the user this list with each item ticked or explained, and wait for the go-ahead.

## After the release

1. **Smoke test** on production: open the app, log in, do the one or two actions that matter most
   (sign up, pay, the main feature). Check that nothing private is reachable logged out.
2. **Watch** logs and error tracking for a while after the release.
3. **Tag** the release in git (`git tag v1.4.0`), so the next `ship` knows where to diff from.
4. Something wrong? Follow the rollback plan first, debug second.
