# DEVIL HUB / recovered native UI test

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil-steal-an-egg-chilli-recovered-ui-test.lua?v=native-ui-4"))()
```

Rejoin the game once before this test. Do not run an older Chilli/full-runtime/main-GUI entry in the same session first. Re-running this entry after its native engine has loaded only recreates the presentation adapter.

The previous Delta report contained 513,299 GC objects but zero tables. Looking up the native Window table with getgc cannot work in that environment. This test exposes the actual Window at its original native constructor, then mounts the existing DEVIL HUB OuroFlow GUI through that direct reference. It preserves existing UI state, callbacks, game bytecode, native gameplay functions, pet/egg widget identities and panel models.

Recovery method:

1. Decode the two original base85/LZMA layers.
2. Insert one Window-reference export in the readable native UI constructor.
3. Recompress that native runtime and update its decompressed-size literal.
4. Leave the first compressed game-bytecode layer byte-for-byte unchanged.
5. Run the original native bootstrap and bind the adapter to the exported Window.

The modified runtime is pinned to repository commit `c2635eefbfac417cf6a3ebc9ed77a01db0132aff`. Download length is 848,796 bytes; transfer checksum is 2,545,282,089; SHA256 is `1ee3e8b49319d44d2aeaf9c7bb7229e6cf24591976bf58c1c32c47222173c843`. Original game-bytecode SHA256 remains `bba27d55c13ed1e4208566067350790a76e04b17c2391d3934ce9ed3484a6cbd`.

**This is partial native-layer recovery, not complete VM devirtualization.** The bytecode and VM remain present. Protected code may reject modifications in the live executor, so offline compilation and layer verification do not establish live compatibility. The test must be checked in Delta before changing the main loader route.

Validation: official Luau compilation; original bootstrap actually decompresses the modified native layer to the exact expected source and passes identical game bytecode; the extracted native Window constructor exports its actual table; the bridge mounts controls with no GC tables; existing callback, widget, hide/restore, sidebar and wrapper contract checks pass. The sandbox tests do not execute the protected game VM.

If it fails, copy `DevilChilliMainUI-report.json`. If failure occurs before adapter mounting, use `DevilChilliFullTest-report.json` and the DEVIL HUB console error. Successful direct discovery appears as `Recovered native UI constructor export (no getgc required)` in the GUI report.

The existing main loader and previous GUI runner are unchanged by this separate test.

Release 2 restyles only the native Steal Panel: navy cards, blue/cyan Steal actions, a blue/black header, rounded thin borders, compact cyan accent, Gotham typography and a blue scrollbar. Original pet images, rarity gradients, numeric values, sort behavior, Auto/Instant toggles, favorite/queue actions, callbacks, visibility and layout geometry are retained. Six verified presentation replacements can be reversed byte-for-byte to restore the original panel factory. The pure style helper creates no gameplay callbacks or input/event connections and is idempotent. Nine focused tests cover callback survival, repeated styling, live labels/images/rarity colors and unchanged geometry.

Release 3 fixes the styled panel's cloned UIStroke sizing: pixel thickness is explicitly FixedSize, preventing the blue border from scaling across the screen. Startup detection now examines each added GUI node once rather than rescanning its entire ScreenGui on every addition. A 1,000-node HUD regression test verifies no additional full-tree scans. Original gameplay bytecode and callbacks remain unchanged.

DEVIL HUB now displays a centered navy/blue loading card with actual download, integrity-check, compile, native-start and interface-mount stages. The card is marked as DEVIL-owned before parenting, caps its width on large screens, displays failures briefly, and cleans up on completion. Concurrent startup requests are ignored. Checksum and first UI construction batches yield to Roblox; fallback GC discovery also yields in batches. Compilation/decompression inside the protected VM can still block temporarily; no live Delta freeze-free claim is made.

Validation for this release: 104 focused offline checks, outer/inner Luau syntax compilation and original-bootstrap bytecode/decompression verification. Main loader routing remains unchanged; use the standalone entry above and rejoin once before switching from an older engine.

Release 4 fixes a second border-size writer inside the original panel module. Its native responsive updater now skips only strokes marked DevilHubPixelStroke; ordinary native strokes retain their original behavior. This prevents a fixed 1.5-pixel border from being multiplied by the native panel's scaled reference thickness. Regression checks execute the extracted native updater at several screen scales and verify the original updater still handles unmarked strokes normally.

The original Chilli loading ScreenGui is disabled at its constructor before parenting. DEVIL HUB stage labels now use plain ASCII to avoid previously corrupted punctuation caused by a Windows text-encoding round trip. Loading failures display a short readable notice; raw diagnostics remain in the report/console instead of being inserted into the card. Focused loader tests verify cleanup, stage display and error text handling. Native gameplay bytecode, callbacks, panels and functionality remain unchanged. Live Delta verification remains required.
