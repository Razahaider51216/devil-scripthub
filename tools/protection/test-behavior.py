"""Replay existing UI fixtures against exact native source inside public packs.

test.py separately executes every outer VM boundary and verifies source bytes.
This suite checks the recovered native callbacks without pretending to provide
Roblox/executor integration or performance measurements.
"""
from pack import *
import importlib.util
results=[]
def run(name,source):
    path=WORK/(name+'.generated.luau');path.write_text(source,encoding='utf-8',newline='\n')
    result=subprocess.run([str(CLI),str(path)],check=True,capture_output=True,timeout=60)
    text=result.stdout.decode('utf-8').strip();print(text);results.append(text)
mocks=(ROOT/'tests/blue-gui-mocks.luau').read_text(encoding='utf-8')
module=native((ROOT/'devil-blue-gui.lua').read_text(encoding='utf-8'),'devil-blue-gui.lua')
checks=(ROOT/'tests/blue-gui-checks.luau').read_text(encoding='utf-8')
checks=checks.replace('-- NATIVE TRANSITIONS INSERTED HERE',(ROOT/'tests/blue-gui-native-minimize.luau').read_text(encoding='utf-8'))
run('shared-ui',mocks+checks.replace('-- MODULE INSERTED HERE',module))
audit=json.loads((ROOT/'devil-blue-gui-router-audit.json').read_text())
definitions='local routes={'+','.join('{Universe='+str(r['Universe'])+',Place='+str(r['Place'])+',File='+json.dumps(r['File'])+'}'for r in audit['routes'])+'}\n'
checks=(ROOT/'tests/blue-gui-desktop-startup.luau').read_text(encoding='utf-8')
run('all-platforms',mocks+definitions+checks.replace('-- MODULE INSERTED HERE',module))
spec=importlib.util.spec_from_file_location('dependency',ROOT/'tools/anime-dice/dependency.py')
dependency=importlib.util.module_from_spec(spec);spec.loader.exec_module(dependency)
ouro=dependency.read(ROOT).decode('utf-8')
entry=native((ROOT/'anime-dice-test.lua').read_text(encoding='utf-8'),'anime-dice-test.lua')
checks=(ROOT/'tests/anime-dice-entry.luau').read_text(encoding='utf-8')
route=next(r for r in audit['routes']if r['File']=='anime-dice-test.lua')
fixture=mocks+'\nlocal entrySource='+literal(entry)+'\nlocal ouroSource='+literal(ouro)+'\nlocal mainLoaderSource='+literal((ROOT/'loader').read_text(encoding='utf-8'))+'\nlocal mainEntryCommit='+json.dumps(route['Commit'])+'\n'
run('anime-native',fixture+checks)
checks=(ROOT/'tools/devilv4/test-entry.luau').read_text(encoding='utf-8')
checks=checks.replace('__OURO_SOURCE__',literal(ouro)).replace('-- ENTRY',native((ROOT/'devilv4-test.lua').read_text(encoding='utf-8'),'devilv4-test.lua'))
run('dig-native',checks)
report={'release':RELEASE,'live_verified':False,'results':results,'native_gameplay_callbacks':True,'artifacts':{name:row['public_sha256']for name,row in json.loads((ROOT/'vm-protection-release.json').read_text())['artifacts'].items()}}
(ROOT/'vm-protection-validation.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8',newline='\n')
