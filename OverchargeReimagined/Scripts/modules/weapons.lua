--[[
------- Overcharge Reimagined v3.0 - By Killera -------

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

local function CreateCustomLuminaDescriptions()
    CustomLuminaDescriptions["Stance_VirtuoseOnShieldBreak"] = "Generate 1 additional charge(s) when dodging or parrying."
    CustomLuminaDescriptions["Stance_CritChanceDefensive"] = "Generate " .. config.LuminaAdditionalChargesPerBaseAttackHit .. " additional charge(s) on a base attack hit."
    --customLuminaDescriptions["Stance_DefensiveGradientCharges"] = "Generate 5 additional charges on a base attack hit."
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
        weapon.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA = FName("AttackPlayAgain")
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

    return weapon
end

-- This function modifies all weapons and clears their passives (if they have any) and replace them with a mix of passives that Gustave can and can't use.
-- The passives that Gustave can't use will be used as a base for our custom passives, so that the game handles the UI drawing for when a passive is locked or unlocked.
-- It also changes their elemental types and chroma cost if needed, although stats scaling and base damage remains the same so those can still be affected by other mods.
local function ModifyAllWeapons(patchedWeaponSample)
    if patchedWeaponSample and patchedWeaponSample:IsValid() then
        return
    end

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

    -- The currently selected character in the menu isn't Gustave.
    if not characterData or not characterData:IsValid() or characterData.CharacterDefinition.CharacterHardcodedName_36_FB9BA9294D02CFB5AD3668B0C4FD85A5:ToString() ~= "Frey" then
        return
    end

    local panel = CustomFunctions.unwrap(param)
    local weapon = CustomFunctions.unwrap(inWeaponInstance)

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
local function WeaponLuminaTooltipsHook(param, passiveEffectDefinition, qualityLevel, isLocked, unlockLevel, selectedFreyInMenu)
    if not selectedFreyInMenu then
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

-- This function displays the lumina passive notifications whenever one of our custom passives get triggered.
local function DisplayCustomLuminaNotification(portrait, weaponInstance, luminaName)
    -- Make sure the objects exist and the lumina name exist and are valid.
    if not portrait or not portrait:IsValid() or not weaponInstance or not weaponInstance:IsValid() or not luminaName then
        return
    end

    -- This will display the weapon name that triggered the passive!
    portrait:AddPassiveEffectNotification(FName(luminaName), weaponInstance)
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
}