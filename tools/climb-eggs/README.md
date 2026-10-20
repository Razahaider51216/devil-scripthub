# Climb for Eggs ? Steal control repair

Release `climb-steal-control-20261020-11`, universe 10765490774,
place 85738654635245. Keeps the existing DEVIL HUB interface, blue/white
presentation, saved settings, filtering, return, claiming and other jobs.

The prior published artifact's exact native compilation input is recovered
without invoking Roblox/game code in `test-boundary.py`. Its source SHA256 is
`b15922483d08c1f81557cbbcaa85237f72fc8b05e5651a444d0f431d745b5e03`.
`baseline-core.lua` matches that actual prior production core, not a toy model.

Reproduced defects in that core:
- Turning Farm off does not immediately release a held prompt. A retired worker
  can subsequently end a player's fresh manual hold.
- Off/on during a yield lets an old attempt resume and activate a stale target.
- An error while waiting for a hold exits without releasing input.
- The executor prompt fallback runs synchronously and can suspend the farm worker.
- Native input starts while the humanoid is still airborne.

The repair gives each attempt ownership and a cancellation generation. Farm Off,
Stop All and unload release its prompt immediately; late workers cannot release
new/manual holds. An xpcall finalizer covers errors, cancellation and timeouts.
The executor fallback runs in at most one bounded child task. Cancellation uses
`task.cancel` when supported. If cancellation is unavailable/fails, its pending
call remains tracked until it returns; no duplicate fallback calls are launched.
The global virtual-keyboard E fallback is removed because it can interfere with
manual interaction and activate a different on-screen prompt.

Approach points use several ground rays around the actual prompt. Valid points
must be inside activation range, supported by a walkable surface and have vertical
clearance. Missing floor, platform edges, roofs outside range and blocked standing
points cannot be reported as successful arrivals. The native fall state must settle
before holding. No server/game state is falsified; pickup still requires replicated
CarryingEgg confirmation. InputHoldBegin/End pairing follows Roblox's API:
https://create.roblox.com/docs/reference/engine/classes/ProximityPrompt

Run `python tools/climb-eggs/test.py`: 130 existing planner/runtime checks,
105 UI/settings checks, old-defect reproduction and repaired ownership/landing
regressions. `test-boundary.py` executes actual old/new public startup wrappers,
verifies exact native source, nil arguments/returns and rejects damaged payloads.
Fixtures simulate Roblox services/physics and do not establish live gameplay success.

Build `python tools/climb-eggs/build.py`, commit the entry, then run
`python tools/climb-eggs/build-main-loader.py ENTRY_COMMIT`. Only the Climb route
and version change. Keep all other maps' immutable pins. Validate public router
and published bytes after pushing. Roblox/executor behavior remains live-unverified.
