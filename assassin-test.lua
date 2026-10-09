-- Diagnostic runner. The protected game payload has NOT been devirtualized.
-- No namecall hooks, remote calls, credential capture, or auth modifications.
local CORE = {}
function CORE.adler32(source)
    local a, b = 1, 0
    for i = 1, #source do
        a = (a + string.byte(source, i)) % 65521
        b = (b + a) % 65521
    end
    return b * 65536 + a
end
function CORE.validLua(source)
    if type(source) ~= "string" or #source == 0 then return false end
    local head = string.lower(string.match(source, "^%s*(.*)") or "")
    return string.sub(head, 1, 1) ~= "<"
        and not string.find(head, "access denied", 1, true)
        and not string.find(head, "forbidden", 1, true)
end
function CORE.verifyRuntime(source)
    if not CORE.validLua(source) then return false, "Not a Lua response" end
    if #source ~= 898586 then return false, "Runtime version/size differs" end
    if CORE.adler32(source) ~= 1933677448 then return false, "Runtime checksum differs" end
    return true, "Pinned runtime integrity passed"
end
function CORE.launch(source, compiler)
    if not CORE.validLua(source) then return false, "Invalid loader response" end
    if type(compiler) ~= "function" then return false, "loadstring unavailable" end
    local ok, fn = pcall(compiler, source, "=AssassinOriginalLoader")
    if not ok or type(fn) ~= "function" then return false, "Loader compilation failed" end
    local ran = pcall(fn)
    if not ran then return false, "Original loader raised an error; see its console" end
    return true, "Loader returned; confirm auth and game UI yourself"
end
-- Offline tests extract only the CORE section, before this marker.
-- END_TEST_CORE
local runtimeURL = "https://flowauth.net/assets/flowauth/sha256/634ab8f45cf483d650d2794d534ca5171859595c965b13100169a1ccd5069fc4/v4_bootstrapper_marbeg.lua"
local loaderURL = "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/games/ck9dw82k.luau"
local env = (type(getgenv) == "function" and getgenv()) or _G
local previous = env.DevilAssassinTest
if previous and previous.gui and previous.gui.Parent then
    previous.gui.Enabled = true
    return
end
local player = game:GetService("Players").LocalPlayer
assert(player, "Run this diagnostic from the Roblox client")
local gui = Instance.new("ScreenGui")
gui.Name = "DevilAssassinTest"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10000
local okParent = false
if type(gethui) == "function" then
    okParent = pcall(function() gui.Parent = gethui() end)
end
if not okParent then gui.Parent = player:WaitForChild("PlayerGui") end
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.9, 0, 0, 310)
frame.Position = UDim2.new(0.05, 0, 0.08, 0)
frame.BackgroundColor3 = Color3.fromRGB(16, 23, 37)
frame.Parent = gui
local limit = Instance.new("UISizeConstraint")
limit.MaxSize = Vector2.new(660, 310)
limit.Parent = frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -65, 0, 42)
title.Position = UDim2.fromOffset(14, 4)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(240, 245, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Devil | Assassin Loader Test"
title.Parent = frame
local log = Instance.new("TextLabel")
log.Size = UDim2.new(1, -28, 0, 185)
log.Position = UDim2.fromOffset(14, 48)
log.BackgroundTransparency = 1
log.TextColor3 = Color3.fromRGB(196, 209, 228)
log.Font = Enum.Font.Code
log.TextSize = 13
log.TextWrapped = true
log.TextXAlignment = Enum.TextXAlignment.Left
log.TextYAlignment = Enum.TextYAlignment.Top
log.Parent = frame
local function button(text, position, size)
    local b = Instance.new("TextButton")
    b.Position, b.Size = position, size
    b.BackgroundColor3 = Color3.fromRGB(47, 82, 132)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font, b.TextSize, b.Text = Enum.Font.Gotham, 14, text
    b.Parent = frame
    return b
end
local run = button("Run original loader", UDim2.new(0, 14, 1, -62), UDim2.new(0.58, -20, 0, 44))
local save = button("Save report", UDim2.new(0.58, 0, 1, -62), UDim2.new(0.42, -14, 0, 44))
local close = button("X", UDim2.new(1, -44, 0, 9), UDim2.fromOffset(32, 32))
local lines, report = {}, {placeId = game.PlaceId, universeId = game.GameId, devirtualized = false}
local state = {gui = gui, report = report}
env.DevilAssassinTest = state
local function status(key, value)
    report[key] = value
    table.insert(lines, key .. ": " .. tostring(value))
    while #lines > 9 do table.remove(lines, 1) end
    if gui.Parent then log.Text = table.concat(lines, "\n") end
    print("[Assassin Test] " .. key .. ": " .. tostring(value))
end
local requestFn = request or http_request or httprequest
if type(requestFn) ~= "function" and type(syn) == "table" then requestFn = syn.request end
local function fetch(url)
    local good, response = pcall(function() return game:HttpGet(url) end)
    if good and CORE.validLua(response) then return response end
    if type(requestFn) == "function" then
        good, response = pcall(requestFn, {Url = url, Method = "GET"})
        if good and type(response) == "table" then
            local code = tonumber(response.StatusCode) or 200
            if code >= 200 and code < 300 and CORE.validLua(response.Body) then return response.Body end
        end
    end
    return nil
end
local supported = game.PlaceId == 120731410233153 or game.GameId == 10767824942
status("map", supported and "+1 Assassin Leveling" or "Wrong game")
status("loadstring", type(loadstring) == "function")
status("buffer", type(buffer) == "table")
status("debug.info", type(debug) == "table" and type(debug.info) == "function")
local started = false
run.Activated:Connect(function()
    if started then return end
    if not supported then status("launch", "Open +1 Assassin Leveling first") return end
    if type(loadstring) ~= "function" then status("launch", "loadstring unavailable") return end
    started = true
    run.Text = "Starting..."
    task.spawn(function()
        status("launch", "Downloading original game entry")
        local source = fetch(loaderURL)
        if not source then
            started = false
            run.Text = "Retry original loader"
            status("launch", "Original entry download failed")
            return
        end
        status("launch", "Running original auth/loader")
        local returned = false
        task.delay(30, function()
            if not returned and gui.Parent then status("launch", "Still running/waiting; check upstream UI") end
        end)
        local success, message = CORE.launch(source, loadstring)
        returned = true
        report.loaderReturned = success
        status("launch", message)
        run.Text = success and "Loader returned" or "Loader error"
    end)
end)
save.Activated:Connect(function()
    if type(writefile) ~= "function" then status("save", "writefile unavailable; report in console") return end
    local saved = pcall(function()
        -- The report contains capabilities/status only; no key or source payload.
        writefile("DevilAssassinTest-report.json", game:GetService("HttpService"):JSONEncode(report))
    end)
    status("save", saved and "DevilAssassinTest-report.json" or "File write failed")
end)
close.Activated:Connect(function()
    if env.DevilAssassinTest == state then env.DevilAssassinTest = nil end
    gui:Destroy()
end)
task.spawn(function()
    status("runtime", "Checking pinned runtime (download only)")
    local source = fetch(runtimeURL)
    if not source then status("runtime", "Download blocked/failed; original loader may use fallbacks") return end
    local verified, message = CORE.verifyRuntime(source)
    report.runtimeVerified = verified
    status("runtime", message)
    if verified and type(loadstring) == "function" then
        local good, compiled = pcall(loadstring, source, "=FlowAuthRuntime")
        status("runtimeCompile", good and type(compiled) == "function")
        -- Do not execute the standalone bootstrap: it needs the original handoff.
    end
end)
