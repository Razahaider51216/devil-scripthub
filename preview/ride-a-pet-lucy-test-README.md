# Ride a Pet / Lucy compatibility test (lucy-test-2)

Separate test; the main loader's Ride a Pet entry remains unchanged.
Rejoin Ride a Pet, then run this BEFORE the main loader or another Lucy test:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/preview/ride-a-pet-lucy-test.lua?v=2"))()
```

The first version decompressed the 889,839-byte upstream wrapper inside the game.
This version removes that preparation cost by downloading its exact decoded VM
and data from a pinned commit. Original protected VM, callbacks, frontend and
runtime data are retained; this is NOT a fully devirtualized source port.
Preparation, data decoding and integrity checks yield regularly. A phase report
is saved before compilation, VM initialization and gameplay launch.

Assets derived from upstream cafe92b2d7b3c2d29ae55e6958a5325e0a0751c0:
- VM: 85,896 bytes; SHA256 0c542d43c7f1e4980fe87caa3708c983583e9e1391875bbb381bcc405fbd901d
- Binary data: 1,215,230 bytes; SHA256 bea836b2d7ccab42cfc2a68948f062662ffae03f2dc11b01212e66e37384162c
- Transport uses hex text for binary data to avoid HTTP text encoding corruption.
Both decompressed artifacts were compared byte-for-byte with the original
ASCII85 + LZMA output before publishing. Checksums are verified before execution.

Requires loadstring, buffer.fromstring, string.pack and string.unpack. The
original runtime may issue its own network requests. Original API/access checks
within the VM remain intact. A CPU-bound original VM can still block Roblox's
cooperative scheduler; the background monitor cannot forcibly interrupt it.
A network request that never returns also needs executor/network diagnosis.

If writefile exists, saves DevilRideLucyTest-report.json with status, failedPhase,
elapsed time and per-phase timings. The yielding-stall monitor refreshes that
report every 15 seconds while loading. If VM initialization starts, this test
requires a rejoin before any retry, including after an error, to avoid stacking
original runtime tasks. Runtime return does not prove GUI/gameplay worked.

Offline validation: runner syntax compiles; 12 regression cases pass, including
exact binary roundtrip, preparation yielding, corrupted VM/data rejection,
invalid encoding, HTTP retries, compilation/initialization errors and duplicate
startup protection. Live Delta/Roblox behavior has not been verified.
