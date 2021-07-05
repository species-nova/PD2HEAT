local mvec3_set = mvector3.set
local mvec3_set_stat = mvector3.set_static
local mvec3_add = mvector3.add
local mvec3_dir = mvector3.direction
local mvec3_cpy = mvector3.copy
local mvec1 = Vector3()
local mvec2 = Vector3()

local mrot_lookat = mrotation.set_look_at
local mrot1 = Rotation()

local math_up = math.UP

local alive_g = alive

function ProjectileBase:update(unit, t, dt)
	if self._collided then
		return
	end

	local unit = self._unit

	if not self._simulated then
		local velocity = self._velocity

		unit:m_position(mvec1)
		mvec3_set(mvec2, velocity * dt)
		mvec3_add(mvec1, mvec2)
		unit:set_position(mvec1)

		if self._orient_to_vel then
			mrot_lookat(mrot1, mvec2, math_up)
			unit:set_rotation(mrot1)
		end

		mvec3_set_stat(self._velocity, velocity.x, velocity.y, velocity.z - 980 * dt)
	end

	local sweep_data = self._sweep_data

	if not sweep_data then
		return
	end

	unit:m_position(sweep_data.current_pos)

	local thrower_unit = self._thrower_unit
	local ignore_units = nil

	if alive_g(thrower_unit) then
		--to avoid colliding with the thrower, this prevents NPCs from hitting themselves with some projectile when throwing/firing it
		--this also applies to player husks when FF is enabled

		local thrower_inv_ext = thrower_unit:inventory()
		local shield_unit = thrower_inv_ext and thrower_inv_ext._shield_unit

		--if the thrower has a shield equipped, ignore it as well
		if shield_unit and alive_g(shield_unit) then
			ignore_units = {
				thrower_unit,
				shield_unit
			}
		else
			ignore_units = thrower_unit
		end
	end

	local col_ray = unit:raycast("ray", sweep_data.last_pos, sweep_data.current_pos, "slot_mask", sweep_data.slot_mask, ignore_units and "ignore_unit" or nil, ignore_units or nil)

	--[[if self._draw_debug_trail then
		Draw:brush(Color(1, 0, 0, 1), nil, 3):line(sweep_data.last_pos, sweep_data.current_pos)
	end]]

	if col_ray then
		mvec3_dir(mvec1, sweep_data.last_pos, sweep_data.current_pos)
		mvec3_add(mvec1, col_ray.position)
		unit:set_position(mvec1)

		--[[if self._draw_debug_impact then
			Draw:brush(Color(0.5, 0, 0, 1), nil, 10):sphere(col_ray.position, 4)
			Draw:brush(Color(0.5, 1, 0, 0), nil, 10):sphere(unit:position(), 3)
		end]]

		col_ray.velocity = unit:velocity()
		self._collided = true

		self:_on_collision(col_ray)
	end

	unit:m_position(sweep_data.last_pos)

	self._sweep_data = sweep_data
end

function ProjectileBase:create_sweep_data()
	local sweep_slot_mask = self._slot_mask
	local game_settings = Global.game_settings

	if game_settings and game_settings.one_down then
		sweep_slot_mask = sweep_slot_mask + 3
	else
		sweep_slot_mask = managers.mutators:modify_value("ProjectileBase:create_sweep_data:slot_mask", sweep_slot_mask)
		sweep_slot_mask = managers.modifiers:modify_value("ProjectileBase:create_sweep_data:slot_mask", sweep_slot_mask)
	end

	local cur_pos = self._unit:position()
	local sweep_data = {
		slot_mask = sweep_slot_mask,
		current_pos = mvec3_cpy(cur_pos),
		last_pos = mvec3_cpy(cur_pos)
	}

	self._sweep_data = sweep_data
end

function ProjectileBase.throw_projectile(projectile_type, pos, dir, owner_peer_id, custom_thrower_unit)
	--Remove time cheat.

	local tweak_entry = tweak_data.blackmarket.projectiles[projectile_type]
	local unit_name = Idstring(not Network:is_server() and tweak_entry.local_unit or tweak_entry.unit)
	local unit = World:spawn_unit(unit_name, pos, Rotation(dir, math.UP))

	if managers.network:session() then
		if owner_peer_id then
			local peer = managers.network:session():peer(owner_peer_id)
			local thrower_unit = peer and peer:unit()

			if alive(thrower_unit) then
				unit:base():set_thrower_unit(thrower_unit)

				if not tweak_entry.throwable and thrower_unit:movement() and thrower_unit:movement():current_state() then
					unit:base():set_weapon_unit(thrower_unit:movement():current_state()._equipped_unit)
				end
			end
		elseif alive(custom_thrower_unit) then --Allow for custom thrower units.
			unit:base():set_thrower_unit(custom_thrower_unit)
		end
	end

	unit:base():throw({
		dir = dir,
		projectile_entry = projectile_type
	})

	if unit:base().set_owner_peer_id then
		unit:base():set_owner_peer_id(owner_peer_id)
	end

	local projectile_type_index = tweak_data.blackmarket:get_index_from_projectile_id(projectile_type)

	managers.network:session():send_to_peers_synched("sync_throw_projectile", unit:id() ~= -1 and unit or nil, pos, dir, projectile_type_index, owner_peer_id or 0)

	if tweak_data.blackmarket.projectiles[projectile_type].impact_detonation then
		unit:damage():add_body_collision_callback(callback(unit:base(), unit:base(), "clbk_impact"))
		unit:base():create_sweep_data()
	end

	return unit
end