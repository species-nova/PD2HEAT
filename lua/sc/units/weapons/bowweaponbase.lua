--The movement of crossbow strings is tied to the reload animation. This results in certain animation
--cancels, or non-immediate reloads (said mechanic is removed here) making the string erroneously
--appear as if it's already been drawn. This code resolves the issue by finding the 'barrel'
--component on affected crossbows and playing the reload up to the point where the string should end up.

function CrossbowWeaponBase:on_enabled(...)
	self.super.on_enabled(self, ...)
	self:fake_crossbow_string_movement(instant)
end

function CrossbowWeaponBase:fire(...)
	local result = self.super.fire(self, ...)
	self:fake_crossbow_string_movement()
	return result
end

function CrossbowWeaponBase:fake_crossbow_string_movement(instant)
	local string_time = self:weapon_tweak_data().crossbow_string_time
	
	if string_time and self:clip_empty() then
		local unit_anim = self:_get_tweak_data_weapon_animation("reload")
		for part_id, data in pairs(self._parts) do
			local part_tweak = tweak_data.weapon.factory.parts[part_id]
			if data.unit and data.animations and data.animations[unit_anim] and part_tweak and part_tweak.type == "barrel" then
				local anim_name = data.animations[unit_anim]
				local ids_anim_name = Idstring(anim_name)
				local length = data.unit:anim_length(ids_anim_name)

				data.unit:anim_stop(ids_anim_name)
				data.unit:anim_play_to(ids_anim_name, string_time, instant and 10 or self._fire_rate_multiplier)
				return
			end
		end
	end
end