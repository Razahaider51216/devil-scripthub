from pathlib import Path
import hashlib, json, lzma, re, struct, subprocess, urllib.request

ROOT = Path(__file__).resolve().parents[2]
WORK = Path(__file__).resolve().parent
LUAU = ROOT.parent / 'luau-tools/luau.exe'
COMPILER = ROOT.parent / 'luau-tools/luau-compile.exe'
UPSTREAM = '03468a41b2ecf2d983b39993ba603c943c140f4f'
URL = f'https://raw.githubusercontent.com/tienkhanh1/Chilli-Hub-Script/{UPSTREAM}/StealAnEggg'
EXPECTED = '7a9695a6cf5844852b59da7e527ea66c753de71fd633cb90a4e287313fdf7113'

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
    assert source.count('[76]=loadstring') == 1
    path = WORK / (label + '.decode.luau')
    path.write_text(capture + source.replace('[76]=loadstring', '[76]=capture', 1), encoding='utf-8')
    result = subprocess.run([str(LUAU), str(path)], capture_output=True, check=True, timeout=45)
    text = result.stdout.decode('utf-8').replace('\r\n', '\n')
    vm = text.split('__STAGE_BEGIN__\n', 1)[1].split('\n__STAGE_END__', 1)[0]
    data = bytes.fromhex(text.split('__DATA_BEGIN__\n', 1)[1].split('\n__DATA_END__', 1)[0])
    return vm, data

original = urllib.request.urlopen(URL, timeout=30).read()
assert sha(original) == EXPECTED, 'Upstream pin/hash mismatch'
source = original.decode('utf-8').replace('\r\n', '\n')
native, game_data = decode(source, 'upstream')
adapted = native
patches = []

def replace(before, after, count=1):
    global adapted
    assert adapted.count(before) == count, ('Changed/ambiguous anchor', before[:100])
    adapted = adapted.replace(before, after)
    patches.append((before, after, count))

replace('h.Window=P;function S.ReflowTabs',
        'h.Window=P;(type(getgenv)=="function"and getgenv()or _G).DevilChilliNativeWindow=P;function S.ReflowTabs')
replace('F.Name="ChilliHubLoading";F.ResetOnSpawn=false;',
        'F.Name="ChilliHubLoading";F.Enabled=false;F.ResetOnSpawn=false;')
replace('discord.gg/CJK4bs2mgT', 'discord.gg/fDwPCmpkkh', adapted.count('discord.gg/CJK4bs2mgT'))
replace('Text="<b>Chilli Hub</b>",Gradient=J', 'Text="<b>DEVIL HUB</b>",Gradient=J')
replace('"rbxassetid://128961717706452","180K+"',
        '((type(getgenv)=="function"and getgenv()or _G).DevilChilliBrandLogo or "https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png"),"180K+"')
replace('loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/refs/heads/main/DiscordLink"))()',
        'local copy=setclipboard or toclipboard;if type(copy)=="function"then copy("https://discord.gg/fDwPCmpkkh");end')
# Preserve the existing blue Steal Panel header without modifying game actions.
replace('IW.Color=A({{0,T(200,18,24)},{0.53,T(255,88,90)},{1,T(214,28,34)}});',
        'IW.Color=A({{0,T(8,18,35)},{0.53,T(0,140,255)},{1,T(16,42,70)}});')

restored = adapted
for before, after, count in reversed(patches):
    assert restored.count(after) == count
    restored = restored.replace(after, before)
assert restored == native, 'Unexpected edits outside declared adaptation'

filters = [{'id': lzma.FILTER_LZMA1, 'lc': 3, 'lp': 0, 'pb': 0, 'dict_size': 1 << 24}]
compressed = lzma.compress(adapted.encode(), format=lzma.FORMAT_RAW, filters=filters)
padded = compressed + b'\0' * (-len(compressed) % 4)
encoded = []
for (word,) in struct.iter_unpack('<I', padded):
    digits = []
    for _ in range(5):
        digits.append(word % 85)
        word //= 85
    encoded.append(''.join(chr(digits[i] + 32) for i in [4, 0, 1, 3, 2]))
blocks = list(re.finditer(r'\[(=*)\[(.*?)\]\1\]', source, re.S))
assert len(blocks) == 2
runtime_block = blocks[0]
payload = runtime_block[2][:4] + ''.join(encoded)
eq = '='
while ']' + eq + ']' in payload:
    eq += '='
output = source[:runtime_block.start()] + '[' + eq + '[' + payload + ']' + eq + ']' + source[runtime_block.end():]
assert output.count('Z(m,H,1285437)') == 1
output = output.replace('Z(m,H,1285437)', f'Z(m,H,{len(adapted.encode())})')
result_native, result_data = decode(output, 'candidate')
assert result_native == adapted
assert result_data == game_data, 'Game bytecode must be identical to upstream'
target = ROOT / 'devil-chilli-native-ui-runtime.lua'
target.write_text(output, encoding='utf-8', newline='\n')
subprocess.run([str(COMPILER), '--null', str(target)], check=True)
manifest = {
    'release': 'chilli-halloween-20261019', 'upstream_commit': UPSTREAM,
    'upstream_url': URL, 'upstream_sha256': EXPECTED,
    'upstream_bytes': len(original), 'source_bytes': target.stat().st_size,
    'source_sha256': sha(target.read_bytes()), 'transfer_checksum': checksum(target.read_bytes()),
    'native_bytes': len(native.encode()), 'game_bytecode_bytes': len(game_data),
    'game_bytecode_sha256': sha(game_data), 'game_bytecode_unchanged': True,
    'native_ui_export_count': 1, 'presentation_patch_groups': len(patches),
    'compression_roundtrip_verified': True, 'complete_vm_devirtualization': False,
    'live_verified': False,
}
(ROOT / 'devil-chilli-native-ui-recovery.json').write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8')
print(json.dumps(manifest, indent=2))

