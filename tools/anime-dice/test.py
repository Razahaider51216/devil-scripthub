from pathlib import Path
import hashlib, json, re, subprocess
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
checks = checks.replace('-- TEST_PLANNER', (here / 'planner.lua').read_text(encoding='utf-8'))
checks = checks.replace('-- TEST_CORE', (here / 'core.lua').read_text(encoding='utf-8'))
path = here / 'test.generated.luau'
path.write_text(checks, encoding='utf-8', newline='\n')
execute(path)
movement = (root / 'tests/anime-dice-movement.luau').read_text(encoding='utf-8')
movement = movement.replace('-- TEST_ADAPTER', (here / 'adapter.lua').read_text(encoding='utf-8'))
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
ouro = dependency.read(root).decode('utf-8')
fixture = mocks + '\nlocal entrySource=' + literal(entry) + '\nlocal ouroSource=' + literal(ouro) + '\n'
fixture += (root / 'tests/anime-dice-entry.luau').read_text(encoding='utf-8')
path = here / 'entry-test.generated.luau'
path.write_text(fixture, encoding='utf-8', newline='\n')
execute(path)
validation = {'release':'anime-dice-test-20261020-7','live_game_verified':False,
    'entry_sha256':hashlib.sha256((root / 'anime-dice-test.lua').read_bytes()).hexdigest(),
    'checks':sum(int(n) for result in results for n in re.findall(r'(\d+) checks', result)),
    'literal_remote_contract_checks':count,'results':results,
    'pinned_gui_sha256':dependency.SHA256,
    'fixtures':{p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in (root / 'tests').glob('anime-dice-*.luau')}}
(root / 'anime-dice-test-validation.json').write_text(json.dumps(validation,indent=2)+'\n',encoding='utf-8',newline='\n')
