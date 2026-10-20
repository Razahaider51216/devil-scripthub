from pathlib import Path
import hashlib, json, subprocess

root=Path(__file__).resolve().parents[2]
here=Path(__file__).resolve().parent
fixture=(root/'tests/blue-gui-mocks.luau').read_text(encoding='utf-8')
checks=(root/'tests/break-language-checks.luau').read_text(encoding='utf-8')
for marker,path in [('MODULE','devil-blue-gui.lua'),('NATIVE LANGUAGE','tests/fixtures/break-native-language.lua'),
                    ('BRIDGE','tools/blue-gui/break-language.lua')]:
    checks=checks.replace('-- '+marker+' INSERTED HERE',(root/path).read_text(encoding='utf-8'))
path=here/'break-language-test.generated.luau'
path.write_text(fixture+checks,encoding='utf-8',newline='\n')
subprocess.run([str(root.parent/'luau-tools/luau.exe'),str(path)],check=True,timeout=25)

manifest_path=root/'break-language-release.json'
if manifest_path.exists():
    manifest=json.loads(manifest_path.read_text(encoding='utf-8'))
    def literal(value):
        eq='='
        while ']'+eq+']' in value:eq+='='
        return '['+eq+'['+value+']'+eq+']'
    artifacts=[]
    for name,record in manifest['entries'].items():
        source=(root/name).read_text(encoding='utf-8')
        assert hashlib.sha256(source.encode()).hexdigest()==record['public_sha256']
        body=source.split('-- END BREAK LANGUAGE SYNC\n',1)[1]
        assert hashlib.sha256(body.encode()).hexdigest()==record['engine_body_sha256']
        artifacts.append('{'+json.dumps(name)+','+literal(source)+'}')
    fixture='local artifacts={'+','.join(artifacts)+'}\n'+r'''
local compile=loadstring
for _,artifact in ipairs(artifacts)do
 local selected={Language='EN'}
 local owner={Version='devil-blue-20261019-10',Stopped=false,Get=function()return table.clone(selected)end,
  Set=function(values)if values.Language then selected.Language=values.Language end;return table.clone(selected)end,
  Destroy=function()end}
 owner.SetLanguage=function(value)return owner.Set({Language=value})end
 local nativeCalls,entered,downloads=0,0,0
 local scope={DevilHubBlueGui=owner,DevilBreakSettings={SetLanguage=function(value)assert(value=='EN');nativeCalls+=1 end}}
 local env={game={GameId=10765288803,PlaceId=114326934417838},getgenv=function()return scope end,
  task={wait=function()end},warn=function()end}
 function env.game:HttpGet()downloads+=1;error('unexpected download at native startup boundary')end
 env.loadstring=function(source,label)
  if label and label:find('DEVIL HUB / native ',1,true)then
   entered+=1
   return function(...)return 'NATIVE BOUNDARY',... end
  end
  local fn,err=compile(source,label)
  if fn then setfenv(fn,env)end
  return fn,err
 end
 setmetatable(env,{__index=getfenv(0)})
 local run=assert(compile(artifact[2]));setfenv(run,env)
 local value,arg,count=run('sentinel',42)
 assert(value=='NATIVE BOUNDARY'and arg=='sentinel'and count==42,'public entry changed original returns/arguments: '..artifact[1])
 assert(entered==1 and downloads==0 and nativeCalls==1 and scope.DevilBreakLanguage=='EN','Break language prelude missing or game startup executed: '..artifact[1])
 scope.DevilBreakLanguageSync.Destroy()
end
print('PASS both actual Break entry bootstraps: language synchronization, unchanged engine bodies, native boundary and original arguments')
'''
    path=here/'break-language-entries-test.generated.luau'
    path.write_text(fixture,encoding='utf-8',newline='\n')
    subprocess.run([str(root.parent/'luau-tools/luau.exe'),str(path)],check=True,timeout=30)
