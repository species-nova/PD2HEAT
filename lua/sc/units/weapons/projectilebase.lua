--Remove time cheat to allow for free editing of projectile rof with minimal hassle.
function ProjectileBase.check_time_cheat(projectile_type, owner_peer_id)
	return true
end

function ProjectileBase:create_sweep_data()
	local sweep_slot_mask = self._slot_mask
	local game_settings = Global.game_settings

	if game_settings and game_settings.one_down then
		sweep_slot_mask = sweep_slot_mask + 3 --Enable friendly fire via sweep data slot mask on pro job.
	else
		sweep_slot_mask = managers.mutators:modify_value("ProjectileBase:create_sweep_data:slot_mask", sweep_slot_mask)
		sweep_slot_mask = managers.modifiers:modify_value("ProjectileBase:create_sweep_data:slot_mask", sweep_slot_mask)
	end

	self._sweep_data = {
		slot_mask = sweep_slot_mask,
		current_pos = self._unit:position(),
		last_pos = mvector3.copy(self._unit:position())
	}
end