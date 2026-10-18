createUI=function(screen)
    if screen.Name=="DevilHubLoading"or ui[screen]then return end
    local root,area
    for _,child in ipairs(screen:GetChildren())do if child:IsA("GuiObject")and not child:GetAttribute("DevilBlueSettings")then
        local size=child.AbsoluteSize;local value=size.X*size.Y
        if value>40000 and(not area or value>area)then root,area=child,value end
    end end
    if not root then return end
    local function make(class,props,parent)
        local node=Instance.new(class);node:SetAttribute("DevilBlueSettings",true)
        for key,value in pairs(props)do node[key]=value end;node.Parent=parent;return node
    end
    local host=make("Frame",{Name="DevilLanguageSelector",BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0),
        Position=UDim2.new(1,-88,0,10),Size=UDim2.fromOffset(96,26),ZIndex=100},root)
    local button=make("TextButton",{Name="LanguageSelect",Size=UDim2.fromScale(1,1),BorderSizePixel=0,
        BackgroundColor3=palette.Background,BackgroundTransparency=.12,Font=Enum.Font.GothamSemibold,TextSize=12,ZIndex=101},host)
    make("UICorner",{CornerRadius=UDim.new(0,6)},button)
    make("UIStroke",{Color=palette.Accent,Transparency=.65,Thickness=1},button)
    local menu=make("Frame",{Name="LanguageOptions",Visible=false,Position=UDim2.fromOffset(0,30),Size=UDim2.fromOffset(96,64),
        BackgroundColor3=palette.Background,BackgroundTransparency=.08,BorderSizePixel=0,ZIndex=102},host)
    make("UICorner",{CornerRadius=UDim.new(0,6)},menu)
    make("UIStroke",{Color=palette.Accent,Transparency=.6,Thickness=1},menu)
    for index,option in ipairs({{"EN","English"},{"TH","ไทย"}})do
        local choice=make("TextButton",{Name="Language"..option[1],Text=option[2],Position=UDim2.fromOffset(4,(index-1)*30+2),
            Size=UDim2.fromOffset(88,28),BackgroundTransparency=1,TextColor3=white,Font=Enum.Font.GothamSemibold,TextSize=13,ZIndex=103},menu)
        keep(choice.Activated,function()controller.SetLanguage(option[1]);menu.Visible=false end)
    end
    keep(button.Activated,function()menu.Visible=not menu.Visible end)
    local function sync()
        button.Text=settings.Language=="TH"and"ไทย  v"or"EN  v"
        button.TextColor3=palette.Accent
    end
    ui[screen]={Frame=host,Update=sync}
    keep(host.Destroying,function()ui[screen]=nil end)
    function controller.Open()menu.Visible=true end
    refreshUI=function()for _,panel in pairs(ui)do panel.Update()end end
    sync()
end
