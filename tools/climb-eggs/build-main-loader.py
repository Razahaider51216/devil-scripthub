from pathlib import Path
import hashlib,json,re,subprocess,sys
ROOT=Path(__file__).resolve().parents[2]
BUILD=ROOT.parent/'steal-chilli-build-20261019'
commit=sys.argv[1];assert re.fullmatch('[0-9a-f]{40}',commit)
entry=subprocess.check_output(['git','show',commit+':climb-for-eggs.lua'],cwd=ROOT)
manifest=json.loads(subprocess.check_output(['git','show',commit+':climb-eggs-release.json'],cwd=ROOT))
assert hashlib.sha256(entry).hexdigest()==manifest['entry_sha256']
canonical=ROOT/'tools/blue-gui/router.lua';before=canonical.read_text(encoding='utf-8')
audit=json.loads((ROOT/'devil-blue-gui-router-audit.json').read_text())
assert hashlib.sha256(before.encode()).hexdigest()==audit['after_native_sha256']
source,count=re.subn(r'(^    \{Name="Climb for Eggs"[^\n]*Commit=")[0-9a-f]+("[^\n]*Version=")[^"]+',lambda m:m[1]+commit+m[2]+manifest['release'],before,flags=re.M)
assert count==1
source,count=re.subn(r'(entry.File=="climb-for-eggs.lua"and")[^"]+',lambda m:m[1]+manifest['release'],source)
assert count==1
other=lambda s:re.findall(r'^    \{(?!Name="Climb for Eggs")[^\n]+',s,re.M)
assert other(source)==other(before)and len(other(source))==len(audit['routes'])-1
baseline_commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip()
assert subprocess.check_output(['git','show',baseline_commit+':tools/blue-gui/router.lua'],cwd=ROOT).decode()==before
old_row=re.search(r'^    \{Name="Climb for Eggs"[^\n]+',before,re.M)[0]
new_row=re.search(r'^    \{Name="Climb for Eggs"[^\n]+',source,re.M)[0]
old_version=re.search(r'entry.File=="climb-for-eggs.lua"and"([^"]+)"',before)[1]
assert source.replace(new_row,old_row,1).replace('entry.File=="climb-for-eggs.lua"and"'+manifest['release']+'"','entry.File=="climb-for-eggs.lua"and"'+old_version+'"',1)==before
canonical.write_text(source,encoding='utf-8',newline='\n')
(BUILD/'loader.native').write_text(source,encoding='utf-8',newline='\n')
subprocess.run([sys.executable,str(BUILD/'build-router.py'),'--only','loader','--release',manifest['release']],cwd=BUILD,check=True)
public=(BUILD/'candidate/loader').read_bytes();(ROOT/'loader').write_bytes(public)
for row in audit['routes']:
 if row['File']=='climb-for-eggs.lua':row.update(Commit=commit,Version=manifest['release'])
previous_sha=audit['public_loader_sha256']
audit.update(release=manifest['release'],before_native_sha256=hashlib.sha256(before.encode()).hexdigest(),after_native_sha256=hashlib.sha256(source.encode()).hexdigest(),public_loader_sha256=hashlib.sha256(public).hexdigest(),public_loader_bytes=len(public),climb_entry_commit=commit,climb_entry_sha256=manifest['entry_sha256'],non_climb_routes_unchanged=True,climb_router_baseline_commit=baseline_commit)
(ROOT/'devil-blue-gui-router-audit.json').write_text(json.dumps(audit,indent=2)+'\n',encoding='utf-8',newline='\n')
manifest.update(runtime_commit=commit,main_loader_sha256=hashlib.sha256(public).hexdigest(),other_routes_unchanged=True)
(ROOT/'climb-eggs-release.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8',newline='\n')
for filename in ['anime-dice-test-release.json','devilv4-test-release.json','devil-steal-update-release.json']:
 path=ROOT/filename;metadata=json.loads(path.read_text())
 if metadata.get('main_loader_sha256')==previous_sha:
  metadata['main_loader_sha256']=audit['public_loader_sha256']
  path.write_text(json.dumps(metadata,indent=2)+'\n',encoding='utf-8',newline='\n')
print('PASS Climb main loader pin/version; all other router entries preserved')
