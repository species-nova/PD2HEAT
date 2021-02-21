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
