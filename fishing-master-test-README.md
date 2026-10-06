## Standalone test v4

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/fishing-master-test.lua?v=4"))()
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

## Selling in v4

V3 waited only 0.5 seconds after invoking SellAll before returning. V4 replaces
that delay with a confirmation loop. It holds new casts while waiting, remains
at the seller until confirmation, and waits for observed updates to settle for
two seconds before returning. That settling interval starts after data changes;
it is not a fixed sleep counted from the outgoing sell request.

The existing native PlayerData.Fetch supplies replicated Coin. When a supported
owned-fish collection is present, the loop waits until its sellable records are
empty, rather than returning after the first partial batch or coin increase.
Optional read-only schemas are Fish, Fishes, FishInventory, Inventory.Fish and
Inventory.Fishes; records must have a string fishId/FishId. Explicit favorite
and locked records are excluded. These are capability checks, not claims that
this failed dump revealed the current inventory schema. If no such collection
is available, an increase of replicated Coin is the available payment receipt.
That balance fallback is an observation, not a transaction-correlated server
response, and another simultaneous credit can affect it.

Each reservation attempts at most three native sell commands, five seconds
apart. There is no automatic return after an unconfirmed request, timeout or
request rejection. After the attempts it continues to poll at the seller with
a visible status. Turning Auto Sell off, Stop All, closing the script or respawn
cancels the wait. Explicit cancellation restores the original character's
position when it is still the same character; a replacement character is never
moved to an old spawn. No sellable fish means no journey is started. Sell Anywhere
uses the same confirmation loop and requires the existing entitlement.

The 45-second deadline still applies to finishing an ongoing fishing session
before a sale starts. No new-cast guard is removed while a sale is pending.
The v3 selected-rarity setting acknowledgement/backoff repair remains unchanged.
The selected-rarity switch configures the game's auto-sell settings; it does not
establish a method to selectively sell existing inventory. Choose a rarity in
Selling before enabling that switch.

No island selection/teleport menu was added. The native seller finder searches
World.Islands.*.Interactives for the nearest npc_fish_seller. The local dump
contains npc_fish_seller_1 on island_starter. IslandConfig/UnlockedIslands serve
rod-purchase filtering; TeleportService serves reconnect separately.

Seventeen sell scenarios cover a delayed receipt, batched inventory updates,
12-second latency, temporary missing data, a balance-only receipt, inventory-only
completion, empty inventory, no confirmation, partial sales and unrelated coin
credits with recognized inventory. Cancellation, respawn, unload, errors and
actual Sell Anywhere entitlement remain covered. Eleven loader cases, adaptive
skill/filter tests and official Luau compilation also pass. Live DeltaX/Roblox
operation remains unverified for this release.

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

