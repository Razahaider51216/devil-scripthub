from pathlib import Path
import subprocess

root = Path(__file__).resolve().parents[2]
source = (root / 'tools/auto-execute/bootstrap.lua').read_text(encoding='utf-8')
eq = '='
while ']' + eq + ']' in source:
    eq += '='
fixture = 'local bootstrap=[' + eq + '[' + source + ']' + eq + ']\n'
fixture += (root / 'tests/auto-execute.luau').read_text(encoding='utf-8')
path = Path(__file__).with_suffix('.generated.luau')
path.write_text(fixture, encoding='utf-8', newline='\n')
subprocess.run([str(root.parent / 'luau-tools/luau.exe'), str(path)], check=True)
