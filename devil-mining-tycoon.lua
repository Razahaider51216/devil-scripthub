-- DEVIL HUB | Mining Tycoon | Standalone test build
-- Adapted from the supplied VANTA FARM script.
-- Counters record client requests, not server-confirmed rewards.

local RS    = game:GetService("ReplicatedStorage")
local TW    = game:GetService("TweenService")
local RUN   = game:GetService("RunService")
local UIS   = game:GetService("UserInputService")
local CG    = game:GetService("CoreGui")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
assert(player, "DEVIL HUB must run on the client")
local host = player:WaitForChild("PlayerGui", 10)
if type(gethui) == "function" then
    local ok, result = pcall(gethui)
    if ok and result then host = result end
end
assert(host, "DEVIL HUB: PlayerGui unavailable")
local shared = type(getgenv) == "function" and getgenv() or _G
if shared.DevilMiningSession then shared.DevilMiningSession.Destroy() end
local farmActive = true
local connections, threads = {}, {}
local controller = {}
shared.DevilMiningSession = controller
local function connect(signal, fn)
    local connection = signal:Connect(fn)
    table.insert(connections, connection)
    return connection
end
local function spawn(fn)
    table.insert(threads, task.spawn(fn))
end
local function stop()
    if not farmActive then return end
    farmActive = false
    for _, connection in ipairs(connections) do connection:Disconnect() end
    for _, thread in ipairs(threads) do pcall(task.cancel, thread) end
    if shared.DevilMiningSession == controller then shared.DevilMiningSession = nil end
end
local previous = host:FindFirstChild("DevilHubMiningTycoon")
if previous then previous:Destroy() end

local VP  = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600))
local SW, SH = VP.X, VP.Y
local GW  = math.min(360, math.max(180, SW - 16))
local GH  = math.min(580, math.max(140, SH - 32))
local TSM = math.clamp(SW * 0.030, 11, 13)
local TBT = math.clamp(SW * 0.036, 13, 15)

local C = {
    bg      = Color3.fromRGB(14, 10, 15),
    panel   = Color3.fromRGB(25, 15, 23),
    card    = Color3.fromRGB(35, 22, 31),
    accent  = Color3.fromRGB(247, 48, 75),
    accent2 = Color3.fromRGB(255, 115, 85),
    on      = Color3.fromRGB(70, 210, 110),
    onDark  = Color3.fromRGB(20, 60, 35),
    off     = Color3.fromRGB(55, 55, 75),
    offDark = Color3.fromRGB(16, 16, 26),
    text    = Color3.fromRGB(220, 220, 240),
    sub     = Color3.fromRGB(130, 130, 160),
    gold    = Color3.fromRGB(255, 190, 50),
    red     = Color3.fromRGB(220, 60, 60),
    white   = Color3.fromRGB(255, 255, 255),
}

-- Resolve each action on demand so absent remotes never block the GUI.
local remoteNames = {"SellItems", "CollectAll", "ClaimOre", "ClaimOil", "ClaimWorth",
    "ClaimGroupRewards", "ClaimUpgrade", "ClickSpeed"}
local Remotes = {}
for _, name in ipairs(remoteNames) do Remotes[name] = name end
local stats = {sold=0, collected=0, clicked=0, errors=0, sent=0}
local lastError = ""
local function fire(name, ...)
    if not farmActive then return false end
    local folder = RS:FindFirstChild("Remotes")
    local remote = folder and folder:FindFirstChild(name)
    if not remote or not remote:IsA("RemoteEvent") then
        stats.errors += 1
        lastError = "Missing RemoteEvent: " .. tostring(name)
        return false
    end
    local args = table.pack(...)
    local ok, err = pcall(function() remote:FireServer(table.unpack(args, 1, args.n)) end)
    if ok then stats.sent += 1 else stats.errors += 1; lastError = tostring(err) end
    return ok
end

local function new(cls, props, parent)
    local obj = Instance.new(cls)
    for k, v in pairs(props) do obj[k] = v end
    if parent then obj.Parent = parent end
    return obj
end
local function corner(r, p)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = p
    return c
end
local function stroke(t, c, p)
    local s = Instance.new("UIStroke")
    s.Thickness = t
    s.Color = c
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end
local function tween(obj, t, props)
    TW:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quad), props):Play()
end

local SGui = new("ScreenGui", {
    Name="DevilHubMiningTycoon", ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset=true, DisplayOrder=100, Parent=host
})

local Main = new("Frame", {
    Size=UDim2.new(0,GW,0,GH),
    Position=UDim2.new(0,(SW-GW)/2,0,16), ClipsDescendants=true,
    BackgroundColor3=C.bg, BorderSizePixel=0,
}, SGui)
corner(14, Main)
stroke(1, C.accent, Main)

local Shimmer = new("Frame", {
    Size=UDim2.new(0,60,0,2),
    Position=UDim2.new(0,GW*0.2,0,0),
    BackgroundColor3=C.accent,
    BorderSizePixel=0, ZIndex=10,
}, Main)
corner(2, Shimmer)

local TBar = new("Frame", {
    Size=UDim2.new(1,0,0,46),
    BackgroundColor3=C.panel,
    BorderSizePixel=0,
}, Main)
corner(14, TBar)

new("Frame", {
    Size=UDim2.new(1,0,0.5,0),
    Position=UDim2.new(0,0,0.5,0),
    BackgroundColor3=C.panel,
    BorderSizePixel=0, ZIndex=0,
}, TBar)

local TIcon = new("TextLabel", {
    Size=UDim2.new(0,30,1,0), Position=UDim2.new(0,10,0,0),
    BackgroundTransparency=1,
    Text="D", TextSize=18, Font=Enum.Font.GothamBold,
    TextColor3=C.gold,
}, TBar)

local TTitle = new("TextLabel", {
    Size=UDim2.new(1,-120,0,22), Position=UDim2.new(0,44,0,5),
    BackgroundTransparency=1,
    Text="DEVIL HUB", TextSize=TBT,
    Font=Enum.Font.GothamBold, TextColor3=C.text,
    TextXAlignment=Enum.TextXAlignment.Left,
}, TBar)

local TSub = new("TextLabel", {
    Size=UDim2.new(1,-100,0,14),
    Position=UDim2.new(0,44,0,24),
    BackgroundTransparency=1,
    Text="Mining Tycoon", TextSize=10,
    Font=Enum.Font.Gotham, TextColor3=C.accent,
    TextXAlignment=Enum.TextXAlignment.Left,
}, TBar)

local function mkBtn(txt, col, x)
    local b = new("TextButton", {
        Size=UDim2.new(0,30,0,30),
        Position=UDim2.new(1,-x,0.5,-15),
        BackgroundColor3=col,
        Text=txt, TextColor3=C.white,
        TextSize=13, Font=Enum.Font.GothamBold,
        BorderSizePixel=0,
    }, TBar)
    corner(8, b)
    return b
end
local CloseBtn = mkBtn("X", C.red, 36)
local MinBtn   = mkBtn("_", C.off, 70)

local Body = new("Frame", {
    Size=UDim2.new(1,0,1,-46),
    Position=UDim2.new(0,0,0,46),
    BackgroundTransparency=1,
}, Main)

local StatBar = new("Frame", {
    Size=UDim2.new(1,-16,0,30),
    Position=UDim2.new(0,8,0,6),
    BackgroundColor3=C.panel,
    BorderSizePixel=0,
}, Body)
corner(8, StatBar)

local StatTxt = new("TextLabel", {
    Size=UDim2.new(1,-10,1,0), Position=UDim2.new(0,10,0,0),
    BackgroundTransparency=1,
    Text="OFF | sent:0 | errors:0",
    TextSize=TSM-1, Font=Enum.Font.Code,
    TextColor3=C.gold, TextXAlignment=Enum.TextXAlignment.Left,
}, StatBar)

local Scroll = new("ScrollingFrame", {
    Size=UDim2.new(1,-8,1,-90),
    Position=UDim2.new(0,4,0,42),
    BackgroundTransparency=1,
    BorderSizePixel=0,
    ScrollBarThickness=3,
    ScrollBarImageColor3=C.accent,
    CanvasSize=UDim2.new(0,0,0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
}, Body)

local SList = new("UIListLayout", {
    SortOrder=Enum.SortOrder.LayoutOrder,
    Padding=UDim.new(0,6),
}, Scroll)
new("UIPadding", {
    PaddingLeft=UDim.new(0,4),
    PaddingRight=UDim.new(0,4),
    PaddingTop=UDim.new(0,4),
}, Scroll)

local function mkSection(icon, label, order)
    local f = new("Frame", {
        Size=UDim2.new(1,0,0,22),
        BackgroundTransparency=1,
        LayoutOrder=order,
    }, Scroll)
    new("TextLabel", {
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Text=icon.."  "..label,
        TextSize=TSM-1, Font=Enum.Font.GothamBold,
        TextColor3=C.sub, TextXAlignment=Enum.TextXAlignment.Left,
    }, f)
    return f
end

local toggles = {}

local function mkToggle(icon, label, desc, order, onFn, offFn, defaultOn)
    local state = defaultOn or false

    local card = new("Frame", {
        Size=UDim2.new(1,0,0,54),
        BackgroundColor3=state and C.onDark or C.card,
        BorderSizePixel=0, LayoutOrder=order,
    }, Scroll)
    corner(10, card)
    local cStroke = stroke(1, state and C.on or C.off, card)

    local iconBG = new("Frame", {
        Size=UDim2.new(0,38,0,38),
        Position=UDim2.new(0,8,0.5,-19),
        BackgroundColor3=state and C.on or C.off,
        BorderSizePixel=0,
    }, card)
    corner(10, iconBG)
    new("TextLabel", {
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Text=icon, TextSize=18,
        Font=Enum.Font.GothamBold,
        TextColor3=C.white,
    }, iconBG)

    new("TextLabel", {
        Size=UDim2.new(1,-110,0,18),
        Position=UDim2.new(0,54,0,9),
        BackgroundTransparency=1,
        Text=label, TextSize=TSM,
        Font=Enum.Font.GothamBold,
        TextColor3=C.text,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, card)
    new("TextLabel", {
        Size=UDim2.new(1,-110,0,14),
        Position=UDim2.new(0,54,0,28),
        BackgroundTransparency=1,
        Text=desc, TextSize=TSM-2,
        Font=Enum.Font.Gotham,
        TextColor3=C.sub,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, card)

    local pill = new("Frame", {
        Size=UDim2.new(0,52,0,26),
        Position=UDim2.new(1,-60,0.5,-13),
        BackgroundColor3=state and C.on or C.off,
        BorderSizePixel=0,
    }, card)
    corner(13, pill)
    local dot = new("Frame", {
        Size=UDim2.new(0,20,0,20),
        Position=UDim2.new(state and 1 or 0, state and -23 or 3, 0.5,-10),
        BackgroundColor3=C.white,
        BorderSizePixel=0,
    }, pill)
    corner(10, dot)
    local pillTxt = new("TextLabel", {
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Text=state and "ON" or "OFF",
        TextSize=9, Font=Enum.Font.GothamBold,
        TextColor3=C.white,
    }, pill)

    local btn = new("TextButton", {
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Text="", BorderSizePixel=0,
    }, card)

    local function setState(s)
        state = s
        tween(card, 0.2, {BackgroundColor3=s and C.onDark or C.card})
        tween(cStroke, 0.2, {Color=s and C.on or C.off})
        tween(iconBG, 0.2, {BackgroundColor3=s and C.on or C.off})
        tween(pill, 0.2, {BackgroundColor3=s and C.on or C.off})
        tween(dot, 0.2, {
            Position=UDim2.new(s and 1 or 0, s and -23 or 3, 0.5,-10)
        })
        pillTxt.Text = s and "ON" or "OFF"
        if not farmActive then return end
        if s and onFn then onFn() elseif not s and offFn then offFn() end
    end

    connect(btn.Activated, function()
        setState(not state)
    end)

    toggles[label] = { getState = function() return state end, setState = setState }
    return card, setState
end

local fState = {}



mkSection("$", "ECONOMY", 1)

mkToggle("$","Auto Sell","Sell request every 3 seconds",2,
    function() fState.sell=true end,
    function() fState.sell=false end)

mkToggle("#","Auto Collect","Collect request every 2 seconds",3,
    function() fState.collect=true end,
    function() fState.collect=false end)

mkSection("@", "MINE CLAIM", 10)

mkToggle("O","Auto Claim Ore","claim ore passive",11,
    function() fState.ore=true end,
    function() fState.ore=false end)

mkToggle("~","Auto Claim Oil","claim oil passive",12,
    function() fState.oil=true end,
    function() fState.oil=false end)

mkToggle("*","Auto Claim Worth","claim worth/prestige",13,
    function() fState.worth=true end,
    function() fState.worth=false end)

mkSection("+", "BONUS", 20)

mkToggle("G","Auto Group Reward","claim group bonus",21,
    function() fState.group=true end,
    function() fState.group=false end)

mkToggle("^","Auto Claim Upgrade","claim upgrade",22,
    function() fState.upg=true end,
    function() fState.upg=false end)

mkToggle("Z","Click Speed Boost","Speed request every 5 seconds",23,
    function() fState.click=true end,
    function() fState.click=false end)



spawn(function()
    while farmActive do
        if fState.sell    then if fire(Remotes.SellItems) then stats.sold+=1 end   end
        task.wait(3)
    end
end)

spawn(function()
    while farmActive do
        if fState.collect then if fire(Remotes.CollectAll) then stats.collected+=1 end end
        if fState.ore     then fire(Remotes.ClaimOre)                          end
        if fState.oil     then fire(Remotes.ClaimOil)                          end
        if fState.worth   then fire(Remotes.ClaimWorth)                        end
        if fState.group   then fire(Remotes.ClaimGroupRewards)                 end
        if fState.upg     then fire(Remotes.ClaimUpgrade)                      end
        task.wait(2)
    end
end)

spawn(function()
    while farmActive do
        if fState.click then
            if fire(Remotes.ClickSpeed, 999) then stats.clicked+=1 end
        end
        task.wait(5)
    end
end)

spawn(function()
    local t = 0
    while farmActive do
        task.wait(1)
        t += 1
        if t >= 1 then
            t = 0
            local active = 0
            for _, v in pairs(fState) do if v then active+=1 end end
            StatTxt.Text = string.format(
                "ON:%d | sent:%d | errors:%d",
                active, stats.sent, stats.errors
            )
        end
    end
end)

spawn(function()
    while farmActive do
        tween(Shimmer, 1.2, {
            Position=UDim2.new(0, GW*0.6, 0, 0),
            BackgroundColor3=C.accent2
        })
        task.wait(1.3)
        tween(Shimmer, 1.2, {
            Position=UDim2.new(0, GW*0.2, 0, 0),
            BackgroundColor3=C.accent
        })
        task.wait(1.3)
    end
end)

spawn(function()
    while farmActive do
        tween(TTitle, 1.5, {TextColor3=C.accent})
        task.wait(1.6)
        tween(TTitle, 1.5, {TextColor3=C.text})
        task.wait(1.6)
    end
end)

local minimized = false
local drag,ds,dp = false,nil,nil
TBar.Active = true
connect(TBar.InputBegan, function(i)
    if i.UserInputType==Enum.UserInputType.Touch
    or i.UserInputType==Enum.UserInputType.MouseButton1 then
        drag=true; ds=i.Position; dp=Main.AbsolutePosition
    end
end)
connect(UIS.InputChanged, function(i)
    if drag and (i.UserInputType==Enum.UserInputType.Touch
    or i.UserInputType==Enum.UserInputType.MouseMovement) then
        local d=i.Position-ds
        Main.Position=UDim2.new(0,math.clamp(dp.X+d.X,0,math.max(0,SW-GW)),0,math.clamp(dp.Y+d.Y,0,math.max(0,SH-(minimized and 46 or GH))))
    end
end)
connect(UIS.InputEnded, function(i)
    if i.UserInputType==Enum.UserInputType.Touch
    or i.UserInputType==Enum.UserInputType.MouseButton1 then
        drag=false
    end
end)

connect(MinBtn.Activated, function()
    minimized = not minimized
    Body.Visible = not minimized
    tween(Main, 0.25, {
        Size = minimized
            and UDim2.new(0,GW,0,46)
            or  UDim2.new(0,GW,0,GH)
    })
    MinBtn.Text = minimized and "+" or "_"
end)

function controller.Destroy()
    stop()
    if SGui.Parent then SGui:Destroy() end
end
connect(CloseBtn.Activated, controller.Destroy)
connect(SGui.Destroying, stop)
local function resize()
    local camera = workspace.CurrentCamera
    if not camera then return end
    SW, SH = camera.ViewportSize.X, camera.ViewportSize.Y
    GW, GH = math.min(360, math.max(180, SW-16)), math.min(580, math.max(140, SH-32))
    Main.Size = UDim2.fromOffset(GW, minimized and 46 or GH)
    Main.Position = UDim2.fromOffset(
        math.clamp(Main.Position.X.Offset, 0, math.max(0,SW-GW)),
        math.clamp(Main.Position.Y.Offset, 0, math.max(0,SH-(minimized and 46 or GH))))
end
local cameraConnection
local function bindCamera()
    if cameraConnection then cameraConnection:Disconnect() end
    if workspace.CurrentCamera then
        cameraConnection = connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), resize)
    end
    resize()
end
connect(workspace:GetPropertyChangedSignal("CurrentCamera"), bindCamera)
bindCamera()
controller.Gui = SGui
controller.Toggles = toggles
controller.Stats = stats
function controller.GetLastError() return lastError end
warn("[DEVIL HUB] Mining Tycoon GUI ready; all features start OFF")
return controller
