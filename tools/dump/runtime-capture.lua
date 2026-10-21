local Runtime={Version="dump-15-v8-no-require-20261022-1",ModuleExecution=false}
local onlineTargets={
    "ReplicatedStorage.LocalData.OnlineData",
    "ReplicatedStorage.GuiUtils.OnlineGift",
    "ReplicatedStorage.Config.Online.Reward",
    "ReplicatedStorage.Config.Online.Helper",
}
function Runtime.ValidSource(source)
    if type(source)~="string" or not source:find("%S") then return false end
    local lower=source:lower()
    if lower:find("decompilation panicked",1,true) or lower:match("^%s*%-%-%s*decompil.-fail") then return false end
    for line in source:gmatch("[^\r\n]+") do
        if line:find("%S") and not line:match("^%s*%-%-") then return true end
    end
    return false
end
function Runtime.New(deps)
    local self={Stopped=false,Busy=false,Generation=0,ListLoadedModules=false,GCFunctions=false,Diagnostics=true,Folder="DevilDump_Dumps/ClientRuntimeV8"}
    local A=deps.APIs
    local function alive(generation) return not self.Stopped and deps.Alive() and generation==self.Generation end
    local function status(text) self.Status=text;if self.Label then pcall(self.Label.Set,self.Label,text,true) end end
    local function ensureFolder(path)
        local built=""
        for part in path:gmatch("[^/]+") do
            built=built=="" and part or built.."/"..part
            local exists=false
            if type(A.isfolder)=="function" then local ok,value=pcall(A.isfolder,built);exists=ok and value end
            if not exists and type(A.makefolder)=="function" then pcall(A.makefolder,built) end
        end
    end
    local function write(path,content)
        if type(A.writefile)~="function" then return nil,"writefile unavailable" end
        local ok,err=pcall(A.writefile,path,content)
        if not ok then return nil,tostring(err) end
        if type(A.readfile)=="function" then
            local readOK,result=pcall(A.readfile,path)
            if not readOK or result~=content then return nil,"readback mismatch" end
        end
        return path
    end
    local function scalar(value)
        local kind=deps.Typeof(value)
        if kind=="nil" then return {type="nil"} end
        if kind=="string" then
            local result={type=kind,length=#value,value=value:sub(1,256),truncated=#value>256}
            local valid,length=pcall(utf8.len,result.value)
            if not valid or not length then
                local bytes={};for i=1,math.min(#value,128) do bytes[#bytes+1]=string.format("%02x",value:byte(i)) end
                result.value=table.concat(bytes);result.encoding="hex";result.truncated=#value>128
            end
            return result
        end
        if kind=="number" then return {type=kind,value=value==value and math.abs(value)<math.huge and value or tostring(value)} end
        if kind=="boolean" then return {type=kind,value=value} end
        if kind=="Instance" then local ok,path=pcall(value.GetFullName,value);return {type=kind,path=ok and path or "unavailable",class=value.ClassName} end
        return {type=kind}
    end
    function self:Capture(generation,scope)
        local targeted=scope=="online-rewards"
        local captureFolder=self.Folder..(targeted and "/OnlineRewards_" or "/Run_")..deps.Date("%Y%m%d_%H%M%S").."_"..tostring(generation)
        ensureFolder(captureFolder)
        local report={schema="devil-runtime-capture-8",placeId=deps.Game.PlaceId,universeId=deps.Game.GameId,
            timestamp=deps.Date("!%Y-%m-%dT%H:%M:%SZ"),scripts={},functions={},errors={},capabilities={},
            inspectedFunctionsExecuted=false,hooksInstalled=false,serverSourceAccessible=false,devirtualized=false,
            counts={source=0,sourceErrors=0,bytecode=0,bytecodeBytes=0,loadedExports=0,gcFunctions=0}}
        report.scope=targeted and "online-rewards" or "all-client"
        local listLoadedModules,gcFunctions,diagnostics=self.ListLoadedModules==true,self.GCFunctions==true,self.Diagnostics==true
        report.release=Runtime.Version
        report.moduleExecutionEnabled=false
        report.loadedExportsStatus="unavailable: capture does not require game modules"
        report.options={loadedExports=false,listLoadedModules=listLoadedModules,gcFunctions=gcFunctions,diagnostics=diagnostics}
        report.progressFile=captureFolder.."/LastOperation.txt"
        local function checkpoint(operation,path)
            report.lastOperation={operation=operation,path=path or ""}
            if diagnostics and type(A.writefile)=="function" then
                local ok,err=pcall(A.writefile,report.progressFile,
                    "DEVIL DUMP V8\nRelease: "..Runtime.Version.."\nOperation: "..operation.."\nScript: "..(path or "")..
                    "\nPlace: "..tostring(report.placeId).."\nThis records the last attempted operation, not a confirmed kick cause.\n")
                if not ok then report.progressError=tostring(err) end
            end
        end
        checkpoint("capture-start")
        report.limits={functions=1200,constantsPerFunction=targeted and 256 or 64,
            upvaluesPerFunction=targeted and 64 or 32,tableDepth=targeted and 4 or 2,
            tableFields=targeted and 12000 or 6000,tableBudget=targeted and "per-script" or "capture"}
        local foundTargets={}
        local function targetIndex(path)
            for index,target in ipairs(onlineTargets) do
                if path==target or path:sub(1,#target+1)==target.."." then return index end
            end
            return nil
        end
        if targeted then report.requestedTargets=table.clone(onlineTargets);report.missingTargets={} end
        for _,name in ipairs({"decompile","getscriptbytecode","getscriptclosure","getsenv","getloadedmodules","getgc","getfenv","getconstants","getupvalues","writefile"}) do report.capabilities[name]=type(A[name])=="function" end
        report.probes={constantsExposeOwnLiteral=false,upvaluesExposeOwnCapture=false}
        local ownCapture={marker="DEVIL_RUNTIME_UPVALUE_PROBE"}
        local ownFunction=function()return "DEVIL_RUNTIME_CONSTANT_PROBE",ownCapture.marker end
        if type(A.getconstants)=="function" then
            checkpoint("getconstants-probe","dumper self-test")
            local ok,values=pcall(A.getconstants,ownFunction)
            if ok and type(values)=="table" then for _,value in pairs(values)do if value=="DEVIL_RUNTIME_CONSTANT_PROBE"then report.probes.constantsExposeOwnLiteral=true end end end
        end
        if type(A.getupvalues)=="function" then
            checkpoint("getupvalues-probe","dumper self-test")
            local ok,values=pcall(A.getupvalues,ownFunction)
            if ok and type(values)=="table" then for _,value in pairs(values)do if value==ownCapture then report.probes.upvaluesExposeOwnCapture=true end end end
        end
        local scripts,known,seen={},{},{}
        local roots={}
        for _,name in ipairs({"ReplicatedStorage","ReplicatedFirst"}) do local ok,r=pcall(deps.Game.GetService,deps.Game,name);if ok and r then roots[#roots+1]=r end end
        local player
        pcall(function()player=deps.Game:GetService("Players").LocalPlayer end)
        if player then
            for _,name in ipairs({"PlayerScripts","PlayerGui","Backpack"}) do local r=player:FindFirstChild(name);if r then roots[#roots+1]=r end end
            if player.Character then roots[#roots+1]=player.Character end
        end
        for _,root in ipairs(roots) do
            checkpoint("enumeration",root.Name)
            local ok,items=pcall(root.GetDescendants,root)
            if ok then for _,item in ipairs(items) do
                if not known[item] and (item:IsA("LocalScript") or item:IsA("ModuleScript")) then
                    local pathOK,path=pcall(item.GetFullName,item)
                    if not targeted or (pathOK and targetIndex(path)) then
                        if #scripts>=3000 then report.scriptLimit=true;break end
                        known[item]=true;scripts[#scripts+1]=item
                        if targeted then foundTargets[path]=true end
                    end
                end
            end else report.errors[#report.errors+1]={operation="enumeration",error=tostring(items)} end
        end
        if targeted then
            table.sort(scripts,function(a,b)
                local ap,bp=a:GetFullName(),b:GetFullName()
                local ai,bi=targetIndex(ap),targetIndex(bp)
                return ai==bi and ap<bp or ai<bi
            end)
            for _,path in ipairs(onlineTargets) do
                if not foundTargets[path] then report.missingTargets[#report.missingTargets+1]=path end
            end
        end
        local loaded={}
        if listLoadedModules and type(A.getloadedmodules)=="function" then
            checkpoint("getloadedmodules")
            local ok,items=pcall(A.getloadedmodules)
            if ok and type(items)=="table" then for _,module in pairs(items) do loaded[module]=true end
            else report.errors[#report.errors+1]={operation="getloadedmodules",error=tostring(items)} end
        end
        local function inspectFunction(fn,owner,key)
            if type(fn)~="function" or seen[fn] then return nil end
            if #report.functions>=1200 then report.functionLimit=true;return nil end
            seen[fn]=true
            local row={id=#report.functions+1,owner=owner,key=tostring(key),constants={},upvalues={}}
            if type(A.info)=="function" then
                local ok,source,line,name=pcall(A.info,fn,"sln")
                if ok then row.debugSource=tostring(source);row.line=line;row.name=name end
                local argc,parameters,vararg=pcall(A.info,fn,"a")
                if argc then row.parameters=parameters;row.vararg=vararg end
            end
            if type(A.getconstants)=="function" then
                checkpoint("getconstants",owner)
                local ok,values=pcall(A.getconstants,fn)
                if ok and type(values)=="table" then
                    for index,value in pairs(values) do
                        if #row.constants>=report.limits.constantsPerFunction then row.constantsTruncated=true;break end
                        row.constants[#row.constants+1]={index=tostring(index),value=scalar(value)}
                    end
                else row.constantsError=tostring(values) end
            end
            if type(A.getupvalues)=="function" then
                checkpoint("getupvalues",owner)
                local ok,values=pcall(A.getupvalues,fn)
                if ok and type(values)=="table" then
                    for index,value in pairs(values) do
                        if #row.upvalues>=report.limits.upvaluesPerFunction then row.upvaluesTruncated=true;break end
                        row.upvalues[#row.upvalues+1]={index=tostring(index),value=scalar(value)}
                    end
                else row.upvaluesError=tostring(values) end
            end
            report.functions[#report.functions+1]=row
            return row.id
        end
        local tableFields=0
        local function inspectTable(value,owner,depth,tables)
            depth=depth or 0;tables=tables or {}
            local result={fields={},methods={}}
            if type(value)=="function" then result.functionId=inspectFunction(value,owner,"export");return result end
            if type(value)~="table" then result.value=scalar(value);return result end
            if tables[value] then result.cycle=true;return result end
            tables[value]=true
            local count=0
            for key,item in next,value do
                count+=1;tableFields+=1;if count>128 or tableFields>report.limits.tableFields then result.truncated=true;break end
                if type(item)=="function" then result.methods[#result.methods+1]={name=tostring(key),functionId=inspectFunction(item,owner,key)}
                else
                    local field={name=tostring(key),value=scalar(item)}
                    if type(item)=="table" and depth<report.limits.tableDepth and key~="_G" and key~="_ENV" and key~="shared" then field.members=inspectTable(item,owner.."."..tostring(key),depth+1,tables) end
                    result.fields[#result.fields+1]=field
                end
            end
            local meta=getmetatable(value)
            if type(meta)=="table" and type(rawget(meta,"__index"))=="table" and rawget(meta,"__index")~=value then
                result.inheritedMethods={}
                count=0
                for key,item in next,rawget(meta,"__index") do
                    count+=1;if count>128 then break end
                    if type(item)=="function" then result.inheritedMethods[#result.inheritedMethods+1]={name=tostring(key),functionId=inspectFunction(item,owner,key)} end
                end
            end
            return result
        end
        for index,item in ipairs(scripts) do
            -- Yield between scripts instead of monopolizing the client for ten full captures.
            deps.Wait()
            if not alive(generation) then report.cancelled=true;break end
            if targeted then tableFields=0 end
            local path=item:GetFullName()
            local row={path=path,class=item.ClassName,name=item.Name,sourceStatus="unavailable",bytecodeStatus="unsupported"}
            local filename=string.format("%04d_%s",index,item.Name:gsub("[^%w_%-]","_"):sub(1,70))
            checkpoint("read-source",path)
            local ok,source=pcall(function()return item.Source end)
            if not ok or not Runtime.ValidSource(source) then
                if type(A.decompile)=="function" then checkpoint("decompile",path);ok,source=pcall(A.decompile,item) end
            end
            if ok and Runtime.ValidSource(source) and #source<=1000000 then
                local file,err=write(captureFolder.."/"..filename..".lua",source)
                if file then row.sourceFile=file;row.sourceStatus="available";report.counts.source+=1
                else row.sourceStatus="write failed";row.sourceError=err end
            else
                report.counts.sourceErrors+=1
                row.sourceError=type(source)=="string" and source:sub(1,256) or tostring(source)
                if type(source)=="string" and source:lower():find("decompilation panicked",1,true) then row.sourceStatus="decompiler error stub" end
            end
            if type(A.getscriptbytecode)=="function" then
                checkpoint("getscriptbytecode",path)
                local byteOK,bytes=pcall(A.getscriptbytecode,item)
                if byteOK and type(bytes)=="string" and #bytes>0 then
                    if #bytes<=2000000 and report.counts.bytecodeBytes+#bytes<=32000000 then
                        local file,err=write(captureFolder.."/"..filename..".bytecode.bin",bytes)
                        if file then row.bytecodeFile=file;row.bytecodeBytes=#bytes;row.bytecodeStatus="raw binary; not source";report.counts.bytecode+=1;report.counts.bytecodeBytes+=#bytes
                        else row.bytecodeStatus="write failed";row.bytecodeError=err end
                    else row.bytecodeStatus="size limit" end
                else row.bytecodeStatus="unavailable";row.bytecodeError=tostring(bytes) end
            end
            if type(A.getscriptclosure)=="function" then
                checkpoint("getscriptclosure",path)
                local closureOK,fn=pcall(A.getscriptclosure,item)
                if closureOK then row.closureFunction=inspectFunction(fn,path,"script closure") else row.closureError=tostring(fn) end
            end
            if item:IsA("LocalScript") and type(A.getsenv)=="function" then
                checkpoint("getsenv",path)
                local envOK,value=pcall(A.getsenv,item)
                if envOK then row.environment=inspectTable(value,path) else row.environmentError=tostring(value) end
            end
            if item:IsA("ModuleScript") then
                if listLoadedModules then row.loadedModule=loaded[item]==true end
                row.loadedExportStatus=report.loadedExportsStatus
            end
            report.scripts[#report.scripts+1]=row
            if index%10==0 then status("Runtime: "..index.."/"..#scripts.." • Source "..report.counts.source.." • Bytecode "..report.counts.bytecode);deps.Wait() end
        end
        if gcFunctions and alive(generation) and type(A.getgc)=="function" and type(A.getfenv)=="function" then
            checkpoint("getgc")
            local ok,objects=pcall(A.getgc,false)
            if ok and type(objects)=="table" then
                for index,value in pairs(objects) do
                    if not alive(generation) then report.cancelled=true;break end
                    if type(value)=="function" and not seen[value] then
                        checkpoint("getfenv","GC function")
                        local envOK,environment=pcall(A.getfenv,value)
                        local owner=envOK and type(environment)=="table" and rawget(environment,"script")
                        if owner and known[owner] then
                            if inspectFunction(value,owner:GetFullName(),"getgc") then report.counts.gcFunctions+=1 end
                        end
                    end
                    if type(index)=="number" and index%500==0 then deps.Wait() end
                end
            else report.errors[#report.errors+1]={operation="getgc",error=tostring(objects)} end
        end
        checkpoint(report.cancelled and "cancelled" or "capture-complete")
        report.counts.scripts=#report.scripts;report.counts.functions=#report.functions
        self.Last=report
        local stamp=deps.Date("%Y%m%d_%H%M%S").."_"..tostring(generation)
        local ok,json=pcall(deps.JSON,report)
        if not ok then return nil,"JSON encoding failed: "..tostring(json) end
        local file,err=write(captureFolder.."/Runtime_"..stamp..".json",json)
        if not file then return nil,err end
        local text="DEVIL DUMP RUNTIME V8\nScope: "..report.scope.."\nPlace: "..report.placeId.."\nScripts: "..report.counts.scripts.."\nUsable Source: "..report.counts.source.."\nSource failures: "..report.counts.sourceErrors.."\nBytecode files: "..report.counts.bytecode.."\nFunctions inspected: "..report.counts.functions.."\nLoaded module exports: "..report.counts.loadedExports.."\nReport: "..file.."\nServer source: inaccessible. No inspected functions executed. No hooks installed. Raw bytecode and metadata are not recovered source."
        if targeted then text..="\nMissing targets: "..(#report.missingTargets>0 and table.concat(report.missingTargets,", ") or "none") end
        write(captureFolder.."/Summary_"..stamp..".txt",text)
        return file,text
    end
    function self:Start(scope)
        if self.Busy or self.Stopped then return false end
        self.Busy=true;self.Generation+=1
        local generation=self.Generation
        deps.Spawn(function()
            status(scope=="online-rewards" and "Capturing online reward modules..." or "Capturing runtime...")
            local ok,file,message=pcall(self.Capture,self,generation,scope)
            self.Busy=false
            if not self.Stopped then status(ok and (message or file or "Capture failed") or tostring(file)) end
        end)
        return true
    end
    function self:Destroy() self.Stopped=true;self.Generation+=1 end
    function self:Mount(window)
        local tab=window:CreateTab({Name="Runtime Capture",Icon="code"})
        local group=tab:CreateGroupbox({Name="Client Runtime v8",Icon="scan",Side="Left"})
        group:CreateParagraph({Name="Source + Bytecode + Runtime",Content="เก็บ Source ที่อ่านได้, Bytecode และเมธอด/ค่าคงที่ • ไม่เรียกใช้ฟังก์ชันที่ตรวจ • Error stub ไม่นับเป็น Source"})
        group:CreateToggle({Name="List loaded modules (metadata only)",CurrentValue=false,Callback=function(value)self.ListLoadedModules=value==true end})
        group:CreateToggle({Name="Scan GC functions (optional)",CurrentValue=false,Callback=function(value)self.GCFunctions=value==true end})
        group:CreateToggle({Name="Save diagnostic checkpoints",CurrentValue=true,Callback=function(value)self.Diagnostics=value==true end})
        group:CreateParagraph({Name="Capture diagnostics",Content="Capture never requires game modules. Loaded-module metadata and GC scanning are optional. LastOperation.txt records the release and last attempted API/script; it does not prove why a game disconnected."})
        group:CreateButton({Name="Dump Client Runtime v8",Callback=function()self:Start()end})
        group:CreateParagraph({Name="Online Rewards",Content="เปิดหน้ารางวัลออนไลน์ค้างไว้ แล้วกดปุ่มด้านล่าง ไม่ต้องรอครบเวลา • เก็บเฉพาะ OnlineData / OnlineGift / Reward / Helper และสคริปต์ลูก"})
        group:CreateButton({Name="Dump Online Rewards Only",Callback=function()self:Start("online-rewards")end})
        group:CreateButton({Name="ยกเลิก Runtime Capture",Callback=function()self.Generation+=1 end})
        self.Label=group:CreateParagraph({Name="Capture status",Content="พร้อม • ไฟล์อยู่ใน "..self.Folder})
    end
    return self
end
return Runtime
