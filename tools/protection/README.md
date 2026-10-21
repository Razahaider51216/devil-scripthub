# Release protection

Release `devil-all-games-obf-20261021-1` protects the main router and the runnable
files for all 12 supported maps. Six game entries lacked a VM startup boundary:
Mine / Dump23, Tap Simulator 2, Steal an Egg, Ride a Pet, Anime Dice and Dig For
Eggs. Their new wrappers use the existing modified Fiu startup interpreter and
randomized payload/opcode packaging. Shared GUI and Steal runtime dependencies
are protected and repinned with updated size/checksum guards.

The six previously VM-protected entries, their route pins, and Break's existing
runtime are byte-identical to the baseline commit. They are explicitly recorded
in `skip_existing`. Rebuilding an existing package never adds another wrapper.
The main router retains its existing single startup boundary; its new payload
updates only protected dependency/entry pins and their transfer checks.

The interpreter is limited to startup: unpacking and compiling native source.
Gameplay loops, UI handlers and returned functions execute natively in their
original environment. Native decoders yield between chunks. No FPS improvement
or universal executor compatibility has been measured. Protected payloads add
download size and startup work; the artifact manifest records the byte counts.

Obfuscation is a deterrent, not encryption, licensing, authentication or guaranteed
secrecy. An executor can inspect client-side code at runtime. Existing public Git
history and previously published source/development files remain accessible;
this release does not change repository visibility or rewrite history. Scope is
production runtime artifacts, not dumpers and unrelated test scripts.

MIT/Fiu license notices remain in every new wrapper. Native build inputs are
kept outside the repository in `../devil-protection-20261021`; no new plaintext
gameplay payload or opcode-map copy is added to this release.

Validation:

- `python tools/protection/test.py`: executes all 19 artifact boundaries, checks
  exact native source against Git baseline with only declared pin/checksum
  substitutions, nil argument/return forwarding, environment preservation,
  cooperative decoding, corruption rejection and immutable dependencies.
- `python tools/protection/test-chain.py`: protected Steal transfer checks and
  preservation of all six existing protected game files/pins.
- `python tools/protection/test-behavior.py`: existing shared GUI, 12-route
  desktop/mobile/hybrid, Anime Dice and Dig UI fixtures against captured native
  source; wrappers are verified separately by the boundary suite.
- `python tools/blue-gui/test-router.py`: the actual public loader across 36
  universe/place cases, arguments, retries, failure cleanup and duplicate guards.

The packaging suite supplements historical tests that assumed public files
contained readable source or specific historical pins. Keep using each game's
native core/adapter regressions for gameplay edits, then pack and validate the
result before publishing. Do not wrap already packaged input again.
