old_init = WeaponUnderbarrelLauncher.init
function WeaponUnderbarrelLauncher:init(unit)
	old_init(self, unit)
	--Initialize variables relevant to gadget_override functions.
	self._recoil = tweak_data.weapon.stats.recoil[self._tweak_data.stats.recoil]
	self._spread = tweak_data.weapon.stats.spread[self._tweak_data.stats.spread]
	self._reload = tweak_data.weapon.stats.reload[self._tweak_data.stats.reload]
	self._concealment = self._tweak_data.stats.concealment
	self._spread_moving = tweak_data.weapon.stats.spread_moving[self._concealment] or 0
	self._spread_bloom = tweak_data.weapon.stat_info.bloom_spread[self._tweak_data.stats.recoil] or 0
	self._bloom_stacks = 0
	self._current_spread = 0
	self._next_fire_allowed = 0
	RaycastWeaponBase.heat_init(self)
end

--Need to support gadget_override functions and the functions they call to make underbarrels match up with 'real' guns mechanically.
--(At least for skills that can actually effect them)
--Also, reminder that underbarrels are incredibly cursed.
WeaponUnderbarrelLauncher.update_spread = RaycastWeaponBase.update_spread
WeaponUnderbarrelLauncher._get_spread = RaycastWeaponBase._get_spread
WeaponUnderbarrelLauncher.add_bloom_stack = RaycastWeaponBase.add_bloom_stack
WeaponUnderbarrelLauncher.get_accuracy_addend = RaycastWeaponBase.get_accuracy_addend
WeaponUnderbarrelLauncher.moving_spread_penalty_reduction = RaycastWeaponBase.moving_spread_penalty_reduction
WeaponUnderbarrelLauncher.bloom_spread_penality_reduction = RaycastWeaponBase.bloom_spread_penality_reduction
WeaponUnderbarrelLauncher.conditional_accuracy_multiplier = RaycastWeaponBase.conditional_accuracy_multiplier
WeaponUnderbarrelLauncher.is_category = RaycastWeaponBase.is_category
WeaponUnderbarrelLauncher.reload_speed_multiplier = RaycastWeaponBase.reload_speed_multiplier
WeaponUnderbarrelLauncher.reload_speed_stat = RaycastWeaponBase.reload_speed_stat
WeaponUnderbarrelLauncher.invalidate_current_reload_speed_multiplier = RaycastWeaponBase.invalidate_current_reload_speed_multiplier
WeaponUnderbarrelLauncher.update_next_shooting_time = RaycastWeaponBase.update_next_shooting_time
WeaponUnderbarrelLauncher.fire_rate_multiplier = NewRaycastWeaponBase.fire_rate_multiplier
WeaponUnderbarrelLauncher.burst_rounds_remaining = RaycastWeaponBase.burst_rounds_remaining

function WeaponUnderbarrelLauncher:weapon_tweak_data()
	return self._tweak_data
end

function WeaponUnderbarrelLauncher:categories()
	return self._tweak_data.categories
end

function WeaponUnderbarrelLauncher:holds_single_round()
	return self._ammo:get_ammo_max_per_clip() == 1
end

function WeaponUnderbarrelLauncher:gadget_overrides_weapon_functions()
	return false
end

local mvec_spread_direction = Vector3()
function WeaponUnderbarrelLauncher:_fire_raycast(weapon_base, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, shoot_through_data)
	local projectile_type = self._launcher_projectile

	if weapon_base:weapon_tweak_data() and weapon_base:weapon_tweak_data().projectile_types then
		projectile_type = weapon_base:weapon_tweak_data().projectile_types[projectile_type] or projectile_type
	end

	local projectile_type_index = tweak_data.blackmarket:get_index_from_projectile_id(projectile_type)

	self._ammo_data = {
		launcher_grenade = projectile_type
	}

	--Use more sane spread calcs.
	local unit = nil
	local spread_x, spread_y = self:_get_spread(user_unit)
	local right = direction:cross(Vector3(0, 0, 1)):normalized()
	local up = direction:cross(right):normalized()
	local r = math.sqrt(math.random())
	local theta = math.random() * 360
	local ax = math.tan(r * spread_x * (spread_mul or 1)) * math.cos(theta)
	local ay = math.tan(r * spread_y * (spread_mul or 1)) * math.sin(theta) * -1

	mvector3.set(mvec_spread_direction, direction)
	mvector3.add(mvec_spread_direction, right * ax)
	mvector3.add(mvec_spread_direction, up * ay)

	self:_adjust_throw_z(mvec_spread_direction)

	mvec_spread_direction = mvec_spread_direction * 1
	local spawn_offset = self:_get_spawn_offset()
	self._dmg_mul = dmg_mul or 1

	if not self._client_authoritative then
		if Network:is_client() then
			managers.network:session():send_to_host("request_throw_projectile", projectile_type_index, from_pos, mvec_spread_direction)
		else
			unit = ProjectileBase.throw_projectile(projectile_type, from_pos, mvec_spread_direction, managers.network:session():local_peer():id())
		end
	else
		unit = ProjectileBase.throw_projectile(projectile_type, from_pos, mvec_spread_direction, managers.network:session():local_peer():id())
	end

	managers.statistics:shot_fired({
		hit = false,
		weapon_unit = weapon_base._unit
	})
	self:on_shot()
	self:update_next_shooting_time()
	weapon_base:check_bullet_objects()

	return {}
end