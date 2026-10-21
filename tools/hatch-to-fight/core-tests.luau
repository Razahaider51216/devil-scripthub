local checks=0
local function check(v,message)assert(v,message);checks+=1 end
local function fixture()
    local time=0;local log={};local attrs={Level=1,Rebirths=0}
    local s={Mounted=true,PetId="Pig",InFight=false,FightStage=0,StagesCleared=0,Rebirths=0,HP=100,MaxHP=100}
    local A={Cache={},Near=true}
    A.Now=function()return time end
    A.Attr=function(key,default)local v=attrs[key];return v==nil and default or v end
    A.Snapshot=function()return s end
    A.Refresh=function()table.insert(log,{Kind="refresh"})end
    A.Blocked=function()return A.BlockReason end
    A.Fire=function(key,...)table.insert(log,{Kind="fire",Key=key,Args=table.pack(...)});if A.Throw then error("temporary executor error")end;return not A.Fail,"remote failed"end
    A.Call=function(lane,args,cb,job)table.insert(log,{Kind="call",Key=lane,Args=args,Job=job});if cb then cb(not A.Fail,A.Fail and"error"or"ok")end;return not A.Fail,"busy"end
    A.Move=function(point,look)table.insert(log,{Kind="move",Point=point});return point~=nil,"not streamed"end
    A.StagePoint=function(index)if A.MissingStage then return end;return "stage-"..index,"look"end
    A.Approach=function()return "approach"end
    A.Drop=function()return A.DropValue end
    A.Dummy=function()return A.DummyValue end
    A.NearHub=function()return A.Near end
    A.HubPoint=function(name)return "hub-"..name end
    A.CancelQueued=function()A.Cancelled=true end
    A.CancelJob=function(job)A.CancelledJob=job end
    A.Destroy=function()A.Destroyed=true end
    local C=makeCore(A,K)
    local function tick(seconds)time+=seconds or 1;C.Tick()end
    local function count(kind,key)
        local n=0;local last
        for _,item in ipairs(log)do if item.Kind==kind and(not key or item.Key==key)then n+=1;last=item end end
        return n,last
    end
    return C,A,s,attrs,tick,count,log
end
do
    local c,a,s,attrs,tick,count=fixture()
    tick();check(count("refresh")==0,"startup polls game state despite all jobs off")
    for _,job in ipairs(c.JobKeys)do check(c.Config[job]==false,"job starts enabled: "..job)end
    c.Set("Farm",true);c.Set("Train",true);check(not c.Config.Farm and c.Config.Train,"primary movement conflict")
    c.Set("Tower",true);c.Set("Boss",true);check(not c.Config.Tower and c.Config.Boss and not c.Config.Train,"primary conflict")
    c.StopAll();tick();check(a.Cancelled and count("fire")==0,"StopAll emitted actions")
    c.Import({Farm=true,Train=true,Tower=true,Boss=true,Stage=999,CraftCount=-5,CombatDistance=0,KeepPets=0,Language="bad"})
    check(c.Config.Boss and not c.Config.Farm and not c.Config.Train and not c.Config.Tower,"profile reintroduces conflicting movement")
    check(c.Config.Stage==60 and c.Config.CraftCount==4 and c.Config.CombatDistance==3 and c.Config.KeepPets==1,"profile number bounds")
    check(c.Config.Language=="EN","profile language invalid")
    c.Destroy();tick();check(a.Destroyed and c.Stopped,"destroy lifecycle")
end
do
    local c,a,s,attrs,tick,count=fixture()
    s.Mob={HP=100,Distance=4,Pos="enemy",Name="Mob"};s.InFight=true;c.Set("Attack",true);c.Set("Special",true)
    tick(.1);local first=count("fire","Ability");check(first==2,"attack/special missing")
    tick(.1);check(count("fire","Ability")==first,"ability cooldown not retained")
    c.Set("Attack",false);c.Set("Special",false);tick(20);check(count("fire","Ability")==first,"disabled abilities still fire")
    c.Set("Farm",true);s.Mounted=false;tick(1);check(count("fire","EquipPet")==1,"native mount request missing")
end
do
    local c,a,s,attrs,tick,count=fixture()
    c.Set("Farm",true);c.Config.Stage=60;tick();check(count("move")==0,"farm attempts locked progression")
    check(c.WarpStage(60)==true,"manual last-stage test unavailable")
    local _,last=count("move");check(last.Point=="stage-60","incorrect last-stage destination")
    check(s.StagesCleared==0 and s.FightStage==0,"teleport falsifies progress")
    a.MissingStage=true;check(not c.WarpStage(60),"missing stage reported successful")
    c.StopAll();c.Config.Stage=0;c.Set("Farm",true);s.StagesCleared=3;tick(5)
    a.MissingStage=false;tick(2);local _,move=count("move");check(move.Point=="stage-4","highest unlocked progression wrong")
end
do
    local c,a,s,attrs,tick,count=fixture()
    c.Set("Train",true);a.DummyValue={Name="Camp",Distance=7,Pos="dummy"}
    tick();check(count("fire","RequestTrainHit")==1,"train event missing")
    a.Throw=true;tick(1);check(c.Config.Train and c.Report.Errors.Movement,"worker exception disables job or is hidden")
    a.Throw=false;tick(4);check(count("fire","RequestTrainHit")>=3 and c.Config.Train,"training failed to recover")
    a.BlockReason="typing";local before=count("fire");tick(5);check(count("fire")==before,"typing does not pause workers")
end
do
    local c,a,s,attrs,tick,count=fixture()
    a.DropValue={Name="Shell",Distance=4,Ref="actual-shell-instance",Key="1",Pos="drop"}
    c.Set("Collect",true);tick();local _,last=count("fire","RequestPickupShell")
    check(last and last.Args[1]=="actual-shell-instance","pickup does not pass actual instance")
    tick(.1);check(count("fire","RequestPickupShell")==1,"pickup duplicate rate limit failed")
    a.Cache.Data={bagCount=10,bagCapacity=10};tick(3);check(count("fire","RequestPickupShell")==1,"full bag still collecting")
end
do
    local c,a,s,attrs,tick,count=fixture()
    a.Cache.Data={equipped=1,buffPet=2,pets={{id="Pig",uid=1},{id="Pig",uid=2},{id="Pig",uid=3,locked=true},{id="Pig",uid=4,favorite=true},{id="Pig",uid=5}}}
    c.Config.PetRarities={Common=true};c.Set("SellPets",true);tick()
    local _,last=count("fire","RequestSellPet");check(last and last.Args[1]==5,"equipped/buff/favorite/locked pet sold")
    check(c.Report.Observed==0 and c.Report.Sent==1,"sent request falsely marked confirmed")
    c.Observe("HatchResult",{});check(c.Report.Observed==1,"game event not counted")
end
do
    local c,a,s,attrs,tick,count=fixture()
    a.Cache.Data={shells={barnyard=8,coop=8,petshop=8,garden=8},eggs={},pets={}}
    c.Config.CraftCount=32;c.Set("Craft",true);c.Set("Sell",true);tick()
    local _,last=count("fire","RequestCraftEgg");check(last and #last.Args[1]==4,"recipe slots wrong")
    local total=0;for _,pair in ipairs(last.Args[1])do check(pair[2]<=8,"recipe exceeds slot limit");total+=pair[2]end
    check(total==32,"recipe total wrong")
    check(count("fire","RequestSell")==0,"reserved crafting shells sold")
    c.Set("Craft",false);tick(4);check(count("fire","RequestSell")==1,"shell sale never runs")
end
do
    local c,a,s,attrs,tick,count=fixture()
    a.Cache.Data={pets={},maxPets=1,eggs={{uid="egg-uid"}}}
    c.Set("Hatch",true);tick();local _,last=count("fire","RequestHatchEgg");check(last.Args[1]=="egg-uid","hatch uid wrong")
    a.Cache.Data.pets={{id="Pig",uid=1}};tick(4);check(count("fire","RequestHatchEgg")==1,"hatch ignores storage full")
end
do
    local c,a,s,attrs,tick,count=fixture()
    a.Cache.Tower={open=true,tickets=1,owned={}}
    c.Set("Tower",true);c.Config.TowerCheckpoint=4;tick();check(count("call","Tower")==0,"unowned checkpoint used")
    c.Config.TowerCheckpoint=0;tick(6);local _,last=count("call","Tower");check(last.Args[1]=="Climb"and last.Args[2]==0,"tower climb arguments wrong")
    c.Config.TowerStop=10;c.Observe("Tower:floor",{floor=10});tick(6);check(count("call","Tower")==1,"floor stop ignored")
    c.Set("Boss",true);s.BossAlive=false;tick();check(count("fire","WorldBoss")==0,"enters unavailable boss")
    s.BossAlive=true;tick(6);local _,boss=count("fire","WorldBoss");check(boss.Args[1]=="Enter","boss entry contract")
end
do
    local c,a,s,attrs,tick,count=fixture()
    attrs.Level=K.RebirthLevels[0];c.Set("Rebirth",true);tick();check(count("fire","RequestRebirth")==1,"native rebirth requirement ignored")
    c.Set("Rebirth",false);a.Cache.Meta={keys=3};c.Set("Crates",true);c.Config.Crate="Secret";tick()
    local _,last=count("call","Meta");check(last.Args[1]=="OpenCrate"and last.Args[2]=="Secret"and last.Args[3]==1,"key crate contract")
    c.Config.Crate="Mutated";tick(5);check(count("call","Meta")==1,"premium crate automatically purchased")
end
do
    local c,a,s,attrs,tick,count=fixture()
    c.Set("Rewards",true);a.Cache.Meta={daily={canClaim=true}};tick()
    local _,daily=count("call","Meta");check(daily.Args[1]=="ClaimDaily","daily claim")
    a.Cache.Meta={gifts={claimed={},elapsed=61}};tick(2)
    local _,gift=count("call","Meta");check(gift.Args[1]=="ClaimGift"and gift.Args[2]==1,"gift timer/state contract")
    a.Cache.Meta={quests={list={{target=3,progress=3,claimed=false}}}};tick(2)
    local _,quest=count("call","Meta");check(quest.Args[1]=="ClaimQuest"and quest.Args[2]==1,"quest claim contract")
    a.Cache.Meta={quests={list={{target=3,progress=3,claimed=true}},bonus=false}};tick(2)
    local _,bonus=count("call","Meta");check(bonus.Args[1]=="ClaimQuestBonus","quest bonus")
end
do
    local c,a,s,attrs,tick,count=fixture()
    local id
    for race,def in pairs(K.Races.List)do if def.Kind=="Fight"then id=race;break end end
    check(id~=nil,"missing native Fight race")
    a.Cache.Race={rolls=3,stars={[id]=1},slots={id},open={true},equipped=0}
    c.Set("RaceEquip",true);tick();local _,equip=count("call","Race")
    check(equip and equip.Args[1]=="Equip"and equip.Args[2]==1,"race equip must send numeric slot")
    c.Set("RaceEquip",false);c.Set("RaceRoll",true);c.Config.RaceStop=K.Races.List[id].Rarity
    tick(5);check(count("call","Race")==1,"race stop rarity ignored")
end
do
    local c,a,s,attrs,tick,count=fixture()
    c.Set("Retreat",true);s.HP=10;tick()
    check(count("fire","RequestReturnHome")==1,"low HP retreat missing")
    check(s.HP==10 and not c.Config.Godmode,"fake local godmode introduced")
    check(c.Report.Godmode:find("Unavailable",1,true)~=nil,"godmode limit hidden")
    for _=1,120 do tick(.5)end
    check(c.Config.Retreat,"long-running job silently disabled")
end
do
    local c,a,s,attrs,tick,count=fixture()
    a.Cache.Data={shells={barnyard=10},bagCount=10,bagCapacity=10}
    a.Near=false;c.Set("Farm",true);c.Set("Sell",true);tick()
    local _,move=count("move");check(c.Service and c.Service.Job=="Sell"and move.Point=="hub-Sell","full bag does not suspend farm for shop visit")
    local signature=c.Service.Signature
    a.Cache.Data={shells={barnyard=10},bagCount=10,bagCapacity=10};tick(1)
    check(c.Service and c.Service.Signature==signature,"unchanged poll falsely completes hub visit")
    a.Near=true;tick(3);check(count("fire","RequestSell")==1,"hub visit does not sell")
    a.Cache.Data={shells={},bagCount=0,bagCapacity=10};tick(1)
    check(not c.Service and c.Config.Farm,"farm does not resume after actual inventory change")
end
print("PASS HatchToFight core: "..checks.." checks")
