local pairs_g = pairs

local alive_g = alive

function DOTManager:update(t, dt)
	local doted_enemies = self._doted_enemies

	for index = #doted_enemies, 1, -1 do
		local dot_info = doted_enemies[index]
		local dot_counter = dot_info.dot_counter

		dot_counter = dot_counter + dt

		if dot_counter > 0.5 then
			self:_damage_dot(dot_info)

			dot_counter = dot_counter - 0.5
		end

		dot_info.dot_counter = dot_counter

		if t > dot_info.dot_length then
			local new_doted_enemies = {}

			for idx = 1, index - 1 do
				new_doted_enemies[#new_doted_enemies + 1] = doted_enemies[idx]
			end

			for idx = index + 1, #doted_enemies do
				new_doted_enemies[#new_doted_enemies + 1] = doted_enemies[idx]
			end

			doted_enemies = new_doted_enemies
			self._doted_enemies = doted_enemies
		end
	end
end

function DOTManager:check_achievemnts(unit, t)
	local achiev_data = tweak_data.achievement.dot_achievements

	if not achiev_data then
		return
	end

	local doted_enemies = self._doted_enemies

	if not doted_enemies or not alive_g(unit) then
		return
	end

	local base_ext = unit:base()

	if not base_ext then
		return
	end

	local tweak_name = base_ext._tweak_table

	if not tweak_name or CopDamage.is_civilian(tweak_name) then
		return
	end

	local dotted_enemies_by_variant = {}
	local local_player = managers.player:player_unit()

	for index = 1, #doted_enemies do
		local dot_info = doted_enemies[index]
		local variant = dot_info.variant
		dotted_enemies_by_variant[variant] = dotted_enemies_by_variant[variant] or {}

		if dot_info.user_unit and dot_info.user_unit == local_player then
			local tbl = dotted_enemies_by_variant[variant]
			tbl[#tbl + 1] = dot_info

			dotted_enemies_by_variant[variant] = tbl
		end
	end

	local variant_count_pass, all_pass = nil

	for achievement, achievement_data in pairs_g(tweak_data.achievement.dot_achievements) do
		variant_count_pass = not achievement_data.count or achievement_data.variant and dotted_enemies_by_variant[achievement_data.variant] and achievement_data.count <= #dotted_enemies_by_variant[achievement_data.variant]
		all_pass = variant_count_pass

		if all_pass then
			managers.achievment:award_data(achievement_data)

			break
		end
	end
end

function DOTManager:add_doted_enemy(enemy_unit, dot_damage_received_time, weapon_unit, dot_length, dot_damage, hurt_animation, variant, weapon_id)
	local dot_info = self:_add_doted_enemy(enemy_unit, dot_damage_received_time, weapon_unit, dot_length, dot_damage, hurt_animation, variant, weapon_id, managers.player:player_unit()) --add proper user_unit in raycastweaponbase

	local weapon = weapon_unit

	if variant == "poison" then
		variant = 1
	elseif variant == "bleed" then
		variant = 2
	elseif variant == "dot" then
		variant = 3
	else
		variant = nil
	end

	if weapon_id ~= nil then
		weapon = managers.player:player_unit()
	end

	managers.network:session():send_to_peers_synched("sync_add_doted_enemy", enemy_unit, variant, weapon, dot_length, dot_damage, managers.player:player_unit(), hurt_animation)
end

function DOTManager:sync_add_dot_damage(enemy_unit, variant, weapon_unit, dot_length, dot_damage, user_unit, hurt_animation, variant, weapon_id)
	if enemy_unit then
		local t = TimerManager:game():time()

		self:_add_doted_enemy(enemy_unit, t, weapon_unit, dot_length, dot_damage, hurt_animation, variant, weapon_id, user_unit)
	end
end

function DOTManager:_add_doted_enemy(enemy_unit, dot_damage_received_time, weapon_unit, dot_length, dot_damage, hurt_animation, variant, weapon_id, user_unit)
	local doted_enemies = self._doted_enemies

	if not doted_enemies then
		return
	end

	local already_doted = false
	local t = TimerManager:game():time()
	local new_length = t + dot_length

	for i = 1, #doted_enemies do
		local dot_info = doted_enemies[i]

		if dot_info.enemy_unit == enemy_unit then
			already_doted = true

			--previous timer should never be shortened, unless the new instance would deal more damage
			if dot_info.dot_length < new_length or dot_info.dot_damage < dot_damage then
				dot_info.dot_length = new_length
				dot_info.dot_damage = dot_damage
			end

			--always override the rest of the info so that the latest attacker gets credited properly
			--only exception being hurt_animation, so that it doesn't magically get removed
			dot_info.weapon_unit = weapon_unit
			dot_info.hurt_animation = dot_info.hurt_animation or hurt_animation
			dot_info.variant = variant
			dot_info.weapon_id = weapon_id
			dot_info.user_unit = user_unit

			break
		end
	end

	if not already_doted then
		local dot_info = {
			dot_counter = 0,
			enemy_unit = enemy_unit,
			weapon_unit = weapon_unit,
			dot_length = new_length,
			dot_damage = dot_damage,
			hurt_animation = hurt_animation,
			variant = variant,
			weapon_id = weapon_id,
			user_unit = user_unit
		}

		doted_enemies[#doted_enemies + 1] = dot_info
	end

	self._doted_enemies = doted_enemies

	self:check_achievemnts(enemy_unit, t)
end

function DOTManager:_damage_dot(dot_info)
	if dot_info.user_unit and dot_info.user_unit == managers.player:player_unit() or not dot_info.user_unit and Network:is_server() then
		local attacker_unit = managers.player:player_unit()
		local col_ray = {
			unit = dot_info.enemy_unit
		}
		local damage = dot_info.dot_damage
		local ignite_character = false
		local weapon_unit = dot_info.weapon_unit
		local weapon_id = dot_info.weapon_id

		if dot_info.variant then
			if dot_info.variant == "poison" then
				PoisonBulletBase:give_damage_dot(col_ray, weapon_unit, attacker_unit, damage, dot_info.hurt_animation, weapon_id)
			elseif dot_info.variant == "bleed" then
				BleedBulletBase:give_damage_dot(col_ray, weapon_unit, attacker_unit, damage, dot_info.hurt_animation, weapon_id)
			end
		end
	end
end

--Allows for custom dot_damage to be defined.
function DOTManager:create_dot_data(type, custom_data)
	local dot_data = deep_clone(tweak_data:get_dot_type_data(type))

	if custom_data then
		dot_data.dot_length = custom_data.dot_length or dot_data.dot_length
		dot_data.hurt_animation_chance = custom_data.hurt_animation_chance or dot_data.hurt_animation_chance
		dot_data.dot_damage = custom_data.dot_damage or dot_data.dot_damage
	end

	return dot_data
end
