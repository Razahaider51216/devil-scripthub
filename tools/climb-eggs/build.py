from pathlib import Path
import ast,base64,hashlib,json,secrets,subprocess,sys
ROOT=Path(__file__).resolve().parents[2]
WORK=Path(__file__).resolve().parent
VMROOT=ROOT.parent/'devil-vm-build'
COMPILER=ROOT.parent/'luau-tools/luau-compile.exe'
RELEASE='climb-steal-control-20261020-11'
planner=(WORK/'planner.lua').read_text(encoding='utf-8')
core=(WORK/'core.lua').read_text(encoding='utf-8')
ui=(WORK/'ui.lua').read_text(encoding='utf-8')
source=ui.replace('-- CLIMB_PLANNER',planner).replace('-- CLIMB_CORE',core).replace('-- CLIMB_LOGO',(WORK/'logo.lua').read_text(encoding='utf-8'))
assert '-- CLIMB_CORE' not in source
(WORK/'entry.native.lua').write_text(source,encoding='utf-8',newline='\n')
subprocess.run([str(COMPILER),'--null',str(WORK/'entry.native.lua')],check=True)
sys.path.insert(0,str(VMROOT))
from opcodes import encode_ops
ns=dict(ROOT=WORK,COMPILER=COMPILER,secrets=secrets,base64=base64,json=json,subprocess=subprocess,hashlib=hashlib,encode_ops=encode_ops,records=[],MAGIC='!DV1!')
tree=ast.parse((VMROOT/'build_vm.py').read_text(encoding='utf-8'))
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef)and n.name in {'encoded','compile_code'}],type_ignores=[]),'packing','exec'),ns)
decoder=(ROOT.parent/'carry-recovery-fix/decoder.lua').read_text(encoding='utf-8')
vm=(VMROOT/'vm-runtime.lua').read_text(encoding='utf-8')
startup='local f,e=loadstring('+json.dumps(decoder+'\nreturn decode\n')+',"DEVIL HUB / startup decoder")\nassert(f,e)\nlocal decode=f()\nlocal run,err=loadstring(decode('+json.dumps(ns['encoded'](source.encode()))+'),"DEVIL HUB / native climb-for-eggs.lua")\nassert(run,err)\nreturn run(...)\n'
payload=ns['compile_code'](startup,'climb-for-eggs.lua/startup-only')
bootstrap='local make=(function()\n'+vm+'\nend)()\nreturn make('+json.dumps(payload)+',getfenv(1))(...)\n'
artifact='--[[\nDEVIL HUB '+RELEASE+'\nIncludes modified Fiu (startup only)\n'+(VMROOT/'Fiu-LICENSE').read_text(encoding='utf-8')+'\n]]\n'+decoder+'\nlocal run,err=loadstring(decode('+json.dumps(ns['encoded'](bootstrap.encode()))+'),"Devil VM")\nassert(run,err)\nreturn run(...)\n'
current=(ROOT/'climb-for-eggs.lua').read_text(encoding='utf-8')
prefix=current.split('-- END SHARED DEVIL BLUE GUI\n',1)[0]+'-- END SHARED DEVIL BLUE GUI\n'
public=(prefix+artifact).encode()
(ROOT/'climb-for-eggs.lua').write_bytes(public)
subprocess.run([str(COMPILER),'--null',str(ROOT/'climb-for-eggs.lua')],check=True)
manifest=dict(release=RELEASE,placeId=85738654635245,universeId=10765490774,source_sha256=hashlib.sha256(source.encode()).hexdigest(),entry_sha256=hashlib.sha256(public).hexdigest(),bytes=len(public),live_verified=False)
(ROOT/'climb-eggs-release.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8',newline='\n')
print('Built Climb entry with native callbacks and existing shared GUI prefix')
