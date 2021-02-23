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

		pl_manager:add_grenade_amount(taken_amount)

		local send_f = session.send_to_peers_synched
		local register_grenade_func = pl_manager.register_grenade
		local my_unit = self._unit

		send_f(session, "sync_unit_event_id_16", my_unit, "base", 1)
		register_grenade_func(pl_manager, local_peer_id)

		for i = 1, taken_amount - 1 do
			send_f(session, "sync_unit_event_id_16", my_unit, "base", 3)

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

local sync_net_event_original = GrenadeCrateBase.sync_net_event
function GrenadeCrateBase:sync_net_event(event_id, peer)
	if event_id == 3 then
		if peer then
			managers.player:register_grenade(peer:id())
		end

		return
	end

	sync_net_event_original(self, event_id, peer)
end
