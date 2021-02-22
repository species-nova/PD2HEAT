--local math_ceil = math.ceil
local math_up = math.UP
local math_dot = math.dot

local alive_g = alive
local world_g = World

local idstr_func = Idstring
local body_idstr = idstr_func("body")

local rot_mods = {
	armor_kit = 180,
	bodybags_bag = -90
}

local custom_find_params = {
	ammo_bag = {
		20,
		21,
		12
	},
	doctor_bag = {
		22,
		28,
		15
	}
}

function PlayerEquipment:valid_look_at_placement(equipment_data)
	local unit = self._unit
	local mov_ext = unit:movement()

	local from = mov_ext:m_head_pos()
	local head_rot = self:_m_deploy_rot()
	local to = from + head_rot:y() * 220

	local ray = unit:raycast("ray", from, to, "slot_mask", managers.slot:get_mask("trip_mine_placeables"), "ray_type", "equipment_placement")
	local dummy_unit = self._dummy_unit

	if ray then
		local equipment_dummy = equipment_data and equipment_data.dummy_unit

		if equipment_dummy then
			local dummy_pos = ray.position
			local dummy_rot = Rotation(ray.normal, math_up)

			if alive_g(dummy_unit) then
				dummy_unit:set_position(dummy_pos)
				dummy_unit:set_rotation(dummy_rot)
			else
				dummy_unit = world_g:spawn_unit(idstr_func(equipment_dummy), dummy_pos, dummy_rot)

				self:_disable_contour(dummy_unit)
			end
		end
	end

	if alive_g(dummy_unit) then
		local vis_state = ray and true or false

		dummy_unit:set_visible(vis_state)
	end

	self._dummy_unit = dummy_unit

	return ray
end

function PlayerEquipment:valid_placement(equipment_data)
	local unit = self._unit
	local mov_ext = unit:movement()

	local valid = not mov_ext:current_state():in_air()
	local dummy_unit = self._dummy_unit

	if valid then
		local equipment_dummy = equipment_data and equipment_data.dummy_unit

		if equipment_dummy then
			local dummy_pos = mov_ext:m_pos()
			local dummy_rot = Rotation(self:_m_deploy_rot():yaw(), 0, 0)

			if alive_g(dummy_unit) then
				dummy_unit:set_position(dummy_pos)
				dummy_unit:set_rotation(dummy_rot)
			else
				dummy_unit = world_g:spawn_unit(idstr_func(equipment_dummy), dummy_pos, dummy_rot)

				self:_disable_contour(dummy_unit)
			end
		end
	end

	if alive_g(dummy_unit) then
		dummy_unit:set_visible(valid)
	end

	self._dummy_unit = dummy_unit

	return valid
end

function PlayerEquipment:valid_shape_placement(equipment_id, equipment_data)
	local unit = self._unit
	local mov_ext = unit:movement()

	local from = mov_ext:m_head_pos()
	local head_rot = self:_m_deploy_rot()
	local to = from + head_rot:y() * 220

	local slotmask = managers.slot:get_mask("trip_mine_placeables")
	local ray = unit:raycast("ray", from, to, "slot_mask", slotmask, "ray_type", "equipment_placement")
	local valid = ray and true or false
	local dummy_unit = self._dummy_unit

	if ray then
		local dummy_pos = ray.position
		local rot_mod = rot_mods[equipment_id]
		local dummy_rot = rot_mod and Rotation(head_rot:yaw() + rot_mod, 0, 0) or Rotation(head_rot:yaw(), 0, 0)

		valid = math_dot(ray.normal, math_up) > 0.25

		if valid then
			if alive_g(dummy_unit) then
				dummy_unit:set_position(dummy_pos)
				dummy_unit:set_rotation(dummy_rot)
			else
				dummy_unit = world_g:spawn_unit(idstr_func(equipment_data.dummy_unit), dummy_pos, dummy_rot)

				--sadly the dummy units lack this extension (and probably the sequences, but I don't know really)
				--having both would allow showing upgraded versions of the equipment during deployment
				--[[local dummy_dmg = dummy_unit:damage()

				if dummy_dmg then
					if equipment_id == "ammo_bag" then
						local ammo_upgrade = managers.player:upgrade_value_nil("ammo_bag", "ammo_increase")

						if ammo_upgrade then
							local base_amount = tweak_data.upgrades.ammo_bag_base
							local amount = base_amount + ammo_upgrade
							local max_amount = base_amount + managers.player:upgrade_value_by_level("ammo_bag", "ammo_increase", 1)
							local percentage = amount / max_amount
							local state = "state_" .. math_ceil(percentage * 6)

							if dummy_dmg:has_sequence(state) then
								dummy_dmg:run_sequence_simple(state)
							end
						end
					elseif equipment_id == "doctor_bag" then
						local amount_upgrade = managers.player:upgrade_value_nil("doctor_bag", "amount_increase")

						if amount_upgrade then
							local base_amount = tweak_data.upgrades.doctor_bag_base
							local amount = base_amount + ammo_upgrade
							local max_amount = base_amount + managers.player:upgrade_value_by_level("doctor_bag", "amount_increase", 1)
							local percentage = amount / max_amount
							local state = "state_" .. math_ceil(percentage * 4)

							if dummy_dmg:has_sequence(state) then
								dummy_dmg:run_sequence_simple(state)
							end
						end
					elseif equipment_id == "sentry_gun" or equipment_id == "sentry_gun_silent" then
						if managers.player:has_category_upgrade("sentry_gun", "shield") and dummy_dmg:has_sequence("shield_on") then
							dummy_dmg:run_sequence_simple("shield_on")
						end
					end
				end]]

				self:_disable_contour(dummy_unit)
			end

			local find_params = custom_find_params[equipment_id] or {30, 40, 17}
			local find_start_pos = dummy_pos + math_up * find_params[1]
			local find_end_pos = dummy_pos + math_up * find_params[2]
			local find_radius = find_params[3]

			local bodies = dummy_unit:find_bodies(unit, "intersect", "capsule", find_start_pos, find_end_pos, find_radius, slotmask + 14 + 25)

			for i = 1, #bodies do
				local body = bodies[i]

				if body:has_ray_type(body_idstr) then
					valid = false

					break
				end
			end
		end
	end

	if alive_g(dummy_unit) then
		dummy_unit:set_visible(valid)
	end

	self._dummy_unit = dummy_unit

	return valid and ray
end

local Net = _G.LuaNetworking

--Grenade Case
function PlayerEquipment:use_armor_kit()
	local ray = self:valid_shape_placement("grenade_crate")

	if ray then
		PlayerStandard.say_line(self, "s01x_plu")
		managers.statistics:use_armor_bag()

		local pos = ray.position
		local rot = Rotation(self._unit:movement():m_head_rot():yaw() + 180, 0, 0)
		local amount_upgrade_lvl = 0

		if Network:is_client() then
			Net:SendToPeer(1, "PlaceGrenadeCrate", tostring(pos).."|"..tostring(rot).."|"..tostring(amount_upgrade_lvl))
		else
			GrenadeCrateBase.spawn(pos, rot, amount_upgrade_lvl, managers.network:session():local_peer():id())
		end

		return true
	end

	return false
end
