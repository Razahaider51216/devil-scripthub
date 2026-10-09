# DEVIL DUMP

Independent universal client utility based on ValenHub. Uses the same OuroFlow
Abyss blue/black interface, Devil logo and Discord invite as Devil Hub.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil-dump.lua?v=dump-6"))()
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
- Fix native Slider startup by keeping AccentGlow as a numeric transparency,
  preserving the color fields separately. Validate the native slider reveal
  and refresh paths with the actual pinned library implementation.
- Fit DEX Explorer and its picking banner to ScreenGui safe bounds automatically,
  recompute on resize/rotation, and clamp mouse/touch dragging inside the screen.

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

## Map Analyst: dump-6

The new Map Analyst tab automatically analyzes accessible client instances and
exports a report on launch. It uses local, name-based analysis; it is not a
language model and does not call an AI API. Remote purposes are explicitly
marked as inferred, and accepted arguments/server validation remain unknown.

Exports go to the executor's file workspace, normally under
`DevilDump_Dumps/Map_<place>_<UTC timestamp>_<scan>/`:

- metadata.json: place/universe, capabilities, streaming, limits and scan errors.
- remotes.json: RemoteEvent, RemoteFunction and UnreliableRemoteEvent inventory,
  path segments, inferred category and observed argument-type shapes.
- map.json: accessible object hierarchy as path/class/name records.
- scripts.json: client-visible script metadata and source-export results.
- analysis.md: a readable summary and evidence/coverage notes.
- Optional source_*.lua files when Include accessible client script sources is on.

Sources are off by default. Source reads/decompilation depend on executor APIs;
each exported source is capped at 1 MB. ModuleScripts are not required or
executed by the analyst. No remote is fired/invoked by this scan. To add observed
usage, enable the existing Remotes recorder, interact with the game, then scan
again. The analyst keeps argument types/counts, including nil positions, and
does not retain argument values. The original recorder is unchanged apart from
feeding these observations and retains its existing full-record export behavior.

Analyze & Dump starts another scan; Export last analysis writes the last result.
Cancel scan stops further traversal/writes. Already written files remain listed
as partial output. Copy summary and Copy JSON work when setclipboard is available,
including executors that cannot write files. Use a relative export folder; path
traversal and absolute paths are rejected. Auto dump on launch can be disabled
for the current session. Source/folder choices are session settings.

Traversal yields every 100 objects and is bounded at 50,000 queued nodes. The
report marks truncation and inaccessible services/subtrees. Export files are
capped at 12 MB; write failures remain visible and the result can still be copied.
GUI unload cancels the analyst and prevents subsequent writes/jobs. These limits
keep the tool responsive and do not constitute a complete server/map dump.

There is no place allowlist, but client APIs cannot reveal server-only source or
provide a universal bypass. Streaming and executor differences affect coverage.
Connecting a real AI model requires a separately configured model/service; this
release sends no map data to an external service.

Validation: 25 analyst checks cover discovery, observed nil/type shapes, inferred
evidence, optional sources, export/read-only modes, relative paths, file failures,
limits, inaccessible trees, cancellation, partial output, GUI callbacks and unload.
Six integration checks exercise the existing frontend and recorder implementations
with the analyst attached. Official Luau compilation and exact packed source
roundtrip passed. Live Roblox/executor behavior remains unverified.
