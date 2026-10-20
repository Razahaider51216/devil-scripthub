-- Appended to the retained runtime fixture; runs with both production baseline and patched core.
local function session()
 attrs.CarryingEgg=nil;cfg.Farm=true;cfg.AutoStore=false;cfg.AutoPlace=false
 deps.Controllers.FallController.IsFalling=false;hum.FloorMaterial=nil
 root.Position=vec(48,200,0);deps.World.Raycast=nil
 local app=make(cfg,nil,P,deps);app.Scan=c.Scan;app.FlyTo=c.Travel
 return app
end
local ended,manual,immediate=0,false,false
prompt.InputHoldBegin=function()end
prompt.InputHoldEnd=function()ended+=1;manual=false end
deps.FirePrompt=function()error('cancelled attempt must not activate')end
local app=session();local cancelled=false
task.wait=function(dt)
 originalWait(dt)
 if not cancelled and app.Report.interaction and app.Report.interaction.stage=='Holding native prompt'then
  cancelled=true;app.Set('Farm',false);immediate=ended>0
  -- A fresh manual hold starts immediately after switching automation off.
  manual=true
 end
end
app.FarmStep();task.wait=originalWait
if EXPECT_BASELINE then
 check(not immediate and not manual,'baseline cancellation defect did not reproduce')
else
 check(immediate and manual,'Stop must release immediately; retired worker must preserve later manual hold')
 check(app.Report.picked==0,'cancelled interaction counted a pickup')
end
app.Destroy()
-- Toggle off then on during the same yielded hold: a retired attempt cannot resume.
local calls=0;app=session();local toggled=false
deps.FirePrompt=function()calls+=1;attrs.CarryingEgg=wild.id end
task.wait=function(dt)
 originalWait(dt)
 if not toggled and app.Report.interaction and app.Report.interaction.stage=='Holding native prompt'then
  toggled=true;app.Set('Farm',false);app.Set('Farm',true)
 end
end
app.FarmStep();task.wait=originalWait
check(EXPECT_BASELINE and calls==1 or not EXPECT_BASELINE and calls==0,'off/on worker ownership regression')
app.Destroy()
-- UI/scheduler failure during a hold must still release native input.
local held=false;prompt.InputHoldBegin=function()held=true end
prompt.InputHoldEnd=function()held=false end
app=session();local injected=false
task.wait=function(dt)
 originalWait(dt)
 if not injected and app.Report.interaction and app.Report.interaction.stage=='Holding native prompt'then
  injected=true;error('injected frame error')
 end
end
local succeeded=pcall(app.FarmStep);task.wait=originalWait
check(EXPECT_BASELINE and not succeeded and held or not EXPECT_BASELINE and succeeded and not held,'error path must release held prompt')
app.Destroy();held=false
-- Executor fallback yields for ten seconds. It must not block the farm worker.
app=session();prompt.InputHoldBegin=function()end
local mainThread=coroutine.running();local pendingThread
local realSpawn=task.spawn
local cancelledThreads=0
task.spawn=function(fn)
 local thread=coroutine.create(fn);pendingThread=thread
 local ok,err=coroutine.resume(thread);assert(ok,err);return thread
end
task.cancel=function(thread)cancelledThreads+=1;assert(coroutine.close(thread))end
task.wait=function(dt)
 if coroutine.running()~=mainThread then coroutine.yield()else originalWait(dt)end
end
deps.FirePrompt=function()task.wait(10);attrs.CarryingEgg=wild.id end
local start=now;app.FarmStep();local elapsed=now-start
if EXPECT_BASELINE then check(elapsed>=10,'baseline fallback blocking did not reproduce')
else
 check(elapsed<6 and app.Report.picked==0,'slow executor call blocked farm worker or fabricated a pickup')
 check(cancelledThreads==1 and coroutine.status(pendingThread)=='dead','timed-out fallback task was not retired')
 check(app.Report.interaction.stage=='Prompt activation timed out','timeout evidence missing')
end
app.Destroy();task.wait=originalWait;task.spawn=realSpawn;task.cancel=nil
-- Native holding cannot start while the replicated humanoid is still airborne.
app=session();hum.FloorMaterial='Air';Enum.Material={Air='Air'}
local begins=0;prompt.InputHoldBegin=function()begins+=1;attrs.CarryingEgg=wild.id end
deps.FirePrompt=function()calls+=1 end
app.FarmStep()
check(EXPECT_BASELINE and begins==1 or not EXPECT_BASELINE and begins==0,'airborne pickup started')
app.Destroy();hum.FloorMaterial=nil
if not EXPECT_BASELINE then
 -- Executors without task.cancel keep one unresolved fallback rather than
 -- spawning copies. Its late completion cannot rewrite a retired report.
 app=session();prompt.InputHoldBegin=function()end
 local workers={};local activations=0
 task.spawn=function(fn)
  local thread=coroutine.create(fn);workers[#workers+1]=thread
  local ok,err=coroutine.resume(thread);assert(ok,err);return thread
 end
 task.wait=function(dt)
  if coroutine.running()~=mainThread then coroutine.yield()else originalWait(dt)end
 end
 deps.FirePrompt=function()activations+=1;task.wait(10)end
 start=now;app.FarmStep()
 check(now-start<6 and activations==1,'uncancellable fallback blocked worker')
 local retired=app.Report.interaction;local stage=retired.stage
 app.Set('Farm',false);app.Set('Farm',true)
 app.FarmStep();check(activations==1,'unresolved executor call was duplicated')
 assert(coroutine.resume(workers[1]))
 check(retired.stage==stage and retired.fallbackReturnedAt==nil,'retired callback rewrote interaction evidence')
 task.wait=originalWait;task.spawn=realSpawn;app.Destroy()
 -- A nearest-side ray misses the platform. Choose another grounded side.
 app=session();prompt.InputHoldBegin=function()attrs.CarryingEgg=wild.id end
 RaycastParams={new=function()return{}end};Enum.RaycastFilterType={Exclude='Exclude'}
 root.Position=vec(47,200,0)
 deps.World.Raycast=function(_,origin,direction,params)
  if direction.Y>0 then return nil end
  if origin.X<50 then return nil end
  return {Position=vec(origin.X,197,origin.Z),Normal=vec(0,1,0)}
 end
 app.FarmStep()
 check(app.Report.picked==1 and root.Position.X>=50,'edge landing failed to select a supported side')
 app.Destroy()
 app=session();begins=0;prompt.InputHoldBegin=function()begins+=1 end
 deps.World.Raycast=function(_,origin,direction)
  if direction.Y>0 then return nil end
  return {Position=vec(origin.X,215,origin.Z),Normal=vec(0,1,0)}
 end
 app.FarmStep()
 check(begins==0 and app.Report.picked==0,'roof outside activation range was accepted as a landing')
 app.Destroy();deps.World.Raycast=nil
 app=session();prompt.InputHoldBegin=function()attrs.CarryingEgg=wild.id end
 deps.World.Raycast=function(_,origin,direction)
  if direction.Y>0 then return {Position=origin}end
  return {Position=vec(origin.X,197,origin.Z),Normal=vec(0,1,0)}
 end
 app.FarmStep();check(app.Report.picked==0,'obstructed standing point accepted')
 app.Destroy();deps.World.Raycast=nil
end
c.Destroy()
print(EXPECT_BASELINE and 'PASS reproduced old cancellation, stale restart, leaked input, blocking fallback and airborne defects' or 'PASS Steal cancellation, manual input restoration, restart, error cleanup, executor timeout and supported landing regressions')
