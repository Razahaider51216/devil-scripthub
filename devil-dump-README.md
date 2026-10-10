# DEVIL DUMP

Independent universal client utility based on ValenHub. Uses the same OuroFlow
Abyss blue/black interface, Devil logo and Discord invite as Devil Hub.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil-dump.lua?v=5"))()
```

Rejoin before switching from an already running ValenHub version. The previous
`valen-standalone.lua` entry forwards here. The five-game `loader` is unchanged;
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

## Item and reward Remote finder: dump-9

The existing `devil-dump.lua?v=5` link still loads this entry; the query is not a pinned Git version.

Open **Map Analyst → Item & Reward Remotes → Find Item / Reward Remotes & Dump**. Automatic Map Analyst scans also include this finder. It recognizes the seven requested names and related aliases, including underscores and RE/RF suffixes:

| Example name | Possible purpose |
| --- | --- |
| SpawnItem | Request item creation |
| GiveItem | Request or handle an item grant |
| PurchaseItem | Item purchase |
| ClaimReward | Reward claim |
| InventoryEvent | Inventory management/update |
| EquipItem | Item equipment |
| CraftItem | Item crafting |

Each matching client-visible Remote record includes its actual name, full path, class, matched alias, match type, possible purpose and existing observed call count/argument type shapes. Names are evaluated on the Remote itself; matching parent-folder names do not fabricate candidates. Unequip/Despawn names are excluded from EquipItem/SpawnItem classification.

The regular scan exports two additional files in its `DevilDump_Dumps/Map_.../` folder:

- `remote-candidates.json`: complete candidate list, map IDs and scan/truncation information.
- `remote-candidates.md`: seven-name match counts and up to 200 actual instances with their paths and possible purposes.

The GUI previews up to 12 matches and can copy the complete matching list as JSON. All purposes remain explicitly inferred (`purposeConfirmed=false`), including when a call has been observed. Accepted arguments, client/server direction and permissions are not established by a name. The finder does not fire remotes, require modules or send requests to an external AI service.

Validation: 38 analyst checks, 8 frontend/recorder integration checks, 28 forwarding/deferred-recorder checks, 16 runtime-capture checks, official Luau compilation and packed-source round-trip integrity. Live Roblox/Delta behavior remains unverified.

## Runtime Capture: dump-8

The supplied Delta ClientRuntime export contained 615 files whose entire contents were `-- decompilation panicked`. Those files are decompiler errors, not recovered script source. Runtime Capture adds independent read paths; it cannot guarantee source recovery or server-only access.

Use **Runtime Capture → Dump Client Runtime v8**. The existing **Dump Client Runtime** button also redirects to this collector. Each run writes a separate folder under `DevilDump_Dumps/ClientRuntimeV8/Run_<timestamp>_<generation>/` inside the executor workspace:

- Usable `.lua` source files, only when accessible Source or the executor decompiler actually returns code. Panic/comment-only stubs are recorded as failures and are not written as recovered source.
- `.bytecode.bin` files when `getscriptbytecode` works. These preserve raw binary bytes; bytecode is not readable/recovered source.
- `Runtime_*.json`: script paths, individual failures, API availability and local constants/upvalue probes, script-closure metadata, constants/upvalue type summaries, LocalScript environment methods, cached loaded-module exports, and matching GC functions attributed through `getfenv(fn).script`.
- `Summary_*.txt`: counts of source, failures, bytecode, runtime functions and loaded exports, plus the JSON report path.

Only modules reported by `getloadedmodules` are passed to cached `require`; arbitrary uninitialized modules are skipped. This option can be turned off. Captured functions are inspected, never invoked; no new remote calls or capture hooks are installed. Existing remote recording remains optional and retains the forward-first/deferred behavior from dump-7.

Limits: 3,000 scripts, 1 MB per source file, 2 MB per bytecode file/32 MB total bytecode, 1,200 unique functions, bounded constants/upvalue/table summaries. Export writes use readback verification when available. Unsupported APIs and empty/wrong results remain visible in the report. The collector cannot fix the executor's native decompiler or read code absent from the client. Source/bytecode/runtime capture may all remain unavailable on a restricted executor.

Validation: 16 runtime-capture checks, 8 frontend/recorder integration checks (including legacy button redirection), 28 remote forwarding/queue checks, and 26 Map Analyst checks passed. Official Luau compilation and packed-payload roundtrip passed. The new collector has not yet been validated live in Delta/Roblox.

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

## Recorder forwarding fix: dump-7

The recovered recorder hook inspected the remote path and redrew its UI before
forwarding the original namecall. Nested Instance method calls could clobber the
active method, causing the forwarded game call to fail. Both hookmetamethod and
raw-metatable handlers now capture the method/arguments, call the original first,
and return its exact results. Original errors and InvokeServer yields propagate
unchanged. Instance inspection, logging and UI updates run in a deferred queue;
recorder errors cannot prevent the original game call.

The pending queue is capped at 512 records. Overflow increments state.Dropped
and skips recording without blocking game traffic. Unload discards pending
records, and recorder-generated calls are excluded during deferred dispatch to
avoid recursive recording. Existing 5,000-log pause and hook ownership checks
remain in place. An original call that raises an error is not added to this queue.

Map Analyst now identifies the exact `-- decompilation panicked` error stub as
failed source recovery instead of exporting it as an available source file.
The previous files containing only that comment cannot recover any script logic.

Validation: 28 hook/queue regression checks reproduce the old namecall-clobber
failure and verify both updated handlers, argument/result nil positions,
InvokeServer yielding, original error propagation, deferred recorder failure,
disabled recording, overflow, scheduling failure and unload. The 26 analyst and
six existing frontend/recorder integration checks also pass. Official compilation
and exact packed roundtrip pass. Real executor behavior requires a live run.

Rejoin before testing this release after a recorder session that blocked game
buttons, so the older installed hook does not remain active.

## Targeted online reward capture: dump-10

Open the Loot to Forge online rewards screen, run the latest Dump, then use
**Runtime Capture → Dump Online Rewards Only**. Keep the loaded-module exports
toggle enabled. The capture writes its JSON, summary, and available source or
bytecode automatically under
`DevilDump_Dumps/ClientRuntimeV8/OnlineRewards_<timestamp>_<run>/`.
There is no need to wait until a reward becomes claimable or enable Remote
Recorder for this capture. Recorder logs remain useful for actual claim calls.

This mode selects only `ReplicatedStorage.LocalData.OnlineData`,
`ReplicatedStorage.GuiUtils.OnlineGift`, `ReplicatedStorage.Config.Online.Reward`,
`ReplicatedStorage.Config.Online.Helper`, and scripts beneath those paths.
OnlineData and OnlineGift take priority. Unrelated scripts cannot consume the
function budget. Table inspection gets a fresh budget per selected script and
reads four nested levels; function constants/upvalues are capped at 256/64.
Missing modules and truncation remain explicit in the report. The ordinary
full-client capture retains its existing limits.

Only modules already reported as loaded are read through cached require.
Inspected game methods are not called, and no reward remote is fired. Executor
decompilation can still fail; raw bytecode and metadata do not constitute
recovered source or proof that early claims are possible.

Validation: 17 targeted capture checks and the existing runtime, analyst,
recorder and integration regressions pass, alongside official Luau compilation
and an exact packed payload roundtrip. Live Delta behavior needs a user run.
