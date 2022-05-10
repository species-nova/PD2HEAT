local mvec3_set = mvector3.set
local mvec3_set_stat = mvector3.set_static

local math_random = math.random

--Local functions requested elsewhere. These are vanilla code.
local function make_double_hud_string(a, b)
	return string.format("%01d|%01d", a, b)
end

local function add_hud_item(amount, icon)
	if #amount > 1 then
		managers.hud:add_item_from_string({
			amount_str = make_double_hud_string(amount[1], amount[2]),
			amount = amount,
			icon = icon
		})
	else
		managers.hud:add_item({
			amount = amount[1],
			icon = icon
		})
	end
end

local function get_as_digested(amount)
	local list = {}

	for i = 1, #amount do
		table.insert(list, Application:digest_value(amount[i], false))
	end

	return list
end

Hooks:PostHook(PlayerManager, "init", "ResInit", function(self)
	--Info for slow debuff, usually caused by Titan Tasers.
	self._slow_data = {
		duration = 0, --Amount of time the slow should decay over.
		power = 0, --% slow when first started.
		start_time = 0 --Time when slow was started.
	}
	self._melee_knockdown_mul = 1
end)

--Make armor bot boost increase armor by % instead of adding.
--Removed unused armor multipliers.
function PlayerManager:body_armor_skill_multiplier(override_armor)
	local multiplier = 1
	multiplier = multiplier + self:upgrade_value("player", "tier_armor_multiplier", 1) - 1 --Armorer, Crew Chief
	multiplier = multiplier + self:upgrade_value("player", tostring(override_armor or managers.blackmarket:equipped_armor(true, true)) .. "_armor_multiplier", 1) - 1 --Crook
	multiplier = multiplier + self:upgrade_value("team", "crew_add_armor", 1) - 1 --Added bot armor boost.
	multiplier = multiplier * self:upgrade_value("player", "armor_reduction_multiplier", 1) --Used by Grinder.

	return multiplier
end

--Removed unused armor addends.
function PlayerManager:body_armor_skill_addend(override_armor)
	local addend = 0
	addend = addend + self:upgrade_value("player", tostring(override_armor or managers.blackmarket:equipped_armor(true, true)) .. "_armor_addend", 0) --Deep Pockets

	--Anarchist
	if self:has_category_upgrade("player", "armor_increase") then
		local health_multiplier = self:health_skill_multiplier()
		local max_health = (PlayerDamage._HEALTH_INIT + self:health_skill_addend()) * health_multiplier
		addend = addend + max_health * self:upgrade_value("player", "armor_increase", 1)
	end

	return addend
end


function PlayerManager:movement_speed_multiplier(speed_state, bonus_multiplier, upgrade_level, health_ratio)
	local multiplier = 1

	if speed_state then
		multiplier = multiplier + self:upgrade_value("player", speed_state .. "_speed_multiplier", 1) - 1 --Burglar
	end

	multiplier = multiplier + self:get_hostage_bonus_multiplier("speed") - 1 --Partners in Crime

	--Kingpin movespeed bonus.
	if self:has_activate_temporary_upgrade("temporary", "chico_injector") then
		multiplier = multiplier + self:upgrade_value("player", "chico_injector_speed", 1) - 1
	end

	--Moving Target movespeed bonus
	if self:has_category_upgrade("player", "detection_risk_add_movement_speed") then
		multiplier = multiplier + self:detection_risk_movement_speed_bonus()
	end

	--Grinder and hitman speed bonuses.
	local player_unit = self:player_unit()
	if alive(player_unit) then
		local hot_stacks = player_unit:character_damage():get_hot_stacks()
		multiplier = multiplier + self:upgrade_value("player", "hot_speed_bonus", 0) * hot_stacks

		--Hitman movespeed bonus
		if player_unit:character_damage():has_temp_health() then
			multiplier = multiplier + self:upgrade_value("player", "temp_health_speed", 1) - 1
		end
	end

	--Running From Death
	multiplier = multiplier + self:temporary_upgrade_value("temporary", "increased_movement_speed", 1) - 1

	--Second Wind
	multiplier = multiplier + self:temporary_upgrade_value("temporary", "damage_speed_multiplier", 1) - 1

	--Fast Feet
	multiplier = multiplier + self:temporary_upgrade_value("temporary", "sprint_speed_boost", 1) - 1

	--Infiltrator
	multiplier = multiplier + self:close_combat_upgrade_value("player", "far_combat_movement_speed", 1) - 1

	--Swan Song movespeed penalty.
	if managers.player:has_activate_temporary_upgrade("temporary", "berserker_damage_multiplier") then	
		multiplier = multiplier * (tweak_data.upgrades.berserker_movement_speed_multiplier or 1)	
	end

	--Armor slowdown.
	local armor_penalty = self:mod_movement_penalty(self:body_armor_value("movement", upgrade_level, 1))
	multiplier = multiplier * armor_penalty
	if bonus_multiplier then
		multiplier = multiplier * bonus_multiplier
	end

	--Apply slowing debuff if active.
	multiplier = multiplier * self:_slow_debuff_mult()

	return multiplier
end

--Moved stuff that's not frame-sensitive to messages to reduce redundant checks.
--Unified all panic chance effects to reduce redundant searches.
function PlayerManager:on_killshot(killed_unit, variant, headshot, weapon_id)
	local player_unit = self:player_unit()

	if not player_unit then
		return
	end

	if CopDamage.is_civilian(killed_unit:base()._tweak_table) then
		return
	end

	local weapon_melee = weapon_id and tweak_data.blackmarket and tweak_data.blackmarket.melee_weapons and tweak_data.blackmarket.melee_weapons[weapon_id] and true
	local t = Application:time()
	local damage_ext = player_unit:character_damage()
	local equipped_unit = self:get_current_state()._equipped_unit

	if killed_unit:brain().surrendered and killed_unit:brain():surrendered() and (variant == "melee" or weapon_melee) then
		managers.custom_safehouse:award("daily_honorable")
	end

	managers.modifiers:run_func("OnPlayerManagerKillshot", player_unit, killed_unit:base()._tweak_table, variant)

	--Increase kill count.
	self._num_kills = self._num_kills + 1

	--Notify listeners. Covers majority of on-kill skills.
	self._message_system:notify(Message.OnEnemyKilled, nil, equipped_unit, variant, killed_unit)

	--These do not use messages since they must occur *as* the unit dies before they become detached from the network.
	--Scavenger Aced ammo drop.
	if self:has_category_upgrade("player", "double_drop") then
		self._target_kills = self._target_kills or self:upgrade_value("player", "double_drop", 0)

		if self._num_kills % self._target_kills == 0 then
			self:_on_spawn_extra_ammo_event(killed_unit)
		end
	else
		self._target_kills = nil
	end

	local killed_base_ext = killed_unit:base()
	local killed_char_tweak = killed_base_ext and killed_base_ext:char_tweak()
	local killed_special = killed_char_tweak and killed_char_tweak.priority_shout

	--Professional aced extra ammo when killing specials while using silenced weapons.
	if variant == "bullet" and self:has_category_upgrade("player", "special_double_drop") and equipped_unit:base():got_silencer() and killed_special then
		self:_on_spawn_extra_ammo_event(killed_unit)
	end

	--Spread on-kill panic.
	local panic_chance = 0

	--Add Specialized Equipment Ace to panic chance.
	if self._single_shot_panic_when_kill and equipped_unit:base():holds_single_round() then
		panic_chance = panic_chance + self:upgrade_value("weapon", "single_shot_panic_when_kill")
	end

	--Apply Sociopath panic chance and add shell rack stack.
	local dist_sq = mvector3.distance_sq(player_unit:movement():m_pos(), killed_unit:movement():m_pos())
	local close_combat_sq = tweak_data.upgrades.close_combat_distance * tweak_data.upgrades.close_combat_distance --18m for Sociopath.
	local real_close_combat_sq = tweak_data.upgrades.close_combat_data.distance * tweak_data.upgrades.close_combat_data.distance --8m for shotgun skills.
	if dist_sq <= close_combat_sq then
		panic_chance = panic_chance + self:use_cooldown_upgrade("cooldown", "killshot_close_panic_chance", 0)
		+ self:upgrade_value("player", "killshot_extra_spooky_panic_chance", 0) --Add Haunt skill to panic chance.
		+ self:upgrade_value("player", "killshot_spooky_panic_chance", 0) * damage_ext:get_missing_revives()

		if self._shell_rack and dist_sq <= real_close_combat_sq then
			self._shell_rack_stacks = math.min(self._shell_rack_stacks + 1, self._shell_rack.max_stacks)
			managers.hud:set_stacks("shell_stacking_reload", self._shell_rack_stacks)
		end
	end

	--Apply panic chance modifier.
	panic_chance = managers.modifiers:modify_value("PlayerManager:GetKillshotPanicChance", panic_chance)

	--Spread the panic.
	self:spread_panic(math.min(panic_chance, 1))

	--Bot boost to regain throwables.
	local gain_throwable_per_kill = managers.player:upgrade_value("team", "crew_throwable_regen", 0)
	if gain_throwable_per_kill ~= 0 then
		self._throw_regen_kills = (self._throw_regen_kills or 0) + 1

		if gain_throwable_per_kill < self._throw_regen_kills then
			managers.player:add_grenade_amount(1, true)

			self._throw_regen_kills = 0
		end
	end

	--TODO: Check if I can move this to a message.
	if variant == "melee" then
		--Boxing Glove Stamina Restore
		local melee_weapon = tweak_data.blackmarket.melee_weapons[managers.blackmarket:equipped_melee_weapon()]
		if melee_weapon.special_weapon and melee_weapon.special_weapon == "stamina_restore" then
			player_unit:movement():add_stamina(player_unit:movement():_max_stamina())
		end
	end
end

function PlayerManager:update(t, dt)
	self._message_system:update()
	self:_update_timers(t)

	if self._need_to_send_player_status then
		self._need_to_send_player_status = nil

		self:need_send_player_status()
	end

	self._sent_player_status_this_frame = nil
	local local_player = self:local_player()

	if self:has_category_upgrade("player", "close_to_hostage_boost") and (not self._hostage_close_to_local_t or self._hostage_close_to_local_t <= t) then
		self._is_local_close_to_hostage = alive(local_player) and managers.groupai and managers.groupai:state():is_a_hostage_within(local_player:movement():m_pos(), tweak_data.upgrades.hostage_near_player_radius)
		self._hostage_close_to_local_t = t + tweak_data.upgrades.hostage_near_player_check_t
	end

	self:_update_damage_dealt(t, dt)

	if #self._global.synced_cocaine_stacks >= 4 then
		local amount = 0

		for i, stack in pairs(self._global.synced_cocaine_stacks) do
			if stack.in_use then
				amount = amount + stack.amount
			end

			if PlayerManager.TARGET_COCAINE_AMOUNT <= amount then
				managers.achievment:award("mad_5")
			end
		end
	end

	self._coroutine_mgr:update(t, dt)
	self._action_mgr:update(t, dt)

	if self._unseen_strike and not self._coroutine_mgr:is_running(PlayerAction.UnseenStrike) then
		local data = self:upgrade_value("player", "unseen_increased_crit_chance", 0)

		if data ~= 0 then
			self._coroutine_mgr:add_coroutine(PlayerAction.UnseenStrike, PlayerAction.UnseenStrike, self, data.min_time)
		end
	end

	if self._silent_precision and not self._coroutine_mgr:is_running(PlayerAction.SilentPrecision) then
		local data = self:upgrade_value("player", "silent_increased_accuracy", 0)

		if data ~= 0 then
			self._coroutine_mgr:add_coroutine(PlayerAction.SilentPrecision, PlayerAction.SilentPrecision, self, data.min_time)
		end
	end

	self:update_smoke_screens(t, dt)
end

--Now used to refresh active grinder stacks when damage is dealt.
--Has no effect outside of grinder.
function PlayerManager:_check_damage_to_hot(t, unit, damage_info)
	if not self._hot_data.refesh_stacks_on_damage or not damage_info.damage or damage_info.damage <= 0.1 then
		return
	end

	local player_unit = self:player_unit()
	if not alive(player_unit) then
		return
	end

	--Shouldn't happen, but just in case.
	if not alive(unit) or not unit:base() then
		return
	end

	--Non-hostile units do not refresh stacks.
	if CopDamage.is_civilian(unit:base()._tweak_table) or not unit:brain():is_hostile() then
		return
	end

	player_unit:character_damage():refresh_hot_duration()
end	

--Messiah functions updated to work indefinitely but with a cooldown.
function PlayerManager:refill_messiah_charges()
	self._messiah_cooldown = 0
end

--Called when people jump to get up.
function PlayerManager:use_messiah_charge()
	self._messiah_cooldown = Application:time() + tweak_data.upgrades.messiah_cooldown
	managers.hud:start_cooldown("messiah", tweak_data.upgrades.messiah_cooldown)
end

--Called when players get kills while downed.
function PlayerManager:_on_messiah_event()
	if self._current_state == "bleed_out" and not self._coroutine_mgr:is_running("get_up_messiah") then
		if self._messiah_cooldown < Application:time() then
			self._coroutine_mgr:add_coroutine("get_up_messiah", PlayerAction.MessiahGetUp, self)
		else
			self._messiah_cooldown = self._messiah_cooldown - tweak_data.upgrades.messiah_kill_cdr --Downed kill CDR.
			managers.hud:change_cooldown("messiah", -tweak_data.upgrades.messiah_kill_cdr)
		end
	end
end

--Calculates bonus from Moving Target.
function PlayerManager:detection_risk_movement_speed_bonus()
	local multiplier = 0
	local detection_risk_add_movement_speed = managers.player:upgrade_value("player", "detection_risk_add_movement_speed")
	multiplier = multiplier + self:get_value_from_risk_upgrade(detection_risk_add_movement_speed, self._detection_risk)
	return multiplier
end

--Remove some unused skills, and make use of cached detection risk value.
function PlayerManager:critical_hit_chance(detection_risk)
	local multiplier = 0
	multiplier = multiplier + self:upgrade_value("player", "critical_hit_chance", 0)
	multiplier = multiplier + self:upgrade_value("weapon", "critical_hit_chance", 0)
	multiplier = multiplier + managers.player:temporary_upgrade_value("temporary", "unseen_strike", 1) - 1
	multiplier = multiplier + self._crit_mul - 1
	local detection_risk_add_crit_chance = managers.player:upgrade_value("player", "detection_risk_add_crit_chance")
	multiplier = multiplier + self:get_value_from_risk_upgrade(detection_risk_add_crit_chance, self._detection_risk)

	return multiplier
end

--Used in some sort of groupai state besiege nonsense. Probably not a good idea and also undocumented
--Probs best to nuke this in the future.
function PlayerManager:_chk_fellow_crimin_proximity(unit)
	local players_nearby = 0
	
	local enemies = World:find_units_quick(unit, "sphere", unit:position(), 1500, managers.slot:get_mask("criminals_no_deployables"))

	for _, enemy in ipairs(enemies) do
		players_nearby = players_nearby + 1
	end
	
	return players_nearby
end


function PlayerManager:damage_reduction_skill_multiplier(damage_type)
	local multiplier = 1
	multiplier = multiplier * self:temporary_upgrade_value("temporary", "revived_damage_resist", 1) --Running From Death Ace
	multiplier = multiplier * self:temporary_upgrade_value("temporary", "first_aid_damage_reduction", 1) --Quick Fix Ace
	multiplier = multiplier * self:temporary_upgrade_value("temporary", "revive_damage_reduction", 1) --Combat Medic
	multiplier = multiplier * self._properties:get_property("revive_damage_reduction", 1) --Combat Medic
	multiplier = multiplier * self._temporary_properties:get_property("revived_damage_reduction", 1) --Painkillers
	multiplier = multiplier * (1 - self:close_combat_upgrade_value("player", "damage_dampener_close_contact", 0)) --Infiltrator
	multiplier = multiplier * self:close_combat_upgrade_value("player", "damage_dampener_outnumbered", 1) --Sociopath
	multiplier = multiplier * (1 - self:close_combat_upgrade_value("player", "close_combat_damage_reduction", 0)) --Underdog Ace

	--Yakuza DR.
	local health_ratio = self:player_unit():character_damage():health_ratio()
	if self:is_damage_health_ratio_active(health_ratio) then
		multiplier = multiplier * (1 - self:upgrade_value("player", "resistance_damage_health_ratio_multiplier", 0) * (1 - health_ratio))
	end

	if damage_type == "melee" then
		multiplier = multiplier * self:upgrade_value("player", "melee_damage_dampener", 1) --Martial Arts Basic
	elseif damage_type == "kick_or_shock" then --Cloaker kicks/taser shocks
		multiplier = multiplier * self:upgrade_value("player", "spooc_damage_resist", 1.0) --Counter Strike
	end

	local current_state = self:get_current_state()

	if current_state then
		if current_state:_interacting() then
			multiplier = multiplier * self:upgrade_value("player", "interacting_damage_multiplier", 1) --Nerves of Steel Ace
		elseif current_state:in_melee() then
			local melee_name_id = managers.blackmarket:equipped_melee_weapon()
			multiplier = multiplier * self:upgrade_value("player", "deflect_ranged", 1) --Iron Knuckles Ace

			if tweak_data.blackmarket.melee_weapons[melee_name_id].block then --Buck shield.
				multiplier = multiplier * tweak_data.blackmarket.melee_weapons[melee_name_id].block
			end
		end
	end

	return multiplier
end

--Removed a number of situational buffs in vanilla that might result in dodge points being set wrong.
--Leaving stance stuff in parameters for compatability.
function PlayerManager:skill_dodge_chance(running, crouching, on_zipline, override_armor, detection_risk)
	local chance = self:upgrade_value("player", "passive_dodge_chance", 0)
	
	chance = chance + self:upgrade_value("player", "tier_dodge_chance", 0)

	local detection_risk_add_dodge_chance = self:upgrade_value("player", "detection_risk_add_dodge_chance")
	chance = chance + self:get_value_from_risk_upgrade(detection_risk_add_dodge_chance, self._detection_risk)
	chance = chance + self:upgrade_value("player", tostring(override_armor or managers.blackmarket:equipped_armor(true, true)) .. "_dodge_addend", 0)

	return chance
end

--Now can also trigger from Yakuza DR. No longer triggers from damage skills
function PlayerManager:is_damage_health_ratio_active(health_ratio)
	return self:has_category_upgrade("player", "resistance_damage_health_ratio_multiplier") and self:get_damage_health_ratio(health_ratio, "armor_regen") > 0
		or self:has_category_upgrade("player", "movement_speed_damage_health_ratio_multiplier") and self:get_damage_health_ratio(health_ratio, "movement_speed") > 0
end

function PlayerManager:health_skill_multiplier()
	local multiplier = 1
	multiplier = multiplier + self:upgrade_value("player", "health_multiplier", 1) - 1
	multiplier = multiplier + self:upgrade_value("player", "passive_health_multiplier", 1) - 1
	multiplier = multiplier + self:team_upgrade_value("health", "passive_multiplier", 1) - 1
	multiplier = multiplier + self:get_hostage_bonus_multiplier("health") - 1
	multiplier = multiplier * self:upgrade_value("player", "health_decrease", 1.0) --Anarchist reduces health by expected amount.
	
	return multiplier
end

function PlayerManager:check_skills()
	self:send_message_now("check_skills")
	self._coroutine_mgr:clear()

	self._single_shot_panic_when_kill = self:has_category_upgrade("weapon", "single_shot_panic_when_kill")
	self._unseen_strike = self:has_category_upgrade("player", "unseen_increased_crit_chance")
	self._silent_precision = self:has_category_upgrade("player", "silent_increased_accuracy")
	self._slow_duration_multiplier = self:upgrade_value("player", "slow_duration_multiplier", 1)

	if self:has_category_upgrade("shotgun", "shell_stacking_reload_speed") then
		self._shell_rack = self:upgrade_value("shotgun", "shell_stacking_reload_speed")
		self._shell_rack_stacks = 0
	end

	--Make Trigger Happy and Desperado stack off of headshots.
	if self:has_category_upgrade("pistol", "stacked_accuracy_bonus") then
		self:register_message(Message.OnHeadShot, self, callback(self, self, "_on_expert_handling_event"))
	else
		self:unregister_message(Message.OnHeadShot, self)
	end

	if self:has_category_upgrade("pistol", "stacking_hit_damage_multiplier") then
		self:register_message(Message.OnHeadShot, "trigger_happy", callback(self, self, "_on_enter_trigger_happy_event"))
	else
		self:unregister_message(Message.OnHeadShot, "trigger_happy")
	end

	self._bloodthirst_stacks = 0
	if self:has_category_upgrade("player", "melee_damage_stacking") then
		self._bloodthirst_data = self:upgrade_value("player", "melee_damage_stacking", nil)
		self:register_message(Message.OnEnemyKilled, "bloodthirst_stacking", callback(self, self, "_trigger_bloodthirst"))
		self:register_message(Message.OnEnemyHit, "bloodthirst_consuming", callback(self, self, "_consume_bloodthirst"))
	else
		self._bloodthirst_data = nil
		self:unregister_message(Message.OnEnemyKilled, "bloodthirst_stacking")
		self:unregister_message(Message.OnEnemyHit, "bloodthirst_consuming")
	end

	if self:has_category_upgrade("player", "messiah_revive_from_bleed_out") then
		self._messiah_cooldown = 0
		self:register_message(Message.OnEnemyKilled, "messiah_revive_from_bleed_out", callback(self, self, "_on_messiah_event"))
	else
		self._messiah_cooldown = nil
		self:unregister_message(Message.OnEnemyKilled, "messiah_revive_from_bleed_out")
	end

	if self:has_category_upgrade("player", "recharge_messiah") then
		self:register_message(Message.OnDoctorBagUsed, "recharge_messiah", callback(self, self, "_on_messiah_recharge_event"))
	else
		self:unregister_message(Message.OnDoctorBagUsed, "recharge_messiah")
	end

	if self:has_category_upgrade("temporary", "single_shot_fast_reload") then
		self:register_message(Message.OnLethalHeadShot, "activate_aggressive_reload", callback(self, self, "_on_activate_aggressive_reload_event"))
	else
		self:unregister_message(Message.OnLethalHeadShot, "activate_aggressive_reload")
	end

	if self:has_category_upgrade("temporary", "single_shot_reload_speed_multiplier") then
		self:register_message(Message.OnEnemyKilled, "activate_specialized_equipment", callback(self, self, "_trigger_specialized_equipment"))
	else
		self:unregister_message(Message.OnEnemyKilled, "activate_specialized_equipment")
	end

	if self:has_category_upgrade("assault_rifle", "headshot_bloom_reduction") then
		self:register_message(Message.OnLethalHeadShot, "reduce_bloom_from_headshot_kill", callback(self, self, "_trigger_rapid_reset_bloom_reduction"))
	else
		self:unregister_message(Message.OnLethalHeadShot, "reduce_bloom_from_headshot_kill")
	end

	if self:has_category_upgrade("player", "head_shot_ammo_return") then
		self._ammo_efficiency = self:upgrade_value("player", "head_shot_ammo_return", nil)
		self:register_message(Message.OnHeadShot, "ammo_efficiency", callback(self, self, "_on_enter_ammo_efficiency_event"))
	else
		self._ammo_efficiency = nil
		self:unregister_message(Message.OnHeadShot, "ammo_efficiency")
	end

	if self:has_category_upgrade("player", "melee_kill_auto_load") then
		self:register_message(Message.OnEnemyKilled, "snatch_auto_load", callback(self, self, "_trigger_snatch_auto_load"))
	else
		self:unregister_message(Message.OnEnemyKilled, "snatch_auto_load")
	end

	if self:has_category_upgrade("player", "melee_kill_increase_reload_speed") then
		self:register_message(Message.OnEnemyKilled, "snatch_reload_speed", callback(self, self, "_on_enemy_killed_bloodthirst"))
	else
		self:unregister_message(Message.OnEnemyKilled, "snatch_reload_speed")
	end

	if self:has_category_upgrade("player", "super_syndrome") then
		self._super_syndrome_count = self:upgrade_value("player", "super_syndrome")
	else
		self._super_syndrome_count = 0
	end

	self._hot_data = self:upgrade_value("player", "heal_over_time", {})
	if self._hot_data.source then
		if self._hot_data.source == "rogue" then
			self:register_message(Message.OnPlayerDodge, "dodge_stack_health_regen", callback(self, self, "_trigger_heal_over_time"))
			self:unregister_message(Message.OnEnemyHit, "melee_stack_health_regen")
			self:unregister_message(Message.OnEnemyKilled, "kill_stack_health_regen")
		elseif self._hot_data.source == "infiltrator" then
			self:register_message(Message.OnEnemyHit, "melee_stack_health_regen", callback(self, self, "_trigger_heal_over_time"))
			self:unregister_message(Message.OnPlayerDodge, "dodge_stack_health_regen")
			self:unregister_message(Message.OnEnemyKilled, "kill_stack_health_regen")
		elseif self._hot_data.source == "grinder" then
			self:register_message(Message.OnEnemyKilled, "kill_stack_health_regen", callback(self, self, "_trigger_heal_over_time"))
			self:unregister_message(Message.OnPlayerDodge, "dodge_stack_health_regen")
			self:unregister_message(Message.OnEnemyHit, "melee_stack_health_regen")
		end
	else
		self:unregister_message(Message.OnPlayerDodge, "dodge_stack_health_regen")
		self:unregister_message(Message.OnEnemyHit, "melee_stack_health_regen")
		self:unregister_message(Message.OnEnemyKilled, "kill_stack_health_regen")
	end

	if self:has_category_upgrade("player", "bomb_cooldown_reduction") then
		self:register_message(Message.OnEnemyKilled, "dodge_smokebomb_cdr", callback(self, self, "_dodge_smokebomb_cdr"))
	else
		self:unregister_message(Message.OnEnemyKilled, "dodge_smokebomb_cdr")
	end

	if self:has_category_upgrade("player", "dodge_heal_no_armor") then
		self:register_message(Message.OnPlayerDodge, "dodge_healing_no_armor", callback(self, self, "_dodge_healing_no_armor"))
	else
		self:unregister_message(Message.OnPlayerDodge, "dodge_healing_no_armor")
	end

	if managers.blackmarket:equipped_grenade() == "smoke_screen_grenade" then
		local function speed_up_on_kill()
			managers.player:speed_up_grenade_cooldown(1)
		end

		self:register_message(Message.OnEnemyKilled, "speed_up_smoke_grenade", speed_up_on_kill)
	else
		self:unregister_message(Message.OnEnemyKilled, "speed_up_smoke_grenade")
	end

	self:add_coroutine("damage_control", PlayerAction.DamageControl)

	if self:has_category_upgrade("snp", "graze_damage") then
		self:register_message(Message.OnWeaponFired, "graze_damage", callback(SniperGrazeDamage, SniperGrazeDamage, "on_weapon_fired"))
	else
		self:unregister_message(Message.OnWeaponFired, "graze_damage")
	end

	if self:has_category_upgrade("temporary", "headshot_accuracy_addend") then
		self:register_message(Message.OnHeadShot, "sharpshooter", callback(self, self, "_trigger_sharpshooter"))
	else
		self:unregister_message(Message.OnHeadShot, "sharpshooter")
	end

	if self:has_category_upgrade("player", "store_temp_health") then
		self:register_message(Message.OnEnemyKilled, "hitman_temp_health", callback(self, self, "_trigger_hitman")) --Triggers include killing his dog and stealing his car.
	else
		self:unregister_message(Message.OnEnemyKilled, "hitman_temp_health")
	end

	if self:has_category_upgrade("player", "armor_health_store_amount") then
		self:register_message(Message.OnEnemyKilled, "expres_store_health", callback(self, self, "_trigger_expres"))
	else
		self:unregister_message(Message.OnEnemyKilled, "expres_store_health")
	end

	if self:has_category_upgrade("player", "kill_change_regenerate_speed") then
		self:register_message(Message.OnEnemyKilled, "ex_pres_regen_armor", callback(self, self, "_trigger_expres_armor"))
	else
		self:unregister_message(Message.OnEnemyKilled, "ex_pres_regen_armor")
	end

	if self:has_category_upgrade("player", "kill_dodge_regen") then
		self:register_message(Message.OnEnemyKilled, "yakuza_on_kill_dodge", callback(self, self, "_trigger_yakuza"))
	else
		self:unregister_message(Message.OnEnemyKilled, "yakuza_on_kill_dodge")
	end

	if self:has_category_upgrade("player", "biker_armor_regen") then
		self:register_message(Message.OnEnemyKilled, "biker_melee_armor", callback(self, self, "_trigger_biker"))
	else
		self:unregister_message(Message.OnEnemyKilled, "biker_melee_armor")
	end

	if self:has_category_upgrade("cooldown", "melee_kill_life_leech") then
		self:register_message(Message.OnEnemyKilled, "sociopath_melee_health", callback(self, self, "_trigger_sociopath_heal"))
	else
		self:unregister_message(Message.OnEnemyKilled, "sociopath_melee_health")
	end

	if self:has_category_upgrade("cooldown", "killshot_regen_armor_bonus") then
		self:register_message(Message.OnEnemyKilled, "sociopath_armor", callback(self, self, "_trigger_sociopath_armor"))
	else
		self:unregister_message(Message.OnEnemyKilled, "sociopath_armor")
	end

	if self:has_category_upgrade("player", "overheat_stacking") then
		self:register_message(Message.OnEnemyKilled, "overheat_stacking", callback(self, self, "_trigger_overheat_stack"))
	else
		self:unregister_message(Message.OnEnemyKilled, "overheat_stacking")
	end

	if self:has_category_upgrade("temporary", "bullet_hell") and self:upgrade_value("temporary", "bullet_hell")[1].kill_refund > 0 then
		self:register_message(Message.OnEnemyKilled, "bullet_hell_reload", callback(self, self, "_trigger_bullet_hell_reload"))
	else
		self:unregister_message(Message.OnEnemyKilled, "bullet_hell_reload")
	end

	if self:has_category_upgrade("player", "survive_one_hit_kill_cdr") then
		self:register_message(Message.OnEnemyKilled, "yakuza_on_kill_cdr", callback(self, self, "_trigger_survive_one_hit_cdr"))
	else
		self:unregister_message(Message.OnEnemyKilled, "yakuza_on_kill_cdr")
	end

	self._hyper_crit_stacks = 0
	if self:has_category_upgrade("player", "hyper_crits") then
		self:register_message(Message.OnWeaponFired, "consume_hyper_crit_stack", callback(self, self, "_consume_hyper_crit_stack"))
		self:register_message(Message.OnEnemyKilled, "trigger_hyper_crits", callback(self, self, "_trigger_hyper_crits"))
	else
		self:unregister_message(Message.OnWeaponFired, "consume_hyper_crit_stack")
		self:unregister_message(Message.OnEnemyKilled, "trigger_hyper_crits")
	end

	if self:has_category_upgrade("player", "melee_hit_stamina") then
		self:register_message(Message.OnEnemyHit, "fast_feet", callback(self, self, "_trigger_melee_hit_stamina"))
	else
		self:unregister_message(Message.OnEnemyHit, "fast_feet")
	end
end

--Passes on a notification when an enemy is hit with a melee attack.
function PlayerManager:enemy_hit(unit, attack_data)
	self._message_system:notify(Message.OnEnemyHit, nil, self._unit, attack_data)
end

local mvec3_norm = mvector3.normalize
local mvec3_dis_sq = mvector3.distance_sq
local mvec3_cpy = mvector3.copy
local ovh_idstr = Idstring("effects/pd2_mod_heatgen/explosions/overheat")
function PlayerManager:enemy_shot(unit, attack_data)
	self._message_system:notify(Message.OnEnemyShot, nil, self._unit, attack_data)

	--Do Overheat stuff if player has the skill.
	if self:has_category_upgrade("player", "overheat") then
		--Filter out invalid attacks.
		local weapon_unit = attack_data.weapon_unit
		local player_unit = attack_data.attacker_unit
		if player_unit ~= self:player_unit()
			or not weapon_unit
			or weapon_unit ~= self:equipped_weapon_unit()
			or not self:equipped_weapon_unit():base():is_category("shotgun", "flamethrower") then
			return
		end

		--Filter out attacks from too far away.
		local overheat_data = self:upgrade_value("player", "overheat")
		local player_pos = player_unit:movement():m_pos()
		local source_pos = unit:movement():m_pos()
		local distance = mvec3_dis_sq(player_pos, source_pos)
		if distance > overheat_data.range * overheat_data.range then
			return
		end

		--Do the random roll and see if it procs.
		local chance = overheat_data.chance + self:get_temporary_property("overheat_stacks", 0)
		local roll = math.random()
		if roll <= chance then
			local source_com = unit:movement():m_com()
			
			World:effect_manager():spawn({
				effect = ovh_idstr,
				position = source_com,
				normal = math.UP
			})
			unit:sound():play("swat_explosion")
			
			local hit_enemies = World:find_units_quick("sphere", source_pos, overheat_data.aoe_radius, managers.slot:get_mask("enemies"))

			--Damage nearby enemies.
			for i = 1, #hit_enemies do
				local enemy = hit_enemies[i]
				local dmg_ext = enemy:character_damage()

				if dmg_ext and dmg_ext.damage_simple then
					local m_com = enemy:movement():m_com()
					local attack_dir = m_com - source_com
					mvec3_norm(attack_dir)

					local overheat_attack_data = {
						variant = "overheat",
						damage = attack_data.damage * overheat_data.damage,
						attacker_unit = player_unit,
						pos = mvec3_cpy(m_com),
						attack_dir = attack_dir
					}

					dmg_ext:damage_simple(overheat_attack_data)
				end
			end
		end
	end
end

--The OnHeadShot message must now pass in attack data and unit info to let certains skills work as expected.
--IE: Ammo Efficiency not proccing off of melee headshots.
function PlayerManager:on_headshot_dealt(unit, attack_data)
	local player_unit = self:player_unit()

	if not player_unit then
		return
	end

	self._message_system:notify(Message.OnHeadShot, nil, unit, attack_data)

	local t = Application:time()

	if self._on_headshot_dealt_t and t < self._on_headshot_dealt_t then
		return
	end

	self._on_headshot_dealt_t = t + (tweak_data.upgrades.on_headshot_dealt_cooldown or 0)
	local damage_ext = player_unit:character_damage()
	local regen_armor_bonus = managers.player:upgrade_value("player", "headshot_regen_armor_bonus", 0)

	if damage_ext and regen_armor_bonus > 0 then
		damage_ext:restore_armor(regen_armor_bonus)
	end
end

--Add extra checks to make sure that it only looks for killing headshots done with valid guns.
function PlayerManager:_on_enter_ammo_efficiency_event(unit, attack_data)
	if not self._coroutine_mgr:is_running("ammo_efficiency") then
		local weapon_unit = self:equipped_weapon_unit()
		local attacker_unit = attack_data.attacker_unit
		local variant = attack_data.variant

		if attacker_unit == self:player_unit() and variant == "bullet" and weapon_unit and weapon_unit:base():is_category("assault_rifle", "snp") and attack_data.result.type == "death" then
			self._coroutine_mgr:add_coroutine("ammo_efficiency", PlayerAction.AmmoEfficiency, self, self._ammo_efficiency.headshots, self._ammo_efficiency.ammo, Application:time() + self._ammo_efficiency.time)
		end
	end
end

--Get health damage reduction gained via skills.
--Crashes mentioning this function mean that there is a syntax error in the file.
function PlayerManager:get_deflection_from_skills()
	return self:upgrade_value("player", "deflection_addend", 0)
end

function PlayerManager:get_max_grenades(grenade_id)
	grenade_id = grenade_id or managers.blackmarket:equipped_grenade()
	local max_amount = tweak_data:get_raw_value("blackmarket", "projectiles", grenade_id, "max_amount") or 0

	--Jack of all trades basic grenade count increase.
	--MAY be source of grenade syncing issues due to interaction with get_max_grenades_by_peer_id(). Is worth investigating some time.
	if max_amount and not tweak_data:get_raw_value("blackmarket", "projectiles", grenade_id, "base_cooldown") then
		max_amount = math.ceil(max_amount * self:upgrade_value("player", "throwables_multiplier", 1.0))
	end
	max_amount = managers.modifiers:modify_value("PlayerManager:GetThrowablesMaxAmount", max_amount)

	return max_amount
end

function PlayerManager:_internal_load()
	local player = self:player_unit()

	if not player then
		return
	end

	--Remove sticky buff trackers.
	if not self._unseen_strike then
		managers.hud:remove_skill("unseen_strike")
	end
	
	if not self._silent_precision then
		managers.hud:remove_skill("silent_precision")
	end

	local default_weapon_selection = 1
	local secondary = managers.blackmarket:equipped_secondary()
	local secondary_slot = managers.blackmarket:equipped_weapon_slot("secondaries")
	local texture_switches = managers.blackmarket:get_weapon_texture_switches("secondaries", secondary_slot, secondary)

	player:inventory():add_unit_by_factory_name(secondary.factory_id, default_weapon_selection == 1, false, secondary.blueprint, secondary.cosmetics, texture_switches)

	local primary = managers.blackmarket:equipped_primary()

	if primary then
		local primary_slot = managers.blackmarket:equipped_weapon_slot("primaries")
		local texture_switches = managers.blackmarket:get_weapon_texture_switches("primaries", primary_slot, primary)

		player:inventory():add_unit_by_factory_name(primary.factory_id, default_weapon_selection == 2, false, primary.blueprint, primary.cosmetics, texture_switches)
	end

	player:inventory():hide_equipped_unit()
	player:inventory():set_melee_weapon(managers.blackmarket:equipped_melee_weapon())

	local peer_id = managers.network:session():local_peer():id()
	local grenade, amount = managers.blackmarket:equipped_grenade()

	if self:has_grenade(peer_id) then
		amount = self:get_grenade_amount(peer_id) or amount
	end

	if amount and not grenade.base_cooldown then --*Should* stop perk deck actives from being increased.
		amount = managers.modifiers:modify_value("PlayerManager:GetThrowablesMaxAmount", amount) --Crime spree throwables mod.
		amount = math.ceil(amount * self:upgrade_value("player", "throwables_multiplier", 1.0)) --JOAT Basic
	end

	self:_set_grenade({
		grenade = grenade,
		amount = math.min(amount, self:get_max_grenades())
	})
	self:_set_body_bags_amount(self._local_player_body_bags or self:total_body_bags())

	if not self._respawn then
		self:_add_level_equipment(player)
		self._down_time = tweak_data.player.damage.DOWNED_TIME --Tracks down time for custody purposes.
		for i, name in ipairs(self._global.default_kit.special_equipment_slots) do
			local ok_name = self._global.equipment[name] and name

			if ok_name then
				local upgrade = tweak_data.upgrades.definitions[ok_name]

				if upgrade and (upgrade.slot and upgrade.slot < 2 or not upgrade.slot) then
					self:add_equipment({
						silent = true,
						equipment = upgrade.equipment_id
					})
				end
			end
		end

		local slot = 2

		if self:has_category_upgrade("player", "second_deployable") then
			slot = 3
		else
			self:set_equipment_in_slot(nil, 2)
		end

		local equipment_list = self:equipment_slots()

		for i, name in ipairs(equipment_list) do
			local ok_name = self._global.equipment[name] and name or self:equipment_in_slot(i)

			if ok_name then
				local upgrade = tweak_data.upgrades.definitions[ok_name]

				if upgrade and (upgrade.slot and upgrade.slot < slot or not upgrade.slot) then
					self:add_equipment({
						silent = true,
						equipment = upgrade.equipment_id,
						slot = i
					})
				end
			end
		end

		self:update_deployable_selection_to_peers()
	else --If someone is respawning from custody, apply relevant penalties.
		for id, weapon in pairs(player:inventory():available_selections()) do
			if alive(weapon.unit) then
				weapon.unit:base():remove_ammo(tweak_data.player.damage.custody_ammo_drained)
				managers.hud:set_ammo_amount(id, weapon.unit:base():ammo_info())
			end
		end
		self._down_time = self._down_time - tweak_data.player.damage.DOWNED_TIME_DEC
		player:character_damage():exit_custody(math.max(tweak_data.player.damage.DOWNED_TIME_MIN, self._down_time))
	end

	if self:has_category_upgrade("player", "messiah_revive_from_bleed_out") then
		managers.hud:add_skill("messiah")
	end

	if self:has_category_upgrade("cooldown", "long_dis_revive") then
		managers.hud:add_skill("long_dis_revive")
	end

	if self:has_category_upgrade("cooldown", "survive_one_hit") then
		managers.hud:add_skill("survive_one_hit")
	end

	if self:has_category_upgrade("cooldown", "shotgun_reload_interrupt_stagger") then
		managers.hud:add_skill("shotgun_reload_interrupt_stagger")
	end

	if self:has_category_upgrade("player", "cocaine_stacking") then
		self:update_synced_cocaine_stacks_to_peers(0, self:upgrade_value("player", "sync_cocaine_upgrade_level", 1), self:upgrade_level("player", "cocaine_stack_absorption_multiplier", 0))
		managers.hud:set_info_meter(nil, {
			icon = "guis/dlcs/coco/textures/pd2/hud_absorb_stack_icon_01",
			max = 1,
			current = self:get_local_cocaine_damage_absorption_ratio(),
			total = self:get_local_cocaine_damage_absorption_max_ratio()
		})
	end

	self:update_cocaine_hud()

	local equipment = self:selected_equipment()

	if equipment then
		add_hud_item(get_as_digested(equipment.amount), equipment.icon)
	end

	--Removed armor kit weirdness.

	--Fully loaded aced checks
	self._ammo_boxes_until_throwable = self:upgrade_value("player", "regain_throwable_from_ammo")

	--Reset when players are spawned, just in case.
	self._slow_data = {
		duration = 0,
		power = 0,
		start_time = 0
	}

	--Precache detection risk, so that the value does not need to be recalculated every frame (very slow).
	self._detection_risk = math.round(managers.blackmarket:get_suspicion_offset_of_local(tweak_data.player.SUSPICION_OFFSET_LERP or 0.75) * 100)
end


function PlayerManager:set_melee_knockdown_multiplier(value)
	self._melee_knockdown_mul = value
end

function PlayerManager:reset_melee_knockdown_multiplier()
	self._melee_knockdown_mul = 1
end

function PlayerManager:get_melee_knockdown_multiplier() 
	return self._melee_knockdown_mul
end

--Moves skills to here for a central point of contact for melee damage multipliers.
function PlayerManager:get_melee_dmg_multiplier()
	return self._melee_dmg_mul
		* managers.player:upgrade_value("weapon", "passive_damage_multiplier", 1)
		* (1 + self:close_combat_upgrade_value("player", "close_combat_damage_boost", 0))
		* self:upgrade_value("player", "melee_damage_health_ratio_multiplier", 1)
end

--Cuts Sicario smock bomb cooldown on kills while inside smoke bomb.
function PlayerManager:_dodge_smokebomb_cdr(equipped_unit, variant, killed_unit)
	local damage_ext = self:player_unit():character_damage()
	
	if damage_ext and damage_ext.in_smoke_bomb == 2 then
		self:speed_up_grenade_cooldown(tweak_data.upgrades.values.player.bomb_cooldown_reduction[1])
	end
end

--Fills dodge meter when backstab kills are done.
function PlayerManager:add_backstab_dodge()
	if self.player_unit then
		local damage_ext = self:player_unit():character_damage()
		damage_ext:fill_dodge_meter(damage_ext:get_dodge_points() * self:upgrade_value("player", "backstab_dodge", 0))
	end
end

--Sneaky Bastard Aced healing stuff.
function PlayerManager:_dodge_healing_no_armor()
	local damage_ext = self:player_unit():character_damage()
	if not (damage_ext:get_real_armor() > 0) and damage_ext:can_dodge_heal() then
		damage_ext:restore_health(self:upgrade_value("player", "dodge_heal_no_armor"), true)
	end
end

--Adds a stack of health regen, may be called by multiple different listeners.
--Rogue calls it on dodge.
--Infiltrator calls it on melee hit.
--Grinder calls it on kill.
function PlayerManager:_trigger_heal_over_time()
	self:player_unit():character_damage():add_hot_stack()
end

--Boosts ROF on headshot kills with single fire guns.
function PlayerManager:_trigger_sharpshooter(unit, attack_data)
	local weapon_unit = self:equipped_weapon_unit()
	local attacker_unit = attack_data.attacker_unit
	local variant = attack_data.variant

	if attacker_unit == self:player_unit() and variant == "bullet" and weapon_unit and weapon_unit:base():fire_mode() == "single" and weapon_unit:base():is_category("assault_rifle", "snp") and attack_data.result.type == "death" then
		self:activate_temporary_upgrade("temporary", "headshot_accuracy_addend")
		self:activate_temporary_upgrade("temporary", "headshot_fire_rate_mult")
	end
end

--Briefly boosts reload speed on single-shot weapons.
function PlayerManager:_trigger_specialized_equipment(equipped_unit, variant, killed_unit)
	if alive(equipped_unit) and equipped_unit:base():holds_single_round() then
		self:activate_temporary_upgrade("temporary", "single_shot_reload_speed_multiplier")
	end
end

function PlayerManager:_trigger_melee_hit_stamina()
	self:player_unit():movement():add_stamina(self:upgrade_value("player", "melee_hit_stamina"))
end

function PlayerManager:can_hyper_crit()
	return self._hyper_crit_stacks > 0
end

function PlayerManager:_consume_hyper_crit_stack(unit, result)
	if self._hyper_crit_stacks > 0 then
		self._hyper_crit_stacks = self._hyper_crit_stacks - 1
		managers.hud:set_stacks("hyper_crits", self._hyper_crit_stacks)
	end
end

function PlayerManager:_trigger_hyper_crits(equipped_unit, variant, killed_unit)
	if variant == "melee" then
		self._hyper_crit_stacks = self:upgrade_value("player", "hyper_crits")
		managers.hud:set_stacks("hyper_crits", self._hyper_crit_stacks)
	end
end

function PlayerManager:_on_activate_aggressive_reload_event(attack_data)
	if attack_data and attack_data.variant == "bullet" then
		local weapon_unit = self:equipped_weapon_unit()

		if weapon_unit then
			local weapon = weapon_unit:base()

			if weapon and weapon:is_category("assault_rifle", "snp") then
				self:activate_temporary_upgrade("temporary", "single_shot_fast_reload")
			end
		end
	end
end

function PlayerManager:_trigger_rapid_reset_bloom_reduction(attack_data)
	if attack_data and attack_data.variant == "bullet" then
		local weapon_unit = self:equipped_weapon_unit()

		if weapon_unit then
			local weapon = weapon_unit:base()

			if weapon and weapon:is_category("assault_rifle", "snp") then
				weapon:multiply_bloom(self:upgrade_value("assault_rifle", "headshot_bloom_reduction", 1))
			end
		end
	end
end

--Returns the bonus attached to shell rack.
function PlayerManager:get_shell_rack_bonus(weap_base)
	local bonus = 0
	if not self._shell_rack then
		return 0
	end

	local is_shotgun = weap_base:is_category("shotgun")
	local is_shotgun_reload = weap_base:use_shotgun_reload()
	if not (is_shotgun or (self._shell_rack.apply_to_shotgun_reload and is_shotgun_reload)) then
		return 0
	end

	return self._shell_rack_stacks * (is_shotgun_reload and self._shell_rack.shotgun_reload_value or self._shell_rack.mag_reload_value)
end

--Removes all shell rack stacks if the given weapon can use them. Should be called after reloading has started.
function PlayerManager:consume_shell_rack_stacks(weap_base)
	local is_shotgun = weap_base:is_category("shotgun")
	local is_shotgun_reload = weap_base:use_shotgun_reload()
	if not self._shell_rack or not (is_shotgun or (self._shell_rack.apply_to_shotgun_reload and is_shotgun_reload)) then
		return
	end

	self._shell_rack_stacks = 0
	managers.hud:remove_skill("shell_stacking_reload")
end

--No longer applies anything to the hud element. Since it's now used to reflect the amount damage was recently reduced by.
function PlayerManager:set_damage_absorption(key, value)
	self._damage_absorption[key] = value and Application:digest_value(value, true) or nil
end

function PlayerManager:update_cocaine_hud()
	--The DR component of the hud is now used to show the amount that damage was recently reduced by.
	--As a result, we should no longer update it to match damage absorption, and instead let PlayerDamage handle it.
	--[[if managers.hud then
		managers.hud:set_absorb_active(HUDManager.PLAYER_PANEL, self:damage_absorption())
	end]]
end

--Adds doctor bag health regen.
function PlayerManager:health_regen()
	local health_regen = tweak_data.player.damage.HEALTH_REGEN
	health_regen = health_regen + self:temporary_upgrade_value("temporary", "wolverine_health_regen", 0)
	health_regen = health_regen + self:upgrade_value("player", "passive_health_regen", 0)
	health_regen = health_regen + self:temporary_upgrade_value("temporary", "doctor_bag_health_regen", 0)

	return health_regen
end

--Move hostage taker to flat # regen from % regen. Add max hostage regen bonus.
function PlayerManager:fixed_health_regen()
	local health_regen = 0
	health_regen = health_regen + self:upgrade_value("team", "crew_health_regen", 0)
	health_regen = health_regen + self:get_hostage_bonus_addend("health_regen")
	local groupai = managers.groupai and managers.groupai:state()
	if (groupai and groupai:hostage_count() + (groupai._num_converted_police or self:num_local_minions()) or self:num_local_minions() or 0) >= tweak_data:get_raw_value("upgrades", "hostage_max_num", "health_regen") then
		health_regen = health_regen + self:get_hostage_bonus_addend("health_regen") * self:upgrade_value("player", "hostage_health_regen_max_mult", 0)
	end

	return health_regen
end

--Slows the player by a % that decays linearly over a duration, along with a visual.
--Power should be between 1 and 0. Corresponds to % speed is slowed on start.
function PlayerManager:apply_slow_debuff(duration, power)
	if power > 1 - self:_slow_debuff_mult() then
		self._slow_data = {
			duration = duration * self._slow_duration_multiplier,
			power = power,
			start_time = Application:time()
		}
		managers.hud:activate_effect_screen(duration, {0.0, 0.2, power})
	end
end

function PlayerManager:_slow_debuff_mult()
	local time = Application:time()
	
	if self._slow_data.start_time + self._slow_data.duration < time then
		return 1 --no slow
	end

	return math.clamp(1 - self._slow_data.power * (1 - ((time - self._slow_data.start_time) / self._slow_data.duration)), 0, 1)
end

--Called when psychoknife kills are performed.
function PlayerManager:spread_panic(chance)
	local pos = self:player_unit():position()
	local area = 1000
	local amount = 200
	local enemies = World:find_units_quick("sphere", pos, area, 12, 21)

	for i, unit in ipairs(enemies) do
		if unit:character_damage() then
			unit:character_damage():build_suppression(amount, chance)
		end
	end
end

--Should help stop Trip Mines and ECMs from becoming embeded in the floor.
function PlayerManager:check_selected_equipment_placement_valid(player)
	local equipment_data = managers.player:selected_equipment()
	if not equipment_data then
		return false
	end
	
	if equipment_data.equipment == "trip_mine" or equipment_data.equipment == "ecm_jammer" then
		return player:equipment():valid_look_at_placement(tweak_data.equipments[equipment_data.equipment]) and true or false
	else
		return player:equipment():valid_shape_placement(equipment_data.equipment, tweak_data.equipments[equipment_data.equipment]) and true or false
	end
end

function PlayerManager:_on_spawn_extra_ammo_event(killed_unit)
	if Network:is_client() then
		managers.network:session():send_to_host("sync_spawn_extra_ammo", killed_unit)
	else
		self:spawn_extra_ammo(killed_unit)
	end
end

--Because listeners execute after the frame they are called on, vanilla Bloodthirst can fail to catch some kills since the coroutine to handle stacks doesn't exist yet.
--The solution is to directly handle it inside PlayerManager, since the couroutine pretty much just existed to change PlayerManager state anyway.
function PlayerManager:_trigger_bloodthirst(weapon_unit, variant)
	if variant ~= "melee" then
		self._bloodthirst_stacks = math.min(self._bloodthirst_stacks + 1, self._bloodthirst_data.max_stacks)
		managers.hud:set_stacks("bloodthirst_stacks", self._bloodthirst_stacks)
		self:set_melee_knockdown_multiplier(1 + (self._bloodthirst_stacks * self._bloodthirst_data.knockdown_multiplier))
		self:set_melee_dmg_multiplier(1 + (self._bloodthirst_stacks * self._bloodthirst_data.damage_multiplier))
	end
end

--Likewise, we make bloodthirst go away after a melee hit instead of a melee kill.
function PlayerManager:_consume_bloodthirst(unit, attack_data)
	self._bloodthirst_stacks = 0
	managers.hud:remove_skill("bloodthirst_stacks")
	managers.player:reset_melee_knockdown_multiplier()
	managers.player:reset_melee_dmg_multiplier()
end

function PlayerManager:_trigger_snatch_auto_load(equipped_unit, variant, killed_unit)
	if variant == "melee" then
		local weapon_unit = equipped_unit:base()
		local bullets_loaded = weapon_unit:get_ammo_remaining_in_clip()
		
		if weapon_unit:is_category("grenade_launcher") then
			bullets_loaded = bullets_loaded + self:upgrade_value("player", "melee_kill_auto_load", 0)[1]
		else
			bullets_loaded = bullets_loaded + self:upgrade_value("player", "melee_kill_auto_load", 0)[2]
		end
		 
		bullets_loaded = math.min(bullets_loaded, math.min(weapon_unit:get_ammo_total(), weapon_unit:get_ammo_max_per_clip()))
		weapon_unit:set_ammo_remaining_in_clip(bullets_loaded)
		managers.hud:set_ammo_amount(weapon_unit:selection_index(), weapon_unit:ammo_info())
	end
end

function PlayerManager:_trigger_bullet_hell_reload(equipped_unit, variant, killed_unit)
	if self:has_activate_temporary_upgrade("temporary", "bullet_hell") then
		local weapon_unit = equipped_unit:base()
		local bullets_loaded = weapon_unit:get_ammo_remaining_in_clip() + self:temporary_upgrade_value("temporary", "bullet_hell").kill_refund
		bullets_loaded = math.min(bullets_loaded, math.min(weapon_unit:get_ammo_total(), weapon_unit:get_ammo_max_per_clip()))
		weapon_unit:set_ammo_remaining_in_clip(bullets_loaded)
		managers.hud:set_ammo_amount(weapon_unit:selection_index(), weapon_unit:ammo_info())
	end
end

function PlayerManager:_trigger_expres(equipped_unit, variant, killed_unit)
	if CopDamage.is_civilian(killed_unit:base()._tweak_table) then
		return
	end

	self:player_unit():character_damage():add_armor_stored_health(self:upgrade_value("player", "armor_health_store_amount", 0))
end

function PlayerManager:_trigger_expres_armor(equipped_unit, variant, killed_unit)
	if self:has_category_upgrade("player", "kill_change_regenerate_speed") then
		local amount = self:body_armor_value("skill_kill_change_regenerate_speed", nil, 1)
		local multiplier = self:upgrade_value("player", "kill_change_regenerate_speed", 0)

		self:player_unit():character_damage():change_regenerate_speed(amount * multiplier, tweak_data.upgrades.kill_change_regenerate_speed_percentage)
	end
end

function PlayerManager:_trigger_yakuza(equipped_unit, variant, killed_unit)
	local damage_ext = self:player_unit():character_damage()

	if damage_ext:health_ratio() < 0.5 then
		if variant == "melee" then
			damage_ext:fill_dodge_meter_yakuza(self:upgrade_value("player", "melee_kill_dodge_regen", 0) + self:upgrade_value("player", "kill_dodge_regen"))
		else
			damage_ext:fill_dodge_meter_yakuza(self:upgrade_value("player", "kill_dodge_regen"))
		end
	end
end

function PlayerManager:_trigger_biker(equipped_unit, variant, killed_unit)
	if self:has_category_upgrade("player", "biker_armor_regen") then
		self:player_unit():character_damage():tick_biker_armor_regen(self:upgrade_value("player", "biker_armor_regen")[3])
	end
end

function PlayerManager:_trigger_hitman(equipped_unit, variant, killed_unit)
	if CopDamage.is_civilian(killed_unit:base()._tweak_table) then
		return
	end
	
	if variant == "melee" then
		self:player_unit():character_damage():consume_temp_stored_health()
	else
		self:player_unit():character_damage():add_armor_stored_health(self:upgrade_value("player", "store_temp_health", {0, 0})[2])
	end
end

function PlayerManager:_trigger_sociopath_heal(equipped_unit, variant, killed_unit)
	if variant == "melee" then
		self:player_unit():character_damage():restore_health(self:use_cooldown_upgrade("cooldown", "melee_kill_life_leech"))
	end
end

function PlayerManager:_trigger_sociopath_armor(equipped_unit, variant, killed_unit)
	local player_unit = self:player_unit()
	local damage_ext = player_unit:character_damage()

	if damage_ext:get_real_armor() == damage_ext:_max_armor() then
		return
	end

	local data = self:use_cooldown_upgrade("cooldown", "killshot_regen_armor_bonus", {0, 0})
	local armor_regen = data[1]
	local dist_sq = mvector3.distance_sq(player_unit:movement():m_pos(), killed_unit:movement():m_pos())
	local close_combat_sq = tweak_data.upgrades.close_combat_distance * tweak_data.upgrades.close_combat_distance
	if dist_sq <= close_combat_sq then
		armor_regen = armor_regen + data[2]
	end

	damage_ext:restore_armor(armor_regen)
end

--Adds another stack of Overheat chance.
function PlayerManager:_trigger_overheat_stack(equipped_unit, variant, killed_unit)
	local stacking_data = self:upgrade_value("player", "overheat_stacking")
	local distance = mvector3.distance_sq(self:player_unit():movement():m_pos(), killed_unit:movement():m_pos())
	if distance > stacking_data.range * stacking_data.range then
		return
	end

	self:add_to_temporary_property("overheat_stacks", stacking_data.time, stacking_data.chance_inc)
	managers.hud:start_buff("overheat_stacks", stacking_data.time)
	managers.hud:set_stacks("overheat_stacks", math.min(math.round(self:get_temporary_property("overheat_stacks", 0) / stacking_data.chance_inc), 4))
end

function PlayerManager:_trigger_survive_one_hit_cdr(equipped_unit, variant, killed_unit)
	self:extend_cooldown_upgrade("cooldown", "survive_one_hit", -self:upgrade_value("player", "survive_one_hit_kill_cdr"))
end

function PlayerManager:_attempt_chico_injector()
	if self:has_activate_temporary_upgrade("temporary", "chico_injector") then
		return false
	end

	local duration = self:upgrade_value("temporary", "chico_injector")[2]
	local now = managers.game_play_central:get_heist_timer()

	managers.network:session():send_to_peers("sync_ability_hud", now + duration, duration)
	self:activate_temporary_upgrade("temporary", "chico_injector")

	local function speed_up_on_kill()
		managers.player:speed_up_grenade_cooldown(1)
	end

	self:register_message(Message.OnEnemyKilled, "speed_up_chico_injector", speed_up_on_kill)

	--Add dodge on activation.
	local damage_ext = self:player_unit():character_damage()
	damage_ext:fill_dodge_meter(damage_ext:get_dodge_points() * self:upgrade_value("player", "chico_injector_dodge", 0))

	return true
end

--Restores 1 down when enough assaults have passed and bots have the skill. Counter is paused when player is in custody or has max revives; or if the crew loses access to the skill.
function PlayerManager:check_enduring()
	if self:has_category_upgrade("team", "crew_scavenge") then
		if not self._assaults_to_extra_revive then
			self._assaults_to_extra_revive = self:crew_ability_upgrade_value("crew_scavenge")
		end

		if self._assaults_to_extra_revive and alive(self:player_unit()) then
			local damage_ext = self:player_unit():character_damage()
			if damage_ext:get_missing_revives() > 0 then
				self._assaults_to_extra_revive = math.max(self._assaults_to_extra_revive - 1, 0)
				if self._assaults_to_extra_revive == 0 then
					damage_ext:add_revive()
					managers.hud:show_hint( { text = "Assaults Survived- Restoring 1 Down" } )
					self._assaults_to_extra_revive = self:crew_ability_upgrade_value("crew_scavenge")
				elseif self._assaults_to_extra_revive == 1 then
					managers.hud:show_hint( { text = "1 Assault Remaining Until Down Restore." } )
				else
					managers.hud:show_hint( { text = tostring(self._assaults_to_extra_revive) .. " Assaults Remaining Until Down Restore." } )
				end
			end
		end
	end
end

--Makes *all* converts contribute to hostage skills, rather than just local converts.
function PlayerManager:get_hostage_bonus_multiplier(category)
	local groupai = managers.groupai and managers.groupai:state()
	local hostages = groupai and groupai:hostage_count() or 0
	hostages = hostages + (groupai and groupai._num_converted_police or self:num_local_minions() or 0)
	local multiplier = 0
	local hostage_max_num = tweak_data:get_raw_value("upgrades", "hostage_max_num", category)

	if hostage_max_num then
		hostages = math.min(hostages, hostage_max_num)
	end

	multiplier = multiplier + self:team_upgrade_value(category, "hostage_multiplier", 1) - 1
	multiplier = multiplier + self:team_upgrade_value(category, "passive_hostage_multiplier", 1) - 1
	multiplier = multiplier + self:upgrade_value("player", "hostage_" .. category .. "_multiplier", 1) - 1
	multiplier = multiplier + self:upgrade_value("player", "passive_hostage_" .. category .. "_multiplier", 1) - 1
	--Removed useless local_player call.

	--No close to hostage boosts.

	return 1 + multiplier * hostages
end

--Makes *all* converts contribute to hostage skills, rather than just local converts.
function PlayerManager:get_hostage_bonus_addend(category)
	local groupai = managers.groupai and managers.groupai:state()
	local hostages = groupai and groupai:hostage_count() or 0
	hostages = hostages + (groupai and groupai._num_converted_police or self:num_local_minions() or 0)
	local addend = 0
	local hostage_max_num = tweak_data:get_raw_value("upgrades", "hostage_max_num", category)

	if hostage_max_num then
		hostages = math.min(hostages, hostage_max_num)
	end

	addend = addend + self:team_upgrade_value(category, "hostage_addend", 0)
	addend = addend + self:team_upgrade_value(category, "passive_hostage_addend", 0)
	addend = addend + self:upgrade_value("player", "hostage_" .. category .. "_addend", 0)
	addend = addend + self:upgrade_value("player", "passive_hostage_" .. category .. "_addend", 0)
	--Removed useless local_player call.

	--No close to hostage boosts.

	return addend * hostages
end

--Instantly reloads all equipped weapons. Used by Running from Death Ace.
function PlayerManager:reload_weapons()
	local weapons = {
		self:player_unit():inventory():unit_by_selection(1), --Secondary
		self:player_unit():inventory():unit_by_selection(2), --Primary
		self:player_unit():inventory():unit_by_selection(3) --Underbarrels
	}

	for _, weapon in pairs(weapons) do
		if weapon and weapon.base then
			local weapon_base = weapon:base()
			weapon_base:on_reload(nil)
			managers.statistics:reloaded()
			managers.hud:set_ammo_amount(weapon_base:selection_index(), weapon_base:ammo_info())
		end
	end
end

--Replacement for vanilla fully loaded throwable coroutine. The vanilla code has 0 benefits from being a coroutine, and it seems to have issues resetting the chance or firing at all.
function PlayerManager:regain_throwable_from_ammo()
	if self._ammo_boxes_until_throwable then --Cheap workaround for vanilla main menu somehow calling this code and causing crashes.
		local peer_id = managers.network:session():local_peer():id()
		local curr_amount = self._global.synced_grenades[peer_id].amount
		local max_amount = self:get_max_grenades()

		if Application:digest_value(curr_amount, false) < max_amount then
			self._ammo_boxes_until_throwable = self._ammo_boxes_until_throwable - 1	
			if self._ammo_boxes_until_throwable == 0 then
				self:add_grenade_amount(1, true)
				self._ammo_boxes_until_throwable = self:upgrade_value("player", "regain_throwable_from_ammo")
			end
		end
	end
end

--Better rounding behavior on DA. Add 1 to deal with some weird rounding edge cases.
function PlayerManager:_get_cocaine_damage_absorption_from_data(data)
	local amount = data.amount or 0
	local upgrade_level = data.upgrade_level or 1

	if amount == 0 then
		return 0
	end
	
	return math.floor((amount + 1) / (tweak_data.upgrades.cocaine_stacks_convert_levels and tweak_data.upgrades.cocaine_stacks_convert_levels[upgrade_level] or 20)) * (tweak_data.upgrades.cocaine_stacks_dmg_absorption_value or 0.1)
end

--Adds buff tracker call.
function PlayerManager:disable_cooldown_upgrade(category, upgrade)
	local upgrade_value = self:upgrade_value(category, upgrade)

	if upgrade_value == 0 then
		return
	end

	local time = upgrade_value[2]
	self._global.cooldown_upgrades[category] = self._global.cooldown_upgrades[category] or {}
	self._global.cooldown_upgrades[category][upgrade] = {
		cooldown_time = Application:time() + time
	}
	managers.hud:start_cooldown(upgrade, time)
end

--Gets the value of a cooldown upgrade and triggers the cooldown if the upgrade is available.
--Otherwise, just returns 0 or default.
function PlayerManager:use_cooldown_upgrade(category, upgrade, default)
	local upgrade_value = self:upgrade_value(category, upgrade)

	if upgrade_value == 0 then
		return default or 0
	end

	local cooldown_timestamp = self._global.cooldown_upgrades[category] and self._global.cooldown_upgrades[category][upgrade] and self._global.cooldown_upgrades[category][upgrade].cooldown_time or 0

	if cooldown_timestamp <= Application:time() then	
		--Does same as disable cooldown upgrade, but without redundant checks.
		local time = upgrade_value[2]
		self._global.cooldown_upgrades[category] = self._global.cooldown_upgrades[category] or {}
		self._global.cooldown_upgrades[category][upgrade] = {
			cooldown_time = Application:time() + time
		}
		managers.hud:start_cooldown(upgrade, time)
		return upgrade_value[1]
	else
		return default or 0
	end
end

function PlayerManager:extend_cooldown_upgrade(category, upgrade, time)
	local cooldown_timestamp = self._global.cooldown_upgrades[category] and self._global.cooldown_upgrades[category][upgrade] and self._global.cooldown_upgrades[category][upgrade].cooldown_time

	if cooldown_timestamp then	
		self._global.cooldown_upgrades[category][upgrade].cooldown_time = cooldown_timestamp + time
		managers.hud:change_cooldown(upgrade, time)
	end
end

--Adds buff tracker call.
function PlayerManager:activate_temporary_upgrade(category, upgrade)
	local upgrade_value = self:upgrade_value(category, upgrade)

	if upgrade_value == 0 then
		return
	end

	local time = upgrade_value[2]
	self._temporary_upgrades[category] = self._temporary_upgrades[category] or {}
	self._temporary_upgrades[category][upgrade] = {
		expire_time = Application:time() + time
	}

	if self:is_upgrade_synced(category, upgrade) then
		managers.network:session():send_to_peers("sync_temporary_upgrade_activated", self:temporary_upgrade_index(category, upgrade))
	end
	managers.hud:start_buff(upgrade, time)
end

--Activates a temporary upgrade 'forever' until otherwise noted.
--Currently only used for unseen strike, so syncing support isn't implemented.
function PlayerManager:activate_temporary_upgrade_indefinitely(category, upgrade)
	local upgrade_value = self:upgrade_value(category, upgrade)

	if upgrade_value == 0 then
		return
	end

	self._temporary_upgrades[category] = self._temporary_upgrades[category] or {}
	self._temporary_upgrades[category][upgrade] = {
		expire_time = math.huge
	}
	managers.hud:remove_skill(upgrade)
	managers.hud:add_skill(upgrade)
end

--Adds buff tracker call.
function PlayerManager:deactivate_temporary_upgrade(category, upgrade)
	local upgrade_value = self:upgrade_value(category, upgrade)

	if upgrade_value == 0 then
		return
	end

	if not self._temporary_upgrades[category] then
		return
	end

	self._temporary_upgrades[category][upgrade] = nil
	managers.hud:remove_skill(upgrade)
end

--The vanilla version of this function is actually nonfunctional. No wonder it's never used.
--This fixes it to fulfill its intended purpose of letting active temporary upgrade durations be changed.
function PlayerManager:extend_temporary_upgrade(category, upgrade, time)
	local upgrade_value = self:upgrade_value(category, upgrade)

	if upgrade_value == 0 then
		return
	end

	self._temporary_upgrades[category][upgrade].expire_time = self._temporary_upgrades[category][upgrade].expire_time + time
end

--Returns the value for an upgrade that scales off of the number of nearby enemies.
function PlayerManager:close_combat_upgrade_value(category, upgrade, default)
	local player_unit = self:player_unit()

	if not alive(player_unit) or not self._global.upgrades[category] or not self._global.upgrades[category][upgrade] then
		return default or 0
	end

	local level = self._global.upgrades[category][upgrade]
	local data = tweak_data.upgrades.values[category][upgrade][level]
	local nr_close_guys = player_unit:movement():nr_close_guys()
	local value = default or 0
	if data.fewer_than and data.fewer_than >= nr_close_guys then
		value = data.value
	elseif data.max then
		value = data.value * math.min(nr_close_guys, data.max)
	elseif data.min and data.min <= nr_close_guys then
		 value = data.value
	end

	return value
end

function PlayerManager:_add_equipment(params)
	if self:has_equipment(params.equipment) then
		print("Allready have equipment", params.equipment)

		return
	end

	local equipment = params.equipment
	local tweak_data = tweak_data.equipments[equipment]
	local amount = {}
	local amount_digest = {}
	local quantity = tweak_data.quantity

	for i = 1, #quantity do
		local equipment_name = equipment

		if tweak_data.upgrade_name then
			equipment_name = tweak_data.upgrade_name[i]
		end

		local amt = (quantity[i] or 0) + self:equiptment_upgrade_value(equipment_name, "quantity")
		amt = managers.modifiers:modify_value("PlayerManager:GetEquipmentMaxAmount", amt, params)

		table.insert(amount, amt)
		table.insert(amount_digest, Application:digest_value(0, true))
	end

	local icon = params.icon or tweak_data and tweak_data.icon
	local use_function_name = params.use_function_name or tweak_data and tweak_data.use_function_name
	local use_function = use_function_name or nil

	--JOAT gives full deployable count.

	table.insert(self._equipment.selections, {
		equipment = equipment,
		amount = amount_digest,
		use_function = use_function,
		action_timer = tweak_data.action_timer,
		icon = icon,
		unit = tweak_data.unit,
		on_use_callback = tweak_data.on_use_callback
	})

	self._equipment.selected_index = self._equipment.selected_index or 1

	add_hud_item(amount, icon)

	for i = 1, #amount do
		self:add_equipment_amount(equipment, amount[i], i)
	end
end

--Use the old version of this function prior to Overkill's update because they don't invalidate the cached value properly in menus.
function PlayerManager:get_value_from_risk_upgrade(risk_upgrade, detection_risk)
	local risk_value = 0

	if not detection_risk then
		detection_risk = managers.blackmarket:get_suspicion_offset_of_local(tweak_data.player.SUSPICION_OFFSET_LERP or 0.75)
		detection_risk = math.round(detection_risk * 100)
	end

	if risk_upgrade and type(risk_upgrade) == "table" then
		local value = risk_upgrade[1]
		local step = risk_upgrade[2]
		local operator = risk_upgrade[3]
		local threshold = risk_upgrade[4]
		local cap = risk_upgrade[5]
		local num_steps = 0

		if operator == "above" then
			num_steps = math.max(math.floor((detection_risk - threshold) / step), 0)
		elseif operator == "below" then
			num_steps = math.max(math.floor((threshold - detection_risk) / step), 0)
		end

		risk_value = num_steps * value

		if cap then
			risk_value = math.min(cap, risk_value) or risk_value
		end
	end

	return risk_value
end

function PlayerManager:spawned_player(id, unit)
	self._players[id] = unit

	MenuCallbackHandler:_update_outfit_information()
	self:setup_viewports()
	self:_internal_load()
	self:_change_player_state()

	if id == 1 then
		--Sets burst fire in hud for guns that start in it.
		local primary = unit:inventory():unit_by_selection(1):base()
		if primary:in_burst_mode() then
			managers.hud:set_teammate_weapon_firemode_burst(1)
		else
			managers.hud:set_teammate_weapon_firemode(HUDManager.PLAYER_PANEL, 1, primary:fire_mode())
		end

		local secondary = unit:inventory():unit_by_selection(2):base()
		if secondary:in_burst_mode() then
			managers.hud:set_teammate_weapon_firemode_burst(2)
		else
			managers.hud:set_teammate_weapon_firemode(HUDManager.PLAYER_PANEL, 2, secondary:fire_mode())
		end

		local grenade_cooldown = tweak_data.blackmarket.projectiles[managers.blackmarket:equipped_grenade()].base_cooldown
		if grenade_cooldown and not self:got_max_grenades() then
			self:replenish_grenades(grenade_cooldown)
		end
	end
end

--Gets the perk deck damage bonus for the desired unit.
--For real players, it's based on the synced progress in their perk deck's passive damage mul.
--For bots, it scales off of difficulty.
--For all other units, it simply returns 1.
function PlayerManager:get_perk_damage_bonus(unit)
	local multiplier = 1
	--Apply perk deck damage bonus.
	if alive(unit) then
		if unit == self:player_unit() then
			multiplier = self:upgrade_value("weapon", "passive_damage_multiplier", 1)
		elseif unit:base().upgrade_value then
			multiplier = (unit:base():upgrade_value("weapon", "passive_damage_multiplier") or 1)
		elseif managers.groupai:state():is_unit_team_AI(unit) then
			multiplier = (tweak_data.character.team_ai_perk_damage_mul or 2)
		end
	end

	return multiplier
end