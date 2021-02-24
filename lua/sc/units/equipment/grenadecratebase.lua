local ids_base = Idstring("base")

function GrenadeCrateBase:setup()
	self._grenade_amount = self._max_grenade_amount or tweak_data.upgrades.grenade_crate_base
	self._empty = false

	self:_set_visual_stage()

	if not Network:is_server() or not self._is_attachable then
		return
	end

	local my_unit = self._unit

	if not alive(my_unit:body("dynamic")) then
		return
	end

	local cur_pos = my_unit:position()
	local z_rot = my_unit:rotation():z()

	local from_pos = cur_pos + z_rot * 10
	local to_pos = cur_pos + z_rot * -10
	local ray = my_unit:raycast("ray", from_pos, to_pos, "slot_mask", managers.slot:get_mask("world_geometry"))

	if ray then
		self._attached_data = {
			body = ray.body,
			position = ray.body:position(),
			rotation = ray.body:rotation(),
			index = 1,
			max_index = 3
		}

		my_unit:set_extension_update_enabled(ids_base, true)
	end
end

function GrenadeCrateBase:server_set_dynamic()
	local my_unit = self._unit
	my_unit:set_extension_update_enabled(ids_base, false)

	self:_set_dynamic()

	local session = managers.network:session()

	if not session then
		return
	end

	session:send_to_peers_synched("sync_unit_event_id_16", my_unit, "base", 2)
end

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

		self:_set_visual_stage()

		if self._grenade_amount <= 0 then
			self:_set_empty()
		end
	end

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

function GrenadeCrateBase:_set_empty()
	self._empty = true

	local my_unit = self._unit

	if Network:is_server() then
		my_unit:set_slot(0)
	else
		my_unit:set_visible(false)
		my_unit:interaction():set_active(false)
	end
end
