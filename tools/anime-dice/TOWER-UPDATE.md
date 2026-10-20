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
