# Devil Hub / Break and Steal an Egg

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/break-and-steal-an-egg.lua"))()
```

Full release entry. Old test URLs forward to this entry. Use a fresh Roblox
session after updating. Supports place 114326934417838 / universe 10765288803.
Requires executor HTTP hooks, loadstring and network access.

The OuroFlow GUI uses the original Info, Main, Visuals, Player and Settings
categories, with native gameplay callbacks behind the new controls. The old
Obsidian screen is disabled. Socials contains Discord only. The Discord card
uses the Devil logo and 2K+ members, without the old background banner.

## Webhook

In Settings > Webhook, paste your Discord webhook URL and enable Animal
pickup notifications. One message is queued for each new nonempty Carrying
transition, the game's pickup confirmation. Opening the toggle, holding an
existing animal, passive Cash income, and banking/dropping the current animal
do not trigger messages. Repeated events for the same carried ID are ignored.

Each message contains that animal's name, rarity, value/price, and income per
second. These fields come from matching AnimalPickup / PlacedAnimal model
attributes or the Carrying JSON. Model details are cached before removal so
notifications can resolve an animal after it leaves the pickup list. Missing
fields show Unavailable. Total player cash is never used as the pet's value.
Name and rarity overrides are optional.

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

Gameplay preserves the public joustingmatch/Ouroboros revision
2676ef9b1c324b21d25834894bb7f26990c3a073 (2026-10-01), SHA256:
3f9986b3035f71437b7af81e0efd5e313834184db55b9101e0ce60e3d7c5b821.
OuroFlow GUI is pinned to c8251f76f74d9942114ebccb0564aa0ac196320a.
This is not the latest FlowAuth payload; authentication checks are not bypassed.

Validated with official Luau compilation, exact packed roundtrip, mock loading
failure/retry/cleanup cases, native callback synchronization, Settings webhook
controls, Socials filtering, and mocked pickup notifications, item snapshots,
429 backoff and request failures. No real webhook messages were sent in tests.
Live game actions and DeltaX have not been verified in this environment.
Client-side packing does not guarantee source secrecy.

Discord: https://discord.gg/ZY7PRcVJe2
