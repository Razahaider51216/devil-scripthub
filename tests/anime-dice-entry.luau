local nativeCompile=loadstring
local function setup(place,corrupt,storage)
 local work={};local downloads=0;local libraryCalls=0
 local clockNow=100
 local scope={DevilHubSilverLogo='devil-logo.png',DevilHubBlueGui={Version='devil-blue-20261019-10',Stopped=false}}
 local language='EN';scope.DevilHubBlueGui.Get=function()return {Language=language}end
 local testTask={spawn=function(fn)work[#work+1]=fn end,defer=function(fn)work[#work+1]=fn end,
  wait=function(n)return coroutine.yield(n)end,delay=function()end}
 local function node(class,name,parent)
  local obj=Instance.new(class);obj.Name=name
  if class=='TextButton'then obj.MouseButton1Click=signal()end
  obj.Parent=parent;return obj
 end
 local rs=node('ReplicatedStorage','ReplicatedStorage')
 local core=node('CoreGui','CoreGui')
 local features=node('Folder','Features',node('Folder','Framework',rs))
 local function module(branch,name,value)local obj=node('ModuleScript',name,node('Folder',branch,features));obj.Export=value;return obj end
 local data={Money=1000,Inventory={},Slots={},AutoRoll=false,AutoSell=0,AutoTower='',TowerTeam={},Rebirth=0,Rolls=0,Halloween={},
  ProtectedTraits={},ProtectedGrades={},ProtectedQuirks={},Dice='Basic',OwnedDice={Basic=true}}
 local proxy=setmetatable({},{__index=function(_,key)return function()return data[key]end end})
 module('Data','DataController',proxy)
 module('Unit','UnitController',{EquippedUnit=function()return data.CarriedId end})
 local rarityModule=node('ModuleScript','Rarities',node('Folder','Other',features.Parent))
 rarityModule.Export={Refs={Common='Common',Rare='Rare',Secret1='Secret I'},Get=function(name)return {sortOrder=({Common=1,Rare=3,['Secret I']=10})[name]}end}
 local unitSpecs={}
 module('Inventory','EntryRegistry',{getEntryConfig=function(name)
  if unitSpecs[name]then return unitSpecs[name]end
  if name=='Weak'then return {kind='Unit',chance=function()return 10 end,income=function()return 1 end,getRarity=function(a)return a.mutation=='Gold'and'Rare'or'Common'end}end
  if name=='Pumpkin Spin'or name=="Witch's Jackpot"or name=='Candy Pot I'or name=='Gems'then return {kind='Boost',image='rbxassetid://123456'}end
  if name=='Lucky Spin'then return {kind='Spin',image='rbxassetid://654321'}end
 end})
 module('Buffs','BuffsConfig',{GetBuff=function(name)return {image='rbxassetid://777'}end})
 module('Monetization','MonetizationConfig',{Gamepasses={Luck={image='rbxassetid://999'}}})
 module('Quests','QuestConfig',{Shop={{name='Gems',amount=10,tickets=1},{name='Luck',gamepass=true,tickets=199}}})
 local dice={Basic={luck=1,image='rbxassetid://1'},Fire={luck=5,price=2500,image='rbxassetid://2'},Water={luck=10,price=10000,image='rbxassetid://3'}}
 local offers={{name='Pumpkin Spin',candy=2500},{name='Candy Pot I',candy=500},{name="Witch's Jackpot",candy=50000}}
 module('Rolling','Dice',{GetAll=function()return dice end,GetDefault=function()return 'Basic'end})
 module('Halloween','HalloweenShop',offers)
 local wings={WING_FLOORS=50,Wings={{name='Front Yard',firstFloor=1,image='rbxassetid://125258111031038'},
  {name='The Abyss',firstFloor=251,endless=true,image='rbxassetid://95391097280127'}}}
 local towerSpecs={Test={},['Dragon Tower']={order=1,image='rbxassetid://85435271739310',difficulty={name='Easy'},maxFloors=100},
  ['Cursed Tower']={order=2,image='rbxassetid://104197656322827',difficulty={name='Medium'},maxFloors=100},
  ['Shadow Tower']={order=6,image='rbxassetid://103129754283172',difficulty={name='Abyssal'},maxFloors=150},
  ['Infinity Tower']={order=99,image='rbxassetid://89992622754247',difficulty={name='Infinity'}},
  ['Front Yard']={event='Halloween',image=wings.Wings[1].image,wing=wings.Wings[1],maxFloors=50,difficulty={name='Floors 1-50'}}}
 module('Halloween','HauntedHouse',wings)
 module('Towers','Towers',{GetAll=function()return towerSpecs end})
 module('Towers','TowerRefs',{ActionWaitTime={floorCompleted=.24,ended=0}})
 local pumpkin={Units={{id='Mummy Loffy',power=5e9},{id='Skeleton Sanjo',power=78e9},{id='Vampire Gujo',power=1e29}}}
 module('Halloween','PumpkinDice',pumpkin)
 local network=node('Folder','Network',rs)
 local roll=node('Folder','RollService',network)
 local remote=node('RemoteEvent','SetAutoRoll',node('Folder','RE',roll));remote.Sent={}
 local towers=node('Folder','Towers',network);local towerEvents=node('Folder','RE',towers);local towerFunctions=node('Folder','RF',towers)
 local equip=node('RemoteEvent','EquipBestTowerTeam',towerEvents);equip.Sent={}
 local pumpkinRemote=node('RemoteEvent','SetAutoSell',node('Folder','RE',node('Folder','PumpkinDiceService',network)));pumpkinRemote.Sent={}
 for _,name in ipairs({'PlayTower','CompleteTowerFloor','CancelTower'})do node('RemoteFunction',name,towerFunctions)end
 local floorActions={{action='floorCompleted',floor=9,rewards={Gems=3,['Unknown Relic']=1}}}
 function methods:InvokeServer(...)
  if self.Name=='PlayTower'then return true elseif self.Name=='CompleteTowerFloor'then return floorActions end
 end
 function methods:FireServer(...)
  self.Sent[#self.Sent+1]=table.pack(...)
  if self==remote then data.AutoRoll=(...)end
 end
 local player=node('Player','Player');player.UserId=storage and storage.UserId or 77
 local function copy(value)
  if type(value)~='table'then return value end
  local result={};for k,v in pairs(value)do result[k]=copy(v)end;return result
 end
 local http={JSONEncode=function(_,value)
  if not storage then return '{}'end
  storage.Serial=(storage.Serial or 0)+1;local token='json'..storage.Serial
  storage.Encoded[token]=copy(value);return token
 end,JSONDecode=function(_,text)return copy(assert(storage and storage.Encoded[text],'invalid JSON'))end}
 local game={GameId=place==113290951185459 and 10708913337 or 1,PlaceId=place,
  GetService=function(_,name)
   if name=='ReplicatedStorage'then return rs elseif name=='Players'then return {LocalPlayer=player}
    elseif name=='HttpService'then return http end
   error('Unexpected service '..name)
  end}
 function game:HttpGet(url)
  downloads+=1
  assert(url:find('/OuroFlow/',1,true),'unexpected dependency URL')
  return corrupt and 'corrupt' or ouroSource
 end
 local objects={};local window
 local function makeWidget(class,host,info)
  local frame=node('Frame','Control',host)
  local label=node('TextLabel','Title',frame);label.Text=info.Name or info.Text or''
  local widget={_frame=frame,Callback=info.Callback,Value=info.CurrentValue,Options=info.Options or{}}
  if class=='Dropdown'then
   widget.Popup=node('Frame','Popup',window.Body);widget.Rows={}
  end
  function widget:Set(v,silent)
   self.Value=v
   if class=='Label'then label.Text=tostring(v)end
   if not silent and self.Callback then self.Callback(v)end
  end
  function widget:Refresh(values,keep,silent)
   check(keep==true and silent==true,'choice refresh invoked callbacks / dropped selections')
   self.Options=values
   if self.Rows then
    local present={};for _,value in ipairs(values)do present[value]=true end
    for value,row in pairs(self.Rows)do if not present[value]then row:Destroy();self.Rows[value]=nil end end
    for _,value in ipairs(values)do if not self.Rows[value]then
     local row=node('TextButton','Option',self.Popup);row.Size=UDim2.new(1,0,0,30)
     local text=node('TextLabel','OptionLabel',row);text.Text=value;text.ZIndex=46
     self.Rows[value]=row
    end end
   end
  end
  function widget:Destroy()frame:Destroy()end
  objects[info.Name or info.Text or class]=widget
   if storage and storage.InitialCallbacks and class=='Toggle'and info.Callback then info.Callback(info.CurrentValue)end
  return widget
 end
 local function group(parent,name)
  local host=node('Frame',name,parent)
  local label=node('TextLabel','Title',host);label.Text=name
  local g={}
  for _,kind in ipairs({'Toggle','Input','Dropdown','Button','Label','Paragraph'})do
   g['Create'..kind]=function(_,info)return makeWidget(kind,host,info)end
  end
  return g
 end
 local library={CreateWindow=function(_,info)
  libraryCalls+=1
  check(info.Backdrop==false and info.Loading==false and info.UnsupportedExecutor==false,'entry enabled a screen-covering startup layer')
  check(type(info.Theme)=='table'and info.Theme.Accent==Color3.fromRGB(164,221,255),'entry did not supply DEVIL blue palette')
  local screen=node('ScreenGui','DEVIL HUB',core)
  local root=node('Frame','Window',screen)
  local w={Gui=screen,Body=root}
  function w:CreateTab(info)
   local host=node('Frame',info.Name,root)
   return {CreateGroupbox=function(_,args)return group(host,args.Name)end}
  end
  function w:Destroy()screen:Destroy()end
  window=w;return w
 end}
 local env=setmetatable({game=game,workspace={GetServerTimeNow=function()return clockNow end,CurrentCamera={ViewportSize=Vector2.new(1280,720)}},task=testTask,
  os=setmetatable({clock=function()return clockNow end},{__index=os}),
  getgenv=function()return scope end,require=function(obj)
   if storage and storage.FailModules and storage.FailModules[obj.Name]then error('Temporary module failure: '..obj.Name)end
   return assert(obj.Export,'missing module')
  end,
  Instance={new=function(class)
   local obj=Instance.new(class);if class=='TextButton'then obj.MouseButton1Click=signal()end;return obj
  end},Color3=Color3,ColorSequence=ColorSequence,UDim2=UDim2,UDim=UDim,Vector2=Vector2,Enum=Enum,
  warn=function()end,print=function()end},{__index=getfenv(0)})
 if storage then
  env.isfile=function(name)return storage.Files[name]~=nil end
  env.readfile=function(name)return assert(storage.Files[name],'file missing')end
  env.writefile=function(name,text)storage.Files[name]=text end
 end
 env.loadstring=function(source,label)
  assert(source==ouroSource and label=='DEVIL HUB / Anime Dice GUI','entry changed native compile boundary')
  return function()return library end
 end
 local originalCompiler=env.loadstring;local originalHttp=game.HttpGet
 local fn=assert(nativeCompile(entrySource));setfenv(fn,env)
 return {Run=fn,scope=scope,work=work,objects=objects,remote=remote,env=env,data=data,offers=offers,dice=dice,towerSpecs=towerSpecs,wings=wings,unitSpecs=unitSpecs,pumpkin=pumpkin,pumpkinRemote=pumpkinRemote,features=features,
  advance=function(n)clockNow+=n end,now=function()return clockNow end,actions=function(value)floorActions=value end,
  compiler=originalCompiler,http=originalHttp,game=game,language=function(v)language=v end,
  counts=function()return downloads,libraryCalls end,window=function()return window end}
end
do
 local storage={Files={},Encoded={}}
 local f=setup(113290951185459,false,storage);local app=f.Run()
 table.remove(f.work,1)()
 check(not app.Report.InitializationError and app.Settings.Report.Status=='No saved settings found.','missing settings failed startup')
 check(app.Window.Body:FindFirstChild('Settings')~=nil,'settings controls were not placed in Settings tab')
 f.objects['Money reserve'].Callback('4321')
 f.objects['Rarities to sell (empty = all)'].Callback({'Rare'})
 f.objects['Keep mutated / variant units for fusion'].Callback(false)
 f.objects['Use game Auto Roll'].Callback(false)
 f.objects['Codes (comma separated)'].Callback('CODE1, CODE2')
 f.objects['Gear priority'].Callback('Damage')
 f.objects['Auto Trick or Treat'].Callback(true)
 f.objects['Discord webhook URL'].Callback('https://discord.com/api/webhooks/123/fake-token')
 f.objects['Embed information'].Callback({'Money','Character','Image'})
 f.objects['Notify rarities (empty = all)'].Callback({'Rare'})
 f.objects['Enable Webhook'].Callback(true)
 app.Config.KeepIds={['unit-stable-id']=true};app.Config.SelectedUnit='unit-stable-id'
 f.objects['Save Settings'].Callback();table.remove(f.work,#f.work)()
 check(storage.Files[app.Settings.Report.File]~=nil and app.Settings.Report.Status=='Settings saved. They will load next run.','Save Settings button did not persist profile')
 app.Destroy()
 storage.InitialCallbacks=true
 local g=setup(113290951185459,false,storage);local restored=g.Run()
 check(not restored.Config.Doors,'saved automation started before game data was ready')
 table.remove(g.work,1)()
 check(not restored.Report.InitializationError and restored.Settings.Restored,'saved profile was not automatically restored')
 check(restored.Config.MoneyReserve==4321 and restored.Config.SellRarities.Rare and restored.Config.Doors,'numeric / rarity / enabled feature preferences not restored')
 check(restored.Config.SelectedUnit=='unit-stable-id'and restored.Config.KeepIds['unit-stable-id'],'inventory IDs were replaced by labels / missing inventory dropped protection')
 check(g.objects['Money reserve'].Value=='4321'and g.objects['Auto Trick or Treat'].Value==true,'visible settings disagreed with restored config')
 check(restored.Config.WebhookEnabled and restored.Config.WebhookRarities.Rare and restored.Config.WebhookFields.Image and not restored.Config.WebhookFields.Level,'webhook filters did not survive settings load')
 check(g.objects['Enable Webhook'].Value==true and g.objects['Discord webhook URL'].Value=='https://discord.com/api/webhooks/123/fake-token','webhook settings widgets not restored')
 check(g.objects['Keep mutated / variant units for fusion'].Value==false and g.objects['Use game Auto Roll'].Value==false,'false boolean setting restored as a true string')
 check(g.objects['Codes (comma separated)'].Value=='CODE1, CODE2'and g.objects['Gear priority'].Value=='Damage','code list / item choice not restored to widgets')
 check(#g.remote.Sent==0,'silent settings restoration invoked feature callbacks')
 g.objects['Money reserve'].Callback('9999');g.objects['Load Saved Settings'].Callback();table.remove(g.work,#g.work)()
 check(restored.Config.MoneyReserve==4321 and restored.Config.Doors,'manual Load Saved Settings missed saved state')
 g.objects['Reset Saved Settings'].Callback();table.remove(g.work,#g.work)()
 check(restored.Config.MoneyReserve==0 and not restored.Config.Doors and g.objects['Auto Trick or Treat'].Value==false,'Reset Saved Settings did not clear current automation / filters')
 check(not restored.Config.WebhookEnabled and restored.Config.WebhookURL=='' and next(restored.Config.WebhookRarities)==nil,'settings reset left webhook enabled')
 restored.Destroy()
 local h=setup(113290951185459,false,storage);local reset=h.Run();table.remove(h.work,1)()
 check(reset.Config.MoneyReserve==0 and not reset.Config.Doors,'reset profile did not persist across restart')
 reset.Destroy()
 -- Re-save an enabled feature, then explicitly stop while the next run loads.
 local seed=setup(113290951185459,false,storage);local first=seed.Run();table.remove(seed.work,1)()
 first.Core.Set('Doors',true);check(first.Settings.Save(),'failed to prepare enabled profile');first.Destroy()
 local stopped=setup(113290951185459,false,storage);local second=stopped.Run()
 stopped.objects['Stop all automation'].Callback();table.remove(stopped.work,#stopped.work)()
 table.remove(stopped.work,1)()
 check(not second.Config.Doors and not second.Settings.Restored,'automatic restore ignored Stop All during startup')
 second.Destroy()
 local late=setup(113290951185459,false,storage);late.data.Money=nil
 local waiting=late.Run();table.remove(late.work,1)()
 check(not waiting.Config.Doors and not waiting.Settings.Restored,'saved automation started before the first player snapshot')
 late.data.Money=1000
 local loop=coroutine.create(table.remove(late.work,1));check(coroutine.resume(loop),'late data restore failed')
 check(waiting.Settings.Restored and waiting.Config.Doors,'saved settings did not resume when player data arrived')
 waiting.Destroy();check(coroutine.resume(loop),'late-data loop did not stop')
 storage.UserId=88
 local other=setup(113290951185459,false,storage);local isolated=other.Run();table.remove(other.work,1)()
 check(not isolated.Settings.Restored and not isolated.Config.Doors,'another account inherited saved automation')
 isolated.Destroy()
end
do
 local f=setup(1,false);local ok=pcall(f.Run)
 check(not ok and f.counts()==0,'wrong game downloaded or ran dependencies')
end
do
 local f=setup(113290951185459,true);local ok=pcall(f.Run)
 check(not ok and f.scope.DevilAnimeDiceStarting==nil,'corrupt GUI left startup guard stuck')
 check(f.scope.DevilAnimeDiceTest==nil,'corrupt GUI left partial automation running')
end
do
 local f=setup(113290951185459,false);local app=f.Run()
 check(app and f.scope.DevilAnimeDiceTest==app,'test entry did not publish its controller')
 check(#f.remote.Sent==0,'entry startup fired an action')
 check(f.objects['Auto Pumpkin Dice']and f.objects['Auto Trick or Treat']and f.objects['Auto Haunted House'],'Halloween controls missing')
 check(f.objects['Auto Trait']and f.objects['Auto Buy Quest Shop Item']and f.objects['Auto Fuse Surplus Units'],'supported systems missing from GUI')
 check(app.Window.Gui:GetAttribute('DevilHubPresentation')==true,'DEVIL theme ownership marker missing')
 local community=app.Presentation.CommunityCard
 check(community and community.Parent and community.AutomaticSize==Enum.AutomaticSize.None,'Discord card missing / uncontrolled height')
 check(#community.DiscordLogo:GetChildren()>0 and community.CommunityBrand.RichText,'Discord silhouette / two-tone brand missing')
 check(community.DiscordInvite.Text=='https://discord.gg/fDwPCmpkkh'and community.DiscordInvite.TextEditable==false,'Discord invitation incorrect / editable')
 local copy=f.objects['Copy Discord Invite'];local status=f.objects['Invite ready to copy.']
 copy.Callback();check(status.Value=='Clipboard unavailable. Select and copy the invite above.','missing clipboard API did not offer manual copy')
 local copied
 f.env.setclipboard=function(text)copied=text end
 copy.Callback();check(copied==community.DiscordInvite.Text and status.Value=='Discord invite copied!','Discord button copied wrong invitation / showed wrong status')
 f.env.setclipboard=function()error('executor denied clipboard')end
 copy.Callback();check(status.Value=='Clipboard unavailable. Select and copy the invite above.','clipboard failure escaped callback')
 f.env.setclipboard=nil;f.env.toclipboard=function(text)copied=text end;copied=nil
 copy.Callback();check(copied==community.DiscordInvite.Text,'alternate clipboard API unsupported')
 -- Run initialization only. The second queued function is the periodic UI loop.
 local init=table.remove(f.work,1);init()
 check(app.Report.InitializationError==nil,'entry failed initialization')
 check(#f.remote.Sent==0,'initialization enabled automation')
 local loop=coroutine.create(table.remove(f.work,1))
 check(coroutine.resume(loop),'first status refresh failed')
 check(not app.Report.LastTickError,'status update crashed')
 f.language('TH');check(coroutine.resume(loop),'Thai language refresh failed')
 local label=f.objects['Auto Roll']._frame:FindFirstChild('Title')
 check(label.Text=='สุ่มลูกเต๋าอัตโนมัติ','shared language selection not reflected in test GUI')
 check(community.CommunityHeading.Text=='เข้าร่วม Discord ของเรา','Discord did not follow shared language selection')
 f.language('EN');check(coroutine.resume(loop),'English language refresh failed')
 check(label.Text=='Auto Roll','test GUI did not return to English')
 local before=f.counts();check(f.Run()==app and f.counts()==before,'duplicate run created another GUI/download')
 check(f.objects['Auto Sell All Unused Units']and not f.objects['Auto Sell Filtered Units']and not f.objects['Sell maximum chance (0 = off)'],'old chance sell controls were not replaced')
 check(not f.objects['Use game sell threshold']and not f.objects['Disable game Auto Sell'],'old game sell threshold controls remained')
 check(f.objects['Keep best units for fusion']and f.objects['Keep copies per character for fusion'],'fusion controls were removed with old selling UI')
 f.objects['Fuse maximum chance (0 = off)'].Callback('1 / 1,000')
 check(app.Config.FuseChanceMax==1000 and app.Config.SellChanceMax==nil,'fusion parser or removal of sell threshold failed')
 f.data.CarriedId='held'
 f.data.Inventory={held={name='Weak',amount=1,attributes={}},unused={name='Weak',amount=1,attributes={}}}
 local snapshot=app.Core.Preview('Sell')
 check(#snapshot==1 and snapshot[1].id=='unused'and not app.Report.LastTickError,'live carried unit controller lookup failed to protect held unit')
 local rarities=f.objects['Rarities to sell (empty = all)']
 check(rarities and #rarities.Options==3 and rarities.Options[1]=='Common'and rarities.Options[3]=='Secret I','native rarities were not loaded into selection menu')
 rarities.Callback({'Rare'})
 check(#app.Core.Preview('Sell')==0,'rarity GUI did not restrict actual sale preview')
 f.data.Inventory.unused.attributes.mutation='Gold'
 check(#app.Core.Preview('Sell')==1,'rarity GUI ignored current mutation-aware rarity')
 check(coroutine.resume(loop)and app.Config.SellRarities.Rare==true,'silent refresh reset the selected sell tiers')
 rarities.Callback({})
 check(next(app.Config.SellRarities)==nil and #app.Core.Preview('Sell')==1,'clearing rarity GUI did not restore Sell All')
 check(f.objects['Event movement']==nil and app.Config.DoorMovement==nil,'movement mode selector was not removed')
 f.objects['Start Event Collection'].Callback()
 table.remove(f.work,#f.work)()
 check(app.Config.Doors and app.Config.Pass and app.Config.EventQuests,'event start did not enable collection / claims')
 check(not app.Config.CandyShop and not app.Config.Pumpkin,'event collection unexpectedly enabled purchases')
 f.objects['Stop Event Collection'].Callback()
 table.remove(f.work,#f.work)()
 check(not app.Config.Doors and not app.Config.Pass and not app.Config.EventQuests,'event stop left work enabled')
 f.objects['Auto Roll'].Callback(true);app.Core.Tick()
 local worker=table.remove(f.work,#f.work);worker()
 check(#f.remote.Sent==1 and f.remote.Sent[1][1]==true,'GUI toggle not connected to actual game action')
 check(f.env.loadstring==f.compiler and f.game.HttpGet==f.http,'entry replaced compiler / HTTP APIs')
 app.Destroy()
 check(app.Stopped and app.Core.Stopped and f.scope.DevilAnimeDiceTest==nil,'entry unload left automation alive')
 check(#f.remote.Sent==2 and f.remote.Sent[2][1]==false,'entry unload failed to restore owned Auto Roll')
 check(coroutine.resume(loop),'closed UI loop crashed')
 check(coroutine.status(loop)=='dead','closed UI loop kept running')
end
do
 local f=setup(113290951185459,false);local destroyed=0
 f.scope.DevilAnimeDiceTest={Version='anime-dice-test-20261020-1',Stopped=false,Destroy=function()destroyed+=1 end}
 local app=f.Run()
 check(destroyed==1 and app.Version=='anime-dice-webhook-20261022-1','rerun retained previous broken release')
 app.Destroy()
end
do
 local f=setup(113290951185459,false);local app=f.Run();table.remove(f.work,1)()
 local p=app.Presentation;local shop=f.objects['Candy shop item'];local dice=f.objects['Dice selection']
 check(p.ShopPopup==shop.Popup and p.DicePopup==dice.Popup and p.ShopPopup~=p.DicePopup,'decorated selector captured the wrong popup')
 for _,offer in ipairs(f.offers)do
  local row=shop.Rows[offer.name];local price=row:FindFirstChild('CandyPrice')
  check(row:FindFirstChild('ItemIcon').Image=='rbxassetid://123456','shop item used a placeholder instead of game artwork')
  check(price and price:FindFirstChild('DevilCandyIcon'):GetAttribute('DevilCandySvg')==true,'shop row missing SVG candy icon')
  check(price.CandyAmount.Text==({['Pumpkin Spin']='2,500',['Candy Pot I']='500',["Witch's Jackpot"]='50,000'})[offer.name],'shop candy price formatted incorrectly')
  check(row.OptionLabel.Position.X.Offset==42 and row.OptionLabel.Size.X.Offset==-158,'shop name overlaps icon or price')
 end
 shop.Callback("Witch's Jackpot");check(app.Config.OfferChoice=="Witch's Jackpot",'icon/price presentation changed actual purchase key')
 f.offers[1].candy=3000;p.RefreshShop(f.offers)
 check(shop.Rows['Pumpkin Spin'].CandyPrice.CandyAmount.Text=='3,000','shop prices did not update from live offers')
 local icons=0;for _,node in ipairs(shop.Rows['Pumpkin Spin']:GetChildren())do if node.Name=='CandyPrice'then icons+=1 end end
 check(icons==1 and app.Config.OfferChoice=="Witch's Jackpot",'refresh duplicated prices or reset selected purchase')
 check(dice.Rows.Fire.DiceIcon.Image=='rbxassetid://2'and dice.Rows.Fire.DicePrice.MoneyPrice.Text=='$2,500','dice icon or price missing')
 check(dice.Rows.Basic.DicePrice.Ownership.Text=='Equipped'and dice.Rows.Fire.DicePrice.Ownership.Text=='Not purchased','initial dice ownership incorrect')
 dice.Callback('Fire');check(app.Config.DiceChoice=='Fire'and #f.remote.Sent==0,'selecting dice auto-purchased or changed value')
 f.data.OwnedDice.Fire=true;p.UpdateDiceState(f.data)
 check(dice.Rows.Fire.DicePrice.Ownership.Text=='Purchased','live owned dice not marked purchased')
 f.data.Dice='Fire';p.UpdateDiceState(f.data)
 check(dice.Rows.Fire.DicePrice.Ownership.Text=='Equipped'and dice.Rows.Basic.DicePrice.Ownership.Text=='Purchased','equipped dice state did not switch')
 p.SetLanguage('TH')
 check(dice.Rows.Fire.DicePrice.Ownership.Text=='กำลังใช้อยู่'and dice.Rows.Basic.DicePrice.Ownership.Text=='ซื้อแล้ว','dice badges ignored Thai language')
 p.SetLanguage('EN');p.RefreshDice({GetAll=function()return f.dice end,GetDefault=function()return 'Basic'end},f.data)
 check(app.Config.DiceChoice=='Fire','dice refresh changed selection')
 app.Config.TowerChoice='Test';app.Core.Set('Tower',true);app.Core.Tick()
 local start=coroutine.create(table.remove(f.work,#f.work))
 check(coroutine.resume(start),'Tower start worker failed before game wait');f.advance(1.1)
 check(coroutine.resume(start)and coroutine.status(start)=='dead','Tower start worker failed after game wait')
 f.advance(6);app.Core.Tick();table.remove(f.work,#f.work)()
 check(not app.Report.PresentationError and #p.Cards==1,'real Tower floor callback failed to show a reward card')
 local card=p.Cards[1]
 check(card.Stage.Text=='Test  ·  Floor 9'and #card.Event.Items==2,'card displayed wrong Tower/floor or reward count')
 check(card.Frame.DevilHubLogo.Image=='devil-logo.png'and card.Frame.Brand.Text=='DEVIL HUB','Tower card missing hub branding')
 local rows=card.List:GetChildren()
 check(rows[1].ItemName.Text=='Gems'and rows[1].ItemAmount.Text=='×3'and rows[1].ItemIcon.Image=='rbxassetid://123456','reward name, amount or native image wrong')
 check(rows[2].ItemIconFallback~=nil,'unknown reward had no fallback icon')
 p.Notify({Tower='Front Yard',Floor=2,Items={}})
 check(#p.Cards==2 and p.Cards[1].Empty.Text=='No drops this floor','no-drop floor claimed a reward or did not show separately')
 p.Cards[1].Collapse.MouseButton1Click:Fire()
 check(p.Collapsed and not card.List.Visible and card.Frame.Size.Y.Offset==50,'collapse did not hide rewards / shrink stack')
 check(card.Stage.Visible and card.Frame.DevilHubLogo.Visible and card.Frame.Brand.Visible,'collapse hid the tower / logo header')
 check(#card.Event.Items==2 and p.Cards[1].Collapse.Text=='+','collapse discarded rewards or did not offer expansion')
 f.advance(2);p.Cards[1].Collapse.MouseButton1Click:Fire()
 check(not p.Collapsed and card.List.Visible and card.Frame.Size.Y.Offset>50,'expand did not restore complete reward card')
 check(card.Expires>=f.now()+7,'interacting with notice did not refresh reading time')
 p.Cards[1].Collapse.MouseButton1Click:Fire()
 p.SetLanguage('TH');check(p.Cards[1].Stage.Text=='Front Yard  ·  ชั้น 2','Tower floor did not use selected language')
 local many={};for i=1,20 do many[i]={Name='Reward '..i,Amount=i}end
 p.Notify({Tower='Test',Floor=10,Items=many})
 check(#p.Cards==2 and card.Frame.destroyed,'notification stack grew without bound')
 check(p.Cards[1].Frame.Size.Y.Offset==50 and not p.Cards[1].List.Visible,'new floor notice forgot collapsed preference')
 check(#p.Cards[1].List:GetChildren()==20 and p.Cards[1].List.CanvasSize.Y.Offset>p.Cards[1].List.Size.Y.Offset,'long reward list was dropped instead of scrollable')
 p.Cards[1].List.CanvasPosition=Vector2.new(0,60);p.Cards[1].Collapse.MouseButton1Click:Fire()
 check(p.Cards[1].List.Visible and p.Cards[1].List.CanvasPosition.Y==60 and #p.Cards[1].List:GetChildren()==20,'expand reset scroll position or lost reward rows')
 f.env.workspace.CurrentCamera.ViewportSize=Vector2.new(320,480);p.Tick(f.now())
 check(#p.Cards==1 and p.Root.Size.X.Offset<=288,'mobile notification escaped screen width / stack limit')
 local mobile=p.Cards[1]
 check(mobile.Frame.Size.Y.Offset<=p.Root.Size.Y.Offset,'mobile reward list escaped available height')
 mobile.Frame.Dismiss.MouseButton1Click:Fire();check(#p.Cards==0,'close button did not dismiss card')
 p.Notify({Tower='Test',Floor=11,Items={}});f.advance(8);p.Tick(f.now())
 check(#p.Cards==0,'expired reward card remained visible')
 p.Notify({Tower='Test',Floor=12,Items={}});local last=p.Cards[1];app.Destroy()
 check(p.Root.destroyed and last.Frame.destroyed and not last.Link.Connected and not last.CollapseLink.Connected,'unload left cards / click connections alive')
end
do
 local f=setup(113290951185459,false);local app=f.Run()
 f.data.Inventory={boost={name='Candy Pot I',amount=2},spin={name='Lucky Spin',amount=1}}
 table.remove(f.work,1)()
 local boost=f.objects['Boosts to use'];local spins=f.objects['Spins to use'];local gear=f.objects['Gear priority'];local quest=f.objects['Quest shop item']
 check(boost.Rows['Candy Pot I'].ItemIcon.Image=='rbxassetid://123456','Boost choice missing native item artwork')
 check(spins.Rows['Lucky Spin'].ItemIcon.Image=='rbxassetid://654321','Spin choice missing native item artwork')
 check(boost.Rows['Candy Pot I'].ItemIcon.Position.X.Offset==34 and boost.Rows['Candy Pot I'].OptionLabel.Position.X.Offset==62,'multi-select icons overlap selection checkbox')
 for _,name in ipairs({'Luck','Money','Damage','Health','Roll','Candy','Pumpkin'})do
  check(gear.Rows[name].PriorityIcon.Image=='rbxassetid://777','gear priority did not use native buff icon: '..name)
 end
 check(quest.Rows.Gems.ItemIcon.Image=='rbxassetid://123456'and quest.Rows.Luck.ItemIcon.Image=='rbxassetid://999','Quest item/gamepass icon missing')
 check(quest.Rows.Gems.TicketPrice.Text=='1 Tickets'and quest.Rows.Luck.TicketPrice.Text=='199 Tickets','Quest ticket price incorrect')
 boost.Callback({'Candy Pot I'});spins.Callback({'Lucky Spin'});gear.Callback('Damage');quest.Callback('Luck')
 check(app.Config.BoostNames['Candy Pot I']and app.Config.SpinNames['Lucky Spin']and app.Config.GearPriority=='Damage'and app.Config.QuestOffer=='Luck','decorated choices changed actual use/equip/purchase keys')
 f.objects['Refresh inventory and choices'].Callback();table.remove(f.work,#f.work)()
 check(app.Config.BoostNames['Candy Pot I']and app.Config.SpinNames['Lucky Spin']and app.Config.GearPriority=='Damage'and app.Config.QuestOffer=='Luck','refresh cleared selected items / gear priority')
 local copies=0;for _,child in ipairs(boost.Rows['Candy Pot I']:GetChildren())do if child.Name=='ItemIcon'then copies+=1 end end
 check(copies==1 and #f.remote.Sent==0,'refresh duplicated item icons or started automation')
 app.Destroy()
end
do
 local f=setup(113290951185459,false);local player=f.game:GetService('Players').LocalPlayer
 player.OnTeleport=signal();local queued={}
 f.env.queue_on_teleport=function(code)queued[#queued+1]=code end
 local app=f.Run()
 check(f.scope.DevilHubAutoExecute.Status=='Ready'and #queued==0,'direct entry did not arm Auto Execute quietly')
 player.OnTeleport:Fire(Enum.TeleportState.Started);player.OnTeleport:Fire(Enum.TeleportState.InProgress)
 check(#queued==1 and queued[1]:find('main/loader?v=vm-1',1,true),'direct entry queued wrong / duplicate loader')
 check(f.Run()==app and #queued==1,'direct entry rerun duplicated Auto Execute')
 app.Destroy()
end
do
 local f=setup(113290951185459,false);local app=f.Run()
 table.remove(f.work,1)()
 local loop=coroutine.create(table.remove(f.work,1));local ticks=0;local tick=app.Core.Tick
 app.Core.Tick=function()ticks+=1;return tick()end
 local render=app.Presentation.Tick
 app.Presentation.Tick=function()error('temporary GUI refresh error')end
 check(coroutine.resume(loop),'presentation error killed automation loop')
 check(app.Report.LastRenderError and ticks==1,'presentation failure was not recorded separately')
 check(coroutine.resume(loop)and ticks==2 and coroutine.status(loop)=='suspended','automation did not continue after a GUI error')
 app.Presentation.Tick=render
 check(coroutine.resume(loop)and ticks==3,'GUI refresh could not recover')
 app.Destroy();check(coroutine.resume(loop)and coroutine.status(loop)=='dead','closed app kept retrying automation')
end
if mainLoaderSource then
 local f=setup(113290951185459,false);local routeRequests=0
 local loading={SetLogo=function()end,Update=function()end,Finish=function()end,Fail=function()end}
 f.scope.DevilHubLoadController={Acquire=function()return loading end,IsActive=function()return true end}
 function f.game:IsLoaded()return true end
 f.game.HttpGet=function(self,url)
  if url:find('/anime-dice-test.lua',1,true)then
   check(url:find('/'..mainEntryCommit..'/anime-dice-test.lua?hub=anime-dice-webhook-20261022-1',1,true),'main loader fetched wrong entry pin / version')
   routeRequests+=1;return entrySource
  end
  return f.http(self,url)
 end
 f.env.loadstring=function(source,label)
  if source==ouroSource then return f.compiler(source,label)end
  local run,err=nativeCompile(source,label);if run then setfenv(run,f.env)end;return run,err
 end
 local run=assert(nativeCompile(mainLoaderSource));setfenv(run,f.env)
 local co=coroutine.create(run);local app
 for _=1,60 do
  local ok,result=coroutine.resume(co);check(ok,'main loader / actual entry failed: '..tostring(result))
  if coroutine.status(co)=='dead'then app=result;break end
 end
 check(app and app==f.scope.DevilAnimeDiceTest and app.Version=='anime-dice-webhook-20261022-1','main loader did not return the actual Anime Dice GUI')
 check(routeRequests==1 and not f.scope.DevilHubRouterLoading,'main loader duplicated entry download or leaked busy state')
 table.remove(f.work,1)()
 check(not app.Report.InitializationError and f.objects['Quest shop item']and f.objects['Boosts to use']and f.objects['Spins to use']and f.objects['Gear priority'],'main-loaded app did not initialize requested selectors')
 local duplicate=coroutine.create(run);local repeated
 for _=1,60 do
  local ok,result=coroutine.resume(duplicate);check(ok,'duplicate loader failed: '..tostring(result))
  if coroutine.status(duplicate)=='dead'then repeated=result;break end
 end
 check(repeated==app and routeRequests==1,'running main loader twice duplicated GUI / download')
 app.Destroy()
end
do
 local f=setup(113290951185459,false);local app=f.Run();table.remove(f.work,1)()
 local picker=f.objects['Tower selection'];local haunted=f.objects['Haunted wing'];local p=app.Presentation
 check(picker.Options[1]=='Dragon Tower'and picker.Options[2]=='Cursed Tower','Tower choices do not follow native progression order')
 check(not table.find(picker.Options,'Front Yard')and table.find(haunted.Options,'Front Yard'),'event wings leaked into normal Tower selector')
 local dragon=picker.Rows['Dragon Tower'];local shadow=picker.Rows['Shadow Tower'];local infinity=picker.Rows['Infinity Tower']
 check(dragon.TowerIcon.Image==f.towerSpecs['Dragon Tower'].image and dragon.TowerIcon:GetAttribute('CustomIcon'),'Tower image is not the native untinted artwork')
 check(dragon.TowerDetails.TowerDifficulty.Text=='Easy'and dragon.TowerDetails.TowerFloors.Text=='100 floors','Tower difficulty / floor count missing')
 check(shadow.TowerDetails.TowerDifficulty.Text=='Abyssal'and shadow.TowerDetails.TowerFloors.Text=='150 floors','Shadow Tower floors were assumed to be 100')
 check(infinity.TowerDetails.TowerDifficulty.Text=='Infinity'and infinity.TowerDetails.TowerFloors.Text=='Endless floors','Infinity Tower shown with a made-up floor cap')
 check(haunted.Rows['Front Yard'].TowerIcon.Image==f.wings.Wings[1].image and haunted.Rows['Front Yard'].TowerDetails.TowerFloors.Text=='Floors 1–50','Haunted wing artwork or native floor range is wrong')
 check(haunted.Rows['The Abyss'].TowerIcon.Image==f.wings.Wings[2].image and haunted.Rows['The Abyss'].TowerDetails.TowerFloors.Text=='Floor 251+','endless wing fallback loses its native starting floor')
 picker.Callback('Dragon Tower');haunted.Callback('The Abyss')
 check(app.Config.TowerChoice=='Dragon Tower'and app.Config.WingChoice=='The Abyss','decorated Tower labels changed gameplay IDs')
 local count=#dragon:GetChildren();p.RefreshTowers(app.Core and {GetAll=function()return f.towerSpecs end},f.wings)
 check(#dragon:GetChildren()==count and app.Config.TowerChoice=='Dragon Tower','Tower refresh duplicates rows or clears selected Tower')
 p.SetLanguage('TH')
 check(dragon.TowerDetails.TowerDifficulty.Text=='ง่าย'and dragon.TowerDetails.TowerFloors.Text=='100 ชั้น','Tower metadata did not switch to Thai')
 p.SetLanguage('EN')
 check(dragon.TowerDetails.TowerDifficulty.Text=='Easy','Tower difficulty did not switch back to English')
 local unknown=picker.Rows.Test
 check(not unknown.TowerIcon.Visible and unknown.TowerIconFallback.Visible and unknown.TowerDetails.TowerFloors.Text=='Floors unavailable','missing Tower art / levels shows a blank icon or invented data')
 f.towerSpecs.Test.image='rbxassetid://456';f.towerSpecs.Test.difficulty={name='Hard'};f.towerSpecs.Test.maxFloors=20
 p.RefreshTowers({GetAll=function()return f.towerSpecs end},f.wings)
 check(unknown.TowerIcon.Visible and not unknown.TowerIconFallback.Visible and unknown.TowerIcon.Image=='rbxassetid://456'and unknown.TowerDetails.TowerDifficulty.Text=='Hard','late metadata does not refresh existing Tower rows')
 app.Destroy()
end
do
 local f=setup(113290951185459,false)
 f.unitSpecs['Mummy Loffy']={image=function()return'rbxassetid://901'end,rarity='Mythical'}
 f.unitSpecs['Skeleton Sanjo']={image='rbxassetid://902'};f.unitSpecs['Vampire Gujo']={image='rbxassetid://903'}
 local app=f.Run();table.remove(f.work,1)();local p=app.Presentation
 local picker=f.objects['Pumpkin units to auto sell'];local row=picker.Rows['Mummy Loffy']
 check(picker.Options[1]=='Mummy Loffy'and row.PumpkinUnitIcon.Image=='rbxassetid://901','Pumpkin picker lost native order or registry artwork')
 check(row.PumpkinUnitDetails.UnitPower.Text=='Power 5B'and row.PumpkinUnitDetails.UnitRarity.Text=='Mythical','Pumpkin unit power / rarity is not native metadata')
 picker.Callback({'Mummy Loffy','Vampire Gujo'});p.RefreshPumpkinUnits(f.pumpkin)
 check(app.Config.PumpkinSellNames['Mummy Loffy']and app.Config.PumpkinSellNames['Vampire Gujo']and not app.Config.PumpkinSellNames['Skeleton Sanjo'],'decorated Pumpkin options do not preserve selected IDs')
 check(#f.pumpkinRemote.Sent==0,'rendering/filter selection applied a sale automatically')
 f.objects['Apply Pumpkin sell filter'].Callback();table.remove(f.work,#f.work)()
 local worker=coroutine.create(table.remove(f.work,#f.work));for _=1,5 do if coroutine.status(worker)=='dead'then break end;check(coroutine.resume(worker),'Pumpkin apply worker failed')end
 local sent={};for _,packet in ipairs(f.pumpkinRemote.Sent)do sent[packet[1]]=packet[2]end
 check(sent['Mummy Loffy']==true and sent['Vampire Gujo']==true and sent['Skeleton Sanjo']==false,'Apply Pumpkin filter sent wrong IDs or deselection states')
 p.SetLanguage('TH');check(row.PumpkinUnitDetails.UnitPower.Text=='พลัง 5B','Pumpkin power label did not translate')
 p.SetLanguage('EN');check(row.PumpkinUnitDetails.UnitPower.Text=='Power 5B','Pumpkin power label did not switch back to English')
 local clones,models,parts,effects=0,{},{},{}
 f.env.typeof=function(value)if type(value)=='table'and value.props and value.props.ClassName then return'Instance'end;return typeof(value)end
 local vecMT={__add=function(a,b)return setmetatable({X=a.X+b.X,Y=a.Y+b.Y,Z=a.Z+b.Z},getmetatable(a))end}
 local function vec(x,y,z)return setmetatable({X=x,Y=y,Z=z},vecMT)end
 f.env.Vector3={new=vec};f.env.CFrame={Angles=function()return{}end,lookAt=function(position,focus)return{Position=position,Focus=focus}end}
 local function maker()
  clones+=1;local model=Instance.new('Model');models[#models+1]=model
  local part=Instance.new('BasePart');part.Parent=model;parts[#parts+1]=part
  local effect=Instance.new('ParticleEmitter');effect.Parent=model;effects[#effects+1]=effect
  model.PivotTo=function()end;model.GetBoundingBox=function()return{Position=vec(0,0,0)},vec(3,6,2)end
  return model
 end
 for i=1,8 do local name='Preview '..i;f.pumpkin.Units[#f.pumpkin.Units+1]={id=name,power=i*1e9};f.unitSpecs[name]={model=maker}end
 p.RefreshPumpkinUnits(f.pumpkin);check(clones==0,'refresh eagerly cloned every Pumpkin model')
 picker.Popup.Visible=true;picker.Popup.AbsoluteSize=Vector2.new(420,300)
 for _,r in pairs(picker.Rows)do r.OptionLabel.AbsolutePosition=Vector2.new(0,30);r.OptionLabel.AbsoluteSize=Vector2.new(200,30)end
 p.Tick(f.now());check(clones==1,'preview creation is not limited to one model per tick')
 for _=1,8 do f.advance(.5);p.Tick(f.now())end
 local active=0;for _,r in pairs(picker.Rows)do if r:FindFirstChild('PumpkinUnitModel')then active+=1 end end
 check(active==6 and clones==6,'Pumpkin preview exceeded six simultaneous visible models: '..active..' active / '..clones..' created; '..tostring(app.Report.LastPreviewError))
 check(parts[1].Anchored and not parts[1].CanCollide and effects[1].destroyed,'preview model retains active effects / physical collisions')
 picker.Popup.Visible=false;p.Tick(f.now())
 check(models[1].destroyed,'closing Pumpkin popup retains preview models')
 picker.Popup.Visible=true;app.Window.Gui.Enabled=false;p.Tick(f.now());check(clones==6,'hidden hub still creates previews')
 app.Window.Gui.Enabled=true;f.advance(9);p.Tick(f.now());local last=models[#models]
 app.Destroy();check(last.destroyed,'unloading hub leaks Pumpkin preview models')
end
do
 local f=setup(113290951185459,false);local app=f.Run();table.remove(f.work,1)();local p=app.Presentation
 local wing={name='Foyer',firstFloor=51,image='rbxassetid://77009522006685'}
 local spec={event='Halloween',order=2,wing=wing,image=wing.image,maxFloors=50,difficulty={name='Floors 51-100'}}
 p.RefreshTowers({GetAll=function()return{Foyer=spec}end},nil)
 local picker=f.objects['Haunted wing'];check(picker.Options[1]=='Foyer'and picker.Rows.Foyer.TowerIcon.Image==wing.image,'Haunted selector depends on a separately loaded wing module')
 local partial={event='Halloween',image=''}
 p.RefreshTowers({GetAll=function()return{Foyer=partial}end},{WING_FLOORS=50,Wings={wing}})
 check(picker.Rows.Foyer.TowerDetails.TowerFloors.Text=='Floors 51–100'and picker.Rows.Foyer.TowerIcon.Image==wing.image,'Haunted partial data does not recover artwork / floor range')
 check(partial.image==''and partial.wing==nil,'presentation mutated native Tower catalog while merging wing metadata')
 app.Destroy()
end
do
 local storage={Files={},Encoded={},FailModules={Towers=true,HauntedHouse=true,TowerRefs=true}}
 local f=setup(113290951185459,false,storage);local app=f.Run();table.remove(f.work,1)()
 local picker=f.objects['Tower selection'];local wings=f.objects['Haunted wing']
 check(table.find(picker.Options,'Dragon Tower')and table.find(picker.Options,'Infinity Tower'),'failed desktop module left Tower picker empty')
 check(table.find(wings.Options,'Front Yard')and table.find(wings.Options,'The Abyss'),'failed wing module left Haunted picker empty')
 check(picker.Rows['Dragon Tower'].TowerIcon.Image=='rbxassetid://85435271739310','fallback lost native Tower art')
 picker.Callback('Dragon Tower');check(app.Config.TowerChoice=='Dragon Tower','desktop fallback selection changed the request id')
 -- Complete the single pending retry, then simulate modules becoming usable.
 table.remove(f.work)();storage.FailModules={}
 f.towerSpecs['New Live Tower']={order=7,image='rbxassetid://7',difficulty={name='New'},maxFloors=200}
 f.objects['Refresh inventory and choices'].Callback();while #f.work>1 do table.remove(f.work,2)()end
 f.objects['Refresh inventory and choices'].Callback();while #f.work>1 do table.remove(f.work,2)()end
 check(table.find(picker.Options,'New Live Tower'),'catalog did not replace fallback when native module recovered')
 -- Rendering a bad optional Dice image must not block Towers or other pickers.
 f.dice.Basic.image={Invalid=true}
 local p=app.Presentation;local original=p.RefreshDice
 p.RefreshDice=function()error('desktop image failure')end
 f.objects['Refresh inventory and choices'].Callback();while #f.work>1 do table.remove(f.work,2)()end
 check(app.Report.ChoiceErrors.Dice and table.find(picker.Options,'New Live Tower'),'optional art failure blocked Tower choices')
 p.RefreshDice=original;app.Destroy()
end
print('PASS complete public test entry: GUI callbacks, icon dropdowns, dice ownership, Tower reward cards, language and unload: '..checks..' checks')
