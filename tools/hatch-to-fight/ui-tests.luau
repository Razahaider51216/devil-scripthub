local checks=0
local function check(v,m)assert(v,m);checks+=1 end
local function signal()
    local callbacks={}
    return {Connect=function(_,fn)
        local record={Fn=fn,Active=true};table.insert(callbacks,record)
        return {Disconnect=function()record.Active=false end}
    end,Fire=function()for _,r in ipairs(callbacks)do if r.Active then r.Fn()end end end}
end
local widgets,windows={},{}
local function widget(config)
    local object={Config=config}
    function object:Set(value,silent)self.Value=value;if not silent and config.Callback then config.Callback(value)end end
    function object:Refresh(options)self.Options=options end
    widgets[config.Name or config.Text]=object
    return object
end
local group={}
for _,kind in ipairs({"Paragraph","Label","Input","Dropdown","Toggle","Button"})do group["Create"..kind]=function(_,config)return widget(config)end end
local library={CreateWindow=function(_,config)
    local window={Config=config,Gui={Destroying=signal()}}
    function window:CreateTab(info)return {CreateGroupbox=function()return group end}end
    function window:Destroy()if self.Dead then return end;self.Dead=true;self.Gui.Destroying:Fire()end
    table.insert(windows,window);return window
end}
local scope={};local getgenv=function()return scope end
local clipboard=0;local setclipboard=function()clipboard+=1 end
local threadErrors={}
local task={}
local spawning=false
function task.wait()if spawning then coroutine.yield()end end
function task.spawn(fn)
    local previous=spawning;spawning=true
    local co=coroutine.create(fn);local ok,err=coroutine.resume(co)
    spawning=previous
    if not ok then table.insert(threadErrors,tostring(err))end
    return co
end
function task.defer(fn)fn()end
local settingsObject
local files={}
local writefile=function(path,value)files[path]=value end
local readfile=function(path)assert(files[path],"no profile");return files[path]end
local gui={GetAttribute=function(_,name)return name=="PetMaxHP"and 100 or 80 end}
local char={GetAttribute=function()return false end,FindFirstChildOfClass=function()return {Health=100}end,FindFirstChild=function()return {}end}
local player={UserId=123,Character=char,GetAttribute=function()return nil end,FindFirstChildOfClass=function()return gui end}
local remotes={FindFirstChild=function()return nil end}
local htf={FindFirstChild=function(_,name)if name=="Remotes"then return remotes end end,WaitForChild=function(_,name)if name=="Remotes"then return remotes end end}
local rs={FindFirstChild=function(_,name)if name=="HatchToFight"then return htf elseif name=="Remotes"then return remotes end end,
    WaitForChild=function(_,name)if name=="HatchToFight"then return htf end end}
local http={JSONEncode=function(_,object)settingsObject=object;return "profile-json"end,
    JSONDecode=function(_,raw)assert(raw=="profile-json");return settingsObject end}
local services={Players={LocalPlayer=player},ReplicatedStorage=rs,HttpService=http,UserInputService={GetFocusedTextBox=function()return nil end},GuiService={MenuIsOpen=false}}
local game={PlaceId=127231827405683,GameId=10768001644,GetService=function(_,name)return services[name]end,
    HttpGet=function()return GUI_DEPENDENCY end}
local workspace={FindFirstChild=function()return nil end,GetAttribute=function()return nil end}
local loadstring=function(text,label)check(text==GUI_DEPENDENCY,"unexpected downloaded code");return function()return library end end
local Color3={fromRGB=function()return {}end,new=function()return {}end}
local UDim2={fromOffset=function()return {}end}
local startedApp=(function()
-- ENTRY
end)()
check(startedApp and startedApp.Version=="hatch-to-fight-test-20261022-1","entry failed")
check(#threadErrors==0 and next(startedApp.Report.Errors)==nil,"startup error hidden")
check(startedApp.Report.Sent==0 and clipboard==0,"startup sends gameplay requests or copies Discord")
check(windows[1].Config.Loading==false and windows[1].Config.Backdrop==false,"fullscreen loading/backdrop introduced")
check(windows[1].Config.ToggleButton.Platform=="Both","desktop reopen unsupported")
check(widgets["Destination"]and #widgets["Destination"].Config.Options==60,"stage destination options empty")
check(widgets["Destination"].Config.CurrentOption:find("Stage 60",1,true),"last-stage default missing")
check(widgets["Godmode availability"]and not widgets["Godmode"],"fake godmode toggle exposed")
widgets["Auto Stage Farm"].Config.Callback(true)
check(startedApp.Config.Farm,"farm toggle did not enable")
widgets["Auto Train"].Config.Callback(true)
check(startedApp.Config.Train and not startedApp.Config.Farm,"movement exclusivity not reflected")
widgets["Shell rarities (empty = all)"].Config.Callback({"Common","Rare"})
check(startedApp.Config.ShellRarities.Common and startedApp.Config.ShellRarities.Rare,"rarity array callback")
widgets["Shells per craft (4–32)"].Config.Callback("5.8")
check(startedApp.Config.CraftCount==5,"fractional recipe entered")
widgets["Restore saved profile on next run"].Config.Callback(true)
widgets["Save settings"].Config.Callback()
check(settingsObject and settingsObject.AutoLoad and settingsObject.Config.Train,"save profile missing enabled jobs")
check(settingsObject.UserId==123 and settingsObject.PlaceId==127231827405683,"profile not scoped to map/account")
widgets["Language"].Config.Callback("ไทย")
check(startedApp.Config.Language=="TH"and widgets["ฝึกพลังอัตโนมัติ"],"Thai menu not rebuilt")
check(not startedApp.Stopped,"language rebuild destroyed app")
widgets["ภาษา"].Config.Callback("English")
check(startedApp.Config.Language=="EN"and widgets["Auto Stage Farm"],"English menu not rebuilt")
widgets["Stop all automation"].Config.Callback()
for _,key in ipairs(startedApp.Core.JobKeys)do check(not startedApp.Config[key],"stop button left job enabled")end
widgets["Load saved settings"].Config.Callback()
check(startedApp.Config.Train and startedApp.Config.ShellRarities.Common,"profile restore failed")
check(clipboard==0,"profile restore copied Discord")
widgets["Copy Discord invite"].Config.Callback();check(clipboard==1,"explicit Discord copy unavailable")
startedApp.Destroy();check(startedApp.Stopped and scope.DevilHtFTest==nil,"unload leaked app")
check(#threadErrors==0,"UI task error")
print("PASS HatchToFight entry/GUI/language/profile/lifecycle: "..checks.." checks")
