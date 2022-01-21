--Apply mag size increase calcs "per-gun" then double the result.
function AkimboWeaponBase:calculate_ammo_max_per_clip()
	local ammo = (tweak_data.weapon[self._name_id].CLIP_AMMO_MAX + (self._extra_ammo or 0)) / 2
	if not self:upgrade_blocked("weapon", "clip_ammo_increase") then
		ammo = ammo * managers.player:upgrade_value("weapon", "clip_ammo_increase", 1)
	end
	ammo = math.round(ammo) * 2
	return ammo
end

--Refactor for general simplicity. No longer uses callbacks, firing both guns reuses generic burst fire code.
local fire_original = AkimboWeaponBase.fire
function AkimboWeaponBase:fire(...)
	if self:is_npc() then
		return fire_original(self, ...)
	end

	local result = nil
	if self._fire_second_gun_next then
		result = self:_fire_second_gun(...)
	else
		result = AkimboWeaponBase.super.fire(self, ...)
	end

	self._fire_second_gun_next = not self._fire_second_gun_next

	return result
end

--Alternate version of _fire_second that does not require an unpack, and transfers important state data over.
function AkimboWeaponBase:_fire_second_gun(...)
	local second_gun_base = alive(self._second_gun) and self._second_gun:base()
	if second_gun_base and self._setup and alive(self._setup.user_unit) then
		second_gun_base._bloom_stacks = self._bloom_stacks
		second_gun_base._shots_without_releasing_trigger = self._shots_without_releasing_trigger

		local fired = second_gun_base.super.fire(second_gun_base, ...)

		if fired then
			if self._fire_second_sound then
				self._fire_second_sound = false
				self._second_gun:base():_fire_sound()
			end

			managers.hud:set_ammo_amount(self:selection_index(), self:ammo_info())
			
			second_gun_base:tweak_data_anim_play("fire")
			self._bloom_stacks = math.max(second_gun_base._bloom_stacks, self._bloom_stacks)
			self._shots_without_releasing_trigger = second_gun_base._shots_without_releasing_trigger
			self:_update_burst_fire()
		end

		return fired
	end
end

--Update spread on second gun too.
function AkimboWeaponBase:update_spread(current_state, t, dt)
	AkimboWeaponBase.super.update_spread(self, current_state, t, dt)
	local second_gun_base = self._second_gun:base()
	second_gun_base._current_spread = self._current_spread
	second_gun_base._current_spread_area = self._current_spread_area
end

--Reloads "one" of the guns.
function AkimboWeaponBase:on_half_reload(...)
	self._bloodthist_value_during_reload = 0
	self._current_reload_speed_multiplier = nil

	--Check if the last shot staggering buff should be reapplied. 
	self:check_reset_last_bullet_stagger()

	if not self._setup.expend_ammo then
		--Nothing
		return
	end

	local ammo_base = self._reload_ammo_base or self:ammo_base()
	local ammo_in_clip = ammo_base:get_ammo_remaining_in_clip()
	local max_clip_size = ammo_base:get_ammo_max_per_clip()

	local bullets_to_chamber = 0
	self._queued_tactical_reload = 0
	if ammo_base:weapon_tweak_data().tactical_reload then
		if ammo_in_clip > 0 then
			bullets_to_chamber = 1
			if ammo_in_clip > 1 then
				self._queued_tactical_reload = 2
			end
		end
	end

	local bullets_to_load = math.ceil((max_clip_size - ammo_in_clip) / 2)
	bullets_to_load = bullets_to_load + bullets_to_chamber
	local ammo_total = ammo_base:get_ammo_total()
	if bullets_to_load > ammo_total then
		bullets_to_load = ammo_total
		self._queue_tactical_reload = false
		if bullets_to_load - 1 == ammo_total then
			bullets_to_chamber = 0
		end
	end 

	ammo_base:set_ammo_remaining_in_clip(ammo_in_clip + bullets_to_load)
	managers.job:set_memory("kill_count_no_reload_" .. tostring(self._name_id), nil, true)
	self._reload_ammo_base = nil
end

--Override NewRaycastWeaponBase reload to handle individual bullet chambering for each gun.
function AkimboWeaponBase:on_reload(...)
	self._bloodthist_value_during_reload = 0
	self._current_reload_speed_multiplier = nil

	--Check if the last shot staggering buff should be reapplied. 
	self:check_reset_last_bullet_stagger()

	if not self._setup.expend_ammo then
		NewRaycastWeaponBase.super.on_reload(self, ...)
		return
	end

	local ammo_base = self._reload_ammo_base or self:ammo_base()
	local ammo_in_clip = ammo_base:get_ammo_remaining_in_clip()
	
	local bullets_to_chamber = self._queued_tactical_reload

	local max_clip_size = ammo_base:get_ammo_max_per_clip()
	local bullets_to_load = math.min(max_clip_size + 2, max_clip_size + bullets_to_chamber)
	local ammo_total = ammo_base:get_ammo_total()
	if bullets_to_load > ammo_total then
		bullets_to_load = ammo_total
		bullets_to_chamber = 0
	end 

	ammo_base:set_ammo_remaining_in_clip(bullets_to_load)
	managers.job:set_memory("kill_count_no_reload_" .. tostring(self._name_id), nil, true)
	self._reload_ammo_base = nil
end

function AkimboWeaponBase:clip_full()
	if self:ammo_base():weapon_tweak_data().tactical_reload then
		return self:ammo_base():get_ammo_remaining_in_clip() == self:ammo_base():get_ammo_max_per_clip() + 2
	else
		return self:ammo_base():get_ammo_remaining_in_clip() == self:ammo_base():get_ammo_max_per_clip()
	end
end

--Akimbo weapons fire twice as fast since they alternate guns. Accomplishes this without messing up animation speeds.
--Though akimbo animations are already mega crufty.
function AkimboWeaponBase:update_next_shooting_time()
	local next_fire = self._base_fire_rate / self:fire_rate_multiplier()
	next_fire = next_fire / 2
	self._next_fire_allowed = self._next_fire_allowed + next_fire
end