--[[
------- Overcharge Reimagined v3.0 - By Killera -------

        This module handles all the character ID and string tables.

        DO NOT MODIFY THIS MODULE IF YOU SIMPLY WANT TO CUSTOMIZE THIS MOD.
        Use the config.lua for that instead!
]]--

-- Gets the current act we are in if loading into the camp, otherwise returns null.
local function GetCurrentAct()
    -- Try to find the camp manager component, this allows us to know if we're loading into the camp or not.
    local campManager = FindFirstOf("BP_CampManager_C")

    -- Camp manager doesn't exist so we loaded a different area, return null.
    if not campManager or not campManager:IsValid() then
        return nil
    end

    -- Retrieve the necessary data so that we know in which chapter we are in.
    campManager:RetrieveData()

    return campManager.CurrentAct
end

-- Gets the selected character ID from the config settings for each chapter.
local function GetCampMainCharacter(currentAct, config, log)
    local configCharacterID

    if currentAct == 0 then
        configCharacterID = config.CampMainCharacter["Act1"]
    elseif currentAct == 1 then
        configCharacterID = config.CampMainCharacter["Act2"]
    elseif currentAct == 2 then
        configCharacterID = config.CampMainCharacter["Act3"]
    else
        configCharacterID = config.CampMainCharacter["Postgame"]
    end

    -- For some reason the config ID was null, use "Noah" aka "Gustave" as fallback.
    if not configCharacterID then
        log("Config character ID in GetCampMainCharacter() was null, falling back to 'Noah'.")
        return "Noah"
    end

    if configCharacterID == 1 then
        return "Lune"
    elseif configCharacterID == 2 then
        return "Maelle"
    elseif configCharacterID == 3 then
        return "Verso"
    elseif configCharacterID == 4 then
        return "Monoco"
    elseif configCharacterID == 5 then
        return "Sciel"
    elseif configCharacterID == 6 then
        return "Esquie"
    -- If the config ID is 0 or any invalid value then always default to "Noah" aka "Gustave".
    else
        return "Noah"
    end
end

-- This function checks if the player actually owns the character.
local function PlayerOwnsCharacter(characterName, log)
    -- Simply find the component responsible for managing this, which is BP_jRPG_GI_Custom_C and handles quite a lot at once.
    local GICustomComponent = FindFirstOf("BP_jRPG_GI_Custom_C")

    -- Couldn't find the component, default to false to be safe.
    if not GICustomComponent or not GICustomComponent:IsValid() then
        log("Couldn't find 'BP_jRPG_GI_Custom_C' component in PlayerOwnsCharacter(), returning false.")
        return false
    end

    -- Check if the player owns the character now.
    local result = GICustomComponent:HasCharacterInCollectionByID(FName(characterName))

    log("Player owns " .. characterName .. ": " .. tostring(result))
    return result
end

-- Expose the functions to main.lua.
return
{
    GetCurrentAct = GetCurrentAct,
    GetCampMainCharacter = GetCampMainCharacter,
    PlayerOwnsCharacter = PlayerOwnsCharacter
}