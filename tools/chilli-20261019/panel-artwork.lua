-- Keep real Steal Panel item artwork separate from themed menu surfaces.
return function(parent,icon)
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
    return icon
end
