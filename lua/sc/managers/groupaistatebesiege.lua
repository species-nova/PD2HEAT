local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_set_zero = mvector3.set_zero
local mvec3_step = mvector3.step
local mvec3_lerp = mvector3.lerp
local mvec3_add = mvector3.add
local mvec3_divide = mvector3.divide
local mvec3_dis_sq = mvector3.distance_sq
local mvec3_cpy = mvector3.copy
local mvec3_sub = mvector3.subtract
local mvec3_dir = mvector3.direction
local mvec3_dot = mvector3.dot
local mvec3_norm = mvector3.normalize
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()
local tmp_vec3 = Vector3()

local math_up = math.UP
local math_lerp = math.lerp
local math_random = math.random
local math_clamp = math.clamp
local math_max = math.max

local pairs_g = pairs
local next_g = next

local table_insert = table.insert
local table_remove = table.remove

--Set to true to Log every spawn group + units spawned. (WARNING: MODERATE PERF IMPACT)
local debug_spawn_groups  = false

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
	
	local level_id = Global.level_data.level_id
	if restoration.street_levels[level_id] then
		self._street = true
	end
end

function GroupAIStateBesiege:update(t, dt)
	GroupAIStateBesiege.super.update(self, t, dt)

	if Network:is_server() then
		--self:fix_broken_groups() --until we fix just how nasty our groupai code is, i'll just stick this here
		self:_queue_police_upd_task()

		if self._draw_enabled and managers.navigation:is_data_ready() then
			self:_draw_enemy_activity(t)
			self:_draw_spawn_points()
		end
	elseif self._draw_enabled then
		self:_draw_enemy_activity_client(t)
	end
end

function GroupAIStateBesiege:paused_update(t, dt)
	GroupAIStateBesiege.super.paused_update(self, t, dt)

	if Network:is_server() then
		if self._draw_enabled and managers.navigation:is_data_ready() then
			self:_draw_enemy_activity(t)
			self:_draw_spawn_points()
		end
	elseif self._draw_enabled then
		self:_draw_enemy_activity_client(t)
	end
end

function GroupAIStateBesiege:fix_broken_groups()
	for group_id, group in pairs_g(self._groups) do
		if group.has_spawned and group.size <= 1 then
			self._groups[group.id] = nil
		else
			for u_key, u_data in pairs_g(group.units) do
				if not u_data or not alive(u_data.unit) or u_data.unit:in_slot(0) or not u_data.tracker then
					group.size = group.size - 1
					group.units[u_key] = nil
					
					if group.size <= 1 then
						self._groups[group.id] = nil
					end	
				end
			end
		end
	end
end

function GroupAIStateBesiege:_draw_enemy_activity_client(t)
	local camera = managers.viewport:get_current_camera()

	if not camera then
		return
	end

	local draw_data = self._AI_draw_data
	local logic_name_texts = draw_data.logic_name_texts --not really logics since client
	local panel = draw_data.panel
	local ws = draw_data.workspace
	local mid_pos1 = tmp_vec1
	local mid_pos2 = tmp_vec2
	local focus_enemy_pen = draw_data.pen_focus_enemy
	local focus_player_brush = draw_data.brush_focus_player
	local suppr_period = 0.4
	local suppr_t = t % suppr_period

	if suppr_t > suppr_period * 0.5 then
		suppr_t = suppr_period - suppr_t
	end

	draw_data.brush_suppressed:set_color(Color(math_lerp(0.2, 0.5, suppr_t), 0.85, 0.9, 0.2))

	local groups = {
		{
			group = self._police,
			color = Color(1, 1, 0, 0)
		},
		{
			group = managers.enemy:all_civilians(),
			color = Color(1, 0.75, 0.75, 0.75)
		},
		{
			group = self._ai_criminals,
			color = Color(1, 0, 1, 0)
		}
	}

	local res_x = RenderSettings.resolution.x
	local res_y = RenderSettings.resolution.y

	for i = 1, #groups do
		local group_data = groups[i]

		for u_key, u_data in pairs_g(group_data.group) do
			local logic_name_text = logic_name_texts[u_key]
			local unit = u_data.unit
			local ext_mov = unit:movement()
			local team = ext_mov:team()
			local text_str = team and team.id or "no_team"

			--[[local anim_machine = unit:anim_state_machine()

			if anim_machine then
				local base_seg_state = anim_machine:segment_state(Idstring("base"))

				if base_seg_state then
					local idx = anim_machine:state_name_to_index(base_seg_state)
					text_str = text_str .. ":base_anim_idx( " .. tostring(idx) .. " )"
				end

				local upper_body_seg_state = anim_machine:segment_state(Idstring("upper_body"))

				if upper_body_seg_state then
					local idx = anim_machine:state_name_to_index(upper_body_seg_state)
					text_str = text_str .. ":upp_bdy_anim_idx( " .. tostring(idx) .. " )"
				end
			end]]

			local active_actions = ext_mov._active_actions

			if active_actions then
				local full_body = active_actions[1]

				if full_body then
					text_str = text_str .. ":action[1]( " .. full_body:type() .. " )"
				end

				local lower_body = active_actions[2]

				if lower_body then
					text_str = text_str .. ":action[2]( " .. lower_body:type() .. " )"
				end

				local upper_body = active_actions[3]

				if upper_body then
					text_str = text_str .. ":action[3]( " .. upper_body:type() .. " )"
				end

				local superficial = active_actions[4]

				if superficial then
					text_str = text_str .. ":action[4]( " .. superficial:type() .. " )"
				end
			end

			local queued_actions = ext_mov._queued_actions

			if queued_actions then
				for idx = 1, #queued_actions do
					local q_action = queued_actions[idx]

					if q_action then
						local action_type = q_action.type or "unknown"

						text_str = text_str .. ":queued_action[1]( " .. action_type .. " )"
					end
				end
			end

			if logic_name_text then
				logic_name_text:set_text(text_str)
			else
				logic_name_text = panel:text({
					name = "text",
					font_size = 20,
					layer = 1,
					text = text_str,
					font = tweak_data.hud.medium_font,
					color = group_data.color
				})
				logic_name_texts[u_key] = logic_name_text
			end

			local my_head_pos = mid_pos1
			local m_head_pos = ext_mov:m_head_pos()

			mvec3_set(my_head_pos, m_head_pos)
			mvec3_set_z(my_head_pos, my_head_pos.z + 30)

			local my_head_pos_screen = camera:world_to_screen(my_head_pos)

			if my_head_pos_screen.z > 0 then
				local screen_x = (my_head_pos_screen.x + 1) * 0.5 * res_x
				local screen_y = (my_head_pos_screen.y + 1) * 0.5 * res_y

				logic_name_text:set_x(screen_x)
				logic_name_text:set_y(screen_y)

				if not logic_name_text:visible() then
					logic_name_text:show()
				end
			elseif logic_name_text:visible() then
				logic_name_text:hide()
			end

			local mov_common_data = ext_mov._common_data

			if mov_common_data and mov_common_data.is_suppressed then
				mvec3_set(mid_pos1, ext_mov:m_pos())
				mvec3_set_z(mid_pos1, mid_pos1.z + 220)
				draw_data.brush_suppressed:cylinder(ext_mov:m_pos(), mid_pos1, 35)
			end

			local attention = ext_mov:attention()

			if attention then
				mvec3_set(my_head_pos, m_head_pos)

				local att_unit, e_pos = nil
				local att_handler = attention.handler

				if att_handler then
					e_pos = att_handler:get_attention_m_pos()
				else
					att_unit = attention.unit

					if att_unit then
						local att_ext_mov = att_unit:movement()

						e_pos = att_ext_mov and att_ext_mov:m_head_pos() or att_unit:position()
					else
						e_pos = attention.pos
					end
				end

				mvec3_step(mid_pos2, my_head_pos, e_pos, 300)
				mvec3_lerp(mid_pos1, my_head_pos, mid_pos2, t % 0.5)
				mvec3_step(mid_pos2, mid_pos1, e_pos, 50)
				focus_enemy_pen:line(mid_pos1, mid_pos2)

				att_unit = att_unit or attention.unit

				if att_unit then
					local att_base = att_unit:base()

					if att_base and att_base.is_local_player then
						focus_player_brush:sphere(my_head_pos, 20)
					end
				end
			end
		end
	end

	for u_key, gui_text in pairs_g(logic_name_texts) do
		local keep = nil

		for i = 1, #groups do
			local group_data = groups[i]

			if group_data.group[u_key] then
				keep = true

				break
			end
		end

		if not keep then
			panel:remove(gui_text)

			logic_name_texts[u_key] = nil
		end
	end
end

function GroupAIStateBesiege:_draw_enemy_activity(t)
	local camera = managers.viewport:get_current_camera()

	if not camera then
		return
	end

	local draw_data = self._AI_draw_data
	local brush_area = draw_data.brush_area
	local area_normal = -math_up
	local logic_name_texts = draw_data.logic_name_texts
	local group_id_texts = draw_data.group_id_texts
	local panel = draw_data.panel
	local ws = draw_data.workspace
	local mid_pos1 = tmp_vec1
	local mid_pos2 = tmp_vec2
	local focus_enemy_pen = draw_data.pen_focus_enemy
	local focus_player_brush = draw_data.brush_focus_player
	local suppr_period = 0.4
	local suppr_t = t % suppr_period

	if suppr_t > suppr_period * 0.5 then
		suppr_t = suppr_period - suppr_t
	end

	draw_data.brush_suppressed:set_color(Color(math_lerp(0.2, 0.5, suppr_t), 0.85, 0.9, 0.2))

	for area_id, area in pairs_g(self._area_data) do
		if next_g(area.police.units) then
			brush_area:half_sphere(area.pos, 22, area_normal)
		end
	end

	local res_x = RenderSettings.resolution.x
	local res_y = RenderSettings.resolution.y

	local function _f_draw_logic_name(u_key, l_data, draw_color)
		local logic_name_text = logic_name_texts[u_key]
		local text_str = l_data.name

		if l_data.objective then
			text_str = text_str .. ":" .. l_data.objective.type
		end

		if not l_data.group and l_data.team then
			text_str = l_data.team.id .. ":" .. text_str
		end

		if l_data.spawned_in_phase then
			text_str = text_str .. ":" .. l_data.spawned_in_phase
		end

		local unit = l_data.unit
		--[[local anim_machine = unit:anim_state_machine()

		if anim_machine then
			local base_seg_state = anim_machine:segment_state(Idstring("base"))

			if base_seg_state then
				local idx = anim_machine:state_name_to_index(base_seg_state)
				text_str = text_str .. ":base_anim_idx( " .. tostring(idx) .. " )"
			end

			local upper_body_seg_state = anim_machine:segment_state(Idstring("upper_body"))

			if upper_body_seg_state then
				local idx = anim_machine:state_name_to_index(upper_body_seg_state)
				text_str = text_str .. ":upp_bdy_anim_idx( " .. tostring(idx) .. " )"
			end
		end]]

		local ext_mov = unit:movement()
		local active_actions = ext_mov._active_actions

		if active_actions then
			local full_body = active_actions[1]

			if full_body then
				text_str = text_str .. ":action[1]( " .. full_body:type() .. " )"
			end

			local lower_body = active_actions[2]

			if lower_body then
				text_str = text_str .. ":action[2]( " .. lower_body:type() .. " )"
			end

			local upper_body = active_actions[3]

			if upper_body then
				text_str = text_str .. ":action[3]( " .. upper_body:type() .. " )"
			end

			local superficial = active_actions[4]

			if superficial then
				text_str = text_str .. ":action[4]( " .. superficial:type() .. " )"
			end
		end

		if logic_name_text then
			logic_name_text:set_text(text_str)
		else
			logic_name_text = panel:text({
				name = "text",
				font_size = 12,
				layer = 1,
				text = text_str,
				font = tweak_data.hud.medium_font,
				color = draw_color
			})
			logic_name_texts[u_key] = logic_name_text
		end

		local my_head_pos = mid_pos1

		mvec3_set(my_head_pos, ext_mov:m_head_pos())
		mvec3_set_z(my_head_pos, my_head_pos.z + 30)

		local my_head_pos_screen = camera:world_to_screen(my_head_pos)

		if my_head_pos_screen.z > 0 then
			local screen_x = (my_head_pos_screen.x + 1) * 0.5 * res_x
			local screen_y = (my_head_pos_screen.y + 1) * 0.5 * res_y

			logic_name_text:set_x(screen_x)
			logic_name_text:set_y(screen_y)

			if not logic_name_text:visible() then
				logic_name_text:show()
			end
		elseif logic_name_text:visible() then
			logic_name_text:hide()
		end
	end

	local brush_to_use = {
		guard = "brush_guard",
		defend_area = "brush_defend",
		free = "brush_free",
		follow = "brush_free",
		surrender = "brush_free",
		act = "brush_act",
		revive = "brush_act"
	}

	local all_nav_segs = managers.navigation._nav_segments

	local function _f_draw_obj_pos(unit)
		local ext_brain = unit:brain()
		local objective = ext_brain:objective()
		local objective_type = objective and objective.type
		local brush = brush_to_use[objective_type]
		brush = brush and draw_data[brush] or draw_data.brush_misc

		local obj_pos = nil

		if objective then
			if objective.pos then
				obj_pos = objective.pos
			else
				local follow_unit = objective.follow_unit

				if follow_unit then
					obj_pos = follow_unit:movement():m_head_pos()

					if follow_unit:base().is_local_player then
						obj_pos = obj_pos + math_up * -30
					end
				elseif objective.nav_seg then
					obj_pos = all_nav_segs[objective.nav_seg].pos
				elseif objective.area then
					obj_pos = objective.area.pos
				end
			end
		end

		local ext_mov = nil

		if obj_pos then
			ext_mov = unit:movement()

			local u_pos = ext_mov:m_com()

			brush:cylinder(u_pos, obj_pos, 4, 3)
			brush:sphere(u_pos, 24)
		end

		if ext_brain._logic_data.is_suppressed then
			ext_mov = ext_mov or unit:movement()

			mvec3_set(mid_pos1, ext_mov:m_pos())
			mvec3_set_z(mid_pos1, mid_pos1.z + 220)
			draw_data.brush_suppressed:cylinder(ext_mov:m_pos(), mid_pos1, 35)
		end
	end

	local my_groups = self._groups
	local group_center = tmp_vec3

	for group_id, group in pairs_g(my_groups) do
		local units_com = {}

		for u_key, u_data in pairs_g(group.units) do
			local m_com = u_data.unit:movement():m_com()

			units_com[#units_com + 1] = m_com

			mvec3_add(group_center, m_com)
		end

		local nr_units = #units_com

		if nr_units > 0 then
			mvec3_divide(group_center, nr_units)

			local gui_text = group_id_texts[group_id]
			local group_pos_screen = camera:world_to_screen(group_center)

			if group_pos_screen.z > 0 then
				local move_type = ":" .. "none"
				local group_objective = group.objective

				if group_objective then
					if group.is_chasing then
						move_type = ":" .. "chasing"
					elseif group_objective.moving_in then
						move_type = ":" .. "moving_in"
					elseif group_objective.moving_out then
						move_type = ":" .. "moving_out"
					elseif group_objective.open_fire then
						move_type = ":" .. "open_fire"
					end
				end

				local phase = ""

				local task_data = self._task_data.assault

				if task_data and task_data.active then
					phase = ":" .. task_data.phase
				end

				if not gui_text then
					gui_text = panel:text({
						name = "text",
						font_size = 12,
						layer = 2,
						text = group.team.id .. ":" .. group_id .. ":" .. group.objective.type .. move_type .. phase,
						font = tweak_data.hud.medium_font,
						color = draw_data.group_id_color
					})
					group_id_texts[group_id] = gui_text
				else
					gui_text:set_text(group.team.id .. ":" .. group_id .. ":" .. group.objective.type .. move_type .. phase)
				end

				local screen_x = (group_pos_screen.x + 1) * 0.5 * res_x
				local screen_y = (group_pos_screen.y + 1) * 0.5 * res_y

				gui_text:set_x(screen_x)
				gui_text:set_y(screen_y)

				if not gui_text:visible() then
					gui_text:show()
				end
			elseif gui_text and gui_text:visible() then
				gui_text:hide()
			end

			for i = 1, #units_com do
				local m_com = units_com[i]

				draw_data.pen_group:line(group_center, m_com)
			end

			mvec3_set_zero(group_center)
		end
	end

	local function _f_draw_attention(l_data)
		local current_focus = l_data.attention_obj

		if not current_focus then
			return
		end

		local my_head_pos = l_data.unit:movement():m_head_pos()
		local e_pos = l_data.attention_obj.m_head_pos

		mvec3_step(mid_pos2, my_head_pos, e_pos, 300)
		mvec3_lerp(mid_pos1, my_head_pos, mid_pos2, t % 0.5)
		mvec3_step(mid_pos2, mid_pos1, e_pos, 50)
		focus_enemy_pen:line(mid_pos1, mid_pos2)

		local focus_base_ext = current_focus.unit:base()

		if focus_base_ext and focus_base_ext.is_local_player then
			focus_player_brush:sphere(my_head_pos, 20)
		end
	end

	local groups = {
		{
			group = self._police,
			color = Color(1, 1, 0, 0)
		},
		{
			group = managers.enemy:all_civilians(),
			color = Color(1, 0.75, 0.75, 0.75)
		},
		{
			group = self._ai_criminals,
			color = Color(1, 0, 1, 0)
		}
	}

	for i = 1, #groups do
		local group_data = groups[i]

		for u_key, u_data in pairs_g(group_data.group) do
			_f_draw_obj_pos(u_data.unit)

			local l_data = u_data.unit:brain()._logic_data

			_f_draw_logic_name(u_key, l_data, group_data.color)
			_f_draw_attention(l_data)
		end
	end

	for u_key, gui_text in pairs_g(logic_name_texts) do
		local keep = nil

		for i = 1, #groups do
			local group_data = groups[i]

			if group_data.group[u_key] then
				keep = true

				break
			end
		end

		if not keep then
			panel:remove(gui_text)

			logic_name_texts[u_key] = nil
		end
	end

	for group_id, gui_text in pairs_g(group_id_texts) do
		if not my_groups[group_id] then
			panel:remove(gui_text)

			group_id_texts[group_id] = nil
		end
	end
end

local difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
local difficulty_index = tweak_data:difficulty_to_index(difficulty)

--Implements cooldowns and hard-diff filters for specific spawn groups.
local group_timestamps = {}
function GroupAIStateBesiege:_choose_best_groups(best_groups, group, group_types, allowed_groups, weight)
	local total_weight = 0
	local currenttime = self._t
	local sustain = self._task_data.assault and self._task_data.assault.phase == "sustain"
	local constraints_tweak = self._tweak_data.group_constraints
	local is_skirmish = managers.skirmish:is_skirmish()

	--Check each spawn group and see if it meets filter.
	for group_type, cat_weights in pairs(allowed_groups) do
		local valid = true

		--If group had constraints tied to it, then check for them. If they aren't met, then don't include the group.
		local constraints = constraints_tweak[group_type]
		if constraints then
			local cooldown = constraints.cooldown
			local previoustimestamp = group_timestamps[group_type]
			if cooldown and previoustimestamp and (currenttime - previoustimestamp) < cooldown then
				valid = nil
			end

			if not is_skirmish then
				local min_diff = constraints.min_diff
				local max_diff = constraints.max_diff
				if (min_diff and self._difficulty_value <= min_diff) or (max_diff and self._difficulty_value >= max_diff) then
					valid = nil
				end
			end

			local sustain_only = constraints.sustain_only
			if sustain_only and sustain == false then
				valid = nil
			end
		end

		--If all constraints are met, add it to the best groups.
		if valid and tweak_data.group_ai.enemy_spawn_groups[group_type] then
			local cat_weights = allowed_groups[group_type]

			if cat_weights then
				local cat_weight = self:_get_difficulty_dependent_value(cat_weights)
				local mod_weight = weight * cat_weight

				table.insert(best_groups, {
					group = group,
					group_type = group_type,
					wght = mod_weight,
					cat_weight = cat_weight,
					dis_weight = weight
				})

				total_weight = total_weight + mod_weight
			end
		end
	end

	return total_weight
end

function GroupAIStateBesiege:_pregenerate_coarse_path(grp_objective, spawn_group)
	--allows groups to preemptively generate coarse_paths as they spawn to their intended destinations, need to set this up for recon and reenforce groups still, but this is a start
	local end_nav_seg = managers.navigation:get_nav_seg_from_pos(grp_objective.area.pos, true)
	local search_params = {
		id = "GroupAI_spawn",
		from_seg = spawn_group.nav_seg,
		to_seg = end_nav_seg,
		access_pos = "swat",
		verify_clbk = callback(self, self, "is_nav_seg_safe") --spawned in groups will try to path safely (avoiding direct contact) to sorround it if at all possible, in order to execute viable flanks as much as possible
	}
	local coarse_path = managers.navigation:search_coarse(search_params)
	
	if coarse_path then
		grp_objective.coarse_path = coarse_path
		grp_objective.area = self:get_area_from_nav_seg_id(coarse_path[#coarse_path][1])
	else
		--if it fails, try without the verify_clbk and go head-first anyway, with a chance to take a much longer and wider path instead.
		local search_params = {
			id = "GroupAI_spawn",
			from_seg = spawn_group.nav_seg,
			to_seg = end_nav_seg,
			access_pos = "swat",
			long_path = math_random() < 0.5 and true
			--no verify_clbk
		}
		local coarse_path = managers.navigation:search_coarse(search_params)
		
		if coarse_path then
			grp_objective.coarse_path = coarse_path
			grp_objective.area = self:get_area_from_nav_seg_id(coarse_path[#coarse_path][1])
		else
			grp_objective.area = self:get_area_from_nav_seg_id(spawn_group.nav_seg)
			grp_objective.coarse_path = {{spawn_group.nav_seg, spawn_group.area.pos}}
		end
	end
end

--Refactored from vanilla code to be a bit easier to read and debug. Also adds timestamp support.
function GroupAIStateBesiege:_spawn_in_group(spawn_group, spawn_group_type, grp_objective, ai_task)
	local spawn_group_desc = tweak_data.group_ai.enemy_spawn_groups[spawn_group_type]
	local wanted_nr_units = nil
	local nr_units = 0

	--Determine number of units to spawn.
	if type(spawn_group_desc.amount) == "number" then
		wanted_nr_units = spawn_group_desc.amount
	else
		wanted_nr_units = math_random(spawn_group_desc.amount[1], spawn_group_desc.amount[2])
	end

	local unit_types = spawn_group_desc.spawn --All units in spawn group.
	local valid_unit_types = {} --All units in the spawn group that are able to spawn.
	local remaining_special_pools = {} --Tracks remaining room in special spawn caps.
	local unit_categories = tweak_data.group_ai.unit_categories
	local total_wgt = 0 --Freqs of all valid unit types all added together.

	--Determine which unit types in spawn group are valid. Delay spawns if required units are above cap.
	for i = 1, #unit_types do
		local spawn_entry = unit_types[i]
		if not spawn_entry.unit then
			log("ERROR IN GROUP: " .. spawn_group_type .. " no unit defined in index " .. tostring(i))
			return
		end

		if not spawn_entry.freq then
			log("ERROR IN GROUP: " .. spawn_group_type .. " no freq defined for unit " .. spawn_entry.unit)
			return
		end

		if spawn_entry.amount_min and spawn_entry.amount_max and spawn_entry.amount_min > spawn_entry.amount_max then
			log("WARNING IN GROUP: " .. spawn_group_type .. " amount_max is smaller than amount_min for " .. spawn_entry.unit)
		end

		local cat_data = unit_categories[spawn_entry.unit]
		if not cat_data then
			log("ERROR IN GROUP: " .. spawn_group_type .. " contains fictional made up imaginary good-for-nothing unit " .. spawn_entry.unit)
			return
		end

		if cat_data.special_type then --Determine if special unit is valid, or if spawning needs to be delayed.
			remaining_special_pools[cat_data.special_type] = managers.job:current_spawn_limit(cat_data.special_type) - self:_get_special_unit_type_count(cat_data.special_type)
			if remaining_special_pools[cat_data.special_type] < (spawn_entry.amount_min or 0) then --If essential spawn would go above cap, then delay spawn group and return.
				spawn_group.delay_t = self._t + 10
				return
			end
			
			if remaining_special_pools[cat_data.special_type] > 0 then --If special unit doesn't go above cap, then add to valid table.
				table_insert(valid_unit_types, spawn_entry)
				total_wgt = total_wgt + spawn_entry.freq
			end
		else --Unit not special, add it to valid table.
			table_insert(valid_unit_types, spawn_entry)
			total_wgt = total_wgt + spawn_entry.freq
		end
	end
	
	--Forced groups (mostly captains) spawn instantly.
	if not spawn_group_desc.force then
		for _, sp_data in ipairs(spawn_group.spawn_pts) do
			sp_data.delay_t = self._t + math.rand(0.5)
		end
	end

	local spawn_task = {
		objective = not grp_objective.element and self._create_objective_from_group_objective(grp_objective),
		units_remaining = {},
		spawn_group = spawn_group,
		force = spawn_group_desc.force,
		spawn_group_type = spawn_group_type,
		ai_task = ai_task
	}
	
	table_insert(self._spawning_groups, spawn_task)

	--Adds as many as needed to meet requirements. Removes any valid units it turns invalid.
	local function _add_unit_type_to_spawn_task(i, spawn_entry)
		local unit_invalidated = false
		local prev_amount = nil --Previous number of these guys in the spawn task.
		local new_amount = nil --New number of these guys in the spawn task.
		if not spawn_task.units_remaining[spawn_entry.unit] then --If unit isn't part of spawn task yet, add the minimum amount to start.
			prev_amount = 0
			new_amount = spawn_entry.amount_min or 1
		else --Otherwise just add 1.
			prev_amount = spawn_task.units_remaining[spawn_entry.unit].amount
			new_amount = 1 + prev_amount
		end
		local amount_increase = new_amount - prev_amount --Amount the number of this unit would increase.

		if spawn_entry.amount_max and new_amount >= spawn_entry.amount_max then --Max unit count reached, removing unit from valid units for future spawns.
			table_remove(valid_unit_types, i)
			total_wgt = total_wgt - spawn_entry.freq
			unit_invalidated = true
		end

		--Update special unit spawn caps.
		local cat_data = unit_categories[spawn_entry.unit]
		if cat_data.special_type then
			if remaining_special_pools[cat_data.special_type] >= amount_increase then
				remaining_special_pools[cat_data.special_type] = remaining_special_pools[cat_data.special_type] - amount_increase
				if remaining_special_pools[cat_data.special_type] == 0 and not unit_invalidated then --Special spawn cap reached, removing unit from valid units for future spawns.
					table_remove(valid_unit_types, i)
					total_wgt = total_wgt - spawn_entry.freq
					unit_invalidated = true
				end
			end
		end

		--Add unit to spawn task.
		spawn_task.units_remaining[spawn_entry.unit] = {
			amount = new_amount,
			spawn_entry = spawn_entry
		}
		nr_units = nr_units + amount_increase

		return unit_invalidated
	end

	--Add required units to spawn group.
	local i = 1
	local req_entry = valid_unit_types[i]
	while req_entry do --Array size changes, so iteration finishes when the current entry is nil.
		if wanted_nr_units > nr_units and req_entry.amount_min and req_entry.amount_min > 0 then
			if _add_unit_type_to_spawn_task(i, req_entry) then --Don't increment to next value if a unit was invalidated.
				i = i + 1
			end
		else
			i = i + 1
		end

		req_entry = valid_unit_types[i]
	end

	--Spawn random units.
	while wanted_nr_units > nr_units and total_wgt > 0 do
		local rand_wgt = math_random() * total_wgt
		local rand_i = 1
		local rand_entry = valid_unit_types[rand_i]

		--Loop until the unit corresponding to rand_wgt is found.
		while true do
			rand_wgt = rand_wgt - rand_entry.freq

			if rand_wgt <= 0 then
				break --Random unit entry found!
			else
				rand_i = rand_i + 1 --Move onto next unit entry.
				rand_entry = valid_unit_types[rand_i]
			end
		end

		_add_unit_type_to_spawn_task(rand_i, rand_entry) --Add our random boi.
	end

	--Create group object and finalize.
	local group_desc = {
		size = nr_units,
		type = spawn_group_type
	}
	local group = self:_create_group(group_desc)
	
	self:_set_objective_to_enemy_group(group, grp_objective)
	group.team = self._teams[spawn_group.team_id or tweak_data.levels:get_default_team_ID("combatant")]
	spawn_task.group = group
	group_timestamps[spawn_group_type] = self._t --Set timestamp for whatever spawngroup was just spawned in to allow for cooldown tracking.
	--table_insert(self._spawning_groups, spawn_task) --Add group to spawning_groups once task is finalized.

	if debug_spawn_groups then
		log("Spawning group: " .. spawn_group_type)
		for name, spawn_info in pairs(spawn_task.units_remaining) do
			log("     " .. name .. "x" .. tostring(spawn_info.amount))
		end
	end

	return group
end

function GroupAIStateBesiege:_upd_group_spawning(use_last)
	local spawn_task = self._spawning_groups[use_last and #self._spawning_groups or 1]

	if not spawn_task then
		return
	end

	self:_perform_group_spawning(spawn_task, spawn_task.force, use_last)
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
					produce_data.name = units[math.random(#units)]
					produce_data.name = managers.modifiers:modify_value("GroupAIStateBesiege:SpawningUnit", produce_data.name)
					local spawned_unit = sp_data.mission_element:produce(produce_data)
					local u_key = spawned_unit:key()
					local objective = nil

					if spawn_task.objective then
						objective = self.clone_objective(spawn_task.objective)
					elseif spawn_task.group.objective.element then
						objective = spawn_task.group.objective.element:get_random_SO(spawned_unit)

						if not objective then
							spawned_unit:set_slot(0)

							return true
						end

						objective.grp_objective = spawn_task.group.objective
					end

					local u_data = self._police[u_key]
					
					if u_data.group then --prevents a unit from having 2 groups at once
						self._groups[u_data.group.id] = nil
						u_data.group = nil
					end

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

		table.remove(self._spawning_groups, use_last and #self._spawning_groups or 1)

		if spawn_task.group.size <= 0 then
			self._groups[spawn_task.group.id] = nil
		end
	end
end


function GroupAIStateBesiege:set_endless_silent()
	self._silent_endless = true
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
	
	if fuck then
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
						
						if self._current_objective_dir then
							local spawn_group_dir = spawn_group.pos:with_z(0)
							mvec3_sub(spawn_group_dir, target_pos:with_z(0))
							mvec3_norm(spawn_group_dir)
							
							if mvec3_dis_sq(spawn_group.pos:with_z(0), target_pos:with_z(0)) < 1500 or mvec3_dot(self._current_objective_dir, spawn_group_dir) < 0.2 then
								should_add_spawngroup = nil
							end
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
	
	for id in pairs(valid_spawn_groups) do
		if self._spawn_group_timers[id] and time < self._spawn_group_timers[id] then
			valid_spawn_groups[id] = nil
			valid_spawn_group_distances[id] = nil
		end
	end
	
	local delays = {15, 20}

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
	return self._enemy_weapons_hot
end

function GroupAIStateBesiege:_chk_group_areas_tresspassed(group)
	local objective = group.objective
	local occupied_areas = {}
	
	for u_key, u_data in pairs(group.units) do
		if u_data and alive(u_data.tracker) then
			local nav_seg = u_data.tracker:nav_segment()
			for area_id, area in pairs(self._area_data) do
				if area.nav_segs[nav_seg] then
					occupied_areas[area_id] = area
				end
			end
		else
			log("broken fucker in " .. tostring(group.id))
			if group.objective.element then
				log("elemental group")
			end
			
			--u_data.unit:set_slot(0)
			if u_data.m_pos then
				local line = Draw:brush(Color.blue:with_alpha(0.5), 10)
				line:cylinder(u_data.m_pos, u_data.m_pos + math_up * 1000, 100)
			end
			
			group.size = group.size - 1
			group.units[u_key] = nil
			if group.size <= 1 then
				self._groups[group.id] = nil
			end			
		end
	end

	for area_id, area in pairs(occupied_areas) do
		if not self:is_area_safe(area) then
			return area
		end
	end
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

function GroupAIStateBesiege:_end_regroup_task()
	if self._task_data.regroup.active then
		self._task_data.regroup.active = nil

		managers.trade:set_trade_countdown(true)
		self:set_assault_mode(false)

		if not self._smoke_grenade_ignore_control then
			managers.network:session():send_to_peers_synched("sync_smoke_grenade_kill")
			self:sync_smoke_grenade_kill()
		end

		local dmg = self._downs_during_assault
		local limits = tweak_data.group_ai.bain_assault_praise_limits
		local result = dmg < limits[1] and 0 or dmg < limits[2] and 1 or 2

		self._current_objective_dir = nil

		managers.mission:call_global_event("end_assault_late")
		managers.groupai:dispatch_event("end_assault_late", self._assault_number)
		managers.hud:end_assault(result)
		self:_mark_hostage_areas_as_unsafe()
		self:_set_rescue_state(true)

		if not self._task_data.assault.next_dispatch_t then
			local assault_delay = self._tweak_data.assault.delay
			self._task_data.assault.next_dispatch_t = self._t + self:_get_difficulty_dependent_value(assault_delay)
		end

		if self._draw_drama then
			self._draw_drama.regroup_hist[#self._draw_drama.regroup_hist][2] = self._t
		end

		self._task_data.recon.next_dispatch_t = self._t
	end
end

function GroupAIStateBesiege:_upd_recon_tasks()
	local task_data = self._task_data.recon.tasks[1]

	self:_assign_enemy_groups_to_recon()

	if not task_data then
		return
	end

	local t = self._t

	self:_assign_assault_groups_to_retire()

	local target_pos = task_data.target_area.pos
	local nr_wanted = self:_get_difficulty_dependent_value(self._tweak_data.recon.force) - self:_count_police_force("recon")

	if nr_wanted <= 0 then
		return
	end

	local used_event, used_spawn_points, reassigned = nil

	if task_data.use_spawn_event then
		if self:_try_use_task_spawn_event(t, task_data.target_area, "recon") then
			used_event = true
		end
	end

	local used_group = nil

	if next(self._spawning_groups) then
		used_group = true
	else
		local spawn_group, spawn_group_type = self:_find_spawn_group_near_area(task_data.target_area, self._tweak_data.recon.groups, nil, nil, nil)

		if spawn_group then
			local grp_objective = {
				attitude = "avoid",
				scan = true,
				stance = "hos",
				type = "recon_area",
				area = task_data.target_area,
				target_area = task_data.target_area
			}

			self:_spawn_in_group(spawn_group, spawn_group_type, grp_objective)

			used_group = true
		end
	end

	if used_event or used_spawn_points or reassigned then
		table.remove(self._task_data.recon.tasks, 1)

		self._task_data.recon.next_dispatch_t = t + 10 * math.random()
	end
end

function GroupAIStateBesiege:_begin_assault_task(assault_areas)
	local assault_task = self._task_data.assault
	assault_task.active = true
	assault_task.next_dispatch_t = nil
	assault_task.target_areas = assault_areas
	self._current_target_area = self._task_data.assault.target_areas[1]
	
	if self._street then 
		if self._current_objective_pos then
			local area_pos = self._current_objective_pos:with_z(0)
			local primary_target_area_pos = self._task_data.assault.target_areas[1].pos:with_z(0)
			mvec3_dir(area_pos, primary_target_area_pos, area_pos)
			self._current_objective_dis = mvec3_dis_sq(primary_target_area_pos, area_pos)
			self._current_objective_dir = area_pos
		else
			self._current_objective_dis = nil
			self._current_objective_dir = nil
		end
	end
	
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
		local randomgroupcallout = math_random(1, 100)
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
		local randomgroupcallout = math_random(1, 100)
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

function GroupAIStateBesiege:_chk_group_use_smoke_grenade(group, task_data, detonate_pos, target_area)
	if task_data.use_smoke then
		local shooter_pos, shooter_u_data = nil
		local duration = tweak_data.group_ai.smoke_grenade_lifetime
		local best_dis = nil
		local best_detonate_pos = nil
		
		for u_key, u_data in pairs(group.units) do
			if u_data.tactics_map and u_data.tactics_map.smoke_grenade then
				if not detonate_pos then
					local nav_seg_id = u_data.tracker:nav_segment()
					local nav_seg = managers.navigation._nav_segments[nav_seg_id]
					
					if not target_area then
						target_area = task_data.target_areas[1]
					end
					
					for neighbour_nav_seg_id, door_list in pairs(nav_seg.neighbours) do
						if target_area.nav_segs[neighbour_nav_seg_id] then
							for i = 1, #door_list do
								local random_door_id = door_list[i]
								local door_pos = nil
								
								if type(random_door_id) == "number" then
									door_pos = managers.navigation._room_doors[random_door_id].center
								else
									door_pos = random_door_id:script_data().element:nav_link_end_pos()
								end
								
								if door_pos then
									local dis = mvec3_dis_sq(door_pos, target_area.pos) 
									
									if not best_dis or best_dis < dis then
										best_detonate_pos = door_pos
										best_dis = dis
										shooter_pos = mvector3.copy(u_data.m_pos)
										shooter_u_data = u_data
									end
								end
							end
						end
					end
				end
			end
		end
		
		if best_detonate_pos then
			detonate_pos = best_detonate_pos
		end
		
		if detonate_pos and shooter_u_data then
			self:detonate_smoke_grenade(detonate_pos, shooter_pos, duration, false)
			self:apply_grenade_cooldown(nil)

			if shooter_u_data.char_tweak.chatter.smoke and not shooter_u_data.unit:sound():speaking(self._t) then
				self:chk_say_enemy_chatter(shooter_u_data.unit, shooter_u_data.m_pos, "smoke")
			end

			return true
		end
	end
end

function GroupAIStateBesiege:_chk_grenade_vis(detonate_pos, target_unit)
	if not target_unit then
		return
	end

	local head_pos = target_unit:movement():m_head_pos()
	local ray_hit = target_unit:raycast("ray", head_pos, detonate_pos, "slot_mask", managers.slot:get_mask("AI_visibility"), "ray_type", "ai_vision", "report")
	
	return not ray_hit
end

function GroupAIStateBesiege:_chk_group_use_flash_grenade(group, task_data, detonate_pos, target_area)
	if task_data.use_smoke then
		local shooter_pos, shooter_u_data = nil
		local duration = tweak_data.group_ai.flash_grenade_lifetime
		local criminal_pos = nil
		local chk_grenade_vis_func = self._chk_grenade_vis
		if not target_area then
			target_area = task_data.target_areas[1]
		end
		
		for c_key, c_data in pairs(target_area.criminal.units) do
			criminal_unit = c_data.unit
			criminal_pos = c_data.unit:movement():m_pos()

			break
		end
		
		for u_key, u_data in pairs(group.units) do
			if u_data.tactics_map and u_data.tactics_map.smoke_grenade then
				if not detonate_pos then
					local nav_seg_id = u_data.tracker:nav_segment()
					local nav_seg = managers.navigation._nav_segments[nav_seg_id]
					
					if not target_area then
						target_area = task_data.target_areas[1]
					end
					
					for neighbour_nav_seg_id, door_list in pairs(nav_seg.neighbours) do
						if target_area.nav_segs[neighbour_nav_seg_id] then
							for i = 1, #door_list do
								local random_door_id = door_list[i]
								local door_pos = nil
								
								if type(random_door_id) == "number" then
									door_pos = managers.navigation._room_doors[random_door_id].center
								else
									door_pos = random_door_id:script_data().element:nav_link_end_pos()
								end
								
								if door_pos then
									if chk_grenade_vis_func(self, door_pos, criminal_unit) then
										local dis = mvec3_dis_sq(door_pos, criminal_pos)
										
										if not best_dis or best_dis > dis then
											best_detonate_pos = door_pos
											best_dis = dis
											shooter_pos = mvector3.copy(u_data.m_pos)
											shooter_u_data = u_data
										end
									end
								end
							end
						end
					end
				end
			end
		end
		
		if best_detonate_pos then
			detonate_pos = best_detonate_pos
		end

		if detonate_pos and shooter_u_data then
			self:detonate_smoke_grenade(detonate_pos, shooter_pos, duration, true)
			self:apply_grenade_cooldown(true)

			if shooter_u_data.char_tweak.chatter.flash_grenade and not shooter_u_data.unit:sound():speaking(self._t) then
				self:chk_say_enemy_chatter(shooter_u_data.unit, shooter_u_data.m_pos, "flash_grenade")
			end

			return true
		end
	end
end

function GroupAIStateBesiege:_assign_group_to_retire(group)
	local retire_area, retire_pos = nil
	local start_area = group.objective.area
	
	if not start_area then
		local group_leader_u_key, group_leader_u_data = self._determine_group_leader(group.units)
		if group_leader_u_data then
			start_area = group_leader_u_data and self:get_area_from_nav_seg_id(group_leader_u_data.tracker:nav_segment())
		else
			for u_key, u_data in pairs_g(group.units) do
				start_area = self:get_area_from_nav_seg_id(u_data.tracker:nav_segment())
				
				if start_area then
					break
				end
			end
		end
	end
	
	local to_search_areas = {
		start_area
	}
	local found_areas = {
		[start_area] = true
	}

	repeat
		local search_area = table.remove(to_search_areas, 1)

		if search_area.flee_points and next(search_area.flee_points) then
			retire_area = search_area
			local flee_point_id, flee_point = next(search_area.flee_points)
			retire_pos = flee_point.pos

			break
		else
			for other_area_id, other_area in pairs(search_area.neighbours) do
				if not found_areas[other_area] then
					table.insert(to_search_areas, other_area)

					found_areas[other_area] = true
				end
			end
		end
	until #to_search_areas == 0

	if not retire_area then
		Application:error("[GroupAIStateBesiege:_assign_group_to_retire] flee point not found. from area:", inspect(group.objective.area), "group ID:", group.id)

		return
	end

	local grp_objective = {
		type = "retire",
		area = retire_area or group.objective.area,
		coarse_path = {
			{
				retire_area.pos_nav_seg,
				retire_area.pos
			}
		},
		pos = retire_pos
	}

	self:_set_objective_to_enemy_group(group, grp_objective)
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
		if task_spawn_allowance <= 0 and not self._silent_endless then
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
		if task_spawn_allowance <= 0 and not self._silent_endless then
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
		elseif t > end_t and not self._hunt_mode and not self._silent_endless then
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
	elseif not self._hunt_mode and not self._silent_endless then
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

	local primary_target_area = task_data.target_areas[1]

	if self:is_area_safe_assault(primary_target_area) then
		local target_pos = primary_target_area.pos
		local nearest_area, nearest_dis = nil

		for criminal_key, criminal_data in pairs(self._player_criminals) do
			if not criminal_data.status then
				local dis = mvector3.distance_sq(target_pos, criminal_data.m_pos)

				if not nearest_dis or dis < nearest_dis then
					nearest_dis = dis
					nearest_area = self:get_area_from_nav_seg_id(criminal_data.tracker:nav_segment())
				end
			end
		end

		if nearest_area then
			primary_target_area = nearest_area
			task_data.target_areas[1] = nearest_area
		end
		
		if self._street then 
			if self._current_objective_pos then
				local area_pos = self._current_objective_pos:with_z(0)
				local primary_target_area_pos = primary_target_area.pos:with_z(0)
				mvec3_dir(area_pos, primary_target_area_pos, area_pos)
				self._current_objective_dir = area_pos
				self._current_objective_dis = mvec3_dis_sq(primary_target_area_pos, area_pos)
			else
				self._current_objective_dis = nil
				self._current_objective_dir = nil
			end
		end
	end
	
	local phase = task_data.phase
	
	local nr_wanted = task_data.force - self:_count_police_force("assault")
	
	if task_data.phase == "anticipation" then
		nr_wanted = nr_wanted - 5
	end
	
	if primary_target_area and nr_wanted > 0 then
		if phase ~= "fade" or self._hunt_mode then 
			local used_event = next(self._spawning_groups)
			
			local anticipation = phase == "anticipation"

			if not used_event then
				
				if not anticipation or self._hunt_mode then
					self:_try_use_task_spawn_event(t, primary_target_area, "assault")
				end
				
				local max_dis = self._street and 6000 or 12000
				local spawn_group, spawn_group_type = self:_find_spawn_group_near_area(primary_target_area, self._tweak_data.assault.groups, primary_target_area.pos, max_dis, nil)

				if spawn_group then
					local grp_objective = {
						attitude = self._street and "avoid" or anticipation and "avoid" or "engage",
						stance = "hos",
						pose = anticipation and "crouch" or "stand",
						type = "assault_area",
						area = primary_target_area
					}

					self:_spawn_in_group(spawn_group, spawn_group_type, grp_objective, task_data)
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

function GroupAIStateBesiege:_verify_group_objective(group)
	local is_objective_broken = nil
	local grp_objective = group.objective
	local coarse_path = grp_objective.coarse_path
	local nav_segments = managers.navigation._nav_segments

	if coarse_path then
		for i = 1, #coarse_path do
			node = coarse_path[i]
			local nav_seg_id = node[1]

			if nav_segments[nav_seg_id].disabled then
				is_objective_broken = true

				break
			end
		end
	end

	if not is_objective_broken then
		return
	end

	local new_area = nil
	local tested_nav_seg_ids = {}

	for u_key, u_data in pairs(group.units) do
		u_data.tracker:move(u_data.m_pos)

		local nav_seg_id = u_data.tracker:nav_segment()

		if not tested_nav_seg_ids[nav_seg_id] then
			tested_nav_seg_ids[nav_seg_id] = true
			local areas = self:get_areas_from_nav_seg_id(nav_seg_id)

			for _, test_area in pairs(areas) do
				for test_nav_seg, _ in pairs(test_area.nav_segs) do
					if not nav_segments[test_nav_seg].disabled then
						new_area = test_area

						break
					end
				end

				if new_area then
					break
				end
			end
		end

		if new_area then
			break
		end
	end

	if not new_area then
		print("[GroupAIStateBesiege:_verify_group_objective] could not find replacement area to", grp_objective.area)

		return
	end
	
	group.objective = {
		moving_out = nil,
		type = grp_objective.type,
		area = new_area
	}
	group.in_place_t = self._t
end

function GroupAIStateBesiege:_assign_enemy_groups_to_assault(phase)
	for group_id, group in pairs_g(self._groups) do
		local grp_objective = group.objective
		if group.has_spawned and grp_objective.type == "assault_area" then
			if grp_objective.moving_out then
				local done_moving = self:_chk_group_area_presence(group, area_to_chk) --adapted to use this system as its much cleaner than the mess of code that was here previously

				if done_moving == true then
					grp_objective.moving_out = nil
					group.in_place_t = self._t
					grp_objective.moving_in = nil

					self:_voice_move_complete(group)
				end
			elseif not group.in_place_t then
				group.in_place_t = self._t
			end
			
			self:_set_assault_objective_to_group(group, phase)
		end
	end
end

function GroupAIStateBesiege:_upd_groups()
	for group_id, group in pairs_g(self._groups) do
		self:_verify_group_objective(group)

		for u_key, u_data in pairs_g(group.units) do
			if alive(u_data.unit) then
				if u_data.unit:brain() then
					local brain = u_data.unit:brain()
					local current_objective = brain:objective()

					if (not current_objective or current_objective.is_default or current_objective.grp_objective and current_objective.grp_objective ~= group.objective and not current_objective.grp_objective.no_retry) and (not group.objective.follow_unit or alive(group.objective.follow_unit)) then
						local objective = self._create_objective_from_group_objective(group.objective, u_data.unit)

						if objective and brain:is_available_for_assignment(objective) then
							self:set_enemy_assigned(objective.area or group.objective.area, u_key)

							if objective.element then
								objective.element:clbk_objective_administered(u_data.unit)
							end

							brain:set_objective(objective)
						end
					end
				else
					local line = Draw:brush(Color.blue:with_alpha(0.5), 10)
					line:cylinder(u_data.m_pos, u_data.m_pos + math_up * 6000, 100)
					log("please die")
					group.size = group.size - 1
					group.units[u_key] = nil
					if group.size <= 1 then
						self._groups[group_id] = nil
					end
				end
			else
				log("why are you like this, please")
				group.size = group.size - 1
				group.units[u_key] = nil
				
				if group.size <= 1 then
					self._groups[group_id] = nil
				end
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
	local phase_is_sustain = phase == "sustain" or self._hunt_mode
	local current_objective = group.objective
	
	local approach, open_fire, push, pull_back, charge, has_found_position = nil
	
	local group_leader_u_key, group_leader_u_data = self._determine_group_leader(group.units)
	local tactics_map = nil
	
	if group_leader_u_data and group_leader_u_data.tactics then
		tactics_map = {}
		
		--group_leader_u_data.tactics[#group_leader_u_data.tactics + 1] = "hunter"
		
		for i = 1, #group_leader_u_data.tactics do
			tactic_name = group_leader_u_data.tactics[i]
			tactics_map[tactic_name] = true
		end

		if current_objective.tactic and not tactics_map[current_objective.tactic] then
			current_objective.tactic = nil
			--group._last_updated_tactics_t = nil
		end
		
		if not phase_is_anticipation then			
			if current_objective.tactic then
				local follow_unit = current_objective.follow_unit
				
				if alive(follow_unit) then
					local crim_key = follow_unit:key()
					local crim_record = self._char_criminals[crim_key] 
					
					if crim_record then
						if current_objective.tactic == "hunter" then
							if crim_record.status and crim_record.status ~= "electrified" then
								current_objective.tactic = nil
							else
								local players_nearby = managers.player:_chk_fellow_crimin_proximity(follow_unit) 
								
								if players_nearby > 0 then
									current_objective.tactic = nil
								end
							end
						elseif current_objective.tactic == "deathguard" then
							if not crim_record.status or crim_record.status == "electrified" then
								current_objective.tactic = nil
							end
						end
					else
						current_objective.tactic = nil
					end
				else
					current_objective.tactic = nil
				end
			else
				for i = 1, #group_leader_u_data.tactics do
					tactic_name = group_leader_u_data.tactics[i]
					
					if tactic_name == "chase_test" then
						for u_key, u_data in pairs_g(self._player_criminals) do
							if u_data.unit then
								if not u_data.status or u_data.status == "electrified" then
									local closest_u_id, closest_u_data, closest_u_dis_sq = self._get_closest_group_unit_to_pos(u_data.m_pos, group.units)
									if closest_u_dis_sq then
										closest_crim_u_data = u_data
										closest_crim_dis_sq = closest_u_dis_sq
									end
								end
							end
						end
						
						if closest_crim_u_data then
							local end_nav_seg = managers.navigation:get_nav_seg_from_pos(closest_crim_u_data.m_pos, true)
							local grp_objective = {
								distance = 1500,
								type = "assault_area",
								attitude = "engage",
								tactic = "chase_test",
								moving_in = true,
								open_fire = true,
								follow_unit = closest_crim_u_data.unit,
								nav_seg = end_nav_seg
							}
							group.is_chasing = true
							
							--log("you're a cuck")
							
							self:_set_objective_to_enemy_group(group, grp_objective)

							return
						end
					elseif tactic_name == "hunter" then
						local closest_crim_u_data, closest_crim_dis_sq = nil
						local crim_dis_sq_chk = not closest_crim_dis_sq or closest_crim_dis_sq > closest_u_dis_sq
						
						for u_key, u_data in pairs_g(self._char_criminals) do
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
							local end_nav_seg = managers.navigation:get_nav_seg_from_pos(closest_crim_u_data.m_pos, true)
							local grp_objective = {
								distance = 1500,
								type = "assault_area",
								attitude = "engage",
								tactic = "hunter",
								moving_in = true,
								open_fire = true,
								follow_unit = closest_crim_u_data.unit,
								nav_seg = end_nav_seg
							}
							group.is_chasing = true

							self:_set_objective_to_enemy_group(group, grp_objective)

							return
						end
					elseif tactic_name == "deathguard" then
						if current_objective.tactic == tactic_name then
							for u_key, u_data in pairs_g(self._char_criminals) do
								if u_data.status and current_objective.follow_unit == u_data.unit then
									local crim_nav_seg = u_data.tracker:nav_segment()

									if current_objective.area.nav_segs[crim_nav_seg] then
										return
									end
								end
							end
						end

						local closest_crim_u_data, closest_crim_dis_sq = nil

						for u_key, u_data in pairs_g(self._char_criminals) do
							if u_data.status and u_data.status ~= "electrified" then
								local closest_u_id, closest_u_data, closest_u_dis_sq = self._get_closest_group_unit_to_pos(u_data.m_pos, group.units)

								if closest_u_dis_sq and closest_u_dis_sq < 1440000 and (not closest_crim_dis_sq or closest_u_dis_sq < closest_crim_dis_sq) then
									closest_crim_u_data = u_data
									closest_crim_dis_sq = closest_u_dis_sq
								end
							end
						end

						if closest_crim_u_data then
							local end_nav_seg = managers.navigation:get_nav_seg_from_pos(closest_crim_u_data.m_pos, true)
							local grp_objective = {
								distance = 800,
								type = "assault_area",
								attitude = "engage",
								tactic = "deathguard",
								open_fire = true,
								moving_in = true,
								follow_unit = closest_crim_u_data.unit,
								nav_seg = end_nav_seg
							}
							group.is_chasing = true

							self:_set_objective_to_enemy_group(group, grp_objective)
							self:_voice_deathguard_start(group)

							return
						end
					end
				end
			end
		else
			current_objective.tactic = nil
		end
	end
	
	if current_objective.tactic then --chasers wont try other objectives until the above cancels them to keep them on-track
		return
	end
	
	local obstructed_area = self:_chk_group_areas_tresspassed(group)

	local objective_area = nil
	
	if obstructed_area then
		--if one of the group members walk into a criminal then, if the phase is anticipation, they'll retreat backwards, otherwise, stand their ground and start shooting.
		--this will most likely always instantly kick in if the group has finished charging into an area.
	
		if phase_is_anticipation then 
			pull_back = true
		else
			objective_area = obstructed_area
			
			if not group.in_place_t or group.in_place_t and self._t - group.in_place_t > 2 then --if we're in the destination and we have stayed still for longer than 2 seconds, if anyone is camping in a specific spot, try to path to them
				push = true
			elseif not current_objective.open_fire or not current_objective.area or current_objective.area.id ~= obstructed_area.id then --have to check for this here or open_fire might not get set
				open_fire = true
			end
		end
	elseif current_objective.moving_in and not current_objective.tactic then
		if phase_is_anticipation then --anticipation groups being aggressive need to pull back
			pull_back = true
		elseif not current_objective.area or not next(current_objective.area.criminal.units) then --if theres suddenly no criminals in the area, start approaching instead
			if self._street or not phase_is_sustain then --details, details, build is generally less aggro than sustain
				approach = true
			else
				push = true
			end
		end
	else
		local forwardmost_i_nav_point = nil
		local area_to_chk = nil
		
		if current_objective.coarse_path then --if they were previously moving in, use their current coarse path for reference as that means they transitioned
			forwardmost_i_nav_point = self:_get_group_forwardmost_coarse_path_index(group)
		elseif current_objective.area then
			area_to_chk = current_objective.area
		end

		if forwardmost_i_nav_point then
			area_to_chk = self:get_area_from_nav_seg_id(current_objective.coarse_path[forwardmost_i_nav_point][1])
		end
				
		local has_criminals_closer = nil
		local has_criminals_close = nil
		
		--check up to two nav areas away, but first check the current area in case obstructed_area didn't proc
		if area_to_chk then
			if next(area_to_chk.criminal.units) then
				has_criminals_close = true
				has_criminals_closer = true
			else
				for area_id, neighbour_area in pairs_g(area_to_chk.neighbours) do
					if next(neighbour_area.criminal.units) then					
						has_criminals_close = neighbour_area
						break
					else					
						for alt_area_id, alt_area in pairs_g(neighbour_area.neighbours) do
							if next(alt_area.criminal.units) then
								has_criminals_close = alt_area
								break
							end
						end
					end
				end
			end
		end
	
		if has_criminals_closer then --open fire when enemies are in the current area we are in
			if phase_is_anticipation then
				pull_back = true
			else
				open_fire = true
			end
		elseif phase_is_anticipation and current_objective.open_fire then --if we were aggressive one update ago, start backing up away from the current objective area
			pull_back = true
		elseif not phase_is_anticipation and group.in_place_t and self._t - group.in_place_t > 10 or not self._street and phase_is_sustain then
			push = true --various checks for sustain, plus one to make sure that if we're a ranged fire team who refused to push due to street, we will eventually push anyways
		elseif has_criminals_close then
			if phase_is_anticipation then --stop early in our coarse path if theres criminals ahead
				pull_back = true
				objective_area = area_to_chk
			elseif self._street then --street behavior, stay in place a bit before pushes 
				if not group.in_place_t or group.in_place_t and self._t - group.in_place_t > 4 then 
					if not tactics_map or not tactics_map.ranged_fire and not tactics_map.elite_ranged_fire then
						objective_area = has_criminals_close
						push = true
					else
						objective_area = area_to_chk
						open_fire = true
					end
				else
					approach = true
					objective_area = area_to_chk
				end
			else
				if not tactics_map or not tactics_map.ranged_fire and not tactics_map.elite_ranged_fire or #has_criminals_close.police.units < 8 or group.in_place_t and self._t - group.in_place_t > 5 then
					--all these checks are here to ensure a well-maintained input of cops once units approach these areas, prevents occasional stand-stills from happening
					objective_area = has_criminals_close
					push = true
				else
					objective_area = area_to_chk
					open_fire = true
				end
			end
		else
			approach = true --continue approaching if none of the conditions above apply
		end
	end
	
	objective_area = objective_area or current_objective.area or group_leader_u_data and self:get_area_from_nav_seg_id(group_leader_u_data.tracker:nav_segment()) or self._task_data.assault.target_areas[1]
	
	if not objective_area then
		return
	end
	
	if not current_objective.area then
		current_objective.area = objective_area
	end

	if open_fire then
		local grp_objective = {
			attitude = "engage",
			pose = "stand",
			type = "assault_area",
			stance = "hos",
			open_fire = true,
			tactic = current_objective.tactic,
			area = obstructed_area or objective_area
		}

		group.is_chasing = nil
		self:_set_objective_to_enemy_group(group, grp_objective)
		self:_voice_open_fire_start(group)
	elseif approach or push then
		local assault_area, alternate_assault_area, alternate_assault_area_from, assault_path, alternate_assault_path = nil
		local to_search_areas = {
			objective_area
		}
		local found_areas = {
			[objective_area] = "init"
		}
		
		repeat
			local search_area = table_remove(to_search_areas, 1)
			
			if next(search_area.criminal.units) then
				local assault_from_here = true
				
				if not push then
					if tactics_map and tactics_map.flank then
						local assault_from_area = found_areas[search_area]

						if assault_from_area ~= "init" then
							local cop_units = assault_from_area.police.units

							for u_key, u_data in pairs_g(cop_units) do
								if u_data.group and u_data.group ~= group and u_data.group.objective.type == "assault_area" then
									assault_from_here = false
									
									if not alternate_assault_area or math_random() < 0.5 then
										local search_params = {
											id = "GroupAI_assault",
											from_seg = current_objective.area.pos_nav_seg,
											to_seg = search_area.pos_nav_seg,
											access_pos = self._get_group_acces_mask(group),
											long_path = true
										}
										alternate_assault_path = managers.navigation:search_coarse(search_params)
										
										if alternate_assault_path then
											--log("pog")
											self:_merge_coarse_path_by_area(alternate_assault_path)

											alternate_assault_area = search_area
											alternate_assault_area_from = assault_from_area
										end
									else
										alternate_assault_area = search_area
										alternate_assault_area_from = assault_from_area
									end

									found_areas[search_area] = nil

									break
								end
							end
						end
					end
				end

				if assault_from_here then
					local search_params = {
						id = "GroupAI_assault",
						from_seg = current_objective.area.pos_nav_seg,
						to_seg = search_area.pos_nav_seg,
						access_pos = self._get_group_acces_mask(group),
						long_path = tactics_map and tactics_map.flank and true or nil
					}
					assault_path = managers.navigation:search_coarse(search_params)

					if assault_path then
						--log("YOOOOOOOOOOOOOOOOOOOOOOOOO")
						self:_merge_coarse_path_by_area(assault_path)

						assault_area = search_area

						break
					end
				end
			else
				for other_area_id, other_area in pairs_g(search_area.neighbours) do
					if not found_areas[other_area] then
						table_insert(to_search_areas, other_area)

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
			local assault_area = push and assault_area or found_areas[assault_area] == "init" and objective_area or found_areas[assault_area]

			local used_grenade = nil
	
			if push then
				if current_objective.area.id == assault_area.id or current_objective.area.neighbours[assault_area] then
					if math_random() < 0.5 then
						used_grenade = self:_chk_group_use_flash_grenade(group, self._task_data.assault, detonate_pos, assault_area)
						
						if not used_grenade then
							used_grenade = self:_chk_group_use_smoke_grenade(group, self._task_data.assault, detonate_pos, assault_area)
						end
					else
						used_grenade = self:_chk_group_use_smoke_grenade(group, self._task_data.assault, detonate_pos, assault_area)
						
						if not used_grenade then
							used_grenade = self:_chk_group_use_flash_grenade(group, self._task_data.assault, detonate_pos, assault_area)
						end
					end
				end
			end
			
			if assault_path and #assault_path > 2 and assault_area.nav_segs[assault_path[#assault_path - 1][1]] then
				table_remove(assault_path)
			end
			
			if approach then
				table_remove(assault_path)
			end
			
			local grp_objective = {
				type = "assault_area",
				stance = "hos",
				area = self:get_area_from_nav_seg_id(assault_path[#assault_path][1]),
				coarse_path = assault_path or nil,
				pose = "stand",
				attitude = push and "engage" or "avoid",
				moving_in = push,
				open_fire = push,
				pushed = push,
				charge = push,
				interrupt_dis = nil
			}
			group.is_chasing = nil

			self:_set_objective_to_enemy_group(group, grp_objective)
		end
	elseif pull_back then
		local retreat_area = nil

		if not next(objective_area.criminal.units) then
			retreat_area = objective_area
		else
			for u_key, u_data in pairs_g(group.units) do
				local nav_seg_id = u_data.tracker:nav_segment()

				if self:is_nav_seg_safe(nav_seg_id) then
					retreat_area = self:get_area_from_nav_seg_id(nav_seg_id)

					break
				end
			end
		end

		if not retreat_area and current_objective.coarse_path then
			local forwardmost_i_nav_point = self:_get_group_forwardmost_coarse_path_index(group)

			if forwardmost_i_nav_point then
				local safe_i = 2
				local nearest_safe_area = self:get_area_from_nav_seg_id(current_objective.coarse_path[math.max(forwardmost_i_nav_point - safe_i, 1)][1])
				retreat_area = nearest_safe_area
			end
		end

		if retreat_area then
			local search_params = nil
			local retreat_path = nil
			
			if group_leader_u_data then
				search_params = {
					id = "GroupAI_pullback",
					from_tracker = group_leader_u_data.unit:movement():nav_tracker(),
					to_seg = retreat_area.pos_nav_seg,
					access_pos = self._get_group_acces_mask(group)
				}
				
				retreat_path = managers.navigation:search_coarse(search_params)
			end

			local new_grp_objective = {
				attitude = "avoid",
				stance = "hos",
				pose = "crouch",
				type = "assault_area",
				area = retreat_area,
				running = true,
				coarse_path = retreat_path or nil
			}
			group.is_chasing = nil

			self:_set_objective_to_enemy_group(group, new_grp_objective)

			return
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

		if grp_objective.follow_unit then --chase objectives use "follow" because fuck you
			objective.type = "follow"
			objective.follow_unit = grp_objective.follow_unit
			objective.distance = grp_objective.distance
		end
		
		objective.no_arrest = true
		objective.stance = "hos"
		objective.pose = "stand"
		objective.scan = true
		objective.interrupt_dis = nil
		objective.interrupt_suppression = nil
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
		objective.interrupt_dis = nil
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

function GroupAIStateBesiege:_chk_group_area_presence(group, area_to_chk) -- does exactly as named, checks if literally any member of the group is IN the area_to_chk
	if not area_to_chk then
		return
	end
	
	local id = area_to_chk.id
	
	local objective = group.objective
	local occupied_areas = {}

	for u_key, u_data in pairs(group.units) do
		if u_data and u_data.tracker then
			local nav_seg = u_data.tracker:nav_segment()

			for area_id, area in pairs(self._area_data) do
				if area.nav_segs[nav_seg] then
					occupied_areas[area_id] = area
				end
			end
		end
	end

	for area_id, area in pairs(occupied_areas) do
		if area_id == id then
			return area
		end
	end
end

function GroupAIStateBesiege:_set_objective_to_enemy_group(group, grp_objective)
	group.objective = grp_objective

	if grp_objective.area then
		if grp_objective.type == "retire" or not self:_chk_group_area_presence(group, grp_objective.area) then --making sure this even counts as something that the group needs to be "moving out" for
			grp_objective.moving_out = true
			--log("dicks")
		else
			grp_objective.moving_out = nil
			--log("dicks")
		end

		if not grp_objective.nav_seg and grp_objective.coarse_path then
			grp_objective.nav_seg = grp_objective.coarse_path[#grp_objective.coarse_path][1]
		end
	end

	grp_objective.assigned_t = self._t

	if self._AI_draw_data and self._AI_draw_data.group_id_texts[group.id] then
		self._AI_draw_data.panel:remove(self._AI_draw_data.group_id_texts[group.id])

		self._AI_draw_data.group_id_texts[group.id] = nil
	end
end

--made some changes here to allow recon groups to spawn even when theres no hostages to let players to cuff cops between assaults
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

	for area_id, area in pairs_g(all_areas) do
		if area.spawn_points then
			for _, sp_data in pairs_g(area.spawn_points) do
				if sp_data.delay_t <= t and not all_nav_segs[sp_data.nav_seg].disabled then
					table_insert(to_search_areas, area)

					found_areas[area_id] = true

					break
				end
			end
		end

		if not found_areas[area_id] and area.spawn_groups then
			for _, sp_data in pairs_g(area.spawn_groups) do
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

	if assault_candidates and self._char_criminals then
		for criminal_key, criminal_data in pairs_g(self._char_criminals) do
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

		if recon_candidates then
			if area.loot or area.hostages then
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
			else
				if nr_criminals and nr_criminals > 0 then
					table_insert(recon_candidates, area)
				end
			end
		end

		if recon_candidates or reenforce_candidates then
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
		local recon_area = nil
		
		for i = 1, #recon_candidates do
			local area = recon_candidates[i]
			recon_area = area
			
			if area.loot or area.hostages then
				break
			end
		end

		self:_begin_recon_task(recon_area)
	end

	if reenforce_candidates and #reenforce_candidates > 0 then
		local lucky_i_candidate = math_random(#reenforce_candidates)
		local reenforce_area = reenforce_candidates[lucky_i_candidate]

		self:_begin_reenforce_task(reenforce_area)

		recon_candidates = nil
	end
end

function GroupAIStateBesiege:_assign_enemy_groups_to_reenforce()
	for group_id, group in pairs(self._groups) do
		local grp_objective = group.objective
		
		if group.has_spawned and grp_objective.type == "reenforce_area" then
			local locked_up_in_area = nil
			
			if grp_objective.moving_out then
				local done_moving = true

				if done_moving then
					group.objective.moving_out = nil
					group.in_place_t = self._t
					group.objective.moving_in = nil

					self:_voice_move_complete(group)
				end
			end

			if not group.objective.moving_in then
				if not group.objective.moving_out then
					self:_set_reenforce_objective_to_group(group)
				end
			end
		end
	end
end

function GroupAIStateBesiege:_set_reenforce_objective_to_group(group)
	if not group.has_spawned then
		return
	end

	local current_objective = group.objective

	if current_objective.target_area then
		if current_objective.moving_out and not current_objective.moving_in then
			local forwardmost_i_nav_point = self:_get_group_forwardmost_coarse_path_index(group)

			if forwardmost_i_nav_point then
				for i = forwardmost_i_nav_point + 1, #current_objective.coarse_path do
					local nav_point = current_objective.coarse_path[forwardmost_i_nav_point]

					if not self:is_nav_seg_safe(nav_point[1]) then
						for i = 0, #current_objective.coarse_path - forwardmost_i_nav_point do
							table.remove(current_objective.coarse_path)
						end

						local grp_objective = {
							attitude = "avoid",
							scan = true,
							pose = "stand",
							type = "reenforce_area",
							stance = "hos",
							area = self:get_area_from_nav_seg_id(current_objective.coarse_path[#current_objective.coarse_path][1]),
							target_area = current_objective.target_area
						}

						self:_set_objective_to_enemy_group(group, grp_objective)

						return
					end
				end
			end
		end

		if not current_objective.moving_out and not current_objective.area.neighbours[current_objective.target_area.id] then
			local search_params = {
				id = "GroupAI_reenforce",
				from_seg = current_objective.area.pos_nav_seg,
				to_seg = current_objective.target_area.pos_nav_seg,
				access_pos = self._get_group_acces_mask(group),
				verify_clbk = callback(self, self, "is_nav_seg_safe")
			}
			local coarse_path = managers.navigation:search_coarse(search_params)

			if coarse_path then
				self:_merge_coarse_path_by_area(coarse_path)
				table.remove(coarse_path)

				local grp_objective = {
					scan = true,
					pose = "stand",
					type = "reenforce_area",
					stance = "hos",
					attitude = "avoid",
					area = self:get_area_from_nav_seg_id(coarse_path[#coarse_path][1]),
					target_area = current_objective.target_area,
					coarse_path = coarse_path
				}

				self:_set_objective_to_enemy_group(group, grp_objective)
			end
		end

		if not current_objective.moving_out and current_objective.area.neighbours[current_objective.target_area.id] and not next(current_objective.target_area.criminal.units) then
			local grp_objective = {
				stance = "hos",
				scan = true,
				pose = "crouch",
				type = "reenforce_area",
				attitude = "engage",
				area = current_objective.target_area
			}

			self:_set_objective_to_enemy_group(group, grp_objective)

			group.objective.moving_in = true
		end
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
