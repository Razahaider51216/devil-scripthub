# Protection and native execution ? silver-native-1

The eight production router/map/dependency files retain a VM-protected startup
boundary with the existing randomized opcode/handler mapping. Protected startup
unpacks a checksummed source payload and calls the native Luau compiler. The
outer and inner transport decoders run natively, yield between chunks, and keep
only bounded character lists before concatenation. Our VM no longer interprets
ongoing game or GUI callbacks or re-virtualizes embedded source literals.

This deliberately reduces interpreter overhead compared with the previous
full VM build. Runtime source/functions can be inspected by a capable executor;
client-side protection cannot guarantee secrecy. Checksums detect transport
corruption and do not provide cryptographic authentication.

Ride's original Lucy VM remains protected and byte-identical. The reviewed
wrapper was decompressed offline; its VM (85,896 bytes) and data (1,215,230 bytes)
are downloaded from a pinned commit and checked before execution. This is not
full devirtualization. Native GUI presentation adjusts branding; it does not
rewrite original gameplay. Steal an Egg retains its existing native constructor
export and unchanged original protected gameplay runtime.

Modified Fiu is pinned to 6cc8887847cf336073e5a8017330d3988844a62f, under MIT.
Every public protected artifact retains its copyright and license notice.
The private source, compiler, build scripts, opcode map and tests stay local.

Offline checks cover all eight native compiler boundaries, exact source bytes,
checksums, argument/return holes and yielding. Router tests cover all five maps;
the actual Loot host and its native embedded gameplay initialize and unload in
mocks. These tests do not measure live Roblox/Delta FPS.
