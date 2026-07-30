# Overcharge Reimagined v1.0

This is an UE4SS mod for Expedition 33 that expands upon the Overcharge mechanic and adds a lot of customization options to the power.

The mod is written in LUA and simply adds our own modifications to the game's runtime functions as an addition to existing mechanics rather than replacing them.

Being a simple UE4SS script mod has the advantage that it is less prone to break in future updates, should the game receive any more.

### INSTALLATION:

Requires UE4SS to be installed in your game folder: https://github.com/UE4SS-RE/RE-UE4SS

Then simply download and put the mod's folder into this path: `Expedition 33\Sandfall\Binaries\Win64\ue4ss\Mods\OverchargeReimagined`
 - The mod will load automatically thanks to the `enabled.txt` file included in the folder.
 - If you want to customize the mod, you can find the `config.lua` file in the folder: `OverchargeReimagined\Scripts`

## Features

- [x] Supports custom maximum charge count
- [x] Fully configurable through `config.lua`
- [x] Custom charge generation per event
- [x] Critical hit support
- [x] Free Aim support
- [x] Lumina damage support
- [x] Passive charge generation
- [x] Negative charge generation (lose charges)
- [x] Shatter fully sets charges to max no matter what limit was set
- [x] Runtime hooking (doesn't replace game files and is designed to be compatible with other mods)
- [x] Open source

## Customization Options

The mod adds the following customization options to the Overcharge mechanic via its config.lua file:

| Mechanic | Name in Config | Description | Default Value | Part of Vanilla |
|-------------|------------|-----------------------------------------------------------------|------|:------:|
| Maximum Charges | VirtualMaxCharges | Set Overcharge to any maximum value above 0. | 100 | ❌ |
| Dodges | ChargesOnDodge | Configure charge gain/loss on successful dodge. | 1 | ✅ |
| Parries | ChargesOnParry | Configure charge gain/loss on successful parry. | 1 | ✅ |
| Base Attacks | ChargesOnBaseAttacks | Configure charge gain/loss on base attack hits. | 1 | ✅ |
| Ability Damage | ChargesFromSkillDamage | Configure charge gain/loss on ability hits. | 1 | ✅ |
| Counter Attacks | ChargesOnCounterAttacks | Configure charge gain/loss on normal counter attacks. | 1 | ✅ |
| Gradient Counter Attacks | ChargesOnGradientCounter | Configure charge gain/loss on gradient counter attacks. | 1 | ✅ |
| Jump Counter | ChargesOnJumpCounter | Configure charge gain/loss on jump counters. | 1 | ✅ |
| Starting Charges | StartingCharges | Configure starting charge amount when battle begins or when freed after being eaten. | 0 | ❌ |
| Charges Per Turn | ChargesPerTurn | Configure charge amount that is given/taken passively per turn. | 0 | ❌ |
| Lumina Damage | ChargesOnLuminaDamage | Configure charge gain/loss on base attack hits. Supports Simoso's Ethereal Sword passive. | 0 | ❌ |
| Free Aim | ChargesOnFreeAim | Configure charge gain/loss per free aim shot. | 0 | ❌ |
| Buff Damage | ChargesOnBuffDamage | Configure charge gain/loss from burn and similar effects | 0 | ❌ |
| Critical Hits | ChargesOnCritical | Configure charge gain/loss from critical hits. Independent from Lumiere Assault and Strike Storm. | 0 | ❌ |
| Hit Taken | ChargesOnReceivedHit | Configure charge gain/loss when hit by an enemy. | 0 | ❌ |
| Free Aim Critical Hits | FreeAimAffectedByCriticals | Enable charge gain/loss from critical hits for free aim shots. | 0 | ❌ |

## Possible templates and variants

### With this mod you can configure the Overcharge mechanic into any playstyle you want.
  - Want to generate or remove charges passively per battle start and per turn separately? You can do that!
  - Do you want Overcharge to work like Perfection and gain charges on "Free Aim" hits but also lose charges when you get hit? You can do that!
  - Want to punish dodges by removing charges but gain more charges per parry to make it require more skill? You can do that!
  - Want to get bonus charges for any critical hits and not just from Lumiere Assault or Strike Storm? You can do that!
  - Do you want Simoso's "ethereal sword" double hit effect to generate charges? You can do that as well!
  - Do you want 100 charges to feel like you're playing with only 10 charges but keep the same damage? Very possible!
  - Want buff effects like "Burn" to generate charges? Also possible!
You can do all of that and more!

## Notes

Since this is a LUA script mod the in-game charge counter will still show 10 max charges because the in-game counter only displays the rounded-down vanilla charge values.

For example, an actual charge count of 30–39 will appear as 3 charges in-game.\
If you have 39 charges and use the ability, you will still do the full damage of 39 charges!

### Example table of the in-game vs. the actual Overcharge counter:

| In-Game Charges | Actual Charges |
|------------|------------|
| 0 | 0 - 9 |
| 1 | 10 - 19 |
| 2 | 20 - 29 |
| 3 | 30 - 39 |
| 4 | 40 - 49 |
| 5 | 50 - 59 |
| 6 | 60 - 69 |
| 7 | 70 - 79 |
| 8 | 80 - 89 |
| 9 | 90 - 99 |
| 10 | 100 |

## Donate

If you like my work, feel free to contribute!

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=573NC92F7RVCS)