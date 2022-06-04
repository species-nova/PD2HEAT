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
		local horig_type = weap.hold
		if not horig_type then
			return reload_times.default
		end

		if type(horig_type) == "table" then
			for _, hold in ipairs(horig_type) do
				if reload_times[hold] then
					return reload_times[hold], hold
				end
			end

			return reload_times.default
		elseif reload_times[horig_type] then
			return reload_times[horig_type], horig_type
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
local orig_init_data_c45_crew = WeaponTweakData._init_data_c45_crew
function WeaponTweakData:_init_data_c45_crew()
	orig_init_data_c45_crew(self)
	apply_crew_weapon_preset(self.c45_crew, crew_pistol_stats)
	apply_crew_weapon_preset(self.colt_1911_primary_crew, crew_pistol_stats)
end

local orig_init_data_beretta92_crew = WeaponTweakData._init_data_beretta92_crew
function WeaponTweakData:_init_data_beretta92_crew()
	orig_init_data_beretta92_crew(self)
	apply_crew_weapon_preset(self.beretta92_crew, crew_pistol_stats)
	apply_crew_weapon_preset(self.beretta92_primary_crew, crew_pistol_stats)
end

local orig_init_data_glock_18_crew = WeaponTweakData._init_data_glock_18_crew
function WeaponTweakData:_init_data_glock_18_crew()
	orig_init_data_glock_18_crew(self)
	apply_crew_weapon_preset(self.glock_18_crew, crew_smg_stats) --An SMG more closely matches what one would expect from an autopistol.
	apply_crew_weapon_preset(self.glock_18c_primary_crew, crew_smg_stats)
end

local orig_init_data_maxim9_crew = WeaponTweakData._init_data_maxim9_crew
function WeaponTweakData:_init_data_maxim9_crew()
	orig_init_data_maxim9_crew(self)
	apply_crew_weapon_preset(self.maxim9_crew, crew_pistol_stats)
end

local orig_init_data_fmg9_crew = WeaponTweakData._init_data_fmg9_crew
function WeaponTweakData:_init_data_fmg9_crew()
	orig_init_data_fmg9_crew(self)
	apply_crew_weapon_preset(self.fmg9_crew, crew_smg_stats)
end

local orig_init_data_raging_bull_crew = WeaponTweakData._init_data_raging_bull_crew
function WeaponTweakData:_init_data_raging_bull_crew()
	orig_init_data_raging_bull_crew(self)
	apply_crew_weapon_preset(self.raging_bull_crew, crew_revolver_stats)
	apply_crew_weapon_preset(self.raging_bull_primary_crew, crew_revolver_stats)
end

local orig_init_data_m4_crew = WeaponTweakData._init_data_m4_crew
function WeaponTweakData:_init_data_m4_crew()
	orig_init_data_m4_crew(self)
	apply_crew_weapon_preset(self.m4_crew, crew_rifle_stats)
	apply_crew_weapon_preset(self.m4_secondary_crew, crew_rifle_stats)
	apply_crew_weapon_preset(self.ak47_ass_crew, crew_rifle_stats)
end

local orig_init_data_ak47_crew = WeaponTweakData._init_data_ak47_crew
function WeaponTweakData:_init_data_ak47_crew()
	orig_init_data_ak47_crew(self)
	apply_crew_weapon_preset(self.ak47_crew, crew_rifle_stats)
end

local orig_init_data_m14_crew = WeaponTweakData._init_data_m14_crew
function WeaponTweakData:_init_data_m14_crew()
	self.m14_crew.auto = {}
	orig_init_data_m14_crew(self)
	apply_crew_weapon_preset(self.m14_crew, crew_dmr_stats)
end

local orig_init_data_r870_crew = WeaponTweakData._init_data_r870_crew
function WeaponTweakData:_init_data_r870_crew()
	orig_init_data_r870_crew(self)
	apply_crew_weapon_preset(self.r870_crew, crew_shotgun_stats)
	apply_crew_weapon_preset(self.benelli_crew, crew_shotgun_stats)
end

local orig_init_data_mossberg_crew = WeaponTweakData._init_data_mossberg_crew
function WeaponTweakData:_init_data_mossberg_crew()
	orig_init_data_mossberg_crew(self)
	apply_crew_weapon_preset(self.mossberg_crew, crew_shotgun_stats)
end

local orig_init_data_mp5_crew = WeaponTweakData._init_data_mp5_crew
function WeaponTweakData:_init_data_mp5_crew()
	orig_init_data_mp5_crew(self)
	apply_crew_weapon_preset(self.mp5_crew, crew_smg_stats)
end

local orig_init_data_g36_crew = WeaponTweakData._init_data_g36_crew
function WeaponTweakData:_init_data_g36_crew()
	orig_init_data_g36_crew(self)
	apply_crew_weapon_preset(self.g36_crew, crew_rifle_stats)
end

local orig_init_data_g17_crew = WeaponTweakData._init_data_g17_crew
function WeaponTweakData:_init_data_g17_crew()
	orig_init_data_g17_crew(self)
	apply_crew_weapon_preset(self.g17_crew, crew_pistol_stats)
end

local orig_init_data_mp9_crew = WeaponTweakData._init_data_mp9_crew
function WeaponTweakData:_init_data_mp9_crew()
	orig_init_data_mp9_crew(self)
	apply_crew_weapon_preset(self.mp9_crew, crew_smg_stats)
end

local orig_init_data_olympic_crew = WeaponTweakData._init_data_olympic_crew
function WeaponTweakData:_init_data_olympic_crew()
	orig_init_data_olympic_crew(self)
	apply_crew_weapon_preset(self.olympic_crew, crew_rifle_stats)
end

local orig_init_data_m16_crew = WeaponTweakData._init_data_m16_crew
function WeaponTweakData:_init_data_m16_crew()
	orig_init_data_m16_crew(self)
	apply_crew_weapon_preset(self.m16_crew, crew_rifle_stats)
end

local orig_init_data_aug_crew = WeaponTweakData._init_data_aug_crew
function WeaponTweakData:_init_data_aug_crew()
	orig_init_data_aug_crew(self)
	apply_crew_weapon_preset(self.aug_crew, crew_rifle_stats)
	apply_crew_weapon_preset(self.aug_secondary_crew, crew_rifle_stats)
end

local orig_init_data_ak74_crew = WeaponTweakData._init_data_ak74_crew
function WeaponTweakData:_init_data_ak74_crew()
	orig_init_data_ak74_crew(self)
	apply_crew_weapon_preset(self.ak74_crew, crew_rifle_stats)
	apply_crew_weapon_preset(self.ak74_secondary_crew, crew_rifle_stats)
end

local orig_init_data_ak5_crew = WeaponTweakData._init_data_ak5_crew
function WeaponTweakData:_init_data_ak5_crew()
	orig_init_data_ak5_crew(self)
	apply_crew_weapon_preset(self.ak5_crew, crew_rifle_stats)
end

local orig_init_data_p90_crew = WeaponTweakData._init_data_p90_crew
function WeaponTweakData:_init_data_p90_crew()
	orig_init_data_p90_crew(self)
	apply_crew_weapon_preset(self.p90_crew, crew_smg_stats)
end

local orig_init_data_amcar_crew = WeaponTweakData._init_data_amcar_crew
function WeaponTweakData:_init_data_amcar_crew()
	orig_init_data_amcar_crew(self)
	apply_crew_weapon_preset(self.amcar_crew, crew_rifle_stats)
end

local orig_init_data_mac10_crew = WeaponTweakData._init_data_mac10_crew
function WeaponTweakData:_init_data_mac10_crew()
	orig_init_data_mac10_crew(self)
	apply_crew_weapon_preset(self.mac10_crew, crew_smg_stats)
end

local orig_init_data_akmsu_crew = WeaponTweakData._init_data_akmsu_crew
function WeaponTweakData:_init_data_akmsu_crew()
	orig_init_data_akmsu_crew(self)
	apply_crew_weapon_preset(self.akmsu_crew, crew_rifle_stats)
	apply_crew_weapon_preset(self.akmsu_primary_crew, crew_rifle_stats)
end

local orig_init_data_akm_crew = WeaponTweakData._init_data_akm_crew
function WeaponTweakData:_init_data_akm_crew()
	orig_init_data_akm_crew(self)
	apply_crew_weapon_preset(self.akm_crew, crew_rifle_stats)
end

local orig_init_data_akm_gorig_crew = WeaponTweakData._init_data_akm_gorig_crew
function WeaponTweakData:_init_data_akm_gorig_crew()
	orig_init_data_akm_gorig_crew(self)
	apply_crew_weapon_preset(self.akm_gold, crew_rifle_stats)
end

local orig_init_data_deagle_crew = WeaponTweakData._init_data_deagle_crew
function WeaponTweakData:_init_data_deagle_crew()
	orig_init_data_deagle_crew(self)
	apply_crew_weapon_preset(self.deagle_crew, crew_revolver_stats)
	apply_crew_weapon_preset(self.deagle_primary_crew, crew_revolver_stats)
end

local orig_init_data_serbu_crew = WeaponTweakData._init_data_serbu_crew
function WeaponTweakData:_init_data_serbu_crew()
	orig_init_data_serbu_crew(self)
	apply_crew_weapon_preset(self.serbu_crew, crew_shotgun_stats)
end

local orig_init_data_saiga_crew = WeaponTweakData._init_data_saiga_crew
function WeaponTweakData:_init_data_saiga_crew()
	orig_init_data_saiga_crew(self)
	apply_crew_weapon_preset(self.saiga_crew, crew_shotgun_mag_stats)
end

local orig_init_data_huntsman_crew = WeaponTweakData._init_data_huntsman_crew
function WeaponTweakData:_init_data_huntsman_crew()
	orig_init_data_huntsman_crew(self)
	apply_crew_weapon_preset(self.huntsman_crew, crew_shotgun_double_stats)
end

local orig_init_data_usp_crew = WeaponTweakData._init_data_usp_crew
function WeaponTweakData:_init_data_usp_crew()
	orig_init_data_usp_crew(self)
	apply_crew_weapon_preset(self.usp_crew, crew_pistol_stats)
end

local orig_init_data_g22c_crew = WeaponTweakData._init_data_g22c_crew
function WeaponTweakData:_init_data_g22c_crew()
	orig_init_data_g22c_crew(self)
	apply_crew_weapon_preset(self.g22c_crew, crew_pistol_stats)
end

local orig_init_data_judge_crew = WeaponTweakData._init_data_judge_crew
function WeaponTweakData:_init_data_judge_crew()
	orig_init_data_judge_crew(self)
	apply_crew_weapon_preset(self.judge_crew, crew_shotgun_stats)
end

local orig_init_data_m45_crew = WeaponTweakData._init_data_m45_crew
function WeaponTweakData:_init_data_m45_crew()
	orig_init_data_m45_crew(self)
	apply_crew_weapon_preset(self.m45_crew, crew_smg_stats)
end

local orig_init_data_s552_crew = WeaponTweakData._init_data_s552_crew
function WeaponTweakData:_init_data_s552_crew()
	orig_init_data_s552_crew(self)
	apply_crew_weapon_preset(self.s552_crew, crew_rifle_stats)
	apply_crew_weapon_preset(self.s552_secondary_crew, crew_rifle_stats)
end

local orig_init_data_ppk_crew = WeaponTweakData._init_data_ppk_crew
function WeaponTweakData:_init_data_ppk_crew()
	orig_init_data_ppk_crew(self)
	apply_crew_weapon_preset(self.ppk_crew, crew_pistol_stats)
end

local orig_init_data_mp7_crew = WeaponTweakData._init_data_mp7_crew
function WeaponTweakData:_init_data_mp7_crew()
	orig_init_data_mp7_crew(self)
	apply_crew_weapon_preset(self.mp7_crew, crew_smg_stats)
end

local orig_init_data_scar_crew = WeaponTweakData._init_data_scar_crew
function WeaponTweakData:_init_data_scar_crew()
	orig_init_data_scar_crew(self)
	apply_crew_weapon_preset(self.scar_crew, crew_rifle_stats)
end

local orig_init_data_p226_crew = WeaponTweakData._init_data_p226_crew
function WeaponTweakData:_init_data_p226_crew()
	orig_init_data_p226_crew(self)
	apply_crew_weapon_preset(self.p226_crew, crew_pistol_stats)
end

local orig_init_data_hk21_crew = WeaponTweakData._init_data_hk21_crew
function WeaponTweakData:_init_data_hk21_crew()
	orig_init_data_hk21_crew(self)
	apply_crew_weapon_preset(self.hk21_crew, crew_lmg_stats)
end

local orig_init_data_m249_crew = WeaponTweakData._init_data_m249_crew
function WeaponTweakData:_init_data_m249_crew()
	orig_init_data_m249_crew(self)
	apply_crew_weapon_preset(self.m249_crew, crew_lmg_stats)
end

local orig_init_data_rpk_crew = WeaponTweakData._init_data_rpk_crew
function WeaponTweakData:_init_data_rpk_crew()
	orig_init_data_rpk_crew(self)
	apply_crew_weapon_preset(self.rpk_crew, crew_lmg_stats)
end

local orig_init_data_m95_crew = WeaponTweakData._init_data_m95_crew
function WeaponTweakData:_init_data_m95_crew()
	orig_init_data_m95_crew(self)
	apply_crew_weapon_preset(self.m95_crew, crew_sniper_stats)
end

local orig_init_data_msr_crew = WeaponTweakData._init_data_msr_crew
function WeaponTweakData:_init_data_msr_crew()
	orig_init_data_msr_crew(self)
	apply_crew_weapon_preset(self.msr_crew, crew_sniper_stats)
end

local orig_init_data_r93_crew = WeaponTweakData._init_data_r93_crew
function WeaponTweakData:_init_data_r93_crew()
	orig_init_data_r93_crew(self)
	apply_crew_weapon_preset(self.r93_crew, crew_sniper_stats)
end

local orig_init_data_fal_crew = WeaponTweakData._init_data_fal_crew
function WeaponTweakData:_init_data_fal_crew()
	orig_init_data_fal_crew(self)
	apply_crew_weapon_preset(self.fal_crew, crew_rifle_stats)
end

local orig_init_data_ben_crew = WeaponTweakData._init_data_ben_crew
function WeaponTweakData:_init_data_ben_crew()
	orig_init_data_ben_crew(self)
	apply_crew_weapon_preset(self.ben_crew, crew_shotgun_stats)
end

local orig_init_data_striker_crew = WeaponTweakData._init_data_striker_crew
function WeaponTweakData:_init_data_striker_crew()
	orig_init_data_striker_crew(self)
	apply_crew_weapon_preset(self.striker_crew, crew_shotgun_mag_stats) --Not an auto-shotty, but it's close enough.
end

local orig_init_data_ksg_crew = WeaponTweakData._init_data_ksg_crew
function WeaponTweakData:_init_data_ksg_crew()
	orig_init_data_ksg_crew(self)
	apply_crew_weapon_preset(self.ksg_crew, crew_shotgun_stats)
end

local orig_init_data_g3_crew = WeaponTweakData._init_data_g3_crew
function WeaponTweakData:_init_data_g3_crew()
	orig_init_data_g3_crew(self)
	apply_crew_weapon_preset(self.g3_crew, crew_rifle_stats)
end

local orig_init_data_g3_crew = WeaponTweakData._init_data_g3_crew
function WeaponTweakData:_init_data_galil_crew()
	orig_init_data_g3_crew(self)
	apply_crew_weapon_preset(self.galil_crew, crew_rifle_stats)
end

local orig_init_data_famas_crew = WeaponTweakData._init_data_famas_crew
function WeaponTweakData:_init_data_famas_crew()
	orig_init_data_famas_crew(self)
	apply_crew_weapon_preset(self.famas_crew, crew_rifle_stats)
end

local orig_init_data_scorpion_crew = WeaponTweakData._init_data_scorpion_crew
function WeaponTweakData:_init_data_scorpion_crew()
	orig_init_data_scorpion_crew(self)
	apply_crew_weapon_preset(self.scorpion_crew, crew_smg_stats)
end

local orig_init_data_tec9_crew = WeaponTweakData._init_data_tec9_crew
function WeaponTweakData:_init_data_tec9_crew()
	orig_init_data_tec9_crew(self)
	apply_crew_weapon_preset(self.tec9_crew, crew_smg_stats)
end

local orig_init_data_uzi_crew = WeaponTweakData._init_data_uzi_crew
function WeaponTweakData:_init_data_uzi_crew()
	orig_init_data_uzi_crew(self)
	apply_crew_weapon_preset(self.uzi_crew, crew_smg_stats)
end

local orig_init_data_g26_crew = WeaponTweakData._init_data_g26_crew
function WeaponTweakData:_init_data_g26_crew()
	orig_init_data_g26_crew(self)
	apply_crew_weapon_preset(self.g26_crew, crew_pistol_stats)
end

local orig_init_data_spas12_crew = WeaponTweakData._init_data_spas12_crew
function WeaponTweakData:_init_data_spas12_crew()
	self.spas12_crew.auto = {}
	orig_init_data_spas12_crew(self)
	apply_crew_weapon_preset(self.spas12_crew, crew_shotgun_stats)
end

local orig_init_data_mg42_crew = WeaponTweakData._init_data_mg42_crew
function WeaponTweakData:_init_data_mg42_crew()
	orig_init_data_mg42_crew(self)
	apply_crew_weapon_preset(self.mg42_crew, crew_lmg_stats)
end

orig_init_data_c96_crew = WeaponTweakData._init_data_c96_crew
function WeaponTweakData:_init_data_c96_crew()
	orig_init_data_c96_crew(self)
	apply_crew_weapon_preset(self.c96_crew, crew_pistol_stats)
end

local orig_init_data_sterling_crew = WeaponTweakData._init_data_sterling_crew
function WeaponTweakData:_init_data_sterling_crew()
	orig_init_data_sterling_crew(self)
	apply_crew_weapon_preset(self.sterling_crew, crew_smg_stats)
end

local orig_init_data_mosin_crew = WeaponTweakData._init_data_mosin_crew
function WeaponTweakData:_init_data_mosin_crew()
	orig_init_data_mosin_crew(self)
	apply_crew_weapon_preset(self.mosin_crew, crew_sniper_stats)
end

local orig_init_data_m1928_crew = WeaponTweakData._init_data_m1928_crew
function WeaponTweakData:_init_data_m1928_crew()
	orig_init_data_m1928_crew(self)
	apply_crew_weapon_preset(self.m1928_crew, crew_smg_stats)
end

local orig_init_data_l85a2_crew = WeaponTweakData._init_data_l85a2_crew
function WeaponTweakData:_init_data_l85a2_crew()
	orig_init_data_l85a2_crew(self)
	apply_crew_weapon_preset(self.l85a2_crew, crew_rifle_stats)
end

local orig_init_data_vhs_crew = WeaponTweakData._init_data_vhs_crew
function WeaponTweakData:_init_data_vhs_crew()
	orig_init_data_vhs_crew(self)
	apply_crew_weapon_preset(self.vhs_crew, crew_rifle_stats)
end

local orig_init_data_hs2000_crew = WeaponTweakData._init_data_hs2000_crew
function WeaponTweakData:_init_data_hs2000_crew()
	orig_init_data_hs2000_crew(self)
	apply_crew_weapon_preset(self.hs2000_crew, crew_pistol_stats)
end

local orig_init_data_cobray_crew = WeaponTweakData._init_data_cobray_crew
function WeaponTweakData:_init_data_cobray_crew()
	orig_init_data_cobray_crew(self)
	apply_crew_weapon_preset(self.cobray_crew, crew_smg_stats)
end

local orig_init_data_b682_crew = WeaponTweakData._init_data_b682_crew
function WeaponTweakData:_init_data_b682_crew()
	orig_init_data_b682_crew(self)
	apply_crew_weapon_preset(self.b682_crew, crew_shotgun_double_stats)
end

local orig_init_data_aa12_crew = WeaponTweakData._init_data_aa12_crew
function WeaponTweakData:_init_data_aa12_crew()
	orig_init_data_aa12_crew(self)
	apply_crew_weapon_preset(self.aa12_crew, crew_shotgun_mag_stats)
end

local orig_init_data_peacemaker_crew = WeaponTweakData._init_data_peacemaker_crew
function WeaponTweakData:_init_data_peacemaker_crew()
	orig_init_data_peacemaker_crew(self)
	apply_crew_weapon_preset(self.peacemaker_crew, crew_revolver_stats)
end

local orig_init_data_winchester1874_crew = WeaponTweakData._init_data_winchester1874_crew
function WeaponTweakData:_init_data_winchester1874_crew()
	orig_init_data_winchester1874_crew(self)
	apply_crew_weapon_preset(self.winchester1874_crew, crew_sniper_stats)
end

local orig_init_data_sbl_crew = WeaponTweakData._init_data_sbl_crew
function WeaponTweakData:_init_data_sbl_crew()
	orig_init_data_sbl_crew(self)
	apply_crew_weapon_preset(self.sbl_crew, crew_sniper_stats)
end

local orig_init_data_mateba_crew = WeaponTweakData._init_data_mateba_crew
function WeaponTweakData:_init_data_mateba_crew()
	orig_init_data_mateba_crew(self)
	apply_crew_weapon_preset(self.mateba_crew, crew_revolver_stats)
end

local orig_init_data_asval_crew = WeaponTweakData._init_data_asval_crew
function WeaponTweakData:_init_data_asval_crew()
	orig_init_data_asval_crew(self)
	apply_crew_weapon_preset(self.asval_crew, crew_rifle_stats)
end

local orig_init_data_sub2000_crew = WeaponTweakData._init_data_sub2000_crew
function WeaponTweakData:_init_data_sub2000_crew()
	orig_init_data_sub2000_crew(self)
	apply_crew_weapon_preset(self.sub2000_crew, crew_pistol_stats)
end

local orig_init_data_wa2000_crew = WeaponTweakData._init_data_wa2000_crew
function WeaponTweakData:_init_data_wa2000_crew()
	orig_init_data_wa2000_crew(self)
	apply_crew_weapon_preset(self.wa2000_crew, crew_sniper_stats)
end

local orig_init_data_polymer_crew = WeaponTweakData._init_data_polymer_crew
function WeaponTweakData:_init_data_polymer_crew()
	orig_init_data_polymer_crew(self)
	apply_crew_weapon_preset(self.polymer_crew, crew_smg_stats)
end

local orig_init_data_baka_crew = WeaponTweakData._init_data_baka_crew
function WeaponTweakData:_init_data_baka_crew()
	orig_init_data_baka_crew(self)
	apply_crew_weapon_preset(self.baka_crew, crew_smg_stats)
end

local orig_init_data_pm9_crew = WeaponTweakData._init_data_pm9_crew
function WeaponTweakData:_init_data_pm9_crew()
	orig_init_data_pm9_crew(self)
	apply_crew_weapon_preset(self.pm9_crew, crew_smg_stats)
end

local orig_init_data_par_crew = WeaponTweakData._init_data_par_crew
function WeaponTweakData:_init_data_par_crew()
	orig_init_data_par_crew(self)
	apply_crew_weapon_preset(self.par_crew, crew_lmg_stats)
	apply_crew_weapon_preset(self.par_secondary_crew, crew_lmg_stats)
end

local orig_init_data_sparrow_crew = WeaponTweakData._init_data_sparrow_crew
function WeaponTweakData:_init_data_sparrow_crew()
	orig_init_data_sparrow_crew(self)
	apply_crew_weapon_preset(self.sparrow_crew, crew_pistol_stats)
end

local orig_init_data_model70_crew = WeaponTweakData._init_data_model70_crew
function WeaponTweakData:_init_data_model70_crew()
	orig_init_data_model70_crew(self)
	apply_crew_weapon_preset(self.model70_crew, crew_sniper_stats)
	apply_crew_weapon_preset(self.model70_secondary_crew, crew_sniper_stats)
end

local orig_init_data_m37_crew = WeaponTweakData._init_data_m37_crew
function WeaponTweakData:_init_data_m37_crew()
	orig_init_data_m37_crew(self)
	apply_crew_weapon_preset(self.m37_crew, crew_shotgun_stats)
end

local orig_init_data_m1897_crew = WeaponTweakData._init_data_m1897_crew
function WeaponTweakData:_init_data_m1897_crew()
	orig_init_data_m1897_crew(self)
	apply_crew_weapon_preset(self.m1897_crew, crew_shotgun_stats)
end

local orig_init_data_sr2_crew = WeaponTweakData._init_data_sr2_crew
function WeaponTweakData:_init_data_sr2_crew()
	orig_init_data_sr2_crew(self)
	apply_crew_weapon_preset(self.sr2_crew, crew_smg_stats)
end

local orig_init_data_pl14_crew = WeaponTweakData._init_data_pl14_crew
function WeaponTweakData:_init_data_pl14_crew()
	orig_init_data_pl14_crew(self)
	apply_crew_weapon_preset(self.pl14_crew, crew_pistol_stats)
end

local orig_init_data_m1911_crew = WeaponTweakData._init_data_m1911_crew
function WeaponTweakData:_init_data_m1911_crew()
	orig_init_data_m1911_crew(self)
	apply_crew_weapon_preset(self.m1911_crew, crew_pistol_stats)
end

local orig_init_data_m590_crew = WeaponTweakData._init_data_m590_crew
function WeaponTweakData:_init_data_m590_crew()
	orig_init_data_m590_crew(self)
	apply_crew_weapon_preset(self.m590_crew, crew_shotgun_stats)
end

local orig_init_data_vityaz_crew = WeaponTweakData._init_data_vityaz_crew
function WeaponTweakData:_init_data_vityaz_crew()
	orig_init_data_vityaz_crew(self)
	apply_crew_weapon_preset(self.vityaz_crew, crew_smg_stats)
	apply_crew_weapon_preset(self.vityaz_primary_crew, crew_smg_stats)
end

local orig_init_data_tecci_crew = WeaponTweakData._init_data_tecci_crew
function WeaponTweakData:_init_data_tecci_crew()
	orig_init_data_tecci_crew(self)
	apply_crew_weapon_preset(self.tecci_crew, crew_lmg_stats) --Lets be real here, this is more of an lmg-ish gun.
end

local orig_init_data_hajk_crew = WeaponTweakData._init_data_hajk_crew
function WeaponTweakData:_init_data_hajk_crew()
	orig_init_data_hajk_crew(self)
	apply_crew_weapon_preset(self.hajk_crew, crew_rifle_stats)
end

local orig_init_data_boot_crew = WeaponTweakData._init_data_boot_crew
function WeaponTweakData:_init_data_boot_crew()
	orig_init_data_boot_crew(self)
	apply_crew_weapon_preset(self.boot_crew, crew_shotgun_stats)
end

local orig_init_data_packrat_crew = WeaponTweakData._init_data_packrat_crew
function WeaponTweakData:_init_data_packrat_crew()
	orig_init_data_packrat_crew(self)
	apply_crew_weapon_preset(self.packrat_crew, crew_pistol_stats)
end

local orig_init_data_schakal_crew = WeaponTweakData._init_data_schakal_crew
function WeaponTweakData:_init_data_schakal_crew()
	orig_init_data_schakal_crew(self)
	apply_crew_weapon_preset(self.schakal_crew, crew_smg_stats)
end

local orig_init_data_desertfox_crew = WeaponTweakData._init_data_desertfox_crew
function WeaponTweakData:_init_data_desertfox_crew()
	orig_init_data_desertfox_crew(self)
	apply_crew_weapon_preset(self.desertfox_crew, crew_sniper_stats)
	apply_crew_weapon_preset(self.desertfox_secondary_crew, crew_sniper_stats)
end

local orig_init_data_rota_crew = WeaponTweakData._init_data_rota_crew
function WeaponTweakData:_init_data_rota_crew()
	orig_init_data_rota_crew(self)
	apply_crew_weapon_preset(self.rota_crew, crew_shotgun_stats)
end

local orig_init_data_contraband_crew = WeaponTweakData._init_data_contraband_crew
function WeaponTweakData:_init_data_contraband_crew()
	orig_init_data_contraband_crew(self)
	apply_crew_weapon_preset(self.contraband_crew, crew_underbarrel_rifle_stats)
end

local orig_init_data_tti_crew = WeaponTweakData._init_data_tti_crew
function WeaponTweakData:_init_data_tti_crew()
	orig_init_data_tti_crew(self)
	apply_crew_weapon_preset(self.tti_crew, crew_sniper_stats)
end

local orig_init_data_siltstone_crew = WeaponTweakData._init_data_siltstone_crew
function WeaponTweakData:_init_data_siltstone_crew()
	orig_init_data_siltstone_crew(self)
	apply_crew_weapon_preset(self.siltstone_crew, crew_sniper_stats)
end

local orig_init_data_flint_crew = WeaponTweakData._init_data_flint_crew
function WeaponTweakData:_init_data_flint_crew()
	orig_init_data_flint_crew(self)
	apply_crew_weapon_preset(self.flint_crew, crew_rifle_stats)
end

local orig_init_data_coal_crew = WeaponTweakData._init_data_coal_crew
function WeaponTweakData:_init_data_coal_crew()
	orig_init_data_coal_crew(self)
	apply_crew_weapon_preset(self.coal_crew, crew_smg_stats)
end

local orig_init_data_lemming_crew = WeaponTweakData._init_data_lemming_crew
function WeaponTweakData:_init_data_lemming_crew()
	orig_init_data_lemming_crew(self)
	apply_crew_weapon_preset(self.lemming_crew, crew_pistol_stats)
end

local orig_init_data_chinchilla_crew = WeaponTweakData._init_data_chinchilla_crew
function WeaponTweakData:_init_data_chinchilla_crew()
	orig_init_data_chinchilla_crew(self)
	apply_crew_weapon_preset(self.chinchilla_crew, crew_revolver_stats)
end

local orig_init_data_model3_crew = WeaponTweakData._init_data_model3_crew
function WeaponTweakData:_init_data_model3_crew()
	orig_init_data_model3_crew(self)
	apply_crew_weapon_preset(self.model3_crew, crew_revolver_stats)
end

local orig_init_data_shepheard_crew = WeaponTweakData._init_data_shepheard_crew
function WeaponTweakData:_init_data_shepheard_crew()
	orig_init_data_shepheard_crew(self)
	apply_crew_weapon_preset(self.shepheard_crew, crew_smg_stats)
end

local orig_init_data_breech_crew = WeaponTweakData._init_data_breech_crew
function WeaponTweakData:_init_data_breech_crew()
	orig_init_data_breech_crew(self)
	apply_crew_weapon_preset(self.breech_crew, crew_pistol_stats)
end

local orig_init_data_ching_crew = WeaponTweakData._init_data_ching_crew
function WeaponTweakData:_init_data_ching_crew()
	orig_init_data_ching_crew(self)
	apply_crew_weapon_preset(self.ching_crew, crew_dmr_stats)
end

local orig_init_data_erma_crew = WeaponTweakData._init_data_erma_crew
function WeaponTweakData:_init_data_erma_crew()
	orig_init_data_erma_crew(self)
	apply_crew_weapon_preset(self.erma_crew, crew_smg_stats)
end

local orig_init_data_shrew_crew = WeaponTweakData._init_data_shrew_crew
function WeaponTweakData:_init_data_shrew_crew()
	orig_init_data_shrew_crew(self)
	apply_crew_weapon_preset(self.shrew_crew, crew_pistol_stats)
end

local orig_init_data_qbu88_crew = WeaponTweakData._init_data_qbu88_crew
function WeaponTweakData:_init_data_qbu88_crew()
	orig_init_data_qbu88_crew(self)
	apply_crew_weapon_preset(self.qbu88_crew, crew_sniper_stats)
end

local orig_init_data_groza_crew = WeaponTweakData._init_data_groza_crew
function WeaponTweakData:_init_data_groza_crew()
	orig_init_data_groza_crew(self)
	apply_crew_weapon_preset(self.groza_crew, crew_underbarrel_rifle_stats)
end

local orig_init_data_basset_crew = WeaponTweakData._init_data_basset_crew
function WeaponTweakData:_init_data_basset_crew()
	orig_init_data_basset_crew(self)
	apply_crew_weapon_preset(self.basset_crew, crew_shotgun_mag_stats)
end

local orig_init_data_corgi_crew = WeaponTweakData._init_data_corgi_crew
function WeaponTweakData:_init_data_corgi_crew()
	orig_init_data_corgi_crew(self)
	apply_crew_weapon_preset(self.corgi_crew, crew_rifle_stats)
end

local orig_init_data_komodo_crew = WeaponTweakData._init_data_komodo_crew
function WeaponTweakData:_init_data_komodo_crew()
	orig_init_data_komodo_crew(self)
	apply_crew_weapon_preset(self.komodo_crew, crew_rifle_stats)
end

local orig_init_data_legacy_crew = WeaponTweakData._init_data_legacy_crew
function WeaponTweakData:_init_data_legacy_crew()
	orig_init_data_legacy_crew(self)
	apply_crew_weapon_preset(self.legacy_crew, crew_pistol_stats)
end

local orig_init_data_coach_crew = WeaponTweakData._init_data_coach_crew
function WeaponTweakData:_init_data_coach_crew()
	orig_init_data_coach_crew(self)
	apply_crew_weapon_preset(self.coach_crew, crew_shotgun_double_stats)
end

local orig_init_data_beer_crew = WeaponTweakData._init_data_beer_crew
function WeaponTweakData:_init_data_beer_crew()
	orig_init_data_beer_crew(self)
	apply_crew_weapon_preset(self.beer_crew, crew_smg_stats) --Closer to an SMG.
end

local orig_init_data_czech_crew = WeaponTweakData._init_data_czech_crew
function WeaponTweakData:_init_data_czech_crew()
	orig_init_data_czech_crew(self)
	apply_crew_weapon_preset(self.czech_crew, crew_smg_stats)
end

local orig_init_data_stech_crew = WeaponTweakData._init_data_stech_crew
function WeaponTweakData:_init_data_stech_crew()
	orig_init_data_stech_crew(self)
	apply_crew_weapon_preset(self.stech_crew, crew_smg_stats)
end

local orig_init_data_holt_crew = WeaponTweakData._init_data_holt_crew
function WeaponTweakData:_init_data_holt_crew()
	orig_init_data_holt_crew(self)
	apply_crew_weapon_preset(self.holt_crew, crew_pistol_stats)
end

local orig_init_data_m60_crew = WeaponTweakData._init_data_m60_crew
function WeaponTweakData:_init_data_m60_crew()
	orig_init_data_m60_crew(self)
	apply_crew_weapon_preset(self.m60_crew, crew_lmg_stats)
end

local orig_init_data_r700_crew = WeaponTweakData._init_data_r700_crew
function WeaponTweakData:_init_data_r700_crew()
	orig_init_data_r700_crew(self)
	apply_crew_weapon_preset(self.r700_crew, crew_sniper_stats)
end

local orig_init_data_hk51b_crew = WeaponTweakData._init_data_hk51b_crew
function WeaponTweakData:_init_data_hk51b_crew()
	orig_init_data_hk51b_crew(self)
	apply_crew_weapon_preset(self.hk51b_crew, crew_lmg_stats)
end

local orig_init_data_scout_crew = WeaponTweakData._init_data_scout_crew
function WeaponTweakData:_init_data_scout_crew()
	orig_init_data_scout_crew(self)
	apply_crew_weapon_preset(self.scout_crew, crew_sniper_stats)
end

function WeaponTweakData:_init_data_flamethrower_mk2_crew()
	--TODO
end