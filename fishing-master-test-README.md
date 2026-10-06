## Standalone test v3

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/fishing-master-test.lua?v=3"))()
```

Run inside Fishing Master in a fresh session. The original historical GUI stays
pinned to commit `836b20c6a25cca72dd8530f54462d978251b3024`. Gameplay source is
prefetched from its immutable public revision, then six exact source targets
are patched: the skill callback resolver, two skill-label constructors,
Auto Sell All, the cast worker guard and the rarity setting synchronizer.
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

## Selling in v3

The historical Sell All worker returns immediately unless fishing is Idling.
Continuous auto casting can restart before a sell tick gets that state. V3
reserves a sell operation and holds new casts only while Idling, allowing the
current cast/minigame/skills to finish. It waits at most 45 seconds, sends the
native sell command once, and restores the original character position on
completion, errors or cancellation. A replaced character is never moved to the
old spawn position. Sell Anywhere is used only with the actual entitlement.
Live acceptance is not inferred from a client method returning normally.

The old rarity synchronizer cached changes even when SetSettings.Fire failed.
V3 reads current Settings.AutoSell and distinguishes confirmed values from
pending intent. Failed/unconfirmed packets can retry every five seconds, at
most three attempts per setting/value. Disabled cleanup is also bounded.
Status labels show missing sellers, busy fishing, failed commands, missing
contracts, pending confirmation and an empty rarity selection.

The native selected-rarity switch updates the game's auto-sell settings; this
source does not demonstrate a method to sell existing inventory by rarity.
Choose at least one rarity in Selling. This repair does not invent a remote
contract for selling existing inventory selectively.

There is no selectable island teleport menu in this Fishing Master source.
IslandConfig/UnlockedIslands filter rod purchases. The existing sell journey
finds the nearest npc_fish_seller under World.Islands.*.Interactives, moves to
that seller and returns. The dump confirms npc_fish_seller_1 on island_starter.
Reconnect uses TeleportService separately. No island navigation was added.

Eight sell scenarios and filter-setting checks cover cast coordination,
command errors, no seller, timeouts, cancellation, respawn, unload, actual
Sell Anywhere entitlement, failed setting packets, bounded retries and server
acknowledgement. Live Roblox/DeltaX behavior remains untested in this release.

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

