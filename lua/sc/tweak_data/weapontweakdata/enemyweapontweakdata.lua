--Contains tweakdata defining all guns used by npcs. Usually enemies..
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

local orig_create_table_structure = WeaponTweakData._create_table_structure
function WeaponTweakData:_create_table_structure()
	orig_create_table_structure(self)
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
	self.raging_bull_npc.DAMAGE = 7.5
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
	self.m14_sniper_npc.DAMAGE = 21
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
	self.m14_sniper_npc.sniper_trail = true
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
	self.flamethrower_mk2_flamer = deep_clone(self.flamethrower_npc)
	self.flamethrower_mk2_flamer.sounds.prefix = "flamethrower_npc"
	self.flamethrower_mk2_flamer.sounds.fire = "flamethrower_npc_fire"
	self.flamethrower_mk2_flamer.sounds.stop_fire = "flamethrower_npc_fire_stop"
	self.flamethrower_mk2_flamer.CLIP_AMMO_MAX = 60
	self.flamethrower_mk2_flamer.NR_CLIPS_MAX = 4
	self.flamethrower_mk2_flamer.DAMAGE = 7.5
	self.flamethrower_mk2_flamer.flame_max_range = 1400

	self.flamethrower_mk2_flamer.FIRE_MODE = "auto"
	self.flamethrower_mk2_flamer.hold = {
		"bullpup",
		"rifle"
	}
	self.flamethrower_mk2_flamer.alert_size = 2500
	self.flamethrower_mk2_flamer.suppression = 3.1

	self.flamethrower_mk2_flamer.pull_magazine_during_reload = "large_metal"
	self.flamethrower_mk2_flamer.anim_usage = "is_bullpup"
	self.flamethrower_mk2_flamer.usage = "is_flamethrower"
end