local job = Global.level_data and Global.level_data.level_id

--Defines most weapon stats via loops for conciseness.
function WeaponTweakData:_init_stats()
	--Iteration causes floating point errors to pile up, which can result in weirdness in some menus.
	--This fixes that.
	local function clamp_near_zero(value)
		if math.abs(value) < 0.01 then
			return 0
		end
		return value
	end

	self.stats = {}
	self.stat_info = {} --Certain custom RM stuff falls under this for compatibility reasons.

	--Automatically clamps extreme values to the size of the table.
	local stat_meta_table = {
		__index = function(t, k)
			if type(k) ~= "number" then return end
			return rawget(t, math.min(math.max(k, 1), #t))
		end
	}

	self.stats.alert_size = {
		0, --Silenced
		2500 --Unsilenced
	}

	self.stats.suppression = {}
	for i = 0.2, 1, 0.04 do --Middle value slightly off to avoid floating point shenanigans.
		table.insert(self.stats.suppression, i)
	end
	setmetatable(self.stats.suppression, stat_meta_table)

	self.stats.damage = {}
	for i = 0.1, 40.01, 0.1 do
		table.insert(self.stats.damage, i)
	end
	setmetatable(self.stats.damage, stat_meta_table)

	self.stats.zoom = {}
	for i = 1, 12.1, 0.1 do
		table.insert(self.stats.zoom, 65 / i)
	end
	setmetatable(self.stats.zoom, stat_meta_table)

	--ACCURACY
		--All spread values are in terms of AREA, to prevent things from scaling exponentially due to the number of additive modifiers.
		--Generic spread, applied at all times.
		--Keep this between 0.5x-1x the other stats to ensure that accuracy min/maxxed guns have the lowest *overall* spread; but worse spread than guns specialized in moving or spraying.
			--Currently, other stats provide up to -8 spread in their respective areas, whereas this provides -6. So investing elsewhere will reduce spread more situationally, but this will reduce it more overall.
		self.stat_info.base_spread = 8
		self.stat_info.spread_per_accuracy = -0.4
		self.stats.spread = {}
		for i = 0, 20, 1 do
			table.insert(self.stats.spread, self.stat_info.base_spread + (i * self.stat_info.spread_per_accuracy))
		end
		setmetatable(self.stats.spread, stat_meta_table)

		self.stat_info.damage_falloff = {
			base = 1480,
			max = 4000,
			acc_bonus = 120,
			near_mul = 1,
			far_mul = 2,
			shotgun_penalty = 0.3
		}
		
		--Cosmetic camera movement.
		self.stat_info.base_breathing_amplitude = 0.525
		self.stat_info.breathing_amplitude_per_accuracy = -0.025
		self.stat_info.breathing_amplitude_stance_muls = {
			standing = 1,
			moving_standing = 1,
			crouching = 0.65,
			moving_crouching = 0.65,
			steelsight = 0.2,
			moving_steelsight = 0.2,
			bipod = 0.0
		}
		self.stat_info.breathing_amplitude = {}
		for i = 1, 21, 1 do
			table.insert(self.stat_info.breathing_amplitude, self.stat_info.base_breathing_amplitude + ((i - 1) * self.stat_info.breathing_amplitude_per_accuracy))
		end
		setmetatable(self.stat_info.breathing_amplitude, stat_meta_table)

	--MOBILITY
		--Keep for legacy purposes, to allow for things to be displayed properly in certain areas without large refactors.
		self.stats.concealment = {}
		for i = 1, 21, 1 do
			table.insert(self.stats.concealment, i)
		end
		setmetatable(self.stats.concealment, stat_meta_table)

		--Generate table for moving_spread and how it relates to mobility.
		--The values in the table correspond to the area of spread.
		--These are added to the area for accuracy while moving before determining the final angles.
		self.stat_info.base_move_spread = 10
		self.stat_info.spread_per_mobility = -0.5
		self.stats.spread_moving = {}
		for i = 0, 20, 1 do
			table.insert(self.stats.spread_moving, self.stat_info.base_move_spread + (i * self.stat_info.spread_per_mobility))
		end
		setmetatable(self.stats.spread_moving, stat_meta_table)

		--Weapon swap speed multiplier from concealment.
		--Values calculated using the inverse to ensure they scale linearly with swap *time*.
		self.stats.mobility = {}
		self.stat_info.swap_speed_min_mul = 0.5 --Min mobility = 2.0x swap time.
		self.stat_info.swap_speed_max_mul = 2.0 --Max mobility = 0.5x swap time.
		for i = 20, 0, -1 do
			table.insert(self.stats.mobility, 1 / math.lerp(self.stat_info.swap_speed_min_mul, self.stat_info.swap_speed_max_mul, i/25))
		end
		setmetatable(self.stats.mobility, stat_meta_table)

		--Cosmetic camera movement.
		self.stat_info.min_vel_overshot_mul = 12 --0 mobility should make the gun heavily lag behind camera movement.
		self.stat_info.vel_overshot_per_mobility = -0.55 --Each point of mobility should make it lag behind less.
		self.stat_info.vel_overshot_stance_muls = {
			standing = 1,
			moving_standing = 1,
			crouching = 0.65,
			moving_crouching = 0.65,
			steelsight = 0.2,
			moving_steelsight = 0.2,
			bipod = 0.0
		}
		self.stat_info.vel_overshot = {}
		for i = 1, 21, 1 do
			table.insert(self.stat_info.vel_overshot, self.stat_info.min_vel_overshot_mul + ((i - 1) * self.stat_info.vel_overshot_per_mobility))
		end
		setmetatable(self.stat_info.vel_overshot, stat_meta_table)

	--STABILITY
		self.stat_info.base_bloom_spread = 12 --Amount of spread each stack of bloom gives.
		self.stat_info.spread_per_stability = -0.6 --Amount bloom spread is reduced by stability.
		self.stat_info.bloom_spread = {}
		for i = 0, 20, 1 do
			table.insert(self.stat_info.bloom_spread, math.max(self.stat_info.base_bloom_spread + (i * self.stat_info.spread_per_stability), 0))
		end
		setmetatable(self.stat_info.bloom_spread, stat_meta_table)

		self.stat_info.bloom_data = {
			decay_delay = 0.25, --How long after the player stops shooting (past the gun's innate ROF limits) to wait before bloom starts to decay.
			decay = 1, --The rate at which bloom decays.
			gain = 1 --Seconds of continuous fire it takes to max out bloom.
		}

		--Recoil multiplier. Used for stability, and cosmetic camera shake.
		self.stat_info.base_recoil_mult = 3.5
		self.stat_info.recoil_per_stability = -0.15
		self.stats.recoil = {}
		for i = 0, 20, 1 do
			table.insert(self.stats.recoil, self.stat_info.base_recoil_mult + (i * self.stat_info.recoil_per_stability))
		end
		setmetatable(self.stats.recoil, stat_meta_table)

	--Multiplier for spread on multi-pellet shotguns. This compensates for linear spread scaling which would otherwise cripple their multikill potential.
	self.stat_info.shotgun_spread_increase = 2.5

	--Stance multipliers for overall gun spread.
	self.stat_info.stance_spread_mults = {
		standing = 1,
		moving_standing = 1,
		crouching = 0.75,
		moving_crouching = 0.75,
		steelsight = 0.5,
		moving_steelsight = 0.5,
		bipod = 0.4
	}

	--Stance multipliers for weapon recoil.
	self.stat_info.stance_recoil_mults = {
		standing = 1,
		crouching = 0.75,
		steelsight = 0.5
		--bipod = 0.4 TODO: Change recoil.lua to use this.
	}

	self.stats.value = {}
	for i = 1, 10.01, 1 do
		table.insert(self.stats.value, i)
	end
	setmetatable(self.stats.value, stat_meta_table)

	self.stats.extra_ammo = {}
	for i = -100, 1500, 1 do
		table.insert(self.stats.extra_ammo, clamp_near_zero(i))
	end
	setmetatable(self.stats.extra_ammo, stat_meta_table)

	self.stats.total_ammo_mod = {}
		for i = -0.99, 1.155, 0.01 do
		table.insert(self.stats.total_ammo_mod, clamp_near_zero(i))
	end
	setmetatable(self.stats.total_ammo_mod, stat_meta_table)

	self.stats.reload = {}
	for i = 0.05, 2.01, 0.05 do
		table.insert(self.stats.reload, clamp_near_zero(i - 1) + 1)
	end
	setmetatable(self.stats.reload, stat_meta_table)

	--Different recoil tables.
	--With the exception of the none table, all of them average out to '0.85'
	--'Heavier' recoils tend to move your screen vertically more than lighter ones, and vice versa for horizontal.
	--This means that they feel meatier, but can also be more reliably controlled by a skilled player.
	--On the flip side, 'lighter' recoils will cancel themselves out more. But have more uncontrollable horizontal spread.
	self.stat_info.kick_tables = {
		--No recoil at all, used for bows and shit.
		none = {
			standing = {
				0,
				0,
				0,
				0
			},
			crouching = {
				0,
				0,
				0,
				0
			},
			steelsight = {
				0,
				0,
				0,
				0
			}
		},

		--Big, low damage bullet hoses will be around here.
		horizontal_recoil = {
			standing = {
				0.5 * self.stat_info.stance_recoil_mults.standing,
				0.6 * self.stat_info.stance_recoil_mults.standing,
				-1.15 * self.stat_info.stance_recoil_mults.standing,
				1.15 * self.stat_info.stance_recoil_mults.standing
			},
			crouching = {
				0.5 * self.stat_info.stance_recoil_mults.crouching,
				0.6 * self.stat_info.stance_recoil_mults.crouching,
				-1.15 * self.stat_info.stance_recoil_mults.crouching,
				1.15 * self.stat_info.stance_recoil_mults.crouching
			},
			steelsight = {
				0.5 * self.stat_info.stance_recoil_mults.steelsight,
				0.6 * self.stat_info.stance_recoil_mults.steelsight,
				-1.15 * self.stat_info.stance_recoil_mults.steelsight,
				1.15 * self.stat_info.stance_recoil_mults.steelsight
			}
		},

		horizontal_left_recoil = {
			standing = {
				0.5 * self.stat_info.stance_recoil_mults.standing,
				0.6 * self.stat_info.stance_recoil_mults.standing,
				-1.725 * self.stat_info.stance_recoil_mults.standing,
				0.575 * self.stat_info.stance_recoil_mults.standing
			},
			crouching = {
				0.5 * self.stat_info.stance_recoil_mults.crouching,
				0.6 * self.stat_info.stance_recoil_mults.crouching,
				-1.725 * self.stat_info.stance_recoil_mults.crouching,
				0.575 * self.stat_info.stance_recoil_mults.crouching
			},
			steelsight = {
				0.5 * self.stat_info.stance_recoil_mults.steelsight,
				0.6 * self.stat_info.stance_recoil_mults.steelsight,
				-1.725 * self.stat_info.stance_recoil_mults.steelsight,
				0.575 * self.stat_info.stance_recoil_mults.steelsight
			}
		},

		horizontal_right_recoil = {
			standing = {
				0.5 * self.stat_info.stance_recoil_mults.standing,
				0.6 * self.stat_info.stance_recoil_mults.standing,
				-0.575 * self.stat_info.stance_recoil_mults.standing,
				1.725 * self.stat_info.stance_recoil_mults.standing
			},
			crouching = {
				0.5 * self.stat_info.stance_recoil_mults.crouching,
				0.6 * self.stat_info.stance_recoil_mults.crouching,
				-0.575 * self.stat_info.stance_recoil_mults.crouching,
				1.725 * self.stat_info.stance_recoil_mults.crouching
			},
			steelsight = {
				0.5 * self.stat_info.stance_recoil_mults.steelsight,
				0.6 * self.stat_info.stance_recoil_mults.steelsight,
				-0.575 * self.stat_info.stance_recoil_mults.steelsight,
				1.725 * self.stat_info.stance_recoil_mults.steelsight
			}
		},

		--Your average SMG and Pistol will be around here.
		even_recoil = {
			standing = {
				0.6 * self.stat_info.stance_recoil_mults.standing,
				0.8 * self.stat_info.stance_recoil_mults.standing,
				-1 * self.stat_info.stance_recoil_mults.standing,
				1 * self.stat_info.stance_recoil_mults.standing
			},
			crouching = {
				0.6 * self.stat_info.stance_recoil_mults.crouching,
				0.8 * self.stat_info.stance_recoil_mults.crouching,
				-1 * self.stat_info.stance_recoil_mults.crouching,
				1 * self.stat_info.stance_recoil_mults.crouching
			},
			steelsight = {
				0.6 * self.stat_info.stance_recoil_mults.steelsight,
				0.8 * self.stat_info.stance_recoil_mults.steelsight,
				-1 * self.stat_info.stance_recoil_mults.steelsight,
				1 * self.stat_info.stance_recoil_mults.steelsight
			}
		},

		left_recoil = {
			standing = {
				0.6 * self.stat_info.stance_recoil_mults.standing,
				0.8 * self.stat_info.stance_recoil_mults.standing,
				-1.5 * self.stat_info.stance_recoil_mults.standing,
				0.5 * self.stat_info.stance_recoil_mults.standing
			},
			crouching = {
				0.6 * self.stat_info.stance_recoil_mults.crouching,
				0.8 * self.stat_info.stance_recoil_mults.crouching,
				-1.5 * self.stat_info.stance_recoil_mults.crouching,
				0.5 * self.stat_info.stance_recoil_mults.crouching
			},
			steelsight = {
				0.6 * self.stat_info.stance_recoil_mults.steelsight,
				0.8 * self.stat_info.stance_recoil_mults.steelsight,
				-1.5 * self.stat_info.stance_recoil_mults.steelsight,
				0.5 * self.stat_info.stance_recoil_mults.steelsight
			}
		},

		right_recoil = {
			standing = {
				0.6 * self.stat_info.stance_recoil_mults.standing,
				0.8 * self.stat_info.stance_recoil_mults.standing,
				-0.5 * self.stat_info.stance_recoil_mults.standing,
				1.5 * self.stat_info.stance_recoil_mults.standing
			},
			crouching = {
				0.6 * self.stat_info.stance_recoil_mults.crouching,
				0.8 * self.stat_info.stance_recoil_mults.crouching,
				-0.5 * self.stat_info.stance_recoil_mults.crouching,
				1.5 * self.stat_info.stance_recoil_mults.crouching
			},
			steelsight = {
				0.6 * self.stat_info.stance_recoil_mults.steelsight,
				0.8 * self.stat_info.stance_recoil_mults.steelsight,
				-0.5 * self.stat_info.stance_recoil_mults.steelsight,
				1.5 * self.stat_info.stance_recoil_mults.steelsight
			}
		},

		--Your average handcannon, light shotguns, or ARs will be around here.
		moderate_kick = {
			standing = {
				0.8 * self.stat_info.stance_recoil_mults.standing,
				1.0 * self.stat_info.stance_recoil_mults.standing,
				-0.8 * self.stat_info.stance_recoil_mults.standing,
				0.8 * self.stat_info.stance_recoil_mults.standing
			},
			crouching = {
				0.8 * self.stat_info.stance_recoil_mults.crouching,
				1.0 * self.stat_info.stance_recoil_mults.crouching,
				-0.8 * self.stat_info.stance_recoil_mults.crouching,
				0.8 * self.stat_info.stance_recoil_mults.crouching
			},
			steelsight = {
				0.8 * self.stat_info.stance_recoil_mults.steelsight,
				1.0 * self.stat_info.stance_recoil_mults.steelsight,
				-0.8 * self.stat_info.stance_recoil_mults.steelsight,
				0.8 * self.stat_info.stance_recoil_mults.steelsight
			}
		},

		moderate_left_kick = {
			standing = {
				0.8 * self.stat_info.stance_recoil_mults.standing,
				1.0 * self.stat_info.stance_recoil_mults.standing,
				-1.2 * self.stat_info.stance_recoil_mults.standing,
				0.4 * self.stat_info.stance_recoil_mults.standing
			},
			crouching = {
				0.8 * self.stat_info.stance_recoil_mults.crouching,
				1.0 * self.stat_info.stance_recoil_mults.crouching,
				-1.2 * self.stat_info.stance_recoil_mults.crouching,
				0.4 * self.stat_info.stance_recoil_mults.crouching
			},
			steelsight = {
				0.8 * self.stat_info.stance_recoil_mults.steelsight,
				1.0 * self.stat_info.stance_recoil_mults.steelsight,
				-1.2 * self.stat_info.stance_recoil_mults.steelsight,
				0.4 * self.stat_info.stance_recoil_mults.steelsight
			}
		},

		moderate_right_kick = {
			standing = {
				0.8 * self.stat_info.stance_recoil_mults.standing,
				1.0 * self.stat_info.stance_recoil_mults.standing,
				-0.4 * self.stat_info.stance_recoil_mults.standing,
				1.2 * self.stat_info.stance_recoil_mults.standing
			},
			crouching = {
				0.8 * self.stat_info.stance_recoil_mults.crouching,
				1.0 * self.stat_info.stance_recoil_mults.crouching,
				-0.4 * self.stat_info.stance_recoil_mults.crouching,
				1.2 * self.stat_info.stance_recoil_mults.crouching
			},
			steelsight = {
				0.8 * self.stat_info.stance_recoil_mults.steelsight,
				1.0 * self.stat_info.stance_recoil_mults.steelsight,
				-0.4 * self.stat_info.stance_recoil_mults.steelsight,
				1.2 * self.stat_info.stance_recoil_mults.steelsight
			}
		},

		--DMRs, Sniper Rifles, and heavy shotguns will be around here.
		vertical_kick = {
			standing = {
				1.5 * self.stat_info.stance_recoil_mults.standing,
				1.58 * self.stat_info.stance_recoil_mults.standing,
				-0.16 * self.stat_info.stance_recoil_mults.standing,
				0.16 * self.stat_info.stance_recoil_mults.standing
			},
			crouching = {
				1.5 * self.stat_info.stance_recoil_mults.crouching,
				1.58 * self.stat_info.stance_recoil_mults.crouching,
				-0.16 * self.stat_info.stance_recoil_mults.crouching,
				0.16 * self.stat_info.stance_recoil_mults.crouching
			},
			steelsight = {
				1.5 * self.stat_info.stance_recoil_mults.steelsight,
				1.58 * self.stat_info.stance_recoil_mults.steelsight,
				-0.16 * self.stat_info.stance_recoil_mults.steelsight,
				0.16 * self.stat_info.stance_recoil_mults.steelsight
			}
		},

		left_kick = {
			standing = {
				1.5 * self.stat_info.stance_recoil_mults.standing,
				1.58 * self.stat_info.stance_recoil_mults.standing,
				-0.32 * self.stat_info.stance_recoil_mults.standing,
				0.0 * self.stat_info.stance_recoil_mults.standing
			},
			crouching = {
				1.5 * self.stat_info.stance_recoil_mults.crouching,
				1.58 * self.stat_info.stance_recoil_mults.crouching,
				-0.32 * self.stat_info.stance_recoil_mults.crouching,
				0.0 * self.stat_info.stance_recoil_mults.crouching
			},
			steelsight = {
				1.5 * self.stat_info.stance_recoil_mults.steelsight,
				1.58 * self.stat_info.stance_recoil_mults.steelsight,
				-0.32 * self.stat_info.stance_recoil_mults.steelsight,
				0.0 * self.stat_info.stance_recoil_mults.steelsight
			}
		},

		right_kick = {
			standing = {
				1.5 * self.stat_info.stance_recoil_mults.standing,
				1.58 * self.stat_info.stance_recoil_mults.standing,
				-0.0 * self.stat_info.stance_recoil_mults.standing,
				0.32 * self.stat_info.stance_recoil_mults.standing
			},
			crouching = {
				1.5 * self.stat_info.stance_recoil_mults.crouching,
				1.58 * self.stat_info.stance_recoil_mults.crouching,
				-0.0 * self.stat_info.stance_recoil_mults.crouching,
				0.32 * self.stat_info.stance_recoil_mults.crouching
			},
			steelsight = {
				1.5 * self.stat_info.stance_recoil_mults.steelsight,
				1.58 * self.stat_info.stance_recoil_mults.steelsight,
				-0.0 * self.stat_info.stance_recoil_mults.steelsight,
				0.32 * self.stat_info.stance_recoil_mults.steelsight
			}
		}
	}

	--[[
	for type, _ in pairs(self.stat_info.kick_tables) do
		self.stat_info.kick_tables[type] = {
			standing = {0.85, -0.85, 0.85, -0.85},
			crouching = {0.85, -0.85, 0.85, -0.85},
			steelsight = {0.85, -0.85, 0.85, -0.85}
		}
	end
	]]

	--Generate PRNG tables for recoil patterns.
	local function generate_circle_pattern(angle, size, switch)
		local pattern = {}
		for i = 1, size, 1 do
			table.insert(pattern, {
				(math.sin(i * angle) + 1) * 0.5,
				(math.cos(i * angle) + 1) * 0.5
			})
		end

		if switch then
			for i = 1, size, 1 do
				table.insert(pattern, {
					((math.sin(i * angle) * -1) + 1) * 0.5,
					((math.cos(i * angle) * -1) + 1) * 0.5
				})
			end
		end

		return pattern
	end

	local circle_cw = generate_circle_pattern(24, 15)
	local circle_ccw = generate_circle_pattern(-24, 15)
	local circle_switch = generate_circle_pattern(36, 10, true)

	self.stat_info.kick_patterns = {
		zigzag_1 = {pattern = circle_cw, random_range = {2, 4}},
		zigzag_2 = {pattern = circle_ccw, random_range = {2, 4}},
		zigzag_3 = {pattern = circle_switch, random_range = {2, 4}},
		jumpy_1 = {pattern = circle_cw, random_range = {3, 6}},
		jumpy_2 = {pattern = circle_ccw, random_range = {3, 6}},
		jumpy_3 = {pattern = circle_switch, random_range = {3, 6}},
		random = {pattern = circle_cw, random_range = {1, 15}}
	}

	for k, v in pairs(self.stat_info.kick_patterns) do
		local x_bias = 0
		local y_bias = 0
		for i, k in ipairs(v) do
			x_bias = x_bias + (k[1] * 2 - 1)
			y_bias = y_bias + (k[2] * 2 - 1)
		end

		if x_bias > 0.05 or y_bias > 0.05 then
			log(k .. " has bias! x=" .. tostring(x_bias) .. " y=" .. tostring(y_bias))
		end
	end

	self.stat_info.autohit_angle = 1.5
	self.stat_info.autohit_head_difficulty_factor = 0.75
	self.stat_info.ricochet_autohit_angle = 6 --Ricochets need a fairly decently sized auto-hit angle to be usable.
	self.stat_info.suppression_angle = 9
end

Hooks:PostHook( WeaponTweakData, "init", "SC_weapons", function(self)
	self.trip_mines.damage = 40
	self.trip_mines.player_damage = 20
	self.trip_mines.damage_size = 200
	self.trip_mines.delay = 0.1

	for i, weap in pairs(self) do
		if weap.categories and weap.stats then --Nil out various values globally, since most are not needed.
			if weap.CAN_TOGGLE_FIREMODE then
				weap.BURST_FIRE = false
			end

			if weap.upgrade_blocks then
				weap.upgrade_blocks = nil
			end

			if weap.stats_modifiers then
				weap.stats_modifiers = nil
			end

			if weap.AMMO_MAX then
				weap.AMMO_MAX = nil
			end
		end
	end

	--Bootleg tier (Primary)
		--Bootleg
		self.tecci.supported = true --ALWAYS include this flag for weapons indended to be used by players. Without it, the gun becomes unselectable.
		self.tecci.kick = self.stat_info.kick_tables.horizontal_recoil
		self.tecci.kick_pattern = self.stat_info.kick_patterns.zigzag_3
		self.tecci.CLIP_AMMO_MAX = 100
		self.tecci.fire_rate_multiplier = 1.05 --700 rpm
		self.tecci.CAN_TOGGLE_FIREMODE = true
		--self.tecci.auto.fire_rate = 0.075 --For fire-rate tweaks, try out both the fire_rate_multiplier and directly changing timers to see what feels better.
		self.tecci.stats = {
			--Stats not included in this table are auto-calculated.
			--Ones that are commented out are optional, and will be given default values = to what the comments set them to if nonexistent.
			damage = 18,
			--Controls the overall spread and range of the gun.
			--Cosmetically, it influences passive weapon sway. (TODO)
			spread = 16,
			--Controls the amount of recoil and bloom the gun has.
			--Cosmetically, it influences camera shake from shooting.
			recoil = 18,
			--Controls the moving spread, swap speed, and ADS speed of the gun.
			--Cosmetically, it influences weapon sway from camera movement. (TODO)
			concealment = 10, --Corresponds to "mobility" from the player's perspective.
			value = 1
			--zoom = 1
			--alert_size = 2 --Set to 1 for internally suppressed guns.
		}
		self.tecci.timers = {
			--Set reload timers to match the time the reload animation *completes*.
			--Firing is blocked until this point is reached, unless you (hard) cancel the animation.
			--Because actions that can cancel reloads between the reload_operational time and the end of the animation require commitment, use these for informing balance.
			reload_not_empty = 4.6,
			reload_empty = 5.3,
			--Set this to equal the time at which the magazine is inserted into the gun, or when the bolt is re-cocked.
			--This is the point at which the ammo counter for the gun is updated, (hard) cancelling the animation from this point forward will.
			--No effect on shotgun-style reloads.
			reload_operational = 3.8,
			empty_reload_operational = 4.6,
			--Set this to equal the latest time in the reload animation the gun is still operational.
			--Prior to this, non-animation-locking actions like sprinting or aiming down sights will cancel the reload. 
			--No effect on shotgun-style reloads.
			reload_interrupt = 0.65,
			empty_reload_interrupt = 0.65,
			--Swap speed stuff.
			unequip = 0.6,
			equip = 0.7
		}
		--Set a hidden reload speed multiplier if reload speed needs to be changed for balance or game-feel. Use timers for animation syncing.
		self.tecci.reload_speed_multiplier = 1.1 --4.2/4.8s
		--Ditto for swap speed.
		--self.tecci.swap_speed_multiplier = 1.0 --

	--Light Rifles (PRIMARY)
		--Amcar
		self.amcar.desc_id = "bm_menu_sc_amcar_desc"
		self.amcar.CLIP_AMMO_MAX = 30
		self.amcar.fire_mode_data.fire_rate = 0.075 --The audio and animation doesn't feel right when changed by the multiplier. 
		self.amcar.auto.fire_rate = 0.075
		self.amcar.kick = self.stat_info.kick_tables.even_recoil
		self.amcar.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.amcar.supported = true
		self.amcar.stats = {
			damage = 20,
			spread = 16,
			recoil = 17,
			concealment = 14,
			value = 1
		}
		self.amcar.timers = {
			reload_not_empty = 2.6,
			reload_empty = 3.2,
			reload_interrupt = 0.8,
			empty_reload_interrupt = 0.7,
			reload_operational = 2.0,
			empty_reload_operational = 2.65,
			unequip = 0.6,
			equip = 0.55
		}

		--JP36
		self.g36.BURST_FIRE = 3
		self.g36.ADAPTIVE_BURST_SIZE = false
		self.g36.fire_rate_multiplier = 1.062 --750 rpm
		self.g36.CLIP_AMMO_MAX = 30
		self.g36.kick = self.stat_info.kick_tables.even_recoil
		self.g36.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.g36.supported = true
		self.g36.stats = {
			damage = 20,
			spread = 18,
			recoil = 18,
			concealment = 13,
			value = 1
		}
		self.g36.timers = {
			reload_not_empty = 3.5,
			reload_empty = 4.45,
			reload_interrupt = 0.8,
			empty_reload_interrupt = 0.8,
			reload_operational = 2.75,
			empty_reload_operational = 3.55,
			unequip = 0.6,
			equip = 0.6
		}
		self.g36.reload_speed_multiplier = 1.14 --3/3.9s

		--Lion's Roar
		self.vhs.CLIP_AMMO_MAX = 30
		self.vhs.fire_mode_data.fire_rate = 0.06976744186
		self.vhs.CAN_TOGGLE_FIREMODE = true
		self.vhs.auto = {}
		self.vhs.auto.fire_rate = 0.06976744186
		self.vhs.kick = self.stat_info.kick_tables.right_recoil
		self.vhs.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.vhs.supported = true
		self.vhs.stats = {
			damage = 20,
			spread = 18,
			recoil = 15,
			concealment = 17,
			value = 9
		}
		self.vhs.stats_modifiers = nil
		self.vhs.timers = {
			reload_not_empty = 4.15,
			reload_empty = 5.25,
			reload_interrupt = 0.95,
			empty_reload_interrupt = 0.9,
			reload_operational = 3.3,
			empty_reload_operational = 4.5,
			unequip = 0.6,
			equip = 0.6
		}
		self.vhs.reload_speed_multiplier = 1.19 --3.5/4.4s

		--Commando 553
		self.s552.fire_mode_data.fire_rate = 0.08571428571
		self.s552.auto.fire_rate = 0.08571428571
		self.s552.BURST_FIRE = 3
		self.s552.ADAPTIVE_BURST_SIZE = false
		self.s552.kick = self.stat_info.kick_tables.right_recoil
		self.s552.kick_pattern = self.stat_info.kick_patterns.random
		self.s552.supported = true
		self.s552.stats = {
			damage = 20,
			spread = 17,
			recoil = 15,
			concealment = 14,
			value = 1
		}
		self.s552.timers = {
			reload_not_empty = 2.4,
			reload_empty = 3.05,
			reload_operational = 1.7,
			empty_reload_operational = 2.25,
			reload_interrupt = 0.6,
			empty_reload_interrupt = 0.6,
			unequip = 0.55,
			equip = 0.7
		}
		self.s552.reload_speed_multiplier = 1.13 --2.1/2.7s

		--Union 5.56
		self.corgi.CLIP_AMMO_MAX = 30
		self.corgi.fire_rate_multiplier = 1.0501 --900 rpm
		self.corgi.CAN_TOGGLE_FIREMODE = true
		self.corgi.kick = self.stat_info.kick_tables.moderate_kick
		self.corgi.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.corgi.supported = true
		self.corgi.stats = {
			damage = 20,
			spread = 16,
			recoil = 14,
			concealment = 15,
			value = 9
		}
		self.corgi.stats_modifiers = nil
		self.corgi.timers = {
			reload_not_empty = 2.6,
			reload_empty = 3.4,
			reload_interrupt = 0.8,
			empty_reload_interrupt = 0.7,
			reload_operational = 2.0,
			empty_reload_operational = 2.75,
			unequip = 0.6,
			equip = 0.6
		}
		self.corgi.reload_speed_multiplier = 1.06 --2.5/3.2s

	--Light Rifles (SECONDARY)
		--Para
		self.olympic.desc_id = "bm_menu_sc_olympic_desc"
		self.olympic.categories = {
			"assault_rifle"
		}
		self.olympic.CLIP_AMMO_MAX = 30
		self.olympic.fire_mode_data.fire_rate = 0.075
		self.olympic.auto.fire_rate = 0.075
		self.olympic.kick = self.stat_info.kick_tables.even_recoil
		self.olympic.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.olympic.supported = true
		self.olympic.stats = {
			damage = 20,
			spread = 15,
			recoil = 15,
			concealment = 16,
			value = 1
		}
		self.olympic.timers = {
			reload_not_empty = 3,
			reload_empty = 3.85,
			reload_interrupt = 0.7,
			empty_reload_interrupt = 0.7,
			reload_operational = 2,
			empty_reload_operational = 3.2,
			unequip = 0.6,
			equip = 0.55
		}
		self.olympic.reload_speed_multiplier = 1.2 --2.5/3.2s

		--Tempest 21
		self.komodo.use_data.selection_index = 1
		self.komodo.desc_id = "bm_menu_sc_olympic_desc"
		self.komodo.categories = {
			"assault_rifle"
		}
		self.komodo.CLIP_AMMO_MAX = 30
		self.komodo.fire_rate_multiplier = 1.125
		self.komodo.kick = self.stat_info.kick_tables.moderate_kick
		self.komodo.kick_pattern = self.stat_info.kick_patterns.jumpy_2
		self.komodo.supported = true
		self.komodo.stats = {
			damage = 20,
			spread = 16,
			recoil = 14,
			concealment = 16,
			value = 1
		}
		self.komodo.timers = {
			reload_not_empty = 2.75,
			reload_empty = 3.45,
			reload_interrupt = 0.6,
			empty_reload_interrupt = 0.6,
			reload_operational = 2,
			empty_reload_operational = 2.7,
			unequip = 0.65,
			equip = 0.6
		}

		--Clarion
		self.famas.use_data.selection_index = 1
		self.famas.CLIP_AMMO_MAX = 25
		self.famas.BURST_FIRE = 3
		self.famas.FIRE_MODE = "burst"
		self.famas.ADAPTIVE_BURST_SIZE = false
		self.famas.CAN_TOGGLE_FIREMODE = true
		self.famas.kick = self.stat_info.kick_tables.vertical_kick
		self.famas.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.famas.supported = true
		self.famas.stats = {
			damage = 20,
			spread = 17,
			recoil = 15,
			concealment = 16,
			value = 1
		}
		self.famas.timers = {
			reload_not_empty = 3.2,
			reload_empty = 4.1,
			reload_operational = 2.55,
			empty_reload_operational = 3.6,
			reload_interrupt = 0.7,
			empty_reload_interrupt = 0.7,
			unequip = 0.55,
			equip = 0.6
		}
		self.famas.reload_speed_multiplier = 1.075 --2.9/3.8s

	--Medium Rifles (PRIMARY)
		--AK
		self.ak74.desc_id = "bm_menu_sc_ak74_desc"
		self.ak74.fire_mode_data.fire_rate = 0.0923076923
		self.ak74.auto.fire_rate = 0.0923076923
		self.ak74.kick = self.stat_info.kick_tables.right_recoil
		self.ak74.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.ak74.supported = true
		self.ak74.stats = {
			damage = 24,
			spread = 17,
			recoil = 15,
			concealment = 14,
			value = 1
		}
		self.ak74.timers = {
			reload_not_empty = 3.4,
			reload_empty = 4.3,
			reload_operational = 2.7,
			empty_reload_operational = 3.8,
			reload_interrupt = 0.66,
			empty_reload_interrupt = 0.66,
			unequip = 0.5,
			equip = 0.6
		}
		self.ak74.reload_speed_multiplier = 1.23 --2.8/3.5s

		--Car 4
		self.new_m4.desc_id = "bm_menu_sc_m4_desc"
		self.new_m4.fire_mode_data.fire_rate = 0.08571428571
		self.new_m4.auto.fire_rate = 0.08571428571
		self.new_m4.kick = self.stat_info.kick_tables.moderate_kick
		self.new_m4.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.new_m4.supported = true
		self.new_m4.stats = {
			damage = 24,
			spread = 16,
			recoil = 16,
			concealment = 14,
			value = 1
		}
		self.new_m4.timers = {
			reload_not_empty = 3.3,
			reload_empty = 4.1,
			reload_operational = 2.665,
			empty_reload_operational = 3.4,
			reload_interrupt = 0.67,
			empty_reload_interrupt = 0.75,
			unequip = 0.6,
			equip = 0.6
		}
		self.new_m4.reload_speed_multiplier = 1.07 --3.1/3.8s

		--UAR
		self.aug.AMMO_MAX = 150
		self.aug.kick = self.stat_info.kick_tables.moderate_right_kick
		self.aug.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.aug.supported = true
		self.aug.stats = {
			damage = 24,
			spread = 16,
			recoil = 13,
			concealment = 17,
			value = 1
		}
		self.aug.timers = {
			reload_not_empty = 3.65,
			reload_empty = 4.1,
			reload_operational = 2.5,
			empty_reload_operational = 3.25,
			reload_interrupt = 0.85,
			empty_reload_interrupt = 85,
			unequip = 0.5,
			equip = 0.5
		}
		self.aug.reload_speed_multiplier = 1.05 --3.5/3.9s

		--Ak17
		self.flint.CLIP_AMMO_MAX = 30
		self.flint.BURST_FIRE = 3
		self.flint.BURST_FIRE_RATE_MULTIPLIER = 1.53846153833 --1000 rpm in burst fire, 650 otherwise.
		self.flint.fire_mode_data.fire_rate = 0.09230769230 --650 rpm
		self.flint.auto.fire_rate = 0.09230769230
		self.flint.ADAPTIVE_BURST_SIZE = false
		self.flint.FIRE_MODE = "burst"
		self.flint.kick = self.stat_info.kick_tables.moderate_right_kick
		self.flint.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.flint.supported = true
		self.flint.stats = {
			damage = 24,
			spread = 17,
			recoil = 14,
			concealment = 12,
			value = 1
		}
		self.flint.timers = {
			reload_not_empty = 2.7,
			reload_empty = 3.7,
			reload_operational = 2.25,
			empty_reload_operational = 3.2,
			reload_interrupt = 0.45,
			empty_reload_interrupt = 0.45,
			unequip = 0.5,
			equip = 0.5
		}
		self.flint.swap_speed_multiplier = 0.95

		--Ak5
		self.ak5.auto.fire_rate = 0.08571428571
		self.ak5.fire_mode_data.fire_rate = 0.08571428571
		self.ak5.kick = self.stat_info.kick_tables.moderate_right_kick
		self.ak5.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.ak5.supported = true
		self.ak5.stats = {
			damage = 24,
			spread = 15,
			recoil = 15,
			concealment = 14,
			value = 1
		}
		self.ak5.timers = {
			reload_not_empty = 2.85,
			reload_empty = 3.85,
			reload_operational = 2,
			empty_reload_operational = 3.1,
			reload_interrupt = 0.6,
			empty_reload_interrupt = 0.65,
			unequip = 0.6,
			equip = 0.45
		}
		self.ak5.reload_speed_multiplier = 1.20 --2.4/3.2s

		--SABR
		if self.osipr then
			self.osipr.tactical_reload = 1
			self.osipr.AMMO_MAX = 120
			self.osipr.CLIP_AMMO_MAX = 30
			self.osipr.fire_mode_data.fire_rate = 0.075
			self.osipr.auto.fire_rate = 0.075
			self.osipr.kick = self.stat_info.kick_tables.moderate_kick
			self.osipr.kick_pattern = self.stat_info.kick_patterns.zigzag_3
			self.osipr.supported = true
			self.osipr.stats = {
				damage = 24,
				spread = 18,
				recoil = 17,
				concealment = 7,
				value = 1
			}
			self.osipr.timers = {
				reload_not_empty = 3,
				reload_empty = 4,
				reload_operational = 2.06,
				empty_reload_operational = 3.06,
				reload_interrupt = 0.67,
				empty_reload_interrupt = 0.67,
				unequip = 0.6,
				equip = 0.6
			}
			self.osipr.has_description = true
			self.osipr.desc_id = "bm_w_osipr_desc"
			self.osipr.custom = false

			self.osipr_gl.AMMO_MAX = 8
			self.osipr_gl.CLIP_AMMO_MAX = 6
			self.osipr_gl.fire_mode_data.fire_rate = 0.75
			self.osipr_gl.kick = self.stat_info.kick_tables.vertical_kick
			self.osipr_gl.kick_pattern = self.stat_info.kick_patterns.random
			self.osipr_gl.supported = true
			self.osipr_gl.stats = {
				damage = 60,
				spread = 17,
				recoil = 5,
				concealment = 7,
				value = 1
			}
			self.osipr_gl.timers = {
				reload_not_empty = 4.1,
				reload_empty = 4.9,
				reload_operational = 3.3,
				empty_reload_operational = 4.15,
				reload_interrupt = 1,
				empty_reload_interrupt = 1,
				equip = 0.6,
				unequip = 0.6,
				equip_underbarrel = 1.55,
				unequip_underbarrel = 1.55
			}
			self.osipr_gl.custom = false
			self.osipr_gl_npc.sounds.prefix = "contrabandm203_npc"
			self.osipr_gl_npc.use_data.selection_index = 2
			self.osipr_gl_npc.DAMAGE = 2
			self.osipr_gl_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
			self.osipr_gl_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
			self.osipr_gl_npc.no_trail = true
			self.osipr_gl_npc.CLIP_AMMO_MAX = 3
			self.osipr_gl_npc.NR_CLIPS_MAX = 1
			self.osipr_gl_npc.auto.fire_rate = 0.1
			self.osipr_gl_npc.hold = "rifle"
			self.osipr_gl_npc.alert_size = 2800
			self.osipr_gl_npc.suppression = 1
			self.osipr_gl_npc.FIRE_MODE = "auto"
		else
			log("[ERROR] Beardlib was unable to load the custom weapons. Check to make sure you installed Beardlib correctly!")
			self.crash.crash = math.huge
		end

	--Medium Rifles (SECONDARY)
		--CR 805B
		self.hajk.BURST_FIRE = 3
		self.hajk.ADAPTIVE_BURST_SIZE = false
		self.hajk.kick = self.stat_info.kick_tables.moderate_kick
		self.hajk.kick_pattern = self.stat_info.kick_patterns.random
		self.hajk.categories = {
			"assault_rifle"
		}
		self.hajk.supported = true
		self.hajk.stats = {
			damage = 24,
			spread = 15,
			recoil = 15,
			concealment = 15,
			value = 1
		}
		self.hajk.timers = {
			reload_not_empty = 2.5,
			reload_empty = 3.7,
			reload_operational = 1.8,
			empty_reload_operational = 3.15,
			reload_interrupt = 0.51,
			empty_reload_interrupt = 0.54,
			equip = 0.6,
			unequip = 0.6
		}

	--Heavy Rifles (PRIMARY)
		--AK.762
		self.akm.desc_id = "bm_menu_sc_akm_desc"
		self.akm.fire_mode_data.fire_rate = 0.1
		self.akm.auto.fire_rate = 0.1
		self.akm.kick = self.stat_info.kick_tables.right_kick
		self.akm.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.akm.supported = true
		self.akm.stats = {
			damage = 30,
			spread = 17,
			recoil = 13,
			concealment = 13,
			value = 1
		}
		self.akm.timers = {
			reload_not_empty = 3.0,
			reload_empty = 4.5,
			reload_operational = 2.15,
			empty_reload_operational = 3.7,
			reload_interrupt = 0.67,
			empty_reload_interrupt = 0.67,
			unequip = 0.5,
			equip = 0.6
		}
		self.akm.reload_speed_multiplier = 1.22 --2.5/3.7s

		--Ak.762 (Gold)
		self.akm_gold.desc_id = "bm_menu_sc_akm_gold_desc"
		self.akm_gold.kick = self.stat_info.kick_tables.right_kick
		self.akm_gold.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.akm_gold.fire_mode_data.fire_rate = 0.1
		self.akm_gold.auto.fire_rate = 0.1
		self.akm_gold.supported = true
		self.akm_gold.stats = {
			damage = 30,
			spread = 17,
			recoil = 13,
			concealment = 13,
			value = 1
		}
		self.akm_gold.timers = {
			reload_not_empty = 3.0,
			reload_empty = 4.5,
			reload_operational = 2.15,
			empty_reload_operational = 3.65,
			reload_interrupt = 0.67,
			empty_reload_interrupt = 0.67,
			unequip = 0.5,
			equip = 0.6
		}
		self.akm.reload_speed_multiplier = 1.22 --2.5/3.7s

		--Queen's Wrath
		self.l85a2.CLIP_AMMO_MAX = 30
		self.l85a2.FIRE_MODE = "auto"
		self.l85a2.fire_mode_data = {}
		self.l85a2.fire_mode_data.fire_rate = 0.0923076923
		self.l85a2.CAN_TOGGLE_FIREMODE = true
		self.l85a2.auto = {}
		self.l85a2.auto.fire_rate = 0.0923076923
		self.l85a2.kick = self.stat_info.kick_tables.moderate_kick
		self.l85a2.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.l85a2.supported = true
		self.l85a2.stats = {
			damage = 30,
			spread = 18,
			recoil = 12,
			concealment = 16,
			value = 9
		}
		self.l85a2.timers = {
			reload_not_empty = 3.8,
			reload_empty = 4.5,
			reload_operational = 3,
			empty_reload_operational = 3.8,
			reload_interrupt = 0.9,
			empty_reload_interrupt = 0.6,
			unequip = 0.45,
			equip = 0.75
		}

		--AMR-16
		self.m16.desc_id = "bm_menu_sc_m16_desc"
		self.m16.fire_mode_data.fire_rate = 0.08571428571
		self.m16.auto.fire_rate = 0.08571428571
		self.m16.CLIP_AMMO_MAX = 30
		self.m16.FIRE_MODE = "auto"
		self.m16.CAN_TOGGLE_FIREMODE = true
		self.m16.kick = self.stat_info.kick_tables.vertical_kick
		self.m16.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.m16.supported = true
		self.m16.stats = {
			damage = 30,
			spread = 16,
			recoil = 15,
			concealment = 12,
			value = 1
		}
		self.m16.timers = {
			reload_not_empty = 3.35,
			reload_empty = 4.2,
			reload_operational = 2.6,
			empty_reload_operational = 3.55,
			reload_interrupt = 0.45,
			empty_reload_interrupt = 0.45,
			unequip = 0.6,
			equip = 0.6
		}
		self.m16.reload_speed_multiplier = 1.075 --3.2/4.0s

		--Falcon
		self.fal.CLIP_AMMO_MAX = 30
		self.fal.fire_mode_data.fire_rate = 0.08571428571
		self.fal.CAN_TOGGLE_FIREMODE = true
		self.fal.auto = {}
		self.fal.auto.fire_rate = 0.08571428571
		self.fal.kick = self.stat_info.kick_tables.moderate_left_kick
		self.fal.kick_pattern = self.stat_info.kick_patterns.random
		self.fal.supported = true
		self.fal.stats = {
			damage = 30,
			spread = 16,
			recoil = 13,
			concealment = 12,
			value = 4
		}
		self.fal.timers = {
			reload_not_empty = 2.8,
			reload_empty = 3.75,
			reload_operational = 2.1,
			empty_reload_operational = 3.05,
			reload_interrupt = 0.86,
			empty_reload_interrupt = 0.86,
			unequip = 0.6,
			equip = 0.6
		}
		self.fal.reload_speed_multiplier = 1.17 --2.4/3.2s

	--Heavy Rifles (SECONDARY)
		--Krinkov
		self.akmsu.categories = {
			"assault_rifle"
		}
		self.akmsu.fire_rate_multiplier = 0.7908333 --650 rpm
		self.akmsu.kick = self.stat_info.kick_tables.moderate_right_kick
		self.akmsu.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.akmsu.supported = true
		self.akmsu.stats = {
			damage = 30,
			spread = 15,
			recoil = 14,
			concealment = 13,
			value = 1
		}
		self.akmsu.timers = {
			reload_not_empty = 2.6,
			reload_empty = 4.4,
			reload_operational = 1.95,
			empty_reload_operational = 3.55,
			reload_interrupt = 0.48,
			empty_reload_interrupt = 0.48,
			unequip = 0.55,
			equip = 0.6
		}
		self.akmsu.reload_speed_multiplier = 1.135 --2.3/3.9s

	--Light DMR (PRIMARY)
		--Eagle Heavy
		self.scar.fire_rate_multiplier = 1.029 --630 rpm.
		self.scar.CAN_TOGGLE_FIREMODE = true
		self.scar.CLIP_AMMO_MAX = 20
		self.scar.kick = self.stat_info.kick_tables.vertical_kick
		self.scar.kick_pattern = self.stat_info.kick_patterns.random
		self.scar.supported = true
		self.scar.stats = {
			damage = 45,
			spread = 16,
			recoil = 14,
			concealment = 11,
			value = 9
		}
		self.scar.timers = {
			reload_not_empty = 2.8,
			reload_empty = 3.65,
			reload_operational = 1.7,
			empty_reload_operational = 2.8,
			reload_interrupt = 0.56,
			empty_reload_interrupt = 0.59,
			unequip = 0.6,
			equip = 0.5
		}
		self.scar.reload_speed_multiplier = 0.9125 --3.1/4s
		self.scar.swap_speed_multiplier = 0.81

		--Byk-1
		self.groza.desc_id = "bm_m203_weapon_sc_desc"
		self.groza.has_description = true
		self.groza.AMMO_MAX = 60
		self.groza.tactical_reload = 1
		self.groza.fire_rate_multiplier = 1.00333333333 --700 rpm.
		self.groza.kick = self.stat_info.kick_tables.vertical_kick
		self.groza.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.groza.supported = true
		self.groza.stats = {
			damage = 45,
			spread = 14,
			recoil = 11,
			concealment = 14,
			value = 1
		}
		self.groza.timers = {
			reload_not_empty = 2.75,
			reload_empty = 3.4,
			reload_operational = 2.1,
			empty_reload_operational = 2.8,
			reload_interrupt = 0.45,
			empty_reload_interrupt = 0.45,
			unequip = 0.6,
			equip = 0.6
		}
		self.groza.reload_speed_multiplier = 0.89 --3.1/3.8s
		self.groza.swap_speed_multiplier = 0.9
		self.groza_underbarrel.upgrade_blocks = {
			weapon = {
				"clip_ammo_increase"
			}
		}
		self.groza_underbarrel.kick = self.stat_info.kick_tables.vertical_kick
		self.groza_underbarrel.kick_pattern = self.stat_info.kick_patterns.random
		self.groza_underbarrel.ignore_damage_upgrades = true
		self.groza_underbarrel.AMMO_MAX = 6
		self.groza_underbarrel.supported = true
		self.groza_underbarrel.stats = {
			damage = 40,
			spread = 5,
			recoil = 5,
			concealment = 14,
			value = 1
		}
		self.groza_underbarrel.timers = {
			reload_not_empty = 1.3,
			reload_empty = 1.3,
			reload_operational = 0.85,
			empty_reload_operational = 0.85,
			reload_interrupt = 0.55,
			empty_reload_interrupt = 0.55,
			unequip = 0.6,
			equip = 0.6,
			equip_underbarrel = 0.55,
			unequip_underbarrel = 0.65
		}
		self.groza_underbarrel.reload_speed_multiplier = 0.75
		self.groza_underbarrel.stats_modifiers = {damage = 10}

		--Valkyria
		self.asval.sounds.fire = "akm_fire_single"
		self.asval.sounds.fire_single = "akm_fire_single"
		self.asval.sounds.fire_auto = "akm_fire"
		self.asval.sounds.stop_fire = "akm_stop"
		self.asval.sounds.dryfire = "primary_dryfire"
		self.asval.fire_rate_multiplier = 1.005 --900 rpm
		self.asval.CLIP_AMMO_MAX = 20
		self.asval.kick = self.stat_info.kick_tables.moderate_kick
		self.asval.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.asval.supported = true
		self.asval.stats = {
			damage = 45,
			spread = 17,
			recoil = 11,
			concealment = 12,
			value = 1,
			alert_size = 1
		}
		self.asval.timers = {
			reload_not_empty = 3.1,
			reload_empty = 4.2,
			reload_operational = 2.55,
			empty_reload_operational = 3.35,
			reload_interrupt = 0.65,
			empty_reload_interrupt = 0.65,
			unequip = 0.5,
			equip = 0.5
		}
		self.asval.swap_speed_multiplier = 0.81

		--Gecko 7.62
		self.galil.fire_rate_multiplier = 0.8875 --750 rpm
		self.galil.CLIP_AMMO_MAX = 30
		self.galil.kick = self.stat_info.kick_tables.moderate_right_kick
		self.galil.kick_pattern = self.stat_info.kick_patterns.random
		self.galil.supported = true
		self.galil.stats = {
			damage = 45,
			spread = 17,
			recoil = 13,
			concealment = 6,
			value = 4
		}
		self.galil.timers = {
			reload_not_empty = 3.3,
			reload_empty = 4.2,
			reload_operational = 2.5,
			empty_reload_operational = 3.65,
			reload_interrupt = 0.52,
			empty_reload_interrupt = 0.47,
			unequip = 0.6,
			equip = 0.6
		}
		self.galil.reload_speed_multiplier = 0.933333 --3.5/4.5s
		self.asval.swap_speed_multiplier = 0.81
		
		--Little Friend Rifle
		self.contraband.desc_id = "bm_m203_weapon_sc_desc"
		self.contraband.has_description = true
		self.contraband.AMMO_MAX = 60
		self.contraband.tactical_reload = 1
		self.contraband.FIRE_MODE = "auto"
		self.contraband.fire_mode_data.fire_rate = 0.1
		self.contraband.CAN_TOGGLE_FIREMODE = true
		self.contraband.auto.fire_rate = 0.1
		self.contraband.kick = self.stat_info.kick_tables.vertical_kick
		self.contraband.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.contraband.supported = true
		self.contraband.stats = {
			damage = 45,
			spread = 17,
			recoil = 14,
			concealment = 9,
			value = 1
		}
		self.contraband.swap_speed_multiplier = 0.9
		self.contraband.timers = {
			reload_not_empty = 3.2,
			reload_empty = 3.9,
			reload_operational = 2.5,
			empty_reload_operational = 3.15,
			reload_interrupt = 0.59,
			empty_reload_interrupt = 0.59,
			unequip = 0.6,
			equip = 0.6
		}
		self.contraband_m203.upgrade_blocks = {
			weapon = {
				"clip_ammo_increase"
			}
		}
		self.contraband_m203.kick = self.stat_info.kick_tables.vertical_kick
		self.contraband_m203.kick_pattern = self.stat_info.kick_patterns.random
		self.contraband_m203.ignore_damage_upgrades = true
		self.contraband_m203.AMMO_MAX = 6
		self.contraband_m203.supported = true
		self.contraband_m203.stats = {
			damage = 80,
			spread = 15,
			recoil = 5,
			concealment = 9,
			value = 1
		}
		self.contraband_m203.timers = {
			reload_not_empty = 2.5,
			reload_empty = 2.5,
			reload_operational = 1.8,
			empty_reload_operational = 1.8,
			reload_interrupt = 0.34,
			empty_reload_interrupt = 0.34,
			unequip = 0.6,
			equip = 0.6,
			equip_underbarrel = 0.4,
			unequip_underbarrel = 0.4
		}
		self.contraband_m203.reload_speed_multiplier = 1.25 --2s
		self.contraband_m203.stats_modifiers = {damage = 10}

	--Heavy DMR (PRIMARY)
		--Galant--
		self.ching.CLIP_AMMO_MAX = 8
		self.ching.CAN_TOGGLE_FIREMODE = false
		self.ching.kick = self.stat_info.kick_tables.vertical_kick
		self.ching.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.ching.supported = true
		self.ching.stats = {
			damage = 60,
			spread = 19,
			recoil = 10,
			concealment = 13,
			value = 9
		}
		self.ching.timers = {
			reload_not_empty = 3.2,
			reload_empty = 2.3,
			reload_operational = 2.1,
			empty_reload_operational = 1.4,
			reload_interrupt = 0.34,
			empty_reload_interrupt = 0.001,
			unequip = 0.6,
			equip = 0.55
		}
		self.ching.swap_speed_multiplier = 0.9

		--M308
		self.new_m14.CLIP_AMMO_MAX = 20
		self.new_m14.fire_mode_data.fire_rate = 0.08571428571 --700rpm
		self.new_m14.single.fire_rate = 0.08571428571
		self.new_m14.kick = self.stat_info.kick_tables.moderate_kick
		self.new_m14.kick_pattern = self.stat_info.kick_patterns.zigzag_3
		self.new_m14.supported = true
		self.new_m14.stats = {
			damage = 60,
			spread = 19,
			recoil = 9,
			concealment = 7,
			value = 1
		}
		self.new_m14.timers = {
			reload_not_empty = 3.1,
			reload_empty = 3.8,
			reload_operational = 2.55,
			empty_reload_operational = 3.0,
			reload_interrupt = 0.78,
			empty_reload_interrupt = 1.04,
			unequip = 0.6,
			equip = 0.55
		}
		self.new_m14.reload_speed_multiplier = 0.926 --3.3/4.1s
		self.new_m14.swap_speed_multiplier = 0.9

		--Gewehr 3
		self.g3.FIRE_MODE = "single"
		self.g3.CLIP_AMMO_MAX = 20
		self.g3.fire_mode_data.fire_rate = 0.1 --600 rpm
		self.g3.auto.fire_rate = 0.1
		self.g3.kick = self.stat_info.kick_tables.right_kick
		self.g3.kick_pattern = self.stat_info.kick_patterns.random
		self.g3.supported = true
		self.g3.stats = {
			damage = 60,
			spread = 17,
			recoil = 12,
			concealment = 9,
			value = 4
		}
		self.g3.timers = {
			reload_not_empty = 3.6,
			reload_empty = 4.6,
			reload_operational = 2.5,
			empty_reload_operational = 3.5,
			reload_interrupt = 0.64,
			empty_reload_interrupt = 0.64,
			unequip = 0.6,
			equip = 0.65
		}
		self.g3.swap_speed_multiplier = 0.9

		--KS12 Urban
		self.shak12.CLIP_AMMO_MAX = 20
		self.shak12.kick = self.stat_info.kick_tables.moderate_kick
		self.shak12.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		--The vanilla muzzle flash is actually blinding.
		--7.62 is smaller than the IRL round, but it looks far more reasonable.
		self.shak12.muzzleflash = "effects/payday2/particles/weapons/big_762_auto_fps"
		self.shak12.tactical_reload = 1
		self.shak12.supported = true
		self.shak12.stats = {
			damage = 60,
			spread = 17,
			recoil = 8,
			concealment = 13,
			value = 1
		}
		self.shak12.timers = {
			reload_not_empty = 2.7,
			reload_empty = 3.5,
			reload_operational = 2.1,
			empty_reload_operational = 2.8,
			reload_interrupt = 0.58,
			empty_reload_interrupt = 0.58,
			unequip = 0.6,
			equip = 0.6
		}
		self.shak12.reload_speed_multiplier = 0.875 --3.1/4s
		self.shak12.swap_speed_multiplier = 0.9

		--Contractor .308
		self.tti.upgrade_blocks = nil
		self.tti.categories = {
			"assault_rifle"
		}
		self.tti.armor_piercing_chance = 0
		self.tti.can_shoot_through_enemy = false
		self.tti.can_shoot_through_shield = false
		self.tti.can_shoot_through_wall = false
		self.tti.has_description = false
		self.tti.CLIP_AMMO_MAX = 20
		self.tti.fire_mode_data.fire_rate = 0.3
		self.tti.single.fire_rate = 0.3
		self.tti.kick = self.stat_info.kick_tables.vertical_kick
		self.tti.kick_pattern = self.stat_info.kick_patterns.zigzag_3
		self.tti.supported = true
		self.tti.stats = {
			damage = 60,
			spread = 20,
			recoil = 13,
			concealment = 12,
			value = 9
		}
		self.tti.timers = {
			reload_not_empty = 2.8,
			reload_empty = 3.8,
			reload_operational = 2.2,
			empty_reload_operational = 3.2,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.6,
			equip = 0.6
		}
		self.tti.stats_modifiers = nil

	--Heavy DMR (Secondary)
		--Kang Arms X1
		self.qbu88.use_data.selection_index = 1
		self.qbu88.upgrade_blocks = nil
		self.qbu88.categories = {
			"assault_rifle"
		}
		self.qbu88.armor_piercing_chance = 0
		self.qbu88.can_shoot_through_enemy = false
		self.qbu88.can_shoot_through_shield = false
		self.qbu88.can_shoot_through_wall = false
		self.qbu88.has_description = false
		self.qbu88.kick = self.stat_info.kick_tables.right_kick
		self.qbu88.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.qbu88.supported = true
		self.qbu88.stats = {
			damage = 60,
			spread = 20,
			recoil = 10,
			concealment = 15,
			value = 9
		}
		self.qbu88.timers = {
			reload_not_empty = 2.7,
			reload_empty = 3.45,
			reload_operational = 2.1,
			empty_reload_operational = 2.7,
			reload_interrupt = 0.55,
			empty_reload_interrupt = 0.55,
			unequip = 0.9,
			equip = 0.9
		}
		self.qbu88.fire_mode_data.fire_rate = 0.3
		self.qbu88.single.fire_rate = 0.3

	--Light LMG (PRIMARY)
		--KSP
		self.m249.categories = {
			"lmg",
			"smg" --All LMGs are placed in the smg category for legacy skill reasons.
		}
		self.m249.desc_id = "bm_menu_sc_m249_desc"
		self.m249.CLIP_AMMO_MAX = 200
		self.m249.fire_rate_multiplier = 0.77 --700 rpm
		self.m249.kick = self.stat_info.kick_tables.horizontal_recoil
		self.m249.kick_pattern = self.stat_info.kick_patterns.random
		self.m249.supported = true
		self.m249.stats = {
			damage = 24,
			spread = 10,
			recoil = 20,
			concealment = 6,
			value = 9
		}
		self.m249.timers = {
			reload_not_empty = 6.4,
			reload_empty = 6.4,
			reload_operational = 5.3,
			empty_reload_operational = 5.3,
			reload_interrupt = 0.53,
			empty_reload_interrupt = 0.55,
			unequip = 0.6,
			equip = 1.0,
			deploy_bipod = 1
		}

		--Brenner 21
		self.hk21.categories = {
			"lmg",
			"smg"
		}
		self.hk21.CLIP_AMMO_MAX = 100
		self.hk21.fire_rate_multiplier = 1.0373 --750 rpm
		self.hk21.kick = self.stat_info.kick_tables.horizontal_right_recoil
		self.hk21.kick_pattern = self.stat_info.kick_patterns.random
		self.hk21.supported = true
		self.hk21.stats = {
			damage = 24,
			spread = 9,
			recoil = 20,
			concealment = 9,
			value = 9
		}
		self.hk21.timers = {
			reload_not_empty = 6,
			reload_empty = 7.7,
			reload_operational = 4.5,
			empty_reload_operational = 6.65,
			reload_interrupt = 1.02,
			empty_reload_interrupt = 2.28,
			unequip = 0.6,
			equip = 1.0,
			deploy_bipod = 1
		}
		self.hk21.reload_speed_multiplier = 1.15 --5.2/6.7

	--Heavy LMG (PRIMARY)
		--Buzzsaw
		self.mg42.categories = {
			"lmg",
			"smg"
		}
		self.mg42.CLIP_AMMO_MAX = 50
		self.mg42.kick = self.stat_info.kick_tables.horizontal_right_recoil
		self.mg42.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.mg42.supported = true
		self.mg42.stats = {
			damage = 30,
			spread = 10,
			recoil = 16,
			concealment = 10,
			value = 9
		}
		self.mg42.timers = {
			reload_not_empty = 7.8,
			reload_empty = 7.8,
			reload_operational = 6.5,
			empty_reload_operational = 6.5,
			reload_interrupt = 2.4,
			empty_reload_interrupt = 2.4,
			unequip = 0.6,
			equip = 1.0,
			deploy_bipod = 1
		}
		self.mg42.reload_speed_multiplier = 1.16 --6.7s

		--M60
		self.m60.categories = {
			"lmg",
			"smg"
		}
		self.m60.CLIP_AMMO_MAX = 100
		self.m60.fire_mode_data.fire_rate = 0.10909090909
		self.m60.auto.fire_rate = 0.10909090909
		self.m60.kick = self.stat_info.kick_tables.horizontal_recoil
		self.m60.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.m60.supported = true
		self.m60.stats = {
			damage = 30,
			spread = 8,
			recoil = 19,
			concealment = 8,
			value = 9
		}
		self.m60.timers = {
			reload_not_empty = 7.25,
			reload_empty = 7.25,
			reload_operational = 6,
			empty_reload_operational = 6,
			reload_interrupt = 0.56,
			empty_reload_interrupt = 0.56,
			unequip = 0.6,
			equip = 1.0,
			deploy_bipod = 1
		}
		self.m60.reload_speed_multiplier = 1.15 --6.3s

		--RPK
		self.rpk.categories = {
			"lmg",
			"smg"
		}
		self.rpk.CLIP_AMMO_MAX = 75
		self.rpk.CAN_TOGGLE_FIREMODE = false
		self.rpk.fire_rate_multiplier = 0.8 --600rpm
		self.rpk.kick = self.stat_info.kick_tables.horizontal_right_recoil
		self.rpk.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.rpk.supported = true
		self.rpk.stats = {
			damage = 30,
			spread = 6,
			recoil = 18,
			concealment = 11,
			value = 9
		}
		self.rpk.timers = {
			reload_not_empty = 4.2,
			reload_empty = 5.4,
			reload_operational = 3.15,
			empty_reload_operational = 4.3,
			reload_interrupt = 0.93,
			empty_reload_interrupt = 0.93,
			unequip = 0.6,
			equip = 1.0,
			deploy_bipod = 1
		}
		self.rpk.swap_speed_multiplier = 0.9
		self.rpk.timers.reload_interrupt = 0.27
		self.rpk.timers.empty_reload_interrupt = 0.2
		self.rpk.reload_speed_multiplier = 1.05 --4/5.1s

		--KSP 58
		self.par.categories = {
			"lmg",
			"smg"
		}
		self.par.CLIP_AMMO_MAX = 150
		self.par.kick = self.stat_info.kick_tables.horizontal_recoil
		self.par.kick_pattern = self.stat_info.kick_patterns.random
		self.par.supported = true
		self.par.stats = {
			damage = 30,
			spread = 9,
			recoil = 18,
			concealment = 6,
			value = 9,
			reload = 20
		}
		self.par.timers = {
			reload_not_empty = 7.2,
			reload_empty = 7.2,
			reload_operational = 6.5,
			empty_reload_operational = 6.5,
			reload_interrupt = 2.34,
			empty_reload_interrupt = 2.34,
			unequip = 0.6,
			equip = 1.0,
			deploy_bipod = 1
		}
		self.par.fire_rate_multiplier = 0.715 --650 rpm.

	--Light Sniper (PRIMARY)
		--Rattlesnake
		self.msr.has_description = true
		self.msr.upgrade_blocks = nil --Mag size increase should apply to it along with other sniper rifles.
		self.msr.desc_id = "bm_ap_weapon_sc_desc"
		self.msr.fire_mode_data.fire_rate = 0.75
		self.msr.kick = self.stat_info.kick_tables.vertical_kick
		self.msr.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.msr.supported = true
		self.msr.stats = {
			damage = 90,
			spread = 19,
			recoil = 12,
			concealment = 14,
			value = 9
		}
		self.msr.timers = {
			reload_not_empty = 3.3,
			reload_empty = 4.2,
			reload_operational = 2.55,
			empty_reload_operational = 3.45,
			reload_interrupt = 0.75,
			empty_reload_interrupt = 0.75,
			unequip = 0.6,
			equip = 0.7
		}

		--R700
		self.r700.upgrade_blocks = nil
		self.r700.has_description = true
		self.r700.desc_id = "bm_ap_weapon_sc_desc"
		self.r700.kick = self.stat_info.kick_tables.vertical_kick
		self.r700.kick_pattern = self.stat_info.kick_patterns.zigzag_3
		self.r700.supported = true
		self.r700.stats = {
			damage = 90,
			spread = 21,
			recoil = 14,
			concealment = 14,
			value = 9
		}
		self.r700.timers = {
			reload_not_empty = 4.2,
			reload_empty = 5.8,
			reload_operational = 3.3,
			empty_reload_operational = 4.7,
			reload_interrupt = 0.9,
			empty_reload_interrupt = 1.6,
			unequip = 0.45,
			equip = 0.75
		}

		--Lebensauger .308
		self.wa2000.upgrade_blocks = nil
		self.wa2000.has_description = true
		self.wa2000.desc_id = "bm_ap_weapon_sc_desc"
		self.wa2000.CLIP_AMMO_MAX = 6
		self.wa2000.kick = self.stat_info.kick_tables.vertical_kick
		self.wa2000.kick_pattern = self.stat_info.kick_patterns.jumpy_2
		self.wa2000.supported = true
		self.wa2000.stats = {
			damage = 90,
			spread = 20,
			recoil = 14,
			concealment = 15,
			value = 9
		}
		self.wa2000.timers = {
			reload_not_empty = 5.2,
			reload_empty = 7,
			reload_operational = 4.6,
			empty_reload_operational = 5.7,
			reload_interrupt = 1,
			empty_reload_interrupt = 1,
			unequip = 0.9,
			equip = 0.9
		}
		self.wa2000.reload_speed_multiplier = 1.3 --4/5.4
		self.wa2000.fire_rate_multiplier = 1.33334 --200rpm
		self.wa2000.swap_speed_multiplier = 1.15


		--Repeater 1874
		self.winchester1874.upgrade_blocks = nil
		self.winchester1874.has_description = true
		self.winchester1874.desc_id = "bm_ap_weapon_sc_desc"
		self.winchester1874.CLIP_AMMO_MAX = 14
		self.winchester1874.fire_mode_data.fire_rate = 1.5
		self.winchester1874.single.fire_rate = 1.5
		self.winchester1874.fire_rate_multiplier = 1.75
		self.winchester1874.kick = self.stat_info.kick_tables.left_kick
		self.winchester1874.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.winchester1874.tactical_reload = 1
		self.winchester1874.supported = true
		self.winchester1874.stats = {
			damage = 90,
			spread = 19,
			recoil = 11,
			concealment = 17,
			value = 9
		}
		self.winchester1874.timers = {
			shotgun_reload_enter = 0.43333333333333335,
			shotgun_reload_exit_empty = 0.76666666666666,
			shotgun_reload_exit_not_empty = 0.4,
			shotgun_reload_shell = 0.5666666666666667,
			shotgun_reload_first_shell_offset = 0.2,
			unequip = 0.9,
			equip = 0.9
		}
		self.winchester1874.reload_speed_multiplier = 1.1

		--Grom
		self.siltstone.upgrade_blocks = nil
		self.siltstone.has_description = true
		self.siltstone.desc_id = "bm_ap_weapon_sc_desc"
		self.siltstone.CLIP_AMMO_MAX = 10
		self.siltstone.fire_mode_data.fire_rate = 0.6
		self.siltstone.kick = self.stat_info.kick_tables.right_kick
		self.siltstone.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.siltstone.supported = true
		self.siltstone.stats = {
			damage = 90,
			spread = 18,
			recoil = 14,
			concealment = 11,
			value = 9
		}
		self.siltstone.timers = {
			reload_not_empty = 2.9,
			reload_empty = 3.9,
			reload_operational = 2.3,
			empty_reload_operational = 3.15,
			reload_interrupt = 0.62,
			empty_reload_interrupt = 0.62,
			unequip = 0.9,
			equip = 0.9
		}
		self.siltstone.reload_speed_multiplier = 0.85 --3.4/4.6s

	--Heavy Sniper (Primary)
		--Bernetti Rangehitter
		self.sbl.upgrade_blocks = nil
		self.sbl.has_description = true
		self.sbl.desc_id = "bm_ap_weapon_sc_desc"
		self.sbl.FIRE_MODE = "single"
		self.sbl.CLIP_AMMO_MAX = 5
		self.sbl.fire_mode_data = {}
		self.sbl.fire_mode_data.fire_rate = 0.5
		self.sbl.CAN_TOGGLE_FIREMODE = false
		self.sbl.single = {}
		self.sbl.single.fire_rate = 0.5
		self.sbl.kick = self.stat_info.kick_tables.left_kick
		self.sbl.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.sbl.tactical_reload = 1
		self.sbl.supported = true
		self.sbl.stats = {
			damage = 120,
			spread = 17,
			recoil = 9,
			concealment = 15,
			value = 9
		}
		self.sbl.timers = {
			shotgun_reload_enter = 0.43333333333333335,
			shotgun_reload_exit_empty = 0.7666666666666667,
			shotgun_reload_exit_not_empty = 0.4,
			shotgun_reload_shell = 0.5666666666666667,
			shotgun_reload_first_shell_offset = 0.2,
			unequip = 0.6,
			equip = 0.6
		}
		self.sbl.swap_speed_multiplier = 0.8

		--Platypus 70
		self.model70.upgrade_blocks = nil
		self.model70.has_description = true
		self.model70.desc_id = "bm_ap_weapon_sc_desc"
		self.model70.CLIP_AMMO_MAX = 6
		self.model70.kick = self.stat_info.kick_tables.vertical_kick
		self.model70.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.model70.supported = true
		self.model70.stats = {
			damage = 120,
			spread = 21,
			recoil = 13,
			concealment = 11,
			value = 9
		}
		self.model70.timers = {
			reload_not_empty = 4,
			reload_empty = 4.8,
			reload_operational = 3.2,
			empty_reload_operational = 4.2,
			reload_interrupt = 0.6,
			empty_reload_interrupt = 0.4,
			unequip = 0.45,
			equip = 0.75
		}
		self.model70.reload_speed_multiplier = 1.12 --3.6/4.3s

		--Desert Fox
		self.desertfox.upgrade_blocks = nil
		self.desertfox.has_description = true
		self.desertfox.desc_id = "bm_ap_weapon_sc_desc"
		self.desertfox.CLIP_AMMO_MAX = 5
		self.desertfox.fire_rate_multiplier = 1.1667 --70rpm
		self.desertfox.kick = self.stat_info.kick_tables.right_kick
		self.desertfox.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.desertfox.supported = true
		self.desertfox.stats = {
			damage = 120,
			spread = 19,
			recoil = 11,
			concealment = 15,
			value = 9
		}
		self.desertfox.timers = {
			reload_not_empty = 3.5,
			reload_empty = 4.3,
			reload_operational = 2.6,
			empty_reload_operational = 3.75,
			reload_interrupt = 0.72,
			empty_reload_interrupt = 0.72,
			unequip = 0.45,
			equip = 0.75
		}

		--R93
		self.r93.upgrade_blocks = nil
		self.r93.has_description = true
		self.r93.desc_id = "bm_ap_weapon_sc_desc"
		self.r93.CLIP_AMMO_MAX = 6 --Has 5 rounds irl, but 6 makes for more interesting tradeoffs.
		self.r93.fire_mode_data.fire_rate = 1
		self.r93.kick = self.stat_info.kick_tables.vertical_kick
		self.r93.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.r93.supported = true
		self.r93.stats = {
			damage = 120,
			spread = 21,
			recoil = 16,
			concealment = 8,
			value = 9
		}
		self.r93.timers = {
			reload_not_empty = 3.5,
			reload_empty = 4.5,
			reload_operational = 2.8,
			empty_reload_operational = 3.8,
			reload_interrupt = 0.7,
			empty_reload_interrupt = 0.7,
			unequip = 0.7,
			equip = 0.65
		}
		self.r93.reload_speed_multiplier = 1.05 --3.3/4.3s

		--Nagant
		self.mosin.upgrade_blocks = nil
		self.mosin.has_description = true
		self.mosin.desc_id = "bm_ap_weapon_sc_desc"
		self.mosin.CLIP_AMMO_MAX = 5
		self.mosin.fire_mode_data.fire_rate = 1
		self.mosin.kick = self.stat_info.kick_tables.vertical_kick
		self.mosin.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.mosin.supported = true
		self.mosin.stats = {
			damage = 120,
			spread = 20,
			recoil = 14,
			concealment = 13,
			value = 9
		}
		self.mosin.timers = {
			reload_not_empty = 4.2,
			reload_empty = 4.2,
			reload_operational = 3.6,
			empty_reload_operational = 3.6,
			reload_interrupt = 0.6,
			empty_reload_interrupt = 0.6,
			unequip = 0.6,
			equip = 0.5
		}
		self.mosin.reload_speed_multiplier = 1.2 --3.5s

	--O LAWD HE COMING Sniper (Primary)
		--Thanatos .50 cal
		self.m95.upgrade_blocks = nil
		self.m95.has_description = true
		self.m95.desc_id = "bm_heavy_ap_weapon_sc_desc"
		self.m95.can_shoot_through_titan_shield = true
		self.m95.fire_rate_multiplier = 1.25 --50 rpm
		self.m95.kick = self.stat_info.kick_tables.right_kick
		self.m95.kick_pattern = self.stat_info.kick_patterns.random
		self.m95.supported = true
		self.m95.stats = {
			damage = 180,
			spread = 21,
			recoil = 6,
			concealment = 8,
			value = 9
		}
		self.m95.timers = {
			reload_not_empty = 4.9,
			reload_empty = 6,	
			reload_operational = 3.96,
			empty_reload_operational = 5.23,
			reload_interrupt = 1.36,
			empty_reload_interrupt = 1.36,
			unequip = 0.9,
			equip = 0.7
		}
		self.m95.swap_speed_multiplier = 1.2
		self.m95.reload_speed_multiplier = 1.2 --4.2/5s

	--PDW SMG (Primary)
		--Tatonka
		self.coal.use_data.selection_index = 2
		self.coal.CLIP_AMMO_MAX = 64
		self.coal.fire_mode_data.fire_rate = 0.08823529411 --680 rpm
		self.coal.auto.fire_rate = 0.08823529411
		self.coal.kick = self.stat_info.kick_tables.horizontal_right_recoil
		self.coal.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.coal.supported = true
		self.coal.stats = {
			damage = 18,
			spread = 14,
			recoil = 17,
			concealment = 17,
			value = 1
		}
		self.coal.timers = {
			reload_not_empty = 3.75,
			reload_empty = 4.75,
			reload_operational = 3.2,
			empty_reload_operational = 4.2,
			reload_interrupt = 0.52,
			empty_reload_interrupt = 0.52,
			unequip = 0.6,
			equip = 0.5
		}

	--PDW Smg (Secondary)
		--CMP
		self.mp9.CLIP_AMMO_MAX = 20
		self.mp9.auto.fire_rate = 0.0545454545454 --1100 rpm
		self.mp9.fire_mode_data.fire_rate = 0.0545454545454
		self.mp9.kick = self.stat_info.kick_tables.even_recoil
		self.mp9.kick_pattern = self.stat_info.kick_patterns.random
		self.mp9.supported = true
		self.mp9.stats = {
			damage = 18,
			spread = 14,
			recoil = 16,
			concealment = 19,
			value = 1
		}
		self.mp9.timers = {
			reload_not_empty = 2.1,
			reload_empty = 3,
			reload_operational = 1.51,
			empty_reload_operational = 2.48,
			reload_interrupt = 0.33,
			empty_reload_interrupt = 0.33,
			unequip = 0.5,
			equip = 0.4
		}

		--Heather
		self.sr2.fire_rate_multiplier = 1.2666667 --950 rpm
		self.sr2.CLIP_AMMO_MAX = 30
		self.sr2.kick = self.stat_info.kick_tables.left_recoil
		self.sr2.kick_pattern = self.stat_info.kick_patterns.random
		self.sr2.supported = true
		self.sr2.stats = {
			damage = 18,
			spread = 15,
			recoil = 14,
			concealment = 18,
			value = 1
		}
		self.sr2.timers = {
			reload_not_empty = 2.7,
			reload_empty = 4.7,
			reload_operational = 2,
			empty_reload_operational = 3.9,
			reload_interrupt = 0.58,
			empty_reload_interrupt = 0.58,
			unequip = 0.55,
			equip = 0.5
		}
		self.sr2.reload_speed_multiplier = 1.24 --2.2/3.8s

		--Kobus 90
		self.p90.fire_mode_data.fire_rate = 0.06666666666 --900 rpm
		self.p90.auto.fire_rate = 0.06666666666
		self.p90.kick = self.stat_info.kick_tables.horizontal_recoil
		self.p90.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.p90.supported = true
		self.p90.stats = {
			damage = 18,
			spread = 11,
			recoil = 15,
			concealment = 17,
			value = 1
		}
		self.p90.timers = {
			reload_not_empty = 3,
			reload_empty = 3.9,
			reload_operational = 2.55,
			empty_reload_operational = 3.35,
			reload_interrupt = 0.57,
			empty_reload_interrupt = 0.57,
			unequip = 0.68,
			equip = 0.65
		}

	--Light SMG (Primary)
		--Miyaka 10 Special
		self.pm9.use_data.selection_index = 2
		self.pm9.fire_mode_data.fire_rate = 0.05454545454 --1100 rpm
		self.pm9.auto.fire_rate = 0.05454545454
		self.pm9.kick = self.stat_info.kick_tables.even_recoil
		self.pm9.kick_pattern = self.stat_info.kick_patterns.random
		self.pm9.supported = true
		self.pm9.stats = {
			damage = 20,
			spread = 12,
			recoil = 14,
			concealment = 18,
			value = 1
		}
		self.pm9.timers = {
			reload_not_empty = 2.3,
			reload_empty = 3,
			reload_operational = 1.85,
			empty_reload_operational = 2.6,
			reload_interrupt = 0.63,
			empty_reload_interrupt = 0.63,
			unequip = 0.7,
			equip = 0.5
		}

		--Singature SMG
		self.shepheard.use_data.selection_index = 2
		self.shepheard.fire_rate_multiplier = 1.13334 --850 rpm
		self.shepheard.kick = self.stat_info.kick_tables.even_recoil
		self.shepheard.kick_pattern = self.stat_info.zigzag_1
		self.shepheard.supported = true
		self.shepheard.stats = {
			damage = 20,
			spread = 15,
			recoil = 18,
			concealment = 17,
			value = 1
		}
		self.shepheard.timers = {
			reload_not_empty = 2.65,
			reload_empty = 3.4,
			reload_operational = 2.02,
			empty_reload_operational = 2.7,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.6,
			equip = 0.5
		}
		self.shepheard.reload_speed_multiplier = 1.13333 --2.3/3s

	--Light SMG (Secondary)
		--Mark-10
		self.mac10.CLIP_AMMO_MAX = 20
		self.mac10.kick = self.stat_info.kick_tables.even_recoil
		self.mac10.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.mac10.supported = true
		self.mac10.stats = {
			damage = 20,
			spread = 14,
			recoil = 14,
			concealment = 18,
			value = 1
		}
		self.mac10.timers = {
			reload_not_empty = 2.2,
			reload_empty = 3,
			reload_operational = 1.55,
			empty_reload_operational = 2.25,
			reload_interrupt = 0.48,
			empty_reload_interrupt = 0.48,
			unequip = 0.5,
			equip = 0.5
		}
		self.mac10.reload_speed_multiplier = 1.11111 --2/2.7s

		--Jacket's Piece
		self.cobray.timers.reload_not_empty = 2
		self.cobray.timers.reload_empty = 4.25
		self.cobray.CLIP_AMMO_MAX = 30
		self.cobray.kick = self.stat_info.kick_tables.even_recoil
		self.cobray.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.cobray.auto.fire_rate = 0.06
		self.cobray.fire_mode_data.fire_rate = 0.06
		self.cobray.supported = true
		self.cobray.stats = {
			damage = 20,
			spread = 14,
			recoil = 13,
			concealment = 16,
			value = 1
		}
		self.cobray.timers = {
			reload_not_empty = 2.5,
			reload_empty = 4.9,
			reload_operational = 1.95,
			empty_reload_operational = 4.25,
			reload_interrupt = 0.6,
			empty_reload_interrupt = 0.6,
			unequip = 0.55,
			equip = 0.5
		}

		--Compact-5
		self.new_mp5.fire_rate_multiplier = 1.0666667 --800 rpm
		self.new_mp5.BURST_FIRE = 3
		self.new_mp5.ADAPTIVE_BURST_SIZE = false
		self.new_mp5.kick = self.stat_info.kick_tables.right_recoil
		self.new_mp5.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.new_mp5.supported = true
		self.new_mp5.stats = {
			damage = 20,
			spread = 16,
			recoil = 15,
			concealment = 16,
			value = 1
		}
		self.new_mp5.timers = {
			reload_not_empty = 3,
			reload_empty = 4.1,
			reload_operational = 2.4,
			empty_reload_operational = 3.5,
			reload_interrupt = 0.68,
			empty_reload_interrupt = 1.36,
			unequip = 0.6,
			equip = 0.6
		}
		self.new_mp5.reload_speed_multiplier = 1.2 --2.5/3.4s

		--Cobra
		self.scorpion.fire_rate_multiplier = 0.85 --1000 rpm
		self.scorpion.kick = self.stat_info.kick_tables.even_recoil
		self.scorpion.kick_pattern = self.stat_info.kick_patterns.jumpy_2
		self.scorpion.supported = true
		self.scorpion.stats = {
			damage = 20,
			spread = 12,
			recoil = 18,
			concealment = 20,
			value = 7
		}
		self.scorpion.timers  = {
			reload_not_empty = 2.4,
			reload_empty = 3.2,
			reload_operational = 1.95,
			empty_reload_operational = 2.7,
			reload_interrupt = 0.48,
			empty_reload_interrupt = 0.48,
			unequip = 0.7,
			equip = 0.5
		}

	--Medium SMG (Primary)
		--AK GEN 21 Tactical
		self.vityaz.tactical_reload = 1
		self.vityaz.use_data.selection_index = 2
		self.vityaz.kick = self.stat_info.kick_tables.right_recoil
		self.vityaz.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.vityaz.supported = true
		self.vityaz.stats = {
			damage = 24,
			spread = 15,
			recoil = 14,
			concealment = 17,
			value = 5
		}
		self.vityaz.timers = {
			reload_not_empty = 2.75,
			reload_empty = 3.85,
			reload_operational = 2.05,
			empty_reload_operational = 3.08,
			reload_interrupt = 0.6,
			empty_reload_interrupt = 0.6,
			unequip = 0.6,
			equip = 0.45
		}
		self.vityaz.reload_speed_multiplier = 1.15 --2.4/3.4s
		self.vityaz.fire_rate_multiplier = 1.0666667 --800rpm

		--Chicago Typewriter
		self.m1928.use_data.selection_index = 2
		self.m1928.fire_rate_multiplier = 0.968188 --700 rpm
		self.m1928.CLIP_AMMO_MAX = 50
		self.m1928.kick = self.stat_info.kick_tables.horizontal_recoil
		self.m1928.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.m1928.supported = true
		self.m1928.stats = {
			damage = 24,
			spread = 10,
			recoil = 18,
			concealment = 15,
			value = 9
		}
		self.m1928.timers = {
			reload_not_empty = 4.4,
			reload_empty = 5.3,
			reload_operational = 3.3,
			empty_reload_operational = 4.3,
			reload_interrupt = 1.04,
			empty_reload_interrupt = 1.04,
			unequip = 0.6,
			equip = 1
		}
		self.m1928.reload_speed_multiplier = 1.13 --3.9/4.7s

		--Mp40
		self.erma.use_data.selection_index = 2
		self.erma.CLIP_AMMO_MAX = 32
		self.erma.fire_mode_data.fire_rate = 0.10909090909
		self.erma.auto.fire_rate = 0.10909090909
		self.erma.kick = self.stat_info.kick_tables.horizontal_recoil
		self.erma.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.erma.supported = true
		self.erma.stats = {
			damage = 24,
			spread = 15,
			recoil = 17,
			concealment = 18,
			value = 5
		}
		self.erma.timers = {
			reload_not_empty = 2.5,
			reload_empty = 3.65,
			reload_operational = 1.85,
			empty_reload_operational = 3.05,
			reload_interrupt = 0.17,
			empty_reload_interrupt = 0.17,
			unequip = 0.5,
			equip = 0.6
		}

	--Medium SMG (Secondary)
		--Spec Ops
		self.mp7.fire_mode_data.fire_rate = 0.06315789473
		self.mp7.auto.fire_rate = 0.06315789473
		self.mp7.kick = self.stat_info.kick_tables.left_recoil
		self.mp7.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.mp7.supported = true
		self.mp7.stats = {
			damage = 24,
			spread = 12,
			recoil = 12,
			concealment = 18,
			value = 7
		}
		self.mp7.timers = {
			reload_not_empty = 2.4,
			reload_empty = 3,
			reload_operational = 1.75,
			empty_reload_operational = 2.25,
			reload_interrupt = 0.41,
			empty_reload_interrupt = 0.41,
			unequip = 0.6,
			equip = 0.5
		}

		--Blaster
		self.tec9.CLIP_AMMO_MAX = 20
		self.tec9.fire_rate_multiplier = 1.11666667 --1000 rpm.
		self.tec9.CAN_TOGGLE_FIREMODE = false
		self.tec9.kick = self.stat_info.kick_tables.even_recoil
		self.tec9.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.tec9.supported = true
		self.tec9.stats = {
			damage = 24,
			spread = 11,
			recoil = 15,
			concealment = 17,
			value = 7
		}
		self.tec9.timers = {
			reload_not_empty = 2.8,
			reload_empty = 4.2,
			reload_operational = 2.315,
			empty_reload_operational = 3.28,
			reload_interrupt = 0.82,
			empty_reload_interrupt = 0.82,
			unequip = 0.6,
			equip = 0.5
		}

		--Patchett
		self.sterling.CLIP_AMMO_MAX = 20
		self.sterling.fire_mode_data.fire_rate = 0.10909090909
		self.sterling.auto.fire_rate = 0.10909090909
		self.sterling.kick = self.stat_info.kick_tables.left_recoil 
		self.sterling.kick_pattern = self.stat_info.kick_patterns.zigzag_3
		self.sterling.supported = true
		self.sterling.stats = {
			damage = 24,
			spread = 18,
			recoil = 16,
			concealment = 17,
			value = 7
		}
		self.sterling.timers = {
			reload_not_empty = 2.9,
			reload_empty = 3.8,
			reload_operational = 2.3,
			empty_reload_operational = 3.3,
			reload_interrupt = 0.68,
			empty_reload_interrupt = 0.68,
			unequip = 0.55,
			equip = 0.65
		}
		self.sterling.reload_speed_multiplier = 1.1 --2.6/3.5s

	--Heavy SMG (Primary)
		--Jackal
		self.schakal.use_data.selection_index = 2
		self.schakal.fire_rate_multiplier = 0.92 --600 rpm
		self.schakal.CLIP_AMMO_MAX = 25
		self.schakal.BURST_FIRE = 3
		self.schakal.ADAPTIVE_BURST_SIZE = false
		self.schakal.kick = self.stat_info.kick_tables.even_recoil
		self.schakal.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.schakal.supported = true
		self.schakal.stats = {
			damage = 30,
			spread = 14,
			recoil = 15,
			concealment = 16,
			value = 1
		}
		self.schakal.timers = {
			reload_not_empty = 2.9,
			reload_empty = 4,
			reload_operational = 2.36,
			empty_reload_operational = 3.6,
			reload_interrupt = 0.62,
			empty_reload_interrupt = 0.62,
			unequip = 0.6,
			equip = 0.5
		} 

		--Kross Vertex
		self.polymer.use_data.selection_index = 2
		self.polymer.BURST_FIRE = 3
		self.polymer.ADAPTIVE_BURST_SIZE = false
		self.polymer.kick = self.stat_info.kick_tables.even_recoil
		self.polymer.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.polymer.supported = true
		self.polymer.stats = {
			damage = 30,
			spread = 8,
			recoil = 15,
			concealment = 16,
			value = 1
		}
		self.polymer.timers = {
			reload_not_empty = 2.6,
			reload_empty = 3.1,
			reload_operational = 2,
			empty_reload_operational = 2.5,
			reload_interrupt = 0.58,
			empty_reload_interrupt = 0.58,
			unequip = 0.6,
			equip = 0.5
		}

	--Heavy SMG (Secondary)
		--Swedish K
		self.m45.CLIP_AMMO_MAX = 30
		self.m45.kick = self.stat_info.kick_tables.left_recoil
		self.m45.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.m45.supported = true
		self.m45.stats = {
			damage = 30,
			spread = 14,
			recoil = 15,
			concealment = 15,
			value = 5
		}
		self.m45.timers = {
			reload_not_empty = 3.4,
			reload_empty = 4.5,
			reload_operational = 2.6,
			empty_reload_operational = 3.7,
			reload_interrupt = 0.56,
			empty_reload_interrupt = 0.56,
			unequip = 0.5,
			equip = 0.6
		}
		self.m45.reload_speed_multiplier = 1.125 --3/4s

		--Micro Uzi
		self.baka.kick = self.stat_info.kick_tables.left_recoil
		self.baka.kick_pattern = self.stat_info.kick_patterns.random
		self.baka.supported = true
		self.baka.stats = {
			damage = 30,
			spread = 6,
			recoil = 13,
			concealment = 19,
			value = 1
		}
		self.baka.timers = {
			reload_not_empty = 2.4,
			reload_empty = 3.1,
			reload_operational = 1.85,
			empty_reload_operational = 2.55,
			reload_interrupt = 0.66,
			empty_reload_interrupt = 0.66,
			unequip = 0.7,
			equip = 0.5
		}

		--Uzi
		self.uzi.CLIP_AMMO_MAX = 22
		self.uzi.fire_rate_multiplier = 0.86 --600 rpm
		self.uzi.kick = self.stat_info.kick_tables.even_recoil
		self.uzi.kick_pattern = self.stat_info.kick_patterns.random
		self.uzi.supported = true
		self.uzi.stats = {
			damage = 30,
			spread = 14,
			recoil = 17,
			concealment = 17,
			value = 7
		}
		self.uzi.timers = {
			reload_not_empty = 3.1,
			reload_empty = 4.1,
			reload_operational = 2.4,
			empty_reload_operational = 3.4,
			reload_interrupt = 0.57,
			empty_reload_interrupt = 0.57,
			unequip = 0.55,
			equip = 0.6
		}

	--Light Pistol (Primary)
		--Bernetti Auto
		self.beer.use_data.selection_index = 2
		self.beer.fire_mode_data.fire_rate = 0.11009174311
		self.beer.BURST_FIRE = 3
		self.beer.ADAPTIVE_BURST_SIZE = false
		self.beer.BURST_FIRE_RATE_MULTIPLIER = 2.01835 --1100 rpm
		self.beer.single = {fire_rate = 0.11009174311}
		self.beer.auto = nil
		self.beer.FIRE_MODE = "burst"
		self.beer.CAN_TOGGLE_FIREMODE = false
		self.beer.kick = self.stat_info.kick_tables.even_recoil
		self.beer.kick_pattern = self.stat_info.kick_patterns.jumpy_2
		self.beer.supported = true
		self.beer.stats = {
			damage = 20,
			spread = 15,
			recoil = 15,
			concealment = 18,
			value = 1
		}
		self.beer.timers = {
			reload_not_empty = 2.0,
			reload_empty = 2.4,
			reload_operational = 1.45,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.43,
			empty_reload_interrupt = 0.43,
			unequip = 0.5,
			equip = 0.35
		}

	--Light Pistol (Secondary)
		--Chimano 88
		self.glock_17.fire_mode_data.fire_rate = 0.11009174311
		self.glock_17.single.fire_rate = 0.11009174311
		self.glock_17.kick = self.stat_info.kick_tables.even_recoil
		self.glock_17.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.glock_17.supported = true
		self.glock_17.stats = {
			damage = 20,
			spread = 18,
			recoil = 18,
			concealment = 20,
			value = 1
		}
		self.glock_17.timers = {
			reload_not_empty = 2.0,
			reload_empty = 2.4,
			reload_operational = 1.45,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.5,
			equip = 0.35
		}

		--Bernetti 9
		self.b92fs.fire_mode_data.fire_rate = 0.11009174311
		self.b92fs.single.fire_rate = 0.11009174311
		self.b92fs.CLIP_AMMO_MAX = 15
		self.b92fs.kick = self.stat_info.kick_tables.even_recoil
		self.b92fs.kick_pattern = self.stat_info.jumpy_2
		self.b92fs.supported = true
		self.b92fs.stats = {
			damage = 20,
			spread = 19,
			recoil = 19,
			concealment = 19,
			value = 1
		}
		self.b92fs.timers = {
			reload_not_empty = 2.0,
			reload_empty = 2.4,
			reload_operational = 1.45,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.5,
			equip = 0.35
		}

		--5/7 AP
		self.lemming.desc_id = "bm_light_ap_weapon_sc_desc"
		self.lemming.has_description = true
		self.lemming.CLIP_AMMO_MAX = 20
		self.lemming.fire_mode_data.fire_rate = 0.125
		self.lemming.single.fire_rate = 0.125
		self.lemming.kick = self.stat_info.kick_tables.even_recoil
		self.lemming.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.lemming.can_shoot_through_enemy = false
		self.lemming.can_shoot_through_shield = false
		self.lemming.can_shoot_through_wall = false
		self.lemming.armor_piercing_chance = 1
		self.lemming.supported = true
		self.lemming.stats = {
			damage = 20,
			spread = 18,
			recoil = 19,
			concealment = 19,
			value = 1
		}
		self.lemming.timers = {
			reload_not_empty = 1.9,
			reload_empty = 2.5,
			reload_operational = 1.5,
			empty_reload_operational = 2.15,
			reload_interrupt = 0.24,
			empty_reload_interrupt = 0.24,
			unequip = 0.5,
			equip = 0.35
		}
		self.lemming.swap_speed_multiplier = 0.9

		--Chimano Compact
		self.g26.kick = self.stat_info.kick_tables.even_recoil
		self.g26.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.g26.fire_mode_data.fire_rate = 0.11009174311
		self.g26.single.fire_rate = 0.11009174311
		self.g26.supported = true
		self.g26.stats = {
			damage = 20,
			spread = 19,
			recoil = 20,
			concealment = 21,
			value = 1
		}
		self.g26.timers = {
			reload_not_empty = 2.0,
			reload_empty = 2.4,
			reload_operational = 1.45,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.5,
			equip = 0.35
		}
		self.g26.reload_speed_multiplier = 1.15 --1.7/2.1s
		self.g26.swap_speed_multiplier = 1.25

		--Stryk 18c
		self.glock_18c.desc_id = "bm_menu_sc_glock18c_desc"
		self.glock_18c.fire_mode_data.fire_rate = 0.11009174311
		self.glock_18c.auto.fire_rate = 0.11009174311
		self.glock_18c.fire_rate_multiplier = 2.01835 --1100 rpm
		self.glock_18c.CLIP_AMMO_MAX = 17
		self.glock_18c.kick = self.stat_info.kick_tables.left_recoil
		self.glock_18c.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.glock_18c.supported = true
		self.glock_18c.stats = {
			damage = 20,
			spread = 17,
			recoil = 12,
			concealment = 20,
			value = 1
		}
		self.glock_18c.timers = {
			reload_not_empty = 2.0,
			reload_empty = 2.4,
			reload_operational = 1.45,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.5,
			equip = 0.35
		}

	--Medium Pistol (Primary)
		--Czech 92
		self.czech.use_data.selection_index = 2
		self.czech.fire_mode_data.fire_rate = 0.06
		self.czech.kick = self.stat_info.kick_tables.left_recoil
		self.czech.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.czech.supported = true
		self.czech.stats = {
			damage = 20,
			spread = 15,
			recoil = 11,
			concealment = 19,
			value = 1
		}
		self.czech.timers = {
			reload_not_empty = 1.95,
			reload_empty = 2.4,
			reload_operational = 1.45,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.37,
			empty_reload_interrupt = 0.43,
			unequip = 0.5,
			equip = 0.35
		}

		--TODO: Kang Arms Model 54

	--Medium Pistol (Secondary)
		--Gruber Kurz
		self.ppk.CLIP_AMMO_MAX = 9
		self.ppk.kick = self.stat_info.kick_tables.right_recoil
		self.ppk.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.ppk.supported = true
		self.ppk.stats = {
			damage = 24,
			spread = 20,
			recoil = 17,
			concealment = 21,
			value = 1
		}
		self.ppk.timers = {
			reload_not_empty = 1.9,
			reload_empty = 2.5,
			reload_operational = 1.5,
			empty_reload_operational = 2.15,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.5,
			equip = 0.35
		}
		self.ppk.reload_speed_multiplier = 1.2 --1.6/2.1s
		self.ppk.swap_speed_multiplier = 1.25

		--Contractor Pistol
		self.packrat.kick = self.stat_info.kick_tables.even_recoil
		self.packrat.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.packrat.fire_rate_multiplier = 1.135417 --545 rpm
		self.packrat.supported = true
		self.packrat.stats = {
			damage = 24,
			spread = 17,
			recoil = 18,
			concealment = 19,
			value = 1
		}
		self.packrat.timers = {
			reload_not_empty = 2,
			reload_empty = 2.7,
			reload_operational = 1.5,
			empty_reload_operational = 2.3,
			reload_interrupt = 0.31,
			empty_reload_interrupt = 0.31,
			unequip = 0.5,
			equip = 0.35
		}

		--White Streak
		self.pl14.fire_mode_data.fire_rate = 0.11009174311
		self.pl14.single.fire_rate = 0.11009174311
		self.pl14.CLIP_AMMO_MAX = 14
		self.pl14.kick = self.stat_info.kick_tables.left_recoil
		self.pl14.kick_pattern = self.stat_info.kick_patterns.jumpy_2
		self.pl14.supported = true
		self.pl14.stats = {
			damage = 24,
			spread = 18,
			recoil = 17,
			concealment = 19,
			value = 1
		}
		self.pl14.timers = {
			reload_not_empty = 1.9,
			reload_empty = 2.5,
			reload_operational = 1.5,
			empty_reload_operational = 2.15,
			reload_interrupt = 0.24,
			empty_reload_interrupt = 0.24,
			unequip = 0.5,
			equip = 0.35
		}

		--M13
		self.legacy.CLIP_AMMO_MAX = 13
		self.legacy.kick = self.stat_info.kick_tables.left_recoil
		self.legacy.kick_pattern = self.stat_info.kick_patterns.random
		self.legacy.supported = true
		self.legacy.stats = {
			damage = 24,
			spread = 19,
			recoil = 15,
			concealment = 21,
			value = 1
		}
		self.legacy.timers = {
			reload_not_empty = 2.0,
			reload_empty = 2.4,
			reload_operational = 1.45,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.5,
			equip = 0.35
		}

		--Holt 9mm
		self.holt.kick = self.stat_info.kick_tables.horizontal_recoil
		self.holt.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.holt.supported = true
		self.holt.stats = {
			damage = 24,
			spread = 16,
			recoil = 20,
			concealment = 19,
			value = 1
		}
		self.holt.timers = {
			reload_not_empty = 2.0,
			reload_empty = 2.4,
			reload_operational = 1.45,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.5,
			equip = 0.35
		}

		--Igor
		self.stech.kick = self.stat_info.kick_tables.moderate_kick
		self.stech.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.stech.CLIP_AMMO_MAX = 20
		self.stech.supported = true
		self.stech.stats = {
			damage = 24,
			spread = 14,
			recoil = 14,
			concealment = 17,
			value = 1
		}
		self.stech.timers = {
			reload_not_empty = 2.5,
			reload_empty = 3.3,
			reload_operational = 1.9,
			empty_reload_operational = 2.6,
			reload_interrupt = 0.46,
			empty_reload_interrupt = 0.43,
			unequip = 0.5,
			equip = 0.35
		}

	--Heavy Pistol (Primary)
		--Cavity 9mm
		self.sub2000.categories = {"pistol"}
		self.sub2000.CLIP_AMMO_MAX = 30
		self.sub2000.fire_rate_multiplier = 0.77195467 --545 rpm
		self.sub2000.kick = self.stat_info.kick_tables.horizontal_recoil
		self.sub2000.kick_pattern = self.stat_info.kick_patterns.random
		self.sub2000.supported = true
		self.sub2000.stats = {
			damage = 30,
			spread = 15,
			recoil = 11,
			concealment = 19,
			value = 1
		}
		self.sub2000.timers = {
			reload_not_empty = 2.8,
			reload_empty = 3.8,
			reload_operational = 2.3,
			empty_reload_operational = 3.3,
			reload_interrupt = 0.44,
			empty_reload_interrupt = 0.92,
			unequip = 0.9,
			equip = 0.9
		}
		self.sub2000.reload_speed_multiplier = 1.26 --2.2/3s
		self.sub2000.swap_speed_multiplier = 1.15

		--Broomstick--
		self.c96.use_data.selection_index = 2
		self.c96.sounds.fire_single = "c96_fire"
		self.c96.sounds.fire_auto = "g18c_fire"
		self.c96.sounds.stop_fire = "g18c_stop"
		self.c96.has_description = true
		self.c96.desc_id = "bm_c96_sc_desc"
		self.c96.FIRE_MODE = "auto"
		self.c96.CAN_TOGGLE_FIREMODE = true
		self.c96.fire_mode_data.fire_rate = 0.06 --1000 rpm
		self.c96.single.fire_rate = 0.06 --1000 rpm
		self.c96.kick = self.stat_info.kick_tables.even_recoil
		self.c96.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.c96.uses_clip = true
		self.c96.clip_capacity = 10
		self.c96.supported = true
		self.c96.stats = {
			damage = 30,
			spread = 17,
			recoil = 17,
			concealment = 19,
			value = 1
		}
		self.c96.timers = {
			reload_not_empty = 4.4,
			reload_empty = 4.8,
			reload_operational = 3.7,
			empty_reload_operational = 4.1,
			reload_interrupt = 0.125,
			empty_reload_interrupt = 0.125,
			unequip = 0.5,
			equip = 0.35
		}
		self.c96.reload_speed_multiplier = 1.15 --3.8s/4.2s

	--Heavy Pistols (Secondary)
		--Signature .40
		self.p226.kick = self.stat_info.kick_tables.left_recoil
		self.p226.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.p226.CLIP_AMMO_MAX = 13
		self.p226.supported = true
		self.p226.stats = {
			damage = 30,
			spread = 15,
			recoil = 17,
			concealment = 19,
			value = 4
		}
		self.p226.timers = {
			reload_not_empty = 2.0,
			reload_empty = 2.4,
			reload_operational = 1.45,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.5,
			equip = 0.35
		}

		--Baby Deagle
		self.sparrow.kick = self.stat_info.kick_tables.even_recoil
		self.sparrow.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.sparrow.fire_rate_multiplier = 1.2 --480 rpm
		self.sparrow.supported = true
		self.sparrow.stats = {
			damage = 30,
			spread = 17,
			recoil = 15,
			concealment = 19,
			value = 1
		}
		self.sparrow.timers = {
			reload_not_empty = 1.9,
			reload_empty = 2.5,
			reload_operational = 1.5,
			empty_reload_operational = 2.15,
			reload_interrupt = 0.44,
			empty_reload_interrupt = 0.44,
			unequip = 0.5,
			equip = 0.35
		}
		self.sparrow.reload_speed_multiplier = 1.05 --1.8/2.4s

		--Chimano Custom
		self.g22c.kick = self.stat_info.kick_tables.even_recoil
		self.g22c.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.g22c.CLIP_AMMO_MAX = 15
		self.g22c.supported = true
		self.g22c.stats = {
			damage = 30,
			spread = 18,
			recoil = 12,
			concealment = 20,
			value = 1
		}
		self.g22c.timers = {
			reload_not_empty = 2.0,
			reload_empty = 2.4,
			reload_operational = 1.45,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.5,
			equip = 0.35
		}

		--Crosskill Guard
		self.shrew.CLIP_AMMO_MAX = 8
		self.shrew.kick = self.stat_info.kick_tables.moderate_kick
		self.shrew.kick_pattern = self.stat_info.kick_patterns.jumpy_2
		self.shrew.supported = true
		self.shrew.stats = {
			damage = 30,
			spread = 19,
			recoil = 14,
			concealment = 21,
			value = 1
		}
		self.shrew.timers = {
			reload_not_empty = 2.0,
			reload_empty = 2.4,
			reload_operational = 1.45,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.5,
			equip = 0.35
		}
		self.shrew.reload_speed_multiplier = 1.05 --1.9/2.3s

	--Light HandCannon (Secondary)
		--Interceptor .45
		self.usp.CLIP_AMMO_MAX = 12
		self.usp.kick = self.stat_info.kick_tables.right_recoil
		self.usp.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.usp.supported = true
		self.usp.stats = {
			damage = 45,
			spread = 16,
			recoil = 10,
			concealment = 19,
			value = 4
		}
		self.usp.timers = {
			reload_not_empty = 2.0,
			reload_empty = 2.4,
			reload_operational = 1.45,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.5,
			equip = 0.35
		}
		self.usp.swap_speed_multiplier = 0.9
		self.usp.reload_speed_multiplier = 0.9 --2.4/2.8s

		--Crosskill
		self.colt_1911.fire_mode_data.fire_rate = 0.125
		self.colt_1911.single.fire_rate = 0.125
		self.colt_1911.CLIP_AMMO_MAX = 8
		self.colt_1911.kick = self.stat_info.kick_tables.moderate_left_kick
		self.colt_1911.kick_pattern = self.stat_info.kick_patterns.random
		self.colt_1911.supported = true
		self.colt_1911.stats = {
			damage = 45,
			spread = 18,
			recoil = 10,
			concealment = 19,
			value = 1
		}
		self.colt_1911.timers = {
			reload_not_empty = 2.0,
			reload_empty = 2.4,
			reload_operational = 1.45,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.72,
			empty_reload_interrupt = 0.72,
			unequip = 0.5,
			equip = 0.35
		}

		--Crosskill Chunky
		self.m1911.tactical_reload = 1
		self.m1911.fire_mode_data.fire_rate = 0.125
		self.m1911.single.fire_rate = 0.125
		self.m1911.CLIP_AMMO_MAX = 8
		self.m1911.kick = self.stat_info.kick_tables.even_recoil
		self.m1911.kick_pattern = self.stat_info.kick_patterns.random
		self.m1911.supported = true
		self.m1911.stats = {
			damage = 45,
			spread = 17,
			recoil = 11,
			concealment = 19,
			value = 1
		}
		self.m1911.timers = {
			reload_not_empty = 2.0,
			reload_empty = 2.4,
			reload_operational = 1.45,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.4,
			empty_reload_interrupt = 0.4,
			unequip = 0.5,
			equip = 0.35
		}
		self.m1911.swap_speed_multiplier = 0.8
		self.m1911.reload_speed_multiplier = 1.05 --1.9/2.3s		

		--Parabellum
		self.breech.fire_mode_data.fire_rate = 0.15
		self.breech.single.fire_rate = 0.15
		self.breech.kick = self.stat_info.kick_tables.moderate_kick
		self.breech.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.breech.supported = true
		self.breech.stats = {
			damage = 45,
			spread = 16,
			recoil = 11,
			concealment = 21,
			value = 1
		}
		self.breech.timers = {
			reload_not_empty = 1.8,
			reload_empty = 2.4,
			reload_operational = 1.55,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.23,
			empty_reload_interrupt = 0.23,
			unequip = 0.5,
			equip = 0.35
		}

		--Leo
		self.hs2000.CLIP_AMMO_MAX = 13
		self.hs2000.FIRE_MODE = "single"
		self.hs2000.kick = self.stat_info.kick_tables.left_recoil
		self.hs2000.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.hs2000.supported = true
		self.hs2000.stats = {
			damage = 45,
			spread = 12,
			recoil = 13,
			concealment = 20,
			value = 4
		}
		self.hs2000.timers = {
			reload_not_empty = 2.0,
			reload_empty = 2.4,
			reload_operational = 1.45,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.5,
			equip = 0.35
		}
		self.hs2000.swap_speed_multiplier = 0.8
		self.hs2000.reload_speed_multiplier = 0.85 --2.4/2.8s

	--Medium Handcannons (Primary)
		--Deagle
		self.deagle.use_data.selection_index = 2
		self.deagle.fire_rate_multiplier = 1.2 --480 rpm
		self.deagle.kick = self.stat_info.kick_tables.vertical_kick
		self.deagle.kick_pattern = self.stat_info.kick_patterns.random
		self.deagle.CLIP_AMMO_MAX = 7
		self.deagle.supported = true
		self.deagle.stats = {
			damage = 60,
			spread = 20,
			recoil = 5,
			concealment = 19,
			value = 1
		}
		self.deagle.timers = {
			reload_not_empty = 2.5,
			reload_empty = 3.6,
			reload_operational = 1.85,
			empty_reload_operational = 3.1,
			reload_interrupt = 0.6,
			empty_reload_interrupt = 0.6,
			unequip = 0.5,
			equip = 0.35
		}
		self.deagle.reload_speed_multiplier = 1.15 --2.2/3.1s

	--Medium Handcannons (Secondary)
		--Bronco
		self.new_raging_bull.fire_mode_data.fire_rate = 0.19047619047
		self.new_raging_bull.single.fire_rate = 0.19047619047
		self.new_raging_bull.kick = self.stat_info.kick_tables.moderate_right_kick
		self.new_raging_bull.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.new_raging_bull.supported = true
		self.new_raging_bull.stats = {
			damage = 60,
			spread = 17,
			recoil = 8,
			concealment = 20,
			value = 1
		}
		self.new_raging_bull.timers = {
			reload_not_empty = 2.5,
			reload_empty = 2.5,
			reload_operational = 2.1,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.39,
			empty_reload_interrupt = 0.39,
			unequip = 0.5,
			equip = 0.45
		}

		--Castigo
		self.chinchilla.fire_mode_data.fire_rate = 0.19047619
		self.chinchilla.single.fire_rate = 0.19047619
		self.chinchilla.kick = self.stat_info.kick_tables.moderate_right_kick
		self.chinchilla.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.chinchilla.supported = true
		self.chinchilla.stats = {
			damage = 60,
			spread = 19,
			recoil = 10,
			concealment = 19,
			value = 1
		}
		self.chinchilla.timers = {
			reload_not_empty = 3.4,
			reload_empty = 3.4,
			reload_operational = 2.97,
			empty_reload_operational = 2.97,
			reload_interrupt = 0.24,
			empty_reload_interrupt = 0.24,
			unequip = 0.5,
			equip = 0.45
		}

		--Frenchman Model 87
		self.model3.fire_rate_multiplier = 0.6 --240 rpm
		self.model3.kick = self.stat_info.kick_tables.moderate_left_kick
		self.model3.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.model3.supported = true
		self.model3.stats = {
			damage = 60,
			spread = 21,
			recoil = 9,
			concealment = 18,
			value = 1
		}
		self.model3.timers = {
			reload_not_empty = 2.65,
			reload_empty = 2.65,
			empty_reload_operational = 2.25,
			reload_operational = 2.25,
			reload_interrupt = 0.36,
			empty_reload_interrupt = 0.36,
			unequip = 0.5,
			equip = 0.45
		}

		--Matever .357
		self.mateba.fire_mode_data.fire_rate = 0.15789474
		self.mateba.single.fire_rate = 0.15789474
		self.mateba.kick = self.stat_info.kick_tables.moderate_right_kick
		self.mateba.kick_pattern = self.stat_info.kick_patterns.jumpy_2
		self.mateba.supported = true
		self.mateba.stats = {
			damage = 60,
			spread = 15,
			recoil = 12,
			concealment = 21,
			value = 1
		}
		self.mateba.timers = {
			reload_not_empty = 4.1,
			reload_empty = 4.1,
			reload_operational = 3.6,
			empty_reload_operational = 3.6,
			reload_interrupt = 0.47,
			empty_reload_interrupt = 0.47,
			unequip = 0.5,
			equip = 0.45
		}

	--Heavy Handcannon (Primary)
		--Phoenix .500 Revolver
		self.shatters_fury.fire_mode_data.fire_rate = 0.25
		self.shatters_fury.single.fire_rate = 0.25
		self.shatters_fury.CLIP_AMMO_MAX = 5
		self.shatters_fury.kick = self.stat_info.kick_tables.left_kick
		self.shatters_fury.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.shatters_fury.supported = true
		self.shatters_fury.has_description = true
		self.shatters_fury.desc_id = "bm_ap_weapon_sc_desc"
		self.shatters_fury.can_shoot_through_enemy = true
		self.shatters_fury.can_shoot_through_shield = true
		self.shatters_fury.can_shoot_through_wall = true
		self.shatters_fury.armor_piercing_chance = 1
		self.shatters_fury.stats = {
			damage = 90,
			spread = 17,
			recoil = 5,
			concealment = 18,
			value = 1
		}
		self.shatters_fury.timers = {
			reload_not_empty = 2.5,
			reload_empty = 2.5,
			reload_operational = 2.1,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.36,
			empty_reload_interrupt = 0.36,
			unequip = 0.5,
			equip = 0.5
		}
		self.shatters_fury.swap_speed_multiplier = 0.7

		--RUS-12 Angry Tiger
		self.rsh12.use_data.selection_index = 2
		self.rsh12.fire_rate_multiplier = 0.7
		self.rsh12.CLIP_AMMO_MAX = 5
		self.rsh12.kick = self.stat_info.kick_tables.right_kick
		self.rsh12.kick_pattern = self.stat_info.kick_patterns.random
		self.rsh12.supported = true
		self.rsh12.can_shoot_through_enemy = true
		self.rsh12.can_shoot_through_shield = true
		self.rsh12.can_shoot_through_wall = true
		self.rsh12.armor_piercing_chance = 1
		self.rsh12.swap_speed_multiplier = 0.6
		self.rsh12.stats = {
			damage = 90,
			spread = 15,
			recoil = 7,
			concealment = 17,
			value = 1
		}
		self.rsh12.timers = {
			reload_not_empty = 2.7,
			reload_empty = 2.7,
			reload_operational = 2.2,
			empty_reload_operational = 2.2,
			reload_interrupt = 0.31,
			empty_reload_interrupt = 0.31,
			unequip = 0.5,
			equip = 0.45
		}
		self.rsh12.swap_speed_multiplier = 0.75

	--Heavy Handcannon (Secondary)
		--Peacemaker
		self.peacemaker.kick = self.stat_info.kick_tables.moderate_left_kick
		self.peacemaker.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.peacemaker.has_description = true
		self.peacemaker.can_shoot_through_enemy = true
		self.peacemaker.can_shoot_through_shield = true
		self.peacemaker.can_shoot_through_wall = true
		self.peacemaker.armor_piercing_chance = 1
		self.peacemaker.desc_id = "bm_ap_weapon_sc_desc"
		self.peacemaker.supported = true
		self.peacemaker.fire_rate_multiplier = 0.6 --240 rpm
		self.peacemaker.stats = {
			damage = 90,
			spread = 19,
			recoil = 8,
			concealment = 19,
			value = 1
		}
		self.peacemaker.timers = {
			shotgun_reload_enter = 1.4333333333333333,
			shotgun_reload_exit_empty = 0.3333333333333333,
			shotgun_reload_exit_not_empty = 0.3333333333333333,
			shotgun_reload_shell = 1,
			shotgun_reload_first_shell_offset = 0.5,
			unequip = 0.65,
			equip = 0.65
		}
		self.peacemaker.swap_speed_multiplier = 0.65

	--Reinfeld 880
	self.r870.desc_id = "bm_menu_sc_r870_desc"
	self.r870.muzzleflash = "effects/particles/shotgun/shotgun_gen"
	self.r870.rays = 9
	self.r870.CLIP_AMMO_MAX = 8
	self.r870.kick = self.stat_info.kick_tables.vertical_kick
	self.r870.single.fire_rate = 0.5
	self.r870.fire_mode_data.fire_rate = 0.5
	self.r870.AMMO_MAX = 60
	self.r870.supported = false
	self.r870.stats = {
		damage = 60,
		spread = 9,
		recoil = 17,
		spread_moving = 6,
		zoom = 1,
		concealment = 22,
		suppression = 5,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.r870.stats_modifiers = nil

	--Izhma 12G
	self.saiga.rays = 9
	self.saiga.muzzleflash = "effects/particles/shotgun/shotgun_gen"
	self.saiga.CLIP_AMMO_MAX = 6
	self.saiga.AMMO_MAX = 120
	self.saiga.fire_mode_data.fire_rate = 0.1
	self.saiga.auto.fire_rate = 0.1
	self.saiga.shake.fire_multiplier = 1
	self.saiga.shake.fire_steelsight_multiplier = -1
	self.saiga.kick = self.stat_info.kick_tables.right_kick
	self.saiga.supported = false
	self.saiga.stats = {
		damage = 30,
		spread = 7,
		recoil = 19,
		spread_moving = 7,
		zoom = 1,
		concealment = 24,
		suppression = 7,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.saiga.stats_modifiers = nil
	self.saiga.reload_speed_multiplier = 1.25

	--Loco 12g
	self.serbu.rays = 9
	self.serbu.muzzleflash = "effects/particles/shotgun/shotgun_gen"
	self.serbu.CLIP_AMMO_MAX = 4
	self.serbu.AMMO_MAX = 30
	self.serbu.fire_mode_data.fire_rate = 0.5
	self.serbu.single.fire_rate = 0.5
	self.serbu.kick = self.stat_info.kick_tables.moderate_kick
	self.serbu.supported = false
	self.serbu.stats = {
		damage = 60,
		spread = 8,
		recoil = 17,
		spread_moving = 6,
		zoom = 1,
		concealment = 22,
		suppression = 5,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.serbu.stats_modifiers = nil

	--Mosconi 12G
	self.huntsman.rays = 9
	self.huntsman.muzzleflash = "effects/particles/shotgun/muzzleflash"
	self.huntsman.AMMO_MAX = 40
	self.huntsman.sounds.fire_single = "huntsman_fire"
	self.huntsman.sounds.fire_auto = "huntsman_fire"
	self.huntsman.BURST_FIRE = 3
	self.huntsman.BURST_FIRE_RATE_MULTIPLIER = 120
	self.huntsman.ADAPTIVE_BURST_SIZE = false
	self.huntsman.CAN_TOGGLE_FIREMODE = false
	self.huntsman.DELAYED_BURST_RECOIL = true
	self.huntsman.fire_mode_data = {}
	self.huntsman.fire_mode_data.fire_rate = 0.06
	self.huntsman.single = {}
	self.huntsman.single.fire_rate = 0.06
	self.huntsman.auto = {}
	self.huntsman.auto.fire_rate = 0.06
	self.huntsman.kick = self.stat_info.kick_tables.vertical_kick
	self.huntsman.supported = false
	self.huntsman.stats = {
		damage = 90,
		spread = 12,
		recoil = 13,
		spread_moving = 6,
		zoom = 1,
		concealment = 21,
		suppression = 3,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.huntsman.stats_modifiers = nil
	self.huntsman.timers.reload_not_empty = 2.3
	self.huntsman.timers.reload_empty = 2.3
	self.huntsman.reload_speed_multiplier = 1.2

	--OVE9000 Saw
	self.saw.has_description = true
	self.saw.desc_id = "bm_ap_saw_sc_desc"
	self.saw.CLIP_AMMO_MAX = 20
	self.saw.AMMO_MAX = 40
	self.saw.kick = self.stat_info.kick_tables.none
	self.saw.supported = false
	self.saw.stats = {
		alert_size = 2,
		suppression = 7,
		zoom = 1,
		spread = 1,
		recoil = 26,
		spread_moving = 7,
		damage = 90,
		concealment = 20,
		value = 1,
		extra_ammo = 101,
		total_ammo_mod = 100,
		reload = 20
	}
	self.saw.stats_modifiers = nil
	self.saw_secondary.kick = self.stat_info.kick_tables.none
	self.saw_secondary.has_description = true
	self.saw_secondary.desc_id = "bm_ap_saw_sc_desc"
	self.saw_secondary.CLIP_AMMO_MAX = 20
	self.saw_secondary.AMMO_MAX = 20
	self.saw_secondary.supported = false
	self.saw_secondary.stats = {
		alert_size = 2,
		suppression = 7,
		zoom = 1,
		spread = 1,
		recoil = 26,
		spread_moving = 7,
		damage = 90,
		concealment = 20,
		value = 1,
		extra_ammo = 101,
		total_ammo_mod = 100,
		reload = 20
	}
	self.saw_secondary.stats_modifiers = nil

	--Judge
	self.judge.fire_mode_data = {}
	self.judge.fire_mode_data.fire_rate = 0.272727
	self.judge.single = {}
	self.judge.single.fire_rate = 0.272727
	self.judge.rays = 9
	self.judge.muzzleflash = "effects/particles/shotgun/muzzleflash"
	self.judge.AMMO_MAX = 20
	self.judge.supported = false
	self.judge.stats = {
		damage = 90,
		spread = 5,
		recoil = 10,
		spread_moving = 5,
		zoom = 1,
		concealment = 25,
		suppression = 4,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.judge.stats_modifiers = nil
	self.judge.timers.reload_not_empty = 2.4
	self.judge.timers.reload_empty = 2.4
	self.judge.stats_modifiers = {damage = 1}
	self.judge.kick = self.stat_info.kick_tables.left_kick
	self.judge.reload_speed_multiplier = 0.85
	self.judge.timers.reload_interrupt = 0.12
	self.judge.timers.empty_reload_interrupt = 0.12

	--M1014
	self.benelli.AMMO_MAX = 80
	self.benelli.rays = 9
	self.benelli.muzzleflash = "effects/particles/shotgun/shotgun_gen"
	self.benelli.fire_mode_data.fire_rate = 0.13953488372
	self.benelli.CAN_TOGGLE_FIREMODE = false
	self.benelli.single = {}
	self.benelli.single.fire_rate = 0.13953488372
	self.benelli.kick = self.stat_info.kick_tables.moderate_kick
	self.benelli.supported = false
	self.benelli.stats = {
		damage = 45,
		spread = 8,
		recoil = 18,
		spread_moving = 7,
		zoom = 1,
		concealment = 22,
		suppression = 6,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.benelli.stats_modifiers = nil

	--Street Sweeper
	self.striker.rays = 9
	self.striker.muzzleflash = "effects/particles/shotgun/shotgun_gen"
	self.striker.AMMO_MAX = 40
	self.striker.fire_mode_data.fire_rate = 0.13953488372
	self.striker.CAN_TOGGLE_FIREMODE = false
	self.striker.single = {}
	self.striker.single.fire_rate = 0.13953488372
	self.striker.CLIP_AMMO_MAX = 12
	self.striker.kick = self.stat_info.kick_tables.right_kick
	self.striker.supported = false
	self.striker.stats = {
		damage = 45,
		spread = 7,
		recoil = 18,
		spread_moving = 7,
		zoom = 1,
		concealment = 20,
		suppression = 6,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.striker.stats_modifiers = nil
	self.striker.timers.shotgun_reload_first_shell_offset = 0.4

	--Raven
	self.ksg.rays = 9
	self.ksg.muzzleflash = "effects/particles/shotgun/shotgun_gen"
	self.ksg.AMMO_MAX = 60
	self.ksg.CLIP_AMMO_MAX = 12
	self.ksg.single.fire_rate = 0.6
	self.ksg.fire_mode_data.fire_rate = 0.6
	self.ksg.kick = self.stat_info.kick_tables.vertical_kick
	self.ksg.supported = false
	self.ksg.stats = {
		damage = 60,
		spread = 8,
		recoil = 18,
		spread_moving = 7,
		zoom = 1,
		concealment = 23,
		suppression = 5,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.ksg.stats_modifiers = nil

	--GL40
	self.gre_m79.upgrade_blocks = {
		weapon = {
			"clip_ammo_increase"
		}
	}
	self.gre_m79.desc_id = "bm_40mm_weapon_sc_desc"
	self.gre_m79.has_description = true
	self.gre_m79.fire_mode_data.fire_rate = 1
	self.gre_m79.kick = self.stat_info.kick_tables.vertical_kick
	self.gre_m79.AMMO_MAX = 9
	self.gre_m79.supported = false
	self.gre_m79.stats = {
		damage = 80,
		spread = 21,
		recoil = 9,
		spread_moving = 6,
		zoom = 1,
		concealment = 25,
		suppression = 20,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.gre_m79.stats_modifiers = {damage = 10}

	--Akimbo Chimano Compact
	self.jowi.kick = self.stat_info.kick_tables.even_recoil
	self.jowi.AMMO_MAX = 180
	self.jowi.fire_mode_data.fire_rate = 0.08571428571
	self.jowi.single = {}
	self.jowi.single.fire_rate = 0.08571428571
	self.jowi.supported = false
	self.jowi.stats = {
		damage = 20,
		spread = 18,
		recoil = 15,
		spread_moving = 9,
		zoom = 1,
		concealment = 32,
		suppression = 9,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.jowi.stats_modifiers = nil

	--Akimbo Crosskill
	self.x_1911.CLIP_AMMO_MAX = 16
	self.x_1911.AMMO_MAX = 80
	self.x_1911.fire_mode_data.fire_rate = 0.08571428571
	self.x_1911.single = {}
	self.x_1911.single.fire_rate = 0.08571428571
	self.x_1911.kick = self.stat_info.kick_tables.even_recoil
	self.x_1911.supported = false
	self.x_1911.stats = {
		damage = 45,
		spread = 16,
		recoil = 9,
		spread_moving = 5,
		zoom = 1,
		concealment = 26,
		suppression = 6,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_1911.stats_modifiers = nil

	--Akimbo Bernetti 9
	self.x_b92fs.kick = self.stat_info.kick_tables.even_recoil
	self.x_b92fs.AMMO_MAX = 180
	self.x_b92fs.FIRE_MODE = "single"
	self.x_b92fs.fire_mode_data.fire_rate = 0.08571428571
	self.x_b92fs.single.fire_rate = 0.08571428571
	self.x_b92fs.supported = false
	self.x_b92fs.stats = {
		damage = 20,
		spread = 17,
		recoil = 14,
		spread_moving = 5,
		zoom = 1,
		concealment = 31,
		suppression = 9,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_b92fs.stats_modifiers = nil

	--Akimbo Deagle
	self.x_deagle.has_description = false
	self.x_deagle.desc_id = "bm_ap_weapon_sc_desc"
	self.x_deagle.CLIP_AMMO_MAX = 16
	self.x_deagle.AMMO_MAX = 60
	self.x_deagle.FIRE_MODE = "single"
	self.x_deagle.fire_mode_data = {}
	self.x_deagle.fire_mode_data.fire_rate = 0.1
	self.x_deagle.single = {}
	self.x_deagle.single.fire_rate = 0.1
	self.x_deagle.kick = self.stat_info.kick_tables.moderate_kick
	self.x_deagle.animations.has_steelsight_stance = true
	self.x_deagle.supported = false
	self.x_deagle.stats = {
		damage = 60,
		spread = 16,
		recoil = 8,
		spread_moving = 6,
		zoom = 1,
		concealment = 22,
		suppression = 5,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_deagle.stats_modifiers = nil

	--Predator 12g
	self.spas12.rays = 9
	self.spas12.muzzleflash = "effects/particles/shotgun/shotgun_gen"
	self.spas12.AMMO_MAX = 80
	self.spas12.CLIP_AMMO_MAX = 8
	self.spas12.fire_mode_data.fire_rate = 0.13953488372
	self.spas12.CAN_TOGGLE_FIREMODE = false
	self.spas12.single = {}
	self.spas12.single.fire_rate = 0.13953488372
	self.spas12.kick = self.stat_info.kick_tables.left_kick
	self.spas12.supported = false
	self.spas12.stats = {
		damage = 45,
		spread = 8,
		recoil = 18,
		spread_moving = 7,
		zoom = 1,
		concealment = 22,
		suppression = 6,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.spas12.stats_modifiers = nil
	self.spas12.stats_modifiers = {damage = 1}

	--Minigun
	self.m134.categories = {
		"minigun",
		"smg"
	}
	self.m134.has_description = false
	self.m134.CLIP_AMMO_MAX = 300
	self.m134.NR_CLIPS_MAX = 1
	self.m134.AMMO_MAX = 300
	self.m134.FIRE_MODE = "auto"
	self.m134.fire_mode_data = {}
	self.m134.fire_mode_data.fire_rate = 0.03
	self.m134.CAN_TOGGLE_FIREMODE = false
	self.m134.auto = {}
	self.m134.auto.fire_rate = 0.03
	self.m134.kick = self.stat_info.kick_tables.horizontal_recoil
	self.m134.supported = false
	self.m134.stats = {
		damage = 18,
		spread = 15,
		recoil = 21,
		spread_moving = 9,
		zoom = 1,
		concealment = 10,
		suppression = 9,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 9,
		reload = 20
	}
	self.m134.stats_modifiers = nil

	--HRL-7
	self.rpg7.upgrade_blocks = {
		weapon = {
			"clip_ammo_increase"
		}
	}
	self.rpg7.kick = self.stat_info.kick_tables.vertical_kick
	self.rpg7.has_description = true
	self.rpg7.desc_id = "bm_rocket_launcher_sc_desc"
	self.rpg7.fire_mode_data.fire_rate = 2
	self.rpg7.AMMO_MAX = 4
	self.rpg7.timers.reload_not_empty = 4.7
	self.rpg7.timers.reload_empty = 4.7
	self.rpg7.supported = false
	self.rpg7.stats = {
		damage = 400,
		spread = 16,
		recoil = 8,
		spread_moving = 6,
		zoom = 1,
		concealment = 12,
		suppression = 20,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.rpg7.stats_modifiers = {damage = 3}
	self.rpg7.swap_speed_multiplier = 1.25
	self.rpg7.reload_speed_multiplier = 1.1
	self.rpg7.turret_instakill = true

	--Joceline O/U 12G
	self.b682.rays = 9
	self.b682.muzzleflash = "effects/particles/shotgun/muzzleflash"
	self.b682.AMMO_MAX = 40
	self.b682.fire_mode_data = {}
	self.b682.CAN_TOGGLE_FIREMODE = false
	self.b682.fire_mode_data.fire_rate = 0.075
	self.b682.single = {}
	self.b682.single.fire_rate = 0.075
	self.b682.auto = {}
	self.b682.auto.fire_rate = 0.075
	self.b682.sounds.fire_single = "b682_fire"
	self.b682.sounds.fire_auto = "b682_fire"
	self.b682.kick = self.stat_info.kick_tables.vertical_kick
	self.b682.supported = false
	self.b682.stats = {
		damage = 90,
		spread = 13,
		recoil = 14,
		spread_moving = 6,
		zoom = 1,
		concealment = 20,
		suppression = 3,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.b682.stats_modifiers = nil
	self.b682.stats_modifiers = {damage = 1}
	self.b682.reload_speed_multiplier = 1.2

	--Akimbo Chimano Custom
	self.x_g22c.kick = self.stat_info.kick_tables.even_recoil
	self.x_g22c.CLIP_AMMO_MAX = 32
	self.x_g22c.AMMO_MAX = 150
	self.x_g22c.FIRE_MODE = "single"
	self.x_g22c.fire_mode_data = {}
	self.x_g22c.fire_mode_data.fire_rate = 0.08571428571
	self.x_g22c.single = {}
	self.x_g22c.single.fire_rate = 0.08571428571
	self.x_g22c.supported = false
	self.x_g22c.stats = {
		damage = 24,
		spread = 16,
		recoil = 13,
		spread_moving = 8,
		zoom = 1,
		concealment = 28,
		suppression = 8,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_g22c.stats_modifiers = nil

	--Akimbo Chimano .88
	self.x_g17.kick = self.stat_info.kick_tables.even_recoil
	self.x_g17.CLIP_AMMO_MAX = 36
	self.x_g17.AMMO_MAX = 180
	self.x_g17.FIRE_MODE = "single"
	self.x_g17.fire_mode_data.fire_rate = 0.08571428571
	self.x_g17.single.fire_rate = 0.08571428571
	self.x_g17.supported = false
	self.x_g17.stats = {
		damage = 20,
		spread = 16,
		recoil = 14,
		spread_moving = 7,
		zoom = 1,
		concealment = 30,
		suppression = 9,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_g17.stats_modifiers = nil

	--Akimbo Interceptor .45
	self.x_usp.kick = self.stat_info.kick_tables.right_recoil
	self.x_usp.CLIP_AMMO_MAX = 24
	self.x_usp.AMMO_MAX = 120
	self.x_usp.fire_mode_data.fire_rate = 0.08571428571
	self.x_usp.single = {}
	self.x_usp.single.fire_rate = 0.08571428571
	self.x_usp.supported = false
	self.x_usp.stats = {
		damage = 30,
		spread = 15,
		recoil = 12,
		spread_moving = 8,
		zoom = 1,
		concealment = 27,
		suppression = 7,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_usp.stats_modifiers = nil

	--Flamethrower Mk1
	self.flamethrower_mk2.categories = {
		"flamethrower",
		"shotgun"
	}
	self.flamethrower_mk2.recategorize = "wpn_special"
	self.flamethrower_mk2.has_description = true
	self.flamethrower_mk2.desc_id = "bm_ap_flamethrower_sc_desc"
	self.flamethrower_mk2.timers.reload_not_empty = 7.7
	self.flamethrower_mk2.timers.reload_empty = 7.7
	self.flamethrower_mk2.rays = 9
	self.flamethrower_mk2.CLIP_AMMO_MAX = 60
	self.flamethrower_mk2.AMMO_MAX = 120
	self.flamethrower_mk2.fire_mode_data.fire_rate = 0.1
	self.flamethrower_mk2.auto = {}
	self.flamethrower_mk2.auto.fire_rate = 0.1
	self.flamethrower_mk2.flame_max_range = 1600
	self.flamethrower_mk2.single_flame_effect_duration = 1
	self.flamethrower_mk2.armor_piercing_chance = 1
	self.flamethrower_mk2.can_shoot_through_enemy = false
	self.flamethrower_mk2.can_shoot_through_shield = false
	self.flamethrower_mk2.can_shoot_through_wall = false
	self.flamethrower_mk2.kick = self.stat_info.kick_tables.horizontal_recoil
	self.flamethrower_mk2.fire_dot_data = {
		dot_damage = 1.6,
		dot_trigger_chance = 60,
		dot_length = 3.1,
		dot_tick_period = 0.5
	}
	self.flamethrower_mk2.supported = false
	self.flamethrower_mk2.stats = {
		damage = 24,
		spread = 7,
		recoil = 23,
		spread_moving = 6,
		zoom = 1,
		concealment = 16,
		suppression = 7,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.flamethrower_mk2.stats_modifiers = nil

	--Piglet
	self.m32.upgrade_blocks = {
		weapon = {
			"clip_ammo_increase"
		}
	}
	self.m32.kick = self.stat_info.kick_tables.right_kick
	self.m32.fire_mode_data.fire_rate = 0.75
	self.m32.single.fire_rate = 0.75
	self.m32.AMMO_MAX = 9
	self.m32.supported = false
	self.m32.stats = {
		damage = 80,
		spread = 6,
		recoil = 8,
		spread_moving = 6,
		zoom = 1,
		concealment = 15,
		suppression = 20,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.m32.stats_modifiers = {damage = 10}
	self.m32.timers.shotgun_reload_first_shell_offset = 1
	self.m32.swap_speed_multiplier = 1.2
	self.m32.reload_speed_multiplier = 1.15

	--Steakout
	self.aa12.rays = 9
	self.aa12.AMMO_MAX = 120
	self.aa12.CLIP_AMMO_MAX = 10
	self.aa12.kick = self.stat_info.kick_tables.moderate_kick
	self.aa12.FIRE_MODE = "auto"
	self.aa12.CAN_TOGGLE_FIREMODE = false
	self.aa12.supported = false
	self.aa12.stats = {
		damage = 30,
		spread = 7,
		recoil = 24,
		spread_moving = 7,
		zoom = 1,
		concealment = 25,
		suppression = 7,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.aa12.stats_modifiers = nil
	self.aa12.reload_speed_multiplier = 1.15

	--Plainsrider bow.
	self.plainsrider.upgrade_blocks = {
		weapon = {
			"clip_ammo_increase"
		}
	}
	self.plainsrider.has_description = true
	self.plainsrider.desc_id = "bm_ap_2_weapon_sc_desc"
	self.plainsrider.kick = self.stat_info.kick_tables.none
	self.plainsrider.AMMO_MAX = 30
	self.plainsrider.charge_data.max_t = 0.5
	self.plainsrider.not_allowed_in_bleedout = false
	self.plainsrider.supported = false
	self.plainsrider.stats = {
		damage = 60,
		spread = 21,
		recoil = 26,
		spread_moving = 12,
		zoom = 1,
		concealment = 30,
		suppression = 20,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.plainsrider.stats_modifiers = {damage = 4}

	--Pistol Crossbow
	self.hunter.upgrade_blocks = {
		weapon = {
			"clip_ammo_increase"
		}
	}
	self.hunter.has_description = true
	self.hunter.desc_id = "bm_ap_3_weapon_sc_desc"
	self.hunter.AMMO_MAX = 15
	self.hunter.ignore_damage_upgrades = true
	self.hunter.fire_mode_data.fire_rate = 1
	self.hunter.kick = self.stat_info.kick_tables.horizontal_recoil
	self.hunter.supported = false
	self.hunter.stats = {
		damage = 120,
		spread = 20,
		recoil = 20,
		spread_moving = 8,
		zoom = 1,
		concealment = 26,
		suppression = 20,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.hunter.stats_modifiers = {damage = 2}

	--Heavy Crossbow
	self.arblast.upgrade_blocks = {
		weapon = {
			"clip_ammo_increase"
		}
	}
	self.arblast.has_description = true
	self.arblast.desc_id = "bm_ap_3_weapon_sc_desc"
	self.arblast.AMMO_MAX = 20
	self.arblast.fire_mode_data.fire_rate = 1.2
	self.arblast.kick = self.stat_info.kick_tables.horizontal_recoil
	self.arblast.supported = false
	self.arblast.stats = {
		damage = 90,
		spread = 21,
		recoil = 16,
		spread_moving = 8,
		zoom = 1,
		concealment = 25,
		suppression = 20,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.arblast.timers.reload_not_empty = 3.05
	self.arblast.timers.reload_empty = 3.05
	self.arblast.stats_modifiers = {damage =  4}
	self.frankish.upgrade_blocks = {
		weapon = {
			"clip_ammo_increase"
		}
	}

	--Light Crossbow
	self.frankish.has_description = true
	self.frankish.desc_id = "bm_ap_3_weapon_sc_desc"
	self.frankish.fire_mode_data.fire_rate = 1
	self.frankish.kick = self.stat_info.kick_tables.horizontal_recoil
	self.frankish.AMMO_MAX = 30
	self.frankish.ignore_damage_upgrades = true
	self.frankish.supported = false
	self.frankish.stats = {
		damage = 60,
		spread = 19,
		recoil = 18,
		spread_moving = 8,
		zoom = 1,
		concealment = 26,
		suppression = 20,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.frankish.timers.reload_not_empty = 1.6
	self.frankish.timers.reload_empty = 1.6
	self.frankish.stats_modifiers = {damage = 4}
	self.long.upgrade_blocks = {
		weapon = {
			"clip_ammo_increase"
		}
	}

	--English Longbow
	self.long.has_description = true
	self.long.desc_id = "bm_ap_2_weapon_sc_desc"
	self.long.kick = self.stat_info.kick_tables.none
	self.long.charge_data.max_t = 1
	self.long.not_allowed_in_bleedout = false
	self.long.AMMO_MAX = 20
	self.long.ignore_damage_upgrades = true
	self.long.supported = false
	self.long.stats = {
		damage = 90,
		spread = 21,
		recoil = 26,
		spread_moving = 12,
		zoom = 1,
		concealment = 29,
		suppression = 20,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.long.stats_modifiers = {damage = 4}

	--GSPS--
	self.m37.rays = 9
	self.m37.muzzleflash = "effects/particles/shotgun/shotgun_gen"
	self.m37.CLIP_AMMO_MAX = 6
	self.m37.AMMO_MAX = 30
	self.m37.fire_mode_data.fire_rate = 0.4
	self.m37.single.fire_rate = 0.4
	self.m37.kick = self.stat_info.kick_tables.right_kick
	self.m37.supported = false
	self.m37.stats = {
		damage = 60,
		spread = 9,
		recoil = 16,
		spread_moving = 6,
		zoom = 1,
		concealment = 20,
		suppression = 5,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.m37.stats_modifiers = nil

	--China Puff--
	self.china.upgrade_blocks = {
		weapon = {
			"clip_ammo_increase"
		}
	}
	self.china.desc_id = "bm_40mm_weapon_sc_desc"
	self.china.has_description = true
	self.china.fire_mode_data.fire_rate = 1.5
	self.china.single.fire_rate = 1.5
	self.china.AMMO_MAX = 5
	self.china.kick = self.stat_info.kick_tables.vertical_kick
	self.china.supported = false
	self.china.stats = {
		damage = 80,
		spread = 6,
		recoil = 9,
		spread_moving = 6,
		zoom = 1,
		concealment = 18,
		suppression = 20,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.china.stats_modifiers = {damage = 10}
	self.china.timers.shotgun_reload_first_shell_offset = 0.5

	--Akimbo Heather
	self.x_sr2.fire_mode_data.fire_rate = 0.06666666666
	self.x_sr2.single.fire_rate = 0.06666666666
	self.x_sr2.CLIP_AMMO_MAX = 60
	self.x_sr2.kick = self.stat_info.kick_tables.even_recoil
	self.x_sr2.AMMO_MAX = 180
	self.x_sr2.supported = false
	self.x_sr2.stats = {
		damage = 20,
		spread = 14,
		recoil = 11,
		spread_moving = 8,
		zoom = 1,
		concealment = 29,
		suppression = 9,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_sr2.stats_modifiers = nil

	--Akimbo MP5
	self.x_mp5.fire_mode_data.fire_rate = 0.075
	self.x_mp5.BURST_FIRE = 6
	self.x_mp5.ADAPTIVE_BURST_SIZE = false
	self.x_mp5.kick = self.stat_info.kick_tables.moderate_kick
	self.x_mp5.AMMO_MAX = 180
	self.x_mp5.supported = false
	self.x_mp5.stats = {
		damage = 20,
		spread = 15,
		recoil = 13,
		spread_moving = 8,
		zoom = 1,
		concealment = 28,
		suppression = 9,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_mp5.stats_modifiers = nil
	self.x_mp5.timers.reload_not_empty = 1.95
	self.x_mp5.timers.reload_empty = 2.6

	--Akimbo Krinkov
	self.x_akmsu.AMMO_MAX = 120
	self.x_akmsu.fire_mode_data.fire_rate = 0.0923076923
	self.x_akmsu.kick = self.stat_info.kick_tables.right_kick
	self.x_akmsu.supported = false
	self.x_akmsu.stats = {
		damage = 30,
		spread = 15,
		recoil = 10,
		spread_moving = 9,
		zoom = 1,
		concealment = 25,
		suppression = 7,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_akmsu.stats_modifiers = nil
	self.x_akmsu.timers.reload_not_empty = 2.75
	self.x_akmsu.timers.reload_empty = 3.4

	--Breaker 12g
	self.boot.AMMO_MAX = 40
	self.boot.CLIP_AMMO_MAX = 6
	self.boot.fire_rate_multiplier = 1.13
	self.boot.fire_mode_data.fire_rate = 0.85
	self.boot.single.fire_rate = 0.85
	self.boot.rays = 9
	self.boot.muzzleflash = "effects/particles/shotgun/muzzleflash"
	self.boot.kick = self.stat_info.kick_tables.right_kick
	self.boot.supported = false
	self.boot.stats = {
		damage = 90,
		spread = 9,
		recoil = 13,
		spread_moving = 5,
		zoom = 1,
		concealment = 18,
		suppression = 4,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.boot.timers = {
		shotgun_reload_enter = 0.733,
		shotgun_reload_exit_empty = 0.85,
		shotgun_reload_exit_not_empty = 0.55,
		shotgun_reload_shell = 0.33,
		shotgun_reload_first_shell_offset = 0.15,
		unequip = 0.55,
		equip = 0.85
	}
	self.boot.stats_modifiers = nil
	self.boot.stats_modifiers = {damage = 1}
	self.boot.reload_speed_multiplier = 0.75

	--Akimbo Contractor Pistols
	self.x_packrat.AMMO_MAX = 180
	self.x_packrat.fire_mode_data.fire_rate = 0.08571428571
	self.x_packrat.single.fire_rate = 0.08571428571
	self.x_packrat.kick = self.stat_info.kick_tables.even_recoil
	self.x_packrat.supported = false
	self.x_packrat.stats = {
		damage = 20,
		spread = 17,
		recoil = 14,
		spread_moving = 7,
		zoom = 1,
		concealment = 31,
		suppression = 9,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_packrat.stats_modifiers = nil

	--Goliath 12G
	self.rota.upgrade_blocks = nil
	self.rota.AMMO_MAX = 40
	self.rota.rays = 9
	self.rota.muzzleflash = "effects/particles/shotgun/shotgun_gen"
	self.rota.kick = self.stat_info.kick_tables.vertical_kick
	self.rota.fire_mode_data.fire_rate = 0.13953488372
	self.rota.single.fire_rate = 0.13953488372
	self.rota.supported = false
	self.rota.stats = {
		damage = 45,
		spread = 5,
		recoil = 17,
		spread_moving = 7,
		zoom = 1,
		concealment = 22,
		suppression = 6,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.rota.stats_modifiers = nil
	self.rota.timers.reload_interrupt = 0.46 --Technically the cylinder is disengaged by like 14% in, but it felt really bad at that value. Animations cover it up anyway.
	self.rota.timers.empty_reload_interrupt = 0.46

	--Arbiter, duh--
	self.arbiter.upgrade_blocks = {
		weapon = {
			"clip_ammo_increase"
		}
	}
	self.arbiter.fire_mode_data.fire_rate = 0.75
	self.arbiter.single.fire_rate = 0.75
	self.arbiter.CLIP_AMMO_MAX = 6
	self.arbiter.AMMO_MAX = 6
	self.arbiter.supported = false
	self.arbiter.stats = {
		damage = 60,
		spread = 6,
		recoil = 8,
		spread_moving = 6,
		zoom = 1,
		concealment = 15,
		suppression = 20,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.arbiter.stats_modifiers = {damage = 10}
	self.arbiter.kick = self.stat_info.kick_tables.vertical_kick
	self.arbiter.reload_speed_multiplier = 0.85

	--Commando 101
	self.ray.upgrade_blocks = {
		weapon = {
			"clip_ammo_increase"
		}
	}
	self.ray.use_data.selection_index = 2
	self.ray.has_description = true
	self.ray.desc_id = "bm_rocket_launcher_sc_desc"
	self.ray.kick = self.stat_info.kick_tables.vertical_kick
	self.ray.timers.reload_not_empty = 6
	self.ray.timers.reload_empty = 6
	self.ray.fire_mode_data.fire_rate = 1
	self.ray.CLIP_AMMO_MAX = 4
	self.ray.AMMO_MAX = 8
	self.ray.supported = false
	self.ray.stats = {
		damage = 400,
		spread = 16,
		recoil = 8,
		spread_moving = 6,
		zoom = 1,
		concealment = 12,
		suppression = 20,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.ray.stats_modifiers = {damage = 3}
	self.ray.swap_speed_multiplier = 1.2
	self.ray.turret_instakill = true

	--Akimbo Castigo
	self.x_chinchilla.tactical_akimbo = false
	self.x_chinchilla.fire_mode_data.fire_rate = 0.19047619
	self.x_chinchilla.single.fire_rate = 0.19047619
	self.x_chinchilla.AMMO_MAX = 60
	self.x_chinchilla.kick = self.stat_info.kick_tables.vertical_kick
	self.x_chinchilla.supported = false
	self.x_chinchilla.stats = {
		damage = 60,
		spread = 17,
		recoil = 9,
		spread_moving = 5,
		zoom = 1,
		concealment = 24,
		suppression = 5,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_chinchilla.stats_modifiers = nil
	self.x_chinchilla.timers.reload_empty = 3.7
	self.x_chinchilla.timers.reload_not_empty = 3.7

	--Airbow
	self.ecp.upgrade_blocks = {
		weapon = {
			"clip_ammo_increase"
		}
	}
	self.ecp.has_description = true
	self.ecp.desc_id = "bm_ap_3_weapon_sc_desc"
	self.ecp.kick = self.stat_info.kick_tables.right_kick
	self.ecp.AMMO_MAX = 40
	self.ecp.ignore_damage_upgrades = true
	self.ecp.supported = false
	self.ecp.stats = {
		damage = 45,
		spread = 17,
		recoil = 21,
		spread_moving = 8,
		zoom = 1,
		concealment = 25,
		suppression = 20,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.ecp.stats_modifiers = {damage = 4}

	--Akimbo Crosskill
	self.x_shrew.fire_mode_data.fire_rate = 0.08571428571
	self.x_shrew.single.fire_rate = 0.08571428571
	self.x_shrew.CLIP_AMMO_MAX = 12
	self.x_shrew.AMMO_MAX = 80
	self.x_shrew.kick = self.stat_info.kick_tables.moderate_kick
	self.x_shrew.supported = false
	self.x_shrew.stats = {
		damage = 45,
		spread = 17,
		recoil = 8,
		spread_moving = 5,
		zoom = 1,
		concealment = 27,
		suppression = 6,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_shrew.stats_modifiers = nil

	--Grimm 12g
	self.basset.rays = 9
	self.basset.muzzleflash = "effects/particles/shotgun/shotgun_gen"
	self.basset.CLIP_AMMO_MAX = 6
	self.basset.AMMO_MAX = 60
	self.basset.fire_mode_data = {fire_rate = 0.1}
	self.basset.auto = {fire_rate = 0.1}
	self.basset.kick = self.stat_info.kick_tables.moderate_left_kick
	self.basset.supported = false
	self.basset.stats = {
		zoom = 1,
		total_ammo_mod = 100,
		damage = 30,
		alert_size = 2,
		spread = 7,
		spread_moving = 8,
		recoil = 19,
		value = 1,
		extra_ammo = 101,
		reload = 20,
		suppression = 6,
		concealment = 24
	}
	self.basset.stats_modifiers = nil
	self.basset.reload_speed_multiplier = 1.25
	self.basset.timers.reload_interrupt = 0.2
	self.basset.timers.empty_reload_interrupt = 0.16

	--Compact 40mm
	self.slap.upgrade_blocks = {
		weapon = {
			"clip_ammo_increase"
		}
	}
	self.slap.desc_id = "bm_40mm_weapon_sc_desc"
	self.slap.has_description = false
	self.slap.fire_mode_data.fire_rate = 1.2
	self.slap.kick = self.stat_info.kick_tables.vertical_kick
	self.slap.AMMO_MAX = 5
	self.slap.supported = false
	self.slap.stats = {
		damage = 80,
		spread = 19,
		recoil = 9,
		spread_moving = 6,
		zoom = 1,
		concealment = 26,
		suppression = 20,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.slap.stats_modifiers = {damage = 10}

	--Akimbo Micro-Uzi
	--Keeping
	self.x_baka.use_data.selection_index = 2
	self.x_baka.CLIP_AMMO_MAX = 60
	self.x_baka.NR_CLIPS_MAX = 4
	self.x_baka.AMMO_MAX = 180
	self.x_baka.FIRE_MODE = "auto"
	self.x_baka.fire_mode_data = {}
	self.x_baka.fire_mode_data.fire_rate = 0.06315789473
	self.x_baka.CAN_TOGGLE_FIREMODE = true
	self.x_baka.single.fire_rate = 0.06315789473
	self.x_baka.kick = {}
	self.x_baka.kick = self.stat_info.kick_tables.moderate_kick
	self.x_baka.supported = false
	self.x_baka.stats = {
		damage = 20,
		spread = 13,
		recoil = 9,
		spread_moving = 8,
		zoom = 1,
		concealment = 28,
		suppression = 9,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_baka.stats_modifiers = nil

	--Akimbo MAC-10
	--Keeping
	self.x_mac10.CLIP_AMMO_MAX = 40
	self.x_mac10.AMMO_MAX = 120
	self.x_mac10.fire_mode_data.fire_rate = 0.06
	self.x_mac10.single.fire_rate = 0.06
	self.x_mac10.kick = self.stat_info.kick_tables.moderate_kick
	self.x_mac10.supported = false
	self.x_mac10.stats = {
		damage = 30,
		spread = 13,
		recoil = 7,
		spread_moving = 8,
		zoom = 1,
		concealment = 22,
		suppression = 7,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_mac10.stats_modifiers = nil

	--Akimbo Matever
	--Keeping
	self.x_2006m.fire_mode_data.fire_rate = 0.15789473684
	self.x_2006m.single.fire_rate = 0.15789473684
	self.x_2006m.AMMO_MAX = 60
	self.x_2006m.kick = self.stat_info.kick_tables.vertical_kick
	self.x_2006m.supported = false
	self.x_2006m.stats = {
		damage = 60,
		spread = 18,
		recoil = 9,
		spread_moving = 5,
		zoom = 1,
		concealment = 24,
		suppression = 5,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_2006m.stats_modifiers = nil
	self.x_2006m.weapon_hold = "x_chinchilla"
	self.x_2006m.animations.reload_name_id = "x_chinchilla"
	self.x_2006m.animations.second_gun_versions = self.x_rage.animations.second_gun_versions or {}
	self.x_2006m.animations.second_gun_versions.reload = "reload"
	self.x_2006m.timers.reload_not_empty = 4.1
	self.x_2006m.timers.reload_empty = 4.1

	--Akimbo Stryk18c
	--Keeping
	self.x_g18c.fire_mode_data.fire_rate = 0.05454545454
	self.x_g18c.single.fire_rate = 0.05454545454
	self.x_g18c.CLIP_AMMO_MAX = 36
	self.x_g18c.AMMO_MAX = 200
	self.x_g18c.kick = self.stat_info.kick_tables.moderate_kick
	self.x_g18c.supported = false
	self.x_g18c.stats = {
		damage = 18,
		spread = 15,
		recoil = 9,
		spread_moving = 9,
		zoom = 1,
		concealment = 28,
		suppression = 10,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_g18c.stats_modifiers = nil


	--Akimbo Broncos
	--Keeping
	self.x_rage.fire_mode_data.fire_rate = 0.19047619047
	self.x_rage.single.fire_rate = 0.19047619047
	self.x_rage.AMMO_MAX = 60
	self.x_rage.kick = self.stat_info.kick_tables.vertical_kick
	self.x_rage.supported = false
	self.x_rage.stats = {
		damage = 60,
		spread = 15,
		recoil = 8,
		spread_moving = 5,
		zoom = 1,
		concealment = 24,
		suppression = 5,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_rage.stats_modifiers = nil
	self.x_rage.weapon_hold = "x_chinchilla"
	self.x_rage.animations.reload_name_id = "x_chinchilla"
	self.x_rage.animations.second_gun_versions = self.x_rage.animations.second_gun_versions or {}
	self.x_rage.animations.second_gun_versions.reload = "reload"
	self.x_rage.timers.reload_not_empty = 3.3
	self.x_rage.timers.reload_empty = 3.3

	--Akimbo Judge
	--Keeping
	self.x_judge.fire_mode_data.fire_rate = 0.272727
	self.x_judge.single.fire_rate = 0.272727
	self.x_judge.rays = 9
	self.x_judge.FIRE_MODE = "single"
	self.x_judge.BURST_FIRE = true
	self.x_judge.AMMO_MAX = 40
	self.x_judge.supported = false
	self.x_judge.stats = {
		damage = 90,
		spread = 3,
		recoil = 0,
		spread_moving = 5,
		zoom = 1,
		concealment = 25,
		suppression = 4,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_judge.stats_modifiers = nil
	self.x_judge.weapon_hold = "x_chinchilla"
	self.x_judge.animations.reload_name_id = "x_chinchilla"
	self.x_judge.animations.second_gun_versions = self.x_judge.animations.second_gun_versions or {}
	self.x_judge.animations.second_gun_versions.reload = "reload"
	self.x_judge.kick = self.stat_info.kick_tables.vertical_kick

	--Microgun
	self.shuno.categories = {
		"minigun",
		"smg"
	}
	self.shuno.has_description = false
	self.shuno.CLIP_AMMO_MAX = 300
	self.shuno.NR_CLIPS_MAX = 1
	self.shuno.AMMO_MAX = 300
	self.shuno.FIRE_MODE = "auto"
	self.shuno.fire_mode_data = {}
	self.shuno.fire_mode_data.fire_rate = 0.05
	self.shuno.CAN_TOGGLE_FIREMODE = false
	self.shuno.auto = {}
	self.shuno.auto.fire_rate = 0.05
	self.shuno.kick = self.stat_info.kick_tables.horizontal_recoil
	self.shuno.supported = false
	self.shuno.stats = {
		damage = 18,
		spread = 16,
		recoil = 23,
		spread_moving = 9,
		zoom = 1,
		concealment = 10,
		suppression = 9,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 9,
		reload = 20
	}
	self.shuno.stats_modifiers = nil
	self.shuno.swap_speed_multiplier = 1.25

	--MA-17 Flamethrower
	self.system.categories = {
		"flamethrower",
		"shotgun"
	}
	self.system.recategorize = "wpn_special"
	self.system.has_description = true
	self.system.desc_id = "bm_ap_flamethrower_sc_desc"
	self.system.timers.reload_not_empty = 8
	self.system.timers.reload_empty = 8
	self.system.rays = 9
	self.system.CLIP_AMMO_MAX = 35
	self.system.AMMO_MAX = 60
	self.system.fire_mode_data.fire_rate = 0.1
	self.system.auto = {}
	self.system.auto.fire_rate = 0.1
	self.system.flame_max_range = 1400
	self.system.single_flame_effect_duration = 1
	self.system.armor_piercing_chance = 1
	self.system.can_shoot_through_enemy = false
	self.system.can_shoot_through_shield = false
	self.system.can_shoot_through_wall = false
	self.system.kick = self.stat_info.kick_tables.horizontal_recoil
	self.system.fire_dot_data = {
		dot_damage = 1.6,
		dot_trigger_chance = 60,
		dot_length = 3.1,
		dot_tick_period = 0.5
	}
	self.system.supported = false
	self.system.stats = {
		damage = 24,
		spread = 6,
		recoil = 23,
		spread_moving = 6,
		zoom = 1,
		concealment = 19,
		suppression = 7,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.system.stats_modifiers = nil

	--DECA Technologies Compound Bow
	self.elastic.upgrade_blocks = {
		weapon = {
			"clip_ammo_increase"
		}
	}
	self.elastic.has_description = true
	self.elastic.desc_id = "bm_ap_2_weapon_sc_desc"
	self.elastic.timers = {
		reload_not_empty = 1.5,
		reload_empty = 1.5,
		unequip = 0.85,
		equip = 0.85
	}
	self.elastic.kick = self.stat_info.kick_tables.none
	self.elastic.charge_data.max_t = 1
	self.elastic.not_allowed_in_bleedout = false
	self.elastic.AMMO_MAX = 20
	self.elastic.ignore_damage_upgrades = true
	self.elastic.supported = false
	self.elastic.stats = {
		damage = 90,
		spread = 20,
		recoil = 26,
		spread_moving = 12,
		zoom = 1,
		concealment = 30,
		suppression = 20,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.elastic.stats_modifiers = {damage = 4}

	--Claire 12G
	self.coach.muzzleflash = "effects/particles/shotgun/muzzleflash"
	self.coach.rays = 9
	self.coach.kick = self.stat_info.kick_tables.vertical_kick
	self.coach.AMMO_MAX = 20
	self.coach.sounds.fire_single = "coach_fire"
	self.coach.sounds.fire_auto = "coach_fire"
	self.coach.BURST_FIRE = 3
	self.coach.CAN_TOGGLE_FIREMODE = false
	self.coach.BURST_FIRE_RATE_MULTIPLIER = 120
	self.coach.DELAYED_BURST_RECOIL = true
	self.coach.ADAPTIVE_BURST_SIZE = false
	self.coach.fire_mode_data = {}
	self.coach.fire_mode_data.fire_rate = 0.06
	self.coach.single = {}
	self.coach.single.fire_rate = 0.06
	self.coach.auto = {}
	self.coach.auto.fire_rate = 0.06
	self.coach.supported = false
	self.coach.stats = {
		damage = 90,
		spread = 10,
		recoil = 13,
		spread_moving = 6,
		zoom = 1,
		concealment = 21,
		suppression = 3,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.coach.stats_modifiers = nil
	self.coach.reload_speed_multiplier = 1.2
	self.coach.timers.reload_interrupt = 0.05
	self.coach.timers.empty_reload_interrupt = 0.05

	--Akimbo CZ 75
	self.x_czech.AMMO_MAX = 180
	self.x_czech.fire_mode_data.fire_rate = 0.06
	self.x_czech.kick = self.stat_info.kick_tables.even_recoil
	self.x_czech.supported = false
	self.x_czech.stats = {
		damage = 20,
		spread = 14,
		recoil = 10,
		spread_moving = 5,
		zoom = 1,
		concealment = 28,
		suppression = 9,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_czech.stats_modifiers = nil

	--Akimbo Igor
	self.x_stech.fire_mode_data.fire_rate = 0.08
	self.x_stech.AMMO_MAX = 150
	self.x_stech.kick = self.stat_info.kick_tables.moderate_kick
	self.x_stech.CLIP_AMMO_MAX = 40
	self.x_stech.supported = false
	self.x_stech.stats = {
		damage = 24,
		spread = 15,
		recoil = 11,
		spread_moving = 8,
		zoom = 1,
		concealment = 26,
		suppression = 8,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_stech.stats_modifiers = nil

	--Akimbo Holt 9mm
	self.x_holt.fire_mode_data.fire_rate = 0.08571428571
	self.x_holt.single.fire_rate = 0.08571428571
	self.x_holt.CLIP_AMMO_MAX = 20
	self.x_holt.AMMO_MAX = 150
	self.x_holt.kick = self.stat_info.kick_tables.even_recoil
	self.x_holt.supported = false
	self.x_holt.stats = {
		damage = 24,
		spread = 16,
		recoil = 13,
		spread_moving = 5,
		zoom = 1,
		concealment = 29,
		suppression = 8,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_holt.stats_modifiers = nil

	--Akimbo Model 87
	self.x_model3.fire_mode_data = {}
	self.x_model3.fire_mode_data.fire_rate = 0.15789473684
	self.x_model3.single = {}
	self.x_model3.single.fire_rate = 0.15789473684
	self.x_model3.AMMO_MAX = 60
	self.x_model3.kick = self.stat_info.kick_tables.moderate_kick
	self.x_model3.supported = false
	self.x_model3.stats = {
		damage = 60,
		spread = 15,
		recoil = 7,
		spread_moving = 5,
		zoom = 1,
		concealment = 23,
		suppression = 5,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.x_model3.stats_modifiers = nil
	self.x_model3.timers.reload_not_empty = 2.4
	self.x_model3.timers.reload_empty = 2.4

	--Reinfeld 88
	self.m1897.muzzleflash = "effects/particles/shotgun/shotgun_gen"
	self.m1897.rays = 9
	self.m1897.CLIP_AMMO_MAX = 7
	self.m1897.kick = self.stat_info.kick_tables.vertical_kick
	self.m1897.single.fire_rate = 0.5
	self.m1897.fire_mode_data.fire_rate = 0.5
	self.m1897.AMMO_MAX = 60
	self.m1897.supported = false
	self.m1897.stats = {
		damage = 60,
		spread = 10,
		recoil = 17,
		spread_moving = 6,
		zoom = 1,
		concealment = 25,
		suppression = 5,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.m1897.stats_modifiers = nil


	--Mosconi 12G Tactical
	self.m590.tactical_reload = 1
	self.m590.muzzleflash = "effects/particles/shotgun/shotgun_gen"
	self.m590.rays = 9
	self.m590.CLIP_AMMO_MAX = 7
	self.m590.kick = self.stat_info.kick_tables.vertical_kick
	self.m590.AMMO_MAX = 60
	self.m590.supported = false
	self.m590.stats = {
		damage = 60,
		spread = 9,
		recoil = 16,
		spread_moving = 6,
		zoom = 1,
		concealment = 24,
		suppression = 5,
		alert_size = 2,
		extra_ammo = 101,
		total_ammo_mod = 100,
		value = 1,
		reload = 20
	}
	self.m590.stats_modifiers = nil

	--Anubis .45
	if self.socom then
		self.socom.timers = {
			reload_not_empty = 1.5435,
			reload_empty = 2.226,
			unequip = 0.5,
			equip = 0.35
		}
		self.socom.tactical_reload = 1
		self.socom.fire_mode_data.fire_rate = 0.08571428571
		self.socom.single.fire_rate = 0.08571428571
		self.socom.CLIP_AMMO_MAX = 12
		self.socom.AMMO_MAX = 40
		self.socom.kick = self.stat_info.kick_tables.even_recoil
		self.socom.supported = false
		self.socom.stats = {
			damage = 45,
			spread = 16,
			recoil = 21,
			spread_moving = 5,
			zoom = 1,
			concealment = 25,
			suppression = 6,
			alert_size = 2,
			extra_ammo = 101,
			total_ammo_mod = 100,
			value = 1,
			reload = 20
		}
		self.socom.stats_modifiers = nil
		self.socom.swap_speed_multiplier = 0.95
		self.socom.timers.reload_interrupt = 0.3
		self.socom.timers.empty_reload_interrupt = 0.2

		--Akimbo Anubis .45
		self.x_socom.tactical_reload = 2
		self.x_socom.fire_mode_data.fire_rate = 0.08571428571
		self.x_socom.single.fire_rate = 0.08571428571
		self.x_socom.CLIP_AMMO_MAX = 24
		self.x_socom.AMMO_MAX = 80
		self.x_socom.kick = self.stat_info.kick_tables.even_recoil
		self.x_socom.supported = false
		self.x_socom.stats = {
			damage = 45,
			spread = 14,
			recoil = 11,
			spread_moving = 5,
			zoom = 1,
			concealment = 25,
			suppression = 6,
			alert_size = 2,
			extra_ammo = 101,
			total_ammo_mod = 100,
			value = 1,
			reload = 20
		}
		self.x_socom.stats_modifiers = nil
		self.x_socom.swap_speed_multiplier = 0.95
	end

	--Disable unwanted akimbos.
		--These generally:
		--A: Fail to fit into an interesting and non-degenerate gameplay niche.
		--B: Lack unique animations.
		--C: Are cases where the guns have been made into primary weapons.
		self.x_basset.use_data.selection_index = 4 --Akimbo Grimms
		self.x_legacy.use_data.selection_index = 4 --Akimbo M13
		self.x_vityaz.use_data.selection_index = 4 --Akimbo AK Gen 21 Tactical
		self.x_pm9.use_data.selection_index = 4	--Akimbo Miyaka 10
		self.x_m1911.use_data.selection_index = 4 --Akimbo Crosskill Chunky
		self.x_beer.use_data.selection_index = 4 --Akimbo Beretta Auto
		self.x_shepheard.use_data.selection_index = 4 --Akimbo Signature SMG
		self.x_rota.use_data.selection_index = 4 --Akimbo Goliath 12g
		self.x_sparrow.use_data.selection_index = 4 --Akimbo Baby Deagle
		self.x_hs2000.use_data.selection_index = 4 --Akimbo Leo
		self.x_p226.use_data.selection_index = 4 --Akimbo Signature .40
		self.x_pl14.use_data.selection_index = 4 --Akimbo White Streak
		self.x_ppk.use_data.selection_index = 4 --Akimbo Gruber Kurz
		self.x_breech.use_data.selection_index = 4 --Akimbo Parabellum
		self.x_c96.use_data.selection_index = 4	--akimbo Broomstick
		self.x_mp7.use_data.selection_index = 4	--Akimbo Spec Ops
		self.x_mp9.use_data.selection_index = 4	--Akimbo CMP
		self.x_olympic.use_data.selection_index = 4	--Akimbo Para
		self.x_p90.use_data.selection_index = 4 --Akimbo Kobus 90
		self.x_polymer.use_data.selection_index = 4	--Akimbo Kross Vertex
		self.x_schakal.use_data.selection_index = 4	--Akimbo Jackal
		self.x_scorpion.use_data.selection_index = 4 --Akimbo Cobra
		self.x_sterling.use_data.selection_index = 4 --Akimbo Patchett
		self.x_tec9.use_data.selection_index = 4 --Akimbo Blasster 9mm
		self.x_uzi.use_data.selection_index = 4	--Akimbo Uzi
		self.x_cobray.use_data.selection_index = 4	--Akimbo Jacket's Piece
		self.x_erma.use_data.selection_index = 4 --Akimbo MP40
		self.x_hajk.use_data.selection_index = 4 --Akimbo CR805
		self.x_m45.use_data.selection_index = 4	--Akimbo Swedish K
		self.x_m1928.use_data.selection_index = 4 --Akimbo Chicago typewriter
		self.x_coal.use_data.selection_index = 4 --Akimbo Tatonka

	--Apply tactical reloading to relevant guns.
		local tact_rel = {'deagle','colt_1911','usp','p226','g22c','glock_17','glock_18c','b92fs','ppk','mp9','new_mp5','mp7','p90','olympic','akmsu','akm','akm_gold','ak74','m16','amcar','new_m4','ak5','s552','g36','aug','saiga','new_m14','scar','fal','rpk','msr','r93','m95','famas','galil','g3','scorpion','benelli','serbu','r870','ksg','g26','spas12','l85a2','vhs','hs2000','tec9','asval','sub2000','polymer','wa2000','model70','sparrow','m37','sr2','pl14','tecci','hajk','boot','packrat','schakal','desertfox','tti','siltstone','flint','coal','lemming','breech','basset','shrew','corgi','shepheard','komodo','legacy','beer','czech','stech','r700','holt'}
		for i, wep_id in ipairs(tact_rel) do
			self[wep_id].tactical_reload = 1
			self[wep_id].has_description = false
		end
		local tact_akimbo_pistol = {'x_deagle','x_1911','x_b92fs','jowi','x_usp','x_g17','x_g22c','x_packrat','x_shrew','x_breech','x_g18c','x_hs2000','x_p226','x_pl14','x_ppk','x_sparrow','x_legacy','x_czech','x_stech','x_holt'}
		for i, wep_id in ipairs(tact_akimbo_pistol) do
			self[wep_id].tactical_reload = 2
			self[wep_id].recategorize = "akimbo"
			self[wep_id].categories = {"akimbo", "pistol"}
		end
		local tact_akimbo_smg = {'x_sr2','x_mp5', 'x_coal', 'x_mp7', 'x_mp9', 'x_p90', 'x_polymer', 'x_schakal', 'x_scorpion', 'x_tec9','x_shepheard'}
		for i, wep_id in ipairs(tact_akimbo_smg) do
			self[wep_id].tactical_reload = 2
			self[wep_id].recategorize = "akimbo"
			self[wep_id].categories = {"akimbo", "smg"}
		end
		local tact_akimbo_rifle = {'x_akmsu', 'x_hajk', 'x_olympic'}
		for i, wep_id in ipairs(tact_akimbo_rifle) do
			self[wep_id].tactical_reload = 2
			self[wep_id].recategorize = "akimbo"
			self[wep_id].categories = {"akimbo", "assault_rifle"}
		end

	--Mark relevant weapons as using stripper clips of sizes that differ from the magazines.
		self.c96.uses_clip = true
		self.mosin.uses_clip = true
		self.c96.clip_capacity = 10
		self.mosin.clip_capacity = 5
		self.x_c96.uses_clip = true
		self.x_c96.clip_capacity = 20

	--Calculate any remaining weapon stats that are shared (IE: reload is always 20) or determined systemically (IE: ammo pickup).
	for name, weap in pairs(self) do
		if weap.categories and weap.stats then
			if not weap.supported then
				weap.use_data.selection_index = 4
			else
				local weap_crew = self[name .. "_crew"]
				if weap_crew and weap_crew.use_data.selection_index and weap.use_data.selection_index ~= weap_crew.use_data.selection_index then
					weap_crew.use_data.selection_index = weap.use_data.selection_index
				end

				--Fixed stat values that are the same for all, or nearly all guns.
				weap.stats.zoom = weap.stats.zoom or 1
				weap.stats.alert_size = weap.stats.alert_size or 2
				weap.stats.extra_ammo = 101
				weap.stats.total_ammo_mod = 100
				weap.stats.reload = 20
				weap.panic_suppression_chance = 0.05
				self:calculate_ammo_data(weap)
				self:calculate_suppression_data(weap)

				--Normalize camera shake.
				if weap.shake then
					weap.shake.fire_multiplier = weap.shake.fire_multiplier / math.abs(weap.shake.fire_multiplier)
					weap.shake.fire_steelsight_multiplier = weap.shake.fire_steelsight_multiplier / math.abs(weap.shake.fire_steelsight_multiplier)
				end
			end
		end
	end
end)

--Define % of total ammo to pickup baseline per damage tier.
--More damaging guns should pick up less ammo, as a tradeoff for their higher output.
--The pickup field corresponds to the amount of damage-as-ammo returned per pickup at 50% ammo.
--At 0% ammo, this is increased to 133.33%. At 100% ammo, this is reduced to 66%.
--On secondaries, overall pickup is reduced to damage_pool_secondary/damage_pool_primary.
--On guns with unique ammo counts (IE: With underbarrels), it's reduced proportionally to the primary damage pool.
--Guns in different categories have additional pickup multipliers, somewhat correlated with their range multipliers.
local damage_tier_data = {
	{damage = 18,  pickup = 378, suppression = 4}, --18/36 damage guns
	{damage = 20,  pickup = 360, suppression = 6},
	{damage = 24,  pickup = 342, suppression = 8},
	{damage = 30,  pickup = 324, suppression = 10},
	{damage = 45,  pickup = 306, suppression = 11},
	{damage = 60,  pickup = 288, suppression = 12},
	{damage = 90,  pickup = 270, suppression = 13},
	{damage = 120, pickup = 252, suppression = 14},
	{damage = 180, pickup = 234, suppression = 15},
	{damage = 240, pickup = 216, suppression = 16}, --All guns above here.
	{damage = 360, pickup = 198, suppression = 17}, --Heavy bows.
	{damage = 600, pickup = 180, suppression = 18}, --Light GLs
	{damage = 800, pickup = 162, suppression = 19}, --Heavy GLs
	{damage = 1200, pickup = 144, suppression = 20} --Rocket Launchers
}
local damage_pool_primary = 7200
local damage_pool_secondary = 3600

function get_damage_tier(weapon)
	local damage_mul = weapon.stats_modifiers and weapon.stats_modifiers.damage or 1
	local damage = weapon.stats.damage * damage_mul
	for i, damage_tier in ipairs(damage_tier_data) do
		if damage - 1 <= damage_tier.damage then
			return damage_tier
		end
	end

	return damage_tier_data[#damage_tier_data]
end

local category_suppression_muls = {
	lmg = 1.5,
	bow = 0.5,
	crossbow = 0.5,
	snp = 0.5,
	pistol = 0.5
}

--Determines the suppression value of the gun. Generally increases with higher damage guns.
--More headshot focused typically-single-fire gun categories get lower suppression, LMGs and Shotties get higher suppression to fit their roles/fantasies.
function WeaponTweakData:calculate_suppression_data(weapon)
	local damage_tier = get_damage_tier(weapon)

	--Get weapon category specific suppression multipliers.
	local multiplier = 1
	for i = 1, #weapon.categories do
		local category = weapon.categories[i]
		multiplier = multiplier * (category_suppression_muls[category] or 1)
	end

	--Silenced guns have their suppression reduced by an additional 4 points.
	weapon.stats.suppression = math.clamp(math.round(damage_tier.suppression * multiplier) - (weapon.stats.alert_size == 2 and 4 or 0), 1, #self.stats.suppression)
end

local category_pickup_muls = { --Different gun categories have different pickup mults to compensate for various factors.
	shotgun = 0.7, --Compensate for ease of aim+multikills and/or versatility.
	bow = 0.7, --Compensate for picking arrows back up.
	crossbow = 0.7,
	pistol = 1.1, --Compensate for low range.
	smg = 1.1,
	akimbo = 1.1,
	saw = 1.25, --Compensate for jankiness.
	lmg = 1
}

local category_ammo_max_muls = {
	lmg = 1.5,
	rocket_launcher = 1.15
}

--Determines a gun's total ammo and pickup.
function WeaponTweakData:calculate_ammo_data(weapon)
	--Determine the damage tier the gun falls under.
	weapon.AMMO_PICKUP = {0, 0}

	local damage_tier = get_damage_tier(weapon)

	local damage_pool = damage_pool_primary
	if weapon.use_data.selection_index == 1 then
		damage_pool = damage_pool_secondary
	end

	local damage_mul = 1
	if damage_tier.damage <= 180 then
		damage_mul = 2
	end

	weapon.AMMO_PICKUP[1] = 1.333333333334 * (damage_tier.pickup / (damage_mul * damage_tier.damage))
	weapon.AMMO_PICKUP[2] = 0.666666666667 * (damage_tier.pickup / (damage_mul * damage_tier.damage))

	local pickup_multiplier = 1
	for i = 1, #weapon.categories do
		local category = weapon.categories[i]
		pickup_multiplier = pickup_multiplier * (category_pickup_muls[category] or 1)
	end

	local ammo_max = weapon.AMMO_MAX
	if not ammo_max then
		ammo_max = damage_pool / (damage_mul * damage_tier.damage)

		--Remove this once rocket launchers are properly tagged.
		if damage_tier.damage >= 1200 then
			ammo_max = ammo_max * category_ammo_max_muls.rocket_launcher
		end

		--Get weapon category specific max ammo multipliers.
		for i = 1, #weapon.categories do
			local category = weapon.categories[i]
			ammo_max = ammo_max * (category_ammo_max_muls[category] or 1)
		end

		if weapon.use_data.selection_index == 1 then
			pickup_multiplier = damage_pool_secondary / damage_pool_primary
		end
	else
		pickup_multiplier = (weapon.AMMO_MAX * damage_tier.damage * damage_mul) / damage_pool_primary
	end

	--Set actual pickup values to use.
	weapon.AMMO_PICKUP[1] = weapon.AMMO_PICKUP[1] * pickup_multiplier
	weapon.AMMO_PICKUP[2] = weapon.AMMO_PICKUP[2] * pickup_multiplier
	weapon.AMMO_MAX = math.floor(ammo_max)
end

WeaponTweakData.clone__create_table_structure = WeaponTweakData._create_table_structure
function WeaponTweakData:_create_table_structure()
	self:clone__create_table_structure()
	self.hk23_sc_npc = {
		usage = "is_lmg",
		anim_usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.m249_bravo_npc = {
		usage = "is_lmg",
		anim_usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.hk21_sc_npc = {
		usage = "is_lmg",
		anim_usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.peacemaker_npc = {
		usage = "is_revolver",
		sounds = {},
		use_data = {}
	}
	self.m249_npc = {
		usage = "is_lmg",
		anim_usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.mossberg_npc = {
		usage = "is_shotgun_pump",
		anim_usage = "is_shotgun_pump",
		sounds = {},
		use_data = {}
	}
	self.mp9_npc = {
		usage = "is_smg",
		anim_usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.osipr_gl_npc = {
		usage = "is_rifle",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.smoke_npc = {
		usage = "is_smg",
		sounds = {},
		use_data = {},
		auto = {}
	}
	self.flamethrower_mk2_crew.anim_usage = "is_bullpup"
	self.flamethrower_mk2_crew.usage = "is_flamethrower"
end

function WeaponTweakData:get_npc_mappings()
	local npc_mappings = {
		new_m4 = "m4_crew",
		new_m14 = "m14_crew",
		colt_1911 = "c45_crew",
		glock_18c = "glock_18_crew",
		b92fs = "beretta92_crew",
		new_raging_bull = "raging_bull_crew",
		new_mp5 = "mp5_crew",
		glock_17 = "g17_crew",
		osipr = "osipr_crew"
	}

	for id, data in pairs(self) do
		if data.autohit and not npc_mappings[id] then
			npc_mappings[id] = id .. "_crew"
		end
	end

	return npc_mappings
end

--TeamAI guns.
	--Base Stats
		local crew_pistol_stats = {
			DAMAGE = 6,
			CLIP_AMMO_MAX = 12,
			NR_CLIPS_MAX = 10,
			alert_size = 2500,
			suppression = 0.9,
			FIRE_MODE = "single",
			armor_piercing = false,
			usage = "is_pistol",
			reload = "pistol"
		}

		local crew_revolver_stats = {
			DAMAGE = 12,
			CLIP_AMMO_MAX = 6,
			NR_CLIPS_MAX = 10,
			alert_size = 2500,
			suppression = 0.9,
			FIRE_MODE = "single",
			armor_piercing = false,
			usage = "is_revolver",
			reload = "pistol"
		}

		local crew_rifle_stats = {
			DAMAGE = 4.8,
			CLIP_AMMO_MAX = 30,
			NR_CLIPS_MAX = 5,
			alert_size = 2500,
			suppression = 1.8,
			FIRE_MODE = "auto",
			auto = {fire_rate = 0.08571428571},
			armor_piercing = false,
			usage = "is_rifle",
			reload = "rifle"
		}

		local crew_underbarrel_rifle_stats = {
			DAMAGE = 4.8,
			CLIP_AMMO_MAX = 20,
			NR_CLIPS_MAX = 5,
			alert_size = 2500,
			suppression = 1.8,
			FIRE_MODE = "auto",
			auto = {fire_rate = 0.08571428571},
			armor_piercing = false,
			usage = "is_rifle_underbarrel",
			reload = "rifle"
		}

		local crew_smg_stats = {
			DAMAGE = 4,
			CLIP_AMMO_MAX = 20,
			NR_CLIPS_MAX = 9,
			alert_size = 2500,
			suppression = 2.7,
			FIRE_MODE = "auto",
			auto = {fire_rate = 0.08571428571},
			armor_piercing = false,
			usage = "is_smg",
			reload = "uzi"
		}

		local crew_lmg_stats = {
			DAMAGE = 4,
			CLIP_AMMO_MAX = 90,
			NR_CLIPS_MAX = 2,
			alert_size = 2500,
			suppression = 2.7,
			FIRE_MODE = "auto",
			auto = {fire_rate = 0.1},
			armor_piercing = false,
			usage = "is_lmg",
			reload = "rifle"
		}

		local crew_dmr_stats = {
			DAMAGE = 12,
			CLIP_AMMO_MAX = 10,
			NR_CLIPS_MAX = 6,
			alert_size = 2500,
			suppression = 1.8,
			FIRE_MODE = "single",
			armor_piercing = false,
			usage = "is_dmr",
			reload = "rifle"
		}

		local crew_sniper_stats = {
			DAMAGE = 18,
			CLIP_AMMO_MAX = 5,
			NR_CLIPS_MAX = 8,
			alert_size = 2500,
			suppression = 2.7,
			FIRE_MODE = "single",
			armor_piercing = true,
			shield_piercing = true,
			usage = "is_sniper",
			reload = "rifle"
		}

		local crew_shotgun_mag_stats = {
			DAMAGE = 90,
			CLIP_AMMO_MAX = 10,
			NR_CLIPS_MAX = 8,
			alert_size = 2500,
			suppression = 2.7,
			FIRE_MODE = "auto",
			auto = {fire_rate = 0.1},
			armor_piercing = false,
			is_shotgun = true,
			usage = "is_shotgun_mag",
			reload = "shotgun"
		}

		local crew_shotgun_stats = {
			DAMAGE = 18,
			CLIP_AMMO_MAX = 10,
			NR_CLIPS_MAX = 6,
			alert_size = 2500,
			suppression = 2.7,
			FIRE_MODE = "single",
			armor_piercing = false,
			is_shotgun = true,
			usage = "is_shotgun_pump",
			reload = "shotgun"
		}

		local crew_shotgun_double_stats = {
			DAMAGE = 36,
			CLIP_AMMO_MAX = 2,
			NR_CLIPS_MAX = 15,
			alert_size = 2500,
			suppression = 2.7,
			FIRE_MODE = "single",
			armor_piercing = false,
			is_shotgun = true,
			usage = "is_shotgun_double",
			reload = "shotgun"
		}

		local reload_times = {
			default = 2,
			rifle = 83 / 30,
			pistol = 46 / 30,
			shotgun = 83 / 30,
			bullpup = 74 / 30,
			uzi = 70 / 30,
			akimbo_pistol = 35 / 30
		}


		function get_crew_gun_reload_time(weap)
			if weap.reload == "looped" then
				local multiplier = weap.looped_reload_speed or 1
				local single_reload = weap.sounds and weap.sounds.prefix and (sound_prefix == "nagant_npc" or sound_prefix == "ching_npc" or sound_prefix == "ecp_npc")
				local magazine_size = weap.CLIP_AMMO_MAX
				local loop_amount = single_reload and 1 or magazine_size

				return (1 * ((0.45 * loop_amount) / multiplier))
			else
				local hold_type = weap.hold
				if not hold_type then
					return reload_times.default
				end

				if type(hold_type) == "table" then
					for _, hold in ipairs(hold_type) do
						if reload_times[hold] then
							return reload_times[hold], hold
						end
					end

					return reload_times.default
				elseif reload_times[hold_type] then
					return reload_times[hold_type], hold_type
				else
					return reload_times.default
				end
			end
		end

		function apply_crew_weapon_preset(weap, preset)
			--Apply preset stats to gun.
			for k, v in pairs(preset) do
				if k ~= "reload" then
					weap[k] = v
				end
			end

			--Force reload timers to match the expected one for the preset.
			local reload_time = get_crew_gun_reload_time(weap)
			local desired_reload_time = reload_times[preset.reload]
			weap.crew_reload_speed_mul = 1
			if desired_reload_time ~= reload_time then
				weap.crew_reload_speed_mul = reload_time / desired_reload_time
			end
		end

	--Init Functions
		local old_init_data_c45_crew = WeaponTweakData._init_data_c45_crew
		function WeaponTweakData:_init_data_c45_crew()
			old_init_data_c45_crew(self)
			apply_crew_weapon_preset(self.c45_crew, crew_pistol_stats)
			apply_crew_weapon_preset(self.colt_1911_primary_crew, crew_pistol_stats)
		end

		local old_init_data_beretta92_crew = WeaponTweakData._init_data_beretta92_crew
		function WeaponTweakData:_init_data_beretta92_crew()
			old_init_data_beretta92_crew(self)
			apply_crew_weapon_preset(self.beretta92_crew, crew_pistol_stats)
			apply_crew_weapon_preset(self.beretta92_primary_crew, crew_pistol_stats)
		end

		local old_init_data_glock_18_crew = WeaponTweakData._init_data_glock_18_crew
		function WeaponTweakData:_init_data_glock_18_crew()
			old_init_data_glock_18_crew(self)
			apply_crew_weapon_preset(self.glock_18_crew, crew_smg_stats) --An SMG more closely matches what one would expect from an autopistol.
			apply_crew_weapon_preset(self.glock_18c_primary_crew, crew_smg_stats)
		end

		local old_init_data_raging_bull_crew = WeaponTweakData._init_data_raging_bull_crew
		function WeaponTweakData:_init_data_raging_bull_crew()
			old_init_data_raging_bull_crew(self)
			apply_crew_weapon_preset(self.raging_bull_crew, crew_revolver_stats)
			apply_crew_weapon_preset(self.raging_bull_primary_crew, crew_revolver_stats)
		end

		local old_init_data_m4_crew = WeaponTweakData._init_data_m4_crew
		function WeaponTweakData:_init_data_m4_crew()
			old_init_data_m4_crew(self)
			apply_crew_weapon_preset(self.m4_crew, crew_rifle_stats)
			apply_crew_weapon_preset(self.m4_secondary_crew, crew_rifle_stats)
			apply_crew_weapon_preset(self.ak47_ass_crew, crew_rifle_stats)
		end

		local old_init_data_ak47_crew = WeaponTweakData._init_data_ak47_crew
		function WeaponTweakData:_init_data_ak47_crew()
			old_init_data_ak47_crew(self)
			apply_crew_weapon_preset(self.ak47_crew, crew_rifle_stats)
		end

		local old_init_data_m14_crew = WeaponTweakData._init_data_m14_crew
		function WeaponTweakData:_init_data_m14_crew()
			self.m14_crew.auto = {}
			old_init_data_m14_crew(self)
			apply_crew_weapon_preset(self.m14_crew, crew_dmr_stats)
		end

		local old_init_data_r870_crew = WeaponTweakData._init_data_r870_crew
		function WeaponTweakData:_init_data_r870_crew()
			old_init_data_r870_crew(self)
			apply_crew_weapon_preset(self.r870_crew, crew_shotgun_stats)
			apply_crew_weapon_preset(self.benelli_crew, crew_shotgun_stats)
		end

		local old_init_data_mossberg_crew = WeaponTweakData._init_data_mossberg_crew
		function WeaponTweakData:_init_data_mossberg_crew()
			old_init_data_mossberg_crew(self)
			apply_crew_weapon_preset(self.mossberg_crew, crew_shotgun_stats)
		end

		local old_init_data_mp5_crew = WeaponTweakData._init_data_mp5_crew
		function WeaponTweakData:_init_data_mp5_crew()
			old_init_data_mp5_crew(self)
			apply_crew_weapon_preset(self.mp5_crew, crew_smg_stats)
		end

		local old_init_data_g36_crew = WeaponTweakData._init_data_g36_crew
		function WeaponTweakData:_init_data_g36_crew()
			old_init_data_g36_crew(self)
			apply_crew_weapon_preset(self.g36_crew, crew_rifle_stats)
		end

		local old_init_data_g17_crew = WeaponTweakData._init_data_g17_crew
		function WeaponTweakData:_init_data_g17_crew()
			old_init_data_g17_crew(self)
			apply_crew_weapon_preset(self.g17_crew, crew_pistol_stats)
		end

		local old_init_data_mp9_crew = WeaponTweakData._init_data_mp9_crew
		function WeaponTweakData:_init_data_mp9_crew()
			old_init_data_mp9_crew(self)
			apply_crew_weapon_preset(self.mp9_crew, crew_smg_stats)
		end

		local old_init_data_olympic_crew = WeaponTweakData._init_data_olympic_crew
		function WeaponTweakData:_init_data_olympic_crew()
			old_init_data_olympic_crew(self)
			apply_crew_weapon_preset(self.olympic_crew, crew_rifle_stats)
		end

		local old_init_data_m16_crew = WeaponTweakData._init_data_m16_crew
		function WeaponTweakData:_init_data_m16_crew()
			old_init_data_m16_crew(self)
			apply_crew_weapon_preset(self.m16_crew, crew_rifle_stats)
		end

		local old_init_data_aug_crew = WeaponTweakData._init_data_aug_crew
		function WeaponTweakData:_init_data_aug_crew()
			old_init_data_aug_crew(self)
			apply_crew_weapon_preset(self.aug_crew, crew_rifle_stats)
			apply_crew_weapon_preset(self.aug_secondary_crew, crew_rifle_stats)
		end

		local old_init_data_ak74_crew = WeaponTweakData._init_data_ak74_crew
		function WeaponTweakData:_init_data_ak74_crew()
			old_init_data_ak74_crew(self)
			apply_crew_weapon_preset(self.ak74_crew, crew_rifle_stats)
			apply_crew_weapon_preset(self.ak74_secondary_crew, crew_rifle_stats)
		end

		local old_init_data_ak5_crew = WeaponTweakData._init_data_ak5_crew
		function WeaponTweakData:_init_data_ak5_crew()
			old_init_data_ak5_crew(self)
			apply_crew_weapon_preset(self.ak5_crew, crew_rifle_stats)
		end

		local old_init_data_p90_crew = WeaponTweakData._init_data_p90_crew
		function WeaponTweakData:_init_data_p90_crew()
			old_init_data_p90_crew(self)
			apply_crew_weapon_preset(self.p90_crew, crew_smg_stats)
		end

		local old_init_data_amcar_crew = WeaponTweakData._init_data_amcar_crew
		function WeaponTweakData:_init_data_amcar_crew()
			old_init_data_amcar_crew(self)
			apply_crew_weapon_preset(self.amcar_crew, crew_rifle_stats)
		end

		local old_init_data_mac10_crew = WeaponTweakData._init_data_mac10_crew
		function WeaponTweakData:_init_data_mac10_crew()
			old_init_data_mac10_crew(self)
			apply_crew_weapon_preset(self.mac10_crew, crew_smg_stats)
		end

		local old_init_data_akmsu_crew = WeaponTweakData._init_data_akmsu_crew
		function WeaponTweakData:_init_data_akmsu_crew()
			old_init_data_akmsu_crew(self)
			apply_crew_weapon_preset(self.akmsu_crew, crew_rifle_stats)
			apply_crew_weapon_preset(self.akmsu_primary_crew, crew_rifle_stats)
		end

		local old_init_data_akm_crew = WeaponTweakData._init_data_akm_crew
		function WeaponTweakData:_init_data_akm_crew()
			old_init_data_akm_crew(self)
			apply_crew_weapon_preset(self.akm_crew, crew_rifle_stats)
		end

		local old_init_data_akm_gold_crew = WeaponTweakData._init_data_akm_gold_crew
		function WeaponTweakData:_init_data_akm_gold_crew()
			old_init_data_akm_gold_crew(self)
			apply_crew_weapon_preset(self.akm_gold, crew_rifle_stats)
		end

		local old_init_data_deagle_crew = WeaponTweakData._init_data_deagle_crew
		function WeaponTweakData:_init_data_deagle_crew()
			old_init_data_deagle_crew(self)
			apply_crew_weapon_preset(self.deagle_crew, crew_revolver_stats)
			apply_crew_weapon_preset(self.deagle_primary_crew, crew_revolver_stats)
		end

		local old_init_data_serbu_crew = WeaponTweakData._init_data_serbu_crew
		function WeaponTweakData:_init_data_serbu_crew()
			old_init_data_serbu_crew(self)
			apply_crew_weapon_preset(self.serbu_crew, crew_shotgun_stats)
		end

		local old_init_data_saiga_crew = WeaponTweakData._init_data_saiga_crew
		function WeaponTweakData:_init_data_saiga_crew()
			old_init_data_saiga_crew(self)
			apply_crew_weapon_preset(self.saiga_crew, crew_shotgun_mag_stats)
		end

		local old_init_data_huntsman_crew = WeaponTweakData._init_data_huntsman_crew
		function WeaponTweakData:_init_data_huntsman_crew()
			old_init_data_huntsman_crew(self)
			apply_crew_weapon_preset(self.huntsman_crew, crew_shotgun_double_stats)
		end

		local old_init_data_usp_crew = WeaponTweakData._init_data_usp_crew
		function WeaponTweakData:_init_data_usp_crew()
			old_init_data_usp_crew(self)
			apply_crew_weapon_preset(self.usp_crew, crew_pistol_stats)
		end

		local old_init_data_g22c_crew = WeaponTweakData._init_data_g22c_crew
		function WeaponTweakData:_init_data_g22c_crew()
			old_init_data_g22c_crew(self)
			apply_crew_weapon_preset(self.g22c_crew, crew_pistol_stats)
		end

		local old_init_data_judge_crew = WeaponTweakData._init_data_judge_crew
		function WeaponTweakData:_init_data_judge_crew()
			old_init_data_judge_crew(self)
			apply_crew_weapon_preset(self.judge_crew, crew_shotgun_stats)
		end

		local old_init_data_m45_crew = WeaponTweakData._init_data_m45_crew
		function WeaponTweakData:_init_data_m45_crew()
			old_init_data_m45_crew(self)
			apply_crew_weapon_preset(self.m45_crew, crew_smg_stats)
		end

		local old_init_data_s552_crew = WeaponTweakData._init_data_s552_crew
		function WeaponTweakData:_init_data_s552_crew()
			old_init_data_s552_crew(self)
			apply_crew_weapon_preset(self.s552_crew, crew_rifle_stats)
			apply_crew_weapon_preset(self.s552_secondary_crew, crew_rifle_stats)
		end

		local old_init_data_ppk_crew = WeaponTweakData._init_data_ppk_crew
		function WeaponTweakData:_init_data_ppk_crew()
			old_init_data_ppk_crew(self)
			apply_crew_weapon_preset(self.ppk_crew, crew_pistol_stats)
		end

		local old_init_data_mp7_crew = WeaponTweakData._init_data_mp7_crew
		function WeaponTweakData:_init_data_mp7_crew()
			old_init_data_mp7_crew(self)
			apply_crew_weapon_preset(self.mp7_crew, crew_smg_stats)
		end

		local old_init_data_scar_crew = WeaponTweakData._init_data_scar_crew
		function WeaponTweakData:_init_data_scar_crew()
			old_init_data_scar_crew(self)
			apply_crew_weapon_preset(self.scar_crew, crew_rifle_stats)
		end

		local old_init_data_p226_crew = WeaponTweakData._init_data_p226_crew
		function WeaponTweakData:_init_data_p226_crew()
			old_init_data_p226_crew(self)
			apply_crew_weapon_preset(self.p226_crew, crew_pistol_stats)
		end

		local old_init_data_hk21_crew = WeaponTweakData._init_data_hk21_crew
		function WeaponTweakData:_init_data_hk21_crew()
			old_init_data_hk21_crew(self)
			apply_crew_weapon_preset(self.hk21_crew, crew_lmg_stats)
		end

		local old_init_data_m249_crew = WeaponTweakData._init_data_m249_crew
		function WeaponTweakData:_init_data_m249_crew()
			old_init_data_m249_crew(self)
			apply_crew_weapon_preset(self.m249_crew, crew_lmg_stats)
		end

		local old_init_data_rpk_crew = WeaponTweakData._init_data_rpk_crew
		function WeaponTweakData:_init_data_rpk_crew()
			old_init_data_rpk_crew(self)
			apply_crew_weapon_preset(self.rpk_crew, crew_lmg_stats)
		end

		local old_init_data_m95_crew = WeaponTweakData._init_data_m95_crew
		function WeaponTweakData:_init_data_m95_crew()
			old_init_data_m95_crew(self)
			apply_crew_weapon_preset(self.m95_crew, crew_sniper_stats)
		end

		local old_init_data_msr_crew = WeaponTweakData._init_data_msr_crew
		function WeaponTweakData:_init_data_msr_crew()
			old_init_data_msr_crew(self)
			apply_crew_weapon_preset(self.msr_crew, crew_sniper_stats)
		end

		local old_init_data_r93_crew = WeaponTweakData._init_data_r93_crew
		function WeaponTweakData:_init_data_r93_crew()
			old_init_data_r93_crew(self)
			apply_crew_weapon_preset(self.r93_crew, crew_sniper_stats)
		end

		local old_init_data_fal_crew = WeaponTweakData._init_data_fal_crew
		function WeaponTweakData:_init_data_fal_crew()
			old_init_data_fal_crew(self)
			apply_crew_weapon_preset(self.fal_crew, crew_rifle_stats)
		end

		local old_init_data_ben_crew = WeaponTweakData._init_data_ben_crew
		function WeaponTweakData:_init_data_ben_crew()
			old_init_data_ben_crew(self)
			apply_crew_weapon_preset(self.ben_crew, crew_shotgun_stats)
		end

		local old_init_data_striker_crew = WeaponTweakData._init_data_striker_crew
		function WeaponTweakData:_init_data_striker_crew()
			old_init_data_striker_crew(self)
			apply_crew_weapon_preset(self.striker_crew, crew_shotgun_mag_stats) --Not an auto-shotty, but it's close enough.
		end

		local old_init_data_ksg_crew = WeaponTweakData._init_data_ksg_crew
		function WeaponTweakData:_init_data_ksg_crew()
			old_init_data_ksg_crew(self)
			apply_crew_weapon_preset(self.ksg_crew, crew_shotgun_stats)
		end

		local old_init_data_g3_crew = WeaponTweakData._init_data_g3_crew
		function WeaponTweakData:_init_data_g3_crew()
			old_init_data_g3_crew(self)
			apply_crew_weapon_preset(self.g3_crew, crew_rifle_stats)
		end

		local old_init_data_g3_crew = WeaponTweakData._init_data_g3_crew
		function WeaponTweakData:_init_data_galil_crew()
			old_init_data_g3_crew(self)
			apply_crew_weapon_preset(self.galil_crew, crew_rifle_stats)
		end

		local old_init_data_famas_crew = WeaponTweakData._init_data_famas_crew
		function WeaponTweakData:_init_data_famas_crew()
			old_init_data_famas_crew(self)
			apply_crew_weapon_preset(self.famas_crew, crew_rifle_stats)
		end

		local old_init_data_scorpion_crew = WeaponTweakData._init_data_scorpion_crew
		function WeaponTweakData:_init_data_scorpion_crew()
			old_init_data_scorpion_crew(self)
			apply_crew_weapon_preset(self.scorpion_crew, crew_smg_stats)
		end

		local old_init_data_tec9_crew = WeaponTweakData._init_data_tec9_crew
		function WeaponTweakData:_init_data_tec9_crew()
			old_init_data_tec9_crew(self)
			apply_crew_weapon_preset(self.tec9_crew, crew_smg_stats)
		end

		local old_init_data_uzi_crew = WeaponTweakData._init_data_uzi_crew
		function WeaponTweakData:_init_data_uzi_crew()
			old_init_data_uzi_crew(self)
			apply_crew_weapon_preset(self.uzi_crew, crew_smg_stats)
		end

		local old_init_data_g26_crew = WeaponTweakData._init_data_g26_crew
		function WeaponTweakData:_init_data_g26_crew()
			old_init_data_g26_crew(self)
			apply_crew_weapon_preset(self.g26_crew, crew_pistol_stats)
		end

		local old_init_data_spas12_crew = WeaponTweakData._init_data_spas12_crew
		function WeaponTweakData:_init_data_spas12_crew()
			self.spas12_crew.auto = {}
			old_init_data_spas12_crew(self)
			apply_crew_weapon_preset(self.spas12_crew, crew_shotgun_stats)
		end

		local old_init_data_mg42_crew = WeaponTweakData._init_data_mg42_crew
		function WeaponTweakData:_init_data_mg42_crew()
			old_init_data_mg42_crew(self)
			apply_crew_weapon_preset(self.mg42_crew, crew_lmg_stats)
		end

		old_init_data_c96_crew = WeaponTweakData._init_data_c96_crew
		function WeaponTweakData:_init_data_c96_crew()
			old_init_data_c96_crew(self)
			apply_crew_weapon_preset(self.c96_crew, crew_pistol_stats)
		end

		local old_init_data_sterling_crew = WeaponTweakData._init_data_sterling_crew
		function WeaponTweakData:_init_data_sterling_crew()
			old_init_data_sterling_crew(self)
			apply_crew_weapon_preset(self.sterling_crew, crew_smg_stats)
		end

		local old_init_data_mosin_crew = WeaponTweakData._init_data_mosin_crew
		function WeaponTweakData:_init_data_mosin_crew()
			old_init_data_mosin_crew(self)
			apply_crew_weapon_preset(self.mosin_crew, crew_sniper_stats)
		end

		local old_init_data_m1928_crew = WeaponTweakData._init_data_m1928_crew
		function WeaponTweakData:_init_data_m1928_crew()
			old_init_data_m1928_crew(self)
			apply_crew_weapon_preset(self.m1928_crew, crew_smg_stats)
		end

		local old_init_data_l85a2_crew = WeaponTweakData._init_data_l85a2_crew
		function WeaponTweakData:_init_data_l85a2_crew()
			old_init_data_l85a2_crew(self)
			apply_crew_weapon_preset(self.l85a2_crew, crew_rifle_stats)
		end

		local old_init_data_vhs_crew = WeaponTweakData._init_data_vhs_crew
		function WeaponTweakData:_init_data_vhs_crew()
			old_init_data_vhs_crew(self)
			apply_crew_weapon_preset(self.vhs_crew, crew_rifle_stats)
		end

		local old_init_data_hs2000_crew = WeaponTweakData._init_data_hs2000_crew
		function WeaponTweakData:_init_data_hs2000_crew()
			old_init_data_hs2000_crew(self)
			apply_crew_weapon_preset(self.hs2000_crew, crew_pistol_stats)
		end

		local old_init_data_cobray_crew = WeaponTweakData._init_data_cobray_crew
		function WeaponTweakData:_init_data_cobray_crew()
			old_init_data_cobray_crew(self)
			apply_crew_weapon_preset(self.cobray_crew, crew_smg_stats)
		end

		local old_init_data_b682_crew = WeaponTweakData._init_data_b682_crew
		function WeaponTweakData:_init_data_b682_crew()
			old_init_data_b682_crew(self)
			apply_crew_weapon_preset(self.b682_crew, crew_shotgun_double_stats)
		end

		local old_init_data_aa12_crew = WeaponTweakData._init_data_aa12_crew
		function WeaponTweakData:_init_data_aa12_crew()
			old_init_data_aa12_crew(self)
			apply_crew_weapon_preset(self.aa12_crew, crew_shotgun_mag_stats)
		end

		local old_init_data_peacemaker_crew = WeaponTweakData._init_data_peacemaker_crew
		function WeaponTweakData:_init_data_peacemaker_crew()
			old_init_data_peacemaker_crew(self)
			apply_crew_weapon_preset(self.peacemaker_crew, crew_revolver_stats)
		end

		local old_init_data_winchester1874_crew = WeaponTweakData._init_data_winchester1874_crew
		function WeaponTweakData:_init_data_winchester1874_crew()
			old_init_data_winchester1874_crew(self)
			apply_crew_weapon_preset(self.winchester1874_crew, crew_sniper_stats)
		end

		local old_init_data_sbl_crew = WeaponTweakData._init_data_sbl_crew
		function WeaponTweakData:_init_data_sbl_crew()
			old_init_data_sbl_crew(self)
			apply_crew_weapon_preset(self.sbl_crew, crew_sniper_stats)
		end

		local old_init_data_mateba_crew = WeaponTweakData._init_data_mateba_crew
		function WeaponTweakData:_init_data_mateba_crew()
			old_init_data_mateba_crew(self)
			apply_crew_weapon_preset(self.mateba_crew, crew_revolver_stats)
		end

		local old_init_data_asval_crew = WeaponTweakData._init_data_asval_crew
		function WeaponTweakData:_init_data_asval_crew()
			old_init_data_asval_crew(self)
			apply_crew_weapon_preset(self.asval_crew, crew_rifle_stats)
		end

		local old_init_data_sub2000_crew = WeaponTweakData._init_data_sub2000_crew
		function WeaponTweakData:_init_data_sub2000_crew()
			old_init_data_sub2000_crew(self)
			apply_crew_weapon_preset(self.sub2000_crew, crew_pistol_stats)
		end

		local old_init_data_wa2000_crew = WeaponTweakData._init_data_wa2000_crew
		function WeaponTweakData:_init_data_wa2000_crew()
			old_init_data_wa2000_crew(self)
			apply_crew_weapon_preset(self.wa2000_crew, crew_sniper_stats)
		end

		local old_init_data_polymer_crew = WeaponTweakData._init_data_polymer_crew
		function WeaponTweakData:_init_data_polymer_crew()
			old_init_data_polymer_crew(self)
			apply_crew_weapon_preset(self.polymer_crew, crew_smg_stats)
		end

		local old_init_data_baka_crew = WeaponTweakData._init_data_baka_crew
		function WeaponTweakData:_init_data_baka_crew()
			old_init_data_baka_crew(self)
			apply_crew_weapon_preset(self.baka_crew, crew_smg_stats)
		end

		local old_init_data_pm9_crew = WeaponTweakData._init_data_pm9_crew
		function WeaponTweakData:_init_data_pm9_crew()
			old_init_data_pm9_crew(self)
			apply_crew_weapon_preset(self.pm9_crew, crew_smg_stats)
		end

		local old_init_data_par_crew = WeaponTweakData._init_data_par_crew
		function WeaponTweakData:_init_data_par_crew()
			old_init_data_par_crew(self)
			apply_crew_weapon_preset(self.par_crew, crew_lmg_stats)
			apply_crew_weapon_preset(self.par_secondary_crew, crew_lmg_stats)
		end

		local old_init_data_sparrow_crew = WeaponTweakData._init_data_sparrow_crew
		function WeaponTweakData:_init_data_sparrow_crew()
			old_init_data_sparrow_crew(self)
			apply_crew_weapon_preset(self.sparrow_crew, crew_pistol_stats)
		end

		local old_init_data_model70_crew = WeaponTweakData._init_data_model70_crew
		function WeaponTweakData:_init_data_model70_crew()
			old_init_data_model70_crew(self)
			apply_crew_weapon_preset(self.model70_crew, crew_sniper_stats)
			apply_crew_weapon_preset(self.model70_secondary_crew, crew_sniper_stats)
		end

		local old_init_data_m37_crew = WeaponTweakData._init_data_m37_crew
		function WeaponTweakData:_init_data_m37_crew()
			old_init_data_m37_crew(self)
			apply_crew_weapon_preset(self.m37_crew, crew_shotgun_stats)
		end

		local old_init_data_m1897_crew = WeaponTweakData._init_data_m1897_crew
		function WeaponTweakData:_init_data_m1897_crew()
			old_init_data_m1897_crew(self)
			apply_crew_weapon_preset(self.m1897_crew, crew_shotgun_stats)
		end

		local old_init_data_sr2_crew = WeaponTweakData._init_data_sr2_crew
		function WeaponTweakData:_init_data_sr2_crew()
			old_init_data_sr2_crew(self)
			apply_crew_weapon_preset(self.sr2_crew, crew_smg_stats)
		end

		local old_init_data_pl14_crew = WeaponTweakData._init_data_pl14_crew
		function WeaponTweakData:_init_data_pl14_crew()
			old_init_data_pl14_crew(self)
			apply_crew_weapon_preset(self.pl14_crew, crew_pistol_stats)
		end

		local old_init_data_m1911_crew = WeaponTweakData._init_data_m1911_crew
		function WeaponTweakData:_init_data_m1911_crew()
			old_init_data_m1911_crew(self)
			apply_crew_weapon_preset(self.m1911_crew, crew_pistol_stats)
		end

		local old_init_data_m590_crew = WeaponTweakData._init_data_m590_crew
		function WeaponTweakData:_init_data_m590_crew()
			old_init_data_m590_crew(self)
			apply_crew_weapon_preset(self.m590_crew, crew_shotgun_stats)
		end

		local old_init_data_vityaz_crew = WeaponTweakData._init_data_vityaz_crew
		function WeaponTweakData:_init_data_vityaz_crew()
			old_init_data_vityaz_crew(self)
			apply_crew_weapon_preset(self.vityaz_crew, crew_smg_stats)
			apply_crew_weapon_preset(self.vityaz_primary_crew, crew_smg_stats)
		end

		local old_init_data_tecci_crew = WeaponTweakData._init_data_tecci_crew
		function WeaponTweakData:_init_data_tecci_crew()
			old_init_data_tecci_crew(self)
			apply_crew_weapon_preset(self.tecci_crew, crew_lmg_stats) --Lets be real here, this is more of an lmg-ish gun.
		end

		local old_init_data_hajk_crew = WeaponTweakData._init_data_hajk_crew
		function WeaponTweakData:_init_data_hajk_crew()
			old_init_data_hajk_crew(self)
			apply_crew_weapon_preset(self.hajk_crew, crew_rifle_stats)
		end

		local old_init_data_boot_crew = WeaponTweakData._init_data_boot_crew
		function WeaponTweakData:_init_data_boot_crew()
			old_init_data_boot_crew(self)
			apply_crew_weapon_preset(self.boot_crew, crew_shotgun_stats)
		end

		local old_init_data_packrat_crew = WeaponTweakData._init_data_packrat_crew
		function WeaponTweakData:_init_data_packrat_crew()
			old_init_data_packrat_crew(self)
			apply_crew_weapon_preset(self.packrat_crew, crew_pistol_stats)
		end

		local old_init_data_schakal_crew = WeaponTweakData._init_data_schakal_crew
		function WeaponTweakData:_init_data_schakal_crew()
			old_init_data_schakal_crew(self)
			apply_crew_weapon_preset(self.schakal_crew, crew_smg_stats)
		end

		local old_init_data_desertfox_crew = WeaponTweakData._init_data_desertfox_crew
		function WeaponTweakData:_init_data_desertfox_crew()
			old_init_data_desertfox_crew(self)
			apply_crew_weapon_preset(self.desertfox_crew, crew_sniper_stats)
			apply_crew_weapon_preset(self.desertfox_secondary_crew, crew_sniper_stats)
		end

		local old_init_data_rota_crew = WeaponTweakData._init_data_rota_crew
		function WeaponTweakData:_init_data_rota_crew()
			old_init_data_rota_crew(self)
			apply_crew_weapon_preset(self.rota_crew, crew_shotgun_stats)
		end

		local old_init_data_contraband_crew = WeaponTweakData._init_data_contraband_crew
		function WeaponTweakData:_init_data_contraband_crew()
			old_init_data_contraband_crew(self)
			apply_crew_weapon_preset(self.contraband_crew, crew_underbarrel_rifle_stats)
		end

		local old_init_data_tti_crew = WeaponTweakData._init_data_tti_crew
		function WeaponTweakData:_init_data_tti_crew()
			old_init_data_tti_crew(self)
			apply_crew_weapon_preset(self.tti_crew, crew_sniper_stats)
		end

		local old_init_data_siltstone_crew = WeaponTweakData._init_data_siltstone_crew
		function WeaponTweakData:_init_data_siltstone_crew()
			old_init_data_siltstone_crew(self)
			apply_crew_weapon_preset(self.siltstone_crew, crew_sniper_stats)
		end

		local old_init_data_flint_crew = WeaponTweakData._init_data_flint_crew
		function WeaponTweakData:_init_data_flint_crew()
			old_init_data_flint_crew(self)
			apply_crew_weapon_preset(self.flint_crew, crew_rifle_stats)
		end

		local old_init_data_coal_crew = WeaponTweakData._init_data_coal_crew
		function WeaponTweakData:_init_data_coal_crew()
			old_init_data_coal_crew(self)
			apply_crew_weapon_preset(self.coal_crew, crew_smg_stats)
		end

		local old_init_data_lemming_crew = WeaponTweakData._init_data_lemming_crew
		function WeaponTweakData:_init_data_lemming_crew()
			old_init_data_lemming_crew(self)
			apply_crew_weapon_preset(self.lemming_crew, crew_pistol_stats)
		end

		local old_init_data_chinchilla_crew = WeaponTweakData._init_data_chinchilla_crew
		function WeaponTweakData:_init_data_chinchilla_crew()
			old_init_data_chinchilla_crew(self)
			apply_crew_weapon_preset(self.chinchilla_crew, crew_revolver_stats)
		end

		local old_init_data_model3_crew = WeaponTweakData._init_data_model3_crew
		function WeaponTweakData:_init_data_model3_crew()
			old_init_data_model3_crew(self)
			apply_crew_weapon_preset(self.model3_crew, crew_revolver_stats)
		end

		local old_init_data_shepheard_crew = WeaponTweakData._init_data_shepheard_crew
		function WeaponTweakData:_init_data_shepheard_crew()
			old_init_data_shepheard_crew(self)
			apply_crew_weapon_preset(self.shepheard_crew, crew_smg_stats)
		end

		local old_init_data_breech_crew = WeaponTweakData._init_data_breech_crew
		function WeaponTweakData:_init_data_breech_crew()
			old_init_data_breech_crew(self)
			apply_crew_weapon_preset(self.breech_crew, crew_pistol_stats)
		end

		local old_init_data_ching_crew = WeaponTweakData._init_data_ching_crew
		function WeaponTweakData:_init_data_ching_crew()
			old_init_data_ching_crew(self)
			apply_crew_weapon_preset(self.ching_crew, crew_dmr_stats)
		end

		local old_init_data_erma_crew = WeaponTweakData._init_data_erma_crew
		function WeaponTweakData:_init_data_erma_crew()
			old_init_data_erma_crew(self)
			apply_crew_weapon_preset(self.erma_crew, crew_smg_stats)
		end

		local old_init_data_shrew_crew = WeaponTweakData._init_data_shrew_crew
		function WeaponTweakData:_init_data_shrew_crew()
			old_init_data_shrew_crew(self)
			apply_crew_weapon_preset(self.shrew_crew, crew_pistol_stats)
		end

		local old_init_data_qbu88_crew = WeaponTweakData._init_data_qbu88_crew
		function WeaponTweakData:_init_data_qbu88_crew()
			old_init_data_qbu88_crew(self)
			apply_crew_weapon_preset(self.qbu88_crew, crew_sniper_stats)
		end

		local old_init_data_groza_crew = WeaponTweakData._init_data_groza_crew
		function WeaponTweakData:_init_data_groza_crew()
			old_init_data_groza_crew(self)
			apply_crew_weapon_preset(self.groza_crew, crew_underbarrel_rifle_stats)
		end

		local old_init_data_basset_crew = WeaponTweakData._init_data_basset_crew
		function WeaponTweakData:_init_data_basset_crew()
			old_init_data_basset_crew(self)
			apply_crew_weapon_preset(self.basset_crew, crew_shotgun_mag_stats)
		end

		local old_init_data_corgi_crew = WeaponTweakData._init_data_corgi_crew
		function WeaponTweakData:_init_data_corgi_crew()
			old_init_data_corgi_crew(self)
			apply_crew_weapon_preset(self.corgi_crew, crew_rifle_stats)
		end

		local old_init_data_komodo_crew = WeaponTweakData._init_data_komodo_crew
		function WeaponTweakData:_init_data_komodo_crew()
			old_init_data_komodo_crew(self)
			apply_crew_weapon_preset(self.komodo_crew, crew_rifle_stats)
		end

		local old_init_data_legacy_crew = WeaponTweakData._init_data_legacy_crew
		function WeaponTweakData:_init_data_legacy_crew()
			old_init_data_legacy_crew(self)
			apply_crew_weapon_preset(self.legacy_crew, crew_pistol_stats)
		end

		local old_init_data_coach_crew = WeaponTweakData._init_data_coach_crew
		function WeaponTweakData:_init_data_coach_crew()
			old_init_data_coach_crew(self)
			apply_crew_weapon_preset(self.coach_crew, crew_shotgun_double_stats)
		end

		local old_init_data_beer_crew = WeaponTweakData._init_data_beer_crew
		function WeaponTweakData:_init_data_beer_crew()
			old_init_data_beer_crew(self)
			apply_crew_weapon_preset(self.beer_crew, crew_smg_stats) --Closer to an SMG.
		end

		local old_init_data_czech_crew = WeaponTweakData._init_data_czech_crew
		function WeaponTweakData:_init_data_czech_crew()
			old_init_data_czech_crew(self)
			apply_crew_weapon_preset(self.czech_crew, crew_smg_stats)
		end

		local old_init_data_stech_crew = WeaponTweakData._init_data_stech_crew
		function WeaponTweakData:_init_data_stech_crew()
			old_init_data_stech_crew(self)
			apply_crew_weapon_preset(self.stech_crew, crew_smg_stats)
		end

		local old_init_data_holt_crew = WeaponTweakData._init_data_holt_crew
		function WeaponTweakData:_init_data_holt_crew()
			old_init_data_holt_crew(self)
			apply_crew_weapon_preset(self.holt_crew, crew_pistol_stats)
		end

		local old_init_data_m60_crew = WeaponTweakData._init_data_m60_crew
		function WeaponTweakData:_init_data_m60_crew()
			old_init_data_m60_crew(self)
			apply_crew_weapon_preset(self.m60_crew, crew_lmg_stats)
		end

		local old_init_data_r700_crew = WeaponTweakData._init_data_r700_crew
		function WeaponTweakData:_init_data_r700_crew()
			old_init_data_r700_crew(self)
			apply_crew_weapon_preset(self.r700_crew, crew_sniper_stats)
		end

--Sentry guns + Difficulty settings.
	function WeaponTweakData:_init_data_sentry_gun_npc()
		self.sentry_gun.categories = {}
		self.sentry_gun.name_id = "debug_sentry_gun"
		self.sentry_gun.DAMAGE = 3
		self.sentry_gun.SUPPRESSION = 1
		self.sentry_gun.SPREAD = 2
		self.sentry_gun.FIRE_RANGE = 2500
		self.sentry_gun.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
		self.sentry_gun.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
		self.sentry_gun.auto.fire_rate = 0.175
		self.sentry_gun.alert_size = 2500
		self.sentry_gun.BAG_DMG_MUL = 0.25
		self.sentry_gun.SHIELD_DMG_MUL = 0
		self.sentry_gun.DEATH_VERIFICATION = {0.4, 0.75}
		self.sentry_gun.DETECTION_RANGE = self.sentry_gun.FIRE_RANGE
		self.sentry_gun.KEEP_FIRE_ANGLE = 0.8
		self.sentry_gun.DETECTION_DELAY = {
			{600, 0.1},
			{
				self.sentry_gun.DETECTION_RANGE,
				0.5
			}
		}
		self.sentry_gun.MAX_VEL_SPIN = 120
		self.sentry_gun.MIN_VEL_SPIN = self.sentry_gun.MAX_VEL_SPIN * 0.05
		self.sentry_gun.SLOWDOWN_ANGLE_SPIN = 30
		self.sentry_gun.ACC_SPIN = self.sentry_gun.MAX_VEL_SPIN * 5
		self.sentry_gun.MAX_VEL_PITCH = 100
		self.sentry_gun.MIN_VEL_PITCH = self.sentry_gun.MAX_VEL_PITCH * 0.05
		self.sentry_gun.SLOWDOWN_ANGLE_PITCH = 20
		self.sentry_gun.ACC_PITCH = self.sentry_gun.MAX_VEL_PITCH * 5
		self.sentry_gun.recoil = {}
		self.sentry_gun.recoil.horizontal = {
			2,
			3,
			0,
			3
		}
		self.sentry_gun.recoil.vertical = {
			1,
			2,
			0,
			4
		}
		self.sentry_gun.challenges = {}
		self.sentry_gun.challenges.group = "sentry_gun"
		self.sentry_gun.challenges.weapon = "sentry_gun"
		self.sentry_gun.suppression = 0.8
	end

	function WeaponTweakData:_set_normal()
	end

	function WeaponTweakData:_set_hard()
	end

	function WeaponTweakData:_set_overkill()
	end

	function WeaponTweakData:_set_overkill_145()
		if job == "chew" or job == "glace" then
			self.swat_van_turret_module.HEALTH_INIT = 675
			self.swat_van_turret_module.SHIELD_HEALTH_INIT = 90
			self.swat_van_turret_module.AUTO_REPAIR = false
		else
			self.swat_van_turret_module.HEALTH_INIT = 1350
			self.swat_van_turret_module.SHIELD_HEALTH_INIT = 180
			self.swat_van_turret_module.AUTO_REPAIR = true
		end

		self.ceiling_turret_module.HEALTH_INIT = 675
		self.ceiling_turret_module.SHIELD_HEALTH_INIT = 90
		self.ceiling_turret_module_no_idle.HEALTH_INIT = 675
		self.ceiling_turret_module_no_idle.SHIELD_HEALTH_INIT = 90
		self.ceiling_turret_module_longer_range.HEALTH_INIT = 675
		self.ceiling_turret_module_longer_range.SHIELD_HEALTH_INIT = 90
		self.aa_turret_module.HEALTH_INIT = 675
		self.aa_turret_module.SHIELD_HEALTH_INIT = 90
		self.crate_turret_module.HEALTH_INIT = 337.5
		self.crate_turret_module.SHIELD_HEALTH_INIT = 45
	end

	function WeaponTweakData:_set_easy_wish()
		if job == "chew" or job == "glace" then
			self.swat_van_turret_module.HEALTH_INIT = 787.5
			self.swat_van_turret_module.SHIELD_HEALTH_INIT = 105
			self.swat_van_turret_module.AUTO_REPAIR = false
		else
			self.swat_van_turret_module.HEALTH_INIT = 1575
			self.swat_van_turret_module.SHIELD_HEALTH_INIT = 210
			self.swat_van_turret_module.AUTO_REPAIR = true
		end
		self.swat_van_turret_module.BAG_DMG_MUL = 10

		self.ceiling_turret_module.HEALTH_INIT = 787.5
		self.ceiling_turret_module.BAG_DMG_MUL = 10
		self.ceiling_turret_module.SHIELD_HEALTH_INIT = 105
		self.ceiling_turret_module_no_idle.HEALTH_INIT = 787.5
		self.ceiling_turret_module_no_idle.BAG_DMG_MUL = 10
		self.ceiling_turret_module_no_idle.SHIELD_HEALTH_INIT = 105
		self.ceiling_turret_module_longer_range.HEALTH_INIT = 787.5
		self.ceiling_turret_module_longer_range.BAG_DMG_MUL = 10
		self.ceiling_turret_module_longer_range.SHIELD_HEALTH_INIT = 105
		self.aa_turret_module.HEALTH_INIT = 787.5
		self.aa_turret_module.BAG_DMG_MUL = 10
		self.aa_turret_module.SHIELD_HEALTH_INIT = 105
		self.crate_turret_module.HEALTH_INIT = 393.75
		self.crate_turret_module.BAG_DMG_MUL = 10
		self.crate_turret_module.SHIELD_HEALTH_INIT = 52.5
	end

	function WeaponTweakData:_set_overkill_290()
		if job == "chew" or job == "glace" then
			self.swat_van_turret_module.HEALTH_INIT = 787.5
			self.swat_van_turret_module.SHIELD_HEALTH_INIT = 105
			self.swat_van_turret_module.AUTO_REPAIR = false
		else
			self.swat_van_turret_module.HEALTH_INIT = 1575
			self.swat_van_turret_module.SHIELD_HEALTH_INIT = 210
			self.swat_van_turret_module.AUTO_REPAIR = true
		end
		self.swat_van_turret_module.BAG_DMG_MUL = 10

		self.ceiling_turret_module.HEALTH_INIT = 787.5
		self.ceiling_turret_module.BAG_DMG_MUL = 10
		self.ceiling_turret_module.SHIELD_HEALTH_INIT = 105
		self.ceiling_turret_module_no_idle.HEALTH_INIT = 787.5
		self.ceiling_turret_module_no_idle.BAG_DMG_MUL = 10
		self.ceiling_turret_module_no_idle.SHIELD_HEALTH_INIT = 105
		self.ceiling_turret_module_longer_range.HEALTH_INIT = 787.5
		self.ceiling_turret_module_longer_range.BAG_DMG_MUL = 10
		self.ceiling_turret_module_longer_range.SHIELD_HEALTH_INIT = 105
		self.aa_turret_module.HEALTH_INIT = 787.5
		self.aa_turret_module.BAG_DMG_MUL = 10
		self.aa_turret_module.SHIELD_HEALTH_INIT = 105
		self.crate_turret_module.HEALTH_INIT = 393.75
		self.crate_turret_module.BAG_DMG_MUL = 10
		self.crate_turret_module.SHIELD_HEALTH_INIT = 52.5

		--Sniper Trail for Snipers
		self.m14_sniper_npc.sniper_trail = true
	end

	function WeaponTweakData:_set_sm_wish()
		if job == "chew" or job == "glace" then
			self.swat_van_turret_module.HEALTH_INIT = 900
			self.swat_van_turret_module.SHIELD_HEALTH_INIT = 105
			self.swat_van_turret_module.AUTO_REPAIR = false
		else
			self.swat_van_turret_module.HEALTH_INIT = 1800
			self.swat_van_turret_module.SHIELD_HEALTH_INIT = 210
			self.swat_van_turret_module.AUTO_REPAIR = true
		end

		self.swat_van_turret_module.BAG_DMG_MUL = 11.4375

		self.ceiling_turret_module.HEALTH_INIT = 900
		self.ceiling_turret_module.BAG_DMG_MUL = 11.4375
		self.ceiling_turret_module.SHIELD_HEALTH_INIT = 105

		self.ceiling_turret_module_no_idle.HEALTH_INIT = 900
		self.ceiling_turret_module_no_idle.BAG_DMG_MUL = 11.4375
		self.ceiling_turret_module_no_idle.SHIELD_HEALTH_INIT = 105

		self.ceiling_turret_module_longer_range.HEALTH_INIT = 900
		self.ceiling_turret_module_longer_range.BAG_DMG_MUL = 11.4375
		self.ceiling_turret_module_longer_range.SHIELD_HEALTH_INIT = 105

		self.aa_turret_module.HEALTH_INIT = 900
		self.aa_turret_module.BAG_DMG_MUL = 11.4375
		self.aa_turret_module.SHIELD_HEALTH_INIT = 105

		self.crate_turret_module.HEALTH_INIT = 900
		self.crate_turret_module.BAG_DMG_MUL = 11.4375
		self.crate_turret_module.SHIELD_HEALTH_INIT = 52.5

		self.swat_van_turret_module.AUTO_REPAIR_MAX_COUNT = 3
		self.ceiling_turret_module.AUTO_REPAIR_MAX_COUNT = 3
		self.ceiling_turret_module_no_idle.AUTO_REPAIR_MAX_COUNT = 3
		self.aa_turret_module.AUTO_REPAIR_MAX_COUNT = 3

		--Sniper Trail for Snipers
		self.m14_sniper_npc.sniper_trail = true
	end

	function WeaponTweakData:_init_data_swat_van_turret_module_npc()
		self.swat_van_turret_module.name_id = "debug_sentry_gun"
		self.swat_van_turret_module.DAMAGE = 2
		self.swat_van_turret_module.DAMAGE_MUL_RANGE = {
			{1000, 1},
			{2000, 1},
			{3000, 1}
		}
		self.swat_van_turret_module.SUPPRESSION = 1
		self.swat_van_turret_module.SPREAD = 3
		self.swat_van_turret_module.FIRE_RANGE = 4000
		self.swat_van_turret_module.CLIP_SIZE = 200
		self.swat_van_turret_module.AUTO_RELOAD = true
		self.swat_van_turret_module.AUTO_RELOAD_DURATION = 8
		self.swat_van_turret_module.CAN_GO_IDLE = true
		self.swat_van_turret_module.IDLE_WAIT_TIME = 5
		self.swat_van_turret_module.AUTO_REPAIR_MAX_COUNT = 2
		self.swat_van_turret_module.AUTO_REPAIR_DURATION = 120
		self.swat_van_turret_module.ECM_HACKABLE = true
		self.swat_van_turret_module.FLASH_GRENADE = {
			range = 300,
			effect_duration = 6,
			chance = 1,
			check_interval = {1, 1},
			quiet_time = {10, 13}
		}
		self.swat_van_turret_module.HACKABLE_WITH_ECM = true
		self.swat_van_turret_module.VELOCITY_COMPENSATION = {SNAPSHOT_INTERVAL = 0.3, OVERCOMPENSATION = 50}
		self.swat_van_turret_module.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
		self.swat_van_turret_module.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
		self.swat_van_turret_module.auto.fire_rate = 0.13333333333
		self.swat_van_turret_module.alert_size = 2500
		self.swat_van_turret_module.headshot_dmg_mul = 1
		self.swat_van_turret_module.EXPLOSION_DMG_MUL = 3
		self.swat_van_turret_module.FIRE_DMG_MUL = 1
		self.swat_van_turret_module.BAG_DMG_MUL = 12.5
		self.swat_van_turret_module.SHIELD_DMG_MUL = 1
		if job == "chew" or job == "glace" then
			self.swat_van_turret_module.HEALTH_INIT = 450
			self.swat_van_turret_module.SHIELD_HEALTH_INIT = 60
			self.swat_van_turret_module.AUTO_REPAIR = false
		else
			self.swat_van_turret_module.HEALTH_INIT = 900
			self.swat_van_turret_module.SHIELD_HEALTH_INIT = 120
			self.swat_van_turret_module.AUTO_REPAIR = true
		end
		self.swat_van_turret_module.DEATH_VERIFICATION = {0.4, 0.75}
		self.swat_van_turret_module.DETECTION_RANGE = self.swat_van_turret_module.FIRE_RANGE
		self.swat_van_turret_module.DETECTION_DELAY = {
			{900, 0.3},
			{3500, 1.5}
		}
		self.swat_van_turret_module.KEEP_FIRE_ANGLE = 0.9
		self.swat_van_turret_module.MAX_VEL_SPIN = 72
		self.swat_van_turret_module.MIN_VEL_SPIN = self.swat_van_turret_module.MAX_VEL_SPIN * 0.05
		self.swat_van_turret_module.SLOWDOWN_ANGLE_SPIN = 30
		self.swat_van_turret_module.ACC_SPIN = self.swat_van_turret_module.MAX_VEL_SPIN * 5
		self.swat_van_turret_module.MAX_VEL_PITCH = 60
		self.swat_van_turret_module.MIN_VEL_PITCH = self.swat_van_turret_module.MAX_VEL_PITCH * 0.05
		self.swat_van_turret_module.SLOWDOWN_ANGLE_PITCH = 20
		self.swat_van_turret_module.ACC_PITCH = self.swat_van_turret_module.MAX_VEL_PITCH * 5
		self.swat_van_turret_module.recoil = {}
		self.swat_van_turret_module.recoil.horizontal = {
			1,
			1.5,
			1,
			1
		}
		self.swat_van_turret_module.recoil.vertical = {
			1,
			1.5,
			1,
			1
		}
		self.swat_van_turret_module.challenges = {}
		self.swat_van_turret_module.challenges.group = "sentry_gun"
		self.swat_van_turret_module.challenges.weapon = "sentry_gun"
		self.swat_van_turret_module.suppression = 1
	end

	function WeaponTweakData:_init_data_crate_turret_module_npc()
		self.crate_turret_module.name_id = "debug_sentry_gun"
		self.crate_turret_module.DAMAGE = 2
		self.crate_turret_module.DAMAGE_MUL_RANGE = {
			{1000, 1},
			{2000, 1},
			{3000, 1}
		}
		self.crate_turret_module.SUPPRESSION = 1
		self.crate_turret_module.SPREAD = 3
		self.crate_turret_module.FIRE_RANGE = 4000
		self.crate_turret_module.DETECTION_RANGE = self.crate_turret_module.FIRE_RANGE
		self.crate_turret_module.CLIP_SIZE = 200
		self.crate_turret_module.AUTO_RELOAD = true
		self.crate_turret_module.AUTO_RELOAD_DURATION = 8
		self.crate_turret_module.CAN_GO_IDLE = false
		self.crate_turret_module.IDLE_WAIT_TIME = 5
		self.crate_turret_module.AUTO_REPAIR = false
		self.crate_turret_module.AUTO_REPAIR_MAX_COUNT = math.huge
		self.crate_turret_module.AUTO_REPAIR_DURATION = 120
		self.crate_turret_module.ECM_HACKABLE = true
		self.crate_turret_module.HACKABLE_WITH_ECM = true
		self.crate_turret_module.VELOCITY_COMPENSATION = {
			OVERCOMPENSATION = 50,
			SNAPSHOT_INTERVAL = 0.3
		}
		self.crate_turret_module.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
		self.crate_turret_module.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
		self.crate_turret_module.auto.fire_rate = 0.06
		self.crate_turret_module.alert_size = 2500
		self.crate_turret_module.headshot_dmg_mul = 1
		self.crate_turret_module.EXPLOSION_DMG_MUL = 3
		self.crate_turret_module.FIRE_DMG_MUL = 1
		self.crate_turret_module.BAG_DMG_MUL = 12.5
		self.crate_turret_module.SHIELD_DMG_MUL = 1
		self.crate_turret_module.HEALTH_INIT = 225
		self.crate_turret_module.SHIELD_HEALTH_INIT = 30
		self.crate_turret_module.DEATH_VERIFICATION = {
			0.4,
			0.75
		}
		self.crate_turret_module.DETECTION_RANGE = 8000
		self.crate_turret_module.DETECTION_DELAY = {
			{
				900,
				0.3
			},
			{
				3500,
				1.5
			}
		}
		self.crate_turret_module.KEEP_FIRE_ANGLE = 0.9
		self.crate_turret_module.MAX_VEL_SPIN = 72
		self.crate_turret_module.MIN_VEL_SPIN = self.crate_turret_module.MAX_VEL_SPIN * 0.05
		self.crate_turret_module.SLOWDOWN_ANGLE_SPIN = 30
		self.crate_turret_module.ACC_SPIN = self.crate_turret_module.MAX_VEL_SPIN * 5
		self.crate_turret_module.MAX_VEL_PITCH = 60
		self.crate_turret_module.MIN_VEL_PITCH = self.crate_turret_module.MAX_VEL_PITCH * 0.05
		self.crate_turret_module.SLOWDOWN_ANGLE_PITCH = 20
		self.crate_turret_module.ACC_PITCH = self.crate_turret_module.MAX_VEL_PITCH * 5
		self.crate_turret_module.recoil = {
			horizontal = {
				1,
				1.5,
				1,
				1
			},
			vertical = {
				1,
				1.5,
				1,
				1
			}
		}
		self.crate_turret_module.challenges = {
			group = "sentry_gun",
			weapon = "sentry_gun"
		}
		self.crate_turret_module.suppression = 0.8
	end

	function WeaponTweakData:_init_data_ceiling_turret_module_npc()
		self.ceiling_turret_module.name_id = "debug_sentry_gun"
		self.ceiling_turret_module.DAMAGE = 2
		self.ceiling_turret_module.DAMAGE_MUL_RANGE = {
			{1000, 1},
			{2000, 1},
			{3000, 1}
		}
		self.ceiling_turret_module.SUPPRESSION = 1
		self.ceiling_turret_module.SPREAD = 3
		self.ceiling_turret_module.FIRE_RANGE = 4000
		self.ceiling_turret_module.CLIP_SIZE = 200
		self.ceiling_turret_module.AUTO_RELOAD = true
		self.ceiling_turret_module.AUTO_RELOAD_DURATION = 8
		self.ceiling_turret_module.CAN_GO_IDLE = false
		self.ceiling_turret_module.IDLE_WAIT_TIME = 5
		self.ceiling_turret_module.AUTO_REPAIR = false
		self.ceiling_turret_module.AUTO_REPAIR_MAX_COUNT = 2
		self.ceiling_turret_module.AUTO_REPAIR_DURATION = 120
		self.ceiling_turret_module.ECM_HACKABLE = true
		self.ceiling_turret_module.FLASH_GRENADE = {
			range = 300,
			effect_duration = 6,
			chance = 1,
			check_interval = {1, 1},
			quiet_time = {10, 13}
		}
		self.ceiling_turret_module.HACKABLE_WITH_ECM = true
		self.ceiling_turret_module.VELOCITY_COMPENSATION = {SNAPSHOT_INTERVAL = 0.3, OVERCOMPENSATION = 50}
		self.ceiling_turret_module.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
		self.ceiling_turret_module.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
		self.ceiling_turret_module.auto.fire_rate = 0.13333333333
		self.ceiling_turret_module.alert_size = 2500
		self.ceiling_turret_module.headshot_dmg_mul = 1
		self.ceiling_turret_module.EXPLOSION_DMG_MUL = 3
		self.ceiling_turret_module.FIRE_DMG_MUL = 1
		self.ceiling_turret_module.BAG_DMG_MUL = 12.5
		self.ceiling_turret_module.SHIELD_DMG_MUL = 1
		self.ceiling_turret_module.HEALTH_INIT = 450
		self.ceiling_turret_module.SHIELD_HEALTH_INIT = 60
		self.ceiling_turret_module.DEATH_VERIFICATION = {0.4, 0.75}
		self.ceiling_turret_module.DETECTION_RANGE = self.ceiling_turret_module.FIRE_RANGE
		self.ceiling_turret_module.DETECTION_DELAY = {
			{900, 0.3},
			{3500, 1.5}
		}
		self.ceiling_turret_module.KEEP_FIRE_ANGLE = 0.9
		self.ceiling_turret_module.MAX_VEL_SPIN = 72
		self.ceiling_turret_module.MIN_VEL_SPIN = self.ceiling_turret_module.MAX_VEL_SPIN * 0.05
		self.ceiling_turret_module.SLOWDOWN_ANGLE_SPIN = 30
		self.ceiling_turret_module.ACC_SPIN = self.ceiling_turret_module.MAX_VEL_SPIN * 5
		self.ceiling_turret_module.MAX_VEL_PITCH = 60
		self.ceiling_turret_module.MIN_VEL_PITCH = self.ceiling_turret_module.MAX_VEL_PITCH * 0.05
		self.ceiling_turret_module.SLOWDOWN_ANGLE_PITCH = 20
		self.ceiling_turret_module.ACC_PITCH = self.ceiling_turret_module.MAX_VEL_PITCH * 5
		self.ceiling_turret_module.recoil = {}
		self.ceiling_turret_module.recoil.horizontal = {
			1,
			1.5,
			1,
			1
		}
		self.ceiling_turret_module.recoil.vertical = {
			1,
			1.5,
			1,
			1
		}
		self.ceiling_turret_module.challenges = {}
		self.ceiling_turret_module.challenges.group = "sentry_gun"
		self.ceiling_turret_module.challenges.weapon = "sentry_gun"
		self.ceiling_turret_module.suppression = 1
		self.ceiling_turret_module_no_idle = deep_clone(self.ceiling_turret_module)
		self.ceiling_turret_module_no_idle.CAN_GO_IDLE = false
		self.ceiling_turret_module_longer_range = deep_clone(self.ceiling_turret_module)
		self.ceiling_turret_module_longer_range.CAN_GO_IDLE = false
		self.ceiling_turret_module_longer_range.FIRE_RANGE = 30000
		self.ceiling_turret_module_longer_range.DETECTION_RANGE = self.ceiling_turret_module_longer_range.FIRE_RANGE
	end

	function WeaponTweakData:_init_data_aa_turret_module_npc()
		self.aa_turret_module.name_id = "debug_sentry_gun"
		self.aa_turret_module.DAMAGE = 2
		self.aa_turret_module.DAMAGE_MUL_RANGE = {
			{1000, 1},
			{2000, 1},
			{3000, 1}
		}
		self.aa_turret_module.SUPPRESSION = 1
		self.aa_turret_module.SPREAD = 3
		self.aa_turret_module.FIRE_RANGE = 4000
		self.aa_turret_module.CLIP_SIZE = 200
		self.aa_turret_module.AUTO_RELOAD = true
		self.aa_turret_module.AUTO_RELOAD_DURATION = 8
		self.aa_turret_module.CAN_GO_IDLE = false
		self.aa_turret_module.IDLE_WAIT_TIME = 5
		self.aa_turret_module.AUTO_REPAIR = true
		self.aa_turret_module.AUTO_REPAIR_MAX_COUNT = math.huge
		self.aa_turret_module.AUTO_REPAIR_DURATION = 120
		self.aa_turret_module.ECM_HACKABLE = true
		self.aa_turret_module.FLASH_GRENADE = {
			range = 300,
			effect_duration = 6,
			chance = 1,
			check_interval = {1, 1},
			quiet_time = {10, 13}
		}
		self.aa_turret_module.HACKABLE_WITH_ECM = true
		self.aa_turret_module.VELOCITY_COMPENSATION = {SNAPSHOT_INTERVAL = 0.3, OVERCOMPENSATION = 50}
		self.aa_turret_module.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
		self.aa_turret_module.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
		self.aa_turret_module.auto.fire_rate = 0.13333333333
		self.aa_turret_module.alert_size = 2500
		self.aa_turret_module.headshot_dmg_mul = 1
		self.aa_turret_module.EXPLOSION_DMG_MUL = 3
		self.aa_turret_module.FIRE_DMG_MUL = 1
		self.aa_turret_module.BAG_DMG_MUL = 12.5
		self.aa_turret_module.SHIELD_DMG_MUL = 1
		self.aa_turret_module.HEALTH_INIT = 450
		self.aa_turret_module.SHIELD_HEALTH_INIT = 60
		self.aa_turret_module.DEATH_VERIFICATION = {0.4, 0.75}
		self.aa_turret_module.DETECTION_RANGE = self.aa_turret_module.FIRE_RANGE
		self.aa_turret_module.DETECTION_DELAY = {
			{900, 0.3},
			{3500, 1.5}
		}
		self.aa_turret_module.KEEP_FIRE_ANGLE = 0.9
		self.aa_turret_module.MAX_VEL_SPIN = 72
		self.aa_turret_module.MIN_VEL_SPIN = self.aa_turret_module.MAX_VEL_SPIN * 0.05
		self.aa_turret_module.SLOWDOWN_ANGLE_SPIN = 30
		self.aa_turret_module.ACC_SPIN = self.aa_turret_module.MAX_VEL_SPIN * 5
		self.aa_turret_module.MAX_VEL_PITCH = 60
		self.aa_turret_module.MIN_VEL_PITCH = self.aa_turret_module.MAX_VEL_PITCH * 0.05
		self.aa_turret_module.SLOWDOWN_ANGLE_PITCH = 20
		self.aa_turret_module.ACC_PITCH = self.aa_turret_module.MAX_VEL_PITCH * 5
		self.aa_turret_module.recoil = {}
		self.aa_turret_module.recoil.horizontal = {
			1,
			1.5,
			1,
			1
		}
		self.aa_turret_module.recoil.vertical = {
			1,
			1.5,
			1,
			1
		}
		self.aa_turret_module.challenges = {}
		self.aa_turret_module.challenges.group = "sentry_gun"
		self.aa_turret_module.challenges.weapon = "sentry_gun"
		self.aa_turret_module.suppression = 1
	end

--Enemy guns
	function WeaponTweakData:_init_data_npc_melee()
		self.npc_melee = {}

		--Police Baton
		self.npc_melee.baton = {}
		self.npc_melee.baton.unit_name = Idstring("units/payday2/characters/ene_acc_baton/ene_acc_baton")
		self.npc_melee.baton.damage = 6
		self.npc_melee.baton.animation_param = "melee_baton"
		self.npc_melee.baton.player_blood_effect = true

		--KABAR knife
		self.npc_melee.knife_1 = {}
		self.npc_melee.knife_1.unit_name = Idstring("units/payday2/characters/ene_acc_knife_1/ene_acc_knife_1")
		self.npc_melee.knife_1.damage = 6
		self.npc_melee.knife_1.animation_param = "melee_knife"
		self.npc_melee.knife_1.player_blood_effect = true

		--Fists
		self.npc_melee.fists = {}
		self.npc_melee.fists.unit_name = nil
		self.npc_melee.fists.damage = 6
		self.npc_melee.fists.animation_param = "melee_fist"
		self.npc_melee.fists.player_blood_effect = true

		--Dozer Fists
		self.npc_melee.fists_dozer = {}
		self.npc_melee.fists_dozer.unit_name = nil
		self.npc_melee.fists_dozer.damage = 12
		self.npc_melee.fists_dozer.push_mul = 3
		self.npc_melee.fists_dozer.animation_param = "melee_fist"
		self.npc_melee.fists_dozer.player_blood_effect = true
		self.npc_melee.fists_dozer.armor_piercing = true

		--Halloween Dozer Hammer
		self.npc_melee.helloween = {}
		self.npc_melee.helloween.unit_name = Idstring("units/pd2_halloween/weapons/wpn_mel_titan_hammer/wpn_mel_titan_hammer")
		self.npc_melee.helloween.damage = 12
		self.npc_melee.fists_dozer.push_mul = 3
		self.npc_melee.helloween.animation_param = "melee_fireaxe"
		self.npc_melee.helloween.player_blood_effect = true
		self.npc_melee.helloween.armor_piercing = true

		--Halloween Dozer Sword
		self.npc_melee.helloween_sword = {}
		self.npc_melee.helloween_sword.unit_name = Idstring("units/payday2/weapons/wpn_mel_hw_sword/wpn_mel_hw_sword")
		self.npc_melee.helloween_sword.damage = 12
		self.npc_melee.fists_dozer.push_mul = 3
		self.npc_melee.helloween_sword.animation_param = "melee_fireaxe"
		self.npc_melee.helloween_sword.player_blood_effect = true
		self.npc_melee.helloween_sword.armor_piercing = true

		--Halloween Dozer Axe
		self.npc_melee.helloween_axe = {}
		self.npc_melee.helloween_axe.unit_name = Idstring("units/pd2_mod_halloween/weapons/wpn_mel_hw_axe/wpn_mel_hw_axe")
		self.npc_melee.helloween_axe.damage = 12
		self.npc_melee.fists_dozer.push_mul = 3
		self.npc_melee.helloween_axe.animation_param = "melee_fireaxe"
		self.npc_melee.helloween_axe.player_blood_effect = true
		self.npc_melee.helloween_axe.armor_piercing = true

		--Summers' Buzzer
		self.npc_melee.buzzer_summer = {}
		self.npc_melee.buzzer_summer.unit_name = Idstring("units/pd2_dlc_vip/characters/ene_acc_buzzer_1/ene_acc_buzzer_1")
		self.npc_melee.buzzer_summer.damage = 6
		self.npc_melee.buzzer_summer.animation_param = "melee_freedom"
		self.npc_melee.buzzer_summer.player_blood_effect = true
	end

	function WeaponTweakData:_init_data_c45_npc()
		self.c45_npc.categories = {"pistol"}
		self.c45_npc.sounds.prefix = "g17_npc"
		self.c45_npc.use_data.selection_index = 1
		self.c45_npc.DAMAGE = 4
		self.c45_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
		self.c45_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
		self.c45_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
		self.c45_npc.CLIP_AMMO_MAX = 17
		self.c45_npc.NR_CLIPS_MAX = 5
		self.c45_npc.hold = "pistol"
		self.c45_npc.alert_size = 2500
		self.c45_npc.suppression = 2.4
		self.c45_npc.FIRE_MODE = "single"

		self.colt_1911_primary_npc = deep_clone(self.c45_npc)
		self.colt_1911_primary_npc.use_data.selection_index = 2
		self.colt_1911_primary_npc.CLIP_AMMO_MAX = 8
		self.colt_1911_primary_npc.sounds.prefix = "c45_fire"
		self.colt_1911_primary_npc.damage = 4

		self.m1911_npc = deep_clone(self.c45_npc)
		self.m1911_npc.use_data.selection_index = 2
		self.m1911_npc.CLIP_AMMO_MAX = 8

		self.white_streak_npc = deep_clone(self.c45_npc)
		self.white_streak_npc.sounds.prefix = "pl14_npc"
		self.m1911_npc.use_data.selection_index = 2
		self.m1911_npc.CLIP_AMMO_MAX = 8
	end

	function WeaponTweakData:_init_data_x_c45_npc()
		self.x_c45_npc.categories = {
			"akimbo",
			"pistol"
		}
		self.x_c45_npc.sounds.prefix = "g17_npc"
		self.x_c45_npc.use_data.selection_index = 1
		self.x_c45_npc.DAMAGE = 4
		self.x_c45_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
		self.x_c45_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
		self.x_c45_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
		self.x_c45_npc.CLIP_AMMO_MAX = 34
		self.x_c45_npc.NR_CLIPS_MAX = 5
		self.x_c45_npc.hold = "akimbo_pistol"
		self.x_c45_npc.alert_size = 2500
		self.x_c45_npc.suppression = 2.4
		self.x_c45_npc.FIRE_MODE = "single"
		self.x_c45_npc.usage = "is_akimbo_pistol"
	end

	function WeaponTweakData:_init_data_beretta92_npc()
		self.beretta92_npc.categories = clone(self.b92fs.categories)
		self.beretta92_npc.sounds.prefix = "beretta_npc"
		self.beretta92_npc.use_data.selection_index = 1
		self.beretta92_npc.DAMAGE = 4
		self.beretta92_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
		self.beretta92_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
		self.beretta92_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
		self.beretta92_npc.CLIP_AMMO_MAX = 30
		self.beretta92_npc.NR_CLIPS_MAX = 4
		self.beretta92_npc.hold = "pistol"
		self.beretta92_npc.alert_size = 0
		self.beretta92_npc.suppression = 0.1
		self.beretta92_npc.FIRE_MODE = "single"
		self.beretta92_npc.has_suppressor = "suppressed_a"
		self.beretta92_primary_npc = deep_clone(self.beretta92_npc)
		self.beretta92_primary_npc.use_data.selection_index = 2

		self.socom_npc = deep_clone(self.beretta92_npc)
		self.socom_npc.sounds.prefix = "usp45_npc"
		self.socom_npc.has_suppressor = "suppressed_a"
		self.socom_npc.alert_size = 0
		self.socom_npc.suppression = 0.1
	end

	function WeaponTweakData:_init_data_raging_bull_npc()
		self.raging_bull_npc.categories = clone(self.new_raging_bull.categories)
		self.raging_bull_npc.sounds.prefix = "rbull_npc"
		self.raging_bull_npc.use_data.selection_index = 1
		self.raging_bull_npc.DAMAGE = 10.5
		self.raging_bull_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
		self.raging_bull_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
		self.raging_bull_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
		self.raging_bull_npc.CLIP_AMMO_MAX = 6
		self.raging_bull_npc.NR_CLIPS_MAX = 8
		self.raging_bull_npc.hold = "pistol"
		self.raging_bull_npc.alert_size = 2500
		self.raging_bull_npc.suppression = 3.2
		self.raging_bull_npc.FIRE_MODE = "single"

		self.deagle_npc = deep_clone(self.raging_bull_npc)
		self.deagle_npc.CLIP_AMMO_MAX = 8
		self.deagle_npc.anim_usage = "is_pistol"
		self.deagle_npc.hold = "pistol"
		self.deagle_npc.reload = "pistol"
		self.deagle_npc.sounds.prefix = "deagle_npc"
		self.deagle_npc.DAMAGE = 8
		self.deagle_npc.fire_rate_multiplier = 1.3

		self.peacemaker_npc = deep_clone(self.raging_bull_npc)
		self.peacemaker_npc.sounds.prefix = "peacemaker_npc"

		self.raging_bull_primary_npc = deep_clone(self.raging_bull_npc)
		self.raging_bull_primary_npc.use_data.selection_index = 2

		self.x_raging_bull_npc = deep_clone(self.raging_bull_npc)
		self.x_raging_bull_npc.categories = clone(self.x_rage.categories)
		self.x_raging_bull_npc.use_data.selection_index = 1
		self.x_raging_bull_npc.CLIP_AMMO_MAX = 12
		self.x_raging_bull_npc.NR_CLIPS_MAX = 5
		self.x_raging_bull_npc.hold = "akimbo_pistol"
		self.x_raging_bull_npc.FIRE_MODE = "single"
	end

	function WeaponTweakData:_init_data_m4_npc()
		--M4
		self.m4_npc.categories = clone(self.new_m4.categories)
		self.m4_npc.sounds.prefix = "m4_npc"
		self.m4_npc.use_data.selection_index = 2
		self.m4_npc.DAMAGE = 5.5
		self.m4_npc.muzzleflash = "effects/payday2/particles/weapons/556_auto"
		self.m4_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
		self.m4_npc.CLIP_AMMO_MAX = 30
		self.m4_npc.NR_CLIPS_MAX = 5
		self.m4_npc.auto.fire_rate = 0.08571428571
		self.m4_npc.hold = "rifle"
		self.m4_npc.alert_size = 2500
		self.m4_npc.suppression = 2.6
		self.m4_npc.FIRE_MODE = "auto"

		self.m4_secondary_npc = deep_clone(self.m4_npc)
		self.m4_secondary_npc.use_data.selection_index = 1

		--AK 101 used by Reapers
		self.ak47_ass_npc = deep_clone(self.m4_npc)
		self.ak47_ass_npc.sounds.prefix = "ak74_npc"

		--Bravo Rifle
		self.swamp_npc = deep_clone(self.m4_npc)
		self.swamp_npc.sounds.prefix = "m16_npc"
		self.swamp_npc.CLIP_AMMO_MAX = 60

		--HK417 (unused?)
		self.sg417_npc = deep_clone(self.m4_npc)
		self.sg417_npc.sounds.prefix = "contraband_npc"

		--Zeal S553
		self.s553_zeal_npc = deep_clone(self.m4_npc)
		self.s553_zeal_npc.sounds.prefix = "sig552_npc"

		--Sexican New Vepom Shipment
		self.hajk_npc = deep_clone(self.m4_npc)
		self.hajk_npc.sounds.prefix = "hajk_npc"

		--M4/203 used by Grenadier
		self.m4_boom_npc = deep_clone(self.m4_npc)

		--AMCAR
		self.amcar_npc = deep_clone(self.m4_npc)
		self.amcar_npc.sounds.prefix = "amcar_npc"
		self.amcar_npc.DAMAGE = 5.5
		self.amcar_npc.CLIP_AMMO_MAX = 20
		self.amcar_npc.auto.fire_rate = 0.075

		--AK102
		self.ak102_npc = deep_clone(self.amcar_npc)
		self.ak102_npc.sounds.prefix = "ak74_npc"
	end

	function WeaponTweakData:_init_data_m4_yellow_npc()
		self.m4_yellow_npc.categories = clone(self.new_m4.categories)
		self.m4_yellow_npc.sounds.prefix = "m4_npc"
		self.m4_yellow_npc.use_data.selection_index = 2
		self.m4_yellow_npc.DAMAGE = 5.5
		self.m4_yellow_npc.muzzleflash = "effects/payday2/particles/weapons/556_auto"
		self.m4_yellow_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
		self.m4_yellow_npc.CLIP_AMMO_MAX = 30
		self.m4_yellow_npc.NR_CLIPS_MAX = 5
		self.m4_yellow_npc.auto.fire_rate = 0.08571428571
		self.m4_yellow_npc.hold = "rifle"
		self.m4_yellow_npc.alert_size = 2500
		self.m4_yellow_npc.suppression = 2.6
		self.m4_yellow_npc.FIRE_MODE = "auto"
		self.m4_yellow_npc.usage = "is_rifle"
	end

	function WeaponTweakData:_init_data_ak47_npc()
		--AKM
		self.ak47_npc.categories = {"assault_rifle"}
		self.ak47_npc.sounds.prefix = "akm_npc"
		self.ak47_npc.use_data.selection_index = 2
		self.ak47_npc.DAMAGE = 5.5
		self.ak47_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
		self.ak47_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
		self.ak47_npc.CLIP_AMMO_MAX = 30
		self.ak47_npc.NR_CLIPS_MAX = 5
		self.ak47_npc.auto.fire_rate = 0.1
		self.ak47_npc.hold = "rifle"
		self.ak47_npc.alert_size = 2500
		self.ak47_npc.suppression = 2.8
		self.ak47_npc.FIRE_MODE = "auto"
		self.ak47_npc.usage = "is_rifle"
	end

	function WeaponTweakData:_init_data_m14_sniper_npc()
		--MSR Rifle
		self.m14_sniper_npc.categories = {"snp"}
		self.m14_sniper_npc.sounds.prefix = "sniper_npc"
		self.m14_sniper_npc.use_data.selection_index = 2
		self.m14_sniper_npc.DAMAGE = 29
		self.m14_sniper_npc.can_shoot_through_enemy = true
		self.m14_sniper_npc.can_shoot_through_shield = true
		self.m14_sniper_npc.can_shoot_through_wall = true
		self.m14_sniper_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
		self.m14_sniper_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
		self.m14_sniper_npc.CLIP_AMMO_MAX = 10
		self.m14_sniper_npc.NR_CLIPS_MAX = 8
		self.m14_sniper_npc.hold = "rifle"
		self.m14_sniper_npc.alert_size = 2500
		self.m14_sniper_npc.suppression = 3.4
		self.m14_sniper_npc.armor_piercing = true
		self.m14_sniper_npc.FIRE_MODE = "single"

		--Reaper variant
		self.svd_snp_npc = deep_clone(self.m14_sniper_npc)

		--Gangster variant
		self.svdsil_snp_npc = deep_clone(self.m14_sniper_npc)
		self.svdsil_snp_npc.has_suppressor = "suppressed_a"
		self.m14_sniper_npc.alert_size = 0
		self.m14_sniper_npc.suppression = 0.1

		--Zeal Sniper variant (unused)
		self.heavy_snp_npc = deep_clone(self.m14_sniper_npc)
	end

	function WeaponTweakData:_init_data_r870_npc()
		self.r870_npc.categories = clone(self.r870.categories)
		self.r870_npc.sounds.prefix = "remington_npc"
		self.r870_npc.use_data.selection_index = 2
		self.r870_npc.DAMAGE = 12.5
		self.r870_npc.muzzleflash = "effects/particles/shotgun/shotgun_gen"
		self.r870_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug_semi"
		self.r870_npc.CLIP_AMMO_MAX = 8
		self.r870_npc.NR_CLIPS_MAX = 4
		self.r870_npc.hold = "rifle"
		self.r870_npc.alert_size = 2500
		self.r870_npc.suppression = 3.2
		self.r870_npc.is_shotgun = true
		self.r870_npc.rays = 6
		self.r870_npc.spread = 3
		self.r870_npc.FIRE_MODE = "single"

		self.benelli_npc = deep_clone(self.r870_npc)
		self.benelli_npc.sounds.prefix = "benelli_m4_npc"
		self.benelli_npc.DAMAGE = 12.5
		self.benelli_npc.CLIP_AMMO_MAX = 10
		self.benelli_npc.alert_size = 2500
		self.benelli_npc.suppression = 3

		self.bayou_npc = deep_clone(self.r870_npc)
		self.bayou_npc.sounds.prefix = "spas_npc"
		self.bayou_npc.DAMAGE = 12.5
		self.bayou_npc.CLIP_AMMO_MAX = 10
		self.bayou_npc.alert_size = 2500
		self.bayou_npc.suppression = 3

		self.r870_taser_npc = deep_clone(self.r870_npc)
		self.r870_taser_npc.sounds.prefix = "keltec_npc"
		self.r870_taser_npc.DAMAGE = 12.5
		self.r870_taser_npc.CLIP_AMMO_MAX = 8
	end

	function WeaponTweakData:_init_data_mossberg_npc()
		self.mossberg_npc.categories = {"shotgun"}
		self.mossberg_npc.sounds.prefix = "remington_npc"
		self.mossberg_npc.use_data.selection_index = 2
		self.mossberg_npc.DAMAGE = 12.5
		self.mossberg_npc.muzzleflash = "effects/particles/shotgun/muzzleflash"
		self.mossberg_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug_semi"
		self.mossberg_npc.CLIP_AMMO_MAX = 2
		self.mossberg_npc.NR_CLIPS_MAX = 6
		self.mossberg_npc.hold = "rifle"
		self.mossberg_npc.alert_size = 2500
		self.mossberg_npc.suppression = 3.6
		self.mossberg_npc.is_shotgun = true
		self.mossberg_npc.rays = 6
		self.mossberg_npc.spread = 3
		self.mossberg_npc.FIRE_MODE = "single"
		self.mossberg_npc.usage = "is_shotgun_pump"
	end

	function WeaponTweakData:_init_data_mp5_npc()
		self.mp5_npc.categories = clone(self.new_mp5.categories)
		self.mp5_npc.sounds.prefix = "mp5_npc"
		self.mp5_npc.use_data.selection_index = 1
		self.mp5_npc.DAMAGE = 6
		self.mp5_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
		self.mp5_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
		self.mp5_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
		self.mp5_npc.CLIP_AMMO_MAX = 30
		self.mp5_npc.NR_CLIPS_MAX = 5
		self.mp5_npc.auto.fire_rate = 0.075
		self.mp5_npc.hold = "rifle"
		self.mp5_npc.alert_size = 2500
		self.mp5_npc.suppression = 2.4
		self.mp5_npc.FIRE_MODE = "auto"

		--Cloaker Mp5
		self.mp5_tactical_npc = deep_clone(self.mp5_npc)
		self.mp5_tactical_npc.has_suppressor = "suppressed_a"
		self.mp5_tactical_npc.alert_size = 0
		self.mp5_tactical_npc.suppression = 0.1

		--T. Cloaker Mp5
		self.mp5_cloak_npc = deep_clone(self.mp5_npc)

		--UMP
		self.ump_npc = deep_clone(self.mp5_npc)
		self.ump_npc.DAMAGE = 6
		self.ump_npc.auto.fire_rate = 0.083
		self.ump_npc.sounds.prefix = "schakal_npc"
		self.ump_npc.CLIP_AMMO_MAX = 25
		self.ump_npc.alert_size = 2500
		self.ump_npc.suppression = 2.8

		--Los Federales UZI
		self.uzi_npc = deep_clone(self.mp5_npc)
		self.uzi_npc.has_suppressor = "suppressed_c"
		self.uzi_npc.alert_size = 0
		self.uzi_npc.suppression = 0.1

		--Krinkov
		self.asval_smg_npc = deep_clone(self.mp5_npc)
		self.asval_smg_npc.DAMAGE = 6
		self.asval_smg_npc.auto.fire_rate = 0.083
		self.asval_smg_npc.CLIP_AMMO_MAX = 25
		self.asval_smg_npc.suppression = 2.8
		self.asval_smg_npc.alert_size = 2500
		self.asval_smg_npc.sounds.prefix = "akmsu_npc"

		--Tatonka
		self.akmsu_smg_npc = deep_clone(self.ump_npc)
		self.akmsu_smg_npc.sounds.prefix = "coal_npc"

		--Autumn MPX
		self.mpx_npc = deep_clone(self.mp5_tactical_npc)
		self.mpx_npc.auto.fire_rate = 0.07058823529
		self.mpx_npc.DAMAGE = 6

	end

	function WeaponTweakData:_init_data_smoke_npc()
		self.smoke_npc.categories = clone(self.new_mp5.categories)
		self.smoke_npc.sounds.prefix = "mp5_npc"
		self.smoke_npc.use_data.selection_index = 1
		self.smoke_npc.DAMAGE = 6
		self.smoke_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
		self.smoke_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
		self.smoke_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
		self.smoke_npc.CLIP_AMMO_MAX = 30
		self.smoke_npc.NR_CLIPS_MAX = 5
		self.smoke_npc.auto.fire_rate = 0.075
		self.smoke_npc.hold = "rifle"
		self.smoke_npc.alert_size = 2500
		self.smoke_npc.suppression = 2.4
		self.smoke_npc.FIRE_MODE = "auto"
	end

	function WeaponTweakData:_init_data_mac11_npc()
		self.mac11_npc.categories = {"smg"}
		self.mac11_npc.sounds.prefix = "mac10_npc"
		self.mac11_npc.use_data.selection_index = 1
		self.mac11_npc.DAMAGE = 6
		self.mac11_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
		self.mac11_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
		self.mac11_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
		self.mac11_npc.CLIP_AMMO_MAX = 20
		self.mac11_npc.NR_CLIPS_MAX = 5
		self.mac11_npc.auto.fire_rate = 0.06
		self.mac11_npc.alert_size = 2500
		self.mac11_npc.hold = {"uzi", "pistol"}
		self.mac11_npc.suppression = 2.8
		self.mac11_npc.FIRE_MODE = "auto"
		self.mac11_npc.usage = "is_smg"
	end

	function WeaponTweakData:_init_data_g36_npc()
		--G36
		self.g36_npc.categories = clone(self.g36.categories)
		self.g36_npc.sounds.prefix = "g36_npc"
		self.g36_npc.use_data.selection_index = 2
		self.g36_npc.DAMAGE = 5.5
		self.g36_npc.muzzleflash = "effects/payday2/particles/weapons/556_auto"
		self.g36_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
		self.g36_npc.CLIP_AMMO_MAX = 30
		self.g36_npc.NR_CLIPS_MAX = 5
		self.g36_npc.auto.fire_rate = 0.08571428571
		self.g36_npc.hold = "rifle"
		self.g36_npc.alert_size = 2500
		self.g36_npc.suppression = 2.6
		self.g36_npc.FIRE_MODE = "auto"
	end

	function WeaponTweakData:_init_data_mp9_npc()
		--NPC MP9
		self.mp9_npc.categories = clone(self.mp9.categories)
		self.mp9_npc.sounds.prefix = "mp9_npc"
		self.mp9_npc.use_data.selection_index = 1
		self.mp9_npc.DAMAGE = 4
		self.mp9_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
		self.mp9_npc.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
		self.mp9_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
		self.mp9_npc.CLIP_AMMO_MAX = 20
		self.mp9_npc.NR_CLIPS_MAX = 5
		self.mp9_npc.auto.fire_rate = 0.06666666666
		self.mp9_npc.hold = "pistol"
		self.mp9_npc.alert_size = 2500
		self.mp9_npc.suppression = 2.2
		self.mp9_npc.FIRE_MODE = "auto"
		self.mp9_npc.usage = "is_pistol"

		--SR2
		self.sr2_smg_npc = deep_clone(self.mp9_npc)
		self.sr2_smg_npc.sounds.prefix = "sr2_npc"
	end

	function WeaponTweakData:_init_data_saiga_npc()
		--Saiga
		self.saiga_npc.categories = clone(self.saiga.categories)
		self.saiga_npc.sounds.prefix = "saiga_npc"
		self.saiga_npc.use_data.selection_index = 2
		self.saiga_npc.DAMAGE = 9
		self.saiga_npc.muzzleflash = "effects/particles/shotgun/shotgun_gen"
		self.saiga_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_slug"
		self.saiga_npc.auto.fire_rate = 0.1
		self.saiga_npc.CLIP_AMMO_MAX = 20
		self.saiga_npc.NR_CLIPS_MAX = 4
		self.saiga_npc.hold = "rifle"
		self.saiga_npc.alert_size = 2500
		self.saiga_npc.suppression = 3.2
		self.saiga_npc.is_shotgun = true
		self.saiga_npc.rays = 6
		self.saiga_npc.spread = 3
		self.saiga_npc.FIRE_MODE = "auto"
	end

	function WeaponTweakData:_init_data_s552_npc()
		--Sig 553
		self.s552_npc.categories = clone(self.s552.categories)
		self.s552_npc.sounds.prefix = "sig552_npc"
		self.s552_npc.use_data.selection_index = 2
		self.s552_npc.DAMAGE = 5.5
		self.s552_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto_silence"
		self.s552_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
		self.s552_npc.CLIP_AMMO_MAX = 30
		self.s552_npc.NR_CLIPS_MAX = 5
		self.s552_npc.auto.fire_rate = 0.08571428571
		self.s552_npc.hold = "rifle"
		self.s552_npc.alert_size = 2500
		self.s552_npc.suppression = 2.6
		self.s552_npc.FIRE_MODE = "auto"
		self.s552_npc.has_suppressor = "suppressed_c"
	end

	function WeaponTweakData:_init_data_scar_npc()
		--M14/Socom 16
		self.scar_npc.categories = clone(self.scar.categories)
		self.scar_npc.sounds.prefix = "zsniper_npc"
		self.scar_npc.use_data.selection_index = 2
		self.scar_npc.DAMAGE = 10.5
		self.scar_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
		self.scar_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
		self.scar_npc.CLIP_AMMO_MAX = 20
		self.scar_npc.NR_CLIPS_MAX = 5
		self.scar_npc.auto.fire_rate = 0.08571428571
		self.scar_npc.hold = "rifle"
		self.scar_npc.alert_size = 2500
		self.scar_npc.suppression = 2.8
		self.scar_npc.FIRE_MODE = "single"
		self.scar_npc.titan_trail = true
		self.scar_npc.usage = "is_dmr"
		self.scar_npc.armor_piercing = true
		self.scar_secondary_npc = deep_clone(self.scar_npc)
		self.scar_secondary_npc.use_data.selection_index = 1
	end

	function WeaponTweakData:_init_data_m249_npc()
		--M249
		self.m249_npc.categories = clone(self.m249.categories)
		self.m249_npc.sounds.prefix = "m249_npc"
		self.m249_npc.use_data.selection_index = 2
		self.m249_npc.DAMAGE = 7
		self.m249_npc.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
		self.m249_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
		self.m249_npc.CLIP_AMMO_MAX = 200
		self.m249_npc.NR_CLIPS_MAX = 2
		self.m249_npc.auto.fire_rate = 0.075
		self.m249_npc.hold = "rifle"
		self.m249_npc.alert_size = 2500
		self.m249_npc.suppression = 2
		self.m249_npc.FIRE_MODE = "auto"

		--RPK
		self.rpk_lmg_npc = deep_clone(self.m249_npc)
		self.rpk_lmg_npc.sounds.prefix = "rpk_npc"

		--HK21
		self.hk21_sc_npc = deep_clone(self.m249_npc)
		self.hk21_sc_npc.sounds.prefix = "hk23e_npc"
		self.hk21_sc_npc.use_data.selection_index = 2
		self.hk21_sc_npc.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
		self.hk21_sc_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
		self.hk21_sc_npc.CLIP_AMMO_MAX = 100
		self.hk21_sc_npc.NR_CLIPS_MAX = 5
		self.hk21_sc_npc.auto.fire_rate = 0.075
		self.hk21_sc_npc.hold = "rifle"

		--HK23
		self.hk23_sc_npc = deep_clone(self.hk21_sc_npc)
		self.hk23_sc_npc.auto.fire_rate = 0.08
		self.hk23_sc_npc.CLIP_AMMO_MAX = 50

		--M60
		self.m60_npc = deep_clone(self.m249_npc)
		self.m60_npc.sounds.prefix = "m60_npc"

		--Bravo LMG--
		self.m249_bravo_npc = deep_clone(self.hk23_sc_npc)
		self.m249_bravo_npc.sounds.prefix = "m249_npc"
		self.m249_bravo_npc.CLIP_AMMO_MAX = 200

		--Murky Bravo M60
		self.m60_bravo_npc = deep_clone(self.hk23_sc_npc)
		self.m60_bravo_npc.sounds.prefix = "m60_npc"
		self.m60_bravo_npc.CLIP_AMMO_MAX = 200

		--M60 Omnia
		self.m60_om_npc = deep_clone(self.m249_npc)
		self.m60_om_npc.sounds.prefix = "m60_npc"
	end

	function WeaponTweakData:_init_data_contraband_npc()
		--HK417
		self.contraband_npc.categories = clone(self.contraband.categories)
		self.contraband_npc.sounds.prefix = "contraband_npc"
		self.contraband_npc.use_data.selection_index = 2
		self.contraband_npc.DAMAGE = 5.5
		self.contraband_npc.muzzleflash = "effects/payday2/particles/weapons/762_auto"
		self.contraband_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556"
		self.contraband_npc.CLIP_AMMO_MAX = 30
		self.contraband_npc.NR_CLIPS_MAX = 5
		self.contraband_npc.auto.fire_rate = 0.08571428571
		self.contraband_npc.hold = "rifle"
		self.contraband_npc.alert_size = 2500
		self.contraband_npc.suppression = 2.6
		self.contraband_npc.FIRE_MODE = "auto"

		--M203
		self.contraband_m203_npc.sounds.prefix = "contrabandm203_npc"
		self.contraband_m203_npc.use_data.selection_index = 2
		self.contraband_m203_npc.DAMAGE = 80
		self.contraband_m203_npc.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
		self.contraband_m203_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
		self.contraband_m203_npc.no_trail = true
		self.contraband_m203_npc.CLIP_AMMO_MAX = 1
		self.contraband_m203_npc.NR_CLIPS_MAX = 4
		self.contraband_m203_npc.looped_reload_speed = 0.16666667
		self.contraband_m203_npc.auto.fire_rate = 0.1
		self.contraband_m203_npc.hold = "rifle"
		self.contraband_m203_npc.alert_size = 2500
		self.contraband_m203_npc.suppression = 1
	end

	function WeaponTweakData:_init_data_mini_npc()
		self.mini_npc.categories = clone(self.m134.categories)
		self.mini_npc.sounds.prefix = "minigun_npc"
		self.mini_npc.use_data.selection_index = 2
		self.mini_npc.DAMAGE = 7
		self.mini_npc.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
		self.mini_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
		self.mini_npc.CLIP_AMMO_MAX = 300
		self.mini_npc.NR_CLIPS_MAX = 2
		self.mini_npc.auto.fire_rate = 0.03
		self.mini_npc.hold = "rifle"
		self.mini_npc.alert_size = 2500
		self.mini_npc.suppression = 2
		self.mini_npc.FIRE_MODE = "auto"
		self.mini_npc.usage = "is_mini"

		--Akimbo Miniguns
		self.x_mini_npc = deep_clone(self.mini_npc)
		self.x_mini_npc.categories = {
			"akimbo",
			"minigun"
		}
		self.x_mini_npc.sounds.prefix = "minigun_npc"
		self.x_mini_npc.use_data.selection_index = 1
		self.x_mini_npc.DAMAGE = 7
		self.x_mini_npc.muzzleflash = "effects/payday2/particles/weapons/big_762_auto"
		self.x_mini_npc.shell_ejection = "effects/payday2/particles/weapons/shells/shell_556_lmg"
		self.x_mini_npc.CLIP_AMMO_MAX = 600
		self.x_mini_npc.NR_CLIPS_MAX = 2
		self.x_mini_npc.auto.fire_rate = 0.015
		self.x_mini_npc.hold = "akimbo_pistol"
		self.x_mini_npc.alert_size = 2500
		self.x_mini_npc.suppression = 2
		self.x_mini_npc.FIRE_MODE = "auto"
	end

	--Crew weapons but not really--
	function WeaponTweakData:_init_data_flamethrower_mk2_crew()
		self.flamethrower_mk2_crew.categories = clone(self.flamethrower_mk2.categories)
		self.flamethrower_mk2_crew.sounds.prefix = "flamethrower_npc"
		self.flamethrower_mk2_crew.sounds.fire = "flamethrower_npc_fire"
		self.flamethrower_mk2_crew.sounds.stop_fire = "flamethrower_npc_fire_stop"
		self.flamethrower_mk2_crew.use_data.selection_index = 2
		self.flamethrower_mk2_crew.DAMAGE = 3.7
		self.flamethrower_mk2_crew.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
		self.flamethrower_mk2_crew.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
		self.flamethrower_mk2_crew.shell_ejection = "effects/payday2/particles/weapons/shells/shell_9mm"
		self.flamethrower_mk2_crew.CLIP_AMMO_MAX = 60
		self.flamethrower_mk2_crew.NR_CLIPS_MAX = 4
		self.flamethrower_mk2_crew.pull_magazine_during_reload = "large_metal"
		self.flamethrower_mk2_crew.hold = {"bullpup", "rifle"}
		self.flamethrower_mk2_crew.auto.fire_rate = 0.1
		self.flamethrower_mk2_crew.hud_icon = "rifle"
		self.flamethrower_mk2_crew.alert_size = 2500
		self.flamethrower_mk2_crew.suppression = 3.1
		self.flamethrower_mk2_crew.FIRE_MODE = "auto"

		self.flamethrower_mk2_flamer = {}
		self.flamethrower_mk2_flamer = deep_clone(self.flamethrower_mk2_crew)
		self.flamethrower_mk2_flamer.categories = clone(self.flamethrower_mk2.categories)
		self.flamethrower_mk2_flamer.sounds.prefix = "flamethrower_npc"
		self.flamethrower_mk2_flamer.sounds.fire = "flamethrower_npc_fire"
		self.flamethrower_mk2_flamer.sounds.stop_fire = "flamethrower_npc_fire_stop"
		self.flamethrower_mk2_flamer.CLIP_AMMO_MAX = 60
		self.flamethrower_mk2_flamer.NR_CLIPS_MAX = 4
		self.flamethrower_mk2_flamer.FIRE_RANGE = 1400
		self.flamethrower_mk2_flamer.DAMAGE = 7.5
		self.flamethrower_mk2_flamer.fire_dot_data = {
			dot_trigger_chance = 0,
			dot_damage = 0,
			dot_length = 0,
			dot_trigger_max_distance = 0,
			dot_tick_period = 0
		}
		self.flamethrower_mk2_flamer.FIRE_MODE = "auto"
		self.flamethrower_mk2_flamer.fire_rate = 0.1
		self.flamethrower_mk2_flamer.hold = {
			"bullpup",
			"rifle"
		}
		self.flamethrower_mk2_flamer.alert_size = 2500
		self.flamethrower_mk2_flamer.suppression = 3.1
		self.flamethrower_mk2_flamer.muzzleflash = "effects/payday2/particles/weapons/9mm_auto"
		self.flamethrower_mk2_flamer.muzzleflash_silenced = "effects/payday2/particles/weapons/9mm_auto_silence"
		self.flamethrower_mk2_flamer.shell_ejection = "effects/payday2/particles/weapons/shells/shell_empty"
		self.flamethrower_mk2_flamer.pull_magazine_during_reload = "large_metal"
		self.flamethrower_mk2_flamer.anim_usage = "is_bullpup"
		self.flamethrower_mk2_flamer.usage = "is_flamethrower"
	end