
--[[
------- Overcharge Reimagined - By Killera -------

        Config made by branbutnexus.

        This config is balanced around having 10 max charges for Overcharge.
        All abilities are balanced around 10 charges so they receive +0.33 damage multiplier per charge rather than +0.2.
        Overcharge and Shatter received the strongest buffs: They gain +3.33 damage multiplier per charge.
        Phantom Stars, Overcharge and Shatter all refund 33% of max charges upon a break.
        The AP cost of Overcharge, From Fire, Radiant Strike and Light Holder were modified back to their vanilla costs.
        Powerful costs 5 AP instead of 4.

        PS:
        I do NOT recommend modifying the settings for the Berserk buff at the bottom of this file.
        Unless you want to see a gigantic or tiny Gustave for a laugh, leave them default for proper gameplay!
]]--

return
{
    ------------------------------------------------------------------------
    -- Charge limit.
    ------------------------------------------------------------------------

    -- Maximum charges that Overcharge can carry. Default: 100 / Default in Vanilla: 10
    -- This also increases the maximum damage done by Overcharge for each additional charge it can hold.
    -- NOTE: DO NOT SET THIS TO A NEGATIVE VALUE OR 0, otherwise your character will be unable to generate any charges!
    VirtualMaxCharges = 10,

    ------------------------------------------------------------------------
    -- Charge generation settings below.

    -- IMPORTANT NOTE: ALL SETTINGS ACCEPT BOTH POSITIVE AND NEGATIVE VALUES.
    -- This means that depending on the settings, they can ADD OR REMOVE charges.
    -- For example: If 'ChargesOnReceivedHit' is -5, then your character loses 5 charges when getting hit by an enemy.
    -- However, the settings DO NOT accept decimal values (e.g. 1.75, 2.25, 3.5 etc.) - this will break charge generation.
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- DEFAULT EVENTS: These are the events that already generate charges in the base game.
    ------------------------------------------------------------------------

    -- Charges on successful dodge. Default: 1
    ChargesOnDodge = 1,

    -- Charges on successful parry. Default: 1
    ChargesOnParry = 1,

    -- Charges per base attack hit. Default: 1
    ChargesOnBaseAttacks = 1,

    -- Charges per hit from abilities. Default: 1
    ChargesFromSkillDamage = 1,

    -- Charges on a normal counter attack. Default: 1
    ChargesOnCounterAttacks = 1,

    -- Charges on a gradient counter attack. Default: 1
    ChargesOnGradientCounter = 1,

    -- Charges per jump counter. Default: 1
    ChargesOnJumpCounter = 1,

    ------------------------------------------------------------------------
    -- CUSTOM EVENTS: These are events that do NOT generate charges in the base game.
    ------------------------------------------------------------------------

    -- Charges added when a battle starts. Default: 0
    -- Also triggers again when our character was eaten and freed by an enemy during battle.
    StartingCharges = 0,

    -- Charges added per character's turn. Default: 0
    -- NOTE: This does NOT affect the character's very first turn.
    ChargesPerTurn = 0,

    -- Charges per hit from lumina effects. Default: 0
    -- NOTE: This affects additional hits from Simoso's ethereal sword passive.
    ChargesOnLuminaDamage = 0,

    -- Charges per free aim shot. Default: 0
    ChargesOnFreeAim = 0,

    -- Charges per damage event from buffs (e.g. burn). Default: 0
    ChargesOnBuffDamage = 0,

    -- Charges per critical hit. Default: 0
    -- NOTE: This does NOT affect free aim shots by default and is independent from abilities that generate bonus charges on criticals as their feature.
    ChargesOnCritical = 0,

    -- Charges when taking a hit from an enemy. Default: 0
    -- NOTE: Taking hits with shields doesn't prevent this event, similar to the perfection mechanic.
    ChargesOnReceivedHit = 0,

    -- This allows free aim shots to generate charges from critical hits using the 'ChargesOnCritical' value setting. Default: false
    -- NOTE: This is independent from the 'ChargesOnFreeAim' setting.
    -- VALUES: true = enabled, false = disabled.
    FreeAimAffectedByCriticals = false,

    ------------------------------------------------------------------------
    -- ABILITIES: These are the settings that define all abilities in regards of: AP cost, generated charges, consumed charges and bonus damage per charges.
    -- The abilities Lumiere Assault and Strike Storm were adjusted to generate more charges to keep up with other abilities that do this.
    -- Overcharge and Shatter both cost 6 AP, From Fire costs 1 more AP.
    ------------------------------------------------------------------------

    -- Overcharge: These are the settings for Overcharge.
    
    -- Percentage amount of charges refilled when breaking an enemy with Overcharge. Default: 0.25 (25%)
    -- NOTE: The value works like this: 0.25 = 25% of max. charges, 0.33 = 33% of max. charges, 1.00 = 100% of max charges aka. complete refill.
    OverchargeChargesPercentage = 0.33,

    -- This adds ontop of Overcharge's default 0.20 damage per charge from the base game. Default: 0.05 (+5%)
    OverchargeDamagePerCharge = 3.30,

    -- This adds ontop of Overcharge's default 0.25 "fully charged" bonus from the base game. Default: 0.10 (+10%)
    OverchargeMaxChargesBonus = 0.08,

    -- AP cost of this ability. Default: 6 / Default in Vanilla: 4
    -- Since Overcharge is quite a bit stronger in this mod, a higher AP cost is only fair.
    OverchargeAPCost = 4,

    ------------------------------------------------------------------------

    -- Shatter: These are the settings for Shatter.
    -- NOTE: Shatter has some higher default settings for its damage per charge because it is an overall weaker ability.
    -- The default settings allow Shatter to do about 1/3 of what Overcharge does.

    -- Percentage amount of charges refilled when breaking an enemy with Shatter. Default: 0.20 (20%)
    -- NOTE: The value works like this: 0.20 = 20% of max. charges, 0.33 = 33% of max. charges, 1.00 = 100% of max charges aka. complete refill.
    ShatterChargesPercentage = 0.33,

    -- Additional damage multiplier that Shatter gets for each charge it consumes. Default: 0.30 (30%)
    -- Overcharge gets 0.20 in the base game.
    ShatterDamagePerCharge = 3.30,

    -- The extra amount of damage that Shatter gets if the charges are full. Default: 0.35 (30%)
    -- Overcharge uses 0.25 in the base game.
    ShatterMaxChargesBonus = 0.33,

    -- AP cost of this ability. Default: 6 / Default in Vanilla: 5
    -- Shatter is basically like Overcharge that hits all enemies so it is VERY strong in this mod, a higher AP cost is only fair.
    ShatterAPCost = 6,

    ------------------------------------------------------------------------

    -- Marking Shot: These are the settings for Marking Shot.

    -- Maximum amount of charges this ability can consume for bonus damage. Default: 10
    MarkingShotChargesConsumed = 10,

    -- Additional damage multiplier per consumed charge. Default: 0.20 (20%)
    MarkingShotDamagePerCharge = 0.33,

    -- AP cost of this ability. Default: 2
    MarkingShotAPCost = 2,

    ------------------------------------------------------------------------

    -- Lumiere Assault: These are the settings for Lumiere Assault.

    -- Charges per critical hit with this ability. Default: 2 / Default in Vanilla: 1
    LumiereAssaultChargesPerCritical = 1,

    -- AP cost of this ability. Default: 3
    LumiereAssaultAPCost = 3,

    ------------------------------------------------------------------------

    -- Strike Storm: These are the settings for Strike Storm.

    -- Charges per critical hit with this ability. Default: 3 / Default in Vanilla: 2
    StrikeStormChargesPerCritical = 2,

    -- AP cost of this ability. Default: 7
    StrikeStormAPCost = 7,

    ------------------------------------------------------------------------

    -- From Fire: These are the settings for From Fire.

    -- Maximum amount of charges this ability can consume for bonus damage. Default: 15
    FromFireChargesConsumed = 10,

    -- Additional damage multiplier per consumed charge. Default: 0.20 (20%)
    FromFireDamagePerCharge = 0.33,

    -- Additional health per hit. Default: 0.01
    -- NOTE: A value of 0.01 for example means 1% of max health healed per hit per charge.
    -- Consuming 15 charges would heal us by 15% of max health per hit.
    FromFireHealPerCharge = 0.015,

    -- Charges per critical hit with this ability. Default: 2
    FromFireChargesPerCritical = 1,

    -- AP cost of this ability. Default: 5 / Default in Vanilla: 4
    FromFireAPCost = 4,

    ------------------------------------------------------------------------

    -- Recovery: These are the settings for Recovery.

    -- Percentage amount of charges that Recovery generates. Default: 0.10 (10%) / Default in Vanilla: 0-2 charges
    -- NOTE: This amount is gained on a perfect skillcheck. A normal skillcheck gives half, while a failed skillcheck gives nothing.
    RecoveryChargesPercentage = 0.33,

    -- AP cost of this ability. Default: 3
    RecoveryAPCost = 3,

    ------------------------------------------------------------------------

    -- Powerful: These are the settings for Powerful.
    -- NOTE: Powerful no longer generates charges but gives very powerful and unique buffs to Gustave the more charges that get consumed.
    -- It grants following bonuses in steps of 5: Shell, Rush, Berserk, bonus duration and Rage.
    -- Berserk and Rage are usually exclusive to enemies only.
    -- Berserk increases your damage every turn with a cap of 12 stacks. If you fail to upkeep Berserk and lose it, you lose all stacks and it starts from 0 stacks again.
    -- Rage allows you to play a second turn as long as you can upkeep it by spamming Powerful. It stacks with Cheater and other effects that give extra turns.

    -- Maximum amount of charges this ability can consume for extra buffs on the casting character. Default: 50
    -- If set to 0, Powerful no longer grants any additional buffs anymore.
    PowerfulChargesConsumed = 10,

    -- AP cost of this ability. Default: 4 / Default in Vanilla: 3
    -- The higher AP cost is justified because it gives Berserk and Rage with enough charges, which is very powerful.
    PowerfulAPCost = 5,

    ------------------------------------------------------------------------

    -- Light Holder: These are the settings for the unused version of Light Holder, exclusive to Gustave only.
    -- NOTE: The damage based on health did NOT work in the vanilla game, this functionality has been restored here.

    -- Charges per critical hit with this ability. Default: 2
    LightHolderChargesPerCritical = 1,

    -- Additional damage multiplier for each x amount of health. Default: 0.01 (1%)
    LightHolderDamagePerHealthChunk = 0.01,

    -- The size of the health chunk that increases the damage multiplier. Default: 100
    -- Example: If the setting is 100 and our character has 1000 health, the damage multiplier will increase 10 times.
    LightHolderHealthChunkSize = 100,

    -- AP cost of this ability. Default: 5 / Default in Vanilla: 4
    -- This ability can be quite strong with enough max health, so the higher cost is justified.
    LightHolderAPCost = 4,

    ------------------------------------------------------------------------

    -- Radiant Strike: These are the settings for the unused version of Radiant Slash, exclusive to Gustave only.

    -- Maximum amount of charges this ability can consume for bonus damage. Default: 20
    RadiantStrikeChargesConsumed = 10,

    -- Additional damage multiplier per consumed charge. Default: 0.20 (20%)
    RadiantStrikeDamagePerCharge = 0.33,

    -- AP cost of this ability. Default: 5 / Default in Vanilla: 4
    RadiantStrikeAPCost = 4,

    ------------------------------------------------------------------------
    -- PERFECTION ABILITIES: Shared with the other character.
    ------------------------------------------------------------------------

    -- Overload: These are the settings for Overload.

    -- Percentage amount of charges refilled when using the ability "Overload". Default: 0.50 (50%)
    OverloadChargesPercentage = 1.00,

    -- AP cost of this ability. Default: 6
    OverloadAPCost = 6,

    ------------------------------------------------------------------------

    -- Steeled Strike: These are the settings for Steeled Strike.

    -- Maximum amount of charges this ability can consume for bonus damage. Default: 50
    SteeledStrikeChargesConsumed = 10,

    -- Additional damage multiplier per consumed charge. Default: 0.20 (20%)
    SteeledStrikeDamagePerCharge = 0.33,

    -- AP cost of this ability. Default: 9
    SteeledStrikeAPCost = 9,

    ------------------------------------------------------------------------

    -- Endbringer: These are the settings for Endbringer.

    -- Charges per hit on a stunned enemy with this ability. Default: 5
    EndbringerChargesPerStunnedHit = 2,

    -- AP cost of this ability. Default: 9
    EndbringerAPCost = 9,

    ------------------------------------------------------------------------

    -- Berserk Slash: These are the settings for Berserk Slash.

    -- Maximum amount of charges this ability can consume for bonus damage. Default: 10
    BerserkSlashChargesConsumed = 10,

    -- Additional damage multiplier per consumed charge. Default: 0.20 (20%)
    BerserkSlashDamagePerCharge = 0.33,

    -- AP cost of this ability. Default: 4
    BerserkSlashAPCost = 4,

    ------------------------------------------------------------------------

    -- Defiant Strike: These are the settings for Defiant Strike.

    -- Maximum amount of charges this ability can consume for bonus damage. Default: 15
    DefiantStrikeChargesConsumed = 10,

    -- Additional damage multiplier per consumed charge. Default: 0.20 (20%)
    DefiantStrikeDamagePerCharge = 0.33,

    -- AP cost of this ability. Default: 3
    DefiantStrikeAPCost = 3,

    ------------------------------------------------------------------------

    -- Blitz: These are the settings for Blitz.

    -- Maximum amount of charges this ability can consume for bonus damage. Default: 5
    BlitzChargesConsumed = 10,

    -- Additional damage multiplier per consumed charge. Default: 0.20 (20%)
    BlitzDamagePerCharge = 0.33,

    -- AP cost of this ability. Default: 3
    BlitzAPCost = 3,

    ------------------------------------------------------------------------

    -- Follow Up: These are the settings for Follow Up.

    -- Maximum amount of charges this ability can consume for bonus damage. Default: 15
    FollowUpChargesConsumed = 10,

    -- Additional damage multiplier per consumed charge. Default: 0.20 (20%)
    FollowUpDamagePerCharge = 0.33,

    -- AP cost of this ability. Default: 5
    FollowUpAPCost = 5,

    -- Reduced AP cost of this ability. Default: 2
    -- NOTE: This value is used when all required charges from FollowUpChargesConsumed are available.
    FollowUpAPReducedCost = 2,

    ------------------------------------------------------------------------

    -- Ascending Assault: These are the settings for Ascending Assault.

    -- Maximum amount of charges this ability can consume for bonus damage. Default: 20
    AscendingAssaultChargesConsumed = 10,

    -- Additional damage multiplier per consumed charge. Default: 0.20 (20%)
    AscendingAssaultDamagePerCharge = 0.33,

    -- AP cost of this ability. Default: 5
    AscendingAssaultAPCost = 5,

    -- Reduced AP cost of this ability. Default: 2
    -- NOTE: This value is used when all required charges from AscendingAssaultChargesConsumed are available.
    AscendingAssaultAPReducedCost = 2,

    ------------------------------------------------------------------------

    -- Speed Burst: These are the settings for Speed Burst.

    -- Extra charges per hit with this ability. Default: 2
    SpeedBurstChargesPerHit = 1,

    -- AP cost of this ability. Default: 6
    SpeedBurstAPCost = 6,

    ------------------------------------------------------------------------

    -- Phantom Stars: These are the settings for Phantom Stars.

    -- Percentage amount of charges refilled when breaking an enemy with Phantom Stars. Default: 0.10 (10%)
    -- NOTE: The value works like this: 0.10 = 10% of max. charges, 0.33 = 33% of max. charges, 1.00 = 100% of max charges aka. complete refill.
    PhantomStarsChargesPercentage = 0.33,

    -- Maximum amount of charges this ability can consume for bonus damage. Default: 40
    PhantomStarsChargesConsumed = 10,

    -- Additional damage multiplier per consumed charge. Default: 0.20 (20%)
    PhantomStarsDamagePerCharge = 0.33,

    -- AP cost of this ability. Default: 9
    PhantomStarsAPCost = 9,

    -- Reduced AP cost of this ability. Default: 5
    -- NOTE: This value is used when all required charges from PhantomStarsChargesConsumed are available.
    PhantomStarsAPReducedCost = 5,

    ------------------------------------------------------------------------

    -- Paradigm Shift: These are the settings for Paradigm Shift.

    --  Amount of charges this ability can consume for bonus AP. Default: 1
    -- NOTE: This triggers with each hit which is 3 times. If set to 1, it will consume 3 charges total.
    ParadigmShiftChargesConsumed = 1,

    -- Amount of AP given per consumed charge. Default: 1
    ParadigmShiftAPPerCharge = 1,

    -- AP cost of this ability. Default: 1
    ParadigmShiftAPCost = 1,

    ------------------------------------------------------------------------

    -- Purification: These are the settings for Purification.

    -- Maximum amount of charges this ability can consume for bonus damage. Default: 10
    PurificationChargesConsumed = 10,

    -- Additional damage multiplier per consumed charge. Default: 0.20 (20%)
    PurificationDamagePerCharge = 0.33,

    -- AP cost of this ability. Default: 4
    PurificationAPCost = 4,

    ------------------------------------------------------------------------

    -- Angel's Eyes: These are the settings for Angel's Eyes.
    -- This is a gradient ability and it's the only one that interacts with Perfection, so it will interact with Overcharge as well.
    -- No cost settings though, there is no reason to modify it since gradients are special.

    -- Extra charges per hit with this ability. Default: 3
    AngelsEyesAdditionalChargesPerHit = 1,

    ------------------------------------------------------------------------
    -- BERSERK: This setting fixes the Berserk buff to not scale the size of our character when gaining it with enough charges via "Powerful".
    -- This has a setting because the Berserk buff has a built-in feature to slowly increase the scaling size of affected characters (I never knew nor noticed this on enemies tbh, did you?).
    -- It is very subtle but you can notice it in longer battles and it can make the character and menus look weird, this setting fixes it so this doesn't happen anymore.

    -- WARNING: THESE SETTINGS CAN MAKE USING THE UI AND SHOOTING ENEMIES IMPOSSIBLE! DO NOT MODIFY IF YOU WANT PROPER GAMEPLAY.
    -- Modify this at your own risk.
    ------------------------------------------------------------------------

    -- This defines the percentage scale size the character gets set to. Default: 1.00 (100%)
    -- WARNING Anything that isn't 1.00 (100%) keeps stacking, so he'll keep getting bigger or smaller with each turn our character has Berserk applied.
    BerserkScaleSize = 1.00,

    -- This defines the amount of time it takes to transition to the new size. Default: 0.05 (50 milliseconds)
    BerserkScaleTime = 0.05,
}
