-- JeevRaksha: run this entire file once in Supabase Dashboard -> SQL Editor.
-- It is safe to re-run and creates the records and avatar storage used by the app.

create extension if not exists pgcrypto;

create table if not exists public.scan_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  species text,
  vision_disease text,
  audio_status text,
  weight_kg numeric,
  bcs_score numeric
);

create index if not exists scan_history_user_created_at_idx
  on public.scan_history (user_id, created_at desc);

alter table public.scan_history enable row level security;

drop policy if exists "Users can view their own scans" on public.scan_history;
create policy "Users can view their own scans"
  on public.scan_history for select to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Users can add their own scans" on public.scan_history;
create policy "Users can add their own scans"
  on public.scan_history for insert to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can update their own scans" on public.scan_history;
create policy "Users can update their own scans"
  on public.scan_history for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

drop policy if exists "Users can delete their own scans" on public.scan_history;
create policy "Users can delete their own scans"
  on public.scan_history for delete to authenticated
  using ((select auth.uid()) = user_id);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('avatars', 'avatars', true, 2097152, array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do update
  set public = excluded.public,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Public avatar access" on storage.objects;
create policy "Public avatar access"
  on storage.objects for select
  using (bucket_id = 'avatars');

drop policy if exists "Users can upload their own avatar" on storage.objects;
create policy "Users can upload their own avatar"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'avatars' and (storage.foldername(name))[1] = (select auth.uid())::text);

drop policy if exists "Users can update their own avatar" on storage.objects;
create policy "Users can update their own avatar"
  on storage.objects for update to authenticated
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = (select auth.uid())::text)
  with check (bucket_id = 'avatars' and (storage.foldername(name))[1] = (select auth.uid())::text);

drop policy if exists "Users can delete their own avatar" on storage.objects;
create policy "Users can delete their own avatar"
  on storage.objects for delete to authenticated
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = (select auth.uid())::text);
