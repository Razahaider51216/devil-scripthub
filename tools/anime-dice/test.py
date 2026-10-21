from pathlib import Path
import hashlib, json, re, subprocess, importlib.util
import dependency

root = Path(__file__).resolve().parents[2]
here = Path(__file__).resolve().parent
results = []
def execute(path):
    result = subprocess.run([str(root.parent / 'luau-tools/luau.exe'), str(path)],
                            timeout=25, capture_output=True, text=True, encoding='utf-8')
    print(result.stdout, end='')
    if result.returncode:
        print(result.stderr, end='')
        result.check_returncode()
    results.append(result.stdout.strip())
checks = (root / 'tests/anime-dice-core.luau').read_text(encoding='utf-8')
webhook=(root/'tests/anime-dice-webhook.luau').read_text(encoding='utf-8')
webhook=webhook.replace('-- TEST_PLANNER',(here/'planner.lua').read_text(encoding='utf-8')).replace('-- TEST_WEBHOOK',(here/'webhook.lua').read_text(encoding='utf-8'))
webhook_path=here/'webhook-test.generated.luau'
webhook_path.write_text(webhook,encoding='utf-8',newline='\n')
execute(webhook_path)
checks = checks.replace('-- TEST_PLANNER', (here / 'planner.lua').read_text(encoding='utf-8'))
baseline=subprocess.check_output(['git','show','f54cc8e866b50ecfe74c228a0922f7b785309657:tools/anime-dice/core.lua'],cwd=root).decode('utf-8')
baseline_path=here/'door-recovery-baseline.generated.luau'
baseline_path.write_text(checks.replace('-- TEST_CORE',baseline),encoding='utf-8',newline='\n')
prior=subprocess.run([str(root.parent/'luau-tools/luau.exe'),str(baseline_path)],capture_output=True,text=True,encoding='utf-8',timeout=25)
assert prior.returncode!=0 and 'stalled route was not retired while keeping automation on' in prior.stderr,prior.stdout+prior.stderr
print('PASS reproduced previous release: a stalled door worker never resumed collection')
checks = checks.replace('-- TEST_CORE', (here / 'core.lua').read_text(encoding='utf-8'))
path = here / 'test.generated.luau'
path.write_text(checks, encoding='utf-8', newline='\n')
execute(path)
settings=(root/'tests/anime-dice-settings.luau').read_text(encoding='utf-8')
settings=settings.replace('-- TEST_CORE',(here/'core.lua').read_text(encoding='utf-8'))
settings_helper=json.dumps((here/'settings.lua').read_text(encoding='utf-8'),ensure_ascii=True)
settings_path=here/'settings-test.generated.luau'
settings_path.write_text('local settingsSource='+settings_helper+'\n'+settings,encoding='utf-8',newline='\n')
execute(settings_path)
movement = (root / 'tests/anime-dice-movement.luau').read_text(encoding='utf-8')
movement = movement.replace('-- TEST_ADAPTER', (here / 'adapter.lua').read_text(encoding='utf-8'))
movement=movement.replace('-- ANIME_TOWER_CATALOG',(here/'tower-catalog.lua').read_text(encoding='utf-8'))
movement_path = here / 'movement-test.generated.luau'
movement_path.write_text(movement, encoding='utf-8', newline='\n')
execute(movement_path)
index = json.loads((here / 'remote-contracts.json').read_text(encoding='utf-8'))
remotes = {r['path']:r['class'] for r in index['remotes']}
core = (here / 'core.lua').read_text(encoding='utf-8')
count = 0
for kind, ns, name in re.findall(r'call\([^\n]*?"(RE|RF)","([^"\n]*)","([^"\n]+)"', core):
    remote = 'ReplicatedStorage.Network.' + (ns + '.' if ns else '') + kind + '.' + name
    assert remotes.get(remote) == ('RemoteEvent' if kind == 'RE' else 'RemoteFunction'), remote
    count += 1
assert count >= 15
print('PASS', count, 'literal action paths/classes match the captured real-game remote inventory')
def literal(value):
    eq = '='
    while ']' + eq + ']' in value:
        eq += '='
    return '[' + eq + '[' + value + ']' + eq + ']'
mocks = (root / 'tests/blue-gui-mocks.luau').read_text(encoding='utf-8')
entry = (root / 'anime-dice-test.lua').read_text(encoding='utf-8')
pack_spec=importlib.util.spec_from_file_location('anime_protection',root/'tools/protection/pack.py')
protection=importlib.util.module_from_spec(pack_spec);pack_spec.loader.exec_module(protection)
entry=protection.native(entry,'anime-dice-test.lua')
ouro = dependency.read(root).decode('utf-8')
fixture = mocks + '\nlocal entrySource=' + literal(entry) + '\nlocal ouroSource=' + literal(ouro) + '\n'
router = json.loads((root / 'devil-blue-gui-router-audit.json').read_text(encoding='utf-8'))
anime_route = next((r for r in router['routes'] if r['File'] == 'anime-dice-test.lua'), None)
entry_release=json.loads((root/'anime-dice-test-release.json').read_text(encoding='utf-8'))['release']
main_matches=anime_route is not None and anime_route.get('Version')==entry_release
if main_matches:
    fixture += 'local mainLoaderSource=' + literal((root / 'loader').read_text(encoding='utf-8')) + '\n'
    fixture += 'local mainEntryCommit=' + json.dumps(anime_route['Commit']) + '\n'
elif anime_route:
    print('SKIP main-loader integration until the new entry release is pinned; testing standalone entry')
fixture += (root / 'tests/anime-dice-entry.luau').read_text(encoding='utf-8')
entry_checks=(root/'tests/anime-dice-entry.luau').read_text(encoding='utf-8')
old_entry=subprocess.check_output(['git','show','2679b1f:anime-dice-test.lua'],cwd=root).decode('utf-8')
focused=entry_checks.split('\ndo\n',1)[0]+entry_checks[entry_checks.rfind('\ndo\n'):]
old_path=here/'desktop-baseline.generated.luau'
old_path.write_text(mocks+'\nlocal entrySource='+literal(old_entry)+'\nlocal ouroSource='+literal(ouro)+'\n'+focused,encoding='utf-8',newline='\n')
old_result=subprocess.run([str(root.parent/'luau-tools/luau.exe'),str(old_path)],capture_output=True,text=True,timeout=25)
assert old_result.returncode!=0 and 'failed desktop module left Tower picker empty'in old_result.stderr,old_result.stdout+old_result.stderr
print('PASS reproduced empty Tower picker against actual previous public entry')
path = here / 'entry-test.generated.luau'
path.write_text(fixture, encoding='utf-8', newline='\n')
execute(path)
validation = {'release':entry_release,'live_game_verified':False,
    'entry_sha256':hashlib.sha256((root / 'anime-dice-test.lua').read_bytes()).hexdigest(),
    'checks':sum(int(n) for result in results for n in re.findall(r'(\d+) checks', result)),
    'literal_remote_contract_checks':count,'results':results,
    'main_loader_sha256':hashlib.sha256((root / 'loader').read_bytes()).hexdigest() if main_matches else None,
    'main_loader_integration_verified':main_matches,
    'pinned_gui_sha256':dependency.SHA256,
    'fixtures':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in (root / 'tests').glob('anime-dice-*.luau')}}
(root / 'anime-dice-test-validation.json').write_text(json.dumps(validation,indent=2)+'\n',encoding='utf-8',newline='\n')
