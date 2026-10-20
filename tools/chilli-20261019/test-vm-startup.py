"""Exercise the actual pre-GUI interpreters with a bounded, inert host.

No network, Roblox instance creation, remotes, or game actions are available.
The compatibility fixture intentionally cannot satisfy all Roblox probes; it
must yield and terminate with the startup diagnostic instead of spinning.
"""
from pathlib import Path
import json, subprocess

root=Path(__file__).resolve().parents[2]
here=Path(__file__).resolve().parent

def literal(value):
    eq='='
    while ']'+eq+']' in value: eq+='='
    return '['+eq+'['+value+']'+eq+']'

native=(here/'native-layer.generated.luau').read_text(encoding='utf-8')
native=native[native.index('return setmetatable({[107]=buffer.writeu8'):]
assert native.count('if devilTicks%512==0 then devilVmCheckpoint(')==8
fixture='local helperSource='+literal((here/'vm-startup.lua').read_text(encoding='utf-8'))+'\n'
fixture+='local nativeSource='+literal(native)+'\n'
# Decimal escapes preserve non-ASCII game-data bytes in UTF-8 source files.
fixture+='local data="'+''.join('\\%03d'%b for b in (root/'analysis/chilli-20261019/game-bytecode.bin').read_bytes())+'"\n'
fixture+=r'''
local checks=0
local function check(value,message)checks+=1;assert(value,message)end
local base=getfenv()
local now,waits,events=0,0,{}
local host=setmetatable({os={clock=function()return now end},task={wait=function()waits+=1;now+=.02 end}},{__index=base})
local helper=assert(loadstring(helperSource));setfenv(helper,host)
local function stage(name,detail)events[#events+1]={name,detail}end
local checkpoint=helper()(stage)
now=.003;checkpoint('6324',98,1,20)
check(waits==0,'fast dispatch yielded unnecessarily')
now=.005;checkpoint('6324',98,512,30)
check(waits==1,'VM did not release the scheduler after its CPU budget')
now+=.003;checkpoint('4201',115,1024,40)
check(waits==1,'yield time consumed the next CPU slice')
now=1.1;checkpoint('6324',37,443,137)
check(#events==1 and events[1][1]=='VM initialization','VM location was not reported')
check(events[1][2].PC==443 and events[1][2].Dispatches==2048,'VM location/count incorrect')
now=120
local ok,err=pcall(checkpoint,'6324',37,443,137)
check(not ok and tostring(err):find('exceeded 120s',1,true),'startup deadline failed')
check(events[#events][1]=='VM startup timed out','timeout was not recorded')
check(not pcall(checkpoint,'6324',37,444,138),'timed out interpreter resumed')
local fresh=helper()(stage)
fresh('finish');now=1000;local before=waits;fresh('6324',37,443,137)
check(waits==before,'finished startup still intercepted gameplay')
host.task={};now=0;local missing=helper()(stage);now=.005
ok,err=pcall(missing,'6324',98,1,1)
check(not ok and tostring(err):find('task.wait',1,true),'missing scheduler could busy-loop')

-- Run the released native interpreter instruction loops. Optional executor and
-- Roblox APIs are deliberately absent; the code cannot contact a game/server.
local ticks,vmYields,phases,lastDetail=0,0,{},nil
local guardHost=setmetatable({os={clock=function()ticks+=.1;return ticks end},
 task={wait=function()vmYields+=1;coroutine.yield('VM_SLICE')end}},{__index=base})
local make=assert(loadstring(helperSource));setfenv(make,guardHost)
local guard=make()(function(name,detail)phases[name]=true;lastDetail=detail end)
local function unavailable()error('OFFLINE HOST API',0)end
local api={new=unavailable}
local env=setmetatable({task={cancel=unavailable,wait=unavailable,spawn=unavailable,defer=unavailable,delay=unavailable},
 Vector3=api,Vector2=api,UDim2=api,UDim=api,Color3=api,Rect=api,
 devilVmCheckpoint=guard,devilStartupStage=function(name)phases[name]=true end},{__index=base})
local identity=env.task
local run=assert(loadstring(nativeSource,'Luraph'));setfenv(run,env)
local clock=os.clock()
local worker=coroutine.create(function()return pcall(function()local entry=run(buffer.fromstring(data));entry()end)end)
local result=table.pack(coroutine.resume(worker))
while coroutine.status(worker)~='dead'do
    assert(result[1]and result[2]=='VM_SLICE','VM failed to suspend at scheduler checkpoint')
    result=table.pack(coroutine.resume(worker))
end
assert(result[1],'VM coroutine failed: '..tostring(result[2]))
ok,err=result[2],result[3]
check(not ok and tostring(err):find('exceeded 120s',1,true),'actual VM bypassed startup deadline: '..tostring(err))
check(vmYields>100,'actual VM dispatch loops did not yield')
check(phases['VM bytecode reader']and phases['VM game entry']and phases['VM startup timed out'],'actual VM phase boundaries missing')
check(lastDetail.Method=='6324'and type(lastDetail.PC)=='number'and type(lastDetail.Opcode)=='number','actual VM location missing')
check(env.task==identity and env.loadstring==base.loadstring and env.getfenv==base.getfenv,'executor global identity changed')
print('PASS actual pre-GUI VM: '..lastDetail.Dispatches..' dispatches, '..vmYields..' scheduler yields, bounded timeout; CPU '..string.format('%.3f',os.clock()-clock)..'s')
print('PASS VM startup scheduler: '..checks..' checks; live Arceus X remains unverified')
'''
path=here/'vm-startup-test.generated.luau'
path.write_text(fixture,encoding='utf-8',newline='\n')
result=subprocess.run([str(root.parent/'luau-tools/luau.exe'),str(path)],capture_output=True,text=True,timeout=15)
print(result.stdout,end='')
if result.returncode:
    print(result.stderr,end='')
    result.check_returncode()
validation_path=root/'devil-steal-panel-rejoin-validation.json'
validation=json.loads(validation_path.read_text(encoding='utf-8'))
validation.update(vm_startup_checks=15,vm_startup_result=result.stdout.strip(),live_arceus_verified=False)
validation_path.write_text(json.dumps(validation,indent=2)+'\n',encoding='utf-8',newline='\n')
