# Devil Hub / Loot to Forge

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loot-to-forge.lua?v=loot-reroll-13"))()
```

Uses the gameplay from the supplied [2KScripts LootToForge reference](https://github.com/hxrendontcry/2kscripts/blob/main/LootToForge.luau)
with Devil Hub's existing OuroFlow GUI, pinned to
`c8251f76f74d9942114ebccb0564aa0ac196320a`. Native tabs, groupboxes, widgets,
the Abyss theme and Devil Hub logo are retained. The reference's custom TwoKUI
window renderer is replaced by a Section/Toggle/Slider/Dropdown/Button bridge.

This supersedes loot-2k-1/2/3 and the old Ouroboros game engine. There is one
reference engine, rather than two overlapping farm implementations.

## Reference systems

The eight reference tabs and 70 named controls are connected to the original
State callbacks, including:

- Power training, automatic stage clears, dungeon farming, Super Loot and World
  Boss automation, selected potions and x100 training at Zone 9.
- Gear/ore/enchant-stone selling, selectable rarity filters and reward claims.
- Forge options, equip best and automatic enchanting.
- Upgrades, rebirth and class rolling with target rarity.
- God Spawner: Apocalypse, The Tri-Wyrm, Cataclysm and Void Overlord sets, Apex Ore, tier II/III runes, Ember Stone and update-reward requests.
- FPS/graphics controls, Anti-AFK, character movement, scale/theme settings,
  and reference configuration save/load.

The reference uses **ReplicatedStorage.Remote** (singular). Previous optional
additions incorrectly searched `Remotes`, causing supported requests to be
missed. The full engine now uses the original root and remote names directly.
Spawner buttons always appear, as in the reference. GetArmorRE/GetWeaponRE
requests and subsequent inventory/equip actions now use the IDs in the supplied NAPHUB spawner reference.

The new engine stores configuration in `DevilHub_LootToForge_2K_Config.json`.
The previous Ouroboros engine's configuration schema is not imported. Requests
still depend on the actual game server: simulated success does not establish
permission to grant gear, persist items across rejoins or unlock paid benefits.
Notifications avoid guaranteeing permanent saving.

## Adaptation and lifecycle

The decoded game body is used directly; no protected upstream game VM is
downloaded. The separate original telemetry/anti-environment loader is not run.
The custom GUI factory is replaced, Discord links use Devil Hub's invite, and
the duplicate source Anti-AFK setting is consolidated. The reference's missing
theme/minimize adapters map to the native GUI.

Gameplay runs in an isolated environment. Workers, delays and event listeners
are tracked. Unload cancels workers, disconnects listeners, restores function
hooks and changed shared-module methods, and closes the GUI. Source store
callbacks without unregister methods become inactive after cleanup. Existing
sessions can be replaced through DevilLootCleanup; a fresh game session remains
the clearest way to compare the complete engine with the prior version.

Reference build: `2026-10-07T08:55:37.768Z`. Distribution SHA256:
`218647dfa0ff786534259887e59a04b4992f68d87bf505676acd617004076c52`.
Source credit: clack / 2K Script Studio.

Validation: official Luau compilation; packed checksums/exact source roundtrip;
the complete adapted engine executed with Roblox API mocks; all eight tabs and
59 named controls bound; original dropdown callbacks, singular Remote paths,
armor/hat/weapon IDs and x100 Zone 9 requests exercised. Host integration checks
native UI loading, environment isolation, shared-method/hook restoration and
worker cleanup. Universal routing for all four games also passes. Live server
behavior has not been verified here.

Discord: https://discord.gg/ZY7PRcVJe2

Version `loot-2k-5` fixes initialization of reference sliders whose `Value` contains
`Min`, `Max`, and `Default`. The bridge now passes numeric defaults and the original
ranges to OuroFlow, including numeric values when applying saved settings.

English DEVIL HUB labels and dropdowns preserve original gameplay/config values.
Community links use https://discord.gg/rZxnEE4Jnp. The logo uses a cached custom
asset when supported, with the original image URL as fallback.

## Spawner update: loot-spawner-7

Only the God Spawner segment was replaced, using the supplied [NAPHUB reference](https://raw.githubusercontent.com/Anyarin29/NAPHUB/refs/heads/main/LOOT_TO_FORGE-NAPHUB29.lua.txt). The existing OuroFlow GUI, host compatibility adapters, other tabs and gameplay are preserved.

- Apocalypse: K_1101 / HHat_1101 / HArmor_1101.
- The Tri-Wyrm: K_1001 / HHat_1001 / HArmor_1001.
- Cataclysm: K_1002 / HHat_1002 / HArmor_1002.
- Void Overlord: K_26 / LHat_16 / LArmor_16.
- Apex Ore (Ore_48): choose 1-100 requests, default 10.
- Poison / Ice / Fire / Thunder runes: choose tier II, III, or both.
- Ember Stone: choose target increase 1-5,000. Collects only returned EnhantStone_1 drop UUIDs from Stage_27; capped at 35 seconds / 200 sequential stage requests. Counts all observed real stacks and excludes the old synthetic display entries.
- Race Roll: an explicit on/off control and 0.1-5 second interval (default 0.5), using the source's reward 4/5/6 payload format at Remote.UpdateLog_Server.TryClaimUPDRewardRE. This is separate from the unchanged Auto Roll Class control.

Inventory observations and exact received UUIDs drive the set equip requests. Request transmission alone is not shown as a confirmed grant. Stop all spawner actions cancels future batch and Race Roll requests; unloading stops the spawner and the existing engine. Already transmitted requests cannot be recalled. Only one batch spawner job can run at a time, and repeated Race Roll enabling cannot duplicate its worker.

Validation: the updated engine ran with Roblox/API mocks across all eight tabs and 64 controls; every set ID, equip UUID, Apex quantity, rune tier, Ember drop filtering/count, Race Roll payload, stop and unload was exercised. Seventeen additional failure/lifecycle checks passed. Luau compilation and all packed checksum/byte-for-byte roundtrips passed. Checks assert that the engine outside the spawner segment and the host/GUI wrappers are unchanged. Live Roblox/server acceptance and persistence have not been verified.

Spawner source credit: Anyarin29 / NAPHUB. Existing engine source credit remains clack / 2K Script Studio.

## Actual Auto Reroll: loot-reroll-8

Use the Upgrade tab's Auto Reroll Class / Race and Auto Reroll Skills controls. These perform rerolls, separately from claiming update rewards.

Class reroll now sends the reference's string slot argument "1" to Remote.Class.LuckOnceRE, including the manual reroll button. Choose Target rarity (Epic / Legendary / Mythic), Exact Class (enter an ID such as Class_9), or Continuous. Exact targets also request slot 1 locking/equipping when those remotes exist. A current class that already meets the selected rarity is intentionally preserved, with a visible status message. Select Continuous when you want to keep rerolling that class.

Auto Reroll Skills calls Remote.Backpack.LuckSkillCell_2RE without arguments, matching the supplied reference. Class and Skill have independent 0.75-5 second intervals and request counters. Known zero Class tickets wait for more; unavailable class/rarity data and remotes produce visible status. Successful transmission is reported as a request, not a confirmed result.

Stop All Rerolls disables both, and unload prevents future sends. Both use the game's reroll currency and server rules. The old reward-claim panel is now explicitly titled Update Reward Requests; it is not Auto Reroll.

Validation: 25 controller checks passed, including exact argument types, independent cooldowns, initial/periodic deduplication, rarity/ID stops, slot locks, continuous mode, no tickets/resume, missing data/remotes and unload. Full-engine mocks exercise both actual rerolls and all prior spawners across eight tabs and 69 controls, including periodic loops and stopping. Packed source/checksum roundtrips and Luau compilation passed. Real server acceptance remains unverified.

## Race screen / reference alignment: loot-reroll-9

The supplied NAPHUB source discovers races with Config.Class.Helper.GetConfig(), compares ClassData.GetEquipedClass() to the target ID, and sends a string argument to Class.LuckOnceRE. Its hardcoded value is "1". This build adds a Race slot selector for 1/2/3, forwarding the selected string instead of always using 1. Slot 3 is the fallback default matching the supplied screenshot; when the module exposes GetEquipedIndex, that actual index initializes the selector.

Select the same slot currently equipped in the game's Races menu, and ensure that slot is unlocked there. The supplied reference's target getter reads the equipped race; it does not establish a getter for every saved slot. Extra paid slots are not included, and the script does not automatically unlock a slot.

Target Race is a dropdown populated from the reference's Helper.GetConfig() API, with real names when the returned rows provide them and raw Class IDs otherwise. The reference's Class_1 through Class_9 fallback is used only if config cannot be read. Refresh Race List retries loading the helper. Exact Class is the default stop mode, matching the reference's target-ID algorithm.

GetLuckTimes() is now informational only, matching NAPHUB's lack of this precondition. The relationship between that legacy getter and the visible Race Roll balance is not verified, so a reported zero no longer blocks the outgoing reroll request. The game server still determines whether a reroll is allowed and consumes currency.

Copy Reroll Status exports the selected slot, module methods, equipped race, legacy ticket getter, current statuses and transmitted request counters for diagnosis. Auto Skill Reroll remains a separate Backpack.LuckSkillCell_2RE request.

Validation: 29 controller checks plus full-engine integration across 70 controls passed. Integration covers selected string slot 3, config-helper race discovery, race label-to-ID mapping, stop rules, independent Class/Skill loops, existing spawners and unload. Luau compilation and exact packed roundtrips passed. The interpretation of the selected slot and live game responses still require in-game verification; the source itself only demonstrates the value "1".

## Reference remote lookup fix: loot-reroll-10

Reroll lookup now follows the supplied NAPHUB `getRemote` helper exactly: first select `Remote.<Name>_Server`, falling back to `Remote.<Name>` only when the server folder is absent. The previous reroll adapter searched only the plain folder, producing the reported Unavailable messages and zero requests.

Race rerolls use `Remote.Class_Server.LuckOnceRE` with the selected string slot. Skill rerolls use `Remote.Backpack_Server.LuckSkillCell_2RE` without arguments. Exact-target locking and equipping use the same Class_Server folder. No guessed remote names or ClassData.LuckOnce signatures were added. Class IDs are the internal race IDs; the selected slot is a separate value.

Validation: 29 controller checks and full-engine integration passed with both server folders and the plain-folder fallback. The server-folder fixture also contains a decoy plain Backpack remote, verifying that the source's folder precedence is respected. Existing 70 controls, stop/unload behavior, Luau compilation and packed source roundtrips passed. Live game responses remain unverified.

## Simple colored stop selection: loot-reroll-11

Select **Stop when obtained**, then enable **Auto Reroll Race**. One menu replaces the three separate stop-mode, rarity and race menus. Colored rarity entries stop at that tier or higher; specific race entries stop at the exact race and request locking/equipping, matching the NAPHUB reference. The final Keep rolling option disables target stopping. The equipped slot initializes from the game and remains selectable.

Rarity options now include Common, Uncommon, Rare, Epic, Legendary, Mythic, Eternal, Secret, Ancient, Infinite and Exclusive. The upper-tier fallback order follows the source's Eternal / Secret / Ancient / Infinite sequence. Current rarity accepts Rarity, RarityLevel or RareLevel fields. Race entries come from Helper.GetConfig(), show their rarity marker when known and use names provided by the config. No race-name mapping is invented when config provides only IDs.

The selected stopping rule is saved as RaceStopChoice; legacy mode/rarity/ID settings are synchronized after configuration loading. Validation: 34 controller checks, every colored dropdown selection, exact-race selection, continuous mode, independent loops, server-folder precedence and existing spawners passed across 68 controls. Luau compilation and packed source roundtrips passed. Live reroll behavior was reported working by the user before this UI change; this version's UI has been checked with mocks.

## Race-only multi-selection: loot-reroll-12

**Stop at selected rarities** now supports multiple selections. Auto Reroll Race stops when the equipped race's level matches any selected rarity exactly. For example, selecting Secret and Infinite stops on either result; an unselected Ancient result continues. This replaces the earlier single-threshold rule.

The menu contains only the eleven colored rarity levels. Specific Class/race targets, locking/equipping on an exact Class target, the continuous option and the refresh-race button have been removed. Auto Reroll Skill, its interval, manual skill reroll and its worker/controller implementation are removed as well. The race slot selector remains because it selects which equipped slot receives the reroll request.

At least one rarity must be selected to enable auto reroll; an empty selection switches it off without sending a request. Unknown current rarity waits without rolling. Manual Reroll Race Once, Stop Reroll and status copying remain available. Settings store the canonical list as RaceStopRarities and restore all selections; older rarity settings migrate to a one-element selection. Legacy AutoRollSkills settings cannot restore the removed worker.

Validation: 25 controller checks and full-engine integration across 66 controls passed. Tests cover stopping on either selected level, continuing on an unselected higher level, empty selections, unknown rarity, multi-selection persistence and legacy migration, race-slot arguments, no Class entries, no skill requests or target-lock requests, cooldowns and cleanup. Luau compilation and packed roundtrips passed. The changed selection behavior still requires live game verification.

## Get Roll labels: loot-reroll-13

Renames the former Update Reward Requests panel to Get Roll, its toggle to Get Reroll Tickets, and its interval to Get Roll interval. The description now identifies reroll-ticket requests. This is a label-only change; the existing request payloads are retained.
