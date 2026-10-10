# DEVIL HUB / Steal an Egg systems test

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil-steal-an-egg-systems-test.lua?v=chilli-hatch-test-1"))()
```

Open Steal an Egg, close the previous DEVIL HUB session and run this separate
entry. Under **Plot → Eggs & pets**, enable **Auto Hatch / Chilli Test**.
**Hatch minimum rarity** keeps the selected tier and higher tiers;
**Hatch minimum income ($/s)** accepts values such as `1m`, or blank for any.
The Auto Hatch description reports waiting, accepted requests or rejection.

This is a limited gameplay update with the existing DEVIL HUB GUI and previous
Steal an Egg engine. It adapts the recovered Chilli Auto Hatch closure (slot
2272) from the Luraph source whose SHA256 is
`6c0a0cd11368cff8b1b2d18cb1d17f4e57afbed8d3c917f66062324d2332162c`.
The latest source hash is recorded by the private build manifest; the pinned
download is retained locally for review.

The new path reads only the local owner's placed, ready eggs, filters rarity
and income, and makes up to four attempts in one worker. It calls the exact
reference remote names `RF/EggWorld/AskHatch` and
`RF/EggWorld/AskFinishHatch`, with the reference's 0.35-second intermediate wait,
0.2-second spacing and ten-second rejection cooldown. A missing remote is
reported; no alternative remote names are guessed. A finish response which
does not reject the call is counted as accepted requests, not proof of a hatch.

This entry does not introduce the new Chilli Instant Steal V2, Fusion/Wisp or
Mech systems. Those recovered closures still have unresolved dependencies.
Other game systems remain from the previous DEVIL HUB implementation. The
main loader and main Steal an Egg entry are unchanged. Starting this entry
uses the shared session cleanup to stop a previous DEVIL HUB Egg session.
Its new hatch worker is cancelled on unload and stops sending requests when
the toggle is disabled.

Validation: 19 adapter checks cover eligible/owned inventory inputs, filters,
request order, four-item batches, overlapping workers, rejection cooldown,
missing remote recovery, disable/unload and empty inventory. The existing GUI
bridge checks and official Luau compilation pass. The adapter is also checked
through the VM pipeline. No live Roblox/Delta test has been performed.
