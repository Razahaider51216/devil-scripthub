"""One VM startup boundary; native game/UI functions and original environments."""
from pathlib import Path
import ast,base64,hashlib,json,secrets,subprocess,sys
ROOT=Path(__file__).resolve().parents[2]
VM=ROOT.parent/'devil-vm-build'
WORK=ROOT.parent/'devil-protection-20261021'
WORK.mkdir(exist_ok=True)
CLI=ROOT.parent/'luau-tools/luau.exe'
COMPILER=ROOT.parent/'luau-tools/luau-compile.exe'
sys.path.insert(0,str(VM))
from opcodes import encode_ops
ns=dict(ROOT=WORK,COMPILER=COMPILER,secrets=secrets,base64=base64,json=json,subprocess=subprocess,hashlib=hashlib,encode_ops=encode_ops,records=[],MAGIC='!DV1!')
tree=ast.parse((VM/'build_vm.py').read_text(encoding='utf-8'))
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef)and n.name in {'encoded','compile_code'}],type_ignores=[]),'packing','exec'),ns)
DECODER=(ROOT.parent/'steal-chilli-build-20261019/decoder.lua').read_text(encoding='utf-8')
RUNTIME=(VM/'vm-runtime.lua').read_text(encoding='utf-8')
LICENSE=(VM/'Fiu-LICENSE').read_text(encoding='utf-8')
RELEASE='devil-all-games-obf-20261021-1'
def sha(value):return hashlib.sha256(value).hexdigest()
def checksum(value):
    result=0
    for b in value:result=(result*33+b)%4294967296
    return result
def literal(value):
    eq='='
    while ']'+eq+']'in value:eq+='='
    return '['+eq+'['+value+']'+eq+']'
def capture(public,name):
    """Do not run game code. Intercept its final native compilation boundary."""
    fixture='''local builtin=loadstring
local captured
local env=setmetatable({task={wait=function()end}},{__index=getfenv(0)})
env.loadstring=function(code,label)
 if label=="Devil VM"or label=="DEVIL HUB / startup decoder"then
  local f,e=builtin(code,label);assert(f,e);setfenv(f,env);return f
 end
 assert(not captured,"Nested native compilation")
 captured=code
 return function(...)return ... end
end
local f=assert(builtin(PUBLIC));setfenv(f,env);f()
assert(captured,"Missing native boundary")
print("__SOURCE_BEGIN__");print(captured);print("__SOURCE_END__")
'''.replace('PUBLIC',literal(public))
    path=WORK/'capture.generated.luau';path.write_text(fixture,encoding='utf-8',newline='\n')
    result=subprocess.run([str(CLI),str(path)],capture_output=True,check=True,timeout=60)
    return result.stdout.decode('utf-8').replace('\r\n','\n').split('__SOURCE_BEGIN__\n',1)[1].split('\n__SOURCE_END__',1)[0]
def native(public,name):
    # Break's language prelude precedes the old VM and must remain intact.
    marker=public.find('--[[\nDEVIL HUB ')
    if marker<0:marker=public.find('--[[\nKUYDUM HUB ')
    if marker>=0 and 'Fiu (startup only)'in public[marker:marker+250]:
        return public[:marker]+capture(public[marker:],name)
    marker=public.find('-- DEVIL HUB / Ride native encoded entry;')
    if marker>=0:return public[:marker]+capture(public[marker:],name)
    if public.startswith('-- KUYDUM HUB ')and ' / native encoded startup\n'in public[:160]:
        return capture(public,name)
    return public
def pack(source,name):
    path=WORK/(name+'.native');path.write_text(source,encoding='utf-8',newline='\n')
    subprocess.run([str(COMPILER),'--null',str(path)],capture_output=True,check=True)
    startup='local f,e=loadstring('+json.dumps(DECODER+'\nreturn decode\n')+',"DEVIL HUB / startup decoder")\nassert(f,e)\nlocal decode=f()\nlocal run,err=loadstring(decode('+json.dumps(ns['encoded'](source.encode()))+'),'+json.dumps('DEVIL HUB / native '+name)+')\nassert(run,err)\nreturn run(...)\n'
    payload=ns['compile_code'](startup,name+'/startup-only')
    bootstrap='local make=(function()\n'+RUNTIME+'\nend)()\nreturn make('+json.dumps(payload)+',getfenv(1))(...)\n'
    artifact='--[[\nDEVIL HUB '+RELEASE+'\nIncludes modified Fiu (startup only)\n'+LICENSE+'\n]]\n'+DECODER+'\nlocal run,err=loadstring(decode('+json.dumps(ns['encoded'](bootstrap.encode()))+'),"Devil VM")\nassert(run,err)\nreturn run(...)\n'
    path=WORK/(name+'.protected');path.write_text(artifact,encoding='utf-8',newline='\n')
    subprocess.run([str(COMPILER),'--null',str(path)],capture_output=True,check=True)
    assert capture(artifact,name)==source,'Native source changed in packing: '+name
    return artifact.encode()
