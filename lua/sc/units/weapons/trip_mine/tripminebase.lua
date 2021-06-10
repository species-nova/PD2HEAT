local orig_raycast = TripMineBase._raycast
function TripMineBase:_raycast(...)
	if self.blackout_active then 
		return {}
	end

	return orig_raycast(self, ...)
end

function TripMineBase:_sensor(t)
	local ray = self:_raycast()

	if ray and ray.unit and not tweak_data.character[ray.unit:base()._tweak_table].is_escort then
		self._sensor_units_detected = self._sensor_units_detected or {}

		if not self._sensor_units_detected[ray.unit:key()] then
			self._sensor_units_detected[ray.unit:key()] = true

			if managers.player:has_category_upgrade("trip_mine", "sensor_highlight") then
				if (managers.groupai:state():whisper_mode() and tweak_data.character[ray.unit:base()._tweak_table].silent_priority_shout or tweak_data.character[ray.unit:base()._tweak_table].priority_shout) then
					managers.game_play_central:auto_highlight_enemy(ray.unit, true)
				end
				self:_emit_sensor_sound_and_effect()

				if managers.network:session() then
					managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", TripMineBase.EVENT_IDS.sensor_beep)
				end
			end

			self._sensor_last_unit_time = t + 5
		end
	end
end

local mvec3_dis_sq = mvector3.distance_sq
local mvec3_copy = mvector3.copy
local mvec3_not_equal = mvector3.not_equal

local mrot_equal = mrotation.equal

local math_ceil = math.ceil

local alive_g = alive
local world_g = World

local ids_base = Idstring("base")

local draw_explosion_sphere = nil
local draw_sync_explosion_sphere = nil
local draw_vanilla_explosion_cylinder = nil
local draw_splinters = nil
local draw_obstructed_splinters = nil
local draw_splinter_hits = nil

function TripMineBase:_check_body()
	local data = self._attached_data

	if not data or data.exploded then
		return
	end

	local index = data.index
	local body = data.body

	if index == 1 then
		if not alive_g(body) or not body:enabled() then
			self:explode()

			data.exploded = true
		end
	elseif index == 2 then
		if not alive_g(body) or not mrot_equal(data.rotation, body:rotation()) then
			self:explode()

			data.exploded = true
		end
	elseif index == 3 then
		if not alive_g(body) or mvec3_not_equal(data.position, body:position()) then
			self:explode()

			data.exploded = true
		end
	end

	if index < data.max_index then
		data.index = index + 1
	else
		data.index = 1
	end

	self._attached_data = data
end

function TripMineBase:_explode(col_ray)
	local player_manager = managers.player
	local damage_size = tweak_data.weapon.trip_mines.damage_size * player_manager:upgrade_value("trip_mine", "explosion_size_multiplier_1", 1) * player_manager:upgrade_value("trip_mine", "damage_multiplier", 1)
	local player = player_manager:player_unit() or nil
	local my_pos = self._ray_from_pos
	local my_fwd = self._forward
	local hit_pos = my_pos + my_fwd * 5

	if draw_explosion_sphere then
		local draw_duration = 3
		local new_brush = Draw:brush(Color.red:with_alpha(0.5), draw_duration)
		new_brush:sphere(hit_pos, damage_size)
	end

	if draw_vanilla_explosion_cylinder then
		local draw_duration = 3
		local new_brush = Draw:brush(Color.blue:with_alpha(0.5), draw_duration)
		new_brush:cylinder(my_pos, self._ray_to_pos, damage_size)
	end

	managers.explosion:give_local_player_dmg(hit_pos, damage_size, tweak_data.weapon.trip_mines.player_damage, player)
	self:_play_sound_and_effects(damage_size)

	local unit = self._unit

	unit:set_extension_update_enabled(ids_base, false)
	self._deactive_timer = 5

	local splinters = {
		mvec3_copy(hit_pos)
	}
	local dirs = {
		Vector3(damage_size, 0, 0),
		Vector3(-damage_size, 0, 0),
		Vector3(0, damage_size, 0),
		Vector3(0, -damage_size, 0),
		Vector3(0, 0, damage_size),
		Vector3(0, 0, -damage_size)
	}

	local geometry_mask = managers.slot:get_mask("world_geometry")

	for i = 1, #dirs do
		local dir = dirs[i]
		local tmp_pos = hit_pos - dir
		local splinter_ray = unit:raycast("ray", hit_pos, tmp_pos, "slot_mask", geometry_mask)

		if splinter_ray then
			local ray_dis = splinter_ray.distance
			local dis = ray_dis > 10 and 10 or ray_dis

			tmp_pos = splinter_ray.position - dir:normalized() * dis
		end

		if draw_splinters then
			local draw_duration = 3
			local new_brush = Draw:brush(Color.white:with_alpha(0.5), draw_duration)
			new_brush:cylinder(hit_pos, tmp_pos, 0.5)
		end

		local near_other_splinter = nil

		for idx = 1, #splinters do
			local s_pos = splinters[idx]

			if mvec3_dis_sq(tmp_pos, s_pos) < 900 then
				near_other_splinter = true

				break
			end
		end

		if not near_other_splinter then
			splinters[#splinters + 1] = mvec3_copy(tmp_pos)
		end
	end

	local units_to_hit, units_to_push = {}, {}
	local damage = tweak_data.weapon.trip_mines.damage * player_manager:upgrade_value("trip_mine", "damage_multiplier", 1)

	local slotmask = managers.slot:get_mask("explosion_targets")
	local bodies = world_g:find_bodies(unit, "intersect", "sphere", hit_pos, damage_size, slotmask)
	local session = managers.network:session()

	for i = 1, #bodies do
		local hit_body = bodies[i]

		if alive_g(hit_body) then
			local hit_unit = hit_body:unit()
			local hit_unit_key = hit_unit:key()
			units_to_push[hit_unit_key] = hit_unit

			local char_dmg_ext = hit_unit:character_damage()
			local hit_character = char_dmg_ext and char_dmg_ext.damage_explosion and not char_dmg_ext:dead()
			local body_ext = hit_body:extension()
			local body_ext_dmg = body_ext and body_ext.damage
			local ray_hit, body_com, damage_character = nil

			if hit_character then
				if not units_to_hit[hit_unit_key] then
					body_com = hit_body:center_of_mass()

					for i = 1, #splinters do
						local s_pos = splinters[i]

						ray_hit = not unit:raycast("ray", s_pos, body_com, "slot_mask", geometry_mask, "report")

						if ray_hit then
							units_to_hit[hit_unit_key] = true
							damage_character = true

							if draw_splinter_hits then
								local draw_duration = 3
								local new_brush = Draw:brush(Color.green:with_alpha(0.5), draw_duration)
								new_brush:cylinder(s_pos, body_com, 0.5)
							end

							break
						elseif draw_obstructed_splinters then
							local draw_duration = 3
							local new_brush = Draw:brush(Color.yellow:with_alpha(0.5), draw_duration)
							new_brush:cylinder(s_pos, body_com, 0.5)
						end
					end
				end
			elseif body_ext_dmg or hit_body:dynamic() then
				if not units_to_hit[hit_unit_key] then
					ray_hit = true
					units_to_hit[hit_unit_key] = true
				end
			end

			if not ray_hit and body_ext_dmg and units_to_hit[hit_unit_key] and char_dmg_ext and char_dmg_ext.damage_explosion then
				body_com = body_com or hit_body:center_of_mass()

				for i = 1, #splinters do
					local s_pos = splinters[i]

					ray_hit = not unit:raycast("ray", s_pos, body_com, "slot_mask", geometry_mask, "report")

					if ray_hit then
						break
					end
				end
			end

			if ray_hit then
				body_com = body_com or hit_body:center_of_mass()
				local dir = body_com - hit_pos
				dir = dir:normalized()

				local dmg = damage
				local base_ext = hit_unit:base()

				if base_ext and base_ext.has_tag and base_ext:has_tag("tank") then
					dmg = dmg * 7
				end

				local body_hit_pos = nil

				if body_ext_dmg then
					local normal = dir
					local prop_damage = dmg > 200 and 200 or dmg
					local network_damage = math_ceil(prop_damage * 163.84)
					prop_damage = network_damage / 163.84

					body_hit_pos = mvec3_copy(hit_body:position())

					body_ext_dmg:damage_explosion(player, normal, body_hit_pos, dir, prop_damage)
					body_ext_dmg:damage_damage(player, normal, body_hit_pos, dir, prop_damage)

					if session and hit_unit:id() ~= -1 then
						network_damage = network_damage > 32768 and 32768 or network_damage

						if player then
							session:send_to_peers_synched("sync_body_damage_explosion", hit_body, player, normal, body_hit_pos, dir, network_damage)
						else
							session:send_to_peers_synched("sync_body_damage_explosion_no_attacker", hit_body, normal, body_hit_pos, dir, network_damage)
						end
					end
				end

				if damage_character then
					body_hit_pos = body_hit_pos or mvec3_copy(hit_body:position())

					--since sending the same col_ray table for all hits actually doesn't make much sense
					local accurate_col_ray = {
						position = body_hit_pos,
						ray = dir
					}

					self:_give_explosion_damage(accurate_col_ray, hit_unit, dmg)
				end
			end
		end
	end

	if player_manager:has_category_upgrade("trip_mine", "fire_trap") then
		local fire_trap_data = player_manager:upgrade_value("trip_mine", "fire_trap", nil)

		if fire_trap_data then
			self:_spawn_environment_fire(player, fire_trap_data[1], fire_trap_data[2])

			if session then
				session:send_to_peers_synched("sync_trip_mine_explode_spawn_fire", unit, player, my_pos, my_fwd, damage_size, damage, fire_trap_data[1], fire_trap_data[2])
			end
		end
	elseif session then
		if player then
			session:send_to_peers_synched("sync_trip_mine_explode", unit, player, my_pos, my_fwd, damage_size, damage)
		else
			session:send_to_peers_synched("sync_trip_mine_explode_no_user", unit, my_pos, my_fwd, damage_size, damage)
		end
	end

	managers.explosion:units_to_push(units_to_push, hit_pos, 300)

	local alert_radius = tweak_data.weapon.trip_mines.alert_radius
	local alert_filter = self._alert_filter or managers.groupai:state():get_unit_type_filter("civilians_enemies")
	local alert_unit = player or unit
	local alert_event = {
		"explosion",
		hit_pos,
		alert_radius,
		alert_filter,
		alert_unit
	}

	managers.groupai:state():propagate_alert(alert_event)

	if Network:is_server() then
		managers.mission:call_global_event("tripmine_exploded")

		unit:set_slot(0)
	else
		unit:set_visible(false)

		local int_ext = unit:interaction()

		if int_ext then
			int_ext:set_active(false)
		end
	end
end

function TripMineBase:sync_trip_mine_explode(user_unit, ray_from, ray_to, damage_size, damage)
	local hit_pos = ray_from + ray_to * 5

	managers.explosion:give_local_player_dmg(hit_pos, damage_size, tweak_data.weapon.trip_mines.player_damage, user_unit)
	self:_play_sound_and_effects(damage_size)

	if draw_sync_explosion_sphere then
		local draw_duration = 3
		local new_brush = Draw:brush(Color.red:with_alpha(0.5), draw_duration)
		new_brush:sphere(hit_pos, damage_size)
	end

	local unit = self._unit
	local bodies = world_g:find_bodies(unit, "intersect", "sphere", hit_pos, damage_size, managers.slot:get_mask("explosion_targets"))
	local units_to_push = {}

	for i = 1, #bodies do
		local hit_body = bodies[i]

		if alive_g(hit_body) then
			local hit_unit = hit_body:unit()
			units_to_push[hit_unit:key()] = hit_unit

			if hit_unit:id() == -1 then
				local body_ext = hit_body:extension()
				local body_ext_dmg = body_ext and body_ext.damage

				if body_ext_dmg then
					local dir = hit_body:center_of_mass() - hit_pos
					dir = dir:normalized()

					local normal = dir
					local dmg = damage
					local base_ext = hit_unit:base()

					if base_ext and base_ext.has_tag and base_ext:has_tag("tank") then
						dmg = dmg * 7
					end

					dmg = dmg > 200 and 200 or dmg
					dmg = math_ceil(dmg * 163.84) / 163.84

					local body_hit_pos = hit_body:position()

					body_ext_dmg:damage_explosion(user_unit, normal, body_hit_pos, dir, dmg)
					body_ext_dmg:damage_damage(user_unit, normal, body_hit_pos, dir, dmg)
				end
			end
		end
	end

	managers.explosion:units_to_push(units_to_push, hit_pos, 300)

	if Network:is_server() then
		managers.mission:call_global_event("tripmine_exploded")

		unit:set_slot(0)
	else
		unit:set_visible(false)

		local int_ext = unit:interaction()

		if int_ext then
			int_ext:set_active(false)
		end
	end
end

function TripMineBase:_play_sound_and_effects(range)
	local custom_params = {
		camera_shake_max_mul = 4,
		sound_muffle_effect = true,
		sound_event = "trip_mine_explode",
		effect = "effects/payday2/particles/explosions/grenade_explosion",
		feedback_range = range * 2,
		on_unit = true
	}

	local unit = self._unit
	local my_fwd = unit:rotation():y()
	local hit_pos = unit:position() + my_fwd * 5

	managers.explosion:play_sound_and_effects(hit_pos, my_fwd, range, custom_params)
end
