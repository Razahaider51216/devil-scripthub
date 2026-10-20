"""Add Dig For Eggs with an immutable entry pin; preserve all existing router code."""
from pathlib import Path
import hashlib, json, re, subprocess, sys

ROOT=Path(__file__).resolve().parents[2]
BUILD=ROOT.parent/'steal-chilli-build-20261019'
BASE='a381f1d700cc6abb5b1317f8cbc6d63d4f888bd8'
commit=sys.argv[1]
assert re.fullmatch('[0-9a-f]{40}',commit)
entry=subprocess.check_output(['git','show',commit+':devilv4-test.lua'],cwd=ROOT)
release=json.loads(subprocess.check_output(['git','show',commit+':devilv4-test-release.json'],cwd=ROOT))
assert hashlib.sha256(entry).hexdigest()==release['entry_sha256']
assert entry==(ROOT/'devilv4-test.lua').read_bytes()
baseline=subprocess.check_output(['git','show',BASE+':tools/blue-gui/router.lua'],cwd=ROOT).decode()
before=(ROOT/'tools/blue-gui/router.lua').read_text(encoding='utf-8')
audit_path=ROOT/'devil-blue-gui-router-audit.json'
audit=json.loads(audit_path.read_text(encoding='utf-8'))
assert hashlib.sha256(before.encode()).hexdigest()==audit['after_native_sha256']
# Rebuild deterministically from the reviewed baseline; only the entry pin changes.
row=dict(Name='Dig For Eggs',Universe=10765013362,Place=121831322352666,
         File='devilv4-test.lua',Commit=commit,Version=release['release'])
route=('    {Name="Dig For Eggs",Universe=10765013362,Place=121831322352666,'
       f'File="devilv4-test.lua",Commit="{commit}",Version="{release["release"]}"}},\n')
override=('-- Dig For Eggs keeps its own release after the legacy version normalizer.\n'
          'for _,entry in ipairs(games)do if entry.File=="devilv4-test.lua"then '
          f'entry.Version="{release["release"]}"end end\n')
guard='''if selected.File=="devilv4-test.lua"then
    local app=env.DevilV4Test
    if app and not app.Stopped and app.Version==selected.Version then return app end
    if type(env.DevilV4Starting)=="number"and os.clock()-env.DevilV4Starting<30 then return end
end
'''
if before!=baseline:
    previous=re.sub(r'^    \{Name="Dig For Eggs"[^\n]+\n','',before,count=1,flags=re.M)
    previous=re.sub(r'-- Dig For Eggs keeps its own release after the legacy version normalizer\.\nfor _,entry in ipairs\(games\)do if entry.File=="devilv4-test.lua"then entry.Version="[^"\n]+"end end\n','',previous,count=1)
    previous=previous.replace(guard,'',1).replace('Anime Dice, and Dig For Eggs. This map','and Anime Dice. This map',1)
    assert previous==baseline,'Existing router changed; review and advance the baseline before rebuilding'
source=baseline.replace('local games={\n','local games={\n'+route,1)
source=source.replace('if not game:IsLoaded()then game.Loaded:Wait()end',override+'if not game:IsLoaded()then game.Loaded:Wait()end',1)
source=source.replace('and Anime Dice. This map','Anime Dice, and Dig For Eggs. This map',1)
source=source.replace('assert(type(loadstring)=="function"',guard+'assert(type(loadstring)=="function"',1)
restored=source.replace(route,'',1).replace(override,'',1).replace(guard,'',1).replace('Anime Dice, and Dig For Eggs. This map','and Anime Dice. This map',1)
assert restored==baseline,'Unrelated router code changed'
(ROOT/'tools/blue-gui/router.lua').write_text(source,encoding='utf-8',newline='\n')
(BUILD/'loader.native').write_text(source,encoding='utf-8',newline='\n')
subprocess.run([sys.executable,str(BUILD/'build-router.py'),'--only','loader','--release','dig-for-eggs-shop-20261021-1'],cwd=BUILD,check=True)
public=(BUILD/'candidate/loader').read_bytes();(ROOT/'loader').write_bytes(public)
# Keep the existing Climb integration check's current-main metadata accurate.
climb_path=ROOT/'climb-eggs-release.json'
climb=json.loads(climb_path.read_text())
if climb.get('main_loader_sha256')==audit['public_loader_sha256']:
    climb['main_loader_sha256']=hashlib.sha256(public).hexdigest()
    climb_path.write_text(json.dumps(climb,indent=2)+'\n',encoding='utf-8',newline='\n')
old_routes=[r for r in audit['routes'] if r['File']!='devilv4-test.lua']
assert len(old_routes)==11
audit['routes']=old_routes+[row]
audit.update(release='dig-for-eggs-shop-20261021-1',existing_game_routes_unchanged=True,
    before_native_sha256=hashlib.sha256(baseline.encode()).hexdigest(),
    after_native_sha256=hashlib.sha256(source.encode()).hexdigest(),
    public_loader_sha256=hashlib.sha256(public).hexdigest(),public_loader_bytes=len(public),
    dig_for_eggs_baseline_commit=BASE,dig_for_eggs_entry_commit=commit,
    dig_for_eggs_entry_sha256=release['entry_sha256'],public_router_universe_place_cases=36)
audit_path.write_text(json.dumps(audit,indent=2)+'\n',encoding='utf-8',newline='\n')
path=ROOT/'devilv4-test-release.json';manifest=json.loads(path.read_text())
manifest.update(production_router_changed=True,main_loader_entry_commit=commit,
    main_loader_entry_sha256=release['entry_sha256'],main_loader_sha256=audit['public_loader_sha256'],
    existing_routes_unchanged=True)
path.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8',newline='\n')
print('PASS Dig For Eggs pinned; removing its additions restores baseline router byte for byte')
