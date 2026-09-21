# Overcharge Reimagined v3.1

This is an UE4SS mod for Expedition 33 that overhauls Gustave as a character and allows all of his skills to interact with his Overcharge mechanic.
Does NOT interfere with Verso's gameplay like other mods do.
The ability receive new names, descriptions, elemental damage types, new effects and more!

The mod is written in LUA and simply adds our own modifications to the game's runtime functions as an addition to existing mechanics rather than replacing them.

Being a simple UE4SS script mod has the advantage that it is less prone to break in future updates, should the game receive any more.

### INSTALLATION:

Download the latest release version [here](https://github.com/AmethystTower/OverchargeReimagined/releases).

## Customization Options

The mod adds a lot of customization options via its config.lua file:

- [x] Charge generation amount
- [x] Charge generation events
- [x] Ability AP Cost
- [x] Charge Consumption per Ability
- [x] Damage per Charge
- [x] Elemental Damage Type
- [x] Ability Name
- [x] Unique Settings per Ability

## Features

- [x] All settings are configurable through the config.lua file
- [x] Maximum charges setting that lets you decide how many charges Gustave can hold
- [x] Different charge generation settings that let you decide when to gain or lose charges
- [x] Ability settings that let you decide how much AP an ability should cost or how much charges it should consume/generate and more!
- [x] Reworks for some abilities like Shatter to be a viable alternative to Overcharge
- [x] The cut versions of Light Holder and Radiant Strike in Gustave's skill tree are fully utilized
- [x] Additions feel natural: Ability names glow in orange when their optimal conditions are met
- [x] Ability descriptions during battle display the actual charge counter for each ability that can consume them
- [x] Runtime hooking (doesn't replace game files and should be compatible with most other mods and possible future game updates

The mod adds the following customization options to the Overcharge charge generation mechanic:

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
  - Do you want to turn Gustave into a pure fire wizard, ice mage, god of thunder or weapon master? Also possible!
You can do all of that and more!

## Donate

If you like my work, feel free to contribute!

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=573NC92F7RVCS)
