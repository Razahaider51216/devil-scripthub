# Devil Hub / Loot to Forge

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loot-to-forge.lua?v=loot-2k-5"))()
```

Uses the gameplay from the supplied [2KScripts LootToForge reference](https://github.com/hxrendontcry/2kscripts/blob/main/LootToForge.luau)
with Devil Hub's existing OuroFlow GUI, pinned to
`c8251f76f74d9942114ebccb0564aa0ac196320a`. Native tabs, groupboxes, widgets,
the Abyss theme and Devil Hub logo are retained. The reference's custom TwoKUI
window renderer is replaced by a Section/Toggle/Slider/Dropdown/Button bridge.

This supersedes loot-2k-1/2/3 and the old Ouroboros game engine. There is one
reference engine, rather than two overlapping farm implementations.

## Reference systems

The eight reference tabs and 59 named controls are connected to the original
State callbacks, including:

- Power training, automatic stage clears, dungeon farming, Super Loot and World
  Boss automation, selected potions and x100 training at Zone 9.
- Gear/ore/enchant-stone selling, selectable rarity filters and reward claims.
- Forge options, equip best and automatic enchanting.
- Upgrades, rebirth and class rolling with target rarity.
- God Spawner: four armor/hat sets, four weapons and the Ember Stone routine.
- FPS/graphics controls, Anti-AFK, character movement, scale/theme settings,
  and reference configuration save/load.

The reference uses **ReplicatedStorage.Remote** (singular). Previous optional
additions incorrectly searched `Remotes`, causing supported requests to be
missed. The full engine now uses the original root and remote names directly.
Spawner buttons always appear, as in the reference. GetArmorRE/GetWeaponRE
requests and subsequent inventory/equip actions retain the original IDs.

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
