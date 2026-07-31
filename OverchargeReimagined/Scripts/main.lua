
--[[
------- Overcharge Reimagined v1.1 - By Killera -------

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

local ok, config = pcall(require, "config")

if not ok then
    -- Create an empty list as fallback.
    config = {}
    Log("Failed to load config.lua, using default values.")
else
    Log("config.lua loaded successfully!")
end

-- This is our custom charge limit, can be set to any number but it should NOT be negative.
local virtualMaxCharges = config.VirtualMaxCharges or 100

----------------------- CHARGE GENERATION DEFAULT SETTINGS START -----------------------
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

----------------------- CHARGE GENERATION DEFAULT SETTINGS END -----------------------

-- These values SHOULD NOT BE MODIFIED.
local virtualCurrentCharges = 0
local MAX_INGAME_CHARGES = 10

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

-- Booleans that we need to monitor states.
local battleHookRegistered = false
local abilityHooksRegistered = false
local updatingNativeCharge = false
local restoreMaxCharges = false
local usedShatter = false
local usedOvercharge = false
local enemyDodgedOvercharge = false
local firstTurn = false

-- Our hook paths that allow us to modify the game.
local CLIENT_RESTART = "/Script/Engine.PlayerController:ClientRestart"
local RECEIVE_BEGIN_PLAY = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:ReceiveBeginPlay"
local ON_TURN_START = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:OnTurnStart"
local CHANGE_CHARGE = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:ChangeCharge"
local UNLEASH_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_UnleashCharge.BP_Battle_SkillScript_Gustave_UnleashCharge_C:OnExecuteSkill"
local UNLEASH_ON_EFFECT = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_UnleashCharge.BP_Battle_SkillScript_Gustave_UnleashCharge_C:OnActionEffect"
local DODGE_SUCCESSFUL = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:OnDodgeSuccessful_Event"
local PARRY_SUCCESSFUL = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:OnParrySuccessful_Event"
local ON_RECEIVED_DAMAGE = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:OnCharacterReceivedDamage"
local SHATTER_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_PerfectBreak.BP_Battle_SkillScript_Gustave_PerfectBreak_C:OnExecuteSkill"
local ON_BREAK_STUN = "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_CharacterBattleStats.AC_jRPG_CharacterBattleStats_C:PerformBreakStun"

-- This hook path is inconsistent and our other hooks don't need it to register properly, can be removed.
-- It seems like a rare issue since only I had it so far and very suddenly too, other mods using this hook also did not work for me properly.
--local BATTLE_DEPENDENCIES_LOADED = "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:OnBattleDependenciesFullyLoaded"

-- Here we will store the active charge component from our character during the battle so we can modify it from any of our hooks.
local chargeComponent = nil

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

-- The following hooks we need to be careful because they don't get registed if we don't have the needed character participating in the first battle.
-- They are responsible for monitoring when someone executes those abilities.
-- We will call this function in our RECEIVE_BEGIN_PLAY hook everytime a battle starts to ensure they are registered when needed.
local function TryRegisterAbilityHooks()
    if abilityHooksRegistered then
        return
    end

    -- If we have no valid charge component then we have no character with Overcharge participating in this battle.
    if not IsValidChargeComponent() then
        return
    end

    local ok = pcall(function()

        -- This hook runs at the start of Overcharge's execution.
        RegisterHook(UNLEASH_ON_EXECUTE, function(param)
            if not IsValidChargeComponent() then
                return
            end

            Log("Overcharge used: Setting max charges and current charges to internal counters: " .. virtualCurrentCharges .. " out of " .. virtualMaxCharges .. ".")

            -- Set the component's max charge and current charge count to our custom values.
            -- This will force the game's damage calculator to use our custom values, while not affecting the UI and breaking things like animations or FX effects.
            chargeComponent.MaxChargeCount = virtualMaxCharges
            chargeComponent.ChargeCount = virtualCurrentCharges

            -- Allows us to track when using Overcharge, so that its hit from skill damage doesn't count.
            usedOvercharge = true

            -- This tells our ChangeCharge() hook to reset the max amount back to 10 when it's called.
            restoreMaxCharges = true

            -- This allows us to check if the enemy in question might have dodged the hit.
            -- Usually the case for flying enemies, and the base game doesn't consume the charges if it's a miss.
            -- If the enemy gets hit by this ability then it gets set back to false.
            enemyDodgedOvercharge = true
        end)

        -- This hook runs at the end of Overcharge's execution.
        RegisterHook(UNLEASH_ON_EFFECT, function(param)
            if not IsValidChargeComponent() then
                return
            end

            Log("Using Overcharge finished.")

            -- The enemy dodged our attack, restore the max charges immediately otherwise the next use of the ability will break the game.
            if enemyDodgedOvercharge then
                chargeComponent.MaxChargeCount = MAX_INGAME_CHARGES
                chargeComponent.ChargeCount = 0
                restoreMaxCharges = false
                Log("Internal Charge Counter kept at " .. virtualCurrentCharges .. " charges due to miss.")
            else
                -- Force game's charge count back to 0 to avoid visual bugs.
                chargeComponent.ChangeCharge(virtualMaxCharges * (-1))

                -- Set the internal charges back to 0.
                virtualCurrentCharges = 0
                Log("Internal Charge Counter consumed and reset back to 0.")
            end
        end)

        -- This hook runs whenever someone uses the ability Shatter.
        RegisterHook(SHATTER_ON_EXECUTE, function(param)
            Log("Shatter used this turn.")
            -- Track the usage of Shatter this turn so that if we stun an enemy, we pretty much know it was from Shatter.
            usedShatter = true
        end)
    end)

    -- If it was successful, mark these hook registrations as true.
    if ok then
        abilityHooksRegistered = true
        Log("Successfully registered Overcharge and Shatter ability execution hooks.")
    end
end

-- This hook runs when loading a save.
RegisterHook(CLIENT_RESTART, function()
    if battleHookRegistered then
        return 
    end

    battleHookRegistered = true

    -- This hook runs on our character when the battle begins.
    -- And it turns out this hook runs when he was eaten by an enemy and freed during battle as well.
    RegisterHook(RECEIVE_BEGIN_PLAY, function(param)
        local self = unwrap(param)

        -- Check if the charge component exists, if yes then cache it.
        if self:IsValid() then
            virtualCurrentCharges = 0
            firstTurn = true

            Log("Internal Charge Counter: " .. tostring(virtualCurrentCharges))

            -- Cache the charge component during the fight for easy access in our other hooks.
            chargeComponent = self

            -- Try registering the ability hooks for Overcharge and Shatter.
            -- These hooks will fail if we don't have the needed character equipped for this battle.
            -- Which means we will have to try and register these hooks every battle.
            -- Also this needs to run AFTER saving our chargeComponent otherwise this will silently fail.
            TryRegisterAbilityHooks()

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

        usedShatter = false
        usedOvercharge = false

        if IsValidChargeComponent() and not firstTurn then
            Log("Adding " .. tostring(chargesPerTurn) .. " charges per turn.")
            chargeComponent.ChangeCharge(chargesPerTurn)
        else
            firstTurn = false
        end
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

        Log("Charge owner: " .. tostring(chargeComponent:GetOwner()))

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
        if isOwner and reason == 1 and usedShatter then
            Log("Player caused break using the ability Shatter, instantly refill charges to " .. virtualMaxCharges .. ".")
            chargeComponent.ChangeCharge(virtualMaxCharges)
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

        if isSourceOwner and isTargetOwner then
            return
        end

        damageReason = damageObject.DamageReason

        -- We dealt damage to an enemy!
        if isSourceOwner then
            -- Set this to false so that incase we used Overcharge and hit the target enemy, we know we have to set the charges back to 0.
            enemyDodgedOvercharge = false

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
            -- Add or remove charges for damaging enemies with abilities if it is NOT from Overcharge, if enabled.
            if damageReason == 1 and not usedOvercharge then
                chargeComponent.ChangeCharge(chargesFromSkillDamage - 1)
                Log("Skill Damage: +" .. chargesFromSkillDamage .. " charges added.")

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
            -- Also track if Overcharge was used, since we don't want the hit to count then.
            elseif damageReason == 6 and chargesOnLuminaDamage ~= 0 and not usedOvercharge then
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