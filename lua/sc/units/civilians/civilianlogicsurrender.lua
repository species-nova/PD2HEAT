local orig_update_enemy_detection = CivilianLogicSurrender._update_enemy_detection
function CivilianLogicSurrender._update_enemy_detection(data, my_data, ...)
	orig_update_enemy_detection(data, my_data, ...)

	local sentry = CivilianLogicBase.check_sentry_suppression(data)
	if sentry then
		--Make the sentry force civvies down.
		my_data.inside_intimidate_aura = true
		my_data.submission_meter = my_data.submission_max
		CivilianLogicSurrender.on_intimidated(data, 1, sentry)
	end
end