"""Install a Break-only language bridge and repin only that main-loader route."""
from pathlib import Path
import hashlib, json, re, subprocess, sys

root=Path(__file__).resolve().parents[2]
here=Path(__file__).resolve().parent
build=root.parent/'steal-chilli-build-20261019'
release='break-language-sync-20261020-1'
manifest_path=root/'break-language-release.json'
mode=sys.argv[1]

def sha(data):return hashlib.sha256(data).hexdigest()

if mode=='entries':
    helper=(here/'break-language.lua').read_text(encoding='utf-8')
    begin='-- BEGIN BREAK LANGUAGE SYNC\n'
    end='-- END BREAK LANGUAGE SYNC\n'
    bridge=begin+'do\nlocal install=(function()\n'+helper+'\nend)()\ninstall()\nend\n'+end
    manifest={'release':release,'map':'Break and Steal an Egg','place_id':114326934417838,
        'universe_id':10765288803,'baseline_commit':subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip(),
        'bridge_sha256':sha(helper.encode()),'native_gameplay_unchanged':True,'live_verified':False,'entries':{}}
    for name in ['break-and-steal-an-egg.lua','break-and-steal-an-egg-runtime.lua']:
        path=root/name
        source=path.read_text(encoding='utf-8')
        if begin in source:
            source,count=re.subn(re.escape(begin)+r'.*?'+re.escape(end),'',source,flags=re.S)
            assert count==1
        prefix,body=source.split('-- END SHARED DEVIL BLUE GUI\n',1)
        prefix+='-- END SHARED DEVIL BLUE GUI\n'
        result=prefix+bridge+body
        assert result.replace(bridge,'',1)==source
        path.write_text(result,encoding='utf-8',newline='\n')
        subprocess.run([str(root.parent/'luau-tools/luau-compile.exe'),'--null',str(path)],check=True)
        manifest['entries'][name]={'engine_body_sha256':sha(body.encode()),'public_sha256':sha(result.encode())}
    manifest_path.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8',newline='\n')
elif mode=='router':
    commit=sys.argv[2]
    assert re.fullmatch('[0-9a-f]{40}',commit)
    manifest=json.loads(subprocess.check_output(['git','show',commit+':'+manifest_path.name],cwd=root))
    for name,record in manifest['entries'].items():
        assert sha(subprocess.check_output(['git','show',commit+':'+name],cwd=root))==record['public_sha256']
    path=here/'router.lua'
    before=path.read_text(encoding='utf-8')
    audit_path=root/'devil-blue-gui-router-audit.json'
    audit=json.loads(audit_path.read_text(encoding='utf-8'))
    assert sha(before.encode())==audit['after_native_sha256']
    after,count=re.subn(r'^    \{Name="Break and Steal an Egg"[^\n]+',lambda _: '    {Name="Break and Steal an Egg",Universe=10765288803,Place=114326934417838,File="break-and-steal-an-egg.lua",Commit="'+commit+'",Version="'+release+'"},',before,flags=re.M)
    assert count==1
    after,count=re.subn(r'entry.File=="break-and-steal-an-egg.lua"and"[^"]+"',
        'entry.File=="break-and-steal-an-egg.lua"and"'+release+'"',after)
    assert count==1
    other_routes=r'^    \{(?!Name="Break and Steal an Egg")[^\n]+'
    assert re.findall(other_routes,before,re.M)==re.findall(other_routes,after,re.M)
    assert before.split('-- END SHARED DEVIL BLUE GUI\n',1)[0]==after.split('-- END SHARED DEVIL BLUE GUI\n',1)[0]
    path.write_text(after,encoding='utf-8',newline='\n')
    (build/'loader.native').write_text(after,encoding='utf-8',newline='\n')
    subprocess.run([sys.executable,str(build/'build-router.py'),'--only','loader','--release',release],cwd=build,check=True)
    public=(build/'candidate/loader').read_bytes()
    (root/'loader').write_bytes(public)
    route=next(row for row in audit['routes']if row['File']=='break-and-steal-an-egg.lua')
    route.update(Commit=commit,Version=release)
    audit.update(release=release,before_native_sha256=sha(before.encode()),after_native_sha256=sha(after.encode()),
        public_loader_sha256=sha(public),public_loader_bytes=len(public),break_language_entry_commit=commit,
        non_break_routes_unchanged=True)
    audit_path.write_text(json.dumps(audit,indent=2)+'\n',encoding='utf-8',newline='\n')
    manifest.update(main_entry_commit=commit,main_loader_sha256=sha(public),non_break_routes_unchanged=True)
    manifest_path.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8',newline='\n')
else:
    raise ValueError(mode)
print('PASS built',mode,release)
