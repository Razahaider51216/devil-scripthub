"""Patch only the V8 capture module in the published passive-startup release."""
from pathlib import Path
import ast, base64, hashlib, json, re, subprocess

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
BASELINE = 'e2dec2a'
RELEASE = 'dump-14-v8-capture-20261022-1'
ns = {'re': re, 'base64': base64, 'RELEASE': ROOT}
tree = ast.parse((ROOT.parent/'naphub-loot-to-forge/build_update.py').read_text(encoding='utf-8'))
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n, ast.FunctionDef) and n.name in {'unpack', 'repack'}], type_ignores=[]), 'packing', 'exec'), ns)
before = subprocess.check_output(['git', 'show', BASELINE+':devil-dump.lua'], cwd=ROOT).decode('utf-8')
original = ns['unpack'](before).decode('utf-8')
marker = 'local DevilRuntimeCapture=(function()\n'
start = original.index(marker)+len(marker)
end = original.index('\nend)()\nlocal DevilMapAnalyst=', start)
module = (HERE/'runtime-capture.lua').read_text(encoding='utf-8').rstrip()
source = (original[:start]+module+original[end:]).replace('devil-dump.lua?v=dump-13-client-start-20261022-1', 'devil-dump.lua?v='+RELEASE)
outer = before.replace('devil-dump.lua?v=dump-13-client-start-20261022-1', 'devil-dump.lua?v='+RELEASE)
(ROOT/'devil-dump.lua').write_text(outer, encoding='utf-8', newline='\n')
ns['repack']('devil-dump.lua', source, original)
public = (ROOT/'devil-dump.lua').read_bytes()
assert ns['unpack'](public.decode('utf-8')) == source.encode('utf-8')
subprocess.run([str(ROOT.parent/'luau-tools/luau-compile.exe'), '--null', str(ROOT/'devil-dump.lua')], check=True, capture_output=True)
report = {
    'release': RELEASE, 'baseline_commit': BASELINE,
    'entry_sha256': hashlib.sha256(public).hexdigest(),
    'native_sha256': hashlib.sha256(source.encode('utf-8')).hexdigest(),
    'live_verified': False, 'automatic_map_scan': False, 'automatic_profile_apply': False,
    'startup_remote_hook': False, 'kick_root_cause_confirmed': False,
    'report': 'User reports BAC-1515 after pressing Dump V8 in Steal an Egg using Delta.',
    'v8_defaults': {'loaded_exports': False, 'gc_functions': False, 'diagnostic_checkpoints': True},
    'diagnostic_file': 'DevilDump_Dumps/ClientRuntimeV8/Run_<timestamp>_<generation>/LastOperation.txt',
    'native_changes': 'V8 capture module and retry URL only; all other native tools identical to baseline'
}
(ROOT/'devil-dump-release.json').write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8', newline='\n')
print('PASS V8 release compilation and exact packing roundtrip')
