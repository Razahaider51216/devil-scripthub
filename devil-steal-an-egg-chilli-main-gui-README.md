# DEVIL HUB / Chilli — existing main GUI test

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil-steal-an-egg-chilli-main-gui.lua?v=main-gui-1"))()
```

Steal an Egg entry using **the existing DEVIL HUB OuroFlow GUI**, with the same library commit, logo, Abyss theme, window configuration, profile, search and floating button as the main script. The cancelled custom GUI redesign is not included.

The complete native Chilli engine remains pinned to `5718ad8818f412ccca12d67dc18dbc2964b7a829`. Its 848,305 bytes and original full-runtime wrapper are unchanged. The GUI library is included verbatim from OuroFlow commit `c8251f76f74d9942114ebccb0564aa0ac196320a`; no new GUI library or gameplay engine is substituted.

The presentation bridge discovers the original Chilli `Window` table through `getgc(true)` and verifies that its tabs belong to the owned `Settings` ScreenGui. It then routes controls through the original option methods: `Get`, `Set(value, true)`, `Press`, and `Apply`. Existing state sharing, exclusivity and gameplay callbacks stay in those methods. Initial construction and UI synchronization do not fire gameplay callbacks. Native option visibility, updated dropdown choices and slider ranges are reflected in the main GUI.

Complex native inventory/canvas/model panels remain accessible through a button that opens their original tab and panel. Their item actions are not replaced with simplified or fake controls. Therefore this is a main-GUI adapter, **not a complete replacement of every rich native panel**.

Running this entry after the full Chilli test already loaded reattaches the UI without launching the protected engine twice. Removing the DEVIL HUB UI restores the original menu and keeps the engine running. This standalone test does not change the main loader route or the other maps.

If Delta does not expose the original UI tables, the adapter leaves the original menu available and writes `DevilChilliMainUI-report.json`. A copied report can identify whether handle discovery or a particular UI method failed. The adapter never generates dummy controls when the original handles are unavailable.

Validation: official Luau syntax compilation, 25 bridge contract checks using native-source toggle and option methods, and 20 full-runtime wrapper regression checks. Runtime and GUI-library SHA256 hashes are verified during assembly. The protected gameplay engine was not executed by these offline tests. The user previously reported that the original pinned engine worked; this new GUI adapter still needs an in-game Delta test.

Runtime SHA256: `6c0a0cd11368cff8b1b2d18cb1d17f4e57afbed8d3c917f66062324d2332162c`.

Existing main GUI library SHA256: `0c30762d3c9c3aa7c25ca3aeceab960a771c96b5af290a3b67aed627161385f5`.
