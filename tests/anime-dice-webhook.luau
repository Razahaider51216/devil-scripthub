local P=(function()
-- TEST_PLANNER
end)()
local make=(function()
-- TEST_WEBHOOK
end)()
local checks=0
local function check(v,m)assert(v,m);checks+=1 end
local function fixture()
    local time=0;local packets,work={},{}
    local cfg={WebhookEnabled=false,WebhookURL="https://discord.com/api/webhooks/123/test-token",WebhookFields={Character=true,Rarity=true,Level=true,Chance=true,Money=true,Balance=true,Image=true},WebhookRarities={},WebhookImages="{}",WebhookInterval=15}
    local specs={A={kind="Unit",rarity="Rare",image="https://example.org/a.png"},B={kind="Unit",rarity="Common",image="rbxassetid://12"},Model={kind="Unit",rarity="Rare"}}
    local ctx={Catalog={Registry={getEntryConfig=function(n)return specs[n]end}}}
    local net={Clock=function()return time end,Spawn=function(fn)work[#work+1]=fn end,
        Decode=function(text)if text=="retry"then return {retry_after=8}elseif text=="custom"then return {Model="https://example.org/model.png"}else return {}end end,
        AssetImage=function(id)check(id=="12","asset ID mismatch");return "https://example.org/thumbnail.png"end}
    local status=204
    net.Post=function(url,body)packets[#packets+1]={URL=url,Body=body};if status=="error"then error("secret token")end;return {StatusCode=status,Body="retry"}end
    local report={};local w=make(ctx,P,cfg,report,net)
    local d={Money=100,Inventory={old={name="A",amount=1,attributes={level=5}}}}
    local function tick(dt)time+=dt or 1;w.Tick(d)end
    local function flush()local queued=work;work={};for _,fn in ipairs(queued)do fn()end end
    local function add(id,name,n)d.Inventory[id]={name=name,amount=n or 1,attributes={level=3}}end
    return w,cfg,d,packets,tick,flush,add,function(v)status=v end,report
end
do
    local w,c,d,p,t,flush,add=fixture()
    t();flush();check(#p==0,"posted with webhook disabled")
    check(not w.ValidURL("https://discord.com.evil.test/api/webhooks/1/token"),"accepted spoofed host")
    check(not w.ValidURL("http://discord.com/api/webhooks/1/token"),"accepted insecure URL")
    check(not w.ValidURL("https://discord.com/api/webhooks/1/token?other=1"),"accepted arbitrary query")
    check(w.ValidURL("https://discord.com/api/v10/webhooks/1/token"):find("?wait=true",1,true),"confirmation absent")
    c.WebhookEnabled=true;t();flush();check(#p==0,"announced pre-existing units")
    add("new","A",2);d.Money=125;t();flush();check(#p==1,"new unit not posted")
    local body=p[1].Body;local e=body.embeds[1]
    check(body.username=="DEVIL HUB"and #body.allowed_mentions.parse==0,"branding or mention control wrong")
    check(e.fields[1].value=="`A`"and e.fields[2].value=="`2`","character/count formatting wrong")
    check(e.fields[3].value=="`Rare`"and e.fields[4].value=="`3`","rarity/level wrong")
    check(e.image.url=="https://example.org/a.png","HTTPS character image absent")
    t(3);flush();check(#p==1,"repeated snapshot duplicated unit")
    d.Inventory.new.attributes.level=4;t(3);flush();check(#p==1,"level change announced as acquisition")
    d.Inventory.new.amount=3;t(3);flush();check(#p==2 and p[2].Body.embeds[1].fields[2].value=="`1`","stack increase amount incorrect")
    d.Money=90;t(10);flush();check(p[#p].Body.embeds[1].title:find("Earnings update",1,true),"earnings summary missing")
    check(p[#p].Body.embeds[1].fields[1].value=="`25`","spending counted as positive gain")
    check(w.Money==0,"earnings period did not reset")
end
do
    local w,c,d,p,t,flush,add=fixture();c.WebhookEnabled=true;t()
    c.WebhookRarities={Rare=true};add("common","B");t();flush();check(#p==0,"rarity exclusion failed")
    c.WebhookFields={Rarity=true};add("rare","A");t();flush()
    local e=p[1].Body.embeds[1];check(#e.fields==1 and not e.image,"field exclusion failed")
    c.WebhookFields={Image=true};c.WebhookRarities={};add("image","B");t(3);flush()
    check(p[2].Body.embeds[1].image.url=="https://example.org/thumbnail.png","Roblox thumbnail missing")
    add("model","Model");t(3);flush();check(#p==2 and w.ImageStatus~=nil,"model-only event fabricated image or invalid empty embed")
    c.WebhookImages="custom";add("custom","Model");t(3);flush();check(p[3].Body.embeds[1].image.url=="https://example.org/model.png","custom character art failed")
end
do
    local w,c,d,p,t,flush,add,setStatus,report=fixture();c.WebhookEnabled=true;t();add("new","A");t()
    c.WebhookEnabled=false;flush();check(#p==0,"queued send ran after disable")
    t();check(#w.Queue==0,"disabled queue not cleared")
    c.WebhookEnabled=true;t();flush();check(#p==0,"reenable replayed old units")
    add("retry","A");setStatus(429);t(3);flush();check(#w.Queue==1 and w.Sent==0,"429 counted as success")
    t(4);flush();check(#p==1,"rate-limit retry ignored delay")
    setStatus(204);t(5);flush();check(#p==2 and w.Sent==1 and #w.Queue==0,"rate-limit recovery failed")
    check(report.Webhook.Queue==nil and report.Webhook.Tick==nil,"report leaked functions or inventory queue")
    setStatus("error");add("fail","A");t(3);flush();check(not w.Status:find("secret",1,true),"HTTP error leaked token")
    t(6);flush();t(11);flush();check(w.Dropped==1 and #w.Queue==0,"failed event retried without bound")
    setStatus(404);add("gone","A");t(20);flush();check(w.Dropped==2,"invalid endpoint retained event")
    add("stop","A");t(20);w.Destroy();flush();check(#w.Queue==0,"destroy retained pending sends")
end
do
    local w,c,d,p,t,flush,add=fixture();c.WebhookEnabled=true;t()
    for i=1,120 do add(tostring(i),"A")end
    t();check(#w.Queue==100 and w.Dropped==20,"queue not bounded")
    c.WebhookURL="https://discord.com/api/webhooks/456/new-token";flush();check(#p==0,"old queued event sent to changed endpoint")
    t();check(#w.Queue==0,"endpoint change replayed queue")
end
print("PASS Anime Dice webhook: opt-in, baseline, money, filters, art, retries, cancellation, bounded queue and secret redaction: "..checks.." checks")
