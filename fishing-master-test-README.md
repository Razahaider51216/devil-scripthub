## Standalone test v2

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/fishing-master-test.lua?v=2"))()
```

Run inside Fishing Master in a fresh session. The original historical GUI stays
pinned to commit `836b20c6a25cca72dd8530f54462d978251b3024`. Gameplay source is
prefetched from its immutable public revision, then three exact source targets
are patched: the skill callback resolver and the two skill-label constructors.
All other historical game logic remains the original source. The loader needs
`loadstring` and `hookfunction`; native automation needs `firesignal`.

Auto Skills now addresses slots rather than physical keys. Z/1, X/2, C/3 and V/4
share their canonical `SlotN.callback`. When that is unavailable, registered
mobile button listeners or key registries provide compatibility fallbacks.
Mobile selection follows the active Rod panel, then preferred/last input.
Visible locked slots and positive timer labels are skipped; attempts are
bounded per slot, pause during text entry, and never fire two input paths for
one skill. Mobile signal fallback additionally needs `getconnections`.
Existing reeling, finisher-gate and IsUsingSkill guards remain in the native
worker. The adapter does not remove cooldowns or server validation.

The new Automation+ tab includes:

- Auto Fishing Cycle: enable the existing perfect cast, minigame, four skill
  slots and best-owned-rod controls together. Turning it off restores the
  previous individual values. Selling, purchasing and rolls stay separate.
- Pause While Typing and Pause During Respawn, with automatic resume.
- Auto Stop After in minutes; zero means unlimited. Time includes pauses.
- Stop All Automation, including native sell/roll/reconnect switches, and live
  input-mode, skill and cycle status. Timer completion also stops all automation.

Downloads have 30-second deadlines and startup has a 90-second deadline.
Temporary HTTP hooks and compatibility bindings restore on success or failure.
Closing/unloading removes the additional heartbeat listener and stops its
callbacks. Errors appear after `[FISHING MASTER TEST]` in the console.

## Local dump findings

The October 6 dump identifies Fishing Master and contains the actual mobile
Rod/Slots buttons. All inspected game controller/config sources are panic
markers, so the export does not provide quest/event packet arguments or server
code. The six remote instance names alone do not establish how to invoke them.
No new quest, event, unit-gacha or authenticated payload contracts were invented.
See `fishing-master-dump-findings.json` for counts and the supported mapping.

Eleven offline loader scenarios cover success and startup/cleanup failures;
adapter tests cover desktop/mobile/hybrid input, numeric registries, locked and
cooldown slots, debounce, failed callbacks, typing, respawn, settings restoration,
timers and cleanup. The entry, original GUI and original/patched runtimes compile
with official Luau. DeltaX and live gameplay remain unverified. This update does
not establish a bypass of anti-cheat, bans, packet validation or authentication.

