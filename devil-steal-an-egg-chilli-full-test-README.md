# DEVIL HUB / complete Chilli runtime test

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil-steal-an-egg-chilli-full-test.lua?v=chilli-full-test-1"))()
```

This separate test runs the complete original Chilli StealAnEgg runtime and
its original frontend. It is not the earlier Auto Hatch-only adaptation.
It is also not a completed devirtualized migration to the DEVIL HUB frontend.
The original menus and callbacks are retained together so unresolved VM
dependency slots do not get replaced with guessed implementations.

The wrapper downloads the unchanged protected source from this fixed public
[Chilli StealAnEgg snapshot](https://github.com/tienkhanh1/Chilli-Hub-Script/blob/5718ad8818f412ccca12d67dc18dbc2964b7a829/StealAnEgg),
SHA256 `6c0a0cd11368cff8b1b2d18cb1d17f4e57afbed8d3c917f66062324d2332162c`.
The transfer is checked for its expected length and numeric checksum; the
recorded SHA256 is from the inspected local snapshot. Its original Luraph
protection is retained. No authentication checks are removed.
The main DEVIL HUB loader and current Egg entry are unchanged.

Open Steal an Egg and rejoin before testing to remove any prior Chilli runtime.
The wrapper stops a previous DEVIL HUB Egg session, checks map and executor
loadstring/buffer support, and prevents repeated full-runtime launches in the
same session. It writes `DevilChilliFullTest-report.json` when the executor
supports file writing. "Runtime returned" means the loader returned; it does
not verify that the UI or individual systems work. Rejoin to end the full test
or before switching back to the main DEVIL HUB Egg entry.

The recovered code shows references to stealing/carry modes, hatch, fusion,
Wisp, Mech, treadmill and other systems. Runtime behavior and server acceptance
still require a live in-game test. No live Delta test has been performed.

Validation: fixed-source comparison, official Luau compilation and
20 wrapper checks cover map guard, pinned download, preserved source, old-session cleanup,
duplicate prevention, API checks, compile/native failure reporting and return
values. Those wrapper checks replace the protected engine with a sentinel;
they do not execute or validate its game systems. Two offline recovery attempts
stopped before game initialization and recovered no VM prototypes, so their
trace output is not used as a replacement gameplay implementation.
