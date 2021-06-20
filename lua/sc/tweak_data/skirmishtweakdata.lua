function SkirmishTweakData:_init_group_ai_data(tweak_data)
	local skirmish_data = deep_clone(tweak_data.group_ai.besiege)
	tweak_data.group_ai.skirmish = skirmish_data

	self.required_kills = {
		40, --Placeholder value, ignore.
		40, --Wave 1
		44, --Wave 2
		48, --Wave 3
		52, --Wave 4
		56, --Wave 5
		60, --Wave 6
		64, --Wave 7
		68, --Wave 8
		72, --Wave 9 (req kills == kills needed until captain can spawn)
		80,
		120
	}

	self.required_kills_balance_mul = {
		0.55,
		0.7,
		0.85,
		1
	}
end

function SkirmishTweakData:_init_wave_phase_durations(tweak_data)
	local skirmish_data = tweak_data.group_ai.skirmish

	skirmish_data.assault.anticipation_duration = {
		{15, 1}
	}

	skirmish_data.assault.build_duration = 15
	skirmish_data.assault.sustain_duration_min = {
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999
	}

	skirmish_data.assault.sustain_duration_max = {
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999
	}

	skirmish_data.assault.sustain_duration_balance_mul = {
		1,
		1,
		1,
		1
	}

	skirmish_data.assault.fade_duration = 5
	skirmish_data.assault.delay = {
		20,
		20,
		20,
		20,
		25,
		25,
		25,
		30,
		30,
		30,
		30,
		30
	}

	skirmish_data.regroup.duration = {
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5
	}

	skirmish_data.assault.hostage_hesitation_delay = {
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5
	}

	--Assaults have infinite resources, end based on kills.
	skirmish_data.assault.force_pool = {
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999,
		99999
	}

	--Temp
	skirmish_data.assault.force = {
		10,
		10,
		11,
		12,
		13,
		14,
		15,
		16,
		17,
		18,
		20,
		30
	}

	skirmish_data.recon.force = {
		4,
		4,
		4,
		4,
		4,
		4,
		4,
		4,
		4,
		4,
		4,
		4
	}

	skirmish_data.recon.interval = {
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5
	}

	skirmish_data.assault.force_balance_mul = {
		0.55,
		0.7,
		0.85,
		1
	}

	skirmish_data.assault.force_pool_balance_mul = {
		1,
		1,
		1,
		1
	}

	skirmish_data.reenforce.interval = {
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5,
		5
	}

	skirmish_data.special_unit_spawn_limits = {
		tank = 3,
		taser = 2,
		taser_titan = 1,
		boom = 2,
		spooc = 3,
		shield = 2,
		shield_titan = 2,
		medic = 3,
		medic_lpf = 1,
		phalanx_vip = 1,
		spring = 1,
		headless_hatman = 1,
		autumn = 1,
		summers = 1
	}

	skirmish_data.group_constraints.common_wave_rush_ds.min_diff = nil
end


function SkirmishTweakData:_init_spawn_group_weights(tweak_data)
	local assault_groups = {
		{ --Wave 1
			cops_n = 0.50,
			swats_n = 0.21,
			heavys_n = 0.11,
			hostage_rescue_n = 0.08,
			shield_n = 0.1
		},
		{ --Wave 2
			cops_h = 0.15,
			swats_h = 0.31,
			heavys_h = 0.2,
			hostage_rescue_h = 0.08,
			shield_h = 0.12,
			FBI_spoocs = 0.06,
			taser_h = 0.06,
			GREEN_tanks_h = 0.02
		},
		{ --Wave 3
			swats_vh = 0.28, --Swat spawns lower than normal to allow for more HRT spawns.
			heavys_vh = 0.17,
			hostage_rescue_vh = 0.08,
			bomb_squad_vh = 0.05,
			shotguns_vh = 0.05,
			shield_vh = 0.15,
			FBI_spoocs = 0.08,
			taser_vh = 0.08,
			boom_taser_vh = 0.02,
			GREEN_tanks_vh = 0.02,
			BLACK_tanks_vh = 0.02
		},
		{ --Wave 4
			swats_ovk = 0.19,
			heavys_ovk = 0.1,
			hostage_rescue_ovk = 0.08,
			bomb_squad_ovk = 0.1,
			shotguns_ovk = 0.1,
			shield_ovk = 0.15,
			FBI_spoocs = 0.1,
			taser_ovk = 0.1,
			boom_taser_ovk = 0.02,
			GREEN_tanks_ovk = 0.04,
			BLACK_tanks_ovk = 0.02
		},
		{ --Wave 5
			swats_mh = 0.16,
			heavys_mh = 0.1,
			hostage_rescue_mh = 0.08,
			bomb_squad_mh =	0.09,
			shotguns_mh = 0.09,
			shield_mh = 0.075,
			shield_sniper_mh = 0.075,
			FBI_spoocs = 0.1,
			taser_mh = 0.07,
			boom_taser_mh = 0.07,
			GREEN_tanks_mh = 0.03,
			BLACK_tanks_mh = 0.03,
			SKULL_tanks_mh = 0.03
		},
		{ --Wave 6
			swats_dw = 0.15,
			heavys_dw = 0.1,
			hostage_rescue_dw = 0.08,
			bomb_squad_dw = 0.09,
			shotguns_dw = 0.09,
			shield_dw = 0.05,
			shield_sniper_dw = 0.1,
			FBI_spoocs = 0.075,
			cloak_spooc_dw = 0.025,
			taser_dw = 0.03,
			boom_taser_dw = 0.1,
			GREEN_tanks_dw = 0.03,
			BLACK_tanks_dw = 0.03,
			SKULL_tanks_dw = 0.03,
			Titan_tanks_dw = 0.02
		},
		{ --Wave 7
			swats_ds = 0.15,
			heavys_ds =	0.07,
			hostage_rescue_ds = 0.05,
			bomb_squad_ds = 0.09,
			shotguns_ds = 0.08,
			shield_ds = 0.05,
			shield_sniper_ds = 0.1,
			FBI_spoocs = 0.05,
			cloak_spooc_ds = 0.05,
			taser_ds = 0.03,
			boom_taser_ds = 0.1,
			common_wave_rush_ds = 0.04,
			GREEN_tanks_ds = 0.04,
			BLACK_tanks_ds = 0.04,
			SKULL_tanks_ds = 0.04,
			Titan_tanks_ds = 0.02
		},
		{ --Wave 8+
			swats_skm = 0.15,
			heavys_skm = 0.07,
			hostage_rescue_skm = 0.05,
			bomb_squad_skm = 0.09,
			shotguns_skm = 0.08,
			shield_skm = 0.05,
			shield_sniper_skm = 0.1,
			FBI_spoocs = 0.025,
			cloak_spooc_ds = 0.075,
			taser_skm = 0.03,
			boom_taser_skm = 0.1,
			common_wave_rush_skm = 0.04,
			GREEN_tanks_skm = 0.04,
			BLACK_tanks_skm = 0.04,
			SKULL_tanks_skm = 0.04,
			Titan_tanks_skm = 0.02
		},
		{ --Wave 9
			--Filled in when captain is selected.
		}
	}

	--This portion of the code will need to be cut and reworked once infinite is in progress.
	--Might be ideal to use/abuse lua virtual tables and vary them based on captain type.
	local wave_9_captain = math.random()

	if wave_9_captain < 0.23335 then --autumn
		self.captain = "Cap_Autumn"
		assault_groups[9] = {
			swats_skm = 0.16,
			heavys_skm = 0.08,
			hostage_rescue_skm = 0.1,
			bomb_squad_skm = 0.1,
			shotguns_skm = 0.1,
			shield_skm = 0.05,
			shield_sniper_skm = 0.1,
			taser_skm = 0.03,
			boom_taser_skm = 0.1,
			common_wave_rush_skm = 0.04,
			GREEN_tanks_skm = 0.04,
			BLACK_tanks_skm = 0.04,
			SKULL_tanks_skm = 0.04,
			Titan_tanks_skm = 0.02
		}
	elseif wave_9_captain < 0.4667 then --summers
		self.captain = "Cap_Summers"
		assault_groups[9] = {
			swats_skm = 0.16,
			heavys_skm = 0.08,
			hostage_rescue_skm = 0.1,
			bomb_squad_skm = 0.1,
			shotguns_skm = 0.1,
			shield_skm = 0.06,
			shield_sniper_skm = 0.11,
			FBI_spoocs = 0.025,
			cloak_spooc_ds = 0.075,
			common_wave_rush_skm = 0.04,
			GREEN_tanks_skm = 0.04,
			BLACK_tanks_skm = 0.04,
			SKULL_tanks_skm = 0.04,
			Titan_tanks_skm = 0.02
		}
	elseif wave_9_captain < 0.7005 then --winters
		self.captain = "Cap_Winters"
		assault_groups[9] = {
			swats_skm = 0.16,
			heavys_skm = 0.08,
			hostage_rescue_skm = 0.1,
			bomb_squad_skm = 0.1,
			shotguns_skm = 0.1,
			FBI_spoocs = 0.025,
			cloak_spooc_ds = 0.075,
			taser_skm = 0.04,
			boom_taser_skm = 0.11,
			common_wave_rush_skm = 0.04,
			GREEN_tanks_skm = 0.05,
			BLACK_tanks_skm = 0.05,
			SKULL_tanks_skm = 0.05,
			Titan_tanks_skm = 0.02
		}
	elseif wave_9_captain < 0.9334 then --spring
		self.captain = "Cap_Spring"
		assault_groups[9] = {
			swats_skm = 0.16,
			heavys_skm = 0.08,
			hostage_rescue_skm = 0.1,
			bomb_squad_skm = 0.1,
			shotguns_skm = 0.1,
			shield_skm = 0.06,
			shield_sniper_skm = 0.11,
			FBI_spoocs = 0.025,
			cloak_spooc_ds = 0.075,
			taser_skm = 0.04,
			boom_taser_skm = 0.11,
			common_wave_rush_skm = 0.04
		}
	else --Spooky halloween boss.
		self.captain = "HVH_Boss"
		assault_groups[9] = {
			swats_skm = 0.16,
			heavys_skm = 0.08,
			hostage_rescue_skm = 0.1,
			bomb_squad_skm = 0.1,
			shotguns_skm = 0.1,
			shield_skm = 0.06,
			shield_sniper_skm = 0.11,
			FBI_spoocs = 0.0125,
			cloak_spooc_ds = 0.0375,
			taser_skm = 0.04,
			boom_taser_skm = 0.11,
			common_wave_rush_skm = 0.04,
			GREEN_tanks_skm = 0.02,
			BLACK_tanks_skm = 0.02,
			SKULL_tanks_skm = 0.02,
			Titan_tanks_skm = 0.01
		}
	end


	--Generate assault.groups for each wave.
	self.spawn_group_waves = {{}, {}, {}, {}, {}, {}, {}, {}, {}}
	local i = 0
	for i = 1, #assault_groups do
		local wave_groups = assault_groups[i]
		for group, chance in pairs(wave_groups) do
			self.spawn_group_waves[i][group] = {chance, chance, chance, chance, chance, chance, chance, chance, chance, chance, chance, chance}
		end
	end


	local reenforce_groups = {
		nil
	}
	local recon_groups = {
		nil
	}	
	
	tweak_data.group_ai.skirmish.assault.groups = self.spawn_group_waves[1]
	tweak_data.group_ai.skirmish.reenforce.groups = reenforce_groups
	tweak_data.group_ai.skirmish.recon.groups = recon_groups
end

function SkirmishTweakData:_init_wave_modifiers()
	self.wave_modifiers = {}
	local health_damage_multipliers = {
		{
			damage = 0.5,
			health = 0.5
		},
		{
			damage = 0.75,
			health = 0.625
		},
		{
			damage = 1.0,
			health = 0.75
		},
		{
			damage = 1.0,
			health = 0.875
		},
		{
			damage = 1.0,
			health = 1.0
		}
	}
	self.wave_modifiers[1] = {
		{
			class = "ModifierEnemyHealthAndDamageByWave",
			data = {waves = health_damage_multipliers}
		}
	}
	self.wave_modifiers[2] = {{class = "ModifierNoHurtAnims"}}
	self.wave_modifiers[4] = {
		{
			class = "ModifierHealSpeed",
			data = {speed = 50}
		}
	}
	self.wave_modifiers[6] = {
		{
			class = "ModifierSniperAim",
			data = {speed = 2}
		}
	}
	self.wave_modifiers[8] = {
		{
			class = "ModifierShieldPhalanx",
			data = {}
		}
	}
end

function SkirmishTweakData:_init_weekly_modifiers()
	self.weekly_modifiers = {
		wsm01 = {
			icon = "crime_spree_cloaker_tear_gas",
			class = "ModifierCloakerTearGas",
			data = {
				diameter = 4,
				duration = 5,
				damage = 10
			}
		},
		wsm02 = {
			icon = "crime_spree_dozer_rage",
			class = "ModifierDozerRage",
			data = {damage = 10}
		},
		wsm03 = {
			icon = "crime_spree_medic_speed",
			class = "ModifierHealSpeed",
			data = {speed = 25}
		},
		wsm04 = {
			icon = "crime_spree_medic_rage",
			class = "ModifierMedicRage",
			data = {damage = 5}
		},
		wsm05 = {
			icon = "crime_spree_youre_that_ninja",
			class = "ModifierMedicAdrenaline",
			data = {damage = 100}
		},
		wsm06 = {
			icon = "crime_spree_more_dozers",
			class = "ModifierMoreDozers",
			data = {inc = 2}
		},
		wsm07 = {
			icon = "crime_spree_shield_phalanx",
			class = "ModifierShieldPhalanx",
			data = {}
		},
		wsm08 = {
			icon = "crime_spree_shield_reflect",
			class = "ModifierShieldReflect",
			data = {}
		},
		wsm09 = {
			icon = "crime_spree_ump_me_up",
			class = "ModifierHeavies",
			data = {}
		},
		wsm10 = {
			icon = "crime_spree_no_hurt",
			class = "ModifierNoHurtAnims",
			data = {}
		}
	}
end