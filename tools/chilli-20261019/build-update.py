from pathlib import Path
import hashlib, json, lzma, re, struct, subprocess, urllib.request

ROOT = Path(__file__).resolve().parents[2]
WORK = Path(__file__).resolve().parent
LUAU = ROOT.parent / 'luau-tools/luau.exe'
COMPILER = ROOT.parent / 'luau-tools/luau-compile.exe'
UPSTREAM = '7b9215d199e43d7dda2569a8cf84477c77552630'
URL = f'https://raw.githubusercontent.com/tienkhanh1/Chilli-Hub-Script/{UPSTREAM}/StealAnEggg'
EXPECTED = '52812e88b260512c0362cd1085c2d830665b33675c67b92d0b168fa2577b6fa2'

def sha(data):
    return hashlib.sha256(data).hexdigest()

def checksum(data):
    value = 0
    for byte in data:
        value = (value * 33 + byte) % 4294967296
    return value

def decode(source, label):
    # Only the decompressor runs. Compiler interception prevents the VM/game code
    # from being compiled or invoked; the Luau CLI has no Roblox/network globals.
    capture = '''local function capture(code)
print("__STAGE_BEGIN__") print(code) print("__STAGE_END__")
return function(data)
print("__DATA_BEGIN__")
local text=buffer.tostring(data)
for i=1,#text,4096 do print((text:sub(i,i+4095):gsub(".",function(c)return string.format("%02x",string.byte(c))end)))end
print("__DATA_END__")
return function()end
end
end
'''
    assert source.count('[94]=loadstring') == 1
    path = WORK / (label + '.decode.luau')
    path.write_text(capture + source.replace('[94]=loadstring', '[94]=capture', 1), encoding='utf-8')
    result = subprocess.run([str(LUAU), str(path)], capture_output=True, check=True, timeout=45)
    text = result.stdout.decode('utf-8').replace('\r\n', '\n')
    vm = text.split('__STAGE_BEGIN__\n', 1)[1].split('\n__STAGE_END__', 1)[0]
    data = bytes.fromhex(text.split('__DATA_BEGIN__\n', 1)[1].split('\n__DATA_END__', 1)[0])
    return vm, data

original = urllib.request.urlopen(URL, timeout=30).read()
assert sha(original) == EXPECTED, 'Upstream pin/hash mismatch'
source = original.decode('utf-8').replace('\r\n', '\n')
native, game_data = decode(source, 'upstream')
(WORK / 'upstream-native.generated.luau').write_text(native, encoding='utf-8')
(WORK / 'upstream-game.generated.bin').write_bytes(game_data)
adapted = native
patches = []

def replace(before, after, count=1):
    global adapted
    assert adapted.count(before) == count, ('Changed/ambiguous anchor', before[:100])
    adapted = adapted.replace(before, after)
    patches.append((before, after, count))

replace('Q.Window=o;function l.ReflowTabs',
        'Q.Window=o;(type(getgenv)=="function"and getgenv()or _G).DevilChilliNativeWindow=o;function l.ReflowTabs')
replace('M.Name="ChilliHubLoading";M.ResetOnSpawn=false;',
        'M.Name="ChilliHubLoading";M.Enabled=false;M.ResetOnSpawn=false;')
replace('discord.gg/CJK4bs2mgT', 'discord.gg/fDwPCmpkkh', adapted.count('discord.gg/CJK4bs2mgT'))
replace('Text="<b>Chilli Hub</b>",Gradient=a', 'Text="<b>DEVIL HUB</b>",Gradient=a')
replace('"rbxassetid://128961717706452","180K+"',
        '((type(getgenv)=="function"and getgenv()or _G).DevilChilliBrandLogo or "https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png"),"180K+"')
replace('loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/refs/heads/main/DiscordLink"))()',
        'local copy=setclipboard or toclipboard;if type(copy)=="function"then copy("https://discord.gg/fDwPCmpkkh");end')
# Disable the upstream promotional mode before it creates controls or callbacks.
replace('return function()local E=G:CreateTab({Name="Venyx"',
        'return function()do return end;local E=G:CreateTab({Name="Venyx"')
# Preserve the existing blue Steal Panel header without modifying game actions.
replace('Rq.Color=I({{0,W(200,18,24)},{0.53,W(255,88,90)},{1,W(214,28,34)}});',
        'Rq.Color=I({{0,W(8,18,35)},{0.53,W(0,140,255)},{1,W(16,42,70)}});')
# Bound only presentation updates; keep movement, combat, farming and RPC cadence intact.
replace('local Lq=M[5].Heartbeat:Connect(function(Wq)',
        'local Lq=devilUiBeat(M[5].Heartbeat,Gy,function(Wq)')
replace('local g=M[5].Heartbeat:Connect(function(j)',
        'local g=devilUiBeat(M[5].Heartbeat,gq,function(j)')
replace('N[#N+1]=V.RenderStepped:Connect(function(B)if not(G.Enabled)',
        'N[#N+1]=devilUiBeat(V.RenderStepped,G,function(B)if not(G.Enabled)')

restored = adapted
for before, after, count in reversed(patches):
    assert restored.count(after) == count
    restored = restored.replace(after, before)
assert restored == native, 'Unexpected edits outside declared adaptation'

# Keep the original compiler, getfenv/setfenv, _G and bootstrap environment intact.
# Only request globals fetched by the game VM receive message-branding adapters.
vm_start = adapted.index('[9705]=function')
vm_end = adapted.index('end,[', vm_start) + len('end')
vm_section = adapted[vm_start:vm_end]
# This revision has six environment READ opcodes in this dispatcher. Do not
# wrap environment writes or the interpreter's own constant/register tables.
vm_section, request_lookup_count = re.subn(r'(L\[[^;=]+\]=)E\[([obwS]\[G\])\]',
    lambda m: m[1] + '(devilWebhookNames[' + m[2] + ']and devilWebhookLookup(' + m[2] + ',E[' + m[2] + '])or E[' + m[2] + '])', vm_section)
assert request_lookup_count == 6, 'Native global-read opcodes changed'
adapted = adapted[:vm_start] + vm_section + adapted[vm_end:]
helper = (WORK / 'webhook-branding.lua').read_text(encoding='utf-8')
adapted = ('local devilWebhookNames={request=true,http_request=true,httprequest=true,syn=true,http=true,fluxus=true}\n'
    'local devilWebhookLookup=(function()\n'+helper+'\nend)()()\n'
    'local devilUiBeat=(function()\n'+(WORK/'ui-performance.lua').read_text(encoding='utf-8')+'\nend)()\n'+adapted)


filters = [{'id': lzma.FILTER_LZMA1, 'lc': 3, 'lp': 0, 'pb': 0, 'dict_size': 1 << 24}]
compressed = lzma.compress(adapted.encode(), format=lzma.FORMAT_RAW, filters=filters)
padded = compressed + b'\0' * (-len(compressed) % 4)
encoded = []
for (word,) in struct.iter_unpack('<I', padded):
    digits = []
    for _ in range(5):
        digits.append(word % 85)
        word //= 85
    encoded.append(''.join(chr(digits[i] + 34) for i in [4, 2, 3, 1, 0]))
blocks = list(re.finditer(r'\[(=*)\[(.*?)\]\1\]', source, re.S))
assert len(blocks) == 2
runtime_block = blocks[0]
payload = runtime_block[2][:4] + ''.join(encoded)
eq = '='
while ']' + eq + ']' in payload:
    eq += '='
output = source[:runtime_block.start()] + '[' + eq + '[' + payload + ']' + eq + ']' + source[runtime_block.end():]
assert output.count('f(P,T,1264377)') == 1
output = output.replace('f(P,T,1264377)', f'f(P,T,{len(adapted.encode())})')
result_native, result_data = decode(output, 'candidate')
assert result_native == adapted
assert result_data == game_data, 'Game bytecode must be identical to upstream'
target = ROOT / 'devil-chilli-native-ui-runtime.lua'
target.write_text(output, encoding='utf-8', newline='\n')
(WORK / 'native-layer.generated.luau').write_text(adapted, encoding='utf-8')
subprocess.run([str(COMPILER), '--null', str(target)], check=True)
manifest = {
    'release': 'chilli-performance-20261021-1', 'upstream_commit': UPSTREAM,
    'features': ['Farm Monsters While Fishing', 'Fishing History',
        'Fishing/Treadmill rotation: Timer or Every Day', 'Teleport To Monsters',
        'Teleport To Pumpkins', 'Teleport To Ghosts', 'Continuous monster/pumpkin target loops'],
    'startup_policy': 'Retain rolled-back bootstrap/environment; no VM watchdog, yield injection, loader replacement, or native GUI quarantine',
    'upstream_url': URL, 'upstream_sha256': EXPECTED,
    'upstream_bytes': len(original), 'source_bytes': target.stat().st_size,
    'source_sha256': sha(target.read_bytes()), 'transfer_checksum': checksum(target.read_bytes()),
    'native_bytes': len(native.encode()), 'game_bytecode_bytes': len(game_data),
    'game_bytecode_sha256': sha(game_data), 'game_bytecode_unchanged': True,
    'native_ui_export_count': 1, 'native_patch_groups': len(patches), 'venyx_mode_disabled': True,
    'compression_roundtrip_verified': True, 'complete_vm_devirtualization': False,
    'live_verified': False, 'original_compiler_environment_preserved': True, 'request_lookup_sites': request_lookup_count,
    'vm_non_request_global_reads_skip_branding_call': True,
    'presentation_callbacks_throttled': 3, 'visible_ui_max_hz': 30, 'hidden_ui_max_hz': 4,
}
(ROOT / 'devil-chilli-native-ui-recovery.json').write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8')
print(json.dumps(manifest, indent=2))
