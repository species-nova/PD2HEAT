function GrenadeCrateBase:take_grenade(unit)
	if self._empty then
		return
	end

	local taken_amount = 0

	if self:_can_take_grenade() then
		unit:sound():play("pickup_ammo")

		local session = managers.network:session()
		local local_peer_id = session:local_peer():id()
		local pl_manager = managers.player

		taken_amount = pl_manager:get_max_grenades_by_peer_id(local_peer_id) - pl_manager:get_grenade_amount(local_peer_id)

		pl_manager:add_grenade_amount(taken)

		local send_f = session.send_to_peers_synched
		local register_grenade_func = pl_manager.register_grenade
		local my_unit = self._unit

		for i = 1, taken do
			send_f(session, "sync_unit_event_id_16", my_unit, "base", 1)

			register_grenade_func(pl_manager, local_peer_id)
		end

		self._grenade_amount = self._grenade_amount - 1
	end

	if self._grenade_amount <= 0 then
		self:_set_empty()
	end

	self:_set_visual_stage()

	return taken_amount
end
