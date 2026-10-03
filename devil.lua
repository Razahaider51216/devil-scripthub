-- DEVIL MOVEMENT V6 // Standalone LocalScript, StarterPlayerScripts.
-- WASD / thumbstick: move. Space / E: up. Q / Ctrl: down.
-- F: flight on/off. RightShift: UI on/off. No external libraries required.
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
if not player then warn("[DEVIL] Run as a LocalScript.") return end
local playerGui = player:WaitForChild("PlayerGui")
for _, name in ipairs({"DEVIL_SPEED_V5", "DEVIL_MOVEMENT_V6"}) do
    local old = playerGui:FindFirstChild(name)
    if old then old:Destroy() end
end
local config = {SpeedEnabled = true, FlyEnabled = false, MaxSpeed = 5000, MaxFlySpeed = 1000}
local colors = {
    background = Color3.fromRGB(8,11,18), panel = Color3.fromRGB(15,21,31),
    raised = Color3.fromRGB(23,32,45), accent = Color3.fromRGB(79,255,176),
    text = Color3.fromRGB(234,244,250), muted = Color3.fromRGB(131,150,171),
    line = Color3.fromRGB(41,57,72), purple = Color3.fromRGB(167,139,250),
}
local connections, alive = {}, true
local humanoid, root, character, speedConnection, deathConnection
local speed, flySpeed, normalSpeed, flyMode = 100,80,16,"Camera"
local flight, touchVertical = nil,{}
local refresh = function() end
local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(connections, connection)
    return connection
end
local function create(class, props, parent)
    local object = Instance.new(class)
    for key,value in pairs(props or {}) do object[key] = value end
    object.Parent = parent
    return object
end
local function corner(parent, radius)
    create("UICorner",{CornerRadius = UDim.new(0,radius or 12)},parent)
end
local function stroke(parent, color, transparency)
    create("UIStroke",{Color = color or colors.line, Thickness = 1, Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border},parent)
end
local function label(parent,text,x,y,w,h,size,color)
    return create("TextLabel",{BackgroundTransparency = 1,Position = UDim2.fromOffset(x,y),
        Size = UDim2.fromOffset(w,h),Text = text,TextSize = size or 14,Font = Enum.Font.Gotham,
        TextColor3 = color or colors.text,TextXAlignment = Enum.TextXAlignment.Left},parent)
end
local function button(parent,text,x,y,w,h,radius,border)
    local object = create("TextButton",{Position = UDim2.fromOffset(x,y),Size = UDim2.fromOffset(w,h),
        Text = text,Font = Enum.Font.GothamMedium,TextSize = 12,TextColor3 = colors.text,
        BackgroundColor3 = colors.raised,AutoButtonColor = false,BorderSizePixel = 0},parent)
    corner(object,radius or 10)
    stroke(object,border)
    local function hover(transparency)
        TweenService:Create(object,TweenInfo.new(.15),{BackgroundTransparency = transparency}):Play()
    end
    connect(object.MouseEnter,function() hover(.18) end)
    connect(object.MouseLeave,function() hover(0) end)
    return object
end
-- Native vector strokes, matching devil-icons.svg; ready without image uploads.
local icons = {
    speed = {{{13,2},{5,14},{11,14},{10,22},{20,9},{14,9},{13,2}}},
    fly = {{{2,11},{22,2},{13,22},{10,14},{2,11}},{{10,14},{22,2}}},
    devil = {{{5,9},{3,3},{9,6}},{{19,9},{21,3},{15,6}},
        {{5,9},{5,16},{12,22},{19,16},{19,9},{12,6},{5,9}},
        {{8,12},{10,13}},{{16,12},{14,13}},{{9,17},{15,17}}},
    close = {{{6,6},{18,18}},{{18,6},{6,18}}},
    up = {{{5,15},{12,8},{19,15}}},down = {{{5,9},{12,16},{19,9}}},
}
local function icon(parent,kind,x,y,size,color)
    local holder = create("Frame",{Name = kind.."Icon",BackgroundTransparency = 1,
        Position = UDim2.fromOffset(x,y),Size = UDim2.fromOffset(size,size)},parent)
    for _,path in ipairs(icons[kind]) do
        for i = 1,#path-1 do
            local a,b = path[i],path[i+1]
            local delta = Vector2.new(b[1]-a[1],b[2]-a[2])
            local segment = create("Frame",{AnchorPoint = Vector2.new(.5,.5),BorderSizePixel = 0,
                BackgroundColor3 = color or colors.accent,
                Position = UDim2.fromScale((a[1]+b[1])/48,(a[2]+b[2])/48),
                Size = UDim2.fromOffset(delta.Magnitude*size/24,math.max(1.5,size/14)),
                Rotation = math.deg(math.atan2(delta.Y,delta.X))},holder)
            corner(segment,3)
        end
    end
end
local gui = create("ScreenGui",{Name = "DEVIL_MOVEMENT_V6",ResetOnSpawn = false,
    IgnoreGuiInset = false,DisplayOrder = 999,ZIndexBehavior = Enum.ZIndexBehavior.Sibling},playerGui)
local bounds = create("Frame",{Size = UDim2.fromScale(1,1),BackgroundTransparency = 1},gui)
local main = create("Frame",{Name = "Movement",AnchorPoint = Vector2.new(.5,.5),
    Position = UDim2.fromScale(.5,.5),Size = UDim2.fromOffset(540,450),BackgroundColor3 = colors.background,
    BorderSizePixel = 0,ClipsDescendants = true},bounds)
corner(main,20)
stroke(main,colors.accent,.55)
create("UIGradient",{Color = ColorSequence.new(colors.panel,colors.background),Rotation = 65},main)
local scale = create("UIScale",{Scale = 1},main)
local header = create("Frame",{Size = UDim2.new(1,-66,0,72),BackgroundTransparency = 1,Active = true},main)
icon(header,"devil",20,18,34)
label(header,"DEVIL",68,15,175,27,22).Font = Enum.Font.GothamBold
local headerStatus = label(header,"MOVEMENT / CONTROL CENTER",69,43,290,15,9,colors.muted)
local close = button(main,"",488,20,32,32)
icon(close,"close",7,7,18,colors.muted)
local rail = create("Frame",{Position = UDim2.fromOffset(394,82),Size = UDim2.fromOffset(130,350),
    BackgroundColor3 = colors.panel,BorderSizePixel = 0},main)
corner(rail,14)
stroke(rail)
label(rail,"MODULES",14,14,102,18,10,colors.muted)
local tabs,pages,controls = {},{},{}
local selected = "Speed"
for i,name in ipairs({"Speed","Fly"}) do
    local tab = button(rail,"",10,44+(i-1)*64,110,56)
    icon(tab,string.lower(name),10,16,23,name == "Fly" and colors.purple or colors.accent)
    label(tab,name,43,10,64,20,13).Font = Enum.Font.GothamBold
    label(tab,i == 1 and "GROUND" or "AIRBORNE",43,31,64,12,8,colors.muted)
    tabs[name] = tab
    local page = create("Frame",{Name = name.."Page",Position = UDim2.fromOffset(20,84),
        Size = UDim2.fromOffset(354,350),BackgroundTransparency = 1,Visible = i == 1},main)
    pages[name] = page
    label(page,name == "Speed" and "Speed control" or "Flight control",0,0,330,30,23).Font = Enum.Font.GothamBold
    label(page,name == "Speed" and "Tune your ground movement." or "Choose how you move through the air.",0,34,354,20,12,colors.muted)
    local panel = create("Frame",{Position = UDim2.fromOffset(0,70),Size = UDim2.fromOffset(354,100),
        BackgroundColor3 = colors.panel,BorderSizePixel = 0},page)
    corner(panel,14)
    stroke(panel)
    label(panel,"VELOCITY / STUDS PER SECOND",14,12,320,17,9,colors.muted)
    local input = create("TextBox",{Position = UDim2.fromOffset(14,38),Size = UDim2.fromOffset(194,48),
        BackgroundColor3 = colors.background,BorderSizePixel = 0,ClearTextOnFocus = false,
        Font = Enum.Font.GothamBold,TextSize = 24,TextColor3 = name == "Fly" and colors.purple or colors.accent,
        Text = tostring(name == "Speed" and speed or flySpeed),PlaceholderText = "Enter speed"},panel)
    corner(input,10)
    controls[name] = {input = input,toggle = button(panel,"",220,38,120,48),presets = {}}
    connect(input.FocusLost,function()
        local number = tonumber(input.Text)
        if number and number == number and math.abs(number) < math.huge then
            if name == "Speed" then speed = math.clamp(math.floor(number),1,config.MaxSpeed)
            else flySpeed = math.clamp(math.floor(number),1,config.MaxFlySpeed) end
            if humanoid and config.SpeedEnabled then humanoid.WalkSpeed = speed end
        end
        refresh()
    end)
end
label(rail,"V6 / LOCAL",14,309,105,17,9,colors.muted)
local railStatus = label(rail,"READY",14,326,105,15,9,colors.accent)
label(pages.Speed,"QUICK PRESETS",0,188,354,18,10,colors.muted)
for i,preset in ipairs({{"NORMAL",16},{"FAST",100},{"TURBO",300},{"EXTREME",500},{"INSANE",1000},{"MAX",2000}}) do
    local b = button(pages.Speed,preset[1].."\n"..preset[2],((i-1)%3)*121,214+math.floor((i-1)/3)*51,112,43)
    table.insert(controls.Speed.presets,{button = b,value = preset[2]})
    connect(b.Activated,function()
        speed = preset[2]
        if humanoid and config.SpeedEnabled then humanoid.WalkSpeed = speed end
        refresh()
    end)
end
label(pages.Fly,"FLIGHT MODE",0,188,354,18,10,colors.muted)
local modeButtons = {}
for i,name in ipairs({"Camera","Cruise","Hover"}) do
    local b = button(pages.Fly,name,(i-1)*121,214,112,38)
    modeButtons[name] = b
    connect(b.Activated,function() flyMode = name refresh() end)
end
local modeHint = label(pages.Fly,"",0,260,354,35,11,colors.muted)
modeHint.TextWrapped = true
label(pages.Fly,"WASD / stick | Space / E up | Q / Ctrl down",0,305,354,19,10,colors.muted)
label(pages.Fly,"F toggles flight / touch arrows when flying",0,327,354,17,10,colors.muted)
local speedStatus = label(pages.Speed,"",0,327,354,17,10,colors.accent)
local launcher = button(bounds,"",18,0,58,58,18,colors.accent)
launcher.Name = "DraggableUIToggle"
launcher.AnchorPoint = Vector2.new(0,.5)
launcher.Position = UDim2.new(0,18,.5,0)
launcher.ZIndex = 20
icon(launcher,"devil",12,11,34)
local flightPad = create("Frame",{AnchorPoint = Vector2.new(1,1),Position = UDim2.new(1,-20,1,-24),
    Size = UDim2.fromOffset(116,54),BackgroundTransparency = 1,Visible = false},bounds)
local up,down = button(flightPad,"",0,0,52,52),button(flightPad,"",62,0,52,52)
icon(up,"up",14,14,24,colors.purple)
icon(down,"down",14,14,24,colors.purple)

local function stopFlight()
    if not flight then return end
    local old = flight
    flight = nil
    old.velocity:Destroy()
    old.orientation:Destroy()
    old.attachment:Destroy()
    if old.humanoid.Parent then
        old.humanoid.AutoRotate = old.autoRotate
        old.humanoid.PlatformStand = old.platformStand
        if old.humanoid.Health > 0 and not old.platformStand then
            old.humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
    if old.root.Parent then
        old.root.AssemblyLinearVelocity = Vector3.zero
        old.root.AssemblyAngularVelocity = Vector3.zero
    end
end
local function startFlight()
    if flight or not humanoid or not root or not root.Parent or humanoid.Health <= 0 then return end
    local attachment = create("Attachment",{Name = "DevilFlightAttachment"},root)
    local velocity = create("LinearVelocity",{Name = "DevilFlightVelocity",Attachment0 = attachment,
        RelativeTo = Enum.ActuatorRelativeTo.World,VelocityConstraintMode = Enum.VelocityConstraintMode.Vector,
        ForceLimitsEnabled = false,VectorVelocity = Vector3.zero},root)
    local orientation = create("AlignOrientation",{Name = "DevilFlightOrientation",Attachment0 = attachment,
        Mode = Enum.OrientationAlignmentMode.OneAttachment,MaxTorque = 1e9,Responsiveness = 25,
        CFrame = root.CFrame.Rotation},root)
    flight = {attachment = attachment,velocity = velocity,orientation = orientation,
        humanoid = humanoid,root = root,autoRotate = humanoid.AutoRotate,platformStand = humanoid.PlatformStand,
        currentVelocity = Vector3.zero}
    humanoid.AutoRotate = false
    humanoid.PlatformStand = true
end
local function setFly(enabled)
    config.FlyEnabled = enabled
    touchVertical = {}
    if enabled then startFlight() else stopFlight() end
    refresh()
end
connect(controls.Speed.toggle.Activated,function()
    config.SpeedEnabled = not config.SpeedEnabled
    if humanoid then humanoid.WalkSpeed = config.SpeedEnabled and speed or normalSpeed end
    refresh()
end)
connect(controls.Fly.toggle.Activated,function() setFly(not config.FlyEnabled) end)
refresh = function()
    if not alive then return end
    for _,name in ipairs({"Speed","Fly"}) do
        local enabled = (name == "Speed" and config.SpeedEnabled) or (name == "Fly" and config.FlyEnabled)
        local accent = name == "Fly" and colors.purple or colors.accent
        local control = controls[name]
        control.input.Text = tostring(name == "Speed" and speed or flySpeed)
        control.toggle.Text = enabled and "ON / ACTIVE" or "OFF / IDLE"
        control.toggle.BackgroundColor3 = enabled and accent or colors.raised
        control.toggle.TextColor3 = enabled and colors.background or colors.muted
        tabs[name].BackgroundColor3 = selected == name and colors.raised or colors.panel
        pages[name].Visible = selected == name
    end
    for name,b in pairs(modeButtons) do
        b.BackgroundColor3 = flyMode == name and colors.purple or colors.raised
        b.TextColor3 = flyMode == name and colors.background or colors.text
    end
    for _,preset in ipairs(controls.Speed.presets) do
        preset.button.TextColor3 = speed == preset.value and colors.accent or colors.text
    end
    local hints = {Camera = "Fly forward in the direction your camera faces.",
        Cruise = "Level flight. Use up / down to change altitude.",
        Hover = "Hold position. Only up / down changes altitude."}
    modeHint.Text = hints[flyMode]
    flightPad.Visible = config.FlyEnabled
    speedStatus.Text = config.SpeedEnabled and ("GROUND ACTIVE / "..speed.." studs/s") or "GROUND IDLE / ORIGINAL SPEED"
    railStatus.Text = flight and "FLY ACTIVE" or "READY"
    headerStatus.Text = humanoid and "MOVEMENT / CHARACTER LINKED" or "MOVEMENT / WAITING FOR CHARACTER"
end
for name,tab in pairs(tabs) do connect(tab.Activated,function() selected = name refresh() end) end
local function toggleWindow() main.Visible = not main.Visible end
connect(close.Activated,function() main.Visible = false end)
local function clampPosition(object,position)
    local area,size,anchor = bounds.AbsoluteSize,object.AbsoluteSize,object.AnchorPoint
    local minX,minY = size.X*anchor.X+8,size.Y*anchor.Y+8
    local maxX,maxY = area.X-size.X*(1-anchor.X)-8,area.Y-size.Y*(1-anchor.Y)-8
    return Vector2.new(math.clamp(position.X,minX,math.max(minX,maxX)),
        math.clamp(position.Y,minY,math.max(minY,maxY)))
end
local function keepVisible(object)
    local p,area = object.Position,bounds.AbsoluteSize
    local point = clampPosition(object,Vector2.new(p.X.Scale*area.X+p.X.Offset,p.Y.Scale*area.Y+p.Y.Offset))
    object.Position = UDim2.fromOffset(point.X,point.Y)
end
local function draggable(handle,object,onTap)
    local active,start,origin,moved,suppressUntil = nil,nil,nil,false,0
    connect(handle.InputBegan,function(input)
        if active or (input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch) then return end
        active,start,moved = input,Vector2.new(input.Position.X,input.Position.Y),false
        local p,area = object.Position,bounds.AbsoluteSize
        origin = Vector2.new(p.X.Scale*area.X+p.X.Offset,p.Y.Scale*area.Y+p.Y.Offset)
    end)
    connect(UIS.InputChanged,function(input)
        if not active then return end
        if active.UserInputType == Enum.UserInputType.Touch then
            if input ~= active then return end
        elseif input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        local delta = Vector2.new(input.Position.X,input.Position.Y)-start
        if delta.Magnitude > 6 then moved = true end
        if moved then
            local p = clampPosition(object,origin+delta)
            object.Position = UDim2.fromOffset(p.X,p.Y)
        end
    end)
    connect(UIS.InputEnded,function(input)
        if input ~= active then return end
        if moved then suppressUntil = os.clock()+.25 end
        active = nil
    end)
    if onTap then connect(handle.Activated,function()
        if not moved and os.clock() >= suppressUntil then onTap() end
    end) end
end
draggable(header,main)
draggable(launcher,launcher,toggleWindow)
local function responsive()
    local area = bounds.AbsoluteSize
    scale.Scale = math.max(.1,math.min(1,(area.X-96)/540,(area.Y-32)/450))
    keepVisible(main)
    keepVisible(launcher)
end
connect(bounds:GetPropertyChangedSignal("AbsoluteSize"),responsive)
for _,pair in ipairs({{up,1},{down,-1}}) do
    connect(pair[1].InputBegan,function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            touchVertical[input] = pair[2]
        end
    end)
end
connect(UIS.InputEnded,function(input) touchVertical[input] = nil end)
connect(UIS.WindowFocusReleased,function() touchVertical = {} end)
connect(UIS.InputBegan,function(input,processed)
    if processed or UIS:GetFocusedTextBox() then return end
    if input.KeyCode == Enum.KeyCode.F then setFly(not config.FlyEnabled)
    elseif input.KeyCode == Enum.KeyCode.RightShift then toggleWindow() end
end)
local function bindCharacter(nextCharacter)
    stopFlight()
    if speedConnection then speedConnection:Disconnect() speedConnection = nil end
    if deathConnection then deathConnection:Disconnect() deathConnection = nil end
    character,humanoid,root = nextCharacter,nil,nil
    refresh()
    local nextHumanoid = nextCharacter:WaitForChild("Humanoid",10)
    local nextRoot = nextCharacter:WaitForChild("HumanoidRootPart",10)
    if not alive or character ~= nextCharacter or player.Character ~= nextCharacter or not nextHumanoid or not nextRoot then return end
    humanoid,root = nextHumanoid,nextRoot
    normalSpeed = humanoid.WalkSpeed
    if config.SpeedEnabled then humanoid.WalkSpeed = speed end
    speedConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if alive and config.SpeedEnabled and humanoid.WalkSpeed ~= speed then humanoid.WalkSpeed = speed end
    end)
    deathConnection = humanoid.Died:Connect(function()
        stopFlight()
        touchVertical = {}
        refresh()
    end)
    if config.FlyEnabled then startFlight() end
    refresh()
end
connect(player.CharacterAdded,function(nextCharacter) task.spawn(bindCharacter,nextCharacter) end)
connect(player.CharacterRemoving,function(oldCharacter)
    if oldCharacter ~= character then return end
    stopFlight()
    if speedConnection then speedConnection:Disconnect() speedConnection = nil end
    if deathConnection then deathConnection:Disconnect() deathConnection = nil end
    character,humanoid,root = nil,nil,nil
    touchVertical = {}
    refresh()
end)
local function key(code) return UIS:IsKeyDown(code) and 1 or 0 end
connect(RunService.PreSimulation,function(dt)
    if not flight then return end
    local camera = workspace.CurrentCamera
    if not camera or not root or not root.Parent or humanoid.Health <= 0 then return end
    local look = camera.CFrame.LookVector
    local flat = Vector3.new(look.X,0,look.Z)
    if flat.Magnitude < .001 then
        local facing = root.CFrame.LookVector
        flat = Vector3.new(facing.X,0,facing.Z)
        if flat.Magnitude < .001 then flat = Vector3.new(0,0,-1) end
    end
    flat = flat.Unit
    local right = Vector3.new(-flat.Z,0,flat.X)
    local direction,vertical = Vector3.zero,0
    if not UIS:GetFocusedTextBox() then
        local forward = key(Enum.KeyCode.W)-key(Enum.KeyCode.S)
        local sideways = key(Enum.KeyCode.D)-key(Enum.KeyCode.A)
        if forward == 0 and sideways == 0 then
            local movement = humanoid.MoveDirection
            forward,sideways = movement:Dot(flat),movement:Dot(right)
        end
        if flyMode ~= "Hover" then direction = (flyMode == "Camera" and look or flat)*forward+right*sideways end
        vertical = key(Enum.KeyCode.Space)+key(Enum.KeyCode.E)-key(Enum.KeyCode.Q)
            -key(Enum.KeyCode.LeftControl)-key(Enum.KeyCode.RightControl)
    end
    for _,value in pairs(touchVertical) do vertical = vertical+value end
    direction = direction+Vector3.new(0,math.clamp(vertical,-1,1),0)
    if direction.Magnitude > 1 then direction = direction.Unit end
    local alpha = flyMode == "Hover" and 1 or (1-math.exp(-12*dt))
    flight.currentVelocity = flight.currentVelocity:Lerp(direction*flySpeed,alpha)
    flight.velocity.VectorVelocity = flight.currentVelocity
    flight.orientation.CFrame = CFrame.lookAt(Vector3.zero,flat)
end)
connect(gui.Destroying,function()
    alive = false
    stopFlight()
    if speedConnection then speedConnection:Disconnect() end
    if deathConnection then deathConnection:Disconnect() end
    if humanoid and humanoid.Parent and config.SpeedEnabled then humanoid.WalkSpeed = normalSpeed end
    for _,connection in ipairs(connections) do connection:Disconnect() end
    touchVertical = {}
end)
refresh()
task.defer(function() if alive then responsive() end end)
if player.Character then task.spawn(bindCharacter,player.Character) end
print("[DEVIL V6] Speed + Fly ready.")
