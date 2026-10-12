# Aqua egg Model/Part recorder

For Place 104050046639813. Run before collecting an egg, collect one and bring
it to your own deposit point. The recorder automatically stops after 180 seconds.
Running it again stops the previous recording and exports immediately.

Output: `DevilAquaEggParts.json` in the executor's files directory. Send that file
for analysis. Without a working writefile API, the completed JSON prints in
labelled Console chunks.

Records Model/Part paths, attributes, pivots, positions, sizes, collision state,
attachments and prompt Enabled/MaxActivationDistance/HoldDuration. Scans
EggRuntime.WildEggs/DroppedEggs and the models containing TakeSeaEgg,
DepositSeaEgg and HatchEggPrompt. Player attributes, CarriedEggId and position
are recorded initially, on prompt events and on carried-egg changes.

The initial snapshot plus the three most recent snapshots and 300 recent events
are retained. Each snapshot is capped at 20,000 nodes and explicitly reports
truncation. Streamed-out objects cannot be read. Records client-visible state;
it does not infer server acceptance from a triggered prompt alone.

No remote calls, hooks, Instance construction, decompilation or property changes
are performed. All event connections disconnect on stop. The script was compiled
with Luau; actual recording must be verified in the user's executor.
