# Post-auth Assassin capture

Run after the original Ouroboros UI and game features are working:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assassin-capture.lua"))()
```

This read-only collector looks for source retained in function debug information
and large source constants in the loaded bootstrap. Candidate Lua is compiled
for syntax only, never executed. It also records bounded table/buffer/upvalue
graphs from functions explicitly tagged `FlowAuthRuntime`, for offline VM analysis.
It does not install hooks, call game remotes, alter authentication or run inspected
functions. Scalar string upvalues and recognizable credential fields are omitted.
The collector compiles with Luau and passes 14 offline checks for graph identity,
credential-field omission, buffer serialization, limits and source selection.
It has not been run inside Roblox here.

Files are saved inside the executor workspace under
`DevilAssassin_Capture_<UTC timestamp>/`, or with that prefix if directories are
unsupported. `manifest.json` lists exactly what was captured. Zero candidates
means source extraction did not succeed; VM state is not runnable game code.

Named compilation removes the original source from debug information in many
runtimes. Executor support for getgc/getconstants/getupvalues also varies, and
graph redactions/limits may prevent reconstruction. This is a capture method to
try against an already successful authorized run, not a guaranteed devirtualizer.

Send `manifest.json` first to establish whether useful material was captured.
Source candidates and VM data stay local and require inspection before reuse;
they are not published by this collector. Opaque VM buffers may contain private
runtime data, so do not commit the capture directory to a public repository.
