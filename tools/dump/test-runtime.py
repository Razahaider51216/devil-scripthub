from pathlib import Path
import ast, base64, hashlib, json, re, subprocess, runpy

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
restored=runpy.run_path(str(HERE/'startup-patch.py'))['restore'](source[:start]+old_module+source[end:]).replace('devil-dump.lua?v='+metadata['release'],'devil-dump.lua?v=dump-13-client-start-20261022-1')
assert restored==old,'Native code outside V8 module changed'
results=['PASS exact public/native integrity; only declared V8 and startup changes']
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
    # Even a legacy enabled export flag cannot cause game-module execution.
    enabled=fixture.replace('local capture=Runtime.New(deps)','local capture=Runtime.New(deps)\ncapture.LoadedExports=true;capture.ListLoadedModules=true;capture.GCFunctions=true',1)
    run(name+'-updated',enabled.replace('require("./runtime-capture")','(function()\n'+new_module+'\nend)()',1))
fixture=(HERE/'test-runtime-diagnostics.luau').read_text(encoding='utf-8')
run('v8-public-diagnostics',fixture.replace('require("./runtime-capture")','(function()\n'+new_module+'\nend)()',1))
previous_public=subprocess.check_output(['git','show','78a758a:devil-dump.lua'],cwd=ROOT).decode('utf-8')
_,_,previous_module=module(ns['unpack'](previous_public).decode('utf-8'))
regression='''
local node={Name="completeIndex",ClassName="ModuleScript",Source="return {}"}
function node:IsA(kind)return kind=="ModuleScript"end
function node:GetFullName()return "ReplicatedStorage.CmdrClient.Commands.completeIndex"end
local files,required,report={},0,nil
local deps={Game={PlaceId=107778070777162,GameId=1,GetService=function(_,name)
 if name=="ReplicatedStorage"then return {GetDescendants=function()return {node}end}end
end},Alive=function()return true end,Spawn=function(fn)fn()end,Wait=function()end,
Date=function()return "test"end,Typeof=type,JSON=function(value)report=value;return "json"end,
APIs={getloadedmodules=function()return {node}end,
 require=function(item)assert(item==node);required+=1;error("simulated module side effect")end,
 writefile=function(path,value)files[path]=value end,makefolder=function()end,isfolder=function()return true end}}
local capture=Runtime.New(deps)
capture.LoadedExports=true;capture.ListLoadedModules=true
capture:Start()
if Runtime.ModuleExecution==false then
 assert(required==0 and report.counts.scripts==1 and report.counts.source==1)
 assert(report.scripts[1].loadedModule==true and report.scripts[1].loadedExport==nil)
 print("PASS completeIndex source retained; metadata and legacy enabled flags never require game module")
else
 assert(required==1 and report.scripts[1].loadedExportError:find("simulated module side effect",1,true))
 print("PASS reproduced previous V8 require call on reported completeIndex path (simulated side effect)")
end
'''
run('v8-require-before','local Runtime=(function()\n'+previous_module+'\nend)()\n'+regression)
run('v8-require-after','local Runtime=(function()\n'+new_module+'\nend)()\n'+regression)
def handler(text,number):
    begin=text.index('handlers['+str(number)+'] = function')
    end=text.index('\nhandlers[',begin+1)
    return text[begin:end]
startup_patch=runpy.run_path(str(HERE/'startup-patch.py'))
for version,text,expected in [('before',old,3),('after',source,0)]:
    # Execute the real former delayed handler with an unset AntiAFK setting.
    # The new build must have no call site scheduling it.
    schedule=startup_patch['DELAYED_APPLY'] if version=='before' else startup_patch['NO_DELAY']
    assert schedule in text
    if version=='after':assert text.count('handlers[60899949]')==1
    fixture='''local handlers={}
local queue,calls={},{}
local script_env={task={delay=function(_,fn)table.insert(queue,fn)end}}
local function bind_handler(fn,values)return function()return fn(values)end end
local settings={WalkSpeed=32,JumpPower=50,Noclip=false}
local api={setAntiAfk=function(v)table.insert(calls,"anti-afk")end,
 updateSpeed=function(v)table.insert(calls,"speed")end,updateJump=function(v)table.insert(calls,"jump")end}
local decoded_local_118={[11]={settings},[12]={api}}
local decoded_local_119={}
'''+handler(text,60899949)+'\n'+schedule+'''
for _,fn in ipairs(queue)do fn()end
assert(#calls==EXPECTED,"unexpected automatic player actions")
api.updateSpeed(24);assert(#calls==EXPECTED+1,"explicit player action unavailable")
print("PASS STARTUP_CASE delayed player actions: EXPECTED; explicit action retained")
'''
    run('startup-actions-'+version,fixture.replace('EXPECTED',str(expected)).replace('STARTUP_CASE',version))
    flag=text.index('decoded_local_119[25].flag = "AntiAFK"')
    begin=text.rfind('\tdecoded_local_119[27] = ',0,flag)
    expression=text[begin:flag].splitlines()[0].strip()
    default_fixture='''local decoded_local_119={[28]=nil}
'''+expression+'''
assert(decoded_local_119[27]==EXPECTED)
print("PASS STARTUP_CASE unset AntiAFK default: EXPECTED")
'''
    run('startup-default-'+version,default_fixture.replace('EXPECTED','true' if version=='before' else 'false').replace('STARTUP_CASE',version))
    begin=text.index('        local window=result[1]\n')
    end=text.index('        local ui=flow:CreateWindow',begin)
    window_setup=text[begin:end]
    # These are the two actual Show() guards in the pinned Rayfield controller.
    show_fixture='''local loaded=0
local window={configuration={autoLoad=true},settings={configAutoLoad="old-profile"},Load=function()loaded+=1 end}
local result,oldWindows={window},{}
'''+window_setup+'''
local function show(self)
 if self.configuration.autoLoad and not self._autoLoaded then
  self._autoLoaded=true;pcall(self.Load,self)
 end
 if self.settings.configAutoLoad and not self._autoLoadedNamed then
  self._autoLoadedNamed=true;pcall(self.Load,self,self.settings.configAutoLoad)
 end
end
show(window);show(window)
assert(loaded==EXPECTED,"unexpected native-window auto profile application")
assert(window.settings.configAutoLoad=="old-profile","deleted saved setting")
window:Load("manual-profile");assert(loaded==EXPECTED+1,"explicit profile Load unavailable")
print("PASS STARTUP_CASE native-window automatic Load calls: EXPECTED; manual Load retained")
'''
    run('startup-window-'+version,show_fixture.replace('EXPECTED','2' if version=='before' else '0').replace('STARTUP_CASE',version))
(ROOT/'devil-dump-validation.json').write_text(json.dumps({
    'release':metadata['release'],'entry_sha256':metadata['entry_sha256'],
    'live_verified':False,'kick_root_cause_confirmed':False,'results':results,
    'limits':'No live Roblox/Delta test; synchronous executor API calls cannot be forcibly timed out or guaranteed not to disconnect.'
},indent=2)+'\n',encoding='utf-8',newline='\n')
print(results[0])
