-- Observes local replicated snapshots; never posts until explicitly enabled.
return function(ctx,P,cfg,report,net)
    local W={Queue={},Status="Off",Sent=0,Dropped=0,Money=0}
    report.Webhook={}
    local function sync()
        report.Webhook={Status=W.Status,Sent=W.Sent,Dropped=W.Dropped,Queued=#W.Queue,Money=W.Money,ImageStatus=W.ImageStatus}
    end
    local previous,identity,busy,nextSend,lastMoney=nil,nil,false,0,0
    local clock=net.Clock or os.clock
    local function code(v)return "`"..tostring(v):gsub("[`\r\n]"," "):sub(1,180).."`"end
    local function url(v)
        if type(v)~="string"then return end
        local id,token=v:match("^https://discord%.com/api/webhooks/(%d+)/([%w_%-]+)$")
        if not id then id,token=v:match("^https://discord%.com/api/v%d+/webhooks/(%d+)/([%w_%-]+)$")end
        if id then return "https://discord.com/api/webhooks/"..id.."/"..token.."?wait=true"end
    end
    W.ValidURL=url
    local function selected(key)return cfg.WebhookFields[key]==true end
    local function enqueue(embed,unit)
        if #embed.fields==0 and not unit then return end
        if #W.Queue>=100 then W.Dropped+=1;return end
        W.Queue[#W.Queue+1]={Embed=embed,Unit=unit,Attempts=0}
    end
    local function embed(title)return {title=title,color=0xA4DDFF,fields={},footer={text="DEVIL HUB • Anime Dice"}}end
    local function field(e,name,value)e.fields[#e.fields+1]={name=name,value=code(value),inline=true}end
    local function image(unit)
        local worked,overrides=pcall(net.Decode,cfg.WebhookImages)
        local value=worked and type(overrides)=="table"and overrides[unit.name]or nil
        if not value then
            value=unit.config.image
            if type(value)=="function"then local ok,result=pcall(value,unit.attributes);value=ok and result or nil end
        end
        if type(value)=="string"and value:match("^https://")then return value end
        local asset=type(value)=="number"and tostring(value)or type(value)=="string"and(value:match("^rbxassetid://(%d+)$")or value:match("[?&]id=(%d+)"))
        if asset and net.AssetImage then return net.AssetImage(asset)end
    end
    local function reset(data)
        previous={};for _,u in ipairs(P.Units(data,ctx.Catalog.Registry))do previous[u.id]=u.amount end
        W.Money=0;lastMoney=clock();W.LastBalance=P.Number(data.Money)
    end
    function W.Tick(data)
        sync()
        local target=cfg.WebhookEnabled and url(cfg.WebhookURL)or nil
        if not target then
            W.Status=cfg.WebhookEnabled and"Enter a valid Discord webhook URL"or"Off"
            previous=nil;identity=nil;table.clear(W.Queue);W.Money=0;return
        end
        if not data then W.Status="Waiting for game data";return end
        if identity~=target then identity=target;table.clear(W.Queue);reset(data)end
        if not previous then reset(data)end
        local balance=P.Number(data.Money)
        W.Money+=math.max(0,balance-(W.LastBalance or balance));W.LastBalance=balance
        local current={}
        for _,u in ipairs(P.Units(data,ctx.Catalog.Registry))do
            current[u.id]=u.amount
            local gain=u.amount-(previous[u.id]or 0)
            if gain>0 and(next(cfg.WebhookRarities)==nil or cfg.WebhookRarities[u.rarity or"Unknown"]==true)then
                local e=embed("🎲 Character obtained")
                if selected("Character")then field(e,"👤 Character",u.name);field(e,"📦 Amount",gain)end
                if selected("Rarity")then field(e,"✨ Rarity",u.rarity or"Unknown")end
                if selected("Level")then field(e,"⬆️ Level",u.attributes.level or 1)end
                if selected("Chance")then field(e,"🍀 Chance","1 / "..tostring(u.chance))end
                if selected("Money")then field(e,"💰 Money gained",string.format("%.8g",W.Money))end
                if selected("Balance")then field(e,"🏦 Balance",string.format("%.8g",balance))end
                enqueue(e,selected("Image")and u or nil)
            end
        end
        previous=current
        local interval=math.clamp(P.Number(cfg.WebhookInterval,60),15,3600)
        if selected("Money")and W.Money>0 and clock()-lastMoney>=interval then
            local e=embed("💰 Earnings update");field(e,"💰 Money gained",string.format("%.8g",W.Money))
            if selected("Balance")then field(e,"🏦 Balance",string.format("%.8g",balance))end
            enqueue(e);W.Money=0;lastMoney=clock()
        end
        if busy or clock()<nextSend or #W.Queue==0 then return end
        busy=true;nextSend=clock()+2
        local item=W.Queue[1];local endpoint=target
        net.Spawn(function()
            if cfg.WebhookEnabled~=true or url(cfg.WebhookURL)~=endpoint or identity~=endpoint or report.Stopped then busy=false;return end
            if item.Unit then
                local worked,value=pcall(image,item.Unit)
                if worked and value then item.Embed.image={url=value}else W.ImageStatus="No public image for "..item.Unit.name.."; add its URL below"end
                item.Unit=nil
            end
            if #item.Embed.fields==0 and not item.Embed.image then table.remove(W.Queue,1);busy=false;return end
            if cfg.WebhookEnabled~=true or url(cfg.WebhookURL)~=endpoint or identity~=endpoint or report.Stopped then busy=false;return end
            local ok,response=pcall(net.Post,endpoint,{username="DEVIL HUB",avatar_url="https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/9a9812469df7b5dad2848abb33c5206f7d57e685/assets/devil-logo-silver-transparent.png",allowed_mentions={parse={}},embeds={item.Embed}})
            busy=false
            if identity~=endpoint or W.Queue[1]~=item then return end
            local status=ok and type(response)=="table"and tonumber(response.StatusCode or response.Status)or nil
            if status and status>=200 and status<300 then
                table.remove(W.Queue,1);W.Sent+=1;W.Status="Sent: "..W.Sent
            elseif status==429 then
                local decoded,body=pcall(net.Decode,response.Body or"")
                local delay=decoded and type(body)=="table"and P.Number(body.retry_after,5)or 5
                nextSend=clock()+math.clamp(delay,1,3600);W.Status="Discord rate limit; waiting"
            else
                item.Attempts+=1;nextSend=clock()+math.min(60,5*item.Attempts)
                W.Status=status and("HTTP "..status)or"HTTP request unavailable or failed"
                -- Never expose executor error strings: they can contain the secret URL.
                if item.Attempts>=3 or status==401 or status==403 or status==404 then table.remove(W.Queue,1);W.Dropped+=1 end
            end
            sync()
        end)
    end
    function W.Destroy()identity=nil;previous=nil;table.clear(W.Queue);report.Stopped=true end
    return W
end
