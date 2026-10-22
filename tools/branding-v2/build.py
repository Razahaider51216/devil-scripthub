"""Brand all production routes without changing their existing gameplay payloads."""
from pathlib import Path
import hashlib,importlib.util,json,re,subprocess,sys,xml.etree.ElementTree as ET

ROOT=Path(__file__).resolve().parents[2]
HERE=Path(__file__).resolve().parent
WORK=ROOT.parent/'devil-branding-v2-build'
WORK.mkdir(exist_ok=True)
RELEASE='devil-brand-v2-20261022-1'
BASELINE='0a2bdfc'
ASSETS='de20eac'
spec=importlib.util.spec_from_file_location('brand_pack',ROOT/'tools/protection/pack.py')
pack=importlib.util.module_from_spec(spec);spec.loader.exec_module(pack)
pack.RELEASE=RELEASE
def sha(data):return hashlib.sha256(data).hexdigest()
def git(name,ref=BASELINE):return subprocess.check_output(['git','show',ref+':'+name],cwd=ROOT)
def head():return subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip()
def save(name,value):(ROOT/name).write_text(json.dumps(value,indent=2)+'\n',encoding='utf-8',newline='\n')
def state():return json.loads((ROOT/'devil-branding-v2-release.json').read_text())
def vector_rects():
    svg=ET.fromstring((ROOT/'assets/devil-d-toggle.svg').read_bytes());rects=[]
    for color,path in enumerate(svg.findall('{http://www.w3.org/2000/svg}path'),1):
        parts=[];points=[]
        for command,x,y in re.findall(r'([MLZ])(?:\s*(-?\d+)\s+(-?\d+))?',path.attrib['d']):
            if command=='Z':parts.append(points);points=[]
            else:points.append((int(x),int(y)))
        active={}
        for row in range(64):
            hits=[];yy=row+.5
            for poly in parts:
                for a,b in zip(poly,poly[1:]+poly[:1]):
                    if (a[1]<=yy<b[1])or(b[1]<=yy<a[1]):hits.append(a[0]+(yy-a[1])*(b[0]-a[0])/(b[1]-a[1]))
            hits.sort();runs=set()
            for left,right in zip(hits[::2],hits[1::2]):
                xs=[x for x in range(64)if left<=x+.5<right]
                if xs:runs.add((xs[0],len(xs)))
            for run in list(active):
                if run not in runs:rects.append(active.pop(run))
            for x,width in runs:
                if (x,width)in active:active[x,width][3]+=1
                else:active[x,width]=[x,row,width,1,color]
        rects.extend(active.values())
    return rects
def runtime():
    data=(ROOT/'assets/devilhubv2.png').read_bytes()
    ref=subprocess.check_output(['git','rev-parse',ASSETS],cwd=ROOT,text=True).strip()
    source=(HERE/'brand.lua').read_text(encoding='utf-8')
    return source.replace('__D_RECTS__','{'+','.join('{'+','.join(map(str,r))+'}'for r in vector_rects())+'}').replace('__LOGO_LEN__',str(len(data))).replace('__LOGO_CHECKSUM__',str(pack.checksum(data))).replace('__LOGO_URL__','https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/'+ref+'/assets/devilhubv2.png')
def prefix(ref):
    data=subprocess.check_output(['git','show',ref+':devil-blue-gui.lua'],cwd=ROOT)
    return '''-- BEGIN DEVIL BRAND V2
do
    local env=type(getgenv)=="function"and getgenv()or _G
    local current=env.DevilHubBlueGui
    if not(current and not current.Stopped and current.BrandingVersion=="RELEASE")then
        local source=game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/REF/devil-blue-gui.lua")
        assert(type(source)=="string"and #source==LENGTH,"DEVIL branding download size mismatch")
        local sum=0;for i=1,#source do sum=(sum*33+source:byte(i))%4294967296;if i%32768==0 and task and task.wait then task.wait()end end
        assert(sum==CHECKSUM,"DEVIL branding checksum mismatch")
        local run,err=loadstring(source,"DEVIL HUB / brand v2");assert(run,err);run()
    end
end
-- END DEVIL BRAND V2
'''.replace('RELEASE',RELEASE).replace('REF',ref).replace('LENGTH',str(len(data))).replace('CHECKSUM',str(pack.checksum(data)))

def shared():
    original=pack.native(git('devil-blue-gui.lua').decode(),'devil-blue-gui.lua')
    source=original.replace('and not scope.DevilHubBlueGui.Stopped then return','and scope.DevilHubBlueGui.BrandingVersion=="'+RELEASE+'" and not scope.DevilHubBlueGui.Stopped then return',1)
    source=source.replace('local controller={Version=VERSION,','local controller={Version=VERSION,BrandingVersion="'+RELEASE+'",',1)
    marker='local links,tracked,owned,states,roots={},{},{},{},{}'
    assert source.count(marker)==1
    source=source.replace(marker,marker+'\nlocal brand=(function()\n'+runtime()+'\nend)()(scope,links)\ncontroller.Branding=brand',1)
    source=source.replace('    local image=node.Image\n    return name=="logo"','    local image=node.Image\n    if brand.Matches(image)then return true end\n    return name=="logo"',1)
    source=source.replace('    return image:find("devil-logo",1,true)~=nil','    return brand.Matches(image)or image:find("devil-logo",1,true)~=nil',1)
    marker='    localize(node)\n    if states[node]'
    assert source.count(marker)==1
    source=source.replace(marker,'    brand.Apply(node,function(image)return logo(image),launcher(image)or waveHost(image)end)\n'+marker,1)
    source=source.replace('    table.clear(roots)\n','    brand.Destroy()\n    table.clear(roots)\n',1)
    source=source.replace('return controller\n','brand.Resolve()\nreturn controller\n',1)
    assert 'brand.Resolve()\nreturn controller' in source
    (WORK/'shared.native.lua').write_text(source,encoding='utf-8',newline='\n')
    data=pack.pack(source,'devil-blue-gui.lua');(ROOT/'devil-blue-gui.lua').write_bytes(data)
    manifest={'release':RELEASE,'baseline_commit':BASELINE,'asset_commit':subprocess.check_output(['git','rev-parse',ASSETS],cwd=ROOT,text=True).strip(),
        'logo_sha256':sha((ROOT/'assets/devilhubv2.png').read_bytes()),'svg_sha256':sha((ROOT/'assets/devil-d-toggle.svg').read_bytes()),
        'shared_sha256':sha(data),'shared_native_sha256':sha(source.encode()),'vector_rectangles':len(vector_rects()),'live_verified':False,'entries':{}}
    save('devil-branding-v2-release.json',manifest)
    print('PASS built protected shared branding module; SVG rectangles:',manifest['vector_rectangles'])
def entries():
    m=state();m['shared_commit']=head();prelude=prefix(m['shared_commit'])
    audit=json.loads(git('devil-blue-gui-router-audit.json'))
    files=[r['File']for r in audit['routes']]
    files+=['ride-a-pet-delta.lua','break-and-steal-an-egg-runtime.lua','devil-steal-an-egg-chilli-main-gui.lua','devil-steal-an-egg-chilli-recovered-ui-test.lua','hatch-to-fight-test.lua']
    for name in files:
        original=git(name);assert not original.startswith(b'\xef\xbb\xbf'),name
        output=prelude.encode()+original
        assert output[len(prelude.encode()):]==original
        (ROOT/name).write_bytes(output)
        subprocess.run([str(pack.COMPILER),'--null',str(ROOT/name)],check=True,capture_output=True)
        m['entries'][name]={'before_sha256':sha(original),'after_sha256':sha(output),'unchanged_payload':True,'added_vm_layers':0}
    save('devil-branding-v2-release.json',m)
    print('PASS branded',len(files),'entries; original payload bytes preserved')
def router():
    m=state();m['entries_commit']=head()
    original=git('tools/blue-gui/router.lua').decode();source=original
    audit=json.loads(git('devil-blue-gui-router-audit.json'))
    for row in audit['routes']:
        pattern=r'(^    \{Name="'+re.escape(row['Name'])+r'"[^\n]*Commit=")[0-9a-f]{40}'
        source,n=re.subn(pattern,lambda match:match[1]+m['entries_commit'],source,flags=re.M);assert n==1,row['Name']
        row['Commit']=m['entries_commit']
    marker='local function logo()\n'
    assert source.count(marker)==1
    source=source.replace(marker,marker+'    if env.DevilHubLogoV2 then return env.DevilHubLogoV2 end\n',1)
    source=prefix(m['shared_commit'])+source
    (ROOT/'tools/blue-gui/router.lua').write_text(source,encoding='utf-8',newline='\n')
    data=pack.pack(source,'loader');(ROOT/'loader').write_bytes(data)
    audit.update(branding_release=RELEASE,branding_shared_commit=m['shared_commit'],branding_entries_commit=m['entries_commit'],
        after_native_sha256=sha(source.encode()),public_loader_sha256=sha(data),public_loader_bytes=len(data))
    for stem,file in [('anime_dice','anime-dice-test.lua'),('climb','climb-for-eggs.lua'),('steal','devil-steal-an-egg.lua')]:
        audit[stem+'_entry_commit']=m['entries_commit'];audit[stem+'_entry_sha256']=m['entries'][file]['after_sha256']
    save('devil-blue-gui-router-audit.json',audit)
    module_meta=json.loads((ROOT/'devil-blue-gui-release.json').read_text())
    module_meta.update(module_commit=m['shared_commit'],module_sha256=m['shared_sha256'],branding_release=RELEASE)
    save('devil-blue-gui-release.json',module_meta)
    m.update(loader_sha256=sha(data),loader_native_sha256=sha(source.encode()),routes=audit['routes'])
    for filename,file in [('anime-dice-test-release.json','anime-dice-test.lua'),('climb-eggs-release.json','climb-for-eggs.lua'),('devilv4-test-release.json','devilv4-test.lua'),('devil-steal-update-release.json','devil-steal-an-egg.lua'),('hatch-to-fight-test-release.json','hatch-to-fight-test.lua')]:
        meta=json.loads((ROOT/filename).read_text(encoding='utf-8'))
        meta.update(branding_release=RELEASE,branding_shared_commit=m['shared_commit'],branding_entry_commit=m['entries_commit'],main_loader_sha256=sha(data))
        if 'entry_sha256'in meta:meta['entry_sha256']=m['entries'][file]['after_sha256']
        if 'main_loader_entry_commit'in meta:meta['main_loader_entry_commit']=m['entries_commit']
        if filename=='devil-steal-update-release.json':meta.update(delegate_commit=m['entries_commit'],delegate_sha256=m['entries'][file]['after_sha256'])
        save(filename,meta)
        validation_path=ROOT/filename.replace('-release.json','-validation.json')
        if validation_path.exists():
            validation=json.loads(validation_path.read_text())
            validation.update(branding_release=RELEASE,branding_validation='devil-branding-v2-validation.json',unchanged_payload_validation_preserved=True,
                entry_sha256=m['entries'][file]['after_sha256'])
            if 'main_loader_sha256'in validation:validation['main_loader_sha256']=sha(data)
            save(validation_path.name,validation)
    save('devil-branding-v2-release.json',m)
    print('PASS router: same game IDs/versions, v2 branding before all 12 routes')

if __name__=='__main__':
    {'shared':shared,'entries':entries,'router':router}[sys.argv[1]]()
