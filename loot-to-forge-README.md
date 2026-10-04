# Devil Hub / Loot to Forge

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loot-to-forge.lua"))()
```

Uses the same untouched Ouroboros game revision tested with the test loader:
c8c823473a8440cd1cd426b47d0edb1ec1ec80af.
Original OuroFlow layout, tabs, controls, gameplay and configurations remain.
The window/home title and hub/toggle logo use DEVIL HUB branding. The default
theme is Abyss: near-black panels with blue accents.

Discord and Supported Games copy actions return https://discord.gg/ZY7PRcVJe2.
Both cards display the same Discord invite below their headings. Buttons are
retained. Other clipboard values
such as Job ID and user profile links remain unchanged.

Requires executor loadstring and HTTP hooks. Start a fresh game session after
switching from the test script. Duplicate startup is blocked. Native UI unload
restores hooks. The untouched game revision retains its authorization checks.

Validated with official Luau compilation, packed integrity and mocks for
constructor return values, native layout/configs, branding, scoped clipboard
and HTTP behavior, startup errors and cleanup. The upstream test was confirmed
working by the user; the branded wrapper has not been verified in-game here.
