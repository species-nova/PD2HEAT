local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_cpy = mvector3.copy
local mvec3_dis = mvector3.distance
local mvec1 = Vector3()
local zero_vel_vec = Vector3(0, 0, 0)

local teleport_rot = Rotation()

local math_random = math.random
local math_up = math.UP
local math_round = math.round
local math_lerp = math.lerp

local ids_g_bag = Idstring("g_bag")
local ids_g_canvasbag = Idstring("g_canvasbag")
local ids_g_g = Idstring("g_g")
local ids_g_goat = Idstring("g_goat")
local ids_g_bodybag = Idstring("g_bodybag")
local carry_data_idstr = Idstring("carry_data")
local col_throw_idstr = Idstring("throw")
local parent_obj_name = Idstring("Neck")
local bag_moving_idstr = Idstring("bag_moving")
local bag_still_idstr = Idstring("bag_still")
local dye_pack_idstr = Idstring("effects/payday2/particles/dye_pack/dye_pack_smoke")

local pairs_g = pairs
local tostring_g = tostring

local deep_clone_g = deep_clone
local alive_g = alive
local world_g = World
local call_on_next_update_g = call_on_next_update

CarryData.EVENT_IDS.dye_pack_exploded = 4
CarryData._carrying_units = {}

function CarryData:init(unit)
	self._unit = unit
	self._dye_initiated = false
	self._has_dye_pack = false
	self._dye_value_multiplier = 100
	self._linked_to = nil

	local is_server = Network:is_server()
	self._is_server = is_server

	local carry_id = self._carry_id

	if carry_id then
		--define everything once instead of constantly having to check static values and variables
		self._value = managers.money:get_bag_value(carry_id, self._multiplier)

		local carry_tweaks = tweak_data.carry
		local carry_tweak_info = carry_tweaks.types[carry_tweaks[carry_id].type]

		if is_server then
			self._AI_carry = carry_tweaks[carry_id].AI_carry
			self._AI_can_run = carry_tweak_info.can_run and true
		end

		self._can_explode = carry_tweak_info.can_explode and true
		self._can_poof = carry_tweak_info.can_poof and true
	else
		self._value = tweak_data:get_value("money_manager", "bag_values", "default")
	end

	if not is_server then
		--clients literally don't need to update anything in this extension, no need to waste performance
		unit:set_extension_update_enabled(carry_data_idstr, false)

		self._link_body = unit:body("hinge_body_1") or unit:body(0)

		return
	end

	self._linked_ai = {}

	if unit:interaction() then
		local has_no_dynamic_body = true
		local nr_bodies = unit:num_bodies()
		local dynamic_bodies = {}

		for i = 0, nr_bodies - 1 do
			local body = unit:body(i)

			if body:dynamic() then
				has_no_dynamic_body = false

				break
			end
		end

		if has_no_dynamic_body then
			--there are a LOT of units with this extension that are just static units
			--we don't want the team AI to grab them nor to even check for it frame by frame
			unit:set_extension_update_enabled(carry_data_idstr, false)
		else
			local link_body = unit:body("hinge_body_1") or unit:body(0)

			if link_body then
				self._link_body = link_body

				local get_obj_f = unit.get_object
				local link_obj = get_obj_f(unit, ids_g_bag) or get_obj_f(unit, ids_g_canvasbag) or get_obj_f(unit, ids_g_g) or get_obj_f(unit, ids_g_goat) or get_obj_f(unit, ids_g_bodybag)

				if link_obj then
					self._link_obj = link_obj
				else
					--no object to check for bots to link to
					unit:set_extension_update_enabled(carry_data_idstr, false)
				end
			else
				--no body that will be used as orientation when linking to a unit
				unit:set_extension_update_enabled(carry_data_idstr, false)
			end
		end

		--_air_start_t gets redefined each time the bag collides with something
		--thus we want to store when the bag was spawned (thrown by players in most cases)
		self._spawn_time = TimerManager:game():time()
	else
		--no interaction extension = can't be bagged or thrown, and thus there's no need to check for bots grabbing them
		unit:set_extension_update_enabled(carry_data_idstr, false)
	end
end

function CarryData:update(unit, t, dt)
	--the only needed function to update here, and only for the server
	self:_update_throw_link(unit, t, dt)
end

function CarryData:_get_carry_body(unit)
	local chars = tweak_data.criminals.characters
	local get_obj_f = unit.get_object
	local body = nil

	for i = 1, #chars do
		local character = chars[i]
		body = get_obj_f(unit, character.body_g_object)

		if body then
			return body
		end
	end

	return nil
end

function CarryData:_update_throw_link(unit, t, dt)
	local spawn_time = self._spawn_time

	if not spawn_time or t > spawn_time + 1 then
		--after 1 second of spawning (usually by being thrown by players), stop checking for bots to link to
		self._unit:set_extension_update_enabled(carry_data_idstr, false)

		return
	end

	local link_object = self._link_obj

	if not link_object or not link_object:visibility() then
		--in case somehow updating got reenabled
		self._unit:set_extension_update_enabled(carry_data_idstr, false)

		return
	end

	local bag_center = link_object:oobb():center()
	local linked_ai = self._linked_ai
	local get_carry_body_f = self._get_carry_body
	local carrying_units = CarryData._carrying_units --bots carrying bags, stored globally
	local last_peer_id = self:latest_peer_id()

	--clients will have an easier time giving bags to bots, might eventually overhaul the system to make it work more locally
	local oobb_mod = last_peer_id and last_peer_id ~= managers.network:session():local_peer():id() and 50 or 25

	for key, ai in pairs_g(managers.groupai:state():all_AI_criminals()) do
		if not carrying_units[key] then --infinitely faster than checking each linked unit of the bot and if one of them has a carry_data extension
			if not linked_ai[key] or t > linked_ai[key] + 1 then --ignore this bot if the bag was recently thrown by them
				local ai_unit = ai.unit
				local mov_ext = ai_unit:movement()

				if not mov_ext.vehicle_unit and not mov_ext:cool() and not mov_ext:downed() then
					local body = get_carry_body_f(self, ai_unit)

					if body then
						local body_oobb = body:oobb()
						body_oobb:grow(oobb_mod)

						if body_oobb:point_inside(bag_center) then
							body_oobb:shrink(oobb_mod)

							self:link_to(ai_unit, false)

							break
						end

						body_oobb:shrink(oobb_mod)
					end
				end
			end
		end
	end
end

function CarryData:_check_dye_explode()
	local chance = math_random()

	if chance < 0.25 then
		self._dye_risk = nil

		self:_dye_exploded()

		return
	end

	self._dye_risk.next_t = TimerManager:game():time() + 2 + math_random(3)
end

function CarryData:_dye_exploded()
	local unit = self._unit

	managers.network:session():send_to_peers_synched("sync_unit_event_id_16", unit, "carry_data", CarryData.EVENT_IDS.dye_pack_exploded)

	local value = self._value
	value = value * (1 - self._dye_value_multiplier / 100)
	value = math_round(value)

	self._value = value

	self._has_dye_pack = false

	self._dye_pack_smoke = world_g:effect_manager():spawn({
		effect = dye_pack_idstr,
		parent = unit:orientation_object()
	})

	self._remove_dye_smoke_id = "_remove_dye_smoke_id" .. tostring_g(unit:key())
	managers.enemy:add_delayed_clbk(self._remove_dye_smoke_id, callback(self, self, "_remove_dye_smoke"), TimerManager:game():time() + 5)
end

function CarryData:_remove_dye_smoke()
	local dye_pack_smoke = self._dye_pack_smoke

	if dye_pack_smoke then
		world_g:effect_manager():fade_kill(dye_pack_smoke)

		self._dye_pack_smoke = nil
	end
end

function CarryData:check_explodes_on_impact(vel_vector, air_time)
	if not self:can_explode() or air_time < 0.5 then
		return
	end

	local vel = vel_vector:length()
	local vel_limit = 500

	if vel < vel_limit then
		return
	end

	local vel_lerp = (vel - vel_limit) / (1200 - vel_limit)
	vel_lerp = vel_lerp > 1 and 1 or vel_lerp

	local chance = math_lerp(0, 0.9, vel_lerp)

	if math_random() <= chance then
		self:start_explosion()

		return true
	end
end

function CarryData:can_explode()
	if not self._is_server or self._disarmed or self._linked_to or self._explode_t then
		return false
	end

	return self._can_explode
end

function CarryData:can_poof()
	return self._can_poof
end

function CarryData:start_explosion(instant)
	if not self:can_explode() then
		return
	end

	self:_unregister_steal_SO()
	self:_start_explosion()

	if not instant then
		local unit = self._unit

		managers.network:session():send_to_peers_synched("sync_unit_event_id_16", unit, "carry_data", CarryData.EVENT_IDS.will_explode)

		local explode_t = TimerManager:game():time() + 1 + math_random() * 3
		self._explode_t = explode_t
		self._delayed_explode_id = "_delayed_carry_explosion" .. tostring_g(unit:key())

		--use a delayed callback for delayed explosions rather than checking the timer frame by frame
		managers.enemy:add_delayed_clbk(self._delayed_explode_id, callback(self, self, "_delayed_explosion"), explode_t)
	else
		self._explode_t = TimerManager:game():time()

		self:_explode()
	end
end

function CarryData:_delayed_explosion()
	self._delayed_explode_id = nil

	self:_explode()
end

function CarryData:disarm()
	local delayed_explode_id = self._delayed_explode_id

	if delayed_explode_id then
		managers.enemy:remove_delayed_clbk(delayed_explode_id)

		self._delayed_explode_id = nil
	end

	self._explode_t = nil
	self._disarmed = true
end

function CarryData:_explode()
	managers.mission:call_global_event("loot_exploded")

	local my_unit = self._unit
	local pos = my_unit:position()
	local normal = math_up
	local range = CarryData.EXPLOSION_SETTINGS.range
	local half_range = range / 2
	local slotmask = managers.slot:get_mask("explosion_targets")
	local splinter_slotmask = managers.slot:get_mask("world_geometry")

	self:_local_player_explosion_damage()
	managers.explosion:play_sound_and_effects(pos, normal, range, CarryData.EXPLOSION_CUSTOM_PARAMS)

	QuickFlashGrenade:make_flash(pos, range, {
		my_unit
	})

	local hit_units, splinters = managers.explosion:detect_and_give_dmg({
		player_damage = 0,
		hit_pos = pos,
		range = range,
		collision_slotmask = slotmask,
		curve_pow = CarryData.EXPLOSION_SETTINGS.curve_pow,
		damage = CarryData.EXPLOSION_SETTINGS.damage,
		ignore_unit = my_unit
	})

	managers.network:session():send_to_peers_synched("sync_unit_event_id_16", my_unit, "carry_data", CarryData.EVENT_IDS.explode)
	my_unit:set_slot(0)

	for _, hit_unit in pairs_g(hit_units) do
		local hit_carry_ext = hit_unit:carry_data()

		if hit_carry_ext and hit_carry_ext:can_explode() then
			mvec3_set(mvec1, hit_unit:position())

			local distance = mvec3_dis(pos, mvec1)
			local dis_lerp = distance - half_range
			local chk_explode = nil

			if dis_lerp > 0 then
				dis_lerp = dis_lerp / range

				local chance = math_lerp(1, 0, dis_lerp / range)
				chk_explode = math_random() < chance
			else
				chk_explode = true
			end

			if chk_explode then
				for i = 1, #splinters do
					local s_pos = splinters[i]
					local ray_hit = not my_unit:raycast("ray", s_pos, mvec1, "slot_mask", splinter_slotmask, "report")

					if ray_hit then
						hit_carry_ext:start_explosion(true)

						break
					end
				end
			end
		end
	end
end

--synced poofs normally execute server-only code, which as you'd guess, it's bad
--just play the effects instead (the unit will be despawned right after by the host)
function CarryData:_sync_poof()
	local pos = self._unit:position()
	local normal = math_up
	local range = CarryData.POOF_SETTINGS.range

	managers.explosion:play_sound_and_effects(pos, normal, range, CarryData.POOF_CUSTOM_PARAMS)
end

local sync_net_event_original = CarryData.sync_net_event
function CarryData:sync_net_event(event_id)
	if event_id == CarryData.EVENT_IDS.poof then
		self:_sync_poof()

		return
	elseif event_id == CarryData.EVENT_IDS.dye_pack_exploded then
		self:sync_dye_exploded()

		return
	end

	sync_net_event_original(self, event_id)
end

function CarryData:clbk_out_of_world()
	local unit = self._unit

	if unit:position().z >= PlayerMovement.OUT_OF_WORLD_Z then
		managers.enemy:add_delayed_clbk(self._register_out_of_world_clbk_id, callback(self, self, "clbk_out_of_world"), TimerManager:game():time() + 2)

		return
	end

	self._register_out_of_world_clbk_id = nil

	local nr_bodies = unit:num_bodies()
	local dynamic_bodies = {}

	for i = 0, nr_bodies - 1 do
		local body = unit:body(i)

		if body:dynamic() then
			body:set_keyframed()

			dynamic_bodies[#dynamic_bodies + 1] = body
		end
	end

	call_on_next_update_g(function ()
		if not alive_g(unit) then
			return
		end

		local temp_tracker = managers.navigation:create_nav_tracker(unit:position(), false)

		unit:set_position(temp_tracker:field_position())
		managers.navigation:destroy_nav_tracker(temp_tracker)

		unit:set_velocity(zero_vel_vec)
		unit:set_rotation(teleport_rot)

		call_on_next_update_g(function ()
			if not alive_g(unit) then
				return
			end

			for i = 1, #dynamic_bodies do
				local body = dynamic_bodies[i]

				body:set_dynamic()
			end
		end)
	end)
end

local set_carry_id_original = CarryData.set_carry_id
function CarryData:set_carry_id(carry_id)
	if carry_id then
		--define everything related to the carry id just like in the init function
		local carry_tweaks = tweak_data.carry
		local carry_tweak_info = carry_tweaks.types[carry_tweaks[carry_id].type]

		if self._is_server then
			self._AI_carry = carry_tweaks[carry_id].AI_carry
			self._AI_can_run = carry_tweak_info.can_run and true
		end

		self._can_explode = carry_tweak_info.can_explode and true
		self._can_poof = carry_tweak_info.can_poof and true
	end

	set_carry_id_original(self, carry_id)
end

function CarryData:_chk_register_steal_SO()
	local my_unit = self._unit
	local link_body = self._link_body

	if not self._has_body_activation_clbk then
		self._has_body_activation_clbk = {
			[link_body:key()] = true
		}

		my_unit:add_body_activation_callback(callback(self, self, "clbk_body_active_state"))
		link_body:set_activate_tag(bag_moving_idstr)
		link_body:set_deactivate_tag(bag_still_idstr)
	end

	if not self._is_server or self._steal_SO_data or self._linked_to or link_body:active() or not managers.navigation:is_data_ready() then
		return
	end

	local AI_carry = self._AI_carry

	if not AI_carry then
		return
	end

	local SO_category = AI_carry.SO_category
	local SO_filter = managers.navigation:convert_SO_AI_group_to_access(SO_category)
	local tracker_pickup = managers.navigation:create_nav_tracker(my_unit:position(), false)
	local pickup_nav_seg = tracker_pickup:nav_segment()
	local pickup_pos = tracker_pickup:field_position()
	local pickup_area = managers.groupai:state():get_area_from_nav_seg_id(pickup_nav_seg)

	managers.navigation:destroy_nav_tracker(tracker_pickup)

	if pickup_area.enemy_loot_drop_points then
		return
	end

	local drop_pos, drop_nav_seg, drop_area = nil
	local drop_point = managers.groupai:state():get_safe_enemy_loot_drop_point(pickup_nav_seg)

	if drop_point then
		drop_pos = mvec3_cpy(drop_point.pos)
		drop_nav_seg = drop_point.nav_seg
		drop_area = drop_point.area
	elseif not self._register_steal_SO_clbk_id then
		self._register_steal_SO_clbk_id = "CarryDataregiserSO" .. tostring_g(my_unit:key())

		managers.enemy:add_delayed_clbk(self._register_steal_SO_clbk_id, callback(self, self, "clbk_register_steal_SO"), TimerManager:game():time() + 10)

		return
	end

	local stand_run = self._AI_can_run
	local drop_objective = {
		type = "act",
		interrupt_health = 0.9,
		haste = stand_run and "run" or "walk",
		pose = stand_run and "stand" or "crouch",
		interrupt_dis = 700,
		nav_seg = drop_nav_seg,
		pos = drop_pos,
		area = drop_area,
		fail_clbk = callback(self, self, "on_secure_SO_failed"),
		complete_clbk = callback(self, self, "on_secure_SO_completed"),
		action = {
			variant = "untie",
			align_sync = true,
			body_part = 1,
			type = "act"
		},
		path_ahead = true,
		action_duration = 1
	}
	local pickup_objective = {
		destroy_clbk_key = false,
		type = "act",
		haste = "run",
		interrupt_health = 0.9,
		pose = "crouch",
		interrupt_dis = 700,
		nav_seg = pickup_nav_seg,
		area = pickup_area,
		pos = pickup_pos,
		fail_clbk = callback(self, self, "on_pickup_SO_failed"),
		complete_clbk = callback(self, self, "on_pickup_SO_completed"),
		action = {
			variant = "untie",
			align_sync = true,
			body_part = 1,
			type = "act"
		},
		action_duration = 1,
		followup_objective = drop_objective
	}
	local so_descriptor = {
		interval = 0,
		base_chance = 1,
		chance_inc = 0,
		usage_amount = 1,
		objective = pickup_objective,
		search_pos = pickup_objective.pos,
		verification_clbk = callback(self, self, "clbk_pickup_SO_verification"),
		AI_group = AI_carry.SO_category,
		admin_clbk = callback(self, self, "on_pickup_SO_administered")
	}
	local so_id = "carrysteal" .. tostring_g(my_unit:key())
	self._steal_SO_data = {
		SO_registered = true,
		picked_up = false,
		SO_id = so_id,
		pickup_area = pickup_area,
		pickup_objective = pickup_objective,
		bag_secure_pos = drop_pos
	}

	managers.groupai:state():add_special_objective(so_id, so_descriptor)
	managers.groupai:state():register_loot(my_unit, pickup_area)
end

function CarryData:clbk_pickup_SO_verification(candidate_unit)
	local so_data = self._steal_SO_data

	if not so_data or not so_data.SO_id then
		return
	end

	if not candidate_unit:base():char_tweak().steal_loot then
		return
	end

	local candidate_mov_ext = candidate_unit:movement()

	if candidate_mov_ext:cool() then
		return
	end

	local nav_seg = candidate_mov_ext:nav_tracker():nav_segment()

	if not so_data.pickup_area.nav_segs[nav_seg] then
		return
	end

	return true
end

function CarryData:on_secure_SO_completed(thief)
	local so_data = self._steal_SO_data

	if thief ~= so_data.thief then
		return
	end

	self._steal_SO_data = nil

	managers.mission:call_global_event("loot_lost")

	self:unlink()

	--this shouldn't be needed, but if the function stops here somehow, something might be fucked somewhere else
	if not so_data.bag_secure_pos then
		return
	end

	--ensure the bag arrives at the loot point properly for clients
	local unit = self._unit
	local client_teleport_pos = Vector3()
	mvec3_set(client_teleport_pos, so_data.bag_secure_pos)
	mvec3_set_z(client_teleport_pos, unit:position().z)

	managers.network:session():send_to_peers_synched("sync_carry_set_position_and_throw", unit, client_teleport_pos, Vector3(0, 0, 0), 0)
end

function CarryData:on_secure_SO_failed(thief)
	local so_data = self._steal_SO_data

	if not so_data.thief or thief ~= so_data.thief then
		return
	end

	self._steal_SO_data = nil

	self:_chk_register_steal_SO()
	self:unlink()
end

function CarryData:link_to(parent_unit, keep_collisions)
	local link_body = self._link_body

	if not link_body then
		return
	end

	--forcing to false because the way this works is intended to make units drop bags when colliding with out of bounds borders
	--but even when it works properly with the fixes I added, it can trigger with other invisible units due to lack of filters
	keep_collisions = false

	local is_server = self._is_server
	local already_linked_to = self._linked_to

	if already_linked_to then
		local linked_mov_ext = already_linked_to:movement()

		if linked_mov_ext and linked_mov_ext.set_carrying_bag then
			already_linked_to:movement():set_carrying_bag(nil)
		end

		if is_server and managers.groupai:state():is_unit_team_AI(already_linked_to) then
			local link_key = already_linked_to:key()

			CarryData._carrying_units[link_key] = nil

			self._linked_ai[link_key] = TimerManager:game():time()
		end
	end

	local my_unit = self._unit
	local int_ext = my_unit:interaction()
	local had_modifier_timer = nil

	if int_ext then
		had_modifier_timer = int_ext._has_modified_timer and true

		--allow the bag to be grabbed instantly
		int_ext._has_modified_timer = true
		int_ext._air_start_time = Application:time()
	end

	--will happen after disabling collisions further below
	call_on_next_update_g(function ()
		if not alive_g(my_unit) or not alive(parent_unit) then
			return
		end

		link_body:set_keyframed()

		call_on_next_update_g(function ()
			if not alive_g(my_unit) or not alive(parent_unit) then
				return
			end

			parent_unit:link(parent_obj_name, my_unit)

			local parent_obj = parent_unit:get_object(parent_obj_name)
			local parent_obj_rot = parent_obj:rotation()
			local world_pos = parent_obj:position() - parent_obj_rot:z() * 30 - parent_obj_rot:y() * 10

			my_unit:set_position(world_pos)
			my_unit:set_velocity(zero_vel_vec)

			local world_rot = Rotation(parent_obj_rot:x(), -parent_obj_rot:z())

			my_unit:set_rotation(world_rot)
		end)
	end)

	if keep_collisions and is_server then
		self._kept_collisions = true

		my_unit:set_body_collision_callback(callback(self, self, "_collision_callback"))

		if int_ext and not had_modifier_timer then
			local nr_bodies = my_unit:num_bodies()

			--like when bags are spawned by players (thrown), the collision script tag neeeds to be set
			--as hitting something before the bag is linked will set an empty idstring for the script
			--causing it to not register collisions with the "throw" tag as intended, unless the bag can explode
			for i_body = 0, nr_bodies - 1 do
				local body = my_unit:body(i_body)

				body:set_collision_script_tag(col_throw_idstr)
				body:set_collision_script_filter(1)
				body:set_collision_script_quiet_time(1)
			end
		end
	else
		local nr_bodies = my_unit:num_bodies()
		local disabled_collisions = {}

		for i_body = 0, nr_bodies - 1 do
			local body = my_unit:body(i_body)

			if body:collisions_enabled() then
				body:set_collisions_enabled(false)

				disabled_collisions[#disabled_collisions + 1] = body
			end
		end

		self._disabled_collisions = disabled_collisions
	end

	local parent_mov_ext = parent_unit:movement()

	if parent_mov_ext and parent_mov_ext.set_carrying_bag then
		parent_mov_ext:set_carrying_bag(my_unit)
	end

	self._linked_to = parent_unit

	if not is_server then
		return
	end

	if managers.groupai:state():is_unit_team_AI(parent_unit) then
		CarryData._carrying_units[parent_unit:key()] = true

		parent_unit:sound():say("r03x_sin", true)
	end

	managers.network:session():send_to_peers_synched("loot_link", my_unit, parent_unit)

	--disable updating when linked, no need to check for other bots to link to
	my_unit:set_extension_update_enabled(carry_data_idstr, false)
end

function CarryData:_collision_callback(tag, unit, body, other_unit, other_body, position, normal, velocity, ...)
	if tag ~= col_throw_idstr or other_unit:visible() then
		return
	end

	--set_disable_collision_with_unit doesn't really do anything, so this is kinda useless
	--[[if other_unit:visible() then
		local to_restore = self._collisions_to_restore or {}

		to_restore[#to_restore + 1] = other_unit

		self._collisions_to_restore = to_restore

		unit:set_disable_collision_with_unit(other_unit)
		unit:set_body_collision_callback(callback(self, self, "_collision_callback"))
	else]]
		local bag_pos = mvec3_cpy(unit:position())
		local col_pos = mvec3_cpy(position)
		local linked_to = self._linked_to
		local linked_mov_ext = linked_to and linked_to:movement()

		if linked_mov_ext and linked_mov_ext.set_carrying_bag then
			linked_to:movement():throw_bag()
		else
			unit:carry_data():unlink()
		end

		call_on_next_update_g(function ()
			if not alive_g(unit) then
				return
			end

			--ensure the bag actually stays in bounds by using the point of contact + inverted velocity vector
			local inv_vel = -velocity
			local dir = col_pos - bag_pos
			dir = dir * inv_vel
			local len_diff = dir:length()
			dir = dir:normalized()

			col_pos = col_pos + dir * (len_diff + 50)

			self:set_position_and_throw(col_pos, Vector3(0, 0, 0), 1)
		end)
	--end
end

function CarryData:unlink()
	local link_body = self._link_body

	if not link_body then
		return
	end

	local is_server = self._is_server
	local my_unit = self._unit
	local int_ext = my_unit:interaction()

	if int_ext then
		--ensure again that the bag to be grabbed instantly
		--in this case, until it collides with something
		int_ext._has_modified_timer = true
		int_ext._air_start_time = Application:time()
	end

	local linked_to = self._linked_to

	if linked_to then
		if is_server and managers.groupai:state():is_unit_team_AI(linked_to) then
			local link_key = linked_to:key()

			CarryData._carrying_units[link_key] = nil

			self._linked_ai[link_key] = TimerManager:game():time()
		end

		local linked_mov_ext = linked_to:movement()

		if linked_mov_ext and linked_mov_ext.set_carrying_bag then
			linked_mov_ext:set_carrying_bag(nil)
		end
	end

	self._linked_to = nil

	my_unit:unlink()

	link_body:set_dynamic()

	local disabled_collisions = self._disabled_collisions

	if disabled_collisions then
		for i = 1, #disabled_collisions do
			local body = disabled_collisions[i]

			body:set_collisions_enabled(true)
		end

		self._disabled_collisions = nil
	elseif self._kept_collisions then
		--just like set_disable_collision_with_unit, I'm commenting this out since it doesn't do anything
		--[[local to_restore = self._collisions_to_restore

		if to_restore then
			for i = 1, #to_restore do
				local other_unit = to_restore[i]

				if alive_g(other_unit) then
					my_unit:set_enable_collision_with_unit(other_unit)
				end
			end

			self._collisions_to_restore = nil
		end]]

		self._kept_collisions = nil
	end

	if int_ext then
		int_ext:register_collision_callbacks()
	end

	if not is_server then
		return
	end

	managers.network:session():send_to_peers_synched("loot_link", my_unit, my_unit)
end

function CarryData:clbk_body_active_state(tag, unit, body, activated)
	if not self._has_body_activation_clbk[body:key()] then
		return
	end

	local oow_clbk_id = self._register_out_of_world_clbk_id

	if activated then
		local so_data = self._steal_SO_data

		if not so_data or not so_data.picked_up then
			self:_unregister_steal_SO()
		end

		if not oow_clbk_id then
			oow_clbk_id = "BagOutOfWorld" .. tostring_g(self._unit:key())
			self._register_out_of_world_clbk_id = oow_clbk_id

			managers.enemy:add_delayed_clbk(oow_clbk_id, callback(self, self, "clbk_out_of_world"), TimerManager:game():time() + 2)
		end
	else
		self:_chk_register_steal_SO()

		if oow_clbk_id then
			managers.enemy:remove_delayed_clbk(oow_clbk_id)

			self._register_out_of_world_clbk_id = nil
		end
	end
end

function CarryData:set_zipline_unit(zipline_unit)
	self._zipline_unit = zipline_unit

	local my_unit = self._unit

	if zipline_unit then
		if self._is_server then
			--no need to check for team AI linking while attached to a zipline
			my_unit:set_extension_update_enabled(carry_data_idstr, false)
		end

		if zipline_unit:zipline():ai_ignores_bag() then
			local att_ext = my_unit:attention()

			if att_ext then
				local att_data = att_ext:attention_data()

				--ensure that there's attention data to save
				if att_data then
					self._saved_attention_data = deep_clone_g(att_data)

					for attention_id, _ in pairs_g(self._saved_attention_data) do
						att_ext:remove_attention(attention_id)
					end
				end
			end
		end
	else
		if self._saved_attention_data then
			local att_ext = self._unit:attention()

			for attention_id, attention_data in pairs_g(self._saved_attention_data) do
				att_ext:add_attention(attention_data)
			end

			self._saved_attention_data = nil
		end

		local int_ext = my_unit:interaction()

		if int_ext then
			--allow the bag to be grabbed instantly
			int_ext._has_modified_timer = true
			int_ext._air_start_time = Application:time()
		end
	end
end

function CarryData:destroy()
	local dye_pack_smoke = self._dye_pack_smoke

	if dye_pack_smoke then
		world_g:effect_manager():fade_kill(dye_pack_smoke)

		self._dye_pack_smoke = nil
	end

	local dye_smoke_id = self._remove_dye_smoke_id
	local delayed_explode_id = self._delayed_explode_id
	local so_clbk_id = self._register_steal_SO_clbk_id
	local oow_clbk_id = self._register_out_of_world_clbk_id
	local oow_dyn_clbk_id = self._register_out_of_world_dynamic_clbk_id

	if dye_smoke_id then
		managers.enemy:remove_delayed_clbk(dye_smoke_id)

		self._remove_dye_smoke_id = nil
	end

	if delayed_explode_id then
		managers.enemy:remove_delayed_clbk(delayed_explode_id)

		self._delayed_explode_id = nil
	end

	if so_clbk_id then
		managers.enemy:remove_delayed_clbk(so_clbk_id)

		self._register_steal_SO_clbk_id = nil
	end

	if oow_clbk_id then
		managers.enemy:remove_delayed_clbk(oow_clbk_id)

		self._register_out_of_world_clbk_id = nil
	end

	if oow_dyn_clbk_id then
		managers.enemy:remove_delayed_clbk(oow_dyn_clbk_id)

		self._register_out_of_world_dynamic_clbk_id = nil
	end

	self:_unregister_steal_SO()

	local linked_to = self._linked_to

	if alive_g(linked_to) then
		local linked_mov_ext = linked_to:movement()

		if linked_mov_ext and linked_mov_ext.set_carrying_bag then
			linked_to:movement():set_carrying_bag(nil)
		end

		if self._is_server and managers.groupai:state():is_unit_team_AI(linked_to) then
			local link_key = linked_to:key()

			CarryData._carrying_units[link_key] = nil
		end
	end

	self._linked_to = nil
end

--teleporting units with dynamic bodies can all be done through one function by using "call_on_next_update"
--or by updating frame by frame and checking what's the next step
--the former is preferable and requires no extra code in update functions
function CarryData:teleport_to(pos)
	self._teleport = pos

	local unit = self._unit
	local nr_bodies = unit:num_bodies()
	local dynamic_bodies = {}

	for i = 0, nr_bodies - 1 do
		local body = unit:body(i)

		if body:dynamic() then
			body:set_keyframed()

			dynamic_bodies[#dynamic_bodies + 1] = body
		end
	end

	call_on_next_update_g(function ()
		if not alive_g(unit) then
			return
		end

		unit:set_position(pos)
		unit:set_velocity(zero_vel_vec)
		unit:set_rotation(teleport_rot)

		call_on_next_update_g(function ()
			if not alive_g(unit) then
				return
			end

			for i = 1, #dynamic_bodies do
				local body = dynamic_bodies[i]

				body:set_dynamic()
			end

			call_on_next_update_g(function ()
				if not alive_g(unit) then
					return
				end

				local push_params = self._teleport_push

				if not push_params then
					self._teleport = nil

					return
				end

				self._teleport_push = nil

				local force = push_params[1]
				local direction = push_params[2]

				unit:push(force, direction)

				self._teleport = nil
			end)
		end)
	end)
end

function CarryData:set_position_and_throw(position, direction, force)
	if not self._linked_to then
		self:teleport_push(force, direction)
		self:teleport_to(position)
	end

	if self._is_server then
		managers.network:session():send_to_peers_synched("sync_carry_set_position_and_throw", self._unit, position, direction, force)
	end
end
