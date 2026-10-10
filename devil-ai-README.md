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

Existing page controls call the recovered callbacks. This is a GUI update, not a new AI backend or a game-specific Get Roll fix. Existing authentication inputs, compatibility globals, export paths, and external module/script dependencies remain as in the recovered base. External tools retain their original attribution. The logo uses the executor's custom asset support; the avatar fallback remains for unsupported executors. Discord: https://discord.gg/ZY7PRcVJe2.

## Validation

Compiled with the official Luau compiler. Isolated GUI tests check all 13 page routes and visibility, five Home shortcuts, Discord copying, literal menu search and reset, portrait/landscape fit, and scale preference preservation. An offline fake Roblox startup comparison produced the same 20 modeled callback errors in both versions under the same configuration, with no trace budget exhaustion. These errors reflect simulated callbacks and the recovered base's limitations; they are not a live-game result. This GUI edition has not yet been tested in Delta/Roblox.

Recovered-base provenance and limitations: [ai-script-recovered-README.md](ai-script-recovered-README.md). Original source: [PayomboyZ Ai Script](https://github.com/payomboyz333/PAY-MB-YZ-HUB/blob/main/Ai%20Script-obfuscated.lua). UI changes by DEVIL HUB; upstream credits are retained.
