local core=Instance.new('CoreGui')
local shared,files,encoded={},{},{}
local serial=0
local function copy(value)
 if type(value)~='table'then return value end
 local out={};for k,v in pairs(value)do out[k]=copy(v)end;return out
end
local http={JSONEncode=function(_,value)serial+=1;local key='json'..serial;encoded[key]=copy(value);return key end,
 JSONDecode=function(_,value)return assert(encoded[value])end}
local heartbeat=signal()
local game={GameId=10765288803,PlaceId=114326934417838,GetService=function(_,name)
 if name=='CoreGui'then return core elseif name=='HttpService'then return http elseif name=='RunService'then return {Heartbeat=heartbeat}end
 error('Unexpected service '..name)
end}
local function getgenv()return shared end
local function isfile(name)return files[name]~=nil end
local function readfile(name)return files[name]end
local function writefile(name,value)files[name]=value end
local function node(class,name,parent,props)
 local out=Instance.new(class);out.Name=name
 for k,v in pairs(props or{})do out[k]=v end
 out.Parent=parent;return out
end
local screen=node('ScreenGui','DevilHubBreak',core)
screen:SetAttribute('DevilBreakFrontend',true)
local root=node('Frame','Window',screen,{AbsoluteSize=Vector2.new(880,520),Size=UDim2.fromOffset(880,520)})
local visual=node('TextLabel','TabName',root,{Text='Visuals'})
local main=node('TextButton','MainTab',root,{Text='Main'})
local dynamic=node('TextLabel','EventStatus',root,{Text='No saved settings; current values kept'})
local search=node('TextBox','Search',root,{Text='my filter',PlaceholderText='Search'})
local minimize=node('TextButton','Minimize',root)
minimize.Position=setmetatable({},{__sub=function()return UDim2.fromOffset(400,0)end})
local callbacks=0;local action=main.Activated:Connect(function()callbacks+=1 end)
local controller=(function()
-- MODULE INSERTED HERE
end)()
local makeNative=(function()
-- NATIVE LANGUAGE INSERTED HERE
end)()
local keepLinks={}
local function keep(link)keepLinks[#keepLinks+1]=link end
local native=makeNative({Gui=screen,MinimizeButton=minimize},shared,keep,
 {Theme={Text=Color3.fromRGB(255,255,255),Surface2=Color3.fromRGB(16,19,25)}})
shared.DevilBreakSettings={SetLanguage=native.SetLanguage}
flush()
local menu=root:FindFirstChild('DevilLanguageSelector'):FindFirstChild('LanguageOptions')
local function select(code)menu:FindFirstChild('Language'..code).Activated:Fire();flush()end
local function visible(object)return object:FindFirstChild('DevilTranslatedLabel').Text end
select('EN')
check(controller.Get().Language=='EN'and shared.DevilBreakLanguage=='TH','fixture did not reproduce independent native/shared selections')
check(visible(visual)~='Visuals','fixture did not reproduce visible Thai text after English selection')
print('PASS reproduced original bug: English selected while native renderer still uses Thai')
local install=(function()
-- BRIDGE INSERTED HERE
end)()
local oldSet,oldDestroy=controller.Set,controller.Destroy
local bridge=install();flush()
check(bridge and bridge.Owner==controller,'Break language bridge not installed')
check(controller.Get().Language=='EN'and shared.DevilBreakLanguage=='EN','initial selection not synchronized')
check(visible(visual)=='Visuals'and visible(main)=='Main','existing labels remained Thai')
check(install()==bridge,'repeated launch duplicated language bridge')
for _=1,3 do
 select('TH')
 check(shared.DevilBreakLanguage=='TH'and controller.Get().Language=='TH','Thai dropdown missed native renderer')
 check(visible(visual)~='Visuals','Thai dropdown failed to translate native labels')
 select('EN')
 check(shared.DevilBreakLanguage=='EN'and controller.Get().Language=='EN','English dropdown missed native renderer')
 check(visible(visual)=='Visuals','English dropdown retained native Thai overlay')
end
dynamic.Text='Saved settings restored automatically';flush()
check(visible(dynamic)=='Saved settings restored automatically','dynamic English status rewritten into Thai')
select('TH');dynamic.Text='Saved settings loaded';flush();select('EN')
check(visible(dynamic)=='Saved settings loaded','dynamic native text did not return to English')
local late=node('TextLabel','LateFeature',root,{Text='Auto Pickup'});flush()
check(visible(late)=='Auto Pickup','late control stuck in Thai')
check(search.Text=='my filter'and search.PlaceholderText=='Search','language change modified search input / left hint in Thai')
main.Activated:Fire();check(callbacks==1 and action.Connected,'game feature callback changed')
check(http:JSONDecode(files['DevilHub-BlueGUI.json']).Language=='EN','English preference not persisted')
shared.DevilBreakSettings.SetLanguage('TH');flush()
check(controller.Get().Language=='TH'and shared.DevilBreakLanguage=='TH','native saved-language restore disagreed with selector')
check(menu:FindFirstChild('LanguageTH').BackgroundTransparency==0,'native selection did not refresh shared dropdown')
shared.DevilBreakSettings.SetLanguage('EN');flush()
check(visible(visual)=='Visuals'and controller.Get().Language=='EN','native English selection missed overlay')
bridge.Destroy()
check(controller.Set==oldSet and controller.Destroy==oldDestroy and shared.DevilBreakSettings.SetLanguage==native.SetLanguage,'bridge teardown did not restore presentation functions')
shared.DevilBreakSettings=nil
local delayed=install()
check(delayed~=nil,'late API bridge not installed')
native.SetLanguage('TH')
shared.DevilBreakSettings={SetLanguage=native.SetLanguage}
heartbeat:Fire();flush()
check(shared.DevilBreakLanguage=='EN'and visible(visual)=='Visuals','late native API did not adopt saved English selection')
check(shared.DevilBreakSettings.SetLanguage~=native.SetLanguage,'late native language API was not synchronized')
controller.Destroy()
check(delayed.Stopped and shared.DevilBreakLanguageSync==nil and shared.DevilBreakSettings.SetLanguage==native.SetLanguage,'theme teardown leaked bridge or native adapter')
native.Destroy()
game.GameId=10563114921;game.PlaceId=107778070777162
check(install()==nil,'Break-only adapter changed Steal an Egg')
game.GameId=10436530264;game.PlaceId=78490532994307
check(install()==nil,'Break-only adapter changed Build An Ant Empire')
print('PASS native/shared language integration: '..checks..' checks; live Roblox remains unverified')
