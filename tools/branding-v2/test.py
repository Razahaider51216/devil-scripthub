from pathlib import Path
import hashlib,importlib.util,json,re,subprocess
from PIL import Image,ImageDraw

ROOT=Path(__file__).resolve().parents[2];HERE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('brand_build',HERE/'build.py')
build=importlib.util.module_from_spec(spec);spec.loader.exec_module(build)
WORK=build.WORK
results=[]
def run(name,source):
    path=WORK/(name+'.generated.luau');path.write_text(source,encoding='utf-8',newline='\n')
    result=subprocess.run([str(build.pack.CLI),str(path)],capture_output=True,text=True,encoding='utf-8',timeout=50)
    if result.returncode:print(result.stdout);print(result.stderr);result.check_returncode()
    print(result.stdout.strip());results.append(result.stdout.strip())
mocks=(ROOT/'tests/blue-gui-mocks.luau').read_text(encoding='utf-8')
module=build.pack.native((ROOT/'devil-blue-gui.lua').read_text(encoding='utf-8'),'devil-blue-gui.lua')
assert hashlib.sha256(module.encode()).hexdigest()==build.state()['shared_native_sha256']
checks=(ROOT/'tests/blue-gui-checks.luau').read_text(encoding='utf-8').replace('-- NATIVE TRANSITIONS INSERTED HERE',(ROOT/'tests/blue-gui-native-minimize.luau').read_text(encoding='utf-8'))
run('shared',mocks+checks.replace('-- MODULE INSERTED HERE',module))
audit=json.loads((ROOT/'devil-blue-gui-router-audit.json').read_text())
defs='local routes={'+','.join('{Universe='+str(r['Universe'])+',Place='+str(r['Place'])+',File='+json.dumps(r['File'])+'}'for r in audit['routes'])+'}\n'
checks=(ROOT/'tests/blue-gui-desktop-startup.luau').read_text(encoding='utf-8')
run('platforms',mocks+defs+checks.replace('-- MODULE INSERTED HERE',module))
checks=(ROOT/'tests/blue-gui-wave-checks.luau').read_text(encoding='utf-8')
run('wave',mocks+checks.replace('-- MODULE INSERTED HERE',module))
checks=(HERE/'brand-tests.luau').read_text(encoding='utf-8')
run('brand',mocks+'\nlocal makeBrand=(function()\n'+build.runtime()+'\nend)()\n'+checks)
# Render exactly the native rectangles, rather than an unrelated font glyph.
im=Image.new('RGB',(320,320),'#07090D');draw=ImageDraw.Draw(im)
for x,y,w,h,c in build.vector_rects():draw.rectangle((x*5,y*5,(x+w)*5-1,(y+h)*5-1),fill=['#F5FBFF','#61D4FF','#FFFFFF'][c-1])
im.save(WORK/'custom-d-preview.png')
m=build.state()
if 'entries_commit'in m:
    data=(ROOT/'devil-blue-gui.lua').read_text(encoding='utf-8')
    prelude=(ROOT/'anime-dice-test.lua').read_text(encoding='utf-8').split('-- END DEVIL BRAND V2\n',1)[0]+'-- END DEVIL BRAND V2\n'
    boot='''local checks=0
local function check(v,message)assert(v,message);checks+=1 end
local source=SOURCE
local scope={DevilHubBlueGui={Version="devil-blue-20261019-10"}}
local getgenv=function()return scope end
local downloads,compiles=0,0
local response=source
local game={HttpGet=function(_,url)
 check(url=="URL","wrong shared module pin")
 downloads+=1;return response
end}
local loadstring=function(text,label)
 check(text==source and label=="DEVIL HUB / brand v2","wrong compilation boundary")
 compiles+=1
 return function()scope.DevilHubBlueGui={BrandingVersion="devil-brand-v2-20261022-2",Stopped=false}end
end
local function start()
PRELUDE
end
start();check(downloads==1 and compiles==1,"old theme skipped branding upgrade")
start();check(downloads==1 and compiles==1,"direct entries duplicated shared startup")
scope.DevilHubBlueGui.Stopped=true;start();check(downloads==2 and compiles==2,"stopped theme was reused")
scope.DevilHubBlueGui=nil;response=source:sub(1,-2)
check(not pcall(start)and compiles==2,"truncated module compiled")
response=source:sub(1,-2)..(source:sub(-1)=="x"and"y"or"x")
check(not pcall(start)and compiles==2,"corrupted module compiled")
response=source;start();check(compiles==3,"valid startup did not recover")
print("PASS branding bootstrap pin, integrity, old-theme upgrade, deduplication and recovery: "..checks.." checks")
'''.replace('URL','https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/'+m['shared_commit']+'/devil-blue-gui.lua').replace('PRELUDE',prelude).replace('SOURCE',build.pack.literal(data))
    run('bootstrap',boot)
    for name,row in m['entries'].items():
        data=(ROOT/name).read_bytes();marker=b'-- END DEVIL BRAND V2\n';assert data.count(marker)==1,name
        original=data.split(marker,1)[1]
        assert hashlib.sha256(original).hexdigest()==row['before_sha256'],name
        assert hashlib.sha256(data).hexdigest()==row['after_sha256'],name
    old=json.loads(build.git('devil-blue-gui-router-audit.json'))['routes']
    for a,b in zip(old,audit['routes']):assert {k:v for k,v in a.items()if k!='Commit'}=={k:v for k,v in b.items()if k!='Commit'}
    loader=build.pack.native((ROOT/'loader').read_text(),'loader')
    assert hashlib.sha256(loader.encode()).hexdigest()==m['loader_native_sha256']
    print('PASS 17 direct entries preserve original payload bytes; 12 route IDs and versions unchanged')
assert (ROOT/'assets/devilhubv2.png').read_bytes()==(ROOT.parent/'devilhubv2.png').read_bytes()
validation={'release':build.RELEASE,'live_verified':False,'results':results,'shared_native_sha256':hashlib.sha256(module.encode()).hexdigest(),
    'vector_rectangles':len(build.vector_rects()),'checks':sum(int(n)for result in results for n in re.findall(r'(\d+) checks',result))}
(ROOT/'devil-branding-v2-validation.json').write_text(json.dumps(validation,indent=2)+'\n',encoding='utf-8',newline='\n')
