-- DEVIL HUB: standalone prototype for the map recorded in Devilv4.
assert(game.PlaceId==121831322352666 or game.GameId==10765013362,"Open the Devilv4 mining map before running this test")
local scope=type(getgenv)=="function"and getgenv()or _G
if scope.DevilV4Test then scope.DevilV4Test.Destroy()end
if scope.DevilV4Starting and os.clock()-scope.DevilV4Starting<30 then return end
scope.DevilV4Starting=os.clock()
local P=(function()
local P={}
P.Jobs={"Dig","FarmFinds","Plant","Hatch","SellLoot","SellEggs","SellPets","BuyShovel","BuyGear","EquipPets","TrainingUpgrade","PlotUpgrade","HoleLuck","AnimalIncome","Rebirth","Potions","Daily","Offline","PetIndex","EventEggs","EventWaves","UseGear","Pumpkin","Train"}
function P.Defaults()
    local c={AimRate=20,FastDig=true,Reserve=0,FindKind="All",FindRarity="All",TeleportKind="Egg",TeleportChoice="",Shovel="Best affordable",Gear="",GearLimit=1,Potion="DigSpeed",UseGearId="",RebirthLimit=1,TrainSeconds=120,DigSeconds=300,Rotate=false}
    for _,key in ipairs(P.Jobs)do c[key]=false end
    return c
end
function P.Number(v,fallback,lo,hi)
    v=tonumber(v);if not v or v~=v or math.abs(v)==math.huge then return fallback end
    return math.clamp(v,lo or 0,hi or 1e30)
end
function P.Affordable(cost,cash,reserve)return type(cost)=="number"and cost>=0 and cost<=math.max(0,(tonumber(cash)or 0)-(tonumber(reserve)or 0))end
function P.ShopChoice(tiers,snapshot,choice,cash,reserve,active)
    if type(snapshot)~="table"or type(snapshot.Owned)~="table"then return end
    local best
    for _,item in ipairs(tiers or{})do
        if not item.WorldOnly and not item.RobuxOnly and item.Kind~="Drill"and (choice=="Best affordable"or item.Id==choice)then
            if snapshot.Owned[item.Id]or P.Affordable(item.Cost,cash,reserve)then
                if not best or (item.Multiplier or 0)>(best.Multiplier or 0)then best=item end
            end
        end
    end
    if not best or best.Id==active then return end
    return best,snapshot.Owned[best.Id]and "Equip"or "Buy"
end
function P.Quote(snapshot,key)
    local s=type(snapshot)=="table"and snapshot[key]
    if type(s)=="table"and (tonumber(s.Count)or 0)>0 and s.Quote~=nil then return s.Quote end
end
function P.ReadyEggs(snapshot,now)
    local ready={};for _,e in ipairs(type(snapshot)=="table"and snapshot.Eggs or{})do
        if e.Id and type(e.ReadyAt)=="number"and e.ReadyAt<=now and not e.Hatching then ready[#ready+1]=e.Id end
    end;return ready
end
function P.DropEligible(drop,claimed,now,deadline)
    return type(drop)=="table"and type(drop.Index)=="number"and type(drop.LandTime)=="number"and now>=drop.LandTime and now<deadline and not drop.Claimed and not drop.Expired and not(claimed and claimed[drop.Index])
end
function P.Settings(raw)
    local out=P.Defaults();if type(raw)~="table"then return out end
    for key,default in pairs(out)do
        local v=raw[key]
        if type(default)=="boolean"then if type(v)=="boolean"then out[key]=v end
        elseif type(default)=="number"then out[key]=P.Number(v,default)
        elseif type(v)=="string"and #v<=120 then out[key]=v end
    end
    out.AimRate=P.Number(out.AimRate,20,5,40);out.GearLimit=math.floor(P.Number(out.GearLimit,1,1,25))
    out.RebirthLimit=math.floor(P.Number(out.RebirthLimit,1,1,100))
    out.TrainSeconds=P.Number(out.TrainSeconds,120,15,900);out.DigSeconds=P.Number(out.DigSeconds,300,15,900)
    return out
end
function P.Money(v)
    v=tonumber(v);if not v then return "?"end
    for _,pair in ipairs({{1e18,"Qi"},{1e15,"Qa"},{1e12,"T"},{1e9,"B"},{1e6,"M"},{1e3,"K"}})do if v>=pair[1]then return string.format("%.2f%s",v/pair[1],pair[2])end end
    return string.format("%.0f",v)
end
return P

end)()
local makeAdapter=(function()
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
    function A.MarketPosition(kind)
        local _,_,root=A.Character();local best,distance
        for _,prompt in ipairs(A.Tags:GetTagged("MarketPrompt"))do
            if prompt.Parent and prompt:IsDescendantOf(workspace)and prompt:GetAttribute("MarketType")==kind then
                local parent=prompt.Parent
                local position=parent:IsA("Attachment")and parent.WorldPosition or parent:IsA("BasePart")and parent.Position
                if not position then local part=A.Part(parent);position=part and part.Position end
                local d=position and root and(root.Position-position).Magnitude
                if d and(not distance or d<distance)then best,distance=position,d end
            end
        end
        return best,distance
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

end)()
local makeCore=(function()
return function(A,P)
    local C={Config=P.Defaults(),Jobs={},Alive=true,Mining=false,Generation=0,Report={Version="devilv4-test-20261021-1",Jobs={},Requests=0,Replies=0,Confirmed=0,Recoveries=0,Errors={},LiveVerified=false},Target=nil}
    local cfg=C.Config;local busyMoney=false;local movingJob=nil;local epoch={};local plans={};local collected={};local eventState
    local aimAt,lastAimTarget=0,nil;local nextAt={};local farmRetryAt=0
    local lastInputAt,progress=nil,nil
    local avoidUntil=setmetatable({},{__mode="k"});local moveFailures=setmetatable({},{__mode="k"})
    local function status(key,text)C.Report.Jobs[key]=tostring(text)end
    local function result(key,data,err)
        if type(data)=="table"then
            C.Report.Replies+=1;status(key,data.Code or data.reason or(data.success and"Confirmed")or"Server replied")
            if data.success or ({Purchased=true,Equipped=true,Upgraded=true,Claimed=true,Rebirthed=true,Sold=true})[data.Code]or(tonumber(data.CashAdded)or 0)>0 then C.Report.Confirmed+=1 end
        else status(key,err or"Waiting for server state")end
        return data
    end
    function C.Request(key,remote,...)
        C.Report.Requests+=1;local data,err=A.Invoke(remote,...);return result(key,data,err)
    end
    function C.StopMining(keepProgress)
        if C.Mining then A.Fire("Mining","Stop");C.Mining=false end;aimAt=0;lastAimTarget=nil;lastInputAt=nil
        if not keepProgress then progress=nil end
    end
    local function recovery(reason)
        C.Report.Recoveries+=1;C.Report.LastRecovery=reason;C.Report.LastRecoveryAt=A.Clock()
    end
    local function skipTarget(reason)
        if C.Target then avoidUntil[C.Target.Instance]=A.Clock()+8 end
        C.Target=nil;farmRetryAt=0;nextAt.FarmFinds=0;C.StopMining();recovery(reason)
        status("FarmFinds",reason.."; selecting another target")
    end
    function C.Set(key,value)
        if type(cfg[key])~="boolean"then return end
        cfg[key]=value==true;epoch[key]=(epoch[key]or 0)+1
        nextAt[key]=nil
        if key=="FarmFinds"and value then avoidUntil=setmetatable({},{__mode="k"});moveFailures=setmetatable({},{__mode="k"});farmRetryAt=0 end
        if not value then status(key,"Off");if key=="Dig"or key=="FarmFinds"or key=="Train"then C.StopMining();C.Target=nil;if A.ReleasePhase then A.ReleasePhase()end end end
    end
    function C.StopAll()
        C.Generation+=1
        for _,key in ipairs(P.Jobs)do C.Set(key,false)end
        C.StopMining();C.Target=nil;status("System","Stopped")
        if A.ReleasePhase then A.ReleasePhase()end
    end
    function C.Run(key,fn,manual)
        if C.Jobs[key]or not C.Alive then return end
        C.Jobs[key]=true;local generation=C.Generation;local version=epoch[key]or 0
        local function valid()return C.Alive and C.Generation==generation and(epoch[key]or 0)==version and(manual or cfg[key])and not A.Blocked()end
        A.Spawn(function()
            local ok,err=xpcall(function()
                if valid()then fn(valid)elseif manual and C.Alive then status(key,A.BlockReason and A.BlockReason()or"Action is paused")end
            end,debug.traceback)
            C.Jobs[key]=nil
            if not ok then status(key,"Error; retrying");C.Report.Errors[key]=tostring(err)end
        end)
    end
    local function invoke(valid,key,remote,...)
        if valid()then return C.Request(key,remote,...)end
    end
    local function money(valid,key,fn)
        if busyMoney or not valid()then status(key,"Waiting for purchase queue");return end
        busyMoney=true
        local ok,err=xpcall(fn,debug.traceback);busyMoney=false;if not ok then error(err)end
    end
    local function move(valid,key,target)
        if C.Shopping and C.Shopping~=key then status(key,"Waiting for shop");return false end
        if C.Selling and C.Selling~=key then status(key,"Waiting for sale");return false end
        if movingJob and movingJob~=key then status(key,"Waiting for movement queue");return false end
        movingJob=key;C.StopMining()
        local callOK,ok,msg=pcall(A.Move,target,valid,key);movingJob=nil
        if not callOK then error(ok)end
        status(key,msg);return ok
    end
    function C.Teleport(target)
        C.Run("Teleport",function(valid)
            target=A.ResolveTarget(target)
            if not target then status("Teleport","No loaded instance of the selected item");return end
            C.NavigationUntil=A.Clock()+1;C.Target=nil
            local arrived=move(valid,"Teleport",target)
            if arrived and valid()and cfg.FarmFinds and(cfg.FindKind=="All"or cfg.FindKind==target.Kind)and(cfg.FindRarity=="All"or cfg.FindRarity==target.Rarity)then C.Target=target end
        end,true)
    end
    function C.Surface(mode)
        C.Run("Travel",function(valid)
            if movingJob or C.Selling or C.Shopping then return end;C.StopMining();C.Target=nil;if A.ReleasePhase then A.ReleasePhase()end
            local _,_,r=A.Character();local before=r and r.Position
            if valid()then A.Fire("Surface",mode);A.Wait(.6)end
            if not valid()then return end
            local _,_,now=A.Character();status("Travel",now and before and(now.Position-before).Magnitude>3 and"Travel confirmed"or"Travel requested; check position")
        end,true)
    end
    local function shopSession(valid,key,fn)
        money(valid,key,function()
            if C.Selling or movingJob or A.MoveBusy then status(key,"Waiting for movement / sale");return end
            C.Shopping=key;C.StopMining()
            local ok,err=xpcall(fn,debug.traceback)
            C.Shopping=nil
            if not ok then error(err)end
        end)
    end
    local function shopOpen(valid,key,remote)
        local snap=invoke(valid,key,remote,"Open")
        if type(snap)~="table"or(snap.Code~="TooFar"and snap.Code~="OutOfRange")then return snap end
        if not valid()then return end
        local kind=remote=="Shovels"and"Shovels"or"Gear"
        local position=A.MarketPosition and A.MarketPosition(kind)
        if not position then
            if A.ReleasePhase then A.ReleasePhase()end
            A.Fire("Surface","Sell");status(key,"Loading market area")
            for _=1,6 do
                A.Wait(.2);if not valid()then return end
                position=A.MarketPosition and A.MarketPosition(kind);if position then break end
            end
        end
        if not position then status(key,"Shop not loaded; visit the market and retry");return end
        if not move(valid,key,{Position=position})then return end
        for _=1,3 do
            if not valid()then return end
            snap=invoke(valid,key,remote,"Open")
            if type(snap)~="table"or(snap.Code~="TooFar"and snap.Code~="OutOfRange")then break end
            A.Wait(.2)
        end
        return snap
    end
    function C.RefreshShop()
        C.Run("ShopRefresh",function(valid)shopSession(valid,"ShopRefresh",function()
            for _,remote in ipairs({"Shovels","Gear"})do
                local snap=shopOpen(valid,"ShopRefresh",remote)
                if valid()and type(snap)=="table"and(remote=="Shovels"and snap.Owned or remote=="Gear"and snap.Counts)then A.Snapshots[remote]=snap end
            end
        end)end,true)
    end
    local handlers={}
    handlers.FarmFinds=function(valid)
        if A.Clock()<(C.NavigationUntil or 0)or C.Selling or C.Shopping or C.Jobs.Plant or A.Attr("AfkTraining",false)or(cfg.Train and not cfg.Rotate)then return end
        local target=C.Target
        if not target or not A.ValidFind(target.Instance)or target.Kind~=cfg.FindKind and cfg.FindKind~="All"or target.Rarity~=cfg.FindRarity and cfg.FindRarity~="All"then
            target=nil
            for _,candidate in ipairs(A.Targets(cfg.FindKind,cfg.FindRarity))do if A.Clock()>=(avoidUntil[candidate.Instance]or 0)then target=candidate;break end end
            C.Target=target
        end
        if not target then status("FarmFinds","Waiting for streamed targets");return end
        if not A.Aim(target)then
            if A.Clock()<farmRetryAt then return end
            local arrived=move(valid,"FarmFinds",target)
            if not arrived or not A.Aim(target)then
                if not valid()then return end
                moveFailures[target.Instance]=(moveFailures[target.Instance]or 0)+1;farmRetryAt=A.Clock()+.5
                if moveFailures[target.Instance]>=3 then moveFailures[target.Instance]=nil;skipTarget("Target remains unreachable")end
                return
            end
        end
        moveFailures[target.Instance]=nil
        if valid()then status("FarmFinds","Target: "..target.Name.." #"..target.Serial);C.UpdateMining()end
    end
    handlers.Plant=function(valid)
        if movingJob or C.Shopping or C.Jobs.Train or A.Attr("AfkTraining",false)then return end
        local tool;for _,t in ipairs(A.Tools())do if t:GetAttribute("ItemId")=="Egg"then tool=t;break end end
        if not tool then status("Plant","Waiting for inventory eggs");return end
        local position=A.PlantPosition();if not position then status("Plant","Waiting for free ground on your plot");return end
        local _,_,root=A.Character();if not root then return end
        if(root.Position-position).Magnitude>25 and not move(valid,"Plant",{Position=position})then return end
        C.StopMining()
        local _,h=A.Character();if valid()and h then h:EquipTool(tool);A.Wait(.15)end
        if valid()and tool.Parent==A.Player.Character then
            A.Fire("Plant",position);status("Plant","Plant requested; waiting for inventory");A.Wait(.5)
            local reply=A.Snapshots.LastPlant
            if valid()and reply and A.Clock()-reply.At<2 then status("Plant",reply.Success and"Plant confirmed"or tostring(reply.Message or"Placement rejected"))end
        end
    end
    handlers.Hatch=function(valid)
        local snapshot=invoke(valid,"Hatch","Eggs","Snapshot");local ready=P.ReadyEggs(snapshot,A.ServerTime())
        if #ready==0 then status("Hatch","Waiting for ready eggs");return end
        -- One ready ID per cycle; a rejected hatch cannot block the others forever.
        C.HatchIndex=(C.HatchIndex or 0)%#ready+1
        invoke(valid,"Hatch","Eggs","Hatch",ready[C.HatchIndex])
    end
    for key,entry in pairs({SellLoot={"SellAll"},SellEggs={"SellSpareEggs","SpareEggs"},SellPets={"SellStoredPets","StoredPets"}})do
        local job,action,quoteKey=key,entry[1],entry[2]
        handlers[job]=function(valid)
            if C.Selling or C.Shopping or movingJob or A.MoveBusy then nextAt[job]=A.Clock()+.2;return end
            C.Selling=job;C.StopMining()
            local ok,err=xpcall(function()
                local function snapshot()
                    local snap=invoke(valid,job,"Sell","Open")
                    if type(snap)=="table"and(snap.Code=="TooFar"or snap.Code=="OutOfRange")and valid()then
                        if A.ReleasePhase then A.ReleasePhase()end
                        A.Fire("Surface","Sell");status(job,"Travelling to sell area");A.Wait(.25)
                        for _=1,3 do
                            if not valid()then return end
                            snap=invoke(valid,job,"Sell","Open")
                            if type(snap)=="table"and type(snap.Items)=="table"then break end
                            if type(snap)~="table"or(snap.Code~="TooFar"and snap.Code~="OutOfRange")then break end
                            A.Wait(.2)
                        end
                    end
                    return snap
                end
                local snap=snapshot();if type(snap)~="table"then return end
                if type(snap.Items)~="table"then status(job,snap.Code or"Invalid sale snapshot");return end
                A.Snapshots.Sell=snap
                local quote=quoteKey and P.Quote(snap,quoteKey)
                if quoteKey and quote==nil or not quoteKey and(tonumber(snap.Total)or 0)<=0 then status(job,"Nothing to sell");return end
                local reply=invoke(valid,job,"Sell",action,quote)
                if type(reply)=="table"and reply.Code=="Changed"and valid()then
                    snap=snapshot();quote=quoteKey and P.Quote(snap,quoteKey)
                    if snap and(quoteKey and quote~=nil or not quoteKey and(tonumber(snap.Total)or 0)>0)then reply=invoke(valid,job,"Sell",action,quote)end
                end
                if type(reply)=="table"then
                    if reply.Items then A.Snapshots.Sell=reply end
                    local cash=tonumber(reply.CashAdded)or 0
                    status(job,cash>0 and("Sold +$"..P.Money(cash))or(reply.Code or"Sale not confirmed"))
                end
            end,debug.traceback)
            C.Selling=nil;if not ok then error(err)end
        end
    end
    function C.BuyShovel(valid,choice)
        shopSession(valid,"BuyShovel",function()
            local snap=shopOpen(valid,"BuyShovel","Shovels");if not valid()or type(snap)~="table"or not snap.Owned then return end;A.Snapshots.Shovels=snap
            local catalog=A.Modules.ShovelCatalog;if not catalog then status("BuyShovel","Waiting for shovel catalog");return end
            local active=catalog.tier(A.Attr("ShovelLevel",1));local item,action=P.ShopChoice(catalog.Tiers,snap,choice or cfg.Shovel,A.Attr("Cash",0),cfg.Reserve,active and active.Id)
            if not item then status("BuyShovel","Equipped best / saving cash");return end
            local reply=invoke(valid,"BuyShovel","Shovels",action,item.Id);if type(reply)=="table"and reply.Owned then A.Snapshots.Shovels=reply end
        end)
    end
    handlers.BuyShovel=function(valid)C.BuyShovel(valid)end
    function C.BuyGear(valid,id)
        shopSession(valid,"BuyGear",function()
            local snap=shopOpen(valid,"BuyGear","Gear");if not valid()or type(snap)~="table"or not snap.Counts then return end;A.Snapshots.Gear=snap
            local catalog=A.Modules.ShovelCatalog;local tier=catalog and catalog.index(id);tier=tier and catalog.Tiers[tier]
            if tier and tier.Kind~="Drill"then return end
            if tier and snap.Owned and snap.Owned[id]then
                if A.Attr("ActiveDrillId")~=id then invoke(valid,"BuyGear","Gear","Equip",id,tier.Cost,snap.Stock and snap.Stock.Key)else status("BuyGear","Already equipped")end;return
            end
            local def=(A.Modules.GearConfig or{}).Types;def=def and def[id]
            if not tier and not def then status("BuyGear","Choose gear or a drill");return end
            if not tier and(tonumber(snap.Counts[id])or 0)>=cfg.GearLimit then status("BuyGear","Inventory limit reached");return end
            if def and def.SingleOwned and(tonumber(snap.Counts[id])or 0)>0 then status("BuyGear","Already owned");return end
            local price=tier and tier.Cost or snap.Prices and snap.Prices[id]
            local stock=snap.Stock
            if not stock or not stock.Key or not stock.Remaining or(tonumber(stock.Remaining[id])or 0)<=0 then status("BuyGear","Waiting for stock");return end
            if not P.Affordable(price,A.Attr("Cash",0),cfg.Reserve)then status("BuyGear","Saving cash / waiting for live price");return end
            local reply=invoke(valid,"BuyGear","Gear","Buy",id,price,stock.Key)
            if valid()and type(reply)=="table"and(reply.Code=="StockChanged"or reply.Code=="PriceChanged")then
                snap=shopOpen(valid,"BuyGear","Gear")
                if not valid()or type(snap)~="table"or not snap.Counts then return end
                A.Snapshots.Gear=snap;price=tier and tier.Cost or snap.Prices and snap.Prices[id];stock=snap.Stock
                if not tier and(tonumber(snap.Counts[id])or 0)>=(def and def.SingleOwned and 1 or cfg.GearLimit)then status("BuyGear","Inventory limit reached");return end
                if not stock or not stock.Key or not stock.Remaining or(tonumber(stock.Remaining[id])or 0)<=0 then status("BuyGear","Waiting for stock");return end
                if not P.Affordable(price,A.Attr("Cash",0),cfg.Reserve)then status("BuyGear","Saving cash / waiting for live price");return end
                reply=invoke(valid,"BuyGear","Gear","Buy",id,price,stock.Key)
            end
            if type(reply)=="table"and reply.Counts then A.Snapshots.Gear=reply end
            if valid()and tier and type(reply)=="table"and reply.Code=="Purchased"then
                invoke(valid,"BuyGear","Gear","Equip",id,tier.Cost,reply.Stock and reply.Stock.Key or stock.Key)
            end
        end)
    end
    handlers.BuyGear=function(valid)C.BuyGear(valid,cfg.Gear)end
    handlers.EquipPets=function(valid)
        if A.Attr("PetEquipBestNeeded",false)then invoke(valid,"EquipPets","Pets","EquipBest",nil,1)else status("EquipPets","Best pets already equipped")end
    end
    for key,def in pairs({TrainingUpgrade={"TrainingUpgradeConfig","TrainingLevel","Training"},PlotUpgrade={"PlotUpgradeConfig","PlotLevel","Plot"}})do
        local job,module,attribute,remote=key,def[1],def[2],def[3]
        handlers[job]=function(valid)money(valid,job,function()
            local config=A.Modules[module];if not config then return end
            local level=config.level(A.Attr(attribute));local offer=config.offer(level)
            if not offer then status(job,"Maximum level");return end
            if not P.Affordable(offer.CashCost,A.Attr("Cash",0),cfg.Reserve)then status(job,"Saving cash");return end
            local sign=A.TaggedOwn(config.SignTag)
            if not sign and remote=="Training"then status(job,"Waiting for your upgrade sign");return end
            invoke(valid,job,remote,sign,"Cash",level)
        end)end
    end
    for _,key in ipairs({"HoleLuck","AnimalIncome"})do
        local job=key;handlers[job]=function(valid)money(valid,job,function()
            local config=A.Modules.BoothUpgradeConfig;if not config or not config.Types[job]then return end
            local d=config.Types[job];local level=config.level(job,A.Attr(d.Attribute));local cost=config.cost(job,level)
            if not P.Affordable(cost,A.Attr("Cash",0),cfg.Reserve)then status(job,"Maximum level / saving cash");return end
            invoke(valid,job,"Booth","Buy",job,level)
        end)end
    end
    handlers.Rebirth=function(valid)
        local snap=invoke(valid,"Rebirth","Rebirth","Snapshot",A.Attr("Rebirths",0))
        if type(snap)~="table"then return end
        if type(snap.Count)~="number"or snap.Count>=cfg.RebirthLimit then status("Rebirth","Rebirth limit reached");return end
        if not snap.Eligible then status("Rebirth","Waiting for requirements");return end
        money(valid,"Rebirth",function()C.StopMining();invoke(valid,"Rebirth","Rebirth","Rebirth",snap.Count)end)
    end
    handlers.Potions=function(valid)
        local id=cfg.Potion;local config=A.Modules.PotionConfig
        if not config or not config.Types[id]then return end
        if A.Attr("Potion"..id.."Until",0)>A.ServerTime()then status("Potions","Potion is active");return end
        if A.Attr("DrinkingPotion",false)then return end
        C.StopMining();local tool=A.Equip("Potion","PotionId",id)
        if not tool then status("Potions","Waiting for owned potion");return end
        A.Wait(.2);if valid()and tool.Parent==A.Player.Character then A.Fire("Potion",id);status("Potions","Consume requested")end
    end
    handlers.Daily=function(valid)
        local s=invoke(valid,"Daily","DailyState")
        if type(s)=="table"and s.CanClaim and type(s.TotalClaims)=="number"then invoke(valid,"Daily","DailyClaim",s.TotalClaims)else status("Daily","Daily reward not ready")end
    end
    handlers.Offline=function(valid)
        local s=invoke(valid,"Offline","Offline","Snapshot")
        if type(s)=="table"and(tonumber(s.Base)or 0)>0 then invoke(valid,"Offline","Offline","Claim")else status("Offline","No offline earnings")end
    end
    handlers.PetIndex=function(valid)
        local s=invoke(valid,"PetIndex","Index","Snapshot")
        if type(s)=="table"then invoke(valid,"PetIndex","Index","ClaimAll")end
    end
    local function events(valid,key)
        local s=invoke(valid,key,"EventState");if type(s)=="table"then eventState=s;A.Snapshots.Events=s end;return eventState
    end
    local function allowed()
        local rule=A.Modules.AdminAbuseEligibility;return rule and rule.allowed(A.Player)==true
    end
    handlers.EventEggs=function(valid)
        local s=events(valid,"EventEggs");if not s or not s.live or not allowed()then status("EventEggs","Waiting for eligible event");return end
        local rains={};if type(s.event)=="table"then rains[#rains+1]=s.event end
        for _,rain in pairs(s.eggRains or{})do if type(rain)=="table"then rains[#rains+1]=rain end end
        local now=A.ServerTime();local selected,bestDrop,bestDistance,deadline
        local _,_,root=A.Character();if not root then return end
        for _,event in ipairs(rains)do
            local config=A.Modules.AbuseEventConfig;config=config and config.getEvent(event.kind)
            if config and config.CollectRadius and type(event.endTime)=="number"and event.id then
                local limit=event.endTime+(config.CleanupAfterShowerSeconds or 0)
                if now<limit then
                    local cache=plans[event.id]
                    if not cache or now-cache.At>5 then
                        local plan=invoke(valid,"EventEggs","EggPlan",event.id)
                        if type(plan)=="table"and type(plan.Drops)=="table"then cache={At=now,Data=plan};plans[event.id]=cache end
                    end
                    if not valid()then return end
                    for _,drop in ipairs(cache and cache.Data.Drops or{})do
                        local claimed=table.clone(cache and cache.Data.Claimed or{})
                        for index,value in pairs(collected[event.id]or{})do if value then claimed[index]=true end end
                        if P.DropEligible(drop,claimed,now,limit)and typeof(drop.Position)=="Vector3"then
                            local dist=(root.Position-drop.Position).Magnitude
                            if not bestDistance or dist<bestDistance then selected=event;bestDrop=drop;bestDistance=dist;deadline=limit end
                        end
                    end
                end
            end
        end
        -- Prune finished event plans instead of retaining drops for a long session.
        for id,cache in pairs(plans)do if now-cache.At>120 then plans[id]=nil;collected[id]=nil end end
        if not bestDrop then status("EventEggs","Waiting for landed event drops");return end
        local config=A.Modules.AbuseEventConfig.getEvent(selected.kind);local radius=config.CollectRadius
        if bestDistance>math.max(2,radius-2)and not move(valid,"EventEggs",{Position=bestDrop.Position})then return end
        local _,_,current=A.Character()
        if not valid()or not current or(current.Position-bestDrop.Position).Magnitude>radius or A.ServerTime()>=deadline then return end
        local reply=invoke(valid,"EventEggs","ClaimEgg",selected.id,bestDrop.Index)
        if type(reply)=="table"and(reply.success or reply.reason=="already_claimed"or reply.reason=="too_late")then
            collected[selected.id]=collected[selected.id]or{};collected[selected.id][bestDrop.Index]=true
        end
    end
    handlers.EventWaves=function(valid)
        local s=events(valid,"EventWaves");local e=s and s.event;local session=s and s.session
        local config=A.Modules.AbuseEventConfig;local rules=A.Modules.AbuseEventRules
        if not s or not s.live or not allowed()or not e or e.kind~="CashTsunami"or not session or typeof(session.groundPosition)~="Vector3"or not config or not rules then status("EventWaves","Waiting for Cash Tsunami");return end
        local _,_,root=A.Character();if not root then return end
        local d=root.Position-session.groundPosition;local distance=Vector2.new(d.X,d.Z).Magnitude
        local now=A.ServerTime();local waveConfig=config.getEvent("CashTsunami")
        for index,offset in ipairs(config.getWaveLaunchOffsets())do
            local id=tostring(e.id)..":"..index
            if not collected[id]and rules.waveEligible(now,e.startTime+offset,distance,waveConfig)then
                local reply=invoke(valid,"EventWaves","ClaimWave",e.id,index)
                if type(reply)=="table"and(reply.success or reply.reason=="already_claimed")then collected[id]=true end
                return
            end
        end
        status("EventWaves","Waiting for wave arrival")
    end
    handlers.UseGear=function(valid)
        if movingJob then return end
        local config=A.Modules.GearConfig;local id=cfg.UseGearId;local d=config and config.Types[id]
        if not d or d.Kind=="Launcher"then status("UseGear","Select placement gear");return end
        C.StopMining();local tool=A.Equip("Gear","GearId",id);if not tool then status("UseGear","Waiting for owned gear");return end
        local c,_,root,head=A.Character();if not head then return end
        local target
        if d.Kind=="MoonTotem"then target=A.PlantPosition()
        else
            local hit=A.Ground(root.Position+root.CFrame.LookVector*4+Vector3.new(0,2,0),{c},12)
            local mine=A.Mine();local grid=A.Modules.GearPlacementGrid;local frame=mine and mine:GetAttribute("DigFrame")
            if hit and hit.Normal.Y>=.65 and mine and hit.Instance:IsDescendantOf(mine)and not hit.Instance:GetAttribute("MineBoundary")and grid and typeof(frame)=="CFrame"then target=grid.snap(frame,hit.Position)end
        end
        if not target or(target-head.Position).Magnitude>(config.Reach or 16)then status("UseGear","Move to clear placement ground");return end
        A.Wait(.15);if valid()then A.Fire("PlaceGear",id,target);status("UseGear","Placement requested")end
    end
    handlers.Pumpkin=function(valid)
        if movingJob then return end
        local target=C.Target or A.Targets(cfg.FindKind,cfg.FindRarity)[1]
        if not target or not A.Aim(target)then status("Pumpkin","Waiting for nearby target");return end
        C.StopMining();local tool=A.Equip("Gear","GearId","PumpkinLauncher")
        if not tool then status("Pumpkin","Waiting for Pumpkin Launcher");return end
        A.Wait(.15);if valid()then A.Fire("Pumpkin",target.Instance.Position);status("Pumpkin","Shot requested")end
    end
    local trainStarted=0;local miningStarted=A.Clock()
    handlers.Train=function(valid)
        if C.Shopping or C.Selling or movingJob then return end
        local now=A.Clock()
        if cfg.Rotate and trainStarted>0 and now-trainStarted>=cfg.TrainSeconds then
            C.StopMining();if valid()then A.Fire("Surface","DigSite")end
            miningStarted=now;trainStarted=0;status("Train","Mining rotation");return
        end
        if cfg.Rotate and trainStarted==0 and now-miningStarted<cfg.DigSeconds then status("Train","Mining rotation");return end
        if A.Attr("AfkTraining",false)then if trainStarted==0 then trainStarted=now end;status("Train","Training confirmed");return end
        local plot=A.Plot();local frame=plot and plot:GetAttribute("PlotFrame");local progression=A.Modules.ProgressionConfig
        if typeof(frame)~="CFrame"or not progression or typeof(progression.TrainingOffset)~="Vector3"then status("Train","Training area not streamed");return end
        move(valid,"Train",{Position=frame:PointToWorldSpace(progression.TrainingOffset),Training=true})
        if valid()then status("Train",A.Attr("AfkTraining",false)and"Training confirmed"or"Arrived; waiting for training trigger")end
    end
    local intervals={FarmFinds=.1,Plant=2,Hatch=2,SellLoot=5,SellEggs=5,SellPets=5,BuyShovel=6,BuyGear=6,EquipPets=4,TrainingUpgrade=6,PlotUpgrade=6,HoleLuck=6,AnimalIncome=6,Rebirth=10,Potions=5,Daily=30,Offline=30,PetIndex=30,EventEggs=.65,EventWaves=.5,UseGear=23,Pumpkin=1,Train=3}
    function C.Tick()
        if not C.Alive then return end
        if A.UpdatePhase then A.UpdatePhase()end
        local now=A.Clock()
        for key,fn in pairs(handlers)do
            local urgent=key=="FarmFinds"and C.Target and not A.ValidFind(C.Target.Instance)
            if cfg[key]and(now>=(nextAt[key]or 0)or urgent)then nextAt[key]=now+(intervals[key]or 5);C.Run(key,fn)end
        end
        C.UpdateMining()
    end
    function C.UpdateMining()
        local now=A.Clock()
        if not C.Alive or not(cfg.Dig or cfg.FarmFinds)then C.StopMining();return end
        local blocked=A.Blocked()
        if C.Shopping or C.Selling or movingJob or A.MoveBusy or C.Jobs.Plant or C.Jobs.Potions or C.Jobs.UseGear or C.Jobs.Pumpkin or blocked or A.Attr("AfkTraining",false)then
            C.StopMining();status("Dig",C.Selling and"Selling; mining resumes afterwards"or blocked and(A.BlockReason and A.BlockReason()or"Temporarily paused")or A.Attr("AfkTraining",false)and"Training; mining paused"or"Finishing movement / item action");return
        end
        if cfg.FarmFinds and not C.Target then C.StopMining();status("Dig","Waiting for selected target");return end
        local targetKey=cfg.FarmFinds and C.Target and C.Target.Instance or"Down"
        if now<aimAt and lastAimTarget==targetKey then return end
        local rate=cfg.FastDig and P.Number(cfg.AimRate,20,5,40)or 10;aimAt=now+1/rate
        local equipment=A.Modules.Equipment
        if equipment and not(A.EnsureDigEquipment and A.EnsureDigEquipment()or not A.EnsureDigEquipment and equipment.shovel(A.Player.Character))then C.StopMining();status("Dig","Restoring equipped shovel / drill");return end
        local origin,direction,mode,selected,hitPart=A.Aim(cfg.FarmFinds and C.Target or nil)
        if not origin then C.StopMining();status("Dig","Waiting for reachable diggable ground");return end
        local timeout=P.Number((A.Modules.ContinuousMiningConfig or{}).AimTimeout,.3,.1,2)
        if C.Mining and lastInputAt and now-lastInputAt>=timeout*.9 then C.StopMining(true);recovery("Restarted mining after input gap")end
        local observed=hitPart or(cfg.FarmFinds and C.Target and C.Target.Instance)
        local health=A.Health and A.Health(observed)
        C.Report.TargetHealth=health;C.Report.TargetName=C.Target and C.Target.Name or nil
        if type(health)=="number"then
            if not progress or progress.Part~=observed or progress.Health~=health then progress={Part=observed,Health=health,At=now,Restarts=0}
            else
                local cooldown=A.NativeCooldown and A.NativeCooldown()or .5
                if now-progress.At>=math.max(3,cooldown*4)then
                    progress.At=now;progress.Restarts+=1
                    if progress.Restarts>=3 and cfg.FarmFinds then skipTarget("No server health progress");return end
                    C.StopMining(true);recovery("Restarted mining: target health unchanged")
                end
            end
        end
        local action=C.Mining and"Aim"or"Start"
        local sent,err=A.Fire("Mining",action,origin,direction,mode,selected)
        if sent then C.Mining=true;lastInputAt=now;lastAimTarget=targetKey;aimAt=now+1/rate;C.Report.LastMiningAction=action;C.Report.LastMiningPacketAt=now;status("Dig",string.format("Continuous mining | %d aim updates/s",rate))else C.Mining=false;status("Dig",err)end
    end
    function C.Destroy()C.StopAll();C.Alive=false;A.Destroy()end
    C.Handlers=handlers
    return C
end

end)()
local makeView=(function()
return function(window,A,P,assets)
    local V={Pickers={},Alive=true,Models={},Loading={},PreviewCount=0}
    local function imageFor(item)return(item.Kind==nil or item.Kind=="Potion")and assets[item.Id]or nil end
    local function node(class,parent,props)
        local n=Instance.new(class);for k,v in pairs(props)do n[k]=v end;n.Parent=parent;return n
    end
    function V.Image(parent,item,size)
        local icon=imageFor(item)
        if icon then
            local n=node("ImageLabel",parent,{Name="DevilItemIcon",Size=UDim2.fromOffset(size,size),BackgroundTransparency=1,Image=icon,ImageColor3=Color3.new(1,1,1),ScaleType=Enum.ScaleType.Fit,ZIndex=parent.ZIndex+1})
            n:SetAttribute("CustomIcon",true);return n
        end
        local view=node("ViewportFrame",parent,{Name="DevilItemModel",Size=UDim2.fromOffset(size,size),BackgroundTransparency=1,Ambient=Color3.new(1,1,1),LightColor=Color3.new(1,1,1),ZIndex=parent.ZIndex+1})
        view:SetAttribute("CustomIcon",true)
        A.Spawn(function()
            if not V.Alive or not view.Parent then return end
            local model
            if item.Kind=="Material"and item.Instance then
                model=Instance.new("Model");local part=item.Instance:Clone();part.Size=Vector3.new(3,3,3);part.CFrame=CFrame.new();part.Transparency=0;part.Parent=model
            else
                local name=({Egg="EggModel",Artifact="ArtifactModels",Potion="PotionModel"})[item.Kind]
                local module=name and A.RS:FindFirstChild("Shared");module=module and module:FindFirstChild(name)
                if module then
                    -- Only allowlisted pure model builders; never start native client controllers.
                    local ok,builder=pcall(require,module)
                    if ok and V.Alive and view.Parent and type(builder)=="table"and type(builder.create)=="function"then
                        local good,value=pcall(builder.create,item.Id);if good and typeof(value)=="Instance"then model=value end
                    end
                end
            end
            if not model then return end
            if not V.Alive or not view.Parent then model:Destroy();return end
            for _,n in ipairs(model:GetDescendants())do
                if n:IsA("BaseScript")or n:IsA("ModuleScript")or n:IsA("ParticleEmitter")or n:IsA("Trail")or n:IsA("Beam")then n:Destroy()
                elseif n:IsA("BasePart")then n.Anchored=true;n.CanCollide=false;n.CanTouch=false;n.CanQuery=false end
            end
            local world=Instance.new("WorldModel");world.Parent=view;model.Parent=world
            local frame,extent=model:GetBoundingBox();local camera=Instance.new("Camera");camera.FieldOfView=35
            camera.CFrame=CFrame.lookAt(frame.Position+Vector3.new(1,.55,1).Unit*math.max(1,extent.Magnitude*1.8),frame.Position)
            camera.Parent=view;view.CurrentCamera=camera
        end)
        return view
    end
    function V.Picker(host,key,name,callback)
        local before={};for _,n in ipairs(window.Body:GetChildren())do before[n]=true end
        local picker={Map={},Rows=setmetatable({},{__mode="k"})}
        picker.Widget=host:CreateDropdown({Name=name,Options={},AllowNone=true,Searchable=true,PopupWidth=470,Callback=function(label)
            if type(label)=="table"then label=label[1]end
            local item=picker.Map[label];if item then callback(item.Id,item)end
        end})
        for _,n in ipairs(window.Body:GetChildren())do if not before[n]and n:IsA("Frame")then picker.Popup=n end end
        V.Pickers[key]=picker;return picker.Widget
    end
    function V.Refresh(key,items,selected)
        local picker=V.Pickers[key];if not picker then return end
        local names,map={},{}
        for _,item in ipairs(items)do local label=item.Label or item.Name or item.Id;names[#names+1]=label;map[label]=item end
        picker.Map=map
        local signature=table.concat(names,"\0")
        if signature~=picker.Signature then
            picker.Widget:Refresh(names,true,true);picker.Signature=signature
            if selected then for _,name in ipairs(names)do if(map[name].Key or map[name].Id)==selected then picker.Widget:Set(name,true);break end end end
        end
        if not picker.Popup then return end
        for _,label in ipairs(picker.Popup:GetDescendants())do
            if label:IsA("TextLabel")and label.Parent and label.Parent:IsA("TextButton")and label.Name~="DevilItemPrice"then
                local plain=label.Text:gsub("<[^>]*>",""):gsub("&amp;","&");local item=map[plain]
                if item then
                    local row=picker.Rows[label]
                    if not row then
                        row={Label=label,Parent=label.Parent};picker.Rows[label]=row
                        label.Position=UDim2.fromOffset(44,0);label.Size=UDim2.new(1,-175,1,0);label.TextColor3=Color3.new(1,1,1);label.TextTransparency=0
                        row.Price=node("TextLabel",label.Parent,{Name="DevilItemPrice",Size=UDim2.fromOffset(118,30),AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-26,.5,0),BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=10,TextColor3=Color3.fromRGB(164,221,255),TextXAlignment=Enum.TextXAlignment.Right,ZIndex=label.ZIndex+1,Text=""})
                    end
                    row.Item=item;row.Price.Text=item.Detail or""
                    if imageFor(item)and not row.Icon then row.Icon=V.Image(row.Parent,item,26);row.Icon.Position=UDim2.new(0,10,.5,-13)end
                end
            end
        end
    end
    function V.VisibleModels()
        -- Bound viewport cost to eight visible rows, even when hundreds of blocks stream in.
        local count=0
        for _,picker in pairs(V.Pickers)do
            for label,row in pairs(picker.Rows)do
                if row.Item and not imageFor(row.Item)then
                    local popup=picker.Popup;local visible=V.Alive and label.Parent and popup and popup.Visible and label.AbsolutePosition.Y>=popup.AbsolutePosition.Y and label.AbsolutePosition.Y<popup.AbsolutePosition.Y+popup.AbsoluteSize.Y
                    if visible and count<8 then
                        count+=1;if not row.Icon then row.Icon=V.Image(row.Parent,row.Item,26);row.Icon.Position=UDim2.new(0,10,.5,-13)end
                    elseif row.Icon then row.Icon:Destroy();row.Icon=nil end
                end
            end
        end
    end
    function V.Destroy()V.Alive=false end
    return V
end

end)()
local assets={["Basic"]="rbxassetid://82607806582254",["Grey"]="rbxassetid://84718066117646",["Green"]="rbxassetid://108153605421728",["Blue"]="rbxassetid://88201373524492",["Purple"]="rbxassetid://133348464670729",["Golden"]="rbxassetid://137223701139677",["Red"]="rbxassetid://100868825563504",["Galaxy"]="rbxassetid://124079969014331",["Secret"]="rbxassetid://88306339908791",["Eternal"]="rbxassetid://91735956058773",["Divine"]="rbxassetid://79013272643598",["Godly"]="rbxassetid://132789056550916",["Transcendent"]="rbxassetid://117387295659510",["Primordial"]="rbxassetid://90759316679765",["Astronomical"]="rbxassetid://87920012641201",["IndustrialDrill"]="rbxassetid://127003251000511",["TitaniumDrill"]="rbxassetid://128557810440603",["PlasmaDrill"]="rbxassetid://76715730228084",["TNT1"]="rbxassetid://89598348008470",["TNT2"]="rbxassetid://124515546167383",["TNT3"]="rbxassetid://122561807137176",["Radar1"]="rbxassetid://137161613613305",["Radar2"]="rbxassetid://72044897314343",["Radar3"]="rbxassetid://129979864742344",["MoonTotem"]="rbxassetid://118815397419556",["PumpkinLauncher"]="rbxassetid://107596347538694",["Training"]="rbxassetid://124340074431648",["Cash"]="rbxassetid://84748695520060",["DigSpeed"]="rbxassetid://70443377049090",["HatchLuck"]="rbxassetid://109301581007466",["Growth"]="rbxassetid://139703536386984"}
local catalog={["Egg"]={["Titanic__Nebula"]={["Name"]="Titanic Nebula Egg",["Rarity"]="Eternal",["Tier"]=9},["Honey"]={["Name"]="Honey Egg",["Rarity"]="Epic",["Tier"]=4},["Titanic__Empyrean"]={["Name"]="Titanic Empyrean Egg",["Rarity"]="Godly",["Tier"]=11},["Titanic__Slate"]={["Name"]="Titanic Slate Egg",["Rarity"]="Rare",["Tier"]=3},["Huge__Cataclysm"]={["Name"]="Huge Null Egg",["Rarity"]="Zero",["Tier"]=13},["Titanic__Fern"]={["Name"]="Titanic Fern Egg",["Rarity"]="Uncommon",["Tier"]=2},["Cataclysm"]={["Name"]="Null Egg",["Rarity"]="Zero",["Tier"]=13},["Titanic__Void"]={["Name"]="Titanic Void Egg",["Rarity"]="Secret",["Tier"]=8},["Relic"]={["Name"]="Relic Egg",["Rarity"]="Mythic",["Tier"]=6},["Titanic__Soil"]={["Name"]="Titanic Soil Egg",["Rarity"]="Common",["Tier"]=1},["Titanic__Genesis"]={["Name"]="Titanic Genesis Egg",["Rarity"]="Godly",["Tier"]=11},["Fossil"]={["Name"]="Fossil Egg",["Rarity"]="Mythic",["Tier"]=6},["Titanic__Crystal"]={["Name"]="Titanic Crystal Egg",["Rarity"]="Legendary",["Tier"]=5},["Huge__Unfathomable"]={["Name"]="Huge Unfathomable Egg",["Rarity"]="Godly",["Tier"]=11},["Huge__Astral"]={["Name"]="Huge Astral Egg",["Rarity"]="Eternal",["Tier"]=9},["Titanic__Moss"]={["Name"]="Titanic Moss Egg",["Rarity"]="Uncommon",["Tier"]=2},["Titanic__Paradox"]={["Name"]="Titanic Paradox Egg",["Rarity"]="Transcendent",["Tier"]=12},["Starlight"]={["Name"]="Starlight Egg",["Rarity"]="Astronomical",["Tier"]=14},["Titanic__Magma"]={["Name"]="Titanic Magma Egg",["Rarity"]="Cosmic",["Tier"]=7},["Huge__Void"]={["Name"]="Huge Void Egg",["Rarity"]="Secret",["Tier"]=8},["Nebula"]={["Name"]="Nebula Egg",["Rarity"]="Eternal",["Tier"]=9},["Astral"]={["Name"]="Astral Egg",["Rarity"]="Eternal",["Tier"]=9},["Titanic__Zenith"]={["Name"]="Titanic Zenith Egg",["Rarity"]="Transcendent",["Tier"]=12},["Titanic__Clay"]={["Name"]="Titanic Clay Egg",["Rarity"]="Common",["Tier"]=1},["Huge__Stone"]={["Name"]="Huge Stone Egg",["Rarity"]="Rare",["Tier"]=3},["Ember"]={["Name"]="Ember Egg",["Rarity"]="Cosmic",["Tier"]=7},["Huge__Fossil"]={["Name"]="Huge Fossil Egg",["Rarity"]="Mythic",["Tier"]=6},["Huge__Fern"]={["Name"]="Huge Fern Egg",["Rarity"]="Uncommon",["Tier"]=2},["Huge__Nebula"]={["Name"]="Huge Nebula Egg",["Rarity"]="Eternal",["Tier"]=9},["Divine"]={["Name"]="Divine Egg",["Rarity"]="Divine",["Tier"]=10},["Titanic__Honey"]={["Name"]="Titanic Honey Egg",["Rarity"]="Epic",["Tier"]=4},["Huge__Divine"]={["Name"]="Huge Divine Egg",["Rarity"]="Divine",["Tier"]=10},["Titanic__Relic"]={["Name"]="Titanic Relic Egg",["Rarity"]="Mythic",["Tier"]=6},["Titanic__Unfathomable"]={["Name"]="Titanic Unfathomable Egg",["Rarity"]="Godly",["Tier"]=11},["Slate"]={["Name"]="Slate Egg",["Rarity"]="Rare",["Tier"]=3},["Titanic__Supernova"]={["Name"]="Titanic Supernova Egg",["Rarity"]="Astronomical",["Tier"]=14},["Titanic__Starlight"]={["Name"]="Titanic Starlight Egg",["Rarity"]="Astronomical",["Tier"]=14},["Titanic__Cataclysm"]={["Name"]="Titanic Null Egg",["Rarity"]="Zero",["Tier"]=13},["Titanic__Seraph"]={["Name"]="Titanic Seraph Egg",["Rarity"]="Divine",["Tier"]=10},["Titanic__Amber"]={["Name"]="Titanic Amber Egg",["Rarity"]="Epic",["Tier"]=4},["Titanic__Divine"]={["Name"]="Titanic Divine Egg",["Rarity"]="Divine",["Tier"]=10},["Seraph"]={["Name"]="Seraph Egg",["Rarity"]="Divine",["Tier"]=10},["Titanic__Astral"]={["Name"]="Titanic Astral Egg",["Rarity"]="Eternal",["Tier"]=9},["Huge__Crystal"]={["Name"]="Huge Crystal Egg",["Rarity"]="Legendary",["Tier"]=5},["Huge__Amber"]={["Name"]="Huge Amber Egg",["Rarity"]="Epic",["Tier"]=4},["Huge__Starlight"]={["Name"]="Huge Starlight Egg",["Rarity"]="Astronomical",["Tier"]=14},["Unfathomable"]={["Name"]="Unfathomable Egg",["Rarity"]="Godly",["Tier"]=11},["Huge__Prism"]={["Name"]="Huge Prism Egg",["Rarity"]="Legendary",["Tier"]=5},["Void"]={["Name"]="Void Egg",["Rarity"]="Secret",["Tier"]=8},["Huge__Soil"]={["Name"]="Huge Soil Egg",["Rarity"]="Common",["Tier"]=1},["Huge__Moss"]={["Name"]="Huge Moss Egg",["Rarity"]="Uncommon",["Tier"]=2},["Titanic__Ember"]={["Name"]="Titanic Ember Egg",["Rarity"]="Cosmic",["Tier"]=7},["Titanic__Fossil"]={["Name"]="Titanic Fossil Egg",["Rarity"]="Mythic",["Tier"]=6},["Empyrean"]={["Name"]="Empyrean Egg",["Rarity"]="Godly",["Tier"]=11},["Moss"]={["Name"]="Moss Egg",["Rarity"]="Uncommon",["Tier"]=2},["Prism"]={["Name"]="Prism Egg",["Rarity"]="Legendary",["Tier"]=5},["Titanic__Eclipse"]={["Name"]="Titanic Eclipse Egg",["Rarity"]="Secret",["Tier"]=8},["Eclipse"]={["Name"]="Eclipse Egg",["Rarity"]="Secret",["Tier"]=8},["Stone"]={["Name"]="Stone Egg",["Rarity"]="Rare",["Tier"]=3},["Huge__Clay"]={["Name"]="Huge Clay Egg",["Rarity"]="Common",["Tier"]=1},["Titanic__Stone"]={["Name"]="Titanic Stone Egg",["Rarity"]="Rare",["Tier"]=3},["Huge__Empyrean"]={["Name"]="Huge Empyrean Egg",["Rarity"]="Godly",["Tier"]=11},["Huge__Ember"]={["Name"]="Huge Ember Egg",["Rarity"]="Cosmic",["Tier"]=7},["Huge__Genesis"]={["Name"]="Huge Genesis Egg",["Rarity"]="Godly",["Tier"]=11},["Huge__Zenith"]={["Name"]="Huge Zenith Egg",["Rarity"]="Transcendent",["Tier"]=12},["Magma"]={["Name"]="Magma Egg",["Rarity"]="Cosmic",["Tier"]=7},["Huge__Magma"]={["Name"]="Huge Magma Egg",["Rarity"]="Cosmic",["Tier"]=7},["Huge__Slate"]={["Name"]="Huge Slate Egg",["Rarity"]="Rare",["Tier"]=3},["Paradox"]={["Name"]="Paradox Egg",["Rarity"]="Transcendent",["Tier"]=12},["Crystal"]={["Name"]="Crystal Egg",["Rarity"]="Legendary",["Tier"]=5},["Huge__Seraph"]={["Name"]="Huge Seraph Egg",["Rarity"]="Divine",["Tier"]=10},["Huge__Honey"]={["Name"]="Huge Honey Egg",["Rarity"]="Epic",["Tier"]=4},["Soil"]={["Name"]="Soil Egg",["Rarity"]="Common",["Tier"]=1},["Fern"]={["Name"]="Fern Egg",["Rarity"]="Uncommon",["Tier"]=2},["Zenith"]={["Name"]="Zenith Egg",["Rarity"]="Transcendent",["Tier"]=12},["Huge__Paradox"]={["Name"]="Huge Paradox Egg",["Rarity"]="Transcendent",["Tier"]=12},["Huge__Eclipse"]={["Name"]="Huge Eclipse Egg",["Rarity"]="Secret",["Tier"]=8},["Clay"]={["Name"]="Clay Egg",["Rarity"]="Common",["Tier"]=1},["Amber"]={["Name"]="Amber Egg",["Rarity"]="Epic",["Tier"]=4},["Genesis"]={["Name"]="Genesis Egg",["Rarity"]="Godly",["Tier"]=11},["Titanic__Prism"]={["Name"]="Titanic Prism Egg",["Rarity"]="Legendary",["Tier"]=5},["Huge__Relic"]={["Name"]="Huge Relic Egg",["Rarity"]="Mythic",["Tier"]=6},["Huge__Supernova"]={["Name"]="Huge Supernova Egg",["Rarity"]="Astronomical",["Tier"]=14},["Supernova"]={["Name"]="Supernova Egg",["Rarity"]="Astronomical",["Tier"]=14}}}
local A=makeAdapter(scope,catalog);local C=makeCore(A,P);local cfg=C.Config
local app={Version=C.Report.Version,Core=C,Adapter=A,Config=cfg,Report=C.Report,Stopped=false};scope.DevilV4Test=app
local window,view,library,logo;local rebuilding=false;local language="EN";local languageOwner,baseSet,wrappedSet
local statusWidget,detailsWidget,settingsWidget,travelWidget,sellWidget,shovelWidget,gearWidget;local controls={};local jobNames={};local selectedTarget;local lastRefresh=0
local profile="DevilHub_MiningTest_"..A.Player.UserId.."_"..game.PlaceId..".json"
local settingsStatus="Ready";local buildUI
local function t(en,th)return language=="TH"and th or en end
local function languageValue()
    local owner=scope.DevilHubBlueGui
    if owner and type(owner.Get)=="function"then local s=owner.Get();if s.Language=="TH"or s.Language=="EN"then return s.Language,owner end end
    return language
end
function app.Destroy()
    if app.Stopped then return end;app.Stopped=true;C.Destroy()
    if languageOwner and languageOwner.Set==wrappedSet then languageOwner.Set=baseSet end
    if view then view.Destroy()end;if window then window:Destroy()end
    if scope.DevilV4Test==app then scope.DevilV4Test=nil end;scope.DevilV4Starting=nil
end
local function loadSettings()
    assert(type(readfile)=="function","Settings file API unavailable")
    local text=readfile(profile);assert(#text<=65536,"Settings file too large")
    local s=A.Http:JSONDecode(text);assert(s.Version==1 and s.UserId==A.Player.UserId and s.PlaceId==game.PlaceId,"Settings belong to another account or map")
    local restored=P.Settings(s.Config);C.StopAll()
    for key,value in pairs(restored)do cfg[key]=value end
    settingsStatus="Settings loaded";if buildUI then buildUI()end
end
local function saveSettings()
    assert(type(writefile)=="function","Settings file API unavailable")
    writefile(profile,A.Http:JSONEncode({Version=1,UserId=A.Player.UserId,PlaceId=game.PlaceId,Config=P.Settings(cfg)}));settingsStatus="Settings saved"
end
local ok,problem=xpcall(function()
    -- BEGIN SHARED DEVIL BLUE GUI
do
    local shared=type(getgenv)=="function"and getgenv()or _G
    local current=shared.DevilHubBlueGui
    if not(current and current.Version=="devil-blue-20261019-10"and not current.Stopped)then
        local ok,problem=pcall(function()
            local source=game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/9a9812469df7b5dad2848abb33c5206f7d57e685/devil-blue-gui.lua")
            assert(type(source)=="string"and #source==95003,"DEVIL blue GUI download size mismatch")
            local sum=0
            for i=1,#source do sum=(sum*33+source:byte(i))%4294967296;if i%32768==0 and task and task.wait then task.wait()end end
            assert(sum==941138957,"DEVIL blue GUI checksum mismatch")
            local run,err=loadstring(source,"DEVIL HUB / Blue GUI")
            assert(run,err)
            return run()
        end)
        if not ok then warn("DEVIL HUB: blue GUI could not start: "..tostring(problem))end
    end
end
-- END SHARED DEVIL BLUE GUI

    local source=game:HttpGet("https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau")
    assert(#source==402130,"GUI download size mismatch")
    local sum=0;for i=1,#source do sum=(sum*33+source:byte(i))%4294967296 end;assert(sum==1125396239,"GUI download checksum mismatch")
    library=assert(loadstring(source,"DEVIL HUB / Mining test GUI"))()
    logo=scope.DevilHubSilverLogo
    if not logo then pcall(function()
        local asset=getcustomasset or getsynasset;if type(asset)~="function"or type(writefile)~="function"then return end
        local bytes=game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/9a9812469df7b5dad2848abb33c5206f7d57e685/assets/devil-logo-silver-transparent.png")
        assert(bytes:sub(1,8)=="\137PNG\13\10\26\10");writefile("DevilHub_Silver_Mining.png",bytes);logo=asset("DevilHub_Silver_Mining.png");scope.DevilHubSilverLogo=logo
    end)end
    language=languageValue()
    local function button(host,en,th,fn)
        return host:CreateButton({Name=t(en,th),Callback=function()A.ReleaseHubFocus(window.Gui);A.Spawn(function()local good,err=xpcall(fn,debug.traceback);if not good then settingsStatus=tostring(err);C.Report.Errors.UI=tostring(err)end end)end})
    end
    local function toggle(host,key,en,th)
        jobNames[key]=t(en,th)
        controls[key]=host:CreateToggle({Name=jobNames[key],CurrentValue=cfg[key],Callback=function(value)if value then A.ReleaseHubFocus(window.Gui)end;C.Set(key,value)end})
    end
    local function slider(host,key,en,th,lo,hi,increment)
        controls[key]=host:CreateSlider({Name=t(en,th),Range={lo,hi},Increment=increment or 1,CurrentValue=cfg[key],Callback=function(v)cfg[key]=P.Number(v,cfg[key],lo,hi)end})
    end
    local function choose(host,key,en,th,options)
        controls[key]=host:CreateDropdown({Name=t(en,th),Options=options,CurrentOption=cfg[key],Searchable=true,Callback=function(v)
            if type(v)~="string"then return end;cfg[key]=v
            if key=="TeleportKind"then cfg.TeleportChoice="";selectedTarget=nil;view.Refresh("Targets",{});lastRefresh=0 end
        end})
    end
    local function group(tab,en,th,side)return tab:CreateGroupbox({Name=t(en,th),Side=side or"Left"})end
    local function tab(en,th,icon)return window:CreateTab({Name=t(en,th),Icon=icon,Backdrop=false})end
    buildUI=function()
        if app.Stopped then return end
        rebuilding=true;if view then view.Destroy()end;if window then window:Destroy()end;controls={};selectedTarget=nil
        window=library:CreateWindow({Name="DEVIL HUB",Icon=logo,Theme={Background=Color3.fromRGB(7,9,13),Surface=Color3.fromRGB(11,13,18),Surface2=Color3.fromRGB(16,19,25),Surface3=Color3.fromRGB(32,39,49),Accent=Color3.fromRGB(164,221,255),Text=Color3.new(1,1,1),Muted=Color3.fromRGB(153,169,185),Warning=Color3.fromRGB(164,221,255)},Density="Compact",Profile=true,Search=true,Home=false,Loading=false,Backdrop=false,UnsupportedExecutor=false,Disclaimer=false,Size=UDim2.fromOffset(840,570),ToggleButton={Platform="Both",Icon=logo},IslandDraggable=true,KeepOnScreen=true,ConfigurationSaving={Enabled=false}})
        window.Gui:SetAttribute("DevilHubPresentation",true);app.Window=window;view=makeView(window,A,P,assets)
        window.Gui.Destroying:Connect(function()if not rebuilding then app.Destroy()end end)
        local farm=tab("Farm","ฟาร์ม","pickaxe")
        local dig=group(farm,"Mining controls","ระบบขุด")
        toggle(dig,"Dig","Auto Dig","ขุดอัตโนมัติ");toggle(dig,"FarmFinds","Auto Farm Selected Finds","วาร์ปขุดของตามตัวกรอง")
        toggle(dig,"FastDig","Fast Dig","ขุดต่อเนื่องความเร็วสูง");slider(dig,"AimRate","Aim updates / second","ความถี่อัปเดตเป้าขุด / วินาที",5,40)
        choose(dig,"FindKind","Target type","ประเภทเป้าหมาย",{"All","Egg","Artifact","Potion","Material"})
        choose(dig,"FindRarity","Rarity","ระดับความหายาก",{"All","Common","Uncommon","Rare","Epic","Legendary","Mythic","Cosmic","Secret","Eternal","Divine","Godly","Transcendent","Zero","Astronomical"})
        local grow=group(farm,"Eggs and training","ไข่และการฝึก","Right")
        toggle(grow,"Plant","Auto Plant Inventory Eggs","วางไข่จากกระเป๋าอัตโนมัติ");toggle(grow,"Hatch","Auto Hatch Ready Eggs","ฟักไข่ที่พร้อมอัตโนมัติ")
        toggle(grow,"Train","Auto Training","ฝึกอัตโนมัติ");toggle(grow,"Rotate","Rotate Training / Digging","สลับฝึกและขุดตามเวลา")
        slider(grow,"TrainSeconds","Training seconds","เวลาฝึก (วินาที)",15,900,15);slider(grow,"DigSeconds","Mining seconds","เวลาขุด (วินาที)",15,900,15)
        grow:CreateLabel({Text=t("Planting needs clear ground on your own plot.","การวางไข่ต้องมีพื้นที่ว่างในฐานของคุณ")})
        local travel=tab("Teleport","วาร์ป","map-pin");local targetGroup=group(travel,"Live targets","เป้าหมายที่มีอยู่จริง")
        choose(targetGroup,"TeleportKind","Teleport target type","ประเภทเป้าหมายวาร์ป",{"Egg","Artifact","Potion","Material","All"})
        view.Picker(targetGroup,"Targets",t("Ore / item target","เลือกแร่หรือสิ่งของ"),function(_,item)selectedTarget=item;cfg.TeleportChoice=item.Key end)
        button(targetGroup,"Teleport to selected target","วาร์ปไปเป้าหมายที่เลือก",function()
            local target=selectedTarget
            for _,item in ipairs(A.TeleportOptions(cfg.TeleportKind))do if item.Key==cfg.TeleportChoice then target=item;break end end
            if target and(cfg.TeleportKind=="All"or target.Kind==cfg.TeleportKind)then C.Teleport(target)else C.Report.Jobs.Teleport="Select an egg / item first"end
        end)
        button(targetGroup,"Teleport to nearest matching target","วาร์ปไปเป้าหมายที่ใกล้ที่สุด",function()local target=A.Targets(cfg.TeleportKind,"All",true)[1];if target then C.Teleport(target)else C.Report.Jobs.Teleport="No loaded instance of the selected item"end end)
        targetGroup:CreateLabel({Text=t("Egg names are grouped by type. Not loaded = no current target.","แสดงชื่อไข่แยกตามชนิด หากยังไม่โหลดจะยังไม่มีเป้าหมายวาร์ป")})
        travelWidget=targetGroup:CreateLabel({Text=t("Select an item to teleport through obstacles.","เลือกสิ่งของเพื่อวาร์ปผ่านสิ่งกีดขวาง")})
        local destinations=group(travel,"Destinations","สถานที่","Right")
        for _,dest in ipairs({{"Home","Home","บ้าน"},{"Plot","My plot","ฐานของฉัน"},{"Surface","Surface","พื้นผิว"},{"DigSite","Dig site","จุดขุด"},{"Sell","Sell area","จุดขาย"}})do
            local mode=dest[1];button(destinations,dest[2],dest[3],function()C.Surface(mode)end)
        end
        local shop=tab("Shop","ร้านค้า","shopping-cart");local shovels=group(shop,"Shovels","พลั่ว")
        view.Picker(shovels,"Shovels",t("Shovel / price / ownership","พลั่ว ราคา และสถานะ"),function(id)cfg.Shovel=id end)
        toggle(shovels,"BuyShovel","Auto Buy / Equip Shovel","ซื้อและใช้พลั่วอัตโนมัติ")
        button(shovels,"Buy / Equip Selected Shovel","ซื้อหรือใช้พลั่วที่เลือก",function()C.Run("BuyShovel",function(valid)C.BuyShovel(valid,cfg.Shovel)end,true)end)
        shovelWidget=shovels:CreateLabel({Text=t("Purchase results appear here.","ผลการซื้อจะแสดงตรงนี้")})
        local gear=group(shop,"Drills and gear","สว่านและอุปกรณ์","Right")
        view.Picker(gear,"Gear",t("Gear / live price / stock","อุปกรณ์ ราคาปัจจุบัน และสต็อก"),function(id)cfg.Gear=id end)
        toggle(gear,"BuyGear","Auto Buy / Equip Selected Gear","ซื้อและใช้อุปกรณ์ที่เลือกอัตโนมัติ")
        slider(gear,"GearLimit","Keep gear quantity","จำนวนอุปกรณ์ที่ซื้อเก็บ",1,25)
        button(gear,"Buy / Equip Selected Gear","ซื้อหรือใช้อุปกรณ์ที่เลือก",function()C.Run("BuyGear",function(valid)C.BuyGear(valid,cfg.Gear)end,true)end)
        button(gear,"Refresh prices and stock","อัปเดตราคาและสต็อก",C.RefreshShop)
        gearWidget=gear:CreateLabel({Text=t("Purchase results appear here.","ผลการซื้อจะแสดงตรงนี้")})
        controls.Reserve=shovels:CreateInput({Name=t("Cash reserve","เงินสดสำรอง"),CurrentValue=tostring(cfg.Reserve),Callback=function(v)cfg.Reserve=P.Number(v,cfg.Reserve)end})
        local inv=tab("Inventory","กระเป๋า","backpack");local sell=group(inv,"Selling","การขาย")
        toggle(sell,"SellLoot","Auto Sell Loot","ขายของขุดอัตโนมัติ");toggle(sell,"SellEggs","Auto Sell Spare Eggs","ขายไข่สำรองอัตโนมัติ");toggle(sell,"SellPets","Auto Sell Stored Pets","ขายสัตว์ในกระเป๋าอัตโนมัติ")
        sell:CreateParagraph({Name=t("Stored pet sale","ขายสัตว์ในกระเป๋า"),Content=t("Sells unequipped pets. Placed pets stay. Uses the game's current sale quote.","ขายสัตว์ที่ไม่ได้ใช้งาน เก็บตัวที่วางในฐานไว้ ใช้ใบเสนอราคาล่าสุดจากเกม")})
        toggle(sell,"EquipPets","Auto Equip Best Pets","ใช้สัตว์ที่ดีที่สุดอัตโนมัติ")
        sellWidget=sell:CreateLabel({Text=t("Sale results appear here.","ผลการขายจะแสดงตรงนี้")})
        local buffs=group(inv,"Potions and gear use","ยาและการใช้อุปกรณ์","Right")
        view.Picker(buffs,"Potions",t("Potion","ยา"),function(id)cfg.Potion=id end)
        toggle(buffs,"Potions","Auto Use Potion When Expired","ใช้ยาเมื่อบัฟหมดอัตโนมัติ")
        view.Picker(buffs,"UseGear",t("Placement gear","อุปกรณ์ที่ต้องการวาง"),function(id)cfg.UseGearId=id end)
        toggle(buffs,"UseGear","Auto Place Owned Gear","วางอุปกรณ์ที่มีอัตโนมัติ");toggle(buffs,"Pumpkin","Auto Fire Pumpkin Launcher","ยิง Pumpkin Launcher อัตโนมัติ")
        local upgrade=tab("Upgrades","อัปเกรด","trending-up");local levels=group(upgrade,"Cash upgrades","อัปเกรดด้วยเงินสด")
        toggle(levels,"TrainingUpgrade","Auto Upgrade Training","อัปเกรดการฝึกอัตโนมัติ");toggle(levels,"PlotUpgrade","Auto Upgrade Plot","อัปเกรดฐานอัตโนมัติ");toggle(levels,"HoleLuck","Auto Upgrade Hatch Luck","อัปเกรดโชคฟักไข่อัตโนมัติ");toggle(levels,"AnimalIncome","Auto Upgrade Pet Income","อัปเกรดรายได้สัตว์อัตโนมัติ")
        local rebirth=group(upgrade,"Rebirth","รีเบิร์ท","Right")
        rebirth:CreateLabel({Text=t("Rebirth resets progression specified by the game.","รีเบิร์ทจะรีเซ็ตความคืบหน้าตามระบบเกม")})
        slider(rebirth,"RebirthLimit","Stop at rebirth count","หยุดเมื่อจำนวนรีเบิร์ทถึง",1,100)
        toggle(rebirth,"Rebirth","Auto Rebirth","รีเบิร์ทอัตโนมัติ")
        local events=tab("Events & Rewards","อีเวนต์และรางวัล","gift");local seasonal=group(events,"Active events","อีเวนต์ที่กำลังเกิด")
        toggle(seasonal,"EventEggs","Auto Collect Event Eggs / Pumpkin Drops","วาร์ปเก็บไข่และของอีเวนต์ฟักทอง")
        toggle(seasonal,"EventWaves","Auto Claim Cash Tsunami Waves","รับรางวัลคลื่น Cash Tsunami")
        local rewards=group(events,"Free rewards","รางวัลฟรี","Right")
        toggle(rewards,"Daily","Auto Claim Daily Rewards","รับรางวัลรายวันอัตโนมัติ");toggle(rewards,"Offline","Auto Claim Offline Earnings","รับรายได้ออฟไลน์อัตโนมัติ");toggle(rewards,"PetIndex","Auto Claim Pet Index Rewards","รับรางวัลสมุดสัตว์อัตโนมัติ")
        local settings=tab("Settings","ตั้งค่า","settings");local settingsGroup=group(settings,"Settings profile","บันทึกการตั้งค่า")
        button(settingsGroup,"Save settings","บันทึกการตั้งค่า",saveSettings);button(settingsGroup,"Load settings","โหลดการตั้งค่า",loadSettings)
        settingsGroup:CreateLabel({Text=t("Saved settings load on the next run for this account and map.","การตั้งค่าที่บันทึกจะโหลดเมื่อรันครั้งถัดไปในบัญชีและแมพนี้")})
        settingsWidget=settingsGroup:CreateLabel({Text=settingsStatus})
        local diagnostics=group(settings,"Live status","สถานะการทำงาน","Right")
        statusWidget=diagnostics:CreateLabel({Text=t("Ready — automation off by default","พร้อมใช้งาน — ออโต้เริ่มต้นปิด")})
        detailsWidget=diagnostics:CreateParagraph({Name="DEVIL HUB TEST",Content=""})
        button(diagnostics,"Stop all automation","หยุดออโต้ทั้งหมด",function()C.StopAll();for _,key in ipairs(P.Jobs)do if controls[key]then controls[key]:Set(false,true)end end end)
        button(diagnostics,"Copy diagnostic report","คัดลอกรายงานทดสอบ",function()
            local report={Version=app.Version,PlaceId=game.PlaceId,GameId=game.GameId,Report=C.Report,Capabilities={Loadstring=type(loadstring)=="function",Settings=type(writefile)=="function",CustomAsset=type(getcustomasset or getsynasset)=="function"}}
            local bytes=A.Http:JSONEncode(report);if type(setclipboard)=="function"then setclipboard(bytes)elseif type(writefile)=="function"then writefile("DevilV4Report.json",bytes)else print(bytes)end;settingsStatus="Report copied / exported"
        end)
        button(diagnostics,"Unload test","ปิดตัวทดสอบ",app.Destroy)
        rebuilding=false;lastRefresh=0
    end
    buildUI()
    local _,owner=languageValue()
    if owner and type(owner.Set)=="function"then
        languageOwner=owner;baseSet=owner.Set
        wrappedSet=function(values)
            local nextLanguage=type(values)=="table"and values.Language
            if not app.Stopped and(nextLanguage=="TH"or nextLanguage=="EN")and nextLanguage~=language then language=nextLanguage;buildUI()end
            return baseSet(values)
        end
        owner.Set=wrappedSet
    end
    scope.DevilV4Starting=nil
    A.Spawn(A.Init)
    if type(readfile)=="function"and type(isfile)=="function"and isfile(profile)then
        local good,err=pcall(loadSettings);if not good then settingsStatus=tostring(err)end
    end
    local function refresh()
        local options=A.TeleportOptions(cfg.TeleportKind)
        for _,item in ipairs(options)do
            item.Label=item.Name
            item.Detail=item.Count>0 and(tostring(item.Count)..t(" found"," จุด").."\n"..math.floor(item.Distance).." studs")or t("Not loaded","ยังไม่โหลด")
        end
        view.Refresh("Targets",options,cfg.TeleportChoice)
        travelWidget:Set(C.Report.Jobs.Teleport or C.Report.Jobs.Travel or t("Select an item to teleport through obstacles.","เลือกสิ่งของเพื่อวาร์ปผ่านสิ่งกีดขวาง"),true)
        local saleLines={};for _,key in ipairs({"SellLoot","SellEggs","SellPets"})do if cfg[key]then saleLines[#saleLines+1]=(jobNames[key]or key)..": "..(C.Report.Jobs[key]or"Starting")end end
        sellWidget:Set(table.concat(saleLines,"\n"),true)
        shovelWidget:Set(C.Report.Jobs.BuyShovel or C.Report.Jobs.ShopRefresh or t("Select a shovel to buy or equip.","เลือกพลั่วเพื่อซื้อหรือใช้งาน"),true)
        gearWidget:Set(C.Report.Jobs.BuyGear or C.Report.Jobs.ShopRefresh or t("Select gear to buy or equip.","เลือกอุปกรณ์เพื่อซื้อหรือใช้งาน"),true)
        local shovelOptions={{Id="Best affordable",Name=t("Best affordable","ดีที่สุดที่ซื้อไหว"),Detail=t("Automatic choice","เลือกอัตโนมัติ")}}
        local gearOptions={};local catalog=A.Modules.ShovelCatalog;local sh=A.Snapshots.Shovels or{};local gs=A.Snapshots.Gear or{}
        for _,item in ipairs(catalog and catalog.Tiers or{})do
            if not item.WorldOnly and not item.RobuxOnly then
                local drill=item.Kind=="Drill";local snap=drill and gs or sh;local owned=snap.Owned and snap.Owned[item.Id]
                local equipped=drill and A.Attr("ActiveDrillId")==item.Id or not drill and catalog.tier(A.Attr("ShovelLevel",1)).Id==item.Id
                local state=equipped and t("Equipped","กำลังใช้")or owned and t("Owned","ซื้อแล้ว")or t("Not owned","ยังไม่ซื้อ")
                local info={Id=item.Id,Name=item.Name,Detail="$"..P.Money(item.Cost).."\n"..state}
                table.insert(drill and gearOptions or shovelOptions,info)
            end
        end
        local gc=A.Modules.GearConfig
        for _,id in ipairs(gc and gc.Order or{})do
            local item=gc.Types[id];local stock=gs.Stock and gs.Stock.Remaining and gs.Stock.Remaining[id]
            local price=gs.Prices and gs.Prices[id]
            gearOptions[#gearOptions+1]={Id=id,Name=item.Name,Detail=(price and"$"..P.Money(price)or t("Refresh price","อัปเดตราคา")).."\n"..t("Stock: ","สต็อก: ")..tostring(stock or"?").." | "..t("Owned: ","มี: ")..tostring(gs.Counts and gs.Counts[id]or 0)}
        end
        view.Refresh("Shovels",shovelOptions,cfg.Shovel);view.Refresh("Gear",gearOptions,cfg.Gear)
        local use={};for _,item in ipairs(gearOptions)do local def=gc and gc.Types[item.Id];if def and def.Kind~="Launcher"then use[#use+1]=item end end
        view.Refresh("UseGear",use,cfg.UseGearId)
        local potionOptions={};local pc=A.Modules.PotionConfig
        for _,id in ipairs(pc and pc.Order or{})do potionOptions[#potionOptions+1]={Id=id,Kind="Potion",Name=pc.Types[id].Name or id,Detail=A.Attr("Potion"..id.."Until",0)>A.ServerTime()and t("Active","กำลังทำงาน")or""}end
        view.Refresh("Potions",potionOptions,cfg.Potion)
        local active=0;local lines={}
        for _,key in ipairs(P.Jobs)do if cfg[key]then active+=1;lines[#lines+1]=(jobNames[key]or key)..": "..(C.Report.Jobs[key]or t("Starting","กำลังเริ่ม"))end end
        statusWidget:Set(string.format("%s %d | %s %d | %s %d",t("Active","เปิด"),active,t("Requests","คำขอ"),C.Report.Requests,t("Confirmed","ยืนยัน"),C.Report.Confirmed),true)
        detailsWidget:Set(table.concat(lines,"\n"),true);settingsWidget:Set(settingsStatus,true)
    end
    A.Spawn(function()
        while not app.Stopped do
            local good,err=pcall(C.Tick);if not good then C.Report.Errors.Tick=tostring(err);C.StopMining()end
            if os.clock()-lastRefresh>=2 then lastRefresh=os.clock();local worked,detail=pcall(refresh);if not worked then C.Report.Errors.Display=tostring(detail)end end
            if view then pcall(view.VisibleModels)end
            A.Wait(.025)
        end
    end)
end,debug.traceback)
if not ok then app.Destroy();error("DEVIL HUB test startup: "..tostring(problem),0)end
return app
