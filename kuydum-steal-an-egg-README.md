# KUYDUM HUB — Steal an Egg

Standalone release `kuydum-native-start-20261022-3` for Steal an Egg
(universe 10563114921, place 107778070777162).

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/refs/heads/main/kuydum-steal-an-egg.lua?v=kuydum-native-start-20261022-3"))()
```

The existing Steal an Egg gameplay runtime is repackaged with byte-identical
native source and original game VM. The frontend is named KUYDUM HUB, uses a monochrome palette, and links
to https://discord.gg/tCnZhrBcM. `assets/kuydumhub.jpg` is an exact copy of the
user-provided original photograph. Executors supporting custom assets load it
from the local JPEG cache; otherwise the frontend retains the remote asset URL.
Actual image support depends on the executor.

The startup progress/loading screen remains removed. Startup uses no loading
tween, percentage window or input-blocking overlay. The native Chilli screen
guard remains active. All four KUYDUM artifacts now decode and compile natively,
without an added Fiu startup interpreter. The original game VM remains unchanged.
The runtime compilation boundary explicitly binds to the original host environment,
not the UI proxy: _G, getgenv, getfenv and filesystem/compiler APIs retain their
original behavior. The UI context still keeps its own branding/state. A regression
reproduces v2's incorrect game-runtime environment as well as v1's missing APIs.
These changes do not prove every possible cause of a live stall is resolved;
rejoin before testing to discard an old blocked task.

The frontend creates a private Lua environment/state context. It does not replace
the global compiler, clipboard API or DEVIL HUB main loader. Native gameplay uses
its original global state and exports its existing native-window handle there;
the private GUI reads that handle. Running two hubs' automation simultaneously
against the same character is not independently isolated.
Own GUI settings/report files beginning with Devil/DEVIL receive a Kuydum/KUYDUM
prefix. Copying a native Discord invite explicitly uses this brand's invite;
startup does not copy an invite. The auto-execute queue points to this standalone
entry and uses its own arrival guard. Repeated runs reuse the active frontend;
the existing native engine auto-execute slot is leased only when unused, to
prevent its legacy loader being queued too; close/error cleanup releases it.
closing it releases the frontend and theme subscriptions so it can reopen.

Entry, GUI, theme and runtime use native encoded startup packages, pinned with
size/checksum validation. Only the pre-existing original game VM is retained.
Obfuscation does not guarantee secrecy.

`python tools/kuydum/test.py` verifies wrapper/native-source integrity, the exact
logo, immutable gameplay reuse, unchanged DEVIL HUB files, a monochrome GUI,
native callbacks/language, state/file isolation, manual invite copy, duplicate
runs, own rejoin payload, close/reopen, failed download cleanup and wrong-map
rejection. These are offline fixtures; live Roblox/executor behavior has not
been verified. The gameplay engine retains its original lifecycle behavior.
