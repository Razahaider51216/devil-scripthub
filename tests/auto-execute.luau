local nativeCompile=loadstring
local checks=0
local function check(ok,message)checks+=1;assert(ok,message)end
local states={Started=1,InProgress=4,Failed=3,WaitingForServer=2}
local function setup(api,noEvent)
    local shared,callbacks,queued={},{},{}
    local event={Connect=function(_,fn)
        callbacks[#callbacks+1]=fn
        return {Connected=true,Disconnect=function()end}
    end}
    local env=setmetatable({getgenv=function()return shared end,Enum={TeleportState=states},
        game={GetService=function()return {LocalPlayer={OnTeleport=not noEvent and event or nil}}end},
        queue_on_teleport=false,queueonteleport=false,syn=false,fluxus=false},{__index=getfenv(0)})
    local queue=function(code)queued[#queued+1]=code end
    if api=='global'then env.queue_on_teleport=queue
    elseif api=='alias'then env.queueonteleport=queue
    elseif api=='scope'then shared.queue_on_teleport=queue
    elseif api=='syn'then env.syn={queue_on_teleport=queue}
    elseif api=='fluxus'then shared.fluxus={queue_on_teleport=queue}
    elseif api=='fallback'then env.queue_on_teleport=function()error('unsupported')end;env.queueonteleport=queue
    elseif api=='false'then env.queue_on_teleport=function()return false end;env.queueonteleport=queue
    elseif api=='broken'then env.queue_on_teleport=function()error('unsupported')end end
    local run=assert(nativeCompile(bootstrap));setfenv(run,env)
    return run,shared,queued,callbacks,env
end
for _,api in ipairs({'global','alias','scope','syn','fluxus','fallback','false'})do
    local run,shared,queued,callbacks=setup(api)
    run();check(shared.DevilHubAutoExecute.Status=='Ready'and #queued==0,'did not arm quietly: '..api)
    run();check(#callbacks==1,'rerun duplicated listener: '..api)
    callbacks[1](states.WaitingForServer);check(#queued==0,'queued on unrelated state')
    callbacks[1](states.Started);callbacks[1](states.InProgress)
    check(#queued==1 and shared.DevilHubAutoExecute.Status=='Queued','failed / duplicated teleport queue: '..api)
    callbacks[1](states.Failed);callbacks[1](states.Started)
    check(#queued==2,'failed teleport blocked retry: '..api)
end
do
    local run,shared,queued,callbacks=setup('missing');run()
    check(shared.DevilHubAutoExecute.Status=='Unavailable'and #callbacks==0 and #queued==0,'missing APIs interrupted / installed event')
    local ready,armed,payloads=setup('global',true);ready();ready()
    check(armed.DevilHubAutoExecute.Queued and #payloads==1,'eventless fallback duplicated / omitted queue')
    local broken,bstate,bqueue,events=setup('broken');broken();events[1](states.Started)
    check(bstate.DevilHubAutoExecute.Status=='Queue failed'and #bqueue==0,'throwing queue escaped callback')
    events[1](states.InProgress);check(bstate.DevilHubAutoExecute.Status=='Queue failed','retrying queue error escaped callback')
end
local function arrive(payload,failures,invalid,compileError)
    local scope,downloads,launches,waits,warnings={},0,0,0,0
    local loaded=false
    local env=setmetatable({getgenv=function()return scope end,
        task={wait=function()waits+=1 end},warn=function()warnings+=1 end,
        game={IsLoaded=function()return loaded end,Loaded={Wait=function()loaded=true end}}},{__index=getfenv(0)})
    function env.game:HttpGet(url)
        check(loaded,'download began before game loaded')
        check(url=='https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader?v=vm-1','queued wrong loader')
        downloads+=1
        if downloads<=(failures or 0)then error('network unavailable')end
        return invalid and '<html>error</html>'or 'return true'
    end
    env.loadstring=function(code,label)
        check(code=='return true'and label=='DEVIL HUB / Auto Execute','invalid body was compiled')
        if compileError then return nil,'compiler unavailable'end
        return function()launches+=1 end
    end
    local run=assert(nativeCompile(payload));setfenv(run,env)
    run()
    return run,scope,function()return downloads,launches,waits,warnings end
end
do
    local run,_,queue,events=setup('global');run();events[1](states.Started)
    local payload=queue[1]
    local arrival,scope,counts=arrive(payload,2)
    local downloads,launches,waits,warnings=counts()
    check(downloads==3 and launches==1 and waits==2 and warnings==0,'arrival retry / launch wrong')
    arrival();check(counts()==3,'duplicate queued payload downloaded again')
    for _,mode in ipairs({'network','html','compile'})do
        local _,failed,totals=arrive(payload,mode=='network'and 3 or 0,mode=='html',mode=='compile')
        local attempts,started,pauses,notices=totals()
        check(attempts==3 and started==0 and pauses==2 and notices==1 and failed.DevilHubAutoExecuteArrival==nil,'arrival failure did not release guard: '..mode)
    end
end
print('PASS Auto Execute API aliases, teleport lifecycle, duplicate guards, failures and destination reload: '..checks..' checks')
