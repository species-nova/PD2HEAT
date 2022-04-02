--The movement of crossbow strings is tied to the reload animation. This results in certain animation
--cancels, or non-immediate reloads (said mechanic is removed here) making the string erroneously
--appear as if it's already been drawn. This code resolves the issue by finding the 'barrel'
--component on affected crossbows and playing the reload up to the point where the string should end up.

function CrossbowWeaponBase:_update_stats_values(...)
	self.super._update_stats_values(self, ...)

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

function CrossbowWeaponBase:on_enabled(...)
	self.super.on_enabled(self, ...)
	self:update_crossbow_string(10)
end

function CrossbowWeaponBase:set_ammo_remaining_in_clip(...)
	self.super.set_ammo_remaining_in_clip(self, ...)
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