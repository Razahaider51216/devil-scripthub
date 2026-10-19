# DEVIL HUB / Anime Dice — standalone test

Open Anime Dice (place `113290951185459`, universe `10708913337`) and run:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/anime-dice-test.lua?v=test-3"))()
```

This test adds a DEVIL HUB interface for the actions identified in the supplied
Workspace (3) dump. It reads live game modules and inventory, not captured unit
IDs. It is published separately; the main loader and its ten game routes are
unchanged. Roblox/executor behavior has not been verified live.

The GUI uses the existing black/blue/white presentation, its single EN/Thai
language menu, blue switches and native minimize/restore controls. No full-screen
startup dimmer is created. English/Thai labels share the existing language choice.
All 28 automation switches start OFF and are not restored from saved configs.

| Tab | Included systems |
|---|---|
| Farm | Roll, Collect Money, Equip Best Base, Level Units, Buy/Equip Dice, Upgrade Tree |
| Inventory | Sell All Unused, Auto Lock, surplus Fuse, preview lists and explicit keep selections |
| Towers | Tower runs, Equip Best Tower Team, Rebirth, Rebirth points and manual reset token |
| Rerolls | Trait, Grade, Quirk targets, request limits, selected unit and game protection |
| Items and rewards | Selected Boost/Spin use, Gear priority, Daily/Group/Offline rewards, completed quests, Quest shop and user-entered codes |
| Halloween | Pumpkin Dice (1/5), Pumpkin sell filter, Haunted House wings, event travel, teleporting Trick or Treat, Pumpkin Pass, event quests and Candy shop |
| Status | Per-feature requests/confirmations/errors, Stop All, refresh choices, copy/save report and unload |

## First test

1. Wait until Money / Units appear in Farm > Live status. Status reports unavailable
   modules or remotes without silently enabling another feature.
2. Enable one feature first and inspect Status. `Requests` means an action was sent;
   `Confirmed` requires a live state change or an explicit successful response.
   The game may already be optimal, so Equip Best can legitimately have no change.
3. Use Stop all automation to stop work and queued requests. An already submitted
   sale, purchase, fusion or reroll cannot be undone by a local stop button.
4. If something fails, use Status > Copy / save test report. The report file is
   `DevilHub-AnimeDice-test-report.json`; it is not sent to a webhook or other user.

## Filters and budgets

- **Sell All Unused replaces chance-based inventory selling.** Inventory > Auto
  Sell All Unused Units sells every unused unit in batches of up to 25, including
  rare, mutated, single-copy and limited units. There is no sale chance ceiling.
  Locked, favorite, plotted, Tower team, carried, selected reroll and explicitly
  kept units are preserved. Keep character names / Keep specific units apply.
  Preview sale shows the same selection used by Auto Sell; selling starts OFF.
- Each sale reads current inventory and usage again before submitting its next
  batch. Pending trades or unavailable carried-unit state pause sales. The live
  inventory label shows the eligible count or the reason for a pause. Native
  Auto Sell applies to new rolls and does not block existing inventory sales.
- Best-unit counts, copies per name and mutation protection now appear under
  fusion and apply only to fusion. Fuse maximum chance starts at **0**; set a
  ceiling and preview before enabling fusion. Chance inputs accept `1/1,000`.
  Pumpkin Dice still has its separate native filter and apply button.
- Money, Candy, Pumpkin and Ticket reserves constrain purchases. Candy/Quest shop
  purchase limits and reroll request limits are explicit controls. Rebirth resets
  all current cash, as the label explains, and stops at the selected tier.
- Trait/Grade/Quirk never pass the override-protection flag. Set desired values;
  a protected current value pauses the job. Their protection selectors load the
  game's existing selections before edits are applied.
- Fusion requires three distinct eligible live IDs, an available fusion pool,
  sufficient money and no pending trade. It consumes those three units.

## Runtime behavior

Native game Auto Roll is used by default and restored when this test disables it
or unloads, if the test enabled it. A preexisting native Auto Roll is preserved.
The optional direct-roll mode waits for live inventory confirmation.

Tower and Haunted House are mutually exclusive and use the server's battle
responses with the game's action timing. Progress is shown in the DEVIL HUB
status tab; this test does not reproduce the native battle animation. Existing
native Auto Tower must be off to avoid two controllers competing. Stopping cancels
only a Tower session that this test successfully started.

Trick or Treat defaults to **Teleport**, with optional Walk movement. Use
Halloween > Start Event Collection to enable doors, completed event quests and
Pass claims together; purchases and Pumpkin rolls remain separate switches.
The collector travels to the Island when no nearby doors are loaded, requests
map streaming, exits each door region to rearm, and visits the nearest ready door.
Teleport checks loaded ground, living character and cancellation before moving.
It waits for the actual nested `HalloweenConfig.TrickOrTreat` travel-speed/minimum
gap limits and server knock/candy events; it never sends `Knocked` or `Landed`.
If the initial cooldown attribute is missing, its fallback deadline stays fixed.
Manual Island travel resumes an enabled collector; Hub travel stops it.
Stop All during travel prevents resuming. Rerunning replaces an older test release.
Streaming, server movement corrections and the live map still need Roblox testing.

Auto Trade is not part of this test: the previous analysis identified its remote
state machine but did not establish a trade policy or validate the full exchange
flow. Codes are supplied by the user; this test does not claim any code is current.

## Build and checks

Sources are under `tools/anime-dice/`. Run `build.py` then `test.py` there with
Python and the sibling official Luau tools. The builder assembles one public
file, includes the immutable checksummed shared DEVIL theme, and checksums the
pinned OuroFlow GUI dependency. No compiler/environment/HTTP hooks are installed.

Offline checks exercise inventory/material protection, budgets/prerequisites,
real-game remote paths and argument shapes, state confirmation, server event
direction, request cooldowns, late responses after stop, movement failure/death,
GUI callbacks, silent selection refresh, language changes, duplicate startup,
corrupt downloads and unload. These mocks do not replace live validation.
