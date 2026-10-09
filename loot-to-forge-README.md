# Devil Hub / Loot to Forge

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loot-to-forge.lua?v=loot-spawner-7"))()
```

Uses the gameplay from the supplied [2KScripts LootToForge reference](https://github.com/hxrendontcry/2kscripts/blob/main/LootToForge.luau)
with Devil Hub's existing OuroFlow GUI, pinned to
`c8251f76f74d9942114ebccb0564aa0ac196320a`. Native tabs, groupboxes, widgets,
the Abyss theme and Devil Hub logo are retained. The reference's custom TwoKUI
window renderer is replaced by a Section/Toggle/Slider/Dropdown/Button bridge.

This supersedes loot-2k-1/2/3 and the old Ouroboros game engine. There is one
reference engine, rather than two overlapping farm implementations.

## Reference systems

The eight reference tabs and 64 named controls are connected to the original
State callbacks, including:

- Power training, automatic stage clears, dungeon farming, Super Loot and World
  Boss automation, selected potions and x100 training at Zone 9.
- Gear/ore/enchant-stone selling, selectable rarity filters and reward claims.
- Forge options, equip best and automatic enchanting.
- Upgrades, rebirth and class rolling with target rarity.
- God Spawner: Apocalypse, The Tri-Wyrm, Cataclysm and Void Overlord sets, Apex Ore, tier II/III runes, Ember Stone and Race Roll requests.
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
