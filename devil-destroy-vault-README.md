# DEVIL HUB — Destroy a Vault

Standalone entry for place `91034536684382` / universe `10561166339`, using the same OuroFlow Abyss UI as the DEVIL HUB game scripts.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil-destroy-vault.lua"))()
```

All automation starts disabled. Press K or use the floating DEVIL HUB button to show/hide the window.

## Controls

- **Main → Rolling / Upgrades (left), Base / Economy (right):** Auto Roll with independent Roll Delay, Auto Buy Rolled Robots, multi-select Buy Rarities, Max Buy Price, multi-select upgrade jobs controlled by Auto Buy Upgrades, Auto Buy Tank Slots, Auto Collect Gold + deposit, and Daily rewards. Layout follows the supplied reference screenshots, retaining DEVIL HUB branding and Abyss theme.
- **Player:** WalkSpeed + Speed, Infinite Jump, Noclip, Instant ProximityPrompt, Fly + Fly Speed, Disable 3D Rendering, FPS Boost, Auto Reconnect on Kick, and Hide UI on Start. All start off. Fly uses the mobile movement stick and camera direction, plus jump to rise; desktop Space rises and Ctrl descends. Turn Fly off before prompt automation; prompt jobs wait while Fly is on.
- **Settings → Farm Modes:** Full farm (Roll + Claim + Gold), Roll + Claim, Gold pickup + smelter deposit, or Auto Upgrades + holder purchases. Select a preset then press Start Selected Farm. Starting a preset stops all previous jobs and synchronizes their toggles. Upgrade and robot purchases spend in-game currency. Settings also retains individual upgrade switches and one-holder upgrade by current ID.
- **Settings:** Fast warp between farm points (default), Fast warp-and-return, stationary, walk into prompt range, or nearby-only interaction modes; job interval, Stop All, owned-base/status JSON report, live prerequisite check, Discord, and cleanup.

For a quick start, Settings → Advanced Rolling → **Start Fast Farm: Roll + Claim + Gold** enables those three jobs and selects Fast mode with 0.5-second Roll Delay and job interval. Auto Claim purchases spend in-game currency. Scheduler delays are not a guaranteed server roll rate; hold duration, feedback latency, failed requests, and game cooldowns still apply. Both timing sliders support 0.35–15 seconds.

Buy Rarities accepts multiple categories and defaults to all twelve visible choices. An empty selection buys none. Claim-before-reroll waiting applies only to offers that satisfy the purchase filters. Max Buy Price defaults to No Limit. The current dumps have no verified rolled-robot price source, so selecting a price cap **waits instead of buying an unpriced offer**; it does not establish a working price lookup. Stop-at-rarity remains independent of the purchase filter in Settings → Advanced Rolling.

## Upgrade control correction

The new supplied manual-call log sends `PurchaseRollLuck` with numeric argument `10` and `PurchaseRollSpots` with `3`; the previous controller always sent `1`. The logged `ReplicatedStorage.SharedUpgradeBoardTemplates...BoardPart` strings match the controller, so those request paths remain unchanged. The log contains no return values and does not prove which calls succeeded or conclusively define the third argument.

The previous correction required integer-only transitions and consequently rejected the user's actual displays: Luck `1x > 2x`, Damage `1.0x > 1.1x`, and Battery `8.0s > 7.9s`. Displayed multipliers/times do not establish a numeric upgrade-level contract. The current entry therefore activates the game's existing **BuyButton**, letting the game calculate its own arguments. It does not convert displayed units into guessed levels or fixed numeric requests.

Board discovery remains scoped to the owned plot and the observed `UpgradeBoardAction` attribute. The matching LocalPlayer PlayerGui SurfaceGui must be adorned to that exact live board, enabled, and have a visible, active BuyButton. The executor must expose `firesignal` or active `getconnections` callbacks. Only one existing click/Activated signal is used per attempt. MAX and unbound/unavailable buttons wait. After activation, a fresh board success-feedback sequence for the local player or a changed game ValueLabel confirms client-visible progress; missing confirmation waits and is not counted as success. Stop/restart invalidates pending activations. No new remote hook is installed. If the button is unavailable, stand near the upgrade board and save Status Report; the report includes GUI binding, Adornee path, button visibility and executor capabilities. This path still requires live Delta verification.

Upgrade prices are read from the matched native GUI's `BuyButton.PriceLabel` when available, otherwise the owned-board label. Available cash and reserve are checked before purchase; an unknown price with a positive reserve waits. Status Report includes each upgrade's request path, live board, raw displayed text, price, and native button binding. Any integer target shown in this report is a display-parser diagnostic; the entry's native-button path does not send it directly.

Player controls restore captured speed, collision, prompt hold duration, shadows/effect states, and rendering on disable/cleanup. Repeated enable does not overwrite the saved original state. Reconnect waits ten seconds after an English kick/disconnection/connection message and makes one teleport attempt; disabling the option or destroying the script cancels the pending attempt. Hide UI on Start is remembered only for later runs in the same executor environment and can be reopened with the logo/K. GameplayPaused is not modified. These client features are not server bypasses.

Auto Place Robots, Auto Replace With Better (DPS/minimum place rarity), Auto Unlock Islands, and Auto Buy Gem Shop are grouped in Settings → Not Supported Yet as unavailable descriptions, not working switches. These descriptions have been removed from beside the working Tank Slots control to avoid suggesting that Auto Buy Tank Slots is unavailable. The current version does not provide all automation in the reference screenshots.

## Auto Upgrade Vault

Main → Upgrades → **Auto Upgrade Vault** is a separate, default-off switch. The newly supplied log confirms the game's `PurchaseVaultTier` action, matching template path, and `UpgradeVaultUpgradeInteraction.BuyButton`; it sends `vault_tier_2` in that snapshot. Automation activates this bound native button using the existing owned-board, budget, cancellation, and confirmation checks, letting the game choose its current tier. It never repeats a hardcoded `vault_tier_2` or guesses the next tier from numeric display values. Damage and Battery already exist under Auto Buy Upgrades, so no duplicate jobs were added.

Gold Value is shown alongside the Vault control as requested. No separate Gold Value purchase action appears in the supplied log or board-action inventory, so no independent Gold Value automation was invented. If the game has a distinct Gold Value buy button, its actual request or native GUI binding is still needed.

## Tank Slots cash correction

The supplied live Status Report showed three locked holder slots priced at 85,000, but omitted cash entirely. The old cash reader only looked at leaderstats/Stats and a player attribute; holder purchases deliberately waited when that balance was unreadable. The supplied map dump identifies the actual cash label at `LocalPlayer.PlayerGui.ScreenGui.SafeRoot.BottomLeftHud.Cash`, so the reader now falls back to that exact HUD path. It supports dollar/comma formatting, rich text, zero, and compact suffixes. Compact rounded balances use a conservative lower bound for affordability and reserve checks; this can postpone a purchase near the displayed balance. Stats/attribute values take precedence when available.

Auto Buy Tank Slots remains opt-in and sends the observed `RobotHolderPurchaseRequest(holderId)` only for an affordable unsold holder on an unlocked owned island. Waiting messages now distinguish missing cash, insufficient cash (with price/reserve), and no eligible slots. Status Report includes `cashDetails` with the chosen source, HUD text, and approximation flag. These corrections have been verified in mocks, not live Roblox.

## Free-roam Roll

Main → **Free-roam Roll: no walking/warping** is disabled by default. Selecting a movement mode, starting a preset, or using quick start disables this override, so Roll follows the chosen movement mode. If manually enabled, Auto Roll uses a separate interaction path. It temporarily expands the local Roll prompt activation distance to cover the player's current position and disables its local line-of-sight requirement, calls the executor's prompt helper, and restores both properties after success/failure/cancellation. It does not move the character or restore a position while the player walks.

This is a **client-side range attempt**, not a recovered server Roll command or a verified server bypass. The previous distance-only stationary attempt was reported not to work in the user's game. Server prompt validation may still reject the expanded local range. The supplied files do not contain the client Roll source or an observed Roll remote payload. Failed attempts report missing game confirmation and pause after three failures; they are not counted as successful rolls.

If no confirmation arrives, Settings → **Capture Roll Code to File** saves `DevilVault_RollCapture_<timestamp>.json` in the executor workspace. It includes owned/candidate plot diagnostics, visible remote names, and accessible/decompiled Roll/Prompt/Interaction client/module sources with individual read errors. It never executes recovered sources or probes guessed remote payloads. Source capture depends on the executor's decompiler and may be incomplete.

The controller locates the local player's plot by replicated owner attributes and rediscovers live prompts and IDs. It uses the exact remote actions captured in the supplied gameplay logs. Prompt jobs inspect feedback sequence changes and success attributes; stale success attributes do not confirm a new action. While Auto Claim is enabled, qualifying pending offers pause rerolling until they are bought. A successful offer is deduplicated during the session. Purchases spend in-game currency; every purchasing automation is a separate opt-in toggle.

Auto Gold selects pickup when pile gold is available and deposit when carried gold is available. Fast modes move the character root into prompt range, wait 0.2 seconds for position replication, activate the prompt, and await fresh success feedback for up to 1.5 seconds. The default route mode retains the successful action's location and warps directly to the next required point. Warp-and-return mode restores the position before each action. Both attempt return on failure or cancellation during an action, without restoring a replaced character root. Position replication or server movement validation may still reject the interaction.

Stationary mode attempts executor `fireproximityprompt` activation without moving or changing the prompt's distance/hold settings. The game may reject distant interactions; the script reports missing confirmation and pauses repeatedly failing jobs. Walking mode uses Humanoid MoveTo with a time limit and activates only after reaching prompt range. No damage bypass, anti-cheat hooks, mutation/fusion automation, or paid lucky-roll/timeskip actions are installed.

## Stop at rarity

In Settings → Advanced Rolling, enable **Stop Roll at selected rarity** and select one or multiple targets. Choices are taken from rarity names present in the supplied Workspace dump: Common, Uncommon, Rare, Epic, Legendary, Mythic, Divine, Secret, Omnipotent, Transcendant, Indestructible, Limited. Matches are exact; no unsupported rarity ordering or odds-to-rarity conversion is assumed.

The script reads `Rarity` only from a displayed robot with `RollOfferId` and `RobotId` matching the current offer surface. On a match it turns off Auto Roll before another reroll and retains the result; Auto Claim and Gold can continue. A previous reveal's attributes or an unrelated robot cannot satisfy the stop condition. If the live game does not expose a matching rarity, the stop cannot detect it; the Status Report includes current offers and resolved rarities for diagnosis.

## Practical limits

- This entry is compiled and tested offline, **not yet verified live in Delta/Roblox**.
- Cash is read from Cash/Money values in the player's leaderstats/Stats, a Cash player attribute, or the exact Cash HUD path captured in the supplied map dump. If cash is not readable, Auto Holder purchase waits. Use Settings → Status Report to inspect `cash` and `cashDetails`.
- Minimum odds uses the live `RollRobotOddsDenominator` attribute: e.g. 1000 accepts denominators at least 1000. It is not a rarity-name filter.
- Holder prices and island locks come from replicated attributes. Robot purchase prices remain unknown, so a positive reserve pauses Auto Claim. Upgrade prices are read from the live owned-board label when available; a positive reserve pauses an upgrade whose price cannot be read. Reserve is enforced for known-price purchases.
- Missing/disabled prompts and absent owned plots wait. Failed jobs back off; three consecutive failures turn that job off. Movement/ownership changes are checked before prompt activation. Remote calls have a ten-second response timeout. A previously sent purchase cannot be undone by Stop All. Settings → Check System displays owned plot, user ID, enabled prompt count, remote-folder presence, and executor prompt-helper availability. Status Report includes candidate plot owners and live offer details.
- Unknown remote responses are shown as unconfirmed, not reported as successful. Daily claims are spaced at least two minutes apart.
- Fusion, Mutation, auto best equip, and Spin remain unimplemented. Vault tier advancement uses only the game's own buy button and requires a bound, accessible native GUI plus live confirmation.

## Validation and dependencies

Official Luau compilation passed. Controller mock tests cover plot ownership/change, deposit-before-pickup ordering, minimum odds, offer deduplication, claim-before-roll, reserve protection, locked islands, observed purchase/upgrade/daily argument contracts, cooldowns, repeated-failure shutdown, Stop, reporting, and selected-rarity stopping without disabling Gold. UI mock tests cover default-off job toggles, multi-select rarity values, mode selection, quick-start synchronization, interval clamping, odds/reserve inputs, Stop All synchronization, remote response classification, and cleanup. Prompt tests cover stationary activation without movement, Fast warp/return without walking, return on cancellation/failure, nearby-only/walking modes, rejection of stale success feedback, and offer/robot matching for rarity. These checks do not prove live server acceptance or executor compatibility.

UI dependency: [OuroFlow](https://github.com/joustingmatch/OuroFlow), pinned to `c8251f76f74d9942114ebccb0564aa0ac196320a`. DEVIL HUB logo uses executor custom-asset support where available. Discord: https://discord.gg/ZY7PRcVJe2.
