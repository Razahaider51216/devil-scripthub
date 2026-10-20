# Steal an Egg ? Chilli Halloween update (2026-10-19)

70% compatibility follow-up (`steal-startup-compat-20261020-3`): a live user
reported the whole game becoming unresponsive at the runtime-start phase after
the previous release. The cause is not confirmed without executor diagnostics.
This release removes the added decoder yields/clocks/upvalues and restores the
original native loading initializer, file diagnostics, flags and 0.05s waits.
The bootstrap shape is checked against upstream with only payload literals and
decoded size excluded. The native loading initializer is checked for exact
parity after reversing its presentation-only changes. Its ScreenGui remains
disabled and unparented, so the original loading card is never attached to UI.
DEVIL progress is a separate observer. Icon fixes, the early UI guard and verified
file caches remain. Tests pass offline; the reported executor freeze is not yet
verified resolved live.

Launcher/startup follow-up (`steal-panel-startup-20261020-2`): fix the separate
Steal Panel launcher as well as item-row artwork. The launcher uses the native
Steal Filter icon until a live item is selected; a blue/white vector egg is shown
while its texture is unavailable. Native loading now preserves its progress API
without constructing a loading GUI or writing a progress file for every part.
The main loader installs the legacy-UI guard before downloading the delegate,
including nested hidden-UI folders. The frontend reuses that guard. Native menu
visibility is bound directly, and its hidden controls are excluded from the
second theme/localization pass.

The delegate and frontend cache immutable, verified GUI/runtime files when the
executor supports files. Each cache hit checks size and checksum before native
compilation; corrupt caches redownload, and file API errors are optional. Hashing
and decompression yield only when their six-millisecond CPU budget is exceeded.
The existing report records source/cache timing, compilation and runtime seconds.
No live speed/FPS improvement is claimed: mobile/executor measurements are pending.

Offline follow-up: 33 panel/visibility/guard checks, 15 cache checks, an actual
public decompressor run with exact native output and an inert game boundary,
and actual VM-delegate cold/warm/corrupt-cache cases. `test-startup.py` runs the
cache/decompression checks. Existing router and main-loader checks also pass.

Steal Panel/rejoin fix (2026-10-20): the native queued Auto Load payload now
opens the DEVIL HUB main loader and shares its duplicate-arrival guard. The
native Settings ScreenGui is disabled before parenting, preventing an upstream
menu from rendering during the frontend handoff. Real item icons keep white
image tint, zero image transparency and neutral gradients before native name
randomization. A missing prototype icon is created in the existing row; initially
empty catalog icons can refresh after live assets become available. Original
selection buttons and the protected game bytecode remain intact.

Validation: `test-panel-rejoin.py` executes the actual patched catalog lookup,
row redraw, pre-parent visibility statement and queued payload. It also exercises
the icon helper through the real shared blue theme with randomized node names.
All 17 checks pass; the runtime decompressor round-trip preserves all 368,215
game bytecode bytes. Live Roblox rendering has not been verified.

Release build order: `build-update.py`, commit the runtime, `build-ui.py
RUNTIME_COMMIT`, commit the frontend, `build-release.py delegate GUI_COMMIT`,
commit the delegate, and `build-release.py router DELEGATE_COMMIT`. The latter
updates only Steal an Egg; the other ten routes and the Auto Execute bootstrap
remain unchanged. Run `test-panel-rejoin.py`, `test-delegate.py`,
`test-public-loader.py` and `tools/blue-gui/test-router.py` before publishing.

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

The release wrapper passed 20 offline checks, including wrong-map rejection,
duplicate launch, unavailable APIs, compiler/runtime failures, corrupt downloads
and HTML responses. `python tools/chilli-20261019/test-delegate.py` exercises the
actual public VM delegate for both map IDs, transfer integrity, native compilation,
argument forwarding and cross-map redirection. The top-level loader is unchanged.
The older all-map router fixture does not model the current shared startup
loader and was not used as evidence for this release.

Main loader follow-up: its previous immutable Steal an Egg pin also needed to
change. The public loader now pins the Halloween delegate at 8a4857ead8e18257e43d434ebb53a9083ec08bd5.
Only that map pin and version changed in the recovered native router.
Run `python tools/chilli-20261019/test-public-loader.py` to test the actual public
VM loader with the existing shared loading-controller API mocked: universe and
place selection, immutable URL, argument forwarding, retries, failure cleanup,
busy and already-mounted guards. Other map definitions remain unchanged.

GUI customization follow-up (2026-10-19): the native Venyx promotional initializer
returns before creating UI/callbacks. The adapter also filters Venyx and the old
DEVIL HUB utility tab. Settings retains native options except the UI Size slider
for the hidden native window; its new DEVIL HUB Appearance group controls the
visible OuroFlow window: accent color, background color, 60?140% size and reset.
Values are stored locally in DevilHub-StealAnEgg-appearance.json. Rich embedded
panels receive the selected colors. Malformed saved settings fall back to defaults.

Discord webhook POSTs from the native runtime's request/http_request/httprequest,
syn.request, http.request and fluxus.request aliases use DEVIL HUB as sender,
logo and embed author; old Chilli/Venyx branding in embed/content text is replaced.
Configured webhook URLs and event fields are preserved. Non-webhook destinations
and malformed bodies pass through. The wrapper changes its own compiler environment
and does not replace executor globals. This changes webhook message branding;
it does not rename a separately registered Discord application.

Validation: `test-customization.py` covers appearance persistence/reset, colors,
window dimensions, webhook aliases, nested compiler environments, headers, return
values, malformed JSON, unrelated URLs and unchanged executor functions. The actual
updated bridge passed 43 checks with latest native option methods, including no
Venyx/DEVIL HUB mode tabs, one Settings tab and original callback/widget restoration.
GUI entries pass the official Luau compiler. Live Delta rendering and live Discord
posting remain unverified. `build-ui.py RUNTIME_COMMIT` rebuilds both GUI entries
from the retained bridge and webhook helper.

The main public loader now pins the customized delegate at
9806d26ecbaa221f6a2bb2a41b369817caaebe1a, which pins GUI entry
c09572d8297fad1528be0e270d218db6d7df95d2 and runtime
5b4a699be9c93e2865ee5cade61b1cf9e2d38509. Public loader and delegate tests
passed again after the pin changes. Other game route definitions are unchanged.

70% startup fix: the earlier webhook wrapper replaced getfenv/loadstring and the
protected bootstrap environment. This can conflict with native runtime probes;
the hang was reported in-game and cannot be reproduced by the offline UI mocks.
The environment wrapper is removed. All original compiler, environment functions
and _G references remain unchanged. Branding now intercepts only the eight native
VM global-read sites and only adapts request aliases; unrelated globals pass through
with their original identity. The original game instructions/data are unchanged.
Offline tests check compiler/environment identity, stable request caches, payloads,
bootstrap compression round-trip and public download integrity. Live Delta startup
still requires user validation; this is a compatibility fix, not a claimed live pass.
