# DEVIL HUB Pet automation trial

Release: petsim-auto-test-2. Standalone, based on the client source in the dump for Place 8737899170 / Universe 3317771874.

Run:

    loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/petsim-auto-test.lua?v=test-2"))()

Features: locked-target pet farming, nearby Auto Tap, collection of newly received currency-orb IDs, item magnet for orbs and lootbags, selected-egg hatching, Equip Best, eligible playtime gifts, eligible rank rewards, next-zone purchases, and rebirth.

DEVIL HUB / OuroFlow GUI with profile, DEVIL logo, Thai/English button beside minimize, Discord, responsive width control, Stop All and Copy / Save Report. No additional loading screen.

All automation starts disabled. Stand in a loaded breakable zone, equip pets and enable Farm first. The farm uses native PlayerPet.SetTarget and resubmits the native CQ_Route and Breakables_JoinPetBulk packets every three seconds for owned, equipped pets. It validates native Breakable targets, locks one target until it disappears, handles model replacement during damage stages, and scans loaded native models if the legacy index is late. Target health changes are logged as damage observations, separately from reward confirmations. Auto Tap requires proximity and game acceptance.

If no equipped pet objects are loaded, Farm requests native Equip Best at most once every fifteen seconds while waiting.

The Farm tab has Teleport to Highest Unlocked Zone and Try Final Zone Once. Both select zones only in the current world. The normal action chooses the highest owned zone whose rebirth requirements are met. The final-zone probe bypasses the client ownership precheck and sends one Teleports_RequestTeleport request, recording the server's actual response. It does not modify ownership or repeat rejected requests. Server acceptance, observed arrival and ownership after arrival are separate report fields. Teleport actions pause workers while pending and preserve enabled automations afterward.

The orb queue captures Orbs: Create packets received after this script loads. It submits actual IDs in batches of at most 100, expires old entries and clears on a game orb reset. Currency orbs and lootbags are distinguished by config.Type. It does not fabricate currency or items.

Item Magnet uses the native Orb.RenderStepped attraction parameters when hookfunction is supported, including for already loaded objects. It temporarily extends magnet distance and restores the object's original flag after every call. Unload restores the native function. If the executor does not support this path, the mode falls back to batching genuine newly received orb and lootbag IDs. The normal orb worker yields to the magnet worker to avoid duplicate collection. Attraction radius is configurable; server-side inventory acceptance remains authoritative.

Hatching spends game currency. It checks EggCmds.IsEggAvailable, requests eligible regular-egg unlocks before buying, and clamps purchase count to EggCmds.GetMaxHatch and the affordable quantity using CalcEggPricePlayer. Active custom eggs use CustomEggs_Hatch with the actual nearest live UID and instance count cap. It avoids competing with native auto hatch and reports missing funds, inactive eggs or server rejection. Distance and cooldown conditions enforced by the game still apply. Next-zone purchases preserve the specified zone-purchase currency reserve. Rebirth and purchases remain off until explicitly enabled.

Native Network.Invoke requests are serialized with a 12-second reporting timeout. An unanswered request retains the lock until completion, including across script reruns; no duplicate is sent while it is pending.

Request counters are separate from confirmations. Fire-and-forget pet assignment, tapping and orb requests do not imply rewards. Rank confirmations require replicated claim data. Save / Copy Report writes DevilPetSimTestReport.json when supported and copies the JSON when clipboard APIs are available.

Validation: Luau compilation; 62 core checks and 374 GUI/native-adapter checks. Covers target locking, native route/join packet shape, real-game hatch limits and custom egg UID semantics, magnet parameter positions and hook cleanup, recovery, filters, reward eligibility, pending requests, rejection cooldown, disable during requests, highest-zone selection, final-zone rejection, arrival vs. ownership, language-state preservation, cleanup and rerun. Live Roblox behavior has not yet been tested.

The main hub loader is unchanged; this is a separate trial script.
