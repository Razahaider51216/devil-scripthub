# Ride a Pet / Lucy upstream compatibility test

This separate test uses the complete protected Lucy Again runtime from the
reviewed latest upstream commit cafe92b2d7b3c2d29ae55e6958a5325e0a0751c0.
The original GUI, callbacks and game systems are retained. This is not a
fully devirtualized port or a replacement for the current main loader.

Rejoin Ride a Pet and run this test before any other DEVIL HUB entry:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/preview/ride-a-pet-lucy-test.lua"))()
```

Requires loadstring, buffer.fromstring, string.pack and string.unpack from the
executor. The source is pinned and checked for byte length/checksum before
launch. The original VM and its access checks are not modified. Upstream may
perform its own network requests after launch. The wrapper makes no claim that
the GUI opened or game features worked merely because the runtime returned.
If writefile is available, saves DevilRideLucyTest-report.json. Share that
report plus whether the original GUI/farm worked to verify game compatibility.

Offline checks: original syntax and wrapper syntax compile; nine wrapper
regressions pass (success/arguments/reporting, wrong map, missing pack, changed
source, bad HTTP response retries, compile failure, runtime failure, duplicate
startup, existing frontend). The original runtime was not run in live Roblox.
