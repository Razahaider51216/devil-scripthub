local make=(function()
-- TEST_NAVIGATION
end)()
local checks=0
local function check(v,m)assert(v,m);checks+=1 end
local function fixture()
    local work,calls={},{};local time=0;local failure
    local net={JobId="current",Now=function()return time end,Spawn=function(fn)work[#work+1]=fn end}
    net.OnFailure=function(fn)failure=fn;return {Disconnect=function()failure=nil end}end
    net.List=function(cursor)calls[#calls+1]={Kind="list",Cursor=cursor};return {data={{id="current",playing=1,maxPlayers=10},{id="full",playing=10,maxPlayers=10},{id="other",playing=2,maxPlayers=10}}}end
    net.Teleport=function(id)calls[#calls+1]={Kind="teleport",Id=id}end
    local report={};local n=make(net,report)
    local function flush()local batch=work;work={};for _,fn in ipairs(batch)do fn()end end
    return n,net,calls,flush,function(v)time+=v;n.Tick()end,function(m)if failure then failure(m)end end,report
end
do
    local n,net,calls,flush,tick,fail,report=fixture()
    check(#calls==0,"startup performed server operations")
    n.Rejoin();n.Hop();flush();check(#calls==1 and calls[1].Id=="current","rejoin or duplicate guard failed")
    check(n.Busy and report.Navigation.Busy,"teleport falsely reported completed")
    fail("instance full");check(not n.Busy and n.Status:find("instance full",1,true),"async teleport failure not shown")
    n.Hop();flush();check(calls[#calls].Id=="other","hop selected current/full server")
    tick(26);check(not n.Busy and n.Status:find("did not complete",1,true),"missing teleport completion locked UI forever")
    net.List=function()return {data={{id="other",playing=1,maxPlayers=10}}}end
    n.Hop();flush();check(not n.Busy and n.Status:find("No other",1,true),"failed server immediately revisited")
    n.Destroy();n.Rejoin();flush();check(n.Stopped and not n.Busy,"unloaded navigation continued")
end
do
    local n,net,calls,flush=fixture();local pages=0
    net.List=function(cursor)
        pages+=1
        if not cursor then return {data={},nextPageCursor="next+cursor"}end
        check(cursor=="next+cursor","pagination cursor lost")
        return {data={{id="next-server",playing=0,maxPlayers=10}}}
    end
    n.Hop();flush();check(pages==2 and calls[1].Id=="next-server","second-page server not selected")
end
do
    local n,net,calls,flush=fixture();local pages=0
    net.List=function()pages+=1;return {data={},nextPageCursor="repeat"}end
    n.Hop();flush();check(pages==2 and not n.Busy and #calls==0,"repeated cursor not bounded")
    net.List=function()error("HTTP 429")end
    n.Hop();flush();check(not n.Busy and n.Status:find("HTTP 429",1,true),"HTTP error left navigation busy")
    net.List=function()return {invalid=true}end
    n.Hop();flush();check(not n.Busy and n.Status:find("Invalid server list",1,true),"malformed list ignored")
end
do
    local n,net,calls,flush=fixture();net.RejoinTarget=function()return nil end
    n.Rejoin();flush();check(#calls==1 and calls[1].Id==nil,"solo rejoin did not request place matchmaking")
end
do
    local n,net,calls,flush=fixture()
    net.Teleport=function()error("teleport unavailable")end
    n.Rejoin();flush();check(not n.Busy and n.Status:find("teleport unavailable",1,true),"synchronous failure not recoverable")
end
do
    local n,net,calls,flush=fixture()
    n.Hop();n.Destroy();flush();check(#calls==0,"queued hop ran after unload")
end
do
    local n,net,calls,flush,tick=fixture();local worker
    net.List=function()coroutine.yield();return {data={{id="other",playing=1,maxPlayers=10}}}end
    net.Spawn=function(fn)worker=coroutine.create(fn);check(coroutine.resume(worker),"search failed")end
    n.Hop();tick(60);n.Hop();check(n.Busy and #calls==0,"pending search allowed overlapping requests")
    n.Destroy();check(coroutine.resume(worker),"unload failed during search");check(#calls==0,"search result teleported after unload")
end
print("PASS Anime Dice navigation: rejoin, filtered/paginated hop, concurrency, failures, timeout and unload: "..checks.." checks")
