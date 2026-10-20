from pathlib import Path
import hashlib, json, re, subprocess

root = Path(__file__).resolve().parents[2]
here = Path(__file__).resolve().parent
native = (here / 'native-layer.generated.luau').read_text(encoding='utf-8')
manifest = json.loads((root / 'devil-chilli-native-ui-recovery.json').read_text())
assert hashlib.sha256(native.encode()).hexdigest() == manifest['adapted_native_sha256']
assert 'tienkhanh1/spicy/main/Chilli.lua' not in native

def literal(value):
    eq = '='
    while ']' + eq + ']' in value:
        eq += '='
    return '[' + eq + '[' + value + ']' + eq + ']'

queue = re.search(r'local Q,r="__ChilliAutoLoadScriptEnabled",\[==\[(.*?)\]==\];local function k\(\)', native, re.S)[1]
catalog = native.split('local function _(v)local s=S[v];',1)[1].split('local function F(R,S)',1)[0]
catalog = 'local function _(v)local s=S[v];' + catalog
redraw = native.split('local function zW(_W,vW)local IW=vW.Style;',1)[1].split('R(_W.Label,IW.Name);',1)[0]
redraw = 'local function redraw(_W,vW)local IW=vW.Style;' + redraw + 'end\n'
creation = re.search(r'F\[40\]=F\[19\].obj1;F\[40\].Enabled=false;F\[40\].Parent=F\[15\];',native)[0]
fixture = (root / 'tests/blue-gui-mocks.luau').read_text(encoding='utf-8')
fixture += '\nlocal makeArtwork=function()\n' + (here / 'panel-artwork.lua').read_text(encoding='utf-8') + '\nend\n'
fixture += '\nlocal themeSource=' + literal((root / 'devil-blue-gui.lua').read_text(encoding='utf-8')) + '\n'
fixture += 'local queuedSource=' + literal(queue) + '\nlocal catalogSource=' + literal(catalog) + '\n'
fixture += 'local redrawSource=' + literal(redraw) + '\nlocal createSource=' + literal(creation) + '\n'
fixture += (root / 'tests/steal-panel-rejoin.luau').read_text(encoding='utf-8')
path = here / 'panel-rejoin.generated.luau'
path.write_text(fixture, encoding='utf-8', newline='\n')
result = subprocess.run([str(root.parent / 'luau-tools/luau.exe'), str(path)], capture_output=True, text=True, encoding='utf-8', timeout=25)
print(result.stdout, end='')
if result.returncode:
    print(result.stderr, end='')
    result.check_returncode()
validation = {'release':manifest['release'],'live_game_verified':False,
    'runtime_sha256':manifest['source_sha256'],'game_bytecode_unchanged':manifest['game_bytecode_unchanged'],
    'result':result.stdout.strip(),'checks':sum(map(int,re.findall(r'(\d+) checks',result.stdout)))}
(root / 'devil-steal-panel-rejoin-validation.json').write_text(json.dumps(validation,indent=2)+'\n',encoding='utf-8',newline='\n')
