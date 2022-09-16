local SPIN_UP = 1
local SPIN_DOWN = -1
local NORMAL_AUTOHIT = 1
local RICOCHET_AUTOHIT = 2

local init_original = RaycastWeaponBase.init
function RaycastWeaponBase:init(unit)
	init_original(self, unit)
	self:heat_init()
end

function RaycastWeaponBase:heat_init()
	self._shoot_through_data = {
		kills = 0,
		from = Vector3()
	}
	local weapon_tweak = tweak_data.weapon[self._name_id] or self._tweak_data
	
	--self._bullet_slotmask = self._bullet_slotmask - World:make_slot_mask(16)
	if Global.game_settings and Global.game_settings.one_down then
		self._bullet_slotmask = self._bullet_slotmask + 3
	else
		self._bullet_slotmask = managers.mutators:modify_value("RaycastWeaponBase:setup:weapon_slot_mask", self._bullet_slotmask)
		self._bullet_slotmask = managers.modifiers:modify_value("RaycastWeaponBase:setup:weapon_slot_mask", self._bullet_slotmask)
	end

	self._deploy_anim_override = weapon_tweak.deploy_anim_override or nil
	self._deploy_ads_stance_mod = weapon_tweak.deploy_ads_stance_mod or {translation = Vector3(0, 0, 0), rotation = Rotation(0, 0, 0)}

	self._headshot_pierce_damage_mult = 1
	self._pierce_damage_mult = 0.5
	self._can_shoot_through_head = self._can_shoot_through_enemy
	self._can_shoot_through_titan_shield = weapon_tweak.can_shoot_through_titan_shield
	self._reload_speed_mult = weapon_tweak.reload_speed_multiplier or 1

	local can_toggle = weapon_tweak.CAN_TOGGLE_FIREMODE
	self._has_auto = not self._locked_fire_mode and (can_toggle or weapon_tweak.FIRE_MODE == "auto")
	self._has_burst = (can_toggle or weapon_tweak.BURST_COUNT) and weapon_tweak.BURST_COUNT ~= false
	self._has_single = can_toggle or (self._has_burst and not self._has_auto)

	--Set range multipliers.
	self._damage_near_mul = tweak_data.weapon.stat_info.damage_falloff.near_mul
	self._damage_far_mul = tweak_data.weapon.stat_info.damage_falloff.far_mul
	
	self._burst_rounds_fired = nil
	self._burst_fire_rate_multiplier = weapon_tweak.BURST_FIRE_RATE_MULTIPLIER or 1
	self._delayed_burst_recoil = weapon_tweak.DELAYED_BURST_RECOIL

	--Partially determines bloom decay rate.
	self._base_fire_rate = (weapon_tweak.fire_mode_data and weapon_tweak.fire_mode_data.fire_rate or 0) / (weapon_tweak.fire_rate_multiplier or 1)

	--Minigun spinning mechanics.
	if weapon_tweak.spin_rounds then
		self._spin_rounds = weapon_tweak.spin_rounds --Number of animation loops to go through to reach fire-able state.
		self._spin_progress = 0 --Current spin progress.
		self._spin_dir = SPIN_DOWN --Spin direction. SPIN_UP == increasing spin speed. SPIN_DOWN == decreasing spin speed. 
		self._next_spin_animation_t = 0 --Time to play next animation loop.
	end

	self._bullets_fired = 0
	self._curr_kick = 0
	self._kick_pattern = weapon_tweak.kick_pattern
	self._rays = weapon_tweak.rays or 1

	self._autohit_prog = 0

	if weapon_tweak.supported then
		--Since armor piercing chance is no longer used, lets use weapon category to determine armor piercing baseline.
		--TODO: Move to autogen stuff in WeaponTweakData.
		if self:is_category("bow", "crossbow", "saw", "snp") then
			self._use_armor_piercing = true
		end

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
				self._can_ricochet = true
			end
		
			self._headshot_pierce_damage_mult = (self._headshot_pierce_damage_mult or 1) * managers.player:upgrade_value(category, "headshot_pierce_damage_mult", 1)

			if managers.player:has_category_upgrade(category, "headshot_pierce") then
				self._can_shoot_through_head = true
			end

			--Tracker for Mag Dumper Ace
			if managers.player:has_category_upgrade(category, "full_auto_free_ammo") then
				self._bullets_until_free = math.min(self._bullets_until_free or math.huge, managers.player:upgrade_value(category, "full_auto_free_ammo"))
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

			if managers.player:has_category_upgrade(category, "overhealed_damage_mul") then
				local overheal_bonus_data = managers.player:upgrade_value(category, "overhealed_damage_mul")
				self._overheal_damage_dist = math.max(self._overheal_damage_dist or -1, overheal_bonus_data.range or math.huge)
				self._overheal_damage_mul = (self._overheal_damage_mul or 1) * (overheal_bonus_data.damage or 1)
			end

			if managers.player:has_category_upgrade(category, "headshots_ignore_medics") then
				self._ignore_medics_distance = math.max(self._ignore_medics_distance or -1, managers.player:upgrade_value(category, "close_combat_ignore_medics", -1))
			end

			self.headshot_repeat_damage_mult = managers.player:upgrade_value(category, "headshot_repeat_damage_mult", 1)
		end

		if managers.player:has_category_upgrade("weapon", "ricochet_bullets") then
			self._can_ricochet = true
		end
	end
end

local setup_original = RaycastWeaponBase.setup
function RaycastWeaponBase:setup(...)
	setup_original(self, ...)

	if self._current_stats_indices then --These should only apply for weapons using actual stats.
		--Use mobility stat to get the moving accuracy penalty.
		self._spread_moving = tweak_data.weapon.stats.spread_moving[self._concealment] or 0

		--Use stability stat for dynamic bloom accuracy.
		self._spread_bloom = tweak_data.weapon.stat_info.bloom_spread[self._current_stats_indices.recoil] or 0
		self._bloom_stacks = 0
		self._current_spread = 0
		self._ammo_overflow = 0 --Amount of non-integer ammo picked up.
		if self._gadgets then
			self._is_tango_4_viable = table.contains(self._gadgets, "wpn_fps_upg_o_45rds")
		end
	end
end

--Returns the number of additional rays fired by the gun, beyond the normal amount defined in the tweakdata.
function RaycastWeaponBase:_get_bonus_rays()
	return 0
end

--Iterates through the hits table(s), generates a table of 'best' hits on a per-unit basis, then processes all collisions on those.
--The 'best' hit is always the one that deals the most damage. Headshots are always assumed to have more damage than body shots.
--Damage to enemies is based on the damage of the 'best' hit * number of rays hit.
function RaycastWeaponBase:_iter_ray_hits(all_hits, user_unit, damage)
	local best_hits = {}
	local cop_kill_count = 0
	local cop_headshot_count = 0
	local hit_result = nil
	--Determine best hits, and handle ray-level info like penetration and related damage mults.
	for i = 1, #all_hits do
		local ray_hits = all_hits[i]
		local ray_damage = damage
		local hit_through_shield = false
		local hit_through_wall = false

		for i = 1, #ray_hits do
			local hit = ray_hits[i]
			--Populate data related to hit.
			ray_damage = self:get_damage_falloff(ray_damage, hit, user_unit)
			hit.damage = ray_damage
			hit.through_shield = hit_through_shield
			hit.through_wall = hit_through_wall
			hit.count = 1
			hit.max_count = #all_hits

			--Handle penetration.
			if hit.unit:in_slot(managers.slot:get_mask("world_geometry")) then
				hit_through_wall = true
				ray_damage = ray_damage * self._pierce_damage_mult
			elseif hit.unit:in_slot(managers.slot:get_mask("enemy_shield_check")) then
				hit_through_shield = hit_through_shield or alive(hit.unit:parent())
				ray_damage = ray_damage * self._pierce_damage_mult
			elseif hit.headshot then
				ray_damage = ray_damage * self._headshot_pierce_damage_mult
			end

			--Update best hits.
			--Fire non-best hits off as blanks.
			local unit_key = hit.unit:key()
			local old_hit = best_hits[unit_key]
			if old_hit then
				if hit.headshot and not old_hit.headshot then
					hit.count = old_hit.count + 1
					best_hits[unit_key] = hit
					self._bullet_class:on_collision(old_hit, self._unit, user_unit, 0, true, false)
				else
					old_hit.count = old_hit.count + 1
					if hit.damage > old_hit.damage then
						old_hit.damage = hit.damage
					end
					self._bullet_class:on_collision(hit, self._unit, user_unit, 0, true, false)
				end
			else
				best_hits[unit_key] = hit
			end
		end
	end

	local hit_anyone = false
	--Once we have all the best hits, process the collision, statistics, and achievement information for each one.
	for unit, hit in pairs(best_hits) do
		--Whether or not this hit had falloff. Used for hitmarker stuff.
		self.last_hit_falloff = (hit.falloff_distance or hit.distance) > self.near_falloff_distance or hit.count < self._rays * 0.5

		local curr_hit_result = self._bullet_class:on_collision(hit, self._unit, user_unit, hit.damage * hit.count, false, false)

		if curr_hit_result then
			if self._rays > 1 then
				hit_result = managers.mutators:modify_value("ShotgunBase:_fire_raycast", curr_hit_result)
			end
			hit.damage_result = curr_hit_result
			cop_kill_count, cop_headshot_count = self:_process_hit(hit, cop_kill_count, cop_headshot_count)
			hit_anyone = true
		end
	end

	return best_hits, cop_kill_count, hit_anyone
end

--Process statistics and achievement related information for a given enemy hit.
function RaycastWeaponBase:_process_hit(hit, cop_kill_count, cop_headshot_count)
	local unit_type = hit.unit:base() and hit.unit:base()._tweak_table
	local is_civilian = unit_type and CopDamage.is_civilian(unit_type)

	--Record that a shot hit a good target.
	--Skip incrementing the ammo count, let fire_raycast handle that.
	if not is_civilian then
		self._shot_fired_stats_table.skip_bullet_count = true
		self._shot_fired_stats_table.hit = true
		managers.statistics:shot_fired(self._shot_fired_stats_table)
		self._shot_fired_stats_table.hit = false
		self._shot_fired_stats_table.skip_bullet_count = false
	end

	if not is_civilian then
		if hit.headshot then
			cop_headshot_count = cop_headshot_count + 1
		end

		if hit.damage_result.type == "death" then
			cop_kill_count = cop_kill_count + 1

			self._kills_without_releasing_trigger = (self._kills_without_releasing_trigger or 0) + 1

			if self:is_category(tweak_data.achievement.easy_as_breathing.weapon_type) then
				if tweak_data.achievement.easy_as_breathing.count <= self._kills_without_releasing_trigger then
					managers.achievment:award(tweak_data.achievement.easy_as_breathing.award)
				end
			end
		end

		if cop_kill_count > 0 then
			self:_check_kill_achievements(hit, cop_kill_count, cop_headshot_count)
		end
	end

	return cop_kill_count, cop_headshot_count
end

--Handles kill related achievements.
--Is overrided by ShotgunBase to handle shotgun specific achievements.
function RaycastWeaponBase:_check_kill_achievements(hit, cop_kill_count, cop_headshot_count)
	local multi_kill, enemy_pass, obstacle_pass, weapon_pass, weapons_pass, weapon_type_pass = nil

	for achievement, achievement_data in pairs(tweak_data.achievement.sniper_kill_achievements) do
		multi_kill = not achievement_data.multi_kill or cop_kill_count == achievement_data.multi_kill
		enemy_pass = not achievement_data.enemy or unit_type == achievement_data.enemy
		obstacle_pass = not achievement_data.obstacle or achievement_data.obstacle == "wall" and hit.through_wall or achievement_data.obstacle == "shield" and hit.through_shield
		weapon_pass = not achievement_data.weapon or self._name_id == achievement_data.weapon
		weapons_pass = not achievement_data.weapons or table.contains(achievement_data.weapons, self._name_id)
		weapon_type_pass = not achievement_data.weapon_type or self:is_category(achievement_data.weapon_type)

		if multi_kill and enemy_pass and obstacle_pass and weapon_pass and weapons_pass and weapon_type_pass then
			if achievement_data.stat then
				managers.achievment:award_progress(achievement_data.stat)
			elseif achievement_data.award then
				managers.achievment:award(achievement_data.award)
			elseif achievement_data.challenge_stat then
				managers.challenge:award_progress(achievement_data.challenge_stat)
			elseif achievement_data.trophy_stat then
				managers.custom_safehouse:award(achievement_data.trophy_stat)
			elseif achievement_data.challenge_award then
				managers.challenge:award(achievement_data.challenge_award)
			end
		end
	end
end

local right_vec = Vector3(0, 0, 1)
local mvec_to = Vector3()
local mvec_spread_direction = Vector3()
function RaycastWeaponBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul)
	if self:gadget_overrides_weapon_functions() then
		--Self is required in this call since underbarrel launchers rely on the weapon_base of the parent gun.
		return self:gadget_function_override("_fire_raycast", self, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul)
	end

	local damage = self._damage * dmg_mul
	local ray_distance = self:weapon_range()
	local result = {}
	local all_hits = {}
	local spread_x, spread_y = self:_get_spread(user_unit)
	local right = direction:cross(right_vec)
	local up = direction:cross(right)
	mvector3.normalize(right)
	mvector3.normalize(up)

	local ray_count = self._rays + self:_get_bonus_rays()
	for i = 1, ray_count do
		local r = math.sqrt(math.random())  --Ensures even spread distribution, rather than center biased.
		local theta = math.random() * 360
		--Calculate spread as a random point in a circle, rather than the vanilla cross biased system.
		local ax = math.tan(r * spread_x * (spread_mul or 1)) * math.cos(theta)
		local ay = math.tan(r * spread_y * (spread_mul or 1)) * math.sin(theta) * -1
		mvector3.set(mvec_spread_direction, direction)
		mvector3.add(mvec_spread_direction, right * ax)
		mvector3.add(mvec_spread_direction, up * ay)
		mvector3.set(mvec_to, mvec_spread_direction)
		mvector3.multiply(mvec_to, ray_distance)
		mvector3.add(mvec_to, from_pos)
		local ray_hits, hit_enemy = self:_collect_hits(from_pos, mvec_to)

		--Check for auto hit if no enemy was hit.
		if self._autoaim and not hit_enemy then
			local auto_ray_hits, auto_hit_enemy = self:_check_near_hits(from_pos, mvec_to, direction, ray_distance, NORMAL_AUTOHIT)
			if auto_ray_hits then
				hit_enemy = auto_hit_enemy	
				ray_hits = auto_ray_hits
				mvector3.set(mvec_to, from_pos)
				mvector3.add_scaled(mvec_to, auto_ray_hits[#auto_ray_hits].ray, ray_distance)
				mvector3.set(mvec_spread_direction, mvec_to)
			end
		end

		if ray_hits then
			if self._alert_events then
				self:_check_alert(ray_hits, from_pos, mvec_to, user_unit)
			end

			--Spawn bullet trail for the main bullet.
			local trail_distance = ray_hits.trail_index > 0 and ray_hits[ray_hits.trail_index] and ray_hits[ray_hits.trail_index].distance or ray_distance
			if trail_distance > 600 and alive(self._obj_fire) then
				self._obj_fire:m_position(self._trail_effect_table.position)
				mvector3.set(self._trail_effect_table.normal, mvec_spread_direction)
				local trail = World:effect_manager():spawn(self._trail_effect_table)
				World:effect_manager():set_remaining_lifetime(trail, math.clamp((trail_distance - 600) / 10000, 0, trail_distance))
			end

			--Spawn a delayed bullet trail if the bullet did a ricochet.
			if ray_hits.ricochet_distance then
				local ricochet_trail_distance = ray_hits[#ray_hits] and ray_hits[#ray_hits].distance or ray_hits.ricochet_distance
				if ricochet_trail_distance > 600 then
					heat.AddDelayedCall("ricochet_trail", math.clamp((trail_distance - 600) / 10000, 0.01, trail_distance), function()
						mvector3.set(self._trail_effect_table.position, ray_hits.ricochet_from_pos)
						mvector3.set(self._trail_effect_table.normal, ray_hits.ricochet_direction)
						local trail = World:effect_manager():spawn(self._trail_effect_table)
						World:effect_manager():set_remaining_lifetime(trail, math.clamp((ricochet_trail_distance - 600) / 10000, 0, ricochet_trail_distance))
					end)
				end
			end

			all_hits[#all_hits + 1] = ray_hits
		end
	end

	--Once all hits are determined, handle collisions.
	local cop_kill_count = 0
	result.rays, cop_kill_count, result.hit_enemy = self:_iter_ray_hits(all_hits, user_unit, damage)

	--Apply suppression to relevant enemies.
	if self._autoaim and self._suppression then
		local suppression_cone_radius = ray_distance * math.tan(tweak_data.weapon.stat_info.suppression_angle)
		local suppressed_enemies = self._unit:find_units("cone", from_pos, direction, suppression_cone_radius, managers.slot:get_mask("player_autoaim"))
		if suppressed_enemies then
			for _, enemy in pairs(suppressed_enemies) do
				if not enemy:movement():cool() then
					enemy:character_damage():build_suppression(self._suppression, self._panic_suppression_chance)
				end
			end
		end
	end

	--Check the tango 4 achievement stuff.
	if not tweak_data.achievement.tango_4.difficulty or table.contains(tweak_data.achievement.tango_4.difficulty, Global.game_settings.difficulty) then
		if self._gadgets and self._is_tango_4_viable and cop_kill_count > 0 and managers.player:player_unit():movement():current_state():in_steelsight() then
			if self._tango_4_data then
				if self._gadget_on == self._tango_4_data.last_gadget_state then
					self._tango_4_data = nil
				else
					self._tango_4_data.last_gadget_state = self._gadget_on
					self._tango_4_data.count = self._tango_4_data.count + 1
				end

				if self._tango_4_data and tweak_data.achievement.tango_4.count <= self._tango_4_data.count then
					managers.achievment:_award_achievement(tweak_data.achievement.tango_4, "tango_4")
				end
			else
				self._tango_4_data = {
					count = 1,
					last_gadget_state = self._gadget_on
				}
			end
		elseif self._tango_4_data then
			self._tango_4_data = nil
		end
	end

	--Record that a shot was fired. Only player guns have autoaim. _process_hit records actual hits for accuracy stats.
	if self._autoaim then
		self._shot_fired_stats_table.hit = false
		if (not self._ammo_data or not self._ammo_data.ignore_statistic) then
			managers.statistics:shot_fired(self._shot_fired_stats_table)
		end
	end

	return result
end

function RaycastWeaponBase:_fire_ricochet(hit, units_hit, unique_hits, hit_enemy)
	local start_distance = hit.distance
	local ray_distance = self:weapon_range() - start_distance

	--Offset the raycast a small amount from the wall, otherwise it will result in the wall 'catching' the bullet.
	local from_pos = hit.position + hit.normal

	local reflect_dir = mvector3.copy(hit.ray)
	mvector3.add(reflect_dir, -2 * hit.ray:dot(hit.normal) * hit.normal)

	--Prevent bullets bouncing directly backwards
	local angle = math.abs(mvector3.angle(hit.ray, reflect_dir))
	if angle < 0 or angle > 170 then
		return
	end

	--Get vector with proper distance.
	local reflect_vec = mvector3.copy(reflect_dir)
	mvector3.multiply(reflect_vec, ray_distance)
	mvector3.add(reflect_vec, from_pos)
	local ray_hits, ricochet_hit_enemy = self:_collect_hits(from_pos, reflect_vec, true)

	--Give more generous auto-aim.
	if not ricochet_hit_enemy then
		local auto_ray_hits, auto_hit_enemy = self:_check_near_hits(from_pos, reflect_vec, direction, ray_distance, RICOCHET_AUTOHIT)
		if auto_ray_hits then
			ricochet_hit_enemy = auto_hit_enemy
			ray_hits = auto_ray_hits
			mvector3.set(reflect_dir, from_pos)
			mvector3.add_scaled(mvec_to, auto_ray_hits[#auto_ray_hits].ray, ray_distance)
			mvector3.set(mvec_spread_direction, reflect_dir)
		end
	end

	--Append hits to table, and add/update relevant fields for the ricochets.
	for i = 1, #ray_hits do
		local hit = ray_hits[i]
		if not units_hit[hit.unit:key()] then
			hit.ricochet = true --Used in on_collision functions to let them know to ignore civilians.
			hit.falloff_distance = start_distance + hit.distance --Needed for correct falloff calcs.
			unique_hits[#unique_hits + 1] = hit
		end
	end

	--Store data for ricohet particle effect
	unique_hits.ricochet_from_pos = from_pos
	unique_hits.ricochet_direction = reflect_vec
	unique_hits.ricochet_distance = ray_distance

	return unique_hits, ricochet_hit_enemy or hit_enemy
end

--Minor fixes and making Winters unpiercable.
local ai_vision_ids = Idstring("ai_vision")
local bulletproof_ids = Idstring("bulletproof")
function RaycastWeaponBase:_collect_hits(from, to, is_ricochet)
	local units_hit = {}
	local unique_hits = {}
	local hit_enemy = false
	local enemy_mask = managers.slot:get_mask("enemies")
	local wall_mask = managers.slot:get_mask("world_geometry", "vehicles")
	local shield_mask = managers.slot:get_mask("enemy_shield_check")
	--Just set this immediately.
	local ray_hits = self._can_shoot_through_wall and World:raycast_wall("ray", from, to, "slot_mask", self._bullet_slotmask, "ignore_unit", self._setup.ignore_units, "thickness", 40, "thickness_mask", wall_mask)
		or World:raycast_all("ray", from, to, "slot_mask", self._bullet_slotmask, "ignore_unit", self._setup.ignore_units)

	for i = 1, #ray_hits do
		local hit = ray_hits[i]
		if not units_hit[hit.unit:key()] then
			units_hit[hit.unit:key()] = true
			unique_hits[#unique_hits + 1] = hit
			hit_enemy = hit_enemy or hit.unit:in_slot(enemy_mask)

			--Check if headshot.
			if hit.unit:in_slot(enemy_mask)
				and not hit.unit:character_damage()._char_tweak.ignore_headshot
				and hit.unit:character_damage()._ids_head_body_name
				and hit.unit:character_damage()._ids_head_body_name == hit.body:name() then
				
				--Track which hits are headshots for achievements, shotgun mechanics, and Tactical Precision.
				hit.headshot = true
			end

			--Determine when bullet travel ends.
			if hit_enemy then
				if not self._can_shoot_through_enemy and (not self._can_shoot_through_head or not hit.headshot) then
					break
				end
			elseif not self._can_shoot_through_wall and hit.unit:in_slot(wall_mask) and (hit.body:has_ray_type(ai_vision_ids) or hit.body:has_ray_type(bulletproof_ids))
				or hit.unit:in_slot(shield_mask) and (hit.unit:name():key() == '4a4a5e0034dd5340' --Winter's Shield
					or (hit.unit:name():key() == 'af254947f0288a6c' and not self._can_shoot_through_titan_shield) --Titan Shields
					or not self._can_shoot_through_shield) then --Regular Shields
				if self._can_ricochet and not is_ricochet then
					unique_hits.trail_index = i
					return self:_fire_ricochet(hit, units_hit, unique_hits, hit_enemy)
				else
					break
				end
			end
		end
	end

	unique_hits.trail_index = #unique_hits
	return unique_hits, hit_enemy
end

function RaycastWeaponBase:get_damage_falloff(damage, col_ray)
	local distance = col_ray.falloff_distance or col_ray.distance
	return (1 - math.min(1, math.max(0, distance - self.near_falloff_distance) / self.far_falloff_distance)) * damage
end

--Call this whenever the gun is fired to update to the latest values, since skills can change it in realtime.
function RaycastWeaponBase:_compute_falloff_distance(user_unit)
	if self:gadget_overrides_weapon_functions() then
		return self:gadget_function_override("_compute_falloff_distance", user_unit)
	end

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

	--Cache falloff values for usage in hitmarkers and other range-related calculations.
	self.near_falloff_distance = base_falloff * self._damage_near_mul
	self.far_falloff_distance = base_falloff * self._damage_far_mul
	self.last_hit_falloff = false
end

function RaycastWeaponBase:_convert_add_to_mul(value)
	if value > 1 then
		return 1 / value
	elseif value < 1 then
		return math.abs(value - 1) + 1
	else
		return 1
	end
end

function RaycastWeaponBase:recoil_multiplier()
	local rounds = 1
	if self._delayed_burst_recoil and self:fire_mode() == "burst" then
		if self:burst_rounds_remaining() then
			return 0
		else
			rounds = self._burst_count
		end
	end

	local user_unit = self._setup and self._setup.user_unit
	local current_state = user_unit:movement()._current_state
	local mul = 1

	if not self._in_steelsight then
		for _, category in ipairs(self:categories()) do
			mul = mul + managers.player:upgrade_value(category, "hip_fire_recoil_multiplier", 1) - 1
		end
	end

	mul = mul + managers.player:temporary_upgrade_value("temporary", "bullet_hell", {recoil_multiplier = 1.0}).recoil_multiplier - 1

	return rounds * self:_convert_add_to_mul(mul)
end

function RaycastWeaponBase:weapon_range()
	if self.near_falloff_distance then
		return self.near_falloff_distance + self.far_falloff_distance
	else
		return self._weapon_range or 20000
	end
end

--Cache shield attack_data table.
local shield_knock_data = {
	damage = 0,
	type = "shield_knock",
	variant = "melee",
	col_ray = nil, --Set this when table is used. Leave rest untouched.
	result = {
		variant = "melee",
		type = "shield_knock"
	}
}
function InstantBulletBase:on_collision(col_ray, weapon_unit, user_unit, damage, blank, no_sound)
	blank = Network:is_client() and not blank and user_unit ~= managers.player:player_unit()

	local hit_unit = col_ray.unit
	local hit_char_damage = hit_unit:character_damage()
	local is_shield = hit_unit:in_slot(managers.slot:get_mask("enemy_shield_check")) and alive(hit_unit:parent())
	local weapon_base = alive(weapon_unit) and weapon_unit:base()

	if alive(weapon_unit) and not blank and is_shield and weapon_base._shield_knock then
		local enemy_unit = hit_unit:parent()

		if enemy_unit:character_damage() and enemy_unit:character_damage().dead and not enemy_unit:character_damage():dead()
		   and enemy_unit:base():char_tweak() and not enemy_unit:character_damage():is_immune_to_shield_knockback()
		   and tweak_data.upgrades.shield_knock_chance > math.random() then
			shield_knock_data.col_ray = col_ray
			enemy_unit:character_damage():_call_listeners(shield_knock_data)
		end
	end

	if col_ray.ricochet then --Civilian hits treat Ricochets as blanks as a QOL feature.
		local unit_type = alive(hit_unit) and hit_unit.base and hit_unit:base() and hit_unit:base()._tweak_table
		if unit_type and CopDamage.is_civilian(unit_type) then
			blank = true
		end
	end

	local play_impact_flesh = not hit_char_damage or not hit_char_damage._no_blood

	if hit_unit:damage() and managers.network:session() and col_ray.body:extension() and col_ray.body:extension().damage then
		local damage_body_extension = true
		local character_unit = nil

		if hit_char_damage then
			character_unit = hit_unit
		elseif is_shield and hit_unit:parent():character_damage() then
			character_unit = hit_unit:parent()
		end

		--do a friendly fire check if the unit hit is a character or a character's shield before damaging the body extension that was hit
		if character_unit and character_unit:character_damage().is_friendly_fire and character_unit:character_damage():is_friendly_fire(user_unit) then
			damage_body_extension = false
		end

		if damage_body_extension then
			local sync_damage = not blank and hit_unit:id() ~= -1
			local network_damage = math.ceil(damage * 163.84)
			damage = network_damage / 163.84

			if sync_damage then
				local normal_vec_yaw, normal_vec_pitch = self._get_vector_sync_yaw_pitch(col_ray.normal, 128, 64)
				local dir_vec_yaw, dir_vec_pitch = self._get_vector_sync_yaw_pitch(col_ray.ray, 128, 64)

				managers.network:session():send_to_peers_synched("sync_body_damage_bullet", col_ray.unit:id() ~= -1 and col_ray.body or nil, user_unit:id() ~= -1 and user_unit or nil, normal_vec_yaw, normal_vec_pitch, col_ray.position, dir_vec_yaw, dir_vec_pitch, math.min(16384, network_damage))
			end

			local local_damage = not blank or hit_unit:id() == -1

			if local_damage then
				col_ray.body:extension().damage:damage_bullet(user_unit, col_ray.normal, col_ray.position, col_ray.ray, 1)
				col_ray.body:extension().damage:damage_damage(user_unit, col_ray.normal, col_ray.position, col_ray.ray, damage)

				if alive(weapon_unit) and weapon_base.categories and weapon_base:categories() then
					local categories = weapon_base:categories()
					for i = 1, #categories do
						col_ray.body:extension().damage:damage_bullet_type(categories[i], user_unit, col_ray.normal, col_ray.position, col_ray.ray, 1)
					end
				end
			end
		end
	end

	local result = nil
	local push_multiplier = nil

	if alive(weapon_unit) and hit_char_damage and hit_char_damage.damage_bullet then
		local was_alive = not hit_char_damage:dead()

		if not blank then
			result = self:give_impact_damage(col_ray, weapon_unit, user_unit, damage, weapon_base._use_armor_piercing, false, false, weapon_base._stagger, weapon_base._variant)
		end

		local is_dead = hit_char_damage:dead()

		if not is_dead then
			if not result or result == "friendly_fire" then
				play_impact_flesh = false
			end
		end

		push_multiplier = self:_get_character_push_multiplier(weapon_unit, was_alive and is_dead)
	end

	managers.game_play_central:physics_push(col_ray, push_multiplier)

	if play_impact_flesh then
		managers.game_play_central:play_impact_flesh({
			col_ray = col_ray,
			no_sound = no_sound
		})
		self:play_impact_sound_and_effects(weapon_unit, col_ray, no_sound)
	end

	return result
end

--New pickup mechanics.
--Fully determinisitic, with no RNG.
--When low on ammo, uses pickup 2, when high, uses pickup 1. Leading to a self-balancing ammo tension.
--Decimal values roll over into the next pickup until it adds up to a bullet.
function RaycastWeaponBase:add_ammo(ratio, add_amount_override)
	local _add_ammo = function(ammo_base, ratio, add_amount_override)
		local ammo_max = ammo_base:get_ammo_max()
		local ammo_total = ammo_base:get_ammo_total() 
		if ammo_max == ammo_total then
			return false, 0
		end

		--Ammo gained is proportional to how much ammo you're missing in the gun.
		local ammo_gained_raw = add_amount_override or math.lerp(ammo_base._ammo_pickup[1], ammo_base._ammo_pickup[2],  ammo_total / ammo_max) * (ratio or 1)
			+ (ammo_base._ammo_overflow or 0)
		if ammo_gained_raw <= 0 then --Handle weapons with 0 pickup.
			return false, 0
		end

		local ammo_gained = math.max(0, math.floor(ammo_gained_raw))
		ammo_base._ammo_overflow = math.max(ammo_gained_raw - ammo_gained, 0)
		ammo_base:set_ammo_total(math.clamp(ammo_total + ammo_gained, 0, ammo_max))
		return true, ammo_gained
	end

	local picked_up, add_amount
	picked_up, add_amount = _add_ammo(self, ratio, add_amount_override)
	
	--Weapons with other weapons attached. Basically, The Little Friend.
	for _, gadget in ipairs(self:get_all_override_weapon_gadgets()) do
		if gadget and gadget.ammo_base then
			local p, a = _add_ammo(gadget:ammo_base(), ratio, add_amount_override)
			picked_up = p or picked_up
			add_amount = add_amount + a
		end
	end
	return picked_up, add_amount
end

--Check if the current shot will proc autohit.
--Low spread == more procs.
--High spread == fewer procs.
--Start from a baseline of every shot procs autohit when you have 0 spread, and increase the number linearly as spread area goes up.
function RaycastWeaponBase:roll_autohit()
	self._autohit_prog = self._autohit_prog + (tweak_data.weapon.stat_info.autohit_rate / (self._current_spread_area + 1))
	if self._autohit_prog >= 1 then
		self._autohit_prog = math.max(self._autohit_prog - 1, 0)
		return true
	end

	return false
end


--Resolves a vanilla issue that can let you cheat timed buffs from one reload->next on shotgun reloads.
--Since all reloads use this cache to avoid 1000 skill checks, it's pretty important to make sure it's invalidated.
--Any time the player starts a new reload.
function RaycastWeaponBase:invalidate_current_reload_speed_multiplier()
	if self:gadget_overrides_weapon_functions() then
		return self:gadget_function_override("invalidate_current_reload_speed_multiplier")
	end

	self._current_reload_speed_multiplier = nil
end

function RaycastWeaponBase:reload_speed_multiplier()
	if self:gadget_overrides_weapon_functions() then
		return self:gadget_function_override("reload_speed_multiplier", user_unit)
	end

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

	for _, category in ipairs(self:categories()) do
		multiplier = multiplier + player_manager:upgrade_value(category, "reload_speed_multiplier", 1) - 1
		multiplier = multiplier + (1 + player_manager:close_combat_upgrade_value(category, "close_combat_reload_speed_multiplier", 0)) - 1
		multiplier = multiplier + (1 + player_manager:close_combat_upgrade_value(category, "far_combat_reload_speed_multiplier", 0)) - 1
		multiplier = multiplier + (1 - math.min(self:ammo_base():get_ammo_remaining_in_clip() / self:ammo_base():get_ammo_max_per_clip(), 1)) * (player_manager:upgrade_value(category, "empty_reload_speed_multiplier", 1) - 1)
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

	multiplier = multiplier * self:reload_speed_stat() * self._reload_speed_mult
	multiplier = managers.modifiers:modify_value("WeaponBase:GetReloadSpeedMultiplier", multiplier)

	self._current_reload_speed_multiplier = multiplier
	return multiplier
end

--Determines if a near hit should turn into an auto_hit.
local body_vec = Vector3()
local head_vec = Vector3()
function RaycastWeaponBase:_check_near_hits(from_pos, to_pos, direction, cone_distance, autohit_type)
	--Check if autohit occurs.
	--If use_aim_assist is set to true (IE: For controller players ADSing), then always autoaim.
	--Same with ricocheting bullets.
	--Otherwise, accumulate the autohit progression tracker and see if it procs.
	if not self:roll_autohit() then
		return
	end

	--Get relevant slot masks
	local enemy_mask = managers.slot:get_mask("player_autoaim")
	local wall_mask = managers.slot:get_mask("world_geometry", "vehicles")
	local shield_mask = managers.slot:get_mask("enemy_shield_check")

	--Collect potential hitrays for all enemies that are within the autoaim cone, and return any valid bullet directions that lead to a hit.
	local autohit_angle = autohit_type == RICOCHET_AUTOHIT and tweak_data.weapon.stat_info.ricochet_autohit_angle or tweak_data.weapon.stat_info.autohit_angle
	local autohit_cone_radius = cone_distance * math.tan(autohit_angle + self:_get_spread())
	local autohit_candidates = self._unit:find_units("cone", from_pos, to_pos, autohit_cone_radius, managers.slot:get_mask("player_autoaim"))
	local autohit_dir = Vector3()
	for _, enemy in pairs(autohit_candidates) do
		--Get head and body positions of the enemy, and determine which one is closer to where the player was aiming to determine final raycast direction.
		--An additional difficulty factor is added to the head's error value to make it slightly trickier to get- just like with a non-autohit bullet.
		local enemy_pos_data = enemy:character_damage():get_ranged_attack_autotarget_data_fast()
		
		local head_pos = enemy_pos_data.head:position()
		local head_vec_len = mvector3.direction(head_vec, from_pos, head_pos)
		local head_error_angle = math.acos(mvector3.dot(direction, head_vec))

		local body_pos = enemy_pos_data.body:position()
		local body_vec_len = mvector3.direction(body_vec, from_pos, body_pos)
		local body_error_angle = math.acos(mvector3.dot(direction, body_vec))

		local autohit_dir_len = 0
		if head_error_angle * tweak_data.weapon.stat_info.autohit_head_difficulty_factor < body_error_angle then
			mvector3.set(autohit_dir, head_vec)
			autohit_dir_len = head_vec_len
		else
			mvector3.set(autohit_dir, body_vec)
			autohit_dir_len = body_vec_len
		end

		--Convert the target vector to originate from the player and go the distance to the enemy head.
		mvector3.multiply(autohit_dir, autohit_dir_len)
		mvector3.add(autohit_dir, from_pos)

		local unique_hits, hit_enemy = self:_collect_hits(from_pos, autohit_dir, autohit_type == RICOCHET_AUTOHIT)
		if hit_enemy then
			return unique_hits, hit_enemy
		end
	end
end

--Autofire soundfix 2 integration.
	_G.AutoFireSoundFixBlacklist = {
		["saw"] = true, --OVE9000 Saw
		["saw_secondary"] = true, --Also OVE9000 Saw
		["flamethrower_mk2"] = true, --Flamethrower Mk1
		["m134"] = true, --Minigun
		["shuno"] = true,  --Microgun
		["system"] = true --Flamethrower Mk2
	}

	--Allows users/modders to easily edit this blacklist from outside of this mod
	Hooks:Register("AFSF2_OnWriteBlacklist")
	Hooks:Add("BaseNetworkSessionOnLoadComplete","AFSF2_OnLoadComplete",function()
		Hooks:Call("AFSF2_OnWriteBlacklist",AutoFireSoundFixBlacklist)
	end)

	--Check for if AFSF's fix code should apply to this particular weapon
	function RaycastWeaponBase:_soundfix_should_play_normal()
		local name_id = self:get_name_id()
		if self._setup.user_unit ~= managers.player:player_unit() then
			--don't apply fix for NPCs or other players
			return true
		elseif AutoFireSoundFixBlacklist[name_id] then
			--blacklisted sound
			return true
		elseif tweak_data.weapon[name_id].use_fix ~= nil then 
			--for custom weapons
			return tweak_data.weapon[name_id].use_fix
		elseif not self:weapon_tweak_data().sounds.fire_single then
			--no singlefire sound; should play normal
			return true
		end
	end

	function RaycastWeaponBase:stop_shooting(...)
		--Apply AFSF
		if self:_soundfix_should_play_normal() then
			self:play_tweak_data_sound("stop_fire")
		end

		self._shooting = nil
		self._kills_without_releasing_trigger = nil
		self._bullets_fired = 0

		--Clear/start timer for bullet hell.
		if self._bullet_hell_procced then
			managers.player:activate_temporary_upgrade("temporary", "bullet_hell")
			self._bullet_hell_procced = nil
		end	

		--Stop minigun spin.
		if self._spin_rounds and not self._in_steelsight then
			self:_stop_spin()
		end
	end

	--Prevent playing sounds except for blacklisted weapons
	local orig_fire_sound = RaycastWeaponBase._fire_sound
	function RaycastWeaponBase:_fire_sound(...)
		if self:_soundfix_should_play_normal() then
			return orig_fire_sound(self,...)
		end
	end

function RaycastWeaponBase:update_next_shooting_time()
	if self:gadget_overrides_weapon_functions() then
		local gadget_func = self:gadget_function_override("update_next_shooting_time")

		if gadget_func then
			return gadget_func
		end
	end

	local next_fire = self._base_fire_rate / self:fire_rate_multiplier()
	self._next_fire_allowed = self._next_fire_allowed + next_fire
end

function RaycastWeaponBase:fire(from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, target_unit)
	local user_unit = self._setup.user_unit
	local is_player = user_unit == managers.player:player_unit()
	local consume_ammo = not is_player

	if is_player then
		--Invalidate old falloff data.
		self:_compute_falloff_distance(user_unit)
		self:add_bloom_stack()

		if managers.player:has_activate_temporary_upgrade("temporary", "no_ammo_cost_buff") then
			managers.player:deactivate_temporary_upgrade("temporary", "no_ammo_cost_buff")

			if managers.player:has_category_upgrade("temporary", "no_ammo_cost") then
				managers.player:activate_temporary_upgrade("temporary", "no_ammo_cost")
			end
		end

		consume_ammo = not managers.player:has_active_temporary_property("bullet_storm") --Bullet Storm
			and (not managers.player:has_activate_temporary_upgrade("temporary", "berserker_damage_multiplier") or not managers.player:has_category_upgrade("player", "berserker_no_ammo_cost")) --Swan Song
			and not (self._bullets_until_free and self._bullets_fired > 0 and self._bullets_fired % self._bullets_until_free == 0) --Spray and Pray
			and not (math.random() < managers.player:temporary_upgrade_value("temporary", "bullet_hell", {free_ammo_chance = 0}).free_ammo_chance) --Bullet Hell

		if self._shots_before_bullet_hell and self._shots_before_bullet_hell <= self._bullets_fired then
			self._bullet_hell_procced = true
			managers.player:activate_temporary_upgrade_indefinitely("temporary", "bullet_hell")
		end

		self._bullets_fired = self._bullets_fired + 1
	end

	if consume_ammo and (is_player or Network:is_server()) then
		local base = self:ammo_base()

		if base:get_ammo_remaining_in_clip() == 0 then
			return
		end

		local ammo_usage = 1
		local mag = base:get_ammo_remaining_in_clip()
		local remaining_ammo = mag - ammo_usage

		if mag > 0 and remaining_ammo <= 0 then
			self:_play_magazine_empty_anims()
			self:set_magazine_empty(true)
		end

		base:set_ammo_remaining_in_clip(mag - ammo_usage)
		self:use_ammo(base, ammo_usage)
	end

	self:_check_ammo_total(user_unit)

	if alive(self._obj_fire) then
		self:_spawn_muzzle_effect(from_pos, direction)
	end

	self:_spawn_shell_eject_effect()

	local ray_res = self:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, target_unit)

	managers.player:send_message(Message.OnWeaponFired, nil, self._unit, ray_res)

	--Autofire soundfix integration.
	if self:_soundfix_should_play_normal() then
		return ray_res
	end

	if ray_res and self._setup.user_unit == managers.player:player_unit() then
		self:play_tweak_data_sound("fire_single","fire")
		self:play_tweak_data_sound("stop_fire")
	end

	return ray_res
end

function RaycastWeaponBase:_play_magazine_empty_anims()
	local w_td = self:weapon_tweak_data()

	if w_td.animations and w_td.animations.magazine_empty then
		self:tweak_data_anim_play("magazine_empty")
	end

	if w_td.sounds and w_td.sounds.magazine_empty then
		self:play_tweak_data_sound("magazine_empty")
	end

	if w_td.effects and w_td.effects.magazine_empty then
		self:_spawn_tweak_data_effect("magazine_empty")
	end
end

--Updates the position in the weapon kick pattern table, and returns the desired value.
function RaycastWeaponBase:do_kick_pattern()
	if not self._kick_pattern then
		heat.log(self._name_id, " is missing a kick pattern!")
		return {math.random(), math.random()}
	end

	self._curr_kick = self._curr_kick + math.round(math.random(self._kick_pattern.random_range[1], self._kick_pattern.random_range[2]))
	if self._curr_kick > #self._kick_pattern.pattern then
		self._curr_kick = self._curr_kick - #self._kick_pattern.pattern
	end

	return self._kick_pattern.pattern[self._curr_kick]
end

function RaycastWeaponBase:holds_single_round()
	if self:gadget_overrides_weapon_functions() then
		return self:gadget_function_override("holds_single_round")
	end
	return self:get_ammo_max_per_clip() == 1
end

--Allows underbarrels to work with weapon category based skills properly.
function RaycastWeaponBase:categories()
	if self:gadget_overrides_weapon_functions() then
		return self:gadget_function_override("categories")
	end
	
	return self._tweak_data and self._tweak_data.categories or self:weapon_tweak_data().categories
end

function RaycastWeaponBase:get_accuracy_addend()
	return managers.blackmarket:accuracy_index_addend(self._name_id, self:categories(), self._silencer, nil, self:fire_mode(), self._blueprint)
end

--Calculate spread value. Done once per frame.
function RaycastWeaponBase:update_spread(current_state, t, dt)
	if self:gadget_overrides_weapon_functions() then
		return self:gadget_function_override("update_spread", current_state, t, dt)
	end

	if not current_state then
		self._current_spread = 0
		return
	end

	--Get spread area from accuracy stat.
	local spread_area = self._spread + self:get_accuracy_addend() * tweak_data.weapon.stat_info.spread_per_accuracy

	--Moving penalty to spread, based on stability stat- added to total area.
	if current_state._moving or current_state._state_data.in_air then
		--Get spread area from stability stat.
		local moving_spread = math.max(self._spread_moving, 0)

		--Add moving spread penalty reduction.
		moving_spread = moving_spread * self:moving_spread_penalty_reduction()

		if current_state._state_data.in_air then
			moving_spread = moving_spread * 2
		end

		spread_area = spread_area + moving_spread
	end

	--Apply bloom penalty to spread. Decay existing stacks if player is not firing or reloading.
	if self._bloom_stacks > 0 and current_state._is_reloading and not current_state:_is_reloading()
		and t > self._next_fire_allowed + tweak_data.weapon.stat_info.bloom_data.decay_delay then
		self._bloom_stacks = math.max(self._bloom_stacks - tweak_data.weapon.stat_info.bloom_data.decay * dt, 0)
	end
	spread_area = spread_area + (self._bloom_stacks * self._spread_bloom * self:bloom_spread_penality_reduction())

	--Apply skill multipliers to overall spread area.
	local movement_state = current_state:get_movement_state()
	spread_area = spread_area * tweak_data.weapon.stat_info.stance_spread_mults[movement_state] * self:conditional_accuracy_multiplier(movement_state)

	self._current_spread_area = math.max(spread_area, 0)

	--Convert spread area to degrees.
	self._current_spread = math.sqrt((self._current_spread_area)/math.pi)
end

function RaycastWeaponBase:add_bloom_stack()
	if self:gadget_overrides_weapon_functions() then
		return self:gadget_function_override("add_bloom_stack")
	end
	self._bloom_stacks = self:holds_single_round() and 1 or math.min(self._bloom_stacks + self._base_fire_rate, 1)
end

function RaycastWeaponBase:multiply_bloom(amount)
	self._bloom_stacks = self._bloom_stacks * amount
end

--Multipliers for overall spread.
function RaycastWeaponBase:conditional_accuracy_multiplier(movement_state)
	local mul = 1
	local pm = managers.player

	if self._can_desperado then
 		mul = mul * pm:get_property("desperado", 1)
 	end

	if movement_state == "steelsight" or movement_state == "moving_steelsight" then
		mul = mul * pm:upgrade_value("weapon", "steelsight_accuracy_inc", 1)
		local categories = self:categories()
		for i = 1, #categories do
			mul = mul * pm:upgrade_value(categories[i], "steelsight_accuracy_inc", 1)
		end
	end

	mul = mul * pm:temporary_upgrade_value("temporary", "silent_precision", 1)

	return mul
end

--Multiplier for movement penalty to spread.
function RaycastWeaponBase:moving_spread_penalty_reduction()
	local spread_multiplier = 1
	local categories = self:categories()
	for i = 1, #categories do
		spread_multiplier = spread_multiplier * managers.player:upgrade_value(categories[i], "move_spread_multiplier", 1)
	end
	return spread_multiplier
end

function RaycastWeaponBase:bloom_spread_penality_reduction()
	local spread_multiplier = 1
	local categories = self:categories()
	for i = 1, #categories do
		spread_multiplier = spread_multiplier * managers.player:upgrade_value(categories[i], "bloom_spread_multiplier", 1)
	end
	return spread_multiplier
end

--Return cached spread value.
function RaycastWeaponBase:_get_spread(user_unit)
	if self:gadget_overrides_weapon_functions() then
		return self:gadget_function_override("_get_spread", user_unit)
	end

	local spread = self._current_spread or self._spread
	return spread, spread
end

function RaycastWeaponBase:remove_ammo(percent)
	local total_ammo = self:get_ammo_total()
	local max_ammo = self:get_ammo_max()
	local ammo = math.max(math.floor(total_ammo - max_ammo * percent), 0)

	self:set_ammo_total(ammo)

	local ammo_in_clip = self:get_ammo_remaining_in_clip()

	if self:get_ammo_total() < ammo_in_clip then
		self:set_ammo_remaining_in_clip(ammo)
	end

	return total_ammo - ammo
end

function RaycastWeaponBase:shake_multiplier(multiplier_type)
	return 1
end

function RaycastWeaponBase:can_ignore_medic_heals(distance)
	if self._ignore_medics_distance and (not distance or distance < self._ignore_medics_distance) then
		return self._ignore_medics_distance
	end
end

function RaycastWeaponBase:overhealed_damage_mul(distance)
	if self._overheal_damage_dist and (not distance or distance < self._overheal_damage_dist) then
		return self._overheal_damage_mul
	end

	return 1
end

--Make mobility affect sprint-out speed.
--The minigun has a weirdly long animation that snaps really badly if you interrupt it. so increase the base timer but give it a bigger multiplier to mostly compensate.
function RaycastWeaponBase:exit_run_speed_multiplier()
	return tweak_data.weapon.stats.mobility[self:get_concealment()] * (self._name_id == "m134" and 2 or 1)
end

--Returns whether or not the gun is firing a burst.
--Always false for RaycastWeaponBase
function RaycastWeaponBase:burst_rounds_remaining()
	return false
end

--Minigun spin mechanics.
	function RaycastWeaponBase:start_shooting()
		if self:gadget_overrides_weapon_functions() then
			local gadget_func = self:gadget_function_override("start_shooting")

			if gadget_func then
				return gadget_func
			end
		end

		if self._spin_rounds then
			self:_start_spin()
		else
			self:_fire_sound()
		end

		self._next_fire_allowed = math.max(self._next_fire_allowed, self._unit:timer():time())
		self._shooting = true
		self._bullets_fired = 0
	end

	local trigger_held_original = RaycastWeaponBase.trigger_held
	function RaycastWeaponBase:trigger_held(...)
		if self._spin_rounds then
			local fired
			if self._next_fire_allowed <= self._unit:timer():time() then
				if self._spin_progress >= self._spin_rounds then
					fired = self:fire(...)
					if fired then
						self._next_fire_allowed = self._next_fire_allowed + (tweak_data.weapon[self._name_id].fire_mode_data and tweak_data.weapon[self._name_id].fire_mode_data.fire_rate or 0) / self:fire_rate_multiplier()
						self:_fire_sound()
					end
				end
			end
			return fired
		else
			return trigger_held_original(self, ...)
		end
	end

	function RaycastWeaponBase:_start_spin()
		if self._spin_progress == 0 or self._spin_dir == SPIN_DOWN then
			self._spin_dir = SPIN_UP
		end
	end

	function RaycastWeaponBase:_stop_spin()
		if self._spin_progress > 0 then
			self._spin_dir = SPIN_DOWN
		end
	end

	function RaycastWeaponBase:update_spin()
		local t = self._unit:timer():time()
		if (self._spin_dir == SPIN_UP and self._spin_rounds > self._spin_progress) or (self._spin_dir == SPIN_DOWN and self._spin_progress > 0) then
			if t >= self._next_spin_animation_t then
				self._spin_progress = self._spin_progress + self._spin_dir
			end
		end

		if self._spin_progress > 0 and t >= self._next_spin_animation_t then
			local spin_speed_mul = self:fire_rate_multiplier() * (self._spin_progress / self._spin_rounds)
			self:tweak_data_anim_play("fire", spin_speed_mul)
			self._next_spin_animation_t = t + (tweak_data.weapon[self._name_id].fire_mode_data and tweak_data.weapon[self._name_id].fire_mode_data.fire_rate or 0) / spin_speed_mul
		end
	end

	function RaycastWeaponBase:vulcan_enter_steelsight()
		self._in_steelsight = true
		self:_start_spin()
	end

	function RaycastWeaponBase:vulcan_exit_steelsight()
		self._in_steelsight = nil
		if not self._shooting then
			self:_stop_spin()
		end
	end

	function RaycastWeaponBase:has_spin()
		return self._spin_rounds ~= nil
	end

--BulletBase additions/changes.
	function DOTBulletBase:on_collision(col_ray, weapon_unit, user_unit, damage, blank)
		local result = DOTBulletBase.super.on_collision(self, col_ray, weapon_unit, user_unit, damage, blank)
		local hit_unit = col_ray.unit

		if hit_unit:character_damage() and hit_unit:character_damage().damage_dot and not hit_unit:character_damage():dead() then
			local dot_data = self:_dot_data_by_weapon(weapon_unit)
			dot_data.dot_damage = dot_data.dot_damage * managers.player:get_perk_damage_bonus(user_unit)
			result = self:start_dot_damage(col_ray, weapon_unit, dot_data)
		end

		return result
	end

	function ProjectilesPoisonBulletBase:on_collision(col_ray, weapon_unit, user_unit, damage, blank)
		local result = DOTBulletBase.super.on_collision(self, col_ray, weapon_unit, user_unit, damage, blank)
		local hit_unit = col_ray.unit
		if hit_unit:character_damage() and hit_unit:character_damage().damage_dot and not hit_unit:character_damage():dead() and alive(weapon_unit) then
			local dot_data = tweak_data.projectiles[weapon_unit:base()._projectile_entry].dot_data
			if not dot_data then
				return
			end

			local dot_type_data = tweak_data:get_dot_type_data(dot_data.type)
			if not dot_type_data then
				return
			end

			--Apply perk deck damage boost.
			local dot_damage = (dot_data.dot_damage or dot_type_data.dot_damage) * managers.player:get_perk_damage_bonus(user_unit)
			result = self:start_dot_damage(col_ray, nil, {
				dot_damage = dot_damage,
				dot_length = dot_data.dot_length or dot_type_data.dot_length
			})
		end

		return result
	end

	BleedBulletBase = BleedBulletBase or class(DOTBulletBase)
	BleedBulletBase.VARIANT = "bleed"
	ProjectilesBleedBulletBase = ProjectilesBleedBulletBase or class(BleedBulletBase)
	ProjectilesBleedBulletBase.NO_BULLET_INPACT_SOUND = false
	ProjectilesBleedBulletBase.on_collision = ProjectilesPoisonBulletBase.on_collision --The poison function fulfills the needs for bleed damage.
	function BleedBulletBase:start_dot_damage(col_ray, weapon_unit, dot_data, weapon_id)
		dot_data = dot_data or self.DOT_DATA
		local hurt_animation = not dot_data.hurt_animation_chance or math.rand(1) < dot_data.hurt_animation_chance

		--Add range limits for Flechette shotguns.
		local can_apply_dot = true
		if alive(weapon_unit) then
			weap_base = weapon_unit:base()
			if (col_ray.falloff_distance or col_ray.distance) > weap_base.near_falloff_distance then
				can_apply_dot = false
			end
		end

		if can_apply_dot == true then
			managers.dot:add_doted_enemy(col_ray.unit, TimerManager:game():time(), weapon_unit, dot_data.dot_length, dot_data.dot_damage, hurt_animation, self.VARIANT, weapon_id)
	 	end
	end

	--Adds a blood splat effect every time the bleed deals damage.
	function BleedBulletBase:give_damage_dot(col_ray, weapon_unit, attacker_unit, damage, hurt_animation, weapon_id)
		--Movement() can return nil, but can also itself be nil. Very fun!
		if alive(col_ray.unit) and col_ray.unit.movement and col_ray.unit:movement() and col_ray.unit:movement()._obj_spine then
			World:effect_manager():spawn({
				effect = Idstring("effects/payday2/particles/impacts/blood/blood_impact_a"),
				position = col_ray.unit:movement()._obj_spine:position(),
				normal = Vector3(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))
			})
		end
		
		return self.super.give_damage_dot(self, col_ray, weapon_unit, attacker_unit, damage, hurt_animation, weapon_id)
	end

	function InstantExplosiveBulletBase:on_collision_server(position, normal, damage, user_unit, weapon_unit, owner_peer_id, owner_selection_index)
		local slot_mask = managers.slot:get_mask("explosion_targets")

		managers.explosion:play_sound_and_effects(position, normal, self.RANGE, self.EFFECT_PARAMS)

		--We need to hit the local player and pass in the user unit to handle friendly fire.
		managers.explosion:give_local_player_dmg(position, self.RANGE, damage * self.PLAYER_DMG_MUL, user_unit)
		local hit_units, splinters, results = managers.explosion:detect_and_give_dmg({
			hit_pos = position,
			range = self.RANGE,
			collision_slotmask = slot_mask,
			curve_pow = self.CURVE_POW,
			damage = damage,
			player_damage = damage * self.PLAYER_DMG_MUL,
			ignore_unit = weapon_unit,
			user = user_unit,
			owner = weapon_unit
		})
		local network_damage = math.ceil(damage * 163.84)

		managers.network:session():send_to_peers_synched("sync_explode_bullet", position, normal, math.min(16384, network_damage), owner_peer_id)

		if managers.network:session():local_peer():id() == owner_peer_id then
			local enemies_hit = (results.count_gangsters or 0) + (results.count_cops or 0)
			local enemies_killed = (results.count_gangster_kills or 0) + (results.count_cop_kills or 0)

			managers.statistics:shot_fired({
				hit = false,
				weapon_unit = weapon_unit
			})

			for i = 1, enemies_hit do
				managers.statistics:shot_fired({
					skip_bullet_count = true,
					hit = true,
					weapon_unit = weapon_unit
				})
			end

			local weapon_pass, weapon_type_pass, count_pass, all_pass = nil

			for achievement, achievement_data in pairs(tweak_data.achievement.explosion_achievements) do
				weapon_pass = not achievement_data.weapon or true
				weapon_type_pass = not achievement_data.weapon_type or weapon_unit:base() and weapon_unit:base().weapon_tweak_data and weapon_unit:base():is_category(achievement_data.weapon_type)
				count_pass = not achievement_data.count or achievement_data.count <= (achievement_data.kill and enemies_killed or enemies_hit)
				all_pass = weapon_pass and weapon_type_pass and count_pass

				if all_pass and achievement_data.award then
					managers.achievment:award(achievement_data.award)
				end
			end
		else
			local peer = managers.network:session():peer(owner_peer_id)
			local SYNCH_MIN = 0
			local SYNCH_MAX = 31
			local count_cops = math.clamp(results.count_cops, SYNCH_MIN, SYNCH_MAX)
			local count_gangsters = math.clamp(results.count_gangsters, SYNCH_MIN, SYNCH_MAX)
			local count_civilians = math.clamp(results.count_civilians, SYNCH_MIN, SYNCH_MAX)
			local count_cop_kills = math.clamp(results.count_cop_kills, SYNCH_MIN, SYNCH_MAX)
			local count_gangster_kills = math.clamp(results.count_gangster_kills, SYNCH_MIN, SYNCH_MAX)
			local count_civilian_kills = math.clamp(results.count_civilian_kills, SYNCH_MIN, SYNCH_MAX)

			managers.network:session():send_to_peer_synched(peer, "sync_explosion_results", count_cops, count_gangsters, count_civilians, count_cop_kills, count_gangster_kills, count_civilian_kills, owner_selection_index)
		end
	end

	--Passes in the user unit to catch friendly fire 
	function InstantExplosiveBulletBase:on_collision_client(position, normal, damage, user_unit)
		managers.explosion:give_local_player_dmg(position, self.RANGE, damage * self.PLAYER_DMG_MUL, user_unit)
		managers.explosion:explode_on_client(position, normal, user_unit, damage, self.RANGE, self.CURVE_POW, self.EFFECT_PARAMS)
	end

	--Fire no longer memes on shields.
	function FlameBulletBase:bullet_slotmask()
		return managers.slot:get_mask("bullet_impact_targets")
	end	

	--Similar to vanilla, effectively a copy/paste of the InstantBulletBase:on_collision function but with 2 differences.
	--1. Blood impact effects are removed.
	--2. Use give_fire_damage instead of give_impact_damage.
	--DragonsBreathBulletBase is no longer used. DB rounds use FlameBulletBase.
	function FlameBulletBase:on_collision(col_ray, weapon_unit, user_unit, damage, blank)
		blank = Network:is_client() and not blank and user_unit ~= managers.player:player_unit()

		local hit_unit = col_ray.unit
		local hit_char_damage = hit_unit:character_damage()
		local is_shield = hit_unit:in_slot(managers.slot:get_mask("enemy_shield_check")) and alive(hit_unit:parent())
		local weapon_base = alive(weapon_unit) and weapon_unit:base()

		--Add shield knocking, since we no longer pierce shields.
		if alive(weapon_unit) and not blank and is_shield and weapon_base._shield_knock then
			local enemy_unit = hit_unit:parent()

			if enemy_unit:character_damage() and enemy_unit:character_damage().dead and not enemy_unit:character_damage():dead()
			   and enemy_unit:base():char_tweak() and not enemy_unit:character_damage():is_immune_to_shield_knockback()
			   and tweak_data.upgrades.shield_knock_chance > math.random() then
				shield_knock_data.col_ray = col_ray
				enemy_unit:character_damage():_call_listeners(shield_knock_data)
			end
		end

		if col_ray.ricochet then --Civilian hits treat Ricochets as blanks as a QOL feature.
			local unit_type = alive(hit_unit) and hit_unit.base and hit_unit:base() and hit_unit:base()._tweak_table
			if unit_type and CopDamage.is_civilian(unit_type) then
				blank = true
			end
		end

		if hit_unit:damage() and managers.network:session() and col_ray.body:extension() and col_ray.body:extension().damage then
			local damage_body_extension = true
			local character_unit = nil

			if hit_char_damage then
				character_unit = hit_unit
			elseif is_shield and hit_unit:parent():character_damage() then
				character_unit = hit_unit:parent()
			end

			--do a friendly fire check if the unit hit is a character or a character's shield before damaging the body extension that was hit
			if character_unit and character_unit:character_damage().is_friendly_fire and character_unit:character_damage():is_friendly_fire(user_unit) then
				damage_body_extension = false
			end

			if damage_body_extension then
				local sync_damage = not blank and hit_unit:id() ~= -1
				local network_damage = math.ceil(damage * 163.84)
				damage = network_damage / 163.84

				if sync_damage then
					local normal_vec_yaw, normal_vec_pitch = self._get_vector_sync_yaw_pitch(col_ray.normal, 128, 64)
					local dir_vec_yaw, dir_vec_pitch = self._get_vector_sync_yaw_pitch(col_ray.ray, 128, 64)

					managers.network:session():send_to_peers_synched("sync_body_damage_bullet", col_ray.unit:id() ~= -1 and col_ray.body or nil, user_unit:id() ~= -1 and user_unit or nil, normal_vec_yaw, normal_vec_pitch, col_ray.position, dir_vec_yaw, dir_vec_pitch, math.min(16384, network_damage))
				end

				local local_damage = not blank or hit_unit:id() == -1

				if local_damage then
					col_ray.body:extension().damage:damage_bullet(user_unit, col_ray.normal, col_ray.position, col_ray.ray, 1)
					col_ray.body:extension().damage:damage_damage(user_unit, col_ray.normal, col_ray.position, col_ray.ray, damage)

					if alive(weapon_unit) and weapon_base.categories and weapon_base:categories() then
						local categories = weapon_base:categories()
						for i = 1, #categories do
							col_ray.body:extension().damage:damage_bullet_type(categories[i], user_unit, col_ray.normal, col_ray.position, col_ray.ray, 1)
						end
					end
				end
			end
		end

		local result = nil
		local push_multiplier = nil

		if alive(weapon_unit) and hit_char_damage and hit_char_damage.damage_bullet then
			local was_alive = not hit_char_damage:dead()

			if not blank then
				result = self:give_fire_damage(col_ray, weapon_unit, user_unit, damage)
			end

			push_multiplier = self:_get_character_push_multiplier(weapon_unit, was_alive and hit_char_damage:dead())
		end

		managers.game_play_central:physics_push(col_ray, push_multiplier)

		return result
	end

	function FlameBulletBase:give_fire_damage(col_ray, weapon_unit, user_unit, damage, armor_piercing)
		local fire_dot_data = nil

		if weapon_unit.base and weapon_unit:base()._ammo_data and weapon_unit:base()._ammo_data.bullet_class == "FlameBulletBase" then
			if col_ray.count then --If multiple rays hit, then multiply the chance by the number of rays. Requires a clone to avoid mutating global state.
				fire_dot_data = clone(weapon_unit:base()._ammo_data.fire_dot_data)
				fire_dot_data.dot_trigger_chance = fire_dot_data.dot_trigger_chance * col_ray.count
			else
				fire_dot_data = clone(weapon_unit:base()._ammo_data.fire_dot_data)
			end
		elseif weapon_unit.base and weapon_unit:base()._name_id then
			local weapon_name_id = weapon_unit:base()._name_id

			if tweak_data.weapon[weapon_name_id] and tweak_data.weapon[weapon_name_id].fire_dot_data then
				fire_dot_data = clone(tweak_data.weapon[weapon_name_id].fire_dot_data)
			end
		end

		if fire_dot_data then
			fire_dot_data.dot_damage = fire_dot_data.dot_damage * managers.player:get_perk_damage_bonus(user_unit)
		end

		local action_data = {
			variant = "fire",
			damage = damage,
			weapon_unit = weapon_unit,
			attacker_unit = user_unit,
			col_ray = col_ray,
			armor_piercing = armor_piercing,
			fire_dot_data = fire_dot_data
		}
		local defense_data = col_ray.unit:character_damage():damage_fire(action_data)

		return defense_data
	end