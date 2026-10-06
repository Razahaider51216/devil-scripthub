# DEVIL HUB Fishing Master standalone v6

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/fishing-master-test.lua?v=6"))()
```

Run in a fresh Fishing Master session. This replaces the previous Ouroboros
backend completely with the publicly available NNVN Hub v1.4.8 game systems.
It remains a separate script; the existing four-game router is unchanged.

## Source and version

The requested current `Key.lua` forwards to PandaAuth. Its protected current
payload was not recovered or authenticated. This release uses the complete,
clear public `Main.lua` from commit
`c040fdc3bfe708eac12cbe3a78d20f27593c5a2d`, dated 2026-09-29:
https://raw.githubusercontent.com/n0namevnnek-web/Fishing-Master/c040fdc3bfe708eac12cbe3a78d20f27593c5a2d/Main.lua

Original source SHA-256:
`74cd3828aacf57b4b913b160b3b1c9e5229872ed82300b0abbea62899626ff7a`.
Original author credit and existing premium checks are retained. No PandaAuth
key validation or premium flag is bypassed.

The interface now uses the same OuroFlow library and Abyss blue/black theme
as the main DEVIL HUB scripts, pinned to commit
`7c495f5a17a2390d70809d628c82cd5384142dbd` in `joustingmatch/OuroFlow`, SHA-256
`b63399d1cefd5b61ca383d27a62110863e63350df856bfede18af198bf6992d3`.
A WindUI-to-OuroFlow adapter renders the native Fishing Master controls through
that library. The upstream UltraObsidian GUI is no longer downloaded or created.
The gameplay runtime is byte-identical to v5.

## Systems and integration changes

Native systems include casting, pulling/reeling, perfect casting, rod skills,
fish filters and locking, selling, quest chains, island travel/unlocks,
shop/rod purchases, skill and aura gacha, crates, rewards/codes, boss tools,
visuals and movement controls. Availability still depends on the game,
executor capabilities and any existing upstream feature restrictions.

- DEVIL HUB name, blue/black colors, logo and Discord:
  https://discord.gg/ZY7PRcVJe2.
- Main GUI sidebar, search, alternating two-column groupboxes, responsive layout,
  player profile and draggable DEVIL-logo reopen button on desktop/mobile.
  The Discord card uses the DEVIL logo, with no original avatar or banner.
- Auto Skills accepts Z/X/C/V and 1/2/3/4. Canonical registered slot callbacks
  are preferred; mobile button signals or the appropriate physical key are
  used as fallbacks, with one input path per attempt. Skills pause during text entry.
- SellAll and SellHeld wait for the native SellController response. Returning
  to the saved position happens only after `SellStatus.OK`. Failed sales stay
  at the seller and preserve the original return position for retries.
- Six hardcoded third-party weather webhook credentials are removed. Weather
  sending defaults off and uses only the user-entered Boss/Weather webhook URL.
- Native game workers, 13 event connections and owned hooks are tracked and
  cleaned when the library unloads or startup fails. Downloads time out after
  30 seconds; game setup times out after 90 seconds with cleanup.
- Existing automation defaults remain off. No previous game backend is loaded.

Cleanup if needed:
```lua
local cleanup = getgenv().DevilFishingNNVNCleanup
if cleanup then cleanup() end
```

## Validation

Official Luau compilation passed for the entry, modified game runtime,
context adapter, GUI bridge and pinned GUI. Isolated offline tests passed 13
sale/skill/lifecycle checks, 11 loader checks and 16 GUI bridge checks, covering pending RPCs, unsuccessful
sales, both input types, duplicate startup, failures, timeouts and cleanup.
Downloaded full game code was not executed locally. Live Roblox/DeltaX behavior
has not been verified, and no claim of universal anti-cheat bypass is made.
