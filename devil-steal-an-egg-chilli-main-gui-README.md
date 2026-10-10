# DEVIL HUB / Chilli — main GUI, embedded native panels

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil-steal-an-egg-chilli-main-gui.lua?v=main-gui-4"))()
```

Steal an Egg uses the existing DEVIL HUB OuroFlow frontend. Release 2 expands the left sidebar, puts icons beside readable tab names, and keeps the original tab/section grouping. It does not build an unrelated GUI or replace the protected gameplay engine.

The original owned Chilli window and launcher ScreenGuis are hidden while this adapter is active, including attempts to re-enable them. Only those owned GUIs are affected; game HUDs are not hidden. Removing the adapter restores the original screens and menu.

Native inventory, pet/egg images, numeric labels, item buttons and viewport models are embedded directly in DEVIL HUB groupboxes. These are the actual live widget instances with their original callbacks and controllers, rather than copied screenshots or simplified item actions. Panel heights track their native layout, tab selection stays linked to the original tabs, and native models keep their rendering controller. The release no longer opens the original window as a fallback for rich panels.

On UI removal, embedded widgets are detached and restored to their original parents **before** the DEVIL HUB GUI is destroyed. Their geometry and UI styling are restored. Gameplay callbacks, state bindings, remote calls and source logic are not rewritten.

The native Chilli engine remains unchanged; its wrapper only removes the old full-test loading notification, pinned to `5718ad8818f412ccca12d67dc18dbc2964b7a829` (848,305 bytes). Original runtime SHA256: `6c0a0cd11368cff8b1b2d18cb1d17f4e57afbed8d3c917f66062324d2332162c`.

OuroFlow remains based on commit `c8251f76f74d9942114ebccb0564aa0ac196320a`. Four presentation-only replacements adjust sidebar width, row height, icon position and label alignment; its method signatures and callbacks are unchanged. Original library SHA256: `0c30762d3c9c3aa7c25ca3aeceab960a771c96b5af290a3b67aed627161385f5`.

Discovery still requires Delta to expose the original native `Window` table through `getgc(true)`. If this fails, the original GUI is kept available and the reason is written to `DevilChilliMainUI-report.json`. If an interactive panel cannot be embedded, the adapter restores the original interface instead of discarding the feature or generating dummy controls.

Validation: official Luau compilation; native-source bridge tests for callbacks, synchronization, rich image/button identity, changing panel height, preventing duplicate owned screens, and safe restoration; sidebar presentation checks; 20 full-runtime wrapper regression checks. Offline tests do not execute the protected game engine or validate Delta rendering. This release still needs an in-game check. The main loader route and other maps are unchanged.

Release 3 installs a presentation guard before launching the unchanged runtime. It hides the exact ChilliHubLoading screen and owned native window/launcher in CoreGui, gethui and PlayerGui, including screens created later. The guard restores visibility on runtime failure or adapter removal; native Instances and controllers remain intact. Use the main-gui entry above, not the old full-runtime-test entry, which intentionally displays the original interface.

Release 4 also covers supplemental native GUIs with randomized names: the verified Chilli fire image asset, exact Chilli Hub title, native performance screen footprint, and every ChilliLibraryOwned screen (including Quick Bars). Screens populated after parenting are watched. DEVIL HUB marks its own GUI exempt before embedding rich native rows. The original game HUD is preserved. No native widgets are destroyed and no feature toggle is changed.
