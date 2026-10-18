from pathlib import Path
import hashlib, json, re, subprocess, sys

root = Path(__file__).resolve().parents[2]
RELEASE = 'devil-blue-20261019-1'
FILES = ['mine-auto-test.lua', 'tapping-auto-test.lua', 'climb-for-eggs.lua',
         'lift-rock-for-eggs.lua', 'aqua-auto-egg.lua', 'devil-steal-an-egg.lua',
         'ride-a-pet.lua', 'break-and-steal-an-egg.lua', 'loot-to-forge.lua',
         'build-an-ant-empire.lua', 'ride-a-pet-delta.lua',
         'break-and-steal-an-egg-runtime.lua',
         'devil-steal-an-egg-chilli-main-gui.lua',
         'devil-steal-an-egg-chilli-recovered-ui-test.lua']

def checksum(data):
    value = 0
    for byte in data:
        value = (value * 33 + byte) % 4294967296
    return value

def prefix(ref):
    assert re.fullmatch('[0-9a-f]{40}', ref)
    module = subprocess.check_output(['git', 'show', ref + ':devil-blue-gui.lua'], cwd=root)
    return f'''-- BEGIN SHARED DEVIL BLUE GUI
do
    local shared=type(getgenv)=="function"and getgenv()or _G
    local current=shared.DevilHubBlueGui
    if not(current and current.Version=="{RELEASE}"and not current.Stopped)then
        local ok,problem=pcall(function()
            local source=game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/{ref}/devil-blue-gui.lua")
            assert(type(source)=="string"and #source=={len(module)},"DEVIL blue GUI download size mismatch")
            local sum=0
            for i=1,#source do sum=(sum*33+source:byte(i))%4294967296;if i%32768==0 and task and task.wait then task.wait()end end
            assert(sum=={checksum(module)},"DEVIL blue GUI checksum mismatch")
            local run,err=loadstring(source,"DEVIL HUB / Blue GUI")
            assert(run,err)
            return run()
        end)
        if not ok then warn("DEVIL HUB: blue GUI could not start: "..tostring(problem))end
    end
end
-- END SHARED DEVIL BLUE GUI
'''

def main():
    ref = sys.argv[1]
    prelude = prefix(ref)
    manifest = {'release': RELEASE, 'module_commit': ref,
                'module_sha256': hashlib.sha256(subprocess.check_output(['git', 'show', ref + ':devil-blue-gui.lua'], cwd=root)).hexdigest(),
                'gameplay_bodies_unchanged': True, 'live_verified': False, 'entries': {}}
    for name in FILES:
        path = root / name
        original = path.read_text(encoding='utf-8-sig')
        if original.startswith('-- BEGIN SHARED DEVIL BLUE GUI'):
            original = original.split('-- END SHARED DEVIL BLUE GUI\n', 1)[1]
        result = prelude + original
        assert result[len(prelude):] == original
        path.write_text(result, encoding='utf-8', newline='\n')
        subprocess.run([str(root.parent / 'luau-tools/luau-compile.exe'), '--null', str(path)],
                       check=True, capture_output=True)
        manifest['entries'][name] = {'original_body_sha256': hashlib.sha256(original.encode()).hexdigest(),
                                    'public_sha256': hashlib.sha256(path.read_bytes()).hexdigest()}
        print('PASS compiled blue GUI entry', name)
    (root / 'devil-blue-gui-release.json').write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8')

if __name__ == '__main__':
    main()
