--Apply perk deck damage bonus.
local orig_init = PoisonGasEffect.init
function PoisonGasEffect:init(position, normal, projectile_tweak, grenade_unit)
	orig_init(self, position, normal, projectile_tweak, grenade_unit)
	self._friendly_fire_tweak = tweak_data.projectiles.gas_grenade
	self._dot_damage_dealt = self._dot_data.dot_damage * managers.player:get_perk_damage_bonus(self._grenade_unit:base():thrower_unit())
end

function PoisonGasEffect:update(t, dt)
	if self._timer then
		self._timer = self._timer - dt

		if not self._started_fading and self._timer <= self._fade_time then
			World:effect_manager():fade_kill(self._effect)

			self._started_fading = true
		end

		if self._timer <= 0 then
			self._timer = nil

			if alive(self._grenade_unit) and Network:is_server() then
				managers.enemy:add_delayed_clbk("PoisonGasEffect", callback(PoisonGasEffect, PoisonGasEffect, "remove_grenade_unit"), TimerManager:game():time() + self._dot_data.dot_length)
			end
		end

		if self._is_local_player then
			self._damage_tick_timer = self._damage_tick_timer - dt

			if self._damage_tick_timer <= 0 then
				self._damage_tick_timer = self._tweak_data.poison_gas_tick_time or 0.1
				local nearby_units = World:find_units_quick("sphere", self._position, self._range, managers.slot:get_mask("enemies"))

				for _, unit in ipairs(nearby_units) do
					if not table.contains(self._unit_list, unit) then
						local hurt_animation = math.random() < self._dot_data.hurt_animation_chance
						managers.dot:add_doted_enemy(unit, TimerManager:game():time(), self._grenade_unit, self._dot_data.dot_length, self._dot_damage_dealt, hurt_animation, "poison", self._grenade_id)
						table.insert(self._unit_list, unit)
					end
				end
			end
		end

		--Add friendly fire.
		local player_unit = managers.player:player_unit()
		if player_unit and mvector3.distance_sq(self._position, player_unit:position()) < self._range * self._range then
			local attack_data = {
				damage = self._friendly_fire_tweak.damage_per_tick,
				no_stamina_damage_mul = self._friendly_fire_tweak.no_stamina_damage_mul,
				stamina_damage = self._friendly_fire_tweak.stamina_per_tick,
				ignore_deflection = true,
				col_ray = {
					ray = math.UP
				},
				variant = "gas"
			}

			player_unit:character_damage():damage_gas(attack_data)
		end
	end
end