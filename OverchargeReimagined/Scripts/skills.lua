
--[[
------- Overcharge Reimagined v2.4 - By Killera -------

        TODO: Reduce duplicated strings.
        I don't like the way this code here is right now and how it rebuilds the whole table everytime it is called but it works well enough for now.
        It does what we need for dynamic descriptions to work in order to show the current charge counter on some abilities.

        DO NOT MODIFY THIS MODULE IF YOU SIMPLY WANT TO CUSTOMIZE THIS MOD.
        Use the config.lua for that instead!

        This function returns a list with the settings for all modified abilities like AP cost, consumed charges, damage multiplier per charge and dynamic descriptions.
        Maybe not the most ideal to create this list everytime we need it, but it gets the job done for now considering this is in Lua.
]]--

-- Lua has no switch-case... ABSOLUTE KANK I HATE THIS LANGUAGE SO MUCH
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
            return "Weapon's Element"
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
    abilityValues["UnleashCharge"].ChargesMultiplier = config.OverchargeDamagePerCharge
    abilityValues["UnleashCharge"].OverchargeDescription = nil
    abilityValues["UnleashCharge"].PerfectionDescription = nil
    abilityValues["UnleashCharge"].Description =    "Deals high single target " .. GetElementString(config.OverchargeElement, elementalEnum, false) .. " damage. 1 hit.\n" ..
                                                    "Consumes all <keyword id=\"Gustave_Charges\">Charges</> for increased damage.\n" ..
                                                    "Can <keyword id=\"Break\">Break</>\n" ..
                                                    "If a target is <keyword id=\"Break\">Broken</> by the hit, Overcharge refills " .. string.format("%g", (config.OverchargeChargesPercentage) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>"
    abilityValues["UnleashCharge"].OverchargeShortDescription = "High " .. GetElementString(config.OverchargeElement, elementalEnum, true) .. " damage based on the amount of <keyword id=\"Gustave_Charges\">Charges</> 1 hit.\n" ..
                                                                "Can <keyword id=\"Break\">Break</>\n" ..
                                                                "If a target is <keyword id=\"Break\">Broken</> by the hit, Overcharge refills " .. string.format("%g", (config.OverchargeChargesPercentage) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>"
    abilityValues["UnleashCharge"].PerfectionShortDescription = nil

    -- Shatter
    abilityValues["PerfectBreak_Gustave"] = {}
    abilityValues["PerfectBreak_Gustave"].APCost = config.ShatterAPCost
    abilityValues["PerfectBreak_Gustave"].ChargesConsumed = config.VirtualMaxCharges
    abilityValues["PerfectBreak_Gustave"].ChargesMultiplier = config.ShatterDamagePerCharge
    abilityValues["PerfectBreak_Gustave"].OverchargeDescription = nil
    abilityValues["PerfectBreak_Gustave"].PerfectionDescription = nil
    abilityValues["PerfectBreak_Gustave"].Description = "Deals high " .. GetElementString(config.ShatterElement, elementalEnum, false) .. " damage to all enemies. 1 hit.\n" ..
                                                        "Consumes all <keyword id=\"Gustave_Charges\">Charges</> for increased damage.\n" ..
                                                        "Can <keyword id=\"Break\">Break</>\n" ..
                                                        "If a target is <keyword id=\"Break\">Broken</> by the hit, Shatter refills " .. string.format("%g", (config.ShatterChargesPercentage) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>"
    abilityValues["PerfectBreak_Gustave"].OverchargeShortDescription =  "High " .. GetElementString(config.ShatterElement, elementalEnum, true) .. " damage based on the amount of <keyword id=\"Gustave_Charges\">Charges</> 1 hit.\n" ..
                                                                        "Can <keyword id=\"Break\">Break</>\n" ..
                                                                        "If a target is <keyword id=\"Break\">Broken</> by the hit, Shatter refills " .. string.format("%g", (config.ShatterChargesPercentage) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>"
    abilityValues["PerfectBreak_Gustave"].PerfectionShortDescription = nil

    -- Marking Shot
    abilityValues["MarkingShot_Gustave"] = {}
    abilityValues["MarkingShot_Gustave"].APCost = config.MarkingShotAPCost
    abilityValues["MarkingShot_Gustave"].ChargesConsumed = config.MarkingShotChargesConsumed
    abilityValues["MarkingShot_Gustave"].ChargesMultiplier = config.MarkingShotDamagePerCharge
    abilityValues["MarkingShot_Gustave"].OverchargeDescription = nil
    abilityValues["MarkingShot_Gustave"].PerfectionDescription = nil
    abilityValues["MarkingShot_Gustave"].Description =  "Deals low single target " .. GetElementString(config.MarkingShotElement, elementalEnum, false) .. " damage. 1 hit.\n" ..
                                                        "Applies <keyword id=\"StatusEffect_Mark\">Mark</>\n" ..
                                                        "Consumes up to " .. (config.MarkingShotChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage."
    abilityValues["MarkingShot_Gustave"].OverchargeShortDescription =   "Low " .. GetElementString(config.MarkingShotElement, elementalEnum, true) .. " damage and applies <keyword id=\"StatusEffect_Mark\">Mark</> 1 hit.\n" .. 
                                                                        "Consumes up to " .. (config.MarkingShotChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage."
    abilityValues["MarkingShot_Gustave"].PerfectionShortDescription = nil

    -- Lumiere Assault
    abilityValues["Combo1_Gustave"] = {}
    abilityValues["Combo1_Gustave"].APCost = config.LumiereAssaultAPCost
    abilityValues["Combo1_Gustave"].ChargesConsumed = nil
    abilityValues["Combo1_Gustave"].ChargesMultiplier = nil
    abilityValues["Combo1_Gustave"].OverchargeDescription = nil
    abilityValues["Combo1_Gustave"].PerfectionDescription = nil
    abilityValues["Combo1_Gustave"].Description =   "Deals low single target " .. GetElementString(config.LumiereAssaultElement, elementalEnum, false) .. " damage. 5 hits.\n" ..
                                                    "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.LumiereAssaultChargesPerCritical) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>"
    abilityValues["Combo1_Gustave"].OverchargeShortDescription =    "Low " .. GetElementString(config.LumiereAssaultElement, elementalEnum, true) .. " damage. 5 hits.\n" ..
                                                                    "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.LumiereAssaultChargesPerCritical) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>"
    abilityValues["Combo1_Gustave"].PerfectionShortDescription = nil

    -- Strike Storm
    abilityValues["StrikeStorm_Gustave"] = {}
    abilityValues["StrikeStorm_Gustave"].APCost = config.StrikeStormAPCost
    abilityValues["StrikeStorm_Gustave"].ChargesConsumed = nil
    abilityValues["StrikeStorm_Gustave"].ChargesMultiplier = nil
    abilityValues["StrikeStorm_Gustave"].OverchargeDescription = nil
    abilityValues["StrikeStorm_Gustave"].PerfectionDescription = nil
    abilityValues["StrikeStorm_Gustave"].Description =  "Deals very high single target " .. GetElementString(config.StrikeStormElement, elementalEnum, false) .. " damage. 6 hits.\n" ..
                                                        "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.StrikeStormChargesPerCritical) .. " additional <keyword id=\"Gustave_Charges\">Charges</>"
    abilityValues["StrikeStorm_Gustave"].OverchargeShortDescription =   "Very high " .. GetElementString(config.StrikeStormElement, elementalEnum, true) .. " damage. 6 hits.\n" ..
                                                                        "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.StrikeStormChargesPerCritical) .. " additional <keyword id=\"Gustave_Charges\">Charges</>"
    abilityValues["StrikeStorm_Gustave"].PerfectionShortDescription = nil

    -- From Fire
    abilityValues["FromFire_Gustave"] = {}
    abilityValues["FromFire_Gustave"].APCost = config.FromFireAPCost
    abilityValues["FromFire_Gustave"].ChargesConsumed = config.FromFireChargesConsumed
    abilityValues["FromFire_Gustave"].ChargesMultiplier = config.FromFireDamagePerCharge
    abilityValues["FromFire_Gustave"].OverchargeDescription = nil
    abilityValues["FromFire_Gustave"].PerfectionDescription = nil
    abilityValues["FromFire_Gustave"].Description = "Deals medium single target " .. GetElementString(config.FromFireElement, elementalEnum, false) .. " damage. 3 hits.\n" ..
                                                    "<keyword id=\"Heal\">Heals</> self by 20% if the target <keyword id=\"StatusEffect_Burn\">Burns</>\n" ..
                                                    "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.FromFireChargesPerCritical) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>\n" ..
                                                    "Consumes up to " .. (config.FromFireChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage and <keyword id=\"Heal\">heal</>"
    abilityValues["FromFire_Gustave"].OverchargeShortDescription =  "Medium " .. GetElementString(config.FromFireElement, elementalEnum, true) .. " damage. 3 hits.\n" ..
                                                                    "<keyword id=\"Heal\">Heals</> self by 20% Health if the target <keyword id=\"StatusEffect_Burn\">Burns</>\n" ..
                                                                    "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.FromFireChargesPerCritical) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>\n" ..
                                                                    "Consumes up to " .. (config.FromFireChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage and <keyword id=\"Heal\">heal</>"
    abilityValues["FromFire_Gustave"].PerfectionShortDescription = nil

    -- Recovery
    abilityValues["PerfectRecovery_Gustave"] = {}
    abilityValues["PerfectRecovery_Gustave"].APCost = config.RecoveryAPCost
    abilityValues["PerfectRecovery_Gustave"].ChargesConsumed = nil
    abilityValues["PerfectRecovery_Gustave"].ChargesMultiplier = nil
    abilityValues["PerfectRecovery_Gustave"].OverchargeDescription = nil
    abilityValues["PerfectRecovery_Gustave"].PerfectionDescription = nil
    abilityValues["PerfectRecovery_Gustave"].Description =  "<keyword id=\"Heal\">Recovers</> 50% Health and dispels Status Effects.\n" ..
                                                            "Refills 0% - " .. string.format("%g", (config.RecoveryChargesPercentage) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>"
    abilityValues["PerfectRecovery_Gustave"].OverchargeShortDescription =   "<keyword id=\"Heal\">Recovers</> 50% Health and dispels Status Effects.\n" ..
                                                                            "Refills 0% - " .. string.format("%g", (config.RecoveryChargesPercentage) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>"
    abilityValues["PerfectRecovery_Gustave"].PerfectionShortDescription = nil

    -- Powerful
    abilityValues["Powerful_Gustave"] = {}
    abilityValues["Powerful_Gustave"].APCost = config.PowerfulAPCost
    abilityValues["Powerful_Gustave"].ChargesConsumed = config.PowerfulChargesConsumed
    abilityValues["Powerful_Gustave"].ChargesMultiplier = nil
    abilityValues["Powerful_Gustave"].OverchargeDescription = nil
    abilityValues["Powerful_Gustave"].PerfectionDescription = nil
    abilityValues["Powerful_Gustave"].Description = "Applies <keyword id=\"Buff_Powerful\">Powerful</> to 1-3 allies for 3 turns.\n" ..
                                                    "Consumes <keyword id=\"Gustave_Charges\">Charges</> to empower Gustave:\n" ..
                                                    string.format("%g", (config.PowerfulChargesConsumed) * 0.2) .. " Charges: Apply <keyword id=\"Buff_Shell_Left\">Shell</> for 3 turns.\n" ..
                                                    string.format("%g", (config.PowerfulChargesConsumed) * 0.4) .. " Charges: Apply <keyword id=\"Buff_Rush_Left\">Rush</> for 3 turns.\n" ..
                                                    string.format("%g", (config.PowerfulChargesConsumed) * 0.6) .. " Charges: Apply <keyword id=\"StatusEffect_Berserk_Left\">Berserk</> for 3 turns.\n" ..
                                                    string.format("%g", (config.PowerfulChargesConsumed) * 0.8) .. " Charges: Increase turn duration to 6.\n" ..
                                                    (config.PowerfulChargesConsumed) .. " Charges: Apply <keyword id=\"StatusEffect_Enraged_Left\">Rage</> for 1 turn."
    abilityValues["Powerful_Gustave"].OverchargeShortDescription =  "Applies <keyword id=\"Buff_Powerful\">Powerful</> to 1-3 allies for 3 turns.\n" ..
                                                                    "Consumes <keyword id=\"Gustave_Charges\">Charges</> to empower Gustave:\n" ..
                                                                    "<keyword id=\"Element_Lightning\">" .. string.format("%g", (config.PowerfulChargesConsumed) * 0.2) .. "</>: <keyword id=\"Buff_Shell_Left\">Shell</> / " ..
                                                                    "<keyword id=\"Element_Lightning\">" .. string.format("%g", (config.PowerfulChargesConsumed) * 0.4) .. "</>: <keyword id=\"Buff_Rush_Left\">Rush</> /\n" ..
                                                                    "<keyword id=\"Element_Lightning\">" .. string.format("%g", (config.PowerfulChargesConsumed) * 0.6) .. "</>: <keyword id=\"StatusEffect_Berserk_Left\">Berserk</> / " ..
                                                                    "<keyword id=\"Element_Lightning\">" .. string.format("%g", (config.PowerfulChargesConsumed) * 0.8) .. "</>: 6-turn duration /\n" ..
                                                                    "<keyword id=\"Element_Lightning\">" .. string.format("%g", (config.PowerfulChargesConsumed)) .. "</>: <keyword id=\"StatusEffect_Enraged_Left\">Rage</> for 1 turn."
    abilityValues["Powerful_Gustave"].PerfectionShortDescription = nil

    -- Light Holder
    abilityValues["OldLightHolder"] = {}
    abilityValues["OldLightHolder"].APCost = config.LightHolderAPCost
    abilityValues["OldLightHolder"].ChargesConsumed = nil
    abilityValues["OldLightHolder"].ChargesMultiplier = nil
    abilityValues["OldLightHolder"].OverchargeDescription = nil
    abilityValues["OldLightHolder"].PerfectionDescription = nil
    abilityValues["OldLightHolder"].Description =   "Deals high single target " .. GetElementString(config.LightHolderElement, elementalEnum, false) .. " damage. 5 hits.\n" ..
                                                    "Damage increased by " .. string.format("%g", (config.LightHolderDamagePerHealthChunk) * 100) .. "% per " .. (config.LightHolderHealthChunkSize) .. " max health.\n" ..
                                                    "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.LightHolderChargesPerCritical) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>"
    abilityValues["OldLightHolder"].OverchargeShortDescription =    "High " .. GetElementString(config.LightHolderElement, elementalEnum, true) .. " damage increased by " .. string.format("%g", (config.LightHolderDamagePerHealthChunk) * 100) .. "% per " .. (config.LightHolderHealthChunkSize) .. " max health. 5 hits.\n" ..
                                                                    "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.LightHolderChargesPerCritical) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>"
    abilityValues["OldLightHolder"].PerfectionShortDescription = nil

    -- Radiant Strike
    abilityValues["RadiantStrike"] = {}
    abilityValues["RadiantStrike"].APCost = config.RadiantStrikeAPCost
    abilityValues["RadiantStrike"].ChargesConsumed = config.RadiantStrikeChargesConsumed
    abilityValues["RadiantStrike"].ChargesMultiplier = config.RadiantStrikeDamagePerCharge
    abilityValues["RadiantStrike"].OverchargeDescription = nil
    abilityValues["RadiantStrike"].PerfectionDescription = nil
    abilityValues["RadiantStrike"].Description =   "Deals low " .. GetElementString(config.RadiantStrikeElement, elementalEnum, false) .. " damage to all enemies. 1 hit.\n" ..
                                                    "Consumes up to " .. (config.RadiantStrikeChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage."
    abilityValues["RadiantStrike"].OverchargeShortDescription = "Deals low " .. GetElementString(config.RadiantStrikeElement, elementalEnum, true) .. " damage to all enemies. 1 hit.\n" ..
                                                                "Consumes up to " .. (config.RadiantStrikeChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage."
    abilityValues["RadiantStrike"].PerfectionShortDescription = nil

    --------------------------------------------------
    -- Perfection abilities shared by other character.
    --------------------------------------------------

    -- Overload
    abilityValues["Overcharge"] = {}
    abilityValues["Overcharge"].APCost = config.OverloadAPCost
    abilityValues["Overcharge"].ChargesConsumed = nil
    abilityValues["Overcharge"].ChargesMultiplier = nil
    abilityValues["Overcharge"].OverchargeDescription = "Refills " .. string.format("%g", (config.OverloadChargesPercentage) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>"
    abilityValues["Overcharge"].PerfectionDescription = "Increases Rank to <img id=\"Rank_A\"/>"
    abilityValues["Overcharge"].Description =   "Refills all <keyword id=\"APShard\">AP</> but sets self-Health to 1." ..
                                                "\n<keyword id=\"Element_Light\">Perfection</>: " .. abilityValues["Overcharge"].PerfectionDescription ..
                                                "\n<keyword id=\"Element_Lightning\">Overcharge</>: " .. abilityValues["Overcharge"].OverchargeDescription
    abilityValues["Overcharge"].OverchargeShortDescription =    "Refills all <keyword id=\"APShard\">AP</> but sets self-Health to 1.\n" .. abilityValues["Overcharge"].OverchargeDescription
    abilityValues["Overcharge"].PerfectionShortDescription =    "Refills all <keyword id=\"APShard\">AP</> but sets self-Health to 1.\n" .. abilityValues["Overcharge"].PerfectionDescription

    -- Steeled Strike
    abilityValues["SteeledStrike"] = {}
    abilityValues["SteeledStrike"].APCost = config.SteeledStrikeAPCost
    abilityValues["SteeledStrike"].ChargesConsumed = config.SteeledStrikeChargesConsumed
    abilityValues["SteeledStrike"].ChargesMultiplier = config.SteeledStrikeDamagePerCharge
    abilityValues["SteeledStrike"].OverchargeDescription = "Consumes up to " .. (config.SteeledStrikeChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage."
    abilityValues["SteeledStrike"].PerfectionDescription = "<img id=\"Rank_S\"/>: Increased damage."
    abilityValues["SteeledStrike"].Description =    "After 1 turn, deals extreme single target damage. 13 hits.\n" ..
                                                    "Interrupted if any damage taken." ..
                                                    "\n<keyword id=\"Element_Light\">Perfection</>: <keyword id=\"Element_Physical\">Physical</>. " .. abilityValues["SteeledStrike"].PerfectionDescription ..
                                                    "\n<keyword id=\"Element_Lightning\">Overcharge</>: " .. GetElementString(config.SteeledStrikeElement, elementalEnum, false) .. ". " .. abilityValues["SteeledStrike"].OverchargeDescription
    abilityValues["SteeledStrike"].OverchargeShortDescription = "After 1 turn, deals extreme " .. GetElementString(config.SteeledStrikeElement, elementalEnum, true) .. " damage. 13 hits.\n" ..
                                                                "Interrupted if any damage taken.\n" .. abilityValues["SteeledStrike"].OverchargeDescription
    abilityValues["SteeledStrike"].PerfectionShortDescription = "After 1 turn, deals extreme <keyword id=\"Element_Physical\">Physical</> damage. 13 hits.\n" ..
                                                                "Interrupted if any damage taken.\n" .. abilityValues["SteeledStrike"].PerfectionDescription

    -- Endbringer
    abilityValues["EndBringer"] = {}
    abilityValues["EndBringer"].APCost = config.EndbringerAPCost
    abilityValues["EndBringer"].ChargesConsumed = nil
    abilityValues["EndBringer"].ChargesMultiplier = nil
    abilityValues["EndBringer"].OverchargeDescription = "<keyword id=\"StatusEffect_Stunned\">Stun Hits</> generate " .. (config.EndbringerChargesPerStunnedHit) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>"
    abilityValues["EndBringer"].PerfectionDescription = "<img id=\"Rank_A\"/>: Can reapply <keyword id=\"StatusEffect_Stunned\">Stun</>"
    abilityValues["EndBringer"].Description =   "Deals extreme single target damage. 6 hits.\n" ..
                                                "Increased damage if the target is <keyword id=\"StatusEffect_Stunned\">Stunned</>" ..
                                                "\n<keyword id=\"Element_Light\">Perfection</>: <keyword id=\"Element_Physical\">Physical</>. " .. abilityValues["EndBringer"].PerfectionDescription ..
                                                "\n<keyword id=\"Element_Lightning\">Overcharge</>: " .. GetElementString(config.EndbringerElement, elementalEnum, false) .. ". " .. abilityValues["EndBringer"].OverchargeDescription
    abilityValues["EndBringer"].OverchargeShortDescription =    "Extreme " .. GetElementString(config.EndbringerElement, elementalEnum, true) .. " damage. 6 hits.\n" ..
                                                                "Increased damage if the target is <keyword id=\"StatusEffect_Stunned\">Stunned</>\n" .. abilityValues["EndBringer"].OverchargeDescription
    abilityValues["EndBringer"].PerfectionShortDescription =    "Extreme <keyword id=\"Element_Physical\">Physical</> damage. 6 hits.\n" ..
                                                                "Increased damage if the target is <keyword id=\"StatusEffect_Stunned\">Stunned</>\n" .. abilityValues["EndBringer"].PerfectionDescription

    -- Berserk Slash
    abilityValues["BerserkSlash"] = {}
    abilityValues["BerserkSlash"].APCost = config.BerserkSlashAPCost or 4
    abilityValues["BerserkSlash"].ChargesConsumed = config.BerserkSlashChargesConsumed or 10
    abilityValues["BerserkSlash"].ChargesMultiplier = config.BerserkSlashDamagePerCharge or 0.2
    abilityValues["BerserkSlash"].OverchargeDescription = "Consumes up to " .. (config.BerserkSlashChargesConsumed or 10) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage."
    abilityValues["BerserkSlash"].PerfectionDescription = "<img id=\"Rank_C\"/>: Increased damage."
    abilityValues["BerserkSlash"].Description = "Deals medium single target damage. 3 hits.\n" ..
                                                "Damage is increased for each Health this character is missing." ..
                                                "\n<keyword id=\"Element_Light\">Perfection</>: <keyword id=\"Element_Physical\">Physical</>. " .. abilityValues["BerserkSlash"].PerfectionDescription ..
                                                "\n<keyword id=\"Element_Lightning\">Overcharge</>: " .. GetElementString(config.BerserkSlashElement or elementalEnum.Physical, elementalEnum, false) .. ". " .. abilityValues["BerserkSlash"].OverchargeDescription
    abilityValues["BerserkSlash"].OverchargeShortDescription =  "Medium " .. GetElementString(config.BerserkSlashElement or elementalEnum.Physical, elementalEnum, true) .. " damage. 3 hits.\n" ..
                                                                "Deals more damage the less Health this character has.\n" .. abilityValues["BerserkSlash"].OverchargeDescription
    abilityValues["BerserkSlash"].PerfectionShortDescription =  "Medium <keyword id=\"Element_Physical\">Physical</> damage. 3 hits.\n" ..
                                                                "Deals more damage the less Health this character has.\n" .. abilityValues["BerserkSlash"].PerfectionDescription

    -- Defiant Strike
    abilityValues["DefiantStrike"] = {}
    abilityValues["DefiantStrike"].APCost = config.DefiantStrikeAPCost
    abilityValues["DefiantStrike"].ChargesConsumed = config.DefiantStrikeChargesConsumed
    abilityValues["DefiantStrike"].ChargesMultiplier = config.DefiantStrikeDamagePerCharge
    abilityValues["DefiantStrike"].OverchargeDescription = "Consumes up to " .. (config.DefiantStrikeChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage."
    abilityValues["DefiantStrike"].PerfectionDescription = "<img id=\"Rank_B\"/>: Increased damage."
    abilityValues["DefiantStrike"].Description =    "Deals high single target damage that applies <keyword id=\"StatusEffect_Mark\">Mark</> 2 hits.\n" ..
                                                    "Costs 30% of current Health." ..
                                                    "\n<keyword id=\"Element_Light\">Perfection</>: <keyword id=\"Element_Physical\">Physical</>. " .. abilityValues["DefiantStrike"].PerfectionDescription ..
                                                    "\n<keyword id=\"Element_Lightning\">Overcharge</>: " .. GetElementString(config.DefiantStrikeElement, elementalEnum, false) .. ". " .. abilityValues["DefiantStrike"].OverchargeDescription
    abilityValues["DefiantStrike"].OverchargeShortDescription = "High " .. GetElementString(config.DefiantStrikeElement, elementalEnum, false) .. " damage. 2 hits. Applies <keyword id=\"StatusEffect_Mark\">Mark</>\n" ..
                                                                "Costs 30% Health.\n" .. abilityValues["DefiantStrike"].OverchargeDescription
    abilityValues["DefiantStrike"].PerfectionShortDescription = "High <keyword id=\"Element_Physical\">Physical</> damage. 2 hits. Applies <keyword id=\"StatusEffect_Mark\">Mark</>\n" ..
                                                                "Costs 30% Health.\n" .. abilityValues["DefiantStrike"].PerfectionDescription

    -- Blitz
    abilityValues["Blitz"] = {}
    abilityValues["Blitz"].APCost = config.BlitzAPCost
    abilityValues["Blitz"].ChargesConsumed = config.BlitzChargesConsumed
    abilityValues["Blitz"].ChargesMultiplier = config.BlitzDamagePerCharge
    abilityValues["Blitz"].OverchargeDescription = "Consumes up to " .. (config.BlitzChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage."
    abilityValues["Blitz"].PerfectionDescription = "<img id=\"Rank_B\"/>: Increased damage."
    abilityValues["Blitz"].Description =    "Deals low single target damage. 1 hit.\n" ..
                                            "Plays a second time. Kills non-boss enemies with less than 10% Health." ..
                                            "\n<keyword id=\"Element_Light\">Perfection</>: <keyword id=\"Element_Physical\">Physical</>. " .. abilityValues["Blitz"].PerfectionDescription ..
                                            "\n<keyword id=\"Element_Lightning\">Overcharge</>: " .. GetElementString(config.BlitzElement, elementalEnum, false) .. ". " .. abilityValues["Blitz"].OverchargeDescription
    abilityValues["Blitz"].OverchargeShortDescription = "Low " .. GetElementString(config.BlitzElement, elementalEnum, true) .. " damage. 1 hit.\n" ..
                                                        "Plays a second time. Kills non-boss enemies with less than 10% Health.\n" .. abilityValues["Blitz"].OverchargeDescription
    abilityValues["Blitz"].PerfectionShortDescription = "Low <keyword id=\"Element_Physical\">Physical</> damage. 1 hit.\n" ..
                                                        "Plays a second time. Kills non-boss enemies with less than 10% Health.\n" .. abilityValues["Blitz"].PerfectionDescription

    -- Follow Up
    abilityValues["FollowUp"] = {}
    abilityValues["FollowUp"].APCost = config.FollowUpAPCost
    abilityValues["FollowUp"].ChargesConsumed = config.FollowUpChargesConsumed
    abilityValues["FollowUp"].ChargesMultiplier = config.FollowUpDamagePerCharge
    abilityValues["FollowUp"].OverchargeDescription = "Consumes up to " .. (config.FollowUpChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage. Costs " .. (config.FollowUpAPReducedCost) .. " <keyword id=\"APShard\">AP</> if required charges are available."
    abilityValues["FollowUp"].PerfectionDescription = "<img id=\"Rank_S\"/>: Costs 2 <keyword id=\"APShard\">AP</>"
    abilityValues["FollowUp"].Description = "Deals medium single target damage. 1 hit.\n" ..
                                            "Damage increased for each Free Aim shot this turn, up to 10 times." ..
                                            "\n<keyword id=\"Element_Light\">Perfection</>: <keyword id=\"Element_Light\">Light</>. " .. abilityValues["FollowUp"].PerfectionDescription ..
                                            "\n<keyword id=\"Element_Lightning\">Overcharge</>: " .. GetElementString(config.FollowUpElement, elementalEnum, false) .. ". " .. abilityValues["FollowUp"].OverchargeDescription
    abilityValues["FollowUp"].OverchargeShortDescription = "Medium " .. GetElementString(config.FollowUpElement, elementalEnum, true) .. " damage, increased for each Free Aim shot this turn, up to 10 times. 1 hit.\n" .. abilityValues["FollowUp"].OverchargeDescription
    abilityValues["FollowUp"].PerfectionShortDescription = "Medium <keyword id=\"Element_Light\">Light</> damage, increased for each Free Aim shot this turn, up to 10 times. 1 hit.\n" .. abilityValues["FollowUp"].PerfectionDescription

    -- Ascending Assault
    abilityValues["AscendingAssault"] = {}
    abilityValues["AscendingAssault"].APCost = config.AscendingAssaultAPCost
    abilityValues["AscendingAssault"].ChargesConsumed = config.AscendingAssaultChargesConsumed
    abilityValues["AscendingAssault"].ChargesMultiplier = config.AscendingAssaultDamagePerCharge
    abilityValues["AscendingAssault"].OverchargeDescription = "Consumes up to " .. (config.AscendingAssaultChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage. Costs " .. (config.AscendingAssaultAPReducedCost) .. " <keyword id=\"APShard\">AP</> if required charges are available."
    abilityValues["AscendingAssault"].PerfectionDescription = "<img id=\"Rank_S\"/>: Costs 2 <keyword id=\"APShard\">AP</>"
    abilityValues["AscendingAssault"].Description = "Deals low single target damage. 1 hit.\n" ..
                                                    "Increased damage at each cast." ..
                                                    "\n<keyword id=\"Element_Light\">Perfection</>: Weapon's Element. " .. abilityValues["AscendingAssault"].PerfectionDescription ..
                                                    "\n<keyword id=\"Element_Lightning\">Overcharge</>: " .. GetElementString(config.AscendingAssaultElement, elementalEnum, false) .. ". " .. abilityValues["AscendingAssault"].OverchargeDescription
    abilityValues["AscendingAssault"].OverchargeShortDescription = "Low " .. GetElementString(config.AscendingAssaultElement, elementalEnum, true) .. " damage. 1 hit.\n" ..
                                                                    "Increased damage at each cast.\n" .. abilityValues["AscendingAssault"].OverchargeDescription
    abilityValues["AscendingAssault"].PerfectionShortDescription = "Low {DynamicElement} damage. 1 hit.\n" ..
                                                                    "Increased damage at each cast.\n" .. abilityValues["AscendingAssault"].PerfectionDescription

    -- Speed Burst
    abilityValues["SpeedBurst"] = {}
    abilityValues["SpeedBurst"].APCost = config.SpeedBurstAPCost
    abilityValues["SpeedBurst"].ChargesConsumed = nil
    abilityValues["SpeedBurst"].ChargesMultiplier = nil
    abilityValues["SpeedBurst"].OverchargeDescription = "Generates " .. (config.SpeedBurstChargesPerHit) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</> per hit."
    abilityValues["SpeedBurst"].PerfectionDescription = "<img id=\"Rank_C\"/>: Increased damage."
    abilityValues["SpeedBurst"].Description =   "Deals high single target damage. 5 hits.\n" ..
                                                "Damage increased by Speed difference with the target." ..
                                                "\n<keyword id=\"Element_Light\">Perfection</>: <keyword id=\"Element_Light\">Light</>. " .. abilityValues["SpeedBurst"].PerfectionDescription ..
                                                "\n<keyword id=\"Element_Lightning\">Overcharge</>: " .. GetElementString(config.SpeedBurstElement, elementalEnum, false) .. ". " .. abilityValues["SpeedBurst"].OverchargeDescription
    abilityValues["SpeedBurst"].OverchargeShortDescription = "High " .. GetElementString(config.SpeedBurstElement, elementalEnum, true) .. " damage increased by Speed difference. 5 hits.\n" .. abilityValues["SpeedBurst"].OverchargeDescription
    abilityValues["SpeedBurst"].PerfectionShortDescription = "High <keyword id=\"Element_Light\">Light</> damage increased by Speed difference. 5 hits.\n" .. abilityValues["SpeedBurst"].PerfectionDescription

    -- Phantom Stars
    abilityValues["PhantomStars"] = {}
    abilityValues["PhantomStars"].APCost = config.PhantomStarsAPCost
    abilityValues["PhantomStars"].ChargesConsumed = config.PhantomStarsChargesConsumed
    abilityValues["PhantomStars"].ChargesMultiplier = config.PhantomStarsDamagePerCharge
    abilityValues["PhantomStars"].OverchargeDescription = "Consumes up to " .. (config.PhantomStarsChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage. Costs " .. (config.PhantomStarsAPReducedCost) .. " <keyword id=\"APShard\">AP</> if required charges are available.\n" ..
                                                          "If a target is <keyword id=\"Break\">Broken</> by the hit, Phantom Stars refills " .. string.format("%g", (config.PhantomStarsChargesPercentage) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>"
    abilityValues["PhantomStars"].PerfectionDescription = "<img id=\"Rank_S\"/>: Costs 5 <keyword id=\"APShard\">AP</>"
    abilityValues["PhantomStars"].Description = "Deals extreme damage to all enemies. 5 hits.\n" .. 
                                                "Can <keyword id=\"Break\">Break</>" ..
                                                "\n<keyword id=\"Element_Light\">Perfection</>: <keyword id=\"Element_Light\">Light</>. " .. abilityValues["PhantomStars"].PerfectionDescription ..
                                                "\n<keyword id=\"Element_Lightning\">Overcharge</>: " .. GetElementString(config.PhantomStarsElement, elementalEnum, false) .. ". " .. abilityValues["PhantomStars"].OverchargeDescription
    abilityValues["PhantomStars"].OverchargeShortDescription =  "Extreme " .. GetElementString(config.PhantomStarsElement, elementalEnum, true) .. " damage to all enemies. 5 hits.\n" ..
                                                                "Can <keyword id=\"Break\">Break</>\n" .. abilityValues["PhantomStars"].OverchargeDescription
    abilityValues["PhantomStars"].PerfectionShortDescription =  "Extreme <keyword id=\"Element_Light\">Light</> damage to all enemies. 5 hits.\n" ..
                                                                "Can <keyword id=\"Break\">Break</>\n" .. abilityValues["PhantomStars"].PerfectionDescription

    -- Paradigm Shift
    abilityValues["ParadigmShift"] = {}
    abilityValues["ParadigmShift"].APCost = config.ParadigmShiftAPCost
    abilityValues["ParadigmShift"].ChargesConsumed = config.ParadigmShiftChargesConsumed
    abilityValues["ParadigmShift"].ChargesMultiplier = nil
    abilityValues["ParadigmShift"].OverchargeDescription = "Consumes " .. (config.ParadigmShiftChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> per hit to give " .. (config.ParadigmShiftAPPerCharge) .. " <keyword id=\"APShard\">AP</> per charge."
    abilityValues["ParadigmShift"].PerfectionDescription = "<img id=\"Rank_C\"/>: +1 <keyword id=\"APShard\">AP</>"
    abilityValues["ParadigmShift"].Description =    "Deals low single target damage and gives 1-3 <keyword id=\"APShard\">AP</> back. 3 hits." ..
                                                    "\n<keyword id=\"Element_Light\">Perfection</>: <keyword id=\"Element_Physical\">Physical</>. " .. abilityValues["ParadigmShift"].PerfectionDescription ..
                                                    "\n<keyword id=\"Element_Lightning\">Overcharge</>: " .. GetElementString(config.ParadigmShiftElement, elementalEnum, false) .. ". " .. abilityValues["ParadigmShift"].OverchargeDescription
    abilityValues["ParadigmShift"].OverchargeShortDescription = "Low " .. GetElementString(config.ParadigmShiftElement, elementalEnum, true) .. " damage and gives 1-3 <keyword id=\"APShard\">AP</> back. 3 hits.\n" .. abilityValues["ParadigmShift"].OverchargeDescription
    abilityValues["ParadigmShift"].PerfectionShortDescription = "Low <keyword id=\"Element_Physical\">Physical</> damage and gives 1-3 <keyword id=\"APShard\">AP</> back. 3 hits.\n" .. abilityValues["ParadigmShift"].PerfectionDescription

    -- Purification
    abilityValues["Purification"] = {}
    abilityValues["Purification"].APCost = config.PurificationAPCost
    abilityValues["Purification"].ChargesConsumed = config.PurificationChargesConsumed
    abilityValues["Purification"].ChargesMultiplier = config.PurificationDamagePerCharge
    abilityValues["Purification"].OverchargeDescription = "Consumes up to " .. (config.PurificationChargesConsumed) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage."
    abilityValues["Purification"].PerfectionDescription = "<img id=\"Rank_B\"/>: Increased damage."
    abilityValues["Purification"].Description = "Deals medium single target damage. 2 hits.\n" ..
                                                "Dispels self status effects." ..
                                                "\n<keyword id=\"Element_Light\">Perfection</>: <keyword id=\"Element_Light\">Light</>. " .. abilityValues["Purification"].PerfectionDescription ..
                                                "\n<keyword id=\"Element_Lightning\">Overcharge</>: " .. GetElementString(config.PurificationElement, elementalEnum, false) .. ". " .. abilityValues["Purification"].OverchargeDescription
    abilityValues["Purification"].OverchargeShortDescription =  "Medium " .. GetElementString(config.PurificationElement, elementalEnum, true) .. " damage. 2 hits.\n" ..
                                                                "Dispels self status effects.\n" .. abilityValues["Purification"].OverchargeDescription
    abilityValues["Purification"].PerfectionShortDescription =  "Medium <keyword id=\"Element_Light\">Light</> damage. 2 hits.\n" ..
                                                                "Dispels self status effects.\n" .. abilityValues["Purification"].PerfectionDescription

    -- Angel's Eyes
    abilityValues["AngelsEyes"] = {}
    abilityValues["AngelsEyes"].APCost = 3 -- This is the gradient cost, modifiying this is not recommended.
    abilityValues["AngelsEyes"].ChargesConsumed = nil
    abilityValues["AngelsEyes"].ChargesMultiplier = nil
    abilityValues["AngelsEyes"].OverchargeDescription = "Generates " .. (config.AngelsEyesAdditionalChargesPerHit or 3) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</> per hit."
    abilityValues["AngelsEyes"].PerfectionDescription = "Generates 1 additional <keyword id=\"Perfection\">Perfection</> per hit."
    abilityValues["AngelsEyes"].Description =   "Deals extreme single target <keyword id=\"Element_Physical\">Physical</> Damage. 8 hits.\n" ..
                                                "Applies Aureole to revive this character on death." ..
                                                "\n<keyword id=\"Element_Light\">Perfection</>: " .. abilityValues["AngelsEyes"].PerfectionDescription ..
                                                "\n<keyword id=\"Element_Lightning\">Overcharge</>: " .. abilityValues["AngelsEyes"].OverchargeDescription
    abilityValues["AngelsEyes"].OverchargeShortDescription =    "Extreme <keyword id=\"Element_Physical\">Physical</> Damage. 8 hits.\n" ..
                                                                "Applies Aureole to revive this character on death.\n" .. abilityValues["AngelsEyes"].OverchargeDescription
    abilityValues["AngelsEyes"].PerfectionShortDescription =    "Extreme <keyword id=\"Element_Physical\">Physical</> Damage. 8 hits.\n" ..
                                                                "Applies Aureole to revive this character on death.\n" .. abilityValues["AngelsEyes"].PerfectionDescription

    log("Initialized abilityValues array in skills.lua successfully!")
end

local function GetAbilityValues(abilityNameID)
    return abilityValues[abilityNameID]
end

-- Expose the functions to main.lua.
return
{
    Init = Init,
    GetAbilityValues = GetAbilityValues,
}