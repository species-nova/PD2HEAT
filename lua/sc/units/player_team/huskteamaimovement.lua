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

function HuskTeamAIMovement:add_weapons()
	local weapon = self._ext_base:default_weapon_name("primary")

	if type(weapon) == "table" then
		weapon = weapon[1]
	end

	if weapon then
		self._unit:inventory():add_unit_by_factory_name(weapon, false, false, nil, "")
	end

	local sec_weapon = self._ext_base:default_weapon_name("secondary")

	if type(sec_weapon) == "table" then
		sec_weapon = sec_weapon[1]
	end

	if sec_weapon then
		self._unit:inventory():add_unit_by_factory_name(sec_weapon, false, false, nil, "")
	end
end
