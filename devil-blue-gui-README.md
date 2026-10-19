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
All menu labels use a brighter blue #68B1FF to white text gradient in both languages.
The effect sits on transparent text overlays so it never colors the button's
background. Native backgrounds keep dark gradients. Text padding, fonts,
alignment, raw values and callbacks remain native. The borderless language button
uses a drawn chevron instead of a Unicode arrow that can appear as a square.

Search and text input surfaces use soft black #181B21, white typed text and
#ACB8C9 placeholder text. Transparent native inputs retain their geometry while
their compact enclosing fields receive the background. Native input gradients
remain neutral so they cannot darken the text. Text and search callbacks stay native.

Dropdown chips, option buttons and popup menus use near-black surfaces (#101319
or darker) with 0.14 background transparency. Background images are tinted dark;
small icons keep white/blue. Dropdowns whose names contain Toggle are not treated
as switches. Switch detection requires a round or named thumb, so a narrow
dropdown's chevron cannot become a switch before the field grows to fit its value.
Native switch tracks still show blue when enabled. Text overlays
reduce native dimming continuously without changing hidden text or raw values;
text outlines are neutral dark rather than blue. Input backgrounds also use 0.14
transparency. Native transparent layout wrappers remain transparent.

The original main window is cached across minimize/restore transitions; temporary
ghost frames and the Island mini bar never become its replacement. The theme no
longer creates or writes UIScale objects. Scale-only animation changes and
presentation-owned descendants do not schedule layout reconstruction. Native
window size and sidebar changes still update the language row. Property writes
use a reentrancy guard and retain Roblox's stored values to avoid rounding feedback.

Full-screen input planes, dimmers and backdrop gradients retain native colors
and transparency. They are excluded from menu-card styling and main-window
discovery. Break and Steal an Egg's bridge reparents Obsidian AddDialog overlays
(full-size TextButtons at ZIndex 9000) to the OuroFlow ScreenGui. These overlays
now follow the primary window's visibility while preserving their controller's
original state. Minimizing hides an open dialog's overlay; restoring returns it
only if the native dialog still exists. Closing/destroying it stays native.

The previous menu policy changed these native 0.5/0.95 transparency layers to
0.14, and their separate parent let them cover the game after minimize. Both
failures reproduce against release 30b809e; the new fixture verifies the fix.
This reproduces the report's mechanism without establishing the exact layer on
the reporting user's live session.

Read-only diagnostics for another report (no input text or credentials collected):

```lua
local report = getgenv().DevilHubBlueGui.InspectLayers()
print(game:GetService("HttpService"):JSONEncode(report))
```

The report lists main windows and screen-covering layers, including names,
parents, dimensions, native/applied opacity and main-window visibility.

165 offline UI checks include eight cycles of the library's original Minimize /
Restore functions with simulated animation timing, plus integrity, callback and
routing checks. A regression replay confirms that the previous release adopts
the temporary animation frame. Live
Roblox/Delta rendering across every game still requires validation.
