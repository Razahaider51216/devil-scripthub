from pathlib import Path
import json

root = Path(__file__).resolve().parents[2]
here = Path(__file__).resolve().parent
pairs = json.loads((here / 'thai-dictionary.json').read_text(encoding='utf-8'))
quote = lambda text: json.dumps(text, ensure_ascii=False)
dictionary = 'local phrasePairs={\n' + ''.join('    {' + quote(en) + ',' + quote(th) + '},\n' for en, th in pairs) + '}\n'
helper = (here / 'localization.lua').read_text(encoding='utf-8').replace('-- PHRASES INSERTED HERE', dictionary)
path = root / 'devil-blue-gui.lua'
source = path.read_text(encoding='utf-8')
begin = '-- BEGIN SHARED LOCALIZATION\n'
finish = '-- END SHARED LOCALIZATION\n'
start = source.index(begin) + len(begin)
end = source.index(finish, start)
source = source[:start] + helper + '\n' + source[end:]
start = source.index('createUI=function(screen)')
end = source.index('local function mark(screen)', start)
source = source[:start] + (here / 'appearance-panel.lua').read_text(encoding='utf-8') + '\n' + source[end:]
path.write_text(source, encoding='utf-8', newline='\n')
print('Built bilingual presentation:', len(pairs), 'English/Thai entries')
