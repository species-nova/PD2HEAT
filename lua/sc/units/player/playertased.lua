function PlayerTased:enter(state_data, enter_data)
	PlayerTased.super.enter(self, state_data, enter_data)
	self._ids_tased_boost = Idstring("tased_boost")
	self._ids_tased = Idstring("tased")
	self._ids_counter_tase = Idstring("tazer_counter")
	self:_start_action_tased(managers.player:player_timer():time(), state_data.non_lethal_electrocution)
	if state_data.non_lethal_electrocution then
		state_data.non_lethal_electrocution = nil
		local recover_time = Application:time() + tweak_data.player.damage.STUN_TIME * managers.player:upgrade_value("player", "electrocution_resistance_multiplier", 1)
		self._recover_delayed_clbk = "PlayerTased_recover_delayed_clbk"
		
		managers.enemy:add_delayed_clbk(self._recover_delayed_clbk, callback(self, self, "clbk_exit_to_std"), recover_time)
	else
		self._fatal_delayed_clbk = "PlayerTased_fatal_delayed_clbk"
		local tased_time = tweak_data.player.damage.TASED_TIME
		--Taser Overcharge changed to allow for taser aim delays to be changed.
		managers.enemy:add_delayed_clbk(self._fatal_delayed_clbk, callback(self, self, "clbk_exit_to_fatal"), TimerManager:game():time() + tased_time)
	end

	self._next_shock = 0.5
	self._taser_value = 1
	self._num_shocks = 0

	managers.groupai:state():on_criminal_disabled(self._unit, "electrified")

	if Network:is_server() then
		self:_register_revive_SO()
	end

	--Removed free reload from being tased.

	local projectile_entry = managers.blackmarket:equipped_projectile()

	if tweak_data.blackmarket.projectiles[projectile_entry].is_a_grenade then
		self:_interupt_action_throw_grenade()
	else
		self:_interupt_action_throw_projectile()
	end

	self:_interupt_action_reload()
	self:_interupt_action_steelsight()
	self:_interupt_action_melee(managers.player:player_timer():time())
	self:_interupt_action_ladder(managers.player:player_timer():time())
	self:_interupt_action_charging_weapon(managers.player:player_timer():time())

	self._rumble_electrified = managers.rumble:play("electrified")
	self.tased = true
	self._state_data = state_data

	if managers.player:has_category_upgrade("player", "escape_taser") then
		local interact_string = managers.localization:text("hud_int_escape_taser", {
			BTN_INTERACT = managers.localization:btn_macro("interact", false)
		})

		managers.hud:show_interact({
			icon = "mugshot_electrified",
			text = interact_string
		})

		local target_time = managers.player:upgrade_value("player", "escape_taser", 2)
		managers.player:add_coroutine("escape_tase", PlayerAction.EscapeTase, managers.player, managers.hud, Application:time() + target_time)

		--Instead directly call give_shock_to_taser().

		managers.player:register_message(Message.EscapeTase, "escape_tase", self:give_shock_to_taser())
	end

	CopDamage.register_listener("on_criminal_tased", {	
		"on_criminal_tased"	
	}, callback(self, self, "_on_tased_event"))
end

--Prevent tasers from putting players at downed health, and instead deal flat health damage.
local orig_clbk_exit_to_fatal = PlayerTased.clbk_exit_to_fatal
function PlayerTased:clbk_exit_to_fatal()
	orig_clbk_exit_to_fatal(self)
	self._unit:character_damage():cloak_or_shock_incap(tweak_data.character.taser.shock_damage)
end

--Adds animation to shockproof ace.
function PlayerTased:call_teammate(line, t, no_gesture, skip_alert)
	local voice_type, plural, prime_target = self:_get_unit_intimidation_action(true, false, false, true, false)
	local interact_type, queue_name = nil
	if voice_type == "stop_cop" or voice_type == "mark_cop" then
		local prime_target_tweak = tweak_data.character[prime_target.unit:base()._tweak_table]
		local shout_sound = prime_target_tweak.priority_shout

		if managers.groupai:state():whisper_mode() then
			shout_sound = prime_target_tweak.silent_priority_shout or shout_sound
		end

		if shout_sound then
			interact_type = "cmd_point"
			queue_name = "s07x_sin"
			if managers.player:has_category_upgrade("player", "special_enemy_highlight") then
				prime_target.unit:contour():add(managers.player:get_contour_for_marked_enemy(), true, managers.player:upgrade_value("player", "mark_enemy_time_multiplier", 1))
			end
			
			--Play Shockproof Aced Animation
			if prime_target.unit:base()._tweak_table == "taser" then
				if not self._tase_ended and managers.player:has_category_upgrade("player", "escape_taser") and prime_target.unit:key() == self._unit:character_damage():tase_data().attacker_unit:key() then
					self:_start_action_counter_tase(t, prime_target)
				end
			end

		end
	end

	if interact_type then
		self:_do_action_intimidate(t, not no_gesture and interact_type or nil, queue_name, skip_alert)
	end
end	

function PlayerTased:give_shock_to_taser()
	if not alive(self._counter_taser_unit) then
		return
	end

	--Remove return, since we now damage Tasers with Shockproof Ace.
	self:_give_shock_to_taser(self._counter_taser_unit)
end
	
function PlayerTased:_give_shock_to_taser(taser_unit)
	--Remove return, since we now damage Tasers with Shockproof Ace.

	local action_data = {
		variant = "counter_tased",
		damage = taser_unit:character_damage()._HEALTH_INIT * (tweak_data.upgrades.counter_taser_damage or 0.2),
		damage_effect = taser_unit:character_damage()._HEALTH_INIT * 2,
		attacker_unit = self._unit,
		attack_dir = -taser_unit:movement()._action_common_data.fwd,
		col_ray = {
			position = mvector3.copy(taser_unit:movement():m_head_pos()),
			body = taser_unit:body("body")
		}
	}

	taser_unit:character_damage():damage_melee(action_data)
	self._unit:sound():play("tase_counter_attack") --Add sound
end

function PlayerTased:_update_check_actions(t, dt)
	local input = self:_get_input(t, dt)

	self:_check_action_shock(t, input)

	self._taser_value = math.step(self._taser_value, 0.8, dt / 4)

	managers.environment_controller:set_taser_value(self._taser_value)

	local shooting = self:_check_action_primary_attack(t, input)
	--Removed extra camera recoil on shot, since it harms auto-guns far more than semi-auto guns.

	if self._unequip_weapon_expire_t and self._unequip_weapon_expire_t <= t then
		self._unequip_weapon_expire_t = nil

		self:_start_action_equip_weapon(t)
	end

	if self._equip_weapon_expire_t and self._equip_weapon_expire_t <= t then
		self._equip_weapon_expire_t = nil
	end

	if input.btn_stats_screen_press then
		self._unit:base():set_stats_screen_visible(true)
	elseif input.btn_stats_screen_release then
		self._unit:base():set_stats_screen_visible(false)
	end

	self:_update_foley(t, input)

	local new_action = nil

	self:_check_action_interact(t, input)

	local new_action = nil
end

function PlayerTased:_check_action_shock(t, input)
	self._next_shock = self._next_shock or 0.15

	if self._next_shock < t then
		self._num_shocks = self._num_shocks or 0
		self._num_shocks = self._num_shocks + 1
		local shock_delay = 0.15 + (math.rand(1) * 0.55) --Make tase actions more frequent.
		self._next_shock = t + shock_delay

		self._unit:camera():play_shaker("player_taser_shock", 1, 10)
		self._unit:camera():camera_unit():base():set_target_tilt((math.random(2) == 1 and -1 or 1) * math.random(10))

		self._taser_value = self._taser_value or 1
		self._taser_value = math.max(self._taser_value - 0.25, 0)

		self._unit:sound():play("tasered_shock")
		managers.rumble:play("electric_shock")

		if not alive(self._counter_taser_unit) then
			if shock_delay > 0.15 then
				self._camera_unit:base():start_shooting()
				self._recoil_t = t + 0.25 --Reduce fire burst time, and only burst if we high roll the shock delay.
				input.btn_primary_attack_state = true
				input.btn_primary_attack_press = true
				--Removed some unused skills.

				self._camera_unit:base():recoil_kick(math.random(-8, 8), math.random(-8, 8))
				self._unit:camera():play_redirect(self:get_animation("tased_boost"))
			else
				self._camera_unit:base():recoil_kick(math.random(-4, 4), math.random(-4, 4))
				self._unit:camera():play_redirect(self:get_animation("tased_boost"))
			end
		end
	elseif self._recoil_t then
		input.btn_primary_attack_state = true
		if self._recoil_t < t then
			self._recoil_t = nil

			self._camera_unit:base():stop_shooting()
		end
	end
end

function PlayerTased:_check_action_primary_attack(t, input)
	local new_action = nil
	local action_wanted = input.btn_primary_attack_state
	action_wanted = action_wanted or self:is_shooting_count()

	if action_wanted then
		local action_forbidden = self:chk_action_forbidden("primary_attack")
		action_forbidden = action_forbidden or self:_is_reloading() or self:_changing_weapon() or self._melee_expire_t or self._use_item_expire_t or self:_interacting() or alive(self._counter_taser_unit)

		if not action_forbidden then
			self._queue_reload_interupt = nil
			local start_shooting = false

			self._ext_inventory:equip_selected_primary(false)

			if self._equipped_unit then
				local weap_base = self._equipped_unit:base()
				local fire_mode = weap_base:fire_mode()
				local fire_on_release = weap_base:fire_on_release()

				if weap_base.clip_empty and weap_base:clip_empty() or weap_base:out_of_ammo() then
					if input.btn_primary_attack_press then
						weap_base:dryfire()
					end
				elseif self._num_shocks > 1 and weap_base.can_refire_while_tased and not weap_base:can_refire_while_tased() then
					-- Nothing
				elseif self._running then
					self:_interupt_action_running(t)
				else
					if not self._shooting and weap_base:start_shooting_allowed() then
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

							if not weap_base:has_spin() then
								weap_base:tweak_data_anim_play("fire", weap_base:fire_rate_multiplier())
							end
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
						fired = weap_base:trigger_pressed(self:get_fire_weapon_position(), self._ext_camera:forward(), dmg_mul, false, 1, 1)
					elseif fire_mode == "auto" then
						fired = weap_base:trigger_held(self:get_fire_weapon_position(), self._ext_camera:forward(), dmg_mul, false, 1, 1)
					elseif input.btn_primary_attack_press then
						fired = weap_base:trigger_pressed(self._ext_camera:position(), self._ext_camera:forward(), dmg_mul, false, 1, 1)

						if weap_base:fire_on_release() then
							if weap_base.set_tased_shot then
								weap_base:set_tased_shot(true)
							end

							fired = weap_base:trigger_released(self._ext_camera:position(), self._ext_camera:forward(), dmg_mul, false, 1, 1)

							if weap_base.set_tased_shot then
								weap_base:set_tased_shot(false)
							end
						end
					end

					new_action = true

					if fired then
						self._shot = true --Used to signal that a crosshair jiggle should occur.

						managers.rumble:play("weapon_fire")
						local weap_tweak_data = tweak_data.weapon[weap_base:get_name_id()]
						self._equipped_unit:base():tweak_data_anim_stop("unequip")
						self._equipped_unit:base():tweak_data_anim_stop("equip")

						if not fired.skip_recoil then
							local v, h, shake = weap_base:get_recoil_kick(self, 1)
							self:apply_recoil(v, h, shake)
						end

						managers.hud:set_ammo_amount(weap_base:selection_index(), weap_base:ammo_info())

						if self._ext_network then
							local impact = not fired.hit_enemy
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

	if not new_action and self._shooting then
		self._equipped_unit:base():stop_shooting()
		self._camera_unit:base():stop_shooting()
	end

	return new_action
end