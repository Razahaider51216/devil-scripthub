from pathlib import Path
import json,runpy,subprocess,hashlib
ROOT=Path(__file__).resolve().parents[2];HERE=Path(__file__).resolve().parent
build=runpy.run_path(str(HERE/'build.py'))
catalog=json.loads((HERE/'catalog.json').read_text(encoding='utf-8'))
core=(HERE/'core.lua').read_text(encoding='utf-8')
adapter=(HERE/'adapter.lua').read_text(encoding='utf-8')
results=[]
def run(name,text):
    path=HERE/(name+'.generated.luau');path.write_text(text,encoding='utf-8',newline='\n')
    p=subprocess.run([str(ROOT.parent/'luau-tools/luau.exe'),str(path)],capture_output=True,timeout=45)
    if p.returncode:
        print(p.stdout.decode('utf-8'),p.stderr.decode('utf-8'));p.check_returncode()
    output=p.stdout.decode('utf-8').strip();print(output);results.append(output)
run('core-tests','local K='+build['lua'](catalog)+'\nlocal makeCore=(function()\n'+core+'\nend)()\n'+(HERE/'core-tests.luau').read_text(encoding='utf-8'))
run('adapter-tests',(HERE/'adapter-tests.luau').read_text(encoding='utf-8').replace('-- ADAPTER','local makeAdapter=(function()\n'+adapter+'\nend)()'))
baseline=subprocess.check_output(['git','show','b2b307f:tools/hatch-to-fight/adapter.lua'],cwd=ROOT).decode('utf-8')
geometry=(HERE/'geometry-tests.luau').read_text(encoding='utf-8')
floor=json.loads((HERE/'geometry-evidence.json').read_text(encoding='utf-8'))['floors']['Stage1']
for name,text,is_old in [('old',baseline,True),('new',adapter,False)]:
    start=text.index('    function A.StagePoint(');end=text.index('    local function own(',start)
    section=text[start:end]
    if not is_old:
        begin=text.index('    local function stageFloor(');finish=text.index('    function A.Move(',begin)
        movement_end=text.index('    function A.HubPoint(',finish)
        section=text[begin:finish]+text[finish:movement_end]+section
    run('geometry-'+name,'local OLD='+str(is_old).lower()+'\nlocal FLOOR='+build['lua'](floor)+'\n'+geometry.replace('-- GEOMETRY',section))
entry=(ROOT/'hatch-to-fight-test.lua').read_text(encoding='utf-8')
gui=runpy.run_path(str(ROOT/'tools/anime-dice/dependency.py'))['read'](ROOT).decode('utf-8')
ui_fixture=(HERE/'ui-tests.luau').read_text(encoding='utf-8')
run('ui-tests','local GUI_DEPENDENCY='+build['lua'](gui)+'\n'+ui_fixture.replace('-- ENTRY',entry))
for forbidden in ['hookmetamethod','hookfunction','getgc(','getrawmetatable','Humanoid.Health =','SetAttribute("PetHP"','SetAttribute("StagesCleared"']:
    assert forbidden not in entry,forbidden
assert entry.count('setclipboard')==1
assert entry.count('loadstring(')==1
assert 'require('not in entry
manifest=json.loads((ROOT/'hatch-to-fight-test-release.json').read_text(encoding='utf-8'))
assert hashlib.sha256((ROOT/'hatch-to-fight-test.lua').read_bytes()).hexdigest()==manifest['entry_sha256']
results.append('PASS exact artifact hash, no game require/global hooks/fabricated HP or stage unlocks')
(ROOT/'hatch-to-fight-test-validation.json').write_text(json.dumps({'release':manifest['release'],'live_verified':False,'results':results},indent=2)+'\n',encoding='utf-8',newline='\n')
