# DEVIL HUB Pet automation trial

Release: petsim-auto-test-1. Standalone, based on the client source in the dump for Place 8737899170 / Universe 3317771874.

Run:

    loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/petsim-auto-test.lua?v=test-1"))()

Features: locked-target pet farming, nearby Auto Tap, collection of newly received orb IDs, selected-egg hatching, Equip Best, eligible playtime gifts, eligible rank rewards, next-zone purchases, and rebirth.

DEVIL HUB / OuroFlow GUI with profile, DEVIL logo, Thai/English button beside minimize, Discord, responsive width control, Stop All and Copy / Save Report. No additional loading screen.

All automation starts disabled. Stand in a loaded breakable zone, equip pets and enable Farm first. The farm uses native PlayerPet.SetTarget, locks one target until it disappears, and respects the selected zone, target class and scan radius. It does not move the character between zones. Auto Tap requires proximity and game acceptance.

The orb queue captures Orbs: Create packets received after this script loads. It submits actual IDs in batches of at most 100, expires old entries and clears on a game orb reset. It does not fabricate currency or items; pre-existing orbs stay under the game's normal collector.

Hatching spends game currency and must satisfy egg unlock, distance, count and cooldown checks enforced by the game. Next-zone purchases preserve the specified zone-purchase currency reserve. Rebirth and purchases remain off until explicitly enabled.

Native Network.Invoke requests are serialized with a 12-second reporting timeout. An unanswered request retains the lock until completion, including across script reruns; no duplicate is sent while it is pending.

Request counters are separate from confirmations. Fire-and-forget pet assignment, tapping and orb requests do not imply rewards. Rank confirmations require replicated claim data. Save / Copy Report writes DevilPetSimTestReport.json when supported and copies the JSON when clipboard APIs are available.

Validation: Luau compilation; 42 core checks; 170 GUI checks. Covers target locking, recovery, filters, reward eligibility, pending requests, rejection cooldown, disable during requests, language-state preservation, cleanup and rerun. Live Roblox behavior has not yet been tested.

The main hub loader is unchanged; this is a separate trial script.
