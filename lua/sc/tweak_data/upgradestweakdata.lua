 --[[

DON'T MODIFY ME IF YOU'RE NOT A DEVELOPER!!!  THANK YOU!!!!!!!!!

]]--

function UpgradesTweakData:_init_value_tables()
	self.values = {
		player = {},
		carry = {},
		trip_mine = {},
		ammo_bag = {},
		ecm_jammer = {},
		sentry_gun = {},
		doctor_bag = {},
		cable_tie = {},
		bodybags_bag = {},
		first_aid_kit = {},
		weapon = {},
		pistol = {},
		assault_rifle = {},
		smg = {},
		shotgun = {},
		grenade_launcher = {},
		bow = {},
		crossbow = {},
		saw = {},
		lmg = {},
		snp = {},
		akimbo = {},
		minigun = {},
		melee = {},
		temporary = {},
		cooldown = {},
		team = {}
	}
	self.values.team.player = {}
	self.values.team.weapon = {}
	self.values.team.pistol = {}
	self.values.team.akimbo = {}
	self.values.team.xp = {}
	self.values.team.armor = {}
	self.values.team.stamina = {}
	self.values.team.health = {}
	self.values.team.cash = {}
	self.values.team.damage_dampener = {}
end

Hooks:PostHook(UpgradesTweakData, "init", "ResLevelTableInit", function(self, tweak_data)
	local level = {
		l2 = {
				name_id = "weapons",
				upgrades = {
					"colt_1911",
					"mac10",
					"hajk",
					"spoon"
				}
			},	
		l10 = {
				name_id = "lvl_10",
				upgrades = {
					"cutters",
					"shawn"
				}
			},	
		l12 = {
				name_id = "body_armor3",
				upgrades = {
					"body_armor3",
					"cobray",
					"boxcutter",
					"groza",
					"groza_underbarrel",
					"m590"
				}
			},			
		l14 = {
				name_id = "weapons",
				upgrades = {
					"bayonet",
					"m1928",
					"sparrow",
					"gator",
					"pl14"
				}
			},
		l15 = {
				name_id = "weapons",
				upgrades = {
					"msr",
					"benelli",
					"plainsrider",
					"sub2000",
					"road",
					"legacy",
					"fmg9"
				}
			},
		l18 = {
				name_id = "weapons",
				upgrades = {
					"baseballbat",
					"scorpion",
					"oldbaton",
					"hockey",
					"meter",
					"hauteur",
					"shock",
					"fear"
				}
			},
		l19 = {
				name_id = "weapons",
				upgrades = {
					"olympic",
					"mp9",
					"baka",
					"pugio",
					"ballistic",
					"maxim9",
					"scout",
					"korth"
				}
			},
		l20 = {
				name_id = "lvl_20",
				upgrades = {
					"schakal",
					"agave",
					"happy",
					"shepheard",
					"slap"
				}
			},
		l23 = {
				name_id = "weapons",
				upgrades = {
					"bullseye",
					"c96",
					"par",
					"m37",
					"rota",
					"cs",
					"brick",
					"ostry",
					"r700"
				}
			},
		l25 = {
				name_id = "weapons",
				upgrades = {
					"boxing_gloves",
					"meat_cleaver",
					"wpn_prj_four",
					"sr2",
					"grip",
					"push",
					"breech",
					"ching",
					"erma",
					"sap"
				}
			},
		l26 = {
			name_id = "weapons",
			upgrades = {
				"new_m14",
				"saiga",
				"sandsteel",
				"packrat",
				"lemming",
				"rsh12",
				"chinchilla",
				"model3",
				"sbl",
				"m1897",
				"x_model3"
			}
		},
		l27 = {
				name_id = "weapons",
				upgrades = {
					"famas",
					"g26",
					"twins",
					"pitchfork",
					"shrew",
					"x_shrew",
					"basset"
				}
			},
		l28 = {
				name_id = "weapons",
				upgrades = {
					"hs2000",
					"vhs",
					"bowie",
					"micstand",
					"qbu88",
					"contender"
				}
			},
		l29 = {
			name_id = "weapons",
			upgrades = {
				"akmsu",
				"glock_18c",
				"asval",
				"long",
				"x_beer",
				"beer",
				"x_czech",
				"czech",
				"x_stech",
				"stech"
			}
		},
		l30 = {
				name_id = "lvl_30",
				upgrades = {
					"shuno",
					"holt"
				}
			},
		l32 = {
				name_id = "weapons",
				upgrades = {
					"x46",
					"tec9",
					"tiger",
					"model70"
				}
			},
		l35 = {
			name_id = "weapons",
			upgrades = {
				"r93",
				"judge",
				"mining_pick",
				"wing"
			}
		},
		l36 = {
				name_id = "weapons",
				upgrades = {
					"p90",
					"deagle",
					"winchester1874"
				}
			},
		l39 = {
				name_id = "weapons",
				upgrades = {
					"m16",
					"huntsman",
					"polymer",
					"china"
				}
			},
		l40 = {
				name_id = "lvl_40",
				upgrades = {
					"shak12",
					"body_armor6"
				}
			},
		l42 = {
				name_id = "weapons",
				upgrades = {
					"fal",
					"tomahawk",
					"coal"
				}
			},
		l50 = {
				name_id = "lvl_50",
				upgrades = {
					"halloween_sword",
					"tkb"
				}
			},
		l51 = {
				name_id = "weapons",
				upgrades = {
					"machete",
					"sterling"
				}
			},
		l55 = {
				name_id = "weapons",
				upgrades = {
					"uzi"
				}
			},
		l60 = {
				name_id = "lvl_60",
				upgrades = {}
			},
		l70 = {
				name_id = "lvl_70",
				upgrades = {}
			},
		l80 = {
				name_id = "lvl_80",
				upgrades = {}
			},
		l90 = {
				name_id = "lvl_90",
				upgrades = {}
			},
		l100 = {
				name_id = "lvl_100",
				upgrades = {}
			}			
	}

	--Insert level variables into level_tree.
	for i=1, 100 do
		local currLevel = level["l" .. tostring(i)]
		if currLevel then
			self.level_tree[i] = currLevel
		end
	end 	
end)
Hooks:PostHook(UpgradesTweakData, "_melee_weapon_definitions", "ResMeleeDef", function(self)
	self.definitions.halloween_sword = {
		dlc = "rest",
		category = "melee_weapon"
	}
end)

--Upgrade Value changes for skills and such--
Hooks:PostHook(UpgradesTweakData, "_init_pd2_values", "ResSkillsInit", function(self)
	--Used by Shotgun skills, Rifle Skills, Infiltrator, and Sociopath
	self.close_combat_data = {
		distance = 800,
		polling_rate = 0.25
	}

	--Explosives hurt--
	self.explosive_bullet.curve_pow = 0.75
	self.explosive_bullet.player_dmg_mul = 0.5
	self.explosive_bullet.range = 150
	self.explosive_bullet.feedback_range = self.explosive_bullet.range
	self.explosive_bullet.camera_shake_max_mul = 4

	--Weapon Based Movement Modifiers--
	self.weapon_movement_penalty.minigun = 0.75
	self.weapon_movement_penalty.lmg = 0.75

	--Armor Stats--
	--Add 20 to the values in this table to get in game amounts.
	self.values.player.body_armor.armor = {
		0.5, --Suit
		4, --LBV
		6, --BV
		8, --HBV
		10, --Flak
		13, --CTV
		18 --ICTV
	}
	
	self.values.player.body_armor.dodge = {
		0.25,
		0.15,
		0.05,
		0.0,
		-0.05,
		-0.1,
		-0.15
	}
	self.values.player.body_armor.concealment = {
		34,
		31,
		27,
		23,
		19,
		15,
		11
	}
	self.values.player.body_armor.damage_shake = { 
		1, 
		0.95, 
		0.9, 
		0.85, 
		0.75, 
		0.7, 
		0.6 
	}
	self.values.player.body_armor.stamina = {
		20,
		20,
		20,
		20,
		20,
		20,
		20
	}
	--Appears to be unused.
	self.values.player.body_armor.skill_ammo_mul = {
		1,
		1.02,
		1.04,
		1.06,
		1.8,
		1.1,
		1.12
	}
	self.values.player.body_armor.deflection = {
		0.00,
		0.05,
		0.10,
		0.15,
		0.20,
		0.15,
		0.10
	}
	self.values.player.body_armor.movement = {
		350/350,
		340/350,
		330/350,
		320/350,
		310/350,
		300/350,
		290/350
	}

	self.values.rep_upgrades.values = {0}
	
	--Custom stuff for SC's mod, mainly suppression resistance and stuff--
	self.values.player.extra_revive_health = {0.25} --Bonus health % to add when getting up. Used by Muscle and Stoic.
	
	--Bot boost stuff stuff--
	self.values.team.crew_add_health = {3}
	self.values.team.crew_add_armor = {1.1} --Now adds % armor, rather than flat armor.
	self.values.team.crew_add_dodge = {0.03} --Now adds % of dodge stat every second to meter.
	self.values.team.crew_add_concealment = {2}
	self.values.team.crew_add_stamina = {15}
	self.values.team.crew_reduce_speed_penalty = {1}
	self.values.team.crew_health_regen = {0.1}
	self.values.team.crew_throwable_regen = {70}
	self.values.team.crew_faster_reload = {1.1}

	--Crew ability stuff
	--Table index corresponds to number of bots.
	self.values.team.crew_inspire = {
		{
			90,
			75,
			60
		}
	}
	--# waves required to regain a down.
	self.values.team.crew_scavenge = {
		{
			3,
			2,
			1
		}
	}
	self.values.team.crew_interact = {
		{
			0.85,
			0.7,
			0.55
		}
	}
	--Also increases bot damage dealt.
	self.values.team.crew_ai_ap_ammo = {
		true
	}
	
	--Equipment--
	--FAKS: Intended to offer on-demand burst healing that cann save people from going down.
	self.values.first_aid_kit.heal_amount = 10 --Heals 100 health on use.

	--Doctor Bags: Intended to offer consistent sustain over a long period of time.
	self.doctor_bag_base = 2 --Starting Number
	self.values.doctor_bag.heal_amount = 0.2 --Heals 20% of max health on use.
	self.values.temporary.doctor_bag_health_regen = {{0.04, 180.1}} --Heals 3% of max health every 4 seconds for the next 4 minutes.
	
	--ECMs: They're ECMs
	self.ecm_jammer_base_battery_life = 10
	self.ecm_jammer_base_low_battery_life = 4
	self.ecm_jammer_base_range = 2500
	self.ecm_feedback_min_duration = 20
	self.ecm_feedback_max_duration = 20
	self.ecm_feedback_interval = 1.5
	self.ecm_feedback_retrigger_interval = 240

	--Sentry Guns
	self.sentry_gun_base_armor = 15
	self.sentry_gun_base_ammo = 140
	self.sentry_gun_intimidate_range = 1960000 --Uses squared distance.

	--"Baked In" upgrades
	self.values.player.stamina_multiplier = {2}
	self.values.team.stamina.multiplier = {1.5}
	self.values.player.civ_calming_alerts = {true}
	self.values.carry.throw_distance_multiplier = {1.5}
	self.values.player.sec_camera_highlight_mask_off = {true}
	self.values.player.special_enemy_highlight_mask_off = {true}
	self.values.player.mask_off_pickup = {true}
	self.values.player.small_loot_multiplier = {1.3, 1.3}
	self.values.player.melee_kill_snatch_pager_chance = {1}
	self.values.player.run_speed_multiplier = {1}
	self.values.player.walk_speed_multiplier = {
		1
	}
	self.values.player.crouch_speed_multiplier = {
		1
	}	
	self.values.player.climb_speed_multiplier = {1.2, 1.75}
	self.values.player.can_free_run = {true}
	self.values.player.counter_strike_melee = {true}
	self.player_damage_health_ratio_threshold = 0.5
	self.player_damage_health_ratio_threshold_2 = 0.5

	--Allegedly used somewhere???
	self.values.akimbo.recoil_multiplier = {
		1.0,
		1.0,
		1.0
	}

	--Skills--
	--MASTERMIND--
		--Medic--
			--Combat Medic--
				--Basic
					self.values.player.revive_damage_reduction = {0.9}
					self.values.temporary.revive_damage_reduction = {{
						0.9,
						5
					}}
				--Ace
					self.revive_health_multiplier = {1.3}
			
			--Quick Fix
				--Basic
					self.values.first_aid_kit.deploy_time_multiplier = {0.5} --Also applies to DBs.
				--Ace
					self.values.temporary.first_aid_damage_reduction = {{0.5, 5}}

			--Painkillers--
				self.first_aid_kit.revived_damage_reduction = {
					{0.75, 5}, --Basic
					{0.5, 5} --Ace
				}

			--Uppers
				self.values.first_aid_kit.quantity = {
					3, --Basic
					6 --Ace
				}
				--Ace
					self.values.first_aid_kit.uppers_cooldown = 30

			--Combat Doctor
				--Basic
					self.values.doctor_bag.amount_increase = {1}
				--Ace
					self.values.doctor_bag.quantity = {1}
			
			--Inspire
				--Basic
					self.skill_descs.inspire = {multibasic = "50%", multibasic2 = "20%", multibasic3 = "10", multipro = "50%"}
					self.morale_boost_speed_bonus = 1.2
					self.morale_boost_suppression_resistance = 1
					self.morale_boost_time = 10
					self.morale_boost_reload_speed_bonus = 1.2
					self.morale_boost_base_cooldown = 3.5
					self.values.player.revive_interaction_speed_multiplier = {
						0.5
					}
				--Ace
					self.values.player.long_dis_revive = {0.5, 0.5}
					self.values.cooldown.long_dis_revive = {
						{1, 90}
					}
			
		--Controller--
			--Cable Guy
				--Basic
					self.values.cable_tie.quantity_1 = {4}
					self.values.cable_tie.interact_speed_multiplier = {0.25}
				--Ace
					self.values.cable_tie.quantity_2 = {4}
					self.values.cable_tie.pickup_chance = {true}

				--Clowns are Scary
					--Basic
						self.values.player.civ_intimidation_mul = {1.5}
					--Ace
						self.values.player.intimidate_range_mul = {1.5}
						self.values.player.intimidate_aura = {1000}

				--Joker
					self.values.player.convert_enemies_max_minions = {
						1, --Basic
						2 --Ace
					}
					--Basic
						self.values.player.convert_enemies = {true}
						--Says health multiplier, but actually multiplies damage taken.
						self.values.player.passive_convert_enemies_health_multiplier = {
							0.4, --Basic
							0.2 --Ace
						}
					--Ace
						self.values.player.convert_enemies_health_multiplier = {0.45}
						--self.values.player.convert_enemies_damage_multiplier = {1.45, 1.45}

				--Stockholm Syndrome
					--Basic
						self.values.player.civilians_dont_flee = {true}
					--Ace
						self.values.player.civilian_reviver = {true}
						self.values.player.civilian_gives_ammo = {true}

				--Partners in Crime--
					--Basic
						self.values.player.hostage_speed_multiplier = {1.03}
					--Ace
						self.values.player.hostage_health_multiplier = {1.075}

				--Hostage Taker
					self.values.player.hostage_health_regen_addend = {
						0.1, --Basic
						0.2 --Unused
					}

					--Ace
						self.values.player.hostage_health_regen_max_mult = { 1.5 }

			
		--Assault--
			--Sturdy Arm--
				--Basic
					self.values.team.weapon.recoil_index_addend = {1}
				--Ace
					self.values.smg.hip_fire_recoil_multiplier = {1.25}

			--None in the Chamber
				--Basic
					self.values.smg.move_spread_multiplier = {0.7}
				--Ace

					self.values.smg.empty_reload_speed_multiplier = {1.3}
				
			--Quintstacked Mags
				self.values.weapon.clip_ammo_increase = {
					1.2, --Basic
					1.5 --Ace
				}

			--Spray 'n Pray
				--Basic
					self.values.smg.bloom_spread_multiplier = {0.7}
				--Ace
					self.values.smg.fire_rate_multiplier = {1.15, 1.15}
					self.values.smg.full_auto_free_ammo = {5}
				
			--Heavy Impact
				--Basic
					self.values.player.ap_bullets = {
						true
					}
				--Ace
					self.values.player.shield_knock = {true}
					self.shield_knock_chance = 0.2
					--self.values.player.bipod_damage_reduction = {0.5} --To be moved to Fence Skill Tree
	
			--Bullet Hell
				--Basic
					self.values.temporary.bullet_hell = {{
						{ --Basic
							fire_rate_multiplier = 1.4,
							recoil_multiplier = 1.4,
							free_ammo_chance = 0.4,
							kill_refund = 0,
							shots_required = 5,
							smg_only = true
						},
						0.01 --duration
					},{
						{ --Ace
							fire_rate_multiplier = 1.4,
							recoil_multiplier = 1.4,
							free_ammo_chance = 0.4,
							kill_refund = 4,
							shots_required = 5
						},
						2
					}}
						
	--ENFORCER--
		--Shotgunner--
			--Riding Coach
				--Basic
					self.values.shotgun.close_combat_draw_speed_multiplier = {{value = 1.5, min = 3}}
				--Ace
					self.values.weapon.close_combat_holster_speed_multiplier = {{value = 1.5, min = 3}}

			--Shell Rack
				self.values.shotgun.shell_stacking_reload_speed = {
					{ --Basic
						mag_reload_value = 0.05,
						shotgun_reload_value = 0.05,
						max_stacks = 4,
						apply_to_shotgun_reload = false
					},
					{ --Ace
						mag_reload_value = 0.05,
						shotgun_reload_value = 0.10,
						max_stacks = 4,
						apply_to_shotgun_reload = true
					}
				}

			--Gung-Ho
				--Basic
					self.values.player.hip_run_and_shoot = {true}
				--Ace
					self.values.shotgun.hip_rate_of_fire = {1.20}
				
			--Underdog
				--Basic
					self.values.player.close_combat_damage_boost = {{value = 0.04, max = 5}}
				--Ace
					self.values.player.close_combat_damage_reduction = {{value = 0.04, max = 5}}
				
			--Shotgun Surgeon
				--Basic
					self.values.shotgun.overhealed_damage_mul = {
						{
							damage = 1.75,
							range = 800
						}
					}
				--Ace
					self.values.shotgun.close_combat_ignore_medics = {800}
				
			--Overheat
				self.values.player.overheat = {{
					range = 800,
					aoe_radius = 500,
					damage = 0.5,
					chance = 0.4
				}}

				self.values.player.overheat_stacking = {{
					range = 800,
					chance_inc = 0.15,
					time = 10
				}}
			
		--Juggernaut--
			--Stun Resistance
				--Basic
					self.values.player.damage_shake_addend = {1}
					self.values.player.resist_melee_push = {0.025}
				--Ace
					self.values.player.flashbang_multiplier = {1, 0.2}
				
				--Die Hard
					self.values.player.deflection_addend = {
						0.05, --Basic
						0.10 --Ace
					}

				--Transporter
					--Basic
						self.values.player.armor_carry_bonus = {1.005}
					--Ace
						self.values.carry.movement_penalty_nullifier = {true}

				--More Blood To Bleed
					self.values.player.health_multiplier = {
						1.15, --Basic
						1.4 --Ace
					}

				--Shockproof
					--Basic
						self.values.player.counter_melee_tase = {true}
						self.values.player.slow_duration_multiplier = {0.5}
					--Ace
						self.values.player.taser_self_shock = {
							true
						}	
						self.counter_taser_damage = 0.5			
						self.values.player.escape_taser = {
							2
						}

				--Fully Armored
					--Basic
						self.values.player.armor_full_cheap_sprint = {0.5}
						self.values.player.armor_full_damage_absorb = {0.25}
					--Ace
						self.values.player.armor_full_stagger = {800}
						
			
		--Support--
			--Scavenger
				--Basic
					self.values.player.increased_pickup_area = {1.5}
				--Ace
					self.values.player.double_drop = {5}
				
			--Bulletstorm
				--Identical to vanilla

			--Diamond Tipped
				--Basic
					self.values.saw.enemy_slicer = {1}
				--Ace
					self.values.saw.ignore_shields = {true}
			
			--Extra Lead
				--Basic
					self.values.ammo_bag.ammo_increase = {2}
				--Ace
					self.values.ammo_bag.quantity = {1}

			--Specialized Equipment
				--Basic
					self.values.temporary.single_shot_reload_speed_multiplier = {{1.75, 1.5}}
				--Ace
					self.values.weapon.single_shot_panic_when_kill = {0.5}
				
			--Fully Loaded
				--Basic
					self.values.player.regain_throwable_from_ammo = {20}
				--Ace
					self.values.player.extra_ammo_multiplier = {1.5}
					self.values.player.fully_loaded_pick_up_multiplier = {1.5}
		
	--TECHNICIAN--
		--Fortress--
			--Logistician
				self.values.player.deploy_interact_faster = {
					0.75, --Basic
					0.25 --Ace
				}
				--Ace
					self.values.team.deploy_interact_faster = {0.25}
				
			--Nerves of Steel
				--Basic
					self.values.player.steelsight_when_downed = {true}				
				--Ace			
					self.values.player.interacting_damage_multiplier = {0.5}

			--Engineering
				--Basic
					self.values.sentry_gun.armor_multiplier = {1.4}
				--Ace
					self.values.sentry_gun.armor_multiplier2 = {1.6}
	
			--Tower Defense
				--Basic
					self.values.sentry_gun.ap_bullets = {true}
					--See SentrygunWeapon.lua under the units/weapons for AP bullet stats.
				--Ace
					self.values.sentry_gun.quantity = {1, 2}

				--Bulletproof
					--Basic
						self.values.player.unpierceable_armor = {true}
					--Ace
						self.values.player.armor_regen_timer_multiplier = {0.8}			
		
			--Jack of All Trades
				--Basic
					self.values.player.throwables_multiplier = {2}
				--Ace
					self.values.player.second_deployable = {true}

		--Breacher--
			--Hardware Expert
				self.values.player.drill_fix_interaction_speed_multiplier = {
					0.8, --Basic
					0.5 --Ace
				}
				--Basic
					self.values.player.drill_alert_rad = {900}
				--Ace
					self.values.player.silent_drill = {true}
				
			--Danger Close
				--Basic
					self.values.trip_mine.explosion_size_multiplier_1 = {1.3}
				--Ace
					self.values.trip_mine.damage_multiplier = {1.5}

			--Drill Sawgent
				self.values.player.drill_speed_multiplier = {
					0.9, --Basic
					0.7 --Ace
				}
				
			--Demoman
				self.values.player.trip_mine_deploy_time_multiplier = {
					0.8, --Basic
					0.6 --Ace
				}
				--Quantity Increase Located in tweakdata.lua since their quantity is hardcoded in the exe

				--Kickstarter
					--Basic
						self.values.player.drill_autorepair_1 = {0.3}
					--Ace
						self.values.player.drill_melee_hit_restart_chance = {true}
				
				--Fire Trap
					self.values.trip_mine.fire_trap = {
						{0, 1}, --Basic
						{10, 1.5} --Ace
					}
			
		--Combat Engineer--
			--Sharpshooter
				--Basic
					self.values.temporary.headshot_accuracy_addend = {{2, 10}}
				--Ace
					self.values.temporary.headshot_fire_rate_mult = {{1.2, 10}}

			--Tactical Precision
				--Basic
					self.values.weapon.enter_steelsight_speed_multiplier = {1.5}
					self.values.weapon.steelsight_accuracy_inc = {0.85}
					self.values.weapon.steelsight_range_inc = {1.15}
				--Ace
					self.values.snp.far_combat_reload_speed_multiplier = {{value = 0.35, fewer_than = 3}}
					self.values.assault_rifle.far_combat_reload_speed_multiplier = {{value = 0.35, fewer_than = 3}}

			--Ammo Efficiency
				self.values.player.head_shot_ammo_return = {
					{ ammo = 0.03, time = 6, headshots = 2, to_magazine = false }, --Basic
					{ ammo = 0.03, time = 10, headshots = 2, to_magazine = true } --Ace
				}

			--Rapid Reset
				--Basic
					self.values.assault_rifle.headshot_bloom_reduction = {0.5}

				--Ace
					self.values.temporary.single_shot_fast_reload = {
						{ --Ace
							1.5,
							10
						},
					}

			--Helmet Popping
				--Basic
					self.values.assault_rifle.headshot_pierce = {true}
					self.values.assault_rifle.headshot_pierce_damage_mult = {2}
					self.values.snp.headshot_pierce_damage_mult = {2}
				--Ace
					self.values.weapon.pop_helmets = {true}
					self.values.assault_rifle.headshot_repeat_damage_mult = {1.35}
					self.values.snp.headshot_repeat_damage_mult = {1.35}

			--Mind Blown
				self.values.snp.graze_damage = {
					{ --Basic
						radius = 500,
						damage_factor = 0.70,
						damage_factor_range = 0.00,
						range_increment = 800
					},
					{ --Ace
						radius = 500,
						damage_factor = 0.70,
						damage_factor_range = 0.30,
						range_increment = 800
					}
				}

	--GHOST--
		--Shinobi--
			--Cleaner
				self.values.weapon.special_damage_taken_multiplier = {
					1.05, --Basic
					1.15 --Ace
				}
				--Basic
					self.values.player.corpse_dispose_amount = {3, 4}
				--Ace
					self.values.bodybags_bag.quantity = {1}

			--Nimble
				self.values.player.pick_lock_easy_speed_multiplier = {
					0.5, --Basic
					0.25 --Ace
				}
				--Ace
					self.values.player.pick_lock_hard = {true}

			--Sixth Sense
				--Basic
					self.values.player.standstill_omniscience = {true}
				--Ace
					self.values.player.additional_assets = {true}
					self.values.player.buy_bodybags_asset = {true}
					self.values.player.buy_spotter_asset = {true}
				
			--Systems Specialist
				self.values.player.tape_loop_duration = {
					10, --Baked in
					30 --Basic
				}
				self.values.player.hack_fix_interaction_speed_multiplier = {
					0.75, --Basic
					0.25 --Ace
				}
				--Ace
					self.values.player.mark_enemy_time_multiplier = {2}
				
			--ECM Specialist
				self.values.ecm_jammer.quantity = {
					1, --Basic
					2 --Ace
				}
				
			--ECM Overdrive
				--Basic
					self.values.ecm_jammer.can_open_sec_doors = {true}		
					self.values.ecm_jammer.feedback_duration_boost = {1.25}
					self.values.ecm_jammer.duration_multiplier = {1.25}
				--Ace
					self.values.ecm_jammer.duration_multiplier_2 = {1.25}
					self.values.ecm_jammer.feedback_duration_boost_2 = {1.25}
					self.values.ecm_jammer.affects_pagers = {true}
			
		--Artful Dodger--
			--Duck and Cover
				--Basic
					self.values.player.stamina_regen_timer_multiplier = {0.75}
					self.values.player.stamina_regen_multiplier = {1.25}
				--Ace
					self.values.player.crouch_dodge_chance = {0.08, 0.08}

			--Evasion
				--Basic
					--Strafe sprinting.
					self.values.player.fall_damage_multiplier = {0.8}
				
				--Ace
					--Run and Reload
				
			--Second Wind
				self.values.temporary.damage_speed_multiplier = {
					{1.1, 0.01}, --Basic
					{1.15, 2} --Ace
				}

			--Moving Target
				self.values.player.detection_risk_add_movement_speed = {
					{ --Basic
						0.02,
						3,
						"below",
						35,
						0.2
					},
					{ --Ace
						0.02,
						1,
						"below",
						35,
						0.2
					}
				}
				--Ace
					self.values.player.run_dodge_chance = {0.15}
					self.values.player.zipline_dodge_chance = {0.6}

			--Bullseye
				self.values.player.headshot_regen_armor_bonus = {
					0.5, --Basic
					3.5 --Ace
				}
				self.on_headshot_dealt_cooldown = 3


			--Sneaky Bastard
				--Concealment stuff same as vanilla.
				--Ace
					self.values.player.dodge_heal_no_armor = {0.15}
			
		--Silent Killer--
			--Dexterous Hands--
				--Basic
					self.values.player.melee_concealment_modifier = {3}
				--Ace
					self.values.player.dodge_melee = {true}

			--Fast Feet
				--Basic
					self.values.player.melee_hit_stamina = {1}
				--Ace
					self.values.temporary.sprint_speed_boost = {{1.6, 0.65}}

			--The Professional
				--Basic
					self.values.weapon.silencer_spread_index_addend = {1}
				--Ace
					self.values.weapon.silencer_recoil_index_addend = {1}
					self.values.player.special_double_drop = {true}

			--Silent Precision
				self.values.temporary.silent_precision = {
					{ --Basic
						0.8,
						0.01 --Workaround for Buff Tracker sanity checks.
					},
					{ --Ace
						0.8,
						3
					}
				}
				self.values.player.silent_increased_accuracy = {
					{ --Basic
						min_time = 3 --Delay before bonus is re-applied after taking damage.
					},
					{ --Ace
						min_time = 3
					}
				}		

			--Unseen Strike
				self.values.temporary.unseen_strike = {
					{ --Basic
						1.25,
						0.01 --Workaround for Buff Tracker sanity checks.
					},
					{ --Ace
						1.25,
						3
					}
				}
				self.values.player.unseen_increased_crit_chance = {
					{ --Basic
						min_time = 3
					},
					{ --Ace
						min_time = 3
					}
				}				
				
			--Backstab
				--Basic
					self.values.player.backstab_crits = {0.45}
				--Ace
					self.values.player.backstab_dodge = {1}

			--Spotter
				--Basic
					self.values.player.marked_enemy_extra_damage = {true}
					self.values.player.marked_enemy_damage_mul = 1.15	
				--Ace
					self.values.player.marked_inc_dmg_distance = {{2000, 1.3}}			

			--Low Blow
				self.values.player.detection_risk_add_crit_chance = {
					{ --Basic
						0.03,
						3,
						"below",
						35,
						0.3
					},
					{ --Ace
						0.03,
						1,
						"below",
						35,
						0.3
					}
				}
				--Ace
					self.values.player.hyper_crits = {3}
		
	--FUGITIVE--
		--Gunslinger
			--Fast on the Draw
				--Basic
					self.values.pistol.swap_speed_multiplier = {1.4}
				--Ace
					self.values.pistol.first_shot_bonus_rays = {1}
				
			--Snap Shot
				--Basic
					self.values.pistol.ricochet_bullets = {true}
				--Ace
					self.values.weapon.ricochet_bullets = {true}

			--Trusty Sidearm
				--Basic
					self.values.weapon.empty_unequip_speed_multiplier = {1.4}
					self.values.pistol.backup_reload_speed_multiplier = {1.2}
				--Ace
					self.values.pistol.offhand_auto_reload = {0.35}

				--Basic
					self.values.pistol.move_spread_multiplier = {0.6}
				
			--Akimbo
				--Basic unlocks akimbos.
				self.values.akimbo.recoil_index_addend = {
					0,
					0, --Basic
					0,
					0,
					0
				}

				--Ace
					self.values.akimbo.extra_ammo_multiplier = {1.35}
					self.values.akimbo.pick_up_multiplier = {1.35}
				--Reserved for future use.
				self.values.akimbo.spread_index_addend = {
					0,
					0,
					0,
					0,
					0
				}

			--Desperado
				self.values.pistol.stacked_accuracy_bonus = {
					{accuracy_bonus = 0.92, max_stacks = 5, max_time = 6}, --Basic
					{accuracy_bonus = 0.92, max_stacks = 5, max_time = 10} --Ace
				}
				--Ace
					self.values.pistol.desperado_all_guns = {true}
				
			--Trigger Happy
				self.values.pistol.stacking_hit_damage_multiplier = {
					{damage_bonus = 1.1, max_stacks = 5, max_time = 6}, --Basic
					{damage_bonus = 1.1, max_stacks = 5, max_time = 10} --Ace
				}
				--Ace
					self.values.pistol.trigger_happy_all_guns = {true}
			
		--Revenant
			--Running From Death
				--Basic
					self.values.temporary.increased_movement_speed = {{1.25, 10}}
				--Ace
					self.values.temporary.revived_damage_resist = {{0.7, 10}}
					self.values.player.revive_reload = {true}
				
			--Undying (Formerly Nine Lives, Formerly Running From Death)
				self.values.player.bleed_out_health_multiplier = {
					2, --Basic
					3 --Ace
				}
				--Ace
					self.values.player.primary_weapon_when_downed = {true}

			--What Doesn't Kill
				--Basic
					self.values.player.damage_absorption_low_revives = {0.15}
				--Ace
					self.values.player.damage_absorption_addend = {0.3}

			--Swan Song
				self.values.temporary.berserker_damage_multiplier = {
					{1, 4}, --Basic
					{1, 8} --Ace
				}
				self.berserker_movement_speed_multiplier = 0.5
				--Ace
					self.values.player.berserker_no_ammo_cost = {true}

			--Haunt
				--Basic
					self.values.player.killshot_spooky_panic_chance = {0.05}
				--Ace
					self.values.player.killshot_extra_spooky_panic_chance = {0.1}
				
			--Messiah
				self.values.player.messiah_revive_from_bleed_out = {1, 3}
				self.messiah_cooldown = 80
				self.messiah_kill_cdr = 20
				self.values.player.pistol_revive_from_bleed_out = {1, 3}
				self.values.player.additional_lives = {1, 3}
			
		--Brawler--
			--Iron Knuckles
				--Basic
					self.values.player.melee_damage_dampener = {0.50}
				--Ace
					self.values.player.deflect_ranged = {0.85}
					
				
			--Bloodthirst
				self.values.player.melee_damage_stacking = {
					{ --Basic
						knockdown_multiplier = 0.3,
						damage_multiplier = 0.0,
						max_stacks = 3
					},
					{ --Ace
						knockdown_multiplier = 0.3,
						damage_multiplier = 0.2,
						max_stacks = 3
					}
				}

			--Pumping Iron
				self.values.player.melee_swing_multiplier = {1.2, 1.5}
				self.values.player.melee_swing_multiplier_delay = {1.2, 1.5}
				
			--Counter Strike
				--Basic
					self.values.player.counter_strike_spooc = {true}
				--Ace
					self.values.player.counter_strike_dozer = {true}

			--Snatch
				--Basic
					self.values.player.melee_kill_auto_load = {{
						1, --Grenade/rocket launchers.
						3 --All other guns.
					}}
				--Ace
					self.values.player.melee_kill_increase_reload_speed = {{1.5, 10}}
				
			--Frenzy
				--Basic
					self.values.player.melee_damage_health_ratio_multiplier = {2.50} --No longer scale off of max health
					self.values.player.max_health_reduction = {0.25}
					
				--Aced
					self.values.player.damage_health_ratio_multiplier = {1.75}

	--Singleplayer stealth stuff, to give them access to resources closer to what they would have in coop.
	if Global.game_settings and Global.game_settings.single_player then
		self.values.cable_tie.quantity_1 = {4}
		self.values.player.corpse_dispose_amount = {6, 8}
	end

	--Perk Decks--
	
	--Shared Perks--
	self.values.weapon.passive_damage_multiplier = {1.25, 1.5, 1.75, 2}
	self.values.player.melee_damage_multiplier = {1.25, 1.5, 1.75, 2}
	self.values.player.non_special_melee_multiplier = {1.25, 1.5, 1.75, 2}
	self.values.player.pick_up_ammo_multiplier = {1.25}

	self.values.player.perk_armor_regen_timer_multiplier = {
		0.9,
		0.8,
		0.7,
		0.65,
		0.6
	}

	--Hitman
	self.values.player.store_temp_health = { 
		{7.5, 2.5},
		{12, 4}
	}
	self.temp_health_decay = 0.6
	self.temp_health_max = 24
	self.values.player.revive_temp_health = { 12 }
	self.values.player.temp_health_speed = { 1.1 }
	self.values.player.temp_health_deflection = { 0.2 }
	self.values.player.armor_regen_dodge = { 1 }

	self.values.player.level_2_dodge_addend = {
		0.05,
		0.1,
		0.15
	}
	self.values.player.level_3_dodge_addend = {
		0.05,
		0.1,
		0.15
	}
	self.values.player.level_4_dodge_addend = {
		0.05,
		0.1,
		0.15
	}

	self.values.player.level_2_armor_multiplier = {
		1.15,
		1.3,
		1.5
	}
	self.values.player.level_3_armor_multiplier = {
		1.15,
		1.3,
		1.5
	}
	self.values.player.level_4_armor_multiplier = {
		1.15,
		1.3,
		1.5
	}

	self.values.player.tier_armor_multiplier = {
		1.1,
		1.1,
		1.2,
		1.2,
		1.25,
		1.25
	}

	--Perk deck related heal over time effects.
	self.values.player.heal_over_time = {
		{ --Infiltrator melee stacking heal.
			source = "infiltrator",
			amount = 0.1,
			tick_time = 1.5,
			tick_count = 5,
			max_stacks = 5
		},
		{ --Rogue dodge stacking heal.
			source = "rogue",
			amount = 0.1,
			tick_time = 2,
			tick_count = 5
		},
		{ --Grinder kill stacking heal (1)
			source = "grinder",
			amount = 0.1,
			tick_time = 1,
			tick_count = 6,
			max_stacks = 4,
			refesh_stacks_on_damage = true --Grinder stacks refresh whenever you deal damage.
		},
		{ --Grinder (3)
			source = "grinder",
			amount = 0.1,
			tick_time = 1,
			tick_count = 10,
			max_stacks = 4,
			refesh_stacks_on_damage = true
		},
		{ --Grinder (5)
			source = "grinder",
			amount = 0.1,
			tick_time = 0.5,
			tick_count = 20,
			max_stacks = 4,
			refesh_stacks_on_damage = true
		},
		{ --Grinder (7)
			source = "grinder",
			amount = 0.1,
			tick_time = 0.5,
			tick_count = 20,
			max_stacks = 8,
			refesh_stacks_on_damage = true
		}
	}

	--Grinder
	self.values.player.armor_reduction_multiplier = {0.5}
	self.values.player.hot_speed_bonus = {0.025}

	--infiltrator stuff
	self.values.player.damage_dampener_close_contact = {
		{value = 0.04, max = 5},
		{value = 0.05, max = 5},
		{value = 0.06, max = 5}
	}
	self.values.player.far_combat_movement_speed = {
		{value = 1.1, fewer_than = 3}
	}

	self.values.team.armor.multiplier = {1.05}
	self.values.team.health.passive_multiplier = {1.05}
	self.hostage_max_num = {
		health_regen = 4,
		health = 4,
		stamina = 4,
		speed = 4,
		damage_dampener = 1
	}
	self.values.team.health.hostage_multiplier = {1.05}
	self.values.team.stamina.hostage_multiplier = {1.05}
	self.values.team.damage = {
		hostage_absorption = {0.1},
		hostage_absorption_limit = 4
	}
	self.values.player.passive_dodge_chance = {
		0.05,
		0.1,
		0.15,
		0.2
   	}
	self.values.player.passive_health_regen = {0.025}
	self.values.player.passive_health_multiplier = {
		1.05,
		1.1,
		1.15,
		1.2,
		1.25,
		1.3,
		1.35,
		1.4,
		1.45,
		1.5
	}
	self.max_melee_weapon_dmg_mul_stacks = 5
	self.values.melee.stacking_hit_expire_t = {10}
	self.values.melee.stacking_hit_damage_multiplier = {
		0.08,
		0.16
	}
	self.values.player.tier_dodge_chance = {
		0.05,
		0.05,
		0.05
	}
	
	self.values.player.perk_armor_loss_multiplier = {
		0.5,
		0.9,
		0.85,
		0.8
	}

	--Rogue
	self.values.player.dodge_on_revive = {true}
	self.values.weapon.passive_swap_speed_multiplier = {
		1.3,
		2 --Unused
	}

	--Gambler
 	self.loose_ammo_restore_health_values = {
 		cd = 10, --Cooldown
 		cdr = {3 , 5}, --Amount cooldown is reduced on ammo box pickup.
		{4, 8}, --Amounts healed per level
		{6, 10},
		{8, 12}
 	}
	self.loose_ammo_give_team_health_ratio = 0.5 --% of healing given to team.
	self.values.player.loose_ammo_restore_health_give_team = {true}	
	self.values.player.loose_ammo_give_armor = {3}
	self.values.player.loose_ammo_give_dodge = {1}

	--Create actual upgrade table for Gambler.
	self.values.temporary.loose_ammo_restore_health = {}
	for i, data in ipairs(self.loose_ammo_restore_health_values) do
		table.insert(self.values.temporary.loose_ammo_restore_health, {
			{
				data[1],
				data[2]
			},
			self.loose_ammo_restore_health_values.cd
		})
	end

	self.values.temporary.loose_ammo_give_team = {{
		true,
		7
	}}
	self.loose_ammo_give_team_ratio = 1 --% of ammo given to team.

	--Sociopath
	self.values.cooldown.killshot_regen_armor_bonus = {
		{{2, 0}, 3},
		{{2, 2}, 3}
	}
	self.values.cooldown.killshot_close_panic_chance = {{0.25, 2}}
	self.values.cooldown.melee_kill_life_leech = {{0.05, 1}}
	self.values.player.damage_dampener_outnumbered = {
		{value = 0.85, min = 3}
	}

	--Anarchist stuff--
	self.values.player.armor_grinding = {
		{
			{2.4, 3.0},
			{2.8, 3.5},
			{3.2, 4.0},
			{3.6, 4.5},
			{4.0, 5.0},
			{4.4, 5.5},
			{4.8, 6.0}
		}
	}
	
	self.values.player.health_decrease = {0.5}
	
	self.values.player.armor_increase = {
		0.50,
		1.00,
		1.50
	}

	self.values.player.damage_to_armor = {
		{
			{2.1, 3},
			{2.4, 3},
			{2.7, 3},
			{3.0, 3},
			{3.2, 3},
			{3.4, 3},
			{3.6, 3}
		}
	}
	
	--Ex President
	self.values.player.armor_health_store_amount = {
		0.4,
		0.6,
		0.8
	}	
	self.values.player.armor_max_health_store_multiplier = {
		1.25
	}

	self.values.player.body_armor.skill_max_health_store = {
		6.4,
		6.0,
		5.6,
		5.2,
		4.8,
		4.4,
		4.0
	}
	self.kill_change_regenerate_speed_percentage = true
	self.values.player.body_armor.skill_kill_change_regenerate_speed = {
		1.40,
		1.35,
		1.30,
		1.25,
		1.20,
		1.15,
		1.10
	}	

	--I AM A BAD MOTHERFUCKA--
	--maniac
	self.cocaine_stacks_convert_levels = {
		200,
		150
	}
	self.cocaine_stacks_dmg_absorption_value = 0.1
	self.cocaine_stacks_tick_t = 0
	self.max_cocaine_stacks_per_tick = 1200
	self.max_total_cocaine_stacks = 1200
	self.cocaine_stacks_decay_t = 8
	self.cocaine_stacks_decay_amount_per_tick = 200
	self.cocaine_stacks_decay_percentage_per_tick = 0
	self.values.player.cocaine_stacking = {1}
	self.values.player.sync_cocaine_stacks = {true}
	self.values.player.cocaine_stacks_decay_multiplier = {0.75}
	self.values.player.sync_cocaine_upgrade_level = {2}
	self.values.player.cocaine_stack_absorption_multiplier = {2}
	
	--Chico--
	--kingpin
	self.values.temporary.chico_injector = {
		{0.3, 4},
		{0.3, 5},
		{0.3, 6}
	}
	self.values.player.chico_injector_speed = {
		1.2
	}
	self.values.player.chico_injector_dodge = {
		2.5,
		5
	}

	self.values.player.chico_armor_multiplier = {
		1.05,
		1.1,
		1.15
	}
	self.values.player.chico_injector_low_health_multiplier = {
		{0.25, 0.5}
	}	
	self.values.player.chico_injector_health_to_speed = {
		{0.5, 2}
	}
	--Are these the dreamers we were told about?--
	--sicario
	self.smoke_screen_armor_regen = {2.0} --Multiplier for armor regen speed.
	self.values.player.sicario_multiplier = {1.0} --Multiplier for dodge gained per second while inside grenade.
	self.values.player.bomb_cooldown_reduction = {3} --Cooldown reduction on smoke bomb for kills while inside the smoke.
	
	--alcoholism is no joke
	--stoic
	self.values.player.armor_to_health_conversion = {
		50
	}
	self.values.player.damage_control_passive = {{
		30,
		12.5
	}}
	self.values.player.damage_control_auto_shrug = {
		4
	}
	self.values.player.damage_control_healing = {
		300
	}

	self.values.player.damage_control_cooldown_drain = {
		{ 0, 1},
		{50, 6}
	}
	
	--Yakuza--
	self.values.cooldown.survive_one_hit = {{true, 300}}
	self.values.player.survive_one_hit_kill_cdr = {5}
	self.values.survive_one_hit_armor = 5.0

	self.values.player.resistance_damage_health_ratio_multiplier = {
		0.25
	}

	self.values.player.dodge_regen_damage_health_ratio_multiplier = {
		0.1
	}

	self.values.player.melee_kill_dodge_regen = {
		0.5
	}

	self.values.player.kill_dodge_regen = {
		0.5
	}
	
	--Fat benis :DDDDD
	--biker?
	self.wild_trigger_time = 2
	self.wild_max_triggers_per_time = 1
	self.values.player.wild_health_amount = {0.2}
	self.values.player.wild_armor_amount = {0.0}
	self.values.player.less_health_wild_armor = {{
		0.0,
		0.0
	}}
	self.values.player.less_health_wild_cooldown = {{
		0.0,
		0.0
	}}
	self.values.player.less_armor_wild_health = {{
		0.25,
		0.2
	}}
	self.values.player.less_armor_wild_cooldown = {{
		0.25,
		0.5
	}}

	self.values.player.biker_armor_regen = {
		--Amount regenerated per tick, time between ticks, time fast forwarded when melee kills are done.
		{1.0, 3.0, 0.0},
		{2.0, 2.5, 3.5} 
	}

	--Tag Team--
	self.values.player.tag_team_base = {
		{
			kill_health_gain = 0.8,
			radius = 0.6,
			distance = 18,
			kill_duration = 0,
			kill_dropoff = 0,
			duration = 11,
			tagged_health_gain_ratio = 0.625
		},
		{
			kill_health_gain = 0.8,
			radius = 0.6,
			distance = 18,
			kill_duration = 2,
			kill_dropoff = 0.2,
			duration = 11,
			tagged_health_gain_ratio = 0.625
		},
		{
			kill_health_gain = 1.6,
			radius = 0.6,
			distance = 18,
			kill_duration = 2,
			kill_dropoff = 0.2,
			duration = 11,
			tagged_health_gain_ratio = 0.625
		}
	}

	self.values.player.tag_team_cooldown_drain = {
		{
			tagged = 0,
			owner = 0
		},
		{
			tagged = 2,
			owner = 2
		}
	}

	self.values.player.tag_team_damage_absorption = {
		{
			kill_gain = 0.05,
			max = 0.8
		}	
	}	
	
	--Hacker
	self.values.player.pocket_ecm_jammer_base = {
		{
			cooldown_drain = 3,
			duration = 12
		}
	}	
	self.values.player.pocket_ecm_heal_on_kill = {
		2
	}	
	self.values.team.pocket_ecm_heal_on_kill = {
		1
	}	
	
end)

--Added new definitions--

local sc_definitions = UpgradesTweakData._player_definitions
function UpgradesTweakData:_player_definitions()
	sc_definitions (self, tweak_data)

	--New Definitions, calling em here to play it safe--
	self.definitions.player_drill_deploy_speed_multiplier = {
		name_id = "menu_player_drill_fix_interaction_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "drill_fix_interaction_speed_multiplier",
			category = "player"
		}
	}		
	self.definitions.player_drill_fix_interaction_speed_multiplier_1 = {
		name_id = "menu_player_drill_fix_interaction_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "drill_fix_interaction_speed_multiplier",
			category = "player"
		}
	}	
	self.definitions.player_drill_fix_interaction_speed_multiplier_2 = {
		name_id = "menu_player_drill_fix_interaction_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "drill_fix_interaction_speed_multiplier",
			category = "player"
		}
	}		
	self.definitions.player_damage_control_auto_shrug_1 = {
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "damage_control_auto_shrug",
			category = "player"
		}
	}
	self.definitions.player_damage_control_auto_shrug_2 = {
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "damage_control_auto_shrug",
			category = "player"
		}
	}
	self.definitions.assault_rifle_spread_index_addend = {
		name_id = "menu_assault_rifle_spread_index_addend",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "spread_index_addend",
			category = "assault_rifle"
		}
	}
	self.definitions.snp_spread_index_addend = {
		name_id = "menu_snp_spread_index_addend",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "spread_index_addend",
			category = "snp"
		}
	}	
	self.definitions.akimbo_spread_index_addend_1 = {
		name_id = "menu_pistol_spread_index_addend",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "spread_index_addend",
			category = "akimbo"
		}
	}	
	self.definitions.akimbo_spread_index_addend_2 = {
		name_id = "menu_pistol_spread_index_addend",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "spread_index_addend",
			category = "akimbo"
		}
	}	
	self.definitions.akimbo_spread_index_addend_3 = {
		name_id = "menu_pistol_spread_index_addend",
		category = "feature",
		upgrade = {
			value = 3,
			upgrade = "spread_index_addend",
			category = "akimbo"
		}
	}
	self.definitions.akimbo_spread_index_addend_4 = {
		name_id = "menu_pistol_spread_index_addend",
		category = "feature",
		upgrade = {
			value = 4,
			upgrade = "spread_index_addend",
			category = "akimbo"
		}
	}
	self.definitions.akimbo_spread_index_addend_5 = {
		name_id = "menu_pistol_spread_index_addend",
		category = "feature",
		upgrade = {
			value = 5,
			upgrade = "spread_index_addend",
			category = "akimbo"
		}
	}	
	self.definitions.weapon_single_shot_panic_when_kill = {
		name_id = "menu_weapon_single_shot_panic_when_kill",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "single_shot_panic_when_kill",
			category = "weapon"
		}
	}
	self.definitions.weapon_special_damage_taken_multiplier_1 = {
		name_id = "menu_weapon_special_damage_taken_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "special_damage_taken_multiplier",
			category = "weapon"
		}
	}
	self.definitions.weapon_special_damage_taken_multiplier_2 = {
		name_id = "menu_weapon_special_damage_taken_multiplier",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "special_damage_taken_multiplier",
			category = "weapon"
		}
	}	
    self.definitions.player_detection_risk_add_movement_speed_1 = {
        category = "feature",
        name_id = "menu_player_detection_risk_add_movement_speed",
        upgrade = {
            category = "player",
            upgrade = "detection_risk_add_movement_speed",
            value = 1
        }
    }
    self.definitions.player_detection_risk_add_movement_speed_2 = {
            category = "feature",
            name_id = "menu_player_detection_risk_add_movement_speed",
            upgrade = {
                category = "player",
                upgrade = "detection_risk_add_movement_speed",
                value = 2
            }
        }
	self.definitions.player_health_multiplier_2 = {
		category = "feature",
		name_id = "menu_player_health_multiplier",
		upgrade = {
			category = "player",
			upgrade = "health_multiplier",
			value = 2
		}
	}
	self.definitions.pistol_first_shot_bonus_rays = {
		category = "feature",
		name_id = "menu_pistol_first_shot_bonus_rays",
		upgrade = {
			category = "pistol",
			upgrade = "first_shot_bonus_rays",
			value = 1
		}
	}
	self.definitions.weapon_ricochet_bullets_1 = {
		category = "feature",
		name_id = "menu_weapon_ricochet_bullets",
		upgrade = {
			category = "pistol",
			upgrade = "ricochet_bullets",
			value = 1
		}
	}
	self.definitions.weapon_ricochet_bullets_2 = {
		category = "feature",
		name_id = "menu_weapon_ricochet_bullets",
		upgrade = {
			category = "weapon",
			upgrade = "ricochet_bullets",
			value = 1
		}
	}
	self.definitions.weapon_empty_unequip_speed_multiplier = {
		category = "feature",
		name_id = "menu_weapon_empty_unequip_speed_multiplier",
		upgrade = {
			category = "weapon",
			upgrade = "empty_unequip_speed_multiplier",
			value = 1
		}
	}
	self.definitions.pistol_backup_reload_speed_multiplier = {
		category = "feature",
		name_id = "menu_pistol_backup_reload_speed_multiplier",
		upgrade = {
			category = "pistol",
			upgrade = "backup_reload_speed_multiplier",
			value = 1
		}
	}
	self.definitions.pistol_offhand_auto_reload = {
		category = "feature",
		name_id = "menu_pistol_offhand_auto_reload",
		upgrade = {
			category = "pistol",
			upgrade = "offhand_auto_reload",
			value = 1
		}
	}
	self.definitions.pistol_desperado_all_guns = {
		category = "feature",
		name_id = "menu_pistol_desperado_all_guns",
		upgrade = {
			category = "pistol",
			upgrade = "desperado_all_guns",
			value = 1
		}
	}
	self.definitions.pistol_trigger_happy_all_guns = {
		category = "feature",
		name_id = "menu_pistol_trigger_happy_all_guns",
		upgrade = {
			category = "pistol",
			upgrade = "trigger_happy_all_guns",
			value = 1
		}
	}
	self.definitions.pistol_stacked_accuracy_bonus_1 = {
		category = "feature",
		name_id = "menu_pistol_stacked_accuracy_bonus",
		upgrade = {
			category = "pistol",
			upgrade = "stacked_accuracy_bonus",
			value = 1
		}
	}
	self.definitions.pistol_stacked_accuracy_bonus_2 = {
		category = "feature",
		name_id = "menu_pistol_stacked_accuracy_bonus",
		upgrade = {
			category = "pistol",
			upgrade = "stacked_accuracy_bonus",
			value = 2
		}
	}
	self.definitions.player_melee_swing_multiplier_1 = {
		category = "feature",
		name_id = "menu_player_melee_swing_multiplier",
		upgrade = {
			category = "player",
			upgrade = "melee_swing_multiplier",
			value = 1
		}
	}
	self.definitions.player_melee_swing_multiplier_2 = {
		category = "feature",
		name_id = "menu_player_melee_swing_multiplier",
		upgrade = {
			category = "player",
			upgrade = "melee_swing_multiplier",
			value = 2
		}
	}	
	self.definitions.player_melee_swing_multiplier_delay_1 = {
		category = "feature",
		name_id = "menu_player_melee_swing_multiplier_delay",
		upgrade = {
			category = "player",
			upgrade = "melee_swing_multiplier_delay",
			value = 1
		}
	}
	self.definitions.player_melee_swing_multiplier_delay_2 = {
		category = "feature",
		name_id = "menu_player_melee_swing_multiplier_delay",
		upgrade = {
			category = "player",
			upgrade = "melee_swing_multiplier_delay",
			value = 2
		}
	}
	self.definitions.player_melee_damage_stacking_1 = {
		category = "feature",
		name_id = "menu_player_melee_damage_stacking",
		upgrade = {
			category = "player",
			upgrade = "melee_damage_stacking",
			value = 1
		}
	}
	self.definitions.player_melee_damage_stacking_2 = {
		category = "feature",
		name_id = "menu_player_melee_damage_stacking",
		upgrade = {
			category = "player",
			upgrade = "melee_damage_stacking",
			value = 2
		}
	}
	self.definitions.player_melee_kill_auto_load = {
		category = "feature",
		name_id = "menu_player_melee_kill_auto_load",
		upgrade = {
			category = "player",
			upgrade = "melee_kill_auto_load",
			value = 1
		}
	}
	self.definitions.player_counter_strike_dozer = {
		category = "feature",
		name_id = "menu_player_counter_strike_dozer",
		upgrade = {
			category = "player",
			upgrade = "counter_strike_dozer",
			value = 1
		}
	}
	self.definitions.player_melee_hit_stamina = {
		category = "feature",
		name_id = "menu_player_melee_hit_stamina",
		upgrade = {
			category = "player",
			upgrade = "melee_hit_stamina",
			value = 1
		}
	}
	self.definitions.temporary_sprint_speed_boost = {
		category = "temporary",
		name_id = "menu_temporary_sprint_speed_boost",
		upgrade = {
			category = "temporary",
			upgrade = "sprint_speed_boost",
			value = 1
		}
	}
	self.definitions.player_deflect_ranged = {
		category = "feature",
		name_id = "menu_player_deflect_ranged",
		upgrade = {
			category = "player",
			upgrade = "deflect_ranged",
			value = 1
		}
	}
	self.definitions.player_level_1_armor_addend = {
		name_id = "menu_player_level_1_armor_addend",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "level_1_armor_addend",
			category = "player"
		}
	}	
	self.definitions.player_level_5_armor_addend = {
		category = "feature",
		name_id = "menu_player_level_5_armor_addend",
		upgrade = {
			category = "player",
			upgrade = "level_5_armor_addend",
			value = 1
		}
	}
	self.definitions.player_extra_revive_health = {
		category = "feature",
		name_id = "menu_player_panic_suppression",
		upgrade = {
			category = "player",
			upgrade = "extra_revive_health",
			value = 1
		}
	}
	self.definitions.player_dodge_on_revive = {
		category = "feature",
		name_id = "menu_player_dodge_on_revive",
		upgrade = {
			category = "player",
			upgrade = "dodge_on_revive",
			value = 1
		}
	}
	self.definitions.player_tag_team_base_1 = {
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "tag_team_base",
			synced = true,
			category = "player"
		}
	}
	self.definitions.player_tag_team_base_2 = {
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "tag_team_base",
			synced = true,
			category = "player"
		}
	}
	self.definitions.player_tag_team_base_3 = {
		category = "feature",
		upgrade = {
			value = 3,
			upgrade = "tag_team_base",
			synced = true,
			category = "player"
		}
	}
	self.definitions.player_tag_team_cooldown_drain_1 = {
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "tag_team_cooldown_drain",
			category = "player"
		}
	}
	self.definitions.player_tag_team_cooldown_drain_2 = {
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "tag_team_cooldown_drain",
			category = "player"
		}
	}
	self.definitions.player_passive_health_multiplier_5 = {
		category = "feature",
		name_id = "menu_player_health_multiplier",
		upgrade = {
			category = "player",
			upgrade = "passive_health_multiplier",
			value = 5
		}
	}
	self.definitions.player_passive_health_multiplier_6 = {
		category = "feature",
		name_id = "menu_player_health_multiplier",
		upgrade = {
			category = "player",
			upgrade = "passive_health_multiplier",
			value = 6
		}
	}	
	self.definitions.player_passive_health_multiplier_7 = {
		category = "feature",
		name_id = "menu_player_health_multiplier",
		upgrade = {
			category = "player",
			upgrade = "passive_health_multiplier",
			value = 7
		}
	}		
	self.definitions.player_passive_health_multiplier_8 = {
		category = "feature",
		name_id = "menu_player_health_multiplier",
		upgrade = {
			category = "player",
			upgrade = "passive_health_multiplier",
			value = 8
		}
	}	
	self.definitions.player_passive_health_multiplier_9 = {
		category = "feature",
		name_id = "menu_player_health_multiplier",
		upgrade = {
			category = "player",
			upgrade = "passive_health_multiplier",
			value = 9
		}
	}
	self.definitions.player_passive_health_multiplier_10 = {
		category = "feature",
		name_id = "menu_player_health_multiplier",
		upgrade = {
			category = "player",
			upgrade = "passive_health_multiplier",
			value = 10
		}
	}
	self.definitions.temporary_single_shot_reload_speed_multiplier = {
		category = "temporary",
		name_id = "menu_temporary_single_shot_reload_speed_multiplier",
		upgrade = {
			category = "temporary",
			upgrade = "single_shot_reload_speed_multiplier",
			value = 1
		}
	}
	self.definitions.temporary_headshot_accuracy_addend = {
		category = "temporary",
		name_id = "menu_temporary_headshot_accuracy_addend",
		upgrade = {
			category = "temporary",
			upgrade = "headshot_accuracy_addend",
			value = 1
		}
	}
	self.definitions.temporary_headshot_fire_rate_mult = {
		category = "temporary",
		name_id = "menu_temporary_headshot_fire_rate_mult",
		upgrade = {
			category = "temporary",
			upgrade = "headshot_fire_rate_mult",
			value = 1
		}
	}
	self.definitions.temporary_damage_speed_multiplier_1 = {
		category = "temporary",
		name_id = "menu_temporary_damage_speed",
		upgrade = {
			category = "temporary",
			upgrade = "damage_speed_multiplier",
			value = 1
		}
	}
	self.definitions.temporary_damage_speed_multiplier_2 = {
		category = "temporary",
		name_id = "menu_temporary_damage_speed",
		upgrade = {
			category = "temporary",
			upgrade = "damage_speed_multiplier",
			value = 2
		}
	}
	self.definitions.player_explosive_damage_reduction = {
		category = "feature",
		name_id = "menu_player_explosive_damage_reduction",
		upgrade = {
			category = "player",
			upgrade = "explosive_damage_reduction",
			value = 1
		}
	}
	self.definitions.player_armor_multiplier_1 = {
		category = "feature",
		name_id = "menu_player_armor_multiplier",
		upgrade = {
			category = "player",
			upgrade = "armor_multiplier",
			value = 1
		}
	}
	self.definitions.player_armor_multiplier_2 = {
		category = "feature",
		name_id = "menu_player_armor_multiplier",
		upgrade = {
			category = "player",
			upgrade = "armor_multiplier",
			value = 2
		}
	}
	self.definitions.player_movement_speed_multiplier_1 = {
		name_id = "menu_player_movement_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "movement_speed_multiplier",
			category = "player"
		}
	}	
	self.definitions.player_movement_speed_multiplier_2 = {
		name_id = "menu_player_movement_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "movement_speed_multiplier",
			category = "player"
		}
	}	
	self.definitions.player_trip_mine_deploy_time_multiplier_1 = {
		incremental = true,
		name_id = "menu_player_trip_mine_deploy_time_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "trip_mine_deploy_time_multiplier",
			category = "player"
		}
	}
	self.definitions.player_trip_mine_deploy_time_multiplier_2 = {
		incremental = true,
		name_id = "menu_player_trip_mine_deploy_time_multiplier",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "trip_mine_deploy_time_multiplier",
			category = "player"
		}
	}	
	self.definitions.cable_tie_pickup_chance = {
		name_id = "menu_shotgun_damage_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "pickup_chance",
			category = "cable_tie"
		}
	}		
	self.definitions.player_hack_fix_interaction_speed_multiplier_1 = {
		name_id = "menu_player_drill_fix_interaction_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "hack_fix_interaction_speed_multiplier",
			category = "player"
		}
	}
	self.definitions.player_hack_fix_interaction_speed_multiplier_2 = {
		name_id = "menu_player_drill_fix_interaction_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "hack_fix_interaction_speed_multiplier",
			category = "player"
		}
	}		
	self.definitions.player_pick_lock_easy_speed_multiplier_1 = {
		name_id = "menu_player_pick_lock_easy_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "pick_lock_easy_speed_multiplier",
			category = "player"
		}
	}
	self.definitions.player_pick_lock_easy_speed_multiplier_2 = {
		name_id = "menu_player_pick_lock_easy_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "pick_lock_easy_speed_multiplier",
			category = "player"
		}
	}
	self.definitions.deploy_interact_faster_2 = {
		name_id = "menu_deploy_interact_faster",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "deploy_interact_faster",
			category = "player"
		}
	}
	self.definitions.player_bomb_cooldown_reduction = {
		category = "feature",
		name_id = "menu_player_bomb_cooldown_reduction",
		upgrade = {
			category = "player",
			upgrade = "bomb_cooldown_reduction",
			value = 1
		}
	}
	self.definitions.player_tag_team_damage_absorption = {
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "tag_team_damage_absorption",
			category = "player"
		}
	}
	self.definitions.temporary_chico_injector_1 = {
		name_id = "menu_temporary_chico_injector_1",
		category = "temporary",
		upgrade = {
			value = 1,
			upgrade = "chico_injector",
			synced = true,
			category = "temporary"
		}
	}
	self.definitions.temporary_chico_injector_2 = {
		name_id = "menu_temporary_chico_injector_1",
		category = "temporary",
		upgrade = {
			value = 2,
			upgrade = "chico_injector",
			synced = true,
			category = "temporary"
		}
	}
	self.definitions.temporary_chico_injector_3 = {
		name_id = "menu_temporary_chico_injector_1",
		category = "temporary",
		upgrade = {
			value = 3,
			upgrade = "chico_injector",
			synced = true,
			category = "temporary"
		}
	}
	self.definitions.player_chico_injector_speed = {
		name_id = "menu_player_chico_injector_speed",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "chico_injector_speed",
			category = "player"
		}
	}
	self.definitions.player_chico_injector_dodge_1 = {
		name_id = "menu_player_chico_injector_dodge",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "chico_injector_dodge",
			category = "player"
		}
	}
	self.definitions.player_chico_injector_dodge_2 = {
		name_id = "menu_player_chico_injector_dodge",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "chico_injector_dodge",
			category = "player"
		}
	}
	self.definitions.pistol_swap_speed_multiplier_1 = {
		name_id = "menu_pistol_swap_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "swap_speed_multiplier",
			category = "pistol"
		}
	}	
	self.definitions.pistol_move_spread_multiplier = {
		name_id = "menu_snp_move_spread_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "move_spread_multiplier",
			category = "pistol"
		}
	}
	self.definitions.player_fully_loaded_pick_up_multiplier = {
		name_id = "menu_player_fully_loaded_pick_up_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "fully_loaded_pick_up_multiplier",
			category = "player"
		}
	}
	self.definitions.player_loose_ammo_give_armor = {
		name_id = "menu_player_loose_ammo_give_armor",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "loose_ammo_give_armor",
			category = "player"
		}
	}		
		self.definitions.player_loose_ammo_give_dodge = {
		name_id = "menu_player_loose_ammo_give_dodge",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "loose_ammo_give_dodge",
			category = "player"
		}
	}	
	--Passive Perk Deck Dam increases
	self.definitions.weapon_passive_damage_multiplier_1 = {
		name_id = "menu_weapon_passive_damage_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "passive_damage_multiplier",
			synced = true,
			category = "weapon"
		}
	}	
	self.definitions.weapon_passive_damage_multiplier_2 = {
		name_id = "menu_weapon_passive_damage_multiplier",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "passive_damage_multiplier",
			synced = true,
			category = "weapon"
		}
	}
	self.definitions.weapon_passive_damage_multiplier_3 = {
		name_id = "menu_weapon_passive_damage_multiplier",
		category = "feature",
		upgrade = {
			value = 3,
			upgrade = "passive_damage_multiplier",
			synced = true,
			category = "weapon"
		}
	}	
	self.definitions.weapon_passive_damage_multiplier_4 = {
		name_id = "menu_weapon_passive_damage_multiplier",
		category = "feature",
		upgrade = {
			value = 4,
			upgrade = "passive_damage_multiplier",
			synced = true,
			category = "weapon"
		}
	}
	self.definitions.player_hostage_health_regen_max_mult = {
		name_id = "menu_player_hostage_health_regen_max_mult",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "hostage_health_regen_max_mult",
			category = "player"
		}
	}
	self.definitions.player_hostage_health_multiplier = {
		name_id = "menu_player_hostage_health_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "hostage_health_multiplier",
			category = "player"
		}
	}
	self.definitions.player_hostage_speed_multiplier = {
		name_id = "menu_player_hostage_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "hostage_speed_multiplier",
			category = "player"
		}
	}
	self.definitions.player_doctor_bag_health_regen = {
		name_id = "menu_temporary_doctor_bag_health_regen",
		category = "temporary",
		upgrade = {
			value = 1,
			upgrade = "doctor_bag_health_regen",
			category = "temporary"
		}
	}
	self.definitions.player_damage_dampener_outnumbered = {
		name_id = "menu_player_damage_dampener_outnumbered",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "damage_dampener_outnumbered",
			category = "player"
		}
	}
	self.definitions.player_damage_dampener_close_contact_1 = {
		name_id = "menu_player_damage_dampener_close_contact",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "damage_dampener_close_contact",
			category = "player"
		}
	}
	self.definitions.player_damage_dampener_close_contact_2 = {
		name_id = "menu_player_damage_dampener_close_contact",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "damage_dampener_close_contact",
			category = "player"
		}
	}
	self.definitions.player_damage_dampener_close_contact_3 = {
		name_id = "menu_player_damage_dampener_close_contact",
		category = "feature",
		upgrade = {
			value = 3,
			upgrade = "damage_dampener_close_contact",
			category = "player"
		}
	}
	self.definitions.player_far_combat_movement_speed = {
		name_id = "menu_player_far_combat_movement_speed",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "far_combat_movement_speed",
			category = "player"
		}
	}
	self.definitions.player_close_combat_damage_reduction = {
		name_id = "menu_player_close_combat_damage_reduction",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "close_combat_damage_reduction",
			category = "player"
		}
	}
	self.definitions.player_close_combat_damage_boost = {
		name_id = "menu_player_close_combat_damage_boost",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "close_combat_damage_boost",
			category = "player"
		}
	}
	self.definitions.player_dodge_stacking_heal = {
		name_id = "menu_player_dodge_stacking_heal",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "heal_over_time",
			category = "player"
		}
	}
	self.definitions.player_kill_stacking_heal_1 = {
		name_id = "menu_player_kill_stacking_heal_1",
		category = "feature",
		upgrade = {
			value = 3,
			upgrade = "heal_over_time",
			category = "player"
		}
	}
	self.definitions.player_kill_stacking_heal_2 = {
		name_id = "menu_player_kill_stacking_heal_2",
		category = "feature",
		upgrade = {
			value = 4,
			upgrade = "heal_over_time",
			category = "player"
		}
	}
	self.definitions.player_kill_stacking_heal_3 = {
		name_id = "menu_player_kill_stacking_heal_3",
		category = "feature",
		upgrade = {
			value = 5,
			upgrade = "heal_over_time",
			category = "player"
		}
	}
	self.definitions.player_kill_stacking_heal_4 = {
		name_id = "menu_player_kill_stacking_heal_4",
		category = "feature",
		upgrade = {
			value = 6,
			upgrade = "heal_over_time",
			category = "player"
		}
	}
	self.definitions.player_armor_reduction_multiplier = {
		name_id = "menu_player_armor_reduction_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "armor_reduction_multiplier",
			category = "player"
		}
	}
	self.definitions.player_hot_speed_bonus = {
		name_id = "menu_player_hot_speed_bonus",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "hot_speed_bonus",
			category = "player"
		}
	}
end

function UpgradesTweakData:_smg_definitions()
	self.definitions.smg_move_spread_multiplier = {
		name_id = "menu_snp_move_spread_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "move_spread_multiplier",
			category = "smg"
		}
	}
	self.definitions.smg_bloom_spread_multiplier = {
		name_id = "menu_snp_bloom_spread_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "bloom_spread_multiplier",
			category = "smg"
		}
	}
	self.definitions.smg_full_auto_free_ammo = {
		name_id = "menu_smg_full_auto_free_ammo",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "full_auto_free_ammo",
			category = "smg"
		}
	}
	self.definitions.smg_empty_reload_speed_multiplier = {
		category = "feature",
		name_id = "menu_smg_empty_reload_speed_multiplier",
		upgrade = {
			category = "smg",
			upgrade = "empty_reload_speed_multiplier",
			value = 1
		}
	}
	self.definitions.smg_fire_rate_multiplier_1 = {
		category = "feature",
		name_id = "menu_smg_fire_rate_multiplier",
		upgrade = {
			category = "smg",
			upgrade = "fire_rate_multiplier",
			value = 1
		}
	}
	self.definitions.smg_hip_fire_spread_multiplier = {
		category = "feature",
		name_id = "menu_smg_hip_fire_spread_multiplier",
		upgrade = {
			category = "smg",
			upgrade = "hip_fire_spread_multiplier",
			value = 1
		}
	}
	self.definitions.player_bullet_hell_1 = {
		category = "temporary",
		name_id = "menu_player_bullet_hell",
		upgrade = {
			category = "temporary",
			upgrade = "bullet_hell",
			value = 1
		}
	}
	self.definitions.player_bullet_hell_2 = {
		category = "temporary",
		name_id = "menu_player_bullet_hell",
		upgrade = {
			category = "temporary",
			upgrade = "bullet_hell",
			value = 2
		}
	}
end

function UpgradesTweakData:_saw_definitions()
	self.definitions.saw = {
		category = "weapon",
		weapon_id = "saw",
		factory_id = "wpn_fps_saw"
	}
	self.definitions.saw_secondary = {
		category = "weapon",
		weapon_id = "saw_secondary",
		factory_id = "wpn_fps_saw_secondary"
	}
	self.definitions.saw_enemy_slicer = {
		category = "feature",
		name_id = "menu_saw_enemy_slicer",
		upgrade = {
			category = "saw",
			upgrade = "enemy_slicer",
			value = 1
		}
	}
	self.definitions.player_overkill_damage_multiplier_2 = {
		category = "temporary",
		name_id = "menu_player_overkill_damage_multiplier",
		upgrade = {
			category = "temporary",
			upgrade = "overkill_damage_multiplier",
			value = 2
		}
	}
	self.definitions.saw_ignore_shields_1 = {
		category = "feature",
		name_id = "menu_saw_ignore_shields",
		upgrade = {
			category = "saw",
			upgrade = "ignore_shields",
			value = 1
		}
	}
	self.definitions.shotgun_swap_speed_multiplier = {
		category = "feature",
		name_id = "menu_saw_swap_speed_multiplier",
		upgrade = {
			category = "shotgun",
			upgrade = "swap_speed_multiplier",
			value = 1
		}
	}
	self.definitions.player_melee_stacking_heal = {
		name_id = "menu_player_melee_stacking_heal",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "heal_over_time",
			category = "player"
		}
	}
	self.definitions.player_dodge_regen_damage_health_ratio_multiplier = {
		name_id = "menu_player_dodge_regen_damage_health_ratio_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "dodge_regen_damage_health_ratio_multiplier",
			category = "player"
		}
	}
	self.definitions.player_resistance_damage_health_ratio_multiplier = {
		name_id = "menu_player_resistance_damage_health_ratio_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "resistance_damage_health_ratio_multiplier",
			category = "player"
		}
	}
	self.definitions.player_biker_armor_regen_1 = {
		name_id = "menu_player_biker_armor_regen",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "biker_armor_regen",
			category = "player"
		}
	}
	self.definitions.player_biker_armor_regen_2 = {
		name_id = "menu_player_biker_armor_regen",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "biker_armor_regen",
			category = "player"
		}
	}
	self.definitions.player_melee_kill_dodge_regen = {
		name_id = "menu_player_melee_kill_dodge_regen",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "melee_kill_dodge_regen",
			category = "player"
		}
	}
	self.definitions.player_kill_dodge_regen = {
		name_id = "menu_player_kill_dodge_regen",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "kill_dodge_regen",
			category = "player"
		}
	}
	self.definitions.player_deflection_addend_1 = {
		name_id = "menu_player_deflection_addend",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "deflection_addend",
			category = "player"
		}
	}
	self.definitions.player_deflection_addend_2 = {
		name_id = "menu_player_deflection_addend",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "deflection_addend",
			category = "player"
		}
	}
	self.definitions.player_bleed_out_health_multiplier_1 = {
		name_id = "menu_player_bleed_out_health_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "bleed_out_health_multiplier",
			category = "player"
		}
	}
	self.definitions.player_bleed_out_health_multiplier_2 = {
		name_id = "menu_player_bleed_out_health_multiplier",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "bleed_out_health_multiplier",
			category = "player"
		}
	}
	self.definitions.player_resist_melee_push = {
		name_id = "menu_player_resist_melee_push",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "resist_melee_push",
			category = "player"
		}
	}
	self.definitions.player_damage_absorption_addend = {
		name_id = "menu_player_damage_absorption_addend",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "damage_absorption_addend",
			category = "player"
		}
	}
	self.definitions.player_damage_absorption_low_revives = {
		name_id = "menu_player_damage_absorption_low_revives",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "damage_absorption_low_revives",
			category = "player"
		}
	}
	self.definitions.player_killshot_spooky_panic_chance = {
		name_id = "menu_player_killshot_spooky_panic_chance",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "killshot_spooky_panic_chance",
			category = "player"
		}
	}
	self.definitions.player_killshot_extra_spooky_panic_chance = {
		name_id = "menu_player_killshot_extra_spooky_panic_chance",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "killshot_extra_spooky_panic_chance",
			category = "player"
		}
	}
	self.definitions.player_throwables_multiplier = {
		name_id = "menu_player_throwables_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "throwables_multiplier",
			category = "player"
		}
	}
	self.definitions.player_dodge_melee = {
		name_id = "menu_player_dodge_melee",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "dodge_melee",
			category = "player"
		}
	}
	self.definitions.player_armor_full_stagger = {
		category = "feature",
		name_id = "menu_player_armor_full_stagger",
		upgrade = {
			category = "player",
			upgrade = "armor_full_stagger",
			value = 1
		}
	}
	self.definitions.player_dodge_heal_no_armor = {
		name_id = "menu_player_dodge_heal_no_armor",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "dodge_heal_no_armor",
			category = "player"
		}
	}
	self.definitions.player_backstab_dodge = {
		name_id = "menu_player_backstab_dodge",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "backstab_dodge",
			category = "player"
		}
	}
	self.definitions.player_backstab_crits = {
		name_id = "menu_player_backstab_crits",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "backstab_crits",
			category = "player"
		}
	}
	self.definitions.player_hyper_crits = {
		name_id = "menu_player_hyper_crits",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "hyper_crits",
			category = "player"
		}
	}
	self.definitions.player_silent_increased_accuracy_1 = {
		name_id = "menu_player_silent_increased_accuracy",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "silent_increased_accuracy",
			category = "player"
		}
	}
	self.definitions.player_silent_increased_accuracy_2 = {
		name_id = "menu_player_silent_increased_accuracy",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "silent_increased_accuracy",
			category = "player"
		}
	}
	self.definitions.player_silent_temp_increased_accuracy_1 = {
		name_id = "menu_player_silent_increased_accuracy",
		category = "temporary",
		upgrade = {
			value = 1,
			upgrade = "silent_precision",
			category = "temporary"
		}
	}
	self.definitions.player_silent_temp_increased_accuracy_2 = {
		name_id = "menu_player_silent_increased_accuracy",
		category = "temporary",
		upgrade = {
			value = 2,
			upgrade = "silent_precision",
			category = "temporary"
		}
	}
	self.definitions.player_special_double_drop = {
		name_id = "menu_player_special_double_drop",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "special_double_drop",
			category = "player"
		}
	}
	self.definitions.player_unpierceable_armor = {
		name_id = "menu_player_unpierceable_armor",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "unpierceable_armor",
			category = "player"
		}
	}
	self.definitions.player_counter_melee_tase = {
		name_id = "menu_player_counter_melee_tase",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "counter_melee_tase",
			category = "player"
		}
	}
	self.definitions.player_slow_duration_multiplier = {
		name_id = "menu_player_slow_duration_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "slow_duration_multiplier",
			category = "player"
		}
	}
	self.definitions.player_armor_full_cheap_sprint = {
		name_id = "menu_player_armor_full_cheap_sprint",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "armor_full_cheap_sprint",
			category = "player"
		}
	}
	self.definitions.player_armor_full_damage_absorb = {
		name_id = "menu_player_armor_full_damage_absorb",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "armor_full_damage_absorb",
			category = "player"
		}
	}
	self.definitions.player_civilians_dont_flee = {
		name_id = "menu_player_civilians_dont_flee",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "civilians_dont_flee",
			category = "player"
		}
	}
	self.definitions.player_bipod_damage_reduction = {
		name_id = "menu_player_bipod_damage_reduction",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "bipod_damage_reduction",
			category = "player"
		}
	}
	self.definitions.player_store_temp_health_1 = {
		name_id = "menu_player_store_temp_health",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "store_temp_health",
			category = "player"
		}
	}
	self.definitions.player_store_temp_health_2 = {
		name_id = "menu_player_store_temp_health",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "store_temp_health",
			category = "player"
		}
	}
	self.definitions.player_revive_temp_health = {
		name_id = "menu_player_revive_temp_health",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "revive_temp_health",
			category = "player"
		}
	}
	self.definitions.player_temp_health_speed = {
		name_id = "menu_player_temp_health_speed",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "temp_health_speed",
			category = "player"
		}
	}
	self.definitions.player_temp_health_deflection = {
		name_id = "menu_player_temp_health_deflection",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "temp_health_deflection",
			category = "player"
		}
	}
	self.definitions.player_armor_regen_dodge = {
		name_id = "menu_player_armor_regen_dodge",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "armor_regen_dodge",
			category = "player"
		}
	}
	self.definitions.player_revive_reload = {
		name_id = "menu_player_revive_reload",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "revive_reload",
			category = "player"
		}
	}
	self.definitions.player_overheat = {
		name_id = "menu_player_overheat",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "overheat",
			category = "player"
		}
	}
	self.definitions.player_overheat_stacking = {
		name_id = "menu_player_overheat_stacking",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "overheat_stacking",
			category = "player"
		}
	}
	self.definitions.assault_rifle_headshot_pierce = {
		name_id = "menu_player_assault_rifle_headshot_pierce",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "headshot_pierce",
			category = "assault_rifle"
		}
	}
	self.definitions.assault_rifle_headshot_pierce_damage_mult = {
		name_id = "menu_player_assault_rifle_headshot_pierce_damage_mult",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "headshot_pierce_damage_mult",
			category = "assault_rifle"
		}
	}
	self.definitions.snp_headshot_pierce_damage_mult = {
		name_id = "menu_player_snp_headshot_pierce_damage_mult",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "headshot_pierce_damage_mult",
			category = "snp"
		}
	}
	self.definitions.assault_rifle_headshot_bloom_reduction = {
		name_id = "menu_player_assault_rifle_headshot_bloom_reduction",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "headshot_bloom_reduction",
			category = "assault_rifle"
		}
	}
	self.definitions.assault_rifle_headshot_repeat_damage_mult = {
		name_id = "menu_player_assault_rifle_headshot_repeat_damage_mult",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "headshot_repeat_damage_mult",
			category = "assault_rifle"
		}
	}
	self.definitions.snp_headshot_repeat_damage_mult = {
		name_id = "menu_player_snp_headshot_repeat_damage_mult",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "headshot_repeat_damage_mult",
			category = "snp"
		}
	}
	self.definitions.snp_far_combat_reload_speed_multiplier = {
		name_id = "menu_snp_far_combat_reload_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "far_combat_reload_speed_multiplier",
			category = "snp"
		}
	}
		self.definitions.assault_rifle_far_combat_reload_speed_multiplier = {
		name_id = "menu_assault_rifle_far_combat_reload_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "far_combat_reload_speed_multiplier",
			category = "assault_rifle"
		}
	}
end

Hooks:PostHook(UpgradesTweakData, "_weapon_definitions", "ResWeaponSkills", function(self)
	self.definitions.shotgun_overhealed_damage_mul = {
		name_id = "menu_shotgun_overhealed_damage_mul",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "overhealed_damage_mul",
			category = "shotgun"
		}
	}
	self.definitions.shotgun_close_combat_ignore_medics = {
		name_id = "menu_shotgun_close_combat_ignore_medics",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "close_combat_ignore_medics",
			category = "shotgun"
		}
	}
	self.definitions.shotgun_shell_stacking_reload_speed_1 = {
		name_id = "menu_shotgun_shell_stacking_reload_speed",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "shell_stacking_reload_speed",
			category = "shotgun"
		}
	}
	self.definitions.shotgun_shell_stacking_reload_speed_2 = {
		name_id = "menu_shotgun_shell_stacking_reload_speed",
		category = "feature",
		upgrade = {
			value = 2,
			upgrade = "shell_stacking_reload_speed",
			category = "shotgun"
		}
	}
	self.definitions.shotgun_close_combat_draw_speed_multiplier = {
		name_id = "menu_shotgun_close_combat_draw_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "close_combat_draw_speed_multiplier",
			category = "shotgun"
		}
	}
	self.definitions.weapon_close_combat_holster_speed_multiplier = {
		name_id = "menu_shotgun_close_combat_holster_speed_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "close_combat_holster_speed_multiplier",
			category = "weapon"
		}
	}
	self.definitions.akimbo_pick_up_multiplier = {
		name_id = "menu_akimbo_pick_up_multiplier",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "pick_up_multiplier",
			category = "akimbo"
		}
	}
	self.definitions.weapon_pop_helmets = {
		name_id = "menu_player_weapon_pop_helmets",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "pop_helmets",
			category = "weapon"
		}
	}
end)

function UpgradesTweakData:_cooldown_definitions()
	self.definitions.cooldown_long_dis_revive = {
		name_id = "menu_cooldown_long_dis_revive",
		category = "cooldown",
		upgrade = {
			value = 1,
			upgrade = "long_dis_revive",
			category = "cooldown"
		}
	}
	self.definitions.cooldown_melee_kill_life_leech = {
		name_id = "menu_cooldown_melee_kill_life_leech",
		category = "cooldown",
		upgrade = {
			value = 1,
			upgrade = "melee_kill_life_leech",
			category = "cooldown"
		}
	}
	self.definitions.cooldown_killshot_regen_armor_bonus_1 = {
		name_id = "menu_cooldown_killshot_regen_armor_bonus",
		category = "cooldown",
		upgrade = {
			value = 1,
			upgrade = "killshot_regen_armor_bonus",
			category = "cooldown"
		}
	}
	self.definitions.cooldown_killshot_regen_armor_bonus_2 = {
		name_id = "menu_cooldown_killshot_regen_armor_bonus",
		category = "cooldown",
		upgrade = {
			value = 2,
			upgrade = "killshot_regen_armor_bonus",
			category = "cooldown"
		}
	}
	self.definitions.cooldown_killshot_close_panic_chance = {
		name_id = "menu_cooldown_killshot_close_panic_chance",
		category = "cooldown",
		upgrade = {
			value = 1,
			upgrade = "killshot_close_panic_chance",
			category = "cooldown"
		}
	}
	self.definitions.cooldown_survive_one_hit = {
		name_id = "menu_cooldown_survive_one_hit",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "survive_one_hit",
			category = "cooldown"
		}
	}
	self.definitions.player_survive_one_hit_kill_cdr = {
		name_id = "menu_player_survive_one_hit_kill_cdr",
		category = "feature",
		upgrade = {
			value = 1,
			upgrade = "survive_one_hit_kill_cdr",
			category = "player"
		}
	}
end