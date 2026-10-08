-- DEVIL EXECUTOR COMPAT BEGIN
-- Startup adapters only. Do not replace the VM compiler or gameplay APIs.
local DevilCompat=(function()
    local scope=_G
    if type(getfenv)=="function"then
        local ok,value=pcall(function()return getfenv(1)end)
        if ok and type(value)=="table"then scope=value end
    end
    local scopes={scope}
    if type(getgenv)=="function"then
        local ok,value=pcall(getgenv)
        if ok and type(value)=="table"and value~=scope then scopes[#scopes+1]=value end
    end
    if type(_G)=="table"and _G~=scope then scopes[#scopes+1]=_G end
    local function member(object,key)
        if object==nil then return nil end
        local ok,value=pcall(function()return object[key]end)
        if ok then return value end
    end
    local function lookup(names,namespaces)
        for _,name in ipairs(names)do
            for _,source in ipairs(scopes)do
                local value=member(source,name)
                if type(value)=="function"then return value end
            end
        end
        for _,namespace in ipairs(namespaces or {})do
            for _,source in ipairs(scopes)do
                local container=member(source,namespace)
                for _,name in ipairs(names)do
                    local value=member(container,name)
                    if type(value)=="function"then return value end
                end
            end
        end
    end
    local function trace(err)
        local message=tostring(err)
        local traceback=member(debug,"traceback")
        if type(traceback)=="function"then
            local ok,value=pcall(traceback,message,2)
            if ok and type(value)=="string"then return value end
        end
        return message
    end
    local function body(value,luaSource)
        if type(value)~="string"or #value==0 then return nil,"Empty HTTP response"end
        if luaSource then
            if value:sub(1,3)=="\239\187\191"then value=value:sub(4)end
            if value:match("^%s*<")then return nil,"HTTP returned HTML instead of Lua"end
            if value:match("^%s*$")then return nil,"Empty Lua response"end
        end
        return value
    end
    local function download(url,luaSource)
        if luaSource==nil then luaSource=true end
        local lastError="No executor HTTP API available"
        for attempt=1,3 do
            for _,name in ipairs({"HttpGet","HttpGetAsync"})do
                local native=member(game,name)
                if type(native)=="function"then
                    local ok,value=pcall(native,game,url)
                    if ok then
                        local valid,problem=body(value,luaSource)
                        if valid then return valid end
                        lastError=problem
                    else lastError=tostring(value)end
                end
            end
            -- A working native downloader remains the preferred path.
            local seen={}
            local function try(send)
                if type(send)~="function"or seen[send]then return nil end
                seen[send]=true
                local ok,response=pcall(send,{Url=url,Method="GET"})
                if not ok then lastError=tostring(response)return nil end
                local content=response
                if type(response)=="table"then
                    local status=tonumber(response.StatusCode or response.Status or response.status_code)
                    if response.Success==false or (status and(status<200 or status>=300))then
                        lastError="HTTP "..tostring(status or "request failed")return nil
                    end
                    content=response.Body or response.body
                end
                local valid,problem=body(content,luaSource)
                if valid then return valid end
                lastError=problem
            end
            for _,source in ipairs(scopes)do
                for _,name in ipairs({"request","http_request","httprequest"})do
                    local value=try(member(source,name))if value then return value end
                end
                for _,namespace in ipairs({"http","syn","fluxus"})do
                    local value=try(member(member(source,namespace),"request"))if value then return value end
                end
            end
            if attempt<3 then task.wait(attempt)end
        end
        error("DEVIL HUB download failed: "..lastError.." | "..tostring(url),0)
    end
    local function requireApis(label,requirements)
        local missing={}
        for _,entry in ipairs(requirements)do
            if type(entry[2])~="function"then missing[#missing+1]=entry[1]end
        end
        assert(#missing==0,"DEVIL HUB / "..label..": missing executor API: "..table.concat(missing,", "))
    end
    return {Download=download,Trace=trace,Lookup=lookup,Require=requireApis,
        NativeHttpGet=member(game,"HttpGet")}
end)()
-- hookfunc is the alternate name for the same old-function-returning API.
-- replaceclosure/replacefunc are intentionally not treated as hookfunction.
local hookfunction=DevilCompat.Lookup({"hookfunction","hookfunc"},{"syn"})
local newcclosure=DevilCompat.Lookup({"newcclosure"},{"syn"})
-- DEVIL EXECUTOR COMPAT END
-- DEVIL MAP ENTRY GUARD
if game.GameId~=10035204815 and game.PlaceId~=124216119978534 then
    DevilCompat.Require("Map selector",{{"loadstring",loadstring}})
    local source=DevilCompat.Download("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader?hub=compat-1")
    local run,err=loadstring(source,"DEVIL HUB / Select current map")assert(run,err)
    return run(...)
end
-- END DEVIL MAP ENTRY GUARD
local DevilDownload=DevilCompat.Download
-- DEVIL HUB / Ride a Pet loading entry
local Loading=(function()
-- Release loading overlay shared by the small loader and protected entry point.
local Loading = {}
function Loading.Begin()
    local env = type(getgenv)=="function" and getgenv() or _G
    local current = env.DevilRideLoading
    if current and current.Gui and current.Gui.Parent and not current.Failed then return current end
    if current and current.Destroy then current:Destroy() end
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local screen = Instance.new("ScreenGui")
    screen.Name = "DevilRideLoading"
    screen.ResetOnSpawn = false
    screen.DisplayOrder = 10001
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    local function make(class,parent,properties)
        local object = Instance.new(class)
        for key,value in pairs(properties) do object[key] = value end
        object.Parent = parent
        return object
    end
    local function corner(parent,radius) make("UICorner",parent,{CornerRadius = UDim.new(0,radius)}) end
    local shade = make("Frame",screen,{Size = UDim2.fromScale(1,1),BackgroundColor3 = Color3.fromRGB(0,0,0),BackgroundTransparency = .35,BorderSizePixel = 0,Active = true})
    local panel = make("Frame",shade,{AnchorPoint = Vector2.new(.5,.5),Position = UDim2.fromScale(.5,.5),Size = UDim2.new(.86,0,0,270),BackgroundColor3 = Color3.fromRGB(20,13,20),BorderSizePixel = 0})
    make("UISizeConstraint",panel,{MaxSize = Vector2.new(420,270)})
    corner(panel,16)
    -- Keep this overlay independent of the native library stroke scaler.
    local logo = make("ImageLabel",panel,{AnchorPoint = Vector2.new(.5,0),Position = UDim2.new(.5,0,0,17),Size = UDim2.fromOffset(76,64),BackgroundTransparency = 1,Image = "",ScaleType = Enum.ScaleType.Fit})
    corner(logo,9)
    local title = make("TextLabel",panel,{Position = UDim2.fromOffset(20,92),Size = UDim2.new(1,-40,0,30),BackgroundTransparency = 1,Text = "DEVIL HUB",Font = Enum.Font.GothamBold,TextSize = 24,TextColor3 = Color3.fromRGB(247,48,75)})
    local status = make("TextLabel",panel,{Position = UDim2.fromOffset(20,131),Size = UDim2.new(1,-40,0,37),BackgroundTransparency = 1,Text = "Preparing your session...",Font = Enum.Font.Gotham,TextSize = 12,TextColor3 = Color3.fromRGB(187,161,179),TextWrapped = true})
    local track = make("Frame",panel,{Position = UDim2.fromOffset(28,181),Size = UDim2.new(1,-56,0,5),BackgroundColor3 = Color3.fromRGB(52,29,44),BorderSizePixel = 0})
    corner(track,3)
    local fill = make("Frame",track,{Size = UDim2.fromScale(.04,1),BackgroundColor3 = Color3.fromRGB(247,48,75),BorderSizePixel = 0})
    corner(fill,3)
    local detail = make("TextLabel",panel,{Position = UDim2.fromOffset(20,203),Size = UDim2.new(1,-40,0,20),BackgroundTransparency = 1,Text = "RIDE A PET / STARTING",Font = Enum.Font.Gotham,TextSize = 9,TextColor3 = Color3.fromRGB(120,98,113)})
    local actions = make("Frame",panel,{Position = UDim2.new(0,24,1,-42),Size = UDim2.new(1,-48,0,28),BackgroundTransparency = 1,Visible = false})
    local function action(text,x)
        local button = make("TextButton",actions,{Position = UDim2.new(x,0,0,0),Size = UDim2.new(.48,0,1,0),Text = text,Font = Enum.Font.GothamMedium,TextSize = 11,TextColor3 = Color3.new(1,1,1),BackgroundColor3 = Color3.fromRGB(65,29,44),BorderSizePixel = 0,AutoButtonColor = false})
        corner(button,6)
        return button
    end
    local retry,close = action("Retry",0),action("Close",.52)
    local controller = {Gui = screen,HoldHub = true,Busy = false,PayloadRunning = false,Failed = false,Progress = 0,Connections = {}}
    env.DevilRideLoading = controller
    local animation
    function controller:SetStage(message,progress)
        if not screen.Parent then return end
        self.Progress = math.max(self.Progress,math.clamp(progress or self.Progress,0,1))
        status.Text = message
        detail.Text = string.format("RIDE A PET / %d%%",math.floor(self.Progress*100))
        if animation then animation:Cancel() end
        animation = TweenService:Create(fill,TweenInfo.new(.18),{Size = UDim2.fromScale(self.Progress,1)})
        animation:Play()
    end
    function controller:Destroy()
        self.HoldHub = false self.Busy = false
        if animation then animation:Cancel() end
        for _,connection in ipairs(self.Connections) do connection:Disconnect() end
        if env.DevilRideLoading == self then env.DevilRideLoading = nil end
        if screen.Parent then screen:Destroy() end
    end
    function controller:Finish(success,message)
        self.Busy = false self.HoldHub = false self.PayloadRunning = false
        if success then
            self:SetStage("Ready. Welcome to Devil Hub.",1)
            self:Destroy()
        else
            self.Failed = true
            status.Text = message or "Unable to start. Please retry."
            detail.Text = "LOAD FAILED / CHECK CONSOLE"
            actions.Visible = true
        end
    end
    table.insert(controller.Connections,close.Activated:Connect(function() controller:Destroy() end))
    table.insert(controller.Connections,retry.Activated:Connect(function()
        if controller.Busy or not screen.Parent then return end
        controller.Busy=true controller.Failed=false actions.Visible=false
        controller:SetStage("Downloading Ride a Pet...",.08)
        task.spawn(function()
            local ok,err = pcall(function()
                local run,parseError = loadstring(DevilDownload("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/ride-a-pet.lua"),"Devil Hub / Retry")
                assert(run,parseError)
                if not screen.Parent then return end
                controller:Destroy()
                run()
            end)
            if not ok then
                if screen.Parent then controller:Finish(false,"Retry failed. Check your connection.") end
                warn("[Devil Hub] Retry failed: "..tostring(err))
            end
        end)
    end))
    task.spawn(function()
        local custom = getcustomasset or getsynasset
        if type(custom) ~= "function" or type(writefile) ~= "function" then return end
        local ok,asset = pcall(function()
            local path = "devil-hub-logo-daceb9cac221.png"
            if type(isfile) ~= "function" or not isfile(path) then
                local data = DevilDownload("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png")
                assert(data:sub(1,8) == "\137PNG\13\10\26\10") writefile(path,data)
            end
            return custom(path)
        end)
        if ok and screen.Parent then logo.Image = asset end
    end)
    return controller
end
return Loading
end)()

local env=type(getgenv)=="function" and getgenv() or _G
if env.DevilRideUnpacking or (env.DevilRideLoading and env.DevilRideLoading.Busy) then return end
local loading=Loading.Begin()
loading.Busy=true
loading:SetStage("Downloading Ride a Pet...",.08)
task.wait()
local args=table.pack(...)
local ok,result=xpcall(function()
    local source=DevilDownload("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/ride-a-pet-delta.lua?v=mapfix-3&compat=1")
    assert(type(source)=="string" and #source>0,"Empty script response")
    local run,err=loadstring(source,"DEVIL HUB / Ride a Pet")
    assert(run,err)
    return run(table.unpack(args,1,args.n))
end,DevilCompat.Trace)
if not ok then
    loading:Finish(false,("Startup failed: "..(tostring(result):match("[^"..string.char(10).."]+")or "Unknown error")):sub(1,180))
    warn("[DEVIL HUB] "..tostring(result))
end
return result
