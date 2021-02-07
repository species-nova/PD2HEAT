local mvec3_set = mvector3.set
local tmp_vec1 = Vector3()

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

	local target_pos = tmp_vec1
	mvec3_set(target_pos, target_unit:movement():m_head_pos())

	local carry_pos = carry_unit:position()
	local dir = target_pos - carry_pos
	local set_z = dir:length() * 0.75
	target_pos = target_pos:with_z(target_pos.z + set_z)
	dir = target_pos - carry_pos

	local throw_distance_multiplier = tweak_data.carry.types[tweak_data.carry[carry_unit:carry_data():carry_id()].type].throw_distance_multiplier

	carry_unit:push(tweak_data.ai_carry.throw_force, (dir - carry_unit:velocity()) * throw_distance_multiplier)
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
