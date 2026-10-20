"""Update Anime Dice while preserving every other route and router code."""
from pathlib import Path
import hashlib, json, re, subprocess, sys

root = Path(__file__).resolve().parents[2]
build = root.parent / 'steal-chilli-build-20261019'
commit = sys.argv[1]
assert re.fullmatch('[0-9a-f]{40}', commit)
entry = subprocess.check_output(['git', 'show', commit + ':anime-dice-test.lua'], cwd=root)
release = json.loads(subprocess.check_output(['git', 'show', commit + ':anime-dice-test-release.json'], cwd=root))
assert hashlib.sha256(entry).hexdigest() == release['entry_sha256']
audit_path = root / 'devil-blue-gui-router-audit.json'
audit = json.loads(audit_path.read_text(encoding='utf-8'))
canonical = root / 'tools/blue-gui/router.lua'
before = (canonical if canonical.exists() else build / 'loader.native').read_text(encoding='utf-8')
assert hashlib.sha256(before.encode()).hexdigest() == audit['after_native_sha256']
source = before
baseline_commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip()
assert subprocess.check_output(['git','show',baseline_commit+':tools/blue-gui/router.lua'],cwd=root).decode()==before
old_row=re.search(r'^    \{Name="Anime Dice"[^\n]+',before,re.M)[0]
old_version=re.search(r'for _,entry in ipairs\(games\)do if entry.File=="anime-dice-test.lua"then entry.Version="([^"]+)"',before)[1]
auto_source = (root / 'tools/auto-execute/bootstrap.lua').read_text(encoding='utf-8').rstrip()
if '-- BEGIN DEVIL AUTO EXECUTE\n' in source:
    source, auto_count = re.subn(r'-- BEGIN DEVIL AUTO EXECUTE\n.*?-- END DEVIL AUTO EXECUTE',
                               lambda _: auto_source, source, count=1, flags=re.S)
    assert auto_count == 1
else:
    marker = 'if selected.File=="ride-a-pet.lua"and'
    assert source.count(marker) == 1
    source = source.replace(marker, auto_source + '\n' + marker, 1)
route = ('    {Name="Anime Dice",Universe=10708913337,Place=113290951185459,'
         f'File="anime-dice-test.lua",Commit="{commit}",Version="{release["release"]}"}},')
if 'File="anime-dice-test.lua"' in source:
    source, count = re.subn(r'^    \{Name="Anime Dice"[^\n]+', lambda _: route, source, flags=re.M)
    assert count == 1
else:
    assert source.count('local games={\n') == 1
    source = source.replace('local games={\n', 'local games={\n' + route + '\n', 1)
    marker = 'if not game:IsLoaded()then game.Loaded:Wait()end'
    source = source.replace(marker, '-- Anime Dice keeps its own release without changing legacy route versions.\n'
        'for _,entry in ipairs(games)do if entry.File=="anime-dice-test.lua"then '
        'entry.Version=entry.Version or "anime-dice"end end\n' + marker, 1)
    source = source.replace('and Build An Ant Empire. This map', 'Build An Ant Empire, and Anime Dice. This map', 1)
    guard = '''if selected.File=="anime-dice-test.lua"then
    local app=env.DevilAnimeDiceTest
    if app and not app.Stopped and app.Version==selected.Version then return app end
    if env.DevilAnimeDiceStarting and os.clock()-env.DevilAnimeDiceStarting.At<30 then return end
end
'''
    source = source.replace('assert(type(loadstring)=="function"', guard + 'assert(type(loadstring)=="function"', 1)
# The legacy version normalizer intentionally overrides entries; restore just
# Anime Dice afterward, leaving every old game's exact version query unchanged.
source, count = re.subn(r'entry.Version=entry.Version or "anime-dice[^"\n]*"',
                       'entry.Version="' + release['release'] + '"', source)
if count == 0:
    source, count = re.subn(r'(for _,entry in ipairs\(games\)do if entry.File=="anime-dice-test.lua"then entry.Version=)"[^"]+"',
                           lambda m: m[1] + '"' + release['release'] + '"', source)
assert count == 1
legacy_before = re.findall(r'^    \{(?!Name="Anime Dice")[^\n]+', before, re.M)
legacy_after = re.findall(r'^    \{(?!Name="Anime Dice")[^\n]+', source, re.M)
assert legacy_before == legacy_after and len(legacy_after) == len(audit['routes'])-1
restored=source.replace(route,old_row,1).replace('entry.File=="anime-dice-test.lua"then entry.Version="'+release['release']+'"','entry.File=="anime-dice-test.lua"then entry.Version="'+old_version+'"',1)
assert restored==before,'Changes outside the Anime Dice pin/version'
source = source.rstrip() + '\n'
canonical.write_text(source, encoding='utf-8', newline='\n')
(build / 'loader.native').write_text(source, encoding='utf-8', newline='\n')
subprocess.run([sys.executable, str(build / 'build-router.py'), '--only', 'loader',
                '--release', release['release']], cwd=build, check=True)
public = (build / 'candidate/loader').read_bytes()
(root / 'loader').write_bytes(public)
row = dict(Name='Anime Dice', Universe=10708913337, Place=113290951185459,
           File='anime-dice-test.lua', Commit=commit, Version=release['release'])
audit['routes'] = [row if r['File']==row['File'] else r for r in audit['routes']]
previous_loader_sha=audit['public_loader_sha256']
audit.update(release=release['release'], map_ids_unchanged=True,
    existing_game_routes_unchanged=True,
    native_logic_unchanged_except_presentation_bootstrap_and_entry_pins=False,
    before_native_sha256=hashlib.sha256(before.encode()).hexdigest(),
    after_native_sha256=hashlib.sha256(source.encode()).hexdigest(),
    public_loader_sha256=hashlib.sha256(public).hexdigest(), public_loader_bytes=len(public),
    anime_dice_entry_commit=commit, anime_dice_entry_sha256=release['entry_sha256'],
    anime_router_baseline_commit=baseline_commit,
    auto_execute_enabled=True, auto_execute_sha256=hashlib.sha256(auto_source.encode()).hexdigest(),
    public_router_universe_place_cases=len(audit['routes'])*3)
audit_path.write_text(json.dumps(audit, indent=2)+'\n', encoding='utf-8', newline='\n')
manifest_path = root / 'anime-dice-test-release.json'
manifest = json.loads(manifest_path.read_text(encoding='utf-8'))
manifest.update(production_router_changed=True, main_loader_entry_commit=commit,main_loader_sha256=audit['public_loader_sha256'])
manifest_path.write_text(json.dumps(manifest, indent=2)+'\n', encoding='utf-8', newline='\n')
for filename in ['climb-eggs-release.json','devilv4-test-release.json','devil-steal-update-release.json']:
    path=root/filename;metadata=json.loads(path.read_text())
    if metadata.get('main_loader_sha256')==previous_loader_sha:
        metadata['main_loader_sha256']=audit['public_loader_sha256']
        path.write_text(json.dumps(metadata,indent=2)+'\n',encoding='utf-8',newline='\n')
print('PASS main loader: Anime Dice pinned, all',len(legacy_after),'other entries and router code preserved')
