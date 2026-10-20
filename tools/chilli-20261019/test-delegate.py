from pathlib import Path
import json, subprocess
root=Path(__file__).resolve().parents[2];repo=root
def literal(s):
 e='='
 while ']'+e+']' in s:e+='='
 return '['+e+'[\n'+s+']'+e+']'
public=(repo/'devil-steal-an-egg.lua').read_text(encoding='utf-8');entry=(repo/'devil-steal-an-egg-chilli-recovered-ui-test.lua').read_text(encoding='utf-8')
release=json.loads((root/'devil-steal-panel-rejoin-release.json').read_text())
test='local public='+literal(public)+'\nlocal reference='+literal(entry)+r'''
local nativeCompile=loadstring
local function setup(universe,place,corrupt,cache)
    local downloads,compiled={},0
    local state={DevilHubBlueGui={Version="devil-blue-20261019-10",Stopped=false}}
    local env={game={GameId=universe,PlaceId=place},task={wait=function()end},getgenv=function()return state end}
    local files={}
    if cache then
        env.isfile=function(name)return files[name]~=nil end
        env.readfile=function(name)return files[name]end
        env.writefile=function(name,value)files[name]=value end
    end
    function env.game:HttpGet(url)
        table.insert(downloads,url)
        if url:find('/loader?',1,true) then return 'main router source' end
        assert(url=='https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/GUI_COMMIT/devil-steal-an-egg-chilli-recovered-ui-test.lua','wrong latest entry pin')
        return corrupt and reference:sub(1,-2)..'x' or reference
    end
    env.loadstring=function(source,label)
        if source~=reference and source~='main router source'then local fn=assert(nativeCompile(source));setfenv(fn,env);return fn end
        compiled+=1
        assert(source==reference or source=='main router source','unexpected source reached native compiler')
        return function(...)return 'loaded',... end
    end
    setmetatable(env,{__index=getfenv(0)})
    local fn=assert(nativeCompile(public));setfenv(fn,env)
    return fn,downloads,function()return compiled end,files
end
for _,ids in ipairs({{10563114921,107778070777162},{10563114921,1},{0,107778070777162}}) do
    local run,downloads,compiled=setup(ids[1],ids[2])
    local result,a,b=run('sentinel',42)
    assert(result=='loaded' and a=='sentinel' and b==42 and #downloads==1 and compiled()==1,'map delegate lost arguments or ran twice')
end
local run,downloads,compiled=setup(10563114921,107778070777162,true)
local ok,err=pcall(run)
assert(not ok and tostring(err):find('checksum mismatch',1,true) and compiled()==0,'corrupted download reached runtime')
run,downloads,compiled=setup(1,2)
local result,arg=run('sentinel')
assert(result=='loaded' and arg=='sentinel' and downloads[1]:find('/loader?',1,true),'cross-map routing changed')
do
 local run,downloads,compiled,files=setup(10563114921,107778070777162,false,true)
 assert(run()=='loaded'and #downloads==1 and compiled()==1,'cache-enabled delegate cold load failed')
 assert(run()=='loaded'and #downloads==1 and compiled()==2,'actual delegate downloaded frontend again on warm load')
 local filename=next(files);assert(filename,'delegate did not save validated frontend')
 files[filename]='X'..files[filename]:sub(2)
 assert(run()=='loaded'and #downloads==2 and compiled()==3,'actual delegate trusted corrupted cache / failed fallback')
end
print('PASS main Steal an Egg VM delegate: universe/place mapping, native compile boundary, argument forwarding, transfer integrity and cross-map routing')
'''
test=test.replace('GUI_COMMIT',release['gui_commit'])
p=Path(__file__).resolve().parent/'test-main-entry.generated.luau';p.write_text(test,encoding='utf-8');subprocess.run([str(root.parent/'luau-tools/luau.exe'),str(p)],check=True)
