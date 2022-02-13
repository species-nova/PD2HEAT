local init_original = PlayerMovement.init
function PlayerMovement:init(...)
	init_original(self, ...)
	
	local player_manager = managers.player
	self._has_underdog = player_manager:has_category_upgrade("shotgun", "close_combat_damage_boost")
		or player_manager:has_category_upgrade("shotgun", "close_combat_damage_reduction")
		or player_manager:has_category_upgrade("shotgun", "close_combat_reload_speed_multiplier")
		or player_manager:has_category_upgrade("shotgun", "close_combat_swap_speed_multiplier")
		or player_manager:has_category_upgrade("player", "far_combat_movement_speed")
		or player_manager:has_category_upgrade("assault_rifle", "far_combat_reload_speed_multiplier")
		or player_manager:has_category_upgrade("snp", "far_combat_reload_speed_multiplier")
		or player_manager:has_category_upgrade("player", "damage_dampener_outnumbered")
		or player_manager:has_category_upgrade("player", "damage_dampener_close_contact")
	self._underdog_skill_data = tweak_data.upgrades.close_combat_data
	self._underdog_chk_t = 0
	self._nr_close_guys = 0
	self._sprint_cost_multiplier = managers.player:upgrade_value("player", "armor_full_cheap_sprint", 1)
	self._has_stamina_dash_skill = managers.player:has_category_upgrade("temporary", "sprint_speed_boost")
	self._can_stamina_dash = true

	self._crosshair_states = {
		standard = true,
		carry = true,
		bipod = true
	}
end

--Determines states to show/hide crosshair panel in.

local change_state = PlayerMovement.change_state
function PlayerMovement:change_state(name)
	change_state(self, name)

	if not self._current_state_name then return end

	if self._crosshair_states[self._current_state_name] then
		managers.hud:show_crosshair_panel(true)
	else
		managers.hud:show_crosshair_panel(false)
	end
end


function PlayerMovement:on_SPOOCed(enemy_unit, flying_strike)
	if managers.player:has_category_upgrade("player", "counter_strike_spooc") and self._current_state.in_melee and self._current_state:in_melee() and not tweak_data.blackmarket.melee_weapons[managers.blackmarket:equipped_melee_weapon()].chainsaw then
		self._current_state:discharge_melee()

		return "countered"
	end

	if self._unit:character_damage()._god_mode or self._unit:character_damage():get_mission_blocker("invulnerable") then
		return
	end

	if self._current_state_name == "standard" or self._current_state_name == "carry" or self._current_state_name == "bleed_out" or self._current_state_name == "tased" or self._current_state_name == "bipod" then
        local state = "incapacitated"
        local damage = nil
        if flying_strike then
            damage = tweak_data.character.spooc.jump_kick_damage
        else
        	damage = tweak_data.character.spooc.kick_damage
        end
		
		state = managers.modifiers:modify_value("PlayerMovement:OnSpooked", state)
		
		managers.player:set_player_state(state)
		self._unit:character_damage():cloak_or_shock_incap(damage)
		managers.achievment:award(tweak_data.achievement.finally.award)

		return true
	end
end	

--Underdog now checks for *any* enemies in proximity.
function PlayerMovement:_upd_underdog_skill(t)
	if not self._has_underdog or t < self._underdog_chk_t then
		return
	end

	self._nr_close_guys = #World:find_units_quick("sphere", self._m_pos, self._underdog_skill_data.distance, managers.slot:get_mask("enemies"))

	managers.hud:set_stacks("close_combat", math.min(self._nr_close_guys, 5))

	self._underdog_chk_t = t + self._underdog_skill_data.polling_rate
end

function PlayerMovement:nr_close_guys()
	return self._nr_close_guys
end

function PlayerMovement:clbk_attention_notice_sneak(observer_unit, status, local_client_detection)
	if alive(observer_unit) then
		self:on_suspicion(observer_unit, status, local_client_detection)
	end
end

function PlayerMovement:on_suspicion(observer_unit, status, local_client_detection)
	if Network:is_server() or local_client_detection then
		self._suspicion_debug = self._suspicion_debug or {}
		self._suspicion_debug[observer_unit:key()] = {
			unit = observer_unit,
			name = observer_unit:name(),
			status = status
		}
		local visible_status = nil

		if managers.groupai:state():whisper_mode() and not managers.groupai:state():stealth_hud_disabled() then
			visible_status = status
		else
			visible_status = false
		end

		self._suspicion = self._suspicion or {}

		if visible_status == false or visible_status == true then
			self._suspicion[observer_unit:key()] = nil

			if not next(self._suspicion) then
				self._suspicion = nil
			end

			if visible_status and observer_unit:movement() and not observer_unit:movement():cool() and TimerManager:game():time() - observer_unit:movement():not_cool_t() > 1 then
				self._suspicion_ratio = false

				self:_feed_suspicion_to_hud()

				return
			end
		elseif type(visible_status) == "number" and (not observer_unit:movement() or observer_unit:movement():cool()) then
			self._suspicion[observer_unit:key()] = visible_status
		else
			return
		end

		self:_calc_suspicion_ratio_and_sync(observer_unit, visible_status, local_client_detection)
	else
		self._suspicion_ratio = status
	end

	self:_feed_suspicion_to_hud()
end

function PlayerMovement:_calc_suspicion_ratio_and_sync(observer_unit, status, local_client_detection)
	local suspicion_sync = nil

	if self._suspicion and status ~= true then
		local max_suspicion = nil

		for u_key, val in pairs(self._suspicion) do
			if not max_suspicion or max_suspicion < val then
				max_suspicion = val
			end
		end

		if max_suspicion then
			self._suspicion_ratio = max_suspicion
			suspicion_sync = math.ceil(self._suspicion_ratio * 254)
		else
			self._suspicion_ratio = false
			suspicion_sync = false
		end
	elseif type(status) == "boolean" then
		self._suspicion_ratio = status
		suspicion_sync = status and 255 or 0
	else
		self._suspicion_ratio = false
		suspicion_sync = 0
	end

	if not local_client_detection and suspicion_sync ~= self._synced_suspicion then
		self._synced_suspicion = suspicion_sync
		local peer = managers.network:session():peer_by_unit(self._unit)

		if peer then
			managers.network:session():send_to_peers_synched("suspicion", peer:id(), suspicion_sync)
		end
	end
end

--Staggers all enemies in an AOE around the player.
--Used by the Shell Shocked skill.
function PlayerMovement:stagger_in_aoe(stagger_dis)
	if stagger_dis <= 0 then
		return
	end

	local nearby_enemies = World:find_units_quick("sphere", self._m_pos, stagger_dis, managers.slot:get_mask("enemies"))

	--Stagger valid (non-special) nearby enemies.
	for i = 1, #nearby_enemies do
		local enemy = nearby_enemies[i]
		local dmg_ext = enemy:character_damage()

		if dmg_ext and dmg_ext.damage_simple then
			local base_ext = enemy:base()
			local char_tweak = base_ext and base_ext.char_tweak and base_ext:char_tweak()
			local immune_to_stagger = char_tweak and (char_tweak.immune_to_knock_down or char_tweak.is_special)

			if not immune_to_stagger then
				local m_com = enemy:movement():m_com()
				local attack_dir = m_com - self._m_head_pos
				mvector3.normalize(attack_dir)

				local stagger_data = {
					damage = 0,
					variant = "counter_spooc",
					stagger = true,
					attacker_unit = self._unit,
					attack_dir = attack_dir,
					pos = mvector3.copy(m_com)
				}

				dmg_ext:damage_simple(stagger_data)
			end
		end
	end
end

function PlayerMovement:activate_cheap_sprint()
	self._sprint_cost_multiplier = managers.player:upgrade_value("player", "armor_full_cheap_sprint", 1)
end

function PlayerMovement:deactivate_cheap_sprint()
	self._sprint_cost_multiplier = 1
end

function PlayerMovement:attempt_sprint_dash()
	if self._can_stamina_dash then
		managers.player:activate_temporary_upgrade("temporary", "sprint_speed_boost")
		self._can_stamina_dash = false
	end
end

function PlayerMovement:add_stamina(value)
	self._can_stamina_dash = self._has_stamina_dash_skill
	self:_change_stamina(math.abs(value) * managers.player:upgrade_value("player", "stamina_regen_multiplier", 1))
end

function PlayerMovement:update_stamina(t, dt, ignore_running, cost_multiplier)
	local dt = self._last_stamina_regen_t and t - self._last_stamina_regen_t or dt
	self._last_stamina_regen_t = t
	
	if not ignore_running and self._is_running then
		self:subtract_stamina(dt * tweak_data.player.movement_state.stamina.STAMINA_DRAIN_RATE * cost_multiplier)
	elseif self._regenerate_timer then
		self._regenerate_timer = self._regenerate_timer - dt

		if self._regenerate_timer < 0 then
			self:add_stamina(dt * tweak_data.player.movement_state.stamina.STAMINA_REGEN_RATE)

			if self:_max_stamina() <= self._stamina then
				self._regenerate_timer = nil
			end
		end
	elseif self._stamina < self:_max_stamina() then
		self:_restart_stamina_regen_timer()
	end

	if _G.IS_VR then
		managers.hud:set_stamina({
			current = self._stamina,
			total = self:_max_stamina()
		})
	end
end


function PlayerMovement:update(unit, t, dt)
	if _G.IS_VR then
		self:_update_vr(unit, t, dt)
	end

	self:_calculate_m_pose()

	if self:_check_out_of_world(t) then
		return
	end

	self:_upd_underdog_skill(t)

	if self._current_state then
		self._current_state:update(t, dt)
	end

	self:update_stamina(t, dt, nil, self._sprint_cost_multiplier)
	self:update_teleport(t, dt)
end