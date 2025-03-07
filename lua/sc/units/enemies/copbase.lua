local pairs_g = pairs

local alive_g = alive

local ids_func = Idstring
local ids_unit = ids_func("unit")
local ids_lod = ids_func("lod")
local ids_lod1 = ids_func("lod1")
local ids_ik_aim = ids_func("ik_aim")
local ids_r_toe = ids_func("RightToeBase")
local ids_l_toe = ids_func("LeftToeBase")

Month = os.date("%m")
local job = Global.level_data and Global.level_data.level_id

local summers_crew = {
	taser_summers = true,
	boom_summers = true,
	medic_summers = true
}

Hooks:PostHook(CopBase, "post_init", "postinithooksex", function(self)
	
	if self._tweak_table == "spooc" then
		self._unit:damage():run_sequence_simple("turn_on_spook_lights")
	end
	
	if self._tweak_table == "summers" then
		managers.enemy:register_summers(self._unit)
	end
	
	if summers_crew[self._tweak_table] then
		self._engagement_range = 1125 --manually set engagement range so these idiots can stick to summers properly without fucking up their weapon usages
		managers.enemy:register_summers_crew(self._unit)
	end
	
	if self._tweak_table == "phalanx_vip" or self._tweak_table == "spring" or self._tweak_table == "summers" or self._tweak_table == "headless_hatman" or managers.skirmish:is_skirmish() and self._tweak_table == "autumn" then
		GroupAIStateBesiege:set_assault_endless(true)
		managers.hud:set_buff_enabled("vip", true)
	end
	
	if self._tweak_table == "autumn" then
		managers.groupai:state():set_endless_silent()
	end

	
end)


--Deleting dozer hats cause it blows people up, pls gib standalone that's always loaded
function CopBase:_chk_spawn_gear()
	local region = tweak_data.levels:get_ai_group_type()
	local difficulty_index = tweak_data:difficulty_to_index(Global and Global.game_settings and Global.game_settings.difficulty or "overkill")

	--Using this only so we can slap this on custom heists
	if heat and heat.Options:GetValue("Holiday") then
		for _,x in pairs(heat.christmas_heists) do
			if job == x or Month == "12" then
				if self._tweak_table == "tank_hw" or self._tweak_table == "spooc_titan" or self._tweak_table == "autumn" then
					--In case we decide to give these guys a unique hat that has some crazy seq manager stuff
				elseif self._tweak_table == "tank_medic" or self._tweak_table == "tank_mini" or self._tweak_table == "spring" then
					self._headwear_unit = safe_spawn_unit("units/pd2_dlc_xm20/characters/ene_acc_dozer_zeal_santa_hat_sc/ene_acc_dozer_zeal_santa_hat_sc", Vector3(), Rotation())
				elseif self._tweak_table == "tank_titan" then
					if region == "russia" or region == "federales" then
						self._headwear_unit = safe_spawn_unit("units/payday2/characters/ene_acc_spook_santa_hat_sc/ene_acc_spook_santa_hat_sc", Vector3(), Rotation())					
					else
						self._headwear_unit = safe_spawn_unit("units/pd2_dlc_xm20/characters/ene_acc_dozer_zeal_santa_hat_sc/ene_acc_dozer_zeal_santa_hat_sc", Vector3(), Rotation())
					end
				elseif self._tweak_table == "tank" then
					if region == "russia" or region == "federales" then
						self._headwear_unit = safe_spawn_unit("units/pd2_dlc_xm20/characters/ene_acc_dozer_akan_santa_hat_sc/ene_acc_dozer_akan_santa_hat_sc", Vector3(), Rotation())
					elseif difficulty_index == 8 then
						self._headwear_unit = safe_spawn_unit("units/pd2_dlc_xm20/characters/ene_acc_dozer_zeal_santa_hat_sc/ene_acc_dozer_zeal_santa_hat_sc", Vector3(), Rotation())
					else
						self._headwear_unit = safe_spawn_unit("units/pd2_dlc_xm20/characters/ene_acc_dozer_santa_hat_sc/ene_acc_dozer_santa_hat_sc", Vector3(), Rotation())
					end			
				elseif self:char_tweak().is_special then
					self._headwear_unit = safe_spawn_unit("units/payday2/characters/ene_acc_spook_santa_hat_sc/ene_acc_spook_santa_hat_sc", Vector3(), Rotation())					
				end

				if self._headwear_unit then
					local align_obj_name = ids_func("Head")
					local align_obj = self._unit:get_object(align_obj_name)

					self._unit:link(align_obj_name, self._headwear_unit, self._headwear_unit:orientation_object():name())
				end
			end
		end
	end
end

function CopBase:default_weapon_name()
	local default_weapon_id = self._default_weapon_id
	
	if default_weapon_id == "amcar" then
		default_weapon_id = "m4"
	elseif default_weapon_id == "m4_blue" then
		default_weapon_id = "mp5"
	end
	
	local weap_ids = tweak_data.character.weap_ids
	
	local job = Global.level_data and Global.level_data.level_id

	--M1911 Users--
	if self._unit:name() == ids_func("units/payday2/characters/ene_secret_service_1/ene_secret_service_1") 
	or self._unit:name() == ids_func("units/payday2/characters/ene_secret_service_2/ene_secret_service_2")
	or self._unit:name() == ids_func("units/pd2_dlc_vit/characters/ene_murkywater_secret_service/ene_murkywater_secret_service")	then
		default_weapon_id = "m1911_npc"
	end
	
	--Blue SWAT Weapon Changes (test)--
	if self._unit:name() == ids_func("units/payday2/characters/ene_swat_1/ene_swat_1") then
		default_weapon_id = "mp5"	
	elseif self._unit:name() == ids_func("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1") then
		default_weapon_id = "mp5"	
	end		
	
	--Yellow Heavy SWAT Weapon Changes (test)
	if self._unit:name() == ids_func("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_ak47_ass/ene_akan_cs_heavy_ak47_ass") then
		default_weapon_id = "ak102"		
	end		
	
	--Biker Weapon Changes--
	if self._unit:name() == ids_func("units/payday2/characters/ene_biker_1/ene_biker_1") then
		default_weapon_id = "mac11"
	elseif self._unit:name() == ids_func("units/payday2/characters/ene_biker_2/ene_biker_2") then
		default_weapon_id = "mossberg"
	elseif self._unit:name() == ids_func("units/payday2/characters/ene_biker_3/ene_biker_3") then
		default_weapon_id = "ak47"
	elseif self._unit:name() == ids_func("units/payday2/characters/ene_biker_4/ene_biker_4") then
		default_weapon_id = "raging_bull"			
	end
	
	--Mendoza Weapon Changes
	if self._unit:name() == ids_func("units/payday2/characters/ene_gang_mexican_1/ene_gang_mexican_1") then
		default_weapon_id = "mac11"
	elseif self._unit:name() == ids_func("units/payday2/characters/ene_gang_mexican_2/ene_gang_mexican_2") then
		default_weapon_id = "mossberg"
	elseif self._unit:name() == ids_func("units/payday2/characters/ene_gang_mexican_3/ene_gang_mexican_3") then
		default_weapon_id = "ak47"
	elseif self._unit:name() == ids_func("units/payday2/characters/ene_gang_mexican_4/ene_gang_mexican_4") then
		default_weapon_id = "raging_bull"			
	end
	
	--Cobras Weapon Changes
	if job == "man" then
		if self._unit:name() == ids_func("units/payday2/characters/ene_gang_black_1/ene_gang_black_1") then
			default_weapon_id = "c45"
		elseif self._unit:name() == ids_func("units/payday2/characters/ene_gang_black_2/ene_gang_black_2") then
			default_weapon_id = "raging_bull"
		elseif self._unit:name() == ids_func("units/payday2/characters/ene_gang_black_3/ene_gang_black_3") then
			default_weapon_id = "c45"
		elseif self._unit:name() == ids_func("units/payday2/characters/ene_gang_black_4/ene_gang_black_4") then
			default_weapon_id = "raging_bull"			
		end		
	else
		if self._unit:name() == ids_func("units/payday2/characters/ene_gang_black_1/ene_gang_black_1") then
			default_weapon_id = "mac11"
		elseif self._unit:name() == ids_func("units/payday2/characters/ene_gang_black_2/ene_gang_black_2") then
			default_weapon_id = "mossberg"
		elseif self._unit:name() == ids_func("units/payday2/characters/ene_gang_black_3/ene_gang_black_3") then
			default_weapon_id = "ak47"
		elseif self._unit:name() == ids_func("units/payday2/characters/ene_gang_black_4/ene_gang_black_4") then
			default_weapon_id = "raging_bull"			
		end				
	end
	
	--Russian Gangster Weapon Changes
	if job == "spa" then
		if self._unit:name() == ids_func("units/payday2/characters/ene_gang_russian_1/ene_gang_russian_1") then
			default_weapon_id = "ak47"
		elseif self._unit:name() == ids_func("units/payday2/characters/ene_gang_russian_2/ene_gang_russian_2") then
			default_weapon_id = "raging_bull"	
		elseif self._unit:name() == ids_func("units/payday2/characters/ene_gang_russian_3/ene_gang_russian_3") then
			default_weapon_id = "mossberg"
		elseif self._unit:name() == ids_func("units/payday2/characters/ene_gang_russian_5/ene_gang_russian_5") then
			default_weapon_id = "ak47"			
		elseif self._unit:name() == ids_func("units/payday2/characters/ene_gang_russian_4/ene_gang_russian_4") then
			default_weapon_id = "mac11"			
		end		
	else
		if self._unit:name() == ids_func("units/payday2/characters/ene_gang_russian_1/ene_gang_russian_1") then
			default_weapon_id = "mossberg"
		elseif self._unit:name() == ids_func("units/payday2/characters/ene_gang_russian_2/ene_gang_russian_2") then
			default_weapon_id = "raging_bull"	
		elseif self._unit:name() == ids_func("units/payday2/characters/ene_gang_russian_3/ene_gang_russian_3") then
			default_weapon_id = "ak47"
		elseif self._unit:name() == ids_func("units/payday2/characters/ene_gang_russian_5/ene_gang_russian_5") then
			default_weapon_id = "ak47"			
		elseif self._unit:name() == ids_func("units/payday2/characters/ene_gang_russian_4/ene_gang_russian_4") then
			default_weapon_id = "mac11"			
		end				
	end
	
	--Bolivian Weapons--
	if self._unit:name() == ids_func("units/pd2_dlc_friend/characters/ene_bolivian_thug_outdoor_01/ene_bolivian_thug_outdoor_01") then
		default_weapon_id = "mossberg"	
	elseif self._unit:name() == ids_func("units/pd2_dlc_friend/characters/ene_bolivian_thug_outdoor_02/ene_bolivian_thug_outdoor_02") then
		default_weapon_id = "mac11"		
	elseif self._unit:name() == ids_func("units/pd2_dlc_friend/characters/ene_security_manager/ene_security_manager") then
		default_weapon_id = "raging_bull"				
	end
	
	--Federale Skulldozer--
	if self._unit:name() == ids_func("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_m249/ene_swat_dozer_policia_federale_m249") then
		default_weapon_id = "m60"				
	end
	
    --Security Guards--
    if self._unit:name() == ids_func("units/payday2/characters/ene_security_3/ene_security_3") or self._unit:name() == ids_func("units/payday2/characters/ene_security_7/ene_security_7") then
        default_weapon_id = "r870"
    elseif self._unit:name() == ids_func("units/payday2/characters/ene_security_6/ene_security_6") then
        default_weapon_id = "mp5"
    elseif self._unit:name() == ids_func("units/payday2/characters/ene_security_8/ene_security_8") then
        default_weapon_id = "raging_bull"
    end
	
	--FBI Guys--
	if self._unit:name() == ids_func("units/payday2/characters/ene_fbi_2/ene_fbi_2") then
		default_weapon_id = "m1911_npc"
	end
	
	--Undead Federal Beauro of Intervention Intellectuals-- 
	if self._unit:name() == ids_func("units/pd2_dlc_hvh/characters/ene_fbi_hvh_2/ene_fbi_hvh_2") then
		deafult_weapon_id = "m1911_npc"
	elseif self._unit:name() == ids_func("units/pd2_dlc_hvh/characters/ene_fbi_hvh_3/ene_fbi_hvh_3") then
		default_weapon_id = "beretta92"
	end
	
	--Giving Friendly AI guns--
	if self._unit:name() == ids_func("units/pd2_dlc_spa/characters/npc_spa/npc_spa") then
		default_weapon_id = "beretta92"	
	elseif self._unit:name() == ids_func("units/payday2/characters/npc_old_hoxton_prisonsuit_2/npc_old_hoxton_prisonsuit_2") then
		default_weapon_id = "mp9"				
	elseif self._unit:name() == ids_func("units/pd2_dlc_berry/characters/npc_locke/npc_locke") then
		default_weapon_id = "m1911_npc"					
	end
	
	--Giving Vanilla Titanshields their silent pistols
	if self._unit:name() == ids_func("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1") then
		default_weapon_id = "beretta92"	
	end	

	for i_weap_id, weap_id in ipairs(weap_ids) do
		if default_weapon_id == weap_id then
			return tweak_data.character.weap_unit_names[i_weap_id]
		end
	end
end

function CopBase:set_visibility_state(stage)
	local unit = self._unit
	stage = stage or false
	local state = stage and true

	if not state and not self._allow_invisible then
		state = true
		stage = 3
	end

	if self._lod_stage == stage then
		return
	end

	local inventory = unit:inventory()
	local weapon = inventory and inventory.get_weapon and inventory:get_weapon()

	if weapon then
		weapon:base():set_flashlight_light_lod_enabled(stage ~= 2 and not not stage)
	end

	if self._visibility_state ~= state then
		if inventory then
			inventory:set_visibility_state(state)

			local mask_unit = inventory._mask_unit

			if mask_unit and alive_g(mask_unit) then
				mask_unit:set_visible(state)

				local linked_units = mask_unit:children()

				for i = 1, #linked_units do
					local linked_unit = linked_units[i]

					linked_unit:set_visible(state)
				end
			end
		end

		unit:set_visible(state)

		local headwear_unit = self._headwear_unit

		if headwear_unit then
			headwear_unit:set_visible(state)
		end

		local spawn_manager = unit:spawn_manager()

		if spawn_manager then
			local linked_units = spawn_manager:linked_units()

			if linked_units then
				local spawned_units = spawn_manager:spawned_units()

				for unit_id, _ in pairs_g(linked_units) do
					local unit_entry = spawned_units[unit_id]

					if unit_entry then
						local child_unit = unit_entry.unit

						if alive_g(child_unit) then
							child_unit:set_visible(state)
						end
					end
				end
			end
		end

		local set_animatable_state = state

		if not set_animatable_state then
			local anim_ext = self._ext_anim

			if not anim_ext.can_freeze or not anim_ext.upper_body_empty then
				set_animatable_state = true
			end
		end

		if set_animatable_state ~= self._animatable_state then
			self._animatable_state = set_animatable_state

			unit:set_animatable_enabled(ids_lod, set_animatable_state)
			unit:set_animatable_enabled(ids_ik_aim, set_animatable_state)
		end

		self._visibility_state = state
	end

	if state then
		if stage ~= self._last_set_anim_lod then
			self._last_set_anim_lod = stage

			self:set_anim_lod(stage)
		end

		if stage == 1 then
			unit:movement():enable_update(true)

			unit:set_animatable_enabled(ids_lod1, true)
		elseif self._lod_stage == 1 then
			unit:set_animatable_enabled(ids_lod1, false)
		end
	else
		if self._lod_stage == 1 then
			unit:set_animatable_enabled(ids_lod1, false)
		end

		local anim_lod = 3

		if anim_lod ~= self._last_set_anim_lod then
			self._last_set_anim_lod = anim_lod

			self:set_anim_lod(anim_lod)
		end
	end

	self._lod_stage = stage

	self:chk_freeze_anims()
end

function CopBase:melee_weapon()
	local set_melee = self._char_tweak.melee_weapon

	if set_melee then
		local ms = managers
		local melee_weapon_data = ms.blackmarket:get_melee_weapon_data(set_melee)

		if melee_weapon_data then
			local third_unit = melee_weapon_data.third_unit

			if third_unit then
				local name = ids_func(third_unit)
				local dr = ms.dyn_resource
				local pack_path = "packages/dyn_resources"

				if not dr:is_resource_ready(ids_unit, name, pack_path) then
					dr:load(ids_unit, name, pack_path, false)
				end
			--don't want to load a first-person unit if a melee weapon lacks a third-person one
			--leaving it here just in case
			--[[else
				local unit = melee_weapon_data.unit

				if unit then
					local name = ids_func(unit)
					local dr = ms.dyn_resource
					local pack_path = "packages/dyn_resources"

					if not dr:is_resource_ready(ids_unit, name, pack_path) then
						dr:load(ids_unit, name, pack_path, false)
					end
				end]]
			end
		end
	end

	return set_melee or self._melee_weapon_table or "weapon"
end
