-- Plated (Kraft) — Phase 27: Group Mode goal metric (protein / calories /
-- weekly sessions). Run this once in the Supabase SQL Editor against the
-- existing live database. Fresh installs get it automatically from
-- reset-schema.sql instead.
--
-- Group Mode's shared streak was hardcoded to "everyone hit their own
-- protein goal today." This lets the group's creator (its "leader")
-- choose the streak metric instead, and change it anytime from the Group
-- tab's settings — not locked in at creation:
--   'protein'  (default) — same as before: each member's own daily
--               food_logs.protein_g sum >= their own goals.protein_g.
--   'calories' — same shape, against goals.calories instead.
--   'sessions' — a weekly target instead of a daily one: every member
--               must log at least sessions_target_per_week distinct
--               lift-dates in the trailing 7 days. Because this is
--               weekly rather than daily, a 'sessions' group's
--               current_streak counts weeks, not days, and
--               evaluate-groups.js only evaluates it once every 7 days
--               instead of daily — see that file's own comment for why.
--
-- sessions_target_per_week is only meaningful (and required) when
-- goal_metric = 'sessions'; left null otherwise.
alter table groups add column if not exists goal_metric text not null default 'protein' check (goal_metric in ('protein', 'calories', 'sessions'));
alter table groups add column if not exists sessions_target_per_week int check (sessions_target_per_week is null or (sessions_target_per_week between 1 and 14));

alter table groups add constraint groups_sessions_target_required check (goal_metric != 'sessions' or sessions_target_per_week is not null);
