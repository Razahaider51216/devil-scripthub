from pathlib import Path
import hashlib,json,subprocess
ROOT=Path(__file__).resolve().parents[2]
manifest=json.loads((ROOT/'climb-eggs-release.json').read_text())
audit=json.loads((ROOT/'devil-blue-gui-router-audit.json').read_text())
entry=(ROOT/'climb-for-eggs.lua').read_bytes()
assert hashlib.sha256(entry).hexdigest()==manifest['entry_sha256']==audit['climb_entry_sha256']
assert subprocess.check_output(['git','show',manifest['runtime_commit']+':climb-for-eggs.lua'],cwd=ROOT)==entry
loader=(ROOT/'loader').read_bytes()
assert hashlib.sha256(loader).hexdigest()==manifest['main_loader_sha256']==audit['public_loader_sha256']
old=subprocess.check_output(['git','show','78b26f780aa2fcb0992aab82640aa3f94f32a1aa:tools/blue-gui/router.lua'],cwd=ROOT).decode()
old=old.replace('e39fb7f24bda4d132f439416c7c68ad7467ff351",Version="climb-fly-speed-10',manifest['runtime_commit']+'",Version="'+manifest['release'])
old=old.replace('entry.File=="climb-for-eggs.lua"and"climb-fly-speed-10','entry.File=="climb-for-eggs.lua"and"'+manifest['release'])
current=(ROOT/'tools/blue-gui/router.lua').read_text(encoding='utf-8')
expected=old
dig=next((r for r in audit['routes'] if r['File']=='devilv4-test.lua'),None)
if dig:
    route=('    {Name="Dig For Eggs",Universe=10765013362,Place=121831322352666,'
           f'File="devilv4-test.lua",Commit="{dig["Commit"]}",Version="{dig["Version"]}"}},\n')
    override=('-- Dig For Eggs keeps its own release after the legacy version normalizer.\n'
              'for _,entry in ipairs(games)do if entry.File=="devilv4-test.lua"then '
              f'entry.Version="{dig["Version"]}"end end\n')
    guard='''if selected.File=="devilv4-test.lua"then
    local app=env.DevilV4Test
    if app and not app.Stopped and app.Version==selected.Version then return app end
    if type(env.DevilV4Starting)=="number"and os.clock()-env.DevilV4Starting<30 then return end
end
'''
    expected=expected.replace('local games={\n','local games={\n'+route,1)
    expected=expected.replace('if not game:IsLoaded()then game.Loaded:Wait()end',override+'if not game:IsLoaded()then game.Loaded:Wait()end',1)
    expected=expected.replace('and Anime Dice. This map','Anime Dice, and Dig For Eggs. This map',1)
    expected=expected.replace('assert(type(loadstring)=="function"',guard+'assert(type(loadstring)=="function"',1)
normalized=current
steal=next(r for r in audit['routes'] if r['File']=='devil-steal-an-egg.lua')
if steal.get('Version','').startswith('chilli-performance-'):
    import re
    baseline_row=re.search(r'^    \{Name="Steal an Egg"[^\n]+',expected,re.M)[0]
    normalized,count=re.subn(r'^    \{Name="Steal an Egg"[^\n]+',lambda _:baseline_row,normalized,flags=re.M)
    assert count==1
    normalized=normalized.replace('entry.File=="devil-steal-an-egg.lua"and"'+steal['Version']+'"','entry.File=="devil-steal-an-egg.lua"and"chilli-fishing-rotation-20261020-1"',1)
assert expected==normalized,'Changes outside the declared game entry pins and Dig For Eggs additions'
assert hashlib.sha256(current.encode()).hexdigest()==audit['after_native_sha256']
print('PASS Climb immutable entry/main-loader hashes; all other router bytes preserved')
