# Devil Hub / Ouroboros GUI test

This is a separate experimental build. The production loaders and scripts are
unchanged. Run it in a fresh game session, using the preview entry:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/preview/ride-a-pet-test.lua"))()
```

The GUI library is the same ObsidianUltra dependency identified in the local
`ouroboros-source/ride-a-pet.recovered.luau`; the Ouroboros gameplay script is
not executed. Tabs and sections are populated from Devil Hub's original
controllers, rather than copying the Ouroboros feature list. The title/footer
identify the build as a test.

Standard toggles, sliders, dropdowns, multi-selects, inputs, buttons and status
labels use Obsidian controls. The adapter returns the original option handles:
callbacks, saved state, visibility dependencies and configuration updates still
use the original controllers. Native value changes update the new controls
without firing callbacks again. The original backend visual frame is hidden; its ScreenGui remains enabled
so native measurement and initialization can continue. Its
launcher and open/close actions control the new interface.

Custom canvas/predictor panels and action dropdowns retain their original GUI
instances through Obsidian's UI passthrough feature. Their appearance and touch
behavior still need verification in the real game. This is a runnable candidate,
not a claim of verified Roblox/DeltaX integration. Do not merge into production
until it has been checked in-game.

The loading overlay, packed distribution and Devil Hub webhook branding are
retained. Test loading state has its own namespace and retries this preview.
Gameplay payload bytes are unchanged from the working original runtime.

Validation: official Luau compilation of the actual UI library, adapted native
UI constructor and packed release; original-controller bridge mocks; callback
counts; state/config sync; multi-select conversion; live labels; visibility;
category selection; custom-instance preservation; loading/failure/retry/close;
exact pack roundtrip; exact original gameplay bytes; production file isolation.
No test webhook or Discord messages are sent.

UI provenance: [joustingmatch/ObsidianUltra](https://github.com/joustingmatch/ObsidianUltra),
commit `92b2f6c90e78d47cab449bdfc2d558d7c35a503c`, upstream `Library.lua` SHA256
`3c985738a6e9b7089f61bc5869a90e8207e62994a0816f59b9dee97ce1c7b946`.
The MIT license and original attribution are preserved in
[Obsidian-LICENSE.txt](Obsidian-LICENSE.txt).

## Startup fix

The preview adapts only the downloaded native GUI constructor using an HTTP
hook for both function calls and Roblox `__namecall` dispatch. It leaves the VM compiler (`loadstring`) untouched. This experimental
bridge requires executor support for `hookfunction`; if it is missing, startup
fails visibly instead of installing a compiler wrapper.

The GUI library includes Lucide icon metadata and uses Roblox sprite assets.
Default textures also use their Roblox assets. Startup no longer downloads
Lucide spritesheets or the default PNG textures. The upstream GUI layout is
retained; these are test-only startup patches. Lucide's MIT license is included
in `Lucide-LICENSE.txt`.

Loading displays separate download/library/controller/window/control stages.
The GUI-library download has a timeout. Once live frontend controls have settled,
the loading overlay closes even if the original gameplay coroutine continues
running. Merely creating an empty window is insufficient. Native controls and
state callbacks remain the readiness source. Production files are unchanged.

The preview keeps the upstream default palette and widget styling. It verifies
that a frontend window and live controllers exist before accepting startup. A
backend-only launch reports a failed GUI connection instead of success.
