-- Keep real Steal Panel item artwork separate from themed menu surfaces.
return function(parent,icon,launcher)
    if not icon or not(icon:IsA("ImageLabel")or icon:IsA("ImageButton"))then
        icon=Instance.new("ImageLabel");icon.Name="Icon"
        icon.AnchorPoint=Vector2.new(0,.5);icon.Position=UDim2.new(0,8,.5,0)
        icon.Size=UDim2.fromOffset(48,48);icon.ZIndex=parent.ZIndex+1
        icon:SetAttribute("DevilBlueSettings",true);icon.Parent=parent
    end
    icon:SetAttribute("DevilBlueSettings",true)
    icon:SetAttribute("DevilStealArtwork",true)
    icon.ImageColor3=Color3.new(1,1,1);icon.ImageTransparency=0
    icon.BackgroundTransparency=1;icon.Visible=true;icon.ScaleType=Enum.ScaleType.Fit
    for _,child in ipairs(icon:GetChildren())do
        if child:IsA("UIGradient")then
            child:SetAttribute("DevilBlueSettings",true)
            child.Color=ColorSequence.new(Color3.new(1,1,1))
            child.Transparency=NumberSequence.new(0)
        end
    end
    if launcher then
        icon.AnchorPoint=Vector2.new(.5,.5);icon.Position=UDim2.fromScale(.5,.5)
        icon.Size=UDim2.fromScale(.68,.68);icon.ZIndex=math.max(icon.ZIndex,parent.ZIndex+1)
        -- This is the native Steal Filter artwork, used until a live item is selected.
        if icon.Image==""then icon.Image="rbxassetid://97499770821177"end
        if not icon:GetAttribute("DevilStealLauncher")then
            icon:SetAttribute("DevilStealLauncher",true)
            local fallback=Instance.new("Frame");fallback.Name="DevilStealFallback"
            fallback.BackgroundTransparency=1;fallback.Size=UDim2.fromScale(1,1)
            fallback:SetAttribute("DevilBlueSettings",true);fallback.Parent=icon
            -- A small vector egg remains visible even if executor asset loading fails.
            local points={{.5,.08},{.35,.15},{.23,.32},{.15,.55},{.16,.73},{.28,.87},{.5,.93},{.72,.87},{.84,.73},{.85,.55},{.77,.32},{.65,.15},{.5,.08}}
            local canvas=Instance.new("Frame");canvas.BackgroundTransparency=1
            canvas.Size=UDim2.fromOffset(32,32);canvas.Position=UDim2.fromScale(.5,.5);canvas.AnchorPoint=Vector2.new(.5,.5)
            canvas:SetAttribute("DevilBlueSettings",true);canvas.Parent=fallback
            for i=1,#points-1 do
                local a,b=points[i],points[i+1];local dx,dy=(b[1]-a[1])*32,(b[2]-a[2])*32
                local line=Instance.new("Frame");line.BorderSizePixel=0;line.AnchorPoint=Vector2.new(.5,.5)
                line.Position=UDim2.fromOffset((a[1]+b[1])*16,(a[2]+b[2])*16)
                line.Size=UDim2.fromOffset(math.sqrt(dx*dx+dy*dy)+1,2)
                line.Rotation=math.deg(math.atan2(dy,dx));line.ZIndex=icon.ZIndex+1
                line.BackgroundColor3=i<=6 and Color3.fromRGB(164,221,255)or Color3.new(1,1,1)
                line:SetAttribute("DevilBlueSettings",true);line.Parent=canvas
            end
            local function update()fallback.Visible=icon.Image==""or not icon.IsLoaded end
            icon:GetPropertyChangedSignal("IsLoaded"):Connect(update)
            icon:GetPropertyChangedSignal("Image"):Connect(update);update()
        end
    end
    return icon
end
