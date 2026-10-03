# Devil Hub

## Ride a Pet

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/ride-a-pet.lua"))()
```

This separate Ride a Pet release adapts Chilli Hub with the DEVIL HUB name,
a crimson community card, the supplied logo, and
[DEVIL HUB Discord](https://discord.gg/ZY7PRcVJe2). The original gameplay VM is
retained. Its captured outer layer was decoded; complete devirtualization was
not required for these UI changes. Existing dependencies and settings remain
compatible. Teleport auto-load points to this release.

Validated with Luau compilation, branding checks, an isolated VM loader test
up to a stub gameplay entry point, and an exact packed-payload comparison.
Actual Roblox gameplay and visual layout have not been tested in this environment.
The release is packed for distribution; packing is reversible.

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
