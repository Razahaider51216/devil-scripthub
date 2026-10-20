from pathlib import Path
import json, re, subprocess, sys

here = Path(__file__).resolve().parent
root = here.parents[1]
runtime_ref = sys.argv[1]
assert re.fullmatch(r'[0-9a-f]{40}', runtime_ref)
manifest = json.loads((root / 'devil-chilli-native-ui-recovery.json').read_text())
path = root / 'devil-steal-an-egg-chilli-recovered-ui-test.lua'
source = path.read_text(encoding='utf-8')
guard_start=source.index('local startNativeUiGuard=(function()\n')+len('local startNativeUiGuard=(function()\n')
guard_end=source.index('\nend)()\nlocal env=',guard_start)
source=source[:guard_start]+(here/'startup-guard.lua').read_text(encoding='utf-8')+source[guard_end:]
cache_begin = '-- BEGIN PINNED SOURCE CACHE\n'
cache_end = '-- END PINNED SOURCE CACHE\n'
if cache_begin in source:
    first = source.index(cache_begin)
    last = source.index(cache_end,first)+len(cache_end)
    source = source[:first]+source[last:]
cache = 'local loadPinnedSource=(function()\n'+(here/'pinned-source.lua').read_text(encoding='utf-8')+'\nend)()\n'
source = source.replace('local completed=table.pack(pcall(function()',cache_begin+cache+cache_end+'local completed=table.pack(pcall(function()',1)
start = source.index('local attach=(function()') + len('local attach=(function()\n')
end = source.index('\nend)()\nlocal function existingDevilHubLibrary', start)
source = source[:start] + (here / 'bridge.lua').read_text(encoding='utf-8') + source[end:]
begin = '-- BEGIN DEVIL WEBHOOK BRANDING\n'
finish = '-- END DEVIL WEBHOOK BRANDING\n'
if begin in source:
    start = source.index(begin)
    end = source.index(finish, start) + len(finish)
    source = source[:start] + source[end:]
source = source.replace('    run=brandWebhookRuntime(run,getfenv(1))\n', '')
source, count = re.subn(r'https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/[0-9a-f]+/devil-chilli-native-ui-runtime.lua',
                      'https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/' + runtime_ref + '/devil-chilli-native-ui-runtime.lua', source)
assert count == 1
url = 'https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/'+runtime_ref+'/devil-chilli-native-ui-runtime.lua'
replacement = ('local originalGameSource,sourceInfo=loadPinnedSource("'+url+'",'+str(manifest['source_bytes'])+','+
    str(manifest['transfer_checksum'])+',"DevilHub_StealRuntime_'+runtime_ref+'.lua")\n'
    '    report.Source=sourceInfo;loading.Update("Preparing verified systems...",.4)\n')
if '-- BEGIN VERIFIED RUNTIME LOAD\n' in source:
    source,count = re.subn(r'-- BEGIN VERIFIED RUNTIME LOAD\n.*?-- END VERIFIED RUNTIME LOAD\n',
        lambda _: '-- BEGIN VERIFIED RUNTIME LOAD\n'+replacement+'-- END VERIFIED RUNTIME LOAD\n',source,flags=re.S)
else:
    source,count = re.subn(r'local originalGameSource=game:HttpGet\([^\n]+\n.*?assert\(checksum==\d+,"Pinned runtime download checksum mismatch"\)\n',
        lambda _: '-- BEGIN VERIFIED RUNTIME LOAD\n'+replacement+'-- END VERIFIED RUNTIME LOAD\n',source,flags=re.S)
assert count == 1
source, count = re.subn(r'referenceSHA256="[0-9a-f]+"', 'referenceSHA256="' + manifest['source_sha256'] + '"', source)
assert count == 1
source = source.replace('    local run,err=loadstring(originalGameSource,"Chilli / Steal an Egg / pinned runtime")',
    '    local compileStarted=os.clock()\n    local run,err=loadstring(originalGameSource,"DEVIL HUB / Steal an Egg / pinned runtime")\n    report.CompileSeconds=os.clock()-compileStarted')
source = source.replace('    return run()\nend,function(err)',
    '    local runtimeStarted=os.clock();local values=table.pack(run())\n    report.RuntimeSeconds=os.clock()-runtimeStarted\n    return table.unpack(values,1,values.n)\nend,function(err)',1)
for name in ['devil-steal-an-egg-chilli-recovered-ui-test.lua', 'devil-steal-an-egg-chilli-main-gui.lua']:
    target = root / name
    target.write_text(source, encoding='utf-8', newline='\n')
    subprocess.run([str(root.parent / 'luau-tools/luau-compile.exe'), '--null', str(target)], check=True)
print('Built matching GUI entries with runtime pin', runtime_ref)
