# Devil Hub / Break and Steal an Egg

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/break-and-steal-an-egg.lua"))()
```

Full release entry. Old test URLs forward to this entry. Use a fresh Roblox
session after updating. Supports place 114326934417838 / universe 10765288803.
Requires executor HTTP hooks, loadstring and network access.

## Gameplay update (2026-10-06)

The supplied remote recording shows EggHitRequest receiving an egg and a
sequence number (2 through 12). The older public runtime sent only the egg.
Auto Break now equips and activates the game's Pickaxe tool so its native
controller owns the request sequence. It does not invent counters or replay
recorded requests. Hits respect the configured interval with a 0.25 second
minimum; rejection or seven seconds without hit feedback pauses Auto Break.

Auto Break and Auto Pick Up & Bank use teleport travel again (live-5), replacing
the slow walking behavior from live-4. A shared travel slot limits transfers to
one every 0.6 seconds. Each target/stage receives one transfer, followed by an
arrival wait; a corrected position pauses that mode instead of repeatedly
forcing the teleport. Pickup takes travel priority, holds the prompt for its
configured duration, waits for a nonempty Carrying state, then teleports to
the original own-base CFrame. Banking waits for Carrying to clear; a
confirmation timeout pauses farming. Stable targets and bounded pickup retries
prevent alternating commands. Main > Automation status reports the current step.
This does not establish that the current server permits teleport travel.

The old and supplied map exports have the same SafeZone position and size.
The remote list grew from 40 to 62 entries, including EggHitConfirmed; no old
remote was removed. These client exports do not contain server validation,
and the game-controller source files contain decompilation failures. The
recording covers hits only, so current pickup/banking behavior still requires
live verification. Manual Teleport to Base retains the upstream behavior.

The OuroFlow GUI uses the original Info, Main, Visuals, Player and Settings
categories, plus a dedicated Webhook category, with native gameplay callbacks behind the new controls. The old
Obsidian screen is disabled. Socials contains Discord only. The Discord card
uses the Devil logo and 2K+ members, without the old background banner.

## Webhook

In Webhook, paste your Discord webhook URL and enable Animal
pickup notifications. One message is queued for each new nonempty Carrying
transition, the game's pickup confirmation. Opening the toggle, holding an
existing animal, passive Cash income, and banking/dropping the current animal
do not trigger messages. Repeated events for the same carried ID are ignored.

Each message contains that animal's name, rarity, value/price, and income per
second. These fields come from matching AnimalPickup / PlacedAnimal model
attributes or the Carrying JSON. Model details are cached before removal so
notifications can resolve an animal after it leaves the pickup list. Missing
fields show Unavailable. Total player cash is never used as the pet's value.
Weight (KG) is included when exposed in the animal attributes or Carrying JSON.
Name and rarity overrides are optional.

Notify Animal Filter and Notify Rarity Filter allow multiple selections; empty
selections allow all. Choices come from animals observed in the current session;
Refresh animal / rarity options updates those lists. Min $/s and Min KG default
to zero. Positive minimums reject animals whose corresponding data is missing.
Filters evaluate actual animal data before optional name/rarity display overrides.

Main > Recent Steals shows the last 20 confirmed pickups in this session with
name, rarity, weight and income per second. Search filters the local history;
Clear history removes it. Loading does not reconstruct previous pickups.

Messages hold independent snapshots so collecting another animal cannot
replace an earlier queued animal's details. A minimum send gap (default two
seconds) controls bursts; it does not create recurring notifications. Successful
messages are removed from the queue. Failed sends wait before retrying and
Discord 429 responses honor retry_after. Send test notification is manual only.

Webhook starts disabled, and enabling does not replay historical pickups.
The URL is not saved to UI configs. Only Discord webhook endpoints are accepted;
mentions are suppressed. Disabling clears queued pickups. Cleanup disconnects
listeners and clears the URL.

## Provenance and validation

Gameplay derives from the public joustingmatch/Ouroboros revision
2676ef9b1c324b21d25834894bb7f26990c3a073 (2026-10-01), SHA256:
3f9986b3035f71437b7af81e0efd5e313834184db55b9101e0ce60e3d7c5b821.
Six callbacks are patched: two duplicated hit workers, the pickup/bank worker,
the Carrying predicate and the two automation toggle setters. Other original
source slices are retained, with a separate travel/action controller.
OuroFlow GUI is pinned to c8251f76f74d9942114ebccb0564aa0ac196320a.
This is not the latest FlowAuth payload; authentication checks are not bypassed.

Validated with official Luau compilation, exact packed roundtrip, mocked
native tool activation/cooldown, single transfers per target, shared travel
cooldown, pickup hold timing, banking confirmation timeouts, position-correction
and hit rejection/missing-feedback pauses; mock loading
failure/retry/cleanup cases, native callback synchronization, Settings webhook
controls, Socials filtering, and mocked pickup notifications, item snapshots,
429 backoff and request failures. No real webhook messages were sent in tests.
Live game actions and DeltaX have not been verified in this environment.
Client-side packing does not guarantee source secrecy.

The supplied ThanHub screenshots also show Auto Titanic Egg, Auto Swing,
Mutation/Min KG pickup filters, Merge and Sell automation. Those gameplay
systems are not implemented in this release: the public ThanHub loader does
not expose their game actions, and screenshots do not establish the current
server API. This update does not resolve or bypass the game's anti-cheat.

Discord: https://discord.gg/ZY7PRcVJe2
