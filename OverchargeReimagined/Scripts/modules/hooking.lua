
--[[
------- Overcharge Reimagined v4.0 - By Killera -------

        This module holds strings of all the hook paths that we need to modify the game's functionality.

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
    EGIDE_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Maelle/BP_Battle_SkillScript_New7_Egide.BP_Battle_SkillScript_New7_Egide_C:OnExecuteSkill",
    SABOTAGE_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Verso/BP_Battle_SkillScript_Verso_Sabotage.BP_Battle_SkillScript_Verso_Sabotage_C:OnExecuteSkill",
    PHOENIX_FLAME_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Maelle/BP_Battle_SkillScript_PhoenixFlame.BP_Battle_SkillScript_PhoenixFlame_C:OnExecuteSkill",
    GOMMAGE_ON_EXECUTE = "/Game/Gameplay/Battle/Skills/Content/Maelle/BP_Battle_SkillScript_Gommage.BP_Battle_SkillScript_Gommage_C:OnExecuteSkill",

    -- Hooks that manipulate the cost and damage multiplier of abilities on the fly.
    GET_BASE_COST = "/Game/Gameplay/SkillTree/BP_DataAsset_Skill.BP_DataAsset_Skill_C:GetSkillBaseCost",
    GET_COST = "/Game/Gameplay/SkillTree/BP_DataAsset_Skill.BP_DataAsset_Skill_C:GetSkillCost",
    GET_ATTACK_MULTIPLIER = "/Game/Gameplay/Battle/BP_BattleDamageBuilder.BP_BattleDamageBuilder_C:GetAttackPowerMultiplier",
    GENERIC_CHARACTER_TURN_START = "/Game/jRPGTemplate/Blueprints/Components/AC_jRPG_CharacterBattleStats.AC_jRPG_CharacterBattleStats_C:OnCharacterTurnStart",
    BERSERK_TURN_START = "/Game/Gameplay/Buffs/GenericBuff/BP_BattleBuff_Berserk.BP_BattleBuff_Berserk_C:OnCharacterTurnStart",
    AUDIO_MANAGER_INIT = "/Game/Audio/Blueprints/BP_AudioCharacter_BattleManager.BP_AudioCharacter_BattleManager_C:Init",
    PLAY_SKILL_BATTLE_LINE_INTERNAL = "/Game/Audio/Blueprints/BP_AudioCharacter_BattleManager.BP_AudioCharacter_BattleManager_C:PlaySkillBattleLineInternal",
    LOAD_DEPENDENCIES_FROM_OBJECT = "/Game/Gameplay/LoadingSystem/BP_LoadingSystemComponent.BP_LoadingSystemComponent_C:LoadDependenciesFromObject",
    ROLL_CRITICAL_HIT = "/Game/Gameplay/Battle/BP_BattleDamages.BP_BattleDamages_C:RollCriticalHit",

    -- Camp and overworld related hooks.
    CAN_SWITCH_CHARACTER = "/Game/jRPGTemplate/Blueprints/Basics/BP_jRPG_Character_World.BP_jRPG_Character_World_C:CanSwitchCharacter",
    LOAD_CHARACTER = "/Game/jRPGTemplate/Blueprints/Basics/BP_jRPG_Character_World.BP_jRPG_Character_World_C:LoadCharacter",
    COMPUTE_ACTIVE_CHARACTER = "/Game/jRPGTemplate/Blueprints/Basics/BP_jRPG_Character_World.BP_jRPG_Character_World_C:ComputeActiveCharacter",

    -- Weapon related hooks.
    LOAD_WEAPON = "/Game/UI/Widgets/InGame_Menu/WeaponPanel/WBP_WeaponTooltip.WBP_WeaponTooltip_C:LoadWeapon",
    LOAD_WEAPON_LUMINAS = "/Game/UI/Widgets/InGame_Menu/WeaponPanel/WBP_WeaponTooltip.WBP_WeaponTooltip_C:LoadWeaponLuminas",
    LOAD_PASSIVE_EFFECT_DATA = "/Game/UI/Widgets/InGame_Menu/WeaponPanel/WBP_WeaponTooltipLumina.WBP_WeaponTooltipLumina_C:LoadPassiveEffectData",

    -- Skill tree related hooks.
    INIT_SKILL_GRAPH_SYSTEM = "/Game/Gameplay/SkillTree/BP_CharacterSkillGraphSystem.BP_CharacterSkillGraphSystem_C:Init",
    GET_TOTAL_SKILL_POINTS = "/Game/Gameplay/SkillTree/BP_CharacterSkillGraphSystem.BP_CharacterSkillGraphSystem_C:GetAvailableSkillPoints",

    -- Merchant related hooks.
    COMPUTE_WEAPON_PRICE = "/Game/Gameplay/Inventory/Merchant/BP_MerchantComponent.BP_MerchantComponent_C:ComputeWeaponPrice",

    -- Gustave animation related notifiers.
    BP_NOAH_BATTLE = "/Game/Characters/Heros/BP_Noah_Battle.BP_Noah_Battle_C",
    ABP_NOAH_BATTLE = "/Game/Characters/Heros/AnimBP/Noah/ABP_Battle_Noah.ABP_Battle_Noah_C",
    CHARACTER_EXCLUSION = "/Game/Gameplay/GameActionsSystem/SetCurrentParty/BP_GameAction_CharacterExclusion.BP_GameAction_CharacterExclusion_C",

    -- Save manager related hooks.
    PREPARE_LOADING_SAVE_GAME = "/Game/Gameplay/Save/BP_SaveManager.BP_SaveManager_C:PrepareToLoadSaveGame",
    START_NEW_GAME = "/Game/Gameplay/Save/BP_SaveManager.BP_SaveManager_C:StartNewGame", -- params: bool FromMainMenu, nameproperty OverrideStartLevelDataID

    -- Character replacer hooks, which prevent the game from removing Gustave/Verso from the party.
    ADD_CHARACTER_TO_COLLECTION = "/Game/Gameplay/GameActionsSystem/ReplaceCharacter/BP_GameActionInstance_ReplaceCharacter.BP_GameActionInstance_ReplaceCharacter_C:AddNewCharacterToCollection",
    GET_CHARACTER_IDS = "/Game/Gameplay/GameActionsSystem/ReplaceCharacter/BP_GameActionInstance_ReplaceCharacter.BP_GameActionInstance_ReplaceCharacter_C:GetCharacterIDs",
}