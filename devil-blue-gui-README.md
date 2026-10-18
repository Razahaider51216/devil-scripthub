# DEVIL HUB blue GUI

The shared theme is installed by the main loader and the ten supported game
entries: Mine / Dump23, Tap Simulator 2, Climb for Eggs, Lift Rock for Eggs,
Ride A Fish, Steal an Egg, Ride a Pet, Break and Steal an Egg, Loot to Forge
and Build An Ant Empire. Direct GUI/runtime aliases are covered too.

Default palette: dark blue `#071B34`, light blue `#75CEFF`, white `#F7FCFF`.
Navigation, controls, borders and scrollbars use blue. Text uses white/light
blue; existing title gradients use both. Recognized brand logos have a white
tint. Pet/item images and thumbnails keep their original images and colors.

Use the **GUI / Colors** button in the bottom-right corner to set accent and
background hex colors, adjust GUI scale from 60–140%, or restore defaults.
The **Language / ภาษา** select menu offers English and ไทย. Selection updates
translated labels immediately and is remembered across games and sessions.
Preferences are stored locally in `DevilHub-BlueGUI.json` and shared by all games.
The Steal an Egg Settings shortcut opens this same panel.

The current English/Thai dictionary has 583 UI entries, including common menus
and features for all ten games. Dynamic labels are updated when the game changes
them. Unknown wording remains as supplied by the game. Translation uses inert
rendering overlays: original Text values, option identifiers and callbacks remain
unchanged. User input in TextBoxes and webhook addresses are never translated.
Search placeholders are translated; native feature search continues to use the
engine's original text/identifiers. Native layouts containing an internal list/grid
are left alone rather than inserting translation overlays into their layout.

Only DEVIL HUB-owned ScreenGuis are styled. Ownership is established by the
explicit presentation attribute, a DevilHub screen name, or the exact product
title. Existing game HUDs are not themed. Later controls/native redraws are
handled through property/descendant events, with no whole-GUI frame polling.
Native responsive UIScale is composed with the saved user scale and restored
on controller removal. Destroying the controller restores captured properties.

The presentation module does not change gameplay callbacks, remotes, request
functions, getfenv/setfenv or loadstring. The release entry prefix fetches an
immutable module pin and checks its byte count/checksum before compiling it.
If presentation download fails, the original game entry can still launch.

Offline validation covers ownership, redraws, late controls, image identity,
callback identity, form validation, persistence, responsive scaling and cleanup.
Official Luau compilation checks each changed entry. All ten router mappings
are exercised with inert downloaded modules; no game engine or live server
actions run during these tests. Live rendering in each Roblox/executor
combination still requires validation.
