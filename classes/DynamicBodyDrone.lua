--code provided by Rex & Xeletron, adapted w/ permission for HEAT
--logic begins the second the dynamic body for the drone is active, automated

DynamicBodyDrone = DynamicBodyDrone or class()

DynamicBodyDrone.can_be_critical = false

DynamicBodyDrone.MAX_VELOCITY_Z = 87
DynamicBodyDrone.MAX_VELOCITY_XY = 450
DynamicBodyDrone.FALLING_MIN_VELOCITY = -75
DynamicBodyDrone.ANCHOR_OFFSET_XY = 2000
DynamicBodyDrone.ANCHOR_DELAY = 10

DynamicBodyDrone.EMP_LENGTH = 10
DynamicBodyDrone.EMP_LENGTH_MINI = 0.7


-- Disable this if its not disabled <3
-- blt.forcepcalls(true)


function DynamicBodyDrone:init(unit)
	self._unit = unit
	
	-- damage
	self._health = 25
	self._dead = false
	self._invulnerable = false
	self._damaged = false
	self._emp_length = 0
	
	if self._ignore_client_damage then
		if Network:is_server() then
			self._HEALTH_GRANULARITY = 5
		else
			self._health_ratio = 1
		end
	end
	
	if self._weakpoint then
		self._weakpoint_id = Idstring(self._weakpoint)
	end
	
	if self._weakpoint_critical then
		self._weakpoint_critical_id = Idstring(self._weakpoint_critical)
	end
	
	-- movement
	self._activated = false
	self._stunned = false
	self._speed_z = 1300
	self._speed_xy = 2300
	self._anchor_pos = unit:position()
	self._anchor_delay = DynamicBodyDrone.ANCHOR_DELAY
	
	self._seq_activate = "drone_loop_start"
	self._seq_deactivate = "drone_loop_stop"
	self._seq_damaged = "drone_damaged"
	self._seq_destroyed = "drone_destroyed"
	self._seq_emp = "drone_emp"
	self._seq_emp_recover = "drone_emp_recover"
	
	if self._activate_instantly then
		if self._unit:damage() and self._unit:damage():has_sequence(self._seq_activate) then
			self._unit:damage():run_sequence_simple(self._seq_activate)
			self._activated = true
		else
			log("[DynamicBodyDrone] This drone does not have sequence '"..self._seq_activate.."'!")
		end
	end
end


function DynamicBodyDrone:force_activation()
	if not self._activated then
		self._activated = true
	end
end

function DynamicBodyDrone:update(unit, t, dt)
	if self._dead or not self._activated then
		return
	end
	
	if t >= self._anchor_delay then
		self._anchor_delay = self._anchor_delay + DynamicBodyDrone.ANCHOR_DELAY
		self._anchor_pos = DynamicBodyDrone:set_new_anchor_point(self._anchor_pos)
	end
	
	local just_recovered = false
	if self._emp_length and self._emp_length > 0 then
		self._emp_length = self._emp_length - dt
		return -- no flying
	elseif self._is_emped then
		self:_recovered_from_emp()
		just_recovered = true
	end
	
	local body = self._unit:body("body_dynamic")
	if body:enabled() then
		local unit_pos = self._unit:position()						-- Position of drone
		local unit_vel = body:velocity()						-- Velocity of drone
		local anchor_off = self._anchor_pos                     -- Anchor position
		local speed = self._speed_z * dt                        -- The Vertical speed
		local speedxy = self._speed_xy * dt                     -- The Horizontal speed
		local tgt_dir = anchor_off - unit_pos                   -- Direction to get to anchor position
		mvector3.normalize(tgt_dir)								-- *Normalized
		
		
		-- VERTICAL
		local velz = 0
		local is_falling = unit_vel.z < DynamicBodyDrone.FALLING_MIN_VELOCITY		-- Falling too fast boolean
		if is_falling then
			velz = math.min(speed + -unit_vel.z, DynamicBodyDrone.MAX_VELOCITY_Z)	-- Speed up against inverse Z velocity
		elseif unit_vel.z < DynamicBodyDrone.MAX_VELOCITY_Z then
			local multi_z = anchor_off.z / unit_pos.z								-- Divided to get speed multiplier to ease a bit
			velz = math.min(speed * multi_z, DynamicBodyDrone.MAX_VELOCITY_Z)		-- Speed up if too slow, otherwise no velocity needed
		end
		
		-- HORIZONTAL
		local velx = DynamicBodyDrone:_horizontal_velocity(unit_vel.x, speedxy, tgt_dir.x)
		local vely = DynamicBodyDrone:_horizontal_velocity(unit_vel.y, speedxy, tgt_dir.y)
		
		
		-- APPLY VELOCITY
		unit_vel = unit_vel * 0.992 -- just a smidge of air resistance
		body:set_velocity(unit_vel + Vector3(velx, vely, velz))
		
		
		-- TURN VELOCITY TO ROTATION
		local sway_multi = 0.02
		local rotation = Rotation(
			0,							-- Currently zero, if used other rotations would not work right
			-unit_vel.y * sway_multi,   --
			 unit_vel.x * sway_multi	-- X must be inverted to go turn the right way
		)
		body:set_rotation(rotation)
	end
end


function DynamicBodyDrone:_horizontal_velocity(axis_velocity, axis_speed, axis_direction)
	if math.abs(axis_velocity) < DynamicBodyDrone.MAX_VELOCITY_XY then
		-- If the drone is below max horizontal velocity return speed times direction
		return axis_speed * axis_direction
	else
		-- Else decrease negative velocity for returned slowdown effect
		return -axis_velocity * 0.1337
	end
end


function DynamicBodyDrone:activate_drone()
	if not self._dead and not self._activated then
		self._activated = true
	end
end


function DynamicBodyDrone:set_new_anchor_point(from)
	local offx = math.rand(DynamicBodyDrone.ANCHOR_OFFSET_XY)-DynamicBodyDrone.ANCHOR_OFFSET_XY/2
	local offy = math.rand(DynamicBodyDrone.ANCHOR_OFFSET_XY)-DynamicBodyDrone.ANCHOR_OFFSET_XY/2
	return from + Vector3(offx, offy, 0)
end


-- DAMAGE PORTION

function DynamicBodyDrone:melee_hit_sfx()
	return "hit_gen"
end

function DynamicBodyDrone:stun_hit(attack_data)
	if self._dead or self._invulnerable then
		return
	end
	log("[DynamicBodyDrone] stun_hit(attack_data)")
	-- PrintTable(attack_data)
end

function DynamicBodyDrone:damage_bullet(attack_data)
	if self._dead or self._invulnerable or Network:is_client() then
		return
	end
	
	local hit_body = attack_data.col_ray.body
	local hit_body_name = hit_body:name()
	
	local hit_weakspot = hit_body and hit_body_name == self._weakpoint_id
	local hit_critspot = hit_body and hit_body_name == self._weakpoint_critical_id

	if hit_critspot then
		self:_die_instant_critical()
	
	elseif hit_weakspot then
		self._health = self._health - attack_data.damage
		managers.hud:on_hit_confirmed()
		if self._health <= 0 then
			self:_drone_destroyed()
		else
			self:_drone_damaged()
		end
	end
end

function DynamicBodyDrone:damage_tase(attack_data)
	if self._dead or self._invulnerable then
		return
	end
	
	self._health = self._health - attack_data.damage
	managers.hud:on_hit_confirmed()
	if self._health <= 0 then
		self:_drone_destroyed()
	else
		self:_drone_damaged()
		self:_add_emp_time(DynamicBodyDrone.EMP_LENGTH)
	end
end

function DynamicBodyDrone:damage_fire(attack_data)
	if self._dead or self._invulnerable then
		return
	end
	
	local damage = (attack_data.fire_dot_data.dot_damage * attack_data.fire_dot_data.dot_length)/60
	damage = damage + attack_data.damage
	
	self._health = self._health - damage
	managers.hud:on_hit_confirmed()
	if self._health <= 0 then
		self:_drone_destroyed()
	else
		self:_drone_damaged()
	end
end

function DynamicBodyDrone:damage_explosion(attack_data)
	if self._dead or self._invulnerable then
		return
	end
	self:_die_instant_critical()
end

function DynamicBodyDrone:_die_instant_critical()
	self._health = 0
	self:_drone_destroyed()
	managers.hud:on_crit_confirmed()
end

function DynamicBodyDrone:sync_health(health_ratio)
	self._health_ratio = health_ratio / self._HEALTH_GRANULARITY

	if health_ratio == 0 then
		self:die()
	end
end

function DynamicBodyDrone:on_marked_state(state)
	if state then
		self._marked_dmg_mul = self._marked_dmg_mul or tweak_data.upgrades.values.player.marked_enemy_damage_mul
	else
		self._marked_dmg_mul = nil
	end
end

function DynamicBodyDrone:die(attacker_unit, variant, options)
	log("[DynamicBodyDrone] die(attacker_unit, variant, options)")
end

function DynamicBodyDrone:dead()
	return self._dead
end


function DynamicBodyDrone:_drone_damaged()
	if not self._damaged then
		self._damaged = true
		if self._unit and self._unit:damage() and self._unit:damage():has_sequence(self._seq_damaged) then
			self._unit:damage():run_sequence_simple(self._seq_damaged)
		else
			log("DynamicBodyDrone: This drone does not have sequence '"..self._seq_damaged.."'!")
		end
	end
end


function DynamicBodyDrone:_add_emp_time(amount)
	self._is_emped = true
	if self._emp_length <= 0 then
		self._emp_length = amount
		if self._unit and self._unit:damage() and self._unit:damage():has_sequence(self._seq_emp) then
			self._unit:damage():run_sequence_simple(self._seq_emp)
		else
			log("DynamicBodyDrone: This drone does not have sequence '"..self._seq_emp.."'!")
		end
	else
		self._emp_length = self._emp_length + amount
	end
end


function DynamicBodyDrone:_recovered_from_emp()
	self._is_emped = false
	if self._unit:damage() and self._unit:damage():has_sequence(self._seq_emp_recover) then
		self._unit:damage():run_sequence_simple(self._seq_emp_recover)
		self._activated = true
	else
		log("[DynamicBodyDrone] This drone does not have sequence '"..self._seq_emp_recover.."'!")
	end
end


function DynamicBodyDrone:_drone_destroyed()
	if not self._dead then
		self._dead = true
		
		if self._unit and self._unit:damage() and self._unit:damage():has_sequence(self._seq_destroyed) then
			self._unit:damage():run_sequence_simple(self._seq_destroyed)
			self._activated = false
		else
			log("DynamicBodyDrone: This drone does not have sequence '"..self._seq_destroyed.."'!")
		end
	end
end