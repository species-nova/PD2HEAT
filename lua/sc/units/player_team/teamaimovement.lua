TeamAIMovement.selected_primaries = {}
TeamAIMovement.selected_secondaries = {}

local mvec3_set = mvector3.set
local tmp_vec1 = Vector3()

local mrot_lookat = mrotation.set_look_at
local tmp_rot_1 = Rotation()

local math_random = math.random
local math_up = math.UP

local type_g = type
local next_g = next

local clone_g = clone
local alive_g = alive
local call_on_next_update_g = call_on_next_update

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

function TeamAIMovement:add_weapons()
	local base_ext = self._ext_base
	local inv_ext = self._ext_inventory

	if not Network:is_server() then
		local weapon = base_ext:default_weapon_name("primary")

		if type_g(weapon) == "table" then
			weapon = weapon[1][1]
		end

		if weapon then
			inv_ext:add_unit_by_factory_name(weapon, false, false, nil, "")
		end

		local sec_weapon = base_ext:default_weapon_name("secondary")

		if type_g(sec_weapon) == "table" then
			sec_weapon = sec_weapon[1][1]
		end

		if sec_weapon and sec_weapon ~= weapon then
			inv_ext:add_unit_by_factory_name(sec_weapon, false, false, nil, "")
		end

		return
	end

	local char_name = base_ext._tweak_table
	local loadout = managers.criminals:get_loadout_for(char_name)
	local crafted = managers.blackmarket:get_crafted_category_slot("primaries", loadout.primary_slot)

	if crafted then
		inv_ext:add_unit_by_factory_blueprint(loadout.primary, false, false, crafted.blueprint, crafted.cosmetics)
	elseif loadout.primary then
		inv_ext:add_unit_by_factory_name(loadout.primary, false, false, nil, "")
	else
		local weapon = base_ext:default_weapon_name("primary")
		local blueprint, cosmetics = nil

		if type_g(weapon) == "table" then
			local already_selected = TeamAIMovement.selected_primaries[char_name]

			if already_selected then
				weapon = already_selected[1]
				blueprint = already_selected[2]
				cosmetics = already_selected[3]
			else
				weapon = weapon[math_random(#weapon)]

				blueprint = weapon.blueprint
				cosmetics = weapon.cosmetics
				weapon = weapon.factory_name

				if not blueprint or not next_g(blueprint) then
					blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(weapon)
				else
					local fm = managers.weapon_factory
					local modified_default = clone_g(fm:get_default_blueprint_by_factory_id(weapon))
					local part_data_f = fm._part_data

					for i = 1, #blueprint do
						local part_id = blueprint[i]
						local part_data = part_data_f(fm, part_id, weapon)

						if part_data then
							for idx = 1, #modified_default do
								local default_part_id = modified_default[idx]
								local default_part_data = part_data_f(fm, default_part_id, weapon)

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

				TeamAIMovement.selected_primaries[char_name] = {
					[1] = weapon,
					[2] = blueprint,
					[3] = cosmetics
				}
			end
		end

		if weapon then
			if blueprint then
				inv_ext:add_unit_by_factory_blueprint(weapon, false, false, blueprint, cosmetics)
			else
				inv_ext:add_unit_by_factory_name(weapon, false, false, nil, "")
			end
		end
	end

	local crafted_secondary = managers.blackmarket:get_crafted_category_slot("secondaries", loadout.secondary_slot)

	if crafted_secondary then
		inv_ext:add_unit_by_factory_blueprint(loadout.secondary, false, false, crafted_secondary.blueprint, crafted_secondary.cosmetics)
	elseif loadout.secondary then
		inv_ext:add_unit_by_factory_name(loadout.secondary, false, false, nil, "")
	else
		local sec_weapon = base_ext:default_weapon_name("secondary")
		local blueprint, cosmetics = nil

		if type_g(sec_weapon) == "table" then
			local already_selected = TeamAIMovement.selected_secondaries[char_name]

			if already_selected then
				sec_weapon = already_selected[1]
				blueprint = already_selected[2]
				cosmetics = already_selected[3]
			else
				sec_weapon = sec_weapon[math_random(#sec_weapon)]

				blueprint = sec_weapon.blueprint
				cosmetics = sec_weapon.cosmetics
				sec_weapon = sec_weapon.factory_name

				if not blueprint or not next_g(blueprint) then
					blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(sec_weapon)
				else
					local fm = managers.weapon_factory
					local modified_default = clone_g(fm:get_default_blueprint_by_factory_id(sec_weapon))
					local part_data_f = fm._part_data

					for i = 1, #blueprint do
						local part_id = blueprint[i]
						local part_data = part_data_f(fm, part_id, sec_weapon)

						if part_data then
							for idx = 1, #modified_default do
								local default_part_id = modified_default[idx]
								local default_part_data = part_data_f(fm, default_part_id, sec_weapon)

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

				TeamAIMovement.selected_secondaries[char_name] = {
					[1] = sec_weapon,
					[2] = blueprint,
					[3] = cosmetics
				}
			end
		end

		if sec_weapon ~= weapon then
			if blueprint then
				inv_ext:add_unit_by_factory_blueprint(sec_weapon, false, false, blueprint, cosmetics)
			else
				inv_ext:add_unit_by_factory_name(sec_weapon, false, false, nil, "")
			end
		end
	end
end

--use inherited functionality from CopMovement:pre_destroy() as this function is normally outdated
function TeamAIMovement:pre_destroy()
	TeamAIMovement.super.pre_destroy(self)

	if self._heat_listener_clbk then
		managers.groupai:state():remove_listener(self._heat_listener_clbk)

		self._heat_listener_clbk = nil
	end

	if self._switch_to_not_cool_clbk_id then
		managers.enemy:remove_delayed_clbk(self._switch_to_not_cool_clbk_id)

		self._switch_to_not_cool_clbk_id = nil
	end
end
