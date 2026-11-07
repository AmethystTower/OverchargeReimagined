--[[
------- Overcharge Reimagined v4.1 - By Killera -------

        This module handles sound assets and patches for combat lines.

        DO NOT MODIFY THIS MODULE IF YOU SIMPLY WANT TO CUSTOMIZE THIS MOD.
        Use the config.lua for that instead!
]]--

-- This list stores a table of all skill voiceline audio assets.
local voiceLinesList = {}
local voiceLinePlaying = false
local Log
local IsValidAudioComponent

-- Initialize the module with the log function.
local function Init(log, isValidAudioComponentFunction)
    Log = log
    IsValidAudioComponent = isValidAudioComponentFunction
end

-- This checks if we used an ability that we want to keep the original voiceline for.
local function KeepOriginalVoiceline(usedOvercharge, usedStrikeStorm, usedRecovery)
    if usedOvercharge or usedStrikeStorm or usedRecovery then
        return true
    end

    return false
end

-- This function caches a reference to all the sound objects for the voicelines.
local function LoadSoundAssets()
    -- Ability voicelines are dependent on the skill being loaded that they are tied to which we handle in our LOAD_DEPENDENCIES_FROM_OBJECT hook.
    voiceLinesList["overcharge1"] = StaticFindObject("/Game/Audio/MetaSound/VO/Noah/SkillLines/VO_BL_Battle_Overcharge1_Gustave.VO_BL_Battle_Overcharge1_Gustave")
    voiceLinesList["overcharge2"] = StaticFindObject("/Game/Audio/MetaSound/VO/Noah/SkillLines/VO_BL_Battle_Overcharge2_Gustave.VO_BL_Battle_Overcharge2_Gustave")
    voiceLinesList["overcharge3"] = StaticFindObject("/Game/Audio/MetaSound/VO/Noah/SkillLines/VO_BL_Battle_Overcharge3_Gustave.VO_BL_Battle_Overcharge3_Gustave")
    voiceLinesList["overcharge4"] = StaticFindObject("/Game/Audio/MetaSound/VO/Noah/SkillLines/VO_BL_Battle_Overcharge4_Gustave.VO_BL_Battle_Overcharge4_Gustave")
    voiceLinesList["breakcycle"] = StaticFindObject("/Game/Audio/MetaSound/VO/Noah/SkillLines/VO_BL_Battle_Skill_Breakthecycle_Gustave.VO_BL_Battle_Skill_Breakthecycle_Gustave")
    voiceLinesList["takethemdown"] = StaticFindObject("/Game/Audio/MetaSound/VO/Noah/SkillLines/VO_BL_Battle_Skill_Takethemdown_Gustave.VO_BL_Battle_Skill_Takethemdown_Gustave")
    voiceLinesList["buffteam"] = StaticFindObject("/Game/Audio/MetaSound/VO/Noah/BattleLine/VO_BL_Battle_BuffTeam_Gustave.VO_BL_Battle_BuffTeam_Gustave")
    voiceLinesList["buffself"] = StaticFindObject("/Game/Audio/MetaSound/VO/Noah/BattleLine/VO_BL_Battle_BuffSelf_Gustave.VO_BL_Battle_BuffSelf_Gustave")

    -- These voicelines always load successfully but the "counter" ones are pretty quiet but also unique to this character.
    -- For some reason the "battle won" voicelines use the "Death Lune" soundalias as a name while there are no actual voicelines for her death, quite weird.
    voiceLinesList["counter"] = StaticFindObject("/Game/Audio/MetaSound/VO/Noah/BattleLine/VO_BL_Battle_Counter_Gustave.VO_BL_Battle_Counter_Gustave")
    voiceLinesList["battlewon"] = StaticFindObject("/Game/Audio/MetaSound/VO/Noah/BattleLine/VO_BL_Battle_DeathLune_Gustave.VO_BL_Battle_DeathLune_Gustave")

    -- Unused voiceline where Gustave reacts to Maelle's death during battle, will be used for the "Maelle's Homage" ability :)
    voiceLinesList["maelle_concerned"] = StaticFindObject("/Game/Audio/MetaSound/VO/Noah/BattleLine/VO_BL_Battle_DeathMaelle_Gustave.VO_BL_Battle_DeathMaelle_Gustave")

    Log("Initialized all sound assets and unloaded loading system component.")
end

-- Load sound dependencies from skill assets.
local function LoadSoundDependencies(loadingSystem, cachedSkills)
    if not loadingSystem or not loadingSystem:IsValid() then
        return
    end

    -- TODO: This works and since we use the game's proper way of loading dependencies, it will cause no issues and the game will handle everything else regarding lifetime and whatnot.
    -- But if we don't have an overcharge component (character missing) then it would be nice to check if we really need to load them for the current fight.
    -- Again, this would be a very small but nice optimization to respect the game's loading patterns, but this is something for a future clean-up update.
    -- This causes no performance issues or much increased memory usage, it's just a few extra abilities that always get loaded so we can use their tied voicelines.
    -- Comparing the fact that using 3 characters with 6 skills each loads 18 of them in a battle, this isn't a big deal.
    if cachedSkills["UnleashCharge"] and cachedSkills["UnleashCharge"]:IsValid() then
        loadingSystem:LoadDependenciesFromObject(cachedSkills["UnleashCharge"])
        Log("Loaded skill and sound dependencies for UnleashCharge skill.")
    end

    if cachedSkills["MarkingShot_Gustave"] and cachedSkills["MarkingShot_Gustave"]:IsValid() then
        loadingSystem:LoadDependenciesFromObject(cachedSkills["MarkingShot_Gustave"])
        Log("Loaded skill and sound dependencies for MarkingShot_Gustave skill.")
    end

    if cachedSkills["StrikeStorm_Gustave"] and cachedSkills["StrikeStorm_Gustave"]:IsValid() then
        loadingSystem:LoadDependenciesFromObject(cachedSkills["StrikeStorm_Gustave"])
        Log("Loaded skill and sound dependencies for StrikeStorm_Gustave skill.")
    end

    if cachedSkills["PerfectRecovery_Gustave"] and cachedSkills["PerfectRecovery_Gustave"]:IsValid() then
        loadingSystem:LoadDependenciesFromObject(cachedSkills["PerfectRecovery_Gustave"])
        Log("Loaded skill and sound dependencies for PerfectRecovery_Gustave skill.")
    end

    if cachedSkills["Powerful_Gustave"] and cachedSkills["Powerful_Gustave"]:IsValid() then
        loadingSystem:LoadDependenciesFromObject(cachedSkills["Powerful_Gustave"])
        Log("Loaded skill and sound dependencies for Powerful_Gustave skill.")
    end
end

-- Called by some function hooks in main.lua, most notably abilities that do not have a voiceline at all or have a voiceline we wanted to change:
-- Lumière Assault, From Fire, Powerful, Radiant Strike, Follow-Up, Ascending Assault, Speed Burst, Paradigm Shift, Egide, Phoenix Flame.
local function PlayVoiceLine(audioManager, keyString)
    if not IsValidAudioComponent() then
        return
    end

    local soundAsset = voiceLinesList[keyString]

    if soundAsset and soundAsset:IsValid() then
        voiceLinePlaying = true
        audioManager:PlaySkillBattleLineInternal(soundAsset)
        voiceLinePlaying = false
    end
end

-- Called by Shatter and Marking Shot.
local function PlayOverchargeLines(audioManager, strengthStage)
    if not IsValidAudioComponent() then
        return
    end

    local soundAsset

    if strengthStage == 3 then
        soundAsset = voiceLinesList["overcharge4"]
    elseif strengthStage == 2 then
        soundAsset = voiceLinesList["overcharge3"]
    elseif strengthStage == 1 then
        soundAsset = voiceLinesList["overcharge2"]
    else
        soundAsset = voiceLinesList["overcharge1"]
    end

    if soundAsset and soundAsset:IsValid() then
        voiceLinePlaying = true
        audioManager:PlaySkillBattleLineInternal(soundAsset)
        voiceLinePlaying = false
    end
end

local function PlaySkillBattleLine(audioManager, usedOvercharge, usedStrikeStorm, usedRecovery, usedOverload, usedSteeledStrike, usedEndbringer, usedPhantomStars, usedBerserkSlash, usedDefiantStrike, usedBlitz, usedPurification, usedLightHolder, usedHomage, usedSabotage, usedAngelsEyes)
    -- We used an ability that we want to keep its original voiceline for, or we are calling this function with a custom voiceline right now.
    -- In both cases do nothing.
    if KeepOriginalVoiceline(usedOvercharge, usedStrikeStorm, usedRecovery) or voiceLinePlaying then
        return
    end

    -- Silence the original voicelines of this ability.
    local interrupted = {}
    audioManager:TryInterruptActiveSkillBattleLine(interrupted)
    Log("Silenced current battle line.")

    -- 50% chance to play no voiceline still since this function seems to trigger all the time, even if nothing is said.
    -- Otherwise we'd hear the voicelines with every cast.
    if math.random(1, 100) <= 50 then
        Log("50% RNG chance wasn't successful, not playing voiceline this time.")
        return
    end

    local voiceLine

    -- Check which ability we used and replace its original voiceline with a custom voiceline from our list.
    if usedOverload then
        voiceLine = voiceLinesList["counter"]
    elseif usedSteeledStrike then
        voiceLine = voiceLinesList["takethemdown"]
    elseif usedEndbringer then
        voiceLine = voiceLinesList["overcharge3"]
    elseif usedPhantomStars then
        voiceLine = voiceLinesList["takethemdown"]
    elseif usedBerserkSlash then
        voiceLine = voiceLinesList["breakcycle"]
    elseif usedDefiantStrike then
        voiceLine = voiceLinesList["battlewon"]
    elseif usedBlitz then
        voiceLine = voiceLinesList["buffteam"]
    elseif usedPurification then
        voiceLine = voiceLinesList["overcharge3"]
    elseif usedLightHolder then
        voiceLine = voiceLinesList["takethemdown"]
    elseif usedHomage then
        voiceLine = voiceLinesList["maelle_concerned"]
    elseif usedSabotage then
        voiceLine = voiceLinesList["battlewon"]
    elseif usedAngelsEyes then
        voiceLine = voiceLinesList["overcharge4"]
    else
        return
    end
    
    if voiceLine and voiceLine:IsValid() then
        voiceLinePlaying = true
        audioManager:PlaySkillBattleLineInternal(voiceLine)
        Log("Replaced battle line with custom value.")
        voiceLinePlaying = false
    end
end


-- Expose the functions to main.lua.
return
{
    Init = Init,
    PlayVoiceLine = PlayVoiceLine,
    PlaySkillBattleLine = PlaySkillBattleLine,
    PlayOverchargeLines = PlayOverchargeLines,
    LoadSoundDependencies = LoadSoundDependencies,
    LoadSoundAssets = LoadSoundAssets,
}