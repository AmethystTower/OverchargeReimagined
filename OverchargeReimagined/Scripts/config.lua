
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
    -- NOTE: This does NOT affect free aim shots by default and is independent from Lumiere Assault and Strike Storm.
    ChargesOnCritical = 0,

    -- Charges when taking a hit from an enemy. Default: 0
    -- NOTE: Taking hits with shields doesn't prevent this event, similar to the perfection mechanic.
    ChargesOnReceivedHit = 0,

    -- This allows free aim shots to generate charges from critical hits using the 'ChargesOnCritical' value setting. Default: false
    -- NOTE: This is independent from the 'ChargesOnFreeAim' setting.
    -- VALUES: true = enabled, false = disabled.
    FreeAimAffectedByCriticals = false,
}
