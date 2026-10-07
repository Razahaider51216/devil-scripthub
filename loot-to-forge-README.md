# Devil Hub / Loot to Forge

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loot-to-forge.lua"))()
```

Retains the pinned Ouroboros game revision tested with the test loader:
c8c823473a8440cd1cd426b47d0edb1ec1ec80af.
Original OuroFlow layout, tabs, controls, gameplay and configurations remain,
with optional additions adapted from the supplied 2KScripts LootToForge source.
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

## Verified reference additions (loot-2k-1)

The existing GUI gains **Extra Automation** when a supported missing feature
is available. Each new toggle defaults off:

- Auto Enchant Equipped Gear: fills empty enchant slots on equipped weapons,
  armor and hats using owned EnchStone items, respecting their quantities.
- Auto Use Selected Potions: Train, Coin, Luck, Damage and HP; uses owned,
  selected potions only when the matching buff is inactive.
- Auto Roll Class: uses class tickets and stops at Epic, Legendary or Mythic
  (or higher), according to the selected target.
- Auto Claim Online Rewards and separate Update, Offline and Index reward
  toggles. Index level requests cover levels 1-10, as in the reference.

Native control flags/titles are observed before adding each feature. Existing
equivalents suppress the matching additions. Missing modules/remotes also omit
their controls; the number of displayed controls can therefore vary by session.
No new farm/forge/sell/dungeon workers are added. The original pinned gameplay
and its authorization behavior are retained.

Reference: [2KScripts LootToForge.luau](https://github.com/hxrendontcry/2kscripts/blob/main/LootToForge.luau),
build 2026-10-07T08:55:37.768Z, SHA256
`218647dfa0ff786534259887e59a04b4992f68d87bf505676acd617004076c52`.
Its loader registry identifies the Loot to Forge file; its outer cipher was
decoded locally. The separate telemetry/anti-environment loader is not used.
The current original VM was not fully reconstructed: overlap is checked against
the controls built by the actual original UI at runtime, rather than assuming
that absence from an older readable version proves a feature is missing.

Validation includes packed checksums/source roundtrip, official Luau compilation,
executable API mocks, resource limits, active-buff avoidance, class target stop,
reward requests, duplicate-feature omission, missing-API omission, cancellation
and actual wrapper integration/cleanup. Live Roblox behavior remains unverified.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loot-to-forge.lua?v=loot-2k-1"))()
```
