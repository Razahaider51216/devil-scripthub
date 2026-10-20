from pathlib import Path
import subprocess
ROOT=Path(__file__).resolve().parents[2]
WORK=Path(__file__).resolve().parent
native=(WORK/'native-layer.generated.luau').read_text(encoding='utf-8')
def factory(number):
    start=native.index(f'end,[{number}]=function')+len(f'end,[{number}]=')
    end=native.index('end,[',start)+3
    return native[start:end]
fixture='local discordFactory='+factory(12)+'\nlocal teleportFactory='+factory(1032)+'\n'+r'''
local checks=0
local function check(v,m)assert(v,m);checks+=1 end
local copied,downloads,executed,queued=0,{},0,{}
local setclipboard=function()copied+=1 end
local toclipboard=setclipboard
local state={};local settings={__ChilliAutoLoadScriptEnabled=true}
local teleport={SetTeleportSetting=function(_,name,value)settings[name]=value end,
 GetTeleportSetting=function(_,name)return settings[name]end}
local game={GetService=function(_,name)assert(name=='TeleportService');return teleport end,
 IsLoaded=function()return true end,HttpGet=function(_,url)table.insert(downloads,url);return'return true'end}
local task={spawn=function(fn)fn()end,defer=function(fn)fn()end,wait=function()end}
local getgenv=function()return state end
local _G={}
local queue_on_teleport=function(code)table.insert(queued,code)end
local env=setmetatable({setclipboard=setclipboard,toclipboard=toclipboard,game=game,task=task,
 getgenv=getgenv,_G=_G,queue_on_teleport=queue_on_teleport,
 loadstring=function()return function()executed+=1 end end},{__index=getfenv(0)})
setfenv(discordFactory,env);setfenv(teleportFactory,env)
discordFactory()({})()
check(copied==0 and #downloads==0,'startup Discord initializer copies or downloads automatically')
local spec
local group={CreateToggle=function(_,config)spec=config;error('capture-done')end}
local function initialize()
 spec=nil
 local ok,err=pcall(teleportFactory({})({teleport,{},group}))
 check(not ok and tostring(err):find('capture-done',1,true)and spec~=nil,'native auto-load factory was not reached')
 return spec
end
spec=initialize()
check(settings.__ChilliAutoLoadScriptEnabled==false,'legacy Chilli rejoin flag survives startup')
spec.Callback(true)
check(#queued==1 and settings.__DevilHubStealAutoLoadEnabled==true,'fallback does not queue DEVIL main loader')
check(queued[1]:find('Razahaider51216/devil-scripthub/refs/heads/main/loader?v=vm-1',1,true)~=nil,'fallback queues an upstream or wrong loader')
check(not queued[1]:find('tienkhanh1',1,true),'fallback still contains upstream Chilli loader')
spec.Callback(true);check(#queued==1,'repeated enable queues duplicate loaders')
spec.Callback(false);check(settings.__DevilHubStealAutoLoadEnabled==false,'disable leaves standalone fallback enabled')
local nativeCompile=loadstring
local arrival=assert(nativeCompile(queued[1]));setfenv(arrival,env);arrival()
check(#downloads==0 and executed==0,'disabled fallback runs after arrival')
spec.Callback(true);arrival()
check(#downloads==1 and executed==1 and copied==0,'enabled arrival does not load DEVIL main or touches clipboard')
queued={};state.DevilHubAutoExecute={Version='devil-auto-execute-1',Link={}}
spec=initialize();spec.Callback(true)
check(#queued==0,'native queue duplicates existing DEVIL Auto Execute listener')
state.DevilHubAutoExecute={Version='devil-auto-execute-1',Queued=true}
spec.Callback(true);check(#queued==0,'native queue duplicates already queued DEVIL loader')
check(copied==0,'startup/rejoin overwrites clipboard')
print('PASS actual startup / rejoin / clipboard checks:',checks)
'''
path=WORK/'test-rejoin-clipboard.generated.luau';path.write_text(fixture,encoding='utf-8',newline='\n')
subprocess.run([str(ROOT.parent/'luau-tools/luau.exe'),str(path)],check=True)
assert 'M[38].Enabled=false;M[19].obj1=M[38];'in native
assert 'h.Enabled=true;task.spawn(function()for n=1,4,1 do'not in native
assert 'local function q()local v=setclipboard or toclipboard;'in native,'explicit Discord copy button removed'
print('PASS original main window disabled at creation/open; explicit Discord button preserved')
