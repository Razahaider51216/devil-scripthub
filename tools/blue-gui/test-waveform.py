"""Replay OuroFlow's actual bar geometry and native color/height updates."""
from pathlib import Path
import subprocess

root = Path(__file__).resolve().parents[2]
mocks = (root / 'tests/blue-gui-mocks.luau').read_text(encoding='utf-8')
checks = (root / 'tests/blue-gui-wave-checks.luau').read_text(encoding='utf-8')
path = Path(__file__).with_suffix('.generated.luau')
runtime = str(root.parent / 'luau-tools/luau.exe')
baseline = subprocess.check_output(['git', 'show',
    '8985ef77de8684b26d4c293d753788024f5e0294:devil-blue-gui.lua'], cwd=root).decode('utf-8')
path.write_text(mocks + checks.replace('-- MODULE INSERTED HERE', baseline), encoding='utf-8', newline='\n')
result = subprocess.run([runtime, str(path)], capture_output=True, text=True, timeout=15)
assert result.returncode != 0 and 'mini waveform lacks readable blue-white gradient' in result.stderr, result.stdout + result.stderr
print('PASS reproduced previous release: mini waveform painted dark')
module = (root / 'devil-blue-gui.lua').read_text(encoding='utf-8')
path.write_text(mocks + checks.replace('-- MODULE INSERTED HERE', module), encoding='utf-8', newline='\n')
subprocess.run([runtime, str(path)], check=True, timeout=15)
