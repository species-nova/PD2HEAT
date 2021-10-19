local math_random = math.random

local string_gsub = string.gsub
local type_g = type
local next_g = next

local table_get_key = table.get_key
local table_contains = table.contains

local clone_g = clone
local alive_g = alive
local world_g = World
local idstr_func = Idstring

function MenuSceneManager:set_henchmen_loadout(index, character, loadout)
	self._picked_character_position = self._picked_character_position or {}
	loadout = loadout or managers.blackmarket:henchman_loadout(index)
	character = character or managers.blackmarket:preferred_henchmen(index)

	if not character then
		local preferred = managers.blackmarket:preferred_henchmen()
		local characters = CriminalsManager.character_names()
		local player_character = managers.blackmarket:get_preferred_characters_list()[1]
		local available = {}

		for i = 1, #characters do
			local name = characters[i]

			if player_character ~= name then
				local found_current = table_get_key(self._picked_character_position, name) or 999

				if not table_contains(preferred, name) and index <= found_current then
					local new_name = CriminalsManager.convert_old_to_new_character_workname(name)
					local char_tweak = tweak_data.blackmarket.characters.locked[new_name] or tweak_data.blackmarket.characters[new_name]

					if not char_tweak.dlc or managers.dlc:is_dlc_unlocked(char_tweak.dlc) then
						available[#available + 1] = name
					end
				end
			end
		end

		if #available < 1 then
			available = CriminalsManager.character_names()
		end

		character = available[math_random(#available)] or "russian"
	end

	self._picked_character_position[index] = character
	local character_id = managers.blackmarket:get_character_id_by_character_name(character)
	local unit = self._henchmen_characters[index]

	self:_delete_character_weapon(unit, "all")

	local unit_name = tweak_data.blackmarket.characters[character_id].menu_unit
	local was_alive = alive_g(unit)

	if not was_alive or idstr_func(unit_name) ~= unit:name() then
		local pos, rot = nil

		if was_alive then
			pos = unit:position()
			rot = unit:rotation()

			self:_delete_character_mask(unit)
			world_g:delete_unit(unit)
		end

		unit = world_g:spawn_unit(idstr_func(unit_name), pos or Vector3(), rot or Rotation())

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
		local blueprint, cosmetics = nil

		if type_g(primary) == "table" then
			primary = primary[math_random(#primary)]

			blueprint = primary.blueprint
			cosmetics = primary.cosmetics
			primary = primary.factory_name
			primary = string_gsub(primary, "_npc", "")

			if not blueprint or not next_g(blueprint) then
				blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(primary)
			else
				local fm = managers.weapon_factory
				local modified_default = clone_g(fm:get_default_blueprint_by_factory_id(primary))
				local part_data_f = fm._part_data

				for i = 1, #blueprint do
					local part_id = blueprint[i]
					local part_data = part_data_f(fm, part_id, primary)

					if part_data then
						for idx = 1, #modified_default do
							local default_part_id = modified_default[idx]
							local default_part_data = part_data_f(fm, default_part_id, primary)

							if default_part_data then
								if part_data.type == default_part_data.type then
									local new_default_blueprint = {}

									for old_i = 1, idx - 1 do
										new_default_blueprint[#new_default_blueprint + 1] = modified_default[old_i]
									end

									for old_i = idx + 1, #modified_default do
										new_default_blueprint[#new_default_blueprint + 1] = modified_default[old_i]
									end

									modified_default = new_default_blueprint

									break
								end
							end
						end
					end
				end

				for i = 1, #blueprint do
					local part_id = blueprint[i]

					modified_default[#modified_default + 1] = part_id
				end

				blueprint = modified_default
			end

			if cosmetics and not cosmetics.id then
				cosmetics = nil
			end
		else
			primary = string_gsub(primary, "_npc", "")

			blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(primary)
		end

		self:set_character_equipped_weapon(unit, primary, blueprint, "primary", cosmetics)

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

if not _G.IS_VR then

Month = os.date("%m")
Day = os.date("%d")	

Hooks:PostHook(MenuSceneManager, "_set_up_environments", "ResHalloweenColorGrade", function(self)
	if Month == "10" and heat.Options:GetValue("Holiday") then
		self._environments.standard.color_grading = "color_halloween"
	end
end)

--this is kinda disgusting
--having template access might be useful later
Hooks:PostHook(MenuSceneManager, "_set_up_templates", "HEATMenuTemplate", function(self)
	local ref = self._bg_unit:get_object(Idstring("a_camera_reference"))
	local c_ref = self._bg_unit:get_object(Idstring("a_reference"))
	local target_pos = Vector3(0, 0, ref:position().z)
	local offset = Vector3(ref:position().x, ref:position().y, 0)
	self._scene_templates.infamy_preview = {
		fov = 40,
		can_change_fov = false,
		use_item_grab = true,
		camera_pos = offset:rotate_with(Rotation(90)) + Vector3(0, 0, 202),
		target_pos = target_pos + Vector3(0, 0, 200),
		character_pos = Vector3(-75, 10, 100),
		hide_armor = true,
		hide_mask = true,
		hide_menu_logo = true,
		hide_weapons = true,
		disable_rotate = true,
		character_visible = true,
		use_character_grab2 = false,
		use_character_pan = false,
		lights = {
			self:_create_light({
				far_range = 250,
				specular_multiplier = 55,
				color = Vector3(0.2, 0.5, 1) * 4.3,
				position = Vector3(0, -200, 280)
			}),
			self:_create_light({
				far_range = 370,
				specular_multiplier = 55,
				color = Vector3(1, 0.7, 0.5) * 2.3,
				position = Vector3(200, 60, 280)
			}),
			self:_create_light({
				far_range = 270,
				specular_multiplier = 0,
				color = Vector3(1, 1, 1) * 0.8,
				position = Vector3(160, -130, 220)
			}),
			self:_create_light({
				far_range = 270,
				specular_multiplier = 155,
				color = Vector3(0.86, 0.67, 0.41) * 2,
				position = Vector3(160, 0, 220)
			})
		}
	}
	self._scene_templates.lobby = {
		use_character_grab = false,
		hide_menu_logo = true,
		camera_pos = offset:rotate_with(Rotation(90)),
		target_pos = target_pos,
		character_pos = c_ref:position() + Vector3(0, 500, 0),
		lobby_characters_visible = true,
		fov = 40,
		lights = {
			self:_create_light({
				far_range = 300,
				color = Vector3(0.86, 0.57, 0.31) * 3,
				position = Vector3(56, 100, -10)
			}),
			self:_create_light({
				far_range = 3000,
				specular_multiplier = 6,
				color = Vector3(1, 2.5, 4.5) * 3,
				position = Vector3(-1000, -300, 800)
			}),
			self:_create_light({
				far_range = 800,
				specular_multiplier = 0,
				color = Vector3(1, 1, 1) * 0.35,
				position = Vector3(300, 100, 0)
			})
		}
	}
	self._scene_templates.lobby1 = {
		use_character_grab = false,
		lobby_characters_visible = true,
		hide_menu_logo = true,
		camera_pos = Vector3(-90.5634, -157.226, -28.6729),
		target_pos = Vector3(-90.5634, -157.226, -28.6729) + Vector3(-0.58315, 0.781811, 0.220697) * 100,
		fov = 30,
		lights = clone(self._scene_templates.lobby.lights)
	}
	self._scene_templates.lobby2 = {
		use_character_grab = false,
		lobby_characters_visible = true,
		hide_menu_logo = true,
		camera_pos = Vector3(-21.2779, -264.36, -56.7304),
		target_pos = Vector3(-21.2779, -264.36, -56.7304) + Vector3(-0.633319, 0.758269, 0.154709) * 100,
		fov = 30,
		lights = clone(self._scene_templates.lobby.lights)
	}
	self._scene_templates.lobby3 = {
		use_character_grab = false,
		lobby_characters_visible = true,
		hide_menu_logo = true,
		camera_pos = Vector3(149.695, -363.069, -110.613),
		target_pos = Vector3(149.695, -363.069, -110.613) + Vector3(-0.648856, 0.748553, 0.136579) * 100,
		fov = 30,
		lights = clone(self._scene_templates.lobby.lights)
	}
	self._scene_templates.lobby4 = {
		use_character_grab = false,
		lobby_characters_visible = true,
		hide_menu_logo = true,
		camera_pos = Vector3(210.949, -449.61, -126.709),
		target_pos = Vector3(210.949, -449.61, -126.709) + Vector3(-0.668524, 0.734205, 0.118403) * 100,
		fov = 30,
		lights = clone(self._scene_templates.lobby.lights)
	}
	self._scene_templates.blackmarket_customize = {
		fov = 40,
		use_item_grab = true,
		disable_rotate = true,
		disable_item_updates = true,
		can_change_fov = true,
		can_move_item = true,
		hide_menu_logo = true,
		change_fov_sensitivity = 2,
		camera_pos = Vector3(1500, -2000, 0)
	}
	self._scene_templates.crime_spree_lobby = {
		use_character_grab = false,
		camera_pos = offset:rotate_with(Rotation(90)),
		target_pos = target_pos,
		character_pos = c_ref:position() + Vector3(0, 500, 0),
		lobby_characters_visible = true,
		fov = 40,
		hide_menu_logo = true,
		lights = {
			self:_create_light({
				far_range = 300,
				color = Vector3(0.86, 0.57, 0.31) * 3,
				position = Vector3(56, 100, -10)
			}),
			self:_create_light({
				far_range = 3000,
				specular_multiplier = 6,
				color = Vector3(1, 2.5, 4.5) * 3,
				position = Vector3(-1000, -300, 800)
			}),
			self:_create_light({
				far_range = 800,
				specular_multiplier = 0,
				color = Vector3(1, 1, 1) * 0.35,
				position = Vector3(300, 100, 0)
			})
		}
	}
	self._scene_templates.crew_management = {
		use_character_grab = false,
		hide_menu_logo = true,
		camera_pos = offset:rotate_with(Rotation(90)),
		target_pos = target_pos,
		character_pos = c_ref:position() + Vector3(0, 500, 0),
		character_visible = false,
		lobby_characters_visible = false,
		henchmen_characters_visible = true,
		fov = 40,
		lights = {
			self:_create_light({
				far_range = 300,
				color = Vector3(0.86, 0.57, 0.31) * 3,
				position = Vector3(56, 100, -10)
			}),
			self:_create_light({
				far_range = 3000,
				specular_multiplier = 6,
				color = Vector3(1, 2.5, 4.5) * 3,
				position = Vector3(-1000, -300, 800)
			}),
			self:_create_light({
				far_range = 800,
				specular_multiplier = 0,
				color = Vector3(1, 1, 1) * 0.35,
				position = Vector3(300, 100, 0)
			})
		}
	}
	self._scene_templates.raid_menu = {
		use_character_grab = false,
		camera_pos = offset:rotate_with(Rotation(90)),
		target_pos = target_pos,
		character_pos = c_ref:position() + Vector3(0, 500, 0),
		character_visible = false,
		hide_menu_logo = true,
		lobby_characters_visible = false,
		henchmen_characters_visible = true,
		fov = 40,
		lights = {
			self:_create_light({
				far_range = 300,
				color = Vector3(0.86, 0.57, 0.31) * 3,
				position = Vector3(56, 100, -10)
			}),
			self:_create_light({
				far_range = 3000,
				specular_multiplier = 6,
				color = Vector3(1, 2.5, 4.5) * 3,
				position = Vector3(-1000, -300, 800)
			}),
			self:_create_light({
				far_range = 800,
				specular_multiplier = 0,
				color = Vector3(1, 1, 1) * 0.35,
				position = Vector3(300, 100, 0)
			})
		}
	}
	self._scene_templates.movie_theater = {
		use_character_grab = false,
		hide_menu_logo = true,
		camera_pos = offset:rotate_with(Rotation(90)),
		target_pos = target_pos,
		character_visible = false,
		lobby_characters_visible = false,
		fov = 40
	}
end)

function MenuSceneManager:_setup_bg()
	local yaw = 180
		--This element must never be removed.
	self._bg_unit = World:spawn_unit(Idstring("units/menu/menu_scene/menu_cylinder"), Vector3(0, 0, 0), Rotation(yaw, 0, 0))


		--Background pattern & smoke FX.  Smoke is 3 different scrolling planes, pattern is 1.  smokecylinder1 is lowest poly and without the other FX, very evident.
	--World:spawn_unit(Idstring("units/menu/menu_scene/menu_cylinder_pattern"), Vector3(0, 0, 0), Rotation(yaw, 0, 0))
	--World:spawn_unit(Idstring("units/menu/menu_scene/menu_smokecylinder1"), Vector3(0, 0, 0), Rotation(yaw, 0, 0))
	--World:spawn_unit(Idstring("units/menu/menu_scene/menu_smokecylinder2"), Vector3(0, 0, 0), Rotation(yaw, 0, 0))
	--World:spawn_unit(Idstring("units/menu/menu_scene/menu_smokecylinder3"), Vector3(0, 0, 0), Rotation(yaw, 0, 0))


		--Menu logo.
	self._menu_logo = World:spawn_unit(Idstring("units/menu/menu_scene/menu_logo"), Vector3(97, -200, -51), Rotation(yaw, 0, 0))


	self:set_character(managers.blackmarket:get_preferred_character())
		
		local e_money = self._bg_unit:effect_spawner(Idstring("e_money"))

		if e_money then
			e_money:set_enabled(false)
		end	
	--Proof of concept, should add more later. 
	if Month == "12" and heat.Options:GetValue("Holiday") then	
		local a = self._bg_unit:get_object(Idstring("a_reference"))
		self._xmas_tree = World:spawn_unit(Idstring("units/pd2_dlc2/props/com_props_christmas_tree_sc/com_prop_christmas_tree_sc"), a:position() + Vector3(-150, 250, -50), Rotation(-45 + (math.random(2) - 1) * 180, 0, 0))
		self._snow_pile = World:spawn_unit(Idstring("units/pd2_dlc_cane/props/cne_prop_snow_pile_01_sc/cne_prop_snow_pile_01_sc"), a:position() + Vector3(-35, 275, -75), Rotation(305, 0, 0))	
	end
		
	self:_setup_lobby_characters()
	self:_setup_henchmen_characters()
end

function MenuSceneManager:_set_up_environments()
	self._environments = {
		standard = {}
	}
	self._environments.standard.environment = "environments/env_menu/env_menu"
	self._environments.standard.color_grading = "color_off"
	self._environments.standard.angle = 0
	self._environments.safe = {
		environment = "environments/env_menu/env_menu",
		color_grading = "color_off",
		angle = -135
	}
	self._environments.crafting = {
		environment = "environments/env_menu/env_menu",
		color_grading = "color_off",
		angle = -135
	}
end


end
