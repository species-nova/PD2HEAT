--Make reload speed multipliers apply to bow charge speed.
--Use cached value if still charging. Otherwise, invalidate it and cache a new one.
function BowWeaponBase:charge_max_t()
	if not self._charging or self._cancelled or not self._charge_max then
		self._charge_max = self:weapon_tweak_data().charge_speed / self:reload_speed_multiplier()
	end

	return self._charge_max
end

--Cache max charge time to keep the value consistent until charging is finished.
local orig_start_charging = BowWeaponBase._start_charging
function BowWeaponBase:_start_charging()
	self._charge_max = self:charge_max_t()
	orig_start_charging(self)
end

--Ignore Overkill's janky and bow-specific implementation of the .reload_speed_multiplier field in WeaponTweakData.
BowWeaponBase.reload_speed_multiplier = BowWeaponBase.super.reload_speed_multiplier

--The movement of crossbow strings is tied to the reload animation. This results in certain animation
--cancels, or non-immediate reloads (said mechanic is removed here) making the string erroneously
--appear as if it's already been drawn. This code resolves the issue by finding the 'barrel'
--component on affected crossbows and playing the reload up to the point where the string should end up.

local orig_update_stats_values = CrossbowWeaponBase._update_stats_values
function CrossbowWeaponBase:_update_stats_values(...)
	orig_update_stats_values(self, ...)

	--Cache a reference to the barrel part, if it can be used for crossbow string movement.
	self._animated_barrel_part = nil
	local unit_anim = self:_get_tweak_data_weapon_animation("reload")
	for part_id, part in pairs(self._parts) do
		local part_tweak = tweak_data.weapon.factory.parts[part_id]
		if part.unit and part.animations and part.animations[unit_anim] and part_tweak and part_tweak.type == "barrel" then
			self._animated_barrel_part = part
			break
		end
	end
end

local orig_on_enabled = CrossbowWeaponBase.on_enabled
function CrossbowWeaponBase:on_enabled(...)
	orig_on_enabled(self, ...)
	self:update_crossbow_string(10)
end

local orig_set_ammo_remaining_in_clip = CrossbowWeaponBase.set_ammo_remaining_in_clip
function CrossbowWeaponBase:set_ammo_remaining_in_clip(...)
	orig_set_ammo_remaining_in_clip(self, ...)
	self:update_crossbow_string(self._fire_rate_multiplier)
end

function CrossbowWeaponBase:update_crossbow_string(speed)
	local string_time = self:weapon_tweak_data().crossbow_string_time
	if not string_time or not self._animated_barrel_part then 
		return
	end
	
	local unit_anim = self:_get_tweak_data_weapon_animation("reload")
	local anim_name = self._animated_barrel_part.animations[unit_anim]
	local part_unit = self._animated_barrel_part.unit
	local ids_anim_name = Idstring(anim_name)
	local length = part_unit:anim_length(ids_anim_name)

	part_unit:anim_stop(ids_anim_name)
	if self:clip_empty() then
		part_unit:anim_play_to(ids_anim_name, string_time, speed)
	end
end

--TODO: Implement code to skip ahead past string movement in the reload animation.