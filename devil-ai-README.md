# DEVIL HUB — AI & Map Tools

GUI edition of the recovered PayomboyZ Ai Script. The original recovered entry remains `ai-script-recovered.lua`; this edition lives at `devil-ai.lua`.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil-ai.lua"))()
```

## Interface

- DEVIL HUB logo, opaque dark blue panels, and a small draggable launcher. Click the launcher or press K to show/hide the window.
- Home: current place/universe, session status, five shortcuts, and the DEVIL HUB Discord invite.
- Build: AI Builder, Macros, Code Library.
- Inspect: Game Explorer, Game Scanner.
- Traffic: Remote Spy, HTTP Spy.
- Files: Dump Files, File Preview, Code Tools.
- System: Debug Logs, Settings.
- Search the navigation in Thai or English. Scaling respects the viewport when changing orientation; language/profile controls remain available.
- Mobile page and navigation canvases convert rendered layout pixels back to UI offsets, and refresh when scale changes, so lower controls remain reachable. Page scrollbars have a wider touch target and reserved gutter.

## Save all remotes

At the top of Remote Spy, Game Explorer, and Dump Files, click **Save All Remotes**. This creates three files in the executor workspace under `DevilHub_Dumps/Place_<PlaceId>/`:

- `Remotes_<timestamp>_<sequence>.json`: client-visible remote names, classes, and paths, including remotes not yet called.
- `RemoteCalls_<timestamp>_<sequence>.json`: captured calls in chronological order, typed arguments, argument counts including nil slots, and recorded source text.
- `RemoteSummary_<timestamp>_<sequence>.txt`: readable inventory and call summary.

Enable Remote Spy and perform game actions before saving if you need call arguments. Discovery alone cannot reveal the expected arguments. The recorder retains up to 2,000 calls; only the retained buffer is exported. Recursive tables have depth and entry limits, marked in the JSON. Inventory export does not invoke/replay any remote and does not decompile scripts or include server source.

The exporter reports actual paths and write/readback failures. If subfolder writes fail it tries filenames at workspace root. Missing `writefile` is reported as a failure, not a clipboard-only save. Files are saved inside the executor's workspace, not automatically to a Windows Downloads folder.

Existing page controls call the recovered callbacks. This is a GUI update, not a new AI backend or a game-specific Get Roll fix. Existing authentication inputs, compatibility globals, export paths, and external module/script dependencies remain as in the recovered base. External tools retain their original attribution. The logo uses the executor's custom asset support; the avatar fallback remains for unsupported executors. Discord: https://discord.gg/ZY7PRcVJe2.

## Validation

Compiled with the official Luau compiler. Isolated GUI tests check all 13 page routes and visibility, five Home shortcuts, Discord copying, literal menu search and reset, portrait/landscape fit, scale preference preservation, and full scroll canvases at four scales. Export tests cover inventory/call separation, nil arguments, cycles, chronological order, filename uniqueness, unsupported/failed writes, fallback paths, readback mismatch, partial saves, empty call buffers, and failed scans. An offline fake Roblox startup comparison produced the same modeled callback errors in both versions under the same configuration, with no trace budget exhaustion. These errors reflect simulated callbacks and the recovered base's limitations; they are not a live-game result. This GUI edition has not yet been tested in Delta/Roblox.

Recovered-base provenance and limitations: [ai-script-recovered-README.md](ai-script-recovered-README.md). Original source: [PayomboyZ Ai Script](https://github.com/payomboyz333/PAY-MB-YZ-HUB/blob/main/Ai%20Script-obfuscated.lua). UI changes by DEVIL HUB; upstream credits are retained.
