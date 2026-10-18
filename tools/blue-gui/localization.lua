-- Render two-tone/translated labels in non-interactive overlays. The engine's original
-- Text, identifiers, input values and callbacks remain untouched.
-- PHRASES INSERTED HERE
local thai,english={},{}
for _,pair in ipairs(phrasePairs)do thai[pair[1]:lower()]=pair[2];english[pair[2]]=english[pair[2]]or pair[1]end
local localized={}
local function translate(text)
    if type(text)~="string"or text==""then return text end
    if settings.Language=="EN"then return english[text]or text end
    local clean=text:find("<",1,true)and text:gsub("<[^>]+>","")or text
    local replacement=thai[clean:lower()]
    if replacement then return replacement end
    for _,pair in ipairs({{"Status: ","สถานะ: "},{"GUI size: ","ขนาด GUI: "},{"Selected: ","เลือก: "},
        {"Loading ","กำลังโหลด "},{"Downloading ","กำลังดาวน์โหลด "}})do
        if clean:sub(1,#pair[1]):lower()==pair[1]:lower()then return pair[2]..clean:sub(#pair[1]+1)end
    end
    return text
end
local function clearOverlay(node,record)
    for _,link in ipairs(record.StyleLinks)do link:Disconnect()end
    table.clear(record.StyleLinks)
    if record.Overlay then
        pcall(function()node.TextTransparency=record.Transparency end)
        record.Overlay:Destroy();record.Overlay=nil
    end
end
local function localize(node)
    if localized[node]or node:GetAttribute("DevilLocalizationOverlay")then return end
    if not node:IsA("TextLabel")and not node:IsA("TextButton")then return end
    local record={Links={},StyleLinks={}}
    localized[node]=record
    function record.Update()
        if controller.Stopped or not node.Parent then return end
        local value=translate(node.Text)
        if value==""then clearOverlay(node,record);return end
        if not record.Overlay then
            if node:FindFirstChildOfClass("UIListLayout")or node:FindFirstChildOfClass("UIGridLayout")then return end
            local overlay=Instance.new("TextLabel")
            overlay.Name="DevilTranslatedLabel";overlay:SetAttribute("DevilLocalizationOverlay",true)
            overlay.BackgroundTransparency=1;overlay.BorderSizePixel=0;overlay.Active=false;overlay.Selectable=false
            overlay.Position=UDim2.fromOffset(0,0);overlay.Size=UDim2.fromScale(1,1)
            -- Gradients live only on transparent text, never on a button's background.
            local function sync(key)pcall(function()
                if key=="TextColor3"then overlay[key]=white
                elseif key=="TextStrokeTransparency"then overlay[key]=1
                else overlay[key]=node[key]end
            end)end
            for _,key in ipairs({"Font","FontFace","TextSize","TextScaled","TextWrapped","TextXAlignment","TextYAlignment",
                "TextColor3","TextStrokeColor3","TextStrokeTransparency","RichText","LineHeight","TextTruncate"})do
                sync(key);keep(node:GetPropertyChangedSignal(key),function()sync(key)end,record.StyleLinks)
            end
            local tone=Instance.new("UIGradient");tone.Name="DevilTextTone"
            tone:SetAttribute("DevilLocalizationOverlay",true)
            tone.Color=ColorSequence.new(palette.Blue,white);tone.Rotation=0;tone.Parent=overlay
            local padding=node:FindFirstChildOfClass("UIPadding")
            if padding then
                local clone=Instance.new("UIPadding");clone:SetAttribute("DevilLocalizationOverlay",true)
                for _,key in ipairs({"PaddingLeft","PaddingRight","PaddingTop","PaddingBottom"})do
                    clone[key]=padding[key]
                    keep(padding:GetPropertyChangedSignal(key),function()clone[key]=padding[key]end,record.StyleLinks)
                end
                clone.Parent=overlay
            end
            local function layer()overlay.ZIndex=(node.ZIndex or 1)+1 end
            layer();keep(node:GetPropertyChangedSignal("ZIndex"),layer,record.StyleLinks)
            record.Transparency=tonumber(node.TextTransparency)or 0
            overlay.TextTransparency=math.clamp(record.Transparency,0,1)^2
            record.Overlay=overlay
            node.TextTransparency=1
            keep(node:GetPropertyChangedSignal("TextTransparency"),function()
                if node.TextTransparency==1 then return end
                record.Transparency=node.TextTransparency;overlay.TextTransparency=math.clamp(record.Transparency,0,1)^2;node.TextTransparency=1
            end,record.StyleLinks)
            overlay.Parent=node
        end
        -- Inline font colors must not multiply or cover the shared text gradient.
        record.Overlay.Text=node.RichText and value:gsub('(<font[^>]-)%s+[cC][oO][lL][oO][rR]%s*=%s*["\'][^"\']+["\']',"%1")or value
    end
    keep(node:GetPropertyChangedSignal("Text"),record.Update,record.Links)
    keep(node.ChildAdded,function(child)
        if child:IsA("UIListLayout")or child:IsA("UIGridLayout")then clearOverlay(node,record)
        elseif child:IsA("UIPadding")then clearOverlay(node,record);record.Update()end
    end,record.Links)
    keep(node.Destroying,function()
        for _,link in ipairs(record.Links)do link:Disconnect()end
        clearOverlay(node,record);localized[node]=nil
    end,record.Links)
    record.Update()
end
