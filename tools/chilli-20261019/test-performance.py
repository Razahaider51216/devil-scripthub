from pathlib import Path
import json,re,subprocess
ROOT=Path(__file__).resolve().parents[2]
WORK=Path(__file__).resolve().parent
native=(WORK/'native-layer.generated.luau').read_text(encoding='utf-8')
manifest=json.loads((ROOT/'devil-chilli-native-ui-recovery.json').read_text())
assert native.count('devilUiBeat(')==3
assert native.count('(devilWebhookNames[')==6
assert manifest['game_bytecode_unchanged'] and not manifest['complete_vm_devirtualization']
helper=(WORK/'ui-performance.lua').read_text()
pattern=r'\(devilWebhookNames\[(?P<name>[obwS]\[G\])\]and devilWebhookLookup\((?P=name),E\[(?P=name)\]\)or E\[(?P=name)\]\)'
expressions=list(re.finditer(pattern,native));assert len(expressions)==6
actual_expression=expressions[0][0].replace(expressions[0]['name'],'name').replace('E[','host[')
fixture='local makeBeat=(function()\n'+helper+'\nend)()\n'+r'''
local checks=0
local function check(v,m)assert(v,m);checks+=1 end
local function signal()
 local s={}
 function s:Connect(fn)
  self.fn=fn;local c={Connected=true}
  function c:Disconnect()self.Connected=false end
  self.connection=c;return c
 end
 function s:Fire(dt)if self.connection.Connected then self.fn(dt)end end
 return s
end
local function object(kind,parent)
 return{Parent=parent,Visible=true,Enabled=true,IsA=function(_,k)return k==kind end}
end
local screen=object('ScreenGui');local root=object('GuiObject',screen)
local s=signal();local calls,total=0,0
local connection=makeBeat(s,root,function(dt)calls+=1;total+=dt end)
for _=1,240 do s:Fire(1/240)end
check(calls>=25 and calls<=30,'visible presentation callback exceeds 30Hz')
check(math.abs(total-1)<.04,'throttling lost elapsed animation time')
screen.Enabled=false;calls=0;total=0
for _=1,480 do s:Fire(1/240)end
check(calls<=13,'hidden presentation callback was not throttled')
calls=0
for _=1,240 do s:Fire(1/240)end
check(calls<=4,'settled hidden UI exceeds four updates per second')
screen.Enabled=true;calls=0
for _=1,240 do s:Fire(1/240)end
check(calls>=20 and calls<=30,'showing UI does not resume presentation updates')
root.Parent=object('Folder');calls=0
for _=1,480 do s:Fire(1/240)end
check(calls<=13,'unparented controller backing renders at full rate')
connection:Disconnect();local before=calls;s:Fire(1)
check(calls==before,'disconnect leaks the presentation callback')
local webhookCalls=0
local devilWebhookNames={request=true,http_request=true,httprequest=true,syn=true,http=true,fluxus=true}
local function devilWebhookLookup(name,value)webhookCalls+=1;return value end
local host={game={},flag=false,request=function()return 'ok' end}
local function guarded(name)return __ACTUAL_VM_READ__ end
local identity=true
for _=1,100000 do if guarded('game')~=host.game then identity=false end end
check(identity,'normal VM global identity changed')
check(webhookCalls==0,'normal VM global reads still call the branding adapter')
check(guarded('flag')==false and guarded('missing')==nil,'false or nil VM globals changed')
check(guarded('request')==host.request and webhookCalls==1,'request alias bypasses branding adapter')
print('PASS presentation scheduling / VM read fast path checks:',checks)
'''
fixture=fixture.replace('__ACTUAL_VM_READ__',actual_expression)
path=WORK/'test-performance.generated.luau';path.write_text(fixture,encoding='utf-8',newline='\n')
subprocess.run([str(ROOT.parent/'luau-tools/luau.exe'),str(path)],check=True)
print('PASS three scoped presentation hooks, six VM global fast paths; native game-data bytes preserved')
