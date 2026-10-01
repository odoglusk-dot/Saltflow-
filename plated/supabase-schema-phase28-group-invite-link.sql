-- Plated (Kraft) — Phase 28: Group Mode shareable invite link. Run this
-- once in the Supabase SQL Editor against the existing live database.
-- Fresh installs get it automatically from reset-schema.sql instead.
--
-- Lets any current member (not just the creator) generate a short code
-- any friend-or-not can join the group with directly — no existing
-- in-app friendship required, unlike invite-to-group.js's friend-based
-- flow. One code per group at a time; generating a new one overwrites
-- the old one, immediately invalidating it (e.g. if it leaked publicly).
-- Expires 7 days after generation (set by generate-group-invite.js, not
-- a DB default, since "7 days from whenever it's generated" isn't a
-- fixed column default) — join-group-by-code.js checks both the code
-- and the expiry.
--
-- No client read/write policy at all: looking up a group by an
-- arbitrary invite_code the caller isn't a member of yet is exactly the
-- kind of cross-user read groups' own RLS is designed to prevent, so
-- both generating and redeeming a code go through service-role
-- functions only, same as every other group write.
alter table groups add column if not exists invite_code text unique;
alter table groups add column if not exists invite_code_expires_at timestamptz;

create index if not exists groups_invite_code_idx on groups (invite_code);
