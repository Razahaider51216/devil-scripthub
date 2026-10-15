# DEVIL HUB Tapping automation trial

Release: tapping-auto-test-6. Standalone trial for Place 72858262610964 / Universe 10629695169, based on the supplied client dump under Downloads/Devildumper.

Run:

    loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/tapping-auto-test.lua?v=test-6"))()

This release removes Auto Open Egg and Enchant, including their controls, workers, requests, renderer hooks and movement priority. Per-mode accepted/rejected messages and request/result counters have been removed from the GUI. Internal diagnostics remain available through Copy / Save Report.

DEVIL HUB retains its pinned OuroFlow GUI, silver DEVIL logo, profile, Thai/English button beside minimize, Discord invite/copy button, width/transparency controls, Stop All and Unload. Five tabs: Click / Player, Stars / Boxes, Progress / Rewards, Settings / Report and Discord. All automation starts disabled.

## Movement corrections

- Stars land directly above the star center, replacing the old eight-stud horizontal offset. The movement worker verifies delivery within four studs of the destination and the native pickup range before collecting; native proximity collection can also confirm through replicated data. Live centers replace saved survey coordinates when loaded.
- Tap Chest uses its native Front, Size, PromptInset and PromptHeight to calculate the interaction anchor. The destination adjusts that anchor to character standing height, avoiding both an extra vertical offset and a broad floor raycast that could select another level. Live chest anchors refresh before claiming. Delivery tolerance is 2.5 studs, followed by a 0.3-second settling period.
- Breakables use the rotated local bounding rectangle to place the character three studs outside its nearest edge at base-relative standing height. The landing stays fixed for that locked target and refreshes only if its frame or size changes.
- Unidentified chest survey coordinates request streaming and discover compatible tagged targets before any teleport. Empty survey points wait three seconds and back off ninety seconds. No chest ID or reward is invented.
- Movement records the actual position and landing error, clears linear/angular velocity, exits sitting and teleports upright. Failed delivery retries every two seconds, with a ten-second backoff after three attempts. Updated live anchors can correct the destination immediately.

## Retained automation

- Fast Auto Click: native TapRequested packets with Auto=false, unique ClientSequence and Source=button_hold. Requested rate 1–100 CPS, at most four catch-up requests per frame. Only matching positive TapResult replies count internally. Native introduction/minigame restrictions remain.
- Infinite Jump: uses normal JumpRequest input and the game's DoubleJumpController refill when air jumps are owned. Otherwise reproduces the native force/direction formula, animation and available effects. Typing, dead characters and native restricted activities block added jumps. Stop/unload removes refill and listeners.
- Auto Collect Stars: merges validated live IDs with fourteen saved star coordinates, skips collected IDs, and calls Collect(starId) after arrival. Real Success or replicated collection confirms the target; pending requests are not duplicated.
- Auto Boxes / Tap Chest: defaults to Tap Chest; selectable Tap Chest, Breakables or Both. Native Claim(chestId) and server-time cooldowns are preserved. Breakables selects a full-health Crate, Chest or WorldChest owned by the player or unowned, optionally avoiding nearby players. It locks one target, drives the shared tap worker until Broken/zero HP, and then selects another. Disappearance without break evidence is recorded as lost.
- Auto Rebirth: Auto or exact native amounts including 1, 5, 25 and 125. Exact selections wait for unlock/funds. Sends RebirthRequested({Index=...}) and waits for its response.
- Auto Buy Upgrades: buys the cheapest selected affordable ClickMultiplier, CriticalChance or AutoClickerSpeed upgrade using native levels, gem prices and progression requirements. Coin/gem reserves remain.
- Auto Claim Quests: visible, completed and unclaimed native quests.
- Auto Open Gift: one selected owned gift per request.
- Auto Equip Best: native EquipBest in Clicks mode.

Stars and boxes share movement ownership; selected targets finish before another movement task. Already-issued collection calls retain ownership until the actual reply, including after disabling. Changing box type releases only an unissued target. There is one RemoteFunction lock across workers and reruns, retained until actual completion. Ambiguous consuming-call exceptions stop that automation; unacknowledged event requests retain their pending request to avoid duplication.

Copy / Save Report writes DevilTappingTestReport.json and copies JSON when supported. It retains configuration, counters, native reasons/results, pending calls, movement target/actual/landing error, jump mode, target ID/source, chest cooldown, box HP and errors. These details are not displayed as per-mode status messages.

The saved routes contain twelve supplied non-Spawn star coordinates, two known Spawn anchors, an identified SkyIsland chest anchor and six chest discovery points. Spawn3 still requires live discovery. Approximate survey positions may need further in-game verification.

Validation: Luau compilation and 269 checks (28 core, 28 adapter, 31 movement, 86 world-farm and 96 full GUI/native-contract checks). Coverage includes absent egg/enchant endpoints and modules, hidden statuses across Thai/English rebuilds, reports retaining diagnostics, exact star/chest landing, changed live anchors, rotated rectangular boxes, stable locked destinations, failed position writes, pending RPC locks, target completion and rerun cleanup. No Roblox client was available for live verification of saved coordinates, server acceptance or ordinary-tap damage on Breakables.

The main hub loader is unchanged; this remains a separate trial link.
