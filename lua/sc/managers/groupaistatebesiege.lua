local mvec3_dis_sq = mvector3.distance_sq
local mvec3_cpy = mvector3.copy
local math_lerp = math.lerp
local math_random = math.random
local math_clamp = math.clamp
local table_insert = table.insert
local table_remove = table.remove

function GroupAIStateBesiege:init(group_ai_state)
	GroupAIStateBesiege.super.init(self)

	if Network:is_server() and managers.navigation:is_data_ready() then
		self:_queue_police_upd_task()
	end

	self._tweak_data = tweak_data.group_ai[group_ai_state]
	self._spawn_group_timers = {}
	self._graph_distance_cache = {}
	self._ponr_is_on = nil
	--Sets functions that determine chatter for spawn group leaders to say upon spawning.
	self:_init_group_entry_lines()
	--self:set_debug_draw_state(true) --Uncomment to debug AI stuff.
end	

function GroupAIStateBesiege:_queue_police_upd_task()
	if not self._police_upd_task_queued then
		self._police_upd_task_queued = true

		managers.enemy:queue_task("GroupAIStateBesiege._upd_police_activity", self._upd_police_activity, self, self._t, nil, true) --please dont let your own algorithms implode like that, ovk, thanks
	end
end

local difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
local difficulty_index = tweak_data:difficulty_to_index(difficulty)

--Implements cooldowns and hard-diff filters for specific spawn groups, by prefiltering them before actually choosing the best groups.
local group_timestamps = {}
local _choose_best_groups_actual = GroupAIStateBesiege._choose_best_groups
function GroupAIStateBesiege:_choose_best_groups(best_groups, group, group_types, allowed_groups, weight, ...)
	local new_allowed_groups = {} --Replacement table for _choose_best_groups_actual.
	local currenttime = self._t
	local sustain = self._task_data.assault and self._task_data.assault.phase == "sustain"
	local constraints_tweak = self._tweak_data.group_constraints

	--Check each spawn group and see if it meets filter.
	for group_type, cat_weights in pairs(allowed_groups) do
		--Get timestamp from when group was last spawned and make sure that cooldown is complete. 
		local constraints = constraints_tweak[group_type]
		local valid = true

		--If group had constraints tied to it, then check for them.
		if constraints then
			local cooldown = constraints.cooldown
			local previoustimestamp = group_timestamps[group_type]
			if cooldown and previoustimestamp and (currenttime - previoustimestamp) < cooldown then
				valid = nil
			end

			local min_diff = constraints.min_diff
			local max_diff = constraints.max_diff
			if (min_diff and self._difficulty_value <= min_diff) or (max_diff and self._difficulty_value >= max_diff) then
				valid = nil
			end

			local sustain_only = constraints.sustain_only
			if sustain_only and sustain == false then
				valid = nil
			end
		end

		--If all constraints are met, add it to the replacement table. Otherwise, ignore it.
		if valid then
			new_allowed_groups[group_type] = cat_weights
		end
	end

	-- Call the original function with the replacement spawngroup table.
	return _choose_best_groups_actual(self, best_groups, group, group_types, new_allowed_groups, weight, ...)
end

--Set timestamp for whatever spawngroup was just spawned in to allow for cooldown tracking.
local _spawn_in_group_actual = GroupAIStateBesiege._spawn_in_group
function GroupAIStateBesiege:_spawn_in_group(spawn_group, spawn_group_type, ...)
	group_timestamps[spawn_group_type] = self._t

	return _spawn_in_group_actual(self, spawn_group, spawn_group_type, ...)
end

-- Cache for normal spawngroups to avoid losing them when they're overwritten.
-- Once a captain is spawned in, this gets reset back to nil.
local cached_spawn_groups = nil
-- Hard forces the next spawn group type by temporarily replacing the assault.groups table.
-- When the group is spawned, the assault.groups table is reverted to cached_spawn_groups.
-- Used by skirmish to force captain spawns.
function GroupAIStateBesiege:force_spawn_group_hard(spawn_group)
	-- Ignore previous force attempt if ones overlap.
	-- Might change to using a LIFO queue if we need support for multiple nearby calls at some point.
	if cached_spawn_groups then
		self._tweak_data.assault.groups = cached_spawn_groups
		cached_spawn_groups = nil
	end

	--Create new forced spawngroup.
	local new_spawn_groups = nil
	if managers.skirmish:is_skirmish() then --Handle Skirmish's custom diff curve.
		new_spawn_groups = { [spawn_group] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1} }
	else
		new_spawn_groups = { [spawn_group] = {1, 1, 1} }
	end

	--Cache old spawn groups, and apply new forced spawn group table.
	cached_spawn_groups = self._tweak_data.assault.groups
	self._tweak_data.assault.groups = new_spawn_groups
end

local function make_dis_id(from, to)
	local f = from < to and from or to
	local t = to < from and from or to

	return tostring(f) .. "-" .. tostring(t)
end

local function spawn_group_id(spawn_group)
	return spawn_group.mission_element:id()
end

function GroupAIStateBesiege:_find_spawn_group_near_area(target_area, allowed_groups, target_pos, max_dis, verify_clbk)
	local all_areas = self._area_data
	
	max_dis = max_dis and max_dis * max_dis
	local min_dis = nil
	
	if fuck and not Global.game_settings.one_down then
		if managers.skirmish:is_skirmish() or self._small_map then
			min_dis = 2250000
		else
			min_dis = 4000000
		end
	end
	
	local t = self._t
	local valid_spawn_groups = {}
	local valid_spawn_group_distances = {}
	local total_dis = 0
	target_pos = target_pos or target_area.pos
	local to_search_areas = {
		target_area
	}
	local found_areas = {
		[target_area.id] = true
	}

	repeat
		local search_area = table_remove(to_search_areas, 1)
		local spawn_groups = search_area.spawn_groups

		if spawn_groups then
			for _, spawn_group in ipairs(spawn_groups) do
				if spawn_group.delay_t <= t and (not verify_clbk or verify_clbk(spawn_group)) then
					local dis_id = make_dis_id(spawn_group.nav_seg, target_area.pos_nav_seg)

					if not self._graph_distance_cache[dis_id] then
						local coarse_params = {
							access_pos = "swat",
							from_seg = spawn_group.nav_seg,
							to_seg = target_area.pos_nav_seg,
							id = dis_id
						}
						local path = managers.navigation:search_coarse(coarse_params)

						if path and #path >= 2 then
							local dis = 0
							local current = spawn_group.pos

							for i = 2, #path do
								local nxt = path[i][2]

								if current and nxt then
									dis = dis + mvec3_dis_sq(current, nxt)
								end

								current = nxt
							end

							self._graph_distance_cache[dis_id] = dis
						end
					end

					if self._graph_distance_cache[dis_id] then
						local my_dis = self._graph_distance_cache[dis_id]
						
						local should_add_spawngroup = true
						--log(tostring(my_dis))
						--log(tostring(min_dis))
						if min_dis and min_dis > my_dis then
							should_add_spawngroup = nil
							--log("piss")
						end
						
						if max_dis and my_dis > max_dis then
							should_add_spawngroup = nil
							--log("piss2")
						end
						
						if should_add_spawngroup then
							--log("confusion")
							total_dis = total_dis + my_dis
							valid_spawn_groups[spawn_group_id(spawn_group)] = spawn_group
							valid_spawn_group_distances[spawn_group_id(spawn_group)] = my_dis
						end	
					end
				end
			end
		end

		for other_area_id, other_area in pairs(all_areas) do
			if not found_areas[other_area_id] and other_area.neighbours[search_area.id] then
				table_insert(to_search_areas, other_area)

				found_areas[other_area_id] = true
			end
		end
	until #to_search_areas == 0

	local time = TimerManager:game():time()
	local spawn_group_number = #valid_spawn_groups
	
	if spawn_group_number and spawn_group_number > 1 then
		for id in pairs(valid_spawn_groups) do
			if self._spawn_group_timers[id] and time < self._spawn_group_timers[id] then
				valid_spawn_groups[id] = nil
				valid_spawn_group_distances[id] = nil
			end
		end
	end
	
	local delays = {15, 20}
	
	if spawn_group_number > 3 and spawn_group_number < 6 then
		delays = {10, 15}
	elseif spawn_group_number < 3 then
		delays = {5, 10}
	end
	
	if self._small_map then --higher delays on small maps
		delays[1] = delays[1] * 2
		delays[2] = delays[2] * 2
	end
	
	if Global.game_settings.one_down then --LET'S GIVE INTO PAAAAAAIN
		delays[1] = delays[1] * 0.5
		delays[2] = delays[2] * 0.5
	end

	if total_dis == 0 then
		total_dis = 1
	end

	local total_weight = 0
	local candidate_groups = {}
	self._debug_weights = {}
	local dis_limit = max_dis or 64000000 --80 meters
	
	for i, dis in pairs(valid_spawn_group_distances) do
		local my_wgt = math_lerp(1, 0.2, math.min(1, dis / dis_limit)) * 5
		local my_spawn_group = valid_spawn_groups[i]
		local my_group_types = my_spawn_group.mission_element:spawn_groups()
		my_spawn_group.distance = dis
		total_weight = total_weight + self:_choose_best_groups(candidate_groups, my_spawn_group, my_group_types, allowed_groups, my_wgt)
	end

	if total_weight == 0 then
		return
	end

	for _, group in ipairs(candidate_groups) do
		table_insert(self._debug_weights, clone(group))
	end

	return self:_choose_best_group(candidate_groups, total_weight, delays)
end

function GroupAIStateBesiege:_choose_best_group(best_groups, total_weight, delays)
	local rand_wgt = total_weight * math_random()
	local best_grp, best_grp_type = nil

	for i, candidate in ipairs(best_groups) do
		rand_wgt = rand_wgt - candidate.wght
		
		if rand_wgt <= 0 then
			if delays then
				self._spawn_group_timers[spawn_group_id(candidate.group)] = TimerManager:game():time() + math_lerp(delays[1], delays[2], math_random())
			end
			best_grp = candidate.group
			best_grp_type = candidate.group_type
			best_grp.delay_t = self._t + best_grp.interval

			break
		end
	end

	return best_grp, best_grp_type
end

function GroupAIStateBesiege:not_assault_0_check()
	if self._assault_number and self._assault_number <= 0 then
		return
	end
	
	return true
end

function GroupAIStateBesiege:_get_megaphone_sound_source()
	local level_id = Global.level_data.level_id
	local pos = nil

	if not level_id then
		pos = Vector3(0, 0, 0)

		Application:error("[TradeManager:_get_megaphone_sound_source] This level has no megaphone position!")
	elseif not tweak_data.levels[level_id].megaphone_pos then
		pos = Vector3(0, 0, 0)
	else
		pos = tweak_data.levels[level_id].megaphone_pos
	end

	local sound_source = SoundDevice:create_source("megaphone")

	sound_source:set_position(pos)

	return sound_source
end

function GroupAIStateBesiege:_check_spawn_phalanx()
	return
end

function GroupAIStateBesiege:chk_assault_active_atm()
	local assault_task = self._task_data.assault
	
	if assault_task and assault_task.phase == "build" or assault_task and assault_task.phase == "sustain" then
		return true
	end
	
	return
end

function GroupAIStateBesiege:is_detection_persistent()
	local assault_task = self._task_data.assault
	
	if assault_task and assault_task.phase == "build" or assault_task and assault_task.phase == "sustain" then
		return true
	end
	
	return
end

function GroupAIStateBesiege:get_hostage_count_for_chatter()
	
	if self._hostage_headcount > 0 then
		return self._hostage_headcount
	end
	
	return 0
end

function GroupAIStateBesiege:chk_has_civilian_hostages()
	if self._police_hostage_headcount and self._hostage_headcount > 0 then
		if self._hostage_headcount - self._police_hostage_headcount > 0 then
			return true
		end
	end
end

function GroupAIStateBesiege:chk_no_fighting_atm()

	if self._drama_data.amount > tweak_data.drama.consistentcombat then
		return
	end
	
	return true
end

function GroupAIStateBesiege:chk_had_hostages()
	return self._had_hostages
end

function GroupAIStateBesiege:chk_anticipation()
	local assault_task = self._task_data.assault
	
	if not assault_task.active or assault_task and assault_task.phase == "anticipation" then
		return true
	end
	
	return
end

function GroupAIStateBesiege:apply_grenade_cooldown(flash)

	if not self._task_data.assault then
		return
	end
	
	local task_data = self._task_data.assault
	local duration = tweak_data.group_ai.smoke_grenade_lifetime
	local cooldown = math_lerp(tweak_data.group_ai.smoke_and_flash_grenade_timeout[1], tweak_data.group_ai.smoke_and_flash_grenade_timeout[2], math_random())
	
	if flash then
		duration = 4
		cooldown = cooldown * 0.5
	end

	cooldown = cooldown + duration
	
	task_data.use_smoke_timer = self._t + cooldown
	task_data.use_smoke = nil
	
end


function GroupAIStateBesiege:_upd_assault_areas(current_area)
	local all_areas = self._area_data
	local nav_manager = managers.navigation
	local all_nav_segs = nav_manager._nav_segments
	local task_data = self._task_data
	local t = self._t
	
	local assault_candidates = {}
	local assault_data = task_data.assault

	local found_areas = {}
	local to_search_areas = {}

	for area_id, area in pairs(all_areas) do
		if area.spawn_points then
			for _, sp_data in pairs(area.spawn_points) do
				if sp_data.delay_t <= t and not all_nav_segs[sp_data.nav_seg].disabled then
					table_insert(to_search_areas, area)

					found_areas[area_id] = true

					break
				end
			end
		end

		if not found_areas[area_id] and area.spawn_groups then
			for _, sp_data in pairs(area.spawn_groups) do
				if sp_data.delay_t <= t and not all_nav_segs[sp_data.nav_seg].disabled then
					table_insert(to_search_areas, area)

					found_areas[area_id] = true

					break
				end
			end
		end
	end

	if #to_search_areas == 0 then
		return current_area
	end

	if assault_candidates and self._char_criminals then
		for criminal_key, criminal_data in pairs(self._char_criminals) do
			if criminal_key and not criminal_data.status then
				local nav_seg = criminal_data.tracker:nav_segment()
				local area = self:get_area_from_nav_seg_id(nav_seg)
				found_areas[area] = true
				
				for _, nbr in pairs(area.neighbours) do
					found_areas[nbr] = true
				end

				table_insert(assault_candidates, area)
			end
		end
	end

	local i = 1

	repeat
		local area = to_search_areas[i]
		local force_factor = area.factors.force
		local demand = force_factor and force_factor.force
		local nr_police = table.size(area.police.units)
		local nr_criminals = table.size(area.criminal.units)

		if assault_candidates and self._player_criminals then
			for criminal_key, _ in pairs(area.criminal.units) do
				if criminal_key and self._player_criminals[criminal_key] then
					if not self._player_criminals[criminal_key].is_deployable then
						table_insert(assault_candidates, area)

						break
					end
				end
			end
		end

		if nr_criminals == 0 then
			for neighbour_area_id, neighbour_area in pairs(area.neighbours) do
				if not found_areas[neighbour_area_id] then
					table_insert(to_search_areas, neighbour_area)

					found_areas[neighbour_area_id] = true
				end
			end
		end

		i = i + 1
	until i > #to_search_areas

	if assault_candidates and #assault_candidates > 0 then
		return assault_candidates
	end
	
end

function GroupAIStateBesiege:_begin_assault_task(assault_areas)
	local assault_task = self._task_data.assault
	assault_task.active = true
	assault_task.next_dispatch_t = nil
	assault_task.target_areas = assault_areas or self:_upd_assault_areas(nil)
	self._current_target_area = self._task_data.assault.target_areas[1]
	assault_task.phase = "anticipation"
	assault_task.start_t = self._t
	local anticipation_duration = self:_get_anticipation_duration(self._tweak_data.assault.anticipation_duration, assault_task.is_first)
	assault_task.is_first = nil
	assault_task.phase_end_t = self._t + anticipation_duration
	assault_task.force = math.ceil(self:_get_difficulty_dependent_value(self._tweak_data.assault.force) * self:_get_balancing_multiplier(self._tweak_data.assault.force_balance_mul))
	assault_task.use_smoke = true
	assault_task.use_smoke_timer = 0
	assault_task.use_spawn_event = true
	assault_task.force_spawned = 0

	if self._hostage_headcount > 0 then
		assault_task.phase_end_t = assault_task.phase_end_t + self:_get_difficulty_dependent_value(self._tweak_data.assault.hostage_hesitation_delay)
		assault_task.is_hesitating = true
		assault_task.voice_delay = self._t + (assault_task.phase_end_t - self._t) / 2
	end

	self._downs_during_assault = 0

	if self._hunt_mode then
		assault_task.phase_end_t = 0
	else
		managers.hud:setup_anticipation(anticipation_duration)
		managers.hud:start_anticipation()
	end

	if self._draw_drama then
		table_insert(self._draw_drama.assault_hist, {
			self._t
		})
	end

	self._task_data.recon.tasks = {}
end

--Generate table used to find spawn-in voicelines.
function GroupAIStateBesiege:_init_group_entry_lines()
	local function random_cs()
		local randomgroupcallout = math.random(1, 100)
		if randomgroupcallout < 25 then
			return "csalpha"
		elseif randomgroupcallout < 50 then
			return "csbravo"
		elseif randomgroupcallout < 75 then
			return "cscharlie"
		else
			return "csdelta"
		end
	end

	local function random_hrt()
		local randomgroupcallout = math.random(1, 100)
		if randomgroupcallout < 25 then
			return "hrtalpha"
		elseif randomgroupcallout < 50 then
			return "hrtbravo"
		elseif randomgroupcallout < 75 then
			return "hrtcharlie"
		else
			return "hrtdelta"
		end
	end

	--Metatable to handle more complex rng selections.
	self._group_entry_line_selectors = setmetatable(
		{
			groupcs1 = "csalpha",
			groupcs2 = "csbravo",
			groupcs3 = "cscharlie",
			groupcs4 = "csdelta",
			grouphrt1 = "hrtalpha",
			grouphrt2 = "hrtbravo",
			grouphrt3 = "hrtcharlie",
			grouphrt4 = "hrtdelta"
		},{
			__index = function(table, key)
				if key == "groupcsr" then
					return random_cs()
				elseif key == "grouphrtr" then
					return random_hrt()
				elseif key == "groupany" then
					if self._task_data.assault.active then
						random_cs()
					else
						random_hrt()
					end
				else
					return rawget(table, key)
				end
			end
		}
	)
end

--Plays spawn in chatter.
--Refers to the _group_entry_line_selectors to determine what exactly to play.
function GroupAIStateBesiege:_voice_groupentry(group)
	local group_leader_u_key, group_leader_u_data = self._determine_group_leader(group.units)

	if group_leader_u_data and group_leader_u_data.tactics and group_leader_u_data.char_tweak.chatter.entry then
		for i_tactic, tactic_name in ipairs(group_leader_u_data.tactics) do
			local selection = self._group_entry_line_selectors[tactic_name]
			if selection then
				self:chk_say_enemy_chatter(group_leader_u_data.unit, group_leader_u_data.m_pos, selection)
			end
		end
	end
end

function GroupAIStateBesiege:set_damage_reduction_buff_hud()
end

function GroupAIStateBesiege:is_smoke_grenade_active() --this functions differently, check for if use_smoke IS a thing instead
	if not self._task_data.assault.use_smoke then
		return
	end
	
	return self._task_data.assault.use_smoke
end


function GroupAIStateBesiege:_chk_group_use_smoke_grenade(group, task_data, detonate_pos)
	
	
	if task_data.use_smoke and not self:is_smoke_grenade_active() then
		local shooter_pos, shooter_u_data = nil
		local duration = tweak_data.group_ai.smoke_grenade_lifetime

		for u_key, u_data in pairs(group.units) do
			if u_data.tactics_map and u_data.tactics_map.smoke_grenade then
				if not detonate_pos then
					local nav_seg_id = u_data.tracker:nav_segment()
					local nav_seg = managers.navigation._nav_segments[nav_seg_id]
					if u_data.group and u_data.group.objective and u_data.group.objective.area and u_data.group.objective.type == "assault_area" or u_data.group and u_data.group.objective and u_data.group.objective.area and u_data.group.objective.type == "retire" then
						detonate_pos = mvec3_cpy(u_data.group.objective.area.pos)
					else
						for neighbour_nav_seg_id, door_list in pairs(nav_seg.neighbours) do
							if self._current_target_area and self._current_target_area.nav_segs[neighbour_nav_seg_id] then
								local random_door_id = door_list[math_random(#door_list)]

								if type(random_door_id) == "number" then
									detonate_pos = managers.navigation._room_doors[random_door_id].center
								else
									detonate_pos = random_door_id:script_data().element:nav_link_end_pos()
								end

								break
							end
						end
					end
				end

				if detonate_pos and shooter_u_data then
					self:detonate_smoke_grenade(detonate_pos, shooter_pos, duration, false)

					task_data.use_smoke_timer = self._t + math_lerp(tweak_data.group_ai.smoke_and_flash_grenade_timeout[1], tweak_data.group_ai.smoke_and_flash_grenade_timeout[2], math.rand(0, 1) ^ 0.5)
					task_data.use_smoke = false

					u_data.unit:sound():say("d01", true)
					u_data.unit:movement():play_redirect("throw_grenade")

					return true
				end
			end
		end
	end
end

function GroupAIStateBesiege:_chk_group_use_flash_grenade(group, task_data, detonate_pos)
	if task_data.use_smoke and not self:is_smoke_grenade_active() then
		local shooter_pos, shooter_u_data = nil
		local duration = tweak_data.group_ai.flash_grenade_lifetime

		for u_key, u_data in pairs(group.units) do
			if u_data.tactics_map and u_data.tactics_map.flash_grenade then
				if not detonate_pos then
					local nav_seg_id = u_data.tracker:nav_segment()
					local nav_seg = managers.navigation._nav_segments[nav_seg_id]
					if u_data.group and u_data.group.objective and u_data.group.objective.area and u_data.group.objective.type == "assault_area" then
						detonate_pos = mvec3_cpy(u_data.group.objective.area.pos)
					else
						for neighbour_nav_seg_id, door_list in pairs(nav_seg.neighbours) do
							if self._current_target_area and self._current_target_area.nav_segs[neighbour_nav_seg_id] then
								local random_door_id = door_list[math_random(#door_list)]

								if type(random_door_id) == "number" then
									detonate_pos = managers.navigation._room_doors[random_door_id].center
								else
									detonate_pos = random_door_id:script_data().element:nav_link_end_pos()
								end

								break
							end
						end
					end
				end

				if detonate_pos and shooter_u_data then
					self:detonate_smoke_grenade(detonate_pos, shooter_pos, duration, true)

					task_data.use_smoke_timer = self._t + math_lerp(tweak_data.group_ai.smoke_and_flash_grenade_timeout[1], tweak_data.group_ai.smoke_and_flash_grenade_timeout[2], math_random() ^ 0.5)
					task_data.use_smoke = false

					u_data.unit:sound():say("d02", true)	
					u_data.unit:movement():play_redirect("throw_grenade")					

					return true
				end
			end
		end
	end
end

function GroupAIStateBesiege:_upd_assault_task()
	local task_data = self._task_data.assault
	if not task_data.active then
		return
	end
	local t = self._t
	--self:_assign_recon_groups_to_retire()
	local force_pool = self:_get_difficulty_dependent_value(self._tweak_data.assault.force_pool) * self:_get_balancing_multiplier(self._tweak_data.assault.force_pool_balance_mul)
	local task_spawn_allowance = force_pool - (self._hunt_mode and 0 or task_data.force_spawned)
	if task_data.phase == "anticipation" then
		if task_spawn_allowance <= 0 then
			task_data.phase = "fade"
			task_data.phase_end_t = t + self._tweak_data.assault.fade_duration
		elseif t > task_data.phase_end_t then
			self._assault_number = self._assault_number + 1
			self:_get_megaphone_sound_source():post_event("mga_generic_c")
			managers.mission:call_global_event("start_assault")
			managers.hud:start_assault(self._assault_number)
			managers.groupai:dispatch_event("start_assault", self._assault_number)
			self:_set_rescue_state(false)
			task_data.phase = "build"
			task_data.phase_end_t = self._t + self._tweak_data.assault.build_duration
			task_data.is_hesitating = nil
			self:set_assault_mode(true)
			managers.trade:set_trade_countdown(false)
		else
			managers.hud:check_anticipation_voice(task_data.phase_end_t - t)
			managers.hud:check_start_anticipation_music(task_data.phase_end_t - t)
			if task_data.is_hesitating and self._t > task_data.voice_delay then
				if 0 < self._hostage_headcount then
					local best_group
					for _, group in pairs(self._groups) do
						if not best_group or group.objective.type == "reenforce_area" then
							best_group = group
						elseif best_group.objective.type ~= "reenforce_area" and group.objective.type ~= "retire" then
							best_group = group
						end
					end
					if best_group and self:_voice_delay_assault(best_group) then
						task_data.is_hesitating = nil
					end
				else
					local best_group
					for _, group in pairs(self._groups) do
						if not best_group or group.objective.type == "reenforce_area" then
							best_group = group
						elseif best_group.objective.type ~= "reenforce_area" and group.objective.type ~= "retire" then
							best_group = group
						end
					end
					if best_group then
						self:_voice_dont_delay_assault(best_group)
			            self:_get_megaphone_sound_source():post_event("mga_hostage_assault_delay")
					end
					task_data.is_hesitating = nil
				end
			end
		end
	elseif task_data.phase == "build" then
		if task_spawn_allowance <= 0 then
			task_data.phase = "fade"
			task_data.phase_end_t = t + self._tweak_data.assault.fade_duration
		elseif t > task_data.phase_end_t then
			local sustain_duration = math_lerp(self:_get_difficulty_dependent_value(self._tweak_data.assault.sustain_duration_min), self:_get_difficulty_dependent_value(self._tweak_data.assault.sustain_duration_max), math_random()) * self:_get_balancing_multiplier(self._tweak_data.assault.sustain_duration_balance_mul)
			managers.modifiers:run_func("OnEnterSustainPhase", sustain_duration)
			task_data.phase = "sustain"
			task_data.phase_end_t = t + sustain_duration
		end
	elseif task_data.phase == "sustain" then
		local end_t = self:assault_phase_end_time()
		task_spawn_allowance = managers.modifiers:modify_value("GroupAIStateBesiege:SustainSpawnAllowance", task_spawn_allowance, force_pool)
		if task_spawn_allowance <= 0 then
			task_data.phase = "fade"
			local time = self._t
				self:_get_megaphone_sound_source():post_event("mga_generic_a")
				for group_id, group in pairs(self._groups) do
					  for u_key, u_data in pairs(group.units) do
					  local nav_seg_id = u_data.tracker:nav_segment()
					  local current_objective = group.objective
						  if current_objective.coarse_path then
							  if not u_data.unit:sound():speaking(time) then
								u_data.unit:sound():say("r01", true)
							end	
						end					   
					end	
				end		
			task_data.phase_end_t = t + self._tweak_data.assault.fade_duration
		elseif t > end_t and not self._hunt_mode then
			task_data.phase = "fade"						
			local time = self._t
				for group_id, group in pairs(self._groups) do
					  for u_key, u_data in pairs(group.units) do
					  local nav_seg_id = u_data.tracker:nav_segment()
					  local current_objective = group.objective
						  if current_objective.coarse_path then
							  if not u_data.unit:sound():speaking(time) then
								u_data.unit:sound():say("r01", true)
							end	
						end					   
					end	
				end		
			task_data.phase_end_t = t + self._tweak_data.assault.fade_duration
		end
	elseif not self._hunt_mode then
		if not task_data.said_retreat then
			task_data.said_retreat = true

			self:_police_announce_retreat()
			self:_get_megaphone_sound_source():post_event("mga_robbers_clever")

			for group_id, group in pairs(self._groups) do
				local current_objective = group.objective

				if current_objective and current_objective.coarse_path then
					for u_key, u_data in pairs(group.units) do
						if not u_data.unit:sound():speaking(t) then
							u_data.unit:sound():say("m01", true)
						end
					end
				end
			end
		end

		if task_data.force_end or task_data.phase_end_t < t then
			task_data.active = nil
			task_data.phase = nil
			task_data.said_retreat = nil
			task_data.force_end = nil
			local force_regroup = task_data.force_regroup
			task_data.force_regroup = nil
			self:_get_megaphone_sound_source():post_event("mga_leave")

			for group_id, group in pairs(self._groups) do
				local current_objective = group.objective

				if current_objective and current_objective.coarse_path then
					for u_key, u_data in pairs(group.units) do
						if not u_data.unit:sound():speaking(t) then
							u_data.unit:sound():say("m01", true)
						end
					end
				end
			end

			if self._draw_drama then
				self._draw_drama.assault_hist[#self._draw_drama.assault_hist][2] = t
			end

			managers.mission:call_global_event("end_assault")
			self:_begin_regroup_task(force_regroup)
			--add diff on assault end (game normally does this through mission scripts, we have to do it manually here)
			--log("assault over!!!")
			self:set_difficulty(nil, 0.3)
			return
		end
	end

	if self._drama_data.amount <= tweak_data.drama.low then
		for criminal_key, criminal_data in pairs(self._player_criminals) do
			self:criminal_spotted(criminal_data.unit)

			--[[for group_id, group in pairs(self._groups) do
				if group.objective.charge then
					for u_key, u_data in pairs(group.units) do
						u_data.unit:brain():clbk_group_member_attention_identified(nil, criminal_key)
					end
				end
			end]]
		end
	end

	local primary_target_area = nil
	
	if self._current_target_area then
		primary_target_area = self._current_target_area
	elseif self._task_data.assault.target_areas then
		self._current_target_area = self._task_data.assault.target_areas[1]
		primary_target_area = self._current_target_area
	end

	if not primary_target_area or not self._current_target_area or self:is_area_safe_assault(primary_target_area) or self._force_assault_end_t then
		self._task_data.assault.target_areas = self:_upd_assault_areas()
		
		if self._task_data.assault.target_areas then
			self._current_target_area = self._task_data.assault.target_areas[1]
			primary_target_area = self._current_target_area
		end
	end
	
	local nr_wanted = task_data.force - self:_count_police_force("assault")
	if task_data.phase == "anticipation" then
		nr_wanted = nr_wanted - 5
	end
	if nr_wanted > 0 and task_data.phase ~= "fade" then
		local used_event
		if task_data.use_spawn_event and task_data.phase ~= "anticipation" then
			task_data.use_spawn_event = false
			if self:_try_use_task_spawn_event(t, primary_target_area, "assault") then
				used_event = true
			end
		end
		if used_event or next(self._spawning_groups) then
		else
			local spawn_group, spawn_group_type = nil
			
			spawn_group, spawn_group_type = self:_find_spawn_group_near_area(primary_target_area, self._tweak_data.assault.groups, nil, nil, nil)
			
			if spawn_group then
				local grp_objective = {
					type = "assault_area",
					area = spawn_group.area,
					coarse_path = {
						{
							spawn_group.area.pos_nav_seg,
							spawn_group.area.pos
						}
					},
					attitude = "avoid",
					pose = "crouch",
					stance = "hos"
				}
				self:_spawn_in_group(spawn_group, spawn_group_type, grp_objective, task_data)

				if cached_spawn_groups then
					self._tweak_data.assault.groups = cached_spawn_groups
					cached_spawn_groups = nil
				end
			end
		end
	end
	
	if task_data.phase ~= "fade" and task_data.phase ~= "anticipation"  then
		if task_data.use_smoke_timer < t then
			task_data.use_smoke = true
		end
	end
	
	self:detonate_queued_smoke_grenades()
	
	self:_assign_enemy_groups_to_assault(task_data.phase)
end

function GroupAIStateBesiege:_upd_groups()
	for group_id, group in pairs(self._groups) do
		if group.has_spawned or group.objective and group.objective.type == "retire" then --make sure the group has fully spawned (or if its intent is to not even spawn) before giving the enemies objectives
			self:_verify_group_objective(group)

			for u_key, u_data in pairs(group.units) do
				local brain = u_data.unit:brain()
				local current_objective = brain:objective()
				local noobjordefaultorgrpobjchkandnoretry = not current_objective or current_objective.is_default or current_objective.grp_objective and current_objective.grp_objective ~= group.objective and not current_objective.grp_objective.no_retry
				local notfollowingorfollowingaliveunit = not group.objective.follow_unit or alive(group.objective.follow_unit)

				if noobjordefaultorgrpobjchkandnoretry and notfollowingorfollowingaliveunit then
					local objective = self._create_objective_from_group_objective(group.objective, u_data.unit)
					
					if objective then
						if brain:is_available_for_assignment(objective) then
							self:set_enemy_assigned(objective.area or group.objective.area, u_key)

							if objective.element then
								objective.element:clbk_objective_administered(u_data.unit)
							end

							u_data.unit:brain():set_objective(objective)
						end
					end
				end
			end
		end
	end
end


function GroupAIStateBesiege:_assign_enemy_groups_to_assault(phase)
	local bad_types = {
		recon_area = true,
		retire = true
	}

	for group_id, group in pairs(self._groups) do
		if group.has_spawned and not bad_types[group.objective.type] then
			if group.objective.moving_out then
				local done_moving = nil

				for u_key, u_data in pairs(group.units) do
					local objective = u_data.unit:brain():objective()

					if objective then
						if objective.grp_objective ~= group.objective then
							-- Nothing
						elseif not objective.in_place then
							done_moving = false
						elseif done_moving == nil then
							done_moving = true
						end
					end
				end

				if done_moving == true then
					group.objective.moving_out = nil
					group.in_place_t = self._t
					group.objective.moving_in = nil

					self:_voice_move_complete(group)
				end
			end

			if not group.objective.moving_in then
				self:_set_assault_objective_to_group(group, phase)
			end
		end
	end
end

function GroupAIStateBesiege:is_area_populated(area)
	for u_key, u_data in pairs(self._police) do
		if not u_data.is_deployable and u_data.tactics_map and not u_data.tactics_map.flank and area.nav_segs[u_data.tracker:nav_segment()] then
			--log("violator")
			return
		end
	end
	
	--log("we got it")

	return true
end

function GroupAIStateBesiege:is_area_populated_and_safe(area)
	for u_key, u_data in pairs(self._police) do
		if not u_data.is_deployable and u_data.tactics_map and not u_data.tactics_map.flank and area.nav_segs[u_data.tracker:nav_segment()] then
			return
		end
	end
	
	for u_key, u_data in pairs(self._criminals) do
		if area.nav_segs[u_data.tracker:nav_segment()] then
			return
		end
	end

	return true
end

function GroupAIStateBase:is_nav_seg_populated(nav_seg)
	local area = self:get_area_from_nav_seg_id(nav_seg)

	return self:is_area_populated(area)
end

function GroupAIStateBase:is_nav_seg_populated_and_safe(nav_seg)
	local area = self:get_area_from_nav_seg_id(nav_seg)

	return self:is_area_populated_and_safe(area)
end

function GroupAIStateBase:is_area_flank_route(area)	
	for u_key, u_data in pairs(self._police) do
		if not u_data.is_deployable and u_data.tactics_map and u_data.tactics_map.flank and area.nav_segs[u_data.tracker:nav_segment()] then
			return
		end
	end

	return true
end

function GroupAIStateBase:is_area_safe_charge(area)
	for u_key, u_data in pairs(self._criminals) do
		if not u_data.is_deployable and area.nav_segs[u_data.tracker:nav_segment()] then
			return
		end
	end
	
	for u_key, u_data in pairs(self._police) do
		if not u_data.is_deployable and u_data.tactics_map and u_data.tactics_map.flank and area.nav_segs[u_data.tracker:nav_segment()] then
			return
		end
	end

	return true
end

function GroupAIStateBase:is_nav_seg_flank_route(nav_seg)
	local area = self:get_area_from_nav_seg_id(nav_seg)

	return self:is_area_flank_route(area)
end

function GroupAIStateBase:is_nav_seg_safe_charge(nav_seg)
	local area = self:get_area_from_nav_seg_id(nav_seg)

	return self:is_area_safe_charge(area)
end

function GroupAIStateBesiege:_set_assault_objective_to_group(group, phase)
	if not group.has_spawned then
		return
	end

	local phase_is_anticipation = phase == "anticipation"
	local current_objective = group.objective
	local approach, open_fire, push, pull_back, charge = nil
	local obstructed_area = self:_chk_group_areas_tresspassed(group)
	local group_leader_u_key, group_leader_u_data = self._determine_group_leader(group.units)
	local tactics_map = nil

	if group_leader_u_data and group_leader_u_data.tactics then
		tactics_map = {}

		for _, tactic_name in ipairs(group_leader_u_data.tactics) do
			tactics_map[tactic_name] = true
		end

		if current_objective.tactic and not tactics_map[current_objective.tactic] then
			current_objective.tactic = nil
		end

		for i_tactic, tactic_name in ipairs(group_leader_u_data.tactics) do
			if tactic_name == "hunter" and not phase_is_anticipation then
				local closest_crim_u_data, closest_crim_dis_sq = nil
				local crim_dis_sq_chk = not closest_crim_dis_sq or closest_crim_dis_sq > closest_u_dis_sq
				
				for u_key, u_data in pairs(self._char_criminals) do
					if u_data.unit then
						if not u_data.status or u_data.status == "electrified" then
							local players_nearby = managers.player:_chk_fellow_crimin_proximity(u_data.unit)
							local closest_u_id, closest_u_data, closest_u_dis_sq = self._get_closest_group_unit_to_pos(u_data.m_pos, group.units)
							if players_nearby and players_nearby <= 0 then
								if closest_u_dis_sq and crim_dis_sq_chk then
									closest_crim_u_data = u_data
									closest_crim_dis_sq = closest_u_dis_sq
								end
							end
						end
					end
				end
				
				if closest_crim_u_data then
					local search_params = {
						id = "GroupAI_hunter",
						from_tracker = group_leader_u_data.unit:movement():nav_tracker(),
						to_tracker = closest_crim_u_data.tracker,
						access_pos = self._get_group_acces_mask(group)
					}
					local coarse_path = managers.navigation:search_coarse(search_params)

					if coarse_path then
						local grp_objective = {
							distance = 400,
							type = "assault_area",
							attitude = "engage",
							tactic = "hunter",
							moving_in = true,
							follow_unit = closest_crim_u_data.unit,
							area = self:get_area_from_nav_seg_id(coarse_path[#coarse_path][1]),
							coarse_path = coarse_path
						}
						group.is_chasing = true

						self:_set_objective_to_enemy_group(group, grp_objective)

						return
					end
				end
			elseif tactic_name == "deathguard" and not phase_is_anticipation then
				if current_objective.tactic == tactic_name then
					for u_key, u_data in pairs(self._char_criminals) do
						if u_data.status and current_objective.follow_unit == u_data.unit then
							local crim_nav_seg = u_data.tracker:nav_segment()

							if current_objective.area.nav_segs[crim_nav_seg] then
								return
							end
						end
					end
				end

				local closest_crim_u_data, closest_crim_dis_sq = nil

				for u_key, u_data in pairs(self._char_criminals) do
					if u_data.status and u_data.status ~= "electrified" then
						local closest_u_id, closest_u_data, closest_u_dis_sq = self._get_closest_group_unit_to_pos(u_data.m_pos, group.units)

						if closest_u_dis_sq and (not closest_crim_dis_sq or closest_u_dis_sq < closest_crim_dis_sq) then
							closest_crim_u_data = u_data
							closest_crim_dis_sq = closest_u_dis_sq
						end
					end
				end

				if closest_crim_u_data then
					local search_params = {
						id = "GroupAI_deathguard",
						from_tracker = group_leader_u_data.unit:movement():nav_tracker(),
						to_tracker = closest_crim_u_data.tracker,
						access_pos = self._get_group_acces_mask(group)
					}
					local coarse_path = managers.navigation:search_coarse(search_params)

					if coarse_path then
						local grp_objective = {
							distance = 800,
							type = "assault_area",
							attitude = "engage",
							tactic = "deathguard",
							moving_in = true,
							follow_unit = closest_crim_u_data.unit,
							area = self:get_area_from_nav_seg_id(coarse_path[#coarse_path][1]),
							coarse_path = coarse_path
						}
						group.is_chasing = true

						self:_set_objective_to_enemy_group(group, grp_objective)
						self:_voice_deathguard_start(group)

						return
					end
				end
			elseif tactic_name == "charge" and not current_objective.moving_out and group.in_place_t then
				if self._t - group.in_place_t > 7 or self._t - group.in_place_t > 4 and next(current_objective.area.criminal.units) and group.is_chasing and not current_objective.charge then
					charge = true
				end
			end
		end
	end

	local objective_area = nil

	if obstructed_area then
		if current_objective.moving_out then
			if not current_objective.open_fire then
				open_fire = true
			end
		elseif not current_objective.pushed or charge and not current_objective.charge then
			push = true
		end
	else
		if not current_objective.moving_out then
			local has_criminals_close = nil

			if not current_objective.moving_out then
				for area_id, neighbour_area in pairs(current_objective.area.neighbours) do
					if next(neighbour_area.criminal.units) then
						has_criminals_close = true

						break
					end
				end
			end

			if charge then
				push = true
			elseif not has_criminals_close or not group.in_place_t then
				push = true
			elseif not phase_is_anticipation and not current_objective.open_fire then
				open_fire = true
			end
			
			if phase_is_anticipation then
				push = nil
				approach = true
			end
			
			if not charge or approach or open_fire then
				if phase_is_anticipation and current_objective.open_fire then
					pull_back = true
				elseif group.in_place_t then
					if group.is_chasing or not tactics_map or not tactics_map.ranged_fire and not tactics_map.elite_ranged_fire or self._t - group.in_place_t > 7 then
						push = true
					end
				end			
			end
		end
	end

	objective_area = objective_area or current_objective.area
	
	if tactics_map and tactics_map.flank then
		flank = true
		--log("ok cool")
	end

	if open_fire then
		local grp_objective = {
			attitude = "engage",
			pose = "stand",
			type = "assault_area",
			stance = "hos",
			open_fire = true,
			tactic = current_objective.tactic,
			area = obstructed_area or current_objective.area,
			coarse_path = {
				{
					objective_area.pos_nav_seg,
					mvector3.copy(current_objective.area.pos)
				}
			}
		}

		self:_set_objective_to_enemy_group(group, grp_objective)
		self:_voice_open_fire_start(group)
	elseif approach or push then
		local verify_clbk = nil
		local assault_area, alternate_assault_area, alternate_assault_area_from, assault_path, alternate_assault_path, area_to_go_to = nil
		
		if flank then
			verify_clbk = approach and callback(self, self, "is_nav_seg_populated_and_safe") or callback(self, self, "is_nav_seg_populated")
		else
			verify_clbk = approach and callback(self, self, "is_nav_seg_safe_charge") or callback(self, self, "is_nav_seg_flank_route")
		end
		
		local to_search_areas = {
			objective_area	
		}
		local found_areas = {
			[objective_area] = "init"
		}

		repeat
			local search_area = table.remove(to_search_areas, 1)

			if next(search_area.criminal.units) then
				local assault_from_here = true
				area_to_go_to = search_area
				
				if approach then
					for other_area_id, other_area in pairs(search_area.neighbours) do
						if self:is_area_safe_assault(other_area) then
							area_to_go_to = other_area
							break
						end
					end
				end
					
				
				--i COULD reformat this entire function in order to remove this stupid check and save a bit of performance...but meh
				if assault_from_here then
					local search_params = {
						id = "GroupAI_assault",
						from_seg = current_objective.area.pos_nav_seg,
						to_seg = area_to_go_to.pos_nav_seg,
						access_pos = self._get_group_acces_mask(group),
						verify_clbk = verify_clbk
					}
					assault_path = managers.navigation:search_coarse(search_params)

					if assault_path then
					
						--[[if flank then
							log("sex")
						else
							log("fucking!!!")
						end]]
						
						self:_merge_coarse_path_by_area(assault_path)

						assault_area = area_to_go_to

						break
					else
						if tactics_map and tactics_map.flank then 
							verify_clbk = approach and callback(self, self, "is_nav_seg_flank_route")
						else
							verify_clbk = approach and callback(self, self, "is_nav_seg_populated")
						end
						
						local search_params = { --approach failed possibly due to unsafe segs, change the check to simply check for crossing flank routes
							id = "GroupAI_assault",
							from_seg = current_objective.area.pos_nav_seg,
							to_seg = area_to_go_to.pos_nav_seg,
							access_pos = self._get_group_acces_mask(group),
							verify_clbk = verify_clbk
						}
						alternate_assault_path = managers.navigation:search_coarse(search_params)

						if approach and not alternate_assault_path then --dont run it twice for non-approach chargers, since that basically means the area is a dead end with other cops in it
							--[[if flank then
								--log("cock")
							else
								--log("motherforker")
							end]]
							
							local search_params = { 
								id = "GroupAI_assault",
								from_seg = current_objective.area.pos_nav_seg,
								to_seg = area_to_go_to.pos_nav_seg,
								access_pos = self._get_group_acces_mask(group)
							}
							alternate_assault_path = managers.navigation:search_coarse(search_params)
						end
						
						if alternate_assault_path then
							--[[if flank then
								log("augh")
							end
						
							log("nngh")]]
							self:_merge_coarse_path_by_area(alternate_assault_path)

							alternate_assault_area = search_area
							alternate_assault_area_from = assault_from_area
							
							break
						end
					end
				end
			else
				for other_area_id, other_area in pairs(search_area.neighbours) do
					if not found_areas[other_area] then
						table.insert(to_search_areas, other_area)

						found_areas[other_area] = search_area
					end
				end
			end
		until #to_search_areas == 0

		if not assault_area and alternate_assault_area then
			assault_area = alternate_assault_area
			found_areas[assault_area] = alternate_assault_area_from
			assault_path = alternate_assault_path
		end

		if assault_area and assault_path then
			if #assault_path > 2 and assault_area.nav_segs[assault_path[#assault_path - 1][1]] then
				table.remove(assault_path)
			end

			if push then				
				self:_voice_move_in_start(group)
			end

			local grp_objective = {
				type = "assault_area",
				stance = "hos",
				area = assault_area,
				coarse_path = assault_path,
				pose = push and "crouch" or "stand",
				attitude = push and "engage" or "avoid",
				moving_in = push and true or nil,
				open_fire = push or nil,
				pushed = push or nil,
				charge = charge,
				interrupt_dis = charge and 0 or nil
			}
			group.is_chasing = group.is_chasing or push

			self:_set_objective_to_enemy_group(group, grp_objective)
		end
	elseif pull_back then
		local retreat_area, do_not_retreat = nil
		
		if objective_area and self:is_area_safe(objective_area) then
			retreat_area = objective_area
		end

		if not retreat_area and not do_not_retreat and current_objective.coarse_path then
			local forwardmost_i_nav_point = self:_get_group_forwardmost_coarse_path_index(group)

			if forwardmost_i_nav_point then
				retreat_area = self:get_area_from_nav_seg_id(group.coarse_path[math.max(forwardmost_i_nav_point - 1, 1)][1])
			end
		end

		if retreat_area then
			local new_grp_objective = {
				attitude = "avoid",
				stance = "hos",
				pose = "crouch",
				type = "assault_area",
				area = retreat_area,
				coarse_path = {
					{
						retreat_area.pos_nav_seg,
						mvector3.copy(retreat_area.pos)
					}
				}
			}
			group.is_chasing = nil

			self:_set_objective_to_enemy_group(group, new_grp_objective)

			return
		end
	end
end

function GroupAIStateBesiege:_set_recon_objective_to_group(group)
	local current_objective = group.objective
	local target_area = current_objective.target_area or current_objective.area
	if not target_area.loot and not target_area.hostages or not current_objective.moving_out and current_objective.moved_in and group.in_place_t and self._t - group.in_place_t > 15 then
		local recon_area
		local to_search_areas = {
			current_objective.area
		}
		local found_areas = {
			[current_objective.area] = "init"
		}
		repeat
			local search_area = table_remove(to_search_areas, 1)
			if search_area.loot or search_area.hostages then
				local occupied
				for test_group_id, test_group in pairs(self._groups) do
					if test_group ~= group and (test_group.objective.target_area == search_area or test_group.objective.area == search_area) then
						occupied = true
					else
					end
				end
				if not occupied and group.visited_areas and group.visited_areas[search_area] then
					occupied = true
				end
				if not occupied then
					local is_area_safe = not next(search_area.criminal.units)
					if is_area_safe then
						recon_area = search_area
						break
					else
						recon_area = recon_area or search_area
					end
				end
			end
			if not next(search_area.criminal.units) then
				for other_area_id, other_area in pairs(search_area.neighbours) do
					if not found_areas[other_area] then
						table_insert(to_search_areas, other_area)
						found_areas[other_area] = search_area
					end
				end
			end
		until #to_search_areas == 0
		if recon_area then
			local coarse_path = {
				{
					recon_area.pos_nav_seg,
					recon_area.pos
				}
			}
			local last_added_area = recon_area
			while found_areas[last_added_area] ~= "init" do
				last_added_area = found_areas[last_added_area]
				table_insert(coarse_path, 1, {
					last_added_area.pos_nav_seg,
					last_added_area.pos
				})
			end
			local grp_objective = {
				scan = true,
				pose = math_random() < 0.5 and "crouch" or "stand",
				type = "recon_area",
				stance = "hos",
				attitude = "avoid",
				area = current_objective.area,
				target_area = recon_area,
				coarse_path = coarse_path,
				bagjob = recon_area.loot or nil,
				hostagejob = recon_area.hostages or nil
			}
			self:_set_objective_to_enemy_group(group, grp_objective)
			self:_voice_looking_for_angle(group)
			current_objective = group.objective
		end
	end
	if current_objective.target_area then
		if current_objective.moving_out and not current_objective.moving_in and current_objective.coarse_path then
			local forwardmost_i_nav_point = self:_get_group_forwardmost_coarse_path_index(group)
			if forwardmost_i_nav_point and forwardmost_i_nav_point > 1 then
				for i = forwardmost_i_nav_point + 1, #current_objective.coarse_path do
					local nav_point = current_objective.coarse_path[forwardmost_i_nav_point]
					if not self:is_nav_seg_safe(nav_point[1]) then
						for i = 0, #current_objective.coarse_path - forwardmost_i_nav_point do
							table_remove(current_objective.coarse_path)
						end
						local grp_objective = {
							attitude = "avoid",
							scan = true,
							pose = math_random() < 0.5 and "crouch" or "stand",
							type = "recon_area",
							stance = "hos",
							area = self:get_area_from_nav_seg_id(current_objective.coarse_path[#current_objective.coarse_path][1]),
							target_area = current_objective.target_area,
							bagjob = current_objective.target_area.loot or nil,
							hostagejob = current_objective.target_area.hostages or nil
						}
						self:_set_objective_to_enemy_group(group, grp_objective)
						self:_voice_looking_for_angle(group)
						return
					end
				end
			end
		end
		if not current_objective.moving_out and not current_objective.area.neighbours[current_objective.target_area.id] then
			local search_params = {
				from_seg = current_objective.area.pos_nav_seg,
				to_seg = current_objective.target_area.pos_nav_seg,
				id = "GroupAI_recon",
				access_pos = self._get_group_acces_mask(group),
				verify_clbk = callback(self, self, "is_nav_seg_safe")
			}
			local coarse_path = managers.navigation:search_coarse(search_params)
			if coarse_path then
				self:_merge_coarse_path_by_area(coarse_path)
				table_remove(coarse_path)
				local grp_objective = {
					scan = true,
					pose = "stand",
					type = "recon_area",
					stance = "hos",
					attitude = "avoid",
					area = self:get_area_from_nav_seg_id(coarse_path[#coarse_path][1]),
					target_area = current_objective.target_area,
					coarse_path = coarse_path,
					bagjob = current_objective.target_area.loot or nil,
					hostagejob = current_objective.target_area.hostages or nil
				}
				self:_set_objective_to_enemy_group(group, grp_objective)
				self:_voice_looking_for_angle(group)
			end
		end
		if not current_objective.moving_out and current_objective.area.neighbours[current_objective.target_area.id] then
			local grp_objective = {
				stance = "hos",
				scan = true,
				pose = math_random() < 0.5 and "crouch" or "stand",
				type = "recon_area",
				attitude = "avoid",
				area = current_objective.target_area,
				bagjob = current_objective.target_area.loot or nil,
				hostagejob = current_objective.target_area.hostages or nil
			}
			self:_set_objective_to_enemy_group(group, grp_objective)
			self:_voice_looking_for_angle(group)
			group.objective.moving_in = true
			group.objective.moved_in = true
		end
	end
end

function GroupAIStateBesiege._create_objective_from_group_objective(grp_objective, receiving_unit)
	local objective = {
		grp_objective = grp_objective
	}

	if grp_objective.element then
		objective = grp_objective.element:get_random_SO(receiving_unit)

		if not objective then
			return
		end

		objective.grp_objective = grp_objective

		return
	elseif grp_objective.type == "defend_area" or grp_objective.type == "recon_area" or grp_objective.type == "reenforce_area" then
		objective.type = "defend_area"
		objective.stance = "hos"
		objective.pose = "stand"
		objective.scan = true
		objective.interrupt_dis = 200
		objective.interrupt_suppression = nil
	elseif grp_objective.type == "retire" then
		objective.type = "defend_area"
		objective.running = true
		objective.stance = "hos"
		objective.pose = "stand"
		objective.scan = true
		objective.no_arrest = true
	elseif grp_objective.type == "assault_area" then
		objective.type = "defend_area"

		if grp_objective.follow_unit then
			objective.follow_unit = grp_objective.follow_unit
			objective.distance = grp_objective.distance
		end
		
		objective.no_arrest = true
		objective.stance = "hos"
		objective.pose = "stand"
		objective.scan = true
		objective.interrupt_dis = 200
		objective.interrupt_suppression = true
	elseif grp_objective.type == "create_phalanx" then
		objective.type = "phalanx"
		objective.stance = "hos"
		objective.interrupt_dis = nil
		objective.interrupt_health = nil
		objective.interrupt_suppression = nil
		objective.attitude = "avoid"
		objective.path_ahead = true
	elseif grp_objective.type == "hunt" then
		objective.type = "hunt"
		objective.stance = "hos"
		objective.scan = true
		objective.interrupt_dis = 200
	end

	objective.stance = grp_objective.stance or objective.stance
	objective.pose = grp_objective.pose or objective.pose
	objective.area = grp_objective.area
	objective.nav_seg = grp_objective.nav_seg or objective.area.pos_nav_seg
	objective.attitude = grp_objective.attitude or objective.attitude
	
	if not objective.no_arrest then
		objective.no_arrest = not objective.attitude or objective.attitude == "avoid"
	end
	
	objective.interrupt_dis = grp_objective.interrupt_dis or objective.interrupt_dis
	objective.interrupt_health = grp_objective.interrupt_health or objective.interrupt_health
	objective.interrupt_suppression = nil
	objective.pos = grp_objective.pos
	objective.bagjob = grp_objective.bagjob or nil
	objective.hostagejob = grp_objective.hostagejob or nil
	
	if not objective.running then
		objective.running = grp_objective.running or nil
	end

	if grp_objective.scan ~= nil then
		objective.scan = grp_objective.scan
	end

	if grp_objective.coarse_path then
		objective.path_style = "coarse_complete"
		objective.path_data = grp_objective.coarse_path
	end

	return objective
end

function GroupAIStateBesiege:_perform_group_spawning(spawn_task, force, use_last)
	local nr_units_spawned = 0
	local produce_data = {
		name = true,
		spawn_ai = {}
	}
	local group_ai_tweak = tweak_data.group_ai
	local spawn_points = spawn_task.spawn_group.spawn_pts

	local function _try_spawn_unit(u_type_name, spawn_entry)
		if GroupAIStateBesiege._MAX_SIMULTANEOUS_SPAWNS <= nr_units_spawned and not force then
			return
		end

		local hopeless = true
		local current_unit_type = tweak_data.levels:get_ai_group_type()

		for _, sp_data in ipairs(spawn_points) do
			local category = group_ai_tweak.unit_categories[u_type_name]

			if (sp_data.accessibility == "any" or category.access[sp_data.accessibility]) and (not sp_data.amount or sp_data.amount > 0) and sp_data.mission_element:enabled() then
				hopeless = false

				if sp_data.delay_t < self._t then
					local units = category.unit_types[current_unit_type]
					produce_data.name = units[math_random(#units)]
					produce_data.name = managers.modifiers:modify_value("GroupAIStateBesiege:SpawningUnit", produce_data.name)
					local spawned_unit = sp_data.mission_element:produce(produce_data)
					local u_key = spawned_unit:key()
					local objective = nil

					if spawn_task.objective then
						objective = self.clone_objective(spawn_task.objective)
					else
						objective = spawn_task.group.objective.element:get_random_SO(spawned_unit)

						if not objective then
							spawned_unit:set_slot(0)

							return true
						end

						objective.grp_objective = spawn_task.group.objective
					end

					local u_data = self._police[u_key]

					self:set_enemy_assigned(objective.area, u_key)

					if spawn_entry.tactics then
						u_data.tactics = spawn_entry.tactics
						u_data.tactics_map = {}

						for _, tactic_name in ipairs(u_data.tactics) do
							u_data.tactics_map[tactic_name] = true
						end
					end

					spawned_unit:brain():set_spawn_entry(spawn_entry, u_data.tactics_map)

					u_data.rank = spawn_entry.rank

					self:_add_group_member(spawn_task.group, u_key)

					if spawned_unit:brain():is_available_for_assignment(objective) then
						if objective.element then
							objective.element:clbk_objective_administered(spawned_unit)
						end

						spawned_unit:brain():set_objective(objective)
					else
						spawned_unit:brain():set_followup_objective(objective)
					end

					nr_units_spawned = nr_units_spawned + 1

					if spawn_task.ai_task then
						spawn_task.ai_task.force_spawned = spawn_task.ai_task.force_spawned + 1
						spawned_unit:brain()._logic_data.spawned_in_phase = spawn_task.ai_task.phase
					end

					sp_data.delay_t = self._t + sp_data.interval

					if sp_data.amount then
						sp_data.amount = sp_data.amount - 1
					end

					return true
				end
			end
		end

		if hopeless then
			debug_pause("[GroupAIStateBesiege:_upd_group_spawning] spawn group", spawn_task.spawn_group.id, "failed to spawn unit", u_type_name)

			return true
		end
	end

	for u_type_name, spawn_info in pairs(spawn_task.units_remaining) do
		if not group_ai_tweak.unit_categories[u_type_name].access.acrobatic then
			for i = spawn_info.amount, 1, -1 do
				local success = _try_spawn_unit(u_type_name, spawn_info.spawn_entry)

				if success then
					spawn_info.amount = spawn_info.amount - 1
				end

				break
			end
		end
	end

	for u_type_name, spawn_info in pairs(spawn_task.units_remaining) do
		for i = spawn_info.amount, 1, -1 do
			local success = _try_spawn_unit(u_type_name, spawn_info.spawn_entry)

			if success then
				spawn_info.amount = spawn_info.amount - 1
			end

			break
		end
	end

	local complete = true

	for u_type_name, spawn_info in pairs(spawn_task.units_remaining) do
		if spawn_info.amount > 0 then
			complete = false

			break
		end
	end

	if complete then
		spawn_task.group.has_spawned = true
		self:_voice_groupentry(spawn_task.group)
		table_remove(self._spawning_groups, use_last and #self._spawning_groups or 1)

		if spawn_task.group.size <= 0 then
			self._groups[spawn_task.group.id] = nil
		end
	end
end

function GroupAIStateBesiege:_begin_new_tasks()
	local all_areas = self._area_data
	local nav_manager = managers.navigation
	local all_nav_segs = nav_manager._nav_segments
	local task_data = self._task_data
	local t = self._t
	local reenforce_candidates = nil
	local reenforce_data = task_data.reenforce

	if reenforce_data.next_dispatch_t and reenforce_data.next_dispatch_t < t then
		reenforce_candidates = {}
	end

	local recon_candidates, are_recon_candidates_safe = nil
	local recon_data = task_data.recon

	if recon_data.next_dispatch_t and recon_data.next_dispatch_t < t and not task_data.assault.active and not task_data.regroup.active then
		recon_candidates = {}
	end

	local assault_candidates = nil
	local assault_data = task_data.assault

	if self._difficulty_value > 0 and assault_data.next_dispatch_t and assault_data.next_dispatch_t < t and not task_data.regroup.active then
		assault_candidates = {}
	end

	if not reenforce_candidates and not recon_candidates and not assault_candidates then
		return
	end

	local found_areas = {}
	local to_search_areas = {}

	for area_id, area in pairs(all_areas) do
		if area.spawn_points then
			for _, sp_data in pairs(area.spawn_points) do
				if sp_data.delay_t <= t and not all_nav_segs[sp_data.nav_seg].disabled then
					table_insert(to_search_areas, area)

					found_areas[area_id] = true

					break
				end
			end
		end

		if not found_areas[area_id] and area.spawn_groups then
			for _, sp_data in pairs(area.spawn_groups) do
				if sp_data.delay_t <= t and not all_nav_segs[sp_data.nav_seg].disabled then
					table_insert(to_search_areas, area)

					found_areas[area_id] = true

					break
				end
			end
		end
	end

	if #to_search_areas == 0 then
		return
	end

	if assault_candidates and self._hunt_mode and self._char_criminals then
		for criminal_key, criminal_data in pairs(self._char_criminals) do
			if criminal_key and not criminal_data.status then
				local nav_seg = criminal_data.tracker:nav_segment()
				local area = self:get_area_from_nav_seg_id(nav_seg)
				found_areas[area] = true

				table_insert(assault_candidates, area)
			end
		end
	end

	local i = 1

	repeat
		local area = to_search_areas[i]
		local force_factor = area.factors.force
		local demand = force_factor and force_factor.force
		local nr_police = table.size(area.police.units)
		local nr_criminals = nil
		
		if area.criminal and area.criminal.units then
			nr_criminals = table.size(area.criminal.units)
		end

		if reenforce_candidates and demand and demand > 0 and nr_criminals and nr_criminals == 0 then
			local area_free = true

			for i_task, reenforce_task_data in ipairs(reenforce_data.tasks) do
				if reenforce_task_data.target_area == area then
					area_free = false

					break
				end
			end

			if area_free then
				table_insert(reenforce_candidates, area)
			end
		end

		if recon_candidates and area.loot or recon_candidates and area.hostages then
			local occupied = nil

			for group_id, group in pairs(self._groups) do
				if group.objective.target_area == area or group.objective.area == area then
					occupied = true

					break
				end
			end

			if not occupied then
				local is_area_safe = nr_criminals == 0

				if is_area_safe then
					if are_recon_candidates_safe then
						table_insert(recon_candidates, area)
					else
						are_recon_candidates_safe = true
						recon_candidates = {
							area
						}
					end
				elseif not are_recon_candidates_safe then
					table_insert(recon_candidates, area)
				end
			end
		end

		if assault_candidates and area.criminal and area.criminal.units and self._criminals then
			for criminal_key, _ in pairs(area.criminal.units) do
				if criminal_key and self._criminals[criminal_key] and not self._criminals[criminal_key].status and not self._criminals[criminal_key].is_deployable then
					table_insert(assault_candidates, area)

					break
				end
			end
		end

		if nr_criminals == 0 then
			for neighbour_area_id, neighbour_area in pairs(area.neighbours) do
				if not found_areas[neighbour_area_id] then
					table_insert(to_search_areas, neighbour_area)

					found_areas[neighbour_area_id] = true
				end
			end
		end

		i = i + 1
	until i > #to_search_areas

	if assault_candidates and #assault_candidates > 0 then
		self:_begin_assault_task(assault_candidates)

		recon_candidates = nil
	end

	if recon_candidates and #recon_candidates > 0 then
		local recon_area = recon_candidates[math_random(#recon_candidates)]

		self:_begin_recon_task(recon_area)
	end

	if reenforce_candidates and #reenforce_candidates > 0 then
		local lucky_i_candidate = math_random(#reenforce_candidates)
		local reenforce_area = reenforce_candidates[lucky_i_candidate]

		self:_begin_reenforce_task(reenforce_area)

		recon_candidates = nil
	end
end

function GroupAIStateBesiege:_voice_saw()
	for group_id, group in pairs(self._groups) do
		for u_key, u_data in pairs(group.units) do
			if u_data.char_tweak.chatter and u_data.char_tweak.chatter.saw then
				self:chk_say_enemy_chatter(u_data.unit, u_data.m_pos, "saw")
			else
				
			end
		end
	end
end


function GroupAIStateBesiege:_voice_sentry()
	for group_id, group in pairs(self._groups) do
		for u_key, u_data in pairs(group.units) do
			if u_data.char_tweak.chatter and u_data.char_tweak.chatter.sentry then
				self:chk_say_enemy_chatter(u_data.unit, u_data.m_pos, "sentry")
			else
				
			end
		end
	end
end

function GroupAIStateBesiege:_voice_looking_for_angle(group)
	for u_key, unit_data in pairs(group.units) do
		if unit_data.char_tweak.chatter and unit_data.char_tweak.chatter.ready and self:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "look_for_angle") then
		else
		end
	end
end	

function GroupAIStateBesiege:_voice_friend_dead(group)
	for u_key, unit_data in pairs(group.units) do
		if unit_data.char_tweak.chatter and unit_data.char_tweak.chatter.enemyidlepanic and self:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "assaultpanic") then
			else
		end
	end
end

function GroupAIStateBesiege:_voice_open_fire_start(group)
	for u_key, unit_data in pairs(group.units) do
		if unit_data.char_tweak.chatter and unit_data.char_tweak.chatter.ready and self:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "open_fire") then
		else
		end
	end
end

function GroupAIStateBesiege:_voice_push_in(group)
	for u_key, unit_data in pairs(group.units) do
		if unit_data.char_tweak.chatter and unit_data.char_tweak.chatter.ready and self:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "push") then
		else
		end
	end
end

function GroupAIStateBesiege:_voice_gtfo(group)
	for u_key, unit_data in pairs(group.units) do
		if unit_data.char_tweak.chatter and unit_data.char_tweak.chatter.ready and self:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "retreat") then
		else
		end
	end
end

function GroupAIStateBesiege:_voice_deathguard_start(group)
	for u_key, unit_data in pairs(group.units) do
		if unit_data.char_tweak.chatter and unit_data.char_tweak.chatter.ready and self:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "deathguard") then
		else
		end
	end
end	

function GroupAIStateBesiege:_voice_smoke(group)
	for u_key, unit_data in pairs(group.units) do
		if unit_data.char_tweak.chatter and unit_data.char_tweak.chatter.ready and self:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "smoke") then
		else
		end
	end
end	

function GroupAIStateBesiege:_voice_flash(group)
	for u_key, unit_data in pairs(group.units) do
		if unit_data.char_tweak.chatter and unit_data.char_tweak.chatter.ready and self:chk_say_enemy_chatter(unit_data.unit, unit_data.m_pos, "flash_grenade") then
		else
		end
	end
end

function GroupAIStateBesiege:_voice_dont_delay_assault(group)
	local time = self._t
	for u_key, unit_data in pairs(group.units) do
		if not unit_data.unit:sound():speaking(time) then
			unit_data.unit:sound():say("p01", true, nil)
			return true
		end
	end
	return false
end

function GroupAIStateBesiege:chk_no_fighting_atm()
	if self._drama_data.amount > 0.2 then
		return
	end

	return true
end
