# Devil Hub

Anime Legacy hub with a completely rebuilt dark crimson interface: vector icons,
left sidebar, category pages, two-column collapsible cards, searchable dropdowns,
page search, themes, draggable window and launcher, and a responsive mobile layout.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil.lua"))()
```

Supports Anime Legacy: universe `10765902945`, or place `106198175232796`.
`Ctrl` / `RightShift` hides or opens the window. The floating Devil icon also toggles
the window and can be dragged. Typing in an input suppresses keyboard shortcuts.

## Categories

Main, Fruits, Modes, Equipment, Player, Gacha, Auto, Potions, Traits, Breathing,
Config, and Search. Each category keeps the original feature pages, callbacks,
automation workers, status displays, priorities, favorites, and configuration
controls. The Player category retains the existing speed, jump and flight system.

Saved profile paths retain their original `ItachiLegacy-<UserId>` names so existing
profiles and favorites still load. Old theme names map to Devil themes. Reconnect
resumes from this repository's `devil.lua`.

## Source and builds

- `devil.lua`: generated, self-contained hub payload; includes the new UI.
- `loader`: small alternative launcher for the same payload.
- `src/ui.lua`: native Roblox UI library.
- `src/legacy.lua`: recovered Legacy controller with UI and branding changes.
- `movement.lua`: preserves the repository's previous standalone Speed/Fly script.
- `tools/build.py`: rebuilds `devil.lua` from the two source modules.

```sh
python tools/build.py
python tools/test.py --luau-dir /path/to/luau-binaries
```

Validation compiles all entry points, checks the recovered feature inventory,
and tests the UI API and interaction lifecycle using a Roblox API mock. These
checks do not replace an in-game test. Actual game integration has not been
tested in Roblox here.

The Legacy controller and original post-load integration derive from
[`itachidevrs/script`](https://github.com/itachidevrs/script). The original `gg2`
post-load integration URL is retained; the new UI does not fetch the old UI library.
