--///Common stat tables///
  --Try to follow the commenting conventions shown.  List the name of the preset, and what it does exactly.
	--///Cosmetic///
		--Cosmetic: If a modpart has no associated stats to apply to the weapon, give it the 'cosmetic' flag, which will make the 'TODO' description not appear ingame.
		local cosmetic = {
			has_description = false,
			stats = {value = 1}
		}
	--///Barrel Extensions///
		--Unsuppressor: To be used on modparts that remove a silencer aspect from the base weapon.
		local unsuppressor = {
			stats = {value = 1, suppression = 4, alert_size = -1},
			custom_stats = {
				damage_near_mul = 1/0.9,
				damage_far_mul  = 1/0.9
			}
		}
		--Loudener: Increases suppression.
		local loudener = {
			stats = {value = 1, suppression = 4}
		}
		--Flash Hider: Reduces suppression.
		local flash_hider = {
			stats = {value = 1, suppression = -4}
		}
		--Suppressor: Suppresses modpart/weapon.
		local suppressor = {
			stats = {value = 2, suppression = -4, alert_size = 1},
			custom_stats = {
				damage_near_mul = 0.9,
				damage_far_mul  = 0.9
			}
		}
		--Light stability extension: DESCRIBE ME
		local light_stab_ext = {
			stats = {value = 2, spread = -1, recoil = 1},
			heat_stat_table = "light_stab_ext",
			heat_mod_filters = {heavy_stab_ext = true}
		}
		--Heavy stability extension: DESCRIBE ME
		local heavy_stab_ext = {
			stats = {value = 3, spread = -2, recoil = 2},
			heat_stat_table = "heavy_stab_ext",
			heat_mod_filters = {light_stab_ext = true, heavy_stab_ext = true}
		}
		--Light accuracy extension: DESCRIBE ME
		local light_acc_ext = {
			stats = {value = 2, spread = 1, recoil = -1},
			heat_stat_table = "light_acc_ext",
			heat_mod_filters = {heavy_acc_ext = true}
		}
		--Heavy accuracy extension: DESCRIBE ME
		local heavy_acc_ext = {
			stats = {value = 3, spread = 2, recoil = -2},
			heat_stat_table = "heavy_acc_ext",
			heat_mod_filters = {light_acc_ext = true, heavy_acc_ext = true}
		}
	--///Gadgets///
		--Bulky gadget: DESCRIBE ME
		local bulky_gadget = {
			custom_stats = {swap_speed_mul = 0.9}
		}
	--///Magazines///
		--Quadstacked magazine: DESCRIBE ME
		local quadstacked_mag = {
			has_description = true,
			desc_id = "bm_wpn_fps_upg_m4_m_quad_desc",
			custom_stats = {movement_speed = 0.9},
			stats = {value = 3, concealment = -5, reload = -5, extra_ammo = 30}
		}
		--Vintage magazine: DESCRIBE ME
		local vintage_mag = {
			stats = {value = 3, concealment = 2, reload = 6, extra_ammo = -10}
		}
		--Shell rack: DESCRIBE ME
		local shell_rack = {
			stats = {value = 1, reload = 2, concealment = -1},
			custom_stats = {swap_speed_mul = 0.9}
		}
	--//Barrels///
		--Light mobility barrel: DESCRIBE ME
		local light_mob_barrel = {
			stats = {value = 2, spread = -1, concealment = 1},
			heat_stat_table = "light_mob_barrel", --Identifier for the stat table.
			heat_mod_filters = {heavy_mob_barrel = true} --Used to determine modifiers of X or Y stat types to filter out for gun.
		}
		--Heavy mobility barrel: DESCRIBE ME
		local heavy_mob_barrel = {
			stats = {value = 3, spread = -2, concealment = 2},
			heat_stat_table = "heavy_mob_barrel",
			heat_mod_filters = {light_mob_barrel = true, heavy_mob_barrel = true}
		}
		--Light accuracy barrel: DESCRIBE ME
		local light_acc_barrel = {
			stats = {value = 2, spread = 1, concealment = -1},
			heat_stat_table = "light_acc_barrel",
			heat_mod_filters = {heavy_acc_barrel = true}
		}
		--Heavy accuracy barrel: DESCRIBE ME
		local heavy_acc_barrel = {
			stats = {value = 3, spread = 2, concealment = -2},
			heat_stat_table = "heavy_acc_barrel",
			heat_mod_filters = {light_acc_barrel = true, heavy_acc_barrel = true}
		}
	--///Grips///
		--Vertical Grip: DESCRIBE ME
		local vertical_grip = {
			stats = {value = 1},
			custom_stats = {
				kick_addend = {
					-0.2,
					-0.2,
					-0.2,
					0.2
				}
			}
		}
		--Horizontal grip: DESCRIBE ME
		local horizontal_grip = {
			stats = {value = 1},
			custom_stats = {
				kick_addend = {
					0.2,
					0.2,
					0.2,
					-0.2
				}
			}
		}
		--Left grip with no beef: DESCRIBE ME
		local left_grip = {
			stats = {value = 1},
			custom_stats = {
				kick_addend = {
					0.2,
					0.2,
					0.0,
					0.4,
				}
			}
		}
		--Right grip: DESCRIBE ME
		local right_grip = {
			stats = {value = 1},
			custom_stats = {
				kick_addend = {
					0.2,
					0.2,
					-0.4,
					0.0
				}
			}
		}
	--///Stocks///
		--Light mobility stock: DESCRIBE ME
		local light_mob_stock = {
			stats = {value = 2, recoil = -1, concealment = 1},
			heat_stat_table = "light_mob_stock",
			heat_mod_filters = {heavy_mob_stock = true}
		}
		--Heavy mobility stock: DESCRIBE ME
		local heavy_mob_stock = {
			stats = {value = 3, recoil = -2, concealment = 2},
			heat_stat_table = "heavy_mob_stock",
			heat_mod_filters = {light_mob_stock = true, heavy_mob_stock = true}
		}
		--Light stability stock: DESCRIBE ME
		local light_stab_stock = {
			stats = {value = 2, recoil = 1, concealment = -1},
			heat_stat_table = "light_stab_stock",
			heat_mod_filters = {heavy_stab_stock = true}
		}
		--Heavy stability stock: DESCRIBE ME
		local heavy_stab_stock = {
			stats = {value = 3, recoil = 2, concealment = -2},
			heat_stat_table = "heavy_stab_stock",
			heat_mod_filters = {light_stab_stock = true, heavy_stab_stock = true}
		}
	--///Arrows///
		--Poison arrow: DESCRIBE ME
		local poison_arrow = {
			stats = {value = 4}
		}
		--Light bow poison: DESCRIBE ME
		local light_bow_poison = {
				stats = {damage = -20},
				custom_stats = {
					dot_data =  {
						type = "poison",
						custom_data = {
							dot_damage = 0.6,
							dot_duration = 5.1,
							dot_tick_period = 0.5,
							hurt_animation_chance = 0.5
						}
					}
				}
			}
		--Heavy bow poison: DESCRIBE ME
		local heavy_bow_poison = {
				stats = {damage = -20},
				custom_stats = {
					dot_data = {
						type = "poison",
						custom_data = {
							dot_damage = 0.6,
							dot_duration = 5.1,
							dot_tick_period = 0.5,
							hurt_animation_chance = 0.5
						}
					}
				}
			}
		--Light explosive arrow: DESCRIBE ME
		local light_explosive_arrow = {
			stats = {value = 4, damage = 20, spread = -4}
		}
		--Heavy explosive arrow: DESCRIBE ME
		local heavy_explosive_arrow = {
			stats = {value = 4, damage = 20, spread = -4}
		}
	--///Flamethrower Tanks///
		--Rare tank: DESCRIBE ME
		local rare_tank = {
			stats = {value = 4},
			has_description = true,
			desc_id = "bm_wp_fla_mk2_mag_rare_desc_sc",
			custom_stats = {
				fire_dot_data = {
					dot_damage = 1,
					dot_trigger_chance = 25,
					dot_length = 3.1,
					dot_tick_period = 0.5
				},
				damage_near_mul = 1.2727273,
				damage_far_mul = 1.2727273
			}
		}
		--Well done tank: DESCRIBE ME
		local well_done_tank = {
			stats = {value = 4},
			has_description = true,
			desc_id = "bm_wp_fla_mk2_mag_well_desc_sc",
			custom_stats = {
				fire_dot_data = {
					dot_damage = 1,
					dot_trigger_chance = 75,
					dot_length = 3.1,
					dot_tick_period = 0.5
				},
				damage_near_mul = 0.7272727,
				damage_far_mul = 0.7272727
			}
		}
		
--////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////

	--Applies a HEAT attachment stat table to a given attachment.
	local function apply_stats(part, stat_table, ...)
		part.supported = true
		for field, data in pairs(stat_table) do
			part[field] = data
		end

		local arg = {...}
		local function append_stats(append_table)
			for k, v in pairs(append_table) do
				if type(v) == "table" then			
					--Clone current table to avoid changing the global attachment tables.
					part[k] = part[k] and deep_clone(part[k]) or {}

					for stat, data in pairs(v) do
						orig_stat = part[k][stat]
						if orig_stat and type(orig_stat) == "number" and k ~= "heat_stat_table" then
							part[k][stat] = orig_stat + data
						else
							part[k][stat] = data
						end
					end
				elseif type(t) == "number" and type(part[k]) == "number" then
					part[k] = part[k] + v
				else
					part[k] = v
				end
			end
		end

		for i = 1, #arg do
			append_stats(arg[i])
		end
	end

	--Shotgun Ammo Types
		local slug_damage = {
			vd12 = 27,
			light = 45,
			medium = 72,
			heavy = 90
		}
		local slug = {
			desc_id = "bm_wp_upg_a_slug_desc_sc",
			supported = true,
			stats = {
				value = 6,
				spread = 2
			},
			custom_stats = {
				muzzleflash = "effects/payday2/particles/weapons/762_auto_fps",
				rays = 1,
				ammo_pickup_min_mul = 0.7,
				ammo_pickup_max_mul = 0.7,
				armor_piercing_add = 1,
				can_shoot_through_enemy = true,
				can_shoot_through_shield = true,
				can_shoot_through_wall = true
			}
		}

		local he_damage = {
			vd12 = 47,
			light = 75,
			medium = 92,
			heavy = 140
		}
		local he_slug = {
			desc_id = "bm_wp_upg_a_he_desc_sc",
			supported = true,
			stats = {
				value = 6
			},
			custom_stats = {
				ignore_statistic = true,
				block_b_storm = true,
				rays = 1,
				bullet_class = "InstantExplosiveBulletBase",
				ammo_pickup_min_mul = 0.5,
				ammo_pickup_max_mul = 0.5
			}
		}

		local buck_damage = {
			vd12 = 3,
			light = 5,
			medium = 8,
			heavy = 10
		}
		local d0buck = {
			desc_id = "bm_wp_upg_a_custom_desc_sc",
			supported = true,
			stats = {
				value = 6,
				spread = -3
			},
			custom_stats = {
				rays = 6,
				damage_near_mul = 0.8,
				damage_far_mul = 0.8,
			}
		}

		local shotgun_dot_damage = {
			vd12 = 2.6,
			light = 4.6,
			medium = 6.1,
			heavy = 8.1
		}
		local flechette = {
			desc_id = "bm_wp_upg_a_piercing_desc_sc",
			stats = {
				value = 6
			},
			custom_stats = {
				armor_piercing_add = 1,
				ammo_pickup_min_mul = 0.85,
				ammo_pickup_max_mul = 0.85,
				damage_near_mul = 1.25,
				damage_far_mul = 1.25,
				rays = 5,
				bullet_class = "BleedBulletBase",
				can_shoot_through_enemy = true,
				dot_data = { 
					type = "bleed",
					custom_data = {
						dot_damage = 1,
						dot_tick_period = 0.5
					}
				}
			}
		}
		local dragons_breath = {
			desc_id = "bm_wp_upg_a_dragons_breath_desc_sc",
			stats = {
				value = 6
			},
			custom_stats = {
				ignore_statistic = true,
				bullet_class = "FlameBulletBase",
				armor_piercing_add = 1,
				rays = 5,
				muzzleflash = "effects/payday2/particles/weapons/shotgun/sho_muzzleflash_dragons_breath",
				fire_dot_data = {
					dot_damage = 1,
					dot_trigger_chance = 12,
					dot_tick_period = 0.5
				}
			}
		}

	local function apply_shotgun_ammo_types(weapon, tier)
		local function create_override(part, stat_block)
			weapon.override = weapon.override or {}
			weapon.override[part] = stat_block
		end

		local function create_shotgun_ammo(preset, damage)
			local ammo = deep_clone(preset)

			if ammo.custom_stats.dot_data then
				ammo.custom_stats.dot_data.custom_data.dot_length = damage
			elseif ammo.custom_stats.fire_dot_data then
				ammo.custom_stats.fire_dot_data.dot_length = damage
			else
				ammo.stats.damage = damage				
			end

			return ammo
		end

		create_override("wpn_fps_upg_a_slug", create_shotgun_ammo(slug, slug_damage[tier])) --Slugs
		create_override("wpn_fps_upg_a_explosive", create_shotgun_ammo(he_slug, he_damage[tier])) --Taser Slug
		create_override("wpn_fps_upg_a_custom", create_shotgun_ammo(d0buck, buck_damage[tier])) --00 Buckshot
		create_override("wpn_fps_upg_a_custom_free", create_shotgun_ammo(d0buck, buck_damage[tier])) --00 Buckshot (free)
		create_override("wpn_fps_upg_a_piercing", create_shotgun_ammo(flechette, shotgun_dot_damage[tier])) --Flechettes
		create_override("wpn_fps_upg_a_dragons_breath", create_shotgun_ammo(dragons_breath, shotgun_dot_damage[tier])) --Dragon's Breath
	end


local orig_init = WeaponFactoryTweakData.init
function WeaponFactoryTweakData:init()
	orig_init(self)

	--Apply tweakdata for custom weapons.
	self:init_heat_shatters_fury()
	self:init_heat_osipr()

	--Strip part stats.
	for _, part in pairs(self.parts) do
		if not part.supported and part.stats then
			part.stats = {
				value = 1,
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

local orig_init_silencers = WeaponFactoryTweakData._init_silencers
function WeaponFactoryTweakData:_init_silencers()
	orig_init_silencers(self)
	apply_stats(self.parts.wpn_fps_upg_ns_ass_smg_large, suppressor, heavy_acc_ext) --The Bigger the Better
	apply_stats(self.parts.wpn_fps_upg_ns_ass_smg_medium, suppressor, light_acc_ext) --Medium Suppressor
	apply_stats(self.parts.wpn_fps_upg_ns_ass_smg_small, suppressor) --Low Profile Suppressor
	apply_stats(self.parts.wpn_fps_upg_ns_pis_large, suppressor, heavy_acc_ext) --Monolith Suppressor
	apply_stats(self.parts.wpn_fps_upg_ns_pis_medium, suppressor, light_acc_ext) --Standard Issue Suppressor
	apply_stats(self.parts.wpn_fps_upg_ns_pis_small, suppressor) --Size Doesn't Matter Suppressor
	apply_stats(self.parts.wpn_fps_upg_ns_shot_thick, suppressor, heavy_stab_ext) --Silent Killer Suppressor
end

local orig_init_nozzles = WeaponFactoryTweakData._init_nozzles
function WeaponFactoryTweakData:_init_nozzles()
	orig_init_nozzles(self)
	apply_stats(self.parts.wpn_fps_upg_ns_ass_smg_firepig, flash_hider) --Fire Breather Nozzle
	apply_stats(self.parts.wpn_fps_upg_ns_ass_smg_stubby, heavy_acc_ext) --Stubby Compensator
	apply_stats(self.parts.wpn_fps_upg_ns_ass_smg_tank, heavy_stab_ext, loudener) --The Tank Compensator
	apply_stats(self.parts.wpn_fps_upg_ns_shot_shark, light_acc_ext) --Shark Teeth Nozzle
end

local orig_init_gadgets = WeaponFactoryTweakData._init_gadgets
function WeaponFactoryTweakData:_init_gadgets()
	orig_init_gadgets(self)
	--apply_stats(self.parts.wpn_fps_addon_ris, cosmetic) --???
	apply_stats(self.parts.wpn_fps_upg_fl_ass_smg_sho_surefire, cosmetic) --Assault Light
	apply_stats(self.parts.wpn_fps_upg_fl_ass_smg_sho_peqbox, cosmetic) --Tactical Laser Module
	apply_stats(self.parts.wpn_fps_upg_fl_pis_laser, cosmetic) --Pocket Laser
	apply_stats(self.parts.wpn_fps_upg_fl_pis_tlr1, cosmetic) --Tactical Pistol Light
	--apply_stats(self.parts.wpn_fps_upg_fl_ass_laser, cosmetic) --Compact Laser Module

end

local orig_init_vertical_grips = WeaponFactoryTweakData._init_vertical_grips
function WeaponFactoryTweakData:_init_vertical_grips()
	orig_init_vertical_grips(self)
	apply_stats(self.parts.wpn_fps_upg_vg_ass_smg_verticalgrip, vertical_grip)
	apply_stats(self.parts.wpn_fps_upg_vg_ass_smg_stubby, horizontal_grip)
	apply_stats(self.parts.wpn_fps_upg_vg_ass_smg_afg, cosmetic)
end

local orig_init_sights = WeaponFactoryTweakData._init_sights
function WeaponFactoryTweakData:_init_sights()
	orig_init_sights(self)
	--TODO: Go over these!
	--apply_stats(self.parts.wpn_fps_upg_o_specter, cosmetic) --Milspec Scope
	--apply_stats(self.parts.wpn_fps_upg_o_aimpoint, cosmetic) --Military Red Dot
	--apply_stats(self.parts.wpn_fps_upg_o_aimpoint_2, cosmetic) --Preorder Military Red Dot
	--apply_stats(self.parts.wpn_fps_upg_o_docter, cosmetic) --Surgeon Sight
	--apply_stats(self.parts.wpn_fps_upg_o_tf90, cosmetic) --Compact Tactical
	--apply_stats(self.parts.wpn_fps_upg_o_poe, cosmetic) --Owl Glass
	--apply_stats(self.parts.wpn_fps_upg_o_eotech, cosmetic) --Holographic Sight
	--apply_stats(self.parts.wpn_fps_upg_o_t1micro, cosmetic) --The Professional's Choice Sight
	--apply_stats(self.parts.wpn_upg_o_marksmansight_rear, cosmetic) --Marksman Sight
	--apply_stats(self.parts.wpn_fps_upg_o_45iron, cosmetic) --Angled Sight
	--apply_stats(self.parts.wpn_fps_upg_o_shortdot, cosmetic) --Shortdot Sight (Default Sniper Scope)
	--apply_stats(self.parts.wpn_fps_upg_o_leupold, cosmetic) --Theia Magnified Scope
end

local orig_init_content_dlc1 = WeaponFactoryTweakData._init_content_dlc1
function WeaponFactoryTweakData:_init_content_dlc1()
	orig_init_content_dlc1(self)
	--TODO: Go over these!
	--apply_stats(self.parts.wpn_fps_upg_o_cmore, cosmetic) --See More Sight
end

local orig_init_content_dlc2 = WeaponFactoryTweakData._init_content_dlc2
function WeaponFactoryTweakData:_init_content_dlc2()
	orig_init_content_dlc2(self)
	--TODO: self.parts.wpn_fps_upg_i_singlefire
	--TODO: self.parts.wpn_fps_upg_i_autofire
	--Make these replace the related fire mode with burst fire. Add them to exclude tables on guns that already have burst fire.
	apply_stats(self.parts.wpn_fps_upg_m4_g_hgrip, left_grip) --Rubber Grip
	apply_stats(self.parts.wpn_fps_upg_m4_g_mgrip, cosmetic) --Straight Grip
end

orig_init_content_dlc2_dec16 = WeaponFactoryTweakData._init_content_dlc2_dec16
function WeaponFactoryTweakData:_init_content_dlc2_dec16()
	orig_init_content_dlc2_dec16(self)
	--TODO: Go over these!
	--apply_stats(self.parts.wpn_fps_upg_o_acog, cosmetic) --Acough Optic Scope
end


orig_init_content_jobs = WeaponFactoryTweakData._init_content_jobs
function WeaponFactoryTweakData:_init_content_jobs()
	orig_init_content_jobs(self)
	apply_stats(self.parts.wpn_fps_pis_rage_extra, cosmetic) --Bronco Scope Mount
	apply_stats(self.parts.wpn_fps_pis_deagle_extra, cosmetic) --Deagle Scope Mount
	apply_stats(self.parts.wpn_fps_upg_fg_jp, horizontal_grip) --Competition Foregrip
	apply_stats(self.parts.wpn_fps_upg_fg_smr, vertical_grip) --Gazelle Rail
	apply_stats(self.parts.wpn_fps_upg_m4_m_quad, quadstacked_mag) --CAR Quadstacked Mag
	apply_stats(self.parts.wpn_fps_upg_ak_fg_tapco, vertical_grip) --Battleproven Handguard
	apply_stats(self.parts.wpn_fps_upg_fg_midwest, horizontal_grip) --Lightweight Rail
	apply_stats(self.parts.wpn_fps_upg_ak_b_draco, heavy_mob_barrel) --AK Slavic Dragon Barrel
	apply_stats(self.parts.wpn_fps_upg_ak_m_quad, quadstacked_mag) --AK Quadstacked Mag
	apply_stats(self.parts.wpn_fps_upg_ak_g_hgrip, left_grip) --AK Rubber Grip
	apply_stats(self.parts.wpn_fps_upg_ak_g_pgrip, horizontal_grip) --Ak Plastic Grip
	apply_stats(self.parts.wpn_fps_upg_ak_g_wgrip, right_grip) --AK Wood Grip
	apply_stats(self.parts.wpn_fps_upg_ass_ns_jprifles, heavy_stab_ext) --Competitors Compensator
	apply_stats(self.parts.wpn_fps_upg_ass_ns_linear, heavy_acc_ext, loudener) --Funnel of Fun Nozzle
	apply_stats(self.parts.wpn_fps_upg_ass_ns_surefire, light_stab_ext) --Tactical Compensator
	apply_stats(self.parts.wpn_fps_upg_pis_ns_flash, flash_hider) --Flash Hider
	apply_stats(self.parts.wpn_fps_upg_shot_ns_king, heavy_acc_ext) --King's Crown Compensator
	apply_stats(self.parts.wpn_fps_upg_ns_pis_medium_slim, suppressor, heavy_stab_ext) --Asepsis Suppressor
	apply_stats(self.parts.wpn_fps_upg_fl_ass_peq15, cosmetic) --Military Laser Module
	apply_stats(self.parts.wpn_fps_upg_m4_s_crane, light_stab_stock) --Wide Stock
	apply_stats(self.parts.wpn_fps_upg_m4_s_mk46, light_stab_stock) --War-Torn Stock
	--apply_stats(self.parts.wpn_fps_upg_o_rmr, cosmetic) --Pistol Red Dot Sight
	--apply_stats(self.parts.wpn_fps_upg_o_eotech_xps, cosmetic) --Compact Holosight
	--apply_stats(self.parts.wpn_fps_upg_o_reflex, cosmetic) --Speculator Sight
	--apply_stats(self.parts.wpn_fps_upg_o_rx01, cosmetic) --Trigonom Sight
	--apply_stats(self.parts.wpn_fps_upg_o_rx30, cosmetic) --Solar Sight
	--apply_stats(self.parts.wpn_fps_upg_o_cs, cosmetic) --Combat Sight
end

local orig_init_butchermodpack = WeaponFactoryTweakData._init_butchermodpack
function WeaponFactoryTweakData:_init_butchermodpack()
	orig_init_butchermodpack(self)
	apply_stats(self.parts.wpn_fps_upg_fl_ass_utg, cosmetic) --LED Combo
	apply_stats(self.parts.wpn_fps_upg_fl_pis_m3x, cosmetic) --Polymer Flashlight
	apply_stats(self.parts.wpn_fps_upg_ass_ns_battle, heavy_acc_ext, flash_hider) --Ported Compensator
	apply_stats(self.parts.wpn_fps_upg_ns_ass_filter, suppressor, bulky_gadget) --Budget Suppressor
	apply_stats(self.parts.wpn_fps_upg_ns_ass_jungle, suppressor, heavy_stab_ext) --Jungle Ninja Suppressor

end

local orig_init_m4 = WeaponFactoryTweakData._init_m4
function WeaponFactoryTweakData:_init_m4()
	orig_init_m4(self)
	apply_stats(self.parts.wpn_fps_m4_upper_reciever_edge, cosmetic) --Exotique Receiver
	apply_stats(self.parts.wpn_fps_m4_uupg_b_long, light_acc_barrel) --Long Barrel
	apply_stats(self.parts.wpn_fps_m4_uupg_b_short, light_mob_barrel) --Short Barrel
	apply_stats(self.parts.wpn_fps_m4_uupg_b_medium, light_acc_barrel) --Medium Barrel (Para)
	apply_stats(self.parts.wpn_fps_m4_uupg_b_sd, suppressor, light_stab_ext, light_acc_barrel) --Stealth Barrel
	apply_stats(self.parts.wpn_fps_m4_uupg_fg_lr300, horizontal_grip) --Aftermarket Special Handguard
	apply_stats(self.parts.wpn_fps_m4_uupg_m_std, cosmetic) --Milspec Mag
	apply_stats(self.parts.wpn_fps_m4_uupg_s_fold, heavy_mob_stock) --Folding Stock
	apply_stats(self.parts.wpn_fps_upg_m4_g_ergo, left_grip) --Ergo Grip
	apply_stats(self.parts.wpn_fps_upg_m4_g_sniper, vertical_grip) --Pro Grip
	apply_stats(self.parts.wpn_fps_upg_m4_m_pmag, cosmetic) --Tactical Mag
	apply_stats(self.parts.wpn_fps_upg_m4_m_straight, vintage_mag) --Vintage Magazine
	apply_stats(self.parts.wpn_fps_upg_m4_s_standard, light_stab_stock) --Standard Stock
	apply_stats(self.parts.wpn_fps_upg_m4_s_pts, heavy_stab_stock) --Tactical Stock
	apply_stats(self.parts.wpn_fps_m4_upg_fg_mk12, heavy_acc_barrel, suppressor, vertical_grip) --Longbore Exclusive Set
end
--Stakeout
local orig_init_aa12 = WeaponFactoryTweakData._init_aa12
function WeaponFactoryTweakData:_init_aa12()
	orig_init_aa12(self)
	apply_stats(self.parts.wpn_fps_sho_aa12_barrel_long, light_acc_barrel) --Long Barrel
	apply_stats(self.parts.wpn_fps_sho_aa12_barrel_silenced, light_acc_barrel, suppressor) --Suppressed Barrel
	apply_shotgun_ammo_types(self.wpn_fps_sho_aa12, "light")
end

--Izhma
local orig_init_saiga = WeaponFactoryTweakData._init_saiga
function WeaponFactoryTweakData:_init_saiga()
	orig_init_saiga(self)
	apply_stats(self.parts.wpn_fps_sho_saiga_b_short, light_mob_barrel) --Short Barrel
	apply_stats(self.parts.wpn_upg_saiga_fg_lowerrail, cosmetic) --Tactical Russian Rail
	apply_shotgun_ammo_types(self.wpn_fps_shot_saiga, "light")
end

--Predator
local orig_init_spas12 = WeaponFactoryTweakData._init_spas12
function WeaponFactoryTweakData:_init_spas12()
	orig_init_spas12(self)
	apply_stats(self.parts.wpn_fps_sho_s_spas12_folded, light_mob_stock) --Folded Stock
	apply_stats(self.parts.wpn_fps_sho_s_spas12_solid, light_stab_stock) --Solid Stock
	apply_stats(self.parts.wpn_fps_sho_s_spas12_nostock, heavy_mob_stock) --No Stock
	apply_shotgun_ammo_types(self.wpn_fps_sho_spas12, "light")
end

--M1014
local orig_init_ben = WeaponFactoryTweakData._init_ben
function WeaponFactoryTweakData:_init_ben()
	orig_init_ben(self)
	apply_stats(self.parts.wpn_fps_sho_ben_b_short, light_mob_barrel) --Short Barrel
	apply_stats(self.parts.wpn_fps_sho_ben_b_long, light_acc_barrel) --Long Barrel
	apply_stats(self.parts.wpn_fps_sho_ben_s_collapsed, light_mob_stock) --Collapsed Stock
	apply_stats(self.parts.wpn_fps_sho_ben_s_solid, light_stab_stock) --Tactical Stock
	apply_shotgun_ammo_types(self.wpn_fps_sho_ben, "light")
end

--Street Sweeper
local orig_init_striker = WeaponFactoryTweakData._init_striker
function WeaponFactoryTweakData:_init_striker()
	orig_init_striker(self)
	apply_stats(self.parts.wpn_fps_sho_striker_b_long, light_acc_barrel) --Long Barrel
	apply_stats(self.parts.wpn_fps_sho_striker_b_suppressed, light_acc_barrel, suppressor) --Suppressed Barrel
	apply_shotgun_ammo_types(self.wpn_fps_sho_striker, "light")
end

--Brother's Grimm
local orig_init_x_basset = WeaponFactoryTweakData._init_x_basset
function WeaponFactoryTweakData:_init_x_basset()
	orig_init_x_basset(self)
	apply_shotgun_ammo_types(self.wpn_fps_sho_x_basset, "light")
end

--Akimbo Judge
local orig_init_x_judge = WeaponFactoryTweakData._init_x_judge
function WeaponFactoryTweakData:_init_x_judge()
	orig_init_x_judge(self)
	apply_shotgun_ammo_types(self.wpn_fps_pis_x_judge, "light")
end

--Goliath
local orig_init_rota = WeaponFactoryTweakData._init_rota
function WeaponFactoryTweakData:_init_rota()
	orig_init_rota(self)
	apply_stats(self.parts.wpn_fps_sho_rota_b_short, light_mob_barrel) --Short Barrel
	apply_stats(self.parts.wpn_fps_sho_rota_b_silencer, cosmetic, suppressor) --Silenced Barrel
	apply_shotgun_ammo_types(self.wpn_fps_sho_rota, "light")
end

--Argos 3
local orig_init_ultima = WeaponFactoryTweakData._init_ultima
function WeaponFactoryTweakData:_init_ultima()
	orig_init_ultima(self)
	apply_stats(self.parts.wpn_fps_sho_ultima_body_kit, cosmetic, bulky_gadget) --Triple Tech Threat
	apply_stats(self.parts.wpn_fps_sho_ultima_body_rack, shell_rack) --ShellSwitch M8 Ammo Cashe
	apply_stats(self.parts.wpn_fps_sho_ultima_s_light, light_stab_stock) --Flak Frame Null Stock
	apply_shotgun_ammo_types(self.wpn_fps_sho_ultima, "light")
end

--Judge
local orig_init_judge = WeaponFactoryTweakData._init_judge
function WeaponFactoryTweakData:_init_judge()
	orig_init_judge(self)
	apply_shotgun_ammo_types(self.wpn_fps_pis_judge, "light")
end

--Grimm
local orig_init_basset = WeaponFactoryTweakData._init_basset
function WeaponFactoryTweakData:_init_basset()
	orig_init_basset(self)
	apply_stats(self.parts.wpn_fps_sho_basset_fg_short, light_mob_barrel) --Little Brother Foregrip
	apply_shotgun_ammo_types(self.wpn_fps_sho_basset, "light")
end

--Reinfeld 880
local orig_init_r870 = WeaponFactoryTweakData._init_r870
function WeaponFactoryTweakData:_init_r870()
	orig_init_r870(self)
	apply_stats(self.parts.wpn_fps_shot_r870_fg_wood, cosmetic) --Zombie Hunter Pump
	apply_stats(self.parts.wpn_fps_shot_r870_s_nostock, heavy_mob_stock) --Short Enough Stock
	apply_stats(self.parts.wpn_fps_shot_r870_s_nostock_big, heavy_mob_stock) --Short Enough Tactical Stock
	apply_stats(self.parts.wpn_fps_shot_r870_s_solid_big, cosmetic) --Government Issue Tactical Stock
	apply_stats(self.parts.wpn_fps_shot_r870_s_folding, light_mob_stock) --Muldon Stock
	apply_stats(self.parts.wpn_fps_shot_r870_body_rack, shell_rack) --Shell Rack
	apply_shotgun_ammo_types(self.wpn_fps_shot_r870, "medium")
end

--Mosconi 12G Tactical
local orig_init_m590 = WeaponFactoryTweakData._init_m590
function WeaponFactoryTweakData:_init_m590()
	orig_init_m590(self)
	apply_stats(self.parts.wpn_fps_sho_m590_b_long, light_acc_barrel) --CE Extender
	apply_stats(self.parts.wpn_fps_sho_m590_b_suppressor, light_acc_barrel, suppressor) --CE Muffler
	apply_stats(self.parts.wpn_fps_sho_m590_body_rail, light_stab_stock) --CE Rail Stabilizer
	apply_shotgun_ammo_types(self.wpn_fps_sho_m590, "medium")
end

--Raven
local orig_init_ksg = WeaponFactoryTweakData._init_ksg
function WeaponFactoryTweakData:_init_ksg()
	orig_init_ksg(self)
	apply_stats(self.parts.wpn_fps_sho_ksg_b_short, light_mob_barrel) --Short Barrel
	apply_stats(self.parts.wpn_fps_sho_ksg_b_long, light_acc_barrel) --Long Barrel
	apply_shotgun_ammo_types(self.wpn_fps_sho_ksg, "medium")
end

--Reinfeld 88
local orig_init_m1897 = WeaponFactoryTweakData._init_m1897
function WeaponFactoryTweakData:_init_m1897()
	orig_init_m1897(self)
	apply_stats(self.parts.wpn_fps_shot_m1897_b_long, light_acc_barrel) --Huntsman Barrel
	apply_stats(self.parts.wpn_fps_shot_m1897_b_short, light_mob_barrel) --Ventilated Barrel
	apply_stats(self.parts.wpn_fps_shot_m1897_s_short, light_mob_stock) --Artisan Stock
	apply_shotgun_ammo_types(self.wpn_fps_shot_m1897, "medium")
end

--Breaker
local orig_init_boot = WeaponFactoryTweakData._init_boot
function WeaponFactoryTweakData:_init_boot()
	orig_init_boot(self)
	apply_stats(self.parts.wpn_fps_sho_boot_b_long, light_acc_barrel) --Long Barrel
	apply_stats(self.parts.wpn_fps_sho_boot_b_short, light_mob_barrel) --Short Barrel
	apply_stats(self.parts.wpn_fps_sho_boot_body_exotic, cosmetic) --Treated Body
	apply_stats(self.parts.wpn_fps_sho_boot_s_long, heavy_stab_stock) --Long Stock
	apply_shotgun_ammo_types(self.wpn_fps_sho_boot, "medium")
end

--Locomotive
local orig_init_serbu = WeaponFactoryTweakData._init_serbu
function WeaponFactoryTweakData:_init_serbu()
	orig_init_serbu(self)
	apply_stats(self.parts.wpn_fps_shot_r870_s_solid, heavy_stab_stock) --Standard Stock
	apply_stats(self.parts.wpn_fps_shot_shorty_s_solid_short, heavy_stab_stock) --Police Shorty Stock
	apply_stats(self.parts.wpn_fps_shot_shorty_s_nostock_short, cosmetic) --Tactical Shorty Stock
	apply_shotgun_ammo_types(self.wpn_fps_shot_serbu, "medium")
end

--GSPS
local orig_init_m37 = WeaponFactoryTweakData._init_m37
function WeaponFactoryTweakData:_init_m37()
	orig_init_m37(self)
	apply_stats(self.parts.wpn_fps_shot_m37_b_short, light_mob_barrel) --Riot Barrel
	apply_stats(self.parts.wpn_fps_shot_m37_s_short, light_mob_stock) --Stakeout Stock
	apply_shotgun_ammo_types(self.wpn_fps_shot_m37, "medium")
end

--Mosconi
local orig_init_huntsman = WeaponFactoryTweakData._init_huntsman
function WeaponFactoryTweakData:_init_huntsman()
	orig_init_huntsman(self)
	apply_stats(self.parts.wpn_fps_shot_huntsman_b_short, heavy_mob_barrel) --Road Warrior Barrel
	apply_stats(self.parts.wpn_fps_shot_huntsman_s_short, heavy_mob_stock) --Gangsta Special Stock
	apply_shotgun_ammo_types(self.wpn_fps_shot_huntsman, "heavy")
end

--Joceline O/U
local orig_init_b682 = WeaponFactoryTweakData._init_b682
function WeaponFactoryTweakData:_init_b682()
	orig_init_b682(self)
	apply_stats(self.parts.wpn_fps_shot_b682_b_short, heavy_mob_barrel) --Sawed Off Barrel
	apply_stats(self.parts.wpn_fps_shot_b682_s_ammopouch, shell_rack) --Luxurious Ammo Pouch
	apply_stats(self.parts.wpn_fps_shot_b682_s_short, heavy_mob_stock) --Wrist Wrecker Stock
	apply_shotgun_ammo_types(self.wpn_fps_shot_b682, "heavy")
end

--Claire
local orig_init_coach = WeaponFactoryTweakData._init_coach
function WeaponFactoryTweakData:_init_coach()
	orig_init_coach(self)
	apply_stats(self.parts.wpn_fps_sho_coach_b_short, heavy_mob_barrel) --Sawed Off Barrel
	apply_stats(self.parts.wpn_fps_sho_coach_s_short, heavy_mob_stock) --Deadman's Stock
	apply_shotgun_ammo_types(self.wpn_fps_sho_coach, "heavy")
end

--Type 54
local orig_init_type54 = WeaponFactoryTweakData._init_type54
function WeaponFactoryTweakData:_init_type54()
	orig_init_type54(self)
	apply_stats(self.parts.wpn_fps_pis_type54_underbarrel, {
		stats = {
			total_ammo_mod = -50,
			value = 6,
			recoil = -1,
			concealment = -2
		},
		custom_stats = {
			ammo_pickup_max_mul = 0.5,
			ammo_pickup_min_mul = 0.5
		},
		heat_stat_table = "type54_underbarrel"
	})
end

--VD 12
orig_init_sko12 = WeaponFactoryTweakData._init_sko12
function WeaponFactoryTweakData:_init_sko12()
	orig_init_sko12(self)
	apply_stats(self.parts.wpn_fps_sho_sko12_b_long, light_acc_barrel) --Long Barrel
	apply_stats(self.parts.wpn_fps_sho_sko12_b_short, light_mob_barrel) --Short Barrel
	apply_stats(self.parts.wpn_fps_sho_sko12_fg_railed, cosmetic) --Front Mounting Rail
	apply_stats(self.parts.wpn_fps_sho_sko12_body_grip, cosmetic) --VD12 Grip
	apply_stats(self.parts.wpn_fps_sho_sko12_stock, light_stab_stock) --VD12 Stock
	apply_stats(self.parts.wpn_fps_sho_sko12_stock_conversion, light_stab_stock) --VD12 Stock (Exclusive Set)
	apply_stats(self.parts.wpn_fps_sho_sko12_conversion, cosmetic) --Exclusive Set
	apply_shotgun_ammo_types(self.wpn_fps_sho_sko12, "vd12")
end

--GL 40
local orig_init_gre_m79 = WeaponFactoryTweakData._init_gre_m79
function WeaponFactoryTweakData:_init_gre_m79()
	orig_init_gre_m79(self)
	apply_stats(self.parts.wpn_fps_gre_m79_barrel_short, heavy_mob_barrel) --Pirate Barrel
	apply_stats(self.parts.wpn_fps_gre_m79_stock_short, light_mob_stock) --Sawed off stock.
end

--Piglet
local orig_init_m32 = WeaponFactoryTweakData._init_m32
function WeaponFactoryTweakData:_init_m32()
	orig_init_m32(self)
	apply_stats(self.parts.wpn_fps_gre_m32_barrel_short, light_mob_barrel) --Short Barrel
end

--China Puff
local orig_init_china = WeaponFactoryTweakData._init_china
function WeaponFactoryTweakData:_init_china()
	orig_init_china(self)
	apply_stats(self.parts.wpn_fps_gre_china_s_short, light_mob_stock) --Riot Stock
end

--Arbiter
local orig_init_arbiter = WeaponFactoryTweakData._init_arbiter
function WeaponFactoryTweakData:_init_arbiter()
	orig_init_arbiter(self)
	apply_stats(self.parts.wpn_fps_gre_arbiter_b_long, heavy_acc_barrel) --Bombardier Barrel
	apply_stats(self.parts.wpn_fps_gre_arbiter_b_comp, light_acc_barrel) --Long Barrel
end

--Pistol Crossbow
local orig_init_hunter = WeaponFactoryTweakData._init_hunter
function WeaponFactoryTweakData:_init_hunter()
	orig_init_hunter(self)
	apply_stats(self.parts.wpn_fps_bow_hunter_b_carbon, light_acc_barrel) --Carbon Limb
	apply_stats(self.parts.wpn_fps_bow_hunter_b_skeletal, light_mob_barrel) --Skeletal Limb
	apply_stats(self.parts.wpn_fps_bow_hunter_g_camo, cosmetic) --Camo Grip
	apply_stats(self.parts.wpn_fps_bow_hunter_g_walnut, cosmetic) --Walnut Grip
	apply_stats(self.parts.wpn_fps_upg_a_crossbow_explosion, light_explosive_arrow) --Explosive Bolt
	apply_stats(self.parts.wpn_fps_upg_a_crossbow_poison, poison_arrow, light_bow_poison) --Poison Bolt
end

--Heavy Crossbow
local orig_init_arblast = WeaponFactoryTweakData._init_arblast
function WeaponFactoryTweakData:_init_arblast()
	orig_init_arblast(self)
	apply_stats(self.parts.wpn_fps_bow_arblast_m_explosive, heavy_explosive_arrow) --Explosive Bolt
	apply_stats(self.parts.wpn_fps_bow_arblast_m_poison, poison_arrow, heavy_bow_poison) --Poison Bolt
end

--Light Crossbow
local orig_init_frankish = WeaponFactoryTweakData._init_frankish
function WeaponFactoryTweakData:_init_frankish()
	orig_init_frankish(self)
	apply_stats(self.parts.wpn_fps_bow_frankish_m_explosive, light_explosive_arrow) --Explosive Bolt
	apply_stats(self.parts.wpn_fps_bow_frankish_m_poison, poison_arrow, light_bow_poison) --Poison Bolt
end

--Airbow
local orig_init_ecp = WeaponFactoryTweakData._init_ecp
function WeaponFactoryTweakData:_init_ecp()
	orig_init_ecp(self)
	apply_stats(self.parts.wpn_fps_bow_ecp_s_bare, heavy_mob_stock) --Light Stock
	apply_stats(self.parts.wpn_fps_bow_ecp_m_arrows_explosive, light_explosive_arrow) --Explosive Bolt
	apply_stats(self.parts.wpn_fps_bow_ecp_m_arrows_poison, poison_arrow, light_bow_poison) --Poison Bolt
end

--Plainsrider
local orig_init_plainsrider = WeaponFactoryTweakData._init_plainsrider
function WeaponFactoryTweakData:_init_plainsrider()
	orig_init_plainsrider(self)
	apply_stats(self.parts.wpn_fps_upg_a_bow_explosion, light_explosive_arrow) --Explosive Arrows
	apply_stats(self.parts.wpn_fps_upg_a_bow_poison, poison_arrow, light_bow_poison) --Poisoned Arrows
end

--English Longbow
local orig_init_long = WeaponFactoryTweakData._init_long
function WeaponFactoryTweakData:_init_long()
	orig_init_long(self)
	apply_stats(self.parts.wpn_fps_bow_long_m_explosive, heavy_explosive_arrow) --Explosive Arrows
	apply_stats(self.parts.wpn_fps_bow_long_m_poison, poison_arrow, heavy_bow_poison) --Poisoned Arrows
end

--DECA Technologies Compound Bow
local orig_init_elastic = WeaponFactoryTweakData._init_elastic
function WeaponFactoryTweakData:_init_elastic()
	orig_init_elastic(self)
	apply_stats(self.parts.wpn_fps_bow_elastic_g_2, cosmetic) --Wooden Grip
	apply_stats(self.parts.wpn_fps_bow_elastic_g_3, cosmetic) --Ergonomic Grip
	apply_stats(self.parts.wpn_fps_bow_elastic_body_tactic, heavy_mob_barrel) --Tactical Frame
	apply_stats(self.parts.wpn_fps_bow_elastic_m_explosive, heavy_explosive_arrow) --Explosive Arrows
	apply_stats(self.parts.wpn_fps_bow_elastic_m_poison, poison_arrow, heavy_bow_poison) --Poisoned Arrows
end

--Flamethrower Mk1
local orig_init_flamethrower_mk2 = WeaponFactoryTweakData._init_flamethrower_mk2
function WeaponFactoryTweakData:_init_flamethrower_mk2()
	orig_init_flamethrower_mk2(self)
	apply_stats(self.parts.wpn_fps_fla_mk2_mag_rare, rare_tank) --Rare
	apply_stats(self.parts.wpn_fps_fla_mk2_mag_welldone, well_done_tank) --Well Done
end

--MA-17 Flamethrower
local orig_init_system = WeaponFactoryTweakData._init_system
function WeaponFactoryTweakData:_init_system()
	orig_init_system(self)
	apply_stats(self.parts.wpn_fps_fla_system_b_wtf, cosmetic) --Merlin Barrel
	apply_stats(self.parts.wpn_fps_fla_system_m_high, well_done_tank) --High Temperature Mixture
	apply_stats(self.parts.wpn_fps_fla_system_m_low, rare_tank) --Low Temperature Mixture
end

--Hailstorm
local orig_init_hailstorm = WeaponFactoryTweakData._init_hailstorm
function WeaponFactoryTweakData:_init_hailstorm()
	orig_init_hailstorm(self)
	apply_stats(self.parts.wpn_fps_hailstorm_b_extended, light_acc_barrel, flash_hider) --V1.4 Barrel
	apply_stats(self.parts.wpn_fps_hailstorm_b_suppressed, light_acc_barrel, suppressor) --V2.2 Barrel
	apply_stats(self.parts.wpn_fps_hailstorm_b_ext_suppressed, heavy_acc_barrel, suppressor) --V3.8 Barrel
	apply_stats(self.parts.wpn_fps_hailstorm_conversion, light_stab_stock, light_stab_ext, light_acc_barrel) --Prototype Exclusive Set
	apply_stats(self.parts.wpn_fps_hailstorm_g_crystal, cosmetic) --Crystalline Grip
	apply_stats(self.parts.wpn_fps_hailstorm_g_noise, cosmetic) --FRZA Grip
	apply_stats(self.parts.wpn_fps_hailstorm_g_bubble, cosmetic) --Whiteout Grip
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
		light_stab_ext
	)

	self.parts.wpn_fps_upg_bonus_recoil_p1 = make_boost(
		"bm_menu_bonus_spread_p2_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_damage_p1_sc",
		heavy_stab_ext
	)

	self.parts.wpn_fps_upg_bonus_team_exp_money_p3 = make_boost(
		"bm_menu_bonus_recoil_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_recoil_p1_sc",
		light_acc_ext
	)

	self.parts.wpn_fps_upg_bonus_total_ammo_p3 = make_boost(
		"bm_menu_bonus_recoil_p1_mod",
		"guis/dlcs/boost_in_lootdrop/textures/pd2/blackmarket/icons/mods/wpn_fps_upg_bonus_total_ammo_p1_sc",
		heavy_acc_ext
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
function WeaponFactoryTweakData:create_ammunition()
	orig_create_ammunition(self)

	--Generic incendiary ammo.
	--See enveffecttweakdata.lua for remaining stats on GL incendiary ammo.
	self.parts.wpn_fps_upg_a_grenade_launcher_incendiary.supported = true
	self.parts.wpn_fps_upg_a_grenade_launcher_incendiary.stats = {damage = -180}

	--Generic electric ammo.
	self.parts.wpn_fps_upg_a_grenade_launcher_electric.supported = true
	self.parts.wpn_fps_upg_a_grenade_launcher_electric.stats = {damage = -100}

	--Generic poison ammo
	self.parts.wpn_fps_upg_a_grenade_launcher_poison.supported = true
	self.parts.wpn_fps_upg_a_grenade_launcher_poison.stats = {damage = -100}

	--Arbiter incendiary ammo.
	self.parts.wpn_fps_upg_a_grenade_launcher_incendiary_arbiter.supported = true
	self.parts.wpn_fps_upg_a_grenade_launcher_incendiary_arbiter.stats = {damage = -134}

	--Arbiter electric ammo
	self.parts.wpn_fps_upg_a_grenade_launcher_electric_arbiter.supported = true
	self.parts.wpn_fps_upg_a_grenade_launcher_electric_arbiter.stats = {damage = -70}

	--Arbiter Poison Ammo
	self.parts.wpn_fps_upg_a_grenade_launcher_poison_arbiter.supported = true
	self.parts.wpn_fps_upg_a_grenade_launcher_poison_arbiter.stats = {damage = -70}

	self.parts.wpn_fps_upg_a_underbarrel_frag_groza.supported = true
	self.parts.wpn_fps_upg_a_underbarrel_electric.supported = true
	self.parts.wpn_fps_upg_a_underbarrel_poison.supported = true

	--Type 54 Underbarrel Ammo Types
	self.parts.wpn_fps_upg_a_slug_underbarrel.custom_stats = deep_clone(slug.custom_stats)
	self.parts.wpn_fps_upg_a_slug_underbarrel.custom_stats.underbarrel_stats = deep_clone(slug.stats)
	self.parts.wpn_fps_upg_a_slug_underbarrel.custom_stats.underbarrel_stats.damage = slug_damage.heavy
	self.parts.wpn_fps_upg_a_slug_underbarrel.desc_id = slug.desc_id
	self.parts.wpn_fps_upg_a_slug_underbarrel.supported = true

	self.parts.wpn_fps_upg_a_piercing_underbarrel.custom_stats = deep_clone(flechette.custom_stats)
	self.parts.wpn_fps_upg_a_piercing_underbarrel.custom_stats.underbarrel_stats = deep_clone(flechette.stats)
	self.parts.wpn_fps_upg_a_piercing_underbarrel.custom_stats.dot_data.custom_data.dot_length = shotgun_dot_damage.heavy
	self.parts.wpn_fps_upg_a_piercing_underbarrel.desc_id = slug.desc_id
	self.parts.wpn_fps_upg_a_piercing_underbarrel.supported = true
end
