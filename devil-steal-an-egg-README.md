# DEVIL HUB / Steal an Egg

The main loader selects `devil-steal-an-egg.lua` for universe `10563114921` or place `107778070777162`. This VM-protected entry delegates to the recovered native UI, pinned to commit `8199d2d36f34f81e398dd62df2666062eb285f96`. Its downloaded entry length and checksum are checked before native compilation.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader?v=vm-1"))()
```

Rejoin once before changing from an older Steal an Egg engine. The latest entry provides DEVIL HUB OuroFlow controls, preserves the original native gameplay engine and callbacks, hides the original loading screen, adds readable DEVIL startup stages, fixes native border rescaling, and removes the cyan line crossing the Steal Panel title.

The small main-map delegate retains the existing modified Fiu VM. The recovered presentation adapter executes through the native compiler so the protected game VM is not interpreted inside another VM. This is partial native UI recovery; complete VM devirtualization and live Delta validation are not claimed.

Validation executes the actual unchanged public loader across all five universe/place mappings, retries, unsupported-map and busy guards, and executes the new main-map delegate through its public VM bootstrap. Delegate checks cover pinned release selection, native compilation, return/argument forwarding, corruption rejection and cross-map redirect. Published source hashes are verified after upload.

See [the recovered UI release notes](devil-steal-an-egg-chilli-recovered-ui-test-README.md) for native recovery details and report filenames.

DEVIL HUB Discord invite: https://discord.gg/fDwPCmpkkh. Home, community display and copy actions use this invite; the original remote Discord helper is no longer fetched.

The Discord community logo uses assets/devil-logo.png, matching the main DEVIL HUB frontend.

shared-loading-3 replaces the adapter's separate startup card with a lease on the
main router's one compact card. The original Chilli loading constructor remains
suppressed. Native game VM/data, Steal Panel behavior and callbacks are unchanged.

The 2026-10-19 release integrates the latest Chilli Halloween systems. See
[update details and validation](tools/chilli-20261019/README.md).
Rejoin before using the updated loader if the previous engine is already running.

The active GUI includes saved appearance settings and DEVIL HUB webhook branding;
Venyx and the extra DEVIL HUB mode tab are removed. Rejoin before updating.

All game entries now share the dark-blue presentation module. The Settings
appearance shortcut uses the inline language selector; the color panel is removed. Game callbacks and
the native startup-environment fix are retained.
