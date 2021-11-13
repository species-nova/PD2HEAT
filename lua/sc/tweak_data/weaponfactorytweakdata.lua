--[[local old_bonuses = WeaponFactoryTweakData.create_bonuses
function WeaponFactoryTweakData:create_bonuses(...)
	old_bonuses(self, ...)

	for _, part in pairs(self.parts) do
		if not part.supported and part.stats then
			--Logs for debugging. Remove if wanted for slightly better performance in loading screens.
			if part.name_id then
--					log("Removing stats from: " .. part.name_id)
			else
--					log("Removing stats from: Unknown Mod")
			end
			
			local alert_size
			if (part.sub_type == "silencer") or (part.perks and table.contains(part.perks,"silencer")) then 
				alert_size = part.stats.alert_size or 0
			end
			
			--Preserve cosmetic part stats.
			part.stats = {
				value = part.stats.value,
				zoom = part.stats.zoom,
				gadget_zoom = part.stats.gadget_zoom,
				alert_size = alert_size
			}
			part.custom_stats = nil
		end
	end
end]]

--Overrides for shotgun ammo types that vary per damage tier.
	--Indented to make for easy code folding in most editors.
	--@SC Feel free to define these for the other ammo types if you want, though it may require way more presets to be made since they also touch ammo count.
	--Flechettes
	local a_piercing_auto_override = {
		desc_id = "bm_wp_upg_a_piercing_auto_desc_sc",
		stats = {
			value = 9,
			damage = -6
		},
		custom_stats = {
			damage_near_mul = 1.25,
			damage_far_mul = 1.25,
			armor_piercing_add = 1,				
			bullet_class = "BleedBulletBase",
			dot_data = { 
				type = "bleed",
				custom_data = {
					dot_damage = 1.6,
					dot_length = 3.1,
					dot_tick_period = 0.5
				}
			}
		}
	}

	local a_piercing_semi_override = {
		desc_id = "bm_wp_upg_a_piercing_semi_desc_sc",
		stats = {
			value = 9,
			damage = -15
		},
		custom_stats = {
			damage_near_mul = 1.25,
			damage_far_mul = 1.25,
			armor_piercing_add = 1,				
			bullet_class = "BleedBulletBase",
			dot_data = { 
				type = "bleed",
				custom_data = {
					dot_damage = 2,
					dot_length = 3.1,
					dot_tick_period = 0.5
				}
			}
		}
	}

	local a_piercing_pump_override = {
		desc_id = "bm_wp_upg_a_piercing_pump_desc_sc",
		stats = {
			value = 9,
			damage = -15
		},
		custom_stats = {
			desc_id = "bm_wp_upg_a_piercing_pump_desc_sc",
			damage_near_mul = 1.25,
			damage_far_mul = 1.25,
			armor_piercing_add = 1,		
			bullet_class = "BleedBulletBase",
			dot_data = { 
				type = "bleed",
				custom_data = {
					dot_damage = 3,
					dot_length = 3.1,
					dot_tick_period = 0.5
				}
			}
		}
	}

	--Dragon's Breath
	local a_dragons_breath_auto_override = {
		desc_id = "bm_wp_upg_a_dragons_breath_auto_desc_sc",
		stats = {
			value = 9,
			damage = -6
		},
		custom_stats = {
			ignore_statistic = true,
			bullet_class = "FlameBulletBase",
			armor_piercing_add = 1,								
			can_shoot_through_shield = false,
			muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
			fire_dot_data = {
				dot_damage = 1.6,
				dot_trigger_chance = 50,
				dot_length = 3.1,
				dot_tick_period = 0.5
			}
		}
	}

	local a_dragons_breath_semi_override = {
		desc_id = "bm_wp_upg_a_dragons_breath_semi_desc_sc",
		stats = {
			value = 9,
			damage = -15
		},
		custom_stats = {
			ignore_statistic = true,
			bullet_class = "FlameBulletBase",
			armor_piercing_add = 1,									
			can_shoot_through_shield = false,
			muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
			fire_dot_data = {
				dot_damage = 3,
				dot_trigger_chance = 50,
				dot_length = 3.1,
				dot_tick_period = 0.5
			}
		}
	}

	local a_dragons_breath_pump_override = {
		desc_id = "bm_wp_upg_a_dragons_breath_pump_desc_sc",
		supported = true,
		stats = {
			value = 9,
			damage = -15
		},
		custom_stats = {
			ignore_statistic = true,
			bullet_class = "FlameBulletBase",
			armor_piercing_add = 1,								
			can_shoot_through_shield = false,
			muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
			fire_dot_data = {
				dot_damage = 3,
				dot_trigger_chance = 50,
				dot_length = 3.1,
				dot_tick_period = 0.5
			}
		}
	}

--Modifiers
function WeaponFactoryTweakData:create_bonuses(tweak_data, weapon_skins)
	--Gotta keep the internal IDs intact to not anger remote JSONs and custom_xml. Using comments to note what is actually what.

	--Smol conceal : "guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_concealment_p1_sc"
	--Big conceal : "guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_concealment_p2_sc"
	--Smol accuracy : "guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_spread_p1_sc"
	--Big accuracy : "guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_damage_p1_sc"
	--Smol recoil : "guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_recoil_p1_sc"
	--Big recoil : "guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_total_ammo_p1_sc"

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