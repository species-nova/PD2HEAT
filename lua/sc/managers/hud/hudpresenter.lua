local how_about_you_present_some_bitches = HUDPresenter._present_information

function HUDPresenter:_present_information(params)

	if params.event == "stinger_objectivecomplete" then
		params.event = nil
	end
	
	return how_about_you_present_some_bitches(self, params)
end