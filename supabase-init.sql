-- Kjør dette i Supabase SQL Editor (Dashboard → SQL Editor → New query → lim inn → Run)
-- Oppretter tabell for sync + åpne policies slik at anon-nøkkelen kan lese/skrive
-- (sikkerhet = den hemmelige sync-koden din, ikke auth)

create table if not exists public.sync_state (
  code text primary key,
  state jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.sync_state enable row level security;

drop policy if exists "anon_read" on public.sync_state;
drop policy if exists "anon_write" on public.sync_state;
drop policy if exists "anon_update" on public.sync_state;

create policy "anon_read"   on public.sync_state for select using (true);
create policy "anon_write"  on public.sync_state for insert with check (true);
create policy "anon_update" on public.sync_state for update using (true) with check (true);

-- ferdig — tabellen er klar til bruk fra appen
