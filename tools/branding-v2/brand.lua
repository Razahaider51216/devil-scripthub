-- PNG branding and a vector D compiled from assets/devil-d-toggle.svg.
-- Only owned brand ImageLabels/ImageButtons are changed; native input stays intact.
return function(scope,links)
    local B={Version="devil-brand-v2-20261022-1",Image=nil,Status="Not loaded"}
    local records=setmetatable({},{__mode="k"})
    local rectangles=__D_RECTS__
    local colors={Color3.fromRGB(245,251,255),Color3.fromRGB(97,212,255),Color3.fromRGB(255,255,255)}
    local function connect(signal,fn)
        local link=signal:Connect(fn);links[#links+1]=link;return link
    end
    function B.Matches(image)
        return type(image)=="string"and(image==B.Image or image:find("devilhubv2",1,true)~=nil
            or image:find("DevilHub_LogoV2",1,true)~=nil)
    end
    local function glyph(node)
        local frame=Instance.new("Frame");frame.Name="DevilCustomD"
        frame:SetAttribute("DevilBlueSettings",true);frame:SetAttribute("CustomIcon",true)
        frame.BackgroundTransparency=1;frame.Active=false;frame.AnchorPoint=Vector2.new(.5,.5)
        frame.Position=UDim2.fromScale(.5,.5);frame.Size=UDim2.fromScale(1,1);frame.ZIndex=node.ZIndex+1
        local aspect=Instance.new("UIAspectRatioConstraint");aspect.AspectRatio=1
        aspect:SetAttribute("DevilBlueSettings",true);aspect.Parent=frame
        for _,r in ipairs(rectangles)do
            local part=Instance.new("Frame");part.Name="DVector"
            part:SetAttribute("DevilBlueSettings",true);part.BackgroundColor3=colors[r[5]]
            part.BorderSizePixel=0;part.Active=false;part.Position=UDim2.fromScale(r[1]/64,r[2]/64)
            part.Size=UDim2.fromScale(r[3]/64,r[4]/64);part.ZIndex=frame.ZIndex+1;part.Parent=frame
        end
        frame.Parent=node;return frame
    end
    function B.Apply(node,classify)
        if not(node:IsA("ImageLabel")or node:IsA("ImageButton"))then return end
        local isLogo=classify(node)
        local record=records[node]
        if not isLogo and not record then return end
        if record then record.Update();return end
        record={Writing=false,Original={Image=node.Image,ImageTransparency=node.ImageTransparency,ImageColor3=node.ImageColor3}}
        records[node]=record
        local function update()
            if record.Writing or not node.Parent then return end
            record.Writing=true
            local _,launcher=classify(node)
            record.Launcher=launcher or record.Launcher
            local vector=record.Launcher or not B.Image
            if vector then
                if not record.Glyph or not record.Glyph.Parent then record.Glyph=glyph(node)end
                record.Glyph.Visible=true;node.ImageTransparency=1
                record.Glyph.ZIndex=node.ZIndex+1
                for _,part in ipairs(record.Glyph:GetChildren())do if part:IsA("GuiObject")then part.ZIndex=node.ZIndex+2 end end
            else
                if record.Glyph then record.Glyph.Visible=false end
                node.Image=B.Image;node.ImageTransparency=0
            end
            node.ImageColor3=Color3.fromRGB(255,255,255);node:SetAttribute("CustomIcon",true)
            record.Writing=false
        end
        record.Update=update
        for _,key in ipairs({"Image","ImageTransparency","ImageColor3","Parent","ZIndex","Name"})do connect(node:GetPropertyChangedSignal(key),update)end
        connect(node.Destroying,function()if record.Glyph then record.Glyph:Destroy()end;records[node]=nil end)
        update()
    end
    function B.Resolve()
        if scope.DevilHubLogoV2Version==B.Version and type(scope.DevilHubLogoV2)=="string"then
            B.Image=scope.DevilHubLogoV2;B.Status="Cached";return B.Image
        end
        local ok,result=pcall(function()
            local custom=getcustomasset or getsynasset
            assert(type(custom)=="function"and type(writefile)=="function","Asset API unavailable")
            local file="DevilHub_LogoV2_20261022.png"
            local bytes
            if type(readfile)=="function"and type(isfile)=="function"and isfile(file)then local read,value=pcall(readfile,file);if read then bytes=value end end
            local function valid(value)
                if type(value)~="string"or #value~=__LOGO_LEN__ or value:sub(1,8)~="\137PNG\13\10\26\10"then return false end
                local sum=0;for i=1,#value do sum=(sum*33+value:byte(i))%4294967296;if i%32768==0 and task and task.wait then task.wait()end end
                return sum==__LOGO_CHECKSUM__
            end
            if not valid(bytes)then bytes=game:HttpGet("__LOGO_URL__");assert(valid(bytes),"Logo integrity failed");writefile(file,bytes)end
            local image=custom(file);assert(type(image)=="string"and image~=""and not image:match("^https?://"),"Asset registration failed")
            return image
        end)
        B.Status=ok and"Ready"or"Vector fallback"
        if ok then B.Image=result;scope.DevilHubLogoV2=result;scope.DevilHubLogoV2Version=B.Version
            scope.DevilHubSilverLogo=result;scope.DevilHubSilverLogoVersion=B.Version
        end
        for _,record in pairs(records)do record.Update()end
        return B.Image
    end
    function B.Destroy()
        for node,record in pairs(records)do
            if record.Glyph then record.Glyph:Destroy()end
            if node.Parent then for key,value in pairs(record.Original)do node[key]=value end end
        end
        table.clear(records)
    end
    return B
end
