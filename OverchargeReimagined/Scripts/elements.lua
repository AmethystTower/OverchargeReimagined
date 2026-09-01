
--[[
------- Overcharge Reimagined v3.0 - By Killera -------

        This module handles all the elemental damage type tables and caches the config's custom element settings used by all abilities in a static list.

        DO NOT MODIFY THIS MODULE IF YOU SIMPLY WANT TO CUSTOMIZE THIS MOD.
        Use the config.lua for that instead!
]]--

-- This is basically an enum (haha Lua has no real enums so this is just an array...) that holds readable values for each elemental type.
local ElementEnum =
{
    Weapon = 0,
    Physical = 1,
    Fire = 2,
    Ice = 3,
    Lightning = 4,
    Earth = 5,
    Dark = 6,
    Light = 7,
    Void = 8
}

-- This holds a static array for our custom ability elemental types.
-- Initialize the element table as empty first because Lua is trash and we can't just hand over the config.lua to this module from main.lua.
local abilityElement = {}

-- Initialize the table with all config settings now.
local function Init(log, config)
    if not config then
        log("Failed to initialize abilityElement array because of missing config values.")
    end

    abilityElement["UnleashCharge"] = config.OverchargeElement
    abilityElement["PerfectBreak_Gustave"] = config.ShatterElement
    abilityElement["MarkingShot_Gustave"] = config.MarkingShot
    abilityElement["Combo1_Gustave"] = config.LumiereAssaultElement
    abilityElement["StrikeStorm_Gustave"] = config.StrikeStormElement
    abilityElement["FromFire_Gustave"] = config.FromFireElement
    abilityElement["OldLightHolder"] = config.LightHolderElement
    abilityElement["RadiantStrike"] = config.RadiantStrikeElement

    -- These abilities are shared.
    abilityElement["SteeledStrike"] = config.SteeledStrikeElement
    abilityElement["EndBringer"] = config.EndbringerElement
    abilityElement["BerserkSlash"] = config.BerserkSlashElement
    abilityElement["DefiantStrike"] = config.DefiantStrikeElement
    abilityElement["Blitz"] = config.BlitzElement
    abilityElement["FollowUp"] = config.FollowUpElement
    abilityElement["AscendingAssault"] = config.AscendingAssaultElement
    abilityElement["SpeedBurst"] = config.SpeedBurstElement
    abilityElement["PhantomStars"] = config.PhantomStarsElement
    abilityElement["ParadigmShift"] = config.ParadigmShiftElement
    abilityElement["Purification"] = config.PurificationElement

    log("Initialized abilityElement array in elements.lua successfully!")
end

-- This function returns the requested entry from the static ability element table.
local function GetAbilityElement(abilityNameID)
    return abilityElement[abilityNameID]
end

-- Expose the functions to main.lua.
return
{
    Init = Init,
    GetAbilityElement = GetAbilityElement,
    ElementEnum = ElementEnum
}