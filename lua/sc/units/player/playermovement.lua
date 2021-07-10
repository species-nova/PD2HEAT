local init_original = PlayerMovement.init
function PlayerMovement:init(...)
	init_original(self, ...)
	
	local player_manager = managers.player
	self._has_underdog = player_manager:has_category_upgrade("shotgun", "close_combat_damage_boost")
		or player_manager:has_category_upgrade("shotgun", "close_combat_damage_reduction")
		or player_manager:has_category_upgrade("shotgun", "close_combat_reload_speed_multiplier")
		or player_manager:has_category_upgrade("shotgun", "close_combat_swap_speed_multiplier")
		or player_manager:has_category_upgrade("assault_rifle", "close_combat_reload_speed_multiplier")
		or player_manager:has_category_upgrade("snp", "close_combat_reload_speed_multiplier")
		or player_manager:has_category_upgrade("player", "damage_dampener_outnumbered")
		or player_manager:has_category_upgrade("player", "damage_dampener_close_contact")
	self._underdog_skill_data = tweak_data.upgrades.close_combat_data
	self._underdog_chk_t = 0
	self._nr_close_guys = 0
	if managers.player:has_category_upgrade("player", "armor_full_infinite_sprint") then
		self._infinite_sprint = true
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
function PlayerMovement:_stagger_in_aoe(stagger_dis)
	if stagger_dis <= 0 then
		return
	end

	local nearby_enemies = World:find_units_quick("sphere", self._m_pos, stagger_dis, managers.slot:get_mask("enemies"))

	--Stagger valid nearby enemies.
	for i = 1, #nearby_enemies do
		local enemy = nearby_enemies[i]
		local dmg_ext = enemy:character_damage()

		if dmg_ext and dmg_ext.damage_simple then
			local base_ext = enemy:base()
			local char_tweak = base_ext and base_ext.char_tweak
			local immune_to_stagger = char_tweak and base_ext:char_tweak().immune_to_knock_down

			if not immune_to_stagger and base_ext.has_tag then
				immune_to_stagger = base_ext:has_tag("tank") or base_ext:has_tag("captain")
			end

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

function PlayerMovement:activate_infinite_sprint()
	self._infinite_sprint = true
end

function PlayerMovement:deactivate_infinite_sprint()
	self._infinite_sprint = nil
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

	self:update_stamina(t, dt, self._infinite_sprint)
	self:update_teleport(t, dt)
end