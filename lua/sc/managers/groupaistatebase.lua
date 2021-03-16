local mvec3_dot = mvector3.dot
local mvec3_set = mvector3.set
local mvec3_sub = mvector3.subtract
local mvec3_dis_sq = mvector3.distance_sq
local mvec3_dir = mvector3.direction
local mvec3_l_sq = mvector3.length_sq
local mvec3_cpy = mvector3.copy

local tmp_vec1 = Vector3()

local math_random = math.random
local math_floor = math.floor
local math_clamp = math.clamp
local math_lerp = math.lerp

local table_contains = table.contains

local ipairs_g = ipairs
local pairs_g = pairs
local next_g = next
local tostring_g = tostring

local alive_g = alive

function GroupAIStateBase:set_debug_draw_state(state)
	if state then
		if not self._draw_enabled then
			local ws = Overlay:newgui():create_screen_workspace()
			local panel = ws:panel()

			if Network:is_server() then
				self._AI_draw_data = {
					brush_area = Draw:brush(Color(0.33, 1, 1, 1)),
					brush_guard = Draw:brush(Color(0.5, 0, 0, 1)),
					brush_investigate = Draw:brush(Color(0.5, 0, 1, 0)),
					brush_defend = Draw:brush(Color(0.5, 0, 0.3, 0)),
					brush_free = Draw:brush(Color(0.5, 0.6, 0.3, 0)),
					brush_act = Draw:brush(Color(0.5, 1, 0.8, 0.8)),
					brush_misc = Draw:brush(Color(0.5, 1, 1, 1)),
					brush_suppressed = Draw:brush(Color(0.3, 0.85, 0.9, 0.2)),
					brush_detection = Draw:brush(Color(0.6, 1, 1, 1)),
					pen_focus_enemy = Draw:pen(Color(0.5, 1, 0.2, 0)),
					brush_focus_player = Draw:brush(Color(0.5, 1, 0, 0)),
					pen_group = Draw:pen(Color(1, 0.1, 0.4, 0.8)),
					workspace = ws,
					panel = panel,
					logic_name_texts = {},
					group_id_color = Color(1, 0.7, 0.1, 0),
					group_id_texts = {}
				}
			else
				self._AI_draw_data = {
					brush_suppressed = Draw:brush(Color(0.3, 0.85, 0.9, 0.2)),
					pen_focus_enemy = Draw:pen(Color(0.5, 1, 0.2, 0)),
					brush_focus_player = Draw:brush(Color(0.5, 1, 0, 0)),
					workspace = ws,
					panel = panel,
					logic_name_texts = {}
				}
			end
		end
	elseif self._draw_enabled then
		Overlay:newgui():destroy_workspace(self._AI_draw_data.workspace)

		self._AI_draw_data = nil
	end

	self._draw_enabled = state
end

function GroupAIStateBase:_calculate_difficulty_ratio()
	local ramp = tweak_data.group_ai.difficulty_curve_points

	--Use alternate curve points for skirmish difficulty ratio.
	if managers.skirmish:is_skirmish() then
		ramp = tweak_data.group_ai.skirmish_difficulty_curve_points
	end

	local diff = self._difficulty_value
	local i = 1

	while diff > (ramp[i] or 1) do
		i = i + 1
	end

	self._difficulty_point_index = i
	self._difficulty_ramp = (diff - (ramp[i - 1] or 0)) / ((ramp[i] or 1) - (ramp[i - 1] or 0))
	--log("Diff = " .. tostring(diff))
	--log("Index = " .. tostring(self._difficulty_point_index))
	--log("Value = " .. tostring(self._difficulty_ramp + self._difficulty_point_index))
end

function GroupAIStateBase:chk_say_teamAI_combat_chatter(unit)
	if not self._assault_mode or not self:is_detection_persistent() then
		return
	end

	local t = self._t

	local frequency_lerp = self._drama_data.amount
	local delay_tweak = tweak_data.sound.criminal_sound.combat_callout_delay
	local delay = math_lerp(delay_tweak[1], delay_tweak[2], frequency_lerp)
	local delay_t = self._teamAI_last_combat_chatter_t + delay

	if t < delay_t then
		return
	end

	--this is normally missing, so all the timer checks above become irrelevant after 10s of starting the heist
	self._teamAI_last_combat_chatter_t = t

	local frequency_lerp_clamp = math_clamp(frequency_lerp^2, 0, 1)
	local chance_tweak = tweak_data.sound.criminal_sound.combat_callout_chance
	local chance = math_lerp(chance_tweak[1], chance_tweak[2], frequency_lerp_clamp)

	if chance < math_random() then
		return
	end

	unit:sound():say("g90", true, true)
end

function GroupAIStateBase:_determine_objective_for_criminal_AI(unit)
	local objective, closest_dis, closest_player = nil
	local ai_pos = unit:movement():m_pos()

	for pl_key, player in pairs_g(self:all_player_criminals()) do
		if player.status ~= "dead" then
			local my_dis = mvec3_dis_sq(ai_pos, player.m_pos)

			if not closest_dis or my_dis < closest_dis then
				closest_dis = my_dis
				closest_player = player
			end
		end
	end

	if closest_player then
		objective = {
			scan = true,
			is_default = true,
			type = "follow",
			follow_unit = closest_player.unit
		}
	end

	if not objective then
		local mov_ext = unit:movement()

		if mov_ext._should_stay then
			mov_ext:set_should_stay(false)
		end

		if self:is_ai_trade_possible() then
			local hostage = managers.trade:get_best_hostage(ai_pos)

			if hostage and mvec3_dis_sq(ai_pos, hostage.m_pos) > 250000 then
				objective = {
					scan = true,
					type = "free",
					haste = "run",
					nav_seg = hostage.tracker:nav_segment()
				}
			end
		end
	end

	return objective
end

function GroupAIStateBase:_check_assault_panic_chatter()
	if self._t and self._last_killed_cop_t and self._t - self._last_killed_cop_t < math.random(1, 3.5) then
		return true
	end
	
	return
end

function GroupAIStateBase:_get_megaphone_sound_source()
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

local sc_group_misc_data = GroupAIStateBase._init_misc_data
function GroupAIStateBase:_init_misc_data()
	sc_group_misc_data(self)
	self._ponr_is_on = nil
	self._decay_target = 1
	self._min_detection_threshold = 1
	self._old_guard_detection_mul = 1
	self._guard_detection_mul = 1
	self._guard_detection_mul_raw = 0
	self._old_guard_detection_mul_raw = 0
	self._played_stealth_warning = 0
	self._guard_delay_deduction = 0		
	self._special_unit_types = {
		tank = true,
		tank_medic = true,
		tank_mini = true,
		tank_hw = true,
		tank_titan = true,
		tank_titan_assault = true,
		spooc = true,
		spooc_titan = true,
		shield = true,
		shield_titan = true,
		phalanx_minion = true,
		phalanx_minion_assault = true,
		taser = true,
		taser_titan = true,
		boom = true,
		boom_titan = true,
		heavy_swat_sniper = true,
		boom_summers = true,
		taser_summers = true,
		medic_summers = true,
		medic = true,
		medic_lpf = true,
		phalanx_vip = true,
		spring = true,
		headless_hatman = true,
		summers = true,
		autumn = true
	}
	
	local diff_index = tweak_data:difficulty_to_index(Global.game_settings.difficulty)
	local job = Global.level_data and Global.level_data.level_id

	if job == "hox_1" or job == "xmn_hox1" then
		self._starting_diff = 0.4
	else
		self._starting_diff = 0.1
	end

	self._starting_diff = managers.modifiers:modify_value("GroupAIStateBase:CheckingDiff", self._starting_diff)

	if diff_index <= 2 then
		self._weapons_hot_threshold = 0.70
		self._suspicion_threshold = 0.6
	elseif diff_index == 3 then
		self._weapons_hot_threshold = 0.65
		self._suspicion_threshold = 0.65
	elseif diff_index == 4 then
		self._weapons_hot_threshold = 0.60
		self._suspicion_threshold = 0.7
	elseif diff_index == 5 then
		self._weapons_hot_threshold = 0.55
		self._suspicion_threshold = 0.75
	elseif diff_index == 6 then
		self._weapons_hot_threshold = 0.50
		self._suspicion_threshold = 0.8
	elseif diff_index == 7 then
		self._weapons_hot_threshold = 0.50
		self._suspicion_threshold = 0.85
	else
		self._weapons_hot_threshold = 0.45
		self._suspicion_threshold = 0.9
	end
	self._blackout_units = {} --offy wuz hear
end

local sc_group_base = GroupAIStateBase.on_simulation_started
function GroupAIStateBase:on_simulation_started()
	sc_group_base(self)
	self._loud_diff_set = false --i really just dont want to take any chances
	self._ponr_is_on = nil
	self._min_detection_threshold = 1
	self._old_guard_detection_mul = 1
	self._guard_detection_mul = 1
	self._guard_detection_mul_raw = 0
	self._old_guard_detection_mul_raw = 0
	self._guard_delay_deduction = 0
	self._played_stealth_warning = 0
	self._special_unit_types = {
		tank = true,
		tank_medic = true,
		tank_mini = true,
		tank_hw = true,
		tank_titan = true,
		tank_titan_assault = true,
		spooc = true,
		spooc_titan = true,
		shield = true,
		shield_titan = true,
		phalanx_minion = true,
		phalanx_minion_assault = true,
		taser = true,
		taser_titan = true,
		boom = true,
		boom_titan = true,
		heavy_swat_sniper = true,
		boom_summers = true,
		taser_summers = true,
		medic_summers = true,
		medic = true,
		medic_lpf = true,
		phalanx_vip = true,
		spring = true,
		headless_hatman = true,
		summers = true,
		autumn = true
	}
	
	local diff_index = tweak_data:difficulty_to_index(Global.game_settings.difficulty)
	
	if diff_index <= 2 then
		self._weapons_hot_threshold = 0.70
		self._suspicion_threshold = 0.6
	elseif diff_index == 3 then
		self._weapons_hot_threshold = 0.65
		self._suspicion_threshold = 0.65
	elseif diff_index == 4 then
		self._weapons_hot_threshold = 0.60
		self._suspicion_threshold = 0.7
	elseif diff_index == 5 then
		self._weapons_hot_threshold = 0.55
		self._suspicion_threshold = 0.75
	elseif diff_index == 6 then
		self._weapons_hot_threshold = 0.50
		self._suspicion_threshold = 0.8
	elseif diff_index == 7 then
		self._weapons_hot_threshold = 0.50
		self._suspicion_threshold = 0.85
	else
		self._weapons_hot_threshold = 0.45
		self._suspicion_threshold = 0.9
	end
	
end

function GroupAIStateBase:chk_guard_detection_mul()
	self._guard_detection_mul = 1 + self._guard_detection_mul_raw
	if self._hostages_killed then
		return self._guard_detection_mul * (self._hostages_killed + 1)
	else
		return self._guard_detection_mul * 1
	end
end

function GroupAIStateBase:chk_guard_delay_deduction()
	if self._hostages_killed then
		return self._guard_delay_deduction * (self._hostages_killed * 0.25)
	else
		return self._guard_delay_deduction * 1
	end
end	

function GroupAIStateBase:set_point_of_no_return_timer(time, point_of_no_return_id)
	if time == nil or setup:has_queued_exec() then
		return
	end

	self._forbid_drop_in = true
	self._ponr_is_on = true
	
	managers.network.matchmake:set_server_joinable(false)

	if not self._peers_inside_point_of_no_return then
		self._peers_inside_point_of_no_return = {}
	end

	self._point_of_no_return_timer = time
	self._point_of_no_return_id = point_of_no_return_id
	self._point_of_no_return_areas = nil

	managers.hud:show_point_of_no_return_timer()
	managers.hud:add_updator("point_of_no_return", callback(self, self, "_update_point_of_no_return"))
	--log("setting diff to 1!!")
	self:set_difficulty(nil, 1)
end

function GroupAIStateBase:_update_point_of_no_return(t, dt)
	if setup:has_queued_exec() then
		managers.hud:hide_point_of_no_return_timer()
		managers.hud:remove_updator("point_of_no_return")

		return
	end

	local function get_mission_script_element(id)
		for name, script in pairs_g(managers.mission:scripts()) do
			if script:element(id) then
				return script:element(id)
			end
		end
	end

	local prev_time = self._point_of_no_return_timer
	self._point_of_no_return_timer = self._point_of_no_return_timer - dt
	local sec = math_floor(self._point_of_no_return_timer)

	if sec < math_floor(prev_time) then
		managers.hud:flash_point_of_no_return_timer(sec <= 10)
	end

	if not self._point_of_no_return_areas then
		self._point_of_no_return_areas = {}
		local ponr_id = self._point_of_no_return_id
		local element = ponr_id and get_mission_script_element(ponr_id)

		if element then
			local element_elements = element._values.elements

			for i = 1, #element_elements do
				local id = element_elements[i]
				local area = id and get_mission_script_element(id)

				if area then
					self._point_of_no_return_areas[#self._point_of_no_return_areas + 1] = area
				end
			end
		end

		if #self._point_of_no_return_areas == 0 then
			self:check_ponr_escape_area()
		end
	end

	local is_inside = false
	local plr_unit = managers.player:player_unit()

	if plr_unit then
		local ponr_areas = self._point_of_no_return_areas

		for i = 1, #ponr_areas do
			local area = ponr_areas[i]
			local shapes = area._shapes

			for idx = 1, #shapes do
				local shape = shapes[idx]

				if shape:is_inside(plr_unit:movement():m_pos()) then
					--shape:draw(0, 0, 0, 1, 0, 0.2)

					is_inside = true

					break
				--else
					--shape:draw(0, 0, 0, 0, 1, 0.2)
				end
			end

			--[[local shape_elements = area._shape_elements

			if shape_elements then
				for idx = 1, #shape_elements do
					local shapes = shape_elements[idx]:get_shapes()

					for idx2 = 1, #shapes do
						local shape = shapes[idx2]

						shape:draw(0, 0, 0, 1, 1, 0.2)
					end
				end
			end]]
		end
	end

	if is_inside ~= self._is_inside_point_of_no_return then
		self._is_inside_point_of_no_return = is_inside

		local session = managers.network:session()

		if managers.network:session() then
			if not Network:is_server() then
				session:send_to_host("is_inside_point_of_no_return", is_inside)
			else
				self:set_is_inside_point_of_no_return(session:local_peer():id(), is_inside)
			end
		end
	end

	if self._point_of_no_return_timer <= 0 then
		managers.hud:remove_updator("point_of_no_return")

		if not is_inside then
			self._failed_point_of_no_return = true
		end

		if Network:is_server() then
			if managers.platform:presence() == "Playing" then
				local num_is_inside = 0

				for _, peer_inside in pairs_g(self._peers_inside_point_of_no_return) do
					num_is_inside = num_is_inside + (peer_inside and 1 or 0)
				end

				if num_is_inside > 0 then
					local num_winners = num_is_inside + self:amount_of_winning_ai_criminals()

					managers.network:session():send_to_peers("mission_ended", true, num_winners)
					game_state_machine:change_state_by_name("victoryscreen", {
						num_winners = num_winners,
						personal_win = is_inside
					})
				else
					managers.network:session():send_to_peers("mission_ended", false, 0)
					game_state_machine:change_state_by_name("gameoverscreen")
				end
			end

			local element = get_mission_script_element(self._point_of_no_return_id)
			local element_elements = element._values.elements

			for i = 1, #element_elements do
				local id = element_elements[i]
				local area = id and get_mission_script_element(id)

				if area then
					area:execute_on_executed(nil)
				end
			end
		end

		managers.hud:feed_point_of_no_return_timer(0, is_inside)
	else
		managers.hud:feed_point_of_no_return_timer(self._point_of_no_return_timer, is_inside)
	end
end

function GroupAIStateBase:check_ponr_escape_area()
	if not self._point_of_no_return_areas or setup:has_queued_exec() then
		return
	end

	for name, script in pairs_g(managers.mission:scripts()) do
		for id, element in pairs_g(script:elements()) do
			if element._shapes and element._callback then
				local values = element._values
				local instigator = values and values.enabled and values.instigator

				if instigator == "player" and values.amount == "all" then
					local trigger = values.trigger_on

					if trigger == "on_enter" or trigger == "while_inside" then
						if not self._point_of_no_return_areas[1] or not table_contains(self._point_of_no_return_areas, element) then
							self._point_of_no_return_areas[#self._point_of_no_return_areas + 1] = element
						end
					end
				end
			end
		end
	end

	managers.enemy:add_delayed_clbk("check_ponr_escape_area", callback(self, self, "check_ponr_escape_area"), self._t + 0.5)
end
		
function GroupAIStateBase:_radio_chatter_clbk()
	if self._ai_enabled and not self:whisper_mode() then
		local optimal_dist = 500
		local best_dist, best_cop, radio_msg = nil

		for _, c_record in pairs_g(self._player_criminals) do
			for i, e_key in ipairs_g(c_record.important_enemies) do
				local cop = self._police[e_key]
				local use_radio = cop.char_tweak.use_radio

				if use_radio then
					if cop.char_tweak.radio_prefix then
						use_radio = cop.char_tweak.radio_prefix .. use_radio
					end

					local dist = math.abs(mvector3.distance(cop.m_pos, c_record.m_pos))

					if not best_dist or dist < best_dist then
						best_dist = dist
						best_cop = cop
						radio_msg = use_radio
					end
				end
			end
		end

		if best_cop then
			best_cop.unit:sound():play(radio_msg, nil, true)
		end
	end

	self._radio_clbk = callback(self, self, "_radio_chatter_clbk")

	managers.enemy:add_delayed_clbk("_radio_chatter_clbk", self._radio_clbk, Application:time() + 30 + math.random(0, 20))
end	

function GroupAIStateBase:_draw_current_logics()
	for key, data in pairs_g(self._police) do
		if data.unit:brain() and data.unit:brain().is_current_logic then
			local brain = data.unit:brain()
			
			if brain:is_current_logic("arrest") then
				local draw_duration = 0.1
				local new_brush = Draw:brush(Color.blue:with_alpha(1), draw_duration)
				new_brush:sphere(data.unit:movement():m_head_pos(), 20)
			elseif brain:is_current_logic("attack") then
				local draw_duration = 0.1
				local new_brush = Draw:brush(Color.red:with_alpha(1), draw_duration)
				new_brush:sphere(data.unit:movement():m_head_pos(), 20)
			elseif brain:is_current_logic("base") then
				local draw_duration = 0.1
				local new_brush = Draw:brush(Color.white:with_alpha(0.5), draw_duration)
				new_brush:sphere(data.unit:movement():m_head_pos(), 20)
			elseif brain:is_current_logic("flee") then
				local draw_duration = 0.1
				local new_brush = Draw:brush(Color.orange:with_alpha(0.5), draw_duration)
				new_brush:sphere(data.unit:movement():m_head_pos(), 20)
			elseif brain:is_current_logic("guard") then
				local draw_duration = 0.1
				local new_brush = Draw:brush(Color.blue:with_alpha(0.1), draw_duration)
				new_brush:sphere(data.unit:movement():m_head_pos(), 20)
			elseif brain:is_current_logic("idle") then
				local draw_duration = 0.1
				local new_brush = Draw:brush(Color.green:with_alpha(0.5), draw_duration)
				new_brush:sphere(data.unit:movement():m_head_pos(), 20)
			elseif brain:is_current_logic("inactive") then
				local draw_duration = 0.1
				local new_brush = Draw:brush(Color.black:with_alpha(0.5), draw_duration)
				new_brush:sphere(data.unit:movement():m_head_pos(), 20)
			elseif brain:is_current_logic("intimidated") then
				local draw_duration = 0.1
				local new_brush = Draw:brush(Color.black:with_alpha(0.5), draw_duration)
				new_brush:sphere(data.unit:movement():m_head_pos(), 20)
			elseif brain:is_current_logic("sniper") then
				local draw_duration = 0.1
				local new_brush = Draw:brush(Color.red:with_alpha(0.1), draw_duration)
				new_brush:sphere(data.unit:movement():m_head_pos(), 20)
			elseif brain:is_current_logic("travel") then
				local draw_duration = 0.1
				local new_brush = Draw:brush(Color.yellow:with_alpha(0.5), draw_duration)
				new_brush:sphere(data.unit:movement():m_head_pos(), 20)
			end
		end
	end
end

function GroupAIStateBase:find_followers_to_unit(leader_key, leader_data)
	local leader_u_data = self._police[leader_key]
	if not leader_u_data then
		return
	end
	leader_u_data.followers = leader_u_data.followers or {}
	local followers = leader_u_data.followers
	local nr_followers = #followers
	local max_nr_followers = leader_data.max_nr_followers
	if nr_followers >= max_nr_followers then
		return
	end
	local wanted_nr_new_followers = max_nr_followers - nr_followers
	local leader_unit = leader_u_data.unit
	local leader_nav_seg = leader_u_data.tracker:nav_segment()
	local objective = {
		type = "follow",
		follow_unit = leader_unit,
		scan = true,
		nav_seg = leader_nav_seg,
		stance = "cbt",
		distance = 600
	}
	local candidates = {}
	for u_key, u_data in pairs_g(self._police) do
		if u_data.assigned_area and not u_data.follower and u_data.char_tweak.follower and u_data.tracker:nav_segment() == leader_nav_seg and u_data.unit:brain():is_available_for_assignment(objective) then
			table.insert(followers, u_key)
			u_data.follower = leader_key
			local new_follow_objective = clone(objective)
			new_follow_objective.fail_clbk = callback(self, self, "clbk_follow_objective_failed", {
				leader_u_data = leader_u_data,
				follower_unit = u_data.unit
			})
			u_data.unit:brain():set_objective(new_follow_objective)
			if #candidates == wanted_nr_new_followers then
				break
			end
		end
	end
end

function GroupAIStateBase:chk_has_followers(leader_key)
	local leader_u_data = self._police[leader_key]
	if leader_u_data and next(leader_u_data.followers) then
		return true
	end
end

function GroupAIStateBase:are_followers_ready(leader_key)
	local leader_u_data = self._police[leader_key]
	if not leader_u_data or not leader_u_data.followers then
		return true
	end
	for i, follower_key in ipairs_g(leader_u_data.followers) do
		local follower_u_data = self._police[follower_key]
		local objective = follower_u_data.unit:brain():objective()
		if objective and not objective.in_place then
			return
		end
	end
	return true
end

function GroupAIStateBase:clbk_follow_objective_failed(data)
	local leader_u_data = data.leader_u_data
	local follower_unit = data.follower_unit
	local follower_key = follower_unit:key()
	for i, _follower_key in ipairs_g(leader_u_data.followers) do
		if _follower_key == follower_key then
			table.remove(leader_u_data.followers, i)
			break
		end
	end
	local follower_u_data = self._police[follower_key]
	if follower_u_data then
		follower_u_data.follower = nil
	end
end

function GroupAIStateBase:_get_balancing_multiplier(balance_multipliers)
	local nr_players = 0
	for u_key, u_data in pairs_g(self:all_criminals()) do
		if not u_data.status then
			nr_players = nr_players + 1
		end
	end
	nr_players = math.clamp(nr_players, 1, 4)
	return balance_multipliers[nr_players]
end

function GroupAIStateBase:queue_smoke_grenade(id, detonate_pos, shooter_pos, duration, ignore_control, flashbang)
	self._smoke_grenades = self._smoke_grenades or {}
	local data = {
		id = id,
		detonate_pos = detonate_pos,
		shooter_pos = shooter_pos,
		duration = duration,
		ignore_control = ignore_control,
		flashbang = flashbang
	}
	self._smoke_grenades[id] = data
end

function GroupAIStateBase:detonate_world_smoke_grenade(id)
	self._smoke_grenades = self._smoke_grenades or {}

	if not self._smoke_grenades[id] then
		--Application:error("Could not detonate smoke grenade as it was not queued!", id)
		return
	end

	local job = Global.level_data and Global.level_data.level_id

	if job == "haunted" then
		self._smoke_grenades = nil --delete queue

		return
	end

	local data = self._smoke_grenades[id]

	if data.flashbang then
		if Network:is_client() then
			return
		end

		local det_pos = data.detonate_pos
		local ray_to = mvector3.copy(det_pos) + math.UP * 5

		mvector3.set_z(ray_to, ray_to.z - 50)

		local ground_ray = World:raycast("ray", det_pos, ray_to, "slot_mask", managers.slot:get_mask("world_geometry, statics"))

		if ground_ray then
			det_pos = ground_ray.hit_position
			mvector3.set_z(det_pos, det_pos.z + 3)
			data.detonate_pos = det_pos
		end

		local rotation = Rotation(math.random() * 360, 0, 0)
		local difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
		local difficulty_index = tweak_data:difficulty_to_index(difficulty)
		local flashbang_unit = nil

		if difficulty_index == 8 then
			flashbang_unit = "units/payday2/weapons/wpn_frag_sc_flashbang/wpn_frag_sc_flashbang"
		else
			flashbang_unit = "units/payday2/weapons/wpn_frag_flashbang/wpn_frag_flashbang"
		end

		local flash_grenade = World:spawn_unit(Idstring(flashbang_unit), det_pos, rotation)
		local shoot_from_pos = data.shooter_pos or det_pos
		flash_grenade:base():activate(shoot_from_pos, data.duration)

		self._smoke_grenades[id] = nil
	else
		data.duration = data.duration == 0 and 15 or data.duration
		local det_pos = data.detonate_pos
		local ray_to = mvector3.copy(det_pos) + math.UP * 5

		mvector3.set_z(ray_to, ray_to.z - 50)

		local ground_ray = World:raycast("ray", det_pos, ray_to, "slot_mask", managers.slot:get_mask("world_geometry, statics"))

		if ground_ray then
			det_pos = ground_ray.hit_position
			mvector3.set_z(det_pos, det_pos.z + 3)
			data.detonate_pos = det_pos
		end

		local rotation = Rotation(math.random() * 360, 0, 0)
		local smoke_grenade_id = Idstring("units/weapons/smoke_grenade_quick/smoke_grenade_quick")
		smoke_grenade_id = managers.modifiers:modify_value("GroupAIStateBase:SpawningSmoke", smoke_grenade_id)
		local smoke_grenade = World:spawn_unit(smoke_grenade_id, det_pos, rotation)
		local shoot_from_pos = data.shooter_pos or det_pos
		--log("spawning smoke!! was it tear gas?")
		smoke_grenade:base():activate(shoot_from_pos, data.duration)

		local voice_line = "g40x_any"
		voice_line = managers.modifiers:modify_value("GroupAIStateBase:CheckingVoiceLine", voice_line)
		managers.groupai:state():teammate_comment(nil, voice_line, det_pos, true, 2000, false)

		data.grenade = smoke_grenade
		self._smoke_end_t = Application:time() + data.duration
	end
end

function GroupAIStateBase:sync_smoke_grenade(detonate_pos, shooter_pos, duration, flashbang)
	self._smoke_grenades = self._smoke_grenades or {}
	local id = #self._smoke_grenades

	self:queue_smoke_grenade(id, detonate_pos, shooter_pos, duration, true, flashbang)
	self:detonate_world_smoke_grenade(id)
end

function GroupAIStateBase:sync_smoke_grenade_kill()
	if self._smoke_grenades then
		for id, data in pairs_g(self._smoke_grenades) do
			if alive(data.grenade) and data.grenade:base() and data.grenade:base().preemptive_kill then
				data.grenade:base():preemptive_kill()
			end
		end

		self._smoke_grenades = {}
		self._smoke_end_t = nil
	end
end

function GroupAIStateBase:smoke_and_flash_grenades()
	return self._smoke_grenades
end

--No longer increases with more players, also ignores converts.
function GroupAIStateBase:has_room_for_police_hostage()
	local nr_hostages_allowed = 4

	return nr_hostages_allowed > self._police_hostage_headcount
end

function GroupAIStateBase:propagate_alert(alert_data)
	if managers.network:session() and Network and not Network:is_server() then
		managers.network:session():send_to_host("propagate_alert", alert_data[1], alert_data[2], alert_data[3], alert_data[4], alert_data[5], alert_data[6])

		return
	end

	local nav_manager = managers.navigation
	local access_func = nav_manager.check_access
	local alert_type = alert_data[1]
	local all_listeners = self._alert_listeners
	local listeners_by_type = all_listeners[alert_type]

	if listeners_by_type then
		local proximity_chk_func = nil
		local alert_epicenter = alert_data[2]

		if alert_epicenter then
			local alert_rad_sq = alert_data[3] * alert_data[3]
			if self._enemy_weapons_hot then
				alert_rad_sq = 4500 * 4500
			end


			function proximity_chk_func(listener_pos)
				return mvec3_dis_sq(alert_epicenter, listener_pos) < alert_rad_sq
			end
		else

			function proximity_chk_func()
				return true
			end
		end

		local alert_filter = alert_data[4]
		local clbks = nil

		for filter_str, listeners_by_type_and_filter in pairs_g(listeners_by_type) do
			local key, listener = next(listeners_by_type_and_filter, nil)
			local filter_num = listener.filter

			if access_func(nav_manager, filter_num, alert_filter, nil) then
				for id, listener in pairs_g(listeners_by_type_and_filter) do
					if proximity_chk_func(listener.m_pos) then
						clbks = clbks or {}

						table.insert(clbks, listener.clbk)
					end
				end
			end
		end

		if clbks then
			for _, clbk in ipairs_g(clbks) do
				clbk(alert_data)
			end
		end
	end
end

--Gameover now happens after ~30 seconds instead of 10 seconds, allowing Stockholm Syndrome and Messiah to function correctly
function GroupAIStateBase:check_gameover_conditions()
	if not Network:is_server() or managers.platform:presence() ~= "Playing" or setup:has_queued_exec() then
		return false
	end

	if game_state_machine:current_state().game_ended and game_state_machine:current_state():game_ended() then
		return false
	end

	if Global.load_start_menu or Application:editor() then
		return false
	end

	if not self:whisper_mode() and self._super_syndrome_peers and self:hostage_count() > 0 then
		for _, active in pairs_g(self._super_syndrome_peers) do
			if active then
				return false
			end
		end
	end

	local plrs_alive = false
	local plrs_disabled = true

	for u_key, u_data in pairs_g(self._player_criminals) do
		plrs_alive = true

		if u_data.status ~= "dead" and u_data.status ~= "disabled" then
			plrs_disabled = false

			break
		end
	end

	local ai_alive = false
	local ai_disabled = true

	for u_key, u_data in pairs_g(self._ai_criminals) do
		ai_alive = true

		if u_data.status ~= "dead" and u_data.status ~= "disabled" then
			ai_disabled = false

			break
		end
	end

	local gameover = false

	if not plrs_alive and not self:is_ai_trade_possible() then
		gameover = true
	elseif plrs_disabled and not ai_alive then
		gameover = true
	elseif plrs_disabled and ai_disabled then
		gameover = true
	end

	gameover = gameover or managers.skirmish:check_gameover_conditions()

	if gameover then
		if not self._gameover_clbk then
			self._gameover_clbk = callback(self, self, "_gameover_clbk_func")

			managers.enemy:add_delayed_clbk("_gameover_clbk", self._gameover_clbk, Application:time() + 25)
		end
	elseif self._gameover_clbk then
		managers.enemy:remove_delayed_clbk("_gameover_clbk")

		self._gameover_clbk = nil
	end

	return gameover
end

Hooks:Add("NetworkReceivedData", "restoration_sync_level_suspicion_from_host", function(sender, message, data)
	if message == "restoration_sync_level_suspicion" then 
		if sender == 1 then 
			local data_tbl = string.split(data,":")
			if data_tbl and #data_tbl > 0 then 
				local groupai_state = managers.groupai:state()
				if data_tbl[1] and data_tbl[2] and groupai_state then
					groupai_state._dummy_old_guard_detection_mul_raw = tonumber(data_tbl[1])
					groupai_state._dummy_alarm_threshold = tonumber(data_tbl[2])
				end
			end
		end
	elseif message == "restoration_drop_ammo" then
		--[[
		if Network:is_server() then
			local data_tbl = string.split(data,":") or {}
			if data_tbl and #data_tbl > 0 then 
				local upgrade_level = 0
				local bullet_storm_level = 0
				local loss_rate = 0.0
				local placement_cost = 0.3
				local pos = Vector3(tonumber(data_tbl[1]) or 0,tonumber(data_tbl[2]) or 0, tonumber(data_tbl[3]) or 0)
				local rot = Rotation(tonumber(data_tbl[4]) or 0,tonumber(data_tbl[5]) or 0, tonumber(data_tbl[6]) or 0)
				local ammo_ratio_taken = tonumber(data_tbl[7]) or 1
				if ammo_ratio_taken < 1 then 
					local unit = AmmoBagBase.spawn(pos, rot, upgrade_level, sender or managers.network:session():local_peer():id(), bullet_storm_level)
					unit:base()._ammo_amount = math.floor(math.min(ammo_ratio_taken,placement_cost) * (1 - loss_rate) * 100) / 100
					local current_amount = unit:base()._ammo_amount
					unit:base():_set_visual_stage()
					managers.network:session():send_to_peers_synched("sync_ammo_bag_ammo_taken", unit, current_amount - ammo_ratio_taken)						
				end
			end
		end
		]]
	end
end)


function GroupAIStateBase:update(t, dt)
	self._t = t
	self:_upd_criminal_suspicion_progress()
	
	local is_whisper_mode = managers.groupai:state():whisper_mode()
	
	local level_suspicion,alarm_threshold
	if Network:is_server() then 
		--use suspicion values
		level_suspicion = self._old_guard_detection_mul_raw
		alarm_threshold = self._weapons_hot_threshold
		--self:_draw_current_logics()
	else
		--use suspicion values synced from host
		level_suspicion = self._dummy_old_guard_detection_mul_raw or 0
		alarm_threshold = self._dummy_alarm_threshold or 0
	end
	
	if self._suspicion_interpolated then
		local delta_suspicion = level_suspicion - self._suspicion_interpolated
		if delta_suspicion < 0.0001 then 
			--has caught up to actual value (or close enough)
			self._suspicion_interpolated = level_suspicion
		else
			local animate_duration = 1 --approximate time in seconds for interpolated value to catch up to actual value
			self._suspicion_interpolated = math.min(level_suspicion,0.0005 + self._suspicion_interpolated + (delta_suspicion * (dt / animate_duration)))
		end
	else
		--init value
		self._suspicion_interpolated = level_suspicion
	end

	local is_server = Network:is_server()

	managers.hud:_upd_animate_level_suspicion(t,level_suspicion,alarm_threshold,self._suspicion_interpolated,is_whisper_mode)

	if is_server and self._last_detection_mul and self._last_detection_mul ~= self._old_guard_detection_mul_raw then 
		LuaNetworking:SendToPeers("restoration_sync_level_suspicion",tostring(self._old_guard_detection_mul_raw) .. ":" .. tostring(self._weapons_hot_threshold))
	end
			
	
	
	if is_whisper_mode then
		local warning_1_threshold = self._weapons_hot_threshold * 0.25
		local warning_2_threshold = self._weapons_hot_threshold * 0.5
		local warning_3_threshold = self._weapons_hot_threshold * 0.75
			
		if self._played_stealth_warning < 1 and self._old_guard_detection_mul_raw >= warning_1_threshold then
			--log("warning1")
			self._played_stealth_warning = 1 
		end
			
		if self._played_stealth_warning < 2 and self._old_guard_detection_mul_raw >= warning_2_threshold then
			--log("warning2")
			self._played_stealth_warning = 2 
		end
			
		if self._played_stealth_warning < 3 and self._old_guard_detection_mul_raw >= warning_3_threshold then
			--log("warning3")
			self._played_stealth_warning = 3
		end
			
		if self._old_guard_detection_mul_raw >= self._weapons_hot_threshold then
			if not self._alarm_t then 
				self._alarm_t = self._t + 60
			end
				
			if self._played_stealth_warning < 4 then
				managers.dialog:queue_dialog("Play_pln_pat_03", {})
				self._played_stealth_warning = 4
			end
				
			if self._played_stealth_warning < 5 and self._alarm_t - 30 < t then
				managers.dialog:queue_dialog("Play_pln_pat_04", {})
				self._played_stealth_warning = 5
			end
				
			if self._played_stealth_warning < 6 and self._alarm_t - 50 < t then
				managers.dialog:queue_dialog("Play_pln_pat_05", {})
				self._played_stealth_warning = 6
			end

			if is_server then
				if self._alarm_t < t then
					self:on_police_called("sys_police_alerted")
					--log("uhohstinkyyyy")
				end
			end
		end
		
		if self._decay_target and self._next_whisper_susp_mul_t and self._next_whisper_susp_mul_t < t then
			self:_upd_whisper_suspicion_mul_decay(t)
		end
	end
	
	if self._draw_drama then
		self:_debug_draw_drama(t)
	end

	self:_upd_debug_draw_attentions()

	if is_server then
		local check_t = self._team_ai_dist_t

		if not check_t or check_t < t then
			self._team_ai_dist_t = t + 1

			if self:team_ai_enabled() then
				self:upd_team_AI_distance()
			end
		end
	end

	self._last_detection_mul = self._old_guard_detection_mul_raw --used purely for suspicion meter syncing
end

local invalid_player_bot_warp_states = {
	jerry1 = true,
	jerry2 = true,
	driving = true
}

local teleport_SO_anims = {
	e_so_teleport_var1 = true,
	e_so_teleport_var2 = true,
	e_so_teleport_var3 = true
}

function GroupAIStateBase:upd_team_AI_distance()
	local ai_criminals = self:all_AI_criminals()

	if not next_g(ai_criminals) then
		return
	end

	local player_criminals = self:all_player_criminals()

	if not next_g(player_criminals) then
		return
	end

	local teleport_distance = tweak_data.team_ai.stop_action.teleport_distance * tweak_data.team_ai.stop_action.teleport_distance
	local nav_manager = managers.navigation
	local find_cover_f = nav_manager.find_cover_in_nav_seg_3
	local search_coarse_f = nav_manager.search_coarse

	for ai_key, ai in pairs_g(ai_criminals) do
		local unit = ai.unit
		local ai_mov_ext = unit:movement()

		if not ai_mov_ext:cool() then
			local objective = unit:brain():objective()
			local has_warp_objective = nil

			if objective then
				if objective.path_style == "warp" or teleport_SO_anims[objective.action]then
					has_warp_objective = true
				else
					local followup = objective.followup_objective

					if followup then
						if followup.path_style == "warp" or teleport_SO_anims[followup.action] then
							has_warp_objective = true
						end
					end
				end
			end

			if not has_warp_objective then
				if not ai_mov_ext:chk_action_forbidden("walk") then
					local bot_pos = ai.m_pos
					local valid_players = {}

					for _, player in pairs_g(self:all_player_criminals()) do
						if player.status ~= "dead" then
							local distance = mvec3_dis_sq(bot_pos, player.m_pos)

							if distance > teleport_distance then
								valid_players[#valid_players + 1] = {player, distance}
							else
								valid_players = {}

								break
							end
						end
					end

					local closest_distance, closest_player, closest_tracker = nil
					local ai_tracker, ai_access = ai.tracker, ai.so_access

					for i = 1, #valid_players do
						local player = valid_players[i][1]
						local tracker = player.tracker

						if not tracker:obstructed() and not tracker:lost() then
							local player_unit = player.unit
							local player_mov_ext = player_unit:movement()

							if not player_mov_ext:zipline_unit() then
								local player_state = player_mov_ext:current_state_name()

								if not invalid_player_bot_warp_states[player_state] then
									local in_air = nil

									if player_unit:base().is_local_player then
										in_air = player_mov_ext:in_air() and true
									else
										in_air = player_mov_ext._in_air and true
									end

									if not in_air then
										local distance = valid_players[i][2]

										if not closest_distance or distance < closest_distance then
											local params = {
												from_tracker = ai_tracker,
												to_seg = tracker:nav_segment(),
												access = {
													"walk"
												},
												id = "warp_coarse_check" .. tostring_g(ai_key),
												access_pos = ai_access
											}

											local can_path = search_coarse_f(nav_manager, params) and true

											if can_path then
												closest_distance = distance
												closest_player = player
												closest_tracker = tracker
											end
										end
									end
								end
							end
						end
					end

					if closest_player then
						local near_cover_point = find_cover_f(nav_manager, closest_tracker:nav_segment(), 500, closest_tracker:field_position())
						local position = near_cover_point and near_cover_point[1] or closest_player.m_pos
						local action_desc = {
							body_part = 1,
							type = "warp",
							position = mvec3_cpy(position)
						}

						ai_mov_ext:action_request(action_desc)
					end
				end
			end
		end
	end
end

function GroupAIStateBase:_upd_whisper_suspicion_mul_decay(t)
	if not self._decay_target or self._next_whisper_susp_mul_t and self._next_whisper_susp_mul_t > t then
		--log("why did this execute")
		return
	end
	
	if self._next_whisper_susp_mul_t and self._next_whisper_susp_mul_t < t then
		if self._guard_detection_mul_raw > self._decay_target then
			self._decay_target = self._old_guard_detection_mul_raw * self._suspicion_threshold
			self._guard_detection_mul_raw = self._guard_detection_mul_raw - 0.01
			self._next_whisper_susp_mul_t = t + 5
			--log("coolcoolcool")
		end
	end	
end

function GroupAIStateBase:_delay_whisper_suspicion_mul_decay()
	self._next_whisper_susp_mul_t = self._t + 5
end

function GroupAIStateBase:on_enemy_unregistered(unit)
	if self:is_unit_in_phalanx_minion_data(unit:key()) then
		self:unregister_phalanx_minion(unit:key())
		CopLogicPhalanxMinion:chk_should_breakup()
		CopLogicPhalanxMinion:chk_should_reposition()
	end

	self._police_force = self._police_force - 1
	local u_key = unit:key()

	self:_clear_character_criminal_suspicion_data(u_key)

	if not Network:is_server() then
		return
	end

	local e_data = self._police[u_key]

	if e_data.importance > 0 then
		for c_key, c_data in pairs_g(self._player_criminals) do
			local imp_keys = c_data.important_enemies

			for i, test_e_key in ipairs_g(imp_keys) do
				if test_e_key == u_key then
					table.remove(imp_keys, i)
					table.remove(c_data.important_dis, i)

					break
				end
			end
		end
	end

	for crim_key, record in pairs_g(self._ai_criminals) do
		record.unit:brain():on_cop_neutralized(u_key)
	end

	local unit_type = unit:base()._tweak_table

	if self._special_unit_types[unit_type] then
		self:unregister_special_unit(u_key, unit_type)
	end

	local dead = unit:character_damage():dead()

	if e_data.group then
		self:_remove_group_member(e_data.group, u_key, dead)
		if dead and self._task_data and self._task_data.assault and self._task_data.assault.active then
			self:_voice_friend_dead(e_data.group)
			self._last_killed_cop_t = self._t
		end
	end
	
	--Only guards with pagers increase suspicion
	local char_tweak = tweak_data.character[unit:base()._tweak_table]
	
	if dead and char_tweak.has_alarm_pager and managers.groupai:state():whisper_mode() then
		self._next_whisper_susp_mul_t = self._t + 5
		self._old_guard_detection_mul_raw = self._old_guard_detection_mul_raw + 0.05
		self._decay_target = self._old_guard_detection_mul_raw * 0.75			
		self._guard_detection_mul_raw = self._old_guard_detection_mul_raw 
		self._guard_delay_deduction = self._guard_delay_deduction + 0.05
	end		

	if e_data.assigned_area and dead then
		local spawn_point = unit:unit_data().mission_element

		if spawn_point then
			local spawn_pos = spawn_point:value("position")
			local u_pos = e_data.m_pos

			if mvector3.distance(spawn_pos, u_pos) < 700 and math.abs(spawn_pos.z - u_pos.z) < 300 then
				local found = nil

				for area_id, area_data in pairs_g(self._area_data) do
					local area_spawn_points = area_data.spawn_points

					if area_spawn_points then
						for _, sp_data in ipairs_g(area_spawn_points) do
							if sp_data.spawn_point == spawn_point then
								found = true
								sp_data.delay_t = math.max(sp_data.delay_t, self._t + math.random(30, 60))

								break
							end
						end

						if found then
							break
						end
					end

					local area_spawn_points = area_data.spawn_groups

					if area_spawn_points then
						for _, sp_data in ipairs_g(area_spawn_points) do
							if sp_data.spawn_point == spawn_point then
								found = true
								sp_data.delay_t = math.max(sp_data.delay_t, self._t + math.random(30, 60))

								break
							end
						end

						if found then
							break
						end
					end
				end
			end
		end
	end

	local objective = unit:brain():objective()

	if objective and objective.fail_clbk then
		local fail_clbk = objective.fail_clbk
		objective.fail_clbk = nil

		fail_clbk(unit)
	end
end

function GroupAIStateBase:on_civilian_unregistered(unit)
	local u_key = unit:key()

	self:_clear_character_criminal_suspicion_data(u_key)

	local u_data = managers.enemy:all_civilians()[u_key]

	if u_data and u_data.hostage_following then
		self:on_hostage_follow(u_data.hostage_following, unit, false)
	end
	
	local dead = unit:character_damage():dead()
	
	--*Big* suspicion increase from dead civs. Watch your background!--
	if dead and managers.groupai:state():whisper_mode() then
		self._next_whisper_susp_mul_t = self._t + 5
		self._old_guard_detection_mul_raw = self._old_guard_detection_mul_raw + 0.05
		self._decay_target = self._old_guard_detection_mul_raw * 0.75			
		self._guard_detection_mul_raw = self._old_guard_detection_mul_raw 
		self._guard_delay_deduction = self._guard_delay_deduction + 0.05
	end		
	
end	

function GroupAIStateBase:_get_anticipation_duration(anticipation_duration_table, is_first)
	local anticipation_duration = anticipation_duration_table[1][1]

	if not is_first then
		local rand = math.random()
		local accumulated_chance = 0

		for i, setting in pairs_g(anticipation_duration_table) do
			accumulated_chance = accumulated_chance + setting[2]

			if rand <= accumulated_chance then
				anticipation_duration = setting[1]

				break
			end
		end
	end
	
	if not managers.skirmish:is_skirmish() then
		if is_first or self._assault_number and self._assault_number == 1 then
			return 45
		elseif self._assault_number and self._assault_number == 2 then
			return 45
		elseif self._assault_number and self._assault_number == 3 then
			return 35
		elseif self._assault_number and self._assault_number >= 4 then
			return 25
		else
			return 45
		end
	else
		return anticipation_duration
	end
	
end

function GroupAIStateBase:criminal_spotted(unit)
	local u_key = unit:key()
	local u_sighting = self._criminals[u_key]

	u_sighting.undetected = nil
	u_sighting.det_t = self._t

	u_sighting.tracker:m_position(u_sighting.pos)

	local seg = u_sighting.tracker:nav_segment()
	u_sighting.seg = seg

	local prev_area = u_sighting.area
	local area = nil

	if prev_area and prev_area.nav_segs[seg] then
		area = prev_area
	else
		area = self:get_area_from_nav_seg_id(seg)
	end

	if prev_area ~= area then
		u_sighting.area = area

		if prev_area then
			prev_area.criminal.units[u_key] = nil
		end

		area.criminal.units[u_key] = u_sighting
	end

	if area.is_safe then
		area.is_safe = nil

		self:_on_area_safety_status(area, {
			reason = "criminal",
			record = u_sighting
		})
	end
end

function GroupAIStateBase:on_criminal_nav_seg_change(unit, nav_seg_id)
	local u_key = unit:key()
	local u_sighting = self._criminals[u_key]

	if not u_sighting then
		return
	end

	local seg = nav_seg_id

	u_sighting.seg = seg

	local prev_area = u_sighting.area
	local area = nil

	if prev_area and prev_area.nav_segs[seg] then
		area = prev_area
	else
		area = self:get_area_from_nav_seg_id(seg)
	end

	if prev_area ~= area then
		u_sighting.area = area

		if prev_area then
			prev_area.criminal.units[u_key] = nil
		end

		area.criminal.units[u_key] = u_sighting
	end
end

function GroupAIStateBase:on_criminal_suspicion_progress(u_suspect, u_observer, status, client_id)
	if not self._ai_enabled or not self._whisper_mode or self._stealth_hud_disabled then
		return
	end

	local ignore_suspicion = u_observer:brain() and u_observer:brain()._ignore_suspicion
	local observer_is_dead = u_observer:character_damage() and u_observer:character_damage():dead()

	if ignore_suspicion or observer_is_dead then
		return
	end

	local obs_key = u_observer:key()

	if managers.groupai:state():all_AI_criminals()[obs_key] then
		return
	end

	local susp_data = self._suspicion_hud_data
	local susp_key = u_suspect and u_suspect:key()

	local function _sync_status(sync_status_code)
		if Network:is_server() and managers.network:session() then
			if client_id then
				managers.network:session():send_to_peers_synched_except(client_id, "suspicion_hud", u_observer, sync_status_code)
			else
				managers.network:session():send_to_peers_synched("suspicion_hud", u_observer, sync_status_code)
			end
		end
	end

	local obs_susp_data = susp_data[obs_key]

	if status == "called" then
		if obs_susp_data then
			if status == obs_susp_data.status then
				return
			else
				obs_susp_data.suspects = nil
			end
		else
			local icon_id = "susp1" .. tostring(obs_key)
			local icon_pos = self._create_hud_suspicion_icon(obs_key, u_observer, "wp_calling_in", tweak_data.hud.suspicion_color, icon_id)
			obs_susp_data = {
				u_observer = u_observer,
				icon_id = icon_id,
				icon_pos = icon_pos
			}
			susp_data[obs_key] = obs_susp_data
		end

		managers.hud:change_waypoint_icon(obs_susp_data.icon_id, "wp_calling_in")
		managers.hud:change_waypoint_arrow_color(obs_susp_data.icon_id, tweak_data.hud.detected_color)

		if obs_susp_data.icon_id2 then
			managers.hud:remove_waypoint(obs_susp_data.icon_id2)

			obs_susp_data.icon_id2 = nil
			obs_susp_data.icon_pos2 = nil
		end

		obs_susp_data.status = "called"
		obs_susp_data.alerted = true
		obs_susp_data.expire_t = self._t + 8
		obs_susp_data.persistent = true

		_sync_status(4)
	elseif status == "calling" then
		if obs_susp_data then
			if status == obs_susp_data.status then
				return
			else
				obs_susp_data.suspects = nil
			end
		else
			local icon_id = "susp1" .. tostring(obs_key)
			local icon_pos = self._create_hud_suspicion_icon(obs_key, u_observer, "wp_calling_in", tweak_data.hud.detected_color, icon_id)
			obs_susp_data = {
				u_observer = u_observer,
				icon_id = icon_id,
				icon_pos = icon_pos
			}
			susp_data[obs_key] = obs_susp_data
		end

		if not obs_susp_data.icon_id2 then
			local hazard_icon_id = "susp2" .. tostring(obs_key)
			local hazard_icon_pos = self._create_hud_suspicion_icon(obs_key, u_observer, "wp_calling_in_hazard", tweak_data.hud.detected_color, hazard_icon_id)
			obs_susp_data.icon_id2 = hazard_icon_id
			obs_susp_data.icon_pos2 = hazard_icon_pos
		end

		managers.hud:change_waypoint_icon(obs_susp_data.icon_id, "wp_calling_in")
		managers.hud:change_waypoint_arrow_color(obs_susp_data.icon_id, tweak_data.hud.detected_color)
		managers.hud:change_waypoint_icon(obs_susp_data.icon_id2, "wp_calling_in_hazard")
		managers.hud:change_waypoint_arrow_color(obs_susp_data.icon_id2, tweak_data.hud.detected_color)

		obs_susp_data.status = "calling"
		obs_susp_data.alerted = true

		_sync_status(3)
	elseif status == true or status == "call_interrupted" then
		if obs_susp_data then
			if obs_susp_data.status == status then
				return
			else
				obs_susp_data.suspects = nil
			end
		else
			local icon_id = "susp1" .. tostring(obs_key)
			local icon_pos = self._create_hud_suspicion_icon(obs_key, u_observer, "wp_detected", tweak_data.hud.detected_color, icon_id)
			obs_susp_data = {
				u_observer = u_observer,
				icon_id = icon_id,
				icon_pos = icon_pos
			}
			susp_data[obs_key] = obs_susp_data
		end

		managers.hud:change_waypoint_icon(obs_susp_data.icon_id, "wp_detected")
		managers.hud:change_waypoint_arrow_color(obs_susp_data.icon_id, tweak_data.hud.detected_color)

		if obs_susp_data.icon_id2 then
			managers.hud:remove_waypoint(obs_susp_data.icon_id2)

			obs_susp_data.icon_id2 = nil
			obs_susp_data.icon_pos2 = nil
		end

		obs_susp_data.status = status
		obs_susp_data.alerted = true

		_sync_status(2)
	elseif not status then
		if obs_susp_data then
			if obs_susp_data.suspects and susp_key then
				obs_susp_data.suspects[susp_key] = nil

				if not next(obs_susp_data.suspects) then
					obs_susp_data.suspects = nil
				end
			end

			if not susp_key or not obs_susp_data.alerted and (not obs_susp_data.suspects or not next(obs_susp_data.suspects)) then
				managers.hud:remove_waypoint(obs_susp_data.icon_id)

				if obs_susp_data.icon_id2 then
					managers.hud:remove_waypoint(obs_susp_data.icon_id2)
				end

				susp_data[obs_key] = nil

				_sync_status(0)
			end
		end
	else
		if obs_susp_data then
			if obs_susp_data.alerted then
				return
			end

			_sync_status(1)
		elseif not obs_susp_data then
			local icon_id = "susp1" .. tostring(obs_key)
			local icon_pos = self._create_hud_suspicion_icon(obs_key, u_observer, "wp_suspicious", tweak_data.hud.suspicion_color, icon_id)
			obs_susp_data = {
				u_observer = u_observer,
				icon_id = icon_id,
				icon_pos = icon_pos
			}
			susp_data[obs_key] = obs_susp_data

			managers.hud:change_waypoint_icon(obs_susp_data.icon_id, "wp_suspicious")
			managers.hud:change_waypoint_arrow_color(obs_susp_data.icon_id, tweak_data.hud.suspicion_color)

			if obs_susp_data.icon_id2 then
				managers.hud:remove_waypoint(obs_susp_data.icon_id2)

				obs_susp_data.icon_id2 = nil
				obs_susp_data.icon_pos2 = nil
			end

			_sync_status(1)
		end

		if susp_key then
			obs_susp_data.suspects = obs_susp_data.suspects or {}

			if obs_susp_data.suspects[susp_key] then
				obs_susp_data.suspects[susp_key].status = status
			else
				obs_susp_data.suspects[susp_key] = {
					status = status,
					u_suspect = u_suspect
				}
			end
		end
	end
end

function GroupAIStateBase:set_whisper_mode(state)
	state = state and true or false

	if state == self._whisper_mode then
		return
	end

	self._whisper_mode = state
	self._whisper_mode_change_t = TimerManager:game():time()

	self:set_ambience_flag()

	if state then
		self:chk_register_removed_attention_objects()
	else
		self:chk_unregister_irrelevant_attention_objects()

		if Network:is_server() and not self._switch_to_not_cool_clbk_id then
			self._switch_to_not_cool_clbk_id = "GroupAI_delayed_not_cool"

			managers.enemy:add_delayed_clbk(self._switch_to_not_cool_clbk_id, callback(self, self, "_clbk_switch_enemies_to_not_cool"), self._t + 1)
		end
	end

	self:_call_listeners("whisper_mode", state)

	if not state then
		self:_clear_criminal_suspicion_data()
	end
end

function GroupAIStateBase:register_AI_attention_object(unit, handler, nav_tracker, team, SO_access)
	local actually_remove_instead = nil

	if not self:whisper_mode() then
		if not nav_tracker and not unit:vehicle_driving() or unit:in_slot(1) --[[or unit:in_slot(17) and unit:character_damage()]] then
			actually_remove_instead = true
		end
	end

	local u_key = unit:key()

	if actually_remove_instead then
		self._attention_objects.all[u_key] = {
			handler = handler
		}

		local handler_data = deep_clone(handler:attention_data())

		self:store_removed_attention_object(u_key, unit, handler, handler_data)

		for attention_id, _ in pairs_g(handler_data) do
			handler:remove_attention(attention_id)
		end
	else
		self._attention_objects.all[u_key] = {
			unit = unit,
			handler = handler,
			nav_tracker = nav_tracker,
			team = team,
			SO_access = SO_access
		}

		self:on_AI_attention_changed(u_key)

		if handler._is_extension then
			local att_obj_upd_state = true

			if not nav_tracker and not unit:vehicle_driving() and not unit:carry_data() then
				local base_ext = unit:base()

				if not base_ext then
					if unit:in_slot(1) then
						att_obj_upd_state = false
					end
				elseif base_ext.is_security_camera then
					if base_ext.is_friendly or base_ext:destroyed() then
						att_obj_upd_state = false
					end
				elseif unit:in_slot(1) then
					att_obj_upd_state = false
				end
			elseif unit:in_slot(1) then
				att_obj_upd_state = false
			end

			handler:set_update_enabled(att_obj_upd_state)

			if not att_obj_upd_state then
				handler:update()

				managers.enemy:add_delayed_clbk("_att_object_pos_upd" .. tostring(u_key), callback(handler, handler, "_do_late_update"), self._t + 0.5)
			end
		end
	end
end

function GroupAIStateBase:unregister_AI_attention_object(unit_key)
	local general_entry = self._attention_objects.all[unit_key]
	local handler = general_entry and general_entry.handler

	if handler and handler._is_extension then
		handler:set_update_enabled(false)
	end

	for cat_filter, list in pairs_g(self._attention_objects) do
		list[unit_key] = nil
	end
end

function GroupAIStateBase:chk_register_removed_attention_objects()
	if not self._removed_attention_objects then
		return
	end

	local all_attention_objects = self:get_all_AI_attention_objects()

	for u_key, removed_data in pairs_g(self._removed_attention_objects) do
		if all_attention_objects[u_key] then
			self._removed_attention_objects[u_key] = nil
		else
			local unit = removed_data[1]

			if alive_g(unit) then
				local handler = removed_data[2]
				local saved_attention_data = removed_data[3]

				for attention_id, attention_data in pairs_g(saved_attention_data) do
					handler:add_attention(attention_data)
				end
			end

			self._removed_attention_objects[u_key] = nil
		end
	end

	self._removed_attention_objects = {}
end

function GroupAIStateBase:store_removed_attention_object(u_key, unit, handler, attention_data)
	local stored_data = self._removed_attention_objects or {}

	if stored_data[u_key] then
		stored_data[u_key][1] = unit
		stored_data[u_key][2] = handler
		local stored_att_data = stored_data[u_key][3]

		for id, data in pairs_g(attention_data) do
			stored_att_data[id] = data
		end
	else
		stored_data[u_key] = {unit, handler, attention_data}
	end

	self._removed_attention_objects = stored_data
end

function GroupAIStateBase:chk_unregister_irrelevant_attention_objects()
	local all_attention_objects = self:get_all_AI_attention_objects()

	for u_key, att_info in pairs_g(all_attention_objects) do
		if not att_info.nav_tracker and not att_info.unit:vehicle_driving() or att_info.unit:in_slot(1) --[[or att_info.unit:in_slot(17) and att_info.unit:character_damage()]] then
			local handler = att_info.handler
			local handler_data = deep_clone(handler:attention_data())

			self:store_removed_attention_object(u_key, att_info.unit, handler, handler_data)

			for attention_id, _ in pairs_g(handler_data) do
				handler:remove_attention(attention_id)
			end
		end
	end
end

--remove this if it ever becomes intended that hostages can't be rescued during assaults
--otherwise leave the function like this since it only causes issues
function GroupAIStateBase:_set_rescue_state(state)
end


function GroupAIStateBase:sync_hostage_killed_warning(warning)
	if not self:bain_state() then
		return
	end

	if warning == 1 then
		managers.dialog:queue_narrator_dialog("c01", {})
	elseif warning == 2 then
		managers.dialog:queue_narrator_dialog("c02", {})
	elseif warning == 3 then
		managers.dialog:queue_narrator_dialog("c03", {})
	end
end

function GroupAIStateBase:hostage_killed(killer_unit)
	if not alive(killer_unit) then
		return
	end

	if killer_unit:base() and killer_unit:base().thrower_unit then
		killer_unit = killer_unit:base():thrower_unit()

		if not alive(killer_unit) then
			return
		end
	end

	local key = killer_unit:key()
	local criminal = self._criminals[key]

	if not criminal then
		return
	end

	self:set_difficulty(nil, 0.1)
			
	if is_first or self._assault_number and self._assault_number >= 1 then
		local roll = math.rand(1, 100)
		local chance_civ = 50
		if roll <= chance_civ then
			 self:_get_megaphone_sound_source():post_event("mga_killed_civ_1st")
		end	
	end

	self._hostages_killed = (self._hostages_killed or 0) + 1

	if not self._hunt_mode then
		if self._hostages_killed >= 1 and not self._hostage_killed_warning_lines then
			self:sync_hostage_killed_warning(1)
			managers.network:session():send_to_peers_synched("sync_hostage_killed_warning", 1)

			self._hostage_killed_warning_lines = 1
		elseif self._hostages_killed >= 3 and self._hostage_killed_warning_lines == 1 then
			self:sync_hostage_killed_warning(2)
			managers.network:session():send_to_peers_synched("sync_hostage_killed_warning", 2)

			self._hostage_killed_warning_lines = 2
		elseif self._hostages_killed >= 7 and self._hostage_killed_warning_lines == 2 then
			self:sync_hostage_killed_warning(3)
			managers.network:session():send_to_peers_synched("sync_hostage_killed_warning", 3)

			self._hostage_killed_warning_lines = 3
		end
	end

	if not criminal.is_deployable then
		local tweak = nil

		if killer_unit:base().is_local_player or killer_unit:base().is_husk_player then
			tweak = tweak_data.player.damage
		else
			tweak = tweak_data.character[killer_unit:base()._tweak_table].damage
		end

		local respawn_penalty = criminal.respawn_penalty or tweak.base_respawn_time_penalty
		criminal.respawn_penalty = respawn_penalty + tweak.respawn_time_penalty
		criminal.hostages_killed = (criminal.hostages_killed or 0) + 1
	end
end

--this function has been repurposed. instead of overriding any previous value, this ADDS diff
--this is set to 0.5 on loud, while other events increase it
--+0.1 on civilian kill (watch your fire!), +0.3 on assault end
--script value is used by the base game, we usually ignore it after the beginning of a level
--thanks (again) to hoxi for helping out with this
--perhaps modify these values at one point in crime spree? who knows
function GroupAIStateBase:set_difficulty(script_value, manual_value)
	if managers.skirmish:is_skirmish() then
		self:set_skirmish_difficulty()
		return
	end

    if self._difficulty_value == 1 then
        return
    end

	if script_value then
		if script_value == 0 then
			self._difficulty_value = 0
			--if diff is set to 0 in the middle of a mission, heists cannot start assaults. this ensures that we can set diff to default 0.5 again if a script sets it to 0
			--i dont think any heists do this but there's no harm in having this check here
			self._loud_diff_set = false 
            self:_calculate_difficulty_ratio()

			return
		elseif not self._loud_diff_set and script_value > 0  then
			--hopefully better way to do it. when game tries to set diff to anything that isnt 0, we add 0.1
			--only do this once (or when value is set to false as said below). otherwise we'll set diff to 1 super fast and that's mean
			--should fix armored transport and its jank mission scripts	(ovk why)
			--also, add 0.1 here instead of setting so you cant bypass civ penalty on some heists
			self._difficulty_value = self._difficulty_value + self._starting_diff
			self:_calculate_difficulty_ratio()
			--please kill me
			self._loud_diff_set = true

			return
        end
    end

    if not manual_value then
        return
    end

	--note that this ADDS, not replaces. only way to replace is with a script_value of 0
    self._difficulty_value = math.min(self._difficulty_value + manual_value, 1)

    self:_calculate_difficulty_ratio()
end

--Skirmish's custom diff scaling.
--First 10 waves correspond directly to array values in its groupai tweakdata, after that it switches to an infinite scaling function.
function GroupAIStateBase:set_skirmish_difficulty()
	--Current_wave_number is always 1 lower than the actual wave number for a new assault.
	local wave = managers.skirmish:current_wave_number() + 1
	local skirmish_ramp = tweak_data.group_ai.skirmish_difficulty_curve_points

	if not self._difficulty_value or self._difficulty_value < skirmish_ramp[10] then
		self._difficulty_value = wave * 0.05
	else
		self._difficulty_value = 1 - (1/(0.2*wave)) --Get infinitely closer to 1 over time.
	end

	self:_calculate_difficulty_ratio()
end

--below stuff is used to handle autumn's deployable blackout effect
function GroupAIStateBase:register_blackout_source(unit)
	if unit and alive(unit) then 
		self._blackout_units[unit:key()] = unit
		self:do_blackout(true)
	end
end

function GroupAIStateBase:unregister_blackout_source(unit)
	if unit and alive(unit) then
		self._blackout_units[unit:key()] = nil
	end
	self:check_blackout()
end

function GroupAIStateBase:check_blackout()
	local any_active = false
	for key,unit in pairs_g(self._blackout_units) do 
		if unit and alive(unit) then 
			any_active = true
			break
		else
			--remove any invalid units from the list, in case their destroy method was not called properly
			self._blackout_units[key] = nil
		end
	end
	self:do_blackout(any_active)
end

function GroupAIStateBase:do_blackout(state)
	local all_eq = World:find_units_quick("all",14,25,26)
	if state then 
		for k,unit in pairs_g(all_eq) do
			if unit and alive(unit) and unit:base() then
				if unit:interaction() and unit:interaction()._tweak_data and unit:interaction()._tweak_data.blackout_vulnerable then 
					--todo add a cool timed callback thing so that they all die with a bit of an offset from each other but all within x seconds
					if unit:base().get_name_id then 
						local eq_id = unit:base():get_name_id() or ""
						if eq_id == "sentry_gun" then --perish
							unit:character_damage():die()
						elseif eq_id == "ecm_jammer" then 
							unit:base():set_battery_empty()
							unit:base():_set_feedback_active(false)
						end
					end
					
					if unit.contour and unit:contour() then 
						unit:contour():add("deployable_blackout")
					end
					unit:base().blackout_active = true
				end
			end
		end
	else
		for k,unit in pairs_g(all_eq) do
			if unit and alive(unit) and unit:base() then
				if unit:interaction() and unit:interaction()._tweak_data and unit:interaction()._tweak_data.blackout_vulnerable then 
					if unit.contour and unit:contour() then 
						unit:contour():remove("deployable_blackout")
					end
					unit:base().blackout_active = false
				end
			end
		end
	end
end

function GroupAIStateBase:_merge_coarse_path_by_area(coarse_path)
	local i_nav_seg = #coarse_path
	local last_area = nil

	while i_nav_seg > 0 do
		if #coarse_path > 2 then
			local nav_seg = coarse_path[i_nav_seg][1]
			local area = self:get_area_from_nav_seg_id(nav_seg)

			if last_area and last_area == area then
				table.remove(coarse_path, i_nav_seg)
			else
				last_area = area
			end
		end

		i_nav_seg = i_nav_seg - 1
	end
end

local _upd_criminal_suspicion_progress_original = GroupAIStateBase._upd_criminal_suspicion_progress
 
function GroupAIStateBase:_upd_criminal_suspicion_progress(...)
	if self._ai_enabled then
		for obs_key, obs_susp_data in pairs_g(self._suspicion_hud_data or {}) do
			local unit = obs_susp_data.u_observer
			
			if managers.enemy:is_civilian(unit) then
				local waypoint = managers.hud._hud.waypoints["susp1" .. tostring(obs_key)]
				
				if waypoint then
					if unit:anim_data().drop then
						if not obs_susp_data._subdued_civ then
							obs_susp_data._alerted_civ = nil
							obs_susp_data._subdued_civ = true
							waypoint.bitmap:set_color(Color(0.0, 1.0, 0.0))
							waypoint.arrow:set_color(Color(0.75, 0, 0.3, 0))
						end
					elseif obs_susp_data.alerted then
						if not obs_susp_data._alerted_civ then
							obs_susp_data._subdued_civ = nil
							obs_susp_data._alerted_civ = true
							waypoint.bitmap:set_color(Color.white)
							waypoint.arrow:set_color(tweak_data.hud.detected_color:with_alpha(0.75))
						end
					end
				end
			end
		end
	end
	
	return _upd_criminal_suspicion_progress_original(self, ...)
end

--Procs Enduring (Down restore with bots) at end of assaults for host.
Hooks:PreHook(GroupAIStateBase, "set_assault_mode" , "TriggerEnduringHost" , function(self, enabled)
	if self._assault_mode ~= enabled and enabled == false then
		managers.player:check_enduring()
	end
end)

--Procs Enduring at end of assaults for clients.
Hooks:PreHook(GroupAIStateBase, "sync_assault_mode" , "TriggerEnduringHost" , function(self, enabled)
	if self._assault_mode ~= enabled and enabled == false then
		managers.player:check_enduring()
	end
end)

local get_sync_event_id_original = GroupAIStateBase.get_sync_event_id
function GroupAIStateBase:get_sync_event_id(event_name)
	--instead of making this effect work for the host (it normally doesn't)
	--since Cloakers do this sound globally in this mod, prevent it from syncing to clients
	if event_name == "cloaker_spawned" then
		return
	end

	return get_sync_event_id_original(self, event_name)
end
