# Ride a Pet - ride-lucy-main-3

Integrated in the universal main loader. Rejoin before moving from the Lucy
preview test or old Ride scripts. `ride-a-pet-delta.lua` delegates to the same
current entry, avoiding two independent old/new engines.

The exact predecoded Lucy VM/data from the successful owner test are retained;
all game systems remain original. This is not a devirtualized gameplay port.
Visible new script GUI roots are branded DEVIL HUB, with the shared silver logo
and `https://discord.gg/fDwPCmpkkh`. Existing game UI, animal pictures and original
farm buttons/callbacks are left intact. The original GUI layout is retained.
A compact 320x112 DEVIL loading card reports preparation stages before launch.
The wrapper copies environment fields into a new table instead of using
`table.clone(getfenv(1))`, which fails on Delta's protected environment metatable.
The original environment and its metatable are retained. A regression executes
the actual protected entry with a locked environment and the exact pinned VM/data
transport; the offline VM factory is stubbed, so this does not verify gameplay.

`DevilRideLucyTest-report.json` records phases/integrity/runtime return.
`DevilRideBrand-report.json` records identified vendor GUI roots/text/logo
changes (zero original control callback replacements). Report counters depend
on which native GUI components the runtime exposes during the session.
Native VM/data integrity and loader/adapter behavior are checked offline;
new visible branding still needs confirmation on Delta.

Startup now borrows the main router's one loading screen. Actual stages range
from 62% (VM download) through 86% (program initialization) and 94% (interface
launch), instead of displaying 65% for every stage. Buffer readers periodically
yield while initializing, and matching OuroFlow modules use a paced Instance
constructor during startup. Reader and constructor API fields are restored after
launch or an error; no per-frame worker is added. VM source and data remain exact.
The scoped compiler adapter gives OuroFlow's original CreateWindow the DEVIL HUB
name/logo, disables its extra loading overlay and sets the floating icon. Config
callbacks, controls and original toggle settings are preserved.
`DevilRideLucyTest-report.json` adds startupBufferReads, startupGuiNodes,
startupYields and uiConstructors for diagnosis. Cooperative yielding cannot
preempt a native compile or a protected loop that makes no wrapped API calls;
this change is not proof of freeze-free operation on Delta.
