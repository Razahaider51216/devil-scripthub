# DEVIL HUB / Loot to Forge — separate custom GUI

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil-loot-to-forge-avenger.lua?v=avenger-1"))()
```

This separate entry contains a newly written Roblox instance GUI. It does not
download OuroFlow, the reference UI, or another UI framework. The main loader
continues to use its existing Loot entry. Starting either Loot entry stops the
other entry's tracked gameplay, preventing duplicate automation.

The new interface uses silver/ivory cards, crimson and gold accents, subtle
reactor rings, the existing DEVIL HUB logo, animated navigation icons and a
rotating logo gradient. Its visible branding uses DEVIL HUB and Loot to Forge;
decorative theme names and HERO/PROTOCOL labels are omitted. Animation can be
disabled from Settings. There is no black GUI background or full-screen dark
overlay. The original logo image is retained unchanged.

All ten reference gameplay tabs and 70 gameplay options remain connected.
The game systems are adapted from the same
[pinned xDTaraZ reference](https://github.com/xDTaraZz/Roblox-Scripts/blob/d3e2eb63732301d34a3daf2fb5e7ffd33459e6e3/All%20Map/Loot%20To%20Forge.lua)
used by the main Loot entry. This includes Get Roll and bounded old-server
search. The supplied reference was readable; no VM source recovery is claimed.
Server acceptance still determines which original game features work.

Image dropdowns now display the reference's `Look.Maps` results. Item/race
images come from the game's own `Config.*.Show` tables, and rarity colours come
from its helper. Images are shown beside available choices and in the selected
preview. Missing images use a neutral symbol; an image is not fabricated for
an unavailable game configuration. Multi-selection, search and refresh remain
connected to the original callback shapes.

Desktop layouts use two columns when room permits. Narrow/portrait/landscape
mobile layouts use one column, with both groups placed in the same scrollable
page. Navigation scrolls independently. Dropdowns open in a separate searchable
panel, outside card clipping. Header and floating logo dragging support touch;
viewport changes recalculate bounds. Information buttons show descriptions.
Sliders, hotkeys, status labels, hide/restore, unload and profiles are supported.
Named configuration profiles/autoload are stored separately under
`DevilHub/LootToForgeAvenger/Profiles`. Selectors load before automation toggles.

GUI, adapter, gameplay and host are compiled through the existing VM pipeline
(four compiled layers). Runtime virtualization does not guarantee source secrecy.

Validation: 65 checks construct the actual custom GUI instance tree through all
ten reference interface builders, test 70 options, mobile reparenting/scroll
configuration, image previews and rows, multi-selection, profile save/load,
path validation, icon motion, clean branding and connection cleanup. The same
checks pass with renderer, adapter and interface executing as VM bytecode.
Official Luau compilation and packed payload roundtrip pass. Layout previews
are rendered from a mock instance model; they are not Roblox screenshots.
Actual Delta/Roblox behavior still requires a live run.
