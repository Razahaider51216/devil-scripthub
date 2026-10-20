-- Captured unchanged native Break language controller; fixture only.
-- Source: break-halloween-zones-release/gameplay.patched.lua (existing release build).
return function(window,scope,keep,library)
    local words={
        ["Info"]="ข้อมูล",["Main"]="หลัก",["Visuals"]="ภาพ / ESP",["Player"]="ผู้เล่น",["Settings"]="ตั้งค่า",
        ["Saved Settings"]="บันทึกตั้งค่า",["Save Settings"]="บันทึกค่าปัจจุบัน",["Load Saved Settings"]="โหลดค่าที่บันทึก",
        ["Restore on next run"]="คืนค่าเมื่อรันครั้งถัดไป",
        ["Press Save Settings after changing options. The next run restores filters and values first, then the saved automation toggles. Settings are stored locally for this account and map."]="ตั้งค่าตามต้องการแล้วกดบันทึก รันครั้งถัดไปจะคืนค่าฟิลเตอร์และค่าต่าง ๆ ก่อนเปิดระบบออโต้ตามที่บันทึก เก็บไฟล์ไว้ในเครื่องแยกตามบัญชีและแมพ",
        ["Settings saved; will load on next run"]="บันทึกแล้ว จะโหลดอัตโนมัติเมื่อรันใหม่",["Saved settings loaded"]="โหลดค่าที่บันทึกแล้ว",
        ["Saved settings restored automatically"]="คืนค่าที่บันทึกอัตโนมัติแล้ว",["No settings loaded"]="ยังไม่ได้โหลดตั้งค่า",
        ["No saved settings; current values kept"]="ยังไม่มีค่าที่บันทึก ใช้ค่าปัจจุบัน",
        ["Saved settings could not be read; current values kept"]="อ่านไฟล์ตั้งค่าไม่ได้ ใช้ค่าปัจจุบัน",
        ["Unable to save settings; check report"]="บันทึกตั้งค่าไม่สำเร็จ ดูรายงาน",
        ["Some saved controls could not be restored; check report"]="คืนค่าบางรายการไม่สำเร็จ ดูรายงาน",
        ["Saving unavailable: executor writefile API missing"]="บันทึกไม่ได้ ตัวรันไม่รองรับ writefile",
        ["Loading unavailable: executor readfile API missing"]="โหลดไม่ได้ ตัวรันไม่รองรับ readfile",
        ["Break"]="ทุบไข่",["Farm"]="เก็บสัตว์",["Plot"]="ฐาน",["Search"]="ค้นหา",
        ["Auto Break"]="ทุบไข่อัตโนมัติ",["Auto Pickup"]="เก็บสัตว์อัตโนมัติ",["Auto Pick Up + Bank"]="เก็บสัตว์และส่งเข้าเซฟโซน",
        ["Auto Pick Up & Bank"]="เก็บสัตว์และส่งเข้าเซฟโซน",["Auto Pick Up"]="เก็บสัตว์อัตโนมัติ",
        ["Rarity Filter"]="เลือกระดับ",["Zone Filter"]="เลือกด่าน",["Animal Filter"]="เลือกสัตว์",
        ["Auto Upgrade Pen"]="อัปเกรดคอกอัตโนมัติ",["Auto Upgrade Treadmill"]="อัปเกรดลู่วิ่งอัตโนมัติ",
        ["Auto Go on Treadmill"]="เข้าลู่วิ่งอัตโนมัติ",["Auto Rebirth"]="รีเบิร์ทอัตโนมัติ",
        ["Auto Hatch"]="ฟักไข่อัตโนมัติ",["Auto Swing"]="ตีอัตโนมัติ",["Auto Equip Best"]="เลือกสัตว์ดีที่สุดอัตโนมัติ",
        ["Auto Buy Pickaxes"]="ซื้อพลั่วอัตโนมัติ",["Auto Buy Trails"]="ซื้อ Trails อัตโนมัติ",
        ["Walk Speed"]="ความเร็วเดิน",["Fly Speed"]="ความเร็วลอย",["Fly"]="ลอย",["Noclip"]="ทะลุกำแพง",
        ["Infinite Jump"]="กระโดดไม่จำกัด",["Anti AFK"]="ป้องกัน AFK",["Theme"]="ธีม",
        ["Unload"]="ปิดสคริปต์",["Unload Script"]="ปิดสคริปต์",["Toggle UI"]="แสดง / ซ่อนหน้าต่าง",
        ["Copy Discord Invite"]="คัดลอกลิงก์ Discord",["Copy / Save Movement Report"]="คัดลอก / บันทึกรายงานการเคลื่อนที่",
        ["Carry fly speed / ความเร็วลอยกลับ"]="ความเร็วลอยกลับ",["Minimum Pickup income ($/s)"]="เงินขั้นต่ำ Auto Pickup ($/s)",
        ["Filter by animal income"]="เลือกตามรายได้สัตว์",
        ["Hell / Demon Event"]="อีเวนต์ Hell / Demon",["Play Event"]="เล่นอีเวนต์",["Event Status"]="สถานะอีเวนต์",
        ["Auto Join + Essence + Boss"]="เข้าอีเวนต์ + ตี Essence + ตีบอสอัตโนมัติ",["Join when Hell opens"]="เข้าประตูเมื่อ Hell เปิด",
        ["Flight speed (studs/s)"]="ความเร็วลอย (studs/s)",["Auto Buy Demon Eggs"]="ซื้อไข่ Demon ด้วย Fallen Tokens อัตโนมัติ",
        ["Token reserve"]="Tokens สำรอง",["Event Movement"]="รูปแบบการเล่น",
        ["Pet Fusion"]="ผสมสัตว์เป็นไข่",["Fusion Machines"]="เครื่องผสม",["Allowed Materials"]="สัตว์ที่อนุญาตให้ใช้",
        ["Merge: 3 identical animals into an egg"]="Merge: ผสมสัตว์ชื่อเดียวกัน 3 ตัวเป็นไข่",
        ["Fuse: deposit recipe + claim Celestial egg"]="Fuse: ฝากตามสูตร + รับไข่ Celestial",
        ["Preview 3 Merge materials"]="ดูสัตว์ 3 ตัวที่จะใช้ Merge",["Fuse Recipe"]="สูตร Fuse",
        ["Material Rarities"]="ระดับสัตว์ที่ใช้เป็นวัตถุดิบ",["Use animals on owned plot"]="รวมสัตว์ที่วางบนฐานตัวเอง",
        ["Keep the heaviest animal"]="เก็บสัตว์ตัวหนักที่สุดไว้",["Skip Mutation / Variant"]="ไม่ใช้สัตว์ติด Mutation / Variant",
        ["Max material weight (0 = unlimited)"]="น้ำหนักวัตถุดิบสูงสุด (0 = ไม่จำกัด)",["Material Rules"]="ขอบเขตวัตถุดิบ",
        ["Copy / Save Event Report"]="คัดลอก / บันทึกรายงานอีเวนต์",["Stop Event / Fusion"]="หยุดอีเวนต์ / ผสมสัตว์",
        ["Off"]="ปิดอยู่",["Enabled"]="เปิดแล้ว",["Waiting for Hell event"]="รออีเวนต์ Hell เปิด",
        ["Waiting for Auto Pickup to finish delivery"]="รอ Auto Pickup ส่งสัตว์เข้าเซฟโซน",
        ["Waiting for Hell doorway to load"]="รอประตู Hell โหลด",["Waiting for game to confirm Hell entry"]="ถึงประตูแล้ว รอเกมยืนยันเข้า Hell",
        ["Attacking Essence eggs"]="กำลังตีไข่เก็บ Essence",["Attacking boss with Bat"]="กำลังตีบอสด้วย Bat",
        ["Flying toward target"]="กำลังลอยเข้าหาเป้าหมาย",["Waiting for boss to spawn or load"]="รอบอสเกิดหรือโหลด",
        ["Waiting for attackable boss phase"]="รอช่วงที่ตีบอสได้",["Error; check report"]="เกิดข้อผิดพลาด ดูรายงาน",
        ["Paused during Event"]="พักผสมระหว่างเล่นอีเวนต์",
        ["Fly close to ground (0.4-stud foot clearance), keep attacking during boss skills and hold against knockback. Speed: 10–140. Requires Pickaxe / Bat; respects game cooldowns."]="ลอยต่ำเหนือพื้นประมาณ 0.4 studs ไปประตูและหาเป้าหมาย ปรับความเร็ว 10–140 studs/s ตรึงตัวกันกระเด็นระหว่างสกิลบอส ไม่หยุดตีเพื่อรอหลบ ใช้ Pickaxe / Bat และตีต่อเนื่องตามคูลดาวน์เกม",
        ["Enter 1000000 or 1M to Steal animals earning at least 1M/s. Combines with selected rarity/name. Use 0 to disable income filtering."]="ใส่ 1000000 หรือ 1M เพื่อ Steal รายได้ 1M/s ขึ้นไป ใช้ร่วมกับระดับและชื่อที่เลือก ใส่ 0 เพื่อปิดเงื่อนไขเงิน",
    }

    words["Event farming zone"]="ด่านฟาร์มอีเวนต์"
    words["Auto: Best Candy"]="อัตโนมัติ: ขนมคุ้มค่าที่สุด"
    words["Auto: Highest Zone"]="อัตโนมัติ: ด่านสูงสุด"
    words["Sell Eggs / Animals"]="ขายไข่ / สัตว์"
    words["Sale Filters"]="ตัวกรองขาย"
    words["Selected Sale"]="ขายเฉพาะที่เลือก"
    words["Auto Sell Selected Items"]="ขายไข่ / สัตว์ที่เลือกอัตโนมัติ"
    words["Include Eggs"]="ขายไข่ด้วย"
    words["Include Animals"]="ขายสัตว์ด้วย"
    words["Egg Species to Sell"]="ชื่อไข่ที่จะขาย"
    words["Animal Species to Sell"]="ชื่อสัตว์ที่จะขาย"
    words["Sale Rarities"]="ระดับที่จะขาย"
    words["Keep the Best of Each Species"]="เก็บตัวดีที่สุดของแต่ละชื่อ"
    words["Keep Mutations / Variants"]="เก็บตัวติด Mutation / Variant"
    words["Max Sale Weight (0 = unlimited)"]="น้ำหนักขายสูงสุด (0 = ไม่จำกัด)"
    words["Preview Sale"]="ดูรายการที่จะขาย"
    words["Sell Selected Now"]="ขายรายการที่เลือกตอนนี้"
    words["Refresh Inventory Names"]="รีเฟรชรายชื่อในกระเป๋า"
    words["No matching items"]="ไม่มีรายการตรงตัวกรอง"
    words["Auto Halloween"]="เล่น Halloween อัตโนมัติ"
    words["Halloween Status / Shop"]="สถานะ / ร้าน Halloween"
    words["Auto Event / Play Halloween"]="Auto Event / เล่น Halloween อัตโนมัติ"
    words["Bank when bag reaches"]="กลับฝากเมื่อขนมถึง"
    words["Halloween ESP / Hidden eggs, houses, candy, enemies"]="ESP Halloween / ไข่ซ่อน บ้าน ขนม ศัตรู"
    words["Event Priority"]="ลำดับการทำงาน"
    words["4 Events"]="4 อีเวนต์"
    words["Halloween Eggs to Buy"]="ไข่ Halloween ที่ซื้อ"
    words["Potions to Buy"]="โพชันที่ซื้อ"
    words["Auto Buy Halloween Shop"]="ซื้อของร้าน Halloween อัตโนมัติ"
    words["Candy Corn Reserve"]="Candy Corn สำรอง"
    words["Halloween Shop"]="ร้าน Halloween"
    words["Waiting for Halloween event"]="รออีเวนต์ Halloween เริ่ม"
    words["Flying to event target"]="กำลังลอยหาเป้าหมายอีเวนต์"
    words["Breaking event target"]="กำลังทุบเป้าหมายอีเวนต์"
    words["Flying to collect candy"]="กำลังลอยเก็บขนม"
    words["Waiting for event targets"]="รอเป้าหมายอีเวนต์เกิด"
    words["Returning to bank candy"]="นำขนมกลับฝากเซฟโซน"
    words["In safe zone; waiting for candy bank"]="อยู่ในเซฟโซน รอเกมฝากขนม"
    words["Candy collected"]="เก็บขนมแล้ว"
    words["Game confirmed candy bank"]="เกมยืนยันฝากขนมแล้ว"
    words["Waiting for character recovery"]="รอตัวละครฟื้นก่อนเคลื่อนที่"
    words["Waiting for game pickaxe"]="รอ Pickaxe ของเกม"
    words["Waiting for candy collection confirmation"]="ถึงขนมแล้ว รอเกมยืนยันการเก็บ"
    words["Waiting for Candy Corn / stock or selected items"]="รอ Candy Corn / สต็อก หรือเลือกรายการซื้อ"
    words["SpeedPower is below the Halloween shop requirement"]="SpeedPower ยังไม่ถึงเงื่อนไขร้าน Halloween"
    words["Buying from Halloween shop"]="กำลังซื้อจากร้าน Halloween"
    words["Game confirmed purchase"]="เกมยืนยันซื้อสำเร็จ"
    words["Shop has not confirmed the purchase"]="ร้านยังไม่ยืนยันการซื้อ"
    words["When an event begins, pause other automation first. Deliver any carried animal before joining. Resume prior automation afterward. Uses the game pickaxe and low flight like Auto Pickup."]="เมื่ออีเวนต์เริ่ม พักออโต้ทั้งหมดเพื่อเล่นก่อน ถ้าถือสัตว์อยู่จะส่งเข้าเซฟโซนให้เสร็จก่อน เมื่ออีเวนต์จบจะคืนระบบที่เปิดไว้ ใช้ Pickaxe เกมและลอยต่ำแบบ Auto Pickup"
    words["Phantom Eggs: find disguised eggs / House of Horrors: break houses / Candy Carnage: break candy piles and bank / Blood Moon: gather candy while avoiding enemies"]="Phantom Eggs: หาไข่ปลอมตัว / House of Horrors: ทุบบ้าน / Candy Carnage: ทุบกองขนมและฝาก / Blood Moon: เก็บขนมพร้อมเลี่ยงศัตรู"
    words["Buy selected items only, respecting reserves and stock. Requires the game SpeedPower threshold. Buying is disabled by default."]="ซื้อเฉพาะรายการที่เลือก ตรวจเงินสำรองและสต็อกก่อนซื้อ ต้องมี SpeedPower ตามเงื่อนไขเกม เริ่มต้นปิดการซื้อ"
    local reverse={};for en,th in pairs(words)do if not reverse[th]then reverse[th]=en end end
    reverse["เก็บสัตว์อัตโนมัติ"]="Auto Pickup";reverse["ปิดสคริปต์"]="Unload Script"
    local language=scope.DevilBreakLanguage=="EN"and"EN"or"TH"
    local records,links={},{};local active=true;local busy=false
    local function translate(text)
        local dictionary=language=="TH"and words or reverse
        if dictionary[text]then return dictionary[text]end
        if not text:find("\n",1,true)then return text end
        local keys={};for key in pairs(dictionary)do keys[#keys+1]=key end
        table.sort(keys,function(a,b)return #a>#b end)
        for _,key in ipairs(keys)do
            local escaped=key:gsub("([^%w])","%%%1")
            text=text:gsub(escaped,function()return dictionary[key]end)
        end
        if language=="EN"then text=text:gsub("ส่งคำขอ:","Requests:"):gsub("ยืนยัน:","Confirmed:")end
        return text
    end
    local function render(record)
        if not active or busy then return end
        busy=true;record.object[record.property]=translate(record.source);busy=false
    end
    local function watch(object)
        if object.Name=="DevilLanguageButton"then return end
        local property
        if object:IsA("TextLabel")or object:IsA("TextButton")then property="Text"
        elseif object:IsA("TextBox")then property="PlaceholderText"end
        if not property or records[object]then return end
        local record={object=object,property=property,source=object[property]};records[object]=record
        links[#links+1]=object:GetPropertyChangedSignal(property):Connect(function()
            if busy or not active then return end
            record.source=object[property];render(record)
        end)
        render(record)
    end
    local minimize=assert(window.MinimizeButton,"DEVIL HUB minimize button unavailable")
    local button=Instance.new("TextButton");button.Name="DevilLanguageButton";button.AnchorPoint=Vector2.new(1,0)
    button.Position=minimize.Position-UDim2.fromOffset(40,0);button.Size=UDim2.fromOffset(78,34)
    button.Text="ไทย / EN";button.TextSize=13;button.Font=Enum.Font.GothamSemibold
    button.TextColor3=library.Theme.Text;button.BackgroundColor3=library.Theme.Surface2;button.ZIndex=50
    button:SetAttribute("NoDrag",true);button.Parent=minimize.Parent
    if window.SearchBox and window.SearchBox.Parent then
        local search=window.SearchBox.Parent
        search.Position=search.Position-UDim2.fromOffset(92,0);search.Size=UDim2.fromOffset(200,34)
    end
    local ctl={}
    function ctl.SetLanguage(value)
        if not active or(value~="TH"and value~="EN")then return end
        language=value;scope.DevilBreakLanguage=value
        for _,record in pairs(records)do render(record)end
    end
    function ctl.Destroy()
        if not active then return end;active=false
        for _,link in ipairs(links)do link:Disconnect()end
        table.clear(records);button:Destroy()
    end
    links[#links+1]=button.MouseButton1Click:Connect(function()ctl.SetLanguage(language=="TH"and"EN"or"TH")end)
    for _,object in ipairs(window.Gui:GetDescendants())do watch(object)end
    links[#links+1]=window.Gui.DescendantAdded:Connect(watch)
    keep(window.Gui.Destroying:Connect(ctl.Destroy))
    scope.DevilBreakLanguage=language
    return ctl
end
