--[[
------- Overcharge Reimagined v4.0 - By Killera -------

        This module loads patches for weapons, character data and other objects upon loading a save.
        Examples include enabling weapon passives on Gustave, showing passive tooltips for him and patching the stats of his weapons.

        DO NOT MODIFY THIS MODULE IF YOU SIMPLY WANT TO CUSTOMIZE THIS MOD.
        Use the config.lua for that instead!
]]--

local Log
local config
local unwrap
local read_int

local CustomSkillCost = {}

local function CreateCustomSkillCostValues()
    CustomSkillCost["Combo1_Gustave"] = config.LumiereAssaultUnlockCost
    CustomSkillCost["MarkingShot_Gustave"] = config.MarkingUnlockCost
    CustomSkillCost["AscendingAssault"] = config.AscendingAssaultUnlockCost
    CustomSkillCost["ParadigmShift"] = config.ParadigmShiftUnlockCost
    CustomSkillCost["FromFire_Gustave"] = config.FromFireUnlockCost
    CustomSkillCost["SpeedBurst"] = config.SpeedBurstUnlockCost
    CustomSkillCost["PerfectRecovery_Gustave"] = config.RecoveryUnlockCost
    CustomSkillCost["BerserkSlash"] = config.BerserkSlashUnlockCost
    CustomSkillCost["DefiantStrike"] = config.DefiantStrikeUnlockCost
    CustomSkillCost["Blitz"] = config.BlitzUnlockCost
    CustomSkillCost["Egide"] = config.EgideUnlockCost
    CustomSkillCost["RadiantStrike"] = config.RadiantStrikeUnlockCost
    CustomSkillCost["Purification"] = config.PurificationUnlockCost
    CustomSkillCost["FollowUp"] = config.FollowUpUnlockCost
    CustomSkillCost["Powerful_Gustave"] = config.PowerfulUnlockCost
    CustomSkillCost["StrikeStorm_Gustave"] = config.StrikeStormUnlockCost
    CustomSkillCost["OldLightHolder"] = config.LightHolderUnlockCost
    CustomSkillCost["SteeledStrike"] = config.SteeledStrikeUnlockCost
    CustomSkillCost["Overcharge"] = config.OverloadUnlockCost
    CustomSkillCost["PhantomStars"] = config.PhantomStarsUnlockCost
    CustomSkillCost["EndBringer"] = config.EndBringerUnlockCost
    CustomSkillCost["PerfectBreak_Gustave"] = config.ShatterUnlockCost
    CustomSkillCost["UnleashCharge"] = config.OverchargeUnlockCost

    -- Special ability unlocked along with Maelle's painter skills.
    CustomSkillCost["GustavesMemoire"] = 0

    -- Gradient abilities.
    CustomSkillCost["Sabotage"] = 0
    CustomSkillCost["PhoenixFlame"] = 0
    CustomSkillCost["Gommage"] = 0
end

local function Init(logFunction, configInstance, unwrapFunction, readIntFunction)
    Log = logFunction
    config = configInstance
    unwrap = unwrapFunction
    read_int = readIntFunction

    CreateCustomSkillCostValues()
end

local function GetSpecificSkillAsset(skillName)
    local skill_assets = FindAllOf("BP_DataAsset_Skill_C")

    if not skill_assets then
        return nil
    end

    for _, asset in pairs(skill_assets) do
        -- If the ability is radiant strike or light holder, modify description as well because it doesn't update in the menu when the skills aren't unlocked yet.
        if asset and asset:IsValid() and asset.NameID:ToString() == skillName then
            return asset
        end
    end

    return nil
end

-- This function patches the skill nodes of the skilltree, modifying the unlock condition, skill cost and which skill should be unlocked for each node.
local function PatchSkilltreeNode(characterInstance, skillNodeID, newSkillName, isSecret, isStartingSkill, coords, unlockName, gradientUnlocksTable)
    skillTreeInstance = characterInstance.SkillGraph

    -- If the node ID doesn't exist, create a new entry based off the first node!
    if not skillTreeInstance.Nodes[skillNodeID] then
        skillTreeInstance.Nodes[skillNodeID] = skillTreeInstance.Nodes[1]
    end

    if not unlockName then
        unlockName = "None"
    end

    skillTreeInstance.Nodes[skillNodeID].SkillUnlock_3_15FA1C06433ACE049603919CDF6155FF.IsStartingSkill_13_E1837512408188F4B7D355B6B67B8C1E = isStartingSkill

    if gradientUnlocksTable then
        skillTreeInstance.Nodes[skillNodeID].SkillUnlock_3_15FA1C06433ACE049603919CDF6155FF.RequiresUnlockItem_18_D9EBC20F41097DD7517E428E4A57655E.DataTable = gradientUnlocksTable
        Log("Added unlock table to node: " .. tostring(skillNodeID .. "."))
    end

    skillTreeInstance.Nodes[skillNodeID].SkillUnlock_3_15FA1C06433ACE049603919CDF6155FF.RequiresUnlockItem_18_D9EBC20F41097DD7517E428E4A57655E.RowName = FName(unlockName)
    skillTreeInstance.Nodes[skillNodeID].SkillUnlock_3_15FA1C06433ACE049603919CDF6155FF.IsSecret_11_8074DE284785FEC2841D2EBBB4749CF3 = isSecret
    Log("Unlocked skill of node: " .. tostring(skillNodeID) .. ".")

    if CustomSkillCost[newSkillName] then
        skillTreeInstance.Nodes[skillNodeID].SkillUnlock_3_15FA1C06433ACE049603919CDF6155FF.UnlockCost_5_E90ABE13467BBA2959E91AB582E679AF = CustomSkillCost[newSkillName]
        Log("Patched skill cost of node: " .. tostring(skillNodeID) .. ".")
    end

    local newSkill = GetSpecificSkillAsset(newSkillName)

    if newSkill then
        skillTreeInstance.Nodes[skillNodeID].SkillUnlock_3_15FA1C06433ACE049603919CDF6155FF.Skill_2_9E4FC5804778258FBAA04BBF7F68F799 = newSkill
        Log("Patched " .. newSkillName .. " into node: " .. tostring(skillNodeID) .. ".")
    else
        Log("Couldn't find and patch skill into skilltree: " .. tostring(newSkillName) .. ".")
    end

    if coords then
        skillTreeInstance.Nodes[skillNodeID].Position2D_6_76DE3C8540C4DF06623F629E63159001.X = coords[1]
        skillTreeInstance.Nodes[skillNodeID].Position2D_6_76DE3C8540C4DF06623F629E63159001.Y = coords[2]
    end

    if isStartingSkill then
        local output = {}
        characterInstance.SkillGraphSystem:TryUnlockSkill(newSkill, output)
        Log("Tried unlocking skill " .. newSkillName .. " succeeded: " .. tostring(output.Success))
    end
end

-- This function patches the edges of the skilltree and connects the skill nodes with each other properly.
-- The edges decide the order of the unlocked skill nodes.
local function PatchSkilltreeEdge(characterInstance, edgeID, fromSkillName, toSkillName)
    skillTreeInstance = characterInstance.SkillGraph

    -- If the edge ID doesn't exist, create a new entry based off the first edge!
    if not skillTreeInstance.Edges[edgeID] then
        skillTreeInstance.Edges[edgeID] = skillTreeInstance.Edges[1]
    end

    local fromSkill = GetSpecificSkillAsset(fromSkillName)
    local toSkill = GetSpecificSkillAsset(toSkillName)

    if fromSkill and fromSkill:IsValid() and toSkill and toSkill:IsValid() then
        skillTreeInstance.Edges[edgeID].FromNode_6_32316F404B63760858F3DEA3B8F5E4A5 = fromSkill
        skillTreeInstance.Edges[edgeID].ToNode_7_EB85CED44A714A612FB2EEBB8DCC8999 = toSkill
    end
end

local function PatchGustaveSkilltree(character)
    -- Patch skilltree nodes.
    PatchSkilltreeNode(character, 1, config.AbilityNode_1, false, true, {600, 225}, nil, nil)
    PatchSkilltreeNode(character, 2, config.AbilityNode_2, false, true, {725, 225}, nil, nil)
    PatchSkilltreeNode(character, 3, config.AbilityNode_3, false, false, {537.5, 325}, nil, nil)
    PatchSkilltreeNode(character, 4, config.AbilityNode_4, false, false, {662.5, 325}, nil, nil)
    PatchSkilltreeNode(character, 5, config.AbilityNode_5, false, false, {787.5, 325}, nil, nil)
    PatchSkilltreeNode(character, 6, config.AbilityNode_6, false, false, {475, 425}, nil, nil)
    PatchSkilltreeNode(character, 7, config.AbilityNode_7, false, false, {600, 425}, nil, nil)
    PatchSkilltreeNode(character, 8, config.AbilityNode_8, false, false, {725, 425}, nil, nil)
    PatchSkilltreeNode(character, 9, config.AbilityNode_9, false, false, {850, 425}, nil, nil)
    PatchSkilltreeNode(character, 10, config.AbilityNode_10, false, false, {475, 525}, nil, nil)
    PatchSkilltreeNode(character, 11, config.AbilityNode_11, false, false, {600, 525}, nil, nil)
    PatchSkilltreeNode(character, 12, config.AbilityNode_12, false, false, {725, 525}, nil, nil)
    PatchSkilltreeNode(character, 13, config.AbilityNode_13, false, false, {850, 525}, nil, nil)
    PatchSkilltreeNode(character, 14, config.AbilityNode_14, false, false, {475, 625}, nil, nil)
    PatchSkilltreeNode(character, 15, config.AbilityNode_15, false, false, {600, 625}, nil, nil)
    PatchSkilltreeNode(character, 16, config.AbilityNode_16, false, false, {725, 625}, nil, nil)
    PatchSkilltreeNode(character, 17, config.AbilityNode_17, false, false, {850, 625}, nil, nil)
    PatchSkilltreeNode(character, 18, config.AbilityNode_18, false, false, {475, 725}, nil, nil)
    PatchSkilltreeNode(character, 19, config.AbilityNode_19, false, false, {600, 725}, nil, nil)
    PatchSkilltreeNode(character, 20, config.AbilityNode_20, false, false, {725, 725}, nil, nil)
    PatchSkilltreeNode(character, 21, config.AbilityNode_21, false, false, {850, 725}, nil, nil)
    PatchSkilltreeNode(character, 22, config.AbilityNode_22, false, false, {537.5, 825}, nil, nil)
    PatchSkilltreeNode(character, 23, config.AbilityNode_23, true, false, {787.5, 825}, nil, nil)

    -- Maelle's Homage - unlocked at the same time as the paintress skills because that's when Maelle dies.
    local unlockTable = StaticFindObject("/Game/jRPGTemplate/Datatables/DT_jRPG_Items_Composite.DT_jRPG_Items_Composite")
    PatchSkilltreeNode(character, 24, "GustavesMemoire", true, true, {662.5, 125}, "Quest_MaellePainterSkillsUnlock", unlockTable)

    -- Gradient abilities.
    local gradientUnlocksTable = StaticFindObject("/Game/Gameplay/SkillTree/Content/DT_Items_GradientAttackUnlocks.DT_Items_GradientAttackUnlocks")
    --local test = gradientUnlocksTable:FindRow("GradientUnlock_Verso1")
    --Log("gradientUnlocksTable: " .. tostring(gradientUnlocksTable:FindRow("GradientUnlock_Maelle1").Item_HardcodedName_90_C7F763B74AAB28EF890A66854D7D95AA:ToString()))
    PatchSkilltreeNode(character, 25, "Sabotage", true, true, {1100, 400}, "GradientUnlock_Maelle1", gradientUnlocksTable)
    PatchSkilltreeNode(character, 26, "PhoenixFlame", true, true, {1100, 550}, "GradientUnlock_Maelle2", gradientUnlocksTable)
    PatchSkilltreeNode(character, 27, "Gommage", true, true, {1100, 700}, "GradientUnlock_Maelle3", gradientUnlocksTable)

    -- Patch skilltree edges -- this connects each ability with each other.
    PatchSkilltreeEdge(character, 1, config.AbilityNode_1, config.AbilityNode_3)
    PatchSkilltreeEdge(character, 2, config.AbilityNode_1, config.AbilityNode_4)
    PatchSkilltreeEdge(character, 3, config.AbilityNode_2, config.AbilityNode_4)
    PatchSkilltreeEdge(character, 4, config.AbilityNode_2, config.AbilityNode_5)
    PatchSkilltreeEdge(character, 5, config.AbilityNode_3, config.AbilityNode_7)
    PatchSkilltreeEdge(character, 6, config.AbilityNode_3, config.AbilityNode_6)
    PatchSkilltreeEdge(character, 7, config.AbilityNode_4, config.AbilityNode_7)
    PatchSkilltreeEdge(character, 8, config.AbilityNode_4, config.AbilityNode_8)
    PatchSkilltreeEdge(character, 9, config.AbilityNode_5, config.AbilityNode_8)
    PatchSkilltreeEdge(character, 10, config.AbilityNode_5, config.AbilityNode_9)
    PatchSkilltreeEdge(character, 11, config.AbilityNode_6, config.AbilityNode_10)
    PatchSkilltreeEdge(character, 12, config.AbilityNode_10, config.AbilityNode_14)
    PatchSkilltreeEdge(character, 13, config.AbilityNode_14, config.AbilityNode_18)
    PatchSkilltreeEdge(character, 14, config.AbilityNode_7, config.AbilityNode_11)
    PatchSkilltreeEdge(character, 15, config.AbilityNode_11, config.AbilityNode_15)
    PatchSkilltreeEdge(character, 16, config.AbilityNode_15, config.AbilityNode_19)
    PatchSkilltreeEdge(character, 17, config.AbilityNode_8, config.AbilityNode_12)
    PatchSkilltreeEdge(character, 18, config.AbilityNode_12, config.AbilityNode_16)
    PatchSkilltreeEdge(character, 19, config.AbilityNode_16, config.AbilityNode_20)
    PatchSkilltreeEdge(character, 20, config.AbilityNode_9, config.AbilityNode_13)
    PatchSkilltreeEdge(character, 21, config.AbilityNode_13, config.AbilityNode_17)
    PatchSkilltreeEdge(character, 22, config.AbilityNode_17, config.AbilityNode_21)
    PatchSkilltreeEdge(character, 23, config.AbilityNode_18, config.AbilityNode_22)
    PatchSkilltreeEdge(character, 24, config.AbilityNode_19, config.AbilityNode_22)
    PatchSkilltreeEdge(character, 25, config.AbilityNode_20, config.AbilityNode_23)
    PatchSkilltreeEdge(character, 26, config.AbilityNode_21, config.AbilityNode_23)
    PatchSkilltreeEdge(character, 27, config.AbilityNode_1, config.AbilityNode_2)
    PatchSkilltreeEdge(character, 28, config.AbilityNode_2, config.AbilityNode_1)

    Log("Successfully patched Noah's skilltree.")
end

-- Splits Gustave's and Verso's weapons and fixes his equipped weapon passives when loading a new save.
local function PatchGustaveVerso(patchedCharacterSample)
    -- Patch Gustave and allow him to use weapon passives, as well as separating his and Verso's weapons.
    local characters = FindAllOf("BP_CharacterData_C")

    if not characters then
        return
    end

    for _, character in pairs(characters) do
        -- Patch Gustave.
        if character and character:IsValid() and character.CharacterDefinition.CharacterHardcodedName_36_FB9BA9294D02CFB5AD3668B0C4FD85A5:ToString() == "Frey" then
            -- Enable weapon passives for Gustave in active battles. This does not affect the menu showing them.
            character.CharacterDefinition.DisableWeaponPassiveEffects_209_0C54A5E74EB0A751C44708913AA9F775 = false
            Log("Successfully enabled weapon passives on Noah!")

            -- Allow Noah Weapons only.
            -- 1 is the enum value for Noah Weapons.
            character.CharacterDefinition.AllowedEquipmentSubtypes_30_BFAD31F7402E66AC596911BFA36BF9AF =
            {
                1,
            }

            Log("Successfully patched Noah to only use Noah weapons!")

            -- Load Gustave's patched weapon luminas on his already equipped weapon when loading a save, otherwise they won't work on battle until re-equipping the weapon.
            local isValid = {}
            local weaponInstance = character:GetEquippedWeaponItemInstance(isValid)

            local luminas =
            {
                weaponInstance.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4,
                weaponInstance.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA,
                weaponInstance.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69,
                weaponInstance.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7
            }

            -- Try to equip each lumina!
            for i = 1, #luminas do
                local result = {}
                character:TryEquipLuminaPassive(luminas[i], result)
                Log("Equipped passive " .. tostring(i) .. " successful: " .. tostring(result.Successful))
            end

            -- Sample the character so that we know if a new save has been loaded later.
            patchedCharacterSample = character

        -- Patch Verso.
        elseif character and character:IsValid() and character.CharacterDefinition.CharacterHardcodedName_36_FB9BA9294D02CFB5AD3668B0C4FD85A5:ToString() == "Verso" then
            -- Allow Verso Weapons only.
            -- 10 is the enum value for Verso Weapons.
            character.CharacterDefinition.AllowedEquipmentSubtypes_30_BFAD31F7402E66AC596911BFA36BF9AF =
            {
                10,
            }

            -- Also patch Verso's passives incase the equipped weapon is Verleso since it can be patched as well.
            local isValid = {}
            local weaponInstance = character:GetEquippedWeaponItemInstance(isValid)
            local name = weaponInstance.WeaponDefinition.DefinitionID_22_2E1ECEC74A7814AEAC1E35ACAD9FC16D:ToString()

            if name == "Verleso" then
                local luminas =
                {
                    weaponInstance.WeaponDefinition.Level1Lumina_37_784B3E9C481C775586D1A89DCF6D6FD4,
                    weaponInstance.WeaponDefinition.Level2Lumina_38_82A460E444079A36F26DDCA706CF3CFA,
                    weaponInstance.WeaponDefinition.Level3Lumina_39_307DE22A4854A7781B622B91C882BC69,
                    weaponInstance.WeaponDefinition.Level4Lumina_40_0EB7E00747F0CED5D7259C995D5AB4A7
                }

                -- Try to equip each lumina!
                for i = 1, #luminas do
                    local result = {}
                    character:TryEquipLuminaPassive(luminas[i], result)
                    Log("Equipped passive " .. tostring(i) .. " successful: " .. tostring(result.Successful))
                end
            end

            Log("Successfully patched Verso to only use Verso weapons!")
        end
    end

    return patchedCharacterSample
end

-- Expose the functions to main.lua.
return
{
    Init = Init,
    PatchGustaveVerso = PatchGustaveVerso,
    PatchGustaveSkilltree = PatchGustaveSkilltree,
    PatchCharacterMenu = PatchCharacterMenu,
    PatchEquippedSkills = PatchEquippedSkills,
}