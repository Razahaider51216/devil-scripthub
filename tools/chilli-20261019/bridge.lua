local configureAppearance=(function()
-- Language is embedded in the window; no extra settings panel is created.
return function(library,window,tab,panels,env)
    local shared=env.DevilHubBlueGui
    return shared and not shared.Stopped and shared.Get()or{}
end

end)()
-- Existing DEVIL HUB OuroFlow frontend -> existing Chilli public UI handles.
-- Read-only discovery. No source patching, remote calls, callback replacement or gameplay rewrites.
return function(createLibrary,restoreStartup)
    local env=type(getgenv)=="function" and getgenv() or _G
    if env.DevilChilliPresentation then env.DevilChilliPresentation.Destroy() end
    if env.DevilChilliMainUI then env.DevilChilliMainUI.Destroy() end
    local report={schema="devil-chilli-main-ui-1",status="Discovering native UI handles",frontend="DEVIL HUB / OuroFlow",
        gameplayRewritten=false,callbacksReplaced=0,nativeOptions=0,boundOptions=0,originalPanelLinks=0,embeddedPanels=0}
    local stopped,mounted,syncing=false,false,false
    local library,window,nativeWindow,nativeRoot
    local connections,items,tabs,groups={},{},{},{}
    local embedded,hiddenScreens={},{}
    local session={Report=report,Items=items}
    env.DevilChilliMainUI=session
    local function save()
        if type(writefile)=="function" then pcall(function()
            writefile("DevilChilliMainUI-report.json",game:GetService("HttpService"):JSONEncode(report))
        end) end
    end
    local function notify(text)
        warn("DEVIL HUB / Chilli UI: "..tostring(text))
        if library then pcall(function() library:Notify({Title="DEVIL HUB",Content=tostring(text),Duration=7}) end) end
    end
    local function method(object,name)
        local ok,value=pcall(function()return object[name]end)
        return ok and type(value)=="function" and value or nil
    end
    local function invoke(object,name,...)
        local fn=method(object,name)
        assert(fn,"Native UI method unavailable: "..name)
        return fn(object,...)
    end
    local function try(object,name,...)
        local fn=method(object,name)
        if not fn then return false end
        return pcall(fn,object,...)
    end
    function session.Destroy()
        if stopped then return end
        stopped=true;mounted=false
        for _,c in ipairs(connections) do c:Disconnect() end
        table.clear(connections)
        -- Detach original widgets BEFORE destroying our GUI, preserving their live controllers.
        for _,panel in ipairs(embedded) do
            local row=panel.Row
            if row.Parent then
                pcall(function()
                    row.Parent=panel.Parent;row.Size=panel.Size;row.Position=panel.Position
                    row.AnchorPoint=panel.AnchorPoint;row.LayoutOrder=panel.LayoutOrder
                    if panel.Style then try(panel.Native,"SetStyle",panel.Style) end
                end)
            end
        end
        for screen,enabled in pairs(hiddenScreens) do pcall(function()screen.Enabled=enabled end) end
        if library then pcall(function() library:Destroy() end) end
        if restoreStartup then restoreStartup();restoreStartup=nil end
        -- Unloading this adapter leaves the working protected engine running.
        if nativeWindow and not rawget(nativeWindow,"_destroyed") then try(nativeWindow,"Open") end
        if env.DevilChilliMainUI==session then env.DevilChilliMainUI=nil end
    end
    local function rootFor(candidate)
        if type(candidate)~="table" or rawget(candidate,"_kind")~="Window" or rawget(candidate,"_destroyed") then return end
        local nativeTabs=rawget(candidate,"Tabs")
        if type(nativeTabs)~="table" then return end
        for _,tab in ipairs(nativeTabs) do
            if type(tab)~="table" or rawget(tab,"Window")~=candidate then continue end
            local page=rawget(tab,"Page")
            if typeof(page)~="Instance" then continue end
            local ancestor=page.Parent
            while ancestor do
                if ancestor:IsA("ScreenGui") and ancestor.Name=="Settings" and ancestor:GetAttribute("ChilliLibraryOwned")==true then
                    return ancestor
                end
                ancestor=ancestor.Parent
            end
        end
    end
    local function discover()
        local exported=env.DevilChilliNativeWindow
        local readable,root=pcall(rootFor,exported)
        if readable and root and method(exported,"SelectTab") and method(exported,"Open") and method(exported,"Close") then
            report.discovery="Recovered native UI constructor export (no getgc required)"
            return exported,root
        end
        if type(getgc)~="function" then return nil,"Delta does not expose getgc; native UI left available" end
        local ok,objects=pcall(getgc,true)
        if not ok or type(objects)~="table" then return nil,"Executor could not enumerate native UI tables" end
        report.gcObjects=#objects;report.tableObjects=0
        for index,candidate in ipairs(objects) do
            if index%2048==0 and task and task.wait then task.wait() end
            if type(candidate)~="table" then continue end
            report.tableObjects+=1
            local readable,root=pcall(rootFor,candidate)
            if not readable then report.uiReadFailures=(report.uiReadFailures or 0)+1;continue end
            if root and method(candidate,"SelectTab") and method(candidate,"Open") and method(candidate,"Close") then
                return candidate,root
            end
        end
        return nil,"Native Chilli Window handles were not exposed; original UI remains available"
    end
    local function signature(value)
        if type(value)=="table" then
            local list={};for _,v in ipairs(value) do table.insert(list,tostring(v)) end
            return table.concat(list,"\31")
        end
        return type(value)..":"..tostring(value)
    end
    local function value(option)
        local ok,result=try(option,"Get");if ok then return result end;return nil
    end
    local function note(option)
        local c=rawget(option,"_controller")
        if type(c)~="table" or not method(c,"GetNote") then return "" end
        local ok,result=try(option,"GetNote");return ok and tostring(result or "") or ""
    end
    local function choices(option)
        local row=rawget(option,"Instance")
        local numbered={}
        if typeof(row)=="Instance" then
            for _,node in ipairs(row:GetDescendants()) do
                local index=tonumber(node.Name:match("^Option(%d+)$"))
                if index and node:IsA("GuiButton") then
                    local label=node:FindFirstChild("Label")
                    if label and label:IsA("TextLabel") then numbered[index]=label.Text end
                end
            end
        end
        local options={}
        for i=1,#numbered do options[i]=numbered[i] end
        return options
    end
    local function icon(name)
        local n=name:lower()
        if n:find("pet",1,true) or n:find("egg",1,true) or n:find("hatch",1,true) then return "egg" end
        if n:find("player",1,true) then return "user" end
        if n:find("tele",1,true) or n:find("server",1,true) then return "globe" end
        if n:find("setting",1,true) then return "settings" end
        if n:find("farm",1,true) or n:find("auto",1,true) then return "swords" end
        return "layout-grid"
    end
    local function embedPanel(option,group,entry)
        local row=rawget(option,"Instance")
        if typeof(row)~="Instance" or not row:IsA("GuiObject") or typeof(group.List)~="Instance" then return false end
        local panel={Native=option,Row=row,Parent=row.Parent,Size=row.Size,Position=row.Position,
            AnchorPoint=row.AnchorPoint,LayoutOrder=row.LayoutOrder}
        table.insert(embedded,panel)
        local host=Instance.new("Frame")
        host.Name="DevilNativePanel";host.BackgroundTransparency=1;host.BorderSizePixel=0
        host:SetAttribute("NoDrag",true)
        host.Size=UDim2.new(1,0,0,math.max(100,row.Size.Y.Offset));host.LayoutOrder=group._order or #group.List:GetChildren()+1
        group._order=host.LayoutOrder
        host.Parent=group.List
        row.Parent=host;row.AnchorPoint=Vector2.new(.5,0);row.Position=UDim2.fromScale(.5,0)
        -- Brand the actual embedded Discord image, including canvases from an older engine.
        if option.Name=="Discord" then
            local logo=env.DevilChilliBrandLogo or (library.Assets and library.Assets.Logo)
            local function brandImage(node)
                if not logo or not(node:IsA("ImageLabel") or node:IsA("ImageButton")) then return end
                if node.Image~="rbxassetid://128961717706452" and node.Name~="Logo" then return end
                local function update()
                    if not stopped and node.Parent and node.Image~=logo then node.Image=logo end
                end
                table.insert(connections,node:GetPropertyChangedSignal("Image"):Connect(update))
                update()
            end
            for _,node in ipairs(row:GetDescendants()) do brandImage(node) end
            table.insert(connections,row.DescendantAdded:Connect(brandImage))
        end
        local updating=false
        local function measure()
            if stopped or updating or not row.Parent then return end
            updating=true
            local height=math.max(1,row.Size.Y.Offset)
            if height<=1 then height=math.max(100,row.AbsoluteSize.Y) end
            host.Size=UDim2.new(1,0,0,height)
            updating=false
        end
        table.insert(connections,row:GetPropertyChangedSignal("Size"):Connect(measure));measure()
        local styleOK,style=try(option,"GetStyle")
        if styleOK and type(style)=="table" and method(option,"SetStyle") then
            panel.Style=table.clone(style)
            local theme=library.Theme or {}
            try(option,"SetStyle",{BackgroundColor=theme.Surface2 or Color3.fromRGB(20,18,27),BackgroundTransparency=.08,
                TextColor=theme.Text or Color3.fromRGB(236,233,245),TextStrokeTransparency=1,
                StrokeColor=theme.Stroke or Color3.fromRGB(31,28,41),StrokeTransparency=.35})
        end
        entry.Embedded=true
        local control={_frame=host,_type="Canvas",_userVisible=true,_listeners={},
            _searchName=tostring(option.Name),_searchKey=tostring(option.Name):lower()}
        function control:IsVisible()return self._userVisible end
        function control:_isShown()return self._userVisible and group._userVisible~=false end
        function control:SetVisible(shown)
            if self._userVisible==shown then return end
            self._userVisible=shown;host.Visible=shown;window._controlsDirty=true
        end
        function control:Destroy()
            if row.Parent==host then row.Parent=panel.Parent end
            if type(group._items)=="table" then
                local index=table.find(group._items,self);if index then table.remove(group._items,index) end
            end
            host:Destroy();self._destroyed=true
        end
        if type(group._items)=="table" then table.insert(group._items,control) end
        window._controlsDirty=true
        entry.Control=control
        report.embeddedPanels+=1
        -- Original images, viewport models, item selection and numeric labels remain live.
        return true
    end
    local function hideOriginalScreens()
        local parents={nativeRoot.Parent}
        local playerGui=game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if playerGui and playerGui~=nativeRoot.Parent then table.insert(parents,playerGui) end
        for _,parent in ipairs(parents) do
            for _,screen in ipairs(parent:GetChildren()) do
                if screen:IsA("ScreenGui") and screen:GetAttribute("ChilliLibraryOwned")==true and
                    (screen==nativeRoot or screen.Name=="ChilliLeftCenter") then
                    if hiddenScreens[screen]==nil then
                        hiddenScreens[screen]=screen.Enabled
                        table.insert(connections,screen:GetPropertyChangedSignal("Enabled"):Connect(function()
                            if not stopped and screen.Enabled then screen.Enabled=false end
                        end))
                    end
                    screen.Enabled=false
                end
            end
        end
    end
    local function add(option,section,group)
        if items[option] then return end
        local kind=tostring(rawget(option,"Type") or ""):lower():gsub("[%s_%-]","")
        local name=tostring(rawget(option,"Name") or "")
        local entry={Native=option,Kind=kind,Group=group,Section=section}
        items[option]=entry;report.nativeOptions+=1
        local function change(v)
            if stopped or not mounted or syncing then return end
            local ok,err=pcall(function()invoke(option,"Set",v,true)end)
            if not ok then notify(name..": "..tostring(err)) end
            session.Sync()
        end
        local config={Name=name,Description=note(option),Callback=change}
        local current=value(option)
        if (kind=="toggle" or kind=="switch") and method(option,"Get") and method(option,"Set") then
            config.CurrentValue=current==true;entry.Control=group:CreateToggle(config)
        elseif (kind=="slider" or kind=="slidebar") and method(option,"GetRange") and method(option,"Set") then
            local ok,low,high=try(option,"GetRange")
            assert(ok and type(low)=="number" and type(high)=="number","Invalid native slider range: "..name)
            local _,decimals,places=try(option,"GetDecimals")
            config.Range={low,high};config.Increment=decimals and 10^(-(tonumber(places) or 2)) or 1
            config.CurrentValue=current;entry.Range=signature(config.Range);entry.Control=group:CreateSlider(config)
        elseif (kind=="input" or kind=="textbox") and method(option,"Set") then
            config.CurrentValue=tostring(current or "");entry.Control=group:CreateInput(config)
        elseif (kind=="label" or kind=="text") then
            config.Name=tostring(current or name);config.Callback=nil
            entry.Control=group:CreateLabel(config)
        elseif kind=="button" and method(option,"Press") then
            config.Callback=function()
                if stopped or not mounted then return end
                local ok,err=try(option,"Press");if not ok then notify(err) end
                session.Sync()
            end
            entry.Control=group:CreateButton(config)
        elseif (kind:find("dropdown",1,true) or kind=="cycleselector") and method(option,"Get") and method(option,"Set") then
            local available=choices(option)
            if #available>0 then
                config.Options=available;config.CurrentOption=type(current)=="table" and current or {current}
                config.MultipleOptions=kind:find("multi",1,true)~=nil;config.AllowNone=config.MultipleOptions
                entry.Options=signature(available);entry.Control=group:CreateDropdown(config)
                if kind:find("action",1,true) and method(option,"Apply") then
                    entry.Apply=group:CreateButton({Name="Apply: "..name,Callback=function()
                        if stopped or not mounted then return end
                        local ok,err=try(option,"Apply");if not ok then notify(err) end;session.Sync()
                    end})
                end
            end
        end
        if entry.Control then
            entry.Config=config;entry.Last=signature(current);entry.Note=config.Description;report.boundOptions+=1
        elseif not embedPanel(option,group,entry) then
            error("Cannot embed original interactive panel: "..name)
        end
    end
    local function populate()
        local added=0
        for _,tab in ipairs(nativeWindow.Tabs) do
            local tabName=tostring(tab.Name or tab.DisplayName or ""):lower()
            if tabName=="venyx" or tabName=="devil hub" then continue end
            local target=tabs[tab]
            if not target then
                local name=tostring(tab.DisplayName or tab.Name)
                target=window:CreateTab({Name=name,Icon=icon(name)});tabs[tab]=target
                if typeof(target._page)=="Instance" then
                    table.insert(connections,target._page:GetPropertyChangedSignal("Visible"):Connect(function()
                        if mounted and not stopped and target._page.Visible then try(nativeWindow,"SelectTab",tab) end
                    end))
                end
            end
            for index,section in ipairs(tab.Sections) do
                local group=groups[section]
                if not group then
                    group=target:CreateGroupbox({Name=tostring(section.DisplayName or section.Name),Side=index%2==1 and "Left" or "Right"})
                    groups[section]=group
                end
                for _,option in ipairs(section.Options) do
                    if tabName=="settings" and tostring(option.Name)=="UI Size" then continue end
                    local fresh=items[option]==nil
                    add(option,section,group)
                    if fresh and not mounted then
                        added+=1
                        if added%20==0 and task and task.wait then task.wait() end
                    end
                end
            end
        end
    end
    function session.Sync()
        if stopped or not mounted or syncing then return end
        syncing=true
        local ok,err=pcall(function()
            populate()
            for native,entry in pairs(items) do
                local control=entry.Control
                if rawget(native,"_destroyed") then
                    if control.Destroy then control:Destroy() end
                    if entry.Apply and entry.Apply.Destroy then entry.Apply:Destroy() end
                    items[native]=nil;continue
                end
                local shownOK,shown=try(native,"IsVisible")
                if shownOK and control.SetVisible then control:SetVisible(shown) end
                if shownOK and entry.Apply and entry.Apply.SetVisible then entry.Apply:SetVisible(shown) end
                if entry.Embedded or entry.Kind=="button" then continue end
                local current=value(native)
                if entry.Range then
                    local rangeOK,low,high=try(native,"GetRange")
                    local nextRange=rangeOK and signature({low,high}) or entry.Range
                    if nextRange~=entry.Range then
                        local order=control._frame and control._frame.LayoutOrder
                        control:Destroy()
                        entry.Config.Range={low,high};entry.Config.CurrentValue=current
                        control=entry.Group:CreateSlider(entry.Config);entry.Control=control;entry.Range=nextRange
                        if order and control._frame then control._frame.LayoutOrder=order end
                    end
                end
                if entry.Options and control.Refresh then
                    local opts=choices(native);local sig=signature(opts)
                    if #opts>0 and sig~=entry.Options then control:Refresh(opts,true,true);entry.Options=sig end
                end
                local sig=signature(current)
                if sig~=entry.Last and control.Set then
                    local display=current
                    if entry.Options and type(display)~="table" then display={display} end
                    control:Set(display,true);entry.Last=sig
                end
                local description=note(native)
                if description~=entry.Note then
                    -- OuroFlow exposes live Description labels on its controls.
                    if typeof(control.Desc)=="Instance" then control.Desc.Text=description end
                    entry.Note=description
                end
            end
        end)
        syncing=false
        if not ok then report.syncError=tostring(err);notify(err);save() end
    end
    local ok,err=xpcall(function()
        local found,rootOrReason=discover()
        if not found then
            report.status="Native UI handles unavailable";report.reason=rootOrReason;save();notify(rootOrReason);session.Destroy();return
        end
        nativeWindow,nativeRoot=found,rootOrReason;session.NativeWindow=nativeWindow
        library=createLibrary()
        local logo=DevilReleaseScope.DevilHubSilverLogo or "https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png?logo=silver-20261011"
        local asset=getcustomasset or getsynasset
        if not DevilReleaseScope.DevilHubSilverLogo and type(asset)=="function" and type(writefile)=="function" then
            local assetOK,image=pcall(function()
                local file="DevilHub_Silver_20261011.png"
                if not(type(isfile)=="function" and isfile(file)) then
                    local data=game:HttpGet(logo);assert(data:sub(1,8)=="\137PNG\r\n\26\n","Invalid DEVIL HUB logo");writefile(file,data)
                end
                return asset(file)
            end)
            if assetOK then logo=image end
        end
        if library.Assets then library.Assets.Logo=logo end
        -- SAME library version and window configuration as the main DEVIL HUB script.
        window=library:CreateWindow({Name="DEVIL HUB",Icon=logo,Theme="Abyss",Size=UDim2.fromOffset(880,520),Density="Compact",
            Profile=true,Search=true,Loading=false,Backdrop=false,Disclaimer=false,UnsupportedExecutor=false,
            KeepOnScreen=true,ConfigurationSaving={Enabled=false},
            Home={Title="DEVIL HUB / Steal an Egg",Discord="https://discord.gg/fDwPCmpkkh"},
            ToggleButton={Title="DEVIL HUB",Icon=logo,Platform="Both",Keybind=Enum.KeyCode.K}})
        -- OuroFlow owns its ScreenGui on the returned WINDOW, not the library.
        if typeof(window.Gui)=="Instance" then
            window.Gui:SetAttribute("DevilHubPresentation",true)
            window.Gui.Enabled=true
        end
        populate();mounted=true;session.Sync()
        invoke(nativeWindow,"Close")
        hideOriginalScreens()
        local settingsTab
        for native,target in pairs(tabs)do
            if tostring(native.Name):lower()=="settings"then settingsTab=target;break end
        end
        settingsTab=settingsTab or window:CreateTab({Name="Settings",Icon="settings"})
        configureAppearance(library,window,settingsTab,embedded,env)
        local nativeFrame=nativeRoot:FindFirstChild("Frame")
        if nativeFrame then table.insert(connections,nativeRoot.Destroying:Connect(session.Destroy)) end
        if window.Gui and window.Gui.Destroying then table.insert(connections,window.Gui.Destroying:Connect(session.Destroy)) end
        local elapsed=0
        table.insert(connections,game:GetService("RunService").Heartbeat:Connect(function(dt)
            elapsed+=dt
            if elapsed>=0.45 then elapsed=0;session.Sync();hideOriginalScreens() end
        end))
        report.status="Mounted DEVIL HUB main GUI on original Chilli handles";report.libraryCommit="c8251f76f74d9942114ebccb0564aa0ac196320a";save()
    end,function(e)return tostring(e)end)
    if not ok then report.status="UI adapter failed; original runtime preserved";report.error=err;save();notify(err);session.Destroy() end
    return session
end
