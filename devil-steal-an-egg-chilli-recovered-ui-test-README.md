# DEVIL HUB / recovered native UI test

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil-steal-an-egg-chilli-recovered-ui-test.lua?v=native-ui-2"))()
```

Rejoin the game once before this test. Do not run an older Chilli/full-runtime/main-GUI entry in the same session first. Re-running this entry after its native engine has loaded only recreates the presentation adapter.

The previous Delta report contained 513,299 GC objects but zero tables. Looking up the native Window table with getgc cannot work in that environment. This test exposes the actual Window at its original native constructor, then mounts the existing DEVIL HUB OuroFlow GUI through that direct reference. It preserves existing UI state, callbacks, game bytecode, native gameplay functions, pet/egg widget identities and panel models.

Recovery method:

1. Decode the two original base85/LZMA layers.
2. Insert one Window-reference export in the readable native UI constructor.
3. Recompress that native runtime and update its decompressed-size literal.
4. Leave the first compressed game-bytecode layer byte-for-byte unchanged.
5. Run the original native bootstrap and bind the adapter to the exported Window.

The modified runtime is pinned to repository commit `240605144ed77233812561e9e3e575947335860d`. Download length is 848,731 bytes; transfer checksum is 3,927,989,284; SHA256 is `efa916b402ffc953b1ddea72511ed145e60f8edd9e264a91a6f78ba49cc40bef`. Original game-bytecode SHA256 remains `bba27d55c13ed1e4208566067350790a76e04b17c2391d3934ce9ed3484a6cbd`.

**This is partial native-layer recovery, not complete VM devirtualization.** The bytecode and VM remain present. Protected code may reject modifications in the live executor, so offline compilation and layer verification do not establish live compatibility. The test must be checked in Delta before changing the main loader route.

Validation: official Luau compilation; original bootstrap actually decompresses the modified native layer to the exact expected source and passes identical game bytecode; the extracted native Window constructor exports its actual table; the bridge mounts controls with no GC tables; existing callback, widget, hide/restore, sidebar and wrapper contract checks pass. The sandbox tests do not execute the protected game VM.

If it fails, copy `DevilChilliMainUI-report.json`. If failure occurs before adapter mounting, use `DevilChilliFullTest-report.json` and the DEVIL HUB console error. Successful direct discovery appears as `Recovered native UI constructor export (no getgc required)` in the GUI report.

The existing main loader and previous GUI runner are unchanged by this separate test.

Release 2 restyles only the native Steal Panel: navy cards, blue/cyan Steal actions, a blue/black header, rounded thin borders, compact cyan accent, Gotham typography and a blue scrollbar. Original pet images, rarity gradients, numeric values, sort behavior, Auto/Instant toggles, favorite/queue actions, callbacks, visibility and layout geometry are retained. Six verified presentation replacements can be reversed byte-for-byte to restore the original panel factory. The pure style helper creates no gameplay callbacks or input/event connections and is idempotent. Nine focused tests cover callback survival, repeated styling, live labels/images/rarity colors and unchanged geometry.
