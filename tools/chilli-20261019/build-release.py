"""Publish only Steal an Egg through the existing immutable dependency chain."""
from pathlib import Path
import hashlib, json, re, subprocess, sys
ROOT=Path(__file__).resolve().parents[2]
WORK=Path(__file__).resolve().parent
BUILD=ROOT.parent/'steal-chilli-build-20261019'
RELEASE='chilli-fishing-rotation-20261020-1'
mode,commit=sys.argv[1:3]
assert re.fullmatch('[0-9a-f]{40}',commit)
def gitfile(name):
    return subprocess.check_output(['git','show',commit+':'+name],cwd=ROOT)
def sha(value):return hashlib.sha256(value).hexdigest()
def checksum(value):
    total=0
    for byte in value:total=(total*33+byte)%4294967296
    return total
if mode=='delegate':
    entry=gitfile('devil-steal-an-egg-chilli-recovered-ui-test.lua')
    native='''local env=type(getgenv)=="function"and getgenv()or _G
if game.GameId~=10563114921 and game.PlaceId~=107778070777162 then
 local run,err=loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader?v=vm-1"))
 assert(run,err);return run(...)
end
if env.DevilChilliUiStarting or env.DevilChilliPresentation or env.DevilChilliMainUI then return env.DevilChilliMainUI end
local source=game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/GUI_COMMIT/devil-steal-an-egg-chilli-recovered-ui-test.lua")
assert(type(source)=="string"and #source==GUI_BYTES,"Pinned script download checksum mismatch or unexpected size")
local checksum=0
for i=1,#source do checksum=(checksum*33+source:byte(i))%4294967296;if i%32768==0 and task and task.wait then task.wait()end end
assert(checksum==GUI_CHECKSUM,"Pinned script download checksum mismatch")
local run,err=loadstring(source,"DEVIL HUB / Steal an Egg native UI")
assert(run,err);return run(...)
'''.replace('GUI_COMMIT',commit).replace('GUI_BYTES',str(len(entry))).replace('GUI_CHECKSUM',str(checksum(entry)))
    name='devil-steal-an-egg.lua'
    (WORK/'delegate.lua').write_text(native,encoding='utf-8',newline='\n')
    prefix=(ROOT/name).read_text(encoding='utf-8').split('-- END SHARED DEVIL BLUE GUI\n',1)[0]+'-- END SHARED DEVIL BLUE GUI\n'
    manifest={'release':RELEASE,'gui_commit':commit,'gui_bytes':len(entry),'gui_sha256':sha(entry),'gui_checksum':checksum(entry),'live_verified':False}
elif mode=='router':
    entry=gitfile('devil-steal-an-egg.lua')
    canonical=ROOT/'tools/blue-gui/router.lua'
    before=canonical.read_text(encoding='utf-8')
    audit=json.loads((ROOT/'devil-blue-gui-router-audit.json').read_text(encoding='utf-8'))
    assert sha(before.encode())==audit['after_native_sha256']
    source,count=re.subn(r'(^    \{Name="Steal an Egg"[^\n]*Commit=")[0-9a-f]+("[^\n]*Version=")[^"]+',lambda m:m[1]+commit+m[2]+RELEASE,before,flags=re.M)
    assert count==1
    source,count=re.subn(r'(entry.File=="devil-steal-an-egg.lua"and")[^"]+',lambda m:m[1]+RELEASE,source)
    assert count==1
    other=lambda s:re.findall(r'^    \{(?!Name="Steal an Egg")[^\n]+',s,re.M)
    assert other(source)==other(before) and len(other(source))==10
    canonical.write_text(source,encoding='utf-8',newline='\n')
    native=source;name='loader';prefix=''
else:raise ValueError(mode)
(BUILD/(name+'.native')).write_text(native,encoding='utf-8',newline='\n')
subprocess.run([sys.executable,str(BUILD/'build-router.py'),'--only',name,'--release',RELEASE],cwd=BUILD,check=True)
public=prefix.encode()+(BUILD/'candidate'/name).read_bytes()
(ROOT/name).write_bytes(public)
if mode=='delegate':
    manifest.update(delegate_bytes=len(public),delegate_sha256=sha(public),delegate_native_sha256=sha(native.encode()))
    (ROOT/'devil-steal-update-release.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8',newline='\n')
else:
    for row in audit['routes']:
        if row['File']=='devil-steal-an-egg.lua':row.update(Commit=commit,Version=RELEASE)
    audit.update(release=RELEASE,before_native_sha256=sha(before.encode()),after_native_sha256=sha(native.encode()),
                 public_loader_sha256=sha(public),public_loader_bytes=len(public),steal_entry_commit=commit,
                 steal_entry_sha256=sha(entry),non_steal_routes_unchanged=True)
    (ROOT/'devil-blue-gui-router-audit.json').write_text(json.dumps(audit,indent=2)+'\n',encoding='utf-8',newline='\n')
    manifest=json.loads((ROOT/'devil-steal-update-release.json').read_text())
    manifest.update(delegate_commit=commit,main_loader_sha256=sha(public),other_game_routes_unchanged=True)
    (ROOT/'devil-steal-update-release.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8',newline='\n')
print('PASS built',mode,commit)
