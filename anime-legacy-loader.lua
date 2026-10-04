-- DEVIL HUB / LOADING SCREEN
local Loading=(function()
-- Release loading overlay shared by the small loader and protected entry point.
local Loading = {}
function Loading.Begin()
    local env = getgenv()
    local current = env.DevilHubLoading
    if current and current.Gui and current.Gui.Parent and not current.Failed then return current end
    if current and current.Destroy then current:Destroy() end
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local screen = Instance.new("ScreenGui")
    screen.Name = "DevilHubLoading"
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
    local shade = make("Frame",screen,{Size = UDim2.fromScale(1,1),BackgroundColor3 = Color3.fromRGB(0,0,0),BackgroundTransparency = .35,BorderSizePixel = 0})
    local panel = make("Frame",shade,{AnchorPoint = Vector2.new(.5,.5),Position = UDim2.fromScale(.5,.5),Size = UDim2.new(.86,0,0,270),BackgroundColor3 = Color3.fromRGB(20,13,20),BorderSizePixel = 0})
    make("UISizeConstraint",panel,{MaxSize = Vector2.new(420,270)})
    corner(panel,16)
    make("UIStroke",panel,{Color = Color3.fromRGB(116,39,59),Thickness = 1})
    local logo = make("ImageLabel",panel,{AnchorPoint = Vector2.new(.5,0),Position = UDim2.new(.5,0,0,17),Size = UDim2.fromOffset(76,64),BackgroundTransparency = 1,Image = "",ScaleType = Enum.ScaleType.Fit})
    corner(logo,9)
    local title = make("TextLabel",panel,{Position = UDim2.fromOffset(20,92),Size = UDim2.new(1,-40,0,30),BackgroundTransparency = 1,Text = "DEVIL HUB",Font = Enum.Font.GothamBold,TextSize = 24,TextColor3 = Color3.fromRGB(247,48,75)})
    local status = make("TextLabel",panel,{Position = UDim2.fromOffset(20,131),Size = UDim2.new(1,-40,0,37),BackgroundTransparency = 1,Text = "Preparing your session...",Font = Enum.Font.Gotham,TextSize = 12,TextColor3 = Color3.fromRGB(187,161,179),TextWrapped = true})
    local track = make("Frame",panel,{Position = UDim2.fromOffset(28,181),Size = UDim2.new(1,-56,0,5),BackgroundColor3 = Color3.fromRGB(52,29,44),BorderSizePixel = 0})
    corner(track,3)
    local fill = make("Frame",track,{Size = UDim2.fromScale(.04,1),BackgroundColor3 = Color3.fromRGB(247,48,75),BorderSizePixel = 0})
    corner(fill,3)
    local detail = make("TextLabel",panel,{Position = UDim2.fromOffset(20,203),Size = UDim2.new(1,-40,0,20),BackgroundTransparency = 1,Text = "ANIME LEGACY / STARTING",Font = Enum.Font.Gotham,TextSize = 9,TextColor3 = Color3.fromRGB(120,98,113)})
    local actions = make("Frame",panel,{Position = UDim2.new(0,24,1,-42),Size = UDim2.new(1,-48,0,28),BackgroundTransparency = 1,Visible = false})
    local function action(text,x)
        local button = make("TextButton",actions,{Position = UDim2.new(x,0,0,0),Size = UDim2.new(.48,0,1,0),Text = text,Font = Enum.Font.GothamMedium,TextSize = 11,TextColor3 = Color3.new(1,1,1),BackgroundColor3 = Color3.fromRGB(65,29,44),BorderSizePixel = 0,AutoButtonColor = false})
        corner(button,6)
        return button
    end
    local retry,close = action("Retry",0),action("Close",.52)
    local controller = {Gui = screen,HoldHub = true,Busy = false,PayloadRunning = false,Failed = false,Progress = 0,Connections = {}}
    env.DevilHubLoading = controller
    local animation
    function controller:SetStage(message,progress)
        if not screen.Parent then return end
        self.Progress = math.max(self.Progress,math.clamp(progress or self.Progress,0,1))
        status.Text = message
        detail.Text = string.format("ANIME LEGACY / %d%%",math.floor(self.Progress*100))
        if animation then animation:Cancel() end
        animation = TweenService:Create(fill,TweenInfo.new(.18),{Size = UDim2.fromScale(self.Progress,1)})
        animation:Play()
    end
    function controller:Destroy()
        self.HoldHub = false self.Busy = false
        if animation then animation:Cancel() end
        for _,connection in ipairs(self.Connections) do connection:Disconnect() end
        if env.DevilHubLoading == self then env.DevilHubLoading = nil end
        if screen.Parent then screen:Destroy() end
    end
    function controller:Finish(success,message)
        self.Busy = false self.HoldHub = false self.PayloadRunning = false
        if success then
            self:SetStage("Ready. Welcome to Devil Hub.",1)
            local runtime = env.DevilHubLegacy
            if runtime and runtime.Window and runtime.Window.Gui.Parent then runtime.Window.Gui.Enabled = true end
            self:Destroy()
        else
            self.Failed = true
            status.Text = message or "Unable to start. Please retry."
            detail.Text = "LOAD FAILED / CHECK CONSOLE"
            actions.Visible = true
            local runtime = env.DevilHubLegacy
            if runtime and runtime.Stop then pcall(runtime.Stop) end
        end
    end
    table.insert(controller.Connections,close.Activated:Connect(function() controller:Destroy() end))
    table.insert(controller.Connections,retry.Activated:Connect(function()
        controller:Destroy()
        task.spawn(function()
            local ok,err = pcall(function()
                local run,parseError = loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader"),"Devil Hub / Retry")
                assert(run,parseError) run()
            end)
            if not ok then warn("[Devil Hub] Retry failed: "..tostring(err)) end
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

local env=getgenv()
if env.DevilHubLoading and env.DevilHubLoading.Busy then return end
local loading=Loading.Begin()
loading.Busy=true
loading:SetStage("Downloading Devil Hub...",.08)
local success,result=xpcall(function()
    local source=game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil.lua")
    assert(type(source)=="string" and #source>0,"Empty script response")
    loading:SetStage("Preparing your session...",.18)
    local run,err=loadstring(source,"Devil Hub")
    assert(run,err)
    return run()
end,debug.traceback)
if not success then
    loading:Finish(false,"Download failed. Check your connection and retry.")
    warn("[Devil Hub] "..tostring(result))
end
return result
