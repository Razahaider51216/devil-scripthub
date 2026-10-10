# Devil Hub

## Universal loader: 5 games

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader?v=hub-5-vm-1"))()
```

Automatically selects Steal An Egg, Ride a Pet, Break and Steal an Egg, Loot to Forge, or Build An Ant Empire
using the Roblox universe/root place ID. Each game keeps its own production
script, UI, features and configuration; only its module is downloaded.
Unsupported games fail before fetching a module. The universal loader and all
eight routed production entries/runtimes now use bytecode virtualization with
per-build opcode permutation. See [VM release details](vm-protection-README.md).
Client-side virtualization cannot guarantee secrecy.

Validated with all five universe/place mappings, scoped downloads, argument
forwarding, startup guards, failure recovery, packed integrity and Luau
compilation. Actual combined-loader behavior still needs an in-game run.

Steal An Egg is mapped to universe `10563114921` / root place `107778070777162`,
verified through the Roblox APIs. Its DEVIL HUB frontend and readable gameplay
implementation now ship together as virtualized bytecode in
`devil-steal-an-egg.lua`. See [Steal An Egg details](devil-steal-an-egg-README.md).

Ride a Pet now includes an **Egg Return** tab with Auto Collect & Return,
multiple egg-type filters, travel speed and manual pickup/home/stop controls.
The added controller is virtualized; the original protected runtime remains
byte-identical. See [Egg Return details](ride-egg-return-README.md).

2026-10-08 startup fixes: all six production entry points (the four games plus
Ride/Break runtime entries) check the current universe/place before creating
their GUI. Launching a game-specific entry in another supported map redirects
through the universal loader. Downloads through the router and Ride/Break
entry wrappers retry up to three times. Failure panels show the first actual
error; the full traceback stays in the console. Build An Ant Empire's
Keybind/ColorPicker bridge now resolves native addons from Options instead of
using their parent rows. The same fix is already applied to Break Egg.

Validated with Luau compilation and executable mocks for all four universe/root
mappings, six cross-map entries, retries, failure-state recovery, unsupported-map
and duplicate-load rejection, and both native addon bridges. Ride and Loot
gameplay payloads are unchanged. Live Roblox/executor behavior still needs a run.

Break Egg now includes Main > Farm Rarities > Egg + Animal Rarities: a shared
multiselect for Auto Egg and Auto Pet Carry Farm. See its game README for details.


## Executor startup compatibility

Startup downloads prefer `game.HttpGet`, then try `game.HttpGetAsync` and
`request`, `http_request`, `httprequest`, `http.request`, `syn.request`, or
`fluxus.request`. Failed downloads retry three times; HTTP error responses,
HTML and empty Lua responses are rejected. Binary logo downloads retain their
original bytes. Errors remain readable when `debug.traceback` is unavailable.

The GUI bridges also accept `hookfunc` or `syn.hookfunction` when the executor
does not expose the global `hookfunction`. Required startup APIs are checked
with an explicit missing-API message. Ride a Pet and Build An Ant Empire still
need native `game.HttpGet` and a working HTTP hook. Break Egg and Loot to Forge
need `loadstring` and `setfenv`. These checks describe startup requirements;
they do not emulate missing gameplay APIs.

The initial one-line launch command above itself needs `game:HttpGet` and
`loadstring` before the downloaded adapter can run. No executor brand is
blocked. Real and other executors have not been tested live; support depends
on their available APIs. Existing GUI, farming controls and embedded gameplay
payloads are preserved. Local validation covers 22 adapter checks, four map
mappings, six entry guards, retries, packed integrity, exact original gameplay
literal bytes, and compilation of all seven public files.

## Ride a Pet

Startup fix `ride-vm-2`: the original Luraph-protected runtime now uses the executor's native compiler, avoiding an additional Fiu VM around that runtime. Its payload bytes are unchanged; DEVIL HUB's loader and GUI adapter remain virtualized. The universal loader uses a new Ride version query. Other published game artifacts are unchanged.

Rejoin the map before testing if an earlier attempt left startup flags active. Startup errors now notify the user and save local reports where `writefile` is available: `DevilHub_Startup_loader.json`, `DevilHub_Startup_ride_a_pet_lua.json`, and `DevilHub_Startup_ride_a_pet_delta_lua.json`. Returned means execution returned, not proof of GUI readiness. Missing compiler/buffer APIs and compile/runtime errors are recorded. Offline compiler-boundary, router, and startup-report tests pass; live Delta startup still needs confirmation.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/ride-a-pet.lua"))()
```

The production Ride a Pet build uses [OuroFlow / Airflow UI](https://github.com/joustingmatch/OuroFlow),
pinned to `c8251f76f74d9942114ebccb0564aa0ac196320a`. It has a dark crimson
interface, an icon sidebar, search, two-column collapsible cards, a profile and
a draggable toggle on the left. Chilli's old window, launchers, logos and FPS/ping
helper are suppressed. Advanced predictor panels retain native instances.

The GUI controls call the original public `Set(value, true)` API. Initial values
and native-to-frontend updates do not fire duplicate gameplay callbacks. Buttons
use their original press actions. Native categories, saved state and configuration
remain. The original protected gameplay runtime is preserved byte-for-byte.

The Discord category displays the supplied Devil Hub logo, `DEVIL HUB`,
`2K+ MEMBERS`, and https://discord.gg/ZY7PRcVJe2. Its copy action redirects the
original invite. Chilli-branded webhook sender/embed names use Devil Hub while
retaining the destination, headers and game data.

The loading panel precedes download, remains during unpacking and startup, and
shows Retry/Close on failure. GUI readiness requires a real window and controls.
The UI library and its Roblox Lucide icon registry require network access.
This build requires executor HTTP hooks; the VM compiler remains unchanged.

Validation: official Luau compilation, exact original payload and pack roundtrip,
actual native setter and callback-dispatch code exercised in bridge tests,
facade/controller/state sync, silent initial values, profile branding, old-UI
suppression, startup/failure/retry/duplicate handling. The user confirmed the new
GUI appearance on DeltaX; the corrected automation callbacks have been tested
locally, not against a live Roblox server. No test webhooks are sent.

The outer distribution is reversibly packed. Older public commits remain
accessible; client-side packing does not provide unbreakable source secrecy.

## Anime Legacy

Anime Legacy hub with a dark crimson UI, category sidebar, collapsible cards,
search, configurable themes, and the supplied black-and-white logo.

## Start

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/anime-legacy-loader.lua"))()
```

The small loader shows the logo and loading stages before fetching the packed
hub. The hub stays hidden until initialization succeeds. A failed load offers
Retry and Close. Calling `devil.lua` directly still opens the loading overlay,
after the initial download completes.

Supports Anime Legacy: universe `10765902945`, or place `106198175232796`.
Ctrl / RightShift hides the window. The floating logo toggles it and can be dragged.
The original category features, automation, movement, profiles, favorites, and
reconnect behavior are retained. Existing saved profile names remain compatible.

## Distribution

`devil.lua` is an obfuscated distribution build. Readable development modules and
build tools are retained locally and are excluded from the current release tree.
Client-side obfuscation is reversible: it discourages casual copying but does not
provide unbreakable protection, licensing, or server-side access control. Earlier
public commits still contain the previously published readable code; removing files
from the latest tree does not remove those commits or other people's copies.

The PNG logo is cached using writefile and getcustomasset / getsynasset. If these
APIs are unavailable, the hub uses its vector icon fallback.

Validation: Luau compilation, exact payload roundtrip, damaged payload rejection,
original feature inventory, UI mock tests, and loading-screen lifecycle mock tests.
Actual game integration has not been tested in Roblox here.

The original Legacy controller derives from [itachidevrs/script](https://github.com/itachidevrs/script).
The original gg2 post-load integration URL remains in use.


## Build An Ant Empire

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/build-an-ant-empire.lua"))()
```

Full Devil Hub module, also selected by the universal loader. Uses the same
OuroFlow presentation and Abyss blue/black theme as Loot to Forge, Devil logo,
and https://discord.gg/ZY7PRcVJe2 for community/support links. Keeps the
unmodified Ouroboros gameplay revision c9624e9671239c7fbe832a480d2773ebfd3b4c5d
that the user confirmed runs. Native Obsidian controls, if used by that runtime,
are bridged into OuroFlow with their callbacks retained. The earlier test entry
remains available as the unmodified baseline. Branding and routing were tested
with mocks and Luau compilation; the branded release still needs a live run.
