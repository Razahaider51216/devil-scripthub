-- Presentation only: watch the native GUI containers before starting the runtime.
return function()
    local scope=type(getgenv)=="function"and getgenv()or _G
    if type(scope.DevilChilliEarlyGuardStop)=="function"then return scope.DevilChilliEarlyGuardStop end
    local hidden,connections,containers={},{},{}
    local stopped=false
    local markers={}
    local function nativeScreen(screen)
        if screen:GetAttribute("DevilNativeCanvas")==true then return false end
        if screen.Name=="DEVIL HUB" or screen:GetAttribute("DevilHubPresentation")==true then return false end
        if screen.Name=="ChilliHubLoading" or screen:GetAttribute("ChilliLibraryOwned")==true then return true end
        local mark=markers[screen] or {}
        if mark.brand then return true end
        -- Exact footprint of the native random-name performance screen.
        return mark.fps and mark.ms and screen.DisplayOrder==58 and screen.Archivable==false and screen.ResetOnSpawn==false
    end
    local function hide(screen)
        if stopped or not screen:IsA("ScreenGui") then return end
        if hidden[screen]~=nil then return end
        if not nativeScreen(screen) then return end
        hidden[screen]=screen.Enabled
        screen.Enabled=false
        table.insert(connections,screen:GetPropertyChangedSignal("Enabled"):Connect(function()
            if not stopped and screen.Enabled and screen.Name~="DEVIL HUB" and screen:GetAttribute("DevilHubPresentation")~=true then screen.Enabled=false end
        end))
    end
    local tracked={}
    local function track(child)
        if not child:IsA("ScreenGui") or tracked[child] then return end
        if child:GetAttribute("DevilNativeCanvas")==true then return end
        tracked[child]=true
        markers[child]={}
        hide(child)
        if hidden[child]~=nil or child:GetAttribute("DevilHubPresentation")==true then return end
        table.insert(connections,child:GetPropertyChangedSignal("Name"):Connect(function()hide(child)end))
        table.insert(connections,child:GetAttributeChangedSignal("ChilliLibraryOwned"):Connect(function()hide(child)end))
        local function inspect(node)
            if stopped or hidden[child]~=nil or child.Name=="DEVIL HUB" or child:GetAttribute("DevilHubPresentation")==true then return end
            local property=(node:IsA("TextLabel") or node:IsA("TextButton")) and "Text"
                or (node:IsA("ImageLabel") or node:IsA("ImageButton")) and "Image"
            if not property then return end
            local function checkNode()
                local mark=markers[child];local value=node[property]
                if property=="Text" then
                    mark.brand=mark.brand or value=="Chilli Hub"
                    mark.fps=mark.fps or value=="FPS";mark.ms=mark.ms or value=="ms"
                else mark.brand=mark.brand or value=="rbxassetid://128961717706452" end
                if mark.brand or (mark.fps and mark.ms) then hide(child) end
            end
            checkNode()
            if node[property]=="" and hidden[child]==nil then
                table.insert(connections,node:GetPropertyChangedSignal(property):Connect(checkNode))
            end
        end
        table.insert(connections,child.DescendantAdded:Connect(inspect))
        for _,node in ipairs(child:GetDescendants()) do inspect(node) end
    end
    local function watch(container)
        if typeof(container)~="Instance" or containers[container] then return end
        containers[container]=true
        table.insert(connections,container.DescendantAdded:Connect(track))
        for _,child in ipairs(container:GetDescendants()) do track(child) end
    end
    pcall(function()watch(game:GetService("CoreGui"))end)
    pcall(function()if type(gethui)=="function" then watch(gethui()) end end)
    pcall(function()watch(game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui"))end)
    local function stop()
        if stopped then return end
        stopped=true
        for _,connection in ipairs(connections) do connection:Disconnect() end
        if scope.DevilChilliEarlyGuardStop==stop then scope.DevilChilliEarlyGuardStop=nil end
        table.clear(connections);table.clear(hidden);table.clear(containers);table.clear(tracked);table.clear(markers)
    end
    scope.DevilChilliEarlyGuardStop=stop
    return stop
end
