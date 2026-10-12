# Devil Hub / Break and Steal an Egg

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/break-and-steal-an-egg.lua"))()
```

Full release entry. Old test URLs forward to this entry. Use a fresh Roblox
session after updating. Supports place 114326934417838 / universe 10765288803.
Requires loadstring, setfenv and network access. The updated Break Egg module
does not install HTTP hooks. Pet Carry Farm also requires fireproximityprompt;
Drawing is required when using the drawing-based ESP controls.

The OuroFlow GUI uses the original Info, Main, Visuals, Player and Settings
categories, plus a dedicated Webhook category, with the updated gameplay callbacks behind the controls. The old
Obsidian screen is disabled. Socials contains Discord only. The Discord card
uses the Devil logo and 2K+ members, without the old background banner.

## Updated gameplay (2026-10-08)

Gameplay now derives from the supplied
[Satbiz01 Break and Steal an Egg script](https://raw.githubusercontent.com/Satbiz01/ExploitsRoblox/refs/heads/main/games/breakandstealenegg.lua).
Its strings were decoded statically before adaptation. The OuroFlow GUI,
loading overlay, Discord card, Webhook and Recent Steals features remain.

- Auto Egg selects the largest eligible eggs, using observed KG when available
  and physical egg size when weights are unavailable. Lower health and distance
  only break initial equal-size ties. It skips Broken/Hatching eggs and eggs near zone-build models, equips
  the pickaxe, moves within hit distance, and calls EggHitRequest. Delay,
  stand distance and Fly speed remain adjustable. Movement uses Tween flight.
  Pausing, carrying,
  disabling, and unloading cancel movement or further hits.
- Auto Shop buys pickaxes/trails, unlocks/upgrades the treadmill, upgrades the
  pen, sells eligible backpack pets, and equips best. Prices come from the
  game's Shared configuration modules. Cash is read again before each purchase.
  The loop runs every three seconds; pet sales run every fourth shop tick.
- Auto Pet Carry Farm uses the reference's PromptAnchor and return route:
  approach at Y=3/Z=123, deliver at X=-77/Y=3/Z=123, with Zone1–Zone9 timing.
  Pickup requires a nonempty Carrying attribute and the delivery counter waits
  for Carrying to clear after the route completes. This is an inferred delivery
  confirmation, not a server delivery receipt. The farm loops with the current living character,
  pauses Auto Egg, and restores any NoClip state it enabled when disabled.
- Player controls cover jump height, infinite jump, reset, saved-position
  teleport/loop, player teleport and NoClip. Visuals cover FOV, player/teammate
  ESP, rarity-filtered egg/pet ESP, guard highlights, brightness and animations.
- Fixed duplicated control IDs, stale character/root references, the source's
  out-of-scope farm distance variable, shadowed carry toggle/NoClip variables,
  listener cleanup and cancellation. NoClip restores original collision values.

Gameplay configs use DevilHub/BreakEgg/<place ID>; previous Ouroboros configs
are not migrated. Theme/config addon groupboxes and confirmation dialogs are
bridged to the existing frontend. The visible frontend still starts in Crimson.

## Shared rarity selection (satbiz-3)

Main > Farm Rarities > Egg + Animal Rarities reuses the existing rarity choices
and supports multiple selections. Auto Egg and Auto Pet Carry Farm use the
selection, with separate egg and animal eligibility. Eggs use the highest
selected tier as a minimum and allow higher tiers. Animals retain exact selected
tiers and their existing minimum income filter. Selecting a tier clears All; selecting All clears prior tiers.
An empty selection prevents new hits and pickups. Values are saved with the
gameplay config. Visual ESP filters remain independent.

Eggs use rarity attributes or the existing BillboardGui text. Animals use
their model's rarity and its own pickup prompt. The legacy global PromptAnchor
is allowed with All, or when rarity, animal ID, an ObjectValue link, or an
unambiguous nearby animal model identifies a selected animal. Spatial matching
checks every rarity, respects the prompt's MaxActivationDistance, and rejects near ties;
it does not substitute a farther selected animal for a closer excluded one.
An unknown or ambiguous anchor is skipped when selecting specific tiers.
Mythic and Mythical are treated as the same tier. Selection is checked again
before hits/prompt activation, including after movement; animals already picked
up continue their delivery. In-game prompt/model layout still needs validation.

## Webhook

In Webhook, paste your Discord webhook URL and enable Animal
pickup notifications. One message is queued for each new nonempty Carrying
transition, the game's pickup confirmation. Opening the toggle, holding an
existing animal, passive Cash income, and banking/dropping the current animal
do not trigger messages. Repeated events for the same carried ID are ignored.

Each message contains that animal's name, rarity, value/price, and income per
second. These fields come from matching AnimalPickup / PlacedAnimal model
attributes or the Carrying JSON. Model details are cached before removal so
notifications can resolve an animal after it leaves the pickup list. Missing
fields show Unavailable. Total player cash is never used as the pet's value.
Weight (KG) is included when exposed in the animal attributes or Carrying JSON.
Name and rarity overrides are optional.

Notify Animal Filter and Notify Rarity Filter allow multiple selections; empty
selections allow all. Choices come from animals observed in the current session;
Refresh animal / rarity options updates those lists. Min $/s and Min KG default
to zero. Positive minimums reject animals whose corresponding data is missing.
Filters evaluate actual animal data before optional name/rarity display overrides.

Main > Recent Steals shows the last 20 confirmed pickups in this session with
name, rarity, weight and income per second. Search filters the local history;
Clear history removes it. Loading does not reconstruct previous pickups.

Messages hold independent snapshots so collecting another animal cannot
replace an earlier queued animal's details. A minimum send gap (default two
seconds) controls bursts; it does not create recurring notifications. Successful
messages are removed from the queue. Failed sends wait before retrying and
Discord 429 responses honor retry_after. Send test notification is manual only.

Webhook starts disabled, and enabling does not replay historical pickups.
The URL is not saved to UI configs. Only Discord webhook endpoints are accepted;
mentions are suppressed. Disabling clears queued pickups. Cleanup disconnects
listeners and clears the URL.

## Provenance and validation

Reference download SHA256:
251064a3e6b79d2d6b60ac7fd27d422539669ea77efa800bc1e3a79f535f4d41.
This identifies the supplied file snapshot; the upstream main branch can change.
The reference is adapted, with the corrections listed above.
OuroFlow GUI is pinned to c8251f76f74d9942114ebccb0564aa0ac196320a.
ThemeManager and SaveManager are vendored from deividcomsono/Obsidian commit
2bf43254266f94492fe1f0fa12d181bb55e98f25, under preview/Obsidian-LICENSE.txt.

This update was validated with official Luau 0.741 compilation, per-chunk
checksums and exact packed source roundtrip, and executable mocks for gameplay
initialization, unique IDs, egg hit/restart/stop, shop cash refresh, carry executor
fallback, pickup/delivery/cancellation and unload. Frontend mocks verify the
original Crimson/size configuration, legacy and direct AddGroupbox APIs,
silent initialization, native/frontend synchronization, multi-select and teardown.
Webhook and item-context source was retained; no real webhook messages were sent.
Live game actions and DeltaX have not been verified in this environment.
Client-side packing does not guarantee source secrecy.

Titanic-specific farming, mutation/Min KG gameplay pickup filters and Merge
automation are not supplied by this reference. Webhook filters remain notification
filters. This update does not resolve or bypass the game's anti-cheat.

## Startup fix (satbiz-2)

The Keybind/ColorPicker bridge resolves the actual addon from native Options[id].
Obsidian's AddKeyPicker and AddColorPicker return their parent row for chaining;
passing that row to OuroFlow sent a boolean toggle value and caused the reported
`attempt to index boolean with 'Name'` startup failure. Unbound/invalid keys now
become nil; bound keys become EnumItems. Frontend-to-native edits keep key mode,
modifiers and color transparency. Regression mocks use the pinned OuroFlow key
renderer and the native parent-return contract, including key sync and teardown.

## Carry without forced death (satbiz-4)

Auto Pet Carry Farm no longer sets Humanoid.Health to zero on enable, after
delivery, or when no matching pickup is found. It starts with the current living
character and repeats after each delivery. If the character dies naturally,
the worker waits for a living character and resumes. Disabling/unloading stops
the worker and cancels movement. An animal already carried before enabling is
left for the player to deliver. Regression mocks cover unchanged health on
enable/delivery, two deliveries without respawning, and natural-death recovery.

## Auto Egg + Carry handoff (satbiz-5)

Both toggles can stay enabled. An idle carry worker allows Auto Egg to continue.
When a selected animal becomes available, carry acquires movement control,
cancels any egg tween, pauses hits, picks up and delivers the animal. Egg farming
resumes after Carrying clears and delivery finishes. Delivery still pending keeps
the handoff; disabling carry releases it. Each worker retains its toggle state.
NoClip changes are scoped to active carry work and restored afterwards.

Carry also works when Auto Egg is off and the player breaks an egg manually.
Detached PromptAnchor lookup now supports the model association above. Mocks
cover joint egg-to-pet-to-bank-to-next-egg execution, delayed bank confirmation,
manual hatch detection, and rejection of excluded or ambiguous nearby animals.
The spatial fallback is an inference; current in-game prompt layout still needs
validation on the user's executor.

## Auto Egg walking fix (satbiz-6)

Auto Egg now uses PathfindingService waypoints and Humanoid:MoveTo instead of
writing the character CFrame, clearing velocity, or tweening the character
between eggs. It leaves the game's movement speed unchanged. Failed/blocked
paths do not fall back to teleporting, and hits remain limited to reachable
targets within the configured distance. Carry handoff cancels walking before
pickup movement. The obsolete Fly speed control is removed.

Stop Auto Egg on damage defaults on. A health drop during egg farming disables
the egg toggle and cancels pending movement/hits; damage during a carry handoff
does not incorrectly disable the paused egg worker. This cannot prevent an
instant server kill and is not a verified anti-cheat bypass. Carry's existing
route is unchanged. Mocks cover walking, no transform/velocity writes, damage
cancellation, manual stop, blocked paths and the existing joint handoff.

## Additional rarities (satbiz-7)

Inferno and Celestial are available in Main's shared multiselect and both ESP
rarity dropdowns. Egg/pet matching recognizes them through attributes or
BillboardGui text, and ESP assigns orange/gold colors. Regression mocks cover
Inferno/Celestial egg selection and collecting a Celestial animal.

Discord: https://discord.gg/ZY7PRcVJe2

## Flight restored (satbiz-8)

Auto Egg again flies between eggs using TweenService, with the original
Fly speed slider (default 100, range 80–600 studs/s). Walking/pathfinding from
satbiz-6 is superseded. Flight cancels on disable, damage, death, changed filters,
or a carry handoff; hits require arrival within range. The shared rarity choices,
Inferno/Celestial support and continuous carry farm remain. Stop on damage stays
enabled by default. This is not a verified anti-cheat bypass.

## Carry discovery fix (satbiz-9)

Carry no longer requires an existing Steal prompt before approaching an animal.
It scans selected animal models first, including nested AnimalPickups folders,
then approaches one to reveal the prompt. Rarity lookup reads all descendant
labels, including a second BillboardGui, rich text and `Rarity: Celestial` labels.
ProximityPromptService.PromptShown/PromptHidden tracks newly visible pickup
prompts outside the model or the legacy PromptAnchor. A unique ObjectText animal
name (with its weight prefix removed) can associate a detached prompt to its
model. ID/reference and unambiguous spatial associations remain supported.
Buy/shop prompts are excluded.

Pickup requests pass the prompt's HoldDuration. Status now distinguishes
approach, prompt/rarity discovery failure, unconfirmed pickup and delivery;
scan exceptions stop the carry toggle and print a traceback. Regression mocks
cover a newly hatched nested animal with two billboards and a late visible,
name-bound Steal prompt, correct hold duration, delivery and shop exclusion.
These model-layout cases are simulated; a live executor run remains necessary.

## Constant flight speed (satbiz-10)

Auto Egg flight duration is now distance divided by the Fly speed setting,
with linear easing and no 12-second maximum. Long trips therefore keep the
selected speed instead of accelerating to finish within 12 seconds. Short trips
also use the same calculation. Fly, cancellation and carry handoff are retained.
Regression mocks compare near and distant flights at 80, 100 and 600 studs/s,
including a flight lasting over 12 seconds. Live game behavior is unverified.

## Minimum pet income (satbiz-11)

Main > Farm Rarities now includes `Minimum pet income ($/s)`. Enter `2000000`
or `2M` to steal only animals earning at least $2M per second AND matching the
selected rarities. `0` disables the income filter. This applies to Auto Pet
Carry Farm, including its handoff from Auto Egg; egg targeting stays unchanged.
The setting is saved with the existing configuration options.

Income is read from IncomePerSecond/MoneyPerSecond/CashPerSecond attributes or
descendant income labels such as `$2M/s`. Positive limits exclude unknown
income. Invalid input retains the previous limit. The filter is checked while
scanning and again immediately before requesting Steal; an already carried pet
continues delivery. Regression mocks cover the exact boundary, numeric/suffix
values, rich text, direct/detached prompts, rarity intersections, live changes
and unchanged egg targeting. Live game verification remains necessary.

## Loading label fix (satbiz-12)

The entry and runtime loading panels now show `BREAK EGG / STARTING` and
`BREAK EGG / <percent>%`. These status labels previously retained the Ride a
Pet template name despite loading the Break Egg module.

## Anti-AFK (satbiz-13)

Main > Session > Anti-AFK defaults on and responds to LocalPlayer.Idled with a
brief VirtualUser right click. It does not hold a button or move the character,
and works independently of the farm toggles. One tracked idle listener is
removed on unload; unsupported input reports one warning instead of stopping
the farms or repeatedly notifying. Existing configuration saving applies.
Mocks cover default-on behavior, disable/re-enable without duplicate input,
executor errors, camera fallback and unload. Live idle-kick prevention depends
on executor support; network/server disconnects are outside this feature.

## Minimum income enforcement (satbiz-14)

When income attributes and visible per-second labels disagree, the carry filter
uses the lowest available parsed rate. A positive minimum excludes unknown income.
Grouping Models containing other discovered animals are excluded so a richer
sibling cannot qualify a cheaper animal's Steal prompt. The existing check just
before pickup still applies. Regression mocks cover the 13B boundary, conflicting
attribute/billboard values, direct and detached prompts, and grouped animals.
Auto Egg targeting, flying and delivery behavior remain intact; live game
verification is still needed.

## Pickup prompt selection (satbiz-15)

The carry scan checks all descendant prompts for an enabled pickup interaction,
rather than stopping at the first prompt (which can be Buy or disabled). After
approaching, it uses the freshly resolved prompt for the same animal, allowing
client prompt recreation without discarding a valid pickup. Rarity/income checks
and server pickup confirmation remain required. Regression mocks cover an
unrelated prompt before Steal and replacement during the approach wait.

## Continuous carry discovery (satbiz-16)

While searching, enabled carry refreshes world pickup prompts every 0.5 seconds,
independently of PromptShown, and requests an immediate rescan on each enable.
Cached prompts outside Workspace are removed. Nested animals with only rarity,
name and income billboards can be discovered and uniquely matched to Steal.
Transient object/scan errors retry rather than disabling the farm. Carry
confirmation and the selected rarity/minimum income checks still apply.
Mocks cover pets appearing after enable, prompt discovery without events,
disable/re-enable and recovery from a transient scan error.

## Higher-tier and heavier-egg targeting (break-heavy-17)

Selecting Rare + Legendary now sends Auto Egg to Legendary-or-higher eggs; Rare and Legendary animals remain eligible for pickup when they satisfy the existing minimum $/s. Egg rarity no longer excludes animal pickups at another selected tier. Unknown egg rarity is skipped with explicit selections; All and empty selections retain their existing meanings.

Auto Egg rechecks for a larger eligible egg before each hit. If none appears, it continues hitting its current target. A heavier spawn replaces the current target without waiting for the old egg to break. Flight checks run at 0.15-second intervals and cancel the old route on a larger target or changed eligibility; the next loop moves to the new target. EggHitRequest and its distance checks remain unchanged. Broken/Hatching/dead eggs, carry handoff, health-damage stop, pause, unload and respawn checks remain in force.

Actual weight comes from exposed WeightKg/WeightKG/Weight/EggWeight/KG attributes or KG labels. Physical size is a fallback when comparable weights are not exposed; it does not manufacture server weight. Targeting is limited to eligible eggs visible to the client through the existing egg enumeration.

Validation: existing gameplay and frontend harnesses, added highest-tier/continuous-hit/heavier-preemption/flight-cancellation/size-fallback regressions, income/pickup/carry compatibility, official Luau compilation, exact packed-host checksum roundtrip, and changed gameplay executed through the distribution VM. Live Roblox/Delta behavior still needs confirmation. The runtime is pinned to commit cc938e45dbed1d1550ae3dc1211222e1cf0dd6af; main loader routing is retained.

## Pickup states, current rarity ladder and egg names (break-filters-18)

Main > Farm Rarities now includes Pickup States and Egg Names to Hit. Both are multiselects with exclusive All; empty Pickup States prevents new pickups and empty Egg Names prevents new hits. Defaults are All to preserve existing farms.

Pickup States supports Normal, Gold (including Golden), Diamond, Rainbow, Radioactive, Shiny, Lucky and Titanic. Variant/Mutation attributes and visible status labels identify the state; Lucky/Titanic boolean attributes are also supported. Any selected state may match, but rarity and minimum income must still pass. Normal excludes special mutations/variants and an unknown explicit state. An unlinked global prompt is not guessed to be a Normal animal. State filters are applied again before pickup, including name/ID-linked detached prompts. Existing carried animals finish their delivery.

The audited rarity ladder is Common, Uncommon, Rare, Epic, Legendary, Mythic, Divine, Cosmic, Secret, Celestial, Inferno, Void, Omega. Mythical remains an input alias for Mythic. Titanic is a special state rather than a rarity in the current dump.

Egg Names to Hit reads EggRewards configuration and observed EggType/EggName attributes or exact known labels. Refresh Egg Names updates the options without intentionally changing the selection. The name filter combines with the highest selected rarity minimum and larger-egg priority; unknown names are skipped with explicit selections.

Hit timing and EggHitRequest are retained. Target scans and weight reads are reused within the current scan window instead of repeating full scans for every comparison, flight check and pre-hit check. New targets are still rechecked at 0.15-second intervals during flight. Larger eggs may have greater server health, so completion time is not guaranteed to match a smaller egg.

Validation includes native and VM gameplay harnesses for new tiers/order, exact egg-name targeting, empty selection, refresh, multi-state variants/mutations, hidden/default/unknown states, linked prompts, retained income limits, flight retargeting and existing farm lifecycle. The source's mutation configuration being disabled does not create or enable mutations; the filter only selects states already present. Live Roblox/Delta validation remains pending. Current runtime pin: cfa4d8b181f2048b92b005b85ffc84a49a021f9d.

## Auto Egg correction (2026-10-11)

Eggs identified only by EggType now resolve their tier through the game's
Shared.EggRarity.ForEggType export. Existing rarity attributes and billboard
labels remain supported. Unknown or failed resolutions do not bypass filters.
Empty selections, unavailable matching eggs, character respawn and animal
pickup/delivery pauses now show a waiting reason in the Egg Farm status.
Hit delay, hit remote, movement, animal rarity/state and minimum-income filters
are unchanged. Offline gameplay and the VM regression harness pass; this
release still requires live Delta validation. Rejoin before using the update.

## Advanced-tier / multi-selection correction (2026-10-11, filters-20)

The hit-tier minimum is bounded by the highest zone rarity in Shared.ZonesConfig.
Selecting Void/Omega therefore keeps breaking eligible eggs in the final
Celestial zone until a selected higher-tier egg spawns. Matching advanced eggs
take priority over the last-zone fallback, then heavier eggs take priority
within that group. Lower selections retain their original minimum tier.
Animal pickup still requires an exact selected rarity, a selected Pickup State
and the configured minimum income; the egg fallback never broadens pickup.
Pickup States do not filter egg hits; Egg Names do not filter animal pickup.
All normalization now sends original display names back to native dropdowns,
preventing case-normalized egg-name keys from clearing the visible selection.
Offline and VM regressions cover final-zone fallback, newly spawned advanced
eggs, simultaneous advanced rarity / Gold pickup filters, minimum income and
native dropdown key validation. Live Delta verification is still required.

## PC cursor correction (2026-10-11, cursor-21)

The hidden Obsidian window enabled its custom cursor and disabled the system
mouse every render frame. Its cursor lived inside the disabled native ScreenGui,
so neither cursor was visible with OuroFlow. The bridge now disables that custom
cursor, releases its native render binding and restores the PC system mouse after
window creation. The unused native Custom Cursor control was removed. Camera
MouseBehavior and Shift Lock are untouched; touch-only devices are not forced to
show a mouse. Gameplay is unchanged. Offline regressions cover the original
failure, next-frame visibility, minimize/reopen, and touch-only cursor state.
VM compilation and gameplay regressions pass; live PC verification is pending.

## Independent Fly speed (2026-10-12, compact-native-2)

The anchoring approach in this historical release is replaced by break-flight-4 below.

Fly speed (studs/s) now ranges from 1 to 600; the previous minimum was 80.
Auto Egg travel duration is distance divided by the selected speed. The root is
temporarily anchored while the linear tween drives flight, preventing game
walking and physics velocity from adding motion. Game WalkSpeed is retained.
The previous anchor state is restored and residual velocity cleared on arrival,
cancellation, target changes, carry handoff, errors and unload. Hit timing,
target/pickup filters, remotes and carry delivery logic remain unchanged.
Offline regressions cover speeds 1/5/80/100/600 with game WalkSpeed 16/250/1000,
short/long flights, pre-existing anchors, damage, cancellation, errors and unload.
Live Roblox/Delta verification is still required.

## Shared startup loading (2026-10-12, shared-loading-3)

The entry and packed runtime retain Begin/SetStage/Finish/Destroy contracts but
borrow the main router's compact loading screen. Both Break layers reuse one
controller, so the old full-size BREAK EGG background no longer opens behind the
compact card. Standalone entry/runtime calls use the same controller and cleanup.
Gameplay, the Fly-speed correction and the GUI's original callbacks are retained.

## Flight replication correction (2026-10-12, break-flight-4)

Auto Egg no longer sets HumanoidRootPart.Anchored during flight. Anchoring was
introduced by compact-native-2 and was a suspect in the reported return to the
old position after reaching a distant/high-tier zone. Flight temporarily sets
PlatformStand and disables AutoRotate, while one PreSimulation/Stepped listener
clears character velocity. WalkSpeed and the game's anchor flag are never changed.
The previous humanoid states are restored and the listener disconnected on
arrival, cancellation, retargeting, damage, carry handoff, error and unload.
A 0.15-second arrival check precedes the first hit; if position was corrected,
no hit is sent and Status explains that arrival was interrupted. The configured
hit interval and rarity/weight/name/pickup selection rules are unchanged.
Offline tests cover different Fly/Walk speeds, a corrected arrival, standalone
Auto Egg, carry takeover during flight, combined break/pickup/bank, and cleanup.
This cannot guarantee acceptance by the game's server; live Delta verification
is required to establish whether the reported return is resolved.


## Carry damage recovery (break-carry-recovery-7)

Auto Pet Carry Farm keeps its toggle enabled after damage. The existing
CarryStopOnDamage setting now reads Pause carry on damage (auto resume).
When enabled, damage cancels travel and releases input suppression and owned
NoClip. The worker waits 1.5 seconds and for the game's movement locks to clear,
then rescans after a dropped animal or retries delivery if still carrying.
Manual disabling, unload and natural respawn remain supported. Auto Egg is unchanged.

Carry Fly Speed retains its 5-30 range and default 12. This release does not
establish a server-approved speed or resolve speed-triggered explosions.
Run break-and-steal-an-egg-carry-diagnostics.lua before farming to record client
positions, observed speeds, health, movement states, Carrying, attributes and
selected server-to-client events. Run it again to export and stop; output is
DevilCarryDiagnostics.json in the executor's files directory when writefile is
available, otherwise JSON is printed. The recorder does not send or suppress remotes.

Validation: official Luau compilation, exact packed source roundtrip, gameplay
regressions including preserved toggle, cancellation, ownership cleanup, cooldown,
stun waiting and automatic confirmed delivery after recovery; public startup
transport and main router checks. Live game/executor validation remains pending.
Rejoin before using the updated loader.


## Carry speed 100 (break-carry-speed-100-8)

Carry Fly Speed now defaults to 100 studs/s and ranges from 5 to 100.
All travel segments use distance divided by the selected speed; the legacy
zone-duration minimum no longer slows the return segment. Existing saved
settings may retain an earlier value; set Carry Fly Speed to 100 for this test.
Damage pause/recovery, pickup/bank confirmation and selection filters remain.
No server acceptance threshold is established. Record the test with the carry
diagnostics script to investigate speed-triggered damage or position correction.

Gameplay mocks cover exact segment durations at 5/12/30/100, two game walking
speeds, damage recovery, filters, handoff and lifecycle. Public startup transport
and five-map routing checks pass. Live Roblox/executor validation is pending.


## Carry falling/physics recovery (break-carry-state-recovery-9)

A client trace from game version 1351 shows delivery at about 63.915s, then
FallingDown at 66.068s with 100 health and PlatformStand/Sit false. Movement
continued during FallingDown/GettingUp, followed by large velocity and position
jumps before health reached zero at 75.848s. This does not establish what
initiated the fall or whether an anti-cheat caused it. CatchFlingRemote was
observed as an object but no received event for it was recorded.

Carry now rejects FallingDown, Ragdoll, GettingUp, Physics and Dead states,
cancels an in-progress tween, releases input/owned NoClip and waits for recovery
without disabling the farm or writing humanoid state. Speed remains 100.
Existing gameplay regressions plus full-health interruptions/recovery in each
blocked state, native transport and router tests pass. Live verification is pending.


## Auto Egg entrance, movement and retry (break-egg-smooth-entrance-10)

Auto Egg defaults to one entrance teleport per enable using the user-recorded
position (-70.8116, 3.5963, 3.8787) from game version 1351. Start Auto Egg at
entrance can be disabled. Carry ownership, carried animals and game locks delay
the entrance step. An interrupted arrival waits instead of repeating teleports.

Straight intermediate path nodes no longer require braking; corners, jumps and
final arrival retain precise steering. Zone model pivots are collected once per
egg scan instead of once per egg. Planar distance decides whether another walk
is required, while the existing full 3D hit reach check remains. This prevents
a floating egg repeatedly restarting a walking route when already within reach.

Transient target/remote errors now rescan and retry without disabling the farm.
The status shows remaining egg health and hit requests separately. The supplied
trace records Nebula Egg reaching zero health and continuous Supernova Egg damage;
it does not establish that high health itself stops farming or explain all
rejection codes. Filters, hit interval, damage-stop option and Carry speed/recovery
are retained. Gameplay mocks cover high-health hits, transient failures, tall-egg
route reuse, entrance/carry ownership and the existing physics/filter/lifecycle
cases. Public transport and five-map routing checks pass. Live validation is pending.


## Carry delivery entrance handoff and speed 200 (break-carry-return-200-11)

When Carry completes its existing delivery confirmation, an enabled Auto Egg
queues one entrance teleport. It waits until Carry releases movement ownership
and Carrying clears before teleporting and resuming normal walking/hits. This
prevents starting an egg route from the bank wall. Start / resume Auto Egg at
entrance defaults on and controls the entrance step; disabling it retains walking
from the current position. Carry-only farming does not trigger an entrance return.

Carry Fly Speed now ranges from 5 to 200 studs/s; default remains 100.
Nominal travel duration is distance divided by the selected speed. Server
acceptance at 200 has not been verified. Damage/forced-physics recovery remains.

Gameplay checks include actual pickup/bank/entrance/hit handoff ordering, exactly
one post-bank return, Carry-only delivery, retained toggles and segment durations
at 5/12/30/100/200. Existing smooth walking, high-health retries, filters, damage,
respawn and cleanup plus public startup/router checks pass. Live testing is pending.


## Fixed stepped approach to selected animals (break-carry-step-pickup-12)

Carry approaches selected animals with position steps of at most 20 studs and
a 0.25-second pause after each step. There are no new menu settings. Both the
hidden-prompt approach and final prompt approach use this behavior. Eligibility,
character state, cancellation and damage are checked between steps. A corrected
position aborts the attempt and waits before rescanning; prompt activation still
requires the fresh selected model/prompt and pickup confirmation.

After pickup, the existing corridor/bank tween route, Fly Speed range through
200, delivery confirmation and post-bank Auto Egg entrance handoff remain.
This does not establish server acceptance of stepped movement or guarantee
that the map will not reject it. Live game testing is required.


## One loading screen and two VM startup layers (break-single-loading-vm2-13)

The Break runtime's old separate overlay is replaced by the same shared loading
adapter used by the entry. Through the main loader, entry/runtime share one
controller and the main screen remains open until its owner finishes. Standalone
Break calls use the compact main presentation. HoldHub/PayloadRunning/Busy flags
are cleared on finish and loading leases release once.

Entry and runtime each have two VM bytecode startup boundaries, encoded payloads
and integrity verification. Gameplay/UI callbacks retain their exact packed native
source. This obfuscates the distribution but does not guarantee code secrecy on
a client controlled by its user. Checks cover both VM layers, corruption rejection,
argument/return holes, exact native transport, five-map routing and actual shared
loading adapter lifecycle. Gameplay source is unchanged; live UI verification is pending.


## Finish selected egg before switching (break-egg-target-lock-14)

Auto Egg retains its selected eligible egg while walking and hitting, even if
a larger or higher-tier egg spawns. After the current egg breaks, reaches zero
health, starts hatching, disappears or no longer passes the current filters,
the next target is chosen with the existing rarity/size ranking. Filters still
apply immediately. The lock is retained across normal Carry pickup/delivery
pauses and the return to the entrance.

Gameplay regressions cover 20 consecutive retained hits with a new larger spawn,
completion, removed/zero-health targets, a larger spawn during walking and the
existing filter/carry/lifecycle checks. Two VM startup layers, shared loading
screen and public router transport are preserved and verified. Live validation
remains pending.


## Faster fixed animal approach (break-carry-fast-approach-15)

Selected-animal approach now uses hops of at most 60 studs with a 0.1-second
pause, replacing 20 studs / 0.25 seconds. No approach controls are added.
Filter checks, correction detection, damage/physics interruption and retry
remain between hops; pickup confirmation and the existing return flight are
unchanged. Auto Egg target locking and the bank-to-entrance handoff are retained.

The 400-stud approach mock now completes in seven hops. Full gameplay, filter,
locked-target, return, cleanup and two-VM transport/router checks pass. These
checks do not establish server acceptance or live pickup timing.


## Animal approach: 50 studs and 0.4 seconds (break-carry-hop50-pause04-16)

At the user's request after live rejection of the faster approach, approach hops
are now capped at 50 studs and pause for 0.4 seconds between hops. These remain
fixed settings with no new controls. Pickup filters, interruption checks, return
flight, bank/entrance handoff, target locking and two-layer VM startup are retained.
Gameplay regressions verify the updated bound and eight hops for the test's
400-stud route within arrival tolerance; transport/router checks pass.
Live server acceptance of the revised pacing is still unverified.


## Reliable post-Carry entrance handoff (break-carry-entrance-handoff-17)

Post-bank Auto Egg entrance return is now independent of the initial entrance
toggle. Carry tracks bank attempts and queues return when Carrying has cleared
on release, including a travel/arrival early return. Successful delivery releases
movement ownership immediately. Carry waits for the queued entrance step before
scanning another animal, so a new pickup cannot continually overtake it.

Carry-only mode does not teleport. The initial entrance toggle still controls
Auto Egg enable behavior. Gameplay checks include initial teleport disabled
during actual pickup/bank/entrance/hit handoff, retained toggles, single return,
filters, target locking, 50-stud/0.4-second approach, damage/respawn/cleanup and
two-VM/router transport. Live verification is pending.


## Anti-AFK keepalive (break-anti-afk-20)

Anti-AFK now sends a pulse every 60 seconds and also responds to Player.Idled.
VirtualUser presses/releases mouse button 2 with a short pause. Release is
attempted even after an input error or a toggle/unload during the pause. If
VirtualUser fails, VirtualInputManager attempts a one-pixel mouse movement
and restores the pointer. Overlapping pulses and frequent idle events are
throttled. All three signal connections are released on unload.

The Session group shows waiting, input sent, disabled or input failed.
DevilBreakAntiAFK-report.json records successful sends, failures, the input
method, last error, Idled events and observed Player.OnTeleport state. A send
without an API error is not proof that the executor reset Roblox's idle timer.
This feature does not reconnect after a network drop or server shutdown.

Offline regression covers scheduling, concurrent Idled events, release during
toggle/unload, input fallback, failed methods, recovery, teleport recording
and cleanup. Public VM/native boundaries and five-game router checks pass.
Actual long-running farming in the user's executor remains to be verified.

Roblox API reference: https://create.roblox.com/docs/reference/engine/classes/Player#Idled
