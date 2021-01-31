function CopInventory:drop_weapon()
	local selection = self._available_selections[self._equipped_selection]
	local unit = selection and selection.unit

	self._equipped_selection = nil

	if alive(unit) then
		unit:unlink()

		local u_dmg = unit:damage()

		if u_dmg then
			u_dmg:run_sequence_simple("enable_body")
			managers.game_play_central:weapon_dropped(unit)
		end

		local second_gun = unit:base() and alive(unit:base()._second_gun) and unit:base()._second_gun

		if second_gun then
			second_gun:unlink()

			local s_gun_u_dmg = unit:damage()

			if s_gun_u_dmg then
				s_gun_u_dmg:run_sequence_simple("enable_body")
				managers.game_play_central:weapon_dropped(second_gun)
			end
		end

		self:_call_listeners("unequip")
	end
end
