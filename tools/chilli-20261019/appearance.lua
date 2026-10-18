-- Controls the visible OuroFlow window. Native game callbacks stay untouched.
return function(library,window,tab,panels,env)
    local defaults=table.clone(library.Theme)
    local baseWidth,baseHeight=880,520
    local settings={Scale=100,Accent=defaults.Accent,Background=defaults.Background}
    local file="DevilHub-StealAnEgg-appearance.json"
    local http=game:GetService("HttpService")
    local function color(value,fallback)
        if type(value)~="table" then return fallback end
        for i=1,3 do if type(value[i])~="number" or value[i]~=value[i] then return fallback end end
        return Color3.fromRGB(math.clamp(value[1],0,255),math.clamp(value[2],0,255),math.clamp(value[3],0,255))
    end
    if type(isfile)=="function" and type(readfile)=="function" then
        pcall(function()
            if not isfile(file) then return end
            local saved=http:JSONDecode(readfile(file))
            if type(saved)~="table" then return end
            if type(saved.Scale)=="number" and saved.Scale==saved.Scale then settings.Scale=math.clamp(saved.Scale,60,140) end
            settings.Accent=color(saved.Accent,settings.Accent)
            settings.Background=color(saved.Background,settings.Background)
        end)
    end
    local function rgb(c)return {math.floor(c.R*255+.5),math.floor(c.G*255+.5),math.floor(c.B*255+.5)}end
    local function save()
        env.DevilChilliAppearance={Scale=settings.Scale,Accent=rgb(settings.Accent),Background=rgb(settings.Background)}
        if type(writefile)=="function" then pcall(function()writefile(file,http:JSONEncode(env.DevilChilliAppearance))end)end
    end
    local function apply()
        library:SetTheme({Accent=settings.Accent,Background=settings.Background},true)
        window:SetSize(Vector2.new(baseWidth*settings.Scale/100,baseHeight*settings.Scale/100),true)
        for _,panel in ipairs(panels)do
            if panel.Native and type(panel.Native.SetStyle)=="function" then
                pcall(panel.Native.SetStyle,panel.Native,{BackgroundColor=settings.Background,StrokeColor=settings.Accent})
            end
        end
    end
    local group=tab:CreateGroupbox({Name="DEVIL HUB Appearance",Side="Right"})
    local scale=group:CreateSlider({Name="GUI Size (%)",Range={60,140},Increment=5,CurrentValue=settings.Scale,
        Callback=function(value)settings.Scale=math.clamp(tonumber(value)or 100,60,140);apply();save()end})
    local accent=group:ColorPicker({Name="Accent Color",Default=settings.Accent,
        Callback=function(value)if typeof(value)=="Color3"then settings.Accent=value;apply();save()end end})
    local background=group:ColorPicker({Name="Background Color",Default=settings.Background,
        Callback=function(value)if typeof(value)=="Color3"then settings.Background=value;apply();save()end end})
    group:CreateButton({Name="Reset Appearance",Callback=function()
        settings.Scale=100;settings.Accent=defaults.Accent;settings.Background=defaults.Background
        if scale.Set then scale:Set(100)end
        if accent.Set then accent:Set(settings.Accent)end
        if background.Set then background:Set(settings.Background)end
        apply();save()
    end})
    apply()
    return settings
end
