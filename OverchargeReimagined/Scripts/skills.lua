
-- TODO: Reduce duplicated strings.
-- I don't like the way this code here is right now but I'll take care of this in the near future.
-- It is like this since I didn't have a clear design yet in mind and did everything on the fly, so I added new stuff when I had new ideas.

-- DO NOT MODIFY THIS MODULE IF YOU SIMPLY WANT TO CUSTOMIZE THIS MOD.
-- Use the config.lua for that instead!

-- This function returns a list with the settings for all modified abilities like AP cost, consumed charges, damage multiplier per charge and dynamic descriptions.
-- Maybe not the most ideal to create this list everytime we need it, but it gets the job done for now considering this is in Lua.
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
                                "If a target is <keyword id=\"Break\">Broken</> by the hit, Overcharge refills " .. string.format("%g", (config.OverchargeChargesPercentage or 0.25) * 100) .. "% of its total <keyword id=\"Gustave_Charges\">Charges</>",
            ShortDescription =  "High <keyword id=\"Element_Lightning\">Lightning</> damage based on the amount of <keyword id=\"Gustave_Charges\">Charges</> 1 hit.\n" ..
                                "Can <keyword id=\"Break\">Break</>\n" ..
                                "If a target is <keyword id=\"Break\">Broken</> by the hit, Overcharge refills " .. string.format("%g", (config.OverchargeChargesPercentage or 0.25) * 100) .. "% of its total <keyword id=\"Gustave_Charges\">Charges</>",
            PerfectionDescription = nil,
            OverchargeDescription = nil,
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
                                "If a target is <keyword id=\"Break\">Broken</> by the hit, Shatter refills " .. string.format("%g", (config.ShatterChargesPercentage or 0.2) * 100) .. "% of its total <keyword id=\"Gustave_Charges\">Charges</>",
            ShortDescription =  "High <keyword id=\"Element_Lightning\">Lightning</> damage based on the amount of <keyword id=\"Gustave_Charges\">Charges</> 1 hit.\n" ..
                                "Can <keyword id=\"Break\">Break</>\n" ..
                                "If a target is <keyword id=\"Break\">Broken</> by the hit, Shatter refills " .. string.format("%g", (config.ShatterChargesPercentage or 0.2) * 100) .. "% of its total <keyword id=\"Gustave_Charges\">Charges</>",
            PerfectionDescription = nil,
            OverchargeDescription = nil,
        },

        -- Marking Shot
        ["MarkingShot_Gustave"] = 
        {
            APCost = config.MarkingShotAPCost or 4,
            ChargesConsumed = config.MarkingShotChargesConsumed or 10,
            ChargesMultiplier = config.MarkingShotDamagePerCharge or 0.2,
            Description =       "Deals low single target <keyword id=\"Element_Lightning\">Lightning</> damage. 1 hit.\n" ..
                                "Applies <keyword id=\"StatusEffect_Mark\">Mark</>\n" ..
                                "Consumes up to " .. (config.MarkingShotChargesConsumed or 10) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
            ShortDescription =  "Low <keyword id=\"Element_Lightning\">Lightning</> damage and applies <keyword id=\"StatusEffect_Mark\">Mark</> 1 hit.\n" .. 
                                "Consumes up to " .. (config.MarkingShotChargesConsumed or 10) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
            PerfectionDescription = nil,
            OverchargeDescription = nil,
        },

        -- Lumiere Assault
        ["Combo1_Gustave"] = 
        {
            APCost = config.LumiereAssaultAPCost or 3,
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "Deals low single target damage. 5 hits.\n" ..
                                "Uses weapon's element.\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.LumiereAssaultChargesPerCritical or 1) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>",
            ShortDescription =  "Low {DynamicElement} damage. 5 hits.\n" ..
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
            Description =       "Deals very high single target damage. 6 hits.\n" ..
                                "Uses weapon's element.\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.StrikeStormChargesPerCritical or 3) .. " additional <keyword id=\"Gustave_Charges\">Charges</>",
            ShortDescription =  "Very high {DynamicElement} damage. 6 hits.\n" ..
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
            Description =       "Deals medium single target damage. 3 hits.\n" ..
                                "Uses weapon's element.\n" ..
                                "<keyword id=\"Heal\">Heals</> self by 20% if the target <keyword id=\"StatusEffect_Burn\">Burns</>\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.FromFireChargesPerCritical or 2) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>\n" ..
                                "Consumes up to " .. (config.FromFireChargesConsumed or 15) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage and <keyword id=\"Heal\">heal</>",
            ShortDescription =  "Medium {DynamicElement} damage. 3 hits.\n" ..
                                "<keyword id=\"Heal\">Heals</> self by 20% Health if the target <keyword id=\"StatusEffect_Burn\">Burns</>\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.FromFireChargesPerCritical or 2) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>\n" ..
                                "Consumes up to " .. (config.FromFireChargesConsumed or 15) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage and <keyword id=\"Heal\">heal</>",
            PerfectionDescription = nil,
            OverchargeDescription = nil,
        },

        -- Recovery
        ["PerfectRecovery_Gustave"] = 
        {
            APCost = config.RecoveryAPCost or 3,
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "<keyword id=\"Heal\">Recovers</> 50% Health and dispels Status Effects.\n" ..
                                "Refills 0% - " .. string.format("%g", (config.RecoveryChargesPercentage or 0.1) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
            ShortDescription =  "<keyword id=\"Heal\">Recovers</> 50% Health and dispels Status Effects.\n" ..
                                "Refills 0% - " .. string.format("%g", (config.RecoveryChargesPercentage or 0.1) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
            PerfectionDescription = nil,
            OverchargeDescription = nil,
        },

        -- Powerful
        ["Powerful_Gustave"] = 
        {
            APCost = config.PowerfulAPCost or 5,
            ChargesConsumed = config.PowerfulChargesConsumed or 50,
            ChargesMultiplier = nil,
            Description =       "Applies <keyword id=\"Buff_Powerful\">Powerful</> to 1-3 allies for 3 turns.\n" ..
                                "Consumes " .. (config.PowerfulChargesConsumed or 50) .. " <keyword id=\"Gustave_Charges\">Charges</> to grant additional buffs to Gustave.\n" ..
                                string.format("%g", (config.PowerfulChargesConsumed or 50) * 0.2) .. " Charges: Apply <keyword id=\"Buff_Shell_Left\">Shell</> for 3 turns.\n" ..
                                string.format("%g", (config.PowerfulChargesConsumed or 50) * 0.4) .. " Charges: Apply <keyword id=\"Buff_Rush_Left\">Rush</> for 3 turns.\n" ..
                                string.format("%g", (config.PowerfulChargesConsumed or 50) * 0.6) .. " Charges: Apply <keyword id=\"Buff_Regen_Left\">Regen</> for 3 turns.\n" ..
                                string.format("%g", (config.PowerfulChargesConsumed or 50) * 0.8) .. " Charges: Increase turn duration to 6.\n" ..
                                (config.PowerfulChargesConsumed or 50) .. " Charges: Apply <keyword id=\"StatusEffect_Enraged_Left\">Rage</> for 1 turn.",
            ShortDescription =  "Applies <keyword id=\"Buff_Powerful\">Powerful</> to 1-3 allies for 3 turns.\n" ..
                                string.format("%g", (config.PowerfulChargesConsumed or 50) * 0.2) .. " Charges: Apply <keyword id=\"Buff_Shell_Left\">Shell</> for 3 turns.\n" ..
                                string.format("%g", (config.PowerfulChargesConsumed or 50) * 0.4) .. " Charges: Apply <keyword id=\"Buff_Rush_Left\">Rush</> for 3 turns.\n" ..
                                string.format("%g", (config.PowerfulChargesConsumed or 50) * 0.6) .. " Charges: Apply <keyword id=\"Buff_Regen_Left\">Regen</> for 3 turns.\n" ..
                                string.format("%g", (config.PowerfulChargesConsumed or 50) * 0.8) .. " Charges: Increase turn duration to 6.\n" ..
                                (config.PowerfulChargesConsumed or 50) .. " Charges: Apply <keyword id=\"StatusEffect_Enraged_Left\">Rage</> for 1 turn.",
            PerfectionDescription = nil,
            OverchargeDescription = nil,
        },

        -- Light Holder
        ["OldLightHolder"] = 
        {
            APCost = config.LightHolderAPCost or 5,
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "Deals high single target <keyword id=\"Element_Light\">Light</> damage. 5 hits.\n" ..
                                "Damage increased by " .. string.format("%g", (config.LightHolderDamagePerHealthChunk or 0.01) * 100) .. "% per " .. (config.LightHolderHealthChunkSize or 100) .. " max health.\n" ..
                                "<keyword id=\"CriticalHit\">Critical Hits</> generate " .. (config.LightHolderChargesPerCritical or 2) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>",
            ShortDescription =  "High <keyword id=\"Element_Light\">Light</> damage increased by " .. string.format("%g", (config.LightHolderDamagePerHealthChunk or 0.01) * 100) .. "% per " .. (config.LightHolderHealthChunkSize or 100) .. " max health. 5 hits.\n" ..
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
            Description =       "Deals low <keyword id=\"Element_Light\">Light</> damage to all enemies. 1 hit.\n" ..
                                "Consumes up to " .. (config.RadiantStrikeChargesConsumed or 20) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
            ShortDescription =  "Deals low <keyword id=\"Element_Light\">Light</> damage to all enemies. 1 hit.\n" ..
                                "Consumes up to " .. (config.RadiantStrikeChargesConsumed or 20) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
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
            Description =       "Refills all <keyword id=\"APShard\">AP</> but sets self-Health to 1.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: Increases Rank to <img id=\"Rank_A\"/>\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Refills " .. string.format("%g", (config.OverloadChargesPercentage or 0.5) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
            ShortDescription =  "Refills all <keyword id=\"APShard\">AP</> but sets self-Health to 1.\n",
            PerfectionDescription = "Increases Rank to <img id=\"Rank_A\"/>",
            OverchargeDescription = "Refills " .. string.format("%g", (config.OverloadChargesPercentage or 0.5) * 100) .. "% of total <keyword id=\"Gustave_Charges\">Charges</>",
        },

        -- Steeled Strike
        ["SteeledStrike"] = 
        {
            APCost = config.SteeledStrikeAPCost or 9,
            ChargesConsumed = config.SteeledStrikeChargesConsumed or 50,
            ChargesMultiplier = config.SteeledStrikeDamagePerCharge or 0.2,
            Description =       "After 1 turn, deals extreme single target <keyword id=\"Element_Physical\">Physical</> damage. 13 hits.\n" ..
                                "Interrupted if any damage taken.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_S\"/>: Increased damage.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. (config.SteeledStrikeChargesConsumed or 50) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
            ShortDescription =  "After 1 turn, extreme <keyword id=\"Element_Physical\">Physical</> damage. 13 hits.\n" ..
                                "Interrupted if any damage taken.\n",
            PerfectionDescription = "<img id=\"Rank_S\"/>: Increased damage.",
            OverchargeDescription = "Consumes up to " .. (config.SteeledStrikeChargesConsumed or 50) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
        },

        -- Endbringer
        ["EndBringer"] = 
        {
            APCost = config.EndbringerAPCost or 9,
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "Deals extreme single target <keyword id=\"Element_Physical\">Physical</> damage. 6 hits.\n" ..
                                "Increased damage if the target is <keyword id=\"StatusEffect_Stunned\">Stunned</>\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_A\"/>: Can reapply <keyword id=\"StatusEffect_Stunned\">Stun</>\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: <keyword id=\"StatusEffect_Stunned\">Stun Hits</> generate " .. (config.EndbringerChargesPerStunnedHit or 5) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>",
            ShortDescription =  "Extreme <keyword id=\"Element_Physical\">Physical</> damage. 6 hits.\n" ..
                                "Increased damage if the target is <keyword id=\"StatusEffect_Stunned\">Stunned</>\n",
            PerfectionDescription = "<img id=\"Rank_A\"/>: Can reapply <keyword id=\"StatusEffect_Stunned\">Stun</>",
            OverchargeDescription = "<keyword id=\"StatusEffect_Stunned\">Stun Hits</> generate " .. (config.EndbringerChargesPerStunnedHit or 5) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</>",
        },

        -- Berserk Slash
        ["BerserkSlash"] = 
        {
            APCost = config.BerserkSlashAPCost or 4,
            ChargesConsumed = config.BerserkSlashChargesConsumed or 10,
            ChargesMultiplier = config.BerserkSlashDamagePerCharge or 0.2,
            Description =       "Deals medium single target <keyword id=\"Element_Physical\">Physical</> damage. 3 hits.\n" ..
                                "Damage is increased for each Health this character is missing.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_C\"/>: Increased damage.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. (config.BerserkSlashChargesConsumed or 10) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
            ShortDescription =  "Medium <keyword id=\"Element_Physical\">Physical</> damage. 3 hits.\n" ..
                                "Deals more damage the less Health this character has.\n",
            PerfectionDescription = "<img id=\"Rank_C\"/>: Increased damage.",
            OverchargeDescription = "Consumes up to " .. (config.BerserkSlashChargesConsumed or 10) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
        },

        -- Defiant Strike
        ["DefiantStrike"] = 
        {
            APCost = config.DefiantStrikeAPCost or 3,
            ChargesConsumed = config.DefiantStrikeChargesConsumed or 15,
            ChargesMultiplier = config.DefiantStrikeDamagePerCharge or 0.2,
            Description =       "Deals high single target <keyword id=\"Element_Physical\">Physical</> damage that applies <keyword id=\"StatusEffect_Mark\">Mark</> 2 hits.\n" ..
                                "Costs 30% of current Health.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_B\"/>: Increased damage.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. (config.DefiantStrikeChargesConsumed or 15) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
            ShortDescription =  "High <keyword id=\"Element_Physical\">Physical</> damage. 2 hits. Applies <keyword id=\"StatusEffect_Mark\">Mark</>\n" ..
                                "Costs 30% Health.\n",
            PerfectionDescription = "<img id=\"Rank_B\"/>: Increased damage.",
            OverchargeDescription = "Consumes up to " .. (config.DefiantStrikeChargesConsumed or 15) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
        },

        -- Blitz
        ["Blitz"] = 
        {
            APCost = config.BlitzAPCost or 3,
            ChargesConsumed = config.BlitzChargesConsumed or 5,
            ChargesMultiplier = config.BlitzDamagePerCharge or 0.2,
            Description =       "Deals low single target <keyword id=\"Element_Physical\">Physical</> damage. 1 hit.\n" ..
                                "Plays a second time. Kills non-boss enemies with less than 10% Health.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_B\"/>: Increased damage.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. (config.BlitzChargesConsumed or 5) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
            ShortDescription =  "Low <keyword id=\"Element_Physical\">Physical</> damage. 1 hit.\n" ..
                                "Plays a second time. Kills non-boss enemies with less than 10% Health.\n",
            PerfectionDescription = "<img id=\"Rank_B\"/>: Increased damage.",
            OverchargeDescription = "Consumes up to " .. (config.BlitzChargesConsumed or 5) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
        },

        -- Follow Up
        ["FollowUp"] = 
        {
            APCost = config.FollowUpAPCost or 5,
            ChargesConsumed = config.FollowUpChargesConsumed or 15,
            ChargesMultiplier = config.FollowUpDamagePerCharge or 0.2,
            Description =       "Deals medium single target <keyword id=\"Element_Light\">Light</> damage. 1 hit.\n" ..
                                "Damage increased for each Free Aim shot this turn, up to 10 times.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_S\"/>: Costs 2 <keyword id=\"APShard\">AP</>\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. (config.FollowUpChargesConsumed or 15) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage. Costs " .. (config.FollowUpAPReducedCost or 2) .. " <keyword id=\"APShard\">AP</> if required charges are available.",
            ShortDescription =  "Medium <keyword id=\"Element_Light\">Light</> damage, increased for each Free Aim shot this turn, up to 10 times. 1 hit.\n",
            PerfectionDescription = "<img id=\"Rank_S\"/>: Costs 2 <keyword id=\"APShard\">AP</>",
            OverchargeDescription = "Consumes up to " .. (config.FollowUpChargesConsumed or 15) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage. Costs " .. (config.FollowUpAPReducedCost or 2) .. " <keyword id=\"APShard\">AP</> if required charges are available.",
        },

        -- Ascending Assault
        ["AscendingAssault"] = 
        {
            APCost = config.AscendingAssaultAPCost or 5,
            ChargesConsumed = config.AscendingAssaultChargesConsumed or 20,
            ChargesMultiplier = config.AscendingAssaultDamagePerCharge or 0.2,
            Description =       "Deals low single target damage. 1 hit.\n" ..
                                "Uses weapon's element.\n" ..
                                "Increased damage at each cast.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_S\"/>: Costs 2 <keyword id=\"APShard\">AP</>\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. (config.AscendingAssaultChargesConsumed or 20) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage. Costs " .. (config.AscendingAssaultAPReducedCost or 2) .. " <keyword id=\"APShard\">AP</> if required charges are available.",
            ShortDescription =  "Low {DynamicElement} damage. 1 hit.\n" ..
                                "Increased damage at each cast.\n",
            PerfectionDescription = "<img id=\"Rank_S\"/>: Costs 2 <keyword id=\"APShard\">AP</>",
            OverchargeDescription = "Consumes up to " .. (config.AscendingAssaultChargesConsumed or 20) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage. Costs " .. (config.AscendingAssaultAPReducedCost or 2) .. " <keyword id=\"APShard\">AP</> if required charges are available.",
        },

        -- Speed Burst
        ["SpeedBurst"] = 
        {
            APCost = config.SpeedBurstAPCost or 3,
            ChargesConsumed = config.SpeedBurstChargesConsumed or 25,
            ChargesMultiplier = config.SpeedBurstDamagePerCharge or 0.2,
            Description =       "Deals high single target <keyword id=\"Element_Light\">Light</> damage. 5 hits.\n" ..
                                "Damage increased by Speed difference with the target.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_C\"/>: Increased damage.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. (config.SpeedBurstChargesConsumed or 25) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
            ShortDescription =  "High <keyword id=\"Element_Light\">Light</> damage increased by Speed difference. 5 hits.\n",
            PerfectionDescription = "<img id=\"Rank_C\"/>: Increased damage.",
            OverchargeDescription = "Consumes up to " .. (config.SpeedBurstChargesConsumed or 25) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
        },

        -- Phantom Stars
        ["PhantomStars"] = 
        {
            APCost = config.PhantomStarsAPCost or 9,
            ChargesConsumed = config.PhantomStarsChargesConsumed or 40,
            ChargesMultiplier = config.PhantomStarsDamagePerCharge or 0.2,
            Description =       "Deals extreme <keyword id=\"Element_Light\">Light</> damage to all enemies. 5 hits.\n" .. 
                                "Can <keyword id=\"Break\">Break</>\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_S\"/>: Costs 5 <keyword id=\"APShard\">AP</>\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. (config.PhantomStarsChargesConsumed or 40) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage. Costs " .. (config.PhantomStarsAPReducedCost or 5) .. " <keyword id=\"APShard\">AP</> if required charges are available.\n" ..
                                "If a target is <keyword id=\"Break\">Broken</> by the hit, Phantom Stars refills " .. string.format("%g", (config.PhantomStarsChargesPercentage or 0.1) * 100) .. "% of its total <keyword id=\"Gustave_Charges\">Charges</>",
            ShortDescription =  "Extreme <keyword id=\"Element_Light\">Light</> damage to all enemies. 5 hits.\n" ..
                                "Can <keyword id=\"Break\">Break</>\n",
            PerfectionDescription = "<img id=\"Rank_S\"/>: Costs 2 <keyword id=\"APShard\">AP</>",
            OverchargeDescription = "Consumes up to " .. (config.PhantomStarsChargesConsumed or 40) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage. Costs " .. (config.PhantomStarsAPReducedCost or 5) .. " <keyword id=\"APShard\">AP</> if required charges are available.\n" ..
                                    "If a target is <keyword id=\"Break\">Broken</> by the hit, Phantom Stars refills " .. string.format("%g", (config.PhantomStarsChargesPercentage or 0.1) * 100) .. "% of its total <keyword id=\"Gustave_Charges\">Charges</>",
        },

        -- Paradigm Shift
        ["ParadigmShift"] = 
        {
            APCost = config.ParadigmShiftAPCost or 9,
            ChargesConsumed = config.ParadigmShiftChargesConsumed or 1,
            ChargesMultiplier = nil,
            Description =       "Deals low <keyword id=\"Element_Physical\">Physical</> single target damage and gives 1-3 <keyword id=\"APShard\">AP</> back. 3 hits.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_C\"/>: +1 <keyword id=\"APShard\">AP</>\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes " .. (config.ParadigmShiftChargesConsumed or 1) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> per hit to give +1 <keyword id=\"APShard\">AP</> per charge.",
            ShortDescription =  "Low <keyword id=\"Element_Physical\">Physical</> damage and gives 1-3 <keyword id=\"APShard\">AP</> back. 3 hits.",
            PerfectionDescription = "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_C\"/>: +1 <keyword id=\"APShard\">AP</>\n",
            OverchargeDescription = "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes " .. (config.ParadigmShiftChargesConsumed or 1) .. " <keyword id=\"Gustave_Charges\">Charge(s)</> per hit to give +1 <keyword id=\"APShard\">AP</> per charge.",
        },

        -- Purification
        ["Purification"] = 
        {
            APCost = config.PurificationAPCost or 4,
            ChargesConsumed = config.PurificationChargesConsumed or 10,
            ChargesMultiplier = config.PurificationDamagePerCharge or 0.2,
            Description =       "Deals single target medium <keyword id=\"Element_Light\">Light</> damage. 2 hits.\n" ..
                                "Dispels self status effects.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: <img id=\"Rank_B\"/>: Increased damage.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Consumes up to " .. (config.PurificationChargesConsumed or 10) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
            ShortDescription =  "Medium <keyword id=\"Element_Light\">Light</> damage. 2 hits.\n" ..
                                "Dispels self status effects.\n",
            PerfectionDescription = "<img id=\"Rank_B\"/>: Increased damage.",
            OverchargeDescription = "Consumes up to " .. (config.PurificationChargesConsumed or 10) .. " <keyword id=\"Gustave_Charges\">Charges</> for increased damage.",
        },

        -- Angel's Eyes
        ["AngelsEyes"] = 
        {
            APCost = 3,
            ChargesConsumed = nil,
            ChargesMultiplier = nil,
            Description =       "Deals extreme <keyword id=\"Element_Physical\">Physical</> Damage. 8 hits.\n" ..
                                "Applies Aureole to revive this character on death.\n" ..
                                "<keyword id=\"Element_Light\">Perfection</>: Gain 1 additional <keyword id=\"Perfection\">Perfection</> per hit.\n" ..
                                "<keyword id=\"Element_Lightning\">Overcharge</>: Gain " .. (config.AngelsEyesAdditionalChargesPerHit or 2) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</> per hit.",
            ShortDescription =  "Extreme <keyword id=\"Element_Physical\">Physical</> Damage. 8 hits.\n" ..
                                "Applies Aureole to revive this character on death.\n",
            PerfectionDescription = "Gain 1 additional <keyword id=\"Perfection\">Perfection</> per hit.",
            OverchargeDescription = "Gain " .. (config.AngelsEyesAdditionalChargesPerHit or 2) .. " additional <keyword id=\"Gustave_Charges\">Charge(s)</> per hit.",
        },
    }

    return abilityValues
end

return GetAbilityValues