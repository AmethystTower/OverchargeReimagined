
-- Overcharge Reimagined configuration file.
-- If you created a cool template with this config that offers unique gameplay, feel free to suggest it and maybe it will get added to this mod's official repository!

return
{
    ------------------------------------------------------------------------
    -- Charge limits.
    ------------------------------------------------------------------------

    -- Maximum charges that Overcharge can carry. Default: 100 / Default in Vanilla: 10
    -- This also increases the maximum damage done by Overcharge for each additional charge it can hold.
    -- NOTE: DO NOT SET THIS TO A NEGATIVE VALUE, otherwise your character will be unable to generate any charges!
    VirtualMaxCharges = 100,

    ------------------------------------------------------------------------
    -- Charge generation settings below.
    -- All default settings match the base game.

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
    -- NOTE: This does NOT affect free aim shots by default and is independent from Lumiere Assault, Strike Storm, Light Holder and From Fire.
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
    ------------------------------------------------------------------------

    -- Overcharge: These are the settings for Overcharge.
    
    -- Percentage amount of charges refilled when breaking an enemy with Overcharge. Default: 0.3 (30%)
    OverchargeChargesPercentage = 0.25,

    -- This adds ontop of Overcharge's default 0.2 damage per charge from the base game.
    OverchargeDamagePerCharge = 0.05,

    -- This adds ontop of Overcharge's default 0.25 "fully charged" bonus from the base game.
    OverchargeMaxChargesBonus = 0.05,

    -- AP cost of this ability. Default: 7 / Default in Vanilla: 4
    -- Since Overcharge is quite a bit stronger in this mod, a higher AP cost is only fair.
    OverchargeAPCost = 7,

    ------------------------------------------------------------------------

    -- Shatter: These are the settings for Shatter.

    -- Percentage amount of charges refilled when breaking an enemy with Shatter. Default: 0.15 (15%)
    -- NOTE: The value works like this: 0.15 = 15% of max. charges, 0.33 = 33% of max. charges, 1.00 = 100% of max charges aka. complete refill.
    ShatterChargesPercentage = 0.15,

    -- Additional damage multiplier that Shatter gets for each charge it consumes.
    -- Overcharge gets 0.2 in the base game.
    ShatterDamagePerCharge = 0.2,

    -- The extra amount of damage that Shatter gets if the charges are full. Default: 0.25 (25%)
    -- Overcharge uses 0.25.
    ShatterMaxChargesBonus = 0.25,

    -- AP cost of this ability. Default: 8 / Default in Vanilla: 5
    -- Shatter is basically like Overcharge that hits all enemies so it is VERY strong in this mod, a higher AP cost is only fair.
    ShatterAPCost = 8,

    ------------------------------------------------------------------------

    -- Marking Shot: These are the settings for Marking Shot.

    -- Maximum amount of charges this ability can consume for bonus damage. Default: 10
    MarkingShotChargesConsumed = 10,

    -- Additional damage multiplier per consumed charge. Default: 0.2 (20%)
    MarkingShotDamagePerCharge = 0.2,

    -- AP cost of this ability. Default: 4 / Default in Vanilla: 2
    MarkingShotAPCost = 4,

    ------------------------------------------------------------------------

    -- Lumiere Assault: These are the settings for Lumiere Assault.

    -- Charges per critical hit with this ability. Default: 1
    LumiereAssaultChargesPerCritical = 1,

    -- AP cost of this ability. Default: 3
    LumiereAssaultAPCost = 3,

    ------------------------------------------------------------------------

    -- Strike Storm: These are the settings for Strike Storm.

    -- Charges per critical hit with this ability. Default: 2
    StrikeStormChargesPerCritical = 2,

    -- AP cost of this ability. Default: 7
    StrikeStormAPCost = 7,

    ------------------------------------------------------------------------

    -- From Fire: These are the settings for From Fire.

    -- Maximum amount of charges this ability can consume for bonus damage. Default: 15
    FromFireChargesConsumed = 15,

    -- Additional damage multiplier per consumed charge. Default: 0.2 (20%)
    FromFireDamagePerCharge = 0.2,

    -- Additional health per hit. Default: 0.01
    -- NOTE: A value of 0.01 for example means 1% of max health healed per hit per charge.
    -- Consuming 15 charges would heal us by 15% of max health per hit.
    FromFireHealPerCharge = 0.01,

    -- Charges per critical hit with this ability. Default: 2
    FromFireChargesPerCritical = 2,

    -- AP cost of this ability. Default: 5 / Default in Vanilla: 4
    FromFireAPCost = 5,

    ------------------------------------------------------------------------

    -- Recovery: These are the settings for Recovery.

    -- Percentage amount of charges that Recovery generates. Default: 0.1 (10%) / Default in Vanilla: 0-2 charges
    -- NOTE: This amount is gained on a perfect skillcheck. A normal skillcheck gives half, while a failed one gives nothing.
    RecoveryChargesPercentage = 0.1,

    -- AP cost of this ability. Default: 3
    RecoveryAPCost = 3,

    ------------------------------------------------------------------------

    -- Powerful: These are the settings for Powerful.
    -- NOTE: Powerful no longer generates charges but gives very powerful effects the more charges that get consumed.
    -- It grants following bonus in steps of 5: Shell, Rush, Regen, bonus duration and Rage.
    -- Rage is usually exclusive to enemies only which allows you to play a second turn as long as you can upkeep it by spamming Powerful.
    -- The higher AP and charge cost are justified solely because it gives Rage at the end.

    -- Maximum amount of charges this ability can consume for extra buffs on the casting character. Default: 50
    PowerfulChargesConsumed = 50,

    -- AP cost of this ability. Default: 5 / Default in Vanilla: 3
    PowerfulAPCost = 5,

    ------------------------------------------------------------------------

    -- Light Holder: These are the settings for the unused version of Light Holder, exclusive to our character only.
    -- NOTE: The damage based on health did NOT work in the vanilla game, this functionality has been restored here.

    -- Charges per critical hit with this ability. Default: 2
    LightHolderChargesPerCritical = 2,

    -- Additional damage multiplier for each x amount of health. Default: 0.01 (1%)
    LightHolderDamagePerHealthChunk = 0.01,

    -- The size of the health chunk that increases the damage multiplier. Default: 100
    -- Example: If the setting is 100 and our character has 1000 health, the damage multiplier will increase 10 times.
    LightHolderHealthChunkSize = 100,

    -- AP cost of this ability. Default: 5 / Default in Vanilla: 5
    LightHolderAPCost = 5,

    ------------------------------------------------------------------------

    -- Radiant Strike: These are the settings for the unused version of Radiant Slash, exclusive to our character only.

    -- Maximum amount of charges this ability can consume for bonus damage. Default: 20
    RadiantStrikeChargesConsumed = 20,

    -- Additional damage multiplier per consumed charge. Default: 0.2 (20%)
    RadiantStrikeDamagePerCharge = 0.2,

    -- AP cost of this ability. Default: 6 / Default in Vanilla: 4
    RadiantStrikeAPCost = 6,

    ------------------------------------------------------------------------
    -- PERFECTION ABILITIES: Shared with the other character.
    ------------------------------------------------------------------------

    -- Overload: These are the settings for Overload.

    -- Percentage amount of charges refilled when using the ability "Overload". Default: 0.5 (50%)
    OverloadChargesPercentage = 0.5,

    -- AP cost of this ability. Default: 6
    OverloadAPCost = 6,

    ------------------------------------------------------------------------

    -- Steeled Strike: These are the settings for Steeled Strike.

    -- Percentage amount of charges refilled when using the ability "Overload". Default: 0.5 (50%)
    SteeledStrikeChargesConsumed = 50,

    -- Additional damage multiplier per consumed charge. Default: 0.2 (20%)
    SteeledStrikeDamagePerCharge = 0.2,

    -- AP cost of this ability. Default: 9
    SteeledStrikeAPCost = 9,

    ------------------------------------------------------------------------

    -- Endbringer: These are the settings for Endbringer.

    -- Charges per hit on a stunned enemy with this ability. Default: 5
    EndbringerChargesPerStunnedHit = 5,

    -- AP cost of this ability. Default: 9
    EndbringerAPCost = 9,
}
