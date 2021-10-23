local mvec3_set = mvector3.set
local mvec3_add = mvector3.add
local mvec3_dot = mvector3.dot
local mvec3_sub = mvector3.subtract
local mvec3_mul = mvector3.multiply
local mvec3_norm = mvector3.normalize
local mvec3_dis = mvector3.distance
local mvec3_dir = mvector3.direction
local mvec3_set_l = mvector3.set_length
local mvec3_len = mvector3.length
local mvec3_cpy = mvector3.copy
local mvec3_add_scaled = mvector3.add_scaled

local mvec_from = Vector3()
local mvec_to = Vector3()
local mvec_spread_direction = Vector3()
local tmp_vec1 = Vector3()
local tmp_vec2 = Vector3()

local tmp_rot1 = Rotation()
local pairs_g = pairs

local table_insert = table.insert
local table_contains = table.contains

local math_ceil = math.ceil
local math_random = math.random
local math_clamp = math.clamp
local math_min = math.min
local math_cos = math.cos
local math_sin = math.sin
local math_rad = math.rad
local math_lerp = math.lerp
local math_floor = math.floor

local t_cont = table.contains

local next_g = next
local alive_g = alive
local world_g = World

local init_original = RaycastWeaponBase.init
local setup_original = RaycastWeaponBase.setup

function RaycastWeaponBase:init(...)
	init_original(self, ...)
	
	self._shoot_through_data = {
		kills = 0,
		from = Vector3()
	}
	
	--self._bullet_slotmask = self._bullet_slotmask - World:make_slot_mask(16)

	if Global.game_settings and Global.game_settings.one_down then
		self._bullet_slotmask = self._bullet_slotmask + 3
	else
		self._bullet_slotmask = managers.mutators:modify_value("RaycastWeaponBase:setup:weapon_slot_mask", self._bullet_slotmask)
		self._bullet_slotmask = managers.modifiers:modify_value("RaycastWeaponBase:setup:weapon_slot_mask", self._bullet_slotmask)
	end

	self._headshot_pierce_damage_mult = 1
	self._shield_pierce_damage_mult = 0.5
	self._can_shoot_through_head = self._can_shoot_through_enemy
end

function RaycastWeaponBase:setup(...)
	setup_original(self, ...)
	
	--self._bullet_slotmask = self._bullet_slotmask - World:make_slot_mask(16)

	--Use stability stat to get the moving accuracy penalty.
	self._spread_moving = tweak_data.weapon.stats.spread_moving[self._current_stats_indices.recoil] or 0

	--Trackers for MG Specialist Ace
	for _, category in ipairs(self:weapon_tweak_data().categories) do
		if managers.player:has_category_upgrade(category, "full_auto_free_ammo") then
			self._bullets_until_free = managers.player:upgrade_value(category, "full_auto_free_ammo")
			break
		end
	end
	self._shots_without_releasing_trigger = 0

	self._ammo_overflow = 0 --Amount of non-integer ammo picked up.

	--Flag for Shell Shocked
	for _, category in ipairs(self:weapon_tweak_data().categories) do
		if managers.player:has_category_upgrade(category, "last_shot_stagger") then
			self._stagger_on_last_shot = managers.player:upgrade_value(category, "last_shot_stagger")
			managers.hud:add_skill(category .. "_last_shot_stagger")
			break
		end
	end

	--Shots required for Bullet Hell
	if managers.player:has_category_upgrade("temporary", "bullet_hell") then
		local bullet_hell_stats = managers.player:upgrade_value("temporary", "bullet_hell")[1]
		self._shots_before_bullet_hell = (not bullet_hell_stats.smg_only or self:is_category("smg")) and bullet_hell_stats.shots_required  
	end
end

--Check for ShellShocked.
local on_reload_original = RaycastWeaponBase.on_reload
function RaycastWeaponBase:on_reload(...)
	self:check_last_bullet_stagger()
	on_reload_original(self, ...)
end

--Fire no longer memes on shields.
function FlameBulletBase:bullet_slotmask()
	return managers.slot:get_mask("bullet_impact_targets")
end	

--Add shield knocking to FlameBulletBase
function FlameBulletBase:on_collision(col_ray, weapon_unit, user_unit, damage, blank)
	if Network:is_client() and not blank and user_unit ~= managers.player:player_unit() then
		blank = true
	end

	local hit_unit = col_ray.unit
	local is_shield = hit_unit:in_slot(managers.slot:get_mask("enemy_shield_check")) and alive(hit_unit:parent())

	--Give DB Shield Knock if the player has the skill.
	if alive(weapon_unit) and is_shield and weapon_unit:base()._shield_knock then
		local enemy_unit = hit_unit:parent()

		if enemy_unit:character_damage() and enemy_unit:character_damage().dead and not enemy_unit:character_damage():dead() then
			if enemy_unit:base():char_tweak() then
				if enemy_unit:base():char_tweak().damage.shield_knocked and not enemy_unit:character_damage():is_immune_to_shield_knockback() then
					local knock_chance = math.sqrt(0.03 * damage) --Makes a nice curve.

					if knock_chance > math.random() then
						local damage_info = {
							damage = 0,
							type = "shield_knock",
							variant = "melee",
							col_ray = col_ray,
							result = {
								variant = "melee",
								type = "shield_knock"
							}
						}

						enemy_unit:character_damage():_call_listeners(damage_info)
					end
				end
			end
		end
	end

	if hit_unit:damage() and managers.network:session() and col_ray.body:extension() and col_ray.body:extension().damage then
		local damage_body_extension = true
		local character_unit = nil

		if hit_unit:character_damage() then
			character_unit = hit_unit
		elseif is_shield and hit_unit:parent():character_damage() then
			character_unit = hit_unit:parent()
		end

		if character_unit and character_unit:character_damage().is_friendly_fire and character_unit:character_damage():is_friendly_fire(user_unit) then
			damage_body_extension = false
		end

		--do a friendly fire check if the unit hit is a character or a character's shield before damaging the body extension that was hit
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

				if alive(weapon_unit) and weapon_unit:base().categories and weapon_unit:base():categories() then
					for _, category in ipairs(weapon_unit:base():categories()) do
						col_ray.body:extension().damage:damage_bullet_type(category, user_unit, col_ray.normal, col_ray.position, col_ray.ray, 1)
					end
				end
			end
		end
	end

	local result = nil

	if alive(weapon_unit) and hit_unit:character_damage() and hit_unit:character_damage().damage_fire then
		local is_alive = not hit_unit:character_damage():dead()
		result = self:give_fire_damage(col_ray, weapon_unit, user_unit, damage)

		if not is_dead then
			if not result or result == "friendly_fire" then
				play_impact_flesh = false
			end
		end

		local push_multiplier = self:_get_character_push_multiplier(weapon_unit, is_alive and is_dead)
		managers.game_play_central:physics_push(col_ray, push_multiplier)
	else
		managers.game_play_central:physics_push(col_ray)
	end

	--Play Impact flesh is never true on fire bullets. No need for this conditional.

	--DB Always plays impact sound and effects.
	self:play_impact_sound_and_effects(weapon_unit, col_ray, no_sound)
	
	return result
end

--Minor fixes and making Winters unpiercable.
function RaycastWeaponBase:_collect_hits(from, to)
	local hit_enemy = false
	local enemy_mask = managers.slot:get_mask("enemies")
	local wall_mask = managers.slot:get_mask("world_geometry", "vehicles")
	local shield_mask = managers.slot:get_mask("enemy_shield_check")
	local ai_vision_ids = Idstring("ai_vision")
	--Just set this immediately.
	local ray_hits = self._can_shoot_through_wall and World:raycast_wall("ray", from, to, "slot_mask", self._bullet_slotmask, "ignore_unit", self._setup.ignore_units, "thickness", 40, "thickness_mask", wall_mask)
		or World:raycast_all("ray", from, to, "slot_mask", self._bullet_slotmask, "ignore_unit", self._setup.ignore_units)
	local units_hit = {}
	local unique_hits = {}

	for i, hit in ipairs(ray_hits) do
		if not units_hit[hit.unit:key()] then
			units_hit[hit.unit:key()] = true
			unique_hits[#unique_hits + 1] = hit
			local hit_enemy = hit_enemy or hit.unit:in_slot(enemy_mask)
			local weak_body = hit.body:has_ray_type(ai_vision_ids)

			--Tactical Precision headshot piercing.
			if self._can_shoot_through_head
				and hit.unit:in_slot(enemy_mask)
				and not hit.unit:character_damage()._char_tweak.ignore_headshot
				and hit.unit:character_damage()._ids_head_body_name
				and hit.unit:character_damage()._ids_head_body_name == hit.body:name() then
				hit.head_pierced = true
			end

			if not self._can_shoot_through_enemy and not hit.head_pierced and hit_enemy then
				break
			elseif has_hit_wall or (not self._can_shoot_through_wall and hit.unit:in_slot(wall_mask) and weak_body) then
				break
			elseif not self._can_shoot_through_shield and hit.unit:in_slot(shield_mask) then
				break
			elseif hit.unit:in_slot(shield_mask) and hit.unit:name():key() == 'af254947f0288a6c' and not self._can_shoot_through_titan_shield  then --Titan shields
				break
			elseif hit.unit:in_slot(shield_mask) and hit.unit:name():key() == '4a4a5e0034dd5340' then --Winters being a shit.
				break						
			end
			
			local has_hit_wall = has_hit_wall or hit.unit:in_slot(wall_mask)				
		end
	end

	return unique_hits, hit_enemy
end	

function InstantBulletBase:on_collision(col_ray, weapon_unit, user_unit, damage, blank, no_sound, already_ricocheted)
	if Network:is_client() and not blank and user_unit ~= managers.player:player_unit() then
		blank = true
	end

	local hit_unit = col_ray.unit
	local is_shield = hit_unit:in_slot(managers.slot:get_mask("enemy_shield_check")) and alive(hit_unit:parent())

	if alive(weapon_unit) and is_shield and weapon_unit:base()._shield_knock then
		local enemy_unit = hit_unit:parent()

		if enemy_unit:character_damage() and enemy_unit:character_damage().dead and not enemy_unit:character_damage():dead() then
			if enemy_unit:base():char_tweak() then
				if enemy_unit:base():char_tweak().damage.shield_knocked and not enemy_unit:character_damage():is_immune_to_shield_knockback() then 
					local knock_chance = math.sqrt(0.02 * damage) --See odds at https://www.desmos.com/calculator/yspearqqxt

					if knock_chance > math.random() then
						local damage_info = {
							damage = 0,
							type = "shield_knock",
							variant = "melee",
							col_ray = col_ray,
							result = {
								variant = "melee",
								type = "shield_knock"
							}
						}

						enemy_unit:character_damage():_call_listeners(damage_info)
					end
				end
			end
		end
	end

	local play_impact_flesh = not hit_unit:character_damage() or not hit_unit:character_damage()._no_blood

	if hit_unit:damage() and managers.network:session() and col_ray.body:extension() and col_ray.body:extension().damage then
		local damage_body_extension = true
		local character_unit = nil

		if hit_unit:character_damage() then
			character_unit = hit_unit
		elseif is_shield and hit_unit:parent():character_damage() then
			character_unit = hit_unit:parent()
		end

		if character_unit and character_unit:character_damage().is_friendly_fire and character_unit:character_damage():is_friendly_fire(user_unit) then
			damage_body_extension = false
		end

		--do a friendly fire check if the unit hit is a character or a character's shield before damaging the body extension that was hit
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

				if alive(weapon_unit) and weapon_unit:base().categories and weapon_unit:base():categories() then
					for _, category in ipairs(weapon_unit:base():categories()) do
						col_ray.body:extension().damage:damage_bullet_type(category, user_unit, col_ray.normal, col_ray.position, col_ray.ray, 1)
					end
				end
			end
		end
	end

	local result = nil

	if alive(weapon_unit) and hit_unit:character_damage() and hit_unit:character_damage().damage_bullet then
		local is_alive = not hit_unit:character_damage():dead()

		if not blank then
			--Knock down skill now checks for whether or not a bipod is active.
			local knock_down = weapon_unit:base()._knock_down and managers.player._current_state == "bipod" and weapon_unit:base()._knock_down > 0 and math.random() < weapon_unit:base()._knock_down
			result = self:give_impact_damage(col_ray, weapon_unit, user_unit, damage, weapon_unit:base()._use_armor_piercing, false, knock_down, weapon_unit:base()._stagger, weapon_unit:base()._variant)
		end

		local is_dead = hit_unit:character_damage():dead()

		if not is_dead then
			if not result or result == "friendly_fire" then
				play_impact_flesh = false
			end
		end

		local push_multiplier = self:_get_character_push_multiplier(weapon_unit, is_alive and is_dead)

		managers.game_play_central:physics_push(col_ray, push_multiplier)
	else
		managers.game_play_central:physics_push(col_ray)
	end

	if play_impact_flesh then
		managers.game_play_central:play_impact_flesh({
			col_ray = col_ray,
			no_sound = no_sound
		})
		self:play_impact_sound_and_effects(weapon_unit, col_ray, no_sound)
	end

	return result
end

--Refactored from vanilla code for consistency and simplicity.
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

		--Apply akimbo rounding.
		if self.AKIMBO then
			local akimbo_rounding = ammo_gained % 2 + #self._fire_callbacks
			ammo_gained = ammo_gained + akimbo_rounding
		end

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

local mvec_to = Vector3()
local mvec_spread_direction = Vector3()
local mvec1 = Vector3()

function RaycastWeaponBase:check_autoaim(from_pos, direction, max_dist, use_aim_assist, autohit_override_data)
	local autohit = use_aim_assist and self._aim_assist_data or self._autohit_data
	autohit = autohit_override_data or autohit
	local autohit_near_angle = autohit.near_angle
	local autohit_far_angle = autohit.far_angle
	local far_dis = autohit.far_dis
	local closest_error, closest_ray = nil
	local tar_vec = tmp_vec1
	local ignore_units = self._setup.ignore_units
	local slotmask = self._bullet_slotmask

	local cone_distance = max_dist or self:weapon_range() or 20000
	local tmp_vec_to = Vector3()
	mvector3.set(tmp_vec_to, mvector3.copy(direction))
	mvector3.multiply(tmp_vec_to, cone_distance)
	mvector3.add(tmp_vec_to, mvector3.copy(from_pos))

	local cone_radius = mvector3.distance(mvector3.copy(from_pos), mvector3.copy(tmp_vec_to)) / 4
	local enemies_in_cone = self._unit:find_units("cone", from_pos, tmp_vec_to, cone_radius, managers.slot:get_mask("player_autoaim"))
	local ignore_rng = nil
	
	for _, enemy in pairs(enemies_in_cone) do
		local com = enemy:character_damage():get_ranged_attack_autotarget_data_fast().object:position()

		mvec3_set(tar_vec, com)
		mvec3_sub(tar_vec, from_pos)

		local tar_aim_dot = mvec3_dot(direction, tar_vec)

		if tar_aim_dot > 0 and (not max_dist or tar_aim_dot < max_dist) then
			local tar_vec_len = math_clamp(mvec3_norm(tar_vec), 1, 6000)
			local error_dot = mvec3_dot(direction, tar_vec)
			local error_angle = math.acos(error_dot)

			if error_angle <= 1 then
				local percent_error = error_angle / 1

				if not closest_error or percent_error < closest_error then
					ignore_rng = true
					tar_vec_len = tar_vec_len + 100

					mvec3_mul(tar_vec, tar_vec_len)
					mvec3_add(tar_vec, from_pos)

					local hit_enemy = false
					local enemy_mask = managers.slot:get_mask("player_autoaim")
					local wall_mask = managers.slot:get_mask("world_geometry", "vehicles")
					local shield_mask = managers.slot:get_mask("enemy_shield_check")
					local ai_vision_ids = Idstring("ai_vision")
					local bulletproof_ids = Idstring("bulletproof")

					local vis_ray = World:raycast_all("ray", from_pos, tar_vec, "slot_mask", slotmask, "ignore_unit", ignore_units)
					local units_hit = {}
					local unique_hits = {}

					for i, hit in ipairs(vis_ray) do
						if not units_hit[hit.unit:key()] then
							units_hit[hit.unit:key()] = true
							unique_hits[#unique_hits + 1] = hit
							hit.hit_position = hit.position
							hit_enemy = hit_enemy or hit.unit:in_slot(enemy_mask)
							local weak_body = hit.body:has_ray_type(ai_vision_ids)
							weak_body = weak_body or hit.body:has_ray_type(bulletproof_ids)

							if hit_enemy then
								break
							elseif hit.unit:in_slot(wall_mask) then
								if weak_body then
									break
								end
							elseif not self._can_shoot_through_shield and hit.unit:in_slot(shield_mask) then
								break
							end
						end
					end

					for _, vis_ray in ipairs(unique_hits) do
						if vis_ray and vis_ray.unit:key() == enemy:key() and (not closest_error or error_angle < closest_error) then
							closest_error = error_angle
							closest_ray = vis_ray

							mvec3_set(tmp_vec1, com)
							mvec3_sub(tmp_vec1, from_pos)

							local d = mvec3_dot(direction, tmp_vec1)

							mvec3_set(tmp_vec1, direction)
							mvec3_mul(tmp_vec1, d)
							mvec3_add(tmp_vec1, from_pos)
							mvec3_sub(tmp_vec1, com)

							closest_ray.distance_to_aim_line = mvec3_len(tmp_vec1)

							break
						end
					end
				end
			end
		end
	end
	
	--log(tostring(ignore_rng))

	return closest_ray
end

local mvec_to = Vector3()
local mvec_spread_direction = Vector3()

function RaycastWeaponBase:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul)
	if self:gadget_overrides_weapon_functions() then
		return self:gadget_function_override("_fire_raycast", self, user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul)
	end
	local result = {}
	local spread_x, spread_y = self:_get_spread(user_unit)
	local ray_distance = self:weapon_range()
	local right = direction:cross(Vector3(0, 0, 1)):normalized()
	local up = direction:cross(right):normalized()
	local r = math.random()
	local theta = math.random() * 360
	local ax = math.tan(r * spread_x * (spread_mul or 1)) * math.cos(theta)
	local ay = math.tan(r * spread_y * (spread_mul or 1)) * math.sin(theta) * -1

	mvector3.set(mvec_spread_direction, direction)
	mvector3.add(mvec_spread_direction, right * ax)
	mvector3.add(mvec_spread_direction, up * ay)
	mvector3.set(mvec_to, mvec_spread_direction)
	mvector3.multiply(mvec_to, ray_distance)
	mvector3.add(mvec_to, from_pos)

	local damage = self:_get_current_damage(dmg_mul)
	local ray_hits, hit_enemy = self:_collect_hits(from_pos, mvec_to)
	local hit_anyone = false

	if suppression_enemies and self._suppression then
		result.enemies_in_cone = suppression_enemies
	end
	
	local aimassist = heat.Options:GetValue("AimAssist")

	if aimassist then
		local auto_hit_candidate = not hit_enemy and self:check_autoaim(from_pos, direction)

		if auto_hit_candidate then
			--local line2 = Draw:brush(Color.green:with_alpha(0.5), 5)
			--line2:cylinder(from_pos, mvec_to, 1)
		
			mvector3.set(mvec_to, from_pos)
			mvector3.add_scaled(mvec_to, auto_hit_candidate.ray, ray_distance)

			ray_hits, hit_enemy = self:_collect_hits(from_pos, mvec_to)
			mvector3.set(mvec_spread_direction, mvec_to)
			--local line = Draw:brush(Color.blue:with_alpha(0.5), 5)
			--line:cylinder(from_pos, mvec_to, 1)
		end
	end
	
	local hit_count = 0
	local cop_kill_count = 0
	local hit_through_wall = false
	local hit_through_shield = false
	local shield_damage_reduction_applied = false
	local hit_through_head = false
	local hit_result = nil

	for _, hit in ipairs(ray_hits) do
		damage = self:get_damage_falloff(damage, hit, user_unit)
		hit_result = self._bullet_class:on_collision(hit, self._unit, user_unit, damage)

		if hit_result and hit.head_pierced and not hit_through_head then
			hit_through_head = true
			damage = damage * self._headshot_pierce_damage_mult
		end

		if hit_result and hit_result.type == "death" then
			local unit_type = hit.unit:base() and hit.unit:base()._tweak_table
			local is_civilian = unit_type and CopDamage.is_civilian(unit_type)

			if not is_civilian then
				cop_kill_count = cop_kill_count + 1
			end

			if not is_civilian then
				self._kills_without_releasing_trigger = (self._kills_without_releasing_trigger or 0) + 1

				if self:is_category(tweak_data.achievement.easy_as_breathing.weapon_type) then
					if tweak_data.achievement.easy_as_breathing.count <= self._kills_without_releasing_trigger then
						managers.achievment:award(tweak_data.achievement.easy_as_breathing.award)
					end
				end
			end
		end

		if hit_result then
			hit.damage_result = hit_result
			hit_anyone = true
			hit_count = hit_count + 1
		end

		if hit.unit:in_slot(managers.slot:get_mask("world_geometry")) then
			hit_through_wall = true
			shield_damage_reduction_applied = false
		elseif hit.unit:in_slot(managers.slot:get_mask("enemy_shield_check")) then
			hit_through_shield = hit_through_shield or alive(hit.unit:parent())
			shield_damage_reduction_applied = false
		end

		--Damage reduction when shooting through shields.
		--self._shield_damage_mult to be sorted out later, will be useful for setting it per gun if wanted in the future.
		if hit_through_shield and not shield_damage_reduction_applied then
			damage = damage * self._shield_pierce_damage_mult
			shield_damage_reduction_applied = true
		end

		if hit_result and hit_result.type == "death" and cop_kill_count > 0 then
			local unit_type = hit.unit:base() and hit.unit:base()._tweak_table
			local multi_kill, enemy_pass, obstacle_pass, weapon_pass, weapons_pass, weapon_type_pass = nil

			for achievement, achievement_data in pairs(tweak_data.achievement.sniper_kill_achievements) do
				multi_kill = not achievement_data.multi_kill or cop_kill_count == achievement_data.multi_kill
				enemy_pass = not achievement_data.enemy or unit_type == achievement_data.enemy
				obstacle_pass = not achievement_data.obstacle or achievement_data.obstacle == "wall" and hit_through_wall or achievement_data.obstacle == "shield" and hit_through_shield
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
	end

	if not tweak_data.achievement.tango_4.difficulty or table.contains(tweak_data.achievement.tango_4.difficulty, Global.game_settings.difficulty) then
		if self._gadgets and table.contains(self._gadgets, "wpn_fps_upg_o_45rds") and cop_kill_count > 0 and managers.player:player_unit():movement():current_state():in_steelsight() then
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

	result.hit_enemy = hit_anyone

	if self._autoaim then
		self._shot_fired_stats_table.hit = hit_anyone
		self._shot_fired_stats_table.hit_count = hit_count

		if (not self._ammo_data or not self._ammo_data.ignore_statistic) and not self._rays then
			managers.statistics:shot_fired(self._shot_fired_stats_table)
		end
	end

	local furthest_hit = ray_hits[#ray_hits]

	if (furthest_hit and furthest_hit.distance > 600 or not furthest_hit) and alive(self._obj_fire) then
		self._obj_fire:m_position(self._trail_effect_table.position)
		mvector3.set(self._trail_effect_table.normal, mvec_spread_direction)

		local trail = World:effect_manager():spawn(self._trail_effect_table)

		if furthest_hit then
			World:effect_manager():set_remaining_lifetime(trail, math.clamp((furthest_hit.distance - 600) / 10000, 0, furthest_hit.distance))
		end
	end

	if self._alert_events then
		result.rays = ray_hits
	end

	return result
end

--Original mod by 90e, uploaded by DarKobalt.
--Reverb fixed by Doctor Mister Cool, aka Didn'tMeltCables, aka DinoMegaCool
--New version uploaded and maintained by Offyerrocker.
--Totally not stolen for resmod 

local afsf_blacklist = {
	["saw"] = true,
	["saw_secondary"] = true,
	["flamethrower_mk2"] = true,
	["system"] = true
}

function RaycastWeaponBase:_soundfix_should_play_normal()
	local name_id = self:get_name_id() or "xX69dank420blazermachineXx" 
	if not self._setup.user_unit == managers.player:player_unit() then
		return true
	elseif afsf_blacklist[name_id] then
		return true
	elseif not tweak_data.weapon[name_id].sounds.fire_single then
		return true
	end
	
end

local orig_fire_sound = RaycastWeaponBase._fire_sound
function RaycastWeaponBase:_fire_sound(...)
	if self:_soundfix_should_play_normal() then
		orig_fire_sound(self,...)
	end
end

--Shell Shocked Skill Reset
function RaycastWeaponBase:check_last_bullet_stagger()
	if self:get_ammo_remaining_in_clip() >= self:get_ammo_max_per_clip() then
		for _, category in ipairs(self:weapon_tweak_data().categories) do
			if managers.player:has_category_upgrade(category, "last_shot_stagger") then
				self._stagger_on_last_shot = managers.player:upgrade_value(category, "last_shot_stagger")
				managers.hud:add_skill(category .. "_last_shot_stagger")
				break
			end
		end
	end
end


--Adds auto fire sound fix, Shell Shocked skill, and MG Specialist skill.
function RaycastWeaponBase:fire(from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit)
	if managers.player:has_activate_temporary_upgrade("temporary", "no_ammo_cost_buff") then
		managers.player:deactivate_temporary_upgrade("temporary", "no_ammo_cost_buff")

		if managers.player:has_category_upgrade("temporary", "no_ammo_cost") then
			managers.player:activate_temporary_upgrade("temporary", "no_ammo_cost")
		end
	end

	local is_player = self._setup.user_unit == managers.player:player_unit()
	local consume_ammo = not managers.player:has_active_temporary_property("bullet_storm") and (not managers.player:has_activate_temporary_upgrade("temporary", "berserker_damage_multiplier") or not managers.player:has_category_upgrade("player", "berserker_no_ammo_cost")) or not is_player

	if is_player then
		--Spray 'n Pray
		self._shots_without_releasing_trigger = self._shots_without_releasing_trigger + 1
		if self._bullets_until_free and self._shots_without_releasing_trigger % self._bullets_until_free == 0 then
			consume_ammo = false
		end

		--Bullet Hell
		if consume_ammo then
			if math.random() < managers.player:temporary_upgrade_value("temporary", "bullet_hell", {free_ammo_chance = 0}).free_ammo_chance then
				consume_ammo = false
			end
		end

		if self._shots_before_bullet_hell and self._shots_before_bullet_hell <= self._shots_without_releasing_trigger then
			self._bullet_hell_procced = true
			managers.player:activate_temporary_upgrade_indefinitely("temporary", "bullet_hell")
		end
	end

	if consume_ammo and (is_player or Network:is_server()) then
		local base = self:ammo_base()

		if base:get_ammo_remaining_in_clip() == 0 then
			return
		end

		local ammo_usage = 1
		local mag = base:get_ammo_remaining_in_clip()
		local remaining_ammo = mag - ammo_usage

		if mag > 0 and remaining_ammo <= (self.AKIMBO and 1 or 0) then
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

			self:set_magazine_empty(true)

			if is_player and self._stagger_on_last_shot then
				self._setup.user_unit:movement():stagger_in_aoe(self._stagger_on_last_shot)
				local categories = self:categories()
				managers.hud:remove_skill(categories[1] .. "_last_shot_stagger")
				self._stagger_on_last_shot = nil
			end
		end

		base:set_ammo_remaining_in_clip(base:get_ammo_remaining_in_clip() - ammo_usage)
		self:use_ammo(base, ammo_usage)
	end

	local user_unit = self._setup.user_unit

	self:_check_ammo_total(user_unit)

	if alive(self._obj_fire) then
		self:_spawn_muzzle_effect(from_pos, direction)
	end

	self:_spawn_shell_eject_effect()

	local ray_res = self:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit)

	if self._alert_events and ray_res.rays then
		self:_check_alert(ray_res.rays, from_pos, direction, user_unit)
	end

	if ray_res.enemies_in_cone then
		for enemy_data, dis_error in pairs(ray_res.enemies_in_cone) do
			if not enemy_data.unit:movement():cool() then
				enemy_data.unit:character_damage():build_suppression(suppr_mul * dis_error * self._suppression, self._panic_suppression_chance)
			end
		end
	end

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

function RaycastWeaponBase:stop_shooting()
	self._shots_without_releasing_trigger = 0
	
	if self._bullet_hell_procced then
		managers.player:activate_temporary_upgrade("temporary", "bullet_hell")
		self._bullet_hell_procced = nil
	end	

	self._shooting = nil
	self._kills_without_releasing_trigger = nil
	self._bullets_fired = nil

	if self:_soundfix_should_play_normal() then
		self:play_tweak_data_sound("stop_fire")
	end
end


--Multipliers for overall spread.
function RaycastWeaponBase:conditional_accuracy_multiplier(current_state)
	local mul = 1

	--Multi-pellet spread increase.
	if self._rays and self._rays > 1 then
		mul = mul * tweak_data.weapon.stat_info.shotgun_spread_increase
	end

	if not current_state then
		return mul
	end

	local pm = managers.player

	if current_state:in_steelsight() then
		for _, category in ipairs(self:categories()) do
			mul = mul * pm:upgrade_value(category, "steelsight_accuracy_inc", 1)
		end
	else
		for _, category in ipairs(self:categories()) do
			mul = mul * pm:upgrade_value(category, "hip_fire_spread_multiplier", 1)
		end
	end

	mul = mul * pm:get_property("desperado", 1)

	return mul
end

--Multiplier for movement penalty to spread.
function RaycastWeaponBase:moving_spread_penalty_reduction()
	local spread_multiplier = 1
	for _, category in ipairs(self:weapon_tweak_data().categories) do
		spread_multiplier = spread_multiplier * managers.player:upgrade_value(category, "move_spread_multiplier", 1)
	end
	return spread_multiplier
end

--Simpler spread function. Determines area bullets can hit then converts that to the max degrees by which the rays can fire.
function RaycastWeaponBase:_get_spread(user_unit)
	local current_state = user_unit:movement()._current_state
	if not current_state then
		return 0, 0
	end

	--Get spread area from accuracy stat.
	local spread_area = math.max(self._spread + 
		managers.blackmarket:accuracy_index_addend(self._name_id, self:categories(), self._silencer, current_state, self:fire_mode(), self._blueprint) * tweak_data.weapon.stat_info.spread_per_accuracy, 0.05)
	
	--Moving penalty to spread, based on stability stat- added to total area.
	if current_state._moving then
		--Get spread area from stability stat.
		local moving_spread = math.max(self._spread_moving + managers.blackmarket:stability_index_addend(self:categories(), self._silencer) * tweak_data.weapon.stat_info.spread_per_stability, 0)
		--Add moving spread penalty reduction.
		moving_spread = moving_spread * self:moving_spread_penalty_reduction()
		spread_area = spread_area + moving_spread
	end

	--Apply skill and stance multipliers to overall spread area.
	local multiplier = tweak_data.weapon.stat_info.stance_spread_mults[current_state:get_movement_state()] * self:conditional_accuracy_multiplier(current_state)
	spread_area = spread_area * multiplier


	--Convert spread area to degrees.
	local spread_x = math.sqrt((spread_area)/math.pi)
	local spread_y = spread_x

	return spread_x, spread_y
end

function RaycastWeaponBase:on_equip(user_unit)
	self:_check_magazine_empty()

	if self._stagger_on_last_shot then
		local categories = self:categories()
		managers.hud:add_skill(categories[1] .. "_last_shot_stagger")
	end
end

function RaycastWeaponBase:on_unequip(user_unit)
	if self._tango_4_data then
		self._tango_4_data = nil
	end

	managers.player:deactivate_temporary_upgrade("temporary", "bullet_hell")
	managers.hud:remove_skill("bullet_hell")

	local categories = self:categories()
	managers.hud:remove_skill(categories[1] .. "_last_shot_stagger")
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

BleedBulletBase = BleedBulletBase or class(DOTBulletBase)
BleedBulletBase.VARIANT = "bleed"
ProjectilesBleedBulletBase = ProjectilesBleedBulletBase or class(BleedBulletBase)
ProjectilesBleedBulletBase.NO_BULLET_INPACT_SOUND = false

--Allow easier hotloading of data.
function ProjectilesBleedBulletBase:on_collision(col_ray, weapon_unit, user_unit, damage, blank)
	local result = DOTBulletBase.super.on_collision(self, col_ray, weapon_unit, user_unit, damage, blank, self.NO_BULLET_INPACT_SOUND)
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

		result = self:start_dot_damage(col_ray, nil, {
			dot_damage = dot_type_data.dot_damage,
			dot_length = dot_data.custom_length or dot_type_data.dot_length
		})
	end

	return result
end

function BleedBulletBase:start_dot_damage(col_ray, weapon_unit, dot_data, weapon_id)
	dot_data = dot_data or self.DOT_DATA
	local hurt_animation = not dot_data.hurt_animation_chance or math.rand(1) < dot_data.hurt_animation_chance

	--Add range limits for Flechette shotguns.
	local can_apply_dot = true
	if alive(weapon_unit) then
		weap_base = weapon_unit:base()
		if weap_base.near_dot_distance then
			can_apply_dot = weap_base.far_dot_distance + weap_base.near_dot_distance > (col_ray.distance or 0)
		end
	end

	if can_apply_dot == true then
		managers.dot:add_doted_enemy(col_ray.unit, TimerManager:game():time(), weapon_unit, dot_data.dot_length, dot_data.dot_damage, hurt_animation, self.VARIANT, weapon_id)
 	end
end

function InstantExplosiveBulletBase:on_collision_server(position, normal, damage, user_unit, weapon_unit, owner_peer_id, owner_selection_index)
	local slot_mask = managers.slot:get_mask("explosion_targets")

	managers.explosion:play_sound_and_effects(position, normal, self.RANGE, self.EFFECT_PARAMS)

	managers.explosion:give_local_player_dmg(position, self.RANGE, damage * self.PLAYER_DMG_MUL, user_unit) --Funny vanilla code doesn't call this and works off of magic because reasons idk.
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

function InstantExplosiveBulletBase:on_collision_client(position, normal, damage, user_unit)
	managers.explosion:give_local_player_dmg(position, self.RANGE, damage * self.PLAYER_DMG_MUL, user_unit)
	managers.explosion:explode_on_client(position, normal, user_unit, damage, self.RANGE, self.CURVE_POW, self.EFFECT_PARAMS)
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
	
	local action_data = {
		variant = self.VARIANT,
		damage = damage,
		weapon_unit = weapon_unit,
		attacker_unit = attacker_unit,
		col_ray = col_ray,
		hurt_animation = hurt_animation,
		weapon_id = weapon_id
	}
	local defense_data = {}

	if col_ray and col_ray.unit and alive(col_ray.unit) and col_ray.unit:character_damage() then
		defense_data = col_ray.unit:character_damage():damage_dot(action_data)
	end

	return defense_data
end