function JobManager:is_current_job_professional()
	if not self._global.current_job then
		return
	end
	
	if managers.crime_spree:is_active() then
		return
	end

	--Just to suffer--
	return Global.game_settings.one_down
end

function JobManager:check_ponr_active()
	if managers.groupai:state()._ponr_is_on and Global.game_settings.one_down and heat.Options:GetValue("PONRTrack") then
		return true
	end

	return false
end

function JobManager:current_job_and_difficulty_stars()
	local difficulty = Global.game_settings.difficulty or "easy"
	local difficulty_id = math.max(0, (tweak_data:difficulty_to_index(difficulty) or 0) - 2)

	return math.clamp(self:current_job_stars() + difficulty_id, 1, 13)
end

function JobManager:_check_add_heat_to_jobs(debug_job_id, ignore_debug_prints)
	if not self._global.heat then
		self:_setup_job_heat()
	end

	local current_job = debug_job_id or self:current_real_job_id()

	if not current_job then
		Application:error("[JobManager:_check_add_heat_to_jobs] No current job.")

		return
	end

	if current_job == "safehouse" or self:current_job_id() == "chill" then
		return
	end

	local current_job_heat = self._global.heat[current_job]

	if not current_job_heat then
		Application:error("[JobManager:_check_add_heat_to_jobs] Job have no heat. If this is safehouse, IGNORE ME!", current_job)

		return
	end

	local is_current_job_freezing = current_job_heat == -self.JOB_HEAT_MAX_VALUE

	if is_current_job_freezing and tweak_data.narrative.ABSOLUTE_ZERO_JOBS_HEATS_OTHERS == false then
		Application:debug("[JobManager:_check_add_heat_to_jobs] Current job is frozen, cant give heat to other jobs.", current_job)

		return
	end

	local job_tweak_data = tweak_data.narrative.jobs[current_job]

	if not job_tweak_data then
		Application:error("[JobManager:_check_add_heat_to_jobs] Current job do not exists in NarrativeTweakData.lua", current_job)

		return
	end

	local job_heat_data = job_tweak_data.heat

	if not job_heat_data and not ignore_debug_prints then
		-- Nothing
	end

	local plvl = managers.experience:current_level()
	local prank = managers.experience:current_rank()
	local all_jobs = {}

	for job_id, heat in pairs(self._global.heat) do
		local is_not_this_job = job_id ~= current_job
		local is_cooldown_ok = self:check_ok_with_cooldown(job_id)
		local is_not_wrapped = not job_tweak_data.wrapped_to_job
		local is_not_dlc_or_got = not job_tweak_data.dlc or managers.dlc:is_dlc_unlocked(job_tweak_data.dlc)
		local is_not_ignore_heat = not tweak_data.narrative.jobs[job_id].ignore_heat
		local pass_all_tests = is_cooldown_ok and is_not_wrapped and is_not_dlc_or_got and is_not_this_job and is_not_ignore_heat

		if pass_all_tests then
			table.insert(all_jobs, job_id)
		end
	end

	local other_jobs_ratio = math.clamp(math.round(tweak_data.narrative.HEAT_OTHER_JOBS_RATIO * #all_jobs), 0, #all_jobs)
	local heated_jobs = {}

	for i = 1, other_jobs_ratio do
		table.insert(heated_jobs, table.remove(all_jobs, math.random(#all_jobs)))
	end

	local cooling = job_heat_data and job_heat_data.this_job or tweak_data.narrative.DEFAULT_HEAT.this_job or 0
	local heating = job_heat_data and job_heat_data.other_jobs or tweak_data.narrative.DEFAULT_HEAT.other_jobs or 0
	local debug_current_job_heat = self._global.heat[current_job]
	local debug_other_jobs_heat = {}
	self._last_known_heat = self._global.heat[current_job]

	self:_change_job_heat(current_job, cooling, true)

	for _, job_id in ipairs(heated_jobs) do
		debug_other_jobs_heat[job_id] = self._global.heat[job_id]

		self:_change_job_heat(job_id, heating)
	end

	self:_chk_fill_heat_containers()

	if ignore_debug_prints then
		return
	end

	Application:debug("[JobManager:_check_add_heat_to_jobs] Heat:")
	print(tostring(current_job) .. ": " .. tostring(debug_current_job_heat) .. " -> " .. tostring(self._global.heat[current_job]))

	for job_id, old_heat in pairs(debug_other_jobs_heat) do
		print(tostring(job_id) .. ": " .. tostring(old_heat) .. " -> " .. tostring(self._global.heat[job_id]))
	end

	Application:debug("------------------------------------------")
end

--Plug in token system for dozers/captains.
function JobManager:current_spawn_limit(special_type)
	if not special_type then
		return math.huge
	end

	local level_data = self:current_level_data()
	local is_skirmish = level_data and level_data.group_ai_state == "skirmish"
	
	local tank_tokens = math.huge
	if special_type == "tank" or special_type == "tank_titan" or (not is_skirmish and special_type == "captain") then
		tank_tokens = managers.groupai:state():get_tank_tokens() --Groupai is better suited to handling tank tokens since it has an update function.
	end

	if is_skirmish then
		local limits_table = tweak_data.skirmish.special_unit_spawn_limits
		local wave_number = managers.groupai:state():get_assault_number()
		local limit_index = math.clamp(wave_number, 1, #limits_table)

		return math.min(tank_tokens, limits_table[limit_index][special_type]) or math.huge
	end

	return math.min(tank_tokens, tweak_data.group_ai.special_unit_spawn_limits[special_type] or math.huge)
end