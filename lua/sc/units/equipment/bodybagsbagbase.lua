local ids_base = Idstring("base")

function BodyBagsBagBase:server_set_dynamic()
	local my_unit = self._unit
	my_unit:set_extension_update_enabled(ids_base, false)

	self:_set_dynamic()

	local session = managers.network:session()

	if not session then
		return
	end

	session:send_to_peers_synched("sync_unit_event_id_16", my_unit, "base", 2)
end

function BodyBagsBagBase:take_bodybag(unit)
	if self._empty then
		return
	end

	local taken_amount = 0

	if self:_can_take_bodybag() then
		unit:sound():play("pickup_ammo")

		local pl_manager = managers.player

		taken_amount = pl_manager:max_body_bags() - pl_manager:get_body_bags_amount()
		pl_manager:add_body_bags_amount(taken_amount)

		managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", 1)

		self._bodybag_amount = self._bodybag_amount - 1

		if Network:is_server() then
			managers.mission:call_global_event("player_refill_bodybagsbag")
		end

		self:_set_visual_stage()

		if self._bodybag_amount <= 0 then
			self:_set_empty()
		end
	end

	return taken_amount
end

function BodyBagsBagBase:sync_bodybag_taken(amount)
	self._bodybag_amount = self._bodybag_amount - amount

	if Network:is_server() then
		managers.mission:call_global_event("player_refill_bodybagsbag")
	end

	self:_set_visual_stage()

	if self._bodybag_amount <= 0 then
		self:_set_empty()
	end
end

function BodyBagsBagBase:_set_empty()
	self._empty = true

	local my_unit = self._unit

	if Network:is_server() then
		my_unit:set_slot(0)
	else
		my_unit:set_visible(false)
		my_unit:interaction():set_active(false)
	end
end
