# Assassin loader diagnostic

This is a runnable diagnostic, **not recovered/devirtualized gameplay code**.
Three bounded offline attempts stopped in VM initialization; zero game
functions were recovered. The supplied runtime is the protected FlowAuth
bootstrap and needs its original loader handoff.

Open +1 Assassin Leveling, then run:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assassin-test.lua"))()
```

The panel checks client capabilities and downloads the pinned bootstrap for
size/checksum/compilation checks. It does not execute that bootstrap alone.
If the asset endpoint blocks the diagnostic download, the original loader
may still work through its own fallbacks.

Press **Run original loader** to fetch and execute the public Ouroboros game
entry with its original authentication. Supply any required authorization
through the original loader's supported flow. A returned loader is not proof
of successful authentication or working gameplay. A 30-second notice means
the loader remains running/waiting; it does not cancel execution.

**Save report** writes `DevilAssassinTest-report.json` in the executor's workspace.
It records map IDs, capability flags and status, with no key or source payload.
The close button closes the diagnostic panel only.

No namecall hooks or game remotes are used by the diagnostic. Pressing Run
executes upstream code, whose own behavior is outside these diagnostic checks.

Validation: Luau compilation and 19 executable core checks (including the
supplied runtime checksum, altered/truncated responses, compiler failures and
launch exceptions). Live Roblox/executor behavior has not been tested here.
