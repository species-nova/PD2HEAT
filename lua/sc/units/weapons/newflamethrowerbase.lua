function NewFlamethrowerBase:setup_default()
	self:kill_effects()

	local unit = self._unit
	local nozzle_obj = unit:get_object(Idstring("fire"))
	self._nozzle_obj = nozzle_obj
	local name_id = self._name_id
	local weap_tweak = tweak_data.weapon[name_id]
	local flame_effect_range = weap_tweak.flame_max_range
	self._range = flame_effect_range
	self._flame_max_range = flame_effect_range
	self._flame_radius = weap_tweak.flame_radius or 40
	local flame_effect = weap_tweak.flame_effect

	if flame_effect then
		self._last_effect_t = -100
		self._flame_effect_collection = {}
		self._flame_effect_ids = Idstring(flame_effect)
		self._flame_max_range_sq = flame_effect_range * flame_effect_range
		local effect_duration = weap_tweak.single_flame_effect_duration
		self._single_flame_effect_duration = effect_duration
		self._single_flame_effect_cooldown = effect_duration * 0.1
	else
		self._last_effect_t = nil
		self._flame_effect_collection = nil
		self._flame_effect_ids = nil
		self._flame_max_range_sq = nil
		self._single_flame_effect_duration = nil
		self._single_flame_effect_cooldown = nil

		print("[NewFlamethrowerBase:setup_default] No flame effect defined for tweak data ID ", name_id)
	end

	local effect_manager = self._effect_manager
	local pilot_effect = weap_tweak.pilot_effect

	if pilot_effect then
		local parent_obj = nil
		local parent_name = weap_tweak.pilot_parent_name

		if parent_name then
			parent_obj = unit:get_object(Idstring(parent_name))

			if not parent_obj then
				print("[NewFlamethrowerBase:setup_default] No pilot parent object found with name ", parent_name, "in unit ", unit)
			end
		end

		parent_obj = parent_obj or nozzle_obj
		local force_synch = self.is_npc and not self:is_npc()
		local pilot_offset = weap_tweak.pilot_offset or nil
		local normal = weap_tweak.pilot_normal or Vector3(0, 0, 1)
		local pilot_effect_id = effect_manager:spawn({
			effect = Idstring(pilot_effect),
			parent = parent_obj,
			force_synch = force_synch,
			position = pilot_offset,
			normal = normal
		})
		self._pilot_effect = pilot_effect_id
		local state = (not self._enabled or not self._visible) and true or false

		effect_manager:set_hidden(pilot_effect_id, state)
		effect_manager:set_frozen(pilot_effect_id, state)
	else
		self._pilot_effect = nil
	end

	local nozzle_effect = weap_tweak.nozzle_effect

	if nozzle_effect then
		self._last_fire_t = -100
		self._nozzle_expire_t = weap_tweak.nozzle_expire_time or 0.2
		local force_synch = self.is_npc and not self:is_npc()
		local normal = weap_tweak.nozzle_normal or Vector3(0, 1, 0)
		local nozzle_effect_id = effect_manager:spawn({
			effect = Idstring(nozzle_effect),
			parent = nozzle_obj,
			force_synch = force_synch,
			normal = normal
		})
		self._nozzle_effect = nozzle_effect_id

		effect_manager:set_hidden(nozzle_effect_id, true)
		effect_manager:set_frozen(nozzle_effect_id, true)

		self._showing_nozzle_effect = false
	else
		self._last_fire_t = nil
		self._nozzle_expire_t = nil
		self._nozzle_effect = nil
		self._showing_nozzle_effect = nil
	end

	local bullet_class = weap_tweak.bullet_class

	if bullet_class ~= nil then
		bullet_class = CoreSerialize.string_to_classtable(bullet_class)

		if not bullet_class then
			print("[NewFlamethrowerBase:setup_default] Unexisting class for bullet_class string ", weap_tweak.bullet_class, "defined for tweak data ID ", name_id)

			bullet_class = FlameBulletBase
		end
	else
		bullet_class = FlameBulletBase
	end

	self._bullet_class = bullet_class
	self._bullet_slotmask = bullet_class:bullet_slotmask()
	
	if Global.game_settings and Global.game_settings.one_down then
		self._bullet_slotmask = self._bullet_slotmask + 3
	else
		self._bullet_slotmask = managers.mutators:modify_value("RaycastWeaponBase:setup:weapon_slot_mask", self._bullet_slotmask)
		self._bullet_slotmask = managers.modifiers:modify_value("RaycastWeaponBase:setup:weapon_slot_mask", self._bullet_slotmask)
	end
	
	self._blank_slotmask = bullet_class:blank_slotmask()
end

function NewFlamethrowerBase:run_and_shoot_allowed()
	local allowed = NewFlamethrowerBase.super.run_and_shoot_allowed(self)
	return allowed or managers.player:has_category_upgrade("shotgun", "hip_run_and_shoot")
end

function NewFlamethrowerBase:_update_stats_values()
	self._bullet_class = nil

	NewFlamethrowerBase.super._update_stats_values(self)
	self:setup_default()

	local ammo_data = self._ammo_data

	if ammo_data then
		local rays = ammo_data.rays

		if rays ~= nil then
			self._rays = rays
		end

		local bullet_class = ammo_data.bullet_class

		if bullet_class ~= nil then
			bullet_class = CoreSerialize.string_to_classtable(bullet_class)

			if bullet_class then
				self._bullet_class = bullet_class
				self._bullet_slotmask = bullet_class:bullet_slotmask()
				self._blank_slotmask = bullet_class:blank_slotmask()
			else
				print("[NewFlamethrowerBase:_update_stats_values] Unexisting class for bullet_class string ", ammo_data.bullet_class, "defined in ammo_data for tweak data ID ", self._name_id)
			end
		end
	end
	
	--Set range multipliers.
	self._damage_near_mul = tweak_data.weapon.stat_info.damage_falloff.near_mul
	self._damage_far_mul = tweak_data.weapon.stat_info.damage_falloff.far_mul	
	local custom_stats = managers.weapon_factory:get_custom_stats_from_weapon(self._factory_id, self._blueprint)
	for part_id, stats in pairs(custom_stats) do
		if stats.damage_near_mul then
			self._damage_near_mul = self._damage_near_mul * stats.damage_near_mul
		end
		if stats.damage_far_mul then
			self._damage_far_mul = self._damage_far_mul * stats.damage_far_mul
		end

		if stats.use_rare_dot then
			self._ammo_data = {
				bullet_class = "FlameBulletBase",
				fire_dot_data = {
					dot_damage = 0.8,
					dot_trigger_chance = 60,
					dot_length = 6.1,
					dot_tick_period = 0.5
				}
			}
		end

		--Worst way to eat a steak, seriously what the fuck's wrong with you
		if stats.use_well_done_dot then
			self._ammo_data = {
				bullet_class = "FlameBulletBase",
				fire_dot_data = {
					dot_damage = 3.2,
					dot_trigger_chance = 60,
					dot_length = 1.6,
					dot_tick_period = 0.5
				}					
			}
		end
	end

	--Effect range, set to longest possible falloff distance.
	self._range = tweak_data.weapon.stat_info.damage_falloff.max * self._damage_far_mul
	self._flame_max_range = self._range

	if self._flame_effect_ids then
		self._flame_max_range_sq = flame_effect_range * flame_effect_range
	end
end

function NewFlamethrowerBase:_update_stats_values()
	NewFlamethrowerBase.super._update_stats_values(self)

	--Set range multipliers.
	self._damage_near_mul = tweak_data.weapon.stat_info.damage_falloff.near_mul
	self._damage_far_mul = tweak_data.weapon.stat_info.damage_falloff.far_mul	
	local custom_stats = managers.weapon_factory:get_custom_stats_from_weapon(self._factory_id, self._blueprint)
	for part_id, stats in pairs(custom_stats) do
		if stats.damage_near_mul then
			self._damage_near_mul = self._damage_near_mul * stats.damage_near_mul
		end
		if stats.damage_far_mul then
			self._damage_far_mul = self._damage_far_mul * stats.damage_far_mul
		end

		if stats.use_rare_dot then
			self._ammo_data = {
				bullet_class = "FlameBulletBase",
				fire_dot_data = {
					dot_damage = 0.8,
					dot_trigger_chance = 60,
					dot_length = 6.1,
					dot_tick_period = 0.5
				}
			}
		end

		--Worst way to eat a steak, seriously what the fuck's wrong with you
		if stats.use_well_done_dot then
			self._ammo_data = {
				bullet_class = "FlameBulletBase",
				fire_dot_data = {
					dot_damage = 3.2,
					dot_trigger_chance = 60,
					dot_length = 1.6,
					dot_tick_period = 0.5
				}					
			}
		end
	end

	--Effect range, set to longest possible falloff distance.
	self._range = tweak_data.weapon.stat_info.damage_falloff.max * self._damage_far_mul
end

function NewFlamethrowerBase:get_damage_falloff(damage, col_ray, user_unit)
	--Initialize base info.
	local falloff_info = tweak_data.weapon.stat_info.damage_falloff
	local distance = col_ray.distance or mvector3.distance(col_ray.unit:position(), user_unit:position())
	local current_state = user_unit:movement()._current_state
	local base_falloff = falloff_info.base
	local pm = managers.player

	if current_state then
		--Get bonus from accuracy.
		local acc_bonus = falloff_info.acc_bonus * (self._current_stats_indices.spread + managers.blackmarket:accuracy_index_addend(self._name_id, self:categories(), self._silencer, current_state, self:fire_mode(), self._blueprint) - 1)
		
		--Get bonus from stability.
		local stab_bonus = falloff_info.stab_bonus * 25
		if current_state._moving then
			stab_bonus = falloff_info.stab_bonus * (self._current_stats_indices.recoil + managers.blackmarket:stability_index_addend(self:categories(), self._silencer) - 1)
		end

		--Apply acc/stab bonuses.
		base_falloff = base_falloff + stab_bonus + acc_bonus

		--Get ADS multiplier.
		if current_state:in_steelsight() then
			for _, category in ipairs(self:categories()) do
				base_falloff = base_falloff * pm:upgrade_value(category, "steelsight_range_inc", 1)
			end
		end

		if self._rays and self._rays > 1 then
			base_falloff = base_falloff * falloff_info.shotgun_penalty
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
	local falloff_near = base_falloff * self._damage_near_mul
	local falloff_far = base_falloff * self._damage_far_mul

	--Cache falloff values for usage in hitmarkers.
	self.near_falloff_distance = falloff_near
	self.far_falloff_distance = falloff_far
	self._range = falloff_far --Likely going to lead to occasional jank, but oh well.

	--Compute final damage.
	return math.max((1 - math.min(1, math.max(0, distance - falloff_near) / (falloff_far))) * damage, 0.05 * damage)
end