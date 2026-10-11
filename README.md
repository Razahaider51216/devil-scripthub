# DEVIL HUB - shared-loading-3

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader?v=vm-1"))()
```

Rejoin before switching from an older release or from the Lucy preview test.
The loader supports Ride a Pet, Break and Steal an Egg, Loot to Forge,
Build An Ant Empire and Steal an Egg. Only the selected map is downloaded.

- Shared silver logo from the owner's supplied `logo.png`, with one versioned
  executor asset cache. No image regeneration or image substitutions.
- DEVIL HUB community link: https://discord.gg/fDwPCmpkkh.
- Compact 320x112 dark/blue loading card with silver logo, progress percentage,
  finite animation, mobile/desktop scaling and short failure captions. Detailed
  startup errors are saved in `DevilHub_LoadError.json`.
- All five maps share one loading screen with the main router. Nested startup
  stages borrow the screen; only the final owner closes it. Legacy Break and
  Steal loading cards and GUI-library loading overlays no longer stack behind it.
- Ride readers and GUI construction yield in startup batches. Stages now have
  distinct percentages instead of all showing 65%. OuroFlow constructors receive
  the silver logo for the window and floating icon before they create the UI.
- Ride startup now copies environment fields rather than cloning the protected
  environment table exposed by Delta. Its original metatable stays untouched.
- Break and Steal an Egg's Fly speed supports 1-600 studs/s independently of
  game WalkSpeed. Character motion is restored when flight ends or is cancelled.
- break-flight-4 removes the anchoring introduced by the earlier flight change,
  preserves unanchored flight and checks arrival before the first hit. Motion
  cleanup is also tested when Pet Carry takes over during a pending flight.
- Ride a Pet now uses the predecoded Lucy runtime that the owner verified in
  game. The original protected VM/data and game systems are retained. A GUI
  adapter changes visible branding and Discord copy behavior; it does not
  replace farm/remotes/controls. Original layout is retained.
- Startup-only VM protection: game and GUI callbacks now use the executor's
  native Luau compiler, avoiding our additional interpreter in ongoing work.
  Payload decoding yields and bounds temporary character buffers.
- Startup/duplicate guards prevent repeated active map launches.
- A bounded 20-second frame sample writes `DevilHub_Performance.json` once,
  then disconnects. This records client frame times, not script-exclusive CPU.

Checks passed: syntax for all eight public entries/dependencies; native-source
transfer integrity and argument/return holes; all five universe/place routes;
network retries/failure cleanup; complete Loot host (10 tabs, 100+ controls,
15 checks); branding/clipboard/callback preservation, loading bounds and finite
sampler cleanup. This update additionally passes a protected-metatable Ride
wrapper regression and Break flights at game WalkSpeed 16/250/1000, including
cancellation, errors and unload. Break's source changes are limited to flight
motion/cancellation and the slider range; pickup/hit/remotes remain unchanged.
Lucy VM/data remain exact.

Live FPS and the new Ride branding have not been verified by the build machine.
If an issue remains, share `DevilHub_Performance.json`,
`DevilRideLucyTest-report.json` and `DevilRideBrand-report.json` as applicable.
The latter records identified GUI roots and branding changes. Third-party
protected runtimes and server/network latency can still cause stalls.

See [protection details](vm-protection-README.md) and
[performance review](performance-review-README.md).
