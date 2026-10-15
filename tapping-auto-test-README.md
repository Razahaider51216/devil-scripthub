# DEVIL HUB Tapping automation trial

Release: tapping-auto-test-1. Standalone trial for Place 72858262610964 / Universe 10629695169, based on the client dump under Downloads/Devildumper.

Run:

    loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/tapping-auto-test.lua?v=test-1"))()

DEVIL HUB uses the existing pinned OuroFlow GUI and silver DEVIL logo, profile panel, Thai/English header button beside minimize, Discord invite/copy button, width/transparency controls, Stop All, Unload and Copy / Save Report. Every automation starts disabled. There is no zone-travel feature.

Features:

- Fast Auto Click sends TapService.RE.TapRequested with the native Auto=false, ClientSequence and Source=button_hold fields. Requested rate is configurable from 1 to 100 per second; a frame catches up at most four requests and never accumulates an unlimited backlog. Only matching, positive-Amount TapResult replies count as confirmations and income. Native manual/auto replies and duplicates are ignored. Pending tap entries expire after five seconds. The server may accept fewer taps than requested. Introduction, mining, digging and Colosseum gates remain.
- Infinite Jump uses UserInputService.JumpRequest and the living character's native Humanoid Jumping state. It supports the normal mobile jump control. It ignores focused text fields and disconnects on unload. It does not alter movement speed or teleport the player.
- Auto Open Egg selects a LaunchEggConfig entry and sends EggService.RE.EggHatchRequested with Egg, Count, Auto=true and Seq from the current location. It never approaches or moves to the egg. It selects 1/3/8 based on the user's maximum, current funds, storage, native x8Egg/OctoHatch entitlement and native EggPricing.GetTotal. It waits for a matching sequence, or a native-compatible unsequenced same-egg result, before another request. TooFar, IslandLocked and RateLimited remain visible. Distance rejection backs off eight seconds; rate rejection backs off two. No live distance bypass is established.
- Auto Rebirth uses RebirthButtonConfig.GetOptionCount and RebirthConfig to choose the highest unlocked affordable button, then sends RebirthRequested({Index=...}). It avoids competing with native auto rebirth and waits for RebirthResult. Hatch and rebirth do not initiate simultaneous coin purchases.
- Auto Buy Upgrades chooses the cheapest affordable selected retained upgrade using native prices, current upgrade levels and progression requirements. ClickMultiplier, HatchSpeed, CriticalChance and AutoClickerSpeed are selectable. It excludes the Teleport upgrade and skill-tree purchase contracts. Coins and Gems have separate reserves, evaluated against current replicated balances; manual actions and replication latency can change those balances.
- Auto Claim Quests claims only visible, completed, unclaimed quests from the native replica and QuestConfig.
- Auto Open Gift opens one selected, known GiftConfig.Pools gift owned in Items.Owned, using OpenGift({Gift=name, Amount=1}).
- Auto Equip Best sends PetActionRequested({Action="EquipBest", Mode="Clicks"}) and waits for the matching action result.
- Auto Enchant rolls one selected owned pet/slot at a time with the native Enchant({PetId, Slot, RequestId}) then Resolve({Token, UseNew}) contracts. The wanted-result filter comes from native filterable enchants. Unwanted results keep the existing enchant; wanted results are applied and the loop stops after confirmation. Existing enchants require the explicit replacement toggle. Native auto enchant, another pending roll, invalid slots, locked/reserved pets and insufficient gems block new rolls. It uses real game gems. No persistent native AutoStart loop is launched. Stopping after a paid roll may leave a pending choice to finish in the game; no new roll is sent while that choice remains.

Only one RemoteFunction invocation is in flight across workers and script reruns. The shared lock stays until that invocation actually completes; a slow request is not resent after a timer. Connection exceptions on consuming calls stop the affected automation as uncertain. Event-based hatch/rebirth/equip requests stop after twelve seconds without acknowledgement and retain the pending request rather than issuing duplicate purchases. Late acknowledgements can still be recorded.

Stopping a hatch loop sends the game's StopOfflineHatch cleanup only for Auto requests issued by this script. A late result while stopped repeats that cleanup. Stop All also disables Infinite Jump. Unload removes listeners; it cannot retract a request already sent to the server.

Copy / Save Report writes DevilTappingTestReport.json and copies JSON when the executor supports those APIs. It includes request/confirmation/rejection counters, native rejection reasons, pending requests and errors. Unsequenced hatch results are labelled separately, since they have weaker attribution than a matching Seq.

Validation: Luau compilation; 37 core checks, 44 adapter checks and 123 GUI/native-contract checks. Covers real request field shapes, entitlement and storage limits, native pricing arguments, reservations, owned-item selection, click reply correlation, pending-request serialization, timeout/no-duplicate behavior, enchant choices and stop behavior, mobile jump input, language rebuild, GUI cleanup and rerun locks. This is offline validation; live Roblox execution and server acceptance have not been established.

The main hub loader is unchanged. This is a separate trial link.
