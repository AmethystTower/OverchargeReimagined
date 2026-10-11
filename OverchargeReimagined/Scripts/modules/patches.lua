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

local CustomSkillCost = {}

local function CreateCustomSkillCostValues()
    CustomSkillCost["UnleashCharge"] = 0
    CustomSkillCost["Combo1_Gustave"] = 0
    CustomSkillCost["PerfectBreak_Gustave"] = 6
    CustomSkillCost["MarkingShot_Gustave"] = 1
    CustomSkillCost["StrikeStorm_Gustave"] = 10
    CustomSkillCost["FromFire_Gustave"] = 2
    CustomSkillCost["PerfectRecovery_Gustave"] = 2
    CustomSkillCost["Powerful_Gustave"] = 1
    CustomSkillCost["OldLightHolder"] = 6
    CustomSkillCost["RadiantStrike"] = 4
    CustomSkillCost["Overcharge"] = 6
    CustomSkillCost["SteeledStrike"] = 10
    CustomSkillCost["EndBringer"] = 10
    CustomSkillCost["BerserkSlash"] = 3
    CustomSkillCost["DefiantStrike"] = 6
    CustomSkillCost["Blitz"] = 5
    CustomSkillCost["FollowUp"] = 5
    CustomSkillCost["AscendingAssault"] = 4
    CustomSkillCost["SpeedBurst"] = 5
    CustomSkillCost["PhantomStars"] = 8
    CustomSkillCost["ParadigmShift"] = 2
    CustomSkillCost["Purification"] = 2
    CustomSkillCost["Egide"] = 4

    -- Gradient abilities.
    CustomSkillCost["Sabotage"] = 0
    CustomSkillCost["PhoenixFlame"] = 0
    CustomSkillCost["AngelsEyes"] = 0
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

local function GetSpecificSkillUnlockCost(skillName)
end

-- This function patches the skill nodes of the skilltree, modifying the unlock condition, skill cost and which skill should be unlocked for each node.
local function PatchSkilltreeNode(characterInstance, skillNodeID, newSkillName, isSecret, isStartingSkill, coords, unlockName, gradientUnlocksTable)
    local skillTreeInstance = characterInstance.SkillGraph

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
        Log("Couldn't find and patch skill into skilltree: " .. tostring(newSkill) .. ".")
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
    local skillTreeInstance = characterInstance.SkillGraph

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
    PatchSkilltreeNode(character, 1, "Powerful_Gustave", false, false, nil, nil)
    PatchSkilltreeNode(character, 2, "Combo1_Gustave", false, true, nil, nil)
    PatchSkilltreeNode(character, 3, "FromFire_Gustave", false, false, nil, nil)
    PatchSkilltreeNode(character, 4, "PerfectRecovery_Gustave", false, false, nil, nil)
    PatchSkilltreeNode(character, 5, "MarkingShot_Gustave", false, false, nil, nil)
    PatchSkilltreeNode(character, 6, "PerfectBreak_Gustave", false, false, nil, nil)
    PatchSkilltreeNode(character, 7, "StrikeStorm_Gustave", false, false, nil, nil)
    PatchSkilltreeNode(character, 8, "UnleashCharge", false, true, nil, nil)
    PatchSkilltreeNode(character, 9, "Blitz", false, false, nil, nil)
    PatchSkilltreeNode(character, 10, "BerserkSlash", false, false, nil, nil)
    PatchSkilltreeNode(character, 11, "OldLightHolder", false, false, nil, nil)
    PatchSkilltreeNode(character, 12, "PhantomStars", false, false, nil, nil)
    PatchSkilltreeNode(character, 13, "AscendingAssault", false, false, nil, nil)
    PatchSkilltreeNode(character, 14, "Overcharge", false, false, nil, nil)
    PatchSkilltreeNode(character, 15, "EndBringer", false, false, nil, nil)
    PatchSkilltreeNode(character, 16, "FollowUp", false, false, nil, nil)
    PatchSkilltreeNode(character, 17, "DefiantStrike", false, false, nil, nil)
    PatchSkilltreeNode(character, 18, "SpeedBurst", false, false, nil, nil)
    PatchSkilltreeNode(character, 19, "ParadigmShift", false, false, nil, nil)
    PatchSkilltreeNode(character, 20, "Purification", false, false, nil, nil)
    PatchSkilltreeNode(character, 21, "SteeledStrike", false, false, nil, nil)
    PatchSkilltreeNode(character, 22, "RadiantStrike", false, false, nil, nil)
    PatchSkilltreeNode(character, 23, "Egide", false, false, {975.0, 225.0}, nil)

    -- Gradient abilities.
    local gradientUnlocksTable = StaticFindObject("/Game/Gameplay/SkillTree/Content/DT_Items_GradientAttackUnlocks.DT_Items_GradientAttackUnlocks")
    --local test = gradientUnlocksTable:FindRow("GradientUnlock_Verso1")
    --Log("gradientUnlocksTable: " .. tostring(gradientUnlocksTable:FindRow("GradientUnlock_Maelle1").Item_HardcodedName_90_C7F763B74AAB28EF890A66854D7D95AA:ToString()))
    PatchSkilltreeNode(character, 24, "Sabotage", true, true, {475.0, 125.0}, "GradientUnlock_Maelle1", gradientUnlocksTable)
    PatchSkilltreeNode(character, 25, "PhoenixFlame", true, true, {662.5, 125.0}, "GradientUnlock_Maelle2", gradientUnlocksTable)
    PatchSkilltreeNode(character, 26, "AngelsEyes", true, true, {850.0, 125.0}, "GradientUnlock_Maelle3", gradientUnlocksTable)

    -- Patch skilltree edges.
    PatchSkilltreeEdge(character, 1, "Combo1_Gustave", "Powerful_Gustave")
    PatchSkilltreeEdge(character, 2, "Powerful_Gustave", "PerfectRecovery_Gustave")
    PatchSkilltreeEdge(character, 3, "UnleashCharge", "MarkingShot_Gustave")
    PatchSkilltreeEdge(character, 4, "MarkingShot_Gustave", "FromFire_Gustave")
    PatchSkilltreeEdge(character, 5, "Powerful_Gustave", "MarkingShot_Gustave")
    PatchSkilltreeEdge(character, 6, "PerfectRecovery_Gustave", "FromFire_Gustave")
    PatchSkilltreeEdge(character, 7, "PerfectRecovery_Gustave", "PerfectBreak_Gustave")
    PatchSkilltreeEdge(character, 8, "FromFire_Gustave", "StrikeStorm_Gustave")
    PatchSkilltreeEdge(character, 9, "StrikeStorm_Gustave", "PerfectBreak_Gustave")
    PatchSkilltreeEdge(character, 10, "PerfectBreak_Gustave", "DefiantStrike")
    PatchSkilltreeEdge(character, 11, "StrikeStorm_Gustave", "ParadigmShift")
    PatchSkilltreeEdge(character, 12, "StrikeStorm_Gustave", "EndBringer")
    PatchSkilltreeEdge(character, 13, "FromFire_Gustave", "BerserkSlash")
    PatchSkilltreeEdge(character, 14, "MarkingShot_Gustave", "Overcharge")
    PatchSkilltreeEdge(character, 15, "Overcharge", "OldLightHolder")
    PatchSkilltreeEdge(character, 16, "OldLightHolder", "Purification")
    PatchSkilltreeEdge(character, 17, "OldLightHolder", "PhantomStars")
    PatchSkilltreeEdge(character, 18, "PhantomStars", "BerserkSlash")
    PatchSkilltreeEdge(character, 19, "EndBringer", "BerserkSlash")
    PatchSkilltreeEdge(character, 20, "Powerful_Gustave", "Blitz")
    PatchSkilltreeEdge(character, 21, "Blitz", "FollowUp")
    PatchSkilltreeEdge(character, 22, "FollowUp", "SpeedBurst")
    PatchSkilltreeEdge(character, 23, "FollowUp", "RadiantStrike")
    PatchSkilltreeEdge(character, 24, "PerfectRecovery_Gustave", "SteeledStrike")
    PatchSkilltreeEdge(character, 25, "SteeledStrike", "RadiantStrike")
    PatchSkilltreeEdge(character, 26, "SteeledStrike", "AscendingAssault")
    PatchSkilltreeEdge(character, 27, "AscendingAssault", "PerfectBreak_Gustave")
    PatchSkilltreeEdge(character, 28, "Egide", "Purification")

    Log("Successfully patched Noah's skilltree.")
end

local function PatchGustaveVerso(patchedCharacterSample)
    if patchedCharacterSample and patchedCharacterSample:IsValid() then
        return
    end

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

            -- Patch Gustave's skilltree.
            PatchGustaveSkilltree(character)

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

            Log("Successfully patched Verso to only use Verso weapons!")
        end
    end

    return patchedCharacterSample
end

local function GetTotalSkillPoints(param, selectedFreyInMenu)
    if not selectedFreyInMenu then
        return
    end

    local skillGraphSystem = unwrap(param)

    if not skillGraphSystem or not skillGraphSystem:IsValid() then
        return
    end

    -- This value will help us calculate how many skillpoints are in use right now.
    local usedSkillPoints = 0

    -- Gets a list of all skills unlocked in the skill tree so far.
    local unlockedSkillAssets = skillGraphSystem:GetUnlockedSkills()

    if unlockedSkillAssets then
        for _, remoteAsset in pairs(unlockedSkillAssets) do
            -- For some reason UE4SS provides us remote objects from the return value of the function, so unwrap them.
            unlockedAsset = unwrap(remoteAsset)
            -- Get the skill's unlock cost and add it to the currently used skillpoints value.
            if unlockedAsset and unlockedAsset:IsValid() then
                if CustomSkillCost[unlockedAsset.NameID:ToString()] then
                    usedSkillPoints = usedSkillPoints + CustomSkillCost[unlockedAsset.NameID:ToString()]
                end
            end
        end
    end

    skillGraphSystem.CurrentlyUsedSkillPoints = usedSkillPoints

    --Log("Successfully patched available points in skill tree for Noah: " .. tostring(skillGraphSystem.CurrentlyUsedSkillPoints))
end

local test = false

local function PatchCharacterMenu(param, remoteCharacterData, remoteActor)
    local menuScene = unwrap(param)

    if not menuScene or not menuScene:IsValid() or test then
        return
    end

    --Log("menuScene.ChildActor_Gustave.RelativeLocation: " .. tostring(menuScene.ChildActor_Gustave.RelativeLocation.X))

    -- Set Gustave's X position more to the left: from 62.13718 to 20.0.
    menuScene.ChildActor_Gustave.RelativeLocation.X = 200.0
    menuScene.ChildActor_Lune.RelativeLocation.X = 200.0
    --menuScene.ChildActor_Lune = menuScene.ChildActor_Gustave

    --Log("menuScene.ChildActor_Gustave.RelativeLocation: " .. tostring(menuScene.ChildActor_Gustave.RelativeLocation.X))

    --local component = menuScene.ChildActor_Gustave

    --Log("Component: " .. tostring(component:GetFullName()))
    --Log("RelativeLocation: " .. tostring(component.RelativeLocation))
    --Log("Parent: " .. tostring(component:GetAttachParent():GetFullName()))
    --Log("Root: " .. tostring(menuScene.DefaultSceneRoot:GetFullName()))

    --menuScene:SetActivePageAndCharacterAnimState(2, unwrap(remoteCharacterData))

    --menuScene:OnCharacterCollectionChanged()
    --menuScene:UpdateCharactersVisualAlterations()
    --menuScene:DisableGameMenuScene()

    --test = true
    --menuScene:LoadCharacters(characterCollectionOut)
    --test = false

    --menuScene:EnableGameMenuScene({}, )
    --menuScene:DisableGameMenuScene()
    --menuScene:EnableGameMenuScene(CurrentGameMenuPage)
end

-- Expose the functions to main.lua.
return
{
    Init = Init,
    PatchGustaveVerso = PatchGustaveVerso,
    PatchGustaveSkilltree = PatchGustaveSkilltree,
    GetTotalSkillPoints = GetTotalSkillPoints,
    PatchCharacterMenu = PatchCharacterMenu,
}