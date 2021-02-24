local math_ceil = math.ceil

local ids_base = Idstring("base")

function DoctorBagBase:server_set_dynamic()
	local my_unit = self._unit
	my_unit:set_extension_update_enabled(ids_base, false)

	self:_set_dynamic()

	local session = managers.network:session()

	if not session then
		return
	end

	session:send_to_peers_synched("sync_unit_event_id_16", my_unit, "base", 1)
end

function DoctorBagBase:take(unit)
	if self._empty then
		return
	end

	--Remove first aid damage reduction.

	local taken = self:_take(unit)

	if taken > 0 then
		unit:sound():play("pickup_ammo")
		managers.network:session():send_to_peers_synched("sync_doctor_bag_taken", self._unit, taken)

		if Network:is_server() then
			managers.mission:call_global_event("player_refill_doctorbag")
		end
	end

	if self._amount <= 0 then
		self:_set_empty()
	else
		self:_set_visual_stage()
	end

	return taken > 0
end

--Make Doctor's Bags only have up to 3 blood bags.
function DoctorBagBase:_set_visual_stage()
	local unit_dmg = self._unit:damage()

	if not unit_dmg then
		return
	end

	local percentage = self._amount / self._max_amount

	--*3 instead of *4
	local state = "state_" .. math_ceil(percentage * 3)

	if unit_dmg:has_sequence(state) then
		unit_dmg:run_sequence_simple(state)
	end
end

function DoctorBagBase:_set_empty()
	self._empty = true

	local my_unit = self._unit

	if Network:is_server() then
		my_unit:set_slot(0)
	else
		my_unit:set_visible(false)
		my_unit:interaction():set_active(false)
	end
end

function DoctorBagBase:sync_taken(amount)
	self._amount = self._amount - amount

	if Network:is_server() then
		managers.mission:call_global_event("player_refill_doctorbag")
	end

	if self._amount <= 0 then
		self:_set_empty()
	else
		self:_set_visual_stage()
	end
end
