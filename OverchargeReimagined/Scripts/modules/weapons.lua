--[[
------- Overcharge Reimagined v4.0 - By Killera -------

        This module modifies all weapons and changes their attack type, attributes, base damage and passives.
        Also contains custom descriptions for custom effects.

        DO NOT MODIFY THIS MODULE IF YOU SIMPLY WANT TO CUSTOMIZE THIS MOD.
        Use the config.lua for that instead!
]]--

local Log
local config
local CustomFunctions
local ElementEnum

local loadWeaponGuard = false
local CustomWeaponNames = {}
local CustomLuminaDescriptions = {}
local tempLuminaArray = {}
local selectedFrey = false

-- Seeram costs 50 times more than usually.
local SeeramPriceMultiplier = 50

local function CreateCustomLuminaDescriptions()
    CustomLuminaDescriptions["Stance_CritChanceDefensive"] = "Generate " .. config.LuminaAdditionalChargesPerBaseAttackHit .. " additional charge(s) on a base attack hit."
    CustomLuminaDescriptions["Stance_VirtuoseOnShieldBreak"] = "Generate " .. config.LuminaAdditionalChargesPerDodgeParry .. " additional charge(s) on successful dodges and parries."
    CustomLuminaDescriptions["Stance_VirtuoseDoubleBurn"] = string.format("%g", (config.LuminaFreezeChance) * 100) .. "% chance to inflict Frozen for 1 turn with Free Aim shots. But Burn immediately removes Frozen."
    CustomLuminaDescriptions["Foretell_HealOnApply"] = "Generate " .. config.LuminaAdditionalChargesPerIceSkillHit .. " additional charge(s) on a hit using Ice skills."
    CustomLuminaDescriptions["Perfection_HealRankDownMedium"] = "Refill " .. string.format("%g", (config.LuminaAdditionalChargesOnBreakPercentage) * 100) .. "% of total charges upon breaking an enemy."
    CustomLuminaDescriptions["Perfection_SwitchRankSOnBreak"] = "Refill an additional " .. string.format("%g", (config.LuminaMoreChargesOnBreakPercentage) * 100) .. "% of total charges upon breaking an enemy.\nBase Attack can break."
    CustomLuminaDescriptions["Stance_ShieldOnOSstance"] = "Start battle with " .. string.format("%g", (config.VirtualMaxCharges * config.LuminaStartingChargesQuarterPercentage)) .. " charges available."
    CustomLuminaDescriptions["Stance_ShieldDStance"] = "+1 Shield for every " .. config.LuminaAdditionalShieldPerCharges .. " total charges consumed during battle."
    CustomLuminaDescriptions["Stance_DefensiveGradientCharges"] = "After the first turn, generate " .. string.format("%g", (config.VirtualMaxCharges * config.LuminaAdditionalChargesPerTurn)) .. " charges on turn start."
    CustomLuminaDescriptions["Stains_RandomGeneration"] = "Generate " .. config.LuminaAdditionalChargesPerFreeAim .. " additional charge(s) with Free Aim shots."
    CustomLuminaDescriptions["Stains_IncreaseDMGPerLightStain"] = "Generate " .. config.LuminaAdditionalChargesPerAnyCounterAttack .. " additional charge(s) on all types of counterattacks."
    CustomLuminaDescriptions["Foretell_ApplyBurnPerSunChargeOnConsume"] = "Skills that generate charges deal " .. string.format("%g", (config.LuminaIncreasedDamagePerChargePercentage) * 100) .. "% more damage per currently available charge."
    CustomLuminaDescriptions["Perfection_Dodgex2"] = "Maximum charge cap is increased to " .. string.format("%g", (1 + config.LuminaIncreaseMaxChargesPercentage) * 100) .. "%."
    CustomLuminaDescriptions["Perfection_StartRankC"] = "Start battle with " .. string.format("%g", (config.LuminaStartingChargesFullPercentage) * 100) .. "% of total charges available. But become unable to generate any new charges."
    CustomLuminaDescriptions["Perfection_StartRankB"] = "All skills deal " .. string.format("%g", (config.LuminaIncreasedDamageWhenNoCharges) * 100) .. "% more damage while no charges are currently available."
    CustomLuminaDescriptions["Perfection_StartRankA"] = "Maximum charge cap is increased to " .. string.format("%g", (1 + config.LuminaDoubleMaxChargesPercentage) * 100) .. "%."
    CustomLuminaDescriptions["Foretell_OnlyDeathEmpress"] = "Generate " .. config.LuminaAdditionalChargesPerParry .. " additional charge(s) on successful parries. But lose " .. config.LuminaLostChargesPerDodge .. " charges per successful dodge and all charges when hit."
    CustomLuminaDescriptions["Foretell_OnlyJusticeChariot"] = "Skills that inflict Burn or Powerless also inflict Curse on non-boss enemies for " .. config.LuminaCurseDuration .. " turn(s)."
    CustomLuminaDescriptions["Foretell_OnlyFoolTower"] = "Skills that inflict Mark also inflict 1 Blight stack for " .. config.LuminaBlightDuration .. " turn(s)."
    CustomLuminaDescriptions["Stance_AOEOnSwitch"] = "Free Aim shots consume " .. config.LuminaFreeAimChargesConsumed .. " charges to give back 1 AP. But Free Aim shots no longer generate new charges."
    CustomLuminaDescriptions["Perfection_SurvivorRankA"] = "Can't die and ignore damage if at least " .. string.format("%g", (config.VirtualMaxCharges * config.LuminaInvulnerabilityMinimumRequiredCharges)) .. " charges are currently available. But always lose " .. string.format("%g", (config.VirtualMaxCharges * config.LuminaInvulnerabilityChargesLostOnHitPercentage)) .. " charges when hit."
    CustomLuminaDescriptions["Stance_DamageSelfSwitch"] = "After the first turn, increase the maximum charge cap by " .. string.format("%g", (config.LuminaAdditionalMaxChargesPercentage) * 100) .. "% on turn start."
    CustomLuminaDescriptions["Perfection_StartRankS"] = "Double all charge generation. But maximum charge cap is reduced to " .. string.format("%g", (config.LuminaReducedMaxChargesPercentage) * 100) .. "%."
    CustomLuminaDescriptions["Stains_EarthDMGUp"] = "Skills that generate charges deal " .. string.format("%g", (config.LuminaIncreasedDamageChargeGeneratingSkills) * 100) .. "% more damage."
    CustomLuminaDescriptions["Stance_DamageSwitch"] = "Skills that consume charges deal " .. string.format("%g", (config.LuminaIncreasedDamagePerConsumedChargePercentage) * 100) .. "% more damage per consumed charge."
    CustomLuminaDescriptions["Stains_AdditionalFire"] = "Dark, Fire and Lightning skills inflict " .. config.LuminaBurnPerDarkFireLightningSkillHit .. " Burn per hit."
    CustomLuminaDescriptions["Stains_FireDMGUp"] = "Skills that inflict Mark also inflict Charm for " .. config.LuminaCharmDuration .. " turn(s). When hit by charmed enemies, ignore damage, apply Rage for 1 turn and inflict 10 Burn."
    CustomLuminaDescriptions["Stains_ICEDMGUp"] = "Skills that consume charges deal " .. string.format("%g", (config.LuminaIncreasedDamagePerConsumedChargePercentageWeaker) * 100) .. "% more damage per consumed charge."

    CustomLuminaDescriptions["Stance_DMG+Stanceless"] = "Generate " .. config.LuminaAdditionalChargesOnCriticals .. " additional charge(s) on Critical hits using skills, base attacks and counterattacks."
end

local function CreateCustomWeaponNames()
    CustomWeaponNames["Noahram"] = "Gustavo"
end

local function IsCustomLumina(luminaName)
    if CustomLuminaDescriptions[luminaName] then
        return true
    end

    return false
end

local function Init(logFunction, configInstance, customFunctionsObject, elementEnumObject)
    Log = logFunction
    config = configInstance
    CustomFunctions = customFunctionsObject
    ElementEnum = elementEnumObject

    CreateCustomLuminaDescriptions()
    CreateCustomWeaponNames()
end

local function GetCustomLuminaDescription(luminaName)
    if CustomLuminaDescriptions[luminaName] then
        return CustomLuminaDescriptions[luminaName]
    else
        return nil
    end
end

local function GetCustomWeaponName(weaponID)
    Log("Getting custom name for: " .. weaponID)
    if CustomWeaponNames[weaponID] then
        return CustomWeaponNames[weaponID]
    end
end

-- This function patches the provided weapon to use the passives and physical attack type that we want on them.
local function ModifyWeapon(weapon)
    if not weapon or not weapon:IsValid() then
        return
    end

    -- This is the weapon's ID name, quite an ugly property name.
    local name = weapon.WeaponDefinition.DefinitionID_22_2E1ECEC74A7814AEAC1E35ACAD9FC16D:ToString()

    -- Check and patch all weapons on the fly when a save gets loaded.
    -- The vanilla game doesn't use the level 1 lumina so we'll never use it either.
    if name == "Noahram" and config.PatchNoahram then
        weapon.WeaponDefinition.BaseDamageType_31_00CBF5EC48FCC5F58D3E21BCCFF7CEAD = ElementEnum.Physical
        weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4 = FName("None")
        weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("Stance_DMG+Stanceless")
        weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69 = FName("ShieldOnShell")
        weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7 = FName("TriggerLightningOnCrit")
        Log("Patched Noahram.")

    elseif name == "Lanceram" and config.PatchLanceram then
        weapon.WeaponDefinition.BaseDamageType_31_00CBF5EC48FCC5F58D3E21BCCFF7CEAD = ElementEnum.Physical
        weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4 = FName("None")
        weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("Stance_CritChanceDefensive")
        weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69 = FName("AttackPlayAgain")
        weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7 = FName("FrenzyAttack")
        Log("Patched Lanceram.")

    elseif name == "Cruleram" and config.PatchCruleram then
        weapon.WeaponDefinition.BaseDamageType_31_00CBF5EC48FCC5F58D3E21BCCFF7CEAD = ElementEnum.Ice
        weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4 = FName("None")
        weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("Stance_VirtuoseOnShieldBreak")
        weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69 = FName("Stance_VirtuoseDoubleBurn")
        weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7 = FName("Foretell_HealOnApply")
        Log("Patched Cruleram.")

    elseif name == "Abysseram" and config.PatchAbysseram then
        weapon.WeaponDefinition.BaseDamageType_31_00CBF5EC48FCC5F58D3E21BCCFF7CEAD = ElementEnum.Earth
        weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4 = FName("None")
        weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("Perfection_HealRankDownMedium")
        weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69 = FName("Perfection_SwitchRankSOnBreak")
        weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7 = FName("BreakEarthBurst")
        Log("Patched Abysseram.")

    elseif name == "Sakaram" and config.PatchSakaram then
        weapon.WeaponDefinition.BaseDamageType_31_00CBF5EC48FCC5F58D3E21BCCFF7CEAD = ElementEnum.Physical
        weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4 = FName("None")
        weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("Stance_ShieldOnOSstance")
        weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69 = FName("Stance_ShieldDStance")
        weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7 = FName("Stance_DefensiveGradientCharges")
        Log("Patched Sakaram.")

    elseif name == "Demonam" and config.PatchDemonam then
        weapon.WeaponDefinition.BaseDamageType_31_00CBF5EC48FCC5F58D3E21BCCFF7CEAD = ElementEnum.Lightning
        weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4 = FName("None")
        weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("Stains_RandomGeneration")
        weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69 = FName("AugmentedAim_Weapon")
        weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7 = FName("FreeAimDoubleShot")
        Log("Patched Demonam.")

    elseif name == "Gaulteram" and config.PatchGaulteram then
        weapon.WeaponDefinition.BaseDamageType_31_00CBF5EC48FCC5F58D3E21BCCFF7CEAD = ElementEnum.Earth
        weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4 = FName("None")
        weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("Stains_IncreaseDMGPerLightStain")
        weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69 = FName("ShieldOnCounter")
        weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7 = FName("CounterDamagePerShield")
        Log("Patched Gaulteram.")

    elseif name == "Delaram" and config.PatchDelaram then
        weapon.WeaponDefinition.BaseDamageType_31_00CBF5EC48FCC5F58D3E21BCCFF7CEAD = ElementEnum.Light
        weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4 = FName("None")
        weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("Foretell_ApplyBurnPerSunChargeOnConsume")
        weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69 = FName("DMG+WhenNoDMGTaken")
        weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7 = FName("Perfection_Dodgex2")
        Log("Patched Delaram.")

    elseif name == "Cultam" and config.PatchCultam then
        weapon.WeaponDefinition.BaseDamageType_31_00CBF5EC48FCC5F58D3E21BCCFF7CEAD = ElementEnum.Dark
        weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4 = FName("None")
        weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("Foretell_OnlyDeathEmpress")
        weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69 = FName("Foretell_OnlyJusticeChariot")
        weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7 = FName("Foretell_OnlyFoolTower")
        Log("Patched Cultam.")

    elseif name == "Blodam" and config.PatchBlodam then
        weapon.WeaponDefinition.BaseDamageType_31_00CBF5EC48FCC5F58D3E21BCCFF7CEAD = ElementEnum.Dark
        weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4 = FName("None")
        weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("Stains_AdditionalFire")
        weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69 = FName("Stains_FireDMGUp")
        weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7 = FName("Stains_ICEDMGUp")
        Log("Patched Blodam.")

    elseif name == "Chevalam" and config.PatchChevalam then
        weapon.WeaponDefinition.BaseDamageType_31_00CBF5EC48FCC5F58D3E21BCCFF7CEAD = ElementEnum.Physical
        weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4 = FName("None")
        weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("Perfection_StartRankC")
        weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69 = FName("Perfection_StartRankB")
        weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7 = FName("Perfection_StartRankA")
        Log("Patched Chevalam.")

    elseif name == "Nosaram" and config.PatchNosaram then
        weapon.WeaponDefinition.BaseDamageType_31_00CBF5EC48FCC5F58D3E21BCCFF7CEAD = ElementEnum.Lightning
        weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4 = FName("None")
        weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("Stance_AOEOnSwitch")
        weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69 = FName("CritPerBurn")
        weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7 = FName("TriggerLightningOnCrit")
        Log("Patched Nosaram.")

    elseif name == "Gesam" and config.PatchGesam then
        weapon.WeaponDefinition.BaseDamageType_31_00CBF5EC48FCC5F58D3E21BCCFF7CEAD = ElementEnum.Fire
        weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4 = FName("None")
        weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("Perfection_StartRankS")
        weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69 = FName("Stains_EarthDMGUp")
        weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7 = FName("Stance_DamageSwitch")
        Log("Patched Gesam.")

    elseif name == "Seeram" and config.PatchSeeram then
        weapon.WeaponDefinition.BaseDamageType_31_00CBF5EC48FCC5F58D3E21BCCFF7CEAD = ElementEnum.Lightning
        weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4 = FName("None")
        weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("BypassAffinities")
        weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69 = FName("Stance_DamageSelfSwitch")
        weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7 = FName("Perfection_SurvivorRankA")
        Log("Patched Seeram.")
    end

    return weapon
end

-- This function modifies all weapons and clears their passives (if they have any) and replace them with a mix of passives that Gustave can and can't use.
-- The passives that Gustave can't use will be used as a base for our custom passives, so that the game handles the UI drawing for when a passive is locked or unlocked.
-- It also changes their elemental types and chroma cost if needed, although stats scaling and base damage remains the same so those can still be affected by other mods.
local function ModifyAllWeapons(patchedWeaponSample)
    local patchedWeapon = nil

    local weapons = FindAllOf("BP_ItemInstance_Gear_Weapon_C")

    if weapons then
        for _, weapon in pairs(weapons) do
            ModifyWeapon(weapon)

            -- Take a sample of a weapon so we know if a new save has been loaded later.
            if not patchedWeapon then
                patchedWeaponSample = weapon
            end
        end
    else
        Log("Found no weapon assets.")
    end

    return patchedWeaponSample
end

-- This function patches the weapon tooltip menu for Gustave, allowing him to see weapon passives in the menu and it forces the game to use our custom descriptions.
-- The way this is done is a bit hacky since we basically look up a different character and use their info in order to enable displaying the passive, but it works good enough for now.
-- Also patches the upgrade menu to display our custom passive descriptions properly as well.
local function WeaponTooltipsHook(param, inWeaponInstance, inCharacterData)
    if loadWeaponGuard then
        return
    end

    local characterData = CustomFunctions.unwrap(inCharacterData)
    local panel = CustomFunctions.unwrap(param)
    local weapon = CustomFunctions.unwrap(inWeaponInstance)

    -- The currently selected character in the menu isn't Gustave, set flag to false and reload the weapon incase it still holds the custom descriptions.
    -- This is needed in merchant shop menus since all weapons appear in one menu and not in respective character menus.
    if not characterData or not characterData:IsValid() or characterData.CharacterDefinition.CharacterHardcodedName_36_FB9BA9294D02CFB5AD3668B0C4FD85A5:ToString() ~= "Frey" then
        selectedFrey = false

        loadWeaponGuard = true
        panel:LoadWeapon(weapon, characterData)
        loadWeaponGuard = false
        return
    end

    selectedFrey = true

    -- Make sure everything is valid.
    if not weapon or not panel or not weapon:IsValid() or not panel:IsValid() then
        return
    end

    -- Patch the weapon for the upgrade menu.
    inWeaponInstance:Set(ModifyWeapon(weapon))

    -- Get the weapon level so that the upgrade menu displays what passives are unlocked correctly.
    local weaponRank = {}
    weapon:GetCurrentQuality(weaponRank)

    -- Force the upgrade menu to load the luminas of the weapon.
    panel:LoadWeaponLuminas(weapon.WeaponDefinition, weaponRank.Quality)

    -- Get a different character's data so that we can use them to show passives on Gustave's menu.
    local characters = FindAllOf("BP_CharacterData_C")

    if not characters then
        return
    end

    -- Take the first best character that isn't Gustave.
    for _, character in pairs(characters) do
        if character and character:IsValid() and character.CharacterDefinition.CharacterHardcodedName_36_FB9BA9294D02CFB5AD3668B0C4FD85A5:ToString() ~= "Frey" then
            -- Force the game to load our patched weapon instead of the vanilla asset.
            loadWeaponGuard = true
            panel:LoadWeapon(weapon, character)
            loadWeaponGuard = false

            Log("Patched Noah's tooltips successfully!")
            return
        end
    end
end

-- This function modifies the lumina descriptions for Gustave so that we can display the custom descriptions in our WeaponTooltipsHook function.
local function WeaponLuminaTooltipsHook(param, passiveEffectDefinition, qualityLevel, isLocked, unlockLevel)
    if not selectedFrey then
        return
    end

    local weaponLuminaTooltipObject = CustomFunctions.unwrap(param)
    local quality = CustomFunctions.read_int(qualityLevel)

    -- Make sure everything is valid.
    if not weaponLuminaTooltipObject or not weaponLuminaTooltipObject:IsValid() or not quality then
        return
    end

    -- Make sure the weapon has a valid passive in this slot.
    if not tempLuminaArray[quality] then
        return
    end

    -- Get the custom description from our array.
    local customDescription = GetCustomLuminaDescription(tempLuminaArray[quality])

    if not customDescription then
        return
    end

    -- Replace the description of the lumina with our custom description and notify the UI that it was updated.
    -- I believe that UE4SS might have fixed the FText issue, but let's be safe for now and use my custom function just incase someone is using an older version that has the bug.
    CustomFunctions.FTextCustom(weaponLuminaTooltipObject.LuminaDesc, "ContentText", customDescription, nil)
    weaponLuminaTooltipObject.LuminaDesc:UpdateText()
end

-- This gets loaded before our WeaponLuminaTooltipsHook function so that we know which lumina descriptions we have to modify.
-- Luckily they are ordered by 1-4 and the lumina tooltip hook has a parameter for the quality level for each lumina which also between 1-4, so we know which ones to modify!
local function WeaponLoadLuminasHook(param, inWeaponDefinition, inCurrentQuality)
    local weaponDefinition = CustomFunctions.unwrap(inWeaponDefinition)

    tempLuminaArray[1] = weaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4:ToString()
    tempLuminaArray[2] = weaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA:ToString()
    tempLuminaArray[3] = weaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69:ToString()
    tempLuminaArray[4] = weaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7:ToString()
end

-- This function checks if the given list of luminas are either custom or unlocked by the current weapon quality level.
local function GetEquippedWeaponLuminas(luminaNameArray, qualityLevel)
    local equippedCustomPassives = {}

    -- Check each entry and add them if they either exist in our custom lumina array and are unlocked.
    for i = 1, #luminaNameArray do
        if luminaNameArray[i] ~= "None" and IsCustomLumina(luminaNameArray[i]) and qualityLevel >= i then
            equippedCustomPassives[luminaNameArray[i]] = luminaNameArray[i]
            Log("Adding custom lumina " .. i .. ": " .. luminaNameArray[i])
        else
            Log("Ignoring non-custom or locked lumina " .. i .. ": " .. luminaNameArray[i])
        end
    end

    return equippedCustomPassives
end

-- Displays the lumina passive notifications whenever one of our custom passives get triggered.
local function DisplayCustomLuminaNotification(portrait, weaponInstance, luminaName)
    -- Make sure the objects exist and the lumina name exist and are valid.
    if not portrait or not portrait:IsValid() or not weaponInstance or not weaponInstance:IsValid() or not luminaName then
        return
    end

    -- Displays the weapon name that triggered the passive!
    portrait:AddPassiveEffectNotification(FName(luminaName), weaponInstance)
end

-- Modifies the chroma cost of weapons, specifically Seeram so it isn't obtainable early on since it's the ultimate weapon.
local function ModifyWeaponPrice(param, remoteItemInstance, remotePrice)
    local weaponInstance = CustomFunctions.unwrap(remoteItemInstance)

    if not weaponInstance then
        return
    end

    local weaponNameID = weaponInstance.ItemDefinitionID:ToString()

    -- Modify Seeram's price and make it very expensive.
    if weaponNameID == "Seeram" then
       local price = CustomFunctions.read_int(remotePrice)
       remotePrice:Set(price * SeeramPriceMultiplier) 
    end
end

-- Expose the functions to main.lua.
return
{
    Init = Init,
    ModifyAllWeapons = ModifyAllWeapons,
    WeaponTooltipsHook = WeaponTooltipsHook,
    WeaponLuminaTooltipsHook = WeaponLuminaTooltipsHook,
    WeaponLoadLuminasHook = WeaponLoadLuminasHook,
    GetEquippedWeaponLuminas = GetEquippedWeaponLuminas,
    DisplayCustomLuminaNotification = DisplayCustomLuminaNotification,
    ModifyWeaponPrice = ModifyWeaponPrice,
}