-- Manual server controls. No HTTP/teleport work runs at startup.
return function(net,report)
    local N={Status="Ready",Busy=false,Stopped=false}
    local generation=0;local visited={};local failureLink;local started=0;local active=false;local awaiting=false
    local function status(text)N.Status=text;report.Navigation={Status=text,Busy=N.Busy}end
    local function finish(text)N.Busy=false;awaiting=false;status(text)end
    local function begin(kind)
        if N.Stopped or N.Busy or active then return end
        N.Busy=true;generation+=1;local token=generation;started=net.Now();active=token;awaiting=false
        status(kind=="Hop"and"Finding another server..."or"Rejoining...")
        net.Spawn(function()
            local function valid()return not N.Stopped and generation==token end
            local ok,err=pcall(function()
                if not valid()then return end
                if not failureLink and net.OnFailure then
                    failureLink=net.OnFailure(function(message)
                        if N.Busy and awaiting and not N.Stopped then generation+=1;finish("Teleport failed: "..tostring(message):sub(1,160))end
                    end)
                end
                local target
                if kind=="Rejoin"then
                    if net.RejoinTarget then target=net.RejoinTarget()else target=net.JobId~=""and net.JobId or nil end
                else
                    local cursor;local seen={}
                    for _=1,5 do
                        local page=net.List(cursor)
                        if not valid()then return end
                        assert(type(page)=="table"and type(page.data)=="table","Invalid server list")
                        for _,server in ipairs(page.data)do
                            local id=server.id
                            if type(id)=="string"and id~=""and id~=net.JobId and not visited[id]
                                and type(server.playing)=="number"and type(server.maxPlayers)=="number"
                                and server.playing<server.maxPlayers then target=id;break end
                        end
                        if target then break end
                        cursor=page.nextPageCursor
                        if type(cursor)~="string"or cursor==""or seen[cursor]then break end
                        seen[cursor]=true
                    end
                    if not target then finish("No other available server found. Try again later.");return end
                    visited[target]=true
                end
                if not valid()then return end
                status(kind=="Hop"and"Joining another server..."or"Rejoining game...");awaiting=true
                net.Teleport(target)
                if valid()and N.Busy then started=net.Now();status("Teleport requested; waiting for Roblox...")end
            end)
            if active==token then active=false end
            if valid()and not ok then finish("Could not change server: "..tostring(err):sub(1,160))end
        end)
    end
    function N.Rejoin()begin("Rejoin")end
    function N.Hop()begin("Hop")end
    function N.Tick()
        if N.Busy and not active and net.Now()-started>25 then generation+=1;finish("Teleport did not complete. Try again.")end
    end
    function N.Destroy()
        N.Stopped=true;generation+=1;N.Busy=false
        if failureLink then failureLink:Disconnect();failureLink=nil end
    end
    return N
end
