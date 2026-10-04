--[[
------- Overcharge Reimagined v3.0 - By Killera -------

        This module loads patches for weapons, character data and other objects upon loading a save.
        Examples include enabling weapon passives on Gustave, showing passive tooltips for him and patching the stats of his weapons.

        DO NOT MODIFY THIS MODULE IF YOU SIMPLY WANT TO CUSTOMIZE THIS MOD.
        Use the config.lua for that instead!
]]--

local Log
local config
local unwrap
local read_int

local function Init(logFunction, configInstance, unwrapFunction, readIntFunction)
    Log = logFunction
    config = configInstance
    unwrap = unwrapFunction
    read_int = readIntFunction
end

local function PatchGustaveVerso()
    -- Patch Gustave and allow him to use weapon passives, as well as separating his and Verso's weapons.
    local characters = FindAllOf("BP_CharacterData_C")

    if not characters then
        return
    end

    for _, character in pairs(characters) do
        -- Patch Gustave.
        if character and character:IsValid() and character.CharacterDefinition.CharacterHardcodedName_36_FB9BA9294D02CFB5AD3668B0C4FD85A5:ToString() == "Frey" then
            character.CharacterDefinition.DisableWeaponPassiveEffects_209_0C54A5E74EB0A751C44708913AA9F775 = false
            Log("Successfully enabled weapon passives on Noah!")

            -- Allow Noah Weapons only.
            -- 1 is the enum value for Noah Weapons.
            character.CharacterDefinition.AllowedEquipmentSubtypes_30_BFAD31F7402E66AC596911BFA36BF9AF =
            {
                1,
            }

            Log("Successfully patched Noah to only use Noah weapons!")
        -- Patch Verso.
        elseif character and character:IsValid() and character.CharacterDefinition.CharacterHardcodedName_36_FB9BA9294D02CFB5AD3668B0C4FD85A5:ToString() == "Verso" then
            -- Allow Verso Weapons only.
            -- 10 is the enum value for Verso Weapons.
            character.CharacterDefinition.AllowedEquipmentSubtypes_30_BFAD31F7402E66AC596911BFA36BF9AF =
            {
                10,
            }

            Log("Successfully patched Verso to only use Verso weapons!")
        end
    end
end

-- Expose the functions to main.lua.
return
{
    Init = Init,
    PatchGustaveVerso = PatchGustaveVerso,
}