-- Owned UI additions. Native dropdown values and purchase callbacks stay intact.
return function(window,ctx,app,logo)
    local view={Cards={},Language="EN"}
    local white=Color3.fromRGB(255,255,255);local blue=Color3.fromRGB(164,221,255)
    local muted=Color3.fromRGB(160,178,195);local black=Color3.fromRGB(7,9,13)
    local candyPaths=__CANDY_PATHS__ -- Generated from assets/devil-candy.svg.
    local function node(class,name,parent,props)
        local obj=Instance.new(class);obj.Name=name
        for key,value in pairs(props or{})do obj[key]=value end
        obj.Parent=parent;return obj
    end
    local function label(name,parent,props)
        local defaults={BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=12,TextColor3=white,
            TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,RichText=false,ZIndex=83}
        for key,value in pairs(props or{})do defaults[key]=value end
        return node("TextLabel",name,parent,defaults)
    end
    local function corner(parent,radius)node("UICorner","Corner",parent,{CornerRadius=UDim.new(0,radius)})end
    local function line(parent,x1,y1,x2,y2,color,size,z)
        local scale=size/24;local dx,dy=x2-x1,y2-y1
        local part=node("Frame","VectorStroke",parent,{AnchorPoint=Vector2.new(.5,.5),
            Position=UDim2.fromOffset((x1+x2)*scale/2,(y1+y2)*scale/2),
            Size=UDim2.fromOffset(math.sqrt(dx*dx+dy*dy)*scale,1.7*scale),Rotation=math.deg(math.atan2(dy,dx)),
            BackgroundColor3=color,BorderSizePixel=0,ZIndex=z})
        corner(part,2)
    end
    function view.Candy(parent,size,z)
        local canvas=node("Frame","DevilCandyIcon",parent,{BackgroundTransparency=1,Size=UDim2.fromOffset(size,size),Rotation=-25,ZIndex=z})
        canvas:SetAttribute("DevilCandySvg",true)
        local body=node("Frame","CandyBody",canvas,{Position=UDim2.fromOffset(7*size/24,8*size/24),
            Size=UDim2.fromOffset(10*size/24,8*size/24),BackgroundTransparency=1,ZIndex=z})
        corner(body,4*size/24);node("UIStroke","Outline",body,{Color=blue,Thickness=1.7*size/24})
        for i,points in ipairs(candyPaths)do for j=1,#points-2,2 do
            line(canvas,points[j],points[j+1],points[j+2],points[j+3],i==2 and blue or white,size,z)
        end end
        return canvas
    end
    local function imageFor(name)
        local registry=ctx.Catalog.Registry
        local ok,spec=pcall(function()return registry.getEntryConfig(name)end)
        local image=ok and spec and spec.image
        if type(image)=="function"then local worked,value=pcall(image,{});image=worked and value or nil end
        if type(image)=="number"then image="rbxassetid://"..image end
        if type(image)=="string"and image~=""then return image end
        local images=ctx.Catalog.Halloween and ctx.Catalog.Halloween.Images or{}
        return images[name]or images[name:gsub("%s","")]
    end
    function view.Item(parent,name,size,z)
        local image=imageFor(name)
        if image then
            local obj=node("ImageLabel","ItemIcon",parent,{Size=UDim2.fromOffset(size,size),BackgroundTransparency=1,
                Image=image,ImageColor3=white,ScaleType=Enum.ScaleType.Fit,ZIndex=z})
            obj:SetAttribute("CustomIcon",true);return obj
        end
        if name=="Candy"then return view.Candy(parent,size,z)end
        return label("ItemIconFallback",parent,{Text="◇",TextColor3=blue,TextSize=size-2,Size=UDim2.fromOffset(size,size),
            TextXAlignment=Enum.TextXAlignment.Center,ZIndex=z})
    end
    local function quantity(value)
        local text=string.format("%.0f",value)
        local result=text:reverse():gsub("(%d%d%d)","%1,"):reverse():gsub("^,","")
        return result
    end
    -- Capture only the popup created by this dropdown; other selectors are untouched.
    local function picker(host,name,selected,default)
        local before={};if window.Body then for _,child in ipairs(window.Body:GetChildren())do before[child]=true end end
        local widget=host:CreateDropdown({Name=name,Options=default and{default}or{},CurrentOption=default,Searchable=true,PopupWidth=420,
            AllowNone=default==nil,Callback=selected})
        local popup
        if window.Body then for _,child in ipairs(window.Body:GetChildren())do
            if not before[child]and child:IsA("Frame")then popup=child end
        end end
        return widget,popup
    end
    function view.CreateShop(host,selected)
        local widget,popup=picker(host,"Candy shop item",selected)
        view.ShopWidget=widget;view.ShopPopup=popup
        return widget
    end
    local function plainText(text)
        return text:gsub("<[^>]*>",""):gsub("&amp;","&"):gsub("&lt;","<"):gsub("&gt;",">")
    end
    local shopRows=setmetatable({},{__mode="k"})
    function view.RefreshShop(offers)
        local names,map={},{}
        for _,offer in ipairs(offers or{})do names[#names+1]=offer.name;map[offer.name]=offer end
        view.ShopWidget:Refresh(names,true,true)
        local popup=view.ShopPopup;if not popup then return end
        for _,text in ipairs(popup:GetDescendants())do
            if text:IsA("TextLabel")and text.Parent and text.Parent:IsA("TextButton")then
                local plain=plainText(text.Text)
                local offer=map[plain]
                if offer then
                    local row=shopRows[text]
                    if not row then
                        row={};shopRows[text]=row
                        text.Position=UDim2.fromOffset(42,0);text.Size=UDim2.new(1,-158,1,0)
                        row.Icon=view.Item(text.Parent,plain,22,text.ZIndex+1)
                        row.Icon.AnchorPoint=Vector2.new(0,.5);row.Icon.Position=UDim2.new(0,13,.5,0)
                        local cost=node("Frame","CandyPrice",text.Parent,{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-29,.5,0),
                            Size=UDim2.fromOffset(80,22),BackgroundTransparency=1,ZIndex=text.ZIndex+1})
                        local candy=view.Candy(cost,19,text.ZIndex+1);candy.Position=UDim2.fromOffset(0,1)
                        row.Cost=label("CandyAmount",cost,{Size=UDim2.new(1,-21,1,0),Position=UDim2.fromOffset(21,0),
                            TextColor3=blue,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=text.ZIndex+1})
                    end
                    row.Cost.Text=quantity(tonumber(offer.candy)or 0)
                end
            end
        end
    end
    local diceRows=setmetatable({},{__mode="k"});local diceSpecs={};local diceData
    local function dicePrice(value)
        if type(value)~="number"then return view.Language=="TH"and"ฟรี"or"Free"end
        if value<1e6 then return "$"..quantity(value)end
        for _,suffix in ipairs({{1e18,"Qi"},{1e15,"Qa"},{1e12,"T"},{1e9,"B"},{1e6,"M"}})do
            if value>=suffix[1]and value<suffix[1]*1000 then return "$"..string.format("%.3g",value/suffix[1])..suffix[2]end
        end
        return "$"..string.format("%.3g",value)
    end
    function view.CreateDice(host,selected)
        local widget,popup=picker(host,"Dice selection",selected,"Best affordable")
        view.DiceWidget=widget;view.DicePopup=popup;return widget
    end
    function view.UpdateDiceState(data)
        if not data then return end;diceData=data
        for _,row in pairs(diceRows)do
            local equipped=data.Dice==row.Name
            local owned=equipped or(data.OwnedDice or{})[row.Name]==true
            row.Price.Text=dicePrice(row.Spec.price)
            row.State.Text=equipped and(view.Language=="TH"and"กำลังใช้อยู่"or"Equipped")
                or owned and(view.Language=="TH"and"ซื้อแล้ว"or"Purchased")
                or(view.Language=="TH"and"ยังไม่ได้ซื้อ"or"Not purchased")
            row.State.TextColor3=equipped and blue or owned and white or muted
        end
    end
    function view.RefreshDice(catalog,data)
        diceSpecs=catalog and catalog.GetAll()or{}
        local names={};for name in pairs(diceSpecs)do names[#names+1]=name end
        table.sort(names,function(a,b)
            local x,y=tonumber(diceSpecs[a].luck)or 0,tonumber(diceSpecs[b].luck)or 0
            return x==y and a<b or x<y
        end)
        table.insert(names,1,"Best affordable");view.DiceWidget:Refresh(names,true,true)
        if view.DicePopup then for _,text in ipairs(view.DicePopup:GetDescendants())do
            if text:IsA("TextLabel")and text.Parent and text.Parent:IsA("TextButton")then
                local name=plainText(text.Text);local spec=diceSpecs[name]
                if spec then
                    local row=diceRows[text]
                    if not row then
                        row={Name=name,Spec=spec};diceRows[text]=row
                        text.Position=UDim2.fromOffset(42,0);text.Size=UDim2.new(1,-198,1,0)
                        local icon=node("ImageLabel","DiceIcon",text.Parent,{AnchorPoint=Vector2.new(0,.5),Position=UDim2.new(0,13,.5,0),
                            Size=UDim2.fromOffset(22,22),Image=spec.image or"",ImageColor3=white,BackgroundTransparency=1,
                            ScaleType=Enum.ScaleType.Fit,ZIndex=text.ZIndex+1})
                        icon:SetAttribute("CustomIcon",true)
                        local state=node("Frame","DicePrice",text.Parent,{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-29,.5,0),
                            Size=UDim2.fromOffset(120,28),BackgroundTransparency=1,ZIndex=text.ZIndex+1})
                        row.Price=label("MoneyPrice",state,{Size=UDim2.new(1,0,0,14),TextSize=11,TextColor3=blue,
                            TextXAlignment=Enum.TextXAlignment.Right,ZIndex=text.ZIndex+1})
                        row.State=label("Ownership",state,{Position=UDim2.fromOffset(0,14),Size=UDim2.new(1,0,0,14),TextSize=10,
                            TextXAlignment=Enum.TextXAlignment.Right,ZIndex=text.ZIndex+1})
                    end
                    row.Spec=spec
                end
            end
        end end
        view.UpdateDiceState(data)
    end
    view.Root=node("Frame","DevilTowerRewardStack",window.Gui,{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-12,0,12),
        Size=UDim2.fromOffset(260,240),BackgroundTransparency=1,ZIndex=80})
    local function remove(index)
        local card=table.remove(view.Cards,index)
        if card then if card.Link then card.Link:Disconnect()end;card.Frame:Destroy()end
    end
    local function viewport()
        local camera=workspace.CurrentCamera
        return camera and camera.ViewportSize or Vector2.new(1280,720)
    end
    local function updateText(card)
        card.Stage.Text=card.Event.Tower.."  ·  "..(view.Language=="TH"and"ชั้น "or"Floor ")..tostring(card.Event.Floor)
        if card.Empty then card.Empty.Text=view.Language=="TH"and"ไม่มีไอเท็มดรอปในชั้นนี้"or"No drops this floor"end
    end
    function view.SetLanguage(language,data)
        view.Language=language=="TH"and"TH"or"EN"
        for _,card in ipairs(view.Cards)do updateText(card)end
        view.UpdateDiceState(data or diceData)
    end
    function view.Tick(now)
        if app.Stopped then return end
        for i=#view.Cards,1,-1 do if view.Cards[i].Expires<=now then remove(i)end end
        local screen=viewport();local maxCards=(screen.X<500 or screen.Y<500)and 1 or 2
        while #view.Cards>maxCards do remove(#view.Cards)end
        local width=math.max(180,math.min(260,screen.X-24));local height=math.max(100,screen.Y-24)
        view.Root.Size=UDim2.fromOffset(width,height)
        local bodyMax=math.max(20,math.min(60,(height-6*(maxCards-1))/maxCards-56))
        local y=0
        for _,card in ipairs(view.Cards)do
            local body=math.min(bodyMax,math.max(1,#card.Event.Items)*20)
            card.Frame.Position=UDim2.fromOffset(0,y);card.Frame.Size=UDim2.new(1,0,0,56+body)
            card.List.Size=UDim2.new(1,-16,0,body)
            card.Timer.Size=UDim2.new(math.clamp((card.Expires-now)/7,0,1),0,0,2)
            y+=62+body
        end
    end
    function view.Notify(event)
        if app.Stopped then return end
        local frame=node("Frame","DevilTowerRewardCard",view.Root,{BackgroundColor3=black,BackgroundTransparency=.1,BorderSizePixel=0,ZIndex=81})
        corner(frame,9);node("UIStroke","Border",frame,{Color=blue,Transparency=.55,Thickness=1})
        if logo then node("ImageLabel","DevilHubLogo",frame,{Position=UDim2.fromOffset(8,6),Size=UDim2.fromOffset(18,18),
            Image=logo,ImageColor3=white,BackgroundTransparency=1,ScaleType=Enum.ScaleType.Fit,ZIndex=83})
        else label("DevilHubLogo",frame,{Text="D",TextSize=17,TextColor3=white,Position=UDim2.fromOffset(8,5),Size=UDim2.fromOffset(18,20)})end
        label("Brand",frame,{Text="DEVIL HUB",Font=Enum.Font.GothamBold,TextSize=10,TextColor3=blue,Position=UDim2.fromOffset(34,6),Size=UDim2.new(1,-66,0,18)})
        local stage=label("Stage",frame,{Position=UDim2.fromOffset(8,27),Size=UDim2.new(1,-16,0,18),TextSize=11,Font=Enum.Font.GothamMedium})
        local list=node("ScrollingFrame","Rewards",frame,{Position=UDim2.fromOffset(8,49),BackgroundTransparency=1,BorderSizePixel=0,
            ScrollBarThickness=2,ScrollBarImageColor3=blue,CanvasSize=UDim2.fromOffset(0,math.max(1,#event.Items)*20),ZIndex=82})
        local card={Frame=frame,Stage=stage,List=list,Event=event,Expires=os.clock()+7}
        if #event.Items==0 then card.Empty=label("EmptyRewards",list,{Text="",TextSize=11,TextColor3=muted,Size=UDim2.new(1,-4,0,18)})end
        for i,item in ipairs(event.Items)do
            local row=node("Frame","RewardItem",list,{Position=UDim2.fromOffset(0,(i-1)*20),Size=UDim2.new(1,-4,0,18),BackgroundTransparency=1,ZIndex=83})
            view.Item(row,item.Name,18,84)
            label("ItemName",row,{Text=item.Name,TextSize=11,Position=UDim2.fromOffset(24,0),Size=UDim2.new(1,-84,1,0)})
            label("ItemAmount",row,{Text="×"..quantity(item.Amount),TextSize=11,TextColor3=blue,Position=UDim2.new(1,-58,0,0),Size=UDim2.fromOffset(58,18),TextXAlignment=Enum.TextXAlignment.Right})
        end
        card.Timer=node("Frame","Lifetime",frame,{Position=UDim2.new(0,0,1,-2),BackgroundColor3=blue,BorderSizePixel=0,ZIndex=83})
        local close=node("TextButton","Dismiss",frame,{Text="×",Font=Enum.Font.Gotham,TextSize=16,TextColor3=white,
            AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-5,0,4),Size=UDim2.fromOffset(20,20),BackgroundTransparency=1,ZIndex=85})
        card.Link=close.MouseButton1Click:Connect(function()
            local index=table.find(view.Cards,card);if index then remove(index);view.Tick(os.clock())end
        end)
        table.insert(view.Cards,1,card);updateText(card);view.Tick(os.clock())
    end
    function view.Destroy()
        for i=#view.Cards,1,-1 do remove(i)end
        view.Root:Destroy();ctx.OnTowerReward=nil
    end
    ctx.OnTowerReward=view.Notify
    return view
end
