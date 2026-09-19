-- Wildverteilung V0.14.0 – zentraler synchronisierter App-Zustand
-- Einmal im Supabase SQL Editor ausführen.

create table if not exists public.app_state (
  id uuid primary key,
  daten jsonb not null default '{}'::jsonb,
  geaendert_am timestamptz not null default now()
);

alter table public.app_state enable row level security;

grant select, insert, update on public.app_state to authenticated;
revoke all on public.app_state from anon;

drop policy if exists "aktive_paechter_app_state" on public.app_state;
create policy "aktive_paechter_app_state"
on public.app_state
for all
to authenticated
using (public.ist_aktiver_paechter())
with check (public.ist_aktiver_paechter());
