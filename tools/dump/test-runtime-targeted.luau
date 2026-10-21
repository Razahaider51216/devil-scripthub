local Runtime=require("./runtime-capture")
local checks=0
local function check(value,message)assert(value,message);checks+=1 end
local function node(path,class)
    local n={Name=path:match("[^.]+$"),ClassName=class or "ModuleScript",Source=""}
    function n:GetFullName()return path end
    function n:IsA(kind)return kind==self.ClassName end
    return n
end
local paths={"ReplicatedStorage.LocalData.OnlineData","ReplicatedStorage.GuiUtils.OnlineGift",
    "ReplicatedStorage.Config.Online.Reward","ReplicatedStorage.Config.Online.Helper"}
local unrelated={}
for i=1,1300 do unrelated[i]=node("ReplicatedStorage.Other.Module"..i)end
local scripts=table.clone(unrelated)
local targets={}
for _,path in ipairs(paths)do local n=node(path);targets[#targets+1]=n;scripts[#scripts+1]=n end
local child=node(paths[2]..".WaitClaim","LocalScript");scripts[#scripts+1]=child
scripts[#scripts+1]=node(paths[2].."Fake")
local executed=0
local callback=function()executed+=1;error("game callback executed")end
local files,required={},{}
local root={GetDescendants=function()return scripts end}
local export={Time=42,Claim=callback,Nested={one={two={three={Balance=7}}}}}
local captured
local deps={Game={PlaceId=118805555015549,GameId=10684750879,GetService=function(_,name)
    if name=="ReplicatedStorage"then return root end
end},Alive=function()return true end,Spawn=function(fn)fn()end,Wait=function()end,
Date=function()return "test"end,Typeof=type,JSON=function(report)captured=report;return "report"end,
APIs={decompile=function()return "-- decompilation panicked"end,
    getloadedmodules=function()return {targets[1],targets[2],targets[3]}end,
    require=function(n)required[#required+1]=n;return export end,
    getscriptclosure=function()return callback end,
    getsenv=function()return {Claim=callback}end,
    getscriptbytecode=function()return "\0BYTECODE"end,
    getgc=function()return {callback}end,
    getfenv=function()return {script=unrelated[1]}end,
    getconstants=function()local result={};for i=1,100 do result[i]="constant"..i end;return result end,
    writefile=function(path,contents)files[path]=contents end,readfile=function(path)return files[path]end,
    makefolder=function()end,isfolder=function()return true end}}
local capture=Runtime.New(deps)
check(capture:Start("online-rewards"),"targeted capture did not start")
check(captured.scope=="online-rewards" and #captured.scripts==5,"unrelated modules consumed targeted budget")
check(#captured.missingTargets==0 and #captured.requestedTargets==4,"target coverage wrong")
check(captured.scripts[1].path==paths[1] and captured.scripts[2].path==paths[2],"state/UI not prioritized")
if Runtime.ModuleExecution==false then
    check(captured.counts.loadedExports==0 and #required==0,"targeted dump required game modules")
    check(captured.scripts[1].loadedModule==true,"missing loaded-module metadata")
else
    check(captured.counts.loadedExports==3 and #required==3,"required an unloaded module")
end
check(captured.counts.bytecode==5 and captured.counts.source==0,"stub accepted as source")
check(not captured.functionLimit and #captured.functions==1,"unrelated closures used function budget")
check(#captured.functions[1].constants==100,"targeted constants still capped at 64")
check(captured.limits.tableBudget=="per-script" and captured.limits.tableDepth==4,"targeted table budget wrong")
local nested
if Runtime.ModuleExecution~=false then
for _,f in ipairs(captured.scripts[1].loadedExport.fields)do if f.name=="Nested"then nested=f.members end end
check(nested and nested.fields[1].members.fields[1].members.fields[1].members.fields[1].value.value==7,"nested target state lost")
else
check(captured.scripts[1].loadedExport==nil and captured.scripts[1].loadedExportStatus==captured.loadedExportsStatus,"missing explicit unavailable export status")
end
local exported=false
for path,content in pairs(files)do if path:find("/OnlineRewards_",1,true) and path:find("Summary_",1,true) and content:find("Scope: online-rewards",1,true)then exported=true end end
check(exported,"targeted summary/folder missing")
check(executed==0 and captured.inspectedFunctionsExecuted==false and captured.hooksInstalled==false,"capture executed game functions")
scripts={targets[1]};required={}
capture:Start("online-rewards")
check(#captured.scripts==1 and #captured.missingTargets==3,"missing targets reported as complete")
capture.LoadedExports=false;required={};capture:Start("online-rewards")
check(#required==0 and captured.counts.loadedExports==0,"export toggle ignored")
local buttons={}
local group={CreateParagraph=function()return {Set=function()end}end,CreateToggle=function()end,
    CreateButton=function(_,config)buttons[config.Name]=config.Callback end}
capture:Mount({CreateTab=function()return {CreateGroupbox=function()return group end}end})
check(type(buttons["Dump Online Rewards Only"])=="function","targeted GUI button missing")
buttons["Dump Online Rewards Only"]()
check(captured.scope=="online-rewards","GUI button runs wrong mode")
capture:Destroy();check(not capture:Start("online-rewards"),"destroyed capture restarted")
print("PASS targeted runtime: "..checks.." checks")
