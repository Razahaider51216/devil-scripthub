# Ride a Pet — Egg Return

The production Ride entry now adds an **Egg Return** tab to the DEVIL HUB GUI reached through the universal loader.

- Auto Collect & Return, initially off.
- Multiple egg-type selections; empty selection accepts any eligible active egg.
- Refresh Egg Types, Travel Speed, Collect & Return Once, Return Carried Eggs and Stop Egg Return.
- Nearest eligible active egg selection, respecting PrivateTo and the source's CollectedEggs filter.
- Pickup success requires Basket feedback. Return success requires Basket to empty after movement back to the owned plot. Failed targets receive a short backoff.
- Original Auto Collect Eggs / Auto Plant Eggs must be off before starting this mode, to avoid two movement systems running together.

The added controller was adapted from an existing readable RideAPet reference. It uses ServerData.ActiveEggs, Remotes.Game.EggPickup, the player's Basket and the plot owned through Data.Owner. Movement uses the reference's FlyTo path and near-base relay; it is not a proven instantaneous teleport or a devirtualization of LuminHub.

The original protected runtime remains byte-identical and uses the native compiler. The added controller is compiled into VM bytecode inside the protected DEVIL frontend host. The public Ride route version is `ride-egg-return-1`.

Validation: official Luau compilation; five-map VM routing and cross-map redirects; original protected-runtime hash/compiler boundary; controller mocks for owner validation, pickup ID, Basket feedback and stopping; frontend mocks for idle startup, egg filters, manual/home actions and legacy conflict checks. No live Roblox/Delta test took place. Long-distance movement and current server acceptance require in-game verification.
