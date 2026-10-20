-- Bind directly to the created screen; hidden-UI container discovery is not required.
return function(screen)
    -- The hidden native controls do not need a second full theme/localization pass.
    screen:SetAttribute("DevilBlueSettings",true)
    screen.Enabled=false
    screen:GetPropertyChangedSignal("Enabled"):Connect(function()
        if screen.Enabled then screen.Enabled=false end
    end)
    return screen
end
