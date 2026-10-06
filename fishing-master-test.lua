-- Fishing Master TEST / public revision 2026-09-30 / original GUI
local Loading=(function()
-- Release loading overlay shared by the small loader and protected entry point.
local Loading = {}
function Loading.Begin()
    local env = type(getgenv)=="function" and getgenv() or _G
    local current = env.DevilFishingTestLoading
    if current and current.Gui and current.Gui.Parent and not current.Failed then return current end
    if current and current.Destroy then current:Destroy() end
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local screen = Instance.new("ScreenGui")
    screen.Name = "DevilFishingTestLoading"
    screen.ResetOnSpawn = false
    screen.DisplayOrder = 10001
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    local function make(class,parent,properties)
        local object = Instance.new(class)
        for key,value in pairs(properties) do object[key] = value end
        object.Parent = parent
        return object
    end
    local function corner(parent,radius) make("UICorner",parent,{CornerRadius = UDim.new(0,radius)}) end
    local shade = make("Frame",screen,{Size = UDim2.fromScale(1,1),BackgroundColor3 = Color3.fromRGB(0,0,0),BackgroundTransparency = .35,BorderSizePixel = 0,Active = true})
    local panel = make("Frame",shade,{AnchorPoint = Vector2.new(.5,.5),Position = UDim2.fromScale(.5,.5),Size = UDim2.new(.86,0,0,270),BackgroundColor3 = Color3.fromRGB(20,13,20),BorderSizePixel = 0})
    make("UISizeConstraint",panel,{MaxSize = Vector2.new(420,270)})
    corner(panel,16)
    -- Keep this overlay independent of the native library stroke scaler.
    local logo = make("ImageLabel",panel,{AnchorPoint = Vector2.new(.5,0),Position = UDim2.new(.5,0,0,17),Size = UDim2.fromOffset(76,64),BackgroundTransparency = 1,Image = "",ScaleType = Enum.ScaleType.Fit})
    corner(logo,9)
    local title = make("TextLabel",panel,{Position = UDim2.fromOffset(20,92),Size = UDim2.new(1,-40,0,30),BackgroundTransparency = 1,Text = "FISHING MASTER / TEST",Font = Enum.Font.GothamBold,TextSize = 24,TextColor3 = Color3.fromRGB(247,48,75)})
    local status = make("TextLabel",panel,{Position = UDim2.fromOffset(20,131),Size = UDim2.new(1,-40,0,37),BackgroundTransparency = 1,Text = "Preparing your session...",Font = Enum.Font.Gotham,TextSize = 12,TextColor3 = Color3.fromRGB(187,161,179),TextWrapped = true})
    local track = make("Frame",panel,{Position = UDim2.fromOffset(28,181),Size = UDim2.new(1,-56,0,5),BackgroundColor3 = Color3.fromRGB(52,29,44),BorderSizePixel = 0})
    corner(track,3)
    local fill = make("Frame",track,{Size = UDim2.fromScale(.04,1),BackgroundColor3 = Color3.fromRGB(247,48,75),BorderSizePixel = 0})
    corner(fill,3)
    local detail = make("TextLabel",panel,{Position = UDim2.fromOffset(20,203),Size = UDim2.new(1,-40,0,20),BackgroundTransparency = 1,Text = "FISHING MASTER / TEST / STARTING",Font = Enum.Font.Gotham,TextSize = 9,TextColor3 = Color3.fromRGB(120,98,113)})
    local actions = make("Frame",panel,{Position = UDim2.new(0,24,1,-42),Size = UDim2.new(1,-48,0,28),BackgroundTransparency = 1,Visible = false})
    local function action(text,x)
        local button = make("TextButton",actions,{Position = UDim2.new(x,0,0,0),Size = UDim2.new(.48,0,1,0),Text = text,Font = Enum.Font.GothamMedium,TextSize = 11,TextColor3 = Color3.new(1,1,1),BackgroundColor3 = Color3.fromRGB(65,29,44),BorderSizePixel = 0,AutoButtonColor = false})
        corner(button,6)
        return button
    end
    local retry,close = action("Retry",0),action("Close",.52)
    local controller = {Gui = screen,HoldHub = true,Busy = false,PayloadRunning = false,Failed = false,Progress = 0,Connections = {}}
    env.DevilFishingTestLoading = controller
    local animation
    function controller:SetStage(message,progress)
        if not screen.Parent then return end
        self.Progress = math.max(self.Progress,math.clamp(progress or self.Progress,0,1))
        status.Text = message
        detail.Text = string.format("FISHING MASTER / TEST / %d%%",math.floor(self.Progress*100))
        if animation then animation:Cancel() end
        animation = TweenService:Create(fill,TweenInfo.new(.18),{Size = UDim2.fromScale(self.Progress,1)})
        animation:Play()
    end
    function controller:Destroy()
        self.HoldHub = false self.Busy = false
        if animation then animation:Cancel() end
        for _,connection in ipairs(self.Connections) do connection:Disconnect() end
        if env.DevilFishingTestLoading == self then env.DevilFishingTestLoading = nil end
        if screen.Parent then screen:Destroy() end
    end
    function controller:Finish(success,message)
        self.Busy = false self.HoldHub = false self.PayloadRunning = false
        if success then
            self:SetStage("Ready. Welcome to Devil Hub.",1)
            self:Destroy()
        else
            self.Failed = true
            status.Text = message or "Unable to start. Please retry."
            detail.Text = "LOAD FAILED / CHECK CONSOLE"
            actions.Visible = true
        end
    end
    table.insert(controller.Connections,close.Activated:Connect(function() controller:Destroy() end))
    table.insert(controller.Connections,retry.Activated:Connect(function()
        if controller.Busy or not screen.Parent then return end
        controller.Busy=true controller.Failed=false actions.Visible=false
        controller:SetStage("Downloading Fishing Master test...",.08)
        task.spawn(function()
            local ok,err = pcall(function()
                local run,parseError = loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/fishing-master-test.lua?v=1"),"Devil Hub / Retry")
                assert(run,parseError)
                if not screen.Parent then return end
                controller:Destroy()
                run()
            end)
            if not ok then
                if screen.Parent then controller:Finish(false,"Retry failed. Check your connection.") end
                warn("[Devil Hub] Retry failed: "..tostring(err))
            end
        end)
    end))
    task.spawn(function()
        local custom = getcustomasset or getsynasset
        if type(custom) ~= "function" or type(writefile) ~= "function" then return end
        local ok,asset = pcall(function()
            local path = "devil-hub-logo-daceb9cac221.png"
            if type(isfile) ~= "function" or not isfile(path) then
                local data = game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png")
                assert(data:sub(1,8) == "\137PNG\13\10\26\10") writefile(path,data)
            end
            return custom(path)
        end)
        if ok and screen.Parent then logo.Image = asset end
    end)
    return controller
end
return Loading

end)()
return (function(...)
-- Runs the historical Fishing Master runtime with its original GUI and callbacks.
local env=type(getgenv)=="function"and getgenv()or _G
if env.DevilFishingTestStarting or env.DevilFishingTestRunning then return end
local args=table.pack(...)
local loading=Loading.Begin()
loading.Busy=true env.DevilFishingTestStarting=true
local originalGui="https://raw.githubusercontent.com/joustingmatch/OuroFlow/main/Source.luau"
local pinnedGui="https://raw.githubusercontent.com/joustingmatch/OuroFlow/836b20c6a25cca72dd8530f54462d978251b3024/Source.luau"
local runtimeUrl="https://raw.githubusercontent.com/joustingmatch/Ouroboros/3dcb41a2b95847bc0b526489c19a391df16fd36f/games/buttsex.luau"
local compiler=loadstring
local hooks={}
local library,createWindow,window,ownedRuntime
local oldAttach=env.DevilFishingTestAttach
local worker,cancelled
local function cleanup()
    cancelled=true
    if worker and type(task.cancel)=="function"then pcall(task.cancel,worker)end
    for i=#hooks,1,-1 do pcall(hookfunction,hooks[i][1],hooks[i][2])end
    hooks={}
    if library and createWindow then library.CreateWindow=createWindow end
    if env.DevilFishingTestAttach~=oldAttach then env.DevilFishingTestAttach=oldAttach end
end
local function dispose()
    cleanup()
    if type(ownedRuntime)=="table"and type(ownedRuntime.Unload)=="function"then pcall(ownedRuntime.Unload,ownedRuntime)end
    if window and type(window.Destroy)=="function"then pcall(window.Destroy,window)end
    env.DevilFishingTestStarting=false env.DevilFishingTestRunning=false
end
local function fetch(url)
    local done,ok,body=false,false,nil
    task.spawn(function()ok,body=pcall(game.HttpGet,game,url)done=true end)
    local deadline=os.clock()+30
    while not done and os.clock()<deadline do task.wait(.1)end
    assert(done,"Download timed out after 30 seconds")assert(ok,body)
    assert(type(body)=="string"and #body>0,"Empty download")
    return body
end
local ok,result=xpcall(function()
    assert(game.PlaceId==99925503388128 or game.GameId==10039889230,"Open Fishing Master first")
    assert(type(compiler)=="function"and type(hookfunction)=="function","This test requires loadstring and hookfunction")
    local prior=env.OuroborosFishingMaster
    assert(not prior or prior.Unloaded==true,"Fishing Master is already running; rejoin before testing")
    loading:SetStage("Downloading the original Fishing Master GUI...",.12)
    local gui=fetch(pinnedGui)
    assert(#gui==382255,"Unexpected GUI revision")
    loading:SetStage("Downloading Fishing Master game controls...",.38)
    local source=fetch(runtimeUrl)
    assert(#source==208259,"Unexpected game runtime revision")
    local guiSource="local ui=(function()\n"..gui.."\nend)()\nreturn ((getgenv and getgenv())or _G).DevilFishingTestAttach(ui)"
    env.DevilFishingTestAttach=function(ui)
        assert(not cancelled,"Test startup was cancelled")
        assert(type(ui)=="table"and type(ui.CreateWindow)=="function","Original GUI did not return a library")
        library=ui createWindow=ui.CreateWindow
        ui.CreateWindow=function(self,info,...)
            assert(not cancelled,"Test startup was cancelled")
            local values=table.pack(createWindow(self,info,...))
            window=values[1]
            loading:SetStage("Connecting native game controls...",.88)
            return table.unpack(values,1,values.n)
        end
        return ui
    end
    for _,name in ipairs({"HttpGet","HttpGetAsync"})do
        local target=game[name]
        if type(target)=="function"then
            local old
            local intercept=function(self,url,...)
                if not cancelled and(url==originalGui or url==pinnedGui)then return guiSource end
                return old(self,url,...)
            end
            old=hookfunction(target,intercept)
            assert(type(old)=="function","HTTP hook did not return the original method")
            hooks[#hooks+1]={target,old}
        end
    end
    loading:SetStage("Starting the original GUI and game modules...",.65)
    local run,parseError=compiler(source,"Fishing Master / TEST public revision")assert(run,parseError)
    local done,started,value=false,false,nil
    worker=task.spawn(function()
        started,value=xpcall(function()return run(table.unpack(args,1,args.n))end,debug.traceback)
        done=true
    end)
    local deadline=os.clock()+90
    while not done and os.clock()<deadline do task.wait(.1)end
    ownedRuntime=env.OuroborosFishingMaster
    assert(done,"Startup timed out after 90 seconds; check the game modules in the console")
    assert(started,value)
    assert(window and window.Gui and window.Gui.Parent,"Original runtime did not create a visible GUI")
    cleanup()
    env.DevilFishingTestCleanup=dispose
    env.DevilFishingTestRunning=window
    if type(window.Destroy)=="function"then
        local destroy=window.Destroy
        window.Destroy=function(self,...)
            env.DevilFishingTestRunning=false
            return destroy(self,...)
        end
    end
    return value
end,function(err)return debug.traceback(tostring(err),2)end)
env.DevilFishingTestStarting=false
if ok then
    loading:Finish(true)
    if type(firesignal)~="function"then warn("[FISHING MASTER TEST] firesignal unavailable; native automation is disabled")end
    return result
end
dispose()
loading:Finish(false,"Test could not start. Check console for the exact error.")
warn("[FISHING MASTER TEST] "..tostring(result))

end)(...)
