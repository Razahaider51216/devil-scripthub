"""Offline contract checks. Never invoke the protected game VM or Roblox remotes."""
from pathlib import Path
import hashlib, json, subprocess
ROOT = Path(__file__).resolve().parents[2]
WORK = Path(__file__).resolve().parent
native = (WORK / 'native-layer.generated.luau').read_text(encoding='utf-8')
upstream = (WORK / 'upstream-native.generated.luau').read_text(encoding='utf-8')
manifest = json.loads((ROOT / 'devil-chilli-native-ui-recovery.json').read_text())
assert hashlib.sha256((ROOT / 'devil-chilli-native-ui-runtime.lua').read_bytes()).hexdigest() == manifest['source_sha256']
assert hashlib.sha256((WORK / 'upstream-game.generated.bin').read_bytes()).hexdigest() == manifest['game_bytecode_sha256']
for text in ['Farm Monsters While Fishing', 'Fishing History', 'Rotate Fishing And Treadmill',
             'Rotation Switch', 'Options={"Timer","Every Day"}', 'Fishing Minutes', 'Treadmill Minutes',
             'Teleport To Monsters', 'Teleport To Pumpkins', 'Teleport To Ghosts',
             'Cast done, farming monsters until the bite', 'k.rotToggle=function']:
    assert text in native and text in upstream, text
assert 'while dq()and not k.better(Lq)and(U(dq,aq))do v();' in native
assert 'while H()and not k.better(a)and(R(H))do v();' in native
# Pull actual latest option public methods; mock only Roblox widgets/services.
methods=[]
for number in (29,30,81,82):
    begin=native.index(f'Hq[{number}]=function')
    end=native.index(';Hq[',begin)
    methods.append(native[begin:end].replace('Hq[','ApiImpl[').replace('Uq(', 'assertObject(')+';')
fixture=(WORK / 'test-bridge.fixture.luau').read_text(encoding='utf-8')
fixture=fixture.replace('__LATEST_OPTION_METHODS__',''.join(methods))
fixture=fixture.replace('__CURRENT_BRIDGE__',(WORK / 'bridge.lua').read_text(encoding='utf-8'))
assert '__LATEST_OPTION_METHODS__' not in fixture and '__CURRENT_BRIDGE__' not in fixture
path=WORK / 'test-integration.generated.luau'
path.write_text(fixture,encoding='utf-8')
subprocess.run([str(ROOT.parent/'luau-tools/luau.exe'),str(path)],check=True)
# The exported constructor itself, extracted from the adapted runtime.
begin=native.index('Hq[106]=function');end=native.index(';(function()',begin)
constructor=native[begin:end]
test='''local env={};local getgenv=function()return env end
local Eq=function(config)return config end;local P={};local l={}
local Hq={[95]=function(window,name)return {Window=window,Name=name}end,[93]=function(window)window.Reflowed=true end}
'''+constructor+'''
local library={};local window=Hq[106](library,{Name="DEVIL HUB"})
assert(env.DevilChilliNativeWindow==window and library.Window==window)
assert(window._kind=="Window" and #window.Tabs==0 and type(window.States)=="table")
assert(window.DefaultTab.Window==window)
l.ReflowTabs();assert(window.Reflowed)
assert(not pcall(Hq[106],library,{}),'duplicate native window accepted')
print("PASS actual latest constructor: export, ownership, state, default tab, reflow, duplicate guard")
'''
path=WORK/'test-constructor.generated.luau';path.write_text(test,encoding='utf-8')
subprocess.run([str(ROOT.parent/'luau-tools/luau.exe'),str(path)],check=True)
print('PASS latest feature declarations, continuous monster/pumpkin loops, runtime/data integrity; live gameplay unverified')
