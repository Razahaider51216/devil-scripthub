-- Reuse the single language menu provided by the shared DEVIL HUB presentation.
local translations={
    ["Farm"]="ฟาร์ม",["Farm controls"]="ระบบฟาร์ม",["Auto Roll"]="สุ่มลูกเต๋าอัตโนมัติ",
    ["Auto Collect Money"]="เก็บเงินฐานอัตโนมัติ",["Auto Equip Best Base"]="จัดตัวหาเงินดีที่สุด",
    ["Auto Level Units"]="อัปเลเวลตัวในฐาน",["Maximum unit level"]="เลเวลตัวสูงสุด",
    ["Dice and upgrades"]="ลูกเต๋าและอัปเกรด",["Auto Buy / Equip Dice"]="ซื้อและใส่ลูกเต๋าอัตโนมัติ",
    ["Dice selection"]="เลือกลูกเต๋า",["Auto Upgrade Tree"]="ซื้อโหนดอัปเกรดอัตโนมัติ",
    ["Upgrade branch"]="สายอัปเกรด",["Money reserve"]="เงินสำรอง",["Live status"]="สถานะปัจจุบัน",
    ["Connecting game modules..."]="กำลังเชื่อมต่อข้อมูลเกม...",["All automation starts off."]="ออโต้ทุกระบบเริ่มปิดไว้",
    ["Stop all automation"]="หยุดออโต้ทั้งหมด",["Inventory"]="กระเป๋า",["Sell and protect"]="ขายและเก็บตัว",
    ["Auto Sell Filtered Units"]="ขายอัตโนมัติตามตัวกรอง",["Sell maximum chance (0 = off)"]="โอกาสสุ่มสูงสุดที่ขาย (0 = ปิด)",
    ["Keep best units"]="จำนวนตัวดีที่สุดที่เก็บ",["Keep copies per character"]="จำนวนที่เก็บต่อชื่อตัว",
    ["Keep mutated / variant units"]="เก็บตัวติด Mutation / Variant",["Keep character names"]="ชื่อตัวที่เก็บไว้",
    ["Keep specific units"]="เลือกตัวที่เก็บไว้",["Disable game Auto Sell"]="ปิด Auto Sell เดิมของเกม",
    ["Preview matching units before selling or fusing."]="ดูรายชื่อก่อนเปิดขายหรือผสม",["Preview sale"]="ดูตัวที่จะขาย",
    ["Lock and fusion"]="ล็อกและผสม",["Auto Lock Rare Units"]="ล็อกตัวหายากอัตโนมัติ",
    ["Lock minimum chance (0 = off)"]="โอกาสสุ่มขั้นต่ำที่ล็อก (0 = ปิด)",["Auto Fuse Surplus Units"]="ผสมตัวส่วนเกินอัตโนมัติ",
    ["Fuse maximum chance (0 = off)"]="โอกาสสุ่มสูงสุดที่ใช้ผสม (0 = ปิด)",["Preview fusion"]="ดูตัวที่จะผสม",
    ["Material filters"]="ตัวกรองวัตถุดิบ",
    ["Locked, plotted, team and kept units are excluded. Fusion consumes three units. Set chance limits before enabling."]="ข้ามตัวที่ล็อก อยู่ในฐาน อยู่ในทีม และตัวที่เก็บไว้ การผสมใช้ตัวสามตัว ตั้งขอบเขตก่อนเปิด",
    ["Towers"]="หอคอย",["Tower farming"]="ฟาร์มหอคอย",["Tower selection"]="เลือกหอคอย",["Auto Tower"]="ลงหอคอยอัตโนมัติ",
    ["Equip Best Tower Team"]="จัดทีมตีหอคอยดีที่สุด",["Tower timing"]="จังหวะหอคอย",
    ["Uses the actual server battle results and game timing. Only one Tower or Haunted House runs at a time."]="ใช้ผลต่อสู้และเวลาจริงของเกม เปิด Tower หรือ Haunted House ได้ทีละระบบ",
    ["Rebirth and points"]="รีเบิร์ธและแต้ม",["Auto Rebirth"]="รีเบิร์ธอัตโนมัติ",["Stop at rebirth"]="หยุดที่รีเบิร์ธ",
    ["Rebirth resets your cash to zero."]="รีเบิร์ธจะรีเซ็ตเงินสดเป็นศูนย์",["Rebirth stat"]="ค่าสถานะที่ลงแต้ม",
    ["Auto Allocate Rebirth Points"]="ลงแต้มรีเบิร์ธอัตโนมัติ",["Use one reset token"]="ใช้ Reset Token หนึ่งชิ้น",
    ["Rerolls"]="สุ่มค่าสถานะ",["Selected unit"]="ตัวที่เลือก",["Unit selection"]="เลือกตัวจากกระเป๋า",
    ["Reroll request limit"]="จำกัดจำนวนคำขอสุ่ม",["Equip selected unit"]="ถือตัวที่เลือก",["Put unit back"]="เก็บตัวที่ถือ",
    ["Reroll targets"]="เป้าหมายการสุ่ม",["Trait targets"]="Trait ที่ต้องการ",["Grade targets"]="Grade ที่ต้องการ",["Quirk targets"]="Quirk ที่ต้องการ",
    ["Auto Trait"]="สุ่ม Trait อัตโนมัติ",["Auto Grade"]="สุ่ม Grade อัตโนมัติ",["Auto Quirk"]="สุ่ม Quirk อัตโนมัติ",
    ["Game protection"]="การป้องกันค่าของเกม",["Protect Trait"]="Trait ที่ป้องกัน",["Protect Grade"]="Grade ที่ป้องกัน",["Protect Quirk"]="Quirk ที่ป้องกัน",
    ["Apply Trait protection"]="บันทึกการป้องกัน Trait",["Apply Grade protection"]="บันทึกการป้องกัน Grade",["Apply Quirk protection"]="บันทึกการป้องกัน Quirk",
    ["Items and rewards"]="ไอเทมและรางวัล",["Items and gear"]="ไอเทมและอุปกรณ์",["Boosts to use"]="ยาที่อนุญาตให้ใช้",
    ["Spins to use"]="Spin ที่อนุญาตให้ใช้",["Auto Use Selected Boosts"]="ใช้ยาที่เลือกอัตโนมัติ",["Auto Use Selected Spins"]="ใช้ Spin ที่เลือกอัตโนมัติ",
    ["Gear priority"]="เป้าหมายการจัดอุปกรณ์",["Auto Equip Gear"]="จัดอุปกรณ์อัตโนมัติ",["Rewards and codes"]="รางวัลและโค้ด",
    ["Auto Claim Daily / Group / Offline"]="รับรางวัลรายวัน / กลุ่ม / ออฟไลน์",["Auto Claim Completed Quests"]="รับเควสต์ที่ครบอัตโนมัติ",
    ["Quest shop item"]="สินค้าร้านเควสต์",["Quest purchase limit"]="จำนวนซื้อร้านเควสต์สูงสุด",["Tickets reserve"]="Tickets สำรอง",
    ["Auto Buy Quest Shop Item"]="ซื้อสินค้าร้านเควสต์อัตโนมัติ",["Codes (comma separated)"]="รายการโค้ด (คั่นด้วยจุลภาค)",
    ["Auto Redeem Entered Codes"]="แลกโค้ดในรายการอัตโนมัติ",["Halloween"]="ฮาโลวีน",["Auto Pumpkin Dice"]="สุ่ม Pumpkin Dice อัตโนมัติ",
    ["Roll count"]="จำนวนต่อครั้ง",["Pumpkins reserve"]="Pumpkins สำรอง",["Pumpkin units to auto sell"]="ตัว Pumpkin ที่ขายอัตโนมัติ",
    ["Apply Pumpkin sell filter"]="บันทึกตัวกรองขาย Pumpkin",["Haunted wing"]="เลือกโซนบ้านผีสิง",["Auto Haunted House"]="ลงบ้านผีสิงอัตโนมัติ",
    ["Travel to Halloween Island"]="ไปเกาะฮาโลวีน",["Return to Hub"]="กลับเกาะหลัก",["Auto Walk Trick or Treat"]="เดินฟาร์ม Trick or Treat",
    ["Door route"]="เส้นทางประตู",["Walks to currently loaded doors, exits before revisiting and waits for server cooldown. No knock or reward is forged."]="เดินไปประตูที่โหลดอยู่ ออกจากเขตก่อนกลับเข้า และรอคูลดาวน์กับผลจากเกม",
    ["Pass and event quests"]="Pass และเควสต์อีเวนต์",["Auto Claim Pumpkin Pass"]="รับรางวัล Pumpkin Pass อัตโนมัติ",
    ["Auto Claim Halloween Quests"]="รับเควสต์ฮาโลวีนที่ครบ",["Candy shop"]="ร้าน Candy",["Candy shop item"]="สินค้าที่ซื้อด้วย Candy",
    ["Purchase limit"]="จำนวนซื้อสูงสุด",["Candy reserve"]="Candy สำรอง",["Auto Buy Candy Shop Item"]="ซื้อสินค้าด้วย Candy อัตโนมัติ",
    ["Status"]="สถานะ",["Test report"]="รายงานตัวทดสอบ",["Test controls"]="ควบคุมตัวทดสอบ",
    ["Copy / save test report"]="คัดลอก / บันทึกรายงาน",["Use game Auto Roll"]="ใช้ระบบ Auto Roll เดิมของเกม",["Close test"]="ปิดตัวทดสอบ",
    ["Standalone test"]="ตัวทดสอบแยก",["All automation starts off. This test is separate from the main loader. Game rules, balances and inventory updates decide the result."]="ทุกออโต้เริ่มปิด ตัวนี้แยกจาก loader หลัก ผลขึ้นอยู่กับกติกา ยอดคงเหลือ และข้อมูลกระเป๋าจริงของเกม",
    ["Refresh inventory and choices"]="อัปเดตกระเป๋าและตัวเลือก",["Connection failed; copy the test report"]="เชื่อมต่อไม่สำเร็จ กรุณาคัดลอกรายงาน"
}
local localized=setmetatable({},{__mode="k"})
local inverse={};for en,th in pairs(translations)do inverse[th]=en end
local currentLanguage="EN"
local function inspectText(node)
    if node:GetAttribute("DevilLocalizationOverlay")or node:GetAttribute("DevilBlueSettings")then return end
    if not(node:IsA("TextLabel")or node:IsA("TextButton"))or localized[node]then return end
    local record={Writing=false};localized[node]=record
    local function update()
        if record.Writing then return end
        local english=inverse[node.Text]or node.Text
        if not translations[english]then return end
        record.English=english;record.Writing=true
        node.Text=currentLanguage=="TH"and translations[english]or english
        record.Writing=false
    end
    links[#links+1]=node:GetPropertyChangedSignal("Text"):Connect(update)
    update()
end
links[#links+1]=window.Gui.DescendantAdded:Connect(inspectText)
for _,node in ipairs(window.Gui:GetDescendants())do inspectText(node)end
local function refreshLanguage()
    local theme=scope.DevilHubBlueGui
    local language=theme and theme.Get and theme.Get().Language or"EN"
    if language==currentLanguage then return end
    currentLanguage=language
    for node,record in pairs(localized)do
        if node.Parent and record.English then
            record.Writing=true;node.Text=language=="TH"and translations[record.English]or record.English;record.Writing=false
        end
    end
end
