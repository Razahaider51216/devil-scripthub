return function(scope,catalog)
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
    function A.FocusBlocks()
        local box=A.Input:GetFocusedTextBox();if not box then return false end
        local node=box
        while node do
            if node:IsA("GuiObject")and not node.Visible or node:IsA("ScreenGui")and not node.Enabled then return false end
            node=node.Parent
        end
        return true
    end
    function A.ReleaseHubFocus(gui)
        local box=A.Input:GetFocusedTextBox()
        if box and box:IsDescendantOf(gui)then box:ReleaseFocus()end
    end
    function A.BlockReason()
        if not A.Character()then return "Waiting for character"end
        if A.FocusBlocks()then return "Paused while typing"end
        if game:GetService("GuiService").MenuIsOpen then return "Game menu is open"end
        if A.Attr("ProductPurchaseOpen",false)then return "Waiting for purchase"end
        if A.Attr("DataResetting",false)then return "Waiting for player data"end
    end
    function A.Blocked()return A.BlockReason()~=nil
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
    function A.ValidTarget(n)
        local mine=A.Mine()
        return n and n.Parent and n:IsA("BasePart")and mine and n:IsDescendantOf(mine)and(n:GetAttribute("FindId")~=nil or n:GetAttribute("MaterialName")~=nil)and not n:GetAttribute("MineBoundary")and not n:GetAttribute("TutorialHidden")and(tonumber(n:GetAttribute("Health"))or 1)>0
    end
    function A.ValidFind(n)return A.ValidTarget(n)and n:GetAttribute("Diggable")==true end
    function A.Identity(n)
        if not A.Serials[n]then A.NextSerial+=1;A.Serials[n]=A.NextSerial end;return A.Serials[n]
    end
    local function add(n)A.Finds[n]=true;A.Identity(n)end
    for _,n in ipairs(A.Tags:GetTagged("MineFind"))do add(n)end
    A.Links[#A.Links+1]=A.Tags:GetInstanceAddedSignal("MineFind"):Connect(add)
    A.Links[#A.Links+1]=A.Tags:GetInstanceRemovedSignal("MineFind"):Connect(function(n)A.Finds[n]=nil end)
    function A.FindDefinition(kind,id)
        local module=A.Modules[({Egg="EggCatalog",Artifact="ArtifactCatalog",Potion="PotionConfig",Material="MaterialCatalog"})[kind]]
        local d=module and module.Types and module.Types[id]
        return type(d)=="table"and d or catalog and catalog[kind]and catalog[kind][id]or{}
    end
    function A.Targets(kind,rarity,includeBuried)
        A.TrackMine()
        local _,_,root=A.Character();local list={}
        for n in pairs(A.Finds)do
            if (includeBuried and A.ValidTarget(n))or(not includeBuried and A.ValidFind(n))then
                local k=n:GetAttribute("FindKind")or"Material"
                local id=n:GetAttribute("FindId")or(n:GetAttribute("MaterialName")or n.Name):gsub("%s","");local d=A.FindDefinition(k,id)
                if(kind=="All"or k==kind)and(rarity=="All"or d.Rarity==rarity)then
                    list[#list+1]={Instance=n,Kind=k,Id=id,Name=d.Name or tostring(id),Rarity=d.Rarity or"Unknown",Position=n.Position,Serial=A.Identity(n),Distance=root and(root.Position-n.Position).Magnitude or math.huge}
                end
            end
        end
        table.sort(list,function(a,b)
            if kind=="All"and(a.Kind=="Material")~=(b.Kind=="Material")then return a.Kind~="Material"end
            if a.Distance==b.Distance then return a.Serial<b.Serial end;return a.Distance<b.Distance
        end)
        return list
    end
    function A.TeleportOptions(kind)
        local grouped={}
        for _,target in ipairs(A.Targets(kind,"All",true))do
            local key=target.Kind..":"..target.Id;local row=grouped[key]
            if row then row.Count+=1 else row=table.clone(target);row.Key=key;row.Group=true;row.Count=1;grouped[key]=row end
        end
        -- Catalog entries remain named even before their instances stream in.
        if kind=="Egg"or kind=="All"then
            local types=table.clone(catalog and catalog.Egg or{})
            for id,d in pairs(A.Modules.EggCatalog and A.Modules.EggCatalog.Types or{})do types[id]=d end
            for id,d in pairs(types)do local key="Egg:"..id
                if not grouped[key]then grouped[key]={Id=id,Key=key,Kind="Egg",Name=d.Name or id.." Egg",Rarity=d.Rarity or"Unknown",Group=true,Count=0,Distance=math.huge}end
            end
        end
        local out={};for _,row in pairs(grouped)do out[#out+1]=row end
        table.sort(out,function(a,b)
            if(a.Count>0)~=(b.Count>0)then return a.Count>0 end
            if a.Kind~=b.Kind then return a.Kind=="Egg"or b.Kind~="Egg"and a.Kind<b.Kind end
            return a.Name==b.Name and a.Key<b.Key or a.Name<b.Name
        end)
        return out
    end
    function A.ResolveTarget(target)
        if not target then return end
        if not target.Group and A.ValidTarget(target.Instance)then local t=table.clone(target);t.Position=t.Instance.Position;return t end
        for _,candidate in ipairs(A.Targets(target.Kind,"All",true))do if candidate.Id==target.Id then return candidate end end
    end
    function A.SurfacePoint(part,origin)
        local ok,point=pcall(function()return part:GetClosestPointOnSurface(origin)end)
        if ok and point and(point-origin).Magnitude>.05 then return point end
        -- A box fallback also supplies a face when the engine returns an interior
        -- origin unchanged, or the surface-query API is unavailable.
        local good,value=pcall(function()
            local p=part.CFrame:PointToObjectSpace(origin);local h=part.Size*.5
            local x,y,z=math.clamp(p.X,-h.X,h.X),math.clamp(p.Y,-h.Y,h.Y),math.clamp(p.Z,-h.Z,h.Z)
            if math.abs(p.X)<=h.X and math.abs(p.Y)<=h.Y and math.abs(p.Z)<=h.Z then
                local dx,dy,dz=h.X-math.abs(p.X),h.Y-math.abs(p.Y),h.Z-math.abs(p.Z)
                if dx<=dy and dx<=dz then x=p.X>=0 and h.X or-h.X elseif dy<=dz then y=p.Y>=0 and h.Y or-h.Y else z=p.Z>=0 and h.Z or-h.Z end
            end
            return part.CFrame:PointToWorldSpace(Vector3.new(x,y,z))
        end)
        return good and value or part.Position+Vector3.new(0,part.Size.Y/2,0)
    end
    function A.Health(part)local value=part and tonumber(part:GetAttribute("Health"));if value and value==value and math.abs(value)<math.huge then return value end end
    function A.NativeCooldown()
        local ok,value=pcall(function()
            local sh=A.Modules.ShovelCatalog;local cd=sh and sh.cooldown(sh.activeLevel(A.Attr("ShovelLevel",1),A.Attr("ActiveDrillId")))or(A.Modules.DigConfig or{}).Cooldown or .5
            local frenzy=A.Modules.DigFrenzyRules;local potion=A.Modules.PotionRules
            if frenzy then cd/=frenzy.speedMultiplier(A.Player,A.ServerTime())end
            if potion then cd/=potion.multiplier(A.Player,"DigSpeed",A.ServerTime())end
            return cd
        end)
        return ok and type(value)=="number"and value==value and math.clamp(value,.025,30)or .5
    end
    function A.EnsureDigEquipment()
        local equipment=A.Modules.Equipment;if not equipment then return true end
        local c,h=A.Character();if not c then return false end
        local tool=equipment.shovel(c);if tool and tool.Enabled~=false then return true end
        if A.Attr("DrinkingPotion",false)then return false end
        local held=c:FindFirstChildOfClass("Tool");local item=held and held:GetAttribute("ItemId")
        if item=="Gear"or item=="Potion"then h:UnequipTools()end
        local drill=A.Attr("ActiveDrillId")
        if drill and not equipment.shovel(c)then A.Equip("Drill","DrillId",drill)end
        tool=equipment.shovel(c);return tool~=nil and tool.Enabled~=false
    end
    function A.Ground(position,exclude,maxDepth)
        local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude
        local c=A.Player.Character;params.FilterDescendantsInstances=exclude or(c and{c}or{})
        params.RespectCanCollide=true
        return workspace:Raycast(position,Vector3.new(0,-(maxDepth or 24),0),params)
    end
    function A.Stand(target)
        local c,hum,root,head=A.Character();if not root then return end
        local p=target.Position;local size=target.Instance and target.Instance.Size or Vector3.new(2,2,2)
        local radius=math.max(size.X,size.Z)/2+2.5
        local offsets=target.Training and{Vector3.zero}or{Vector3.new(radius,0,0),Vector3.new(-radius,0,0),Vector3.new(0,0,radius),Vector3.new(0,0,-radius)}
        for _,offset in ipairs(offsets)do
            local hit=A.Ground(p+offset+Vector3.new(0,4,0),{c,target.Instance},18)
            if hit and hit.Normal.Y>.65 and math.abs(hit.Position.Y-p.Y)<=8 then
                local goal=hit.Position+Vector3.new(0,hum.HipHeight+root.Size.Y/2+.15,0)
                local box=OverlapParams.new();box.FilterType=Enum.RaycastFilterType.Exclude;box.FilterDescendantsInstances={c};box.RespectCanCollide=true
                local clear=true;for _,part in ipairs(workspace:GetPartBoundsInBox(CFrame.new(goal),Vector3.new(2,3,2),box))do if part.CanCollide then clear=false;break end end
                if clear and(not target.Instance or A.CanSee(target.Instance,goal+(head.Position-root.Position)))then return goal end
            end
        end
        -- Buried targets have no empty adjacent floor. Stand over their top face
        -- with a scoped character collision lease instead of rejecting the warp.
        if target.Instance and A.ValidTarget(target.Instance)then
            return p+Vector3.new(0,size.Y/2+hum.HipHeight+root.Size.Y/2+.15,0),true
        end
    end
    function A.ReleasePhase()
        local phase=A.Phase;A.Phase=nil;if not phase then return end
        if phase.Step then phase.Step:Disconnect()end
        if phase.Hover then phase.Hover:Destroy()end
        for part,old in pairs(phase.Parts)do if part.Parent then pcall(function()part.CanCollide=old end)end end
    end
    function A.PhaseCharacter(character,root,owner,hover)
        if A.Phase and A.Phase.Character~=character then A.ReleasePhase()end
        local phase=A.Phase or{Character=character,Root=root,Parts={}};A.Phase=phase;phase.Owner=owner
        if not phase.Step then phase.Step=game:GetService("RunService").Stepped:Connect(function()if A.Phase==phase then A.UpdatePhase()end end)end
        for _,part in ipairs(character:GetDescendants())do if part:IsA("BasePart")then
            if phase.Parts[part]==nil then phase.Parts[part]=part.CanCollide end;part.CanCollide=false
        end end
        if hover and not phase.Hover then
            local force=Instance.new("BodyVelocity");force.Name="DevilTeleportHover";force.MaxForce=Vector3.new(0,1e6,0);force.Velocity=Vector3.zero;force.Parent=root;phase.Hover=force
        end
    end
    function A.SpaceClear(position,character)
        local box=OverlapParams.new();box.FilterType=Enum.RaycastFilterType.Exclude;box.FilterDescendantsInstances={character};box.RespectCanCollide=true
        for _,part in ipairs(workspace:GetPartBoundsInBox(CFrame.new(position),Vector3.new(2,3,2),box))do if part.CanCollide then return false end end
        return true
    end
    function A.UpdatePhase()
        local phase=A.Phase;if not phase then return end
        local character,_,root=A.Character()
        if character~=phase.Character or not root or not A.Alive then A.ReleasePhase();return end
        if not A.MoveBusy and A.SpaceClear(root.Position,character)then A.ReleasePhase();return end
        A.PhaseCharacter(character,root,phase.Owner,phase.Hover~=nil)
    end
    function A.Move(target,valid,owner)
        if A.MoveBusy then return false,"Another movement is active"end
        if not valid()then return false,"Cancelled"end
        local c,_,root=A.Character();if not root then return false,"Waiting for character"end
        if target.Instance and not A.ValidTarget(target.Instance)then return false,"Target disappeared"end
        target.Position=target.Instance and target.Instance.Position or target.Position
        local goal,buried=A.Stand(target);if not goal then return false,"No clear ground next to target"end
        A.MoveBusy=true
        local ok,err=pcall(function()
            if not valid()then return end
            A.PhaseCharacter(c,root,owner,buried)
            root.AssemblyLinearVelocity=Vector3.zero;root.AssemblyAngularVelocity=Vector3.zero
            local facing=Vector3.new(target.Position.X,goal.Y,target.Position.Z)
            if(facing-goal).Magnitude<.01 then facing=goal+Vector3.new(0,0,-1)end
            c:PivotTo(CFrame.lookAt(goal,facing))
            task.wait(.06)
        end)
        A.MoveBusy=false
        if not ok then A.ReleasePhase();return false,tostring(err)end
        if not valid()then A.ReleasePhase();return false,"Cancelled"end
        local _,_,current=A.Character();if current~=root or(root.Position-goal).Magnitude>7 then A.ReleasePhase();return false,"Teleport not confirmed (server correction or respawn)"end
        A.UpdatePhase()
        return true,"Arrived"
    end
    function A.Aim(target)
        local c,_,root,head=A.Character();if not head then return end
        local config=A.Modules.DigConfig;local reach=config and config.Reach or 30
        local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={c}
        if target then
            if not A.ValidFind(target.Instance)then return end
            local point=A.SurfacePoint(target.Instance,head.Position)
            local delta=point-head.Position;if delta.Magnitude<.1 or delta.Magnitude>reach then return end
            local hit=workspace:Raycast(head.Position,delta.Unit*(delta.Magnitude+1),params)
            if not hit or hit.Instance~=target.Instance then return end
            return head.Position,delta.Unit,target.Kind=="Material"and"Aim"or"Find",target.Kind~="Material"and target.Instance or nil,target.Instance
        end
        local hit=workspace:Raycast(head.Position,Vector3.new(0,-reach,0),params)
        local mine=A.Mine();if not hit or not mine or not hit.Instance:IsDescendantOf(mine)or hit.Instance:GetAttribute("MineBoundary")or hit.Instance:GetAttribute("Diggable")~=true then return end
        return head.Position,Vector3.new(0,-1,0),"Down",nil,hit.Instance
    end
    function A.CanSee(part,origin)
        local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={A.Player.Character}
        local point=A.SurfacePoint(part,origin);local delta=point-origin
        if delta.Magnitude<.1 then return false end
        local hit=workspace:Raycast(origin,delta.Unit*(delta.Magnitude+1),params)
        return hit and hit.Instance==part
    end
    function A.Tools()
        local roots={};local backpack=A.Player:FindFirstChild("Backpack");if backpack then roots[#roots+1]=backpack end;if A.Player.Character then roots[#roots+1]=A.Player.Character end
        local list={};for _,parent in ipairs(roots)do
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
        for _,name in ipairs({"ShovelCatalog","GearConfig","GearPlacementGrid","EggCatalog","ArtifactCatalog","PotionConfig","MaterialCatalog","DigConfig","EggConfig","TrainingUpgradeConfig","PlotUpgradeConfig","BoothUpgradeConfig","ProgressionConfig","Equipment","PotionRules","DigFrenzyRules","ContinuousMiningConfig","RebirthConfig","AbuseEventConfig","AbuseEventRules","AdminAbuseEligibility"})do
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
    function A.Destroy()A.ReleasePhase();A.Alive=false;for _,c in ipairs(A.Links)do c:Disconnect()end end
    return A
end
