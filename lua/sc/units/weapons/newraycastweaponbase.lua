local old_update_stats_values = NewRaycastWeaponBase._update_stats_values	
function NewRaycastWeaponBase:_update_stats_values(disallow_replenish, ammo_data, ...)
	old_update_stats_values(self, disallow_replenish, ammo_data, ...)
	
	--Why the fuck is this not triggering on heist restarts????
	if not self._damage_near_mul then
		self:heat_init()
	end

	local weapon_tweak = self:weapon_tweak_data()
	if self._ammo_data then
		if self._ammo_data.rays ~= nil then
			self._rays = self._ammo_data.rays
		end
		if self._ammo_data.damage_near_mul ~= nil then
			self._damage_near_mul = self._damage_near_mul * self._ammo_data.damage_near_mul
		end
		if self._ammo_data.damage_far_mul ~= nil then
			self._damage_far_mul = self._damage_far_mul * self._ammo_data.damage_far_mul
		end

		if self._ammo_data.underbarrel_stats then
			--Add stuff to allow for stat modification for underbarrels using the custom stats table.
			--The normal stat table is used for the parent gun!
			local stats_tweak_data = tweak_data.weapon.stats
			local base_stats = weapon_tweak.stats
			local stats = deep_clone(base_stats)
			local parts_stats = self._ammo_data.underbarrel_stats
			local modifier_stats = weapon_tweak.stats_modifiers

			for stat, _ in pairs(stats) do
				if parts_stats[stat] then
					stats[stat] = stats[stat] + parts_stats[stat]
				end

				stats[stat] = math.clamp(stats[stat], 1, #stats_tweak_data[stat])
			end

			self._current_stats_indices = stats
			self._current_stats = {}

			for stat, i in pairs(stats) do
				self._current_stats[stat] = stats_tweak_data[stat] and stats_tweak_data[stat][i]

				if modifier_stats and modifier_stats[stat] then
					self._current_stats[stat] = self._current_stats[stat] * modifier_stats[stat]
				end
			end

			self._current_stats.alert_size = stats_tweak_data.alert_size[math.clamp(stats.alert_size, 1, #stats_tweak_data.alert_size)]

			if modifier_stats and modifier_stats.alert_size then
				self._current_stats.alert_size = self._current_stats.alert_size * modifier_stats.alert_size
			end

			if parts_stats and parts_stats.spread_multi then
				self._current_stats.spread_multi = parts_stats.spread_multi
			end

			self._alert_size = self._current_stats.alert_size or self._alert_size
			self._suppression = self._current_stats.suppression or self._suppression
			self._zoom = self._current_stats.zoom or self._zoom
			self._spread = self._current_stats.spread or self._spread
			self._recoil = self._current_stats.recoil or self._recoil
			self._spread_moving = self._current_stats.spread_moving or self._spread_moving
			self._extra_ammo = self._current_stats.extra_ammo or self._extra_ammo
			self._total_ammo_mod = self._current_stats.total_ammo_mod or self._total_ammo_mod
			self._damage = ((self._current_stats.damage or 0) + self:damage_addend()) * self:damage_multiplier()
		end
	end

	self._ads_speed_mult = self._ads_speed_mult or 1
	if not self:is_npc() then
		local weapon = {
			factory_id = self._factory_id,
			blueprint = self._blueprint,
			weapon_id = self._name_id
		}
		self._current_concealment = managers.blackmarket:calculate_weapon_concealment(weapon) + managers.blackmarket:get_silencer_concealment_modifiers(weapon)
		self._swap_speed_mul = (weapon_tweak.swap_speed_multiplier or 1) * tweak_data.weapon.stats.mobility[self._current_concealment]
	end

	local custom_stats = managers.weapon_factory:get_custom_stats_from_weapon(self._factory_id, self._blueprint)
	for part_id, stats in pairs(custom_stats) do
		if stats.reload_anim_override then
			if weapon_tweak.animations then
				weapon_tweak.animations.reload_name_id = stats.reload_anim_override 
			end
		end

		if stats.can_shoot_through_titan_shield then
			self._can_shoot_through_titan_shield = true
		end

		if stats.damage_near_mul then
			self._damage_near_mul = self._damage_near_mul * stats.damage_near_mul
		end

		if stats.damage_far_mul then
			self._damage_far_mul = self._damage_far_mul * stats.damage_far_mul
		end
		
		if self._swap_speed_mul and stats.swap_speed_mul then
			self._swap_speed_mul = self._swap_speed_mul * stats.swap_speed_mul
		end

		if stats.kick_addend and self._kick then
			--Avoid mutating global state. Multiple pointless clones should be a non issue since guns should only have 1 grip mod at most.
			self._kick = clone(self._kick)
			for i = 1, 4 do
				self._kick[i] = self._kick[i] + stats.kick_addend[i]
			end
		end
	end

	self:precalculate_ammo_pickup()
end

function NewRaycastWeaponBase:get_offhand_auto_reload_speed()
	return self._offhand_auto_reload_speed
end

function NewRaycastWeaponBase:clip_full()
	if self:ammo_base():weapon_tweak_data().tactical_reload then
		return self:ammo_base():get_ammo_remaining_in_clip() == self:ammo_base():get_ammo_max_per_clip() + 1
	else
		return self:ammo_base():get_ammo_remaining_in_clip() == self:ammo_base():get_ammo_max_per_clip()
	end
end

function NewRaycastWeaponBase:on_half_reload(...)
	--Placeholder. Implemented for Akimbo guns.
end

function NewRaycastWeaponBase:on_reload(...)
	--This function is now called earlier when the mag is inserted into the gun.
	--As a result, we delay object cleanup until on_reload_stop() is called.
	--Likewise, since the gun is "reloaded," we reset bloodthirst stuff now.
	self._bloodthist_value_during_reload = 0
	self._current_reload_speed_multiplier = nil

	if not self._setup.expend_ammo then
		NewRaycastWeaponBase.super.on_reload(self, ...)
		return
	end

	local ammo_base = self._reload_ammo_base or self:ammo_base()
	local ammo_in_clip = ammo_base:get_ammo_remaining_in_clip()
	if ammo_in_clip > 0 and ammo_base:weapon_tweak_data().tactical_reload then
		ammo_base:set_ammo_remaining_in_clip(math.min(ammo_base:get_ammo_total(), ammo_base:get_ammo_max_per_clip() + 1))
	else
		ammo_base:set_ammo_remaining_in_clip(math.min(ammo_base:get_ammo_total(), ammo_base:get_ammo_max_per_clip()))
	end

	managers.job:set_memory("kill_count_no_reload_" .. tostring(self._name_id), nil, true)

	self._reload_ammo_base = nil
end

function NewRaycastWeaponBase:max_bullets_to_reload(from_empty)
	local max_per_mag = self:get_ammo_max_per_clip()
	if not from_empty and self:weapon_tweak_data().tactical_reload then
		max_per_mag = max_per_mag + 1
	end
	return math.min(self:get_ammo_total(), max_per_mag) - self:get_ammo_remaining_in_clip()
end

function NewRaycastWeaponBase:bullets_per_load(is_empty)
	local shotgun_reload_tweak = self:_get_shotgun_reload_tweak_data(not is_empty)
	if shotgun_reload_tweak and shotgun_reload_tweak.reload_queue then
		return 2 --Just do 2 for right now. If more queued-reloads get introduced, consider proper handling for offhand reloads.
	else
		return shotgun_reload_tweak and shotgun_reload_tweak.reload_num or 1
	end
end

function NewRaycastWeaponBase:reload_expire_t(is_not_empty)
	if self._use_shotgun_reload then
		local shotgun_reload_tweak = self:_get_shotgun_reload_tweak_data(is_not_empty)
		if shotgun_reload_tweak and shotgun_reload_tweak.reload_queue then
			local ammo_total = self:get_ammo_total()
			local ammo_max_per_clip = self:get_ammo_max_per_clip() + (not self._started_reload_empty and self:weapon_tweak_data().tactical_reload and 1 or 0)
			local ammo_remaining_in_clip = self:get_ammo_remaining_in_clip()
			local ammo_to_reload = math.min(ammo_total - ammo_remaining_in_clip, ammo_max_per_clip - ammo_remaining_in_clip)
			local reload_expire_t = 0
			local queue_index = 0
			local queue_data = nil
			local queue_num = #shotgun_reload_tweak.reload_queue

			while ammo_to_reload > 0 do
				if queue_index == queue_num then
					reload_expire_t = reload_expire_t + (shotgun_reload_tweak.reload_queue_wrap or 0)
				end

				queue_index = queue_index % queue_num + 1
				queue_data = shotgun_reload_tweak.reload_queue[queue_index]
				reload_expire_t = reload_expire_t + queue_data.expire_t or 0.5666666666666667
				ammo_to_reload = ammo_to_reload - (queue_data.reload_num or 1)
			end

			return reload_expire_t
		else
			local reload_count = math.ceil(self:max_bullets_to_reload(not is_not_empty or self._started_reload_empty) / (shotgun_reload_tweak and shotgun_reload_tweak.reload_num or 1))
			return reload_count * self:reload_shell_expire_t(is_not_empty)
		end
	end
end

function NewRaycastWeaponBase:update_reloading(t, dt, time_left)
	if self._use_shotgun_reload and self._next_shell_reloded_t and t > self._next_shell_reloded_t then
		local speed_multiplier = self:reload_speed_multiplier()
		local shotgun_reload_tweak = self:_get_shotgun_reload_tweak_data(not self._started_reload_empty)
		local ammo_to_reload = 1
		local next_queue_data = nil

		if shotgun_reload_tweak and shotgun_reload_tweak.reload_queue then
			self._shotgun_queue_index = self._shotgun_queue_index % #shotgun_reload_tweak.reload_queue + 1

			if self._shotgun_queue_index == #shotgun_reload_tweak.reload_queue then
				self._next_shell_reloded_t = self._next_shell_reloded_t + (shotgun_reload_tweak.reload_queue_wrap or 0)
			end

			local queue_data = shotgun_reload_tweak.reload_queue[self._shotgun_queue_index]
			ammo_to_reload = queue_data and queue_data.reload_num or 1
			next_queue_data = shotgun_reload_tweak.reload_queue[self._shotgun_queue_index + 1]
			self._next_shell_reloded_t = self._next_shell_reloded_t + (next_queue_data and next_queue_data.expire_t or 0.5666666666666667) / speed_multiplier
		else
			self._next_shell_reloded_t = self._next_shell_reloded_t + self:reload_shell_expire_t(not self._started_reload_empty) / speed_multiplier
			ammo_to_reload = shotgun_reload_tweak and shotgun_reload_tweak.reload_num or 1
		end

		if not self._started_reload_empty and self:weapon_tweak_data().tactical_reload then
			self:set_ammo_remaining_in_clip(math.min(self:get_ammo_max_per_clip() + 1, self:get_ammo_remaining_in_clip() + ammo_to_reload))
		else
			self:set_ammo_remaining_in_clip(math.min(self:get_ammo_max_per_clip(), self:get_ammo_remaining_in_clip() + ammo_to_reload))
		end

		managers.job:set_memory("kill_count_no_reload_" .. tostring(self._name_id), nil, true)

		if not next_queue_data or not next_queue_data.skip_update_ammo then
			self:update_ammo_objects()
		end

		return true
	end
end

--Ensure that RaycastWeaponBase functions are used to avoid duplicate code.
NewRaycastWeaponBase.conditional_accuracy_multiplier = RaycastWeaponBase.conditional_accuracy_multiplier  
NewRaycastWeaponBase.moving_spread_penalty_reduction = RaycastWeaponBase.moving_spread_penalty_reduction
NewRaycastWeaponBase.update_spread = RaycastWeaponBase.update_spread
NewRaycastWeaponBase._get_spread = RaycastWeaponBase._get_spread
NewRaycastWeaponBase.get_damage_falloff = RaycastWeaponBase.get_damage_falloff
NewRaycastWeaponBase.reload_speed_multiplier = RaycastWeaponBase.reload_speed_multiplier
NewRaycastWeaponBase.weapon_range = RaycastWeaponBase.weapon_range
NewRaycastWeaponBase.recoil_multiplier = RaycastWeaponBase.recoil_multiplier
NewRaycastWeaponBase._fire_raycast = RaycastWeaponBase._fire_raycast

local on_enabled_original = NewRaycastWeaponBase.on_enabled
function NewRaycastWeaponBase:on_enabled(...)
	self:cancel_burst()
	return on_enabled_original(self, ...)
end

local on_disabled_original = NewRaycastWeaponBase.on_disabled
function NewRaycastWeaponBase:on_disabled(...)
	self:cancel_burst()
	return on_disabled_original(self, ...)
end

--Returns the weapon's current concealment stat.
function RaycastWeaponBase:get_concealment()
	local result = self._current_concealment or self._concealment
	if result then
		return math.max(result, 1)
	else
		return 20
	end
	
end

function NewRaycastWeaponBase:precalculate_ammo_pickup()
	--Precalculate ammo pickup values.
	if self:weapon_tweak_data().AMMO_PICKUP then
		self._ammo_pickup = {self:weapon_tweak_data().AMMO_PICKUP[1], self:weapon_tweak_data().AMMO_PICKUP[2]} --Get base gun ammo pickup.

		--Pickup multiplier from skills.
		local pickup_multiplier = managers.player:upgrade_value("player", "fully_loaded_pick_up_multiplier", 1)

		--Apply multiplier from skills and ammo.
		self._ammo_pickup[1] = self._ammo_pickup[1] * pickup_multiplier * ((self._ammo_data and self._ammo_data.ammo_pickup_min_mul) or 1)
		self._ammo_pickup[2] = self._ammo_pickup[2] * pickup_multiplier * ((self._ammo_data and self._ammo_data.ammo_pickup_max_mul) or 1)
	end
end

function NewRaycastWeaponBase:fire_rate_multiplier()
	local mul = 1
	local player_manager = managers.player

	if managers.player:has_activate_temporary_upgrade("temporary", "headshot_fire_rate_mult") then
		mul = mul + player_manager:temporary_upgrade_value("temporary", "headshot_fire_rate_mult", 1) - 1
	end 
	
	mul = mul + player_manager:temporary_upgrade_value("temporary", "bullet_hell", {fire_rate_multiplier = 1.0}).fire_rate_multiplier - 1

	--Adds hipfire bonus over the normal one.
	local user_unit = self._setup and self._setup.user_unit
	local current_state = alive(user_unit) and user_unit:movement() and user_unit:movement()._current_state
	if current_state and not current_state:in_steelsight() then
		mul = mul + player_manager:upgrade_value("shotgun", "hip_rate_of_fire", 1) - 1
	end

	mul = mul * (self:weapon_tweak_data().fire_rate_multiplier or 1)
	
	if self:burst_rounds_remaining() then
		mul = mul * (self._burst_fire_rate_multiplier or 1)
	end	

	return mul * (self._fire_rate_multiplier or 1)
end

local ids_single = Idstring("single")
local ids_auto = Idstring("auto")
local ids_burst = Idstring("burst")
local ids_volley = Idstring("volley")

function NewRaycastWeaponBase:start_shooting()
	if self._fire_mode == ids_volley then
		self:_start_charging()
		self._shooting = true
		return
	end

	return NewRaycastWeaponBase.super.start_shooting(self)
end

function NewRaycastWeaponBase:stop_shooting()
	NewRaycastWeaponBase.super.stop_shooting(self)
	if self._fire_mode == ids_volley then
		self:stop_volley_charge()
	end
end

function NewRaycastWeaponBase:trigger_held(...)
	if self._fire_mode == ids_volley then
		local volley_charge_time = self:charge_max_t()
		local fired = false

		if self._volley_charge_start_t + volley_charge_time <= managers.player:player_timer():time() then
			fired = self:fire(...)

			if fired then
				self:call_on_digital_gui("stop_volley_charge")

				--Allow fire rate buffs to affect the volley mode.
				self._next_fire_allowed = self._unit:timer():time() + (self:charge_cooldown_t() / self:fire_rate_multiplier())

				self:_fire_sound()

				self._volley_charging = nil
			end
		end

		return fired
	end

	return NewRaycastWeaponBase.super.trigger_held(self, ...)
end

function NewRaycastWeaponBase:fire(...)
	local result = NewRaycastWeaponBase.super.fire(self, ...)
	
	if result and self:fire_mode() == "burst" then
		self:_update_burst_fire() --Use single update_burst_fire function to handle burst fired guns.
	end
	
	return result
end	

--Single update function for all burst fire counter updates. Call this whenever a given gun fires.
function NewRaycastWeaponBase:_update_burst_fire()
	if self:clip_empty() then
		self:cancel_burst()
	elseif self:fire_mode() == "burst" then
		--Vanilla uses a down moving counter, but here an upwards moving counter is used. With a nil value == no burst
		self._burst_rounds_fired = (self._burst_rounds_fired or 0) + 1
		if self._burst_rounds_fired >= self._burst_count then
			self:cancel_burst()
		end
	end
end

--Stops the current burst. Applies recoil to the player if the burst should have delayed recoil.
function NewRaycastWeaponBase:cancel_burst()	
	if self._delayed_burst_recoil and self._burst_rounds_fired and self._burst_rounds_fired > 0 then
		local current_state = self._setup.user_unit:movement():current_state()
		local v, h, shake = self:get_recoil_kick(current_state, self._burst_rounds_fired)
		current_state:apply_recoil(v, h, shake)
	end
	self._burst_rounds_fired = nil
end

--Returns whether or not the gun is firing a burst.
function NewRaycastWeaponBase:burst_rounds_remaining()
	return self._burst_rounds_fired and self._burst_rounds_fired < self._burst_count
end

--Provides vanilla compatibility for external classes interfacing with burst fire, just in case.
function NewRaycastWeaponBase:shooting_count()
	return self._burst_rounds_fired and self._burst_rounds_fired - self._burst_count or 0
end

function NewRaycastWeaponBase:can_toggle_firemode()
	if self:gadget_overrides_weapon_functions() then
		return self:gadget_function_override("can_toggle_firemode")
	end

	return self._toggable_fire_modes and #self._toggable_fire_modes > 1
end

function NewRaycastWeaponBase:toggle_firemode(skip_post_event)
	if self._locked_fire_mode or not self:can_toggle_firemode() then
		return false
	end
	
	if not self._fire_mode_index then
		for i = 1, #self._toggable_fire_modes do
			if self._toggable_fire_modes[i] == self._fire_mode then
				self._fire_mode_index = i
				break
			end
		end
	end

	if self._fire_mode_index == #self._toggable_fire_modes then
		self._fire_mode_index = 1
	else
		self._fire_mode_index = self._fire_mode_index + 1		
	end
	local prev_fire_mode = self._fire_mode
	self._fire_mode = self._toggable_fire_modes[self._fire_mode_index]

	if not skip_post_event then
		if prev_fire_mode == ids_single or prev_fire_mode == ids_volley then
			self._sound_fire:post_event("wp_auto_switch_on")
		else
			self._sound_fire:post_event("wp_auto_switch_off")
		end
	end

	local fire_effect = fire_mode_data and (self._silencer and fire_mode_data.muzzleflash_silenced or fire_mode_data.muzzleflash)
	self:change_fire_effect(fire_effect)

	local trail_effect = fire_mode_data and fire_mode_data.trail_effect
	self:change_trail_effect(trail_effect)

	self:call_on_digital_gui("set_firemode", self:fire_mode())
	self:update_firemode_gui_ammo()

	return true
end

--Returns the number of additional rays fired by the gun, beyond the normal amount.
function RaycastWeaponBase:_get_bonus_rays()
	local result = self._first_shot_active and self._first_shot_bonus_rays or 0
	self._first_shot_active = false
	
	if self._fire_mode == ids_volley then
		result = result + self._volley_rays
	end

	return result
end

function NewRaycastWeaponBase:enter_steelsight_speed_multiplier()
	--Make mobility affect this.
	local base_multiplier = tweak_data.weapon.stats.mobility[self._current_concealment]
	local multiplier = 1
	local categories = self:weapon_tweak_data().categories

	--Removed blatantly unused upgrades.
	for i = 1, #categories do
		multiplier = multiplier + managers.player:upgrade_value(category, "enter_steelsight_speed_multiplier", 1) - 1
	end

	multiplier = multiplier + managers.player:upgrade_value("weapon", "enter_steelsight_speed_multiplier", 1) - 1

	return multiplier * base_multiplier
end

function NewRaycastWeaponBase:calculate_ammo_max_per_clip()
	local ammo = tweak_data.weapon[self._name_id].CLIP_AMMO_MAX + (self._extra_ammo or 0)
	if not self:upgrade_blocked("weapon", "clip_ammo_increase") then
		ammo = ammo * managers.player:upgrade_value("weapon", "clip_ammo_increase", 1)
	end
	ammo = math.round(ammo)
	return ammo
end

local orig_on_equip = NewRaycastWeaponBase.on_equip
function NewRaycastWeaponBase:on_equip(...)
	orig_on_equip(self, ...)
	
	self._equipped = true
	self._first_shot_active = true
end

local orig_on_unequip = NewRaycastWeaponBase.on_unequip
function NewRaycastWeaponBase:on_unequip(...)
	orig_on_unequip(self, ...)

	self._equipped = false
	managers.player:deactivate_temporary_upgrade("temporary", "bullet_hell")
	managers.hud:remove_skill("bullet_hell")
end

function NewRaycastWeaponBase:sway_mul(move_state)
	self.shakers.breathing.amplitude = tweak_data.weapon.stat_info.breathing_amplitude[math.min(self:weapon_tweak_data().stats.spread + self:get_accuracy_addend(), 21)]
		* tweak_data.weapon.stat_info.breathing_amplitude_stance_muls[move_state]
	return self.shakers
end

function NewRaycastWeaponBase:vel_overshot_mul(move_state, alt_state)
	local vel_overshot = tweak_data.weapon.stat_info.vel_overshot[self._current_concealment] * tweak_data.weapon.stat_info.vel_overshot_stance_muls[move_state]
	self.vel_overshot.yaw_neg = -vel_overshot
	self.vel_overshot.yaw_pos = vel_overshot
	self.vel_overshot.pitch_neg = vel_overshot
	self.vel_overshot.pitch_pos = -vel_overshot
	self.vel_overshot.pivot = (tweak_data.player.stances.default[self:get_stance_id()] or tweak_data.player.stances.default.standard).vel_overshot.pivot
	return self.vel_overshot
end

function NewRaycastWeaponBase:shake_multiplier(multiplier_type)
	return self:weapon_tweak_data().shake[multiplier_type] * (self.AKIMBO and 0.5 or 1) 
end

function NewRaycastWeaponBase:get_base_swap_speed_mul()
	return self._swap_speed_mul
end