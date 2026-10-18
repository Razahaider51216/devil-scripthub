-- Shared presentation only. Game callbacks, network APIs and compiler environments stay original.
local scope=type(getgenv)=="function"and getgenv()or _G
local VERSION="devil-blue-20261019-1"
if scope.DevilHubBlueGui and scope.DevilHubBlueGui.Version==VERSION and not scope.DevilHubBlueGui.Stopped then return scope.DevilHubBlueGui end
if scope.DevilHubBlueGui and scope.DevilHubBlueGui.Destroy then scope.DevilHubBlueGui.Destroy()end
local controller={Version=VERSION,Stopped=false,Report={screens=0,nodes=0,callbacksReplaced=0}}
scope.DevilHubBlueGui=controller
local white=Color3.fromRGB(247,252,255)
local defaults={Accent="#75CEFF",Background="#071B34",Scale=100}
local settings=table.clone(defaults)
local configFile="DevilHub-BlueGUI.json"
local links,tracked,owned,states,scales={},{},{},{},{}
local ui,refreshUI,refreshAll
local http=game:GetService("HttpService")
local function hex(text)
    if type(text)~="string"then return nil end
    local r,g,b=text:match("^#?(%x%x)(%x%x)(%x%x)$")
    if not r then return nil end
    return Color3.fromRGB(tonumber(r,16),tonumber(g,16),tonumber(b,16))
end
local function valid(input)
    if type(input)~="table"then return end
    for _,key in ipairs({"Accent","Background"})do if hex(input[key])then settings[key]="#"..input[key]:gsub("#",""):upper()end end
    if type(input.Scale)=="number"and input.Scale==input.Scale then settings.Scale=math.clamp(input.Scale,60,140)end
end
if type(readfile)=="function"and type(isfile)=="function"then pcall(function()if isfile(configFile)then valid(http:JSONDecode(readfile(configFile)))end end)end
local palette={}
local function updatePalette()
    palette.Accent=hex(settings.Accent);palette.Background=hex(settings.Background)
    palette.Surface=palette.Background:Lerp(palette.Accent,.12)
    palette.Surface2=palette.Background:Lerp(palette.Accent,.23)
end
updatePalette()
local function keep(signal,fn,bag)
    local link=signal:Connect(fn);table.insert(bag or links,link);return link
end
local function save()
    if type(writefile)=="function"then pcall(function()writefile(configFile,http:JSONEncode(settings))end)end
end
local function brightness(c)return math.max(c.R,c.G,c.B)end
local function saturation(c)return math.max(c.R,c.G,c.B)-math.min(c.R,c.G,c.B)end
local function title(text)
    text=tostring(text):gsub("<[^>]+>",""):upper()
    return text=="DEVIL HUB"or text:sub(1,12)=="DEVIL HUB / "
end
local function logo(node)
    local name=node.Name:lower()
    local image=node.Image
    return name=="logo"or name=="brandlogo"or name=="devillogo"or
        (type(image)=="string"and(image:find("devil-logo",1,true)or image:find("DevilHub_Silver",1,true)or
        (scope.DevilHubSilverLogo and image==scope.DevilHubSilverLogo)))
end
local function target(node,key,source)
    local name=node.Name:lower()
    if key=="TextColor3"then
        if title(node.Text)then return white end
        return (saturation(source)>.1 or brightness(source)<.8)and palette.Accent or white
    elseif key=="Text"then
        return (source:gsub('(<font[^>]-color%s*=%s*["\'])[^"\']+(["\'])',"%1"..settings.Accent.."%2"))
    elseif key=="ImageColor3"then return logo(node)and white or palette.Accent
    elseif key=="ScrollBarImageColor3"or key=="Color"and node:IsA("UIStroke")then return palette.Accent
    elseif key=="Color"and node:IsA("UIGradient")then
        local parent=node.Parent
        if parent and(parent:IsA("TextLabel")or parent:IsA("TextButton"))then return ColorSequence.new(white,palette.Accent)end
        local value=source.Keypoints[1].Value
        return brightness(value)>.5 and saturation(value)>.15 and ColorSequence.new(palette.Surface2,palette.Accent)
            or ColorSequence.new(palette.Background,palette.Surface)
    elseif key=="BackgroundColor3"then
        if node:IsA("TextBox")then return palette.Surface end
        if name:find("toggle",1,true)or name:find("switch",1,true)or name:find("slider",1,true)then
            return brightness(source)>.48 and palette.Accent or palette.Surface2
        end
        if name:find("tab",1,true)or name:find("nav",1,true)or name:find("option",1,true)or node:IsA("TextButton")then return palette.Surface2 end
        return brightness(source)>.45 and saturation(source)>.15 and palette.Surface2 or palette.Background
    end
    return source
end
local function applyProperty(node,state,key)
    if controller.Stopped or not node.Parent then return end
    local value=target(node,key,state.Source[key])
    state.Applied[key]=value
    if node[key]~=value then node[key]=value end
end
local function observe(node,state,key)
    state.Source[key]=node[key]
    applyProperty(node,state,key)
    keep(node:GetPropertyChangedSignal(key),function()
        if controller.Stopped or node[key]==state.Applied[key]then return end
        state.Source[key]=node[key]
        applyProperty(node,state,key)
    end,state.Links)
end
local function patch(node)
    if states[node]then return end
    local keys={}
    if node:IsA("GuiObject")then
        if node:IsA("Frame")or node:IsA("TextButton")or node:IsA("TextBox")or node:IsA("ScrollingFrame")then table.insert(keys,"BackgroundColor3")end
        if node:IsA("TextLabel")or node:IsA("TextButton")or node:IsA("TextBox")then
            table.insert(keys,"TextColor3")
            if node.RichText then table.insert(keys,"Text")end
        end
        if node:IsA("ScrollingFrame")then table.insert(keys,"ScrollBarImageColor3")end
        if node:IsA("ImageLabel")or node:IsA("ImageButton")then
            local name=node.Name:lower()
            local parentName=node.Parent and node.Parent.Name:lower()or ""
            local navigation=parentName:find("tab",1,true)or parentName:find("nav",1,true)or parentName:find("sidebar",1,true)
            if logo(node)or name=="tabicon"or name=="navicon"or name=="icon"and navigation then table.insert(keys,"ImageColor3")end
        end
    elseif node:IsA("UIStroke")or node:IsA("UIGradient")then table.insert(keys,"Color")end
    if #keys==0 then return end
    local state={Source={},Applied={},Links={}};states[node]=state
    controller.Report.nodes+=1
    for _,key in ipairs(keys)do observe(node,state,key)end
    keep(node.Destroying,function()
        for _,link in ipairs(state.Links)do link:Disconnect()end
        states[node]=nil
    end,state.Links)
    if node:IsA("ImageLabel")or node:IsA("ImageButton")then
        keep(node:GetPropertyChangedSignal("Image"),function()applyProperty(node,state,"ImageColor3")end,state.Links)
    end
end
local function scaleScreen(screen)
    if screen.Name=="DevilHubLoading"then return end
    local root,area
    for _,child in ipairs(screen:GetChildren())do if child:IsA("GuiObject")then
        local size=child.AbsoluteSize;local nextArea=size.X*size.Y
        if nextArea>40000 and(not area or nextArea>area)then root,area=child,nextArea end
    end end
    if not root then return end
    local state=scales[screen]
    if state and state.Root~=root then
        state.Link:Disconnect()
        if state.Created then state.Node:Destroy()else state.Node.Scale=state.Base end
        scales[screen]=nil;state=nil
    end
    if not state then
        local node=root:FindFirstChildOfClass("UIScale")
        local inserted=node==nil
        if not node then node=Instance.new("UIScale");node.Name="DevilBlueScale";node.Parent=root end
        state={Root=root,Node=node,Base=node.Scale,Created=inserted};scales[screen]=state
        state.Link=keep(node:GetPropertyChangedSignal("Scale"),function()
            if controller.Stopped or node.Scale==state.Applied then return end
            state.Base=node.Scale;state.Applied=state.Base*settings.Scale/100;node.Scale=state.Applied
        end)
    end
    state.Applied=state.Base*settings.Scale/100;state.Node.Scale=state.Applied
end
local function createUI(parent)
    if ui then return end
    ui=Instance.new("ScreenGui");ui.Name="DevilBlueAppearance";ui.ResetOnSpawn=false;ui.DisplayOrder=10020
    ui:SetAttribute("DevilBlueSettings",true)
    ui.Parent=parent
    local function make(class,props,host)
        local node=Instance.new(class)
        for key,value in pairs(props)do node[key]=value end
        node.Parent=host;return node
    end
    local function round(node,radius)make("UICorner",{CornerRadius=UDim.new(0,radius)},node)end
    local button=make("TextButton",{Name="AppearanceButton",AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-16,1,-16),
        Size=UDim2.fromOffset(116,34),Text="GUI / Colors",Font=Enum.Font.GothamSemibold,TextSize=13,BorderSizePixel=0},ui);round(button,9)
    local card=make("Frame",{Name="AppearancePanel",Visible=false,AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-16,1,-58),
        Size=UDim2.fromOffset(294,242),BorderSizePixel=0},ui);round(card,12)
    local heading=make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,12),Size=UDim2.fromOffset(260,24),
        Text="DEVIL HUB / GUI",Font=Enum.Font.GothamBold,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left},card)
    local function input(label,y,value)
        make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,y),Size=UDim2.fromOffset(120,28),Text=label,
            Font=Enum.Font.Gotham,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left},card)
        local box=make("TextBox",{Position=UDim2.fromOffset(144,y),Size=UDim2.fromOffset(134,28),Text=value,
            ClearTextOnFocus=false,Font=Enum.Font.Code,TextSize=14,BorderSizePixel=0},card);round(box,6);return box
    end
    local accent=input("Light blue / Accent",52,settings.Accent)
    local background=input("Dark background",90,settings.Background)
    local scaleLabel=make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(61,134),Size=UDim2.fromOffset(172,30),
        Font=Enum.Font.GothamSemibold,TextSize=14},card)
    local function action(text,x,y,width,fn)
        local node=make("TextButton",{Text=text,Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(width,30),
            Font=Enum.Font.GothamSemibold,TextSize=13,BorderSizePixel=0},card);round(node,6);keep(node.Activated,fn);return node
    end
    action("-",16,134,36,function()controller.Set({Scale=settings.Scale-10})end)
    action("+",242,134,36,function()controller.Set({Scale=settings.Scale+10})end)
    local feedback=make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(16,170),Size=UDim2.fromOffset(262,18),
        Text="Saved for all supported games",Font=Enum.Font.Gotham,TextSize=11},card)
    action("Apply",16,198,126,function()
        if not hex(accent.Text)or not hex(background.Text)then feedback.Text="Use 6 hex digits, e.g. #75CEFF";return end
        controller.Set({Accent=accent.Text,Background=background.Text});feedback.Text="Saved for all supported games"
    end)
    action("Reset",152,198,126,function()controller.Set(defaults);feedback.Text="Default blue theme restored"end)
    function controller.Open()card.Visible=true end
    keep(button.Activated,function()card.Visible=not card.Visible end)
    refreshUI=function()
        button.BackgroundColor3=palette.Surface2;button.TextColor3=palette.Accent
        card.BackgroundColor3=palette.Background
        heading.TextColor3=white;scaleLabel.Text="GUI size: "..math.floor(settings.Scale).."%"
        accent.Text=settings.Accent;background.Text=settings.Background
        for _,node in ipairs(card:GetDescendants())do
            if node:IsA("TextBox")or node:IsA("TextButton")then node.BackgroundColor3=palette.Surface2;node.TextColor3=white
            elseif node:IsA("TextLabel")then node.TextColor3=node==heading and white or palette.Accent end
        end
    end
    refreshUI()
end
local function mark(screen)
    if owned[screen]or screen:GetAttribute("DevilBlueSettings")then return end
    owned[screen]=true;controller.Report.screens+=1
    for _,node in ipairs(screen:GetDescendants())do patch(node)end
    scaleScreen(screen)
    if screen.Name~="DevilHubLoading"then createUI(screen.Parent)end
end
local function track(screen)
    if not screen:IsA("ScreenGui")or tracked[screen]or screen:GetAttribute("DevilBlueSettings")then return end
    local state={Links={},Probes=0,Roots=setmetatable({},{__mode="k"})};tracked[screen]=state
    local function queueScale()
        if state.ScaleQueued then return end
        state.ScaleQueued=true
        task.defer(function()state.ScaleQueued=false;if not controller.Stopped and owned[screen]then scaleScreen(screen)end end)
    end
    local function inspect(node)
        if node:IsA("GuiObject")and node.Parent==screen and not state.Roots[node]then
            state.Roots[node]=true;keep(node:GetPropertyChangedSignal("AbsoluteSize"),queueScale,state.Links)
        end
        if owned[screen]then
            patch(node)
            queueScale()
            return
        end
        if node:IsA("TextLabel")or node:IsA("TextButton")then
            if title(node.Text)then mark(screen)
            elseif node.Text==""and state.Probes<24 then
                state.Probes+=1
                local link
                link=keep(node:GetPropertyChangedSignal("Text"),function()
                    if title(node.Text)then mark(screen)end
                    if node.Text~=""then link:Disconnect()end
                end,state.Links)
            end
        end
    end
    keep(screen.DescendantAdded,inspect,state.Links)
    keep(screen:GetPropertyChangedSignal("Name"),function()if screen.Name:lower():match("^devilhub")then mark(screen)end end,state.Links)
    keep(screen:GetAttributeChangedSignal("DevilHubPresentation"),function()if screen:GetAttribute("DevilHubPresentation")then mark(screen)end end,state.Links)
    keep(screen.Destroying,function()
        for _,link in ipairs(state.Links)do link:Disconnect()end
        local scale=scales[screen];if scale then scale.Link:Disconnect()end
        tracked[screen]=nil;owned[screen]=nil;scales[screen]=nil
    end,state.Links)
    if screen:GetAttribute("DevilHubPresentation")or screen.Name:lower():match("^devilhub")then mark(screen)end
    for _,node in ipairs(screen:GetDescendants())do inspect(node)end
end
refreshAll=function()
    for node,state in pairs(states)do for key in pairs(state.Source)do applyProperty(node,state,key)end end
    for screen in pairs(owned)do scaleScreen(screen)end
    if refreshUI then refreshUI()end
end
function controller.Set(values)
    valid(values);updatePalette();refreshAll();save();return table.clone(settings)
end
function controller.Get()return table.clone(settings)end
function controller.Destroy()
    if controller.Stopped then return end
    controller.Stopped=true
    for _,link in ipairs(links)do link:Disconnect()end
    for _,state in pairs(tracked)do for _,link in ipairs(state.Links)do link:Disconnect()end end
    for node,state in pairs(states)do
        for _,link in ipairs(state.Links)do link:Disconnect()end
        for key,value in pairs(state.Source)do pcall(function()if node[key]==state.Applied[key]then node[key]=value end end)end
    end
    for _,state in pairs(scales)do
        state.Link:Disconnect()
        if state.Created then state.Node:Destroy()else pcall(function()state.Node.Scale=state.Base end)end
    end
    if ui then ui:Destroy()end
    if scope.DevilHubBlueGui==controller then scope.DevilHubBlueGui=nil end
end
local containers={}
local function watch(parent)
    if not parent or containers[parent]then return end
    containers[parent]=true;keep(parent.ChildAdded,track)
    for _,screen in ipairs(parent:GetChildren())do track(screen)end
end
pcall(function()watch(game:GetService("CoreGui"))end)
pcall(function()if type(gethui)=="function"then watch(gethui())end end)
pcall(function()
    local players=game:GetService("Players")
    local function watchPlayer(player)
        if not player then return end
        watch(player:FindFirstChildOfClass("PlayerGui"))
        keep(player.ChildAdded,function(child)if child:IsA("PlayerGui")then watch(child)end end)
    end
    watchPlayer(players.LocalPlayer)
    if not players.LocalPlayer then keep(players:GetPropertyChangedSignal("LocalPlayer"),function()watchPlayer(players.LocalPlayer)end)end
end)
return controller
