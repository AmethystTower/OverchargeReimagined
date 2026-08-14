
--[[
------- Overcharge Reimagined v2.0 - By Killera -------

------- NOTE:
        I am part of the Call of Duty modding community - specifically the MW2 client community.
        You probably heard of clients such as AlterIWnet, FourDeltaOne, RepZIW4 or IW4x before.
        I've been part of these communities for over 10 years and haven't modded any other games since then.

        I like Expedition 33 and I played it a lot with the old "Overcharge Unleashed" mod that simply increased the charge count to 100,
        but after it broke with the latest update I decided to put my skills to test and create my own mod for a game and engine that I had no idea about.

        About 2 weeks later and here we are, having made my first UE4ss mod for Expedition 33!
        The reason why I went for this type of mod is because it is less prone to break in future updates, since the other Overcharge mod replaced entire game modules.
        This mod simply hooks the game's runtime functions and adds our own modifications to them, simply being an addition to existing mechanics rather than replacing them.
        
        The only downside compared to the original "Overcharge Unleashed" mod is that the UI still displays up to 10 charges.
        Internally, the mod keeps track of your real charge count, so you'll sometimes have to guess if you're at 30 or 39 charges, for example.
            
        But compared to the other mod, you can customize all the settings however you want using the config.lua file!
         - Want to generate charges passively per battle start and turn? You can do that!
         - Do you want Overcharge to work like Perfection and gain charges on "Free Aim" hits but also lose charges when you get hit? You can do that!
         - Want to punish dodges by removing charges but gain more charges per parry to make it require more skill? You can do that!
         - Want to get bonus charges for any critical hits and not just from Lumiere Assault or Strike Storm? You can do that!
         - Do you want Simoso's "ethereal sword" double hit effect to generate charges? You can do that as well!
         - Want buff effects like "Burn" to generate charges? Also possible!
        You can do all of that and more!

        Feel free to modify this mod as long as credits are given!
         - If you modify the mod and want to share it, you HAVE to open source it since it is under the GPLv3 license.
        If you just want to customize this mod and simply change gameplay values then use the config.lua instead!

        PS: Time for some shameless advertising!
        If you happen to play Call of Duty and like to play the old Modern Warfare 2 game, feel free to follow our project here:
        https://discord.gg/wzD7eCM
        https://www.youtube.com/@mw2reimagined/videos

        Everything in this file was reverse engineered by me using FModel and a lot of trial and error.

        PPS:
        LUA is a disgusting language, I hate it. C++, C# and even assembly are much better.
        The only reason why I went for Lua is because of the simplicity that anyone can just modify it and maybe learn from my work.

        Have fun with the mod! :)
------- NOTE END
]]--

local function Log(msg)
    print("[Overcharge Reimagined] " .. msg .. "\n")
end

Log("Loading...\n")

-- Load our config.
local ok, config = pcall(require, "config")

if not ok then
    -- Create an empty list as fallback.
    config = {}
    Log("Failed to load config.lua, using default values.")
else
    Log("config.lua loaded successfully!")
end

-- This gets our list of ability modifications such as new descriptions and different AP costs.
local functionOK, GetAbilityValues = pcall(require, "skills")

if not functionOK then
    Log("Failed to load skills.lua, using empty list.")
else
    Log("skills.lua loaded successfully!")
end

-- This is our custom charge limit, can be set to any number but it should NOT be negative.
local virtualMaxCharges = config.VirtualMaxCharges or 100

-- Charge generation values.
-- NOTE: All those settings can be negative as well, so our character loses charges instead when those events occur.
-- If no config exists, then all values are set to what the base game does for charge generation.

local startingCharges = config.StartingCharges or 0 -- Amount of charges received when a battle begins.
local chargesPerTurn = config.ChargesPerTurn or 0 -- Amount of charges received when our character plays his turn.

local chargesOnDodge = config.ChargesOnDodge or 1 -- Charges per dodge.
local chargesOnParry = config.ChargesOnParry or 1 -- Charges per parry.
local chargesOnBaseAttacks = config.ChargesOnBaseAttacks or 1 -- Charges per base attack hit.
local chargesOnCounterAttacks = config.ChargesOnCounterAttacks or 1 -- Charges per counter attack.
local chargesOnJumpCounter = config.ChargesOnJumpCounter or 1 -- Charges per jump counter.
local chargesOnGradientCounter = config.ChargesOnGradientCounter or 1 -- Charges per gradient counter.
local chargesFromSkillDamage = config.ChargesFromSkillDamage or 1 -- Charges per ability hit.
local chargesOnLuminaDamage = config.ChargesOnLuminaDamage or 0 -- Charges per lumina hit (Simoso ethereal light sword effect uses this).
local chargesOnFreeAim = config.ChargesOnFreeAim or 0 -- Charges per free aim hit.
local chargesOnBuffDamage = config.ChargesOnBuffDamage or 0 -- Charges per buff hit (e.g. burn damage).
local chargesOnReceivedHit = config.ChargesOnReceivedHit or 0 -- Charges when receiving a hit from an enemy.

-- Independent from Lumiere Assault's and Strike Storm's bonus charges on critical hits.
-- This does NOT affect free aim shots by default.
local chargesOnCritical = config.ChargesOnCritical or 0

-- This allows bonus charges generated from criticals to trigger when shooting at enemies using free aim.
local freeAimAffectedByCriticals = config.FreeAimAffectedByCriticals

-- Check if the config value is null, set to false by default.
if freeAimAffectedByCriticals == nil then
    freeAimAffectedByCriticals = false
end

-- Ability settings that we need in this module of the mod.
local shatterChargesPercentage = config.ShatterChargesPercentage or 0.15
local overchargeChargesPercentage = config.OverchargeChargesPercentage or 0.25
local overloadChargesPercentage = config.OverloadChargesPercentage or 0.5
local overchargeMaxChargesBonus = config.OverchargeMaxChargesBonus or 0.05
local shatterMaxChargesBonus = config.ShatterMaxChargesBonus or 0.15
local lightHolderDamagePerHealthChunk = config.LightHolderDamagePerHealthChunk or 0.01
local lightHolderHealthChunkSize = config.LightHolderHealthChunkSize or 100
local lightHolderChargesPerCritical = config.LightHolderChargesPerCritical or 2
local lumiereAssaultChargesPerCritical = config.LumiereAssaultChargesPerCritical or 1
local strikeStormChargesPerCritical = config.StrikeStormChargesPerCritical or 2
local fromFireChargesPerCritical = config.FromFireChargesPerCritical or 2
local fromFireHealPerCharge = config.FromFireHealPerCharge or 0.01
local recoveryChargesPercentage = config.RecoveryChargesPercentage or 0.1
local endbringerChargesPerStunnedHit = config.EndbringerChargesPerStunnedHit or 5
local followUpAPReducedCost = config.FollowUpAPReducedCost or 2
local followUpChargesConsumed = config.FollowUpChargesConsumed or 15
local ascendingAssaultAPReducedCost = config.AscendingAssaultAPReducedCost or 2
local ascendingAssaultChargesConsumed = config.AscendingAssaultChargesConsumed or 20
local phantomStarsAPReducedCost = config.PhantomStarsAPReducedCost or 5
local phantomStarsChargesConsumed = config.PhantomStarsChargesConsumed or 40
local phantomStarsChargesPercentage = config.PhantomStarsChargesPercentage or 0.1
local paradigmShiftAPPerCharge = config.ParadigmShiftAPPerCharge or 1
local angelsEyesAdditionalChargesPerHit = config.AngelsEyesAdditionalChargesPerHit or 3

-- These values SHOULD NOT BE MODIFIED.
local virtualCurrentCharges = 0 -- Our own charge counter.
local MAX_INGAME_CHARGES = 10 -- I suppose one could modifiy this to 100 for compatibility with Overcharge Unleashed?

-- This makes sure the in-game charges are always within the number of MAX_INGAME_CHARGES independent to how many actual charges we can have.
local CHARGE_MULTIPLIER

-- Check if virtual max charges has been set to 0 or even negative numbers, then create our multiplier accordingly.
if virtualMaxCharges > 0 then
    -- This multiplier is used to make sure no whatter how many max charges we have set, the game will always use 10 charges.
    CHARGE_MULTIPLIER = 100 / (virtualMaxCharges * MAX_INGAME_CHARGES)
else
    CHARGE_MULTIPLIER = 0

    -- Incase someone set the number to negatives, set it to 0.
    -- Now we can't generate any charges anymore... hope you're happy! :D
    virtualMaxCharges = 0
end

-- These booleans that tell us if a hook is now in place or not.
local clientHookRegistered = false
local abilityHooksRegistered = false
local unleashHookRegistered = false
local shatterHookRegistered = false
local lightHolderHookRegistered = false
local radiantStrikeHookRegistered = false
local markingShotHookRegistered = false
local lumiereAssaultHookRegistered = false
local strikeStormHookRegistered = false
local fromFireHookRegistered = false
local recoveryHookRegistered = false
local powerfulHookRegistered = false
local overloadHookRegistered = false
local steeledStrikeHookRegistered = false
local endbringerHookRegistered = false
local berserkSlashHookRegistered = false
local defiantStrikeHookRegistered = false
local blitzHookRegistered = false
local followUpHookRegistered = false
local ascendingAssaultHookRegistered = false
local speedBurstHookRegistered = false
local phantomStarsHookRegistered = false
local paradigmShiftHookRegistered = false
local purificationHookRegistered = false
local angelsEyesHookRegistered = false
local berserkHookRegistered = false

-- Booleans that we need to monitor states.
local updatingNativeCharge = false
local restoreMaxCharges = false
local firstTurn = false
local overchargeCharacterTurn = false
local fullChargeBonus = false
local steeledStrikeExecuted = false

-- Booleans that we use to monitor when a specific skill was used or triggers.
local usedShatter = false
local usedOvercharge = false
local usedLightHolder = false
local usedRadiantStrike = false
local usedMarkingShot = false
local usedLumiereAssault = false
local usedStrikeStorm = false
local usedFromFire = false
local usedPowerful = false
local usedSteeledStrike = false
local usedEndbringer = false
local usedBerserkSlash = false
local usedDefiantStrike = false
local usedBlitz = false
local usedFollowUp = false
local usedAscendingAssault = false
local usedSpeedBurst = false
local usedPhantomStars = false
local usedPurification = false
local usedAngelsEyes = false

-- This tells if we have consumed some charges this turn with any ability that isn't Overcharge.
local consumedChargesFromAbility = 0

-- Here we will store the active charge component from our character during the battle so we can modify it from any of our hooks.
local chargeComponent = nil

-- Our general hook paths that allow us to modify the game.
local CLIENT_RESTART = "/Script/Engine.PlayerController:ClientRestart"
local RECEIVE_BEGIN_PLAY = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:ReceiveBeginPlay"
local ON_TURN_START = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:OnTurnStart"
local ON_TURN_END = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:OnTurnEnd"
local CHANGE_CHARGE = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:ChangeCharge"
local DODGE_SUCCESSFUL = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:OnDodgeSuccessful_Event"
local PARRY_SUCCESSFUL = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:OnParrySuccessful_Event"
local ON_RECEIVED_DAMAGE = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:OnCharacterReceivedDamage"
local ON_BREAK_STUN = "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_CharacterBattleStats.AC_jRPG_CharacterBattleStats_C:PerformBreakStun"

-- These are all ability hooks that we use so that they can have additional effects as well as consume and generate charges.
local UNLEASH_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_UnleashCharge.BP_Battle_SkillScript_Gustave_UnleashCharge_C:OnExecuteSkill"
local SHATTER_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_PerfectBreak.BP_Battle_SkillScript_Gustave_PerfectBreak_C:OnExecuteSkill"
local LIGHT_HOLDER_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_LightHolder.BP_Battle_SkillScript_LightHolder_C:OnExecuteSkill"
local RADIANT_STRIKE_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_RadiantStrike.BP_Battle_SkillScript_Verso_RadiantStrike_C:OnExecuteSkill"
local OVERLOAD_ON_EFFECT = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_Overcharge.BP_Battle_SkillScript_Verso_Overcharge_C:OnActionEffect"
local MARKING_SHOT_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_MarkingShot.BP_Battle_SkillScript_Gustave_MarkingShot_C:OnExecuteSkill"
local LUMIERE_ASSAULT_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_Combo1.BP_Battle_SkillScript_Gustave_Combo1_C:OnExecuteSkill"
local STRIKE_STORM_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_StrikeStorm.BP_Battle_SkillScript_Gustave_StrikeStorm_C:OnExecuteSkill"
local FROM_FIRE_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_FromFire.BP_Battle_SkillScript_Gustave_FromFire_C:OnExecuteSkill"
local RECOVERY_ON_EFFECT = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_PerfectRecovery.BP_Battle_SkillScript_Gustave_PerfectRecovery_C:OnActionEffect"
local POWERFUL_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_Powerful.BP_Battle_SkillScript_Gustave_Powerful_C:OnExecuteSkill"
local POWERFUL_ON_EFFECT = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_Powerful.BP_Battle_SkillScript_Gustave_Powerful_C:OnActionEffect"
local STEELED_STRIKE_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_SteeledStrike.BP_Battle_SkillScript_Verso_SteeledStrike_C:OnExecuteSkill"
local ENDBRINGER_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_EndBringer.BP_Battle_SkillScript_Verso_EndBringer_C:OnExecuteSkill"
local BERSERK_SLASH_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_BerserkSlash.BP_Battle_SkillScript_Verso_BerserkSlash_C:OnExecuteSkill"
local DEFIANT_STRIKE_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_DefiantStrike.BP_Battle_SkillScript_Verso_DefiantStrike_C:OnExecuteSkill"
local BLITZ_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Blitz.BP_Battle_SkillScript_Blitz_C:OnExecuteSkill"
local FOLLOW_UP_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_Followup.BP_Battle_SkillScript_Verso_Followup_C:OnExecuteSkill"
local FOLLOW_UP_COST_OVERRIDE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_Followup.BP_Battle_SkillScript_Verso_Followup_C:GetSkillCostOverride"
local ASCENDING_ASSAULT_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_AscendingAssault.BP_Battle_SkillScript_Verso_AscendingAssault_C:OnExecuteSkill"
local ASCENDING_ASSAULT_COST_OVERRIDE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_AscendingAssault.BP_Battle_SkillScript_Verso_AscendingAssault_C:GetSkillCostOverride"
local SPEED_BURST_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_SpeedBurst.BP_Battle_SkillScript_Verso_SpeedBurst_C:OnExecuteSkill"
local PHANTOM_STARS_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_PhantomStars.BP_Battle_SkillScript_Verso_PhantomStars_C:OnExecuteSkill"
local PHANTOM_STARS_COST_OVERRIDE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_PhantomStars.BP_Battle_SkillScript_Verso_PhantomStars_C:GetSkillCostOverride"
local PARADIGM_SHIFT_ON_EFFECT = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_ParadigmShift.BP_Battle_SkillScript_Verso_ParadigmShift_C:OnActionEffect"
local PURIFICATION_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_NEW_15.BP_Battle_SkillScript_NEW_15_C:OnExecuteSkill"
local ANGELS_EYES_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_AngelsEyes.BP_Battle_SkillScript_Verso_AngelsEyes_C:OnExecuteSkill"

-- Our modifier hooks that allow us to manipulate the cost and damage multiplier of abilities on the fly.
local GET_BASE_COST = "/Game/Gameplay/SkillTree/BP_DataAsset_Skill.BP_DataAsset_Skill_C:GetSkillBaseCost"
local GET_COST = "/Game/Gameplay/SkillTree/BP_DataAsset_Skill.BP_DataAsset_Skill_C:GetSkillCost"
local GET_ATTACK_MULTIPLIER = "/Game/Gameplay/Battle/BP_BattleDamageBuilder.BP_BattleDamageBuilder_C:GetAttackPowerMultiplier"
local BERSERK_TURN_START = "/Game/Gameplay/Buffs/GenericBuff/BP_BattleBuff_Berserk.BP_BattleBuff_Berserk_C:OnCharacterTurnStart"

-- This function lets us unwrap UE4 objects as proper values.
local function unwrap(param)
	if not param then
		return nil
	end

	local ok, val = pcall(function()
		return param:get()
	end)

	if ok and val ~= nil then
		return val
	end

	return nil
end

-- This function lets us unwrap UE4 objects as proper integers.
local function read_int(param)
	if not param then
		return nil
	end

	local ok, val = pcall(function()
		return param:get()
	end)

	if ok and val ~= nil then
		return tonumber(val)
	end

	return nil
end

-- This function helps us find out if our current charge component is still valid.
local function IsValidChargeComponent()
    return chargeComponent and chargeComponent:IsValid()
end

-- This function gets all the custom settings such as APCost, ChargeConsumption and descriptions from the skills.lua file.
local function GetAbilityOverrideValues(abilityNameID)
    local abilityOverrides = GetAbilityValues(config)

    if not abilityOverrides then
        Log("Failed to call GetAbilityValues()")
        return nil
    end

    local newValues = abilityOverrides[abilityNameID]

    if not newValues then
        Log("No values found for: " .. tostring(abilityNameID))
        return nil
    end

    return newValues
end

-- This function modifies the AP cost and description of abilities.
local function ModifyAbilityCostAndDescription(param)
    local self = unwrap(param) or param

    if not self or not self:IsValid() then
        return
    end

    -- Check if the skill type is 1 and if it isn't, do nothing.
    -- 2 are gradient abilities and 3 are items, we ignore those.
    -- UNLESS it is Angel's eyes, we want to modify the ability's description and add charges on criticals but not make its cost customizable.
    if self.SkillType ~= 1 and self.NameID:ToString() ~= "AngelsEyes" then
        return
    end

    --Log("Skill: " .. tostring(self:GetFullName()))
    --Log("NameID: " .. tostring(self.NameID:ToString()))
    --Log("Name: " .. tostring(self.name:ToString()))
    --Log("Type: " .. tostring(self.SkillType))
    --Log("Description: " .. tostring(self.Description:ToString()))
    --Log("Short Description: " .. tostring(self.ShortDescription:ToString()))
    --Log("APCost: " .. tostring(self.APCost))
    --Log("Element Type: " .. tostring(self.BaseElementalType))

    local abilityNameID = self.NameID:ToString()

    local abilityValues = GetAbilityOverrideValues(abilityNameID)

    if not abilityValues then
        return
    end

    -- For whatever reason modifiying the ShortDescription property corrupts the value of this property, giving it a random integer value from a different memory location.
    -- I assume this is a bug in UE4SS and it assumes a wrong size for the property.
    -- After countless testing and debugging it seems this is the only property that gets corrupted, everything else remains the same.
    -- Since this isn't a big project and I don't get money for this I won't spend countless of hours trying to figure out what the exact issue is.
    -- If anyone reports problems that are related to this, only then I'll get back to it.
    local targetingType = self.TargetingType

    self.APCost = abilityValues.APCost

    -- Set the skill's long description which is shown in the character menu and at the top left window during target selection in battle.
    if self.Description ~= abilityValues.Description then
        self.Description = FText(abilityValues.Description)
    end

    -- Build the string for the short description dynamically.
    local assembledShortDescription = abilityValues.ShortDescription

    -- We currently have the Overcharge character's turn and are selecting his abilities, show Overcharge effect strings if they exist.
    if overchargeCharacterTurn and abilityValues.OverchargeDescription then
        assembledShortDescription = assembledShortDescription .. abilityValues.OverchargeDescription
    -- We have a different character's turn, show Perfection effect strings, if they exist.
    elseif abilityValues.PerfectionDescription then
        assembledShortDescription = assembledShortDescription .. abilityValues.PerfectionDescription
    end

    -- Show the current charge count for any abilities that consume charges and specifically Overcharge and Shatter since they consume all charges.
    -- Of course we make sure that the count only gets shown if it's the turn of the Overcharge character.
    if (abilityValues.ChargesConsumed or abilityNameID == "UnleashCharge" or abilityNameID == "PerfectBreak_Gustave") and overchargeCharacterTurn then
        assembledShortDescription = assembledShortDescription .. ("\nCharges: " .. virtualCurrentCharges .. " of " .. virtualMaxCharges .. " <keyword id=\"Gustave_Charges\">Charges</> available.")
    end

    -- Set the skill's short description to what we just assembled on the fly.
    self.ShortDescription = FText(assembledShortDescription)
    
    -- Set the value of TargetingType to what it originally was.
    self.TargetingType = targetingType

    Log("Modified ability: " .. tostring(self.NameID:ToString()))
end

local function IncreaseDamageMultiplierBasedOnCharges(multiplier, abilityName, consumedCharges)
    local abilityValues = GetAbilityOverrideValues(abilityName)

    if not abilityValues then
        return multiplier
    end

    local bonusMultiplier = abilityValues.ChargesMultiplier

    Log("FinalDamageMultiplier before: " .. tostring(multiplier))

    -- Formula: Every charge adds +ChargesMultiplier to the multiplier.
    local addedModifier = consumedCharges * bonusMultiplier

    multiplier = multiplier + addedModifier

    Log("Added +" .. addedModifier .. " to the damage multiplier based on " .. consumedCharges .. " charges and " .. bonusMultiplier .. " per charge.")
    Log("FinalDamageMultiplier after: " .. tostring(multiplier))

    return multiplier
end

local function CalculateAmountOfConsumedCharges(abilityName, abilityNameLog)
    if not IsValidChargeComponent() then
        return
    end

    local abilityValues = GetAbilityOverrideValues(abilityName)

    if not abilityValues then
        return
    end

    local consumedCharges = abilityValues.ChargesConsumed

    -- Calculate how many charges we have available for consumption from the counter.
    -- math.min() returns whatever value here is smaller, so if our counter is less than what the ability can consume, we return that instead.
    local availableCharges = math.min(virtualCurrentCharges, consumedCharges)
    consumedChargesFromAbility = availableCharges

    -- Do not consume the charges here when we are using Overcharge, since we need it for the game's native damage calculation as we only want to add to it.
    -- The game natively consumes the charges using our custom values once Overcharge is finished.
    if not usedOvercharge then
        chargeComponent.ChangeCharge(consumedChargesFromAbility * (-1))
    end

    Log(abilityNameLog .. ": Consuming " .. consumedChargesFromAbility .. " charges for increased damage.")
end

local function ResetAbilityStates()
    -- Reset all ability states.
    -- EXCEPT Steeled Strike, that ability gets set to false if our character gets hit or when his turn starts.
    usedShatter = false
    usedOvercharge = false
    usedLightHolder = false
    usedRadiantStrike = false
    usedMarkingShot = false
    usedLumiereAssault = false
    usedStrikeStorm = false
    usedFromFire = false
    usedPowerful = false
    usedEndbringer = false
    usedBerserkSlash = false
    usedDefiantStrike = false
    usedBlitz = false
    usedFollowUp = false
    usedAscendingAssault = false
    usedSpeedBurst = false
    usedPhantomStars = false
    usedPurification = false
    usedAngelsEyes = false
    fullChargeBonus = false

    -- Only reset it at the end of our turn if we actually executed the ability.
    if steeledStrikeExecuted then
        steeledStrikeExecuted = false
        usedSteeledStrike = false
    end

    -- Set this back to 0.
    consumedChargesFromAbility = 0
end

-- The following hooks we need to be careful because they don't get registed if we don't have the needed character participating in the first battle.
-- They are responsible for monitoring when someone executes those abilities.
-- We will call this function in our RECEIVE_BEGIN_PLAY hook everytime a battle starts to ensure they are registered when needed.
local function TryRegisterAbilityHooks()
    -- If we have no valid charge component then we have no character with Overcharge participating in this battle.
    if not IsValidChargeComponent() then
        Log("No valid charge component, can't register ability hooks.")
        return
    end

    -- Try to register Overcharge's hooks.
    if not unleashHookRegistered then
        local ok = pcall(function()
            -- This hook runs at the start of Overcharge's execution.
            RegisterHook(UNLEASH_ON_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Overcharge used: Setting max charges and current charges to internal counters: " .. virtualCurrentCharges .. " out of " .. virtualMaxCharges .. ".")

                -- Set the component's max charge and current charge count to our custom values.
                -- This will force the game's damage calculator to use our custom values, while not affecting the UI and breaking things like animations or FX effects.
                -- The game will naturally remove the charges from our internal counter automatically due to calling ChangeCharge() with the value we force here.
                chargeComponent.MaxChargeCount = virtualMaxCharges
                chargeComponent.ChargeCount = virtualCurrentCharges

                -- Allows us to track when using Overcharge, so that its hit from skill damage doesn't count.
                usedOvercharge = true

                -- This tells our ChangeCharge() hook to reset the max amount back to 10 when it's called.
                restoreMaxCharges = true

                -- We will still call our functions here so that we can add custom bonus damage to the ability if desired.
                fullChargeBonus = virtualCurrentCharges == virtualMaxCharges

                CalculateAmountOfConsumedCharges("UnleashCharge", "Overcharge")

                -- Set the counter back to 0 without notifying the UI.
                virtualCurrentCharges = 0
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            unleashHookRegistered = true
            Log("Successfully registered Overcharge ability execution hooks.")
        end
    end

    -- Try to register Shatter's hooks.
    if not shatterHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses the ability Shatter.
            RegisterHook(SHATTER_ON_EXECUTE, function(param)
                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Shatter used this turn.")
                -- Allows us to track when using Overcharge, so that its hit from skill damage doesn't count.
                usedShatter = true

                fullChargeBonus = virtualCurrentCharges == virtualMaxCharges

                CalculateAmountOfConsumedCharges("PerfectBreak_Gustave", "Shatter")
            end)
        end)

        -- If it was successful, mark hooks registrations as true.
        if ok then
            shatterHookRegistered = true
            Log("Successfully registered Shatter ability execution hooks.")
        end
    end

    -- Try to register Marking Shot's hooks.
    if not markingShotHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Marking Shot.
            RegisterHook(MARKING_SHOT_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Marking Shot used this turn.")
                usedMarkingShot = true

                CalculateAmountOfConsumedCharges("MarkingShot_Gustave", "Marking Shot")
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            markingShotHookRegistered = true
            Log("Successfully registered Marking Shot ability execution hooks.")
        end
    end

    -- Try to register Lumiere Assault's hooks.
    if not lumiereAssaultHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Lumiere Assault.
            RegisterHook(LUMIERE_ASSAULT_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Lumiere Assault used this turn.")
                usedLumiereAssault = true
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            lumiereAssaultHookRegistered = true
            Log("Successfully registered Lumiere Assault ability execution hooks.")
        end
    end

    -- Try to register Strike Storm's hooks.
    if not strikeStormHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Strike Storm.
            RegisterHook(STRIKE_STORM_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Strike Storm used this turn.")
                usedStrikeStorm = true
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            strikeStormHookRegistered = true
            Log("Successfully registered Strike Storm ability execution hooks.")
        end
    end

    -- Try to register From Fire's hooks.
    if not fromFireHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses From Fire.
            RegisterHook(FROM_FIRE_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("From Fire used this turn.")
                usedFromFire = true

                CalculateAmountOfConsumedCharges("FromFire_Gustave", "From Fire")
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            fromFireHookRegistered = true
            Log("Successfully registered From Fire ability execution hooks.")
        end
    end

    -- Try to register Recovery's hooks.
    if not recoveryHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Recovery.
            RegisterHook(RECOVERY_ON_EFFECT, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                local result = unwrap(param)

                if not result then
                    return
                end

                -- Remove the vanilla charge amount generated by the base game depending on the skillchecks the player hit.
                -- But only do this if we have less than max charges, since the game's native code doesn't add charges when the counter is already full.
                if virtualCurrentCharges ~= virtualMaxCharges then
                    chargeComponent.ChangeCharge(result.ChargeGain * (-1))
                end

                -- Calculate the charges that Recovery generates.
                local addedCharges = math.floor((virtualMaxCharges * recoveryChargesPercentage))

                -- Multiply our added charges with the charge gain from the game's result object.
                -- This way we can utilize the skillcheck and add more percentages.
                -- Formula: Charges x 0.5 x ChargeGain.
                -- If ChargeGain is 2 we get 100% charges, if it's 1 we get 50% and if it's 0 we get 0% charges.
                addedCharges = math.floor(addedCharges * 0.5 * result.ChargeGain)

                chargeComponent.ChangeCharge(addedCharges)
                Log("Recovery: Adding " .. addedCharges .. " charges to the counter.")
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            recoveryHookRegistered = true
            Log("Successfully registered Recovery ability execution hooks.")
        end
    end

    -- Try to register Powerful's hooks.
    if not powerfulHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Powerful.
            RegisterHook(POWERFUL_ON_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                -- This lets us know we need to ignore the next instance added charges because they are added by the game's native code, which runs before our code does.
                -- They did this in a hacky way so I couldn't access the direct value like in Recovery, so have to make this hacky myself.
                -- I wish I would have used C++ but then this is harder for people to modify.
                -- IMPORTANT: ONLY do this if the charges are NOT full because the game's native code does not call ChangeCharge if the charges are already full.
                -- Otherwise it would ignore our own call to ChangeCharge and not remove the charges properly.
                if virtualCurrentCharges ~= virtualMaxCharges then
                    usedPowerful = true
                end
            end)

            -- This hook runs when Powerful's effects trigger.
            RegisterHook(POWERFUL_ON_EFFECT, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                local skillScript = unwrap(param)

                if not skillScript then
                    return
                end

                -- The character class we need for ApplyBuff().
                local statsClass = StaticFindObject("/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_CharacterBattleStats.AC_jRPG_CharacterBattleStats_C")

                -- Get the character who's casting Powerful.
                local castingChar = {}
                skillScript:GetCurrentCharacter(castingChar)

                if not castingChar or not castingChar.CurrentCharacter then
                    return
                end

                -- Retrieve the character's class component.
                local castingCharacterClass = castingChar.CurrentCharacter:GetComponentByClass(statsClass)

                if not castingCharacterClass then
                    return
                end

                -- Get the ability's properties so we can check how many charges it can consume.
                local abilityValues = GetAbilityOverrideValues("Powerful_Gustave")

                if not abilityValues then
                    return
                end

                -- Apply bonus buffs to our character depending on the charges he consumed for this.
                -- If this ability can't consume charges because it was configured to be 0 then don't give any bonus effects or duration.
                if abilityValues.ChargesConsumed > 0 then
                    local applyShell = false
                    local applyRush = false
                    local applyBerserk = false
                    local applyEnraged = false
                    local turnDuration = 3

                    -- Calculate amount of consumed charges.
                    CalculateAmountOfConsumedCharges("Powerful_Gustave", "Powerful")

                    -- For every 20% of the total charge consumption we grant a bonus.
                    -- Example: If the ability can consume up to 15 charges, we grant a bonus every 3 charges.
                    local consumedChargesChunk = math.floor(abilityValues.ChargesConsumed * 0.2)

                    -- We consumed 1/5 of the required charges, grant Shell as a bonus.
                    if consumedChargesFromAbility >= consumedChargesChunk then
                        applyShell = true
                        Log("Powerful: Granting Shell.")
                    end

                    -- We consumed 2/5 of the required charges, grant Rush as a bonus.
                    if consumedChargesFromAbility >= consumedChargesChunk * 2 then
                        applyRush = true
                        Log("Powerful: Granting Rush.")
                    end

                    -- We consumed 3/5 of the required charges, grant Berserk as a bonus.
                    if consumedChargesFromAbility >= consumedChargesChunk * 3 then
                        applyBerserk = true
                        Log("Powerful: Granting Berserk.")
                    end

                    -- We consumed 4/5 of the required charges, increase turn duration by +2.
                    if consumedChargesFromAbility >= consumedChargesChunk * 4 then
                        turnDuration = turnDuration + 3
                        Log("Powerful: Increasing duration by +3.")
                    end

                    -- We consumed ALL required charges, grant Enraged as a bonus.
                    if consumedChargesFromAbility >= consumedChargesChunk * 5 then
                        applyEnraged = true
                        Log("Powerful: Granting Enraged.")
                    end

                    -- Refund any possible charges that were not enough to increase the duration.
                    if consumedChargesFromAbility > 0 then
                        local refundAmount = math.floor(consumedChargesFromAbility % consumedChargesChunk)
                        chargeComponent.ChangeCharge(refundAmount)
                        Log("Powerful: Refunding " .. refundAmount .. " leftover charges that were not enough for next buff stage.")
                    end

                    -- Apply any bonus buffs to our character if we get any.
                    -- We don't need the applied buff object but the function requires it as an output parameter.
                    local appliedBuff = {}

                    -- Reapply powerful with the potentially new turn duration.
                    -- But do not treat him as casting character, since he'd reapply lumina effects regarding powerful twice.
                    local powerfulBuffClass = StaticFindObject("/Game/Gameplay/Buffs/StatsBuffs/BP_BattleBuff_Powerful_125.BP_BattleBuff_Powerful_125_C")
                    skillScript:ApplyBuff(powerfulBuffClass, castingCharacterClass, turnDuration, nil, 4, appliedBuff)

                    if applyShell then
                        local shellBuffClass = StaticFindObject("/Game/Gameplay/Buffs/StatsBuffs/BP_BattleBuff_Defense15.BP_BattleBuff_Defense15_C")
                        -- ApplyBuff: Buff class, target character, duration, casting character, 4 = forced application (guaranteed), returned buff object.
                        skillScript:ApplyBuff(shellBuffClass, castingCharacterClass, turnDuration, castingCharacterClass, 4, appliedBuff)
                    end

                    if applyRush then
                        local rushBuffClass = StaticFindObject("/Game/Gameplay/Buffs/ParentClasses/BP_BattleBuff_Speed.BP_BattleBuff_Speed_C")
                        skillScript:ApplyBuff(rushBuffClass, castingCharacterClass, turnDuration, castingCharacterClass, 4, appliedBuff)
                    end

                    if applyBerserk then
                        local berserkBuffClass = StaticFindObject("/Game/Gameplay/Buffs/GenericBuff/BP_BattleBuff_Berserk.BP_BattleBuff_Berserk_C")
                        skillScript:ApplyBuff(berserkBuffClass, castingCharacterClass, turnDuration, castingCharacterClass, 4, appliedBuff)
                        appliedBuff.CreatedBuffInstance.IsPermanent = false -- Berserk is hardcoded to be permanent, set this to false.
                    end

                    -- Enraged is always limited to 1 turn by the base game unfortunately :D
                    if applyEnraged then
                        local enragedBuffClass = StaticFindObject("/Game/Gameplay/Buffs/GenericBuff/BP_BattleBuff_Enraged.BP_BattleBuff_Enraged_C")
                        skillScript:ApplyBuff(enragedBuffClass, castingCharacterClass, 1, castingCharacterClass, 4, appliedBuff)
                    end
                end
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            powerfulHookRegistered = true
            Log("Successfully registered Powerful ability execution hooks.")
        end
    end

    -- Try to register Light Holder's hooks.
    if not lightHolderHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses the unused ability Light Holder.
            RegisterHook(LIGHT_HOLDER_EXECUTE, function(param)
                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Unused Light Holder used this turn.")
                usedLightHolder = true
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            lightHolderHookRegistered = true
            Log("Successfully registered Light Holder ability execution hooks.")
        end
    end

    -- Try to register Radiant Strike's hooks.
    if not radiantStrikeHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses the unused ability Radiant Strike.
            RegisterHook(RADIANT_STRIKE_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Unused Radiant Strike used this turn.")
                usedRadiantStrike = true

                CalculateAmountOfConsumedCharges("RadiantStrike", "Radiant Strike")
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            radiantStrikeHookRegistered = true
            Log("Successfully registered Radiant Strike ability execution hooks.")
        end
    end

    -- Try to register Overload's hooks.
    if not overloadHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Overload.
            RegisterHook(OVERLOAD_ON_EFFECT, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Overload used this turn.")

                -- Overload executes this function twice during its animation, so let's cut the percentage multiplier by half to get our value :)
                local halvedMultiplier = (overloadChargesPercentage * 0.5)

                local addedCharges = math.floor((virtualMaxCharges * halvedMultiplier))

                chargeComponent.ChangeCharge(addedCharges)
                Log("Overload: Adding " .. addedCharges .. " charges to the counter.")
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            overloadHookRegistered = true
            Log("Successfully registered Overload ability execution hooks.")
        end
    end

    -- Try to register Steeled Strike's hooks.
    if not steeledStrikeHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Steeled Strike.
            RegisterHook(STEELED_STRIKE_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                -- Steeled Strike is very special since it takes a turn before the attack happens.
                -- We need to put the logic into our character's turn start in our ON_TURN_START hook.
                Log("Steeled Strike used this turn.")
                usedSteeledStrike = true
            end)
        end)

        -- If it was successful, mark th hooks registrations as true.
        if ok then
            steeledStrikeHookRegistered = true
            Log("Successfully registered Steeled Strike ability execution hooks.")
        end
    end

    -- Try to register Endbringer's hooks.
    if not endbringerHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Endbringer.
            RegisterHook(ENDBRINGER_ON_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Endbringer used this turn.")
                usedEndbringer = true
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            endbringerHookRegistered = true
            Log("Successfully registered Endbringer ability execution hooks.")
        end
    end

    -- Try to register Berserk Slash's hooks.
    if not berserkSlashHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Berserk Slash.
            RegisterHook(BERSERK_SLASH_ON_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Berserk Slash used this turn.")
                usedBerserkSlash = true

                CalculateAmountOfConsumedCharges("BerserkSlash", "Berserk Slash")
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            berserkSlashHookRegistered = true
            Log("Successfully registered Berserk Slash ability execution hooks.")
        end
    end

    -- Try to register Defiant Strike's hooks.
    if not defiantStrikeHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Defiant Strike.
            RegisterHook(DEFIANT_STRIKE_ON_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Defiant Strike used this turn.")
                usedDefiantStrike = true

                CalculateAmountOfConsumedCharges("DefiantStrike", "Defiant Strike")
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            defiantStrikeHookRegistered = true
            Log("Successfully registered Defiant Strike ability execution hooks.")
        end
    end

    -- Try to register Blitz's hooks.
    if not blitzHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Blitz.
            RegisterHook(BLITZ_ON_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Blitz used this turn.")
                usedBlitz = true

                CalculateAmountOfConsumedCharges("Blitz", "Blitz")
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            blitzHookRegistered = true
            Log("Successfully registered Blitz ability execution hooks.")
        end
    end

    -- Try to register Follow Up's hooks.
    if not followUpHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Follow Up.
            RegisterHook(FOLLOW_UP_ON_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Follow Up used this turn.")
                usedFollowUp = true

                CalculateAmountOfConsumedCharges("FollowUp", "Follow Up")
            end)

            -- This hook runs whenever Follow Up checks its requirement for reduced AP cost.
            RegisterHook(FOLLOW_UP_COST_OVERRIDE, function(param, override, newValue)
                if not IsValidChargeComponent() then
                    return
                end

                -- It's a different character's turn so do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                -- Check if we have the required charge consumption amount for Follow Up.
                -- If yes, override its usual AP cost to the new value.
                if virtualCurrentCharges >= followUpChargesConsumed then
                    local skillScript = unwrap(param)

                    if skillScript and skillScript.SkillState then
                        skillScript.SkillState:SetOvercharge(true, true)
                    end

                    override:set(true)
                    newValue:set(followUpAPReducedCost)
                end
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            followUpHookRegistered = true
            Log("Successfully registered Follow Up ability execution hooks.")
        end
    end

    -- Try to register Ascending Assault's hooks.
    if not ascendingAssaultHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Ascending Assault.
            RegisterHook(ASCENDING_ASSAULT_ON_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Ascending Assault used this turn.")
                usedAscendingAssault = true

                CalculateAmountOfConsumedCharges("AscendingAssault", "Ascending Assault")
            end)

            -- This hook runs whenever Ascending Assault checks its requirement for reduced AP cost.
            RegisterHook(ASCENDING_ASSAULT_COST_OVERRIDE, function(param, override, newValue)
                if not IsValidChargeComponent() then
                    return
                end

                -- It's a different character's turn so do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                -- Check if we have the required charge consumption amount for Ascending Assault.
                -- If yes, override its usual AP cost to the new value.
                if virtualCurrentCharges >= ascendingAssaultChargesConsumed then
                    local skillScript = unwrap(param)

                    if skillScript and skillScript.SkillState then
                        skillScript.SkillState:SetOvercharge(true, true)
                    end

                    override:set(true)
                    newValue:set(ascendingAssaultAPReducedCost)
                end
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            ascendingAssaultHookRegistered = true
            Log("Successfully registered Ascending Assault ability execution hooks.")
        end
    end

    -- Try to register Speed Burst's hooks.
    if not speedBurstHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Speed Burst.
            RegisterHook(SPEED_BURST_ON_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Speed Burst used this turn.")
                usedSpeedBurst = true

                CalculateAmountOfConsumedCharges("SpeedBurst", "Speed Burst")
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            speedBurstHookRegistered = true
            Log("Successfully registered Speed Burst ability execution hooks.")
        end
    end

    -- Try to register Phantom Stars' hooks.
    if not phantomStarsHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Phantom Stars.
            RegisterHook(PHANTOM_STARS_ON_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Phantom Stars used this turn.")
                usedPhantomStars = true

                CalculateAmountOfConsumedCharges("PhantomStars", "Phantom Stars")
            end)

            -- This hook runs whenever Phantom Stars checks its requirement for reduced AP cost.
            RegisterHook(PHANTOM_STARS_COST_OVERRIDE, function(param, override, newValue)
                if not IsValidChargeComponent() then
                    return
                end

                -- It's a different character's turn so do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                -- Check if we have the required charge consumption amount for Phantom Stars.
                -- If yes, override its usual AP cost to the new value.
                if virtualCurrentCharges >= phantomStarsChargesConsumed then
                    local skillScript = unwrap(param)

                    if skillScript and skillScript.SkillState then
                        skillScript.SkillState:SetOvercharge(true, true)
                    end

                    override:set(true)
                    newValue:set(phantomStarsAPReducedCost)
                end
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            phantomStarsHookRegistered = true
            Log("Successfully registered Phantom Stars ability execution hooks.")
        end
    end

    -- Try to register Paradigm Shift's hooks.
    if not paradigmShiftHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Paradigm Shift.
            RegisterHook(PARADIGM_SHIFT_ON_EFFECT, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Paradigm Shift used this turn.")

                local skillScript = unwrap(param)

                if not skillScript then
                    return
                end

                -- Get the character who's casting Paradigm Shift.
                local castingChar = {}
                skillScript:GetCurrentCharacter(castingChar)

                if not castingChar or not castingChar.CurrentCharacter then
                    return
                end

                local statsClass = StaticFindObject("/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_CharacterBattleStats.AC_jRPG_CharacterBattleStats_C")

                -- Retrieve the character's class component.
                local castingCharacterClass = castingChar.CurrentCharacter:GetComponentByClass(statsClass)

                if not castingCharacterClass then
                    return
                end

                -- Calculate consumed charges.
                CalculateAmountOfConsumedCharges("ParadigmShift", "Paradigm Shift")

                -- Give us an AP value equal to the consumed charge amount with reason 1: AP restored through skill.
                castingCharacterClass:GainAP(consumedChargesFromAbility, 1)
                Log("Restored " .. paradigmShiftAPPerCharge .. " extra AP from consumed charges.")
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            paradigmShiftHookRegistered = true
            Log("Successfully registered Paradigm Shift ability execution hooks.")
        end
    end

    -- Try to register Purification's hooks.
    if not purificationHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Purification.
            RegisterHook(PURIFICATION_ON_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Purification used this turn.")
                usedPurification = true

                CalculateAmountOfConsumedCharges("Purification", "Purification")
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            purificationHookRegistered = true
            Log("Successfully registered Purification ability execution hooks.")
        end
    end

    -- Try to register Angel's Eyes' hooks.
    if not angelsEyesHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever someone uses Angel's Eyes.
            RegisterHook(ANGELS_EYES_ON_EXECUTE, function(param)
                if not IsValidChargeComponent() then
                    return
                end

                -- A different character used this ability, do nothing.
                if not overchargeCharacterTurn then
                    return
                end

                Log("Angel's Eyes used this turn.")
                usedAngelsEyes = true
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            angelsEyesHookRegistered = true
            Log("Successfully registered Angel's Eyes ability execution hooks.")
        end
    end

    -- Try to register the turn start function hook for the buff of Berserk.
    if not berserkHookRegistered then
        local ok = pcall(function()
            -- This hook runs whenever a character starts a turn and there is a character that has "Berserk".
            -- We have to be careful here so we don't affect the characters that DO NOT have the "Berserk" buff.
            -- I DID NOT KNOW THAT BERSERK SLOWLY MAKES AFFECTED CHARACTERS GROW, I fought the chromatic lampmaster for an hour in the randomizer in spring meadows and suddenly noticed that Gustave was LARGE.
            -- This should fix it while not taking away this feature from enemies BUT you can turn off this fix with a config setting if you like to meme around... :)
            RegisterHook(BERSERK_TURN_START, function(param, characterStats, turnStartDependencies)
                if not IsValidChargeComponent() then
                    return
                end

                local berserk = unwrap(param)
                local stats = unwrap(characterStats)

                if not berserk or not stats then
                    return
                end

                -- Not a big fan of using GetOuter but that is the easiest solution right now.
                local berserkParent = berserk:GetOuter()

                -- Get the owner of the berserk buff.
                local berserkCharacter = berserkParent:GetOwner()

                -- Get the current character who's playing the current turn.
                local currentCharacter = stats:GetOwner()

                -- Do nothing if any of these objects are invalid.
                -- And compare the berserk character to the current character playing the turn, making sure the character without berserk doesn't get affected.
                if not berserkCharacter:IsValid() or not currentCharacter:IsValid() or berserkCharacter:GetFullName() ~= currentCharacter:GetFullName() then
                    Log("BERSERK_TURN_START: Preventing non-berserk character from being affected.")
                    return
                end

                -- Reset the berserk character's size back to normal if it is the owner of the charge component.
                -- We do not want to affect normal enemies with this and have them keep their size scaling.
                if chargeComponent:IsCharacterOwner(berserkCharacter) then
                    berserkCharacter:ChangeSize(1, 0.05, nil)
                    Log("BERSERK_TURN_START: Set berserk character's size back to normal.")
                end
            end)
        end)

        -- If it was successful, mark the hooks registrations as true.
        if ok then
            berserkHookRegistered = true
            Log("Successfully registered Berserk turn start function hook.")
        end
    end
end

-- This hook runs when loading a save.
RegisterHook(CLIENT_RESTART, function()
    if clientHookRegistered then
        return 
    end

    clientHookRegistered = true

    RegisterHook(GET_ATTACK_MULTIPLIER, function(param)
        if not IsValidChargeComponent() then
            return
        end

        local modifier = unwrap(param)

        -- Return if the modifier somehow doesn't exist or the damage isn't caused by a skill.
        if not modifier or modifier.DamageReason ~= 1 then
            return
        end

        local owner = modifier.DamageSource:GetOwner()

        -- The damaging character somehow doesn't exist or is not the one with Overcharge, do nothing.
        if not owner or not chargeComponent:IsCharacterOwner(owner) then
            return
        end

        -- We used Overcharge, this will let us further increase its damage per charge if so desired.
        if usedOvercharge then
            modifier.FinalDamageMultiplier = IncreaseDamageMultiplierBasedOnCharges(modifier.FinalDamageMultiplier, "UnleashCharge", consumedChargesFromAbility)

            -- Overcharge is full, further increase Overcharge's bonus damage!
            if fullChargeBonus then
                modifier.FinalDamageMultiplier = modifier.FinalDamageMultiplier + overchargeMaxChargesBonus
                Log("Full charge bonus: Increasing Overcharge's damage by another +" .. overchargeMaxChargesBonus .. " to a total of " .. modifier.FinalDamageMultiplier .. ".")
            end

        -- We used Shatter, it consumes ALL charges for increased damage!
        -- This is basically another version of Overcharge now, except it's slightly weaker but hits all enemies instead.
        elseif usedShatter then
            modifier.FinalDamageMultiplier = IncreaseDamageMultiplierBasedOnCharges(modifier.FinalDamageMultiplier, "PerfectBreak_Gustave", consumedChargesFromAbility)

            -- Overcharge is full, further increase Shatter's bonus damage!
            if fullChargeBonus then
                modifier.FinalDamageMultiplier = modifier.FinalDamageMultiplier + shatterMaxChargesBonus
                Log("Full charge bonus: Increasing Shatter's damage by another +" .. shatterMaxChargesBonus .. " to a total of " .. modifier.FinalDamageMultiplier .. ".")
            end

        -- We used Marking Shot.
        elseif usedMarkingShot then
            modifier.FinalDamageMultiplier = IncreaseDamageMultiplierBasedOnCharges(modifier.FinalDamageMultiplier, "MarkingShot_Gustave", consumedChargesFromAbility)

        -- We used From Fire.
        elseif usedFromFire then
            modifier.FinalDamageMultiplier = IncreaseDamageMultiplierBasedOnCharges(modifier.FinalDamageMultiplier, "FromFire_Gustave", consumedChargesFromAbility)
            
            -- Heal our character based on the amount of charges we consumed.
            local result = {}

            -- Get the max health.
            modifier.DamageSource:GetMaxHP(result)

            -- Formula: Max health x heal per charge x amount of charges.
            local healAmount = (result.MaxHP * fromFireHealPerCharge) * consumedChargesFromAbility

            -- Heal based on amount of charges and max health.
            -- Params: Heal amount, character that healed us (ourselves in this case), play heal effect, self heal, debug string.
            -- This will damage us if we're inverted but since From Fire does this in the vanilla game we'll leave it like this.
            if healAmount > 0 then
                modifier.DamageSource.RecoverHP(healAmount, modifier.DamageSource, true, 1, "none")
            end

        -- We used the unused version of Radiant Strike.
        elseif usedRadiantStrike then
            modifier.FinalDamageMultiplier = IncreaseDamageMultiplierBasedOnCharges(modifier.FinalDamageMultiplier, "RadiantStrike", consumedChargesFromAbility)

        -- We used the unused version of Light Holder which says it scales with health, get the max HP!
        -- I decided to not go for current health since that is a bit lame really, makes low-health builds not good with it then.
        -- This ability does not consume charges, it generates bonus charges on criticals instead.
        elseif usedLightHolder then
            local result = {}

            modifier.DamageSource:GetMaxHP(result)

            -- Formula: Every x amount of max. health adds +x to the multiplier.
            local addedModifier = (result.MaxHP / lightHolderHealthChunkSize) * lightHolderDamagePerHealthChunk

            modifier.FinalDamageMultiplier = modifier.FinalDamageMultiplier + addedModifier
            Log("Added +" .. addedModifier .. " to the damage multiplier based on " .. result.MaxHP .. " health for Light Holder.")

        -- We used Steeled strike.
        elseif usedSteeledStrike then
            modifier.FinalDamageMultiplier = IncreaseDamageMultiplierBasedOnCharges(modifier.FinalDamageMultiplier, "SteeledStrike", consumedChargesFromAbility)

        -- We used Berserk Slash
        elseif usedBerserkSlash then
            modifier.FinalDamageMultiplier = IncreaseDamageMultiplierBasedOnCharges(modifier.FinalDamageMultiplier, "BerserkSlash", consumedChargesFromAbility)

        -- We used Defiant Strike
        elseif usedDefiantStrike then
            modifier.FinalDamageMultiplier = IncreaseDamageMultiplierBasedOnCharges(modifier.FinalDamageMultiplier, "DefiantStrike", consumedChargesFromAbility)

        -- We used Blitz
        elseif usedBlitz then
            modifier.FinalDamageMultiplier = IncreaseDamageMultiplierBasedOnCharges(modifier.FinalDamageMultiplier, "Blitz", consumedChargesFromAbility)

        -- We used Follow Up
        elseif usedFollowUp then
            modifier.FinalDamageMultiplier = IncreaseDamageMultiplierBasedOnCharges(modifier.FinalDamageMultiplier, "FollowUp", consumedChargesFromAbility)

        -- We used Ascending Assault
        elseif usedAscendingAssault then
            modifier.FinalDamageMultiplier = IncreaseDamageMultiplierBasedOnCharges(modifier.FinalDamageMultiplier, "AscendingAssault", consumedChargesFromAbility)

        -- We used Speed Burst
        elseif usedSpeedBurst then
            modifier.FinalDamageMultiplier = IncreaseDamageMultiplierBasedOnCharges(modifier.FinalDamageMultiplier, "SpeedBurst", consumedChargesFromAbility)

        -- We used Phantom Stars
        elseif usedPhantomStars then
            modifier.FinalDamageMultiplier = IncreaseDamageMultiplierBasedOnCharges(modifier.FinalDamageMultiplier, "PhantomStars", consumedChargesFromAbility)

        -- We used Purification
        elseif usedPurification then
            modifier.FinalDamageMultiplier = IncreaseDamageMultiplierBasedOnCharges(modifier.FinalDamageMultiplier, "Purification", consumedChargesFromAbility)
        end
    end)

    -- Modify Radiant Strike and Light Holder so that they show their correct descriptions in the skilltree immediately.
    -- For some reason the game doesn't call GET_BASE_COST for those 2 abilities specifically which is noticable due to them showing incorrect AP costs until they're equipped.
    local skill_assets = FindAllOf("BP_DataAsset_Skill_C")

    -- Find Radiant Strike and Light Holder and fix their descriptions immediately.
    for _, asset in pairs(skill_assets) do
        if asset.NameID:ToString() == "RadiantStrike" or asset.NameID:ToString() == "OldLightHolder" then
            ModifyAbilityCostAndDescription(asset)
        end
    end

    -- This hook modifies the AP cost and description of abilities.
    RegisterHook(GET_BASE_COST, ModifyAbilityCostAndDescription)

    -- This hook runs when we're in battle and open the ability menu.
    -- We will use this function to decide if an ability should be highlighted in orange because we have the optimal charge counts for them.
    RegisterHook(GET_COST, function(param, RemoteSkillState)
        if not IsValidChargeComponent() then
            return
        end

        -- It's a different character's turn, do nothing.
        if not overchargeCharacterTurn then
            return
        end

        local self = unwrap(param)

        if not self then
            return
        end

        local skillState = unwrap(RemoteSkillState)

        if not skillState then
            return
        end

        -- Check if the skill type is 1 and if it isn't, do nothing.
        -- 2 are gradient abilities and 3 are items, we ignore those.
        if self.SkillType ~= 1 then
            return
        end

        local abilityNameID = self.NameID:ToString()

        local abilityValues = GetAbilityOverrideValues(abilityNameID)

        if not abilityValues then
            return
        end

        -- Check if we are at max charges and the abilities are Overcharge or Shatter and highlight them.
        if virtualCurrentCharges == virtualMaxCharges and (abilityNameID == "UnleashCharge" or abilityNameID == "PerfectBreak_Gustave") then
            skillState:SetOvercharge(true, true)
            return
        end

        -- Check if we have all charges available that this ability could consume and hightlight it.
        if abilityValues.ChargesConsumed and virtualCurrentCharges >= abilityValues.ChargesConsumed then
            skillState:SetOvercharge(true, true)
            return
        end

        -- Check if we have 0 charges and this ability can generate bonus charges, highlight them.
        -- Except it's Endbringer, that ability only generates charges on stunned enemies.
        -- The game will automatically highlight it in orange for us when an enemy is stunned.
        if not abilityValues.ChargesConsumed and virtualCurrentCharges == 0 and abilityNameID ~= "EndBringer" then
            skillState:SetOvercharge(true, true)
        end
    end)

    -- This hook runs on our character when the battle begins.
    -- And it turns out this hook runs when he was eaten by an enemy and freed during battle as well.
    RegisterHook(RECEIVE_BEGIN_PLAY, function(param)
        local self = unwrap(param)

        -- Check if the charge component exists, if yes then cache it.
        if self:IsValid() then
            virtualCurrentCharges = 0
            consumedChargesFromAbility = 0
            firstTurn = true
            overchargeCharacterTurn = false

            Log("Internal Charge Counter: " .. tostring(virtualCurrentCharges))

            -- Cache the charge component during the fight for easy access in our other hooks.
            chargeComponent = self

            -- Try registering the ability hooks for Overcharge and Shatter.
            -- These hooks will fail if we don't have the needed character equipped for this battle.
            -- Which means we will have to try and register these hooks every battle.
            -- Also this needs to run AFTER saving our chargeComponent otherwise this will silently fail.
            TryRegisterAbilityHooks()

            -- Reset all ability states incase some are left from our last fight.
            ResetAbilityStates()

            -- Also reset steeled strike incase it's true from our last fight.
            usedSteeledStrike = false

            -- Add a 2 second delay before applying the starting charges.
            -- Otherwise we'd get an error and no charges due to calling this too early when the character is not fully initialized yet.
            ExecuteWithDelay(2000, function()
                -- This is another safety check to see if self still exists, since we are exceuting delayed code here.
                if self:IsValid() then
                    Log("Adding " .. tostring(startingCharges) .. " starting charges.")
                    self.ChangeCharge(startingCharges)
                end
            end)
        end
    end)
    
    -- This hook runs whenever our character gets his turn.
    RegisterHook(ON_TURN_START, function(param)
        -- This is a safety incase we somehow ever lose the current charge component, get it when a new turn starts.
        -- Although this should NEVER happen.
        if not IsValidChargeComponent() then
            local self = unwrap(param)

            if self:IsValid() then
                chargeComponent = self
            else
                return
            end

            Log("Charge component disappeared: Saved new valid charge component.")
        end

        -- Mark this as our turn.
        overchargeCharacterTurn = true

        -- We had used STEELED STRIKE last turn and didn't get hit, consume charges for increased damage now.
        if usedSteeledStrike then
            steeledStrikeExecuted = true
            CalculateAmountOfConsumedCharges("SteeledStrike", "Steeled Strike")
        end

        -- Check if this is our first turn, if yes then don't add the charges per turn yet.
        if IsValidChargeComponent() and not firstTurn then
            Log("Adding " .. tostring(chargesPerTurn) .. " charges per turn.")
            chargeComponent.ChangeCharge(chargesPerTurn)
        else
            firstTurn = false
        end
    end)

    -- This hook runs whenever the turn of our character ends.
    RegisterHook(ON_TURN_END, function(param)
        -- This is a safety incase we somehow ever lose the current charge component, get it when a new turn starts.
        -- Although this should NEVER happen.
        if not IsValidChargeComponent() then
            local self = unwrap(param)

            if self:IsValid() then
                chargeComponent = self
            else
                return
            end

            Log("Charge component disappeared: Saved new valid charge component.")
        end

        -- It is no longer our turn.
        overchargeCharacterTurn = false

        -- Reset all ability states.
        ResetAbilityStates()
    end)

    -- This hook runs whenever someone dodges.
    RegisterHook(DODGE_SUCCESSFUL, function(param, character, enemy)
        -- We have kept the default value of +1 charge per successful dodge, do nothing.
        if chargesOnDodge == 1 then
            return
        end

        if not IsValidChargeComponent() then
            return
        end

        local dodgingCharacter = unwrap(character)

        -- The character that is dodging is not the one with Overcharge, skip.
        if not chargeComponent:IsCharacterOwner(dodgingCharacter) then
            return
        end

        -- We have changed the value of the charges per dodge, add or remove them!
        -- We do -1 because the game already adds 1 charge by default.
        local calculatedCharges = chargesOnDodge - 1

        chargeComponent.ChangeCharge(calculatedCharges)
    end)

    -- This hook runs whenever someone parries.
    RegisterHook(PARRY_SUCCESSFUL, function(param, character, enemy)
        -- We have kept the default value of +1 charge per successful parry, do nothing.
        if chargesOnParry == 1 then
            return
        end

        if not IsValidChargeComponent() then
            return
        end

        local parryingCharacter = unwrap(character)

        -- The character that is parrying is not the one with Overcharge, skip.
        if not chargeComponent:IsCharacterOwner(parryingCharacter) then
            return
        end

        -- We have changed the value of the charges per dodge, add or remove them!
        -- We do -1 because the game already adds 1 charge by default.
        local calculatedCharges = chargesOnParry - 1

        chargeComponent.ChangeCharge(calculatedCharges)
    end)

    -- This hook runs whenever someone gets broken/stunned.
    RegisterHook(ON_BREAK_STUN, function(selfParam, sourceParam, reasonParam)
        if not IsValidChargeComponent() then
            return
        end

        --local selfObject = unwrap(selfParam)
        local sourceCharacter = unwrap(sourceParam)

        -- Make sure the source character exists.
        if not sourceCharacter then
            return
        end

        -- This is the reason for the break.
        local reason = unwrap(reasonParam)

        -- Get our actual breaking character from the parameter.
        local owner = sourceCharacter:GetOwner()

        -- IMPORTANT: Wrap this IsCharacterOwner() call into a pcall because sometimes the charge component can become a trivial object and make the call IsCharacterOwner() invalid.
        -- This can happen during the frame where we break and free our character after he was eaten by an enemy, which could cause the game to crash if not guarded properly.
        local success, isOwner = pcall(function()
            return chargeComponent:IsCharacterOwner(owner)
        end)

        if not success then
            Log("ON_BREAK_STUN: IsCharacterOwner failed: " .. tostring(isOwner))
            return
        end

        -- Reason 1: Broken by an ability.
        if isOwner and reason == 1 then
            -- Broken by Shatter.
            if usedShatter then
                -- We remove -10 from the calculated amount because Shatter is hardcoded to give 10 charges on a break.
                Log("Player caused break using the ability Shatter, instantly refilling charges by " .. (shatterChargesPercentage * 100) .. "% of " .. virtualMaxCharges .. " total charges.")
                chargeComponent.ChangeCharge(math.floor(virtualMaxCharges * shatterChargesPercentage) - 10)
            -- Broken by Overcharge.
            elseif usedOvercharge then
                Log("Player caused break using the ability Overcharge, instantly refilling charges by " .. (overchargeChargesPercentage * 100) .. "% of " .. virtualMaxCharges .. " total charges.")
                chargeComponent.ChangeCharge(math.floor(virtualMaxCharges * overchargeChargesPercentage))
            -- Broken by Phantom Stars.
            elseif usedPhantomStars then
                Log("Player caused break using the ability Phantom Stars, instantly refilling charges by " .. (phantomStarsChargesPercentage * 100) .. "% of " .. virtualMaxCharges .. " total charges.")
                chargeComponent.ChangeCharge(math.floor(virtualMaxCharges * phantomStarsChargesPercentage))
            end
        end
    end)

    -- This hook runs whenever someone takes damage.
    RegisterHook(ON_RECEIVED_DAMAGE, function(param, damageParam)
        if not IsValidChargeComponent() then
            return
        end

        local damageObject = unwrap(damageParam)

        local statsComponentSource = damageObject.SourceCharacter
        local statsComponentTarget = damageObject.TargetCharacter

        local sourceOwner = statsComponentSource.GetOwner()
        local targetOwner = statsComponentTarget.GetOwner()

        local isSourceOwner = sourceOwner:IsValid() and chargeComponent:IsCharacterOwner(sourceOwner)
        local isTargetOwner = targetOwner:IsValid() and chargeComponent:IsCharacterOwner(targetOwner)

        -- We damaged ourselves, do nothing.
        if isSourceOwner and isTargetOwner then
            return
        end

        -- Get the damage reason.
        damageReason = damageObject.DamageReason

        -- We dealt damage to an enemy!
        if isSourceOwner then
            -- Critical hits: Add or remove charges based on critical hits, if enabled.
            -- This is independent from Lumiere Assault and Strike Storm.
            if damageObject.IsCriticalHit and chargesOnCritical ~= 0 then
                -- Check if the player enabled bonus charges from critical hits to affect free aim shots as well.
                if damageReason ~= 3 or freeAimAffectedByCriticals then
                    chargeComponent.ChangeCharge(chargesOnCritical)
                    Log("Critical Damage: +" .. chargesOnCritical .. " charges added.")
                end
            end

            -- Damage Reason 1: Skill damage.
            -- Add or remove charges for damaging enemies with abilities if it is NOT from Overcharge or Shatter, if enabled.
            if damageReason == 1 then
                chargeComponent.ChangeCharge(chargesFromSkillDamage - 1)
                Log("Skill Damage: +" .. chargesFromSkillDamage .. " charges added.")

                -- Monitor abilities that generate bonus charges on critical hits as their exclusive feature.
                if damageObject.IsCriticalHit then
                    -- Light Holder.
                    if usedLightHolder then
                        chargeComponent.ChangeCharge(lightHolderChargesPerCritical)
                        Log("Light Holder Critical Damage: +" .. lightHolderChargesPerCritical .. " charges added.")

                    -- From Fire.
                    elseif usedFromFire then
                        chargeComponent.ChangeCharge(fromFireChargesPerCritical)
                        Log("From Fire Critical Damage: +" .. fromFireChargesPerCritical .. " charges added.")

                    -- Lumiere Assault.
                    -- Remove 1 from our value since the base game adds 1 per critical hit naturally already.
                    elseif usedLumiereAssault then
                        chargeComponent.ChangeCharge(lumiereAssaultChargesPerCritical - 1)
                        Log("Lumiere Assault Critical Damage: +" .. lumiereAssaultChargesPerCritical .. " charges added.")

                    -- Strike Storm.
                    -- Remove 2 from our value since the base game adds 2 per critical hit naturally already.
                    elseif usedStrikeStorm then
                        chargeComponent.ChangeCharge(strikeStormChargesPerCritical - 2)
                        Log("Strike Storm Critical Damage: +" .. strikeStormChargesPerCritical .. " charges added.")
                    end
                end

                -- Monitor Endbringer's hits when the target is stunned for bonus charges.
                if usedEndbringer and damageObject.TargetCharacter.IsStun then
                    chargeComponent.ChangeCharge(endbringerChargesPerStunnedHit)
                    Log("Endbringer Stun Damage: +" .. endbringerChargesPerStunnedHit .. " charges added.")

                -- The base game still adds charges from Overcharge's and Shatter's hit, so remove these hits.
                elseif usedShatter or usedOvercharge then
                    chargeComponent.ChangeCharge((-1))

                -- Add additional charges per hit from Angel's Eyes.
                elseif usedAngelsEyes then
                    chargeComponent.ChangeCharge(angelsEyesAdditionalChargesPerHit)
                    Log("Angel's Eyes: +" .. angelsEyesAdditionalChargesPerHit .. " charges added.")
                end

            -- Damage Reason 2: Buffs such as burn.
            -- Add or remove charges for damaging enemies through buffs, if enabled.
            elseif damageReason == 2 and chargesOnBuffDamage ~= 0 then
                chargeComponent.ChangeCharge(chargesOnBuffDamage)
                Log("Buff Damage: +" .. chargesOnBuffDamage .. " charges added.")

            -- Damage reason 3: Free aim shots.
            -- Add/remove charges for shooting enemies, if enabled.
            elseif damageReason == 3 and chargesOnFreeAim ~= 0 then
                chargeComponent.ChangeCharge(chargesOnFreeAim)
                Log("Free Aim Damage: +" .. chargesOnFreeAim .. " charges added.")

            -- Damage Reason 4: Basic attacks.
            -- Add/remove charges for basic attacking enemies, if enabled.
            elseif damageReason == 4 then
                chargeComponent.ChangeCharge(chargesOnBaseAttacks - 1)
                Log("Base Attack Damage: +" .. chargesOnBaseAttacks .. " charges added.")

            -- Damage Reason 5 and 9: Normal counter attacks.
            -- Add or remove charges for doing a normal or ranged counter attack, if enabled.
            elseif damageReason == 5 or damageReason == 9 then
                chargeComponent.ChangeCharge(chargesOnCounterAttacks - 1)
                Log("Counter Attack Damage: +" .. chargesOnCounterAttacks .. " charges added.")

            -- Damage reason 6: Lumina which is used by the Simoso "ethereal" sword ability for double light damage.
            -- Add/remove charges for this effect, if enabled.
            elseif damageReason == 6 and chargesOnLuminaDamage ~= 0 then
                chargeComponent.ChangeCharge(chargesOnLuminaDamage)
                Log("Lumina Damage: +" .. chargesOnLuminaDamage .. " charges added.")

            -- Damage Reason 8: Gradient counter attack.
            -- Add or remove charges for doing a gradient counter attack, if enabled.
            elseif damageReason == 8 then
                chargeComponent.ChangeCharge(chargesOnGradientCounter - 1)
                Log("Gradient Counter Damage: +" .. chargesOnGradientCounter .. " charges added.")

            -- Damage Reason 11: Jump counter attack.
            -- Add or remove charges for doing a jump counter attack, if enabled.
            elseif damageReason == 11 then
                chargeComponent.ChangeCharge(chargesOnJumpCounter - 1)
                Log("Jump Counter Damage: +" .. chargesOnJumpCounter .. " charges added.")
            end
        end

        -- We took damage from an enemy!
        if isTargetOwner then
            -- Adds or removes charges when receiving a hit, if enabled.
            -- Damage reason anything other than 2: Add or remove charges for anything that isn't buff damage (e.g. burn).
            if damageReason ~= 2 and chargesOnReceivedHit ~=0 then
                chargeComponent.ChangeCharge(chargesOnReceivedHit)
                Log("Damage Taken: +" .. chargesOnReceivedHit .. " charges added.")
            end

            -- Incase Steeled Strike is enabled, disable it now since we got hit and it was cancelled.
            if usedSteeledStrike then
                usedSteeledStrike = false
            end
        end
    end)

    -- This hook runs whenever charges get added/removed.
    RegisterHook(CHANGE_CHARGE, function(param, amount)
        -- Since we call ChangeCharge() in our hook, this prevents an infinite recursive call.
        if updatingNativeCharge then
            return
        end

        if not IsValidChargeComponent() then
            return
        end

        -- We already have the maximum amount of charges, so do nothing otherwise the player keeps hearing the "max charges" noise.
        -- Unless the added charge amount is negative, then in this case do NOT skip this instance.
        if(virtualCurrentCharges == virtualMaxCharges) and (read_int(amount) >= 0) then
            return
        end

        -- Reset the max charges of the component to the original game value after OnExecuteSkill was executed.
        -- Since ChangeCarge() gets called basically everytime this is the perfect place to reset the max count cleanly.
        if restoreMaxCharges then
            chargeComponent.MaxChargeCount = MAX_INGAME_CHARGES
            restoreMaxCharges = false
        end

        -- Don't generate charges from the vanilla functionality of Powerful, since our version has been reworked to not do this anymore.
        if usedPowerful then
            usedPowerful = false
            return
        end

        -- The amount of charges that get added to our counter.
        -- Also includes the bonus charges from Lumiere Assault, Strike Storm and Shatter.
        Log("Added charges: "..tostring(read_int(amount)))

        -- Add the charges.
        virtualCurrentCharges = virtualCurrentCharges + read_int(amount)

        -- Make sure we don't go over our max limit.
        -- Also make sure our virtual charges never go below 0 as well.
        if(virtualCurrentCharges > virtualMaxCharges) then
            virtualCurrentCharges = virtualMaxCharges
        elseif(virtualCurrentCharges < 0) then
            virtualCurrentCharges = 0
        end

        Log("Internal Charge Counter: " .. tostring(virtualCurrentCharges))

        updatingNativeCharge = true
        
        -- Force game's internal charge counter back to 0 so that we can base it off the amount from our custom counter.
        chargeComponent.SetChargeCountInternal(0)

        -- Calculate the amount of in-game charges based off our internal counter multiplied by x.
        -- Ideally this will result in an increase in steps of 10.
        local charges = math.floor(virtualCurrentCharges * CHARGE_MULTIPLIER)

        -- This is a safety measure for the in-game counter just incase it somehow goes below 0 or above 10 charges.
        if(charges < 0) then
            charges = 0
        elseif(charges > MAX_INGAME_CHARGES) then
            charges = MAX_INGAME_CHARGES
        end

        -- Add the amount of in-game charges we calculated.
        -- This forces the current amount of charges to be used by the game for: gameplay, UI, animation selection and fx effect played on the arm.
        chargeComponent.ChangeCharge(charges)
        updatingNativeCharge = false
    end)
end)
