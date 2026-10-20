local passed=0
local function check(value,message)assert(value,message);passed+=1 end
local P=(function()
-- POLICY
end)()
local makeCore=(function()
-- CORE
end)()
local now=0
local tasks={}
local function spawn(fn)local co=coroutine.create(fn);tasks[#tasks+1]=co end
local function pump()
    local batch=tasks;tasks={}
    for _,co in ipairs(batch)do
        local good,err=coroutine.resume(co);assert(good,err)
        if coroutine.status(co)~="dead"then tasks[#tasks+1]=co end
    end
end
local function drain()for _=1,12 do if #tasks==0 then return end;pump()end;assert(#tasks==0,"Unexpected hanging test task")end
local function context()
    local A={Calls={},Sent={},Modules={},Snapshots={},Player={Character={}},Pause=false,Next={},Attrs={},BlockedValue=false}
    A.Clock=function()return now end;A.ServerTime=A.Clock;A.Spawn=spawn;A.Wait=function()coroutine.yield()end
    A.Attr=function(key,default)local v=A.Attrs[key];if v==nil then return default end;return v end
    A.Blocked=function()return A.BlockedValue end
    A.Invoke=function(remote,...)
        A.Calls[#A.Calls+1]={Remote=remote,Args=table.pack(...)}
        if A.Pause then coroutine.yield()end
        local value=A.Next[remote];if type(value)=="function"then return value(...)end;return value
    end
    A.Fire=function(remote,...)A.Sent[#A.Sent+1]={Remote=remote,Args=table.pack(...)};return true end
    A.Character=function()return {},{},{}end
    A.Aim=function()return "origin","direction","Down",nil end
    A.Targets=function()return{}end;A.Tools=function()return{}end
    A.TaggedOwn=function()return "owned-sign"end
    A.ValidFind=function()return false end
    A.Destroy=function()A.Destroyed=true end
    return A
end
local function shovelCatalog()
    return{Tiers={{Id="Basic",Multiplier=1,Cost=0},{Id="Grey",Multiplier=2,Cost=100},{Id="Blue",Multiplier=4,Cost=1000},{Id="Paid",Multiplier=999,Cost=1,RobuxOnly=true},{Id="World",Multiplier=9999,Cost=1,WorldOnly=true},{Id="Drill",Kind="Drill",Multiplier=100,Cost=1}},tier=function()return{Id="Basic"}end}
end
for _,key in ipairs(P.Jobs)do check(P.Defaults()[key]==false,"Auto job must start off: "..key)end
check(P.Settings({AimRate=1/0}).AimRate==20,"Reject infinite aim rate")
check(P.Settings({AimRate=999,GearLimit=-1}).AimRate==40,"Cap aim frequency")
check(P.Settings({AimRate=999,GearLimit=-1}).GearLimit==1,"Bound quantity")
check(P.Settings({Dig="yes"}).Dig==false,"Reject invalid setting types")
check(P.Affordable(100,200,100),"Reserve exact boundary")
check(not P.Affordable(101,200,100),"Preserve reserve")
check(not P.Affordable(nil,200,0),"Reject missing price")
check(P.Quote({StoredPets={Count=1,Quote="server-token"}},"StoredPets")=="server-token","Preserve opaque sale quote")
check(P.Quote({StoredPets={Count=0,Quote=1}},"StoredPets")==nil,"Skip empty sale")
check(#P.ReadyEggs({Eggs={{Id="ready",ReadyAt=9},{Id="growing",ReadyAt=11},{Id="busy",ReadyAt=8,Hatching=true}}},10)==1,"Only hatch ready eggs")
check(not P.DropEligible({Index=1,LandTime=20},{},19,30),"Do not collect airborne drop")
check(P.DropEligible({Index=1,LandTime=20},{},20,30),"Collect landed drop")
check(not P.DropEligible({Index=1,LandTime=20},{[1]=true},20,30),"Skip claimed drop")
check(not P.DropEligible({Index=1,LandTime=20},{},30,30),"Skip expired drop")
do
    local catalog=shovelCatalog();local item,action=P.ShopChoice(catalog.Tiers,{Owned={Basic=true}},"Best affordable",500,0,"Basic")
    check(item.Id=="Grey"and action=="Buy","Select strongest affordable cash shovel")
    item,action=P.ShopChoice(catalog.Tiers,{Owned={Basic=true,Grey=true}},"Best affordable",0,0,"Basic")
    check(item.Id=="Grey"and action=="Equip","Equip owned upgrades without paying again")
    check(P.ShopChoice(catalog.Tiers,{Owned={Basic=true}},"Paid",5000,0,"Basic")==nil,"No paid item automation")
end
do
    local A=context();local C=makeCore(A,P);now=1
    C.Tick();drain();check(#A.Calls==0 and #A.Sent==0,"Loading sends no automation requests")
    C.Set("Dig",true)
    for _=1,100 do now+=.025;C.Tick();drain()end
    check(A.Sent[1].Args[1]=="Start","Begin native continuous mining")
    check(#A.Sent<=51 and #A.Sent>=35,"Bound mining aim packets")
    check(A.Sent[2].Args[1]=="Aim","Update rather than restart mining")
    C.Set("Dig",false);check(A.Sent[#A.Sent].Args[1]=="Stop","Stop immediately on toggle")
    local count=#A.Sent;C.Tick();drain();check(#A.Sent==count,"No extra packets after stop")
    C.Set("Dig",true);A.BlockedValue=true;C.Tick();check(#A.Sent==count,"Pause during text input / game menu")
    A.BlockedValue=false;A.Attrs.AfkTraining=true;C.Tick();check(#A.Sent==count,"Pause while native training is active")
    C.Destroy();check(A.Destroyed and not C.Alive,"Unload releases adapter")
end
do
    local A=context();local C=makeCore(A,P);A.Modules.ShovelCatalog=shovelCatalog();A.Next.Shovels={Owned={Basic=true}};A.Attrs.Cash=500
    C.Run("BuyShovel",function(valid)C.BuyShovel(valid)end,true);drain()
    check(#A.Calls==2 and A.Calls[2].Args[1]=="Buy"and A.Calls[2].Args[2]=="Grey","Real shovel Buy signature")
end
do
    local A=context();local C=makeCore(A,P);A.Modules.ShovelCatalog=shovelCatalog();A.Next.Shovels={Owned={Basic=true}};A.Attrs.Cash=500;A.Pause=true
    C.Set("BuyShovel",true);C.Tick();pump();check(#A.Calls==1,"Snapshot started")
    C.Set("BuyShovel",false);C.Set("BuyShovel",true);A.Pause=false;drain()
    check(#A.Calls==1,"Toggle off/on cancels stale snapshot continuation")
end
do
    local A=context();local C=makeCore(A,P);A.Next.Sell={Total=400,StoredPets={Count=2,Quote="fresh-quote"}};C.Config.SellPets=true
    C.Run("SellPets",C.Handlers.SellPets);drain()
    check(A.Calls[2].Args[1]=="SellStoredPets"and A.Calls[2].Args[2]=="fresh-quote","Stored pet sale uses fresh quote")
    A.Calls={};A.Pause=true;C.Run("SellPets",C.Handlers.SellPets);pump();C.StopAll();A.Pause=false;drain()
    check(#A.Calls==1,"Stop all cancels destructive continuation after quote")
end
do
    local A=context();local C=makeCore(A,P);A.Next.Eggs={Eggs={{Id="a",ReadyAt=0},{Id="b",ReadyAt=0}}};C.Config.Hatch=true
    C.Run("Hatch",C.Handlers.Hatch);drain();local first=A.Calls[2].Args[2]
    C.Run("Hatch",C.Handlers.Hatch);drain();check(A.Calls[4].Args[2]~=first,"A rejected egg does not starve other ready eggs")
end
do
    local A=context();local C=makeCore(A,P);C.Config.Daily=true;A.Next.DailyState={CanClaim=false,TotalClaims=2}
    C.Run("Daily",C.Handlers.Daily);drain();check(#A.Calls==1,"No daily claim before eligible")
    A.Next.DailyState={CanClaim=true,TotalClaims=2};C.Run("Daily",C.Handlers.Daily);drain()
    check(A.Calls[3].Remote=="DailyClaim"and A.Calls[3].Args[1]==2,"Daily claim forwards current count")
end
do
    local A=context();local C=makeCore(A,P);C.Config.PlotUpgrade=true;A.Attrs.Cash=1000
    A.Modules.PlotUpgradeConfig={level=function()return 4 end,offer=function()return{CashCost=500}end,SignTag="PlotSign"}
    C.Run("PlotUpgrade",C.Handlers.PlotUpgrade);drain()
    check(A.Calls[1].Args[1]=="owned-sign"and A.Calls[1].Args[2]=="Cash"and A.Calls[1].Args[3]==4,"Upgrade contract uses owned sign, Cash, current level")
    A.Next.Plot={Code="NotEnoughCash"};A.Calls={};C.Run("PlotUpgrade",C.Handlers.PlotUpgrade);drain()
    check(#A.Calls==1,"No Robux fallback after cash rejection")
end
do
    local A=context();local C=makeCore(A,P);C.Config.Rebirth=true;A.Next.Rebirth={Eligible=true,Count=1};C.Config.RebirthLimit=1
    C.Run("Rebirth",C.Handlers.Rebirth);drain();check(#A.Calls==1,"Respect rebirth stop count")
    A.Next.Rebirth={Eligible=false,Count=0};A.Calls={};C.Run("Rebirth",C.Handlers.Rebirth);drain();check(#A.Calls==1,"Respect rebirth eligibility")
end
do
    local A=context();local C=makeCore(A,P);A.Attrs.Cash=1000;C.Config.Gear="TNT1";C.Config.BuyGear=true
    A.Modules.GearConfig={Types={TNT1={Cost=100,Kind="TNT"}}}
    A.Next.Gear={Counts={},Prices={TNT1=120},Stock={Key="rotation-5",Remaining={TNT1=3}}}
    C.Run("BuyGear",C.Handlers.BuyGear);drain()
    check(A.Calls[2].Args[1]=="Buy"and A.Calls[2].Args[2]=="TNT1"and A.Calls[2].Args[3]==120 and A.Calls[2].Args[4]=="rotation-5","Gear purchase uses live price and stock key")
    A.Next.Gear.Counts.TNT1=1;A.Calls={};C.Run("BuyGear",C.Handlers.BuyGear);drain();check(#A.Calls==1,"Respect owned gear quantity")
    A.Next.Gear.Counts.TNT1=nil;A.Next.Gear.Stock.Remaining.TNT1=0;A.Calls={};C.Run("BuyGear",C.Handlers.BuyGear);drain();check(#A.Calls==1,"Skip out of stock gear")
    A.Next.Gear.Stock.Remaining.TNT1=1;C.Config.Reserve=950;A.Calls={};C.Run("BuyGear",C.Handlers.BuyGear);drain();check(#A.Calls==1,"Gear preserves cash reserve")
end
do
    local A=context();local C=makeCore(A,P);C.Config.SellLoot=true;A.Next.Sell=function()error("Temporary error")end
    C.Run("SellLoot",C.Handlers.SellLoot);drain();check(C.Jobs.SellLoot==nil,"Release job after exception")
    A.Next.Sell={Total=1};C.Run("SellLoot",C.Handlers.SellLoot);drain();check(#A.Calls==3,"Retry on later cycle after failure")
end
do
    local A=context();local C=makeCore(A,P);C.Config.Plant=true
    local tool={GetAttribute=function()return"Egg"end};A.Tools=function()return{tool}end
    local position={};A.PlantPosition=function()return position end
    local root={Position=setmetatable({},{__sub=function()return{Magnitude=100}end})}
    local humanoid={EquipTool=function()tool.Parent=A.Player.Character end}
    A.Character=function()return A.Player.Character,humanoid,root end
    local movement=0;A.Move=function(_,valid)movement+=1;return valid(),"Arrived"end
    C.Run("Plant",C.Handlers.Plant);pump()
    check(movement==1,"Auto Plant returns to own plot when far away")
    C.StopAll();drain();check(#A.Sent==0,"Stopping during plant travel/equip prevents planting")
end
do
    local A=context();local C=makeCore(A,P);C.Config.FarmFinds=true;C.Config.Train=true
    local searches=0;A.Targets=function()searches+=1;return{}end
    C.Run("FarmFinds",C.Handlers.FarmFinds);drain();check(searches==0,"Find farming does not pull character away from exclusive training")
    C.Config.Rotate=true;A.Attrs.AfkTraining=true
    C.Run("FarmFinds",C.Handlers.FarmFinds);drain();check(searches==0,"Find farming waits until training rotation actually ends")
end
print("PASS core/policy behavior checks:",passed)
