return function(window,A,P,assets)
    local V={Pickers={},Alive=true,Models={},Loading={},PreviewCount=0}
    local function node(class,parent,props)
        local n=Instance.new(class);for k,v in pairs(props)do n[k]=v end;n.Parent=parent;return n
    end
    function V.Image(parent,item,size)
        local icon=assets[item.Id]
        if icon then
            local n=node("ImageLabel",parent,{Name="DevilItemIcon",Size=UDim2.fromOffset(size,size),BackgroundTransparency=1,Image=icon,ImageColor3=Color3.new(1,1,1),ScaleType=Enum.ScaleType.Fit,ZIndex=parent.ZIndex+1})
            n:SetAttribute("CustomIcon",true);return n
        end
        local view=node("ViewportFrame",parent,{Name="DevilItemModel",Size=UDim2.fromOffset(size,size),BackgroundTransparency=1,Ambient=Color3.new(1,1,1),LightColor=Color3.new(1,1,1),ZIndex=parent.ZIndex+1})
        view:SetAttribute("CustomIcon",true)
        A.Spawn(function()
            if not V.Alive or not view.Parent then return end
            local model
            if item.Kind=="Material"and item.Instance then
                model=Instance.new("Model");local part=item.Instance:Clone();part.Size=Vector3.new(3,3,3);part.CFrame=CFrame.new();part.Transparency=0;part.Parent=model
            else
                local name=({Egg="EggModel",Artifact="ArtifactModels",Potion="PotionModel"})[item.Kind]
                local module=name and A.RS:FindFirstChild("Shared");module=module and module:FindFirstChild(name)
                if module then
                    -- Only allowlisted pure model builders; never start native client controllers.
                    local ok,builder=pcall(require,module)
                    if ok and V.Alive and view.Parent and type(builder)=="table"and type(builder.create)=="function"then
                        local good,value=pcall(builder.create,item.Id);if good and typeof(value)=="Instance"then model=value end
                    end
                end
            end
            if not model then return end
            if not V.Alive or not view.Parent then model:Destroy();return end
            for _,n in ipairs(model:GetDescendants())do
                if n:IsA("BaseScript")or n:IsA("ModuleScript")or n:IsA("ParticleEmitter")or n:IsA("Trail")or n:IsA("Beam")then n:Destroy()
                elseif n:IsA("BasePart")then n.Anchored=true;n.CanCollide=false;n.CanTouch=false;n.CanQuery=false end
            end
            local world=Instance.new("WorldModel");world.Parent=view;model.Parent=world
            local frame,extent=model:GetBoundingBox();local camera=Instance.new("Camera");camera.FieldOfView=35
            camera.CFrame=CFrame.lookAt(frame.Position+Vector3.new(1,.55,1).Unit*math.max(1,extent.Magnitude*1.8),frame.Position)
            camera.Parent=view;view.CurrentCamera=camera
        end)
        return view
    end
    function V.Picker(host,key,name,callback)
        local before={};for _,n in ipairs(window.Body:GetChildren())do before[n]=true end
        local picker={Map={},Rows=setmetatable({},{__mode="k"})}
        picker.Widget=host:CreateDropdown({Name=name,Options={},AllowNone=true,Searchable=true,PopupWidth=470,Callback=function(label)
            if type(label)=="table"then label=label[1]end
            local item=picker.Map[label];if item then callback(item.Id,item)end
        end})
        for _,n in ipairs(window.Body:GetChildren())do if not before[n]and n:IsA("Frame")then picker.Popup=n end end
        V.Pickers[key]=picker;return picker.Widget
    end
    function V.Refresh(key,items,selected)
        local picker=V.Pickers[key];if not picker then return end
        local names,map={},{}
        for _,item in ipairs(items)do local label=item.Label or item.Name or item.Id;names[#names+1]=label;map[label]=item end
        picker.Map=map
        local signature=table.concat(names,"\0")
        if signature~=picker.Signature then
            picker.Widget:Refresh(names,true,true);picker.Signature=signature
            if selected then for _,name in ipairs(names)do if map[name].Id==selected then picker.Widget:Set(name,true);break end end end
        end
        if not picker.Popup then return end
        for _,label in ipairs(picker.Popup:GetDescendants())do
            if label:IsA("TextLabel")and label.Parent and label.Parent:IsA("TextButton")and label.Name~="DevilItemPrice"then
                local plain=label.Text:gsub("<[^>]*>",""):gsub("&amp;","&");local item=map[plain]
                if item then
                    local row=picker.Rows[label]
                    if not row then
                        row={Label=label,Parent=label.Parent};picker.Rows[label]=row
                        label.Position=UDim2.fromOffset(44,0);label.Size=UDim2.new(1,-175,1,0)
                        row.Price=node("TextLabel",label.Parent,{Name="DevilItemPrice",Size=UDim2.fromOffset(118,30),AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-26,.5,0),BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=10,TextColor3=Color3.fromRGB(164,221,255),TextXAlignment=Enum.TextXAlignment.Right,ZIndex=label.ZIndex+1,Text=""})
                    end
                    row.Item=item;row.Price.Text=item.Detail or""
                    if assets[item.Id]and not row.Icon then row.Icon=V.Image(row.Parent,item,26);row.Icon.Position=UDim2.new(0,10,.5,-13)end
                end
            end
        end
    end
    function V.VisibleModels()
        -- Bound viewport cost to eight visible rows, even when hundreds of blocks stream in.
        local count=0
        for _,picker in pairs(V.Pickers)do
            for label,row in pairs(picker.Rows)do
                if row.Item and not assets[row.Item.Id]then
                    local popup=picker.Popup;local visible=V.Alive and label.Parent and popup and popup.Visible and label.AbsolutePosition.Y>=popup.AbsolutePosition.Y and label.AbsolutePosition.Y<popup.AbsolutePosition.Y+popup.AbsoluteSize.Y
                    if visible and count<8 then
                        count+=1;if not row.Icon then row.Icon=V.Image(row.Parent,row.Item,26);row.Icon.Position=UDim2.new(0,10,.5,-13)end
                    elseif row.Icon then row.Icon:Destroy();row.Icon=nil end
                end
            end
        end
    end
    function V.Destroy()V.Alive=false end
    return V
end
