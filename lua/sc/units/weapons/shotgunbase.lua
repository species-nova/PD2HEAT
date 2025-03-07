function ShotgunBase:_update_stats_values(...)
	ShotgunBase.super._update_stats_values(self, ...)
	--Range multipliers are now in NewRaycastWeaponBase
	if tweak_data.weapon[self._name_id].use_shotgun_reload == nil then
		self._use_shotgun_reload = self._use_shotgun_reload or self._use_shotgun_reload == nil
	else
		self._use_shotgun_reload = tweak_data.weapon[self._name_id].use_shotgun_reload
	end
end


ShotgunBase.fire_rate_multiplier = NewRaycastWeaponBase.fire_rate_multiplier
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

--Let taser slugs also do damage things.
function InstantElectricBulletBase:give_impact_damage(col_ray, weapon_unit, user_unit, damage, armor_piercing)
	local hit_unit = col_ray.unit
	local action_data = {
		damage = 0,
		weapon_unit = weapon_unit,
		attacker_unit = user_unit,
		col_ray = col_ray,
		armor_piercing = armor_piercing,
		attacker_unit = user_unit,
		attack_dir = col_ray.ray,
		variant = weapon_unit:base() and weapon_unit:base().get_tase_strength and weapon_unit:base():get_tase_strength() or "light"
	}

	--The result of this isn't very important compared with the result of damage_bullet.
	if hit_unit and hit_unit:character_damage().damage_tase then
		hit_unit:character_damage():damage_tase(action_data)
	end

	return InstantElectricBulletBase.super.give_impact_damage(self, col_ray, weapon_unit, user_unit, damage, armor_piercing)
end
