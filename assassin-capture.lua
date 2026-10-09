-- Read-only post-auth capture; no hooks and no execution of inspected functions.
local Capture = (function()
local Capture = {}
function Capture.isSensitive(key)
    if type(key) ~= "string" then return false end
    local s = key:lower()
    for _, word in ipairs({"credential", "script_key", "license", "token", "password", "cookie", "session", "ticket", "authorization", "bsdata", "privatekey"}) do
        if s:find(word, 1, true) then return true end
    end
    return s == "key" or s == "auth"
end
function Capture.candidate(value)
    if type(value) ~= "string" or #value < 256 or #value > 2000000 then return nil end
    if value:sub(1, 1) == "=" or value:sub(1, 1) == "@" then return nil end
    if value:find("FlowAuth isolated console", 1, true)
        or value:find("v4_bootstrapper_marbeg", 1, true)
        or value:find("_bsdata0", 1, true) then return nil end
    -- The already supplied shared bootstrap is not the missing game payload.
    if #value == 898586 and value:find("return setmetatable({[15]=buffer.tostring", 1, true) == 1 then return nil end
    local markers = 0
    for _, word in ipairs({"MobPega", "WinPadToque", "Huevo_Abrir", "ZonaEntro", "Pets_SetEquipped", "Assassin Leveling"}) do
        if value:find(word, 1, true) then markers += 1 end
    end
    if markers >= 2 then return "game-source-candidate" end
    if value:find("Ouroboros", 1, true) and (value:find("CreateWindow", 1, true) or value:find("ScreenGui", 1, true)) then
        return "ui-source-candidate"
    end
end
function Capture.runtimeSource(value)
    return type(value) == "string" and (value == "=FlowAuthRuntime" or value == "FlowAuthRuntime")
end
function Capture.graph(deps, options)
    options = options or {}
    local result = {schema = "devil-live-vm-1", nodes = {}, roots = {}, redacted = 0, truncated = false, bytes = 0}
    local ids, nextId = {}, 0
    local maxNodes, maxFields, maxBytes = options.maxNodes or 2500, options.maxFields or 1500, options.maxBytes or 4000000
    local encode
    local function limit(bytes)
        if result.bytes + bytes > maxBytes then result.truncated = true return false end
        result.bytes += bytes
        return true
    end
    local function hide(reason)
        result.redacted += 1
        return {type = "redacted", reason = reason}
    end
    local function register(value, kind)
        if ids[value] then return nil, {ref = ids[value]} end
        if nextId >= maxNodes or not limit(64) then result.truncated = true return nil, {type = "truncated"} end
        nextId += 1
        local node = {id = nextId, type = kind}
        ids[value], result.nodes[#result.nodes + 1] = nextId, node
        return node, {ref = nextId}
    end
    encode = function(value, depth, field)
        if Capture.isSensitive(field) then return hide("sensitive field") end
        if depth > 14 then result.truncated = true return {type = "truncated", reason = "depth"} end
        local kind = deps.typeof(value)
        if kind == "nil" then return {type = "nil"} end
        if kind == "number" then
            if value ~= value or value == math.huge or value == -math.huge then return {type = "number", value = tostring(value)} end
            limit(16)
            return {type = "number", value = value}
        end
        if kind == "boolean" then return {type = "boolean", value = value} end
        if kind == "string" then
            -- Never copy short arbitrary upvalue strings (keys/session material).
            if not field and #value < 1024 then return hide("scalar string upvalue") end
            if #value > 1000000 then result.truncated = true return {type = "truncated", reason = "string size"} end
            if not limit(#value * 2) then return {type = "truncated"} end
            return {type = "bytes", hex = deps.hex(value)}
        end
        if kind == "table" then
            local node, ref = register(value, "table")
            if not node then return ref end
            node.entries = {}
            local count = 0
            for key, entry in next, value do
                count += 1
                if count % 100 == 0 and deps.yield then deps.yield() end
                if count > maxFields or result.bytes >= maxBytes then node.truncated = true result.truncated = true break end
                if (type(key) == "string" or type(key) == "number") and not Capture.isSensitive(key) then
                    local keyData = type(key) == "string" and {type = "string", value = key} or {type = "number", value = key}
                    if limit(#tostring(key) + 24) then
                        node.entries[#node.entries + 1] = {key = keyData, value = encode(entry, depth + 1, key)}
                    end
                elseif Capture.isSensitive(key) then result.redacted += 1 end
            end
            return ref
        end
        if kind == "buffer" and deps.bufferString then
            local node, ref = register(value, "buffer")
            if not node then return ref end
            local ok, data = pcall(deps.bufferString, value)
            if ok and type(data) == "string" and #data <= 1000000 and limit(#data * 2) then
                node.hex, node.length = deps.hex(data), #data
            else node.truncated = true result.truncated = true end
            return ref
        end
        if kind == "function" then
            local node, ref = register(value, "function")
            if not node then return ref end
            -- Do not call the function or inspect authorization closure contents.
            local ok, source = pcall(deps.source, value)
            node.runtime = ok and Capture.runtimeSource(source) or false
            node.uiScope = deps.allow and deps.allow(value) or false
            if (node.runtime or node.uiScope) and deps.upvalues then
                local read, values = pcall(deps.upvalues, value)
                if read and type(values) == "table" then
                    node.upvalues = {}
                    for key, entry in next, values do
                        if type(key) == "number" or (type(key) == "string" and not Capture.isSensitive(key)) then
                            node.upvalues[#node.upvalues + 1] = {index = key, value = encode(entry, depth + 1, nil)}
                        end
                    end
                else node.upvaluesUnavailable = true end
            end
            return ref
        end
        return {type = kind, omitted = true}
    end
    return {result = result, add = function(value)
        result.roots[#result.roots + 1] = encode(value, 0, nil)
    end}
end
return Capture

end)()
assert(game.PlaceId == 120731410233153 or game.GameId == 10767824942, "Open +1 Assassin Leveling first")
assert(type(writefile) == "function", "This capture needs writefile")
local env = (type(getgenv) == "function" and getgenv()) or _G
if env.DevilAssassinCaptureRunning then return warn("[DEVIL Capture] Capture already running") end
env.DevilAssassinCaptureRunning = true
local timestamp = os.date("!%Y%m%d_%H%M%S")
local folder = "DevilAssassin_Capture_" .. timestamp
local prefix = folder .. "/"
if type(makefolder) == "function" then
    local created = pcall(makefolder, folder)
    if not created then prefix = folder .. "_" end
else prefix = folder .. "_" end
local report = {schema = "devil-assassin-capture-2", placeId = game.PlaceId, universeId = game.GameId,
    sources = {}, functions = 0, runtimeFunctions = 0, constantsInspected = 0, constantReadFailures = 0, sourceBytes = 0,
    devirtualized = false, hooksInstalled = false, inspectedFunctionsExecuted = false, complete = false}
local function message(text) print("[DEVIL Capture] " .. text) end
local function hex(data)
    local chunks = {}
    for i = 1, #data, 32768 do
        chunks[#chunks + 1] = (data:sub(i, i + 32767):gsub(".", function(char) return string.format("%02x", string.byte(char)) end))
        if i > 1 then task.wait() end
    end
    return table.concat(chunks)
end
local dbg = debug or {}
local function sourceOf(fn)
    if type(dbg.info) == "function" then
        local ok, source = pcall(dbg.info, fn, "s")
        if ok and type(source) == "string" and source ~= "=[C]" and source ~= "[C]" and source ~= "" then return source end
    end
    if type(dbg.getinfo) == "function" then
        local ok, info = pcall(dbg.getinfo, fn)
        if ok and type(info) == "table" then return info.source end
    end
end
local getUpvalues = dbg.getupvalues or getupvalues
local getConstants = dbg.getconstants or getconstants
local getConnections = getconnections
local selected, selectedSources = {}, {}
local graph = Capture.graph({typeof = typeof, hex = hex, source = sourceOf,
    allow = function(fn)
        if selected[fn] then return true end
        local source = sourceOf(fn)
        return type(source) == "string" and selectedSources[source] == true
    end,
    yield = function() task.wait() end,
    upvalues = type(getUpvalues) == "function" and getUpvalues or nil,
    bufferString = type(buffer) == "table" and buffer.tostring or nil})
report.capabilities = {getgc = type(getgc) == "function", debugInfo = type(dbg.info) == "function", getinfo = type(dbg.getinfo) == "function",
    upvalues = type(getUpvalues) == "function", constants = type(getConstants) == "function", connections = type(getConnections) == "function"}
local executorName = identifyexecutor or getexecutorname
if type(executorName) == "function" then
    local ok, name, version = pcall(executorName)
    if ok and type(name) == "string" then report.executor = name:sub(1, 80) end
    if ok and type(version) == "string" then report.executorVersion = version:sub(1, 80) end
end
local seen = {}
local function saveSource(text, origin)
    local classification = Capture.candidate(text)
    if not classification or seen[text] then return end
    seen[text] = true
    if #report.sources >= 12 or report.sourceBytes + #text > 8000000 then report.sourcesTruncated = true return end
    -- Compile only to reject non-code constants. Never execute the result.
    if type(loadstring) ~= "function" then return end
    local valid, compiled = pcall(loadstring, text, "=DevilCaptureSyntaxCheck")
    if not valid or type(compiled) ~= "function" then return end
    local name = "candidate_" .. tostring(#report.sources + 1) .. ".lua"
    local saved = pcall(writefile, prefix .. name, text)
    if saved then
        report.sourceBytes += #text
        report.sources[#report.sources + 1] = {file = name, bytes = #text, origin = origin, classification = classification,
            compilePassed = true, devirtualized = false}
        message("Saved " .. name .. " (candidate; still needs inspection)")
    else report.sourceWriteFailed = true end
end
local visited = {}
local function inspect(value, origin, owned)
        if type(value) == "function" and not visited[value] then
            visited[value] = true
            report.functions += 1
            local source = sourceOf(value)
            saveSource(source, origin)
            if owned then
                selected[value] = true
                if type(source) == "string" and source ~= "=[C]" and source ~= "[C]"
                    and source ~= ""
                    and not source:lower():find("flowauthinit", 1, true) then selectedSources[source] = true end
            end
            if Capture.runtimeSource(source) or owned then
                if Capture.runtimeSource(source) then report.runtimeFunctions += 1 end
                graph.add(value)
                if type(getConstants) == "function" and report.constantsInspected < 1000 then
                    local ok, constants = pcall(getConstants, value)
                    if ok and type(constants) == "table" then
                        report.constantsInspected += 1
                        for _, constant in next, constants do
                            if type(constant) == "string" then saveSource(constant, "runtime constant") end
                        end
                    else report.constantReadFailures += 1 end
                end
            end
        end
end
local function connectionFunction(connection)
    local ok, value = pcall(function() return connection.Function or connection.Callback end)
    return ok and type(value) == "function" and value or nil
end
local function apiProbe()
    local marker = {value = 72491}
    local function probe() return marker.value, "DEVIL_CAPTURE_CONST_PROBE" end
    report.probes = {getgcSeesOwnFunction = false, upvaluesExposeOwnCapture = false,
        constantsExposeOwnLiteral = false, connectionsExposeOwnCallback = false}
    if type(getgc) == "function" then
        local ok, objects = pcall(getgc, true)
        if ok and type(objects) == "table" then
            for _, value in next, objects do if value == probe then report.probes.getgcSeesOwnFunction = true end end
        end
    end
    if type(getUpvalues) == "function" then
        local ok, values = pcall(getUpvalues, probe)
        if ok and type(values) == "table" then
            for _, value in next, values do if value == marker then report.probes.upvaluesExposeOwnCapture = true end end
        end
    end
    if type(getConstants) == "function" then
        local ok, values = pcall(getConstants, probe)
        if ok and type(values) == "table" then
            for _, value in next, values do if value == "DEVIL_CAPTURE_CONST_PROBE" then report.probes.constantsExposeOwnLiteral = true end end
        end
    end
    if type(getConnections) == "function" then
        local event = Instance.new("BindableEvent")
        local connection = event.Event:Connect(probe)
        local ok, values = pcall(getConnections, event.Event)
        if ok and type(values) == "table" then
            for _, value in next, values do
                if connectionFunction(value) == probe then report.probes.connectionsExposeOwnCallback = true end
            end
        end
        connection:Disconnect()
        event:Destroy()
    end
end
local function uiCallbacks()
    report.uiRoots, report.uiButtons, report.uiCallbacks, report.uiReadFailures = 0, 0, 0, 0
    if type(getConnections) ~= "function" or not report.probes.connectionsExposeOwnCallback then return end
    local containers = {}
    local function add(value) if value and not table.find(containers, value) then containers[#containers + 1] = value end end
    pcall(function() add(game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")) end)
    pcall(function() add(game:GetService("CoreGui")) end)
    if type(gethui) == "function" then pcall(function() add(gethui()) end) end
    local seenRoots, seenCallbacks = {}, {}
    for _, container in ipairs(containers) do
        local ok, all = pcall(function() return container:GetDescendants() end)
        if not ok then report.uiReadFailures += 1 else
            local readRoot, rootIsScreen = pcall(function() return container:IsA("ScreenGui") end)
            if readRoot and rootIsScreen then table.insert(all, 1, container) end
            for _, root in ipairs(all) do
                if root:IsA("ScreenGui") and not seenRoots[root] then
                    seenRoots[root] = true
                    local read, nodes = pcall(function() return root:GetDescendants() end)
                    if read and #nodes < 12000 then
                        local marked, auth = false, false
                        for _, node in ipairs(nodes) do
                            if node:IsA("TextLabel") or node:IsA("TextButton") then
                                local text = node.Text:lower()
                                if text:find("ouroboros", 1, true) then marked = true end
                                if text:find("flowauth", 1, true) or text:find("key system", 1, true) then auth = true end
                            end
                        end
                        if marked and not auth then
                            report.uiRoots += 1
                            for _, node in ipairs(nodes) do
                                if node:IsA("GuiButton") then
                                    report.uiButtons += 1
                                    for _, eventName in ipairs({"Activated", "MouseButton1Click"}) do
                                        local got, connections = pcall(function() return getConnections(node[eventName]) end)
                                        if got and type(connections) == "table" then
                                            for _, connection in next, connections do
                                                local callback = connectionFunction(connection)
                                                if callback and not seenCallbacks[callback] and report.uiCallbacks < 400 then
                                                    seenCallbacks[callback] = true
                                                    report.uiCallbacks += 1
                                                    inspect(callback, "recognized hub UI callback", true)
                                                end
                                            end
                                        end
                                    end
                                    if report.uiButtons % 20 == 0 then task.wait() end
                                end
                            end
                        end
                    elseif not read then report.uiReadFailures += 1 end
                end
            end
        end
    end
end
local function perform()
    message("Probing real inspection behavior; inspected functions are never called")
    apiProbe()
    message("Inspecting loaded functions and recognized hub button callbacks")
    local good, objects = false, nil
    if type(getgc) == "function" then
        good, objects = pcall(getgc, true)
        if not good or type(objects) ~= "table" then good, objects = pcall(getgc) end
    end
    if good and type(objects) == "table" then
        local count = 0
        for _, value in next, objects do
            count += 1
            inspect(value, "debug source", false)
            if count % 100 == 0 then task.wait() end
            if count >= 60000 then report.gcTruncated = true break end
        end
        report.gcObjects = count
    else report.gcObjects = 0 end
    uiCallbacks()
    graph.result.note = "Live VM data; not devirtualized source. Redactions/limits can prevent full reconstruction."
    if #graph.result.roots > 0 then
        local ok = pcall(function()
            writefile(prefix .. "live-vm.json", game:GetService("HttpService"):JSONEncode(graph.result))
        end)
        report.vmSaved, report.vmNodes = ok, #graph.result.nodes
        report.vmTruncated, report.vmRedacted = graph.result.truncated, graph.result.redacted
    end
    report.complete = true
    report.result = #report.sources > 0 and "Source candidates saved; inspect before editing/running"
        or (#graph.result.roots > 0 and "Runtime/UI state found; no game source recovered yet" or "Executor exposes no matching source/runtime functions")
end
local ok = pcall(perform)
if not ok then report.result = "Capture failed; inspect capability flags" end
local written = pcall(function()
    writefile(prefix .. "manifest.json", game:GetService("HttpService"):JSONEncode(report))
end)
env.DevilAssassinCaptureRunning = nil
env.DevilAssassinLastCapture = report
message(report.result)
message(written and ("Manifest: " .. prefix .. "manifest.json") or "Manifest write failed")
return report
