-- Scoped to native presentation callbacks. Gameplay signals and VM scheduling stay native.
return function(signal,root,callback)
    local elapsed,visibilityElapsed,shown=0,.25,true
    return signal:Connect(function(dt)
        elapsed+=dt;visibilityElapsed+=dt
        if elapsed<1/30 then return end
        if visibilityElapsed>=.25 then
            visibilityElapsed=0;shown=true
            local node=root;local screen=false
            while node do
                if node:IsA("ScreenGui")then screen=true end
                if node:IsA("GuiObject")and not node.Visible or node:IsA("ScreenGui")and not node.Enabled then shown=false;break end
                node=node.Parent
            end
            if not screen then shown=false end
        end
        if not shown and elapsed<.25 then return end
        local delta=elapsed;elapsed=0
        callback(delta)
    end)
end
