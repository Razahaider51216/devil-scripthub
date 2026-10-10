# DEVIL HUB — Destroy a Vault

Standalone entry for place `91034536684382` / universe `10561166339`, using the same OuroFlow Abyss UI as the DEVIL HUB game scripts.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil-destroy-vault.lua"))()
```

All automation starts disabled. Press K or use the floating DEVIL HUB button to show/hide the window.

## Controls

- **Main:** Auto Roll, Auto purchase/claim rolled robots with minimum odds denominator, Auto collect Gold and deposit carried Gold into the smelter, Auto Daily claim.
- **Progression:** Auto Damage, Battery, Roll Luck, Roll Spots; Auto purchase affordable unlocked-island holder slots; upgrade one already-unlocked holder by its current ID.
- **Settings:** walk into prompt range, job interval, Stop All, owned-base/status JSON report, Discord, and cleanup.

The controller locates the local player's plot by replicated owner attributes and rediscovers live prompts and IDs. It uses the exact remote actions captured in the supplied gameplay logs. Prompt jobs inspect feedback sequence changes and success attributes; stale success attributes do not confirm a new action. While Auto Claim is enabled, qualifying pending offers pause rerolling until they are bought. A successful offer is deduplicated during the session. Purchases spend in-game currency; every purchasing automation is a separate opt-in toggle.

Auto Gold walks to pickup when pile gold is available and to deposit when carried gold is available. It does not alter server gold/cash state. Walking uses Humanoid MoveTo with a time limit. Prompt activation stays inside its current activation distance. No teleport, damage bypass, anti-cheat hooks, mutation/fusion automation, or paid lucky-roll/timeskip actions are installed.

## Practical limits

- This entry is compiled and tested offline, **not yet verified live in Delta/Roblox**.
- Cash is read from numeric Cash/Money values in the player's leaderstats/Stats or a Cash player attribute. If cash is not readable, Auto Holder purchase waits. Use Settings → Status Report to inspect what the client exposes.
- Minimum odds uses the live `RollRobotOddsDenominator` attribute: e.g. 1000 accepts denominators at least 1000. It is not a rarity-name filter.
- Holder prices and island locks come from replicated attributes. Exact robot and upgrade prices are not available in the supplied dump. Setting a positive reserve pauses Auto Claim and board upgrades; reserve is enforced for holder purchases where prices are known.
- Missing/disabled prompts and absent owned plots wait. Failed jobs back off; three consecutive failures turn that job off. Movement/ownership changes are checked before prompt activation. Remote calls have a ten-second response timeout. A previously sent purchase cannot be undone by Stop All.
- Unknown remote responses are shown as unconfirmed, not reported as successful. Daily claims are spaced at least two minutes apart.
- Fusion, Mutation, auto best equip, Spin, and automatic next Vault tier are not implemented because their complete selection/state contracts have not been captured.

## Validation and dependencies

Official Luau compilation passed. Controller mock tests cover plot ownership/change, deposit-before-pickup ordering, minimum odds, offer deduplication, claim-before-roll, reserve protection, locked islands, observed purchase/upgrade/daily argument contracts, cooldowns, repeated-failure shutdown, Stop, and reporting. UI mock tests cover nine default-off toggles, odds/reserve inputs, Stop All synchronization, remote response classification, and cleanup. These checks do not prove live server acceptance or executor compatibility.

UI dependency: [OuroFlow](https://github.com/joustingmatch/OuroFlow), pinned to `c8251f76f74d9942114ebccb0564aa0ac196320a`. DEVIL HUB logo uses executor custom-asset support where available. Discord: https://discord.gg/ZY7PRcVJe2.
