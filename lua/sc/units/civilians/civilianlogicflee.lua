function CivilianLogicFlee.on_rescue_SO_administered(ignore_this, data, receiver_unit)
	managers.groupai:state():on_civilian_try_freed()

	local my_data = data.internal_data
	my_data.rescuer = receiver_unit
	my_data.rescue_SO_id = nil

	receiver_unit:sound():say("cr1", true) --"We'll come to you!"

	managers.groupai:state():unregister_rescueable_hostage(data.key)
end