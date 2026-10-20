# DEVIL HUB — Devilv4 mining test

Standalone prototype for Place `121831322352666`, Universe `10765013362`.
This entry does not replace the production main loader or any existing game script.

## Included

- DEVIL HUB black translucent GUI, blue/white text, compact layout, existing embedded English/Thai selector.
- Continuous Auto Dig, Fast Dig aim frequency (5–40 updates/second), live target farming with type/rarity filters.
- Teleport to loaded materials, eggs, artifacts and potions; duplicate block names retain distinct instance IDs.
- Item pictures: 31 native image assets for shovels, drills, gear and potions. Eggs/artifacts/materials use actual models in bounded viewport previews.
- Shovel selection, cash prices and purchased/equipped state. Gear/drill selection, live stock and price, manual purchase/equip and optional auto purchase.
- Cash reserve and consumable quantity limit. No Robux fallback.
- Auto plant inventory eggs on clear ground in the player's plot; hatch ready eggs.
- Auto sell loot, spare eggs or stored pets using fresh server quotes. Stored-pet selling keeps equipped/placed pets according to the native server contract; it can sell valuable unequipped pets.
- Auto equip best pets; cash upgrades for training, plot capacity, hatch luck and pet income.
- Optional rebirth with a stop count; disabled by default. Rebirth uses the game's reset rules.
- Potion selector and auto use after the selected buff expires; owned gear placement; Pumpkin Launcher use.
- Training at the configured plot training position; optional timed training/mining rotation.
- Eligible event egg/pumpkin-drop collection using server drop plans and collection radius. Cash Tsunami rewards at native wave timing.
- Daily rewards, offline earnings and Pet Index rewards.
- Per-account/per-place Save/Load settings in Settings. Only explicitly saved switches resume on the next run.
- Stop All, unload, diagnostic JSON export, bounded asynchronous requests, cancellation checks and persistent locks for hanging requests across reloads.

## Practical limits

This is an offline-validated test, not a live-game compatibility claim. Server checks still decide purchases, rewards, mining and movement. Fast Dig keeps valid continuous mining input; changing aim frequency does not establish a server cooldown bypass. Owned DigSpeed potions and the game's equipment bonuses remain the source of server-authorized speed improvements. No damage bypass, damage-stat mutation, admin/test tool flag, or invulnerability code is included.

Only currently streamed targets can be listed. A teleport needs clear nearby ground and reports server correction. Teleporting beside a block does not grant it; the block still needs mining. Recipes, rarity-selective pet selling, paid growth/reward multipliers, and admin event creation are not invented where the captured client contract does not support them.

All auto jobs start off without a saved profile. To resume a setup, choose the filters/switches, then press **Settings → Save settings**. Use **Stop all automation** before saving an inactive profile.

If a feature waits or is rejected, use **Settings → Copy diagnostic report**. Include that report with the executor name and the feature being tested.

## Build and validation

```powershell
python tools/devilv4/build.py
python tools/devilv4/test.py
```

The builder embeds the reviewed source modules, verifies the pinned OuroFlow dependency, extracts only asset ID mappings from the supplied dump, and compiles the public entry using Luau. Tests cover policy, cancellation, remote arguments, quotes, reserve/stock, the complete public entry with a mocked Roblox/GUI environment, pictures/prices, language changes, settings reload, hanging RPCs, duplicate targets, streaming removal and teleport correction.

Dependency: OuroFlow source commit `c8251f76f74d9942114ebccb0564aa0ac196320a`; existing DEVIL blue theme commit `9a9812469df7b5dad2848abb33c5206f7d57e685`. Item assets retain native game IDs from the supplied Devilv4 client dump.
