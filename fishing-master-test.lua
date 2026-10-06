-- Fishing Master TEST v9 / replacement backend: public NNVN v1.4.8
local Loading=(function()
-- Release loading overlay shared by the small loader and protected entry point.
local Loading = {}
function Loading.Begin()
    local env = type(getgenv)=="function" and getgenv() or _G
    local current = env.DevilFishingNNVNLoading
    if current and current.Gui and current.Gui.Parent and not current.Failed then return current end
    if current and current.Destroy then current:Destroy() end
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local screen = Instance.new("ScreenGui")
    screen.Name = "DevilFishingNNVNLoading"
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
    local panel = make("Frame",shade,{AnchorPoint = Vector2.new(.5,.5),Position = UDim2.fromScale(.5,.5),Size = UDim2.new(.86,0,0,270),BackgroundColor3 = Color3.fromRGB(8,14,22),BorderSizePixel = 0})
    make("UISizeConstraint",panel,{MaxSize = Vector2.new(420,270)})
    corner(panel,16)
    -- Keep this overlay independent of the native library stroke scaler.
    local logo = make("ImageLabel",panel,{AnchorPoint = Vector2.new(.5,0),Position = UDim2.new(.5,0,0,17),Size = UDim2.fromOffset(76,64),BackgroundTransparency = 1,Image = "",ScaleType = Enum.ScaleType.Fit})
    corner(logo,9)
    local title = make("TextLabel",panel,{Position = UDim2.fromOffset(20,92),Size = UDim2.new(1,-40,0,30),BackgroundTransparency = 1,Text = "DEVIL HUB / FISHING",Font = Enum.Font.GothamBold,TextSize = 24,TextColor3 = Color3.fromRGB(56,148,255)})
    local status = make("TextLabel",panel,{Position = UDim2.fromOffset(20,131),Size = UDim2.new(1,-40,0,37),BackgroundTransparency = 1,Text = "Preparing your session...",Font = Enum.Font.Gotham,TextSize = 12,TextColor3 = Color3.fromRGB(187,161,179),TextWrapped = true})
    local track = make("Frame",panel,{Position = UDim2.fromOffset(28,181),Size = UDim2.new(1,-56,0,5),BackgroundColor3 = Color3.fromRGB(52,29,44),BorderSizePixel = 0})
    corner(track,3)
    local fill = make("Frame",track,{Size = UDim2.fromScale(.04,1),BackgroundColor3 = Color3.fromRGB(56,148,255),BorderSizePixel = 0})
    corner(fill,3)
    local detail = make("TextLabel",panel,{Position = UDim2.fromOffset(20,203),Size = UDim2.new(1,-40,0,20),BackgroundTransparency = 1,Text = "FISHING MASTER / STARTING",Font = Enum.Font.Gotham,TextSize = 9,TextColor3 = Color3.fromRGB(120,98,113)})
    local actions = make("Frame",panel,{Position = UDim2.new(0,24,1,-42),Size = UDim2.new(1,-48,0,28),BackgroundTransparency = 1,Visible = false})
    local function action(text,x)
        local button = make("TextButton",actions,{Position = UDim2.new(x,0,0,0),Size = UDim2.new(.48,0,1,0),Text = text,Font = Enum.Font.GothamMedium,TextSize = 11,TextColor3 = Color3.new(1,1,1),BackgroundColor3 = Color3.fromRGB(65,29,44),BorderSizePixel = 0,AutoButtonColor = false})
        corner(button,6)
        return button
    end
    local retry,close = action("Retry",0),action("Close",.52)
    local controller = {Gui = screen,HoldHub = true,Busy = false,PayloadRunning = false,Failed = false,Progress = 0,Connections = {}}
    env.DevilFishingNNVNLoading = controller
    local animation
    function controller:SetStage(message,progress)
        if not screen.Parent then return end
        self.Progress = math.max(self.Progress,math.clamp(progress or self.Progress,0,1))
        status.Text = message
        detail.Text = string.format("FISHING MASTER / %d%%",math.floor(self.Progress*100))
        if animation then animation:Cancel() end
        animation = TweenService:Create(fill,TweenInfo.new(.18),{Size = UDim2.fromScale(self.Progress,1)})
        animation:Play()
    end
    function controller:Destroy()
        self.HoldHub = false self.Busy = false
        if animation then animation:Cancel() end
        for _,connection in ipairs(self.Connections) do connection:Disconnect() end
        if env.DevilFishingNNVNLoading == self then env.DevilFishingNNVNLoading = nil end
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
        controller:SetStage("Downloading Fishing Master...",.08)
        task.spawn(function()
            local ok,err = pcall(function()
                local run,parseError = loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/fishing-master-test.lua?v=9"),"Devil Hub / Retry")
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
                local data = game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png")
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
local ContextFactory=(function()
return function(deps)
	local self = { Active = true, Threads = {}, Connections = {}, Hooks = {}, Logo = deps.Logo or "" }
	local baseTask = deps.Task
	self.Task = setmetatable({}, { __index = baseTask })
	local function schedule(name, ...)
		local args = table.pack(...)
		local position = name == "delay" and 2 or 1
		local fn = args[position]
		local thread, finished
		args[position] = function(...)
			if not self.Active then return end
			local ok, err = pcall(fn, ...)
			finished = true
			if thread then self.Threads[thread] = nil end
			if not ok then deps.Warn("[DEVIL HUB / NNVN] " .. tostring(err)) end
		end
		thread = baseTask[name](table.unpack(args, 1, args.n))
		if not finished then self.Threads[thread] = true end
		return thread
	end
	for _, name in ipairs({ "spawn", "defer", "delay" }) do self.Task[name] = function(...) return schedule(name, ...) end end
	function self:Connect(signal, callback)
		local connection = signal:Connect(function(...) if self.Active then return callback(...) end end)
		self.Connections[#self.Connections + 1] = connection
		return connection
	end
	if type(deps.HookFunction) == "function" then
		self.HookFunction = function(target, replacement)
			local original = deps.HookFunction(target, replacement)
			self.Hooks[#self.Hooks + 1] = { Kind = "function", Target = target, Original = original }
			return original
		end
	end
	if type(deps.HookMeta) == "function" then
		self.HookMeta = function(target, name, replacement)
			local original = deps.HookMeta(target, name, replacement)
			self.Hooks[#self.Hooks + 1] = { Kind = "meta", Target = target, Name = name, Original = original }
			return original
		end
	end
	function self:Bind(env) self.Env = env end
    function self:InputBlocked()
        if not self.Active or deps.Input:GetFocusedTextBox()then return true end
        if self.PointerOverGUI then
            local ok,interacting=pcall(self.PointerOverGUI)
            if ok and interacting then return true end
            if not ok and not self.InputProbeWarned then
                self.InputProbeWarned=true
                deps.Warn("[DEVIL HUB] GUI input check failed: "..tostring(interacting))
            end
        end
        return self.Env and self.Env.S and self.Env.S.AutoActionBusy==true or false
    end
    function self:InputAction(fn)
        if self:InputBlocked()then return false end
        local owner=coroutine.running()
        if self.InputOwner and self.InputOwner~=owner then return false end
        local nested=self.InputOwner==owner
        self.InputOwner=owner
        local values=table.pack(pcall(fn))
        if not nested then
            if self.ReleaseInput then pcall(self.ReleaseInput)self.ReleaseInput=nil end
            self.InputOwner=nil
        end
        if not values[1]then deps.Warn("[DEVIL HUB / Input] "..tostring(values[2]))return false end
        return table.unpack(values,2,values.n)
    end
    function self:MousePoint()
        local viewport=deps.Viewport and deps.Viewport()
        if not viewport then return 0,0 end
        local root=self.Window and self.Window.MainFrame
        for _,fraction in ipairs({{.5,.5},{.25,.6},{.75,.6},{.5,.8},{.02,.55},{.98,.55},{.02,.85},{.98,.85}})do
            local x,y=math.floor(viewport.X*fraction[1]),math.floor(viewport.Y*fraction[2])
            local blocked=false
            if root and root.Visible then
                local pos,size=root.AbsolutePosition,root.AbsoluteSize
                blocked=x>=pos.X and x<=pos.X+size.X and y>=pos.Y and y<=pos.Y+size.Y
            end
            if not blocked and deps.PlayerGui.GetGuiObjectsAtPosition then
                local ok,objects=pcall(deps.PlayerGui.GetGuiObjectsAtPosition,deps.PlayerGui,x,y)
                if not ok then
                    if not self.TargetProbeWarned then
                        self.TargetProbeWarned=true
                        deps.Warn("[DEVIL HUB] GUI hit testing unavailable; using window bounds")
                    end
                else
                    for _,object in ipairs(objects)do if object:IsA("GuiButton")then blocked=true break end end
                end
            end
            if not blocked then return x,y end
        end
        return nil,nil
    end

    function self:IsVisible(object)
        if not object then return false end
        local current=object
        while current do
            if current:IsA("GuiObject")and not current.Visible then return false end
            if current:IsA("ScreenGui")and not current.Enabled then return false end
            current=current.Parent
        end
        return true
    end
    function self:FireButton(button)
        if type(deps.FireSignal)~="function"or type(deps.GetConnections)~="function"then return false end
        for _,name in ipairs({"Activated","MouseButton1Click"})do
            local ok,listeners=pcall(deps.GetConnections,button[name])
            if ok and type(listeners)=="table"then
                for _,listener in pairs(listeners)do
                    if listener.Enabled~=false and listener.Connected~=false then return pcall(deps.FireSignal,button[name],nil,1)end
                end
            end
        end
        return false
    end
	function self:UseSkill(slot, client, simulate)
		if self:InputBlocked() then return false end
        local rodGui=deps.PlayerGui:FindFirstChild("Rod")
        if rodGui then
            local mobilePanel=rodGui:FindFirstChild("Mobile")
            local desktop=rodGui:FindFirstChild("Desktop")
            local slots=mobilePanel and mobilePanel.Visible and mobilePanel:FindFirstChild("Slots")or desktop
            local slotGui=slots and slots:FindFirstChild("Slot"..slot)
            if slotGui and slotGui.GetDescendants then
                for _,node in ipairs(slotGui:GetDescendants())do
                    if node.Name=="Locked"and self:IsVisible(node)then return false end
                    if node.Name=="Timer"and self:IsVisible(node)and (tonumber(node.Text)or 0)>0 then return false end
                end
            end
        end
        local now=os.clock()
        self.LastSkill=self.LastSkill or {}
        if self.LastSkill[slot] and now-self.LastSkill[slot]<.75 then return false end
        self.LastSkill[slot]=now
		local keybinds
		if client then
			local ok, value = pcall(client.GetController, "KeybindsController")
			if ok then keybinds = value end
		end
		local entry = keybinds and keybinds.Keys and keybinds.Keys["Slot" .. slot]
		if type(entry) == "table" and type(entry.callback) == "function" then
			local ok = pcall(entry.callback, false)
			return ok -- One input path per attempt, including on callback failure.
		end
		local rod = deps.PlayerGui:FindFirstChild("Rod")
		local mobile = rod and rod:FindFirstChild("Mobile")
		local mobileMode = mobile and mobile.Visible
		if not rod then mobileMode = deps.Input.TouchEnabled and not deps.Input.KeyboardEnabled end
		if mobileMode and type(deps.FireSignal) == "function" and type(deps.GetConnections) == "function" then
			local slots = mobile and mobile:FindFirstChild("Slots")
			local button = slots and slots:FindFirstChild("Slot" .. slot)
			if button then
				for _, name in ipairs({ "Activated", "MouseButton1Click" }) do
					local ok, listeners = pcall(deps.GetConnections, button[name])
					if ok and type(listeners) == "table" then
						for _, listener in pairs(listeners) do
							if listener.Enabled ~= false and listener.Connected ~= false then return pcall(deps.FireSignal, button[name], nil, 1) end
						end
					end
				end
			end
		end
		local names = mobileMode and { "One", "Two", "Three", "Four" } or { "Z", "X", "C", "V" }
		return simulate(deps.KeyCode[names[slot]])~=false
	end
	function self:Stop(destroyUI)
		if not self.Active then return end
		self.Active = false
        if self.ReleaseInput then pcall(self.ReleaseInput)self.ReleaseInput=nil end
		local env = self.Env
		if env and env.S then
			for key, value in pairs(env.S) do if type(value) == "boolean" then env.S[key] = false end end
			if env.getRoot and self.ReturnCharacter == deps.Player.Character and env.S.LastInteractionReturnCF then
				local rootOK, root = pcall(env.getRoot)
				if not rootOK then root = nil end
				if root then pcall(function() root.CFrame = env.S.LastInteractionReturnCF end) end
			end
			for _, name in ipairs({ "setFly", "setPerfectCast", "stopTween", "clearESP", "clearBossRegionESP", "removeBossFarmPlatform" }) do
				if type(env[name]) == "function" then pcall(env[name], false) end
			end
		end
		for _, connection in ipairs(self.Connections) do pcall(connection.Disconnect, connection) end
		self.Connections = {}
		local current = coroutine.running()
		for thread in pairs(self.Threads) do if thread ~= current then pcall(baseTask.cancel, thread) end end
		self.Threads = {}
		for i = #self.Hooks, 1, -1 do
			local hook = self.Hooks[i]
			if hook.Kind == "function" then pcall(deps.HookFunction, hook.Target, hook.Original)
			else pcall(deps.HookMeta, hook.Target, hook.Name, hook.Original) end
		end
		self.Hooks = {}
		if destroyUI and self.UnloadLibrary then pcall(self.UnloadLibrary, self.Library) end
		if deps.OnStop then deps.OnStop() end
	end
	return self
end

end)()
local GuiFactory=(function()
-- WindUI control contract rendered entirely by the main DEVIL HUB OuroFlow GUI.
return function(flow,ctx)
    local ui={Scheme={},Windows={},Theme="Abyss"}
    local sequence=0
    local function name(info)return tostring(info.Title or info.Name or info.Text or "Control")end
    local function live()return ctx.Active end
    local function selected(value,values)
        if type(value)~="table"then return value end
        if value.Value~=nil then return selected(value.Value,values)end
        local out={}
        for _,v in ipairs(values or {})do
            if value[v]==true or table.find(value,v)then out[#out+1]=v end
        end
        return out
    end
    local function groupFacade(raw)
        local group={Raw=raw}
        local function control(kind,info)
            info=info or {}
            sequence+=1
            local constructing=true
            local multi=info.Multi==true or info.MultiSelect==true or info.Multiple==true
            local settings=type(info.Value)=="table"and info.Value or {}
            local default=info.Default
            if default==nil then default=info.Value end
            local opts={Name=name(info),Icon=info.Icon,Tooltip=info.Tooltip or info.Description,
                Flag="DevilFishing_"..sequence,CurrentValue=default,Visible=info.Visible~=false}
            if kind=="Slider"then
                opts.Range={settings.Min or info.Min or 0,settings.Max or info.Max or 100}
                opts.CurrentValue=settings.Default or info.Default or opts.Range[1]
                opts.Increment=settings.Step or info.Step or .01
            elseif kind=="Dropdown"then
                opts.Options=info.Values or info.Options or {}
                opts.MultipleOptions=multi opts.AllowNone=true opts.Searchable=true
                opts.CurrentOption=multi and selected(default or {},opts.Options)or default
            elseif kind=="Input"then
                opts.CurrentValue=tostring(default or "")opts.PlaceholderText=info.Placeholder
            end
            local proxy={Value=opts.CurrentValue,Values=opts.Options,Multi=multi}
            opts.Callback=function(value,...)
                proxy.Value=value
                if not constructing and live()and type(info.Callback)=="function"then return info.Callback(value,...)end
            end
            local widget=raw["Create"..kind](raw,opts)
            proxy.Raw=widget constructing=false
            function proxy:Set(value,silent)
                if kind=="Dropdown"and multi then value=selected(value,self.Values)end
                self.Value=value widget:Set(value,silent==true)
            end
            proxy.SetValue=proxy.Set proxy.SetSelected=proxy.Set proxy.Select=proxy.Set
            function proxy:Get()return widget:Get()end
            function proxy:Refresh(values,keep,silent)
                self.Values=values widget:Refresh(values,keep~=false,silent==true)
            end
            proxy.SetValues=proxy.Refresh
            function proxy:SetVisible(value)widget:SetVisible(value)end
            function proxy:SetTitle(value)if widget.SetTitle then widget:SetTitle(value)elseif widget.SetText then widget:SetText(value)end end
            function proxy:Destroy()widget:Destroy()end
            return proxy
        end
        for _,kind in ipairs({"Toggle","Slider","Dropdown","Input"})do group[kind]=function(_,info)return control(kind,info)end end
        function group:Button(info)
            return raw:CreateButton({Name=name(info),Icon=info.Icon,Tooltip=info.Tooltip or info.Description,
                Callback=function(...)if live()and info.Callback then return info.Callback(...)end end})
        end
        function group:Paragraph(info)
            local widget=raw:CreateParagraph({Title=name(info),Content=info.Desc or info.Content or info.Description or ""})
            local proxy={Raw=widget}
            function proxy:SetDesc(text)widget:Set(tostring(text or ""))end
            proxy.Set=proxy.SetDesc proxy.SetText=proxy.SetDesc
            function proxy:SetTitle(text)if widget.SetTitle then widget:SetTitle(text)end end
            function proxy:SetVisible(value)widget:SetVisible(value)end
            function proxy:Destroy()widget:Destroy()end
            return proxy
        end
        function group:AddDiscordBox(_,info)
            local picture=raw:CreateImage({Name="DEVIL HUB",Image=ctx.Logo,Height=105,ScaleType=Enum.ScaleType.Fit})
            local details=raw:CreateParagraph({Title="Discord",Content="https://discord.gg/ZY7PRcVJe2"})
            local button=raw:CreateButton({Name="Copy Discord Invite",Icon="copy",Callback=function()
                if live()then
                    local copy=setclipboard or toclipboard
                    if type(copy)=="function"then copy("https://discord.gg/ZY7PRcVJe2")end
                end
            end})
            local proxy={}
            function proxy:SetVisible(value)picture:SetVisible(value)details:SetVisible(value)button:SetVisible(value)end
            function proxy:Destroy()picture:Destroy()details:Destroy()button:Destroy()end
            return proxy
        end
        function group:DiscordBox(info)return self:AddDiscordBox("DevilDiscord",info)end
        return group
    end
    function ui:CreateWindow(info)
        local raw=flow:CreateWindow({Name="DEVIL HUB",Icon=ctx.Logo,LoadingSubtitle="FISHING MASTER",
            Theme="Abyss",Density="Compact",Profile=true,Search=true,Home=false,Loading=false,
            Backdrop=false,UnsupportedExecutor=false,Disclaimer=false,KeepOnScreen=true,IslandDraggable=true,
            Size=UDim2.fromOffset(820,550),ToggleUIKeybind="RightControl",
            ToggleButton={Platform="Both",Icon=ctx.Logo},
            ConfigurationSaving={Enabled=false,FolderName="DevilFishingStandalone"}})
        local window={Raw=raw,MainFrame=raw.Root,Tabs={}}
        local input=game:GetService("UserInputService")
        local touches={}
        if input.TouchEnabled then
            ctx:Connect(input.TouchStarted,function(touch)touches[touch]=true end)
            ctx:Connect(input.TouchEnded,function(touch)touches[touch]=nil end)
        end
        ctx.PointerOverGUI=function()
            local root=raw.Root
            if not root or not root.Visible then return false end
            local p,s=root.AbsolutePosition,root.AbsoluteSize
            local function inside(v)return v.X>=p.X and v.X<=p.X+s.X and v.Y>=p.Y and v.Y<=p.Y+s.Y end
            if input.MouseEnabled and input:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)and inside(input:GetMouseLocation())then return true end
            for touch in pairs(touches)do if inside(touch.Position)then return true end end
            return false
        end

        self.Windows[#self.Windows+1]=window
        local destroy=raw.Destroy
        raw.Destroy=function(self,...)ctx:Stop(false)return destroy(self,...)end
        function window:Tab(config)
            local native=raw:CreateTab({Name=name(config),Icon=config.Icon,Backdrop=false})
            local tab={Raw=native,Sections=0}
            self.Tabs[#self.Tabs+1]=tab
            function tab:Section(settings)
                self.Sections+=1
                local side=settings.Side or(self.Sections%2==1 and "Left"or "Right")
                return groupFacade(native:CreateGroupbox({Name=name(settings),Icon=settings.Icon,Side=side,Collapsed=false}))
            end
            tab.AddSection=tab.Section
            function tab:Select()raw:SelectTab(native)end
            tab.Show=tab.Select
            function tab:SetVisible(value)if native.SetVisible then native:SetVisible(value)end end
            return tab
        end
        function window:EditOpenButton(settings)if raw.SetToggleButtonIcon then raw:SetToggleButtonIcon(ctx.Logo)end end
        function window:SetCompact()end -- Compact density is set at construction.
        function window:SetFooter()end -- Main GUI uses its player profile and Home Discord card.
        function window:Tag()end -- Access status remains in the native Home section.
        function window:SetBackground(image)if raw.SetBackground then raw:SetBackground(image)end end
        window.SetBackgroundImage=window.SetBackground
        function window:Destroy()ui:Unload()end
        function window:Toggle(value)raw:Toggle(value)end
        return window
    end
    function ui:SetTheme(value)
        value=tostring(value or "Abyss")
        if value=="Dark"or value=="Midnight"then value="Abyss"end
        flow:SetTheme(value)self.Theme=value
    end
    function ui:GetCurrentTheme()return self.Theme end
    function ui:GetThemes()return{Abyss=true,Obsidian=true,Crimson=true}end
    function ui:UpdateColors()end -- The main GUI theme owns presentation colors.
    function ui:Notify(info)
        local window=self.Windows[#self.Windows]
        if window and live()then return window.Raw:Notify(info)end
    end
    function ui:Unload()flow:Unload()end
    return ui
end

end)()
return(function(...)
local env=type(getgenv)=="function" and getgenv()or _G
if env.DevilFishingNNVNStarting or env.DevilFishingNNVNRunning then return end
local args=table.pack(...)
local loading=Loading.Begin()
loading.Busy=true
env.DevilFishingNNVNStarting=true
local ctx,library,worker
local oldContext=env.DevilFishingNNVNContext
local oldLibrary,oldWindUI=env.Library,env.NNVN_WindUI
local function restore()
    if ctx and env.DevilFishingNNVNContext==ctx then env.DevilFishingNNVNContext=oldContext end
    if library and env.Library==library then env.Library=oldLibrary end
    if library and env.NNVN_WindUI==library then env.NNVN_WindUI=oldWindUI end
    if env.DevilFishingNNVNRunning==ctx then env.DevilFishingNNVNRunning=nil env.DevilFishingNNVNCleanup=nil end
    env.DevilFishingNNVNStarting=false
end
local function fetch(url)
    local done,success,body=false,false,nil
    local download=task.spawn(function() success,body=pcall(game.HttpGet,game,url) done=true end)
    local deadline=os.clock()+30
    while not done and os.clock()<deadline do task.wait(.1)end
    if not done then pcall(task.cancel,download)error("Download timed out after 30 seconds")end
    assert(success,body)
    assert(type(body)=="string" and #body>0,"Empty download")
    return body
end
local function compile(source,name)
    local fn,err=loadstring(source,name)
    assert(fn,err)
    return fn
end
local ok,result=xpcall(function()
    assert(game.PlaceId==99925503388128 or game.GameId==10039889230,"Open Fishing Master first")
    assert(type(loadstring)=="function","This script needs loadstring")
    assert(not env.DevilFishingTestRunning and not env.DevilFishingTestStarting,"Rejoin before replacing the previous Fishing Master backend")
    assert(not env.OuroborosFishingMaster or env.OuroborosFishingMaster.Unloaded==true,"Rejoin before replacing the previous Fishing Master backend")
    loading:SetStage("Downloading Fishing Master interface...",.12)
    local gui=fetch("https://raw.githubusercontent.com/joustingmatch/OuroFlow/7c495f5a17a2390d70809d628c82cd5384142dbd/Source.luau")
    assert(#gui==413023,"Unexpected GUI revision")
    loading:SetStage("Downloading the NNVN v1.4.8 game systems...",.4)
    local runtime=fetch("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/fishing-master-nnvn-runtime.lua?v=9")
    assert(#runtime==417619,"Unexpected game systems revision")
    local guiFn=compile(gui,"DEVIL HUB / interface")
    local runtimeFn=compile(runtime,"DEVIL HUB / Fishing Master")
    local logo=""
    local custom=getcustomasset or getsynasset
    if type(custom)=="function" and type(isfile)=="function" and isfile("devil-hub-logo-daceb9cac221.png")then
        local assetOK,asset=pcall(custom,"devil-hub-logo-daceb9cac221.png")
        if assetOK then logo=asset end
    end
    local player=game:GetService("Players").LocalPlayer
    ctx=ContextFactory({Task=task,Warn=warn,HookFunction=hookfunction,HookMeta=hookmetamethod,
        Input=game:GetService("UserInputService"),Player=player,PlayerGui=player:WaitForChild("PlayerGui"),
        FireSignal=firesignal,GetConnections=getconnections,KeyCode=Enum.KeyCode,Viewport=function()return workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize end,Logo=logo,OnStop=restore})
    env.DevilFishingNNVNContext=ctx
    loading:SetStage("Building the DEVIL HUB interface...",.6)
    library=GuiFactory(guiFn(),ctx)
    assert(type(library)=="table" and type(library.CreateWindow)=="function","Interface failed to initialize")
    ctx.Library=library
    ctx.UnloadLibrary=library.Unload
    if type(library.Unload)=="function"then
        library.Unload=function(self,...)ctx:Stop(false)return ctx.UnloadLibrary(self,...)end
    end
    loading:SetStage("Starting Fishing Master game controls...",.8)
    local done,started,startResult=false,false,nil
    worker=task.spawn(function()
        started,startResult=xpcall(function()return runtimeFn(table.unpack(args,1,args.n))end,debug.traceback)
        done=true
    end)
    local deadline=os.clock()+90
    while not done and os.clock()<deadline do task.wait(.1)end
    assert(done,"Game systems startup timed out after 90 seconds")
    assert(started,startResult)
    assert(ctx.Window and ctx.Window.MainFrame and ctx.Window.MainFrame.Parent,"Fishing Master window did not open")
    env.DevilFishingNNVNContext=oldContext
    env.DevilFishingNNVNStarting=false
    env.DevilFishingNNVNRunning=ctx
    env.DevilFishingNNVNCleanup=function()ctx:Stop(true)end
    loading:Finish(true)
    return startResult
end,debug.traceback)
if not ok then
    if worker then pcall(task.cancel,worker)end
    if ctx then ctx:Stop(true)end
    restore()
    loading:Finish(false,"Could not start Fishing Master. Check console for details.")
    warn("[DEVIL HUB / Fishing Master] "..tostring(result))
end
return result

end)(...)
