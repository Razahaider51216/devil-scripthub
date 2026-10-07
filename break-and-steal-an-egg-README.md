# Devil Hub / Break and Steal an Egg

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/break-and-steal-an-egg.lua"))()
```

Full release entry. Old test URLs forward to this entry. Use a fresh Roblox
session after updating. Supports place 114326934417838 / universe 10765288803.
Requires loadstring, setfenv and network access. The updated Break Egg module
does not install HTTP hooks. Pet Carry Farm also requires fireproximityprompt;
Drawing is required when using the drawing-based ESP controls.

The OuroFlow GUI uses the original Info, Main, Visuals, Player and Settings
categories, plus a dedicated Webhook category, with the updated gameplay callbacks behind the controls. The old
Obsidian screen is disabled. Socials contains Discord only. The Discord card
uses the Devil logo and 2K+ members, without the old background banner.

## Updated gameplay (2026-10-08)

Gameplay now derives from the supplied
[Satbiz01 Break and Steal an Egg script](https://raw.githubusercontent.com/Satbiz01/ExploitsRoblox/refs/heads/main/games/breakandstealenegg.lua).
Its strings were decoded statically before adaptation. The OuroFlow GUI,
loading overlay, Discord card, Webhook and Recent Steals features remain.

- Auto Egg selects valid eggs by lowest health, using nearest distance to break
  ties. It skips Broken/Hatching eggs and eggs near zone-build models, equips
  the pickaxe, moves within hit distance, and calls EggHitRequest. Delay,
  stand distance, and movement speed remain adjustable. Pausing, carrying,
  disabling, and unloading cancel movement or further hits.
- Auto Shop buys pickaxes/trails, unlocks/upgrades the treadmill, upgrades the
  pen, sells eligible backpack pets, and equips best. Prices come from the
  game's Shared configuration modules. Cash is read again before each purchase.
  The loop runs every three seconds; pet sales run every fourth shop tick.
- Auto Pet Carry Farm uses the reference's PromptAnchor and return route:
  approach at Y=3/Z=123, deliver at X=-77/Y=3/Z=123, with Zone1–Zone9 timing.
  Pickup requires a nonempty Carrying attribute and the delivery counter waits
  for Carrying to clear after the route completes. This is an inferred delivery
  confirmation, not a server delivery receipt. The farm respawns to repeat,
  pauses Auto Egg, and restores any NoClip state it enabled when disabled.
- Player controls cover jump height, infinite jump, reset, saved-position
  teleport/loop, player teleport and NoClip. Visuals cover FOV, player/teammate
  ESP, rarity-filtered egg/pet ESP, guard highlights, brightness and animations.
- Fixed duplicated control IDs, stale character/root references, the source's
  out-of-scope farm distance variable, shadowed carry toggle/NoClip variables,
  listener cleanup and cancellation. NoClip restores original collision values.

Gameplay configs use DevilHub/BreakEgg/<place ID>; previous Ouroboros configs
are not migrated. Theme/config addon groupboxes and confirmation dialogs are
bridged to the existing frontend. The visible frontend still starts in Crimson.

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

Reference download SHA256:
251064a3e6b79d2d6b60ac7fd27d422539669ea77efa800bc1e3a79f535f4d41.
This identifies the supplied file snapshot; the upstream main branch can change.
The reference is adapted, with the corrections listed above.
OuroFlow GUI is pinned to c8251f76f74d9942114ebccb0564aa0ac196320a.
ThemeManager and SaveManager are vendored from deividcomsono/Obsidian commit
2bf43254266f94492fe1f0fa12d181bb55e98f25, under preview/Obsidian-LICENSE.txt.

This update was validated with official Luau 0.741 compilation, per-chunk
checksums and exact packed source roundtrip, and executable mocks for gameplay
initialization, unique IDs, egg hit/restart/stop, shop cash refresh, carry executor
fallback, pickup/delivery/cancellation and unload. Frontend mocks verify the
original Crimson/size configuration, legacy and direct AddGroupbox APIs,
silent initialization, native/frontend synchronization, multi-select and teardown.
Webhook and item-context source was retained; no real webhook messages were sent.
Live game actions and DeltaX have not been verified in this environment.
Client-side packing does not guarantee source secrecy.

Titanic-specific farming, mutation/Min KG gameplay pickup filters and Merge
automation are not supplied by this reference. Webhook filters remain notification
filters. This update does not resolve or bypass the game's anti-cheat.

Discord: https://discord.gg/ZY7PRcVJe2
