local checks=0
local function check(v,message)assert(v,message);checks+=1 end
local P=(function()
-- TEST_PLANNER
end)()
local make=(function()
-- TEST_CORE
end)()
local function clone(v)
 if type(v)~='table'then return v end
 local out={};for k,x in pairs(v)do out[k]=clone(x)end;return out
end
local function fixture()
 local now=100;local work={};local packets={};local listeners={}
 local d={Money=10000,Inventory={},Slots={},TowerTeam={},Upgrades={},OwnedDice={Basic=true},Dice='Basic',Rebirth=0,RebirthStats={},
  AutoRoll=false,AutoTower='',PendingTrade=false,ActiveEntries={},EquippedGear={},ProtectedTraits={},ProtectedGrades={},ProtectedQuirks={},
  LastDailyRewardClaim=1000,ClaimedGroupReward=true,PendingOfflineEarnings=0,Quests={},Halloween={},Rolls=0,AutoSell=0,OwnedGamepasses={},RedeemedCodes={}}
 local function entry(name,amount,attrs)return {name=name,amount=amount or 1,attributes=attrs or{}}end
 local configs={Weak={kind='Unit',income=function()return 10 end,damage=function()return 10 end,chance=function()return 10 end},
  Rare={kind='Unit',income=function()return 100 end,damage=function()return 100 end,chance=function()return 1000 end}}
 local ctx={Ready=true,Warnings={},Catalog={},Clock=function()return now end,Now=function()return now end,WallTime=function()return 1100 end,
  Wait=function(n)now+=n end,Spawn=function(fn)work[#work+1]=fn end,Snapshot=function()local out=clone(d);out.Storage=50;return out end,
  Buff=function()return 1 end,CancelMovement=function()end,Destroy=function()end,InGroup=function()return false end,
  Listen=function(ns,key,fn)listeners[ns..'/'..key]=fn end}
 local c=ctx.Catalog
 c.Registry={getEntryConfig=function(name)return configs[name]end}
 c.Dice={GetAll=function()return {Basic={luck=1},Fire={luck=5,price=100},Water={luck=10,price=500}}end}
 c.Upgrades={Start={price=0},Child={price=200},Grandchild={price=300}}
 c.TreeStructure={GetParent=function(id)return id=='Child'and'Start'or id=='Grandchild'and'Child'or nil end}
 c.UnitUtil={GetLevelPrice=function()return 50 end}
 c.Towers={GetAll=function()return {Test={},['Front Yard']={event=true}}end}
 c.TowerRefs={ActionWaitTime={floorStarted=.76,damageEnemy=.62,floorCompleted=.24,ended=0}}
 c.Rebirths={GetNext=function()return {cost=5000}end}
 c.RebirthStats={Get=function()return {}end,GetRemaining=function(rebirth,stats)local n=0;for _,v in pairs(stats)do n+=v end;return rebirth-n end}
 c.QuirkUtil={GetRollCost=function()return 20 end}
 c.FusingConfig={GetCost=function()return 30 end}
 c.FusingUtil={GetChance=function(item)return item.name=='Weak'and not item.attributes.locked and 10 or nil end,BuildPools=function()return {}end}
 c.Daily={Cooldown=10000};c.Quest={Periods={Daily={quests={{id='Rolls',target=5}}}},Shop={{name='Gems',tickets=1}}}
 c.Halloween={PUMPKINS='Pumpkins',CANDY='Candy',COOLDOWN=30,MIN_KNOCK_GAP=2,MAX_TRAVEL_SPEED=60}
 c.PumpkinDice={COST=100,MULTI=5,ROLL_DURATION=2.5,Units={{id='Mummy'}}}
 c.PumpkinPass={{candy=500,free={Pumpkins=100}}}
 c.HalloweenShop={{name='Potion',candy=10}}
 c.HalloweenQuests={PERIODS={'Hourly'},Hourly={dataKey='HourlyQuests',pool={{id='Rolls',target=5}}}}
 local server
 ctx.Fire=function(ns,key,...)
  local args=table.pack(...);packets[#packets+1]={ns=ns,key=key,args=args,kind='RE',at=now}
  if server then server(ns,key,args)end
 end
 ctx.Invoke=function(ns,key,...)
  local args=table.pack(...);packets[#packets+1]={ns=ns,key=key,args=args,kind='RF',at=now}
  if server then return server(ns,key,args)end
 end
 local ctl=make(ctx,P)
 local function drain()local batch=work;work={};for _,fn in ipairs(batch)do fn()end end
 local function step(seconds)now+=seconds or 0;ctl.Tick();drain()end
 return {ctx=ctx,d=d,c=c,ctl=ctl,cfg=ctl.Config,packets=packets,listeners=listeners,entry=entry,step=step,drain=drain,
  server=function(fn)server=fn end,time=function()return now end,configs=configs}
end
do
 local f=fixture();f.step();check(#f.packets==0,'default startup sent game actions')
 for _,name in ipairs(f.ctl.Jobs)do check(f.cfg[name]==false,'automation defaults on: '..name)end
 check(P.Number('nan',2)==2 and P.Number(math.huge,2)==2 and P.Number(-10,2)==2,'invalid numeric inputs accepted')
end
do
 local f=fixture();local e=f.entry
 f.d.Inventory={a=e('Weak'),b=e('Weak'),c=e('Weak'),d=e('Weak'),r=e('Rare'),locked=e('Weak',1,{locked=true}),mut=e('Weak',1,{mutation='Gold'})}
 f.d.Slots={['1']={unitId='a'}};f.d.TowerTeam={'b'};f.cfg.KeepNames.Weak=true;f.cfg.SellChanceMax=20
 check(#f.ctl.Preview('Sell')==0,'kept names or rare/locked units eligible for sale')
 f.cfg.KeepNames={};f.cfg.KeepCopies=0;f.cfg.KeepBest=0;f.cfg.SelectedUnit='c'
 local list=f.ctl.Preview('Sell');check(#list==1 and list[1].id=='d','plot/team/mutation/selected/locked filtering failed')
 f.d.PendingTrade={reservedUnits=2};check(#f.ctl.Preview('Fuse')==0,'pending trade material guard failed')
 f.cfg.SellChanceMax=0;f.d.PendingTrade=false;check(#f.ctl.Preview('Sell')==0,'unset sell limit allowed sales')
 f.cfg.SellChanceMax=20;f.cfg.Sell=true;f.d.AutoSell=100;f.step();check(#f.packets==0,'custom sale ran alongside native AutoSell')
end
do
 local f=fixture();f.d.Slots={['2']={balance=50}};f.ctl.Set('Collect',true)
 f.step();check(#f.packets==1 and f.packets[1].args[1]==2,'collect sent wrong slot type')
 check(f.ctl.Report.Jobs.Collect.Confirmed==0,'FireServer return counted as confirmation')
 f.step(.1);check(#f.packets==1,'unconfirmed collect duplicated')
 f.d.Slots['2'].balance=0;f.step(.1);check(f.ctl.Report.Jobs.Collect.Confirmed==1,'live balance confirmation not recognized')
end
do
 local f=fixture();f.cfg.MoneyReserve=9900;f.ctl.Set('Upgrade',true);f.ctl.Set('Dice',true);f.step()
 f.d.Upgrades.Start=true;f.step(4)
 local buys=0
 for _,p in ipairs(f.packets)do if p.key=='BuyDice'then buys+=1;check(p.args[1]=='Fire','dice reserve selected unaffordable item')end end
 check(buys==1,'affordable dice not purchased')
 check(P.Upgrade({Money=10000,Upgrades={}},f.c,f.cfg).id=='Start','upgrade planner skipped prerequisite')
 f.d.Upgrades.Start=true;f.cfg.MoneyReserve=0
 check(P.Upgrade(f.d,f.c,f.cfg).id=='Child','tree planner bought grandchild before parent')
end
do
 local f=fixture();f.cfg.UseNativeRoll=true;f.ctl.Set('Roll',true);f.step()
 check(f.packets[1].key=='SetAutoRoll'and f.packets[1].args[1]==true,'native Auto Roll not enabled')
 f.ctl.StopAll();check(f.packets[#f.packets].key=='SetAutoRoll'and f.packets[#f.packets].args[1]==false,'owned native roll not restored')
 local g=fixture();g.d.AutoRoll=true;g.ctl.Set('Roll',true);g.step();g.ctl.StopAll();check(#g.packets==0,'preexisting native roll changed on unload')
end
do
 local f=fixture();f.ctl.Set('Collect',true);f.ctl.Tick();f.ctl.StopAll();f.drain()
 check(#f.packets==0,'queued worker sent actions after StopAll')
 f.ctl.Destroy();f.step(100);check(#f.packets==0,'destroyed controller sent actions')
end
do
 local f=fixture();f.d.Inventory.u=f.entry('Weak',1,{trait='Good'});f.d.Inventory['Trait Reroll']=f.entry('Trait Reroll',5)
 f.cfg.SelectedUnit='u';f.cfg.TraitTargets={Best=true};f.d.ProtectedTraits.Good=true
 f.ctl.Set('Trait',true);f.step();check(#f.packets==0,'reroll overwrote protected trait')
 f.d.ProtectedTraits.Good=false;f.step(4)
 check(f.packets[1].ns=='TraitService'and f.packets[1].args[1]=='u'and f.packets[1].args[2]==false,'reroll protection flag/ID incorrect')
 f.d.Inventory.u.attributes.trait='Best';f.step(.2);f.step(1)
 check(not f.cfg.Trait,'reroll did not stop at target')
end
do
 local f=fixture();f.d.Quests.Daily={expiresAt=1234,progress={Rolls=5},claimed={}}
 f.ctl.Set('Quests',true);f.step()
 local p=f.packets[1];check(p.ns=='QuestService'and p.args.n==3 and p.args[3]==1234,'quest claim omitted current expiresAt')
 local g=fixture();g.d.Halloween.HourlyQuests={ids={'Rolls'},progress={Rolls=5},claimed={}}
 g.ctl.Set('EventQuests',true);g.step();check(g.packets[1].ns=='HalloweenQuestService'and g.packets[1].args.n==2,'event claim used base quest protocol')
end
do
 local f=fixture();f.d.Inventory.Pumpkins=f.entry('Pumpkins',499);f.cfg.PumpkinCount=5
 f.ctl.Set('Pumpkin',true);f.step();check(#f.packets==0,'pumpkin roll ignored currency cost')
 f.d.Inventory.Pumpkins.amount=1000;f.step(4);check(f.packets[1].kind=='RF'and f.packets[1].args[1]==5,'pumpkin multi count wrong')
 f.step(.5);check(#f.packets==1,'pumpkin request repeated during cooldown')
end
do
 local f=fixture();f.d.Inventory.Candy=f.entry('Candy',100);f.cfg.OfferChoice='Potion';f.cfg.OfferLimit=1
 f.server(function(ns,key)if ns=='HalloweenService'and key=='BuyOffer'then f.d.Inventory.Candy.amount-=10 end end)
 f.ctl.Set('CandyShop',true);f.step();f.step(.1);f.step(4)
 check(#f.packets==1 and f.ctl.Report.Jobs.CandyShop.Purchases==1,'Candy purchase limit not enforced')
end
do
 local f=fixture();f.cfg.KeepBest=0;f.cfg.KeepCopies=0;f.cfg.FuseChanceMax=20
 f.d.Inventory={a=f.entry('Weak'),b=f.entry('Weak'),c=f.entry('Weak')}
 f.ctl.Set('Fuse',true);f.step();check(f.packets[1].ns=='FusingService'and f.packets[1].args.n==3,'fusion did not send three distinct live IDs')
 local ids=f.packets[1].args;check(ids[1]~=ids[2]and ids[2]~=ids[3]and ids[1]~=ids[3],'fusion repeated unit ID')
end
do
 local f=fixture();f.cfg.TowerChoice='Test'
 f.server(function(ns,key)if key=='PlayTower'then f.ctl.Set('Tower',false);return true end end)
 f.ctl.Set('Tower',true);f.step()
 check(f.packets[#f.packets].key=='CancelTower','late successful tower start not cancelled after StopAll')
 local g=fixture();g.ctl.Set('Tower',true);g.ctl.Set('Haunted',true)
 check(not g.cfg.Tower and g.cfg.Haunted,'Tower and Haunted modes active together')
end
do
 local f=fixture();f.cfg.TowerChoice='Test';local round=0
 f.server(function(ns,key)
  if key=='PlayTower'then return true end
  if key=='CompleteTowerFloor'then round+=1;return {{action='floorStarted'},{action='damageEnemy'},{action='floorCompleted',floor=round}}end
 end)
 f.ctl.Set('Tower',true);f.step();f.step(5.3);local count=#f.packets
 f.step(.3);check(#f.packets==count,'tower requests ignored battle action delay')
 check(f.ctl.Report.Jobs.Tower.Confirmed==1,'tower floor not counted from server actions')
 f.ctl.StopAll();f.drain();check(f.packets[#f.packets].key=='CancelTower','owned tower not stopped')
end
do
 local f=fixture();f.ctl.BindEvents();f.ctl.Set('Doors',true)
 local part={Position={}};f.listeners['TrickOrTreatService/Knocked'](part,1,200)
 f.listeners['TrickOrTreatService/Landed'](part,12)
 check(f.ctl.Report.Jobs.Doors.Confirmed==1 and f.ctl.Report.Jobs.Doors.Candy==12,'door confirmation not sourced from server events')
 check(#f.packets==0,'door result handler forged an outgoing reward action')
end
do
 local f=fixture();f.d.Rebirth=0;f.cfg.RebirthLimit=1;f.ctl.Set('Rebirth',true);f.step()
 check(f.packets[1].key=='Rebirth','rebirth gate rejected affordable tier')
 f.d.Rebirth=1;f.step(.1);f.step(5);check(#f.packets==1,'rebirth exceeded selected target')
end
do
 local f=fixture();f.d.Inventory.Tickets=f.entry('Tickets',1);f.cfg.QuestOffer='Gems';f.cfg.TicketReserve=1
 f.ctl.Set('QuestShop',true);f.step();check(#f.packets==0,'quest shop ignored ticket reserve')
 f.cfg.TicketReserve=0;f.step(4);check(f.packets[1].ns=='QuestService'and f.packets[1].args[1]=='Gems','quest shop sent wrong offer parameter')
end
do
 local f=fixture();f.d.Inventory.u=f.entry('Weak',1,{level=1});f.d.Slots['1']={unitId='u'}
 f.server(function(ns,key,args)if key=='LevelUpSlot'then f.d.Inventory.u.attributes.level+=1 end end)
 f.cfg.LevelCap=2;f.ctl.Set('Level',true);f.step();f.step(.1);f.step(1)
 check(#f.packets==1 and f.packets[1].args[1]==1,'unit level cap or numeric slot contract failed')
 check(f.ctl.Report.Jobs.Level.Confirmed==1,'unit level confirmation missing')
 local g=fixture();g.d.Inventory.r=g.entry('Rare');g.cfg.LockChanceMin=100
 g.ctl.Set('Lock',true);g.step();check(g.packets[1].args[1].r==true,'Auto Lock did not send ID map')
end
do
 local f=fixture();f.cfg.KeepBest=0;f.cfg.KeepCopies=0;f.cfg.SellChanceMax=100
 f.d.Inventory.u=f.entry('Weak')
 f.server(function(ns,key,args)if key=='SellInventory'then check(args[1][1]=='u','sell ID list malformed');return 400,1 end end)
 f.ctl.Set('Sell',true);f.step()
 check(f.ctl.Report.Jobs.Sell.Confirmed==1 and f.ctl.Report.Jobs.Sell.Units==1 and f.ctl.Report.Jobs.Sell.Earned==400,'sale counted wrong response values')
end
do
 local f=fixture();f.configs.Potion={kind='Boost'};f.configs.Spin={kind='Spin'}
 f.d.Inventory.Potion=f.entry('Potion',2);f.d.Inventory.Spin=f.entry('Spin',2)
 f.cfg.BoostNames.Potion=true;f.cfg.SpinNames.Spin=true
 f.ctl.Set('Boost',true);f.ctl.Set('Spin',true);f.step()
 check(#f.packets==2 and f.packets[1].ns=='BoostService'and f.packets[2].ns=='SpinService','consumable kinds routed incorrectly')
 local g=fixture();g.configs.Potion={kind='Boost'};g.d.Inventory.Potion=g.entry('Potion',2);g.d.ActiveEntries.Potion={name='Potion',remaining=10}
 g.cfg.BoostNames.Potion=true;g.ctl.Set('Boost',true);g.step();check(#g.packets==0,'active potion consumed again')
end
do
 local f=fixture();f.configs.Hat={kind='Gear',slot='Head',buffs={Luck={amount=2}}};f.d.Inventory.Hat=f.entry('Hat')
 f.ctl.Set('Gear',true);f.step()
 check(f.packets[1].ns=='GearService'and f.packets[1].args[1]=='Head'and f.packets[1].args[2]=='Hat','gear slot/name protocol wrong')
end
do
 local f=fixture();f.d.PendingOfflineEarnings=100
 f.ctl.Set('Rewards',true);f.step()
 check(f.packets[1].ns=='OfflineEarningsService'and f.packets[1].args.n==0,'offline reward called wrong action')
 local g=fixture();g.d.Halloween={CandyEarned=500,PathClaimed={},PathPremiumClaimed={}}
 g.ctl.Set('Pass',true);g.step();check(g.packets[1].key=='ClaimAllPath','earned pass tier not claimed')
end
do
 local f=fixture();f.cfg.CodeList={'TEST_A','TEST_B'};f.ctl.Set('Codes',true);f.step()
 check(f.packets[1].args[1]=='TEST_A','code list changed user code')
 f.d.RedeemedCodes.TEST_A=true;f.step(.1);f.step(2)
 check(f.packets[2].args[1]=='TEST_B','code list did not advance after confirmation')
 f.d.RedeemedCodes.TEST_B=true;f.step(2);f.step(20);check(#f.packets==2,'processed codes replayed endlessly')
end
do
 local f=fixture();f.ctl.PumpkinFilter({Mummy=true});f.drain()
 check(f.packets[1].ns=='PumpkinDiceService'and f.packets[1].args[1]=='Mummy'and f.packets[1].args[2]==true,'pumpkin sell filter protocol wrong')
 f.ctl.Protect('Grade',{S=true});f.drain()
 check(f.packets[2].key=='SetGradeProtected'and f.packets[2].args[2]==true,'grade protection protocol wrong')
 f.ctl.Teleport('Island');check(f.packets[3].kind=='RF'and f.packets[3].args[1]=='Island','event teleport wrong protocol')
 local n=#f.packets;check(not pcall(f.ctl.Teleport,'arbitrary')and #f.packets==n,'unknown destination sent to server')
end
do
 local f=fixture();f.cfg.TowerChoice='Test';local switched=false
 f.server(function(ns,key)
  if key=='PlayTower'then return true end
  if key=='CompleteTowerFloor'then
   if not switched then
    switched=true;f.ctl.Set('Tower',false);f.ctl.Set('Haunted',true)
    f.ctl.Tick();f.drain() -- A new run starts before the old response is processed.
    return {{action='ended'}}
   end
   return {{action='floorCompleted',floor=1}}
  end
 end)
 f.ctl.Set('Tower',true);f.step();f.step(6);f.step(7)
 check(f.cfg.Haunted and f.packets[#f.packets].key=='CompleteTowerFloor','stale Tower response discarded the new Haunted session')
 check(f.ctl.Report.Jobs.Haunted.Confirmed==1,'Haunted session lost progress after mode switch')
end
print('PASS Anime Dice planning, network contracts, confirmation, stop and event behavior: '..checks..' checks')
