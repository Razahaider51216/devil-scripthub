# DEVIL HUB — Destroy a Vault

Standalone entry for place `91034536684382` / universe `10561166339`, using the same OuroFlow Abyss UI as the DEVIL HUB game scripts.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil-destroy-vault.lua"))()
```

All automation starts disabled. Press K or use the floating DEVIL HUB button to show/hide the window.

## Controls

- **Main:** Auto Roll, Auto purchase/claim rolled robots with minimum odds denominator, a multi-select rarity stop, Auto collect Gold and deposit carried Gold into the smelter, Auto Daily claim.
- **Progression:** Auto Damage, Battery, Roll Luck, Roll Spots; Auto purchase affordable unlocked-island holder slots; upgrade one already-unlocked holder by its current ID.
- **Settings:** Fast warp-and-return (default), stationary, walk into prompt range, or nearby-only interaction modes; job interval, Stop All, owned-base/status JSON report, live prerequisite check, Discord, and cleanup.

For a quick start, Main → **Start Fast Farm: Roll + Claim + Gold** enables those three jobs and selects Fast mode at a 0.5-second minimum interval between repeats of each job. Auto Claim purchases spend in-game currency. The 0.5-second setting is a scheduler delay, not a guaranteed server roll rate; hold duration, feedback latency, failed requests, and game cooldowns still apply. The slider supports 0.35–15 seconds.

The controller locates the local player's plot by replicated owner attributes and rediscovers live prompts and IDs. It uses the exact remote actions captured in the supplied gameplay logs. Prompt jobs inspect feedback sequence changes and success attributes; stale success attributes do not confirm a new action. While Auto Claim is enabled, qualifying pending offers pause rerolling until they are bought. A successful offer is deduplicated during the session. Purchases spend in-game currency; every purchasing automation is a separate opt-in toggle.

Auto Gold selects pickup when pile gold is available and deposit when carried gold is available. It does not alter server gold/cash state. Fast mode temporarily moves the character root into the prompt's local activation range, waits 0.2 seconds for position replication, activates the prompt, awaits a new success feedback sequence for up to 1.5 seconds, then restores its previous position. Return is attempted on success, failure, cancellation, and cleanup; the script avoids restoring a replaced/dead character root. Position replication or server movement validation may still reject the interaction; there is no guarantee of bypassing server checks.

Stationary mode attempts executor `fireproximityprompt` activation without moving or changing the prompt's distance/hold settings. The game may reject distant interactions; the script reports missing confirmation and pauses repeatedly failing jobs. Walking mode uses Humanoid MoveTo with a time limit and activates only after reaching prompt range. No damage bypass, anti-cheat hooks, mutation/fusion automation, or paid lucky-roll/timeskip actions are installed.

## Stop at rarity

Enable **Stop Roll at selected rarity** and select one or multiple targets. Choices are taken from rarity names present in the supplied Workspace dump: Common, Uncommon, Rare, Epic, Legendary, Mythic, Divine, Secret, Omnipotent, Transcendant, Indestructible, Limited. Matches are exact; no unsupported rarity ordering or odds-to-rarity conversion is assumed.

The script reads `Rarity` only from a displayed robot with `RollOfferId` and `RobotId` matching the current offer surface. On a match it turns off Auto Roll before another reroll and retains the result; Auto Claim and Gold can continue. A previous reveal's attributes or an unrelated robot cannot satisfy the stop condition. If the live game does not expose a matching rarity, the stop cannot detect it; the Status Report includes current offers and resolved rarities for diagnosis.

## Practical limits

- This entry is compiled and tested offline, **not yet verified live in Delta/Roblox**.
- Cash is read from numeric Cash/Money values in the player's leaderstats/Stats or a Cash player attribute. If cash is not readable, Auto Holder purchase waits. Use Settings → Status Report to inspect what the client exposes.
- Minimum odds uses the live `RollRobotOddsDenominator` attribute: e.g. 1000 accepts denominators at least 1000. It is not a rarity-name filter.
- Holder prices and island locks come from replicated attributes. Exact robot and upgrade prices are not available in the supplied dump. Setting a positive reserve pauses Auto Claim and board upgrades; reserve is enforced for holder purchases where prices are known.
- Missing/disabled prompts and absent owned plots wait. Failed jobs back off; three consecutive failures turn that job off. Movement/ownership changes are checked before prompt activation. Remote calls have a ten-second response timeout. A previously sent purchase cannot be undone by Stop All. Settings → Check System displays owned plot, user ID, enabled prompt count, remote-folder presence, and executor prompt-helper availability. Status Report includes candidate plot owners and live offer details.
- Unknown remote responses are shown as unconfirmed, not reported as successful. Daily claims are spaced at least two minutes apart.
- Fusion, Mutation, auto best equip, Spin, and automatic next Vault tier are not implemented because their complete selection/state contracts have not been captured.

## Validation and dependencies

Official Luau compilation passed. Controller mock tests cover plot ownership/change, deposit-before-pickup ordering, minimum odds, offer deduplication, claim-before-roll, reserve protection, locked islands, observed purchase/upgrade/daily argument contracts, cooldowns, repeated-failure shutdown, Stop, reporting, and selected-rarity stopping without disabling Gold. UI mock tests cover default-off job toggles, multi-select rarity values, mode selection, quick-start synchronization, interval clamping, odds/reserve inputs, Stop All synchronization, remote response classification, and cleanup. Prompt tests cover stationary activation without movement, Fast warp/return without walking, return on cancellation/failure, nearby-only/walking modes, rejection of stale success feedback, and offer/robot matching for rarity. These checks do not prove live server acceptance or executor compatibility.

UI dependency: [OuroFlow](https://github.com/joustingmatch/OuroFlow), pinned to `c8251f76f74d9942114ebccb0564aa0ac196320a`. DEVIL HUB logo uses executor custom-asset support where available. Discord: https://discord.gg/ZY7PRcVJe2.
