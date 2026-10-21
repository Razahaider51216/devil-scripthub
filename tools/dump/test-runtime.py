from pathlib import Path
import ast, base64, hashlib, json, re, subprocess

ROOT=Path(__file__).resolve().parents[2]
HERE=Path(__file__).resolve().parent
CLI=ROOT.parent/'luau-tools/luau.exe'
ns={'re':re,'base64':base64}
tree=ast.parse((ROOT.parent/'naphub-loot-to-forge/build_update.py').read_text(encoding='utf-8'))
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name=='unpack'],type_ignores=[]),'packing','exec'),ns)
metadata=json.loads((ROOT/'devil-dump-release.json').read_text(encoding='utf-8'))
public=(ROOT/'devil-dump.lua').read_bytes()
source=ns['unpack'](public.decode('utf-8')).decode('utf-8')
assert hashlib.sha256(public).hexdigest()==metadata['entry_sha256']
assert hashlib.sha256(source.encode('utf-8')).hexdigest()==metadata['native_sha256']
old_public=subprocess.check_output(['git','show',metadata['baseline_commit']+':devil-dump.lua'],cwd=ROOT).decode('utf-8')
old=ns['unpack'](old_public).decode('utf-8')
def module(text):
    start=text.index('local DevilRuntimeCapture=(function()\n')+len('local DevilRuntimeCapture=(function()\n')
    end=text.index('\nend)()\nlocal DevilMapAnalyst=',start)
    return start,end,text[start:end]
start,end,new_module=module(source)
_,_,old_module=module(old)
assert new_module==(HERE/'runtime-capture.lua').read_text(encoding='utf-8').rstrip()
restored=(source[:start]+old_module+source[end:]).replace('devil-dump.lua?v='+metadata['release'],'devil-dump.lua?v=dump-13-client-start-20261022-1')
assert restored==old,'Native code outside V8 module changed'
results=['PASS exact public/native integrity and all unrelated native tools unchanged']
def run(name,text):
    path=HERE/(name+'.generated.luau')
    path.write_text(text,encoding='utf-8',newline='\n')
    result=subprocess.run([str(CLI),str(path)],capture_output=True,timeout=45)
    if result.returncode:
        print(result.stdout.decode('utf-8'),result.stderr.decode('utf-8'))
        result.check_returncode()
    message=result.stdout.decode('utf-8').strip()
    print(message);results.append(message)
for name in ['test-runtime-output','test-runtime-targeted']:
    fixture=(HERE/(name+'.luau')).read_text(encoding='utf-8')
    run(name+'-baseline',fixture.replace('require("./runtime-capture")','(function()\n'+old_module+'\nend)()',1))
    # Optional APIs remain available when explicitly enabled.
    enabled=fixture.replace('local capture=Runtime.New(deps)','local capture=Runtime.New(deps)\ncapture.LoadedExports=true;capture.GCFunctions=true',1)
    run(name+'-updated',enabled.replace('require("./runtime-capture")','(function()\n'+new_module+'\nend)()',1))
fixture=(HERE/'test-runtime-diagnostics.luau').read_text(encoding='utf-8')
run('v8-public-diagnostics',fixture.replace('require("./runtime-capture")','(function()\n'+new_module+'\nend)()',1))
(ROOT/'devil-dump-validation.json').write_text(json.dumps({
    'release':metadata['release'],'entry_sha256':metadata['entry_sha256'],
    'live_verified':False,'kick_root_cause_confirmed':False,'results':results,
    'limits':'No live Roblox/Delta test; synchronous executor API calls cannot be forcibly timed out or guaranteed not to disconnect.'
},indent=2)+'\n',encoding='utf-8',newline='\n')
print(results[0])
