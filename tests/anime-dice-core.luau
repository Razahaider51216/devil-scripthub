local checks=0
local function check(v,message)assert(v,message);checks+=1 end
local V={};local vm={}
function V.new(x,y,z)return setmetatable({X=x,Y=y,Z=z},vm)end
vm.__add=function(a,b)return V.new(a.X+b.X,a.Y+b.Y,a.Z+b.Z)end
vm.__sub=function(a,b)return V.new(a.X-b.X,a.Y-b.Y,a.Z-b.Z)end
vm.__mul=function(a,b)return V.new(a.X*b,a.Y*b,a.Z*b)end
vm.__index=function(a,k)if k=='Magnitude'then return math.sqrt(a.X*a.X+a.Y*a.Y+a.Z*a.Z)end end
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
 c.Halloween={PUMPKINS='Pumpkins',CANDY='Candy',TrickOrTreat={COOLDOWN=30,MIN_KNOCK_GAP=2,MAX_TRAVEL_SPEED=60}}
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
 f.d.Slots={['1']={unitId='a'}};f.d.TowerTeam={'b'};f.cfg.KeepNames.Weak=true;f.cfg.KeepIds.r=true
 check(#f.ctl.Preview('Sell')==0,'kept names or rare/locked units eligible for sale')
 f.cfg.KeepNames={};f.cfg.KeepIds={};f.cfg.SelectedUnit='c'
 local list=f.ctl.Preview('Sell');local selected={};for _,u in ipairs(list)do selected[u.id]=true end
 check(#list==3 and selected.d and selected.r and selected.mut,'sell all did not include unused rare/mutated/single-copy units')
 f.cfg.FuseChanceMax=20;f.cfg.KeepCopies=0;f.cfg.KeepBest=0
 local fusion=f.ctl.Preview('Fuse');check(#fusion==1 and fusion[1].id=='d','sell all bypass leaked into fusion filters')
 f.d.PendingTrade={reservedUnits=2};check(#f.ctl.Preview('Fuse')==0 and #f.ctl.Preview('Sell')==0,'pending trade material guard failed')
 f.d.PendingTrade=false;f.d.EquippedUnit='d';check(#f.ctl.Preview('Sell')==2,'carried unit included in sell all')
 f.d.EquippedUnitKnown=false;check(#f.ctl.Preview('Sell')==0 and f.ctl.SellSummary():find('carried',1,true),'unknown carried state did not pause selling')
 f.d.EquippedUnitKnown=true;f.d.EquippedUnit=nil;f.ctl.Set('Sell',true);f.d.AutoSell=100;f.step()
 check(#f.packets==1 and f.packets[1].key=='SellInventory','native roll AutoSell unnecessarily blocked inventory sale')
 check(P.Chance('1 / 1,000')==1000 and P.Chance('100,000')==100000 and P.Chance('-2',50)==50,'formatted sell chances parsed incorrectly')
 check(f.ctl.SellSummary():find('3 eligible',1,true),'live sell all summary wrong')
 check(f.cfg.SellChanceMax==nil,'obsolete sell chance configuration remained')
 f.d.PendingTrade=true;check(f.ctl.SellSummary():find('trade',1,true),'trade pause reason hidden')
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
 local f=fixture()
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
do
 local f=fixture();f.ctl.BindEvents()
 local first={Position=V.new(0,0,0)};local second={Position=V.new(240,0,0)}
 local doors={{key=first,position=first.Position,front=V.new(1,0,0),range=14},
  {key=second,position=second.Position,front=V.new(1,0,0),range=14}}
 local pos=V.new(30,0,0);local moves={};local armed={};local blocked={};local last
 f.ctx.Doors=function()return doors end;f.ctx.Position=function()return pos end;f.ctx.DoorInitialReady=function()return 0 end
 f.ctx.MoveDoor=function(goal,active,door)
  check(active()and door and(door.key==first or door.key==second),'route omitted door geometry / cancellation')
  pos=goal;moves[#moves+1]={at=f.time(),position=pos}
  for _,door in ipairs(doors)do
   local distance=(pos-door.position).Magnitude
   if distance>door.range+3 then armed[door.key]=true end
   if distance<door.range and armed[door.key]and(not blocked[door.key]or blocked[door.key]<=f.time())then
    if last then check(f.time()-last.at>=(door.position-last.position).Magnitude/60,'teleport ignored server travel-speed gate')end
    armed[door.key]=false;blocked[door.key]=f.time()+30;last={at=f.time(),position=door.position}
    f.listeners['TrickOrTreatService/Knocked'](door.key,1,blocked[door.key])
    f.listeners['TrickOrTreatService/Landed'](door.key,10)
   end
  end
  return true,'Arrived'
 end
 f.ctl.Set('Doors',true);f.step();f.step(1)
 check(f.ctl.Report.Jobs.Doors.Errors==0 and f.ctl.Report.Jobs.Doors.Confirmed==2,'multi-door route failed with actual nested Halloween configuration')
 check(#moves==4 and f.ctl.Report.Jobs.Doors.Candy==20,'route did not visit two doors / collect confirmed candy')
 local before=#moves;f.step(1)
 check(#moves==before and f.ctl.Report.Jobs.Doors.Status:find('cooldown',1,true),'cooling doors were repeatedly visited')
 f.step(31);check(f.ctl.Report.Jobs.Doors.Confirmed==3,'previous door did not rearm after cooldown')
 check(#f.packets==0,'door collector sent server-to-client knock/reward events')
end
do
 local f=fixture();local streamed=0
 f.ctx.Position=function()return V.new(0,0,0)end;f.ctx.Doors=function()return {}end
 f.ctx.StreamEvent=function()streamed+=1 end
 f.ctl.Set('Doors',true);f.step();f.step(3)
 check(#f.packets==1 and f.packets[1].key=='Teleport'and f.packets[1].args[1]=='Island','no loaded doors did not initiate event travel')
 check(f.cfg.Doors and streamed==2,'event travel disabled collection / failed to request streaming')
 f.step(30);check(#f.packets==2,'missing map did not retry travel after bounded cooldown')
 f.ctl.Teleport('Island');check(f.cfg.Doors,'manual Island travel permanently disabled collection')
 f.ctl.Teleport('Hub');check(not f.cfg.Doors,'Hub return immediately traveled back to event')
 f.ctl.Set('Doors',true)
 f.server(function(_,key)if key=='Teleport'then f.ctl.StopAll()end end)
 f.ctl.Teleport('Island');check(not f.cfg.Doors,'stop during travel restarted collector')
end
do
 local f=fixture();f.configs.Limited={kind='Unit',limited=true};f.configs.Potion={kind='Boost'}
 f.d.Inventory={limited=f.entry('Limited'),potion=f.entry('Potion'),favorite=f.entry('Weak',1,{favorite=true})}
 f.cfg.KeepBest=100;f.cfg.KeepCopies=100;f.cfg.SkipMutations=true
 local items=f.ctl.Preview('Sell')
 check(#items==1 and items[1].id=='limited','sell all skipped a unit without chance or included non-units/favorites')
 f.cfg.FuseChanceMax=100;check(#f.ctl.Preview('Fuse')==0,'limited unit allowed into fusion')
end
do
 local f=fixture()
 for i=1,60 do f.d.Inventory[string.format('u%02d',i)]=f.entry('Weak')end
 f.d.Slots={{unitId='u01'}};f.d.TowerTeam={'u02'};f.d.EquippedUnit='u03'
 f.d.Inventory.u04.attributes.locked=true;f.d.Inventory.u05.attributes.favorite=true;f.cfg.KeepIds.u06=true
 f.server(function(_,key,args)
  if key=='SellInventory'then
   check(#args[1]<=25,'sell all exceeded batch size')
   for _,id in ipairs(args[1])do
    check(id~='u01'and id~='u02'and id~='u03'and id~='u04'and id~='u05'and id~='u06'and id~='u10','sell all submitted a used or protected unit')
    f.d.Inventory[id]=nil
   end
   return 400*#args[1],#args[1]
  end
 end)
 f.ctl.Set('Sell',true);f.step()
 -- This unit is assigned to a base after the first batch, before the next sale.
 f.d.Slots[2]={unitId='u10'}
 f.d.PendingTrade=true;f.step(2);check(#f.packets==1,'batch selling continued during a trade')
 f.d.PendingTrade=false;f.step(3);f.step(2);f.step(2)
 check(#f.packets==3 and f.ctl.Report.Jobs.Sell.Units==53,'sell all did not drain multiple batches from live snapshots')
 local remaining=0;for _ in pairs(f.d.Inventory)do remaining+=1 end
 check(remaining==7 and f.d.Inventory.u10,'batch selling failed to preserve a newly assigned base unit')
end
do
 local f=fixture()
 f.configs.Weak.getRarity=function(a)return a.mutation=='Gold'and'Rare'or'Common'end
 f.configs.Weak.rarity='WrongStaticTier';f.configs.Rare.rarity='Rare'
 f.configs.Limited={kind='Unit',limited=true,rarity='Exclusive'}
 f.configs.Unknown={kind='Unit'}
 f.configs.Broken={kind='Unit',getRarity=function()error('unavailable')end,rarity='Common'}
 f.d.Inventory={c=f.entry('Weak'),r=f.entry('Rare'),m=f.entry('Weak',1,{mutation='Gold'}),ex=f.entry('Limited'),u=f.entry('Unknown'),bad=f.entry('Broken'),
  p=f.entry('Weak'),t=f.entry('Rare'),h=f.entry('Weak'),l=f.entry('Weak',1,{locked=true}),fav=f.entry('Rare',1,{favorite=true}),k=f.entry('Rare')}
 f.d.Slots={{unitId='p'}};f.d.TowerTeam={'t'};f.d.EquippedUnit='h';f.cfg.KeepIds.k=true
 check(#f.ctl.Preview('Sell')==6,'empty rarity selection did not preserve Sell All and usage protections')
 f.cfg.SellRarities={Common=true};local items=f.ctl.Preview('Sell')
 check(#items==1 and items[1].id=='c','Common selection included another tier, unknown rarity, or protected units')
 check(f.ctl.SellSummary():find('Sell [Common]',1,true),'selected tier absent from live sale summary')
 f.cfg.SellRarities={Rare=true};items=f.ctl.Preview('Sell')
 check(#items==2 and items[1].rarity=='Rare'and items[2].rarity=='Rare','native mutation-aware rarity did not match filtering')
 f.cfg.SellRarities={Common=true,Rare=true};check(#f.ctl.Preview('Sell')==3,'multiple selected tiers not combined')
 f.cfg.SellRarities={Exclusive=true};items=f.ctl.Preview('Sell');check(#items==1 and items[1].id=='ex','explicit limited rarity not selectable')
 f.cfg.KeepBest=0;f.cfg.KeepCopies=0;f.cfg.SkipMutations=false;f.cfg.FuseChanceMax=1000
 check(#f.ctl.Preview('Fuse')==3,'sell rarity selection affected fusion')
 f.cfg.SellRarities={Common=true};f.d.Inventory.m.attributes.mutation=nil
 check(#f.ctl.Preview('Sell')==2,'rarity changes were not read from live unit attributes')
 f.cfg.SellRarities={};check(#f.ctl.Preview('Sell')==6,'clearing selections did not restore Sell All')
 local choices=P.RarityOptions({Refs={Common='Common',Rare='Rare',Secret1='Secret I'},Get=function(name)
  return {sortOrder=({Common=1,Rare=3,['Secret I']=10})[name]}
 end},P.Units(f.d,f.c.Registry),{Haunted=true})
 check(choices[1]=='Common'and choices[2]=='Rare'and choices[3]=='Secret I','rarity choices did not use native tier values / order')
 check(table.find(choices,'Exclusive')and table.find(choices,'Haunted'),'missing catalog / selected tiers were dropped from choices')
end
do
 local f=fixture();f.configs.Weak.rarity='Common';f.configs.Rare.rarity='Rare'
 f.d.Inventory={c=f.entry('Weak'),r=f.entry('Rare')};f.cfg.SellRarities={Common=true}
 f.server(function(_,key,args)if key=='SellInventory'then
  check(#args[1]==1,'rarity filter submitted more than selected tier')
  local id=args[1][1];f.d.Inventory[id]=nil;return 100,1
 end end)
 f.ctl.Set('Sell',true);f.step();check(f.packets[1].args[1][1]=='c','Auto Sell did not use Common selection')
 f.cfg.SellRarities={Rare=true};f.step(2)
 check(f.packets[2].args[1][1]=='r'and f.ctl.Report.Jobs.Sell.Units==2,'running seller did not apply changed tiers to the next batch')
end
do
 local f=fixture();local events={};f.ctx.OnTowerReward=function(event)events[#events+1]=event end
 f.cfg.TowerChoice='Test'
 f.server(function(_,key)
  if key=='PlayTower'then return true end
  if key=='CompleteTowerFloor'then return {{action='floorCompleted',floor=9,rewards={Gems=3,['Trait Reroll']=1,Invalid=-2,Infinite=math.huge}},
   {action='ended',rewards={Gems=100}}}end
 end)
 f.ctl.Set('Tower',true);f.step();f.cfg.TowerChoice='Front Yard';f.step(6)
 check(#events==1 and events[1].Tower=='Test'and events[1].Floor==9,'floor notice mislabeled running Tower or duplicated end summary')
 check(#events[1].Items==2 and events[1].Items[1].Name=='Gems'and events[1].Items[1].Amount==3,'notice included unconfirmed/end-total/invalid rewards')
 check(#f.ctl.Report.TowerRewards==1,'confirmed rewards absent from exported report')
 local g=fixture();g.cfg.WingChoice='Front Yard';g.ctx.OnTowerReward=function()error('UI unavailable')end
 g.server(function(_,key)if key=='PlayTower'then return true elseif key=='CompleteTowerFloor'then return {{action='floorCompleted',floor=1,rewards={Candy=1,Pumpkins=1}}}end end)
 g.ctl.Set('Haunted',true);g.step();g.step(6)
 check(g.ctl.Report.PresentationError and g.ctl.Report.Jobs.Haunted.Errors==0 and g.ctl.Report.Jobs.Haunted.Confirmed==1,'notice error stopped farming')
 check(g.ctl.Report.TowerRewards[1].Job=='Haunted','Haunted reward report mixed with regular Tower')
end
do
 local f=fixture();f.d.Dice='Water';f.d.OwnedDice.Fire=true;f.cfg.DiceChoice='Fire'
 f.ctl.Set('Dice',true);f.step()
 check(#f.packets==1 and f.packets[1].key=='EquipDice'and f.packets[1].args[1]=='Fire','explicit owned lower-luck dice was ignored or repurchased')
end
do
 local f=fixture();f.ctl.BindEvents()
 local part={Position=V.new(0,0,0)};local door={key=part,position=part.Position,front=V.new(1,0,0),range=14}
 f.ctx.Doors=function()return {door}end;f.ctx.Position=function()return V.new(30,0,0)end;f.ctx.DoorInitialReady=function()return 0 end
 local visits=0
 f.ctx.MoveDoor=function(_,active)
  if not active()then return false,'Cancelled'end
  visits+=1
  if visits%2==0 then
   f.listeners['TrickOrTreatService/Knocked'](part,1,f.time()+30)
   f.listeners['TrickOrTreatService/Landed'](part,10)
  end
  return true,'Arrived'
 end
 f.ctl.Set('Doors',true)
 for _=1,120 do f.step(31)end
 check(f.time()>3700 and f.cfg.Doors and f.ctl.Report.Jobs.Doors.Confirmed==120,'long-running door collector stopped after repeated cooldowns')
 check(f.ctl.Report.Jobs.Doors.Candy==1200 and visits==240,'continuous collector lost confirmed rewards / door visits')
 local before=visits;f.ctl.Set('Doors',false);f.step(120)
 check(not f.cfg.Doors and visits==before,'explicit off restarted door collection')
end
do
 local f=fixture();f.ctl.BindEvents()
 local part={Position=V.new(0,0,0)};local door={key=part,position=part.Position,front=V.new(1,0,0),range=14}
 f.ctx.Doors=function()return {door}end;f.ctx.Position=function()return V.new(30,0,0)end;f.ctx.DoorInitialReady=function()return 0 end
 local workers={};local visits=0
 f.ctx.Spawn=function(fn)
  local co=coroutine.create(fn);workers[#workers+1]=co;check(coroutine.resume(co),'door worker failed to start')
 end
 f.ctx.MoveDoor=function(_,active)
  visits+=1
  if visits==1 or visits==3 then coroutine.yield('movement pending')end
  if not active()then return false,'Cancelled'end
  if visits==3 then f.listeners['TrickOrTreatService/Knocked'](part,1,f.time()+30)end
  return true,'Arrived'
 end
 f.ctl.Set('Doors',true);f.step()
 check(f.ctl.Report.Jobs.Doors.Busy and #workers==1,'fixture did not hold the first route worker')
 f.step(61)
 check(f.cfg.Doors and f.ctl.Report.Jobs.Doors.Recoveries==1 and not f.ctl.Report.Jobs.Doors.Busy,'stalled route was not retired while keeping automation on')
 f.step(1)
 check(#workers==2 and f.ctl.Report.Jobs.Doors.Busy,'collector did not start a replacement route')
 check(coroutine.resume(workers[1]),'late retired worker failed to finish')
 check(f.ctl.Report.Jobs.Doors.Busy and #workers==2,'late worker cleared newer worker ownership')
 check(coroutine.resume(workers[2]),'replacement route failed to finish')
 check(f.cfg.Doors and f.ctl.Report.Jobs.Doors.Confirmed==1 and not f.ctl.Report.Jobs.Doors.Busy,'replacement route did not continue farming')
 f.ctl.StopAll();f.step(120)
 check(not f.cfg.Doors and #workers==2,'watchdog restarted the collector after Stop All')
end
do
 local f=fixture();local workers={}
 f.ctx.Spawn=function(fn)local co=coroutine.create(fn);workers[#workers+1]=co;check(coroutine.resume(co),'stream worker failed')end
 f.ctx.Position=function()return V.new(0,0,0)end;f.ctx.Doors=function()return {}end
 f.ctx.StreamEvent=function()coroutine.yield('stream pending')end
 f.ctl.Set('Doors',true);f.step()
 check(f.ctl.Report.Jobs.Doors.Busy,'fixture did not stall event streaming')
 f.ctl.Set('Doors',false);f.ctl.Set('Doors',true);f.step()
 check(#workers==2 and f.ctl.Report.Jobs.Doors.Busy,'manual off/on remained blocked by the old worker')
 f.ctl.Set('Doors',false)
 for _,co in ipairs(workers)do check(coroutine.resume(co),'cancelled worker failed to finish')end
 f.step(120)
 check(not f.cfg.Doors and not f.ctl.Report.Jobs.Doors.Busy and #workers==2,'late workers or recovery ignored explicit off')
end
print('PASS Anime Dice planning, network contracts, confirmation, stop and event behavior: '..checks..' checks')
