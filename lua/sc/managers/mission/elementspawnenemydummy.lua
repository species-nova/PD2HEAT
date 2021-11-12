--New spawn replacement functionality for enemies, to make tables easier to parse, and consistent with groupaitweakdata.
--Essentially, you get the unit name, and then redirect it to an existing groupaitweakdata unit category;
--This makes it so that if ANYTHING in the file system changes, it'll only really need to be changed in groupaitweakdata.


local groupai_enemy_replacements = {
    
    --For enemies with multiple spawngroups per difficulty, creating a new spawngroup that merges everything together would be the best choice, with new scaling for scripted spawns.
	
	--shields here--
    ["units/pd2_dlc_mad/characters/ene_akan_cs_shield_c45/ene_akan_cs_shield_c45"] = "swat_shield",
    ["units/pd2_dlc_mad/characters/ene_akan_fbi_shield_dw_sr2_smg/ene_akan_fbi_shield_dw_sr2_smg"] = "swat_shield",
    ["units/pd2_dlc_mad/characters/ene_akan_fbi_shield_sr2_smg/ene_akan_fbi_shield_sr2_smg"] = "swat_shield",
	["units/payday2/characters/ene_shield_1/ene_shield_1"] = "swat_shield",
	["units/payday2/characters/ene_shield_2/ene_shield_2"] = "swat_shield",
	["units/payday2/characters/ene_city_shield/ene_city_shield"] = "swat_shield",
	["units/payday2/characters/ene_shield_gensec/ene_shield_gensec"] = "swat_shield",
	["units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield"] = "swat_shield",
	["units/pd2_dlc_mad/characters/ene_akan_fbi_shield_dw_sr2_smg/ene_akan_fbi_shield_dw_sr2_smg"] = "swat_shield",
	["units/pd2_dlc_hvh/characters/ene_shield_hvh_2/ene_shield_hvh_2"] = "swat_shield",
	["units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1"] = "swat_shield",
	["units/pd2_dlc_bph/characters/ene_murkywater_shield/ene_murkywater_shield"] = "swat_shield",
	["units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_c45/ene_swat_shield_policia_federale_c45"] = "swat_shield",
	["units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9/ene_swat_shield_policia_federale_mp9"] = "swat_shield",
	
	--test guy--
	["units/payday2/characters/ene_security_1/ene_security_1"] = "swat_shield",
	["units/payday2/characters/ene_security_2/ene_security_2"] = "swat_shield",
	["units/payday2/characters/ene_security_3/ene_security_3"] = "swat_shield",

    --Cloakers
    ["units/payday2/characters/ene_spook_1/ene_spook_1"] = "spooc",
    ["units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker"] = "spooc",
    ["units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg"] = "spooc",

    --Tasers
    ["units/pd2_dlc_mad/characters/ene_akan_cs_tazer_ak47_ass/ene_akan_cs_tazer_ak47_ass"] = "CS_taser",

    --Dozers.
    ["units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"] = "FBI_tank",
    ["units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg"] = "SKULL_tank",
    ["units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga"] = "BLACK_tank",
}

--For specific spawn replacements, we use a separate table for it, this table WILL need updates if the file locations get changed, but we can keep things more organized that way.

local specific_enemy_replacements = {
    ["units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"] = "units/payday2/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc",
}

function ElementSpawnEnemyDummy:init(...)
    ElementSpawnEnemyDummy.super.init(self, ...)
    local ai_type = tweak_data.levels:get_ai_group_type()
    local difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
    local difficulty_index = tweak_data:difficulty_to_index(difficulty)
    local job = Global.level_data and Global.level_data.level_id
    
    if groupai_enemy_replacements[self._values.enemy] then
        self._values.enemy = self:get_enemy_by_diff(groupai_enemy_replacements[self._values.enemy], ai_type)
    elseif specific_enemy_replacements[self._values.enemy] then
        self._values.enemy = self:get_enemy_by_diff(specific_enemy_replacements[self._values.enemy], ai_type)
    end
    
    self._enemy_name = self._values.enemy or Idstring("units/payday2/characters/ene_swat_1/ene_swat_1")
    self._values.enemy = nil
    self._units = {}
    self._events = {}
    self:_finalize_values()
end

function ElementSpawnEnemyDummy:get_enemy_by_diff(enemy_to_check, ai_type)
    local unit_categories = tweak_data.group_ai.unit_categories
    
    if unit_categories[enemy_to_check] then
        local unit_to_check = unit_categories[enemy_to_check]
		
		if not unit_to_check then
			return self._values.enemy or Idstring("units/payday2/characters/ene_swat_1/ene_swat_1")
		end
		
        if unit_to_check.unit_types[ai_type] then
			local thetable = unit_to_check.unit_types[ai_type]
			
            return thetable[1]
        else
			local ai_type = "america"
			
			if unit_to_check.unit_types[ai_type] then
				return unit_to_check.unit_types[ai_type]
			else
				return self._values.enemy or Idstring("units/payday2/characters/ene_swat_1/ene_swat_1")
			end
        end
    end
    
    return Idstring("units/payday2/characters/ene_swat_1/ene_swat_1")
end