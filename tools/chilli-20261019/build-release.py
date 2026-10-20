"""Pin the fixed frontend, then update only Steal an Egg in the main router."""
from pathlib import Path
import hashlib, json, re, subprocess, sys

root = Path(__file__).resolve().parents[2]
build = root.parent / 'steal-chilli-build-20261019'
mode, commit = sys.argv[1:3]
assert re.fullmatch('[0-9a-f]{40}', commit)
release = 'steal-startup-vm-20261020-5'
manifest_path = root / 'devil-steal-panel-rejoin-release.json'

def blob(name):
    return subprocess.check_output(['git','show',commit+':'+name],cwd=root)

def checksum(data):
    value = 0
    for byte in data:
        value = (value*33+byte)%4294967296
    return value

if mode == 'delegate':
    gui = blob('devil-steal-an-egg-chilli-recovered-ui-test.lua')
    source = '''local env=type(getgenv)=="function"and getgenv()or _G
if game.GameId~=10563114921 and game.PlaceId~=107778070777162 then
    local run,err=loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader?v=vm-1"))
    assert(run,err);return run(...)
end
if env.DevilChilliUiStarting or env.DevilChilliMainUI then return env.DevilChilliMainUI end
local loadPinnedSource=(function()
PINNED_SOURCE_HELPER
end)()
local source=loadPinnedSource("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/GUI_COMMIT/devil-steal-an-egg-chilli-recovered-ui-test.lua",GUI_SIZE,GUI_CHECKSUM,"DevilHub_StealGUI_GUI_COMMIT.lua")
local run,err=loadstring(source,"DEVIL HUB / Steal an Egg native UI")
assert(run,err);return run(...)
'''.replace('GUI_COMMIT',commit).replace('GUI_SIZE',str(len(gui))).replace('GUI_CHECKSUM',str(checksum(gui))).replace('PINNED_SOURCE_HELPER',(Path(__file__).parent/'pinned-source.lua').read_text(encoding='utf-8'))
    filename = 'devil-steal-an-egg.lua'
    manifest = {'release':release,'gui_commit':commit,'gui_sha256':hashlib.sha256(gui).hexdigest(),
        'runtime_commit':re.search(rb'/([0-9a-f]{40})/devil-chilli-native-ui-runtime.lua',gui)[1].decode(),
        'live_game_verified':False,'game_bytecode_unchanged':True}
elif mode == 'router':
    manifest = json.loads(blob(manifest_path.name))
    assert hashlib.sha256(blob('devil-steal-an-egg.lua')).hexdigest() == manifest['delegate_sha256']
    audit_path = root / 'devil-blue-gui-router-audit.json'
    audit = json.loads(audit_path.read_text(encoding='utf-8'))
    native = root / 'tools/blue-gui/router.lua'
    before = native.read_text(encoding='utf-8')
    assert hashlib.sha256(before.encode()).hexdigest() == audit['after_native_sha256']
    route = next(r for r in audit['routes'] if r['File']=='devil-steal-an-egg.lua')
    old_version = re.search(r'entry.File=="devil-steal-an-egg.lua"and"([^"]+)"',before)[1]
    source, count = re.subn(r'^    \{Name="Steal an Egg"[^\n]+',
        lambda _: '    {Name="Steal an Egg",Universe=10563114921,Place=107778070777162,File="devil-steal-an-egg.lua",Commit="'+commit+'",Version="'+release+'"},',before,flags=re.M)
    assert count == 1
    anchor = 'entry.File=="devil-steal-an-egg.lua"and"'+old_version+'"'
    assert source.count(anchor)==1
    source = source.replace(anchor,'entry.File=="devil-steal-an-egg.lua"and"'+release+'"')
    early = ('-- BEGIN EARLY STEAL UI GUARD\nif selected.File=="devil-steal-an-egg.lua"then\n'
        'local install=(function()\n'+(Path(__file__).parent/'startup-guard.lua').read_text(encoding='utf-8')+
        '\nend)()\ninstall()\nend\n-- END EARLY STEAL UI GUARD\n')
    if '-- BEGIN EARLY STEAL UI GUARD\n' in source:
        source,count=re.subn(r'-- BEGIN EARLY STEAL UI GUARD\n.*?-- END EARLY STEAL UI GUARD\n',lambda _:early,source,flags=re.S)
        assert count==1
    else:
        marker='-- BEGIN DEVIL AUTO EXECUTE\n'
        assert source.count(marker)==1
        source=source.replace(marker,early+marker,1)
    assert re.findall(r'^    \{(?!Name="Steal an Egg")[^\n]+',before,re.M)==re.findall(r'^    \{(?!Name="Steal an Egg")[^\n]+',source,re.M)
    native.write_text(source,encoding='utf-8',newline='\n')
    route.update(Commit=commit,Version=release)
    filename = 'loader'
else:
    raise ValueError(mode)

(build / (filename+'.native')).write_text(source,encoding='utf-8',newline='\n')
subprocess.run([sys.executable,str(build/'build-router.py'),'--only',filename,'--release',release],cwd=build,check=True)
public = (build/'candidate'/filename).read_bytes()
# Preserve the shared theme prelude on the direct delegate as well.
if mode == 'delegate':
    current = (root/filename).read_text(encoding='utf-8')
    prefix = current.split('-- END SHARED DEVIL BLUE GUI\n',1)[0]+'-- END SHARED DEVIL BLUE GUI\n'
    public = prefix.encode()+public
    manifest['delegate_sha256'] = hashlib.sha256(public).hexdigest()
else:
    audit.update(release=release,before_native_sha256=hashlib.sha256(before.encode()).hexdigest(),
        after_native_sha256=hashlib.sha256(source.encode()).hexdigest(),public_loader_sha256=hashlib.sha256(public).hexdigest(),
        public_loader_bytes=len(public),steal_panel_entry_commit=commit,non_steal_routes_unchanged=True)
    audit_path.write_text(json.dumps(audit,indent=2)+'\n',encoding='utf-8',newline='\n')
    manifest.update(main_loader_entry_commit=commit,main_loader_sha256=hashlib.sha256(public).hexdigest())
    test = root / 'tools/chilli-20261019/test-public-loader.py'
    text = test.read_text(encoding='utf-8')
    text,count = re.subn(r'/[0-9a-f]{40}/devil-steal-an-egg.lua\?hub=[^"\\]+',
        lambda _: '/'+commit+'/devil-steal-an-egg.lua?hub='+release,text)
    assert count==1
    test.write_text(text,encoding='utf-8',newline='\n')
(root/filename).write_bytes(public)
manifest_path.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8',newline='\n')
print('PASS built',filename,'pin',commit)
