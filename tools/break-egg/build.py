"""Rebuild the Break runtime from the recorded baseline, preserving its compiler bridge."""
from pathlib import Path
import ast,base64,json,re,secrets,subprocess,sys
ROOT=Path(__file__).resolve().parents[2]
HERE=Path(__file__).resolve().parent
WORK=ROOT.parent/'break-large-egg-build';WORK.mkdir(exist_ok=True)
sys.path.insert(0,str(ROOT/'tools/protection'))
import pack
pack.WORK=WORK
BASELINE='931dc94'
NAME='break-and-steal-an-egg-runtime.lua'
def git_source(ref):return subprocess.check_output(['git','show',ref+':'+NAME],cwd=ROOT).decode('utf-8')
def once(source,old,new):
    assert source.count(old)==1,(old[:90],source.count(old))
    return source.replace(old,new,1)
def edits(gameplay):
    start=gameplay.index('    local function eggApproach(')
    end=gameplay.index('    local function ',start+10)
    approach=(HERE/'approach.lua').read_text(encoding='utf-8-sig')
    formatter=(HERE/'income-format.lua').read_text(encoding='utf-8-sig')
    changes=[(gameplay[start:end],approach),
      ('    local function parseIncome(value)',formatter+'    api.FormatIncome=formatIncome\n    local function parseIncome(value)'),
      ('math.max(2,(eggConfig.HitRange or 8)-1)','eggReach()'),
      ('use 1000000 or 1M; previous value retained','use 1k, 10T or 100T; previous value retained'),
      ('tostring(amount).."/s"','formatIncome(amount).."/s"'),
      ('CurrentValue="0",\n                            Callback=function(value)', 'CurrentValue="0",Placeholder="1k / 10T / 100T",Numeric=false,\n                            Callback=function(value)'),
      ('''                                if movement and not movement.Set("PickupMinimumIncome",value)and incomeInput then
                                    incomeInput:Set(tostring(movement.MinimumIncome),true)
                                end''','''                                if incomeInput then incomeInput:Set(value,true)end'''),
      ('                        raw:CreateParagraph({Name="เลือกตามรายได้สัตว์",','''                        local incomeStatus=raw:CreateLabel({Text="เงินขั้นต่ำที่ใช้จริง: 0/s (ปิดตัวกรองเงิน)"})
                        local originalIncomeSet=incomeInput.Set
                        incomeInput.Set=function(self,value)
                            if not movement then return originalIncomeSet(self,value,true)end
                            movement.Set("PickupMinimumIncome",value)
                            local text=movement.FormatIncome(movement.MinimumIncome)
                            originalIncomeSet(self,text,true)
                            incomeStatus:Set("เงินขั้นต่ำที่ใช้จริง: "..text.."/s"..(movement.MinimumIncome==0 and " (ปิดตัวกรองเงิน)"or ""))
                        end
                        raw:CreateParagraph({Name="เลือกตามรายได้สัตว์",''')]

    changes.append(('ใส่ 1000000 หรือ 1M เพื่อ Steal รายได้ 1M/s ขึ้นไป','ใส่ 1k, 10T หรือ 100T เพื่อ Steal ตามรายได้ต่อวินาทีขั้นต่ำ'))
    return changes

def main():
    native=pack.native(git_source(BASELINE),NAME)
    match=re.search(r'https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/([0-9a-f]{40})/'+re.escape(NAME),native)
    assert match
    inner=pack.native(git_source(match[1]),'break-inner')
    ns=dict(re=re,base64=base64,secrets=secrets,STD='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/')
    tree=ast.parse((ROOT.parent/'devil-vm-build/build_vm.py').read_text(encoding='utf-8'))
    exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef)and n.name=='packed_body'],type_ignores=[]),'decode','exec'),ns)
    gameplay=ns['packed_body'](inner);assert gameplay
    changes=edits(gameplay)
    patched=gameplay
    for old,new in changes:
        assert old in patched,old[:120]
        patched=patched.replace(old,new)
    (WORK/'gameplay.patched.lua').write_text(patched,encoding='utf-8')
    subprocess.run([str(pack.COMPILER),'--null',str(WORK/'gameplay.patched.lua')],check=True)
    rows=','.join('{'+json.dumps(a,ensure_ascii=False)+','+json.dumps(b,ensure_ascii=False)+'}'for a,b in changes)
    bridge='''    local reachAndIncomeEdits={ROWS}
    local function patchReachAndIncome(source)
        for _,edit in ipairs(reachAndIncomeEdits)do
            local found=false
            local from=1;local pieces={}
            while true do
                local at=source:find(edit[1],from,true)
                if not at then pieces[#pieces+1]=source:sub(from);break end
                found=true;pieces[#pieces+1]=source:sub(from,at-1);pieces[#pieces+1]=edit[2];from=at+#edit[1]
            end
            assert(found,"Break reach/income update: expected gameplay section missing")
            source=table.concat(pieces)
        end
        return source
    end
'''.replace('ROWS',rows)
    native=once(native,'    local patched=false\n',bridge+'    local patched=false\n')
    native=once(native,'            patched=true\n','            source=patchReachAndIncome(source)\n            patched=true\n')
    (WORK/'runtime.patched.lua').write_text(native,encoding='utf-8')
    pack.RELEASE='break-income-ui-20261022-2'
    artifact=pack.pack(native,NAME)
    (ROOT/NAME).write_bytes(artifact)
    # Extract the exact injected patch for executable regression checks.
    (WORK/'patch.lua').write_text(bridge+'return patchReachAndIncome',encoding='utf-8')
    (WORK/'gameplay.before.lua').write_text(gameplay,encoding='utf-8')
    print('PASS compiled gameplay, native boundary and packed source roundtrip')
if __name__=='__main__':main()
