-- Matches General / cloned Frame / ImageButton attributes in treadmillMultiplier.
local children={}
local function frame(id,action)
    local button={GetAttribute=function(_,k)if k=="Id"then return id elseif k=="Action"then return action or "ClaimTmMultiplier"end end}
    local f={Visible=true,FindFirstChildOfClass=function()return button end}
    function f:Destroy()self.destroyed=true;self.Visible=false end
    table.insert(children,f);return f
end
local general={GetChildren=function()return children end}
player.FindFirstChild=function()return {FindFirstChild=function()return general end}end
local unlinked=0
deps.Controllers.ButtonsController={Unlink=function()unlinked+=1 end}
local calls={}
local fail=false
treadmill.ClaimMultiplier=function(_,id)
    if fail then error("temporary failure")end
    calls[id]=(calls[id]or 0)+1
end
local oldFrame=frame("before-enable")
local template=frame(nil);local unrelated=frame("other","OtherAction")
cfg=P.Defaults()
local app=make(cfg,nil,P,deps)
app.JobsStep();check(not calls["before-enable"],"bonus off leaves manual buttons alone")
cfg.AutoBonus=true;app.JobsStep()
check(calls["before-enable"]==1 and oldFrame.destroyed and unlinked==1,"existing visible bonus claimed and unlinked")
check(not template.destroyed and not unrelated.destroyed,"template and unrelated controls preserved")
signal:Fire("new","stale-session");app.JobsStep();check(not calls.new,"stale signal ignored")
signal:Fire("new","session-1");signal:Fire("new","session-1")
local f=frame("new");app.JobsStep();app.JobsStep()
check(calls.new==1 and f.destroyed,"new signal plus frame claims once")
local retry=frame("retry");fail=true;app.JobsStep()
check(not retry.destroyed and not calls.retry,"failed request keeps button for retry")
fail=false;app.JobsStep();check(calls.retry==1 and retry.destroyed,"transient failure retries")
local ready=frame("ready");treadmill.LoadedAnimation=nil;app.JobsStep()
check(not calls.ready,"wait for native training animation readiness")
treadmill.LoadedAnimation={};app.JobsStep();check(calls.ready==1,"readiness recovery")
cfg.AutoBonus=false;cfg.AutoTrain=true
local automatic=frame("auto-train");app.JobsStep()
check(calls["auto-train"]==1 and automatic.destroyed,"auto treadmill includes bonuses")
cfg.AutoTrain=false;treadmill.OnTreadmill=false;app.JobsStep()
signal:Fire("off","session-1");check(not calls.off,"no requests off treadmill")
treadmill.OnTreadmill=true;treadmill.TreadmillSession="session-2";cfg.AutoBonus=true
local again=frame("new");app.JobsStep()
check(calls.new==2 and again.destroyed,"new session can reuse native id")
local total=0
for i=1,20 do frame("batch-"..i)end
app.JobsStep();for id,n in pairs(calls)do if id:match("batch")then total+=n end end
check(total==8,"bounded eight bonus requests per worker tick")
app.JobsStep();app.JobsStep()
total=0;for id,n in pairs(calls)do if id:match("batch")then total+=n end end
check(total==20,"backlog drains over bounded ticks")
app.Stop();local stop=frame("stopped");signal:Fire("stopped","session-2");app.JobsStep()
check(not calls.stopped and not stop.destroyed,"stop all disables bonus worker")
app.Destroy();cfg.AutoBonus=true;signal:Fire("unloaded","session-2");app.JobsStep()
check(not calls.unloaded,"unload disconnects and stops worker")
print("PASS training bonus regressions",checks)
