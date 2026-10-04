--[[
------- Overcharge Reimagined v3.0 - By Killera -------

        This module modifies all weapons and changes their attack type, attributes, base damage and passives.
        Also contains custom descriptions for custom effects.

        DO NOT MODIFY THIS MODULE IF YOU SIMPLY WANT TO CUSTOMIZE THIS MOD.
        Use the config.lua for that instead!
]]--

local Log
local config
local unwrap
local read_int

local loadWeaponGuard = false
local customLuminaDescriptions = {}
local tempLuminaArray = {}

local function CreateCustomLuminaDescriptions()
    customLuminaDescriptions["Stance_VirtuoseOnShieldBreak"] = "Generate 1 additional charge(s) when dodging or parrying."
    customLuminaDescriptions["Stance_CritChanceDefensive"] = "Generate 3 additional charge(s) on a base attack hit."
    --customLuminaDescriptions["Stance_DefensiveGradientCharges"] = "Generate 5 additional charges on a base attack hit."
end

local function Init(logFunction, configInstance, unwrapFunction, readIntFunction)
    Log = logFunction
    config = configInstance
    unwrap = unwrapFunction
    read_int = readIntFunction

    CreateCustomLuminaDescriptions()
end

local function GetCustomLuminaDescription(luminaName)
    if customLuminaDescriptions[luminaName] then
        return customLuminaDescriptions[luminaName]
    else
        return nil
    end
end

-- This function modifies all weapons and clears their passives (if they have any) and replace them with a mix of passives that Gustave can and can't use.
-- The passives that Gustave can't use will be used as a base for our custom passives, so that the game handles the UI drawing for when a passive is locked or unlocked.
-- It also changes their elemental types and chroma cost if needed, although stats scaling and base damage remains the same so those can still be affected by other mods.
local function ModifyAllWeapons(ElementEnum)
    local weapons = FindAllOf("BP_ItemInstance_Gear_Weapon_C")

    if weapons then
        for _, weapon in pairs(weapons) do
            if weapon and weapon:IsValid() then
                local name = weapon.WeaponDefinition.DefinitionID_22_2E1ECEC74A7814AEAC1E35ACAD9FC16D:ToString()

                if name == "Noahram" then
                    weapon.WeaponDefinition.BaseDamageType_31_00CBF5EC48FCC5F58D3E21BCCFF7CEAD = ElementEnum.Physical
                    weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4 = FName("None")
                    weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("None")
                    weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69 = FName("None")
                    weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7 = FName("None")
                    Log("Patched Noahram.")
                elseif name == "Lanceram" then
                    weapon.WeaponDefinition.BaseDamageType_31_00CBF5EC48FCC5F58D3E21BCCFF7CEAD = ElementEnum.Physical
                    weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4 = FName("None")
                    weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("Stance_VirtuoseOnShieldBreak")
                    weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69 = FName("Stance_CritChanceDefensive")
                    weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7 = FName("FrenzyAttack")
                    Log("Patched Lanceram.")
                elseif name == "Seeram" then
                    Log("Found Seeram!")
                    weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4 = FName("None")
                    weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("None")
                    weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69 = FName("None")
                    weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7 = FName("None")
                    Log("Patched passives to nothing.")
                elseif name == "Gesam" then
                    Log("Found Gesam!")
                    Log("0: " .. weapon.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4:ToString())
                    Log("1: " .. weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA:ToString())
                    Log("2: " .. weapon.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69:ToString())
                    Log("3: " .. weapon.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7:ToString())
                end
            end
        end
    else
        Log("Found no weapon assets.")
    end
end

-- This function patches the weapon tooltip menu for Gustave, allowing him to see weapon passives in the menu.
-- The way this is done is a bit hacky since we basically look up a different character and use their info in order to enable displaying the passive, but it works good enough for now.
local function WeaponTooltipsHook(param, inWeaponInstance, inCharacterData)
    if loadWeaponGuard then
        return
    end

    local characterData = unwrap(inCharacterData)

    if not characterData or not characterData:IsValid() or characterData.CharacterDefinition.CharacterHardcodedName_36_FB9BA9294D02CFB5AD3668B0C4FD85A5:ToString() ~= "Frey" then
        return
    end

    local panel = unwrap(param)
    local weapon = unwrap(inWeaponInstance)

    if not weapon or not panel or not weapon:IsValid() or not panel:IsValid() then
        return
    end

    local characters = FindAllOf("BP_CharacterData_C")

    if not characters then
        return
    end

    for _, character in pairs(characters) do
        if character and character:IsValid() and character.CharacterDefinition.CharacterHardcodedName_36_FB9BA9294D02CFB5AD3668B0C4FD85A5:ToString() ~= "Frey" then
            loadWeaponGuard = true
            panel:LoadWeapon(weapon, character)

            loadWeaponGuard = false
            Log("Patched Noah's tooltips successfully!")
            return
        end
    end
end

-- This function modifies the lumina descriptions for Gustave so that we can display the custom descriptions.
local function WeaponLuminaTooltipsHook(param, passiveEffectDefinition, qualityLevel, isLocked, unlockLevel, selectedFreyInMenu)
    if not selectedFreyInMenu then
        return
    end

    local weaponLuminaTooltipObject = unwrap(param)
    local luminaInstance = unwrap(passiveEffectDefinition)
    local quality = read_int(qualityLevel)

    if not tempLuminaArray[quality] then
        return
    end

    local customDescription = GetCustomLuminaDescription(tempLuminaArray[quality])

    if not customDescription then
        return
    end

    weaponLuminaTooltipObject.LuminaDesc.ContentText = FText(customDescription)
    weaponLuminaTooltipObject.LuminaDesc:UpdateText()
end

-- This gets loaded before our WeaponLuminaTooltipsHook function so that we know which lumina descriptions we have to modify.
-- Luckily they are ordered by 1-4 and the lumina tooltip hook has a parameter for the quality level for each lumina which also between 1-4, so we know which ones to modify!
local function WeaponLoadLuminasHook(param, inWeaponDefinition, inCurrentQuality)
    local weaponDefinition = unwrap(inWeaponDefinition)

    tempLuminaArray[1] = weaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4:ToString()
    tempLuminaArray[2] = weaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA:ToString()
    tempLuminaArray[3] = weaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69:ToString()
    tempLuminaArray[4] = weaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7:ToString()
end

-- Expose the functions to main.lua.
return
{
    Init = Init,
    ModifyAllWeapons = ModifyAllWeapons,
    WeaponTooltipsHook = WeaponTooltipsHook,
    WeaponLuminaTooltipsHook = WeaponLuminaTooltipsHook,
    WeaponLoadLuminasHook = WeaponLoadLuminasHook,
}