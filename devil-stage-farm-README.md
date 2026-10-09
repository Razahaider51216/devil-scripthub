# DEVIL Stage Farm

ไฟล์หลัก: `devil-stage-farm.lua` — ไม่มีระบบ key; ใช้ OuroFlow revision `c8251f76f74d9942114ebccb0564aa0ac196320a` และธีม Crimson ชุดเดียวกับ GUI ตัวหลักใน Git
รองรับเฉพาะ Place ID `120731410233153` ตามดัมป์ที่ให้มา ไม่ใช่ Anime Zero จากงานก่อน

## สิ่งที่สร้าง

- เลือก World 1–4, โซนย่อยตามชื่อในแมพ และ Stage 1–63
- ฟาร์มด่านเดิม หรือวนช่วง Stage ภายใน World / โซนที่เลือก
- ย้ายไป Floor ของ Stage, รอเวลาต่อสู้ที่ปรับได้ แล้วไป normal WinPad
- นับการเพิ่มของ `leaderstats.Wins`; หยุดหลังเก็บไม่สำเร็จ 3 รอบ
- รอเกิดใหม่แล้วทำต่อได้; เปลี่ยนเป้าหมายจะหยุดให้เริ่มรอบใหม่
- Travel World ผ่านปุ่มเดิมของเกม, Go to Stage และ Rescan / Follow my area
- Auto Attack / Equip Tool และตามมอนที่อยู่ภายใน Floor ของ Stage ที่เลือก
- Combat training preset เปิด Tool attack ทุก 0.1 วินาที และเร่ง learned Train เมื่อมี recipe
- แสดง Strength จริงจาก leaderstats; Record combat messages บันทึกข้อความจาก Arena/Remotos แยก incoming/outgoing แล้ว Copy combat report
- Learn actions เพื่อจำ arguments ที่เกมส่งจริง แล้วใช้ Auto Train, Daily Reward, Timed Gifts, Quest Action, Rebirth, Boss Action, Hatch และ Offline Claim
- ปรับช่วงเวลาของแต่ละออโต้, บันทึกการตั้งค่า, GUI แบบตัวหลักพร้อมแท็บ Farm/Combat/Auto/Settings และปุ่มโลโก้ลอยสำหรับซ่อน/แสดง และ STOP ALL

## วิธีเริ่ม

1. ใช้เนื้อหา `devil-stage-farm.lua` ใน Roblox client environment ที่คุณใช้อยู่
2. เข้า World ที่ปลดล็อกแล้ว ใช้ Travel World หรือเมนู World ของเกม
3. กด Rescan / Follow my area เพื่อเลือกบริเวณที่โหลดจริง แล้วเลือกโซนกับ Stage
4. ตั้ง Fight time ให้พอกับการผ่านด่าน แล้วกด Start Farm
5. สำหรับออโต้เสริม: กด Learn actions ON, กดปุ่มของเกมจริงหนึ่งครั้ง เช่น Train / รับรางวัล / Rebirth, จากนั้นปิด Learn แล้วเปิดออโต้ที่มีรายการ learned

## ตรวจดาเมจ

ยังไม่มี one-hit หรือ damage bypass ที่ยืนยันว่าใช้งานได้ ดัมป์ไม่มีสูตรดาเมจและโค้ดตรวจฝั่งเซิร์ฟเวอร์
Tool attack เรียกการโจมตีปกติของ Tool; damage และ cooldown ยังถูกกำหนดโดยเกม
ตามมอนใช้เฉพาะ `_MobsLocal` และตรวจ bounds ของ Floor ที่เลือก ไม่ตามผู้เล่นหรือมอนข้ามด่าน
ถ้าเกมไม่มี Tool ให้ใช้ learned Train สำหรับ action ที่จับได้; ชื่อ Auto Attack ไม่ได้แปลว่ารับประกันทุกระบบ combat ของเกม

เปิด Combat → Record combat messages, เล่นด่านและตีมอนตามปกติหนึ่งรอบ แล้วกด Copy combat report
รายงานเก็บเฉพาะ 30 ข้อความล่าสุดและตัดความลึก/ความยาวของข้อมูล ไม่แก้ไขคำสั่งเดิม
ส่งข้อความรายงานนี้เพื่อวิเคราะห์ contract ของ combat ต่อได้ แต่ตัวรายงานเองไม่ข้ามการตรวจของเซิร์ฟเวอร์
ระบบบันทึกขาออกต้องใช้ namecall hook และเห็นเฉพาะคำสั่งที่ผ่าน namecall; ขาเข้าใช้ OnClientEvent ของ remotes ที่พบตอนเริ่ม

Rebirth รีเซ็ตความคืบหน้าและ Hatch ใช้เงินในเกมตามคำสั่งที่คุณกดไว้ ทุกออโต้เริ่มปิดเมื่อรันไฟล์ใหม่
ไม่มีการทำ Auto ซื้อ Robux, ลบ pets, ปลดล็อก World หรือส่ง Admin remote
ถ้า Learned ยังเป็น 0 จะเปิดออโต้ประเภทนั้นไม่ได้ ต้องใช้ปุ่มเกมจริงเพื่อเรียนรู้ก่อน
ปุ่ม STOP ALL หยุดการส่งครั้งต่อไป; คำขอที่ส่งไปแล้วเรียกคืนไม่ได้

## ข้อจำกัดที่ตรวจพบ

ดัมป์มี 4 World และ 63 Stage แต่ geometry ถูก Streaming: มี Floor ที่เห็นจริงเพียง Stage 34–38 และ normal WinPad เพียง Stage 34–37
ตำแหน่งที่เหลือไม่ได้เดาขึ้นมา เมื่อเข้า World และแมพโหลดแล้ว สคริปต์จะใช้ Instance จริงที่หาได้ ถ้ายังหาไม่พบจะหยุดพร้อมข้อความ
World 5 มีปุ่มใน GUI แต่ไม่มีโครงสร้าง Stage ในดัมป์ จึงยังไม่เพิ่มรายการ World 5

ไฟล์สคริปต์ในดัมป์รายงาน `decompilation panicked` จึงไม่ทราบ signature ของ remote
Learn actions ใช้ namecall observer เฉพาะรายการ remote ที่กำหนด ไม่เปลี่ยน arguments หรือผลลัพธ์ของคำสั่งเดิม
รองรับเฉพาะคำสั่งที่ผ่าน namecall; environment ที่ไม่มี hookmetamethod/getnamecallmethod จะใช้ Learn ไม่ได้ แต่ UI/Stage movement/Tool auto ยังทำงานได้
Recipes อยู่ในหน่วยความจำเฉพาะ session; บันทึกลงไฟล์เฉพาะค่าตั้งต้น ไม่บันทึกคำสั่งที่จับได้
การส่งคำสั่งได้ไม่ใช่หลักฐานว่าเซิร์ฟเวอร์อนุมัติรางวัล และค่ารับส่งที่ใช้ครั้งเดียวอาจต้องเรียนรู้ใหม่
Auto Quest/Boss คือการทำซ้ำ action ที่คุณกดไว้ ไม่ใช่ระบบเดาลำดับเควสต์หรือ AI ต่อสู้บอส
ตัวฟาร์มใช้การย้ายไป Floor และ WinPad จริง; การผ่านด่านยังขึ้นกับ combat, strength และเงื่อนไขของเกม
Wins ที่เพิ่มเป็นผลสังเกตหลังไป WinPad; หากมีรางวัลอื่นเพิ่มพร้อมกัน อาจนับร่วมด้วย

## การตรวจ

- Luau compile ผ่านทั้งไฟล์รวม
- Core checks ผ่าน 28 ข้อ: World/Stage boundaries, route filtering, ไม่มี World/geometry ที่แต่งขึ้น, argument snapshot, nil/false, signature, numeric validation และ cooldown/concurrent invoke guard
- Frontend integration checks ผ่าน 18 ข้อ: GUI branding/theme/pin, initial values, World/Stage switching, learned-auto guard, STOP ALL, silent sync และ unload
- Combat/report checks ผ่าน 12 ข้อ: เลือกมอนมีชีวิตในด่าน, bounds, missing geometry และรูปแบบรายงาน
- ยังไม่ได้ทดสอบในเกมจริง จึงยังยืนยันผลการฟาร์มหรือการรับรางวัลฝั่งเซิร์ฟเวอร์ไม่ได้

## สร้างใหม่

`python build_catalog.py` อ่านดัมป์เดิมและสร้าง catalog
`python build.py` รวม core, catalog และ runtime เป็นไฟล์ standalone
`luau test-core.luau` ตรวจ logic ที่ไม่ต้องใช้ Roblox
