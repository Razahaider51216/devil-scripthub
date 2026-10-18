createUI=function(screen)
    if screen.Name=="DevilHubLoading"then return end
    local root,area
    for _,child in ipairs(screen:GetChildren())do if child:IsA("GuiObject")and not child:GetAttribute("DevilBlueSettings")then
        local size=child.AbsoluteSize;local value=size.X*size.Y
        if value>40000 and(not area or value>area)then root,area=child,value end
    end end
    if not root then return end
    local sidebar,tabs
    for _,node in ipairs(root:GetDescendants())do
        if node.Name=="Sidebar"and node:IsA("GuiObject")then
            local list=node:FindFirstChild("Tabs")or node:FindFirstChild("TabList")
            if list and list:IsA("GuiObject")then sidebar,tabs=node,list;break end
        end
    end
    local previous=ui[screen]
    if previous then
        if previous.Root==root and previous.Dock==sidebar then previous.Reflow();return end
        previous.Frame:Destroy()
    end
    local panelLinks,geometry={},{}
    local function make(class,props,parent)
        local node=Instance.new(class);node:SetAttribute("DevilBlueSettings",true)
        for key,value in pairs(props)do node[key]=value end;node.Parent=parent;return node
    end
    local function reserve(node,key,transform)
        geometry[node]=geometry[node]or{}
        if geometry[node][key]then return end
        local record={Source=node[key]};geometry[node][key]=record
        local function apply()
            record.Applied=transform(record.Source)
            if node[key]~=record.Applied then node[key]=record.Applied end
        end
        keep(node:GetPropertyChangedSignal(key),function()
            if node[key]==record.Applied then return end
            record.Source=node[key];apply()
        end,panelLinks)
        apply()
    end
    local rowHeight=40
    local host=make("Frame",{Name="DevilLanguageSelector",BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.new(1,-16,0,32),
        Position=UDim2.fromOffset(8,0),ZIndex=100},sidebar or root)
    local function reflow()
        if sidebar then
            reserve(tabs,"Position",function(p)return UDim2.new(p.X.Scale,p.X.Offset,p.Y.Scale,p.Y.Offset+rowHeight)end)
            reserve(tabs,"Size",function(s)return UDim2.new(s.X.Scale,s.X.Offset,s.Y.Scale,s.Y.Offset-rowHeight)end)
            local original=geometry[tabs].Position.Source
            host.Position=UDim2.new(0,8,original.Y.Scale,original.Y.Offset+2)
        else
            -- Reserve an actual row for libraries without a Sidebar; no overlay on native controls.
            host.Position=UDim2.fromOffset(12,4);host.Size=UDim2.new(1,-24,0,32)
            for _,child in ipairs(root:GetChildren())do
                if child:IsA("GuiObject")and not child:GetAttribute("DevilBlueSettings")and not launcher(child)then
                    reserve(child,"Position",function(p)return UDim2.new(p.X.Scale,p.X.Offset,p.Y.Scale,p.Y.Offset+rowHeight*(1-p.Y.Scale))end)
                    reserve(child,"Size",function(s)return UDim2.new(s.X.Scale,s.X.Offset,s.Y.Scale,s.Y.Offset-rowHeight*s.Y.Scale)end)
                end
            end
        end
    end
    local button=make("TextButton",{Name="LanguageSelect",Size=sidebar and UDim2.fromScale(1,1)or UDim2.fromOffset(112,32),
        AnchorPoint=sidebar and Vector2.new(0,0)or Vector2.new(1,0),Position=sidebar and UDim2.fromOffset(0,0)or UDim2.fromScale(1,0),
        BorderSizePixel=0,AutoButtonColor=false,Text="",BackgroundColor3=palette.Surface,BackgroundTransparency=1,
        Font=Enum.Font.GothamSemibold,TextSize=13,ZIndex=101},host)
    make("UICorner",{CornerRadius=UDim.new(0,8)},button)
    local caption=make("TextLabel",{Name="LanguageCaption",BackgroundTransparency=1,BorderSizePixel=0,
        Size=UDim2.new(1,-20,1,0),TextColor3=white,Font=Enum.Font.GothamSemibold,TextSize=13,ZIndex=102},button)
    make("UIGradient",{Color=ColorSequence.new(palette.Blue,white),Rotation=0},caption)
    -- Draw the dropdown arrow; a Unicode arrow can display as a missing-glyph square.
    for index,rotation in ipairs({45,-45})do
        make("Frame",{Name="LanguageChevron"..index,Size=UDim2.fromOffset(5,2),AnchorPoint=Vector2.new(.5,.5),
            Position=UDim2.new(1,index==1 and -15 or -12,.5,0),Rotation=rotation,
            BackgroundColor3=palette.Accent,BorderSizePixel=0,ZIndex=102},button)
    end
    keep(button.MouseEnter,function()button.BackgroundTransparency=.3 end,panelLinks)
    keep(button.MouseLeave,function()button.BackgroundTransparency=1 end,panelLinks)
    local label
    if not sidebar then label=make("TextLabel",{Name="LanguageLabel",Text="Language",BackgroundTransparency=1,
        Size=UDim2.new(1,-124,1,0),TextXAlignment=Enum.TextXAlignment.Left,TextColor3=white,
        Font=Enum.Font.GothamSemibold,TextSize=13,ZIndex=101},host)end
    local menu=make("Frame",{Name="LanguageOptions",Visible=false,Position=UDim2.new(button.Position.X.Scale,button.Position.X.Offset,0,38),
        AnchorPoint=button.AnchorPoint,Size=sidebar and UDim2.new(1,0,0,72)or UDim2.fromOffset(112,72),
        BackgroundColor3=palette.Background,BackgroundTransparency=.04,BorderSizePixel=0,ZIndex=102},host)
    make("UICorner",{CornerRadius=UDim.new(0,8)},menu)
    make("UIStroke",{Color=palette.Accent,Transparency=.6,Thickness=1},menu)
    local choices={}
    for index,option in ipairs({{"EN","English"},{"TH","ไทย"}})do
        local choice=make("TextButton",{Name="Language"..option[1],Text=option[2],Position=UDim2.fromOffset(4,(index-1)*32+4),
            Size=UDim2.new(1,-8,0,28),BackgroundColor3=palette.Surface2,BackgroundTransparency=1,BorderSizePixel=0,
            AutoButtonColor=false,TextColor3=white,Font=Enum.Font.GothamSemibold,TextSize=13,ZIndex=103},menu)
        make("UICorner",{CornerRadius=UDim.new(0,6)},choice)
        choices[option[1]]=choice
        keep(choice.Activated,function()controller.SetLanguage(option[1]);menu.Visible=false end,panelLinks)
        keep(choice.MouseEnter,function()choice.BackgroundTransparency=.15 end,panelLinks)
        keep(choice.MouseLeave,function()choice.BackgroundTransparency=settings.Language==option[1]and 0 or 1 end,panelLinks)
    end
    keep(button.Activated,function()menu.Visible=not menu.Visible end,panelLinks)
    keep(root:GetPropertyChangedSignal("Visible"),function()if not root.Visible then menu.Visible=false end end,panelLinks)
    local function sync()
        caption.Text=settings.Language=="TH"and"ไทย"or"English"
        if label then label.Text=settings.Language=="TH"and"ภาษา"or"Language"end
        for code,choice in pairs(choices)do
            local selected=code==settings.Language
            choice.TextColor3=selected and palette.Accent or white
            choice.BackgroundTransparency=selected and 0 or 1
        end
    end
    local cleaned=false
    local function cleanup()
        if cleaned then return end;cleaned=true
        for _,link in ipairs(panelLinks)do link:Disconnect()end
        for node,properties in pairs(geometry)do for key,record in pairs(properties)do
            pcall(function()if node[key]==record.Applied then node[key]=record.Source end end)
        end end
        ui[screen]=nil
    end
    ui[screen]={Frame=host,Root=root,Dock=sidebar,Update=sync,Reflow=reflow,Cleanup=cleanup}
    keep(host.Destroying,cleanup,panelLinks)
    function controller.Open()menu.Visible=true end
    refreshUI=function()for _,panel in pairs(ui)do panel.Update()end end
    reflow();sync()
end
