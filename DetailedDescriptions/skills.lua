
--[[
------- Overcharge Reimagined v3.0 - By Killera -------

        This module handles all the ability descriptions and settings like AP cost, consumed charges and damage per charge.
        The descriptions are quite difficult to read because of all the variables and the formatting needed.
        But if this isn't an issue to you then you can feel free to modify and translate this to a different language if you desire.
        I will happily add it to the official repository and make the translation available as an extra download.

        This is a version with more detailed ability descriptions, as it was a request by some users so that they match the detailed descriptios of another mod.

        DO NOT MODIFY THIS MODULE IF YOU SIMPLY WANT TO CUSTOMIZE THIS MOD.
        Use the config.lua for that instead!
]]--

-- Lua has no switch-case... ABSOLUTE KANK I HATE THIS LANGUAGE SO MUCH.
-- This function simply returns a formatted string for each elemental damage type in their respective colours.
local function GetElementString(elementValue, elementalEnum, isShortDescription)
    if elementValue == elementalEnum.Physical then
        return "<keyword id=\"Element_Physical\">Physical</>"
    elseif elementValue == elementalEnum.Fire then
        return "<keyword id=\"Element_Fire\">Fire</>"
    elseif elementValue == elementalEnum.Ice then
        return "<keyword id=\"Element_Ice\">Ice</>"
    elseif elementValue == elementalEnum.Lightning then
        return "<keyword id=\"Element_Lightning\">Lightning</>"
    elseif elementValue == elementalEnum.Earth then
        return "<keyword id=\"Element_Earth\">Earth</>"
    elseif elementValue == elementalEnum.Dark then
        return "<keyword id=\"Element_Dark\">Dark</>"
    elseif elementValue == elementalEnum.Light then
        return "<keyword id=\"Element_Light\">Light</>"
    elseif elementValue == elementalEnum.Void then
        return "<keyword id=\"Element_Void\">Void</>"
    elseif elementValue == elementalEnum.Weapon then
        if isShortDescription then
            return "{DynamicElement}"
        else
            return "<keyword id=\"Element_Physical\">Weapon's Element</>"
        end
    end
end

local abilityValues = {}

-- Initialize the table with all config settings now.
local function Init(log, config, elementalEnum)
    if not config then
        log("Failed to initialize abilityValues array because of missing config values.")
        return
    end

    -- Overcharge
    abilityValues["UnleashCharge"] = {}
    abilityValues["UnleashCharge"].APCost = config.OverchargeAPCost
    abilityValues["UnleashCharge"].ChargesConsumed = config.VirtualMaxCharges
    abilityValues["UnleashCharge"].ChargesMultiplier = config.OverchargeDamagePerCharge
    abilityValues["UnleashCharge"].OverchargeName = config.OverchargeName
    abilityValues["UnleashCharge"].OverchargeBonusDescription = "Can <keyword id=\"Break\">Stun</> a target and refill " .. string.format("%g", (config.OverchargeChargesPercentage) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</> upon doing so."
    abilityValues["UnleashCharge"].OverchargeLongDescription = "150% " .. GetElementString(config.OverchargeElement, elementalEnum, false) .. " damage. [<text color=\"#D5B87C\">1x</>]\nConsumes all <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", 20 + (config.OverchargeDamagePerCharge * 100)) .. "-" .. string.format("%g", 40 + ((config.OverchargeDamagePerCharge) * 100)) .. "% damage per charge.\nDeals +" .. string.format("%g", (config.OverchargeMaxChargesBonus * 100)) .. "% additional damage if charges are at max.\n" .. abilityValues["UnleashCharge"].OverchargeBonusDescription
    abilityValues["UnleashCharge"].OverchargeShortDescription = "150% " .. GetElementString(config.OverchargeElement, elementalEnum, true) .. " damage. [<text color=\"#D5B87C\">1x</>]\nConsumes all <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", 20 + (config.OverchargeDamagePerCharge * 100)) .. "-" .. string.format("%g", 40 + ((config.OverchargeDamagePerCharge) * 100)) .. "% damage per charge.\nDeals +" .. string.format("%g", (config.OverchargeMaxChargesBonus * 100)) .. "% additional damage if charges are at max.\n" .. abilityValues["UnleashCharge"].OverchargeBonusDescription
    abilityValues["UnleashCharge"].PerfectionName = nil
    abilityValues["UnleashCharge"].PerfectionBonusDescription = nil
    abilityValues["UnleashCharge"].PerfectionLongDescription = nil
    abilityValues["UnleashCharge"].PerfectionShortDescription = nil

    -- Shatter
    abilityValues["PerfectBreak_Gustave"] = {}
    abilityValues["PerfectBreak_Gustave"].APCost = config.ShatterAPCost
    abilityValues["PerfectBreak_Gustave"].ChargesConsumed = config.VirtualMaxCharges
    abilityValues["PerfectBreak_Gustave"].ChargesMultiplier = config.ShatterDamagePerCharge
    abilityValues["PerfectBreak_Gustave"].OverchargeName = config.ShatterName
    abilityValues["PerfectBreak_Gustave"].OverchargeBonusDescription = "Can <keyword id=\"Break\">Stun</> a target and refill " .. string.format("%g", (config.ShatterChargesPercentage) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</> upon doing so."
    abilityValues["PerfectBreak_Gustave"].OverchargeLongDescription = "175% " .. GetElementString(config.ShatterElement, elementalEnum, false) .. " damage to all enemies. [<text color=\"#D5B87C\">1x</>]\nConsumes all <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.ShatterDamagePerCharge) * 100) .. "% damage per charge.\nDeals +" .. string.format("%g", (config.ShatterMaxChargesBonus) * 100) .. "% additional damage if charges are at max.\n" .. abilityValues["PerfectBreak_Gustave"].OverchargeBonusDescription
    abilityValues["PerfectBreak_Gustave"].OverchargeShortDescription = "175% " .. GetElementString(config.ShatterElement, elementalEnum, true) .. " damage to all enemies. [<text color=\"#D5B87C\">1x</>]\nConsumes all <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.ShatterDamagePerCharge) * 100) .. "% damage per charge.\nDeals +" .. string.format("%g", (config.ShatterMaxChargesBonus) * 100) .. "% additional damage if charges are at max.\n" .. abilityValues["PerfectBreak_Gustave"].OverchargeBonusDescription
    abilityValues["PerfectBreak_Gustave"].PerfectionName = nil
    abilityValues["PerfectBreak_Gustave"].PerfectionBonusDescription = nil
    abilityValues["PerfectBreak_Gustave"].PerfectionLongDescription = nil
    abilityValues["PerfectBreak_Gustave"].PerfectionShortDescription = nil

    -- Marking Shot
    abilityValues["MarkingShot_Gustave"] = {}
    abilityValues["MarkingShot_Gustave"].APCost = config.MarkingShotAPCost
    abilityValues["MarkingShot_Gustave"].ChargesConsumed = config.VirtualMaxCharges
    abilityValues["MarkingShot_Gustave"].ChargesMultiplier = config.MarkingShotDamagePerCharge
    abilityValues["MarkingShot_Gustave"].OverchargeName = config.MarkingShotName
    abilityValues["MarkingShot_Gustave"].OverchargeBonusDescription = "Applies <keyword id=\"StatusEffect_Mark\">Mark</> at the end of the barrage."
    abilityValues["MarkingShot_Gustave"].OverchargeLongDescription = "100% " .. GetElementString(config.MarkingShotElement, elementalEnum, false) .. " damage. [<text color=\"#D5B87C\">1x</>]\nConsumes all <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.MarkingShotDamagePerCharge) * 100) .. "% damage and +" .. string.format("%g", (config.MarkingShotMaxStunChance / config.VirtualMaxCharges) * 100) .."% chance to instantly <keyword id=\"Break\">Stun</> per charge.\nDeals +" .. string.format("%g", (config.MarkingShotMaxChargesBonus) * 100) .. "% additional damage if charges are at max.\n" .. abilityValues["MarkingShot_Gustave"].OverchargeBonusDescription
    abilityValues["MarkingShot_Gustave"].OverchargeDynamicDescriptionPiece = "% chance to instantly <keyword id=\"Break\">Stun</>\n" .. abilityValues["MarkingShot_Gustave"].OverchargeBonusDescription
    -- Do not add bonus description to short description here, this ability's short description is built dynamically to show the current stun chance in module main.lua in function ModifyAbilityCostAndDescription() during battle.
    abilityValues["MarkingShot_Gustave"].OverchargeShortDescription = "100% " .. GetElementString(config.MarkingShotElement, elementalEnum, false) .. " damage. [<text color=\"#D5B87C\">1x</>]\nConsumes all <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.MarkingShotDamagePerCharge) * 100) .. "% damage per charge.\nDeals +" .. string.format("%g", (config.MarkingShotMaxChargesBonus) * 100) .. "% additional damage if charges are at max."
    abilityValues["MarkingShot_Gustave"].PerfectionName = nil
    abilityValues["MarkingShot_Gustave"].PerfectionBonusDescription = nil
    abilityValues["MarkingShot_Gustave"].PerfectionLongDescription = nil
    abilityValues["MarkingShot_Gustave"].PerfectionShortDescription = nil

    -- Lumiere Assault
    abilityValues["Combo1_Gustave"] = {}
    abilityValues["Combo1_Gustave"].APCost = config.LumiereAssaultAPCost
    abilityValues["Combo1_Gustave"].ChargesConsumed = nil
    abilityValues["Combo1_Gustave"].ChargesMultiplier = nil
    abilityValues["Combo1_Gustave"].OverchargeName = config.LumiereAssaultName
    abilityValues["Combo1_Gustave"].OverchargeBonusDescription = "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.LumiereAssaultChargesPerCritical) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>"
    abilityValues["Combo1_Gustave"].OverchargeLongDescription = "125% " .. GetElementString(config.LumiereAssaultElement, elementalEnum, false) .. " damage over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\nGets interrupted if failed.\n" .. abilityValues["Combo1_Gustave"].OverchargeBonusDescription
    abilityValues["Combo1_Gustave"].OverchargeShortDescription = "125% " .. GetElementString(config.LumiereAssaultElement, elementalEnum, true) .. " damage over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\nGets interrupted if failed.\n" .. abilityValues["Combo1_Gustave"].OverchargeBonusDescription
    abilityValues["Combo1_Gustave"].PerfectionName = nil
    abilityValues["Combo1_Gustave"].PerfectionBonusDescription = nil
    abilityValues["Combo1_Gustave"].PerfectionLongDescription = nil
    abilityValues["Combo1_Gustave"].PerfectionShortDescription = nil

    -- Strike Storm
    abilityValues["StrikeStorm_Gustave"] = {}
    abilityValues["StrikeStorm_Gustave"].APCost = config.StrikeStormAPCost
    abilityValues["StrikeStorm_Gustave"].ChargesConsumed = nil
    abilityValues["StrikeStorm_Gustave"].ChargesMultiplier = nil
    abilityValues["StrikeStorm_Gustave"].OverchargeName = config.StrikeStormName
    abilityValues["StrikeStorm_Gustave"].OverchargeBonusDescription = "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.StrikeStormChargesPerCritical) .. " additional <keyword id=\"Gustave_Charges\">Charges</>"
    abilityValues["StrikeStorm_Gustave"].OverchargeLongDescription = "420% " .. GetElementString(config.StrikeStormElement, elementalEnum, false) .. " damage over 6 hits. [<text color=\"#D5B87C\">0.3x</>]\nGets interrupted if failed.\n" .. abilityValues["StrikeStorm_Gustave"].OverchargeBonusDescription
    abilityValues["StrikeStorm_Gustave"].OverchargeShortDescription = "420% " .. GetElementString(config.StrikeStormElement, elementalEnum, true) .. " damage over 6 hits. [<text color=\"#D5B87C\">0.3x</>]\nGets interrupted if failed.\n" .. abilityValues["StrikeStorm_Gustave"].OverchargeBonusDescription
    abilityValues["StrikeStorm_Gustave"].PerfectionName = nil
    abilityValues["StrikeStorm_Gustave"].PerfectionBonusDescription = nil
    abilityValues["StrikeStorm_Gustave"].PerfectionLongDescription = nil
    abilityValues["StrikeStorm_Gustave"].PerfectionShortDescription = nil

    -- From Fire
    abilityValues["FromFire_Gustave"] = {}
    abilityValues["FromFire_Gustave"].APCost = config.FromFireAPCost
    abilityValues["FromFire_Gustave"].ChargesConsumed = config.FromFireChargesConsumed
    abilityValues["FromFire_Gustave"].ChargesMultiplier = config.FromFireDamagePerCharge
    abilityValues["FromFire_Gustave"].OverchargeName = config.FromFireName
    abilityValues["FromFire_Gustave"].OverchargeBonusDescription = "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.FromFireChargesPerCritical) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>\n" .. "Consumes up to " .. (config.FromFireChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.FromFireDamagePerCharge or 0.2) * 100) .. "% additional damage and +" .. string.format("%g", (config.FromFireHealPerCharge or 0.01) * 100) .. "% <keyword id=\"Heal\">heal</> per charge."
    abilityValues["FromFire_Gustave"].OverchargeLongDescription = "187.5% " .. GetElementString(config.FromFireElement, elementalEnum, false) .. " damage over 3 hits. [<text color=\"#D5B87C\">0.5x</>]\n" .. "<keyword id=\"Heal\">Recover</> 20% Health when used against a <keyword id=\"StatusEffect_Burn\">Burning</> enemy.\n" .. abilityValues["FromFire_Gustave"].OverchargeBonusDescription
    abilityValues["FromFire_Gustave"].OverchargeShortDescription = "187.5% " .. GetElementString(config.FromFireElement, elementalEnum, true) .. " damage over 3 hits. [<text color=\"#D5B87C\">0.5x</>]\n" .. "<keyword id=\"Heal\">Recover</> 20% Health when used against a <keyword id=\"StatusEffect_Burn\">Burning</> enemy.\n" .. abilityValues["FromFire_Gustave"].OverchargeBonusDescription
    abilityValues["FromFire_Gustave"].PerfectionName = nil
    abilityValues["FromFire_Gustave"].PerfectionBonusDescription = nil
    abilityValues["FromFire_Gustave"].PerfectionLongDescription = nil
    abilityValues["FromFire_Gustave"].PerfectionShortDescription = nil

    -- Recovery
    abilityValues["PerfectRecovery_Gustave"] = {}
    abilityValues["PerfectRecovery_Gustave"].APCost = config.RecoveryAPCost
    abilityValues["PerfectRecovery_Gustave"].ChargesConsumed = nil
    abilityValues["PerfectRecovery_Gustave"].ChargesMultiplier = nil
    abilityValues["PerfectRecovery_Gustave"].OverchargeName = config.RecoveryName
    abilityValues["PerfectRecovery_Gustave"].OverchargeBonusDescription = "Gain 0% - " .. string.format("%g", (config.RecoveryChargesPercentage) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>"
    abilityValues["PerfectRecovery_Gustave"].OverchargeLongDescription = "<keyword id=\"Heal\">Recover</> 50% Health and cleanse Status Effects.\n" .. abilityValues["PerfectRecovery_Gustave"].OverchargeBonusDescription
    abilityValues["PerfectRecovery_Gustave"].OverchargeShortDescription = "<keyword id=\"Heal\">Recover</> 50% Health and cleanse Status Effects.\n" .. abilityValues["PerfectRecovery_Gustave"].OverchargeBonusDescription
    abilityValues["PerfectRecovery_Gustave"].PerfectionName = nil
    abilityValues["PerfectRecovery_Gustave"].PerfectionBonusDescription = nil
    abilityValues["PerfectRecovery_Gustave"].PerfectionLongDescription = nil
    abilityValues["PerfectRecovery_Gustave"].PerfectionShortDescription = nil

    -- Powerful
    abilityValues["Powerful_Gustave"] = {}
    abilityValues["Powerful_Gustave"].APCost = config.PowerfulAPCost
    abilityValues["Powerful_Gustave"].ChargesConsumed = config.PowerfulChargesConsumed
    abilityValues["Powerful_Gustave"].ChargesMultiplier = nil
    abilityValues["Powerful_Gustave"].OverchargeName = config.PowerfulName
    abilityValues["Powerful_Gustave"].OverchargeBonusDescription = "Consumes <keyword id=\"Gustave_Charges\">Charges</> to empower Gustave:\n"
    abilityValues["Powerful_Gustave"].OverchargeLongDescription = "Apply <keyword id=\"Buff_Powerful\">Powerful</> to self and 0-2 allies for 3 turns.\n" .. abilityValues["Powerful_Gustave"].OverchargeBonusDescription ..
                                                                string.format("%g", (config.PowerfulChargesConsumed) * 0.2) .. " Charges: Apply <keyword id=\"Buff_Shell_Left\">Shell</> for 3 turns.\n" ..
                                                                string.format("%g", (config.PowerfulChargesConsumed) * 0.4) .. " Charges: Apply <keyword id=\"Buff_Rush_Left\">Rush</> for 3 turns.\n" ..
                                                                string.format("%g", (config.PowerfulChargesConsumed) * 0.6) .. " Charges: Apply <keyword id=\"StatusEffect_Berserk_Left\">Berserk</> for 3 turns.\n" ..
                                                                string.format("%g", (config.PowerfulChargesConsumed) * 0.8) .. " Charges: Increase turn duration to 6.\n" ..
                                                                (config.PowerfulChargesConsumed) .. " Charges: Apply <keyword id=\"StatusEffect_Enraged_Left\">Rage</> for 1 turn."
    abilityValues["Powerful_Gustave"].OverchargeShortDescription = "Apply <keyword id=\"Buff_Powerful\">Powerful</> to self and 0-2 allies for 3 turns.\n" .. abilityValues["Powerful_Gustave"].OverchargeBonusDescription ..
                                                                "<keyword id=\"Element_Lightning\">" .. string.format("%g", (config.PowerfulChargesConsumed) * 0.2) .. "</>: <keyword id=\"Buff_Shell_Left\">Shell</> / " ..
                                                                "<keyword id=\"Element_Lightning\">" .. string.format("%g", (config.PowerfulChargesConsumed) * 0.4) .. "</>: <keyword id=\"Buff_Rush_Left\">Rush</> /\n" ..
                                                                "<keyword id=\"Element_Lightning\">" .. string.format("%g", (config.PowerfulChargesConsumed) * 0.6) .. "</>: <keyword id=\"StatusEffect_Berserk_Left\">Berserk</> / " ..
                                                                "<keyword id=\"Element_Lightning\">" .. string.format("%g", (config.PowerfulChargesConsumed) * 0.8) .. "</>: 6-turn duration /\n" ..
                                                                "<keyword id=\"Element_Lightning\">" .. string.format("%g", (config.PowerfulChargesConsumed)) .. "</>: <keyword id=\"StatusEffect_Enraged_Left\">Rage</> for 1 turn."
    abilityValues["Powerful_Gustave"].PerfectionName = nil
    abilityValues["Powerful_Gustave"].PerfectionBonusDescription = nil
    abilityValues["Powerful_Gustave"].PerfectionLongDescription = nil
    abilityValues["Powerful_Gustave"].PerfectionShortDescription = nil

    -- Light Holder
    abilityValues["OldLightHolder"] = {}
    abilityValues["OldLightHolder"].APCost = config.LightHolderAPCost
    abilityValues["OldLightHolder"].ChargesConsumed = nil
    abilityValues["OldLightHolder"].ChargesMultiplier = nil
    abilityValues["OldLightHolder"].OverchargeName = config.LightHolderName
    abilityValues["OldLightHolder"].OverchargeBonusDescription = "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.LightHolderChargesPerCritical) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>"
    abilityValues["OldLightHolder"].OverchargeLongDescription = "345% " .. GetElementString(config.LightHolderElement, elementalEnum, false) .. " damage over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\n" .. "Deals +" .. string.format("%g", (config.LightHolderDamagePerHealthChunk) * 100) .. "% additional damage per " .. (config.LightHolderHealthChunkSize) .. " max health.\n" .. abilityValues["OldLightHolder"].OverchargeBonusDescription
    abilityValues["OldLightHolder"].OverchargeShortDescription = "345% " .. GetElementString(config.LightHolderElement, elementalEnum, true) .. " damage over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\n" .. "Deals +" .. string.format("%g", (config.LightHolderDamagePerHealthChunk) * 100) .. "% additional damage per " .. (config.LightHolderHealthChunkSize) .. " max health.\n" .. abilityValues["OldLightHolder"].OverchargeBonusDescription
    abilityValues["OldLightHolder"].PerfectionName = nil
    abilityValues["OldLightHolder"].PerfectionBonusDescription = nil
    abilityValues["OldLightHolder"].PerfectionLongDescription = nil
    abilityValues["OldLightHolder"].PerfectionShortDescription = nil

    -- Radiant Strike
    abilityValues["RadiantStrike"] = {}
    abilityValues["RadiantStrike"].APCost = config.RadiantStrikeAPCost
    abilityValues["RadiantStrike"].ChargesConsumed = config.RadiantStrikeChargesConsumed
    abilityValues["RadiantStrike"].ChargesMultiplier = config.RadiantStrikeDamagePerCharge
    abilityValues["RadiantStrike"].OverchargeName = config.RadiantStrikeName
    abilityValues["RadiantStrike"].OverchargeBonusDescription = "Consumes up to " .. (config.RadiantStrikeChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.RadiantStrikeDamagePerCharge) * 100) .. "% additional damage per charge."
    abilityValues["RadiantStrike"].OverchargeLongDescription = "140% " .. GetElementString(config.RadiantStrikeElement, elementalEnum, false) .. " damage to all enemies. [<text color=\"#D5B87C\">1x</>]\n" .. abilityValues["RadiantStrike"].OverchargeBonusDescription
    abilityValues["RadiantStrike"].OverchargeShortDescription = "140% " .. GetElementString(config.RadiantStrikeElement, elementalEnum, true) .. " damage to all enemies. [<text color=\"#D5B87C\">1x</>]\n" .. abilityValues["RadiantStrike"].OverchargeBonusDescription
    abilityValues["RadiantStrike"].PerfectionName = nil
    abilityValues["RadiantStrike"].PerfectionBonusDescription = nil
    abilityValues["RadiantStrike"].PerfectionLongDescription = nil
    abilityValues["RadiantStrike"].PerfectionShortDescription = nil

    --------------------------------------------------
    -- Perfection abilities shared by other character.
    --------------------------------------------------

    -- Overload
    abilityValues["Overcharge"] = {}
    abilityValues["Overcharge"].APCost = config.OverloadAPCost
    abilityValues["Overcharge"].ChargesConsumed = nil
    abilityValues["Overcharge"].ChargesMultiplier = nil
    abilityValues["Overcharge"].OverchargeName = config.OverloadName
    abilityValues["Overcharge"].OverchargeBonusDescription = "Refill " .. string.format("%g", (config.OverloadChargesPercentage) * 100) .. "% of missing <keyword id=\"Gustave_Charges\">Charges</>"
    abilityValues["Overcharge"].OverchargeLongDescription = "Set Health to 1 and recover all <keyword id=\"APShard\">AP</>\n" .. abilityValues["Overcharge"].OverchargeBonusDescription
    abilityValues["Overcharge"].OverchargeShortDescription = "Set Health to 1 and recover all <keyword id=\"APShard\">AP</>\n" .. abilityValues["Overcharge"].OverchargeBonusDescription
    abilityValues["Overcharge"].PerfectionName = "Overload"
    abilityValues["Overcharge"].PerfectionBonusDescription = "Set rank to <img id=\"Rank_A\"/>"
    abilityValues["Overcharge"].PerfectionLongDescription = "Set Health to 1 and recover all <keyword id=\"APShard\">AP</>\n" .. abilityValues["Overcharge"].PerfectionBonusDescription
    abilityValues["Overcharge"].PerfectionShortDescription = "Set Health to 1 and recover all <keyword id=\"APShard\">AP</>\n" .. abilityValues["Overcharge"].PerfectionBonusDescription

    -- Steeled Strike
    abilityValues["SteeledStrike"] = {}
    abilityValues["SteeledStrike"].APCost = config.SteeledStrikeAPCost
    abilityValues["SteeledStrike"].ChargesConsumed = config.SteeledStrikeChargesConsumed
    abilityValues["SteeledStrike"].ChargesMultiplier = config.SteeledStrikeDamagePerCharge
    abilityValues["SteeledStrike"].OverchargeName = config.SteeledStrikeName
    abilityValues["SteeledStrike"].OverchargeBonusDescription = "Consumes up to " .. (config.SteeledStrikeChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.SteeledStrikeDamagePerCharge) * 100) .. "% additional damage per charge."
    abilityValues["SteeledStrike"].OverchargeLongDescription = "After 1 turn, deals 650% " .. GetElementString(config.SteeledStrikeElement, elementalEnum, false) .. " damage over 13 hits. [<text color=\"#D5B87C\">0.1x</>]\nInterrupted if any damage taken.\n" .. abilityValues["SteeledStrike"].OverchargeBonusDescription
    abilityValues["SteeledStrike"].OverchargeShortDescription = "After 1 turn, deals 650% " .. GetElementString(config.SteeledStrikeElement, elementalEnum, true) .. " damage over 13 hits. [<text color=\"#D5B87C\">0.1x</>]\nInterrupted if any damage taken.\n" .. abilityValues["SteeledStrike"].OverchargeBonusDescription
    abilityValues["SteeledStrike"].PerfectionName = "Steeled Strike"
    abilityValues["SteeledStrike"].PerfectionBonusDescription = "<img id=\"Rank_S\"/>: Deals 150% more damage."
    abilityValues["SteeledStrike"].PerfectionLongDescription = "After 1 turn, deals 650% <keyword id=\"Element_Physical\">Physical</> damage over 13 hits. [<text color=\"#D5B87C\">0.1x</>]\nInterrupted if any damage taken.\n" .. abilityValues["SteeledStrike"].PerfectionBonusDescription
    abilityValues["SteeledStrike"].PerfectionShortDescription = "After 1 turn, deals 650% <keyword id=\"Element_Physical\">Physical</> damage over 13 hits. [<text color=\"#D5B87C\">0.1x</>]\nInterrupted if any damage taken.\n" .. abilityValues["SteeledStrike"].PerfectionBonusDescription

    -- Endbringer
    abilityValues["EndBringer"] = {}
    abilityValues["EndBringer"].APCost = config.EndbringerAPCost
    abilityValues["EndBringer"].ChargesConsumed = nil
    abilityValues["EndBringer"].ChargesMultiplier = nil
    abilityValues["EndBringer"].OverchargeName = config.EndbringerName
    abilityValues["EndBringer"].OverchargeBonusDescription = "<keyword id=\"StatusEffect_Stunned\">Stun Hits</> generate " .. (config.EndbringerChargesPerStunnedHit) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>"
    abilityValues["EndBringer"].OverchargeLongDescription = "720% " .. GetElementString(config.EndbringerElement, elementalEnum, false) .. " damage over 6 hits. [<text color=\"#D5B87C\">0.2x</>]\nDeals 200% more damage if the target is <keyword id=\"StatusEffect_Stunned\">Stunned</>\n" .. abilityValues["EndBringer"].OverchargeBonusDescription
    abilityValues["EndBringer"].OverchargeShortDescription = "720% " .. GetElementString(config.EndbringerElement, elementalEnum, true) .. " damage over 6 hits. [<text color=\"#D5B87C\">0.2x</>]\nDeals 200% more damage if the target is <keyword id=\"StatusEffect_Stunned\">Stunned</>\n" .. abilityValues["EndBringer"].OverchargeBonusDescription
    abilityValues["EndBringer"].PerfectionName = "Endbringer"
    abilityValues["EndBringer"].PerfectionBonusDescription = "<img id=\"Rank_A\"/>: Can reapply <keyword id=\"StatusEffect_Stunned\">Stun</>"
    abilityValues["EndBringer"].PerfectionLongDescription = "720% <keyword id=\"Element_Physical\">Physical</> damage over 6 hits. [<text color=\"#D5B87C\">0.2x</>]\nDeals 200% more damage if the target is <keyword id=\"StatusEffect_Stunned\">Stunned</>\n" .. abilityValues["EndBringer"].PerfectionBonusDescription
    abilityValues["EndBringer"].PerfectionShortDescription = "720% <keyword id=\"Element_Physical\">Physical</> damage over 6 hits. [<text color=\"#D5B87C\">0.2x</>]\nDeals 200% more damage if the target is <keyword id=\"StatusEffect_Stunned\">Stunned</>\n" .. abilityValues["EndBringer"].PerfectionBonusDescription

    -- Berserk Slash
    abilityValues["BerserkSlash"] = {}
    abilityValues["BerserkSlash"].APCost = config.BerserkSlashAPCost
    abilityValues["BerserkSlash"].ChargesConsumed = config.BerserkSlashChargesConsumed
    abilityValues["BerserkSlash"].ChargesMultiplier = config.BerserkSlashDamagePerCharge
    abilityValues["BerserkSlash"].OverchargeName = config.BerserkSlashName
    abilityValues["BerserkSlash"].OverchargeBonusDescription = "Consumes up to " .. (config.BerserkSlashChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.BerserkSlashDamagePerCharge) * 100) .. "% additional damage per charge."
    abilityValues["BerserkSlash"].OverchargeLongDescription = "60% " .. GetElementString(config.BerserkSlashElement or elementalEnum.Physical, elementalEnum, false) .. " damage over 3 hits. [<text color=\"#D5B87C\">0.5x</>]\nDeals +15% more damage per missing 1% health.\n" .. abilityValues["BerserkSlash"].OverchargeBonusDescription
    abilityValues["BerserkSlash"].OverchargeShortDescription = "60% " .. GetElementString(config.BerserkSlashElement or elementalEnum.Physical, elementalEnum, true) .. " damage over 3 hits. [<text color=\"#D5B87C\">0.5x</>]\nDeals +15% more damage per missing 1% health.\n" .. abilityValues["BerserkSlash"].OverchargeBonusDescription
    abilityValues["BerserkSlash"].PerfectionName = "Berserk Slash"
    abilityValues["BerserkSlash"].PerfectionBonusDescription = "<img id=\"Rank_C\"/>: Deals 50% more damage."
    abilityValues["BerserkSlash"].PerfectionLongDescription = "60% <keyword id=\"Element_Physical\">Physical</> damage over 3 hits. [<text color=\"#D5B87C\">0.5x</>]\nDeals +15% more damage per missing 1% health.\n" .. abilityValues["BerserkSlash"].PerfectionBonusDescription
    abilityValues["BerserkSlash"].PerfectionShortDescription = "60% <keyword id=\"Element_Physical\">Physical</> damage over 3 hits. [<text color=\"#D5B87C\">0.5x</>]\nDeals +15% more damage per missing 1% health.\n" .. abilityValues["BerserkSlash"].PerfectionBonusDescription

    -- Defiant Strike
    abilityValues["DefiantStrike"] = {}
    abilityValues["DefiantStrike"].APCost = config.DefiantStrikeAPCost
    abilityValues["DefiantStrike"].ChargesConsumed = config.DefiantStrikeChargesConsumed
    abilityValues["DefiantStrike"].ChargesMultiplier = config.DefiantStrikeDamagePerCharge
    abilityValues["DefiantStrike"].OverchargeName = config.DefiantStrikeName
    abilityValues["DefiantStrike"].OverchargeBonusDescription = "Consumes up to " .. (config.DefiantStrikeChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.DefiantStrikeDamagePerCharge) * 100) .. "% additional damage per charge."
    abilityValues["DefiantStrike"].OverchargeLongDescription = "400% " .. GetElementString(config.DefiantStrikeElement, elementalEnum, false) .. " damage over 2 hits. [<text color=\"#D5B87C\">0.7x</>]\nLast hit applies <keyword id=\"StatusEffect_Mark\">Mark</>\nCosts 30% of current Health.\n" .. abilityValues["DefiantStrike"].OverchargeBonusDescription
    abilityValues["DefiantStrike"].OverchargeShortDescription = "400% " .. GetElementString(config.DefiantStrikeElement, elementalEnum, true) .. " damage over 2 hits. [<text color=\"#D5B87C\">0.7x</>]\nLast hit applies <keyword id=\"StatusEffect_Mark\">Mark</>\nCosts 30% of current Health.\n" .. abilityValues["DefiantStrike"].OverchargeBonusDescription
    abilityValues["DefiantStrike"].PerfectionName = "Defiant Strike"
    abilityValues["DefiantStrike"].PerfectionBonusDescription = "<img id=\"Rank_B\"/>: Deals 50% more damage."
    abilityValues["DefiantStrike"].PerfectionLongDescription = "400% <keyword id=\"Element_Physical\">Physical</> damage over 2 hits. [<text color=\"#D5B87C\">0.7x</>]\nLast hit applies <keyword id=\"StatusEffect_Mark\">Mark</>\nCosts 30% of current Health.\n" .. abilityValues["DefiantStrike"].PerfectionBonusDescription
    abilityValues["DefiantStrike"].PerfectionShortDescription = "400% <keyword id=\"Element_Physical\">Physical</> damage over 2 hits. [<text color=\"#D5B87C\">0.7x</>]\nLast hit applies <keyword id=\"StatusEffect_Mark\">Mark</>\nCosts 30% of current Health.\n" .. abilityValues["DefiantStrike"].PerfectionBonusDescription

    -- Blitz
    abilityValues["Blitz"] = {}
    abilityValues["Blitz"].APCost = config.BlitzAPCost
    abilityValues["Blitz"].ChargesConsumed = config.BlitzChargesConsumed
    abilityValues["Blitz"].ChargesMultiplier = config.BlitzDamagePerCharge
    abilityValues["Blitz"].OverchargeName = config.BlitzName
    abilityValues["Blitz"].OverchargeBonusDescription = "Consumes up to " .. (config.BlitzChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.BlitzDamagePerCharge) * 100) .. "% additional damage per charge."
    abilityValues["Blitz"].OverchargeLongDescription = "150% " .. GetElementString(config.BlitzElement, elementalEnum, false) .. " damage. [<text color=\"#D5B87C\">1x</>]\nKills non-boss enemies with less than 10% Health.\nPlay a second turn.\n" .. abilityValues["Blitz"].OverchargeBonusDescription
    abilityValues["Blitz"].OverchargeShortDescription = "150% " .. GetElementString(config.BlitzElement, elementalEnum, true) .. " damage. [<text color=\"#D5B87C\">1x</>]\nKills non-boss enemies with less than 10% Health.\nPlay a second turn.\n" .. abilityValues["Blitz"].OverchargeBonusDescription
    abilityValues["Blitz"].PerfectionName = "Blitz"
    abilityValues["Blitz"].PerfectionBonusDescription = "<img id=\"Rank_B\"/>: Deals 50% more damage."
    abilityValues["Blitz"].PerfectionLongDescription = "150% <keyword id=\"Element_Physical\">Physical</> damage. [<text color=\"#D5B87C\">1x</>]\nKills non-boss enemies with less than 10% Health.\nPlay a second turn.\n" .. abilityValues["Blitz"].PerfectionBonusDescription
    abilityValues["Blitz"].PerfectionShortDescription = "150% <keyword id=\"Element_Physical\">Physical</> damage. [<text color=\"#D5B87C\">1x</>]\nKills non-boss enemies with less than 10% Health.\nPlay a second turn.\n" .. abilityValues["Blitz"].PerfectionBonusDescription

    -- Follow Up
    abilityValues["FollowUp"] = {}
    abilityValues["FollowUp"].APCost = config.FollowUpAPCost
    abilityValues["FollowUp"].ChargesConsumed = config.FollowUpChargesConsumed
    abilityValues["FollowUp"].ChargesMultiplier = config.FollowUpDamagePerCharge
    abilityValues["FollowUp"].OverchargeName = config.FollowUpAPName
    abilityValues["FollowUp"].OverchargeBonusDescription = "Consumes up to " .. (config.FollowUpChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.FollowUpDamagePerCharge) * 100) .. "% additional damage per charge.\nCosts " .. (config.FollowUpAPReducedCost) .. " <keyword id=\"APShard\">AP</> if required charges are available."
    abilityValues["FollowUp"].OverchargeLongDescription = "200% " .. GetElementString(config.FollowUpElement, elementalEnum, false) .. " damage. [<text color=\"#D5B87C\">1x</>]\nDeals +50% more damage per Free Aim shot fired this turn, up to 10 times.\n" .. abilityValues["FollowUp"].OverchargeBonusDescription
    abilityValues["FollowUp"].OverchargeShortDescription = "200% " .. GetElementString(config.FollowUpElement, elementalEnum, true) .. " damage. [<text color=\"#D5B87C\">1x</>]\nDeals +50% more damage per Free Aim shot fired this turn, up to 10 times.\n" .. abilityValues["FollowUp"].OverchargeBonusDescription
    abilityValues["FollowUp"].PerfectionName = "Follow Up"
    abilityValues["FollowUp"].PerfectionBonusDescription = "<img id=\"Rank_S\"/>: Costs 2 <keyword id=\"APShard\">AP</> instead."
    abilityValues["FollowUp"].PerfectionLongDescription = "200% <keyword id=\"Element_Light\">Light</> damage. [<text color=\"#D5B87C\">1x</>]\nDeals +50% more damage per Free Aim shot fired this turn, up to 10 times.\n" .. abilityValues["FollowUp"].PerfectionBonusDescription
    abilityValues["FollowUp"].PerfectionShortDescription = "200% <keyword id=\"Element_Light\">Light</> damage. [<text color=\"#D5B87C\">1x</>]\nDeals +50% more damage per Free Aim shot fired this turn, up to 10 times.\n" .. abilityValues["FollowUp"].PerfectionBonusDescription

    -- Ascending Assault
    abilityValues["AscendingAssault"] = {}
    abilityValues["AscendingAssault"].APCost = config.AscendingAssaultAPCost
    abilityValues["AscendingAssault"].ChargesConsumed = config.AscendingAssaultChargesConsumed
    abilityValues["AscendingAssault"].ChargesMultiplier = config.AscendingAssaultDamagePerCharge
    abilityValues["AscendingAssault"].OverchargeName = config.AscendingAssaultName
    abilityValues["AscendingAssault"].OverchargeBonusDescription = "Costs " .. (config.AscendingAssaultAPReducedCost) .. " <keyword id=\"APShard\">AP</> if all charges are available."
    abilityValues["AscendingAssault"].OverchargeLongDescription = "250% " .. GetElementString(config.AscendingAssaultElement, elementalEnum, false) .. " damage. [<text color=\"#D5B87C\">1x</>]\nDeals +30% more damage per previous cast, up to 5 times.\n" .. "Initially consumes up to " .. (config.AscendingAssaultChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> and consumes up to " .. (config.AscendingAssaultAdditionalChargesConsumed) .. " more <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.AscendingAssaultDamagePerCharge) * 100) .. "% additional damage per charge after each cast.\n" .. abilityValues["AscendingAssault"].OverchargeBonusDescription
    abilityValues["AscendingAssault"].OverchargeDynamicDescriptionPiece = "for +" .. string.format("%g", (config.AscendingAssaultDamagePerCharge) * 100) .. "% additional damage per charge.\n" .. abilityValues["AscendingAssault"].OverchargeBonusDescription
    -- Do not add bonus description to short description here, this ability's short description is built dynamically to show the current amount of consumed charges in module main.lua in function ModifyAbilityCostAndDescription() during battle.
    abilityValues["AscendingAssault"].OverchargeShortDescription = "250% " .. GetElementString(config.AscendingAssaultElement, elementalEnum, true) .. " damage. [<text color=\"#D5B87C\">1x</>]\nDeals +30% more damage per previous cast, up to 5 times.\n"
    abilityValues["AscendingAssault"].PerfectionName = "Ascending Assault"
    abilityValues["AscendingAssault"].PerfectionBonusDescription = "<img id=\"Rank_S\"/>: Costs 2 <keyword id=\"APShard\">AP</> instead."
    abilityValues["AscendingAssault"].PerfectionLongDescription = "250% damage. [<text color=\"#D5B87C\">1x</>]\nUses weapon's element.\nDeals +30% more damage per previous cast, up to 5 times.\n" .. abilityValues["AscendingAssault"].PerfectionBonusDescription
    abilityValues["AscendingAssault"].PerfectionShortDescription = "250% {DynamicElement} damage. [<text color=\"#D5B87C\">1x</>]\nDeals +30% more damage per previous cast, up to 5 times.\n" .. abilityValues["AscendingAssault"].PerfectionBonusDescription

    -- Speed Burst
    abilityValues["SpeedBurst"] = {}
    abilityValues["SpeedBurst"].APCost = config.SpeedBurstAPCost
    abilityValues["SpeedBurst"].ChargesConsumed = nil
    abilityValues["SpeedBurst"].ChargesMultiplier = nil
    abilityValues["SpeedBurst"].OverchargeName = config.SpeedBurstName
    abilityValues["SpeedBurst"].OverchargeBonusDescription = "Generates " .. (config.SpeedBurstChargesPerHit) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</> per hit."
    abilityValues["SpeedBurst"].OverchargeLongDescription = "250% " .. GetElementString(config.SpeedBurstElement, elementalEnum, false) .. " damage over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\nDamage increased by Speed difference with target, up to 100% more damage.\n" .. abilityValues["SpeedBurst"].OverchargeBonusDescription
    abilityValues["SpeedBurst"].OverchargeShortDescription = "250% " .. GetElementString(config.SpeedBurstElement, elementalEnum, true) .. " damage over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\nDamage increased by Speed difference with target, up to 100% more damage.\n" .. abilityValues["SpeedBurst"].OverchargeBonusDescription
    abilityValues["SpeedBurst"].PerfectionName = "Speed Burst"
    abilityValues["SpeedBurst"].PerfectionBonusDescription = "<img id=\"Rank_C\"/>: Deals 100% more damage."
    abilityValues["SpeedBurst"].PerfectionLongDescription = "250% <keyword id=\"Element_Light\">Light</> damage over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\nDamage increased by Speed difference with target, up to 100% more damage.\n" .. abilityValues["SpeedBurst"].PerfectionBonusDescription
    abilityValues["SpeedBurst"].PerfectionShortDescription = "250% <keyword id=\"Element_Light\">Light</> damage over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\nDamage increased by Speed difference with target, up to 100% more damage.\n" .. abilityValues["SpeedBurst"].PerfectionBonusDescription

    -- Phantom Stars
    abilityValues["PhantomStars"] = {}
    abilityValues["PhantomStars"].APCost = config.PhantomStarsAPCost
    abilityValues["PhantomStars"].ChargesConsumed = config.PhantomStarsChargesConsumed
    abilityValues["PhantomStars"].ChargesMultiplier = config.PhantomStarsDamagePerCharge
    abilityValues["PhantomStars"].OverchargeName = config.PhantomStarsName
    abilityValues["PhantomStars"].OverchargeBonusDescription = "Consumes up to " .. (config.PhantomStarsChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.PhantomStarsDamagePerCharge) * 100) .. "% additional damage per charge.\nCosts " .. (config.PhantomStarsAPReducedCost) .. " <keyword id=\"APShard\">AP</> if all charges are available.\nCan <keyword id=\"Break\">Stun</> a target and refill " .. string.format("%g", (config.PhantomStarsChargesPercentage) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</> upon doing so."
    abilityValues["PhantomStars"].OverchargeLongDescription = "350% " .. GetElementString(config.PhantomStarsElement, elementalEnum, false) .. " damage to all enemies over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\n" .. abilityValues["PhantomStars"].OverchargeBonusDescription
    abilityValues["PhantomStars"].OverchargeShortDescription = "350% " .. GetElementString(config.PhantomStarsElement, elementalEnum, true) .. " damage to all enemies over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\n" .. abilityValues["PhantomStars"].OverchargeBonusDescription
    abilityValues["PhantomStars"].PerfectionName = "Phantom Stars"
    abilityValues["PhantomStars"].PerfectionBonusDescription = "<img id=\"Rank_S\"/>: Costs 5 <keyword id=\"APShard\">AP</> instead."
    abilityValues["PhantomStars"].PerfectionLongDescription = "350% <keyword id=\"Element_Light\">Light</> damage to all enemies over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\nCan <keyword id=\"Break\">Stun</>\n" .. abilityValues["PhantomStars"].PerfectionBonusDescription
    abilityValues["PhantomStars"].PerfectionShortDescription = "350% <keyword id=\"Element_Light\">Light</> damage to all enemies over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\nCan <keyword id=\"Break\">Stun</>\n" .. abilityValues["PhantomStars"].PerfectionBonusDescription

    -- Paradigm Shift
    abilityValues["ParadigmShift"] = {}
    abilityValues["ParadigmShift"].APCost = config.ParadigmShiftAPCost
    abilityValues["ParadigmShift"].ChargesConsumed = config.ParadigmShiftChargesConsumed
    abilityValues["ParadigmShift"].ChargesMultiplier = nil
    abilityValues["ParadigmShift"].OverchargeName = config.ParadigmShiftName
    abilityValues["ParadigmShift"].OverchargeBonusDescription = "Consumes " .. (config.ParadigmShiftChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> per hit to give +" .. (config.ParadigmShiftAPPerCharge) .. " <keyword id=\"APShard\">AP</> per charge."
    abilityValues["ParadigmShift"].OverchargeLongDescription = "90% " .. GetElementString(config.ParadigmShiftElement, elementalEnum, false) .. " damage over 3 hits. [<text color=\"#D5B87C\">0.7x</>]\nRecover 1-3 <keyword id=\"APShard\">AP</> on completion.\n" .. abilityValues["ParadigmShift"].OverchargeBonusDescription
    abilityValues["ParadigmShift"].OverchargeShortDescription = "90% " .. GetElementString(config.ParadigmShiftElement, elementalEnum, true) .. " damage over 3 hits. [<text color=\"#D5B87C\">0.7x</>]\nRecover 1-3 <keyword id=\"APShard\">AP</> on completion.\n" .. abilityValues["ParadigmShift"].OverchargeBonusDescription
    abilityValues["ParadigmShift"].PerfectionName = "Paradigm Shift"
    abilityValues["ParadigmShift"].PerfectionBonusDescription = "<img id=\"Rank_C\"/>: +1 more <keyword id=\"APShard\">AP</> recovered."
    abilityValues["ParadigmShift"].PerfectionLongDescription = "90% <keyword id=\"Element_Physical\">Physical</> damage over 3 hits. [<text color=\"#D5B87C\">0.7x</>]\nRecover 1-3 <keyword id=\"APShard\">AP</> on completion.\n" .. abilityValues["ParadigmShift"].PerfectionBonusDescription
    abilityValues["ParadigmShift"].PerfectionShortDescription = "90% <keyword id=\"Element_Physical\">Physical</> damage over 3 hits. [<text color=\"#D5B87C\">0.7x</>]\nRecover 1-3 <keyword id=\"APShard\">AP</> on completion.\n" .. abilityValues["ParadigmShift"].PerfectionBonusDescription

    -- Purification
    abilityValues["Purification"] = {}
    abilityValues["Purification"].APCost = config.PurificationAPCost
    abilityValues["Purification"].ChargesConsumed = config.PurificationChargesConsumed
    abilityValues["Purification"].ChargesMultiplier = config.PurificationDamagePerCharge
    abilityValues["Purification"].OverchargeName = config.PurificationName
    abilityValues["Purification"].OverchargeBonusDescription = "Consumes up to " .. (config.PurificationChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.PurificationDamagePerCharge) * 100) .. "% additional damage per charge.\nIf all charges are available, inflicts <keyword id=\"Buff_Powerless_Left\">Powerless</> for 3 turns."
    abilityValues["Purification"].OverchargeLongDescription = "250% " .. GetElementString(config.PurificationElement, elementalEnum, false) .. " damage over 2 hits. [<text color=\"#D5B87C\">0.7x</>]\nCleanse all Status Effects from Gustave upon casting.\n" .. abilityValues["Purification"].OverchargeBonusDescription
    abilityValues["Purification"].OverchargeShortDescription = "250% " .. GetElementString(config.PurificationElement, elementalEnum, true) .. " damage over 2 hits. [<text color=\"#D5B87C\">0.7x</>]\nCleanse all Status Effects from Gustave upon casting.\n" .. abilityValues["Purification"].OverchargeBonusDescription
    abilityValues["Purification"].PerfectionName = "Purification"
    abilityValues["Purification"].PerfectionBonusDescription = "<img id=\"Rank_B\"/>: Deals 100% more damage."
    abilityValues["Purification"].PerfectionLongDescription = "250% <keyword id=\"Element_Light\">Light</> damage over 2 hits. [<text color=\"#D5B87C\">0.7x</>]\nCleanse all Status Effects from Verso upon casting.\n" .. abilityValues["Purification"].PerfectionBonusDescription
    abilityValues["Purification"].PerfectionShortDescription = "250% <keyword id=\"Element_Light\">Light</> damage over 2 hits. [<text color=\"#D5B87C\">0.7x</>]\nCleanse all Status Effects from Verso upon casting.\n" .. abilityValues["Purification"].PerfectionBonusDescription

    -- Angel's Eyes
    abilityValues["AngelsEyes"] = {}
    abilityValues["AngelsEyes"].APCost = 3 -- This is the gradient cost, modifiying this is not recommended.
    abilityValues["AngelsEyes"].ChargesConsumed = nil
    abilityValues["AngelsEyes"].ChargesMultiplier = nil
    abilityValues["AngelsEyes"].OverchargeName = nil
    abilityValues["AngelsEyes"].OverchargeBonusDescription = "Generates " .. (config.AngelsEyesAdditionalChargesPerHit or 3) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</> per hit."
    abilityValues["AngelsEyes"].OverchargeLongDescription = "800% <keyword id=\"Element_Physical\">Physical</> damage over 8 hits. [<text color=\"#D5B87C\">0.1x</>]\nGain Aureole, reviving Gustave if he dies.\n" .. abilityValues["AngelsEyes"].OverchargeBonusDescription
    abilityValues["AngelsEyes"].OverchargeShortDescription = "800% <keyword id=\"Element_Physical\">Physical</> damage over 8 hits. [<text color=\"#D5B87C\">0.1x</>]\nGain Aureole, reviving Gustave if he dies.\n" .. abilityValues["AngelsEyes"].OverchargeBonusDescription
    abilityValues["AngelsEyes"].PerfectionName = nil
    abilityValues["AngelsEyes"].PerfectionBonusDescription = "Generates 1 additional <keyword id=\"Perfection\">Perfection</> per hit."
    abilityValues["AngelsEyes"].PerfectionLongDescription = "800% <keyword id=\"Element_Physical\">Physical</> damage over 8 hits. [<text color=\"#D5B87C\">0.1x</>]\nGain Aureole, reviving Verso if he dies.\n" .. abilityValues["AngelsEyes"].PerfectionBonusDescription
    abilityValues["AngelsEyes"].PerfectionShortDescription = "800% <keyword id=\"Element_Physical\">Physical</> damage over 8 hits. [<text color=\"#D5B87C\">0.1x</>]\nGain Aureole, reviving Verso if he dies.\n" .. abilityValues["AngelsEyes"].PerfectionBonusDescription

    log("Initialized abilityValues array in skills.lua successfully!")
end

-- This function returns the settings of the requested ability like AP cost, consumed charges, damage multiplier per charge and dynamic descriptions.
local function GetAbilityValues(abilityNameID)
    return abilityValues[abilityNameID]
end

-- Expose the functions to main.lua.
return
{
    Init = Init,
    GetAbilityValues = GetAbilityValues,
}