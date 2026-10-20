local checks=0
local function check(value,message) checks+=1;assert(value,message) end
local scope,windows,files,encoded={}, {}, {}, {}
local seq=0;local destroyedCores=0;local clipboard
local function clone(value)
    if type(value)~="table" then return value end
    local copy={};for k,v in pairs(value) do copy[k]=clone(v) end;return copy
end
local function signal()
    local callbacks={}
    return {Connect=function(_,fn) table.insert(callbacks,fn);return {Disconnect=function()end} end,
        Fire=function(_,...)for _,fn in ipairs(callbacks)do fn(...)end end}
end
local posmt={__sub=function(a,b)return setmetatable({x=a.x-b.x,y=a.y-b.y},getmetatable(a))end}
local function pos(x,y)return setmetatable({x=x,y=y},posmt)end
local library={}
local function group(win)
    local g={}
    for _,kind in ipairs({"Toggle","Dropdown","Slider","Input","Button","Paragraph","Label","Image"}) do
        g["Create"..kind]=function(_,opts)
            local widget={options=opts}
            function widget:Set(value,silent)
                if kind=="Paragraph" or kind=="Label" then check(type(value)=="string","OuroFlow text setter contract") end
                self.value=value;if not silent and opts.Callback then opts.Callback(value) end
            end
            win.widgets[opts.Name or "Totals"]=widget;return widget
        end
    end
    function g:CreateGroupbox(opts)local result=group(win);win.groups[opts.Name]=result;return result end
    return g
end
function library:CreateWindow(opts)
    local win={options=opts,widgets={},groups={},Gui={Destroying=signal()}}
    win.MinimizeButton={Position=pos(-14,14),Parent={win=win}}
    for _,key in ipairs({"SetTransparent","SetHideName","SetHideAvatar","SetToggleButton","SetSize"}) do
        win[key]=function(self,value)self[key.."_value"]=value end
    end
    function win:CreateTab(opts)local result=group(win);self.groups[opts.Name]=result;return result end
    function win:Destroy()self.destroyed=true;self.Gui.Destroying:Fire()end
    table.insert(windows,win);return win
end
local Http={
    JSONEncode=function(_,value)seq+=1;local token="JSON-"..seq;encoded[token]=clone(value);return token end,
    JSONDecode=function(_,value)check(encoded[value]~=nil,"encoded settings available");return clone(encoded[value]) end,
}
local player={UserId=123}
local env
local function inst(class)
    return setmetatable({Activated=signal(),ClassName=class},{__newindex=function(self,key,value)
        rawset(self,key,value)
        if key=="Parent" and value and value.win then value.win.widgets[self.Name]=self end
    end})
end
local coreInstances={}
env=setmetatable({
    game={PlaceId=85738654635245,GameId=10765490774,GetService=function(_,name)
        return name=="HttpService" and Http or {LocalPlayer=player}
    end,HttpGet=function()return "return MOCK_LIB"end},
    getgenv=function()return scope end,MOCK_LIB=library,
    UDim2={fromOffset=pos},UDim={new=function()return {}end},
    Vector2={new=pos},Color3={new=function()return {}end,fromRGB=function()return {}end},
    Enum={Font={GothamSemibold="font"}},Instance={new=inst},
    isfile=function(name)return files[name]~=nil end,
    readfile=function(name)assert(files[name],"missing file");return files[name]end,
    writefile=function(name,value)files[name]=value end,
    setclipboard=function(value)clipboard=value end,
    task={defer=function(fn)fn()end},
},{__index=getfenv(0)})
env.loadstring=function(source,label)local fn,problem=loadstring(source,label);if fn then setfenv(fn,env)end;return fn,problem end
env.MOCK_MAKE=function(config,notify)
    check(config.Farm==false,"workers initially disabled before saved filters restore")
    local c={Config=config,Report={status="Ready",picked=0,stored=0,placed=0,hatched=0,lost=0,jobs={}}}
    function c.Set(key,value)config[key]=value end
    function c.Stop()for k,v in pairs(config)do if type(v)=="boolean" and (k=="Farm" or k:match("^Auto"))then config[k]=false end end end
    function c.Destroy()destroyedCores+=1;c.Stop()end
    function c.SaveReport()clipboard="report";return clipboard end
    table.insert(coreInstances,c);return c
end
local run=assert(env.loadstring(UI_TEST_SOURCE,"Climb UI"))
local c=run();local first=windows[#windows]
local flySlider=first.widgets["ความเร็วลอยเก็บไข่"]
check(flySlider and flySlider.options.CurrentValue==60 and flySlider.options.Range[2]==500,"collection flight slider exposes default and limit")
flySlider:Set(500)
check(c.Config.FlySpeed==500,"collection flight slider updates the runtime configuration")
check(first.options.Name=="DEVIL HUB" and first.options.Profile and first.options.Loading==false,"DEVIL GUI profile + no duplicate loading")
check(first.widgets["DevilLanguageButton"]~=nil,"header language button beside minimize")
first.widgets["ระดับไข่: สูงสุดอยู่บน"]:Set({"Divine"},false)
first.widgets["เก็บไข่และกลับฐานอัตโนมัติ"]:Set(true,false)
check(first.widgets["ความเร็วลอย (studs/วินาที)"]==nil,"obsolete flight speed slider removed")
first.widgets["เงินสำรอง"]:Set("1000",false)
first.widgets["ขายสัตว์เฉพาะระดับที่เลือก"]:Set(true,false)
first.widgets["ระดับที่จะขาย"]:Set({"Common"},false)
first.widgets["หน้าต่างโปร่งใส"]:Set(true,false)
check(c.Config.Tiers.Divine and c.Config.Farm and c.Config.AutoSell,"controls update actual configuration")
first.widgets["DevilLanguageButton"].Activated:Fire()
local second=windows[#windows]
check(c.Config.Language=="EN" and c.Config.Farm and c.Config.Tiers.Divine,"language rebuild preserves farm settings")
check(destroyedCores==0 and second.options.Profile,"rebuild does not unload gameplay")
second.widgets["Save Current Settings"].options.Callback()
check(files["DevilClimbEggSettings_123.json"]~=nil,"settings saved per account")
second.widgets["Copy Invite Link"].options.Callback();check(clipboard=="https://discord.gg/ZY7PRcVJe2","Discord invitation copied")
second.widgets["Copy / Save Report"].options.Callback();check(clipboard=="report","report button reachable")
c.Destroy();check(destroyedCores==1 and not scope.DevilClimbEggs,"unload cleans instance")
local c2=run();local third=windows[#windows]
check(c2.Config.Language=="EN" and c2.Config.Farm and c2.Config.ReserveCash==1000 and c2.Config.Tiers.Divine,"fresh run restores saved filters + enabled auto")
check(c2.Config.AutoSell and c2.Config.SellTiers.Common and c2.Config.Transparent,"fresh run restores automation and appearance")
check(third.SetTransparent_value,"restored appearance applied")
third.widgets["Stop All"].options.Callback()
check(not c2.Config.Farm and not c2.Config.AutoSell,"stop all disables running automations")
local fourth=windows[#windows]
fourth.widgets["Load Saved Settings"].options.Callback()
check(c2.Config.Farm and c2.Config.AutoSell,"manual restore activates saved workers")
local saved=encoded[files["DevilClimbEggSettings_123.json"]];saved.userId=999
local before=c2.Config.ReserveCash
windows[#windows].widgets["Load Saved Settings"].options.Callback()
check(c2.Config.ReserveCash==before and c2.Config.Farm,"wrong-account file preserves live state")
c2.Destroy();check(destroyedCores==2,"second unload cleans only once")
print("PASS Climb DEVIL HUB UI + save/restore:",checks,"checks")
