-- Local startup breadcrumbs; no network reporting, hooks or replacement compiler.
return function(initialPhase)
    local scope=type(getgenv)=="function"and getgenv()or _G
    if scope.DevilStealStartupTrace and scope.DevilStealStartupTrace.Version=="steal-startup-layout-20261020-4"
        and type(scope.DevilStealStartupStage)=="function"then
        scope.DevilStealStartupStage(initialPhase or"Native layer decoded")
        return scope.DevilStealStartupStage
    end
    local report={Version="steal-startup-layout-20261020-4",LastPhase="Runtime entry",Steps={},Executor="Unknown",
        StartedAt=os.clock(),PlaceId=game.PlaceId,Capabilities={Buffer=type(buffer)=="table",Loadstring=type(loadstring)=="function"}}
    local identify=identifyexecutor or getexecutorname
    if type(identify)=="function"then
        local ok,name,version=pcall(identify)
        if ok then report.Executor=tostring(name)..(version and(" / "..tostring(version))or"")end
    end
    scope.DevilStealStartupTrace=report
    local function stage(name)
        if report.LastPhase==name and #report.Steps>0 then return end
        report.LastPhase=name;report.Elapsed=os.clock()-report.StartedAt
        report.Steps[#report.Steps+1]={Phase=name,At=report.Elapsed}
        if #report.Steps>24 then table.remove(report.Steps,1)end
        if type(writefile)=="function"then pcall(function()
            writefile("DevilHub-Steal-Startup.json",game:GetService("HttpService"):JSONEncode(report))
        end)end
        warn("DEVIL HUB startup: "..name)
        local loading=scope.DevilHubLoadController
        if loading and type(loading.Update)=="function"then pcall(loading.Update,"Steal startup: "..name,.7)end
    end
    scope.DevilStealStartupStage=stage
    stage(initialPhase or"Native layer decoded")
    return stage
end
