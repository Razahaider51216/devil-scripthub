-- Break and Steal an Egg only: share one selection with its native translator.
-- The game engine, automation callbacks and shared theme module stay original.
return function()
    if game.GameId~=10765288803 and game.PlaceId~=114326934417838 then return end
    local scope=type(getgenv)=="function"and getgenv()or _G
    local owner=scope.DevilHubBlueGui
    if not owner or owner.Stopped or type(owner.Set)~="function"or type(owner.Get)~="function"then return end
    local previous=scope.DevilBreakLanguageSync
    if previous and not previous.Stopped then
        if previous.Owner==owner then previous.Sync();return previous end
        previous.Destroy()
    end
    local state={Version="break-language-sync-20261020-1",Owner=owner,Stopped=false}
    local originalSet,originalDestroy=owner.Set,owner.Destroy
    local nativeApi,nativeSet,nativeProxy,heartbeat,destroy
    local setting=false
    local function valid(value)return value=="EN"or value=="TH"end
    local function disconnect()
        if heartbeat then heartbeat:Disconnect();heartbeat=nil end
    end
    local function restoreNative()
        if nativeApi and nativeApi.SetLanguage==nativeProxy then nativeApi.SetLanguage=nativeSet end
        nativeApi,nativeSet,nativeProxy=nil,nil,nil
    end
    local function attachNative()
        local api=scope.DevilBreakSettings
        if type(api)~="table"or type(api.SetLanguage)~="function"then return false end
        if api==nativeApi and api.SetLanguage==nativeProxy then return true end
        restoreNative()
        nativeApi,nativeSet=api,api.SetLanguage
        nativeProxy=function(value)
            if not valid(value)then return end
            if setting then return nativeSet(value)end
            return owner.SetLanguage(value)
        end
        api.SetLanguage=nativeProxy
        return true
    end
    local function set(values)
        if state.Stopped or setting then return originalSet(values)end
        local value=type(values)=="table"and values.Language
        if not valid(value)then return originalSet(values)end
        setting=true
        scope.DevilBreakLanguage=value
        attachNative()
        if nativeSet then
            local ok,problem=pcall(nativeSet,value)
            state.NativeError=not ok and tostring(problem)or nil
        end
        -- Refresh overlays after the native renderer has changed source text.
        local result=table.pack(pcall(originalSet,values))
        setting=false
        if not result[1]then error(result[2],0)end
        return table.unpack(result,2,result.n)
    end
    owner.Set=set
    function state.Sync()
        if state.Stopped or owner.Stopped then return end
        local value=owner.Get().Language
        if not valid(value)then return end
        scope.DevilBreakLanguage=value
        if attachNative()then owner.Set({Language=value});disconnect();return true end
    end
    function state.Destroy()
        if state.Stopped then return end
        state.Stopped=true;disconnect();restoreNative()
        if owner.Set==set then owner.Set=originalSet end
        if owner.Destroy==destroy then owner.Destroy=originalDestroy end
        if scope.DevilBreakLanguageSync==state then scope.DevilBreakLanguageSync=nil end
    end
    destroy=function()
        state.Destroy()
        if owner.Destroy==destroy then owner.Destroy=originalDestroy end
        if type(originalDestroy)=="function"then return originalDestroy()end
    end
    if type(originalDestroy)=="function"then owner.Destroy=destroy end
    scope.DevilBreakLanguageSync=state
    -- The native API is exported after the window is created. Catch that handoff
    -- without starting any game features or waiting in the loader thread.
    if not state.Sync()then
        pcall(function()
            local started=os.clock()
            heartbeat=game:GetService("RunService").Heartbeat:Connect(function()
                if state.Stopped or owner.Stopped or os.clock()-started>120 then disconnect();return end
                state.Sync()
            end)
        end)
    end
    return state
end
