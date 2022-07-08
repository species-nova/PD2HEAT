--Enable friendly fire on projobs. Cache original flame_max_range.
local orig_setup_default = NewFlamethrowerBase.setup_default
function NewFlamethrowerBase:setup_default()
	orig_setup_default(self)
	self._bullet_slotmask = self._bullet_class:bullet_slotmask()
	if Global.game_settings and Global.game_settings.one_down then
		self._bullet_slotmask = self._bullet_slotmask + 3 
	else
		self._bullet_slotmask = managers.mutators:modify_value("RaycastWeaponBase:setup:weapon_slot_mask", self._bullet_slotmask)
		self._bullet_slotmask = managers.modifiers:modify_value("RaycastWeaponBase:setup:weapon_slot_mask", self._bullet_slotmask)
	end
	self._base_flame_max_range = self._flame_max_range
end

--Allow tank attachments to tweak range and DOT.
local orig_update_stats_values = NewFlamethrowerBase._update_stats_values
function NewFlamethrowerBase:_update_stats_values()
	orig_update_stats_values(self)

	local custom_stats = managers.weapon_factory:get_custom_stats_from_weapon(self._factory_id, self._blueprint)
	for part_id, stats in pairs(custom_stats) do
		if stats.fire_dot_data then
			self._ammo_data.fire_dot_data = stats.fire_dot_data
		end

		if stats.damage_near_mul then
			self._tank_flame_range_mul = stats.damage_near_mul
		end
	end
end

function NewFlamethrowerBase:update_spread(current_state, t, dt)
	--No need for this.
end

function NewFlamethrowerBase:_get_spread(user_unit)
	return 5.5, 5.5
end

function NewFlamethrowerBase:_compute_falloff_distance(user_unit)
	--Initialize base info.
	local falloff_info = tweak_data.weapon.stat_info.damage_falloff
	local current_state = user_unit:movement()._current_state
	local base_falloff = self._base_flame_max_range
	local pm = managers.player

	if current_state then
		--Get bonus from accuracy.
		local acc_bonus = falloff_info.acc_bonus * managers.blackmarket:accuracy_index_addend(self._name_id, self:categories(), self._silencer, current_state, self:fire_mode(), self._blueprint)
	
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

	--No need for baseline range mul stuff, can set range directly on flamethrowers.

	if self._tank_flame_range_mul then
		base_falloff = self._tank_flame_range_mul * base_falloff
	end

	--Cache falloff values for usage in hitmarkers and other range-related calculations.
	self._flame_max_range = base_falloff
	self._flame_max_range_sq = base_falloff * base_falloff
end

local mvec3_set = mvector3.set
local mvec3_add = mvector3.add
local mvec3_mul = mvector3.multiply
local mvec3_dir = mvector3.direction
local mvec_to = Vector3()
local mvec_direction = Vector3()
local mvec_spread_direction = Vector3()
function NewFlamethrowerBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul)
	local result = {}
	local damage = self._damage * dmg_mul --Just use the provided dmg_mul.
	self:_compute_falloff_distance(user_unit)
	local damage_range = self._flame_max_range --This needs to be defined on flamethowers. No fallbacksies.

	--Use new suppression method that's not coupled to autoaim.
	if self._suppression then
		local suppression_cone_radius = damage_range * math.tan(tweak_data.weapon.stat_info.suppression_angle)
		local suppressed_enemies = self._unit:find_units("cone", from_pos, direction, suppression_cone_radius, managers.slot:get_mask("player_autoaim"))
		if suppressed_enemies then
			for _, enemy in pairs(suppressed_enemies) do
				if not enemy:movement():cool() then
					enemy:character_damage():build_suppression(self._suppression, self._panic_suppression_chance)
				end
			end
		end
	end

	mvec3_set(mvec_to, direction)
	mvec3_mul(mvec_to, damage_range)
	mvec3_add(mvec_to, from_pos)

	--Use a sphere cast to make it a bit more clear when stuff is blocking the flames.
	local col_ray = World:raycast("ray", mvector3.copy(from_pos), mvec_to, "sphere_cast_radius", self._flame_radius * 0.75, "slot_mask", self._bullet_slotmask, "ignore_unit", self._setup.ignore_units)
	if col_ray then
		local col_dis = col_ray.distance

		if col_dis < damage_range then
			damage_range = col_dis
		end

		mvec3_set(mvec_to, direction)
		mvec3_mul(mvec_to, damage_range)
		mvec3_add(mvec_to, from_pos)
	end

	self:_spawn_flame_effect(mvec_to, direction)
	local hit_bodies = World:find_bodies("intersect", "capsule", from_pos, mvec_to, self._flame_radius, self._bullet_slotmask)
	local weap_unit = self._unit
	local hit_enemies = 0
	local hit_body, hit_unit, hit_u_key = nil
	local units_hit = {}
	local ignore_units = self._setup.ignore_units
	local t_contains = table.contains
	local obstruction_mask = managers.slot:get_mask("world_geometry", "enemy_shield_check")

	local bullet_class = self._bullet_class
	for i = 1, #hit_bodies do
		hit_body = hit_bodies[i]
		hit_unit = hit_body:unit()

		if not t_contains(ignore_units, hit_unit) then
			hit_u_key = hit_unit:key()

			if not units_hit[hit_u_key] then
				local hit_pos = hit_body:position()
				--Do an extra LOS check to ensure that enemies can't get hit around corners or through shields.
				local obstructed = hit_unit:raycast("ray", from_pos, hit_pos, "slot_mask", obstruction_mask, "report")
				if not obstructed then
					units_hit[hit_u_key] = true
					--Just process the hit immediately, instead of looping through everything a second time.
					local fake_ray_dir = hit_body:center_of_mass()
					fake_ray_dis = mvec3_dir(fake_ray_dir, from_pos, fake_ray_dir)
					local fake_ray = {
						body = hit_body,
						unit = hit_body:unit(),
						ray = fake_ray_dir,
						normal = fake_ray_dir,
						distance = fake_ray_dis,
						position = hit_pos,
						hit_position = hit_pos
					}

					local result = bullet_class:on_collision(fake_ray, weap_unit, user_unit, damage)
					if result then
						hit_enemies = hit_enemies + 1
					end
				end
			end
		end
	end

	if self._alert_events then
		result.rays = {{position = from_pos}}
	end

	if hit_enemies > 0 then
		result.hit_enemy = true

		managers.statistics:shot_fired({
			hit = true,
			hit_count = hit_enemies,
			weapon_unit = weap_unit
		})
	else
		result.hit_enemy = false

		managers.statistics:shot_fired({
			hit = false,
			weapon_unit = weap_unit
		})
	end

	return result
end