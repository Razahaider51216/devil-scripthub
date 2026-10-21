-- Reuse the single language menu provided by the shared DEVIL HUB presentation.
local translations={
    ["Webhook"]="เว็บฮุก",["DEVIL HUB Webhook"]="เว็บฮุก DEVIL HUB",["Enable Webhook"]="เปิดเว็บฮุก",
    ["Discord webhook URL"]="ลิงก์เว็บฮุก Discord",["Embed information"]="ข้อมูลที่แสดงใน Embed",
    ["Notify rarities (empty = all)"]="ระดับที่แจ้งเตือน (ว่าง = ทั้งหมด)",["Earnings interval (seconds)"]="รอบแจ้งเงิน (วินาที)",
    ["Character images"]="รูปตัวละคร",["Character name (exact)"]="ชื่อตัวละคร (ตรงกับเกม)",
    ["Character image HTTPS URL"]="ลิงก์รูปตัวละคร HTTPS",["Save character image"]="บันทึกรูปตัวละคร",
    ["Public images"]="รูปภาพสาธารณะ",["Money gained"]="เงินที่ได้รับ",
    ["Settings"]="ตั้งค่า",["Saved settings"]="ค่าที่บันทึก",["Restore settings"]="คืนค่าตั้งค่า",
    ["Save Settings"]="บันทึกตั้งค่า",["Load Saved Settings"]="โหลดตั้งค่าที่บันทึก",["Reset Saved Settings"]="รีเซ็ตตั้งค่าที่บันทึก",
    ["Save filters, item choices and enabled automation. Saved settings load automatically next run."]="บันทึกฟิลเตอร์ รายการที่เลือก และออโต้ที่เปิดไว้ รันครั้งถัดไปจะโหลดค่าเดิมอัตโนมัติ",
    ["Automation starts off without a saved profile. Saved settings restore after game data is ready."]="หากยังไม่มีค่าที่บันทึก ออโต้จะเริ่มปิดไว้ หากบันทึกแล้วจะโหลดค่าเดิมเมื่อข้อมูลเกมพร้อม",
    ["No saved settings loaded yet."]="ยังไม่ได้โหลดค่าที่บันทึก",["No saved settings found."]="ยังไม่มีค่าที่บันทึก",
    ["Settings saved. They will load next run."]="บันทึกตั้งค่าแล้ว รันครั้งถัดไปจะโหลดให้อัตโนมัติ",
    ["Saved settings loaded."]="โหลดตั้งค่าที่บันทึกแล้ว",["Saved settings reset."]="รีเซ็ตตั้งค่าที่บันทึกแล้ว",
    ["Waiting for player identity."]="กำลังรอข้อมูลผู้เล่น",["Waiting for game data."]="กำลังรอข้อมูลเกม",
    ["Saving unavailable on this executor."]="ตัวรันนี้ไม่รองรับการบันทึกไฟล์",["Loading unavailable on this executor."]="ตัวรันนี้ไม่รองรับการอ่านไฟล์",
    ["Settings could not be saved."]="บันทึกตั้งค่าไม่สำเร็จ",["Settings could not be applied."]="นำค่าที่บันทึกมาใช้ไม่สำเร็จ",
    ["Saved settings could not be read."]="อ่านไฟล์ตั้งค่าไม่สำเร็จ",
    ["DEVIL HUB Community"]="ชุมชน DEVIL HUB",
    ["Join our Discord"]="เข้าร่วม Discord ของเรา",
    ["Updates, announcements and community support."]="อัปเดต ประกาศ และความช่วยเหลือจากชุมชน",
    ["Invite ready to copy."]="พร้อมคัดลอกลิงก์เชิญ",
    ["Copy Discord Invite"]="คัดลอกลิงก์ Discord",
    ["Discord invite copied!"]="คัดลอกลิงก์ Discord แล้ว!",
    ["Clipboard unavailable. Select and copy the invite above."]="คัดลอกอัตโนมัติไม่ได้ เลือกและคัดลอกลิงก์ด้านบน",
    ["Stay connected"]="ติดตามข่าวสาร",
    ["Updates and announcements"]="อัปเดตและประกาศ",
    ["New releases, supported games and DEVIL HUB news."]="เวอร์ชันใหม่ เกมที่รองรับ และข่าวสาร DEVIL HUB",
    ["Support and feedback"]="ช่วยเหลือและเสนอแนะ",
    ["Report bugs, share suggestions and connect with the community."]="แจ้งบั๊ก เสนอแนะ และพูดคุยกับชุมชน",
    ["Anime Dice"]="Anime Dice",
    ["All automation starts off. Launch directly or through the DEVIL HUB main loader. Game rules, balances and inventory updates decide the result."]="ออโต้ทุกระบบเริ่มปิด ใช้ได้โดยตรงหรือผ่าน loader หลัก DEVIL HUB ผลขึ้นกับกติกา ยอดคงเหลือ และกระเป๋าในเกม",
    ["Rarities to sell (empty = all)"]="ระดับที่ต้องการขาย (ไม่เลือก = ขายทั้งหมด)",
    ["Select rarities to sell only those tiers. Clear every selection to Sell All Unused."]="เลือกขายได้หลายระดับ หากไม่เลือกเลยจะขายตัวที่ไม่ได้ใช้ทั้งหมด",
    ["Teleports to ground at each event door and waits for server travel limits, cooldown and confirmed rewards."]="วาร์ปลงพื้นหน้าประตูอีเวนต์ รอเวลาระหว่างประตู คูลดาวน์ และยืนยันรางวัลจากเกม",
    ["Auto Sell All Unused Units"]="ขายตัวที่ไม่ได้ใช้ทั้งหมดอัตโนมัติ",["Sell All Unused"]="ขายตัวที่ไม่ได้ใช้ทั้งหมด",
    ["Sell All Unused: waiting for live inventory."]="ขายตัวที่ไม่ได้ใช้ทั้งหมด: กำลังโหลดกระเป๋า",
    ["Sells all unused units, including rare and mutated units. Keeps plotted, Tower team, carried, locked, favorite and explicitly kept units."]="ขายตัวที่ไม่ได้ใช้ทั้งหมด รวมตัวหายากและ Mutation เว้นตัวในฐาน ทีม Tower ตัวที่ถือ ตัวล็อก รายการโปรด และตัวที่เลือกเก็บไว้",
    ["Keep best units for fusion"]="เก็บตัวดีที่สุดไว้จากการผสม",["Keep copies per character for fusion"]="จำนวนต่อชื่อที่เก็บจากการผสม",
    ["Keep mutated / variant units for fusion"]="ไม่ใช้ตัว Mutation / Variant ผสม",
    ["Auto Trick or Treat"]="เก็บ Trick or Treat อัตโนมัติ",
    ["Start Event Collection"]="เริ่มเก็บอีเวนต์",["Stop Event Collection"]="หยุดเก็บอีเวนต์",



    ["Farm"]="ฟาร์ม",["Farm controls"]="ระบบฟาร์ม",["Auto Roll"]="สุ่มลูกเต๋าอัตโนมัติ",
    ["Auto Collect Money"]="เก็บเงินฐานอัตโนมัติ",["Auto Equip Best Base"]="จัดตัวหาเงินดีที่สุด",
    ["Auto Level Units"]="อัปเลเวลตัวในฐาน",["Maximum unit level"]="เลเวลตัวสูงสุด",
    ["Dice and upgrades"]="ลูกเต๋าและอัปเกรด",["Auto Buy / Equip Dice"]="ซื้อและใส่ลูกเต๋าอัตโนมัติ",
    ["Dice selection"]="เลือกลูกเต๋า",["Auto Upgrade Tree"]="ซื้อโหนดอัปเกรดอัตโนมัติ",
    ["Upgrade branch"]="สายอัปเกรด",["Money reserve"]="เงินสำรอง",["Live status"]="สถานะปัจจุบัน",
    ["Connecting game modules..."]="กำลังเชื่อมต่อข้อมูลเกม...",["All automation starts off."]="ออโต้ทุกระบบเริ่มปิดไว้",
    ["Stop all automation"]="หยุดออโต้ทั้งหมด",["Inventory"]="กระเป๋า",["Sell and protect"]="ขายและเก็บตัว",


    ["Keep character names"]="ชื่อตัวที่เก็บไว้",
    ["Keep specific units"]="เลือกตัวที่เก็บไว้",
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
    ["Travel to Halloween Island"]="ไปเกาะฮาโลวีน",["Return to Hub"]="กลับเกาะหลัก",
    ["Door route"]="เส้นทางประตู",
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
