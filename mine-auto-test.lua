-- BEGIN SHARED DEVIL BLUE GUI
do
    local shared=type(getgenv)=="function"and getgenv()or _G
    local current=shared.DevilHubBlueGui
    if not(current and current.Version=="devil-blue-20261019-3"and not current.Stopped)then
        local ok,problem=pcall(function()
            local source=game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/abb8b8ddd1041fe1900336cc2d2b09a8fcb20c16/devil-blue-gui.lua")
            assert(type(source)=="string"and #source==71726,"DEVIL blue GUI download size mismatch")
            local sum=0
            for i=1,#source do sum=(sum*33+source:byte(i))%4294967296;if i%32768==0 and task and task.wait then task.wait()end end
            assert(sum==2183648080,"DEVIL blue GUI checksum mismatch")
            local run,err=loadstring(source,"DEVIL HUB / Blue GUI")
            assert(run,err)
            return run()
        end)
        if not ok then warn("DEVIL HUB: blue GUI could not start: "..tostring(problem))end
    end
end
-- END SHARED DEVIL BLUE GUI
assert(game.PlaceId==79389059854988 or game.GameId==10740316645,"DEVIL HUB: เปิดแมพจาก Dump23 ก่อน")
local env=type(getgenv)=="function"and getgenv()or _G
if env.DevilMineTest then env.DevilMineTest.Destroy()end
local makeCore=(function()
-- Scheduler shared by every economy action. No interception or global hooks.
return function(config, deps)
    local api={Jobs={},Errors={},Stopped=false}
    local order,index={},0
    local nextSend=0
    function api.Add(name,plan,interval)
        order[#order+1]=name
        api.Jobs[name]={Plan=plan,Interval=interval or 2,Next=0,Requests=0,Progress=0,Misses=0,Status="ปิดอยู่"}
    end
    function api.Set(name,on)
        config[name]=on==true
        local job=api.Jobs[name]
        if job then
            job.Next=0;job.Status=on and "รอรอบทำงาน" or "ปิดอยู่"
            if not on then job.Pending=nil end
        end
    end
    function api.Error(name,message)
        api.Errors[#api.Errors+1]={job=name,message=tostring(message),t=deps.Now()}
        if #api.Errors>30 then table.remove(api.Errors,1)end
    end
    function api.Tick()
        if api.Stopped then return end
        local now=deps.Now()
        for _=1,#order do
            index=index%#order+1
            local name=order[index];local job=api.Jobs[name]
            if not config[name] then job.Status="ปิดอยู่";continue end
            if now<job.Next then continue end
            if job.Pending then
                local previous=job.Pending
                local changed=false
                if previous.Observe then
                    local seen,value=pcall(previous.Observe)
                    changed=seen and value~=previous.Before
                end
                if changed then
                    job.Progress+=1;job.Misses=0;job.Pending=nil
                elseif now<previous.Deadline then
                    job.Status="รอข้อมูลเกมอัปเดต";continue
                else
                    job.Pending=nil;job.Misses+=1
                    job.Next=now+math.min(30,2^math.min(job.Misses,5))
                    job.Status="ยังไม่เห็นผลอัปเดต พักก่อนลองใหม่"
                    continue
                end
            end
            local ok,action,status=pcall(job.Plan)
            if not ok then
                api.Error(name,action);job.Status="เกิดข้อผิดพลาด ดูรายงาน";job.Next=now+10;continue
            end
            if not action then job.Status=status or "รอเงื่อนไข";job.Next=now+.75;continue end
            if now<nextSend then continue end
            local before
            if action.Observe then
                local seen,value=pcall(action.Observe)
                if not seen then api.Error(name,value);job.Next=now+5;continue end
                before=value
            end
            local sent,err=pcall(deps.Send,action.Event,table.unpack(action.Args or {},1,(action.Args or {}).n or #(action.Args or {})))
            nextSend=now+.15 -- <= 7 automated requests/sec, shared across jobs
            job.Next=now+job.Interval
            if sent then
                job.Requests+=1;job.LastEvent=action.Event;job.Status="ส่งคำขอแล้ว";job.UpdatedAt=now
                if action.Observe then
                    job.Pending={Before=before,Observe=action.Observe,Deadline=now+(action.Timeout or 8)}
                end
                if action.Sent then action.Sent()end
            else
                api.Error(name,err);job.Status="ส่งคำขอไม่สำเร็จ";job.Next=now+5
            end
            return
        end
    end
    function api.StopAll()
        for _,name in ipairs(order)do api.Set(name,false)end
    end
    function api.Report()
        local jobs={}
        for _,name in ipairs(order)do
            local j=api.Jobs[name]
            jobs[name]={status=j.Status,requests=j.Requests,progressUpdates=j.Progress,misses=j.Misses,lastEvent=j.LastEvent,updatedAt=j.UpdatedAt}
        end
        return {release="mine-auto-test-4",jobs=jobs,errors=api.Errors,liveVerified=false}
    end
    function api.Destroy()api.Stopped=true;api.StopAll()end
    return api
end

end)()
local makeAdapter=(function()
return function(config,deps,core)
    local api={}
    local function mod(name)return deps.Module(name)end
    local C=mod("MineConfig")
    local I=mod("MineInventory")
    local Items=mod("Items")
    local function data()
        local d=mod("GameState").GetData2()
        return d,d and d.MineGame
    end
    local function mine()local _,m=data();return m end
    local function money()local d=data();return math.max(0,(d and tonumber(d.Money)or 0)-config.Reserve)end
    local function sig(value)
        if type(value)~="table"then return tostring(value)end
        local out={}
        for k,v in pairs(value)do out[#out+1]=tostring(k).."="..sig(v)end
        table.sort(out);return table.concat(out,";")
    end
    local function watch(field)return function()local m=mine();return sig(m and m[field])end end
    local function action(event,args,observe)return {Event=event,Args=args or {},Observe=observe}end
    local function entries()
        local m=mine()
        return m and I.Collect(m,"All")or {}
    end
    local function selected(set,value)return type(set)=="table"and set[value]==true end
    local function empty(set)return not set or next(set)==nil end
    local function item(holder)return holder and Items.GetItemData(holder.CharName)end
    local function slots(m,all)
        local list={}
        for key,h in pairs(m.Holders or {})do
            if type(h)=="table"and h.CharName and h.CharName~="" and (all or config.Slot=="All"or config.Slot==key)then
                list[#list+1]={Key=key,Holder=h,Item=item(h)}
            end
        end
        table.sort(list,function(a,b)return a.Key<b.Key end);return list
    end
    function api.Entries()return entries()end
    function api.Data()return data()end
    function api.Options()
        local m=mine()
        local out={Names={},Slots={"All"},Zones={},Recipes={},Enchants={},Mutations={},Picks={},Skills={}}
        local seen={}
        for _,e in ipairs(entries())do
            if not seen[e.Name]then seen[e.Name]=true;out.Names[#out.Names+1]=e.Name end
        end
        for k in pairs(m and m.Holders or {})do out.Slots[#out.Slots+1]=k end
        for k in pairs(C.Zones or {})do out.Zones[#out.Zones+1]=k end
        for _,p in ipairs(C.Pickaxes or {})do out.Picks[#out.Picks+1]=p.Name end
        for _,v in ipairs(C.GetVariantLadder())do
            if type(v)=="table"and v.VariantName then out.Mutations[#out.Mutations+1]=v.VariantName end
        end
        for _,v in ipairs(mod("MineEnchantCatalog").Enchants or {})do out.Enchants[#out.Enchants+1]=v.Name end
        local craft=mod("MineCraftingCatalog")
        for _,v in ipairs(type(craft.Recipes)=="function"and craft.Recipes()or {})do out.Recipes[#out.Recipes+1]=v.Key end
        for _,k in ipairs(C.ZoneKeys or {})do
            for _,n in ipairs(C.GetSkillNodes(k))do if n.Family then out.Skills[n.Family]=true end end
        end
        for _,k in ipairs({"Names","Slots","Zones","Recipes","Enchants","Mutations","Picks"})do table.sort(out[k])end
        table.sort(out.Zones,function(a,b)return (tonumber(a:match("%d+"))or 0)<(tonumber(b:match("%d+"))or 0)end)
        return out
    end
    core.Add("Equip",function()
        if not mine()then return nil,"รอข้อมูลผู้เล่น"end
        return action("MineEquipBest",{},watch("Holders"))
    end,5)
    core.Add("Chest",function()
        local m=mine()
        if not m or next(m.Chest or {})==nil then return nil,"รอของในหีบ"end
        return action("MineTakeChest",{},watch("Chest"))
    end,1)
    local saleTrip
    function api.SellBusy()return saleTrip~=nil end
    function api.CancelSale()saleTrip=nil;if deps.CancelSeller then deps.CancelSeller()end end
    core.Add("Sell",function()
        local m=mine();if not m then return nil,"รอข้อมูลผู้เล่น"end
        if saleTrip=="Return" then
            api.SellInfo=api.SellInfo or {};api.SellInfo.stage="ReturningHome"
            local out=action("MineTeleport",{"Plot"})
            out.Sent=function()
                saleTrip=nil
                if deps.CancelSeller then deps.CancelSeller()end
            end
            return out
        end
        if empty(config.SellNames)and empty(config.SellRarities)and empty(config.SellKinds)then return nil,"เลือกรายการที่จะขายก่อน"end
        local protected={}
        local protectedNames={}
        for _,key in pairs(m.Hotbar or {})do protected[key]=true end
        for _,h in pairs(m.Holders or {})do
            if type(h)=="table"and h.CharName then protectedNames[h.CharName]=true end
        end
        local bestKey,bestRank
        for _,e in ipairs(entries())do
            if e.Kind=="Character"and(not bestRank or(e.Rank or 0)>bestRank)then bestRank=e.Rank or 0;bestKey=e.Key end
        end
        local keys={}
        local function matches(e)
            local filter=(empty(config.SellNames)or selected(config.SellNames,e.Name))
                and(empty(config.SellRarities)or selected(config.SellRarities,e.Rarity))
                and(empty(config.SellKinds)or selected(config.SellKinds,e.Kind))
            local sellable=e.Kind=="Ore"or e.Kind=="Pickaxe"or(e.Kind=="Character"and C.CanSellCharacter(Items.GetItemData(e.Name)))
            if filter and sellable and(e.SellCount or e.Count or 0)>0 and(e.Worth or 0)>0
                and not protected[e.Key]and not protectedNames[e.Name]and not e.Locked and not e.Favorite
                and not(config.KeepBest and e.Key==bestKey)then
                return true
            end
            return false
        end
        for _,e in ipairs(entries())do
            if matches(e)then keys[#keys+1]=e.Key;if #keys>=50 then break end end
        end
        api.SellInfo=api.SellInfo or {}
        api.SellInfo.candidates=#keys
        if #keys==0 then
            -- Sell can collect matching chest items even when the separate
            -- Take All toggle is disabled. Never take unselected chest items.
            for _,e in ipairs(I.ChestEntries(m))do
                if not matches(e)then continue end
                if deps.ChestStep then
                    local ready,step,status=deps.ChestStep()
                    if not ready then
                        if step then saleTrip="Collecting"end
                        api.SellInfo.stage="ToChest"
                        return step,status
                    end
                end
                api.SellInfo.stage="TakingFilteredChest"
                return action("MineTakeChest",{e.Key},watch("Chest"))
            end
            if saleTrip then saleTrip="Return";return nil,"ไม่มีรายการเหลือ เตรียมกลับบ้าน"end
            return nil,"ไม่มีของตรงตัวกรอง หรือเก็บไว้"
        end
        local function counts()
            -- Resolve() does not support Pickaxes in the supplied client.
            local values={}
            for _,e in ipairs(entries())do values[e.Key]=e.SellCount or e.Count or 0 end
            local result={}
            for _,key in ipairs(keys)do result[key]=values[key]or 0 end
            return result
        end
        local before=counts()
        if deps.SellerStep then
            local ready,step,status,details=deps.SellerStep()
            if details then for k,v in pairs(details)do api.SellInfo[k]=v end end
            if not ready then
                if step then saleTrip="Selling"end
                return step,status
            end
            saleTrip="Selling"
        end
        api.SellInfo.stage="Selling"
        api.SellInfo.keys=keys
        return action("MineSellItems",{keys},function()
            local after=counts()
            local decreased=false
            for _,key in ipairs(keys)do if after[key]<before[key]then decreased=true;break end end
            if decreased and saleTrip then saleTrip="Return";api.SellInfo.stage="SaleObserved"end
            return decreased and "decreased"or "waiting"
        end)
    end,1.5)
    local lastAutoSell
    core.Add("ChestSell",function()
        local d,m=data();if not m then return nil,"รอข้อมูลผู้เล่น"end
        if type(C.PlayerHasPass)=="function"and not C.PlayerHasPass(d,C.AutoSellPassLabel or "Auto Sell")then
            return nil,"เกมต้องมี Gamepass Auto Sell ใช้ขายแบบวาร์ปแทนได้"
        end
        local desired=sig(config.ChestSellNames)
        if lastAutoSell==desired then return nil,"ตั้งขายจากหีบแล้ว"end
        for name,on in pairs(config.ChestSellNames)do
            if on and(m.AutoSell or {})[name]~=true then
                return {Event="MineAutoSellSet",Args={name,true},Observe=watch("AutoSell")}
            end
        end
        lastAutoSell=desired;return nil,"รายการขายจากหีบตรงกับที่เลือก"
    end,1)
    core.Add("Pickaxe",function()
        local d,m=data();if not m then return nil,"รอข้อมูลผู้เล่น"end
        local stock=mod("MineStock")
        for i,p in ipairs(C.Pickaxes or {})do
            if selected(config.Picks,p.Name)and not p.RobuxOnly and not p.ProductId
                and(m.UnlockedZones or {})[p.ZoneReq]and(tonumber(p.Cost)or math.huge)<=money()then
                local remaining=stock.GetRemaining(d,p.Name)
                if (remaining==nil or remaining>0)and(tonumber((m.Pickaxes or {})[p.Name])or 0)<=0 then
                    return action("MineBuyPickaxe",{i},watch("Pickaxes"))
                end
            end
        end
        return nil,"รอ Pickaxe ที่เลือก เงิน หรือสต็อก"
    end,1.5)
    for _,kind in ipairs({"Damage","Speed","MineSpeed"})do
        core.Add("Upgrade"..kind,function()
            local m=mine();if not m then return nil,"รอข้อมูลผู้เล่น"end
            for _,s in ipairs(slots(m))do
                local h=s.Holder;local def=s.Item
                if not def then continue end
                local level,cost,cap
                if kind=="Damage"then
                    level=C.GetHolderLevel(h);cost=C.GetCharacterUpgradeCost(level,def);cap=C.CharMaxLevel
                elseif kind=="Speed"then
                    level=C.GetHolderSpeedLevel(h);cost=C.GetCharacterSpeedUpgradeCost(level,def);cap=C.CharSpeedMaxLevel
                else
                    level=C.GetHolderMineSpeedLevel(h);cost=C.GetCharacterMineSpeedUpgradeCost(level,def);cap=C.CharMineSpeedMaxLevel
                end
                if level<(cap or config.MaxLevel)and level<config.MaxLevel and cost<=money()then
                    return action("MineUpgradeCharacter",kind=="Damage"and{s.Key}or{s.Key,kind},watch("Holders"))
                end
            end
            return nil,"รอเงิน หรือถึงระดับที่ตั้งไว้"
        end,1)
    end
    core.Add("Core",function()
        local m=mine();if not m then return nil,"รอข้อมูลผู้เล่น"end
        for _,def in ipairs(C.CoreUpgrades or {})do
            if selected(config.CoreKinds,def.Id)then
                local level=C.GetCoreLevel(m,def.Id)
                if level<(def.Max or math.huge)and def.Cost(level)<=money()then
                    return action(def.Event,{},watch(def.Field))
                end
            end
        end
        return nil,"รอเงิน หรืออัปเกรดหลักครบแล้ว"
    end,1)
    core.Add("Skills",function()
        local m=mine();if not m then return nil,"รอข้อมูลผู้เล่น"end
        for _,zone in ipairs(C.ZoneKeys or {})do
            if not(m.UnlockedZones or {})[zone]then continue end
            local skills=(m.Skills or {})[zone]or {}
            for _,node in ipairs(C.GetSkillNodes(zone))do
                if selected(config.SkillKinds,node.Family)and not C.IsSkillNodeMaxed(skills,node)and C.IsSkillNodeOpen(skills,node)then
                    local cost=C.GetSkillCost(zone,skills[node.Family]or 0,node.Family)
                    if cost<=money()then return action("MineBuySkill",{zone,node.Family,node.Id},watch("Skills"))end
                end
            end
        end
        return nil,"รอสกิลที่เลือก เงิน หรือเงื่อนไขก่อนหน้า"
    end,1)
    core.Add("Mutation",function()
        local m=mine();if not m then return nil,"รอข้อมูลผู้เล่น"end
        if config.Slot=="All"then return nil,"เลือกช่องตัวละครหนึ่งช่องก่อนสุ่ม"end
        if empty(config.Mutations)then return nil,"เลือก Mutation ที่ต้องการก่อน"end
        local h=(m.Holders or {})[config.Slot];local def=item(h)
        if not def then return nil,"ช่องนี้ยังไม่มีตัวละคร"end
        if selected(config.Mutations,C.GetHolderVariant(h))then return nil,"ได้ Mutation ที่เลือกแล้ว"end
        if C.GetMutationRollCost(def,m)>money()then return nil,"เงินไม่พอหลังหักเงินสำรอง"end
        return action("MineRollMutation",{config.Slot},watch("Holders"))
    end,3)
    core.Add("Enchant",function()
        local m=mine();if not m then return nil,"รอข้อมูลผู้เล่น"end
        local catalog=mod("MineEnchantCatalog")
        if not catalog.Unlocked(m)then return nil,"ยังไม่ปลดล็อก Enchant"end
        if empty(config.Enchants)then return nil,"เลือก Enchant ที่ต้องการก่อน"end
        for _,e in ipairs(entries())do
            if e.Kind=="Enchant"and selected(config.Enchants,e.Name)then return nil,"มี Enchant ที่เลือกในกระเป๋าแล้ว"end
        end
        if C.GetEnchantDiceCount(m)<=config.ReserveDice then return nil,"รอลูกเต๋า Enchant"end
        return action("MineRollEnchant",{1},watch("EnchantItems"))
    end,4.5)
    core.Add("Craft",function()
        local d,m=data();if not m then return nil,"รอข้อมูลผู้เล่น"end
        local cat=mod("MineCraftingCatalog")
        if cat.Enabled==false then return nil,"เกมยังปิดระบบ Crafting"end
        local recipe=cat.ByKey(config.Recipe)
        if not recipe then return nil,"เลือกสูตรก่อน"end
        if not cat.Check(m,money(),recipe)then return nil,"รอวัตถุดิบและเงิน"end
        return action("MineCraft",{recipe.Key},watch("Characters"))
    end,3)
    core.Add("Summon",function()
        local m=mine();if not m then return nil,"รอข้อมูลผู้เล่น"end
        local cat=mod("MineSummonCatalog")
        if not cat.Unlocked(m)then return nil,"ยังไม่ปลดล็อก Summoning Shrine"end
        if C.GetSummonScrollCount(m)<=config.ReserveScroll then return nil,"รอ Summon Scroll"end
        if not empty(config.SummonStop)then
            for _,e in ipairs(entries())do
                if e.Kind=="Character"and selected(config.SummonStop,e.Rarity)then return nil,"มีตัวละครระดับเป้าหมายแล้ว"end
            end
        end
        return action("MineSummon",{},watch("Characters"))
    end,5)
    core.Add("Daily",function()
        local m=mine();if not m then return nil,"รอข้อมูลผู้เล่น"end
        local cat=mod("MineDailySpinConfig")
        if cat.Enabled==false or not cat.Unlocked(m)then return nil,"ยังไม่ปลดล็อกรางวัลรายวัน"end
        if not cat.Ready(m.DailySpin)then return nil,"รอรางวัลรายวันรอบถัดไป"end
        return action(cat.Events.Spin,{},watch("DailySpin"))
    end,12)
    core.Add("Quest",function()
        local m=mine();if not m then return nil,"รอข้อมูลผู้เล่น"end
        local cat=mod("MineDailyQuestsCatalog")
        if cat.Enabled==false then return nil,"เกมยังปิด Daily Quest"end
        return nil,"รอข้อมูลเควสต์ที่สำเร็จ"
    end,15)
    local target
    core.Add("Farm",function()
        local m=mine();if not m then return nil,"รอข้อมูลผู้เล่น"end
        if not target or not deps.NodeAlive(target)then target=deps.FindNode(config.NodeMode)end
        if not target then return nil,"รอหินในเหมืองของเรา"end
        local keys={}
        for _,s in ipairs(slots(m,true))do if s.Key:match("^M%d+$")and s.Item and s.Item.MineRole~="Hauler"then keys[#keys+1]=s.Key end end
        if #keys==0 then return nil,"ใส่คนงาน Miner ก่อน"end
        local id=tonumber(target.Name:match("^Node(%d+)$"))
        if not id then return nil,"ไม่พบรหัสหิน"end
        api.Target={id=id,name=target.Name}
        return action("MineFocusMany",{keys,id},function()return tostring(deps.NodeHealth(target))end)
    end,3)
    function api.Travel(zone)
        if saleTrip then return false,"รอขายของและกลับบ้านให้เสร็จก่อน"end
        local m=mine();if not m then return false,"ข้อมูลยังไม่พร้อม"end
        if zone=="Highest"then
            local best=0
            for k,on in pairs(m.UnlockedZones or {})do local n=tonumber(tostring(k):match("^Z(%d+)$"));if on and n and n>best then best=n;zone=k end end
        end
        if zone~="Plot"and zone~="Hub"then
            if not(m.UnlockedZones or {})[zone]then return false,"ยังไม่ปลดล็อกโซนนี้"end
            return deps.Manual("MineSelectZone",zone)
        end
        return deps.Manual("MineTeleport",zone)
    end
    return api
end

end)()
local resolveLogo=(function()
return function(deps)
    local env=deps.Env
    local apis=deps.APIs
    local version="silver-break-20261014"
    local file="DevilHub_Silver_20261014.png"
    local function valid(value)
        return type(value)=="string"and value~=""and not value:match("^https?://")
    end
    if env.DevilHubSilverLogoVersion==version and valid(env.DevilHubSilverLogo)then return env.DevilHubSilverLogo end
    local ok,result=pcall(function()
        local exists=false
        if type(apis.isfile)=="function"then
            local checked,value=pcall(apis.isfile,file);exists=checked and value==true
        end
        if exists and type(apis.readfile)=="function"then
            local checked,body=pcall(apis.readfile,file)
            exists=checked and type(body)=="string"and body:sub(1,8)=="\137PNG\r\n\26\n"
        end
        if not exists then
            assert(type(apis.writefile)=="function","Logo needs writefile")
            local body=deps.Fetch("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/a28a74d3b5c98f687c165dcefaadfe0a743d280c/assets/devil-logo.png")
            assert(type(body)=="string"and body:sub(1,8)=="\137PNG\r\n\26\n","Invalid logo PNG")
            apis.writefile(file,body)
        end
        for _,name in ipairs({"getcustomasset","getsynasset","get_custom_asset"})do
            if type(apis[name])=="function"then
                local checked,value=pcall(apis[name],file)
                if checked and valid(value)then return value end
            end
        end
        error("Executor has no usable custom asset API")
    end)
    if not ok then env.DevilHubLogoError=tostring(result);return ""end
    env.DevilHubSilverLogo=result;env.DevilHubSilverLogoVersion=version;env.DevilHubLogoError=nil
    return result
end

end)()
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Http=game:GetService("HttpService")
local Collection=game:GetService("CollectionService")
local player=Players.LocalPlayer
local alive=true
local config={
    Farm=false,Equip=false,Chest=false,Sell=false,ChestSell=false,Pickaxe=false,
    UpgradeDamage=false,UpgradeSpeed=false,UpgradeMineSpeed=false,Core=false,Skills=false,
    Mutation=false,Enchant=false,Craft=false,Summon=false,Daily=false,Quest=false,
    Slot="All",Reserve=0,ReserveDice=0,ReserveScroll=0,MaxLevel=50,
    SellNames={},SellRarities={},SellKinds={},ChestSellNames={},KeepBest=true,
    Picks={},CoreKinds={Tap=true,Slots=true},SkillKinds={},Mutations={},Enchants={},
    SummonStop={},Recipe="",NodeMode="Nearest",AutoAttack=false,AttackDelay=.25,
    RunSpeedEnabled=false,RunSpeed=32,InfiniteJump=false,UIScale=1,
}
local api={Config=config}
local cache,connections,controls={},{},{}
local core,adapter,window,library
local manualNext=0
local function module(name)
    if cache[name]then return cache[name]end
    local modules=RS:FindFirstChild("Modules")
    local m=modules and modules:FindFirstChild(name)
    assert(m and m:IsA("ModuleScript"),"Missing module: "..name)
    cache[name]=require(m);return cache[name]
end
local function send(event,...)
    assert(alive,"Stopped")
    assert(player:GetAttribute("ReloadingPlayerData")~=true,"Player data reloading")
    assert(player:GetAttribute("MineTradeSettling")~=true,"Trade settling")
    local remotes=RS:FindFirstChild("Remotes")
    local remote=remotes and remotes:FindFirstChild("GamestateEvent")
    assert(remote and remote:IsA("RemoteEvent"),"GamestateEvent unavailable")
    remote:FireServer(event,...)
end
local function manual(event,...)
    if os.clock()<manualNext then return false,"รอก่อนส่งคำขอถัดไป"end
    manualNext=os.clock()+.5
    local ok,err=pcall(send,event,...)
    return ok,ok and "ส่งคำขอแล้ว"or tostring(err)
end
local function myPlot()
    local world=workspace:FindFirstChild("MineWorld")
    local plots=world and world:FindFirstChild("Plots")
    if not plots then return nil end
    for _,p in ipairs(plots:GetChildren())do
        if tonumber(p:GetAttribute("OwnerUserId"))==player.UserId then return p end
    end
    local index=player:GetAttribute("MinePlotIndex")
    local p=index and plots:FindFirstChild("MinePlot"..tostring(index))
    if p and p:GetAttribute("OwnerUserId")==nil then return p end
end
local function nodeHealth(n)return n:GetAttribute("NodeHP")end
local function nodeAlive(n)
    local plot=myPlot()
    return n and n.Parent and plot and n:IsDescendantOf(plot)
        and n:GetAttribute("NodeBroken")~=true and(tonumber(nodeHealth(n))or 0)>0
end
local function findNode(mode)
    local char=player.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local best,score
    for _,n in ipairs(Collection:GetTagged("MineNode"))do
        if not nodeAlive(n)or not n.Name:match("^Node%d+$")then continue end
        local pos=n:IsA("Model")and n:GetPivot().Position or n:IsA("BasePart")and n.Position
        if not pos then continue end
        local value=mode=="LowestHP"and(tonumber(nodeHealth(n))or math.huge)
            or mode=="HighestHP"and-(tonumber(nodeHealth(n))or 0)
            or root and(pos-root.Position).Magnitude or 0
        if not score or value<score then best=n;score=value end
    end
    return best
end
local sellerState={phase="Idle",at=0}
local chestAt
local function sellerPosition()
    local stand=workspace:FindFirstChild("SellStand")
    if not stand then return nil end
    local prompt=stand:FindFirstChild("SellPrompt",true)
    local anchor=prompt and prompt.Parent
    if anchor and anchor:IsA("Attachment")then return anchor.WorldPosition end
    if anchor and anchor:IsA("BasePart")then return anchor.Position end
    for _,model in ipairs(stand:GetChildren())do
        if model:IsA("Model")and model:FindFirstChildOfClass("Humanoid")then
            local part=model:FindFirstChild("UpperTorso")or model:FindFirstChild("Torso")
                or model:FindFirstChild("HumanoidRootPart")or model:FindFirstChild("Head")
            if part then return part.Position end
        end
    end
    local part=stand:IsA("Model")and stand.PrimaryPart or nil
    part=part or stand:FindFirstChildWhichIsA("BasePart",true)
    return part and part.Position
end
local function cancelSeller()sellerState={phase="Idle",at=0};chestAt=nil end
local function chestStep()
    if not chestAt then
        return false,{Event="MineTeleport",Args={"Plot"},Sent=function()chestAt=os.clock()end},"กลับบ้านเพื่อหยิบของที่เลือกจากหีบ"
    end
    if os.clock()-chestAt<1 then return false,nil,"รอวาร์ปกลับถึงหีบ"end
    return true
end
local function sellerStep()
    local now=os.clock()
    local char=player.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local h=char and char:FindFirstChildOfClass("Humanoid")
    if not root or not h or h.Health<=0 then return false,nil,"รอตัวละครเกิดใหม่",{stage="WaitingCharacter"}end
    if sellerState.phase=="Idle"then
        return false,{Event="MineTeleport",Args={"Hub"},Sent=function()
            sellerState={phase="Hub",at=os.clock()}
        end},"วาร์ปไป Hub เพื่อขายของ",{stage="ToHub"}
    end
    if sellerState.phase=="Hub"then
        if now-sellerState.at<1 then return false,nil,"รอวาร์ปเข้า Hub",{stage="WaitingHub"}end
        local pos=sellerPosition()
        if not pos then return false,nil,"รอจุดขาย SellStand โหลด",{stage="WaitingSeller"}end
        h.Sit=false
        root.AssemblyLinearVelocity=Vector3.zero
        root.AssemblyAngularVelocity=Vector3.zero
        local dest=pos+Vector3.new(0,0,3)
        root.CFrame=CFrame.lookAt(dest,Vector3.new(pos.X,dest.Y,pos.Z))
        sellerState={phase="Settle",at=now,position=pos}
        return false,nil,"วาร์ปถึงจุดขาย รอตำแหน่งเข้าที่",{stage="Settling"}
    end
    local pos=sellerPosition()or sellerState.position
    local distance=pos and(root.Position-pos).Magnitude or math.huge
    if distance>8 then
        sellerState={phase="Hub",at=now-1}
        return false,nil,"ตำแหน่งถูกดึงออกจากจุดขาย กำลังเข้าใหม่",{stage="Reapproach",sellerDistance=distance}
    end
    if now-sellerState.at<.7 then return false,nil,"รอพร้อมขาย",{stage="Settling",sellerDistance=distance}end
    return true,nil,nil,{stage="AtSeller",sellerDistance=distance}
end
core=makeCore(config,{Now=os.clock,Send=send})
adapter=makeAdapter(config,{Module=module,FindNode=findNode,NodeAlive=nodeAlive,NodeHealth=nodeHealth,Manual=manual,
    SellerStep=sellerStep,ChestStep=chestStep,CancelSeller=cancelSeller},core)
api.Core=core
local file="DevilMineAuto79389059854988.json"
local function textSet(value)
    local out={}
    if type(value)=="table"then
        for k,v in pairs(value)do if type(k)=="number"and type(v)=="string"then out[v]=true elseif type(k)=="string"and v==true then out[k]=true end end
    elseif type(value)=="string"then out[value]=true end
    return out
end
local function selected(set)local out={};for k,on in pairs(set)do if on then out[#out+1]=k end end;table.sort(out);return out end
local function single(v)return type(v)=="table"and v[1]or v end
local limits={Reserve={0,1e100},ReserveDice={0,1000000},ReserveScroll={0,1000000},MaxLevel={1,10000},
    RunSpeed={8,200},UIScale={.6,1.5},AttackDelay={.15,2}}
local enums={Slot=true,Recipe=true,NodeMode=true}
local function loadSettings()
    if type(readfile)~="function"then return false,"ตัวรันไม่มี readfile"end
    local ok,value=pcall(function()return Http:JSONDecode(readfile(file))end)
    if not ok or type(value)~="table"or value.schema~=1 or type(value.config)~="table"then return false,"ยังไม่มีไฟล์ตั้งค่าที่ใช้ได้"end
    for key,default in pairs(config)do
        local v=value.config[key]
        if type(default)=="boolean"and type(v)=="boolean"then config[key]=v
        elseif limits[key]and type(v)=="number"and v==v then config[key]=math.clamp(v,table.unpack(limits[key]))
        elseif enums[key]and type(v)=="string"and #v<256 then config[key]=v
        elseif type(default)=="table"and type(v)=="table"then config[key]=textSet(v)end
    end
    return true,"โหลดตั้งค่าแล้ว"
end
function api.Save()
    if type(writefile)~="function"then return false,"ตัวรันไม่มี writefile"end
    local ok,err=pcall(writefile,file,Http:JSONEncode({schema=1,config=config}))
    return ok,ok and "บันทึกตั้งค่าแล้ว"or tostring(err)
end
function api.Report()
    local report=core.Report()
    local d,m=adapter.Data()
    report.placeId=game.PlaceId;report.userId=player.UserId;report.config=config
    report.data={ready=m~=nil,money=d and d.Money,currentZone=m and m.CurrentZone,holders=m and m.Holders,
        chest=m and m.Chest,unlockedZones=m and m.UnlockedZones}
    report.target=adapter.Target
    report.sell=adapter.SellInfo
    return report
end
function api.CopyReport()
    local out=Http:JSONEncode(api.Report())
    local clip=setclipboard or toclipboard or set_clipboard
    if type(clip)=="function"then pcall(clip,out)end
    if type(writefile)=="function"then pcall(writefile,"DevilMineReport.json",out)end
    return out
end
local oldHumanoid,oldSpeed
local function restoreSpeed()
    if oldHumanoid and oldHumanoid.Parent and oldSpeed then pcall(function()oldHumanoid.WalkSpeed=oldSpeed end)end
    oldHumanoid=nil;oldSpeed=nil
end
function api.Destroy()
    if not alive then return end
    alive=false;core.Destroy();adapter.CancelSale();restoreSpeed()
    for _,c in ipairs(connections)do pcall(c.Disconnect,c)end
    if window then window:Destroy();window=nil end
    if env.DevilMineTest==api then env.DevilMineTest=nil end
end
local function fetch(url)
    local ok,body=pcall(function()return game:HttpGet(url)end)
    if ok and type(body)=="string"and #body>0 then return body end
    local req=request or http_request or(type(http)=="table"and http.request)or(type(syn)=="table"and syn.request)
    assert(type(req)=="function","HTTP unavailable")
    local r=req({Url=url,Method="GET"})
    assert(type(r)=="table"and(tonumber(r.StatusCode or r.Status or 200)or 0)<400,"GUI download failed")
    return r.Body or r.body
end
loadSettings()
local labels={
    Farm="ฟาร์มหินด้วยคนงาน",Equip="ใส่ตัวละครที่ดีที่สุด",Chest="เก็บของจากหีบ",
    Sell="ขายของตามตัวกรอง",ChestSell="ตั้งขายของจากหีบอัตโนมัติ",Pickaxe="ซื้อ Pickaxe ที่เลือก",
    UpgradeDamage="อัปเกรดดาเมจตัวละคร",UpgradeSpeed="อัปเกรดเดินคนงาน",UpgradeMineSpeed="อัปเกรดความเร็วขุด",
    Core="อัปเกรดหลัก / ช่องคนงาน",Skills="ซื้อสกิลตามที่เลือก",Mutation="สุ่ม Mutation",
    Enchant="สุ่ม Enchant",Craft="คราฟต์อัตโนมัติ",Summon="ใช้ Summon Scroll",Daily="รับรางวัลหมุนรายวัน",Quest="รับ Daily Quest",
}
local function notify(message)
    if controls.Message then controls.Message:Set(tostring(message),true)end
end
local function toggle(group,key,name)
    controls[key]=group:CreateToggle({Name=name or labels[key]or key,CurrentValue=config[key],Callback=function(on)
        if core.Jobs[key]then core.Set(key,on)else config[key]=on==true end
        if key=="Sell"and not on then adapter.CancelSale()end
    end})
end
local function dropdown(group,key,name,options,multiple)
    local w=group:CreateDropdown({Name=name,Options=options,MultipleOptions=multiple,AllowNone=true,Searchable=true,
        CurrentOption=multiple and selected(config[key])or config[key],
        Callback=function(v)config[key]=multiple and textSet(v)or(single(v)or "")end})
    controls[key]=w;return w
end
local function slider(group,key,name,min,max,step)
    controls[key]=group:CreateSlider({Name=name,Range={min,max},Increment=step or 1,CurrentValue=config[key],Callback=function(v)config[key]=v end})
end
local function input(group,key,name)
    controls[key]=group:CreateInput({Name=name,CurrentValue=tostring(config[key]),Numeric=true,Callback=function(v)
        local n=tonumber(v);if n and n==n then config[key]=math.clamp(n,table.unpack(limits[key]))end
    end})
end
local function options()
    local ok,result=pcall(adapter.Options)
    if ok then return result end
    core.Error("Options",result)
    return {Names={},Slots={"All"},Zones={},Recipes={},Enchants={},Mutations={},Picks={},Skills={}}
end
local function refresh()
    local opts=options()
    local maps={SellNames=opts.Names,ChestSellNames=opts.Names,Slot=opts.Slots,Recipe=opts.Recipes,
        Picks=opts.Picks,Enchants=opts.Enchants,Mutations=opts.Mutations}
    for key,list in pairs(maps)do
        if controls[key]then
            controls[key]:Refresh(list,true,true)
            controls[key]:Set(type(config[key])=="table"and selected(config[key])or config[key],true)
        end
    end
    notify("อัปเดตรายการจากเกมแล้ว")
end
local function buildUI()
    local opts=options()
    local logo=resolveLogo({Env=env,Fetch=fetch,APIs={
        writefile=writefile or write_file,readfile=readfile or read_file,isfile=isfile or is_file,
        getcustomasset=getcustomasset,getsynasset=getsynasset,get_custom_asset=get_custom_asset}})
    window=library:CreateWindow({Name="DEVIL HUB",Icon=logo,Theme="Abyss",Density="Compact",Profile=true,
        Search=false,Home=false,Loading=false,Backdrop=false,Disclaimer=false,UnsupportedExecutor=false,
        Size=UDim2.fromOffset(850,590),KeepOnScreen=true,ToggleButton={Platform="Both",Icon=logo},
        ConfigurationSaving={Enabled=false}})
    local function tab(name,icon)return window:CreateTab({Name=name,Icon=icon})end
    local function group(parent,name,side,icon)return parent:CreateGroupbox({Name=name,Side=side,Icon=icon})end
    local farm=tab("ฟาร์มเหมือง","pickaxe")
    local mining=group(farm,"คนงานและหีบ","Left","hammer")
    toggle(mining,"Farm");toggle(mining,"Equip");toggle(mining,"Chest")
    dropdown(mining,"NodeMode","เลือกหิน",{"Nearest","LowestHP","HighestHP"},false)
    mining:CreateParagraph({Name="เส้นทางฟาร์ม",Content="ส่ง Miner ในฐานของเราไปหาหิน ล็อกเป้าหมายจนแตก ไม่ติดตั้ง Remote Spy"})
    local combat=group(farm,"โจมตี / สถานะ","Right","swords")
    toggle(combat,"AutoAttack","ใช้อาวุธที่ถืออัตโนมัติ")
    slider(combat,"AttackDelay","ระยะห่างการใช้อาวุธ",.15,2,.05)
    combat:CreateParagraph({Name="อาวุธ",Content="ใช้ Tool.Activate ตามระบบเกม ต้องถืออาวุธและอยู่ในระยะเอง ดาเมจขึ้นกับเกม"})
    controls.Status=combat:CreateParagraph({Name="สถานะระบบ",Content="พร้อมใช้งาน"})
    combat:CreateButton({Name="หยุดออโต้ทั้งหมด",Callback=function()
        core.StopAll();adapter.CancelSale();config.AutoAttack=false
        for key in pairs(core.Jobs)do if controls[key]then controls[key]:Set(false,true)end end
        if controls.AutoAttack then controls.AutoAttack:Set(false,true)end
    end})
    local bag=tab("กระเป๋า / ขาย","backpack")
    local sell=group(bag,"ขายแบบกรอง","Left","coins")
    toggle(sell,"Sell")
    dropdown(sell,"SellKinds","ชนิดที่จะขาย",{"Ore","Character","Pickaxe"},true)
    dropdown(sell,"SellRarities","ระดับที่จะขาย",{"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Exotic", "Limited", "Exclusive", "Scaled"},true)
    dropdown(sell,"SellNames","ชื่อที่จะขาย",opts.Names,true)
    toggle(sell,"KeepBest","เก็บตัวละครที่ดีที่สุดไว้")
    sell:CreateParagraph({Name="ตัวกรอง / เส้นทางขาย",Content="ถ้ากระเป๋าว่างจะหยิบของตรงตัวกรองจากหีบ วาร์ปไปขาย แล้วกลับบ้านเมื่อจำนวนของลดลง ตัวกรองแต่ละช่องใช้ร่วมกัน"})
    local chest=group(bag,"ขายจากหีบ","Right","archive")
    toggle(chest,"ChestSell");dropdown(chest,"ChestSellNames","ชื่อที่ให้เกมขายทันที",opts.Names,true)
    chest:CreateParagraph({Name="การตั้งค่าขายของเกม",Content="เปิดเพื่อเพิ่มชื่อที่เลือกลง Auto Sell ของเกม ปิดออโต้จะไม่ลบการตั้งค่าที่ส่งไปแล้ว ปรับปิดชื่อได้จากเมนู Auto Sell ของเกม"})
    chest:CreateButton({Name="รีเฟรชรายการ",Callback=refresh})
    local upgrades=tab("ซื้อ / อัปเกรด","trending-up")
    local chars=group(upgrades,"ตัวละคร","Left","users")
    dropdown(chars,"Slot","ช่องตัวละคร",opts.Slots,false)
    toggle(chars,"UpgradeDamage");toggle(chars,"UpgradeSpeed");toggle(chars,"UpgradeMineSpeed")
    slider(chars,"MaxLevel","ระดับสูงสุดที่ให้อัป",1,500)
    local shop=group(upgrades,"สกิลและ Pickaxe","Right","shopping-cart")
    toggle(shop,"Core");dropdown(shop,"CoreKinds","อัปเกรดหลัก",{"Tap","Slots"},true)
    toggle(shop,"Skills")
    local skills={};for k in pairs(opts.Skills)do skills[#skills+1]=k end;table.sort(skills)
    dropdown(shop,"SkillKinds","ตระกูลสกิล",skills,true)
    toggle(shop,"Pickaxe");dropdown(shop,"Picks","Pickaxe ที่ให้ซื้อ",opts.Picks,true)
    input(shop,"Reserve","เงินสำรอง")
    local rolls=tab("Mutation / Enchant","sparkles")
    local mutation=group(rolls,"Mutation ตัวละคร","Left","dna")
    toggle(mutation,"Mutation");dropdown(mutation,"Mutations","หยุดเมื่อได้ Mutation",opts.Mutations,true)
    mutation:CreateParagraph({Name="ช่องเป้าหมาย",Content="ใช้ช่องตัวละครที่เลือกในหมวดซื้อ / อัปเกรด ต้องเลือกช่องเดียว สุ่มจนได้ค่าที่เลือกหรือเงินถึงสำรอง"})
    local enchant=group(rolls,"Enchant","Right","wand-sparkles")
    toggle(enchant,"Enchant");dropdown(enchant,"Enchants","หยุดเมื่อมี Enchant เหล่านี้",opts.Enchants,true)
    input(enchant,"ReserveDice","เก็บลูกเต๋าไว้")
    enchant:CreateParagraph({Name="เงื่อนไข",Content="ใช้ลูกเต๋าปกติครั้งละ 1 ลูก หยุดเมื่อพบ Enchant ที่เลือกในกระเป๋า ไม่ทับ Enchant ที่ใส่เอง"})
    local extra=tab("Summon / รางวัล","gift")
    local summon=group(extra,"Summon และ Craft","Left","flame")
    toggle(summon,"Summon");dropdown(summon,"SummonStop","หยุดเมื่อมีตัวละครระดับนี้",{"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Exotic", "Limited", "Exclusive", "Scaled"},true)
    input(summon,"ReserveScroll","เก็บ Summon Scroll ไว้")
    toggle(summon,"Craft");dropdown(summon,"Recipe","สูตรคราฟต์",opts.Recipes,false)
    summon:CreateParagraph({Name="Crafting",Content="Dump ปัจจุบันตั้ง Enabled=false ระบบจะรอจนเกมเปิดใช้งาน"})
    local rewards=group(extra,"รางวัล","Right","calendar-check")
    toggle(rewards,"Daily")
    rewards:CreateParagraph({Name="Daily Quest",Content="เกมปิด Daily Quest อยู่ จึงยังไม่ส่งคำขอรับเควสต์"})
    local travel=tab("เดินทาง / ผู้เล่น","map-pin")
    local zones=group(travel,"เดินทางด้วยระบบเกม","Left","compass")
    local zoneChoice="Highest"
    zones:CreateDropdown({Name="โซน",Options=opts.Zones,AllowNone=true,Searchable=true,
        Callback=function(v)zoneChoice=single(v)end})
    zones:CreateButton({Name="ไปโซนที่เลือก",Callback=function()local _,msg=adapter.Travel(zoneChoice);notify(msg)end})
    zones:CreateButton({Name="เลือกโซนสูงสุดที่ปลดล็อก",Callback=function()local _,msg=adapter.Travel("Highest");notify(msg)end})
    zones:CreateButton({Name="กลับเหมืองของเรา",Callback=function()local _,msg=adapter.Travel("Plot");notify(msg)end})
    zones:CreateButton({Name="ไป Hub",Callback=function()local _,msg=adapter.Travel("Hub");notify(msg)end})
    local movement=group(travel,"ผู้เล่น","Right","person-standing")
    toggle(movement,"RunSpeedEnabled","ปรับความเร็ววิ่ง")
    slider(movement,"RunSpeed","ความเร็ววิ่ง",8,200)
    toggle(movement,"InfiniteJump","กระโดดไม่จำกัด")
    local settings=tab("ตั้งค่า / รายงาน","settings")
    local save=group(settings,"บันทึกการตั้งค่า","Left","save")
    controls.Message=save:CreateParagraph({Name="ข้อความ",Content="พร้อมใช้งาน • mine-auto-test-4"})
    save:CreateButton({Name="บันทึกตั้งค่า",Callback=function()local _,msg=api.Save();notify(msg)end})
    save:CreateParagraph({Name="เรียกคืนอัตโนมัติ",Content="รันใหม่จะใช้ค่าที่บันทึกไว้ รวมสถานะเปิดออโต้ของแต่ละระบบ"})
    save:CreateButton({Name="รีเฟรชรายการจากเกม",Callback=refresh})
    save:CreateButton({Name="คัดลอก / บันทึกรายงาน",Callback=function()api.CopyReport();notify("บันทึก DevilMineReport.json แล้ว ถ้าตัวรันรองรับ")end})
    save:CreateButton({Name="ปิด Script",Callback=api.Destroy})
    local social=group(settings,"DEVIL HUB","Right","message-circle")
    social:CreateParagraph({Name="Discord",Content="https://discord.gg/ZY7PRcVJe2"})
    social:CreateButton({Name="คัดลอก Discord",Callback=function()
        local clip=setclipboard or toclipboard or set_clipboard
        if type(clip)=="function"then clip("https://discord.gg/ZY7PRcVJe2")end
    end})
    social:CreateParagraph({Name="รุ่นทดลอง",Content="อ่านข้อมูลจากโมดูลเกมและส่งคำขอตามรูปแบบใน Dump ไม่ใช้ hook ของ Remote Spy"})
    if window.Gui then connections[#connections+1]=window.Gui.Destroying:Connect(api.Destroy)end
end
local ok,err=xpcall(function()
    local source=fetch("https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau")
    library=assert(loadstring(source,"DEVIL HUB / Mine GUI"))()
    buildUI()
end,function(e)return tostring(e)end)
if not ok then api.Destroy();error(err)end
env.DevilMineTest=api
connections[#connections+1]=game:GetService("UserInputService").JumpRequest:Connect(function()
    if not alive or not config.InfiniteJump then return end
    local char=player.Character;local h=char and char:FindFirstChildOfClass("Humanoid")
    if h and h.Health>0 then h:ChangeState(Enum.HumanoidStateType.Jumping)end
end)
task.spawn(function()
    local lastUI,lastAttack=0,0
    while alive do
        local good,message=pcall(function()
            core.Tick()
            local char=player.Character;local h=char and char:FindFirstChildOfClass("Humanoid")
            if config.RunSpeedEnabled and h then
                if oldHumanoid~=h then restoreSpeed();oldHumanoid=h;oldSpeed=h.WalkSpeed end
                h.WalkSpeed=config.RunSpeed
            elseif oldHumanoid then restoreSpeed()end
            if config.AutoAttack and not adapter.SellBusy()and char and h and h.Health>0 and os.clock()-lastAttack>=config.AttackDelay then
                local tool=char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate();lastAttack=os.clock()end
            end
            if os.clock()-lastUI>=1 then
                lastUI=os.clock();local lines={}
                for key,label in pairs(labels)do
                    if config[key]then local j=core.Jobs[key];lines[#lines+1]=label..": "..j.Status end
                end
                table.sort(lines)
                if controls.Status then controls.Status:Set(#lines>0 and table.concat(lines,"\n")or "ออโต้ปิดอยู่",true)end
            end
        end)
        if not good then core.Error("Worker",message)end
        task.wait(.1)
    end
end)
return api
