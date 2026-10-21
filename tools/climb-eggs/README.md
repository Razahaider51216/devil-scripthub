# Climb for Eggs — Steal control and language synchronization

Release `climb-training-bonus-20261021-13`, universe 10765490774,
place 85738654635245. Keeps the existing DEVIL HUB interface, blue/white
presentation, saved settings, filtering, return, claiming and other jobs.
Training bonus repair: the previous listener only saw new signals, marked
failed/no-op claims consumed and left the native floating icons on screen.
Auto Treadmill now includes bonus collection; Auto Training Bonuses also works
when the player starts training manually. The existing one-second job worker
collects current General children with the exact ClaimTmMultiplier/Id attributes,
checks session/animation readiness, retries thrown failures, deduplicates per
session and unlinks/destroys claimed frames. Each tick sends at most eight claims.
No whole-GUI scans, virtual mouse clicks or new per-frame loops are added.
Claims are request counts, not server-confirmed reward counts. The native contract
comes from Dump1 Run_20261016_180246_1 treadmillController, treadmillMultiplier
and claimTmMultiplierAction. Bonus regressions cover existing/new buttons,
readiness, retry, duplicate/stale events, session reuse, batches, stop and unload.

The shared language selector previously changed its own language while the
native Climb renderer kept its independently saved Thai value. The native UI
now binds to the shared selection. Native labels/statuses rebuild first, then
shared overlays refresh; active core, automation and filter values are retained.
Startup and manual profile restore respect the language currently shown in the
shared selector. Saving a profile records that synchronized language.
There is one shared selector; standalone operation retains its fallback button.
Native SetLanguage calls update the shared selection, and unload/shared-module
teardown restore the original presentation methods without stacking bindings.
Report messages retain a canonical English source for switching back from Thai.
The added Thai status strings are preserved as UTF-8 instead of question marks.

`python tools/climb-eggs/test-language.py` reproduces the old split using the
actual previous UI, then exercises the actual shared dropdown and new native
renderer: 33 checks covering startup, repeated EN/TH changes, dynamic statuses,
Thai text encoding, saved profiles, native API, automation preservation and cleanup.

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
