-- Krafft — Phase 30: Plyometric exercise library (Krafft Athlete Mode).
-- Run this once in the Supabase SQL Editor against the existing live
-- database. Fresh installs get it automatically from reset-schema.sql
-- instead.
--
-- Fills the 'power_speed'/'functional_athletic' Block Builder pools with
-- real content for the first time — phase18's own comment anticipated
-- this ("declared but unused until that exercise content exists"). Cues
-- are written for explosive, reactive movement specifically: landing
-- mechanics are called out as their own cue line (cue_mistake and/or
-- cue_bracing), not folded into "execution" the way a lift's cues are,
-- since how you land is the part most likely to go wrong and matters
-- most for injury risk.
--
-- No hypertrophy_* columns — these aren't hypertrophy-rep-range work, so
-- those stay null, same as every power_speed-tagged Olympic lift already
-- in the library.
--
-- Tagged with the 'impact' avoid_flag (declared in phase18, unused until
-- now) so a user who flags high-impact work to avoid in the Block
-- Builder won't get these — see BLOCK_AVOID_OPTIONS in index.html.
insert into exercises (
  name, muscle_group, body_region, secondary_regions, equipment,
  cue_setup, cue_execution, cue_mistake, cue_bracing,
  movement_type, lengthened_bias, avoid_flags, block_types,
  muscle_map_key, muscle_map_secondary_keys
) values
('Box Jump', 'Legs', 'legs', '{}', 'Bodyweight',
 'Stand arm''s length from a sturdy, stable box or platform, feet shoulder-width apart, knees soft.',
 'Swing your arms back, then drive them forward and up explosively while extending through the hips, knees, and ankles to jump onto the box.',
 'Landing with stiff, locked knees. Absorb the landing by bending your hips and knees the instant your feet touch down — don''t let your legs stay straight through impact.',
 'Brace your core before takeoff and keep it braced through landing, so the impact loads your legs and hips, not a collapsing lower back.',
 'plyometric', false, '{impact}', '{functional_athletic,power_speed}', 'quads', '{glutes,calves}'),

('Depth Jump', 'Legs', 'legs', '{}', 'Bodyweight',
 'Stand on a low box (roughly 12-18 inches), feet hip-width apart, near the front edge.',
 'Step off the box — don''t jump off — land on both feet, and the instant your feet touch the ground, explode straight up into a maximal vertical jump.',
 'Pausing on the ground before jumping back up. This turns one reactive movement into two separate ones — the point is a near-instant rebound, not a stop-and-go squat.',
 'Keep your torso tall and braced through the landing so the rebound is driven by your legs and hips snapping into the ground, not a trunk that folds forward.',
 'plyometric', false, '{impact}', '{functional_athletic,power_speed}', 'quads', '{glutes,hamstrings}'),

('Broad Jump', 'Legs', 'legs', '{}', 'Bodyweight',
 'Stand with feet shoulder-width apart, toes just behind a start line, knees slightly bent.',
 'Swing your arms back and load your hips, then drive forward and up explosively, extending fully through the hips and ankles to jump as far forward as possible.',
 'Landing off-balance or falling backward. Land with knees bent, absorbing through the hips, and stick the landing under control before resetting for the next rep.',
 'Brace your core on takeoff so the power comes from your hips and legs, and keep that brace through landing to control your forward momentum.',
 'plyometric', false, '{impact}', '{functional_athletic,power_speed}', 'quads', '{glutes,hamstrings}'),

('Lateral Bound', 'Legs', 'legs', '{}', 'Bodyweight',
 'Start balanced on one leg, knee slightly bent, the other leg lifted slightly off the ground.',
 'Push off hard to the side off the stance leg, driving through the hip to bound laterally, and land softly on the opposite leg with the knee tracking over the foot.',
 'Letting the landing knee cave inward toward the midline. Keep the knee aligned over the foot on landing to control the sideways force instead of absorbing it at the joint.',
 'Brace your core through each landing to stay stable on one leg before bounding back the other direction.',
 'plyometric', false, '{impact}', '{functional_athletic}', 'glutes', '{quads,calves}'),

('Single-Leg Bound', 'Legs', 'legs', '{}', 'Bodyweight',
 'Start in a slight single-leg athletic stance, knee soft, opposite arm back.',
 'Drive off the ground leg explosively, extending the hip fully, and bound forward to land on the same leg, absorbing through the hip and knee before bounding again.',
 'Landing flat-footed with a straight knee. Land on the ball of the foot with the knee bent to absorb the impact before the next bound.',
 'Keep your core braced and your landing leg stable under your hips on each touchdown, rather than reaching out in front of your body.',
 'plyometric', false, '{impact}', '{functional_athletic}', 'hamstrings', '{glutes,calves}'),

('Tuck Jump', 'Legs', 'legs', '{}', 'Bodyweight',
 'Stand with feet shoulder-width apart, knees soft, arms relaxed at your sides.',
 'Jump straight up as high as possible, driving your knees up toward your chest at the peak, then land softly back in the starting stance and repeat immediately.',
 'Landing with knees collapsing inward. Land with feet shoulder-width apart and knees tracking over the toes on every rep, even as fatigue sets in.',
 'Brace your core throughout to keep your trunk upright instead of leaning forward to generate the knee drive.',
 'plyometric', false, '{impact}', '{functional_athletic,power_speed}', 'quads', '{abs}'),

('Squat Jump', 'Legs', 'legs', '{}', 'Bodyweight',
 'Stand with feet shoulder-width apart, drop into a quarter-to-half squat.',
 'Explode upward out of the squat, extending hips, knees, and ankles fully to jump as high as possible, then land softly back into the squat position.',
 'Re-bending the knees too little on landing, so the impact goes straight into the joints. Land back into the same depth of squat you jumped from to absorb the force.',
 'Keep your core braced throughout the jump and landing to keep your torso upright rather than collapsing forward.',
 'plyometric', false, '{impact}', '{functional_athletic,power_speed}', 'quads', '{glutes}'),

('Medicine Ball Chest Pass', 'Chest', 'chest', '{}', 'Medicine Ball',
 'Stand or half-kneel facing a solid wall, holding the ball at your chest with both hands.',
 'Explosively extend your arms and push the ball into the wall as hard as possible, catching it on the rebound and resetting quickly for the next rep.',
 'Pushing only with the arms. Drive the pass with a quick extension through the chest and a slight hip snap, not an arm-only shove.',
 'Brace your core to keep your torso stable as you catch the rebound, rather than getting knocked backward by the ball''s momentum.',
 'plyometric', false, '{}', '{functional_athletic}', 'chest', '{delts,triceps}'),

('Medicine Ball Overhead Slam', 'Abs', 'core', '{}', 'Medicine Ball',
 'Stand with feet shoulder-width apart, holding the ball overhead with both hands, arms extended.',
 'Explosively flex at the hips and core, slamming the ball into the ground as hard as possible in front of your feet, then catch the bounce and reset.',
 'Rounding the lower back on the slam. Hinge at the hips and brace the core through the movement rather than letting the spine flex under load.',
 'Brace your core hard right as the ball leaves your hands — that brace is what transfers the power from your hips into the slam.',
 'plyometric', false, '{}', '{functional_athletic}', 'abs', '{lowerback}'),

('Medicine Ball Rotational Throw', 'Obliques', 'core', '{}', 'Medicine Ball',
 'Stand sideways to a solid wall, feet shoulder-width apart, holding the ball at hip height with both hands.',
 'Rotate your hips and trunk away from the wall slightly, then explosively reverse the rotation, releasing the ball into the wall at hip height, and catch the rebound.',
 'Rotating only through the arms and shoulders. The power should start from the hips turning first, with the trunk and arms following — not the other way around.',
 'Keep your core braced through the rotation so the force transfers through your trunk instead of loading your lower back at the end range.',
 'plyometric', false, '{}', '{functional_athletic}', 'obliques', '{abs}')
on conflict (name) do nothing;
