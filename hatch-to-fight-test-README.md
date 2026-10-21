# DEVIL HUB — HatchToFight test

Standalone test built from the user's Devilv10 client dump. Place ID:
`127231827405683`; universe: `10768001644`. The existing main loader and supported
game routes are unchanged.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/refs/heads/main/hatch-to-fight-test.lua?v=hatch-to-fight-test-20261022-1"))()
```

The entry contains the gameplay adapter, scheduler and an offline catalog of
60 stages and 191 pets. It downloads the existing pinned OuroFlow interface and
DEVIL HUB logo. It never requires game modules, installs global hooks, starts
Remote Spy, copies Discord on startup or creates a fullscreen loading overlay.
All automation starts off unless the user explicitly saves a profile with
**Restore saved profile on next run** enabled.

## Controls

| Tab | Implemented test controls |
| --- | --- |
| Overview | Snapshot, per-job status, sent requests versus observed game events, refresh, stop all |
| Combat | Auto Stage Farm, Attack, Special, mount selected pet, target stage and distance |
| Training | Best available or selected dummy, rebirth when the dumped progression formula permits it |
| Inventory | Collect shells, shell rarity filter, sell shells, sell unused pets by rarity, equip strongest pet by listed damage per cooldown |
| Forge | Shell selection, 4–32 shell recipes, up to 8 per slot/4 slots, hatch available eggs, storage checks |
| Shop | Selected coin upgrades, live price/level display, visit shop |
| Rewards | Ready daily/gifts/quests/quest bonus, daily Tower ticket, owned-key crate opening |
| Tower & Boss | Repeated Tower entry, owned checkpoint check, floor limit, observed floor status, World Boss entry and combat |
| Races | Roll existing rolls, stop at selected rarity or higher, equip an available numeric slot by role/stat score |
| Teleport | 60 stage destinations, Stage 60 test, native world travel, return home |
| Settings | English/Thai in the same GUI, scoped save/load, opt-in profile restore, manual Discord copy, unload |

Farm, Train, Tower and Boss are mutually exclusive movement modes. Auto hub visits
temporarily pause them between fights for hatching, crafting, selling a full bag
or affordable upgrades. A visit waits for relevant inventory/upgrade changes,
then resumes; a stalled visit retries later. Crafting reserves selected shells
from selling. Equipped, buff, locked and favorite pets are excluded from sale,
and a minimum pet count is retained. No selection in a sale rarity filter means
all eligible rarities; sale jobs remain off until explicitly enabled.

Server-function requests use one pending lane per endpoint, retained across
reloads. A timed-out call does not create another call on that lane. Stopping a
job cancels queued work; a request already delivered to the server cannot be
retracted. Individual errors back off without silently disabling the job.

## Godmode and last-stage limits

**Godmode is not implemented as a working bypass.** The supplied client HUD reads
`PlayerGui.PetHP` and `PetMaxHP`; the dump provides neither authoritative server
damage code nor a verified invulnerability operation. The GUI shows this status
explicitly. It does not set local HP to claim immunity. Auto Retreat is a separate
optional feature using the game's Return Home request; the server may reject it
during a fight.

Stage 60 in this catalog is SunKingdom / DawnTitanSolaris. The separate warp test
uses a streamed entrance gate or stage marker, without altering `StagesCleared`
or `FightStage`. Native travel checks progress/unlocks and may return `locked`
or `fighting`. Moving the character does not establish permission to fight or
receive rewards. The farm job normally chooses the next unlocked stage.

`RequestTrainHit` exists in the dump, but its sender arguments were not present
in the captured native client or remote log. The prototype attempts the empty
argument event near a permitted dummy and exposes observed `PowerGain` counts.
This contract needs live validation. Crate automation consumes owned keys only;
the Mutated premium crate is listed but no purchase is initiated. Race equipment
uses the observed numeric slot contract, not a race name.

## Validation

Run `python tools/hatch-to-fight/test.py`. Official Luau compilation and exact
artifact hashing are required. Behavioral checks cover scheduling/cooldowns,
movement ownership, full-bag hub visits, inventory protection, recipe limits,
reward readiness, Tower checkpoints, race slots, cancellation, failed/hung remote
calls, language rebuilds, settings and unload. UI checks use a mocked renderer;
they do not establish Roblox visual correctness. No live Delta/Roblox run has
verified gameplay success or executor compatibility.

`tools/hatch-to-fight/evidence.json` records original source hashes. Catalog
generation evaluates only offline configuration providers with a restricted
Roblox stub; it repairs decompiler self-referencing table bindings before
evaluation. No client controller or dumped server code executes in the game.
