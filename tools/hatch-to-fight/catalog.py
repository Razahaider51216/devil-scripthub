from pathlib import Path
import json,hashlib,subprocess,re
ROOT=Path(__file__).resolve().parents[2];HERE=Path(__file__).resolve().parent
DUMP=Path(r'C:\Users\Administrator\Downloads\Devilv10\DevilDump_Dumps\ClientRuntimeV8\Run_20261022_014726_1')
runtime=json.loads(next(DUMP.glob('Runtime_*.json')).read_text(encoding='utf-8'))
providers=[];evidence={}
for row in runtime['scripts']:
    path=row['path']
    if not(path.startswith('ReplicatedStorage.HatchToFight.Config.') or path.startswith('ReplicatedStorage.Shared.')):continue
    name=row.get('sourceFile','').split('/')[-1]
    if not name or not (DUMP/name).exists():continue
    source=(DUMP/name).read_text(encoding='utf-8')
    evidence[path]={'file':name,'sha256':hashlib.sha256((DUMP/name).read_bytes()).hexdigest()}
    # Decompiler table literals can capture their own identifier before its local
    # binding exists. Restore the forward binding for offline data evaluation.
    recovered=re.sub(r'local (v_u_\d+) = \{',r'local \1; \1 = {',source)
    providers.append('providers['+json.dumps(path)+']=function(script,require,game,Color3,Vector3,Vector2,Enum)\n'+recovered+'\nend')
boot=r'''
local providers,cache,loading,nodes={},{},{},{}
local function warn(message)print("CATALOG WARNING: "..tostring(message))end
local known={}
local function node(path)
 if nodes[path]then return nodes[path]end
 local object={Path=path}
 nodes[path]=object
 return setmetatable(object,{__index=function(_,key)
  if key=="Name"then return path:match("[^.]+$")end
  if key=="Parent"then return node(path:match("^(.*)%.[^.]+$")or"")end
  if key=="IsA"then return function(_,class)return class=="ModuleScript"and providers[path]~=nil or class=="Folder"and providers[path]==nil end end
  if key=="GetChildren"then return function()
   local children={}
   for candidate in pairs(known)do if candidate:match("^(.*)%.[^.]+$")==path then table.insert(children,node(candidate))end end
   table.sort(children,function(a,b)return a.Path<b.Path end);return children
  end end
  if key=="WaitForChild"then return function(_,name)assert(known[path.."."..name],"Unknown offline dependency "..path.."."..name);return node(path.."."..name)end end
  if key=="FindFirstChild"then return function(_,name)return known[path.."."..name]and node(path.."."..name)end end
  if known[path.."."..key]then return node(path.."."..key)end
 end})
end
local visual
visual=function(...)return setmetatable({__visual=true},{__index=function(_,key)if key=="Lerp"then return function()return visual()end end;return visual end})end
local Color3={fromRGB=visual,fromHSV=visual,new=visual}
local Vector3={new=function(x,y,z)return {X=x,Y=y,Z=z,Unit={X=x,Y=y,Z=z}}end}
local Vector2=Vector3
local Enum=setmetatable({},{__index=function()return setmetatable({},{__index=function(_,key)return key end})end})
local game={GetService=function(_,name)assert(name=="ReplicatedStorage","Offline data loader forbids service "..name);return node(name)end}
local load
load=function(object)
 local path=object.Path
 if cache[path]then return cache[path]end
 assert(not loading[path],"cyclic offline data dependency "..path)
 assert(providers[path],"Missing offline data dependency "..path)
 loading[path]=true
 local ok,result=pcall(providers[path],object,load,game,Color3,Vector3,Vector2,Enum)
 loading[path]=nil
 assert(ok,result)
 cache[path]=result;return result
end
'''
tail=r'''
for path in pairs(providers)do
 local current=path
 while current~=""do known[current]=true;current=current:match("^(.*)%.[^.]+$")or""end
end
local function encode(value,seen)
 local kind=type(value)
 if kind=="string"then return string.format("%q",value):gsub("\\\n","\\n")end
 if kind=="number"then return value==value and math.abs(value)<math.huge and tostring(value)or"null"end
 if kind=="boolean"then return tostring(value)end
 if kind~="table"or value.__visual then return "null"end
 seen=seen or{};if seen[value]then return "null"end;seen[value]=true
 local out={}
 for k,v in pairs(value)do
  if type(v)~="function"and not(type(v)=="table"and v.__visual)then
   table.insert(out,encode(tostring(k))..":"..encode(v,seen))
  end
 end
 seen[value]=nil;table.sort(out);return "{"..table.concat(out,",").."}"
end
local output={}
for key,path in pairs(SELECTED)do output[key]=load(node(path))end
local progression=load(node("ReplicatedStorage.Shared.Progression"))
output.RebirthLevels={}
for i=0,1000 do output.RebirthLevels[i]=progression.rebirthLevel(i)end
print(encode(output))
'''
selected={'Stages':'ReplicatedStorage.HatchToFight.Config.Stages','Pets':'ReplicatedStorage.HatchToFight.Config.Pets',
 'Shop':'ReplicatedStorage.HatchToFight.Config.Shop','Rarities':'ReplicatedStorage.HatchToFight.Config.Rarities',
 'Rewards':'ReplicatedStorage.HatchToFight.Config.Rewards','Crates':'ReplicatedStorage.HatchToFight.Config.Crates',
 'Races':'ReplicatedStorage.HatchToFight.Config.Races','Tower':'ReplicatedStorage.HatchToFight.Config.Tower'}
for key in ['Training','Upgrades','Forge','Eggs','Progression','Economy','Shells']:selected[key]='ReplicatedStorage.Shared.Config.'+key
selection='{'+','.join('['+json.dumps(k)+']='+json.dumps(v)for k,v in selected.items())+'}'
path=HERE/'catalog.generated.luau';path.write_text(boot+'\n'+'\n'.join(providers)+'\nlocal SELECTED='+selection+'\n'+tail,encoding='utf-8',newline='\n')
result=subprocess.run([str(ROOT.parent/'luau-tools/luau.exe'),str(path)],capture_output=True,timeout=35)
if result.returncode:print(result.stderr.decode('utf-8'));result.check_returncode()
lines=result.stdout.decode('utf-8').splitlines()
for warning in lines[:-1]:print(warning)
data=json.loads(lines[-1])
assert len(data['Stages']['List'])==60
assert len(data['Pets']['List'])>100
(HERE/'catalog.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8',newline='\n')
(HERE/'evidence.json').write_text(json.dumps({'place_id':127231827405683,'universe_id':10768001644,'sources':evidence,'server_code_available':False,'live_verified':False},indent=2)+'\n',encoding='utf-8',newline='\n')
print('PASS offline catalog:',len(data['Stages']['List']),'stages,',len(data['Pets']['List']),'pets; no game execution')
