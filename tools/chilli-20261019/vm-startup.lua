-- Checkpoints inside the two native interpreters, before the GUI is constructed.
-- Never replace executor globals, compiler environments, or game bytecode.
return function(stage)
    local clock=os.clock
    local wait=task and task.wait
    local started,lastSlice,lastReport=clock(),clock(),clock()
    local active=true
    local dispatches,yields=0,0
    local failure
    return function(method,state,pc,opcode)
        if method=="finish"then active=false;return end
        if not active then return end
        if failure then error(failure,0)end
        dispatches+=512
        local now=clock()
        local detail={Method=method,State=state,PC=pc,Opcode=opcode,
            Dispatches=dispatches,Yields=yields,Seconds=now-started}
        if now-started>=120 then
            failure="DEVIL HUB: Steal startup exceeded 120s at VM "..method.." / PC "..tostring(pc)..
                ". See DevilHub-Steal-Startup.json."
            stage("VM startup timed out",detail)
            error(failure,0)
        end
        if now-lastReport>=1 then
            lastReport=now
            stage("VM initialization",detail)
        end
        if now-lastSlice>=.004 then
            if type(wait)~="function"then
                failure="DEVIL HUB: executor task.wait is unavailable; cannot initialize VM safely."
                stage("VM scheduler unavailable",detail)
                error(failure,0)
            end
            yields+=1
            wait()
            -- Time spent yielding does not consume the next frame's CPU slice.
            lastSlice=clock()
        end
    end
end
