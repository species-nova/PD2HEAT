local job = Global.level_data and Global.level_data.level_id

--Headshot damage tiers.
local headshot_difficulty_array = {2, 2.5, 3}
local normal_headshot = 1 --2 below Overkill, 2.5 on Mayhem-Deathwish, 3 on DS
local bravo_headshot = 1.5 --3 below Overkill, 3.75 on Mayhem-Deathwish, 4.5 on DS
local strong_headshot = 2 --4 below Overkill, 5 on Mayhem-Deathwish, 6 on DS
local projectile_throw_pos_offset = Vector3(50, 50, 0)

--Grenades
	local frag = {
		type = "bravo_frag",
		cooldown = 3, --Cooldown between grenade throw attempts.
		use_cooldown = 12, --Cooldown between throwing a grenade and starting attempts again.
		chance = 0.15, --Chance to throw grenade for each attempt.
		min_range = 500, --Minimum range grenade can be thrown to.
		max_range = 2000, --Maximum range grenade can be thrown to.
		throw_force = 1 / 1300, --Force multiplier applied to throw.
		offset = projectile_throw_pos_offset, --Offset applied to grenade spawn position, usually used to sync it to hand position. 
		voiceline = "use_gas" --Voiceline unit plays when throwing grenade.
		--no_anim = true --Add this field to grenades launched by grenade launchers to skip throwing animation.
	}

	local cluster_frag = {
		type = "cluster_fuck",
		cooldown = 12,
		chance = 1,
		min_range = 500,
		max_range = 2000,
		throw_force = 1 / 1300,
		offset = projectile_throw_pos_offset,
		voiceline = "use_gas"
	}

	local tear_gas = {
		type = "gas_grenade",
		cooldown = 2,
		use_cooldown = 10,
		chance = 0.75,
		min_range = 500,
		max_range = 2400,
		throw_force = 1 / 1150,
		no_anim = true,
		voiceline = "use_gas"
	}

	local autumn_gas = {
		type = "gas_grenade",
		cooldown = 2,
		use_cooldown = 15,
		chance = 0.6,
		min_range = 500,
		max_range = 2400,
		throw_force = 1 / 1150,
		offset = projectile_throw_pos_offset,
		voiceline = "i03"
	}

	local molotov = {
		type = "molotov",
		cooldown = 2,
		use_cooldown = 6,
		chance = 0.5,
		min_range = 500,
		max_range = 2000,
		throw_force = 1 / 1150,
		offset = projectile_throw_pos_offset,
		voiceline = "use_gas"
	}

	local hatman_molotov = {
		type = "hatman_molotov",
		cooldown = 10,
		chance = 1,
		min_range = 500,
		max_range = 2000,
		throw_force = 1 / 1150,
		offset = projectile_throw_pos_offset,
		voiceline = "use_gas"
	}

	local gang_member_launcher_frag = {
		type="launcher_frag",
		chance = 0.9,
		cooldown = 5,
		use_cooldown = 50,
		min_range = 500,
		max_range = 2400,
		throw_force = 1 / 650,
		voiceline = "g43",
		strict_throw = 3,
		no_anim = true
	}

local old_init = CharacterTweakData.init
function CharacterTweakData:init(tweak_data, presets)
	old_init(self, tweak_data, presets)
	local presets = self:_presets(tweak_data)
	local func = "_init_region_" .. tostring(tweak_data.levels:get_ai_group_type())

	self[func](self)

	self._prefix_data_p1 = {
		cop = function ()
			return self._unit_prefixes.cop
		end,
		swat = function ()
			return self._unit_prefixes.swat
		end,
		heavy_swat = function ()
			return self._unit_prefixes.heavy_swat
		end,
		taser = function ()
			return self._unit_prefixes.taser
		end,
		cloaker = function ()
			return self._unit_prefixes.cloaker
		end,
		bulldozer = function ()
			return self._unit_prefixes.bulldozer
		end,
		medic = function ()
			return self._unit_prefixes.medic
		end
	}
	
	self:_init_boom(presets)
	self:_init_spring(presets)
	self:_init_summers(presets)
	self:_init_autumn(presets)
	self:_init_omnia_lpf(presets)
	self:_init_tank_biker(presets)
end

function CharacterTweakData:_init_region_america()
	self._default_chatter = "dispatch_generic_message"
	self._unit_prefixes = {
		cop = "l",
		swat = "l",
		heavy_swat = "l",
		taser = "tsr",
		cloaker = "clk",
		bulldozer = "bdz",
		medic = "mdc"
	}
	self._speech_prefix_p2 = "d"
end

function CharacterTweakData:_init_region_russia()
	self._default_chatter = "dsp_radio_russian"
	self._unit_prefixes = {
		cop = "r",
		swat = "r",
		heavy_swat = "r",
		taser = "rtsr",
		cloaker = "rclk",
		bulldozer = "rbdz",
		medic = "rmdc"
	}
	self._speech_prefix_p2 = "n"
end

function CharacterTweakData:_init_region_zombie()
	self._default_chatter = "dsp_radio_zombie"
	self._unit_prefixes = {
		cop = "z",
		swat = "z",
		heavy_swat = "z",
		taser = "tsr",
		cloaker = "clk",
		bulldozer = "bdz",
		medic = "mdc"
	}
	self._speech_prefix_p2 = "n"
end

function CharacterTweakData:_init_region_murkywater()
	self._default_chatter = "dsp_radio_russian"
	self._unit_prefixes = {
		cop = "l",
		swat = "l",
		heavy_swat = "l5d",
		taser = "tsr",
		cloaker = "clk",
		bulldozer = "bdz",
		medic = "nothing"
	}
	self._speech_prefix_p2 = "n"
end

function CharacterTweakData:_init_region_federales()
	self._default_chatter = "mex_dispatch_generic_message"
	self._unit_prefixes = {
		cop = "m",
		swat = "m",
		heavy_swat = "m",
		taser = "mtsr",
		cloaker = "mclk",
		bulldozer = "mbdz",
		medic = "mmdc"
	}
	self._speech_prefix_p2 = "n"
end	

function CharacterTweakData:_init_region_nypd()
	self._default_chatter = "dispatch_generic_message"
	self._unit_prefixes = {
		cop = "l",
		swat = "l",
		heavy_swat = "l",
		taser = "tsr",
		cloaker = "clk",
		bulldozer = "bdz",
		medic = "mdc"
	}
	self._speech_prefix_p2 = "d"
end

function CharacterTweakData:_init_region_lapd()
	self._default_chatter = "dispatch_generic_message"
	self._unit_prefixes = {
		cop = "l",
		swat = "l",
		heavy_swat = "l",
		taser = "tsr",
		cloaker = "clk",
		bulldozer = "bdz",
		medic = "mdc"
	}
	self._speech_prefix_p2 = "d"
end		

function CharacterTweakData:get_ai_group_type()    
	local bullshit = self.tweak_data.levels:get_ai_group_type()
	if not Global.game_settings then
		return group_to_use
	end
	local ai_group_type = {}
	ai_group_type["murkywater"] = "murkywater"    
	ai_group_type["federales"] = "federales"        
	ai_group_type["zombie"] = "zombie"                
	ai_group_type["russia"] = "russia"        
   
	if bullshit then
		if ai_group_type[bullshit] then
			group_to_use = ai_group_type[bullshit]
		end
	end
	return group_to_use
end

function CharacterTweakData:_init_security(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.security = deep_clone(presets.base)
	self.security.tags = {"law"}
	self.security.experience = {}
	self.security.weapon = presets.weapon.normal
	self.security.detection = presets.detection.guard
	self.security.HEALTH_INIT = 12
	self.security.headshot_dmg_mul = normal_headshot
	self.security.move_speed = presets.move_speed.normal
	self.security.crouch_move = nil
	self.security.surrender_break_time = {20, 30}
	self.security.suppression = presets.suppression.easy
	self.security.surrender = presets.surrender.easy
	self.security.ecm_vulnerability = 1
	self.security.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.security.weapon_voice = "3"
	self.security.melee_weapon = "baton"
	self.security.experience.cable_tie = "tie_swat"
	self.security.speech_prefix_p1 = "l"
	self.security.speech_prefix_p2 = "n"
	self.security.speech_prefix_count = 4
	self.security.access = "security"
	self.security.rescue_hostages = false
	self.security.use_radio = nil
	self.security.silent_priority_shout = "f37"
	self.security.dodge = presets.dodge.poor
	self.security.deathguard = false
	self.security.chatter = presets.enemy_chatter.guard
	self.security.has_alarm_pager = true
	if is_murky then
		self.security.radio_prefix = "fri_"
	end			
	self.security.steal_loot = nil
	self.security.static_dodge_preset = true
	self.security.shooting_death = false
	self.security.heal_cooldown = 2
	table.insert(self._enemy_list, "security")
	
	self.security_undominatable = deep_clone(self.security)
	self.security_undominatable.surrender = nil
	self.security_undominatable.unintimidateable = true
	table.insert(self._enemy_list, "security_undominatable")
	
	self.mute_security_undominatable = deep_clone(self.security)
	self.mute_security_undominatable.suppression = nil
	self.mute_security_undominatable.surrender = nil
	self.mute_security_undominatable.has_alarm_pager = false
	self.mute_security_undominatable.chatter = presets.enemy_chatter.no_chatter
	self.mute_security_undominatable.weapon_voice = "3"
	self.mute_security_undominatable.speech_prefix_p1 = "bb"
	self.mute_security_undominatable.speech_prefix_p2 = "n"
	self.mute_security_undominatable.speech_prefix_count = 1
	if job == "tag" or job == "xmn_tag" then
		self.mute_security_undominatable.failure_on_death = true
		self.mute_security_undominatable.unintimidateable = true
	end
	table.insert(self._enemy_list, "mute_security_undominatable")	
	
	self.security_mex = deep_clone(self.security)
	self.security_mex.speech_prefix_p1 = "m"
	self.security_mex.radio_prefix = "mex_"
	if job == "fex" then
		self.security_mex.melee_weapon = "fists"
	else
		self.security_mex.melee_weapon = "baton"
	end

	table.insert(self._enemy_list, "security_mex")	
	
	self.security_mex_no_pager = deep_clone(self.security)
	self.security_mex_no_pager.speech_prefix_p1 = "m"
	self.security_mex_no_pager.radio_prefix = "mex_"
	self.security_mex_no_pager.has_alarm_pager = false
	if job == "fex" then
		self.security_mex_no_pager.melee_weapon = "fists"
	else
		self.security_mex_no_pager.melee_weapon = "baton"
	end

	table.insert(self._enemy_list, "security_mex_no_pager")		
end

function CharacterTweakData:_init_gensec(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.gensec = deep_clone(presets.base)
	self.gensec.tags = {"law"}
	self.gensec.experience = {}
	self.gensec.weapon = presets.weapon.good
	self.gensec.detection = presets.detection.guard
	self.gensec.HEALTH_INIT = 18
	self.gensec.headshot_dmg_mul = bravo_headshot
	self.gensec.move_speed = presets.move_speed.very_fast
	self.gensec.crouch_move = nil
	self.gensec.surrender_break_time = {20, 30}
	self.gensec.suppression = presets.suppression.hard_def
	self.gensec.surrender = presets.surrender.easy
	self.gensec.ecm_vulnerability = 1
	self.gensec.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.gensec.weapon_voice = "3"
	self.gensec.experience.cable_tie = "tie_swat"
	self.gensec.speech_prefix_p1 = "l"
	self.gensec.speech_prefix_p2 = "n"
	self.gensec.speech_prefix_count = 4
	self.gensec.access = "security"
	self.gensec.rescue_hostages = false
	self.gensec.use_radio = nil
	self.gensec.silent_priority_shout = "f37"
	self.gensec.dodge = presets.dodge.athletic
	self.gensec.deathguard = false
	self.gensec.chatter = presets.enemy_chatter.guard
	self.gensec.has_alarm_pager = true
	self.gensec.melee_weapon = "baton"
	self.gensec.steal_loot = nil
	self.gensec.heal_cooldown = 2
	table.insert(self._enemy_list, "gensec")
	
	--Guard variant, different entry type as a failsafe
	self.gensec_guard = deep_clone(self.gensec)	
	self.gensec_guard.access = "security"
	table.insert(self._enemy_list, "gensec_guard")
end

function CharacterTweakData:_init_cop(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.cop = deep_clone(presets.base)
	self.cop.tags = {"law"}
	self.cop.experience = {}
	self.cop.weapon = presets.weapon.good
	self.cop.detection = presets.detection.normal
	self.cop.HEALTH_INIT = 12
	self.cop.headshot_dmg_mul = normal_headshot
	self.cop.move_speed = presets.move_speed.normal
	self.cop.surrender_break_time = {10, 15}
	self.cop.suppression = presets.suppression.easy
	self.cop.surrender = presets.surrender.easy
	self.cop.ecm_vulnerability = 1
	self.cop.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.cop.weapon_voice = "1"
	self.cop.experience.cable_tie = "tie_swat"
	self.cop.speech_prefix_p1 = self._prefix_data_p1.cop()
	self.cop.speech_prefix_p2 = "n"
	self.cop.speech_prefix_count = 4
	if job == "wwh" then
		self.cop.access = "cop"
	else
		self.cop.access = "fbi"
	end
	self.cop.silent_priority_shout = "f37"
	self.cop.dodge = presets.dodge.average
	self.cop.deathguard = true
	self.cop.shooting_death = false
	self.cop.chatter = presets.enemy_chatter.cop
	self.cop.melee_weapon = "baton"
	if job == "chill_combat" then
		self.cop.steal_loot = true
	else
		self.cop.steal_loot = true
	end
	self.cop.static_dodge_preset = true
	self.cop.has_alarm_pager = false
	self.cop.heal_cooldown = 2
	table.insert(self._enemy_list, "cop")
	self.cop_scared = deep_clone(self.cop)
	self.cop_scared.surrender = presets.surrender.always
	self.cop_scared.surrender_break_time = nil
	table.insert(self._enemy_list, "cop_scared")
	
	self.cop_forest = deep_clone(self.cop)
	self.cop_forest.speech_prefix_p1 = "l"
	self.cop_forest.speech_prefix_p2 = "n"
	self.cop_forest.speech_prefix_count = 4		
	self.cop_forest.access = "gangster"
	table.insert(self._enemy_list, "cop_forest")
	
	self.cop_female = deep_clone(self.cop)
	self.cop_female.speech_prefix_p1 = "fl"
	self.cop_female.speech_prefix_p2 = "n"
	self.cop_female.speech_prefix_count = 1
	self.cop_female.tags = {"law", "female_enemy"}
	table.insert(self._enemy_list, "cop_female")
	self.cop_civ = deep_clone(self.cop)
	self.cop_civ.weapon = presets.weapon.good
	self.cop_civ.detection = presets.detection.normal_undercover
	self.cop_civ.HEALTH_INIT = 0.9
	self.cop_civ.headshot_dmg_mul = 1.7
	self.cop_civ.surrender = nil
	self.cop_civ.unintimidateable = true
	self.cop_civ.silent_priority_shout = nil
	self.cop_civ.melee_weapon = nil
	self.cop_civ.move_speed = presets.move_speed.very_fast
	table.insert(self._enemy_list, "cop_civ")
	
	self.dave = deep_clone(self.cop)
	self.dave.weapon = presets.weapon.good
	self.dave.detection = presets.detection.good
	self.dave.dodge = presets.dodge.elite
	self.dave.HEALTH_INIT = 24
	self.dave.headshot_dmg_mul = 2
	self.dave.silent_priority_shout = nil
	self.dave.melee_weapon = "fists_dozer"
	self.dave.move_speed = presets.move_speed.lightning
	self.dave.custom_voicework = "big_dave"
	self.dave.can_shoot_while_dodging = true
	self.dave.can_slide_on_suppress = true
	self.dave.steal_loot = true
	self.dave.access = "fbi"
	self.dave.speech_prefix_p1 = "fuckyou"
	self.dave.speech_prefix_count = nil   
	self.dave.heal_cooldown = 10
end

function CharacterTweakData:_init_fbi(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.fbi = deep_clone(presets.base)
	self.fbi.tags = {"law"}
	self.fbi.experience = {}
	self.fbi.weapon = presets.weapon.expert
	self.fbi.detection = presets.detection.normal
	self.fbi.HEALTH_INIT = 21.6
	self.fbi.headshot_dmg_mul = normal_headshot
	self.fbi.move_speed = presets.move_speed.very_fast
	self.fbi.surrender_break_time = {7, 12}
	self.fbi.suppression = presets.suppression.hard_def
	self.fbi.surrender = presets.surrender.easy
	self.fbi.ecm_vulnerability = 1
	self.fbi.ecm_hurts = {
			ears = {min_duration = 10, max_duration = 10}
		}
	self.fbi.weapon_voice = "2"
	self.fbi.experience.cable_tie = "tie_swat"
	self.fbi.speech_prefix_p1 = self._prefix_data_p1.cop()
	self.fbi.speech_prefix_p2 = "n"
	self.fbi.speech_prefix_count = 4
	self.fbi.silent_priority_shout = "f37"
	self.fbi.access = "fbi"
	self.fbi.dodge = presets.dodge.athletic
	self.fbi.deathguard = true
	self.fbi.chatter = presets.enemy_chatter.cop
	self.fbi.steal_loot = true
	self.fbi.rescue_hostages = true
	self.fbi.no_arrest = false
	self.fbi.heal_cooldown = 2
	table.insert(self._enemy_list, "fbi")
	self.fbi_female = deep_clone(self.fbi)
	self.fbi_female.speech_prefix_p1 = "fl"
	self.fbi_female.speech_prefix_p2 = "n"
	self.fbi_female.speech_prefix_count = 1
	self.fbi_female.tags = {"law", "female_enemy"}
	table.insert(self._enemy_list, "fbi_female")
	
	self.fbi_vet = deep_clone(self.fbi)
	self.fbi_vet.weapon = presets.weapon.good
	self.fbi_vet.can_shoot_while_dodging = true
	self.fbi_vet.can_slide_on_suppress = true
	self.fbi_vet.HEALTH_INIT = 36
	self.fbi_vet.headshot_dmg_mul = normal_headshot
	self.fbi_vet.damage.melee_damage_mul = 2
	self.fbi_vet.DAMAGE_CLAMP_BULLET = 6
	self.fbi_vet.dodge = presets.dodge.veteran
	self.fbi_vet.access = "spooc"
	self.fbi_vet.damage.hurt_severity = presets.hurt_severities.elite
	self.fbi_vet.use_animation_on_fire_damage = false
	self.fbi_vet.move_speed = presets.move_speed.lightning
	self.fbi_vet.surrender = nil
	self.fbi_vet.unintimidateable = true	
	if is_reaper or is_federales then
	   self.fbi_vet.custom_voicework = nil	
	else   
	   self.fbi_vet.custom_voicework = "bruce"
	end   
	self.fbi_vet.dodge_with_grenade = {
		smoke = {duration = {
			12,
			12
		}},
		check = function (t, nr_grenades_used)
			local delay_till_next_use = 18
			local chance = 0.25

			if math.random() < chance then
				return true, t + delay_till_next_use
			end

			return false, t + delay_till_next_use
		end
	}	
	self.fbi_vet.static_dodge_preset = true
	if is_reaper or is_federales then
		self.fbi_vet.speech_prefix_p1 = self._prefix_data_p1.swat()
		self.fbi_vet.speech_prefix_p2 = self._speech_prefix_p2
		self.fbi_vet.speech_prefix_count = 4
	else
		self.fbi_vet.speech_prefix_p1 = "heck"
		self.fbi_vet.speech_prefix_count = nil	
	end
	self.fbi_vet.heal_cooldown = 2
	table.insert(self._enemy_list, "fbi_vet")	

	self.fbi_vet_boss = deep_clone(self.fbi_vet)
	self.fbi_vet_boss.HEALTH_INIT = 72
	self.fbi_vet_boss.weapon = presets.weapon.expert
	self.fbi_vet_boss.headshot_dmg_mul = normal_headshot	
	self.fbi_vet_boss.melee_weapon = "buzzer_summer"
	self.fbi_vet_boss.tase_on_melee = true
	self.fbi_vet_boss.heal_cooldown = true
	table.insert(self._enemy_list, "fbi_vet_boss")	
	
	self.meme_man = deep_clone(self.fbi_vet)		
	self.meme_man.tags = {"law", "tank", "special"}		
	self.meme_man.HEALTH_INIT = 540
	self.meme_man.damage.explosion_damage_mul = 2
	self.meme_man.headshot_dmg_mul = strong_headshot		
	self.meme_man.can_shoot_while_dodging = true
	self.meme_man.smoke_dodge_increase = 10
	self.meme_man.priority_shout = "f30"
	self.meme_man.bot_priority_shout = "f30x_any"
	self.meme_man.priority_shout_max_dis = 3000		
	self.meme_man.dodge = presets.dodge.veteran
	self.meme_man.allowed_stances = {cbt = true} 
	self.meme_man.access = "gangster"
	self.meme_man.use_animation_on_fire_damage = false
	self.meme_man.move_speed = presets.move_speed.lightning
	self.meme_man.weapon = presets.weapon.meme_man
	self.meme_man.surrender = nil
	self.meme_man.is_special = true
	self.meme_man.unintimidateable = true
	self.meme_man.heal_cooldown = 1
	table.insert(self._enemy_list, "meme_man")	
	self.meme_man_shield = deep_clone(self.meme_man)
	self.meme_man_shield.damage.shield_explosion_damage_mul = 1
	self.meme_man_shield.damage.shield_explosion_ally_damage_mul = 1
	self.meme_man_shield.tags = {"medic", "special", "shield"}		
	self.meme_man_shield.priority_shout = "f30"
	self.meme_man_shield.bot_priority_shout = "f30x_any"
	self.meme_man_shield.priority_shout_max_dis = 3000				
	self.meme_man_shield.access = "gangster"
	self.meme_man_shield.use_animation_on_fire_damage = false
	self.meme_man_shield.weapon = presets.weapon.meme_man
	self.meme_man_shield.move_speed = presets.move_speed.lightning
	self.meme_man_shield.surrender = nil
	self.meme_man_shield.is_special = true
	self.meme_man_shield.unintimidateable = true
	self.meme_man_shield.allowed_poses = {crouch = true}
	self.meme_man_shield.always_face_enemy = true
	self.meme_man_shield.move_speed = presets.move_speed.lightning
	self.meme_man_shield.no_run_start = true
	self.meme_man_shield.no_run_stop = true
	self.meme_man_shield.no_retreat = true
	self.meme_man_shield.no_limping = true
	self.meme_man_shield.no_arrest = true
	self.meme_man_shield.no_equip_anim = true
	self.meme_man_shield.wall_fwd_offset = 100
	self.meme_man_shield.calls_in = nil
	self.meme_man_shield.ignore_medic_revive_animation = true
	self.meme_man_shield.damage.hurt_severity = presets.hurt_severities.only_explosion_hurts
	self.meme_man_shield.damage.shield_knocked = true		
	table.insert(self._enemy_list, "meme_man_shield")				
	self.vetlod = deep_clone(self.fbi_vet)		
	self.vetlod.custom_voicework = "tdozer"
	self.vetlod.access = "fbi"
	table.insert(self._enemy_list, "vetlod")							
end

function CharacterTweakData:_init_medic(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.medic = deep_clone(presets.base)
	self.medic.tags = {"law", "medic", "special"}
	self.medic.experience = {}
	self.medic.weapon = presets.weapon.normal
	self.medic.detection = presets.detection.normal
	self.medic.HEALTH_INIT = 57.6
	self.medic.headshot_dmg_mul = normal_headshot
	self.medic.suppression = nil
	self.medic.surrender = presets.surrender.special
	self.medic.move_speed = presets.move_speed.very_fast
	self.medic.surrender_break_time = {7, 12}
	self.medic.ecm_vulnerability = 1
	self.medic.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.medic.weapon_voice = "2"
	self.medic.experience.cable_tie = "tie_swat"
	self.medic.speech_prefix_p1 = self._prefix_data_p1.medic()
	self.medic.speech_prefix_count = nil
	self.medic.spawn_sound_event = self._prefix_data_p1.medic() .. "_entrance"
	self.medic.access = "swat"
	self.medic.dodge = presets.dodge.athletic
	self.medic.deathguard = true
	self.medic.no_arrest = true
	if is_murky then
	    self.medic.custom_voicework = "murky_medic"
	else	
	    self.medic.custom_voicework = nil
	end	
	self.medic.chatter = {
		aggressive = true,
		retreat = true,
		go_go = true,
		contact = true,
		entrance = true
	}
	self.medic.steal_loot = nil
	self.medic.rescue_hostages = false
	self.medic.priority_shout = "f47"
	self.medic.bot_priority_shout = "f47x_any"
	self.medic.priority_shout_max_dis = 3000
	self.medic.is_special = true
	table.insert(self._enemy_list, "medic")
	self.medic_summers = deep_clone(self.medic)
	self.medic_summers.HEALTH_INIT = 180
	self.medic_summers.headshot_dmg_mul = normal_headshot
	self.medic_summers.weapon = presets.weapon.good
	self.medic_summers.tags = {"medic_summers_special", "medic_summers", "custom", "special"}
	self.medic_summers.ignore_medic_revive_animation = false
	self.medic_summers.surrender = nil
	self.medic_summers.flammable = false
	self.medic_summers.use_animation_on_fire_damage = false
	self.medic_summers.damage.hurt_severity = presets.hurt_severities.only_light_hurt_no_explode
	self.medic_summers.ecm_vulnerability = 0
	self.medic_summers.ecm_hurts = {}			
	self.medic_summers.immune_to_concussion = true
	self.medic_summers.no_damage_mission = true
	self.medic_summers.no_limping = true
	self.medic_summers.no_retreat = true
	self.medic_summers.no_arrest = true
	self.medic_summers.rescue_hostages = false
	self.medic_summers.steal_loot = nil
	self.medic_summers.immune_to_knock_down = true
	self.medic_summers.priority_shout = "f45"
	self.medic_summers.bot_priority_shout = "f45x_any"
	self.medic_summers.speech_prefix_p1 = "rmdc"
	self.medic_summers.speech_prefix_p2 = nil
	self.medic_summers.custom_voicework = nil
	self.medic_summers.spawn_sound_event = "rmdc_entrance"
	self.medic_summers.use_radio = "dsp_radio_russian"
	self.medic_summers.chatter = presets.enemy_chatter.omnia_lpf
	self.medic_summers.is_special = true
	self.medic_summers.do_summers_heal = true
	self.medic_summers.follower = true
	table.insert(self._enemy_list, "medic_summers")
end

function CharacterTweakData:_init_omnia_lpf(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.omnia_lpf = deep_clone(presets.base)
	self.omnia_lpf.experience = {}
	self.omnia_lpf.weapon = presets.weapon.normal
	self.omnia_lpf.detection = presets.detection.normal
	self.omnia_lpf.HEALTH_INIT = 240
	self.omnia_lpf.headshot_dmg_mul = strong_headshot
	self.omnia_lpf.damage.melee_damage_mul = 2
	self.omnia_lpf.move_speed = presets.move_speed.fast
	self.omnia_lpf.surrender_break_time = {7, 12}
	self.omnia_lpf.suppression = nil
	self.omnia_lpf.surrender = nil
	self.omnia_lpf.ecm_vulnerability = 1
	self.omnia_lpf.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.omnia_lpf.weapon_voice = "2"
	self.omnia_lpf.experience.cable_tie = "tie_swat"	
	if is_reaper or is_federales then
		self.omnia_lpf.speech_prefix_p1 = self._prefix_data_p1.medic()
		self.omnia_lpf.speech_prefix_count = nil
		self.omnia_lpf.spawn_sound_event = "rmdc_entrance"
	else
		self.omnia_lpf.speech_prefix_p1 = "piss and shit"
		self.omnia_lpf.speech_prefix_p2 = nil
		self.omnia_lpf.speech_prefix_count = nil
		self.omnia_lpf.spawn_sound_event = nil
	end				
	self.omnia_lpf.access = "swat"
	self.omnia_lpf.dodge = presets.dodge.elite
	self.omnia_lpf.no_arrest = true
	self.omnia_lpf.chatter = presets.enemy_chatter.omnia_lpf
	self.omnia_lpf.melee_weapon = "baton"
	self.omnia_lpf.rescue_hostages = false
	self.omnia_lpf.steal_loot = nil
	if is_reaper or is_federales then
		self.omnia_lpf.custom_voicework = nil
	elseif is_zombie then
		self.omnia_lpf.custom_voicework = "awoolpf"
	else
		self.omnia_lpf.custom_voicework = "olpf"
	end			
	self.omnia_lpf.priority_shout = "f47"
	self.omnia_lpf.bot_priority_shout = "f47x_any"
	self.omnia_lpf.tags = {"law", "medic", "lpf", "special", "customvo"}
	self.omnia_lpf.do_omnia = {
		cooldown = 8,
		radius = 600
	}
	self.omnia_lpf.is_special = true
	table.insert(self._enemy_list, "omnia_lpf")
end

function CharacterTweakData:_init_swat(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.swat = deep_clone(presets.base)
	self.swat.tags = {"law"}
	self.swat.experience = {}
	self.swat.weapon = presets.weapon.expert
	self.swat.detection = presets.detection.normal
	self.swat.HEALTH_INIT = 21.6
	self.swat.headshot_dmg_mul = normal_headshot
	self.swat.move_speed = presets.move_speed.very_fast
	self.swat.surrender_break_time = {6, 10}
	self.swat.suppression = presets.suppression.hard_agg
	self.swat.surrender = presets.surrender.hard
	self.swat.ecm_vulnerability = 1
	self.swat.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.swat.weapon_voice = "2"
	self.swat.experience.cable_tie = "tie_swat"
	self.swat.speech_prefix_p1 = self._prefix_data_p1.cop()
	self.swat.speech_prefix_p2 = "n"
	self.swat.speech_prefix_count = 4
	--Just in case, makes them be able to go for the hostage
	if managers.skirmish and managers.skirmish:is_skirmish() then
		self.swat.access = "fbi"
	else
		self.swat.access = "swat"
	end
	self.swat.dodge = presets.dodge.athletic
	self.swat.no_arrest = false
	self.swat.chatter = presets.enemy_chatter.swat
	self.swat.melee_weapon = "fists"
	if is_murky then
	    self.swat.has_alarm_pager = true
	else
	    self.swat.has_alarm_pager = false
	end
	if job == "kosugi" or job == "dark" then
		self.swat.shooting_death = false
		self.swat.radio_prefix = "fri_"
		self.swat.use_radio = "dsp_radio_russian"
	else
		self.swat.shooting_death = true
	end		
	self.swat.steal_loot = true		
	self.swat.silent_priority_shout = "f37"
	self.swat.heal_cooldown = true
	table.insert(self._enemy_list, "swat")
	
	self.hrt = deep_clone(self.swat)
	self.hrt.access = "fbi"
	self.hrt.rescue_hostages = true
	table.insert(self._enemy_list, "hrt")
	
	self.swat_titan = deep_clone(self.swat)
	self.swat_titan.can_slide_on_suppress = true
	self.swat_titan.damage.hurt_severity = presets.hurt_severities.elite_easy
	self.swat_titan.gas_on_death = true
	self.swat_titan.use_animation_on_fire_damage = true
	self.swat_titan.move_speed = presets.move_speed.very_fast
	self.swat_titan.weapon = presets.weapon.expert
	self.swat_titan.dodge = presets.dodge.elite
	self.swat_titan.HEALTH_INIT = 24
	self.swat_titan.headshot_dmg_mul = normal_headshot
	self.swat_titan.custom_voicework = nil
	self.swat_titan.static_dodge_preset = true
	self.swat_titan.heal_cooldown = true
	self.swat_titan.rescue_hostages = true
	table.insert(self._enemy_list, "swat_titan")
end

function CharacterTweakData:_init_heavy_swat(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.heavy_swat = deep_clone(presets.base)
	self.heavy_swat.tags = {"law"}
	self.heavy_swat.experience = {}
	self.heavy_swat.weapon = presets.weapon.expert
	self.heavy_swat.detection = presets.detection.normal
	self.heavy_swat.HEALTH_INIT = 32.4
	self.heavy_swat.headshot_dmg_mul = normal_headshot
	self.heavy_swat.move_speed = presets.move_speed.fast
	self.heavy_swat.surrender_break_time = {6, 8}
	self.heavy_swat.suppression = presets.suppression.hard_agg
	self.heavy_swat.surrender = presets.surrender.hard
	self.heavy_swat.damage.hurt_severity = presets.hurt_severities.heavy
	self.heavy_swat.ecm_vulnerability = 1
	self.heavy_swat.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.heavy_swat.weapon_voice = "2"
	self.heavy_swat.experience.cable_tie = "tie_swat"
	self.heavy_swat.speech_prefix_p1 = self._prefix_data_p1.swat()
	self.heavy_swat.speech_prefix_p2 = self._speech_prefix_p2
	self.heavy_swat.speech_prefix_count = 4
	self.heavy_swat.access = "swat"
	self.heavy_swat.dodge = presets.dodge.heavy
	self.heavy_swat.no_arrest = false
	self.heavy_swat.chatter = presets.enemy_chatter.swat
	if job == "chill_combat" then
		self.heavy_swat.steal_loot = nil
	else
		self.heavy_swat.steal_loot = true
	end
	if is_murky then
	    self.heavy_swat.has_alarm_pager = true
	else
	    self.heavy_swat.has_alarm_pager = false
	end
	if job == "kosugi" or job == "dark" then
		self.heavy_swat.shooting_death = false
		self.heavy_swat.radio_prefix = "fri_"
		self.heavy_swat.use_radio = "dsp_radio_russian"
	else
		self.heavy_swat.shooting_death = true
	end			
	self.heavy_swat.silent_priority_shout = "f37"
	self.heavy_swat.static_weapon_preset = false
	self.heavy_swat.static_dodge_preset = true
	self.heavy_swat.static_melee_preset = false	
	self.heavy_swat.heal_cooldown = 5
	table.insert(self._enemy_list, "heavy_swat")
	
	self.heavy_swat_sniper = deep_clone(self.heavy_swat)
	self.heavy_swat_sniper.tags = {"law", "sniper", "special", "customvo"}
	self.heavy_swat_sniper.priority_shout = "f34"
	self.heavy_swat_sniper.bot_priority_shout = "f34x_any"
	self.heavy_swat_sniper.priority_shout_max_dis = 3000
	self.heavy_swat_sniper.HEALTH_INIT = 27
	self.heavy_swat_sniper.headshot_dmg_mul = normal_headshot
	self.heavy_swat_sniper.surrender_break_time = {6, 10}
	self.heavy_swat_sniper.suppression = nil
	self.heavy_swat_sniper.surrender = nil
	self.heavy_swat_sniper.no_arrest = true
	self.heavy_swat_sniper.ecm_vulnerability = 1
	self.heavy_swat_sniper.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.heavy_swat_sniper.experience.cable_tie = "tie_swat"
	self.heavy_swat_sniper.speech_prefix_p1 = "fug"
	self.heavy_swat_sniper.speech_prefix_p2 = nil
	self.heavy_swat_sniper.speech_prefix_count = 1
	self.heavy_swat_sniper.access = "swat"
	self.heavy_swat_sniper.damage.hurt_severity = presets.hurt_severities.elite
	self.heavy_swat_sniper.use_animation_on_fire_damage = false
	self.heavy_swat_sniper.move_speed = presets.move_speed.normal
	self.heavy_swat_sniper.dodge = presets.dodge.elite
	self.heavy_swat_sniper.chatter = presets.enemy_chatter.swat
	self.heavy_swat_sniper.melee_weapon = "fists"
	self.heavy_swat_sniper.steal_loot = nil
	self.heavy_swat_sniper.has_alarm_pager = false
	self.heavy_swat_sniper.calls_in = true
	self.heavy_swat_sniper.static_weapon_preset = true
	self.heavy_swat_sniper.static_dodge_preset = true
	self.heavy_swat_sniper.static_melee_preset = true	
	self.heavy_swat_sniper.custom_voicework = nil
	self.heavy_swat_sniper.die_sound_event = "mga_death_scream"
	if is_reaper or is_federales then
		self.heavy_swat_sniper.custom_voicework = "tswat_ru"
	else
		self.heavy_swat_sniper.custom_voicework = "tsniper_real"
	end		
	self.heavy_swat_sniper.is_special = true
	self.heavy_swat_sniper.heal_cooldown = 5
	table.insert(self._enemy_list, "heavy_swat_sniper")
	
	--Weekend Snipers
	self.weekend_dmr = deep_clone(self.heavy_swat_sniper)
	self.weekend_dmr.speech_prefix_p1 = "cum"
	self.weekend_dmr.speech_prefix_p2 = nil
	self.weekend_dmr.speech_prefix_count = nil
	if is_reaper then
		self.weekend_dmr.custom_voicework = "tswat_ru"
	elseif is_murky then
		self.weekend_dmr.custom_voicework = "bravo_murky"	
	elseif is_federales then
		self.weekend_dmr.custom_voicework = "bravo_mex"
	else
		self.weekend_dmr.custom_voicework = "bravo_elite"
	end	
	self.weekend_dmr.HEALTH_INIT = 40.5
	self.weekend_dmr.headshot_dmg_mul = bravo_headshot 
	self.weekend_dmr.damage.explosion_damage_mul = 1.5
	self.weekend_dmr.damage.fire_pool_damage_mul = 1.5
	self.weekend_dmr.heal_cooldown = 5
	self.weekend_dmr.grenade = frag
	table.insert(self._enemy_list, "weekend_dmr")
end

function CharacterTweakData:_init_fbi_swat(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.fbi_swat = deep_clone(presets.base)
	self.fbi_swat.tags = {"law"}
	self.fbi_swat.experience = {}
	self.fbi_swat.weapon = presets.weapon.expert
	self.fbi_swat.detection = presets.detection.normal
	self.fbi_swat.HEALTH_INIT = 32.4
	self.fbi_swat.headshot_dmg_mul = normal_headshot
	self.fbi_swat.move_speed = presets.move_speed.very_fast
	self.fbi_swat.surrender_break_time = {6, 10}
	self.fbi_swat.suppression = presets.suppression.hard_def
	self.fbi_swat.surrender = presets.surrender.hard
	self.fbi_swat.ecm_vulnerability = 1
	self.fbi_swat.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.fbi_swat.weapon_voice = "2"
	self.fbi_swat.experience.cable_tie = "tie_swat"
	self.fbi_swat.speech_prefix_p1 = self._prefix_data_p1.swat()
	self.fbi_swat.speech_prefix_p2 = self._speech_prefix_p2
	self.fbi_swat.speech_prefix_count = 4
	self.fbi_swat.access = "swat"
	self.fbi_swat.dodge = presets.dodge.athletic_very_hard
	self.fbi_swat.no_arrest = false
	self.fbi_swat.chatter = presets.enemy_chatter.swat
	self.fbi_swat.melee_weapon = "knife_1"
	if job == "chill_combat" then
		self.fbi_swat.steal_loot = nil
	else
		self.fbi_swat.steal_loot = true
	end
	self.fbi_swat.static_weapon_preset = true
	self.fbi_swat.static_dodge_preset = true
	self.fbi_swat.static_melee_preset = true
	self.fbi_swat.heal_cooldown = true
	table.insert(self._enemy_list, "fbi_swat")
	
	self.fbi_swat_vet = deep_clone(self.fbi_swat)
	table.insert(self._enemy_list, "fbi_swat_vet")
end

function CharacterTweakData:_init_fbi_heavy_swat(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.fbi_heavy_swat = deep_clone(presets.base)
	self.fbi_heavy_swat.tags = {"law"}
	self.fbi_heavy_swat.experience = {}
	self.fbi_heavy_swat.weapon = presets.weapon.normal
	self.fbi_heavy_swat.detection = presets.detection.normal
	self.fbi_heavy_swat.HEALTH_INIT = 50.4
	self.fbi_heavy_swat.headshot_dmg_mul = normal_headshot
	self.fbi_heavy_swat.move_speed = presets.move_speed.fast
	self.fbi_heavy_swat.surrender_break_time = {6, 8}
	self.fbi_heavy_swat.suppression = presets.suppression.hard_agg
	self.fbi_heavy_swat.surrender = presets.surrender.hard
	self.fbi_heavy_swat.damage.hurt_severity = presets.hurt_severities.heavy
	self.fbi_heavy_swat.ecm_vulnerability = 1
	self.fbi_heavy_swat.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.fbi_heavy_swat.weapon_voice = "2"
	self.fbi_heavy_swat.experience.cable_tie = "tie_swat"
	self.fbi_heavy_swat.speech_prefix_p1 = self._prefix_data_p1.heavy_swat()
	self.fbi_heavy_swat.speech_prefix_p2 = self._speech_prefix_p2
	self.fbi_heavy_swat.speech_prefix_count = 4
	self.fbi_heavy_swat.access = "swat"
	self.fbi_heavy_swat.dodge = presets.dodge.heavy_very_hard
	self.fbi_heavy_swat.no_arrest = false
	self.fbi_heavy_swat.melee_weapon = "knife_1"
	self.fbi_heavy_swat.chatter = presets.enemy_chatter.swat
	if job == "chill_combat" then
		self.fbi_heavy_swat.steal_loot = nil
	else
		self.fbi_heavy_swat.steal_loot = true
	end
	self.fbi_heavy_swat.static_weapon_preset = true
	self.fbi_heavy_swat.static_dodge_preset = true
	self.fbi_heavy_swat.static_melee_preset = true	
	self.fbi_heavy_swat.heal_cooldown = true
	table.insert(self._enemy_list, "fbi_heavy_swat")
end

function CharacterTweakData:_init_city_swat(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.city_swat = deep_clone(presets.base)
	self.city_swat.tags = {"law", "city_swat"}
	self.city_swat.experience = {}
	self.city_swat.weapon = presets.weapon.expert
	self.city_swat.detection = presets.detection.normal
	self.city_swat.HEALTH_INIT = 32.4
	self.city_swat.headshot_dmg_mul = normal_headshot
	self.city_swat.move_speed = presets.move_speed.very_fast
	self.city_swat.surrender_break_time = {6, 10}
	self.city_swat.suppression = presets.suppression.hard_def
	self.city_swat.surrender = presets.surrender.hard
	self.city_swat.no_arrest = false
	self.city_swat.ecm_vulnerability = 1
	self.city_swat.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.city_swat.weapon_voice = "2"
	self.city_swat.experience.cable_tie = "tie_swat"
	self.city_swat.silent_priority_shout = "f37"
	self.city_swat.speech_prefix_p1 = self._prefix_data_p1.swat()
	self.city_swat.speech_prefix_p2 = self._speech_prefix_p2
	self.city_swat.speech_prefix_count = 4
	self.city_swat.access = "swat"
	self.city_swat.dodge = presets.dodge.athletic_overkill
	self.city_swat.chatter = presets.enemy_chatter.swat
	self.city_swat.melee_weapon = "knife_1"
	if job == "chill_combat" then
		self.city_swat.steal_loot = nil
	else
		self.city_swat.steal_loot = true
	end
	if job == "kosugi" or job == "dark" then
		self.city_swat.shooting_death = false
		self.city_swat.radio_prefix = "fri_"
		self.city_swat.use_radio = "dsp_radio_russian"
	else
		self.city_swat.shooting_death = true
	end	
	self.city_swat.has_alarm_pager = true
	self.city_swat.calls_in = true
	self.city_swat.static_weapon_preset = true
	self.city_swat.static_dodge_preset = true
	self.city_swat.static_melee_preset = true	
	self.city_swat.custom_voicework = nil
	self.city_swat.heal_cooldown = true
	table.insert(self._enemy_list, "city_swat")
	
	--Guard variant, different entry type as a failsafe
	self.city_swat_guard = deep_clone(self.city_swat)
	self.city_swat_guard.weapon = presets.weapon.good
	self.city_swat_guard.HEALTH_INIT = 24
	self.city_swat_guard.headshot_dmg_mul = strong_headshot
	self.city_swat_guard.access = "security"
	self.city_swat_guard.chatter = presets.enemy_chatter.guard
	self.city_swat_guard.melee_weapon = "baton"
	self.city_swat_guard.use_radio = nil
	table.insert(self._enemy_list, "city_swat_guard")
			
	--Weekend
	self.weekend = deep_clone(self.city_swat)
	if is_reaper then
		self.weekend.custom_voicework = "tswat_ru"
	elseif is_murky then
		self.weekend.custom_voicework = "bravo_murky"	
	elseif is_federales then
		self.weekend.custom_voicework = "bravo_mex"
	else
		self.weekend.custom_voicework = "bravo"
	end	
	self.weekend.HEALTH_INIT = 48.6
	self.weekend.dodge = self.presets.dodge.athletic_very_hard
	self.weekend.damage.explosion_damage_mul = 1.5
	self.weekend.damage.fire_pool_damage_mul = 1.5
	self.weekend.headshot_dmg_mul = bravo_headshot		
	self.weekend.speech_prefix_p1 = "cum"
	self.weekend.speech_prefix_p2 = nil
	self.weekend.speech_prefix_count = nil	
	self.weekend.heal_cooldown = true
	self.weekend.grenade = frag
	self.weekend.surrender = presets.surrender.bravo
	table.insert(self._enemy_list, "weekend")				
	
	self.city_swat_titan = deep_clone(self.city_swat)
	self.city_swat_titan.can_slide_on_suppress = true
	self.city_swat_titan.speech_prefix_p1 = "are you team cum pisser"
	self.city_swat_titan.speech_prefix_p2 = "or team poop shitter"
	self.city_swat_titan.speech_prefix_count = nil		
	if is_reaper or is_federales then
		self.city_swat_titan.custom_voicework = "tswat_ru"
	else
		self.city_swat_titan.custom_voicework = "pdth"
	end				
	self.city_swat_titan.HEALTH_INIT = 42
	self.city_swat_titan.headshot_dmg_mul = normal_headshot
	self.city_swat_titan.weapon = presets.weapon.good
	self.city_swat_titan.damage.hurt_severity = presets.hurt_severities.elite_easy
	self.city_swat_titan.damage.explosion_damage_mul = 0.5
	self.city_swat_titan.use_animation_on_fire_damage = true
	self.city_swat_titan.move_speed = presets.move_speed.fast
	self.city_swat_titan.dodge = presets.dodge.elite
	self.city_swat_titan.static_weapon_preset = true
	self.city_swat_titan.static_dodge_preset = true
	self.city_swat_titan.static_melee_preset = true	
	self.city_swat_titan.heal_cooldown = true
	table.insert(self._enemy_list, "city_swat_titan")
	
	self.city_swat_titan_assault = deep_clone(self.city_swat_titan)
	table.insert(self._enemy_list, "city_swat_titan_assault")
	
	self.skeleton_swat_titan = deep_clone(self.city_swat_titan)
	self.skeleton_swat_titan.custom_voicework = "skeleton"
	table.insert(self._enemy_list, "skeleton_swat_titan")	
	
	--Weekend LMG
	self.weekend_lmg = deep_clone(self.city_swat_titan)		
	if is_reaper then
		self.weekend_lmg.custom_voicework = "tswat_ru"
	elseif is_murky then
		self.weekend_lmg.custom_voicework = "bravo_murky"	
	elseif is_federales then
		self.weekend_lmg.custom_voicework = "bravo_mex"
	else
		self.weekend_lmg.custom_voicework = "bravo_elite"
	end		
	self.weekend_lmg.speech_prefix_p1 = "cum"
	self.weekend_lmg.speech_prefix_p2 = nil
	self.weekend_lmg.speech_prefix_count = nil
	self.weekend_lmg.HEALTH_INIT = 63
	self.weekend_lmg.weapon = presets.weapon.expert
	self.weekend_lmg.headshot_dmg_mul = bravo_headshot
	self.weekend_lmg.damage.explosion_damage_mul = 0.75
	self.weekend_lmg.damage.fire_pool_damage_mul = 1.5	
	self.weekend_lmg.heal_cooldown = true
	self.weekend_lmg.grenade = frag
	table.insert(self._enemy_list, "weekend_lmg")

	--Temp Solution
	if job == "haunted" then
		self.city_swat = deep_clone(self.skeleton_swat_titan)
	end
end

function CharacterTweakData:_init_sniper(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.sniper = deep_clone(presets.base)
	self.sniper.tags = {"law", "sniper", "special"}
	self.sniper.experience = {}
	self.sniper.weapon = presets.weapon.sniper
	self.sniper.detection = presets.detection.sniper
	self.sniper.HEALTH_INIT = 6
	self.sniper.headshot_dmg_mul = normal_headshot
	self.sniper.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.sniper.allowed_poses = {stand = true}
	self.sniper.move_speed = presets.move_speed.very_fast
	self.sniper.shooting_death = false
	self.sniper.no_move_and_shoot = true
	self.sniper.move_and_shoot_cooldown = 1
	self.sniper.suppression = nil
	self.sniper.melee_weapon = nil
	self.sniper.ecm_vulnerability = 1
	self.sniper.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.sniper.weapon_voice = "1"
	self.sniper.experience.cable_tie = "tie_swat"
	self.sniper.speech_prefix_p1 = self._prefix_data_p1.swat()
	self.sniper.speech_prefix_p2 = "n"
	self.sniper.speech_prefix_count = 4
	self.sniper.priority_shout = "f34"
	self.sniper.bot_priority_shout = "f34x_any"
	self.sniper.priority_shout_max_dis = 3000
	self.sniper.access = "sniper"
	self.sniper.no_retreat = true
	self.sniper.no_limping = true
	self.sniper.no_arrest = true
	self.sniper.chatter = presets.enemy_chatter.no_chatter
	self.sniper.steal_loot = nil
	self.sniper.rescue_hostages = false
	self.sniper.static_weapon_preset = true
	self.sniper.static_dodge_preset = true
	self.sniper.crouch_move = nil
	self.sniper.is_special = true
	self.sniper.die_sound_event = "mga_death_scream"
	self.sniper.spawn_sound_event = "mga_deploy_snipers"
	self.sniper.do_not_drop_ammo = true
	table.insert(self._enemy_list, "sniper")
end

function CharacterTweakData:_init_gangster(presets)
	self.gangster = deep_clone(presets.base)
	self.gangster.experience = {}
	self.gangster.weapon = presets.weapon.gangster
	self.gangster.detection = presets.detection.normal
	self.gangster.HEALTH_INIT = 10.8
	self.gangster.headshot_dmg_mul = normal_headshot
	self.gangster.damage.melee_damage_mul = 0.5
	self.gangster.move_speed = presets.move_speed.normal
	self.gangster.suspicious = nil
	self.gangster.suppression = presets.suppression.easy
	self.gangster.surrender = nil
	self.gangster.ecm_vulnerability = 1
	self.gangster.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.gangster.no_arrest = true
	self.gangster.no_retreat = true
	self.gangster.weapon_voice = "3"
	self.gangster.experience.cable_tie = "tie_swat"
	self.gangster.rescue_hostages = false
	self.gangster.use_radio = nil		
	if job == "nightclub" or job == "short2_stage1" or job == "jolly" or job == "spa" then
		self.gangster.speech_prefix_p1 = "rt"
		self.gangster.speech_prefix_p2 = nil
		self.gangster.speech_prefix_count = 2
	elseif job == "alex_2" or job == "alex_2_res" or job == "welcome_to_the_jungle_1" then
		self.gangster.speech_prefix_p1 = "ict"
		self.gangster.speech_prefix_p2 = nil
		self.gangster.speech_prefix_count = 2
	elseif job == "man" then	
		self.gangster.speech_prefix_p1 = self._prefix_data_p1.cop()
		self.gangster.speech_prefix_p2 = "n"
		self.gangster.speech_prefix_count = 4	
		self.gangster.no_arrest = false
		self.gangster.rescue_hostages = true
		self.gangster.use_radio = self._default_chatter				
	else
		self.gangster.speech_prefix_p1 = "lt"
		self.gangster.speech_prefix_p2 = nil
		self.gangster.speech_prefix_count = 2
	end
	self.gangster.chatter = {
		aggressive = true,
		retreat = true,
		contact = true,
		go_go = true,
		suppress = true
	}
	self.gangster.silent_priority_shout = "f37"
	if job == "alex_3" or job == "alex_3_res" or job == "mex" then
		self.gangster.access = "security"
	else
		self.gangster.access = "gangster"
	end
	self.gangster.dodge = presets.dodge.average
	self.gangster.challenges = {type = "gangster"}
	self.gangster.melee_weapon = "fists"
	self.gangster.steal_loot = nil
	self.gangster.calls_in = true
	self.gangster.static_dodge_preset = true
	self.gangster.unintimidateable = true
	self.gangster.always_drop = true
	self.gangster.heal_cooldown = 2
	table.insert(self._enemy_list, "gangster")
end

function CharacterTweakData:_init_biker(presets)
	self.biker = deep_clone(self.gangster)
	if job == "mex" then
		self.biker.access = "security"
	else
		self.biker.access = "gangster"
	end
	self.biker.calls_in = true
	self.biker.speech_prefix_p1 = "bik"
	self.biker.speech_prefix_p2 = nil
	self.biker.speech_prefix_count = 2	
	self.biker.chatter = {
		aggressive = true,
		retreat = true,
		contact = true,
		go_go = true,
		suppress = true
	}
	self.biker.static_dodge_preset = true
	self.biker.always_drop = true
	self.biker.heal_cooldown = 2
	self.biker.melee_weapon = "knife_1"
	table.insert(self._enemy_list, "biker")
	self.biker_guard = deep_clone(self.biker)
	self.biker_guard.suppression = presets.suppression.hard_def
	self.biker_guard.has_alarm_pager = true
	self.biker_guard.radio_prefix = "fri_"
	self.biker_guard.surrender = presets.surrender.hard
	self.biker_guard.surrender_break_time = {20, 30}
	self.biker_guard.detection = presets.detection.guard
	self.biker_guard.move_speed = presets.move_speed.very_fast
	self.biker_guard.ecm_vulnerability = 1
	self.biker_guard.no_arrest = false
	self.biker_guard.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.biker_guard.speech_prefix_p1 = "bik"
	self.biker_guard.speech_prefix_p2 = nil
	self.biker_guard.speech_prefix_count = 2
	self.biker_guard.chatter = {
		aggressive = true,
		retreat = true,
		contact = true,
		go_go = true,
		suppress = true
	}
	self.biker_guard.static_dodge_preset = false
	self.biker_guard.heal_cooldown = 2
	table.insert(self._enemy_list, "biker_guard")
end

function CharacterTweakData:_init_triad(presets)
	self.triad = deep_clone(self.gangster)
	self.triad.access = "gangster"
	self.triad.calls_in = true
	self.triad.die_sound_event = "l2n_x01a_any_3p"

	table.insert(self._enemy_list, "triad")
end

function CharacterTweakData:_init_captain(presets)
	self.captain = deep_clone(self.gangster)
	self.captain.calls_in = true
	self.captain.no_limping = true
	self.captain.immune_to_knock_down = true
	self.captain.immune_to_concussion = true
	self.captain.no_retreat = true
	self.captain.no_arrest = true
	self.captain.surrender = nil
	self.captain.unintimidateable = true
	self.captain.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.captain.flammable = false
	self.captain.can_be_tased = false
	self.captain.suppression = nil

	table.insert(self._enemy_list, "captain")
end

function CharacterTweakData:_init_biker_escape(presets)
	self.biker_escape = deep_clone(self.gangster)
	self.biker_escape.melee_weapon = "knife_1"
	self.biker_escape.move_speed = presets.move_speed.very_fast
	self.biker_escape.suppression = nil
	table.insert(self._enemy_list, "biker_escape")
end

function CharacterTweakData:_init_mobster(presets)
	self.mobster = deep_clone(self.gangster)
	self.mobster.calls_in = true
	self.mobster.melee_weapon = "fists"
	self.mobster.speech_prefix_p1 = "rt"
	self.mobster.speech_prefix_p2 = nil
	self.mobster.speech_prefix_count = 2
	self.mobster.chatter = {
		aggressive = true,
		retreat = true,
		contact = true,
		go_go = true,
		suppress = true
	}
	self.mobster.static_dodge_preset = true
	self.mobster.always_drop = true
	self.mobster.heal_cooldown = 2
	table.insert(self._enemy_list, "mobster")
end

function CharacterTweakData:_init_mobster_boss(presets)
	self.mobster_boss = deep_clone(presets.base)
	self.mobster_boss.tags = {"custom", "special"}
	self.mobster_boss.experience = {}
	self.mobster_boss.detection = presets.detection.normal
	self.mobster_boss.weapon = presets.weapon.gangster
	self.mobster_boss.HEALTH_INIT = 864
	self.mobster_boss.headshot_dmg_mul = strong_headshot
	self.mobster_boss.damage.hurt_severity = presets.hurt_severities.boss
	self.mobster_boss.damage.explosion_damage_mul = 2
	self.mobster_boss.move_speed = presets.move_speed.slow
	self.mobster_boss.allowed_poses = {stand = true}
	self.mobster_boss.crouch_move = false
	self.mobster_boss.no_run_start = true
	self.mobster_boss.no_run_stop = true
	self.mobster_boss.no_retreat = true
	self.mobster_boss.no_limping = true
	self.mobster_boss.no_arrest = true
	self.mobster_boss.surrender = nil
	self.mobster_boss.ecm_vulnerability = 0
	self.mobster_boss.ecm_hurts = {}
	self.mobster_boss.weapon_voice = "3"
	self.mobster_boss.experience.cable_tie = "tie_swat"
	self.mobster_boss.access = "gangster"
	self.mobster_boss.speech_prefix_p1 = "l"
	self.mobster_boss.speech_prefix_p2 = "n"
	self.mobster_boss.speech_prefix_count = 4
	self.mobster_boss.rescue_hostages = false
	self.mobster_boss.melee_weapon = "fists_dozer"
	self.mobster_boss.steal_loot = nil
	self.mobster_boss.calls_in = nil
	self.mobster_boss.chatter = presets.enemy_chatter.no_chatter
	self.mobster_boss.use_radio = nil
	self.mobster_boss.can_be_tased = false
	self.mobster_boss.priority_shout = "g29"
	self.mobster_boss.bot_priority_shout = "g29"
	self.mobster_boss.silent_priority_shout = nil
	self.mobster_boss.custom_shout = true
	self.mobster_boss.priority_shout_max_dis = 3000
	self.mobster_boss.use_animation_on_fire_damage = false
	self.mobster_boss.flammable = true
	self.mobster_boss.immune_to_knock_down = true
	self.mobster_boss.immune_to_concussion = true
	self.mobster_boss.must_headshot = true
	self.mobster_boss.static_dodge_preset = true
	self.mobster_boss.is_special = true
	self.mobster_boss.always_drop = true
	self.mobster_boss.heal_cooldown = 45
	self.mobster_boss.die_sound_event = "l1n_burndeath"
	table.insert(self._enemy_list, "mobster_boss")
end

function CharacterTweakData:_init_biker_boss(presets)
	self.biker_boss = deep_clone(presets.base)
	self.biker_boss.tags = {"custom", "special"}
	self.biker_boss.experience = {}
	self.biker_boss.weapon = presets.weapon.gangster
	self.biker_boss.detection = presets.detection.normal
	self.biker_boss.HEALTH_INIT = 864
	self.biker_boss.headshot_dmg_mul = strong_headshot
	self.biker_boss.damage.hurt_severity = presets.hurt_severities.boss
	self.biker_boss.damage.explosion_damage_mul = 2
	self.biker_boss.move_speed = presets.move_speed.very_slow
	self.biker_boss.allowed_poses = {stand = true}
	self.biker_boss.no_retreat = true
	self.biker_boss.no_limping = true
	self.biker_boss.no_run_start = true
	self.biker_boss.no_run_stop = true	
	self.biker_boss.no_arrest = true
	self.biker_boss.surrender = nil
	self.biker_boss.ecm_vulnerability = 0
	self.biker_boss.ecm_hurts = {}
	self.biker_boss.weapon_voice = "3"
	self.biker_boss.experience.cable_tie = "tie_swat"
	self.biker_boss.access = "gangster"
	self.biker_boss.speech_prefix_p1 = "bb"
	self.biker_boss.speech_prefix_p2 = "n"
	self.biker_boss.speech_prefix_count = 1
	self.biker_boss.rescue_hostages = false
	self.biker_boss.melee_weapon = "fists_dozer"
	self.biker_boss.steal_loot = nil
	self.biker_boss.calls_in = nil
	self.biker_boss.chatter = presets.enemy_chatter.no_chatter
	self.biker_boss.use_radio = nil
	self.biker_boss.use_animation_on_fire_damage = false
	self.biker_boss.flammable = true
	self.biker_boss.can_be_tased = false
	self.biker_boss.immune_to_knock_down = true
	self.biker_boss.priority_shout = "g29"
	self.biker_boss.bot_priority_shout = "g29"
	self.biker_boss.silent_priority_shout = nil
	self.biker_boss.custom_shout = true
	self.biker_boss.priority_shout_max_dis = 3000
	self.biker_boss.immune_to_concussion = true
	self.biker_boss.must_headshot = true
	self.biker_boss.static_dodge_preset = true
	self.biker_boss.always_drop = true
	self.biker_boss.is_special = true
	self.biker_boss.heal_cooldown = 45
	self.biker_boss.die_sound_event = "f1n_x01a_any_3p"
	table.insert(self._enemy_list, "biker_boss")
end

function CharacterTweakData:_init_hector_boss(presets)
	self.hector_boss = deep_clone(self.mobster_boss)
	self.hector_boss.tags = {"custom", "special"}
	self.hector_boss.weapon = presets.weapon.good
	self.hector_boss.can_be_tased = false
	self.hector_boss.priority_shout = "g29"
	self.hector_boss.bot_priority_shout = "g29"
	self.hector_boss.silent_priority_shout = nil
	self.hector_boss.custom_shout = true
	self.hector_boss.priority_shout_max_dis = 3000
	self.hector_boss.is_special = true
	self.hector_boss.always_drop = true
	self.hector_boss.heal_cooldown = 45
	self.hector_boss.die_sound_event = "l1n_burndeath"
	table.insert(self._enemy_list, "hector_boss")
end

function CharacterTweakData:_init_hector_boss_no_armor(presets)
	self.hector_boss_no_armor = deep_clone(self.fbi)
	self.hector_boss_no_armor.no_retreat = true
	self.hector_boss_no_armor.no_limping = true
	self.hector_boss_no_armor.no_arrest = true
	self.hector_boss_no_armor.surrender = nil
	self.hector_boss_no_armor.unintimidateable = true
	self.hector_boss_no_armor.access = "gangster"
	self.hector_boss_no_armor.rescue_hostages = false
	self.hector_boss_no_armor.steal_loot = nil
	self.hector_boss_no_armor.calls_in = nil
	self.hector_boss_no_armor.chatter = presets.enemy_chatter.no_chatter
	self.hector_boss_no_armor.use_radio = nil
	self.hector_boss_no_armor.can_be_tased = true
	self.hector_boss_no_armor.always_drop = true
	self.hector_boss_no_armor.heal_cooldown = 2
	table.insert(self._enemy_list, "hector_boss_no_armor")
end

function CharacterTweakData:_init_chavez_boss(presets)
	self.chavez_boss = deep_clone(presets.base)
	self.chavez_boss.experience = {}
	self.chavez_boss.tags = {"custom", "special"}
	self.chavez_boss.weapon = presets.weapon.gangster
	self.chavez_boss.detection = presets.detection.normal
	self.chavez_boss.priority_shout = "g29"
	self.chavez_boss.bot_priority_shout = "g29"
	self.chavez_boss.silent_priority_shout = nil
	self.chavez_boss.custom_shout = true
	self.chavez_boss.priority_shout_max_dis = 3000
	self.chavez_boss.damage.hurt_severity = presets.hurt_severities.boss
	self.chavez_boss.HEALTH_INIT = 864
	self.chavez_boss.headshot_dmg_mul = strong_headshot
	self.chavez_boss.damage.hurt_severity = presets.hurt_severities.boss
	self.chavez_boss.damage.explosion_damage_mul = 2
	self.chavez_boss.move_speed = presets.move_speed.very_slow
	self.chavez_boss.allowed_poses = {stand = true}
	self.chavez_boss.no_retreat = true
	self.chavez_boss.no_limping = true
	self.chavez_boss.no_arrest = true
	self.chavez_boss.no_run_start = true
	self.chavez_boss.no_run_stop = true		
	self.chavez_boss.surrender = nil
	self.chavez_boss.ecm_vulnerability = 0
	self.chavez_boss.ecm_hurts = {}
	self.chavez_boss.weapon_voice = "1"
	self.chavez_boss.experience.cable_tie = "tie_swat"
	self.chavez_boss.access = "gangster"
	self.chavez_boss.speech_prefix_p1 = "bb"
	self.chavez_boss.speech_prefix_p2 = "n"
	self.chavez_boss.speech_prefix_count = 1
	self.chavez_boss.rescue_hostages = false
	self.chavez_boss.melee_weapon = "fists_dozer"
	self.chavez_boss.steal_loot = nil
	self.chavez_boss.calls_in = nil
	self.chavez_boss.chatter = presets.enemy_chatter.no_chatter
	self.chavez_boss.use_radio = nil
	self.chavez_boss.can_be_tased = false
	self.chavez_boss.use_animation_on_fire_damage = false
	self.chavez_boss.flammable = true
	self.chavez_boss.can_be_tased = false
	self.chavez_boss.immune_to_knock_down = true
	self.chavez_boss.immune_to_concussion = true
	self.chavez_boss.must_headshot = true
	self.chavez_boss.static_dodge_preset = true
	self.chavez_boss.is_special = true
	self.chavez_boss.always_drop = true
	self.chavez_boss.heal_cooldown = 45
	self.chavez_boss.die_sound_event = "l1n_burndeath"
	table.insert(self._enemy_list, "chavez_boss")
end

function CharacterTweakData:_init_bolivians(presets)
	self.bolivian = deep_clone(self.gangster)
	self.bolivian.detection = presets.detection.normal
	self.bolivian.access = "security"
	self.bolivian.radio_prefix = "fri_"
	self.bolivian.suspicious = true
	self.bolivian.crouch_move = nil
	self.bolivian.no_arrest = true
	self.bolivian.speech_prefix_p1 = "lt"
	self.bolivian.speech_prefix_p2 = nil
	self.bolivian.speech_prefix_count = 2
	self.bolivian.chatter = {
		aggressive = true,
		retreat = true,
		contact = true,
		go_go = true,
		suppress = true
	}
	self.bolivian.static_dodge_preset = true
	self.bolivian.always_drop = true
	self.bolivian.heal_cooldown = 2
	table.insert(self._enemy_list, "bolivian")
	
	self.bolivian_indoors = deep_clone(self.bolivian)
	self.bolivian_indoors.suppression = presets.suppression.hard
	self.bolivian_indoors.has_alarm_pager = true
	self.bolivian_indoors.surrender = presets.surrender.easy
	self.bolivian_indoors.surrender_break_time = {20, 30}
	self.bolivian_indoors.detection = presets.detection.guard
	self.bolivian_indoors.move_speed = presets.move_speed.very_fast
	self.bolivian_indoors.ecm_vulnerability = 1
	self.bolivian_indoors.no_arrest = false
	self.bolivian_indoors.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.bolivian_indoors.speech_prefix_p1 = "lt"
	self.bolivian_indoors.speech_prefix_p2 = nil
	self.bolivian_indoors.speech_prefix_count = 2
	self.bolivian_indoors.chatter = {
		aggressive = true,
		retreat = true,
		contact = true,
		go_go = true,
		suppress = true
	}
	self.bolivian_indoors.static_dodge_preset = false
	self.bolivian_indoors.unintimidateable = false
	table.insert(self._enemy_list, "bolivian_indoors")
	
	self.bolivian_indoors_mex = deep_clone(self.bolivian_indoors)
	self.bolivian_indoors_mex.has_alarm_pager = true
	if job == "mex" then
		self.bolivian_indoors_mex.access = "security"
	else
		self.bolivian_indoors_mex.access = "gangster"
	end				

	table.insert(self._enemy_list, "bolivian_indoors_mex")		
end

function CharacterTweakData:_init_drug_lord_boss(presets)
	self.drug_lord_boss = deep_clone(presets.base)
	self.drug_lord_boss.experience = {}
	self.drug_lord_boss.tags = {"custom", "special"}
	self.drug_lord_boss.grenade = frag
	self.drug_lord_boss.weapon = presets.weapon.gangster
	self.drug_lord_boss.detection = presets.detection.normal
	self.drug_lord_boss.HEALTH_INIT = 864
	self.drug_lord_boss.headshot_dmg_mul = strong_headshot
	self.drug_lord_boss.damage.hurt_severity = presets.hurt_severities.boss
	self.drug_lord_boss.damage.explosion_damage_mul = 2
	self.drug_lord_boss.move_speed = presets.move_speed.very_slow
	self.drug_lord_boss.allowed_poses = {stand = true}
	self.drug_lord_boss.crouch_move = false
	self.drug_lord_boss.no_run_start = true
	self.drug_lord_boss.no_run_stop = true
	self.drug_lord_boss.no_retreat = true
	self.drug_lord_boss.no_limping = true
	self.drug_lord_boss.no_arrest = true
	self.drug_lord_boss.surrender = nil
	self.drug_lord_boss.ecm_vulnerability = 0
	self.drug_lord_boss.ecm_hurts = {}
	self.drug_lord_boss.weapon_voice = "3"
	self.drug_lord_boss.experience.cable_tie = "tie_swat"
	self.drug_lord_boss.access = "gangster"
	self.drug_lord_boss.speech_prefix_p1 = "bb"
	self.drug_lord_boss.speech_prefix_p2 = "n"
	self.drug_lord_boss.speech_prefix_count = 1
	self.drug_lord_boss.rescue_hostages = false
	self.drug_lord_boss.silent_priority_shout = "f37"
	self.drug_lord_boss.melee_weapon = "fists_dozer"
	self.drug_lord_boss.steal_loot = nil
	self.drug_lord_boss.calls_in = nil
	self.drug_lord_boss.chatter = presets.enemy_chatter.no_chatter
	self.drug_lord_boss.use_radio = nil
	self.drug_lord_boss.can_be_tased = false
	self.drug_lord_boss.use_animation_on_fire_damage = false
	self.drug_lord_boss.flammable = true
	self.drug_lord_boss.can_be_tased = false
	self.drug_lord_boss.immune_to_knock_down = true
	self.drug_lord_boss.immune_to_concussion = true
	self.drug_lord_boss.priority_shout = "g29"
	self.drug_lord_boss.bot_priority_shout = "g29"
	self.drug_lord_boss.custom_shout = true
	self.drug_lord_boss.priority_shout_max_dis = 3000
	self.drug_lord_boss.must_headshot = true
	self.drug_lord_boss.static_dodge_preset = true
	self.drug_lord_boss.is_special = true
	self.drug_lord_boss.always_drop = true
	self.drug_lord_boss.heal_cooldown = 45
	self.drug_lord_boss.die_sound_event = "l1n_burndeath"
	table.insert(self._enemy_list, "drug_lord_boss")
end

function CharacterTweakData:_init_drug_lord_boss_stealth(presets)
	self.drug_lord_boss_stealth = deep_clone(presets.base)
	self.drug_lord_boss_stealth.experience = {}
	self.drug_lord_boss_stealth.weapon = presets.weapon.gangster
	self.drug_lord_boss_stealth.detection = presets.detection.normal
	self.drug_lord_boss_stealth.HEALTH_INIT = 24
	self.drug_lord_boss_stealth.headshot_dmg_mul = strong_headshot
	self.drug_lord_boss_stealth.move_speed = presets.move_speed.very_fast
	self.drug_lord_boss_stealth.no_retreat = true
	self.drug_lord_boss_stealth.no_limping = true
	self.drug_lord_boss_stealth.no_arrest = true
	self.drug_lord_boss_stealth.surrender = nil
	self.drug_lord_boss_stealth.unintimidateable = true
	self.drug_lord_boss_stealth.ecm_vulnerability = 0
	self.drug_lord_boss_stealth.ecm_hurts = {
		ears = {min_duration = 0, max_duration = 0}
	}
	self.drug_lord_boss_stealth.weapon_voice = "3"
	self.drug_lord_boss_stealth.experience.cable_tie = "tie_swat"
	self.drug_lord_boss_stealth.access = "gangster"
	self.drug_lord_boss_stealth.speech_prefix_p1 = "bb"
	self.drug_lord_boss_stealth.speech_prefix_p2 = "n"
	self.drug_lord_boss_stealth.speech_prefix_count = 1
	self.drug_lord_boss_stealth.rescue_hostages = false
	self.drug_lord_boss_stealth.silent_priority_shout = "f37"
	self.drug_lord_boss_stealth.melee_weapon = "fists_dozer"
	self.drug_lord_boss_stealth.steal_loot = nil
	self.drug_lord_boss_stealth.calls_in = nil
	self.drug_lord_boss_stealth.chatter = presets.enemy_chatter.no_chatter
	self.drug_lord_boss_stealth.use_radio = nil
	self.drug_lord_boss_stealth.use_animation_on_fire_damage = true
	self.drug_lord_boss_stealth.flammable = true
	self.drug_lord_boss_stealth.can_be_tased = true
	self.drug_lord_boss_stealth.immune_to_knock_down = false
	self.drug_lord_boss_stealth.immune_to_concussion = false
	self.drug_lord_boss_stealth.always_drop = true
	self.drug_lord_boss_stealth.heal_cooldown = 2
	self.drug_lord_boss_stealth.die_sound_event = "l2n_x01a_any_3p"
	table.insert(self._enemy_list, "drug_lord_boss_stealth")
end

function CharacterTweakData:_init_tank(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.tank = deep_clone(presets.base)
	self.tank.tags = {"law", "tank", "special"}
	self.tank.experience = {}
	self.tank.damage.tased_response = {
		light = {tased_time = 1, down_time = 0},
		heavy = {tased_time = 2, down_time = 0}
	}
	self.tank.damage.explosion_damage_mul = 2
	self.tank.weapon = presets.weapon.dozer
	self.tank.detection = presets.detection.normal
	self.tank.HEALTH_INIT = 540
	self.tank.headshot_dmg_mul = strong_headshot
	self.tank.move_speed = presets.move_speed.slow
	self.tank.allowed_stances = {cbt = true}
	self.tank.allowed_poses = {stand = true}
	self.tank.crouch_move = false
	self.tank.no_run_start = true
	self.tank.no_run_stop = true
	self.tank.no_retreat = true
	self.tank.no_limping = true
	self.tank.no_arrest = true
	self.tank.surrender = nil
	self.tank.ecm_vulnerability = 0
	self.tank.ecm_hurts = {}
	if is_federales then
		self.tank.die_sound_event = "bdz_x02a_any_3p"
	else
		self.tank.die_sound_event = nil
	end
	self.tank.weapon_voice = "3"
	self.tank.experience.cable_tie = "tie_swat"
	self.tank.access = "tank"
	self.tank.speech_prefix_p1 = self._prefix_data_p1.bulldozer()
	self.tank.speech_prefix_p2 = nil
	self.tank.speech_prefix_count = nil
	self.tank.spawn_sound_event = self._prefix_data_p1.bulldozer() .. "_entrance"
	self.tank.priority_shout = "f30"
	self.tank.bot_priority_shout = "f30x_any"
	self.tank.priority_shout_max_dis = 3000
	self.tank.rescue_hostages = false
	self.tank.deathguard = true
	self.tank.melee_weapon = "fists_dozer"
	self.tank.damage.hurt_severity = presets.hurt_severities.only_light_hurt_no_explode
	self.tank.chatter = {
		reload = true, --this is just here for tdozers
		aggressive = true,
		retreat = true,
		go_go = true,
		contact = true,
		entrance = true
	}
	self.tank.announce_incomming = "incomming_tank"
	self.tank.steal_loot = nil
	self.tank.calls_in = nil
	self.tank.use_animation_on_fire_damage = false
	self.tank.flammable = true
	self.tank.can_be_tased = false
	self.tank.immune_to_concussion = false
	self.tank.immune_to_knock_down = true
	self.tank.tank_concussion = true
	self.tank.must_headshot = true
	self.tank.static_dodge_preset = true
	self.tank.no_recoil = true
	self.tank.is_special = true
	self.tank.heal_cooldown = 45
	table.insert(self._enemy_list, "tank")
	
	self.tank_medic = deep_clone(self.tank)
	self.tank_medic.is_special = true
	table.insert(self.tank_medic.tags, "medic")
	table.insert(self.tank_medic.tags, "backliner")
	table.insert(self._enemy_list, "tank_medic")
	
	self.tank_titan = deep_clone(self.tank)
	self.tank_titan.weapon = presets.weapon.sniper
	self.tank_titan.tags = {"law", "tank", "special", "tank_titan", "customvo", "no_run", "backliner"}	
	self.tank_titan.move_speed = presets.move_speed.very_slow
	self.tank_titan.damage.hurt_severity = presets.hurt_severities.titan	
	self.tank_titan.HEALTH_INIT = 864
	self.tank_titan.headshot_dmg_mul = strong_headshot
	self.tank_titan.damage.explosion_damage_mul = 2
	self.tank_titan.immune_to_concussion = true
	self.tank_titan.immune_to_knock_down = true
	self.tank_titan.priority_shout_max_dis = 3000
	self.tank_titan.ecm_vulnerability = 0		
	if is_reaper or is_federales then
		self.tank_titan.custom_voicework = "tdozer_ru"
	else
		self.tank_titan.custom_voicework = "tdozer"
	end			
	if is_reaper or is_federales then
		self.tank_titan.spawn_sound_event = "bdz_entrance_elite"
	else
		self.tank_titan.spawn_sound_event = "bdz_entrance_elite"
	end		
	if is_reaper then
		self.tank.speech_prefix_p1 = self._prefix_data_p1.bulldozer()
		self.tank.speech_prefix_p2 = nil
		self.tank.speech_prefix_count = nil
	else
		self.tank_titan.speech_prefix_p1 = "heck"
		self.tank_titan.speech_prefix_count = nil	
	end				
	self.tank_titan.ecm_hurts = {}
	self.tank_titan.is_special = true
	self.tank_titan.heal_cooldown = 45
	table.insert(self._enemy_list, "tank_titan")
	
	self.tank_titan_assault = deep_clone(self.tank_titan)
	self.tank_titan_assault.tags = {"law", "tank", "special", "tank_titan", "no_run", "backliner"}
	table.insert(self._enemy_list, "tank_titan_assault")
	
	self.tank_hw = deep_clone(self.tank_titan_assault)
	self.tank_hw.weapon = presets.weapon.good	
	self.tank_hw.ignore_headshot = false
	self.tank_hw.melee_anims = nil
	self.tank_hw.move_speed = presets.move_speed.very_slow
	table.insert(self._enemy_list, "tank_hw")	
end

function CharacterTweakData:_init_tank_biker(presets)
	self.tank_biker = deep_clone(self.tank)
	self.tank_biker.spawn_sound_event = nil
	self.tank_biker.spawn_sound_event_2 = nil
	self.tank_biker.access = "gangster"
	self.tank_biker.rescue_hostages = false
	self.tank_biker.use_radio = nil
	self.tank_biker.speech_prefix_p1 = "bik"
	self.tank_biker.speech_prefix_p2 = nil
	self.tank_biker.speech_prefix_count = 2	
	self.tank_biker.die_sound_event = "x02_any_3p"	
	self.tank_biker.die_sound_event_2 = "l1n_burndeath"	
	self.tank_biker.chatter = presets.enemy_chatter.swat
end

function CharacterTweakData:_init_spooc(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.spooc = deep_clone(presets.base)
	self.spooc.tags = {"law", "spooc", "special"}
	self.spooc.experience = {}
	self.spooc.damage.hurt_severity = presets.hurt_severities.spooc
	self.spooc.weapon = presets.weapon.good
	self.spooc.detection = presets.detection.normal
	self.spooc.HEALTH_INIT = 115.2
	self.spooc.headshot_dmg_mul = strong_headshot
	self.spooc.damage.melee_damage_mul = 0.5
	self.spooc.move_speed = presets.move_speed.lightning
	self.spooc.no_retreat = true
	self.spooc.no_arrest = true
	self.spooc.surrender_break_time = {4, 6}
	self.spooc.suppression = nil
	self.spooc.surrender = nil
	self.spooc.priority_shout = "f33"
	self.spooc.bot_priority_shout = "f33x_any"
	self.spooc.priority_shout_max_dis = 3000
	self.spooc.rescue_hostages = false
	self.spooc.spooc_attack_timeout = {4, 4}
	self.spooc.spooc_attack_beating_time = {3, 3}
	self.spooc.spooc_attack_use_smoke_chance = 0
	self.spooc.weapon_voice = "3"
	self.spooc.experience.cable_tie = "tie_swat"
	self.spooc.speech_prefix_p1 = self._prefix_data_p1.cloaker()
	self.spooc.speech_prefix_count = nil
	self.spooc.access = "spooc"
	self.spooc.flammable = true
	self.spooc.dodge = presets.dodge.ninja
	self.spooc.chatter = presets.enemy_chatter.cloaker
	self.spooc.steal_loot = nil
	self.spooc.melee_weapon = "fists"
	self.spooc.use_radio = nil
	self.spooc.can_be_tased = true
	self.spooc.static_dodge_preset = true
	self.spooc.is_special = true
	self.spooc.kick_damage = 6.0 --Amount of damage dealt when cloakers kick players.
	self.spooc.jump_kick_damage = 12.0 --Amount of damage dealt when cloakers jump kick players.
	self.spooc.spawn_sound_event_2 = "clk_c01x_plu"
	self.spooc.spooc_sound_events = {
		detect_stop = "cloaker_detect_stop",
		detect = "cloaker_detect_mono"
	}
	self.spooc.heal_cooldown = true
	self.spooc.special_deaths = {
		melee = {
			[("head"):id():key()] = {
				sequence = "dismember_head",
				melee_weapon_id = "sandsteel",
				character_name = "dragon",
				sound_effect = "split_gen_head"
			},
			[("body"):id():key()] = {
				sequence = "dismember_body_top",
				melee_weapon_id = "sandsteel",
				character_name = "dragon",
				sound_effect = "split_gen_body"
			}
		}
	}
	table.insert(self._enemy_list, "spooc")

	self.spooc_titan = deep_clone(self.spooc)
	self.spooc_titan.weapon = presets.weapon.normal
	self.spooc_titan.tags = {"law", "custom", "special", "spooc"}
	self.spooc_titan.special_deaths = nil
	self.spooc_titan.HEALTH_INIT = 144
	self.spooc_titan.headshot_dmg_mul = strong_headshot	
	self.spooc_titan.damage.melee_damage_mul = 2
	self.spooc_titan.damage.explosion_damage_mul = 2
	if is_reaper or is_federales then	
		self.spooc_titan.speech_prefix_p1 = self._prefix_data_p1.cloaker()
		self.spooc_titan.speech_prefix_count = nil
	else
		self.spooc_titan.speech_prefix_p1 = "t_spk"
		self.spooc_titan.speech_prefix_count = nil
	end
	self.spooc_titan.damage.hurt_severity = presets.hurt_severities.spooc_titan
	self.spooc_titan.can_cloak = true
	self.spooc_titan.recloak_damage_threshold = 0.5
	self.spooc_titan.can_be_tased = false
	self.spooc_titan.priority_shout_max_dis = 0
	self.spooc_titan.unintimidateable = true
	self.spooc_titan.spawn_sound_event = "cloaker_presence_loop"
	self.spooc_titan.die_sound_event = "cloaker_presence_stop"
	self.spooc_titan.is_special = true
	if is_reaper or is_federales then
		self.spooc_titan.custom_voicework = nil
	else
		self.spooc_titan.custom_voicework = "tspook"
	end		
	self.spooc_titan.heal_cooldown = 30
	table.insert(self._enemy_list, "spooc_titan")	
end

function CharacterTweakData:_init_shadow_spooc(presets)
	self.shadow_spooc = deep_clone(presets.base)
	self.shadow_spooc.tags = {"law", "spooc", "special"}
	self.shadow_spooc.experience = {}
	self.shadow_spooc.damage.hurt_severity = presets.hurt_severities.spooc
	self.shadow_spooc.weapon = presets.weapon.normal
	self.shadow_spooc.detection = presets.detection.normal
	self.shadow_spooc.HEALTH_INIT = 144
	self.shadow_spooc.headshot_dmg_mul = strong_headshot	
	self.shadow_spooc.damage.melee_damage_mul = 2
	self.shadow_spooc.damage.explosion_damage_mul = 2
	self.shadow_spooc.move_speed = presets.move_speed.lightning
	self.shadow_spooc.no_retreat = true
	self.shadow_spooc.no_arrest = true
	self.shadow_spooc.surrender_break_time = {4, 6}
	self.shadow_spooc.suppression = nil
	self.shadow_spooc.surrender = nil
	self.shadow_spooc.priority_shout = "f33"
	self.shadow_spooc.bot_priority_shout = "f33x_any"
	self.shadow_spooc.priority_shout_max_dis = 3000
	self.shadow_spooc.rescue_hostages = false
	self.shadow_spooc.spooc_attack_timeout = {4, 4}
	self.shadow_spooc.spooc_attack_beating_time = {3, 3}
	self.shadow_spooc.spooc_attack_use_smoke_chance = 0
	self.shadow_spooc.weapon_voice = "3"
	self.shadow_spooc.experience.cable_tie = "tie_swat"
	self.shadow_spooc.speech_prefix_p1 = "uno_clk"
	self.shadow_spooc.speech_prefix_count = nil
	self.shadow_spooc.use_radio = nil
	self.shadow_spooc.chatter = presets.enemy_chatter.no_chatter
	self.shadow_spooc.do_not_drop_ammo = false
	self.shadow_spooc.steal_loot = nil
	self.shadow_spooc.spawn_sound_event = "uno_cloaker_presence_loop"
	self.shadow_spooc.die_sound_event = "uno_cloaker_presence_stop"
	self.shadow_spooc.spooc_sound_events = {
		detect_stop = "uno_cloaker_detect_stop",
		taunt_during_assault = "",
		taunt_after_assault = "",
		detect = "uno_cloaker_detect"
	}
	self.shadow_spooc.access = "spooc"
	self.shadow_spooc.flammable = true
	self.shadow_spooc.dodge = presets.dodge.ninja
	self.shadow_spooc.chatter = presets.enemy_chatter.no_chatter
	self.shadow_spooc.steal_loot = nil
	self.shadow_spooc.melee_weapon = nil
	self.shadow_spooc.use_radio = nil
	self.shadow_spooc.can_be_tased = true
	self.shadow_spooc.static_dodge_preset = true
	self.shadow_spooc.is_special = true
	self.shadow_spooc.heal_cooldown = true
	table.insert(self._enemy_list, "shadow_spooc")
end	

function CharacterTweakData:_init_shield(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.shield = deep_clone(presets.base)
	self.shield.tags = {"law", "shield", "special"}
	self.shield.damage.shield_explosion_ally_damage_mul = 1
	self.shield.damage.shield_explosion_damage_mul = 1
	self.shield.damage.explosion_damage_mul = 0.75
	self.shield.damage.fire_pool_damage_mul = 0.75
	self.shield.headshot_dmg_mul = normal_headshot
	self.shield.experience = {}
	self.shield.weapon = presets.weapon.shield
	self.shield.detection = presets.detection.normal
	self.shield.HEALTH_INIT = 36
	self.shield.damage.melee_damage_mul = 2
	self.shield.allowed_stances = {cbt = true}
	self.shield.allowed_poses = {crouch = true}
	self.shield.always_face_enemy = true
	self.shield.move_speed = presets.move_speed.fast
	self.shield.no_run_start = true
	self.shield.no_run_stop = true
	self.shield.no_retreat = true
	self.shield.no_limping = true
	self.shield.no_arrest = true
	self.shield.surrender = nil
	self.shield.ecm_vulnerability = 1
	self.shield.suppression = nil
	self.shield.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.shield.priority_shout = "f31"
	self.shield.bot_priority_shout = "f31x_any"
	self.shield.priority_shout_max_dis = 3000
	self.shield.rescue_hostages = false
	self.shield.deathguard = false
	self.shield.no_equip_anim = true
	self.shield.wall_fwd_offset = 100
	self.shield.calls_in = nil
	self.shield.ignore_medic_revive_animation = true
	self.shield.damage.hurt_severity = presets.hurt_severities.only_explosion_hurts
	self.shield.damage.shield_knocked = true
	self.shield.use_animation_on_fire_damage = false
	self.shield.flammable = true
	self.shield.weapon_voice = "3"
	self.shield.experience.cable_tie = "tie_swat"
	self.shield.speech_prefix_p1 = self._prefix_data_p1.swat()
	self.shield.speech_prefix_p2 = self._speech_prefix_p2
	self.shield.speech_prefix_count = 4
	self.shield.access = "shield"
	self.shield.chatter = presets.enemy_chatter.shield
	self.shield.announce_incomming = "incomming_shield"
	self.shield.spawn_sound_event = "shield_identification"
	self.shield.steal_loot = nil
	self.shield.use_animation_on_fire_damage = false
	self.shield.immune_to_knock_down = true
	self.shield.static_dodge_preset = true
	self.shield.is_special = true
	self.shield.heal_cooldown = 10
	table.insert(self._enemy_list, "shield")
end

function CharacterTweakData:_init_phalanx_minion(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.phalanx_minion = deep_clone(self.shield)
	self.phalanx_minion.tags = {"law", "shield", "special", "shield_titan"}
	self.phalanx_minion.experience = {}
	self.phalanx_minion.damage.shield_explosion_damage_mul = 0
	self.phalanx_minion.damage.shield_explosion_ally_damage_mul = 0
	self.phalanx_minion.weapon = presets.weapon.normal
	self.phalanx_minion.detection = presets.detection.normal
	self.phalanx_minion.headshot_dmg_mul = normal_headshot
	self.phalanx_minion.HEALTH_INIT = 48
	self.phalanx_minion.damage.explosion_damage_mul = 0.5
	self.phalanx_minion.damage.fire_pool_damage_mul = 0.5
	self.phalanx_minion.damage.melee_damage_mul = 2
	self.phalanx_minion.damage.hurt_severity = presets.hurt_severities.no_hurts_no_tase
	self.phalanx_minion.flammable = false
	self.phalanx_minion.damage.shield_knocked = true
	self.phalanx_minion.priority_shout = "f31"
	self.phalanx_minion.bot_priority_shout = "f31x_any"		
	self.phalanx_minion.move_speed = presets.move_speed.slow
	self.phalanx_minion.priority_shout_max_dis = 3000
	self.phalanx_minion.weapon_voice = "3"
	self.phalanx_minion.experience.cable_tie = "tie_swat"
	self.phalanx_minion.access = "shield"
	self.phalanx_minion.chatter = presets.enemy_chatter.shield
	self.phalanx_minion.announce_incomming = "incomming_shield"
	self.phalanx_minion.steal_loot = nil
	self.phalanx_minion.ignore_medic_revive_animation = true
	self.phalanx_minion.ecm_vulnerability = 1
	self.phalanx_minion.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.phalanx_minion.use_animation_on_fire_damage = false
	self.phalanx_minion.can_be_tased = false
	self.phalanx_minion.immune_to_knock_down = true
	self.phalanx_minion.immune_to_concussion = true
	self.phalanx_minion.damage.immune_to_knockback = false
	self.phalanx_minion.spawn_sound_event = "shield_identification"
	self.phalanx_minion.suppression = nil
	self.phalanx_minion.is_special = true
	self.phalanx_minion.speech_prefix_p1 = "fug"
	self.phalanx_minion.speech_prefix_p2 = nil
	self.phalanx_minion.speech_prefix_count = 1	
	if is_reaper or is_federales then
		self.phalanx_minion.custom_voicework = "tshield_ru"
	else
		self.phalanx_minion.custom_voicework = "tsniper"
	end		
	self.phalanx_minion.heal_cooldown = 15
	table.insert(self._enemy_list, "phalanx_minion")
	self.phalanx_minion_assault = deep_clone(self.phalanx_minion)
	table.insert(self._enemy_list, "phalanx_minion_assault")
end

function CharacterTweakData:_init_phalanx_vip(presets)
	self.phalanx_vip = deep_clone(self.phalanx_minion)
	self.phalanx_vip.tags = {"law", "shield", "special", "shield_titan", "captain"}
	self.phalanx_vip.damage.shield_knocked = false
	self.phalanx_vip.damage.immune_to_knockback = true
	self.phalanx_vip.immune_to_knock_down = true
	self.phalanx_vip.damage.shield_explosion_damage_mul = 0
	self.phalanx_vip.damage.shield_explosion_ally_damage_mul = 0
	self.phalanx_vip.HEALTH_INIT = 1500
	self.phalanx_vip.headshot_dmg_mul = strong_headshot
	self.phalanx_vip.damage.explosion_damage_mul = 2
	self.phalanx_vip.damage.melee_damage_mul = 2
	self.phalanx_vip.spawn_sound_event = "cpa_a02_01"	
	self.phalanx_vip.priority_shout = "f45"
	self.phalanx_vip.bot_priority_shout = "f45x_any"
	self.phalanx_vip.priority_shout_max_dis = 3000
	self.phalanx_vip.flammable = false
	self.phalanx_vip.can_be_tased = false
	self.phalanx_vip.ecm_vulnerability = nil	
	self.phalanx_vip.die_sound_event_2 = "l2n_x01a_any_3p"
	self.phalanx_vip.must_headshot = true
	self.phalanx_vip.ends_assault_on_death = true
	self.phalanx_vip.suppression = nil
	self.phalanx_vip.ecm_hurts = {}
	self.phalanx_vip.is_special = true
	self.phalanx_vip.custom_voicework = nil
	self.phalanx_vip.speech_prefix_p1 = "cpw"
	self.phalanx_vip.speech_prefix_p2 = nil
	self.phalanx_vip.speech_prefix_count = nil
	self.phalanx_vip.no_damage_mission = true
	self.phalanx_vip.weapon = presets.weapon.expert
	--self.phalanx_vip.death_animation = "death_run" 
	--self.phalanx_vip.death_animation_vars = {"var3", "heavy", "fwd", "high"}
	self.phalanx_vip.chatter = {
		aggressive = true,
		retreat = true,
		go_go = true,
		contact = true,
		heal_chatter_winters = true,
		entrance = true
	}
	self.phalanx_vip.slowing_bullets = {
		duration = 1.5,
		power = 0.75
	}
	self.phalanx_vip.do_omnia = {
		cooldown = 8,
		radius = 1200
	}
	table.insert(self._enemy_list, "phalanx_vip")
end

function CharacterTweakData:_init_spring(presets)
	self.spring = deep_clone(self.tank)
	self.spring.weapon = presets.weapon.dozer
	self.spring.tags = {"law", "custom", "special", "captain", "no_run"}
	self.spring.move_speed = presets.move_speed.very_slow
	self.spring.rage_move_speed = presets.move_speed.fast
	self.spring.grenade = cluster_frag
	self.spring.no_run_start = true
	self.spring.no_run_stop = true
	self.spring.no_retreat = true
	self.spring.no_limping = true
	self.spring.no_arrest = true
	self.spring.LOWER_HEALTH_PERCENTAGE_LIMIT = nil
	self.spring.FINAL_LOWER_HEALTH_PERCENTAGE_LIMIT = nil
	self.spring.ends_assault_on_death = true
	self.spring.no_damage_mission = true
	self.spring.immune_to_knock_down = true
	self.spring.HEALTH_INIT = 1620
	self.spring.EXTRA_HEALTH_BALANCE = 50
	self.spring.headshot_dmg_mul = normal_headshot
	self.spring.damage.explosion_damage_mul = 2
	self.spring.priority_shout = "f45"
	self.spring.bot_priority_shout = "f45x_any"
	self.spring.priority_shout_max_dis = 3000
	self.spring.flammable = true
	self.spring.rescue_hostages = false
	self.spring.can_be_tased = false
	self.spring.ecm_vulnerability = nil
	self.spring.immune_to_concussion = true
	self.spring.ecm_hurts = {}
	self.spring.damage.hurt_severity = presets.hurt_severities.captain
	self.spring.melee_weapon = "fists_dozer"
	self.spring.speech_prefix_p1 = "cpw"
	self.spring.speech_prefix_p2 = nil
	self.spring.speech_prefix_count = nil
	self.spring.chatter = {
		aggressive = true,
		retreat = true,
		go_go = true,
		contact = true,
		entrance = true
	}
	self.spring.announce_incomming = "incomming_captain"
	self.spring.spawn_sound_event = "cpa_a02_01"
	self.spring.die_sound_event_2 = "bdz_x02a_any_3p"
	self.spring.static_dodge_preset = true
	self.spring.is_special = true
	table.insert(self._enemy_list, "spring")
	
	--Headless Titandozer Boss 
	self.headless_hatman = deep_clone(self.spring)
	self.headless_hatman.custom_voicework = "hatman"
	self.headless_hatman.slowing_bullets = {
		duration = 1,
		power = 0.5
	}
	self.headless_hatman.grenade = hatman_molotov
	table.insert(self._enemy_list, "headless_hatman")
end

function CharacterTweakData:_init_summers(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.summers = deep_clone(presets.base)
	self.summers.tags = {"law", "custom", "special", "summers"}
	self.summers.experience = {}
	self.summers.weapon = presets.weapon.expert
	self.summers.melee_weapon = "buzzer_summer"
	self.summers.weapon_safety_range = 1
	self.summers.detection = presets.detection.normal
	self.summers.HEALTH_INIT = 216
	self.summers.headshot_dmg_mul = normal_headshot
	self.summers.flammable = false
	self.summers.use_animation_on_fire_damage = false
	self.summers.damage.hurt_severity = presets.hurt_severities.only_light_hurt_no_explode
	self.summers.bag_dmg_mul = 6
	self.summers.move_speed = presets.move_speed.fast
	self.summers.crouch_move = false
	self.summers.no_retreat = true
	self.summers.no_limping = true
	self.summers.no_arrest = true
	self.summers.ends_assault_on_death = true
	self.summers.no_damage_mission = true
	self.summers.immune_to_knock_down = true
	self.summers.priority_shout = "f45"
	self.summers.bot_priority_shout = "f45x_any"
	self.summers.priority_shout_max_dis = 3000
	self.summers.surrender = nil
	self.summers.ecm_vulnerability = 0
	self.summers.ecm_hurts = {}
	self.summers.surrender_break_time = {4, 6}
	self.summers.suppression = nil
	self.summers.weapon_voice = "3"
	self.summers.experience.cable_tie = "tie_swat"
	self.summers.speech_prefix_p1 = "rtsr"
	self.summers.speech_prefix_p2 = nil
	self.summers.speech_prefix_count = nil
	self.summers.access = "taser"
	self.summers.dodge = presets.dodge.elite
	self.summers.use_gas = true
	self.summers.rescue_hostages = false
	self.summers.can_be_tased = false
	self.summers.immune_to_concussion = true
	self.summers.deathguard = true
	self.summers.tase_on_melee = true
	self.summers.chatter = presets.enemy_chatter.summers
	self.summers.announce_incomming = "incomming_captain"
	if is_reaper then
		self.summers.spawn_sound_event = "cloaker_spawn"
	else
		self.summers.spawn_sound_event = "cpa_a02_01"
	end
	self.summers.use_radio = "dsp_radio_russian"
	self.summers.steal_loot = nil
	self.summers.is_special = true
	self.summers.leader = {max_nr_followers = 3}
	table.insert(self._enemy_list, "summers")
end

function CharacterTweakData:_init_autumn(presets)
	self.autumn = deep_clone(presets.base)
	self.autumn.tags = {"law", "custom", "special", "customvo"}
	self.autumn.experience = {}
	self.autumn.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.autumn.weapon = presets.weapon.expert
	self.autumn.detection = presets.detection.normal
	self.autumn.damage.immune_to_knockback = true
	self.autumn.immune_to_knock_down = true		
	self.autumn.immune_to_concussion = true		
	self.autumn.HEALTH_INIT = 432
	self.autumn.headshot_dmg_mul = normal_headshot
	self.autumn.flammable = false
	self.autumn.damage.explosion_damage_mul = 2
	self.autumn.move_speed = presets.move_speed.lightning
	self.autumn.can_cloak = true
	self.autumn.recloak_damage_threshold = 0.2
	self.autumn.no_retreat = true
	self.autumn.no_limping = true
	self.autumn.no_arrest = true
	self.autumn.surrender_break_time = {4, 6}
	self.autumn.suppression = nil
	self.autumn.surrender = nil
	self.autumn.can_be_tased = false
	self.autumn.priority_shout_max_dis = 0
	self.autumn.unintimidateable = true
	self.autumn.must_headshot = true
	self.autumn.priority_shout_max_dis = 3000
	self.autumn.rescue_hostages = true
	self.autumn.spooc_attack_timeout = {4, 4}
	self.autumn.spooc_attack_beating_time = {0, 0}
	self.autumn.no_damage_mission = true
	self.autumn.spawn_sound_event_2 = "cloaker_spawn"
	self.autumn.grenade = autumn_gas
	self.autumn.cuff_on_melee = true
	--self.autumn.spawn_sound_event_2 = "cpa_a02_01"--uncomment for testing purposes
	self.autumn.weapon_voice = "3"
	self.autumn.experience.cable_tie = "tie_swat"
	self.autumn.speech_prefix_p1 = "cpa"
	self.autumn.speech_prefix_count = nil
	self.autumn.custom_voicework = "autumn"		
	self.autumn.ends_assault_on_death = true	
	self.autumn.access = "spooc"
	self.autumn.dodge = presets.dodge.autumn
	self.autumn.chatter = {
		aggressive = true,
		retreat = true,
		go_go = true,
		contact = true,
		entrance = true
	}
	self.autumn.steal_loot = nil
	self.autumn.melee_weapon = nil
	self.autumn.use_radio = nil
	self.autumn.static_dodge_preset = true
	self.autumn.is_special = true
	self.autumn.dodge_with_grenade = {
		smoke = {duration = {
			12,
			12
		}},
		check = function (t, nr_grenades_used)
			local delay_till_next_use = 12
			local chance = 0.5

			if math.random() < chance then
				return true, t + delay_till_next_use
			end

			return false, t + delay_till_next_use
		end
	}
	self.autumn.do_autumn_blackout = true --if true, deployables in a radius around this cop will be disabled
	table.insert(self._enemy_list, "autumn")
end	

function CharacterTweakData:_init_taser(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end		
	self.taser = deep_clone(presets.base)
	self.taser.tags = {"law", "taser", "special"}
	self.taser.experience = {}
	self.taser.weapon = presets.weapon.good
	self.taser.weapon.is_rifle.tase_distance = 1400
	self.taser.weapon.is_rifle.aim_delay_tase = {0.75, 0.75}
	self.taser.weapon.is_rifle.tase_sphere_cast_radius = 10
	self.taser.detection = presets.detection.normal
	self.taser.HEALTH_INIT = 72
	self.taser.headshot_dmg_mul = normal_headshot
	self.taser.move_speed = presets.move_speed.fast
	self.taser.no_retreat = true
	self.taser.no_arrest = true
	self.taser.surrender = presets.surrender.special
	self.taser.ecm_vulnerability = 1
	self.taser.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.taser.surrender_break_time = {4, 6}
	self.taser.suppression = nil
	self.taser.weapon_voice = "3"
	self.taser.experience.cable_tie = "tie_swat"
	self.taser.speech_prefix_p1 = self._prefix_data_p1.taser()
	self.taser.speech_prefix_p2 = nil
	self.taser.speech_prefix_count = nil
	self.taser.spawn_sound_event = self._prefix_data_p1.taser() .. "_entrance"
	self.taser.access = "taser"
	self.taser.dodge = presets.dodge.athletic
	self.taser.priority_shout = "f32"
	self.taser.bot_priority_shout = "f32x_any"
	self.taser.priority_shout_max_dis = 3000
	self.taser.rescue_hostages = false
	self.taser.deathguard = true
	self.taser.shock_damage = 8.0 --Amount of damage dealt when taser shocks down.
	self.taser.chatter = {
		aggressive = true,
		retreat = true,
		go_go = true,
		contact = true,
		entrance = true
	}
	self.taser.announce_incomming = "incomming_taser"
	self.taser.steal_loot = nil
	self.taser.special_deaths = {}
	self.taser.special_deaths.bullet = {
		[("head"):id():key()] = {
			character_name = "bodhi",
			weapon_id = "model70",
			sequence = "kill_tazer_headshot",
			special_comment = "x01"
		}
	}
	self.taser.is_special = true
	self.taser.heal_cooldown = 15
	table.insert(self._enemy_list, "taser")
	
	self.taser_summers = deep_clone(self.taser)
	self.taser_summers.weapon = presets.weapon.expert
	self.taser_summers.HEALTH_INIT = 180
	self.taser_summers.headshot_dmg_mul = normal_headshot
	self.taser_summers.tags = {"female_enemy","taser", "medic_summers", "custom", "special"}
	self.taser_summers.ignore_medic_revive_animation = false
	self.taser_summers.flammable = false
	self.taser_summers.use_animation_on_fire_damage = false
	self.taser_summers.damage.hurt_severity = presets.hurt_severities.only_light_hurt_no_explode
	self.taser_summers.ecm_vulnerability = 0
	self.taser_summers.ecm_hurts = {}
	self.taser_summers.chatter = presets.enemy_chatter.summers
	self.taser_summers.no_retreat = true
	self.taser_summers.no_limping = true
	self.taser_summers.rescue_hostages = false
	self.taser_summers.steal_loot = nil
	self.taser_summers.immune_to_concussion = true
	self.taser_summers.no_damage_mission = true
	self.taser_summers.no_arrest = true
	self.taser_summers.immune_to_knock_down = true
	self.taser_summers.priority_shout = "f45"
	self.taser_summers.bot_priority_shout = "f45x_any"
	self.taser_summers.speech_prefix_p1 = "fl"
	self.taser_summers.speech_prefix_p2 = "n"
	self.taser_summers.speech_prefix_count = 1
	self.taser_summers.use_radio = "dsp_radio_russian"
	self.taser_summers.spawn_sound_event = nil
	self.taser_summers.custom_voicework = nil
	self.taser_summers.is_special = true	
	self.taser_summers.follower = true
	self.taser_summers.tase_on_melee = true
	self.taser_summers.slowing_bullets = {
		duration = 3,
		power = 1,
		taunt = true
	}
	table.insert(self._enemy_list, "taser_summers")
	
	self.taser_titan = deep_clone(self.taser)
	self.taser_titan.tags = {"taser", "taser_titan", "custom", "special"}
	self.taser_titan.HEALTH_INIT = 81
	self.taser_titan.headshot_dmg_mul = normal_headshot
	self.taser_titan.priority_shout = "f32"
	self.taser_titan.bot_priority_shout = "f32x_any"
	self.taser_titan.immune_to_concussion = true	
	self.taser_titan.use_animation_on_fire_damage = false
	self.taser_titan.can_be_tased = false	
	if is_reaper or is_federales then
		self.taser_titan.spawn_sound_event = "rtsr_elite"
	else
		self.taser_titan.spawn_sound_event = "tsr_elite"
	end	
	self.taser_titan.custom_voicework = nil
	self.taser_titan.surrender = nil
	self.taser_titan.dodge = presets.dodge.elite
	self.taser_titan.static_dodge_preset = true
	self.taser_titan.is_special = true	
	self.taser_titan.move_speed = presets.move_speed.fast
	self.taser_titan.heal_cooldown = true
	self.taser_titan.tase_on_melee = true
	self.taser_titan.slowing_bullets = {
		duration = 3,
		power = 1,
		taunt = true
	}
	table.insert(self._enemy_list, "taser_titan")
end

function CharacterTweakData:_init_boom(presets)
	local is_murky
	if self:get_ai_group_type() == "murkywater" then
		is_murky = true
	end
	local is_reaper
	if self:get_ai_group_type() == "russia" then
		is_reaper = true
	end
	local is_zombie
	if self:get_ai_group_type() == "zombie" then
		is_zombie = true
	end
	local is_federales
	if self:get_ai_group_type() == "federales" then
		is_federales = true
	end			
	self.boom = deep_clone(presets.base)
	self.boom.tags = {"law", "boom", "custom", "special", "customvo"}
	self.boom.experience = {}
	self.boom.weapon = presets.weapon.good
	self.boom.melee_weapon = "baton"
	self.boom.weapon_safety_range = 1000
	self.boom.detection = presets.detection.normal
	self.boom.HEALTH_INIT = 72
	self.boom.headshot_dmg_mul = normal_headshot
	self.boom.HEALTH_SUICIDE_LIMIT = 0.25
	self.boom.flammable = true
	self.boom.use_animation_on_fire_damage = true
	self.boom.damage.explosion_damage_mul = 0.5
	self.boom.damage.hurt_severity = presets.hurt_severities.boom
	self.boom.bag_dmg_mul = 6
	self.boom.move_speed = presets.move_speed.fast
	self.boom.no_retreat = true
	self.boom.no_arrest = true
	self.boom.surrender = nil
	self.boom.ecm_vulnerability = 1
	self.boom.ecm_hurts = {
		ears = {min_duration = 3, max_duration = 3}
	}
	self.boom.surrender_break_time = {4, 6}
	self.boom.suppression = nil
	self.boom.weapon_voice = "3"
	self.boom.experience.cable_tie = "tie_swat"
	self.boom.speech_prefix_p1 = nil
	self.boom.speech_prefix_p2 = nil
	self.boom.speech_prefix_count = nil
	self.boom.access = "taser"
	self.boom.dodge = presets.dodge.athletic
	self.boom.use_gas = true
	self.boom.grenade = tear_gas
	self.boom.priority_shout = "g29"
	self.boom.bot_priority_shout = "g29"
	self.boom.priority_shout_max_dis = 3000
	self.boom.custom_shout = true
	self.boom.rescue_hostages = false
	self.boom.deathguard = true
	self.boom.chatter = {
		aggressive = true,
		retreat = true,
		go_go = true,
		contact = true,
		entrance = true
	}
	self.boom.announce_incomming = "incomming_gren"
	self.boom.steal_loot = nil
	if is_federales then
		self.boom.custom_voicework = "grenadier_bex"
	--Temp, until we get a better one
	elseif is_reaper then
		self.boom.custom_voicework = "tswat_ru"
	else
		self.boom.custom_voicework = "grenadier"
	end
	self.boom.is_special = true		
	self.boom.heal_cooldown = 15
	table.insert(self._enemy_list, "boom")
	
	self.boom_summers = deep_clone(self.boom)
	self.boom_summers.weapon = presets.weapon.expert
	self.boom_summers.use_animation_on_fire_damage = false
	self.boom_summers.damage.explosion_damage_mul = 1
	self.boom_summers.damage.fire_damage_mul = 1
	self.boom_summers.damage.hurt_severity = presets.hurt_severities.only_light_hurt_no_explode
	self.boom_summers.chatter = presets.enemy_chatter.summers
	self.boom_summers.speech_prefix_p1 = "fl"
	self.boom_summers.speech_prefix_p2 = "n"
	self.boom_summers.speech_prefix_count = 1
	self.boom_summers.custom_voicework = nil
	self.boom_summers.use_radio = "dsp_radio_russian"
	self.boom_summers.HEALTH_INIT = 180
	self.boom_summers.headshot_dmg_mul = normal_headshot
	self.boom_summers.tags = {"female_enemy", "medic_summers", "custom", "special"}
	self.boom_summers.ignore_medic_revive_animation = false
	self.boom_summers.grenade = molotov
	self.boom_summers.no_retreat = true
	self.boom_summers.no_limping = true
	self.boom_summers.no_arrest = true
	self.boom_summers.immune_to_knock_down = true
	self.boom_summers.immune_to_concussion = true
	self.boom_summers.no_damage_mission = true
	self.boom_summers.priority_shout = "f45"
	self.boom_summers.bot_priority_shout = "f45x_any"
	self.boom_summers.custom_shout = false
	self.boom_summers.rescue_hostages = false
	self.boom_summers.steal_loot = nil
	self.boom_summers.follower = true
	self.boom_summers.ecm_vulnerability = 0
	self.boom_summers.ecm_hurts = {}		
	table.insert(self._enemy_list, "boom_summers")		
	
	self.boom_titan = deep_clone(self.boom)
	self.boom_titan.heal_cooldown = true
	table.insert(self._enemy_list, "boom_titan")		
end

function CharacterTweakData:_init_inside_man(presets)
	self.inside_man = deep_clone(presets.base)
	self.inside_man.experience = {}
	self.inside_man.weapon = presets.weapon.good
	self.inside_man.detection = presets.detection.blind
	self.inside_man.HEALTH_INIT = 10
	self.inside_man.headshot_dmg_mul = normal_headshot
	self.inside_man.move_speed = presets.move_speed.normal
	self.inside_man.surrender_break_time = {10, 15}
	self.inside_man.suppression = nil
	self.inside_man.surrender = nil
	self.inside_man.unintimidateable = true
	self.inside_man.ecm_vulnerability = nil
	self.inside_man.ecm_hurts = {
		ears = {min_duration = 0, max_duration = 0}
	}
	self.inside_man.weapon_voice = "1"
	self.inside_man.experience.cable_tie = "tie_swat"
	self.inside_man.speech_prefix_p1 = "l"
	self.inside_man.speech_prefix_p2 = "n"
	self.inside_man.speech_prefix_count = 4
	self.inside_man.access = "cop"
	self.inside_man.dodge = presets.dodge.average
	self.inside_man.chatter = presets.enemy_chatter.no_chatter
	self.inside_man.melee_weapon = "baton"
	self.inside_man.calls_in = nil
end

function CharacterTweakData:_init_civilian(presets)
	self.civilian = {
		experience = {}
	}
	self.civilian.tags = {"civilian"}
	self.civilian.detection = presets.detection.civilian
	self.civilian.HEALTH_INIT = 0.9 --Some day these poor guys will get proper health
	self.civilian.headshot_dmg_mul = normal_headshot
	self.civilian.move_speed = presets.move_speed.civ_fast
	self.civilian.flee_type = "escape"
	self.civilian.scare_max = {10, 20}
	self.civilian.scare_shot = 1
	self.civilian.scare_intimidate = -5
	self.civilian.submission_max = {60, 120}
	self.civilian.submission_intimidate = 120
	self.civilian.run_away_delay = {5, 20}
	self.civilian.damage = {
		hurt_severity = presets.hurt_severities.no_hurts
	}
	self.civilian.flammable = false
	self.civilian.ecm_vulnerability = nil
	self.civilian.ecm_hurts = {
		ears = {min_duration = 0, max_duration = 0}
	}
	self.civilian.experience.cable_tie = "tie_civ"
	self.civilian.die_sound_event = "a01x_any"
	self.civilian.silent_priority_shout = "f37"
	self.civilian.speech_prefix_p1 = "cm"
	self.civilian.speech_prefix_count = 2
	self.civilian.access = "civ_male"
	self.civilian.intimidateable = true
	self.civilian.challenges = {type = "civilians"}
	if job == "nmh" or job == "nmh_res" then
		self.civilian.calls_in = false
	else
		self.civilian.calls_in = true
	end
	self.civilian.hostage_move_speed = 1.5
	self.civilian_female = deep_clone(self.civilian)
	self.civilian_female.die_sound_event = "a02x_any"
	self.civilian_female.speech_prefix_p1 = "cf"
	self.civilian_female.speech_prefix_count = 5
	self.civilian_female.female = true
	self.civilian_female.access = "civ_female"
	self.robbers_safehouse = deep_clone(self.civilian)
	self.robbers_safehouse.scare_shot = 0
	self.robbers_safehouse.scare_intimidate = 0
	self.robbers_safehouse.intimidateable = false
	self.robbers_safehouse.ignores_aggression = true
	self.robbers_safehouse.calls_in = nil
	self.robbers_safehouse.ignores_contours = true
	self.robbers_safehouse.HEALTH_INIT = 20
	self.robbers_safehouse.headshot_dmg_mul = 1
	self.robbers_safehouse.use_ik = true	
end

function CharacterTweakData:_init_civilian_mariachi(presets)
	self.civilian_mariachi = deep_clone(self.civilian)
end	

function CharacterTweakData:_init_bank_manager(presets)
	self.bank_manager = {
		experience = {},
		escort = {}
	}
	self.bank_manager.tags = {"civilian"}
	self.bank_manager.die_sound_event = "a01x_any"
	self.bank_manager.detection = presets.detection.civilian
	self.bank_manager.HEALTH_INIT = self.civilian.HEALTH_INIT
	self.bank_manager.headshot_dmg_mul = self.civilian.headshot_dmg_mul
	self.bank_manager.move_speed = presets.move_speed.normal
	self.bank_manager.flee_type = "hide"
	self.bank_manager.scare_max = {10, 20}
	self.bank_manager.scare_shot = 1
	self.bank_manager.scare_intimidate = -5
	self.bank_manager.submission_max = {60, 120}
	self.bank_manager.submission_intimidate = 120
	self.bank_manager.damage = {
		hurt_severity = presets.hurt_severities.no_hurts
	}
	self.bank_manager.flammable = false
	self.bank_manager.ecm_vulnerability = nil
	self.bank_manager.ecm_hurts = {
		ears = {min_duration = 0, max_duration = 0}
	}
	self.bank_manager.experience.cable_tie = "tie_civ"
	self.bank_manager.speech_prefix_p1 = "cm"
	self.bank_manager.speech_prefix_count = 2
	self.bank_manager.access = "civ_male"
	self.bank_manager.intimidateable = true
	self.bank_manager.hostage_move_speed = 1.5
	self.bank_manager.challenges = {type = "civilians"}
	self.bank_manager.calls_in = true
end

function CharacterTweakData:_init_drunk_pilot(presets)
	self.drunk_pilot = deep_clone(self.civilian)
	self.drunk_pilot.move_speed = presets.move_speed.civ_fast
	self.drunk_pilot.flee_type = "hide"
	self.drunk_pilot.access = "civ_male"
	self.drunk_pilot.intimidateable = nil
	self.drunk_pilot.challenges = {type = "civilians"}
	self.drunk_pilot.calls_in = nil
	self.drunk_pilot.ignores_aggression = true
end

function CharacterTweakData:_init_boris(presets)
	self.boris = deep_clone(self.civilian)
	self.boris.flee_type = "hide"
	self.boris.access = "civ_male"
	self.boris.intimidateable = nil
	self.boris.challenges = {type = "civilians"}
	self.boris.calls_in = nil
	self.boris.ignores_aggression = true
end

function CharacterTweakData:_init_old_hoxton_mission(presets)
	self.old_hoxton_mission = deep_clone(presets.base)
	self.old_hoxton_mission.experience = {}
	self.old_hoxton_mission.no_run_start = true
	self.old_hoxton_mission.no_run_stop = true
	self.old_hoxton_mission.weapon = presets.weapon.good
	self.old_hoxton_mission.detection = presets.detection.gang_member
	self.old_hoxton_mission.damage = presets.gang_member_damage
	self.old_hoxton_mission.damage.explosion_damage_mul = 0
	self.old_hoxton_mission.HEALTH_INIT = 20
	self.old_hoxton_mission.headshot_dmg_mul = 1
	self.old_hoxton_mission.move_speed = presets.move_speed.gang_member
	--Cause they don't like being told what to do
	self.old_hoxton_mission.allowed_poses = {stand = true}
	self.old_hoxton_mission.surrender_break_time = {6, 10}
	self.old_hoxton_mission.suppression = nil
	self.old_hoxton_mission.surrender = false
	self.old_hoxton_mission.weapon_voice = "1"
	self.old_hoxton_mission.experience.cable_tie = "tie_swat"
	self.old_hoxton_mission.speech_prefix_p1 = "rb2"
	self.old_hoxton_mission.access = "teamAI4"
	self.old_hoxton_mission.dodge = nil
	self.old_hoxton_mission.no_arrest = true
	self.old_hoxton_mission.chatter = presets.enemy_chatter.no_chatter
	self.old_hoxton_mission.use_radio = nil
	self.old_hoxton_mission.melee_weapon = "toothbrush"
	self.old_hoxton_mission.steal_loot = false
	self.old_hoxton_mission.rescue_hostages = false
	self.old_hoxton_mission.crouch_move = false
	self.old_hoxton_mission.static_dodge_preset = true
	--No more being mean to Hoxton
	self.old_hoxton_mission.is_escort = true
	self.old_hoxton_mission.speech_escort = "f38"
	self.old_hoxton_mission.escort_idle_talk = false	
	
	self.anubis = deep_clone(self.old_hoxton_mission)	
end

function CharacterTweakData:_init_spa_vip(presets)
	self.spa_vip = deep_clone(self.old_hoxton_mission)
	self.spa_vip.melee_weapon = "fists"
	self.spa_vip.spotlight_important = 100
	self.spa_vip.is_escort = true
	self.spa_vip.escort_idle_talk = false
	self.spa_vip.escort_scared_dist = 100
end

function CharacterTweakData:_init_spa_vip_hurt(presets)
	self.spa_vip_hurt = deep_clone(self.civilian)
	self.spa_vip_hurt.move_speed = presets.move_speed.slow
	self.spa_vip_hurt.flee_type = "hide"
	self.spa_vip_hurt.access = "civ_male"
	self.spa_vip_hurt.intimidateable = nil
	self.spa_vip_hurt.challenges = {type = "civilians"}
	self.spa_vip_hurt.calls_in = nil
	self.spa_vip_hurt.ignores_aggression = true
end

function CharacterTweakData:_init_russian(presets)
	self.russian = {}
	self.russian.always_face_enemy = true
	self.russian.no_run_start = true
	self.russian.no_run_stop = true
	self.russian.flammable = false
	self.russian.damage = presets.gang_member_damage
	self.russian.weapon = deep_clone(presets.weapon.gang_member)
	self.russian.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.dallas.primaries,
		secondary = self.char_wep_tables.dallas.secondaries
	}
	self.russian.detection = presets.detection.gang_member
	self.russian.move_speed = presets.move_speed.very_fast
	self.russian.crouch_move = false
	self.russian.speech_prefix = "rb2"
	self.russian.weapon_voice = "1"
	self.russian.access = "teamAI1"
	self.russian.dodge = nil
	self.russian.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_german(presets)
	self.german = {}
	self.german.always_face_enemy = true
	self.german.no_run_start = true
	self.german.no_run_stop = true
	self.german.flammable = false
	self.german.melee_weapon = "nin"
	self.german.damage = presets.gang_member_damage
	self.german.weapon = deep_clone(presets.weapon.gang_member)
	self.german.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.wolf.primaries,
		secondary = self.char_wep_tables.wolf.secondaries
	}
	self.german.detection = presets.detection.gang_member
	self.german.move_speed = presets.move_speed.very_fast
	self.german.crouch_move = false
	self.german.speech_prefix = "rb2"
	self.german.weapon_voice = "2"
	self.german.access = "teamAI1"
	self.german.dodge = nil
	self.german.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_spanish(presets)
	self.spanish = {}
	self.spanish.always_face_enemy = true
	self.spanish.no_run_start = true
	self.spanish.no_run_stop = true
	self.spanish.flammable = false
	self.spanish.melee_weapon = "gerber"
	self.spanish.damage = presets.gang_member_damage
	self.spanish.weapon = deep_clone(presets.weapon.gang_member)
	self.spanish.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.chains.primaries,
		secondary = self.char_wep_tables.chains.secondaries
	}
	self.spanish.detection = presets.detection.gang_member
	self.spanish.move_speed = presets.move_speed.very_fast
	self.spanish.crouch_move = false
	self.spanish.speech_prefix = "rb2"
	self.spanish.weapon_voice = "3"
	self.spanish.access = "teamAI1"
	self.spanish.dodge = nil
	self.spanish.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_american(presets)
	self.american = {}
	self.american.always_face_enemy = true
	self.american.no_run_start = true
	self.american.no_run_stop = true
	self.american.flammable = false
	self.american.damage = presets.gang_member_damage
	self.american.weapon = deep_clone(presets.weapon.gang_member)
	self.american.melee_weapon = "baton"
	self.american.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.houston.primaries,
		secondary = self.char_wep_tables.houston.secondaries
	}
	self.american.detection = presets.detection.gang_member
	self.american.move_speed = presets.move_speed.very_fast
	self.american.crouch_move = false
	self.american.speech_prefix = "rb2"
	self.american.weapon_voice = "3"
	self.american.access = "teamAI1"
	self.american.dodge = nil
	self.american.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_jowi(presets)
	self.jowi = {}
	self.jowi.always_face_enemy = true
	self.jowi.no_run_start = true
	self.jowi.no_run_stop = true
	self.jowi.melee_weapon = "kabartanto"
	self.jowi.damage = presets.gang_member_damage
	self.jowi.weapon = deep_clone(presets.weapon.gang_member)
	self.jowi.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.wick.primaries,
		secondary = self.char_wep_tables.wick.secondaries
	}
	self.jowi.detection = presets.detection.gang_member
	self.jowi.move_speed = presets.move_speed.very_fast
	self.jowi.crouch_move = false
	self.jowi.speech_prefix = "rb2"
	self.jowi.weapon_voice = "3"
	self.jowi.access = "teamAI1"
	self.jowi.dodge = nil
	self.jowi.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_old_hoxton(presets)
	self.old_hoxton = {}
	self.old_hoxton.always_face_enemy = true
	self.old_hoxton.no_run_start = true
	self.old_hoxton.no_run_stop = true
	self.old_hoxton.melee_weapon = "switchblade"
	self.old_hoxton.damage = presets.gang_member_damage
	self.old_hoxton.weapon = deep_clone(presets.weapon.gang_member)
	self.old_hoxton.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.hoxton.primaries,
		secondary = self.char_wep_tables.hoxton.secondaries
	}
	self.old_hoxton.detection = presets.detection.gang_member
	self.old_hoxton.move_speed = presets.move_speed.very_fast
	self.old_hoxton.crouch_move = false
	self.old_hoxton.speech_prefix = "rb2"
	self.old_hoxton.weapon_voice = "3"
	self.old_hoxton.access = "teamAI1"
	self.old_hoxton.dodge = nil
	self.old_hoxton.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_clover(presets)
	self.female_1 = {}
	self.female_1.always_face_enemy = true
	self.female_1.no_run_start = true
	self.female_1.no_run_stop = true
	self.female_1.melee_weapon = "shillelagh"
	self.female_1.damage = presets.gang_member_damage
	self.female_1.weapon = deep_clone(presets.weapon.gang_member)
	self.female_1.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.clover.primaries,
		secondary = self.char_wep_tables.clover.secondaries
	}
	self.female_1.detection = presets.detection.gang_member
	self.female_1.move_speed = presets.move_speed.very_fast
	self.female_1.crouch_move = false
	self.female_1.speech_prefix = "rb7"
	self.female_1.weapon_voice = "3"
	self.female_1.access = "teamAI1"
	self.female_1.dodge = nil
	self.female_1.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_dragan(presets)
	self.dragan = {}
	self.dragan.always_face_enemy = true
	self.dragan.no_run_start = true
	self.dragan.no_run_stop = true
	self.dragan.melee_weapon = "meat_cleaver"
	self.dragan.damage = presets.gang_member_damage
	self.dragan.weapon = deep_clone(presets.weapon.gang_member)
	self.dragan.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.dragan.primaries,
		secondary = self.char_wep_tables.dragan.secondaries
	}
	self.dragan.detection = presets.detection.gang_member
	self.dragan.move_speed = presets.move_speed.very_fast
	self.dragan.crouch_move = false
	self.dragan.speech_prefix = "rb8"
	self.dragan.weapon_voice = "3"
	self.dragan.access = "teamAI1"
	self.dragan.dodge = nil
	self.dragan.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_jacket(presets)
	self.jacket = {}
	self.jacket.always_face_enemy = true
	self.jacket.no_run_start = true
	self.jacket.no_run_stop = true
	self.jacket.melee_weapon = "hammer"
	self.jacket.damage = presets.gang_member_damage
	self.jacket.weapon = deep_clone(presets.weapon.gang_member)
	self.jacket.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.jacket.primaries,
		secondary = self.char_wep_tables.jacket.secondaries
	}
	self.jacket.detection = presets.detection.gang_member
	self.jacket.move_speed = presets.move_speed.very_fast
	self.jacket.crouch_move = false
	self.jacket.speech_prefix = "rb9"
	self.jacket.weapon_voice = "3"
	self.jacket.access = "teamAI1"
	self.jacket.dodge = nil
	self.jacket.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_bonnie(presets)
	self.bonnie = {}
	self.bonnie.always_face_enemy = true
	self.bonnie.no_run_start = true
	self.bonnie.no_run_stop = true
	self.bonnie.melee_weapon = "croupier_rake"
	self.bonnie.damage = presets.gang_member_damage
	self.bonnie.weapon = deep_clone(presets.weapon.gang_member)
	self.bonnie.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.bonnie.primaries,
		secondary = self.char_wep_tables.bonnie.secondaries
	}
	self.bonnie.detection = presets.detection.gang_member
	self.bonnie.move_speed = presets.move_speed.very_fast
	self.bonnie.dodge = nil
	self.bonnie.crouch_move = false
	self.bonnie.speech_prefix = "rb10"
	self.bonnie.weapon_voice = "3"
	self.bonnie.access = "teamAI1"
	self.bonnie.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_sokol(presets)
	self.sokol = {}
	self.sokol.always_face_enemy = true
	self.sokol.no_run_start = true
	self.sokol.no_run_stop = true
	self.sokol.melee_weapon = "hockey"
	self.sokol.damage = presets.gang_member_damage
	self.sokol.weapon = deep_clone(presets.weapon.gang_member)
	self.sokol.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.sokol.primaries,
		secondary = self.char_wep_tables.sokol.secondaries
	}
	self.sokol.detection = presets.detection.gang_member
	self.sokol.move_speed = presets.move_speed.very_fast
	self.sokol.crouch_move = false
	self.sokol.speech_prefix = "rb11"
	self.sokol.weapon_voice = "3"
	self.sokol.access = "teamAI1"
	self.sokol.dodge = nil
	self.sokol.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_dragon(presets)
	self.dragon = {}
	self.dragon.always_face_enemy = true
	self.dragon.no_run_start = true
	self.dragon.no_run_stop = true
	self.dragon.melee_weapon = "sandsteel"
	self.dragon.damage = presets.gang_member_damage
	self.dragon.weapon = deep_clone(presets.weapon.gang_member)
	self.dragon.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.jiro.primaries,
		secondary = self.char_wep_tables.jiro.secondaries
	}
	self.dragon.detection = presets.detection.gang_member
	self.dragon.move_speed = presets.move_speed.very_fast
	self.dragon.crouch_move = false
	self.dragon.speech_prefix = "rb12"
	self.dragon.weapon_voice = "3"
	self.dragon.access = "teamAI1"
	self.dragon.dodge = nil
	self.dragon.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_bodhi(presets)
	self.bodhi = {}
	self.bodhi.always_face_enemy = true
	self.bodhi.no_run_start = true
	self.bodhi.no_run_stop = true
	self.bodhi.melee_weapon = "iceaxe"
	self.bodhi.damage = presets.gang_member_damage
	self.bodhi.weapon = deep_clone(presets.weapon.gang_member)
	self.bodhi.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.bodhi.primaries,
		secondary = self.char_wep_tables.bodhi.secondaries
	}
	self.bodhi.detection = presets.detection.gang_member
	self.bodhi.move_speed = presets.move_speed.very_fast
	self.bodhi.crouch_move = false
	self.bodhi.speech_prefix = "rb13"
	self.bodhi.weapon_voice = "3"
	self.bodhi.access = "teamAI1"
	self.bodhi.dodge = nil
	self.bodhi.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_jimmy(presets)
	self.jimmy = {}
	self.jimmy.always_face_enemy = true
	self.jimmy.no_run_start = true
	self.jimmy.no_run_stop = true
	self.jimmy.melee_weapon = "ballistic"
	self.jimmy.damage = presets.gang_member_damage
	self.jimmy.weapon = deep_clone(presets.weapon.gang_member)
	self.jimmy.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.jimmy.primaries,
		secondary = self.char_wep_tables.jimmy.secondaries
	}
	self.jimmy.detection = presets.detection.gang_member
	self.jimmy.move_speed = presets.move_speed.very_fast
	self.jimmy.crouch_move = false
	self.jimmy.speech_prefix = "rb14"
	self.jimmy.weapon_voice = "3"
	self.jimmy.access = "teamAI1"
	self.jimmy.dodge = nil
	self.jimmy.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_sydney(presets)
	self.sydney = {}
	self.sydney.always_face_enemy = true
	self.sydney.no_run_start = true
	self.sydney.no_run_stop = true
	self.sydney.melee_weapon = "wing"
	self.sydney.damage = presets.gang_member_damage
	self.sydney.weapon = deep_clone(presets.weapon.gang_member)
	self.sydney.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.sydney.primaries,
		secondary = self.char_wep_tables.sydney.secondaries
	}
	self.sydney.detection = presets.detection.gang_member
	self.sydney.move_speed = presets.move_speed.very_fast
	self.sydney.crouch_move = false
	self.sydney.speech_prefix = "rb15"
	self.sydney.weapon_voice = "3"
	self.sydney.access = "teamAI1"
	self.sydney.dodge = nil
	self.sydney.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_wild(presets)
	self.wild = {}
	self.wild.always_face_enemy = true
	self.wild.no_run_start = true
	self.wild.no_run_stop = true
	self.wild.melee_weapon = "road"
	self.wild.damage = presets.gang_member_damage
	self.wild.weapon = deep_clone(presets.weapon.gang_member)
	self.wild.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.rust.primaries,
		secondary = self.char_wep_tables.rust.secondaries
	}
	self.wild.detection = presets.detection.gang_member
	self.wild.move_speed = presets.move_speed.very_fast
	self.wild.crouch_move = false
	self.wild.speech_prefix = "rb16"
	self.wild.weapon_voice = "3"
	self.wild.access = "teamAI1"
	self.wild.dodge = nil
	self.wild.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_chico(presets)
	self.chico = {}
	self.chico.always_face_enemy = true
	self.chico.no_run_start = true
	self.chico.no_run_stop = true
	self.chico.melee_weapon = "brick"
	self.chico.damage = presets.gang_member_damage
	self.chico.weapon = deep_clone(presets.weapon.gang_member)
	self.chico.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.tony.primaries,
		secondary = self.char_wep_tables.tony.secondaries
	}
	self.chico.detection = presets.detection.gang_member
	self.chico.move_speed = presets.move_speed.very_fast
	self.chico.crouch_move = false
	self.chico.speech_prefix = "rb17"
	self.chico.weapon_voice = "3"
	self.chico.access = "teamAI1"
	self.chico.dodge = nil
	self.chico.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_max(presets)
	self.max = {}
	self.max.always_face_enemy = true
	self.max.no_run_start = true
	self.max.no_run_stop = true
	self.max.melee_weapon = "agave"
	self.max.damage = presets.gang_member_damage
	self.max.weapon = deep_clone(presets.weapon.gang_member)
	self.max.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.sangres.primaries,
		secondary = self.char_wep_tables.sangres.secondaries
	}
	self.max.detection = presets.detection.gang_member
	self.max.move_speed = presets.move_speed.very_fast
	self.max.crouch_move = false
	self.max.speech_prefix = "rb18"
	self.max.weapon_voice = "3"
	self.max.access = "teamAI1"
	self.max.dodge = nil
	self.max.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_myh(presets)
	self.myh = {}
	self.myh.always_face_enemy = true
	self.myh.no_run_start = true
	self.myh.no_run_stop = true
	self.myh.flammable = false
	self.myh.melee_weapon = "sap"
	self.myh.damage = presets.gang_member_damage
	self.myh.weapon = deep_clone(presets.weapon.gang_member)
	self.myh.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.duke.primaries,
		secondary = self.char_wep_tables.duke.secondaries
	}
	self.myh.detection = presets.detection.gang_member
	self.myh.move_speed = presets.move_speed.very_fast
	self.myh.crouch_move = false
	self.myh.speech_prefix = "rb2"
	self.myh.weapon_voice = "1"
	self.myh.access = "teamAI1"
	self.myh.dodge = nil
	self.myh.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_ecp(presets)
	self.ecp_female = {
		damage = presets.gang_member_damage,
		weapon = deep_clone(presets.weapon.gang_member)
	}
	self.ecp_female.weapon.weapons_of_choice = {
		primary = "wpn_fps_ass_m4_npc",
		secondary = "wpn_fps_smg_mp5_npc"
	}
	self.ecp_female.always_face_enemy = true
	self.ecp_female.no_run_start = true
	self.ecp_female.no_run_stop = true
	self.ecp_female.flammable = false
	self.ecp_female.melee_weapon = "clean"
	self.ecp_female.detection = presets.detection.gang_member
	self.ecp_female.move_speed = presets.move_speed.very_fast 
	self.ecp_female.crouch_move = false
	self.ecp_female.speech_prefix = "rb21"
	self.ecp_female.weapon_voice = "3"
	self.ecp_female.access = "teamAI1"
	self.ecp_female.dodge = nil
	self.ecp_female.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
	self.ecp_male = {
		damage = presets.gang_member_damage,
		weapon = deep_clone(presets.weapon.gang_member)
	}
	self.ecp_male.weapon.weapons_of_choice = {
		primary = "wpn_fps_ass_m4_npc",
		secondary = "wpn_fps_smg_mp5_npc"
	}
	self.ecp_male.always_face_enemy = true
	self.ecp_male.no_run_start = true
	self.ecp_male.no_run_stop = true
	self.ecp_male.flammable = false		
	self.ecp_male.melee_weapon = "clean"
	self.ecp_male.detection = presets.detection.gang_member
	self.ecp_male.move_speed = presets.move_speed.very_fast
	self.ecp_male.crouch_move = false
	self.ecp_male.speech_prefix = "rb20"
	self.ecp_male.weapon_voice = "3"
	self.ecp_male.access = "teamAI1"
	self.ecp_male.dodge = nil
	self.ecp_male.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_joy(presets)
	self.joy = {
		damage = presets.gang_member_damage,
		weapon = deep_clone(presets.weapon.gang_member)
	}
	self.joy.weapon.weapons_of_choice = {
		primary = self.char_wep_tables.joy.primaries,
		secondary = self.char_wep_tables.joy.secondaries
	}
	self.joy.always_face_enemy = true
	self.joy.no_run_start = true
	self.joy.no_run_stop = true
	self.joy.flammable = false			
	self.joy.detection = presets.detection.gang_member
	self.joy.move_speed = presets.move_speed.very_fast
	self.joy.crouch_move = false
	self.joy.speech_prefix = "rb19"
	self.joy.weapon_voice = "3"
	self.joy.access = "teamAI1"
	self.joy.dodge = nil
	self.joy.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end	

function CharacterTweakData:_presets(tweak_data)
	local presets = {}
	presets.enemy_chatter = {
		no_chatter = {},
		guard = {
			aggressive = true,
			contact = true,
			clear = true,
			clear_whisper = true,
			clear_whisper_2 = true,
			reload = true,
			look_for_angle = true,
			ecm = true,
			saw = true,
			trip_mines = true,
			sentry = true,
			suppress = true
		},
		cop = {
			entry = true,
			aggressive = true,
			enemyidlepanic = true,
			controlpanic = true,
			dodge = true,
			cuffed = true,
			incomming_captain = true,
			incomming_gren = true,
			incomming_tank = true,
			incomming_spooc = true,
			incomming_shield = true,
			incomming_taser = true,
			entry = true,
			aggressive_assault = true,
			retreat = true,
			contact = true,
			clear = true,
			clear_whisper = true,
			go_go = true,
			push = true,
			reload = true,
			look_for_angle = true,
			ecm = true,
			saw = true,
			trip_mines = true,
			sentry = true,
			ready = true,
			smoke = true,
			flash_grenade = true,
			follow_me = true,
			deathguard = true,
			open_fire = true,
			suppress = true
		},
		swat = {
			entry = true,
			aggressive = true,
			enemyidlepanic = true,
			controlpanic = true,
			dodge = true,
			cuffed = true,
			incomming_captain = true,
			incomming_gren = true,
			incomming_tank = true,
			incomming_spooc = true,
			incomming_shield = true,
			incomming_taser = true,
			entry = true,
			aggressive_assault = true,
			retreat = true,
			contact = true,
			clear = true,
			clear_whisper = true,
			go_go = true,
			push = true,
			reload = true,
			look_for_angle = true,
			ecm = true,
			saw = true,
			trip_mines = true,
			sentry = true,
			ready = true,
			smoke = true,
			flash_grenade = true,
			follow_me = true,
			deathguard = true,
			open_fire = true,
			suppress = true
		},
		omnia_lpf = {
			aggressive = true,
			retreat = true,
			contact = true,
			clear = true,
			clear_whisper = true,
			heal_chatter = true,
			go_go = true,
			push = true,
			reload = true,
			look_for_angle = true,
			ecm = true,
			saw = true,
			trip_mines = true,
			sentry = true,
			ready = true,
			smoke = true,
			flash_grenade = true,
			follow_me = true,
			suppress = true
		},			
		summers = {
			aggressive = true,
			retreat = true,
			contact = true,
			clear = true,
			clear_whisper = true,
			go_go = true,
			push = true,
			reload = true,
			look_for_angle = true,
			ecm = true,
			saw = true,
			trip_mines = true,
			sentry = true,
			ready = true,
			smoke = true,
			flash_grenade = true,
			follow_me = true,
			suppress = true
		},
		shield = {
			entry = true,
			aggressive = true,
			enemyidlepanic = true,
			controlpanic = true,
			dodge = true,
			cuffed = true,
			incomming_captain = true,
			incomming_gren = true,
			incomming_tank = true,
			incomming_spooc = true,
			incomming_taser = true,
			entry = true,
			aggressive_assault = true,
			retreat = true,
			contact = true,
			clear = true,
			clear_whisper = true,
			go_go = true,
			push = true,
			reload = true,
			look_for_angle = true,
			ecm = true,
			saw = true,
			trip_mines = true,
			sentry = true,
			ready = true,
			smoke = true,
			flash_grenade = true,
			follow_me = true,
			deathguard = true,
			open_fire = true,
			suppress = true
		},
		cloaker = {
			contact = true,
			cloakercontact = true,
			cloakeravoidance = true,
			aggressive = true
		},			
	}
	
	presets.hurt_severities = {}
	presets.hurt_severities.no_hurts = {
		bullet = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		explosion = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		melee = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		fire = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		poison = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		bleed = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		tase = false
	}
	presets.hurt_severities.only_light_hurt_no_explode = {
		bullet = {
			health_reference = 1,
			zones = {
				{light = 1}
			}
		},
		explosion = {
			health_reference = 1,
			zones = {
				{light = 1}
			}
		},
		melee = {
			health_reference = 1,
			zones = {
				{light = 1}
			}
		},
		fire = {
			health_reference = 1,
			zones = {
				{light = 1}
			}
		},
		poison = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		bleed = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		tase = false
	}	
	presets.hurt_severities.titan = deep_clone(presets.hurt_severities.no_hurts)
	presets.hurt_severities.titan.bullet = {
			health_reference = "current",
			zones = {
				{
					light = 0.995,
					explode = 0.005
				}
			}
	}
	presets.hurt_severities.titan.fire = {
			health_reference = "current",
			zones = {
				{light = 1}
			}
	}
	presets.hurt_severities.titan.explosion = {
			health_reference = "current",
			zones = {
				{light = 1}
			}
	}
	presets.hurt_severities.captain = deep_clone(presets.hurt_severities.titan)
	presets.hurt_severities.captain.bullet = {
			health_reference = "current",
			zones = {
				{
					light = 0.995,
					explode = 0.005
				}
			}
	}	
	presets.hurt_severities.boss = deep_clone(presets.hurt_severities.titan)
	presets.hurt_severities.boss.bullet = {
			health_reference = "current",
			zones = {
				{
					light = 0.995,
					moderate = 0.005
				}
			}
	}		
	presets.hurt_severities.no_hurts_no_tase = deep_clone(presets.hurt_severities.no_hurts)
	presets.hurt_severities.no_hurts_no_tase.tase = false
	presets.hurt_severities.only_light_hurt = {
		bullet = {
			health_reference = 1,
			zones = {
				{light = 1}
			}
		},
		explosion = {
			health_reference = 1,
			zones = {
				{explode = 1}
			}
		},
		melee = {
			health_reference = 1,
			zones = {
				{light = 1}
			}
		},
		fire = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		poison = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		bleed = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		tase = true
	}
	presets.hurt_severities.only_light_hurt_and_fire = {
		bullet = {
			health_reference = 1,
			zones = {
				{light = 1}
			}
		},
		explosion = {
			health_reference = 1,
			zones = {
				{explode = 1}
			}
		},
		melee = {
			health_reference = 1,
			zones = {
				{light = 1}
			}
		},
		fire = {
			health_reference = 1,
			zones = {
				{fire = 1}
			}
		},
		poison = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		bleed = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		tase = true
	}
	presets.hurt_severities.light_hurt_fire_poison = deep_clone(presets.hurt_severities.only_light_hurt_and_fire)
	presets.hurt_severities.light_hurt_fire_poison.poison = {
		health_reference = 1,
		zones = {
			{poison = 1}
		}
	}
	presets.hurt_severities.elite = deep_clone(presets.hurt_severities.light_hurt_fire_poison)
	presets.hurt_severities.elite.fire = {
		health_reference = 1,
		zones = {
			{none = 1}
		}
	}
	presets.hurt_severities.elite.melee = {
		health_reference = "current",
		zones = {
			{
				health_limit = 0.3,
				none = 0.3,
				light = 0.7,
				moderate = 0,
				heavy = 0
			},
			{
				health_limit = 0.8,
				light = 1,
				moderate = 0,
				heavy = 0
			},
			{
				health_limit = 0.9,
				light = 0.8,
				moderate = 0.2,
				heavy = 0
			},
			{
				light = 0,
				moderate = 9,
				heavy = 0
			}
		}
	}
	presets.hurt_severities.elite_easy = deep_clone(presets.hurt_severities.light_hurt_fire_poison)
	presets.hurt_severities.elite_easy.fire = {
		health_reference = "current",
		zones = {
			{
				health_limit = 0.3,
				none = 0.2,
				light = 0.7,
				fire = 0.05
			},
			{
				health_limit = 0.6,
				light = 0.4,
				fire = 0.4
			},
			{
				health_limit = 0.9,
				light = 0.2,
				fire = 0.2
			},
			{
				light = 0,
				fire = 1
			}
		}
	}
	presets.hurt_severities.elite_easy.bullet = {
		health_reference = "current",
		zones = {
			{
				health_limit = 0.3,
				none = 0.2,
				light = 0.7,
				moderate = 0.05,
				heavy = 0
			},
			{
				health_limit = 0.6,
				light = 0.4,
				moderate = 0.4,
				heavy = 0
			},
			{
				health_limit = 0.9,
				light = 0.2,
				moderate = 0.2,
				heavy = 0
			},
			{
				light = 0,
				moderate = 1,
				heavy = 0
			}
		}
	}	
	presets.hurt_severities.elite_easy.melee = {
		health_reference = "current",
		zones = {
			{
				health_limit = 0.3,
				none = 0.3,
				light = 0.7,
				moderate = 0,
				heavy = 0
			},
			{
				health_limit = 0.8,
				light = 1,
				moderate = 0,
				heavy = 0
			},
			{
				health_limit = 0.9,
				light = 0.8,
				moderate = 0.2,
				heavy = 0
			},
			{
				light = 0,
				moderate = 9,
				heavy = 0
			}
		}
	}		
	presets.hurt_severities.only_explosion_hurts = {
		bullet = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		explosion = {
			health_reference = 1,
			zones = {
				{explode = 1}
			}
		},
		melee = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		fire = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		poison = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		bleed = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		tase = true
	}
	presets.hurt_severities.only_fire_and_poison_hurts = {
		bullet = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		explosion = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		melee = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		fire = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		poison = {
			health_reference = 1,
			zones = {
				{poison = 1}
			}
		},
		bleed = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		tase = true
	}
	presets.hurt_severities.base = {
		bullet = {
			health_reference = "current",
			zones = {
				{
					health_limit = 0.3,
					none = 0.2,
					light = 0.7,
					moderate = 0.05,
					heavy = 0.05
				},
				{
					health_limit = 0.6,
					light = 0.4,
					moderate = 0.4,
					heavy = 0.2
				},
				{
					health_limit = 0.9,
					light = 0.2,
					moderate = 0.2,
					heavy = 0.6
				},
				{
					light = 0,
					moderate = 0,
					heavy = 1
				}
			}
		},
		explosion = {
			health_reference = "current",
			zones = {
				{
					health_limit = 0.2,
					none = 0.6,
					heavy = 0.4
				},
				{
					health_limit = 0.5,
					heavy = 0.6,
					explode = 0.4
				},
				{heavy = 0.2, explode = 0.8}
			}
		},
		melee = {
			health_reference = "current",
			zones = {
				{
					health_limit = 0.3,
					none = 0.3,
					light = 0.7,
					moderate = 0,
					heavy = 0
				},
				{
					health_limit = 0.8,
					light = 1,
					moderate = 0,
					heavy = 0
				},
				{
					health_limit = 0.9,
					light = 0.6,
					moderate = 0.2,
					heavy = 0.2
				},
				{
					light = 0,
					moderate = 0,
					heavy = 9
				}
			}
		},
		fire = {
			health_reference = "current",
			zones = {
				{fire = 1}
			}
		},
		poison = {
			health_reference = "current",
			zones = {
				{none = 0, poison = 1}
			}
		},
		bleed = {
			health_reference = "current",
			zones = {
				{none = 1}
			}
		},
		tase = true
	}
	presets.hurt_severities.heavy = deep_clone(presets.hurt_severities.base)
	presets.hurt_severities.heavy.bullet = {
		health_reference = "current",
		zones = {
			{
				health_limit = 0.3,
				none = 0.2,
				light = 0.7,
				moderate = 0.1
			},
			{
				health_limit = 0.6,
				light = 0.4,
				moderate = 0.6
			},
			{
				health_limit = 0.9,
				light = 0.2,
				moderate = 0.8
			},
			{
				light = 0,
				moderate = 1,
				heavy = 0
			}
		}
	}	
	presets.hurt_severities.spooc = deep_clone(presets.hurt_severities.base)
	presets.hurt_severities.spooc_titan = deep_clone(presets.hurt_severities.base)
	presets.hurt_severities.spooc_titan.fire = {
		health_reference = 1,
		zones = {
			{none = 1}
		}
	}
	presets.hurt_severities.spooc_titan.melee = {
		health_reference = "current",
		zones = {
			{none = 1}
		}
	}	
	presets.hurt_severities.boom = deep_clone(presets.hurt_severities.base)
	presets.hurt_severities.boom.explosion = {
		health_reference = 1,
		zones = {
			{none = 1}
		}
	}
	presets.hurt_severities.base_no_poison = deep_clone(presets.hurt_severities.base)
	presets.hurt_severities.base_no_poison.poison = {
		health_reference = 1,
		zones = {
			{none = 1}
		}
	}
	presets.base = {}
	presets.base.HEALTH_INIT = 2
	presets.base.headshot_dmg_mul = normal_headshot
	presets.base.use_animation_on_fire_damage = true
	presets.base.SPEED_WALK = {
		ntl = 120,
		hos = 180,
		cbt = 160,
		pnc = 160
	}
	presets.base.SPEED_RUN = 370
	presets.base.chatter = presets.enemy_chatter.no_chatter
	presets.base.crouch_move = true
	presets.base.shooting_death = true
	presets.base.suspicious = true
	presets.base.surrender_break_time = {20, 30}
	presets.base.submission_max = {45, 60}
	presets.base.submission_intimidate = 15
	presets.base.speech_prefix = "po"
	presets.base.speech_prefix_count = 1
	presets.base.follower = false
	presets.base.rescue_hostages = false
	presets.base.use_radio = self._default_chatter
	presets.base.dodge = nil
	presets.base.challenges = {type = "law"}
	presets.base.calls_in = true
	presets.base.ignore_medic_revive_animation = false
	presets.base.spotlight_important = false
	presets.base.experience = {}
	presets.base.experience.cable_tie = "tie_swat"
	presets.base.damage = {}
	presets.base.damage.hurt_severity = presets.hurt_severities.base
	presets.base.damage.death_severity = 0.5
	presets.base.damage.explosion_damage_mul = 1
	presets.base.damage.tased_response = {
		light = {tased_time = 5, down_time = 5},
		heavy = {tased_time = 5, down_time = 10}
	}
	presets.base.static_weapon_preset = false
	presets.base.static_dodge_preset = false
	presets.base.static_melee_preset = false
	presets.gang_member_damage = {}
	presets.gang_member_damage.HEALTH_INIT = 100
	presets.gang_member_damage.no_run_start = true
	presets.gang_member_damage.no_run_stop = true
	presets.gang_member_damage.headshot_dmg_mul = normal_headshot
	presets.gang_member_damage.LIVES_INIT = 4
	presets.gang_member_damage.explosion_damage_mul = 0
	presets.gang_member_damage.REGENERATE_TIME = 5
	presets.gang_member_damage.REGENERATE_TIME_AWAY = 2.5
	presets.gang_member_damage.DOWNED_TIME = tweak_data.player.damage.DOWNED_TIME
	presets.gang_member_damage.TASED_TIME = tweak_data.player.damage.TASED_TIME
	presets.gang_member_damage.BLEED_OUT_HEALTH_INIT = 40
	presets.gang_member_damage.ARRESTED_TIME = 30
	presets.gang_member_damage.INCAPACITATED_TIME = tweak_data.player.damage.INCAPACITATED_TIME
	presets.gang_member_damage.hurt_severity = deep_clone(presets.hurt_severities.no_hurts)
	presets.gang_member_damage.MIN_DAMAGE_INTERVAL = 0.6
	presets.gang_member_damage.respawn_time_penalty = 0
	presets.gang_member_damage.base_respawn_time_penalty = 5
	presets.weapon = {}

	presets.weapon.expert = {}

	--Has quick response in close range, and extremely consistent long range plinking. Generally mediocre and flatish damage to compensate.
	presets.weapon.expert.is_pistol = {
		aim_delay = {0.1, 0.4}, --Delay to acquire target. Scales based on range vs max falloff range.
		focus_delay = 3, --Delay to reach max accuracy and recoil control from when shooting starts.
		focus_dis = 500,
		spread = 8,
		miss_dis = 16, --Distance to offset vector on missed shots.
		RELOAD_SPEED = 1.25,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		range = {
			close = 900, --Should be ~half optimal range.
			optimal = 1800, --Should generally match range where damage falloff kicks in.
			far = 5400 --Should generally match 150% of range where damage falloff kicks in.
		},
		FALLOFF = {
			{
				r = 200,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {0.3, 0.3},
				burst_size = 3
			},
			{
				r = 450,
				acc = {0.3, 0.6},
				dmg_mul = 1,
				recoil = {0.3, 0.3},
				burst_size = 3
			},
			{
				r = 900,
				acc = {0.4, 0.7},
				dmg_mul = 1,
				recoil = {0.4, 0.4},
				burst_size = 3
			},
			{
				r = 901,
				acc = {0.4, 0.7},
				dmg_mul = 1,
				recoil = {0.4, 0.4},
				burst_size = 1
			},
			{
				r = 1800,
				acc = {0.5, 0.8},
				dmg_mul = 1,
				recoil = {0.6, 0.6},
				burst_size = 1
			},
			{
				r = 3600,
				acc = {0.5, 0.8},
				dmg_mul = 0.5,
				recoil = {0.9, 0.9},
				burst_size = 1
			},
			{
				r = 5400,
				acc = {0, 0},
				dmg_mul = 0.0,
				recoil = {1.8, 1.8},
				burst_size = 1
			}
		}
	}

	--Keeps the Pistol's close range responsiveness, but loses the long range plinking via terrible ranged aim delay, and more aggressive falloff.
	--Doubled ROF but reduced accuracy at range, because akimbo.
	presets.weapon.expert.is_akimbo_pistol = {
		aim_delay = {0.1, 0.6},
		focus_delay = 3,
		focus_dis = 500,
		spread = 10,
		miss_dis = 20,
		RELOAD_SPEED = 1,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		range = {
			close = 750,
			optimal = 1500,
			far = 4500
		},
		FALLOFF = {
			{
				r = 200,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {0.15, 0.15},
				burst_size = 4
			},
			{
				r = 325,
				acc = {0.3, 0.6},
				dmg_mul = 1,
				recoil = {0.15, 0.15},
				burst_size = 4
			},
			{
				r = 750,
				acc = {0.275, 0.5},
				dmg_mul = 1,
				recoil = {0.2, 0.2},
				burst_size = 4
			},
			{
				r = 751,
				acc = {0.275, 0.5},
				dmg_mul = 1,
				recoil = {0.2, 0.2},
				burst_size = 1
			},
			{
				r = 1500,
				acc = {0.25, 0.4},
				dmg_mul = 1,
				recoil = {0.3, 0.3},
				burst_size = 1
			},
			{
				r = 3000,
				acc = {0.25, 0.4},
				dmg_mul = 0.5,
				recoil = {0.45, 0.45},
				burst_size = 1
			},
			{
				r = 4500,
				acc = {0, 0},
				dmg_mul = 0.0,
				recoil = {0.9, 0.9},
				burst_size = 1
			}
		}
	}

	--Quick to react. Big damage, fairly inaccurate- especially up close.
	presets.weapon.expert.is_revolver = {
		aim_delay = {0.4, 0.8},
		focus_delay = 3,
		focus_dis = 500,
		spread = 6,
		miss_dis = 24,
		RELOAD_SPEED = 1,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		range = {
			close = 900,
			optimal = 1800,
			far = 5400
		},
		FALLOFF = {
			{
				r = 200,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {0.5, 0.5},
				burst_size = 1
			},
			{
				r = 450,
				acc = {0.15, 0.3},
				dmg_mul = 1,
				recoil = {0.4, 0.4},
				burst_size = 1
			},
			{
				r = 900,
				acc = {0.2, 0.4},
				dmg_mul = 1,
				recoil = {0.55, 0.55},
				burst_size = 1
			},
			{
				r = 1800,
				acc = {0.3, 0.5},
				dmg_mul = 1,
				recoil = {1, 1},
				burst_size = 1
			},
			{
				r = 3600,
				acc = {0.3, 0.5},
				dmg_mul = 0.5,
				recoil = {0.9, 0.9},
				burst_size = 1
			},
			{
				r = 5400,
				acc = {0, 0},
				dmg_mul = 0.0,
				recoil = {1.8, 1.8},
				burst_size = 1
			}
		}
	}

	--Pretty average all-round. Threatening at any range, but not quite as much as more specialized guns.
	presets.weapon.expert.is_rifle = {
		aim_delay = {0.3, 1.5},
		focus_delay = 6,
		focus_dis = 300,
		spread = 10,
		miss_dis = 20,
		RELOAD_SPEED = 0.75,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		range = {
			close = 1125,
			optimal = 2250,
			far = 6750
		},
		FALLOFF = {
			{
				r = 200,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {0.6, 0.6},
				burst_size = 30
			},
			{
				r = 600,
				acc = {0.25, 0.55},
				dmg_mul = 1,
				recoil = {0.6, 0.6},
				burst_size = 30
			},
			{
				r = 601,
				acc = {0.3, 0.7},
				dmg_mul = 1,
				recoil = {0.3, 0.3},
				burst_size = 3
			},
			{
				r = 1125,
				acc = {0.3, 0.7},
				dmg_mul = 1,
				recoil = {0.8, 0.4},
				burst_size = 3
			},
			{
				r = 2250,
				acc = {0.3, 0.7},
				dmg_mul = 1,
				recoil = {0.8, 0.4},
				burst_size = 3
			},
			{
				r = 4500,
				acc = {0.15, 0.35},
				dmg_mul = 0.5,
				recoil = {0.8, 0.4},
				burst_size = 2
			},
			{
				r = 6750,
				acc = {0, 0},
				dmg_mul = 0.0,
				recoil = {0.9, 0.6},
				burst_size = 1
			}
		}
	}

	--Long range burst, takes a while to become accurate enough to hit perfectly consistently, with the time it takes varying based on range. Struggles up close.
	--Abuses acc values > 1 to achieve this.
	presets.weapon.expert.is_dmr = {
		aim_delay = {0.4, 2.0},
		focus_delay = 12,
		focus_dis = 150,
		spread = 10,
		miss_dis = 20,
		RELOAD_SPEED = 0.75,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		range = {
			close = 1500,
			optimal = 3000,
			far = 9000
		},
		FALLOFF = {
			{
				r = 200,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {0.6, 0.3},
				burst_size = 1
			},
			{
				r = 750,
				acc = {0.33, 2.0}, --4 seconds to max acc.
				dmg_mul = 1,
				recoil = {0.8, 0.4},
				burst_size = 1
			},
			{
				r = 1500,
				acc = {0.0, 2.0}, --6 seconds to max acc.
				dmg_mul = 1,
				recoil = {1.6, 0.8},
				burst_size = 1
			},
			{
				r = 3000,
				acc = {0.0, 1.5}, --8 seconds to max acc.
				dmg_mul = 1,
				recoil = {1.6, 0.8},
				burst_size = 1
			},
			{
				r = 6000,
				acc = {0.0, 1.0}, --12 seconds to max acc.
				dmg_mul = 0.5,
				recoil = {1.6, 0.8},
				burst_size = 1
			},
			{
				r = 9000,
				acc = {0, 0},
				dmg_mul = 0.0,
				recoil = {1.8, 1.2},
				burst_size = 1
			}
		}
	}

	--Similar to ARs, but with more threat up close and less from far away.
	presets.weapon.expert.is_smg = {
		aim_delay = {0.2, 1.2},
		focus_delay = 6,
		focus_dis = 400,
		spread = 14,
		miss_dis = 28,
		RELOAD_SPEED = 1,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		range = {
			close = 900,
			optimal = 1800,
			far = 5400
		},
		FALLOFF = {
			{
				r = 200,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {0.3, 0.3},
				burst_size = 30
			},
			{
				r = 450,
				acc = {0.3, 0.9},
				dmg_mul = 1,
				recoil = {0.4, 0.3},
				burst_size = 10
			},
			{
				r = 900,
				acc = {0.25, 0.75},
				dmg_mul = 1,
				recoil = {0.4, 0.3},
				burst_size = 10
			},
			{
				r = 1800,
				acc = {0.2, 0.6},
				dmg_mul = 1,
				recoil = {0.6, 0.4},
				burst_size = 5
			},
			{
				r = 3600,
				acc = {0.1, 0.3},
				dmg_mul = 0.5,
				recoil = {0.9, 0.6},
				burst_size = 3
			},
			{
				r = 5400,
				acc = {0, 0},
				dmg_mul = 0.0,
				recoil = {0.6, 0.3},
				burst_size = 1
			}
		}
	}

	--Focus on suppressing player with high volume+damage inaccurate fire. Players that remain in it too long will get torn apart if the focus_delay is left to tick down.
	presets.weapon.expert.is_lmg = {
		aim_delay = {0.4, 2.0},
		focus_delay = 12,
		focus_dis = 150,
		spread = 16,
		miss_dis = 48,
		RELOAD_SPEED = 0.5,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		range = {
			close = 1125,
			optimal = 2250,
			far = 6750
		},
		FALLOFF = {
			{
				r = 200,
				acc = {0.75, 1.0},
				dmg_mul = 1,
				recoil = {0.4, 0.4},
				burst_size = 30
			},
			{
				r = 600,
				acc = {0.2, 0.7},
				dmg_mul = 1,
				recoil = {0.4, 0.4},
				burst_size = 30
			},
			{
				r = 1125,
				acc = {0.15, 0.6},
				dmg_mul = 1,
				recoil = {0.4, 0.4},
				burst_size = 15
			},
			{
				r = 2250,
				acc = {0.1, 0.5},
				dmg_mul = 1,
				recoil = {0.6, 0.4},
				burst_size = 12
			},
			{
				r = 4500,
				acc = {0.0, 0.4},
				dmg_mul = 0.5,
				recoil = {0.6, 0.4},
				burst_size = 9
			},
			{
				r = 6750,
				acc = {0, 0},
				dmg_mul = 0,
				recoil = {0.9, 0.6},
				burst_size = 6
			}
		}
	}

	--LMG but with more close range grunt and even more extreme stats.
	presets.weapon.expert.is_mini = {
		aim_delay = {0.6, 1.8},
		focus_delay = 12,
		focus_dis = 150,
		spread = 20,
		miss_dis = 48,
		RELOAD_SPEED = 0.5,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		range = {
			close = 1125,
			optimal = 2250,
			far = 6750
		},
		FALLOFF = {
			{
				r = 200,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {1.0, 1.0},
				burst_size = 300
			},
			{
				r = 600,
				acc = {0.5, 1.0},
				dmg_mul = 1,
				recoil = {1.0, 1.0},
				burst_size = 300
			},
			{
				r = 1125,
				acc = {0.0, 0.5},
				dmg_mul = 1,
				recoil = {1.0, 1.0},
				burst_size = 150
			},
			{
				r = 2250,
				acc = {0.0, 0.25},
				dmg_mul = 1,
				recoil = {1.0, 1.0},
				burst_size = 100
			},
			{
				r = 4500,
				acc = {0.0, 0.125},
				dmg_mul = 0.5,
				recoil = {1.0, 1.0},
				burst_size = 75
			},
			{
				r = 6750,
				acc = {0, 0},
				dmg_mul = 0,
				recoil = {1.0, 1.0},
				burst_size = 50
			}
		}
	}

	--Close range burst. Takes a moment to react, but is highly consistent once it does. First shot is usually a warning shot.
	presets.weapon.expert.is_shotgun_pump = {
		aim_delay = {0.2, 0.3},
		focus_delay = 1.5,
		focus_dis = 100,
		spread = 20,
		miss_dis = 20,
		RELOAD_SPEED = 0.4,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		range = {
			close = 400,
			optimal = 800,
			far = 2400
		},
		FALLOFF = {
			{
				r = 400,
				acc = {0.6, 1.0},
				dmg_mul = 1,
				recoil = {0.8, 0.8},
				burst_size = 1
			},
			{
				r = 800,
				acc = {0.0, 1.0},
				dmg_mul = 1,
				recoil = {0.8, 0.8},
				burst_size = 1
			},
			{
				r = 1600,
				acc = {0.0, 0.6},
				dmg_mul = 0.5,
				recoil = {1.4, 0.8},
				burst_size = 1
			},
			{
				r = 2400,
				acc = {0, 0},
				dmg_mul = 0.0,
				recoil = {2, 1},
				burst_size = 1
			}
		}
	}

	--Close range murder if left unchecked. Somewhat inconsistent.
	presets.weapon.expert.is_shotgun_mag = {
		aim_delay = {0.3, 0.4},
		focus_delay = 6,
		focus_dis = 100,
		spread = 20,
		miss_dis = 20,
		RELOAD_SPEED = 0.6,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		range = {
			close = 350,
			optimal = 700,
			far = 2100
		},
		FALLOFF = {
			{
				r = 400,
				acc = {0.6, 1.0},
				dmg_mul = 1,
				recoil = {0.3, 0.3},
				burst_size = 6
			},
			{
				r = 700,
				acc = {0.4, 0.6},
				dmg_mul = 1,
				recoil = {0.5, 0.4},
				burst_size = 4
			},
			{
				r = 1400,
				acc = {0.2, 0.4},
				dmg_mul = 0.5,
				recoil = {1.0, 0.5},
				burst_size = 2
			},
			{
				r = 2100,
				acc = {0, 0},
				dmg_mul = 0,
				recoil = {1.5, 1.0},
				burst_size = 1
			}
		}
	}

	--Murder at <14m. Useless beyond that. Similar to autoshotgun beyond that.
	presets.weapon.expert.is_flamethrower = {
		aim_delay = {0.6, 0.8},
		focus_delay = 1,
		focus_dis = 200,
		spread = 20,
		miss_dis = 20,
		RELOAD_SPEED = 0.4,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		range = {
			close = 700,
			optimal = 1000,
			far = 1500
		},
		FALLOFF = {
			{
				r = 700,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {1, 1},
				burst_size = 100
			},
			{
				r = 1400,
				acc = {1.0, 1.0},
				dmg_mul = 0.4,
				recoil = {1, 1},
				burst_size = 100
			},
			{
				r = 1401,
				acc = {0, 0},
				dmg_mul = 0,
				recoil = {1, 1},
				burst_size = 100
			}
		}
	}

	presets.weapon.good = deep_clone(presets.weapon.expert) --Good presets typically lose reload speed and some reaction speed. But have similar peak perf to expert.
	--preset, accuracy_mul, aim_delay_mul, focus_delay_mul, recoil_mul, reload_speed_mul
	self:_multiply_weapon_preset(presets.weapon.good.is_pistol,        1.00, 1.20, 1.20, 1.00, 0.90)
	self:_multiply_weapon_preset(presets.weapon.good.is_akimbo_pistol, 1.00, 1.15, 1.15, 1.00, 0.80)
	self:_multiply_weapon_preset(presets.weapon.good.is_revolver,      1.00, 1.00, 1.30, 1.00, 0.80)
	self:_multiply_weapon_preset(presets.weapon.good.is_rifle,         1.00, 1.10, 1.30, 1.00, 0.90)
	self:_multiply_weapon_preset(presets.weapon.good.is_dmr,           1.00, 1.00, 1.40, 1.00, 0.90)
	self:_multiply_weapon_preset(presets.weapon.good.is_smg,           1.00, 1.15, 1.20, 1.00, 0.85)
	self:_multiply_weapon_preset(presets.weapon.good.is_lmg,           1.00, 1.10, 1.30, 1.00, 0.80)
	--Minigun retains expert stats
	self:_multiply_weapon_preset(presets.weapon.good.is_shotgun_pump,  1.00, 1.40, 1.00, 1.00, 0.8)
	self:_multiply_weapon_preset(presets.weapon.good.is_shotgun_mag,   1.00, 1.30, 1.10, 1.00, 0.8)
	--Flamethrower retains expert stats

	presets.weapon.normal = deep_clone(presets.weapon.expert) --Normal presets also lose out on effective damage output via longer recoil and/or worse accuracy.
	self:_multiply_weapon_preset(presets.weapon.normal.is_pistol,        1.00, 1.20, 1.20, 1.50, 0.90)
	self:_multiply_weapon_preset(presets.weapon.normal.is_akimbo_pistol, 1.00, 1.15, 1.15, 1.50, 0.80)
	self:_multiply_weapon_preset(presets.weapon.normal.is_revolver,      1.00, 1.00, 1.30, 1.50, 0.80)
	self:_multiply_weapon_preset(presets.weapon.normal.is_rifle,         0.80, 1.10, 1.30, 1.30, 0.90)
	self:_multiply_weapon_preset(presets.weapon.normal.is_dmr,           0.80, 1.00, 1.40, 1.30, 0.90)
	self:_multiply_weapon_preset(presets.weapon.normal.is_smg,           0.70, 1.15, 1.20, 1.20, 0.85)
	self:_multiply_weapon_preset(presets.weapon.normal.is_lmg,           0.90, 1.10, 1.30, 1.40, 0.80)
	--Minigun retains expert stats
	self:_multiply_weapon_preset(presets.weapon.normal.is_shotgun_pump,  1.00, 1.40, 1.00, 1.50, 0.8)
	self:_multiply_weapon_preset(presets.weapon.normal.is_shotgun_mag,   0.70, 1.30, 1.10, 1.20, 0.8)
	--Flamethrower retains expert stats

	presets.weapon.shield = deep_clone(presets.weapon.normal) --Normal, but with no melee attacks.
	for preset_name, preset in pairs(presets.weapon.shield) do
		preset.melee_dmg = nil
		preset.melee_speed = nil
		preset.melee_retry_delay = nil
	end

	presets.weapon.dozer = deep_clone(presets.weapon.good) --Good, but with slow melee attacks.
	for preset_name, preset in pairs(presets.weapon.dozer) do
		preset.melee_speed = 0.6667
		preset.melee_retry_delay = {3, 3}
	end

	presets.weapon.gangster = deep_clone(presets.weapon.normal) --Normal but with 1.5x damage.
	presets.weapon.meme_man = deep_clone(presets.weapon.expert) --Idk yet, gotta think of something dumb.
	presets.weapon.deathwish = deep_clone(presets.weapon.expert) --Unused, needed to prevent crash.
	
	--Will hit every 2.5 seconds after a 3 second wait time.
	presets.weapon.sniper = {}
	presets.weapon.sniper.is_rifle = {
		aim_delay = {3, 3},
		focus_delay = 3,
		focus_dis = 0,
		spread = 0,
		miss_dis = 20,
		RELOAD_SPEED = 1,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		use_laser = true,
		sniper_charge_attack = true,
		range = {
			close = 3000,
			optimal = 6000,
			far = 9000
		},
		FALLOFF = {
			{
				r = 3000,
				acc = {1, 1},
				dmg_mul = 1,
				recoil = {2.5, 2.5},
				burst_size = 1
			},
			{
				r = 6000,
				acc = {1, 1},
				dmg_mul = 0.9,
				recoil = {2.5, 2.5},
				burst_size = 1
			},
			{
				r = 9000,
				acc = {1, 1},
				dmg_mul = 0.8,
				recoil = {2.5, 2.5},
				burst_size = 1
			},
			{
				r = 18000,
				acc = {1, 1},
				dmg_mul = 0.7,
				recoil = {2.5, 2.5},
				burst_size = 1
			},
		}
	}

	--Bot weapon presets
	presets.weapon.gang_member = deep_clone(presets.weapon.expert)

	presets.weapon.gang_member.is_pistol = {
		aim_delay = {0.2, 0.6},
		focus_delay = 2,
		focus_dis = 600,
		spread = 6,
		miss_dis = 12,
		RELOAD_SPEED = 1.5,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		crew = true,
		range = {
			close = 1125,
			optimal = 2250,
			far = 6750
		},
		FALLOFF = {
			{ --200 dps.
				r = 300,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {0.3, 0.3},
				burst_size = 1
			},
			{ --80/160 dps
				r = 600,
				acc = {0.5, 1.0},
				dmg_mul = 1,
				recoil = {0.3, 0.3},
				burst_size = 1
			},
			{ --60/120 dps
				r = 1125,
				acc = {0.4, 0.8},
				dmg_mul = 1,
				recoil = {0.3, 0.3},
				burst_size = 1
			},
			{ --40/80 dps
				r = 2250,
				acc = {0.4, 0.8},
				dmg_mul = 1,
				recoil = {0.45, 0.45},
				burst_size = 1
			},
			{ --10/20 dps
				r = 4500,
				acc = {0.3, 0.6},
				dmg_mul = 0.5,
				recoil = {0.9, 0.9},
				burst_size = 1
			},
			{
				r = 6750,
				acc = {0, 0},
				dmg_mul = 0.0,
				recoil = {1.8, 1.8},
				burst_size = 1
			}
		}
	}

	presets.weapon.gang_member.is_revolver = {
		aim_delay = {0.2, 0.6},
		focus_delay = 2,
		focus_dis = 600,
		spread = 6,
		miss_dis = 12,
		RELOAD_SPEED = 0.4,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		crew = true,
		range = {
			close = 1125,
			optimal = 2250,
			far = 6750
		},
		FALLOFF = {
			{ --200 dps.
				r = 300,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {0.5, 0.5},
				burst_size = 1
			},
			{ --80/160 dps
				r = 600,
				acc = {0.5, 1.0},
				dmg_mul = 1,
				recoil = {0.5, 0.5},
				burst_size = 1
			},
			{ --60/120 dps
				r = 1125,
				acc = {0.4, 0.8},
				dmg_mul = 1,
				recoil = {0.5, 0.5},
				burst_size = 1
			},
			{ --40/80 dps
				r = 2250,
				acc = {0.4, 0.8},
				dmg_mul = 1,
				recoil = {0.75, 0.75},
				burst_size = 1
			},
			{ --10/20 dps
				r = 4500,
				acc = {0.3, 0.6},
				dmg_mul = 0.5,
				recoil = {1.5, 1.5},
				burst_size = 1
			},
			{
				r = 6750,
				acc = {0, 0},
				dmg_mul = 0.0,
				recoil = {1.8, 1.8},
				burst_size = 1
			}
		}
	}

	presets.weapon.gang_member.is_rifle = {
		aim_delay = {0.4, 1.2},
		focus_delay = 4,
		focus_dis = 450,
		spread = 8,
		miss_dis = 16,
		RELOAD_SPEED = 1,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		crew = true,
		range = {
			close = 1400,
			optimal = 2800,
			far = 8400
		},
		FALLOFF = {
			{
				r = 350,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {0.6, 0.6},
				burst_size = 30
			},
			{
				r = 700,
				acc = {0.176, 0.528},
				dmg_mul = 1,
				recoil = {0.6, 0.6},
				burst_size = 30
			},
			{
				r = 701,
				acc = {0.225, 0.675},
				dmg_mul = 1,
				recoil = {0.3, 0.3},
				burst_size = 3
			},
			{
				r = 1400,
				acc = {0.2, 0.6},
				dmg_mul = 1,
				recoil = {0.3, 0.3},
				burst_size = 3
			},
			{
				r = 2800,
				acc = {0.15, 0.45},
				dmg_mul = 1,
				recoil = {0.45, 0.45},
				burst_size = 3
			},
			{
				r = 5600,
				acc = {0.1, 0.3},
				dmg_mul = 0.5,
				recoil = {0.6, 0.6},
				burst_size = 2
			},
			{
				r = 8400,
				acc = {0, 0},
				dmg_mul = 0.0,
				recoil = {1.2, 1.2},
				burst_size = 1
			}
		}
	}

	presets.weapon.gang_member.is_rifle_underbarrel = {
		aim_delay = {0.4, 1.2},
		focus_delay = 4,
		focus_dis = 450,
		spread = 8,
		miss_dis = 16,
		RELOAD_SPEED = 1,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		grenade = gang_member_launcher_frag,
		crew = true,
		range = {
			close = 1400,
			optimal = 2800,
			far = 8400
		},
		FALLOFF = {
			{
				r = 350,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {0.6, 0.6},
				burst_size = 3
			},
			{
				r = 700,
				acc = {0.201, 0.603},
				dmg_mul = 1,
				recoil = {0.6, 0.6},
				burst_size = 3
			},
			{
				r = 701,
				acc = {0.225, 0.675},
				dmg_mul = 1,
				recoil = {0.3, 0.3},
				burst_size = 2
			},
			{
				r = 1400,
				acc = {0.2, 0.6},
				dmg_mul = 1,
				recoil = {0.3, 0.3},
				burst_size = 2
			},
			{
				r = 2800,
				acc = {0.15, 0.45},
				dmg_mul = 1,
				recoil = {0.45, 0.45},
				burst_size = 2
			},
			{
				r = 5600,
				acc = {0.1, 0.3},
				dmg_mul = 0.5,
				recoil = {0.6, 0.6},
				burst_size = 2
			},
			{
				r = 8400,
				acc = {0, 0},
				dmg_mul = 0.0,
				recoil = {1.2, 1.2},
				burst_size = 1
			}
		}
	}

	presets.weapon.gang_member.is_smg = {
		aim_delay = {0.2, 0.6},
		focus_delay = 2,
		focus_dis = 600,
		spread = 10,
		miss_dis = 20,
		RELOAD_SPEED = 1.5,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		crew = true,
		range = {
			close = 1125,
			optimal = 2250,
			far = 6750
		},
		FALLOFF = {
			{
				r = 300,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {0.4, 0.4},
				burst_size = 20
			},
			{
				r = 600,
				acc = {0.3, 0.6},
				dmg_mul = 1,
				recoil = {0.4, 0.4},
				burst_size = 20
			},
			{
				r = 1125,
				acc = {0.25, 0.5},
				dmg_mul = 1,
				recoil = {0.4, 0.4},
				burst_size = 20
			},
			{
				r = 2250,
				acc = {0.14, 0.28},
				dmg_mul = 1,
				recoil = {0.4, 0.4},
				burst_size = 20
			},
			{
				r = 2251,
				acc = {0.19, 0.38},
				dmg_mul = 1,
				recoil = {0.3, 0.3},
				burst_size = 3
			},
			{
				r = 4500,
				acc = {0.1, 0.2},
				dmg_mul = 0.5,
				recoil = {0.6, 0.6},
				burst_size = 3
			},
			{
				r = 6750,
				acc = {0, 0},
				dmg_mul = 0.0,
				recoil = {1.8, 1.8},
				burst_size = 1
			}
		}
	}

	presets.weapon.gang_member.is_lmg = {
		aim_delay = {0.6, 1.8},
		focus_delay = 6,
		focus_dis = 300,
		spread = 12,
		miss_dis = 24,
		RELOAD_SPEED = 0.4,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		crew = true,
		range = {
			close = 1400,
			optimal = 2800,
			far = 8400
		},
		FALLOFF = {
			{
				r = 350,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {1.0, 1.0},
				burst_size = 90
			},
			{
				r = 700,
				acc = {0.2, 0.8},
				dmg_mul = 1,
				recoil = {1.0, 1.0},
				burst_size = 90
			},
			{
				r = 1400,
				acc = {0.15, 0.6},
				dmg_mul = 1,
				recoil = {1.0, 1.0},
				burst_size = 90
			},
			{
				r = 2800,
				acc = {0.06, 0.3},
				dmg_mul = 1,
				recoil = {1.0, 1.0},
				burst_size = 3
			},
			{
				r = 2801,
				acc = {0.1, 0.4},
				dmg_mul = 1,
				recoil = {0.3, 0.3},
				burst_size = 3
			},
			{
				r = 5600,
				acc = {0.05, 0.2},
				dmg_mul = 0.5,
				recoil = {0.6, 0.6},
				burst_size = 3
			},
			{
				r = 8400,
				acc = {0, 0},
				dmg_mul = 0.0,
				recoil = {1.2, 1.2},
				burst_size = 1
			}
		}
	}

	presets.weapon.gang_member.is_dmr = {
		aim_delay = {0.6, 1.8},
		focus_delay = 6,
		focus_dis = 300,
		spread = 4,
		miss_dis = 8,
		RELOAD_SPEED = 1,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		crew = true,
		range = {
			close = 1875,
			optimal = 3750,
			far = 11250
		},
		FALLOFF = {
			{
				r = 470,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {0.5, 0.5},
				burst_size = 1
			},
			{
				r = 940,
				acc = {0.25, 0.75},
				dmg_mul = 1,
				recoil = {0.5, 0.5},
				burst_size = 1
			},
			{
				r = 1875,
				acc = {0.25, 0.75},
				dmg_mul = 1,
				recoil = {0.75, 0.75},
				burst_size = 1
			},
			{
				r = 3750,
				acc = {0.2, 0.6},
				dmg_mul = 1,
				recoil = {1.0, 1.0},
				burst_size = 1
			},
			{
				r = 7500,
				acc = {0.15, 0.45},
				dmg_mul = 0.5,
				recoil = {1.5, 1.5},
				burst_size = 1
			},
			{
				r = 11250,
				acc = {0, 0},
				dmg_mul = 0.0,
				recoil = {1.8, 1.8},
				burst_size = 1
			}
		}
	}

	presets.weapon.gang_member.is_sniper = {
		aim_delay = {0.6, 1.8},
		focus_delay = 6,
		focus_dis = 300,
		spread = 2,
		miss_dis = 6,
		RELOAD_SPEED = 0.7,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		crew = true,
		range = {
			close = 1875,
			optimal = 3750,
			far = 11250
		},
		FALLOFF = {
			{
				r = 470,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {0.75, 0.75},
				burst_size = 1
			},
			{
				r = 940,
				acc = {0.25, 0.75},
				dmg_mul = 1,
				recoil = {0.75, 0.75},
				burst_size = 1
			},
			{
				r = 1875,
				acc = {0.25, 0.75},
				dmg_mul = 1,
				recoil = {1.125, 1.125},
				burst_size = 1
			},
			{
				r = 3750,
				acc = {0.2, 0.6},
				dmg_mul = 1,
				recoil = {1.5, 1.5},
				burst_size = 1
			},
			{
				r = 7500,
				acc = {0.15, 0.45},
				dmg_mul = 0.5,
				recoil = {1.8, 1.8},
				burst_size = 1
			},
			{
				r = 11250,
				acc = {0, 0},
				dmg_mul = 0.0,
				recoil = {1.8, 1.8},
				burst_size = 1
			}
		}
	}

	presets.weapon.gang_member.is_shotgun_mag = {
		aim_delay = {0.6, 1.8},
		focus_delay = 6,
		focus_dis = 300,
		spread = 20,
		miss_dis = 20,
		RELOAD_SPEED = 0.8,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		crew = true,
		range = {
			close = 400,
			optimal = 800,
			far = 2400
		},
		FALLOFF = {
			{
				r = 400,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {0.4, 0.4},
				burst_size = 10
			},
			{
				r = 800,
				acc = {0.75, 1.0},
				dmg_mul = 1,
				recoil = {0.4, 0.4},
				burst_size = 5
			},
			{
				r = 1600,
				acc = {0.4, 1.0},
				dmg_mul = 0.5,
				recoil = {0.4, 0.4},
				burst_size = 2
			},
			{
				r = 2400,
				acc = {0, 0},
				dmg_mul = 0,
				recoil = {0.8, 0.8},
				burst_size = 1
			}
		}
	}

	presets.weapon.gang_member.is_shotgun_pump = {
		aim_delay = {0.4, 1.2},
		focus_delay = 4,
		focus_dis = 450,
		spread = 20,
		miss_dis = 20,
		RELOAD_SPEED = 0.5,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		crew = true,
		range = {
			close = 450,
			optimal = 900,
			far = 3600
		},
		FALLOFF = {
			{
				r = 450,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {0.5, 0.5},
				burst_size = 1
			},
			{
				r = 900,
				acc = {0.75, 1.0},
				dmg_mul = 1,
				recoil = {0.65, 0.65},
				burst_size = 1
			},
			{
				r = 1800,
				acc = {0.4, 0.8},
				dmg_mul = 0.5,
				recoil = {0.8, 0.8},
				burst_size = 1
			},
			{
				r = 3600,
				acc = {0, 0},
				dmg_mul = 0,
				recoil = {1.6, 1.6},
				burst_size = 1
			}
		}
	}

	presets.weapon.gang_member.is_shotgun_double = {
		aim_delay = {0.2, 0.6},
		focus_delay = 2,
		focus_dis = 600,
		spread = 20,
		miss_dis = 20,
		RELOAD_SPEED = 1.2,
		melee_dmg = 1,
		melee_speed = 1,
		melee_retry_delay = {2, 2},
		crew = true,
		range = {
			close = 500,
			optimal = 1000,
			far = 4000
		},
		FALLOFF = {
			{
				r = 500,
				acc = {1.0, 1.0},
				dmg_mul = 1,
				recoil = {0.3, 0.3},
				burst_size = 1
			},
			{
				r = 1000,
				acc = {0.75, 1.0},
				dmg_mul = 1,
				recoil = {0.6, 0.6},
				burst_size = 1
			},
			{
				r = 2000,
				acc = {0.4, 0.8},
				dmg_mul = 0.5,
				recoil = {1.0, 1.0},
				burst_size = 1
			},
			{
				r = 4000,
				acc = {0, 0},
				dmg_mul = 0,
				recoil = {2.0, 2.0},
				burst_size = 1
			}
		}
	}

	presets.detection = {}
	presets.detection.normal = {
		idle = {},
		combat = {},
		recon = {},
		guard = {},
		ntl = {}
	}
	presets.detection.normal.idle.dis_max = 10000
	presets.detection.normal.idle.angle_max = 120
	presets.detection.normal.idle.delay = {0, 0}
	presets.detection.normal.idle.use_uncover_range = true
	presets.detection.normal.combat.dis_max = 10000
	presets.detection.normal.combat.angle_max = 120
	presets.detection.normal.combat.delay = {0, 0}
	presets.detection.normal.combat.use_uncover_range = true
	presets.detection.normal.recon.dis_max = 10000
	presets.detection.normal.recon.angle_max = 120
	presets.detection.normal.recon.delay = {0, 0}
	presets.detection.normal.recon.use_uncover_range = true
	presets.detection.normal.guard.dis_max = 10000
	presets.detection.normal.guard.angle_max = 120
	presets.detection.normal.guard.delay = {0, 0}
	presets.detection.normal.ntl.dis_max = 4000
	presets.detection.normal.ntl.angle_max = 60
	presets.detection.normal.ntl.delay = {0.2, 2}
	presets.detection.normal_undercover = {
		idle = {},
		combat = {},
		recon = {},
		guard = {},
		ntl = {}
	}
	presets.detection.normal_undercover.idle.dis_max = 700
	presets.detection.normal_undercover.idle.angle_max = 60
	presets.detection.normal_undercover.idle.delay = {0, 0}
	presets.detection.normal_undercover.idle.use_uncover_range = false
	presets.detection.normal_undercover.combat.dis_max = 10000
	presets.detection.normal_undercover.combat.angle_max = 120
	presets.detection.normal_undercover.combat.delay = {0, 0}
	presets.detection.normal_undercover.combat.use_uncover_range = true
	presets.detection.normal_undercover.recon.dis_max = 10000
	presets.detection.normal_undercover.recon.angle_max = 120
	presets.detection.normal_undercover.recon.delay = {0, 0}
	presets.detection.normal_undercover.recon.use_uncover_range = true
	presets.detection.normal_undercover.guard.dis_max = 10000
	presets.detection.normal_undercover.guard.angle_max = 120
	presets.detection.normal_undercover.guard.delay = {0, 0}
	presets.detection.normal_undercover.ntl.dis_max = 4000
	presets.detection.normal_undercover.ntl.angle_max = 60
	presets.detection.normal_undercover.ntl.delay = {0.2, 2}
	presets.detection.guard = {
		idle = {},
		combat = {},
		recon = {},
		guard = {},
		ntl = {}
	}
	presets.detection.guard.idle.dis_max = 10000
	presets.detection.guard.idle.angle_max = 120
	presets.detection.guard.idle.delay = {0, 0}
	presets.detection.guard.idle.use_uncover_range = true
	presets.detection.guard.combat.dis_max = 10000
	presets.detection.guard.combat.angle_max = 120
	presets.detection.guard.combat.delay = {0, 0}
	presets.detection.guard.combat.use_uncover_range = true
	presets.detection.guard.recon.dis_max = 10000
	presets.detection.guard.recon.angle_max = 120
	presets.detection.guard.recon.delay = {0, 0}
	presets.detection.guard.recon.use_uncover_range = true
	presets.detection.guard.guard.dis_max = 10000
	presets.detection.guard.guard.angle_max = 120
	presets.detection.guard.guard.delay = {0, 0}
	presets.detection.guard.ntl = presets.detection.normal.ntl
	presets.detection.sniper = {
		idle = {},
		combat = {},
		recon = {},
		guard = {},
		ntl = {}
	}
	presets.detection.sniper.idle.dis_max = 10000
	presets.detection.sniper.idle.angle_max = 180
	presets.detection.sniper.idle.delay = {0.5, 1}
	presets.detection.sniper.idle.use_uncover_range = true
	presets.detection.sniper.combat.dis_max = 10000
	presets.detection.sniper.combat.angle_max = 120
	presets.detection.sniper.combat.delay = {0.5, 1}
	presets.detection.sniper.combat.use_uncover_range = true
	presets.detection.sniper.recon.dis_max = 10000
	presets.detection.sniper.recon.angle_max = 120
	presets.detection.sniper.recon.delay = {0.5, 1}
	presets.detection.sniper.recon.use_uncover_range = true
	presets.detection.sniper.guard.dis_max = 10000
	presets.detection.sniper.guard.angle_max = 150
	presets.detection.sniper.guard.delay = {0.3, 1}
	presets.detection.sniper.ntl = presets.detection.normal.ntl
	presets.detection.gang_member = {
		idle = {},
		combat = {},
		recon = {},
		guard = {},
		ntl = {}
	}
	presets.detection.gang_member.idle.dis_max = 10000
	presets.detection.gang_member.idle.angle_max = 240
	presets.detection.gang_member.idle.delay = {0, 0}
	presets.detection.gang_member.idle.use_uncover_range = true
	presets.detection.gang_member.combat.dis_max = 10000
	presets.detection.gang_member.combat.angle_max = 240
	presets.detection.gang_member.combat.delay = {0, 0}
	presets.detection.gang_member.combat.use_uncover_range = true
	presets.detection.gang_member.recon.dis_max = 10000
	presets.detection.gang_member.recon.angle_max = 240
	presets.detection.gang_member.recon.delay = {0, 0}
	presets.detection.gang_member.recon.use_uncover_range = true
	presets.detection.gang_member.guard.dis_max = 10000
	presets.detection.gang_member.guard.angle_max = 240
	presets.detection.gang_member.guard.delay = {0, 0}
	presets.detection.gang_member.ntl = presets.detection.normal.ntl
	presets.detection.civilian = {
		cbt = {},
		ntl = {}
	}
	presets.detection.civilian.cbt.dis_max = 700
	presets.detection.civilian.cbt.angle_max = 120
	presets.detection.civilian.cbt.delay = {0, 0}
	presets.detection.civilian.cbt.use_uncover_range = true
	presets.detection.civilian.ntl.dis_max = 2000
	presets.detection.civilian.ntl.angle_max = 60
	presets.detection.civilian.ntl.delay = {0.2, 3}
	presets.detection.blind = {
		idle = {},
		combat = {},
		recon = {},
		guard = {},
		ntl = {}
	}
	presets.detection.blind.idle.dis_max = 1
	presets.detection.blind.idle.angle_max = 0
	presets.detection.blind.idle.delay = {0, 0}
	presets.detection.blind.idle.use_uncover_range = false
	presets.detection.blind.combat.dis_max = 1
	presets.detection.blind.combat.angle_max = 0
	presets.detection.blind.combat.delay = {0, 0}
	presets.detection.blind.combat.use_uncover_range = false
	presets.detection.blind.recon.dis_max = 1
	presets.detection.blind.recon.angle_max = 0
	presets.detection.blind.recon.delay = {0, 0}
	presets.detection.blind.recon.use_uncover_range = false
	presets.detection.blind.guard.dis_max = 1
	presets.detection.blind.guard.angle_max = 0
	presets.detection.blind.guard.delay = {0, 0}
	presets.detection.blind.guard.use_uncover_range = false
	presets.detection.blind.ntl.dis_max = 1
	presets.detection.blind.ntl.angle_max = 0
	presets.detection.blind.ntl.delay = {0, 0}
	presets.detection.blind.ntl.use_uncover_range = false
	presets.dodge = {
		poor = {
			speed = 1,
			occasions = {
				hit = {
					chance = 0.8,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 1,
							timeout = {2, 3}
						}
					}
				},
				scared = {
					chance = 0.8,
					check_timeout = {1, 2},
					variations = {
						side_step = {
							chance = 1,
							timeout = {2, 3}
						}
					}
				}
			}
		},
		average = {
			speed = 1,
			occasions = {
				hit = {
					chance = 0.8,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 1,
							timeout = {2, 3}
						}
					}
				},
				scared = {
					chance = 0.8,
					check_timeout = {4, 7},
					variations = {
						dive = {
							chance = 1,
							timeout = {5, 8}
						}
					}
				}
			}
		},
		heavy = {
			speed = 1,
			occasions = {
				hit = {
					chance = 0.65,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 9,
							timeout = {0, 7},
							shoot_chance = 0.8,
							shoot_accuracy = 0.5
						},
						roll = {
							chance = 1,
							timeout = {8, 10}
						}
					}
				},
				preemptive = {
					chance = 0.325,
					check_timeout = {1, 7},
					variations = {
						side_step = {
							chance = 1,
							timeout = {1, 7},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						}
					}
				},
				scared = {
					chance = 0.65,
					check_timeout = {1, 2},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.5,
							shoot_accuracy = 0.4
						},
						roll = {
							chance = 1,
							timeout = {8, 10}
						},
						dive = {
							chance = 2,
							timeout = {8, 10}
						}
					}
				}
			}
		},
		athletic = {
			speed = 1.1,
			occasions = {
				hit = {
					chance = 0.9,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 3},
							shoot_chance = 0.8,
							shoot_accuracy = 0.5
						},
						roll = {
							chance = 1,
							timeout = {3, 4}
						}
					}
				},
				preemptive = {
					chance = 0.45,
					check_timeout = {2, 3},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						},
						roll = {
							chance = 1,
							timeout = {3, 4}
						}
					}
				},
				scared = {
					chance = 0.9,
					check_timeout = {1, 2},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.5,
							shoot_accuracy = 0.4
						},
						roll = {
							chance = 3,
							timeout = {3, 5}
						},
						dive = {
							chance = 1,
							timeout = {3, 5}
						}
					}
				}
			}
		},
		athletic_very_hard = {
			speed = 1,
			occasions = {
				hit = {
					chance = 1,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 3},
							shoot_chance = 0.8,
							shoot_accuracy = 0.5
						},
						roll = {
							chance = 1,
							timeout = {3, 4}
						}
					}
				},
				preemptive = {
					chance = 0.5,
					check_timeout = {1, 2},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						},
						roll = {
							chance = 1,
							timeout = {3, 4}
						}
					}
				},
				scared = {
					chance = 1,
					check_timeout = {0, 1},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.5,
							shoot_accuracy = 0.4
						},
						roll = {
							chance = 3,
							timeout = {3, 5}
						},
						dive = {
							chance = 1,
							timeout = {3, 5}
						}
					}
				}
			}
		},
		heavy_very_hard = {
			speed = 0.9,
			occasions = {
				hit = {
					chance = 0.75,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 9,
							timeout = {0, 7},
							shoot_chance = 0.8,
							shoot_accuracy = 0.5
						},
						roll = {
							chance = 1,
							timeout = {8, 10}
						}
					}
				},
				preemptive = {
					chance = 0.375,
					check_timeout = {0, 6},
					variations = {
						side_step = {
							chance = 1,
							timeout = {1, 7},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						}
					}
				},
				scared = {
					chance = 0.75,
					check_timeout = {0, 1},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.5,
							shoot_accuracy = 0.4
						},
						roll = {
							chance = 1,
							timeout = {8, 10}
						},
						dive = {
							chance = 2,
							timeout = {8, 10}
						}
					}
				}
			}
		},
		athletic_overkill = {
			speed = 1.1,
			occasions = {
				hit = {
					chance = 1,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 3},
							shoot_chance = 0.8,
							shoot_accuracy = 0.5
						},
						roll = {
							chance = 1,
							timeout = {3, 4}
						}
					}
				},
				preemptive = {
					chance = 0.75,
					check_timeout = {0, 1},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						},
						roll = {
							chance = 1,
							timeout = {3, 4}
						}
					}
				},
				scared = {
					chance = 1,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.5,
							shoot_accuracy = 0.4
						},
						roll = {
							chance = 3,
							timeout = {3, 5}
						},
						dive = {
							chance = 1,
							timeout = {3, 5}
						}
					}
				}
			}
		},
		heavy_overkill = {
			speed = 1,
			occasions = {
				hit = {
					chance = 0.75,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 9,
							timeout = {0, 7},
							shoot_chance = 0.8,
							shoot_accuracy = 0.5
						},
						roll = {
							chance = 1,
							timeout = {8, 10}
						}
					}
				},
				preemptive = {
					chance = 0.5,
					check_timeout = {0, 5},
					variations = {
						side_step = {
							chance = 1,
							timeout = {1, 7},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						}
					}
				},
				scared = {
					chance = 0.75,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.5,
							shoot_accuracy = 0.4
						},
						roll = {
							chance = 1,
							timeout = {8, 10}
						},
						dive = {
							chance = 2,
							timeout = {8, 10}
						}
					}
				}
			}
		},		
		ninja = {
			speed = 1.6,
			occasions = {
				hit = {
					chance = 0.9,
					check_timeout = {0, 3},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						},
						roll = {
							chance = 1,
							timeout = {1.2, 2}
						},
						wheel = {
							chance = 2,
							timeout = {1.2, 2}
						}
					}
				},
				preemptive = {
					chance = 0.7,
					check_timeout = {0, 3},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.8
						},
						roll = {
							chance = 1,
							timeout = {1.2, 2}
						},
						wheel = {
							chance = 2,
							timeout = {1.2, 2}
						}
					}
				},
				scared = {
					chance = 0.9,
					check_timeout = {0, 3},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.8,
							shoot_accuracy = 0.6
						},
						roll = {
							chance = 3,
							timeout = {1.2, 2}
						},
						wheel = {
							chance = 3,
							timeout = {1.2, 2}
						},
						dive = {
							chance = 1,
							timeout = {1.2, 2}
						}
					}
				}
			}
		},
		autumn = {
			speed = 1.6,
			occasions = {
				hit = {
					chance = 1,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						},
						roll = {
							chance = 1,
							timeout = {1.2, 2}
						},
						wheel = {
							chance = 2,
							timeout = {1.2, 2}
						}
					}
				},
				preemptive = {
					chance = 0.9,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.8
						},
						roll = {
							chance = 1,
							timeout = {1.2, 2}
						},
						wheel = {
							chance = 2,
							timeout = {1.2, 2}
						}
					}
				},
				scared = {
					chance = 0.9,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.8,
							shoot_accuracy = 0.6
						},
						roll = {
							chance = 3,
							timeout = {1.2, 2}
						},
						wheel = {
							chance = 3,
							timeout = {1.2, 2}
						},
						dive = {
							chance = 1,
							timeout = {1.2, 2}
						}
					}
				}
			}
		},			
		deathwish = {
			speed = 1.3,
			occasions = {
				hit = {
					chance = 1,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						},
						roll = {
							chance = 1,
							timeout = {1.2, 2}
						}
					}
				},
				preemptive = {
					chance = 1,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.8
						},
						roll = {
							chance = 1,
							timeout = {1.2, 2}
						}
					}
				},
				scared = {
					chance = 1,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.8,
							shoot_accuracy = 0.6
						},
						roll = {
							chance = 3,
							timeout = {1.2, 2}
						},
						dive = {
							chance = 1,
							timeout = {1.2, 2}
						}
					}
				}
			}
		},
		elite = {
			speed = 1.3,
			occasions = {
				hit = {
					chance = 1,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						},
						roll = {
							chance = 1,
							timeout = {1.2, 2}
						}
					}
				},
				preemptive = {
					chance = 0.9,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.8
						},
						roll = {
							chance = 1,
							timeout = {1.2, 2}
						}
					}
				},
				scared = {
					chance = 1,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.8,
							shoot_accuracy = 0.6
						},
						roll = {
							chance = 3,
							timeout = {1.2, 2}
						},
						dive = {
							chance = 1,
							timeout = {1.2, 2}
						}
					}
				}
			}
		},
		veteran = {
			speed = 1.6,
			occasions = {
				hit = {
					chance = 1,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 1},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						},
						roll = {
							chance = 1,
							timeout = {1, 1}
						},
						wheel = {
							chance = 2,
							timeout = {1, 1}
						}
					}
				},
				preemptive = {
					chance = 1,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 1},
							shoot_chance = 1,
							shoot_accuracy = 0.8
						},
						roll = {
							chance = 1,
							timeout = {1, 1}
						},
						wheel = {
							chance = 2,
							timeout = {1, 1}
						}
					}
				},
				scared = {
					chance = 1,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 1},
							shoot_chance = 0.8,
							shoot_accuracy = 0.6
						},
						roll = {
							chance = 3,
							timeout = {1, 1}
						},
						wheel = {
							chance = 3,
							timeout = {1, 1}
						},
						dive = {
							chance = 1,
							timeout = {1, 1}
						}
					}
				}
			}
		}
	}
	for preset_name, preset_data in pairs(presets.dodge) do
		for reason_name, reason_data in pairs(preset_data.occasions) do
			local total_w = 0
			for variation_name, variation_data in pairs(reason_data.variations) do
				total_w = total_w + variation_data.chance
			end
			if total_w > 0 then
				for variation_name, variation_data in pairs(reason_data.variations) do
					variation_data.chance = variation_data.chance / total_w
				end
			end
		end
	end
	presets.move_speed = {
		civ_fast = {
			stand = {
				walk = {
					ntl = {
						fwd = 150,
						strafe = 120,
						bwd = 100
					},
					hos = {
						fwd = 210,
						strafe = 190,
						bwd = 160
					},
					cbt = {
						fwd = 210,
						strafe = 175,
						bwd = 160
					}
				},
				run = {
					hos = {
						fwd = 500,
						strafe = 192,
						bwd = 230
					},
					cbt = {
						fwd = 500,
						strafe = 250,
						bwd = 230
					}
				}
			},
			crouch = {
				walk = {
					hos = {
						fwd = 174,
						strafe = 160,
						bwd = 163
					},
					cbt = {
						fwd = 174,
						strafe = 160,
						bwd = 163
					}
				},
				run = {
					hos = {
						fwd = 312,
						strafe = 245,
						bwd = 260
					},
					cbt = {
						fwd = 312,
						strafe = 245,
						bwd = 260
					}
				}
			}
		},
		gang_member = {
			stand = {
				walk = {
					ntl = {
						fwd = 150,
						strafe = 150,
						bwd = 150
					},
					hos = {
						fwd = 437.5,
						strafe = 437.5,
						bwd = 437.5
					},
					cbt = {
						fwd = 437.5,
						strafe = 437.5,
						bwd = 437.5
					}
				},
				run = {
					hos = {
						fwd = 718.75,
						strafe = 718.75,
						bwd = 718.75
					},
					cbt = {
						fwd = 718.75,
						strafe = 718.75,
						bwd = 718.75
					}
				}
			},
			crouch = {
				walk = {
					hos = {
						fwd = 281.25,
						strafe = 281.25,
						bwd = 281.25
					},
					cbt = {
						fwd = 281.25,
						strafe = 281.25,
						bwd = 281.25
					}
				},
				run = {
					hos = {
						fwd = 281.25,
						strafe = 281.25,
						bwd = 281.25
					},
					cbt = {
						fwd = 281.25,
						strafe = 281.25,
						bwd = 281.25
					}
				}
			}
		},
		lightning = {
			stand = {
				walk = {
					ntl = {
						fwd = 150,
						strafe = 120,
						bwd = 110
					},
					hos = {
						fwd = 350,
						strafe = 350,
						bwd = 350
					},
					cbt = {
						fwd = 350,
						strafe = 350,
						bwd = 350
					}
				},
				run = {
					hos = {
						fwd = 800,
						strafe = 350,
						bwd = 350
					},
					cbt = {
						fwd = 800,
						strafe = 350,
						bwd = 350
					}
				}
			},
			crouch = {
				walk = {
					hos = {
						fwd = 225,
						strafe = 225,
						bwd = 225
					},
					cbt = {
						fwd = 225,
						strafe = 225,
						bwd = 225
					}
				},
				run = {
					hos = {
						fwd = 360,
						strafe = 225,
						bwd = 225
					},
					cbt = {
						fwd = 360,
						strafe = 225,
						bwd = 225
					}
				}
			}
		},
		very_slow = {
			stand = {
				walk = {
					ntl = {
						fwd = 144,
						strafe = 120,
						bwd = 110
					},
					hos = {
						fwd = 144,
						strafe = 144,
						bwd = 144
					},
					cbt = {
						fwd = 144,
						strafe = 144,
						bwd = 144
					}
				},
				run = {
					hos = {
						fwd = 144,
						strafe = 144,
						bwd = 144
					},
					cbt = {
						fwd = 144,
						strafe = 144,
						bwd = 144
					}
				}
			},
			crouch = {
				walk = {
					hos = {
						fwd = 130,
						strafe = 130,
						bwd = 130
					},
					cbt = {
						fwd = 130,
						strafe = 130,
						bwd = 130
					}
				},
				run = {
					hos = {
						fwd = 130,
						strafe = 130,
						bwd = 130
					},
					cbt = {
						fwd = 130,
						strafe = 130,
						bwd = 130
					}
				}
			}
		},
		slow = {
			stand = {
				walk = {
					ntl = {
						fwd = 144,
						strafe = 120,
						bwd = 110
					},
					hos = {
						fwd = 144,
						strafe = 144,
						bwd = 144
					},
					cbt = {
						fwd = 144,
						strafe = 144,
						bwd = 144
					}
				},
				run = {
					hos = {
						fwd = 360,
						strafe = 144,
						bwd = 144
					},
					cbt = {
						fwd = 360,
						strafe = 144,
						bwd = 144
					}
				}
			},
			crouch = {
				walk = {
					hos = {
						fwd = 130,
						strafe = 130,
						bwd = 130
					},
					cbt = {
						fwd = 130,
						strafe = 130,
						bwd = 130
					}
				},
				run = {
					hos = {
						fwd = 208,
						strafe = 130,
						bwd = 130
					},
					cbt = {
						fwd = 208,
						strafe = 130,
						bwd = 130
					}
				}
			}
		},
		normal = {
			stand = {
				walk = {
					ntl = {
						fwd = 150,
						strafe = 120,
						bwd = 110
					},
					hos = {
						fwd = 262,
						strafe = 262,
						bwd = 262
					},
					cbt = {
						fwd = 262,
						strafe = 262,
						bwd = 262
					}
				},
				run = {
					hos = {
						fwd = 431,
						strafe = 262,
						bwd = 262
					},
					cbt = {
						fwd = 431,
						strafe = 262,
						bwd = 262
					}
				}
			},
			crouch = {
				walk = {
					hos = {
						fwd = 168,
						strafe = 168,
						bwd = 168
					},
					cbt = {
						fwd = 168,
						strafe = 168,
						bwd = 168
					}
				},
				run = {
					hos = {
						fwd = 268,
						strafe = 168,
						bwd = 168
					},
					cbt = {
						fwd = 268,
						strafe = 168,
						bwd = 168
					}
				}
			}
		},
		fast = {
			stand = {
				walk = {
					ntl = {
						fwd = 150,
						strafe = 120,
						bwd = 110
					},
					hos = {
						fwd = 297,
						strafe = 297,
						bwd = 297
					},
					cbt = {
						fwd = 297,
						strafe = 297,
						bwd = 297
					}
				},
				run = {
					hos = {
						fwd = 488,
						strafe = 297,
						bwd = 297
					},
					cbt = {
						fwd = 488,
						strafe = 297,
						bwd = 297
					}
				}
			},
			crouch = {
				walk = {
					hos = {
						fwd = 191,
						strafe = 191,
						bwd = 191
					},
					cbt = {
						fwd = 191,
						strafe = 191,
						bwd = 191
					}
				},
				run = {
					hos = {
						fwd = 305,
						strafe = 191,
						bwd = 191
					},
					cbt = {
						fwd = 305,
						strafe = 191,
						bwd = 191
					}
				}
			}
		},
		very_fast = {
			stand = {
				walk = {
					ntl = {
						fwd = 150,
						strafe = 120,
						bwd = 110
					},
					hos = {
						fwd = 332,
						strafe = 332,
						bwd = 332
					},
					cbt = {
						fwd = 332,
						strafe = 332,
						bwd = 332
					}
				},
				run = {
					hos = {
						fwd = 546,
						strafe = 332,
						bwd = 332
					},
					cbt = {
						fwd = 546,
						strafe = 332,
						bwd = 332
					}
				}
			},
			crouch = {
				walk = {
					hos = {
						fwd = 213,
						strafe = 213,
						bwd = 213
					},
					cbt = {
						fwd = 213,
						strafe = 213,
						bwd = 213
					}
				},
				run = {
					hos = {
						fwd = 340,
						strafe = 213,
						bwd = 213
					},
					cbt = {
						fwd = 340,
						strafe = 213,
						bwd = 213
					}
				}
			}
		}
	}
	for speed_preset_name, poses in pairs(presets.move_speed) do
		for pose, hastes in pairs(poses) do
			hastes.run.ntl = hastes.run.hos
		end
		poses.crouch.walk.ntl = poses.crouch.walk.hos
		poses.crouch.run.ntl = poses.crouch.run.hos
		poses.stand.run.ntl = poses.stand.run.hos
		poses.panic = poses.stand
	end
	presets.surrender = {}
	presets.surrender.always = {base_chance = 1}
	presets.surrender.never = {base_chance = 0}
	presets.surrender.easy = {
		base_chance = 0.75,
		significant_chance = 0.35,
		violence_timeout = 2,
		reasons = {
			health = {
				[1] = 0.25,
				[0.75] = 0.5,
				[0.5] = 0.75,
			},
			weapon_down = 0.5,
			pants_down = 1,
			isolated = 0.08
		},
		factors = {
			flanked = 0.05,
			unaware_of_aggressor = 0.1,
			enemy_weap_cold = 0.11,
			aggressor_dis = {
				[1000] = 0,
				[300] = 0.2
			}
		}
	}
	presets.surrender.hard = {
		base_chance = 0.5,
		significant_chance = 0.35,
		violence_timeout = 2,
		reasons = {
			health = {
				[1] = 0.25,
				[0.75] = 0.5,
				[0.5] = 0.75,
			},
			weapon_down = 0.5,
			pants_down = 1,
			isolated = 0.08
		},
		factors = {
			flanked = 0.05,
			unaware_of_aggressor = 0.1,
			enemy_weap_cold = 0.11,
			aggressor_dis = {
				[1000] = 0,
				[300] = 0.2
			}
		}
	}
	presets.surrender.bravo = {
		base_chance = 0.3,
		significant_chance = 0.35,
		violence_timeout = 2,
		reasons = {
			health = {
				[1] = 0.25,
				[0.75] = 0.5,
				[0.5] = 0.75,
			},
			weapon_down = 0.5,
			pants_down = 1,
			isolated = 0.08
		},
		factors = {
			flanked = 0.05,
			unaware_of_aggressor = 0.1,
			enemy_weap_cold = 0.11,
			aggressor_dis = {
				[1000] = 0,
				[300] = 0.2
			}
		}
	}	
	presets.surrender.special = {
		base_chance = 0.25,
		significant_chance = 0.35,
		violence_timeout = 2,
		reasons = {
			health = {
				[1] = 0.25,
				[0.75] = 0.5,
				[0.5] = 0.75,
			},
			weapon_down = 0.5,
			pants_down = 1,
			isolated = 0.08
		},
		factors = {
			flanked = 0.05,
			unaware_of_aggressor = 0.1,
			enemy_weap_cold = 0.11,
			aggressor_dis = {
				[1000] = 0,
				[300] = 0.2
			}
		}
	}
	presets.suppression = {
		easy = {
			duration = {10, 15},
			react_point = {0, 2},
			brown_point = {3, 5},
			panic_chance_mul = 1
		},
		hard_def = {
			duration = {5, 10},
			react_point = {0, 2},
			brown_point = {5, 6},
			panic_chance_mul = 1
		},
		hard_agg = {
			duration = {5, 8},
			react_point = {2, 5},
			brown_point = {5, 6},
			panic_chance_mul = 1
		},
		no_supress = {
			duration = {0.1, 0.15},
			react_point = {100, 200},
			brown_point = {400, 500},
			panic_chance_mul = 0
		}
	}
	
	--bot weapon randomizer bs--
	self.char_wep_tables = {}

	self.char_wep_tables.dallas = {
		primaries = {
			[1] = {
				--weapon factory id/name, found in weaponfactorytweakdata, usually at the bottom of an init function
				--in the case of this weapon, you can find it like this: self.wpn_fps_ass_74_npc = deep_clone(self.wpn_fps_ass_74)
				--you want the first part without the self., so wpn_fps_ass_74_npc
				factory_name = "wpn_fps_ass_74_npc",
				--blueprint table used to build a weapon with certain weapon mods/parts, which can be found in weaponfactorytweakdata
				--these can be found as variables or strings, depending on where you're looking, but you need to type them as a string here
				--if the weapon is not gonna use any mods, just leave the table empty or don't even define it
				blueprint = {
					"wpn_fps_upg_ak_b_ak105",
					"wpn_fps_upg_o_ak_scopemount",
					"wpn_fps_upg_fg_midwest",
					"wpn_fps_upg_fl_ass_smg_sho_surefire",
					"wpn_fps_upg_ak_g_pgrip",
					"wpn_fps_upg_ak_m_uspalm",
					"wpn_fps_upg_o_cmore",
					"wpn_upg_ak_s_folding"
				},
				--cosmetics table used to add a skin or color to the weapon
				--haven't fully looked into where these are stored and how this works, so leave it blank for now
				cosmetics = {}
			},
			[2] = {
				factory_name = "wpn_fps_ass_amcar_npc",
				blueprint = {
					"wpn_fps_upg_o_eotech",
					"wpn_fps_m4_uupg_m_std",
					"wpn_fps_upg_m4_s_standard",
					"wpn_fps_upg_fl_ass_smg_sho_surefire",
					"wpn_fps_upg_charm_dallas"
				},
				cosmetics = {
					id = "amcar_same",
					quality = "mint"
				}
			},
			[3] = {
				factory_name = "wpn_fps_ass_g36_npc",
				blueprint = {
					"wpn_fps_ass_g36_o_vintage",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_pis_1911_npc",
				blueprint = {
					"wpn_fps_pis_1911_g_bling",
					"wpn_fps_pis_1911_b_long",
					"wpn_upg_o_marksmansight_rear",
					"wpn_fps_upg_fl_pis_tlr1",
					"wpn_fps_upg_charm_dallas"
				},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.wolf = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_shot_r870_npc",
				blueprint = {
					"wpn_fps_shot_r870_s_solid_big",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			},
			[2] = {
				factory_name = "wpn_fps_ass_s552_npc",
				blueprint = {
					"wpn_fps_ass_s552_b_long",
					"wpn_fps_ass_s552_fg_standard_green",
					"wpn_fps_ass_s552_g_standard_green",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_smg_mp5_npc",
				blueprint = {
					"wpn_fps_smg_mp5_fg_m5k"
				},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.chains = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_lmg_m249_npc",
				blueprint = {
					"wpn_fps_lmg_m249_s_solid",
					"wpn_fps_lmg_m249_b_long",
					"wpn_fps_upg_o_eotech",
					"wpn_fps_upg_fl_ass_peq15"
				},
				cosmetics = {}
			},
			[2] = {
				factory_name = "wpn_fps_ass_g3_npc",
				blueprint = {
					"wpn_fps_ass_g3_fg_railed",
					"wpn_fps_ass_g3_g_retro",
					"wpn_fps_ass_g3_s_sniper",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			},
			[3] = {
				factory_name = "wpn_fps_ass_scar_npc",
				blueprint = {
					"wpn_fps_ass_scar_fg_railext",
					"wpn_fps_ass_scar_s_sniper",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			},
			[4] = {
				factory_name = "wpn_fps_lmg_hk21_npc",
				blueprint = {},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_smg_mac10_npc",
				blueprint = {
					"wpn_fps_smg_cobray_ns_silencer",
					"wpn_fps_smg_mac10_m_extended",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.houston = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_ass_aug_npc",
				blueprint = {
					"wpn_fps_aug_b_short",
					"wpn_fps_upg_o_acog",
					"wpn_fps_aug_fg_a3",
					"wpn_fps_aug_body_f90",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			},
			[2] = {
				factory_name = "wpn_fps_ass_ak5_npc",
				blueprint = {
					"wpn_fps_ass_ak5_b_short",
					"wpn_fps_ass_ak5_fg_ak5c",
					"wpn_fps_ass_ak5_s_ak5c",
					"wpn_fps_upg_o_rx30",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_smg_mp5_npc",
				blueprint = {
					"wpn_fps_smg_mp5_fg_mp5sd",
					"wpn_fps_smg_mp5_s_adjust"
				},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.wick = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_snp_tti_npc",
				blueprint = {
					"wpn_fps_snp_tti_g_grippy",
					"wpn_fps_snp_tti_s_vltor",
					"wpn_fps_upg_fl_ass_peq15"
				},
				cosmetics = {}
			},
			[2] = {
				factory_name = "wpn_fps_sho_ksg_npc",
				blueprint = {
					"wpn_fps_sho_ksg_b_long",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			},
			[3] = {
				factory_name = "wpn_fps_ass_m4_npc",
				blueprint = {
					"wpn_fps_m4_uupg_b_sd",
					"wpn_fps_upg_ass_m4_lower_reciever_core",
					"wpn_fps_upg_o_reflex",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_smg_schakal_npc",
				blueprint = {
					"wpn_fps_smg_schakal_vg_surefire",
					"wpn_fps_upg_o_reflex",
					"wpn_fps_smg_schakal_ns_silencer",
					"wpn_fps_smg_schakal_m_short",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			},
			[2] = {
				factory_name = "wpn_fps_pis_packrat_npc",
				blueprint = {
					"wpn_fps_pis_packrat_o_expert",
					"wpn_fps_upg_ns_pis_medium_slim",
					"wpn_fps_upg_fl_pis_tlr1"
					
				},
				cosmetics = {}
			}
		}
	}

	local hox_m14 = {
		factory_name = "wpn_fps_ass_m14_npc",
		blueprint = {
			"wpn_fps_upg_o_t1micro",
			"wpn_fps_upg_o_m14_scopemount",
			"wpn_fps_upg_fl_ass_smg_sho_surefire"
		},
		cosmetics = {}
	}

	local hox_famas = {
		factory_name = "wpn_fps_ass_famas_npc",
		blueprint = {
			"wpn_fps_ass_famas_b_sniper",
			"wpn_fps_ass_famas_g_retro",
			"wpn_fps_upg_fl_ass_smg_sho_surefire"
		},
		cosmetics = {}
	}

	self.char_wep_tables.hoxton = {
		primaries = {
			[1] = hox_m14,
			[2] = hox_m14,
			[3] = hox_m14,
			[4] = hox_m14,
			[5] = hox_m14,
			[6] = hox_famas,
			[7] = hox_famas,
			[8] = hox_famas,
			[9] = hox_famas,
			[10] = hox_famas,
			[11] = hox_famas,
			--cursed--
			[12] = {
				factory_name = "wpn_fps_ass_m14_npc",
				blueprint = {
					"wpn_fps_ass_m14_body_ruger",
					"wpn_fps_upg_fl_ass_smg_sho_surefire",
					"wpn_fps_upg_ass_ns_surefire",
					"wpn_fps_upg_o_spot",
					"wpn_fps_upg_o_m14_scopemount"
				},
				cosmetics = {
					id = "new_m14_golddigger",
					quality = "mint"
				}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_pis_usp_npc",
				blueprint = {
					"wpn_fps_upg_ns_pis_ipsccomp",
					"wpn_fps_pis_usp_b_match",
					"wpn_fps_pis_usp_m_extended"
				},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.clover = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_ass_l85a2_npc",
				blueprint = {
					"wpn_fps_ass_l85a2_fg_short",
					"wpn_fps_ass_l85a2_b_short",
					"wpn_fps_upg_ns_ass_smg_large",
					"wpn_fps_ass_l85a2_g_worn",
					"wpn_fps_ass_l85a2_m_emag",
					"wpn_fps_upg_o_eotech",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			},
			[2] = {
				factory_name = "wpn_fps_ass_sub2000_npc",
				blueprint = {
					"wpn_fps_ass_sub2000_fg_suppressed",
					"wpn_fps_upg_o_eotech_xps",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			},
			[3] = {
				factory_name = "wpn_fps_sho_ksg_npc",
				blueprint = {
					"wpn_fps_sho_ksg_b_short",
					"wpn_fps_upg_ns_sho_salvo_large",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_smg_mp5_npc",
				blueprint = {
					"wpn_fps_smg_mp5_fg_mp5sd",
					"wpn_fps_smg_mp5_s_ring"
				},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.dragan = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_ass_vhs_npc",
				blueprint = {
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			},
			[2] = {
				factory_name = "wpn_fps_sho_spas12_npc",
				blueprint = {
					"wpn_fps_sho_s_spas12_folded",
					"wpn_fps_sho_b_spas12_long",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_pis_hs2000_npc", 
				blueprint = {
					"wpn_fps_upg_pis_ns_flash",
					"wpn_fps_pis_hs2000_m_extended",
					"wpn_fps_pis_hs2000_sl_custom",
					"wpn_fps_upg_o_rmr",
					"wpn_fps_upg_fl_pis_tlr1"
				},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.jacket = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_ass_akm_npc",
				blueprint = {
					"wpn_fps_upg_ak_s_solidstock",
					"wpn_fps_upg_ak_g_wgrip",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				}, 
				cosmetics = {} 
			},
			[2] = {
				factory_name = "wpn_fps_ass_m16_npc",
				blueprint = {
					"wpn_fps_m16_fg_vietnam",
					"wpn_fps_upg_m4_m_straight",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			},
			[3] = {
				factory_name = "wpn_fps_shot_huntsman_npc",
				blueprint = {},
				cosmetics = {}
			},
			[4] = {
				factory_name = "wpn_fps_shot_r870_npc",
				blueprint = {
					"wpn_fps_shot_r870_s_nostock_big",
					"wpn_fps_shot_r870_body_rack",
					"wpn_fps_shot_r870_fg_wood",
					"wpn_fps_upg_ns_shot_shark",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_smg_cobray_npc",
				blueprint = {
					"wpn_fps_smg_cobray_body_upper_jacket",
					"wpn_fps_smg_cobray_ns_barrelextension",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.bonnie = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_lmg_mg42_npc",
				blueprint = {
					"wpn_fps_lmg_mg42_b_mg34",
					"wpn_fps_upg_bp_lmg_lionbipod",
					"wpn_fps_upg_fl_ass_peq15"
				},
				cosmetics = {}
			},
			[2] = {
				factory_name = "wpn_fps_shot_b682_npc",
				blueprint = {
					"wpn_fps_shot_b682_s_ammopouch"
				},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_pis_judge_npc", 
				blueprint = {
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.sokol = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_ass_asval_npc",
				blueprint = {
					"wpn_fps_ass_asval_s_solid",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			},
			[2] = {
				factory_name = "wpn_fps_smg_vityaz_npc",
				blueprint = {
					"wpn_fps_smg_vityaz_b_supressed",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_smg_mp5_npc", ----placeholder
				blueprint = {},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.jiro = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_smg_polymer_npc",
				blueprint = {
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_smg_baka_npc",
				blueprint = {
					"wpn_fps_smg_baka_b_comp",
					"wpn_fps_smg_baka_s_standard"
				},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.bodhi = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_snp_model70_npc",
				blueprint = {
					"wpn_fps_upg_fl_ass_peq15"
				},
				cosmetics = {}
			},
			[2] = {
				factory_name = "wpn_fps_ass_galil_npc",
				blueprint = {
					"wpn_fps_ass_galil_fg_sniper",
					"wpn_fps_ass_galil_s_sniper",
					"wpn_fps_upg_o_specter",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_pis_sparrow_npc",
				blueprint = {
					"wpn_fps_pis_sparrow_b_comp",
					"wpn_fps_pis_sparrow_body_941",
					"wpn_fps_pis_sparrow_g_cowboy",
					"wpn_fps_upg_fl_pis_tlr1"
				},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.jimmy = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_sho_ben_npc",
				blueprint = {
					"wpn_fps_sho_ben_b_short",
					"wpn_fps_sho_ben_s_collapsed",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			},
			[2] = {
				factory_name = "wpn_fps_pis_beer_npc",
				blueprint = {},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_smg_sr2_npc",
				blueprint = {
				"wpn_fps_smg_sr2_ns_silencer",
				"wpn_fps_smg_sr2_s_unfolded",
				"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.sydney = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_ass_tecci_npc",
				blueprint = {
					"wpn_fps_ass_tecci_b_long",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			},
			[2] = {
				factory_name = "wpn_fps_sho_aa12_npc",
				blueprint = {
					"wpn_fps_sho_aa12_barrel_long",
					"wpn_fps_upg_shot_ns_king",
					"wpn_fps_sho_aa12_mag_drum",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_pis_deagle_npc", 
				blueprint = {
					"wpn_fps_pis_deagle_g_bling",
					"wpn_fps_upg_fl_pis_tlr1"
				},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.rust = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_sho_boot_npc",
				blueprint = {
					"wpn_fps_sho_boot_body_exotic",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_smg_mp5_npc", ----placeholder
				blueprint = {},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.tony = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_ass_contraband_npc",
				blueprint = {
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			},
			[2] = {
				factory_name = "wpn_fps_shot_m37_npc",
				blueprint = {
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_smg_uzi_npc", 
				blueprint = {
					"wpn_fps_smg_uzi_s_standard",
					"wpn_fps_smg_uzi_fg_rail",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.sangres = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_ass_akm_gold_npc",
				blueprint = {
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_pis_chinchilla_npc",
				blueprint = {
					"wpn_fps_pis_chinchilla_g_death"
				},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.duke = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_ass_ching_npc",
				blueprint = {
					"wpn_fps_ass_ching_s_pouch",
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			},
			[2] = {
				factory_name = "wpn_fps_smg_erma_npc",
				blueprint = {
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			},
			[3] = {
				factory_name = "wpn_fps_shot_m1897_npc",
				blueprint = {
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_pis_shrew_npc",
				blueprint = {
					"wpn_fps_pis_shrew_g_bling",
					"wpn_fps_upg_fl_pis_tlr1"
				},
				cosmetics = {}
			}
		}
	}

	self.char_wep_tables.joy = {
		primaries = {
			[1] = {
				factory_name = "wpn_fps_smg_shepheard_npc",
				blueprint = {
					"wpn_fps_upg_fl_ass_smg_sho_surefire"
				},
				cosmetics = {}
			}
		},
		secondaries = {
			[1] = {
				factory_name = "wpn_fps_smg_mp5_npc", ----placeholder
				blueprint = {},
				cosmetics = {}
			}
		}
	}

	return presets
end

function CharacterTweakData:_create_table_structure()
	self.weap_ids = {
		"beretta92",
		"c45",
		"raging_bull",
		"m4",
		"m4_yellow",
		"ak47",
		"r870",
		"mossberg",
		"mp5",
		"mp5_tactical",
		"mp9",
		"mac11",
		"m14_sniper_npc",
		"saiga",
		"m249",
		"benelli",
		"g36",
		"ump",
		"scar_murky",
		"rpk_lmg",
		"svd_snp",
		"akmsu_smg",
		"asval_smg",
		"sr2_smg",
		"ak47_ass",
		"peacemaker",
		"x_akmsu",
		"x_c45",
		"sg417",
		"svdsil_snp",
		"mini",
		"heavy_zeal_sniper",
		"m4_boom",
		"hk21_sc",
		"mp5_zeal",
		"p90_summer",
		"m16_summer",
		"mp5_cloak",
		"s552_sc",
		"r870_taser",
		"oicw",
		"hmg_spring",
		"smoke",
		"ak47_ass_elite",
		"asval_smg_elite",
		"ak47_ass_boom",
		"autumn_smg",
		"s553_zeal",
		"lmg_titan",
		"x_mini_npc",
		"x_raging_bull_npc",
		"bravo_rifle",
		"bravo_shotgun",
		"bravo_lmg",
		"bravo_dmr",
		"flamethrower_mk2_flamer_summers",
		"scar_npc",
		"m1911_npc",
		"vet_cop_boss_pistol",
		"m60",
		"m60_bravo",
		"m60_om",
		"deagle",
		"mp9_titan",
		"sr2_titan",
		"beretta92_titan",
		"hajk_cop",
		"uzi_cop",
		"m4_blue",
		"ak_blue",
		"amcar",
		"ak102",
		"m416_npc",
		"socom_npc",
		"white_streak_npc"
	}
	self.weap_unit_names = {
		Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92"),
		Idstring("units/payday2/weapons/wpn_npc_c45/wpn_npc_c45"),
		Idstring("units/payday2/weapons/wpn_npc_raging_bull/wpn_npc_raging_bull"),
		Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4"),
		Idstring("units/payday2/weapons/wpn_npc_m4_yellow/wpn_npc_m4_yellow"),
		Idstring("units/payday2/weapons/wpn_npc_ak47/wpn_npc_ak47"),
		Idstring("units/payday2/weapons/wpn_npc_r870/wpn_npc_r870"),
		Idstring("units/payday2/weapons/wpn_npc_sawnoff_shotgun/wpn_npc_sawnoff_shotgun"),
		Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5"),
		Idstring("units/payday2/weapons/wpn_npc_mp5_tactical/wpn_npc_mp5_tactical"),
		Idstring("units/payday2/weapons/wpn_npc_smg_mp9/wpn_npc_smg_mp9"),
		Idstring("units/payday2/weapons/wpn_npc_mac11/wpn_npc_mac11"),
		Idstring("units/payday2/weapons/wpn_npc_sniper/wpn_npc_sniper"),
		Idstring("units/payday2/weapons/wpn_npc_saiga/wpn_npc_saiga"),
		Idstring("units/payday2/weapons/wpn_npc_lmg_m249/wpn_npc_lmg_m249"),
		Idstring("units/payday2/weapons/wpn_npc_benelli/wpn_npc_benelli"),
		Idstring("units/payday2/weapons/wpn_npc_g36/wpn_npc_g36"),
		Idstring("units/payday2/weapons/wpn_npc_ump/wpn_npc_ump"),
		Idstring("units/payday2/weapons/wpn_npc_scar_murkywater/wpn_npc_scar_murkywater"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_rpk/wpn_npc_rpk"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_svd/wpn_npc_svd"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_akmsu/wpn_npc_akmsu"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_asval/wpn_npc_asval"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_sr2/wpn_npc_sr2"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_ak47/wpn_npc_ak47"),
		Idstring("units/payday2/weapons/wpn_npc_peacemaker/wpn_npc_peacemaker"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_akmsu/wpn_npc_x_akmsu"),
		Idstring("units/payday2/weapons/wpn_npc_c45/wpn_npc_x_c45"),
		Idstring("units/pd2_dlc_chico/weapons/wpn_npc_sg417/wpn_npc_sg417"),
		Idstring("units/pd2_dlc_spa/weapons/wpn_npc_svd_silenced/wpn_npc_svd_silenced"),
		Idstring("units/pd2_dlc_drm/weapons/wpn_npc_mini/wpn_npc_mini"),
		Idstring("units/payday2/weapons/wpn_npc_scar_murkywater/wpn_npc_scar_murkywater"),
		Idstring("units/payday2/weapons/wpn_npc_m4_boom/wpn_npc_m4_boom"),
		Idstring("units/payday2/weapons/wpn_npc_hk21_sc/wpn_npc_hk21_sc"),
		Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5"),
		Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5"),
		Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4"),
		Idstring("units/payday2/weapons/wpn_npc_mp5_cloak/wpn_npc_mp5_cloak"),
		Idstring("units/payday2/weapons/wpn_npc_s552_sc/wpn_npc_s552_sc"),
		Idstring("units/payday2/weapons/wpn_npc_r870_taser_sc/wpn_npc_r870_taser_sc"),
		Idstring("units/payday2/weapons/wpn_npc_oicw/wpn_npc_oicw"),
		Idstring("units/pd2_dlc_drm/weapons/wpn_npc_mini/wpn_npc_mini"),
		Idstring("units/pd2_dlc_uno/weapons/wpn_npc_smoke/wpn_npc_smoke"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_ak47/wpn_npc_ak47"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_asval/wpn_npc_asval"),
		Idstring("units/payday2/weapons/wpn_npc_m4_boom/wpn_npc_m4_boom"),
		Idstring("units/pd2_dlc_vip/weapons/wpn_npc_mpx/wpn_npc_mpx"),
		Idstring("units/payday2/weapons/wpn_npc_s553/wpn_npc_s553"),
		Idstring("units/payday2/weapons/wpn_npc_hk23_sc/wpn_npc_hk23_sc"),
		Idstring("units/payday2/weapons/wpn_npc_mini/x_mini_npc"),	
		Idstring("units/payday2/weapons/wpn_npc_raging_bull/x_raging_bull_npc"),
		Idstring("units/pd2_mod_bravo/weapons/wpn_npc_swamp/wpn_npc_swamp"),
		Idstring("units/pd2_mod_bravo/weapons/wpn_npc_bayou/wpn_npc_bayou"),
		Idstring("units/pd2_mod_bravo/weapons/wpn_npc_lmg_m249_bravo/wpn_npc_lmg_m249_bravo"),
		Idstring("units/payday2/weapons/wpn_npc_scar_murkywater/wpn_npc_scar_murkywater"),
		Idstring("units/pd2_dlc_vip/weapons/wpn_npc_flamethrower_summers/wpn_npc_flamethrower_summers"),
		Idstring("units/payday2/weapons/wpn_npc_scar_light/wpn_npc_scar_light"),
		Idstring("units/payday2/weapons/wpn_npc_1911/wpn_npc_1911"),
		Idstring("units/payday2/weapons/wpn_npc_raging_bull/x_raging_bull_npc"),
		Idstring("units/payday2/weapons/wpn_npc_m60/wpn_npc_m60"),
		Idstring("units/pd2_mod_bravo/weapons/wpn_npc_m60_bravo/wpn_npc_m60_bravo"),
		Idstring("units/payday2/weapons/wpn_npc_m60_om/wpn_npc_m60_om"),
		Idstring("units/payday2/weapons/wpn_npc_degle/wpn_npc_degle"),
		Idstring("units/payday2/weapons/wpn_npc_smg_mp9_titan/wpn_npc_smg_mp9_titan"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_sr2_titan/wpn_npc_sr2_titan"),
		Idstring("units/payday2/weapons/wpn_npc_beretta92_titan/wpn_npc_beretta92_titan"),
		Idstring("units/pd2_dlc_bex/weapons/wpn_npc_hajk/wpn_npc_hajk"),
		Idstring("units/pd2_dlc_bex/weapons/wpn_npc_uzi/wpn_npc_uzi"),
		Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_akmsu/wpn_npc_akmsu"),
		Idstring("units/payday2/weapons/wpn_npc_amcar/wpn_npc_amcar"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_ak102/wpn_npc_ak102"),
		Idstring("units/pd2_mod_lapd/weapons/wpn_npc_m416/wpn_npc_m416"),
		Idstring("units/payday2/weapons/wpn_npc_socom/wpn_npc_socom"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_pl14/wpn_npc_pl14")
	}
end


function CharacterTweakData:character_map()
	local char_map = {
		basic = {
			path = "units/payday2/characters/",
			list = {
				"civ_female_bank_1",
				"civ_female_bank_manager_1",
				"civ_female_bikini_1",
				"civ_female_bikini_2",
				"civ_female_casual_1",
				"civ_female_casual_2",
				"civ_female_casual_3",
				"civ_female_casual_4",
				"civ_female_casual_5",
				"civ_female_casual_6",
				"civ_female_casual_7",
				"civ_female_casual_8",
				"civ_female_casual_9",
				"civ_female_casual_10",
				"civ_female_crackwhore_1",
				"civ_female_curator_1",
				"civ_female_curator_2",
				"civ_female_hostess_apron_1",
				"civ_female_hostess_jacket_1",
				"civ_female_hostess_shirt_1",
				"civ_female_party_1",
				"civ_female_party_2",
				"civ_female_party_3",
				"civ_female_party_4",
				"civ_female_waitress_1",
				"civ_female_waitress_2",
				"civ_female_waitress_3",
				"civ_female_waitress_4",
				"civ_female_wife_trophy_1",
				"civ_female_wife_trophy_2",
				"civ_male_bank_1",
				"civ_male_bank_2",
				"civ_male_bank_manager_1",
				"civ_male_bank_manager_3",
				"civ_male_bank_manager_4",
				"civ_male_bank_manager_5",
				"civ_male_bartender_1",
				"civ_male_bartender_2",
				"civ_male_business_1",
				"civ_male_business_2",
				"civ_male_casual_1",
				"civ_male_casual_2",
				"civ_male_casual_3",
				"civ_male_casual_4",
				"civ_male_casual_5",
				"civ_male_casual_6",
				"civ_male_casual_7",
				"civ_male_casual_8",
				"civ_male_casual_9",
				"civ_male_casual_12",
				"civ_male_casual_13",
				"civ_male_casual_14",
				"civ_male_curator_1",
				"civ_male_curator_2",
				"civ_male_curator_3",
				"civ_male_dj_1",
				"civ_male_italian_robe_1",
				"civ_male_janitor_1",
				"civ_male_janitor_2",
				"civ_male_janitor_3",
				"civ_male_meth_cook_1",
				"civ_male_party_1",
				"civ_male_party_2",
				"civ_male_party_3",
				"civ_male_pilot_1",
				"civ_male_scientist_1",
				"civ_male_miami_store_clerk_1",
				"civ_male_taxman",
				"civ_male_trucker_1",
				"civ_male_worker_1",
				"civ_male_worker_2",
				"civ_male_worker_3",
				"civ_male_worker_docks_1",
				"civ_male_worker_docks_2",
				"civ_male_worker_docks_3",
				"civ_male_dog_abuser_1",
				"civ_male_dog_abuser_2",
				"ene_biker_1",
				"ene_biker_2",
				"ene_biker_3",
				"ene_biker_4",
				"ene_bulldozer_1",
				"ene_bulldozer_2",
				"ene_bulldozer_2_hw",
				"ene_bulldozer_3",
				"ene_bulldozer_4",
				"ene_city_swat_1",
				"ene_city_swat_1_sc",
				"ene_city_swat_2",
				"ene_city_swat_3",
				"ene_city_swat_heavy_1",
				"ene_city_swat_heavy_2",
				"ene_murkywater_1",
				"ene_murkywater_2",
				"ene_cop_1",
				"ene_cop_2",
				"ene_cop_3",
				"ene_cop_4",
				"ene_fbi_1",
				"ene_fbi_2",
				"ene_fbi_3",
				"ene_fbi_boss_1",
				"ene_fbi_female_1",
				"ene_fbi_female_2",
				"ene_fbi_female_3",
				"ene_fbi_female_4",
				"ene_fbi_heavy_1",
				"ene_fbi_heavy_r870",
				"ene_fbi_heavy_r870_sc",
				"ene_fbi_office_1",
				"ene_fbi_office_2",
				"ene_fbi_office_3",
				"ene_fbi_office_4",
				"ene_fbi_swat_1",
				"ene_fbi_swat_2",
				"ene_fbi_swat_3",
				"ene_gang_black_1",
				"ene_gang_black_2",
				"ene_gang_black_3",
				"ene_gang_black_4",
				"ene_gang_mexican_1",
				"ene_gang_mexican_2",
				"ene_gang_mexican_3",
				"ene_gang_mexican_4",
				"ene_gang_russian_1",
				"ene_gang_russian_2",
				"ene_gang_russian_3",
				"ene_gang_russian_4",
				"ene_gang_russian_5",
				"ene_gang_mobster_1",
				"ene_gang_mobster_2",
				"ene_gang_mobster_3",
				"ene_gang_mobster_4",
				"ene_gang_mobster_boss",
				"ene_guard_national_1",
				"ene_hoxton_breakout_guard_1",
				"ene_hoxton_breakout_guard_2",
				"ene_male_tgt_1",
				"ene_murkywater_1",
				"ene_murkywater_2",
				"ene_prisonguard_female_1",
				"ene_prisonguard_male_1",
				"ene_secret_service_1",
				"ene_secret_service_2",
				"ene_security_1",
				"ene_security_2",
				"ene_security_3",
				"ene_security_4",
				"ene_security_5",
				"ene_security_6",
				"ene_security_7",
				"ene_security_8",
				"ene_security_kh_1",
				"ene_security_kh_2",
				"ene_security_kh_3",
				"ene_shield_1",
				"ene_shield_2",
				"ene_city_shield",
				"ene_shield_gensec",
				"ene_phalanx_1",
				"ene_vip_1",
				"ene_vip_2",
				"ene_sniper_1",
				"ene_sniper_2",
				"ene_sniper_3",
				"ene_spook_1",
				"ene_swat_1",
				"ene_swat_2",
				"ene_swat_heavy_1",
				"ene_swat_heavy_r870",
				"ene_swat_heavy_r870_sc",
				"ene_tazer_1",
				"ene_grenadier_1",
				"ene_veteran_cop_1",
				"ene_veteran_cop_2",
				"ene_veteran_lod_1",
				"ene_veteran_lod_2",					
				"npc_old_hoxton_prisonsuit_1",
				"npc_old_hoxton_prisonsuit_2",
				"ene_medic_r870",
				"ene_medic_m4",
				"ene_spook_cloak_1",					
				"ene_city_heavy_r870_sc",
				"ene_city_heavy_r870",
				"ene_city_heavy_g36",
				"ene_mememan_1",	
				"ene_mememan_2",										
				"ene_bulldozer_biker_1",
				"ene_guard_biker_1",
				"ene_murky_heavy_m4",
				"ene_murky_heavy_r870",
				"ene_city_guard_1",
				"ene_city_guard_2",
				"ene_city_guard_3"
			}
		},
		dlc1 = {
			path = "units/pd2_dlc1/characters/",
			list = {
				"civ_male_bank_manager_2",
				"civ_male_casual_10",
				"civ_male_casual_11",
				"civ_male_firefighter_1",
				"civ_male_paramedic_1",
				"civ_male_paramedic_2",
				"ene_security_gensec_1",
				"ene_security_gensec_2",
				"ene_security_gensec_3"
			}
		},
		dlc2 = {
			path = "units/pd2_dlc2/characters/",
			list = {
				"civ_female_bank_assistant_1",
				"civ_female_bank_assistant_2"
			}
		},
		mansion = {
			path = "units/pd2_mcmansion/characters/",
			list = {
				"ene_male_hector_1",
				"ene_male_hector_2",
				"ene_hoxton_breakout_guard_1",
				"ene_hoxton_breakout_guard_2"
			}
		},
		cage = {
			path = "units/pd2_dlc_cage/characters/",
			list = {
				"civ_female_bank_2"
			}
		},
		arena = {
			path = "units/pd2_dlc_arena/characters/",
			list = {
				"civ_female_fastfood_1",
				"civ_female_party_alesso_1",
				"civ_female_party_alesso_2",
				"civ_female_party_alesso_3",
				"civ_female_party_alesso_4",
				"civ_female_party_alesso_5",
				"civ_female_party_alesso_6",
				"civ_male_party_alesso_1",
				"civ_male_party_alesso_2",
				"civ_male_alesso_booth",
				"civ_male_fastfood_1",
				"ene_guard_security_heavy_2",
				"ene_guard_security_heavy_1"
			}
		},
		kenaz = {
			path = "units/pd2_dlc_casino/characters/",
			list = {
				"civ_male_casino_1",
				"civ_male_casino_2",
				"civ_male_casino_3",
				"civ_male_casino_4",
				"ene_secret_service_1_casino",
				"civ_male_business_casino_1",
				"civ_male_business_casino_2",
				"civ_male_impersonator",
				"civ_female_casino_1",
				"civ_female_casino_2",
				"civ_female_casino_3",
				"civ_male_casino_pitboss"
			}
		},
		vip = {
			path = "units/pd2_dlc_vip/characters/",
			list = {
				"ene_vip_1",
				"ene_vip_2",
				"ene_vip_2_assault",					
				"ene_spring",
				"ene_vip_autumn",					
				"ene_summers",
				"ene_phalanx_medic",
				"ene_phalanx_grenadier",
				"ene_phalanx_taser",
				"ene_phalanx_1",
				"ene_phalanx_1_assault",					
				"ene_titan_shotgun",
				"ene_titan_rifle",
				"ene_omnia_lpf",
				"ene_fbi_titan_1",
				"ene_titan_sniper",
				"ene_titan_taser"
			}
		},
		holly = {
			path = "units/pd2_dlc_holly/characters/",
			list = {
				"civ_male_hobo_1",
				"civ_male_hobo_2",
				"civ_male_hobo_3",
				"civ_male_hobo_4",
				"ene_gang_hispanic_1",
				"ene_gang_hispanic_3",
				"ene_gang_hispanic_2"
			}
		},
		red = {
			path = "units/pd2_dlc_red/characters/",
			list = {
				"civ_female_inside_man_1"
			}
		},
		dinner = {
			path = "units/pd2_dlc_dinner/characters/",
			list = {
				"civ_male_butcher_2",
				"civ_male_butcher_1"
			}
		},
		pal = {
			path = "units/pd2_dlc_pal/characters/",
			list = {
				"civ_male_mitch"
			}
		},
		cane = {
			path = "units/pd2_dlc_cane/characters/",
			list = {
				"civ_male_helper_1",
				"civ_male_helper_2",
				"civ_male_helper_3",
				"civ_male_helper_4"
			}
		},
		berry = {
			path = "units/pd2_dlc_berry/characters/",
			list = {
				"ene_murkywater_no_light",
				"npc_locke"
			}
		},
		peta = {
			path = "units/pd2_dlc_peta/characters/",
			list = {
				"civ_male_boris"
			}
		},
		mad = {
			path = "units/pd2_dlc_mad/characters/",
			list = {
				"civ_male_scientist_01",
				"civ_male_scientist_02",
				"ene_akan_fbi_heavy_g36",
				"ene_akan_fbi_heavy_r870",
				"ene_akan_fbi_shield_sr2_smg",
				"ene_akan_fbi_spooc_asval_smg",
				"ene_akan_cs_cop_c45_sc",
				"ene_akan_cs_cop_raging_bull_sc",					
				"ene_akan_fbi_swat_ak47_ass",					
				"ene_akan_fbi_swat_dw_ak47_ass",
				"ene_akan_fbi_swat_dw_ak47_ass_sc",					
				"ene_akan_fbi_swat_dw_r870",
				"ene_akan_fbi_swat_dw_r870_sc",					
				"ene_akan_fbi_swat_dw_ump",
				"ene_akan_fbi_swat_r870",
				"ene_akan_fbi_swat_ump",
				"ene_akan_fbi_tank_r870",
				"ene_akan_fbi_tank_rpk_lmg",
				"ene_akan_fbi_tank_saiga",
				"ene_akan_cs_cop_ak47_ass",
				"ene_akan_cs_cop_akmsu_smg",
				"ene_akan_cs_cop_akmsu_smg_sc",
				"ene_akan_cs_cop_asval_smg",
				"ene_akan_cs_swat_zeal",					
				"ene_akan_cs_cop_r870",
				"ene_akan_cs_heavy_ak47_ass",
				"ene_akan_cs_heavy_r870",
				"ene_akan_cs_shield_c45",
				"ene_akan_cs_swat_ak47_ass",
				"ene_akan_cs_swat_r870",
				"ene_akan_cs_swat_sniper_svd_snp",
				"ene_akan_cs_tazer_ak47_ass",
				"ene_akan_medic_ak47_ass",
				"ene_akan_medic_r870",				
				"ene_akan_fbi_heavy_dw",
				"ene_akan_fbi_heavy_dw_r870",
				"ene_akan_fbi_1",
				"ene_akan_fbi_2",
				"ene_akan_veteran_1",
				"ene_akan_veteran_2",
				"ene_akan_grenadier_1",
				"ene_akan_medic_bob",
				"ene_akan_medic_zdann",	
				"ene_vip_2",
				"ene_titan_shotgun",
				"ene_titan_rifle",
				"ene_akan_lpf",
				"ene_fbi_titan_1",
				"ene_phalanx_1_assault",										
				"ene_spook_cloak_1",										
				"ene_titan_sniper",
				"ene_titan_taser"				
			}
		},
		born = {
			path = "units/pd2_dlc_born/characters/",
			list = {
				"ene_gang_biker_boss",
				"ene_biker_female_1",
				"ene_biker_female_2",
				"ene_biker_female_3",
				"npc_male_mechanic"
			}
		},
		flat = {
			path = "units/pd2_dlc_flat/characters/",
			list = {
				"npc_chavez",
				"npc_jamaican"
			}
		},
		help = {
			path = "units/pd2_dlc_help/characters/",
			list = {
				"ene_zeal_bulldozer_halloween"
			}
		},
		glace = {
			path = "units/pd2_dlc_glace/characters/",
			list = {
				"npc_chinese_prisoner",
				"npc_prisoner_1",
				"npc_prisoner_2",
				"npc_prisoner_3",
				"npc_prisoner_4",
				"npc_prisoner_5",
				"npc_prisoner_6",
				"npc_yakuza_prisoner"
			}
		},
		moon = {
			path = "units/pd2_dlc_moon/characters/",
			list = {
				"civ_male_pilot_2"
			}
		},
		friend = {
			path = "units/pd2_dlc_friend/characters/",
			list = {
				"ene_bolivian_thug_outdoor_01",
				"ene_bolivian_thug_outdoor_02",
				"ene_drug_lord_boss",
				"ene_security_manager",
				"ene_thug_indoor_01",
				"ene_thug_indoor_02"
			}
		},
		gitgud = {
			path = "units/pd2_dlc_gitgud/characters/",
			list = {
				"ene_zeal_bulldozer",
				"ene_zeal_bulldozer_2",
				"ene_zeal_bulldozer_3",
				"ene_zeal_cloaker",
				"ene_zeal_swat",
				"ene_zeal_city_1",
				"ene_zeal_city_2",
				"ene_zeal_city_3",
				"ene_zeal_medic",				
				"ene_zeal_sniper",
				"ene_zeal_swat_heavy",
				"ene_zeal_heavy_shield",
				"ene_zeal_swat_shield",
				"ene_zeal_tazer",
				"ene_grenadier_1",
				"ene_zeal_fbi_1",
				"ene_zeal_fbi_m4",
				"ene_zeal_fbi_mp5",
				"ene_zeal_swat_heavy_sc",
				"ene_zeal_swat_heavy_r870_sc"
			}
		},
		spa = {
			path = "units/pd2_dlc_spa/characters/",
			list = {
				"ene_sniper_3",
				"npc_spa",
				"npc_spa_2",
				"npc_spa_3",
				"npc_gage"
			}
		},
		fish = {
			path = "units/pd2_dlc_lxy/characters/",
			list = {
				"civ_female_guest_gala_1",
				"civ_female_guest_gala_2",
				"civ_male_guest_gala_1",
				"civ_male_guest_gala_2",
				"civ_male_camera_crew_1"
			}
		},
		slu = {
			path = "units/pd2_dlc_slu/characters/",
			list = {"npc_vlad", "npc_sophia"}
		},
		run = {
			path = "units/pd2_dlc_run/characters/",
			list = {"npc_matt"}
		},
		rvd = {
			path = "units/pd2_dlc_rvd/characters/",
			list = {
				"npc_cop",
				"npc_cop_01",
				"npc_mr_brown",
				"npc_mr_pink",
				"npc_mr_orange",
				"npc_mr_blonde",
				"npc_mr_pink_escort",
				"ene_la_cop_1",
				"ene_la_cop_2",
				"ene_la_cop_3",
				"ene_la_cop_4",
				"ene_female_civ_undercover"
			}
		},		
		drm = {
			path = "units/pd2_dlc_drm/characters/",
			list = {
				"ene_bulldozer_medic",
				"ene_bulldozer_medic_classic",
				"ene_bulldozer_minigun",
				"ene_bulldozer_minigun_classic",
				"ene_zeal_swat_heavy_sniper"
			}
		},
		wwh = {
			path = "units/pd2_dlc_wwh/characters/",
			list = {
				"ene_female_crew",
				"ene_male_crew_01",
				"ene_male_crew_02",
				"ene_captain",
				"ene_locke"
			}			
		},		
		dah = {
			path = "units/pd2_dlc_dah/characters/",
			list = {
				"npc_male_cfo",
				"npc_male_ralph"
			}
		},		
		hvh = {
			path = "units/pd2_dlc_hvh/characters/",
			list = {
				"ene_cop_hvh_1",
				"ene_cop_hvh_2",
				"ene_cop_hvh_3",
				"ene_cop_hvh_4",
				"ene_swat_hvh_1",
				"ene_swat_hvh_2",
				"ene_fbi_hvh_1",
				"ene_fbi_hvh_2",
				"ene_fbi_hvh_3",
				"ene_spook_hvh_1",
				"ene_swat_heavy_hvh_1",
				"ene_swat_heavy_hvh_r870",
				"ene_tazer_hvh_1",
				"ene_shield_hvh_1",
				"ene_shield_hvh_2",
				"ene_medic_hvh_r870",
				"ene_medic_hvh_m4",
				"ene_bulldozer_hvh_1",
				"ene_bulldozer_hvh_2",
				"ene_bulldozer_hvh_3",
				"ene_fbi_swat_hvh_1",
				"ene_fbi_swat_hvh_2",
				"ene_fbi_heavy_hvh_1",
				"ene_fbi_heavy_hvh_r870",
				"ene_sniper_hvh_2"
			}
		},
		des = {
			path = "units/pd2_dlc_des/characters/",
			list = {
				"ene_murkywater_no_light_not_security",
				"ene_murkywater_not_security_1",
				"ene_murkywater_not_security_2",
				"ene_male_des",
				"civ_male_hazmat",
				"civ_male_des_scientist_01",
				"civ_male_des_scientist_02"
			}
		},		
		tag = {
			path = "units/pd2_dlc_tag/characters/",
			list = {"ene_male_commissioner"}			
		},	
		nmh = {
			path = "units/pd2_dlc_nmh/characters/",
			list = {
				"civ_male_doctor_01",
				"civ_male_doctor_02",
				"civ_male_doctor_03",
				"civ_male_scrubs_01",
				"civ_male_scrubs_02",
				"civ_male_scrubs_03",
				"civ_male_scrubs_04",
				"civ_female_scrubs_01",
				"civ_female_scrubs_02",
				"civ_female_scrubs_03",
				"civ_female_scrubs_04",
				"civ_female_doctor_01",
				"civ_female_hotpants"
			}
		},			
		sah = {
			path = "units/pd2_dlc_sah/characters/",
			list = {
				"civ_male_gala_guest_03",
				"civ_male_gala_guest_04",
				"civ_male_gala_guest_05",
				"civ_male_gala_guest_06",
				"civ_male_auctioneer",
				"civ_female_gala_guest_04",
				"civ_female_gala_guest_05",
				"civ_female_gala_guest_06",
				"civ_male_shacklethorn_waiter_01",
				"civ_male_shacklethorn_waiter_02",
				"civ_male_maintenance_01"
			}
		},
		skm = {
			path = "units/pd2_skirmish/characters/",
			list = {
				"civ_male_bank_manager_hostage",
				"civ_female_museum_curator_hostage",
				"civ_female_drug_lord_hostage",
				"civ_male_prisoner_hostage"
			}				
		},
		bph = {
			path = "units/pd2_dlc_bph/characters/",
			list = {
				"civ_male_locke_escort",
				"civ_male_bain",
				"ene_male_bain",
				"ene_murkywater_medic",
				"ene_murkywater_medic_r870",
				"ene_murkywater_tazer",
				"ene_murkywater_cloaker",
				"ene_murkywater_bulldozer_1",
				"ene_murkywater_bulldozer_2",
				"ene_murkywater_bulldozer_3",
				"ene_murkywater_bulldozer_4",
				"ene_murkywater_bulldozer_medic",
				"ene_murkywater_shield",
				"ene_murkywater_sniper",
				"ene_murkywater_heavy",
				"ene_murkywater_heavy_shotgun",
				"ene_murkywater_heavy_g36",
				"ene_murkywater_light_city",
				"ene_murkywater_light_city_r870",
				"ene_murkywater_light_fbi_r870",
				"ene_murkywater_light_fbi",
				"ene_murkywater_light",
				"ene_murkywater_light_r870"
			}
		},
		vit = {
			path = "units/pd2_dlc_vit/characters/",
			list = {"ene_murkywater_secret_service"}
		},	
		uno = {
			path = "units/pd2_dlc_uno/characters/",
			list = {
				"ene_shadow_cloaker_1",
				"ene_shadow_cloaker_2"
			}
		},
		mex = {
			path = "units/pd2_dlc_mex/characters/",
			list = {
				"ene_mex_security_guard",
				"ene_mex_security_guard_2",
				"ene_mex_security_guard_3",
				"ene_mex_thug_outdoor_01",
				"ene_mex_thug_outdoor_02",
				"ene_mex_thug_outdoor_03",
				"civ_male_italian"
			}				
		},
		pex = {
			path = "units/pd2_dlc_pex/characters/",
			list = {
				"civ_male_prisoner_pex",
				"civ_male_prisoner_pex_bloody",
				"civ_male_janitor_pex_01",
				"civ_male_janitor_pex_02",
				"ene_male_office_cop_01",
				"ene_male_office_cop_02",
				"ene_male_office_cop_03",
				"ene_male_office_cop_04",
				"ene_female_office_cop_01",
				"npc_male_vladbroinlaw_pex",
				"npc_male_vladbroinlaw_pex_bloody",
				"npc_male_vladbroinlaw_cop_pex"
			}
		},		
		bex = {
			path = "units/pd2_dlc_bex/characters/",
			list = {
				"ene_swat_policia_federale",
				"ene_swat_policia_federale_sc",
				"ene_swat_policia_federale_r870",
				"ene_swat_policia_federale_city",
				"ene_swat_policia_federale_city_r870",
				"ene_swat_policia_federale_city_ump",
				"ene_swat_policia_federale_zeal",
				"ene_swat_policia_federale_zeal_r870",
				"ene_swat_policia_federale_zeal_ump",
				"ene_swat_policia_federale_city_fbi",
				"ene_swat_policia_federale_city_fbi_r870",
				"ene_swat_policia_federale_city_fbi_ump",
				"ene_swat_policia_federale_fbi",
				"ene_swat_policia_federale_fbi_r870",
				"ene_swat_policia_federale_fbi_ump",
				"ene_swat_medic_policia_federale",
				"ene_swat_medic_policia_federale_r870",
				"ene_swat_cloaker_policia_federale",
				"ene_swat_cloaker_policia_federale_sc",
				"ene_swat_policia_sniper",
				"ene_swat_shield_policia_federale_mp9_fbi",
				"ene_swat_shield_policia_federale_mp9_sc",
				"ene_swat_shield_policia_federale_mp9",
				"ene_swat_shield_policia_federale_c45",
				"ene_swat_tazer_policia_federale",
				"ene_swat_heavy_policia_federale",
				"ene_swat_heavy_policia_federale_r870",
				"ene_swat_heavy_policia_federale_g36",
				"ene_swat_heavy_policia_federale_fbi",
				"ene_swat_heavy_policia_federale_fbi_r870",
				"ene_swat_heavy_policia_federale_fbi_g36",
				"ene_swat_heavy_policia_federale_city_r870",
				"ene_swat_heavy_policia_federale_city_g36",
				"ene_swat_heavy_policia_federale_zeal_r870",
				"ene_swat_heavy_policia_federale_zeal_g36",
				"ene_swat_dozer_medic_policia_federale",
				"ene_swat_dozer_policia_federale_r870",
				"ene_swat_dozer_policia_federale_saiga",
				"ene_swat_dozer_policia_federale_m249",
				"ene_swat_dozer_policia_federale_minigun",
				"ene_policia_01",
				"ene_policia_02",
				"ene_policia_03",
				"ene_policia_04",
				"ene_fbi_1",
				"ene_fbi_2",
				"ene_fbi_3",
				"ene_grenadier_1",
				"ene_bex_security_01",
				"ene_bex_security_02",
				"ene_bex_security_03",
				"ene_bex_security_suit_01",
				"ene_bex_security_suit_02",
				"ene_bex_security_suit_03",
				"civ_male_it_guy",
				"ene_veteran_enrique_1",
				"ene_veteran_enrique_2",
				"civ_male_bex_bank_manager",
				"civ_male_bex_business",
				"civ_male_mariachi_01",
				"civ_male_mariachi_02",
				"civ_male_mariachi_03",
				"civ_male_mariachi_04"
			}
		},		
		fex = {
			path = "units/pd2_dlc_fex/characters/",
			list = {
				"civ_female_masquerade_1",
				"civ_female_masquerade_2",
				"civ_female_masquerade_3",
				"civ_female_masquerade_4",
				"civ_male_masquerade_1",
				"civ_male_masquerade_2",
				"civ_male_masquerade_3",
				"civ_male_masquerade_4",
				"ene_guard_dog_mask",
				"ene_guard_dog_mask_no_pager",
				"ene_guard_jaguar_mask",
				"ene_guard_jaguar_mask_no_pager",
				"ene_guard_owl_mask",
				"ene_guard_owl_mask_no_pager",
				"ene_guard_serpent_mask",
				"ene_guard_serpent_mask_no_pager",
				"ene_thug_outdoor_fex",
				"ene_secret_service_fex"
			}
		},
		chas = {
			path = "units/pd2_dlc_chas/characters/",
			list = {
				"ene_male_triad_gang_1",
				"ene_male_triad_gang_2",
				"ene_male_triad_gang_3",
				"ene_male_triad_gang_4",
				"ene_male_triad_gang_5",
				"civ_male_asian_casual_1",
				"civ_male_asian_casual_2",
				"civ_male_asian_casual_3",
				"civ_female_asian_casual_1",
				"civ_female_asian_storekeeper",
				"civ_male_auctioneer_2",
				"ene_male_chas_police_01",
				"ene_male_chas_police_02"
			}
		},
		sand = {
			path = "units/pd2_dlc_sand/characters/",
			list = {
				"civ_male_vlad",
				"civ_male_dockworker_01",
				"civ_male_dockworker_02",
				"civ_male_dockworker_03"	
			}
		},
		sharks = {
			path = "units/pd2_mod_sharks/characters/",
			list = {
				"ene_murky_cs_cop_c45",
				"ene_murky_cs_cop_mp5",
				"ene_murky_cs_cop_r870",
				"ene_murky_cs_cop_raging_bull",
				"ene_fbi_3",
				"ene_murky_swat_r870",
				"ene_fbi_1",
				"ene_fbi_2",
				"ene_fbi_swat_1",
				"ene_fbi_swat_2",
				"ene_fbi_swat_3",
				"ene_fbi_heavy_1",
				"ene_fbi_heavy_r870",
				"ene_swat_heavy_1",
				"ene_swat_heavy_r870",
				"ene_murky_shield_yellow",
				"ene_murky_shield_fbi",
				"ene_city_swat_1",
				"ene_city_swat_2",
				"ene_city_swat_3",
				"ene_murky_fbi_tank_m249",
				"ene_murky_fbi_tank_medic",
				"ene_murky_fbi_tank_saiga",
				"ene_murky_fbi_tank_r870",
				"ene_murky_spook",
				"ene_murky_veteran_1",
				"ene_grenadier_1",
				"ene_murky_medic_m4",
				"ene_murky_tazer",
				"ene_swat_1",
				"ene_swat_2",
				"ene_murky_sniper"
			}
		},
		omnia = {
			path = "units/pd2_mod_omnia/characters/",
			list = {
				"ene_omnia_hrt_1",
				"ene_omnia_hrt_2",		
				"ene_omnia_hrt_3",
				"ene_omnia_crew",
				"ene_omnia_crew_2",
				"ene_omnia_city",
				"ene_omnia_city_2",
				"ene_omnia_city_3",
				"ene_omnia_heavy",
				"ene_omnia_heavy_r870",
				"ene_bulldozer_1",
				"ene_bulldozer_2",
				"ene_bulldozer_3",
				"ene_omnia_spook",
				"ene_grenadier_1",
				"ene_omnia_medic",
				"ene_omnia_taser",
				"ene_omnia_shield"					
			}
		},
		nypd = {
			path = "units/pd2_mod_nypd/characters/",
			list = {
				"ene_shield_1",
				"ene_sniper_1",
				"ene_fbi_swat_1",
				"ene_fbi_swat_2",
				"ene_fbi_swat_3",
				"ene_fbi_heavy_1",
				"ene_fbi_heavy_r870",
				"ene_fbi_heavy_r870_sc",
				"ene_spook_1",
				"ene_bulldozer_1",
				"ene_bulldozer_2",
				"ene_nypd_heavy_m4",					
				"ene_nypd_medic",
				"ene_tazer_1",
				"ene_fbi_2",	
				"ene_fbi_3",	
				"ene_nypd_veteran_cop_1",		
				"ene_nypd_veteran_cop_2",										
				"ene_nypd_heavy_r870",
				"ene_nypd_swat_1",
				"ene_nypd_swat_2",
				"ene_nypd_shield",
				"ene_nypd_murky_1",
				"ene_nypd_murky_2",
				"ene_cop_1",
				"ene_cop_2",
				"ene_cop_3",
				"ene_cop_4"
			}
		},
		lapd = {
			path = "units/pd2_mod_lapd/characters/",
			list = {
				"ene_shield_1",
				"ene_shield_2",
				"ene_cop_1",
				"ene_cop_2",
				"ene_cop_3",
				"ene_cop_4",				
				"ene_sniper_1",				
				"ene_fbi_swat_1",
				"ene_fbi_swat_2",
				"ene_fbi_3",
				"ene_city_shield",				
				"ene_fbi_2",
				"ene_fbi_swat_3",
				"ene_city_swat_1",
				"ene_city_swat_2",
				"ene_city_swat_3",
				"ene_bulldozer_3",
				"ene_fbi_heavy_1",
				"ene_fbi_heavy_r870",
				"ene_fbi_heavy_r870_sc",
				"ene_city_heavy_g36",
				"ene_city_heavy_r870_sc",
				"ene_swat_1",
				"ene_swat_2",
				"ene_swat_heavy_1",
				"ene_swat_heavy_r870",
				"ene_lapd_veteran_cop_1",
				"ene_lapd_veteran_cop_2"
			}
		},
		bravo = {
			path = "units/pd2_mod_bravo/characters/",
			list = {
				"ene_bravo_dmr",
				"ene_bravo_lmg",
				"ene_bravo_rifle",
				"ene_bravo_shotgun",
				"ene_bravo_dmr_ru",
				"ene_bravo_lmg_ru",
				"ene_bravo_rifle_ru",
				"ene_bravo_shotgun_ru",
				"ene_bravo_dmr_murky",
				"ene_bravo_lmg_murky",
				"ene_bravo_rifle_murky",
				"ene_bravo_shotgun_murky",
				"ene_bravo_dmr_mex",
				"ene_bravo_lmg_mex",
				"ene_bravo_rifle_mex",
				"ene_bravo_shotgun_mex"
			}
		},
		dave = {
			path = "units/pd2_mod_dave/characters/",
			list = {
				"ene_big_dave"
			}
		},
		halloween = {
			path = "units/pd2_mod_halloween/characters/",
			list = {
				"ene_skele_swat",
				"ene_skele_swat_2",
				"ene_zeal_city_1",
				"ene_zeal_city_2",
				"ene_zeal_city_3",
				"ene_zeal_swat_heavy_sc",
				"ene_zeal_swat_heavy_r870_sc",
				"ene_city_swat_1",
				"ene_city_swat_2",
				"ene_city_swat_3",
				"ene_fbi_swat_3",
				"ene_medic_mp5",
				"ene_zeal_fbi_m4",
				"ene_zeal_fbi_mp5",
				"ene_zeal_swat_shield",
				"ene_zeal_bulldozer",
				"ene_zeal_bulldozer_2",
				"ene_zeal_bulldozer_3",
				"ene_zeal_cloaker",
				"ene_grenadier_1",
				"ene_zeal_tazer",
				"ene_shield_gensec",
				"ene_fbi_heavy_r870_sc",
				"ene_city_heavy_r870_sc",
				"ene_swat_heavy_r870_sc",
				"ene_headless_hatman",				
				"ene_spook_cloak_1",	
				"ene_omnia_lpf",
				"ene_fbi_titan_1",
				"ene_titan_sniper",
				"ene_titan_taser",
				"ene_veteran_cop_1",
				"ene_phalanx_1_assault"
			}
		}			
	}
	return char_map
end

function CharacterTweakData:_process_weapon_usage_table(weap_usage_table)
end

function CharacterTweakData:_set_easy()
	self:_set_normal()
end

function CharacterTweakData:_set_normal()
	self:_calculate_heal_cooldowns(15)
	self:_multiply_all_hp(0.5, 1)
	self:_multiply_all_damage(0.3, 0.45, 0.5)
	self:_multiply_teamai_health(0.3, 0.3)

	--No normal tase for Elektra on lower difficulties
	self.taser_summers.weapon.is_rifle.tase_distance = 0
	
	--No Frags on Spring on lower difficulties
	self.spring.grenade = nil		
	self.headless_hatman.grenade = nil
	
	self:_set_characters_dodge_preset("athletic")
	self:_set_characters_melee_preset("1", "1")

	self.flashbang_multiplier = 2
	self.concussion_multiplier = 1

	self:_multiply_all_speeds(1, 1)

	self.weap_unit_names[19] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[23] = Idstring("units/payday2/weapons/wpn_npc_mp5_tactical/wpn_npc_mp5_tactical")
	self.weap_unit_names[31] = Idstring("units/payday2/weapons/wpn_npc_benelli/wpn_npc_benelli")	
	if job == "tag" or job == "xmn_tag" then
		self.weap_unit_names[59] = Idstring("units/payday2/weapons/wpn_npc_raging_bull/wpn_npc_raging_bull")
	end		
end

function CharacterTweakData:_set_hard()
	self:_calculate_heal_cooldowns(15)
	self:_multiply_all_hp(0.625, 1)
	self:_multiply_all_damage(0.5, 0.75, 0.625)
	self:_multiply_teamai_health(0.5, 0.3)

	--No normal tase for Elektra on lower difficulties
	self.taser_summers.weapon.is_rifle.tase_distance = 0	

	--No Frags on Spring on lower difficulties
	self.spring.grenade = nil		
	self.headless_hatman.grenade = nil
	
	self:_set_characters_dodge_preset("athletic")
	self:_set_characters_melee_preset("1", "1")
	self.flashbang_multiplier = 2
	self.concussion_multiplier = 1
	self:_multiply_all_speeds(1, 1)
	self.weap_unit_names[6] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[19] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[23] = Idstring("units/payday2/weapons/wpn_npc_mp5_tactical/wpn_npc_mp5_tactical")
	self.weap_unit_names[31] = Idstring("units/payday2/weapons/wpn_npc_benelli/wpn_npc_benelli")
	self.weap_unit_names[69] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")	
	self.weap_unit_names[70] = Idstring("units/pd2_dlc_mad/weapons/wpn_npc_ak47/wpn_npc_ak47")
	if job == "tag" or job == "xmn_tag" then
		self.weap_unit_names[59] = Idstring("units/payday2/weapons/wpn_npc_raging_bull/wpn_npc_raging_bull")
	end		
end

function CharacterTweakData:_set_overkill()
	self:_calculate_heal_cooldowns(15)
	self:_multiply_all_hp(0.75, 2)
	self:_multiply_all_damage(0.7, 1.05, 0.75)
	self:_multiply_teamai_health(0.7, 0.3)

	--No normal tase for Elektra on lower difficulties
	self.taser_summers.weapon.is_rifle.tase_distance = 0
	
	--No Frags on Spring on lower difficulties
	self.spring.grenade = nil
	self.headless_hatman.grenade = nil	
		
	self:_set_characters_dodge_preset("athletic_very_hard")
	self:_set_characters_melee_preset("2", "1")
	self.flashbang_multiplier = 2
	self.concussion_multiplier = 1
	self:_multiply_all_speeds(1, 1)
	self.weap_unit_names[19] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[23] = Idstring("units/payday2/weapons/wpn_npc_mp5_tactical/wpn_npc_mp5_tactical")
	self.weap_unit_names[31] = Idstring("units/payday2/weapons/wpn_npc_benelli/wpn_npc_benelli")	
	self.weap_unit_names[69] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")	
	self.weap_unit_names[70] = Idstring("units/pd2_dlc_mad/weapons/wpn_npc_ak47/wpn_npc_ak47")	
	if job == "tag" or job == "xmn_tag" then
		self.weap_unit_names[59] = Idstring("units/payday2/weapons/wpn_npc_raging_bull/wpn_npc_raging_bull")
	end		
end

function CharacterTweakData:_set_overkill_145()
	self:_calculate_heal_cooldowns(15)
	self:_multiply_all_hp(0.825, 2)
	self:_multiply_all_damage(0.9, 1.35, 0.825)
	self:_multiply_teamai_health(0.9, 0.25)
			
	self:_set_characters_dodge_preset("athletic_overkill")
	self:_set_characters_melee_preset("2.8", "2")
	self.fbi.can_shoot_while_dodging = true
	self.swat.can_shoot_while_dodging = true
	self.hrt.can_shoot_while_dodging = true
	self.fbi.can_slide_on_suppress = true
	self.swat.can_slide_on_suppress = true
	self.hrt.can_slide_on_suppress = true
	
	self.flashbang_multiplier = 2
	self.concussion_multiplier = 1
	self:_multiply_all_speeds(1, 1)
	self.weap_unit_names[19] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[23] = Idstring("units/payday2/weapons/wpn_npc_mp5_tactical/wpn_npc_mp5_tactical")
	self.weap_unit_names[31] = Idstring("units/payday2/weapons/wpn_npc_benelli/wpn_npc_benelli")	
	if job == "tag" or job == "xmn_tag" then
		self.weap_unit_names[59] = Idstring("units/payday2/weapons/wpn_npc_raging_bull/wpn_npc_raging_bull")
	end
end

function CharacterTweakData:_set_easy_wish()
	self:_calculate_heal_cooldowns(15)
	self:_multiply_all_hp(1, 2)
	self:_multiply_all_damage(1, 1.5, 1)
	self:_multiply_teamai_health(1, 0.25)

	self:_set_characters_weapon_preset("expert", "good")
	self:_set_characters_dodge_preset("athletic_overkill")
	self.fbi.can_shoot_while_dodging = true
	self.swat.can_shoot_while_dodging = true	
	self.hrt.can_shoot_while_dodging = true
	self.fbi.can_slide_on_suppress = true		
	self.swat.can_slide_on_suppress = true		
	self.hrt.can_slide_on_suppress = true	
	self.fbi_swat.can_slide_on_suppress = true		 
	self.city_swat.can_slide_on_suppress = true		
	self.city_swat_guard.can_slide_on_suppress = true	
	self:_set_characters_melee_preset("2.8", "2")

	self.flashbang_multiplier = 2
	self.concussion_multiplier = 1
	self:_multiply_all_speeds(1, 1)
	self.weap_unit_names[19] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[23] = Idstring("units/payday2/weapons/wpn_npc_mp5_tactical/wpn_npc_mp5_tactical")
	self.weap_unit_names[31] = Idstring("units/payday2/weapons/wpn_npc_benelli/wpn_npc_benelli")	
	if job == "tag" or job == "xmn_tag" then
		self.weap_unit_names[59] = Idstring("units/payday2/weapons/wpn_npc_raging_bull/wpn_npc_raging_bull")
	end
end

function CharacterTweakData:_set_overkill_290()
	self:_calculate_heal_cooldowns(15)
	self:_multiply_all_hp(1, 2)
	self:_multiply_all_damage(1, 1.5, 1)
	self:_multiply_teamai_health(1, 0.25)

	self:_set_characters_dodge_preset("deathwish")
	self.fbi.can_shoot_while_dodging = true
	self.swat.can_shoot_while_dodging = true	
	self.hrt.can_shoot_while_dodging = true
	self.fbi.can_slide_on_suppress = true		
	self.swat.can_slide_on_suppress = true	
	self.hrt.can_slide_on_suppress = true	
	self.fbi_swat.can_slide_on_suppress = true		
	self.city_swat.can_slide_on_suppress = true
	self.city_swat_guard.can_slide_on_suppress = true
	
	--Titan SWAT stun resistance
	self.city_swat_titan.damage.hurt_severity = self.presets.hurt_severities.elite	
	self.city_swat_titan.use_animation_on_fire_damage = false
	self.city_swat_titan_assault.damage.hurt_severity = self.presets.hurt_severities.elite	
	self.city_swat_titan_assault.use_animation_on_fire_damage = false
	self.skeleton_swat_titan.damage.hurt_severity = self.presets.hurt_severities.elite	
	self.skeleton_swat_titan.use_animation_on_fire_damage = false	
	self.weekend_lmg.damage.hurt_severity = self.presets.hurt_severities.elite	
	self.weekend_lmg.use_animation_on_fire_damage = false				
	
	--Fast HRTs
	self.fbi.move_speed = self.presets.move_speed.lightning
	self.hrt.move_speed = self.presets.move_speed.lightning
	
	self.flashbang_multiplier = 2
	self.concussion_multiplier = 1
	self:_multiply_all_speeds(1, 1)
	self.weap_unit_names[19] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[23] = Idstring("units/payday2/weapons/wpn_npc_mp5_tactical/wpn_npc_mp5_tactical")
	self.weap_unit_names[31] = Idstring("units/payday2/weapons/wpn_npc_benelli/wpn_npc_benelli")
	if job == "tag" or job == "xmn_tag" then
		self.weap_unit_names[59] = Idstring("units/payday2/weapons/wpn_npc_raging_bull/wpn_npc_raging_bull")
	end		
end

function CharacterTweakData:_set_sm_wish()
	self:_calculate_heal_cooldowns(15)
	self:_multiply_all_hp(1, 3)
	self:_multiply_all_damage(1, 1.5, 1)
	self:_multiply_teamai_health(1, 0.2)
	
	self:_set_characters_dodge_preset("deathwish")
	self:_set_characters_melee_preset("3.5", "2.8")
	self.fbi.can_shoot_while_dodging = true
	self.swat.can_shoot_while_dodging = true
	self.hrt.can_shoot_while_dodging = true
	self.fbi.can_slide_on_suppress = true
	self.swat.can_slide_on_suppress = true
	self.hrt.can_slide_on_suppress = true
	self.fbi_swat.can_slide_on_suppress = true
	self.city_swat.can_slide_on_suppress = true
	self.city_swat_guard.can_slide_on_suppress = true
	self.fbi_heavy_swat.can_slide_on_suppress = true
	
	self.weap_unit_names[13] = Idstring("units/payday2/weapons/wpn_npc_sniper_sc/wpn_npc_sniper_sc")		
	self.weap_unit_names[21] = Idstring("units/pd2_dlc_mad/weapons/wpn_npc_svd_sc/wpn_npc_svd_sc")		
	
	self.shield.damage.hurt_severity = self.presets.hurt_severities.no_hurts
	
	self.city_swat.can_shoot_while_dodging = true
	self.city_swat_guard.can_shoot_while_dodging = true	
	
	self:_multiply_all_speeds(1, 1)
	self.flashbang_multiplier = 2
	self.concussion_multiplier = 1
	
	--Titan SWAT smoke dodging
	self.heavy_swat.dodge_with_grenade = {
		smoke = {duration = {
			12,
			12
		}},
		check = function (t, nr_grenades_used)
			local delay_till_next_use = 30
			local chance = 0.15

			if math.random() < chance then
				return true, t + delay_till_next_use
			end

			return false, t + delay_till_next_use
		end
	}	
	self.fbi_swat.dodge_with_grenade = {
		smoke = {duration = {
			12,
			12
		}},
		check = function (t, nr_grenades_used)
			local delay_till_next_use = 30
			local chance = 0.15

			if math.random() < chance then
				return true, t + delay_till_next_use
			end

			return false, t + delay_till_next_use
		end
	}	
	self.city_swat.dodge_with_grenade = {
		smoke = {duration = {
			12,
			12
		}},
		check = function (t, nr_grenades_used)
			local delay_till_next_use = 30
			local chance = 0.15

			if math.random() < chance then
				return true, t + delay_till_next_use
			end

			return false, t + delay_till_next_use
		end
	}
	self.weekend.dodge_with_grenade = {
		smoke = {duration = {
			12,
			12
		}},
		check = function (t, nr_grenades_used)
			local delay_till_next_use = 30
			local chance = 0.15

			if math.random() < chance then
				return true, t + delay_till_next_use
			end

			return false, t + delay_till_next_use
		end
	}
	self.weekend_lmg.dodge_with_grenade = {
		smoke = {duration = {
			12,
			12
		}},
		check = function (t, nr_grenades_used)
			local delay_till_next_use = 30
			local chance = 0.1

			if math.random() < chance then
				return true, t + delay_till_next_use
			end

			return false, t + delay_till_next_use
		end
	}		
	
	--Titan SWAT stun resistance
	self.city_swat_titan.damage.hurt_severity = self.presets.hurt_severities.elite
	self.city_swat_titan.use_animation_on_fire_damage = false
	self.city_swat_titan_assault.damage.hurt_severity = self.presets.hurt_severities.elite
	self.city_swat_titan_assault.use_animation_on_fire_damage = false
	self.skeleton_swat_titan.damage.hurt_severity = self.presets.hurt_severities.elite
	self.skeleton_swat_titan.use_animation_on_fire_damage = false
	self.weekend_lmg.damage.hurt_severity = self.presets.hurt_severities.elite
	self.weekend_lmg.use_animation_on_fire_damage = false

	--Fast Titan HRTs
	self.fbi.move_speed = self.presets.move_speed.lightning
	self.hrt.move_speed = self.presets.move_speed.lightning
	
	--Titandozers become immune to stunning
	self.tank_titan.damage.hurt_severity = self.presets.hurt_severities.no_hurts_no_tase
	self.tank_titan_assault.damage.hurt_severity = self.presets.hurt_severities.no_hurts_no_tase	
	self.tank_hw.damage.hurt_severity = self.presets.hurt_severities.no_hurts_no_tase
	
	--Winters can now overheal special enemies
	self.phalanx_vip.do_omnia.overheal_specials = true

	self.weap_unit_names[19] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[23] = Idstring("units/payday2/weapons/wpn_npc_mp5_tactical/wpn_npc_mp5_tactical")
	self.weap_unit_names[31] = Idstring("units/payday2/weapons/wpn_npc_benelli/wpn_npc_benelli")
	if job == "tag" or job == "xmn_tag" then
		self.weap_unit_names[59] = Idstring("units/payday2/weapons/wpn_npc_raging_bull/wpn_npc_raging_bull")
	end		
end

function CharacterTweakData:is_special_unit(enemy_tweak)
	local is_special = false
	if self[enemy_tweak].is_special then
		is_special = true
	end
	return is_special
end

--Sets enemy heal cooldowns to be values proportional to their head health.
--healing_speed == amount of head health a medic can heal per second.
function CharacterTweakData:_calculate_heal_cooldowns(healing_speed)
	hs_mul = headshot_difficulty_array[3] --Initial health values use DS numbers, so use DS headshot muls.
	for _, enemy_tweak in ipairs(self._enemy_list) do
		local enemy = self[enemy_tweak]
		if enemy and enemy.heal_cooldown then
			enemy.heal_cooldown = enemy.HEALTH_INIT / (enemy.headshot_dmg_mul * hs_mul * healing_speed)
		end
	end
end

function CharacterTweakData:_multiply_all_hp(health_mul, headshot_index)
	--Get new headshot multiplier.
	local hs_mul = headshot_difficulty_array[headshot_index] --Get headshot multiplier.
	local hp_mul = health_mul * (hs_mul / headshot_difficulty_array[3]) --Get overall hp mul. Compensate for lower headshot mults by reducing body health.

	for _, enemy_tweak in ipairs(self._enemy_list) do
		local enemy = self[enemy_tweak]
		if enemy then
			enemy.HEALTH_INIT = enemy.HEALTH_INIT * hp_mul
			enemy.headshot_dmg_mul = enemy.headshot_dmg_mul * hs_mul
			if enemy.DAMAGE_CLAMP_BULLET then
				enemy.DAMAGE_CLAMP_BULLET = enemy.DAMAGE_CLAMP_BULLET * hp_mul
			end

			--REMOVE THESE EXTRA MULS ONCE PERK DECKS ALLOW FOR THESE TYPES OF DAMAGE TO SCALE!
			enemy.damage.explosion_damage_mul = (enemy.damage.explosion_damage_mul or 1) * hp_mul --Explosives deal same relative damage on all difficulties until perk deck damage boost works on them.
			enemy.damage.fire_pool_damage_mul = (enemy.damage.fire_pool_damage_mul or 1) * hp_mul --Ditto for fire pools.
			enemy.damage.dot_damage_mul = (enemy.damage.dot_damage_mul or 1) * hp_mul --Ditto for DOT
		end
	end
end

function CharacterTweakData:_multiply_all_speeds(walk_mul, run_mul)
	for _, enemy_tweak in ipairs(self._enemy_list) do
		if self[enemy_tweak] then
			local speed_preset = deep_clone(self[enemy_tweak].move_speed)

			self[enemy_tweak].move_speed = speed_preset

			speed_preset.stand.walk.hos.fwd = speed_preset.stand.walk.hos.fwd * walk_mul
			speed_preset.stand.walk.hos.strafe = speed_preset.stand.walk.hos.strafe * walk_mul
			speed_preset.stand.walk.hos.bwd = speed_preset.stand.walk.hos.bwd * walk_mul
			speed_preset.stand.walk.cbt.fwd = speed_preset.stand.walk.cbt.fwd * walk_mul
			speed_preset.stand.walk.cbt.strafe = speed_preset.stand.walk.cbt.strafe * walk_mul
			speed_preset.stand.walk.cbt.bwd = speed_preset.stand.walk.cbt.bwd * walk_mul
			speed_preset.stand.run.hos.fwd = speed_preset.stand.run.hos.fwd * run_mul
			speed_preset.stand.run.hos.strafe = speed_preset.stand.run.hos.strafe * run_mul
			speed_preset.stand.run.hos.bwd = speed_preset.stand.run.hos.bwd * run_mul
			speed_preset.stand.run.cbt.fwd = speed_preset.stand.run.cbt.fwd * run_mul
			speed_preset.stand.run.cbt.strafe = speed_preset.stand.run.cbt.strafe * run_mul
			speed_preset.stand.run.cbt.bwd = speed_preset.stand.run.cbt.bwd * run_mul
			speed_preset.crouch.walk.hos.fwd = speed_preset.crouch.walk.hos.fwd * walk_mul
			speed_preset.crouch.walk.hos.strafe = speed_preset.crouch.walk.hos.strafe * walk_mul
			speed_preset.crouch.walk.hos.bwd = speed_preset.crouch.walk.hos.bwd * walk_mul
			speed_preset.crouch.walk.cbt.fwd = speed_preset.crouch.walk.cbt.fwd * walk_mul
			speed_preset.crouch.walk.cbt.strafe = speed_preset.crouch.walk.cbt.strafe * walk_mul
			speed_preset.crouch.walk.cbt.bwd = speed_preset.crouch.walk.cbt.bwd * walk_mul
			speed_preset.crouch.run.hos.fwd = speed_preset.crouch.run.hos.fwd * run_mul
			speed_preset.crouch.run.hos.strafe = speed_preset.crouch.run.hos.strafe * run_mul
			speed_preset.crouch.run.hos.bwd = speed_preset.crouch.run.hos.bwd * run_mul
			speed_preset.crouch.run.cbt.fwd = speed_preset.crouch.run.cbt.fwd * run_mul
			speed_preset.crouch.run.cbt.strafe = speed_preset.crouch.run.cbt.strafe * run_mul
			speed_preset.crouch.run.cbt.bwd = speed_preset.crouch.run.cbt.bwd * run_mul
		end
	end
end

function CharacterTweakData:_set_characters_dodge_preset(preset)
	for _, enemy_tweak in ipairs(self._enemy_list) do
		if self[enemy_tweak] then
			if not self[enemy_tweak].static_dodge_preset then
				if not self:is_special_unit(enemy_tweak) then
					self[enemy_tweak].dodge = self.presets.dodge[preset]
				end
			end
		end
	end
end

function CharacterTweakData:_set_characters_melee_preset(preset, special_preset)
	for _, enemy_tweak in ipairs(self._enemy_list) do
		if self[enemy_tweak] then
			if not self[enemy_tweak].static_melee_preset then
				if not self:is_special_unit(enemy_tweak) then
					self[enemy_tweak].melee_weapon_dmg_multiplier = preset
				else
					self[enemy_tweak].melee_weapon_dmg_multiplier = special_preset
				end
			end
		end
	end
end

function CharacterTweakData:_multiply_weapon_preset(preset, accuracy_mul, aim_delay_mul, focus_delay_mul, recoil_mul, reload_speed_mul)
	preset.aim_delay = {preset.aim_delay[1] * aim_delay_mul, preset.aim_delay[2] * aim_delay_mul}
	preset.RELOAD_SPEED = preset.RELOAD_SPEED * reload_speed_mul
	preset.focus_delay = preset.focus_delay * focus_delay_mul
	for i = 1, #preset.FALLOFF do
		if preset.FALLOFF[i].r > 300 then
			preset.FALLOFF[i].acc = {preset.FALLOFF[i].acc[1] * accuracy_mul, preset.FALLOFF[i].acc[2] * accuracy_mul}
		end
		preset.FALLOFF[i].recoil = {preset.FALLOFF[i].recoil[1] * recoil_mul, preset.FALLOFF[i].recoil[2] * recoil_mul}
	end
end

function CharacterTweakData:_multiply_all_damage(mul, gang_mul, teamai_mul)
	for tier_name, preset_tier in pairs(self.presets.weapon) do
		
		--Select relevant multiplier.
		local current_dmg_mul = mul
		if tier_name == "gangster" then
			current_dmg_mul = gang_mul
		elseif tier_name == "gang_member" then
			current_dmg_mul = teamai_mul
		end

		--Apply multiplier.
		for preset_name, preset in pairs(preset_tier) do
			if preset.melee_dmg then
				preset.melee_dmg = preset.melee_dmg * current_dmg_mul
			end

			for weapon, falloff_tier in pairs(preset.FALLOFF) do
				falloff_tier.dmg_mul = falloff_tier.dmg_mul * current_dmg_mul
			end
		end
	end

	self.spooc.kick_damage = 0.1 * math.ceil(self.spooc.kick_damage * 10 * mul)
	self.spooc.jump_kick_damage = 0.1 * math.ceil(self.spooc.jump_kick_damage * 10 * mul)
	self.taser.shock_damage = 0.1 * math.ceil(self.taser.shock_damage * 10 * mul)
end

function CharacterTweakData:_multiply_teamai_health(mul, grace_period)
	self.presets.gang_member_damage.HEALTH_INIT = self.presets.gang_member_damage.HEALTH_INIT * mul
	self.presets.gang_member_damage.MIN_DAMAGE_INTERVAL = grace_period
	self.old_hoxton_mission.HEALTH_INIT = self.presets.gang_member_damage.HEALTH_INIT
	self.spa_vip.HEALTH_INIT = self.presets.gang_member_damage.HEALTH_INIT
end