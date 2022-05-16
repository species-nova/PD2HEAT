local mvec3_norm = mvector3.normalize
local mvec3_cpy = mvector3.copy

local world_g = World

local original_init = PlayerStandard.init

local RELOAD_INTERRUPTED = 2
local RELOAD_INTERRUPT_QUEUED = 1
local RELOADING = 0

function PlayerStandard:init(unit)
	original_init(self, unit)

	self._queue_reload_start = false
	
	if Global.game_settings and Global.game_settings.one_down then
		self._slotmask_bullet_impact_targets = self._slotmask_bullet_impact_targets + 3
	else
		self._slotmask_bullet_impact_targets = managers.mutators:modify_value("PlayerStandard:init:melee_slot_mask", self._slotmask_bullet_impact_targets)
		self._slotmask_bullet_impact_targets = managers.modifiers:modify_value("PlayerStandard:init:melee_slot_mask", self._slotmask_bullet_impact_targets)
	end
	
	--Getting rid of unique underbarrel anim states. Unnecessary and only causes custom underbarrel animations to break.
	PlayerStandard.ANIM_STATES.underbarrel = {
		equip = Idstring("equip"),
		unequip = Idstring("unequip"),
		start_running = Idstring("start_running"),
		stop_running = Idstring("stop_running"),
		melee = Idstring("melee"),
		melee_miss = Idstring("melee_miss"),
		idle = Idstring("idle")
	}
end

function PlayerStandard:_check_action_jump(t, input)
	local new_action = nil
	local action_wanted = input.btn_jump_press

	if action_wanted then
		local action_forbidden = self._jump_t and t < self._jump_t + 0.55
		action_forbidden = action_forbidden or self._unit:base():stats_screen_visible() or self._state_data.in_air or self:_interacting() or self:_on_zipline() or self:_does_deploying_limit_movement() or self:_is_using_bipod()

		if not action_forbidden then
			if self._state_data.ducking then
				self:_interupt_action_ducking(t)
			end
				
			if self._state_data.on_ladder then
				self:_interupt_action_ladder(t)
			end

			local action_start_data = {}
			local jump_vel_z = tweak_data.player.movement_state.standard.movement.jump_velocity.z
			action_start_data.jump_vel_z = jump_vel_z

			if self._move_dir then
				local is_running = self._running and self._unit:movement():is_above_stamina_threshold() and t - self._start_running_t > 0.4
				local jump_vel_xy = 250
					
				if math.abs(self._last_velocity_xy:length()) > jump_vel_xy then
					jump_vel_xy = math.abs(self._last_velocity_xy:length())
				end
					
				action_start_data.jump_vel_xy = jump_vel_xy

				if is_running then
					self._unit:movement():subtract_stamina(tweak_data.player.movement_state.stamina.JUMP_STAMINA_DRAIN)
				end
			end

			new_action = self:_start_action_jump(t, action_start_data)
		end
	end

	return new_action
end

local tmp_ground_from_vec = Vector3()
local tmp_ground_to_vec = Vector3()
local up_offset_vec = math.UP * 30
local down_offset_vec = math.UP * -40

function PlayerStandard:_chk_floor_moving_pos(pos)
	local hips_pos = tmp_ground_from_vec
	local down_pos = tmp_ground_to_vec

	mvector3.set(hips_pos, self._pos)
	mvector3.add(hips_pos, up_offset_vec)
	mvector3.set(down_pos, hips_pos)
	mvector3.add(down_pos, down_offset_vec)

	local ground_ray = self._unit:raycast("ray", hips_pos, down_pos, "slot_mask", self._slotmask_gnd_ray, "ray_type", "body mover", "sphere_cast_radius", 29)

	if ground_ray then
		return ground_ray
	end
end

local mvec_pos_new = Vector3()
local mvec_achieved_walk_vel = Vector3()
local mvec_move_dir_normalized = Vector3()

function PlayerStandard:_update_movement(t, dt)
	local anim_data = self._unit:anim_data()
	local weapon_id = alive(self._equipped_unit) and self._equipped_unit:base() and self._equipped_unit:base():get_name_id()
	local weapon_tweak_data = weapon_id and tweak_data.weapon[weapon_id]
	local pos_new = nil
	self._target_headbob = self._target_headbob or 0
	self._headbob = self._headbob or 0
	
	local WALK_SPEED_MAX = self:_get_max_walk_speed(t)
	
	self._cached_final_speed = self._cached_final_speed or 0
		
	if WALK_SPEED_MAX ~= self._cached_final_speed then
		self._cached_final_speed = WALK_SPEED_MAX
		
		self._ext_network:send("action_change_speed", WALK_SPEED_MAX)
	end
	
	local floor_moving_ray = self:_chk_floor_moving_pos()
	local floor_moving_vel, floor_moving_pos
	
	if floor_moving_ray then
		floor_moving_vel = floor_moving_ray.body and floor_moving_ray.body:velocity() or nil
		--floor_moving_pos = floor_moving_ray.position
	end
	
	local acceleration = WALK_SPEED_MAX * 8
	local decceleration = acceleration * 0.8
	
	if self._state_data.on_zipline and self._state_data.zipline_data.position then
		local speed = mvector3.length(self._state_data.zipline_data.position - self._pos) / dt / 500
		pos_new = mvec_pos_new

		mvector3.set(pos_new, self._state_data.zipline_data.position)

		if self._state_data.zipline_data.camera_shake then
			self._ext_camera:shaker():set_parameter(self._state_data.zipline_data.camera_shake, "amplitude", speed)
		end

		if alive(self._state_data.zipline_data.zipline_unit) then
			local dot = mvector3.dot(self._ext_camera:rotation():x(), self._state_data.zipline_data.zipline_unit:zipline():current_direction())

			self._ext_camera:camera_unit():base():set_target_tilt(dot * 10 * speed)
		end

		self._target_headbob = 0
	elseif self._move_dir then
		local enter_moving = not self._moving
		self._moving = true

		if enter_moving then
			self._last_sent_pos_t = t
		end

		mvector3.set(mvec_move_dir_normalized, self._move_dir)
		mvector3.normalize(mvec_move_dir_normalized)

		local wanted_walk_speed = WALK_SPEED_MAX * math.min(1, self._move_dir:length())
		local achieved_walk_vel = mvec_achieved_walk_vel
		
		local lleration = acceleration
		
		if math.abs(self._last_velocity_xy:length()) > wanted_walk_speed then
			lleration = decceleration
		end

		if self._jump_vel_xy and self._state_data.in_air and mvector3.dot(self._jump_vel_xy, self._last_velocity_xy) > 0 then
			local wanted_walk_speed_air = WALK_SPEED_MAX * math.min(1, self._move_dir:length())
			local acceleration = self._state_data.in_air and 700 or self._running and 5000 or 3000
			local input_move_vec = wanted_walk_speed_air * self._move_dir
			local jump_dir = mvector3.copy(self._last_velocity_xy)
			local jump_vel = mvector3.normalize(jump_dir)
			local fwd_dot = jump_dir:dot(input_move_vec)

			if fwd_dot < jump_vel then
				local sustain_dot = (input_move_vec:normalized() * jump_vel):dot(jump_dir)
				local new_move_vec = input_move_vec + jump_dir * (sustain_dot - fwd_dot)

				mvector3.step(achieved_walk_vel, self._last_velocity_xy, new_move_vec, 700 * dt)
			else
				mvector3.multiply(mvec_move_dir_normalized, wanted_walk_speed_air)
				mvector3.step(achieved_walk_vel, self._last_velocity_xy, wanted_walk_speed_air * self._move_dir:normalized(), acceleration * dt)
			end

			local fwd_component = nil
		else
			mvector3.multiply(mvec_move_dir_normalized, wanted_walk_speed)
			mvector3.step(achieved_walk_vel, self._last_velocity_xy, mvec_move_dir_normalized, lleration * dt)
		end

		if mvector3.is_zero(self._last_velocity_xy) then
			mvector3.set_length(achieved_walk_vel, math.max(achieved_walk_vel:length(), 100))
		end
		
		pos_new = mvec_pos_new

		mvector3.set(pos_new, achieved_walk_vel)
		mvector3.multiply(pos_new, dt)
		mvector3.add(pos_new, self._pos)

		self._target_headbob = self:_get_walk_headbob()
		self._target_headbob = self._target_headbob * self._move_dir:length()

		if weapon_tweak_data and weapon_tweak_data.headbob and weapon_tweak_data.headbob.multiplier then
			self._target_headbob = self._target_headbob * weapon_tweak_data.headbob.multiplier
		end
	elseif not mvector3.is_zero(self._last_velocity_xy) then
		local decceleration = self._state_data.in_air and 250 or math.lerp(2000, 1500, math.min(self._last_velocity_xy:length() / WALK_SPEED_MAX, 1))
		local achieved_walk_vel = math.step(self._last_velocity_xy, Vector3(), decceleration * dt)

		pos_new = mvec_pos_new

		mvector3.set(pos_new, achieved_walk_vel)
		mvector3.multiply(pos_new, dt)
		mvector3.add(pos_new, self._pos)

		self._target_headbob = 0
	elseif self._moving or floor_moving_vel then
		if floor_moving_vel then
			local achieved_walk_vel = mvec_achieved_walk_vel
			mvector3.set(achieved_walk_vel, floor_moving_vel)
			
			pos_new = mvec_pos_new
			mvector3.set(pos_new, achieved_walk_vel)
			mvector3.multiply(pos_new, dt)
			mvector3.add(pos_new, self._pos)
		end
		
		self._moving = false
		self._target_headbob = 0
	end

	if self._headbob ~= self._target_headbob then
		local ratio = 4

		if weapon_tweak_data and weapon_tweak_data.headbob and weapon_tweak_data.headbob.speed_ratio then
			ratio = weapon_tweak_data.headbob.speed_ratio
		end

		self._headbob = math.step(self._headbob, self._target_headbob, dt / ratio)

		self._ext_camera:set_shaker_parameter("headbob", "amplitude", self._headbob)
	end

	if pos_new then
		if floor_moving_pos then
			pos_new.z = floor_moving_pos.z
		end
	
		self._unit:movement():set_position(pos_new)
		mvector3.set(self._last_velocity_xy, pos_new)
		mvector3.subtract(self._last_velocity_xy, self._pos)

		if not self._state_data.on_ladder and not self._state_data.on_zipline then
			mvector3.set_z(self._last_velocity_xy, 0)
		end

		mvector3.divide(self._last_velocity_xy, dt)
	else
		mvector3.set_static(self._last_velocity_xy, 0, 0, 0)
	end

	local cur_pos = pos_new or self._pos

	self:_update_network_jump(cur_pos, false)
	self:_update_network_position(t, dt, cur_pos, pos_new)
end

--Allows night vision to be used with any mask.
function PlayerStandard:set_night_vision_state(state)
	local mask_id = managers.blackmarket:equipped_mask().mask_id
	local mask_tweak = tweak_data.blackmarket.masks[mask_id]
	local night_vision = mask_tweak.night_vision 

	--If mask doesn't have night vision, it does.
	if not night_vision then
		night_vision = {
			effect = "color_night_vision",
			light = not _G.IS_VR and 0.3 or 0.1
		}
	end

	--This conditional is hilarious in vanilla btw.
	if self._state_data.night_vision_active == state then
		return
	end

	local ambient_color_key = CoreEnvironmentFeeder.PostAmbientColorFeeder.DATA_PATH_KEY
	--Use a proper fallback env instead of whatever vanilla does if there's an issue.
	local level_id = Global.game_settings.level_id
	local env_setting = gradient_filter and tweak_data.levels[level_id].env_params and tweak_data.levels[level_id].env_params.color_grading
	local level_check = env_setting or managers.user:get_setting("video_color_grading")
	local effect = state and night_vision.effect or level_check

	if state then
		local function light_modifier(handler, feeder)
			local base_light = feeder._target and mvector3.copy(feeder._target) or Vector3()
			local light = night_vision.light

			return base_light + Vector3(light, light, light)
		end

		managers.viewport:create_global_environment_modifier(ambient_color_key, true, light_modifier)
	else
		managers.viewport:destroy_global_environment_modifier(ambient_color_key)
	end

	self._unit:sound():play(state and "night_vision_on" or "night_vision_off", nil, false)
	managers.environment_controller:set_default_color_grading(effect, state)
	managers.environment_controller:refresh_render_settings()

	self._state_data.night_vision_active = state
end	

--Stops disabled cameras from being markable.
local add_unit_to_char_table_old = PlayerStandard._add_unit_to_char_table
function PlayerStandard:_add_unit_to_char_table(char_table, unit, unit_type, ...)
	if unit_type ~= 3 or unit:base()._detection_delay or (Network:is_client() and unit:base().cam_disabled ~= true) then
		add_unit_to_char_table_old(self, char_table, unit, unit_type, ...)
	end
end

function PlayerStandard:_activate_mover(mover, velocity)
	self._unit:activate_mover(mover, velocity)

	if self._state_data.on_ladder then
		self._unit:mover():set_gravity(Vector3(0, 0, 0))
	else
		self._unit:mover():set_gravity(Vector3(0, 0, -982)) --sets the actual gravity, you can set this to funny values if you want moon-jumping or something
	end
	
	self._unit:mover():set_damping(self._tweak_data.gravity / self._tweak_data.terminal_velocity) --sets how fast the player accelerates downwards in the air, i have no clue what the value for this actually represents since its something like 0.14-ish.
	

	if self._is_jumping then
		self._unit:mover():jump()
		self._unit:mover():set_velocity(velocity)
	end
end

function PlayerStandard:_start_action_ladder(t, ladder_unit)
	self._state_data.on_ladder = true

	self:_interupt_action_running(t)
	self._unit:mover():set_velocity(Vector3())
	self._unit:mover():set_gravity(Vector3(0, 0, 0))
	self._unit:mover():jump()
	self._unit:movement():on_enter_ladder(ladder_unit)
end

function PlayerStandard:_end_action_ladder(t, input)
	if not self._state_data.on_ladder then
		return
	end

	self._state_data.on_ladder = false

	if self._unit:mover() then
		self._unit:mover():set_gravity(Vector3(0, 0, -982))
		self._unit:mover():set_damping(self._tweak_data.gravity / self._tweak_data.terminal_velocity)
	end

	self._unit:movement():on_exit_ladder()
end	

--Allow for stopping all bots.
function PlayerStandard:_check_action_interact(t, input,...)
	local keyboard = self._controller.TYPE == "pc" or managers.controller:get_default_wrapper_type() == "pc"
	local new_action, timer, interact_object = nil

	if input.btn_interact_press then
		if _G.IS_VR then
			self._interact_hand = input.btn_interact_left_press and PlayerHand.LEFT or PlayerHand.RIGHT
		end

		if not self:_action_interact_forbidden() then
			new_action, timer, interact_object = self._interaction:interact(self._unit, input.data, self._interact_hand)

			if new_action then
				self:_play_interact_redirect(t, input)
			end

			if timer then
				new_action = true

				self._ext_camera:camera_unit():base():set_limits(80, 50)
				self:_start_action_interact(t, input, timer, interact_object)
			end

			if not new_action then
				self._start_intimidate = true
				self._start_intimidate_t = t
			end
		end
	end

	local secondary_delay = tweak_data.team_ai.stop_action.delay
	local force_secondary_intimidate = false
	local HOLD_TO_STOP_ALL_AI_DURATION = 1.5 --seconds to hold down to direct all ai instead of just the one
	local skip_intimidate_action = false 
	if self._start_shout_all_ai_t and self._start_shout_all_ai_t + HOLD_TO_STOP_ALL_AI_DURATION <= t then
		self._start_shout_all_ai_t = nil
		
		--tell all ai to stop
		for i, char_data in pairs(managers.criminals._characters) do
			if char_data.data.ai then
				local ai_unit = char_data.unit
				if alive(ai_unit) then 
					ai_unit:brain():on_long_dis_interacted(0, ai_unit, true)
					skip_intimidate_action = true
				end
			end
		
		end
		if skip_intimidate_action then 
			self:say_line("f48x_any", false)
			--play a voiceline if any ai were actually stopped
		end
	elseif self._controller:get_input_released("interact_secondary") then 
		--if release before the full duration required to call all ai then do normal single-target "stop ai" action
		self._start_shout_all_ai_t = nil
		force_secondary_intimidate = true
	elseif input.btn_interact_secondary_press then 
		--if pressing for the first time (not holding), start timer, do not do normal single-target "stop ai" until key release
		self._start_shout_all_ai_t = t
		skip_intimidate_action = true
	end

	if input.btn_interact_release then
		local released = true

		if _G.IS_VR then
			local release_hand = input.btn_interact_left_release and PlayerHand.LEFT or PlayerHand.RIGHT
			released = release_hand == self._interact_hand
		end

		if released then
			if self._start_intimidate and not self:_action_interact_forbidden() then
				if t < self._start_intimidate_t + secondary_delay then
					self:_start_action_intimidate(t)

					self._start_intimidate = false
				end
			else
				self:_interupt_action_interact()
			end
		end
	end
	
	if (self._start_intimidate or force_secondary_intimidate) and not (self:_action_interact_forbidden() or skip_intimidate_action) and (not keyboard and t > self._start_intimidate_t + secondary_delay or force_secondary_intimidate) then
		--don't do normal shout action if doing the "shout at ai" action with separate keybind
		self:_start_action_intimidate(t, true)

		self._start_intimidate = false
	end

	return new_action
end

function PlayerStandard:update(t, dt)
	PlayerMovementState.update(self, t, dt)
	self:_calculate_standard_variables(t, dt)
	self:_update_ground_ray()
	self:_update_fwd_ray()
	self:_update_check_actions(t, dt)

	if self._menu_closed_fire_cooldown > 0 then
		self._menu_closed_fire_cooldown = self._menu_closed_fire_cooldown - dt
	end

	self:_update_movement(t, dt)
	self:_upd_nav_data()
	self:_update_omniscience(t, dt)
	self:_upd_stance_switch_delay(t, dt)
	
	--Update the current weapon's spread value based on recent actions.
	local weapon = self._unit:inventory():equipped_unit():base() 
	weapon:update_spread(self, t, dt)
	self:_update_crosshair(t, dt, weapon)
	managers.hud:_update_crosshair_offset(t, dt)

	if weapon:has_spin() then
		weapon:update_spin()
	end
end

function PlayerStandard:_update_crosshair(t, dt, weapon)
	local crosshair_visible = alive(self._equipped_unit) and
							  not weapon:is_category("saw") and
							  not self:_is_meleeing() and
							  not self:_interacting() and
							  (not self._state_data.in_steelsight or self._crosshair_ignore_steelsight)

	if crosshair_visible then
		--Ensure that crosshair is actually visible.
		managers.hud:set_crosshair_visible(true)

		--Update hud's fov value. Easier and far less error prone to grab it here than there.
		managers.hud:set_camera_fov(self._camera_unit:base()._fov.fov)

		--Update crosshair size.
			--Get current weapon's spread values to determine base size.
			local crosshair_spread = weapon:_get_spread(self._unit)

			--Apply additional jiggle over crosshair in addition to actual aim bloom for game feel.
			if self._shot and t and (not self._next_crosshair_jiggle or self._next_crosshair_jiggle < t) then
				crosshair_spread = crosshair_spread + (weapon._recoil) * 4 --Magic number that feels good.
				self._next_crosshair_jiggle = t + 0.1
				self._shot = false --Trigger crosshair jiggles when a single shot was fired in the previous frame.
			end

			--Set the final size of the crosshair.
			managers.hud:set_crosshair_offset(crosshair_spread)
	else
		--Hide the crosshair and set its size to 0 when it shouldn't be seen.
		managers.hud:set_crosshair_visible(false)
		managers.hud:set_crosshair_offset(0)
	end

	--Vanilla accessibility dot updates are handled here, once per frame, instead of potentially multiple times per frame.
	local name_id = self._equipped_unit:base():get_name_id()

	if self._state_data.in_steelsight and managers.user:get_setting("accessibility_dot_hide_ads") then
		managers.hud:set_accessibility_dot_visible(not tweak_data.weapon[name_id].crosshair.steelsight.hidden)
	else
		managers.hud:set_accessibility_dot_visible(not tweak_data.weapon[name_id].crosshair[self._state_data.ducking and "crouching" or "standing"].hidden)
	end
end

function PlayerStandard:_update_check_actions(t, dt, paused)
	local input = self:_get_input(t, dt, paused)

	self:_determine_move_direction()
	self:_update_interaction_timers(t)
	self:_update_throw_projectile_timers(t, input)
	self:_update_reload_timers(t, dt, input)
	self:_update_melee_timers(t, input)
	self:_update_charging_weapon_timers(t, input)
	self:_update_use_item_timers(t, input)
	self:_update_equip_weapon_timers(t, input)
	self:_update_running_timers(t)
	self:_update_zipline_timers(t, dt)

	if self._change_item_expire_t and self._change_item_expire_t <= t then
		self._change_item_expire_t = nil
	end

	if self._change_weapon_pressed_expire_t and self._change_weapon_pressed_expire_t <= t then
		self._change_weapon_pressed_expire_t = nil
	end

	self:_update_steelsight_timers(t, dt)

	if input.btn_stats_screen_press then
		self._unit:base():set_stats_screen_visible(true)
	elseif input.btn_stats_screen_release then
		self._unit:base():set_stats_screen_visible(false)
	end

	self:_update_foley(t, input)

	local new_action = nil
	local anim_data = self._ext_anim
	new_action = new_action or self:_check_action_weapon_gadget(t, input)
	new_action = new_action or self:_check_action_weapon_firemode(t, input)
	new_action = new_action or self:_check_action_melee(t, input)
	new_action = new_action or self:_check_action_reload(t, input)
	new_action = new_action or self:_check_change_weapon(t, input)

	if not new_action then
		new_action = self:_check_action_primary_attack(t, input)

		if not _G.IS_VR and not new_action then
			self:_check_stop_shooting()
		end
	end

	new_action = new_action or self:_check_action_equip(t, input)
	new_action = new_action or self:_check_use_item(t, input)
	new_action = new_action or self:_check_action_throw_projectile(t, input)
	new_action = new_action or self:_check_action_interact(t, input)

	self:_check_action_jump(t, input)
	self:_check_action_run(t, input)
	self:_check_action_ladder(t, input)
	self:_check_action_zipline(t, input)
	self:_check_action_cash_inspect(t, input)

	if not new_action then
		new_action = self:_check_action_deploy_bipod(t, input)
		new_action = new_action or self:_check_action_deploy_underbarrel(t, input)
	end

	self:_check_action_change_equipment(t, input)
	self:_check_action_duck(t, input)
	self:_check_action_steelsight(t, input)
	self:_check_action_night_vision(t, input)
	self:_find_pickups(t)
end

function PlayerStandard:_start_action_intimidate(t, secondary)
	if not self._intimidate_t or tweak_data.player.movement_state.interaction_delay < t - self._intimidate_t then
		local skip_alert = managers.groupai:state():whisper_mode()
		local voice_type, plural, prime_target = self:_get_unit_intimidation_action(not secondary, not secondary, true, false, true, nil, nil, nil, secondary)

		if prime_target and prime_target.unit and prime_target.unit.base and (prime_target.unit:base().unintimidateable or prime_target.unit:anim_data() and prime_target.unit:anim_data().unintimidateable) then
			return
		end
		
		local interact_type, sound_name = nil
		local sound_suffix = plural and "plu" or "sin"
		if voice_type == "stop" then
			interact_type = "cmd_stop"
			sound_name = "f02x_" .. sound_suffix
		elseif voice_type == "stop_cop" then
			interact_type = "cmd_stop"
			sound_name = "l01x_" .. sound_suffix
		elseif voice_type == "mark_cop" or voice_type == "mark_cop_quiet" then
			interact_type = "cmd_point"
			if voice_type == "mark_cop_quiet" then
				sound_name = tweak_data.character[prime_target.unit:base()._tweak_table].silent_priority_shout .. "_any"
			elseif tweak_data.character[prime_target.unit:base()._tweak_table].custom_shout then --Special boss shoutouts.
				sound_name = tweak_data.character[prime_target.unit:base()._tweak_table].priority_shout
			else
				sound_name = tweak_data.character[prime_target.unit:base()._tweak_table].priority_shout .. "x_any"
				sound_name = managers.modifiers:modify_value("PlayerStandart:_start_action_intimidate", sound_name, prime_target.unit)
			end

			if managers.player:has_category_upgrade("player", "special_enemy_highlight") then
				prime_target.unit:contour():add(managers.player:get_contour_for_marked_enemy(), true, managers.player:upgrade_value("player", "mark_enemy_time_multiplier", 1))
				managers.network:session():send_to_peers_synched("spot_enemy", prime_target.unit)
			end
		elseif voice_type == "down" then
			interact_type = "cmd_down"
			sound_name = "f02x_" .. sound_suffix
			self._shout_down_t = t
		elseif voice_type == "down_cop" then
			interact_type = "cmd_down"
			sound_name = "l02x_" .. sound_suffix
		elseif voice_type == "cuff_cop" then
			interact_type = "cmd_down"
			sound_name = "l03x_" .. sound_suffix
		elseif voice_type == "down_stay" then
			interact_type = "cmd_down"

			if self._shout_down_t and t < self._shout_down_t + 2 then
				sound_name = "f03b_any"
			else
				sound_name = "f03a_" .. sound_suffix
			end
		elseif voice_type == "come" then
			interact_type = "cmd_come"
			local static_data = managers.criminals:character_static_data_by_unit(prime_target.unit)

			if static_data then
				local character_code = static_data.ssuffix
				sound_name = "f21" .. character_code .. "_sin"
			else
				sound_name = "f38_any"
			end
		elseif voice_type == "revive" then
			interact_type = "cmd_get_up"
			local static_data = managers.criminals:character_static_data_by_unit(prime_target.unit)

			if not static_data then
				return
			end

			local character_code = static_data.ssuffix
			sound_name = "f36x_any"

			if math.random() < self._ext_movement:rally_skill_data().revive_chance then
				prime_target.unit:interaction():interact(self._unit)
			end

			self._ext_movement:rally_skill_data().morale_boost_delay_t = managers.player:player_timer():time() + (self._ext_movement:rally_skill_data().morale_boost_cooldown_t or 3.5)
		elseif voice_type == "boost" then
			interact_type = "cmd_gogo"
			local static_data = managers.criminals:character_static_data_by_unit(prime_target.unit)

			if not static_data then
				return
			end

			local character_code = static_data.ssuffix
			sound_name = "g18"
			self._ext_movement:rally_skill_data().morale_boost_delay_t = managers.player:player_timer():time() + (self._ext_movement:rally_skill_data().morale_boost_cooldown_t or 3.5)
		elseif voice_type == "escort" then
			interact_type = "cmd_point"
			sound_name = "f41_" .. sound_suffix
		elseif voice_type == "escort_keep" or voice_type == "escort_go" then
			interact_type = "cmd_point"
			sound_name = "f40_any"
		elseif voice_type == "bridge_codeword" then
			sound_name = "bri_14"
			interact_type = "cmd_point"
		elseif voice_type == "bridge_chair" then
			sound_name = "bri_29"
			interact_type = "cmd_point"
		elseif voice_type == "undercover_interrogate" then
			sound_name = "f46x_any"
			interact_type = "cmd_point"
		elseif voice_type == "undercover_escort" then
			sound_name = "f41_any"
			interact_type = "cmd_point"
		elseif voice_type == "mark_camera" then
			sound_name = "f39_any"
			interact_type = "cmd_point"

			prime_target.unit:contour():add("mark_unit", true, managers.player:upgrade_value("player", "mark_enemy_time_multiplier", 1))
		elseif voice_type == "mark_turret" then
			sound_name = "f44x_any"
			interact_type = "cmd_point"
			local type = prime_target.unit:base().get_type and prime_target.unit:base():get_type()

			prime_target.unit:contour():add(managers.player:get_contour_for_marked_enemy(type), true, managers.player:upgrade_value("player", "mark_enemy_time_multiplier", 1))
		elseif voice_type == "ai_stay" then
			sound_name = "f48x_any"
			interact_type = "cmd_stop"
		end

		self:_do_action_intimidate(t, interact_type, sound_name, skip_alert)
	end
end

--Sixth sense action forbidden to let it work in loud, and only requires the player to not be moving to proc (so actions like shooting or aiming down sights no longer stop it).
function PlayerStandard:_update_omniscience(t, dt)
	local action_forbidden = not managers.player:has_category_upgrade("player", "standstill_omniscience") or managers.player:current_state() == "civilian" or self._ext_movement:has_carry_restriction() or self:_on_zipline() or self._moving or self:running() or self:in_air() or not tweak_data.player.omniscience
	if action_forbidden then
		if self._state_data.omniscience_t then
			self._state_data.omniscience_t = nil
		end

		return
	end

	self._state_data.omniscience_t = self._state_data.omniscience_t or t + tweak_data.player.omniscience.start_t

	if self._state_data.omniscience_t <= t then
		local sensed_targets = world_g:find_units_quick("sphere", self._unit:movement():m_pos(), tweak_data.player.omniscience.sense_radius, managers.slot:get_mask("trip_mine_targets"))

		for _, unit in ipairs(sensed_targets) do
			if alive(unit) and not unit:base():char_tweak().is_escort then
				self._state_data.omniscience_units_detected = self._state_data.omniscience_units_detected or {}

				if not self._state_data.omniscience_units_detected[unit:key()] or self._state_data.omniscience_units_detected[unit:key()] <= t then
					self._state_data.omniscience_units_detected[unit:key()] = t + tweak_data.player.omniscience.target_resense_t

					managers.game_play_central:auto_highlight_enemy(unit, true)
					break
				end
			end
		end

		self._state_data.omniscience_t = t + tweak_data.player.omniscience.interval_t
	end
end

--Updates strafing flag to make sprinting cost more stamina when not running forwards
function PlayerStandard:_check_strafe_running()
	if self._running and self._can_free_run or mvector3.angle(self._stick_move, math.Y) <= 54 then
		return false
	end

	return true
end

function PlayerStandard:_get_max_walk_speed(t, force_run)
	local speed_tweak = self._tweak_data.movement.speed
	local movement_speed = speed_tweak.STANDARD_MAX
	local speed_state = "walk"

	if self._state_data.in_steelsight and not managers.player:has_category_upgrade("player", "steelsight_normal_movement_speed") and not _G.IS_VR then
		movement_speed = speed_tweak.STEELSIGHT_MAX
		speed_state = "steelsight"
	elseif self:on_ladder() then
		movement_speed = speed_tweak.CLIMBING_MAX
		speed_state = "climb"
	elseif self._state_data.ducking then
		movement_speed = speed_tweak.CROUCHING_MAX
		speed_state = "crouch"
	elseif self._state_data.in_air then
		movement_speed = speed_tweak.INAIR_MAX
		speed_state = nil
	elseif self._running or force_run then
		--Apply movement speed penalty to strafe running, if needed.
		movement_speed = self:_check_strafe_running() and speed_tweak.STRAFE_RUNNING_MAX or speed_tweak.RUNNING_MAX
		speed_state = "run"
	end

	--movement_speed = managers.modifiers:modify_value("PlayerStandard:GetMaxWalkSpeed", movement_speed, self._state_data, speed_tweak)
	local morale_boost_bonus = self._ext_movement:morale_boost()
	local multiplier = managers.player:movement_speed_multiplier(speed_state, speed_state and morale_boost_bonus and morale_boost_bonus.move_speed_bonus, nil, self._ext_damage:health_ratio())
	multiplier = multiplier * (self._tweak_data.movement.multiplier[speed_state] or 1)
	local apply_weapon_penalty = true

	if self:_is_meleeing() then
		local melee_entry = managers.blackmarket:equipped_melee_weapon()
		apply_weapon_penalty = not tweak_data.blackmarket.melee_weapons[melee_entry].stats.remove_weapon_movement_penalty
	end

	if alive(self._equipped_unit) and apply_weapon_penalty then
		multiplier = multiplier * self._equipped_unit:base():movement_penalty()
	end

	local final_speed = movement_speed * multiplier
	return final_speed
end

local orig_set_running = PlayerStandard.set_running
function PlayerStandard:set_running(running, ...)
	orig_set_running(self, running, ...)
	if running then
		self._unit:movement():attempt_sprint_dash()
	end
end

--Baseline sprint in any direction.
function PlayerStandard:_update_running_timers(t)
	if self._end_running_expire_t then
		if self._end_running_expire_t <= t then
			self._end_running_expire_t = nil

			self:set_running(false)
		end
	elseif self._running and self._unit:movement():is_stamina_drained() then
			self:_interupt_action_running(t)
	end
end

--Allows for melee sprinting.
function PlayerStandard:_start_action_running(t)
	--Consolidated vanilla checks.
	if not self._move_dir or self:on_ladder() or self:_on_zipline() or managers.player:get_player_rule("no_run") or not self._unit:movement():is_above_stamina_threshold() then
		self._running_wanted = true
		return
	end

	if self._shooting and not self._equipped_unit:base():run_and_shoot_allowed() or self:_changing_weapon() or self._use_item_expire_t or self._state_data.in_air or self:_is_throwing_projectile() or self._state_data.ducking and not self:_can_stand() then
		self._running_wanted = true
		return
	end

	if not self.RUN_AND_RELOAD and self:_soft_interrupt_action_reload(t) ~= RELOAD_INTERRUPTED then
		self._running_wanted = true
		return
	end
				
	self._running_wanted = false

	if (not self._state_data.shake_player_start_running or not self._ext_camera:shaker():is_playing(self._state_data.shake_player_start_running)) and managers.user:get_setting("use_headbob") then
		self._state_data.shake_player_start_running = self._ext_camera:play_shaker("player_start_running" , 0.75)
	end
				
	self:set_running(true)

	self._end_running_expire_t = nil
	self._start_running_t = t
	
	--Skip sprinting animations if player is doing melee things.
	if not self:_is_charging_weapon() and not self:_is_meleeing() and (not self:_is_reloading() or not self.RUN_AND_RELOAD) then
		if not self._equipped_unit:base():run_and_shoot_allowed() then
			self._ext_camera:play_redirect(self:get_animation("start_running"), self._equipped_unit:base():exit_run_speed_multiplier())	
		else
			self._ext_camera:play_redirect(self:get_animation("idle"))	
		end	
	end
				
	self:_interupt_action_steelsight(t)
	self:_interupt_action_ducking(t)
end

function PlayerStandard:_end_action_running(t)
	if not self._end_running_expire_t then
		local weap_base = self._equipped_unit:base()
		local speed_multiplier = weap_base:exit_run_speed_multiplier()
		--The minigun has a weirdly long animation that snaps really badly if you interrupt it. so increase the base timer but give it a bigger multiplier to mostly compensate.
		self._end_running_expire_t = t + (weap_base._name_id == "m134" and 1 or 0.4) / speed_multiplier
		--Adds a few melee related checks to avoid cutting off animations.
		local stop_running = not self:_is_charging_weapon() and not self:_is_meleeing() and not weap_base:run_and_shoot_allowed() and (not self.RUN_AND_RELOAD or not self:_is_reloading())
		
		if stop_running then
			self._ext_camera:play_redirect(self:get_animation("stop_running"), speed_multiplier)
		end
	end
end

--Stores running input, is a workaround for other things that may interrupt running.
local orig_start_action_melee = PlayerStandard._start_action_melee
function PlayerStandard:_start_action_melee(t, ...)
	self._state_data.melee_running_wanted = self._running and not self._end_running_expire_t

	orig_start_action_melee(self, t, ...)

	--Passes in running input, is a workaround for other things that may interrupt running.
	if self._state_data.melee_running_wanted then
		self._running_wanted = true
	end

	--Start chainsaw timer.
	local melee_tweak = tweak_data.blackmarket.melee_weapons[managers.blackmarket:equipped_melee_weapon()]
	if melee_tweak.chainsaw then
		self._state_data.chainsaw_t = t + melee_tweak.chainsaw.start_delay
	end
end

local orig_check_action_melee = PlayerStandard._check_action_melee
function PlayerStandard:_check_action_melee(t, input)
	orig_check_action_melee(self, t, input)

	--Stop chainsaw when no longer meleeing.
	if input.btn_melee_release then
		self._state_data.chainsaw_t = nil
	end
end


--Effectively a slightly modified version of _do_melee_damage but without charging and certain melee gimmicks.
function PlayerStandard:_do_chainsaw_damage(t)
	melee_entry = managers.blackmarket:equipped_melee_weapon()

	--Determine if attack hits.
	local sphere_cast_radius = 20
	local col_ray = self:_calc_melee_hit_ray(t, sphere_cast_radius)

	if col_ray and alive(col_ray.unit) then
		local damage, damage_effect = managers.blackmarket:equipped_melee_weapon_damage_info(0)
		damage = tweak_data.blackmarket.melee_weapons[melee_entry].chainsaw.tick_damage
		damage = damage * managers.player:get_melee_dmg_multiplier()
		damage_effect = damage_effect * managers.player:get_melee_knockdown_multiplier()
		col_ray.sphere_cast_radius = sphere_cast_radius
		local hit_unit = col_ray.unit

		if hit_unit:character_damage() then
			local hit_sfx = "hit_body"

			if hit_unit:character_damage() and hit_unit:character_damage().melee_hit_sfx then
				hit_sfx = hit_unit:character_damage():melee_hit_sfx()
			end

			self:_play_melee_sound(melee_entry, hit_sfx, self._melee_attack_var)
			self:_play_melee_sound(melee_entry, "charge", self._melee_attack_var)

			if not hit_unit:character_damage()._no_blood then
				managers.game_play_central:play_impact_flesh({
					col_ray = col_ray
				})
				managers.game_play_central:play_impact_sound_and_effects({
					no_decal = true,
					no_sound = true,
					col_ray = col_ray
				})
			end
		else
			self:_play_melee_sound(melee_entry, "hit_gen", self._melee_attack_var)
			self:_play_melee_sound(melee_entry, "charge", self._melee_attack_var) -- continue playing charge sound after hit instead of silence

			managers.game_play_central:play_impact_sound_and_effects({
				no_decal = true,
				no_sound = true,
				col_ray = col_ray,
				effect = Idstring("effects/payday2/particles/impacts/fallback_impact_pd2")
			})
		end

		local custom_data = nil

		if _G.IS_VR and hand_id then
			custom_data = {
				engine = hand_id == 1 and "right" or "left"
			}
		end

		managers.game_play_central:physics_push(col_ray)

		local character_unit = character_unit or hit_unit
		if character_unit:character_damage() and character_unit:character_damage().damage_melee then
			local action_data = {
				variant = "melee",
				damage = damage,
				damage_effect = damage_effect,
				attacker_unit = self._unit,
				col_ray = col_ray,
				name_id = melee_entry,
				charge_lerp_value = 0 --There is no charging this attack.
			}

			local defense_data = character_unit:character_damage():damage_melee(action_data)

			self:_perform_sync_melee_damage(hit_unit, col_ray, action_data.damage)

			return defense_data
		else
			self:_perform_sync_melee_damage(hit_unit, col_ray, damage)
		end
	end

	return col_ray
end

--Updated version of vanilla function, adding in melee sprinting, chainsaw, and repeat_hit functionality.
function PlayerStandard:_update_melee_timers(t, input)
	--Resume normal sprinting animations once melee attack is done.
	--Making it not cancel the equip animation will require a fair amount more work, since it doesn't set the timers. Is a job for another day.
	if self._running and not self._end_running_expire_t and not self._state_data.meleeing and self._state_data.melee_expire_t and t >= self._state_data.melee_expire_t and not self:_is_charging_weapon() and (not self:_is_reloading() or not self.RUN_AND_RELOAD) and (instant or not self._state_data.melee_repeat_expire_t) then
		if not self._equipped_unit:base():run_and_shoot_allowed() then
			self._ext_camera:play_redirect(self:get_animation("start_running"))
		else
			self._ext_camera:play_redirect(self:get_animation("idle"))
		end
	elseif self._state_data.meleeing then
		local lerp_value = self:_get_melee_charge_lerp_value(t)

		self._camera_unit:anim_state_machine():set_parameter(self:get_animation("melee_charge_state"), "charge_lerp", math.bezier({
			0,
			0,
			1,
			1
		}, lerp_value))

		if self._state_data.melee_charge_shake then
			self._ext_camera:shaker():set_parameter(self._state_data.melee_charge_shake, "amplitude", math.bezier({
				0,
				0,
				1,
				1
			}, lerp_value))
		end
	end

	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	local melee_weapon = tweak_data.blackmarket.melee_weapons[melee_entry]
	local instant = melee_weapon.instant
	
	if self._state_data.melee_damage_delay_t and self._state_data.melee_damage_delay_t <= t then
		self:_do_melee_damage(t, nil, self._state_data.melee_hit_ray, melee_entry, self._did_melee_counter_attack)

		self._did_melee_counter_attack = nil
		self._state_data.melee_damage_delay_t = nil
		self._state_data.melee_hit_ray = nil
	--Trigger chainsaw damage and update timer. if melee hasn't been discharged.
	elseif melee_weapon.chainsaw and self._state_data.chainsaw_t and self._state_data.chainsaw_t < t then
		self:_do_chainsaw_damage(t)
		self._state_data.chainsaw_t = t + melee_weapon.chainsaw.tick_delay
	end

	if self._state_data.melee_attack_allowed_t and self._state_data.melee_attack_allowed_t <= t then
		self._state_data.melee_start_t = t
		local melee_charge_shaker = melee_weapon.melee_charge_shaker or "player_melee_charge"
		self._state_data.melee_charge_shake = self._ext_camera:play_shaker(melee_charge_shaker, 0)
		self._state_data.melee_attack_allowed_t = nil
	end

	if self._state_data.melee_repeat_expire_t and self._state_data.melee_repeat_expire_t <= t then
		self._state_data.melee_repeat_expire_t = nil

		if input.btn_meleet_state then
			self._state_data.melee_charge_wanted = not instant and true
		end
	end

	if self._state_data.melee_expire_t and self._state_data.melee_expire_t <= t then
		self._state_data.melee_expire_t = nil
		self._state_data.melee_repeat_expire_t = nil
		self._melee_repeat_damage_bonus = nil --Clear melee repeat bonus (from specialist knives and such) when melee is over.

		self:_stance_entered()

		if self._equipped_unit and input.btn_steelsight_state then
			self._steelsight_wanted = true
		end
	end
end

function PlayerStandard:_interupt_action_melee(t)
	if not self:_is_meleeing() then
		return
	end

	self._state_data.melee_hit_ray = nil
	self._state_data.melee_charge_wanted = nil
	self._state_data.melee_expire_t = nil
	self._state_data.melee_repeat_expire_t = nil
	self._state_data.melee_attack_allowed_t = nil
	self._state_data.melee_damage_delay_t = nil
	self._state_data.meleeing = nil	
	self._state_data.chainsaw_t = nil --Stop chainsaw stuff if also no longer in melee.
	self._melee_repeat_damage_bonus = nil --Same goes for the melee repeat hitter bonus.

	self._unit:sound():play("interupt_melee", nil, false)
	self:_play_melee_sound(managers.blackmarket:equipped_melee_weapon(), "hit_air", self._melee_attack_var)
	self._camera_unit:base():unspawn_melee_item()
	self._camera_unit:base():show_weapon()
	self:_play_equip_animation() --Use generic equip animation function.

	if self._state_data.melee_charge_shake then
		self._ext_camera:stop_shaker(self._state_data.melee_charge_shake)

		self._state_data.melee_charge_shake = nil
	end

	self:_stance_entered()

	--Interrupting melee attacks also interrupt melee sprinting.
	self:_interupt_action_running(t)
	local running = self._running and not self._end_running_expire_t
	if running then
		self._running_wanted = true
	end
end

function PlayerStandard:_start_action_jump(t, action_start_data)
	--Don't interrupt melee sprinting.
	if self._running and not self.RUN_AND_RELOAD and not self._equipped_unit:base():run_and_shoot_allowed() and not self._is_meleeing then
		self:_soft_interrupt_action_reload(t)
		self._ext_camera:play_redirect(self:get_animation("stop_running"), self._equipped_unit:base():exit_run_speed_multiplier())
	end

	self:_interupt_action_running(t)

	self._jump_t = t
	local jump_vec = action_start_data.jump_vel_z * math.UP

	self._unit:mover():jump()

	if self._move_dir then
		local move_dir_clamp = self._move_dir:normalized() * math.min(1, self._move_dir:length())
		self._last_velocity_xy = move_dir_clamp * action_start_data.jump_vel_xy
		self._jump_vel_xy = mvector3.copy(self._last_velocity_xy)
	else
		self._last_velocity_xy = Vector3()
	end

	self:_perform_jump(jump_vec)
end		

function PlayerStandard:_do_action_melee(t, input, skip_damage, countered)
	self._state_data.meleeing = nil
	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	local instant_hit = tweak_data.blackmarket.melee_weapons[melee_entry].instant
	local pre_calc_hit_ray = tweak_data.blackmarket.melee_weapons[melee_entry].hit_pre_calculation
	local melee_damage_delay = tweak_data.blackmarket.melee_weapons[melee_entry].melee_damage_delay or 0
	--Lets skills give faster melee charge and swing speeds.
	local charge_lerp_value = instant_hit and 0 or self:_get_melee_charge_lerp_value(t)
	local charge_bonus_start = tweak_data.blackmarket.melee_weapons[melee_entry].charge_bonus_start or 2 --i.e. never get the bonus
	local charge_bonus_speed = tweak_data.blackmarket.melee_weapons[melee_entry].charge_bonus_speed or 1
	local speed = tweak_data.blackmarket.melee_weapons[melee_entry].speed_mult or 1
	local anim_speed = tweak_data.blackmarket.melee_weapons[melee_entry].anim_speed_mult or 1
	speed = speed * anim_speed
	speed = speed * managers.player:upgrade_value("player", "melee_swing_multiplier", 1)
	melee_damage_delay = melee_damage_delay * (1 / managers.player:upgrade_value("player", "melee_swing_multiplier", 1))
	local melee_expire_t = tweak_data.blackmarket.melee_weapons[melee_entry].expire_t or 0 --Add fallbacks for certain stats.
	local melee_repeat_expire_t = tweak_data.blackmarket.melee_weapons[melee_entry].repeat_expire_t or 0
	melee_damage_delay = math.min(melee_damage_delay, tweak_data.blackmarket.melee_weapons[melee_entry].repeat_expire_t)
	local primary = managers.blackmarket:equipped_primary()
	local primary_id = primary.weapon_id
	local bayonet_id = managers.blackmarket:equipped_bayonet(primary_id)
	local bayonet_melee = false

	if bayonet_id and self._equipped_unit:base():selection_index() == 2 then
		bayonet_melee = true
	end
	
	if charge_lerp_value and charge_lerp_value > charge_bonus_start then
		speed = math.max(speed, speed * (charge_lerp_value * charge_bonus_speed))
		melee_damage_delay = math.min(melee_damage_delay, melee_damage_delay / (charge_lerp_value * charge_bonus_speed))
		melee_expire_t = math.min(melee_expire_t, melee_expire_t / (charge_lerp_value * charge_bonus_speed))
		melee_repeat_expire_t = math.min(melee_repeat_expire_t, melee_repeat_expire_t / (charge_lerp_value * charge_bonus_speed))
	end
	
	self._state_data.melee_expire_t = t + melee_expire_t
	self._state_data.melee_repeat_expire_t = t + math.min(melee_repeat_expire_t, melee_expire_t)
	if not instant_hit and not skip_damage then
		self._state_data.melee_damage_delay_t = t + melee_damage_delay

		if pre_calc_hit_ray then
			self._state_data.melee_hit_ray = self:_calc_melee_hit_ray(t, 20) or true
		else
			self._state_data.melee_hit_ray = nil
		end
	end

	local send_redirect = instant_hit and (bayonet_melee and "melee_bayonet" or "melee") or "melee_item"

	if instant_hit then
		managers.network:session():send_to_peers_synched("play_distance_interact_redirect", self._unit, send_redirect)
	else
		self._ext_network:send("sync_melee_discharge")
	end

	if self._state_data.melee_charge_shake then
		self._ext_camera:shaker():stop(self._state_data.melee_charge_shake)

		self._state_data.melee_charge_shake = nil
	end

	self._melee_attack_var = 0

	if instant_hit then
		local hit = skip_damage or self:_do_melee_damage(t, bayonet_melee)

		if hit then
			self._ext_camera:play_redirect(bayonet_melee and self:get_animation("melee_bayonet") or self:get_animation("melee"))
		else
			self._ext_camera:play_redirect(bayonet_melee and self:get_animation("melee_miss_bayonet") or self:get_animation("melee_miss"))
		end
	else
		local anim_attack_vars = tweak_data.blackmarket.melee_weapons[melee_entry].anim_attack_vars
		local anim_attack_charged_amount = tweak_data.blackmarket.melee_weapons[melee_entry].anim_attack_charged_amount or 0.5 --At half charge, use the charge variant
		local anim_attack_charged_vars = tweak_data.blackmarket.melee_weapons[melee_entry].anim_attack_charged_vars
		local anim_attack_left_vars = tweak_data.blackmarket.melee_weapons[melee_entry].anim_attack_left_vars
		local anim_attack_right_vars = tweak_data.blackmarket.melee_weapons[melee_entry].anim_attack_right_vars
		local timing_fix = tweak_data.blackmarket.melee_weapons[melee_entry].timing_fix
		local timing_fix_speed_mult = tweak_data.blackmarket.melee_weapons[melee_entry].timing_fix_speed_mult or 1
		self._melee_attack_var = anim_attack_vars and math.random(#anim_attack_vars)

		self:_play_melee_sound(melee_entry, "hit_air", self._melee_attack_var)

		local melee_item_tweak_anim = "attack"
		local melee_item_prefix = ""
		local melee_item_suffix = ""
		local anim_attack_param = anim_attack_vars and anim_attack_vars[self._melee_attack_var]
		
		if anim_attack_charged_vars and charge_lerp_value >= anim_attack_charged_amount then
			self._melee_attack_var = anim_attack_charged_vars and math.random(#anim_attack_charged_vars)
			anim_attack_param = anim_attack_charged_vars and anim_attack_charged_vars[self._melee_attack_var]
		elseif self._stick_move then
			local angle = mvector3.angle(self._stick_move, math.X)
			if anim_attack_left_vars and angle and (angle <= 180) and (angle >= 135) then
				self._melee_attack_var = anim_attack_left_vars and math.random(#anim_attack_left_vars)
				anim_attack_param = anim_attack_left_vars and anim_attack_left_vars[self._melee_attack_var]
			elseif anim_attack_right_vars and angle and (angle <= 45) and (angle >= 0) then
				self._melee_attack_var = anim_attack_right_vars and math.random(#anim_attack_right_vars)
				anim_attack_param = anim_attack_right_vars and anim_attack_right_vars[self._melee_attack_var]
			end
		end

		if countered then
			self._did_melee_counter_attack = true
		end

		local fix_anim_timer = anim_attack_param and timing_fix and table.contains(timing_fix, anim_attack_param)
		if fix_anim_timer then
			speed = speed * timing_fix_speed_mult
		end

		local state = self._ext_camera:play_redirect(self:get_animation("melee_attack"), speed) --Apply speed mult to animation.
		if anim_attack_param then
			self._camera_unit:anim_state_machine():set_parameter(state, anim_attack_param, 1)

			melee_item_prefix = anim_attack_param .. "_"
		end

		if self._state_data.melee_hit_ray and self._state_data.melee_hit_ray ~= true then
			self._camera_unit:anim_state_machine():set_parameter(state, "hit", 1)

			melee_item_suffix = "_hit"
		end

		melee_item_tweak_anim = melee_item_prefix .. melee_item_tweak_anim .. melee_item_suffix

		self._camera_unit:base():play_anim_melee_item(melee_item_tweak_anim)
	end
end

--Remove vanilla function, since it has a number of issues that conflict with the crosshair system in HEAT.
--The crosshair should only need to be updated once per frame, and it needs time data that many of the calls here do not provide.
function PlayerStandard:_update_crosshair_offset(t)
end

function PlayerStandard:is_shooting_count()
	return self._shooting and self._equipped_unit and self._equipped_unit:base():burst_rounds_remaining()
end

--Recoil used at the end of burst fire.
function PlayerStandard:force_recoil_kick(weap_base, shots_fired)
	local recoil_multiplier = (weap_base:recoil() + weap_base:recoil_addend()) * weap_base:recoil_multiplier() * (shots_fired or 1)
	local up, down, left, right = unpack(weap_base:weapon_tweak_data().kick[self._state_data.in_steelsight and "steelsight" or self._state_data.ducking and "crouching" or "standing"])
	self._camera_unit:base():recoil_kick(up * recoil_multiplier, down * recoil_multiplier, left * recoil_multiplier, right * recoil_multiplier, true)
end

function PlayerStandard:_start_action_steelsight(t, gadget_state)
	if self:_changing_weapon() or self:_interacting() or self:_is_meleeing() or self._use_item_expire_t or self:_is_throwing_projectile() or self:_on_zipline() then
		self._steelsight_wanted = true

		return
	end

	if self._running and not self._end_running_expire_t then
		self:_interupt_action_running(t)

		self._steelsight_wanted = true

		return
	end

	local weap_base = self._equipped_unit:base()
	if self:_soft_interrupt_action_reload(t) == RELOADING then
		return
	end

	self:_break_intimidate_redirect(t)

	self._steelsight_wanted = false
	self._state_data.in_steelsight = true

	self:_stance_entered()
	self:_interupt_action_running(t)
	self:_interupt_action_cash_inspect(t)

	if gadget_state ~= nil then
		weap_base:play_sound("gadget_steelsight_" .. (gadget_state and "enter" or "exit"))
	else
		weap_base:play_tweak_data_sound("enter_steelsight")
	end

	if self._state_data.in_steelsight or self._steelsight_wanted then
		if weap_base:has_spin() then
			weap_base:vulcan_enter_steelsight()
		end
	end

	if weap_base:weapon_tweak_data().animations.has_steelsight_stance then
		self:_need_to_play_idle_redirect()

		self._state_data.steelsight_weight_target = 1

		self._camera_unit:base():set_steelsight_anim_enabled(true)
	end


	self._state_data.reticle_obj = weap_base.get_reticle_obj and weap_base:get_reticle_obj()

	if managers.controller:get_default_wrapper_type() ~= "pc" and managers.user:get_setting("aim_assist") then
		local closest_ray = self._equipped_unit:base():check_autoaim(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), nil, true)

		self._camera_unit:base():clbk_aim_assist(closest_ray)
	end

	self._ext_network:send("set_stance", 3, false, false)
	managers.job:set_memory("cac_4", true)
end

--Ends minigun spinup.
local orig_end_action_steelsight = PlayerStandard._end_action_steelsight
function PlayerStandard:_end_action_steelsight(t, gadget_state)
	self._state_data.was_in_steelsight = true --Flag that steelsight is being left.
	orig_end_action_steelsight(self, t, gadget_state)
	self._state_data.was_in_steelsight = false

	if not self._state_data.in_steelsight then
		local weapon = self._unit:inventory():equipped_unit():base()
		if weapon:has_spin() then
			weapon:vulcan_exit_steelsight()
		end
	end
end

function PlayerStandard:discharge_melee()
	self:_do_action_melee(managers.player:player_timer():time(), nil, nil, nil, true)
end

local melee_vars = {
	"player_melee",
	"player_melee_var2"
}
function PlayerStandard:_do_melee_damage(t, bayonet_melee, melee_hit_ray, melee_entry, countered)
	melee_entry = melee_entry or bayonet_melee and "weapon" or managers.blackmarket:equipped_melee_weapon()
	local melee_damage_delay = tweak_data.blackmarket.melee_weapons[melee_entry].melee_damage_delay or 0
	local sphere_cast_radius = 20

	--Melee weapon tweakdata.
	local melee_weapon = tweak_data.blackmarket.melee_weapons[melee_entry]
	--Holds info for certain melee gimmicks (IE: Taser Shock, Psycho Knife Panic, ect)
	local special_weapon = melee_weapon.special_weapon

	-- If true, disables the shaker when a melee weapon connects
	local instant_hit = tweak_data.blackmarket.melee_weapons[melee_entry].instant
	local charge_lerp_value = instant_hit and 0 or self:_get_melee_charge_lerp_value(t, melee_damage_delay)
	if not melee_weapon.no_hit_shaker then
		self._ext_camera:play_shaker(melee_vars[math.random(#melee_vars)], math.max(0.3, charge_lerp_value))
	end

	local col_ray = nil
	if melee_hit_ray then
		col_ray = melee_hit_ray ~= true and melee_hit_ray or nil
	else
		col_ray = self:_calc_melee_hit_ray(t, sphere_cast_radius)
	end

	if col_ray and alive(col_ray.unit) then
		local damage, damage_effect = managers.blackmarket:equipped_melee_weapon_damage_info(charge_lerp_value)
		damage = damage * managers.player:get_melee_dmg_multiplier()
		damage_effect = damage_effect * managers.player:get_melee_knockdown_multiplier()

		--Allows melee weapons to bash open locks. Scales with knockdown.
		if col_ray.unit:damage() and col_ray.body:extension() and col_ray.body:extension().damage then
			local hit , _ = col_ray.body:extension().damage:damage_lock(managers.player:player_unit(), col_ray.normal, col_ray.position, col_ray.ray, damage_effect * 0.2)
			if hit then
				if col_ray.unit:id() ~= -1 then
					managers.network:session():send_to_peers_synched("sync_body_damage_lock", col_ray.body, damage_effect * 0.2)
				end
						
				managers.game_play_central:play_impact_sound_and_effects({
					col_ray = col_ray,
					decal = "saw"
				})

				local new_alert = {
					"vo_cbt",
					self._unit:movement():m_head_pos(),
					450,
					self._unit:movement():SO_access(),
					self._unit
				}
				managers.groupai:state():propagate_alert(new_alert)
			end
		end

		col_ray.sphere_cast_radius = sphere_cast_radius
		local hit_unit = col_ray.unit
		if hit_unit:character_damage() then
			if bayonet_melee then
				self._unit:sound():play("fairbairn_hit_body", nil, false)
			elseif special_weapon == "taser" and charge_lerp_value ~= 1 then --Feedback for non-charged attacks with shock weapons. Might not do anything, need to verify.
				self._unit:sound():play("melee_hit_gen", nil, false)
			else
				self:_play_melee_sound(melee_entry, "hit_body")
			end
			if not hit_unit:character_damage()._no_blood then
				managers.game_play_central:play_impact_flesh({col_ray = col_ray})
				managers.game_play_central:play_impact_sound_and_effects({
					col_ray = col_ray,
					no_decal = true,
					no_sound = true
				})
			end
			self._camera_unit:base():play_anim_melee_item("hit_body")
		elseif self._on_melee_restart_drill and hit_unit:base() and (hit_unit:base().is_drill or hit_unit:base().is_saw) then
			hit_unit:base():on_melee_hit(managers.network:session():local_peer():id())
		else
			if bayonet_melee then
				self._unit:sound():play("knife_hit_gen", nil, false)
			elseif special_weapon == "taser" and charge_lerp_value ~= 1 then --Feedback for non-charged attacks with shock weapons. Might not do anything, need to verify.
					self._unit:sound():play("melee_hit_gen", nil, false)
			else
				self:_play_melee_sound(melee_entry, "hit_gen")
			end
			managers.game_play_central:play_impact_sound_and_effects({
				col_ray = col_ray,
				effect = Idstring("effects/payday2/particles/impacts/fallback_impact_pd2"),
				no_decal = true,
				no_sound = true
			})
		end

		local custom_data = nil
			
		if _G.IS_VR then
			local melee_hand_id = self._unit:hand():get_active_hand_id("melee")
			melee_hand_id = melee_hand_id or self._unit:hand():get_active_hand_id("weapon")

			if melee_hand_id then
				custom_data = {engine = melee_hand_id == 1 and "right" or "left"}
			end
		end			

		managers.rumble:play("melee_hit", nil, nil, custom_data)
		managers.game_play_central:physics_push(col_ray)
		
		local character_unit, shield_knock
		if hit_unit:in_slot(8) and alive(hit_unit:parent()) and hit_unit:parent():character_damage():can_melee_knock_shield(damage_effect) then
			shield_knock = true
			character_unit = hit_unit:parent()
		end

		character_unit = character_unit or hit_unit
		if character_unit:character_damage() and character_unit:character_damage().damage_melee then
			--Do melee gimmick stuff. Might be worth it to use function references instead of branching later on if we get more of these.
			damage = damage * (self._melee_repeat_damage_bonus or 1)
			if special_weapon == "repeat_hitter" then
				self._melee_repeat_damage_bonus = 2.0
			elseif special_weapon == "hyper_crit" and math.random() <= 0.05 then
				damage = damage * 10
				damage_effect = damage_effect * 10
				self._unit:sound():play("bell_ring")
			elseif charge_lerp_value >= 0.99 and special_weapon == "panic" then
				managers.player:spread_panic(1)
			end

			if countered and melee_weapon.counter_damage then
				damage = damage * melee_weapon.counter_damage
				damage_effect = damage_effect * melee_weapon.counter_damage
			end 

			local action_data = {
				variant = special_weapon == "taser" and "taser_tased" or "melee",
				damage = shield_knock and 0 or damage,
				damage_effect = damage_effect,
				attacker_unit = self._unit,
				col_ray = col_ray,
				shield_knock = shield_knock,
				name_id = melee_entry,
				charge_lerp_value = charge_lerp_value,
				backstab_multiplier = melee_weapon.backstab_damage_multiplier or 1,
				headshot_multiplier = melee_weapon.headshot_damage_multiplier or 1,
				armor_piercing = melee_weapon.damage_type == "bludgeoning"
			}
			
			local defense_data = character_unit:character_damage():damage_melee(action_data)
			self:_check_melee_dot_damage(col_ray, defense_data, melee_entry)
			self:_perform_sync_melee_damage(hit_unit, col_ray, action_data.damage)

			if tweak_data.blackmarket.melee_weapons[melee_entry].fire_dot_data and character_unit:character_damage().damage_fire then
				local action_data = {
					variant = "fire",
					damage = 0,
					attacker_unit = self._unit,
					col_ray = col_ray,
					fire_dot_data = tweak_data.blackmarket.melee_weapons[melee_entry].fire_dot_data
				}

				character_unit:character_damage():damage_fire(action_data)
			end

			return defense_data
		else
			self:_perform_sync_melee_damage(hit_unit, col_ray, damage)
		end
	end
	return col_ray
end

--Now also returns steelsight information. Used for referencing spread values to give steelsight bonuses.
function PlayerStandard:get_movement_state()
	--Is stance done check ensures that steelsight is only returned if we actually finish the steelsight animation.
	if self._state_data.in_steelsight and self._camera_unit:base():is_stance_done() then
		return self._moving and "moving_steelsight" or "steelsight"
	end

	if self._state_data.ducking then
		return self._moving and "moving_crouching" or "crouching"
	else
		return self._moving and "moving_standing" or "standing"
	end
end

--Initiate dodge stuff when player enters a state where they can begin dodging stuff.
--Crashes here indicate syntax errors in playerdamage.
local orig_enter = PlayerStandard._enter
function PlayerStandard:_enter(enter_data)
	orig_enter(self, enter_data)
	self._ext_damage:set_dodge_points()
	self._can_free_run = managers.player:has_category_upgrade("player", "can_free_run")
	self._can_trigger_happy_all_guns = managers.player:has_category_upgrade("pistol", "trigger_happy_all_guns")

	--Cooldown on crosshair expansion from shooting, allows for a satisfying jiggle for full auto guns.
	self._next_crosshair_jiggle = 0.0

	--Don't hide the crosshair during steelsight for weapons of these categories.
	--Check for it whenever we enter PlayerStandard, or swap weapons.
	self._crosshair_ignore_steelsight = self._equipped_unit:base():is_category("akimbo", "minigun")

	--Set the crosshair to be visible.
	managers.hud:show_crosshair_panel(true)
end

--Update whenever the crosshair should ignore steelsights whenever the equipped gun changes.
--Also kick off offhand reloads as desired.
local orig_inventory_clbk_listener = PlayerStandard.inventory_clbk_listener
function PlayerStandard:inventory_clbk_listener(unit, event, ...)
	orig_inventory_clbk_listener(self, unit, event, ...)

	if event == "equip" then
		self._crosshair_ignore_steelsight = self._equipped_unit:base():is_category("akimbo", "minigun")
		self:_attempt_offhand_reload()
	elseif event == "unequip" then
		self:_stop_offhand_reload()
	end
end

--Checks if the current "offhand" gun (The gun not currently equipped) can be automatically reloaded in the background.
--If so, then kick off the auto reload.
--Timer is based on the original reload speed * the multiplier resulting from auto-reload skills.
--Timer results are handled in update_reload_timers.
--Called when swapping weapons, or when picking up ammo (since this may enable a previously impossible reload).
function PlayerStandard:_attempt_offhand_reload()
	if not self._state_data.offhand_reload_t then
		local weap_base = self._equipped_unit:base()
		
		local speed_multiplier = weap_base:get_offhand_auto_reload_speed()
		if speed_multiplier then
			local offhand_weapon = self._ext_inventory:get_next_selection()
			offhand_weapon = offhand_weapon and offhand_weapon.unit and offhand_weapon.unit:base()

			if offhand_weapon and offhand_weapon:can_reload() and not offhand_weapon:clip_full() then
				local t = Application:time()
				local is_empty = offhand_weapon:clip_empty()

				speed_multiplier = speed_multiplier * offhand_weapon:reload_speed_multiplier()
				local auto_reload_time = offhand_weapon:reload_expire_t(not is_empty)
				
				if not auto_reload_time then --Weapon doesn't use per-bullet reloads, use tweak timers instead.
					local timers = offhand_weapon:weapon_tweak_data().timers
					auto_reload_time = (is_empty and timers.reload_empty or timers.reload_not_empty) / speed_multiplier
				else --Per-bullet reloads return a non-nil reload_expire_t().
					auto_reload_time = auto_reload_time / speed_multiplier

					--Figure out how long each bullet takes to reload. Not 100% matching manual reload, but nobody is going to notice.
					local bullets_missing = offhand_weapon:max_bullets_to_reload(is_empty)
					self._state_data.bullets_to_load = offhand_weapon:bullets_per_load(is_empty)
					self._state_data.offhand_per_bullet_reload_t = auto_reload_time / math.ceil(bullets_missing / self._state_data.bullets_to_load)
					self._state_data.offhand_reload_next_bullet_t = t + self._state_data.offhand_per_bullet_reload_t - 0.01 --Offset avoids some floating point nonsense I was having.
				end

				self._state_data.offhand_reload_t = t + auto_reload_time
				self._state_data.offhand_reload_empty = is_empty
				managers.hud:start_cooldown("offhand_auto_reload", auto_reload_time)
			end
		end
	elseif self._state_data.offhand_per_bullet_reload_t then
		--Picking up ammo boxes can potentially increase the number of bullets that per-bullet reloads can reload.
		--So extend the time remaining by the desired amount and update the buff tracker.
		local t = Application:time()
		local offhand_weapon = self._ext_inventory:get_next_selection()
		offhand_weapon = offhand_weapon and offhand_weapon.unit and offhand_weapon.unit:base()

		if offhand_weapon then
			local bullets_missing = offhand_weapon:max_bullets_to_reload(self._state_data.offhand_reload_empty)
			local old_offhand_reload_t = self._state_data.offhand_reload_t
			self._state_data.offhand_reload_t = t + self._state_data.offhand_per_bullet_reload_t * bullets_missing
			managers.hud:change_cooldown("offhand_auto_reload", self._state_data.offhand_reload_t - old_offhand_reload_t)
		end
	end
end

--Stops any currently active offhand reloads. 
function PlayerStandard:_stop_offhand_reload()
	managers.hud:remove_skill("offhand_auto_reload")
	self._state_data.offhand_reload_t = nil
	self._state_data.bullets_to_load = nil
	self._state_data.offhand_reload_next_bullet_t = nil
	self._state_data.offhand_per_bullet_reload_t = nil
	self._state_data.offhand_reload_empty = nil
end

function PlayerStandard:_update_reload_timers(t, dt, input)
	local state = self._state_data
	
	if state.reload_enter_expire_t and state.reload_enter_expire_t <= t then
		state.reload_enter_expire_t = nil

		self:_start_action_reload(t)
	end

	local weapon = alive(self._equipped_unit) and self._equipped_unit:base()
	
	if state.reload_expire_t then
		local interupt = nil
		local speed_multiplier = self._equipped_unit:base():reload_speed_multiplier()
		if weapon:update_reloading(t, dt, state.reload_expire_t - t) then --Update reloading if using a per-bullet reload.
			managers.hud:set_ammo_amount(weapon:selection_index(), weapon:ammo_info())
			
			if self._queue_reload_interupt then
				self._queue_reload_interupt = nil
				interupt = true
			elseif state.reload_expire_t <= t then --Update timers in case player total ammo changes to allow for more to be reloaded.
				state.reload_expire_t = t + (weapon:reload_expire_t(not weapon:started_reload_empty()) or 2.2) / speed_multiplier
			end
			managers.player:consume_shell_rack_stacks(weapon)
		elseif state.refill_half_magazine_t and state.refill_half_magazine_t <= t then
			weapon:on_half_reload() --Load up one magazine on an akimbo weapon. If timer is set on a non-akimbo weapon, expect a crash (so don't set it!).

			--Update trackers.
			managers.statistics:reloaded()
			managers.hud:set_ammo_amount(weapon:selection_index(), weapon:ammo_info())
			managers.player:consume_shell_rack_stacks(weapon)

			state.refill_half_magazine_t = nil
		elseif state.refill_magazine_t and state.refill_magazine_t <= t then
			weapon:on_reload() --Load up the magazine.
			
			--Update trackers.
			managers.statistics:reloaded()
			managers.hud:set_ammo_amount(weapon:selection_index(), weapon:ammo_info())
			managers.player:consume_shell_rack_stacks(weapon)
			
			state.refill_magazine_t = nil --Magazine loaded, so no time to reload it exists any more.
		end

		if state.reload_expire_t <= t or interupt then --The reload is complete, or has been interrupted.
			state.reload_expire_t = nil

			local empty_reload = weapon:started_reload_empty()
			local reload_exit_expire_t = weapon:reload_exit_expire_t(not empty_reload)
			if reload_exit_expire_t then
				state.reload_exit_expire_t = t + reload_exit_expire_t / speed_multiplier
				local reload_type = empty_reload and  "reload_exit" or "reload_not_empty_exit"
				self._ext_camera:play_redirect(self:get_animation(reload_type), speed_multiplier)
				weapon:tweak_data_anim_play(reload_type, speed_multiplier)
			else --Reload animation is complete, return to business as usual.
				if input.btn_steelsight_state then
					self._steelsight_wanted = true
				elseif self.RUN_AND_RELOAD and self._running and not self._end_running_expire_t and not weapon:run_and_shoot_allowed() then
					self._ext_camera:play_redirect(self:get_animation("start_running"))
				end
			end
		end
	end

	if state.reload_exit_expire_t and state.reload_exit_expire_t <= t then
		state.reload_exit_expire_t = nil

		managers.statistics:reloaded()
		managers.hud:set_ammo_amount(weapon:selection_index(), weapon:ammo_info())

		if input.btn_steelsight_state then
			self._steelsight_wanted = true
		elseif self.RUN_AND_RELOAD and self._running and not self._end_running_expire_t and not weapon:run_and_shoot_allowed() then
			self._ext_camera:play_redirect(self:get_animation("start_running"))
		end

		if weapon.on_reload_stop then
			weapon:on_reload_stop()
		end
	end

	if state.offhand_reload_t then
		local offhand_weapon = self._ext_inventory:get_next_selection()
		offhand_weapon = offhand_weapon and alive(offhand_weapon.unit) and offhand_weapon.unit:base()
		if offhand_weapon then
			--Handle "per-bullet" reloads.
			if state.offhand_reload_next_bullet_t and state.offhand_reload_next_bullet_t < t then
				offhand_weapon:play_tweak_data_sound("enter_steelsight") --Use steelsight noise as an audio que for the auto-reload.
				state.offhand_reload_next_bullet_t = t + state.offhand_per_bullet_reload_t - 0.01
				if state.offhand_reload_empty or not offhand_weapon:weapon_tweak_data().tactical_reload then --Extra clamping for sanity, but probably not needed.
					offhand_weapon:set_ammo_remaining_in_clip(math.min(offhand_weapon:get_ammo_max_per_clip(), offhand_weapon:get_ammo_remaining_in_clip() + state.bullets_to_load))
				else
					offhand_weapon:set_ammo_remaining_in_clip(math.min(offhand_weapon:get_ammo_max_per_clip() + 1, offhand_weapon:get_ammo_remaining_in_clip() + state.bullets_to_load))
				end
				managers.player:consume_shell_rack_stacks(offhand_weapon)
				managers.job:set_memory("kill_count_no_reload_" .. tostring(offhand_weapon._name_id), nil, true)
				managers.hud:set_ammo_amount(offhand_weapon:selection_index(), offhand_weapon:ammo_info())
			end

			if state.offhand_reload_t < t then
				--If not a per-bullet reload, then we should just reload "normally".
				if not state.offhand_reload_next_bullet_t then
					offhand_weapon:play_tweak_data_sound("enter_steelsight")
					offhand_weapon:on_reload() --Load up the magazine.
					managers.hud:set_ammo_amount(offhand_weapon:selection_index(), offhand_weapon:ammo_info())
					managers.statistics:reloaded()
					managers.player:consume_shell_rack_stacks(offhand_weapon)
				end

				self:_stop_offhand_reload()
			end
		end
	end
end

--Add a check for queued inputs.
function PlayerStandard:_check_action_reload(t, input)
	local new_action = nil
	local action_wanted = self._queue_reload_start or input.btn_reload_press

	if action_wanted then
		local action_forbidden = self:_is_reloading() or self:_changing_weapon() or self:_is_meleeing() or self._use_item_expire_t or self:_interacting() or self:_is_throwing_projectile()

		if self:is_shooting_count() then --Queue a reload to occur once the current burst ends.
			self._queue_reload_start = true
		elseif not action_forbidden and self._equipped_unit and not self._equipped_unit:base():clip_full() then
			self:_start_action_reload_enter(t)
			
			new_action = not self._queue_reload_start
		end
	end

	return new_action
end

--Adds a delay + input queuing based on the firing delay of the weapon for 2 reasons.
--1. Reduce animation clipping.
--2. To make using the short duration reload speed bonus on kill smoother on projectile weapons.
--Also invalidates the current cached reload speed multiplier.
function PlayerStandard:_start_action_reload_enter(t)
	local weapon = self._equipped_unit:base()

	--Wait until the current firing animation has completed or the weapon flags an immediate reload to start reloading.
	if weapon and weapon:can_reload() then
		if weapon:start_shooting_allowed() then
			self._queue_reload_start = false
			managers.player:send_message_now(Message.OnPlayerReload, nil, self._equipped_unit)
			self:_interupt_action_steelsight(t)

			if not self.RUN_AND_RELOAD then
				self:_interupt_action_running(t)
			end

			weapon:invalidate_current_reload_speed_multiplier()
			local is_reload_not_empty = weapon:clip_not_empty()
			local base_reload_enter_expire_t = weapon:reload_enter_expire_t(is_reload_not_empty)

			if base_reload_enter_expire_t and base_reload_enter_expire_t > 0 then
				local speed_multiplier = weapon:reload_speed_multiplier()

				self._ext_camera:play_redirect(Idstring("reload_enter_" .. weapon.name_id), speed_multiplier)

				self._state_data.reload_enter_expire_t = t + base_reload_enter_expire_t / speed_multiplier

				weapon:tweak_data_anim_play("reload_enter", speed_multiplier)
				return
			end

			self:_start_action_reload(t)
		elseif not weapon:use_shotgun_reload() then
			--Otherwise, flag that we want the reload to start at the soonest opportunity.
			self._queue_reload_start = true
		end
	end
end
function PlayerStandard:_start_action_reload(t)
	local weapon = self._equipped_unit:base()

	if weapon and weapon:can_reload() then
		weapon:tweak_data_anim_stop("fire")
		weapon:start_reload() --Executed earlier to get accurate reload timers, otherwise may mess up normal and tactical for shotguns.

		local shotgun_reload = weapon:use_shotgun_reload()
		local weapon_tweak = weapon:weapon_tweak_data()
		local anim_tweak = weapon_tweak.animations
		local timers = weapon_tweak.timers
		local reload_prefix = weapon:reload_prefix() or ""
		--Extra check for anim_tweak needed for beardlib custom animation support.
		local reload_name_id = anim_tweak and anim_tweak.reload_name_id or weapon_tweak.reload_name_id or weapon.name_id
		local speed_multiplier = weapon:reload_speed_multiplier()

		if weapon:clip_empty() or (weapon.AKIMBO and weapon:get_ammo_remaining_in_clip() == 1) then --Play empty anim for Akimbos if one of the two guns is dry.
			--Tracks time until end of the animation for reloading.
			self._state_data.reload_expire_t = t + (timers.reload_empty or weapon:reload_expire_t(false) or 2.6) / speed_multiplier

			if not shotgun_reload then
				--Set time to actually add ammo to the gun, pretty much always before the actual animation finishes.
				self._state_data.refill_magazine_t = ((timers.empty_reload_operational and t + timers.empty_reload_operational / speed_multiplier) or self._state_data.reload_expire_t)

				--Many akimbo weapons have 2 seperate magazine reload events, set the timer for when the first one should occur and refill the ammo missing from one gun.
				--Timer is ignored otherwise.
				self._state_data.refill_half_magazine_t = timers.empty_half_reload_operational and t + timers.empty_half_reload_operational / speed_multiplier

				--Set time where non-commital animations like sprinting or ADS can interrupt the reload.
				--False == always interruptable. Make sure to set the timers!
				self._state_data.reload_soft_interrupt_t = timers.empty_reload_interrupt and t + timers.empty_reload_interrupt / speed_multiplier
			end

			self._ext_camera:play_redirect(Idstring(reload_prefix .. "reload_" .. reload_name_id), speed_multiplier)
			if anim_tweak.ignore_fullreload or not weapon:tweak_data_anim_play("reload", speed_multiplier) then
				weapon:tweak_data_anim_play("reload_not_empty", speed_multiplier)
			end
		else
			self._state_data.reload_expire_t = t + (timers.reload_not_empty or weapon:reload_expire_t(true) or 2.2) / speed_multiplier
			
			if not shotgun_reload then
				self._state_data.refill_magazine_t = (timers.reload_operational and t + timers.reload_operational / speed_multiplier) or self._state_data.reload_expire_t
				self._state_data.refill_half_magazine_t = timers.half_reload_operational and t + timers.half_reload_operational / speed_multiplier
				self._state_data.reload_soft_interrupt_t = timers.reload_interrupt and t + timers.reload_interrupt / speed_multiplier
			end
			
			self._ext_camera:play_redirect(Idstring(reload_prefix .. "reload_not_empty_" .. reload_name_id), speed_multiplier)
			if anim_tweak.ignore_nonemptyreload or not weapon:tweak_data_anim_play("reload_not_empty", speed_multiplier) then
				weapon:tweak_data_anim_play("reload", speed_multiplier)
			end
		end
		
		--Gather network data for syncing.
		local empty_reload = weapon:clip_empty() and 1 or 0
		if shotgun_reload then
			empty_reload = weapon:get_ammo_max_per_clip() - weapon:get_ammo_remaining_in_clip()
		end

		self._ext_network:send("reload_weapon", empty_reload, speed_multiplier)
	end
end

function PlayerStandard:_start_action_unequip_weapon(t, data)
	local speed_multiplier = self:_get_swap_speed_multiplier(true) --Signal that we are holstering the current weapon.

	self._equipped_unit:base():tweak_data_anim_stop("equip")
	self._equipped_unit:base():tweak_data_anim_play("unequip", speed_multiplier)

	local tweak_data = self._equipped_unit:base():weapon_tweak_data()
	self._change_weapon_data = data
	self._unequip_weapon_expire_t = t + (tweak_data.timers.unequip or 0.5) / speed_multiplier

	self:_interupt_action_running(t)
	self:_interupt_action_charging_weapon(t)

	local result = self._ext_camera:play_redirect(self:get_animation("unequip"), speed_multiplier)

	self:_interupt_action_reload(t)
	self:_interupt_action_steelsight(t)
	self._ext_network:send("switch_weapon", speed_multiplier, 1)
end

function PlayerStandard:_get_swap_speed_multiplier(is_holstering)
	local weap_base = self._equipped_unit:base()
	local weapon_tweak_data = weap_base:weapon_tweak_data()
	local player_manager = managers.player
	local base_multiplier = (weapon_tweak_data.swap_speed_multiplier or 1) --Base Multiplier reflects weapon base stats, and uses multiplicative values.
	base_multiplier = base_multiplier * tweak_data.weapon.stats.mobility[weap_base:get_concealment()] --Get concealment bonus/penalty.
	local skill_multiplier = 1 --Skill multiplier reflects bonuses from skills, and has additive scaling to match other skills.
	skill_multiplier = skill_multiplier + player_manager:upgrade_value("weapon", "swap_speed_multiplier", 1) - 1
	skill_multiplier = skill_multiplier + player_manager:upgrade_value("weapon", "passive_swap_speed_multiplier", 1) - 1
	skill_multiplier = skill_multiplier + player_manager:upgrade_value("team", "crew_faster_swap", 1) - 1

	--Get per category multipliers (IE: Pistols swap faster, Akimbos swap slower, ect).
	for _, category in ipairs(weapon_tweak_data.categories) do
		base_multiplier = base_multiplier * (tweak_data[category] and tweak_data[category].swap_bonus or 1)
		skill_multiplier = skill_multiplier + player_manager:upgrade_value(category, "swap_speed_multiplier", 1) - 1
	end

	if managers.player:has_activate_temporary_upgrade("temporary", "swap_weapon_faster") then
		skill_multiplier = skill_multiplier + player_manager:temporary_upgrade_value("temporary", "swap_weapon_faster", 1) - 1
	end

	if is_holstering then
		if weap_base:clip_empty() then
			skill_multiplier = skill_multiplier + player_manager:upgrade_value("weapon", "empty_unequip_speed_multiplier", 1) - 1
		end

		skill_multiplier = skill_multiplier + player_manager:close_combat_upgrade_value("weapon", "close_combat_holster_speed_multiplier", 1) - 1
		for _, category in ipairs(weapon_tweak_data.categories) do
			skill_multiplier = skill_multiplier + player_manager:close_combat_upgrade_value(category, "close_combat_holster_speed_multiplier", 1) - 1
		end
	else
		skill_multiplier = skill_multiplier + player_manager:close_combat_upgrade_value("weapon", "close_combat_draw_speed_multiplier", 1) - 1
		for _, category in ipairs(weapon_tweak_data.categories) do
			skill_multiplier = skill_multiplier + player_manager:close_combat_upgrade_value(category, "close_combat_draw_speed_multiplier", 1) - 1
		end
	end

	local multiplier = base_multiplier * skill_multiplier
	return managers.modifiers:modify_value("PlayerStandard:GetSwapSpeedMultiplier", multiplier)
end

--Inspire no longer works through walls.
function PlayerStandard:_get_unit_intimidation_action(intimidate_enemies, intimidate_civilians, intimidate_teammates, only_special_enemies, intimidate_escorts, intimidation_amount, primary_only, detect_only, secondary)
	local char_table = {}
	local unit_type_enemy = 0
	local unit_type_civilian = 1
	local unit_type_teammate = 2
	local unit_type_camera = 3
	local unit_type_turret = 4
	local cam_fwd = self._ext_camera:forward()
	local my_head_pos = self._ext_movement:m_head_pos()

	if _G.IS_VR then
		local hand_unit = self._unit:hand():hand_unit(self._interact_hand)

		if hand_unit:raycast("ray", hand_unit:position(), my_head_pos, "slot_mask", 1) then
			return
		end

		cam_fwd = hand_unit:rotation():y()
		my_head_pos = hand_unit:position()
	end

	local spotting_mul = managers.player:upgrade_value("player", "marked_distance_mul", 1)
	local range_mul = managers.player:upgrade_value("player", "intimidate_range_mul", 1) * managers.player:upgrade_value("player", "passive_intimidate_range_mul", 1)
	local intimidate_range_civ = tweak_data.player.long_dis_interaction.intimidate_range_civilians * range_mul
	local intimidate_range_ene = tweak_data.player.long_dis_interaction.intimidate_range_enemies * range_mul
	local highlight_range = tweak_data.player.long_dis_interaction.highlight_range * range_mul * spotting_mul
	local intimidate_range_teammates = tweak_data.player.long_dis_interaction.intimidate_range_teammates

	if intimidate_enemies then
		local enemies = managers.enemy:all_enemies()

		for u_key, u_data in pairs(enemies) do
			if self._unit:movement():team().foes[u_data.unit:movement():team().id] and not u_data.unit:anim_data().hands_tied and not u_data.unit:anim_data().long_dis_interact_disabled and (not u_data.unit:character_damage() or not u_data.unit:character_damage():dead()) and (u_data.char_tweak.priority_shout or not only_special_enemies) then
				if managers.groupai:state():whisper_mode() then
					if u_data.char_tweak.silent_priority_shout and u_data.unit:movement():cool() then
						self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_enemy, highlight_range, false, false, 0.01, my_head_pos, cam_fwd)
					elseif not u_data.unit:movement():cool() then
						self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_enemy, intimidate_range_ene, false, false, 100, my_head_pos, cam_fwd, nil, "ai_vision mover")
					end
				elseif u_data.char_tweak.priority_shout then
					self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_enemy, highlight_range, false, false, 0.01, my_head_pos, cam_fwd)
				else
					self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_enemy, intimidate_range_ene, false, false, 100, my_head_pos, cam_fwd, nil, "ai_vision mover")
				end
			end
		end
	end

	if intimidate_civilians then
		local civilians = managers.enemy:all_civilians()

		for u_key, u_data in pairs(civilians) do
			if alive(u_data.unit) and u_data.unit:in_slot(21) and not u_data.unit:movement():cool() and not u_data.unit:anim_data().long_dis_interact_disabled then
				local is_escort = u_data.char_tweak.is_escort

				if not is_escort or intimidate_escorts then
					local dist = is_escort and 300 or intimidate_range_civ
					local prio = is_escort and 100000 or 0.001

					self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_civilian, dist, false, false, prio, my_head_pos, cam_fwd)
				end
			end
		end
	end
	
	if intimidate_teammates and not managers.groupai:state():whisper_mode() then
		local criminals = managers.groupai:state():all_char_criminals()

		for u_key, u_data in pairs(criminals) do
			local added = nil

			if u_key ~= self._unit:key() then
				local rally_skill_data = self._ext_movement:rally_skill_data()

				if rally_skill_data and rally_skill_data.long_dis_revive and mvector3.distance_sq(self._pos, u_data.m_pos) < rally_skill_data.range_sq then
					local needs_revive = nil

					if u_data.unit:base().is_husk_player then
						needs_revive = u_data.unit:interaction():active() and u_data.unit:movement():need_revive() and u_data.unit:movement():current_state_name() ~= "arrested"
					else
						needs_revive = u_data.unit:character_damage():need_revive()
					end

					if needs_revive then
						added = true
						--Disable "interaction_through_walls" from the char_table check to stop inspire from working through walls.
						self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_teammate, intimidate_range_teammates, false, true, 5000, my_head_pos, cam_fwd)
					end
				end
			end

			if not added and not u_data.is_deployable and not u_data.unit:movement():downed() and not u_data.unit:base().is_local_player and not u_data.unit:anim_data().long_dis_interact_disabled then
				self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_teammate, intimidate_range_teammates, true, not secondary, 0.01, my_head_pos, cam_fwd)
			end
		end
	end

	if intimidate_enemies and intimidate_teammates then
		local enemies = managers.enemy:all_enemies()

		for u_key, u_data in pairs(enemies) do
			if u_data.unit:movement():team() and u_data.unit:movement():team().id == "criminal1" and not u_data.unit:movement():cool() and not u_data.unit:anim_data().long_dis_interact_disabled then
				local is_escort = u_data.char_tweak.is_escort

				if not is_escort or intimidate_escorts then
					local dist = is_escort and 300 or intimidate_range_civ
					local prio = is_escort and 100000 or 0.001

					self:_add_unit_to_char_table(char_table, u_data.unit, unit_type_civilian, dist, false, false, prio, my_head_pos, cam_fwd)
				end
			end
		end
	end

	if intimidate_enemies then
		if managers.groupai:state():whisper_mode() then
			for _, unit in ipairs(SecurityCamera.cameras) do
				if alive(unit) and unit:enabled() and not unit:base():destroyed() then
					local dist = 2000
					local prio = 0.001

					self:_add_unit_to_char_table(char_table, unit, unit_type_camera, dist, false, false, prio, my_head_pos, cam_fwd, {
						unit
					})
				end
			end
		end

		local turret_units = managers.groupai:state():turrets()

		if turret_units then
			for _, unit in pairs(turret_units) do
				if alive(unit) and unit:movement():team().foes[self._ext_movement:team().id] then
					self:_add_unit_to_char_table(char_table, unit, unit_type_turret, 2000, false, false, 0.01, my_head_pos, cam_fwd, {
						unit
					})
				end
			end
		end
	end

	local prime_target = self:_get_interaction_target(char_table, my_head_pos, cam_fwd)

	return self:_get_intimidation_action(prime_target, char_table, intimidation_amount, primary_only, detect_only, secondary)
end

--Replace coroutine with a playermanager function. The coroutine had issues with randomly not being called- or not having values get reset, and overall being jank???
function PlayerStandard:_find_pickups(t)
	local pickups = world_g:find_units_quick("sphere", self._unit:movement():m_pos(), self._pickup_area, self._slotmask_pickups)
	local grenade_tweak = tweak_data.blackmarket.projectiles[managers.blackmarket:equipped_grenade()]
	local may_find_grenade = not grenade_tweak.base_cooldown and managers.player:has_category_upgrade("player", "regain_throwable_from_ammo")
	local pickup_found = false

	for _, pickup in ipairs(pickups) do
		if pickup:pickup() and pickup:pickup():pickup(self._unit) then
			pickup_found = true
			if may_find_grenade then
				managers.player:regain_throwable_from_ammo() --Replace vanilla coroutine
			end

			for id, weapon in pairs(self._unit:inventory():available_selections()) do
				managers.hud:set_ammo_amount(id, weapon.unit:base():ammo_info())
			end
		end
	end

	if pickup_found then
		self:_attempt_offhand_reload()
	end
end

--Allowing underbarrels to update stance
function PlayerStandard:_check_action_deploy_underbarrel(t, input)
	local new_action = nil
	local action_forbidden = false

	if not input.btn_deploy_bipod and not self._toggle_underbarrel_wanted then
		return new_action
	end
	
	--Removed the ADS check so you can swap to the underbarrel while doing that
	action_forbidden = self:_is_throwing_projectile() or self:_is_meleeing() or self:is_equipping() or self:_changing_weapon() or self:shooting() or self:_is_reloading() or self:is_switching_stances() or self:_interacting() or self:running() and not self._equipped_unit:base():run_and_shoot_allowed()

	if self._running and not self._equipped_unit:base():run_and_shoot_allowed() and not self._end_running_expire_t then
		self:_interupt_action_running(t)

		self._toggle_underbarrel_wanted = true

		return
	end

	if not action_forbidden then
		self._toggle_underbarrel_wanted = false
		local weapon = self._equipped_unit:base()
		local underbarrel_names = managers.weapon_factory:get_parts_from_weapon_by_type_or_perk("underbarrel", weapon._factory_id, weapon._blueprint)

		if underbarrel_names and underbarrel_names[1] then
			local underbarrel = weapon._parts[underbarrel_names[1]]

			if underbarrel then
				local underbarrel_base = underbarrel.unit:base()
				local underbarrel_tweak = tweak_data.weapon[underbarrel_base.name_id]

				if weapon.record_fire_mode then
					weapon:record_fire_mode()
				end

				underbarrel_base:toggle()

				new_action = true

				if weapon.reset_cached_gadget then
					weapon:reset_cached_gadget()
				end

				if weapon._update_stats_values then
					weapon:_update_stats_values(true)
				end

				local anim_ids = nil
				local switch_delay = 1

				if underbarrel_base:is_on() then
					anim_ids = Idstring("underbarrel_enter_" .. weapon.name_id)
					switch_delay = underbarrel_tweak.timers.equip_underbarrel

					self:set_animation_state("underbarrel")
				else
					anim_ids = Idstring("underbarrel_exit_" .. weapon.name_id)
					switch_delay = underbarrel_tweak.timers.unequip_underbarrel

					self:set_animation_state("standard")
				end

				if anim_ids then
					self._ext_camera:play_redirect(anim_ids, 1)
				end

				self:set_animation_weapon_hold(nil)
				self:set_stance_switch_delay(switch_delay)
				--Updates the stance when we 'deploy' the underbarrel.
				self:_stance_entered()

				if alive(self._equipped_unit) then
					managers.hud:set_ammo_amount(self._equipped_unit:base():selection_index(), self._equipped_unit:base():ammo_info())
					managers.hud:set_teammate_weapon_firemode(HUDManager.PLAYER_PANEL, self._unit:inventory():equipped_selection(), self._equipped_unit:base():fire_mode())
				end

				managers.network:session():send_to_peers_synched("sync_underbarrel_switch", self._equipped_unit:base():selection_index(), underbarrel_base.name_id, underbarrel_base:is_on())
			end
		end
	end

	return new_action
end

--Interrupts the weapon reload at the soonest opportunity where it makes logical sense.
--Returns state of reload interrupt.
function PlayerStandard:_soft_interrupt_action_reload(t)
	local weap_base = self._equipped_unit:base()

	if self:_is_reloading() then
		if weap_base:reload_exit_expire_t(not weap_base:started_reload_empty()) then --Per shell reloads need to finish reloading the current shell.
			self._queue_reload_interupt = true
			return RELOAD_INTERRUPT_QUEUED
		else --Otherwise instant reload cancel.
			if self._state_data.reload_soft_interrupt_t and t <= self._state_data.reload_soft_interrupt_t then
				self:_interupt_action_reload()
				self._ext_camera:play_redirect(self:get_animation("idle"))
				return RELOAD_INTERRUPTED
			end

			return RELOADING
		end
	end

	return RELOAD_INTERRUPTED
end

function PlayerStandard:_interupt_action_reload(t)
	local weap_base = self._equipped_unit:base()
	if alive(self._equipped_unit) then
		weap_base:check_bullet_objects()
	end

	if self:_is_reloading() then
		weap_base:tweak_data_anim_stop("reload_enter")
		weap_base:tweak_data_anim_stop("reload")
		weap_base:tweak_data_anim_stop("reload_not_empty")
		weap_base:tweak_data_anim_stop("reload_exit")
	end

	self._queue_reload_start = false
	self._state_data.reload_enter_expire_t = nil
	self._state_data.reload_expire_t = nil
	self._state_data.reload_exit_expire_t = nil
	
	--Clear custom timers.
	self._state_data.refill_magazine_t = nil
	self._state_data.refill_half_magazine_t = nil
	self._state_data.reload_soft_interrupt_t = nil

	--Fixes weapons using shotgun-style reloads occasionally only loading one shell in
	self._queue_reload_interupt = nil

	managers.player:remove_property("shock_and_awe_reload_multiplier")
	self:send_reload_interupt()
end

function PlayerStandard:_check_action_primary_attack(t, input)
	local new_action = nil
	local action_wanted = input.btn_primary_attack_state or input.btn_primary_attack_release or self:is_shooting_count()

	if action_wanted then
		local action_forbidden = self:_is_reloading() or self:_changing_weapon() or self:_is_meleeing() or self._use_item_expire_t or self:_interacting() or self:_is_throwing_projectile() or self:_is_deploying_bipod() or self._menu_closed_fire_cooldown > 0 or self:is_switching_stances()

		if not action_forbidden then
			self._queue_reload_interupt = nil
			local start_shooting = false

			self._ext_inventory:equip_selected_primary(false)

			if self._equipped_unit then
				local weap_base = self._equipped_unit:base()
				local fire_mode = weap_base:fire_mode()
				local fire_on_release = weap_base:fire_on_release()

				if weap_base:out_of_ammo() then
					if input.btn_primary_attack_press then
						weap_base:dryfire()
					end
				elseif weap_base.clip_empty and weap_base:clip_empty() then
					if self:_is_using_bipod() then
						if input.btn_primary_attack_press then
							weap_base:dryfire()
						end

						self._equipped_unit:base():tweak_data_anim_stop("fire")
					elseif fire_mode == "single" then
						if input.btn_primary_attack_press then
							self:_start_action_reload_enter(t)
						end
					else
						new_action = true

						self:_start_action_reload_enter(t)
					end
				elseif self._running and not self._equipped_unit:base():run_and_shoot_allowed() then
					self:_interupt_action_running(t)
				else
					if not self._shooting then
						if weap_base:start_shooting_allowed() then
							local start = fire_mode ~= "auto" and input.btn_primary_attack_press
							start = start or fire_mode == "auto" and input.btn_primary_attack_state
							start = start and not fire_on_release
							start = start or fire_on_release and input.btn_primary_attack_release

							if start then
								weap_base:start_shooting()
								self._camera_unit:base():start_shooting()

								self._shooting = true
								self._shooting_t = t
								start_shooting = true

								if fire_mode == "auto" then
									self._unit:camera():play_redirect(self:get_animation("recoil_enter"))

									if (not weap_base.akimbo or weap_base:weapon_tweak_data().allow_akimbo_autofire) and (not weap_base.third_person_important or weap_base.third_person_important and not weap_base:third_person_important()) then
										self._ext_network:send("sync_start_auto_fire_sound", 0)
									end
								end
							end
						else
							self:_check_stop_shooting()

							return false
						end
					end
					
					local upgrade_name = weap_base:is_category("saw") and "melee_damage_health_ratio_multiplier" or "damage_health_ratio_multiplier"
					local dmg_mul = managers.player:upgrade_value("player", upgrade_name, 1)
					
					dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "berserker_damage_multiplier", 1)
					
					if self._can_trigger_happy_all_guns or weap_base:is_category("pistol") then
						dmg_mul = dmg_mul * managers.player:get_property("trigger_happy", 1)
					end

					dmg_mul = dmg_mul * (1 + managers.player:close_combat_upgrade_value("player", "close_combat_damage_boost", 0))

					local fired = nil
					if weap_base:burst_rounds_remaining() then
						fired = weap_base:trigger_pressed(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, 1, 1)
					elseif fire_mode == "auto" then
						fired = weap_base:trigger_held(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, 1, 1)
					else
						if input.btn_primary_attack_press and start_shooting then
							--TODO: Investigate removing spread/autohit muls, since they are no longer relevant.
							fired = weap_base:trigger_pressed(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, 1, 1)
						elseif fire_on_release then
							if input.btn_primary_attack_release then
								fired = weap_base:trigger_released(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, 1, 1)
							elseif input.btn_primary_attack_state then
								weap_base:trigger_held(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul, nil, 1, 1)
							end
						end
					end

					if weap_base.manages_steelsight and weap_base:manages_steelsight() then
						if weap_base:wants_steelsight() and not self._state_data.in_steelsight then
							self:_start_action_steelsight(t)
						elseif not weap_base:wants_steelsight() and self._state_data.in_steelsight then
							self:_end_action_steelsight(t)
						end
					end

					local charging_weapon = fire_on_release and weap_base:charging()

					if not self._state_data.charging_weapon and charging_weapon then
						self:_start_action_charging_weapon(t)
					elseif self._state_data.charging_weapon and not charging_weapon then
						self:_end_action_charging_weapon(t)
					end

					new_action = true

					if fired then
						self._shot = true --Used to signal that a crosshair jiggle should occur.

						managers.rumble:play("weapon_fire")
						--Apply stability to screen shake from firing.
						local weap_tweak_data = tweak_data.weapon[weap_base:get_name_id()]
						local shake_multiplier = weap_base:shake_multiplier(self._state_data.in_steelsight and "fire_steelsight_multiplier" or "fire_multiplier")
						self._equipped_unit:base():tweak_data_anim_stop("unequip")
						self._equipped_unit:base():tweak_data_anim_stop("equip")

						if not weap_base:has_spin() and not self._state_data.in_steelsight or not weap_base:tweak_data_anim_play("fire_steelsight", weap_base:fire_rate_multiplier()) then
							weap_base:tweak_data_anim_play("fire", weap_base:fire_rate_multiplier())
						end

						if (fire_mode == "single" or fire_mode == "burst") and weap_base:get_name_id() ~= "saw" and not weap_base.skip_fire_animation then
							if not self._state_data.in_steelsight then
								self._ext_camera:play_redirect(self:get_animation("recoil"), weap_base:fire_rate_multiplier())
							elseif weap_tweak_data.animations.recoil_steelsight then
								self._ext_camera:play_redirect(weap_base:is_second_sight_on() and self:get_animation("recoil") or self:get_animation("recoil_steelsight"), 1)
							end
						end

						if not fired.skip_recoil then
							local up, down, left, right = unpack(weap_tweak_data.kick[self._state_data.in_steelsight and "steelsight" or self._state_data.ducking and "crouching" or "standing"])
							local recoil_multiplier = (weap_base:recoil() + weap_base:recoil_addend()) * weap_base:recoil_multiplier()
							self._camera_unit:base():recoil_kick(up * recoil_multiplier, down * recoil_multiplier, left * recoil_multiplier, right * recoil_multiplier, true)
							self._ext_camera:play_shaker("fire_weapon_rot", shake_multiplier * recoil_multiplier * 0.5)
							self._ext_camera:play_shaker("fire_weapon_kick", shake_multiplier * recoil_multiplier * 0.75, 1, 0.15)
						end

						if self._shooting_t then
							local time_shooting = t - self._shooting_t
							local achievement_data = tweak_data.achievement.never_let_you_go

							if achievement_data and weap_base:get_name_id() == achievement_data.weapon_id and achievement_data.timer <= time_shooting then
								managers.achievment:award(achievement_data.award)

								self._shooting_t = nil
							end
						end
						
						if weap_base.set_recharge_clbk then
							weap_base:set_recharge_clbk(callback(self, self, "weapon_recharge_clbk_listener"))
						end

						managers.hud:set_ammo_amount(weap_base:selection_index(), weap_base:ammo_info())

						local impact = not fired.hit_enemy

						if weap_base.third_person_important and weap_base:third_person_important() then
							self._ext_network:send("shot_blank_reliable", impact, 0)
						elseif weap_base.akimbo and not weap_base:weapon_tweak_data().allow_akimbo_autofire or fire_mode == "single" or fire_mode == "burst" then
							self._ext_network:send("shot_blank", impact, 0)
						end
					elseif fire_mode == "single" or fire_mode == "burst" and not weap_base:burst_rounds_remaining() then
						new_action = false
					end
				end
			end
		elseif self:_is_reloading() and self._equipped_unit:base():reload_interuptable() and input.btn_primary_attack_press then
			self._queue_reload_interupt = true
		end
	end

	if not new_action then
		self:_check_stop_shooting()
	end

	return new_action
end

--Apply cosmetic sway effects to weapons based on their stats.
function PlayerStandard:_stance_entered(unequipped)
	local stance_standard = tweak_data.player.stances.default[managers.player:current_state()] or tweak_data.player.stances.default.standard
	local head_stance = self._state_data.ducking and tweak_data.player.stances.default.crouched.head or stance_standard.head
	local stance_id = nil
	local stance_mod = {
		translation = Vector3(0, 0, 0)
	}

	local weap_base = self._equipped_unit:base()
	local vel_overshot = nil
	local sway = nil
	if not unequipped then
		stance_id = weap_base:get_stance_id()

		if self._state_data.in_steelsight and weap_base.stance_mod then
			stance_mod = weap_base:stance_mod() or stance_mod
		end

		if not self:_is_meleeing() and not self:_is_throwing_projectile() then
			local move_state = self:get_movement_state()
			sway = weap_base:sway_mul(move_state)
			vel_overshot = weap_base:vel_overshot_mul(move_state, self._state_data.in_steelsight and "steelsight" or self._state_data.ducking and "crouching" or "standard")
		end
	end

	local stances = nil
	stances = (self:_is_meleeing() or self:_is_throwing_projectile()) and tweak_data.player.stances.default or tweak_data.player.stances[stance_id] or tweak_data.player.stances.default
	local misc_attribs = stances.standard
	misc_attribs = (not self:_is_using_bipod() or self:_is_throwing_projectile() or stances.bipod) and (self._state_data.in_steelsight and stances.steelsight or self._state_data.ducking and stances.crouched or stances.standard)
	sway = sway or misc_attribs.shakers
	vel_overshot = vel_overshot or misc_attribs.vel_overshot	

	local duration = tweak_data.player.TRANSITION_DURATION + (weap_base:transition_duration() or 0)
	local duration_multiplier = (self._state_data.in_steelsight or self._state_data.was_in_steelsight) and 1 / weap_base:enter_steelsight_speed_multiplier() or 1
	local new_fov = self:get_zoom_fov(misc_attribs) + 0

	self._camera_unit:base():clbk_stance_entered(misc_attribs.shoulders, head_stance, vel_overshot, new_fov, sway, stance_mod, duration_multiplier, duration)
	managers.menu:set_mouse_sensitivity(self:in_steelsight())
end

function PlayerStandard:_get_melee_charge_lerp_value(t, offset)
	offset = offset or 0
	local melee_entry = managers.blackmarket:equipped_melee_weapon()
	local max_charge_time = tweak_data.blackmarket.melee_weapons[melee_entry].stats.charge_time
	max_charge_time = max_charge_time / managers.player:upgrade_value("player", "melee_swing_multiplier_delay", 1)

	if not self._state_data.melee_start_t then
		return 0
	end

	local charge = math.clamp(t - self._state_data.melee_start_t - offset, 0, max_charge_time) / max_charge_time
	if charge > 0.99 then
		charge = 1
	end

	return charge
end

--Apply swap speed multiplier to more forms of equip/unequip animation.
function PlayerStandard:_start_action_equip(redirect, extra_time)
	local tweak_data = self._equipped_unit:base():weapon_tweak_data()
	local speed_multiplier = 1

	if redirect == self:get_animation("equip") then
		speed_multiplier = self:_get_swap_speed_multiplier()
		self._equipped_unit:base():tweak_data_anim_stop("unequip")
		self._equipped_unit:base():tweak_data_anim_play("equip", speed_multiplier)
	end

	self._equip_weapon_expire_t = (managers.player:player_timer():time() + (tweak_data.timers.equip or 0.7) / speed_multiplier + (extra_time or 0))
	self._ext_camera:play_redirect(redirect or self:get_animation("equip"), speed_multiplier)
end

function PlayerStandard:_play_equip_animation()
	local tweak_data = self._equipped_unit:base():weapon_tweak_data()
	local speed_multiplier = self:_get_swap_speed_multiplier()
	self._equip_weapon_expire_t = managers.player:player_timer():time() + (tweak_data.timers.equip or 0.7) / speed_multiplier
	self._ext_camera:play_redirect(self:get_animation("equip"), speed_multiplier)
	self._equipped_unit:base():tweak_data_anim_stop("unequip")
	self._equipped_unit:base():tweak_data_anim_play("equip", speed_multiplier)
end

function PlayerStandard:_play_unequip_animation()
	local speed_multiplier = self:_get_swap_speed_multiplier(true)
	self._ext_camera:play_redirect(self:get_animation("unequip"), speed_multiplier)
	self._equipped_unit:base():tweak_data_anim_stop("equip")
	self._equipped_unit:base():tweak_data_anim_play("unequip", speed_multiplier)
end

function PlayerStandard:_interupt_action_throw_projectile(t)
	if not self:_is_throwing_projectile() then
		return
	end

	self._state_data.projectile_idle_wanted = nil
	self._state_data.projectile_expire_t = nil
	self._state_data.projectile_throw_allowed_t = nil
	self._state_data.throwing_projectile = nil
	self._camera_unit_anim_data.throwing = nil

	self._camera_unit:base():unspawn_grenade()
	self._camera_unit:base():show_weapon()
	self:_play_equip_animation()
	self:_stance_entered()
end
