from pathlib import Path
import json, subprocess

root = Path(__file__).resolve().parents[2]
audit = json.loads((root / 'devil-blue-gui-router-audit.json').read_text(encoding='utf-8'))
source = (root / 'loader').read_text(encoding='utf-8')
eq = '='
while ']' + eq + ']' in source:
    eq += '='
definitions = '{' + ','.join('{' + str(row['Universe']) + ',' + str(row['Place']) + ',' + json.dumps(row['File']) + ','
    + json.dumps(row.get('Commit', audit['game_entries_commit'])) + ',' + json.dumps(row.get('Version', '')) + '}' for row in audit['routes']) + '}'
fixture = 'local public=[' + eq + '[' + source + ']' + eq + ']\nlocal definitions=' + definitions + '\n' + r'''
local nativeCompile=loadstring
local function setup(universe,place,failures)
 local env,state,downloads={},{},{}
 state.DevilHubBlueGui={Version='devil-blue-20261019-10',Stopped=false}
 local loading={SetLogo=function()end,Update=function()end,Finish=function()end,Fail=function()end}
 state.DevilHubLoadController={Acquire=function()return loading end,IsActive=function()return true end}
 env.game={GameId=universe,PlaceId=place,Loaded={Wait=function()end}}
 function env.game:IsLoaded()return true end
 function env.game:HttpGet(url)
  table.insert(downloads,url)
  if #downloads<=(failures or 0)then error('network failed')end
  return "return 'route-ok',..."
 end
 state.DevilBreakExecutorContext={Version='break-executor-compat-19',Game=env.game}
 env.getgenv=function()return state end
 env.task={wait=function()end,spawn=function()end,defer=function()end,delay=function()end}
 env.warn=function()end;env.print=function()end
 env.loadstring=function(code,label)
  local fn,err=nativeCompile(code,label)
  if fn then setfenv(fn,env)end
  return fn,err
 end
 setmetatable(env,{__index=getfenv(0)})
 local fn=assert(nativeCompile(public));setfenv(fn,env)
 return fn,state,downloads
end
local cases=0
for _,entry in ipairs(definitions)do
 for _,ids in ipairs({{entry[1],entry[2]},{entry[1],1},{0,entry[2]}})do
  local run,state,downloads=setup(ids[1],ids[2])
  local result,first,second=run('sentinel',42)
  assert(result=='route-ok'and first=='sentinel'and second==42,'arguments/returns changed')
  assert(#downloads==1 and downloads[1]:find('/'..entry[4]..'/'..entry[3]..'?hub=',1,true),'map or immutable release pin changed')
  if entry[5]~=''then assert(downloads[1]:find('?hub='..entry[5],1,true),'per-game version changed')end
  assert(state.DevilHubRouterLoading==false,'router busy state leaked')
  cases+=1
 end
end
local run,state,downloads=setup(definitions[1][1],1,2)
assert(run()=='route-ok'and #downloads==3,'download retries changed')
run,state,downloads=setup(definitions[1][1],1,3)
local ok,err=pcall(run)
assert(not ok and #downloads==3 and not state.DevilHubRouterLoading and tostring(err):find('download failed',1,true),'failure cleanup changed')
run,state,downloads=setup(1,2)
ok=pcall(run);assert(not ok and #downloads==0,'unsupported map downloaded a game')
run,state,downloads=setup(definitions[1][1],1)
state.DevilHubRouterLoading=true
assert(run()==nil and #downloads==0,'busy router relaunched')
run,state,downloads=setup(10563114921,1)
state.DevilChilliMainUI={}
assert(run()==nil and #downloads==0,'existing Steal GUI relaunched')
local anime=definitions[#definitions]
if anime[3]=='anime-dice-test.lua'then
 run,state,downloads=setup(anime[1],1)
 local app={Version=anime[5],Stopped=false};state.DevilAnimeDiceTest=app
 assert(run()==app and #downloads==0,'current Anime GUI relaunched / redownloaded')
 run,state,downloads=setup(anime[1],1)
 state.DevilAnimeDiceTest={Version='older-release',Stopped=false}
 assert(run()=='route-ok'and #downloads==1,'older Anime release blocked an update')
 run,state,downloads=setup(anime[1],1)
 state.DevilAnimeDiceStarting={At=os.clock()}
 assert(run()==nil and #downloads==0,'Anime startup guard redownloaded')
end
print('PASS actual public router: '..cases..' universe/place cases across '..#definitions..' games, immutable pins, retries, errors, arguments and session guards')
'''
fixture = fixture.replace('GAME_PIN', audit['game_entries_commit'])
path = Path(__file__).with_suffix('.generated.luau')
path.write_text(fixture, encoding='utf-8', newline='\n')
subprocess.run([str(root.parent / 'luau-tools/luau.exe'), str(path)], check=True)
