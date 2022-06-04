local mvec_1 = Vector3()
local mvec_2 = Vector3()

local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
local mvec3_cpy = mvector3.copy
local mvec3_spread = mvector3.spread
local mvec3_set = mvector3.set
local mvec3_dot = mvector3.dot
local mvec3_dis = mvector3.distance
local mvec3_norm = mvector3.normalize

local math_clamp = math.clamp
local math_ceil = math.ceil
local math_max = math.max
local math_min = math.min
local math_random = math.random
local math_rand = math.rand
local math_lerp = math.lerp
local math_UP = math.UP

local ids_func = Idstring
local table_contains = table.contains

local big_enemy_visor_shattering_table = {
	ids_func("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"),
	ids_func("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1_husk"),
	ids_func("units/payday2/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc"),    
	ids_func("units/payday2/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc_husk"),    
	ids_func("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"),
	ids_func("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36_husk"),
	ids_func("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1"),
	ids_func("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1_husk"),
	ids_func("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_r870/ene_swat_heavy_hvh_r870"),
	ids_func("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_r870/ene_swat_heavy_hvh_r870_husk"),
	ids_func("units/pd2_mod_halloween/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc"),
	ids_func("units/pd2_mod_halloween/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc_husk"),                 	
	ids_func("units/pd2_mod_halloween/characters/ene_zeal_swat_heavy_r870_sc/ene_zeal_swat_heavy_r870_sc"),
	ids_func("units/pd2_mod_halloween/characters/ene_zeal_swat_heavy_r870_sc/ene_zeal_swat_heavy_r870_sc_husk"),                 	
	ids_func("units/pd2_mod_halloween/characters/ene_zeal_tazer/ene_zeal_tazer"),
	ids_func("units/pd2_mod_halloween/characters/ene_zeal_tazer/ene_zeal_tazer_husk"),                 	
	ids_func("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"),
	ids_func("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1_husk"),
	ids_func("units/payday2/characters/ene_shield_2/ene_shield_2"),
	ids_func("units/payday2/characters/ene_shield_2/ene_shield_2_husk"),
	ids_func("units/payday2/characters/ene_tazer_1/ene_tazer_1"),
	ids_func("units/payday2/characters/ene_tazer_1/ene_tazer_1_husk"),     
	ids_func("units/pd2_dlc_bex/characters/ene_swat_tazer_policia_federale/ene_swat_tazer_policia_federale"),
	ids_func("units/pd2_dlc_bex/characters/ene_swat_tazer_policia_federale/ene_swat_tazer_policia_federale_husk"),                 
	ids_func("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_zeal_g36/ene_swat_heavy_policia_federale_zeal_g36"),
	ids_func("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_zeal_g36/ene_swat_heavy_policia_federale_zeal_g36_husk"),                 
	ids_func("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"),
	ids_func("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer_husk"),                 
	ids_func("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc"),
	ids_func("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc_husk"),                 
	ids_func("units/pd2_mod_lapd/characters/ene_swat_heavy_1/ene_swat_heavy_1"),
	ids_func("units/pd2_mod_lapd/characters/ene_swat_heavy_1/ene_swat_heavy_1_husk"),                 
	ids_func("units/pd2_mod_lapd/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"),
	ids_func("units/pd2_mod_lapd/characters/ene_swat_heavy_r870/ene_swat_heavy_r870_husk"),                 
	ids_func("units/pd2_mod_lapd/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"),
	ids_func("units/pd2_mod_lapd/characters/ene_fbi_heavy_1/ene_fbi_heavy_1_husk"),                 
	ids_func("units/pd2_mod_lapd/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc"),
	ids_func("units/pd2_mod_lapd/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc_husk"),                 
	ids_func("units/pd2_mod_lapd/characters/ene_city_heavy_g36/ene_city_heavy_g36"),
	ids_func("units/pd2_mod_lapd/characters/ene_city_heavy_g36/ene_city_heavy_g36_husk"),                 
	ids_func("units/pd2_mod_sharks/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"),
	ids_func("units/pd2_mod_sharks/characters/ene_fbi_heavy_1/ene_fbi_heavy_1_husk"),                 
	ids_func("units/pd2_mod_sharks/characters/ene_murky_tazer/ene_murky_tazer"),
	ids_func("units/pd2_mod_sharks/characters/ene_murky_tazer/ene_murky_tazer_husk"),                 
	ids_func("units/pd2_mod_sharks/characters/ene_swat_heavy_1/ene_swat_heavy_1"),                 
	ids_func("units/pd2_mod_sharks/characters/ene_swat_heavy_1/ene_swat_heavy_1_husk"),               
	ids_func("units/pd2_mod_sharks/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"),                 
	ids_func("units/pd2_mod_sharks/characters/ene_swat_heavy_r870/ene_swat_heavy_r870_husk"),
	ids_func("units/pd2_mod_nypd/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"),
	ids_func("units/pd2_mod_nypd/characters/ene_fbi_heavy_1/ene_fbi_heavy_1_husk"),                 	
	ids_func("units/pd2_mod_nypd/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc"),
	ids_func("units/pd2_mod_nypd/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc_husk"),                 	
	ids_func("units/pd2_mod_nypd/characters/ene_nypd_heavy_m4/ene_nypd_heavy_m4"),
	ids_func("units/pd2_mod_nypd/characters/ene_nypd_heavy_m4/ene_nypd_heavy_m4_husk"),                 
	ids_func("units/pd2_mod_nypd/characters/ene_nypd_heavy_r870/ene_nypd_heavy_r870"),
	ids_func("units/pd2_mod_nypd/characters/ene_nypd_heavy_r870/ene_nypd_heavy_r870_husk"),                 	
}

local old_init = CopDamage.init
function CopDamage:init(...)
	old_init(self, ...)
	
	self._autotarget_data = {
		head = self._unit:get_object(Idstring("Head")),
		body = self._unit:get_object(Idstring("Spine1"))
	}
	
	--Replace head hitbox with a smaller one for non-dozer enemies.	
	if self._head_body_name and not self._char_tweak.big_head_mode then	
		local my_unit = self._unit
		local base_ext = my_unit:base()

		if not base_ext.has_tag or not base_ext:has_tag("tank") then
			local function f()
				if alive(my_unit) then
					my_unit:body("head"):set_sphere_radius(16)
				end
			end
		
			managers.enemy:add_delayed_clbk("hitboxes" .. tostring(my_unit:key()), f, TimerManager:game():time())
		end
	end

	--Health syncing values used to handle the LPF Overhealing effect.
	self._OVERHEALTH_INIT = self._HEALTH_INIT * 2
	self._OVERHEALTH_INIT_PRECENT = self._OVERHEALTH_INIT / self._HEALTH_GRANULARITY
	
	self._player_damage_ratio = 0 --Damage dealt to this enemy by players that contributed to the kill.

	--Enemies can have resist stacking defined in their preset.
	--Stacks make it more difficult to apply the same hurt multiple times to the same enemy.
	--Use this to allow for IE: Dozers to be knocked down with high knockdown melees, but not get stunlocked by them.
	self._hurt_resists = {} 

	if self._char_tweak.can_cloak then
		self._RECLOAK_THRESHOLD = self._HEALTH_INIT * (self._char_tweak.recloak_damage_threshold or 0)
		self._next_defensive_recloak = self._HEALTH_INIT - self._RECLOAK_THRESHOLD
	end
end

function CopDamage:get_ranged_attack_autotarget_data_fast()
	return self._autotarget_data
end

function CopDamage:_spawn_head_gadget(params)
	if not self._head_gear then
		return
	end

	if self._head_gear_object then
		if self._nr_head_gear_objects then
			for i = 1, self._nr_head_gear_objects do
				local head_gear_obj_name = self._head_gear_object .. tostring(i)

				self._unit:get_object(Idstring(head_gear_obj_name)):set_visibility(false)
			end
		else
			self._unit:get_object(Idstring(self._head_gear_object)):set_visibility(false)
		end

		if self._head_gear_decal_mesh then
			local mesh_name_idstr = Idstring(self._head_gear_decal_mesh)

			self._unit:decal_surface(mesh_name_idstr):set_mesh_material(mesh_name_idstr, Idstring("flesh"))
		end
	end

	local unit = World:spawn_unit(Idstring(self._head_gear), params.position, params.rotation)
	
	self._head_gear = false

	if not params.skip_push then
		local true_dir = params.dir
		local spread = math_random(6, 9)
		mvec3_spread(true_dir, spread)
		local dir = math_UP + true_dir
		local body = unit:body(0)

		body:push_at(body:mass(), dir * math_lerp(450, 650, math_random()), unit:position() + Vector3(math_rand(1), math_rand(1), math_rand(1)))
	end
	
	local my_unit = self._unit

	if not table_contains(big_enemy_visor_shattering_table, my_unit:name()) then
		return
	end

	local u_dmg = my_unit:damage()

	if u_dmg and u_dmg:has_sequence("shatter") then
		u_dmg:run_sequence_simple("shatter")
	end
end

function CopDamage:_apply_damage_reduction(damage)
	local damage_reduction = self._unit:movement():team().damage_reduction or 0
	
	if self._unit:base()._tweak_table == "summers" then
		local summers_crew = managers.enemy._registered_summers_crew
		
		if next(summers_crew) then
			local resist = 0
			for i = 1, #summers_crew do
				resist = resist + 0.3
			end
			resist = math_clamp(resist, 0, 0.9)
			
			damage_reduction = damage_reduction + resist
		end
	end

	if damage_reduction > 0 then
		damage = damage * (1 - damage_reduction)
	end

	if self._damage_reduction_multiplier then
		damage = damage * self._damage_reduction_multiplier
	end

	return damage
end
			
function CopDamage:damage_fire(attack_data)
	if self._dead or self._invulnerable then
		return
	end

	local attacker_unit = attack_data.attacker_unit
	local weap_unit = attack_data.weapon_unit

	if attacker_unit and alive(attacker_unit) then
		if attacker_unit:base() and attacker_unit:base().thrower_unit then
			attacker_unit = attacker_unit:base():thrower_unit()
			weap_unit = attack_data.attacker_unit
		end

		if self:is_friendly_fire(attacker_unit) then
			return "friendly_fire"
		end
	end

	local is_civilian = CopDamage.is_civilian(self._unit:base()._tweak_table)
	local head = attack_data.variant ~= "stun" and self._head_body_name and attack_data.col_ray.body and attack_data.col_ray.body:name() == self._ids_head_body_name

	if head and weap_unit and alive(weap_unit) and weap_unit:base() and not weap_unit:base().thrower_unit and attack_data.col_ray and attack_data.col_ray.ray and self._unit:base():has_tag("tank") then
		mvec3_set(mvec_1, attack_data.col_ray.ray)
		mrotation.z(self._unit:movement():m_head_rot(), mvec_2)

		local not_from_the_front = mvec3_dot(mvec_1, mvec_2) >= 0

		if not_from_the_front then
			head = false
		end
	end

	local headshot_multiplier = 1
	local damage = attack_data.damage
	local distance = 1000
	local hit_pos = attack_data.col_ray.hit_position

	if attack_data.attacker_unit == managers.player:player_unit() then
		if weap_unit and alive(weap_unit) and attack_data.variant ~= "stun" then
			if hit_pos then
				distance = mvector3.distance(hit_pos, attack_data.attacker_unit:position())
			end

			local weap_base = weap_unit:base()
			local is_grenade_or_ground_fire = nil

			if weap_base then
				if weap_base.thrower_unit or weap_base.get_name_id and weap_base:get_name_id() == "environment_fire" then
					is_grenade_or_ground_fire = true
				end
			end

			if is_grenade_or_ground_fire then
				if attack_data.is_fire_dot_damage and self._char_tweak.priority_shout then
					damage = damage * managers.player:upgrade_value("weapon", "special_damage_taken_multiplier", 1)
				end
			else
				if head then
					if not self._helmet_popped and managers.player:has_category_upgrade("weapon", "pop_helmets") then
						if self._unit:base()._tweak_table == "boom" then
							self._unit:damage():run_sequence_simple("grenadier_glass_break")
						else
							self:_spawn_head_gadget({
								position = attack_data.col_ray.body:position(),
								rotation = attack_data.col_ray.body:rotation(),
								dir = attack_data.col_ray.ray
							})
						end
						self._helmet_popped = true
					end

					headshot_multiplier = managers.player:upgrade_value("weapon", "passive_headshot_damage_multiplier", 1)
					managers.player:on_headshot_dealt(self._unit, attack_data)
				end

				local critical_hit, crit_damage = self:roll_critical_hit(attack_data)

				if critical_hit then
					damage = crit_damage
				end

				if self._char_tweak.priority_shout then
					damage = damage * managers.player:upgrade_value("weapon", "special_damage_taken_multiplier", 1)
				end

				local damage_scale = 1
				if weap_base.last_hit_falloff then
					damage_scale = 0.5
				end		

				if not attack_data.is_fire_dot_damage and damage > 0 then
					if critical_hit then
						managers.hud:on_crit_confirmed(damage_scale)
					else
						managers.hud:on_hit_confirmed(damage_scale)
					end
				end
			end
		end
	end

	if head and not self._damage_reduction_multiplier then
		damage = damage * (self._char_tweak.headshot_dmg_mul or 1) * headshot_multiplier
	end

	local weap_base = nil
	if alive(weap_unit) then
		weap_base = weap_unit:base()
	end

	--Allows seperate damage mults for fire pools, dot, and fire damage.
	if weap_base and self._char_tweak.damage.fire_pool_damage_mul and (weap_base.thrower_unit or weap_base.get_name_id and weap_base:get_name_id() == "environment_fire") then
		damage = damage * self._char_tweak.damage.fire_pool_damage_mul
	elseif attack_data.is_fire_dot_damage and self._char_tweak.damage.dot_damage_mul then --Is Fire DOT
		damage = damage * self._char_tweak.damage.dot_damage_mul
	elseif self._char_tweak.damage.fire_damage_mul then --Is direct fire damage.
		damage = damage * self._char_tweak.damage.fire_damage_mul
	end	
		
	if self._marked_dmg_mul then
		damage = damage * self._marked_dmg_mul

		if not attack_data.is_fire_dot_damage and self._marked_dmg_dist_mul and alive(attacker_unit) then
			local dst = mvec3_dis(attacker_unit:position(), self._unit:position())
			local spott_dst = tweak_data.upgrades.values.player.marked_inc_dmg_distance[self._marked_dmg_dist_mul]

			if spott_dst[1] < dst then
				damage = damage * spott_dst[2]
			end
		end
	end

	damage = self:_apply_damage_reduction(damage)

	if self._char_tweak.DAMAGE_CLAMP_FIRE then
		damage = math_min(damage, self._char_tweak.DAMAGE_CLAMP_FIRE)
	end

	attack_data.raw_damage = damage

	local damage_percent = 0
	if self:is_overhealed() then
		damage = (weap_base and weap_base.overhealed_damage_mul and weap_base:overhealed_damage_mul(distance) or 1) * damage
		damage = math_clamp(damage, 0, self._OVERHEALTH_INIT)
		damage_percent = math_ceil(damage / self._OVERHEALTH_INIT_PRECENT)
		damage = damage_percent * self._OVERHEALTH_INIT_PRECENT
	else
		damage = math_clamp(damage, 0, self._HEALTH_INIT)
		damage_percent = math_ceil(damage / self._HEALTH_INIT_PRECENT)
		damage = damage_percent * self._HEALTH_INIT_PRECENT
	end

	if self._immortal then
		damage = math_min(damage, self._health - 1)
	end

	local result = nil

	if self._health <= damage then
		attack_data.damage = self._health

		if not (head and weap_base and weap_base.can_ignore_medic_heals and weap_base:can_ignore_medic_heals(distance)) and self:check_medic_heal() then
			result = {
				type = "healed",
				variant = attack_data.variant
			}
			self._player_damage_ratio = 0
		else
			result = {
				type = "death",
				variant = attack_data.variant
			}

			self:die(attack_data)
			self:chk_killshot(attacker_unit, "fire")
		end
	else
		attack_data.damage = damage

		local result_type = "dmg_rcv"

		if not attack_data.is_fire_dot_damage then
			result_type = self:get_damage_type(damage_percent, "fire")
		end

		result = {
			type = result_type,
			variant = attack_data.variant
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.result = result
	attack_data.pos = attack_data.col_ray.position

	if result.type == "death" then
		if attack_data.variant ~= "stun" then
			if self._unit:base()._tweak_table == "boom" then
				self._unit:damage():run_sequence_simple("grenadier_glass_break")
			elseif self._head_body_name then
				local body = self._unit:body(self._head_body_name)

				self:_spawn_head_gadget({
					skip_push = true,
					position = body:position(),
					rotation = body:rotation()
				})
			end
		end

		if Network:is_server() and self._char_tweak.gas_on_death then
			managers.groupai:state():detonate_cs_grenade(self._unit:movement():m_pos() + math_UP * 10, mvec3_cpy(self._unit:movement():m_head_pos()), 7.5)
		end

		local data = {
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			owner = attack_data.owner,
			weapon_unit = weap_unit,
			variant = attack_data.variant,
			is_molotov = attack_data.is_molotov
		}

		managers.statistics:killed_by_anyone(data)

		if attacker_unit == managers.player:player_unit() then
			if alive(attacker_unit) then
				self:_comment_death(attacker_unit, self._unit)
			end

			self:_show_death_hint(self._unit:base()._tweak_table)
			managers.statistics:killed(data)

			if is_civilian then
				managers.money:civilian_killed()
			end

			self:_check_damage_achievements(attack_data, false)
		else
			if attacker_unit and alive(attacker_unit) and managers.groupai:state():is_unit_team_AI(attacker_unit) then
				self:_AI_comment_death(attacker_unit, self._unit)
			end
		end
	end
	
	if weap_base and weap_base.add_damage_result then
		weapon_unit:base():add_damage_result(self._unit, result.type == "death", damage_percent)
	end

	if not attack_data.is_fire_dot_damage and attack_data.fire_dot_data and result.type ~= "death" then --DoT never triggers an animation so it shouldn't constantly micro-stun enemies that are vulnerable to fire
		local fire_dot_data = attack_data.fire_dot_data
		local flammable, start_dot_dance_antimation = nil

		if self._char_tweak.flammable == nil then
			flammable = true
		else
			flammable = self._char_tweak.flammable
		end

		if flammable then
			local fire_dot_max_distance = weap_base and weap_base.far_falloff_distance and weap_base.far_falloff_distance + weap_base.near_falloff_distance or tonumber(fire_dot_data.dot_trigger_max_distance) or 3000

			if distance < fire_dot_max_distance then
				local start_dot_damage_roll = math_random(1, 100)
				local fire_dot_trigger_chance = tonumber(fire_dot_data.dot_trigger_chance) or 30

				--Dragon's breath trigger chance scales with range.
				if weap_base and weap_base.far_falloff_distance then
					fire_dot_trigger_chance = (1 - math.min(1, math.max(0, distance - weap_base.near_falloff_distance) / weap_base.far_falloff_distance)) * fire_dot_trigger_chance
				end

				if start_dot_damage_roll <= fire_dot_trigger_chance then
					local dot_damage = fire_dot_data.dot_damage or 25
					local t = TimerManager:game():time()

					managers.fire:add_doted_enemy(self._unit, t, weapon_unit, fire_dot_data.dot_length, dot_damage, attacker_unit, attack_data.is_molotov)

					local use_animation_on_fire_damage = nil

					if self._char_tweak.use_animation_on_fire_damage == nil then
						use_animation_on_fire_damage = true
					else
						use_animation_on_fire_damage = self._char_tweak.use_animation_on_fire_damage
					end

					if use_animation_on_fire_damage then
						if self.get_last_time_unit_got_fire_damage then
							local last_time_received = self:get_last_time_unit_got_fire_damage()

							if last_time_received == nil or t - last_time_received > 2 then
								start_dot_dance_antimation = true
							end
						else
							start_dot_dance_antimation = true
						end
					end
				end
			end

			fire_dot_data.start_dot_dance_antimation = start_dot_dance_antimation
			attack_data.fire_dot_data = fire_dot_data
		end

		if not start_dot_dance_antimation then --prevent fire_hurt from micro-stunning enemies when the dance animation isn't proced
			result.type = "dmg_rcv"
			attack_data.result.type = "dmg_rcv"
		else
			result.type = "fire_hurt"
			attack_data.result.type = "fire_hurt"
		end
	end

	local attacker = attack_data.attacker_unit

	if not attacker or not alive(attacker) or attacker:id() == -1 then
		attacker = self._unit
	end

	self:_send_fire_attack_result(attack_data, attacker, damage_percent, attack_data.is_fire_dot_damage, attack_data.col_ray.ray, attack_data.result.type == "healed")
	self:_on_damage_received(attack_data)

	if not attack_data.is_fire_dot_damage and not is_civilian and attacker_unit and alive(attacker_unit) then
		managers.player:enemy_shot(self._unit, attack_data)
	end

	return result
end

function CopDamage:sync_damage_fire(attacker_unit, damage_percent, start_dot_dance_antimation, death, direction, weapon_type, weapon_id, healed)
	if self._dead then
		return
	end

	local variant = "fire"
	local attack_data = {
		variant = variant,
		attacker_unit = attacker_unit
	}

	local attacker = attack_data.attacker_unit
	local weapon_unit = nil

	if attacker and attacker:base() and attacker:base().thrower_unit then
		attacker = attacker:base():thrower_unit()
		weapon_unit = attack_data.attacker_unit
	end

	--environment fires are the weapon unit, and those are not network synced (yet they're still set as the weapon unit)
	--I'll eventually rework the system to make these not despawn and set them as the weapon units just like other incendiary weapons
	if not weapon_unit and weapon_id ~= "molotov" and weapon_id ~= "fir_com" then
		weapon_unit = attacker_unit and attacker_unit:inventory() and alive(attacker_unit:inventory():equipped_unit()) and attacker_unit:inventory():equipped_unit()
	end

	local hit_pos = mvec3_cpy(self._unit:position())
	mvec3_set_z(hit_pos, hit_pos.z + 100)

	local attack_dir, result = nil

	if direction then
		attack_dir = direction
	elseif attacker_unit then
		local from_pos = nil

		if attacker_unit:movement() then
			if attacker_unit:movement().m_detect_pos then
				from_pos = attacker_unit:movement():m_detect_pos()
			elseif attacker_unit:movement().m_head_pos then
				from_pos = attacker_unit:movement():m_head_pos()
			else
				from_pos = attacker_unit:position()
			end
		else
			from_pos = attacker_unit:position()
		end

		attack_dir = hit_pos - from_pos
		mvec3_norm(attack_dir)
	else
		attack_dir = -self._unit:rotation():y()
	end

	attack_data.attack_dir = attack_dir
	hit_pos = hit_pos - attack_dir * 5
	attack_data.pos = hit_pos

	local damage = 0
	if self:is_overhealed() then
		damage = damage_percent * self._OVERHEALTH_INIT_PRECENT
	else
		damage = damage_percent * self._HEALTH_INIT_PRECENT
	end
	attack_data.damage = damage

	if death then
		attack_data.damage = self._health

		if self._unit:base()._tweak_table == "boom" then
			self._unit:damage():run_sequence_simple("grenadier_glass_break")
		elseif self._head_body_name then
			local body = self._unit:body(self._head_body_name)

			self:_spawn_head_gadget({
				skip_push = true,
				position = body:position(),
				rotation = body:rotation()
			})
		end

		if Network:is_server() and self._char_tweak.gas_on_death then
			managers.groupai:state():detonate_cs_grenade(self._unit:movement():m_pos() + math_UP * 10, mvec3_cpy(self._unit:movement():m_head_pos()), 7.5)
		end

		result = {
			type = "death",
			variant = variant
		}

		self:die(attack_data)
		self:chk_killshot(attacker_unit, "fire")

		local data = {
			variant = variant,
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			weapon_unit = weapon_unit,
			is_molotov = weapon_id == "molotov"
		}

		managers.statistics:killed_by_anyone(data)

		if attacker == managers.player:player_unit() then
			if alive(attacker) then
				self:_comment_death(attacker, self._unit)
			end

			self:_show_death_hint(self._unit:base()._tweak_table)
			managers.statistics:killed(data)

			if CopDamage.is_civilian(self._unit:base()._tweak_table) then
				managers.money:civilian_killed()
			end

			self:_check_damage_achievements(attack_data, false)
		end
	else
		local result_type = "dmg_rcv"

		if healed then
			result_type = "healed"

			attack_data.damage = self._health
		else
			self:_apply_damage_to_health(damage)
		end

		result = {
			type = result_type,
			variant = variant
		}
	end

	attack_data.result = result
	attack_data.is_synced = true
	weapon_unit = attack_data.weapon_unit or weapon_unit

	if alive(weapon_unit) and weapon_unit:base() and weapon_unit:base().add_damage_result then
		weapon_unit:base():add_damage_result(self._unit, result.type == "death", damage_percent)
	end

	self:_on_damage_received(attack_data)
end

function CopDamage:damage_bullet(attack_data)
	if self._dead or self._invulnerable then
		return
	end

	local attacker = attack_data.attacker_unit
	if self:is_friendly_fire(attacker) then
		return "friendly_fire"
	end

	if self:chk_immune_to_attacker(attacker) then
		return
	end

	if alive(attacker) and attacker:in_slot(16) then
		if self._unit:brain().surrendered and self._unit:brain():surrendered() or self._unit:anim_data().surrender or self._unit:anim_data().hands_back or self._unit:anim_data().hands_tied then
			return
		end
	end

	local weap_unit = attack_data.weapon_unit
	local weap_base = weap_unit:base()
	local is_civilian = CopDamage.is_civilian(self._unit:base()._tweak_table)
	local attacked_by_local_player = attack_data.attacker_unit == managers.player:player_unit()
	if self._has_plate and attack_data.col_ray.body and attack_data.col_ray.body:name() == self._ids_plate_name then
		if attack_data.armor_piercing or weap_base.thrower_unit then
			World:effect_manager():spawn({
				effect = Idstring("effects/payday2/particles/impacts/blood/blood_impact_a"),
				position = attack_data.col_ray.position,
				normal = attack_data.col_ray.ray
			})
		else
			World:effect_manager():spawn({
				effect = Idstring("effects/payday2/particles/impacts/steel_no_decal_impact_pd2"),
				position = attack_data.col_ray.position,
				normal = attack_data.col_ray.ray
			})

			if attacked_by_local_player then
				self._unit:sound():play("knuckles_hit_gen", nil, nil)
			end

			return
		end
	end

	local result = nil
	local body_index = self._unit:get_body_index(attack_data.col_ray.body:name())
	local head = not self._char_tweak.ignore_headshot and (attack_data.col_ray.headshot or self._head_body_name and not self._unit:in_slot(16) and attack_data.col_ray.body and attack_data.col_ray.body:name() == self._ids_head_body_name)
	if head and not weap_base.thrower_unit and self._unit:base():has_tag("tank") then
		mvector3.set(mvec_1, attack_data.col_ray.ray)
		mrotation.z(self._unit:movement():m_head_rot(), mvec_2)

		local not_from_the_front = mvector3.dot(mvec_1, mvec_2) >= 0

		if not_from_the_front then
			head = false
		end
	end
	attack_data.headshot = head

	local damage = attack_data.damage
	local headshot_by_player = false
	local headshot_multiplier = 1
	local distance = attack_data.col_ray.falloff_distance or attack_data.col_ray.distance or mvector3.distance(attack_data.origin, self._unit:position()) or 0
	if attacked_by_local_player then
		attack_data.backstab = self:check_backstab(attack_data)
		
		local damage_scale = 1
		if weap_base.last_hit_falloff then
			damage_scale = 0.5
		end		
		
		local critical_hit, crit_damage = self:roll_critical_hit(attack_data)
		if critical_hit then
			damage = crit_damage
			attack_data.critical_hit = true

			if damage > 0 then
				managers.hud:on_crit_confirmed(damage_scale)
			end
		else
			if damage > 0 then
				managers.hud:on_hit_confirmed(damage_scale)
			end
		end

		if self._char_tweak.priority_shout then
			damage = damage * managers.player:upgrade_value("weapon", "special_damage_taken_multiplier", 1)
		end

		if head then
			if self._helmet_popped then
				damage = damage * (weap_base.headshot_repeat_damage_mult or 1)
			end

			if not self._helmet_popped and managers.player:has_category_upgrade("weapon", "pop_helmets") then
				if self._unit:base()._tweak_table == "boom" then
					self._unit:damage():run_sequence_simple("grenadier_glass_break")
				else
					self:_spawn_head_gadget({
						position = attack_data.col_ray.body:position(),
						rotation = attack_data.col_ray.body:rotation(),
						dir = attack_data.col_ray.ray
					})
				end
				self._helmet_popped = true
			end

			managers.player:on_headshot_dealt(self._unit, attack_data)
		end
	end

	if head and not self._damage_reduction_multiplier then
		damage = damage * (self._char_tweak.headshot_dmg_mul or 1) * headshot_multiplier
	end
	
	if self._char_tweak.damage.bullet_damage_mul then
		damage = damage * self._char_tweak.damage.bullet_damage_mul
	end

	if self._marked_dmg_mul then
		damage = damage * self._marked_dmg_mul

		if self._marked_dmg_dist_mul then
			local spott_dst = tweak_data.upgrades.values.player.marked_inc_dmg_distance[self._marked_dmg_dist_mul]

			if spott_dst[1] < distance then
				damage = damage * spott_dst[2]
			end
		end
	end

	damage = self:_apply_damage_reduction(damage)

	if self._unit:base():char_tweak().DAMAGE_CLAMP_BULLET then
		damage = math.min(damage, self._char_tweak.DAMAGE_CLAMP_BULLET)
	end

	attack_data.raw_damage = damage

	if weap_base:is_category("saw") then
		managers.groupai:state():_voice_saw() --THAT MADMAN HAS A FUCKIN' SAW
	end

	if attacker:base().sentry_gun then
		managers.groupai:state():_voice_sentry() --FUCKING SCI-FI ROBOT GUNS
	end

	local damage_percent = 0
	if self:is_overhealed() then
		damage = (weap_base and weap_base.overhealed_damage_mul and weap_base:overhealed_damage_mul(distance) or 1) * damage
		damage = math_clamp(damage, 0, self._OVERHEALTH_INIT)
		damage_percent = math_ceil(damage / self._OVERHEALTH_INIT_PRECENT)
		damage = damage_percent * self._OVERHEALTH_INIT_PRECENT
	else
		damage = math_clamp(damage, 0, self._HEALTH_INIT)
		damage_percent = math_ceil(damage / self._HEALTH_INIT_PRECENT)
		damage = damage_percent * self._HEALTH_INIT_PRECENT
	end

	if self._immortal then
		damage = math.min(damage, self._health - 1)
	end

	if self._health <= damage then
		attack_data.damage = self._health

		if not (head and weap_base.can_ignore_medic_heals and weap_base:can_ignore_medic_heals(distance)) and self:check_medic_heal() then
			result = {
				type = "healed",
				variant = attack_data.variant
			}
			self._player_damage_ratio = 0
		else
			if head then
				managers.player:on_lethal_headshot_dealt(attacker, attack_data)

				if self._unit:base()._tweak_table == "boom" then
					self._unit:damage():run_sequence_simple("grenadier_glass_break")
				else
					if self._unit:damage() and self._unit:damage():has_sequence("squelch") then
						self._unit:damage():run_sequence_simple("squelch")
					end
					self:_spawn_head_gadget({
						position = attack_data.col_ray.body:position(),
						rotation = attack_data.col_ray.body:rotation(),
						dir = attack_data.col_ray.ray
					})
				end
			elseif Network:is_server() and self._char_tweak.gas_on_death then
				managers.groupai:state():detonate_cs_grenade(self._unit:movement():m_pos() + math.UP * 10, mvector3.copy(self._unit:movement():m_head_pos()), 7.5)
			end

			result = {
				type = "death",
				variant = attack_data.variant
			}

			if attack_data.backstab then
				managers.player:add_backstab_dodge()
			end

			self:die(attack_data)
			self:chk_killshot(attacker, "bullet", head and attacked_by_local_player)
		end
	else
		attack_data.damage = damage

		local result_type = nil

		if not self._char_tweak.immune_to_knock_down then
			if attack_data.knock_down then
				result_type = "knock_down"
			elseif attack_data.stagger and not self._has_been_staggered then
				result_type = "stagger"
				self._has_been_staggered = true
			end
		end

		if not result_type then
			result_type = self:get_damage_type(damage_percent, "bullet")
		end

		result = {
			type = result_type,
			variant = attack_data.variant
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.result = result
	attack_data.pos = attack_data.col_ray.position

	if result.type == "death" then
		local data = {
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			head_shot = head,
			weapon_unit = attack_data.weapon_unit,
			variant = attack_data.variant
		}		

		managers.statistics:killed_by_anyone(data)

		if attacked_by_local_player then
			local special_comment = self:_check_special_death_conditions(attack_data.variant, attack_data.col_ray.body, attacker, attack_data.weapon_unit)

			self:_comment_death(attacker, self._unit, special_comment)
			self:_show_death_hint(self._unit:base()._tweak_table)

			local attacker_state = managers.player:current_state()
			data.attacker_state = attacker_state

			managers.statistics:killed(data)
			self:_check_damage_achievements(attack_data, head)

			if not is_civilian and managers.player:has_category_upgrade("temporary", "overkill_damage_multiplier") and not weap_base.thrower_unit and weap_base:is_category("shotgun", "saw") then
				managers.player:activate_temporary_upgrade("temporary", "overkill_damage_multiplier")
			end

			if is_civilian then
				managers.money:civilian_killed()
			end
		elseif attacker:base().sentry_gun then
			if Network:is_server() then
				local server_info = weap_base:server_information()

				if server_info and server_info.owner_peer_id ~= managers.network:session():local_peer():id() then
					local owner_peer = managers.network:session():peer(server_info.owner_peer_id)

					if owner_peer then
						owner_peer:send_queued_sync("sync_player_kill_statistic", data.name, data.head_shot and true or false, data.weapon_unit, data.variant, data.stats_name)
					end
				else
					data.attacker_state = managers.player:current_state()

					managers.statistics:killed(data)
				end
			end

			local sentry_attack_data = deep_clone(attack_data)
			sentry_attack_data.attacker_unit = attacker:base():get_owner()

			if sentry_attack_data.attacker_unit == managers.player:player_unit() then
				self:_check_damage_achievements(sentry_attack_data, head)
			else
				self._unit:network():send("sync_damage_achievements", sentry_attack_data.weapon_unit, sentry_attack_data.attacker_unit, sentry_attack_data.damage, sentry_attack_data.col_ray and sentry_attack_data.col_ray.distance, head)
			end
		elseif managers.groupai:state():is_unit_team_AI(attacker) then
			local special_comment = self:_check_special_death_conditions(attack_data.variant, attack_data.col_ray.body, attacker, weap_unit)
			self:_AI_comment_death(attacker, self._unit, special_comment)
		end
	end

	local hit_offset_height = math.clamp(attack_data.col_ray.position.z - self._unit:position().z, 0, 300)
	if not attacker or not alive(attacker) or attacker:id() == -1 then
		attacker = self._unit
	end

	if weap_base.add_damage_result then
		weap_base:add_damage_result(self._unit, result.type == "death", attacker, damage_percent) --add bow and arrow base checks
	end

	local i_result = nil
	if result.type == "healed" then
		i_result = 1
	else
		i_result = 0
	end

	self:_send_bullet_attack_result(attack_data, attacker, damage_percent, body_index, hit_offset_height, i_result)
	self:_on_damage_received(attack_data)

	if not is_civilian then
		managers.player:enemy_shot(self._unit, attack_data)
	end

	result.attack_data = attack_data

	return result
end

function CopDamage:sync_damage_bullet(attacker_unit, damage_percent, i_body, hit_offset_height, i_result, death)
	if self._dead then
		return
	end

	local attack_data = {
		variant = "bullet",
		attacker_unit = attacker_unit
	}

	local from_pos, attack_dir, result = nil
	local body = self._unit:body(i_body)
	local head = self._head_body_name and not self._unit:in_slot(16) and not self._char_tweak.ignore_headshot and body and body:name() == self._ids_head_body_name
	local hit_pos = mvec3_cpy(body:position())
	attack_data.pos = hit_pos

	if attacker_unit then
		from_pos = attacker_unit:movement().m_detect_pos and attacker_unit:movement():m_detect_pos() or attacker_unit:movement():m_head_pos()

		attack_dir = hit_pos - from_pos
		mvec3_norm(attack_dir)
	else
		attack_dir = -self._unit:rotation():y()
	end

	attack_data.attack_dir = attack_dir

	local damage = 0
	if self:is_overhealed() then
		damage = damage_percent * self._OVERHEALTH_INIT_PRECENT
	else
		damage = damage_percent * self._HEALTH_INIT_PRECENT
	end
	attack_data.damage = damage

	if death then
		attack_data.damage = self._health

		if head then
			if self._unit:base()._tweak_table == "boom" then
				self._unit:damage():run_sequence_simple("grenadier_glass_break")
			else
				if self._unit:damage() and self._unit:damage():has_sequence("squelch") then
					self._unit:damage():run_sequence_simple("squelch")
				end			
				self:_spawn_head_gadget({
					position = body:position(),
					rotation = body:rotation(),
					dir = attack_dir
				})
			end
		elseif Network:is_server() and self._char_tweak.gas_on_death then
			managers.groupai:state():detonate_cs_grenade(self._unit:movement():m_pos() + math_UP * 10, mvec3_cpy(self._unit:movement():m_head_pos()), 7.5)
		end

		result = {
			variant = "bullet",
			type = "death"
		}

		self:die(attack_data)
		self:chk_killshot(attacker_unit, "bullet")

		local data = {
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			head_shot = head,
			weapon_unit = attacker_unit and attacker_unit:inventory() and attacker_unit:inventory():equipped_unit(),
			variant = attack_data.variant
		}

		if data.weapon_unit then
			self:_check_special_death_conditions("bullet", body, attacker_unit, data.weapon_unit)
			managers.statistics:killed_by_anyone(data)
		end
	else
		local result_type = "dmg_rcv"

		if i_result == 1 then
			result_type = "healed"

			attack_data.damage = self._health
		else
			self:_apply_damage_to_health(damage)
		end

		result = {
			variant = "bullet",
			type = result_type
		}
	end

	attack_data.result = result
	attack_data.is_synced = true

	if not self._no_blood and damage > 0 then
		managers.game_play_central:sync_play_impact_flesh(hit_pos, attack_dir)
	end

	self:_on_damage_received(attack_data)
end

function CopDamage:damage_melee(attack_data)
	if self._dead or self._invulnerable then
		return
	end

	if self:is_friendly_fire(attack_data.attacker_unit) then
		return "friendly_fire"
	end

	if alive(attack_data.attacker_unit) and attack_data.attacker_unit:in_slot(16) then
		local has_surrendered = self._unit:brain().surrendered and self._unit:brain():surrendered() or self._unit:anim_data().surrender or self._unit:anim_data().hands_back or self._unit:anim_data().hands_tied

		if has_surrendered then
			return
		end
	end

	local result = nil
	local is_civilian, is_gangster, is_cop = nil

	if CopDamage.is_civilian(self._unit:base()._tweak_table) then
		is_civilian = true
	elseif CopDamage.is_gangster(self._unit:base()._tweak_table) then
		is_gangster = true
	else
		is_cop = true
	end

	local head = self._head_body_name and not self._unit:in_slot(16) and not self._char_tweak.ignore_headshot and attack_data.col_ray.body and attack_data.col_ray.body:name() == self._ids_head_body_name
	local headshot_multiplier = attack_data.headshot_multiplier or 1
	local damage = attack_data.damage

	--Non-bludgeoning melee hits at body armor deal no damage.
	if self._has_plate and attack_data.col_ray.body and attack_data.col_ray.body:name() == self._ids_plate_name then
		if attack_data.armor_piercing then
			World:effect_manager():spawn({
				effect = Idstring("effects/payday2/particles/impacts/blood/blood_impact_a"),
				position = attack_data.col_ray.position,
				normal = attack_data.col_ray.ray
			})
		else
			World:effect_manager():spawn({
				effect = Idstring("effects/payday2/particles/impacts/steel_no_decal_impact_pd2"),
				position = attack_data.col_ray.position,
				normal = attack_data.col_ray.ray
			})			

			--Armor Impact sound AAAAAAAAAAA
			if attack_data.attacker_unit == managers.player:player_unit() then
				self._unit:sound():play("knuckles_hit_gen", nil, nil)
				damage = 0
			end
		end
	end

	--Damage effect always acts like it has a headshot.
	local damage_effect = attack_data.damage_effect * (self._char_tweak.headshot_dmg_mul or 2)

	if attack_data.attacker_unit == managers.player:player_unit() then
		attack_data.backstab = self:check_backstab(attack_data)

		if attack_data.backstab and attack_data.backstab_multiplier then
			damage = damage * attack_data.backstab_multiplier
		end

		local critical_hit, crit_damage = self:roll_critical_hit(attack_data)

		if critical_hit then
			damage = crit_damage

			local critical_hits = self._char_tweak.critical_hits or {}
			local critical_damage_mul = critical_hits.damage_mul or self._char_tweak.headshot_dmg_mul

			attack_data.critical_hit = true

			if damage > 0 then
				managers.hud:on_crit_confirmed()
			end
		else
			if damage > 0 then
				managers.hud:on_hit_confirmed()
			end
		end

		if tweak_data.achievement.cavity.melee_type == attack_data.name_id and not is_civilian then
			managers.achievment:award(tweak_data.achievement.cavity.award)
		end

		if self._char_tweak.priority_shout then
			damage = damage * managers.player:upgrade_value("weapon", "special_damage_taken_multiplier", 1)
		end

		if head then
			if not self._helmet_popped and managers.player:has_category_upgrade("weapon", "pop_helmets") then
				if self._unit:base()._tweak_table == "boom" then
					self._unit:damage():run_sequence_simple("grenadier_glass_break")
				else
					self:_spawn_head_gadget({
						position = attack_data.col_ray.body:position(),
						rotation = attack_data.col_ray.body:rotation(),
						dir = attack_data.col_ray.ray
					})
				end
				self._helmet_popped = true
			end

			headshot_multiplier = headshot_multiplier * managers.player:upgrade_value("weapon", "passive_headshot_damage_multiplier", 1)
			managers.player:on_headshot_dealt(self._unit, attack_data)
		end
	end

	if head and not self._damage_reduction_multiplier then
		if self._char_tweak.headshot_dmg_mul then
			headshot_multiplier = math_max(self._char_tweak.headshot_dmg_mul * headshot_multiplier, 1)
			damage = damage * headshot_multiplier
		else
			damage = self._health * 2
		end
	end

	if self._marked_dmg_mul then
		damage = damage * self._marked_dmg_mul
	end

	if self._char_tweak.damage.melee_damage_mul then
		damage = damage * self._char_tweak.damage.melee_damage_mul
		damage_effect = damage_effect * self._char_tweak.damage.melee_damage_mul
	end

	damage = self:_apply_damage_reduction(damage)
	attack_data.raw_damage = damage

	local damage_percent = 0
	local damage_effect_percent = 0
	if self:is_overhealed() then
		damage = math_clamp(damage, 0, self._OVERHEALTH_INIT)
		damage_effect = math_clamp(damage_effect, 0, self._OVERHEALTH_INIT)
		damage_percent = math_ceil(damage / self._OVERHEALTH_INIT_PRECENT)
		damage_effect_percent = math_ceil(damage_effect / self._OVERHEALTH_INIT_PRECENT)
		damage = damage_percent * self._OVERHEALTH_INIT_PRECENT
		damage_effect = damage_effect_percent * self._OVERHEALTH_INIT_PRECENT
	else
		damage = math_clamp(damage, 0, self._HEALTH_INIT)
		damage_effect = math_clamp(damage_effect, 0, self._HEALTH_INIT)
		damage_percent = math_ceil(damage / self._HEALTH_INIT_PRECENT)
		damage_effect_percent = math_ceil(damage_effect / self._HEALTH_INIT_PRECENT)
		damage = damage_percent * self._HEALTH_INIT_PRECENT
		damage_effect = damage_effect_percent * self._HEALTH_INIT_PRECENT
	end	

	if self._immortal then
		damage = math_min(damage, self._health - 1)
		damage_effect = math_min(damage_effect, self._health - 1)
	end

	if self._health <= damage then
		damage_effect_percent = 1
		attack_data.damage = self._health
		attack_data.damage_effect = self._health

		if self:check_medic_heal() then
			result = {
				type = "healed",
				variant = "melee"
			}
			self._player_damage_ratio = 0
		else
			if head then
				if self._unit:base()._tweak_table == "boom" then
					self._unit:damage():run_sequence_simple("grenadier_glass_break")
				else
					self:_spawn_head_gadget({
						position = attack_data.col_ray.body:position(),
						rotation = attack_data.col_ray.body:rotation(),
						dir = attack_data.col_ray.ray
					})
				end
			end

			result = {
				type = "death",
				variant = "melee"
			}

			if attack_data.backstab then
				managers.player:add_backstab_dodge()
			end

			self:die(attack_data)
			self:chk_killshot(attack_data.attacker_unit, "melee")
		end
	else
		attack_data.damage = damage
		attack_data.damage_effect = damage_effect

		local result_type = nil

		if attack_data.shield_knock then
			result_type = "shield_knock"
		elseif attack_data.variant == "counter_tased" then
			result_type = "counter_tased"
		elseif attack_data.variant == "taser_tased" then
			if self._char_tweak.can_be_tased == nil or self._char_tweak.can_be_tased then
				result_type = "taser_tased"

				if attack_data.charge_lerp_value then
					local charge_power = math_lerp(0, 1, attack_data.charge_lerp_value)

					damage_effect_percent = charge_power
					self._tased_time = math_lerp(1, 5, charge_power)
					self._tased_down_time = self._tased_time * 2
				else
					damage_effect_percent = 0.4
					self._tased_time = 2
					self._tased_down_time = self._tased_time * 2
				end
			end
		elseif attack_data.variant == "counter_spooc" then
			result_type = "expl_hurt"
		end

		if not result_type then
			result_type = self:get_damage_type(damage_effect_percent, "melee")
		end

		result = {
			type = result_type,
			variant = "melee"
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.variant = "melee"
	attack_data.result = result
	attack_data.pos = attack_data.col_ray.position

	local snatch_pager, from_behind = nil

	if result.type == "death" then
		local data = {
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			head_shot = head,
			weapon_unit = attack_data.weapon_unit,
			name_id = attack_data.name_id,
			variant = "melee"
		}

		managers.statistics:killed_by_anyone(data)

		if attack_data.attacker_unit == managers.player:player_unit() then
			local special_comment = self:_check_special_death_conditions("melee", attack_data.col_ray.body, attack_data.attacker_unit, attack_data.name_id)

			self:_comment_death(attack_data.attacker_unit, self._unit, special_comment)
			self:_show_death_hint(self._unit:base()._tweak_table)
			managers.statistics:killed(data)

			if is_civilian then
				managers.money:civilian_killed()
			else
				if managers.groupai:state():whisper_mode() and managers.blackmarket:equipped_mask().mask_id == tweak_data.achievement.cant_hear_you_scream.mask then
					managers.achievment:award_progress(tweak_data.achievement.cant_hear_you_scream.stat)
				end

				if is_cop and Global.game_settings.level_id == "nightclub" and attack_data.name_id and attack_data.name_id == "fists" then
					managers.achievment:award_progress(tweak_data.achievement.final_rule.stat)
				end

				mvec3_set(mvec_1, self._unit:position())
				mvec3_sub(mvec_1, attack_data.attacker_unit:position())
				mvec3_norm(mvec_1)
				mvec3_set(mvec_2, self._unit:rotation():y())

				from_behind = mvec3_dot(mvec_1, mvec_2) >= 0

				local job = Global.level_data and Global.level_data.level_id

				if job == "short1_stage1" or job == "short1_stage2" then
					--Just in case, cause otherwise it apparently screws everything up
					snatch_pager = false
				else
					if managers.player:upgrade_value("player", "melee_kill_snatch_pager_chance", 0) > math_rand(1) then
						if self._unit:movement():cool() then
							snatch_pager = true
							self._unit:unit_data().has_alarm_pager = false
						else
							local not_cool_t = self._unit:movement().not_cool_t and self._unit:movement():not_cool_t()
							local t = TimerManager:game():time()

							if not not_cool_t or t - not_cool_t < 0.75 then
								snatch_pager = true
								self._unit:unit_data().has_alarm_pager = false
							end
						end
					end
				end
			end
		elseif managers.groupai:state():is_unit_team_AI(attack_data.attacker_unit) then
			local special_comment = self:_check_special_death_conditions("melee", attack_data.col_ray.body, attack_data.attacker_unit, attack_data.name_id)

			self:_AI_comment_death(attack_data.attacker_unit, self._unit, special_comment)
		end
	end

	if attack_data.attacker_unit == managers.player:player_unit() and alive(attack_data.attacker_unit) and tweak_data.blackmarket.melee_weapons[attack_data.name_id] then
		local achievements = tweak_data.achievement.enemy_melee_hit_achievements or {}
		local melee_type = tweak_data.blackmarket.melee_weapons[attack_data.name_id].type
		local enemy_base = self._unit:base()
		local enemy_movement = self._unit:movement()
		local enemy_type = enemy_base._tweak_table
		local unit_weapon = enemy_base._default_weapon_id
		local health_ratio = managers.player:player_unit():character_damage():health_ratio() * 100
		local melee_pass, melee_weapons_pass, type_pass, enemy_pass, enemy_weapon_pass, diff_pass, health_pass, level_pass, job_pass, jobs_pass, enemy_count_pass, tags_all_pass, tags_any_pass, all_pass, cop_pass, gangster_pass, civilian_pass, stealth_pass, on_fire_pass, behind_pass, result_pass, mutators_pass, critical_pass, action_pass, is_dropin_pass, style_pass = nil

		for achievement, achievement_data in pairs(achievements) do
			melee_pass = not achievement_data.melee_id or achievement_data.melee_id == attack_data.name_id
			melee_weapons_pass = not achievement_data.melee_weapons or table.contains(achievement_data.melee_weapons, attack_data.name_id)
			type_pass = not achievement_data.melee_type or melee_type == achievement_data.melee_type
			result_pass = not achievement_data.result or attack_data.result.type == achievement_data.result
			enemy_pass = not achievement_data.enemy or enemy_type == achievement_data.enemy
			enemy_weapon_pass = not achievement_data.enemy_weapon or unit_weapon == achievement_data.enemy_weapon
			behind_pass = not achievement_data.from_behind or from_behind
			diff_pass = not achievement_data.difficulty or table.contains(achievement_data.difficulty, Global.game_settings.difficulty)
			health_pass = not achievement_data.health or health_ratio <= achievement_data.health
			level_pass = not achievement_data.level_id or (managers.job:current_level_id() or "") == achievement_data.level_id
			job_pass = not achievement_data.job or managers.job:current_real_job_id() == achievement_data.job
			jobs_pass = not achievement_data.jobs or table.contains(achievement_data.jobs, managers.job:current_real_job_id())
			enemy_count_pass = not achievement_data.enemy_kills or achievement_data.enemy_kills.count <= managers.statistics:session_enemy_killed_by_type(achievement_data.enemy_kills.enemy, "melee")
			tags_all_pass = not achievement_data.enemy_tags_all or enemy_base:has_all_tags(achievement_data.enemy_tags_all)
			tags_any_pass = not achievement_data.enemy_tags_any or enemy_base:has_any_tag(achievement_data.enemy_tags_any)
			cop_pass = not achievement_data.is_cop or is_cop
			gangster_pass = not achievement_data.is_gangster or is_gangster
			civilian_pass = not achievement_data.is_not_civilian or not is_civilian
			stealth_pass = not achievement_data.is_stealth or managers.groupai:state():whisper_mode()
			on_fire_pass = not achievement_data.is_on_fire or managers.fire:is_set_on_fire(self._unit)
			is_dropin_pass = achievement_data.is_dropin == nil or achievement_data.is_dropin == managers.statistics:is_dropin()
			style_pass = not achievement_data.player_style or achievement_data.player_style.style == managers.blackmarket:equipped_player_style() and (not achievement_data.player_style.variation or achievement_data.player_style.variation == managers.blackmarket:equipped_suit_variation())

			if achievement_data.enemies then
				enemy_pass = false

				for _, enemy in pairs(achievement_data.enemies) do
					if enemy == enemy_type then
						enemy_pass = true

						break
					end
				end
			end

			mutators_pass = managers.mutators:check_achievements(achievement_data)
			critical_pass = not achievement_data.critical

			if achievement_data.critical then
				critical_pass = attack_data.critical_hit
			end

			action_pass = true

			if achievement_data.action then
				local action = enemy_movement:get_action(achievement_data.action.body_part)
				local action_type = action and action:type()
				action_pass = action_type == achievement_data.action.type
			end

			all_pass = melee_pass and melee_weapons_pass and type_pass and enemy_pass and enemy_weapon_pass and behind_pass and diff_pass and health_pass and level_pass and job_pass and jobs_pass and cop_pass and gangster_pass and civilian_pass and stealth_pass and on_fire_pass and enemy_count_pass and tags_all_pass and tags_any_pass and result_pass and mutators_pass and critical_pass and action_pass and is_dropin_pass and style_pass

			if all_pass then
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

	local attacker = attack_data.attacker_unit

	if not attacker or not alive(attacker) or attacker:id() == -1 then
		attack_data.attacker_unit = self._unit
	end

	local hit_offset_height = math_clamp(attack_data.col_ray.position.z - self._unit:position().z, 0, 300)
	local i_result = 0

	if snatch_pager then
		i_result = 3
	elseif result.type == "taser_tased" then
		i_result = 2
	elseif result.type == "healed" then
		i_result = 1
	end

	local body_index = self._unit:get_body_index(attack_data.col_ray.body:name())

	self:_send_melee_attack_result(attack_data, damage_percent, damage_effect_percent, hit_offset_height, i_result, body_index)
	self:_on_damage_received(attack_data)

	if not is_civilian then
		managers.player:enemy_hit(self._unit, attack_data)
	end

	return result
end

function CopDamage:sync_damage_melee(attacker_unit, damage_percent, damage_effect_percent, i_body, hit_offset_height, i_result, death)
	if self._dead then
		return
	end

	local attack_data = {
		variant = "melee",
		attacker_unit = attacker_unit
	}
	local result, attack_dir = nil
	local body = self._unit:body(i_body)
	local head = self._head_body_name and not self._unit:in_slot(16) and not self._char_tweak.ignore_headshot and body and body:name() == self._ids_head_body_name
	local hit_pos = mvec3_cpy(body:position())
	attack_data.pos = hit_pos

	if attacker_unit then
		local from_pos = attacker_unit:movement().m_detect_pos and attacker_unit:movement():m_detect_pos() or attacker_unit:movement():m_head_pos()

		attack_dir = hit_pos - from_pos
		mvec3_norm(attack_dir)
	else
		attack_dir = -self._unit:rotation():y()
	end

	attack_data.attack_dir = attack_dir

	local damage = 0
	local damage_effect = 0
	if self:is_overhealed() then
		damage = damage_percent * self._OVERHEALTH_INIT_PRECENT
		damage_effect = damage_effect_percent * self._OVERHEALTH_INIT_PRECENT
	else
		damage = damage_percent * self._HEALTH_INIT_PRECENT
		damage_effect = damage_effect_percent * self._HEALTH_INIT_PRECENT
	end
	attack_data.damage = damage
	attack_data.damage_effect = damage_effect

	if death then
		attack_data.damage = self._health
		attack_data.damage_effect = self._health

		if head then
			if self._unit:base()._tweak_table == "boom" then
				self._unit:damage():run_sequence_simple("grenadier_glass_break")
			else
				self:_spawn_head_gadget({
					position = body:position(),
					rotation = body:rotation(),
					dir = attack_dir
				})
			end
		end

		local melee_name_id = nil
		local valid_attacker = attacker_unit and attacker_unit:base()

		if valid_attacker then
			if attacker_unit:base().is_husk_player then
				local peer_id = managers.network:session():peer_by_unit(attacker_unit):id()
				local peer = managers.network:session():peer(peer_id)

				melee_name_id = peer:melee_id()
			else
				melee_name_id = attacker_unit:base().melee_weapon and attacker_unit:base():melee_weapon()
			end

			if melee_name_id then
				self:_check_special_death_conditions("melee", body, attacker_unit, melee_name_id)
			end
		end

		result = {
			variant = "melee",
			type = "death"
		}

		self:die(attack_data)
		self:chk_killshot(attacker_unit, "melee")

		local data = {
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			name_id = melee_name_id,
			variant = "melee"
		}

		managers.statistics:killed_by_anyone(data)
	else
		local result_type = "dmg_rcv"

		if i_result == 1 then
			result_type = "healed"

			attack_data.damage = self._health
			attack_data.damage_effect = self._health
		else
			self:_apply_damage_to_health(damage)

			if i_result == 2 then
				self._tased_time = math_lerp(1, 5, damage_effect_percent)
				self._tased_down_time = self._tased_time * 2
			end
		end

		result = {
			variant = "melee",
			type = result_type
		}
	end

	attack_data.result = result
	attack_data.is_synced = true

	if i_result == 3 then
		self._unit:unit_data().has_alarm_pager = false
	end

	if not self._no_blood and damage > 0 then
		managers.game_play_central:sync_play_impact_flesh(hit_pos, attack_dir)
	end

	self:_on_damage_received(attack_data)
end

local old_death = CopDamage.die
function CopDamage:die(attack_data)
	--Increment skirmish kill counter.
	if managers.skirmish:is_skirmish() then
		managers.skirmish:do_kill()
	end

	if not self._char_tweak.always_drop and self._pickup == "ammo" then
		local attacker_unit = attack_data.thrower_unit or attack_data.attacker_unit

		if alive(attacker_unit) and managers.groupai:state():is_unit_team_AI(attacker_unit) then
			local roll = math_random()
			local ammo_chance = 0.2 + self._player_damage_ratio --Enemy bot ammo drop chance increases based on the amount of damage dealy by a player.
			--80% of health damage leading to kill dealt by a player == 100% chance to drop ammo.
			--0% of health damage leading to kill dealt by a player == 20% chance to drop ammo.

			if roll >= ammo_chance then
				self:set_pickup()
			end
		end
	end

	old_death(self, attack_data)

	if self._unit:interaction().tweak_data == "hostage_convert" then
		self._unit:interaction():set_active(false, true, false)
	end

	if self._char_tweak.ends_assault_on_death then
		if managers.groupai:state()._silent_endless then
			managers.groupai:state()._silent_endless = nil
		end
		
		managers.groupai:state():force_end_assault_phase()
		managers.hud:set_buff_enabled("vip", false)
	end

	if self._unit:contour() then
		self._unit:contour():remove("omnia_heal", false)
		self._unit:contour():remove("medic_show", false)
		self._unit:contour():remove("medic_buff", false)
	end

	if self._unit:base()._tweak_table == "spooc" then
		self._unit:damage():run_sequence_simple("kill_spook_lights")
	end

	if self._char_tweak.failure_on_death then
		if managers.platform:presence() == "Playing" then
			managers.network:session():send_to_peers("mission_ended", false)
			game_state_machine:change_state_by_name("gameoverscreen")
		end
	end

	if self._char_tweak.do_autumn_blackout then
		managers.groupai:state():unregister_blackout_source(self._unit)
	end

	if self._char_tweak.die_sound_event_2 then
		self._unit:sound():play(self._char_tweak.die_sound_event_2, nil, true)
	end

	if self._unit:base()._tweak_table == "boom" then
		local boom_boom = false
		boom_boom = managers.modifiers:modify_value("CopDamage:CanBoomBoom", boom_boom)
		if boom_boom then
			MutatorExplodingEnemies._detonate(MutatorExplodingEnemies, self, attack_data, true, 60, 500)
		end
	end
end

function CopDamage:heal_unit(...)
	log("THIS COP NEEDS TO USE MEDIC DAMAGE: " .. self._unit:base()._tweak_table)
	MedicDamage.heal_unit(self, ...)
end

function CopDamage:stun_hit(attack_data)
	if self._dead or self._invulnerable or self._unit:in_slot(16, 21, 22) then
		return
	else
		local anim_data = self._unit:anim_data()

		if anim_data and anim_data.act then
			return
		else
			if self._unit:brain().surrendered and self._unit:brain():surrendered() then
				return
			elseif anim_data then
				if anim_data.surrender or anim_data.hands_back or anim_data.hands_tied then
					return
				end
			end
		end
	end

	local attacker_unit = attack_data.attacker_unit

	if attacker_unit and attacker_unit:base() and attacker_unit:base().thrower_unit then
		attacker_unit = attacker_unit:base():thrower_unit()
	end

	if self:is_friendly_fire(attacker_unit) then
		return "friendly_fire"
	end

	local attacker = attack_data.attacker_unit

	if not attacker or not alive(attacker) or attacker:id() == -1 then
		attacker = self._unit
	end

	local result_type = "concussion"

	if self._char_tweak.tank_concussion then
		result_type = "expl_hurt"
	end

	local result = {
		type = result_type,
		variant = attack_data.variant
	}
	attack_data.result = result
	attack_data.pos = attack_data.col_ray.position

	self:_send_stun_attack_result(attacker, 0, self:_get_attack_variant_index(attack_data.variant), attack_data.col_ray.ray)
	self:_on_damage_received(attack_data)
	self:_create_stun_exit_clbk()

	return result
end

function CopDamage:sync_damage_stun(attacker_unit, damage_percent, i_attack_variant, death, direction)
	if self._dead then
		return
	end

	local variant = CopDamage._ATTACK_VARIANTS[i_attack_variant]
	local attack_data = {
		variant = variant,
		attacker_unit = attacker_unit
	}

	local hit_pos = mvec3_cpy(self._unit:position())
	mvec3_set_z(hit_pos, hit_pos.z + 100)

	local attack_dir = nil

	if direction then
		attack_dir = direction
	elseif attacker_unit then
		attack_dir = self._unit:position() - attacker_unit:position()
		mvec3_norm(attack_dir)
	else
		attack_dir = -self._unit:rotation():y()
	end

	attack_data.attack_dir = attack_dir
	hit_pos = hit_pos - attack_dir * 5
	attack_data.pos = hit_pos

	local result = {
		type = "concussion",
		variant = variant
	}
	attack_data.result = result
	attack_data.is_synced = true

	self:_on_damage_received(attack_data)
	self:_create_stun_exit_clbk()
end

function CopDamage:damage_explosion(attack_data)
	if self._dead or self._invulnerable then
		return
	end

	if attack_data.weapon_unit and alive(attack_data.weapon_unit) then
		if attack_data.weapon_unit:base() and attack_data.weapon_unit:base()._variant == "explosion" and not attack_data.weapon_unit:base()._thrower_unit then
			-- no friendly fire >:(
			return
		end
	end

	local attacker_unit = attack_data.attacker_unit
	local weap_unit = attack_data.weapon_unit

	if attacker_unit and alive(attacker_unit) then
		if attacker_unit:base() and attacker_unit:base().thrower_unit then
			attacker_unit = attacker_unit:base():thrower_unit()
			weap_unit = attack_data.attacker_unit
		end

		if self:is_friendly_fire(attacker_unit) then
			return "friendly_fire"
		end
	end

	local is_civilian = CopDamage.is_civilian(self._unit:base()._tweak_table)
	local result = nil
	local damage = attack_data.damage
	
	if self._char_tweak.damage.explosion_damage_mul then
		damage = damage * self._char_tweak.damage.explosion_damage_mul
	end

	if self._marked_dmg_mul then
		damage = damage * self._marked_dmg_mul

		if self._marked_dmg_dist_mul and alive(attacker_unit) then
			local dst = mvec3_dis(attacker_unit:position(), self._unit:position())
			local spott_dst = tweak_data.upgrades.values.player.marked_inc_dmg_distance[self._marked_dmg_dist_mul]

			if spott_dst[1] < dst then
				damage = damage * spott_dst[2]
			end
		end
	end

	damage = managers.modifiers:modify_value("CopDamage:DamageExplosion", damage, self._unit)
	damage = self:_apply_damage_reduction(damage)

	if attacker_unit == managers.player:player_unit() and damage > 0 and attack_data.variant ~= "stun" then
		managers.hud:on_hit_confirmed()
	end

	if self._char_tweak.DAMAGE_CLAMP_EXPLOSION then
		damage = math_min(damage, self._char_tweak.DAMAGE_CLAMP_EXPLOSION)
	end

	attack_data.raw_damage = damage

	local damage_percent = 0
	if self:is_overhealed() then
		damage = math_clamp(damage, 0, self._OVERHEALTH_INIT)
		damage_percent = math_ceil(damage / self._OVERHEALTH_INIT_PRECENT)
		damage = damage_percent * self._OVERHEALTH_INIT_PRECENT
	else
		damage = math_clamp(damage, 0, self._HEALTH_INIT)
		damage_percent = math_ceil(damage / self._HEALTH_INIT_PRECENT)
		damage = damage_percent * self._HEALTH_INIT_PRECENT
	end	

	if self._immortal then
		damage = math_min(damage, self._health - 1)
	end

	if self._health <= damage then
		attack_data.damage = self._health

		if self:check_medic_heal() then
			result = {
				type = "healed",
				variant = attack_data.variant
			}
			self._player_damage_ratio = 0
		else
			result = {
				type = "death",
				variant = attack_data.variant
			}

			self:die(attack_data)
		end
	else
		attack_data.damage = damage

		local result_type = attack_data.variant == "stun" and "hurt_sick" or self:get_damage_type(damage_percent, "explosion")

		result = {
			type = result_type,
			variant = attack_data.variant
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.result = result
	attack_data.pos = attack_data.col_ray.position
	result.ignite_character = attack_data.ignite_character

	if result.type == "death" then
		local data = {
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			owner = attack_data.owner,
			weapon_unit = weap_unit,
			variant = attack_data.variant
		}

		managers.statistics:killed_by_anyone(data)

		if attack_data.variant ~= "stun" then
			if self._unit:base()._tweak_table == "boom" then
				self._unit:damage():run_sequence_simple("grenadier_glass_break")
			elseif self._head_body_name then
				local body = self._unit:body(self._head_body_name)

				self:_spawn_head_gadget({
					skip_push = true,
					position = body:position(),
					rotation = body:rotation()
				})
			end
		end

		if Network:is_server() and self._char_tweak.gas_on_death then
			managers.groupai:state():detonate_cs_grenade(self._unit:movement():m_pos() + math_UP * 10, mvec3_cpy(self._unit:movement():m_head_pos()), 7.5)
		end

		if not is_civilian and managers.player:has_category_upgrade("temporary", "overkill_damage_multiplier") and attacker_unit == managers.player:player_unit() and attack_data.weapon_unit and attack_data.weapon_unit:base().weapon_tweak_data and not attack_data.weapon_unit:base().thrower_unit and attack_data.weapon_unit:base():is_category("shotgun", "saw") then
			managers.player:activate_temporary_upgrade("temporary", "overkill_damage_multiplier")
		end

		self:chk_killshot(attacker_unit, "explosion")

		if attacker_unit == managers.player:player_unit() then
			if alive(attacker_unit) then
				self:_comment_death(attacker_unit, self._unit)
			end

			self:_show_death_hint(self._unit:base()._tweak_table)
			managers.statistics:killed(data)

			if is_civilian then
				managers.money:civilian_killed()
			end

			self:_check_damage_achievements(attack_data, false)
		else
			if attacker_unit and alive(attacker_unit) and managers.groupai:state():is_unit_team_AI(attacker_unit) then
				self:_AI_comment_death(attacker_unit, self._unit)
			end
		end
	end

	if alive(weap_unit) and weap_unit:base() and weap_unit:base().add_damage_result then
		weap_unit:base():add_damage_result(self._unit, result.type == "death", attacker_unit, damage_percent)
	end

	if attack_data.variant ~= "stun" and not self._no_blood and damage > 0 then
		managers.game_play_central:sync_play_impact_flesh(attack_data.pos, attack_data.col_ray.ray)
	end

	local attacker = attack_data.attacker_unit

	if not attacker or not alive(attacker) or attacker:id() == -1 then
		attacker = self._unit
	end

	local sync_attack_variant = attack_data.variant

	if result.type == "healed" then
		sync_attack_variant = "healed"
	end

	self:_send_explosion_attack_result(attack_data, attacker, damage_percent, self:_get_attack_variant_index(sync_attack_variant), attack_data.col_ray.ray)
	self:_on_damage_received(attack_data)

	if not is_civilian and attacker_unit and alive(attacker_unit) then
		managers.player:enemy_shot(self._unit, attack_data)
	end

	return result
end

function CopDamage:sync_damage_explosion(attacker_unit, damage_percent, i_attack_variant, death, direction, weapon_unit)
	if self._dead then
		return
	end

	local variant = CopDamage._ATTACK_VARIANTS[i_attack_variant]
	local was_healed = nil

	if variant == "healed" then
		variant = "explosion"
		was_healed = true
	end

	local attack_data = {
		variant = variant,
		attacker_unit = attacker_unit,
		weapon_unit = weapon_unit
	}

	local attacker = attack_data.attacker_unit
	local weapon_unit = weapon_unit

	if attacker and attacker:base() and attacker:base().thrower_unit then
		attacker = attacker:base():thrower_unit()
		weapon_unit = attack_data.attacker_unit
	end

	if not weapon_unit then
		weapon_unit = attacker_unit and attacker_unit:inventory() and alive(attacker_unit:inventory():equipped_unit()) and attacker_unit:inventory():equipped_unit()
	end

	local hit_pos = mvec3_cpy(self._unit:position())
	mvec3_set_z(hit_pos, hit_pos.z + 100)

	local attack_dir, result = nil

	if direction then
		attack_dir = direction
	elseif attacker_unit then
		local from_pos = nil

		if attacker_unit:movement() then
			if attacker_unit:movement().m_detect_pos then
				from_pos = attacker_unit:movement():m_detect_pos()
			elseif attacker_unit:movement().m_head_pos then
				from_pos = attacker_unit:movement():m_head_pos()
			else
				from_pos = attacker_unit:position()
			end
		else
			from_pos = attacker_unit:position()
		end

		attack_dir = hit_pos - from_pos
		mvec3_norm(attack_dir)
	else
		attack_dir = -self._unit:rotation():y()
	end

	attack_data.attack_dir = attack_dir
	hit_pos = hit_pos - attack_dir * 5
	attack_data.pos = hit_pos

	local damage = 0
	if self:is_overhealed() then
		damage = damage_percent * self._OVERHEALTH_INIT_PRECENT
	else
		damage = damage_percent * self._HEALTH_INIT_PRECENT
	end
	attack_data.damage = damage

	if death then
		attack_data.damage = self._health

		if variant ~= "stun" then
			if self._unit:base()._tweak_table == "boom" then
				self._unit:damage():run_sequence_simple("grenadier_glass_break")
			elseif self._head_body_name then
				local body = self._unit:body(self._head_body_name)

				self:_spawn_head_gadget({
					skip_push = true,
					position = body:position(),
					rotation = body:rotation()
				})
			end
		end

		if Network:is_server() and self._char_tweak.gas_on_death then
			managers.groupai:state():detonate_cs_grenade(self._unit:movement():m_pos() + math_UP * 10, mvec3_cpy(self._unit:movement():m_head_pos()), 7.5)
		end

		result = {
			type = "death",
			variant = variant
		}

		self:die(attack_data)

		local data = {
			variant = "explosion",
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			weapon_unit = weapon_unit
		}

		managers.statistics:killed_by_anyone(data)

		self:chk_killshot(attacker, "explosion")

		if attacker == managers.player:player_unit() then
			if alive(attacker) then
				self:_comment_death(attacker, self._unit)
			end

			self:_show_death_hint(self._unit:base()._tweak_table)
			managers.statistics:killed(data)

			if CopDamage.is_civilian(self._unit:base()._tweak_table) then
				managers.money:civilian_killed()
			end

			self:_check_damage_achievements(attack_data, false)
		end
	else
		local result_type = "dmg_rcv"

		if was_healed then
			result_type = "healed"

			attack_data.damage = self._health
		else
			self:_apply_damage_to_health(damage)
		end

		result = {
			type = result_type,
			variant = variant
		}
	end

	attack_data.result = result
	attack_data.is_synced = true
	weapon_unit = attack_data.weapon_unit or weapon_unit

	if damage > 0 and variant ~= "stun" and attacker == managers.player:player_unit() and alive(attacker) then
		managers.hud:on_hit_confirmed()
	end

	if alive(weapon_unit) and weapon_unit:base() and weapon_unit:base().add_damage_result then
		weapon_unit:base():add_damage_result(self._unit, result.type == "death", damage_percent)
	end

	if variant ~= "stun" and not self._no_blood and damage > 0 then
		managers.game_play_central:sync_play_impact_flesh(hit_pos, attack_dir)
	end

	self:_on_damage_received(attack_data)
end

function CopDamage:damage_simple(attack_data)
	if self._dead or self._invulnerable then
		return
	end

	if self._unit:in_slot(16, 21, 22) then
		return
	end

	local is_civilian = CopDamage.is_civilian(self._unit:base()._tweak_table)
	local result = nil
	local damage = attack_data.damage

	damage = self:_apply_damage_reduction(damage)

	if self._char_tweak.DAMAGE_CLAMP_SHOCK then
		damage = math_min(damage, self._char_tweak.DAMAGE_CLAMP_SHOCK)
	elseif self._char_tweak.DAMAGE_CLAMP_BULLET then
		damage = math_min(damage, self._char_tweak.DAMAGE_CLAMP_BULLET)
	end

	attack_data.raw_damage = damage

	local damage_percent = 0
	if self:is_overhealed() then
		damage = math_clamp(damage, 0, self._OVERHEALTH_INIT)
		damage_percent = math_ceil(damage / self._OVERHEALTH_INIT_PRECENT)
		damage = damage_percent * self._OVERHEALTH_INIT_PRECENT
	else
		damage = math_clamp(damage, 0, self._HEALTH_INIT)
		damage_percent = math_ceil(damage / self._HEALTH_INIT_PRECENT)
		damage = damage_percent * self._HEALTH_INIT_PRECENT
	end

	if self._immortal then
		damage = math_min(damage, self._health - 1)
	end

	if self._health <= damage then
		attack_data.damage = self._health

		if self:check_medic_heal() then
			result = {
				type = "healed",
				variant = attack_data.variant
			}
			self._player_damage_ratio = 0
		else
			result = {
				type = "death",
				variant = attack_data.variant
			}

			self:die(attack_data)
			self:chk_killshot(attack_data.attacker_unit, attack_data.variant)
		end
	else
		attack_data.damage = damage

		local result_type = nil

		if not self._char_tweak.immune_to_knock_down then
			local weapon_base = attack_data.attacker_unit and attack_data.attacker_unit:inventory() and attack_data.attacker_unit:inventory():equipped_unit() and attack_data.attacker_unit:inventory():equipped_unit():base()

			if weapon_base then
				local knock_down = weapon_base._knock_down and weapon_base._knock_down > 0 and math_random() < weapon_base._knock_down

				if knock_down then
					result_type = "knock_down"
				else
					local stagger = attack_data.stagger or weapon_base._stagger and not self._has_been_staggered

					if stagger then
						result_type = "stagger"
						self._has_been_staggered = true
					end
				end
			end
		end

		if not result_type then
			result_type = self:get_damage_type(damage_percent)
		end

		result = {
			type = result_type,
			variant = attack_data.variant
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.result = result

	local attacker_unit = attack_data.attacker_unit

	if result.type == "death" then
		local data = {
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			owner = attack_data.owner,
			weapon_unit = attack_data.weapon_unit,
			variant = attack_data.variant
		}

		managers.statistics:killed_by_anyone(data)

		if attacker_unit and attacker_unit:base() and attacker_unit:base().thrower_unit then
			attacker_unit = attacker_unit:base():thrower_unit()
			data.weapon_unit = attack_data.attacker_unit
		end

		if not is_civilian and managers.player:has_category_upgrade("temporary", "overkill_damage_multiplier") and attacker_unit == managers.player:player_unit() and attack_data.weapon_unit and attack_data.weapon_unit:base().weapon_tweak_data and not attack_data.weapon_unit:base().thrower_unit and attack_data.weapon_unit:base():is_category("shotgun", "saw") then
			managers.player:activate_temporary_upgrade("temporary", "overkill_damage_multiplier")
		end

		if attacker_unit == managers.player:player_unit() then
			if alive(attacker_unit) then
				self:_comment_death(attacker_unit, self._unit)
			end

			self:_show_death_hint(self._unit:base()._tweak_table)
			managers.statistics:killed(data)

			if is_civilian then
				managers.money:civilian_killed()
			end

			self:_check_damage_achievements(attack_data, false)
		else
			if attacker_unit and alive(attacker_unit) and managers.groupai:state():is_unit_team_AI(attacker_unit) then
				self:_AI_comment_death(attacker_unit, self._unit)
			end
		end
	end

	local attacker = attack_data.attacker_unit

	if not attacker or not alive(attacker) or attacker:id() == -1 then
		attacker = self._unit
	end

	if not self._no_blood and damage > 0 then
		managers.game_play_central:sync_play_impact_flesh(attack_data.pos, attack_data.attack_dir)
	end

	local i_result = nil

	if result.type == "healed" then
		i_result = 1
	else
		i_result = 0
	end

	self:_send_simple_attack_result(attacker, damage_percent, self:_get_attack_variant_index(attack_data.variant), i_result)
	self:_on_damage_received(attack_data)

	if not is_civilian and attacker_unit and alive(attacker_unit) then
		managers.player:enemy_shot(self._unit, attack_data)
	end

	return result
end

function CopDamage:sync_damage_simple(attacker_unit, damage_percent, i_attack_variant, i_result, death)
	if self._dead then
		return
	end

	local variant = CopDamage._ATTACK_VARIANTS[i_attack_variant]
	local attack_data = {
		variant = variant,
		attacker_unit = attacker_unit
	}

	local hit_pos = mvec3_cpy(self._unit:position())
	mvec3_set_z(hit_pos, hit_pos.z + 100)

	local attack_dir, result = nil

	if attacker_unit then
		local from_pos = nil

		if attacker_unit:movement() then
			if attacker_unit:movement().m_detect_pos then
				from_pos = attacker_unit:movement():m_detect_pos()
			elseif attacker_unit:movement().m_head_pos then
				from_pos = attacker_unit:movement():m_head_pos()
			else
				from_pos = attacker_unit:position()
			end
		else
			from_pos = attacker_unit:position()
		end

		attack_dir = hit_pos - from_pos
		mvec3_norm(attack_dir)
	else
		attack_dir = -self._unit:rotation():y()
	end

	attack_data.attack_dir = attack_dir
	hit_pos = hit_pos - attack_dir * 5
	attack_data.pos = hit_pos

	local damage = 0
	if self:is_overhealed() then
		damage = damage_percent * self._OVERHEALTH_INIT_PRECENT
	else
		damage = damage_percent * self._HEALTH_INIT_PRECENT
	end
	attack_data.damage = damage

	if death then
		attack_data.damage = self._health

		result = {
			type = "death",
			variant = variant
		}

		self:die(attack_data)
		self:chk_killshot(attacker_unit, variant)

		local data = {
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			weapon_unit = attacker_unit and attacker_unit:inventory() and attacker_unit:inventory():equipped_unit(),
			variant = variant
		}

		local attacker = attacker_unit

		if attacker and attacker:base() and attacker:base().thrower_unit then
			data.weapon_unit = attacker_unit
		end

		if data.weapon_unit then
			managers.statistics:killed_by_anyone(data)
		end
	else
		local result_type = "dmg_rcv"

		if i_result == 1 then
			result_type = "healed"

			attack_data.damage = self._health
		else
			self:_apply_damage_to_health(damage)
		end

		result = {
			type = result_type,
			variant = variant
		}
	end

	attack_data.result = result
	attack_data.is_synced = true

	if not self._no_blood and damage > 0 then
		managers.game_play_central:sync_play_impact_flesh(hit_pos, attack_dir)
	end

	self:_on_damage_received(attack_data)
end

function CopDamage:damage_dot(attack_data)
	if self._dead or self._invulnerable then
		return
	end

	if attack_data.attacker_unit and alive(attack_data.attacker_unit) and self:is_friendly_fire(attack_data.attacker_unit) then
		return "friendly_fire"
	end

	local damage = attack_data.damage

	if self._char_tweak.damage.dot_damage_mul then
		damage = damage * self._char_tweak.damage.dot_damage_mul
	end

	if self._marked_dmg_mul then
		damage = damage * self._marked_dmg_mul
	end

	damage = self:_apply_damage_reduction(damage)

	if self._char_tweak.DAMAGE_CLAMP_DOT then
		damage = math_min(damage, self._char_tweak.DAMAGE_CLAMP_DOT)
	end

	attack_data.raw_damage = damage

	local damage_percent = 0
	if self:is_overhealed() then
		damage = math_clamp(damage, 0, self._OVERHEALTH_INIT)
		damage_percent = math_ceil(damage / self._OVERHEALTH_INIT_PRECENT)
		damage = damage_percent * self._OVERHEALTH_INIT_PRECENT
	else
		damage = math_clamp(damage, 0, self._HEALTH_INIT)
		damage_percent = math_ceil(damage / self._HEALTH_INIT_PRECENT)
		damage = damage_percent * self._HEALTH_INIT_PRECENT
	end

	if self._immortal then
		damage = math_min(damage, self._health - 1)
	end

	if not attack_data.variant then
		attack_data.variant = "dot"
	end

	local result = nil

	if self._health <= damage then
		attack_data.damage = self._health

		if self:check_medic_heal() then
			result = {
				type = "healed",
				variant = attack_data.variant
			}
			self._player_damage_ratio = 0
		else
			result = {
				type = "death",
				variant = attack_data.variant
			}

			self:die(attack_data)
			self:chk_killshot(attack_data.attacker_unit, attack_data.variant, nil, attack_data.weapon_id)
		end
	else
		attack_data.damage = damage

		local result_type = attack_data.hurt_animation and self:get_damage_type(damage_percent, attack_data.variant) or "dmg_rcv"

		result = {
			type = result_type,
			variant = attack_data.variant
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.result = result
	attack_data.pos = attack_data.col_ray.position

	if result.type == "death" then
		local variant = attack_data.weapon_id and tweak_data.blackmarket and tweak_data.blackmarket.melee_weapons and tweak_data.blackmarket.melee_weapons[attack_data.weapon_id] and "melee" or attack_data.variant
		local data = {
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			owner = attack_data.owner,
			weapon_unit = attack_data.weapon_unit,
			variant = variant,
			name_id = attack_data.weapon_id
		}

		managers.statistics:killed_by_anyone(data)

		if attack_data.attacker_unit == managers.player:player_unit() then
			if alive(attack_data.attacker_unit) then
				self:_comment_death(attack_data.attacker_unit, self._unit)
			end

			self:_show_death_hint(self._unit:base()._tweak_table)
			managers.statistics:killed(data)

			if CopDamage.is_civilian(self._unit:base()._tweak_table) then
				managers.money:civilian_killed()
			end

			self:_check_damage_achievements(attack_data, false)
		end
	end

	if attack_data.hurt_animation and result.type ~= "poison_hurt" then
		attack_data.hurt_animation = false
	end

	local attacker = attack_data.attacker_unit

	if not attacker or not alive(attacker) or attacker:id() == -1 then
		attacker = self._unit
	end

	local sync_attack_variant = attack_data.variant

	if result.type == "healed" then
		if attack_data.variant == "poison" then
			sync_attack_variant = "poison_healed"
		else
			sync_attack_variant = "dot_healed"
		end
	end

	self:_send_dot_attack_result(attack_data, attacker, damage_percent, sync_attack_variant)
	self:_on_damage_received(attack_data)
	
	result.attack_data = attack_data
	result.damage_percent = damage_percent
	result.damage = damage

	return result
end

function CopDamage:sync_damage_dot(attacker_unit, damage_percent, death, variant, hurt_animation, weapon_id)
	if self._dead then
		return
	end

	local attack_variant, was_healed, result = nil

	if variant == "poison_healed" then
		attack_variant = "poison"
		was_healed = true
	elseif variant == "dot_healed" then
		attack_variant = "dot"
		was_healed = true
	else
		attack_variant = variant
	end

	local attack_data = {
		variant = attack_variant,
		attacker_unit = attacker_unit
	}

	local damage = 0
	if self:is_overhealed() then
		damage = damage_percent * self._OVERHEALTH_INIT_PRECENT
	else
		damage = damage_percent * self._HEALTH_INIT_PRECENT
	end
	attack_data.damage = damage

	if death then
		attack_data.damage = self._health

		result = {
			type = "death",
			variant = attack_variant
		}

		self:die(attack_data)
		self:chk_killshot(attacker_unit, attack_variant, nil, weapon_id)

		local real_variant = weapon_id and tweak_data.blackmarket and tweak_data.blackmarket.melee_weapons and tweak_data.blackmarket.melee_weapons[weapon_id] and "melee" or attack_data.variant
		local data = {
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			weapon_unit = not weapon_id and attacker_unit and attacker_unit:inventory() and attacker_unit:inventory():equipped_unit(),
			variant = real_variant,
			name_id = weapon_id
		}

		if data.weapon_unit or data.name_id then
			managers.statistics:killed_by_anyone(data)
		end
	else
		local result_type = "dmg_rcv"

		if was_healed then
			result_type = "healed"

			attack_data.damage = self._health
		else
			self:_apply_damage_to_health(damage)
		end

		result = {
			variant = attack_variant,
			type = result_type
		}
	end

	attack_data.result = result
	attack_data.weapon_id = weapon_id
	attack_data.is_synced = true

	self:_on_damage_received(attack_data)
end

function CopDamage:damage_tase(attack_data)
	if self._dead or self._invulnerable then
		return
	end

	local attacker_unit = attack_data.attacker_unit
	local weap_unit = attack_data.weapon_unit

	if attacker_unit and alive(attacker_unit) and self:is_friendly_fire(attacker_unit) then
		return "friendly_fire"
	end

	local result = nil
	local damage = attack_data.damage

	damage = self:_apply_damage_reduction(damage)
	attack_data.raw_damage = damage

	local damage_percent = 0
	if self:is_overhealed() then
		damage = math_clamp(damage, 0, self._OVERHEALTH_INIT)
		damage_percent = math_ceil(damage / self._OVERHEALTH_INIT_PRECENT)
		damage = damage_percent * self._OVERHEALTH_INIT_PRECENT
	else
		damage = math_clamp(damage, 0, self._HEALTH_INIT)
		damage_percent = math_ceil(damage / self._HEALTH_INIT_PRECENT)
		damage = damage_percent * self._HEALTH_INIT_PRECENT
	end	

	if self._immortal then
		damage = math_min(damage, self._health - 1)
	end

	local tase_variant = nil

	if self._health <= damage then
		attack_data.damage = self._health
		attack_data.variant = "bullet"

		result = {
			variant = "bullet",
			type = "death"
		}

		self:die(attack_data)
		self:chk_killshot(attacker_unit, "tase")
	else
		attack_data.damage = damage

		local result_type = "dmg_rcv"

		if self._char_tweak.damage.hurt_severity.tase == nil or self._char_tweak.damage.hurt_severity.tase then
			if attacker_unit == managers.player:player_unit() then
				if weap_unit then
					managers.hud:on_hit_confirmed()
				end
			end

			result_type = "taser_tased"

			if self._char_tweak.damage and self._char_tweak.damage.tased_response then
				if attack_data.variant == "heavy" and self._char_tweak.damage.tased_response.heavy then
					self._tased_time = self._char_tweak.damage.tased_response.heavy.tased_time
					self._tased_down_time = self._char_tweak.damage.tased_response.heavy.down_time
					tase_variant = "heavy"
				elseif self._char_tweak.damage.tased_response.light then
					self._tased_time = self._char_tweak.damage.tased_response.light.tased_time
					self._tased_down_time = self._char_tweak.damage.tased_response.light.down_time
					tase_variant = "light"
				else
					self._tased_time = 5
					self._tased_down_time = 10
				end
			end
		end

		attack_data.variant = "bullet"

		result = {
			type = result_type,
			variant = attack_data.variant
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.result = result
	attack_data.pos = attack_data.col_ray.position

	if result.type == "death" then
		local data = {
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			owner = attack_data.owner,
			weapon_unit = weap_unit,
			variant = "bullet"
		}

		managers.statistics:killed_by_anyone(data)

		if attacker_unit == managers.player:player_unit() then
			if alive(attacker_unit) then
				self:_comment_death(attacker_unit, self._unit)
			end

			self:_show_death_hint(self._unit:base()._tweak_table)
			managers.statistics:killed(data)

			if CopDamage.is_civilian(self._unit:base()._tweak_table) then
				managers.money:civilian_killed()
			end

			self:_check_damage_achievements(attack_data, false)
		else
			if attacker_unit and alive(attacker_unit) and managers.groupai:state():is_unit_team_AI(attacker_unit) then
				self:_AI_comment_death(attacker_unit, self._unit)
			end
		end
	end

	local attacker = attacker_unit

	if not attacker or not alive(attacker) or attacker:id() == -1 then
		attack_data.attacker_unit = self._unit
	end

	local i_result = nil

	if result.type == "taser_tased" then
		if tase_variant == "heavy" then
			i_result = 1
		elseif tase_variant == "light" then
			i_result = 2
		else
			i_result = 3
		end
	else
		i_result = 0
	end

	self:_send_tase_attack_result(attack_data, damage_percent, i_result)
	self:_on_damage_received(attack_data)

	return result
end

function CopDamage:sync_damage_tase(attacker_unit, damage_percent, i_result, death)
	if self._dead then
		return
	end

	local attack_data = {
		attacker_unit = attacker_unit,
		variant = "bullet"
	}

	local hit_pos = mvec3_cpy(self._unit:position())
	mvec3_set_z(hit_pos, hit_pos.z + 100)

	local attack_dir, result = nil

	if attacker_unit then
		local from_pos = nil

		if attacker_unit:movement() then
			if attacker_unit:movement().m_detect_pos then
				from_pos = attacker_unit:movement():m_detect_pos()
			elseif attacker_unit:movement().m_head_pos then
				from_pos = attacker_unit:movement():m_head_pos()
			else
				from_pos = attacker_unit:position()
			end
		else
			from_pos = attacker_unit:position()
		end

		attack_dir = hit_pos - from_pos
		mvec3_norm(attack_dir)
	else
		attack_dir = -self._unit:rotation():y()
	end

	attack_data.attack_dir = attack_dir
	hit_pos = hit_pos - attack_dir * 5
	attack_data.pos = hit_pos

	local damage = 0
	if self:is_overhealed() then
		damage = damage_percent * self._OVERHEALTH_INIT_PRECENT
	else
		damage = damage_percent * self._HEALTH_INIT_PRECENT
	end
	attack_data.damage = damage

	if death then
		attack_data.damage = self._health

		result = {
			variant = "bullet",
			type = "death"
		}

		self:die(attack_data)
		self:chk_killshot(attacker_unit, "tase")

		local data = {
			variant = "bullet",
			name = self._unit:base()._tweak_table,
			stats_name = self._unit:base()._stats_name,
			weapon_unit = attacker_unit and attacker_unit:inventory() and attacker_unit:inventory():equipped_unit(),
		}

		managers.statistics:killed_by_anyone(data)
	else
		local result_type = "dmg_rcv"

		if i_result == 1 then
			result_type = "taser_tased"
			self._tased_time = self._char_tweak.damage.tased_response.heavy.tased_time
			self._tased_down_time = self._char_tweak.damage.tased_response.heavy.down_time
		elseif i_result == 2 then
			result_type = "taser_tased"
			self._tased_time = self._char_tweak.damage.tased_response.light.tased_time
			self._tased_down_time = self._char_tweak.damage.tased_response.light.down_time
		elseif i_result == 3 then
			result_type = "taser_tased"
			self._tased_time = 5
			self._tased_down_time = 10
		end

		result = {
			type = result_type,
			variant = "bullet"
		}

		self:_apply_damage_to_health(damage)
	end

	attack_data.result = result
	attack_data.is_synced = true

	self:_on_damage_received(attack_data)
end

function CopDamage:_on_damage_received(damage_info)
	self:_call_listeners(damage_info)
	CopDamage._notify_listeners("on_damage", damage_info)

	if damage_info.result.type == "death" then
		managers.enemy:on_enemy_died(self._unit, damage_info)
	end

	local attacker_unit = damage_info and damage_info.attacker_unit

	if alive(attacker_unit) then
		local attacker_base = attacker_unit:base()

		if attacker_base then
			if attacker_base.thrower_unit then
				local actual_attacker = attacker_base:thrower_unit()

				if alive(actual_attacker) then
					attacker_unit = actual_attacker
					attacker_base = actual_attacker:base()
				end
			elseif attacker_base.sentry_gun then
				local actual_attacker = attacker_base:get_owner()

				if alive(actual_attacker) then
					attacker_unit = actual_attacker
					attacker_base = actual_attacker:base()
				end
			end

			if attacker_base then
				local store_damage_ratio = nil

				if attacker_base.is_local_player then
					store_damage_ratio = true

					managers.player:on_damage_dealt(self._unit, damage_info)
				else
					store_damage_ratio = attacker_base.is_husk_player
				end

				if store_damage_ratio and damage_info.damage then
					if self._was_overhealed then
						self._player_damage_ratio = self._player_damage_ratio + (damage_info.damage / self._OVERHEALTH_INIT)
					else
						self._player_damage_ratio = self._player_damage_ratio + (damage_info.damage / self._HEALTH_INIT)
					end
				end
			end
		end
	end

	--should prevent countering and shield knock from counting towards this
	if damage_info.variant == "melee" and type(damage_info.damage) == "number" and damage_info.damage > 0 then
		managers.statistics:register_melee_hit()
	end

	self:_update_debug_ws(damage_info)

	if not self._dead and not self._unit:base():has_tag("special") and self._health > 0 then
		local t = TimerManager:game():time()

		if not self._next_allowed_hurt_t or self._next_allowed_hurt_t and self._next_allowed_hurt_t < t then
			if damage_info.damage and damage_info.damage > 0.01 and self._health > damage_info.damage then
				if not damage_info.result_type or damage_info.result_type ~= "healed" or damage_info.variant == "hurt_sick" and damage_info.result_type ~= "death" then
					if damage_info.is_fire_dot_damage or damage_info.variant == "fire" then
						if self._next_allowed_burnhurt_t and self._next_allowed_burnhurt_t < t or not self._next_allowed_burnhurt_t then
							self._unit:sound():say("burnhurt", nil, nil, nil, nil)
							self._next_allowed_burnhurt_t = t + 8
							self._next_allowed_hurt_t = t + math_random(1, 1.28)
						end
					else
						self._unit:sound():say("x01a_any_3p", nil, nil, nil, nil)
					end
				end
			end
		end
	end
end

function CopDamage:damage_mission(attack_data)
	if self._dead then
		return
	elseif self._invulnerable or self._immortal then
		if not attack_data.forced then
			return
		end
	end

	if self.immortal and self.is_escort then
		if attack_data.backup_so then
			attack_data.backup_so:on_executed(self._unit)
		end

		return
	end

	if self._char_tweak.no_damage_mission then
		return
	end

	local result = nil
	local damage_percent = self._HEALTH_GRANULARITY
	attack_data.damage = self._health
	result = {
		type = "death",
		variant = attack_data.variant
	}

	self:die(attack_data)

	attack_data.result = result
	attack_data.attack_dir = -self._unit:rotation():y()
	attack_data.pos = self._unit:position()

	if attack_data.attacker_unit == managers.player:local_player() then
		if CopDamage.is_civilian(self._unit:base()._tweak_table) then
			managers.money:civilian_killed()
		elseif Network:is_server() and self._char_tweak.gas_on_death then
			managers.groupai:state():detonate_cs_grenade(self._unit:movement():m_pos() + math_UP * 10, mvec3_cpy(self._unit:movement():m_head_pos()), 7.5)
		end
	end

	self:_send_explosion_attack_result(attack_data, self._unit, damage_percent, self:_get_attack_variant_index("explosion"), attack_data.col_ray and attack_data.col_ray.ray)
	self:_on_damage_received(attack_data)

	return result
end

local orig_build_suppression = CopDamage.build_suppression
function CopDamage:build_suppression(...)
	if not self._invulnerable and not self._unit:in_slot(16) then
		orig_build_suppression(self, ...)
	end
end

function CopDamage:_check_special_death_conditions(variant, body, attacker_unit, weapon_unit)
	if not attacker_unit or not alive(attacker_unit) or not attacker_unit:base() then
		return
	end

	local special_deaths = self._char_tweak.special_deaths --special deaths set in charactertweakdata

	if not special_deaths or not special_deaths[variant] then
		return
	end

	local body_data = special_deaths[variant][body:name():key()]

	if not body_data then
		return
	end

	if not managers.groupai:state():all_criminals()[attacker_unit:key()] then --is not a heister
		return
	end

	local attacker_name = managers.criminals:character_name_by_unit(attacker_unit)

	if not body_data.character_name or body_data.character_name ~= attacker_name then
		return
	end

	if variant == "melee" then
		if body_data.melee_weapon_id and weapon_unit then
			if body_data.melee_weapon_id == weapon_unit then
				if self._unit:damage():has_sequence(body_data.sequence) then
					if body_data.sound_effect then
						self._unit:sound():play(body_data.sound_effect, nil, nil)
					end

					self._unit:damage():run_sequence_simple(body_data.sequence)

					if body_data.special_comment then
						if attacker_unit == managers.player:player_unit() or Network:is_server() and managers.groupai:state():is_unit_team_AI(attacker_unit) then
							return body_data.special_comment
						end
					end
				end
			end
		end
	elseif variant == "bullet" then
		if body_data.weapon_id and alive(weapon_unit) then
			local factory_id = weapon_unit:base()._factory_id --factory id, aka its unit id

			if not factory_id then
				return
			end

			if weapon_unit:base():is_npc() then --uses newnpcraycastweaponbase (so, bots and player husks)
				factory_id = utf8.sub(factory_id, 1, -5) --removes the _npc part (or third_unit, forgot which one but it's what it does) from the name to see if it coincides below
			end

			local weapon_id = managers.weapon_factory:get_weapon_id_by_factory_id(factory_id) --actual weapon id used in many files

			if body_data.weapon_id == weapon_id then
				if self._unit:damage():has_sequence(body_data.sequence) then
					self._unit:damage():run_sequence_simple(body_data.sequence)
				end

				if body_data.special_comment then
					if attacker_unit == managers.player:player_unit() or Network:is_server() and managers.groupai:state():is_unit_team_AI(attacker_unit) then
						return body_data.special_comment
					end
				end
			end
		end
	end
end

function CopDamage:_comment_death(attacker, killed_unit, special_comment)
	local victim_base = killed_unit:base()

	if special_comment then
		PlayerStandard.say_line(attacker:sound(), special_comment)
	elseif victim_base:has_tag("tank") then
		PlayerStandard.say_line(attacker:sound(), "g30x_any")
	elseif victim_base:has_tag("spooc") then
		PlayerStandard.say_line(attacker:sound(), "g33x_any")
	elseif victim_base:has_tag("taser") then
		PlayerStandard.say_line(attacker:sound(), "g32x_any")
	elseif victim_base:has_tag("shield") then
		PlayerStandard.say_line(attacker:sound(), "g31x_any")
	elseif victim_base:has_tag("sniper") then
		PlayerStandard.say_line(attacker:sound(), "g35x_any")
	elseif victim_base:has_tag("medic") then
		PlayerStandard.say_line(attacker:sound(), "g36x_any")
	elseif victim_base:has_tag("custom") then
		PlayerStandard.say_line(attacker:sound(), "g92")
	end
end

function CopDamage:_AI_comment_death(unit, killed_unit, special_comment)
	local victim_base = killed_unit:base()

	if special_comment then
		unit:sound():say(special_comment, true)
	elseif victim_base:has_tag("tank") then
		unit:sound():say("g30x_any", true)
	elseif victim_base:has_tag("spooc") then
		unit:sound():say("g33x_any", true)
	elseif victim_base:has_tag("taser") then
		unit:sound():say("g32x_any", true)
	elseif victim_base:has_tag("shield") then
		unit:sound():say("g31x_any", true)
	elseif victim_base:has_tag("sniper") then
		unit:sound():say("g35x_any", true)
	elseif victim_base:has_tag("medic") then
		unit:sound():say("g36x_any", true)
	elseif victim_base:has_tag("custom") then
		unit:sound():say("g92", true)
	end
end

function CopDamage:_on_death(variant)
	--Remove Ex-Pres
	managers.player:chk_wild_kill_counter(self._unit, variant)
end

function CopDamage.is_hrt(type)
	return type == "swat" or type == "fbi" or type == "cop" or type == "security"
end

function CopDamage:roll_critical_hit(attack_data)
	local damage = attack_data.damage

	if not self:can_be_critical(attack_data) then
		return false, damage
	end

	local critical_damage_mul = 2
	local critical_hit = false
	local critical_value = 0
	critical_value = critical_value + managers.player:critical_hit_chance()

	if attack_data.backstab then
		critical_value = critical_value + managers.player:upgrade_value("player", "backstab_crits", 0)
	end

	if critical_value > 0 then
		local critical_roll = math_rand(1)
		critical_hit = critical_roll < critical_value
	end

	local hyper_crit = attack_data.variant == "bullet" and managers.player:can_hyper_crit()
	if critical_hit and hyper_crit then
		damage = damage * critical_damage_mul * critical_damage_mul
	elseif critical_hit then
		damage = damage * critical_damage_mul
	elseif hyper_crit then
		critical_hit = true
		damage = damage * critical_damage_mul
	end

	return critical_hit, damage
end

function CopDamage:check_backstab(attack_data)
	if self._unit.movement and self._unit:movement().m_rot then
		local fwd_vec = mvec3_dot(self._unit:movement():m_rot():y(), managers.player:player_unit():movement():m_head_rot():y())

		--# degrees of leeway == (1-(2*number fwd_vec > than))pi radians
		if fwd_vec > 0.15 then
			return true
		end
	end

	return false
end

--Sets an enemy's health to double. Triggered by LPFs/Winters.
function CopDamage:apply_overheal(heal_amount)
	local amount_to_heal = math_ceil(self._health - self._OVERHEALTH_INIT)

	if self._unit:contour() then
		self._unit:contour():add("omnia_heal", false)
	end

	self._was_overhealed = true --Whether or not overheal was EVER applied to this enemy.
	self._player_damage_ratio = 0
	self:_apply_damage_to_health(amount_to_heal)
end

--Whether or not an overheal is still active.
function CopDamage:is_overhealed()
	if self._health_ratio > 1 then
		return true
	end
	return nil
end

local old_apply_damage_to_health = CopDamage._apply_damage_to_health
function CopDamage:_apply_damage_to_health(damage)
	old_apply_damage_to_health(self, damage)
	
	if self._RECLOAK_THRESHOLD then
		local movement_ext = self._unit:movement()
		local is_cloaked = movement_ext:is_cloaked()
		if not is_cloaked and self._health <= self._next_defensive_recloak then
			movement_ext:set_cloaked(true)
			self._next_defensive_recloak = self._health - self._RECLOAK_THRESHOLD
		elseif is_cloaked then
			self._next_defensive_recloak = self._health - self._RECLOAK_THRESHOLD
		end
	end
end

--Adds an additional resist stack mechanic that can be applied to specific enemies to prevent stunlocking.
function CopDamage:get_damage_type(damage_percent, category)
	category = category or "bullet"
	local hurt_table = self._char_tweak.damage.hurt_severity[category]
	local dmg = damage_percent / self._HEALTH_GRANULARITY

	if hurt_table.health_reference == "full" then
		-- Nothing
	elseif hurt_table.health_reference == "current" then
		dmg = math.min(1, self._HEALTH_INIT * dmg / self._health)
	else
		dmg = math.min(1, self._HEALTH_INIT * dmg / hurt_table.health_reference)
	end
	
	--Apply hurt resistance stacks.
	if self._hurt_resists and self._hurt_resists[category] then
		dmg = dmg * ((hurt_table.resist_stack_multiplier or 0.5) / self._hurt_resists[category])
	end

	local zone = nil

	for i_zone, test_zone in ipairs(hurt_table.zones) do
		if i_zone == #hurt_table.zones or dmg < test_zone.health_limit then
			zone = test_zone

			break
		end
	end

	local rand_nr = math.random()
	local total_w = 0

	for sev_name, hurt_type in pairs(self._hurt_severities) do
		local weight = zone[sev_name]

		if weight and weight > 0 then
			total_w = total_w + weight

			if rand_nr <= total_w then
				if hurt_table.resist_stacking then
					--Check if a new resist stack needs to be added.
					for type, stacks in pairs(hurt_table.resist_stacking) do
						if not self._hurt_resists then  --Cops were somehow spawning without this initialized
							self._hurt_resists = {}
						end

						if type == sev_name then
							self._hurt_resists[category] = (self._hurt_resists[category] or 0) + stacks 
						end
					end
				end

				return hurt_type or "dmg_rcv"
			end
		end
	end

	return "dmg_rcv"
end

function CopDamage:can_melee_knock_shield(knockdown)
	local knock_breakpoint = self._char_tweak.damage.shield_knock_breakpoint
	if self._char_tweak.damage.shield_knock_resistance_stacking then
		if not self._hurt_resists then --Cops were somehow spawning without this initialized
			self._hurt_resists = {}
		end 

		if self._hurt_resists.shield_knock then
			knock_breakpoint = knock_breakpoint / (self._char_tweak.damage.shield_knock_resistance_stacking / self._hurt_resists.shield_knock)
		end

		if knock_breakpoint and knockdown >= knock_breakpoint * self._health_ratio then
			self._hurt_resists.shield_knock = (self._hurt_resists.shield_knock or 0) + 1
			return true
		else
			return false
		end
	else
		return knock_breakpoint and knockdown >= knock_breakpoint * self._health_ratio		
	end
end