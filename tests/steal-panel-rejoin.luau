local artwork=makeArtwork()
local function instanceType(value)
 if type(value)=='table'and value.ClassName then return 'Instance'end
 return typeof(value)
end
local core=Instance.new('CoreGui')
local screen=Instance.new('ScreenGui');screen.Name='DevilHubStealTest';screen.Parent=core
local root=Instance.new('Frame');root.Name='MainWindow';root.Size=UDim2.fromOffset(880,520);root.Parent=screen
local row=Instance.new('Frame');row.Parent=root
local button=Instance.new('TextButton');button.Parent=row
local pet=Instance.new('ImageLabel');pet.Name='Icon';pet.Image='rbxassetid://123456'
pet.Size=UDim2.fromScale(1,1);pet.ImageColor3=Color3.new(0,0,0);pet.ImageTransparency=1;pet.Visible=false;pet.Parent=button
local gradient=Instance.new('UIGradient');gradient.Color=ColorSequence.new(Color3.new(0,0,0));gradient.Parent=pet
local clicks=0;button.Activated:Connect(function()clicks+=1 end)
check(artwork(button,pet)==pet,'artwork replaced real icon instance')
check(pet.Image=='rbxassetid://123456'and pet.Visible and pet.ImageTransparency==0,'artwork still hidden / asset changed')
check(pet.ImageColor3==Color3.new(1,1,1)and gradient.Color.Keypoints[1].Value==Color3.new(1,1,1),'artwork / gradient still black')
check(pet:GetAttribute('DevilBlueSettings')and gradient:GetAttribute('DevilBlueSettings'),'theme exclusion missing')
pet.Name='randomized-123';button.Name='randomized-456'
local env={}
local game={GetService=function(_,name)
 if name=='CoreGui'then return core elseif name=='Players'then return {LocalPlayer=Instance.new('Player')}
 elseif name=='HttpService'then return {JSONEncode=function()return '{}'end,JSONDecode=function()return {}end}end
 error(name)
end}
local compile=assert(loadstring(themeSource))
setfenv(compile,setmetatable({game=game,getgenv=function()return env end,task=task,Instance=Instance,typeof=instanceType,
 Color3=Color3,ColorSequence=ColorSequence,Vector2=Vector2,UDim2=UDim2,UDim=UDim,Enum=Enum},{__index=getfenv(0)}))
local theme=compile();flush()
check(pet.ImageColor3==Color3.new(1,1,1),'shared theme darkened randomized pet art')
check(gradient.Color.Keypoints[1].Value==Color3.new(1,1,1),'shared theme darkened pet gradient')
pet.Image='rbxassetid://654321';flush()
check(pet.Image=='rbxassetid://654321'and pet.ImageColor3==Color3.new(1,1,1),'live pet image redraw lost')
button.Activated:Fire();check(clicks==1,'artwork fix lost original click handler')
local added=artwork(row,nil)
check(added:IsA('ImageLabel')and added.Parent==row and added.Visible and added.Size.X.Offset==48,'missing prototype icon not created')
check(artwork(row,added)==added,'repeated artwork fix duplicated icon')
local launcher=artwork(button,nil,true)
check(launcher.Image~=''and launcher:GetAttribute('DevilStealLauncher'),'launcher still lacks default system icon')
check(launcher.DevilStealFallback.Visible and #launcher.DevilStealFallback:GetChildren()>0,'unloaded icon has no visible vector fallback')
launcher.IsLoaded=true
check(not launcher.DevilStealFallback.Visible,'loaded native icon remained covered by fallback')
launcher.IsLoaded=false;launcher.Image='rbxassetid://999'
check(launcher.DevilStealFallback.Visible,'changed / failed asset removed fallback')
local children=#launcher:GetChildren();artwork(button,launcher,true)
check(#launcher:GetChildren()==children,'launcher redraw duplicated fallback / listeners')
theme.Destroy()
do
 local cache={};local data={Assets={Directory={}}}
 local fn=assert(loadstring(catalogSource..'return _'))
 setfenv(fn,setmetatable({S=cache,E=data,T=Color3.fromRGB,A=function()return {}end},{__index=getfenv(0)}))
 local catalog=fn();check(catalog('Pet').Icon=='','missing catalog artwork did not return empty state')
 data.Assets.Directory.Pet={Icon=123456,DisplayName='Pet'}
 local spec=catalog('Pet');check(spec.Icon=='rbxassetid://123456','early empty cache blocked later native pet icon')
 local refresh=assert(loadstring(redrawSource..'return redraw'))()
 local item={Category='Pet',Icon=added};added.Image=''
 refresh(item,{Category='Pet',Style=spec})
 check(added.Image=='rbxassetid://123456','same-category row did not refresh late artwork')
end
do
 local host=Instance.new('Folder');local native=Instance.new('ScreenGui');native.Enabled=true
 local frame=Instance.new('Frame');frame.Size=UDim2.fromScale(.45,.55)
 local flashed=false
 native:GetPropertyChangedSignal('Parent'):Connect(function()
  for _,child in ipairs(native:GetChildren())do if child:IsA('GuiObject')and not(child:IsA('CanvasGroup')and child.GroupTransparency==1)then flashed=true end end
 end)
 local create=assert(loadstring(createSource));setfenv(create,{F={[19]={obj1=native,obj2=frame},[15]=host},devilKeepNativeHidden=makeVisibility()});create()
 check(native.Parent==host and native.Enabled and not flashed,'startup changed native Enabled state / exposed native pixels')
 check(frame.Parent:IsA('CanvasGroup')and frame.Parent.GroupTransparency==1 and frame.Parent.Parent==native,'root frame bypassed invisible canvas')
 check(frame.Parent.Size.X.Scale==1 and frame.Parent.Size.Y.Scale==1,'native root lost viewport layout size')
 native.Enabled=false;native.Enabled=true;check(native.Enabled,'permanent visibility lock still intercepts engine state')
 check(native:GetAttribute('DevilBlueSettings')==true,'hidden native GUI still incurs a complete theme / localization pass')
end
do
 local shared={};local player=Instance.new('Player');local pg=Instance.new('PlayerGui');pg.Parent=player
 local host=setmetatable({getgenv=function()return shared end,typeof=instanceType,
  game={GetService=function(_,name)if name=='CoreGui'then return core end;return {LocalPlayer=player}end}},{__index=getfenv(0)})
 setfenv(makeGuard,host);local install=makeGuard();local stop=install()
 check(install()==stop,'early and frontend guards installed twice')
 local nested=Instance.new('Folder');nested.Parent=core
 local native=Instance.new('ScreenGui');native.Name='Settings';native.Parent=nested
 native:SetAttribute('ChilliLibraryOwned',true)
 check(not native.Enabled,'early guard missed late ownership under a nested hidden-UI folder')
 native.Enabled=true;check(not native.Enabled,'legacy native GUI reopened under early guard')
 local ours=Instance.new('ScreenGui');ours:SetAttribute('DevilHubPresentation',true);ours.Parent=core
 check(ours.Enabled,'early guard hid the DEVIL HUB frontend')
 local panel=Instance.new('ScreenGui');panel.Name='randomized-steal-panel';panel.Parent=core
 check(panel.Enabled,'early guard hid the separate Steal Panel')
 local quarantined=Instance.new('ScreenGui');makeVisibility()(quarantined);quarantined:SetAttribute('ChilliLibraryOwned',true);quarantined.Parent=core
 check(quarantined.Enabled,'early guard disabled the transparent native layout screen')
 stop();check(shared.DevilChilliEarlyGuardStop==nil and not native.Enabled,'guard cleanup exposed old GUI / kept singleton alive')
end
do
 local shared={};local written,warnings={},{};local updates=0
 local host=setmetatable({getgenv=function()return shared end,game={PlaceId=107778070777162,GetService=function()return {JSONEncode=function(_,data)return data.LastPhase end}end},
  identifyexecutor=function()return 'Offline Executor','1.2'end,
  writefile=function(path,text)written[path]=text end,warn=function(text)warnings[#warnings+1]=text end},{__index=getfenv(0)})
 shared.DevilHubLoadController={Update=function()updates+=1 end}
 setfenv(makeTrace,host);local stage=makeTrace()()
 check(shared.DevilStealStartupTrace.Executor=='Offline Executor / 1.2','startup trace did not identify executor')
 stage('Native UI write probe');stage('Native UI write probe')
 check(written['DevilHub-Steal-Startup.json']=='Native UI write probe'and #shared.DevilStealStartupTrace.Steps==2,'startup trace missing / repeated phase duplicated breadcrumbs')
 check(updates==2 and #warnings==2,'startup trace did not expose actual stages')
 host.writefile=function()error('file API unavailable')end
 stage('Native handles ready');check(shared.DevilStealStartupTrace.LastPhase=='Native handles ready','failed diagnostic file write interrupted startup')
 local previous=shared.DevilStealStartupTrace
 local resumed=makeTrace()('Protected bootstrap')
 check(resumed==stage and shared.DevilStealStartupTrace==previous and previous.LastPhase=='Protected bootstrap','bootstrap / native transition lost existing trace')
end
do
 local shared={};local progress
 shared.DevilHubLoadController={Update=function(text,value)progress=value end}
 local screens,waits={},{}
 local host=setmetatable({getgenv=function()return shared end,task={wait=function(n)waits[#waits+1]=n end,delay=function()end},
  game={GetService=function()return core end},typeof=instanceType,
  Instance={new=function(class)local obj=Instance.new(class);if class=='ScreenGui'then screens[#screens+1]=obj end;return obj end},
  Color3=Color3,ColorSequence=ColorSequence,UDim2=UDim2,UDim=UDim,Vector2=Vector2,Enum=Enum},{__index=getfenv(0)})
 setfenv(makeLoading,host);host.devilNativeProgress=makeLoading()
 local compile=assert(loadstring(nativeLoadingSource));setfenv(compile,host)
 local factory=compile();local initialize=factory()();initialize()
 check(shared.ChilliCanvasHold and type(shared.ChilliHubLoadStep)=='function','original loading lost engine hold / progress API')
 check(#screens==1 and screens[1].Parent==nil and not screens[1].Enabled,'native loading screen was exposed')
 shared.ChilliHubLoadStep(4);check(progress==.74,'native progress did not update DEVIL loading screen')
 check(waits[#waits]==.05,'original initialization wait was changed')
 shared.ChilliHubLoadStep(10)
 check(shared.ChilliCanvasHold==nil and shared.ChilliHubLoadStep==nil and shared.ChilliHubLoading==nil,'loading completion did not release native engine')
end
for _,enabled in ipairs({true,false})do
 local shared={};local downloads,launches=0,0
 local target={IsLoaded=function()return true end,GetService=function()return {GetTeleportSetting=function()return enabled end}end}
 target.HttpGet=function(_,url)
  check(url=='https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/loader?v=vm-1','native rejoin still downloads upstream')
  downloads+=1;return 'return true'
 end
 local run=assert(loadstring(queuedSource))
 setfenv(run,setmetatable({game=target,getgenv=function()return shared end,task={wait=function()end},
  loadstring=function()return function()launches+=1 end end},{__index=getfenv(0)}))
 run();run()
 check(downloads==(enabled and 1 or 0)and launches==downloads,'native queue ignored setting / duplicated main loader')
end
print('PASS Steal Panel artwork, live catalog refresh, shared theme, native startup and exact rejoin payload: '..checks..' checks')
