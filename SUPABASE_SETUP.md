# Supabase setup

After creating the Supabase project and adding its Project URL and publishable key to `.env.local`:

1. Open **Supabase Dashboard → SQL Editor → New query**.
2. Copy and run the full contents of [20261108_initial_schema.sql](supabase/migrations/20261108_initial_schema.sql).
3. In **Authentication → Providers**, enable Email and allow new users to sign up.
4. In **Authentication → URL Configuration**, set the Site URL to `http://localhost:3000` and add `http://localhost:3000/**` as a redirect URL.

The SQL creates the `scan_history` table, row-level security policies, and the `avatars` storage bucket required by the dashboard, history, reports, diagnosis, and settings pages.
