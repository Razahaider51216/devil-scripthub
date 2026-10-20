-- BEGIN SHARED DEVIL BLUE GUI
do
    local shared=type(getgenv)=="function"and getgenv()or _G
    local current=shared.DevilHubBlueGui
    if not(current and current.Version=="devil-blue-20261019-10"and not current.Stopped)then
        local ok,problem=pcall(function()
            local source=game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/9a9812469df7b5dad2848abb33c5206f7d57e685/devil-blue-gui.lua")
            assert(type(source)=="string"and #source==95003,"DEVIL blue GUI download size mismatch")
            local sum=0
            for i=1,#source do sum=(sum*33+source:byte(i))%4294967296;if i%32768==0 and task and task.wait then task.wait()end end
            assert(sum==941138957,"DEVIL blue GUI checksum mismatch")
            local run,err=loadstring(source,"DEVIL HUB / Blue GUI")
            assert(run,err)
            return run()
        end)
        if not ok then warn("DEVIL HUB: blue GUI could not start: "..tostring(problem))end
    end
end
-- END SHARED DEVIL BLUE GUI
-- DEVIL HUB: route only; gameplay and GUI remain in their own game modules.
local env=type(getgenv)=="function"and getgenv()or _G
if env.DevilHubRouterLoading then return end
local games={
    {Name="Anime Dice",Universe=10708913337,Place=113290951185459,File="anime-dice-test.lua",Commit="ea790b8bfd404e47512b95d9a8d650628dd246fe",Version="anime-dice-test-20261020-12"},
    {Name="Mine / Dump23",Universe=10740316645,Place=79389059854988,File="mine-auto-test.lua",Commit="e39fb7f24bda4d132f439416c7c68ad7467ff351",Version="mine-auto-test-4"},
    {Name="Tap Simulator 2",Universe=10629695169,Place=72858262610964,File="tapping-auto-test.lua",Commit="e39fb7f24bda4d132f439416c7c68ad7467ff351",Version="tapping-auto-test-10"},
    {Name="Climb for Eggs",Universe=10765490774,Place=85738654635245,File="climb-for-eggs.lua",Commit="fa18b61e74e788a1825123d7bf3182b628c3463f",Version="climb-language-sync-20261020-12"},
    {Name="Lift Rock for Eggs",Universe=10768316438,Place=76731343328034,File="lift-rock-for-eggs.lua",Commit="e39fb7f24bda4d132f439416c7c68ad7467ff351",Version="lift-rock-fly-23"},
    {Name="Ride A Fish",Universe=10766691148,Place=104050046639813,File="aqua-auto-egg.lua",Commit="e39fb7f24bda4d132f439416c7c68ad7467ff351",Version="aqua-auto-egg-18"},
    {Name="Steal an Egg",Universe=10563114921,Place=107778070777162,File="devil-steal-an-egg.lua",Commit="bceae2ad767b4ee309d4ad430caa2fd6aebf0c7e",Version="chilli-fishing-rotation-20261020-1"},
    {Name="Ride a Pet",Universe=10035204815,Place=124216119978534,File="ride-a-pet.lua",Commit="e39fb7f24bda4d132f439416c7c68ad7467ff351"},
    {Name="Break and Steal an Egg",Universe=10765288803,Place=114326934417838,File="break-and-steal-an-egg.lua",Commit="a7cf89d5f4aa4cf74d84e12af125cf82b788eae5",Version="break-language-sync-20261020-1"},
    {Name="Loot to Forge",Universe=10684750879,Place=118805555015549,File="loot-to-forge.lua",Commit="e39fb7f24bda4d132f439416c7c68ad7467ff351",Version="silver-native-1"},
    {Name="Build An Ant Empire",Universe=10436530264,Place=78490532994307,File="build-an-ant-empire.lua",Commit="e39fb7f24bda4d132f439416c7c68ad7467ff351"},
}
for _,entry in ipairs(games)do entry.Version=entry.File=="devil-steal-an-egg.lua"and"chilli-fishing-rotation-20261020-1"or entry.File=="mine-auto-test.lua"and"mine-auto-test-4"or entry.File=="tapping-auto-test.lua"and"tapping-auto-test-10"or entry.File=="climb-for-eggs.lua"and"climb-language-sync-20261020-12"or entry.File=="lift-rock-for-eggs.lua"and"lift-rock-fly-23"or entry.File=="aqua-auto-egg.lua"and"aqua-auto-egg-18"or entry.File=="break-and-steal-an-egg.lua"and"break-language-sync-20261020-1"or(entry.File=="ride-a-pet.lua"and"ride-native-obf-18"or"shared-loading-3")end
-- Anime Dice keeps its own release without changing legacy route versions.
for _,entry in ipairs(games)do if entry.File=="anime-dice-test.lua"then entry.Version="anime-dice-test-20261020-12"end end
if not game:IsLoaded()then game.Loaded:Wait()end
local selected
for _,entry in ipairs(games)do if game.GameId==entry.Universe then selected=entry break end end
if not selected then for _,entry in ipairs(games)do if game.PlaceId==entry.Place then selected=entry break end end end
assert(selected,"DEVIL HUB supports Mine / Dump23, Tap Simulator 2, Climb for Eggs, Lift Rock for Eggs, Ride A Fish, Steal an Egg, Ride a Pet, Break and Steal an Egg, Loot to Forge, Build An Ant Empire, and Anime Dice. This map is not supported yet. GameId="..tostring(game.GameId).." PlaceId="..tostring(game.PlaceId).."")
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
if selected.File=="ride-a-pet.lua"and(env.DevilRideLucyRunning or env.DevilRideLucyLoading or env.DevilRideLucyRequiresRejoin or env.DevilRideUnpacking or env.DevilRideDeltaLoading or(env.DevilRideLoading and env.DevilRideLoading.Busy))then return end
if selected.File=="break-and-steal-an-egg.lua"and(env.DevilBreakActive or env.DevilBreakUnpacking)then return end
if selected.File=="loot-to-forge.lua"and(env.DevilLootStarting or env.DevilLootRunning)then return end
if selected.File=="build-an-ant-empire.lua"and(env.DevilAntStarting or env.DevilAntRunning)then return end
if selected.File=="devil-steal-an-egg.lua"and(env.DevilChilliUiStarting or env.DevilChilliPresentation or env.DevilChilliMainUI)then return end
if selected.File=="anime-dice-test.lua"then
    local app=env.DevilAnimeDiceTest
    if app and not app.Stopped and app.Version==selected.Version then return app end
    if env.DevilAnimeDiceStarting and os.clock()-env.DevilAnimeDiceStarting.At<30 then return end
end
assert(type(loadstring)=="function","Executor loadstring support is required.")
env.DevilHubRouterLoading=true
local loading=(function()
-- Compact presentation only: finite tweens and one viewport resize listener.
return function(map)
    local scope=type(getgenv)=="function"and getgenv()or _G
    local shared=scope.DevilHubLoadController
    if shared and shared.Acquire and shared.IsActive()then return shared.Acquire()end
    if scope.DevilHubLoadScreen then pcall(scope.DevilHubLoadScreen.Destroy,scope.DevilHubLoadScreen)end
    local screen=Instance.new("ScreenGui")
    screen.Name="DevilHubLoading";screen.ResetOnSpawn=false;screen.IgnoreGuiInset=true;screen.DisplayOrder=10000
    screen:SetAttribute("DevilHubPresentation",true)
    local playerGui=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    local parent=playerGui
    pcall(function()parent=type(gethui)=="function"and gethui()or game:GetService("CoreGui")end)
    if not pcall(function()screen.Parent=parent end)then screen.Parent=playerGui end
    scope.DevilHubLoadScreen=screen
    local blue=Color3.fromRGB(0,140,255)
    local cyan=Color3.fromRGB(56,207,255)
    local card=Instance.new("Frame");card.Name="DevilLoadCard"
    card.AnchorPoint=Vector2.new(.5,.5);card.Position=UDim2.fromScale(.5,.5)
    card.Size=UDim2.fromOffset(320,112);card.BackgroundColor3=Color3.fromRGB(8,13,24)
    card.BorderSizePixel=0;card.ZIndex=3;card.Parent=screen
    local function round(node,radius)
        local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,radius);corner.Parent=node
    end
    round(card,14)
    local border=Instance.new("UIStroke");border.Color=blue;border.Thickness=1;border.Transparency=.25;border.Parent=card
    local glow=Instance.new("Frame");glow.Name="DevilLoadGlow";glow.Position=UDim2.fromOffset(-3,-3)
    glow.Size=UDim2.new(1,6,1,6);glow.BackgroundColor3=blue;glow.BackgroundTransparency=.92
    glow.BorderSizePixel=0;glow.ZIndex=1;glow.Parent=card;round(glow,17)
    local background=Instance.new("Frame");background.Name="DevilLoadSurface"
    background.Size=UDim2.fromScale(1,1);background.BackgroundColor3=Color3.fromRGB(255,255,255)
    background.BorderSizePixel=0;background.ZIndex=3;background.Parent=card;round(background,14)
    local gradient=Instance.new("UIGradient");gradient.Rotation=20
    gradient.Color=ColorSequence.new(Color3.fromRGB(8,13,24),Color3.fromRGB(12,28,48));gradient.Parent=background
    local scale=Instance.new("UIScale");scale.Name="DevilLoadScale";scale.Parent=card
    local camera=workspace.CurrentCamera
    local tweens,links={},{}
    local stopped=false
    local tweenService=game:GetService("TweenService")
    local function animate(node,key,properties,duration)
        if tweens[key]then pcall(tweens[key].Cancel,tweens[key]);tweens[key]=nil end
        local ok,value=pcall(function()
            return tweenService:Create(node,TweenInfo.new(duration,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),properties)
        end)
        if ok then tweens[key]=value;value:Play()
        else for name,value in pairs(properties)do node[name]=value end end
    end
    local function fit()
        local size=camera and camera.ViewportSize
        local factor=size and math.min(1,math.max(1,size.X-32)/326,math.max(1,size.Y-32)/118)or 1
        return math.max(.1,factor)
    end
    local target=fit();scale.Scale=target*.96
    animate(scale,"open",{Scale=target},.2)
    if camera then
        local ok,link=pcall(function()return camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            if stopped then return end
            if tweens.open then pcall(tweens.open.Cancel,tweens.open);tweens.open=nil end
            scale.Scale=fit()
        end)end)
        if ok then links[#links+1]=link end
    end
    local logo=Instance.new("ImageLabel");logo.Name="DevilLogo";logo.BackgroundTransparency=1
    logo.Size=UDim2.fromOffset(42,42);logo.Position=UDim2.fromOffset(16,16)
    logo.ScaleType=Enum.ScaleType.Fit;logo.ZIndex=4;logo.Parent=card
    logo.Image=scope.DevilHubSilverLogo or ""
    local function label(name,text,x,y,width,height,size,color)
        local node=Instance.new("TextLabel");node.Name=name;node.BackgroundTransparency=1
        node.Font=Enum.Font.GothamSemibold;node.TextColor3=color or Color3.fromRGB(230,244,255)
        node.TextSize=size;node.TextXAlignment=Enum.TextXAlignment.Left;node.TextTruncate=Enum.TextTruncate.AtEnd
        node.Position=UDim2.fromOffset(x,y);node.Size=UDim2.fromOffset(width,height)
        node.Text=text;node.ZIndex=4;node.Parent=card;return node
    end
    label("DevilLoadTitle","DEVIL HUB",70,15,158,23,18)
    label("DevilLoadMap",tostring(map),70,40,214,17,11,Color3.fromRGB(144,168,195))
    local badge=Instance.new("Frame");badge.Name="DevilLoadBadge"
    badge.Position=UDim2.fromOffset(242,18);badge.Size=UDim2.fromOffset(62,19)
    badge.BackgroundColor3=Color3.fromRGB(14,43,69);badge.BorderSizePixel=0;badge.ZIndex=4;badge.Parent=card;round(badge,6)
    local badgeText=label("DevilLoadBadgeText","LOADING",249,18,52,19,8,cyan)
    local status=label("DevilLoadStatus","Preparing...",16,72,247,16,11)
    local percentage=label("DevilLoadPercent","8%",270,72,34,16,10,cyan)
    percentage.TextXAlignment=Enum.TextXAlignment.Right
    local track=Instance.new("Frame");track.Position=UDim2.fromOffset(16,97);track.Size=UDim2.fromOffset(288,3)
    track.BackgroundColor3=Color3.fromRGB(25,41,63);track.BorderSizePixel=0;track.ZIndex=4;track.Parent=card;round(track,3)
    local fill=Instance.new("Frame");fill.Size=UDim2.fromScale(.08,1);fill.BackgroundColor3=blue
    fill.BorderSizePixel=0;fill.ZIndex=5;fill.Parent=track;round(fill,3)
    local shine=Instance.new("UIGradient");shine.Color=ColorSequence.new(blue,cyan);shine.Parent=fill
    local function cleanup()
        if stopped then return end;stopped=true
        for _,link in ipairs(links)do pcall(link.Disconnect,link)end
        for _,value in pairs(tweens)do pcall(value.Cancel,value)end
        table.clear(links);table.clear(tweens)
        if scope.DevilHubLoadScreen==screen then scope.DevilHubLoadScreen=nil end
        if scope.DevilHubLoadController==shared then scope.DevilHubLoadController=nil end
    end
    if screen.Destroying then links[#links+1]=screen.Destroying:Connect(cleanup)end
    local controller={}
    shared=controller
    local owners=1
    local finished=false
    local failed=false
    local shownProgress=0
    local function close()
        if stopped then return end
        cleanup();if screen.Parent then screen:Destroy()end
    end
    local function release()
        owners-=1
        if owners==0 and not failed then close()end
    end
    function controller.IsActive()return not stopped and not failed and screen.Parent~=nil end
    function controller.Update(text,progress)
        if stopped or not screen.Parent then return end
        if failed then return end
        local value=math.max(shownProgress,math.clamp(progress or .1,0,1))
        shownProgress=value
        status.Text=tostring(text);percentage.Text=string.format("%d%%",math.floor(value*100+.5))
        animate(fill,"progress",{Size=UDim2.fromScale(value,1)},.18)
    end
    function controller.SetLogo(image)if not stopped and screen.Parent then logo.Image=image end end
    function controller.Finish()
        if stopped or finished then return end
        finished=true;release()
    end
    controller.Destroy=controller.Finish
    function controller.Fail(message)
        if stopped or failed then return end
        local detail=tostring(message)
        warn("[DEVIL HUB / startup] "..detail)
        if type(writefile)=="function"then pcall(function()
            writefile("DevilHub_LoadError.json",game:GetService("HttpService"):JSONEncode({map=map,error=detail,release="shared-loading-3"}))
        end)end
        controller.Update("Start failed - check Console",1)
        failed=true;controller.LastError=detail
        badgeText.Text="FAILED";percentage.Text="ERR"
        shine.Enabled=false;fill.BackgroundColor3=Color3.fromRGB(255,85,85)
        task.delay(8,close)
    end
    function controller.Acquire()
        owners+=1
        local released=false
        local lease={Update=controller.Update,SetLogo=controller.SetLogo,Fail=controller.Fail,IsActive=controller.IsActive,Acquire=controller.Acquire}
        function lease.Finish()if not released then released=true;release()end end
        lease.Destroy=lease.Finish
        return lease
    end
    scope.DevilHubLoadController=controller
    return controller
end

end)()(selected.Name)
env.DevilHubLoadController=loading
local logoOK,logo=pcall(function()
    return (function()
local function logo()
    local version="silver-break-20261014"
    local url="https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/a28a74d3b5c98f687c165dcefaadfe0a743d280c/assets/devil-logo.png"
    local cached=env.DevilHubSilverLogo
    if env.DevilHubSilverLogoVersion==version and type(cached)=="string"and cached~=""and not cached:match("^https?://")then return cached end
    local file="DevilHub_Silver_20261014.png"
    local signature="\137PNG\r\n\26\n"
    local ok,value=pcall(function()
        assert(type(writefile)=="function","Logo file API unavailable")
        local exists=type(isfile)=="function"and isfile(file)
        if exists and type(readfile)=="function"then
            local readable,data=pcall(readfile,file)
            exists=readable and type(data)=="string"and data:sub(1,8)==signature
        end
        if not exists then
            local data=game:HttpGet(url)
            assert(type(data)=="string"and data:sub(1,8)==signature,"Invalid DEVIL HUB logo response")
            writefile(file,data)
        end
        for _,key in ipairs({"getcustomasset","getsynasset"})do
            local custom=getfenv()[key]
            if type(custom)=="function"then
                local resolved,image=pcall(custom,file)
                if resolved and type(image)=="string"and image~=""and not image:match("^https?://")then return image end
            end
        end
        error("Logo asset API unavailable")
    end)
    if ok then
        env.DevilHubSilverLogo=value;env.DevilHubSilverLogoVersion=version;env.DevilHubLogoError=nil
        return value
    end
    env.DevilHubLogoError=tostring(value)
    -- Do not cache an HTTP URL as a resolved Roblox asset: later calls can retry.
    return url
end
return logo

end)()()
end)
if logoOK then loading.SetLogo(logo)end
loading.Update("Downloading "..selected.Name.."...",.15)
task.wait()

local args=table.pack(...)
local outcome=table.pack(xpcall(function()
    if not game:IsLoaded()then game.Loaded:Wait()end
    print("[DEVIL HUB] Loading "..selected.Name.."...")
    local downloadGame=game
    if selected.File=="break-and-steal-an-egg.lua"then
        local compat=env.DevilBreakExecutorContext
        if not compat or compat.Version~="break-executor-compat-19"then
            local make=(function()
-- Executor capability adapter. All HTTP replacement is local to this environment.
return function(host,shared)
    host=host or getfenv(0);shared=shared or host
    local rawGame=assert(host.game or shared.game,"Roblox game is unavailable")
    local compile=host.loadstring or shared.loadstring
    local setEnvironment=host.setfenv or shared.setfenv
    assert(type(compile)=="function","Executor loadstring support is required")
    assert(type(setEnvironment)=="function","Executor setfenv support is required")
    local getEnvironment=host.getfenv or shared.getfenv or getfenv
    local api={Version="break-executor-compat-19",Report={mode="ScopedHTTP",capabilities={}}}
    local function find(names)
        for _,source in ipairs({host,shared})do
            for _,name in ipairs(names)do if type(source[name])=="function"then return source[name]end end
        end
    end
    local send=find({"request","http_request","httprequest"})
    if not send then
        for _,name in ipairs({"http","syn","fluxus"})do
            local namespace=host[name]or shared[name]
            if type(namespace)=="table"and type(namespace.request)=="function"then send=namespace.request;break end
        end
    end
    local function normalize(response)
        assert(type(response)=="table","Executor HTTP request returned no response table")
        local code=tonumber(response.StatusCode or response.Status or response.status_code or response.status)
        local success=response.Success
        if success==nil then success=response.success end
        if code then success=success~=false and code>=200 and code<300 elseif success==true then code=200 end
        return{StatusCode=code,Success=success==true,Body=response.Body or response.body or response.ResponseBody,
            Headers=response.Headers or response.headers}
    end
    if send then
        api.Request=function(options)return normalize(send(options))end
    end
    local copy=find({"setclipboard","toclipboard","set_clipboard"})
    api.Copy=copy
    api.ReadFile=find({"readfile","read_file"});api.WriteFile=find({"writefile","write_file"})
    api.IsFile=find({"isfile","is_file"});api.MakeFolder=find({"makefolder","make_folder"})
    api.CustomAsset=find({"getcustomasset","getsynasset"})
    api.Prompt=find({"fireproximityprompt","fire_proximity_prompt"})
    local nativeHui=find({"gethui","get_hidden_gui"})
    function api.GetHui()
        if nativeHui then local ok,parent=pcall(nativeHui);if ok and parent then return parent end end
        local player=rawGame:GetService("Players").LocalPlayer
        assert(player,"Local player is unavailable")
        return player:FindFirstChildOfClass("PlayerGui")or player:WaitForChild("PlayerGui")
    end
    local nativeClone=find({"cloneref"})
    local gameProxy
    function api.CloneRef(value)
        if value==gameProxy then return value end
        if nativeClone then return nativeClone(value)end
        return value
    end
    local identify=find({"identifyexecutor","getexecutorname"})
    if identify then
        local ok,name=pcall(identify)
        if ok then api.Report.name=tostring(name)end
    end
    local c=api.Report.capabilities
    c.request=send~=nil;c.clipboard=copy~=nil;c.files=api.ReadFile~=nil and api.WriteFile~=nil
    c.customAsset=api.CustomAsset~=nil;c.promptHelper=api.Prompt~=nil;c.nativeCloneRef=nativeClone~=nil
    local slots={}
    for _,method in ipairs({"HttpGet","HttpGetAsync"})do
        local slot={method=method}
        slot.base=function(_,url,...)
            local failure
            local native=rawGame[method]
            if type(native)=="function"then
                local ok,result=pcall(native,rawGame,url,...)
                if ok and type(result)=="string"then return result end
                failure=result
            end
            if api.Request then
                local ok,response=pcall(api.Request,{Url=url,Method="GET"})
                if ok and response.Success and type(response.Body)=="string"then return response.Body end
                failure=ok and("HTTP "..tostring(response.StatusCode))or response
            end
            error("HTTP download failed: "..tostring(failure or"No supported HTTP API"),0)
        end
        slot.handler=slot.base
        slot.dispatch=function(self,url,...)return slot.handler(self,url,...)end
        slots[method]=slot
    end
    local methods={}
    gameProxy=setmetatable({},{
        __index=function(_,key)
            if slots[key]then return slots[key].dispatch end
            local value=rawGame[key]
            if type(value)~="function"then return value end
            if not methods[key]then methods[key]=function(_,...)return value(rawGame,...)end end
            return methods[key]
        end,
        __newindex=function(_,key,value)rawGame[key]=value end,
    })
    api.Game=gameProxy
    -- The legacy GUI adapter hooks only its own Game.HttpGet functions.
    -- Implement those swaps with Lua dispatch slots instead of process-wide hooks.
    function api.HookFunction(target,replacement)
        assert(type(replacement)=="function","Replacement must be a function")
        for _,slot in pairs(slots)do
            if target==slot.dispatch then local old=slot.handler;slot.handler=replacement;return old end
        end
        error("Scoped adapter only supports its own HTTP functions",0)
    end
    local scope=setmetatable({
        game=gameProxy,Game=gameProxy,getgenv=function()return shared end,
        request=api.Request,http_request=api.Request,httprequest=api.Request,
        setclipboard=copy,toclipboard=copy,
        readfile=api.ReadFile,writefile=api.WriteFile,isfile=api.IsFile,makefolder=api.MakeFolder,
        getcustomasset=api.CustomAsset,getsynasset=api.CustomAsset,
        fireproximityprompt=api.Prompt,gethui=api.GetHui,cloneref=api.CloneRef,
        hookfunction=api.HookFunction,
        -- These are ordinary local Lua dispatch slots, not native hooks.
        -- Avoid adding a C-closure yield boundary around HTTP downloads.
        newcclosure=function(fn)return fn end,
        -- Table proxies need no userdata __namecall hook.
        hookmetamethod=false,getnamecallmethod=false,
    },{__index=host})
    scope.getfenv=function(subject)
        if subject==0 then return scope end
        if type(subject)=="function"then return getEnvironment(subject)end
        return getEnvironment((subject or 1)+1)
    end
    function api.Compile(source,label)
        local fn,problem=compile(source,label)
        if fn then setEnvironment(fn,scope)end
        return fn,problem
    end
    scope.loadstring=api.Compile
    api.Scope=scope
    return api
end

            end)()
            compat=make(getfenv(1),env);env.DevilBreakExecutorContext=compat
        end
        downloadGame=compat.Game
    end
    local source,lastError
    for attempt=1,3 do
        local downloaded,body=pcall(downloadGame.HttpGet,downloadGame,"https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/"..(selected.Commit or "main").."/"..selected.File.."?hub="..(selected.Version or "4-games-3"))
        if downloaded and type(body)=="string"and #body>0 and not body:match("^%s*<")then source=body break end
        lastError=downloaded and "Empty or invalid script response"or tostring(body)
        if attempt<3 then task.wait(attempt)end
    end
    assert(source,selected.Name.." download failed: "..tostring(lastError))
    assert(type(source)=="string"and #source>0,"Empty script download")
    loading.Update("Starting "..selected.Name.."...",.6)
    task.wait()
    local run,err=loadstring(source,"DEVIL HUB / "..selected.Name)
    assert(run,err)
    local sample=(function()
-- Bounded diagnostics: arithmetic only for 20 seconds, one report write at the end.
return function(map)
    local scope=type(getgenv)=="function"and getgenv()or _G
    if scope.DevilHubFrameSample then scope.DevilHubFrameSample.Stop()end
    local report={schema="devil-hub-frame-sample-1",map=map,placeId=game.PlaceId,universeId=game.GameId,
        release="silver-native-1",frames=0,elapsed=0,slowFrames=0,worstFrame=0}
    local link,stopped
    local controller={}
    function controller.Stop()
        if stopped then return end;stopped=true
        if link then link:Disconnect()end
        if report.frames>0 then report.averageFrameMs=report.elapsed/report.frames*1000 end
        if type(writefile)=="function"then pcall(function()
            writefile("DevilHub_Performance.json",game:GetService("HttpService"):JSONEncode(report))
        end)end
        if scope.DevilHubFrameSample==controller then scope.DevilHubFrameSample=nil end
    end
    local ok,value=pcall(function()return game:GetService("RunService").Heartbeat end)
    if not ok or not value then return controller end
    link=value:Connect(function(dt)
        report.frames+=1;report.elapsed+=dt
        report.worstFrame=math.max(report.worstFrame,dt)
        if dt>.05 then report.slowFrames+=1 end
        if report.elapsed>=20 then controller.Stop()end
    end)
    scope.DevilHubFrameSample=controller
    return controller
end

end)()(selected.Name)
    return run(table.unpack(args,1,args.n))
end,function(err)return debug.traceback(tostring(err),2)end))
local ok,result=outcome[1],outcome[2]
env.DevilHubRouterLoading=false
if ok then loading.Finish()else loading.Fail(tostring(result));loading.Finish()end
if not ok then warn("[DEVIL HUB] "..tostring(result))error(result,0)end
return table.unpack(outcome,2,outcome.n)
