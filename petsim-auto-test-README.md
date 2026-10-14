# DEVIL HUB Pet automation trial

Release: petsim-auto-test-5. Standalone, based on the client source in the dump for Place 8737899170 / Universe 3317771874.

Run:

    loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/petsim-auto-test.lua?v=test-5"))()

Features: locked-target pet farming, nearby Auto Tap, collection of newly received currency-orb IDs, item magnet for orbs and lootbags, selected-egg hatching, Equip Best, eligible playtime gifts, eligible rank rewards, next-zone purchases, and rebirth.

DEVIL HUB / OuroFlow GUI with profile, DEVIL logo, Thai/English button beside minimize, Discord, responsive width control, Stop All and Copy / Save Report. No additional loading screen.

Pet Spawn Test is a separate GUI category. Select a directory pet by class (Gargantuan, Titanic, Huge, Exclusive, Normal or All), then Normal / Golden / Rainbow and optional Shiny. Class ordering reflects the directory flags rather than a claim about maximum damage. Invalid variants are rejected before sending.

The test builds the native PetItem with SetType, SetShiny and PopulateUID, then sends AdminInventory_SpawnItem(item:GetNetworkPacket(), 1, LocalPlayer), matching the supplied admin client source. It requests one pet per attempt. Unconfirmed requests retry after 12, 24 and then 30 seconds until stopped or a matching increase is observed. Stop Spawn Test, Stop All and Unload cancel further attempts; errors retry after 15 seconds. It never calls the admin client's local WorldFX.RewardItem animation or inserts the requested template into inventory.

This dump includes a client admin whitelist but no server handler; the current account's server permissions are unknown. Repetition does not grant admin rights. A sent request is not evidence of a spawned pet, and an ignored request remains unconfirmed. The worker records matching native PetItem:All(LocalPlayer) quantity before/after and requires an own-player Items: Update packet containing Pet data before counting an observed increase. This documents an inventory observation, not proof that the admin request caused it; unrelated server grants could coincide. Save Report includes spawnTest requests, attempts, variant, baseline, current count, serverUpdates, retry deadline and errors.

While the test runs, new Hatch, Gifts and Ranks requests pause and resume afterward. Already pending requests and rank confirmations can finish before the spawn baseline is taken. Native auto hatch must be stopped separately. Every automation, including the spawn test, starts off.

All automation starts disabled. Stand in a loaded breakable zone, equip pets and enable Farm first. The farm uses native PlayerPet.SetTarget and resubmits the native CQ_Route and Breakables_JoinPetBulk packets every three seconds for owned, equipped pets. It validates native Breakable targets, locks one target until it disappears, handles model replacement during damage stages, and scans loaded native models if the legacy index is late. Target health changes are logged as damage observations, separately from reward confirmations. Auto Tap requires proximity and game acceptance.

If no equipped pet objects are loaded, Farm requests native Equip Best at most once every fifteen seconds while waiting.

The Farm tab has Teleport to Highest Unlocked Zone and Try Final Zone Once. Both select zones only in the current world. The normal action chooses the highest owned zone whose rebirth requirements are met. The final-zone probe bypasses the client ownership precheck and sends one Teleports_RequestTeleport request, recording the server's actual response. It does not modify ownership or repeat rejected requests. Server acceptance, observed arrival and ownership after arrival are separate report fields. Teleport actions pause workers while pending and preserve enabled automations afterward.

The orb queue captures Orbs: Create packets received after this script loads. It submits actual IDs in batches of at most 100, expires old entries and clears on a game orb reset. Currency orbs and lootbags are distinguished by config.Type. It does not fabricate currency or items.

Item Magnet uses the native Orb.RenderStepped attraction parameters when hookfunction is supported, including for already loaded objects. It temporarily extends magnet distance and restores the object's original flag after every call. Unload restores the native function. If the executor does not support this path, the mode falls back to batching genuine newly received orb and lootbag IDs. The normal orb worker yields to the magnet worker to avoid duplicate collection. Attraction radius is configurable; server-side inventory acceptance remains authoritative.

Hatching spends game currency. It checks EggCmds.IsEggAvailable, requests eligible regular-egg unlocks before buying, and clamps purchase count to EggCmds.GetMaxHatch and the affordable quantity using CalcEggPricePlayer. Active custom eggs use CustomEggs_Hatch with the actual nearest live UID and instance count cap. It avoids competing with native auto hatch and reports missing funds, inactive eggs or server rejection.

Hatching sends requests from the player's current location, per the latest user preference. It does not move to an egg, impose a local distance gate, or require a loaded regular-egg model. Distance is diagnostic only. The live report showed that the server can reject requests at 382.63 studs; this change does not claim to bypass that server check. Highest-zone travel buttons remain separate manual actions.

Bypass Tap / Skip Egg Animation defaults on while this script's Hatch is enabled. Where script access is supported, it replaces PlayNormalEggAnimation and PlayTowerDefenseAnimations with an enabled-only presentation skip. It preserves the outer native Eggs_PlayOpenAnimation handler, including item unhide, SM_Unmask and CompletedHatching. Without script access, it uses the native GlobalInstantHatch branch to remove the four-click crack stage. Existing presentations can be advanced using scoped native mouse callbacks (or a mouse signal fallback when available) only while OpeningEgg is positive. Native functions and the previous instant-hatch attribute are restored on stop/unload. The report includes hatchUI.mode, skipped, tapReleased and errors.

The empty-selector regression came from comparing an egg's currency string to WorldsUtil.GetWorldCurrency(), which returns a directory table. The selector now uses GetWorldCurrencyId() or normalizes the table's _id. Numbered regular eggs remain visible before profile data loads; unavailable eggs get a Locked annotation. An unknown currency with no matches falls back to the numbered catalog instead of an empty selector. Active custom eggs have Event labels; inactive definitions do not become 000 entries. A three-second refresh updates the existing dropdown silently, preserving the selected egg, automation, open tab and GUI. Refresh Egg List is also available manually. Per-attempt hatch details are cleared before the next attempt so an unavailable egg cannot retain an old distance error.

Fire-and-forget events show that they have no reply, rather than displaying a misleading zero confirmation counter. Pet farm shows assigned-pet and observed-damage counts. Server cooldown and inventory authority remain unchanged. Next-zone purchases preserve the specified zone-purchase currency reserve. Rebirth and purchases remain off until explicitly enabled.

Native Network.Invoke requests are serialized with a 12-second reporting timeout. An unanswered request retains the lock until completion, including across script reruns; no duplicate is sent while it is pending.

Request counters are separate from confirmations. Fire-and-forget pet assignment, tapping and orb requests do not imply rewards. Rank confirmations require replicated claim data. Save / Copy Report writes DevilPetSimTestReport.json when supported and copies the JSON when clipboard APIs are available.

Validation: Luau compilation; core, GUI/native-adapter, catalog regression and hatch-presentation bypass checks. Covers the actual currency table API shape, delayed profiles, locked entries, silent dropdown refresh, requests at 382 studs without character movement, stale error cleanup, native route/join packet shape, hatch limits and custom egg UID semantics, presentation skip with native completion preserved, restoration, magnet cleanup and rerun. Changes have not yet been validated in live Roblox.

The main hub loader is unchanged; this is a separate trial script.

Version 5 validation: Luau compilation, 70 core checks, 681 GUI/native-adapter checks, 28 spawn-state checks, 22 hatch-presentation checks and 11 catalog checks. Spawn coverage includes the dump-shaped packet and player receiver, native variant constants, no local template reward, retry intervals, error backoff, stop during construction, selection changes, own versus other-player replication, observed inventory increase, automatic stop, GUI synchronization, reward pause/resume and listener cleanup. No live Roblox spawn success has been established.
