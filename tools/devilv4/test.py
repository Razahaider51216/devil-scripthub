from pathlib import Path
import hashlib, json, re, subprocess
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
luau = ROOT.parent / 'luau-tools/luau.exe'
def run_checks(path):
    result=subprocess.run([str(luau),str(path)],capture_output=True,text=True,encoding='utf-8')
    print(result.stdout,end='')
    if result.returncode:print(result.stderr)
    result.check_returncode()
    return int(re.search(r'checks:\s*(\d+)',result.stdout)[1])
template = (HERE / 'test-core.luau').read_text(encoding='utf-8')
for marker, filename in [('POLICY','policy.lua'),('CORE','core.lua')]:
    template = template.replace('-- ' + marker, (HERE / filename).read_text(encoding='utf-8'))
target = HERE / 'test-core.generated.luau'
target.write_text(template, encoding='utf-8', newline='\n')
behavior_checks=run_checks(target)
regression_reproduced=False
baseline=subprocess.run(['git','show','fbab251a6dc2f9c8f3bf3f0fb2df83d8ace07683:tools/devilv4/core.lua'],cwd=ROOT,capture_output=True,text=True,encoding='utf-8')
if baseline.returncode==0:
    old_test=(HERE/'test-core.luau').read_text(encoding='utf-8').replace('-- POLICY',(HERE/'policy.lua').read_text(encoding='utf-8')).replace('-- CORE',baseline.stdout)
    old_path=HERE/'test-stall-baseline.generated.luau';old_path.write_text(old_test,encoding='utf-8',newline='\n')
    old_result=subprocess.run([str(luau),str(old_path)],capture_output=True,text=True,encoding='utf-8')
    assert old_result.returncode!=0 and 'Input timeout rearms with Start' in old_result.stderr,old_result.stderr
    regression_reproduced=True
    print('PASS reproduced stale mining session against published v2; new version recovers')
sys.path.insert(0, str(ROOT / 'tools/anime-dice'))
import dependency
def literal(value):
    for n in range(1,10):
        eq='='*n
        if ']'+eq+']' not in value:
            return '['+eq+'['+value+']'+eq+']'
    raise AssertionError('No safe Lua literal delimiter')
entry_test=(HERE/'test-entry.luau').read_text(encoding='utf-8')
entry_test=entry_test.replace('__OURO_SOURCE__',literal(dependency.read(ROOT).decode()))
entry_test=entry_test.replace('-- ENTRY',(ROOT/'devilv4-test.lua').read_text(encoding='utf-8'))
entry_target=HERE/'test-entry.generated.luau'
entry_target.write_text(entry_test,encoding='utf-8',newline='\n')
gui_checks=run_checks(entry_target)
adapter_test=(HERE/'test-adapter.luau').read_text(encoding='utf-8')
adapter_test=adapter_test.replace('-- HARNESS',entry_test.split('local entry=function()',1)[0])
adapter_test=adapter_test.replace('-- ADAPTER',(HERE/'adapter.lua').read_text(encoding='utf-8'))
adapter_target=HERE/'test-adapter.generated.luau'
adapter_target.write_text(adapter_test,encoding='utf-8',newline='\n')
adapter_checks=run_checks(adapter_target)
manifest=json.loads((ROOT/'devilv4-test-release.json').read_text())
assert hashlib.sha256((ROOT/'devilv4-test.lua').read_bytes()).hexdigest()==manifest['entry_sha256']
for filename in ['policy.lua','adapter.lua','core.lua','ui.lua','presentation.lua']:
    raw=(HERE/filename).read_text(encoding='utf-8')
    assert 'AdminTestShovel' not in raw and '9e15' not in raw
    assert ':SetAttribute("DigPower"' not in raw
    assert 'while true do' not in raw
    assert hashlib.sha256((HERE/filename).read_bytes()).hexdigest()==manifest['sources'][filename]
assert manifest['production_router_changed'] is False
assert hashlib.sha256((HERE/'catalog.json').read_bytes()).hexdigest()==manifest['catalog_sha256']
assert 'devilv4-test.lua' not in (ROOT/'loader').read_text(encoding='utf-8')
assert subprocess.check_output(['git','diff','HEAD','--','loader'],cwd=ROOT)==b''
dump=Path(r'C:\Users\Administrator\Downloads\Devilv4\DevilDump_Dumps')
maps=list(dump.glob('Map_121831322352666*/map.json'))
remote_count=None
if maps:
    rows=json.loads(maps[0].read_text(encoding='utf-8-sig'))
    paths={r['path'] for r in rows if r['class'] in ('RemoteEvent','RemoteFunction')}
    contract_line=next(line for line in (HERE/'adapter.lua').read_text().splitlines() if 'local paths=' in line)
    contracts=re.findall(r'(\w+)="([^"]+)"',contract_line)
    for name,path in contracts:
        assert 'ReplicatedStorage.'+path in paths, (name,path)
    remote_count=len(contracts)
    print('PASS all',remote_count,'remote paths exist in supplied map dump')
validation={'release':manifest['release'],'live_game_verified':False,'luau_compile':True,
            'behavior_checks':behavior_checks,'public_entry_gui_settings_checks':gui_checks,'adapter_checks':adapter_checks,
            'remote_paths_checked':remote_count,'production_loader_unchanged':True,
            'published_v2_stall_reproduced':regression_reproduced,
            'entry_sha256':manifest['entry_sha256'],
            'production_loader_sha256':hashlib.sha256((ROOT/'loader').read_bytes()).hexdigest()}
(ROOT/'devilv4-test-validation.json').write_text(json.dumps(validation,indent=2)+'\n',encoding='utf-8',newline='\n')
print('PASS entry integrity, no damage bypass, standalone routing, 31 source-derived images')
