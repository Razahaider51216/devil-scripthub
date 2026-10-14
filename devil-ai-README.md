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

## Dump map images

In **Dump Files** or **Game Explorer**, use **Dump Image List** to export image
references only, or **Dump + Download Images** to also save the image binaries.
**Cancel Image Dump** stops the remaining work and preserves a partial manifest.

The scan covers loaded Workspace, ReplicatedStorage, Lighting, StarterGui,
MaterialService and the local player's PlayerGui. It finds image UI, decals,
textures, mesh textures, particles, beams, trails, sky faces, clothing and
accessible material maps, including [URI-backed Content](https://create.roblox.com/docs/reference/engine/datatypes/Content)
properties. Restricted property reads are recorded.

Files are created in the executor workspace under
DevilHub_Dumps/Place_<PlaceId>/:

- Images_<timestamp>_<sequence>.json: exact Asset ID strings, original content
  references, instance paths and properties, download results and actual saved paths.
- Images_<timestamp>_<sequence>.txt: readable image inventory.
- Images_<timestamp>_<sequence>/Image_<AssetId>.<extension>: downloaded image
  bytes. The extension follows the binary signature rather than assuming PNG.

Asset IDs are deduplicated while their individual uses remain listed. Decal XML
texture references are resolved before saving. HTTP failures, restricted
properties, unsupported responses, cancellation and limits are recorded.
Built-in rbxasset references and thumbnail references are listed but not presented
as downloaded original assets. Only instances already available to the client are
scanned; this does not make streamed-out objects available.

The scan limit is 250,000 instances, each image retains up to 1,000 use references,
and downloading is limited to 5,000 unique assets of up to 32 MiB each. Limits are
marked in the manifest. Folder-write failures fall back to filenames at workspace
root. Write/readback failures are reported. No remote calls are replayed and no
downloaded content is executed.

## Save all remotes

At the top of Remote Spy, Game Explorer, and Dump Files, click **Save All Remotes**. This creates three files in the executor workspace under `DevilHub_Dumps/Place_<PlaceId>/`:

- `Remotes_<timestamp>_<sequence>.json`: client-visible remote names, classes, and paths, including remotes not yet called.
- `RemoteCalls_<timestamp>_<sequence>.json`: captured calls in chronological order, typed arguments, argument counts including nil slots, and recorded source text.
- `RemoteSummary_<timestamp>_<sequence>.txt`: readable inventory and call summary.

Enable Remote Spy and perform game actions before saving if you need call arguments. Discovery alone cannot reveal the expected arguments. The recorder retains up to 2,000 calls; only the retained buffer is exported. Recursive tables have depth and entry limits, marked in the JSON. Inventory export does not invoke/replay any remote and does not decompile scripts or include server source.

The exporter reports actual paths and write/readback failures. If subfolder writes fail it tries filenames at workspace root. Missing `writefile` is reported as a failure, not a clipboard-only save. Files are saved inside the executor's workspace, not automatically to a Windows Downloads folder.

Existing page controls call the recovered callbacks. This is a GUI update, not a new AI backend or a game-specific Get Roll fix. Existing authentication inputs, compatibility globals, export paths, and external module/script dependencies remain as in the recovered base. External tools retain their original attribution. The logo uses the executor's custom asset support; the avatar fallback remains for unsupported executors. Discord: https://discord.gg/ZY7PRcVJe2.

## Validation

The image exporter has 28 offline checks covering duplicate IDs, URI-backed
Content, denied property reads, original PNG/JPEG bytes, decal XML, failed HTTP,
non-image responses, fallback paths, readback mismatches, cancellation, cycles,
limits and empty maps. Integration checks execute both pages' controls with the
real request/redirect adapter and shared cleanup. Existing GUI and remote-export
checks pass. Binary downloading has not been verified in a live Roblox session.

Compiled with the official Luau compiler. Isolated GUI tests check all 13 page routes and visibility, five Home shortcuts, Discord copying, literal menu search and reset, portrait/landscape fit, scale preference preservation, and full scroll canvases at four scales. Export tests cover inventory/call separation, nil arguments, cycles, chronological order, filename uniqueness, unsupported/failed writes, fallback paths, readback mismatch, partial saves, empty call buffers, and failed scans. An offline fake Roblox startup comparison produced the same modeled callback errors in both versions under the same configuration, with no trace budget exhaustion. These errors reflect simulated callbacks and the recovered base's limitations; they are not a live-game result. This GUI edition has not yet been tested in Delta/Roblox.

Recovered-base provenance and limitations: [ai-script-recovered-README.md](ai-script-recovered-README.md). Original source: [PayomboyZ Ai Script](https://github.com/payomboyz333/PAY-MB-YZ-HUB/blob/main/Ai%20Script-obfuscated.lua). UI changes by DEVIL HUB; upstream credits are retained.
