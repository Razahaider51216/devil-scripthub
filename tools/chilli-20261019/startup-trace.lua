-- Local startup breadcrumbs; no network reporting, hooks or replacement compiler.
return function(initialPhase)
    local scope=type(getgenv)=="function"and getgenv()or _G
    if scope.DevilStealStartupTrace and scope.DevilStealStartupTrace.Version=="steal-startup-vm-20261020-5"
        and type(scope.DevilStealStartupStage)=="function"then
        scope.DevilStealStartupStage(initialPhase or"Native layer decoded")
        return scope.DevilStealStartupStage
    end
    local report={Version="steal-startup-vm-20261020-5",LastPhase="Runtime entry",Steps={},Executor="Unknown",
        StartedAt=os.clock(),PlaceId=game.PlaceId,Capabilities={Buffer=type(buffer)=="table",Loadstring=type(loadstring)=="function"}}
    local identify=identifyexecutor or getexecutorname
    if type(identify)=="function"then
        local ok,name,version=pcall(identify)
        if ok then report.Executor=tostring(name)..(version and(" / "..tostring(version))or"")end
    end
    scope.DevilStealStartupTrace=report
    local function stage(name,detail)
        local changed=report.LastPhase~=name or #report.Steps==0
        if not changed and not detail then return end
        if detail then report.VM=detail end
        report.LastPhase=name;report.Elapsed=os.clock()-report.StartedAt
        if changed then report.Steps[#report.Steps+1]={Phase=name,At=report.Elapsed}end
        if #report.Steps>24 then table.remove(report.Steps,1)end
        if type(writefile)=="function"then pcall(function()
            writefile("DevilHub-Steal-Startup.json",game:GetService("HttpService"):JSONEncode(report))
        end)end
        if changed then warn("DEVIL HUB startup: "..name)end
        local loading=scope.DevilHubLoadController
        local message="Steal startup: "..name
        if name=="VM initialization"and detail then
            message="Preparing Steal an Egg systems... "..tostring(math.floor(detail.Seconds)).."s"
        end
        if loading and type(loading.Update)=="function"then pcall(loading.Update,message,.7)end
    end
    scope.DevilStealStartupStage=stage
    stage(initialPhase or"Native layer decoded")
    return stage
end
