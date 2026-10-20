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
    local A=context();local C=makeCore(A,P);A.Next.Sell={Items={},Total=400,StoredPets={Count=2,Quote="fresh-quote"}};C.Config.SellPets=true
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
    A.Next.Sell={Items={},Total=1};C.Run("SellLoot",C.Handlers.SellLoot);drain();check(#A.Calls==3,"Retry on later cycle after failure")
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
do
    local A=context();local C=makeCore(A,P);local searches=0
    local first={Instance={Alive=true},Kind="Egg",Rarity="Common",Name="Soil Egg",Serial=1,Ready=false}
    local second={Instance={Alive=true},Kind="Egg",Rarity="Common",Name="Clay Egg",Serial=2,Ready=false}
    A.ValidFind=function(n)return n and n.Alive end
    A.Targets=function()searches+=1;return first.Instance.Alive and{first,second}or{second}end
    A.Aim=function(target)if target and target.Instance.Alive and target.Ready then return"origin","direction","Find",target.Instance end end
    A.Move=function(target,valid)now+=.06;target.Ready=true;return valid(),"Arrived"end
    C.Set("FarmFinds",true);local started=now;C.Tick();drain()
    check(C.Target==first and A.Sent[1].Args[1]=="Start"and now-started<=.061,"Farm starts mining immediately after 60 ms movement settle")
    local before=now;first.Instance.Alive=false;now+=.025;C.Tick();drain()
    check(C.Target==second and now-before<=.086,"Destroyed target switches on next tick without waiting one second")
    local scans=searches;for _=1,30 do now+=.025;C.Tick();drain()end
    check(searches==scans,"Healthy target does not rescan and sort whole mine every poll")
    C.StopAll()
end
do
    local A=context();local C=makeCore(A,P);C.Config.SellLoot=true;local opens=0
    A.Next.Sell=function(action)
        if action=="Open"then opens+=1;if opens==1 then return{Code="TooFar"}end;return{Items={},Total=75}end
        return{Items={},Total=0,Code="Sold",CashAdded=75}
    end
    C.Run("SellLoot",C.Handlers.SellLoot);pump()
    check(C.Selling=="SellLoot"and A.Sent[1].Remote=="Surface"and A.Sent[1].Args[1]=="Sell","Auto sell travels to native seller when out of range")
    C.Config.FarmFinds=true;A.Pause=true;local scans=0;A.Targets=function()scans+=1;return{}end
    C.Run("FarmFinds",C.Handlers.FarmFinds);pump();check(scans==0,"Farm cannot move character away during a sale")
    A.Pause=false;drain();check(C.Selling==nil and C.Report.Jobs.SellLoot=="Sold +$75","Sale confirms actual server cash and releases lock")
end
do
    local A=context();local C=makeCore(A,P);C.Config.SellEggs=true;local opens=0;local quotes={}
    A.Next.Sell=function(action,quote)
        if action=="Open"then opens+=1;return{Items={},SpareEggs={Count=1,Quote="quote-"..opens}}end
        quotes[#quotes+1]=quote;return #quotes==1 and{Code="Changed"}or{Items={},CashAdded=10}
    end
    C.Run("SellEggs",C.Handlers.SellEggs);drain()
    check(#quotes==2 and quotes[1]=="quote-1"and quotes[2]=="quote-2","Changed quote is refreshed rather than reused")
    A.Calls={};A.Next.Sell={Code="Restricted"};C.Run("SellEggs",C.Handlers.SellEggs);drain()
    check(#A.Calls==1 and C.Report.Jobs.SellEggs=="Restricted","Preserve server rejection rather than masking it as empty inventory")
end
do
    local A=context();local C=makeCore(A,P);C.Config.SellLoot=true;C.Config.SellPets=true;A.Pause=true;A.Next.Sell={Items={},Total=1}
    C.Run("SellLoot",C.Handlers.SellLoot);C.Run("SellPets",C.Handlers.SellPets);pump()
    check(#A.Calls==1,"Sale types serialize instead of competing for same remote")
    C.StopAll();A.Pause=false;drain();check(#A.Calls==1 and C.Selling==nil,"Stop cancels sale and clears ownership after pending snapshot")
end
do
    local A=context();local C=makeCore(A,P);C.Set("Dig",true);C.Tick();drain()
    now+=.4;C.Tick();drain()
    check(A.Sent[#A.Sent-1].Args[1]=="Stop"and A.Sent[#A.Sent].Args[1]=="Start","Input timeout rearms with Start rather than sending Aim forever")
    check(C.Report.Recoveries==1 and C.Config.Dig,"Recovery keeps automation enabled")
    C.StopAll();local count=#A.Sent;now+=5;C.Tick();drain();check(#A.Sent==count,"Watchdog cannot restart after Stop All")
end
do
    local A=context();local C=makeCore(A,P)
    local first={Instance={Alive=true,HP=100},Kind="Egg",Rarity="Common",Name="Soil",Serial=1}
    local second={Instance={Alive=true,HP=1000},Kind="Egg",Rarity="Common",Name="Clay",Serial=2}
    A.ValidFind=function(n)return n and n.Alive end;A.Targets=function()return{first,second}end
    A.Aim=function(t)if t then return"o","d","Find",t.Instance,t.Instance end end
    A.Health=function(n)return n and n.HP end;A.NativeCooldown=function()return .5 end
    C.Set("FarmFinds",true);C.Tick();drain()
    for _=1,220 do now+=.05;if C.Target==second then second.Instance.HP-=1 end;C.Tick();drain()end
    check(C.Target==second and C.Config.FarmFinds,"Unchanged server health recovers then moves past stalled target without switching auto off")
    check(C.Report.Recoveries>=3,"Repeated no-progress sessions are recorded")
    C.StopAll()
end
do
    local A=context();local C=makeCore(A,P);local node={HP=100}
    A.Aim=function()return"o","d","Down",nil,node end;A.Health=function(n)return n.HP end;A.NativeCooldown=function()return 2 end
    C.Set("Dig",true)
    for _=1,140 do now+=.05;C.Tick();drain()end
    check(C.Report.Recoveries==0,"Slow native equipment gets its own progress window")
    node.HP=99;now+=.05;C.Tick();drain();check(C.Report.Recoveries==0,"Actual damage progress resets watchdog")
    C.StopAll()
end
do
    local A=context();local C=makeCore(A,P)
    local stuck={Instance={},Kind="Egg",Rarity="Common",Name="Stuck",Serial=1};local good={Instance={},Kind="Egg",Rarity="Common",Name="Good",Serial=2}
    A.ValidFind=function(n)return n~=nil end;A.Targets=function()return{stuck,good}end
    A.Aim=function(t)if t==good then return"o","d","Find",t.Instance end end
    local attempts=0;A.Move=function()attempts+=1;return false,"Blocked"end
    C.Set("FarmFinds",true)
    for _=1,60 do now+=.05;C.Tick();drain()end
    check(attempts==3 and C.Target==good,"Repeated unreachable nearest egg cannot starve reachable eggs")
    check(C.Config.FarmFinds,"Target backoff keeps farm running")
    C.StopAll()
end
do
    local A=context();local C=makeCore(A,P);A.Modules.ShovelCatalog=shovelCatalog();A.Attrs.Cash=500
    local arrived=false;local moves=0
    A.MarketPosition=function(kind)check(kind=="Shovels","Resolve native shovel market type");return "shop-position"end
    A.Move=function(target,valid)
        check(C.Shopping=="BuyShovel"and target.Position=="shop-position","Shop owns movement until purchase completes")
        coroutine.yield();coroutine.yield();if not valid()then return false,"Cancelled"end;arrived=true;moves+=1;return true,"Arrived"
    end
    A.Next.Shovels=function(action)
        if action=="Open"then return arrived and{Owned={Basic=true}}or{Code="TooFar"}end
        return{Code="Purchased",Owned={Basic=true,Grey=true}}
    end
    C.Config.Dig=true;C.Config.FarmFinds=true;C.Config.SellLoot=true
    A.Targets=function()error("Farm must pause during shopping")end
    C.Run("BuyShovel",function(valid)C.BuyShovel(valid)end,true);pump()
    C.Run("FarmFinds",C.Handlers.FarmFinds);C.Run("SellLoot",C.Handlers.SellLoot);C.UpdateMining();pump();drain()
    check(moves==1 and #A.Calls==3 and A.Calls[3].Args[1]=="Buy","TooFar travels, reopens and purchases without sale / farm interference")
    check(not C.Shopping and not C.Report.Errors.FarmFinds and C.Report.Jobs.BuyShovel=="Purchased","Shop releases movement and reports server result")
    arrived=false;A.Calls={};C.Run("BuyShovel",function(valid)C.BuyShovel(valid)end,true);pump();C.StopAll();drain()
    check(#A.Calls==1 and not C.Shopping,"Stop all during market travel prevents purchase and releases shop lease")
end
do
    local A=context();local C=makeCore(A,P);A.Attrs.Cash=1000;C.Config.GearLimit=10
    A.Modules.GearConfig={Types={Totem={SingleOwned=true}}}
    A.Next.Gear={Counts={Totem=1},Prices={Totem=100},Stock={Key="s",Remaining={Totem=2}}}
    C.Run("BuyGear",function(valid)C.BuyGear(valid,"Totem")end,true);drain()
    check(#A.Calls==1 and C.Report.Jobs.BuyGear=="Already owned","SingleOwned uses Counts even when drill Owned map is absent")
    local buys=0;local opens=0;A.Calls={}
    A.Next.Gear=function(action,id,price,key)
        if action=="Open"then opens+=1;return{Counts={},Prices={Totem=opens==1 and 100 or 120},Stock={Key=opens==1 and"old"or"fresh",Remaining={Totem=2}}}end
        buys+=1
        if buys==1 then return{Code="PriceChanged"}end
        check(price==120 and key=="fresh","Retry uses refreshed price and stock key")
        return{Code="Purchased",Counts={Totem=1}}
    end
    C.Run("BuyGear",function(valid)C.BuyGear(valid,"Totem")end,true);drain()
    check(buys==2 and opens==2 and C.Report.Jobs.BuyGear=="Purchased","Price changes refresh once and purchase succeeds")
    A.Calls={};C.Config.Reserve=950;buys=0;opens=0
    C.Run("BuyGear",function(valid)C.BuyGear(valid,"Totem")end,true);drain()
    check(buys==0,"Changed-price path never overrides cash reserve")
end
do
    local A=context();local C=makeCore(A,P);A.Attrs.Cash=1000
    A.Modules.ShovelCatalog={Tiers={{Id="Drill",Kind="Drill",Cost=100}},index=function()return 1 end}
    A.Next.Gear=function(action)
        if action=="Open"then return{Counts={},Owned={},Stock={Key="live",Remaining={Drill=1}}}end
        if action=="Buy"then return{Code="Purchased",Counts={},Owned={Drill=true}}end
        return{Code="Equipped"}
    end
    C.Run("BuyGear",function(valid)C.BuyGear(valid,"Drill")end,true);drain()
    check(#A.Calls==3 and A.Calls[3].Args[1]=="Equip"and A.Calls[3].Args[2]=="Drill","A purchased drill is equipped during the same operation")
    A.Calls={};A.Next.Gear={Code="TooFar"};A.MarketPosition=function()return nil end
    C.Run("BuyGear",function(valid)C.BuyGear(valid,"Drill")end,true);drain()
    check(#A.Calls==1 and A.Sent[1].Args[1]=="Sell"and not C.Shopping,"Unstreamed shop gets bounded surface discovery without blind purchases")
    check(C.Report.Jobs.BuyGear=="Shop not loaded; visit the market and retry","Missing market shows an actionable status")
end
print("PASS core/policy behavior checks:",passed)
