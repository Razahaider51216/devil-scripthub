-- BEGIN DEVIL AUTO EXECUTE
do
    local scope=type(getgenv)=="function"and getgenv()or _G
    local current=scope.DevilHubAutoExecute
    if not(current and current.Version=="devil-auto-execute-1"and(current.Link or current.Queued))then
        local state={Version="devil-auto-execute-1",Status="Unavailable",Queued=false}
        scope.DevilHubAutoExecute=state
        local ok,problem=pcall(function()
            local candidates={}
            local function add(fn)
                if type(fn)~="function"then return end
                for _,existing in ipairs(candidates)do if existing==fn then return end end
                candidates[#candidates+1]=fn
            end
            add(queue_on_teleport);add(queueonteleport)
            add(scope.queue_on_teleport);add(scope.queueonteleport)
            for _,namespace in ipairs({"syn","fluxus"})do
                local api=scope[namespace]or(namespace=="syn"and syn or fluxus)
                if type(api)=="table"then add(api.queue_on_teleport);add(api.queueonteleport)end
            end
            if #candidates==0 then return end
            local payload=[==[
local scope=type(getgenv)=="function"and getgenv()or _G
if scope.DevilHubAutoExecuteArrival then return end
scope.DevilHubAutoExecuteArrival=true
if not game:IsLoaded()then game.Loaded:Wait()end
for attempt=1,3 do
    local ok,problem=pcall(function()
        local source=game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader?v=vm-1")
        assert(type(source)=="string"and #source>0 and not source:match("^%s*<"),"Invalid DEVIL HUB loader response")
        local run,err=loadstring(source,"DEVIL HUB / Auto Execute")
        assert(run,err)
        return run()
    end)
    if ok then return end
    if attempt<3 then task.wait(attempt*2)
    else scope.DevilHubAutoExecuteArrival=nil;warn("DEVIL HUB Auto Execute: "..tostring(problem))end
end
]==]
            local function queue()
                if state.Queued then return end
                for _,fn in ipairs(candidates)do
                    local queued,result=pcall(fn,payload)
                    if queued and result~=false then state.Queued=true;state.Status="Queued";state.LastError=nil;return end
                    state.LastError=tostring(result)
                end
                state.Status="Queue failed"
            end
            local player=game:GetService("Players").LocalPlayer
            if player and player.OnTeleport then
                state.Link=player.OnTeleport:Connect(function(status)
                    if status==Enum.TeleportState.Started or status==Enum.TeleportState.InProgress then queue()
                    elseif status==Enum.TeleportState.Failed then state.Queued=false;state.Status="Ready"end
                end)
                state.Status="Ready"
            else
                -- Some executors cannot expose the event; preload their queue.
                queue()
            end
        end)
        if not ok then state.Status="Unavailable";state.LastError=tostring(problem)end
    end
end
-- END DEVIL AUTO EXECUTE
