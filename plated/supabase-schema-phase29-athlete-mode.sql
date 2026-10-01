-- Krafft — Phase 29: Krafft Athlete Mode. Run this once in the Supabase
-- SQL Editor against the existing live database. Fresh installs get it
-- automatically from reset-schema.sql instead.
--
-- Athlete Mode is additive — nutrition tracking, general lifting, the
-- standard Block Builder, achievements, and everything else are
-- untouched and stay accessible regardless of this toggle. Turning it on
-- just unlocks the Power & Speed / Functional-Athletic Block Builder
-- categories, a sport/position setup flow, a conditioning (speed/
-- agility) log, and a Pro-gated sports psychology section.
--
-- athlete_sport/athlete_position are plain text with NO check
-- constraint, deliberately — the valid-sport list (SPORTS in index.html)
-- lives in application code, same as every other extensible option set
-- in this app (BLOCK_FOCUS_OPTIONS, PLAN_TEMPLATES). Adding a second
-- sport later is a JS change, not a migration.
--
-- athlete_mode_unlocked_at (not just a boolean "has it ever been on")
-- is what the one-time unlock transition checks — null means the
-- transition hasn't played yet; once set, it never plays again even
-- after toggling off and back on.
--
-- athlete_game_plan is one jsonb blob (if-then plan + process goal) —
-- one row per user, no history needed — same "jsonb blob on profiles"
-- convention active_training_block already uses, rather than a whole
-- table for two short text fields.
alter table profiles add column if not exists athlete_mode_enabled boolean not null default false;
alter table profiles add column if not exists athlete_mode_unlocked_at timestamptz;
alter table profiles add column if not exists athlete_sport text;
alter table profiles add column if not exists athlete_position text;
alter table profiles add column if not exists athlete_game_plan jsonb;

-- Speed/agility/conditioning work doesn't fit the lifts table's
-- weight/sets/reps_per_set shape (all four are NOT NULL there) — a sprint
-- interval has a distance or a time, a ladder drill might just be a
-- completion checkmark. Kept as its own table rather than loosening
-- lifts' NOT NULL constraints, which would ripple into PR detection,
-- career volume, and the muscle map heatmap for every existing row.
create table if not exists conditioning_log (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  drill text not null,
  metric_type text not null check (metric_type in ('distance', 'time', 'completion')),
  distance_m numeric,
  duration_s numeric,
  completed boolean,
  notes text,
  date date not null,
  created_at timestamptz not null default now()
);

create index if not exists conditioning_log_user_date_idx on conditioning_log (user_id, date desc);

alter table conditioning_log enable row level security;

create policy "conditioning_log_select_own" on conditioning_log for select using (auth.uid() = user_id);
create policy "conditioning_log_insert_own" on conditioning_log for insert with check (auth.uid() = user_id);
create policy "conditioning_log_update_own" on conditioning_log for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "conditioning_log_delete_own" on conditioning_log for delete using (auth.uid() = user_id);

-- ── Sports psychology (Pro-tier) — adapted from the standalone "Show Up
-- Ready" app (github.com/odoglusk-dot/showup-ready), whose data model
-- this mirrors closely: journal_entries and confidence_entries there map
-- directly to the two tables below, one-to-one.
create table if not exists athlete_journal_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  what_went_well text,
  one_thing_to_improve text,
  mood int check (mood between 1 and 5),
  entry_date date not null default current_date,
  created_at timestamptz not null default now()
);

create index if not exists athlete_journal_entries_user_idx on athlete_journal_entries (user_id, entry_date desc);

alter table athlete_journal_entries enable row level security;

create policy "athlete_journal_entries_select_own" on athlete_journal_entries for select using (auth.uid() = user_id);
create policy "athlete_journal_entries_insert_own" on athlete_journal_entries for insert with check (auth.uid() = user_id);
create policy "athlete_journal_entries_update_own" on athlete_journal_entries for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "athlete_journal_entries_delete_own" on athlete_journal_entries for delete using (auth.uid() = user_id);

create table if not exists athlete_confidence_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  description text not null,
  source text not null default 'self' check (source in ('self', 'coach', 'teammate', 'other')),
  entry_date date not null default current_date,
  created_at timestamptz not null default now()
);

create index if not exists athlete_confidence_entries_user_idx on athlete_confidence_entries (user_id, entry_date desc);

alter table athlete_confidence_entries enable row level security;

create policy "athlete_confidence_entries_select_own" on athlete_confidence_entries for select using (auth.uid() = user_id);
create policy "athlete_confidence_entries_insert_own" on athlete_confidence_entries for insert with check (auth.uid() = user_id);
create policy "athlete_confidence_entries_update_own" on athlete_confidence_entries for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "athlete_confidence_entries_delete_own" on athlete_confidence_entries for delete using (auth.uid() = user_id);
