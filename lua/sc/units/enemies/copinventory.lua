local alive_g = alive

function CopInventory:drop_weapon()
	local selection = self._available_selections[self._equipped_selection]
	local unit = selection and selection.unit

	if not alive_g(unit) then
		self._equipped_selection = nil

		return
	end

	local base_ext = unit:base()
	local second_gun = base_ext and base_ext._second_gun

	unit:unlink()

	local u_dmg = unit:damage()

	if u_dmg then
		u_dmg:run_sequence_simple("enable_body")
		managers.game_play_central:weapon_dropped(unit)
	end

	if alive_g(second_gun) then
		second_gun:unlink()

		local s_gun_u_dmg = second_gun:damage()

		if s_gun_u_dmg then
			s_gun_u_dmg:run_sequence_simple("enable_body")
			managers.game_play_central:weapon_dropped(second_gun)
		end
	end

	self._equipped_selection = nil

	self:_call_listeners("unequip")
end
