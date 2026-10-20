local checks=0
local function check(value,message)checks+=1;assert(value,message)end
local makeCore=(function()
-- TEST_CORE
end)()
local function copy(value)
 if type(value)~='table'then return value end
 local out={};for k,v in pairs(value)do out[k]=copy(v)end;return out
end
local function setup(mode)
 local files,encoded={},{};local serial,cancels=0,0
 local http={JSONEncode=function(_,value)serial+=1;local key='json'..serial;encoded[key]=copy(value);return key end,
  JSONDecode=function(_,text)return copy(assert(encoded[text],'invalid JSON'))end}
 local ctx={UserId=77,PlaceId=113290951185459,Ready=true,Clock=function()return 0 end,Spawn=function()end,
  CancelMovement=function()cancels+=1 end}
 local core=makeCore(ctx,{})
 local host=setmetatable({game={GetService=function()return http end}},{__index=getfenv()})
 if mode~='no-read'then host.readfile=function(name)return assert(files[name],'missing')end end
 if mode~='no-write'then host.writefile=function(name,text)if mode=='broken-write'then error('denied')end;files[name]=text end end
 host.isfile=function(name)if mode=='broken-isfile'then error('denied')end;return files[name]~=nil end
 local run=assert(loadstring(settingsSource));setfenv(run,host)
 local api=run()(core,ctx)
 local function store(value)files[api.Report.File]=http:JSONEncode(value)end
 return {api=api,core=core,ctx=ctx,cfg=core.Config,files=files,http=http,store=store,
  cancels=function()return cancels end,profile=function()return http:JSONDecode(files[api.Report.File])end}
end
do
 local f=setup()
 check(not f.api.Load()and f.cancels()==0,'missing settings mutated live configuration')
 f.cfg.MoneyReserve=2345;f.cfg.SellRarities={Rare=true};f.cfg.CodeList={'A','B'};f.cfg.SelectedUnit='stable-id'
 f.cfg.KeepIds={['stable-id']=true};f.cfg.PumpkinSellNames={Mummy=true};f.cfg.ProtectedTraits={Strong=true}
 f.core.Set('Doors',true);f.cfg.SkipMutations=false
 check(f.api.Save(),'save failed')
 local profile=f.profile();check(profile.Schema==1 and profile.UserId==77 and profile.PlaceId==f.ctx.PlaceId,'saved identity / schema missing')
 f.core.Set('Doors',false);f.cfg.MoneyReserve=0;f.cfg.SellRarities={};f.cfg.SkipMutations=true
 check(f.api.Load(function()
  check(not f.cfg.Doors and f.cfg.MoneyReserve==2345 and f.cfg.SellRarities.Rare,'automation enabled before filters were restored')
 end),'load failed')
 check(f.cfg.Doors and not f.cfg.SkipMutations and f.cfg.KeepIds['stable-id']and f.cfg.SelectedUnit=='stable-id','automation, false boolean or stable IDs lost')
 check(f.cfg.PumpkinSellNames.Mummy and f.cfg.ProtectedTraits.Strong and f.cfg.CodeList[2]=='B','table / list selections lost')
 check(f.api.Reset()and not f.cfg.Doors and f.cfg.MoneyReserve==0 and not next(f.cfg.SellRarities),'reset failed')
 check(f.profile().Values.Doors==false and f.profile().Values.MoneyReserve==0,'reset not persisted')
end
for _,bad in ipairs({
 {Schema=2,UserId=77,PlaceId=113290951185459,Values={}},
 {Schema=1,UserId=88,PlaceId=113290951185459,Values={Doors=true}},
 {Schema=1,UserId=77,PlaceId=1,Values={Doors=true}},
 {Schema=1,UserId=77,PlaceId=113290951185459,Values={MoneyReserve='0',Doors=true}},
 {Schema=1,UserId=77,PlaceId=113290951185459,Values={MoneyReserve=-1,Doors=true}},
 {Schema=1,UserId=77,PlaceId=113290951185459,Values={MoneyReserve=math.huge,Doors=true}},
 {Schema=1,UserId=77,PlaceId=113290951185459,Values={SellRarities={Rare='true'},Doors=true}},
 {Schema=1,UserId=77,PlaceId=113290951185459,Values={CodeList={BAD='code'},Doors=true}},
 {Schema=1,UserId=77,PlaceId=113290951185459,Values={SkipMutations='false',Doors=true}},
})do
 local f=setup();f.cfg.MoneyReserve=999;f.core.Set('Doors',true);f.store(bad)
 check(not f.api.Load(),'invalid profile accepted')
 check(f.cfg.MoneyReserve==999 and f.cfg.Doors and f.cancels()==0,'invalid profile partially changed settings / automation')
end
do
 local f=setup();f.files[f.api.Report.File]='not-json'
 check(not f.api.Load()and not f.cfg.Doors,'malformed file enabled automation')
 f.files[f.api.Report.File]=string.rep('x',1048577)
 check(not f.api.Load(),'oversized file accepted')
 f.store({Schema=1,UserId=77,PlaceId=f.ctx.PlaceId,Values={MoneyReserve=45,Unknown=true}})
 check(f.api.Load()and f.cfg.MoneyReserve==45 and f.cfg.Unknown==nil and not f.cfg.Doors,'schema migration failed / unknown field installed')
end
for _,mode in ipairs({'no-read','no-write','broken-write','broken-isfile'})do
 local f=setup(mode)
 if mode=='no-read'then check(not f.api.Load(),'missing read API escaped')
 elseif mode=='broken-isfile'then check(f.api.Save()and f.api.Load(),'optional isfile failure blocked readable file')
 else check(not f.api.Save(),'missing / failing write API escaped')end
 check(not f.cfg.Doors,'file API failure started automation')
end
do
 local f=setup();f.core.Set('Doors',true);f.api.Save();f.core.Set('Doors',false);f.ctx.Ready=false
 check(not f.api.Load()and not f.cfg.Doors,'settings resumed automation before data readiness')
 f.cfg.MoneyReserve=100;f.core.Set('Doors',true)
 check(f.api.Reset()and not f.cfg.Doors and f.cfg.MoneyReserve==0,'reset during initialization left automation enabled')
 f.ctx.Ready=true;f.store({Schema=1,UserId=77,PlaceId=f.ctx.PlaceId,Values={Doors=true}})
 check(not f.api.Load(function()error('GUI unavailable')end)and not f.cfg.Doors,'failed UI restoration enabled saved automation')
end
print('PASS saved settings: schema, identity, validation, ordering, lists, false values, reset, API failures and readiness: '..checks..' checks')
