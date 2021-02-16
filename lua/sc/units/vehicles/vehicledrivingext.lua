function VehicleDrivingExt:on_drive_SO_failed(seat, unit)
	local so_data = seat.drive_SO_data

	if not so_data then
		return
	end

	if unit ~= so_data.unit then
		return
	end

	if alive(unit) then
		local mov_ext = unit:movement()

		mov_ext.vehicle_unit = nil
		mov_ext.vehicle_seat = nil
	end

	seat.drive_SO_data = nil

	self:_create_seat_SO(seat)
end

function VehicleDrivingExt:_unregister_drive_SO(seat)
	local so_data = seat.drive_SO_data

	if not so_data then
		return
	end

	seat.drive_SO_data = nil

	if so_data.SO_registered then
		managers.groupai:state():remove_special_objective(so_data.SO_id)
	end

	local bot_unit = so_data.unit

	if alive(bot_unit) then
		local mov_ext = bot_unit:movement()

		mov_ext.vehicle_unit = nil
		mov_ext.vehicle_seat = nil

		bot_unit:brain():set_objective(nil)
	end
end
