# Devil Hub VM release vm-1

The universal loader and all production files used by its four game routes are
distributed through a Luau bytecode interpreter:

- Ride a Pet: ride-a-pet.lua and ride-a-pet-delta.lua.
- Break and Steal an Egg: break-and-steal-an-egg.lua and its runtime.
- Loot to Forge: loot-to-forge.lua, retaining the latest Get Roll labels and
  multiple rarity stopping selections.
- Build An Ant Empire: build-an-ant-empire.lua.
- Universal entry: loader.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader?v=ride-vm-2"))()
```

This is bytecode virtualization rather than only source-string packing. The
private build compiles 14 layers with debug information removed, including
embedded game sources and the existing startup wrappers. Instruction opcode
bytes use a per-build permutation; dispatch uses separately randomized handler
IDs. Encoded payloads have size/checksum verification. Checksums detect damage;
they are not cryptographic authentication. The bootstrapping interpreter is
encoded separately and bundled locally in each artifact, with no additional
interpreter download or external obfuscation service.

The interpreter is a modified, pinned [Fiu](https://github.com/rce-incorporated/Fiu/tree/6cc8887847cf336073e5a8017330d3988844a62f), under its MIT license.
Each release includes the required copyright and license notice. It supports
the compiler's bytecode version 14. VM execution needs the standard Luau buffer,
bit32 and table APIs, plus the executor APIs already required by each game.

Local validation compiles all seven artifacts, executes the public universal
loader across all four mappings, and exercises retries, argument forwarding,
unsupported/duplicate load rejection and six entry files redirecting across
maps. The full public Loot artifact is tested with its actual host and nested
VM, including the 66 controls, multiple rarity selections, configuration,
spawners and cleanup. Its game source is not passed as readable Lua to native
loadstring. Break Egg's gameplay regression suite also runs through this VM.

VM execution adds CPU and memory overhead. Ride a Pet's original Luraph-protected
payload now uses the native compiler, avoiding interpreting its VM inside Fiu.
The protected payload remains byte-identical; DEVIL HUB loader/GUI code keeps its
outer VM. This Ride-only startup correction and version-query update do not
replace other published gameplay artifacts. Real-device startup time and gameplay
performance require in-game verification. These checks use API mocks and do
not establish live executor compatibility for every device.

Client-executed code can still be inspected, dumped or reverse-engineered. The
payload encoding, opcode permutation and VM increase inspection effort but do
not guarantee secrecy. Existing public Git history is unchanged. This release
does not add a key system, telemetry, debugger blocking or gameplay features.

Readable build inputs, exact native release backups and VM tooling remain local
at C:/Users/Administrator/Documents/script/devil-vm-build. Public files are
release artifacts; future gameplay updates must regenerate the VM release from
the private source baseline instead of editing the public VM files.
