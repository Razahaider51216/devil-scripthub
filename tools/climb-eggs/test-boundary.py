"""Run public startup wrappers, intercept native compilation before game code runs."""
from pathlib import Path
import hashlib,json,subprocess
ROOT=Path(__file__).resolve().parents[2]
WORK=Path(__file__).resolve().parent
fixture='''local public=PUBLIC
local builtin=loadstring
local state={DevilHubBlueGui={Version="devil-blue-20261019-10",Stopped=false}}
local env=setmetatable({task={wait=function()end},getgenv=function()return state end},{__index=getfenv(0)})
local calls=0
env.loadstring=function(code,label)
 if label=="Devil VM"or label=="DEVIL HUB / startup decoder"then
  local f,e=builtin(code,label);assert(f,e);setfenv(f,env);return f
 end
 assert(label=="DEVIL HUB / native climb-for-eggs.lua",label)
 calls+=1
 print("__NATIVE_BEGIN__");print(code);print("__NATIVE_END__")
 return function(...)return "native-ok",... end
end
local f=assert(builtin(public));setfenv(f,env)
local result=table.pack(f("marker",nil,42))
assert(result.n==4 and result[1]=="native-ok"and result[2]=="marker"and result[3]==nil and result[4]==42 and calls==1)
local damaged,n=public:gsub('(decode%("%d+:%d+:%d+:)([A-Za-z0-9+/])',function(prefix,char)return prefix..(char=="A"and"B"or"A")end,1)
assert(n==1)
f=assert(builtin(damaged));setfenv(f,env)
local ok,err=pcall(f);assert(not ok and tostring(err):find("integrity",1,true)and calls==1)
'''
for old in (True,False):
 public=subprocess.check_output(['git','show','78b26f780aa2fcb0992aab82640aa3f94f32a1aa:climb-for-eggs.lua'],cwd=ROOT).decode()if old else(ROOT/'climb-for-eggs.lua').read_text(encoding='utf-8')
 path=WORK/'boundary.generated.luau';path.write_text(fixture.replace('PUBLIC',json.dumps(public,ensure_ascii=False)),encoding='utf-8')
 result=subprocess.run([str(ROOT.parent/'luau-tools/luau.exe'),str(path)],capture_output=True,check=True,timeout=30)
 captured=result.stdout.decode().replace('\r\n','\n').split('__NATIVE_BEGIN__\n',1)[1].split('\n__NATIVE_END__',1)[0]
 if old:
  assert hashlib.sha256(captured.encode()).hexdigest()=='b15922483d08c1f81557cbbcaa85237f72fc8b05e5651a444d0f431d745b5e03'
  core=captured.split('local make=(function()\n',1)[1].split('\nend)()\nlocal makeLogo=',1)[0]
  assert core==(WORK/'baseline-core.lua').read_text(encoding='utf-8'),'regressions do not use actual previous production core'
 else:
  assert captured==(WORK/'entry.native.lua').read_text(encoding='utf-8')
print('PASS actual old/new public boundaries: baseline provenance, exact native source, nil arguments/returns, corrupted payload rejection')
