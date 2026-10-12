# Ride a Pet: ride-native-obf-18

The main router now selects the encoded native Ride entry. Ride and its Delta
compatibility entry no longer include DEVIL's additional Fiu startup VM.
The original Lucy interpreter and its pinned program data remain required;
this release does not claim to devirtualize that original runtime.

Verification and hex decoding now yield after 12 ms of CPU work instead of
unconditionally yielding at every small chunk. Initialization uses the same
12 ms budget in place of 4 ms. Integrity checks and original gameplay callbacks
are preserved. Ride entry size drops from 138,729 to approximately 43,000 bytes.

Use the existing main loader and rejoin before loading this release:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader?v=vm-1"))()
```

Offline validation covers exact decoded source, argument/return nils, rejection
of corrupted payloads, routing/retry/cleanup, and Delta's protected environment
with pinned VM/data integrity. The original VM factory is stubbed in the offline
entry test; actual in-game load time remains to be measured.
Phase timings are saved by the executor in `DevilRideLucyTest-report.json`.
