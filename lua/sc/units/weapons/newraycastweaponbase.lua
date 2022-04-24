--Adds ability to define per weapon category AP skills.
local old_init = NewRaycastWeaponBase.init
function NewRaycastWeaponBase:init(...)
	old_init(self, ...)

	--Since armor piercing chance is no longer used, lets use weapon category to determine armor piercing baseline.
	--TODO: Move to autogen stuff in WeaponTweakData.
	if self:is_category("bow", "crossbow", "saw", "snp") then
		self._use_armor_piercing = true
	end

	local weapon_tweak = self:weapon_tweak_data()
	if weapon_tweak.armor_piercing_chance and weapon_tweak.armor_piercing_chance > 0 then
		self._use_armor_piercing = true
	end

	--Shots required for Bullet Hell
	if managers.player:has_category_upgrade("temporary", "bullet_hell") then
		local bullet_hell_stats = managers.player:upgrade_value("temporary", "bullet_hell")[1]
		self._shots_before_bullet_hell = (not bullet_hell_stats.smg_only or self:is_category("smg")) and bullet_hell_stats.shots_required  
	end

	--Pre-allocate some tables so we don't waste time making new ones on every state change, or touching global state in potentially weird ways.
	--Actual data is set in the sway and vel_overshot functions.
	self.shakers = {breathing = {amplitude = 0}}
	self.vel_overshot = {
		pivot = nil, --Use the pivot from PlayerTweakData in getter.
		yaw_neg = 0,
		yaw_pos = 0,
		pitch_neg = 0,
		pitch_pos = 0
	}

	if managers.player:has_category_upgrade("pistol", "desperado_all_guns") then
		self._can_desperado = true
	end

	for _, category in ipairs(self:categories()) do
		if managers.player:has_category_upgrade(category, "ap_bullets") then
			self._use_armor_piercing = true
		end

		if managers.player:has_category_upgrade(category, "ricochet_bullets") then
			self._ricochet_data = {
				cop_kill_count = 0,
				hit_enemy = false
			}
		end
	
		self._headshot_pierce_damage_mult = math.max(self._headshot_pierce_damage_mult, managers.player:upgrade_value(category, "headshot_pierce_damage_mult", 0))

		if managers.player:has_category_upgrade(category, "headshot_pierce") then
			self._can_shoot_through_head = true
		end

		--Tracker for Mag Dumper Ace
		if managers.player:has_category_upgrade(category, "full_auto_free_ammo") then
			self._bullets_until_free = managers.player:upgrade_value(category, "full_auto_free_ammo")
			break
		end

		if managers.player:has_category_upgrade(category, "first_shot_bonus_rays") then
			self._first_shot_bonus_rays = (self._first_shot_bonus_rays or 0) + managers.player:upgrade_value(category, "first_shot_bonus_rays", 0)
			self._first_shot_active = true
		end

		if category == "pistol" then
			self._can_desperado = true
		end

		if managers.player:has_category_upgrade(category, "offhand_auto_reload") then
			self._offhand_auto_reload_speed = (self._offhand_auto_reload_speed or 0) + managers.player:upgrade_value(category, "offhand_auto_reload")
		end

		self.headshot_repeat_damage_mult = managers.player:upgrade_value(category, "headshot_repeat_damage_mult", 1)
	end

	if managers.player:has_category_upgrade("weapon", "ricochet_bullets") then
		self._ricochet_data = self._ricochet_data or {
			cop_kill_count = 0,
			hit_enemy = false
		}
	end
end

function NewRaycastWeaponBase:get_offhand_auto_reload_speed()
	return self._offhand_auto_reload_speed
end

function NewRaycastWeaponBase:can_ricochet()
	return self._ricochet_data ~= nil
end

--Returns the number of additional rays fired by the gun, beyond the normal amount defined in the tweakdata.
function RaycastWeaponBase:_get_bonus_rays()
	local result = self._first_shot_active and self._first_shot_bonus_rays or 0
	self._first_shot_active = false
	return result
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

		managers.player:consume_shell_rack_stacks(self)
		managers.job:set_memory("kill_count_no_reload_" .. tostring(self._name_id), nil, true)

		if not next_queue_data or not next_queue_data.skip_update_ammo then
			self:update_ammo_objects()
		end

		return true
	end
end

NewRaycastWeaponBase.DEFAULT_BURST_SIZE = 3
NewRaycastWeaponBase.IDSTRING_SINGLE = Idstring("single")
NewRaycastWeaponBase.IDSTRING_AUTO = Idstring("auto")

--Ensure that RaycastWeaponBase functions are used to avoid duplicate code.
NewRaycastWeaponBase.conditional_accuracy_multiplier = RaycastWeaponBase.conditional_accuracy_multiplier  
NewRaycastWeaponBase.moving_spread_penalty_reduction = RaycastWeaponBase.moving_spread_penalty_reduction
NewRaycastWeaponBase.update_spread = RaycastWeaponBase.update_spread
NewRaycastWeaponBase._get_spread = RaycastWeaponBase._get_spread

function NewRaycastWeaponBase:recoil_multiplier(...)
	local rounds = 1
	if self._delayed_burst_recoil and self:in_burst_mode() then
		if self:burst_rounds_remaining() then
			return 0
		else
			rounds = self._burst_size
		end
	end

	local user_unit = self._setup and self._setup.user_unit
	local current_state = user_unit:movement()._current_state
	local mul = 1
	local player_manager = managers.player

	if not self._in_steelsight then
		for _, category in ipairs(self:categories()) do
			mul = mul + player_manager:upgrade_value(category, "hip_fire_recoil_multiplier", 1) - 1
		end
	end

	mul = mul + player_manager:temporary_upgrade_value("temporary", "bullet_hell", {recoil_multiplier = 1.0}).recoil_multiplier - 1

	return rounds * self:_convert_add_to_mul(mul)
end

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

--Resolves a vanilla issue that can let you cheat timed buffs from one reload->next on shotgun reloads.
--Since all reloads use this cache to avoid 1000 skill checks, it's pretty important to make sure it's invalidated.
--Any time the player starts a new reload.
function NewRaycastWeaponBase:invalidate_current_reload_speed_multiplier()
	self._current_reload_speed_multiplier = nil
end

local start_reload_original = NewRaycastWeaponBase.start_reload
function NewRaycastWeaponBase:start_reload(...)
	self:cancel_burst()
	return start_reload_original(self, ...)
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

--Le stats face
local old_update_stats_values = NewRaycastWeaponBase._update_stats_values	
function NewRaycastWeaponBase:_update_stats_values(disallow_replenish)
	old_update_stats_values(self, disallow_replenish)
	
	self._reload_speed_mult = self:weapon_tweak_data().reload_speed_multiplier or 1
	self._ads_speed_mult = self._ads_speed_mult or 1
	
	self._deploy_anim_override = self:weapon_tweak_data().deploy_anim_override or nil
	self._deploy_ads_stance_mod = self:weapon_tweak_data().deploy_ads_stance_mod or {translation = Vector3(0, 0, 0), rotation = Rotation(0, 0, 0)}		
		
	if not self:is_npc() then
		local weapon = {
			factory_id = self._factory_id,
			blueprint = self._blueprint
		}
		self._current_concealment = managers.blackmarket:calculate_weapon_concealment(weapon) + managers.blackmarket:get_silencer_concealment_modifiers(weapon)

		self._can_shoot_through_titan_shield = self:weapon_tweak_data().can_shoot_through_titan_shield
	
		self._burst_rounds_fired = nil
		self._has_auto = not self._locked_fire_mode and (self:can_toggle_firemode() or self:weapon_tweak_data().FIRE_MODE == "auto")
		
		self._has_burst_fire = (self:can_toggle_firemode() or self:weapon_tweak_data().BURST_FIRE) and self:weapon_tweak_data().BURST_FIRE ~= false
		
		--self._has_burst_fire = (not self._locked_fire_mode or managers.weapon_factor:has_perk("fire_mode_burst", self._factory_id, self._blueprint) or (self:can_toggle_firemode() or self:weapon_tweak_data().BURST_FIRE) and self:weapon_tweak_data().BURST_FIRE ~= false
		--self._locked_fire_mode = self._locked_fire_mode or managers.weapon_factor:has_perk("fire_mode_burst", self._factory_id, self._blueprint) and Idstring("burst")
		self._burst_size = self:weapon_tweak_data().BURST_FIRE or NewRaycastWeaponBase.DEFAULT_BURST_SIZE
		self._adaptive_burst_size = self:weapon_tweak_data().ADAPTIVE_BURST_SIZE ~= false
		self._burst_fire_rate_multiplier = self:weapon_tweak_data().BURST_FIRE_RATE_MULTIPLIER or 1
		self._delayed_burst_recoil = self:weapon_tweak_data().DELAYED_BURST_RECOIL

		if self:weapon_tweak_data().FIRE_MODE == "burst" then
			self:_set_burst_mode(true, true)
		end
	end		
	
	--Set range multipliers.
	self._damage_near_mul = tweak_data.weapon.stat_info.damage_falloff.near_mul
	self._damage_far_mul = tweak_data.weapon.stat_info.damage_falloff.far_mul

	if self._ammo_data then
		if self._ammo_data.damage_near_mul ~= nil then
			self._damage_near_mul = self._damage_near_mul * self._ammo_data.damage_near_mul
		end
		if self._ammo_data.damage_far_mul ~= nil then
			self._damage_far_mul = self._damage_far_mul * self._ammo_data.damage_far_mul
		end
	end

	local custom_stats = managers.weapon_factory:get_custom_stats_from_weapon(self._factory_id, self._blueprint)
	for part_id, stats in pairs(custom_stats) do
		if stats.disable_steelsight_stance then
			if self:weapon_tweak_data().animations then
				self:weapon_tweak_data().animations.has_steelsight_stance = false
			end
		end

		if stats.is_drum_aa12 then
			if self:weapon_tweak_data().animations then
				self:weapon_tweak_data().animations.reload_name_id = "aa12"
			end
		end

		if stats.is_mag_akm then
			if self:weapon_tweak_data().animations then
				self:weapon_tweak_data().animations.reload_name_id = "akm"
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
	end

	self._flame_max_range = self._damage_far_mul

	self:precalculate_ammo_pickup()
end

function NewRaycastWeaponBase:precalculate_ammo_pickup()
	--Precalculate ammo pickup values.
	if self:weapon_tweak_data().AMMO_PICKUP then
		self._ammo_pickup = {self:weapon_tweak_data().AMMO_PICKUP[1], self:weapon_tweak_data().AMMO_PICKUP[2]} --Get base gun ammo pickup.

		--Pickup multiplier from skills.
		local pickup_multiplier = managers.player:upgrade_value("player", "fully_loaded_pick_up_multiplier", 1)

		for _, category in ipairs(self:categories()) do
			pickup_multiplier = pickup_multiplier + managers.player:upgrade_value(category, "pick_up_multiplier", 1) - 1
		end

		--Apply multiplier from skills and ammo.
		self._ammo_pickup[1] = self._ammo_pickup[1] * pickup_multiplier * ((self._ammo_data and self._ammo_data.ammo_pickup_min_mul) or 1)
		self._ammo_pickup[2] = self._ammo_pickup[2] * pickup_multiplier * ((self._ammo_data and self._ammo_data.ammo_pickup_max_mul) or 1)
	end
end

function NewRaycastWeaponBase:fire_rate_multiplier()
	local mul = 1
	local player_manager = managers.player

	if player_manager:has_activate_temporary_upgrade("temporary", "headshot_fire_rate_mult") then
		mul = mul + player_manager:temporary_upgrade_value("temporary", "headshot_fire_rate_mult", 1) - 1
	end 

	mul = mul + player_manager:temporary_upgrade_value("temporary", "bullet_hell", {fire_rate_multiplier = 1.0}).fire_rate_multiplier - 1

	mul = mul * (self:weapon_tweak_data().fire_rate_multiplier or 1)
	
	if self:burst_rounds_remaining() then
		mul = mul * (self._burst_fire_rate_multiplier or 1)
	end

	return mul * (self._fire_rate_multiplier or 1)
end

local fire_original = NewRaycastWeaponBase.fire
function NewRaycastWeaponBase:fire(...)
	local result = fire_original(self, ...)
	
	if result and self:in_burst_mode() then
		self:_update_burst_fire()
	end
	
	return result
end	

function NewRaycastWeaponBase:_update_burst_fire()
	if self:clip_empty() then
		self:cancel_burst()
	elseif self:in_burst_mode() then
		self._burst_rounds_fired = (self._burst_rounds_fired or 0) + 1
		if self._burst_rounds_fired >= self._burst_size then
			self:cancel_burst()
		end
	end
end

local toggle_firemode_original = NewRaycastWeaponBase.toggle_firemode
function NewRaycastWeaponBase:toggle_firemode(...)
	return self._has_burst_fire and not self._locked_fire_mode and not self:gadget_overrides_weapon_functions() and self:_check_toggle_burst() or toggle_firemode_original(self, ...)
end

function NewRaycastWeaponBase:_check_toggle_burst()
	if self:in_burst_mode() then
		self:_set_burst_mode(false, self.AKIMBO and not self._has_auto)
		return true
	elseif (self._fire_mode == NewRaycastWeaponBase.IDSTRING_SINGLE) or (self._fire_mode == NewRaycastWeaponBase.IDSTRING_AUTO and not self:can_toggle_firemode()) then
		self:_set_burst_mode(true, self.AKIMBO)
		return true
	end
end

function NewRaycastWeaponBase:_set_burst_mode(status, skip_sound)
	self._in_burst_mode = status
	self._fire_mode = NewRaycastWeaponBase["IDSTRING_" .. (status and "SINGLE" or self._has_auto and "AUTO" or "SINGLE")]
	
	if not skip_sound then
		self._sound_fire:post_event(status and "wp_auto_switch_on" or self._has_auto and "wp_auto_switch_on" or "wp_auto_switch_off")
	end
	
	self:cancel_burst()
end

function NewRaycastWeaponBase:can_use_burst_mode()
	return self._has_burst_fire
end

function NewRaycastWeaponBase:in_burst_mode()
	return self._fire_mode == NewRaycastWeaponBase.IDSTRING_SINGLE and self._in_burst_mode and not self:gadget_overrides_weapon_functions()
end

function NewRaycastWeaponBase:burst_rounds_remaining()
	return self._burst_rounds_fired and self._burst_rounds_fired < self._burst_size
end

function NewRaycastWeaponBase:cancel_burst(soft_cancel)
	if self._adaptive_burst_size or not soft_cancel then		
		if self._delayed_burst_recoil and self._burst_rounds_fired > 0 then
			self._setup.user_unit:movement():current_state():force_recoil_kick(self, self._burst_rounds_fired)
		end
		self._burst_rounds_fired = nil
	end
end	

function NewRaycastWeaponBase:reload_speed_multiplier()
	if self._current_reload_speed_multiplier then
		return self._current_reload_speed_multiplier
	end

	local player_manager = managers.player
	local user_unit = self._setup and alive(self._setup.user_unit) and self._setup.user_unit
	local multiplier = 1
	local clip_empty = self:ammo_base():get_ammo_remaining_in_clip() == 0
	local offhand_weapon_empty = false
	if user_unit and user_unit:inventory() and user_unit:inventory().get_next_selection then
		local offhand_weapon = user_unit:inventory():get_next_selection()
		offhand_weapon = offhand_weapon and offhand_weapon.unit and offhand_weapon.unit:base()
		if offhand_weapon then		
			offhand_weapon_empty = offhand_weapon:clip_empty()
		end
	end

	for _, category in ipairs(self:weapon_tweak_data().categories) do
		multiplier = multiplier + player_manager:upgrade_value(category, "reload_speed_multiplier", 1) - 1
		multiplier = multiplier + (1 + player_manager:close_combat_upgrade_value(category, "close_combat_reload_speed_multiplier", 0)) - 1
		multiplier = multiplier + (1 + player_manager:close_combat_upgrade_value(category, "far_combat_reload_speed_multiplier", 0)) - 1
		multiplier = multiplier + (1 - math.min(self:get_ammo_remaining_in_clip() / self:get_ammo_max_per_clip(), 1)) * (player_manager:upgrade_value(category, "empty_reload_speed_multiplier", 1) - 1)
		if offhand_weapon_empty then
			multiplier = multiplier + player_manager:upgrade_value(category, "backup_reload_speed_multiplier", 1) - 1
		end
	end
	multiplier = multiplier + player_manager:upgrade_value("weapon", "passive_reload_speed_multiplier", 1) - 1
	multiplier = multiplier + player_manager:upgrade_value(self._name_id, "reload_speed_multiplier", 1) - 1
	
	if user_unit and user_unit:movement() then
		local morale_boost_bonus = user_unit:movement():morale_boost()

		if morale_boost_bonus then
			multiplier = multiplier + morale_boost_bonus.reload_speed_bonus - 1
		end

		if self._setup.user_unit:movement():next_reload_speed_multiplier() then
			multiplier = multiplier + user_unit:movement():next_reload_speed_multiplier() - 1
		end
	end

	if self:holds_single_round() and player_manager:has_activate_temporary_upgrade("temporary", "single_shot_reload_speed_multiplier") then
		multiplier = multiplier + player_manager:temporary_upgrade_value("temporary", "single_shot_reload_speed_multiplier", 1) - 1
	end
	
	if player_manager:has_activate_temporary_upgrade("temporary", "single_shot_fast_reload") then
		multiplier = multiplier + player_manager:temporary_upgrade_value("temporary", "single_shot_fast_reload", 1) - 1
	end
	
	multiplier = multiplier + player_manager:get_shell_rack_bonus(self)
	multiplier = multiplier + player_manager:get_temporary_property("bloodthirst_reload_speed", 1) - 1
	multiplier = multiplier + player_manager:upgrade_value("team", "crew_faster_reload", 1) - 1

	multiplier = multiplier * self:reload_speed_stat()  * self._reload_speed_mult
	multiplier = managers.modifiers:modify_value("WeaponBase:GetReloadSpeedMultiplier", multiplier)

	self._current_reload_speed_multiplier = multiplier
	return multiplier
end

function NewRaycastWeaponBase:enter_steelsight_speed_multiplier()
	--Make mobility affect this.
	local base_multiplier = tweak_data.weapon.stats.mobility[self:get_concealment()]
	local multiplier = 1
	local categories = self:weapon_tweak_data().categories

	--Removed blatantly unused upgrades.
	for i = 1, #categories do
		multiplier = multiplier + 1 - managers.player:upgrade_value(category, "enter_steelsight_speed_multiplier", 1)
	end

	multiplier = multiplier + 1 - managers.player:upgrade_value("weapon", "enter_steelsight_speed_multiplier", 1)

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

function NewRaycastWeaponBase:get_damage_falloff(damage, col_ray, user_unit, distance_offset)
	local distance = col_ray.distance or mvector3.distance(col_ray.unit:position(), user_unit:position())
	if distance_offset then
		distance = distance + distance_offset
	end
	col_ray.falloff_distance = distance

	--Use cached values if still valid (IE: When shooting multiple rays at once). Otherwise, recalculate falloff.
	local falloff_near = self.near_falloff_distance
	local falloff_far = self.far_falloff_distance
	if not falloff_near and not falloff_far then
		--Initialize base info.
		local falloff_info = tweak_data.weapon.stat_info.damage_falloff
		local current_state = user_unit:movement()._current_state
		local base_falloff = falloff_info.base
		local pm = managers.player

		if current_state then
			--Get bonus from accuracy.
			local acc_bonus = falloff_info.acc_bonus * (self._current_stats_indices.spread + managers.blackmarket:accuracy_index_addend(self._name_id, self:categories(), self._silencer, current_state, self:fire_mode(), self._blueprint) - 1)
		
			--Apply acc/stab bonuses.
			base_falloff = base_falloff + acc_bonus

			--Get ADS multiplier.
			if current_state:in_steelsight() then
				for _, category in ipairs(self:categories()) do
					base_falloff = base_falloff * pm:upgrade_value(category, "steelsight_range_inc", 1)
				end
			end
		end

		--Apply global range multipliers.
		base_falloff = base_falloff * (1 + 1 - pm:get_property("desperado", 1))
		base_falloff = base_falloff * (1 + 1 - pm:temporary_upgrade_value("temporary", "silent_precision", 1))

		base_falloff = base_falloff * (self:weapon_tweak_data().range_mul or 1)
		for _, category in ipairs(self:categories()) do
			if tweak_data[category] and tweak_data[category].range_mul then
				base_falloff = base_falloff * tweak_data[category].range_mul
			end
		end

		--Apply multipliers.
		falloff_near = base_falloff * self._damage_near_mul
		falloff_far = base_falloff * self._damage_far_mul

		--Cache falloff values for usage in hitmarkers and other range-related calculations.
		self.near_falloff_distance = falloff_near
		self.far_falloff_distance = falloff_far --Previous range values. Will generally be the same bullet-to-bullet.
	end


	--Compute final damage.
	return math.max((1 - math.min(1, math.max(0, distance - falloff_near) / (falloff_far))) * damage, 0.05 * damage)
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
	local vel_overshot = tweak_data.weapon.stat_info.vel_overshot[self:get_concealment()] * tweak_data.weapon.stat_info.vel_overshot_stance_muls[move_state]
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