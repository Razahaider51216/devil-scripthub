# DEVIL HUB Tapping automation trial

Release: tapping-auto-test-7. Standalone trial for Place 72858262610964 / Universe 10629695169, based on the supplied client dump under Downloads/Devildumper.

Run:

    loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/tapping-auto-test.lua?v=test-7"))()

This release adds Auto Unlock Islands. Auto Open Egg and Enchant remain removed, including their controls, workers, requests and renderer hooks. Per-mode accepted/rejected messages and request/result counters remain hidden in the GUI. Internal diagnostics remain available through Copy / Save Report.

DEVIL HUB retains its pinned OuroFlow GUI, silver DEVIL logo, profile, Thai/English button beside minimize, Discord invite/copy button, width/transparency controls, Stop All and Unload. Five tabs: Click / Player, Stars / Boxes, Progress / Rewards, Settings / Report and Discord. All automation starts disabled.

## Movement corrections

- Stars land directly above the star center, replacing the old eight-stud horizontal offset. The movement worker verifies delivery within four studs of the destination and the native pickup range before collecting; native proximity collection can also confirm through replicated data. Live centers replace saved survey coordinates when loaded.
- Tap Chest uses its native Front, Size, PromptInset and PromptHeight to calculate the interaction anchor. The destination adjusts that anchor to character standing height, avoiding both an extra vertical offset and a broad floor raycast that could select another level. Live chest anchors refresh before claiming. Delivery tolerance is 2.5 studs, followed by a 0.3-second settling period.
- Breakables use the rotated local bounding rectangle to place the character three studs outside its nearest edge at base-relative standing height. The landing stays fixed for that locked target and refreshes only if its frame or size changes.
- Unidentified chest survey coordinates request streaming and discover compatible tagged targets before any teleport. Empty survey points wait three seconds and back off ninety seconds. No chest ID or reward is invented.
- Movement records the actual position and landing error, clears linear/angular velocity, exits sitting and teleports upright. Failed delivery retries every two seconds, with a ten-second backoff after three attempts. Updated live anchors can correct the destination immediately.

## Retained automation

- Auto Unlock Islands: toggle in Progress / Rewards. Reads live IslandConfig.Islands order, price and PortalName, waits for enough Coins after the configured reserve, then teleports beside the nearest loaded hub/next portal for the first locked island. Requires the main world, BridgeLowered and no active native introduction/minigame restriction. It waits for the selected star/box and pending rebirth or shared consuming RPC to finish. Missing portals request streaming around the verified hub anchor; it never invents a portal destination.
- The island purchase uses IslandService.RE.IslandUnlockRequested:FireServer({Action="Purchase", Island=name}), matching 0069_IslandController.lua. Arrival must be within four studs of the standing destination, with a three-stud delivery tolerance and 0.4-second settling period. The destination uses the portal's live CFrame/Size and character height, four studs beyond its thin face. Funds are checked again after arrival.
- Only a matching Purchase/Island response with Success=true or Progression.UnlockedIslands confirms a purchase. It waits for replicated unlock data before the next island, avoiding repeated purchases with stale balances. Explicit refusals back off eight seconds. Pending event state survives reruns; after twelve seconds without confirmation the toggle stops and movement releases, while the unresolved ticket prevents duplicate purchasing. Late results still clear the pending state. Details stay in the report.
- Island movement shares ownership with Stars / Boxes. Auto Rebirth waits while an island approach, purchase or replicated confirmation owns the coin budget. Stop All disables island automation; unload removes its listener and movement but cannot retract a request already sent.
- Fast Auto Click: native TapRequested packets with Auto=false, unique ClientSequence and Source=button_hold. Requested rate 1–100 CPS, at most four catch-up requests per frame. Only matching positive TapResult replies count internally. Native introduction/minigame restrictions remain.
- Infinite Jump: uses normal JumpRequest input and the game's DoubleJumpController refill when air jumps are owned. Otherwise reproduces the native force/direction formula, animation and available effects. Typing, dead characters and native restricted activities block added jumps. Stop/unload removes refill and listeners.
- Auto Collect Stars: merges validated live IDs with fourteen saved star coordinates, skips collected IDs, and calls Collect(starId) after arrival. Real Success or replicated collection confirms the target; pending requests are not duplicated.
- Auto Boxes / Tap Chest: defaults to Tap Chest; selectable Tap Chest, Breakables or Both. Native Claim(chestId) and server-time cooldowns are preserved. Breakables selects a full-health Crate, Chest or WorldChest owned by the player or unowned, optionally avoiding nearby players. It locks one target, drives the shared tap worker until Broken/zero HP, and then selects another. Disappearance without break evidence is recorded as lost.
- Auto Rebirth: Auto or exact native amounts including 1, 5, 25 and 125. Exact selections wait for unlock/funds. Sends RebirthRequested({Index=...}) and waits for its response.
- Auto Buy Upgrades: buys the cheapest selected affordable ClickMultiplier, CriticalChance or AutoClickerSpeed upgrade using native levels, gem prices and progression requirements. Coin/gem reserves remain.
- Auto Claim Quests: visible, completed and unclaimed native quests.
- Auto Open Gift: one selected owned gift per request.
- Auto Equip Best: native EquipBest in Clicks mode.

Islands, stars and boxes share movement ownership; selected targets finish before another movement task. An affordable island purchase takes the next free movement turn. Already-issued star/chest collection calls retain ownership until the actual reply, including after disabling. Changing box type releases only an unissued target. There is one RemoteFunction lock across workers and reruns, retained until actual completion. Ambiguous consuming-call exceptions stop that automation; unacknowledged event requests retain their pending request to avoid duplication.

Copy / Save Report writes DevilTappingTestReport.json and copies JSON when supported. It retains configuration, counters, native reasons/results, pending calls, island price/coins/target/pending result, movement target/actual/landing error, jump mode, chest cooldown, box HP and errors. These details are not displayed as per-mode status messages.

The saved routes contain twelve supplied non-Spawn star coordinates, two known Spawn anchors, an identified SkyIsland chest anchor and six chest discovery points. Spawn3 still requires live discovery. Approximate survey positions may need further in-game verification.

The supplied native island snapshot has Sky Island (5,000,000), Autumn (1,000,000,000), Mushroom (800,000,000,000), Desert (45,000,000,000,000), Crystal Cave (590,000,000,000,000) and Shadow Realm (19,000,000,000,000,000). The implementation reads live configuration rather than hardcoding these prices. Evidence: 0525_IslandConfig.lua, 0069_IslandController.lua and RemoteDump_72858262610964.txt lines 112–116. The dump does not contain server source; acceptance and any additional server requirements require an in-game test.

Validation: Luau compilation and 360 checks (33 core, 28 adapter, 31 movement, 87 world-farm, 57 island and 124 full GUI/native-contract checks). New coverage includes budget/reserve gates, bridge prerequisites, stable portal landing, exact event contract, matching result validation, replica latency, cross-rerun pending purchases, late results, timeout/rejection handling, shared movement and rebirth spending. Prior star/chest landing, box locking, native jump, hidden statuses and removed egg/enchant regression checks remain. No Roblox client was available for live verification of saved coordinates, server acceptance or ordinary-tap damage on Breakables.

The main hub loader is unchanged; this remains a separate trial link.
