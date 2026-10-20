return function(scope)
    local A={Modules={},Pending=scope.DevilV4Pending or{},Snapshots={},Links={},Finds={},Serials=setmetatable({},{__mode="k"}),NextSerial=0,Alive=true}
    scope.DevilV4Pending=A.Pending -- A hung InvokeServer retains its lane across reloads.
    A.Player=game:GetService("Players").LocalPlayer
    A.RS=game:GetService("ReplicatedStorage");A.Tags=game:GetService("CollectionService");A.Input=game:GetService("UserInputService")
    A.Http=game:GetService("HttpService");A.Clock=os.clock;A.Spawn=task.spawn;A.Wait=task.wait
    A.ServerTime=function()return workspace:GetServerTimeNow()end
    local paths={Mining="DiggingRemotes.Mining",Surface="DiggingRemotes.Surface",Plant="EggRemotes.Plant",Eggs="EggRemotes.EggCollection",Shovels="MarketRemotes.ShovelMarket",Gear="MarketRemotes.GearShop",Sell="MarketRemotes.LootMarket",Pets="PetCollection",Index="PetIndex",Training="UpgradeTraining",Plot="UpgradePlot",Booth="MarketRemotes.BoothUpgrades",Rebirth="Rebirth",Potion="PotionRemotes.Consume",DailyState="DailyRewardsRemotes.GetState",DailyClaim="DailyRewardsRemotes.Claim",Offline="OfflineEarnings",EventState="LiveAdmin.GetState",EggPlan="LiveAdmin.GetEggPlan",ClaimEgg="LiveAdmin.ClaimEgg",ClaimWave="LiveAdmin.ClaimWave",PlaceGear="GearRemotes.Place",Pumpkin="GearRemotes.FirePumpkin"}
    function A.Remote(key)
        local node=A.RS
        for segment in string.gmatch(paths[key]or"","[^.]+")do node=node and node:FindFirstChild(segment)end
        return node~=A.RS and node or nil
    end
    function A.Fire(key,...)
        if not A.Alive then return false,"Unloaded"end
        local r=A.Remote(key);if not r or not r:IsA("RemoteEvent")then return false,"Remote unavailable: "..key end
        return pcall(r.FireServer,r,...)
    end
    function A.Invoke(key,...)
        if not A.Alive then return nil,"Unloaded"end
        local r=A.Remote(key);if not r or not r:IsA("RemoteFunction")then return nil,"Remote unavailable: "..key end
        if A.Pending[key]then return nil,"Waiting for previous "..key.." request"end
        local pending={At=os.clock(),Done=false};A.Pending[key]=pending
        local args=table.pack(...)
        task.spawn(function()
            pending.OK,pending.Value=pcall(r.InvokeServer,r,table.unpack(args,1,args.n));pending.Done=true
            if A.Pending[key]==pending then A.Pending[key]=nil end
        end)
        while not pending.Done and A.Alive and os.clock()-pending.At<8 do task.wait(.05)end
        if not pending.Done then return nil,"Server timeout: "..key end
        if not pending.OK then return nil,tostring(pending.Value)end
        return pending.Value
    end
    function A.Character()
        local c=A.Player.Character;local h=c and c:FindFirstChildOfClass("Humanoid");local r=c and c:FindFirstChild("HumanoidRootPart")
        if h and r and h.Health>0 then return c,h,r,c:FindFirstChild("Head")or r end
    end
    function A.Blocked()
        return not A.Character()or A.Input:GetFocusedTextBox()~=nil or game:GetService("GuiService").MenuIsOpen or A.Player:GetAttribute("ProductPurchaseOpen")==true or A.Player:GetAttribute("DataResetting")==true
    end
    function A.Attr(name,default)local v=A.Player:GetAttribute(name);if v==nil then return default end;return v end
    function A.Plot()
        local map=workspace:FindFirstChild("RuntimeMap");local plots=map and map:FindFirstChild("Plots")
        for _,p in ipairs(plots and plots:GetChildren()or{})do if p:GetAttribute("ClaimedUserId")==A.Player.UserId then return p end end
    end
    function A.Owned(node)
        local plot=A.Plot();return plot and (node==plot or node:IsDescendantOf(plot))
    end
    function A.Part(node)
        if not node then return end
        if node:IsA("BasePart")then return node end
        return node:IsA("Model")and(node.PrimaryPart or node:FindFirstChildWhichIsA("BasePart",true))or node:FindFirstChildWhichIsA("BasePart",true)
    end
    function A.TaggedOwn(tag)
        for _,n in ipairs(A.Tags:GetTagged(tag))do if A.Owned(n)then return n end end
    end
    function A.Mine()
        local map=workspace:FindFirstChild("RuntimeMap");return map and map:FindFirstChild("CommunalMine")
    end
    function A.ValidFind(n)
        local mine=A.Mine()
        return n and n.Parent and n:IsA("BasePart")and mine and n:IsDescendantOf(mine)and(n:GetAttribute("FindId")~=nil or n:GetAttribute("MaterialName")~=nil)and n:GetAttribute("Diggable")==true and not n:GetAttribute("MineBoundary")and not n:GetAttribute("TutorialHidden")and(tonumber(n:GetAttribute("Health"))or 1)>0
    end
    function A.Identity(n)
        if not A.Serials[n]then A.NextSerial+=1;A.Serials[n]=A.NextSerial end;return A.Serials[n]
    end
    local function add(n)A.Finds[n]=true;A.Identity(n)end
    for _,n in ipairs(A.Tags:GetTagged("MineFind"))do add(n)end
    A.Links[#A.Links+1]=A.Tags:GetInstanceAddedSignal("MineFind"):Connect(add)
    A.Links[#A.Links+1]=A.Tags:GetInstanceRemovedSignal("MineFind"):Connect(function(n)A.Finds[n]=nil end)
    function A.FindDefinition(kind,id)
        local module=A.Modules[({Egg="EggCatalog",Artifact="ArtifactCatalog",Potion="PotionConfig",Material="MaterialCatalog"})[kind]]
        return module and module.Types and module.Types[id]or{}
    end
    function A.Targets(kind,rarity)
        A.TrackMine()
        local _,_,root=A.Character();local list={}
        for n in pairs(A.Finds)do
            if A.ValidFind(n)then
                local k=n:GetAttribute("FindKind")or"Material"
                local id=n:GetAttribute("FindId")or(n:GetAttribute("MaterialName")or n.Name):gsub("%s","");local d=A.FindDefinition(k,id)
                if(kind=="All"or k==kind)and(rarity=="All"or d.Rarity==rarity)then
                    list[#list+1]={Instance=n,Kind=k,Id=id,Name=d.Name or tostring(id),Rarity=d.Rarity or"Unknown",Position=n.Position,Serial=A.Identity(n),Distance=root and(root.Position-n.Position).Magnitude or math.huge}
                end
            end
        end
        table.sort(list,function(a,b)if a.Distance==b.Distance then return a.Serial<b.Serial end;return a.Distance<b.Distance end)
        return list
    end
    function A.Ground(position,exclude,maxDepth)
        local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
        local c=A.Player.Character;params.FilterDescendantsInstances=exclude or(c and{c}or{})
        params.RespectCanCollide=true
        return workspace:Raycast(position,Vector3.new(0,-(maxDepth or 24),0),params)
    end
    function A.Stand(target)
        local c,hum,root=A.Character();if not root then return end
        local p=target.Position;local size=target.Instance and target.Instance.Size or Vector3.new(2,2,2)
        local radius=math.max(size.X,size.Z)/2+2.5
        local offsets=target.Training and{Vector3.zero}or{Vector3.new(radius,0,0),Vector3.new(-radius,0,0),Vector3.new(0,0,radius),Vector3.new(0,0,-radius)}
        for _,offset in ipairs(offsets)do
            local hit=A.Ground(p+offset+Vector3.new(0,4,0),{c,target.Instance},18)
            if hit and hit.Normal.Y>.65 and math.abs(hit.Position.Y-p.Y)<=8 then
                local goal=hit.Position+Vector3.new(0,hum.HipHeight+root.Size.Y/2+.15,0)
                local box=OverlapParams.new();box.FilterType=Enum.RaycastFilterType.Exclude;box.FilterDescendantsInstances={c};box.RespectCanCollide=true
                local clear=true;for _,part in ipairs(workspace:GetPartBoundsInBox(CFrame.new(goal),Vector3.new(2,3,2),box))do if part.CanCollide then clear=false;break end end
                if clear then return goal end
            end
        end
    end
    function A.Move(target,valid)
        if A.MoveBusy then return false,"Another movement is active"end
        if not valid()then return false,"Cancelled"end
        local c,_,root=A.Character();if not root then return false,"Waiting for character"end
        if target.Instance and not A.ValidFind(target.Instance)then return false,"Target disappeared"end
        local goal=A.Stand(target);if not goal then return false,"No clear ground next to target"end
        A.MoveBusy=true
        local ok,err=pcall(function()
            if not valid()then return end
            root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero
            c:PivotTo(CFrame.lookAt(goal,Vector3.new(target.Position.X,goal.Y,target.Position.Z)))
            task.wait(.4)
        end)
        A.MoveBusy=false
        if not ok then return false,tostring(err)end
        if not valid()then return false,"Cancelled"end
        local _,_,current=A.Character();if current~=root or(root.Position-goal).Magnitude>7 then return false,"Teleport not confirmed (server correction or respawn)"end
        return true,"Arrived"
    end
    function A.Aim(target)
        local c,_,root,head=A.Character();if not head then return end
        local config=A.Modules.DigConfig;local reach=config and config.Reach or 30
        local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={c}
        if target then
            if not A.ValidFind(target.Instance)or(target.Instance.Position-head.Position).Magnitude>reach then return end
            local delta=target.Instance.Position-head.Position;if delta.Magnitude<.1 then return end
            local hit=workspace:Raycast(head.Position,delta.Unit*(delta.Magnitude+1),params)
            if not hit or hit.Instance~=target.Instance then return end
            return head.Position,delta.Unit,target.Kind=="Material"and"Aim"or"Find",target.Kind~="Material"and target.Instance or nil
        end
        local hit=workspace:Raycast(head.Position,Vector3.new(0,-reach,0),params)
        local mine=A.Mine();if not hit or not mine or not hit.Instance:IsDescendantOf(mine)or hit.Instance:GetAttribute("MineBoundary")or hit.Instance:GetAttribute("Diggable")~=true then return end
        return head.Position,Vector3.new(0,-1,0),"Down",nil
    end
    function A.Tools()
        local list={};for _,parent in ipairs({A.Player:FindFirstChild("Backpack"),A.Player.Character})do
            if parent then for _,tool in ipairs(parent:GetChildren())do if tool:IsA("Tool")then list[#list+1]=tool end end end
        end;return list
    end
    function A.Equip(item,attribute,id)
        local _,h=A.Character();if not h then return end
        for _,t in ipairs(A.Tools())do if t:GetAttribute("ItemId")==item and(not attribute or t:GetAttribute(attribute)==id)then h:EquipTool(t);return t end end
    end
    function A.PlantPosition()
        local plot=A.Plot();local lawn=plot and plot:FindFirstChild("Lawn");local frame=plot and plot:GetAttribute("PlotFrame")
        if not lawn or typeof(frame)~="CFrame"then return end
        local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Include;params.FilterDescendantsInstances={lawn}
        local spacing=(A.Modules.EggConfig or{}).PlantSpacing or 5.125
        local planted=workspace:FindFirstChild("RuntimeEggs");planted=planted and planted:FindFirstChild("Planted")
        local positions={};for _,m in ipairs(planted and planted:GetChildren()or{})do
            local part=A.Part(m);if part then positions[#positions+1]=part.Position end
        end
        for z=-3,3 do for x=-3,3 do
            local p=frame:PointToWorldSpace(Vector3.new(x*spacing,4,z*spacing));local hit=workspace:Raycast(p,Vector3.new(0,-8,0),params)
            if hit and hit.Normal.Y>.9 and math.abs(frame:PointToObjectSpace(hit.Position).Y)<.6 then
                local free=true;for _,pos in ipairs(positions)do if(pos-hit.Position).Magnitude<spacing then free=false;break end end
                if free then return hit.Position end
            end
        end end
    end
    function A.Init()
        local shared=A.RS:FindFirstChild("Shared");if not shared then return end
        local plant=A.Remote("Plant")
        if plant and plant:IsA("RemoteEvent")then A.Links[#A.Links+1]=plant.OnClientEvent:Connect(function(success,message)
            A.Snapshots.LastPlant={At=A.Clock(),Success=success==true,Message=message}
        end)end
        for _,name in ipairs({"ShovelCatalog","GearConfig","GearPlacementGrid","EggCatalog","ArtifactCatalog","PotionConfig","MaterialCatalog","DigConfig","EggConfig","TrainingUpgradeConfig","PlotUpgradeConfig","BoothUpgradeConfig","ProgressionConfig","Equipment","ContinuousMiningConfig","RebirthConfig","AbuseEventConfig","AbuseEventRules","AdminAbuseEligibility"})do
            if not A.Alive then return end
            local module=shared:FindFirstChild(name)
            if module and module:IsA("ModuleScript")then task.spawn(function()local ok,v=pcall(require,module);if ok and A.Alive then A.Modules[name]=v end end)end
            task.wait()
        end
        A.TrackMine()
    end
    function A.TrackMine()
        local mine=A.Mine();if not A.Alive or not mine or mine==A.TrackedMine then return end
        A.TrackedMine=mine
        local function track(n)if n:IsA("BasePart")then add(n)end end
        A.Links[#A.Links+1]=mine.DescendantAdded:Connect(track)
        A.Links[#A.Links+1]=mine.DescendantRemoving:Connect(function(n)A.Finds[n]=nil end)
        A.Spawn(function()
            for i,n in ipairs(mine:GetDescendants())do if not A.Alive or A.TrackedMine~=mine then break end;track(n);if i%200==0 then task.wait()end end
        end)
    end
    function A.Destroy()A.Alive=false;for _,c in ipairs(A.Links)do c:Disconnect()end end
    return A
end
