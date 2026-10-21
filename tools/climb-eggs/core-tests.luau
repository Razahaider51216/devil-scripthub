local P=(function()
-- CLIMB_PLANNER
end)()
local make=(function()
-- CLIMB_CORE
end)()
local checks=0
local function check(value,message) checks+=1;assert(value,message) end
local cfg=P.Defaults()
local function egg(rarity,distance,mutation,variant)
    return {enabled=true,rarity=rarity,distance=distance,mutation=mutation,variant=variant}
end
local epic=egg("Epic",2);local mythic=egg("Mythic",400)
check(P.Choose({epic,mythic,egg("Royal",1)},cfg)==mythic,"highest selected level")
cfg.Tiers={Epic=true};check(P.Choose({mythic,epic},cfg)==epic,"unselected levels excluded")
cfg.Tiers={};check(P.Choose({mythic,epic},cfg)==nil,"empty selection waits")
cfg.Tiers={Epic=true,Mythic=true};cfg.Variants={Golden=true}
check(not P.Match(epic,cfg),"strict variant filter")
epic.variant="Golden";check(P.Match(epic,cfg),"selected variant matches")
cfg.Variants={All=true};cfg.Mutations={Candy=true}
check(not P.Match(epic,cfg),"strict mutation filter")
epic.mutation="Candy";check(P.Match(epic,cfg),"selected mutation")
cfg.Mutations={All=true};cfg.AutoEvent=true
check(P.Choose({mythic,epic},cfg,"Candy")==epic,"event priority preserves selected levels")
cfg.Tiers={Mythic=true};check(P.Choose({mythic,epic},cfg,"Candy")==mythic,"event cannot override rarity selection")
check(P.Validate({ReserveCash=-10}).ReserveCash==0,"reserve minimum")
check(P.Validate({Speed=300}).Speed==nil,"obsolete saved flight speed ignored")
check(P.Validate({ReserveCash=0/0})==nil,"reject NaN")
check(P.Validate({Farm="yes"})==nil,"reject malformed settings toggle")
check(P.Validate({Tiers={Epic=true},Farm=true}).Farm==true,"saved enabled automation")
local function pet(name,scale,variant,mutation,extra)
    local item={Handler="Animal",Name=name,CustomData={AssetScale=scale or 1,Variant=variant or "Normal",Mutation=mutation}}
    for k,v in pairs(extra or {}) do item[k]=v end;return item
end
local inv={a=pet("Chicken",1),b=pet("Chicken",2),c=pet("Chicken",3),best=pet("Chicken",8),
    locked=pet("Chicken",1,nil,nil,{Locked=true}),favorite=pet("Chicken",1,nil,nil,{Favorite=true}),
    equipped=pet("Chicken",1),other=pet("Horse",1),gold=pet("Chicken",1,"Golden"),
    candy=pet("Chicken",1,"Normal","Candy"),egg={Handler="Egg",Name="Chicken"}}
local function rarity(name)return name=="Chicken" and "Common" or "Epic" end
local function score(item)return item.CustomData.AssetScale^3 end
cfg=P.Defaults();cfg.SellTiers={Common=true}
local sold=P.SellCandidates(inv,{equipped=true},cfg,rarity,score)
local ids={};for _,entry in ipairs(sold) do ids[entry.id]=true end
check(not ids.best and not ids.locked and not ids.favorite and not ids.equipped and not ids.other and not ids.egg,"sale protection + filters")
check(ids.a and ids.b and ids.c,"eligible sale candidates")
local fusion=P.FuseCandidates(inv,{equipped=true},cfg,rarity,score,{})
check(fusion and fusion[1].id=="a" and fusion[2].id=="b" and fusion[3].id=="c","same species + variant + mutation")
check(P.FuseCandidates({a=inv.a,b=inv.b,c=inv.c},{},cfg,rarity,score,{c=true})==nil,"exclude reserved materials")
-- Simulated runtime with independent server state and real public request signatures.
game={PlaceId=85738654635245}
local now=0
task={wait=function(dt) now+=dt or .01 end,spawn=function(fn)fn()end}
local attrs={}
local player={UserId=123,GetAttribute=function(_,key)return attrs[key]end,FindFirstChild=function()return nil end}
local signal={callbacks={}}
function signal:Connect(fn)
    local holder={fn=fn};table.insert(self.callbacks,holder)
    return {Disconnect=function()holder.fn=nil end}
end
function signal:Fire(...)for _,holder in ipairs(self.callbacks) do if holder.fn then holder.fn(...)end end end
local native={Data={Inventory=inv,EquippedAnimals={equipped=true},PlacedEggs={},Cash=1000000,Rebirths=0,Speed=5000,BaseLevel=0,StaminaLevel=1,TreadmillLevel=0,Fuse={Slots={}}}}
local bonusRequests=0
local treadmill={OnTreadmill=true,TreadmillSession="session-1",LoadedAnimation={},DisableActivation=false,Signals={ShowMultiplierButton=signal},
    ClaimMultiplier=function(_,id)check(id=="bonus-1","bonus id from game");bonusRequests+=1 end,
    DeactivateTreadmill=function(self)self.OnTreadmill=false end}
local requests={}
local services={}
local function register(service,method,handler)
    services[service]=services[service] or {}
    services[service][method]={InvokeServer=function(_,...)table.insert(requests,{service=service,method=method,args=table.pack(...)});return handler(...)end}
end
register("AnimalSellService","Request",function(action,id)
    check(action=="Sell" and inv[id] and inv[id].Handler=="Animal","sale exact ID")
    return {Status=false,Reason="Please wait a moment."}
end)
register("RebirthService","Request",function(skip)check(skip==false,"normal rebirth, no paid skip");return {Status=true}end)
register("TrailsService","GetTrails",function()return {Owned={["Gray Trail"]=true},Equipped="Gray Trail"}end)
register("TrailsService","SelectTrail",function(name)check(name=="Blue Trail","highest affordable trail");return {Status=true,Result="Purchased"}end)
register("StaminaUpgradeService","Purchase",function(level)check(level==1,"stamina current level");return {Status=true}end)
register("EggSpawnService","ClaimEgg",function()
    attrs.CarryingEgg=nil;native.Data.Inventory.newEgg={Handler="Egg",Name="Chicken"};return {Status=true,EggName="Chicken"}
end)
local deps={Manual=true,Clock=function()return now end,Player=player,Players={},RS={},Run={},Http={},World={FindFirstChild=function()return nil end,GetServerTimeNow=function()return now end},
    Controllers={DataController=native,TreadmillController=treadmill,BaseController={Base=nil},ZoneController={Zone="Lobby"},FallController={IsFalling=false}},
    Modules={Egg={Eggs={Chicken={Rarity="Common"},Horse={Rarity="Epic"}}},Rebirth={GetRequirements=function()return {Speed=10000}end},
        Trails={Trails={["Gray Trail"]={Price=100},["Blue Trail"]={Price=5000},["Royal Trail"]={Price=1e12}}},
        Stamina={Levels={{Price=0},{Price=800}}}},Services=services}
cfg=P.Defaults();cfg.AutoBonus=true;cfg.KeepBest=true;cfg.SellTiers={Common=true}
local c=make(cfg,nil,P,deps)
signal:Fire("bonus-1");signal:Fire("bonus-1");c.JobsStep();check(bonusRequests==1,"bonus id consumed once")
cfg.AutoSell=true;cfg.AutoRebirth=true;cfg.AutoTrails=true;cfg.AutoStamina=true
c.JobsStep()
check(c.Report.jobs.Sell.confirmed==0 and c.Report.jobs.Sell.status=="Please wait a moment.","rejected request is not success")
check(not c.Report.jobs.Rebirth or c.Report.jobs.Rebirth.requests==0,"wait until rebirth speed requirement")
check(c.Report.jobs.Trails.confirmed==1,"trail nested configuration")
check(c.Report.jobs.AutoStamina.confirmed==1,"upgrade acknowledged")
native.Data.Speed=10000;now+=6;c.JobsStep()
check(c.Report.jobs.Rebirth.confirmed==1,"eligible normal rebirth")
local callsBefore=#requests;now+=.1;c.JobsStep();check(#requests==callsBefore,"cooldown prevents request bursts")
local vmt={}
local function vec(x,y,z)return setmetatable({X=x,Y=y,Z=z},vmt)end
vmt.__sub=function(a,b)return vec(a.X-b.X,a.Y-b.Y,a.Z-b.Z)end
vmt.__add=function(a,b)return vec(a.X+b.X,a.Y+b.Y,a.Z+b.Z)end
vmt.__mul=function(a,b)return vec(a.X*b,a.Y*b,a.Z*b)end
vmt.__div=function(a,b)return vec(a.X/b,a.Y/b,a.Z/b)end
vmt.__index=function(a,k)if k=="Magnitude" then return math.sqrt(a.X*a.X+a.Y*a.Y+a.Z*a.Z)end end
Vector3={new=vec,zero=vec(0,0,0)}
local cfmt={__mul=function(a,b)a.Rotation=b;return a end}
CFrame={new=function(position)return setmetatable({Position=position,Rotation={}},cfmt)end}
local hum={Health=100,PlatformStand=false,AutoRotate=true}
local currentFrame=CFrame.new(vec(0,0,0));local moves=0
local root=setmetatable({Position=vec(0,0,0),CanCollide=true},{
    __index=function(_,key)if key=="CFrame" then return currentFrame end end,
    __newindex=function(self,key,value)
        if key=="CFrame" then currentFrame=value;rawset(self,"Position",value.Position);moves+=1
        else rawset(self,key,value) end
    end})
player.Character={GetAttribute=function()return nil end,FindFirstChild=function(_,key)return key=="HumanoidRootPart" and root end,FindFirstChildOfClass=function()return hum end}
deps.Controllers.BaseController.TpCFrame={Position=vec(0,0,0)}
local oldRotation=root.CFrame.Rotation
check(c.Travel(vec(10000,8000,20),function()return true end),"real teleport travel reaches far destination")
check(moves==1 and root.Position.X==10000 and root.Position.Y==8000,"one position change, no incremental flight")
check(c.Report.travel.mode=="Teleport" and c.Report.travel.stage=="Arrived","teleport diagnostics")
check(root.CFrame.Rotation==oldRotation and root.CanCollide and hum.AutoRotate,"orientation and physics flags preserved")
check(treadmill.OnTreadmill==false,"native treadmill detached before teleport")
check(not c.Travel(vec(0,0,0),function()return false end) and moves==1,"cancelled target never moves")
hum.PlatformStand=true
check(not c.Travel(vec(0,0,0)) and moves==1,"wait for knockdown before teleport")
hum.PlatformStand=false
local originalWait=task.wait
task.wait=function(dt)originalWait(dt);root.Position=vec(0,0,0)end
check(not c.Travel(vec(10000,8000,20)) and c.Report.travel.stage=="Position not confirmed","position pulled back is reported as failed arrival")
task.wait=originalWait
-- CFrame flight advances in bounded steps and phases only character collisions.
local created,lastMover={},nil
Instance={new=function(kind)
    local item={ClassName=kind}
    function item:Destroy()self.destroyed=true end
    table.insert(created,item)
    if kind=="LinearVelocity"then lastMover=item end
    return item
end}
Enum={ActuatorRelativeTo={World="World"},VelocityConstraintMode={Vector="Vector"}}
root.Parent={}
root.IsA=function(_,kind)return kind=="BasePart"end
local torso={Parent={},CanCollide=false,IsA=root.IsA}
player.Character.GetDescendants=function()return{root,torso}end
cfg.FlySpeed=60
local beforeFlightMoves=moves
local phased=false
task.wait=function(dt)
    originalWait(dt)
    if lastMover and not lastMover.destroyed then
        phased=phased or(root.CanCollide==false and torso.CanCollide==false)
    end
end
check(c.FlyTo(vec(100,300,20),function()return true end),"CFrame flight reaches its destination")
check(moves>beforeFlightMoves and c.Report.travel.maxStepDistance<=3.001 and c.Report.travel.mode=="CFrameFly"and c.Report.travel.waypoints==1,"CFrame displacement respects speed and frame-time limits")
check(phased and root.CanCollide and not torso.CanCollide and not c.Report.travel.noclip,"arrival restores both collidable and originally noncollidable body parts")
check(created[1].destroyed and created[2].destroyed and root.AssemblyLinearVelocity.Magnitude==0,"arrival removes flight constraints and releases character")
check(root.CanCollide and hum.AutoRotate and root.CFrame.Rotation==oldRotation,"flight preserves original orientation and native flags")
task.wait=function(dt)originalWait(dt);root.Position=vec(0,0,0)end
check(not c.FlyTo(vec(1000,300,20),function()return true end)and c.Report.travel.stage=="Blocked or position pulled back","blocked physical flight ends instead of hanging")
check(created[3].destroyed and created[4].destroyed and root.CanCollide and not torso.CanCollide,"server-pulled flight cleans constraints and restores collisions")
cfg.Farm=true
task.wait=function(dt)originalWait(dt);cfg.Farm=false end
check(not c.FlyTo(vec(1000,300,20),function()return cfg.Farm end)and c.Report.travel.stage=="Cancelled","turning off collection cancels flight")
check(created[5].destroyed and created[6].destroyed and root.CanCollide and not torso.CanCollide,"cancelled flight releases physics and collisions")
task.wait=originalWait
cfg.AutoSell=false;cfg.AutoRebirth=false;cfg.AutoTrails=false;cfg.AutoStamina=false;cfg.AutoTrain=false;cfg.Farm=true;cfg.Tiers={Epic=true}
local model={Parent={},GetAttribute=function()return nil end}
local anchor={WorldPosition=vec(50,200,0),IsA=function(_,kind)return kind=="Attachment"end}
local prompt={Parent=anchor,Enabled=true,MaxActivationDistance=8,HoldDuration=.5,
    InputHoldBegin=function()attrs.CarryingEgg="wild-1"end,InputHoldEnd=function()end}
local wild={model=model,prompt=prompt,id="wild-1",name="Horse",rarity="Epic",variant="Normal",enabled=true,distance=200}
c.Scan=function()return {wild}end
local flights=0
c.Travel=function(position,continue)
    check(not continue or continue(),"travel valid target");flights+=1;root.Position=position;return true
end
c.FlyTo=c.Travel
c.FarmStep();check(c.Report.picked==1 and c.Report.phase=="Return","confirmed pickup enters return")
root.Position=vec(0,0,0)
c.FarmStep();check(attrs.CarryingEgg==nil and flights==1,"landing claims inventory without teleporting a held egg")
cfg.Farm=false;c.FarmStep();check(c.Report.stored==1 and c.Report.lost==0,"inventory delta confirms receipt")
attrs.CarryingEgg="lost-egg";deps.Controllers.ZoneController.Zone="Forest"
c.FarmStep();attrs.CarryingEgg=nil;now+=100;c.FarmStep()
check(c.Report.lost==0,"receipt grace starts after carry clears, not before long flight")
now+=7;c.FarmStep()
check(c.Report.lost==1 and c.Report.phase=="Idle","dropped egg clears stale return")
check(c.Report.errors[1]==nil,"runtime has no hidden errors")
-- The native controller can already be claiming on ZoneChanged. Never race
-- that in-flight request with another raw ClaimEgg from our return worker.
local nativeCarry={Claiming=true,IsCarrying=true,ClaimRejected=false}
local nativeAttempts=0
nativeCarry.tryClaimEgg=function(self)nativeAttempts+=1;self.Claiming=true end
deps.Controllers.EggCarryController=nativeCarry;deps.Controllers.ZoneController.Zone="Lobby"
attrs.CarryingEgg="native-claim";cfg.Farm=true;cfg.AutoPlace=false;root.Position=vec(0,0,0)
local claimCore=make(cfg,nil,P,deps)
claimCore.Travel=c.Travel
local rawBefore=#requests
claimCore.FarmStep();claimCore.FarmStep()
check(nativeAttempts==0 and #requests==rawBefore,"native in-flight claim excludes raw and duplicate requests")
check(claimCore.Report.jobs.Store.pending and claimCore.Report.returnState.nativeClaiming,"pending native claim remains visible")
nativeCarry.Claiming=false;now+=3;claimCore.FarmStep();claimCore.FarmStep()
check(nativeAttempts==1 and #requests==rawBefore,"idle native claim uses the game's shared Claiming lock")
attrs.CarryingEgg=nil
native.Data.Inventory.nativeReceipt={Handler="Egg",Name="Horse"}
cfg.Farm=false;claimCore.FarmStep()
check(claimCore.Report.stored==1 and claimCore.Report.lost==0 and claimCore.Report.jobs.Store.confirmed==1,"native claim is confirmed only by an actual inventory receipt")
claimCore.Destroy()
-- A locally stale Lobby flag after a failed return is not permission to claim.
attrs.CarryingEgg="failed-return";cfg.Farm=true;root.Position=vec(100,200,0)
nativeCarry.Claiming=false
claimCore=make(cfg,nil,P,deps);claimCore.Travel=function()return false end
claimCore.FarmStep()
check(nativeAttempts==1 and #requests==rawBefore and not claimCore.Report.returnState.arrived,"failed return cannot initiate either claim path")
claimCore.Destroy();attrs.CarryingEgg=nil;deps.Controllers.EggCarryController=nil
-- The native hold may not activate a hidden prompt after a long teleport.
-- Fallback stays bound to the same selected prompt without executor-specific arguments.
local oldBegin=prompt.InputHoldBegin
local begins,fallbacks=0,0
prompt.InputHoldBegin=function()begins+=1 end
deps.FirePrompt=function(actual,...)
    check(actual==prompt and select("#",...)==0,"fallback uses locked prompt without a fractional activation count")
    fallbacks+=1;attrs.CarryingEgg=wild.id
end
local refusal=setmetatable({callbacks={}},{__index=signal})
services.EggSpawnService.StealRefused={OnClientEvent=refusal}
cfg.Farm=true
local fresh=make(cfg,nil,P,deps);fresh.Scan=c.Scan;fresh.FlyTo=c.FlyTo
local startedAt=now
fresh.FarmStep()
check(begins==1 and fallbacks==1 and fresh.Report.picked==1,"unresponsive InputHoldBegin reaches prompt fallback and confirms real carrying")
check(now-startedAt>=.5 and fresh.Report.interaction.method=="InputHoldBegin + prompt fallback","native hold finishes before a single alternate activation")
check(root.Position.Y==anchor.WorldPosition.Y,"approach no longer teleports above prompt anchor")
fresh.Destroy();attrs.CarryingEgg=nil
-- Surface-aware landing excludes the egg; it stays within actual prompt range.
RaycastParams={new=function()return {}end};Enum.RaycastFilterType={Exclude="Exclude"}
deps.World.Raycast=function(_,origin,direction,params)
    check(params.RespectCanCollide and params.FilterDescendantsInstances[2]==model,"landing ray ignores egg and character")
    if direction.Y>0 then return nil end
    return {Position=vec(origin.X,197,origin.Z)}
end
root.Position=vec(0,0,0)
fresh=make(cfg,nil,P,deps);fresh.Scan=c.Scan;fresh.FlyTo=c.FlyTo;cfg.Farm=true
fresh.FarmStep()
check(math.abs(root.Position.Y-200.1)<.001 and fresh.Report.picked==1,"standing height is based on nearby ground rather than prompt height")
fresh.Destroy();attrs.CarryingEgg=nil;deps.World.Raycast=nil
-- After a failed attempt, another activation at the same egg must not re-teleport.
deps.FirePrompt=function()end
cfg.Farm=true;fresh=make(cfg,nil,P,deps);fresh.Scan=c.Scan;fresh.FlyTo=c.FlyTo
local beforeRetryTravel=flights
fresh.FarmStep();now+=5;fresh.FarmStep()
check(flights==beforeRetryTravel and fresh.Report.picked==0,"stationary retries do not reset position or invent carrying")
check(fresh.Report.interaction.finishedAt and fresh.Report.interaction.fallbackReturnedAt and fresh.Report.interaction.stage=="No pickup confirmation","finished activation is distinguished from a pending fallback")
fresh.Destroy()
-- Prompt automation must not synthesize a global E key over manual input.
local keys={}
prompt.KeyboardKeyCode="E"
deps.VirtualInputManager={SendKeyEvent=function(...)table.insert(keys,{...})end}
cfg.Farm=true;fresh=make(cfg,nil,P,deps);fresh.Scan=c.Scan;fresh.FlyTo=c.FlyTo
fresh.FarmStep()
check(#keys==0 and fresh.Report.picked==0,"failed native activation never injects global keyboard input")
fresh.Destroy();attrs.CarryingEgg=nil;deps.VirtualInputManager=nil;prompt.KeyboardKeyCode=nil
-- A held egg phases out to the Lobby's horizontal position before falling.
attrs.CarryingEgg="jump-egg";cfg.Farm=true
deps.Controllers.ZoneController.Zone="Forest";root.Position=vec(50,500,0)
fresh=make(cfg,nil,P,deps);fresh.Travel=function()error("held eggs must not teleport")end
fresh.FarmStep()
check(fresh.Report.travel.mode=="CFrameReturn"and fresh.Report.travel.stage=="Released above Lobby","carried egg uses the same wall-passing flight to exit the platform")
check(math.abs(root.Position.X)<1 and math.abs(root.Position.Z)<1 and root.Position.Y>500 and root.CanCollide,"release occurs above the actual Lobby spawn with collisions restored")
local afterReleaseMoves=moves
now+=.2;fresh.FarmStep()
check(moves==afterReleaseMoves,"release grace does not repeatedly hover the character")
deps.Controllers.FallController.IsFalling=true;now+=3;fresh.FarmStep()
check(moves==afterReleaseMoves and fresh.Report.travel.stage=="Waiting for game landing","falling is not interrupted by another move or teleport")
fresh.Destroy();attrs.CarryingEgg=nil
deps.Controllers.FallController.IsFalling=false;deps.Controllers.ZoneController.Zone="Lobby"
attrs.CarryingEgg="return-drop";cfg.Farm=true
fresh=make(cfg,nil,P,deps)
task.wait=function(dt)originalWait(dt);attrs.CarryingEgg=nil end
check(not fresh.FlyTo(vec(1000,500,0),function()return cfg.Farm end,"return-drop",true),"losing the locked carried egg cancels return flight")
check(fresh.Report.travel.stage=="Cancelled"and root.CanCollide and not torso.CanCollide,"lost carry restores collision instead of continuing with stale state")
task.wait=originalWait;fresh.Destroy()
-- A refusal is diagnostic evidence, never a successful steal.
deps.FirePrompt=function()fallbacks+=1;refusal:Fire("Steal denied: stand near the egg")end
cfg.Farm=true;fresh=make(cfg,nil,P,deps);fresh.Scan=c.Scan;fresh.FlyTo=c.FlyTo
fresh.FarmStep()
check(fresh.Report.picked==0 and fresh.Report.interaction.stage=="Server refused pickup","refused activation cannot increase pickup count")
check(fresh.Report.lastStealRefusal.message=="Steal denied: stand near the egg","new StealRefused signal retained in report")
local refusalAt=fresh.Report.lastStealRefusal.t
fresh.Destroy();now+=1;refusal:Fire("late")
check(fresh.Report.lastStealRefusal.t==refusalAt,"unload disconnects refusal listener")
-- Cancelling or drifting outside the range during the hold must not fire a fallback.
cfg.Farm=true;fresh=make(cfg,nil,P,deps);fresh.Scan=c.Scan;fresh.FlyTo=c.FlyTo
local fallbackBefore=fallbacks
task.wait=function(dt)originalWait(dt);cfg.Farm=false end
fresh.FarmStep();task.wait=originalWait
check(fallbacks==fallbackBefore and fresh.Report.picked==0 and fresh.Report.interaction.stage=="Cancelled","stop while holding releases without activation")
fresh.Destroy();deps.FirePrompt=nil;prompt.InputHoldBegin=oldBegin;cfg.Farm=false
-- Partial deposits must resume their own recipe rather than getting stuck or
-- consuming a player's different manually selected animal.
cfg.AutoFuse=true;cfg.FuseTiers={Common=true};cfg.KeepBest=true
deps.Modules.Fuse={
    GetStatus=function(state,time)return state.FinishAt and (state.FinishAt<=time and "Ready" or "Running") or "Filling"end,
    GetPrice=function()return 100 end,
    GetResult=function(state)return state.Slots["1"] and state.Slots["2"] and state.Slots["3"] end,
}
local rejectOnce=true;local starts=0
register("FuseService","SetSlot",function(slot,id)
    if slot==2 and rejectOnce then rejectOnce=false;return {Status=false,Reason="Please wait a moment."} end
    native.Data.Fuse.Slots[tostring(slot)]=id;return {Status=true}
end)
register("FuseService","Start",function()starts+=1;native.Data.Fuse.FinishAt=now+5;return {Status=true}end)
register("FuseService","Collect",function()native.Data.Fuse={Slots={}};cfg.AutoFuse=false;return {Status=true}end)
now+=3;c.JobsStep();check(native.Data.Fuse.Slots["1"]=="a" and not native.Data.Fuse.Slots["2"],"partial deposit acknowledged")
now+=3;c.JobsStep();check(native.Data.Fuse.Slots["2"]=="b","resume slot 2 after rejection")
now+=3;c.JobsStep();check(native.Data.Fuse.Slots["3"]=="c","resume slot 3")
now+=3;c.JobsStep();check(starts==1 and native.Data.Fuse.FinishAt,"start only fully replicated recipe")
now+=1;c.JobsStep();check(starts==1,"running recipe does not restart")
now+=6;c.JobsStep();check(not cfg.AutoFuse and next(native.Data.Fuse.Slots)==nil,"collect finished mutation")
local delayed
register("DelayedService","Request",function()return {Status=true}end)
task.spawn=function(fn)delayed=fn end
local _,pending=c.Call("DelayedService","Request",{},"Delayed")
check(pending=="Request pending; waiting for server","bounded wait for hanging RPC")
local before=#requests;local _,busy=c.Call("DelayedService","Request",{},"Delayed")
check(busy=="Busy" and #requests==before,"no duplicate while old request is still pending")
delayed();check(c.Report.jobs.Delayed.pending==false and c.Report.jobs.Delayed.confirmed==1,"late acknowledgement reported")
task.spawn=function(fn)fn()end
c.Destroy();signal:Fire("bonus-1");check(bonusRequests==1,"unload disconnects bonus listener")
check(treadmill.DisableActivation==false,"restore native activation setting")
print("PASS Climb egg planner + runtime:",checks,"checks")
