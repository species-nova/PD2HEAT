TeamAIMovement.update = TeamAIMovement.super.update

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
		if objective then
			if objective.type == "revive" then
				if managers.player:is_custom_cooldown_not_active("team", "crew_inspire") then
					return
				end
			end
		end
	end
	return old_throw(self, ...)
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
