Break and Steal an Egg has a native language renderer with its own
`DevilBreakLanguage` selection and `DevilBreakSettings.SetLanguage` API. The shared
English/Thai menu previously updated only the shared renderer. The native renderer
kept writing Thai into source labels and the text overlays, including phrases
absent from the shared reverse dictionary. Choosing English could therefore leave
Thai text visible while the shared selector displayed English.

`break-language.lua` connects the two presentation APIs only for universe
10765288803 / place 114326934417838. A menu selection renders native text first,
then refreshes the shared overlays. Native saved-language restoration also updates
the shared selection and its preference file. The adapter handles a native API
registered after the window appears and restores its presentation adapters on
teardown. Game automation, action callbacks, remotes, theme colors and other game
routes are preserved. Steal an Egg retains the user's pre-Steal-Panel rollback.

Run `python tools/blue-gui/test-break-language.py`. It uses the actual existing
native language controller captured in `tests/fixtures/break-native-language.lua`
with the complete shared module. It reproduces the old English/Thai disagreement,
then checks the actual dropdown, repeated switches, dynamic and late labels,
search text, native settings restoration, saved preferences, late API setup,
callback preservation, teardown and wrong-map rejection. Roblox rendering on a
live executor remains unverified.

Build the two Break entry preludes with
`python tools/blue-gui/build-break-language.py entries`, commit those artifacts,
then run `python tools/blue-gui/build-break-language.py router ENTRY_COMMIT`.
The entry builder preserves each existing compiled engine body byte-for-byte.
Only the Break main-loader pin/version changes; the shared module pin and all
other game route definitions are asserted unchanged.
