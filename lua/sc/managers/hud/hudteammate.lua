--Default function for vanilla HUD. If using a custom HUD that alters fire mode HUD components, make sure to implement this function in it
HUDTeammate.set_weapon_firemode_burst = HUDTeammate.set_weapon_firemode_burst or function(self, id, firemode, burst_fire)
	local is_secondary = id == 1
	local secondary_weapon_panel = self._player_panel:child("weapons_panel"):child("secondary_weapon_panel")
	local primary_weapon_panel = self._player_panel:child("weapons_panel"):child("primary_weapon_panel")
	local weapon_selection = is_secondary and secondary_weapon_panel:child("weapon_selection") or primary_weapon_panel:child("weapon_selection")
	if alive(weapon_selection) then
		local firemode_single = weapon_selection:child("firemode_single")
		local firemode_auto = weapon_selection:child("firemode_auto")
		if alive(firemode_single) and alive(firemode_auto) then
			firemode_single:show()
			firemode_auto:show()
		end
	end
end

--Changed to now display amount that damage was recently reduced by.
function HUDTeammate:set_absorb_active(absorb_amount)
	self._absorb_active_amount = math.max((self._absorb_active_amount or 0) + absorb_amount, 0) --Now adds in the desired amount of "absorb"
	--No longer synced to players to reduce visual clutter, since it's not essential information.
end

--Gradually drains away over time.
function HUDTeammate:_animate_update_absorb(o, radial_absorb_shield_name, radial_absorb_health_name, var_name, blink)
	repeat
		coroutine.yield()
	until alive(self._panel) and self[var_name] and self._armor_data and self._health_data

	local teammate_panel = self._panel:child("player")
	local radial_health_panel = self._radial_health_panel
	local radial_shield = radial_health_panel:child("radial_shield")
	local radial_health = radial_health_panel:child("radial_health")
	local radial_absorb_shield = radial_health_panel:child(radial_absorb_shield_name)
	local radial_absorb_health = radial_health_panel:child(radial_absorb_health_name)
	local radial_shield_rot = radial_shield:color().r
	local radial_health_rot = radial_health:color().r

	radial_absorb_shield:set_rotation((1 - radial_shield_rot) * 360)
	radial_absorb_health:set_rotation((1 - radial_health_rot) * 360)

	local current_shield, current_health, current_absorb = nil
	local min_reduction = 1
	local percent_reduction = 1
	local dt, update_absorb = nil

	while alive(teammate_panel) do
		dt = coroutine.yield()

		if self[var_name] and self._armor_data and self._health_data then
			current_absorb = self[var_name]
			current_shield = self._armor_data.current
			current_health = self._health_data.current

			if radial_shield:color().r ~= radial_shield_rot or radial_health:color().r ~= radial_health_rot then
				radial_shield_rot = radial_shield:color().r
				radial_health_rot = radial_health:color().r

				radial_absorb_shield:set_rotation((1 - radial_shield_rot) * 360)
				radial_absorb_health:set_rotation((1 - radial_health_rot) * 360)
			end

			if current_absorb > 0 then
				local shield_ratio = current_shield == 0 and 0 or math.min(current_absorb / current_shield, 1)
				local health_ratio = current_health == 0 and 0 or math.min((current_absorb - shield_ratio * current_shield) / current_health, 1)
				local shield = math.clamp(shield_ratio * radial_shield_rot, 0, 1)
				local health = math.clamp(health_ratio * radial_health_rot, 0, 1)

				radial_absorb_shield:set_color(Color(1, shield, 1, 1))
				radial_absorb_health:set_color(Color(1, health, 1, 1))
				radial_absorb_shield:set_visible(shield > 0)
				radial_absorb_health:set_visible(health > 0)
				
				--Update value for next frame.
				--Choose largest between percent reduction and min reduction.
				self[var_name] = math.max(math.min(current_absorb - (dt * percent_reduction * current_absorb), current_absorb - (min_reduction * dt)), 0)
			end
		end
	end
end