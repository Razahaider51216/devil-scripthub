local Runtime=require("./runtime-capture")
local checks=0
local function check(v,msg)assert(v,msg);checks+=1 end
local function scriptNode(name,class,source)
    local node={Name=name,ClassName=class,Source=source}
    function node:IsA(kind)return self.ClassName==kind end
    function node:GetFullName()return "ReplicatedStorage."..name end
    return node
end
local module=scriptNode("Loaded","ModuleScript","")
local client=scriptNode("Client","LocalScript","")
local unloaded=scriptNode("Unloaded","ModuleScript","return {}")
local callback=function()error("inspected game function executed")end
local files,calls={},{}
local latestTrace=""
local function store(path,value)
    files[path]=value
    if path:find("LastOperation.txt",1,true)then latestTrace=value end
end
local yields=0
local lastReport
local root={Name="ReplicatedStorage",GetDescendants=function()return {module,client,unloaded}end}
local function count(name)calls[name]=(calls[name]or 0)+1 end
local function currentTrace()
    return latestTrace
end
local function traceIs(operation,path)
    check(currentTrace():find("Operation: "..operation.."\n",1,true)~=nil,"checkpoint not written before "..operation)
    if path then check(currentTrace():find("Script: "..path.."\n",1,true)~=nil,"wrong script checkpoint")end
end
local deps={
    Game={PlaceId=107778070777162,GameId=1,GetService=function(_,name)if name=="ReplicatedStorage"then return root end end},
    Alive=function()return true end,Spawn=function(fn)fn()end,Wait=function()yields+=1 end,
    Date=function()return "test"end,Typeof=type,
    JSON=function(report)lastReport=report;return "json"end,
    APIs={
        writefile=store,readfile=function(path)return files[path]end,
        makefolder=function()end,isfolder=function()return true end,
        decompile=function(node)count("decompile");traceIs("decompile",node:GetFullName());error("unsupported source")end,
        getscriptbytecode=function(node)traceIs("getscriptbytecode",node:GetFullName());return "\0BYTECODE"end,
        getscriptclosure=function(node)traceIs("getscriptclosure",node:GetFullName());return callback end,
        getsenv=function(node)traceIs("getsenv",node:GetFullName());return {Method=callback}end,
        getloadedmodules=function()count("loaded");traceIs("getloadedmodules");return {module}end,
        require=function(node)count("require");traceIs("require-loaded-export",node:GetFullName());check(node==module,"required unloaded module");return {Method=callback}end,
        getgc=function()count("gc");traceIs("getgc");return {}end,
        getfenv=function()return {}end,
    }
}
local capture=Runtime.New(deps)
check(not capture.ListLoadedModules and not capture.GCFunctions,"expensive optional scans enabled by default")
check(capture:Start(),"default capture failed to start")
check(not calls.loaded and not calls.require and not calls.gc,"default capture calls optional APIs")
check(lastReport.counts.scripts==3 and lastReport.counts.bytecode==3,"lost normal V8 output")
check(lastReport.counts.source==1 and lastReport.counts.sourceErrors==2,"API errors abort collection")
check(yields>=3,"no per-script scheduling yield")
check(currentTrace():find("Operation: capture-complete",1,true)~=nil,"missing completion marker")
check(lastReport.options.diagnostics and not lastReport.options.loadedExports,"incorrect report defaults")
capture.LoadedExports=true;capture.ListLoadedModules=true;capture.GCFunctions=true
capture:Start()
check(calls.loaded==1 and not calls.require and calls.gc==1,"optional metadata APIs or no-require rule failed")
check(lastReport.counts.loadedExports==0 and lastReport.moduleExecutionEnabled==false,"report claims exports read")
check(lastReport.scripts[1].loadedModule and not lastReport.scripts[3].loadedModule,"loaded metadata incorrect")
check(currentTrace():find("Release: "..Runtime.Version,1,true)~=nil,"release missing from diagnostic")
capture.LoadedExports=false;capture.ListLoadedModules=false;capture.GCFunctions=false
local oldWait=deps.Wait
local ticks=0
deps.Wait=function()oldWait();ticks+=1;if ticks==2 then capture.Generation+=1 end end
capture:Start()
check(lastReport.cancelled and lastReport.counts.scripts==1,"cancel does not stop per-script capture")
check(currentTrace():find("Operation: cancelled",1,true)~=nil,"cancel checkpoint missing")
deps.Wait=oldWait
local writes=0
deps.APIs.writefile=function(path,value)
    if path:find("LastOperation.txt",1,true)then error("trace disk error")end
    files[path]=value;writes+=1
end
capture:Start()
check(lastReport.progressError and lastReport.counts.scripts==3 and writes>0,"diagnostic failure aborts dump")
-- A blocked executor API must leave the checkpoint on disk before returning control.
deps.APIs.writefile=store
local pending=coroutine.create(function()capture:Start()end)
deps.APIs.decompile=function(node)coroutine.yield("blocked")end
local resumed,reason=coroutine.resume(pending)
check(resumed and reason=="blocked","blocking fixture did not suspend capture")
traceIs("decompile","ReplicatedStorage.Loaded")
check(capture.Busy,"overlapping capture allowed while API blocked")
check(not capture:Start(),"duplicate capture started")
capture:Destroy();check(not capture:Start(),"destroyed capture restarted")
print("PASS V8 diagnostics/defaults/cancellation/API-error/blocked-call: "..checks.." checks")
