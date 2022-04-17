local old_update_stats_values = ShotgunBase._update_stats_values

function ShotgunBase:_update_stats_values()
	ShotgunBase.super._update_stats_values(self)
	self:setup_default()

	--Set range multipliers.
	self._damage_near_mul = tweak_data.weapon.stat_info.damage_falloff.near_mul
	self._damage_far_mul = tweak_data.weapon.stat_info.damage_falloff.far_mul
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
	end
	local custom_stats = managers.weapon_factory:get_custom_stats_from_weapon(self._factory_id, self._blueprint)
	for part_id, stats in pairs(custom_stats) do
		if stats.damage_near_mul then
			self._damage_near_mul = self._damage_near_mul * stats.damage_near_mul
		end
		if stats.damage_far_mul then
			self._damage_far_mul = self._damage_far_mul * stats.damage_far_mul
		end
	end

	self._range = tweak_data.weapon.stat_info.damage_falloff.max * self._damage_far_mul
end

function ShotgunBase:fire_rate_multiplier()
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

local mvec_temp = Vector3()
local mvec_to = Vector3()
local mvec_direction = Vector3()
local mvec_spread_direction = Vector3()

ShotgunBase._fire_raycast = RaycastWeaponBase._fire_raycast --Baseline fire_raycast supports multiple rays.

--Update achievement checks to also use shotgun specific ones.
function ShotgunBase:_check_kill_achievements(hit, cop_kill_count, cop_headshot_count)
	ShotgunBase.super._check_kill_achievements(self, hit, cop_kill_count, cop_headshot_count)
	
	for key, data in pairs(tweak_data.achievement.shotgun_single_shot_kills) do
		if hit.headshot and data.count <= cop_headshot_count or data.count <= cop_kill_count then
			local should_award = true
			if data.blueprint then
				local missing_parts = false
				for _, part_or_parts in ipairs(data.blueprint) do
					if type(part_or_parts) == "string" then
						if not table.contains(self._blueprint or {}, part_or_parts) then
							missing_parts = true

							break
						end
					else
						local found_part = false
						for _, part in ipairs(part_or_parts) do
							if table.contains(self._blueprint or {}, part) then
								found_part = true

								break
							end
						end

						if not found_part then
							missing_parts = true
							break
						end
					end
				end

				if missing_parts then
					should_award = false
				end
			end

			if should_award then
				managers.achievment:_award_achievement(data, key)
			end
		end
	end

	return result
end