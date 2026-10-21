local checks=0
local function check(v,m)assert(v,m);checks+=1 end
local queue,requests={},{}
local block=false
local remote={}
function remote:IsA(kind)return kind=="RemoteFunction"end
function remote:InvokeServer(...)
    table.insert(requests,table.pack(...))
    if block then coroutine.yield("pending-server")end
    return {ok=true}
end
local event={}
function event:IsA(kind)return kind=="RemoteEvent"end
function event:FireServer(...)table.insert(requests,table.pack(...))end
local htfRemotes={FindFirstChild=function(_,name)if name=="Meta"or name=="Tower"or name=="Race"then return remote elseif name=="Ability"then return event end end}
local htf={FindFirstChild=function(_,name)if name=="Remotes"then return htfRemotes end end}
local sharedRemotes={FindFirstChild=function(_,name)if name=="GetData"then return remote elseif name=="RequestTrainHit"then return event end end}
local player={}
local rs={FindFirstChild=function(_,name)if name=="HatchToFight"then return htf elseif name=="Remotes"then return sharedRemotes end end}
local game={GetService=function(_,name)
    if name=="Players"then return {LocalPlayer=player}elseif name=="ReplicatedStorage"then return rs else return {}end
end}
local task={spawn=function(fn)table.insert(queue,coroutine.create(fn))end}
-- ADAPTER
local scope={};local A=makeAdapter(scope,{})
local time=0;A.Now=function()return time end
check(#requests==0 and #queue==0,"adapter startup sends game requests")
local callbackCount=0
check(A.Call("Meta",table.pack("command",nil,"tail",nil),function()callbackCount+=1 end,"Rewards"),"request not queued")
check(not A.Call("Meta",table.pack("duplicate")),"concurrent lane request accepted")
local first=table.remove(queue,1);local ok,err=coroutine.resume(first);check(ok,tostring(err))
check(#requests==1 and requests[1].n==4 and requests[1][2]==nil and requests[1][3]=="tail","nil positions changed")
check(callbackCount==1 and not A.Pending.Meta,"lane not released")
check(A.Call("Data",table.pack(),nil,"Farm"),"data queue")
A.CancelJob("Farm");coroutine.resume(table.remove(queue,1))
check(#requests==1 and not A.Pending.Data,"cancelled queued request executed")
block=true
A.Call("Meta",table.pack("State"),function()callbackCount+=1 end)
local pending=table.remove(queue,1);local resumed,reason=coroutine.resume(pending)
check(resumed and reason=="pending-server","pending fixture did not suspend")
time=20;check(not A.Call("Meta",table.pack("State")),"timeout creates duplicate server request")
A.Destroy();local B=makeAdapter(scope,{});B.Now=function()return time end
check(not B.Call("Meta",table.pack("State")),"reload stacks blocked server requests")
coroutine.resume(pending)
check(callbackCount==1,"unloaded request invoked callback")
check(not B.Pending.Meta,"finished old lane not released")
block=false;B.Call("Meta",table.pack("State"));coroutine.resume(table.remove(queue,1))
check(type(B.Cache.Meta)=="table","state response not cached")
local sent=0
for _ in pairs(B.Pending)do sent+=1 end
check(sent==0,"completed lanes leaked")
local fired=B.Fire("RequestTrainHit")
check(fired and requests[#requests].n==0,"training event path or argument count incorrect")
local result,why=B.Fire("Missing")
check(not result and why:find("Missing",1,true),"missing remote not reported")
B.Destroy();check(not B.Fire("Ability","Attack"),"unloaded adapter fires game event")
print("PASS HatchToFight adapter concurrency/lifecycle: "..checks.." checks")
