# Protection and native execution ? silver-native-1

The nine production router/map/dependency files retain a VM-protected startup
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

Ride A Fish now routes through the main loader to the pinned, protected
`aqua-auto-egg-18` entry. This release includes carried-egg inventory storage,
configured batch fish sales, selected Gear/Food purchases, aquarium skin
purchases with Tokens, and scoped Egg ESP. New systems start disabled and
purchase/sale selections start empty. Gameplay requests are based on the
available game-client dumps; upstream Ouroboros gameplay callbacks were not
devirtualized or copied from its FlowAuth runtime.
Auto Place Eggs in Fish Box equips a matching inventory egg only when an owned
box has capacity, then uses the existing validated deposit route. It works
with collection disabled and prevents inventory storage from reclaiming an
egg during placement. Egg inventory/placement workers check every 0.2 seconds;
confirmed placements advance without the previous two-second delay. Egg travel
settles for 0.15 seconds and retains position, cancellation and server-state
confirmation checks. Purchase/sale cooldowns remain unchanged.
Auto Rebirth checks fresh server requirements and confirms the resulting count.
The Aqua VM covers startup; farm and GUI callbacks execute natively.

Offline checks cover native compiler boundaries, exact source bytes,
checksums, argument/return holes and yielding. Router tests cover all six maps;
the actual Loot host and its native embedded gameplay initialize and unload in
mocks. These tests do not measure live Roblox/Delta FPS.
