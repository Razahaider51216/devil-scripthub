local artwork=makeArtwork()
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
setfenv(compile,setmetatable({game=game,getgenv=function()return env end,task=task,Instance=Instance,typeof=typeof,
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
 local flashed=false
 native:GetPropertyChangedSignal('Parent'):Connect(function()if native.Parent and native.Enabled then flashed=true end end)
 local create=assert(loadstring(createSource));setfenv(create,{F={[19]={obj1=native},[15]=host}});create()
 check(native.Parent==host and not native.Enabled and not flashed,'native GUI was enabled when parented')
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
