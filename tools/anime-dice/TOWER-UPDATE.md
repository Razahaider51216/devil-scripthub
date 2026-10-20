Anime Dice Tower selectors use the live `Towers.GetAll()` metadata:

- Native tower artwork, difficulty name and maximum floor count.
- Native progression order, including Infinity after the finite towers.
- Haunted House wing artwork and global floor ranges; endless wings retain their starting floor.
- English/Thai metadata labels, preserving original tower names as saved/gameplay keys.
- Missing artwork/data produces an explicit fallback. Enemy models are not cloned for menu previews.
- Silent refresh retains selection and does not start a Tower or send gameplay requests.

The captured catalog contains Dragon/Easy, Cursed/Medium, Pirate/Hard,
Hidden Leaf/Extreme, Slayer/Nightmare, Shadow/Abyssal and Infinity.
Finite normal towers have 100 floors except Shadow (150). The live catalog is
used at runtime so these values are not hardcoded into the selector.

Validation uses the complete public entry, image/difficulty/floor rendering,
native ordering, stable selection, late metadata, fallback art, both languages,
and existing automation/settings regressions. Offline checks do not establish
asset visibility or gameplay compatibility on a live Roblox executor.

The Pumpkin units to auto sell selector now shows registry artwork, or a static
preview built from the unit's native `model({})` factory when no image exists.
Power comes from `PumpkinDice.Units`; rarity comes from the registry. Multi-select
and Apply keep the original unit IDs and deselection states.

Model previews are lazy: at most one is created per UI tick and six remain alive
for visible rows. Closing/hiding the popup or unloading destroys the clones.
Preview clones have scripts/effects removed and parts anchored without collision.
No animation/frame connection is created. Missing model errors use a fallback and
an eight-second retry interval instead of repeatedly cloning every frame.

Haunted wing also reads event entries from the Tower catalog when the separate
HauntedHouse module is unavailable. Partial artwork/floor data is merged into
presentation copies, preserving the live game configuration.
