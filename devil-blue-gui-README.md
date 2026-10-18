# DEVIL HUB: translucent black, soft blue, white

All ten supported games use a fixed presentation: near-black #07090D with slight
background transparency, subtly blue framed controls, soft-blue #A4DDFF accents,
and white/blue text. The open/minimize launcher uses solid black behind a white
DEVIL logo. Pet/item images, input values and game callbacks remain original.

There is no GUI / Colors button, floating settings window, color picker or shared
size panel. Language selection has its own 32px row above the sidebar navigation,
with 8px spacing. The old DevilLanguageButton beside minimize is hidden, leaving
one shared language menu in each window. Its callbacks and original visibility
are restored on unload. The navigation viewport reserves space and keeps its lower
edge above the original profile footer. Libraries without a sidebar reserve a
header row. Native resizing is preserved; unload restores the original geometry.
Click EN or Thai to select English / Thai. Language is saved locally in
DevilHub-BlueGUI.json. Old color/size preferences are ignored.

Enabled switches use #A4DDFF tracks with white thumbs; disabled tracks use neutral
#202731. Unnamed desktop/mobile switches follow their native thumb position.
Control icons, icon gradients, frame glyphs and hover redraws use white/blue,
including unnamed library icons. Named inventory, pet/item images, avatars and
thumbnail images keep their source colors. Composite open buttons keep a solid
black background and white DEVIL logo.

The 583-entry English/Thai dictionary handles common menus and features. Unknown
wording stays original. Inert translation labels preserve the engine's raw Text
values and callbacks. TextBox input is not translated. Native search still uses
original engine identifiers. Internal list/grid text containers are left intact.

Ownership is determined by the DEVIL title, explicit presentation attribute or
recognized brand image. Arbitrary game HUDs and game logos stay unchanged.
Updates use property/descendant events, not whole-GUI frame polling. No request,
compiler, getfenv/setfenv or game automation function is replaced.

The main loader and all ten game entries install the same immutable, checksummed
presentation module. Download failure leaves the original game entry usable.
All menu labels use a blue #4697FF to white text gradient in both languages.
The effect sits on transparent text overlays so it never colors the button's
background. Native backgrounds keep dark gradients. Text padding, fonts,
alignment, raw values and callbacks remain native. The borderless language button
uses a drawn chevron instead of a Unicode arrow that can appear as a square.

78 offline UI checks plus integrity, callback-preservation and routing checks pass. Live
Roblox/Delta rendering across every game still requires validation.
