from pathlib import Path
import hashlib,json,re,subprocess,sys
ROOT=Path(__file__).resolve().parents[2]
HERE=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'tools/protection'))
from pack import native,pack,checksum,sha,WORK
RELEASE='kuydum-no-loader-20261022-2'
STATE=WORK/'kuydum-state.json'
state=json.loads(STATE.read_text())if STATE.exists()else{'release':RELEASE,'artifacts':{},'base_commit':subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip()}
state['release']=RELEASE
def gray(source):
    def rgb(m):
        r,g,b=map(int,m.groups());v=round(.2126*r+.7152*g+.0722*b)
        return f'Color3.fromRGB({v},{v},{v})'
    source=re.sub(r'Color3.fromRGB\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)',rgb,source)
    def color(m):
        text=m[1];r,g,b=(int(text[i:i+2],16)for i in (0,2,4));v=round(.2126*r+.7152*g+.0722*b)
        return '#'+f'{v:02X}'*3
    return re.sub(r'#([0-9A-Fa-f]{6})(?![0-9A-Fa-f])',color,source)
def branding(source):
    return(source.replace('DEVIL HUB','KUYDUM HUB').replace('https://discord.gg/fDwPCmpkkh','https://discord.gg/tCnZhrBcM')
        .replace('DevilHubPresentation','KuydumHubPresentation').replace('"^devilhub"','"^kuydumhub"')
        .replace('"devil-logo"','"kuydum-logo"').replace('"DevilHub_Silver"','"KuydumHubLogo"')
        .replace('text:sub(1,12)=="KUYDUM HUB / "','text:sub(1,13)=="KUYDUM HUB / "'))
def save(name,source):
    data=pack(source,name).replace(b'DEVIL HUB devil-all-games-obf-20261021-1',('KUYDUM HUB '+RELEASE).encode(),1);(ROOT/name).write_bytes(data)
    (WORK/(name+'.kuydum-native')).write_text(source,encoding='utf-8',newline='\n')
    state['artifacts'][name]={'public_sha256':sha(data),'native_sha256':sha(source.encode()),'bytes':len(data)}
def head():return subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip()
def url(ref,name):return 'https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/'+ref+'/'+name
stage=sys.argv[1]
if stage=='theme':
    original=native((ROOT/'devil-blue-gui.lua').read_text(encoding='utf-8'),'devil-blue-gui.lua')
    source=gray(branding(original)).replace('devil-blue-20261019-10','kuydum-mono-20261022-1')
    save('kuydum-theme.lua',source)
    logo=Path('C:/Users/Administrator/Downloads/kuydumhub.jpg').read_bytes()
    (ROOT/'assets/kuydumhub.jpg').write_bytes(logo)
    state['logo_sha256']=sha(logo);state['logo_bytes']=len(logo)
elif stage=='gui':
    state['theme_commit']=head()
    source=native((ROOT/'devil-steal-an-egg-chilli-recovered-ui-test.lua').read_text(encoding='utf-8'),'gui')
    source=gray(branding(source)).replace('devil-blue-20261019-10','kuydum-mono-20261022-1')
    data=(ROOT/'kuydum-theme.lua').read_bytes()
    source,n=re.subn(r'https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/[0-9a-f]{40}/devil-blue-gui.lua',url(state['theme_commit'],'kuydum-theme.lua'),source);assert n==1
    source,n=re.subn(r'(#source==)\d+(,"DEVIL blue GUI download size)',lambda m:m[1]+str(len(data))+m[2],source);assert n==1
    source,n=re.subn(r'(assert\(sum==)\d+(,"DEVIL blue GUI checksum)',lambda m:m[1]+str(checksum(data))+m[2],source);assert n==1
    source=source.replace('Theme="Abyss"','Theme={Background=Color3.fromRGB(8,8,8),Surface=Color3.fromRGB(16,16,16),Surface2=Color3.fromRGB(23,23,23),Surface3=Color3.fromRGB(38,38,38),Accent=Color3.fromRGB(235,235,235),Text=Color3.fromRGB(255,255,255),Muted=Color3.fromRGB(170,170,170),Stroke=Color3.fromRGB(60,60,60)}')
    source=re.sub(r'https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png\?logo=silver-20261011',url(state['theme_commit'],'assets/kuydumhub.jpg'),source)
    start=source.index('local loading=(function()')
    end=source.index('end)()("Steal an Egg")',start)+len('end)()("Steal an Egg")')
    source=source[:start]+'''-- No startup screen, percentage, tweens or input-blocking overlay.
local loading={Update=function()end,Finish=function()end,Fail=function(message)
    warn("KUYDUM HUB: "..tostring(message))
end}
'''+source[end:]
    assert 'Starting original systems...'in source
    assert 'scope.DevilHubLoadScreen'not in source
    save('kuydum-steal-gui.lua',source)
elif stage=='entry':
    state['gui_commit']=head()
    gui=(ROOT/'kuydum-steal-gui.lua').read_bytes()
    auto=(ROOT/'tools/auto-execute/bootstrap.lua').read_text(encoding='utf-8')
    auto=auto.replace('https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader?v=vm-1',url('refs/heads/main','kuydum-steal-an-egg.lua')+'?v='+RELEASE)
    auto=auto.replace('DevilHubAutoExecuteArrival','KuydumHubAutoExecuteArrival').replace('DEVIL HUB','KUYDUM HUB')
    source=(HERE/'entry.lua').read_text(encoding='utf-8')
    for key,value in {'__LOGO_URL__':url(state['theme_commit'],'assets/kuydumhub.jpg'),'__LOGO_BYTES__':str(state['logo_bytes']),
        '__GUI_URL__':url(state['gui_commit'],'kuydum-steal-gui.lua'),'__GUI_BYTES__':str(len(gui)),'__GUI_CHECKSUM__':str(checksum(gui)),
        '__AUTO_SOURCE__':json.dumps(auto,ensure_ascii=False)}.items():source=source.replace(key,value)
    save('kuydum-steal-an-egg.lua',source)
    state.update(discord='https://discord.gg/tCnZhrBcM',theme='monochrome',standalone=True,main_loader_changed=False,live_verified=False,architecture='VM startup / native gameplay callbacks',startup_screen=False,native_executor_api_inheritance=True)
    (ROOT/'kuydum-release.json').write_text(json.dumps(state,indent=2)+'\n',encoding='utf-8',newline='\n')
else:raise ValueError(stage)
STATE.write_text(json.dumps(state,indent=2)+'\n')
print('PASS KUYDUM build',stage)
