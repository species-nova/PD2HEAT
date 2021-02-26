Month = os.date("%m")
Day = os.date("%d")	

Hooks:PostHook(MenuSceneManager, "_set_up_environments", "ResHalloweenColorGrade", function(self)
	if Month == "10" and restoration.Options:GetValue("OTHER/Holiday") then
		self._environments.standard.color_grading = "color_halloween"
	end
end)

-- Hooks:PostHook(MenuSceneManager, "_set_up_templates", "ResChallengesTemplate", function(self)
-- 	self._scene_templates.res_challenges = {
-- 		hide_menu_logo = true
-- 	}
-- end)

local math_random = math.random

function MenuSceneManager:set_henchmen_loadout(index, character, loadout)
	self._picked_character_position = self._picked_character_position or {}
	loadout = loadout or managers.blackmarket:henchman_loadout(index)
	character = character or managers.blackmarket:preferred_henchmen(index)

	if not character then
		local preferred = managers.blackmarket:preferred_henchmen()
		local characters = CriminalsManager.character_names()
		local player_character = managers.blackmarket:get_preferred_characters_list()[1]
		local available = {}

		for i, name in ipairs(characters) do
			if player_character ~= name then
				local found_current = table.get_key(self._picked_character_position, name) or 999

				if not table.contains(preferred, name) and index <= found_current then
					local new_name = CriminalsManager.convert_old_to_new_character_workname(name)
					local char_tweak = tweak_data.blackmarket.characters.locked[new_name] or tweak_data.blackmarket.characters[new_name]

					if not char_tweak.dlc or managers.dlc:is_dlc_unlocked(char_tweak.dlc) then
						table.insert(available, name)
					end
				end
			end
		end

		if #available < 1 then
			available = CriminalsManager.character_names()
		end

		character = available[math.random(#available)] or "russian"
	end

	self._picked_character_position[index] = character
	local character_id = managers.blackmarket:get_character_id_by_character_name(character)
	local unit = self._henchmen_characters[index]

	self:_delete_character_weapon(unit, "all")

	local unit_name = tweak_data.blackmarket.characters[character_id].menu_unit

	if not alive(unit) or Idstring(unit_name) ~= unit:name() then
		local pos = unit:position()
		local rot = unit:rotation()

		if alive(unit) then
			self:_delete_character_mask(unit)
			World:delete_unit(unit)
		end

		unit = World:spawn_unit(Idstring(unit_name), pos, rot)

		self:_init_character(unit, index)

		self._henchmen_characters[index] = unit
	end

	unit:base():set_character_name(character)

	local mask = loadout.mask
	local mask_blueprint = loadout.mask_blueprint
	local crafted_mask = managers.blackmarket:get_crafted_category_slot("masks", loadout.mask_slot)

	if crafted_mask then
		mask = crafted_mask.mask_id
		mask_blueprint = crafted_mask.blueprint
	end

	self:set_character_mask_by_id(mask, mask_blueprint, unit, nil, character)

	local mask_data = self._mask_units[unit:key()]

	if mask_data then
		self:update_mask_offset(mask_data)
	end

	local weapon_id = nil
	local crafted_primary = managers.blackmarket:get_crafted_category_slot("primaries", loadout.primary_slot)

	if crafted_primary then
		local primary = crafted_primary.factory_id
		local primary_id = crafted_primary.weapon_id
		local primary_blueprint = crafted_primary.blueprint
		local primary_cosmetics = crafted_primary.cosmetics

		self:set_character_equipped_weapon(unit, primary, primary_blueprint, "primary", primary_cosmetics)

		weapon_id = primary_id
	else
		local primary = tweak_data.character[character].weapon.weapons_of_choice.primary

		if type(primary) == "table" then
			primary = primary[math_random(#primary)]
		end

		primary = string.gsub(primary, "_npc", "")
		local blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(primary)

		self:set_character_equipped_weapon(unit, primary, blueprint, "primary", nil)

		weapon_id = managers.weapon_factory:get_weapon_id_by_factory_id(primary)
	end

	self:set_character_player_style(loadout.player_style, loadout.suit_variation, unit)
	self:set_character_gloves(loadout.glove_id, unit)
	self:_select_henchmen_pose(unit, weapon_id, index)

	local pos, rot = self:get_henchmen_positioning(index)

	unit:set_position(pos)
	unit:set_rotation(rot)
	self:set_henchmen_visible(true, index)
end

function MenuSceneManager:_setup_bg()
	local yaw = 180
	self._bg_unit = World:spawn_unit(Idstring("units/menu/menu_scene/menu_cylinder"), Vector3(0, 0, 0), Rotation(yaw, 0, 0))

	World:spawn_unit(Idstring("units/menu/menu_scene/menu_cylinder_pattern"), Vector3(0, 0, 0), Rotation(yaw, 0, 0))
	World:spawn_unit(Idstring("units/menu/menu_scene/menu_smokecylinder1"), Vector3(0, 0, 0), Rotation(yaw, 0, 0))
	World:spawn_unit(Idstring("units/menu/menu_scene/menu_smokecylinder2"), Vector3(0, 0, 0), Rotation(yaw, 0, 0))
	World:spawn_unit(Idstring("units/menu/menu_scene/menu_smokecylinder3"), Vector3(0, 0, 0), Rotation(yaw, 0, 0))

	self._menu_logo = World:spawn_unit(Idstring("units/menu/menu_scene/menu_logo"), Vector3(0, 10, 0), Rotation(yaw, 0, 0))

	self:set_character(managers.blackmarket:get_preferred_character())
		
	--Proof of concept, should add more later. 
	if Month == "12" and restoration.Options:GetValue("OTHER/Holiday") then
			
		local a = self._bg_unit:get_object(Idstring("a_reference"))
		self._xmas_tree = World:spawn_unit(Idstring("units/pd2_dlc2/props/com_props_christmas_tree_sc/com_prop_christmas_tree_sc"), a:position() + Vector3(-150, 250, -50), Rotation(-45 + (math.random(2) - 1) * 180, 0, 0))
		self._snow_pile = World:spawn_unit(Idstring("units/pd2_dlc_cane/props/cne_prop_snow_pile_01_sc/cne_prop_snow_pile_01_sc"), a:position() + Vector3(-35, 275, -75), Rotation(305, 0, 0))
		
		local e_money = self._bg_unit:effect_spawner(Idstring("e_money"))

		if e_money then
			e_money:set_enabled(false)
		end		
		
	end
		
	self:_setup_lobby_characters()
	self:_setup_henchmen_characters()
end
