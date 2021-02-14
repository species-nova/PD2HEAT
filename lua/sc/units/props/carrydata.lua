local zero_vel_vec = Vector3(0, 0, 0)

local math_random = math.random
local math_up = math.UP

local ids_g_bag = Idstring("g_bag")
local ids_g_canvasbag = Idstring("g_canvasbag")
local ids_g_g = Idstring("g_g")
local ids_g_goat = Idstring("g_goat")
local ids_g_bodybag = Idstring("g_bodybag")
local carry_data_idstr = Idstring("carry_data")
local col_throw_idstr = Idstring("throw")
local parent_obj_name = Idstring("Neck")

local pairs_g = pairs
local tostring_g = tostring

local deep_clone_g = deep_clone
local alive_g = alive
local call_on_next_update_g = call_on_next_update

CarryData._carrying_units = {}

function CarryData:init(unit)
	self._unit = unit
	self._dye_initiated = false
	self._has_dye_pack = false
	self._dye_value_multiplier = 100
	self._linked_to = nil

	local carry_id = self._carry_id

	if carry_id then
		self._value = managers.money:get_bag_value(carry_id, self._multiplier)

		local carry_tweaks = tweak_data.carry
		local carry_types = carry_tweaks.types
		local tweak_info = carry_tweaks[carry_id].type

		self._can_explode = carry_types[tweak_info].can_explode and true
		self._can_poof = carry_types[tweak_info].can_poof and true
	else
		self._value = tweak_data:get_value("money_manager", "bag_values", "default")
	end

	local is_server = Network:is_server()
	self._is_server = is_server

	if not is_server then
		--clients literally don't need to update anything in this extension, no need to waste performance
		unit:set_extension_update_enabled(carry_data_idstr, false)

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
	local my_unit = self._unit
	local int_ext = my_unit:interaction()
	local air_start_t = int_ext._air_start_time

	if air_start_t and t > air_start_t + 1 then
		--after 1 second of being thrown, stop checking for bots to link to
		unit:set_extension_update_enabled(carry_data_idstr, false)

		return
	end

	local link_object = self._link_obj

	if not link_object or not link_object:visibility() then
		--in case somehow updating got reenabled
		unit:set_extension_update_enabled(carry_data_idstr, false)

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

function CarryData:can_explode()
	if self._disarmed then
		return false
	end

	return self._can_explode
end

function CarryData:can_poof()
	return self._can_poof
end

function CarryData:start_explosion(instant)
	if self._explode_t or not self:can_explode() then
		return
	end

	self:_unregister_steal_SO()
	self:_start_explosion()

	if not instant then
		managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "carry_data", CarryData.EVENT_IDS.will_explode)

		local explode_t = TimerManager:game():time() + 1 + math_random() * 3
		self._explode_t = explode_t
		self._delayed_explode_key = "_delayed_carry_explosion" .. tostring_g(self._unit:key())

		--use a delayed callback for delayed explosions rather than checking the timer frame by frame
		managers.enemy:add_delayed_clbk(self._delayed_explode_key, callback(self, self, "_delayed_explosion"), explode_t)
	else
		self:_explode()
	end
end

function CarryData:_delayed_explosion()
	self._delayed_explode_key = nil

	if not alive_g(self._unit) then
		return
	end

	self:_explode()
end

--synced poofs normally execute server-only code, which as you'd guess, it's bad
--just play the effects instead (the unit will be despawned right after by the host)
function CarryData:_sync_poof()
	local pos = self._unit:position()
	local normal = math_up
	local range = CarryData.POOF_SETTINGS.range
	local effect = CarryData.POOF_CUSTOM_PARAMS.effect

	managers.explosion:play_sound_and_effects(pos, normal, range, CarryData.POOF_CUSTOM_PARAMS)
end

local sync_net_event_original = CarryData.sync_net_event
function CarryData:sync_net_event(event_id)
	if event_id == CarryData.EVENT_IDS.poof then
		self:_sync_poof()

		return
	end

	sync_net_event_original(self, event_id)
end

local set_carry_id_original = CarryData.set_carry_id
function CarryData:set_carry_id(carry_id)
	if carry_id then
		--redefine everything related to the carry id just like in the init function
		self._value = managers.money:get_bag_value(carry_id, self._multiplier or 1)

		local carry_tweaks = tweak_data.carry
		local carry_types = carry_tweaks.types
		local tweak_info = carry_tweaks[carry_id].type

		self._can_explode = carry_types[tweak_info].can_explode and true
		self._can_poof = carry_types[tweak_info].can_poof and true
	end

	set_carry_id_original(self, carry_id)
end

function CarryData:set_zipline_unit(zipline_unit)
	self._zipline_unit = zipline_unit

	if zipline_unit then
		if zipline_unit:zipline():ai_ignores_bag() then
			local att_ext = self._unit:attention()

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
	elseif self._saved_attention_data then
		local att_ext = self._unit:attention()

		for attention_id, attention_data in pairs_g(self._saved_attention_data) do
			att_ext:add_attention(attention_data)
		end

		self._saved_attention_data = nil
	end
end

function CarryData:link_to(parent_unit, keep_collisions)
	local link_body = self._link_body

	if not link_body then
		return
	end

	--forcing to false because the way this works is intended to make units drop bags on out of bounds borders
	--but it's not consistent at all from testing + it can trigger with normal geometry sometimes
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

	if keep_collisions then
		--don't bother using this, really
		if is_server then
			self._kept_collisions = true

			my_unit:set_body_collision_callback(function (tag, unit, colliding_body, other_unit, other_body, position, normal, velocity)
				if tag ~= col_throw_idstr then
					return
				end

				if other_unit:visible() then
					unit:set_disable_collision_with_unit(other_unit)
				else
					unit:carry_data():unlink()
				end
			end)
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

function CarryData:unlink()
	local link_body = self._link_body

	if not link_body then
		return
	end

	local is_server = self._is_server
	local my_unit = self._unit
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
		self._kept_collisions = nil

		my_unit:interaction():register_collision_callbacks()
	end

	if not is_server then
		return
	end

	managers.network:session():send_to_peers_synched("loot_link", my_unit, my_unit)
end

function CarryData:destroy()
	if self._register_steal_SO_clbk_id then
		managers.enemy:remove_delayed_clbk(self._register_steal_SO_clbk_id)

		self._register_steal_SO_clbk_id = nil
	end

	if self._register_out_of_world_clbk_id then
		managers.enemy:remove_delayed_clbk(self._register_out_of_world_clbk_id)

		self._register_out_of_world_clbk_id = nil
	end

	if self._register_out_of_world_dynamic_clbk_id then
		managers.enemy:remove_delayed_clbk(self._register_out_of_world_dynamic_clbk_id)

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
