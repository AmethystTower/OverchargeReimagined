
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

local function GetAbilityValues(config)
    local abilityValues = 
    {
        -- Overcharge
        ["UnleashCharge"] = 
        {
            APCost = config.OverchargeAPCost or 6,
            ChargesConsumed = config.VirtualMaxCharges or 100,
            ChargesMultiplier = config.OverchargeDamagePerCharge or 0.15,
            Description =       "150% <keyword id=\"Element_Lightning\">Lightning</> damage. [<text color=\"#D5B87C\">1x</>]\n" ..
                                "Consumes all <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", 20 + ((config.OverchargeDamagePerCharge or 0.15) * 100)) .. "% damage per charge.\n" ..
                                "Deals " .. string.format("%g", 20 + ((config.OverchargeMaxChargesBonus or 0.15) * 100)) .. "% more damage if charges are at max.\n" ..
                                "Can <keyword id=\"Break\">Stun</>\n" ..
                                "If a target is <keyword id=\"Break\">Stunned</> by the hit, Overcharge refills " .. string.format("%g", (config.OverchargeChargesPercentage or 0.25) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
            ShortDescription =  "150% <keyword id=\"Element_Lightning\">Lightning</> damage. [<text color=\"#D5B87C\">1x</>]\n" ..
                                "Consumes all <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", 20 + ((config.OverchargeDamagePerCharge or 0.15) * 100)) .. "% damage per charge.\n" ..
                                "Deals " .. string.format("%g", 20 + ((config.OverchargeMaxChargesBonus or 0.15) * 100)) .. "% more damage if charges are at max.\n" ..
                                "Can <keyword id=\"Break\">Stun</>\n" ..
                                "If a target is <keyword id=\"Break\">Stunned</> by the hit, Overcharge refills " .. string.format("%g", (config.OverchargeChargesPercentage or 0.25) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
            PerfectionDescription = nil,
            OverchargeDescription = nil,
        },

        -- Shatter
        ["PerfectBreak_Gustave"] = 
        {
            APCost = config.ShatterAPCost or 6,
            ChargesConsumed = config.VirtualMaxCharges or 100,
            ChargesMultiplier = config.ShatterDamagePerCharge or 0.2,
            Description =       "175% <keyword id=\"Element_Lightning\">Lightning</> damage to all enemies. [<text color=\"#D5B87C\">1x</>]\n" ..
                                "Consumes all <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.ShatterDamagePerCharge or 0.3) * 100) .. "% damage per charge.\n" ..
                                "Deals " .. string.format("%g", (config.ShatterMaxChargesBonus or 0.35) * 100) .. "% more damage if charges are at max.\n" ..
                                "Can <keyword id=\"Break\">Stun</>\n" ..
                                "If a target is <keyword id=\"Break\">Stunned</> by the hit, Shatter refills " .. string.format("%g", (config.ShatterChargesPercentage or 0.2) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
            ShortDescription =  "175% <keyword id=\"Element_Lightning\">Lightning</> damage to all enemies. [<text color=\"#D5B87C\">1x</>]\n" ..
                                "Consumes all <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.ShatterDamagePerCharge or 0.3) * 100) .. "% damage per charge.\n" ..
                                "Deals " .. string.format("%g", (config.ShatterMaxChargesBonus or 0.35) * 100) .. "% more damage if charges are at max.\n" ..
                                "Can <keyword id=\"Break\">Stun</>\n" ..
                                "If a target is <keyword id=\"Break\">Stunned</> by the hit, Shatter refills " .. string.format("%g", (config.ShatterChargesPercentage or 0.2) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
            PerfectionDescription = nil,
            OverchargeDescription = nil,
        },

        -- Marking Shot
        ["MarkingShot_Gustave"] = 
        {
            APCost = config.MarkingShotAPCost or 2,
            ChargesConsumed = config.MarkingShotChargesConsumed or 10,
            ChargesMultiplier = config.MarkingShotDamagePerCharge or 0.2,
            Description =       "100% <keyword id=\"Element_Lightning\">Lightning</> damage. [<text color=\"#D5B87C\">1x</>]\n" ..
                                "Applies <keyword id=\"StatusEffect_Mark\">Mark</> on hit.\n" ..
                                "Consumes up to " .. (config.MarkingShotChargesConsumed or 10) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.MarkingShotDamagePerCharge or 0.2) * 100) .. "% more damage per charge.",
            ShortDescription =  "100% <keyword id=\"Element_Lightning\">Lightning</> damage. [<text color=\"#D5B87C\">1x</>]\n" ..
                                "Applies <keyword id=\"StatusEffect_Mark\">Mark</> on hit.\n" ..
                                "Consumes up to " .. (config.MarkingShotChargesConsumed or 10) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.MarkingShotDamagePerCharge or 0.2) * 100) .. "% more damage per charge.",
            PerfectionDescription = nil,
            OverchargeDescription = nil,
        },

        -- Lumiere Assault
        ["Combo1_Gustave"] = 
        {
            APCost = config.LumiereAssaultAPCost or 3,
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "125% damage over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\n" ..
                                "Uses weapon's element.\n" ..
                                "Gets interrupted if failed.\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.LumiereAssaultChargesPerCritical or 1) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>",
            ShortDescription =  "125% {DynamicElement} damage over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\n" ..
                                "Gets interrupted if failed.\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.LumiereAssaultChargesPerCritical or 1) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>",
            PerfectionDescription = nil,
            OverchargeDescription = nil,
        },

        -- Strike Storm
        ["StrikeStorm_Gustave"] = 
        {
            APCost = config.StrikeStormAPCost or 7,
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "420% damage over 6 hits. [<text color=\"#D5B87C\">0.3x</>]\n" ..
                                "Uses weapon's element.\n" ..
                                "Gets interrupted if failed.\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.StrikeStormChargesPerCritical or 3) .. " additional <keyword id=\"Gustave_Charges\">Charges</>",
            ShortDescription =  "420% {DynamicElement} damage over 6 hits. [<text color=\"#D5B87C\">0.3x</>]\n" ..
                                "Gets interrupted if failed.\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.StrikeStormChargesPerCritical or 3) .. " additional <keyword id=\"Gustave_Charges\">Charges</>",
            PerfectionDescription = nil,
            OverchargeDescription = nil,
        },

        -- From Fire
        ["FromFire_Gustave"] = 
        {
            APCost = config.FromFireAPCost or 5,
            ChargesConsumed = config.FromFireChargesConsumed or 15,
            ChargesMultiplier = config.FromFireDamagePerCharge or 0.2,
            Description =       "187.5% damage over 3 hits. [<text color=\"#D5B87C\">0.5x</>]\n" ..
                                "Uses weapon's element.\n" ..
                                "<keyword id=\"Heal\">Recover</> 20% Health when used against a <keyword id=\"StatusEffect_Burn\">Burning</> enemy.\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.FromFireChargesPerCritical or 2) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>\n" ..
                                "Consumes up to " .. (config.FromFireChargesConsumed or 15) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.FromFireDamagePerCharge or 0.2) * 100) .. "% more damage and +" .. string.format("%g", (config.FromFireHealPerCharge or 0.01) * 100) .. "% <keyword id=\"Heal\">heal</> per charge.",
            ShortDescription =  "187.5% {DynamicElement} damage over 3 hits. [<text color=\"#D5B87C\">0.5x</>]\n" ..
                                "<keyword id=\"Heal\">Recover</> 20% Health when used against a <keyword id=\"StatusEffect_Burn\">Burning</> enemy.\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.FromFireChargesPerCritical or 2) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>\n" ..
                                "Consumes up to " .. (config.FromFireChargesConsumed or 15) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.FromFireDamagePerCharge or 0.2) * 100) .. "% more damage and +" .. string.format("%g", (config.FromFireHealPerCharge or 0.01) * 100) .. "% <keyword id=\"Heal\">heal</> per charge.",
            PerfectionDescription = nil,
            OverchargeDescription = nil,
        },

        -- Recovery
        ["PerfectRecovery_Gustave"] = 
        {
            APCost = config.RecoveryAPCost or 3,
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "<keyword id=\"Heal\">Recover</> 50% Health and cleanse Status Effects.\n" ..
                                "Gain 0% - " .. string.format("%g", (config.RecoveryChargesPercentage or 0.1) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
            ShortDescription =  "<keyword id=\"Heal\">Recover</> 50% Health and cleanse Status Effects.\n" ..
                                "Gain 0% - " .. string.format("%g", (config.RecoveryChargesPercentage or 0.1) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
            PerfectionDescription = nil,
            OverchargeDescription = nil,
        },

        -- Powerful
        ["Powerful_Gustave"] = 
        {
            APCost = config.PowerfulAPCost or 4,
            ChargesConsumed = config.PowerfulChargesConsumed or 50,
            ChargesMultiplier = nil,
            Description =       "Apply <keyword id=\"Buff_Powerful\">Powerful</> to 1-3 allies.\n" ..
                                "Consumes <keyword id=\"Gustave_Charges\">Charges</> to empower Gustave:\n" ..
                                string.format("%g", (config.PowerfulChargesConsumed or 50) * 0.2) .. " Charges: Apply <keyword id=\"Buff_Shell_Left\">Shell</> for 3 turns.\n" ..
                                string.format("%g", (config.PowerfulChargesConsumed or 50) * 0.4) .. " Charges: Apply <keyword id=\"Buff_Rush_Left\">Rush</> for 3 turns.\n" ..
                                string.format("%g", (config.PowerfulChargesConsumed or 50) * 0.6) .. " Charges: Apply <keyword id=\"StatusEffect_Berserk_Left\">Berserk</> for 3 turns.\n" ..
                                string.format("%g", (config.PowerfulChargesConsumed or 50) * 0.8) .. " Charges: Increase turn duration to 6.\n" ..
                                (config.PowerfulChargesConsumed or 50) .. " Charges: Apply <keyword id=\"StatusEffect_Enraged_Left\">Rage</> for 1 turn.",
            ShortDescription =  "Apply <keyword id=\"Buff_Powerful\">Powerful</> to 1-3 allies.\n" ..
                                "Consumes <keyword id=\"Gustave_Charges\">Charges</> to empower Gustave:\n" ..
                                "<keyword id=\"Element_Lightning\">" .. string.format("%g", (config.PowerfulChargesConsumed or 50) * 0.2) .. "</>: <keyword id=\"Buff_Shell_Left\">Shell</> / " ..
                                "<keyword id=\"Element_Lightning\">" .. string.format("%g", (config.PowerfulChargesConsumed or 50) * 0.4) .. "</>: <keyword id=\"Buff_Rush_Left\">Rush</> /\n" ..
                                "<keyword id=\"Element_Lightning\">" .. string.format("%g", (config.PowerfulChargesConsumed or 50) * 0.6) .. "</>: <keyword id=\"StatusEffect_Berserk_Left\">Berserk</> / " ..
                                "<keyword id=\"Element_Lightning\">" .. string.format("%g", (config.PowerfulChargesConsumed or 50) * 0.8) .. "</>: 6-turn duration /\n" ..
                                "<keyword id=\"Element_Lightning\">" .. string.format("%g", (config.PowerfulChargesConsumed or 50)) .. "</>: <keyword id=\"StatusEffect_Enraged_Left\">Rage</> for 1 turn.",
            PerfectionDescription = nil,
            OverchargeDescription = nil,
        },

        -- Light Holder
        ["OldLightHolder"] = 
        {
            APCost = config.LightHolderAPCost or 5,
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "345% <keyword id=\"Element_Light\">Light</> damage over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\n" ..
                                "Deals +" .. string.format("%g", (config.LightHolderDamagePerHealthChunk or 0.01) * 100) .. "% more damage per " .. (config.LightHolderHealthChunkSize or 100) .. " max health.\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.LightHolderChargesPerCritical or 2) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>",
            ShortDescription =  "345% <keyword id=\"Element_Light\">Light</> damage over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\n" ..
                                "Deals +" .. string.format("%g", (config.LightHolderDamagePerHealthChunk or 0.01) * 100) .. "% more damage per " .. (config.LightHolderHealthChunkSize or 100) .. " max health.\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.LightHolderChargesPerCritical or 2) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>",
            PerfectionDescription = nil,
            OverchargeDescription = nil,
        },

        -- Radiant Strike
        ["RadiantStrike"] = 
        {
            APCost = config.RadiantStrikeAPCost or 6,
            ChargesConsumed = config.RadiantStrikeChargesConsumed or 20,
            ChargesMultiplier = config.RadiantStrikeDamagePerCharge or 0.2,
            Description =       "140% <keyword id=\"Element_Light\">Light</> damage to all enemies. [<text color=\"#D5B87C\">1x</>]\n" ..
                                "Consumes up to " .. (config.RadiantStrikeChargesConsumed or 20) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.RadiantStrikeDamagePerCharge or 0.2) * 100) .. "% more damage per charge.",
            ShortDescription =  "140% <keyword id=\"Element_Light\">Light</> damage to all enemies. [<text color=\"#D5B87C\">1x</>]\n" ..
                                "Consumes up to " .. (config.RadiantStrikeChargesConsumed or 20) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.RadiantStrikeDamagePerCharge or 0.2) * 100) .. "% more damage per charge.",
            PerfectionDescription = nil,
            OverchargeDescription = nil,
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
            Description =       "Set Health to 1 and recover all <keyword id=\"APShard\">AP</>\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: Set rank to <img id=\"Rank_A\"/>\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Refill " .. string.format("%g", (config.OverloadChargesPercentage or 0.5) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
            ShortDescription =  "Set Health to 1 and recover all <keyword id=\"APShard\">AP</>\n",
            PerfectionDescription = "Set rank to <img id=\"Rank_A\"/>",
            OverchargeDescription = "Refill " .. string.format("%g", (config.OverloadChargesPercentage or 0.5) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
        },

        -- Steeled Strike
        ["SteeledStrike"] = 
        {
            APCost = config.SteeledStrikeAPCost or 9,
            ChargesConsumed = config.SteeledStrikeChargesConsumed or 50,
            ChargesMultiplier = config.SteeledStrikeDamagePerCharge or 0.2,
            Description =       "After 1 turn, deals 650% <keyword id=\"Element_Physical\">Physical</> damage over 13 hits. [<text color=\"#D5B87C\">0.1x</>]\n" ..
                                "Interrupted if any damage taken.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_S\"/>: Deals 150% more damage.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. (config.SteeledStrikeChargesConsumed or 50) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.SteeledStrikeDamagePerCharge or 0.2) * 100) .. "% more damage per charge.",
            ShortDescription =  "After 1 turn, deals 650% <keyword id=\"Element_Physical\">Physical</> damage over 13 hits. [<text color=\"#D5B87C\">0.1x</>]\n" ..
                                "Interrupted if any damage taken.\n",
            PerfectionDescription = "<img id=\"Rank_S\"/>: Deals 150% more damage.",
            OverchargeDescription = "Consumes up to " .. (config.SteeledStrikeChargesConsumed or 50) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.SteeledStrikeDamagePerCharge or 0.2) * 100) .. "% more damage per charge.",
        },

        -- Endbringer
        ["EndBringer"] = 
        {
            APCost = config.EndbringerAPCost or 9,
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "720% <keyword id=\"Element_Physical\">Physical</> damage over 6 hits. [<text color=\"#D5B87C\">0.2x</>]\n" ..
                                "Deals 200% more damage if the target is <keyword id=\"StatusEffect_Stunned\">Stunned</>\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_A\"/>: Can reapply <keyword id=\"StatusEffect_Stunned\">Stun</>\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: <keyword id=\"StatusEffect_Stunned\">Stun Hits</> generate " .. (config.EndbringerChargesPerStunnedHit or 5) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>",
            ShortDescription =  "720% <keyword id=\"Element_Physical\">Physical</> damage over 6 hits. [<text color=\"#D5B87C\">0.2x</>]\n" ..
                                "Deals 200% more damage if the target is <keyword id=\"StatusEffect_Stunned\">Stunned</>\n",
            PerfectionDescription = "<img id=\"Rank_A\"/>: Can reapply <keyword id=\"StatusEffect_Stunned\">Stun</>",
            OverchargeDescription = "<keyword id=\"StatusEffect_Stunned\">Stun Hits</> generate " .. (config.EndbringerChargesPerStunnedHit or 5) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>",
        },

        -- Berserk Slash
        ["BerserkSlash"] = 
        {
            APCost = config.BerserkSlashAPCost or 4,
            ChargesConsumed = config.BerserkSlashChargesConsumed or 10,
            ChargesMultiplier = config.BerserkSlashDamagePerCharge or 0.2,
            Description =       "60% <keyword id=\"Element_Physical\">Physical</> damage over 3 hits. [<text color=\"#D5B87C\">0.5x</>]\n" ..
                                "Deals +15% more damage per missing 1% health.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_C\"/>: Deals 50% more damage.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. (config.BerserkSlashChargesConsumed or 10) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.BerserkSlashDamagePerCharge or 0.2) * 100) .. "% more damage per charge.",
            ShortDescription =  "60% <keyword id=\"Element_Physical\">Physical</> damage over 3 hits. [<text color=\"#D5B87C\">0.5x</>]\n" ..
                                "Deals +15% more damage per missing 1% health.\n",
            PerfectionDescription = "<img id=\"Rank_C\"/>: Deals 50% more damage.",
            OverchargeDescription = "Consumes up to " .. (config.BerserkSlashChargesConsumed or 10) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.BerserkSlashDamagePerCharge or 0.2) * 100) .. "% more damage per charge.",
        },

        -- Defiant Strike
        ["DefiantStrike"] = 
        {
            APCost = config.DefiantStrikeAPCost or 3,
            ChargesConsumed = config.DefiantStrikeChargesConsumed or 15,
            ChargesMultiplier = config.DefiantStrikeDamagePerCharge or 0.2,
            Description =       "400% <keyword id=\"Element_Physical\">Physical</> damage over 2 hits. [<text color=\"#D5B87C\">0.7x</>]\n" ..
                                "Last hit applies <keyword id=\"StatusEffect_Mark\">Mark</>\n" ..
                                "Costs 30% of current Health.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_B\"/>: Deals 50% more damage.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. (config.DefiantStrikeChargesConsumed or 15) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.DefiantStrikeDamagePerCharge or 0.2) * 100) .. "% more damage per charge.",
            ShortDescription =  "400% <keyword id=\"Element_Physical\">Physical</> damage over 2 hits. [<text color=\"#D5B87C\">0.7x</>]\n" ..
                                "Last hit applies <keyword id=\"StatusEffect_Mark\">Mark</>\n" ..
                                "Costs 30% of current Health.\n",
            PerfectionDescription = "<img id=\"Rank_B\"/>: Deals 50% more damage.",
            OverchargeDescription = "Consumes up to " .. (config.DefiantStrikeChargesConsumed or 15) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.DefiantStrikeDamagePerCharge or 0.2) * 100) .. "% more damage per charge.",
        },

        -- Blitz
        ["Blitz"] = 
        {
            APCost = config.BlitzAPCost or 3,
            ChargesConsumed = config.BlitzChargesConsumed or 5,
            ChargesMultiplier = config.BlitzDamagePerCharge or 0.2,
            Description =       "150% <keyword id=\"Element_Physical\">Physical</> damage. [<text color=\"#D5B87C\">1x</>]\n" ..
                                "Kills non-boss enemies with less than 10% Health.\n" ..
                                "Play a second turn.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_B\"/>: Deals 50% more damage.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. (config.BlitzChargesConsumed or 5) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.BlitzDamagePerCharge or 0.2) * 100) .. "% more damage per charge.",
            ShortDescription =  "150% <keyword id=\"Element_Physical\">Physical</> damage. [<text color=\"#D5B87C\">1x</>]\n" ..
                                "Kills non-boss enemies with less than 10% Health.\n" ..
                                "Play a second turn.\n",
            PerfectionDescription = "<img id=\"Rank_B\"/>: Deals 50% more damage.",
            OverchargeDescription = "Consumes up to " .. (config.BlitzChargesConsumed or 5) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.BlitzDamagePerCharge or 0.2) * 100) .. "% more damage per charge.",
        },

        -- Follow Up
        ["FollowUp"] = 
        {
            APCost = config.FollowUpAPCost or 5,
            ChargesConsumed = config.FollowUpChargesConsumed or 15,
            ChargesMultiplier = config.FollowUpDamagePerCharge or 0.2,
            Description =       "200% <keyword id=\"Element_Light\">Light</> damage. [<text color=\"#D5B87C\">1x</>]\n" ..
                                "Deals +50% more damage per Free Aim shot fired this turn, up to 10 times.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_S\"/>: Costs 2 <keyword id=\"APShard\">AP</> instead.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. (config.FollowUpChargesConsumed or 15) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.FollowUpDamagePerCharge or 0.2) * 100) .. "% more damage per charge. Costs " .. (config.FollowUpAPReducedCost or 2) .. " <keyword id=\"APShard\">AP</> if required charges are available.",
            ShortDescription =  "200% <keyword id=\"Element_Light\">Light</> damage. [<text color=\"#D5B87C\">1x</>]\n" ..
                                "Deals +50% more damage per Free Aim shot fired this turn, up to 10 times.\n",
            PerfectionDescription = "<img id=\"Rank_S\"/>: Costs 2 <keyword id=\"APShard\">AP</> instead.",
            OverchargeDescription = "Consumes up to " .. (config.FollowUpChargesConsumed or 15) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.FollowUpDamagePerCharge or 0.2) * 100) .. "% more damage per charge. Costs " .. (config.FollowUpAPReducedCost or 2) .. " <keyword id=\"APShard\">AP</> if required charges are available.",
        },

        -- Ascending Assault
        ["AscendingAssault"] = 
        {
            APCost = config.AscendingAssaultAPCost or 5,
            ChargesConsumed = config.AscendingAssaultChargesConsumed or 20,
            ChargesMultiplier = config.AscendingAssaultDamagePerCharge or 0.2,
            Description =       "250% damage. [<text color=\"#D5B87C\">1x</>]\n" ..
                                "Uses weapon's element.\n" ..
                                "Deals +30% more damage per previous cast, up to 5 times.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_S\"/>: Costs 2 <keyword id=\"APShard\">AP</> instead.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. (config.AscendingAssaultChargesConsumed or 20) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.AscendingAssaultDamagePerCharge or 0.2) * 100) .. "% more damage per charge. Costs " .. (config.AscendingAssaultAPReducedCost or 2) .. " <keyword id=\"APShard\">AP</> if required charges are available.",
            ShortDescription =  "250% {DynamicElement} damage. [<text color=\"#D5B87C\">1x</>]\n" ..
                                "Deals +30% more damage per previous cast, up to 5 times.\n",
            PerfectionDescription = "<img id=\"Rank_S\"/>: Costs 2 <keyword id=\"APShard\">AP</> instead.",
            OverchargeDescription = "Consumes up to " .. (config.AscendingAssaultChargesConsumed or 20) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.AscendingAssaultDamagePerCharge or 0.2) * 100) .. "% more damage per charge. Costs " .. (config.AscendingAssaultAPReducedCost or 2) .. " <keyword id=\"APShard\">AP</> if required charges are available.",
        },

        -- Speed Burst
        ["SpeedBurst"] = 
        {
            APCost = config.SpeedBurstAPCost or 6,
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "250% <keyword id=\"Element_Light\">Light</> damage over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\n" ..
                                "Damage increased by Speed difference with target, up to 100% more damage.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_C\"/>: Deals 100% more damage.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Generates " .. (config.SpeedBurstChargesPerHit or 1) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</> per hit.",
            ShortDescription =  "250% <keyword id=\"Element_Light\">Light</> damage over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\n" ..
                                "Damage increased by Speed difference with target, up to 100% more damage.\n",
            PerfectionDescription = "<img id=\"Rank_C\"/>: Deals 100% more damage.",
            OverchargeDescription = "Generates " .. (config.SpeedBurstChargesPerHit or 1) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</> per hit.",
        },

        -- Phantom Stars
        ["PhantomStars"] = 
        {
            APCost = config.PhantomStarsAPCost or 9,
            ChargesConsumed = config.PhantomStarsChargesConsumed or 40,
            ChargesMultiplier = config.PhantomStarsDamagePerCharge or 0.2,
            Description =       "350% <keyword id=\"Element_Light\">Light</> damage to all enemies over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\n" .. 
                                "Can <keyword id=\"Break\">Stun</>\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_S\"/>: Costs 5 <keyword id=\"APShard\">AP</> instead.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. (config.PhantomStarsChargesConsumed or 40) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.PhantomStarsDamagePerCharge or 0.2) * 100) .. "% more damage per charge. Costs " .. (config.PhantomStarsAPReducedCost or 5) .. " <keyword id=\"APShard\">AP</> if required charges are available.\n" ..
                                "If a target is <keyword id=\"Break\">Stunned</> by the hit, Phantom Stars refills " .. string.format("%g", (config.PhantomStarsChargesPercentage or 0.1) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
            ShortDescription =  "350% <keyword id=\"Element_Light\">Light</> damage to all enemies over 5 hits. [<text color=\"#D5B87C\">0.3x</>]\n" ..
                                "Can <keyword id=\"Break\">Stun</>\n",
            PerfectionDescription = "<img id=\"Rank_S\"/>: Costs 5 <keyword id=\"APShard\">AP</> instead.",
            OverchargeDescription = "Consumes up to " .. (config.PhantomStarsChargesConsumed or 40) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.PhantomStarsDamagePerCharge or 0.2) * 100) .. "% more damage per charge. Costs " .. (config.PhantomStarsAPReducedCost or 5) .. " <keyword id=\"APShard\">AP</> if required charges are available.\n" ..
                                    "If a target is <keyword id=\"Break\">Stunned</> by the hit, Phantom Stars refills " .. string.format("%g", (config.PhantomStarsChargesPercentage or 0.1) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
        },

        -- Paradigm Shift
        ["ParadigmShift"] = 
        {
            APCost = config.ParadigmShiftAPCost or 1,
            ChargesConsumed = config.ParadigmShiftChargesConsumed or 1,
            ChargesMultiplier = nil,
            Description =       "90% <keyword id=\"Element_Physical\">Physical</> damage over 3 hits. [<text color=\"#D5B87C\">0.7x</>]\n" ..
                                "Recover 1-3 <keyword id=\"APShard\">AP</> on completion.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_C\"/>: +1 more <keyword id=\"APShard\">AP</> recovered.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes " .. (config.ParadigmShiftChargesConsumed or 1) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> per hit to give +1 <keyword id=\"APShard\">AP</> per charge.",
            ShortDescription =  "90% <keyword id=\"Element_Physical\">Physical</> damage over 3 hits. [<text color=\"#D5B87C\">0.7x</>]\n" ..
                                "Recover 1-3 <keyword id=\"APShard\">AP</> on completion.\n",
            PerfectionDescription = "<img id=\"Rank_C\"/>: +1 more <keyword id=\"APShard\">AP</> recovered.",
            OverchargeDescription = "Consumes " .. (config.ParadigmShiftChargesConsumed or 1) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> per hit to give +1 <keyword id=\"APShard\">AP</> per charge.",
        },

        -- Purification
        ["Purification"] = 
        {
            APCost = config.PurificationAPCost or 4,
            ChargesConsumed = config.PurificationChargesConsumed or 10,
            ChargesMultiplier = config.PurificationDamagePerCharge or 0.2,
            Description =       "250% <keyword id=\"Element_Light\">Light</> damage over 2 hits. [<text color=\"#D5B87C\">0.7x</>]\n" ..
                                "Cleanse all Status Effects from his character upon casting.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_B\"/>: Deals 100% more damage.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. (config.PurificationChargesConsumed or 10) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.PurificationDamagePerCharge or 0.2) * 100) .. "% more damage per charge.",
            ShortDescription =  "250% <keyword id=\"Element_Light\">Light</> damage over 2 hits. [<text color=\"#D5B87C\">0.7x</>]\n" ..
                                "Cleanse all Status Effects from his character upon casting.\n",
            PerfectionDescription = "<img id=\"Rank_B\"/>: Deals 100% more damage.",
            OverchargeDescription = "Consumes up to " .. (config.PurificationChargesConsumed or 10) .. " <keyword id=\"Gustave_Charges\">Charges</> for +" .. string.format("%g", (config.PurificationDamagePerCharge or 0.2) * 100) .. "% more damage per charge.",
        },

        -- Angel's Eyes
        ["AngelsEyes"] = 
        {
            APCost = 3, -- This is the gradient cost, modifiying this is not recommended.
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "800% <keyword id=\"Element_Physical\">Physical</> damage over 8 hits. [<text color=\"#D5B87C\">0.1x</>]\n" ..
                                "Gain Aureole, reviving this character if they die.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: Gain 1 additional <keyword id=\"Perfection\">Perfection</> per hit.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Gain " .. (config.AngelsEyesAdditionalChargesPerHit or 3) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</> per hit.",
            ShortDescription =  "800% <keyword id=\"Element_Physical\">Physical</> damage over 8 hits. [<text color=\"#D5B87C\">0.1x</>]\n" ..
                                "Gain Aureole, reviving this character if they die.\n",
            PerfectionDescription = "Gain 1 additional <keyword id=\"Perfection\">Perfection</> per hit.",
            OverchargeDescription = "Gain " .. (config.AngelsEyesAdditionalChargesPerHit or 3) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</> per hit.",
        },
    }

    return abilityValues
end

-- Expose the function to main.lua.
return GetAbilityValues