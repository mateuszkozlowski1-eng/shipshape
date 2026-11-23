# Security checklist

The usual ways apps built fast get hurt. Go through the sections the change touches. Every hit becomes
a finding with a concrete scenario (see `SKILL.md`).

## Secrets

- [ ] No API keys, passwords, tokens, connection strings or private keys in code, committed config,
      tests, logs or error messages.
- [ ] No secret reaches the browser or the mobile app bundle. Variables with a public prefix
      (`NEXT_PUBLIC_`, `VITE_`, `EXPO_PUBLIC_`, `REACT_APP_`, `PUBLIC_`) are visible to everyone.
- [ ] Admin and service keys (Supabase `service_role`, Firebase Admin, Stripe secret key...) are used
      only on the server.
- [ ] `.env` files are in `.gitignore` and not tracked (`git ls-files | grep -i env`).

## Who can do what (the most common hole)

- [ ] Every API route, server action and function that reads or changes data checks **who** is
      calling. Hiding a button in the UI is not protection.
- [ ] It also checks **whose** data it is: user B must not read or edit user A's record by changing an
      id in the URL or the request body.
- [ ] Admin-only actions check the role on the server.
- [ ] Supabase: row-level security is **enabled on every table**, with policies that match the rules.
      Firebase: security rules are not open (`allow read, write: if true`).
- [ ] Tokens are verified (signature and expiry), not just decoded.

## Input

- [ ] Database queries use parameters or the ORM, never strings built from user input.
- [ ] No user input in shell commands, file paths, `eval` or dynamic imports.
- [ ] Validation happens on the server. Client-side validation is only for comfort.
- [ ] HTML from users or from an AI model is not rendered raw (`dangerouslySetInnerHTML`, `v-html`,
      `innerHTML`, `{@html}`) unless it is sanitized.
- [ ] The server does not fetch user-supplied URLs without limits (internal addresses, cloud metadata
      endpoints).
- [ ] File uploads: type and size limited, files not served as HTML or scripts from your domain,
      storage bucket not public unless it should be.

## What goes out

- [ ] Responses return only the fields the client needs, not whole database rows (password hashes,
      other users' emails, internal flags).
- [ ] Errors shown to users carry no stack traces, SQL or internal paths.
- [ ] Logs carry no passwords, tokens or more personal data than needed.

## Sessions and cookies

- [ ] Session cookies are `HttpOnly`, `Secure` and have a `SameSite` setting.
- [ ] Logout ends the session on the server where there is one.
- [ ] Password reset and email links are single-use and expire.

## Money and abuse

- [ ] Prices and totals are calculated on the server, never taken from the client.
- [ ] Payment webhooks verify the provider's signature and are safe to receive twice.
- [ ] Endpoints that cost money per call (AI models, SMS, email, maps) require a logged-in user and
      have a rate limit or quota. An open AI endpoint can empty your account overnight.
- [ ] Login, sign-up and password reset have rate limits.

## AI features

- [ ] Text from users, documents or web pages that goes into a prompt cannot make the model do what it
      should not (call tools, reveal the system prompt, act for another user). Treat it as data.
- [ ] Model output is untrusted input: escaped before rendering, validated before it is used in
      queries, commands or tool calls.
- [ ] The model's tools can touch only what the current user is allowed to touch.

## Dependencies and configuration

- [ ] New packages exist under that exact name, are maintained and widely used (watch for typos and
      invented package names).
- [ ] The lock file is committed. Known vulnerabilities checked (`npm audit`, `pip-audit` or the
      stack's equivalent).
- [ ] Debug mode, verbose errors and test accounts are off in production.
- [ ] CORS is not `*` for endpoints that use cookies or tokens.

## Destructive operations

- [ ] Deletes and updates are scoped (`WHERE` clause, owner check).
- [ ] Migrations that drop or change columns have a way back (backup, two-step change).
- [ ] Bulk operations ask for confirmation before running on real data.
