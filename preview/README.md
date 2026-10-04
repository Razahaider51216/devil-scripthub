# Devil Hub / new OuroFlow GUI test

Run in a fresh game session:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/preview/ride-a-pet-test.lua?v=live-6"))()
```

This preview now uses **OuroFlow / Airflow UI**, not the older ObsidianUltra GUI.
The upstream developer's `joustingmatch/v2test` references OuroFlow. The local
Ride a Pet recovery references the older ObsidianUltra dependency.

The new interface has an icon sidebar, player profile, search in the content
header, compact controls and collapsible groupboxes in two columns. Crimson
provides the dark red palette. The library adapts to narrow screens and includes
a draggable toggle button on the left and a draggable minimized island.

Only the GUI library is loaded. Ouroboros gameplay code is not executed.
Devil Hub categories, original option handles, callbacks, saved state and
visibility dependencies come from the unchanged original gameplay runtime.
Enabled toggles do not invoke gameplay a second time during frontend creation.
Native value updates use silent frontend setters. Advanced predictor/canvas
instances retain their connections inside clipped holders; their appearance is
still native. The native frame and launcher are hidden.

The UI dependency is fetched directly from its upstream repository, pinned to
commit `c8251f76f74d9942114ebccb0564aa0ac196320a`:
https://github.com/joustingmatch/OuroFlow

This dependency requires network access. Its Lucide icon registry is also fetched
by the library. No custom font or texture downloads are requested by this bridge.
The old Obsidian library/license files remain for the earlier preview history;
the current loader does not use them.

The HTTP adapter covers function calls and Roblox namecall dispatch while
keeping `loadstring` unchanged. A launch with only the original UI is rejected
as an unsuccessful GUI connection. Startup retains the loading overlay and
stage messages. This preview requires `hookfunction`; native namecall coverage
also uses `hookmetamethod` and `getnamecallmethod` when available.

Validation: official Luau compilation of the pinned upstream library, facade,
clear shell and packed entry; original-controller bridge mocks; facade tests
for columns, initial callbacks, silent updates, dropdown values, changed slider
ranges, frontend/native tab selection and cleanup; loading/error/retry checks;
exact pack roundtrip and original gameplay bytes. Actual Roblox/DeltaX layout
and touch behavior still need in-game testing. Production files are unchanged.
No test webhook or Discord messages are sent.

Native presentation cleanup: known Chilli logo assets also identify random-named
launcher GUIs. Every native top-level layer is hidden, including later additions.
The Chilli FPS/ping helper is identified by its exact native signature. Visibility
guards prevent the old engine reopening these layers. The OuroFlow frontend and
the game's own UI are exempt. Callback/state objects are retained, not destroyed.

The preview now also includes the production callback correction: native options
use `Set(value, true)`, with `SetValue` only as a compatibility fallback. Discord
renders a new Devil Hub community card rather than mounting the original canvas.
