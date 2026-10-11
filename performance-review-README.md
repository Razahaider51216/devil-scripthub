# Main-loader performance review ? silver-native-1

| Map | Finding and change |
| --- | --- |
| Ride a Pet | Use the owner-verified predecoded Lucy VM/data; avoid in-game LZMA preparation. Original third-party VM stays intact. No per-frame GUI branding scan or getgc scan is added. |
| Break and Steal an Egg | Host, GUI bridge and embedded game callbacks now compile natively instead of running through our Fiu interpreter. Original farm timings/selection/remotes are retained. Logo getter shares the versioned asset. |
| Loot to Forge | Complete current xDTaraZ host/10 tabs retained; scheduler and GUI callbacks now compile natively. Existing scoped cleanup still disconnects/cancels tracked work. Get Roll and old-server features are retained. |
| Build An Ant Empire | Frontend callbacks and startup bridge now compile natively. Existing native protected engine, cleanup and duplicate guards remain. Old community URLs and logo cache names are updated. |
| Steal an Egg | Keep the current working native GUI constructor export and protected gameplay. Its small VM-protected delegate pins the updated native frontend, checking size/checksum; avoid putting the large GUI back into our interpreter. |

Shared asset resolution caches one image in the executor environment/file.
New logo cache naming prevents reuse of the old PNG. Loading cards use finite
updates, with no perpetual tween/RenderStepped animation. Ride branding uses
GUI property/creation events and retains existing control callbacks, including
an additive Discord-copy observer for VM clipboard aliases. Pet/egg images and
close-button images are left intact. Its listeners can be disconnected.

All native source transport boundaries and all five routes pass offline tests.
Actual Loot host checks confirm all 10 tabs, 100+ controls and disconnect/unload.
An illustrative CLI callback loop returned the same value with the old
interpreter (0.04845 seconds) and native Luau (0.000447 seconds). This isolates
interpreter overhead on the build machine; it is not an FPS claim or a live
Roblox benchmark. No farm tick delays or server requests were sped up/removed.

The bounded Heartbeat sampler records average/worst frame time and counts frames
over 50 ms for the first 20 seconds of module startup. It writes
`DevilHub_Performance.json` once and disconnects. Results include the game's
rendering, device load and other scripts, so they do not prove which script
caused a slow frame. New Ride branding/live FPS still require in-game testing.
