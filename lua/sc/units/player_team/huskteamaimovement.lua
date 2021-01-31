function HuskTeamAIMovement:sync_reload_weapon(empty_reload, reload_speed_multiplier)
	local reload_action = {
		body_part = 3,
		type = "reload",
		idle_reload = empty_reload ~= 0 and empty_reload or nil
	}

	self:action_request(reload_action)
end

function HuskTeamAIMovement:_switch_to_not_cool(...)
	HuskTeamAIMovement.super._switch_to_not_cool(self, ...)

	if self._unit:inventory():equipped_unit() then
		self._unit:inventory():_ensure_weapon_visibility()
	end
end
