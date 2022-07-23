local orig_init = WeaponTweakData.init
function WeaponTweakData:init(...)
	orig_init(self, ...)
	self.trip_mines.damage = 40
	self.trip_mines.player_damage = 20
	self.trip_mines.damage_size = 200
	self.trip_mines.delay = 0.1

	for i, weap in pairs(self) do
		if weap.categories and weap.stats then --Nil out various values globally, since most are not needed.
			weap.BURST_COUNT = false
			weap.upgrade_blocks = nil
			weap.stats_modifiers = nil
			weap.AMMO_MAX = nil
			weap.not_allowed_in_bleedout = nil
			weap.rays = nil
		end
	end

	--Bootleg tier (Primary)
		--Bootleg
		self.tecci.supported = true --ALWAYS include this flag for weapons indended to be used by players. Without it, the gun becomes unselectable.
		self.tecci.kick = self.stat_info.kick_tables.horizontal_recoil
		self.tecci.kick_pattern = self.stat_info.kick_patterns.zigzag_3
		--self.tecci.AMMO_MAX --Vanilla max ammo stat. Don't define unless you want automatic ammo max calculation to be overwritten (IE: for balancing guns with underbarrels and such)
		self.tecci.CLIP_AMMO_MAX = 100
		self.tecci.fire_rate_multiplier = 1.05 --700 rpm
		self.tecci.CAN_TOGGLE_FIREMODE = true
		--self.tecci.auto.fire_rate = 0.075 --For fire-rate tweaks, try out both the fire_rate_multiplier and directly changing timers to see what feels better.
		self.tecci.stats = {
			--Stats not included in this table are auto-calculated.
			--Ones that are commented out are optional, and will be given default values = to what the comments set them to if nonexistent.
			damage = 18,
			--Controls the overall spread and range of the gun.
			--Cosmetically, it influences passive weapon sway.
			spread = 16,
			--Controls the amount of recoil and bloom the gun has.
			--Cosmetically, it influences camera shake from shooting.
			recoil = 18,
			--Controls the moving spread, swap speed, and ADS speed of the gun.
			--Cosmetically, it influences weapon sway from camera movement.
			concealment = 10, --Corresponds to "mobility" from the player's perspective.
			--value = 1
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
		self.tecci.reload_speed_multiplier = 1.1 --4.2/4.8s (Try to leave comments denoting the resulting time)
		--Ditto for swap speed.
		--self.tecci.swap_speed_multiplier = 1.0 --(Try to leave comments denoting the resulting time)
		
		--Only use on single-shot crossbows. Defines the cutoff time in the reload animation to animate the draw-string to when firing.
		--0.067 is usually a good number to start with.
		--self.tecci.crossbow_string_time = 0.067
		
		--If this exists, the gun gets burst fire. Fires in bursts equivalent to this many rounds.
		--self.tecci.BURST_COUNT = 3
		--Set to true if you want bursts to be interrupt-able early by releasing the trigger.
		--self.tecci.ADAPTIVE_BURST_SIZE = true
		--Acts similarly to the fire_rate_multiplier flag, but only applies while the gun is actively shooting a burst.
		--self.tecci.BURST_FIRE_RATE_MULTIPLIER = 2

		--Used exclusively on rocket launchers to fit their gimmick.
		--self.tecci.turret_instakill = true

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
			concealment = 14
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
		self.g36.BURST_COUNT = 3
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
			concealment = 13
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
			concealment = 17
		}
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
		self.s552.BURST_COUNT = 3
		self.s552.ADAPTIVE_BURST_SIZE = false
		self.s552.kick = self.stat_info.kick_tables.right_recoil
		self.s552.kick_pattern = self.stat_info.kick_patterns.random
		self.s552.supported = true
		self.s552.stats = {
			damage = 20,
			spread = 17,
			recoil = 15,
			concealment = 14
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
			concealment = 15
		}
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
			concealment = 16
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
			concealment = 16
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
		self.famas.BURST_COUNT = 3
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
			concealment = 16
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
			concealment = 14
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
			concealment = 14
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
		self.aug.kick = self.stat_info.kick_tables.moderate_right_kick
		self.aug.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.aug.supported = true
		self.aug.stats = {
			damage = 24,
			spread = 16,
			recoil = 13,
			concealment = 17
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
		self.flint.BURST_COUNT = 2
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
			concealment = 13
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
			concealment = 14
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
			self.osipr.tactical_reload = true
			self.osipr.AMMO_MAX = 90
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
				concealment = 7
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

			self.osipr_gl.AMMO_MAX = 6
			self.osipr_gl.CLIP_AMMO_MAX = 5
			self.osipr_gl.tactical_reload = true
			self.osipr_gl.fire_mode_data.fire_rate = 0.4
			self.osipr_gl.kick = self.stat_info.kick_tables.vertical_kick
			self.osipr_gl.kick_pattern = self.stat_info.kick_patterns.random
			self.osipr_gl.supported = true
			self.osipr_gl.stats = {
				damage = 30,
				spread = 9,
				recoil = 5,
				concealment = 7
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
			self.osipr_gl.reload_speed_multiplier = 0.85 --4.8/5.8
			self.osipr_gl_npc.FIRE_MODE = "auto"
		else
			log("[ERROR] Beardlib was unable to load the custom weapons. Check to make sure you installed Beardlib correctly!")
			self.crash.crash = math.huge
		end

	--Medium Rifles (SECONDARY)
		--CR 805B
		self.hajk.BURST_COUNT = 3
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
			concealment = 15
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
			concealment = 13
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
			concealment = 13
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
			concealment = 16
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
			concealment = 12
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
			concealment = 12
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
			concealment = 13
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

	--HEAVY Rifle (AKIMBO)
		--Akimbo Krinkov
		self.x_akmsu.categories = {
			"assault_rifle",
			"akimbo"
		}
		self.x_akmsu.CLIP_AMMO_MAX = self.akmsu.CLIP_AMMO_MAX * 2
		self.x_akmsu.BURST_COUNT = 2
		self.x_akmsu.ADAPTIVE_BURST_SIZE = true
		self.x_akmsu.fire_mode_data.fire_rate = self.akmsu.fire_mode_data.fire_rate
		self.x_akmsu.single.fire_rate = self.akmsu.auto.fire_rate
		self.x_akmsu.fire_rate_multiplier = self.akmsu.fire_rate_multiplier
		self.x_akmsu.kick = self.akmsu.kick
		self.x_akmsu.kick_pattern = self.akmsu.kick_pattern
		self.x_akmsu.supported = true
		self.x_akmsu.stats = {
			damage = 30,
			spread = 11,
			recoil = 10,
			concealment = 9
		}
		self.x_akmsu.timers = {
			reload_not_empty = 3.6,
			reload_empty = 3.9,
			half_reload_operational = 1.7,
			empty_half_reload_operational = 2.5,
			reload_operational = 2.2,
			empty_reload_operational = 2.8,
			reload_interrupt = 0.38,
			empty_reload_interrupt = 0.38,
			unequip = 0.5,
			equip = 0.65
		}
		self.x_akmsu.reload_speed_multiplier = 0.8 --4.5/4.9s

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
			concealment = 11
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
		self.groza.AMMO_MAX = 40
		self.groza.tactical_reload = true
		self.groza.fire_rate_multiplier = 1.00333333333 --700 rpm.
		self.groza.kick = self.stat_info.kick_tables.vertical_kick
		self.groza.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.groza.supported = true
		self.groza.stats = {
			damage = 45,
			spread = 14,
			recoil = 11,
			concealment = 14
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
		self.groza_underbarrel.single.fire_rate = 0.3
		self.groza_underbarrel.fire_mode_data.fire_rate = 0.3
		self.groza_underbarrel.fire_rate_multiplier = 0.4 --100 rpm.
		self.groza_underbarrel.kick = self.stat_info.kick_tables.vertical_kick
		self.groza_underbarrel.kick_pattern = self.stat_info.kick_patterns.random
		self.groza_underbarrel.AMMO_MAX = 4
		self.groza_underbarrel.supported = true
		self.groza_underbarrel.stats = {
			damage = 40,
			spread = 5,
			recoil = 5,
			concealment = 14
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
			concealment = 6
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
		self.contraband.AMMO_MAX = 40
		self.contraband.tactical_reload = true
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
			concealment = 9
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
		self.contraband_m203.single.fire_rate = 0.3
		self.contraband_m203.fire_mode_data.fire_rate = 0.3
		self.contraband_m203.fire_rate_multiplier = 0.4 --100 rpm.
		self.contraband_m203.kick = self.stat_info.kick_tables.vertical_kick
		self.contraband_m203.kick_pattern = self.stat_info.kick_patterns.random
		self.contraband_m203.AMMO_MAX = 4
		self.contraband_m203.supported = true
		self.contraband_m203.stats = {
			damage = 40,
			spread = 14,
			recoil = 10,
			concealment = 9
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
			spread = 18,
			recoil = 10,
			concealment = 13
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
			concealment = 7
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
			concealment = 9
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
		self.shak12.tactical_reload = true
		self.shak12.supported = true
		self.shak12.stats = {
			damage = 60,
			spread = 17,
			recoil = 8,
			concealment = 13
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
			concealment = 12
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

	--Heavy DMR (Secondary)
		--Kang Arms X1
		self.qbu88.use_data.selection_index = 1
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
			concealment = 15
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

	--Minigun (PRIMARY)
		--Minigun
		self.m134.categories = {
			"minigun",
			"smg"
		}
		self.m134.has_description = false
		self.m134.CLIP_AMMO_MAX = 360
		self.m134.fire_mode_data.fire_rate = 0.05
		self.m134.fire_rate_multiplier = 1.666666666667 --2000 rpm
		self.m134.kick = self.stat_info.kick_tables.horizontal_recoil
		self.m134.kick_pattern = self.stat_info.kick_patterns.random
		self.m134.supported = true
		self.m134.stats = {
			damage = 20,
			spread = 5,
			recoil = 12,
			concealment = 5
		}
		self.m134.spin_rounds = 18
		self.m134.timers = {
			reload_empty = 9,
			reload_not_empty = 9,
			reload_operational = 7.8,
			empty_reload_operational = 7.8,
			reload_interrupt = 1.2,
			empty_reload_interrupt = 1.2,
			unequip = 0.9,
			equip = 0.9
		}

		--Microgun
		self.shuno.categories = {
			"minigun",
			"smg"
		}
		self.shuno.has_description = false
		self.shuno.CLIP_AMMO_MAX = 400
		self.shuno.FIRE_MODE = "auto"
		self.shuno.fire_mode_data.fire_rate = 0.05
		self.shuno.fire_rate_multiplier = 1.5 --1800 rpm
		self.shuno.kick = self.stat_info.kick_tables.horizontal_recoil
		self.shuno.kick_pattern = self.stat_info.kick_patterns.random
		self.shuno.supported = true
		self.shuno.stats = {
			damage = 18,
			spread = 5,
			recoil = 14,
			concealment = 6
		}
		self.shuno.spin_rounds = 15
		self.shuno.timers = {
			reload_empty = 11,
			reload_not_empty = 11,
			reload_operational = 8.2,
			empty_reload_operational = 8.2,
			reload_interrupt = 1.35,
			empty_reload_interrupt = 1.35,
			unequip = 1.5,
			equip = 0.9
		}
		self.shuno.reload_speed_multiplier = 1.222222 --9s
		self.shuno.swap_speed_multiplier = 1.3

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
			concealment = 6
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
			concealment = 9
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

		--SG Versteckt 51D
		self.hk51b.categories = {
			"lmg",
			"smg"
		}
		self.hk51b.kick = self.stat_info.kick_tables.moderate_right_kick
		self.hk51b.kick_pattern = self.stat_info.kick_patterns.random
		self.hk51b.fire_rate_multiplier = 0.9 --600rpm
		self.hk51b.supported = true
		self.hk51b.stats = {
			damage = 24,
			spread = 14,
			recoil = 17,
			concealment = 13
		}
		self.hk51b.timers = {
			reload_not_empty = 3.6,
			reload_empty = 4.1,
			reload_operational = 2.95,
			empty_reload_operational = 3.3,
			reload_interrupt = 0.49,
			empty_reload_interrupt = 0.95,
			unequip = 0.6,
			equip = 0.65,
			deploy_bipod = 1
		}
		self.hk51b.swap_speed_multiplier = 0.8

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
			concealment = 10
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
			concealment = 8
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
			concealment = 11
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
		self.msr.desc_id = "bm_ap_weapon_sc_desc"
		self.msr.fire_mode_data.fire_rate = 0.75
		self.msr.kick = self.stat_info.kick_tables.vertical_kick
		self.msr.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.msr.supported = true
		self.msr.stats = {
			damage = 90,
			spread = 19,
			recoil = 12,
			concealment = 13
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
		self.r700.has_description = true
		self.r700.desc_id = "bm_ap_weapon_sc_desc"
		self.r700.kick = self.stat_info.kick_tables.vertical_kick
		self.r700.kick_pattern = self.stat_info.kick_patterns.zigzag_3
		self.r700.supported = true
		self.r700.stats = {
			damage = 90,
			spread = 21,
			recoil = 14,
			concealment = 13
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
			concealment = 14
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
		self.winchester1874.has_description = true
		self.winchester1874.desc_id = "bm_ap_weapon_sc_desc"
		self.winchester1874.CLIP_AMMO_MAX = 14
		self.winchester1874.fire_mode_data.fire_rate = 1.5
		self.winchester1874.single.fire_rate = 1.5
		self.winchester1874.fire_rate_multiplier = 1.75
		self.winchester1874.kick = self.stat_info.kick_tables.left_kick
		self.winchester1874.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.winchester1874.tactical_reload = true
		self.winchester1874.supported = true
		self.winchester1874.stats = {
			damage = 90,
			spread = 19,
			recoil = 11,
			concealment = 16
		}
		self.winchester1874.timers = {
			shotgun_reload_enter = 0.43333333333333335,
			shotgun_reload_exit_empty = 0.76666666666666,
			shotgun_reload_exit_not_empty = 0.4,
			shotgun_reload_shell = 0.5666666666666667,
			shotgun_reload_first_shell_offset = 0.2,
			shotgun_reload_interrupt = 0.47,
			unequip = 0.9,
			equip = 0.9
		}
		self.winchester1874.reload_speed_multiplier = 1.1

		--Grom
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
			concealment = 10
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

	--Light Sniper (Secondary)
		--Pronghorn Sniper Rifle
		self.scout.has_description = true
		self.scout.desc_id = "bm_ap_weapon_sc_desc"
		self.scout.tactical_reload = true
		self.scout.fire_mode_data.fire_rate = 0.75
		self.scout.kick = self.stat_info.kick_tables.vertical_kick
		self.scout.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.scout.supported = true
		self.scout.stats = {
			damage = 90,
			spread = 18,
			recoil = 11,
			concealment = 14
		}
		self.scout.timers = {
			reload_not_empty = 4.2,
			reload_empty = 5.7,
			reload_operational = 3.4,
			empty_reload_operational = 5.3,
			reload_interrupt = 0.36,
			empty_reload_interrupt = 0.36,
			unequip = 0.4,
			equip = 0.45
		}


	--Heavy Sniper (Primary)
		--Bernetti Rangehitter
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
		self.sbl.tactical_reload = true
		self.sbl.supported = true
		self.sbl.stats = {
			damage = 135,
			spread = 17,
			recoil = 9,
			concealment = 13
		}
		self.sbl.timers = {
			shotgun_reload_enter = 0.43333333333333335,
			shotgun_reload_exit_empty = 0.7666666666666667,
			shotgun_reload_exit_not_empty = 0.4,
			shotgun_reload_shell = 0.5666666666666667,
			shotgun_reload_first_shell_offset = 0.2,
			shotgun_reload_interrupt = 0.47,
			unequip = 0.6,
			equip = 0.6
		}
		self.sbl.swap_speed_multiplier = 0.8

		--Platypus 70
		self.model70.has_description = true
		self.model70.desc_id = "bm_ap_weapon_sc_desc"
		self.model70.CLIP_AMMO_MAX = 6
		self.model70.kick = self.stat_info.kick_tables.vertical_kick
		self.model70.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.model70.supported = true
		self.model70.stats = {
			damage = 135,
			spread = 21,
			recoil = 13,
			concealment = 9
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
		self.desertfox.has_description = true
		self.desertfox.desc_id = "bm_ap_weapon_sc_desc"
		self.desertfox.CLIP_AMMO_MAX = 5
		self.desertfox.fire_rate_multiplier = 1.1667 --70rpm
		self.desertfox.kick = self.stat_info.kick_tables.right_kick
		self.desertfox.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.desertfox.supported = true
		self.desertfox.stats = {
			damage = 135,
			spread = 19,
			recoil = 11,
			concealment = 13
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
		self.r93.has_description = true
		self.r93.desc_id = "bm_ap_weapon_sc_desc"
		self.r93.CLIP_AMMO_MAX = 6 --Has 5 rounds irl, but 6 makes for more interesting tradeoffs.
		self.r93.fire_mode_data.fire_rate = 1
		self.r93.kick = self.stat_info.kick_tables.vertical_kick
		self.r93.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.r93.supported = true
		self.r93.stats = {
			damage = 135,
			spread = 21,
			recoil = 16,
			concealment = 6
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
		self.mosin.has_description = true
		self.mosin.desc_id = "bm_ap_weapon_sc_desc"
		self.mosin.CLIP_AMMO_MAX = 5
		self.mosin.fire_mode_data.fire_rate = 1
		self.mosin.kick = self.stat_info.kick_tables.vertical_kick
		self.mosin.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.mosin.supported = true
		self.mosin.stats = {
			damage = 135,
			spread = 20,
			recoil = 14,
			concealment = 11
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
			concealment = 7
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
			concealment = 17
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
			concealment = 19
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
			concealment = 18
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
			concealment = 17
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

	--PDW SMG (Akimbo)
		--Akimbo Heather
		self.x_sr2.fire_mode_data.fire_rate = self.sr2.fire_mode_data.fire_rate
		self.x_sr2.single.fire_rate = self.sr2.auto.fire_rate
		self.x_sr2.fire_rate_multiplier = self.sr2.fire_rate_multiplier
		self.x_sr2.CLIP_AMMO_MAX = self.sr2.CLIP_AMMO_MAX * 2
		self.x_sr2.kick = self.sr2.kick
		self.x_sr2.kick_pattern = self.sr2.kick_pattern
		self.x_sr2.BURST_COUNT = 2
		self.x_sr2.ADAPTIVE_BURST_SIZE = true
		self.x_sr2.supported = true
		self.x_sr2.stats = {
			damage = 18,
			spread = 11,
			recoil = 14,
			concealment = 17
		}
		self.x_sr2.timers = {
			reload_not_empty = 2.2,
			reload_empty = 2.6,
			half_reload_operational = 1.5,
			empty_half_reload_operational = 1.6,
			reload_operational = 1.8,
			empty_reload_operational = 2.3,
			reload_interrupt = 0.34,
			empty_reload_interrupt = 0.34,
			unequip = 0.5,
			equip = 0.45
		}
		self.x_sr2.reload_speed_multiplier = 0.7 --3.1/3.7s
		self.x_sr2.swap_speed_multiplier = 0.8

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
			concealment = 18
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
			concealment = 17
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
			concealment = 18
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
			concealment = 16
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
		self.new_mp5.BURST_COUNT = 3
		self.new_mp5.ADAPTIVE_BURST_SIZE = false
		self.new_mp5.kick = self.stat_info.kick_tables.right_recoil
		self.new_mp5.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.new_mp5.supported = true
		self.new_mp5.stats = {
			damage = 20,
			spread = 16,
			recoil = 15,
			concealment = 16
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
			concealment = 20
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

	--Light SMG (AKIMBO)
		--Akimbo Mark-10
		self.x_mac10.CLIP_AMMO_MAX = self.mac10.CLIP_AMMO_MAX * 2
		self.x_mac10.fire_mode_data.fire_rate = self.mac10.fire_mode_data.fire_rate
		self.x_mac10.single.fire_rate = self.mac10.auto.fire_rate
		self.x_mac10.kick = self.mac10.kick
		self.x_mac10.kick_pattern = self.mac10.kick_pattern
		self.x_mac10.supported = true
		self.x_mac10.BURST_COUNT = 2
		self.x_mac10.ADAPTIVE_BURST_SIZE = true
		self.x_mac10.stats = {
			damage = 20,
			spread = 9,
			recoil = 9,
			concealment = 15
		}
		self.x_mac10.timers = {
			reload_not_empty = 3.6,
			reload_empty = 3.9,
			half_reload_operational = 1.7,
			empty_half_reload_operational = 2.5,
			reload_operational = 2.2,
			empty_reload_operational = 2.8,
			reload_interrupt = 0.38,
			empty_reload_interrupt = 0.38,
			unequip = 0.5,
			equip = 0.65
		}

		--Akimbo Compact-5
		self.x_mp5.fire_rate_multiplier = self.new_mp5.fire_rate_multiplier
		self.x_mp5.BURST_COUNT = 6
		self.x_mp5.ADAPTIVE_BURST_SIZE = false
		self.x_mp5.kick = self.new_mp5.kick
		self.x_mp5.kick_pattern = self.new_mp5.kick_pattern
		self.x_mp5.CLIP_AMMO_MAX = self.new_mp5.CLIP_AMMO_MAX * 2
		self.x_mp5.supported = true
		self.x_mp5.stats = {
			damage = 20,
			spread = 12,
			recoil = 11,
			concealment = 11
		}
		self.x_mp5.timers = {
			reload_not_empty = 2.65,
			reload_empty = 3.2,
			half_reload_operational = 1.35,
			empty_half_reload_operational = 1.8,
			reload_operational = 1.8,
			empty_reload_operational = 2.55,
			reload_interrupt = 0.35,
			empty_reload_interrupt = 0.35,
			unequip = 0.5,
			equip = 0.65
		}
		self.x_mp5.reload_speed_multiplier = 0.8 --3.3/4s
		self.x_mp5.swap_speed_multiplier = 0.9

	--Medium SMG (Primary)
		--AK GEN 21 Tactical
		self.vityaz.tactical_reload = true
		self.vityaz.use_data.selection_index = 2
		self.vityaz.kick = self.stat_info.kick_tables.right_recoil
		self.vityaz.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.vityaz.supported = true
		self.vityaz.stats = {
			damage = 24,
			spread = 15,
			recoil = 14,
			concealment = 17
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
			concealment = 15
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
			concealment = 18
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
			concealment = 18
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
			concealment = 17
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
			concealment = 17
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

		--Wasp-Ds Smg
		self.fmg9.fire_rate_multiplier = 0.9 --1200 rpm
		self.fmg9.CLIP_AMMO_MAX = 33
		self.fmg9.kick = self.stat_info.kick_tables.moderate_left_kick
		self.fmg9.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.fmg9.tactical_reload = true
		self.fmg9.supported = true
		self.fmg9.stats = {
			damage = 24,
			spread = 10,
			recoil = 10,
			concealment = 21
		}
		self.fmg9.timers = {
			reload_not_empty = 2.6,
			reload_empty = 4.3,
			reload_operational = 1.9,
			empty_reload_operational = 3.65,
			reload_interrupt = 0.42,
			empty_reload_interrupt = 0.3,
			unequip = 1.8,
			equip = 1.4
		}

	--Heavy SMG (Primary)
		--Jackal
		self.schakal.use_data.selection_index = 2
		self.schakal.fire_rate_multiplier = 0.92 --600 rpm
		self.schakal.CLIP_AMMO_MAX = 25
		self.schakal.BURST_COUNT = 3
		self.schakal.ADAPTIVE_BURST_SIZE = false
		self.schakal.kick = self.stat_info.kick_tables.even_recoil
		self.schakal.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.schakal.supported = true
		self.schakal.stats = {
			damage = 30,
			spread = 14,
			recoil = 15,
			concealment = 16
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
		self.polymer.BURST_COUNT = 3
		self.polymer.ADAPTIVE_BURST_SIZE = false
		self.polymer.kick = self.stat_info.kick_tables.even_recoil
		self.polymer.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.polymer.supported = true
		self.polymer.stats = {
			damage = 30,
			spread = 8,
			recoil = 15,
			concealment = 16
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
			concealment = 15
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
			concealment = 19
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
			concealment = 17
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
		self.beer.BURST_COUNT = 3
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
			concealment = 18
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
			concealment = 20
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
			concealment = 19
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
			concealment = 19
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
			concealment = 21
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
			spread = 16,
			recoil = 13,
			concealment = 20
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

		--Maxim 9
		self.maxim9.kick = self.stat_info.kick_tables.left_recoil
		self.maxim9.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.maxim9.tactical_reload = true
		self.maxim9.supported = true
		self.maxim9.stats = {
			damage = 20,
			spread = 17,
			recoil = 20,
			concealment = 20,
			alert_size = 1
		}
		self.maxim9.timers = {
			reload_not_empty = 2.0,
			reload_empty = 2.4,
			reload_operational = 1.45,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.5,
			equip = 0.35
		}

	--Light Pistol (Akimbo)
		--Akimbo Chimano 88
		self.x_g17.kick = self.glock_17.kick
		self.x_g17.kick_pattern = self.glock_17.kick_pattern
		self.x_g17.CLIP_AMMO_MAX = self.glock_17.CLIP_AMMO_MAX * 2
		self.x_g17.fire_mode_data.fire_rate = self.glock_17.fire_mode_data.fire_rate
		self.x_g17.single.fire_rate = self.glock_17.single.fire_rate
		self.x_g17.BURST_COUNT = 2
		self.x_g17.ADAPTIVE_BURST_SIZE = true
		self.x_g17.FIRE_MODE = "burst"
		self.x_g17.supported = true
		self.x_g17.stats = {
			damage = 20,
			spread = 15,
			recoil = 14,
			concealment = 19
		}
		self.x_g17.timers = {
			reload_not_empty = 3.7,
			reload_empty = 4.15,
			reload_operational = 3.1,
			empty_reload_operational = 4.03,
			half_reload_operational = 1.8,
			empty_half_reload_operational = 3.97,
			reload_interrupt = 0.35,
			empty_reload_interrupt = 0.35,
			unequip = 0.5,
			equip = 0.5
		}

		--Akimbo Bernetti 9
		self.x_b92fs.kick = self.b92fs.kick
		self.x_b92fs.kick_pattern = self.b92fs.kick_pattern
		self.x_b92fs.FIRE_MODE = "burst"
		self.x_b92fs.BURST_COUNT = 2
		self.x_b92fs.ADAPTIVE_BURST_SIZE = true
		self.x_b92fs.CLIP_AMMO_MAX = self.b92fs.CLIP_AMMO_MAX * 2
		self.x_b92fs.fire_mode_data.fire_rate = self.b92fs.fire_mode_data.fire_rate
		self.x_b92fs.single.fire_rate = self.b92fs.single.fire_rate
		self.x_b92fs.supported = true
		self.x_b92fs.stats = {
			damage = 20,
			spread = 17,
			recoil = 17,
			concealment = 17
		}
		self.x_b92fs.timers = {
			reload_not_empty = 3.7,
			reload_empty = 4.15,
			reload_operational = 3.1,
			empty_reload_operational = 4.03,
			half_reload_operational = 1.8,
			empty_half_reload_operational = 3.97,
			reload_interrupt = 0.35,
			empty_reload_interrupt = 0.35,
			unequip = 0.5,
			equip = 0.5
		}
		self.x_b92fs.reload_speed_multiplier = 0.9 --4.1/4.6s

		--Akimbo Chimano Compact
		self.jowi.kick = self.g26.kick
		self.jowi.kick_pattern = self.g26.kick_pattern
		self.jowi.fire_mode_data.fire_rate = self.g26.fire_mode_data.fire_rate
		self.jowi.single.fire_rate = self.g26.single.fire_rate
		self.jowi.CLIP_AMMO_MAX = self.g26.CLIP_AMMO_MAX * 2
		self.jowi.BURST_COUNT = 2
		self.jowi.ADAPTIVE_BURST_SIZE = true
		self.jowi.FIRE_MODE = "burst"
		self.jowi.supported = true
		self.jowi.stats = {
			damage = 20,
			spread = 19,
			recoil = 20,
			concealment = 20
		}
		self.jowi.timers = {
			reload_not_empty = 3.7,
			reload_empty = 4.15,
			reload_operational = 3.1,
			empty_reload_operational = 4.03,
			half_reload_operational = 1.8,
			empty_half_reload_operational = 3.97,
			reload_interrupt = 0.35,
			empty_reload_interrupt = 0.35,
			unequip = 0.5,
			equip = 0.5
		}
		self.jowi.reload_speed_multiplier = 1.1 --3.4/3.8s

		--Akimbo Stryk18c
		self.x_g18c.fire_mode_data.fire_rate = self.glock_18c.fire_mode_data.fire_rate
		self.x_g18c.single.fire_rate = self.glock_18c.auto.fire_rate
		self.x_g18c.fire_rate_multiplier = self.glock_18c.fire_rate_multiplier
		self.x_g18c.CLIP_AMMO_MAX = self.glock_18c.CLIP_AMMO_MAX * 2
		self.x_g18c.kick = self.glock_18c.kick
		self.x_g18c.kick_pattern = self.glock_18c.kick_pattern
		self.x_g18c.BURST_COUNT = 2
		self.x_g18c.ADAPTIVE_BURST_SIZE = true
		self.x_g18c.supported = true
		self.x_g18c.stats = {
			damage = 20,
			spread = 11,
			recoil = 8,
			concealment = 19
		}
		self.x_g18c.timers = {
			reload_not_empty = 3.7,
			reload_empty = 4.15,
			reload_operational = 3.1,
			empty_reload_operational = 4.03,
			half_reload_operational = 1.8,
			empty_half_reload_operational = 3.97,
			reload_interrupt = 0.35,
			empty_reload_interrupt = 0.35,
			unequip = 0.5,
			equip = 0.5
		}

	--Medium Pistol (Primary)
		--Czech 92
		self.czech.use_data.selection_index = 2
		self.czech.fire_mode_data.fire_rate = 0.06
		self.czech.kick = self.stat_info.kick_tables.left_recoil
		self.czech.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.czech.supported = true
		self.czech.stats = {
			damage = 24,
			spread = 14,
			recoil = 12,
			concealment = 19
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

		--Kang Arms Model 54
		--TODO: Still very buggy/crashy.
		self.type54.use_data.selection_index = 2
		self.type54.kick = self.stat_info.kick_tables.left_recoil
		self.type54.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.type54.supported = false
		self.type54.CLIP_AMMO_MAX = 8
		self.type54.tactical_reload = true
		self.type54.stats = {
			damage = 24,
			spread = 21,
			recoil = 21,
			concealment = 21
		}
		self.type54.timers = {
			reload_not_empty = 2.0,
			reload_empty = 2.4,
			reload_operational = 1.45,
			empty_reload_operational = 2.1,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.5,
			equip = 0.35
		}
		self.type54.reload_speed_multiplier = 1.2 --1.7/2s
		self.type54_underbarrel.use_data.selection_index = 4
		self.type54_underbarrel.supported = false
		self.type54_underbarrel.AMMO_MAX = 15
		self.type54_underbarrel.stats = {
			damage = 16,
			spread = 16,
			recoil = 5,
			concealment = 21
		}
		self.type54_underbarrel.timers = {
			reload_not_empty = 2,
			reload_empty = 2,
			reload_operational = 1.78,
			empty_reload_operational = 1.78,
			reload_interrupt = 0.4,
			empty_reload_interrupt = 0.4,
			unequip = 0.6,
			equip = 0.6,
			equip_underbarrel = 0.4,
			unequip_underbarrel = 0.4
		}

	--Medium Pistol (Secondary)
		--Gruber Kurz
		self.ppk.CLIP_AMMO_MAX = 9
		self.ppk.kick = self.stat_info.kick_tables.right_recoil
		self.ppk.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.ppk.supported = true
		self.ppk.stats = {
			damage = 24,
			spread = 19,
			recoil = 18,
			concealment = 21
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
			spread = 16,
			recoil = 19,
			concealment = 19
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
			spread = 17,
			recoil = 18,
			concealment = 19
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
			spread = 18,
			recoil = 16,
			concealment = 21
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
			spread = 15,
			recoil = 21,
			concealment = 19
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
			spread = 13,
			recoil = 15,
			concealment = 17
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

	--Medium Pistol (Akimbo)
		--Akimbo M13 Pistols
		self.x_legacy.global_value = nil --Allows for the akimbo skill requirement text to appear
		self.x_legacy.fire_mode_data.fire_rate = self.legacy.fire_mode_data.fire_rate
		self.x_legacy.single.fire_rate = self.legacy.single.fire_rate
		self.x_legacy.kick = self.legacy.kick
		self.x_legacy.kick_pattern = self.legacy.kick_pattern
		self.x_legacy.CLIP_AMMO_MAX = self.legacy.CLIP_AMMO_MAX * 2
		self.x_legacy.BURST_COUNT = 2
		self.x_legacy.ADAPTIVE_BURST_SIZE = true
		self.x_legacy.FIRE_MODE = "burst"
		self.x_legacy.supported = true
		self.x_legacy.stats = {
			damage = 24,
			spread = 15,
			recoil = 11,
			concealment = 20
		}
		self.x_legacy.timers = {
			reload_not_empty = 3.7,
			reload_empty = 4.15,
			reload_operational = 3.1,
			empty_reload_operational = 4.03,
			half_reload_operational = 1.8,
			empty_half_reload_operational = 3.97,
			reload_interrupt = 0.35,
			empty_reload_interrupt = 0.35,
			unequip = 0.5,
			equip = 0.5
		}
		self.x_legacy.reload_speed_multiplier = 0.95 --3.9/4.4s

		--Akimbo White Streak
		self.x_pl14.fire_mode_data.fire_rate = self.pl14.fire_mode_data.fire_rate
		self.x_pl14.single.fire_rate = self.pl14.single.fire_rate
		self.x_pl14.CLIP_AMMO_MAX = self.pl14.CLIP_AMMO_MAX * 2
		self.x_pl14.BURST_COUNT = 2
		self.x_pl14.ADAPTIVE_BURST_SIZE = true
		self.x_pl14.FIRE_MODE = "burst"
		self.x_pl14.kick = self.pl14.kick
		self.x_pl14.kick_pattern = self.pl14.kick_pattern
		self.x_pl14.supported = true
		self.x_pl14.stats = {
			damage = 24,
			spread = 13,
			recoil = 15,
			concealment = 17
		}
		self.x_pl14.timers = {
			reload_not_empty = 3.7,
			reload_empty = 4.15,
			reload_operational = 3.1,
			empty_reload_operational = 4.03,
			half_reload_operational = 1.8,
			empty_half_reload_operational = 3.97,
			reload_interrupt = 0.35,
			empty_reload_interrupt = 0.35,
			unequip = 0.5,
			equip = 0.5
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
			concealment = 19
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
		self.c96.FIRE_MODE = "auto"
		self.c96.CAN_TOGGLE_FIREMODE = true
		self.c96.fire_mode_data.fire_rate = 0.06 --1000 rpm
		self.c96.single.fire_rate = 0.06 --1000 rpm
		self.c96.kick = self.stat_info.kick_tables.even_recoil
		self.c96.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.c96.supported = true
		self.c96.stats = {
			damage = 30,
			spread = 17,
			recoil = 17,
			concealment = 19
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
			spread = 14,
			recoil = 18,
			concealment = 19
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
			spread = 16,
			recoil = 16,
			concealment = 19
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
			spread = 17,
			recoil = 13,
			concealment = 20
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
			spread = 18,
			recoil = 15,
			concealment = 21
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
		self.shrew.reload_speed_multiplier = 1.15 --1.9/2.3s

	--Heavy Pistol (Akimbo)
		--Akimbo Chimano Custom
		self.x_g22c.kick = self.g22c.kick
		self.x_g22c.kick_pattern = self.g22c.kick_pattern
		self.x_g22c.CLIP_AMMO_MAX = self.g22c.CLIP_AMMO_MAX * 2
		self.x_g22c.BURST_COUNT = 2
		self.x_g22c.ADAPTIVE_BURST_SIZE = true
		self.x_g22c.FIRE_MODE = "burst"
		self.x_g22c.fire_mode_data.fire_rate = self.g22c.fire_mode_data.fire_rate
		self.x_g22c.single.fire_rate = self.g22c.single.fire_rate
		self.x_g22c.supported = true
		self.x_g22c.stats = {
			damage = 30,
			spread = 13,
			recoil = 9,
			concealment = 19
		}
		self.x_g22c.timers = {
			reload_not_empty = 3.7,
			reload_empty = 4.15,
			reload_operational = 3.1,
			empty_reload_operational = 4.03,
			half_reload_operational = 1.8,
			empty_half_reload_operational = 3.97,
			reload_interrupt = 0.35,
			empty_reload_interrupt = 0.35,
			unequip = 0.5,
			equip = 0.5
		}

	--Light HandCannon (Secondary)
		--Interceptor .45
		self.usp.CLIP_AMMO_MAX = 12
		self.usp.kick = self.stat_info.kick_tables.right_recoil
		self.usp.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.usp.supported = true
		self.usp.stats = {
			damage = 45,
			spread = 15,
			recoil = 11,
			concealment = 19
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
			spread = 17,
			recoil = 11,
			concealment = 19
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
		self.m1911.tactical_reload = true
		self.m1911.fire_mode_data.fire_rate = 0.125
		self.m1911.single.fire_rate = 0.125
		self.m1911.CLIP_AMMO_MAX = 8
		self.m1911.kick = self.stat_info.kick_tables.even_recoil
		self.m1911.kick_pattern = self.stat_info.kick_patterns.random
		self.m1911.supported = true
		self.m1911.stats = {
			damage = 45,
			spread = 16,
			recoil = 10,
			concealment = 19
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
			spread = 15,
			recoil = 10,
			concealment = 21
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
			spread = 11,
			recoil = 14,
			concealment = 20
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

	--Light Handcannons (Akimbo)
		--Akimbo Interceptor .45
		self.x_usp.kick = self.stat_info.kick_tables.right_recoil
		self.x_usp.kick_pattern = self.usp.kick_pattern
		self.x_usp.CLIP_AMMO_MAX = self.usp.CLIP_AMMO_MAX * 2
		self.x_usp.fire_mode_data.fire_rate = self.usp.fire_mode_data.fire_rate
		self.x_usp.single.fire_rate = self.usp.single.fire_rate
		self.x_usp.BURST_COUNT = 2
		self.x_usp.ADAPTIVE_BURST_SIZE = true
		self.x_usp.FIRE_MODE = "burst"
		self.x_usp.supported = true
		self.x_usp.stats = {
			damage = 45,
			spread = 11,
			recoil = 7,
			concealment = 17
		}
		self.x_usp.timers = {
			reload_not_empty = 3.7,
			reload_empty = 4.15,
			reload_operational = 3.1,
			empty_reload_operational = 4.03,
			half_reload_operational = 1.8,
			empty_half_reload_operational = 3.97,
			reload_interrupt = 0.35,
			empty_reload_interrupt = 0.35,
			unequip = 0.5,
			equip = 0.5
		}
		self.x_usp.swap_speed_multiplier = 0.85
		self.x_usp.reload_speed_multiplier = 0.85 --4.4/4.9s

		--Akimbo Crosskill
		self.x_1911.CLIP_AMMO_MAX = self.colt_1911.CLIP_AMMO_MAX * 2
		self.x_1911.fire_mode_data.fire_rate = self.colt_1911.fire_mode_data.fire_rate
		self.x_1911.single.fire_rate = self.colt_1911.single.fire_rate
		self.x_1911.kick = self.colt_1911.kick
		self.x_1911.kick_pattern = self.colt_1911.kick_pattern
		self.x_1911.BURST_COUNT = 2
		self.x_1911.ADAPTIVE_BURST_SIZE = true
		self.x_1911.FIRE_MODE = "burst"
		self.x_1911.supported = true
		self.x_1911.stats = {
			damage = 45,
			spread = 13,
			recoil = 7,
			concealment = 17
		}
		self.x_1911.timers = {
			reload_not_empty = 3.7,
			reload_empty = 4.15,
			reload_operational = 3.1,
			empty_reload_operational = 4.03,
			half_reload_operational = 1.8,
			empty_half_reload_operational = 3.97,
			reload_interrupt = 0.35,
			empty_reload_interrupt = 0.35,
			unequip = 0.5,
			equip = 0.5
		}

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
			spread = 19,
			recoil = 7,
			concealment = 18
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
			spread = 16,
			recoil = 9,
			concealment = 20
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
			concealment = 19
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
			concealment = 18
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
			spread = 14,
			recoil = 13,
			concealment = 21
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

	--Medium Handcannons (Akimbo)
		--Akimbo Castigo
		self.x_chinchilla.fire_mode_data.fire_rate = self.chinchilla.fire_mode_data.fire_rate
		self.x_chinchilla.single.fire_rate = self.chinchilla.single.fire_rate
		self.x_chinchilla.kick = self.chinchilla.kick
		self.x_chinchilla.kick_pattern = self.chinchilla.kick_pattern
		self.x_chinchilla.BURST_COUNT = 2
		self.x_chinchilla.ADAPTIVE_BURST_SIZE = true
		self.x_chinchilla.FIRE_MODE = "burst"
		self.x_chinchilla.supported = true
		self.x_chinchilla.stats = {
			damage = 60,
			spread = 17,
			recoil = 6,
			concealment = 17
		}
		self.x_chinchilla.timers = {
			reload_not_empty = 3.74,
			reload_empty = 3.74,
			reload_operational = 3.54,
			empty_reload_operational = 3.54,
			half_reload_operational = 3.46,
			empty_half_reload_operational = 3.46,
			reload_interrupt = 0.28,
			empty_reload_interrupt = 0.28,
			unequip = 0.5,
			equip = 0.5
		}
		self.x_chinchilla.reload_speed_multiplier = 0.85 --4.4s

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
			concealment = 17
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
			spread = 14,
			recoil = 7,
			concealment = 17
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
			spread = 18,
			recoil = 8,
			concealment = 19
		}
		self.peacemaker.timers = {
			shotgun_reload_enter = 1.4333333333333333,
			shotgun_reload_exit_empty = 0.3333333333333333,
			shotgun_reload_exit_not_empty = 0.3333333333333333,
			shotgun_reload_shell = 1,
			shotgun_reload_first_shell_offset = 0.5,
			shotgun_reload_interrupt = 0.47,
			unequip = 0.65,
			equip = 0.65
		}
		self.peacemaker.swap_speed_multiplier = 0.65

	--Grenade Launchers (Primary)
		--GL 40
		self.gre_m79.desc_id = "bm_40mm_weapon_sc_desc"
		self.gre_m79.has_description = true
		self.gre_m79.fire_mode_data.fire_rate = 0.3
		self.gre_m79.fire_rate_multiplier = 0.6 --120 rpm.
		self.gre_m79.kick = self.stat_info.kick_tables.vertical_kick
		self.gre_m79.kick_pattern = self.stat_info.kick_patterns.random
		self.gre_m79.supported = true
		self.gre_m79.stats = {
			damage = 40,
			spread = 18,
			recoil = 10,
			concealment = 15
		}
		self.gre_m79.timers = {
			reload_not_empty = 3.2,
			reload_empty = 3.2,
			reload_operational = 3.2,
			empty_reload_operational = 3.2,
			reload_interrupt = 0.55,
			empty_reload_interrupt = 0.55,
			equip = 0.6,
			unequip = 0.6
		}
		self.gre_m79.stats_modifiers = {damage = 10}

		--Piglet	
		self.m32.desc_id = "bm_40mm_weapon_sc_desc"
		self.m32.has_description = true
		self.m32.kick = self.stat_info.kick_tables.right_kick
		self.m32.kick_pattern = self.stat_info.kick_patterns.random
		self.m32.fire_mode_data.fire_rate = 0.4
		self.m32.single.fire_rate = 0.4 --150 rpm.
		self.m32.supported = true
		self.m32.stats = {
			damage = 40,
			spread = 12,
			recoil = 10,
			concealment = 7
		}
		self.m32.stats_modifiers = {damage = 10}
		self.m32.timers = {
			shotgun_reload_enter = 1.96,
			shotgun_reload_exit_empty = 0.75,
			shotgun_reload_exit_not_empty = 0.75,
			shotgun_reload_shell = 2,
			shotgun_reload_first_shell_offset = 1,
			shotgun_reload_interrupt = 1.15,
			unequip = 0.85,
			equip = 0.85
		}
		self.m32.swap_speed_multiplier = 1.2
		self.m32.reload_speed_multiplier = 1.2

	--Grenade Launchers (Secondary)
		--Compact 40mm
		self.slap.desc_id = "bm_40mm_weapon_sc_desc"
		self.slap.has_description = true
		self.slap.fire_mode_data.fire_rate = 0.5
		self.slap.single.fire_rate = 0.5
		self.slap.kick = self.stat_info.kick_tables.moderate_kick
		self.slap.kick_pattern = self.stat_info.kick_patterns.random
		self.slap.supported = true
		self.slap.stats = {
			damage = 40,
			spread = 16,
			recoil = 10,
			concealment = 15
		}
		self.slap.timers = {
			reload_not_empty = 4,
			reload_empty = 4,
			reload_operational = 3.2,
			empty_reload_operational = 3.2,
			reload_interrupt = 0.55,
			empty_reload_interrupt = 0.55,
			equip = 0.6,
			unequip = 0.6
		}
		self.slap.reload_speed_multiplier = 1.1 --3.6s
		self.slap.swap_speed_multiplier = 1.25
		self.slap.stats_modifiers = {damage = 10}

		--China Puff
		self.china.desc_id = "bm_40mm_weapon_sc_desc"
		self.china.has_description = true
		self.china.fire_rate_multiplier = 0.8 --40 rpm
		self.china.kick = self.stat_info.kick_tables.vertical_kick
		self.china.kick_pattern = self.stat_info.kick_patterns.random
		self.china.supported = true
		self.china.tactical_reload = true
		self.china.stats = {
			damage = 40,
			spread = 9,
			recoil = 7,
			concealment = 11
		}
		self.china.stats_modifiers = {damage = 10}
		self.china.timers = {
			shotgun_reload_enter = 0.83,
			shotgun_reload_exit_empty = 1.1,
			shotgun_reload_exit_not_empty = 0.45,
			shotgun_reload_shell = 0.83,
			shotgun_reload_first_shell_offset = 0.5,
			shotgun_reload_interrupt = 0.97,
			unequip = 0.6,
			equip = 0.9
		}
		self.china.reload_speed_multiplier = 0.85 --5.8s
		self.china.swap_speed_multiplier = 0.95

		--Arbiter
		self.arbiter.fire_mode_data.fire_rate = 0.4
		self.arbiter.single.fire_rate = 0.4
		self.arbiter.CLIP_AMMO_MAX = 5
		self.arbiter.tactical_reload = true
		self.arbiter.kick = self.stat_info.kick_tables.vertical_kick
		self.arbiter.kick_pattern = self.stat_info.kick_patterns.random
		self.arbiter.supported = true
		self.arbiter.stats = {
			damage = 30,
			spread = 9,
			recoil = 5,
			concealment = 7
		}
		self.arbiter.timers = {
			reload_not_empty = 4.1,
			reload_empty = 4.9,
			reload_operational = 3.34,
			empty_reload_operational = 4.5,
			reload_interrupt = 0.85,
			empty_reload_interrupt = 0.85,
			unequip = 0.6,
			equip = 0.6
		}
		self.arbiter.stats_modifiers = {damage = 10}
		self.arbiter.reload_speed_multiplier = 0.85
		self.arbiter.swap_speed_multiplier = 0.7

	--Rocket Launchers (Primary)
		--Commando 101
		self.ray.use_data.selection_index = 2
		self.ray.has_description = true
		self.ray.desc_id = "bm_rocket_launcher_sc_desc"
		self.ray.turret_instakill = true
		self.ray.kick = self.stat_info.kick_tables.even_recoil
		self.ray.kick_pattern = self.stat_info.kick_patterns.random
		self.ray.fire_mode_data.fire_rate = 0.5
		self.ray.fire_rate_multiplier = 0.75 --80 rpm
		self.ray.supported = true
		self.ray.stats = {
			damage = 60,
			spread = 6,
			recoil = 21,
			concealment = 5
		}
		self.ray.timers = {
			reload_not_empty = 7.5,
			reload_empty = 7.5,
			empty_reload_operational = 6,
			reload_operational = 6,
			reload_interrupt = 1,
			empty_reload_interrupt = 1,
			unequip = 0.85,
			equip = 0.85
		}
		self.ray.stats_modifiers = {damage = 10}
		self.ray.swap_speed_multiplier = 1.2

	--Rocket Launchers (Secondary)
		--HRL-7
		self.rpg7.kick = self.stat_info.kick_tables.even_recoil
		self.rpg7.kick_pattern = self.stat_info.kick_patterns.random
		self.rpg7.has_description = true
		self.rpg7.desc_id = "bm_rocket_launcher_sc_desc"
		self.rpg7.turret_instakill = true
		self.rpg7.fire_mode_data.fire_rate = 0.75
		self.rpg7.supported = true
		self.rpg7.stats = {
			damage = 60,
			spread = 10,
			recoil = 17,
			concealment = 6
		}
		self.rpg7.timers = {
			reload_not_empty = 5.6,
			reload_empty = 5.6,
			reload_operational = 4.7,
			empty_reload_operational = 4.7,
			reload_interrupt = 1.4,
			empty_reload_interrupt = 1.4,
			equip = 0.85,
			unequip = 0.85
		}
		self.rpg7.stats_modifiers = {damage = 10}
		self.rpg7.swap_speed_multiplier = 1.25
		self.rpg7.reload_speed_multiplier = 1.1

	--Crossbows (Primary)
		--Airbow
		self.ecp.has_description = true
		self.ecp.desc_id = "bm_ap_3_weapon_sc_desc"
		self.ecp.kick = self.stat_info.kick_tables.right_kick
		self.ecp.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.ecp.supported = true
		self.ecp.stats = {
			damage = 135,
			spread = 14,
			recoil = 16,
			concealment = 11,
			alert_size = 2
		}
		self.ecp.timers = {
			reload_not_empty = 3.6,
			reload_empty = 3.6,
			reload_operational = 3,
			empty_reload_operational = 3,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.7,
			equip = 0.5
		}

		--Heavy Crossbow
		self.arblast.has_description = true
		self.arblast.desc_id = "bm_ap_3_weapon_sc_desc"
		self.arblast.single.fire_rate = 0.5
		self.arblast.fire_mode_data.fire_rate = 0.5
		self.arblast.kick = self.stat_info.kick_tables.horizontal_recoil
		self.arblast.kick_pattern = self.stat_info.kick_patterns.random
		self.arblast.supported = true
		self.arblast.stats = {
			damage = 180,
			spread = 21,
			recoil = 21,
			concealment = 14,
			alert_size = 2
		}
		self.arblast.timers = {
			reload_empty = 3.8,
			reload_not_empty = 3.8,
			reload_operational = 2.5,
			empty_reload_operational = 2.5,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.7,
			equip = 0.5
		}
		self.arblast.crossbow_string_time = 0.067
		self.arblast.reload_speed_multiplier = 1.2666 --3s

		--Light Crossbow
		self.frankish.has_description = true
		self.frankish.desc_id = "bm_ap_3_weapon_sc_desc"
		self.frankish.single.fire_rate = 0.5
		self.frankish.fire_mode_data.fire_rate = 0.5
		self.frankish.kick = self.stat_info.kick_tables.horizontal_recoil
		self.frankish.kick_pattern = self.stat_info.kick_patterns.random
		self.frankish.supported = true
		self.frankish.stats = {
			damage = 135,
			spread = 21,
			recoil = 21,
			concealment = 15,
			alert_size = 2
		}
		self.frankish.timers = {
			reload_not_empty = 2,
			reload_empty = 2,
			reload_operational = 1.6,
			empty_reload_operational = 1.6,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.7,
			equip = 0.5
		}
		self.frankish.crossbow_string_time = 0.067
		self.frankish.reload_speed_multiplier = 1.25 --1.6s

	--Crossbows (Secondary)
		--Pistol Crossbow
		self.hunter.has_description = true
		self.hunter.desc_id = "bm_ap_3_weapon_sc_desc"
		self.hunter.single.fire_rate = 0.5
		self.hunter.fire_mode_data.fire_rate = 0.5
		self.hunter.kick = self.stat_info.kick_tables.horizontal_recoil
		self.hunter.kick_pattern = self.stat_info.kick_patterns.random
		self.hunter.supported = true
		self.hunter.stats = {
			damage = 135,
			spread = 16,
			recoil = 21,
			concealment = 20,
			alert_size = 2,
			reload = 20
		}
		self.hunter.timers = {
			reload_not_empty = 1.6,
			reload_empty = 1.6,
			reload_operational = 1.2,
			empty_reload_operational = 1.2,
			reload_interrupt = 0.27,
			empty_reload_interrupt = 0.27,
			unequip = 0.55,
			equip = 0.5
		}
		self.hunter.crossbow_string_time = 0.067

	--Bows (Primary)
		--Plainsrider bow.
		self.plainsrider.has_description = true
		self.plainsrider.desc_id = "bm_ap_2_weapon_sc_desc"
		self.plainsrider.kick = self.stat_info.kick_tables.none
		self.plainsrider.kick_pattern = self.stat_info.kick_patterns.random
		self.plainsrider.supported = true
		self.plainsrider.fire_mode_data.fire_rate = 0.1
		self.plainsrider.single.fire_rate = 0.1
		self.plainsrider.stats = {
			damage = 135,
			spread = 20,
			recoil = 21,
			concealment = 15,
			alert_size = 2
		}
		self.plainsrider.timers = {
			reload_operational = 0.65,
			empty_reload_operational = 0.65,
			reload_not_empty = 0.8,
			reload_empty = 0.8,
			reload_interrupt = 0,
			empty_reload_interrupt = 0,
			equip = 0.4,
			unequip = 0.4
		}
		self.plainsrider.charge_speed = 0.8
		self.plainsrider.fire_rate_multiplier = 0.5
		self.plainsrider.reload_speed_multiplier = 1.33333

		--English Longbow
		self.long.has_description = true
		self.long.desc_id = "bm_ap_2_weapon_sc_desc"
		self.long.kick = self.stat_info.kick_tables.none
		self.long.kick_pattern = self.stat_info.kick_patterns.random
		self.long.supported = true
		self.long.charge_speed = 1
		self.long.fire_mode_data.fire_rate = 0.14
		self.long.single.fire_rate = 0.14
		self.long.stats = {
			damage = 180,
			spread = 21,
			recoil = 21,
			concealment = 14,
			alert_size = 2
		}
		self.long.timers = {
			reload_operational = 0.9,
			empty_reload_operational = 0.9,
			reload_not_empty = 1.5,
			reload_empty = 1.5,
			reload_interrupt = 0,
			empty_reload_interrupt = 0,
			equip = 0.5,
			unequip = 0.5
		}
		self.long.fire_rate_multiplier = 0.5
		self.long.reload_speed_multiplier = 1.4

		--DECA Technologies Compound Bow
		self.elastic.has_description = true
		self.elastic.desc_id = "bm_ap_2_weapon_sc_desc"
		self.elastic.kick = self.stat_info.kick_tables.none
		self.elastic.kick_pattern = self.stat_info.kick_patterns.random
		self.elastic.supported = true
		self.elastic.charge_speed = 0.9
		self.elastic.fire_mode_data.fire_rate = 1
		self.elastic.single.fire_rate = 1
		self.elastic.stats = {
			damage = 180,
			spread = 21,
			recoil = 21,
			concealment = 13,
			alert_size = 2
		}
		self.elastic.timers = {
			reload_operational = 1.15,
			empty_reload_operational = 1.15,
			reload_not_empty = 1.3,
			reload_empty = 1.3,
			reload_interrupt = 0,
			empty_reload_interrupt = 0,
			unequip = 0.7,
			equip = 0.7
		}
		self.elastic.fire_rate_multiplier = 1.25
		self.elastic.reload_speed_multiplier = 2

	--Light Shotgun (Primary)
		--Steakout
		self.aa12.CLIP_AMMO_MAX = 10
		self.aa12.kick = self.stat_info.kick_tables.vertical_kick
		self.aa12.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.aa12.FIRE_MODE = "auto"
		self.aa12.CAN_TOGGLE_FIREMODE = false
		self.aa12.supported = true
		self.aa12.stats = {
			damage = 8,
			spread = 10,
			recoil = 13,
			concealment = 11
		}
		self.aa12.timers = {
			reload_not_empty = 3.8,
			reload_empty = 5.2,
			reload_operational = 3,
			empty_reload_operational = 4.1,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.55,
			equip = 0.55
		}

		--Izhma 12G
		self.saiga.rays = 9
		self.saiga.muzzleflash = "effects/particles/shotgun/shotgun_gen"
		self.saiga.CLIP_AMMO_MAX = 5
		self.saiga.fire_mode_data.fire_rate = 0.1
		self.saiga.auto.fire_rate = 0.1
		self.saiga.kick = self.stat_info.kick_tables.right_kick
		self.saiga.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.saiga.supported = true
		self.saiga.stats = {
			damage = 8,
			spread = 14,
			recoil = 9,
			concealment = 16
		}
		self.saiga.timers = {
			reload_not_empty = 3.3,
			reload_empty = 4.5,
			reload_operational = 2.65,
			empty_reload_operational = 3.95,
			reload_interrupt = 0.5,
			empty_reload_interrupt = 0.5,
			unequip = 0.6,
			equip = 0.6
		}
		self.saiga.reload_speed_multiplier = 1.2 --2.2/3

		--Predator 12g
		self.spas12.muzzleflash = "effects/particles/shotgun/shotgun_gen"
		self.spas12.CLIP_AMMO_MAX = 6
		self.spas12.fire_mode_data.fire_rate = 0.175
		self.spas12.single.fire_rate = 0.175
		self.spas12.fire_rate_multiplier = 1.166 --400 rpm
		self.spas12.kick = self.stat_info.kick_tables.left_kick
		self.spas12.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.spas12.supported = true
		self.spas12.stats = {
			damage = 8,
			spread = 15,
			recoil = 12,
			concealment = 14
		}
		self.spas12.timers = {
			shotgun_reload_enter = 0.3,
			shotgun_reload_exit_empty = 1.2,
			shotgun_reload_exit_not_empty = 0.2,
			shotgun_reload_shell = 0.57,
			shotgun_reload_first_shell_offset = 0.33,
			shotgun_reload_interrupt = 0.4,
			unequip = 0.55,
			equip = 0.85
		}
		self.spas12.reload_speed_multiplier = 1.1

		--M1014
		self.benelli.CLIP_AMMO_MAX = 7
		self.benelli.muzzleflash = "effects/particles/shotgun/shotgun_gen"
		self.benelli.fire_mode_data.fire_rate = 0.175
		self.benelli.single.fire_rate = 0.175
		self.benelli.fire_rate_multiplier = 1.166 --400 rpm
		self.benelli.kick = self.stat_info.kick_tables.moderate_kick
		self.benelli.kick_pattern = self.stat_info.kick_patterns.jumpy_2
		self.benelli.supported = true
		self.benelli.stats = {
			damage = 8,
			spread = 14,
			recoil = 10,
			concealment = 15
		}
		self.benelli.timers = {
			shotgun_reload_enter = 0.3,
			shotgun_reload_exit_empty = 1.2,
			shotgun_reload_exit_not_empty = 0.2,
			shotgun_reload_shell = 0.57,
			shotgun_reload_first_shell_offset = 0.33,
			shotgun_reload_interrupt = 0.4,
			unequip = 0.55,
			equip = 0.85
		}
		self.benelli.reload_speed_multiplier = 1.1

		--Street Sweeper
		self.striker.use_data.selection_index = 2
		self.striker.muzzleflash = "effects/particles/shotgun/shotgun_gen"
		self.striker.fire_mode_data.fire_rate = 0.175
		self.striker.single.fire_rate = 0.175
		self.striker.fire_rate_multiplier = 1.312 --450 rpm
		self.striker.kick = self.stat_info.kick_tables.right_kick
		self.striker.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.striker.supported = true
		self.striker.stats = {
			damage = 8,
			spread = 9,
			recoil = 14,
			concealment = 12
		}
		self.striker.timers = {
			shotgun_reload_enter = 0.5333333333333333,
			shotgun_reload_exit_empty = 0.4,
			shotgun_reload_exit_not_empty = 0.4,
			shotgun_reload_shell = 0.6,
			shotgun_reload_first_shell_offset = 0.4,
			shotgun_reload_interrupt = 0.55,
			unequip = 0.6,
			equip = 0.85
		}
		self.striker.reload_speed_multiplier = 0.85

	--Light Shotgun (Akimbo)
		--Brothers Grimm
		self.x_basset.CLIP_AMMO_MAX = 10
		self.x_basset.kick = self.stat_info.kick_tables.right_kick
		self.x_basset.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.x_basset.BURST_COUNT = 2
		self.x_basset.ADAPTIVE_BURST_SIZE = true
		self.x_basset.fire_mode_data.fire_rate = 0.2
		self.x_basset.single.fire_rate = 0.2 --300 rpm, 600 rpm introduces audio issues on the Grimms
		self.x_basset.supported = true
		self.x_basset.stats = {
			damage = 8,
			spread = 9,
			recoil = 5,
			concealment = 13
		}
		self.x_basset.timers = {
			reload_not_empty = 3.6,
			reload_empty = 3.9,
			half_reload_operational = 1.7,
			empty_half_reload_operational = 2.5,
			reload_operational = 2.2,
			empty_reload_operational = 2.8,
			reload_interrupt = 0.38,
			empty_reload_interrupt = 0.38,
			unequip = 0.5,
			equip = 0.65
		}

		--Akimbo Judge
		self.x_judge.fire_mode_data.fire_rate = 0.272727
		self.x_judge.single.fire_rate = 0.272727
		self.x_judge.FIRE_MODE = "burst"
		self.x_judge.BURST_COUNT = 2
		self.x_judge.ADAPTIVE_BURST_SIZE = true
		self.x_judge.supported = true
		self.x_judge.kick = self.stat_info.kick_tables.vertical_kick
		self.x_judge.kick_pattern = self.stat_info.kick_patterns.zigzag_3
		--The Akimbo Castigo animations look nicer, but have audio issues.
		--self.x_judge.weapon_hold = "x_chinchilla"
		--self.x_judge.animations.reload_name_id = "x_chinchilla"
		--self.x_judge.animations.second_gun_versions = self.x_judge.animations.second_gun_versions or {}
		--self.x_judge.animations.second_gun_versions.reload = "reload"
		self.x_judge.stats = {
			damage = 8,
			spread = 8,
			recoil = 5,
			concealment = 17
		}
		self.x_judge.timers = {
			reload_not_empty = 4.5,
			reload_empty = 4.5,
			reload_operational = 3.36,
			empty_reload_operational = 3.36,
			half_reload_operational = 2.96,
			empty_half_reload_operational = 2.96,
			reload_interrupt = 0.28,
			empty_reload_interrupt = 0.28,
			unequip = 0.5,
			equip = 0.5
		}

	--Light Shotguns (Secondary)
		--Goliath 12G
		self.rota.muzzleflash = "effects/particles/shotgun/shotgun_gen"
		self.rota.kick = self.stat_info.kick_tables.vertical_kick
		self.rota.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.rota.fire_mode_data.fire_rate = 0.175
		self.rota.single.fire_rate = 0.175
		self.rota.fire_rate_multiplier = 1.166 --400 rpm
		self.rota.supported = true
		self.rota.stats = {
			damage = 8,
			spread = 9,
			recoil = 13,
			concealment = 11
		}
		self.rota.timers = {
			reload_not_empty = 3.1,
			reload_empty = 3.1,
			reload_operational = 2.55,
			empty_reload_operational = 2.55, 
			reload_interrupt = 1.15, --Technically the cylinder is disengaged by ~0.36s, but it felt really bad at that value. Animations cover it up anyway.
			empty_reload_interrupt = 1.15,
			unequip = 0.6,
			equip = 0.6
		}
		self.rota.reload_speed_multiplier = 0.9 --3.6s
		
		--Argos 3
		self.ultima.muzzleflash = "effects/particles/shotgun/shotgun_gen"
		self.ultima.kick = self.stat_info.kick_tables.moderate_right_kick
		self.ultima.kick_pattern = self.stat_info.kick_patterns.random
		self.ultima.supported = true
		self.ultima.stats = {
			damage = 8,
			spread = 10,
			recoil = 10,
			concealment = 15
		}
		self.ultima.timers.shotgun_reload.empty.reload_queue = {
			{
				reload_num = 1,
				expire_t = 1.4333333333333333,
				stop_update_ammo = true,
				shell_order = {
					3
				}
			},
			{
				reload_num = 2,
				expire_t = 0.6,
				shell_order = {
					3,
					4,
					1,
					2
				}
			},
			{
				skip_update_ammo = true,
				reload_num = 2,
				expire_t = 0.3333333333333333
			},
			{
				reload_num = 2,
				expire_t = 0.6333333333333333,
				shell_order = {
					1,
					2
				}
			},
			{
				reload_num = 2,
				expire_t = 0.6333333333333333,
				shell_order = {
					1,
					2
				}
			},
			{
				reload_num = 2,
				expire_t = 0.6333333333333333,
				shell_order = {
					1,
					2
				}
			}
		}
		self.ultima.timers.shotgun_reload_interrupt = 0.5
		--Mostly use the vanilla timers, since they match the unique reload animation pretty well.

		--Judge
		self.judge.fire_mode_data.fire_rate = 0.272727
		self.judge.single.fire_rate = 0.272727
		self.judge.muzzleflash = "effects/particles/shotgun/shotgun_gen"
		self.judge.kick = self.stat_info.kick_tables.left_kick
		self.judge.kick_pattern = self.stat_info.kick_patterns.random
		self.judge.supported = true
		self.judge.stats = {
			damage = 8,
			spread = 12,
			recoil = 9,
			concealment = 19
		}
		self.judge.timers = {
			reload_not_empty = 2.4,
			reload_empty = 2.4,
			reload_operational = 2.2,
			empty_reload_operational = 2.2,
			reload_interrupt = 0.29,
			empty_reload_interrupt = 0.29,
			unequip = 0.5,
			equip = 0.45
		}

		--Grimm 12g
		self.basset.muzzleflash = "effects/particles/shotgun/shotgun_gen"
		self.basset.CLIP_AMMO_MAX = 5
		self.basset.kick = self.stat_info.kick_tables.right_kick
		self.basset.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.basset.supported = true
		self.basset.stats = {
			damage = 8,
			spread = 13,
			recoil = 9,
			concealment = 17
		}
		self.basset.timers = {
			reload_not_empty = 2.7,
			reload_empty = 3.3,
			reload_operational = 2.16,
			empty_reload_operational = 2.9,
			reload_interrupt = 0.44,
			empty_reload_interrupt = 0.44,
			unequip = 0.55,
			equip = 0.55
		}
		self.basset.reload_speed_multiplier = 1.1 --2.1/2.8

	--Medium Shotguns (Primary)
		--Reinfeld 880
		self.r870.desc_id = "bm_menu_sc_r870_desc"
		self.r870.muzzleflash = "effects/particles/shotgun/shotgun_gen"
		self.r870.single.fire_rate = 0.5
		self.r870.fire_mode_data.fire_rate = 0.5
		self.r870.kick = self.stat_info.kick_tables.vertical_kick
		self.r870.kick_pattern = self.stat_info.kick_patterns.jumpy_2
		self.r870.supported = true
		self.r870.stats = {
			damage = 11,
			spread = 14,
			recoil = 14,
			concealment = 12
		}
		self.r870.timers = {
			shotgun_reload_enter = 0.3,
			shotgun_reload_exit_empty = 0.7,
			shotgun_reload_exit_not_empty = 0.3,
			shotgun_reload_shell = 0.57,
			shotgun_reload_first_shell_offset = 0.33,
			shotgun_reload_interrupt = 0.4,
			unequip = 0.6,
			equip = 0.55
		}

		--Mosconi 12G Tactical
		self.m590.tactical_reload = true
		self.m590.muzzleflash = "effects/particles/shotgun/shotgun_gen"
		self.m590.CLIP_AMMO_MAX = 7
		self.m590.kick = self.stat_info.kick_tables.vertical_kick
		self.m590.kick_pattern = self.stat_info.kick_patterns.zigzag_2
		self.m590.supported = true
		self.m590.stats = {
			damage = 11,
			spread = 12,
			recoil = 14,
			concealment = 11
		}
		self.m590.timers = {
			shotgun_reload_enter = 0.3,
			shotgun_reload_exit_empty = 0.7,
			shotgun_reload_exit_not_empty = 0.3,
			shotgun_reload_shell = 0.57,
			shotgun_reload_first_shell_offset = 0.33,
			shotgun_reload_interrupt = 0.4,
			unequip = 0.6,
			equip = 0.55
		}
		self.m590.reload_speed_multiplier = 0.8 --6.6s

		--Raven
		self.ksg.muzzleflash = "effects/particles/shotgun/shotgun_gen"
		self.ksg.CLIP_AMMO_MAX = 14
		self.ksg.single.fire_rate = 0.55
		self.ksg.fire_mode_data.fire_rate = 0.55
		self.ksg.fire_rate_multiplier = 0.825 --90rpm
		self.ksg.kick = self.stat_info.kick_tables.left_kick
		self.ksg.kick_pattern = self.stat_info.kick_patterns.jumpy_2
		self.ksg.supported = true
		self.ksg.stats = {
			damage = 11,
			spread = 9,
			recoil = 14,
			concealment = 12
		}
		self.ksg.timers = {
			shotgun_reload_enter = 0.3,
			shotgun_reload_exit_empty = 0.7,
			shotgun_reload_exit_not_empty = 0.3,
			shotgun_reload_shell = 0.57,
			shotgun_reload_first_shell_offset = 0.33,
			shotgun_reload_interrupt = 0.4,
			unequip = 0.6,
			equip = 0.55
		}
		self.ksg.reload_speed_multiplier = 0.85 --11s

		--Reinfeld 88
		self.m1897.muzzleflash = "effects/particles/shotgun/shotgun_gen"
		self.m1897.CLIP_AMMO_MAX = 5
		self.m1897.kick = self.stat_info.kick_tables.moderate_left_kick
		self.m1897.kick_pattern = self.stat_info.kick_patterns.jumpy_2
		self.m1897.single.fire_rate = 0.5
		self.m1897.fire_mode_data.fire_rate = 0.5
		self.m1897.supported = true
		self.m1897.stats = {
			damage = 11,
			spread = 12,
			recoil = 15,
			concealment = 15
		}
		self.m1897.timers = {
			shotgun_reload_enter = 0.5,
			shotgun_reload_exit_empty = 0.7,
			shotgun_reload_exit_not_empty = 0.55,
			shotgun_reload_shell = 0.65,
			shotgun_reload_first_shell_offset = 0,
			shotgun_reload_interrupt = 0.77,
			unequip = 0.85,
			equip = 0.85
		}
		self.m1897.reload_speed_multiplier = 1.1
		self.m1897.swap_speed_multiplier = 1.1

	--Medium Shotguns (Secondary)
		--Breaker 12g
		self.boot.use_data.selection_index = 1
		self.boot.CLIP_AMMO_MAX = 5
		self.boot.fire_rate_multiplier = 1.13
		self.boot.fire_mode_data.fire_rate = 0.85
		self.boot.single.fire_rate = 0.85
		self.boot.muzzleflash = "effects/particles/shotgun/shotgun_gen"
		self.boot.kick = self.stat_info.kick_tables.left_kick
		self.boot.kick_pattern = self.stat_info.kick_patterns.jumpy_3
		self.boot.supported = true
		self.boot.stats = {
			damage = 11,
			spread = 15,
			recoil = 10,
			concealment = 15
		}
		self.boot.timers = {
			shotgun_reload_enter = 0.733,
			shotgun_reload_exit_empty = 0.85,
			shotgun_reload_exit_not_empty = 0.55,
			shotgun_reload_shell = 0.33,
			shotgun_reload_first_shell_offset = 0.15,
			shotgun_reload_interrupt = 0.3,
			unequip = 0.55,
			equip = 0.85
		}
		self.boot.reload_speed_multiplier = 0.92 --3.7s

		--Locomotive 12g
		self.serbu.muzzleflash = "effects/particles/shotgun/shotgun_gen"
		self.serbu.CLIP_AMMO_MAX = 4
		self.serbu.fire_mode_data.fire_rate = 0.5
		self.serbu.single.fire_rate = 0.5
		self.serbu.kick = self.stat_info.kick_tables.vertical_kick
		self.serbu.kick_pattern = self.stat_info.kick_patterns.jumpy_2
		self.serbu.supported = true
		self.serbu.stats = {
			damage = 11,
			spread = 12,
			recoil = 12,
			concealment = 15
		}
		self.serbu.timers = {
			shotgun_reload_enter = 0.3,
			shotgun_reload_exit_empty = 0.7,
			shotgun_reload_exit_not_empty = 0.3,
			shotgun_reload_shell = 0.57,
			shotgun_reload_first_shell_offset = 0.33,
			shotgun_reload_interrupt = 0.4, 
			unequip = 0.7,
			equip = 0.6
		}

		--GSPS--
		self.m37.muzzleflash = "effects/particles/shotgun/shotgun_gen"
		self.m37.CLIP_AMMO_MAX = 4
		self.m37.fire_mode_data.fire_rate = 0.75
		self.m37.single.fire_rate = 0.75
		self.m37.kick = self.stat_info.kick_tables.left_kick
		self.m37.kick_pattern = self.stat_info.kick_patterns.jumpy_1
		self.m37.supported = true
		self.m37.stats = {
			damage = 11,
			spread = 14,
			recoil = 14,
			concealment = 14
		}
		self.m37.timers = {
			shotgun_reload_enter = 0.5,
			shotgun_reload_exit_empty = 0.7,
			shotgun_reload_exit_not_empty = 0.3,
			shotgun_reload_shell = 0.65,
			shotgun_reload_first_shell_offset = 0,
			shotgun_reload_interrupt = 0.77,
			unequip = 0.6,
			equip = 0.85
		}
		self.m37.reload_speed_multiplier = 1.25 --3s

	--Heavy Shotgun (Primary)
		--Mosconi 12G
		self.huntsman.muzzleflash = "effects/particles/shotgun/muzzleflash"
		self.huntsman.sounds.fire_single = "huntsman_fire"
		self.huntsman.sounds.fire_auto = "huntsman_fire"
		self.huntsman.BURST_COUNT = 3
		self.huntsman.BURST_FIRE_RATE_MULTIPLIER = 6
		self.huntsman.ADAPTIVE_BURST_SIZE = false
		self.huntsman.CAN_TOGGLE_FIREMODE = false
		self.huntsman.DELAYED_BURST_RECOIL = true
		self.huntsman.fire_mode_data = {}
		self.huntsman.fire_mode_data.fire_rate = 0.3
		self.huntsman.single = {}
		self.huntsman.single.fire_rate = 0.3
		self.huntsman.auto = {}
		self.huntsman.auto.fire_rate = 0.3
		self.huntsman.fire_rate_multiplier = 2 --400 rpm
		self.huntsman.kick = self.stat_info.kick_tables.right_kick
		self.huntsman.kick_pattern = self.stat_info.kick_patterns.random
		self.huntsman.supported = true
		self.huntsman.stats = {
			damage = 16,
			spread = 13,
			recoil = 10,
			concealment = 17
		}
		self.huntsman.timers = {
			reload_empty = 2.8,
			reload_not_empty = 2.8,
			reload_operational = 2.5,
			empty_reload_operational = 2.5,
			reload_interrupt = 0.1,
			empty_reload_interrupt = 0.1,
			equip = 0.6,
			unequip = 0.6
		}
		self.huntsman.reload_speed_multiplier = 1.04 --2.7s

		--Joceline O/U 12G
		self.b682.muzzleflash = "effects/particles/shotgun/muzzleflash"
		self.b682.sounds.fire_single = "b682_fire"
		self.b682.sounds.fire_auto = "b682_fire"
		self.b682.kick = self.stat_info.kick_tables.vertical_kick
		self.b682.kick_pattern = self.stat_info.kick_patterns.random
		self.b682.supported = true
		self.b682.fire_mode_data = {
			fire_rate = 0.18
		}
		self.b682.single = {
			fire_rate = 0.18
		}
		self.b682.fire_rate_multiplier = 1.2 --400 rpm
		self.b682.stats = {
			damage = 16,
			spread = 15,
			recoil = 9,
			concealment = 17
		}
		self.b682.timers = {
			reload_not_empty = 3.3,
			reload_empty = 3.3,
			reload_operational = 2.7,
			empty_reload_operational = 2.7,
			reload_interrupt = 0.48,
			empty_reload_interrupt = 0.48,
			unequip = 0.55,
			equip = 0.55
		}
		self.b682.reload_speed_multiplier = 1.1 --3s

	--Heavy Shotgun (Secondary)
		--Claire 12G
		self.coach.muzzleflash = "effects/particles/shotgun/muzzleflash"
		self.coach.kick = self.stat_info.kick_tables.left_kick
		self.coach.kick_pattern = self.stat_info.kick_patterns.random
		self.coach.sounds.fire_single = "coach_fire"
		self.coach.sounds.fire_auto = "coach_fire"
		self.coach.BURST_COUNT = 3
		self.coach.CAN_TOGGLE_FIREMODE = false
		self.coach.BURST_FIRE_RATE_MULTIPLIER = 6
		self.coach.DELAYED_BURST_RECOIL = true
		self.coach.ADAPTIVE_BURST_SIZE = false
		self.coach.fire_mode_data = {}
		self.coach.fire_mode_data.fire_rate = 0.18
		self.coach.single = {}
		self.coach.single.fire_rate = 0.18
		self.coach.auto = {}
		self.coach.auto.fire_rate = 0.18
		self.coach.fire_rate_multiplier = 1.2 --400 rpm
		self.coach.supported = true
		self.coach.stats = {
			damage = 16,
			spread = 12,
			recoil = 10,
			concealment = 17
		}
		self.coach.timers = {
			reload_not_empty = 2.3,
			reload_empty = 2.3,
			reload_operational = 2.2,
			empty_reload_operational = 2.2,
			reload_interrupt = 0.1,
			empty_reload_interrupt = 0.1,
			equip = 0.6,
			unequip = 0.4
		}
		self.coach.reload_speed_multiplier = 1.05 --2.2s

	--Saws
		--OVE9000 Saw
		self.saw.has_description = true
		self.saw.desc_id = "bm_ap_saw_sc_desc"
		self.saw.CLIP_AMMO_MAX = 100
		self.saw.AMMO_MAX = 200
		self.saw.kick = self.stat_info.kick_tables.vertical_kick
		self.saw.kick_pattern = self.stat_info.kick_patterns.random
		self.saw.fire_mode_data.fire_rate = 0.1
		self.saw.auto.fire_rate = 0.1
		self.saw.supported = true
		self.saw.stats = {
			spread = 21,
			recoil = 16,
			damage = 60,
			concealment = 11
		}
		self.saw.timers = {
			reload_not_empty = 4.8,
			reload_empty = 4.8,
			reload_operational = 3.7,
			empty_reload_operational = 3.7,
			reload_interrupt = 0.0,
			empty_reload_interrupt = 0.0,
			unequip = 0.8,
			equip = 0.8
		}
		self.saw_secondary.kick = self.saw.kick
		self.saw_secondary.kick_pattern = self.saw.kick_pattern
		self.saw_secondary.has_description = true
		self.saw_secondary.desc_id = "bm_ap_saw_sc_desc"
		self.saw_secondary.CLIP_AMMO_MAX = self.saw.CLIP_AMMO_MAX
		self.saw_secondary.AMMO_MAX = math.floor(self.saw.AMMO_MAX / 2)
		self.saw_secondary.fire_mode_data.fire_rate = self.saw.fire_mode_data.fire_rate
		self.saw_secondary.auto.fire_rate = self.saw.auto.fire_rate
		self.saw_secondary.supported = true
		self.saw_secondary.stats = deep_clone(self.saw.stats)
		self.saw_secondary.timers = deep_clone(self.saw.timers)

	--Flamethrowers
		--Flamethrower Mk1
		self.flamethrower_mk2.categories = {
			"flamethrower",
			"shotgun"
		}
		self.flamethrower_mk2.CLIP_AMMO_MAX = 80
		self.flamethrower_mk2.recategorize = "wpn_special"
		self.flamethrower_mk2.has_description = true
		self.flamethrower_mk2.desc_id = "bm_ap_flamethrower_sc_desc"
		self.flamethrower_mk2.timers.reload_not_empty = 7.7
		self.flamethrower_mk2.timers.reload_empty = 7.7
		self.flamethrower_mk2.fire_mode_data.fire_rate = 0.06
		self.flamethrower_mk2.auto.fire_rate = 0.06
		self.flamethrower_mk2.flame_max_range = 1100
		self.flamethrower_mk2.flame_radius = 50
		self.flamethrower_mk2.kick = self.stat_info.kick_tables.horizontal_recoil
		self.flamethrower_mk2.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.flamethrower_mk2.fire_dot_data = {
			dot_damage = 1.8,
			dot_trigger_chance = 50,
			dot_length = 2.1,
			dot_tick_period = 0.5
		}
		self.flamethrower_mk2.supported = true
		self.flamethrower_mk2.stats = {
			damage = 36,
			spread = 0,
			recoil = 23,
			concealment = 6
		}
		self.flamethrower_mk2.timers = {
			reload_not_empty = 9.2,
			reload_empty = 9.2,
			reload_operational = 8.5,
			empty_reload_operational = 8.5,
			reload_interrupt = 0.72,
			empty_reload_interrupt = 0.72,
			equip = 0.85,
			unequip = 0.85
		}
		self.flamethrower_mk2.reload_speed_multiplier = 1.1 --8.4s

		--MA-17 Flamethrower
		self.system.categories = {
			"flamethrower",
			"shotgun"
		}
		self.system.recategorize = "wpn_special"
		self.system.has_description = true
		self.system.desc_id = "bm_ap_flamethrower_sc_desc"
		self.system.CLIP_AMMO_MAX = 80
		self.system.fire_mode_data.fire_rate = 0.06
		self.system.auto.fire_rate = 0.06
		self.system.flame_max_range = 1100
		self.system.single_flame_effect_duration = 1
		self.system.kick = self.stat_info.kick_tables.horizontal_recoil
		self.system.kick_pattern = self.stat_info.kick_patterns.zigzag_1
		self.system.supported = true
		self.system.fire_dot_data = {
			dot_damage = 1.8,
			dot_trigger_chance = 50,
			dot_length = 2.1,
			dot_tick_period = 0.5
		}
		self.system.stats = {
			damage = 36,
			spread = 0,
			recoil = 23,
			concealment = 12
		}
		self.system.timers = {
			reload_not_empty = 9.2,
			reload_empty = 9.2,
			reload_operational = 8.5,
			empty_reload_operational = 8.5,
			reload_interrupt = 1.56,
			empty_reload_interrupt = 1.56,
			equip = 0.85,
			unequip = 0.85
		}
		self.system.reload_speed_multiplier = 1.05 --8.8s

	--Mounted Turrets
		--Mounted Ranc Heavy Turret
		self.ranc_heavy_machine_gun.categories = {
			"lmg",
			"smg"
		}
		self.ranc_heavy_machine_gun.stats = {
			damage = 60,
			spread = 10,
			recoil = 19,
			concealment = 5
		}
		self.ranc_heavy_machine_gun.AMMO_MAX = self.ranc_heavy_machine_gun.CLIP_AMMO_MAX
		self.ranc_heavy_machine_gun.kick = self.stat_info.kick_tables.moderate_kick
		self.ranc_heavy_machine_gun.kick_pattern = self.stat_info.kick_patterns.zigzag_3

	--Anubis .45
	if self.socom then
		--TODO: Implement Anubis stats once the standalone gun is released.
	end

	--The following Akimbo weapons are not supported. These generally:
		--A: Fail to fit into an interesting and non-degenerate gameplay niche.
		--B: Lack unique animations, or have animations that make glaringly obvious limitations with current akimbo code.
		--C: Are cases where the guns have been made into primary weapons.
		--Akimbo M13
		--Akimbo AK Gen 21 Tactical
		--Akimbo Miyaka 10
		--Akimbo Crosskill Chunky
		--Akimbo Beretta Auto
		--Akimbo Signature SMG
		--Akimbo Goliath 12g
		--Akimbo Baby Deagle
		--Akimbo Leo
		--Akimbo Signature .40
		--Akimbo White Streak
		--Akimbo Gruber Kurz
		--Akimbo Parabellum
		--akimbo Broomstick
		--Akimbo Spec Ops
		--Akimbo CMP
		--Akimbo Para
		--Akimbo Kobus 90
		--Akimbo Kross Vertex
		--Akimbo Jackal
		--Akimbo Cobra
		--Akimbo Patchett
		--Akimbo Blaster 9mm
		--Akimbo Uzi
		--Akimbo Jacket's Piece
		--Akimbo MP40
		--Akimbo CR805
		--Akimbo Swedish K
		--Akimbo Chicago typewriter
		--Akimbo Tatonka
		--Akimbo Igors
		--Akimbo Crosskill Guards
		--Akimbo Matevers
		--Akimbo Bronco
		--Akimbo Frenchman

	--Apply tactical reloading to relevant guns.
	--TODO: Move these to the weapon specific blocks.
	local tact_rel = {'deagle','colt_1911','usp','p226','g22c','glock_17','glock_18c','b92fs','ppk','mp9','new_mp5','mp7','p90','olympic','akmsu','akm','akm_gold','ak74','m16','amcar','new_m4','ak5','s552','g36','aug','saiga','new_m14','scar','fal','rpk','msr','r93','m95','famas','galil','g3','scorpion','benelli','serbu','r870','ksg','g26','spas12','l85a2','vhs','hs2000','tec9','asval','sub2000','polymer','wa2000','model70','sparrow','m37','sr2','pl14','tecci','hajk','boot','packrat','schakal','desertfox','tti','siltstone','flint','coal','lemming','breech','basset','shrew','corgi','shepheard','komodo','legacy','beer','czech','stech','r700','holt', 'x_deagle','x_1911','x_b92fs','jowi','x_usp','x_g17','x_g22c','x_packrat','x_shrew','x_breech','x_g18c','x_hs2000','x_p226','x_pl14','x_ppk','x_sparrow','x_legacy','x_czech','x_stech','x_holt', 'x_sr2','x_mp5', 'x_coal', 'x_mp7', 'x_mp9', 'x_p90', 'x_polymer', 'x_schakal', 'x_scorpion', 'x_tec9','x_shepheard', 'x_akmsu', 'x_hajk', 'x_olympic'}
	for i, wep_id in ipairs(tact_rel) do
		self[wep_id].tactical_reload = true
	end

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

				if weap.categories[1] == "akimbo" then
					weap.categories[1] = weap.categories[2]
					weap.categories[2] = "akimbo"
				end

				if weap.categories[1] == "shotgun" and not weap.rays then
					weap.rays = 9
				end

				--Fixed stat values that are the same for all, or nearly all guns.
				weap.stats.zoom = weap.stats.zoom or 1
				weap.stats.alert_size = weap.stats.alert_size or 2
				weap.stats.extra_ammo = 101
				weap.stats.total_ammo_mod = 100
				weap.stats.reload = 20
				weap.stats.value = 1
				weap.panic_suppression_chance = 0.05
				self:calculate_ammo_data(weap)
				self:calculate_suppression_data(weap)

				if weap.CLIP_AMMO_MAX == 1 then
					weap.upgrade_blocks = {
						weapon = {
							"clip_ammo_increase"
						}
					}
				end

				--Normalize camera shake.
				if weap.shake then
					if weap.shake.fire_multiplier ~= 0 then
						weap.shake.fire_multiplier = weap.shake.fire_multiplier / math.abs(weap.shake.fire_multiplier)
					end

					if weap.shake.fire_steelsight_multiplier ~= 0 then
						weap.shake.fire_steelsight_multiplier = weap.shake.fire_steelsight_multiplier / math.abs(weap.shake.fire_steelsight_multiplier)
					end
				end
			end
		end
	end
end

--Define % of total ammo to pickup baseline per damage tier.
--More damaging guns should pick up less ammo, as a tradeoff for their higher output.
--The pickup field corresponds to the amount of damage-as-ammo returned per pickup at 50% ammo.
--At 0% ammo, this is increased to 133.33%. At 100% ammo, this is reduced to 66%.
--On secondaries, overall pickup is reduced to damage_pool_secondary/damage_pool_primary.
--On guns with unique ammo counts (IE: With underbarrels), it's reduced proportionally to the primary damage pool.
--Guns in different categories have additional pickup multipliers, somewhat correlated with their range multipliers.
local damage_tier_data = {
	{damage = 18,  pickup = 320, suppression =  4}, --18/36 damage guns
	{damage = 20,  pickup = 310, suppression =  6},
	{damage = 24,  pickup = 290, suppression =  8},
	{damage = 30,  pickup = 260, suppression = 10},
	{damage = 45,  pickup = 230, suppression = 11},
	{damage = 60,  pickup = 210, suppression = 12},
	{damage = 90,  pickup = 190, suppression = 13},
	{damage = 135, pickup = 160, suppression = 14},
	{damage = 180, pickup = 150, suppression = 15},
	{damage = 240, pickup = 140, suppression = 16},
	{damage = 300, pickup = 130, suppression = 17},
	{damage = 360, pickup = 120, suppression = 18},
	{damage = 400, pickup = 110, suppression = 19},
	{damage = 600, pickup = 100, suppression = 20}
}
local shotgun_damage_tier_data = {
	{tier = 8,  damage = 60,  pickup = 210, suppression = 13}, --144 damage shotguns = 120 damage other weapons
	{tier = 11, damage = 90,  pickup = 190, suppression = 14}, --198 damage shotguns = 180 damage other weapons
	{tier = 16, damage = 135, pickup = 160, suppression = 15}  --252 damage shotguns = 270 damage other weapons
}

local damage_pool_primary = 3600
local damage_pool_secondary = 1800

local function get_damage_tier(weapon)
	local damage_mul = weapon.stats_modifiers and weapon.stats_modifiers.damage or 1
	local damage = weapon.stats.damage * damage_mul
	local damage_tiers = weapon.rays and shotgun_damage_tier_data or damage_tier_data
	for i = 1, #damage_tiers do
		local damage_tier = damage_tiers[i]
		if damage - 1 <= (damage_tier.tier or damage_tier.damage) then
			return damage_tier
		end
	end

	return damage_tier_data[#damage_tier_data]
end

local category_data = {
	shotgun          = {pickup = 1.0, suppression = 1.0, ammo_max = 1.0},
	bow              = {pickup = 0.7, suppression = 0.5, ammo_max = 1.0},
	crossbow         = {pickup = 0.7, suppression = 0.5, ammo_max = 1.0},
	pistol           = {pickup = 1.1, suppression = 0.5, ammo_max = 1.0},
	smg              = {pickup = 1.1, suppression = 1.5, ammo_max = 1.0},
	lmg              = {pickup = 1.0, suppression = 1.3, ammo_max = 1.5}, --Applies on top of SMG preset
	minigun          = {pickup = 1.0, suppression = 1.3, ammo_max = 2.0}, --Applies on top of SMG preset
	saw              = {pickup = 1.0, suppression = 1.0, ammo_max = 1.0},
	grenade_launcher = {pickup = 0.5, suppression = 1.0, ammo_max = 1.0},
	snp              = {pickup = 1.0, suppression = 1.0, ammo_max = 1.0},
	assault_rifle    = {pickup = 1.0, suppression = 1.0, ammo_max = 1.0},
	akimbo           = {pickup = 1.0, suppression = 1.0, ammo_max = 1.0},
	flamethrower     = {pickup = 1.3, suppression = 1.5, ammo_max = 2.0}
}
local shield_piercing_pickup_mul = 0.7

local function get_category_modifier(weapon, field)
	local result = 1
	for i = 1, #weapon.categories do
		local cat_data = category_data[weapon.categories[i]]
		result = result * (cat_data and cat_data[field] or 1)
	end
	return result
end

--Multipliers for ammo pickup to interpolate between based on current ammo. Make sure these average to 1 for sanity's sake.
local pickup_mul_near_empty = 1.333333333334
local pickup_mul_near_full = 0.666666666667

--Determines a gun's total ammo and pickup.
function WeaponTweakData:calculate_ammo_data(weapon)
	--Determine the damage tier the gun falls under.
	weapon.AMMO_PICKUP = {0, 0}

	local damage_tier = get_damage_tier(weapon)
	local damage_pool = damage_pool_primary
	if weapon.use_data.selection_index == 1 then
		damage_pool = damage_pool_secondary
	end

	weapon.AMMO_PICKUP[1] = pickup_mul_near_empty * (damage_tier.pickup / damage_tier.damage)
	weapon.AMMO_PICKUP[2] = pickup_mul_near_full * (damage_tier.pickup / damage_tier.damage)

	local pickup_multiplier = get_category_modifier(weapon, "pickup")

	local ammo_max = weapon.AMMO_MAX
	if not ammo_max then
		ammo_max = damage_pool / damage_tier.damage

		--Get weapon category specific max ammo multipliers.
		ammo_max = ammo_max * get_category_modifier(weapon, "ammo_max")

		if weapon.use_data.selection_index == 1 then
			pickup_multiplier = pickup_multiplier * (damage_pool_secondary / damage_pool_primary)
		end

		if weapon.can_shoot_through_shield then
			pickup_multiplier = pickup_multiplier * shield_piercing_pickup_mul
		end
	else
		pickup_multiplier = pickup_multiplier * ((weapon.AMMO_MAX * damage_tier.damage) / damage_pool_primary)
		
		if weapon.can_shoot_through_shield then
			pickup_multiplier = pickup_multiplier * shield_piercing_pickup_mul
		end
	end

	--Set actual pickup values to use.
	weapon.AMMO_PICKUP[1] = weapon.AMMO_PICKUP[1] * pickup_multiplier
	weapon.AMMO_PICKUP[2] = weapon.AMMO_PICKUP[2] * pickup_multiplier
	weapon.AMMO_MAX = math.floor(ammo_max)
end

--Determines the suppression value of the gun. Generally increases with higher damage guns.
--More headshot focused typically-single-fire gun categories get lower suppression, LMGs and Shotties get higher suppression to fit their roles/fantasies.
function WeaponTweakData:calculate_suppression_data(weapon)
	local damage_tier = get_damage_tier(weapon)

	--Get weapon category specific suppression multipliers.
	local multiplier = get_category_modifier(weapon, "suppression")

	--Silenced guns have their suppression reduced by an additional 4 points.
	weapon.stats.suppression = math.clamp(math.round(damage_tier.suppression * multiplier) - (weapon.stats.alert_size == 2 and 4 or 0), 1, #self.stats.suppression)
end