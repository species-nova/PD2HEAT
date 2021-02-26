local mvec3_set = mvector3.set
local tmp_vec1 = Vector3()

local mrot_lookat = mrotation.set_look_at
local tmp_rot_1 = Rotation()

local math_up = math.UP

function TeamAIMovement:sync_reload_weapon(empty_reload, reload_speed_multiplier)
	local reload_action = {
		body_part = 3,
		type = "reload",
		idle_reload = empty_reload ~= 0 and empty_reload or nil
	}

	self:action_request(reload_action)
end

function TeamAIMovement:on_SPOOCed(enemy_unit, flying_strike)
	if self._unit:character_damage()._god_mode then
		return
	end

	if flying_strike then
		self._unit:brain():set_logic("surrender")
		self._unit:network():send("arrested")
		self._unit:character_damage():on_arrested()	
	else
		self._unit:character_damage():on_incapacitated()
	end

	return true
end

local old_throw = TeamAIMovement.throw_bag
function TeamAIMovement:throw_bag(...)
	local data = self._ext_brain._logic_data

	if data then
		local objective = data.objective

		if objective and objective.type == "revive" and managers.player:is_custom_cooldown_not_active("team", "crew_inspire") then
			return
		end
	end

	return old_throw(self, ...)
end

function TeamAIMovement:sync_throw_bag(carry_unit, target_unit)
	if not alive(target_unit) then
		return
	end

	local dynamic_bodies = {}
	local nr_bodies = carry_unit:num_bodies()

	for i = 0, nr_bodies - 1 do
		local body = carry_unit:body(i)

		if body:dynamic() then
			body:set_keyframed()

			dynamic_bodies[#dynamic_bodies + 1] = body
		end
	end

	call_on_next_update(function ()
		if not alive(carry_unit) or not alive(target_unit) or not alive(self._unit) then
			return
		end

		local spine_pos = Vector3()
		self._obj_spine:m_position(spine_pos)

		local target_pos = tmp_vec1
		local carry_rot = tmp_rot_1
		mvec3_set(target_pos, target_unit:movement():m_head_pos())

		local dir = target_pos - spine_pos
		mrot_lookat(carry_rot, dir, math_up)

		local set_z = dir:length() * 0.75
		target_pos = target_pos:with_z(target_pos.z + set_z)
		dir = target_pos - spine_pos

		carry_unit:set_position(spine_pos)
		carry_unit:set_velocity(Vector3(0, 0, 0))
		carry_unit:set_rotation(carry_rot)

		call_on_next_update(function ()
			if not alive(carry_unit) or not alive(target_unit) or not alive(self._unit) then
				return
			end

			for i = 1, #dynamic_bodies do
				local body = dynamic_bodies[i]

				body:set_dynamic()
			end

			call_on_next_update(function ()
				if not alive(carry_unit) or not alive(target_unit) or not alive(self._unit) then
					return
				end

				local throw_distance_multiplier = tweak_data.carry.types[tweak_data.carry[carry_unit:carry_data():carry_id()].type].throw_distance_multiplier

				carry_unit:push(tweak_data.ai_carry.throw_force, dir * throw_distance_multiplier)
			end)
		end)
	end)
end

function TeamAIMovement:set_should_stay(should_stay)
	if self._should_stay == should_stay then
		return
	end

	self._should_stay = should_stay

	if Network:is_server() then
		managers.network:session():send_to_peers_synched("sync_team_ai_stopped", self._unit, should_stay)
	end

	local panel = managers.criminals:character_data_by_unit(self._unit)

	if panel then
		managers.hud:set_ai_stopped(panel.panel_id, should_stay)
	end
end

function TeamAIMovement:chk_action_forbidden(action_type)
	--stay put orders are not supposed to affect clients
	if action_type == "walk" and self._should_stay and Network:is_server() then
		local objective = self._unit:brain():objective()

		if objective then
			if objective.forced or objective.type == "revive" then
				return false
			end
		end

		return true
	end

	return TeamAIMovement.super.chk_action_forbidden(self, action_type)
end

local math_random = math.random

TeamAIMovement.selected_weapons = {}

function TeamAIMovement:add_weapons()
	if Network:is_server() then
		local char_name = self._ext_base._tweak_table
		local loadout = managers.criminals:get_loadout_for(char_name)
		local crafted = managers.blackmarket:get_crafted_category_slot("primaries", loadout.primary_slot)

		if crafted then
			self._unit:inventory():add_unit_by_factory_blueprint(loadout.primary, false, false, crafted.blueprint, crafted.cosmetics)
		elseif loadout.primary then
			self._unit:inventory():add_unit_by_factory_name(loadout.primary, false, false, nil, "")
		else
			local weapon = self._ext_base:default_weapon_name("primary")

			if type(weapon) == "table" then
				local already_selected = TeamAIMovement.selected_weapons[char_name]

				if already_selected then
					weapon = already_selected
				else
					weapon = weapon[math_random(#weapon)]

					TeamAIMovement.selected_weapons[char_name] = weapon
				end
			end

			if weapon then
				self._unit:inventory():add_unit_by_factory_name(weapon, false, false, nil, "")
			end
		end

		local sec_weapon = self._ext_base:default_weapon_name("secondary")

		if type(sec_weapon) == "table" then
			local already_selected = TeamAIMovement.selected_weapons[char_name]

			if already_selected then
				sec_weapon = already_selected
			else
				sec_weapon = sec_weapon[math_random(#sec_weapon)]

				TeamAIMovement.selected_weapons[char_name] = sec_weapon
			end
		end

		if sec_weapon then
			self._unit:inventory():add_unit_by_factory_name(sec_weapon, false, false, nil, "")
		end
	else
		local weapon = self._ext_base:default_weapon_name("primary")

		if type(weapon) == "table" then
			weapon = weapon[math_random(#weapon)]
		end

		if weapon then
			self._unit:inventory():add_unit_by_factory_name(weapon, false, false, nil, "")
		end

		local sec_weapon = self._ext_base:default_weapon_name("secondary")

		if type(sec_weapon) == "table" then
			sec_weapon = sec_weapon[math_random(#sec_weapon)]
		end

		if sec_weapon then
			self._unit:inventory():add_unit_by_factory_name(sec_weapon, false, false, nil, "")
		end
	end
end