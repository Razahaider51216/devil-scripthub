-- Keep the engine's screen/layout state intact during startup; hide its pixels.
return function(screen)
    screen:SetAttribute("DevilBlueSettings",true)
    screen:SetAttribute("DevilNativeCanvas",true)
    local canvas=screen:FindFirstChild("DevilNativeCanvas")
    if not canvas then
        canvas=Instance.new("CanvasGroup");canvas.Name="DevilNativeCanvas"
        canvas.BackgroundTransparency=1;canvas.GroupTransparency=1
        canvas.Size=UDim2.fromScale(1,1);canvas.Position=UDim2.fromScale(0,0)
        canvas.Active=false;canvas:SetAttribute("DevilBlueSettings",true)
        canvas.Parent=screen
    end
    return canvas
end
