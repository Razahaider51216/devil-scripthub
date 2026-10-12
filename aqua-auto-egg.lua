-- DEVIL HUB / Aqua Auto Egg test. Teleport collection and game prompt interactions.
assert(game.PlaceId==104050046639813,"Open the Aqua map (Place 104050046639813) first.")
local scope=type(getgenv)=="function"and getgenv()or _G
if scope.DevilAquaAutoEgg then scope.DevilAquaAutoEgg.Destroy()end
local window,core
local function logo()
    local image="https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assets/devil-logo.png?logo=aqua-1"
    local asset=getcustomasset or getsynasset
    if type(asset)=="function"and type(writefile)=="function"then
        local ok,value=pcall(function()
            local file="DevilHub_Aqua_Logo.png"
            if not(type(isfile)=="function"and isfile(file))then
                local data=game:HttpGet(image)
                assert(data:sub(1,8)=="\137PNG\r\n\26\n","Invalid logo response")
                writefile(file,data)
            end
            return asset(file)
        end)
        if ok and type(value)=="string"and value~=""then image=value end
    end
    return image
end
local config={Farm=false,Hatch=false,EquipBest=false,Tiers={},MinKg=0,MinLuck=0,Order="Nearest",Dropped=true,Teleport=true}
local function fetch(url,label)
    local problem
    for attempt=1,3 do
        local ok,source=pcall(game.HttpGet,game,url)
        if ok and type(source)=="string"and #source>100 then
            local run,err=loadstring(source,label)
            if run then return run()end
            problem=err
        else problem=source end
        task.wait(attempt)
    end
    error(tostring(problem),0)
end
local done=false
local controller={}
function controller.Destroy()
    if done then return end;done=true
    if core then core.Destroy()end
    if scope.DevilAquaAutoEgg==controller then scope.DevilAquaAutoEgg=nil end
    if window then window:Destroy()end
end
scope.DevilAquaAutoEgg=controller
local ok,err=xpcall(function()
    local library=fetch("https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau","DEVIL HUB / OuroFlow")
    local image=logo()
    window=library:CreateWindow({Name="DEVIL HUB",Icon=image,Theme="Crimson",Density="Compact",
        Profile=true,Search=true,Home=false,Loading=false,Backdrop=false,UnsupportedExecutor=false,Disclaimer=false,
        Size=UDim2.fromOffset(760,510),ToggleButton={Platform="Both",Icon=image},IslandDraggable=true,KeepOnScreen=true,
        ConfigurationSaving={Enabled=false,FolderName="DevilAqua"}})
    local tab=window:CreateTab({Name="Auto Egg",Icon="egg",Backdrop=false})
    local farm=tab:CreateGroupbox({Name="Egg Farm",Side="Left"})
    local filters=tab:CreateGroupbox({Name="Egg Filters",Side="Right"})
    local state=farm:CreateLabel({Text="Preparing game controls..."})
    local totals=farm:CreateLabel({Text="Picked: 0 | Deposited: 0 | Hatch requests: 0"})
    local make=(function()
return function(config,onStatus)
    local Players=game:GetService("Players")
    local player=Players.LocalPlayer
    local RS=game:GetService("ReplicatedStorage")
    local Run=game:GetService("RunService")
    local requests=assert(RS:WaitForChild("EggGame",15),"EggGame unavailable"):WaitForChild("Requests",15)
    local events=RS.EggGame:WaitForChild("Events",15)
    assert(requests and events,"Egg remotes unavailable")
    local api={Config=config,Report={release="aqua-auto-egg-3",picked=0,deposited=0,hatchRequests=0,errors={}}}
    local active=true
    local links={}
    local hatches={}
    local retryEgg={}
    local hatchRetry={}
    local selected
    local motion
    local heldPrompt
    local lastEquip=-math.huge
    local now=os.clock
    local function status(text)
        api.Report.status=text
        api.Report.carriedEggId=player:GetAttribute("CarriedEggId")
        if onStatus then pcall(onStatus,text,api.Report)end
    end
    local function logError(err)
        local text=tostring(err)
        if #api.Report.errors>=20 then table.remove(api.Report.errors,1)end
        api.Report.errors[#api.Report.errors+1]={t=now(),message=text}
        warn("[DEVIL HUB / AQUA] "..text)
    end
    local function alive()
        local c=player.Character
        local h=c and c:FindFirstChildOfClass("Humanoid")
        local root=c and c:FindFirstChild("HumanoidRootPart")
        if h and root and h.Health>0 then return c,h,root end
    end
    local function carried()
        local id=player:GetAttribute("CarriedEggId")
        return type(id)=="string"and id~=""and id or nil
    end
    local function promptPosition(prompt)
        local parent=prompt and prompt.Parent
        if not parent then return end
        if parent:IsA("Attachment")then return parent.WorldPosition end
        if parent:IsA("BasePart")then return parent.Position end
        if parent:IsA("Model")then return parent:GetPivot().Position end
    end
    local function ownPot()
        local name=player:GetAttribute("PlayerPot")
        return type(name)=="string"and workspace:FindFirstChild(name)or nil
    end
    local function ownPrompt(prompt)
        local pot=ownPot()
        if not pot or not prompt:IsDescendantOf(pot)then return false end
        local object=prompt.Parent
        while object and object~=workspace do
            local owner=object:GetAttribute("OwnerUserId")
            if owner~=nil then return tonumber(owner)==player.UserId end
            if object==pot then break end
            object=object.Parent
        end
        return true -- PlayerPot itself is a player attribute supplied by the game.
    end
    local function hatchInteraction(prompt)
        local object=prompt and prompt.Parent
        local pot=ownPot()
        while object and object~=pot and object~=workspace do
            if object:GetAttribute("HatchSlot")~=nil then return object end
            object=object.Parent
        end
        return prompt and prompt.Parent
    end
    local function availableDeposit(prompt,requireEnabled)
        if not prompt or not prompt.Parent or not ownPrompt(prompt)then return false end
        local interaction=hatchInteraction(prompt)
        local state=interaction and interaction:GetAttribute("Status")
        -- Enabled is an interaction gate; the game may disable deposits until
        -- the player carries an egg. Empty is the slot capacity signal.
        local empty=state=="Empty"or(state==nil and prompt.Enabled)
        return empty and(not requireEnabled or prompt.Enabled)
    end
    local function nearestDeposit(requireEnabled)
        local _,_,root=alive()
        local pot=ownPot()
        local scan={playerPot=player:GetAttribute("PlayerPot"),potFound=pot~=nil,prompts=0,owned=0,empty=0,enabled=0,slots={}}
        api.Report.slotScan=scan
        if not root or not pot then return end
        local best,distance
        for _,node in ipairs(pot:GetDescendants())do
            if node:IsA("ProximityPrompt")and node.Name=="DepositSeaEgg"then
                scan.prompts+=1
                if node.Enabled then scan.enabled+=1 end
                local interaction=hatchInteraction(node)
                local state=interaction and interaction:GetAttribute("Status")
                local owned=ownPrompt(node)
                if owned then scan.owned+=1;if state=="Empty"then scan.empty+=1 end end
                scan.slots[#scan.slots+1]={slot=interaction and interaction:GetAttribute("HatchSlot"),status=state,enabled=node.Enabled,owned=owned,owner=interaction and interaction:GetAttribute("OwnerUserId")}
                if availableDeposit(node,requireEnabled)then
                    local point=promptPosition(node)
                    local d=point and(root.Position-point).Magnitude
                    if d and(not distance or d<distance)then best,distance=node,d end
                end
            end
        end
        return best
    end
    local function noDepositStatus()
        local scan=api.Report.slotScan or{}
        if not scan.potFound then return "Waiting for your PlayerPot to load"end
        if scan.prompts==0 then return "Waiting for hatch rack / deposit prompts to load"end
        if scan.owned==0 then return "No owned deposit slots found; save report"end
        return "No empty hatch slot; waiting for hatch completion"
    end
    local function pickupPrompt(model)
        for _,node in ipairs(model:GetDescendants())do
            if node:IsA("ProximityPrompt")and(node.Name=="TakeSeaEgg"or node.Name=="PickupDroppedEgg")and node.Enabled then return node end
        end
    end
    local function eligible(model)
        if not model or not model.Parent or not model:IsA("Model")then return false end
        local id=model:GetAttribute("EggId")
        if type(id)~="string"or id==""or now()<(retryEgg[id]or 0)then return false end
        local tier=model:GetAttribute("EggTier")
        if next(config.Tiers)and not config.Tiers[tier]then return false end
        if(tonumber(model:GetAttribute("EggKg"))or 0)<config.MinKg then return false end
        if(tonumber(model:GetAttribute("EggLuck"))or 0)<config.MinLuck then return false end
        return pickupPrompt(model)~=nil
    end
    local function chooseEgg()
        local _,_,root=alive()
        if not root then return end
        local runtime=workspace:FindFirstChild("EggRuntime")
        if not runtime then return end
        local best,bestScore
        for _,folderName in ipairs(config.Dropped and{"WildEggs","DroppedEggs"}or{"WildEggs"})do
            local folder=runtime:FindFirstChild(folderName)
            for _,model in ipairs(folder and folder:GetChildren()or{})do
                if eligible(model)then
                    local point=promptPosition(pickupPrompt(model))
                    if point then
                        local distance=(root.Position-point).Magnitude
                        local score=config.Order=="Highest Luck"and-(tonumber(model:GetAttribute("EggLuck"))or 0)or distance
                        if not bestScore or score<bestScore then best,bestScore=model,score end
                    end
                end
            end
        end
        return best
    end
    local function stopMotion()
        local old=motion;motion=nil
        if not old then return end
        pcall(Run.UnbindFromRenderStep,Run,old.bindName)
        if old.controls and old.controls.GetMoveVector==old.override then old.controls.GetMoveVector=old.originalMove end
        if old.controls and old.wasEnabled then pcall(old.controls.Enable,old.controls)end
        if old.camera and workspace.CurrentCamera==old.camera then
            pcall(function()old.camera.CameraType=old.cameraType;old.camera.CFrame=old.cameraFrame end)
        end
        if old.humanoid and old.root.Parent then
            pcall(function()old.humanoid:Move(Vector3.zero,false);old.humanoid:MoveTo(old.root.Position)end)
        end
        if player:GetAttribute("MilkfishRiding")==true then
            local remote=RS:FindFirstChild("MilkfishRideInput")
            if remote then pcall(remote.FireServer,remote,Vector3.zero)end
        end
    end
    local function travel(prompt,check,allowDisabled)
        stopMotion()
        local character,humanoid,root=alive()
        if not root then return false,"Waiting for character"end
        local riding=player:GetAttribute("MilkfishRiding")==true
        local point=promptPosition(prompt)
        if not point then return false,"Target disappeared"end
        -- Ground movement uses the normal humanoid. Underwater steering uses
        -- the existing ride controller's GetMoveVector input and camera direction.
        if not config.Teleport and not riding and point.Y<root.Position.Y-15 then return false,"Mount a fish to reach underwater eggs"end
        local token={humanoid=humanoid,root=root,bindName="DevilAquaEggMovement"}
        motion=token
        local ok,module=pcall(function()return require(player.PlayerScripts:WaitForChild("PlayerModule",5))end)
        if ok and module then
            token.controls=module:GetControls()
            token.wasEnabled=token.controls.controlsEnabled~=false
            token.originalMove=token.controls.GetMoveVector
            token.controls:Disable()
            token.override=function(self,...)
                if motion==token then return not config.Teleport and player:GetAttribute("MilkfishRiding")==true and Vector3.new(0,0,-1)or Vector3.zero end
                return token.originalMove(self,...)
            end
            token.controls.GetMoveVector=token.override
        elseif riding and not config.Teleport then stopMotion();return false,"Ride controls unavailable"end
        if config.Teleport then
            local function coordinates(v)return {x=v.X,y=v.Y,z=v.Z}end
            local record={mode="Teleport",prompt=prompt.Name,from=coordinates(root.Position),target=coordinates(point),stage="Starting"}
            api.Report.travel=record
            if riding then
                local remote=RS:FindFirstChild("MilkfishRideInput")
                if remote then pcall(remote.FireServer,remote,Vector3.zero)end
            end
            for attempt=1,2 do
                if not active or not config.Farm or motion~=token then break end
                local c,h=alive()
                if c~=character or h~=humanoid or not prompt.Parent or(check and not check())then break end
                if not prompt.Enabled and not allowDisabled then break end
                point=promptPosition(prompt)
                if not point then break end
                record.attempt=attempt;record.stage="Settling"
                status("Teleporting to "..prompt.Name)
                local destination=point+Vector3.new(0,math.min(3,prompt.MaxActivationDistance*.25),0)
                character:PivotTo(character:GetPivot()+(destination-root.Position))
                root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero
                task.wait(.35)
                c,h=alive()
                if not active or not config.Farm or motion~=token or c~=character or h~=humanoid then break end
                if not prompt.Parent or(check and not check())then break end
                point=promptPosition(prompt)
                if not point then break end
                record.actual=coordinates(root.Position);record.distance=(root.Position-point).Magnitude
                if record.distance<=math.max(2,prompt.MaxActivationDistance-2)then
                    record.stage="Arrived";stopMotion();return true
                end
                record.stage="Position corrected or moved away"
            end
            stopMotion()
            if not active or not config.Farm then record.stage="Cancelled";return false,"Teleport cancelled"end
            return false,"Teleport did not stay near target; save farm report"
        end
        local direction=Vector3.zero
        if riding then
            local camera=workspace.CurrentCamera
            if not camera then stopMotion();return false,"Camera unavailable"end
            token.camera=camera;token.cameraType=camera.CameraType;token.cameraFrame=camera.CFrame
            camera.CameraType=Enum.CameraType.Scriptable
            Run:BindToRenderStep(token.bindName,Enum.RenderPriority.Camera.Value+1,function()
                if motion==token and root.Parent and direction.Magnitude>.001 then
                    local pos=root.Position+Vector3.new(0,4,0)
                    local up=math.abs(direction.Unit.Y)>.98 and Vector3.new(0,0,1)or Vector3.yAxis
                    camera.CFrame=CFrame.lookAt(pos,pos+direction.Unit*20,up)
                end
            end)
        end
        local beginning=now();local lastProgress=beginning;local bestDistance=math.huge
        local lastMove=-math.huge
        while active and config.Farm and motion==token do
            local c,h=alive()
            if c~=character or h~=humanoid then break end
            if not prompt.Parent or(not prompt.Enabled and not allowDisabled)or(check and not check())then break end
            point=promptPosition(prompt)
            if not point then break end
            direction=point-root.Position
            local distance=direction.Magnitude
            if distance<=math.max(2,prompt.MaxActivationDistance-2)then stopMotion();return true end
            if distance<bestDistance-1 then bestDistance=distance;lastProgress=now()end
            if now()-lastProgress>10 then stopMotion();return false,"Movement blocked; skipping this target"end
            if now()-beginning>120 then stopMotion();return false,"Travel timed out"end
            if not riding and now()-lastMove>.6 then
                lastMove=now();humanoid:MoveTo(point)
                -- A short forward obstacle check allows normal humanoid jumping.
                local params=RaycastParams.new();params.FilterDescendantsInstances={character};params.FilterType=Enum.RaycastFilterType.Exclude
                local flat=Vector3.new(direction.X,0,direction.Z)
                if flat.Magnitude>1 and workspace:Raycast(root.Position,flat.Unit*3,params)then humanoid.Jump=true end
            end
            status("Moving: "..math.floor(distance).." studs remaining")
            task.wait(.1)
        end
        stopMotion();return false,"Movement interrupted"
    end
    local function activate(prompt)
        local _,_,root=alive()
        local point=promptPosition(prompt)
        if not root or not point or not prompt.Enabled or(root.Position-point).Magnitude>prompt.MaxActivationDistance then return false end
        if prompt.Name=="DepositSeaEgg"and not ownPrompt(prompt)then return false end
        api.Report.interaction={prompt=prompt.Name,enabled=prompt.Enabled,distance=(root.Position-point).Magnitude,stage="Holding"}
        status("Activating "..prompt.Name)
        heldPrompt=prompt
        local ok,err=pcall(function()
            prompt:InputHoldBegin()
            task.wait(math.max(0,prompt.HoldDuration)+.15)
        end)
        pcall(prompt.InputHoldEnd,prompt);heldPrompt=nil
        api.Report.interaction.stage=ok and"Hold ended; waiting for game confirmation"or"Prompt call failed"
        if not ok then
            if type(fireproximityprompt)=="function"then return pcall(fireproximityprompt,prompt,prompt.HoldDuration)end
            logError(err)
        end
        return ok
    end
    local function waitFor(predicate,seconds)
        local finish=now()+seconds
        repeat if predicate()then return true end;task.wait(.1)until not active or not config.Farm or now()>=finish
        return predicate()
    end
    local function farmStep()
        if not alive()then selected=nil;status("Waiting for character");return end
        local id=carried()
        if id then
            selected=nil
            local deposit=nearestDeposit()
            if not deposit then status(noDepositStatus());return end
            status("Returning carried egg to your pot")
            local arrived,err=travel(deposit,function()return carried()==id and availableDeposit(deposit,false)end,true)
            if not arrived then status(err);return end
            if not active or not config.Farm or carried()~=id then return end
            if not waitFor(function()return deposit.Parent and deposit.Enabled end,3)then
                status("At empty hatch slot, but DepositSeaEgg is disabled; save report");return
            end
            if not active or not config.Farm or carried()~=id or not availableDeposit(deposit,true)then return end
            local interaction=hatchInteraction(deposit)
            local slot=interaction and interaction:GetAttribute("HatchSlot")
            local oldStatus=interaction and interaction:GetAttribute("Status")
            local previousEntry
            for _,entry in ipairs(hatches)do if entry.Slot==slot then previousEntry=entry end end
            activate(deposit)
            local function confirmed()
                if carried()or not alive()then return false end
                local newStatus=interaction and interaction.Parent and interaction:GetAttribute("Status")
                if newStatus and newStatus~=oldStatus and newStatus~="Empty"then return true end
                for _,entry in ipairs(hatches)do
                    if entry.Slot==slot and entry~=previousEntry and tonumber(entry.FinishAt)then return true end
                end
                return false
            end
            if waitFor(confirmed,5)then
                api.Report.deposited+=1;status("Egg deposited: "..api.Report.deposited)
            else status("Deposit unconfirmed; check hatch state before retry");task.wait(2)end
            return
        end
        if not nearestDeposit()then status(noDepositStatus());return end
        if not eligible(selected)then selected=chooseEgg()end
        if not selected then status("Waiting for an available egg matching your filters");return end
        local model=selected;local eggId=model:GetAttribute("EggId");local prompt=pickupPrompt(model)
        api.Report.target={id=eggId,tier=model:GetAttribute("EggTier"),kg=model:GetAttribute("EggKg"),luck=model:GetAttribute("EggLuck")}
        local arrived,err=travel(prompt,function()return not carried()and eligible(model)end)
        if not arrived then
            retryEgg[eggId]=now()+30;selected=nil;status(err);return
        end
        if not active or not config.Farm or carried()then return end
        activate(prompt)
        if waitFor(function()return carried()==eggId end,5)then
            api.Report.picked+=1;status("Egg pickup confirmed")
        else retryEgg[eggId]=now()+20;status("Pickup unconfirmed; trying another egg")end
        selected=nil
    end
    links[#links+1]=events.OnClientEvent:Connect(function(kind,data)
        if kind=="Hatches"and type(data)=="table"then hatches=data end
        if kind=="Collection"and config.EquipBest and now()-lastEquip>3 then
            lastEquip=now();local ok,err=pcall(requests.FireServer,requests,"EquipBest");if not ok then logError(err)end
        end
    end)
    local function hatchStep()
        for _,entry in ipairs(hatches)do
            local slot=tonumber(entry.Slot)
            if slot and tonumber(entry.FinishAt)and workspace:GetServerTimeNow()>=entry.FinishAt and not entry.Triggered and now()>=(hatchRetry[slot]or 0)then
                if not active or not config.Hatch then return end
                hatchRetry[slot]=now()+4
                requests:FireServer("HatchFromUI",slot);api.Report.hatchRequests+=1
            end
        end
    end
    function api.SaveReport()
        nearestDeposit()
        api.Report.player={userId=player.UserId,carriedEggId=carried(),hasSeaEgg=player:GetAttribute("HasSeaEgg"),eggEquipped=player:GetAttribute("EggEquipped"),riding=player:GetAttribute("MilkfishRiding")}
        if type(writefile)=="function"then pcall(function()
            writefile("DevilAquaAutoEgg-report.json",game:GetService("HttpService"):JSONEncode(api.Report))
        end)end
    end
    function api.SetFarm(enabled)
        config.Farm=enabled
        if not enabled then selected=nil;stopMotion();if heldPrompt then pcall(heldPrompt.InputHoldEnd,heldPrompt);heldPrompt=nil end end
        status(enabled and"Auto Egg enabled"or"Auto Egg stopped")
    end
    function api.Destroy()
        if not active then return end
        api.SetFarm(false);active=false
        for _,link in ipairs(links)do link:Disconnect()end
        api.SaveReport()
    end
    -- Pure selection helpers exposed for diagnostics and offline regression.
    api.ChooseEgg=chooseEgg;api.NearestDeposit=nearestDeposit;api.Carried=carried
    task.spawn(function()
        while active do
            api.Report.workerTick=now()
            if config.Farm then
                local ok,err=xpcall(farmStep,debug.traceback)
                if not ok then stopMotion();logError(err);status("Retrying after error; check report");task.wait(2)end
            end
            task.wait(.5)
        end
    end)
    task.spawn(function()
        while active do
            if config.Hatch then local ok,err=pcall(hatchStep);if not ok then logError(err)end end
            task.wait(1)
        end
    end)
    local ready,readyError=pcall(requests.FireServer,requests,"Ready")
    if not ready then logError(readyError)end
    status(config.Teleport and"Ready - teleport egg collection"or"Ready - mount your fish before collecting underwater eggs")
    return api
end

    end)()
    core=make(config,function(text,report)
        if done then return end
        state:Set(text,true)
        totals:Set("Picked: "..report.picked.." | Deposited: "..report.deposited.." | Hatch requests: "..report.hatchRequests,true)
    end)
    controller.Core=core
    local farmToggle=farm:CreateToggle({Name="Auto Collect + Return Egg",CurrentValue=false,Callback=function(value)core.SetFarm(value)end})
    local hatchToggle=farm:CreateToggle({Name="Auto Hatch Ready Eggs",CurrentValue=false,Callback=function(value)config.Hatch=value end})
    local equipToggle=farm:CreateToggle({Name="Auto Equip Best After Hatch",CurrentValue=false,Callback=function(value)
        config.EquipBest=value
        if value then game:GetService("ReplicatedStorage").EggGame.Requests:FireServer("EquipBest")end
    end})
    farm:CreateButton({Name="Start Egg Farm + Hatch",Callback=function()
        config.Hatch=true;hatchToggle:Set(true,true);farmToggle:Set(true,true);core.SetFarm(true)
    end})
    farm:CreateButton({Name="Stop All",Callback=function()
        config.Hatch=false;config.EquipBest=false;equipToggle:Set(false,true);hatchToggle:Set(false,true);farmToggle:Set(false,true);core.SetFarm(false)
    end})
    farm:CreateButton({Name="Save Farm Report",Callback=function()core.SaveReport()end})
    farm:CreateParagraph({Name="First run",Content="Auto teleports near the selected egg, waits for pickup confirmation, then teleports back to an empty hatch slot at your pot. Farm pauses when your hatch slots are full. Save the report if the game moves you away or rejects a prompt."})
    local tiers={};local seen={}
    local runtime=workspace:FindFirstChild("EggRuntime")
    for _,folderName in ipairs({"WildEggs","DroppedEggs"})do
        local folder=runtime and runtime:FindFirstChild(folderName)
        for _,model in ipairs(folder and folder:GetChildren()or{})do
            local tier=model:GetAttribute("EggTier")
            if type(tier)=="string"and not seen[tier]then seen[tier]=true;tiers[#tiers+1]=tier end
        end
    end
    table.sort(tiers)
    filters:CreateDropdown({Name="Egg Types (empty = all)",Options=tiers,CurrentOption={},MultipleOptions=true,AllowNone=true,Searchable=true,
        Callback=function(values)
            local selected={}
            if type(values)=="table"then for key,value in pairs(values)do
                if type(key)=="number"and type(value)=="string"then selected[value]=true
                elseif type(key)=="string"and value==true then selected[key]=true end
            end end
            config.Tiers=selected
        end})
    filters:CreateDropdown({Name="Priority",Options={"Nearest","Highest Luck"},CurrentOption={"Nearest"},Callback=function(value)
        local selected=type(value)=="table"and value[1]or value
        if selected=="Nearest"or selected=="Highest Luck"then config.Order=selected end
    end})
    local function minimum(field,value)
        local number=tonumber(value)
        if number and number==number and number>=0 and number<math.huge then config[field]=number end
    end
    filters:CreateInput({Name="Minimum KG",CurrentValue="0",Numeric=true,Callback=function(value)minimum("MinKg",value)end})
    filters:CreateInput({Name="Minimum Egg Luck",CurrentValue="0",Numeric=true,Callback=function(value)minimum("MinLuck",value)end})
    filters:CreateToggle({Name="Include Dropped Eggs",CurrentValue=true,Callback=function(value)config.Dropped=value end})
    filters:CreateParagraph({Name="Selection",Content="The selected egg remains the target until it is collected, disappears, becomes unavailable, or no longer matches your filters."})
    local info=window:CreateTab({Name="Info",Icon="info",Backdrop=false})
    local about=info:CreateGroupbox({Name="DEVIL HUB",Side="Left"})
    about:CreateLabel({Text="Aqua Auto Egg - test release 3 / Teleport"})
    about:CreateLabel({Text="Place: 104050046639813"})
    about:CreateParagraph({Name="Diagnostics",Content="Use Save Farm Report and send DevilAquaAutoEgg-report.json if movement or prompts fail."})
    about:CreateButton({Name="Unload",Callback=controller.Destroy})
    if window.Gui and window.Gui.Destroying then window.Gui.Destroying:Connect(controller.Destroy)end
end,debug.traceback)
if not ok then controller.Destroy();error("DEVIL HUB Aqua startup failed: "..tostring(err),0)end
return controller
