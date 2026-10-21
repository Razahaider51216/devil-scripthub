-- Standalone brand scope. Native game callbacks use the existing protected runtime.
assert(game.GameId==10563114921 or game.PlaceId==107778070777162,"Open Steal an Egg before running KUYDUM HUB")
local host=getfenv(1)
local root=type(getgenv)=="function"and getgenv()or _G
local previous=root.KuydumHubSession
if previous and not previous.Stopped then
    if previous.Loading or previous.Shared.DevilChilliMainUI then return previous end
    previous.Destroy()
end
local app={Brand="KUYDUM HUB",Version="kuydum-steal-20261022-1",Discord="https://discord.gg/tCnZhrBcM",Loading=true,Stopped=false}
local shared=root.KuydumHubContext or{};app.Shared=shared;root.KuydumHubContext=shared
root.KuydumHubSession=app
local scope=setmetatable({getgenv=function()return shared end,_G=shared},{__index=host})
local compile,setEnvironment,getEnvironment=loadstring,setfenv,getfenv
scope.getfenv=function(subject)
    if subject==0 then return scope end
    if type(subject)=="function"then return getEnvironment(subject)end
    return getEnvironment((subject or 1)+1)
end
scope.loadstring=function(source,label)
    local fn,problem=compile(source,label)
    if fn then setEnvironment(fn,scope)end
    return fn,problem
end
local function filename(path)
    if type(path)~="string"then return path end
    return(path:gsub("^Devil","Kuydum"):gsub("^DEVIL","KUYDUM"))
end
for _,name in ipairs({"readfile","writefile","isfile","makefolder","isfolder","delfile","getcustomasset","getsynasset"})do
    local fn=host[name]
    if type(fn)=="function"then scope[name]=function(path,...)return fn(filename(path),...)end end
end
local copy=host.setclipboard or host.toclipboard
if type(copy)=="function"then
    local function brandedCopy(value,...)
        if type(value)=="string"and value:match("^https?://discord%.gg/[%w_%-]+/?$")then value=app.Discord end
        return copy(value,...)
    end
    scope.setclipboard=brandedCopy;scope.toclipboard=brandedCopy
end
function app.Destroy()
    if app.Stopped then return end
    app.Stopped=true
    local auto=shared.DevilHubAutoExecute
    if auto and auto.Link then pcall(function()auto.Link:Disconnect()end)end
    for _,key in ipairs({"DevilChilliMainUI","DevilHubBlueGui"})do
        local current=shared[key]
        if current and type(current.Destroy)=="function"then pcall(current.Destroy)end
    end
    if root.KuydumHubSession==app then root.KuydumHubSession=nil end
end
local ok,problem=xpcall(function()
    local url="__LOGO_URL__"
    local image=url
    local asset=scope.getcustomasset or scope.getsynasset
    if asset and scope.writefile then
        local loaded,value=pcall(function()
            local data=game:HttpGet(url)
            assert(type(data)=="string"and #data==__LOGO_BYTES__,"KUYDUM HUB logo download failed")
            scope.writefile("KuydumHubLogo.jpg",data)
            return asset("KuydumHubLogo.jpg")
        end)
        if loaded and type(value)=="string"then image=value end
    end
    shared.DevilHubSilverLogo=image;shared.DevilChilliBrandLogo=image
    local auto=assert(scope.loadstring(__AUTO_SOURCE__,"KUYDUM HUB / Auto Execute"));auto()
    local source=game:HttpGet("__GUI_URL__")
    assert(type(source)=="string"and #source==__GUI_BYTES__,"KUYDUM HUB GUI download size mismatch")
    local sum=0
    for i=1,#source do sum=(sum*33+source:byte(i))%4294967296;if i%32768==0 and task and task.wait then task.wait()end end
    assert(sum==__GUI_CHECKSUM__,"KUYDUM HUB GUI download checksum mismatch")
    local run,err=scope.loadstring(source,"KUYDUM HUB / Steal an Egg GUI");assert(run,err)
    app.Results=table.pack(run())
    app.Session=shared.DevilChilliMainUI
    if app.Session and type(app.Session.Destroy)=="function"then
        local destroySession=app.Session.Destroy
        app.Session.Destroy=function(...)
            destroySession(...)
            if not app.Stopped then app.Destroy()end
        end
    end
    app.Loading=false
end,debug.traceback)
if not ok then app.Error=tostring(problem);app.Destroy();error(problem,0)end
return app
