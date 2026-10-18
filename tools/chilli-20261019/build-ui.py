from pathlib import Path
import json, re, subprocess, sys

here = Path(__file__).resolve().parent
root = here.parents[1]
runtime_ref = sys.argv[1]
assert re.fullmatch(r'[0-9a-f]{40}', runtime_ref)
manifest = json.loads((root / 'devil-chilli-native-ui-recovery.json').read_text())
path = root / 'devil-steal-an-egg-chilli-recovered-ui-test.lua'
source = path.read_text(encoding='utf-8')
start = source.index('local attach=(function()') + len('local attach=(function()\n')
end = source.index('\nend)()\nlocal function existingDevilHubLibrary', start)
source = source[:start] + (here / 'bridge.lua').read_text(encoding='utf-8') + source[end:]
begin = '-- BEGIN DEVIL WEBHOOK BRANDING\n'
finish = '-- END DEVIL WEBHOOK BRANDING\n'
helper = begin + 'local brandWebhookRuntime=(function()\n' + (here / 'webhook-branding.lua').read_text(encoding='utf-8') + '\nend)()\n' + finish
if begin in source:
    start = source.index(begin)
    end = source.index(finish, start) + len(finish)
    source = source[:start] + helper + source[end:]
else:
    source = source.replace('local attach=(function()', helper + 'local attach=(function()', 1)
source, count = re.subn(r'(originalGameSource=game:HttpGet\(")https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/[0-9a-f]+/devil-chilli-native-ui-runtime.lua',
                      r'\g<1>https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/' + runtime_ref + '/devil-chilli-native-ui-runtime.lua', source)
assert count == 1
source, count = re.subn(r'#originalGameSource==\d+', '#originalGameSource==' + str(manifest['source_bytes']), source)
assert count == 1
source, count = re.subn(r'assert\(checksum==\d+,"Pinned runtime', 'assert(checksum==' + str(manifest['transfer_checksum']) + ',"Pinned runtime', source)
assert count == 1
source, count = re.subn(r'referenceSHA256="[0-9a-f]+"', 'referenceSHA256="' + manifest['source_sha256'] + '"', source)
assert count == 1
needle = '    assert(run,err)\n    report.status="Runtime compiled"'
if 'run=brandWebhookRuntime(run,getfenv(1))' not in source:
    assert source.count(needle) == 1
    source = source.replace(needle, '    assert(run,err)\n    run=brandWebhookRuntime(run,getfenv(1))\n    report.status="Runtime compiled"')
for name in ['devil-steal-an-egg-chilli-recovered-ui-test.lua', 'devil-steal-an-egg-chilli-main-gui.lua']:
    target = root / name
    target.write_text(source, encoding='utf-8', newline='\n')
    subprocess.run([str(root.parent / 'luau-tools/luau-compile.exe'), '--null', str(target)], check=True)
print('Built matching GUI entries with runtime pin', runtime_ref)
