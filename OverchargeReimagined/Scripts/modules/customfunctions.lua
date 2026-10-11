
--[[
------- Overcharge Reimagined v3.0 - By Killera -------

        This module contains some custom functions that were made for this mod.

        DO NOT MODIFY THIS MODULE IF YOU SIMPLY WANT TO CUSTOMIZE THIS MOD.
        Use the config.lua for that instead!
]]--

local Log

local function Init(logFunction)
    Log = logFunction
end

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

-- Since we must build an FText ourselves, the runtime strings require the special symbols to be escaped, otherwise they won't print properly.
-- Example: In Lua we write \"Element\" for the colours but in the runtime it becomes "Element".
-- In order for the colours to not break, we must turn "Element" back into \"Element\" and also handle newlines.
local function EscapeStringCharacters(value)
    value = value:gsub("\\", "\\\\")
    value = value:gsub('"', '\\"')
    value = value:gsub("\n", "\\n")

    return value
end

-- UE4SS' implementation of FText has a major bug with this game where it expects the size of FTest properties to be 24 bytes, but the game only uses 16 bytes!
-- This caused UE4SS' function to write into adjacent memory and cause a memory corruption.
-- This would cause weird behaviour like giving the ability's targeting type an impossible value or it would cause a hard game crash.
-- With our own implementation we build the FText ourselves in order to circumvent this issue.
-- Let's hope that UE4SS fixes this issue at some point, since it has been a known problem for a few months now.
-- Our function gets the memory location of the ability's description property and we import our custom built FText into it.
-- Special thanks to SamTheMan for researching about this issue.
local function FTextCustom(skillObject, propertyName, newDescription, abilityNameID)
    local success, result = pcall(function()
        local reflection = skillObject:Reflection()

        if not reflection then
            Log("Failed to get reflection for skill object.")
            return
        end

        -- Find the skill's description reflection property.
        local property = reflection:GetProperty(propertyName)

        if not property then
            Log("Failed to find property for skill object.")
            return
        end

        -- Get the property's memory address.
        local pointer = property:ContainerPtrToValuePtr(skillObject)

        if not pointer then
            Log("Failed to find pointer address for property of skill object.")
            return
        end

        -- Build our own FText formatted string and import it directly into the corresponding description property.
        local customFText = 'INVTEXT("' .. EscapeStringCharacters(newDescription) .. '")'
        property:ImportText(customFText, pointer, 0, skillObject)
        Log("Imported text into FText property.")

        -- Add the new description to the version in the tracked abilities array.
        -- This will allow us to compare the descriptions and see if they are different, so we prevent unnecessary writing.
        -- Also check if abilityNameID is null because we use this function to modify the charge UI, which doesn't need a name ID.
        if abilityNameID then
            return newDescription
        end

        return nil
    end)

    if not success then
        Log("Failed to set " .. propertyName .. ": " .. tostring(errorMessage))
    end

    -- This is the actual return result that holds the new description.
    -- Since this function uses a pcall, we need to return it TWICE.
    -- I hate Lua.
    return result
end

-- Expose the functions to main.lua.
return
{
    Init = Init,
    unwrap = unwrap,
    read_int = read_int,
    FTextCustom = FTextCustom,
    EscapeStringCharacters = EscapeStringCharacters,
}