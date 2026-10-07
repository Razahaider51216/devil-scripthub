# DEVIL HUB / Loot to Forge Roll Dump

Separate from the main farming script. Run after the main script, then temporarily
disable Auto Roll Class and automatic online reward claims so manual actions are
easy to identify. One ticket is enough to observe one real Roll request.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loot-to-forge-roll-dump.lua"))()
```

1. Press Start Remote to begin capturing, including a ticket-count snapshot.
2. When an online reward becomes available, claim it through the game's UI.
3. Press the game's Roll button once. The dumper tracks ticket-count changes.
4. Press Save to stop capture and write the report (or Stop, then Copy). Save writes
   `DevilHub_Loot_Roll_Dump.json` in the executor's filesystem.

The tool inventories ReplicatedStorage remotes and observes Class/Luck/Roll/
Ticket/Gacha/Online traffic. It records outbound FireServer/InvokeServer calls
when executor namecall hooking is available, inbound RemoteEvent messages,
argument types (including nil), and ticket count changes. It does not invoke or
replay remotes, grant tickets, or change the main script. InvokeServer return
values and explicit direct-method calls are not intercepted. Remotes with
unrelated names can appear in the inventory without their traffic being recorded.
An observed online reward may grant a different resource: ticket count changes
must confirm what was actually received. The known daily dungeon ticket claim
is distinct from Class rolls; it does not establish a Class ticket grant.

Keep the report bounded to the most recent 500 records. Stop pauses
capture; Start Remote resumes it without duplicate listeners. Close disconnects
listeners and restores the top namecall hook only
when owned by this tool, preserving later-installed hooks. Rerun to start a new
session. Close also removes its independent GUI.

Drag the title to reposition the window with mouse or touch. The log area scrolls
vertically through the retained records with a mouse wheel or touch gesture;
Copy and Save remain fixed below it. New records do not reset the scroll position.
