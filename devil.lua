-- DEVIL HUB / ANIME LEGACY
-- Built from src/ui.lua + src/legacy.lua by tools/build.py.
if not game:IsLoaded() then game.Loaded:Wait() end
local function notify(message)
    local ok = pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Devil Hub", Text = message, Duration = 8,
        })
    end)
    if not ok then warn("[Devil Hub] " .. message) end
end
if game.GameId ~= 10765902945 and game.PlaceId ~= 106198175232796 then
    notify("Devil Hub: this build supports Anime Legacy.")
    return
end
local success, result = xpcall(function()
local DevilUI = (function()
-- Devil Hub UI: native vector icons, compact cards, touch-friendly controls.
-- API-compatible with the recovered Legacy feature controller.
local UI = {APIVersion = 1, LayoutRevision = 3,
    LogoURL = "https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png"}
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local palette = {
    background = Color3.fromRGB(16, 11, 16), sidebar = Color3.fromRGB(22, 14, 21),
    card = Color3.fromRGB(27, 18, 26), field = Color3.fromRGB(36, 24, 34),
    line = Color3.fromRGB(59, 35, 48), text = Color3.fromRGB(238, 228, 235),
    muted = Color3.fromRGB(149, 126, 142), accent = Color3.fromRGB(247, 48, 75),
}
local paths = {
    devil = {{{5,9},{3,3},{9,6}},{{19,9},{21,3},{15,6}},{{5,9},{5,16},{12,22},{19,16},{19,9},{12,6},{5,9}},{{8,12},{10,13}},{{16,12},{14,13}},{{9,17},{15,17}}},
    home = {{{3,11},{12,3},{21,11}},{{5,10},{5,21},{10,21},{10,15},{14,15},{14,21},{19,21},{19,10}}},
    grid = {{{3,3},{10,3},{10,10},{3,10},{3,3}},{{14,3},{21,3},{21,10},{14,10},{14,3}},{{3,14},{10,14},{10,21},{3,21},{3,14}},{{14,14},{21,14},{21,21},{14,21},{14,14}}},
    sword = {{{5,19},{19,5},{21,3},{21,7},{7,21}},{{3,15},{9,21}},{{3,21},{5,19}}},
    fruit = {{{12,7},{7,6},{4,10},{4,16},{8,21},{12,20},{16,21},{20,16},{20,10},{17,6},{12,7}},{{12,7},{13,3},{17,2}}},
    player = {{{8,3},{16,3},{17,7},{15,11},{9,11},{7,7},{8,3}},{{3,21},{4,16},{9,14},{15,14},{20,16},{21,21}}},
    star = {{{12,2},{15,8},{22,9},{17,14},{18,22},{12,18},{6,22},{7,14},{2,9},{9,8},{12,2}}},
    flask = {{{8,2},{16,2}},{{9,2},{9,9},{3,19},{5,22},{19,22},{21,19},{15,9},{15,2}},{{7,15},{17,15}}},
    gear = {{{9,3},{15,3},{16,7},{20,9},{20,15},{16,17},{15,21},{9,21},{8,17},{4,15},{4,9},{8,7},{9,3}},{{9,9},{15,9},{15,15},{9,15},{9,9}}},
    search = {{{9,3},{14,4},{17,9},{16,14},{11,17},{6,16},{3,11},{4,6},{9,3}},{{16,16},{22,22}}},
    bolt = {{{13,2},{5,14},{11,14},{10,22},{20,9},{14,9},{13,2}}},
    wind = {{{3,6},{16,6},{19,3},{22,6},{20,9},{3,9}},{{3,13},{17,13},{20,16},{17,19},{14,18}},{{3,17},{9,17},{12,20},{9,22}}},
    minus = {{{5,12},{19,12}}}, close = {{{6,6},{18,18}},{{18,6},{6,18}}},
    chevron = {{{8,5},{15,12},{8,19}}}, down = {{{5,8},{12,15},{19,8}}},
}
local tabIcons = {Main = "home",Farm = "home",Fruits = "fruit",Modes = "grid",Equipment = "sword",
    Player = "player",Gacha = "star",Auto = "bolt",Potions = "flask",Traits = "star",
    Breathing = "wind",Config = "gear",Search = "search"}
local function make(class, parent, props)
    local object = Instance.new(class)
    for key, value in pairs(props or {}) do object[key] = value end
    object.Parent = parent
    return object
end
local function rounded(parent, radius)
    make("UICorner",parent,{CornerRadius = UDim.new(0,radius or 8)})
end
local function outlined(parent,color,transparency)
    return make("UIStroke",parent,{Color = color or palette.line,Thickness = 1,
        Transparency = transparency or 0,ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end
local function text(parent,value,position,size,fontSize,color)
    return make("TextLabel",parent,{BackgroundTransparency = 1,Position = position or UDim2.new(),
        Size = size or UDim2.new(1,0,0,22),Text = value or "",Font = Enum.Font.Gotham,
        TextSize = fontSize or 12,TextColor3 = color or palette.text,
        TextXAlignment = Enum.TextXAlignment.Left,TextTruncate = Enum.TextTruncate.AtEnd})
end
local function click(parent,props)
    props = props or {}
    props.Text = props.Text or ""
    props.AutoButtonColor = false
    props.BorderSizePixel = 0
    props.Font = Enum.Font.GothamMedium
    props.TextSize = props.TextSize or 12
    props.TextColor3 = props.TextColor3 or palette.text
    props.BackgroundColor3 = props.BackgroundColor3 or palette.field
    local object = make("TextButton",parent,props)
    rounded(object,7)
    return object
end
local function drawIcon(parent,kind,position,size,color)
    local holder = make("Frame",parent,{Name = "VectorIcon",Position = position,
        Size = UDim2.fromOffset(size,size),BackgroundTransparency = 1})
    for _,path in ipairs(paths[kind] or paths.grid) do
        for i = 1,#path-1 do
            local a,b = path[i],path[i+1]
            local dx,dy = b[1]-a[1],b[2]-a[2]
            local line = make("Frame",holder,{AnchorPoint = Vector2.new(.5,.5),BorderSizePixel = 0,
                BackgroundColor3 = color or palette.accent,
                Position = UDim2.fromScale((a[1]+b[1])/48,(a[2]+b[2])/48),
                Size = UDim2.fromOffset(math.sqrt(dx*dx+dy*dy)*size/24,math.max(1.3,size/15)),
                Rotation = math.deg(math.atan2(dy,dx))})
            rounded(line,3)
        end
    end
    return holder
end
local themes = {
    ["Devil - Crimson"] = Color3.fromRGB(247,48,75),
    ["Devil - Violet"] = Color3.fromRGB(177,112,255),
    ["Devil - Emerald"] = Color3.fromRGB(67,220,159),
    ["Devil - Ice"] = Color3.fromRGB(92,182,255),
    ["Devil - Amber"] = Color3.fromRGB(255,171,68),
    ["Devil - Rose"] = Color3.fromRGB(255,109,178),
    ["Devil - Silver"] = Color3.fromRGB(209,214,230),
}
local themeAliases = {["Itachi - Red"] = "Devil - Crimson",["Itachi - Dark"] = "Devil - Silver",
    ["Yuno - Green"] = "Devil - Emerald",["Rimuru - Blue"] = "Devil - Ice",
    ["Gojo - Purple"] = "Devil - Violet",["Luffy - Orange"] = "Devil - Amber",
    ["Minato - Yellow"] = "Devil - Amber",["Milim - Pink"] = "Devil - Rose",
    ["Honred Gojo - White"] = "Devil - Silver"}
function UI:GetThemeOptions()
    local result = {}
    for _,name in ipairs({"Devil - Crimson","Devil - Violet","Devil - Emerald","Devil - Ice","Devil - Amber","Devil - Rose","Devil - Silver"}) do
        table.insert(result,{Title = name,Value = name})
    end
    return result
end
local logoAsset,logoAttempted = "",false
function UI:GetLogo()
    if logoAttempted then return logoAsset end
    logoAttempted = true
    local customAsset = getcustomasset or getsynasset
    if type(customAsset) ~= "function" or type(writefile) ~= "function" then return "" end
    local ok,result = pcall(function()
        -- Content-specific cache name prevents an older brand image being reused.
        local path = "devil-hub-logo-daceb9cac221.png"
        if type(isfile) ~= "function" or not isfile(path) then
            local data = game:HttpGet(self.LogoURL)
            assert(type(data) == "string" and data:sub(1,8) == "\137PNG\13\10\26\10","Invalid Devil Hub logo")
            writefile(path,data)
        end
        local asset = customAsset(path)
        assert(type(asset) == "string" and asset ~= "","Logo asset unavailable")
        return asset
    end)
    if ok then logoAsset = result end
    return logoAsset
end
function UI:GetTabIcon(name) return tabIcons[name] or name end

function UI:CreateWindow(config)
    config = config or {}
    local window = {_tabs = {},_connections = {},_items = {},_accentObjects = {},_popups = {},_cleanup = {},_alive = true}
    local accent = palette.accent
    local function listen(signal,callback)
        local connection = signal:Connect(callback)
        table.insert(window._connections,connection)
        return connection
    end
    local function animate(object,props)
        TweenService:Create(object,TweenInfo.new(.16,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),props):Play()
    end
    local function accentObject(object,property)
        object[property] = accent
        table.insert(window._accentObjects,{object,property})
    end
    local gui = make("ScreenGui",Players.LocalPlayer:WaitForChild("PlayerGui"),{
        Name = "DevilHub",ResetOnSpawn = false,IgnoreGuiInset = false,DisplayOrder = 1000,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    window.Gui = gui
    local bounds = make("Frame",gui,{Name = "Bounds",Size = UDim2.fromScale(1,1),BackgroundTransparency = 1})
    local frame = make("Frame",bounds,{Name = "DevilWindow",AnchorPoint = Vector2.new(.5,.5),
        Position = UDim2.fromScale(.5,.5),Size = UDim2.fromOffset(860,570),
        BackgroundColor3 = palette.background,BackgroundTransparency = .04,BorderSizePixel = 0,ClipsDescendants = true})
    window.Frame = frame
    rounded(frame,13)
    outlined(frame,palette.line,.15)
    local topLine = make("Frame",frame,{Size = UDim2.new(1,-28,0,1),Position = UDim2.fromOffset(14,0),BorderSizePixel = 0})
    accentObject(topLine,"BackgroundColor3")
    local scale = make("UIScale",frame,{Name = "ResponsiveScale",Scale = 1})
    local sidebar = make("Frame",frame,{Name = "Sidebar",Size = UDim2.new(0,82,1,0),
        BackgroundColor3 = palette.sidebar,BorderSizePixel = 0})
    make("Frame",sidebar,{Position = UDim2.new(1,-1,0,0),Size = UDim2.new(0,1,1,0),
        BackgroundColor3 = palette.line,BackgroundTransparency = .35,BorderSizePixel = 0})
    local logo = drawIcon(sidebar,"devil",UDim2.fromOffset(24,18),34,accent)
    for _,line in ipairs(logo:GetDescendants()) do if line:IsA("Frame") then accentObject(line,"BackgroundColor3") end end
    local sidebarLogo = make("ImageLabel",sidebar,{Name = "DevilBrandLogo",Position = UDim2.fromOffset(13,10),
        Size = UDim2.fromOffset(56,50),BackgroundTransparency = 1,Image = "",Visible = false,ScaleType = Enum.ScaleType.Fit})
    rounded(sidebarLogo,8)
    local navigation = make("ScrollingFrame",sidebar,{Name = "Navigation",Position = UDim2.fromOffset(4,70),
        Size = UDim2.new(1,-8,1,-152),BackgroundTransparency = 1,BorderSizePixel = 0,
        ScrollBarThickness = 2,ScrollBarImageColor3 = palette.line,AutomaticCanvasSize = Enum.AutomaticSize.Y,CanvasSize = UDim2.new()})
    make("UIListLayout",navigation,{Padding = UDim.new(0,3),SortOrder = Enum.SortOrder.LayoutOrder})
    local profile = make("Frame",sidebar,{Position = UDim2.new(0,8,1,-73),Size = UDim2.fromOffset(66,65),BackgroundTransparency = 1})
    local avatar = make("ImageLabel",profile,{Position = UDim2.fromOffset(19,0),Size = UDim2.fromOffset(28,28),
        BackgroundColor3 = palette.field,BorderSizePixel = 0,Image = ""})
    rounded(avatar,14)
    local username = text(profile,Players.LocalPlayer.DisplayName,UDim2.fromOffset(0,33),UDim2.fromOffset(66,15),9)
    username.TextXAlignment = Enum.TextXAlignment.Center
    local badge = text(profile,"DEVIL HUB",UDim2.fromOffset(0,49),UDim2.fromOffset(66,12),8,palette.muted)
    badge.TextXAlignment = Enum.TextXAlignment.Center
    task.spawn(function()
        local ok,image = pcall(function()
            return Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100)
        end)
        if window._alive and ok then avatar.Image = image end
    end)
    local header = make("Frame",frame,{Name = "Header",Position = UDim2.fromOffset(98,0),Size = UDim2.new(1,-355,0,56),BackgroundTransparency = 1,Active = true})
    local heading = text(header,"Main",UDim2.fromOffset(28,10),UDim2.new(1,-30,0,24),16)
    heading.Font = Enum.Font.GothamBold
    local headingIcon = drawIcon(header,"home",UDim2.fromOffset(0,12),20,accent)
    local subtitle = text(header,config.Title or "Devil Hub",UDim2.fromOffset(29,34),UDim2.new(1,-30,0,14),9,palette.muted)
    local searchBox = make("TextBox",frame,{Name = "GlobalSearch",Position = UDim2.new(1,-246,0,13),Size = UDim2.fromOffset(170,30),
        Text = "",PlaceholderText = "Search this page...",ClearTextOnFocus = false,TextColor3 = palette.text,
        PlaceholderColor3 = palette.muted,Font = Enum.Font.Gotham,TextSize = 10,BackgroundColor3 = palette.card,BorderSizePixel = 0})
    rounded(searchBox,7)
    local minimize = click(frame,{Name = "Minimize",Position = UDim2.new(1,-68,0,15),Size = UDim2.fromOffset(24,26),BackgroundTransparency = 1})
    drawIcon(minimize,"minus",UDim2.fromOffset(4,5),16,palette.muted)
    local close = click(frame,{Name = "Close",Position = UDim2.new(1,-38,0,15),Size = UDim2.fromOffset(24,26),BackgroundTransparency = 1})
    drawIcon(close,"close",UDim2.fromOffset(4,5),16,palette.muted)
    local pageSelectors = make("Frame",frame,{Name = "PageSelectors",Position = UDim2.fromOffset(98,59),
        Size = UDim2.new(1,-112,0,34),BackgroundTransparency = 1})
    local content = make("Frame",frame,{Name = "Content",Position = UDim2.fromOffset(98,102),
        Size = UDim2.new(1,-112,1,-138),BackgroundTransparency = 1})
    local footer = text(frame,"ANIME LEGACY  /  DEVIL HUB",UDim2.new(0,100,1,-28),UDim2.new(1,-245,0,18),9,palette.muted)
    text(frame,"CTRL / RSHIFT  ·  HIDE",UDim2.new(1,-151,1,-28),UDim2.fromOffset(140,18),8,palette.muted)
    local launcher = click(bounds,{Name = "DevilLauncher",Position = UDim2.new(0,16,.45,0),Size = UDim2.fromOffset(52,52),
        BackgroundColor3 = palette.sidebar,ZIndex = 50})
    rounded(launcher,15)
    local launcherStroke = outlined(launcher,accent,.25)
    accentObject(launcherStroke,"Color")
    local launcherVector = drawIcon(launcher,"devil",UDim2.fromOffset(10,9),32,accent)
    local launcherLogo = make("ImageLabel",launcher,{Name = "DevilBrandLogo",Position = UDim2.fromOffset(4,4),
        Size = UDim2.fromOffset(44,44),BackgroundTransparency = 1,Image = "",Visible = false,ScaleType = Enum.ScaleType.Fit})
    rounded(launcherLogo,7)
    window.LogoImages = {sidebarLogo,launcherLogo}
    task.spawn(function()
        local asset = UI:GetLogo()
        if asset ~= "" and window._alive then
            for _,image in ipairs(window.LogoImages) do image.Image = asset image.Visible = true end
            logo.Visible = false launcherVector.Visible = false
        end
    end)
    window.Launcher = launcher
    local function closePopups()
        for popup,api in pairs(window._popups) do
            popup.Visible = false
            api._opened = false
        end
    end
    function window:SetMinimized(value)
        gui:SetAttribute("Minimized",value == true)
        frame.Visible = value ~= true
        closePopups()
    end
    function window:Destroy() gui:Destroy() end
    function window:SetTitle(value) subtitle.Text = tostring(value) end
    function window:SetDescription(value) footer.Text = tostring(value).."  /  DEVIL HUB" end
    function window:GetThemeAccent() return accent end
    function window:SetTheme(name)
        accent = themes[themeAliases[name] or name] or themes["Devil - Crimson"]
        for _,entry in ipairs(self._accentObjects) do if entry[1].Parent then entry[1][entry[2]] = accent end end
        for _,item in ipairs(self._items) do if item.Paint then item:Paint() end end
        if self._selected then self:SelectTab(self._selected) end
    end
    function window:BindThemeSettings(settings)
        self._settings = settings
        self:SetTheme(settings.UITheme)
        local last = settings.UITheme
        listen(game:GetService("RunService").Heartbeat,function()
            if last ~= settings.UITheme then last = settings.UITheme self:SetTheme(last) end
        end)
    end
    local function clampObject(object,point)
        local area,size,a = bounds.AbsoluteSize,object.AbsoluteSize,object.AnchorPoint
        local lowerX,lowerY = size.X*a.X+6,size.Y*a.Y+6
        return Vector2.new(math.clamp(point.X,lowerX,math.max(lowerX,area.X-size.X*(1-a.X)-6)),
            math.clamp(point.Y,lowerY,math.max(lowerY,area.Y-size.Y*(1-a.Y)-6)))
    end
    local function drag(handle,object,onClick)
        local pointer,start,origin,moved,suppress = nil,nil,nil,false,0
        listen(handle.InputBegan,function(input)
            if pointer or (input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch) then return end
            pointer,start,moved = input,Vector2.new(input.Position.X,input.Position.Y),false
            local p,area = object.Position,bounds.AbsoluteSize
            origin = Vector2.new(p.X.Scale*area.X+p.X.Offset,p.Y.Scale*area.Y+p.Y.Offset)
        end)
        listen(UIS.InputChanged,function(input)
            if not pointer then return end
            if pointer.UserInputType == Enum.UserInputType.Touch then if input ~= pointer then return end
            elseif input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            local delta = Vector2.new(input.Position.X,input.Position.Y)-start
            if delta.Magnitude > 6 then moved = true end
            if moved then local p = clampObject(object,origin+delta) object.Position = UDim2.fromOffset(p.X,p.Y) end
        end)
        listen(UIS.InputEnded,function(input)
            if input == pointer then if moved then suppress = os.clock()+.25 end pointer = nil end
        end)
        if onClick then listen(handle.Activated,function() if not moved and os.clock() >= suppress then onClick() end end) end
    end
    drag(header,frame)
    drag(launcher,launcher,function() window:SetMinimized(not gui:GetAttribute("Minimized")) end)
    listen(minimize.Activated,function() window:SetMinimized(true) end)
    listen(close.Activated,function() window:SetMinimized(true) end)
    listen(UIS.InputBegan,function(input,processed)
        if input.KeyCode == Enum.KeyCode.Escape then closePopups() end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local function inside(object)
                local p,s = object.AbsolutePosition,object.AbsoluteSize
                return input.Position.X >= p.X and input.Position.X <= p.X+s.X
                    and input.Position.Y >= p.Y and input.Position.Y <= p.Y+s.Y
            end
            for popup,api in pairs(window._popups) do
                if popup.Visible and not inside(popup) and not inside(api.Selector) then closePopups() break end
            end
        end
        if processed or UIS:GetFocusedTextBox() then return end
        if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
            window:SetMinimized(not gui:GetAttribute("Minimized"))
        end
    end)
    function window:Filter(query)
        query = tostring(query or ""):lower()
        for _,tab in ipairs(self._tabs) do for _,page in ipairs(tab._pages) do
            for _,item in ipairs(page._items) do
                if query == "" then
                    if item._filtering then item.Instance.Visible = item._beforeFilter item._filtering = false end
                else
                    if not item._filtering then item._beforeFilter = item.Instance.Visible item._filtering = true end
                    item.Instance.Visible = item._beforeFilter and (item.SearchText or ""):find(query,1,true) ~= nil
                end
            end
        end end
    end
    listen(searchBox:GetPropertyChangedSignal("Text"),function() window:Filter(searchBox.Text) end)
    function window:SelectTab(tab)
        closePopups()
        self._selected = tab
        heading.Text = tab.Name
        headingIcon:Destroy()
        headingIcon = drawIcon(header,tabIcons[tab.Name] or "grid",UDim2.fromOffset(0,12),20,accent)
        for _,other in ipairs(self._tabs) do
            local selected = other == tab
            other.Selector.Visible = selected
            other.Button.BackgroundTransparency = selected and .25 or 1
            other.Indicator.Visible = selected
            other.Title.TextColor3 = selected and accent or palette.muted
            for _,line in ipairs(other.Icon:GetDescendants()) do if line:IsA("Frame") then line.BackgroundColor3 = selected and accent or palette.muted end end
            for _,page in ipairs(other._pages) do page.Page.Visible = selected and page == other._activePage end
        end
    end
    local methods = {}
    local function register(page,api,config)
        api.Frame = api.Instance
        api.SearchText = (tostring(config.Title or "").." "..tostring(config.Description or "")):lower()
        table.insert(page._items,api)
        table.insert(window._items,api)
        api.Instance.LayoutOrder = #page._items
        return api
    end
    local function row(page,config,height,class)
        local column = page.Columns[config.Column == 2 and 2 or 1]
        local object = make(class or "Frame",column,{Name = (config.Title or "Control").."Row",Size = UDim2.new(1,0,0,height or 38),
            BackgroundTransparency = 1,BorderSizePixel = 0})
        if class == "TextButton" then object.Text = "" object.AutoButtonColor = false end
        local title = text(object,config.Title,UDim2.fromOffset(12,3),UDim2.new(1,-82,0,28),11)
        title.Name = "Title"
        local description = text(object,config.Description or "",UDim2.fromOffset(12,31),UDim2.new(1,-24,0,0),10,palette.muted)
        description.Name = "Description"
        description.TextWrapped = true
        description.TextTruncate = Enum.TextTruncate.None
        description.TextYAlignment = Enum.TextYAlignment.Top
        if config.Description and config.Description ~= "" then
            description.Size = UDim2.new(1,-24,0,28)
            object.Size = UDim2.new(1,0,0,math.max(height or 38,65))
        else description.Visible = false end
        return {Instance = object,Title = title,Description = description}
    end
    local function callback(config,value,skip)
        if not skip and type(config.Callback) == "function" then
            local ok,err = pcall(config.Callback,value)
            if not ok then warn("[Devil Hub] "..tostring(err)) end
        end
    end
    function methods:AddToggle(config)
        local api = row(self,config,38,"TextButton")
        local switch = make("Frame",api.Instance,{Name = "Switch",Position = UDim2.new(1,-44,0,10),Size = UDim2.fromOffset(30,16),
            BackgroundColor3 = palette.line,BorderSizePixel = 0})
        rounded(switch,8)
        local knob = make("Frame",switch,{Name = "Knob",Position = UDim2.fromOffset(3,3),Size = UDim2.fromOffset(10,10),
            BackgroundColor3 = palette.muted,BorderSizePixel = 0})
        rounded(knob,5)
        api.Switch = switch
        function api:Paint()
            animate(switch,{BackgroundColor3 = self.Value and accent or palette.line})
            animate(knob,{Position = UDim2.fromOffset(self.Value and 17 or 3,3),BackgroundColor3 = self.Value and palette.text or palette.muted})
        end
        function api:Set(value,skip) self.Value = value == true self:Paint() callback(config,self.Value,skip) end
        function api:Get() return self.Value end
        api:Set(config.Default,true)
        listen(api.Instance.Activated,function() api:Set(not api.Value) end)
        return register(self,api,config)
    end
    function methods:AddButton(config)
        local api = row(self,config,38,"TextButton")
        api.Title.Size = UDim2.new(1,-45,0,28)
        drawIcon(api.Instance,"chevron",UDim2.new(1,-31,0,11),14,palette.muted)
        listen(api.Instance.Activated,function() callback(config,nil,false) end)
        listen(api.Instance.MouseEnter,function() animate(api.Instance,{BackgroundColor3 = palette.field,BackgroundTransparency = .25}) end)
        listen(api.Instance.MouseLeave,function() animate(api.Instance,{BackgroundTransparency = 1}) end)
        return register(self,api,config)
    end
    function methods:AddParagraph(config)
        local api = row(self,config,40)
        api.Title.Size = UDim2.new(1,-24,0,24)
        api.Description.Visible = true
        api.Description.Position = UDim2.fromOffset(12,29)
        api.Description.Size = UDim2.new(1,-24,0,0)
        api.Description.AutomaticSize = Enum.AutomaticSize.Y
        api.Instance.AutomaticSize = Enum.AutomaticSize.Y
        make("UIPadding",api.Instance,{PaddingBottom = UDim.new(0,12)})
        function api:SetTitle(value) self.Title.Text = tostring(value) end
        function api:SetDescription(value) self.Description.Text = tostring(value) end
        return register(self,api,config)
    end
    function methods:AddInput(config)
        local api = row(self,config,40)
        api.Title.Size = UDim2.new(.48,-16,0,28)
        local box = make("TextBox",api.Instance,{Position = UDim2.new(.48,0,0,6),Size = UDim2.new(.52,-12,0,27),
            Text = tostring(config.Default or ""),PlaceholderText = config.Placeholder or "Enter value",ClearTextOnFocus = false,
            Font = Enum.Font.Gotham,TextSize = 11,TextColor3 = palette.text,BackgroundColor3 = palette.field,BorderSizePixel = 0})
        rounded(box,5)
        api.Input,api.ValueBox,api.Value = box,box,box.Text
        function api:Set(value,skip) self.Value = tostring(value or "") box.Text = self.Value callback(config,self.Value,skip) end
        function api:Get() return self.Value end
        listen(box.FocusLost,function() api:Set(box.Text) end)
        return register(self,api,config)
    end
    function methods:AddSlider(config)
        local api = row(self,config,66)
        local minimum,maximum = tonumber(config.Min) or 0,tonumber(config.Max) or 100
        if minimum > maximum then minimum,maximum = maximum,minimum end
        local step = math.max(.000001,math.abs(tonumber(config.Increment or config.Step) or 1))
        api.Title.Size = UDim2.new(1,-95,0,25)
        local boxHolder = make("Frame",api.Instance,{Position = UDim2.new(1,-72,0,4),Size = UDim2.fromOffset(60,25),BackgroundColor3 = palette.field,BorderSizePixel = 0})
        rounded(boxHolder,5)
        local box = make("TextBox",boxHolder,{Size = UDim2.fromScale(1,1),BackgroundTransparency = 1,Text = "",
            Font = Enum.Font.Gotham,TextSize = 11,TextColor3 = palette.text,ClearTextOnFocus = false})
        local track = click(api.Instance,{Name = "SliderTrack",Position = UDim2.fromOffset(12,35),Size = UDim2.new(1,-24,0,23),BackgroundTransparency = 1})
        local rail = make("Frame",track,{Position = UDim2.new(0,0,.5,-2),Size = UDim2.new(1,0,0,4),BackgroundColor3 = palette.line,BorderSizePixel = 0})
        rounded(rail,2)
        local fill = make("Frame",rail,{Size = UDim2.fromScale(0,1),BackgroundColor3 = accent,BorderSizePixel = 0})
        rounded(fill,2)
        local knob = make("Frame",track,{AnchorPoint = Vector2.new(.5,.5),Position = UDim2.fromScale(0,.5),Size = UDim2.fromOffset(10,10),BackgroundColor3 = accent,BorderSizePixel = 0})
        rounded(knob,5)
        api.ValueBox,api.Track,api.Min,api.Max = box,track,minimum,maximum
        function api:Paint() fill.BackgroundColor3 = accent knob.BackgroundColor3 = accent end
        function api:Set(value,skip)
            local number = tonumber(value)
            if not number or number ~= number or math.abs(number) == math.huge then box.Text = tostring(self.Value or minimum) return end
            number = math.clamp(minimum+math.round((number-minimum)/step)*step,minimum,maximum)
            self.Value = number box.Text = tostring(number)
            local alpha = maximum == minimum and 0 or (number-minimum)/(maximum-minimum)
            fill.Size = UDim2.fromScale(alpha,1) knob.Position = UDim2.fromScale(alpha,.5)
            callback(config,number,skip)
        end
        function api:Get() return self.Value end
        local pointer
        local function move(x) api:Set(minimum+(maximum-minimum)*math.clamp((x-track.AbsolutePosition.X)/math.max(1,track.AbsoluteSize.X),0,1)) end
        listen(track.InputBegan,function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then pointer = input move(input.Position.X) end
        end)
        listen(UIS.InputChanged,function(input)
            if pointer and (input == pointer or (pointer.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement)) then move(input.Position.X) end
        end)
        listen(UIS.InputEnded,function(input) if input == pointer then pointer = nil end end)
        listen(box.FocusLost,function() api:Set(box.Text) end)
        api:Set(config.Default or minimum,true)
        return register(self,api,config)
    end
    function methods:AddDropdown(config)
        local api = row(self,config,39)
        api.Title.Size = UDim2.new(.47,-16,0,28)
        local selector = click(api.Instance,{Name = "Selector",Position = UDim2.new(.47,0,0,5),Size = UDim2.new(.53,-12,0,28),BackgroundTransparency = .5})
        local valueText = text(selector,"",UDim2.fromOffset(8,0),UDim2.new(1,-28,1,0),10,palette.muted)
        drawIcon(selector,"down",UDim2.new(1,-19,0,8),12,palette.muted)
        local popup = make("Frame",bounds,{Name = "DropdownPopup",BackgroundColor3 = palette.card,BorderSizePixel = 0,Visible = false,ZIndex = 80})
        rounded(popup,9)
        outlined(popup,palette.line)
        local popupSearch = make("TextBox",popup,{Position = UDim2.fromOffset(8,8),Size = UDim2.new(1,-16,0,28),Text = "",PlaceholderText = "Filter options...",
            ClearTextOnFocus = false,TextColor3 = palette.text,PlaceholderColor3 = palette.muted,Font = Enum.Font.Gotham,TextSize = 11,BackgroundColor3 = palette.field,BorderSizePixel = 0})
        rounded(popupSearch,5)
        local list = make("ScrollingFrame",popup,{Position = UDim2.fromOffset(6,42),Size = UDim2.new(1,-12,1,-48),BackgroundTransparency = 1,BorderSizePixel = 0,
            ScrollBarThickness = 3,ScrollBarImageColor3 = palette.line,AutomaticCanvasSize = Enum.AutomaticSize.Y,CanvasSize = UDim2.new()})
        make("UIListLayout",list,{Padding = UDim.new(0,3),SortOrder = Enum.SortOrder.LayoutOrder})
        window._popups[popup] = api
        local options,optionRows,optionConnections = {},{},{}
        api.Selector = selector
        api._opened = false
        local function selected(value)
            return config.Multi and table.find(api.Value or {},value) ~= nil or (not config.Multi and api.Value == value)
        end
        local function repaint()
            local names = {}
            for _,option in ipairs(options) do if selected(option.Value) then table.insert(names,option.Title) end end
            valueText.Text = #names > 0 and table.concat(names,", ") or "Select..."
            for _,entry in ipairs(optionRows) do
                entry.check.BackgroundColor3 = selected(entry.option.Value) and accent or palette.line
            end
        end
        function api:Paint() repaint() end
        function api:Set(value,skip)
            if config.Multi then self.Value = type(value) == "table" and table.clone(value) or {}
            else self.Value = value end
            repaint() callback(config,self.Value,skip)
        end
        function api:Get() return self.Value end
        function api:Reload(values)
            for _,connection in ipairs(optionConnections) do connection:Disconnect() end
            table.clear(optionConnections)
            for _,entry in ipairs(optionRows) do entry.row:Destroy() end
            options,optionRows = {},{}
            for i,value in ipairs(values or {}) do
                local option = type(value) == "table" and {Title = tostring(value.Title or value.Value),Value = value.Value,Description = value.Description} or {Title = tostring(value),Value = value}
                table.insert(options,option)
                local object = click(list,{Name = "Option",Size = UDim2.new(1,-3,0,option.Description and 64 or 32),BackgroundTransparency = .6,LayoutOrder = i})
                local check = make("Frame",object,{Name = "Check",Position = UDim2.fromOffset(8,10),Size = UDim2.fromOffset(12,12),BorderSizePixel = 0,BackgroundColor3 = palette.line})
                rounded(check,3)
                text(object,option.Title,UDim2.fromOffset(29,3),UDim2.new(1,-37,0,26),11)
                if option.Description then
                    local desc = text(object,tostring(option.Description),UDim2.fromOffset(29,29),UDim2.new(1,-37,0,30),9,palette.muted)
                    desc.Name = "Description" desc.TextWrapped = true desc.TextTruncate = Enum.TextTruncate.None
                    desc.Size = UDim2.new(1,-37,0,0) desc.AutomaticSize = Enum.AutomaticSize.Y
                    object.AutomaticSize = Enum.AutomaticSize.Y
                    make("UIPadding",object,{PaddingBottom = UDim.new(0,8)})
                end
                table.insert(optionRows,{row = object,check = check,option = option})
                table.insert(optionConnections,object.Activated:Connect(function()
                    if config.Multi then
                        local result = table.clone(api.Value or {})
                        local index = table.find(result,option.Value)
                        if index then table.remove(result,index) else table.insert(result,option.Value) end
                        api:Set(result)
                    else api:Set(option.Value) api._opened = false popup.Visible = false end
                end))
            end
            repaint()
        end
        local function filterOptions()
            local query = popupSearch.Text:lower()
            for _,entry in ipairs(optionRows) do entry.row.Visible = query == "" or (entry.option.Title.." "..tostring(entry.option.Description or "")):lower():find(query,1,true) ~= nil end
        end
        listen(popupSearch:GetPropertyChangedSignal("Text"),filterOptions)
        local function placePopup()
            local origin = bounds.AbsolutePosition
            local area = bounds.AbsoluteSize
            local width = math.min(math.max(220,selector.AbsoluteSize.X),area.X-16)
            local height = math.min(276,area.Y-16)
            local x = math.clamp(selector.AbsolutePosition.X-origin.X,8,math.max(8,area.X-width-8))
            local y = selector.AbsolutePosition.Y-origin.Y+selector.AbsoluteSize.Y+5
            if y+height > area.Y-8 then y = math.max(8,selector.AbsolutePosition.Y-origin.Y-height-5) end
            popup.Position = UDim2.fromOffset(x,y) popup.Size = UDim2.fromOffset(width,height)
        end
        listen(selector.Activated,function()
            local open = not api._opened closePopups() api._opened = open
            if open then placePopup() popupSearch.Text = "" filterOptions() end
            popup.Visible = open
        end)
        table.insert(window._cleanup,function() for _,connection in ipairs(optionConnections) do connection:Disconnect() end end)
        api:Reload(config.Options)
        api:Set(config.Default,true)
        -- Match the old API: metadata-rich option rows are reachable via Instance.
        api.Popup = popup
        return register(self,api,config)
    end
    function window:AddTab(config)
        local name = config.Title or "Module"
        local tab = {Name = name,_pages = {},_activePage = nil}
        local slot = make("Frame",navigation,{Name = name.."Slot",Size = UDim2.new(1,0,0,51),BackgroundTransparency = 1,LayoutOrder = #self._tabs+1})
        tab.Button = click(slot,{Name = "TabButton",Size = UDim2.fromScale(1,1),BackgroundColor3 = palette.field,BackgroundTransparency = 1})
        tab.Icon = drawIcon(tab.Button,tabIcons[name] or "grid",UDim2.fromOffset(25,5),21,palette.muted)
        tab.Title = text(tab.Button,name,UDim2.fromOffset(0,32),UDim2.new(1,0,0,14),9,palette.muted)
        tab.Title.TextXAlignment = Enum.TextXAlignment.Center
        tab.Indicator = make("Frame",tab.Button,{Position = UDim2.fromOffset(0,10),Size = UDim2.fromOffset(3,31),BorderSizePixel = 0,Visible = false})
        rounded(tab.Indicator,2) accentObject(tab.Indicator,"BackgroundColor3")
        tab.Selector = make("ScrollingFrame",pageSelectors,{Size = UDim2.fromScale(1,1),BackgroundTransparency = 1,BorderSizePixel = 0,
            ScrollBarThickness = 0,AutomaticCanvasSize = Enum.AutomaticSize.X,CanvasSize = UDim2.new(),Visible = false})
        make("UIListLayout",tab.Selector,{FillDirection = Enum.FillDirection.Horizontal,Padding = UDim.new(0,6),SortOrder = Enum.SortOrder.LayoutOrder})
        function tab:SelectPage(target)
            closePopups() self._activePage = target
            for _,page in ipairs(self._pages) do
                local active = page == target
                page.Page.Visible = active and window._selected == self
                page.Button.BackgroundColor3 = active and palette.field or palette.background
                page.Button.TextColor3 = active and accent or palette.muted
                page.Line.Visible = active
            end
        end
        function tab:AddPage(config)
            local page = {ParentTab = self,PageTitle = config.Title or "Controls",_items = {},Columns = {},Cards = {}}
            for name,method in pairs(methods) do page[name] = method end
            page.Button = click(self.Selector,{Text = page.PageTitle,Size = UDim2.fromOffset(math.max(80,#page.PageTitle*6+24),30),LayoutOrder = #self._pages+1,BackgroundColor3 = palette.background})
            page.Line = make("Frame",page.Button,{Position = UDim2.new(0,10,1,-1),Size = UDim2.new(1,-20,0,1),BorderSizePixel = 0})
            accentObject(page.Line,"BackgroundColor3")
            page.Page = make("ScrollingFrame",content,{Name = page.PageTitle.."Page",Size = UDim2.fromScale(1,1),BackgroundTransparency = 1,BorderSizePixel = 0,
                ScrollBarThickness = 3,ScrollBarImageColor3 = palette.line,AutomaticCanvasSize = Enum.AutomaticSize.Y,CanvasSize = UDim2.new(),Visible = false})
            for index = 1,2 do
                local card = make("Frame",page.Page,{Name = "Section"..index,Size = UDim2.new(.5,-7,0,0),Position = UDim2.new((index-1)*.5,(index-1)*7,0,0),
                    AutomaticSize = Enum.AutomaticSize.Y,BackgroundColor3 = palette.card,BackgroundTransparency = .08,BorderSizePixel = 0})
                rounded(card,9) outlined(card,palette.line,.35)
                local cardHeader = click(card,{Name = "SectionHeader",Size = UDim2.new(1,0,0,36),BackgroundTransparency = 1})
                text(cardHeader,index == 1 and page.PageTitle or "Options & status",UDim2.fromOffset(12,4),UDim2.new(1,-48,0,28),12).Font = Enum.Font.GothamMedium
                local mark = text(cardHeader,"−",UDim2.new(1,-42,0,6),UDim2.fromOffset(16,22),14,palette.muted)
                drawIcon(cardHeader,tabIcons[self.Name] or "grid",UDim2.new(1,-23,0,11),14,accent)
                make("Frame",card,{Position = UDim2.fromOffset(10,36),Size = UDim2.new(1,-20,0,1),BackgroundColor3 = palette.line,BackgroundTransparency = .4,BorderSizePixel = 0})
                local column = make("Frame",card,{Name = "Controls",Position = UDim2.fromOffset(0,42),Size = UDim2.new(1,0,0,0),AutomaticSize = Enum.AutomaticSize.Y,BackgroundTransparency = 1})
                make("UIListLayout",column,{Padding = UDim.new(0,2),SortOrder = Enum.SortOrder.LayoutOrder})
                make("UIPadding",column,{PaddingBottom = UDim.new(0,8)})
                local collapsed = false
                listen(cardHeader.Activated,function()
                    collapsed = not collapsed column.Visible = not collapsed mark.Text = collapsed and "+" or "−"
                    card.AutomaticSize = collapsed and Enum.AutomaticSize.None or Enum.AutomaticSize.Y
                    card.Size = UDim2.new(card.Size.X.Scale,card.Size.X.Offset,0,collapsed and 38 or 0)
                end)
                page.Columns[index],page.Cards[index] = column,card
            end
            local function columnsResponsive()
                local narrow = page.Page.AbsoluteSize.X < 470
                page.Cards[1].Size = UDim2.new(narrow and 1 or .5,narrow and -5 or -7,0,page.Cards[1].Size.Y.Offset)
                page.Cards[2].Size = UDim2.new(narrow and 1 or .5,narrow and -5 or -7,0,page.Cards[2].Size.Y.Offset)
                page.Cards[2].Position = narrow and UDim2.fromOffset(0,page.Cards[1].AbsoluteSize.Y/math.max(.01,scale.Scale)+12) or UDim2.new(.5,7,0,0)
            end
            listen(page.Page:GetPropertyChangedSignal("AbsoluteSize"),columnsResponsive)
            listen(page.Cards[1]:GetPropertyChangedSignal("AbsoluteSize"),columnsResponsive)
            task.defer(columnsResponsive)
            listen(page.Button.Activated,function() self:SelectPage(page) end)
            table.insert(self._pages,page)
            if not self._activePage then self:SelectPage(page) end
            return page
        end
        listen(tab.Button.Activated,function() window:SelectTab(tab) end)
        table.insert(self._tabs,tab)
        if not self._selected then self:SelectTab(tab) end
        return tab
    end
    local function responsive()
        closePopups()
        local area = bounds.AbsoluteSize
        -- Reflow at small sizes, retain readable fonts rather than shrinking a desktop view.
        local width = math.clamp(area.X-92,380,860)
        local height = math.clamp(area.Y-28,300,570)
        local compact = width < 600
        header.Size = UDim2.new(1,compact and -305 or -355,0,56)
        searchBox.Position = UDim2.new(1,compact and -196 or -246,0,13)
        searchBox.Size = UDim2.fromOffset(compact and 120 or 170,30)
        frame.Size = UDim2.fromOffset(width,height)
        scale.Scale = math.min(1,(area.X-18)/width,(area.Y-18)/height)
        for _,object in ipairs({frame,launcher}) do
            local p = object.Position
            local point = clampObject(object,Vector2.new(p.X.Scale*area.X+p.X.Offset,p.Y.Scale*area.Y+p.Y.Offset))
            object.Position = UDim2.fromOffset(point.X,point.Y)
        end
    end
    listen(bounds:GetPropertyChangedSignal("AbsoluteSize"),responsive)
    listen(gui.Destroying,function()
        window._alive = false
        for _,cleanup in ipairs(window._cleanup) do cleanup() end
        for _,connection in ipairs(window._connections) do connection:Disconnect() end
        table.clear(window._connections)
    end)
    gui:SetAttribute("Minimized",false)
    task.defer(responsive)
    return window
end
return UI
end)()
if game.GameId~=10765902945 and game.PlaceId~=106198175232796 then return end
local env=getgenv()
if env.DevilHubLegacy then env.DevilHubLegacy.Stop()
elseif env.ItachiLegacy then env.ItachiLegacy.Stop() end
local R={Alive=true,Settings={},Controls={},Errors={},Status={},Jobs={},Connections={},Gates={},Pages={},Version="2026.09.28"}
env.DevilHubLegacy=R
env.ItachiLegacy=R -- Keep old integrations and saved profiles compatible.
local S=R.Settings
local Players=game:GetService("Players")
local Player=Players.LocalPlayer
local Http=game:GetService("HttpService")
local Tags=game:GetService("CollectionService")
local function native(fn,...)
    local id=getthreadidentity and getthreadidentity()
    if setthreadidentity then setthreadidentity(2) end
    local result=table.pack(pcall(fn,...))
    if id and setthreadidentity then setthreadidentity(id) end
    if not result[1] then error(result[2],2) end
    return table.unpack(result,2,result.n)
end
local O=native(require,game:GetService("ReplicatedStorage"):WaitForChild("Omni",30))
local deadline=os.clock()+90
while not O.Data and os.clock()<deadline do task.wait(.2) end
assert(O.Data,"Anime Legacy data has not loaded")
local function fire(system,action,...)
    local args=table.pack(...)
    return native(function() return O.Signal:Fire("General",system,action,table.unpack(args,1,args.n)) end)
end
local function invoke(system,action,...)
    local args=table.pack(...)
    return native(function() return O.Signal:Invoke("General",system,action,table.unpack(args,1,args.n)) end)
end
local function connect(signal,fn)local c=signal:Connect(fn);table.insert(R.Connections,c);return c end
local function state(key,value)R.Status[key]=value end
local function gate(key,seconds)
    if os.clock()<(R.Gates[key] or 0) then return false end
    R.Gates[key]=os.clock()+seconds;return true
end
local function worker(name,delay,fn)
    table.insert(R.Jobs,task.spawn(function()
        while R.Alive do
            local ok,e=pcall(fn)
            if not ok then R.Errors[name]=tostring(e);state(name,tostring(e)) else R.Errors[name]=nil end
            task.wait(delay)
        end
    end))
end
local function owns(map)return native(O.Utils.PlayerStats.OwnsMap,map,O.Data) end
local function root()return Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") end
local function list(t)
    local out={};for k,v in pairs(t or {}) do table.insert(out,{Title=tostring(k),Value=k,Order=type(v)=="table" and v.Index or 0}) end
    table.sort(out,function(a,b)if (a.Order or 0)==(b.Order or 0) then return a.Title<b.Title end return (a.Order or 0)<(b.Order or 0) end);return out
end
local function has(t,v)return table.find(t or {},v)~=nil end
local function module(path)
    local obj=Player.PlayerScripts:WaitForChild("Omni")
    for part in path:gmatch("[^.]+") do obj=assert(obj:FindFirstChild(part),path.." unavailable") end
    return native(require,obj)
end
-- The interface is bundled into devil.lua; no remote UI library is loaded.
local UI=DevilUI
local W=UI:CreateWindow({Title="Devil Hub",Description="Anime Legacy"})
R.Window=W
local UIS=game:GetService("UserInputService")
local entries={}
local function safe(fn)return function(...)local ok,e=pcall(fn,...);if not ok then R.Errors.Interface=tostring(e) end end end
local function tab(title,icon)
    return W:AddTab({Title=title,Icon=icon})
end
local function page(t,title)local p=t:AddPage({Title=title});R.Pages[title]=p;return p end
local function remember(p,key,title,api,default,kind)
    R.Controls[key]={API=api,Default=default,Kind=kind}
    table.insert(entries,{Page=p,Key=key,Title=title});return api
end
local function toggle(p,key,title,col,desc)
    S[key]=false
    return remember(p,key,title,p:AddToggle({Title=title,Description=desc or "",Column=col or 1,Default=false,Callback=function(v)S[key]=v==true end}),false,"boolean")
end
local function dropdown(p,key,title,values,multi,default,col)
    S[key]=default or (multi and {} or nil)
    return remember(p,key,title,p:AddDropdown({Title=title,Column=col or 1,Options=values,Multi=multi,Default=S[key],Callback=function(v)S[key]=v end}),S[key],multi and "table" or "string")
end
local function input(p,key,title,default,col)
    S[key]=default
    return remember(p,key,title,p:AddInput({Title=title,Column=col or 1,Default=default,Callback=function(v)S[key]=v end}),default,"string")
end
local function button(p,title,fn,col) return p:AddButton({Title=title,Column=col or 1,Callback=safe(fn)}) end
local labels={}
local function status(p,key)labels[key]=p:AddParagraph({Title="Status · "..key,Description="Disabled",Column=2}).Description end
local function stopAll()
    for key,c in pairs(R.Controls) do if c.Kind=="boolean" then S[key]=false;c.API:Set(false,true) end end
end
function R.Stop()
    if not R.Alive then return end
    R.Alive=false
    if R.StopNativeAutos then R.StopNativeAutos() end
    if R.StopStarAuto then R.StopStarAuto() end
    if R.RestoreStarPanel then R.RestoreStarPanel() end
    if R.RestoreMovement then R.RestoreMovement() end
    if R.RestoreNick then R.RestoreNick() end
    if R.EndFruitTrip then R.EndFruitTrip() end
    if R.RestoreFruitNotifications then R.RestoreFruitNotifications() end
    if R.RestoreTestingNotice then R.RestoreTestingNotice() end
    if R.RestoreTimeChamberUI then R.RestoreTimeChamberUI() end
    for _,t in ipairs(R.Jobs) do if t~=coroutine.running() then pcall(task.cancel,t) end end
    for _,c in ipairs(R.Connections) do c:Disconnect() end
    if R.Hidden then for gui,enabled in pairs(R.Hidden) do if gui.Parent then gui.Enabled=enabled end end end
    if R.Window then R.Window.Gui:Destroy() end
end
local function priority(p,key,title,options,selectionKey)
    local names={};local order={}
    for _,v in ipairs(options) do names[v.Value]=v.Title;table.insert(order,v.Value) end
    S[key]=order
    local container=p:AddParagraph({Title=title,Description="",Column=2}).Instance
    local frame=Instance.new("Frame",container);frame.BackgroundTransparency=1;frame.Position=UDim2.fromOffset(8,40);frame.Size=UDim2.new(1,-16,0,0)
    local layout=Instance.new("UIListLayout",frame);layout.Padding=UDim.new(0,4)
    local connections={}
    local function draw()
        for _,c in ipairs(connections) do c:Disconnect() end;table.clear(connections)
        for _,v in ipairs(frame:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
        local valid,seen={},{}
        for _,id in ipairs(S[key]) do if names[id] and not seen[id] then table.insert(valid,id);seen[id]=true end end
        for _,id in ipairs(order) do if not seen[id] then table.insert(valid,id) end end
        S[key]=valid
        if selectionKey then
            local selected={};for _,id in ipairs(valid) do if has(S[selectionKey],id) then table.insert(selected,id) end end
            valid=selected
        end
        container.Size=UDim2.new(1,0,0,48+#valid*40);frame.Size=UDim2.new(1,-16,0,#valid*40)
        for i,id in ipairs(valid) do
            local row=Instance.new("Frame",frame);row.Size=UDim2.new(1,0,0,36);row.LayoutOrder=i;row.BackgroundColor3=Color3.fromRGB(28,19,23)
            local text=Instance.new("TextLabel",row);text.Size=UDim2.new(1,-76,1,0);text.BackgroundTransparency=1;text.Text=tostring(i)..". "..names[id];text.TextColor3=Color3.new(1,1,1);text.TextSize=11;text.TextWrapped=true
            for _,direction in ipairs({-1,1}) do
                local b=Instance.new("TextButton",row);b.Size=UDim2.fromOffset(30,30);b.Position=UDim2.new(1,direction==-1 and -68 or -34,0,3);b.Text=direction==-1 and "↑" or "↓";b.TextSize=22;b.TextColor3=Color3.fromRGB(255,35,75);b.BackgroundColor3=Color3.fromRGB(38,25,30)
                table.insert(connections,b.Activated:Connect(function()
                    local j=i+direction
                    if j>=1 and j<=#valid then
                        local a=table.find(S[key],id);local b=table.find(S[key],valid[j])
                        S[key][a],S[key][b]=S[key][b],S[key][a];draw()
                    end
                end))
            end
        end
    end
    R.Controls[key]={Kind="table",Default=table.clone(order),API={Set=function(_,v)S[key]=v;draw()end,Reload=function(_,values)
        names={};order={};for _,v in ipairs(values) do names[v.Value]=v.Title;table.insert(order,v.Value) end;draw()
    end}}
    connect(W.Gui.Destroying,function()for _,c in ipairs(connections) do c:Disconnect()end end)
    draw()
    if selectionKey then
        local previous=""
        worker(key.."View",.2,function()
            local signature=table.concat(S[selectionKey] or {},"|")..":"..table.concat(S[key],"|")
            if signature~=previous then previous=signature;draw() end
        end)
    end
end

local function stationaryAttack() return S.AttackEverything and not S.AutoWorldQuest and not O.Data.Gamemode and not R.ModeJoining and (not R.ModeWinner or R.ModeWinner=="Farm") end
local farm=page(tab("Main"),"World Farm")
dropdown(farm,"World","World",list(O.Shared.Maps.List),false,O.Data.Maps.Current)
local function difficultyOptions()
    local options={}
    for _,difficulty in ipairs({"Easy","Medium","Hard","Insane","Boss","Secret"}) do
        local names={}
        for name,def in pairs(O.Shared.Enemies.List[S.World] or {}) do if def.Difficulty==difficulty then table.insert(names,name) end end
        table.sort(names)
        table.insert(options,{Title=difficulty..(#names>0 and " · "..table.concat(names,", ") or ""),Value=difficulty})
    end
    return options
end
local enemyFilter=dropdown(farm,"Difficulty","Enemy difficulty",difficultyOptions(),true,{"Easy"})
local function enemyPriorityOptions()
    local values={}
    for name,def in pairs(O.Shared.Enemies.List[S.World] or {}) do
        table.insert(values,{Title=name.." · "..tostring(def.Difficulty or ""),Value=name})
    end
    table.sort(values,function(a,b)return a.Title<b.Title end);return values
end
toggle(farm,"PrioritizeEnemies","Use Enemy Priority",2,"Attacks higher-priority living enemies first; falls back when they are unavailable")
priority(farm,"EnemyOrder","Enemy Priority",enemyPriorityOptions())
local function enemyRank(enemy)
    if not S.PrioritizeEnemies or O.Data.Gamemode then return 1 end
    return table.find(S.EnemyOrder or {},enemy:GetAttribute("EnemyName")) or math.huge
end
local difficultyWorld=S.World
worker("Enemy Filter",.3,function()if difficultyWorld~=S.World then difficultyWorld=S.World;enemyFilter:Reload(difficultyOptions());R.Controls.EnemyOrder.API:Reload(enemyPriorityOptions()) end end)
toggle(farm,"Farm","Auto Farm",1,"Moves to selected enemies and sends equipped fighters")
toggle(farm,"AutoWorldQuest","Auto Quest · Current World",1,"Accepts the current world's main quest, farms unfinished targets and claims the reward. Follows your world when you change maps.")
status(farm,"World Quest")
toggle(farm,"AttackEverything","Auto Attack Everything",1,"Keeps your character in place and sends fighters to every living enemy in the current world; mode farming keeps teleport priority")
toggle(farm,"Click","Auto Click",2)
toggle(farm,"Skill","Auto Weapon Skill",2)
toggle(farm,"Fighters","Auto Send Fighters",2)
farm:AddParagraph({Title="Spot / Range",Description="Automatically finds a position covering the largest group within attack range. Keeps the current spot when coverage is equal.",Column=2})
button(farm,"Teleport to Selected World",function()if owns(S.World) then fire("Maps","Teleport",S.World) end end)
local fruitPage=page(tab("Fruits"),"Collect")
toggle(fruitPage,"CollectFruits","Auto Collect Fruits",1,"Visits a fruit world only after a spawn notice, collects, then returns to your previous position")
status(fruitPage,"Fruits")
status(farm,"Farm")
local modesTab=tab("Modes")
for _,spec in ipairs({{"Dungeon","Dungeon Easy","Room"},{"Trial","Trial Easy","Wave"}}) do
    local key,title,unit=spec[1],spec[2],spec[3]
    local p=page(modesTab,title)
    toggle(p,key.."Enter","Auto Enter "..title,1,"Enters only while the server entry window is open")
    toggle(p,key.."Farm","Auto Farm · Spot / Range",1,"Chooses a position covering the most enemies in your session")
    if key=="Dungeon" then p:AddParagraph({Title="Lowest Health First",Description="Targets the enemy with the lowest remaining HP across all rooms, moving directly to that target.",Column=1}) end
    toggle(p,key.."Leave","Auto Leave on "..unit,2)
    input(p,key.."LeaveAt","Leave at "..unit,"10",2)
    p:AddParagraph({Title="Exit condition",Description=key=="Dungeon" and "Leaves after clearing this many rooms." or "Leaves when this wave starts.",Column=2})
    button(p,"Leave Current Mode",function()fire("Gamemodes","Leave")end)
    status(p,key)
end
local modes=page(modesTab,"Culling Game")
do
    local priorities=page(modesTab,"Priorities")
    priority(priorities,"ModeOrder","Activity Priority",{{Title="Dungeon Easy",Value="Dungeon Easy"},{Title="Trial Easy",Value="Trial Easy"},{Title="Culling Game",Value="Culling Game"},{Title="Normal Farm / World Quest",Value="Farm"}})
    priorities:AddParagraph({Title="How priority works",Description="The first enabled and available activity wins. Higher priorities can interrupt a running mode. World Farm includes Auto Quest and Attack Everything. Closed modes or missing tickets are skipped.",Column=1})
    status(priorities,"Mode Priority")
end
toggle(modes,"FarmModes","Auto Farm Culling Game · Spot / Range")
toggle(modes,"CullingLeave","Auto Leave on Wave",1)
input(modes,"CullingLeaveAt","Leave at Wave","10",1)
toggle(modes,"HideGamemodeResult","Hide Game Mode Result",2,"Automatically closes the result screen, like Continue")
status(modes,"Culling")
worker("Hide Gamemode Result",.1,function()
    if not S.HideGamemodeResult then return end
    local frames=O.Interface:FindFirstChild("Frames")
    local result=frames and frames:FindFirstChild("GamemodeResults")
    if result and result.Visible then native(O.Frame.Close,O.Frame,"GamemodeResults") end
end)
button(modes,"Leave Current Mode",function()fire("Gamemodes","Leave")end)
button(modes,"Recall in Current Mode",function()fire("Gamemodes","Recall")end)
button(modes,"Open Culling Game",function()native(O.Scripts.Interface.Gamemodes.Start,"Culling Game")end)
dropdown(modes,"CullingDifficulty","Culling Game Difficulty",{{Title="Easy",Value="Easy"},{Title="Medium",Value="Medium"},{Title="Hard",Value="Hard"}},false,"Easy",2)
toggle(modes,"Culling","Auto Culling Game",2,"Creates your party and spends the required ticket only when starting")
status(modes,"Modes")
local equipmentTab=tab("Equipment")
do
    local p=page(equipmentTab,"Auto Evolve")
    local function options()
        local out={}
        local shared=O.Shared.Accessories
        for id,item in pairs((O.Data.Accessories or {}).List or {}) do
            if shared.GetNextRarity(shared.GetRarity(item)) then
                table.insert(out,{Value=id,Title=item.Name.." · "..shared.GetRarity(item).." · "..tostring(id):sub(-8)})
            end
        end
        table.sort(out,function(a,b)return a.Title<b.Title end)
        return out
    end
    toggle(p,"AutoEvolveAccessories","Auto Evolve + Equip Accessories",1,"Automatically evolves all accessories with enough matching duplicates and equips the highest rarity per slot. Locked and equipped accessories are never consumed.")
    status(p,"Accessory Evolve")
    local pending,retryAt=nil,0
    worker("Accessory Evolve",1,function()
        local data=O.Data.Accessories
        local shared=O.Shared.Accessories
        if not data or not data.List then state("Accessory Evolve","Waiting for inventory");return end
        if pending then
            local item=data.List[pending.ID]
            if item and shared.GetRarity(item)~=pending.Rarity then
                pending=nil;retryAt=os.clock()+1
            elseif os.clock()-pending.At>=10 then
                pending=nil;retryAt=os.clock()+5
                state("Accessory Evolve","No confirmation · waiting before retry");return
            else
                state("Accessory Evolve","Waiting for evolution confirmation");return
            end
        end
        if not S.AutoEvolveAccessories then state("Accessory Evolve","Disabled");return end
        if os.clock()<retryAt then return end
        local equipped={}
        for _,id in pairs(data.Equipped or {}) do equipped[id]=true end
        local targets={}
        for id in pairs(data.List) do table.insert(targets,id) end
        table.sort(targets,function(a,b)
            local rankA=equipped[a] and 2 or data.List[a].Locked and 1 or 0
            local rankB=equipped[b] and 2 or data.List[b].Locked and 1 or 0
            if rankA~=rankB then return rankA>rankB end
            return tostring(a)<tostring(b)
        end)
        local missing,waiting=false,false
        for _,id in ipairs(targets) do
            local target=data.List[id]
            if target then
                local rarity=shared.GetRarity(target)
                if shared.GetNextRarity(rarity) then
                    waiting=true
                    local candidates={}
                    for other,item in pairs(data.List) do
                        if other~=id and not equipped[other] and item.Locked~=true and item.Name==target.Name and shared.GetRarity(item)==rarity then
                            table.insert(candidates,other)
                        end
                    end
                    table.sort(candidates)
                    local nextRarity,cost=shared.GetEvolveResult(rarity,#candidates)
                    if cost and cost>0 then
                        local fuel={}
                        for i=1,cost do fuel[candidates[i]]=true end
                        pending={ID=id,Rarity=rarity,At=os.clock()}
                        state("Accessory Evolve","Evolving "..target.Name.." · "..rarity.." → "..nextRarity)
                        fire("Accessories","Evolve",id,fuel)
                        return
                    end
                end
            else missing=true end
        end
        local best={}
        local function rank(item)
            return native(function()return O.Utils.Order:Rarity(shared.GetRarity(item))end)
        end
        for slot,id in pairs(data.Equipped or {}) do if data.List[id] then best[slot]=id end end
        for _,id in ipairs(targets) do
            local item=data.List[id]
            local definition=shared.List[item.Name]
            local slot=definition and definition.Type
            if slot and (not best[slot] or rank(item)>rank(data.List[best[slot]])) then best[slot]=id end
        end
        for slot,id in pairs(best) do
            if (data.Equipped or {})[slot]~=id and gate("accessory-equip:"..slot,3) then fire("Accessories","Equip",id) end
        end
        state("Accessory Evolve", "Waiting for duplicates · equipping highest rarity per slot")
    end)
end

do
    local best=page(equipmentTab,"Equip Best")
    toggle(best,"EquipBestPets","Auto Equip Best Pets",1,"Uses the game's Equip Best for fighters every 5 seconds. Takes priority over saved mode teams while enabled.")
    status(best,"Equip Best Pets")
    worker("Equip Best Pets",1,function()
        if not S.EquipBestPets then state("Equip Best Pets","Disabled");return end
        if gate("equip-best-pets",5) then fire("Fighters","EquipBest") end
        state("Equip Best Pets","Keeping the best fighters equipped · native selection")
    end)
end
local teams=page(equipmentTab,"Equip Team on Gamemode")
local teamContexts={{"World","World"},{"Dungeon Easy","Dungeon"},{"Trial Easy","Trial"},{"Culling Game","Culling"}}
local function savedTeams()
    local options={{Title="None",Value="None"}}
    for index,team in pairs(O.Data.Fighters.Teams or {}) do
        if type(team)=="table" and next(team) then table.insert(options,{Title="Team #"..index,Value=tostring(index)}) end
    end
    table.sort(options,function(a,b)return (tonumber(a.Value) or -1)<(tonumber(b.Value) or -1) end)
    return options
end
for _,context in ipairs(teamContexts) do dropdown(teams,"ModeTeam"..context[2],context[1],savedTeams(),false,"None") end
toggle(teams,"ModeTeams","Equip Team on Gamemode",1,"Loads a saved game team when entering World or a mode")
button(teams,"Refresh Saved Teams",function()for _,c in ipairs(teamContexts) do R.Controls["ModeTeam"..c[2]].API:Reload(savedTeams()) end end)
status(teams,"Mode Teams")
local lastTeamContext
worker("Mode Teams",.5,function()
    if not S.ModeTeams then lastTeamContext=nil;state("Mode Teams","Disabled");return end
    if S.EquipBestPets then lastTeamContext=nil;state("Mode Teams","Paused for Auto Equip Best Pets");return end
    local mode=O.Data.Gamemode or "World";local key
    for _,c in ipairs(teamContexts) do if c[1]==mode then key=c[2] end end
    local slot=key and tonumber(S["ModeTeam"..key])
    if not slot then lastTeamContext=nil;state("Mode Teams",mode.." · no team selected");return end
    local team=O.Data.Fighters.Teams[slot]
    if not team or not next(team) then lastTeamContext=nil;state("Mode Teams","Saved team is empty or missing");return end
    local token=mode..":"..tostring(O.Data.GamemodeSession)..":"..slot
    if token~=lastTeamContext then
        fire("Fighters","LoadTeam",slot);lastTeamContext=token
        state("Mode Teams",mode.." · Team #"..slot.." requested")
    end
end)
local playerPage=page(tab("Player"),"Movement")
local function movementSlider(key,title,default,minimum,maximum)
    S[key]=tostring(default)
    local api=playerPage:AddSlider({Title=title,Column=1,Min=minimum,Max=maximum,Default=default,Increment=1,Callback=function(value)S[key]=tostring(value)end})
    api.ValueBox.TextEditable=false
    api.ValueBox.Active=false
    api.Title.Position=UDim2.fromOffset(12,5)
    api.Title.Size=UDim2.new(1,-100,0,20)
    api.ValueBox.Parent.Position=UDim2.new(1,-78,0,3)
    api.Track.Position=UDim2.new(0,16,0,30)
    api.Track.Size=UDim2.new(1,-32,0,24)
    remember(playerPage,key,title,api,tostring(default),"string")
end
movementSlider("PlayerSpeed","Player Speed",32,0,300)
toggle(playerPage,"CustomSpeed","Enable Player Speed")
movementSlider("PlayerJump","Jump Height",15,0,200)
toggle(playerPage,"CustomJump","Enable Jump Height")
movementSlider("FlySpeed","Fly Speed",60,1,300)
toggle(playerPage,"Fly","Fly",2,"WASD to move · Space up · Left Shift down")
local movementHumanoid,movementDefaults,flightRoot,flightAttachment,flightVelocity,flightOrientation
local function stopFlight()
    if flightVelocity then flightVelocity:Destroy();flightVelocity=nil end
    if flightOrientation then flightOrientation:Destroy();flightOrientation=nil end
    if flightAttachment then flightAttachment:Destroy();flightAttachment=nil end
    if flightRoot and flightRoot.Parent then flightRoot.AssemblyLinearVelocity=Vector3.zero end
    flightRoot=nil
    if movementHumanoid and movementHumanoid.Parent and movementDefaults then
        movementHumanoid.AutoRotate=movementDefaults.AutoRotate
        movementHumanoid.PlatformStand=movementDefaults.PlatformStand
    end
end
local function restoreMovement()
    stopFlight()
    if movementHumanoid and movementHumanoid.Parent and movementDefaults then
        movementHumanoid.WalkSpeed=movementDefaults.WalkSpeed
        movementHumanoid.JumpHeight=movementDefaults.JumpHeight
        movementHumanoid.JumpPower=movementDefaults.JumpPower
    end
end
R.RestoreMovement=restoreMovement
connect(game:GetService("RunService").Heartbeat,function()
    local character=Player.Character
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    local hrp=character and character:FindFirstChild("HumanoidRootPart")
    if humanoid~=movementHumanoid then
        restoreMovement();movementHumanoid=humanoid
        movementDefaults=humanoid and {WalkSpeed=humanoid.WalkSpeed,JumpHeight=humanoid.JumpHeight,JumpPower=humanoid.JumpPower,AutoRotate=humanoid.AutoRotate,PlatformStand=humanoid.PlatformStand}
    end
    if not humanoid or not hrp or humanoid.Health<=0 then stopFlight();return end
    if S.CustomSpeed then humanoid.WalkSpeed=math.clamp(tonumber(S.PlayerSpeed) or 32,0,300)
    elseif R.SpeedApplied then humanoid.WalkSpeed=movementDefaults.WalkSpeed end
    R.SpeedApplied=S.CustomSpeed
    if S.CustomJump then
        local height=math.clamp(tonumber(S.PlayerJump) or 15,0,300)
        humanoid.JumpHeight=height;humanoid.JumpPower=math.sqrt(2*workspace.Gravity*height)
    elseif R.JumpApplied then humanoid.JumpHeight=movementDefaults.JumpHeight;humanoid.JumpPower=movementDefaults.JumpPower end
    R.JumpApplied=S.CustomJump
    if not S.Fly then if flightRoot then stopFlight() end;return end
    if flightRoot~=hrp then
        stopFlight();flightRoot=hrp
        flightAttachment=Instance.new("Attachment",hrp)
        flightVelocity=Instance.new("LinearVelocity",hrp);flightVelocity.Attachment0=flightAttachment;flightVelocity.RelativeTo=Enum.ActuatorRelativeTo.World;flightVelocity.MaxForce=math.huge
        flightOrientation=Instance.new("AlignOrientation",hrp);flightOrientation.Attachment0=flightAttachment;flightOrientation.Mode=Enum.OrientationAlignmentMode.OneAttachment;flightOrientation.MaxTorque=math.huge;flightOrientation.Responsiveness=25
    end
    humanoid.PlatformStand=true;humanoid.AutoRotate=false
    local camera=workspace.CurrentCamera;if not camera then return end
    local direction=Vector3.zero
    if not UIS:GetFocusedTextBox() then
        if UIS:IsKeyDown(Enum.KeyCode.W) then direction=direction+camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then direction=direction-camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then direction=direction+camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then direction=direction-camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then direction=direction+Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then direction=direction-Vector3.yAxis end
    end
    flightVelocity.VectorVelocity=direction.Magnitude>0 and direction.Unit*math.clamp(tonumber(S.FlySpeed) or 60,1,300) or Vector3.zero
    flightOrientation.CFrame=camera.CFrame.Rotation
end)

local deconstructPage=page(equipmentTab,"Deconstruct")
local deconstructOptions={}
local rarityNames={};local raritySeen={}
for _,name in ipairs({"Common","Uncommon","Rare","Epic","Legendary","Mythical","Secret"}) do table.insert(rarityNames,name);raritySeen[name]=true end
for _,def in pairs(O.Shared.Fighters.List) do
    if def.Rarity and not raritySeen[def.Rarity] then raritySeen[def.Rarity]=true;table.insert(rarityNames,def.Rarity) end
end
for _,name in ipairs(rarityNames) do
    table.insert(deconstructOptions,{Title=name,Value=name.."|Normal"})
    table.insert(deconstructOptions,{Title=name.." Shiny",Value=name.."|Shiny"})
end
dropdown(deconstructPage,"DeconstructRarities","Selected Rarities",deconstructOptions,true,{})
toggle(deconstructPage,"AutoDeconstruct","Auto Deconstruct",1,"Converts selected rarities regardless of trait or weather. Locked and equipped fighters are kept.")
status(deconstructPage,"Deconstruct")
local function deconstructCandidates()
    local selected={};local count=0
    for uid,fighter in pairs(O.Data.Fighters.List) do
        local def=O.Shared.Fighters.List[fighter.Name]
        local key=def and def.Rarity and (def.Rarity..(fighter.Shiny and "|Shiny" or "|Normal"))
        if key and has(S.DeconstructRarities,key) and not fighter.Locked and not O.Data.Fighters.Equipped[uid]
            and not has(S.FeedCharacters or {},uid)
            and native(O.Shared.FighterFeed.GetDeconstructReward,fighter) then
            selected[uid]=true;count=count+1
            if count>=50 then break end
        end
    end
    return selected,count
end
local deconstructRequest
worker("Deconstruct",.2,function()
    if deconstructRequest then
        local request=deconstructRequest
        local remaining=0
        for uid in pairs(request.Selected) do if O.Data.Fighters.List[uid] then remaining=remaining+1 end end
        if remaining==0 or os.clock()-request.At>=5 then
            if request.Thread then pcall(task.cancel,request.Thread) end
            deconstructRequest=nil
            R.DeconstructRetryAt=os.clock()+(remaining==0 and .1 or 1)
            state("Deconstruct",remaining==0 and "Batch confirmed · checking inventory" or "Response timed out · refreshing inventory")
        else return end
    end
    if not S.AutoDeconstruct then state("Deconstruct","Disabled");return end
    if #S.DeconstructRarities==0 then state("Deconstruct","Select rarities to deconstruct");return end
    if os.clock()<(R.DeconstructRetryAt or 0) then return end
    local selected,count=deconstructCandidates()
    if count==0 then state("Deconstruct","Waiting for matching fighters");return end
    state("Deconstruct","Deconstructing "..count.." fighters")
    local request={At=os.clock(),Selected=selected};deconstructRequest=request
    request.Thread=task.defer(function()
        local ok,result=pcall(invoke,"Fighters","Deconstruct",selected)
        if deconstructRequest~=request or not R.Alive then return end
        if not ok or not result then
            deconstructRequest=nil;R.DeconstructRetryAt=os.clock()+1
            state("Deconstruct","Request rejected · refreshing and retrying")
        else
            state("Deconstruct","Waiting for inventory confirmation · "..count)
        end
    end)
    table.insert(R.Jobs,request.Thread)
end)
local gachaTab=tab("Gacha")
local stars=page(gachaTab,"Stars")
local function animationToggle(p,key,title,nativeKey)
    local initial=O.Data.Settings[nativeKey]==true
    S[key]=initial
    remember(p,key,title,p:AddToggle({Title=title,Column=2,Default=initial,Callback=safe(function(value)
        S[key]=value==true
        fire("Settings","Set",nativeKey,S[key])
    end)}),initial,"boolean")
end
animationToggle(stars,"HideStarRoll","Hide Star Roll UI","Hide Star Animation")
toggle(stars,"HideStarPanel","Hide Star Panel",2,"Hides the star selection panel only while this option is enabled")
dropdown(stars,"Star","Star",list(O.Shared.Stars.List),false,O.Data.Maps.Current)
toggle(stars,"OpenStars","Auto Open Stars",1,"Uses the game's rolling controller and inventory checks")
status(stars,"Stars")
local gacha=page(gachaTab,"Systems")
animationToggle(gacha,"HideGachaRoll","Hide Gacha Roll UI","Hide Gacha Animation")
toggle(gacha,"HideGachaPanel","Hide Gacha Panel",2,"Hides the gacha panel only while this option is enabled")
dropdown(gacha,"Gachas","Selected Gachas",list(O.Shared.Gacha.List),true,{"Haki"})
priority(gacha,"GachaOrder","Gacha Priority",list(O.Shared.Gacha.List))
toggle(gacha,"RollGacha","Auto Roll Gacha")
status(gacha,"Gacha")
local auto=tab("Auto")
local progress=page(auto,"Progression")
dropdown(progress,"Progressions","Selected Progressions",list(O.Shared.Progression.List),true,{})
toggle(progress,"Progress","Auto Upgrade Progression",1,"Attempts only when the native controller confirms access and balance")
status(progress,"Progression")
local upgrades=page(auto,"Upgrades")
local upgradeOptions={}
for system,def in pairs(O.Shared.Upgrade.List) do for key in pairs(def.Upgrades or {}) do table.insert(upgradeOptions,{Title=system.." · "..key,Value=system.."|"..key}) end end
table.sort(upgradeOptions,function(a,b)return a.Title<b.Title end)
dropdown(upgrades,"Upgrades","Selected Upgrades",upgradeOptions,true,{})
toggle(upgrades,"Upgrade","Auto Buy Upgrades")
priority(upgrades,"UpgradeOrder","Upgrade Priority",upgradeOptions)
status(upgrades,"Upgrades")
local rewards=page(auto,"Rewards")
do
    local questsPage=page(auto,"Side Quests")
    toggle(questsPage,"CollectSideQuests","Auto Accept Side Quests",1,"Accepts available side quests from unlocked maps. Does not teleport, farm objectives or claim rewards.")
    toggle(questsPage,"CollectSecretQuests","Auto Collect Secret Quests",1,"Accepts each island's secret quest when unlocked. Does not farm or claim its rewards.")
    status(questsPage,"Side Quests")
    worker("Side Quests",3,function()
        if not S.CollectSideQuests and not S.CollectSecretQuests then state("Side Quests","Disabled");return end
        local category=O.Shared.Quests.List.Side
        local collected=0
        for name,def in pairs(category and category.List or {}) do
            local map=def.MapName or def.Map
            local accessible=type(map)=="string" and owns(map) or false
            if not map then
                for _,mission in ipairs(def.Missions or {}) do
                    if mission.Type=="Kill" and mission.Name then
                        for area,enemies in pairs(O.Shared.Enemies.List) do
                            if enemies[mission.Name] and owns(area) then accessible=true;break end
                        end
                    end
                    if accessible then break end
                end
            end
            if accessible and native(O.Shared.Quests.CanCollectQuest,name,"Side",O.Data) then
                if gate("sidequest:collect:"..name,10) then
                    fire("Quests","Collect","Side",name)
                    collected=collected+1
                end
            end
        end
        state("Side Quests",collected>0 and ("Accepting "..collected.." side quests") or "Waiting for new available side quests")
    end)
end
local codesPage=page(auto,"Codes")
local redeemCodes={}
toggle(codesPage,"AutoCodes","Auto Redeem All Codes",1,"Waiting for the game's code system to become available")
status(codesPage,"Codes")
worker("Codes",5,function()
    if not S.AutoCodes then state("Codes","Disabled");return end
    state("Codes",#redeemCodes==0 and "No released codes configured · redemption system unavailable in this build" or "Codes queued · waiting for verified game redemption integration")
end)
for _,x in ipairs({{"Achievements","Auto Claim Achievements"},{"Quests","Auto Claim Quests"},{"Inbox","Auto Claim Inbox"},{"TimeRewards","Auto Collect Time Rewards"},{"DailyRewards","Auto Collect Daily Rewards"}}) do toggle(rewards,x[1],x[2]) end
status(rewards,"Rewards")
toggle(rewards,"TimeChamberRewards","Auto Claim Time Chamber Rewards",1,"Claims unlocked timed rewards using your recorded chamber time")
do
    local hidden=false
    local controller
    local originalRefresh
    local wrappedRefresh
    local function applyHidden()
        local gui=Player.PlayerGui:FindFirstChild("TimeChamber")
        if gui then gui.Enabled=false end
        native(O.Frame.RemoveFramesHider,O.Frame,"TimeChamber")
        native(O.Frame.RefreshHUD,O.Frame)
    end
    R.RestoreTimeChamberUI=function()
        if not hidden then return end
        hidden=false
        if controller and controller.RefreshVisibility==wrappedRefresh then controller.RefreshVisibility=originalRefresh end
        if originalRefresh then native(originalRefresh) end
    end
    toggle(rewards,"HideTimeChamberUI","Hide Time Chamber UI",2,"Hides the chamber overlay and restores the HUD. Does not change access or movement restrictions.",function()
        if not S.HideTimeChamberUI then R.RestoreTimeChamberUI() end
    end)
    worker("Time Chamber UI",.25,function()
        if not S.HideTimeChamberUI then R.RestoreTimeChamberUI();return end
        if not hidden then
            controller=module("Scripts.Interface.TimeChamber")
            originalRefresh=controller.RefreshVisibility
            assert(type(originalRefresh)=="function","Time Chamber visibility controller unavailable")
            wrappedRefresh=function(...)
                originalRefresh(...)
                if R.Alive and S.HideTimeChamberUI then applyHidden() end
            end
            controller.RefreshVisibility=wrappedRefresh
            hidden=true
        end
        applyHidden()
    end)
end
status(rewards,"Time Chamber")
worker("Time Chamber",2,function()
    if not S.TimeChamberRewards then state("Time Chamber","Disabled");return end
    local data=O.Data.TimeChamber
    local definition=O.Shared.TimeChamber
    if not data or not definition then state("Time Chamber","Waiting for chamber data");return end
    local claimed=data.Claimed or {}
    local elapsed=tonumber(data.Time) or 0
    local remaining,requested=0,0
    for index,reward in ipairs(definition.Confirmed or {}) do
        if claimed[tostring(index)]~=true then
            remaining=remaining+1
            if elapsed>=(tonumber(reward.Time) or math.huge) and gate("timechamber:claim:"..index,5) then
                fire("TimeChamber","Claim",index);requested=requested+1
            end
        end
    end
    state("Time Chamber",requested>0 and ("Claiming "..requested.." available rewards") or remaining==0 and "All timed rewards claimed" or "Waiting for reward timers")
end)
toggle(rewards,"IndexRewards","Auto Index Rewards",1,"Claims unlocked Fighter, Accessory and Weapon index rewards")
toggle(rewards,"LevelRewards","Auto Level Rewards",1,"Claims rewards for levels you have reached")
local statsPage=page(auto,"Stats")
dropdown(statsPage,"StatTarget","Stat to upgrade",list(O.Shared.PlayerLevel.List.Stats),false,nil,1)
toggle(statsPage,"AutoStats","Auto Stats",1,"Spends available points on the selected stat; does not reset existing points")
status(statsPage,"Stats")
local potionsTab=tab("Potions")
local boosts=page(potionsTab,"Auto Use")
dropdown(boosts,"Potions","Selected Potions",list(O.Shared.Potions.List),true,{})
toggle(boosts,"Boosts","Auto Use Potions",1,"Continuously consumes all selected potions in stock, even with active effects; respects mode rules")
toggle(boosts,"PotionRules","Manage Potion Pause by Mode",1,"Selected Active Potions run in each mode; other active timers are paused")
for _,spec in ipairs({{"World","World"},{"Dungeon","Dungeon Easy"},{"Trial","Trial Easy"},{"Culling","Culling Game"}}) do
    local p=page(potionsTab,spec[2])
    dropdown(p,"ActivePotions"..spec[1],"Active Potions",list(O.Shared.Potions.List),true,{})
end
status(boosts,"Boosts")
local traitsTab=tab("Traits")
local traitPage=page(traitsTab,"Auto Roll")
local function fighterOptions()
    local options={}
    for uid,fighter in pairs(O.Data.Fighters.List) do
        table.insert(options,{Value=uid,Title=tostring(fighter.Name)..(fighter.Shiny and " [Shiny]" or "").." · Lv "..tostring(fighter.Level or 1).." · "..uid:sub(-8)})
    end
    table.sort(options,function(a,b)return a.Title<b.Title end)
    return options
end
do
    local feedPage=page(equipmentTab,"Auto Feed")
    dropdown(feedPage,"FeedCharacters","Selected Characters",fighterOptions(),true,{})
    priority(feedPage,"FeedOrder","Character Priority",fighterOptions(),"FeedCharacters")
    input(feedPage,"FeedLevel","Level Wanted","50")
    toggle(feedPage,"AutoFeed","Auto Feed",1,"Feeds selected characters in priority order until Level Wanted. Waits when food runs out.")
    button(feedPage,"Refresh Characters",function()
        local options=fighterOptions()
        R.Controls.FeedCharacters.API:Reload(options)
        R.Controls.FeedOrder.API:Reload(options)
    end)
    status(feedPage,"Feed")
    local function feedPlan(fighter,wanted)
        local shared=O.Shared.Fighters
        local target=math.min(wanted,shared.GetFighterMaxLevel(fighter,O.Data))
        if (fighter.Level or 1)>=target then return {},target end
        local remaining=-(fighter.Exp or 0)
        for level=(fighter.Level or 1)+1,target do
            local cost=shared.GetNeededExpForLevel(level,fighter,O.Data)
            if not cost or cost<=0 then return nil,target end
            remaining=remaining+cost
        end
        local gain=shared.GetFighterExpGain(fighter,O.Data)
        if not gain or gain<=0 or gain==math.huge or gain~=gain then return nil,target end
        local foods={}
        for _,name in ipairs(O.Shared.FighterFeed.GetFoods()) do
            if remaining<=0 then break end
            local amount=O.Shared.FighterFeed.GetAvailableAmount(name,O.Data)
            local exp=O.Shared.Items.List[name].FeedExp*gain
            if amount>0 and exp>0 then
                local count=math.min(amount,math.ceil(remaining/exp))
                foods[name]=count;remaining=remaining-count*exp
            end
        end
        return foods,target
    end
    local pending,retryAt=nil,0
    worker("Feed",.5,function()
        if pending then
            local fighter=O.Data.Fighters.List[pending.ID]
            local changed=not fighter or fighter.Level~=pending.Level or fighter.Exp~=pending.Exp
            if changed or os.clock()-pending.At>=8 or not S.AutoFeed then
                if pending.Thread then pcall(task.cancel,pending.Thread) end
                retryAt=os.clock()+(changed and .3 or 2);pending=nil
            else state("Feed","Waiting for feed confirmation");return end
        end
        if not S.AutoFeed then state("Feed","Disabled");return end
        local wanted=tonumber(S.FeedLevel)
        if not wanted or wanted~=wanted or wanted==math.huge or wanted<1 then state("Feed","Enter a valid Level Wanted");return end
        wanted=math.floor(wanted)
        if #S.FeedCharacters==0 then state("Feed","Select characters to feed");return end
        if os.clock()<retryAt then return end
        local order,seen={},{}
        for _,id in ipairs(S.FeedOrder) do if has(S.FeedCharacters,id) and not seen[id] then table.insert(order,id);seen[id]=true end end
        for _,id in ipairs(S.FeedCharacters) do if not seen[id] then table.insert(order,id);seen[id]=true end end
        local missing=false
        for _,id in ipairs(order) do
            local fighter=O.Data.Fighters.List[id]
            if fighter then
                local foods,target=native(feedPlan,fighter,wanted)
                if (fighter.Level or 1)<target then
                    if not foods then state("Feed","Unable to calculate food for "..fighter.Name);return end
                    if not next(foods) then state("Feed","Waiting for food · "..fighter.Name.." → Lv "..target);return end
                    local request={ID=id,Level=fighter.Level,Exp=fighter.Exp,At=os.clock()};pending=request
                    state("Feed","Feeding "..fighter.Name.." → Lv "..target)
                    request.Thread=task.defer(function()
                        if not R.Alive or not S.AutoFeed or pending~=request then return end
                        local ok,result=pcall(invoke,"Fighters","Feed",id,foods)
                        if pending~=request or not R.Alive then return end
                        if not ok or not result then
                            pending=nil;retryAt=os.clock()+2
                            state("Feed","Feed rejected · retrying after inventory refresh")
                        end
                    end)
                    table.insert(R.Jobs,request.Thread)
                    return
                end
            else missing=true end
        end
        if missing then state("Feed","Selected character missing · refresh selection");return end
        S.AutoFeed=false;R.Controls.AutoFeed.API:Set(false,true)
        state("Feed","Complete · all selected characters reached target or level cap")
    end)
end
local fighters=fighterOptions()
dropdown(traitPage,"TraitCharacters","Selected Characters",fighters,true,{})
priority(traitPage,"TraitOrder","Character Priority",fighters,"TraitCharacters")
local traitOptions={}
local descriptions={}
local traitRarityOrder={Common=1,Uncommon=2,Rare=3,Epic=4,Legendary=5,Mythical=6,Mythic=6,Secret=7,Exclusive=8}
for name,info in pairs(O.Shared.Traits.List) do
    if type(info)=="table" and (info.Chance or 0)>0 then
        local effects={}
        for _,group in ipairs({"Attributes","Perks"}) do
            for stat,bonus in pairs(info[group] or {}) do
                if type(bonus)=="table" and tonumber(bonus.Amount) then
                    table.insert(effects,stat.." "..(bonus.Type=="Multi" and string.format("x%.3g",bonus.Amount) or string.format("%+.1f%%",bonus.Amount*100)))
                end
            end
        end
        table.sort(effects)
        descriptions[name]=#effects>0 and table.concat(effects," · ") or tostring(info.Description or "No stat bonus listed")
        local rarity=tostring(info.Rarity or "Common")
        table.insert(traitOptions,{Title=name.." ("..rarity..")",Description=descriptions[name],Value=name,RarityOrder=traitRarityOrder[rarity] or 99})
    end
end
table.sort(traitOptions,function(a,b)
    if a.RarityOrder~=b.RarityOrder then return a.RarityOrder<b.RarityOrder end
    return a.Value<b.Value
end)
local traitFilter=dropdown(traitPage,"TraitStops","Stop on Traits",traitOptions,true,{})
for _,desc in ipairs(traitFilter.Instance:GetDescendants()) do
    if desc:IsA("TextLabel") and desc.Name=="Description" and desc.Parent:FindFirstChild("Check") then
        desc.TextWrapped=true;desc.TextTruncate=Enum.TextTruncate.None;desc.TextYAlignment=Enum.TextYAlignment.Top
        desc.TextColor3=Color3.fromRGB(160,160,168)
        local function resize()
            local width=math.max(80,desc.AbsoluteSize.X)
            local height=game:GetService("TextService"):GetTextSize(desc.Text,desc.TextSize,desc.Font,Vector2.new(width,1000)).Y
            desc.Size=UDim2.new(1,-45,0,height+2)
            desc.Parent.Size=UDim2.new(1,-3,0,math.max(42,height+28))
        end
        connect(desc:GetPropertyChangedSignal("AbsoluteSize"),resize);resize()
    end
end
toggle(traitPage,"AutoTraits","Auto Roll Traits",1,"Alternates rolls with Breathing and Gacha; keeps matching traits and advances through selected characters")
toggle(traitPage,"HideTraitPanel","Hide Trait Panel",1,"Hides the native Traits panel without stopping rolls; restores it when disabled")
status(traitPage,"Traits")
local traitIndex=page(traitsTab,"Trait Effects")
for _,option in ipairs(traitOptions) do traitIndex:AddParagraph({Title=option.Title,Description=descriptions[option.Value],Column=1}) end
button(traitPage,"Refresh Characters",function()
    local options=fighterOptions()
    R.Controls.TraitCharacters.API:Reload(options)
    local known={};for _,uid in ipairs(S.TraitOrder) do known[uid]=true end
    for _,v in ipairs(options) do if not known[v.Value] then table.insert(S.TraitOrder,v.Value) end end
    R.Controls.TraitOrder.API:Reload(options)
end)
local configTab=tab("Config")
local activityPage=page(configTab,"Roll Rotation")
activityPage:AddParagraph({Title="Automatic rotation",Description="Traits → Breathing → Gacha: one confirmed roll per turn among enabled systems with resources. Stars runs independently.",Column=1})
status(activityPage,"Rotation")
R.ActivityReady={}
local activitySettings={Traits="AutoTraits",Breathing="AutoBreathing",Gacha="RollGacha"}
local rollOrder={"Traits","Breathing","Gacha"}
local rollCursor,rollPending=0,nil
local function cancelNativeAuto(name)
    if R[name.."AutoOwned"] then
        local controller=name=="Gacha" and module("Scripts.Interface.Gacha.Default") or O.Scripts.Interface[name=="Traits" and "Traits" or "Breathings"]
        native(controller.CancelAuto)
        R[name.."AutoOwned"]=false
    end
end
R.StopNativeAutos=function()cancelNativeAuto("Traits");cancelNativeAuto("Breathing");cancelNativeAuto("Gacha")end
function R.SoloRoll(name)
    for other,setting in pairs(activitySettings) do
        if other~=name and S[setting] and (R.ActivityReady[other] or 0)>os.clock() then return false end
    end
    return true
end
local function finishRollTurn(name)
    for index,key in ipairs(rollOrder) do if key==name then rollCursor=index;break end end
    R.ActiveActivity=nil
    R.ActivityStartedAt=nil
end
local function activity(name,ready)
    if not activitySettings[name] then return ready end
    R.ActivityReady[name]=ready and os.clock()+7 or nil
    for other in pairs(activitySettings) do
        if R[other.."AutoOwned"] and (not S[activitySettings[other]] or not R.SoloRoll(other) or other==name and not ready) then cancelNativeAuto(other) end
    end
    if rollPending then
        local pending=rollPending
        if pending.Read()~=pending.Before then
            pending.Confirmed=true
            pending.ReadyAt=pending.ReadyAt or os.clock()+pending.Cooldown
        end
        if pending.Confirmed and os.clock()>=pending.ReadyAt or os.clock()>=pending.Deadline then
            if not pending.Confirmed then R.Errors.RollRotation="No confirmation from "..pending.Name.."; retrying on its next turn" else R.Errors.RollRotation=nil end
            finishRollTurn(pending.Name);rollPending=nil
        else
            state("Rotation",pending.Name.." · waiting for roll result / animation")
            return false
        end
    end
    local winner=R.ActiveActivity
    if winner and os.clock()-(R.ActivityStartedAt or os.clock())>=5 then
        finishRollTurn(winner);winner=nil
    end
    if winner and (not S[activitySettings[winner]] or (R.ActivityReady[winner] or 0)<=os.clock()) then winner=nil end
    if not winner then
        for offset=1,#rollOrder do
            local key=rollOrder[(rollCursor+offset-1)%#rollOrder+1]
            if S[activitySettings[key]] and (R.ActivityReady[key] or 0)>os.clock() then winner=key;break end
        end
    end
    if winner~=R.ActiveActivity then R.ActivityStartedAt=winner and os.clock() or nil end
    R.ActiveActivity=winner
    state("Rotation",winner and ("Next roll: "..winner) or "Waiting for enabled systems with resources")
    return winner==name
end
local function priorityWait()
    return "Waiting for turn · "..tostring(R.ActiveActivity or "rotation")
end
local function rollOnce(name,controller,price,cooldown,readResult)
    local function snapshot()
        local balance=native(O.Shared.Economy.GetBalance,O.Data,price)
        return tostring(balance and balance.Total).."|"..tostring(readResult())
    end
    if R.SoloRoll(name) and type(controller.StartAuto)=="function" then
        R.NativeRollProgress=R.NativeRollProgress or {}
        local current=snapshot()
        local previous=R.NativeRollProgress[name]
        if not previous or previous.Value~=current then
            R.NativeRollProgress[name]={Value=current,At=os.clock()}
        elseif os.clock()-previous.At>=math.max(8,cooldown+5) then
            cancelNativeAuto(name);R.NativeRollProgress[name]=nil
        end
        if not R[name.."AutoOwned"] then
            native(controller.CancelAuto);native(controller.StartAuto);R[name.."AutoOwned"]=true
        end
        return
    end
    cancelNativeAuto(name)
    native(controller.CancelAuto)
    local pending={Name=name,Read=snapshot,Before=snapshot(),Cooldown=math.max(.2,cooldown)+.3,Deadline=os.clock()+math.max(12,cooldown+8)}
    rollPending=pending
    local ok,err=pcall(native,controller.Roll)
    if not ok then rollPending=nil;finishRollTurn(name);error(err) end
end
local function syncStops(system,selected)
    local synced=true
    local data=O.Data[system] and O.Data[system].AutoStop or {}
    for name,def in pairs(O.Shared[system].List) do
        if system=="Traits" then
            local wanted=has(selected,name)
            if (data[name]==true)~=wanted then
                synced=false
                if gate("stop:"..system..name,1) then fire(system,"SetAutoStop",name,wanted) end
            end
        else
            for rarity in pairs(def.Rarities) do
                local wanted=has(selected,name.."|"..rarity)
                if ((data[name] or {})[rarity]==true)~=wanted then
                    synced=false
                    if gate("stop:"..system..name..rarity,1) then fire(system,"SetAutoStop",name,rarity,wanted) end
                end
            end
        end
    end
    return synced
end
local function stopTraits(message)
    cancelNativeAuto("Traits");activity("Traits",false)
    S.AutoTraits=false;R.Controls.AutoTraits.API:Set(false,true);state("Traits",message)
end
worker("Traits",.2,function()
    if not S.AutoTraits then cancelNativeAuto("Traits");activity("Traits",false);R.TraitCharacter=nil;R.TraitAutoProgress=nil;return end
    local solo=R.SoloRoll("Traits")
    if not solo then cancelNativeAuto("Traits");R.TraitAutoProgress=nil end
    if #S.TraitStops==0 then stopTraits("Select at least one target trait");return end
    local target,missing
    for _,uid in ipairs(S.TraitOrder) do if has(S.TraitCharacters,uid) then
        local fighter=O.Data.Fighters.List[uid]
        if fighter then
            local info=native(O.Shared.Traits.Get,fighter)
            if not info or not has(S.TraitStops,info.Name) then target=uid;break end
        else missing=true end
    end end
    if not target then
        if missing then cancelNativeAuto("Traits");activity("Traits",false);state("Traits","Selected character missing · refresh selection")
        else stopTraits("Queue complete · all selected characters match the filter") end
        return
    end
    local canPay=native(O.Shared.Economy.CanSpendRandom,O.Data,O.Shared.Traits.Price,native(O.Shared.MonetizationPolicy.FromPlayer,Player))
    if not canPay then cancelNativeAuto("Traits");R.TraitAutoProgress=nil end
    if not activity("Traits",canPay) then state("Traits",canPay and priorityWait() or "Waiting for tokens");return end
    if not syncStops("Traits",S.TraitStops) then cancelNativeAuto("Traits");state("Traits","Synchronizing native stop filter");return end
    local controller=O.Scripts.Interface.Traits
    if R.TraitCharacter~=target then
        cancelNativeAuto("Traits");R.TraitAutoProgress=nil;native(controller.CancelAuto);native(controller.Start);native(controller.SelectFighter,target);R.TraitCharacter=target
        return
    end
    if solo then
        local balance=native(O.Shared.Economy.GetBalance,O.Data,O.Shared.Traits.Price)
        local info=native(O.Shared.Traits.Get,O.Data.Fighters.List[target])
        local snapshot=tostring(balance and balance.Total).."|"..tostring(info and info.Name)
        local progress=R.TraitAutoProgress
        local timeout=math.max(8,native(O.Utils.PlayerStats.TraitsCooldown,O.Data,Player)+5)
        if not progress or progress.Snapshot~=snapshot then
            R.TraitAutoProgress={Snapshot=snapshot,At=os.clock()}
        elseif os.clock()-progress.At>=timeout then
            cancelNativeAuto("Traits");R.TraitAutoProgress=nil
        end
        if not R.TraitsAutoOwned then
            native(controller.CancelAuto)
            native(controller.Start)
            native(controller.StartAuto)
            R.TraitsAutoOwned=true
        end
        state("Traits","Native auto · rolling "..O.Data.Fighters.List[target].Name)
        return
    end
    native(controller.Start)
    rollOnce("Traits",controller,O.Shared.Traits.Price,native(O.Utils.PlayerStats.TraitsCooldown,O.Data,Player),function()
        local fighter=O.Data.Fighters.List[target];local info=fighter and native(O.Shared.Traits.Get,fighter)
        return info and info.Name or ""
    end)
    state("Traits","Rotation · rolling "..O.Data.Fighters.List[target].Name)
end)

do
local p=page(tab("Breathing"),"Auto Roll")
local function weaponOptions()
    local options={}
    for uid,w in pairs(O.Data.Weapons.List) do if w.Name~="Melee" and O.Shared.Weapons.List[w.Name] then table.insert(options,{Title=w.Name.." · "..uid:sub(-8),Value=uid}) end end
    table.sort(options,function(a,b)return a.Title<b.Title end);return options
end
dropdown(p,"BreathingWeapons","Selected Weapons",weaponOptions(),true,{})
priority(p,"BreathingOrder","Weapon Priority",weaponOptions(),"BreathingWeapons")
local options={}
for name,def in pairs(O.Shared.Breathings.List) do
    for rarity,info in pairs(def.Rarities) do
        local effects={}
        for _,group in ipairs({"Attributes","Perks"}) do for stat,bonus in pairs(info[group] or {}) do
            table.insert(effects,stat.." "..(bonus.Type=="Multi" and string.format("x%.3g",bonus.Amount) or string.format("%+.1f%%",bonus.Amount*100)))
        end end
        table.sort(effects)
        table.insert(options,{Title=name.." ("..rarity..")",Description=table.concat(effects," · "),Value=name.."|"..rarity,RarityOrder=native(O.Utils.Order.Rarity,O.Utils.Order,rarity)})
    end
end
table.sort(options,function(a,b)
    if a.RarityOrder~=b.RarityOrder then return a.RarityOrder<b.RarityOrder end
    return a.Title<b.Title
end)
local filter=dropdown(p,"BreathingStops","Keep Breathings",options,true,{})
for _,desc in ipairs(filter.Instance:GetDescendants()) do
    if desc:IsA("TextLabel") and desc.Name=="Description" and desc.Parent:FindFirstChild("Check") then
        desc.TextWrapped=true;desc.TextTruncate=Enum.TextTruncate.None;desc.TextYAlignment=Enum.TextYAlignment.Top
        desc.Size=UDim2.new(1,-45,0,42);desc.Parent.Size=UDim2.new(1,-3,0,68)
    end
end
toggle(p,"AutoBreathing","Auto Roll Breathing",1,"Locks matching results, then rolls until at least two match. Each lock doubles the token cost.")
toggle(p,"HideBreathingPanel","Hide Breathing UI",1,"Hides the Breathing panel without stopping rolls; restores it when disabled")
status(p,"Breathing")
button(p,"Refresh Weapons",function()local values=weaponOptions();R.Controls.BreathingWeapons.API:Reload(values);R.Controls.BreathingOrder.API:Reload(values)end)
local selectedWeapon
local function stop(message)
    cancelNativeAuto("Breathing");activity("Breathing",false)
    S.AutoBreathing=false;R.Controls.AutoBreathing.API:Set(false,true);state("Breathing",message)
end
worker("Breathing",.2,function()
    if not S.AutoBreathing then cancelNativeAuto("Breathing");activity("Breathing",false);selectedWeapon=nil;return end
    if #S.BreathingStops==0 or #S.BreathingWeapons==0 then stop("Select weapons and desired breathings");return end
    local target,missing,lockName,blocked
    for _,uid in ipairs(S.BreathingOrder) do if has(S.BreathingWeapons,uid) then
        local weapon=O.Data.Weapons.List[uid]
        if weapon then
            local data=weapon.Breathings or {};local current=data.Current or {};local locked=data.Locked or {}
            local matches,total=0,0
            for name,rarity in pairs(current) do total=total+1;if has(S.BreathingStops,name.."|"..rarity) then matches=matches+1 end end
            if matches<math.max(2,total) then
                target=uid
                for name,rarity in pairs(current) do
                    if has(S.BreathingStops,name.."|"..rarity) then if not locked[name] then lockName=name end
                    elseif locked[name] then blocked=name end
                end
                break
            end
        else missing=true end
    end end
    if not target then
        if missing then cancelNativeAuto("Breathing");activity("Breathing",false);state("Breathing","Selected weapon missing · refresh selection")
        else stop("Complete · both slots match on every selected weapon") end
        return
    end
    if blocked then cancelNativeAuto("Breathing");activity("Breathing",false);state("Breathing","Unlock unwanted breathing manually: "..blocked);return end
    if not owns(O.Shared.Breathings.MapName) then stop("Unlock "..O.Shared.Breathings.MapName);return end
    local weapon=O.Data.Weapons.List[target];local data=weapon.Breathings or {};local locks=0
    for _,locked in pairs(data.Locked or {}) do if locked then locks=locks+1 end end
    local price=table.clone(O.Shared.Breathings.Price);price.Amount=price.Amount*2^locks
    local canPay=native(O.Shared.Economy.CanSpendRandom,O.Data,price,native(O.Shared.MonetizationPolicy.FromPlayer,Player))
    if not activity("Breathing",canPay) then state("Breathing",canPay and priorityWait() or "Waiting for tokens");return end
    if not syncStops("Breathings",S.BreathingStops) then cancelNativeAuto("Breathing");state("Breathing","Synchronizing native stop filter");return end
    local controller=O.Scripts.Interface.Breathings
    if selectedWeapon~=target then
        cancelNativeAuto("Breathing");native(controller.CancelAuto);native(controller.Start);native(controller.SelectWeapon,target);selectedWeapon=target;return
    end
    if lockName then
        cancelNativeAuto("Breathing")
        if gate("breathing:lock:"..target..":"..lockName,1) then fire("Breathings","SetLock",target,lockName,true) end
        state("Breathing","Locking "..lockName.." · "..weapon.Name)
        finishRollTurn("Breathing");return
    end
    if not R.BreathingAutoOwned then native(controller.Start) end
    rollOnce("Breathing",controller,price,native(O.Utils.PlayerStats.BreathingsCooldown,O.Data,Player),function()
        local w=O.Data.Weapons.List[target]
        return native(O.Shared.Breathings.GetOutcomeKey,w and w.Breathings and w.Breathings.Current or {})
    end)
    state("Breathing","Rotation · rolling "..weapon.Name.." · "..price.Amount.." tokens")
end)
end

local config=page(configTab,"Settings")
 dropdown(config,"UITheme","UI Theme",UI:GetThemeOptions(),false,"Devil - Crimson",1)
 if W.BindThemeSettings then W:BindThemeSettings(S) end
do
local protection=page(configTab,"Anti-Admin")
toggle(protection,"AntiAdmin","Anti-Admin",1,"Disables automation when a selected role joins this server")
dropdown(protection,"AdminRanks","Monitored Roles",{
{Title="Tester",Value="2"},{Title="CC Manager",Value="20"},{Title="Staff",Value="199"},{Title="Community Manager",Value="200"},{Title="StarX Team",Value="250"},{Title="Co Owner",Value="253"},{Title="Owner",Value="254"},{Title="Holder",Value="255"}},true,{"199","200","250","253","254","255"})
status(protection,"AntiAdmin")
local checking={}
local function check(joined)
    if not S.AntiAdmin or joined==Player or not joined.Parent or checking[joined] then return end
    checking[joined]=true
    local ok,rank=pcall(function()return joined:GetRankInGroup(33910482)end)
    checking[joined]=nil
    if not R.Alive or not S.AntiAdmin or not joined.Parent then return end
    if not ok then R.AdminNotice="Role lookup failed · retrying";state("AntiAdmin",R.AdminNotice);return end
    if has(S.AdminRanks,tostring(rank)) then
        for key,c in pairs(R.Controls) do if c.Kind=="boolean" and key~="AntiAdmin" then S[key]=false;c.API:Set(false,true) end end
        for _,name in ipairs({"Traits","Breathings"}) do pcall(function()native(O.Scripts.Interface[name].CancelAuto)end) end
        local message="Paused · @"..joined.Name.." · rank "..rank
        R.AdminNotice=message
        state("AntiAdmin",message)
        if gate("adminnotice:"..joined.UserId,30) then pcall(function()game:GetService("StarterGui"):SetCore("SendNotification",{Title="Devil Hub",Text=message,Duration=15})end) end
    end
end
connect(Players.PlayerAdded,function(joined)table.insert(R.Jobs,task.spawn(check,joined))end)
worker("AntiAdmin",.3,function()
    if not S.AntiAdmin then R.AdminNotice=nil;R.AdminNextCheck=nil;state("AntiAdmin","Disabled");return end
    state("AntiAdmin",R.AdminNotice or "Active · monitoring selected roles")
    if os.clock()>=(R.AdminNextCheck or 0) then
        R.AdminNextCheck=os.clock()+10;R.AdminNotice=nil
        for _,joined in ipairs(Players:GetPlayers()) do table.insert(R.Jobs,task.spawn(check,joined)) end
    end
end)
end

toggle(config,"AntiAFK","Anti-AFK")
toggle(config,"Reconnect","Auto Reconnect",2,"Rejoins after disconnecting and restores settings when supported by the executor")
status(config,"AntiAFK")
status(config,"Reconnect")
toggle(config,"HideGame","Hide Game UI")
toggle(config,"HideNick","Hide Nick",1,"Hides your overhead username locally; restores it when disabled")
input(config,"Profile","Profile Name","default")
local folder="ItachiLegacy-"..Player.UserId
local function profilePath()
    local name=tostring(S.Profile):gsub("[^%w_-]","");assert(#name>0,"Enter a profile name")
    if not isfolder(folder) then makefolder(folder) end
    return folder.."/"..name..".json"
end
local autoLoadPath=folder.."-autoload.json"
local function loadProfile()
    local settings=Http:JSONDecode(readfile(profilePath()));assert(type(settings)=="table","Invalid profile")
    for key,c in pairs(R.Controls) do local v=settings[key];if v~=nil and typeof(v)==c.Kind then S[key]=v;c.API:Set(v,true) end end
    state("Config","Config loaded · "..S.Profile)
end
button(config,"Save Config",function()writefile(profilePath(),Http:JSONEncode(S));state("Config","Config saved · "..S.Profile)end)
button(config,"Load Config",loadProfile)
S.AutoLoad=false
remember(config,"AutoLoad","Auto Load",config:AddToggle({Title="Auto Load",Description="Loads this saved profile when the script starts",Column=1,Default=false,Callback=safe(function(value)
    if value then
        writefile(profilePath(),Http:JSONEncode(S))
        writefile(autoLoadPath,Http:JSONEncode({Profile=S.Profile}))
    elseif isfile(autoLoadPath) then delfile(autoLoadPath) end
    S.AutoLoad=value==true
    state("Config",value and "Auto Load enabled · "..S.Profile or "Auto Load disabled")
end)}),false,"boolean")
R.LoadStartupConfig=function()
    local resume=getgenv().DevilHubLegacyResume or getgenv().ItachiLegacyResume
    getgenv().DevilHubLegacyResume=nil
    getgenv().DevilHubLegacyResume=nil
    if type(resume)=="string" then
        local ok,data=pcall(function()return Http:JSONDecode(resume)end)
        if ok and data.UserId==Player.UserId and type(data.At)=="number" and math.abs(os.time()-data.At)<3600 and type(data.Settings)=="table" then
            for key,c in pairs(R.Controls) do local value=data.Settings[key];if typeof(value)==c.Kind then S[key]=value;c.API:Set(value,true) end end
            state("Config","Reconnected · session settings restored");return
        end
    end
    if type(isfile)~="function" or not isfile(autoLoadPath) then return end
    local ok,err=pcall(function()
        local metadata=Http:JSONDecode(readfile(autoLoadPath));assert(type(metadata.Profile)=="string","Invalid Auto Load profile")
        S.Profile=metadata.Profile;R.Controls.Profile.API:Set(S.Profile,true)
        loadProfile();S.AutoLoad=true;R.Controls.AutoLoad.API:Set(true,true)
    end)
    if not ok then state("Config","Auto Load failed · "..tostring(err)) end
end
button(config,"Delete Profile",function()delfile(profilePath());state("Config","Profile deleted")end)
button(config,"Stop All Automation",stopAll,2)
button(config,"Unload Hub",R.Stop,2)
button(config,"Copy Diagnostics",function()if setclipboard then setclipboard(Http:JSONEncode({Version=R.Version,Errors=R.Errors,Status=R.Status}))end end,2)
status(config,"Config")
local search=page(tab("Search"),"Search Features")
local searchRows={}
local favorites={}
local favoritePath="ItachiLegacy-"..Player.UserId.."-favorites.json"
pcall(function()if isfile(favoritePath) then favorites=Http:JSONDecode(readfile(favoritePath)) end end)
local query="";local onlyFavorites=false
local function filterSearch()
    for _,row in ipairs(searchRows) do row.Frame.Visible=(not onlyFavorites or favorites[row.Key]) and row.Text:find(query,1,true)~=nil;row.Star.Text=favorites[row.Key] and "★" or "☆" end
end
search:AddInput({Title="Search features",Default="",Column=1,Callback=function(v)
    query=tostring(v):lower();filterSearch()
end})
search:AddToggle({Title="Favorites only",Default=false,Column=1,Callback=function(v)onlyFavorites=v;filterSearch()end})
for _,entry in ipairs(entries) do
    local row=button(search,entry.Title,function()W:SelectTab(entry.Page.ParentTab);entry.Page.ParentTab:SelectPage(entry.Page)end,2)
    local frame=row.Frame or row.Instance
    if frame then
        row.Title.Size=UDim2.new(1,-60,0,30)
        local star=Instance.new("TextButton",frame);star.Size=UDim2.fromOffset(40,40);star.Position=UDim2.new(1,-44,.5,-20);star.BackgroundTransparency=1;star.TextSize=25;star.TextColor3=Color3.fromRGB(255,35,75);star.ZIndex=15
        connect(star.Activated,function()favorites[entry.Key]=not favorites[entry.Key];pcall(writefile,favoritePath,Http:JSONEncode(favorites));filterSearch()end)
        table.insert(searchRows,{Frame=frame,Text=(entry.Title.." "..entry.Page.PageTitle):lower(),Key=entry.Key,Star=star})
    end
end
filterSearch()
local function bestSpot(points,radius,current,heightAt)
    if #points==0 then return nil,0 end
    local y=points[1].Y
    local best,count,distance=nil,-1,math.huge
    local checks=0
    local function score(x,z)
        local y=y
        if heightAt then y=heightAt(x,y,z) end
        if not y then return end
        local hits=0
        for _,p in ipairs(points) do
            if (p.X-x)^2+(p.Y-y)^2+(p.Z-z)^2<=radius^2+0.00001 then hits=hits+1 end
        end
        local travel=(current.X-x)^2+(current.Y-y)^2+(current.Z-z)^2
        if hits>count or (hits==count and travel<distance) then best={X=x,Y=y,Z=z};count=hits;distance=travel end
        checks=checks+1
        if checks%128==0 and task then task.wait() end
    end
    score(current.X,current.Z)
    for _,p in ipairs(points) do score(p.X,p.Z) end
    for i=1,#points do
        local a=points[i];local ra2=radius^2-(a.Y-y)^2
        if ra2>=0 then
            for j=i+1,#points do
                local b=points[j];local rb2=radius^2-(b.Y-y)^2
                local dx,dz=b.X-a.X,b.Z-a.Z;local d2=dx*dx+dz*dz
                if rb2>=0 and d2>0.00001 then
                    local d=math.sqrt(d2);local ra,rb=math.sqrt(ra2),math.sqrt(rb2)
                    if d<=ra+rb and d>=math.abs(ra-rb) then
                        local along=(ra2-rb2+d2)/(2*d);local h=math.sqrt(math.max(0,ra2-along*along))
                        local x,z=a.X+along*dx/d,a.Z+along*dz/d
                        score(x-h*dz/d,z+h*dx/d);score(x+h*dz/d,z-h*dx/d)
                    end
                end
            end
        end
    end
    return best,count
end

local function modeFloorHeight(hrp)
    local map=workspace.Client.Maps:FindFirstChild(O.Data.Gamemode or O.Data.Maps.Current or "")
    local humanoid=hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
    if not humanoid then return function()return nil end end
    local clearance=hrp.Size.Y*.5+humanoid.HipHeight
    if humanoid.RigType==Enum.HumanoidRigType.R6 then
        local leg=hrp.Parent:FindFirstChild("Left Leg")
        clearance=clearance+(leg and leg.Size.Y or 2)
    end
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances=map and {map,workspace.Terrain} or {workspace.Client.Maps,workspace.Terrain}
    params.RespectCanCollide=true
    return function(x,y,z)
        local hit=workspace:Raycast(Vector3.new(x,y+12,z),Vector3.new(0,-80,0),params)
        if hit and hit.Normal.Y>.5 then return hit.Position.Y+clearance+.2 end
    end
end

R.QuestLogic=(function()
local Quest={}
function Quest.next(def,progress)
    if not def then return "Missing" end
    if progress and (progress.Claimed or def.MaximumCompletions and (progress.Completions or 0)>=def.MaximumCompletions) then return "Complete" end
    if not progress or not progress.Available then return "Collect" end
    for i,mission in ipairs(def.Missions or {}) do
        local count=tonumber((progress.Missions or {})[i]) or 0
        if count<(mission.Amount or 0) then
            if mission.Type~="Kill" or not mission.Name then return "Unsupported",mission,count end
            return "Farm",mission,count
        end
    end
    return "Claim"
end
return Quest

end)()
function R.WorldQuestStep()
    R.QuestTarget=nil
    if not S.AutoWorldQuest then state("World Quest","Disabled");return end
    if O.Data.Gamemode then state("World Quest","Paused for gamemode");return end
    local map=O.Data.Maps.Current
    local definitions=O.Shared.Quests.List.Main
    local def=definitions and definitions.List[map]
    local data=O.Data.Quests.List.Main
    local progress=data and data.List[map]
    local action,mission,count=R.QuestLogic.next(def,progress)
    if action=="Missing" then state("World Quest",map.." · no main quest available");return end
    if action=="Complete" then state("World Quest",map.." · quest completed");return end
    if action=="Collect" then
        local can,reason=native(O.Shared.Quests.CanCollectQuest,map,"Main",O.Data)
        state("World Quest",map.." · "..(can and "accepting quest" or tostring(reason)))
        if can and gate("worldquest:collect:"..map,3) then fire("Quests","Collect","Main",map) end
    elseif action=="Claim" then
        state("World Quest",map.." · claiming reward")
        if gate("worldquest:claim:"..map,3) then fire("Quests","Claim","Main",map) end
    elseif action=="Farm" then
        R.QuestTarget={World=map,Enemy=mission.Name}
        state("World Quest",map.." · "..mission.Name.." · "..count.."/"..mission.Amount)
    else state("World Quest","Objective requires manual action · "..tostring(mission.Title or mission.Type)) end
end
local function currentWorld() return S.AutoWorldQuest and O.Data.Maps.Current or S.World end
local function modeKey()
    return O.Data.Gamemode=="Dungeon Easy" and "Dungeon" or O.Data.Gamemode=="Trial Easy" and "Trial" or O.Data.Gamemode=="Culling Game" and "Culling" or nil
end
local function modeSession()
    local map=workspace.Client.Maps:FindFirstChild(O.Data.Gamemode or "")
    local sessions=map and map:FindFirstChild("GamemodeSessions")
    return sessions and sessions:FindFirstChild(O.Data.GamemodeSession or "")
end
local function modeState(name)
    local session=modeSession()
    if not session or not session:FindFirstChild("StateManager") then return nil end
    local manager=native(O.Utils.StateManager.Get,session)
    return manager and native(function()return manager:GetState(name)end)
end
local function farmEnabled()
    local key=modeKey()
    if O.Data.Gamemode then
        if key=="Culling" then return S.FarmModes end
        return key and S[key.."Farm"] or (not key and S.FarmModes)
    end
    return S.AutoWorldQuest or S.Farm
end
local function attackRange()
    local radius=native(O.Utils.PlayerStats.AutoAttackRange,O.Data,Player)
    if S.Click then
        local weapon=O.Data.Weapons.List[O.Data.Weapons.Equipped]
        local definition=weapon and O.Shared.Weapons.List[weapon.Name]
        for _,hit in ipairs(definition and definition.Hits or {}) do
            if tonumber(hit.Range) then
                local offset=hit.Offset and hit.Offset.Position.Magnitude or 0
                radius=math.min(radius,math.max(2,hit.Range-offset))
            end
        end
    end
    return math.max(1,radius-.5)
end
local function prioritizeDungeonTreasure(enemies)
    if not S.DungeonTreasure or O.Data.Gamemode~="Dungeon Easy" then return enemies end
    local folder=workspace.Client.Maps:FindFirstChild("Dungeon Easy")
    local manager=folder and native(O.Utils.StateManager.Get,folder)
    if not manager then return enemies end
    local rooms=native(function()return manager:GetState("Rooms")end) or {}
    local cleared=native(function()return manager:GetState("ClearedRooms")end) or {}
    local visible=native(function()return manager:GetState("VisibleRooms")end) or {}
    local chests={};local groups={}
    for _,entry in ipairs(enemies) do
        local id=tostring(entry.Enemy:GetAttribute("RoomIndex"))
        local def=O.Shared.Enemies.StaticModels[entry.Enemy:GetAttribute("EnemyName")]
        if visible[id] and def and def.Category=="Chests" then table.insert(chests,entry) end
        if visible[id] and not cleared[id] then groups[id]=groups[id] or {};table.insert(groups[id],entry) end
    end
    if #chests>0 then R.DungeonTreasureStatus="Attacking available chests";return chests end
    local coordinates={};local distance={};local pending={}
    for id,room in pairs(rooms) do
        if room.Coordinates then coordinates[tostring(room.Coordinates)]=tostring(id) end
        if room.Type=="Treasure" and not cleared[tostring(id)] then distance[tostring(id)]=0;pending[tostring(id)]=true end
    end
    local directions={North=Vector3.new(0,0,-1),South=Vector3.new(0,0,1),East=Vector3.new(1,0,0),West=Vector3.new(-1,0,0)}
    local opposite={North="South",South="North",East="West",West="East"}
    while next(pending) do
        local id;for candidate in pairs(pending) do if not id or distance[candidate]<distance[id] then id=candidate end end
        pending[id]=nil
        local room=rooms[id]
        if room and room.Coordinates then
            for direction,offset in pairs(directions) do
                local neighbor=coordinates[tostring(room.Coordinates+offset)]
                local other=neighbor and rooms[neighbor]
                if other and (room.Connections or {})[direction] and (other.Connections or {})[opposite[direction]] then
                    local cost=distance[id]+((cleared[id] or room.Type=="Start") and 0 or 1)
                    if not distance[neighbor] or cost<distance[neighbor] then distance[neighbor]=cost;pending[neighbor]=true end
                end
            end
        end
    end
    local chosen
    for id in pairs(groups) do if distance[id] and (not chosen or distance[id]<distance[chosen] or distance[id]==distance[chosen] and tonumber(id)<tonumber(chosen)) then chosen=id end end
    if chosen then R.DungeonTreasureStatus="Treasure route · clear room "..chosen;return groups[chosen] end
    R.DungeonTreasureStatus=nil
    return enemies
end
R.DungeonHealthOrder=(function()
return function(entries)
    local alive={}
    for _,entry in ipairs(entries) do
        local health=tonumber(entry.Health)
        if not health or health~=health then health=math.huge end
        if health>0 then
            entry.Health=health
            table.insert(alive,entry)
        end
    end
    table.sort(alive,function(a,b)
        if a.Health~=b.Health then return a.Health<b.Health end
        return tostring(a.ID)<tostring(b.ID)
    end)
    local first=alive[1]
    return alive,first and tostring(first.Room or first.ID),first and first.Health
end

end)()
local function enemiesForFarm()
    local out={};local mode=O.Data.Gamemode
    local parent
    if mode then
        local group=workspace.Server.Enemies.Gamemodes:FindFirstChild(mode)
        parent=group and group:FindFirstChild(O.Data.GamemodeSession or "")
        if not parent then return out end
    end
    for _,enemy in ipairs(Tags:GetTagged("Enemy")) do
        local d=enemy:FindFirstChild("Data");local pos=d and d:FindFirstChild("CurrentPosition")
        local quest=not mode and S.AutoWorldQuest
        local matches=quest and R.QuestTarget and R.QuestTarget.World==O.Data.Maps.Current and enemy:GetAttribute("EnemyName")==R.QuestTarget.Enemy
        local eligible=mode and enemy:IsDescendantOf(parent) or (not mode and enemy:GetAttribute("MapName")==currentWorld() and (quest and matches or not quest and (#S.Difficulty==0 or has(S.Difficulty,enemy:GetAttribute("Difficulty")))))
        if eligible and pos and not enemy:GetAttribute("Died") then table.insert(out,{Enemy=enemy,Position=pos.Value.Position}) end
    end
    local hrp=root()
    if S.PrioritizeEnemies and not S.AutoWorldQuest and not mode and #out>0 then
        local rank=math.huge
        for _,entry in ipairs(out) do rank=math.min(rank,enemyRank(entry.Enemy)) end
        local preferred={};for _,entry in ipairs(out) do if enemyRank(entry.Enemy)==rank then table.insert(preferred,entry) end end
        out=preferred
    end
    if hrp then table.sort(out,function(a,b)return (a.Position-hrp.Position).Magnitude<(b.Position-hrp.Position).Magnitude end) end
    if mode=="Culling Game" then
        local entries={}
        for _,entry in ipairs(out) do
            local health=entry.Enemy.Data:FindFirstChild("Health")
            entry.Health=health and health.Value
            entry.Room="Culling"
            entry.ID=entry.Enemy:GetAttribute("EnemyID") or tostring(entry.Enemy)
            if entry.Enemy:GetAttribute("Shielded")~=true then table.insert(entries,entry) end
        end
        local ordered=R.DungeonHealthOrder(entries)
        return ordered[1] and {ordered[1]} or {}
    end
    if mode=="Dungeon Easy" then
        for _,entry in ipairs(out) do
            local health=entry.Enemy.Data:FindFirstChild("Health")
            entry.Health=health and health.Value
            entry.Room=entry.Enemy:GetAttribute("RoomIndex")
            entry.ID=entry.Enemy:GetAttribute("EnemyID") or tostring(entry.Enemy)
        end
        local ordered,room=R.DungeonHealthOrder(out)
        R.DungeonTreasureStatus=nil
        R.DungeonHealthRoom=room
        return ordered[1] and {ordered[1]} or {}
    end
    return prioritizeDungeonTreasure(out)
end
worker("Farm",.5,function()
    if not O.Data.Gamemode and (R.ModeJoining or R.ModeWinner and R.ModeWinner~="Farm") then R.Target=nil;R.SpotTargets={};state("Farm","Waiting for "..tostring(R.ModeWinner or "mode entry"));return end
    if not O.Data.Gamemode and not activity("Farm",farmEnabled() or S.AttackEverything) then R.Target=nil;R.SpotTargets={};return end
    if R.FruitTrip or R.FruitVisit then return end
    R.WorldQuestStep()
    if S.AutoWorldQuest and not O.Data.Gamemode and not R.QuestTarget then R.Target=nil;R.SpotTargets={};state("Farm",R.Status["World Quest"]);return end
    if stationaryAttack() then R.Target=nil;R.SpotTargets={};return end
    if not farmEnabled() or R.LeavingSession==O.Data.GamemodeSession and O.Data.GamemodeSession~=nil then R.Target=nil;R.SpotTargets={};state("Farm","Disabled or leaving mode");return end
    if not O.Data.Gamemode then
        local map=currentWorld()
        if not owns(map) then state("Farm","Selected world is locked");return end
        if O.Data.Maps.Current~=map then if gate("map",5) then fire("Maps","Teleport",map) end;return end
    end
    local hrp=root();if not hrp then return end
    local enemies=enemiesForFarm();local key=modeKey() or "Farm"
    if #enemies==0 then R.Target=nil;R.SpotTargets={};state(key,"Waiting for enemies in this spot/session");return end
    local points={};for _,v in ipairs(enemies) do table.insert(points,v.Position) end
    local radius=attackRange()
    local grounded=true
    local floorHeight=modeFloorHeight(hrp)
    local spot,covered
    if radius>4 then spot,covered=bestSpot(points,radius,hrp.Position,floorHeight) end
    local direct=radius<=4 or not spot or (covered or 0)<2
    local directEnemy
    if direct then
        -- Keep the current enemy until it dies instead of hopping between close targets.
        if O.Data.Gamemode~="Dungeon Easy" and O.Data.Gamemode~="Culling Game" then
            for _,v in ipairs(enemies) do if v.Enemy==R.Target then directEnemy=v;break end end
        end
        directEnemy=directEnemy or enemies[1]
        local p=directEnemy.Position
        local y=floorHeight(p.X,p.Y,p.Z)
        if y then spot={X=p.X,Y=y,Z=p.Z};covered=1 else spot=nil end
    end
    if not R.Alive or stationaryAttack() or not farmEnabled() then return end
    if not spot then R.Target=nil;R.SpotTargets={};state(key,"Waiting for arena floor");return end
    local position=Vector3.new(spot.X,spot.Y,spot.Z)
    local aim=(directEnemy or enemies[1]).Position
    if grounded then aim=Vector3.new(aim.X,position.Y,aim.Z) end
    if (aim-position).Magnitude<.1 then aim=position+(grounded and Vector3.zAxis or hrp.CFrame.LookVector) end
    if (hrp.Position-position).Magnitude>.6 then
        if grounded then hrp.AssemblyLinearVelocity=Vector3.zero;hrp.AssemblyAngularVelocity=Vector3.zero end
        hrp.CFrame=CFrame.lookAt(position,aim)
    end
    R.Target=nil;R.SpotTargets={}
    if direct then
        R.Target=directEnemy.Enemy
        R.SpotTargets={directEnemy.Enemy:GetAttribute("EnemyID")}
    else
    for _,v in ipairs(enemies) do if (v.Position-position).Magnitude<=radius+.05 then
        table.insert(R.SpotTargets,v.Enemy:GetAttribute("EnemyID"));R.Target=R.Target or v.Enemy
    end end
    end
    local message=direct and ("Direct target · "..tostring(directEnemy.Enemy:GetAttribute("EnemyName"))) or string.format("Spot / Range %.1f · %d/%d enemies",radius,covered,#enemies)
    if S.DungeonTreasure and O.Data.Gamemode=="Dungeon Easy" and R.DungeonTreasureStatus then message=R.DungeonTreasureStatus.." · "..message end
    if O.Data.Gamemode=="Dungeon Easy" and R.DungeonHealthRoom then message="Lowest HP enemy · room "..R.DungeonHealthRoom.." · "..message end
    state("Farm",message);if key~="Farm" then state(key,message) end
end)
worker("ModeExit",.5,function()
    local key=modeKey();local session=O.Data.GamemodeSession
    if not key or not session then R.LeavingSession=nil;return end
    local threshold=math.max(1,math.floor(tonumber(S[key.."LeaveAt"]) or 1))
    local count=modeState(key=="Dungeon" and "RoomsCleared" or "CurrentWave")
    if S[key.."Leave"] and type(count)=="number" and count>=threshold then
        R.LeavingSession=session
        if gate("leave:"..session,5) then fire("Gamemodes","Leave") end
        R.LeftWindows=R.LeftWindows or {};R.LeftWindows[O.Data.Gamemode]=workspace:GetServerTimeNow()
        state(key,"Leaving at "..tostring(count))
    end
end)

local attackTarget,attackBusy,attackAgain
local attackObservedHealth,attackProgressAt,attackObservedId
local attackSkipped=setmetatable({},{__mode="k"})
local attackPosition,attackMovedAt,attackMovementPending
local attackRequest
local attackWasEmpty=true
local function sendEverything(id,units,reason)
    if attackRequest then
        if os.clock()-attackRequest.At<3 then return false end
        if attackRequest.Thread then pcall(task.cancel,attackRequest.Thread) end
        attackRequest=nil
    end
    local request={At=os.clock()};attackRequest=request
    R.AttackDispatch={Target=id,At=request.At,Reason=reason}
    request.Thread=task.defer(function()
        local ok,result=pcall(invoke,"Combat","FighterAttack",id,units)
        if attackRequest==request then
            attackRequest=nil
            if not ok or result==false then attackMovementPending=true;attackMovedAt=0 end
        end
    end)
    table.insert(R.Jobs,request.Thread)
    return true
end
local targetConnections={}
local function clearAttackTarget()
    for _,c in ipairs(targetConnections) do c:Disconnect() end
    table.clear(targetConnections);attackTarget=nil
end
local attackEverything
local function scheduleAttack()
    if not R.Alive or not stationaryAttack() then return end
    if attackBusy then attackAgain=true;return end
    task.defer(attackEverything)
end
attackEverything=function()
    if attackBusy or not R.Alive then return end
    if not stationaryAttack() then clearAttackTarget();attackPosition=nil;attackMovementPending=false;return end
    attackBusy=true
    local ok,err=pcall(function()
        local mode=O.Data.Gamemode;local session=O.Data.GamemodeSession
        local hrp=root()
        if not hrp then clearAttackTarget();attackPosition=nil;return end
        if attackPosition and (hrp.Position-attackPosition).Magnitude>.5 then
            attackMovedAt=os.clock();attackMovementPending=true
            clearAttackTarget()
            attackPosition=hrp.Position
        end
        attackPosition=attackPosition or hrp.Position
        if session and R.LeavingSession==session then clearAttackTarget();return end
        local parent
        if mode then local group=workspace.Server.Enemies.Gamemodes:FindFirstChild(mode);parent=group and group:FindFirstChild(session or "") end
        local function valid(e)
            local d=e and e:FindFirstChild("Data")
            local health=d and d:FindFirstChild("Health")
            return e and e.Parent and (attackSkipped[e] or 0)<=os.clock() and health and tonumber(health.Value) and tonumber(health.Value)>0 and not e:GetAttribute("Died") and (mode and parent and e:IsDescendantOf(parent) or not mode and e:GetAttribute("MapName")==O.Data.Maps.Current)
        end
        if valid(attackTarget) then
            local position=attackTarget.Data:FindFirstChild("CurrentPosition")
            local currentDistance=position and (position.Value.Position-hrp.Position).Magnitude or math.huge
            local range=native(O.Utils.PlayerStats.AutoAttackRange,O.Data,Player)
            if currentDistance>range then
                for _,enemy in ipairs(Tags:GetTagged("Enemy")) do
                    local data=enemy:FindFirstChild("Data");local pos=data and data:FindFirstChild("CurrentPosition")
                    if valid(enemy) and pos and (pos.Value.Position-hrp.Position).Magnitude+2<currentDistance then clearAttackTarget();break end
                end
            end
        end
        if valid(attackTarget) and S.PrioritizeEnemies then
            for _,enemy in ipairs(Tags:GetTagged("Enemy")) do
                if valid(enemy) and enemyRank(enemy)<enemyRank(attackTarget) then clearAttackTarget();break end
            end
        end
        if not valid(attackTarget) then
            clearAttackTarget()
            local nearest,rank=math.huge,math.huge;local hrp=root()
            for _,enemy in ipairs(Tags:GetTagged("Enemy")) do
                local d=enemy:FindFirstChild("Data");local position=d and d:FindFirstChild("CurrentPosition")
                if valid(enemy) and position then
                    local distance=hrp and (position.Value.Position-hrp.Position).Magnitude or 0
                    local candidateRank=enemyRank(enemy)
                    if candidateRank<rank or candidateRank==rank and distance<nearest then nearest=distance;rank=candidateRank;attackTarget=enemy end
                end
            end
            if attackTarget then
                local health=attackTarget.Data:FindFirstChild("Health")
                if health then table.insert(targetConnections,health.Changed:Connect(function(value)if tonumber(value) and tonumber(value)<=0 then scheduleAttack() end end)) end
                table.insert(targetConnections,attackTarget:GetAttributeChangedSignal("Died"):Connect(scheduleAttack))
                table.insert(targetConnections,attackTarget.AncestryChanged:Connect(scheduleAttack))
            end
        end
        if not attackTarget then
            attackWasEmpty=true;attackObservedId=nil;attackObservedHealth=nil
            state("Farm","Attack Everything · waiting for enemies");return
        end
        if attackWasEmpty then
            attackWasEmpty=false;attackMovementPending=true;attackMovedAt=0
        end
        local id=attackTarget:GetAttribute("EnemyID");if not id then return end
        local hv=attackTarget.Data:FindFirstChild("Health");local hp=hv and tonumber(hv.Value)
        if id~=attackObservedId or hp~=attackObservedHealth then
            attackObservedId=id;attackObservedHealth=hp;attackProgressAt=os.clock()
        elseif os.clock()-(attackProgressAt or 0)>15 then
            attackSkipped[attackTarget]=os.clock()+3
            clearAttackTarget();attackObservedId=nil
            attackMovementPending=true;attackMovedAt=0;attackAgain=true
            return
        end
        local available=native(O.Utils.PlayerStats.GetAvailableFightersForTarget,id,O.Data,Player)
        if os.clock()-(attackProgressAt or 0)>6 and gate("everything:stalled:"..id,5) then
            attackMovementPending=true;attackMovedAt=0
        end
        -- Replicated Target can remain assigned after movement interrupts combat.
        -- Reissue once after settling instead of trusting that stale assignment.
        if attackMovementPending and os.clock()-(attackMovedAt or 0)>=.3 and gate("everything:movement",1) then
            available={}
            for uid,equipped in pairs(O.Data.Fighters.Equipped) do
                if equipped and workspace.Server.Fighters:FindFirstChild(uid) then table.insert(available,uid) end
            end
            if #available>0 then
                if sendEverything(id,available,"Respawn / movement recovery") then attackMovementPending=false end
                return
            end
        end
        if #available>0 and gate("everything:"..id,.15) then
            sendEverything(id,available,"Target selection")
        end
        state("Farm","Attack Everything · "..tostring(attackTarget:GetAttribute("EnemyName")))
    end)
    attackBusy=false
    R.Errors.AttackEverything=not ok and tostring(err) or nil
    if attackAgain then attackAgain=false;scheduleAttack() end
end
connect(Tags:GetInstanceAddedSignal("Enemy"),scheduleAttack)
local fighterWatchers={}
local function watchFighter(fighter)
    if fighterWatchers[fighter] then return end
    local connections={};fighterWatchers[fighter]=connections
    local function watchValue(value)
        if value.Name=="Target" and value:IsA("StringValue") then
            table.insert(connections,value.Changed:Connect(scheduleAttack))
        end
    end
    for _,child in ipairs(fighter:GetChildren()) do watchValue(child) end
    table.insert(connections,fighter.ChildAdded:Connect(watchValue))
    table.insert(connections,fighter.AncestryChanged:Connect(function(_,parent)
        if not parent then for _,c in ipairs(connections) do c:Disconnect() end;fighterWatchers[fighter]=nil end
    end))
end
for _,fighter in ipairs(workspace.Server.Fighters:GetChildren()) do watchFighter(fighter) end
connect(workspace.Server.Fighters.ChildAdded,watchFighter)
connect(W.Gui.Destroying,function()for _,connections in pairs(fighterWatchers) do for _,c in ipairs(connections) do c:Disconnect() end end end)
connect(W.Gui.Destroying,clearAttackTarget)
worker("AttackEverything",.1,attackEverything)
worker("Combat",.2,function()
    if S.Click or S.AutoWorldQuest and R.Target and not O.Data.Gamemode and not R.FruitTrip and not R.FruitVisit then fire("Combat","PlayerAttack") end
    if S.Skill and gate("skill",1) then native(O.Scripts.Interface.HUD.UseSkill) end
    if not stationaryAttack() and (S.Fighters or R.Target) and gate("fighters",1) then
        local hrp=root();if not hrp then return end
        local enemy=R.Target
        if O.Data.Gamemode=="Culling Game" and (not enemy or enemy:GetAttribute("Shielded")==true) then
            R.Target=nil;R.SpotTargets={};return
        end
        if S.AutoWorldQuest and not O.Data.Gamemode and (not R.QuestTarget or not enemy or enemy:GetAttribute("MapName")~=R.QuestTarget.World or enemy:GetAttribute("EnemyName")~=R.QuestTarget.Enemy) then return end
        local id=enemy and enemy:GetAttribute("EnemyID")
        if not id then
            local targets=native(O.Utils.Enemies.GetEnemiesInRange,hrp.Position,native(O.Utils.PlayerStats.AutoAttackRange,O.Data,Player))
            id=targets[1] and targets[1].ID
        end
        if not id then return end
        local units={}
        for uid,current in pairs(native(O.Utils.PlayerStats.GetFighterTargets,O.Data,Player)) do
            if current=="" or R.Target and current~=id then table.insert(units,uid) end
        end
        if #units>0 then
            local ids=R.SpotTargets or {}
            if #ids>1 and not S.AutoWorldQuest then
                local groups={}
                for i,uid in ipairs(units) do local targetId=ids[(i-1)%#ids+1];groups[targetId]=groups[targetId] or {};table.insert(groups[targetId],uid) end
                for targetId,group in pairs(groups) do invoke("Combat","FighterAttack",targetId,group) end
            else sendEverything(id,units,"World Farm / Quest") end
        end
    end
end)

local panelMasks={}
for _,spec in ipairs({{"Star","HideStarPanel"},{"Gacha","HideGachaPanel"},{"Traits","HideTraitPanel"},{"Breathings","HideBreathingPanel"}}) do
    local panel=O.Interface.Frames:WaitForChild(spec[1])
    table.insert(panelMasks,{Panel=panel,Key=spec[2],Saved={}})
end
local function restorePanel(record)
    if record.NativeHidden~=nil then
        native(O.Frame.SetHidden,O.Frame,record.Panel.Name,record.NativeHidden)
        record.NativeHidden=nil
        native(O.Frame.RefreshHUD,O.Frame)
    end
    if record.Position then record.Panel.Position=record.Position;record.Position=nil end
    for object,properties in pairs(record.Saved) do
        if object.Parent then for property,value in pairs(properties) do object[property]=value end end
    end
    table.clear(record.Saved)
end
local function refreshStarPanel()
    for _,record in ipairs(panelMasks) do
        if record.Key~="HideStarPanel" then
            if S[record.Key] then
                local frame=native(O.Frame.Get,O.Frame,record.Panel.Name)
                if frame then
                    if record.NativeHidden==nil then record.NativeHidden=native(frame.Scope.peek,frame.Hidden) end
                    if not native(frame.Scope.peek,frame.Hidden) then native(O.Frame.SetHidden,O.Frame,record.Panel.Name,true) end
                end
            elseif record.NativeHidden~=nil or record.Position then restorePanel(record) end
            continue
        end
        if S[record.Key] then
            local objects=record.Panel:GetDescendants();table.insert(objects,record.Panel)
            for _,object in ipairs(objects) do
                local properties={}
                if object:IsA("GuiObject") then table.insert(properties,"BackgroundTransparency") end
                if object:IsA("ImageLabel") or object:IsA("ImageButton") or object:IsA("ViewportFrame") then table.insert(properties,"ImageTransparency") end
                if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then table.insert(properties,"TextTransparency");table.insert(properties,"TextStrokeTransparency") end
                if object:IsA("UIStroke") then table.insert(properties,"Transparency") end
                if object:IsA("CanvasGroup") then table.insert(properties,"GroupTransparency") end
                for _,property in ipairs(properties) do
                    local saved=record.Saved[object] or {};record.Saved[object]=saved
                    if saved[property]==nil or object[property]~=1 then saved[property]=object[property] end
                    if object[property]~=1 then object[property]=1 end
                end
            end
        elseif next(record.Saved) then restorePanel(record) end
    end
    if S.HideGachaPanel or S.HideTraitPanel or S.HideBreathingPanel then
        local hiddenGacha,otherPanel=false,false
        for _,name in ipairs(native(O.Frame.GetOpenedFrames,O.Frame)) do
            local frame=native(O.Frame.Get,O.Frame,name)
            if frame and (frame.Preset=="Default" or frame.Preset=="Overlay2") then
                if name=="Gacha" and S.HideGachaPanel or name=="Traits" and S.HideTraitPanel or name=="Breathings" and S.HideBreathingPanel then hiddenGacha=true
                elseif not native(frame.Scope.peek,frame.Hidden) then otherPanel=true end
            end
        end
        if hiddenGacha and not otherPanel then native(O.Frame.OpenHUD,O.Frame) end
    end
end
R.RestoreStarPanel=function()for _,record in ipairs(panelMasks) do restorePanel(record) end end
connect(game:GetService("RunService").RenderStepped,refreshStarPanel)
R.StopStarAuto=function()
    if R.StarAutoOwned then native(O.Scripts.Interface.Stars.CancelAutoRoll);R.StarAutoOwned=false end
end
worker("Stars",.3,function()
    if not S.OpenStars then activity("Stars",false);R.StopStarAuto();state("Stars","Disabled");return end
    local cfg=O.Shared.Stars.List[S.Star]
    if not cfg or not owns(cfg.MapName) then activity("Stars",false);R.StopStarAuto();state("Stars","Star world is locked");return end
    local controller=O.Scripts.Interface.Stars
    if R.StarAutoOwned and not activity("Stars",true) then state("Stars",priorityWait());return end
    if R.StarAutoSelection~=S.Star then R.StopStarAuto();R.StarAutoSelection=S.Star end
    if not native(controller.IsRolling) then
        native(O.Utils.Multipliers.Invalidate,Player)
        local maximum=math.max(1,math.floor(native(O.Utils.PlayerStats.MaxStarOpens,O.Data,Player)))
        local _,_,free=native(O.Utils.PlayerStats.FightersInventory,O.Data,Player)
        if free<maximum then activity("Stars",false);R.StopStarAuto();state("Stars","Waiting for "..maximum.." free inventory slots");return end
        local fullPrice=table.clone(cfg.Price);fullPrice.Amount=fullPrice.Amount*maximum
        local balance=native(O.Shared.Economy.GetBalance,O.Data,fullPrice)
        local amount=balance and balance.Total
        if amount==nil and fullPrice.Type=="Currency" then amount=tonumber(O.Data[fullPrice.Name]) end
        if amount and amount<fullPrice.Amount then activity("Stars",false);R.StopStarAuto();state("Stars","Waiting for currency · resumes automatically");return end
        if not activity("Stars",true) then state("Stars",priorityWait());return end
        if not native(controller.IsAutoRolling) then
            native(controller.Start,S.Star)
            R.StarAutoOwned=true
            native(controller.StartAutoRoll)
        end
        R.StarRequested=maximum
    end
    state("Stars","Opening "..S.Star.." · max "..tostring(R.StarRequested or "—"))
end)
worker("RollVisibility",1,function()
    for key,nativeKey in pairs({HideStarRoll="Hide Star Animation",HideGachaRoll="Hide Gacha Animation"}) do
        if (O.Data.Settings[nativeKey]==true)~=S[key] and gate(key,3) then fire("Settings","Set",nativeKey,S[key]) end
    end
end)
worker("Gacha",.2,function()
    if not S.RollGacha then cancelNativeAuto("Gacha");R.LastGacha=nil;activity("Gacha",false);state("Gacha","Disabled");return end
    local completed={}
    for _,name in ipairs(S.Gachas) do
        local def=O.Shared.Gacha.List[name]
        local source=def and def.Source
        local current=O.Data.Gacha[name] and O.Data.Gacha[name].Current
        local result=source and source.Normal and source.Normal[current]
        if source and source.Type=="Normal" and result then
            local highest=0
            for _,item in pairs(source.Normal) do
                if type(item.Chance)=="number" and item.Chance>0 then
                    highest=math.max(highest,native(O.Utils.Order.Rarity,O.Utils.Order,item.Rarity))
                end
            end
            if highest>0 and native(O.Utils.Order.Rarity,O.Utils.Order,result.Rarity)>=highest then completed[name]=true end
        end
    end
    if next(completed) then
        local remaining={}
        for _,name in ipairs(S.Gachas) do if not completed[name] then table.insert(remaining,name) end end
        S.Gachas=remaining;R.Controls.Gachas.API:Set(remaining,true)
        if completed[R.LastGacha] then cancelNativeAuto("Gacha");native(module("Scripts.Interface.Gacha.Default").CancelAuto);R.LastGacha=nil end
    end
    if #S.Gachas==0 then
        S.RollGacha=false;R.Controls.RollGacha.API:Set(false,true)
        R.LastGacha=nil;activity("Gacha",false)
        state("Gacha","Queue complete · no selected gachas remaining");return
    end
    for _,name in ipairs(S.GachaOrder) do
        local def=O.Shared.Gacha.List[name]
        if has(S.Gachas,name) and def and owns(def.Map or def.MapName) then
            local policy=native(O.Shared.MonetizationPolicy.FromPlayer,Player)
            local canSpend=native(O.Shared.Economy.CanSpendRandom,O.Data,def.Price,policy)
            if canSpend then
                if not activity("Gacha",true) then state("Gacha",priorityWait());return end
                if R.LastGacha~=name or not R.GachaAutoOwned then cancelNativeAuto("Gacha");native(O.Scripts.Interface.Gacha.Start,name);R.LastGacha=name end
                rollOnce("Gacha",module("Scripts.Interface.Gacha.Default"),def.Price,native(O.Utils.PlayerStats.GachaCooldown,O.Data,Player,name),function()
                    return O.Data.Gacha[name] and O.Data.Gacha[name].Current
                end)
                state("Gacha","Rolling "..name);return
            end
        end
    end
    R.LastGacha=nil;activity("Gacha",false);state("Gacha","Waiting for selected gacha resources")
end)
worker("Progression",2,function()
    if not S.Progress then state("Progression","Disabled");return end
    local controller=module("Scripts.Interface.Progression.State")
    for _,name in ipairs(S.Progressions) do
        local info=native(controller.Get,name)
        if info.CanUpgrade then fire("Progression","Upgrade",name);state("Progression","Upgrading "..name);return end
    end
    state("Progression","Waiting for resources or access")
end)
worker("Upgrades",.15,function()
    if not S.Upgrade then state("Upgrades","Disabled");return end
    for _,value in ipairs(S.UpgradeOrder) do
        if not has(S.Upgrades,value) then continue end
        local system,key=value:match("^(.-)|(.+)$")
        local def=O.Shared.Upgrade.List[system];local part=def and def.Upgrades[key]
        if part and (not def.MapName or owns(def.MapName)) then
            local level=native(O.Shared.Upgrade.GetCurrentLevel,system,key,O.Data)
            if level<part.MaxLevel then
                local info=native(O.Shared.Upgrade.GetLevelInformation,system,key,level+1)
                if info and info.Price and native(O.Shared.Upgrade.GetPriceAmount,O.Data,info.Price)>=info.Price.Amount then
                    if gate("upgrade:"..system..":"..key..":"..level,.6) then fire("Upgrade","Upgrade",system,key) end;state("Upgrades","Buying "..key);return
                end
            end
        end
    end
    state("Upgrades","Waiting for resources or maxed")
end)
worker("IndexRewards",2,function()
    if not S.IndexRewards then return end
    for section,info in pairs(O.Shared.Index.Rewards) do
        local discovered=native(O.Shared.Index.GetDiscoveredAmount,section,O.Data)
        for _,reward in pairs(info.List) do
            if discovered>=reward.Amount and not native(O.Shared.Index.IsRewardClaimed,section,reward.Amount,O.Data) and gate("indexClaim:"..section..":"..reward.Amount,5) then
                fire("IndexRewards","Claim",section,reward.Amount)
            end
        end
    end
end)
worker("LevelRewards",2,function()
    if not S.LevelRewards then return end
    for _,reward in pairs(O.Shared.PlayerLevel.List.Rewards) do
        if O.Data.Level.Amount>=reward.Level and not O.Data.Level.Rewards["Level"..reward.Level] and gate("levelClaim:"..reward.Level,5) then
            fire("PlayerLevel","ClaimReward",reward.Level)
        end
    end
end)
worker("Stats",.5,function()
    if not S.AutoStats then state("Stats","Disabled");return end
    if not S.StatTarget or not O.Shared.PlayerLevel.List.Stats[S.StatTarget] then state("Stats","Select a stat");return end
    local available=math.max(0,math.floor(native(O.Shared.PlayerLevel.GetAvailablePoints,O.Data)))
    if available==0 then state("Stats","Waiting for points · "..S.StatTarget);return end
    if gate("upgradeStat",3) then
        fire("PlayerLevel","UpgradeStat",S.StatTarget,available)
        state("Stats","Assigning "..available.." points to "..S.StatTarget)
    end
end)
worker("Rewards",15,function()
    for _,name in ipairs({"Achievements","Quests","Inbox"}) do if S[name] then fire(name,"ClaimAll") end end
    state("Rewards","Checking enabled rewards")
end)
worker("TimeRewards",1,function()
    if not S.TimeRewards then return end
    local d=O.Data.TimeRewards
    for i,reward in ipairs(O.Shared.TimeRewards) do
        if not d.Claimed[tostring(i)] and d.TimePlayed>=reward.Time and gate("timeReward:"..i,5) then
            fire("TimeRewards","Claim",i)
        end
    end
end)
worker("DailyRewards",1,function()
    if not S.DailyRewards then return end
    local d=O.Data.DailyRewards
    local day=d.Start==0 and 1 or math.floor((workspace:GetServerTimeNow()-d.Start)/86400)+1
    for i=1,math.min(day,#O.Shared.DailyRewards) do
        if not d.Claimed[tostring(i)] and gate("dailyReward:"..i,5) then fire("DailyRewards","Claim",i) end
    end
end)
native(function()
    connect(O.Scripts.General.Parties.SyncEvent,function(party)R.Party=party end)
    for _,signal in ipairs({O.Scripts.General.Parties.LeftEvent,O.Scripts.General.Parties.DisbandedEvent,O.Scripts.General.Parties.KickedEvent}) do connect(signal,function()R.Party=nil end) end
end)
R.ModePriority=(function()
local Priority={}
function Priority.window(def,now)
    local hour=math.floor(now/3600)*3600
    for _,minute in ipairs(def.OpenTimes or {}) do
        local opens=hour+minute*60
        if opens>now then opens=opens-3600 end
        local closes=opens+(def.EnterTime or 60)
        if now>=opens and now<closes then return {Status="Opened",EntryClosesAt=closes} end
    end
    return {Status="Closed"}
end
function Priority.choose(order,ready,current)
    for _,name in ipairs(order or {}) do
        if name==current or ready[name] then return name end
    end
    return current
end
return Priority

end)()
function R.ModeInvoke(system,action,...)
    local args=table.pack(...)
    local done,ok,result=false,false,nil
    local thread=task.spawn(function()
        ok,result=pcall(invoke,system,action,table.unpack(args,1,args.n));done=true
    end)
    table.insert(R.Jobs,thread)
    local deadline=os.clock()+4
    while not done and R.Alive and os.clock()<deadline do task.wait(.1) end
    if not done then pcall(task.cancel,thread);return nil end
    if ok then return result end
    return nil
end
worker("Modes",2,function()
    if R.FruitTrip or R.FruitVisit then return end
    local enabled={["Dungeon Easy"]=S.DungeonEnter,["Trial Easy"]=S.TrialEnter,["Culling Game"]=S.Culling}
    local current=O.Data.Gamemode
    if current then R.ModeJoining=nil end
    if R.ModeJoining then
        if os.clock()-R.ModeJoining<12 then state("Mode Priority","Joining "..tostring(R.ModeWinner));return end
        R.ModeJoining=nil
    end
    local windows={}
    for _,name in ipairs({"Dungeon Easy","Trial Easy"}) do
        local enabled=(name=="Dungeon Easy" and S.DungeonEnter) or (name=="Trial Easy" and S.TrialEnter)
        local def=O.Shared.Gamemodes.List[name]
        if enabled and def and name~=current and owns(def.MapName) then
            local preview=R.ModeInvoke("Gamemodes","Preview",name)
            if not preview then preview=R.ModePriority.window(def,workspace:GetServerTimeNow()) end
            if preview and preview.Status=="Opened" and workspace:GetServerTimeNow()<preview.EntryClosesAt and (not R.LeftWindows or not R.LeftWindows[name] or R.LeftWindows[name]<preview.EntryClosesAt-(def.EnterTime or 60)) then
                windows[name]=true
            end
        end
    end
    if S.Culling then
        local def=O.Shared.Gamemodes.List["Culling Game"]
        local price=native(O.Shared.Gamemodes.GetPrice,def)
        local ready=owns(def.MapName) and (not price or native(O.Shared.Gamemodes.GetPriceAmount,O.Data,price)>=price.Amount)
        windows["Culling Game"]=ready
    end
    windows.Farm=S.Farm or S.AttackEverything or S.AutoWorldQuest
    if S.AutoWorldQuest and not S.Farm and not S.AttackEverything then
        local map=O.Data.Maps.Current
        local def=O.Shared.Quests.List.Main.List[map]
        local data=O.Data.Quests.List.Main
        local action=R.QuestLogic.next(def,data and data.List[map])
        windows.Farm=action~="Complete" and action~="Missing" and action~="Unsupported"
    end
    local managed=current and enabled[current]
    local winner=R.ModePriority.choose(S.ModeOrder,windows,managed and current or nil)
    if current and not managed then R.ModeWinner=nil;state("Mode Priority","Manual mode · "..current);return end
    R.ModeWinner=winner
    state("Mode Priority",winner and ("Selected · "..winner) or "Waiting for enabled activities")
    if current then
        if winner and winner~=current then
            R.LeavingSession=O.Data.GamemodeSession
            state("Modes","Leaving "..current.." for "..winner)
            if gate("priority-mode-leave",5) then fire("Gamemodes","Leave") end
        else state("Modes","Inside "..current) end
        return
    end
    if winner=="Farm" or not winner then state("Modes",winner=="Farm" and "Farming · waiting for higher-priority modes to open" or "Waiting for entry window / tickets");return end
    if winner=="Dungeon Easy" or winner=="Trial Easy" then
        R.ModeJoining=os.clock();R.Target=nil;R.SpotTargets={}
        local ok,result=pcall(R.ModeInvoke,"Gamemodes","Join",winner)
        if not ok or not result then R.ModeJoining=nil;R.ModeWinner=nil;state("Modes","Entry not confirmed · retrying while open");return end
        state("Modes","Joining "..winner);return
    end
    if winner=="Culling Game" then
        local def=O.Shared.Gamemodes.List["Culling Game"]
        if not owns(def.MapName) then state("Modes","Culling Game world is locked");return end
        local entryPrice=native(O.Shared.Gamemodes.GetPrice,def)
        local ready=not entryPrice or native(O.Shared.Gamemodes.GetPriceAmount,O.Data,entryPrice)>=entryPrice.Amount
        if not ready then state("Modes","Waiting for Culling Game ticket");return end
        if not R.Party then
            if gate("party-create",15) then fire("Parties","Create","Culling Game") end
            state("Modes","Creating Culling Game party");return
        end
        if R.Party.GamemodeName~="Culling Game" or R.Party.Leader~=Player.UserId then state("Modes","Current party is controlled by another player or mode");return end
        if R.Party.Status=="Running" then
            if gate("party-reset",5) then fire("Parties","Leave") end
            state("Modes","Leaving previous Culling party before creating a new one");return
        end
        if R.Party.Difficulty~=S.CullingDifficulty then fire("Parties","SetDifficulty",S.CullingDifficulty);return end
        local price=native(O.Shared.Gamemodes.GetPrice,def)
        if price and native(O.Shared.Gamemodes.GetPriceAmount,O.Data,price)<price.Amount then state("Modes","Waiting for Culling Game ticket");return end
        if gate("party-start",15) then R.ModeJoining=os.clock();R.Target=nil;R.SpotTargets={};fire("Parties","Start") end
        state("Modes","Starting Culling Game");return
    end
    state("Modes","Waiting for entry window")
end)
R.PotionRequests={}
local function potionRequest(name,action,value,after)
    local token=action..":"..name
    local pending=R.PotionRequests[token]
    if pending then
        if os.clock()-pending.At<8 then return end
        if pending.Thread then pcall(task.cancel,pending.Thread) end
        R.PotionRequests[token]=nil
    end
    if not gate(token,2) then return end
    local request={At=os.clock()};R.PotionRequests[token]=request
    request.Thread=task.spawn(function()
        local ok,result=pcall(invoke,"Marketplace",action,name,value)
        if R.PotionRequests[token]~=request then return end
        R.PotionRequests[token]=nil
        if not ok then R.Errors[token]=tostring(result)
        elseif result==false then R.Errors[token]="Server rejected potion request"
        else R.Errors[token]=nil;if after and R.Alive then after() end end
    end)
    table.insert(R.Jobs,request.Thread)
end
worker("Boosts",.25,function()
    local mode=O.Data.Gamemode
    local key=mode=="Dungeon Easy" and "Dungeon" or mode=="Trial Easy" and "Trial" or mode=="Culling Game" and "Culling" or "World"
    local allowed=S["ActivePotions"..key] or {}
    for name,potion in pairs(O.Data.Commerce.Potions or {}) do
        if (potion.Remaining or 0)>0 then
            if S.PotionRules then
                local pause=not has(allowed,name)
                if (potion.Paused==true)~=pause then potionRequest(name,"SetPotionPaused",pause) end
            elseif S.Boosts and has(S.Potions,name) and potion.Paused then
                potionRequest(name,"SetPotionPaused",false)
            end
        end
    end
    if S.Boosts then
        for _,name in ipairs(S.Potions) do
            if (O.Data.Items.List[name] or 0)>0 then
                potionRequest(name,"UsePotion",false)
            end
        end
    end
    local active,paused,empty,waiting,blocked=0,0,0,0,0
    for _,name in ipairs(S.Potions) do
        local potion=(O.Data.Commerce.Potions or {})[name]
        if S.PotionRules and not has(allowed,name) then blocked=blocked+1 end
            if potion and (potion.Remaining or 0)>0 then
                if potion.Paused then paused=paused+1 else active=active+1 end
            end
            if (O.Data.Items.List[name] or 0)>0 then waiting=waiting+1 else empty=empty+1 end
    end
    state("Boosts",(S.Boosts and "Auto use enabled" or "Auto use disabled").." · "..active.." active · "..paused.." paused · "..waiting.." awaiting use · "..empty.." no stock · "..blocked.." disabled for "..key)
end)
do
    local attempts=setmetatable({},{__mode="k"})
    local notices,seenNotices={},{}
    local function notice(text)
        if not R.Alive or not S.CollectFruits then return end
        local plain=tostring(text):gsub("<[^>]*>",""):lower()
        if not plain:find("spawned",1,true) and not plain:find("appeared",1,true) then return end
        local fruit=plain:find("fruit",1,true)
        for _,cfg in pairs(O.Shared.Fruits.List) do
            for _,item in ipairs(cfg.Fruits) do if plain:find(item.Name:lower(),1,true) then fruit=true end end
        end
        if not fruit then return end
        for _,cfg in pairs(O.Shared.Fruits.List) do
            if plain:find(cfg.MapName:lower(),1,true) and owns(cfg.MapName) then
                local now=os.clock()
                if now-(seenNotices[cfg.MapName] or -1000)<cfg.Lifetime then return end
                seenNotices[cfg.MapName]=now
                notices[cfg.MapName]=now+cfg.Lifetime
                state("Fruits","Spawn notice received: "..cfg.MapName)
            end
        end
    end
    R.FruitSpawnNotice=notice
    do
        local ok,controller=pcall(module,"Scripts.Interface.Notifications")
        if ok and type(controller)=="table" and type(controller.Create)=="function" then
            local original=controller.Create
            local wrapper
            wrapper=function(kind,payload,...)
                if R.Alive and type(payload)=="table" and type(payload.Message)=="string" then
                    local message=payload.Message
                    R.LastGameNotification=message
                    task.defer(function()
                        if R.Alive then local success,err=pcall(notice,message);if not success then R.Errors.FruitNotification=tostring(err) end end
                    end)
                end
                return original(kind,payload,...)
            end
            controller.Create=wrapper
            R.RestoreFruitNotifications=function()if controller.Create==wrapper then controller.Create=original end end
        else R.Errors.FruitNotification="Notification controller unavailable" end
    end
    local watched=setmetatable({},{__mode="k"})
    local function watchLabel(label,readNow)
        if not label:IsA("TextLabel") or label:IsDescendantOf(W.Gui) or watched[label] then return end
        watched[label]=true
        local c=connect(label:GetPropertyChangedSignal("Text"),function()notice(label.Text)end)
        label.Destroying:Once(function()c:Disconnect()end)
        if readNow then notice(label.Text) end
    end
    for _,label in ipairs(Player.PlayerGui:GetDescendants()) do watchLabel(label,false) end
    connect(Player.PlayerGui.DescendantAdded,function(label)watchLabel(label,true)end)
    local function finishVisit()
        R.FruitVisit=nil
    end
    R.EndFruitTrip=function()
        local trip=R.FruitTrip;R.FruitTrip=nil
        local hrp=root()
        if trip and hrp==trip.Root and O.Data.Maps.Current==trip.World and not O.Data.Gamemode then hrp.CFrame=trip.Origin end
    end
    local function promptPosition(prompt)
        local parent=prompt.Parent
        if parent and parent:IsA("Attachment") then return parent.WorldPosition end
        if parent and parent:IsA("BasePart") then return parent.Position end
        if parent and parent:IsA("Model") then return parent:GetPivot().Position end
    end
    worker("Fruits",.25,function()
        if O.Data.Gamemode then
            R.EndFruitTrip();finishVisit();state("Fruits","Waiting until you leave the gamemode");return
        end
        local hrp=root();if not hrp then R.EndFruitTrip();return end
        local visit=R.FruitVisit
        if not S.CollectFruits then
            R.EndFruitTrip()
            if visit then visit.Returning=true else state("Fruits","Disabled");return end
        end
        if visit and visit.Returning then
            if O.Data.Maps.Current~=visit.World then
                if gate("fruitMap",3) then fire("Maps","Teleport",visit.World) end
                state("Fruits","Returning to "..visit.World)
                if os.clock()-visit.At>90 then finishVisit();state("Fruits","Return timed out") end
                return
            end
            visit.ReturnedAt=visit.ReturnedAt or os.clock()
            if os.clock()-visit.ReturnedAt<2 then return end
            hrp.CFrame=visit.Origin;finishVisit();state("Fruits",S.CollectFruits and "Waiting for fruit spawn notice" or "Disabled");return
        end
        if visit then
            local destination=visit.Maps[visit.Index]
            if not destination then visit.Returning=true;return end
            if O.Data.Maps.Current~=destination then
                if os.clock()-visit.StepAt>15 then visit.Index=visit.Index+1;visit.StepAt=os.clock();visit.ArrivedAt=nil;return end
                if gate("fruitMap",3) then fire("Maps","Teleport",destination) end
                state("Fruits","Checking fruit world: "..destination);return
            end
            visit.ArrivedAt=visit.ArrivedAt or os.clock()
            if os.clock()-visit.ArrivedAt<3 then return end
        end
        local trip=R.FruitTrip
        if trip then
            if trip.Root~=hrp or trip.World~=O.Data.Maps.Current then R.EndFruitTrip();return end
            local prompt=trip.Prompt
            if not prompt:IsDescendantOf(workspace) or not prompt.Enabled then
                R.EndFruitTrip();state("Fruits","Fruit no longer available · searching");return
            end
            if os.clock()-trip.At>8 then
                attempts[prompt]=os.clock()+20;R.EndFruitTrip();state("Fruits","Collection not confirmed · retrying later");return
            end
            local position=promptPosition(prompt)
            if not position then R.EndFruitTrip();return end
            hrp.CFrame=CFrame.new(position+Vector3.new(0,2,0))
            if os.clock()-trip.At>=.3 and gate("fruitCollect",1) then fire("Fruits","Collect",prompt:GetAttribute("FruitID")) end
            state("Fruits","Collecting fruit");return
        end
        if not gate("fruitScan",1) then return end
        local nearest,distance
        for _,prompt in ipairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") and prompt.Enabled and type(prompt:GetAttribute("FruitID"))=="string" and os.clock()>=(attempts[prompt] or 0) then
                local position=promptPosition(prompt)
                local dist=position and (position-hrp.Position).Magnitude
                if dist and (not distance or dist<distance) then nearest=prompt;distance=dist end
            end
        end
        if nearest then if not activity("Fruits",true) then state("Fruits","Waiting for general priority");return end;R.FruitTrip={Prompt=nearest,Root=hrp,Origin=hrp.CFrame,World=O.Data.Maps.Current,At=os.clock()}
        elseif visit then
            if os.clock()-visit.ArrivedAt>=6 then
                visit.Index=visit.Index+1;visit.StepAt=os.clock();visit.ArrivedAt=nil
            end
            state("Fruits","Waiting for fruit world to load")
        else
            local maps={}
            for map,expires in pairs(notices) do
                if expires>os.clock() and owns(map) then table.insert(maps,map) end
                if expires<=os.clock() then notices[map]=nil end
            end
            table.sort(maps)
            if #maps>0 then
                if not activity("Fruits",true) then state("Fruits","Waiting for general priority");return end
                for _,map in ipairs(maps) do notices[map]=nil end
                R.FruitVisit={World=O.Data.Maps.Current,Origin=hrp.CFrame,Maps=maps,Index=1,At=os.clock(),StepAt=os.clock()}
            else activity("Fruits",false);state("Fruits","Waiting for fruit spawn notice") end
        end
    end)
end
  function R.AntiIdle()
      if not S.AntiAFK or not R.Alive then return end
      if R.AntiIdleBusy then return end
      R.AntiIdleBusy=true
      local inputOK,inputError=pcall(function()
          local input=game:GetService("VirtualInputManager")
          input:SendKeyEvent(true,Enum.KeyCode.F15,false,game)
          task.wait(.08)
          input:SendKeyEvent(false,Enum.KeyCode.F15,false,game)
      end)
      local virtualOK,virtualError=pcall(function()
          local virtual=game:GetService("VirtualUser")
          virtual:CaptureController()
          local camera=workspace.CurrentCamera
          virtual:Button2Down(Vector2.new(1,1),camera and camera.CFrame or CFrame.new())
          task.wait(.1)
          virtual:Button2Up(Vector2.new(1,1),camera and camera.CFrame or CFrame.new())
      end)
      R.AntiIdleBusy=false
      R.AntiIdleResult={Keyboard=inputOK,VirtualUser=virtualOK,At=os.clock()}
      if inputOK or virtualOK then
          R.Errors.AntiAFK=nil;state("AntiAFK","Activity sent · 30-second cycle")
      else
          R.Errors.AntiAFK=tostring(inputError).." / "..tostring(virtualError)
          state("AntiAFK","Executor blocked simulated input")
      end
  end
  connect(Player.Idled,function()local ok,err=pcall(R.AntiIdle);if not ok then R.Errors.AntiAFK=tostring(err) end end)

worker("AntiAFK",30,R.AntiIdle)
do
 local queue=queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)
 local function queueResume()
  if R.ResumeQueued then return end
  if type(queue)~="function" then
   state("Reconnect","Reconnect available · executor cannot resume the script")
   return
  end
  local snapshot=Http:JSONEncode({UserId=Player.UserId,At=os.time(),Settings=S})
  queue("repeat task.wait(1) until game:IsLoaded()\ngetgenv().DevilHubLegacyResume="..string.format("%q",snapshot).."\nlocal run,err=loadstring(game:HttpGet('https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/devil.lua'));assert(run,err);run()")
  R.ResumeQueued=true
 end
 connect(Player.OnTeleport,function(teleportState)
  if teleportState==Enum.TeleportState.Failed then R.Reconnecting=false;R.ResumeQueued=false
  elseif S.Reconnect then
   local ok,err=pcall(queueResume);if not ok then R.Errors.ReconnectResume=tostring(err) end
  end
 end)
 connect(game:GetService("TeleportService").TeleportInitFailed,function(player)
  if player==Player then R.Reconnecting=false;R.ResumeQueued=false end
 end)
 worker("Reconnect",3,function()
  if not S.Reconnect then state("Reconnect","Disabled");return end
  local core=game:GetService("CoreGui")
  local prompts=core:FindFirstChild("RobloxPromptGui") or core:FindFirstChild("robloxPromptGui")
  local disconnected=false
  if prompts then
   for _,object in ipairs(prompts:GetDescendants()) do
    if object.Name=="ErrorPrompt" and object:IsA("GuiObject") and object.Visible then
     local visible=true;local parent=object.Parent
     while parent and parent~=core do
      if parent:IsA("GuiObject") and not parent.Visible then visible=false end
      if parent:IsA("ScreenGui") and not parent.Enabled then visible=false end
      parent=parent.Parent
     end
     if visible then disconnected=true;break end
    end
   end
  end
  if not disconnected then state("Reconnect",type(queue)=="function" and "Monitoring connection · automatic resume ready" or "Monitoring connection · automatic resume unavailable");return end
  if R.Reconnecting or not gate("ReconnectAttempt",20) then return end
  R.Reconnecting=true;R.ReconnectAttempts=(R.ReconnectAttempts or 0)+1
  local queued,queueError=pcall(queueResume)
  if not queued then R.Errors.ReconnectResume=tostring(queueError) end
  state("Reconnect","Reconnecting · attempt "..R.ReconnectAttempts)
  local ok,err=pcall(function()
   local service=game:GetService("TeleportService")
   if R.ReconnectAttempts==1 and game.JobId~="" then service:TeleportToPlaceInstance(game.PlaceId,game.JobId,Player)
   else service:Teleport(game.PlaceId,Player) end
  end)
  if not ok then R.Reconnecting=false;R.Errors.Reconnect=tostring(err);state("Reconnect","Failed · retrying in 20 seconds") end
  task.delay(15,function()if R.Alive then R.Reconnecting=false end end)
 end)
end

R.Hidden={}
do
    local saved=setmetatable({},{__mode="k"})
    local function hide(object,property,value)
        if not saved[object] then saved[object]={Property=property,Value=object[property]} end
        object[property]=value
    end
    R.RestoreNick=function()
        for object,entry in pairs(saved) do
            if object.Parent then object[entry.Property]=entry.Value end
            saved[object]=nil
        end
    end
    worker("HideNick",.25,function()
        if not S.HideNick then R.RestoreNick();return end
        local character=Player.Character
        if not character then return end
        local humanoid=character:FindFirstChildOfClass("Humanoid")
        if humanoid then hide(humanoid,"NameDisplayDistance",0) end
        for _,object in ipairs(character:GetDescendants()) do
            if object:IsA("TextLabel") and object:FindFirstAncestorWhichIsA("BillboardGui") then
                local text=object.Text:gsub("<[^>]*>",""):gsub("^%s+",""):gsub("%s+$","")
                if text==Player.Name or text==Player.DisplayName or text=="@"..Player.Name then hide(object,"Visible",false) end
            end
        end
    end)
end
do
    local hidden=setmetatable({},{__mode="k"})
    local function isTestingNotice(text)
        local normalized=tostring(text):gsub("<[^>]*>",""):upper():gsub("[^A-Z]","")
        return normalized:find("THISGAMEISSTILLBEINGTESTED",1,true)
            or normalized:find("BUGSAREEXPECTED",1,true)
            or normalized:find("BALANCEMENTISNTDONEYET",1,true)
    end
    R.RestoreTestingNotice=function()
        for label,visible in pairs(hidden) do
            if label.Parent then label.Visible=visible end
        end
        table.clear(hidden)
    end
    worker("TestingNotice",.5,function()
        for _,label in ipairs(Player.PlayerGui:GetDescendants()) do
            if (label:IsA("TextLabel") or label:IsA("TextButton")) and not label:IsDescendantOf(W.Gui) then
                if isTestingNotice(label.Text) then
                    if hidden[label]==nil then hidden[label]=label.Visible end
                    label.Visible=false
                elseif hidden[label]~=nil then
                    label.Visible=hidden[label];hidden[label]=nil
                end
            end
        end
    end)
end
worker("Visual",1,function()
    if S.HideGame then
        for _,gui in ipairs(Player.PlayerGui:GetChildren()) do if gui:IsA("ScreenGui") and gui~=W.Gui then if R.Hidden[gui]==nil then R.Hidden[gui]=gui.Enabled end;gui.Enabled=false end end
    else for gui,value in pairs(R.Hidden) do if gui.Parent then gui.Enabled=value end;R.Hidden[gui]=nil end end
end)
worker("Interface",1,function()
    for key,label in pairs(labels) do label.Text=R.Status[key] or "Disabled" end
    local n=0;for _ in pairs(R.Errors) do n+=1 end
    if n>0 then labels.Config.Text=tostring(n).." errors · use Copy Diagnostics" end
end)
R.Ready=true
R.LoadStartupConfig()
connect(W.Gui.Destroying,R.Stop)
return R
end, debug.traceback)
if not success then
    local env = getgenv()
    local runtime = env.DevilHubLegacy
    if runtime and runtime.Stop then pcall(runtime.Stop) end
    notify("Unable to start Devil Hub. Check the console.")
    warn("[Devil Hub] " .. tostring(result))
    return
end
-- Retain the original Legacy post-load integration.
pcall(function()
    local source = game:HttpGet("https://raw.githubusercontent.com/itachidevrs/gg/refs/heads/main/gg2")
    local run, err = loadstring(source, "Devil Hub / Legacy integration")
    assert(run, err)
    run()
end)
return result
