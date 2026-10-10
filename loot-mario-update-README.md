# Loot to Forge: loot-mario-1

The main loader now routes Loot to Forge to the complete gameplay set from the
user-supplied [xDTaraZ reference](https://github.com/xDTaraZz/Roblox-Scripts/blob/d3e2eb63732301d34a3daf2fb5e7ffd33459e6e3/All%20Map/Loot%20To%20Forge.lua).
That file was already readable; this is an adaptation, not a claimed recovery
of an obfuscated VM. Original gameplay names and source attribution are retained
in the private build records. The gameplay and DEVIL GUI host ship as VM bytecode.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader?v=loot-mario-1"))()
```

The previous Loot interface and engine are replaced together. DEVIL HUB retains
its logo, Discord invitation, OuroFlow interface and Abyss theme. The reference's
ten tabs and all gameplay controls appear in the new GUI:

- Main: status, equipped gear, current task, Kaitun, rewards and codes.
- Gear: best gear, rune priority, enhance targets, equip and manual enhancement.
- Combat & Farm: stages, ore rarity filters, combat, bosses and the item index.
- Forge: gear/ore choices, rarity filters, quantities and automatic forging.
- Sell: gear type/rarity filters, retention limits and automatic/manual sales.
- Upgrade & Rebirth: training, clicking, upgrades and rebirth.
- Tower: tower farming, season rewards, spins and selected goods.
- Spawn Items: the reference's item, gear, roll/ticket/token, potion and stone controls.
- Player: race targets, rarity and stars, roll slots, refill/lock/protection,
  best slot, movement and survival controls.
- Settings: configuration profiles/autoload, rejoin, rendering, old-server
  version target/search/stop, emptiest-server hop and saved positions.

Single/multiple dropdowns preserve the reference callback data shapes. Refresh
buttons, chained buttons, numeric inputs and movement hotkeys remain connected.
Optional dropdown item images are stored as metadata; choices in this frontend
use the reference's text labels. Configurations use the separate
`DevilHub/LootToForgeMario` folder. Existing settings from the old engine are not
automatically enabled. Unload stops the scheduler, tracked tasks/connections,
restores modified game methods/hooks and releases muted roll animations.

Get Roll and Find Old Server remain available. The roll grant function first
compares the actual roll balance after one request; if it does not increase,
bulk claims return zero. It retains the supplied reference's whitespace-prefixed
UpdateLog reward method. The old-server search remembers known server IDs and
checks the version after joining, with a bounded hop count. A server list cannot
prove a server's version before joining. Old servers might no longer exist, and
neither that search nor the original features guarantee that patched servers
will grant tickets, free purchases, damage or inventory changes.

Validation: 47 interface checks exercise all ten builders, 70 registered options,
107 option/button controls, multi-selection shapes, sliders, numeric inputs,
hotkeys, unsupported features and unload. The same checks pass with the adapter
and interface executing as compiled VM bytecode. Twelve Get Roll checks cover
patched/accepting mock servers and bounded requests. Fourteen checks execute the
actual public Loot host and embedded VM, including initialization and cleanup.
Five-map router/cross-map tests, compilation and payload packing pass. No live
Roblox/Delta execution is claimed.
