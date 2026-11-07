
--[[
------- Overcharge Reimagined v4.1 - By Killera -------

        This module handles all the ability descriptions and settings like AP cost, consumed charges and damage per charge.
        The descriptions are quite difficult to read because of all the variables and the formatting needed.
        But if this isn't an issue to you then you can feel free to modify and translate this to a different language if you desire.
        I will happily add it to the official repository and make the translation available as an extra download.

        This is a version with more detailed ability descriptions, as it was a request by some users so that they match the detailed descriptions of another mod.

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
    abilityValues["UnleashCharge"].OverchargeLongDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>150% " .. GetElementString(config.OverchargeElement, elementalEnum, false) .. " damage.\n" .. "Consumes all <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", 20 + (config.OverchargeDamagePerCharge * 100)) .. "%-" .. string.format("%g", 40 + ((config.OverchargeDamagePerCharge) * 100)) .. "% damage per charge.\nDeals +" .. string.format("%g", (config.OverchargeMaxChargesBonus * 100)) .. "% additional damage if charges are at max.\n" .. abilityValues["UnleashCharge"].OverchargeBonusDescription
    abilityValues["UnleashCharge"].OverchargeShortDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>150% " .. GetElementString(config.OverchargeElement, elementalEnum, true) .. " damage.\n" .. "Consumes all <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", 20 + (config.OverchargeDamagePerCharge * 100)) .. "%-" .. string.format("%g", 40 + ((config.OverchargeDamagePerCharge) * 100)) .. "% damage per charge.\nDeals +" .. string.format("%g", (config.OverchargeMaxChargesBonus * 100)) .. "% additional damage if charges are at max.\n" .. abilityValues["UnleashCharge"].OverchargeBonusDescription
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
    abilityValues["PerfectBreak_Gustave"].OverchargeLongDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>175% " .. GetElementString(config.ShatterElement, elementalEnum, false) .. " damage to all enemies.\nConsumes all <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.ShatterDamagePerCharge) * 100) .. "% damage per charge.\nDeals +" .. string.format("%g", (config.ShatterMaxChargesBonus) * 100) .. "% additional damage if charges are at max.\n" .. abilityValues["PerfectBreak_Gustave"].OverchargeBonusDescription
    abilityValues["PerfectBreak_Gustave"].OverchargeShortDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>175% " .. GetElementString(config.ShatterElement, elementalEnum, true) .. " damage to all enemies.\nConsumes all <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.ShatterDamagePerCharge) * 100) .. "% damage per charge.\nDeals +" .. string.format("%g", (config.ShatterMaxChargesBonus) * 100) .. "% additional damage if charges are at max.\n" .. abilityValues["PerfectBreak_Gustave"].OverchargeBonusDescription
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
    abilityValues["MarkingShot_Gustave"].OverchargeLongDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/> 100% " .. GetElementString(config.MarkingShotElement, elementalEnum, false) .. " damage.\nConsumes all <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.MarkingShotDamagePerCharge) * 100) .. "% damage and +" .. string.format("%g", (config.MarkingShotMaxStunChance / config.VirtualMaxCharges) * 100) .."% chance to instantly <keyword id=\"Break\">Stun</> per charge.\nDeals +" .. string.format("%g", (config.MarkingShotMaxChargesBonus) * 100) .. "% additional damage if charges are at max.\n" .. abilityValues["MarkingShot_Gustave"].OverchargeBonusDescription
    abilityValues["MarkingShot_Gustave"].OverchargeDynamicDescriptionPiece = "% chance to instantly <keyword id=\"Break\">Stun</>\n" .. abilityValues["MarkingShot_Gustave"].OverchargeBonusDescription
    -- Do not add bonus description to short description here, this ability's short description is built dynamically to show the current stun chance in module main.lua in function ModifyAbilityCostAndDescription() during battle.
    abilityValues["MarkingShot_Gustave"].OverchargeShortDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/> 100% " .. GetElementString(config.MarkingShotElement, elementalEnum, true) .. " damage.\nConsumes all <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.MarkingShotDamagePerCharge) * 100) .. "% damage per charge.\nDeals +" .. string.format("%g", (config.MarkingShotMaxChargesBonus) * 100) .. "% additional damage if charges are at max."
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
    abilityValues["Combo1_Gustave"].OverchargeBonusDescription = "Can <keyword id=\"Break\">Stun</>\n<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.LumiereAssaultChargesPerCritical) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>"
    abilityValues["Combo1_Gustave"].OverchargeLongDescription = "<text color=\"#D9C084\">0.3x</><img id=\"Break\"/>125% " .. GetElementString(config.LumiereAssaultElement, elementalEnum, false) .. " damage over 5 hits.\nGets interrupted if failed.\n" .. abilityValues["Combo1_Gustave"].OverchargeBonusDescription
    abilityValues["Combo1_Gustave"].OverchargeShortDescription = "<text color=\"#D9C084\">0.3x</><img id=\"Break\"/>125% " .. GetElementString(config.LumiereAssaultElement, elementalEnum, true) .. " damage over 5 hits.\nGets interrupted if failed.\n" .. abilityValues["Combo1_Gustave"].OverchargeBonusDescription
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
    abilityValues["StrikeStorm_Gustave"].OverchargeBonusDescription = "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.StrikeStormChargesPerCritical) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>"
    abilityValues["StrikeStorm_Gustave"].OverchargeLongDescription = "<text color=\"#D9C084\">0.3x</><img id=\"Break\"/>420% " .. GetElementString(config.StrikeStormElement, elementalEnum, false) .. " damage over 6 hits.\nGets interrupted if failed.\n" .. abilityValues["StrikeStorm_Gustave"].OverchargeBonusDescription
    abilityValues["StrikeStorm_Gustave"].OverchargeShortDescription = "<text color=\"#D9C084\">0.3x</><img id=\"Break\"/>420% " .. GetElementString(config.StrikeStormElement, elementalEnum, true) .. " damage over 6 hits.\nGets interrupted if failed.\n" .. abilityValues["StrikeStorm_Gustave"].OverchargeBonusDescription
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
    abilityValues["FromFire_Gustave"].OverchargeBonusDescription = "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.FromFireChargesPerCritical) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>\n" .. "Consumes up to " .. (config.FromFireChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> for +" .. string.format("%g", (config.FromFireDamagePerCharge or 0.2) * 100) .. "% additional damage and grants +" .. string.format("%g", (config.FromFireHealPerCharge or 0.01) * 100) .. "% <keyword id=\"Heal\">heal</> per charge."
    abilityValues["FromFire_Gustave"].OverchargeLongDescription = "<text color=\"#D9C084\">0.5x</><img id=\"Break\"/>187.5% " .. GetElementString(config.FromFireElement, elementalEnum, false) .. " damage over 3 hits.\n" .. "After cast, if this hit a <keyword id=\"StatusEffect_Burn\">Burning</> enemy, <keyword id=\"Heal\">heal</> 20% of max health.\n" .. abilityValues["FromFire_Gustave"].OverchargeBonusDescription
    abilityValues["FromFire_Gustave"].OverchargeShortDescription = "<text color=\"#D9C084\">0.5x</><img id=\"Break\"/>187.5% " .. GetElementString(config.FromFireElement, elementalEnum, true) .. " damage over 3 hits.\n" .. "After cast, if this hit a <keyword id=\"StatusEffect_Burn\">Burning</> enemy, <keyword id=\"Heal\">heal</> 20% of max health.\n" .. abilityValues["FromFire_Gustave"].OverchargeBonusDescription
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
    abilityValues["PerfectRecovery_Gustave"].OverchargeBonusDescription = "Generates 0 - " .. string.format("%g", (config.VirtualMaxCharges * config.RecoveryChargesPercentage)) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> upon being used."
    abilityValues["PerfectRecovery_Gustave"].OverchargeLongDescription = "<keyword id=\"Heal\">Heal</> 50% of max health and cleanse status effects.\n" .. abilityValues["PerfectRecovery_Gustave"].OverchargeBonusDescription
    abilityValues["PerfectRecovery_Gustave"].OverchargeShortDescription = "<keyword id=\"Heal\">Heal</> 50% of max health and cleanse status effects.\n" .. abilityValues["PerfectRecovery_Gustave"].OverchargeBonusDescription
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
    abilityValues["Powerful_Gustave"].OverchargeLongDescription = "Apply <keyword id=\"Buff_Powerful_Left\">Powerful</> to self and 0-2 allies for 3 turns.\n" .. abilityValues["Powerful_Gustave"].OverchargeBonusDescription ..
                                                                string.format("%g", (config.PowerfulChargesConsumed) * 0.2) .. " Charges: Apply <keyword id=\"Buff_Shell_Left\">Shell</> for 3 turns.\n" ..
                                                                string.format("%g", (config.PowerfulChargesConsumed) * 0.4) .. " Charges: Apply <keyword id=\"Buff_Rush_Left\">Rush</> for 3 turns.\n" ..
                                                                string.format("%g", (config.PowerfulChargesConsumed) * 0.6) .. " Charges: Apply <keyword id=\"StatusEffect_Berserk_Left\">Berserk</> for 3 turns.\n" ..
                                                                string.format("%g", (config.PowerfulChargesConsumed) * 0.8) .. " Charges: Increase turn duration to 6.\n" ..
                                                                (config.PowerfulChargesConsumed) .. " Charges: Apply <keyword id=\"StatusEffect_Enraged_Left\">Rage</> for 1 turn."
    abilityValues["Powerful_Gustave"].OverchargeShortDescription = "Apply <keyword id=\"Buff_Powerful_Left\">Powerful</> to self and 0-2 allies for 3 turns.\n" .. abilityValues["Powerful_Gustave"].OverchargeBonusDescription ..
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
    abilityValues["OldLightHolder"].OverchargeLongDescription = "<text color=\"#D9C084\">0.3x</><img id=\"Break\"/>345% " .. GetElementString(config.LightHolderElement, elementalEnum, false) .. " damage over 5 hits.\nGets interrupted if failed.\n" .. "Deals +" .. string.format("%g", (config.LightHolderDamagePerHealthChunk) * 100) .. "% additional damage per " .. (config.LightHolderHealthChunkSize) .. " max health.\n" .. abilityValues["OldLightHolder"].OverchargeBonusDescription
    abilityValues["OldLightHolder"].OverchargeShortDescription = "<text color=\"#D9C084\">0.3x</><img id=\"Break\"/>345% " .. GetElementString(config.LightHolderElement, elementalEnum, true) .. " damage over 5 hits.\nGets interrupted if failed.\n" .. "Deals +" .. string.format("%g", (config.LightHolderDamagePerHealthChunk) * 100) .. "% additional damage per " .. (config.LightHolderHealthChunkSize) .. " max health.\n" .. abilityValues["OldLightHolder"].OverchargeBonusDescription
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
    abilityValues["RadiantStrike"].OverchargeBonusDescription = "Consumes up to " .. (config.RadiantStrikeChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> for +" .. string.format("%g", (config.RadiantStrikeDamagePerCharge) * 100) .. "% additional damage per charge.\nIf all charges are available, inflicts 5 <keyword id=\"StatusEffect_Burn\">Burn</>"
    abilityValues["RadiantStrike"].OverchargeLongDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>140% " .. GetElementString(config.RadiantStrikeElement, elementalEnum, false) .. " damage to all enemies.\n" .. abilityValues["RadiantStrike"].OverchargeBonusDescription
    abilityValues["RadiantStrike"].OverchargeShortDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>140% " .. GetElementString(config.RadiantStrikeElement, elementalEnum, true) .. " damage to all enemies.\n" .. abilityValues["RadiantStrike"].OverchargeBonusDescription
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
    abilityValues["Overcharge"].OverchargeBonusDescription = "Refill " .. string.format("%g", (config.OverloadChargesPercentage) * 100) .. "% of missing <keyword id=\"Gustave_Charges\">Charges</> from " .. config.VirtualMaxCharges .. "."
    abilityValues["Overcharge"].OverchargeLongDescription = "Set current health to 1. Recover all <keyword id=\"APShard\">AP</>\n" .. abilityValues["Overcharge"].OverchargeBonusDescription
    abilityValues["Overcharge"].OverchargeShortDescription = "Set current health to 1. Recover all <keyword id=\"APShard\">AP</>\n" .. abilityValues["Overcharge"].OverchargeBonusDescription
    abilityValues["Overcharge"].PerfectionName = "Overload"
    abilityValues["Overcharge"].PerfectionBonusDescription = ""
    abilityValues["Overcharge"].PerfectionLongDescription = "Set current health to 1. Recover all <keyword id=\"APShard\">AP</> and set rank to <img id=\"Rank_A\"/>" .. abilityValues["Overcharge"].PerfectionBonusDescription
    abilityValues["Overcharge"].PerfectionShortDescription = "Set current health to 1. Recover all <keyword id=\"APShard\">AP</> and set rank to <img id=\"Rank_A\"/>" .. abilityValues["Overcharge"].PerfectionBonusDescription

    -- Steeled Strike
    abilityValues["SteeledStrike"] = {}
    abilityValues["SteeledStrike"].APCost = config.SteeledStrikeAPCost
    abilityValues["SteeledStrike"].ChargesConsumed = config.SteeledStrikeChargesConsumed
    abilityValues["SteeledStrike"].ChargesMultiplier = config.SteeledStrikeDamagePerCharge
    abilityValues["SteeledStrike"].OverchargeName = config.SteeledStrikeName
    abilityValues["SteeledStrike"].OverchargeBonusDescription = "Consumes up to " .. (config.SteeledStrikeChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> for +" .. string.format("%g", (config.SteeledStrikeDamagePerCharge) * 100) .. "% additional damage per charge."
    abilityValues["SteeledStrike"].OverchargeLongDescription = "<text color=\"#D9C084\">0.1x</><img id=\"Break\"/>Next turn, deals 650% " .. GetElementString(config.SteeledStrikeElement, elementalEnum, false) .. " damage over 13 hits.\nInterrupted if hit.\n" .. abilityValues["SteeledStrike"].OverchargeBonusDescription
    abilityValues["SteeledStrike"].OverchargeShortDescription = "<text color=\"#D9C084\">0.1x</><img id=\"Break\"/>Next turn, deals 650% " .. GetElementString(config.SteeledStrikeElement, elementalEnum, true) .. " damage over 13 hits.\nInterrupted if hit.\n" .. abilityValues["SteeledStrike"].OverchargeBonusDescription
    abilityValues["SteeledStrike"].PerfectionName = "Steeled Strike"
    abilityValues["SteeledStrike"].PerfectionBonusDescription = "<img id=\"Rank_S\"/>: deals 150% more damage."
    abilityValues["SteeledStrike"].PerfectionLongDescription = "<text color=\"#D9C084\">0.1x</><img id=\"Break\"/>Next turn, deals 650% <keyword id=\"Element_Physical\">Physical</> damage over 13 hits.\nInterrupted if hit.\n" .. abilityValues["SteeledStrike"].PerfectionBonusDescription
    abilityValues["SteeledStrike"].PerfectionShortDescription = "<text color=\"#D9C084\">0.1x</><img id=\"Break\"/>Next turn, deals 650% <keyword id=\"Element_Physical\">Physical</> damage over 13 hits.\nInterrupted if hit.\n" .. abilityValues["SteeledStrike"].PerfectionBonusDescription

    -- Endbringer
    abilityValues["EndBringer"] = {}
    abilityValues["EndBringer"].APCost = config.EndbringerAPCost
    abilityValues["EndBringer"].ChargesConsumed = nil
    abilityValues["EndBringer"].ChargesMultiplier = nil
    abilityValues["EndBringer"].OverchargeName = config.EndbringerName
    abilityValues["EndBringer"].OverchargeBonusDescription = "<keyword id=\"StatusEffect_Stunned\">Stun Hits</> generate " .. (config.EndbringerChargesPerStunnedHit) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>"
    abilityValues["EndBringer"].OverchargeLongDescription = "<text color=\"#D9C084\">0.2x</><img id=\"Break\"/>720% " .. GetElementString(config.EndbringerElement, elementalEnum, false) .. " damage over 6 hits.\nDeals 200% more damage to <keyword id=\"StatusEffect_Stunned\">Stunned</> enemies.\n" .. abilityValues["EndBringer"].OverchargeBonusDescription
    abilityValues["EndBringer"].OverchargeShortDescription = "<text color=\"#D9C084\">0.2x</><img id=\"Break\"/>720% " .. GetElementString(config.EndbringerElement, elementalEnum, true) .. " damage over 6 hits.\nDeals 200% more damage to <keyword id=\"StatusEffect_Stunned\">Stunned</> enemies.\n" .. abilityValues["EndBringer"].OverchargeBonusDescription
    abilityValues["EndBringer"].PerfectionName = "Endbringer"
    abilityValues["EndBringer"].PerfectionBonusDescription = "<img id=\"Rank_A\"/>: can reapply <keyword id=\"StatusEffect_Stunned\">Stun</>"
    abilityValues["EndBringer"].PerfectionLongDescription = "<text color=\"#D9C084\">0.2x</><img id=\"Break\"/>720% <keyword id=\"Element_Physical\">Physical</> damage over 6 hits.\nDeals 200% more damage to <keyword id=\"StatusEffect_Stunned\">Stunned</> enemies.\n" .. abilityValues["EndBringer"].PerfectionBonusDescription
    abilityValues["EndBringer"].PerfectionShortDescription = "<text color=\"#D9C084\">0.2x</><img id=\"Break\"/>720% <keyword id=\"Element_Physical\">Physical</> damage over 6 hits.\nDeals 200% more damage to <keyword id=\"StatusEffect_Stunned\">Stunned</> enemies.\n" .. abilityValues["EndBringer"].PerfectionBonusDescription

    -- Berserk Slash
    abilityValues["BerserkSlash"] = {}
    abilityValues["BerserkSlash"].APCost = config.BerserkSlashAPCost
    abilityValues["BerserkSlash"].ChargesConsumed = config.BerserkSlashChargesConsumed
    abilityValues["BerserkSlash"].ChargesMultiplier = config.BerserkSlashDamagePerCharge
    abilityValues["BerserkSlash"].OverchargeName = config.BerserkSlashName
    abilityValues["BerserkSlash"].OverchargeBonusDescription = "Consumes up to " .. (config.BerserkSlashChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.BerserkSlashDamagePerCharge) * 100) .. "% additional damage per charge."
    abilityValues["BerserkSlash"].OverchargeLongDescription = "<text color=\"#D9C084\">0.5x</><img id=\"Break\"/>60% " .. GetElementString(config.BerserkSlashElement, elementalEnum, false) .. " damage over 3 hits.\nDeals +15% more damage per missing health %.\n" .. abilityValues["BerserkSlash"].OverchargeBonusDescription
    abilityValues["BerserkSlash"].OverchargeShortDescription = "<text color=\"#D9C084\">0.5x</><img id=\"Break\"/>60% " .. GetElementString(config.BerserkSlashElement, elementalEnum, true) .. " damage over 3 hits.\nDeals +15% more damage per missing health %.\n" .. abilityValues["BerserkSlash"].OverchargeBonusDescription
    abilityValues["BerserkSlash"].PerfectionName = "Berserk Slash"
    abilityValues["BerserkSlash"].PerfectionBonusDescription = "<img id=\"Rank_C\"/>: deals 50% more damage."
    abilityValues["BerserkSlash"].PerfectionLongDescription = "<text color=\"#D9C084\">0.5x</><img id=\"Break\"/>60% <keyword id=\"Element_Physical\">Physical</> damage over 3 hits.\nDeals +15% more damage per missing health %.\n" .. abilityValues["BerserkSlash"].PerfectionBonusDescription
    abilityValues["BerserkSlash"].PerfectionShortDescription = "<text color=\"#D9C084\">0.5x</><img id=\"Break\"/>60% <keyword id=\"Element_Physical\">Physical</> damage over 3 hits.\nDeals +15% more damage per missing health %.\n" .. abilityValues["BerserkSlash"].PerfectionBonusDescription

    -- Defiant Strike
    abilityValues["DefiantStrike"] = {}
    abilityValues["DefiantStrike"].APCost = config.DefiantStrikeAPCost
    abilityValues["DefiantStrike"].ChargesConsumed = nil
    abilityValues["DefiantStrike"].ChargesMultiplier = nil
    abilityValues["DefiantStrike"].OverchargeName = config.DefiantStrikeName
    abilityValues["DefiantStrike"].OverchargeBonusDescription = "Generates " .. string.format("%g", (config.VirtualMaxCharges * config.DefiantStrikeChargesPercentage)) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> upon being used."
    abilityValues["DefiantStrike"].OverchargeLongDescription = "<text color=\"#D9C084\">0.7x</><img id=\"Break\"/>400% " .. GetElementString(config.DefiantStrikeElement, elementalEnum, false) .. " damage over 2 hits. Costs 30% of current health to cast.\nLast hit applies <keyword id=\"StatusEffect_Mark\">Mark</>\n" .. abilityValues["DefiantStrike"].OverchargeBonusDescription
    abilityValues["DefiantStrike"].OverchargeShortDescription = "<text color=\"#D9C084\">0.7x</><img id=\"Break\"/>400% " .. GetElementString(config.DefiantStrikeElement, elementalEnum, true) .. " damage over 2 hits. Costs 30% of current health to cast.\nLast hit applies <keyword id=\"StatusEffect_Mark\">Mark</>\n" .. abilityValues["DefiantStrike"].OverchargeBonusDescription
    abilityValues["DefiantStrike"].PerfectionName = "Defiant Strike"
    abilityValues["DefiantStrike"].PerfectionBonusDescription = "<img id=\"Rank_B\"/>: deals 50% more damage."
    abilityValues["DefiantStrike"].PerfectionLongDescription = "<text color=\"#D9C084\">0.7x</><img id=\"Break\"/>400% <keyword id=\"Element_Physical\">Physical</> damage over 2 hits. Costs 30% of current health to cast.\nLast hit applies <keyword id=\"StatusEffect_Mark\">Mark</>\n" .. abilityValues["DefiantStrike"].PerfectionBonusDescription
    abilityValues["DefiantStrike"].PerfectionShortDescription = "<text color=\"#D9C084\">0.7x</><img id=\"Break\"/>400% <keyword id=\"Element_Physical\">Physical</> damage over 2 hits. Costs 30% of current health to cast.\nLast hit applies <keyword id=\"StatusEffect_Mark\">Mark</>\n" .. abilityValues["DefiantStrike"].PerfectionBonusDescription

    -- Blitz
    abilityValues["Blitz"] = {}
    abilityValues["Blitz"].APCost = config.BlitzAPCost
    abilityValues["Blitz"].ChargesConsumed = config.BlitzChargesConsumed
    abilityValues["Blitz"].ChargesMultiplier = config.BlitzDamagePerCharge
    abilityValues["Blitz"].OverchargeName = config.BlitzName
    abilityValues["Blitz"].OverchargeBonusDescription = "Consumes up to " .. (config.BlitzChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> for +" .. string.format("%g", (config.BlitzDamagePerCharge) * 100) .. "% additional damage per charge."
    abilityValues["Blitz"].OverchargeLongDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>150% " .. GetElementString(config.BlitzElement, elementalEnum, false) .. " damage.\nKills non-boss enemies with less than 10% health on hit.\nPlay an extra turn.\n" .. abilityValues["Blitz"].OverchargeBonusDescription
    abilityValues["Blitz"].OverchargeShortDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>150% " .. GetElementString(config.BlitzElement, elementalEnum, true) .. " damage.\nKills non-boss enemies with less than 10% health on hit.\nPlay an extra turn.\n" .. abilityValues["Blitz"].OverchargeBonusDescription
    abilityValues["Blitz"].PerfectionName = "Blitz"
    abilityValues["Blitz"].PerfectionBonusDescription = "<img id=\"Rank_B\"/>: deals 50% more damage."
    abilityValues["Blitz"].PerfectionLongDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>150% <keyword id=\"Element_Physical\">Physical</> damage.\nKills non-boss enemies with less than 10% health on hit.\nPlay an extra turn.\n" .. abilityValues["Blitz"].PerfectionBonusDescription
    abilityValues["Blitz"].PerfectionShortDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>150% <keyword id=\"Element_Physical\">Physical</> damage.\nKills non-boss enemies with less than 10% health on hit.\nPlay an extra turn.\n" .. abilityValues["Blitz"].PerfectionBonusDescription

    -- Follow Up
    abilityValues["FollowUp"] = {}
    abilityValues["FollowUp"].APCost = config.FollowUpAPCost
    abilityValues["FollowUp"].ChargesConsumed = config.FollowUpChargesConsumed
    abilityValues["FollowUp"].ChargesMultiplier = config.FollowUpDamagePerCharge
    abilityValues["FollowUp"].OverchargeName = config.FollowUpAPName
    abilityValues["FollowUp"].OverchargeBonusDescription = "Consumes up to " .. (config.FollowUpChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> for +" .. string.format("%g", (config.FollowUpDamagePerCharge) * 100) .. "% additional damage per charge.\nIf all charges are available, cost reduced to " .. (config.FollowUpAPReducedCost) .. " <keyword id=\"APShard\">AP</>"
    abilityValues["FollowUp"].OverchargeLongDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>200% " .. GetElementString(config.FollowUpElement, elementalEnum, false) .. " damage.\nDeals +50% more damage per Free aim shot hit this turn, up to 10 times.\n" .. abilityValues["FollowUp"].OverchargeBonusDescription
    abilityValues["FollowUp"].OverchargeShortDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>200% " .. GetElementString(config.FollowUpElement, elementalEnum, true) .. " damage.\nDeals +50% more damage per Free aim shot hit this turn, up to 10 times.\n" .. abilityValues["FollowUp"].OverchargeBonusDescription
    abilityValues["FollowUp"].PerfectionName = "Follow Up"
    abilityValues["FollowUp"].PerfectionBonusDescription = "<img id=\"Rank_S\"/>: cost reduced to 2 <keyword id=\"APShard\">AP</>"
    abilityValues["FollowUp"].PerfectionLongDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>200% <keyword id=\"Element_Light\">Light</> damage.\nDeals +50% more damage per Free aim shot hit this turn, up to 10 times.\n" .. abilityValues["FollowUp"].PerfectionBonusDescription
    abilityValues["FollowUp"].PerfectionShortDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>200% <keyword id=\"Element_Light\">Light</> damage.\nDeals +50% more damage per Free aim shot hit this turn, up to 10 times.\n" .. abilityValues["FollowUp"].PerfectionBonusDescription

    -- Ascending Assault
    abilityValues["AscendingAssault"] = {}
    abilityValues["AscendingAssault"].APCost = config.AscendingAssaultAPCost
    abilityValues["AscendingAssault"].ChargesConsumed = config.AscendingAssaultChargesConsumed
    abilityValues["AscendingAssault"].ChargesMultiplier = config.AscendingAssaultDamagePerCharge
    abilityValues["AscendingAssault"].OverchargeName = config.AscendingAssaultName
    abilityValues["AscendingAssault"].OverchargeBonusDescription = "If all charges are available, cost reduced to " .. (config.AscendingAssaultAPReducedCost) .. " <keyword id=\"APShard\">AP</>"
    abilityValues["AscendingAssault"].OverchargeLongDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>250% " .. GetElementString(config.AscendingAssaultElement, elementalEnum, false) .. " damage.\nDeals +30% more damage (max 150%) for each previous cast.\nInitially consumes up to " .. (config.AscendingAssaultChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> and consumes up to " .. (config.AscendingAssaultAdditionalChargesConsumed) .. " more <keyword id=\"Gustave_Charges\">Charge(s)</> per cast for +" .. string.format("%g", (config.AscendingAssaultDamagePerCharge) * 100) .. "% additional damage per charge.\n" .. abilityValues["AscendingAssault"].OverchargeBonusDescription
    abilityValues["AscendingAssault"].OverchargeDynamicDescriptionPiece = "for +" .. string.format("%g", (config.AscendingAssaultDamagePerCharge) * 100) .. "% additional damage per charge.\n" .. abilityValues["AscendingAssault"].OverchargeBonusDescription
    -- Do not add bonus description to short description here, this ability's short description is built dynamically to show the current amount of consumed charges in module main.lua in function ModifyAbilityCostAndDescription() during battle.
    abilityValues["AscendingAssault"].OverchargeShortDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>250% " .. GetElementString(config.AscendingAssaultElement, elementalEnum, true) .. " damage.\nDeals +30% more damage (max 150%) for each previous cast.\n"
    abilityValues["AscendingAssault"].PerfectionName = "Ascending Assault"
    abilityValues["AscendingAssault"].PerfectionBonusDescription = "<img id=\"Rank_S\"/>: cost reduced to 2 <keyword id=\"APShard\">AP</>"
    abilityValues["AscendingAssault"].PerfectionLongDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>250% damage as weapon's element.\nDeals +30% more damage (max 150%) for each previous cast.\n" .. abilityValues["AscendingAssault"].PerfectionBonusDescription
    abilityValues["AscendingAssault"].PerfectionShortDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>250% {DynamicElement} damage.\nDeals +30% more damage (max 150%) for each previous cast.\n" .. abilityValues["AscendingAssault"].PerfectionBonusDescription

    -- Speed Burst
    abilityValues["SpeedBurst"] = {}
    abilityValues["SpeedBurst"].APCost = config.SpeedBurstAPCost
    abilityValues["SpeedBurst"].ChargesConsumed = nil
    abilityValues["SpeedBurst"].ChargesMultiplier = nil
    abilityValues["SpeedBurst"].OverchargeName = config.SpeedBurstName
    abilityValues["SpeedBurst"].OverchargeBonusDescription = "Generates " .. (config.SpeedBurstChargesPerHit) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</> per hit."
    abilityValues["SpeedBurst"].OverchargeLongDescription = "<text color=\"#D9C084\">0.3x</><img id=\"Break\"/>250% " .. GetElementString(config.SpeedBurstElement, elementalEnum, false) .. " damage over 5 hits.\nDamage increased by Speed difference with enemy, up to 100% more.\n" .. abilityValues["SpeedBurst"].OverchargeBonusDescription
    abilityValues["SpeedBurst"].OverchargeShortDescription = "<text color=\"#D9C084\">0.3x</><img id=\"Break\"/>250% " .. GetElementString(config.SpeedBurstElement, elementalEnum, true) .. " damage over 5 hits.\nDamage increased by Speed difference with enemy, up to 100% more.\n" .. abilityValues["SpeedBurst"].OverchargeBonusDescription
    abilityValues["SpeedBurst"].PerfectionName = "Speed Burst"
    abilityValues["SpeedBurst"].PerfectionBonusDescription = "<img id=\"Rank_C\"/>: deals 100% more damage."
    abilityValues["SpeedBurst"].PerfectionLongDescription = "<text color=\"#D9C084\">0.3x</><img id=\"Break\"/>250% <keyword id=\"Element_Light\">Light</> damage over 5 hits.\nDamage increased by Speed difference with enemy, up to 100% more.\n" .. abilityValues["SpeedBurst"].PerfectionBonusDescription
    abilityValues["SpeedBurst"].PerfectionShortDescription = "<text color=\"#D9C084\">0.3x</><img id=\"Break\"/>250% <keyword id=\"Element_Light\">Light</> damage over 5 hits.\nDamage increased by Speed difference with enemy, up to 100% more.\n" .. abilityValues["SpeedBurst"].PerfectionBonusDescription

    -- Phantom Stars
    abilityValues["PhantomStars"] = {}
    abilityValues["PhantomStars"].APCost = config.PhantomStarsAPCost
    abilityValues["PhantomStars"].ChargesConsumed = config.PhantomStarsChargesConsumed
    abilityValues["PhantomStars"].ChargesMultiplier = config.PhantomStarsDamagePerCharge
    abilityValues["PhantomStars"].OverchargeName = config.PhantomStarsName
    abilityValues["PhantomStars"].OverchargeBonusDescription = "Consumes up to " .. (config.PhantomStarsChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> for +" .. string.format("%g", (config.PhantomStarsDamagePerCharge) * 100) .. "% additional damage per charge.\nIf all charges are available, cost reduced to " .. (config.PhantomStarsAPReducedCost) .. " <keyword id=\"APShard\">AP</>\nCan <keyword id=\"Break\">Stun</> a target and refill " .. string.format("%g", (config.PhantomStarsChargesPercentage) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</> upon doing so."
    abilityValues["PhantomStars"].OverchargeLongDescription = "<text color=\"#D9C084\">0.3x</><img id=\"Break\"/>350% " .. GetElementString(config.PhantomStarsElement, elementalEnum, false) .. " damage to all enemies over 5 hits.\n" .. abilityValues["PhantomStars"].OverchargeBonusDescription
    abilityValues["PhantomStars"].OverchargeShortDescription = "<text color=\"#D9C084\">0.3x</><img id=\"Break\"/>350% " .. GetElementString(config.PhantomStarsElement, elementalEnum, true) .. " damage to all enemies over 5 hits.\n" .. abilityValues["PhantomStars"].OverchargeBonusDescription
    abilityValues["PhantomStars"].PerfectionName = "Phantom Stars"
    abilityValues["PhantomStars"].PerfectionBonusDescription = "<img id=\"Rank_S\"/>: cost reduced to 5 <keyword id=\"APShard\">AP</>"
    abilityValues["PhantomStars"].PerfectionLongDescription = "<text color=\"#D9C084\">0.3x</><img id=\"Break\"/>350% <keyword id=\"Element_Light\">Light</> damage to all enemies over 5 hits.\nCan <keyword id=\"StatusEffect_Stunned\">Stun</>\n" .. abilityValues["PhantomStars"].PerfectionBonusDescription
    abilityValues["PhantomStars"].PerfectionShortDescription = "<text color=\"#D9C084\">0.3x</><img id=\"Break\"/>350% <keyword id=\"Element_Light\">Light</> damage to all enemies over 5 hits.\nCan <keyword id=\"StatusEffect_Stunned\">Stun</>\n" .. abilityValues["PhantomStars"].PerfectionBonusDescription

    -- Paradigm Shift
    abilityValues["ParadigmShift"] = {}
    abilityValues["ParadigmShift"].APCost = config.ParadigmShiftAPCost
    abilityValues["ParadigmShift"].ChargesConsumed = config.ParadigmShiftChargesConsumed
    abilityValues["ParadigmShift"].ChargesMultiplier = nil
    abilityValues["ParadigmShift"].OverchargeName = config.ParadigmShiftName
    abilityValues["ParadigmShift"].OverchargeBonusDescription = "Consumes " .. (config.ParadigmShiftChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> per hit to recover +" .. (config.ParadigmShiftAPPerCharge) .. " <keyword id=\"APShard\">AP</> per charge."
    abilityValues["ParadigmShift"].OverchargeLongDescription = "<text color=\"#D9C084\">0.7x</><img id=\"Break\"/>90% " .. GetElementString(config.ParadigmShiftElement, elementalEnum, false) .. " damage over 3 hits.\nAfter cast, recover 1-4 <keyword id=\"APShard\">AP</>\n" .. abilityValues["ParadigmShift"].OverchargeBonusDescription
    abilityValues["ParadigmShift"].OverchargeShortDescription = "<text color=\"#D9C084\">0.7x</><img id=\"Break\"/>90% " .. GetElementString(config.ParadigmShiftElement, elementalEnum, true) .. " damage over 3 hits.\nAfter cast, recover 1-4 <keyword id=\"APShard\">AP</>\n" .. abilityValues["ParadigmShift"].OverchargeBonusDescription
    abilityValues["ParadigmShift"].PerfectionName = "Paradigm Shift"
    abilityValues["ParadigmShift"].PerfectionBonusDescription = "<img id=\"Rank_C\"/>: recover 1 additional <keyword id=\"APShard\">AP</>"
    abilityValues["ParadigmShift"].PerfectionLongDescription = "<text color=\"#D9C084\">0.7x</><img id=\"Break\"/>90% <keyword id=\"Element_Physical\">Physical</> damage over 3 hits.\nAfter cast, recover 1-4 <keyword id=\"APShard\">AP</>\n" .. abilityValues["ParadigmShift"].PerfectionBonusDescription
    abilityValues["ParadigmShift"].PerfectionShortDescription = "<text color=\"#D9C084\">0.7x</><img id=\"Break\"/>90% <keyword id=\"Element_Physical\">Physical</> damage over 3 hits.\nAfter cast, recover 1-4 <keyword id=\"APShard\">AP</>\n" .. abilityValues["ParadigmShift"].PerfectionBonusDescription

    -- Purification
    abilityValues["Purification"] = {}
    abilityValues["Purification"].APCost = config.PurificationAPCost
    abilityValues["Purification"].ChargesConsumed = config.PurificationChargesConsumed
    abilityValues["Purification"].ChargesMultiplier = config.PurificationDamagePerCharge
    abilityValues["Purification"].OverchargeName = config.PurificationName
    abilityValues["Purification"].OverchargeBonusDescription = "Consumes up to " .. (config.PurificationChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> for +" .. string.format("%g", (config.PurificationDamagePerCharge) * 100) .. "% additional damage per charge.\nIf all charges are available, inflicts <keyword id=\"Buff_Powerless_Left\">Powerless</> for 3 turns."
    abilityValues["Purification"].OverchargeLongDescription = "<text color=\"#D9C084\">0.7x</><img id=\"Break\"/>250% " .. GetElementString(config.PurificationElement, elementalEnum, false) .. " damage over 2 hits.\nCleanse status effects.\n" .. abilityValues["Purification"].OverchargeBonusDescription
    abilityValues["Purification"].OverchargeShortDescription = "<text color=\"#D9C084\">0.7x</><img id=\"Break\"/>250% " .. GetElementString(config.PurificationElement, elementalEnum, true) .. " damage over 2 hits.\nCleanse status effects.\n" .. abilityValues["Purification"].OverchargeBonusDescription
    abilityValues["Purification"].PerfectionName = "Purification"
    abilityValues["Purification"].PerfectionBonusDescription = "<img id=\"Rank_B\"/>: deals 100% more damage."
    abilityValues["Purification"].PerfectionLongDescription = "<text color=\"#D9C084\">0.7x</><img id=\"Break\"/>250% <keyword id=\"Element_Light\">Light</> damage over 2 hits.\nCleanse status effects.\n" .. abilityValues["Purification"].PerfectionBonusDescription
    abilityValues["Purification"].PerfectionShortDescription = "<text color=\"#D9C084\">0.7x</><img id=\"Break\"/>250% <keyword id=\"Element_Light\">Light</> damage over 2 hits.\nCleanse status effects.\n" .. abilityValues["Purification"].PerfectionBonusDescription

    -- Gustave's Homage
    abilityValues["GustavesMemoire"] = {}
    abilityValues["GustavesMemoire"].APCost = config.GustavesHomageAPCost
    abilityValues["GustavesMemoire"].ChargesConsumed = config.GustavesHomageChargesConsumed
    abilityValues["GustavesMemoire"].ChargesMultiplier = config.GustavesHomageDamagePerCharge
    abilityValues["GustavesMemoire"].OverchargeName = config.GustavesHomageName
    abilityValues["GustavesMemoire"].OverchargeBonusDescription = "Deals 50% more damage to <keyword id=\"StatusEffect_Mark\">Marked</> enemies without removing <keyword id=\"StatusEffect_Mark\">Mark</>\nConsumes up to " .. (config.GustavesHomageChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> for +" .. string.format("%g", (config.GustavesHomageDamagePerCharge) * 100) .. "% additional damage per charge.\nIf all charges are available, inflicts 2 <keyword id=\"StatusEffect_Burn\">Burn</> per hit."
    abilityValues["GustavesMemoire"].OverchargeLongDescription = "<text color=\"#D9C084\">0.1x</><img id=\"Break\"/>400% " .. GetElementString(config.GustavesHomageElement, elementalEnum, false) .. " damage over 8 hits.\nLast hit deals 100% more damage.\n" .. abilityValues["GustavesMemoire"].OverchargeBonusDescription
    abilityValues["GustavesMemoire"].OverchargeShortDescription = "<text color=\"#D9C084\">0.1x</><img id=\"Break\"/>400% " .. GetElementString(config.GustavesHomageElement, elementalEnum, true) .. " damage over 8 hits.\nLast hit deals 100% more damage.\n" .. abilityValues["GustavesMemoire"].OverchargeBonusDescription
    abilityValues["GustavesMemoire"].PerfectionName = "Gustave's Homage"
    abilityValues["GustavesMemoire"].PerfectionBonusDescription = "Deals 50% more damage to <keyword id=\"StatusEffect_Mark\">Marked</> enemies without removing <keyword id=\"StatusEffect_Mark\">Mark</>"
    abilityValues["GustavesMemoire"].PerfectionLongDescription = "<text color=\"#D9C084\">0.1x</><img id=\"Break\"/>400% <keyword id=\"Element_Lightning\">Lightning</> damage over 8 hits.\nLast hit deals 100% more damage.\n" .. abilityValues["GustavesMemoire"].PerfectionBonusDescription
    abilityValues["GustavesMemoire"].PerfectionShortDescription = "<text color=\"#D9C084\">0.1x</><img id=\"Break\"/>400% <keyword id=\"Element_Lightning\">Lightning</> damage over 8 hits.\nLast hit deals 100% more damage.\n" .. abilityValues["GustavesMemoire"].PerfectionBonusDescription

    -- Egide
    abilityValues["Egide"] = {}
    abilityValues["Egide"].APCost = config.EgideAPCost
    abilityValues["Egide"].ChargesConsumed = config.EgideChargesConsumed
    abilityValues["Egide"].ChargesMultiplier = nil
    abilityValues["Egide"].OverchargeName = config.EgideName
    abilityValues["Egide"].OverchargeBonusDescription = "Extended by 1 turn when you gain <keyword id=\"Buff_Shell\">Shell</>\nConsumes up to " .. (config.EgideChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> to <keyword id=\"Heal\">recover</> " .. string.format("%g", (config.EgideHealPerCharge) * 100) .. "% max health per charge.\nIf all charges are available, apply <keyword id=\"Buff_Regen\">Regen</> to yourself for 2 turns."
    abilityValues["Egide"].OverchargeLongDescription = "Take damage for your allies. <text color=\"#B4B4B4\">(2 turns)</>\n" .. abilityValues["Egide"].OverchargeBonusDescription
    abilityValues["Egide"].OverchargeShortDescription = "Take damage for your allies. <text color=\"#B4B4B4\">(2 turns)</>\n" .. abilityValues["Egide"].OverchargeBonusDescription
    abilityValues["Egide"].PerfectionName = "Egide"
    abilityValues["Egide"].PerfectionBonusDescription = "Extended by 1 turn when you gain <keyword id=\"Buff_Shell\">Shell</>"
    abilityValues["Egide"].PerfectionLongDescription = "Take damage for your allies. <text color=\"#B4B4B4\">(2 turns)</>\n" .. abilityValues["Egide"].PerfectionBonusDescription
    abilityValues["Egide"].PerfectionShortDescription = "Take damage for your allies. <text color=\"#B4B4B4\">(2 turns)</>\n" .. abilityValues["Egide"].PerfectionBonusDescription

    -- Sabotage
    abilityValues["Sabotage"] = {}
    abilityValues["Sabotage"].APCost = 1 -- This is the gradient cost, modifiying this is not recommended.
    abilityValues["Sabotage"].ChargesConsumed = nil
    abilityValues["Sabotage"].ChargesMultiplier = nil
    abilityValues["Sabotage"].OverchargeName = config.SabotageName
    abilityValues["Sabotage"].OverchargeBonusDescription = ""
    abilityValues["Sabotage"].OverchargeLongDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>300% " .. GetElementString(config.SabotageElement, elementalEnum, false) .. " damage to all enemies.\nApplies <keyword id=\"StatusEffect_Mark\">Mark</> on hit." .. abilityValues["Sabotage"].OverchargeBonusDescription
    abilityValues["Sabotage"].OverchargeShortDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>300% " .. GetElementString(config.SabotageElement, elementalEnum, true) .. " damage to all enemies.\nApplies <keyword id=\"StatusEffect_Mark\">Mark</> on hit." .. abilityValues["Sabotage"].OverchargeBonusDescription
    abilityValues["Sabotage"].PerfectionName = "Sabotage"
    abilityValues["Sabotage"].PerfectionBonusDescription = ""
    abilityValues["Sabotage"].PerfectionLongDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>300% <keyword id=\"Element_Physical\">Physical</> damage to all enemies.\nApplies <keyword id=\"StatusEffect_Mark\">Mark</> on hit." .. abilityValues["Sabotage"].PerfectionBonusDescription
    abilityValues["Sabotage"].PerfectionShortDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>300% <keyword id=\"Element_Physical\">Physical</> damage to all enemies.\nApplies <keyword id=\"StatusEffect_Mark\">Mark</> on hit." .. abilityValues["Sabotage"].PerfectionBonusDescription

    -- Phoenix Flame
    abilityValues["PhoenixFlame"] = {}
    abilityValues["PhoenixFlame"].APCost = 2 -- This is the gradient cost, modifiying this is not recommended.
    abilityValues["PhoenixFlame"].ChargesConsumed = nil
    abilityValues["PhoenixFlame"].ChargesMultiplier = nil
    abilityValues["PhoenixFlame"].OverchargeName = config.PhoenixFlameName
    abilityValues["PhoenixFlame"].OverchargeBonusDescription = "Apply <keyword id=\"StatusEffect_Berserk_Left\">Berserk</> to yourself for " .. (config.PhoenixFlameBerserkDuration) .. " turns."
    abilityValues["PhoenixFlame"].OverchargeLongDescription = "Inflict 10 <keyword id=\"StatusEffect_Burn\">Burn</> to all enemies. Revive all allies with 50-70% of their max health.\n" .. abilityValues["PhoenixFlame"].OverchargeBonusDescription
    abilityValues["PhoenixFlame"].OverchargeShortDescription = "Inflict 10 <keyword id=\"StatusEffect_Burn\">Burn</> to all enemies. Revive all allies with 50-70% of their max health.\n" .. abilityValues["PhoenixFlame"].OverchargeBonusDescription
    abilityValues["PhoenixFlame"].PerfectionName = "Phoenix Flame"
    abilityValues["PhoenixFlame"].PerfectionBonusDescription = ""
    abilityValues["PhoenixFlame"].PerfectionLongDescription = "Inflict 10 <keyword id=\"StatusEffect_Burn\">Burn</> to all enemies. Revive all allies with 50-70% of their max health." .. abilityValues["PhoenixFlame"].PerfectionBonusDescription
    abilityValues["PhoenixFlame"].PerfectionShortDescription = "Inflict 10 <keyword id=\"StatusEffect_Burn\">Burn</> to all enemies. Revive all allies with 50-70% of their max health." .. abilityValues["PhoenixFlame"].PerfectionBonusDescription

    -- Gommage
    abilityValues["Gommage"] = {}
    abilityValues["Gommage"].APCost = 3 -- This is the gradient cost, modifiying this is not recommended.
    abilityValues["Gommage"].ChargesConsumed = nil
    abilityValues["Gommage"].ChargesMultiplier = nil
    abilityValues["Gommage"].OverchargeName = config.GommageName
    abilityValues["Gommage"].OverchargeBonusDescription = "Refills " .. string.format("%g", (config.GommageChargesPercentage) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>"
    abilityValues["Gommage"].OverchargeLongDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>5000% " .. GetElementString(config.GommageElement, elementalEnum, false) .. " damage.\nKills non-boss enemies.\n" .. abilityValues["Gommage"].OverchargeBonusDescription
    abilityValues["Gommage"].OverchargeShortDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>5000% " .. GetElementString(config.GommageElement, elementalEnum, true) .. " damage.\nKills non-boss enemies.\n" .. abilityValues["Gommage"].OverchargeBonusDescription
    abilityValues["Gommage"].PerfectionName = "Gommage"
    abilityValues["Gommage"].PerfectionBonusDescription = ""
    abilityValues["Gommage"].PerfectionLongDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>5000% <keyword id=\"Element_Void\">Void</> damage.\nKills non-boss enemies." .. abilityValues["Gommage"].PerfectionBonusDescription
    abilityValues["Gommage"].PerfectionShortDescription = "<text color=\"#D9C084\">1.0x</><img id=\"Break\"/>5000% <keyword id=\"Element_Void\">Void</> damage.\nKills non-boss enemies." .. abilityValues["Gommage"].PerfectionBonusDescription

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