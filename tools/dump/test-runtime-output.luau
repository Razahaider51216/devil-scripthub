local Runtime=require("./runtime-capture")
local checks=0
local function check(ok,message) assert(ok,message);checks+=1 end
local function scriptNode(name,class,source)
    local item={Name=name,ClassName=class,Source=source or ""}
    function item:IsA(kind)return self.ClassName==kind end
    function item:GetFullName()return "ReplicatedStorage."..self.Name end
    return item
end
local valid=scriptNode("Valid","ModuleScript","return {}")
local panic=scriptNode("RollRefreshTransaction","ModuleScript")
local localScript=scriptNode("Client","LocalScript")
local notLoaded=scriptNode("NotLoaded","ModuleScript")
local inspected=function()error("inspected function executed")end
local gcFunction=function()error("GC function executed")end
local files,folders={},{}
local required={}
local root={GetDescendants=function()return {valid,panic,localScript,notLoaded}end}
local player={FindFirstChild=function()return nil end}
local game={PlaceId=1,GameId=2,GetService=function(_,name)
    if name=="Players"then return {LocalPlayer=player}end
    if name=="ReplicatedStorage"then return root end
end}
local captured
local deps={Game=game,Alive=function()return true end,Spawn=function(fn)fn()end,Wait=function()end,Date=function()return "test"end,
    Typeof=type,JSON=function(report)captured=report;return "encoded-report"end,APIs={
        decompile=function()return "-- decompilation panicked"end,
        getscriptbytecode=function(item)if item==panic or item==localScript then return "\0\255BYTECODE"end error("unsupported")end,
        getscriptclosure=function()return inspected end,
        getsenv=function()return {Roll=inspected}end,
        getloadedmodules=function()return {panic}end,
        require=function(item)required[#required+1]=item;return {Roll=inspected,Version=1}end,
        getgc=function()return {gcFunction,inspected}end,
        getfenv=function(fn)return fn==gcFunction and {script=panic}or {}end,
        getconstants=function()return {"Roll","\255",1,true}end,
        getupvalues=function()return {1,"state"}end,
        info=function(_,mode)if mode=="a"then return 2,false end return "client",12,"Roll"end,
        writefile=function(path,contents)files[path]=contents end,
        readfile=function(path)return files[path]end,
        makefolder=function(path)folders[path]=true end,
        isfolder=function(path)return folders[path]end,
    }}
check(not Runtime.ValidSource("-- decompilation panicked"),"accepted panic stub")
check(not Runtime.ValidSource("-- comments only\n-- no code"),"accepted comments-only source")
check(Runtime.ValidSource("-- header\nreturn {}"),"rejected source")
local capture=Runtime.New(deps)
check(capture:Start(),"capture did not start")
check(captured.counts.scripts==4 and captured.counts.source==1 and captured.counts.sourceErrors==3,"source classification/counts")
check(captured.counts.bytecode==2 and captured.counts.bytecodeBytes==20,"bytecode counts")
if Runtime.ModuleExecution==false then
    check(#required==0 and captured.counts.loadedExports==0,"capture required game module")
    check(captured.scripts[2].loadedModule==true and captured.scripts[4].loadedModule==false,"loaded metadata missing")
    check(captured.moduleExecutionEnabled==false and captured.counts.gcFunctions==1,"runtime metadata failed")
else
    check(#required==1 and required[1]==panic,"initialized an unloaded module")
    check(captured.counts.loadedExports==1 and captured.counts.gcFunctions==1,"runtime fallback failed")
end
check(captured.scripts[2].sourceStatus=="decompiler error stub" and not captured.scripts[2].sourceFile,"exported panic as source")
check(files[captured.scripts[2].bytecodeFile]=="\0\255BYTECODE","binary bytes corrupted")
check(captured.functions[1].parameters==2 and #captured.functions[1].constants==4,"missing function metadata")
local binary=false
for _,constant in ipairs(captured.functions[1].constants)do if constant.value.encoding=="hex"then binary=true end end
check(binary,"unsafe binary constant in JSON")
check(captured.inspectedFunctionsExecuted==false and captured.hooksInstalled==false and captured.serverSourceAccessible==false,"misleading capabilities")
capture.LoadedExports=false;table.clear(required);capture:Start()
check(#required==0 and captured.counts.loadedExports==0,"disabled exports still required modules")
deps.APIs.writefile=nil
local failed=Runtime.New(deps);failed:Start()
check(failed.Status=="writefile unavailable","unsupported writer claimed success")
capture:Destroy();check(not capture:Start(),"destroyed capture restarted")
print("PASS runtime capture: "..checks.." checks")
