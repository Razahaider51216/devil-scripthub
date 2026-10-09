-- DEVIL HUB presentation adapter for the original Assassin loader.
-- Protected upstream/auth remain original; game payload is not devirtualized.
local Brand = (function()
local Brand = {}
Brand.Invite = "https://discord.gg/ZY7PRcVJe2"
Brand.KnownLogos = {}
function Brand.text(value)
    if type(value) ~= "string" then return value end
    return (value:gsub("[Oo][Uu][Rr][Oo][Bb][Oo][Rr][Oo][Ss]", "DEVIL HUB")
        :gsub("[Oo][Uu][Rr][Oo][Ff][Ll][Oo][Ww]", "DEVIL HUB")
        :gsub("https?://[Dd][Ii][Ss][Cc][Oo][Rr][Dd]%.gg/[%w_-]+", Brand.Invite)
        :gsub("https?://[Dd][Ii][Ss][Cc][Oo][Rr][Dd]%.com/invite/[%w_-]+", Brand.Invite)
        :gsub("[Dd][Ii][Ss][Cc][Oo][Rr][Dd]%.gg/[%w_-]+", "discord.gg/ZY7PRcVJe2"))
end
function Brand.marker(value)
    if type(value) ~= "string" then return false end
    local s = value:lower()
    return s:find("ouroboros", 1, true) ~= nil or s:find("ouroflow", 1, true) ~= nil
end
function Brand.logo(value)
    if type(value) ~= "string" then return false end
    return Brand.KnownLogos[value] == true or value:find("103859712365480", 1, true) ~= nil
        or value:lower():find("ouroflowlogo.png", 1, true) ~= nil
end
function Brand.discord(value)
    if type(value) ~= "string" then return false end
    local s = value:lower()
    return s:find("discord", 1, true) ~= nil
end
function Brand.action(value)
    if type(value) ~= "string" then return false end
    local s = value:lower()
    if s:find("webhook", 1, true) then return false end
    return s:match("^%s*discord%s*$") ~= nil
        or s:find("discord.gg/", 1, true) ~= nil
        or s:find("discord.com/invite/", 1, true) ~= nil
        or (Brand.discord(s) and (s:find("join", 1, true) ~= nil
            or s:find("copy", 1, true) ~= nil or s:find("open", 1, true) ~= nil
            or s:find("invite", 1, true) ~= nil))
end
function Brand.auth(value)
    if type(value) ~= "string" then return false end
    local s = value:lower()
    return s:find("flowauth", 1, true) ~= nil
        or s:find("key system", 1, true) ~= nil
        or s:find("keysystem", 1, true) ~= nil
end
function Brand.findButton(node, root)
    local cursor = node
    while cursor and cursor ~= root do
        if cursor:IsA("GuiButton") then return cursor end
        cursor = cursor.Parent
    end
end
function Brand.inviteButton(node, root)
    local text = node:IsA("TextButton") and node.Text or node.Name
    if Brand.action(text) then return true end
    if tostring(text):lower():find("webhook", 1, true) then return false end
    local s = tostring(text):lower()
    if not (s:find("copy", 1, true) or s:find("join", 1, true)
        or s:find("invite", 1, true) or s:find("open", 1, true)) then return false end
    local cursor = node.Parent
    for _ = 1, 3 do
        if not cursor or cursor == root then break end
        local children = cursor:GetDescendants()
        -- Never classify a whole window by a distant Discord label.
        if #children > 60 then break end
        for _, child in ipairs(children) do
            if child:IsA("TextLabel") and Brand.action(child.Text) then return true end
        end
        cursor = cursor.Parent
    end
    return false
end
return Brand

end)()
local env = (type(getgenv) == "function" and getgenv()) or _G
if env.DevilAssassinBrand and env.DevilAssassinBrand.Gui.Parent then
    env.DevilAssassinBrand.Gui.Enabled = true
    return
end
assert(game.PlaceId == 120731410233153 or game.GameId == 10767824942, "Open +1 Assassin Leveling first")
local player = game:GetService("Players").LocalPlayer
assert(player, "Run on the Roblox client")
local roots = {}
local function addRoot(root)
    if root and not table.find(roots, root) then roots[#roots + 1] = root end
end
local playerGui = player:WaitForChild("PlayerGui")
addRoot(playerGui)
if type(gethui) == "function" then
    local ok, root = pcall(gethui)
    if ok then addRoot(root) end
end
pcall(function() addRoot(game:GetService("CoreGui")) end)
local gui = Instance.new("ScreenGui")
gui.Name, gui.ResetOnSpawn, gui.DisplayOrder = "DevilAssassinBrand", false, 10001
local parented = false
if type(gethui) == "function" then parented = pcall(function() gui.Parent = gethui() end) end
if not parented then gui.Parent = playerGui end
local panel = Instance.new("Frame")
panel.Size, panel.Position = UDim2.fromOffset(300, 135), UDim2.new(1, -312, 0, 65)
panel.BackgroundColor3, panel.Parent = Color3.fromRGB(12, 18, 29), gui
local corner = Instance.new("UICorner")
corner.CornerRadius, corner.Parent = UDim.new(0, 12), panel
local title = Instance.new("TextLabel")
title.Position, title.Size = UDim2.fromOffset(62, 10), UDim2.new(1, -75, 0, 24)
title.BackgroundTransparency, title.Text = 1, "DEVIL HUB | Assassin"
title.TextSize, title.Font, title.TextColor3 = 15, Enum.Font.GothamBold, Color3.fromRGB(239, 244, 255)
title.Parent = panel
local image = Instance.new("ImageLabel")
image.Position, image.Size = UDim2.fromOffset(10, 9), UDim2.fromOffset(42, 42)
image.BackgroundTransparency, image.ScaleType, image.Parent = 1, Enum.ScaleType.Fit, panel
local info = Instance.new("TextLabel")
info.Position, info.Size = UDim2.fromOffset(10, 50), UDim2.new(1, -20, 0, 28)
info.BackgroundTransparency, info.TextSize, info.Font = 1, 12, Enum.Font.Gotham
info.TextColor3, info.TextWrapped, info.Parent = Color3.fromRGB(154, 173, 202), true, panel
local state = {Gui = gui, Roots = 0, Texts = 0, Logos = 0, Buttons = 0, Connections = {}, Overlays = {}, Restores = {}, Stopped = false}
env.DevilAssassinBrand = state
local function status(text)
    if gui.Parent then info.Text = text end
    print("[DEVIL HUB / Assassin] " .. text)
end
local function connect(signal, callback)
    local connection = signal:Connect(function(...) if not state.Stopped then return callback(...) end end)
    state.Connections[#state.Connections + 1] = connection
    return connection
end
local copy = setclipboard or toclipboard
local function copyInvite()
    if type(copy) == "function" then
        local ok = pcall(copy, Brand.Invite)
        status(ok and "DEVIL HUB Discord copied" or "Clipboard failed")
    else status(Brand.Invite) end
end
local function button(text, x, width)
    local node = Instance.new("TextButton")
    node.Position, node.Size = UDim2.fromOffset(x, 86), UDim2.fromOffset(width, 36)
    node.Text, node.TextSize, node.Font = text, 13, Enum.Font.Gotham
    node.TextColor3, node.BackgroundColor3, node.Parent = Color3.new(1, 1, 1), Color3.fromRGB(36, 64, 107), panel
    return node
end
local launch = button("Run original", 10, 130)
local discord = button("Discord", 150, 95)
local stop = button("X", 255, 35)
connect(discord.Activated, copyInvite)
local function fetch(url)
    local ok, data = pcall(function() return game:HttpGet(url) end)
    if ok and type(data) == "string" and #data > 0 then return data end
    local requestFn = request or http_request or (type(syn) == "table" and syn.request)
    if type(requestFn) == "function" then
        ok, data = pcall(requestFn, {Url = url, Method = "GET"})
        if ok and type(data) == "table" and (tonumber(data.StatusCode) or 200) >= 200
            and (tonumber(data.StatusCode) or 200) < 300 then return data.Body end
    end
end
local branded, watched, overlays = {}, {}, {}
local logoAsset
local originalAsset = getcustomasset or getsynasset
if type(originalAsset) == "function" and type(isfile) == "function" then
    pcall(function()
        local path = "AirFlowAssets/OuroFlowLogo.png"
        if isfile(path) then
            local asset = originalAsset(path)
            if type(asset) == "string" and asset ~= "" then Brand.KnownLogos[asset] = true end
        end
    end)
end
local function restoreProperty(node, key, before, after)
    state.Restores[#state.Restores + 1] = function()
        if node.Parent and node[key] == after then node[key] = before end
    end
end
local function applyLogo(node)
    if not logoAsset then return end
    if node.Image ~= logoAsset then
        restoreProperty(node, "Image", node.Image, logoAsset)
        restoreProperty(node, "ImageColor3", node.ImageColor3, Color3.new(1, 1, 1))
        restoreProperty(node, "ImageRectOffset", node.ImageRectOffset, Vector2.zero)
        restoreProperty(node, "ImageRectSize", node.ImageRectSize, Vector2.zero)
        node.Image, node.ImageColor3 = logoAsset, Color3.new(1, 1, 1)
        node.ImageRectOffset, node.ImageRectSize = Vector2.zero, Vector2.zero
        state.Logos += 1
    end
end
local function bindInvite(target)
    if overlays[target] or not target.Parent then return end
    local cover = Instance.new("TextButton")
    cover.Name = "DevilDiscordAction"
    cover.Size, cover.Position = UDim2.fromScale(1, 1), UDim2.fromScale(0, 0)
    cover.BackgroundTransparency, cover.Text, cover.AutoButtonColor = 1, "", false
    cover.ZIndex, cover.Active, cover.Selectable = math.max(target.ZIndex + 10, 50), true, true
    restoreProperty(target, "Selectable", target.Selectable, false)
    target.Selectable = false
    cover.Parent = target
    overlays[target] = cover
    state.Overlays[#state.Overlays + 1] = cover
    state.Buttons += 1
    connect(cover.Activated, copyInvite)
end
local function isText(node)
    return node:IsA("TextLabel") or node:IsA("TextButton")
end
local function applyNode(node, root)
    if watched[node] or node.Name == "DevilDiscordAction" then return end
    watched[node] = true
    if isText(node) then
        local changing = false
        local function update()
            if changing or not node.Parent or Brand.auth(node.Text) then return end
            local before, after = node.Text, Brand.text(node.Text)
            if before ~= after then
                changing = true
                restoreProperty(node, "Text", before, after)
                node.Text = after
                state.Texts += 1
                changing = false
            end
            if Brand.action(node.Text) then
                local target = Brand.findButton(node, root)
                if target then bindInvite(target) end
            end
        end
        update()
        connect(node:GetPropertyChangedSignal("Text"), update)
    elseif node:IsA("ImageLabel") or node:IsA("ImageButton") then
        local ownedLogo = Brand.logo(node.Image) or node.Name:lower() == "logo"
        if ownedLogo then
            applyLogo(node)
            connect(node:GetPropertyChangedSignal("Image"), function() applyLogo(node) end)
        end
    end
    if node:IsA("GuiButton") and Brand.inviteButton(node, root) then bindInvite(node) end
end
local function accept(root)
    if branded[root] or root == gui or root.Name == "DevilAssassinTest" or Brand.auth(root.Name) then return end
    local ok, nodes = pcall(function() return root:GetDescendants() end)
    if not ok or #nodes > 8000 then return end
    local marked = Brand.marker(root.Name)
    local knownLogo = false
    local mapTitle = false
    for _, node in ipairs(nodes) do
        if isText(node) and Brand.marker(node.Text) and not Brand.auth(node.Text) then marked = true end
        if isText(node) and node.Text:lower():find("assassin leveling", 1, true) then mapTitle = true end
        if (node:IsA("ImageLabel") or node:IsA("ImageButton")) and Brand.logo(node.Image) then knownLogo = true end
    end
    -- A known logo alone may belong to another hub. Require a branded title/name.
    if not marked and not (knownLogo and (mapTitle or root.Name:lower() == "airflowui")) then return end
    -- Never modify an authentication panel even if it also displays a hub title.
    for _, node in ipairs(nodes) do
        if isText(node) and Brand.auth(node.Text) then return end
    end
    branded[root] = true
    state.Roots += 1
    for _, node in ipairs(nodes) do pcall(applyNode, node, root) end
    connect(root.DescendantAdded, function(node)
        task.defer(function() if not state.Stopped then pcall(applyNode, node, root) end end)
    end)
    status("Branded UI found | " .. state.Roots .. " window(s)")
end
local function scan()
    for _, container in ipairs(roots) do
        local ok, nodes = pcall(function() return container:GetDescendants() end)
        if ok then
            for _, node in ipairs(nodes) do
                if node:IsA("ScreenGui") then accept(node) end
            end
        end
    end
end
function state.Stop()
    if state.Stopped then return end
    state.Stopped = true
    for _, connection in ipairs(state.Connections) do connection:Disconnect() end
    for _, overlay in ipairs(state.Overlays) do overlay:Destroy() end
    for i = #state.Restores, 1, -1 do pcall(state.Restores[i]) end
    if env.DevilAssassinBrand == state then env.DevilAssassinBrand = nil end
    gui:Destroy()
end
connect(stop.Activated, state.Stop)
local started = false
connect(launch.Activated, function()
    if state.Roots > 0 then status("Existing UI detected; no second launch") return end
    if started then return end
    if type(loadstring) ~= "function" then status("loadstring unavailable") return end
    started = true
    launch.Text = "Starting..."
    task.spawn(function()
        local source = fetch("https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/games/ck9dw82k.luau")
        if type(source) ~= "string" or source:match("^%s*<") then
            started = false launch.Text = "Retry" status("Original entry download failed") return
        end
        local compiled, fn = pcall(loadstring, source, "=AssassinOriginalLoader")
        if not compiled or type(fn) ~= "function" then
            started = false launch.Text = "Retry" status("Original loader compile failed") return
        end
        status("Starting original loader/auth")
        local ok = pcall(fn)
        launch.Text = ok and "Loader returned" or "Loader error"
        status(ok and "Loader returned; waiting for game UI" or "Original loader error; see its console")
        scan()
    end)
end)
status("Looking for the existing Assassin hub UI")
scan()
task.spawn(function()
    local customAsset = getcustomasset or getsynasset
    if type(writefile) ~= "function" or type(customAsset) ~= "function" then
        status("Logo needs writefile + getcustomasset; text/Discord still apply") return
    end
    local ok, asset = pcall(function()
        local png = fetch("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png")
        assert(type(png) == "string" and png:sub(1, 8) == "\137PNG\13\10\26\10", "Invalid logo")
        local file = "DevilHub_Assassin_Logo.png"
        writefile(file, png)
        return customAsset(file)
    end)
    if state.Stopped then return end
    if not ok or type(asset) ~= "string" or asset == "" then status("Logo download/asset failed") return end
    logoAsset, image.Image = asset, asset
    for root in pairs(branded) do
        for _, node in ipairs(root:GetDescendants()) do
            if (node:IsA("ImageLabel") or node:IsA("ImageButton"))
                and (Brand.logo(node.Image) or node.Name:lower() == "logo") then pcall(applyLogo, node) end
        end
    end
end)
task.spawn(function()
    for attempt = 1, 32 do
        if state.Stopped then return end
        scan()
        task.wait(attempt <= 20 and 2 or 5)
    end
    if state.Roots == 0 then status("UI not identified; send a screenshot for exact matching") end
end)
return state
