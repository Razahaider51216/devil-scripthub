# DEVIL HUB ? silver-native-1

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader?v=silver-native-1"))()
```

Rejoin before switching from an older release or from the Lucy preview test.
The loader supports Ride a Pet, Break and Steal an Egg, Loot to Forge,
Build An Ant Empire and Steal an Egg. Only the selected map is downloaded.

- Shared silver logo from the owner's supplied `logo.png`, with one versioned
  executor asset cache. No image regeneration or image substitutions.
- DEVIL HUB community link: https://discord.gg/fDwPCmpkkh.
- Centered dark/blue loading card, bounded on mobile and desktop screens.
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
14 checks); branding/clipboard/callback preservation, loading bounds and finite
sampler cleanup. Embedded Loot/Break game source was compared with the previous
release, allowing only Discord display-link updates. Lucy VM/data remain exact.

Live FPS and the new Ride branding have not been verified by the build machine.
If an issue remains, share `DevilHub_Performance.json`,
`DevilRideLucyTest-report.json` and `DevilRideBrand-report.json` as applicable.
The latter records identified GUI roots and branding changes. Third-party
protected runtimes and server/network latency can still cause stalls.

See [protection details](vm-protection-README.md) and
[performance review](performance-review-README.md).
