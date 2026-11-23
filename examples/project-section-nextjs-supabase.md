# Example: a filled-in Project section

What the `setup` skill might write into `AGENTS.md` for a typical Next.js + Supabase app. Short, exact,
and honest about what it could not confirm.

```markdown
## Project

- What it is: Invoicing app for freelancers: clients, invoices, PDF export, Stripe payments.
- Stack: Next.js 15 (App Router, TypeScript), Supabase (Postgres, Auth, Storage), Stripe, Tailwind. Hosted on Vercel.
- Run locally: `npm run dev` (needs `.env.local`, see `.env.example`; local Supabase via `npx supabase start`)
- Tests: `npm test` (Vitest, 23 tests, all passing). No end-to-end tests yet.
- Lint / format / type check: `npm run lint`, `npm run format:check`, `npx tsc --noEmit`
- Secrets live in: `.env.local` (in .gitignore, not tracked). `SUPABASE_SERVICE_ROLE_KEY` and
  `STRIPE_SECRET_KEY` are server-only; only `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` are public.
- Sensitive areas: `app/api/stripe/webhook` (payments), `lib/supabase/admin.ts` (service role),
  RLS policies in `supabase/migrations`, invoice PDFs in Storage (bucket `invoices`, private),
  `app/api/ai/summary` (calls a paid AI API).
- Unverified: whether RLS is enabled on the `clients` table in production (can't reach production).
```
