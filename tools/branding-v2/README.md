# DEVIL HUB v2 branding

`assets/devilhubv2.png` is an exact copy of the supplied logo. The asset is pinned
to its Git commit; cached PNG bytes are checked before reuse. Executors with
custom asset support display this PNG on brand logos. Without an asset API the
custom vector D remains visible as a fallback.

`assets/devil-d-toggle.svg` is the authoritative custom white/blue D artwork. The
build converts its even-odd polygon paths into 104 merged native GUI rectangles.
Launcher/reopen and Island brand image slots use this vector, independent of
PNG downloads or executor SVG support. Existing click/drag/minimize handlers,
visibility, size and window layout remain under each native GUI's control.

The shared presentation keeps its existing compatibility version and exposes a
separate `BrandingVersion`. New entry preludes verify/download the immutable
shared module before existing game startup. Old shared preludes recognize the
compatible controller and skip loading their historical theme. The per-game
public payload after the new prelude is byte-for-byte unchanged, including its
original VM, compiler boundaries and gameplay. No additional game VM is added.

Coverage: the 12 main-loader routes, Ride a Pet Delta, Break runtime, two Steal
GUI aliases and the standalone HatchToFight test. KUYDUM and dump tools retain
their own branding. Unrelated working-tree files are not rebuilt.

The release manifest records immutable asset/module/entry commits and hashes.
The main loader retains all game IDs and gameplay versions and updates only
the route commits, brand prelude and logo cache preference. Historical gameplay
validation remains applicable to the unchanged payload; current branding is
validated separately. No live Roblox/executor rendering was available.

Build order:

1. Commit the logo/SVG assets and update `ASSETS` in `build.py` when changing art.
2. `python tools/branding-v2/build.py shared`, test and commit the shared module.
3. `python tools/branding-v2/build.py entries`, commit the entry overlays.
4. `python tools/branding-v2/build.py router`, then run the branding suite.

`BASELINE` deliberately names the reviewed pre-brand release. A later game
release must use its new reviewed baseline instead of replaying the old payload.
Future native entry builds using `tools/blue-gui/build-entries.py` pick up the
new module commit and require the branding version. Standalone builds without
that shared prefix must retain/reapply the brand prelude from the manifest.

Validation: `python tools/branding-v2/test.py` executes the exact recovered
native shared module against existing GUI, desktop/mobile/4K and mini-bar
fixtures; checks PNG cache, D rendering, late native redraws, original clicks,
content image isolation and cleanup; verifies all 17 payload hashes and 12
unchanged route identities. `custom-d-preview.png` in the external build folder
renders the same generated rectangles used in the runtime.
