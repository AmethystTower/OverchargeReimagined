
local function GetAbilityValues(config)
    local abilityValues = 
    {
        -- Overcharge
        ["UnleashCharge"] = 
        {
            APCost = config.OverchargeAPCost or 7,
            ChargesConsumed = config.VirtualMaxCharges or 100,
            ChargesMultiplier = config.OverchargeDamagePerCharge,
            Description =       "Deals high single target <keyword id=\"Element_Lightning\">Lightning</> damage. 1 hit.\n" ..
                                "Consumes all <keyword id=\"Gustave_Charges\">Charges</> for increased damage.\n" ..
                                "Can <keyword id=\"Break\">Break</>\n" ..
                                "If a target is <keyword id=\"Break\">Broken</> by the hit, Overcharge refills " .. string.format("%g", config.OverchargeChargesPercentage * 100) .. "% of its total <keyword id=\"Gustave_Charges\">Charges</>",
            ShortDescription =  "High <keyword id=\"Element_Lightning\">Lightning</> damage based on the amount of <keyword id=\"Gustave_Charges\">Charges</> 1 hit.\n" ..
                                "Can <keyword id=\"Break\">Break</>\n" ..
                                "If a target is <keyword id=\"Break\">Broken</> by the hit, Overcharge refills " .. string.format("%g", config.OverchargeChargesPercentage * 100) .. "% of its total <keyword id=\"Gustave_Charges\">Charges</>",
        },

        -- Shatter
        ["PerfectBreak_Gustave"] = 
        {
            APCost = config.ShatterAPCost or 8,
            ChargesConsumed = config.VirtualMaxCharges or 100,
            ChargesMultiplier = config.ShatterDamagePerCharge or 0.2,
            Description =       "Deals high <keyword id=\"Element_Lightning\">Lightning</> damage to all enemies. 1 hit.\n" ..
                                "Consumes all <keyword id=\"Gustave_Charges\">Charges</> for increased damage.\n" ..
                                "Can <keyword id=\"Break\">Break</>\n" ..
                                "If a target is <keyword id=\"Break\">Broken</> by the hit, Shatter refills " .. string.format("%g", config.ShatterChargesPercentage * 100) .. "% of its total <keyword id=\"Gustave_Charges\">Charges</>",
            ShortDescription =  "High <keyword id=\"Element_Lightning\">Lightning</> damage based on the amount of <keyword id=\"Gustave_Charges\">Charges</> 1 hit.\n" ..
                                "Can <keyword id=\"Break\">Break</>\n" ..
                                "If a target is <keyword id=\"Break\">Broken</> by the hit, Shatter refills " .. string.format("%g", config.ShatterChargesPercentage * 100) .. "% of its total <keyword id=\"Gustave_Charges\">Charges</>",
        },

        -- Marking Shot
        ["MarkingShot_Gustave"] = 
        {
            APCost = config.MarkingShotAPCost or 4,
            ChargesConsumed = config.MarkingShotChargesConsumed or 10,
            ChargesMultiplier = config.MarkingShotDamagePerCharge or 0.2,
            Description =       "Deals low single target <keyword id=\"Element_Lightning\">Lightning</> damage. 1 hit.\n" ..
                                "Applies <keyword id=\"StatusEffect_Mark\">Mark</>\n" ..
                                "Consumes up to " .. config.MarkingShotChargesConsumed .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
            ShortDescription =  "Low <keyword id=\"Element_Lightning\">Lightning</> damage and applies <keyword id=\"StatusEffect_Mark\">Mark</> 1 hit.\n" .. 
                                "Consumes up to " .. config.MarkingShotChargesConsumed .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
        },

        -- Lumiere Assault
        ["Combo1_Gustave"] = 
        {
            APCost = config.LumiereAssaultAPCost or 3,
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "Deals low single target damage. 5 hits.\n" ..
                                "Uses weapon's element.\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. config.LumiereAssaultChargesPerCritical .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>",
            ShortDescription =  "Low {DynamicElement} damage. 5 hits.\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. config.LumiereAssaultChargesPerCritical .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>",
        },

        -- Strike Storm
        ["StrikeStorm_Gustave"] = 
        {
            APCost = config.StrikeStormAPCost or 7,
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "Deals very high single target damage. 6 hits.\n" ..
                                "Uses weapon's element.\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. config.StrikeStormChargesPerCritical .. " additional <keyword id=\"Gustave_Charges\">Charges</>",
            ShortDescription =  "Very high {DynamicElement} damage. 6 hits.\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. config.StrikeStormChargesPerCritical .. " additional <keyword id=\"Gustave_Charges\">Charges</>",
        },

        -- From Fire
        ["FromFire_Gustave"] = 
        {
            APCost = config.FromFireAPCost or 5,
            ChargesConsumed = config.FromFireChargesConsumed or 15,
            ChargesMultiplier = config.FromFireDamagePerCharge or 0.2,
            Description =       "Deals medium single target damage. 3 hits.\n" ..
                                "Uses weapon's element.\n" ..
                                "<keyword id=\"Heal\">Heals</> self by 20% if the target <keyword id=\"StatusEffect_Burn\">Burns</>\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. config.FromFireChargesPerCritical .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>\n" ..
                                "Consumes up to " .. config.FromFireChargesConsumed .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage and <keyword id=\"Heal\">heal</>",
            ShortDescription =  "Medium {DynamicElement} damage. 3 hits.\n" ..
                                "<keyword id=\"Heal\">Heals</> self by 20% Health if the target <keyword id=\"StatusEffect_Burn\">Burns</>\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. config.FromFireChargesPerCritical .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>\n" ..
                                "Consumes up to " .. config.FromFireChargesConsumed .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage and <keyword id=\"Heal\">heal</>",
        },

        -- Recovery
        ["PerfectRecovery_Gustave"] = 
        {
            APCost = config.RecoveryAPCost or 3,
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "<keyword id=\"Heal\">Recovers</> 50% Health and dispels Status Effects.\n" ..
                                "Refills 0% - " .. string.format("%g", config.RecoveryChargesPercentage * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
            ShortDescription =  "<keyword id=\"Heal\">Recovers</> 50% Health and dispels Status Effects.\n" ..
                                "Refills 0% - " .. string.format("%g", config.RecoveryChargesPercentage * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
        },

        -- Powerful
        ["Powerful_Gustave"] = 
        {
            APCost = config.PowerfulAPCost or 5,
            ChargesConsumed = config.PowerfulChargesConsumed or 50,
            ChargesMultiplier = nil,
            Description =       "Applies <keyword id=\"Buff_Powerful\">Powerful</> to 1-3 allies for 3 turns.\n" ..
                                "Consumes up to " .. config.PowerfulChargesConsumed .. " <keyword id=\"Gustave_Charges\">Charges</> to grant additional buffs to Gustave.\n" ..
                                string.format("%g", config.PowerfulChargesConsumed * 0.2) .. " Charges: Grants <keyword id=\"Buff_Shell_Left\">Shell</> for 3 turns.\n" ..
                                string.format("%g", config.PowerfulChargesConsumed * 0.4) .. " Charges: Grants <keyword id=\"Buff_Rush_Left\">Rush</> for 3 turns.\n" ..
                                string.format("%g", config.PowerfulChargesConsumed * 0.6) .. " Charges: Grants <keyword id=\"Buff_Regen_Left\">Regen</> for 3 turns.\n" ..
                                string.format("%g", config.PowerfulChargesConsumed * 0.8) .. " Charges: Increase turn duration to 5.\n" ..
                                (config.PowerfulChargesConsumed) .. " Charges: Grants <keyword id=\"StatusEffect_Enraged_Left\">Rage</> for 1 turn.",
            ShortDescription =  "Applies <keyword id=\"Buff_Powerful\">Powerful</> to 1-3 allies for 3 turns.\n" ..
                                "Consumes up to " .. config.PowerfulChargesConsumed .. " <keyword id=\"Gustave_Charges\">Charges</> to grant additional buffs to Gustave.\n" ..
                                string.format("%g", config.PowerfulChargesConsumed * 0.2) .. " Charges: Grants <keyword id=\"Buff_Shell_Left\">Shell</> for 3 turns.\n" ..
                                string.format("%g", config.PowerfulChargesConsumed * 0.4) .. " Charges: Grants <keyword id=\"Buff_Rush_Left\">Rush</> for 3 turns.\n" ..
                                string.format("%g", config.PowerfulChargesConsumed * 0.6) .. " Charges: Grants <keyword id=\"Buff_Regen_Left\">Regen</> for 3 turns.\n" ..
                                string.format("%g", config.PowerfulChargesConsumed * 0.8) .. " Charges: Increase turn duration to 5.\n" ..
                                (config.PowerfulChargesConsumed) .. " Charges: Grants <keyword id=\"StatusEffect_Enraged_Left\">Rage</> for 1 turn.",
        },

        -- Light Holder
        ["OldLightHolder"] = 
        {
            APCost = config.LightHolderAPCost or 5,
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "Deals high single target <keyword id=\"Element_Light\">Light</> damage. 5 hits.\n" ..
                                "Damage increased by " .. (config.LightHolderDamagePerHealthChunk * 100) .. "% per " .. config.LightHolderHealthChunkSize .. " max health.\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. config.LightHolderChargesPerCritical .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>",
            ShortDescription =  "High <keyword id=\"Element_Light\">Light</> damage increased by " .. (config.LightHolderDamagePerHealthChunk * 100) .. "% per " .. config.LightHolderHealthChunkSize .. " max health. 5 hits.\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. config.LightHolderChargesPerCritical .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>",
        },

        -- Radiant Strike
        ["RadiantStrike"] = 
        {
            APCost = config.RadiantStrikeAPCost or 6,
            ChargesConsumed = config.RadiantStrikeChargesConsumed or 20,
            ChargesMultiplier = config.RadiantStrikeDamagePerCharge or 0.2,
            Description =       "Deals low <keyword id=\"Element_Light\">Light</> damage to all enemies. 1 hit.\n" ..
                                "Consumes up to " .. config.RadiantStrikeChargesConsumed .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
            ShortDescription =  "Deals low <keyword id=\"Element_Light\">Light</> damage to all enemies. 1 hit.\n" ..
                                "Consumes up to " .. config.RadiantStrikeChargesConsumed .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
        },

        --------------------------------------------------
        -- Perfection abilities shared by other character.
        --------------------------------------------------

        -- Overload
        ["Overcharge"] = 
        {
            APCost = config.OverloadAPCost or 6,
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "Refills all <keyword id=\"APShard\">AP</> but sets self-Health to 1.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: Increases Rank to <img id=\"Rank_A\"/>\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Refills " .. string.format("%g", config.OverloadChargesPercentage * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
            ShortDescription =  "Refills all <keyword id=\"APShard\">AP</> but sets self-Health to 1.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: Increases Rank to <img id=\"Rank_A\"/>\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Refills " .. string.format("%g", config.OverloadChargesPercentage * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
        },

        -- Steeled Strike
        ["SteeledStrike"] = 
        {
            APCost = config.SteeledStrikeAPCost or 9,
            ChargesConsumed = config.SteeledStrikeChargesConsumed or 50,
            ChargesMultiplier = config.SteeledStrikeDamagePerCharge,
            Description =       "After 1 turn, deals extreme single target <keyword id=\"Element_Physical\">Physical</> damage. 13 hits.\n" ..
                                "Interrupted if any damage taken.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_S\"/>: Increased damage.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. config.SteeledStrikeChargesConsumed .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
            ShortDescription =  "After 1 turn, extreme <keyword id=\"Element_Physical\">Physical</> damage. 13 hits.\n" ..
                                "Interrupted if any damage taken.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_S\"/>: Increased damage.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. config.SteeledStrikeChargesConsumed .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
        },

        -- Steeled Strike
        ["EndBringer"] = 
        {
            APCost = config.EndbringerAPCost or 9,
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "Deals extreme single target <keyword id=\"Element_Physical\">Physical</> damage. 6 hits.\n" ..
                                "Increased damage if the target is <keyword id=\"StatusEffect_Stunned\">Stunned</>\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_A\"/>: Can reapply <keyword id=\"StatusEffect_Stunned\">Stun</>\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: <keyword id=\"StatusEffect_Stunned\">Stun Hits</> generate " .. config.EndbringerChargesPerStunnedHit .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>",
            ShortDescription =  "Extreme <keyword id=\"Element_Physical\">Physical</> damage. 6 hits.\n" ..
                                "Increased damage if the target is <keyword id=\"StatusEffect_Stunned\">Stunned</>\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_A\"/>: Can reapply <keyword id=\"StatusEffect_Stunned\">Stun</>\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: <keyword id=\"StatusEffect_Stunned\">Stun Hits</> generate " .. config.EndbringerChargesPerStunnedHit .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>",
        },
    }

    return abilityValues
end

return GetAbilityValues