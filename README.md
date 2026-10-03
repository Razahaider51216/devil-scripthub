# Devil Hub

## Ride a Pet

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/ride-a-pet.lua"))()
```

The Delta-compatible Ride a Pet build retains the original protected Chilli
runtime byte-for-byte. The interface is restyled externally: a dark crimson
window, left category sidebar with native vector icons, original controls on
the right, the supplied monochrome logo, and `2K+` community member text.
[DEVIL HUB Discord](https://discord.gg/ZY7PRcVJe2) replaces the old invite.

The original buttons and callbacks are retained when categories are moved.
Native main-window and content geometry are retained; no extra UIScale or
content-size locks are added. Navigation sits beside the native window. The
launcher keeps its original dragging and toggle behavior, and its randomized
button is recognized by the original logo asset ID. The extra floating
Discord button has been removed. No extra payload
packing or modified gameplay VM is used. The original game's dependencies and
teleport behavior remain. The original runtime was confirmed working by the
user on DeltaX; this newest visual layout has not been tested inside Roblox.

Validation: official Luau compilation, exact original runtime bytes, isolated
startup/clipboard cleanup, and GUI mocks covering native callback preservation,
page selection, native dimensions, absence of an extra scale, randomized
launcher logos and event preservation, categories created later, and HUD isolation.

## Anime Legacy

Anime Legacy hub with a dark crimson UI, category sidebar, collapsible cards,
search, configurable themes, and the supplied black-and-white logo.

## Start

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader"))()
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
