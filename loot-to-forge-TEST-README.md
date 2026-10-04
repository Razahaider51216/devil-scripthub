# Loot to Forge test

Open Loot to Forge (place 118805555015549 / universe 10684750879), then run:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loot-to-forge-test.lua"))()
```

This entry executes the untouched public Ouroboros Centurion build pinned to
c8c823473a8440cd1cd426b47d0edb1ec1ec80af. It retains the original GUI and
features. It does not execute the partially recovered inspection files and
does not alter Devil Hub production.

If the latest version fails on your executor, rejoin the game and try the
earlier original luast revision with loot-to-forge-legacy-test.lua instead.
That revision is pinned to 66b31d4f88fd27bf5d0150f9169acf43cbdd1281.
Do not run both in the same session. Console output distinguishes download,
compile and runtime errors. Duplicate startup and wrong-game guards are included.

Loader and upstream artifacts compile with official Luau. Loader mocks cover
source selection, untouched payload forwarding, errors and startup guards.
Actual Roblox / DeltaX compatibility remains unverified.
