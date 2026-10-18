# Steal an Egg ? Chilli Halloween update (2026-10-19)

The DEVIL HUB adapter now uses Chilli's StealAnEggg release pinned to upstream
03468a41b2ecf2d983b39993ba603c943c140f4f, reached through the current Chilli.lua router.
The previous production runtime was pinned to the older StealAnEgg release.

The latest native engine includes Halloween controls for Auto Fishing, Auto Phantom
Express, Auto Pumpkin Moon, Auto Ghost Dog Quest, Auto Play Cursed Island Wars,
Auto Catch Shooting Star, Auto Farm Monsters, Auto Vacuum Ghouler Boss, Auto Trade
Souls, Auto Buy Halloween Dimension Egg and Auto Steal Halloween Eggs. These are
upstream implementations exposed through the existing native controls and callbacks.
Seasonal feature availability follows upstream and the current game event.

The existing DEVIL HUB frontend discovers tabs and sections from the exported
native window, including new sections. The native constructor export, hidden
loading screen, DEVIL community links/logo and blue panel header are adapted.
Game VM instructions/data are unchanged; this is native layer unpacking and
integration, not complete devirtualization. Prior variable-specific panel styling
is not blindly applied to the new runtime.

Validation: both upstream and adapted bootstraps decoded with an inert compiler
interceptor; adapted native source round-tripped exactly and all 368,215 game data
bytes matched upstream. Official Luau compilation passed. The actual new native
constructor passed ownership/state/default-tab/reflow checks. The existing published
DEVIL bridge passed 39 checks using the new runtime's actual option API methods,
covering callbacks, synchronization, live rich-panel identity, restoration and
missing-handle behavior. The game VM was not run in these offline tests.
Live Roblox/Delta gameplay and event completion remain unverified.

Rebuild the runtime with `python tools/chilli-20261019/build-update.py`; it requires
Python and the existing sibling luau-tools executables. It downloads an immutable
upstream pin and rejects an unexpected SHA256 before decoding. Temporary decode
files are generated beside the builder. See devil-chilli-native-ui-recovery.json
for source hashes, byte counts and transfer checksum.
