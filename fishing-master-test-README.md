# DEVIL HUB Fishing Master standalone v10

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/fishing-master-test.lua?v=10"))()
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
The separate floating Fishing Master version/status bar and its settings
section are removed. Gameplay automation is preserved.

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
- Native game workers, 12 event connections and owned hooks are tracked and
  cleaned when the library unloads or startup fails. Downloads time out after
  30 seconds; game setup times out after 90 seconds with cleanup.
- Existing automation defaults remain off. No previous game backend is loaded.

Cleanup if needed:
```lua
local cleanup = getgenv().DevilFishingNNVNCleanup
if cleanup then cleanup() end
```

## Input fixes in v8

- Catch popup dismissal fires one registered Continue/Dismiss/Close button signal.
  It never clicks the screen center or selects an arbitrary unrelated button.
  Hidden popup ancestors and the DEVIL HUB GUI are excluded from detection.
  This path requires `firesignal` and `getconnections`.
- Auto Pull owns reeling clicks while enabled. Auto Click shares its throttle,
  and both skill modes share a batch lock and cooldowns.
- Mouse/key input and skill batches use a shared lock to prevent concurrent
  presses. Skills run only during FirstPull/Reeling and honor visible locked
  slots, positive cooldown labels and an available IsUsingSkill state.
- Automated input pauses while typing, interacting with the DEVIL GUI, or
  handling a selling action. Hovering without pressing does not pause farming.
- Synthetic mouse targets exclude the DEVIL window and PlayerGui buttons.
  Stopping the script releases any held mouse/key input.
- Generic QTE containers called Counter/Direction no longer imply an Up input.

## Mobile regression fix in v9

The v8 GUI interaction probe incorrectly called `UserInputService:GetTouches`,
which is not part of the Roblox API. An error in that probe could terminate
an automation worker on touch devices. It now tracks `TouchStarted` and
`TouchEnded` events, disconnects them with the runtime and pauses only while
pressing/dragging inside the GUI. Merely hovering no longer blocks automation.
Reference: https://create.roblox.com/docs/reference/engine/classes/UserInputService

Input probe errors cannot terminate game workers. Mouse target selection also
checks free edge positions when the GUI covers the central candidates; an
unavailable executor GUI hit test falls back to the known DEVIL window bounds.
The existing anti-duplicate input lock and targeted popup dismissal remain.

## Additional compatibility and diagnostics in v10

The original upstream `(0, 0)` mouse target is restored as the first candidate,
with DEVIL-window protection retained. Rod detection prefers the existing
FishingController `IsRodEquipped` method when available, so an equipped rod
whose tool name does not contain "rod" is recognized. Both Auto Skills modes
can run; the shared lock/cooldowns prevent duplicate batches.

Seventeen persistent workers report exceptions and retry after two seconds.
One-shot purchase/sale callbacks are not automatically retried. The existing
Debug State button prints `[DEVIL HUB / DIAGNOSTICS]` with controller readiness,
raw GetState errors, equipped rod status, enabled flags, input errors and worker
errors. A stalled enabled fishing system also prints one diagnostic snapshot
after about 15 seconds without increasing action counters.

The user-provided Soteria endpoint could not be retrieved: browser access failed
and direct HTTP failed DNS resolution. No source or systems from that endpoint
are included, and the underlying live game incompatibility remains unverified.

## Validation

Official Luau compilation passed. Existing 60 isolated offline checks passed,
plus four worker/diagnostic tests. These cover transient failure recovery,
stopping retries, warning deduplication and reporting raw controller errors.
Live Roblox/DeltaX behavior has not been verified; diagnostics are needed to
identify any remaining controller/executor mismatch.
