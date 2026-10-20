# Steal an Egg upstream integration ? 2026-10-20

Release: `chilli-performance-20261021-1`.
Chilli.lua routes this game to `tienkhanh1/Chilli-Hub-Script/StealAnEggg`.
The immutable upstream commit is `7b9215d199e43d7dda2569a8cf84477c77552630`;
its 811,078 bytes must match SHA256
`52812e88b260512c0362cd1085c2d830665b33675c67b92d0b168fa2577b6fa2`.

New upstream systems are exposed using the existing DEVIL HUB handle bridge:
- Farm Monsters While Fishing and live Fishing History canvas.
- Fishing/Treadmill rotation: Timer or Every Day; separate minute sliders.
- Teleport To Monsters, Pumpkins and Ghosts.
- Continuous target loops for monsters/pumpkins with cooperative upstream yielding.

The build unpacks the native layer, exports its native Window, hides only the
upstream loading ScreenGui, retains DEVIL community branding and disables the
Venyx promotional initializer. The blue Steal Panel header adaptation is retained.
The latest wrapper uses a different base85 alphabet/order and dispatcher layout.
Six global-read opcodes receive the existing narrowly scoped webhook-branding
adapter; original environment/compiler APIs and global writes retain their identity.
No configured destination, gameplay arguments, or payload fields are redirected.

All 360,955 upstream game-data bytes are preserved. Native modifications are
reversible declared substitutions plus the scoped request adapter. Both compression
round-trip and game-data equality are checked before writing the runtime.
This is native-layer recovery, not complete devirtualization of the protected VM.

The previously requested startup rollback is retained: no VM timeout/watchdog,
injected VM instruction yielding, compiler/environment replacement, loading-module
replacement, native GUI quarantine, or pet-icon startup patches are reintroduced.
Upstream seasonal behavior follows the current game.

## Performance and original GUI removal

The original `Settings` and `ChilliLeftCenter` ScreenGuis are destroyed after the
DEVIL frontend mounts. Native handle/controller backing instances are retained
in an unparented Folder, outside every ScreenGui, so state bindings and original
game callbacks remain usable. Interactive rich panels are moved into DEVIL HUB
before the original shell is removed. Unload does not resurrect the Chilli GUI;
remount uses the exported controller store without re-running the game engine.
This removes the original visible shell; it does not claim to eliminate every
legacy controller object or prevent their initial construction.

The bridge caches dropdown descendant indexes, writes visibility only when it
changes, discovers new options at most once every two seconds in background,
skips hidden tabs, and reads at most 24 controls or approximately 2 ms per
background pass. User-triggered synchronization remains immediate. Report counters
record scans, reads, visibility writes and maximum synchronization duration.

Three native presentation callbacks are limited to 30 Hz while displayed and
4 Hz while hidden/unparented; accumulated elapsed time is passed through for
animation timers. Movement, combat, input and farming signals are unchanged.
All six VM environment-read sites bypass the webhook helper for ordinary names;
request aliases retain their existing branding adapter and function identities.
The Steal-only public delegate is native Lua, removing its redundant Fiu startup
interpreter and payload decoder. The shared main router and original game VM are
separate layers and remain intact.

AST inspection found 215 top-level native function entries, including a 65,612
byte dispatcher. Generic devirtualization was attempted with both the recovered
chunk and its real bound game-data buffer; neither produced executable recovered
game source (the lifter reported an IndexError). No behaviour trace is substituted
for the game engine. The protected VM remains; FPS improvement and the original
reported lag still require a live Roblox/executor measurement.

Run `test-performance.py`, `test-integration.py`, and `test-customization.py`
before building/pinning the GUI and public wrappers.

Build runtime: `python tools/chilli-20261019/build-update.py`.
Run `test-integration.py`: actual latest option methods and exported constructor,
60 bridge checks including new toggles, original callbacks, silent state refresh,
live history canvas and unload restoration. Its fixture mocks Roblox UI/services;
it does not invoke the protected VM, remote events, or game actions.
`test-customization.py` checks webhook alias/brand/return/header behavior.
`build-ui.py RUNTIME_COMMIT` pins both GUI entries to the exact adapted runtime.
`build-release.py delegate GUI_COMMIT` and `router DELEGATE_COMMIT` build the
remaining immutable chain, changing only the Steal route and version.

Public wrapper, router and shared GUI regressions must pass before publishing.
No live Roblox/executor compatibility or event completion is claimed. The earlier
70% freeze on Arceus X cannot be established or resolved by offline UI mocks.
