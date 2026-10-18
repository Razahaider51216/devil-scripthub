local function createUI(parent)
    if ui then return end
    ui=Instance.new("ScreenGui");ui.Name="DevilBlueAppearance";ui.ResetOnSpawn=false;ui.DisplayOrder=10020
    ui:SetAttribute("DevilBlueSettings",true);ui.Parent=parent
    local function make(class,props,host)
        local node=Instance.new(class);for key,value in pairs(props)do node[key]=value end;node.Parent=host;return node
    end
    local function round(node,radius)make("UICorner",{CornerRadius=UDim.new(0,radius)},node)end
    local button=make("TextButton",{Name="AppearanceButton",AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-16,1,-16),
        Size=UDim2.fromOffset(116,34),Text="GUI / Colors",Font=Enum.Font.GothamSemibold,TextSize=13,BorderSizePixel=0},ui);round(button,9)
    local card=make("Frame",{Name="AppearancePanel",Visible=false,AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-16,1,-58),
        Size=UDim2.fromOffset(294,288),BorderSizePixel=0},ui);round(card,12)
    local heading=make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,12),Size=UDim2.fromOffset(260,24),
        Text="DEVIL HUB / GUI",Font=Enum.Font.GothamBold,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left},card)
    local panelScale=make("UIScale",{Name="PanelViewportScale",Scale=1},card)
    pcall(function()
        local camera=workspace.CurrentCamera
        local function fit()
            local viewport=camera.ViewportSize
            panelScale.Scale=math.clamp(math.min((viewport.X-28)/294,(viewport.Y-84)/288),.5,1)
        end
        fit();keep(camera:GetPropertyChangedSignal("ViewportSize"),fit)
    end)
    make("TextLabel",{Name="LanguageLabel",BackgroundTransparency=1,Position=UDim2.fromOffset(16,50),Size=UDim2.fromOffset(124,28),
        Text="Language / ภาษา",Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},card)
    local language=make("TextButton",{Name="LanguageSelect",Position=UDim2.fromOffset(144,50),Size=UDim2.fromOffset(134,28),
        Font=Enum.Font.GothamSemibold,TextSize=13,BorderSizePixel=0},card);round(language,6)
    local menu=make("Frame",{Name="LanguageOptions",Visible=false,Position=UDim2.fromOffset(144,80),Size=UDim2.fromOffset(134,64),
        BackgroundColor3=palette.Surface2,BorderSizePixel=0,ZIndex=20},card);round(menu,6)
    for index,option in ipairs({{"EN","English"},{"TH","ไทย"}})do
        local choice=make("TextButton",{Name="Language"..option[1],Text=option[2],Position=UDim2.fromOffset(4,(index-1)*30+2),
            Size=UDim2.fromOffset(126,28),BackgroundTransparency=1,Font=Enum.Font.GothamSemibold,TextSize=13,ZIndex=21},menu)
        keep(choice.Activated,function()controller.Set({Language=option[1]});menu.Visible=false end)
    end
    keep(language.Activated,function()menu.Visible=not menu.Visible end)
    local function input(label,name,y,value)
        local caption=make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,y),Size=UDim2.fromOffset(120,28),Text=label,
            Font=Enum.Font.Gotham,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},card)
        caption:SetAttribute("DevilUiEnglish",label)
        local box=make("TextBox",{Name=name,Position=UDim2.fromOffset(144,y),Size=UDim2.fromOffset(134,28),Text=value,
            ClearTextOnFocus=false,Font=Enum.Font.Code,TextSize=14,BorderSizePixel=0},card);round(box,6);return box
    end
    local accent=input("Light blue / Accent","AccentInput",90,settings.Accent)
    local background=input("Dark background","BackgroundInput",128,settings.Background)
    local scaleLabel=make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(61,170),Size=UDim2.fromOffset(172,30),
        Font=Enum.Font.GothamSemibold,TextSize=14},card)
    local function action(text,x,y,width,fn)
        local node=make("TextButton",{Name=text,Text=text,Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(width,30),
            Font=Enum.Font.GothamSemibold,TextSize=13,BorderSizePixel=0},card)
        node:SetAttribute("DevilUiEnglish",text);round(node,6);keep(node.Activated,fn);return node
    end
    action("-",16,170,36,function()controller.Set({Scale=settings.Scale-10})end)
    action("+",242,170,36,function()controller.Set({Scale=settings.Scale+10})end)
    local feedback=make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,208),Size=UDim2.fromOffset(262,18),
        Text="Saved for all supported games",Font=Enum.Font.Gotham,TextSize=11},card)
    action("Apply",16,238,126,function()
        if not hex(accent.Text)or not hex(background.Text)then feedback.Text=translate("Use 6 hex digits, e.g. #75CEFF");return end
        controller.Set({Accent=accent.Text,Background=background.Text});feedback.Text=translate("Saved for all supported games")
    end)
    action("Reset",152,238,126,function()
        controller.Set({Accent=defaults.Accent,Background=defaults.Background,Scale=100})
        feedback.Text=translate("Default blue theme restored")
    end)
    function controller.Open()card.Visible=true end
    keep(button.Activated,function()card.Visible=not card.Visible end)
    refreshUI=function()
        button.BackgroundColor3=palette.Surface2;button.TextColor3=palette.Accent;button.Text=translate("GUI / Colors")
        card.BackgroundColor3=palette.Background;menu.BackgroundColor3=palette.Surface2
        heading.TextColor3=white;scaleLabel.Text=translate("GUI size: ")..math.floor(settings.Scale).."%"
        accent.Text=settings.Accent;background.Text=settings.Background
        language.Text=settings.Language=="TH"and"ไทย  ▾"or"English  ▾"
        feedback.Text=translate("Saved for all supported games")
        for _,node in ipairs(card:GetDescendants())do
            if node:IsA("TextBox")or node:IsA("TextButton")then node.BackgroundColor3=palette.Surface2;node.TextColor3=white
            elseif node:IsA("TextLabel")then node.TextColor3=node==heading and white or palette.Accent end
            local source=node:GetAttribute("DevilUiEnglish");if source then node.Text=translate(source)end
        end
    end
    refreshUI()
end
