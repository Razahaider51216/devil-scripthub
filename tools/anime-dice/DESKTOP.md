# Desktop Tower choices

Release `anime-dice-desktop-towers-20261021-3`.

The screenshot shows an empty dropdown, which alone cannot identify the user's
executor failure. Inspection reproduced two paths that leave it empty: an
unavailable optional native module is never retried, and a Dice rendering failure
prevents the subsequent Tower refresh. Choices also unnecessarily waited for a
complete player snapshot.

The adapter now retries unavailable modules in one background worker. Tower,
HauntedHouse and TowerRefs have a metadata fallback derived from the supplied
ClientRuntimeV8 Run_20261020_011805_1 dump. The seven normal towers and six wings
retain native request IDs, images, difficulty, floor ranges and native action
timings. Each source hash is recorded in tower-catalog.lua. Live modules replace
the fallback after recovery, including any newly added towers. This metadata
does not fabricate battle outcomes, drops, damage or unlocks; server requests
and confirmations remain authoritative. Dump metadata can become outdated if
the game changes while native module loading remains unavailable.

Tower choices refresh before player snapshot readiness. Optional presentation
failures are recorded individually in Report.ChoiceErrors so another selector
can still populate. No executor identity changes or global require hooks.

The public-entry regression exercises failed module loads, fallback artwork/IDs,
native recovery and an isolated Dice rendering exception. The shared GUI startup
suite exercises all 12 routed games under desktop, touch laptop and mobile input
profiles, five GUI parenting/access profiles, resizing and 4K. Native callbacks
and scaling remain intact. These fixtures do not establish live compatibility
with every executor or verify gameplay inside Roblox.
