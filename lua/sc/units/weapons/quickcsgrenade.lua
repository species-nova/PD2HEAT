function QuickCsGrenade:_setup_from_tweak_data()
	local grenade_entry = self._tweak_projectile_entry or "gas_grenade"
	self._tweak_data = tweak_data.projectiles[grenade_entry]
	self._radius = self._tweak_data.radius or 300
	self._radius_blurzone_multiplier = self._tweak_data.radius_blurzone_multiplier or 1.3
	self._stamina_per_tick = self._tweak_data.stamina_per_tick or 2
	self._no_stamina_damage_mul = self._tweak_data.no_stamina_damage_mul or 2
	self._damage_per_tick = self._tweak_data.damage_per_tick or 0.6
	self._damage_tick_period = self._tweak_data.damage_tick_period or 0.2
end


function QuickCsGrenade:_play_sound_and_effects()
	if self._state == 1 then
		local sound_source = SoundDevice:create_source("grenade_fire_source")

		sound_source:set_position(self._shoot_position)
		sound_source:post_event("grenade_gas_npc_fire")
	elseif self._state == 2 then
		local sound_source = SoundDevice:create_source("grenade_bounce_source")

		sound_source:set_position(self._unit:position())
		sound_source:post_event("grenade_gas_bounce")
	elseif self._state == 3 then
		World:effect_manager():spawn({
			effect = Idstring("effects/particles/explosions/explosion_smoke_grenade"),
			position = self._unit:position(),
			normal = self._unit:rotation():y()
		})
		self._unit:sound_source():post_event("grenade_gas_explode")

		local parent = self._unit:orientation_object()

		self._smoke_effect = World:effect_manager():spawn({
			effect = Idstring("effects/particles/explosions/cs_grenade_smoke_sc"),
			parent = parent
		})

		local blurzone_radius = self._radius * self._radius_blurzone_multiplier

		managers.environment_controller:set_blurzone(self._unit:key(), 1, self._unit:position(), blurzone_radius, 0, true)
	end
end	

--Add stamina related mechanics.
function QuickCsGrenade:_do_damage()
	local player_unit = managers.player:player_unit()

	if player_unit and mvector3.distance_sq(self._unit:position(), player_unit:position()) < self._tweak_data.radius * self._tweak_data.radius then
		local movement_ext = player_unit:movement()

		local attack_data = {
			damage = self._damage_per_tick,
			no_stamina_damage_mul = self._no_stamina_damage_mul,
			stamina_damage = self._stamina_per_tick,
			ignore_deflection = true, 
			col_ray = {
				ray = math.UP
			},
			variant = "gas"
		}

		player_unit:character_damage():damage_gas(attack_data)

		if not self._has_played_VO then
			PlayerStandard.say_line(player_unit:sound(), "g42x_any")

			self._has_played_VO = true
		end
	end
end