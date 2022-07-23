if not tweak_data then 
	return 
end

tweak_data.overlay_effects.level_fade_in = {
			blend_mode = "sub",
			sustain = 1,
			play_paused = true,
			fade_in = 0,
			fade_out = 3,
			color = Color(1, 1, 1, 1),
			timer = TimerManager:game()
}
tweak_data.overlay_effects.fade_out = {
			blend_mode = "sub",
			sustain = 30,
			play_paused = true,
			fade_in = 3,
			fade_out = 0,
			color = Color(1, 1, 1, 1),
			timer = TimerManager:main()
}
tweak_data.overlay_effects.fade_in = {
			blend_mode = "sub",
			sustain = 0,
			play_paused = true,
			fade_in = 0,
			fade_out = 3,
			color = Color(1, 1, 1, 1),
			timer = TimerManager:main()
}
tweak_data.overlay_effects.fade_out_permanent = {
			blend_mode = "sub",
			fade_out = 0,
			play_paused = true,
			fade_in = 1,
			color = Color(1, 1, 1, 1),
			timer = TimerManager:main()
}
tweak_data.overlay_effects.fade_out_in = {
			blend_mode = "sub",
			sustain = 1,
			play_paused = true,
			fade_in = 1,
			fade_out = 1,
			color = Color(1, 1, 1, 1),
			timer = TimerManager:main()
}
tweak_data.overlay_effects.element_fade_in = {
			blend_mode = "sub",
			sustain = 0,
			play_paused = true,
			fade_in = 0,
			fade_out = 3,
			color = Color(1, 1, 1, 1),
			timer = TimerManager:main()
}
tweak_data.overlay_effects.element_fade_out = {
			blend_mode = "sub",
			sustain = 0,
			play_paused = true,
			fade_in = 3,
			fade_out = 0,
			color = Color(1, 1, 1, 1),
			timer = TimerManager:main()
}
--tweak_data.screen_colors.button_stage_2 = Color(255, 1, 240, 255) / 255
--tweak_data.screen_colors.button_stage_3 = Color(127, 1, 190, 255) / 255
tweak_data.screen_colors.button_stage_2 = Color(255, 1, 161, 255) / 255
tweak_data.screen_colors.button_stage_3 = Color(127, 1, 161, 255) / 255

    local orange = Vector3( 221, 88, 44 )/255 -- slot 2
    local green = Vector3( 142, 221, 37 )/255 -- slot 3
    local brown = Vector3( 221, 117, 214 )/255 -- slot 4, actually pink
    local blue = Vector3( 108, 221, 193 )/255 -- slot 1
    local team_ai = Vector3( 0.003, 0.631, 1 ) -- team AI
	
    tweak_data.peer_vector_colors = { blue, orange, green, brown, team_ai }
    tweak_data.peer_colors = { "mrblue", "mrorange", "mrgreen", "mrbrown", "mrai" }    

-- these are used for name labels and the dot beside the player's name on the teammate panel in the vanilla HUD
    tweak_data.chat_colors = {     
    Color(0.423, 0.866, 0.756), -- Blue/Purple/Peer1/Host.
    Color(0.866, 0.345, 0.172), -- Orange/Red/Peer2.
    Color(0.556, 0.866, 0.145), -- Green/Peer3.
    Color(0.866, 0.458, 0.839), -- Brown/Peer4.  PINK ACTUALLY
    Color(0.003, 0.631, 1) -- Team AI.
    }

-- preplanning colors
    tweak_data.preplanning_peer_colors = {
        Color("ff6CDDC1"),
        Color("ffDD582C"),
        Color("ff8EDD25"),
        Color("ffDD75D6")
    }
    
--Swap Speed Multipliers
--TODO: Move to stat_info
tweak_data.pistol = {range_mul = 0.8}
tweak_data.akimbo = {swap_bonus = 0.75, range_mul = 0.8}
tweak_data.smg = {range_mul = 0.8}
tweak_data.lmg = {range_mul = 1.25} --Stacks with smg to give a mul of 1
tweak_data.snp = {range_mul = 1.25}
tweak_data.minigun = {range_mul = 1.5}
tweak_data.shotgun = {range_mul = 0.6}


local function apply_rocket_frag(projectile)
	projectile.damage = 60
	projectile.player_damage = 32
	projectile.range = 500
	projectile.curve_pow = 0.1
	projectile.turret_instakill = true
end
apply_rocket_frag(tweak_data.projectiles.launcher_rocket)
apply_rocket_frag(tweak_data.projectiles.rocket_ray_frag)


local function apply_launcher_grenade(grenade)
	grenade.damage = 40
	grenade.player_damage = 21.5
	grenade.curve_pow = 1
	grenade.range = 500
end
apply_launcher_grenade(tweak_data.projectiles.launcher_frag)
apply_launcher_grenade(tweak_data.projectiles.launcher_frag_m32)
apply_launcher_grenade(tweak_data.projectiles.launcher_m203)
apply_launcher_grenade(tweak_data.projectiles.launcher_frag_china)
apply_launcher_grenade(tweak_data.projectiles.launcher_frag_slap)
apply_launcher_grenade(tweak_data.projectiles.underbarrel_m203_groza)

tweak_data.projectiles.launcher_frag_arbiter.damage = 30
tweak_data.projectiles.launcher_frag_arbiter.player_damage = 16
tweak_data.projectiles.launcher_frag_arbiter.launch_speed = 2500
tweak_data.projectiles.launcher_frag_arbiter.range = 400
tweak_data.projectiles.launcher_frag_arbiter.curve_pow = 1
tweak_data.projectiles.launcher_frag_arbiter.init_timer = nil
tweak_data.projectiles.launcher_frag_osipr = deep_clone(tweak_data.projectiles.launcher_frag_arbiter)


local fire_pool_dot_data = {
	dot_damage = 1.8,
	dot_trigger_max_distance = 3000,
	dot_trigger_chance = 50,
	dot_length = 3.1,
	dot_tick_period = 0.5
}
local arbiter_fire_pool_dot_data = clone(fire_pool_dot_data)
arbiter_fire_pool_dot_data.dot_length = 2.1
local function apply_launcher_indendiary(grenade)
	grenade.damage = 3
	grenade.launch_speed = 1250
	grenade.curve_pow = 1
	grenade.player_damage = 3
	grenade.burn_duration = 5
	grenade.fire_dot_data = fire_pool_dot_data
end
apply_launcher_indendiary(tweak_data.projectiles.launcher_incendiary)
apply_launcher_indendiary(tweak_data.projectiles.launcher_incendiary_m32)
apply_launcher_indendiary(tweak_data.projectiles.launcher_incendiary_china)
apply_launcher_indendiary(tweak_data.projectiles.launcher_incendiary_slap)

tweak_data.projectiles.launcher_incendiary_arbiter.damage = 2
tweak_data.projectiles.launcher_incendiary_arbiter.launch_speed = 2500
tweak_data.projectiles.launcher_incendiary_arbiter.player_damage = 2.5
tweak_data.projectiles.launcher_incendiary_arbiter.burn_duration = 5
tweak_data.projectiles.launcher_incendiary_arbiter.init_timer = nil
tweak_data.projectiles.launcher_incendiary_arbiter.fire_dot_data = arbiter_fire_pool_dot_data
tweak_data.projectiles.launcher_incendiary_osipr = deep_clone(tweak_data.projectiles.launcher_incendiary_arbiter)


--Tactical ZAPper grenades (Grenade Launchers)
local function apply_launcher_electric(grenade)
	grenade.damage = 20
	grenade.player_damage = 0.5
	grenade.curve_pow = 1
	grenade.range = 500
end
apply_launcher_electric(tweak_data.projectiles.launcher_electric)
apply_launcher_electric(tweak_data.projectiles.launcher_electric_m32)
apply_launcher_electric(tweak_data.projectiles.launcher_electric_china)
apply_launcher_electric(tweak_data.projectiles.launcher_electric_slap)
apply_launcher_electric(tweak_data.projectiles.underbarrel_electric)
apply_launcher_electric(tweak_data.projectiles.underbarrel_electric_groza)

tweak_data.projectiles.launcher_electric_arbiter.damage = 15
tweak_data.projectiles.launcher_electric_arbiter.player_damage = 0.4
tweak_data.projectiles.launcher_electric_arbiter.launch_speed = 2500
tweak_data.projectiles.launcher_electric_arbiter.range = 400
tweak_data.projectiles.launcher_electric_arbiter.curve_pow = 1
tweak_data.projectiles.launcher_electric_arbiter.init_timer = nil
tweak_data.projectiles.launcher_electric_osipr = deep_clone(tweak_data.projectiles.launcher_electric_arbiter)


local poison_gas_cloud_dot_data = {
	hurt_animation_chance = 0.5,
	dot_damage = 1.5,
	dot_length = 9.1,
	dot_tick_period = 0.5
}
local arbiter_fire_pool_dot_data = clone(poison_gas_cloud_dot_data)
arbiter_fire_pool_dot_data.dot_length = 6.1
local function apply_laucher_poison(grenade)
	grenade.damage = 20
	grenade.player_damage = 12
	grenade.poison_gas_range = 450
	grenade.poison_gas_duration = 5
	grenade.poison_gas_dot_data = poison_gas_cloud_dot_data
end
apply_laucher_poison(tweak_data.projectiles.launcher_poison)
apply_laucher_poison(tweak_data.projectiles.launcher_poison_gre_m79)
apply_laucher_poison(tweak_data.projectiles.launcher_poison_m32)
apply_laucher_poison(tweak_data.projectiles.launcher_poison_groza)
apply_laucher_poison(tweak_data.projectiles.launcher_poison_china)
apply_laucher_poison(tweak_data.projectiles.launcher_poison_slap)
apply_laucher_poison(tweak_data.projectiles.launcher_poison_contraband)
apply_laucher_poison(tweak_data.projectiles.launcher_poison)

tweak_data.projectiles.launcher_poison_arbiter.damage = 15
tweak_data.projectiles.launcher_poison_arbiter.player_damage = 8
tweak_data.projectiles.launcher_poison_arbiter.poison_gas_range = 600
tweak_data.projectiles.launcher_poison_arbiter.poison_gas_duration = 8
tweak_data.projectiles.launcher_poison_arbiter.poison_gas_dot_data = arbiter_poison_gas_cloud_dot_data


--Plainsrider--
tweak_data.projectiles.west_arrow.damage = 13.5
tweak_data.projectiles.west_arrow_exp.damage = 18
tweak_data.projectiles.bow_poison_arrow.damage = 9
tweak_data.projectiles.west_arrow.launch_speed = 2000
tweak_data.projectiles.west_arrow_exp.launch_speed = 2500
tweak_data.projectiles.bow_poison_arrow.launch_speed = 2500

--Long Arrow--
tweak_data.projectiles.long_arrow.damage = 18
tweak_data.projectiles.long_arrow_exp.damage = 24
tweak_data.projectiles.long_poison_arrow.damage = 12
tweak_data.projectiles.long_arrow.launch_speed = 2500
tweak_data.projectiles.long_arrow_exp.launch_speed = 3125
tweak_data.projectiles.long_poison_arrow.launch_speed = 3125

--The not longbow--
tweak_data.projectiles.elastic_arrow.damage = 18
tweak_data.projectiles.elastic_arrow_exp.damage = 24
tweak_data.projectiles.elastic_arrow_poison.damage = 12
tweak_data.projectiles.elastic_arrow.launch_speed = 2500
tweak_data.projectiles.elastic_arrow_exp.launch_speed = 3125
tweak_data.projectiles.elastic_arrow_poison.launch_speed = 3125	

--Pistol Crossbow--
tweak_data.projectiles.crossbow_arrow.damage = 13.5
tweak_data.projectiles.crossbow_arrow_exp.damage = 18
tweak_data.projectiles.crossbow_poison_arrow.damage = 9
tweak_data.projectiles.crossbow_arrow.launch_speed = 3125
tweak_data.projectiles.crossbow_arrow_exp.launch_speed = 2500
tweak_data.projectiles.crossbow_poison_arrow.launch_speed = 3125

--Arblast Heavy Crossbow--
tweak_data.projectiles.arblast_arrow.damage = 18
tweak_data.projectiles.arblast_arrow_exp.damage = 24
tweak_data.projectiles.arblast_poison_arrow.damage = 12
tweak_data.projectiles.arblast_arrow.launch_speed = 4375
tweak_data.projectiles.arblast_arrow_exp.launch_speed = 3500
tweak_data.projectiles.arblast_poison_arrow.launch_speed = 4375

--Light Crossbow Arrow--
tweak_data.projectiles.frankish_arrow.damage = 13.5
tweak_data.projectiles.frankish_arrow_exp.damage = 18
tweak_data.projectiles.frankish_poison_arrow.damage = 9
tweak_data.projectiles.frankish_poison_arrow.launch_speed = 3750
tweak_data.projectiles.frankish_arrow_exp.launch_speed = 3000
tweak_data.projectiles.frankish_arrow.launch_speed = 3750

--Airbow--
tweak_data.projectiles.ecp_arrow.damage = 13.5
tweak_data.projectiles.ecp_arrow_exp.damage = 18
tweak_data.projectiles.ecp_arrow_poison.damage = 9
tweak_data.projectiles.ecp_arrow_poison.launch_speed = 3125
tweak_data.projectiles.ecp_arrow_exp.launch_speed = 2500
tweak_data.projectiles.ecp_arrow.launch_speed = 3125

--Frag Grenade--
tweak_data.projectiles.frag.damage = 40
tweak_data.projectiles.frag.player_damage = 21.5
tweak_data.projectiles.frag.curve_pow = 0.5
tweak_data.projectiles.frag.range = 500

--Viper Poison Gas Grenade
tweak_data.projectiles.poison_gas_grenade.damage = 20
tweak_data.projectiles.poison_gas_grenade.poison_gas_range = 600
tweak_data.projectiles.poison_gas_grenade.poison_gas_duration = 10
tweak_data.projectiles.poison_gas_grenade.poison_gas_dot_data = poison_gas_cloud_dot_data

--Dynamite--
tweak_data.projectiles.dynamite.damage = 40
tweak_data.projectiles.dynamite.player_damage = 21.5
tweak_data.projectiles.dynamite.curve_pow = 0.5
tweak_data.projectiles.dynamite.range = 400

--Community Frag--
tweak_data.projectiles.frag_com.damage = 40
tweak_data.projectiles.frag_com.player_damage = 21.5
tweak_data.projectiles.frag_com.curve_pow = 0.5
tweak_data.projectiles.frag_com.range = 500

--The other community frag--
tweak_data.projectiles.dada_com.damage = 40
tweak_data.projectiles.dada_com.player_damage = 21.5
tweak_data.projectiles.dada_com.curve_pow = 0.5
tweak_data.projectiles.dada_com.range = 500

--Molliest of tovs--
tweak_data.projectiles.molotov.damage = 3
tweak_data.projectiles.molotov.player_damage = 3
tweak_data.projectiles.molotov.burn_duration = 10
tweak_data.projectiles.molotov.fire_dot_data = fire_pool_dot_data

--Incendiary Nades--
tweak_data.projectiles.fir_com.damage = 3
tweak_data.projectiles.fir_com.player_damage = 3
tweak_data.projectiles.fir_com.fire_dot_data = fire_pool_dot_data
tweak_data.projectiles.fir_com.range = 75
tweak_data.blackmarket.projectiles.fir_com.impact_detonation = false

--Throwing Card--
tweak_data.projectiles.wpn_prj_ace.damage = 12
tweak_data.projectiles.wpn_prj_ace.adjust_z = 0

--Shuriken
tweak_data.projectiles.wpn_prj_four.damage = 9
tweak_data.projectiles.wpn_prj_four.dot_data = {
	type = "poison",
	dot_damage = 1.5,
	dot_duration = 3.1,
	hurt_animation_chance = 0.5
}

--Throwing Knife--
tweak_data.projectiles.wpn_prj_target.damage = 12
tweak_data.projectiles.wpn_prj_target.adjust_z = 0
tweak_data.projectiles.wpn_prj_target.launch_speed = 2000

--Javelin--
tweak_data.projectiles.wpn_prj_jav.damage = 18
tweak_data.projectiles.wpn_prj_jav.launch_speed = 1500
tweak_data.projectiles.wpn_prj_jav.adjust_z = 30

--Throwing axe--
tweak_data.projectiles.wpn_prj_hur.damage = 18
tweak_data.projectiles.wpn_prj_hur.launch_speed = 1000
tweak_data.projectiles.wpn_prj_hur.adjust_z = 120

--ZAPper grenade
tweak_data.projectiles.wpn_gre_electric.damage = 20
tweak_data.projectiles.wpn_gre_electric.player_damage = 0.5
tweak_data.projectiles.wpn_gre_electric.curve_pow = 0.5
tweak_data.projectiles.wpn_gre_electric.range = 500

tweak_data.dot_types.poison = {
	damage_class = "PoisonBulletBase",
	dot_length = 3.1,
	dot_damage = 1.5,
	hurt_animation_chance = 0.5
}

tweak_data.dot_types.bleed = {
	damage_class = "BleedBulletBase",
	dot_length = 3.1,
	dot_damage = 1.8,
	hurt_animation_chance = 0
}

--Stun nades--
tweak_data.projectiles.concussion.damage = 0
tweak_data.projectiles.concussion.curve_pow = 0.8
tweak_data.projectiles.concussion.range = 1000
tweak_data.projectiles.concussion.duration = {min = 7.5, additional = 0}

--Had to include this in here due to some BS with it being in upgradestweakdata
tweak_data.upgrades.values.player.health_multiplier = {1.15, 1.4}
tweak_data.upgrades.values.trip_mine.quantity = {3, 7}
tweak_data.upgrades.values.shape_charge.quantity = {3, 5}

tweak_data.interaction.drill_upgrade.timer = 2
tweak_data.interaction.gen_int_saw_upgrade.timer = 2

--Grenadier gas grenade. Existed before, and not to be confused with the official gas grenades.
tweak_data.projectiles.gas_grenade = {
	radius = 300,
	radius_blurzone_multiplier = 1.3,
	damage_tick_period = 0.4 / 3,
	damage_per_tick = 0.6,
	no_stamina_damage_mul = 2,
	stamina_per_tick = 2,
	duration = 7.5,
	timer = 1.5
}

local difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
local difficulty_index = tweak_data:difficulty_to_index(difficulty)
local enemy_grenade_damage_mul = 1
if difficulty_index == 8 then
	tweak_data.interaction.corpse_alarm_pager.timer = 15
	tweak_data.projectiles.gas_grenade.damage_tick_period = 0.4 / 3
	tweak_data.projectiles.gas_grenade.damage_per_tick = 0.6
elseif difficulty_index == 7 then
	tweak_data.interaction.corpse_alarm_pager.timer = 12.5
	tweak_data.projectiles.gas_grenade.damage_tick_period = 0.4 / 2
	tweak_data.projectiles.gas_grenade.damage_per_tick = 0.6
elseif difficulty_index == 6 then
	tweak_data.interaction.corpse_alarm_pager.timer = 10
	tweak_data.projectiles.gas_grenade.damage_tick_period = 0.5 / 2
	tweak_data.projectiles.gas_grenade.damage_per_tick = 0.6
elseif difficulty_index == 5 then
	tweak_data.interaction.corpse_alarm_pager.timer = 10
	tweak_data.projectiles.gas_grenade.damage_tick_period = 0.55 / 2
	tweak_data.projectiles.gas_grenade.damage_per_tick = 0.5
	enemy_grenade_damage_mul = 0.9
elseif difficulty_index == 4 then
	tweak_data.interaction.corpse_alarm_pager.timer = 10
	tweak_data.projectiles.gas_grenade.damage_tick_period = 0.55 / 2
	tweak_data.projectiles.gas_grenade.damage_per_tick = 0.4
	enemy_grenade_damage_mul = 0.7
elseif difficulty_index == 3 then
	tweak_data.interaction.corpse_alarm_pager.timer = 10
	tweak_data.projectiles.gas_grenade.damage_tick_period = 0.6 / 2
	tweak_data.projectiles.gas_grenade.damage_per_tick = 0.3
	enemy_grenade_damage_mul = 0.5
elseif difficulty_index <= 2 then
	tweak_data.interaction.corpse_alarm_pager.timer = 10
	tweak_data.projectiles.gas_grenade.damage_tick_period = 0.6 / 2
	tweak_data.projectiles.gas_grenade.damage_per_tick = 0.2
	enemy_grenade_damage_mul = 0.3
end	

tweak_data.narrative.jobs["chill_combat"].contact = "events"	
tweak_data.narrative.jobs.chill_combat.contract_visuals = {}	
tweak_data.narrative.jobs.chill_combat.contract_visuals.preview_image = {
	id = "chill_combat"
}	

--Smoke Grenades--
tweak_data.projectiles.smoke_screen_grenade.damage = 0
tweak_data.projectiles.smoke_screen_grenade.curve_pow = 1
tweak_data.projectiles.smoke_screen_grenade.range = 1500
tweak_data.projectiles.smoke_screen_grenade.name_id = "bm_smoke_screen_grenade"
tweak_data.projectiles.smoke_screen_grenade.duration = 12
tweak_data.projectiles.smoke_screen_grenade.dodge_chance = 0.1
tweak_data.projectiles.smoke_screen_grenade.init_timer = 0
tweak_data.projectiles.smoke_screen_grenade.accuracy_roll_chance = 0.8
tweak_data.projectiles.smoke_screen_grenade.accuracy_fail_spread = {5, 10}

--Bravo grenades.
tweak_data.projectiles.bravo_frag = {
	name_id = "bm_bravo_frag",
	damage = 21.5 * enemy_grenade_damage_mul, --215 damage at point blank.
	player_damage = 21.5 * enemy_grenade_damage_mul,
	curve_pow = 0.1,
	range = 500
}

--Spring Cluster Grenades.
tweak_data.projectiles.cluster_fuck = {
	name_id = "bm_cluster_fuck",
	damage = 21.5 * enemy_grenade_damage_mul, --215 damage at point blank.
	player_damage = 21.5 * enemy_grenade_damage_mul,
	curve_pow = 0.1,
	range = 500,
	cluster = "child_grenade",
	cluster_count = 3
}

tweak_data.projectiles.child_grenade = {
	name_id = "bm_child_grenade",
	init_timer = 1,
	damage = 10.0 * enemy_grenade_damage_mul, --100 damage at point blank.
	player_damage = 10.0 * enemy_grenade_damage_mul,
	curve_pow = 0.1,
	range = 500,
	launch_speed = 100
}

--Hatman Molotov
tweak_data.projectiles.hatman_molotov = {}
tweak_data.projectiles.hatman_molotov.env_effect = "hatman_molotov_fire"

--Genuinely why--
--Killed for now--
--tweak_data.team_ai.stop_action.delay = 0.8
--tweak_data.team_ai.stop_action.distance = 9999999999999999999999999999999999

tweak_data.medic.cooldown = 1
tweak_data.medic.radius = 550

if difficulty_index <= 4 then
	tweak_data.medic.doc_radius = 1500
elseif difficulty_index == 5 then
	tweak_data.medic.doc_radius = 2500
elseif difficulty_index == 6 then
	tweak_data.medic.doc_radius = 5000
else
	tweak_data.medic.doc_radius = 9999999
end			

tweak_data.medic.disabled_units = {
	"phalanx_vip",
	"spring",
	"headless_hatman",
	"taser_summers",
	"boom_summers",
	"medic_summers",
	"summers",
	"autumn",
	"medic",
	"sniper",
	"tank_medic"
}
tweak_data.medic.cooldown_summers = 0
tweak_data.radius_summers = 100000
tweak_data.medic.whitelisted_units = {
	"summers"
}
tweak_data.medic.whitelisted_units_summer_squad = {
	"summers"
}
tweak_data.achievement.complete_heist_achievements.pain_train.num_players = nil
tweak_data.achievement.complete_heist_achievements.anticimex.num_players = nil
tweak_data.achievement.complete_heist_achievements.ovk_8.num_players = nil
tweak_data.achievement.complete_heist_achievements.steel_1.num_players = nil
tweak_data.achievement.complete_heist_achievements.green_2.num_players = nil
tweak_data.achievement.complete_heist_achievements.trophy_flawless.num_players = nil
tweak_data.achievement.complete_heist_achievements.trophy_friendly_car.num_players = nil
tweak_data.achievement.complete_heist_achievements.ovk_8.num_players = nil
tweak_data.achievement.complete_heist_statistics_achievements.immortal_ballot.num_players = nil
tweak_data.achievement.complete_heist_statistics_achievements.full_two_twenty.num_players = nil

tweak_data.casino = {
	unlock_level = 0,
	entrance_level = {
		14,
		28,
		40,
		45,
		55,
		65,
		75
	},
	entrance_fee = {
		15000,
		15000,
		15000,
		15000,
		15000,
		15000,
		15000
	},
	prefer_cost = 5000,
	prefer_chance = 0.1,
	secure_card_cost = {
		10000,
		20000,
		30000
	},
	secure_card_level = {
		0,
		0,
		0
	},
	infamous_cost = 100000,
	infamous_chance = 3
}	

tweak_data.experience_manager.stage_failed_multiplier = 0.5
-- From update 34
tweak_data.experience_manager.stage_completion = {
	200,
	250,
	300,
	350,
	425,
	475,
	550
}
tweak_data.experience_manager.job_completion = {
	2000,
	4000,
	10000,
	16000,
	20000,
	28000,
	32000
}

tweak_data.experience_manager.pro_day_multiplier = {
	1,
	1,
	1,
	1,
	1,
	1,
	1
}

if Global.game_settings and Global.game_settings.one_down then
	tweak_data.experience_manager.pro_job_new = 1.2
end

	tweak_data.gui.buy_weapon_categories = {
		primaries = {
			{"assault_rifle"},
			{"snp"},
			{"shotgun"},
			{"smg"},
			{"lmg"},
			{"pistol"},
			{"wpn_special"}
		},
		secondaries = {
			{"assault_rifle"},
			{"snp"},
			{"shotgun"},
			{"smg"},
			{"pistol"},
			{"wpn_special"}
		}
	}

--Sounds of Animals Fighting--
local animal_fight = {
		award = "pig_5",
		jobs = {"mia"},
		num_players = nil,
		difficulties = hard_and_above,
		equipped_team = {
			masks = {
				"white_wolf",
				"owl",
				"rabbit",
				"pig"
			}
		}
}
table.insert(tweak_data.achievement.complete_heist_achievements, animal_fight)

--Four Monkeys--
local go_bananas = {
	award = "gage4_12",
	job = {"alex"},
	num_players = nil,
	difficulties = overkill_and_above,
	equipped_team = {
		masks = {
			"silverback",
			"mandril",
			"skullmonkey",
			"orangutang"
		}
	}
}
table.insert(tweak_data.achievement.complete_heist_achievements, go_bananas)

--Riders on the snowstorm--
local xmas_2014 = {
	award = "deer_6",
	jobs = {"pines"},
	num_players = nil,
	difficulties = deathwish_and_above,
	equipped_team = {
		masks = {
			"krampus",
			"mrs_claus",
			"strinch",
			"robo_santa"
		}
	}
}
table.insert(tweak_data.achievement.complete_heist_achievements, xmas_2014)

--Reindeer Games--
local reindeer_games = {
	award = "charliesierra_9",
	num_players = nil,
	equipped_team = {
		masks = {
			"santa_happy",
			"santa_mad",
			"santa_drunk",
			"santa_surprise"
		}
	}
}
table.insert(tweak_data.achievement.complete_heist_achievements, reindeer_games)

--Ghost Riders--
local ghost_riders = {
	award = "bob_10",
	num_players = nil,
	equipped_team = {
		masks = {
			"skullhard",
			"skullveryhard",
			"skulloverkill",
			"skulloverkillplus",
			"gitgud_e_wish",
			"gitgud_sm_wish"
		}
	}
}
table.insert(tweak_data.achievement.complete_heist_achievements, ghost_riders)

--Funding Father--
local funding_father = {
	award = "bigbank_10",
	num_players = nil,
	equipped_team = {
		masks = {
			"franklin",
			"lincoln",
			"grant",
			"washington"
		}
	}
}
table.insert(tweak_data.achievement.complete_heist_achievements, funding_father)

--Unusual Suspects--
local guy_with_gun_now_with_night_jobs = {
	award = "gage5_6",
	num_players = nil,
	jobs = {
		"watchdogs_wrapper",
		"watchdogs",
		"watchdogs_night"
	},
	difficulties = overkill_and_above,
	equipped_team = {
		masks = {
			"galax",
			"crowgoblin",
			"evil",
			"volt"
		}
	}
}
table.insert(tweak_data.achievement.complete_heist_achievements, guy_with_gun_now_with_night_jobs)

--Wind of change--
local wind_of_change = {
	award = "eagle_3",
	num_players = nil,
	jobs = {"hox"},
	difficulties = overkill_and_above,
	equipped_team = {
		masks = {
			"churchill",
			"red_hurricane",
			"patton",
			"de_gaulle"
		}
	}
}
table.insert(tweak_data.achievement.complete_heist_achievements, wind_of_change)

--Honor Among Thieves--
local blight = {
	award = "bat_5",
	jobs = {"mus"},
	difficulties = overkill_and_above,
	equipped_team = {
		masks = {
			"medusa",
			"anubis",
			"pazuzu",
			"cursed_crown"
		}
	}
}
table.insert(tweak_data.achievement.complete_heist_achievements, blight)