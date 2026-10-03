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
