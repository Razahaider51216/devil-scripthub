local nativeCompile=loadstring
local function setup(place,corrupt)
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
 module('Inventory','EntryRegistry',{getEntryConfig=function(name)
  if name=='Weak'then return {kind='Unit',chance=function()return 10 end,income=function()return 1 end,getRarity=function(a)return a.mutation=='Gold'and'Rare'or'Common'end}end
  if name=='Pumpkin Spin'or name=="Witch's Jackpot"or name=='Candy Pot I'or name=='Gems'then return {kind='Boost',image='rbxassetid://123456'}end
 end})
 local dice={Basic={luck=1,image='rbxassetid://1'},Fire={luck=5,price=2500,image='rbxassetid://2'},Water={luck=10,price=10000,image='rbxassetid://3'}}
 local offers={{name='Pumpkin Spin',candy=2500},{name='Candy Pot I',candy=500},{name="Witch's Jackpot",candy=50000}}
 module('Rolling','Dice',{GetAll=function()return dice end,GetDefault=function()return 'Basic'end})
 module('Halloween','HalloweenShop',offers)
 module('Towers','Towers',{GetAll=function()return {Test={},['Front Yard']={event=true}}end})
 module('Towers','TowerRefs',{ActionWaitTime={floorCompleted=.24,ended=0}})
 local network=node('Folder','Network',rs)
 local roll=node('Folder','RollService',network)
 local remote=node('RemoteEvent','SetAutoRoll',node('Folder','RE',roll));remote.Sent={}
 local towers=node('Folder','Towers',network);local towerEvents=node('Folder','RE',towers);local towerFunctions=node('Folder','RF',towers)
 local equip=node('RemoteEvent','EquipBestTowerTeam',towerEvents);equip.Sent={}
 for _,name in ipairs({'PlayTower','CompleteTowerFloor','CancelTower'})do node('RemoteFunction',name,towerFunctions)end
 local floorActions={{action='floorCompleted',floor=9,rewards={Gems=3,['Unknown Relic']=1}}}
 function methods:InvokeServer(...)
  if self.Name=='PlayTower'then return true elseif self.Name=='CompleteTowerFloor'then return floorActions end
 end
 function methods:FireServer(...)
  self.Sent[#self.Sent+1]=table.pack(...)
  if self==remote then data.AutoRoll=(...)end
 end
 local player=node('Player','Player')
 local game={GameId=place==113290951185459 and 10708913337 or 1,PlaceId=place,
  GetService=function(_,name)
   if name=='ReplicatedStorage'then return rs elseif name=='Players'then return {LocalPlayer=player}
   elseif name=='HttpService'then return {JSONEncode=function()return '{}'end}end
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
  getgenv=function()return scope end,require=function(obj)return assert(obj.Export,'missing module')end,
  Instance={new=function(class)
   local obj=Instance.new(class);if class=='TextButton'then obj.MouseButton1Click=signal()end;return obj
  end},Color3=Color3,ColorSequence=ColorSequence,UDim2=UDim2,UDim=UDim,Vector2=Vector2,Enum=Enum,
  warn=function()end,print=function()end},{__index=getfenv(0)})
 env.loadstring=function(source,label)
  assert(source==ouroSource and label=='DEVIL HUB / Anime Dice GUI','entry changed native compile boundary')
  return function()return library end
 end
 local originalCompiler=env.loadstring;local originalHttp=game.HttpGet
 local fn=assert(nativeCompile(entrySource));setfenv(fn,env)
 return {Run=fn,scope=scope,work=work,objects=objects,remote=remote,env=env,data=data,offers=offers,dice=dice,
  advance=function(n)clockNow+=n end,now=function()return clockNow end,actions=function(value)floorActions=value end,
  compiler=originalCompiler,http=originalHttp,game=game,language=function(v)language=v end,
  counts=function()return downloads,libraryCalls end,window=function()return window end}
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
 check(destroyed==1 and app.Version=='anime-dice-test-20261020-7','rerun retained previous broken release')
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
print('PASS complete public test entry: GUI callbacks, icon dropdowns, dice ownership, Tower reward cards, language and unload: '..checks..' checks')
