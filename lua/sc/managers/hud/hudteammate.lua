function HUDTeammate:set_weapon_firemode(id, firemode)
	local is_secondary = id == 1
	local secondary_weapon_panel = self._player_panel:child("weapons_panel"):child("secondary_weapon_panel")
	local primary_weapon_panel = self._player_panel:child("weapons_panel"):child("primary_weapon_panel")
	local weapon_selection = is_secondary and secondary_weapon_panel:child("weapon_selection") or primary_weapon_panel:child("weapon_selection")

	if alive(weapon_selection) then
		local firemode_single = weapon_selection:child("firemode_single")
		local firemode_auto = weapon_selection:child("firemode_auto")

		if alive(firemode_single) and alive(firemode_auto) then
			if firemode == "single" then
				firemode_single:show()
				firemode_auto:hide()
			elseif firemode == "burst" then
				firemode_single:show()
				firemode_auto:show()
			else
				firemode_single:hide()
				firemode_auto:show()
			end
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

--TODO: Temporary shim to prevent missing textures.
--Need to update to have proper compatibility with vanilla.
function HUDTeammate:_create_primary_weapon_firemode()
	local primary_weapon_panel = self._player_panel:child("weapons_panel"):child("primary_weapon_panel")
	local weapon_selection_panel = primary_weapon_panel:child("weapon_selection")
	local old_single = weapon_selection_panel:child("firemode_single")
	local old_auto = weapon_selection_panel:child("firemode_auto")

	if alive(old_single) then
		weapon_selection_panel:remove(old_single)
	end

	if alive(old_auto) then
		weapon_selection_panel:remove(old_auto)
	end

	if self._main_player then
		local equipped_primary = managers.blackmarket:equipped_primary()
		local weapon_tweak_data = tweak_data.weapon[equipped_primary.weapon_id]
		local fire_mode = weapon_tweak_data.FIRE_MODE
		local can_toggle_firemode = weapon_tweak_data.CAN_TOGGLE_FIREMODE
		local toggable_fire_modes = false --weapon_tweak_data.fire_mode_data and weapon_tweak_data.fire_mode_data.toggable

		if toggable_fire_modes then
			can_toggle_firemode = #toggable_fire_modes > 1
			local firemode_single_key = toggable_fire_modes[1] or "single"
			local firemode_auto_key = toggable_fire_modes[2] or "auto"
			self._firemode_primary_mapping = {
				[firemode_single_key] = "single",
				[firemode_auto_key] = "auto"
			}
		end

		local locked_to_auto = managers.weapon_factory:has_perk("fire_mode_auto", equipped_primary.factory_id, equipped_primary.blueprint)
		local locked_to_single = managers.weapon_factory:has_perk("fire_mode_single", equipped_primary.factory_id, equipped_primary.blueprint)
		locked_to_auto = managers.weapon_factory:has_perk("fire_mode_burst", equipped_primary.factory_id, equipped_primary.blueprint)
		local single_id = "firemode_single" .. ((not can_toggle_firemode or locked_to_single) and "_locked" or "")

		if toggable_fire_modes and can_toggle_firemode then
			local firemode_single_key = toggable_fire_modes[1] or "single"
			local firemode_auto_key = toggable_fire_modes[2] or "auto"
			single_id = string.format("firemode_%s_%s", firemode_single_key, firemode_auto_key)
		end

		local texture, texture_rect = tweak_data.hud_icons:get_icon_data(single_id)
		local firemode_single = weapon_selection_panel:bitmap({
			name = "firemode_single",
			blend_mode = "mul",
			layer = 1,
			x = 2,
			texture = texture,
			texture_rect = texture_rect
		})

		firemode_single:set_bottom(weapon_selection_panel:h() - 2)
		firemode_single:hide()

		local auto_id = "firemode_auto" .. ((not can_toggle_firemode or locked_to_auto) and "_locked" or "")

		if toggable_fire_modes and can_toggle_firemode then
			local firemode_single_key = toggable_fire_modes[1] or "single"
			local firemode_auto_key = toggable_fire_modes[2] or "auto"
			auto_id = string.format("firemode_%s_%s", firemode_auto_key, firemode_single_key)
		end

		local texture, texture_rect = tweak_data.hud_icons:get_icon_data(auto_id)
		local firemode_auto = weapon_selection_panel:bitmap({
			name = "firemode_auto",
			blend_mode = "mul",
			layer = 1,
			x = 2,
			texture = texture,
			texture_rect = texture_rect
		})

		firemode_auto:set_bottom(weapon_selection_panel:h() - 2)
		firemode_auto:hide()

		if self._firemode_primary_mapping then
			fire_mode = self._firemode_primary_mapping[fire_mode] or fire_mode
		end

		if locked_to_single or not locked_to_auto and fire_mode == "single" then
			firemode_single:show()
		else
			firemode_auto:show()
		end
	end
end

function HUDTeammate:_create_secondary_weapon_firemode()
	local secondary_weapon_panel = self._player_panel:child("weapons_panel"):child("secondary_weapon_panel")
	local weapon_selection_panel = secondary_weapon_panel:child("weapon_selection")
	local old_single = weapon_selection_panel:child("firemode_single")
	local old_auto = weapon_selection_panel:child("firemode_auto")

	if alive(old_single) then
		weapon_selection_panel:remove(old_single)
	end

	if alive(old_auto) then
		weapon_selection_panel:remove(old_auto)
	end

	if self._main_player then
		local equipped_secondary = managers.blackmarket:equipped_secondary()
		local weapon_tweak_data = tweak_data.weapon[equipped_secondary.weapon_id]
		local fire_mode = weapon_tweak_data.FIRE_MODE
		local can_toggle_firemode = weapon_tweak_data.CAN_TOGGLE_FIREMODE
		local toggable_fire_modes = false --weapon_tweak_data.fire_mode_data and weapon_tweak_data.fire_mode_data.toggable

		if toggable_fire_modes then
			can_toggle_firemode = #toggable_fire_modes > 1
			local firemode_single_key = toggable_fire_modes[1] or "single"
			local firemode_auto_key = toggable_fire_modes[2] or "auto"
			self._firemode_secondary_mapping = {
				[firemode_single_key] = "single",
				[firemode_auto_key] = "auto"
			}
		end

		local locked_to_auto = managers.weapon_factory:has_perk("fire_mode_auto", equipped_secondary.factory_id, equipped_secondary.blueprint)
		local locked_to_single = managers.weapon_factory:has_perk("fire_mode_single", equipped_secondary.factory_id, equipped_secondary.blueprint)
		locked_to_auto = managers.weapon_factory:has_perk("fire_mode_burst", equipped_secondary.factory_id, equipped_secondary.blueprint)
		local single_id = "firemode_single" .. ((not can_toggle_firemode or locked_to_single) and "_locked" or "")

		if toggable_fire_modes and can_toggle_firemode then
			local firemode_single_key = toggable_fire_modes[1] or "single"
			local firemode_auto_key = toggable_fire_modes[2] or "auto"
			single_id = string.format("firemode_%s_%s", firemode_single_key, firemode_auto_key)
		end

		local texture, texture_rect = tweak_data.hud_icons:get_icon_data(single_id)
		local firemode_single = weapon_selection_panel:bitmap({
			name = "firemode_single",
			blend_mode = "mul",
			layer = 1,
			x = 2,
			texture = texture,
			texture_rect = texture_rect
		})

		firemode_single:set_bottom(weapon_selection_panel:h() - 2)
		firemode_single:hide()

		local auto_id = "firemode_auto" .. ((not can_toggle_firemode or locked_to_auto) and "_locked" or "")

		if toggable_fire_modes and can_toggle_firemode then
			local firemode_single_key = toggable_fire_modes[1] or "single"
			local firemode_auto_key = toggable_fire_modes[2] or "auto"
			auto_id = string.format("firemode_%s_%s", firemode_auto_key, firemode_single_key)
		end

		local texture, texture_rect = tweak_data.hud_icons:get_icon_data(auto_id)
		local firemode_auto = weapon_selection_panel:bitmap({
			name = "firemode_auto",
			blend_mode = "mul",
			layer = 1,
			x = 2,
			texture = texture,
			texture_rect = texture_rect
		})

		firemode_auto:set_bottom(weapon_selection_panel:h() - 2)
		firemode_auto:hide()

		if self._firemode_secondary_mapping then
			fire_mode = self._firemode_secondary_mapping[fire_mode] or fire_mode
		end

		if locked_to_single or not locked_to_auto and fire_mode == "single" then
			firemode_single:show()
		else
			firemode_auto:show()
		end
	end
end
