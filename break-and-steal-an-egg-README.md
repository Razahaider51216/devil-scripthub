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

In Settings > Webhook, paste your Discord webhook URL and enable Cash
notifications. Default interval is 30 seconds (adjustable from 10 to 300).
Notifications report positive increases of the player's Cash attribute,
session earnings and current cash, plus the latest carried egg/pet name and
rarity. Spending is not treated as earnings. The cash amount is not attributed
to a specific pet: that field is the latest carrying context.

Item details resolve from the Carrying attribute and matching AnimalPickup /
PlacedAnimal models. Unavailable data stays unavailable. Optional name and
rarity overrides let you supply details if the current game format differs.
Send test notification sends a sample to your configured webhook.

Webhook starts disabled. The URL is not saved to UI configs. Only Discord
webhook endpoints are accepted; mentions are suppressed. Requests are batched,
never overlap, and respect Discord rate limits. Failed earnings notifications
remain queued until a later attempt. Disabling stops tracking and clears the
pending batch; cleanup disconnects listeners and clears the URL.

## Provenance and validation

Gameplay preserves the public joustingmatch/Ouroboros revision
2676ef9b1c324b21d25834894bb7f26990c3a073 (2026-10-01), SHA256:
3f9986b3035f71437b7af81e0efd5e313834184db55b9101e0ce60e3d7c5b821.
OuroFlow GUI is pinned to c8251f76f74d9942114ebccb0564aa0ac196320a.
This is not the latest FlowAuth payload; authentication checks are not bypassed.

Validated with official Luau compilation, exact packed roundtrip, mock loading
failure/retry/cleanup cases, native callback synchronization, Settings webhook
controls, Socials filtering, and mocked webhook accounting, item lookup,
429 backoff and request failures. No real webhook messages were sent in tests.
Live game actions and DeltaX have not been verified in this environment.
Client-side packing does not guarantee source secrecy.

Discord: https://discord.gg/ZY7PRcVJe2
