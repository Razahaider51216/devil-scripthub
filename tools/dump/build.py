from pathlib import Path
import ast,base64,hashlib,json,re,subprocess
ROOT=Path(__file__).resolve().parents[2];HERE=Path(__file__).resolve().parent
WORK=ROOT.parent/'devil-dump-development'
if (ROOT/'devil-dump-release.json').exists() and json.loads((ROOT/'devil-dump-release.json').read_text(encoding='utf-8'))['release'].startswith(('dump-14-','dump-15-')):
 subprocess.run(['python',str(HERE/'build-runtime.py')],check=True)
 raise SystemExit(0)
RELEASE='dump-13-client-start-20261022-1'
ns={'re':re,'base64':base64,'RELEASE':ROOT}
tree=ast.parse((ROOT.parent/'naphub-loot-to-forge/build_update.py').read_text(encoding='utf-8'))
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef)and n.name in {'unpack','repack'}],type_ignores=[]),'dump-packing','exec'),ns)
before=(ROOT/'devil-dump.lua').read_text(encoding='utf-8')
baseline_ref=None
metadata_path=ROOT/'devil-dump-release.json'
if metadata_path.exists():
    previous=json.loads(metadata_path.read_text())
    if hashlib.sha256((ROOT/'devil-dump.lua').read_bytes()).hexdigest()==previous['entry_sha256']:
        before=subprocess.check_output(['git','show',previous['baseline_commit']+':devil-dump.lua'],cwd=ROOT).decode('utf-8')
        baseline_ref=previous['baseline_commit']
source=ns['unpack'](before).decode('utf-8')
(WORK/'dump-before-v13.lua').write_text(source,encoding='utf-8',newline='\n')
baseline=baseline_ref or subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip()
anchor='Folder="DevilDump_Dumps",Auto=true,Sources=false,MaxNodes=50000'
assert source.count(anchor)==1
source=source.replace(anchor,anchor.replace('Auto=true','Auto=false'),1)
anchor='\tdecoded_local_1186[19] = { true }'
assert source.count(anchor)==1
source=source.replace(anchor,anchor.replace('true','false'),1)
start=source.index('\tdecoded_local_1186[40] = decoded_local_1186[36]\n\tdecoded_local_1186[40]()')
end=source.index('\tdecoded_local_1186[40] = {}',start)
old_autoload=source[start:end]
assert 'decoded_local_1186[40](decoded_local_1186[41])'in old_autoload
source=source[:start]+'''    -- Startup never applies a saved profile's movement/recorder actions.
    -- The existing explicit profile Load controls remain available.
'''+source[end:]
source=source.replace('devil-dump.lua?v=dump-12','devil-dump.lua?v='+RELEASE)
new_outer=before.replace('screen.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")','screen.Parent = dumpGuiParent()',1)
assert new_outer!=before
helper=(HERE/'gui-parent.lua').read_text(encoding='utf-8')
new_outer=new_outer.replace('local Loading = {}','local Loading = {}\n'+helper,1)
new_outer=new_outer.replace('devil-dump.lua?v=dump-12','devil-dump.lua?v='+RELEASE)
(ROOT/'devil-dump.lua').write_text(new_outer,encoding='utf-8',newline='\n')
ns['repack']('devil-dump.lua',source,ns['unpack'](before).decode('utf-8'))
public=(ROOT/'devil-dump.lua').read_bytes()
assert ns['unpack'](public.decode('utf-8'))==source.encode()
(WORK/'dump-v13.lua').write_text(source,encoding='utf-8',newline='\n')
(WORK/'autoload-before.generated.luau').write_text(old_autoload,encoding='utf-8',newline='\n')
subprocess.run([str(ROOT.parent/'luau-tools/luau-compile.exe'),'--null',str(ROOT/'devil-dump.lua')],check=True,capture_output=True)
report={'release':RELEASE,'baseline_commit':baseline,'entry_sha256':hashlib.sha256(public).hexdigest(),
 'native_sha256':hashlib.sha256(source.encode()).hexdigest(),'live_verified':False,'automatic_map_scan':False,
 'automatic_profile_apply':False,'startup_remote_hook':False,'explicit_dump_spy_and_profile_features_retained':True,
 'utility_ui_host_order':['gethui/get_hidden_gui','CoreGui','PlayerGui fallback'],
 'kick_root_cause_confirmed':False,'report':'Immediate kick using Delta; includes Steal an Egg; exact kick text unavailable'}
(ROOT/'devil-dump-release.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8',newline='\n')
print('PASS built passive DEVIL DUMP startup; native features retained; exact packed roundtrip and compilation')
