--Modifiers
function WeaponFactoryTweakData:create_bonuses(tweak_data, weapon_skins)
	--Gotta keep the internal IDs intact to not anger remote JSONs and custom_xml.
	local function make_boost(name, icon, stats)
		local boost_table = {
			pcs = {},
			type = "bonus",
			a_obj = "a_body",
			name_id = name,
			alt_icon = icon,
			unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
			third_unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
			supported = true,
			stats = stats,
			internal_part = true,
			perks = {"bonus"},
			texture_bundle_folder = "boost_in_lootdrop",
			sub_type = "bonus_stats"
		}
		return boost_table
	end

	self.parts.wpn_fps_upg_bonus_concealment_p1 = make_boost(
		"bm_menu_bonus_concealment_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_concealment_p1_sc",
		{value = 1, concealment = 1, spread = -1}
	)

	self.parts.wpn_fps_upg_bonus_concealment_p2 = make_boost(
		"bm_menu_bonus_concealment_p2_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_concealment_p2_sc",
		{value = 1, concealment = 2, spread = -2}
	)

	self.parts.wpn_fps_upg_bonus_concealment_p3 = make_boost(
		"bm_menu_bonus_concealment_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_concealment_p1_sc",
		{value = 1, concealment = 1, recoil = -1}
	)

	self.parts.wpn_fps_upg_bonus_damage_p1 = make_boost(
		"bm_menu_bonus_concealment_p2_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_concealment_p2_sc",
		{value = 1, concealment = 2, recoil = -2}
	)

	self.parts.wpn_fps_upg_bonus_damage_p2 = make_boost(
		"bm_menu_bonus_spread_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_spread_p1_sc",
		{value = 1, spread = 1, recoil = -1}
	)

	self.parts.wpn_fps_upg_bonus_recoil_p1 = make_boost(
		"bm_menu_bonus_spread_p2_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_damage_p1_sc",
		{value = 1, spread = 2, recoil = -2}
	)

	self.parts.wpn_fps_upg_bonus_spread_n1 = make_boost(
		"bm_menu_bonus_spread_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_spread_p1_sc",
		{value = 1, spread = 1, concealment = -1}
	)

	self.parts.wpn_fps_upg_bonus_spread_p1 = make_boost(
		"bm_menu_bonus_spread_p2_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_damage_p1_sc",
		{value = 1, spread = 2, concealment = -2}
	)

	self.parts.wpn_fps_upg_bonus_team_exp_money_p3 = make_boost(
		"bm_menu_bonus_recoil_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_recoil_p1_sc",
		{value = 1, recoil = 1, spread = -1}
	)

	self.parts.wpn_fps_upg_bonus_total_ammo_p3 = make_boost(
		"bm_menu_bonus_recoil_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_total_ammo_p1_sc",
		{value = 1, recoil = 2, spread = -2}
	)

	self.parts.wpn_fps_upg_bonus_total_ammo_p1 = make_boost(
		"bm_menu_bonus_recoil_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_recoil_p1_sc",
		{value = 1, recoil = 1, concealment = -1}
	)

	self.parts.wpn_fps_upg_bonus_sc_none = make_boost(
		"bm_menu_bonus_recoil_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_total_ammo_p1_sc",
		{value = 1, recoil = 2, concealment = -2}
	)
	--self.parts.wpn_fps_upg_bonus_sc_none.exclude_from_challenge = true

	if weapon_skins then
		local uses_parts = {
			wpn_fps_upg_bonus_team_exp_money_p3 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_concealment_p1 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_recoil_p1 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_spread_p1 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_spread_n1 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_damage_p1 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_total_ammo_p1 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_concealment_p2 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_concealment_p3 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_damage_p2 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_total_ammo_p3 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_sc_none = {exclude_category = {"saw"}}
		}

		local all_pass, weapon_pass, exclude_weapon_pass, category_pass, exclude_category_pass
		for id, data in pairs(tweak_data.upgrades.definitions) do
			local weapon_tweak = tweak_data.weapon[data.weapon_id]
			local primary_category = weapon_tweak and weapon_tweak.categories and weapon_tweak.categories[1]
			if data.weapon_id and weapon_tweak and data.factory_id and self[data.factory_id] then
				for part_id, params in pairs(uses_parts) do
					weapon_pass = not params.weapon or table.contains(params.weapon, data.weapon_id)
					exclude_weapon_pass = not params.exclude_weapon or not table.contains(params.exclude_weapon, data.weapon_id)
					category_pass = not params.category or table.contains(params.category, primary_category)
					exclude_category_pass = not params.exclude_category or not table.contains(params.exclude_category, primary_category)
					all_pass = weapon_pass and exclude_weapon_pass and category_pass and exclude_category_pass
					if all_pass then
						table.insert(self[data.factory_id].uses_parts, part_id)
						table.insert(self[data.factory_id .. "_npc"].uses_parts, part_id)
					end
				end
			end
		end

		--Resmod Custom Weapon stuff

		--Raze's Fury

		self.wpn_fps_pis_shatters_fury.adds = {
			wpn_fps_upg_o_specter = {
				"wpn_fps_pis_rage_o_adapter"
			},
			wpn_fps_upg_o_aimpoint = {
				"wpn_fps_pis_rage_o_adapter"
			},
			wpn_fps_upg_o_aimpoint_2 = {
				"wpn_fps_pis_rage_o_adapter"
			},
			wpn_fps_upg_o_docter = {
				"wpn_fps_pis_rage_o_adapter"
			},
			wpn_fps_upg_o_eotech = {
				"wpn_fps_pis_rage_o_adapter"
			},
			wpn_fps_upg_o_t1micro = {
				"wpn_fps_pis_rage_o_adapter"
			},
			wpn_fps_upg_o_cmore = {
				"wpn_fps_pis_rage_o_adapter"
			},
			wpn_fps_upg_o_acog = {
				"wpn_fps_pis_rage_o_adapter"
			},
			wpn_fps_upg_o_cs = {
				"wpn_fps_pis_rage_o_adapter"
			},
			wpn_fps_upg_o_eotech_xps = {
				"wpn_fps_pis_rage_o_adapter"
			},
			wpn_fps_upg_o_reflex = {
				"wpn_fps_pis_rage_o_adapter"
			},
			wpn_fps_upg_o_rx01 = {
				"wpn_fps_pis_rage_o_adapter"
			},
			wpn_fps_upg_o_rx30 = {
				"wpn_fps_pis_rage_o_adapter"
			},
			wpn_fps_upg_o_spot = {
				"wpn_fps_pis_rage_o_adapter"
			},
			wpn_fps_upg_o_bmg = {
				"wpn_fps_pis_rage_o_adapter"
			},
			wpn_fps_upg_o_fc1 = {
				"wpn_fps_pis_rage_o_adapter"
			},
			wpn_fps_upg_o_uh = {
				"wpn_fps_pis_rage_o_adapter"
			}			
		}
		self.wpn_fps_pis_shatters_fury.override = {
			wpn_fps_pis_rage_lock = { 
				forbids = {}
			}
		}	
		self.wpn_fps_pis_shatters_fury.uses_parts = {
			"wpn_fps_pis_shatters_fury_body_standard",
			"wpn_fps_pis_shatters_fury_body_smooth",
			"wpn_fps_pis_shatters_fury_b_standard",
			"wpn_fps_pis_shatters_fury_b_short",
			"wpn_fps_pis_shatters_fury_b_long",
			"wpn_fps_pis_shatters_fury_b_comp1",
			"wpn_fps_pis_shatters_fury_b_comp2",
			"wpn_fps_pis_shatters_fury_g_standard",
			"wpn_fps_pis_shatters_fury_g_ergo",
			"wpn_fps_upg_o_specter",
			"wpn_fps_upg_o_aimpoint",
			"wpn_fps_upg_o_docter",
			"wpn_fps_upg_o_eotech",
			"wpn_fps_upg_o_t1micro",
			"wpn_fps_upg_o_cmore",
			"wpn_fps_upg_o_aimpoint_2",
			"wpn_fps_upg_o_acog",
			"wpn_fps_upg_o_eotech_xps",
			"wpn_fps_upg_o_reflex",
			"wpn_fps_upg_o_rx01",
			"wpn_fps_upg_o_rx30",
			"wpn_fps_upg_o_cs",
			"wpn_fps_pis_rage_o_adapter",
			"wpn_fps_pis_rage_lock",
			"wpn_fps_upg_o_spot",
			"wpn_fps_upg_o_xpsg33_magnifier",
			"wpn_fps_upg_o_sig",
			"wpn_fps_upg_o_bmg",
			"wpn_fps_upg_o_uh",
			"wpn_fps_upg_o_fc1"		
		}

		for _, part in pairs(self.parts) do
			if not part.supported and part.stats then
				part.stats = {
					value = part.stats.value,
					zoom = part.stats.zoom,
					alert_size = part.stats.alert_size,
					gadget_zoom = part.stats.gadget_zoom
				}
				part.custom_stats = nil
				part.desc_id = "bm_auto_generated_mod_sc_desc"
				part.has_description = true
			end
		end
	end
end

--Platypus 70
local orig_init_model70 = WeaponFactoryTweakData._init_model70
function WeaponFactoryTweakData:_init_model70()
	orig_init_model70(self)

	--Beak Suppressor
	self.parts.wpn_fps_snp_model70_ns_suppressor.pcs = {
		10,
		20,
		30,
		40
	}
	self.parts.wpn_fps_snp_model70_ns_suppressor.supported = true
	self.parts.wpn_fps_snp_model70_ns_suppressor.stats = {
		value = 10,
		suppression = 10,
		alert_size = -1
	}
	
	--Iron Sight
	self.parts.wpn_fps_snp_model70_iron_sight.pcs = {}
	self.parts.wpn_fps_snp_model70_iron_sight.supported = true
	self.parts.wpn_fps_snp_model70_iron_sight.stats = {
		value = 0
	}
	self.parts.wpn_fps_snp_model70_iron_sight.stance_mod = {
		wpn_fps_snp_msr = {
			translation = Vector3(0, 0, -3)
		},
		wpn_fps_snp_desertfox = {
			translation = Vector3(0, 0, -3.5)
		},
		wpn_fps_snp_r93 = {
			translation = Vector3(0, 0, -3.1)
		},
		wpn_fps_snp_m95 = {
			translation = Vector3(0, 25, -1.5)
		},
		wpn_fps_snp_tti = {
			translation = Vector3(0, 0, 0.25)
		},
		wpn_fps_snp_r700 = {
			translation = Vector3(0, 0, -3)
		}	
	}
end

local orig_init_tti = WeaponFactoryTweakData._init_tti
function WeaponFactoryTweakData:_init_tti()
	orig_init_tti(self)
	self.wpn_fps_snp_tti.override = {	
		wpn_fps_snp_model70_iron_sight = { 
			adds = {"wpn_fps_m4_uupg_o_flipup"}
		}
	}				
	self.wpn_fps_snp_tti.default_blueprint = {
		"wpn_fps_snp_tti_vg_standard",
		"wpn_fps_snp_tti_ns_standard",
		"wpn_fps_snp_tti_m_standard",
		"wpn_fps_snp_tti_fg_standard",
		"wpn_fps_snp_tti_dhs_switch",
		"wpn_fps_snp_tti_dh_standard",
		"wpn_fps_snp_tti_bolt_standard",
		"wpn_fps_snp_tti_body_receiverupper",
		"wpn_fps_snp_tti_body_receiverlower",
		"wpn_fps_snp_tti_b_standard",
		"wpn_fps_upg_o_shortdot",
		--"wpn_fps_m4_uupg_o_flipup",
		"wpn_fps_ass_contraband_s_standard",
		"wpn_fps_upg_m4_g_standard_vanilla"
	}
	self.wpn_fps_snp_tti.uses_parts = {
		"wpn_fps_snp_tti_vg_standard",
		"wpn_fps_snp_tti_s_vltor",
		"wpn_fps_snp_tti_ns_standard",
		"wpn_fps_snp_tti_ns_hex",
		"wpn_fps_snp_tti_m_standard",
		"wpn_fps_snp_tti_g_grippy",
		"wpn_fps_snp_tti_fg_standard",
		"wpn_fps_snp_tti_dhs_switch",
		"wpn_fps_snp_tti_dh_standard",
		"wpn_fps_snp_tti_bolt_standard",
		"wpn_fps_snp_tti_body_receiverupper",
		"wpn_fps_snp_tti_body_receiverlower",
		"wpn_fps_snp_tti_b_standard",
		"wpn_fps_ass_contraband_s_standard",
		"wpn_fps_upg_m4_s_ubr",
		"wpn_fps_upg_m4_s_crane",
		"wpn_fps_upg_m4_s_mk46",
		"wpn_fps_m4_uupg_s_fold",
		"wpn_fps_upg_m4_s_standard_vanilla",
		"wpn_fps_upg_m4_s_pts",
		"wpn_fps_upg_m4_g_hgrip",
		"wpn_fps_upg_m4_g_mgrip",
		"wpn_fps_upg_m4_g_standard_vanilla",
		"wpn_fps_upg_m4_g_ergo",
		"wpn_fps_upg_m4_g_sniper",
		"wpn_fps_upg_m4_s_adapter",
		"wpn_fps_upg_o_specter",
		"wpn_fps_upg_o_aimpoint",
		"wpn_fps_upg_o_docter",
		"wpn_fps_upg_o_eotech",
		"wpn_fps_upg_o_t1micro",
		"wpn_fps_upg_o_cmore",
		"wpn_fps_upg_o_aimpoint_2",
		"wpn_fps_upg_o_acog",
		"wpn_fps_upg_o_shortdot",
		"wpn_fps_upg_o_leupold",
		"wpn_fps_upg_o_45iron",
		"wpn_fps_upg_fl_ass_smg_sho_peqbox",
		"wpn_fps_upg_fl_ass_smg_sho_surefire",
		"wpn_fps_upg_o_eotech_xps",
		"wpn_fps_upg_o_reflex",
		"wpn_fps_upg_o_rx01",
		"wpn_fps_upg_o_rx30",
		"wpn_fps_upg_o_cs",
		"wpn_fps_upg_fl_ass_peq15",
		"wpn_fps_upg_fl_ass_laser",
		"wpn_fps_upg_fl_ass_utg",
		"wpn_fps_upg_o_spot",
		"wpn_fps_upg_o_box",
		"wpn_fps_upg_o_45rds",
		"wpn_fps_upg_o_xpsg33_magnifier",
		"wpn_fps_upg_o_45rds_v2",
		"wpn_fps_upg_g_m4_surgeon",
		"wpn_fps_upg_o_sig",
		"wpn_fps_upg_o_bmg",
		"wpn_fps_upg_o_uh",
		"wpn_fps_upg_o_fc1",
		"wpn_fps_upg_o_45steel",
		--Stuff--
		"wpn_fps_snp_model70_iron_sight",
		"wpn_fps_upg_m4_s_standard"
	}
	self.wpn_fps_snp_tti_npc = deep_clone(self.wpn_fps_snp_tti)
	self.wpn_fps_snp_tti_npc.unit = "units/pd2_dlc_spa/weapons/wpn_fps_snp_tti/wpn_fps_snp_tti_npc"
end