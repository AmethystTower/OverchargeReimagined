
--[[
------- Overcharge Reimagined v3.0 - By Killera -------

        This module initializes all the hook paths that we need to modify the game's functionality.

        DO NOT MODIFY THIS MODULE IF YOU SIMPLY WANT TO CUSTOMIZE THIS MOD.
        Use the config.lua for that instead!
]]--

return
{
    -- Our general hook paths that allow us to modify the game.
    CLIENT_RESTART = "/Script/Engine.PlayerController:ClientRestart",
    BATTLE_FULLY_LOADED = "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:OnBattleDependenciesFullyLoaded",
    BATTLE_STARTED = "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_BattleManager.AC_jRPG_BattleManager_C:StartBattleNEW",
    MENU_LOAD_CHARACTER_DATA = "/Game/UI/Widgets/InGame_Menu/CharacterSheet/WBP_GM_CharacterSheet.WBP_GM_CharacterSheet_C:LoadCharacterData",
    SKILLPANEL_LOAD_CHARACTER = "/Game/UI/Widgets/InGame_Menu/Skill_Panel/WBP_GM_SkillsPanel.WBP_GM_SkillsPanel_C:LoadCharacter",

    -- Those are our hooks related to the Overcharge component so we can intercept charge generation and consumption.
    RECEIVE_BEGIN_PLAY = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:ReceiveBeginPlay",
    ON_TURN_START = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:OnTurnStart",
    ON_TURN_END = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:OnTurnEnd",
    CHANGE_CHARGE = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:ChangeCharge",
    DODGE_SUCCESSFUL = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:OnDodgeSuccessful_Event",
    PARRY_SUCCESSFUL = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:OnParrySuccessful_Event",
    ON_RECEIVED_DAMAGE = "/Game/Gameplay/Battle/UniqueMechanics/Charge/BP_UniqueMechanic_Charge_Component.BP_UniqueMechanic_Charge_Component_C:OnCharacterReceivedDamage",
    ON_BREAK_STUN = "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_CharacterBattleStats.AC_jRPG_CharacterBattleStats_C:PerformBreakStun",
    OVERCHARGE_WIDGET_CONSTRUCT = "/Game/Gameplay/Battle/UniqueMechanics/Charge/WBP_UniqueMechanic_Charge.WBP_UniqueMechanic_Charge_C:Construct",
    UPDATE_CURRENT_VALUE = "/Game/Gameplay/Battle/UniqueMechanics/Charge/WBP_UniqueMechanic_Charge.WBP_UniqueMechanic_Charge_C:UpdateCurrentValue",

    -- These are all ability hooks that we use so that they can have additional effects as well as consume and generate charges.
    -- Quite a few hooks we have there... :D
    -- But it's done in the most stable way, I promise! Unlike these horrible AI mods people have been releasing lately.
    UNLEASH_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_UnleashCharge.BP_Battle_SkillScript_Gustave_UnleashCharge_C:OnExecuteSkill",
    SHATTER_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_PerfectBreak.BP_Battle_SkillScript_Gustave_PerfectBreak_C:OnExecuteSkill",
    LIGHT_HOLDER_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_LightHolder.BP_Battle_SkillScript_LightHolder_C:OnExecuteSkill",
    RADIANT_STRIKE_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_RadiantStrike.BP_Battle_SkillScript_Verso_RadiantStrike_C:OnExecuteSkill",
    OVERLOAD_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_Overcharge.BP_Battle_SkillScript_Verso_Overcharge_C:OnExecuteSkill",
    OVERLOAD_ON_EFFECT = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_Overcharge.BP_Battle_SkillScript_Verso_Overcharge_C:OnActionEffect",
    MARKING_SHOT_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_MarkingShot.BP_Battle_SkillScript_Gustave_MarkingShot_C:OnExecuteSkill",
    LUMIERE_ASSAULT_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_Combo1.BP_Battle_SkillScript_Gustave_Combo1_C:OnExecuteSkill",
    STRIKE_STORM_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_StrikeStorm.BP_Battle_SkillScript_Gustave_StrikeStorm_C:OnExecuteSkill",
    FROM_FIRE_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_FromFire.BP_Battle_SkillScript_Gustave_FromFire_C:OnExecuteSkill",
    RECOVERY_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_PerfectRecovery.BP_Battle_SkillScript_Gustave_PerfectRecovery_C:OnExecuteSkill",
    RECOVERY_ON_EFFECT = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_PerfectRecovery.BP_Battle_SkillScript_Gustave_PerfectRecovery_C:OnActionEffect",
    POWERFUL_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_Powerful.BP_Battle_SkillScript_Gustave_Powerful_C:OnExecuteSkill",
    POWERFUL_ON_EFFECT = "/Game/Gameplay/Battle/Skills/Content/Gustave/BP_Battle_SkillScript_Gustave_Powerful.BP_Battle_SkillScript_Gustave_Powerful_C:OnActionEffect",
    STEELED_STRIKE_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_SteeledStrike.BP_Battle_SkillScript_Verso_SteeledStrike_C:OnExecuteSkill",
    ENDBRINGER_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_EndBringer.BP_Battle_SkillScript_Verso_EndBringer_C:OnExecuteSkill",
    BERSERK_SLASH_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_BerserkSlash.BP_Battle_SkillScript_Verso_BerserkSlash_C:OnExecuteSkill",
    DEFIANT_STRIKE_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_DefiantStrike.BP_Battle_SkillScript_Verso_DefiantStrike_C:OnExecuteSkill",
    BLITZ_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Blitz.BP_Battle_SkillScript_Blitz_C:OnExecuteSkill",
    FOLLOW_UP_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_Followup.BP_Battle_SkillScript_Verso_Followup_C:OnExecuteSkill",
    FOLLOW_UP_COST_OVERRIDE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_Followup.BP_Battle_SkillScript_Verso_Followup_C:GetSkillCostOverride",
    ASCENDING_ASSAULT_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_AscendingAssault.BP_Battle_SkillScript_Verso_AscendingAssault_C:OnExecuteSkill",
    ASCENDING_ASSAULT_COST_OVERRIDE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_AscendingAssault.BP_Battle_SkillScript_Verso_AscendingAssault_C:GetSkillCostOverride",
    SPEED_BURST_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_SpeedBurst.BP_Battle_SkillScript_Verso_SpeedBurst_C:OnExecuteSkill",
    PHANTOM_STARS_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_PhantomStars.BP_Battle_SkillScript_Verso_PhantomStars_C:OnExecuteSkill",
    PHANTOM_STARS_COST_OVERRIDE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_PhantomStars.BP_Battle_SkillScript_Verso_PhantomStars_C:GetSkillCostOverride",
    PARADIGM_SHIFT_ON_EFFECT = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_ParadigmShift.BP_Battle_SkillScript_Verso_ParadigmShift_C:OnActionEffect",
    PARADIGM_SHIFT_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_ParadigmShift.BP_Battle_SkillScript_Verso_ParadigmShift_C:OnExecuteSkill",
    PURIFICATION_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_NEW_15.BP_Battle_SkillScript_NEW_15_C:OnExecuteSkill",
    SABOTAGE_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_Sabotage.BP_Battle_SkillScript_Verso_Sabotage_C:OnExecuteSkill",
    STRIKER_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_Striker.BP_Battle_SkillScript_Verso_Striker_C:OnExecuteSkill",
    ANGELS_EYES_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_AngelsEyes.BP_Battle_SkillScript_Verso_AngelsEyes_C:OnExecuteSkill",

    -- Our modifier hooks that allow us to manipulate the cost and damage multiplier of abilities on the fly.
    GET_BASE_COST = "/Game/Gameplay/SkillTree/BP_DataAsset_Skill.BP_DataAsset_Skill_C:GetSkillBaseCost",
    GET_COST = "/Game/Gameplay/SkillTree/BP_DataAsset_Skill.BP_DataAsset_Skill_C:GetSkillCost",
    GET_ATTACK_MULTIPLIER = "/Game/Gameplay/Battle/BP_BattleDamageBuilder.BP_BattleDamageBuilder_C:GetAttackPowerMultiplier",
    GENERIC_CHARACTER_TURN_START = "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_CharacterBattleStats.AC_jRPG_CharacterBattleStats_C:OnCharacterTurnStart",
    BERSERK_TURN_START = "/Game/Gameplay/Buffs/GenericBuff/BP_BattleBuff_Berserk.BP_BattleBuff_Berserk_C:OnCharacterTurnStart",
    AUDIO_MANAGER_INIT = "/Game/Audio/Blueprints/BP_AudioCharacter_BattleManager.BP_AudioCharacter_BattleManager_C:Init",
    PLAY_SKILL_BATTLE_LINE_INTERNAL = "/Game/Audio/Blueprints/BP_AudioCharacter_BattleManager.BP_AudioCharacter_BattleManager_C:PlaySkillBattleLineInternal",
    LOAD_DEPENDENCIES_FROM_OBJECT = "/Game/Gameplay/LoadingSystem/BP_LoadingSystemComponent.BP_LoadingSystemComponent_C:LoadDependenciesFromObject",
}