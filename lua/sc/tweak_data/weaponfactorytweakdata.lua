--Common stat tables
	--Barrels
		local light_mob_barrel = {
			stats = {value = 1, spread = -1, concealment = 1},
			heat_stat_table = "light_mob_barrel", --Identifier for the stat table.
			heat_mod_filters = {heavy_mob_barrel = true} --Used to determine modifiers of X or Y stat types to filter out for gun.
		}
		local heavy_mob_barrel = {
			stats = {value = 1, spread = -2, concealment = 2},
			heat_stat_table = "heavy_mob_barrel",
			heat_mod_filters = {light_mob_barrel = true, heavy_mob_barrel = true}
		}
		local light_acc_barrel = {
			stats = {value = 1, spread = 1, concealment = -1},
			heat_stat_table = "light_acc_barrel",
			heat_mod_filters = {heavy_acc_barrel = true}
		}
		local heavy_acc_barrel = {
			stats = {value = 1, spread = 2, concealment = -2},
			heat_stat_table = "heavy_acc_barrel",
			heat_mod_filters = {light_acc_barrel = true, heavy_acc_barrel = true}
		}
	--Grips
		local light_stab_grip = {
			stats = {value = 1, spread = -1, recoil = 1},
			heat_stat_table = "light_stab_grip",
			heat_mod_filters = {heavy_stab_grip = true}
		}
		local heavy_stab_grip = {
			stats = {value = 1, spread = -2, recoil = 2},
			heat_stat_table = "heavy_stab_grip",
			heat_mod_filters = {light_stab_grip = true, heavy_stab_grip = true}
		}
		local light_acc_grip = {
			stats = {value = 1, spread = 1, recoil = -1},
			heat_stat_table = "light_acc_grip",
			heat_mod_filters = {heavy_acc_grip = true}
		}
		local heavy_acc_grip = {
			stats = {value = 1, spread = 2, recoil = -2},
			heat_stat_table = "heavy_acc_grip",
			heat_mod_filters = {light_acc_grip = true, heavy_acc_grip = true}
		}
	--Stocks
		local light_mob_stock = {
			stats = {value = 1, recoil = -1, concealment = 1},
			heat_stat_table = "light_mob_stock",
			heat_mod_filters = {heavy_mob_stock = true}
		}
		local heavy_mob_stock = {
			stats = {value = 1, recoil = -2, concealment = 2},
			heat_stat_table = "heavy_mob_stock",
			heat_mod_filters = {light_mob_stock = true, heavy_mob_stock = true}
		}
		local light_stab_stock = {
			stats = {value = 1, recoil = 1, concealment = -1},
			heat_stat_table = "light_stab_stock",
			heat_mod_filters = {heavy_stab_stock = true}
		}
		local heavy_stab_stock = {
			stats = {value = 1, recoil = 2, concealment = -2},
			heat_stat_table = "heavy_stab_stock",
			heat_mod_filters = {light_stab_stock = true, heavy_stab_stock = true}
		}

	--Applies a HEAT attachment stat table to a given attachment.
	function apply_stats(part, stat_table)
		part.supported = true
		for field, data in pairs(stat_table) do
			part[field] = data
		end
	end

local orig_init = WeaponFactoryTweakData.init
function WeaponFactoryTweakData:init(...)
	orig_init(self, ...)

	--Apply tweakdata for custom weapons.
	self:init_heat_shatters_fury()
	self:init_heat_osipr()

	--Strip part stats.
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

--GL 40
local orig_init_gre_m79 = WeaponFactoryTweakData._init_gre_m79
function WeaponFactoryTweakData:_init_gre_m79(...)
	orig_init_gre_m79(self, ...)
	apply_stats(self.parts.wpn_fps_gre_m79_barrel_short, heavy_mob_barrel) --Pirate Barrel
	apply_stats(self.parts.wpn_fps_gre_m79_stock_short, light_mob_stock) --Sawed off stock.
end

--Piglet
local orig_init_m32 = WeaponFactoryTweakData._init_m32
function WeaponFactoryTweakData:_init_m32(...)
	orig_init_m32(self, ...)
	apply_stats(self.parts.wpn_fps_gre_m32_barrel_short, light_mob_barrel) --Short Barrel
end

--China Puff
local orig_init_china = WeaponFactoryTweakData._init_china
function WeaponFactoryTweakData:_init_china(...)
	orig_init_china(self, ...)
	apply_stats(self.parts.wpn_fps_gre_china_s_short, light_mob_stock) --Riot Stock
end

--Arbiter
local orig_init_arbiter = WeaponFactoryTweakData._init_arbiter
function WeaponFactoryTweakData:_init_arbiter(...)
	orig_init_arbiter(self, ...)
	apply_stats(self.parts.wpn_fps_gre_arbiter_b_long, heavy_acc_barrel) --Bombardier Barrel
	apply_stats(self.parts.wpn_fps_gre_arbiter_b_comp, light_acc_barrel) --Long Barrel
end

--Phoenix .500
function WeaponFactoryTweakData:init_heat_shatters_fury()
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
end

--SABR
function WeaponFactoryTweakData:init_heat_osipr()
	self.parts.wpn_fps_ass_osipr_scope.material_parameters = {
		gfx_reddot = {
			{
				id = Idstring("holo_reticle_scale"),
				value = Vector3(0.2, 1.5, 40),
				condition = function ()
					return not _G.IS_VR
				end
			},
			{
				id = Idstring("holo_reticle_scale"),
				value = Vector3(0.2, 1, 20),
				condition = function ()
					return _G.IS_VR
				end
			}
		}
	}
	self.parts.wpn_fps_ass_osipr_b_standard.custom = false
	self.parts.wpn_fps_ass_osipr_body.custom = false
	self.parts.wpn_fps_ass_osipr_bolt.custom = false
	self.parts.wpn_fps_ass_osipr_gl.custom = false
	self.parts.wpn_fps_ass_osipr_gl_incendiary.custom = false
	self.parts.wpn_fps_ass_osipr_scope.custom = false
	self.parts.wpn_fps_ass_osipr_m_gl.custom = false
	self.parts.wpn_fps_ass_osipr_m_gl_incendiary.custom = false
end

--Modifiers
function WeaponFactoryTweakData:create_bonuses(tweak_data, weapon_skins)
	--Gotta keep the internal IDs intact to not anger remote JSONs and custom_xml.
	local function make_boost(name, icon, stat_table)
		local boost_table = {
			pcs = {},
			type = "bonus",
			a_obj = "a_body",
			name_id = name,
			alt_icon = icon,
			unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
			third_unit = "units/payday2/weapons/wpn_upg_dummy/wpn_upg_dummy",
			supported = true,
			stats = stat_table.stats,
			heat_stat_table = stat_table.heat_stat_table,
			heat_mod_filters = stat_table.heat_mod_filters,
			internal_part = true,
			perks = {"bonus"},
			texture_bundle_folder = "boost_in_lootdrop",
			sub_type = "bonus_stats"
		}
		return boost_table
	end

	self.parts.wpn_fps_upg_bonus_concealment_p3 = make_boost(
		"bm_menu_bonus_concealment_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_concealment_p1_sc",
		light_mob_stock
	)

	self.parts.wpn_fps_upg_bonus_damage_p1 = make_boost(
		"bm_menu_bonus_concealment_p2_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_concealment_p2_sc",
		heavy_mob_stock
	)

	self.parts.wpn_fps_upg_bonus_total_ammo_p1 = make_boost(
		"bm_menu_bonus_recoil_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_recoil_p1_sc",
		light_stab_stock
	)

	self.parts.wpn_fps_upg_bonus_sc_none = make_boost(
		"bm_menu_bonus_recoil_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_total_ammo_p1_sc",
		heavy_stab_stock
	)

	self.parts.wpn_fps_upg_bonus_concealment_p1 = make_boost(
		"bm_menu_bonus_concealment_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_concealment_p1_sc",
		light_mob_barrel
	)

	self.parts.wpn_fps_upg_bonus_concealment_p2 = make_boost(
		"bm_menu_bonus_concealment_p2_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_concealment_p2_sc",
		heavy_mob_barrel
	)

	self.parts.wpn_fps_upg_bonus_spread_n1 = make_boost(
		"bm_menu_bonus_spread_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_spread_p1_sc",
		light_acc_barrel
	)

	self.parts.wpn_fps_upg_bonus_spread_p1 = make_boost(
		"bm_menu_bonus_spread_p2_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_damage_p1_sc",
		heavy_acc_barrel
	)

	self.parts.wpn_fps_upg_bonus_damage_p2 = make_boost(
		"bm_menu_bonus_spread_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_spread_p1_sc",
		light_stab_grip
	)

	self.parts.wpn_fps_upg_bonus_recoil_p1 = make_boost(
		"bm_menu_bonus_spread_p2_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_damage_p1_sc",
		heavy_stab_grip
	)

	self.parts.wpn_fps_upg_bonus_team_exp_money_p3 = make_boost(
		"bm_menu_bonus_recoil_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_recoil_p1_sc",
		light_acc_grip
	)

	self.parts.wpn_fps_upg_bonus_total_ammo_p3 = make_boost(
		"bm_menu_bonus_recoil_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_total_ammo_p1_sc",
		heavy_acc_grip
	)

	if weapon_skins then
		local uses_parts = {
			wpn_fps_upg_bonus_concealment_p3 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_damage_p1 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_total_ammo_p1 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_sc_none = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_concealment_p1 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_concealment_p2 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_spread_n1 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_spread_p1 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_damage_p2 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_recoil_p1 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_team_exp_money_p3 = {exclude_category = {"saw"}},
			wpn_fps_upg_bonus_total_ammo_p3 = {exclude_category = {"saw"}}
		}

		local all_pass, weapon_pass, exclude_weapon_pass, category_pass, exclude_category_pass, duplicate_pass
		for id, data in pairs(tweak_data.upgrades.definitions) do
			local weapon_tweak = tweak_data.weapon[data.weapon_id]
			local primary_category = weapon_tweak and weapon_tweak.categories and weapon_tweak.categories[1]
			if data.weapon_id and weapon_tweak and data.factory_id and self[data.factory_id] then
				local attachments = self[data.factory_id].uses_parts or {}
				for part_id, params in pairs(uses_parts) do
					weapon_pass = not params.weapon or table.contains(params.weapon, data.weapon_id)
					exclude_weapon_pass = not params.exclude_weapon or not table.contains(params.exclude_weapon, data.weapon_id)
					category_pass = not params.category or table.contains(params.category, primary_category)
					exclude_category_pass = not params.exclude_category or not table.contains(params.exclude_category, primary_category)

					--Add filter pass to not include any modifiers that would duplicate stats of other attachments on a given gun.
					duplicate_pass = true
					for i, attachment_id in ipairs(attachments) do
						local attachment = self.parts[attachment_id]
						if attachment
							and not uses_parts[attachment_id]
							and attachment.heat_mod_filters
							and attachment.heat_mod_filters[self.parts[part_id].heat_stat_table] then
							duplicate_pass = false
							break
						end
					end

					if weapon_pass and exclude_weapon_pass and category_pass and exclude_category_pass and duplicate_pass then
						table.insert(self[data.factory_id].uses_parts, part_id)
						table.insert(self[data.factory_id .. "_npc"].uses_parts, part_id)
					end
				end
			end
		end
	end
end

local orig_create_ammunition = WeaponFactoryTweakData.create_ammunition
function WeaponFactoryTweakData:create_ammunition(...)
	orig_create_ammunition(self, ...)

	--Generic incendiary ammo.
	--See enveffecttweakdata.lua for remaining stats on GL incendiary ammo.
	self.parts.wpn_fps_upg_a_grenade_launcher_incendiary.supported = true
	self.parts.wpn_fps_upg_a_grenade_launcher_incendiary.stats = {damage = -37}

	--Generic electric ammo.
	self.parts.wpn_fps_upg_a_grenade_launcher_electric.supported = true
	self.parts.wpn_fps_upg_a_grenade_launcher_electric.stats = {damage = -20}

	--Arbiter incendiary ammo.
	self.parts.wpn_fps_upg_a_grenade_launcher_incendiary_arbiter.supported = true
	self.parts.wpn_fps_upg_a_grenade_launcher_incendiary_arbiter.stats = {damage = -28}

	--Arbiter electric ammo
	self.parts.wpn_fps_upg_a_grenade_launcher_electric_arbiter.supported = true
	self.parts.wpn_fps_upg_a_grenade_launcher_electric_arbiter.stats = {damage = -15}

	self.parts.wpn_fps_upg_a_underbarrel_frag_groza.supported = true
	self.parts.wpn_fps_upg_a_underbarrel_electric.supported = true
end