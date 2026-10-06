# DEVIL DUMP

Independent universal client utility based on ValenHub. Uses the same OuroFlow
Abyss blue/black interface, Devil logo and Discord invite as Devil Hub.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil-dump.lua?v=3"))()
```

Rejoin before switching from an already running ValenHub version. The previous
`valen-standalone.lua` entry forwards here. The four-game `loader` is unchanged;
DEVIL DUMP is a separate script with no Place ID allowlist.

Original categories and controllers remain: Player, Dumper, Remotes, Explorer,
Contact and Settings. Includes movement, map/script/client-runtime/remote
exports, remote recording, DEX inspection and configuration management. The
visible controls drive the original native controllers; native configuration
loading and saving are retained. The old native window is hidden. DEX keeps its
specialized layout with updated branding and colors.

Discord and community links: https://discord.gg/ZY7PRcVJe2
Default export/config folders are `DevilDump_Dumps` and `DevilDump_service`.
Existing `ValenHub_service` configurations are not automatically migrated.

Changes in this release:

- Replace deprecated BodyVelocity/BodyGyro flight with LinearVelocity and
  AlignOrientation; clean up on respawn and disable, update speed without
  rebuilding constraints, support joystick motion and touch up/down buttons.
- Restore each part's original collision value when disabling Noclip, removing
  a part or respawning; cache parts instead of scanning the character each frame.
- Support Humanoid UseJumpPower and JumpHeight; reject invalid numeric settings.
- Yield during large export and explorer traversals, and cancel those jobs when
  the hub closes.
- Pause remote recording at 5,000 events, retain the captured records for export,
  copy argument arrays and throttle status redraws. Save and clear to resume.
- Disconnect tracked listeners, restore owned remote hooks and movement values,
  remove owned GUIs and block duplicate launches. If another script has replaced
  the recorder's hook, rejoin before restarting to avoid stacking hooks.
- Add loading progress, HTTP timeouts and a failure/retry path; pin both UI
  dependencies to the reviewed revisions.
- Fix DeltaX startup with a protected executor environment metatable: inherit
  globals through a private overlay instead of cloning the protected table.
  Display the actual startup error with a Copy error button, and propagate
  native BuildHub failures instead of leaving an empty or partial GUI.

Validation: official Luau compilation for all components; isolated tests for
controller callbacks and configuration synchronization, movement restoration
and respawn, recorder bounds, cleanup, duplicate guards, failures/retry and nil
argument forwarding. Packed payload roundtrip matches the reviewed source
byte-for-byte. No real game actions or webhook messages were executed during
these tests. Roblox/DeltaX still requires a live user run.

Universal means no game-specific routing or allowlist. Server-only objects and
scripts are not available to this client tool. Streaming can omit unloaded
objects. Source recovery, file export, remote hooks and saveinstance depend on
the executor's available APIs; this release cannot guarantee every operation
on every game. Client-side packing does not guarantee source secrecy.

Original attribution: VALEN HUB / valen_vct. Recovery provenance is recorded in
[valen-standalone-README.md](valen-standalone-README.md). UI dependencies:
[OuroFlow c8251f7](https://github.com/joustingmatch/OuroFlow/tree/c8251f76f74d9942114ebccb0564aa0ac196320a),
[Rayfield-Plus c89802b](https://github.com/72msreal-pixel/MySoure/blob/c89802b88f4c6e1cb1bff1bd4585367247d17434/Rayfield-Plus.luau).
