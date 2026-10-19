local nativeCompile=loadstring
local function setup(place,corrupt)
 local work={};local downloads=0;local libraryCalls=0
 local scope={DevilHubSilverLogo='devil-logo.png',DevilHubBlueGui={Version='devil-blue-20261019-10',Stopped=false}}
 local language='EN';scope.DevilHubBlueGui.Get=function()return {Language=language}end
 local testTask={spawn=function(fn)work[#work+1]=fn end,defer=function(fn)work[#work+1]=fn end,
  wait=function(n)return coroutine.yield(n)end,delay=function()end}
 local function node(class,name,parent)
  local obj=Instance.new(class);obj.Name=name;obj.Parent=parent;return obj
 end
 local rs=node('ReplicatedStorage','ReplicatedStorage')
 local core=node('CoreGui','CoreGui')
 local features=node('Folder','Features',node('Folder','Framework',rs))
 local function module(branch,name,value)local obj=node('ModuleScript',name,node('Folder',branch,features));obj.Export=value;return obj end
 local data={Money=1000,Inventory={},Slots={},AutoRoll=false,AutoSell=0,AutoTower='',TowerTeam={},Rebirth=0,Rolls=0,Halloween={},
  ProtectedTraits={},ProtectedGrades={},ProtectedQuirks={}}
 local proxy=setmetatable({},{__index=function(_,key)return function()return data[key]end end})
 module('Data','DataController',proxy)
 module('Inventory','EntryRegistry',{getEntryConfig=function()return nil end})
 local network=node('Folder','Network',rs)
 local roll=node('Folder','RollService',network)
 local remote=node('RemoteEvent','SetAutoRoll',node('Folder','RE',roll));remote.Sent={}
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
  function widget:Set(v,silent)
   self.Value=v
   if class=='Label'then label.Text=tostring(v)end
   if not silent and self.Callback then self.Callback(v)end
  end
  function widget:Refresh(values,keep,silent)
   check(keep==true and silent==true,'choice refresh invoked callbacks / dropped selections')
   self.Options=values
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
  local w={Gui=screen}
  function w:CreateTab(info)
   local host=node('Frame',info.Name,root)
   return {CreateGroupbox=function(_,args)return group(host,args.Name)end}
  end
  function w:Destroy()screen:Destroy()end
  window=w;return w
 end}
 local env=setmetatable({game=game,workspace={GetServerTimeNow=function()return 100 end},task=testTask,
  getgenv=function()return scope end,require=function(obj)return assert(obj.Export,'missing module')end,
  Instance=Instance,Color3=Color3,ColorSequence=ColorSequence,UDim2=UDim2,UDim=UDim,Vector2=Vector2,Enum=Enum,
  warn=function()end,print=function()end},{__index=getfenv(0)})
 env.loadstring=function(source,label)
  assert(source==ouroSource and label=='DEVIL HUB / Anime Dice GUI','entry changed native compile boundary')
  return function()return library end
 end
 local originalCompiler=env.loadstring;local originalHttp=game.HttpGet
 local fn=assert(nativeCompile(entrySource));setfenv(fn,env)
 return {Run=fn,scope=scope,work=work,objects=objects,remote=remote,env=env,data=data,
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
 f.objects['Sell maximum chance (0 = off)'].Callback('1 / 1,000')
 check(app.Config.SellChanceMax==1000,'GUI chance input rejected formatted denominators')
 f.data.AutoSell=500;f.objects['Use game sell threshold'].Callback();table.remove(f.work,#f.work)()
 check(app.Config.SellChanceMax==500 and f.objects['Sell maximum chance (0 = off)'].Value=='500','game threshold button left filter / input out of sync')
 f.objects['Start Event Collection'].Callback()
 table.remove(f.work,#f.work)()
 check(app.Config.Doors and app.Config.Pass and app.Config.EventQuests and app.Config.DoorMovement=='Teleport','event start did not enable collection / claims with teleport')
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
 check(destroyed==1 and app.Version=='anime-dice-test-20261020-2','rerun retained previous broken release')
 app.Destroy()
end
print('PASS complete public test entry: GUI callbacks, Halloween, language, integrity, singleton and unload: '..checks..' checks')
