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
		--Keep this between 0.5x-1x the other stats to ensure that investing elsewhere will reduce spread more situationally, but this will reduce it more overall.
		self.stat_info.base_spread = 10
		self.stat_info.spread_per_accuracy = -0.5
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
			far_mul = 2
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
		self.stat_info.base_move_spread = 12
		self.stat_info.spread_per_mobility = -0.6
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
		self.stat_info.base_bloom_spread = 14 --Amount of spread each stack of bloom gives.
		self.stat_info.spread_per_stability = -0.7 --Amount bloom spread is reduced by stability.
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

	--Stance multipliers for overall gun spread.
	self.stat_info.stance_spread_mults = {
		standing = 1,
		moving_standing = 1,
		crouching = 0.75,
		moving_crouching = 0.75,
		steelsight = 0.5,
		moving_steelsight = 0.5,
		bipod = 0.35
	}

	--Stance multipliers for weapon recoil.
	self.stat_info.stance_recoil_mults = {
		standing = 1,
		crouching = 0.8,
		steelsight = 0.6,
		bipod = 0.5
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

	self.stat_info.autohit_rate = 0.5 --Multiplier for how often autohit should occur at 0 spread. (IE: 1==every shot, 0.5==every other shot, ect)
	self.stat_info.autohit_angle = 1.5
	self.stat_info.autohit_head_difficulty_factor = 0.75
	self.stat_info.ricochet_autohit_angle = 6 --Ricochets need a fairly decently sized auto-hit angle to be usable.
	self.stat_info.suppression_angle = 9
end