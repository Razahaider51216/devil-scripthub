# DEVIL HUB / Loot to Forge — separate custom GUI

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil-loot-to-forge-avenger.lua?v=devil-blue-2"))()
```

This separate entry contains a newly written Roblox instance GUI. It does not
download OuroFlow, the reference UI, or another UI framework. The main loader
continues to use its existing Loot entry. Starting either Loot entry stops the
other entry's tracked gameplay, preventing duplicate automation.

The interface uses translucent black panels, blue accents, a wide window up to
1160 by 720 pixels, animated icons and a silver DEVIL HUB logo. Every tab shows
its name beside its icon. Portrait phones use a horizontally scrollable named
navigation bar above the content; landscape and desktop use the sidebar.
Visible branding uses DEVIL HUB and Loot to Forge, without decorative theme
names. Animation can be disabled from Settings. Roblox's default rectangular
borders are disabled, strokes use Border mode, and control rows are transparent
so nested opaque rectangles do not cover the rounded cards.

The logo is an edited transparent PNG prepared from the user's silver logo
with the built-in imagegen tool: [logo asset](assets/devil-logo-silver-transparent.png).
Edit prompt: remove the black background, preserve the silver/chrome monogram,
diagonal swoosh, two round endpoints, bevels, proportions and orientation;
add no text, glow or border. The host uses a separate v2 local asset cache.

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

Wide desktop and landscape layouts use two columns when room permits. Narrow
portrait layouts use one column, with both groups in the same scrollable
page. Navigation scrolls independently. Dropdowns open in a separate searchable
panel, outside card clipping. Header and floating logo dragging support touch;
viewport changes recalculate bounds. Information buttons show descriptions.
Sliders, hotkeys, status labels, hide/restore, unload and profiles are supported.
Named configuration profiles/autoload are stored separately under
`DevilHub/LootToForgeAvenger/Profiles`. Selectors load before automation toggles.

GUI, adapter, gameplay and host are compiled through the existing VM pipeline
(four compiled layers). Runtime virtualization does not guarantee source secrecy.

Validation: 77 checks construct the actual custom GUI instance tree through all
ten reference interface builders, test 70 options, mobile reparenting/scroll
configuration, image previews and rows, multi-selection, profile save/load,
path validation, icon motion, named mobile navigation, translucent backgrounds,
border defaults, clean branding and connection cleanup. The same
checks pass with renderer, adapter and interface executing as VM bytecode.
Official Luau compilation and packed payload roundtrip pass. Layout previews
are rendered from a mock instance model; they are not Roblox screenshots.
Actual Delta/Roblox behavior still requires a live run.
