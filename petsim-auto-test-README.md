# DEVIL HUB Pet automation trial

Release: petsim-auto-test-3. Standalone, based on the client source in the dump for Place 8737899170 / Universe 3317771874.

Run:

    loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/petsim-auto-test.lua?v=test-3"))()

Features: locked-target pet farming, nearby Auto Tap, collection of newly received currency-orb IDs, item magnet for orbs and lootbags, selected-egg hatching, Equip Best, eligible playtime gifts, eligible rank rewards, next-zone purchases, and rebirth.

DEVIL HUB / OuroFlow GUI with profile, DEVIL logo, Thai/English button beside minimize, Discord, responsive width control, Stop All and Copy / Save Report. No additional loading screen.

All automation starts disabled. Stand in a loaded breakable zone, equip pets and enable Farm first. The farm uses native PlayerPet.SetTarget and resubmits the native CQ_Route and Breakables_JoinPetBulk packets every three seconds for owned, equipped pets. It validates native Breakable targets, locks one target until it disappears, handles model replacement during damage stages, and scans loaded native models if the legacy index is late. Target health changes are logged as damage observations, separately from reward confirmations. Auto Tap requires proximity and game acceptance.

If no equipped pet objects are loaded, Farm requests native Equip Best at most once every fifteen seconds while waiting.

The Farm tab has Teleport to Highest Unlocked Zone and Try Final Zone Once. Both select zones only in the current world. The normal action chooses the highest owned zone whose rebirth requirements are met. The final-zone probe bypasses the client ownership precheck and sends one Teleports_RequestTeleport request, recording the server's actual response. It does not modify ownership or repeat rejected requests. Server acceptance, observed arrival and ownership after arrival are separate report fields. Teleport actions pause workers while pending and preserve enabled automations afterward.

The orb queue captures Orbs: Create packets received after this script loads. It submits actual IDs in batches of at most 100, expires old entries and clears on a game orb reset. Currency orbs and lootbags are distinguished by config.Type. It does not fabricate currency or items.

Item Magnet uses the native Orb.RenderStepped attraction parameters when hookfunction is supported, including for already loaded objects. It temporarily extends magnet distance and restores the object's original flag after every call. Unload restores the native function. If the executor does not support this path, the mode falls back to batching genuine newly received orb and lootbag IDs. The normal orb worker yields to the magnet worker to avoid duplicate collection. Attraction radius is configurable; server-side inventory acceptance remains authoritative.

Hatching spends game currency. It checks EggCmds.IsEggAvailable, requests eligible regular-egg unlocks before buying, and clamps purchase count to EggCmds.GetMaxHatch and the affordable quantity using CalcEggPricePlayer. Active custom eggs use CustomEggs_Hatch with the actual nearest live UID and instance count cap. It avoids competing with native auto hatch and reports missing funds, inactive eggs or server rejection.

The supplied live report confirmed a distance rejection at 382.63 studs. Auto approach now resolves the selected egg stand in the current world's loaded Eggs/ZoneEggs folders (or the actual live custom egg), pauses workers, invokes the native TeleportCharacterTo helper once, and requires three consecutive observations within 14 studs before submitting the hatch request. Missing models and unstable positions are reported rather than treated as arrival.

Bypass Tap / Skip Egg Animation defaults on while this script's Hatch is enabled. Where script access is supported, it replaces PlayNormalEggAnimation and PlayTowerDefenseAnimations with an enabled-only presentation skip. It preserves the outer native Eggs_PlayOpenAnimation handler, including item unhide, SM_Unmask and CompletedHatching. Without script access, it uses the native GlobalInstantHatch branch to remove the four-click crack stage. Existing presentations can be advanced using scoped native mouse callbacks (or a mouse signal fallback when available) only while OpeningEgg is positive. Native functions and the previous instant-hatch attribute are restored on stop/unload. The report includes hatchUI.mode, skipped, tapReleased and errors.

The egg dropdown contains available numbered eggs in the current world's currency and separately labelled Event entries for active, hatchable custom eggs. It no longer fills the dropdown with placeholder 000 entries for inactive directory definitions. Refresh Available Eggs updates eligibility after progression. Per-attempt hatch details are cleared before the next attempt so an unavailable egg cannot retain an old distance error.

Fire-and-forget events show that they have no reply, rather than displaying a misleading zero confirmation counter. Pet farm shows assigned-pet and observed-damage counts. Server cooldown and inventory authority remain unchanged. Next-zone purchases preserve the specified zone-purchase currency reserve. Rebirth and purchases remain off until explicitly enabled.

Native Network.Invoke requests are serialized with a 12-second reporting timeout. An unanswered request retains the lock until completion, including across script reruns; no duplicate is sent while it is pending.

Request counters are separate from confirmations. Fire-and-forget pet assignment, tapping and orb requests do not imply rewards. Rank confirmations require replicated claim data. Save / Copy Report writes DevilPetSimTestReport.json when supported and copies the JSON when clipboard APIs are available.

Validation: Luau compilation; core, GUI/native-adapter and hatch-presentation bypass checks. Covers target locking, native route/join packet shape, real-game hatch limits and custom egg UID semantics, approach-before-purchase, stale error cleanup, catalog filtering, presentation skip with native completion preserved, instant-hatch fallback, restoration, magnet parameter positions and hook cleanup, recovery, reward eligibility, pending requests, highest-zone selection and rerun. Changes have not yet been validated in live Roblox.

The main hub loader is unchanged; this is a separate trial script.
