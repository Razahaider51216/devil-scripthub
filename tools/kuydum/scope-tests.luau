local builtin=loadstring
local legacy={marker=true};local oldTheme={marker=true}
local root={DevilChilliMainUI=legacy,DevilHubBlueGui=oldTheme}
local clipboard,queued,files={}, {}, {['DevilHub-BlueGUI.json']='original'}
local links={}
local teleport={Connect=function(_,fn)
 local c={Connected=true,fn=fn};function c:Disconnect()self.Connected=false end
 table.insert(links,c);return c
end}
local function fireTeleport()
 for _,c in ipairs(links)do if c.Connected then c.fn('TeleportState.Started')end end
end
local downloads=0;local corrupt=false;local receivedScope
local game={GameId=10563114921,PlaceId=107778070777162,GetService=function(_,name)
 assert(name=='Players',name);return {LocalPlayer={OnTeleport=teleport}}
end}
function game:HttpGet(url)
 downloads+=1
 if url:find('/assets/kuydumhub.jpg',1,true)then return LOGO end
 assert(url:find('/kuydum-steal-gui.lua',1,true),'standalone fetched the main loader')
 if corrupt then return GUI:sub(1,-2)..(GUI:sub(-1)=='x'and'y'or'x')end
 return GUI
end
local themeDestroyed=0;local sessionDestroyed=0
local env=setmetatable({game=game,getgenv=function()return root end,_G=root,task={wait=function()end},
 Enum={TeleportState={Started='TeleportState.Started',InProgress='progress',Failed='failed'}},
 queue_on_teleport=function(code)queued[#queued+1]=code end,
 setclipboard=function(v)clipboard[#clipboard+1]=v end,
 isfile=function(path)return files[path]~=nil end,
 writefile=function(path,data)files[path]=data end,
 readfile=function(path)return files[path]end,
 getcustomasset=function(path)return 'custom://'..path end},{__index=getfenv(0)})
env.loadstring=function(source,label)
 if label=='KUYDUM HUB / Steal an Egg GUI'then
  assert(source==GUI)
  return function()
   receivedScope=getfenv(1)
   local shared=getgenv()
   assert(shared~=root and shared.DevilHubSilverLogo=='custom://KuydumHubLogo.jpg')
   writefile('DevilHub-BlueGUI.json','kuydum settings')
   shared.DevilHubBlueGui={Destroy=function()themeDestroyed+=1 end}
   shared.DevilChilliMainUI={Destroy=function()sessionDestroyed+=1;shared.DevilChilliMainUI=nil end,
    Copy=function()setclipboard('https://discord.gg/oldInvite')end}
   return 'native result',nil,42
  end
 end
 local f,e=builtin(source,label);if f then setfenv(f,env)end;return f,e
end
local f=assert(builtin(ENTRY));setfenv(f,env)
local app=f()
assert(app.Brand=='KUYDUM HUB'and not app.Loading and not app.Stopped)
assert(app.Results.n==3 and app.Results[1]=='native result'and app.Results[2]==nil and app.Results[3]==42)
assert(root.DevilChilliMainUI==legacy and root.DevilHubBlueGui==oldTheme,'original hub state changed')
assert(files['DevilHub-BlueGUI.json']=='original'and files['KuydumHub-BlueGUI.json']=='kuydum settings')
assert(#clipboard==0,'startup copied an invite automatically')
app.Session.Copy();assert(clipboard[1]=='https://discord.gg/tCnZhrBcM')
assert(env.setclipboard~=receivedScope.setclipboard,'clipboard alias was not locally scoped')
local before=downloads;assert(f()==app and downloads==before,'duplicate run redownloaded GUI')
fireTeleport();assert(#queued==1 and queued[1]:find('/kuydum-steal-an-egg.lua',1,true))
assert(not queued[1]:find('/main/loader',1,true)and queued[1]:find('KuydumHubAutoExecuteArrival',1,true))
fireTeleport();assert(#queued==1,'teleport queued twice')
app.Session.Destroy();assert(app.Stopped and root.KuydumHubSession==nil and not links[1].Connected)
assert(themeDestroyed==1 and sessionDestroyed==1 and root.DevilChilliMainUI==legacy)
corrupt=true
local ok,err=pcall(f)
assert(not ok and tostring(err):find('checksum mismatch',1,true)and root.KuydumHubSession==nil,'damaged GUI was not rejected/cleaned up')
corrupt=false
local reopened=f();assert(reopened~=app and not reopened.Stopped,'closed GUI could not reopen')
reopened.Destroy();assert(root.DevilHubBlueGui==oldTheme)
game.GameId=1;game.PlaceId=1;before=downloads
assert(not pcall(f)and downloads==before,'wrong game downloaded or initialized the fork')
print('PASS KUYDUM scope: brand isolation, exact logo, saved-file namespace, manual Discord copy, no auto-copy, duplicate guard, own rejoin, close/reopen, integrity and wrong-map rejection')
