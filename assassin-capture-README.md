# Post-auth Assassin capture

Run after the original Ouroboros UI and game features are working:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assassin-capture.lua"))()
```

This read-only collector looks for source retained in function debug information
and large source constants in the loaded bootstrap. Candidate Lua is compiled
for syntax only, never executed. It also records bounded table/buffer/upvalue
graphs from functions explicitly tagged `FlowAuthRuntime`, for offline VM analysis.
Version 2 also reads callback references from recognized Ouroboros UI buttons
using `getconnections`, if an isolated BindableEvent self-check confirms that
the API exposes the actual callback function. No UI button is clicked and no
connection is fired, disabled or replaced.
It does not install hooks, call game remotes, alter authentication or run inspected
functions. Scalar string upvalues and recognizable credential fields are omitted.
The collector compiles with Luau and passes 15 core checks plus 11 integration
checks using a deliberately sparse getgc fixture and working connection API.
They cover graph identity, credential-field omission, buffer serialization,
limits, source selection, API probes and UI callbacks without execution.
It has not been run inside Roblox here.

Files are saved inside the executor workspace under
`DevilAssassin_Capture_<UTC timestamp>/`, or with that prefix if directories are
unsupported. `manifest.json` lists exactly what was captured. Zero candidates
means source extraction did not succeed; VM state is not runnable game code.

Named compilation removes the original source from debug information in many
runtimes. Executor support for getgc/getconstants/getupvalues also varies, and
graph redactions/limits may prevent reconstruction. This is a capture method to
try against an already successful authorized run, not a guaranteed devirtualizer.
The manifest distinguishes API presence from behavior: `probes` reports whether
getgc/getupvalues/getconstants/getconnections can inspect known local fixtures.
It also records the executor name/version when that API is available.

Send `manifest.json` first to establish whether useful material was captured.
Source candidates and VM data stay local and require inspection before reuse;
they are not published by this collector. Opaque VM buffers may contain private
runtime data, so do not commit the capture directory to a public repository.
