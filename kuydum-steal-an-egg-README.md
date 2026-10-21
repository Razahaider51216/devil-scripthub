# KUYDUM HUB — Steal an Egg

Standalone release `kuydum-steal-20261022-1` for Steal an Egg
(universe 10563114921, place 107778070777162).

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/refs/heads/main/kuydum-steal-an-egg.lua?v=kuydum-steal-20261022-1"))()
```

The existing Steal an Egg gameplay runtime is reused at its immutable protected
commit. The frontend is named KUYDUM HUB, uses a monochrome palette, and links
to https://discord.gg/tCnZhrBcM. `assets/kuydumhub.jpg` is an exact copy of the
user-provided original photograph. Executors supporting custom assets load it
from the local JPEG cache; otherwise the frontend retains the remote asset URL.
Actual image support depends on the executor.

This runner creates a private Lua environment/state context. It does not replace
the global compiler, clipboard API, existing DEVIL HUB state or its main loader.
Own GUI settings/report files beginning with Devil/DEVIL receive a Kuydum/KUYDUM
prefix. Copying a native Discord invite explicitly uses this brand's invite;
startup does not copy an invite. The auto-execute queue points to this standalone
entry and uses its own arrival guard. Repeated runs reuse the active frontend;
closing it releases the frontend and theme subscriptions so it can reopen.

Both GUI and theme use obfuscated VM startup packages, with the same native
gameplay/UI execution architecture as the existing releases. They are pinned
with size/checksum validation. Obfuscation does not guarantee secrecy.

`python tools/kuydum/test.py` verifies wrapper/native-source integrity, the exact
logo, immutable gameplay reuse, unchanged DEVIL HUB files, a monochrome GUI,
native callbacks/language, state/file isolation, manual invite copy, duplicate
runs, own rejoin payload, close/reopen, failed download cleanup and wrong-map
rejection. These are offline fixtures; live Roblox/executor behavior has not
been verified. The gameplay engine retains its original lifecycle behavior.
