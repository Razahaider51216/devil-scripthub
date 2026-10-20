-- Mirror progress without replacing the original engine initializer or waits.
return function(value)
    local scope=type(getgenv)=="function"and getgenv()or _G
    local step=math.clamp(math.floor(tonumber(value)or 0),0,10)
    if type(scope.DevilStealStartupStage)=="function"then scope.DevilStealStartupStage("Engine part "..step.."/10")end
    local loading=scope.DevilHubLoadController
    if loading and type(loading.Update)=="function"then
        pcall(loading.Update,"Loading Steal an Egg systems ("..step.."/10)...",.7+step*.01)
    end
end
