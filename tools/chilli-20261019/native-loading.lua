-- Retain the protected engine's progress contract without creating another GUI.
return function()
    local scope=type(getgenv)=="function"and getgenv()or _G
    scope.ChilliCanvasHold=true;scope.ChilliHubLoading=os.clock()+30
    scope.ChilliHubLoadStep=function(value)
        local step=math.clamp(math.floor(tonumber(value)or 0),0,10)
        local loading=scope.DevilHubLoadController
        if loading and type(loading.Update)=="function"then
            pcall(loading.Update,"Loading Steal an Egg systems ("..step.."/10)...",.7+step*.01)
        end
        if step>=10 then
            scope.ChilliHubLoadStep=nil;scope.ChilliCanvasHold=nil;scope.ChilliHubLoading=nil
        end
        if task and type(task.wait)=="function"then task.wait()end
    end
end
