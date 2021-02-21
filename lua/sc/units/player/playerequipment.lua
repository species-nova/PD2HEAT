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

function PlayerEquipment:valid_shape_placement(equipment_id, equipment_data)
	local unit = self._unit
	local mov_ext = unit:movement()

	local from = mov_ext:m_head_pos()
	local head_rot = mov_ext:m_head_rot()
	local to = from + head_rot:y() * 220

	local ray = unit:raycast("ray", from, to, "slot_mask", managers.slot:get_mask("trip_mine_placeables"), "ray_type", "equipment_placement")
	local valid = ray and true or false

	local dummy_unit = self._dummy_unit
	local dummy_pos, dummy_rot = nil

	if ray then
		dummy_pos = ray.position

		local rot_mod = rot_mods[equipment_id]
		dummy_rot = rot_mod and Rotation(head_rot:yaw() + rot_mod, 0, 0) or Rotation(head_rot:yaw(), 0, 0)

		valid = math_dot(ray.normal, math_up) > 0.25

		if valid then
			if alive_g(dummy_unit) then
				dummy_unit:set_position(dummy_pos)
				dummy_unit:set_rotation(dummy_rot)
			else
				dummy_unit = world_g:spawn_unit(idstr_func(equipment_data.dummy_unit), dummy_pos, dummy_rot)

				self:_disable_contour(dummy_unit)
			end

			local find_params = custom_find_params[equipment_id] or {30, 40, 17}
			local find_start_pos = dummy_pos + math_up * find_params[1]
			local find_end_pos = dummy_pos + math_up * find_params[2]
			local find_radius = find_params[3]

			local bodies = dummy_unit:find_bodies("intersect", "capsule", find_start_pos, find_end_pos, find_radius, managers.slot:get_mask("trip_mine_placeables") + 14 + 25)

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
