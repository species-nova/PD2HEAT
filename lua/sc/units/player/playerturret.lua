local orig_update = PlayerTurret.update
function PlayerTurret:update(t, dt)
	if alive(self._turret_unit) then
		orig_update(self, t, dt)
		local weapon = self._turret_unit:base()
		weapon:update_spread(self, t, dt)
		self:_update_crosshair(t, dt, weapon)
		managers.hud:_update_crosshair_offset(t, dt)
	end
end

function PlayerTurret:_check_action_primary_attack(t, input)
	local weap_base = self._turret_unit:base()
	local weapon_tweak_data = weap_base:weapon_tweak_data()

	if weap_base:clip_empty() then
		if input.btn_primary_attack_press then
			weap_base:dryfire()
		end

		self:_check_stop_shooting()

		return false
	end

	if input.btn_primary_attack_state and not self._shooting then
		if not weap_base:start_shooting_allowed() then
			self:_check_stop_shooting()

			return false
		end

		self:_check_start_shooting()
	end

	if input.btn_primary_attack_state then
		local dmg_mul = 1
		local primary_category = weapon_tweak_data.categories[1]

		if not weapon_tweak_data.ignore_damage_multipliers then
			local upgrade_name = weap_base:is_category("saw") and "melee_damage_health_ratio_multiplier" or "damage_health_ratio_multiplier"
			dmg_mul = managers.player:upgrade_value("player", upgrade_name, 1)
			
			dmg_mul = dmg_mul * managers.player:temporary_upgrade_value("temporary", "berserker_damage_multiplier", 1)
			
			if self._can_trigger_happy_all_guns or weap_base:is_category("pistol") then
				dmg_mul = dmg_mul * managers.player:get_property("trigger_happy", 1)
			end

			dmg_mul = dmg_mul * (1 + managers.player:close_combat_upgrade_value("player", "close_combat_damage_boost", 0))
		end

		local fired = weap_base:trigger_held(self:get_fire_weapon_position(), self:get_fire_weapon_direction(), dmg_mul)

		if fired then
			managers.rumble:play("weapon_fire")
			local weap_tweak_data = tweak_data.weapon[weap_base:get_name_id()]
			local shake_multiplier = weap_base:shake_multiplier(self._state_data.in_steelsight and "fire_steelsight_multiplier" or "fire_multiplier")

			if not weap_base:has_spin() and not self._state_data.in_steelsight or not weap_base:tweak_data_anim_play("fire_steelsight", weap_base:fire_rate_multiplier()) then
				weap_base:tweak_data_anim_play("fire", weap_base:fire_rate_multiplier())
			end

			if not fired.skip_recoil then
				local v, h, shake = weap_base:get_recoil_kick(self, 1)
				self:apply_recoil(v, h, shake)
			end

			managers.hud:set_ammo_amount(2, weap_base:ammo_info())
			self._turret_unit:network():send("shot_player_turret", not fired.hit_enemy)
			weap_base:tweak_data_anim_stop("unequip")
			weap_base:tweak_data_anim_stop("equip")

			if not weap_base:has_spin() and not self._state_data.in_steelsight or not weap_base:tweak_data_anim_play("fire_steelsight", weap_base:fire_rate_multiplier()) then
				weap_base:tweak_data_anim_play("fire", weap_base:fire_rate_multiplier())
			end
		end

		return true
	else
		self:_check_stop_shooting()
	end
end