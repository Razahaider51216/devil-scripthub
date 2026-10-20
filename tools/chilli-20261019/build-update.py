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

cached = ROOT / 'analysis/chilli-20261019/StealAnEggg.original.lua'
original = cached.read_bytes() if cached.is_file() and sha(cached.read_bytes()) == EXPECTED else urllib.request.urlopen(URL, timeout=30).read()
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
# Disable the native menu BEFORE parenting, so no upstream window can render
# during the handoff to DEVIL HUB, including a rejoin into a fresh client.
replace('F[40]=F[19].obj1;F[40].Parent=F[15];',
        'F[40]=F[19].obj1;F[40].Enabled=false;devilKeepNativeHidden(F[40]);F[40].Parent=F[15];')
# Replace the old loading widget with the same progress/hold API and no GUI.
loading_start = adapted.index('[117]=function')
loading_end = adapted.index('end,[', loading_start) + len('end')
replace(adapted[loading_start:loading_end],
        '[117]=function(N,N,N,N)return function()return devilNativeLoading;end;end')
# The native auto-load queue used to download Chilli.lua independently of our
# main loader. Share its destination guard with the always-enabled hub queue.
queue_match = re.search(r'local Q,r="__ChilliAutoLoadScriptEnabled",("(?:\\.|[^"\\])*");local function k\(\)', adapted)
assert queue_match, 'Native auto-load payload anchor changed'
common = (ROOT / 'tools/auto-execute/bootstrap.lua').read_text(encoding='utf-8')
arrival = common.split('local payload=[==[\n', 1)[1].split('\n]==]', 1)[0]
queued = ('local enabled=true\n'
          'pcall(function()enabled=game:GetService("TeleportService"):GetTeleportSetting("__ChilliAutoLoadScriptEnabled")==true end)\n'
          'if enabled then\n' + arrival + '\nend\n')
replace(queue_match[1], '[==[' + queued + ']==]')
replace('discord.gg/CJK4bs2mgT', 'discord.gg/fDwPCmpkkh', adapted.count('discord.gg/CJK4bs2mgT'))
replace('Text="<b>Chilli Hub</b>",Gradient=J', 'Text="<b>DEVIL HUB</b>",Gradient=J')
replace('"rbxassetid://128961717706452","180K+"',
        '((type(getgenv)=="function"and getgenv()or _G).DevilChilliBrandLogo or "https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png"),"180K+"')
replace('loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/refs/heads/main/DiscordLink"))()',
        'local copy=setclipboard or toclipboard;if type(copy)=="function"then copy("https://discord.gg/fDwPCmpkkh");end')
# Disable the upstream promotional mode before it creates controls or callbacks.
replace('return function()local N;local N=Q;local U,t,r,k,h,P,c,X,x=N:CreateTab({Name="Venyx"',
        'return function()do return end;local N;local N=Q;local U,t,r,k,h,P,c,X,x=N:CreateTab({Name="Venyx"')
# Preserve the existing blue Steal Panel header without modifying game actions.
replace('IW.Color=A({{0,T(200,18,24)},{0.53,T(255,88,90)},{1,T(214,28,34)}});',
        'IW.Color=A({{0,T(8,18,35)},{0.53,T(0,140,255)},{1,T(16,42,70)}});')
replace('uW.BadgeGradient=uW.Badge and uW.Badge:FindFirstChildOfClass("UIGradient")or nil;',
        'uW.Icon=devilStealArtwork(fW,uW.Icon);uW.BadgeGradient=uW.Badge and uW.Badge:FindFirstChildOfClass("UIGradient")or nil;')
replace('D=i:FindFirstChild("ImageLabel");',
        'D=devilStealArtwork(i,i:FindFirstChild("ImageLabel")or i:FindFirstChild("Icon"),true);')
# Retry a catalog entry whose artwork was not ready when the first row appeared.
replace('local function _(v)local s=S[v];if s then return s;end;',
        'local function _(v)local s=S[v];if s and s.Icon~=""then return s;end;')
replace('local function zW(_W,vW)local IW=vW.Style;if _W.Category~=vW.Category then',
        'local function zW(_W,vW)local IW=vW.Style;if _W.Category~=vW.Category or(_W.Icon and _W.Icon.Image~=IW.Icon)then')

restored = adapted
for before, after, count in reversed(patches):
    assert restored.count(after) == count
    restored = restored.replace(after, before)
assert restored == native, 'Unexpected edits outside declared adaptation'

# Keep the original compiler, getfenv/setfenv, _G and bootstrap environment intact.
# Only request globals fetched by the game VM receive message-branding adapters.
vm_start = adapted.index('[4201]=function')
vm_end = adapted.index('end,[', vm_start) + len('end')
vm_section = adapted[vm_start:vm_end]
vm_section, request_lookup_count = re.subn(r'B\[((?:c|P|F)\[Y\])\]',
    lambda m: 'devilWebhookLookup(' + m[1] + ',B[' + m[1] + '])', vm_section)
assert request_lookup_count == 8, 'Native global-lookup sites changed'
adapted = adapted[:vm_start] + vm_section + adapted[vm_end:]
helper = (WORK / 'webhook-branding.lua').read_text(encoding='utf-8')
adapted = 'local devilWebhookLookup=(function()\n' + helper + '\nend)()()\n' + adapted
artwork = (WORK / 'panel-artwork.lua').read_text(encoding='utf-8')
adapted = 'local devilStealArtwork=(function()\n' + artwork + '\nend)()\n' + adapted
for variable,filename in [('devilNativeLoading','native-loading.lua'),('devilKeepNativeHidden','native-visibility.lua')]:
    adapted = 'local ' + variable + '=(function()\n' + (WORK / filename).read_text(encoding='utf-8') + '\nend)()\n' + adapted
(WORK / 'native-layer.generated.luau').write_text(adapted, encoding='utf-8', newline='\n')


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
slice_source = (WORK / 'startup-slice.lua').read_text(encoding='utf-8')
decode_anchor = 'm[59],1;while true do local z;'
assert output.count(decode_anchor) == 1
output = output.replace(decode_anchor,'m[59],1;local devilDecodeTicks=0;while true do devilDecodeTicks+=1;if devilDecodeTicks%1024==0 then devilStartupSlice()end;local z;')
lzma_anchor = 'while e<a do if D(q,h)==0 then'
assert output.count(lzma_anchor) == 1
output = slice_source + '\n' + output.replace(lzma_anchor,'local devilNextSlice=0;while e<a do if e>=devilNextSlice then devilNextSlice=e+8192;devilStartupSlice()end;if D(q,h)==0 then')
result_native, result_data = decode(output, 'candidate')
assert result_native == adapted
assert result_data == game_data, 'Game bytecode must be identical to upstream'
target = ROOT / 'devil-chilli-native-ui-runtime.lua'
target.write_text(output, encoding='utf-8', newline='\n')
subprocess.run([str(COMPILER), '--null', str(target)], check=True)
manifest = {
    'release': 'steal-panel-startup-20261020-2', 'upstream_commit': UPSTREAM,
    'upstream_url': URL, 'upstream_sha256': EXPECTED,
    'upstream_bytes': len(original), 'source_bytes': target.stat().st_size,
    'source_sha256': sha(target.read_bytes()), 'transfer_checksum': checksum(target.read_bytes()),
    'native_bytes': len(native.encode()), 'game_bytecode_bytes': len(game_data),
    'game_bytecode_sha256': sha(game_data), 'game_bytecode_unchanged': True,
    'native_ui_export_count': 1, 'native_patch_groups': len(patches), 'venyx_mode_disabled': True,
    'compression_roundtrip_verified': True, 'complete_vm_devirtualization': False,
    'live_verified': False, 'original_compiler_environment_preserved': True, 'request_lookup_sites': request_lookup_count,
    'native_menu_hidden_before_parenting': True, 'queued_loader_is_devil_hub': True,
    'shared_auto_execute_arrival_guard': True, 'pet_artwork_preserved_before_name_randomization': True,
    'artwork_sha256': sha(artwork.encode()),
    'adapted_native_sha256': sha(adapted.encode()),
    'steal_launcher_icon_supported':True,'native_loading_widget_removed':True,
    'native_visibility_lock':True,'cooperative_decompression':True,
}
(ROOT / 'devil-chilli-native-ui-recovery.json').write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8')
print(json.dumps(manifest, indent=2))
