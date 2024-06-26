local old_projectiles = BlackMarketTweakData._init_projectiles
function BlackMarketTweakData:_init_projectiles(tweak_data)
   	old_projectiles(self, tweak_data)	
	--[[
	self.projectiles.fir_com = {
		name_id = "bm_grenade_fir_com",
		desc_id = "bm_grenade_fir_com_desc",
		unit = "units/pd2_dlc_fir/weapons/wpn_fps_gre_white/wpn_third_gre_white",
		unit_dummy = "units/pd2_dlc_fir/weapons/wpn_fps_gre_white/wpn_fps_gre_white_husk",
		icon = "fir_grenade",
		dlc = "pd2_clan",
		no_cheat_count = true,
		impact_detonation = true,
		time_cheat = 1,
		throwable = true,
		max_amount = 3,
		texture_bundle_folder = "fir",
		physic_effect = Idstring("physic_effects/molotov_throw"),
		animation = "throw_concussion",
		anim_global_param = "projectile_frag",
		throw_allowed_expire_t = 0.1,
		expire_t = 1.3,
		repeat_expire_t = 1.5,
		is_a_grenade = true
	}
	]]--

	table.insert(self._projectiles_index, "bravo_frag")
	table.insert(self._projectiles_index, "cluster_fuck")
	table.insert(self._projectiles_index, "child_grenade")
	table.insert(self._projectiles_index, "hatman_molotov")
	table.insert(self._projectiles_index, "launcher_frag_osipr")
	table.insert(self._projectiles_index, "launcher_incendiary_osipr")
	table.insert(self._projectiles_index, "launcher_electric_osipr")	
	table.insert(self._projectiles_index, "gas_grenade")

	--Throwables--
	self.projectiles.wpn_prj_four.max_amount = 10
	self.projectiles.wpn_prj_four.repeat_expire_t = 0.5
	self.projectiles.wpn_prj_ace.max_amount = 14
	self.projectiles.wpn_prj_ace.repeat_expire_t = 0.5
	self.projectiles.wpn_prj_target.repeat_expire_t = 0.5
	self.projectiles.wpn_prj_target.throw_allowed_expire_t = 0.15
	self.projectiles.wpn_prj_target.max_amount = 10
	self.projectiles.wpn_prj_jav.max_amount = 8
	self.projectiles.wpn_prj_hur.max_amount = 6
	self.projectiles.fir_com.max_amount = 3
	self.projectiles.smoke_screen_grenade.base_cooldown = 40
	self.projectiles.damage_control.base_cooldown = 30
	self.projectiles.tag_team.base_cooldown = 80
	self.projectiles.concussion.max_amount = 5
	self.projectiles.wpn_gre_electric.max_amount = 3
	self.projectiles.poison_gas_grenade.max_amount = 3
	
	self.projectiles.pocket_ecm_jammer.max_amount = 1
	self.projectiles.pocket_ecm_jammer.base_cooldown = 80
	
	--Cheat detection prevention
	for k, v in pairs(self.projectiles) do
		self.projectiles[k].no_cheat_count = true
	end

	--Animation overrides for grenades so they aren't shitty. Like seriously, Javelin throw for grenades..?	
	--HE
	self.projectiles.frag.animation = "throw_grenade_com"							--throw_grenade (Comments are original lines for ref sake)
	self.projectiles.frag.anim_global_param = "projectile_frag_com"					--projectile_frag
	--HEF OVK
	--self.projectiles.frag_com.animation = "throw_grenade_com"						--throw_grenade_com
	--self.projectiles.frag_com.anim_global_param = "projectile_frag_com"			--projectile_frag_com
	--Matyroshka
	--self.projectiles.dada_com.animation = "throw_dada"							--throw_dada
	--self.projectiles.dada_com.anim_global_param = "projectile_dada"				--projectile_dada 
	--Dynamite
	--self.projectiles.dynamite.animation = "throw_dynamite"						--throw_dynamite
	--self.projectiles.dynamite.anim_global_param = "projectile_dynamite"			--projectile_dynamite
	--Molotov
	self.projectiles.molotov.animation = "throw_dynamite"							--throw_molotov
	self.projectiles.molotov.anim_global_param = "projectile_dynamite"				--projectile_molotov
	--Incendiary  
	self.projectiles.fir_com.animation = "throw_grenade_com"						--throw_concussion
	self.projectiles.fir_com.anim_global_param = "projectile_frag_com"				--projectile_frag  
	--Concussion  
	self.projectiles.concussion.animation = "throw_grenade_com"						--throw_concussion
	self.projectiles.concussion.anim_global_param = "projectile_frag_com"			--projectile_frag   
	--Sicaro Smoke 
	--self.projectiles.smoke_screen_grenade.animation = "throw_grenade_com"					--throw_grenade_com
	--self.projectiles.smoke_screen_grenade.anim_global_param = "projectile_frag_com"		--projectile_frag_com	

	self.projectiles.gas_grenade = {
		name_id = "gas_grenade",
		unit = "units/weapons/gas_grenade/gas_grenade",
		unit_dummy = "units/weapons/gas_grenade/gas_grenade_husk",
		throwable = false,
		is_a_grenade = true,
		add_trail_effect = true,
	}

	self.projectiles.bravo_frag = {}
	self.projectiles.bravo_frag.name_id = "bm_bravo_frag"
	self.projectiles.bravo_frag.unit = "units/payday2/weapons/wpn_npc_bravo_frag/wpn_npc_bravo_frag"
	self.projectiles.bravo_frag.unit_dummy = "units/payday2/weapons/wpn_npc_bravo_frag/wpn_npc_bravo_frag_husk"
	self.projectiles.bravo_frag.throwable = false
	self.projectiles.bravo_frag.is_a_grenade = true
	self.projectiles.bravo_frag.is_explosive = true
	self.projectiles.bravo_frag.add_trail_effect = true

	self.projectiles.cluster_fuck = {}
	self.projectiles.cluster_fuck.name_id = "bm_cluster_fuck"
	self.projectiles.cluster_fuck.unit = "units/payday2/weapons/wpn_npc_cluster_fuck/wpn_npc_cluster_fuck"
	self.projectiles.cluster_fuck.unit_dummy = "units/payday2/weapons/wpn_npc_cluster_fuck/wpn_npc_cluster_fuck_husk"
	self.projectiles.cluster_fuck.throwable = false
	self.projectiles.cluster_fuck.is_a_grenade = true
	self.projectiles.cluster_fuck.is_explosive = true
	self.projectiles.cluster_fuck.add_trail_effect = true

	self.projectiles.child_grenade = {}
	self.projectiles.child_grenade.init_timer = 1.0
	self.projectiles.child_grenade.name_id = "bm_child_grenade"
	self.projectiles.child_grenade.unit = "units/payday2/weapons/wpn_npc_child_grenade/wpn_npc_child_grenade"
	self.projectiles.child_grenade.unit_dummy = "units/payday2/weapons/wpn_npc_child_grenade/wpn_npc_child_grenade"
	self.projectiles.child_grenade.throwable = false
	self.projectiles.child_grenade.is_a_grenade = true
	self.projectiles.child_grenade.is_explosive = true
	self.projectiles.child_grenade.add_trail_effect = true
	
	self.projectiles.hatman_molotov = {}
	self.projectiles.hatman_molotov.unit = "units/pd2_mod_halloween/weapons/wpn_npc_hatman_molotov/wpn_npc_hatman_molotov"
	self.projectiles.hatman_molotov.unit_dummy = "units/pd2_dlc_bbq/weapons/molotov_cocktail/wpn_molotov_husk"
	self.projectiles.hatman_molotov.physic_effect = Idstring("physic_effects/molotov_throw")
	self.projectiles.hatman_molotov.throwable = false
	self.projectiles.hatman_molotov.is_a_grenade = true
	self.projectiles.hatman_molotov.add_trail_effect = true
	self.projectiles.hatman_molotov.impact_detonation = true

	--SABR Grenade Launcher.
	self.projectiles.launcher_frag_osipr = {
		name_id = "bm_launcher_frag",
		unit = "units/mods/weapons/wpn_osipr_frag_grenade/wpn_osipr_frag_grenade",
		weapon_id = "osipr_gl",
		no_cheat_count = true,
		impact_detonation = true,
		is_explosive = true,
		time_cheat = 0,
		adjust_z = 0
	}
	self.projectiles.launcher_incendiary_osipr = {
		name_id = "bm_launcher_incendiary",
		unit = "units/mods/weapons/wpn_osipr_frag_incendiary_grenade/wpn_osipr_frag_incendiary_grenade",
		weapon_id = "osipr_gl",
		no_cheat_count = true,
		impact_detonation = true,
		time_cheat = 0,
		adjust_z = 0
	}

	self.projectiles.launcher_electric_osipr = {
		name_id = "bm_launcher_electric",
		unit = "units/mods/weapons/wpn_osipr_frag_electric_grenade/wpn_osipr_frag_electric_grenade",
		weapon_id = "osipr_gl",
		no_cheat_count = true,
		impact_detonation = true,
		time_cheat = 0,
		adjust_z = 0
	}

	self.projectiles.launcher_frag_m32.time_cheat = 0.7
	self.projectiles.launcher_incendiary_m32.time_cheat = 0.7
end

local old_weapon_skins = BlackMarketTweakData._init_weapon_skins
function BlackMarketTweakData:_init_weapon_skins(tweak_data)
	old_weapon_skins(self, tweak_data)
	for weapon, data in pairs(self.weapon_skins) do
		self.weapon_skins[weapon].locked = nil
	end
	self.weapon_skins.ak74_rodina.desc_id = "bm_wskn_ak74_rodina_desc_sc"
	self.weapon_skins.ak74_rodina.default_blueprint = {
		"wpn_fps_ass_74_body_upperreceiver",
		"wpn_fps_ass_ak_body_lowerreceiver",
		"wpn_fps_ass_74_b_standard",
		"wpn_fps_upg_ak_m_uspalm",
		"wpn_upg_ak_s_skfoldable_vanilla",
		"wpn_upg_ak_fg_standard",
		"wpn_fps_upg_o_cmore",
		"wpn_fps_upg_o_ak_scopemount",
		"wpn_fps_upg_vlad_rodina_legend"
	}
	self.weapon_skins.deagle_bling.desc_id = "bm_wskn_deagle_bling_desc_sc"
	self.weapon_skins.deagle_bling.default_blueprint = {
		"wpn_fps_pis_deagle_body_standard",
		"wpn_fps_pis_deagle_m_standard",
		"wpn_fps_pis_deagle_b_standard",
		"wpn_fps_pis_deagle_g_ergo",
		"wpn_fps_upg_o_rmr",
		"wpn_fps_upg_midas_touch_legend"
	}
	self.weapon_skins.deagle_bling.default_blueprint = {
		"wpn_fps_pis_deagle_body_standard",
		"wpn_fps_pis_deagle_m_standard",
		"wpn_fps_pis_deagle_b_standard",
		"wpn_fps_pis_deagle_g_ergo",
		"wpn_fps_upg_o_rmr",
		"wpn_fps_upg_midas_touch_legend"
	}
	self.weapon_skins.flamethrower_mk2_fire.parts = {
		wpn_fps_fla_mk2_body_fierybeast = {
			[Idstring("body"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/cop/sticker/dragons_df"),
				uv_offset_rot = Vector3(0.101598, 0.998331, 0),
				pattern_gradient = Idstring("units/payday2_cash/safes/cop/pattern_gradient/gradient_cop_overkill_logo_df"),
				uv_scale = Vector3(2.78944, 2.78944, 0.401383),
				base_gradient = Idstring("units/payday2_cash/safes/cf15/base_gradient/base_cf15_003_df"),
				pattern_tweak = Vector3(10.2218, 4.66481, 1)
			},
			[Idstring("mtr_head"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/cf15/base_gradient/base_cf15_004_df")
			}
		},
		wpn_fps_fla_mk2_body = {
			[Idstring("body"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/cop/sticker/dragons_df"),
				uv_offset_rot = Vector3(0.101598, 0.998331, 0),
				pattern_gradient = Idstring("units/payday2_cash/safes/cop/pattern_gradient/gradient_cop_overkill_logo_df"),
				uv_scale = Vector3(2.78944, 2.78944, 0.401383),
				base_gradient = Idstring("units/payday2_cash/safes/cf15/base_gradient/base_cf15_003_df"),
				pattern_tweak = Vector3(10.2218, 4.66481, 1)
			},
			[Idstring("mtr_head"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/cf15/base_gradient/base_cf15_004_df")
			}
		},
		wpn_fps_fla_mk2_mag = {
			[Idstring("flame_fuel_can"):key()] = {
				cubemap_pattern_control = Vector3(0.1772, 0.444312, 0),
				pattern = Idstring("units/payday2_cash/safes/cop/pattern/pattern_dragon_scales_df")
			}
		},
		wpn_fps_fla_mk2_mag_rare = {
			[Idstring("flame_fuel_can"):key()] = {
				cubemap_pattern_control = Vector3(0.1772, 0.444312, 0),
				pattern = Idstring("units/payday2_cash/safes/cop/pattern/pattern_dragon_scales_df")
			}
		},
		wpn_fps_fla_mk2_mag_welldone = {
			[Idstring("flame_fuel_can"):key()] = {
				cubemap_pattern_control = Vector3(0.1772, 0.444312, 0),
				pattern = Idstring("units/payday2_cash/safes/cop/pattern/pattern_dragon_scales_df")
			}
		}
	}
	self.weapon_skins.flamethrower_mk2_fire.default_blueprint = {
		"wpn_fps_fla_mk2_empty",
		"wpn_fps_fla_mk2_body",
		"wpn_fps_fla_mk2_mag",
		"wpn_fps_upg_dragon_lord_legend"
	}
	self.weapon_skins.rpg7_boom.parts = {
		wpn_fps_rpg7_m_rocket = {
			[Idstring("mtr_rocket"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/cop/base_gradient/base_cop_006_df")
			},
			[Idstring("mtr_custom_rocket"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/cf15/base_gradient/base_cf15_005_df")
			}
		},
		wpn_fps_upg_o_rx30 = {
			[Idstring("rx30"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/cf15/base_gradient/base_cf15_004_df")
			}
		},
		wpn_fps_rpg7_m_grinclown = {
			[Idstring("mtr_rocket"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/cop/base_gradient/base_cop_006_df")
			},
			[Idstring("mtr_custom_rocket"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/cf15/base_gradient/base_cf15_005_df")
			}
		},
		wpn_fps_rpg7_sight = {
			[Idstring("mtr_sights"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/cf15/base_gradient/base_cf15_004_df")
			}
		},
		wpn_fps_rpg7_body = {
			[Idstring("mtr_body"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/cop/sticker/golden_df"),
				pattern = Idstring("units/payday2_cash/safes/cop/pattern/pattern_dollar_bling_df"),
				cubemap_pattern_control = Vector3(0.484856, 0.0555689, 0),
				base_gradient = Idstring("units/payday2_cash/safes/shared/base_gradient/base_shared_007_df"),
				uv_offset_rot = Vector3(0.312392, 0.964172, 0),
				uv_scale = Vector3(2.21734, 4.02898, 0),
				pattern_tweak = Vector3(11.1281, 0.169331, 0.780587),
				pattern_gradient = Idstring("units/payday2_cash/safes/cop/pattern_gradient/gradient_cop_prisonsuit_df")
			}
		}
	}
	self.weapon_skins.rpg7_boom.default_blueprint = {
		"wpn_fps_rpg7_body",
		"wpn_fps_rpg7_m_rocket",
		"wpn_fps_rpg7_barrel",
		"wpn_fps_upg_o_rx30",
		"wpn_fps_upg_green_grin_legend"
	}
	self.weapon_skins.m134_bulletstorm.parts = {
		wpn_fps_lmg_m134_body_upper_spikey = {
			[Idstring("mtr_spikey"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/cop/base_gradient/base_cop_spikey_df")
			},
			[Idstring("mtr_handle"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/cop/sticker/sticker_overkill_df"),
				uv_offset_rot = Vector3(0.403869, 1.06965, 4.72475),
				base_gradient = Idstring("units/payday2_cash/safes/cop/base_gradient/base_cop_008_df"),
				uv_scale = Vector3(11.7046, 11.5616, 1),
				pattern = Idstring("units/payday2_cash/safes/cop/pattern/pattern_flames_df"),
				pattern_tweak = Vector3(4.35488, 1.7877, 1)
			}
		},
		wpn_fps_lmg_m134_body_upper_light = {
			[Idstring("mtr_spikey"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/cop/base_gradient/base_cop_spikey_df")
			},
			[Idstring("mtr_handle"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/cop/sticker/sticker_overkill_df"),
				uv_offset_rot = Vector3(0.403869, 1.06965, 4.72475),
				base_gradient = Idstring("units/payday2_cash/safes/cop/base_gradient/base_cop_008_df"),
				uv_scale = Vector3(11.7046, 11.5616, 1),
				pattern = Idstring("units/payday2_cash/safes/cop/pattern/pattern_flames_df"),
				pattern_tweak = Vector3(4.35488, 1.7877, 1)
			}
		},
		wpn_fps_lmg_m134_body_upper = {
			[Idstring("mtr_spikey"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/cop/base_gradient/base_cop_spikey_df")
			},
			[Idstring("mtr_handle"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/cop/sticker/sticker_overkill_df"),
				uv_offset_rot = Vector3(0.403869, 1.06965, 4.72475),
				base_gradient = Idstring("units/payday2_cash/safes/cop/base_gradient/base_cop_008_df"),
				uv_scale = Vector3(11.7046, 11.5616, 1),
				pattern = Idstring("units/payday2_cash/safes/cop/pattern/pattern_flames_df"),
				pattern_tweak = Vector3(4.35488, 1.7877, 1)
			}
		},
		wpn_fps_lmg_m134_barrel_legendary = {
			[Idstring("mtr_spikey"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/cop/base_gradient/base_cop_spikey_df")
			},
			[Idstring("mtr_barrel"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/cop/sticker/sticker_bdsm_df"),
				uv_offset_rot = Vector3(-0.30007, 1.43362, 3.12136),
				pattern_pos = Vector3(0, 0.00620103, 0),
				uv_scale = Vector3(6.98481, 6.98481, 1),
				pattern_tweak = Vector3(16.4703, 0, 1)
			}
		},
		wpn_fps_lmg_m134_barrel = {
			[Idstring("mtr_spikey"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/cop/base_gradient/base_cop_spikey_df")
			},
			[Idstring("mtr_barrel"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/cop/sticker/sticker_bdsm_df"),
				uv_offset_rot = Vector3(-0.30007, 1.43362, 3.12136),
				pattern_pos = Vector3(0, 0.00620103, 0),
				uv_scale = Vector3(6.98481, 6.98481, 1),
				pattern_tweak = Vector3(16.4703, 0, 1)
			}
		},
		wpn_fps_lmg_m134_barrel_extreme = {
			[Idstring("mtr_spikey"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/cop/base_gradient/base_cop_spikey_df")
			},
			[Idstring("mtr_barrel"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/cop/sticker/sticker_bdsm_df"),
				uv_offset_rot = Vector3(-0.30007, 1.43362, 3.12136),
				pattern_pos = Vector3(0, 0.00620103, 0),
				uv_scale = Vector3(6.98481, 6.98481, 1),
				pattern_tweak = Vector3(16.4703, 0, 1)
			}
		},
		wpn_fps_lmg_m134_barrel_short = {
			[Idstring("mtr_spikey"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/cop/base_gradient/base_cop_spikey_df")
			},
			[Idstring("mtr_barrel"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/cop/sticker/sticker_bdsm_df"),
				uv_offset_rot = Vector3(-0.30007, 1.43362, 3.12136),
				pattern_pos = Vector3(0, 0.00620103, 0),
				uv_scale = Vector3(6.98481, 6.98481, 1),
				pattern_tweak = Vector3(16.4703, 0, 1)
			}
		},
		wpn_fps_lmg_m134_body = {
			[Idstring("mtr_body"):key()] = {
				uv_offset_rot = Vector3(0.196995, 1.22728, 0),
				pattern_gradient = Idstring("units/payday2_cash/safes/cf15/pattern_gradient/gradient_cf15_gold_df"),
				pattern = Idstring("units/payday2_cash/safes/cop/pattern/pattern_flames_df"),
				pattern_tweak = Vector3(7.55068, 1.71278, 1)
			}
		}
	}
	self.weapon_skins.m134_bulletstorm.default_blueprint = {
		"wpn_fps_lmg_m134_body",
		"wpn_fps_lmg_m134_m_standard",
		"wpn_fps_lmg_m134_barrel_extreme",
		"wpn_fps_lmg_m134_body_upper",
		"wpn_fps_upg_fl_ass_utg",
		"wpn_fps_upg_the_gimp_legend"
	}
	self.weapon_skins.r870_waves.parts = {
		wpn_fps_shot_r870_body_standard = {
			[Idstring("receiver"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/surf/sticker/sticker_legendary_big_df"),
				uv_scale = Vector3(0.78745, 0.787775, 1),
				uv_offset_rot = Vector3(-0.132736, 1.12235, 0)
			}
		},
		wpn_fps_shot_r870_b_legendary = {
			[Idstring("long_barrel"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/surf/sticker/sticker_legendary_big_df"),
				uv_scale = Vector3(0.834774, 0.930124, 1),
				uv_offset_rot = Vector3(-0.165514, 1.10327, 3.15133)
			},
			[Idstring("mtr_legendary_barrel"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/surf/sticker/sticker_legendary_big_df"),
				uv_offset_rot = Vector3(0.184614, 1.15697, 1.61487),
				uv_scale = Vector3(2.79044, 2.59874, 1),
				base_gradient = Idstring("units/payday2_cash/safes/shared/base_gradient/base_tactical_001_df")
			}
		},
		wpn_fps_shot_r870_b_long = {
			[Idstring("long_barrel"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/surf/sticker/sticker_legendary_big_df"),
				uv_scale = Vector3(0.834774, 0.930124, 1),
				uv_offset_rot = Vector3(-0.165514, 1.10327, 3.15133)
			},
			[Idstring("mtr_legendary_barrel"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/surf/sticker/sticker_legendary_big_df"),
				uv_offset_rot = Vector3(0.184614, 1.15697, 1.61487),
				uv_scale = Vector3(2.79044, 2.59874, 1),
				base_gradient = Idstring("units/payday2_cash/safes/shared/base_gradient/base_tactical_001_df")
			}
		}
	}
	self.weapon_skins.r870_waves.default_blueprint = {
		"wpn_fps_shot_r870_body_standard",
		"wpn_fps_shot_r870_b_long",
		"wpn_fps_upg_m4_g_ergo",
		"wpn_fps_shot_r870_fg_wood",
		"wpn_fps_shot_r870_s_nostock",
		"wpn_fps_upg_the_big_kahuna"
	}
	self.weapon_skins.p90_dallas_sallad.default_blueprint = {
		"wpn_fps_smg_p90_body_p90",
		"wpn_fps_smg_p90_m_std",
		"wpn_fps_smg_p90_b_long",
		"wpn_fps_upg_o_cmore",
		"wpn_fps_upg_fl_ass_utg",
		"wpn_fps_upg_salad_legend"
	}
	self.weapon_skins.x_1911_ginger.parts = {
		wpn_fps_pis_1911_o_long = {
			[Idstring("sights"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/flake/base_gradient/base_flake_003_df")
			}
		},
		wpn_fps_pis_1911_b_standard = {
			[Idstring("slide_long"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/flake/sticker/flake_sticker_swirl_df"),
				pattern = Idstring("units/payday2_cash/safes/flake/pattern/flake_pattern_04_df"),
				base_gradient = Idstring("units/payday2_cash/safes/flake/base_gradient/base_flake_003_df"),
				uv_offset_rot = Vector3(-0.146434, 1.01741, 0),
				pattern_pos = Vector3(0.301932, 0, 0),
				uv_scale = Vector3(1.78827, 2.88479, 1),
				pattern_tweak = Vector3(1.06368, 0, 1),
				pattern_gradient = Idstring("units/payday2_cash/safes/flake/pattern_gradient/pattern_gradient_001_df")
			},
			[Idstring("barrel_vented"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/flake/base_gradient/base_flake_003_df")
			}
		},
		wpn_fps_pis_1911_b_long = {
			[Idstring("slide_long"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/flake/sticker/flake_sticker_swirl_df"),
				pattern = Idstring("units/payday2_cash/safes/flake/pattern/flake_pattern_04_df"),
				base_gradient = Idstring("units/payday2_cash/safes/flake/base_gradient/base_flake_003_df"),
				uv_offset_rot = Vector3(-0.146434, 1.01741, 0),
				pattern_pos = Vector3(0.301932, 0, 0),
				uv_scale = Vector3(1.78827, 2.88479, 1),
				pattern_tweak = Vector3(1.06368, 0, 1),
				pattern_gradient = Idstring("units/payday2_cash/safes/flake/pattern_gradient/pattern_gradient_001_df")
			},
			[Idstring("barrel_vented"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/flake/base_gradient/base_flake_003_df")
			}
		},
		wpn_fps_pis_1911_b_vented = {
			[Idstring("slide_long"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/flake/sticker/flake_sticker_swirl_df"),
				pattern = Idstring("units/payday2_cash/safes/flake/pattern/flake_pattern_04_df"),
				base_gradient = Idstring("units/payday2_cash/safes/flake/base_gradient/base_flake_003_df"),
				uv_offset_rot = Vector3(-0.146434, 1.01741, 0),
				pattern_pos = Vector3(0.301932, 0, 0),
				uv_scale = Vector3(1.78827, 2.88479, 1),
				pattern_tweak = Vector3(1.06368, 0, 1),
				pattern_gradient = Idstring("units/payday2_cash/safes/flake/pattern_gradient/pattern_gradient_001_df")
			},
			[Idstring("barrel_vented"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/flake/base_gradient/base_flake_003_df")
			}
		},
		wpn_fps_pis_1911_fl_legendary = {
			[Idstring("mtr_legend_laser"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/flake/sticker/flake_sticker_swirl_df"),
				uv_offset_rot = Vector3(0.158836, 1.00787, 3.36112),
				pattern_tweak = Vector3(1.87455, 0, 1),
				pattern = Idstring("units/payday2_cash/safes/flake/pattern/flake_pattern_04_df"),
				uv_scale = Vector3(2.78944, 6.03132, 1),
				base_gradient = Idstring("units/payday2_cash/safes/flake/base_gradient/base_flake_003_df"),
				pattern_gradient = Idstring("units/payday2_cash/safes/flake/pattern_gradient/pattern_gradient_001_df")
			}
		},
		wpn_fps_upg_fl_pis_laser = {
			[Idstring("mtr_legend_laser"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/flake/sticker/flake_sticker_swirl_df"),
				uv_offset_rot = Vector3(0.158836, 1.00787, 3.36112),
				pattern_tweak = Vector3(1.87455, 0, 1),
				pattern = Idstring("units/payday2_cash/safes/flake/pattern/flake_pattern_04_df"),
				uv_scale = Vector3(2.78944, 6.03132, 1),
				base_gradient = Idstring("units/payday2_cash/safes/flake/base_gradient/base_flake_003_df"),
				pattern_gradient = Idstring("units/payday2_cash/safes/flake/pattern_gradient/pattern_gradient_001_df")
			}
		},
		wpn_fps_upg_fl_pis_tlr1 = {
			[Idstring("mtr_legend_laser"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/flake/sticker/flake_sticker_swirl_df"),
				uv_offset_rot = Vector3(0.158836, 1.00787, 3.36112),
				pattern_tweak = Vector3(1.87455, 0, 1),
				pattern = Idstring("units/payday2_cash/safes/flake/pattern/flake_pattern_04_df"),
				uv_scale = Vector3(2.78944, 6.03132, 1),
				base_gradient = Idstring("units/payday2_cash/safes/flake/base_gradient/base_flake_003_df"),
				pattern_gradient = Idstring("units/payday2_cash/safes/flake/pattern_gradient/pattern_gradient_001_df")
			}
		},
		wpn_fps_upg_fl_pis_crimson = {
			[Idstring("mtr_legend_laser"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/flake/sticker/flake_sticker_swirl_df"),
				uv_offset_rot = Vector3(0.158836, 1.00787, 3.36112),
				pattern_tweak = Vector3(1.87455, 0, 1),
				pattern = Idstring("units/payday2_cash/safes/flake/pattern/flake_pattern_04_df"),
				uv_scale = Vector3(2.78944, 6.03132, 1),
				base_gradient = Idstring("units/payday2_cash/safes/flake/base_gradient/base_flake_003_df"),
				pattern_gradient = Idstring("units/payday2_cash/safes/flake/pattern_gradient/pattern_gradient_001_df")
			}
		},
		wpn_fps_upg_fl_pis_x400v = {
			[Idstring("mtr_legend_laser"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/flake/sticker/flake_sticker_swirl_df"),
				uv_offset_rot = Vector3(0.158836, 1.00787, 3.36112),
				pattern_tweak = Vector3(1.87455, 0, 1),
				pattern = Idstring("units/payday2_cash/safes/flake/pattern/flake_pattern_04_df"),
				uv_scale = Vector3(2.78944, 6.03132, 1),
				base_gradient = Idstring("units/payday2_cash/safes/flake/base_gradient/base_flake_003_df"),
				pattern_gradient = Idstring("units/payday2_cash/safes/flake/pattern_gradient/pattern_gradient_001_df")
			}
		},
		wpn_fps_upg_fl_pis_m3x = {
			[Idstring("mtr_legend_laser"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/flake/sticker/flake_sticker_swirl_df"),
				uv_offset_rot = Vector3(0.158836, 1.00787, 3.36112),
				pattern_tweak = Vector3(1.87455, 0, 1),
				pattern = Idstring("units/payday2_cash/safes/flake/pattern/flake_pattern_04_df"),
				uv_scale = Vector3(2.78944, 6.03132, 1),
				base_gradient = Idstring("units/payday2_cash/safes/flake/base_gradient/base_flake_003_df"),
				pattern_gradient = Idstring("units/payday2_cash/safes/flake/pattern_gradient/pattern_gradient_001_df")
			}
		},
		wpn_fps_pis_1911_g_legendary = {
			[Idstring("mtr_legend_grip"):key()] = {
				pattern_tweak = Vector3(5.21345, 3.04644, 1),
				pattern = Idstring("units/payday2_cash/safes/dallas/pattern/pattern_wood_df"),
				pattern_gradient = Idstring("units/payday2_cash/safes/dallas/pattern_gradient/gradient_dallas_wood_001_df")
			}
		},
		wpn_fps_pis_1911_g_standard = {
			[Idstring("mtr_legend_grip"):key()] = {
				pattern_tweak = Vector3(5.21345, 3.04644, 1),
				pattern = Idstring("units/payday2_cash/safes/dallas/pattern/pattern_wood_df"),
				pattern_gradient = Idstring("units/payday2_cash/safes/dallas/pattern_gradient/gradient_dallas_wood_001_df")
			}
		},
		wpn_fps_pis_1911_g_bling = {
			[Idstring("mtr_legend_grip"):key()] = {
				pattern_tweak = Vector3(5.21345, 3.04644, 1),
				pattern = Idstring("units/payday2_cash/safes/dallas/pattern/pattern_wood_df"),
				pattern_gradient = Idstring("units/payday2_cash/safes/dallas/pattern_gradient/gradient_dallas_wood_001_df")
			}
		},
		wpn_fps_pis_1911_g_ergo = {
			[Idstring("mtr_legend_grip"):key()] = {
				pattern_tweak = Vector3(5.21345, 3.04644, 1),
				pattern = Idstring("units/payday2_cash/safes/dallas/pattern/pattern_wood_df"),
				pattern_gradient = Idstring("units/payday2_cash/safes/dallas/pattern_gradient/gradient_dallas_wood_001_df")
			}
		},
		wpn_fps_pis_1911_g_engraved = {
			[Idstring("mtr_legend_grip"):key()] = {
				pattern_tweak = Vector3(5.21345, 3.04644, 1),
				pattern = Idstring("units/payday2_cash/safes/dallas/pattern/pattern_wood_df"),
				pattern_gradient = Idstring("units/payday2_cash/safes/dallas/pattern_gradient/gradient_dallas_wood_001_df")
			}
		}
	}
	self.weapon_skins.x_1911_ginger.default_blueprint = {
		"wpn_fps_pis_1911_g_standard",
		"wpn_fps_upg_fl_pis_laser",
		"wpn_fps_pis_1911_body_standard",
		"wpn_fps_pis_1911_b_long",
		"wpn_fps_pis_1911_m_standard",
		"wpn_fps_upg_santa_slayers_legend"
	}
	self.weapon_skins.model70_baaah.parts = {
		wpn_fps_snp_model70_b_legend = {
			[Idstring("mtr_skull"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/shared/base_gradient/base_shared_003_df")
			},
			[Idstring("mtr_barrel"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/dallas/base_gradient/base_dallas_003_df")
			}
		},
		wpn_fps_snp_model70_s_legend = {
			[Idstring("mtr_legend"):key()] = {
				uv_scale = Vector3(4.5534, 4.02898, 0),
				uv_offset_rot = Vector3(-0.308609, 1.01741, 0.513984)
			},
			[Idstring("mtr_body"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/bah/sticker/sticker_bah_005_df"),
				uv_offset_rot = Vector3(-0.0188784, 0.924013, 0.469029),
				pattern_gradient = Idstring("units/payday2_cash/safes/bah/pattern_gradient/gradient_bah_002_df"),
				pattern_pos = Vector3(-0.140053, 0.322472, 0),
				uv_scale = Vector3(3.12316, 4.79177, 0),
				pattern = Idstring("units/payday2_cash/safes/bah/pattern/bah_pattern_007_df"),
				pattern_tweak = Vector3(6.21612, 0.012, 1)
			}
		},
		wpn_fps_snp_model70_s_standard = {
			[Idstring("mtr_legend"):key()] = {
				uv_scale = Vector3(4.5534, 4.02898, 0),
				uv_offset_rot = Vector3(-0.308609, 1.01741, 0.513984)
			},
			[Idstring("mtr_body"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/bah/sticker/sticker_bah_005_df"),
				uv_offset_rot = Vector3(-0.0188784, 0.924013, 0.469029),
				pattern_gradient = Idstring("units/payday2_cash/safes/bah/pattern_gradient/gradient_bah_002_df"),
				pattern_pos = Vector3(-0.140053, 0.322472, 0),
				uv_scale = Vector3(3.12316, 4.79177, 0),
				pattern = Idstring("units/payday2_cash/safes/bah/pattern/bah_pattern_007_df"),
				pattern_tweak = Vector3(6.21612, 0.012, 1)
			}
		},
		wpn_fps_upg_o_leupold = {
			[Idstring("leupold"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/bah/sticker/sticker_bah_002b_df"),
				pattern = Idstring("units/payday2_cash/safes/bah/pattern/bah_pattern_001_df"),
				base_gradient = Idstring("units/payday2_cash/safes/dallas/base_gradient/base_dallas_003_df"),
				uv_offset_rot = Vector3(0.36663, 0.969712, 6.28319),
				pattern_pos = Vector3(-0.037418, 0.807537, 0),
				uv_scale = Vector3(3.21851, 11.8953, 0),
				pattern_gradient = Idstring("units/payday2_cash/safes/bah/pattern_gradient/gradient_bah_009_df"),
				pattern_tweak = Vector3(0.532996, 0, 0)
			}
		},
		wpn_fps_snp_model70_body_standard = {
			[Idstring("mtr_receiver"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/bah/sticker/sticker_bah_005_df"),
				uv_scale = Vector3(1.50222, 1.1685, 0),
				uv_offset_rot = Vector3(0.222376, 1.08273, 5.22823)
			}
		}
	}

	--Legendary Part Additions
	self.weapon_skins.model70_baaah.default_blueprint = {
		"wpn_fps_snp_model70_b_standard",
		"wpn_fps_snp_model70_body_standard",
		"wpn_fps_snp_model70_s_standard",
		"wpn_fps_snp_model70_m_standard",
		"wpn_fps_upg_o_leupold",
		"wpn_fps_upg_fl_ass_peq15",
		"wpn_fps_upg_baaah_legend"
	}
	self.weapon_skins.par_wolf.default_blueprint = {
		"wpn_fps_lmg_par_b_short",
		"wpn_fps_lmg_par_body_standard",
		"wpn_fps_lmg_par_m_standard",
		"wpn_fps_lmg_par_s_plastic",
		"wpn_fps_lmg_par_upper_reciever",
		"wpn_fps_upg_bp_lmg_lionbipod",
		"wpn_fps_upg_fl_ass_utg",
		"wpn_fps_upg_par_legend"
	}
	self.weapon_skins.m16_cola.default_blueprint = {
		"wpn_fps_m4_uupg_draghandle",
		"wpn_fps_upg_m4_m_pmag",
		"wpn_fps_upg_o_acog",
		"wpn_fps_m4_uupg_b_long",
		"wpn_fps_m16_fg_standard",
		"wpn_fps_m16_s_solid_vanilla",
		"wpn_fps_upg_m4_g_mgrip",
		"wpn_fps_upg_ass_m4_lower_reciever_core",
		"wpn_fps_upg_ass_m4_upper_reciever_core",
		"wpn_fps_upg_cola_legend"
	}
	self.weapon_skins.boot_buck.default_blueprint = {
		"wpn_fps_sho_boot_b_standard",
		"wpn_fps_sho_boot_fg_standard",
		"wpn_fps_sho_boot_s_short",
		"wpn_fps_sho_boot_body_standard",
		"wpn_fps_sho_boot_em_extra",
		"wpn_fps_sho_boot_m_standard",
		"wpn_fps_upg_boot_legend_optic",
		"wpn_fps_upg_boot_legend"
	}
	self.weapon_skins.boot_buck.parts = {
		wpn_fps_sho_boot_fg_legendary = {
			[Idstring("mtr_fg_legend"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/buck/sticker/buck_sticker_018_df"),
				uv_offset_rot = Vector3(-0.013418, 0.889093, 6.28319),
				uv_scale = Vector3(2.24234, 4.59908, 0),
				pattern_gradient = Idstring("units/payday2_cash/safes/buck/pattern_gradient/gradient_buck_013_df")
			}
		},
		wpn_fps_sho_boot_fg_standard = {
			[Idstring("mtr_fg_legend"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/buck/sticker/buck_sticker_018_df"),
				uv_offset_rot = Vector3(-0.013418, 0.889093, 6.28319),
				uv_scale = Vector3(2.24234, 4.59908, 0),
				pattern_gradient = Idstring("units/payday2_cash/safes/buck/pattern_gradient/gradient_buck_013_df")
			}
		},
		wpn_fps_sho_boot_body_standard = {
			[Idstring("mtr_body"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/buck/sticker/buck_sticker_017_df"),
				uv_offset_rot = Vector3(0.027582, 0.99787, 6.28319),
				uv_scale = Vector3(2.83711, 2.83711, 0),
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_007_df")
			},
			[Idstring("mtr_mech"):key()] = {
				uv_scale = Vector3(4.7441, 6.60341, 1),
				uv_offset_rot = Vector3(0, 1.19866, 1.57791)
			}
		},
		wpn_fps_sho_boot_body_exotic = {
			[Idstring("mtr_body"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/buck/sticker/buck_sticker_017_df"),
				uv_offset_rot = Vector3(0.027582, 0.99787, 6.28319),
				uv_scale = Vector3(2.83711, 2.83711, 0),
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_007_df")
			},
			[Idstring("mtr_mech"):key()] = {
				uv_scale = Vector3(4.7441, 6.60341, 1),
				uv_offset_rot = Vector3(0, 1.19866, 1.57791)
			}
		},
		wpn_fps_sho_boot_b_legendary = {
			[Idstring("mtr_b_legend"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_016_b_df"),
				uv_offset_rot = Vector3(0.35517, 0.950632, 1.56293),
				pattern_pos = Vector3(0.645361, 0.473647, 0),
				uv_scale = Vector3(3.9813, 0.01, 1),
				pattern_tweak = Vector3(15.1347, 0.0794209, 1),
				pattern_gradient = Idstring("units/payday2_cash/safes/buck/pattern_gradient/gradient_buck_013_df")
			},
			[Idstring("mtr_axe"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_016_c_df"),
				uv_offset_rot = Vector3(0.257393, 0.823076, 3.12136),
				pattern_pos = Vector3(0.387789, -0.404006, 0),
				uv_scale = Vector3(2.27501, 3.40989, 0),
				sticker = Idstring("units/payday2_cash/safes/buck/sticker/buck_sticker_020_df"),
				pattern_tweak = Vector3(5.49964, 1.60788, 1)
			},
			[Idstring("mtr_barrel"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_007_df"),
				uv_offset_rot = Vector3(0.149297, 0.998331, 0),
				pattern_pos = Vector3(0, 0.206535, 0),
				uv_scale = Vector3(4.172, 5.84062, 0.150966),
				pattern_tweak = Vector3(7.26449, 0, 1),
				pattern_gradient = Idstring("units/payday2_cash/safes/buck/pattern_gradient/gradient_buck_013_df")
			}
		},
		wpn_fps_sho_boot_b_standard = {
			[Idstring("mtr_b_legend"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_016_b_df"),
				uv_offset_rot = Vector3(0.35517, 0.950632, 1.56293),
				pattern_pos = Vector3(0.645361, 0.473647, 0),
				uv_scale = Vector3(3.9813, 0.01, 1),
				pattern_tweak = Vector3(15.1347, 0.0794209, 1),
				pattern_gradient = Idstring("units/payday2_cash/safes/buck/pattern_gradient/gradient_buck_013_df")
			},
			[Idstring("mtr_axe"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_016_c_df"),
				uv_offset_rot = Vector3(0.257393, 0.823076, 3.12136),
				pattern_pos = Vector3(0.387789, -0.404006, 0),
				uv_scale = Vector3(2.27501, 3.40989, 0),
				sticker = Idstring("units/payday2_cash/safes/buck/sticker/buck_sticker_020_df"),
				pattern_tweak = Vector3(5.49964, 1.60788, 1)
			},
			[Idstring("mtr_barrel"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_007_df"),
				uv_offset_rot = Vector3(0.149297, 0.998331, 0),
				pattern_pos = Vector3(0, 0.206535, 0),
				uv_scale = Vector3(4.172, 5.84062, 0.150966),
				pattern_tweak = Vector3(7.26449, 0, 1),
				pattern_gradient = Idstring("units/payday2_cash/safes/buck/pattern_gradient/gradient_buck_013_df")
			}
		},
		wpn_fps_sho_boot_b_short = {
			[Idstring("mtr_b_legend"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_016_b_df"),
				uv_offset_rot = Vector3(0.35517, 0.950632, 1.56293),
				pattern_pos = Vector3(0.645361, 0.473647, 0),
				uv_scale = Vector3(3.9813, 0.01, 1),
				pattern_tweak = Vector3(15.1347, 0.0794209, 1),
				pattern_gradient = Idstring("units/payday2_cash/safes/buck/pattern_gradient/gradient_buck_013_df")
			},
			[Idstring("mtr_axe"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_016_c_df"),
				uv_offset_rot = Vector3(0.257393, 0.823076, 3.12136),
				pattern_pos = Vector3(0.387789, -0.404006, 0),
				uv_scale = Vector3(2.27501, 3.40989, 0),
				sticker = Idstring("units/payday2_cash/safes/buck/sticker/buck_sticker_020_df"),
				pattern_tweak = Vector3(5.49964, 1.60788, 1)
			},
			[Idstring("mtr_barrel"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_007_df"),
				uv_offset_rot = Vector3(0.149297, 0.998331, 0),
				pattern_pos = Vector3(0, 0.206535, 0),
				uv_scale = Vector3(4.172, 5.84062, 0.150966),
				pattern_tweak = Vector3(7.26449, 0, 1),
				pattern_gradient = Idstring("units/payday2_cash/safes/buck/pattern_gradient/gradient_buck_013_df")
			}
		},
		wpn_fps_sho_boot_b_long = {
			[Idstring("mtr_b_legend"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_016_b_df"),
				uv_offset_rot = Vector3(0.35517, 0.950632, 1.56293),
				pattern_pos = Vector3(0.645361, 0.473647, 0),
				uv_scale = Vector3(3.9813, 0.01, 1),
				pattern_tweak = Vector3(15.1347, 0.0794209, 1),
				pattern_gradient = Idstring("units/payday2_cash/safes/buck/pattern_gradient/gradient_buck_013_df")
			},
			[Idstring("mtr_axe"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_016_c_df"),
				uv_offset_rot = Vector3(0.257393, 0.823076, 3.12136),
				pattern_pos = Vector3(0.387789, -0.404006, 0),
				uv_scale = Vector3(2.27501, 3.40989, 0),
				sticker = Idstring("units/payday2_cash/safes/buck/sticker/buck_sticker_020_df"),
				pattern_tweak = Vector3(5.49964, 1.60788, 1)
			},
			[Idstring("mtr_barrel"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_007_df"),
				uv_offset_rot = Vector3(0.149297, 0.998331, 0),
				pattern_pos = Vector3(0, 0.206535, 0),
				uv_scale = Vector3(4.172, 5.84062, 0.150966),
				pattern_tweak = Vector3(7.26449, 0, 1),
				pattern_gradient = Idstring("units/payday2_cash/safes/buck/pattern_gradient/gradient_buck_013_df")
			}
		},
		wpn_fps_sho_boot_s_legendary = {
			[Idstring("mtr_s_legend"):key()] = {
				pattern = Idstring("units/payday2_cash/safes/buck/pattern/buck_pattern_006_df"),
				pattern_pos = Vector3(-0.184593, 0.7056, 0),
				pattern_gradient = Idstring("units/payday2_cash/safes/buck/pattern_gradient/gradient_buck_013_df"),
				pattern_tweak = Vector3(2.30384, 0, 1)
			}
		},
		wpn_fps_sho_boot_s_short = {
			[Idstring("mtr_s_legend"):key()] = {
				pattern = Idstring("units/payday2_cash/safes/buck/pattern/buck_pattern_006_df"),
				pattern_pos = Vector3(-0.184593, 0.7056, 0),
				pattern_gradient = Idstring("units/payday2_cash/safes/buck/pattern_gradient/gradient_buck_013_df"),
				pattern_tweak = Vector3(2.30384, 0, 1)
			}
		},
		wpn_fps_sho_boot_s_long = {
			[Idstring("mtr_s_legend"):key()] = {
				pattern = Idstring("units/payday2_cash/safes/buck/pattern/buck_pattern_006_df"),
				pattern_pos = Vector3(-0.184593, 0.7056, 0),
				pattern_gradient = Idstring("units/payday2_cash/safes/buck/pattern_gradient/gradient_buck_013_df"),
				pattern_tweak = Vector3(2.30384, 0, 1)
			}
		},
		wpn_fps_sho_boot_o_legendary = {
			[Idstring("mtr_sight_legend"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/buck/sticker/buck_sticker_001_df"),
				uv_scale = Vector3(7.22318, 12.2767, 0.179585),
				uv_offset_rot = Vector3(-0.0841165, 1.05303, 1.56293)
			}
		},
		wpn_fps_upg_boot_legend_optic = {
			[Idstring("mtr_sight_legend"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/buck/sticker/buck_sticker_001_df"),
				uv_scale = Vector3(7.22318, 12.2767, 0.179585),
				uv_offset_rot = Vector3(-0.0841165, 1.05303, 1.56293)
			}
		},
	}
	
	--BAYONETTA GUN--
	self.weapon_skins.judge_burn.default_blueprint = {
		"wpn_fps_pis_judge_body_standard",
		"wpn_fps_pis_judge_b_standard",
		"wpn_fps_pis_judge_g_standard",
		"wpn_fps_upg_judge_legend",
		"wpn_fps_upg_a_custom"
	}
	self.weapon_skins.judge_burn.parts = {
		wpn_fps_pis_judge_g_legend = {
			[Idstring("mtr_grip_legendary"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/burn/sticker/burn_sticker_025_df"),
				uv_scale = Vector3(2.16967, 2.40804, 0.310756),
				uv_offset_rot = Vector3(-0.195752, 1.00125, 4.7108)
			}
		},
		wpn_fps_pis_judge_g_standard = {
			[Idstring("mtr_grip_legendary"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/burn/sticker/burn_sticker_025_df"),
				uv_scale = Vector3(2.16967, 2.40804, 0.310756),
				uv_offset_rot = Vector3(-0.195752, 1.00125, 4.7108)
			}
		},
		wpn_fps_pis_judge_b_legend = {
			[Idstring("mtr_b_legendary"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/burn/base_gradient/base_burn_016_c_df"),
				pattern = Idstring("units/payday2_cash/safes/burn/pattern/burn_pattern_001_df"),
				uv_offset_rot = Vector3(0.184455, 1.00579, 6.28319),
				pattern_pos = Vector3(0, 0.130217, 0),
				uv_scale = Vector3(2.40804, 2.50439, 1),
				sticker = Idstring("units/payday2_cash/safes/burn/sticker/burn_sticker_024_df"),
				pattern_tweak = Vector3(10.6034, 0.798698, 1)
			}
		},
		wpn_fps_pis_judge_b_standard = {
			[Idstring("mtr_b_legendary"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/burn/base_gradient/base_burn_016_c_df"),
				pattern = Idstring("units/payday2_cash/safes/burn/pattern/burn_pattern_001_df"),
				uv_offset_rot = Vector3(0.184455, 1.00579, 6.28319),
				pattern_pos = Vector3(0, 0.130217, 0),
				uv_scale = Vector3(2.40804, 2.50439, 1),
				sticker = Idstring("units/payday2_cash/safes/burn/sticker/burn_sticker_024_df"),
				pattern_tweak = Vector3(10.6034, 0.798698, 1)
			}
		},
		wpn_fps_pis_judge_body_standard = {
			[Idstring("mtr_buckshot"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/surf/base_gradient/base_surf_003_df")
			},
			[Idstring("mtr_mech"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/burn/base_gradient/base_burn_016_b_df")
			},
			[Idstring("mtr_cylinder"):key()] = {
				pattern = Idstring("units/payday2_cash/safes/burn/pattern/burn_pattern_020_df"),
				pattern_pos = Vector3(0, 0.626822, 0),
				uv_scale = Vector3(1, 0.01, 1),
				pattern_tweak = Vector3(1.34987, 4.71775, 1),
				pattern_gradient = Idstring("units/payday2_cash/safes/burn/pattern_gradient/gradient_burn_006_df")
			},
			[Idstring("mtr_frame"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/burn/sticker/burn_sticker_026_df"),
				uv_offset_rot = Vector3(-0.0329577, 0.881854, 1.57491),
				uv_scale = Vector3(1.69292, 1.88362, 1),
				pattern_tweak = Vector3(0.920584, 0, 1)
			}
		}
	}

	--KSG legendary--
	self.weapon_skins.ksg_same.default_blueprint = {
		"wpn_fps_sho_ksg_body_standard",
		"wpn_fps_sho_ksg_b_long",
		"wpn_fps_sho_ksg_fg_standard",
		"wpn_fps_upg_o_dd_rear",
		"wpn_fps_upg_ksg_legend",
		"wpn_fps_upg_a_custom_free"
	}
	self.weapon_skins.ksg_same.parts = {
		wpn_fps_sho_ksg_fg_standard = {
			[Idstring("mat_pump"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/same/base_gradient/base_gradient_same_015_d_df"),
				uv_offset_rot = Vector3(-0.308609, 0.740759, 4.14034),
				uv_scale = Vector3(0.01, 0.601377, 0),
				sticker = "units/payday2_cash/safes/same/sticker/sticker_same_015_e_df"
			}
		},
		wpn_fps_upg_o_dd_rear = {
			[Idstring("mtr_dd"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/same/base_gradient/base_gradient_same_015_d_df")
			}
		},
		wpn_fps_upg_o_dd_front = {
			[Idstring("mtr_dd"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/same/base_gradient/base_gradient_same_015_d_df")
			}
		},
		wpn_fps_sho_ksg_b_legendary = {
			[Idstring("mat_body"):key()] = {
				base_gradient = "units/payday2_cash/safes/same/base_gradient/base_gradient_same_015_c_df"
			},
			[Idstring("mtr_comp"):key()] = {
				pattern_tweak = Vector3(0, 0, 1),
				base_gradient = "units/payday2_cash/safes/same/base_gradient/base_gradient_same_015_b_df",
				sticker = Idstring("units/payday2_cash/safes/same/sticker/sticker_same_015_b_df"),
				uv_scale = Vector3(5.22085, 5.22085, 0.053184),
				uv_offset_rot = Vector3(-0.00333852, 0.993331, 0),
				pattern_gradient = Idstring("units/payday2_cash/safes/red/pattern_gradient/pattern_gradient_marble_floor_df"),
				pattern = Idstring("units/payday2_cash/safes/same/pattern/same_pattern_016_df")
			}
		},
		wpn_fps_sho_ksg_b_long = {
			[Idstring("mat_body"):key()] = {
				base_gradient = "units/payday2_cash/safes/same/base_gradient/base_gradient_same_015_c_df"
			},
			[Idstring("mtr_comp"):key()] = {
				pattern_tweak = Vector3(0, 0, 1),
				base_gradient = "units/payday2_cash/safes/same/base_gradient/base_gradient_same_015_b_df",
				sticker = Idstring("units/payday2_cash/safes/same/sticker/sticker_same_015_b_df"),
				uv_scale = Vector3(5.22085, 5.22085, 0.053184),
				uv_offset_rot = Vector3(-0.00333852, 0.993331, 0),
				pattern_gradient = Idstring("units/payday2_cash/safes/red/pattern_gradient/pattern_gradient_marble_floor_df"),
				pattern = Idstring("units/payday2_cash/safes/same/pattern/same_pattern_016_df")
			}
		},
		wpn_fps_sho_ksg_b_standard = {
			[Idstring("mat_body"):key()] = {
				base_gradient = "units/payday2_cash/safes/same/base_gradient/base_gradient_same_015_c_df"
			},
			[Idstring("mtr_comp"):key()] = {
				pattern_tweak = Vector3(0, 0, 1),
				base_gradient = "units/payday2_cash/safes/same/base_gradient/base_gradient_same_015_b_df",
				sticker = Idstring("units/payday2_cash/safes/same/sticker/sticker_same_015_b_df"),
				uv_scale = Vector3(5.22085, 5.22085, 0.053184),
				uv_offset_rot = Vector3(-0.00333852, 0.993331, 0),
				pattern_gradient = Idstring("units/payday2_cash/safes/red/pattern_gradient/pattern_gradient_marble_floor_df"),
				pattern = Idstring("units/payday2_cash/safes/same/pattern/same_pattern_016_df")
			}
		},
		wpn_fps_sho_ksg_b_short = {
			[Idstring("mat_body"):key()] = {
				base_gradient = "units/payday2_cash/safes/same/base_gradient/base_gradient_same_015_c_df"
			},
			[Idstring("mtr_comp"):key()] = {
				pattern_tweak = Vector3(0, 0, 1),
				base_gradient = "units/payday2_cash/safes/same/base_gradient/base_gradient_same_015_b_df",
				sticker = Idstring("units/payday2_cash/safes/same/sticker/sticker_same_015_b_df"),
				uv_scale = Vector3(5.22085, 5.22085, 0.053184),
				uv_offset_rot = Vector3(-0.00333852, 0.993331, 0),
				pattern_gradient = Idstring("units/payday2_cash/safes/red/pattern_gradient/pattern_gradient_marble_floor_df"),
				pattern = Idstring("units/payday2_cash/safes/same/pattern/same_pattern_016_df")
			}
		},
		wpn_fps_sho_ksg_body_standard = {
			[Idstring("mat_body"):key()] = {
				pattern_gradient = Idstring("units/payday2_cash/safes/same/pattern_gradient/gradient_same_016_df"),
				pattern_tweak = Vector3(0.983, 3.15932, 1),
				uv_offset_rot = Vector3(-0.093196, 1.00787, 6.28319),
				uv_scale = Vector3(3.12316, 3.07549, 0),
				pattern_pos = Vector3(1.10057, 1.2172, 0),
				sticker = "units/payday2_cash/safes/same/sticker/sticker_same_015_df",
				pattern = Idstring("units/payday2_cash/safes/cola/pattern/cola_pattern_010_df")
			}
		}
	}

	--The Not Patriot--
	self.weapon_skins.tecci_grunt.default_blueprint = {
		"wpn_fps_ass_tecci_dh_standard",
		"wpn_fps_ass_tecci_lower_reciever",
		"wpn_fps_ass_tecci_m_drum",
		"wpn_fps_ass_tecci_upper_reciever",
		"wpn_fps_ass_tecci_vg_standard",
		"wpn_fps_upg_m4_g_hgrip",
		"wpn_fps_upg_o_eotech",
		"wpn_fps_ass_tecci_b_standard",
		"wpn_fps_ass_tecci_fg_standard",
		"wpn_fps_m4_uupg_s_fold",
		"wpn_fps_upg_tecci_legend"
	}
	self.weapon_skins.tecci_grunt.parts = {
		wpn_fps_ass_tecci_lower_reciever = {
			[Idstring("mtr_lower"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/dinner/base_gradient/base_assault_002_df"),
				sticker = Idstring("units/payday2_cash/safes/grunt/sticker/grunt_sticker_024_df"),
				uv_scale = Vector3(14.1837, 14.279, 0),
				uv_offset_rot = Vector3(0.12736, 0.674981, 6.28319)
			}
		},
		wpn_fps_ass_tecci_b_legend = {
			[Idstring("mtr_b_legend"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/shared/base_gradient/base_shared_002_df"),
				pattern_tweak = Vector3(0, 0, 1),
				pattern = Idstring("units/payday2_cash/safes/shared/pattern/pattern_acryl_001_df")
			}
		},
		wpn_fps_ass_tecci_b_standard = {
			[Idstring("mtr_b_legend"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/shared/base_gradient/base_shared_002_df"),
				pattern_tweak = Vector3(0, 0, 1),
				pattern = Idstring("units/payday2_cash/safes/shared/pattern/pattern_acryl_001_df")
			}
		},
		wpn_fps_ass_tecci_b_long = {
			[Idstring("mtr_b_legend"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/shared/base_gradient/base_shared_002_df"),
				pattern_tweak = Vector3(0, 0, 1),
				pattern = Idstring("units/payday2_cash/safes/shared/pattern/pattern_acryl_001_df")
			}
		},
		wpn_fps_ass_tecci_dh_standard = {
			[Idstring("mtr_drag"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/cf15/base_gradient/base_cf15_001_df"),
				pattern_tweak = Vector3(0, 0, 1)
			}
		},
		wpn_fps_upg_o_eotech = {
			[Idstring("mtr_eotech"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/grunt/base_gradient/base_grunt_007_df"),
				sticker = Idstring("units/payday2_cash/safes/grunt/sticker/grunt_sticker_021_df"),
				uv_scale = Vector3(6.55574, 6.93714, 1),
				uv_offset_rot = Vector3(-7.98811E-4, 0.788918, 0),
				pattern = Idstring("units/payday2_cash/safes/grunt/pattern/grunt_pattern_001_df")
			}
		},
		wpn_fps_ass_tecci_upper_reciever = {
			[Idstring("mtr_upper"):key()] = {
				pattern_tweak = Vector3(0, 0, 1),
				sticker = Idstring("units/payday2_cash/safes/grunt/sticker/grunt_sticker_023_df"),
				uv_scale = Vector3(4.5534, 4.3627, 1),
				uv_offset_rot = Vector3(-0.0594179, 0.913934, 0),
				pattern = Idstring("units/payday2_cash/safes/shared/pattern/pattern_acryl_001_df")
			}
		},
		wpn_fps_ass_tecci_vg_standard = {
			[Idstring("mtr_vg"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/grunt/sticker/grunt_sticker_019_df"),
				uv_scale = Vector3(2.69409, 3.12316, 0.263058),
				pattern_pos = Vector3(0.225614, 0.0825189, 0),
				uv_offset_rot = Vector3(0.0709791, 0.669981, 1.60788)
			}
		},
		wpn_fps_ass_tecci_s_legend = {
			[Idstring("mtr_s_legend"):key()] = {
				uv_offset_rot = Vector3(-0.271371, 1.00925, 6.28319),
				sticker = Idstring("units/payday2_cash/safes/grunt/sticker/grunt_sticker_026_df"),
				uv_scale = Vector3(4.45805, 2.78944, 0)
			}
		},
		wpn_fps_ass_tecci_s_standard = {
			[Idstring("mtr_s_legend"):key()] = {
				uv_offset_rot = Vector3(-0.271371, 1.00925, 6.28319),
				sticker = Idstring("units/payday2_cash/safes/grunt/sticker/grunt_sticker_026_df"),
				uv_scale = Vector3(4.45805, 2.78944, 0)
			}
		},
		wpn_fps_upg_m4_s_standard = {
			[Idstring("mtr_s_legend"):key()] = {
				uv_offset_rot = Vector3(-0.271371, 1.00925, 6.28319),
				sticker = Idstring("units/payday2_cash/safes/grunt/sticker/grunt_sticker_026_df"),
				uv_scale = Vector3(4.45805, 2.78944, 0)
			}
		},
		wpn_fps_upg_m4_s_crane = {
			[Idstring("mtr_s_legend"):key()] = {
				uv_offset_rot = Vector3(-0.271371, 1.00925, 6.28319),
				sticker = Idstring("units/payday2_cash/safes/grunt/sticker/grunt_sticker_026_df"),
				uv_scale = Vector3(4.45805, 2.78944, 0)
			}
		},
		wpn_fps_upg_m4_s_mk46 = {
			[Idstring("mtr_s_legend"):key()] = {
				uv_offset_rot = Vector3(-0.271371, 1.00925, 6.28319),
				sticker = Idstring("units/payday2_cash/safes/grunt/sticker/grunt_sticker_026_df"),
				uv_scale = Vector3(4.45805, 2.78944, 0)
			}
		},
		wpn_fps_upg_m4_s_ubr = {
			[Idstring("mtr_s_legend"):key()] = {
				uv_offset_rot = Vector3(-0.271371, 1.00925, 6.28319),
				sticker = Idstring("units/payday2_cash/safes/grunt/sticker/grunt_sticker_026_df"),
				uv_scale = Vector3(4.45805, 2.78944, 0)
			}
		},
		wpn_fps_m4_uupg_s_fold = {
			[Idstring("mtr_s_legend"):key()] = {
				uv_offset_rot = Vector3(-0.271371, 1.00925, 6.28319),
				sticker = Idstring("units/payday2_cash/safes/grunt/sticker/grunt_sticker_026_df"),
				uv_scale = Vector3(4.45805, 2.78944, 0)
			}
		},
		wpn_fps_upg_m4_s_pts = {
			[Idstring("mtr_s_legend"):key()] = {
				uv_offset_rot = Vector3(-0.271371, 1.00925, 6.28319),
				sticker = Idstring("units/payday2_cash/safes/grunt/sticker/grunt_sticker_026_df"),
				uv_scale = Vector3(4.45805, 2.78944, 0)
			}
		},
		wpn_fps_ass_tecci_fg_legend = {
			[Idstring("mtr_fg_legend"):key()] = {
				pattern_tweak = Vector3(0, 0, 1),
				uv_offset_rot = Vector3(0.248614, 0.952632, 6.28319),
				uv_scale = Vector3(11.9907, 14.6128, 0),
				sticker = Idstring("units/payday2_cash/safes/grunt/sticker/grunt_sticker_025_df"),
				pattern = Idstring("units/payday2_cash/safes/bah/pattern/bah_pattern_006_df")
			}
		},
		wpn_fps_ass_tecci_fg_standard = {
			[Idstring("mtr_fg_legend"):key()] = {
				pattern_tweak = Vector3(0, 0, 1),
				uv_offset_rot = Vector3(0.248614, 0.952632, 6.28319),
				uv_scale = Vector3(11.9907, 14.6128, 0),
				sticker = Idstring("units/payday2_cash/safes/grunt/sticker/grunt_sticker_025_df"),
				pattern = Idstring("units/payday2_cash/safes/bah/pattern/bah_pattern_006_df")
			}
		}
	}
	--Plush Phoenix--
	self.weapon_skins.new_m14_lones.default_blueprint = {
		"wpn_fps_ass_m14_b_standard",
		"wpn_fps_ass_m14_body_lower",
		"wpn_fps_ass_m14_body_upper",
		"wpn_fps_ass_m14_m_standard",
		"wpn_fps_ass_m14_body_ebr",
		"wpn_fps_upg_o_m14_scopemount",
		"wpn_fps_upg_o_acog",
		"wpn_fps_upg_m14_legend",
		"wpn_fps_upg_ns_ass_smg_medium"
	}
	self.weapon_skins.new_m14_lones.parts = {
		wpn_fps_ass_m14_body_legendary = {
			[Idstring("mtr_body"):key()] = {
				pattern_tweak = Vector3(0.72979, 6.28319, 1),
				uv_offset_rot = Vector3(0.0495189, 1.01641, 6.23823),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_021_df"),
				uv_scale = Vector3(1.26385, 3.74293, 1),
				pattern_pos = Vector3(-0.165514, -0.117815, 0),
				cubemap_pattern_control = Vector3(0.382304, 0.456237, 0),
				pattern = Idstring("units/payday2_cash/safes/burn/pattern/burn_pattern_020_df")
			},
			[Idstring("mtr_stock"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/lones/base_gradient/base_lones_009_c_df")
			}
		},
		wpn_fps_ass_m14_body_dmr = {
			[Idstring("mtr_body"):key()] = {
				pattern_tweak = Vector3(0.72979, 6.28319, 1),
				uv_offset_rot = Vector3(0.0495189, 1.01641, 6.23823),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_021_df"),
				uv_scale = Vector3(1.26385, 3.74293, 1),
				pattern_pos = Vector3(-0.165514, -0.117815, 0),
				cubemap_pattern_control = Vector3(0.382304, 0.456237, 0),
				pattern = Idstring("units/payday2_cash/safes/burn/pattern/burn_pattern_020_df")
			},
			[Idstring("mtr_stock"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/lones/base_gradient/base_lones_009_c_df")
			}
		},
		wpn_fps_ass_m14_body_ebr = {
			[Idstring("mtr_body"):key()] = {
				pattern_tweak = Vector3(0.72979, 6.28319, 1),
				uv_offset_rot = Vector3(0.0495189, 1.01641, 6.23823),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_021_df"),
				uv_scale = Vector3(1.26385, 3.74293, 1),
				pattern_pos = Vector3(-0.165514, -0.117815, 0),
				cubemap_pattern_control = Vector3(0.382304, 0.456237, 0),
				pattern = Idstring("units/payday2_cash/safes/burn/pattern/burn_pattern_020_df")
			},
			[Idstring("mtr_stock"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/lones/base_gradient/base_lones_009_c_df")
			}
		},
		wpn_fps_ass_m14_body_jae = {
			[Idstring("mtr_body"):key()] = {
				pattern_tweak = Vector3(0.72979, 6.28319, 1),
				uv_offset_rot = Vector3(0.0495189, 1.01641, 6.23823),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_021_df"),
				uv_scale = Vector3(1.26385, 3.74293, 1),
				pattern_pos = Vector3(-0.165514, -0.117815, 0),
				cubemap_pattern_control = Vector3(0.382304, 0.456237, 0),
				pattern = Idstring("units/payday2_cash/safes/burn/pattern/burn_pattern_020_df")
			},
			[Idstring("mtr_stock"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/lones/base_gradient/base_lones_009_c_df")
			}
		},
		wpn_fps_upg_o_eotech = {
			[Idstring("mtr_eotech"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_011_df"),
				uv_offset_rot = Vector3(0.117678, 0.796918, 3.15133),
				uv_scale = Vector3(6.55574, 5.03015, 0.150966)
			}
		},
		wpn_fps_ass_m14_b_legendary = {
			[Idstring("mtr_barrel"):key()] = {
				pattern_tweak = Vector3(1.20678, 0.184315, 1),
				uv_offset_rot = Vector3(0.0192806, 1.06157, 3.13635),
				pattern_pos = Vector3(-0.519483, -0.169974, 0),
				base_gradient = Idstring("units/payday2_cash/safes/lones/base_gradient/base_lones_009_c_df"),
				cubemap_pattern_control = Vector3(0, 0.001, 0),
				uv_scale = Vector3(11.4186, 10.179, 0),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_022_df"),
				pattern = Idstring("units/payday2_cash/safes/burn/pattern/burn_pattern_017_df")
			}
		},
		wpn_fps_ass_m14_b_standard = {
			[Idstring("mtr_barrel"):key()] = {
				pattern_tweak = Vector3(1.20678, 0.184315, 1),
				uv_offset_rot = Vector3(0.0192806, 1.06157, 3.13635),
				pattern_pos = Vector3(-0.519483, -0.169974, 0),
				base_gradient = Idstring("units/payday2_cash/safes/lones/base_gradient/base_lones_009_c_df"),
				cubemap_pattern_control = Vector3(0, 0.001, 0),
				uv_scale = Vector3(11.4186, 10.179, 0),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_022_df"),
				pattern = Idstring("units/payday2_cash/safes/burn/pattern/burn_pattern_017_df")
			}
		},
		wpn_fps_upg_o_acog = {
			[Idstring("mtr_acog"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/lones/base_gradient/base_lones_001_b_df"),
				uv_offset_rot = Vector3(0.150837, 1.04087, 0),
				uv_scale = Vector3(3.69526, 2.83711, 0.899833),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_023_df")
			}
		},
		wpn_fps_upg_o_m14_scopemount = {
			[Idstring("mtr_mount"):key()] = {
				uv_offset_rot = Vector3(0.008, 0.71214, 0),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_026_df"),
				uv_scale = Vector3(2.21734, 2.64641, 1)
			}
		},
		wpn_fps_ass_m14_body_upper_legendary = {
			[Idstring("base"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/lones/base_gradient/base_lones_001_b_df"),
				pattern_gradient = Idstring("units/payday2_cash/safes/buck/pattern_gradient/gradient_buck_003_df"),
				pattern_pos = Vector3(0.0729792, -0.0224179, 0),
				pattern_tweak = Vector3(0.872886, 0, 1),
				pattern = Idstring("units/payday2_cash/safes/burn/pattern/burn_pattern_017_df")
			}
		},
		wpn_fps_ass_m14_body_upper = {
			[Idstring("base"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/lones/base_gradient/base_lones_001_b_df"),
				pattern_gradient = Idstring("units/payday2_cash/safes/buck/pattern_gradient/gradient_buck_003_df"),
				pattern_pos = Vector3(0.0729792, -0.0224179, 0),
				pattern_tweak = Vector3(0.872886, 0, 1),
				pattern = Idstring("units/payday2_cash/safes/burn/pattern/burn_pattern_017_df")
			}
		},
		wpn_fps_ass_m14_m_standard = {
			[Idstring("mag"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_020_df"),
				uv_scale = Vector3(2.26502, 1.07315, 1),
				cubemap_pattern_control = Vector3(0, 0.804436, 0),
				uv_offset_rot = Vector3(0.0227409, 0.999251, 0.0194812)
			}
		},
		wpn_fps_ass_m14_body_lower_legendary = {
			[Idstring("lower1"):key()] = {
				pattern_gradient = Idstring("units/payday2_cash/safes/red/pattern_gradient/gradient_france_df"),
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_014_df")
			}
		},
		wpn_fps_ass_m14_body_lower = {
			[Idstring("lower1"):key()] = {
				pattern_gradient = Idstring("units/payday2_cash/safes/red/pattern_gradient/gradient_france_df"),
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_014_df")
			}
		},
		wpn_fps_upg_ns_ass_smg_medium = {
			[Idstring("medium"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/dallas/base_gradient/base_dallas_003_df"),
				uv_offset_rot = Vector3(0.002, 1.01741, 1.60788),
				uv_scale = Vector3(1.69292, 0.977799, 1),
				pattern_pos = Vector3(0.750298, 1.22728, 0),
				pattern_tweak = Vector3(0.3959, 0, 1),
				pattern = Idstring("units/payday2_cash/safes/burn/pattern/burn_pattern_018_df")
			}
		}
	}
	
	--Demon--
	self.weapon_skins.serbu_lones.default_blueprint = {
		"wpn_fps_shot_r870_body_standard",
		"wpn_fps_shot_r870_b_short",
		"wpn_fps_shot_r870_fg_small",
		"wpn_fps_shot_r870_s_nostock_vanilla",
		"wpn_fps_upg_serbu_legend",
		"wpn_fps_upg_ns_shot_shark",
		"wpn_fps_upg_a_custom_free",
		"wpn_fps_upg_o_reflex"
	}

	self.weapon_skins.serbu_lones.parts = {
		wpn_fps_shot_shorty_s_legendary = {
			[Idstring("mtr_grip"):key()] = {
				pattern_gradient = Idstring("units/payday2_cash/safes/lones/pattern_gradient/gradient_lones_005_df"),
				uv_offset_rot = Vector3(-0.224672, 0.998331, 6.27319),
				uv_scale = Vector3(10.6558, 1.69292, 0),
				pattern_tweak = Vector3(0, 0, 1),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_024_df")
			}
		},
		wpn_fps_shot_r870_s_nostock_vanilla = {
			[Idstring("mtr_grip"):key()] = {
				pattern_gradient = Idstring("units/payday2_cash/safes/lones/pattern_gradient/gradient_lones_005_df"),
				uv_offset_rot = Vector3(-0.224672, 0.998331, 6.27319),
				uv_scale = Vector3(10.6558, 1.69292, 0),
				pattern_tweak = Vector3(0, 0, 1),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_024_df")
			}
		},
		wpn_fps_shot_r870_s_folding = {
			[Idstring("mtr_grip"):key()] = {
				pattern_gradient = Idstring("units/payday2_cash/safes/lones/pattern_gradient/gradient_lones_005_df"),
				uv_offset_rot = Vector3(-0.224672, 0.998331, 6.27319),
				uv_scale = Vector3(10.6558, 1.69292, 0),
				pattern_tweak = Vector3(0, 0, 1),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_024_df")
			}
		},
		wpn_fps_shot_shorty_s_nostock_short = {
			[Idstring("mtr_grip"):key()] = {
				pattern_gradient = Idstring("units/payday2_cash/safes/lones/pattern_gradient/gradient_lones_005_df"),
				uv_offset_rot = Vector3(-0.224672, 0.998331, 6.27319),
				uv_scale = Vector3(10.6558, 1.69292, 0),
				pattern_tweak = Vector3(0, 0, 1),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_024_df")
			}
		},
		wpn_fps_shot_r870_s_solid = {
			[Idstring("mtr_grip"):key()] = {
				pattern_gradient = Idstring("units/payday2_cash/safes/lones/pattern_gradient/gradient_lones_005_df"),
				uv_offset_rot = Vector3(-0.224672, 0.998331, 6.27319),
				uv_scale = Vector3(10.6558, 1.69292, 0),
				pattern_tweak = Vector3(0, 0, 1),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_024_df")
			}
		},
		wpn_fps_shot_r870_s_solid_single = {
			[Idstring("mtr_grip"):key()] = {
				pattern_gradient = Idstring("units/payday2_cash/safes/lones/pattern_gradient/gradient_lones_005_df"),
				uv_offset_rot = Vector3(-0.224672, 0.998331, 6.27319),
				uv_scale = Vector3(10.6558, 1.69292, 0),
				pattern_tweak = Vector3(0, 0, 1),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_024_df")
			}
		},
		wpn_fps_shot_shorty_s_solid_short = {
			[Idstring("mtr_grip"):key()] = {
				pattern_gradient = Idstring("units/payday2_cash/safes/lones/pattern_gradient/gradient_lones_005_df"),
				uv_offset_rot = Vector3(-0.224672, 0.998331, 6.27319),
				uv_scale = Vector3(10.6558, 1.69292, 0),
				pattern_tweak = Vector3(0, 0, 1),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_024_df")
			}
		},
		wpn_fps_shot_shorty_b_legendary = {
			[Idstring("short_barrel"):key()] = {
				pattern_tweak = Vector3(8.12306, 0, 1),
				cubemap_pattern_control = Vector3(0.325066, 0.468161, 0),
				uv_scale = Vector3(5.45922, 5.45922, 1),
				uv_offset_rot = Vector3(2, 1.3513, 0),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_004_df")
			},
			[Idstring("mtr_comp"):key()] = {
				pattern_gradient = Idstring("units/payday2_cash/safes/lones/pattern_gradient/gradient_lones_005_df"),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_025_df"),
				uv_scale = Vector3(2.45571, 3.07549, 1),
				uv_offset_rot = Vector3(-0.0335768, 0.808537, 0),
				pattern_tweak = Vector3(1.58836, 0, 1),
				pattern = Idstring("units/payday2_cash/safes/cola/pattern/cola_pattern_005_df")
			}
		},
		wpn_fps_shot_r870_b_short = {
			[Idstring("short_barrel"):key()] = {
				pattern_tweak = Vector3(8.12306, 0, 1),
				cubemap_pattern_control = Vector3(0.325066, 0.468161, 0),
				uv_scale = Vector3(5.45922, 5.45922, 1),
				uv_offset_rot = Vector3(2, 1.3513, 0),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_004_df")
			},
			[Idstring("mtr_comp"):key()] = {
				pattern_gradient = Idstring("units/payday2_cash/safes/lones/pattern_gradient/gradient_lones_005_df"),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_025_df"),
				uv_scale = Vector3(2.45571, 3.07549, 1),
				uv_offset_rot = Vector3(-0.0335768, 0.808537, 0),
				pattern_tweak = Vector3(1.58836, 0, 1),
				pattern = Idstring("units/payday2_cash/safes/cola/pattern/cola_pattern_005_df")
			}
		},
		wpn_fps_shot_r870_body_standard = {
			[Idstring("receiver"):key()] = {
				pattern_tweak = Vector3(3.21011, 0, 1),
				cubemap_pattern_control = Vector3(1, 1, 0),
				uv_scale = Vector3(3.79061, 2.74176, 1),
				uv_offset_rot = Vector3(0.198995, 0.825235, 0),
				sticker = Idstring("units/payday2_cash/safes/lones/sticker/lones_sticker_019_df"),
				pattern = Idstring("units/payday2_cash/safes/cola/pattern/cola_pattern_005_df")
			}
		},
		wpn_fps_shot_shorty_fg_legendary = {
			[Idstring("mtr_fg"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_015_df")
			}
		},
		wpn_fps_shot_r870_fg_small = {
			[Idstring("mtr_fg"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/buck/base_gradient/base_buck_015_df")
			}
		},
		wpn_fps_upg_o_reflex = {
			[Idstring("reflex"):key()] = {
				pattern_tweak = Vector3(1.58836, 0, 1)
			}
		}
	}

	self.weapon_skins.ching_wwt = {
		name_id = "bm_wskn_ching_wwt",
		desc_id = "bm_wskn_ching_wwt_desc",
		weapon_id = "ching",
		rarity = "rare",
		bonus = "spread_p1",
		reserve_quality = true,
		texture_bundle_folder = "cash/safes/wwt",
		base_gradient = Idstring("units/payday2_cash/safes/wwt/base_gradient/base_wwt_008_df"),
		pattern_gradient = Idstring("units/payday2_cash/safes/ast/pattern_gradient/gradient_ast_001_df"),
		pattern = Idstring("units/payday2_cash/safes/smosh/pattern/smosh_pattern_021_b_df"),
		default_blueprint = {
			"wpn_fps_ass_ching_body_standard",
			"wpn_fps_ass_ching_bolt_standard",
			"wpn_fps_ass_ching_dh_standard",
			"wpn_fps_ass_ching_extra_swiwel",
			"wpn_fps_ass_ching_extra1_swiwel",
			"wpn_fps_ass_ching_m_standard",
			"wpn_fps_ass_ching_s_standard",
			"wpn_fps_ass_ching_s_pouch",
			"wpn_fps_upg_o_acog",
			"wpn_fps_upg_fl_ass_smg_sho_peqbox",
			"wpn_fps_ass_ching_b_standard",
			"wpn_fps_ass_ching_fg_railed"
		},
		parts = {
			wpn_fps_ass_ching_b_standard = {[Idstring("mat_ching_body"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/grunt/sticker/grunt_sticker_011_df"),
				uv_offset_rot = Vector3(0.406869, 1.37038, 1.60788),
				uv_scale = Vector3(3.59991, 1.64524, 1)
			}},
			wpn_fps_ass_ching_s_standard = {[Idstring("mat_ching_body"):key()] = {
				sticker = Idstring("units/payday2_cash/safes/wwt/sticker/wwt_sticker_004_b_df"),
				uv_offset_rot = Vector3(-0.035, 0.881156, 0),
				uv_scale = Vector3(1.02547, 1.40687, 1)
			}},
			wpn_fps_ass_ching_fg_standard = {[Idstring("mat_ching_body"):key()] = {pattern = Idstring("units/payday2_cash/safes/default/pattern/pattern_default_df")}},
			wpn_fps_ass_ching_body_standard = {[Idstring("mat_ching_receiver"):key()] = {
				base_gradient = Idstring("units/payday2_cash/safes/wac/base_gradient/base_wac_006_b_df"),
				uv_offset_rot = Vector3(0, 0, 3.09139),
				uv_scale = Vector3(1, 1, 0.215359),
				pattern = Idstring("units/payday2_cash/safes/default/pattern/pattern_default_df")
			}},
			wpn_fps_ass_ching_bolt_standard = {[Idstring("mat_ching_body"):key()] = {pattern = Idstring("units/payday2_cash/safes/default/pattern/pattern_default_df")}},
			wpn_fps_ass_ching_s_pouch = {
				[Idstring("mtr_pouch"):key()] = {
					base_gradient = Idstring("units/payday2_cash/safes/wac/base_gradient/base_wac_018_df"),
					sticker = Idstring("units/payday2_cash/safes/wwt/sticker/wwt_sticker_004_df"),
					uv_scale = Vector3(1.21217, 1.1685, 1),
					uv_offset_rot = Vector3(0.330551, 1.07465, 4.72475),
					pattern = Idstring("units/payday2_cash/safes/default/pattern/pattern_default_df")
				},
				[Idstring("mat_ching_body"):key()] = {
					uv_offset_rot = Vector3(-0.0381166, 0.880473, 0),
					sticker = Idstring("units/payday2_cash/safes/wwt/sticker/wwt_sticker_004_b_df"),
					uv_scale = Vector3(1.01782, 1.4152, 1)
				}
			},
			wpn_fps_upg_o_acog = {[Idstring("mtr_acog"):key()] = {base_gradient = Idstring("units/payday2_cash/safes/wwt/base_gradient/base_wwt_006_df")}}
		},
		types = {sight = {
			pattern_gradient = Idstring("units/payday2_cash/safes/default/pattern_gradient/gradient_default_df"),
			base_gradient = Idstring("units/payday2_cash/safes/cola/base_gradient/base_cola_005_df"),
			pattern = Idstring("units/payday2_cash/safes/default/pattern/pattern_default_df")
		}}
	}

	--Croupier blueprint/sticker fix
	self.weapon_skins.m16_ait.default_blueprint = {
		"wpn_fps_m4_uupg_draghandle",
		"wpn_fps_amcar_bolt_standard",
		"wpn_fps_upg_fl_ass_smg_sho_peqbox",
		"wpn_fps_upg_ass_m4_lower_reciever_core",
		"wpn_fps_upg_ass_m4_upper_reciever_core",
		"wpn_fps_m4_uupg_m_std_vanilla",
		"wpn_fps_snp_tti_s_vltor",
		"wpn_fps_upg_m4_g_mgrip",
		"wpn_fps_m16_fg_standard",
		"wpn_fps_m4_uupg_b_medium_vanilla",
		"wpn_fps_upg_ass_ns_battle",
		"wpn_fps_upg_o_cmore"
	}

	self.weapon_skins.m16_ait.parts.wpn_fps_m4_uupg_m_std_vanilla = {
		[Idstring("m4_mag_std"):key()] = {
			pattern = "units/payday2_cash/safes/ait/pattern/ait_pattern_024_g_df",
			pattern_gradient = "units/payday2_cash/safes/ait/pattern_gradient/gradient_ait_024_b_df"
		}
	}	
end

local melee_weapons_old = BlackMarketTweakData._init_melee_weapons
function BlackMarketTweakData:_init_melee_weapons(...)
   	melee_weapons_old(self, ...)

	--Weapon butt--
	self.melee_weapons.weapon.damage_type = "bludgeoning"
	self.melee_weapons.weapon.stats.min_damage = 2
	self.melee_weapons.weapon.stats.max_damage = 2
	self.melee_weapons.weapon.stats.range = 150
	self.melee_weapons.weapon.expire_t = 0.85
	self.melee_weapons.weapon.repeat_expire_t = 0.8

	--Fists
	self.melee_weapons.fists.damage_type = "bludgeoning"
	self.melee_weapons.fists.stats.min_damage = 1.2
	self.melee_weapons.fists.stats.max_damage = 2
	self.melee_weapons.fists.stats.range = 150
	self.melee_weapons.fists.repeat_expire_t = 0.4
	self.melee_weapons.fists.melee_damage_delay = 0.2
	self.melee_weapons.fists.expire_t = 1.1

	--Brass Knuckles--
	self.melee_weapons.brass_knuckles.damage_type = "bludgeoning"
	self.melee_weapons.brass_knuckles.stats.min_damage = 1.6
	self.melee_weapons.brass_knuckles.stats.max_damage = 2.4
	self.melee_weapons.brass_knuckles.stats.range = 160
	self.melee_weapons.brass_knuckles.repeat_expire_t = 0.55
	self.melee_weapons.brass_knuckles.melee_damage_delay = 0.2
	self.melee_weapons.brass_knuckles.expire_t = 1.1

	--Ursa Tanto Knife--
	self.melee_weapons.kabartanto.damage_type = "slashing"
	self.melee_weapons.kabartanto.stats.min_damage = 2.4
	self.melee_weapons.kabartanto.stats.max_damage = 3
	self.melee_weapons.kabartanto.stats.range = 165
	self.melee_weapons.kabartanto.repeat_expire_t = 0.5
	self.melee_weapons.kabartanto.expire_t = 1.1
	self.melee_weapons.kabartanto.melee_damage_delay = 0.1
	self.melee_weapons.kabartanto.anim_global_param = "melee_knife"
	self.melee_weapons.kabartanto.anim_attack_vars = {
		"var1",
		"var2",
		"var3",
		"var4"
	}

	--Nova's Shank--
	self.melee_weapons.toothbrush.damage_type = "slashing"
	self.melee_weapons.toothbrush.stats.min_damage = 2
	self.melee_weapons.toothbrush.stats.max_damage = 2.4
	self.melee_weapons.toothbrush.stats.range = 150
	self.melee_weapons.toothbrush.repeat_expire_t = 0.3
	self.melee_weapons.toothbrush.expire_t = 1.1
	self.melee_weapons.toothbrush.melee_damage_delay = 0.1

	--Money Bundle--
	self.melee_weapons.moneybundle.damage_type = "bludgeoning"
	self.melee_weapons.moneybundle.stats.min_damage = 1.2
	self.melee_weapons.moneybundle.stats.max_damage = 2
	self.melee_weapons.moneybundle.repeat_expire_t = 0.45
	self.melee_weapons.moneybundle.stats.range = 160
	self.melee_weapons.moneybundle.melee_damage_delay = 0.2
	self.melee_weapons.moneybundle.expire_t = 1.1

	--Psycho Knife--
	self.melee_weapons.chef.damage_type = "slashing"
	self.melee_weapons.chef.info_id = "bm_melee_chef_info"
	self.melee_weapons.chef.stats.min_damage = 0.65
	self.melee_weapons.chef.stats.max_damage = 33.3
	self.melee_weapons.chef.stats.range = 170
	self.melee_weapons.chef.repeat_expire_t = 0.65
	self.melee_weapons.chef.melee_damage_delay = 0.1
	self.melee_weapons.chef.expire_t = 1.1
	self.melee_weapons.chef.special_weapon = "panic"

	--Lucille Baseball Bat--
	self.melee_weapons.barbedwire.damage_type = "bludgeoning"
	self.melee_weapons.barbedwire.anim_global_param = "melee_baseballbat"
	self.melee_weapons.barbedwire.type = "axe"
	self.melee_weapons.barbedwire.dot_data = {
		type = "bleed",
		custom_data = {
			dot_damage = 1,
			dot_length = 2.1,
			hurt_animation_chance = 0.0
		}
	}
	self.melee_weapons.barbedwire.info_id = "bm_melee_barbedwire_info"
	self.melee_weapons.barbedwire.align_objects = {"a_weapon_right"}
	self.melee_weapons.barbedwire.anim_attack_vars = {"var1","var2"}
	self.melee_weapons.barbedwire.stats.min_damage = 2.4
	self.melee_weapons.barbedwire.stats.max_damage = 5
	self.melee_weapons.barbedwire.stats.range = 210
	self.melee_weapons.barbedwire.repeat_expire_t = 1.05
	self.melee_weapons.barbedwire.expire_t = 1.2
	self.melee_weapons.barbedwire.melee_damage_delay = 0.2

	--Rivertown Glen Bottle --
	self.melee_weapons.whiskey.damage_type = "bludgeoning"
	self.melee_weapons.whiskey.stats.min_damage = 2
	self.melee_weapons.whiskey.stats.max_damage = 3
	self.melee_weapons.whiskey.stats.range = 185
	self.melee_weapons.whiskey.repeat_expire_t = 0.8
	self.melee_weapons.whiskey.melee_damage_delay = 0.2
	self.melee_weapons.whiskey.expire_t = 1.2

	--Bolt Cutters--
	self.melee_weapons.cutters.damage_type = "bludgeoning"
	self.melee_weapons.cutters.stats.min_damage = 2.4
	self.melee_weapons.cutters.stats.max_damage = 5
	self.melee_weapons.cutters.stats.range = 200
	self.melee_weapons.cutters.repeat_expire_t = 1
	self.melee_weapons.cutters.melee_damage_delay = 0.2
	self.melee_weapons.cutters.expire_t = 1.2

	--Boxcutters--
	self.melee_weapons.boxcutter.damage_type = "slashing"
	self.melee_weapons.boxcutter.stats.weapon_type = "sharp"
	self.melee_weapons.boxcutter.stats.min_damage = 2
	self.melee_weapons.boxcutter.stats.max_damage = 2.4
	self.melee_weapons.boxcutter.stats.range = 160
	self.melee_weapons.boxcutter.repeat_expire_t = 0.35
	self.melee_weapons.boxcutter.melee_damage_delay = 0.1
	
	--Boxing Gloves--
	self.melee_weapons.boxing_gloves.damage_type = "bludgeoning"
	self.melee_weapons.boxing_gloves.info_id = "bm_melee_boxing_gloves_info"
	self.melee_weapons.boxing_gloves.stats.min_damage = 1
	self.melee_weapons.boxing_gloves.stats.max_damage = 1.6
	self.melee_weapons.boxing_gloves.stats.range = 170
	self.melee_weapons.boxing_gloves.repeat_expire_t = 0.6
	self.melee_weapons.boxing_gloves.melee_damage_delay = 0.2
	self.melee_weapons.boxing_gloves.expire_t = 1.1
	self.melee_weapons.boxing_gloves.special_weapon = "stamina_restore"

	--Alpha Mauler--
	self.melee_weapons.alien_maul.damage_type = "bludgeoning"
	self.melee_weapons.alien_maul.anim_global_param = "melee_baseballbat"
	self.melee_weapons.alien_maul.type = "axe"
	self.melee_weapons.alien_maul.align_objects = {
		"a_weapon_right"
	}
	self.melee_weapons.alien_maul.stats.min_damage = 2.4
	self.melee_weapons.alien_maul.stats.max_damage = 5
	self.melee_weapons.alien_maul.stats.range = 220
	self.melee_weapons.alien_maul.repeat_expire_t = 1.1
	self.melee_weapons.alien_maul.melee_damage_delay = 0.2
	self.melee_weapons.alien_maul.expire_t = 1.2

	--URSA Knife--
	self.melee_weapons.kabar.damage_type = "slashing"
	self.melee_weapons.kabar.stats.min_damage = 2.4
	self.melee_weapons.kabar.stats.max_damage = 3
	self.melee_weapons.kabar.stats.range = 165
	self.melee_weapons.kabar.anim_global_param = "melee_knife"
	self.melee_weapons.kabar.anim_attack_vars = {
		"var1",
		"var2",
		"var3",
		"var4"
	}
	self.melee_weapons.kabar.repeat_expire_t = 0.5
	self.melee_weapons.kabar.expire_t = 1.1
	self.melee_weapons.kabar.melee_damage_delay = 0.1

	--Krieger Blade--
	self.melee_weapons.kampfmesser.damage_type = "slashing"
	self.melee_weapons.kampfmesser.stats.min_damage = 2.4
	self.melee_weapons.kampfmesser.stats.max_damage = 3
	self.melee_weapons.kampfmesser.stats.range = 175
	self.melee_weapons.kampfmesser.anim_global_param = "melee_knife2"
	self.melee_weapons.kampfmesser.repeat_expire_t = 0.55
	self.melee_weapons.kampfmesser.melee_damage_delay = 0.1
	self.melee_weapons.kampfmesser.expire_t = 1.1

	--Berger Combat Knife--
	self.melee_weapons.gerber.damage_type = "slashing"
	self.melee_weapons.gerber.anim_global_param = "melee_stab"
	self.melee_weapons.gerber.align_objects = {
		"a_weapon_right"
	}
	self.melee_weapons.gerber.repeat_expire_t = 0.4
	self.melee_weapons.gerber.stats.min_damage = 2
	self.melee_weapons.gerber.stats.max_damage = 2.4
	self.melee_weapons.gerber.stats.range = 170
	self.melee_weapons.gerber.expire_t = 1.1
	self.melee_weapons.gerber.melee_damage_delay = 0.1	

	--Trautman Knife--
	self.melee_weapons.rambo.damage_type = "slashing"
	self.melee_weapons.rambo.stats.min_damage = 3
	self.melee_weapons.rambo.stats.max_damage = 5
	self.melee_weapons.rambo.anim_global_param = "melee_knife"
	self.melee_weapons.rambo.repeat_expire_t = 0.7
	self.melee_weapons.rambo.expire_t = 1.1
	self.melee_weapons.rambo.stats.range = 180
	self.melee_weapons.rambo.melee_damage_delay = 0.1

	--K.L.A.S. Shovel--
	self.melee_weapons.shovel.damage_type = "bludgeoning"
	self.melee_weapons.shovel.stats.min_damage = 2
	self.melee_weapons.shovel.stats.max_damage = 3
	self.melee_weapons.shovel.stats.range = 195
	self.melee_weapons.shovel.repeat_expire_t = 0.85
	self.melee_weapons.shovel.attack_allowed_expire_t = 0.1
	self.melee_weapons.shovel.melee_damage_delay = 0.2
	self.melee_weapons.shovel.expire_t = 1.2

	--Telescopic Baton--
	self.melee_weapons.baton.damage_type = "bludgeoning"
	self.melee_weapons.baton.stats.min_damage = 1.6
	self.melee_weapons.baton.stats.max_damage = 2.4
	self.melee_weapons.baton.stats.range = 190
	self.melee_weapons.baton.repeat_expire_t = 0.7
	self.melee_weapons.baton.melee_damage_delay = 0.2
	self.melee_weapons.baton.expire_t = 1.1

	--Survival Tomahawk--
	self.melee_weapons.tomahawk.damage_type = "piercing"
	self.melee_weapons.tomahawk.stats.min_damage = 2
	self.melee_weapons.tomahawk.stats.max_damage = 5
	self.melee_weapons.tomahawk.stats.range = 200
	self.melee_weapons.tomahawk.repeat_expire_t = 0.8
	self.melee_weapons.tomahawk.attack_allowed_expire_t = 0.1
	self.melee_weapons.tomahawk.expire_t = 1.1
	self.melee_weapons.tomahawk.melee_damage_delay = 0.1

	--Utility Machete--
	self.melee_weapons.becker.damage_type = "slashing"
	self.melee_weapons.becker.anim_global_param = "melee_axe"
	self.melee_weapons.becker.stats.min_damage = 2.4
	self.melee_weapons.becker.stats.max_damage = 3
	self.melee_weapons.becker.stats.range = 185
	self.melee_weapons.becker.repeat_expire_t = 0.6
	self.melee_weapons.becker.melee_damage_delay = 0.1
	self.melee_weapons.becker.expire_t = 1.1
	self.melee_weapons.becker.align_objects = {"a_weapon_right"}
	self.melee_weapons.becker.anim_attack_vars = {"var1","var3","var4"}

	--Bayonet Knife--
	self.melee_weapons.bayonet.damage_type = "slashing"
	self.melee_weapons.bayonet.anim_global_param = "melee_stab"
	self.melee_weapons.bayonet.align_objects = {"a_weapon_right"}
	self.melee_weapons.bayonet.repeat_expire_t = 0.4
	self.melee_weapons.bayonet.stats.min_damage = 2
	self.melee_weapons.bayonet.stats.max_damage = 2.4
	self.melee_weapons.bayonet.stats.range = 170
	self.melee_weapons.bayonet.expire_t = 1.1

	--Compact Hatchet--
	self.melee_weapons.bullseye.damage_type = "piercing"
	self.melee_weapons.bullseye.stats.min_damage = 2
	self.melee_weapons.bullseye.stats.max_damage = 5
	self.melee_weapons.bullseye.stats.range = 180
	self.melee_weapons.bullseye.repeat_expire_t = 0.7
	self.melee_weapons.bullseye.expire_t = 1.1

	--X-46 Knife--
	self.melee_weapons.x46.damage_type = "slashing"
	self.melee_weapons.x46.anim_global_param = "melee_knife2"
	self.melee_weapons.x46.stats.min_damage = 2.4
	self.melee_weapons.x46.stats.max_damage = 3
	self.melee_weapons.x46.stats.range = 175
	self.melee_weapons.x46.repeat_expire_t = 0.55
	self.melee_weapons.x46.expire_t = 1.1	

	--Ding Dong Breaching Tool--
	self.melee_weapons.dingdong.damage_type = "bludgeoning"
	self.melee_weapons.dingdong.stats.min_damage = 2.4
	self.melee_weapons.dingdong.stats.max_damage = 5
	self.melee_weapons.dingdong.stats.range = 220
	self.melee_weapons.dingdong.repeat_expire_t = 1.1
	self.melee_weapons.dingdong.melee_damage_delay = 0.2
	self.melee_weapons.dingdong.expire_t = 1.2

	--Baseball Bat--
	self.melee_weapons.baseballbat.damage_type = "bludgeoning"
	self.melee_weapons.baseballbat.stats.min_damage = 2.4
	self.melee_weapons.baseballbat.stats.max_damage = 5
	self.melee_weapons.baseballbat.stats.range = 210
	self.melee_weapons.baseballbat.repeat_expire_t = 1.05
	self.melee_weapons.baseballbat.melee_damage_delay = 0.2
	self.melee_weapons.baseballbat.expire_t = 1.2

	--Cleaver--
	self.melee_weapons.cleaver.damage_type = "slashing"
	self.melee_weapons.cleaver.info_id = "bm_melee_cleaver_info"
	self.melee_weapons.cleaver.anim_speed_mult = 1.25
	self.melee_weapons.cleaver.stats.min_damage = 3
	self.melee_weapons.cleaver.stats.max_damage = 8
	self.melee_weapons.cleaver.repeat_expire_t = 0.5
	self.melee_weapons.cleaver.stats.range = 185
	self.melee_weapons.cleaver.melee_damage_delay = 0.1
	self.melee_weapons.cleaver.expire_t = 1.1
	self.melee_weapons.cleaver.headshot_damage_multiplier = 0.5

	--Machete Knife--
	self.melee_weapons.machete.damage_type = "slashing"
	self.melee_weapons.machete.stats.min_damage = 3
	self.melee_weapons.machete.stats.max_damage = 5
	self.melee_weapons.machete.stats.range = 190
	self.melee_weapons.machete.repeat_expire_t = 0.75
	self.melee_weapons.machete.melee_damage_delay = 0.1
	self.melee_weapons.machete.expire_t = 1.1	

	--Fire Axe--
	self.melee_weapons.fireaxe.damage_type = "piercing"
	self.melee_weapons.fireaxe.anim_global_param = "melee_baseballbat"
	self.melee_weapons.fireaxe.align_objects = {
		"a_weapon_right"
	}
	self.melee_weapons.fireaxe.anim_speed_mult = 1.5
	self.melee_weapons.fireaxe.stats.min_damage = 2.4
	self.melee_weapons.fireaxe.stats.max_damage = 8
	self.melee_weapons.fireaxe.stats.range = 205
	self.melee_weapons.fireaxe.repeat_expire_t = 0.9
	self.melee_weapons.fireaxe.melee_damage_delay = 0.1
	self.melee_weapons.fireaxe.expire_t = 1.2

	--50 Blessings Briefcase --
	self.melee_weapons.briefcase.damage_type = "bludgeoning"
	self.melee_weapons.briefcase.anim_speed_mult = 1.4
	self.melee_weapons.briefcase.stats.min_damage = 2
	self.melee_weapons.briefcase.stats.max_damage = 3
	self.melee_weapons.briefcase.stats.range = 175
	self.melee_weapons.briefcase.repeat_expire_t = 0.75
	self.melee_weapons.briefcase.melee_damage_delay = 0.2
	self.melee_weapons.briefcase.expire_t = 1.2

	--Swagger Stick--
	self.melee_weapons.swagger.damage_type = "bludgeoning"
	self.melee_weapons.swagger.stats.min_damage = 1.6
	self.melee_weapons.swagger.stats.max_damage = 2.4
	self.melee_weapons.swagger.stats.range = 180
	self.melee_weapons.swagger.repeat_expire_t = 0.6
	self.melee_weapons.swagger.melee_damage_delay = 0.2
	self.melee_weapons.swagger.expire_t = 1.1

	--Potato Masher--
	self.melee_weapons.model24.damage_type = "bludgeoning"
	self.melee_weapons.model24.stats.min_damage = 2
	self.melee_weapons.model24.stats.max_damage = 3
	self.melee_weapons.model24.stats.range = 165
	self.melee_weapons.model24.repeat_expire_t = 0.7
	self.melee_weapons.model24.melee_damage_delay = 0.2
	self.melee_weapons.model24.expire_t = 1.2

	--Trench Knife--
	self.melee_weapons.fairbair.damage_type = "slashing"
	self.melee_weapons.fairbair.anim_global_param = "melee_stab"
	self.melee_weapons.fairbair.align_objects = {
		"a_weapon_right"
	}	
	self.melee_weapons.fairbair.stats.min_damage = 2
	self.melee_weapons.fairbair.stats.max_damage = 2.4
	self.melee_weapons.fairbair.stats.range = 160
	self.melee_weapons.fairbair.repeat_expire_t = 0.35
	self.melee_weapons.fairbair.melee_damage_delay = 0.1
	self.melee_weapons.fairbair.expire_t = 1.2

	--Freedom Spear--
	self.melee_weapons.freedom.damage_type = "piercing"
	self.melee_weapons.freedom.anim_global_param = "melee_freedom"
	self.melee_weapons.freedom.align_objects = {"a_weapon_left"}
	self.melee_weapons.freedom.anim_attack_vars = {"var1","var2","var3","var4"}
	self.melee_weapons.freedom.anim_speed_mult = 1.75
	self.melee_weapons.freedom.stats.min_damage = 2.4
	self.melee_weapons.freedom.stats.max_damage = 8
	self.melee_weapons.freedom.stats.range = 225
	self.melee_weapons.freedom.repeat_expire_t = 1.1
	self.melee_weapons.freedom.melee_damage_delay = 0.1
	self.melee_weapons.freedom.expire_t = 1.2

	--Carpenter's Delight--
	self.melee_weapons.hammer.damage_type = "bludgeoning"
	self.melee_weapons.hammer.stats.min_damage = 2
	self.melee_weapons.hammer.stats.max_damage = 3
	self.melee_weapons.hammer.stats.range = 165
	self.melee_weapons.hammer.repeat_expire_t = 0.7
	self.melee_weapons.hammer.melee_damage_delay = 0.2
	self.melee_weapons.hammer.expire_t = 1.2

	--Clover's Shillelagh--	
	self.melee_weapons.shillelagh.damage_type = "bludgeoning"
	self.melee_weapons.shillelagh.stats.min_damage = 2
	self.melee_weapons.shillelagh.stats.max_damage = 3
	self.melee_weapons.shillelagh.stats.range = 205
	self.melee_weapons.shillelagh.repeat_expire_t = 0.9
	self.melee_weapons.shillelagh.attack_allowed_expire_t = 0.1
	self.melee_weapons.shillelagh.melee_damage_delay = 0.2
	self.melee_weapons.shillelagh.expire_t = 1.2	

	--Dragan's Cleaver--
	self.melee_weapons.meat_cleaver.damage_type = "slashing"
	self.melee_weapons.meat_cleaver.info_id = "bm_melee_cleaver_info"
	self.melee_weapons.meat_cleaver.anim_speed_mult = 1.25
	self.melee_weapons.meat_cleaver.stats.min_damage = 6
	self.melee_weapons.meat_cleaver.stats.max_damage = 10
	self.melee_weapons.meat_cleaver.stats.range = 190
	self.melee_weapons.meat_cleaver.repeat_expire_t = 0.6
	self.melee_weapons.meat_cleaver.melee_damage_delay = 0.1
	self.melee_weapons.meat_cleaver.expire_t = 1.1
	self.melee_weapons.meat_cleaver.headshot_damage_multiplier = 0.5

	--The Motherforker--
	self.melee_weapons.fork.damage_type = "piercing"	
	self.melee_weapons.fork.anim_global_param = "melee_stab"
	self.melee_weapons.fork.align_objects = {"a_weapon_right"}
	self.melee_weapons.fork.repeat_expire_t = 0.45
	self.melee_weapons.fork.stats.min_damage = 1.6
	self.melee_weapons.fork.stats.max_damage = 3
	self.melee_weapons.fork.stats.range = 170
	self.melee_weapons.fork.expire_t = 1.1	

	--Spatula--	
	self.melee_weapons.spatula.damage_type = "bludgeoning"
	self.melee_weapons.spatula.stats.min_damage = 1.2
	self.melee_weapons.spatula.stats.max_damage = 2
	self.melee_weapons.spatula.repeat_expire_t = 0.5
	self.melee_weapons.spatula.stats.range = 170
	self.melee_weapons.spatula.melee_damage_delay = 0.2
	self.melee_weapons.spatula.expire_t = 1.1	

	--Poker--	
	self.melee_weapons.poker.damage_type = "piercing"
	self.melee_weapons.poker.anim_global_param = "melee_pitchfork"
	self.melee_weapons.poker.align_objects = {"a_weapon_left"}
	self.melee_weapons.poker.anim_attack_vars = {"var1","var2","var3","var4"}
	self.melee_weapons.poker.stats.min_damage = 2.4
	self.melee_weapons.poker.stats.max_damage = 8
	self.melee_weapons.poker.stats.range = 195
	self.melee_weapons.poker.repeat_expire_t = 0.85
	self.melee_weapons.poker.melee_damage_delay = 0.1
	self.melee_weapons.poker.expire_t = 1.2	

	--Tenderizer--	
	self.melee_weapons.tenderizer.damage_type = "bludgeoning"
	self.melee_weapons.tenderizer.stats.min_damage = 2
	self.melee_weapons.tenderizer.stats.max_damage = 3
	self.melee_weapons.tenderizer.stats.range = 185
	self.melee_weapons.tenderizer.repeat_expire_t = 0.8
	self.melee_weapons.tenderizer.melee_damage_delay = 0.2
	self.melee_weapons.tenderizer.expire_t = 1.2	

	--You're Mine--	
	self.melee_weapons.branding_iron.info_id = "bm_melee_branding_iron_info"
	self.melee_weapons.branding_iron.anim_global_param = "melee_pitchfork"
	self.melee_weapons.branding_iron.align_objects = {"a_weapon_left"}
	self.melee_weapons.branding_iron.anim_attack_vars = {"var1","var2","var3","var4"}
	self.melee_weapons.branding_iron.damage_type = "piercing"
	self.melee_weapons.branding_iron.stats.min_damage = 2.4
	self.melee_weapons.branding_iron.stats.max_damage = 8
	self.melee_weapons.branding_iron.stats.range = 190
	self.melee_weapons.branding_iron.repeat_expire_t = 0.9
	self.melee_weapons.branding_iron.melee_damage_delay = 0.2
	self.melee_weapons.branding_iron.expire_t = 1.2	
	self.melee_weapons.branding_iron.fire_dot_data = {
		dot_trigger_chance = 25,
		dot_damage = 1,
		dot_length = 3.1,
		dot_trigger_max_distance = 3000,
		dot_tick_period = 0.5
	}

	--Scalper Tomahawk--
	self.melee_weapons.scalper.damage_type = "piercing" 
	self.melee_weapons.scalper.stats.min_damage = 2
	self.melee_weapons.scalper.stats.max_damage = 5
	self.melee_weapons.scalper.stats.range = 200
	self.melee_weapons.scalper.repeat_expire_t = 0.8
	self.melee_weapons.scalper.attack_allowed_expire_t = 0.1
	self.melee_weapons.scalper.expire_t = 1.1
	self.melee_weapons.scalper.melee_damage_delay = 0.1	

	--Arkansas Toothpick--	
	self.melee_weapons.bowie.damage_type = "slashing"
	self.melee_weapons.bowie.anim_global_param = "melee_knife2"
	self.melee_weapons.bowie.stats.min_damage = 2.4
	self.melee_weapons.bowie.stats.max_damage = 3
	self.melee_weapons.bowie.stats.range = 175
	self.melee_weapons.bowie.repeat_expire_t = 0.55
	self.melee_weapons.bowie.expire_t = 1.1		

	--Gold Fever--
	self.melee_weapons.mining_pick.damage_type = "piercing"
	self.melee_weapons.mining_pick.make_decal = true
	self.melee_weapons.mining_pick.make_effect = true
	self.melee_weapons.mining_pick.stats.min_damage = 2.4
	self.melee_weapons.mining_pick.stats.max_damage = 8
	self.melee_weapons.mining_pick.stats.range = 225
	self.melee_weapons.mining_pick.repeat_expire_t = 1.1
	self.melee_weapons.mining_pick.melee_damage_delay = 0.15
	self.melee_weapons.mining_pick.expire_t = 1.2

	--Microphone--	
	self.melee_weapons.microphone.damage_type = "bludgeoning"
	self.melee_weapons.microphone.stats.min_damage = 1.2
	self.melee_weapons.microphone.stats.max_damage = 2
	self.melee_weapons.microphone.repeat_expire_t = 0.45
	self.melee_weapons.microphone.stats.range = 160
	self.melee_weapons.microphone.melee_damage_delay = 0.2
	self.melee_weapons.microphone.expire_t = 1.1	

	--Classic Baton--	
	self.melee_weapons.oldbaton.damage_type = "bludgeoning"
	self.melee_weapons.oldbaton.stats.min_damage = 1.6
	self.melee_weapons.oldbaton.stats.max_damage = 2.4
	self.melee_weapons.oldbaton.stats.range = 190
	self.melee_weapons.oldbaton.repeat_expire_t = 0.7
	self.melee_weapons.oldbaton.melee_damage_delay = 0.2
	self.melee_weapons.oldbaton.expire_t = 1.1	

	--Metal Detector--
	self.melee_weapons.detector.damage_type = "bludgeoning"
	self.melee_weapons.detector.stats.min_damage = 2
	self.melee_weapons.detector.stats.max_damage = 3
	self.melee_weapons.detector.stats.range = 205
	self.melee_weapons.detector.repeat_expire_t = 0.9
	self.melee_weapons.detector.attack_allowed_expire_t = 0.1
	self.melee_weapons.detector.melee_damage_delay = 0.2
	self.melee_weapons.detector.expire_t = 1.2	

	--Microphone Stand--
	self.melee_weapons.micstand.damage_type = "bludgeoning"
	self.melee_weapons.micstand.anim_global_param = "melee_baseballbat"
	self.melee_weapons.micstand.align_objects = {
		"a_weapon_right"
	}	
	self.melee_weapons.micstand.stats.min_damage = 2.4
	self.melee_weapons.micstand.stats.max_damage = 5
	self.melee_weapons.micstand.stats.range = 190
	self.melee_weapons.micstand.repeat_expire_t = 0.9
	self.melee_weapons.micstand.melee_damage_delay = 0.2
	self.melee_weapons.micstand.expire_t = 1.2	

	--Hockey Stick--
	self.melee_weapons.hockey.damage_type = "bludgeoning"
	self.melee_weapons.hockey.anim_global_param = "melee_baseballbat"
	self.melee_weapons.hockey.align_objects = {
		"a_weapon_right"
	}		
	self.melee_weapons.hockey.stats.min_damage = 2.4
	self.melee_weapons.hockey.stats.max_damage = 5
	self.melee_weapons.hockey.stats.range = 200
	self.melee_weapons.hockey.repeat_expire_t = 1
	self.melee_weapons.hockey.melee_damage_delay = 0.2
	self.melee_weapons.hockey.expire_t = 1.2

	--Jackpot--
	self.melee_weapons.slot_lever.damage_type = "bludgeoning"
	self.melee_weapons.slot_lever.info_id = "bm_melee_slot_lever_info"
	self.melee_weapons.slot_lever.special_weapon = "hyper_crit"
	self.melee_weapons.slot_lever.anim_speed_mult = 0.9
	self.melee_weapons.slot_lever.stats.min_damage = 1.6
	self.melee_weapons.slot_lever.stats.max_damage = 2.4
	self.melee_weapons.slot_lever.stats.range = 180
	self.melee_weapons.slot_lever.repeat_expire_t = 0.65
	self.melee_weapons.slot_lever.melee_damage_delay = 0.22
	self.melee_weapons.slot_lever.expire_t = 1.15

	--Croupier Rake--
	self.melee_weapons.croupier_rake.damage_type = "bludgeoning"
	self.melee_weapons.croupier_rake.stats.min_damage = 1.6
	self.melee_weapons.croupier_rake.stats.max_damage = 2.4
	self.melee_weapons.croupier_rake.stats.range = 190
	self.melee_weapons.croupier_rake.repeat_expire_t = 0.7
	self.melee_weapons.croupier_rake.melee_damage_delay = 0.2
	self.melee_weapons.croupier_rake.expire_t = 1.1

	--Switchblade--
	self.melee_weapons.switchblade.damage_type = "slashing"
	self.melee_weapons.switchblade.info_id = "bm_melee_switchblade_info"	
	self.melee_weapons.switchblade.anim_global_param = "melee_boxcutter"
	self.melee_weapons.switchblade.align_objects = {
		"a_weapon_right"
	}	
	self.melee_weapons.switchblade.anim_attack_vars = {
			"var1",
			"var2",
			"var3",
			"var4"
	}
	self.melee_weapons.switchblade.repeat_expire_t = 0.5
	self.melee_weapons.switchblade.stats.min_damage = 1.6
	self.melee_weapons.switchblade.stats.max_damage = 2.4
	self.melee_weapons.switchblade.stats.range = 170
	self.melee_weapons.switchblade.expire_t = 1.2
	self.melee_weapons.switchblade.backstab_damage_multiplier = 2

	--Buzzer--
	self.melee_weapons.taser.damage_type = "tase"
	self.melee_weapons.taser.stats.min_damage = 1
	self.melee_weapons.taser.stats.max_damage = 1.2
	self.melee_weapons.taser.stats.range = 160
	self.melee_weapons.taser.repeat_expire_t = 0.6
	self.melee_weapons.taser.melee_damage_delay = 0.2
	
	--Empty Palm Kata--	
	self.melee_weapons.fight.damage_type = "bludgeoning"
	self.melee_weapons.fight.stats.min_damage = 1
	self.melee_weapons.fight.stats.max_damage = 1.6
	self.melee_weapons.fight.stats.range = 150
	self.melee_weapons.fight.repeat_expire_t = 0.4
	self.melee_weapons.fight.melee_damage_delay = 0.2
	self.melee_weapons.fight.expire_t = 1.1
	self.melee_weapons.fight.counter_damage = 2
	self.melee_weapons.fight.info_id = "bm_melee_fight_info"
	
	--Okinawan Style Sai--
	self.melee_weapons.twins.damage_type = "piercing"	
	self.melee_weapons.twins.stats.min_damage = 2
	self.melee_weapons.twins.stats.max_damage = 5
	self.melee_weapons.twins.stats.range = 170
	self.melee_weapons.twins.repeat_expire_t = 0.65
	self.melee_weapons.twins.melee_damage_delay = 0.1
	self.melee_weapons.twins.expire_t = 1.1	

	--Talons--
	self.melee_weapons.tiger.damage_type = "multi_slash"
	self.melee_weapons.tiger.stats.min_damage = 1.6
	self.melee_weapons.tiger.stats.max_damage = 2.4
	self.melee_weapons.tiger.stats.range = 155
	self.melee_weapons.tiger.repeat_expire_t = 0.45
	self.melee_weapons.tiger.expire_t = 1.1
	self.melee_weapons.tiger.melee_damage_delay = 0.1

	--Kunai--
	self.melee_weapons.cqc.damage_type = "piercing"
	self.melee_weapons.cqc.dot_data = {
		type = "poison",
		custom_data = {
			dot_damage = 0.6,
			dot_length = 4.1,
			hurt_animation_chance = 0.75
		}
	}	
	self.melee_weapons.cqc.stats.min_damage = 1
	self.melee_weapons.cqc.stats.max_damage = 1.6
	self.melee_weapons.cqc.stats.range = 150
	self.melee_weapons.cqc.repeat_expire_t = 0.3
	self.melee_weapons.cqc.expire_t = 1.1
	self.melee_weapons.cqc.melee_damage_delay = 0.1	

	--Shinsakuto Katana--
	self.melee_weapons.sandsteel.damage_type = "slashing"
	self.melee_weapons.sandsteel.info_id = "bm_melee_katana_info"	
	self.melee_weapons.sandsteel.stats.min_damage = 3
	self.melee_weapons.sandsteel.stats.max_damage = 5
	self.melee_weapons.sandsteel.stats.range = 220
	self.melee_weapons.sandsteel.repeat_expire_t = 0.9
	self.melee_weapons.sandsteel.attack_allowed_expire_t = 0.1
	self.melee_weapons.sandsteel.expire_t = 1.1
	self.melee_weapons.sandsteel.melee_damage_delay = 0.1	

	--Buckler Shield--
	self.melee_weapons.buck.damage_type = "bludgeoning"
	self.melee_weapons.buck.info_id = "bm_melee_buck_info"	
	self.melee_weapons.buck.anim_speed_mult = 1.4
	self.melee_weapons.buck.stats.min_damage = 1.6
	self.melee_weapons.buck.stats.max_damage = 2.4
	self.melee_weapons.buck.stats.range = 155
	self.melee_weapons.buck.repeat_expire_t = 0.7
	self.melee_weapons.buck.melee_damage_delay = 0.2
	self.melee_weapons.buck.expire_t = 1.2
	self.melee_weapons.buck.block = 0.85

	--Bearded Axe--
	self.melee_weapons.beardy.damage_type = "piercing"	
	self.melee_weapons.beardy.anim_global_param = "melee_baseballbat"
	self.melee_weapons.beardy.align_objects = {
		"a_weapon_right"
	}	
	self.melee_weapons.beardy.anim_speed_mult = 1.6
	self.melee_weapons.beardy.stats.min_damage = 2.4
	self.melee_weapons.beardy.stats.max_damage = 8
	self.melee_weapons.beardy.stats.range = 225
	self.melee_weapons.beardy.repeat_expire_t = 1.1
	self.melee_weapons.beardy.melee_damage_delay = 0.1
	self.melee_weapons.beardy.expire_t = 1.2	

	--Morning Star--
	self.melee_weapons.morning.damage_type = "bludgeoning"
	self.melee_weapons.morning.stats.min_damage = 2.4
	self.melee_weapons.morning.stats.max_damage = 3
	self.melee_weapons.morning.stats.range = 190
	self.melee_weapons.morning.repeat_expire_t = 0.9
	self.melee_weapons.morning.melee_damage_delay = 0.2
	self.melee_weapons.morning.expire_t = 1.2	
	
	--Great sword--
	self.melee_weapons.great.damage_type = "slashing"
	self.melee_weapons.great.anim_global_param = "melee_baseballbat"
	self.melee_weapons.great.align_objects = {
		"a_weapon_right"
	}
	self.melee_weapons.great.anim_speed_mult = 1.6
	self.melee_weapons.great.stats.min_damage = 5
	self.melee_weapons.great.stats.max_damage = 8
	self.melee_weapons.great.stats.range = 215
	self.melee_weapons.great.repeat_expire_t = 1
	self.melee_weapons.great.melee_damage_delay = 0.1
	self.melee_weapons.great.expire_t = 1.2	

	--Selfie Stick--
	self.melee_weapons.selfie.damage_type = "bludgeoning"
	self.melee_weapons.selfie.stats.min_damage = 1.2
	self.melee_weapons.selfie.stats.max_damage = 2
	self.melee_weapons.selfie.repeat_expire_t = 0.55
	self.melee_weapons.selfie.stats.range = 180
	self.melee_weapons.selfie.melee_damage_delay = 0.2
	self.melee_weapons.selfie.expire_t = 1.1	

	--Machete--
	self.melee_weapons.gator.damage_type = "slashing"
	self.melee_weapons.gator.stats.min_damage = 2.4
	self.melee_weapons.gator.stats.max_damage = 3
	self.melee_weapons.gator.repeat_expire_t = 0.6
	self.melee_weapons.gator.stats.range = 185
	self.melee_weapons.gator.melee_damage_delay = 0.1
	self.melee_weapons.gator.expire_t = 1.1	

	--Ice Pick--
	self.melee_weapons.iceaxe.damage_type = "piercing"
	self.melee_weapons.iceaxe.stats.min_damage = 2
	self.melee_weapons.iceaxe.stats.max_damage = 5
	self.melee_weapons.iceaxe.stats.range = 200
	self.melee_weapons.iceaxe.repeat_expire_t = 0.8
	self.melee_weapons.iceaxe.melee_damage_delay = 0.1
	self.melee_weapons.iceaxe.expire_t = 1.1
	self.melee_weapons.iceaxe.attack_allowed_expire_t = 0.1

	--Diving Knife--
	self.melee_weapons.pugio.damage_type = "slashing"
	self.melee_weapons.pugio.stats.min_damage = 2
	self.melee_weapons.pugio.stats.max_damage = 2.4
	self.melee_weapons.pugio.stats.range = 150
	self.melee_weapons.pugio.repeat_expire_t = 0.3
	self.melee_weapons.pugio.expire_t = 1.1
	self.melee_weapons.pugio.melee_damage_delay = 0.1
	
	--Shawn--
	self.melee_weapons.shawn.damage_type = "slashing"
	self.melee_weapons.shawn.stats.min_damage = 3
	self.melee_weapons.shawn.stats.max_damage = 5
	self.melee_weapons.shawn.stats.range = 160
	self.melee_weapons.shawn.repeat_expire_t = 0.6
	self.melee_weapons.shawn.melee_damage_delay = 0.1
	self.melee_weapons.shawn.expire_t = 1.1

	--Pitchfork--
	self.melee_weapons.pitchfork.damage_type = "piercing" 
	self.melee_weapons.pitchfork.anim_speed_mult = 1.65
	self.melee_weapons.pitchfork.stats.min_damage = 2.4
	self.melee_weapons.pitchfork.stats.max_damage = 8
	self.melee_weapons.pitchfork.stats.range = 225
	self.melee_weapons.pitchfork.repeat_expire_t = 1.1
	self.melee_weapons.pitchfork.melee_damage_delay = 0.15
	self.melee_weapons.pitchfork.expire_t = 1.2

	--Shephard's cane--
	self.melee_weapons.stick.damage_type = "bludgeoning"
	self.melee_weapons.stick.anim_global_param = "melee_baseballbat"
	self.melee_weapons.stick.type = "axe"
	self.melee_weapons.stick.align_objects = {"a_weapon_right"}
	self.melee_weapons.stick.anim_attack_vars = {"var1","var2"}
	self.melee_weapons.stick.stats.min_damage = 2.4
	self.melee_weapons.stick.stats.max_damage = 5
	self.melee_weapons.stick.stats.range = 210
	self.melee_weapons.stick.repeat_expire_t = 1.05
	self.melee_weapons.stick.expire_t = 1.2
	self.melee_weapons.stick.melee_damage_delay = 0.2

	--Scout Knife--
	self.melee_weapons.scoutknife.damage_type = "slashing"
	self.melee_weapons.scoutknife.repeat_expire_t = 0.4
	self.melee_weapons.scoutknife.stats.min_damage = 2
	self.melee_weapons.scoutknife.stats.max_damage = 2.4
	self.melee_weapons.scoutknife.stats.range = 170
	self.melee_weapons.scoutknife.expire_t = 1.1

	--Pounder Nailgun--
	self.melee_weapons.nin.damage_type = "piercing"
	self.melee_weapons.nin.info_id = "bm_melee_nin_info" 
	self.melee_weapons.nin.make_effect = true
	self.melee_weapons.nin.make_decal = true  
	self.melee_weapons.nin.stats.min_damage = 2
	self.melee_weapons.nin.stats.max_damage = 2
	self.melee_weapons.nin.stats.range = 500
	self.melee_weapons.nin.repeat_expire_t = 1
	self.melee_weapons.nin.melee_damage_delay = 0.15
	self.melee_weapons.nin.melee_charge_shaker = ""
	self.melee_weapons.nin.no_hit_shaker = true
	self.melee_weapons.nin.sounds.hit_air = ""
	self.melee_weapons.nin.sounds.charge = ""
	self.melee_weapons.nin.anim_attack_vars = {"var1"}
	self.melee_weapons.nin.anim_global_param = "melee_nin_res"

	--Specialist Knives --
	self.melee_weapons.ballistic.damage_type = "multi_slash"
	self.melee_weapons.ballistic.sounds.equip = "knife_equip"
	self.melee_weapons.ballistic.sounds.hit_air = "knife_hit_air"
	self.melee_weapons.ballistic.sounds.hit_gen = "knife_hit_gen"
	self.melee_weapons.ballistic.sounds.hit_body = "knife_hit_body"
	self.melee_weapons.ballistic.sounds.charge = "knife_charge"
	self.melee_weapons.ballistic.stats.min_damage = 2
	self.melee_weapons.ballistic.stats.max_damage = 3
	self.melee_weapons.ballistic.stats.range = 155
	self.melee_weapons.ballistic.repeat_expire_t = 0.6
	self.melee_weapons.ballistic.melee_damage_delay = 0.1
	self.melee_weapons.ballistic.expire_t = 1.1

	--Electric Brass Knuckles--
	self.melee_weapons.zeus.damage_type = "tase"
	self.melee_weapons.zeus.stats.min_damage = 1
	self.melee_weapons.zeus.stats.max_damage = 1.2
	self.melee_weapons.zeus.stats.range = 160
	self.melee_weapons.zeus.repeat_expire_t = 0.6
	self.melee_weapons.zeus.melee_damage_delay = 0.2

	--Butterfly Knife--
	self.melee_weapons.wing.damage_type = "slashing"
	self.melee_weapons.wing.info_id = "bm_melee_wing_info"	
	self.melee_weapons.wing.stats.min_damage = 1
	self.melee_weapons.wing.stats.max_damage = 2
	self.melee_weapons.wing.stats.range = 165
	self.melee_weapons.wing.repeat_expire_t = 0.5
	self.melee_weapons.wing.expire_t = 1.1
	self.melee_weapons.wing.melee_damage_delay = 0.1
	self.melee_weapons.wing.backstab_damage_multiplier = 4

	--Chain Whip--
	self.melee_weapons.road.damage_type = "bludgeoning"
	self.melee_weapons.road.anim_speed_mult = 1.75
	self.melee_weapons.road.stats.min_damage = 2
	self.melee_weapons.road.stats.max_damage = 3
	self.melee_weapons.road.stats.range = 195
	self.melee_weapons.road.repeat_expire_t = 0.85
	self.melee_weapons.road.melee_damage_delay = 0.1
	self.melee_weapons.road.expire_t = 1.2

	--Chainsaw--
	self.melee_weapons.cs.damage_type = "slashing"
	self.melee_weapons.cs.info_id = "bm_melee_cs_info"
	self.melee_weapons.cs.chainsaw = {
		tick_damage = 2,
		tick_delay = 0.25,
		start_delay = 0.8
	}
	self.melee_weapons.cs.stats.min_damage = 5
	self.melee_weapons.cs.stats.max_damage = 5
	self.melee_weapons.cs.stats.range = 180
	self.melee_weapons.cs.repeat_expire_t = 1.6

	--Hotline 8000x--
	self.melee_weapons.brick.damage_type = "bludgeoning"
	self.melee_weapons.brick.stats.min_damage = 1.2
	self.melee_weapons.brick.stats.max_damage = 2
	self.melee_weapons.brick.repeat_expire_t = 0.5
	self.melee_weapons.brick.stats.range = 170
	self.melee_weapons.brick.melee_damage_delay = 0.2
	self.melee_weapons.brick.expire_t = 1.1	

	--Kazuguruma--
	self.melee_weapons.ostry.damage_type = "slashing"
	self.melee_weapons.ostry.info_id = "bm_melee_ostry_info"
	self.melee_weapons.ostry.chainsaw = {
		tick_damage = 1,
		tick_delay = 0.25,
		start_delay = 0.4
	}
	self.melee_weapons.ostry.stats.tick_damage = 2	
	self.melee_weapons.ostry.stats.min_damage = 3
	self.melee_weapons.ostry.stats.max_damage = 3
	self.melee_weapons.ostry.stats.range = 160
	self.melee_weapons.ostry.melee_damage_delay = 0.1
	self.melee_weapons.ostry.repeat_expire_t = 1.1

	--Hook--
	self.melee_weapons.catch.damage_type = "slashing"
	self.melee_weapons.catch.stats.min_damage = 3
	self.melee_weapons.catch.stats.max_damage = 5
	self.melee_weapons.catch.stats.range = 180
	self.melee_weapons.catch.repeat_expire_t = 0.7
	self.melee_weapons.catch.expire_t = 1.1

	--Rezkoye--
	self.melee_weapons.oxide.damage_type = "slashing"
	self.melee_weapons.oxide.stats.min_damage = 3
	self.melee_weapons.oxide.stats.max_damage = 5
	self.melee_weapons.oxide.stats.range = 190
	self.melee_weapons.oxide.repeat_expire_t = 0.75
	self.melee_weapons.oxide.melee_damage_delay = 0.1
	self.melee_weapons.oxide.expire_t = 1.1	

	--The Pen--
	self.melee_weapons.sword.damage_type = "piercing"
	self.melee_weapons.sword.stats.min_damage = 1.6
	self.melee_weapons.sword.stats.max_damage = 3
	self.melee_weapons.sword.stats.range = 150
	self.melee_weapons.sword.repeat_expire_t = 0.3
	self.melee_weapons.sword.expire_t = 1.1
	self.melee_weapons.sword.melee_damage_delay = 0.1
	
	--El Vergudo--
	self.melee_weapons.agave.damage_type = "slashing"
	self.melee_weapons.agave.stats.min_damage = 3
	self.melee_weapons.agave.stats.max_damage = 5
	self.melee_weapons.agave.stats.range = 210
	self.melee_weapons.agave.repeat_expire_t = 0.85
	self.melee_weapons.agave.attack_allowed_expire_t = 0.1
	self.melee_weapons.agave.expire_t = 1.1
	self.melee_weapons.agave.melee_damage_delay = 0.1	

	--Push Daggers--
	self.melee_weapons.push.damage_type = "multi_slash"
	self.melee_weapons.push.stats.min_damage = 2
	self.melee_weapons.push.stats.max_damage = 3
	self.melee_weapons.push.stats.range = 155
	self.melee_weapons.push.repeat_expire_t = 0.6
	self.melee_weapons.push.expire_t = 1.1
	self.melee_weapons.push.melee_damage_delay = 0.1

	--Knuckle Daggers--
	self.melee_weapons.grip.damage_type = "multi_slash"
	self.melee_weapons.grip.stats.min_damage = 2
	self.melee_weapons.grip.stats.max_damage = 3
	self.melee_weapons.grip.stats.range = 155
	self.melee_weapons.grip.repeat_expire_t = 0.6
	self.melee_weapons.grip.melee_damage_delay = 0.1
	self.melee_weapons.grip.expire_t = 1.1
	
	--Leather Sap--
	self.melee_weapons.sap.damage_type = "bludgeoning"
	self.melee_weapons.sap.stats.min_damage = 1.2
	self.melee_weapons.sap.stats.max_damage = 2
	self.melee_weapons.sap.stats.range = 140
	self.melee_weapons.sap.repeat_expire_t = 0.35
	self.melee_weapons.sap.melee_damage_delay = 0.2
	self.melee_weapons.sap.expire_t = 1.1
	
	--Two Handed Great Ruler--
	self.melee_weapons.meter.damage_type = "slashing"
	self.melee_weapons.meter.anim_global_param = "melee_baseballbat"
	self.melee_weapons.meter.align_objects = {
		"a_weapon_right"
	}
	self.melee_weapons.meter.anim_speed_mult = 1.6
	self.melee_weapons.meter.stats.min_damage = 5
	self.melee_weapons.meter.stats.max_damage = 8
	self.melee_weapons.meter.stats.range = 215
	self.melee_weapons.meter.repeat_expire_t = 1
	self.melee_weapons.meter.melee_damage_delay = 0.1
	self.melee_weapons.meter.expire_t = 1.2	
	
	--Alabama Razor--
	self.melee_weapons.clean.damage_type = "slashing"
	self.melee_weapons.clean.dot_data = {
		type = "bleed",
		custom_data = {
			dot_damage = 1,
			dot_length = 2.1,
			hurt_animation_chance = 0.0
		}
	}
	self.melee_weapons.clean.info_id = "bm_melee_clean_info"
	self.melee_weapons.clean.stats.weapon_type = "sharp"
	self.melee_weapons.clean.stats.min_damage = 2.4
	self.melee_weapons.clean.stats.max_damage = 2.4
	self.melee_weapons.clean.stats.range = 140
	self.melee_weapons.clean.repeat_expire_t = 0.6
	self.melee_weapons.clean.melee_damage_delay = 0
	self.melee_weapons.clean.expire_t = 0.65
	
	--Tactical Flashlight--
	self.melee_weapons.aziz.damage_type = "bludgeoning"
	self.melee_weapons.aziz.stats.min_damage = 1.2
	self.melee_weapons.aziz.stats.max_damage = 2
	self.melee_weapons.aziz.repeat_expire_t = 0.5
	self.melee_weapons.aziz.stats.range = 170
	self.melee_weapons.aziz.melee_damage_delay = 0.2
	self.melee_weapons.aziz.expire_t = 1.1	
	
	--Hackaton--
	self.melee_weapons.happy.damage_type = "bludgeoning"
	self.melee_weapons.happy.stats.min_damage = 1.6
	self.melee_weapons.happy.stats.max_damage = 2.4
	self.melee_weapons.happy.stats.range = 180
	self.melee_weapons.happy.repeat_expire_t = 0.6
	self.melee_weapons.happy.melee_damage_delay = 0.2
	self.melee_weapons.happy.expire_t = 1.1
	
	--Monkey Wrench--
	self.melee_weapons.shock.damage_type = "bludgeoning"
	self.melee_weapons.shock.stats.min_damage = 2
	self.melee_weapons.shock.stats.max_damage = 3
	self.melee_weapons.shock.stats.range = 205
	self.melee_weapons.shock.repeat_expire_t = 0.9
	self.melee_weapons.shock.attack_allowed_expire_t = 0.1
	self.melee_weapons.shock.melee_damage_delay = 0.2
	self.melee_weapons.shock.expire_t = 1.2	
	
	--Kento's Tanto--
	self.melee_weapons.hauteur.damage_type = "slashing"
	self.melee_weapons.hauteur.stats.min_damage = 2.4
	self.melee_weapons.hauteur.stats.max_damage = 3
	self.melee_weapons.hauteur.stats.range = 155
	self.melee_weapons.hauteur.repeat_expire_t = 0.45
	self.melee_weapons.hauteur.expire_t = 1.1
	self.melee_weapons.hauteur.melee_damage_delay = 0.1

	--Stainless Steel Syringe --
	self.melee_weapons.fear.damage_type = "piercing"
	self.melee_weapons.fear.dot_data = {
		type = "poison",
		custom_data = {
			dot_damage = 0.6,
			dot_length = 4.1,
			hurt_animation_chance = 0.75
		}
	}
	self.melee_weapons.fear.stats.min_damage = 1
	self.melee_weapons.fear.stats.max_damage = 1.6
	self.melee_weapons.fear.stats.range = 150
	self.melee_weapons.fear.repeat_expire_t = 0.3
	self.melee_weapons.fear.expire_t = 1.1
	self.melee_weapons.fear.melee_damage_delay = 0.1	
	self.melee_weapons.fear.info_id = "bm_melee_cqc_info"
	
	--El Ritmo--
	self.melee_weapons.chac.damage_type = "bludgeoning"
	self.melee_weapons.chac.stats.min_damage = 1.2
	self.melee_weapons.chac.stats.max_damage = 2
	self.melee_weapons.chac.repeat_expire_t = 0.45
	self.melee_weapons.chac.stats.range = 160
	self.melee_weapons.chac.melee_damage_delay = 0.2
	self.melee_weapons.chac.expire_t = 1.1

	--Comically Large Spoon
	self.melee_weapons.spoon.damage_type = "bludgeoning"
	self.melee_weapons.spoon.stats.min_damage = 2.4
	self.melee_weapons.spoon.stats.max_damage = 5
	self.melee_weapons.spoon.stats.range = 220
	self.melee_weapons.spoon.repeat_expire_t = 1.1
	self.melee_weapons.spoon.melee_damage_delay = 0.2
	self.melee_weapons.spoon.expire_t = 1.2

	--Comically Large Spoon of Gold
	self.melee_weapons.spoon_gold.info_id = "bm_melee_spoon_gold_info"
	self.melee_weapons.spoon_gold.damage_type = "bludgeoning"
	self.melee_weapons.spoon_gold.stats.min_damage = 2.4
	self.melee_weapons.spoon_gold.stats.max_damage = 5
	self.melee_weapons.spoon_gold.stats.range = 220
	self.melee_weapons.spoon_gold.repeat_expire_t = 1.1
	self.melee_weapons.spoon_gold.melee_damage_delay = 0.2
	self.melee_weapons.spoon_gold.expire_t = 1.2
	self.melee_weapons.spoon_gold.fire_dot_data = {
		dot_trigger_chance = 25,
		dot_damage = 1,
		dot_length = 3.1,
		dot_trigger_max_distance = 3000,
		dot_tick_period = 0.5
	}

	local no_charge_time = {
		weapon = true, --Weapon Butt
		nin = true, --Pounder Nailgun
		ostry = true, --Kazaguruma
		cs = true, --Chainsaw
		clean = true --Alabama Razor
	}

	local concealment_overrides = {
		weapon = 21, --Weapon Butt
		fists = 21,  --Fists
		barbedwire = 6, --Lucille Baseball Bat
		switchblade = 18, --Switchblade
		taser = 19, --Buzzer
		fight = 21, --Empty Palm Kata
		buck = 11, --Buckler Shield
		nin = 11, --Pounder Nailgun
		zeus = 19, --Electric Brass Knuckles
		wing = 21, --Butterfly Knife
		ostry = 5, --Kazaguruma
		clean = 21, --Alabama Razor
	}

   	local knockdown_tables = {
		slashing = {
			clean = {1, 1}, --Alabama Razor
			wing = {1, 1}, --Butterfly Knife
			switchblade = {1, 1}, --Switchblade
			cs = {0.5, 0.5}, --Chainsaw
			ostry = {0.75, 0.75}, --Kazaguruma
			chef = {2, 2}, --Psycho Knife
			meat_cleaver = {1, 1}, --Dragan's Cleaver
			cleaver = {1, 1}, --Cleaver
			--First number corresponds to the damage tier (in terms of min_damage)
			--Second number corresponds to repeat_expire_t
			--Allows for bult-setting of melee knockdown.
			[2] = {
				[0.3] = {0.75, 0.75}, --Nova's Shank, Diving Knife
				[0.35] = {1, 1}, --Utility Knife, Trench Knife
				[0.4] = {1.25, 1.25} --Berger Knife, Bayonet Knife, Scout Knife
			},
			[2.4] = {
				[0.45] = {0.75, 0.75}, --Kento's Tanto
				[0.5] = {0.9, 0.9}, --Ursa Tanto, Kabar Knife
				[0.55] = {1.1, 1.1}, --Krieger Blade, X-46 Knife, Arkansas Toothpick
				[0.6] = {1.25, 1.25} --Utility Machete, Machete
			},
			[3] = {
				[0.6] = {0.75, 0.75}, --Shawn's Shears
				[0.7] = {0.85, 0.85}, --Trautman Knife, Hook
				[0.75] = {1, 1}, --Machete Knife, Rezkoye
				[0.85] = {1.15, 1.15}, --El Verdugo
				[0.9] = {1.25, 1.25} --Shinsakuto Katana
			},
			[5] = { 
				[1] = {0.75, 0.75} --Great Sword, Great Ruler
			}
		},
		tase = {
			[1] = {
				[0.6] = {0, 0} --Electric Brass Knuckles, Buzzer
			}
		},
		multi_slash = {
			[1.6] = {
				[0.45] = {1, 3} --Talons
			},
			[2] = {
				[0.6] = {1, 3} --Push Daggers, Specialist Knives, Knuckle Daggers
			}
		},
		bludgeoning = {
			weapon = {4, 4}, --Weapon Butt
			barbedwire = {4, 4}, --Lucille Baseball Bat
			buck = {4, 6}, --Buckler Shield
			boxing_gloves = {9, 9}, --Boxing Gloves
			fight = {6, 6}, --Empty Palm Kata
			slot_lever = {3, 4}, --Jackpot
			spoon_gold = {4, 4}, --Comically Large Spoon of Gold
			[1.2] = {
				[0.35] = {4, 4}, --Leather Sap
				[0.4] = {5, 5}, --Fists
				[0.45] = {6, 6}, --Money Bundle, Microphone, El Ritmo
				[0.5] = {7, 7}, --Spatula, Hotline 8000x, Tactical Flashlight
				[0.55] = {8, 8} --Selfie Stick
			},
			[1.6] = {
				[0.55] = {4, 4}, --Brass Knuckles
				[0.6] = {5, 5}, --Swagger Stick, Hackaton
				[0.7] = {8, 8} --Telescopic Baton, Classic Baton, Croupier's Rake
			},
			[2] = {
				[0.7] = {4, 4}, --Potato Masher, Carpenter's Delight
				[0.75] = {5, 5}, --Briefcase
				[0.8] = {6, 6}, --R. Glen Bottle, Tenderizer
				[0.85] = {7, 7},--Chain Whip, KL:AS Shovel
				[0.9] = {8, 8} --Clover's Shillelagh, Metal Detector, Monkey Wrench
			},
			[2.4] = {
				[0.9] = {4, 4}, --Microphone Stand, Morning Star
				[1] = {6, 6}, --Bolt Cutters, Hockey Stick
				[1.05] = {7, 7}, --Baseball Bat, Shepherd's Cane
				[1.1] = {8, 8} --Ding Dong Breaching Tool, Alpha Mauler
			}
		},
		piercing = {
			fear = {0.25, 1.5}, --Stainless Steel Syringe 
			cqc = {0.25, 1.5}, --Kunai
			nin = {3.5, 3.5}, --Pounder Nailgun
			branding_iron = {0.5, 2}, --You're Mine
			[1.6] = {
				[0.3] = {0.5, 2}, --The pen
				[0.45] = {0.75, 3}, --MotherForker
			},
			[2] = {
				[0.65] = {0.5, 2}, --Okinawan Style Sai
				[0.7] = {0.75, 3}, --Compact Hatchet
				[0.8] = {1, 4}, --Survival Tomahawk, Scalper Tomahawk, Ice Pick
			},
			[2.4] = {
				[0.85] = {0.5, 2}, --Poker
				[0.9] = {0.75, 3}, --Fire Axe
				[1.1] = {1, 4} --Freedom Spear, Pitchfork, Bearded Axe, Gold Fever
			}
		}
   	}

	for name, weap in pairs(self.melee_weapons) do
		if concealment_overrides[name] then
			weap.stats.concealment = concealment_overrides[name]
		else
			weap.stats.concealment = math.clamp(21 - ((weap.repeat_expire_t - 0.3) / 0.05), 1, 21)
		end

		if weap.damage_type then
			--Lookup desired knockdown value
			local weap_knockdown = nil
			if knockdown_tables[weap.damage_type][name] then
				weap_knockdown = knockdown_tables[weap.damage_type][name]
			elseif weap.repeat_expire_t and knockdown_tables[weap.damage_type][weap.stats.min_damage] then
				weap_knockdown = knockdown_tables[weap.damage_type][weap.stats.min_damage][weap.repeat_expire_t]
			end

			weap.stats.min_damage_effect = weap_knockdown[1]
			weap.stats.max_damage_effect = weap_knockdown[2]

			--Calculate charge time.
			if no_charge_time[name] then
				weap.stats.charge_time = (weap.stats.charge_time and 0.0000001) or nil
			else
				weap.stats.charge_time = math.ceil(weap.repeat_expire_t * 7.5 *
					(((weap.stats.max_damage / weap.stats.min_damage) + (weap.stats.max_damage_effect / weap.stats.min_damage_effect))/2)
					) / 10 --Apply rounding
			end

			--Apply damage type gimmick.
			if weap.damage_type == "piercing" then
				weap.headshot_damage_multiplier = 1.5

				if not weap.info_id then
					weap.info_id = "bm_melee_piercing_info"
				end
			elseif weap.damage_type == "bludgeoning" then
				weap.armor_piercing = true
				
				if not concealment_overrides[name] then
					weap.stats.concealment = math.min(weap.stats.concealment + 2, 21)
				end

				if not weap.info_id then
					weap.info_id = "bm_melee_bludgeoning_info"
				end
			elseif weap.damage_type == "multi_slash" then
				weap.special_weapon = "repeat_hitter"

				if not concealment_overrides[name] then
					weap.stats.concealment = math.min(weap.stats.concealment + 1, 21)
				end

				if not weap.info_id then
					weap.info_id = "bm_melee_multi_slash_info"
				end
			elseif weap.damage_type == "tase" then
				weap.special_weapon = "taser"
				weap.stats.charge_time = 0.8
				if not weap.info_id then
					weap.info_id = "bm_melee_taser_info"
				end
			end
		else
			log(tostring(name) .. "is missing a damage type")
		end
	end
end