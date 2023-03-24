--Player Sentry Gun
local orig_init_data_sentry_gun_npc = WeaponTweakData._init_data_sentry_gun_npc
function WeaponTweakData:_init_data_sentry_gun_npc()
	orig_init_data_sentry_gun_npc(self)
	self.sentry_gun.DAMAGE = 2
	self.sentry_gun.SPREAD = 2
	self.sentry_gun.FIRE_RANGE = 2500
	self.sentry_gun.DETECTION_RANGE = self.sentry_gun.FIRE_RANGE
	self.sentry_gun.auto.fire_rate = 0.175
end

--Function to apply stat template to enemy sentry guns.
local known_sentry_guns = {}
local function apply_sentry_stats(sentry_gun, health_multiplier)
	table.insert(known_sentry_guns, sentry_gun)
	sentry_gun.DAMAGE = 4
	sentry_gun.DAMAGE_MUL_RANGE = {
		{2250, 1},
		{4500, 0.5},
		{6750, 0}
	}

	sentry_gun.CLIP_SIZE = 250
	sentry_gun.SPREAD = 3
	sentry_gun.FIRE_RANGE = 6750
	sentry_gun.DETECTION_DELAY = {
		{1125, 0.3},
		{2250, 0.6},
		{4500, 1.5},
		{7000, 3.0}
	}
	sentry_gun.DETECTION_RANGE = 7000
	sentry_gun.BODY_DAMAGE_CLAMP = nil
	sentry_gun.SHIELD_DAMAGE_CLAMP = nil
	sentry_gun.auto.fire_rate = 0.06
	sentry_gun.BAG_DMG_MUL = 10
	sentry_gun.EXPLOSION_DMG_MUL = 10
	sentry_gun.FIRE_DMG_MUL = 1
	sentry_gun.HEALTH_INIT = 600 * (health_multiplier or 1)
	sentry_gun.SHIELD_HEALTH_INIT = 72
	sentry_gun.MAX_VEL_SPIN = 48
	sentry_gun.MIN_VEL_SPIN = 2.4
	sentry_gun.MAX_VEL_PITCH = sentry_gun.MAX_VEL_SPIN
	sentry_gun.MIN_VEL_PITCH = sentry_gun.MIN_VEL_SPIN
	sentry_gun.ECM_HACKABLE = true

	if sentry_gun.AUTO_REPAIR then
		sentry_gun.AUTO_REPAIR_MAX_COUNT = 3
		sentry_gun.AUTO_REPAIR_DURATION = 120
	end
end

local orig_init_data_swat_van_turret_module_npc = WeaponTweakData._init_data_swat_van_turret_module_npc
function WeaponTweakData:_init_data_swat_van_turret_module_npc()
	orig_init_data_swat_van_turret_module_npc(self)
	apply_sentry_stats(self.swat_van_turret_module, 2)
end

local orig_init_data_crate_turret_module_npc = WeaponTweakData._init_data_crate_turret_module_npc
function WeaponTweakData:_init_data_crate_turret_module_npc()
	orig_init_data_crate_turret_module_npc(self)
	apply_sentry_stats(self.crate_turret_module)
end

local orig_init_data_ceiling_turret_module_npc = WeaponTweakData._init_data_ceiling_turret_module_npc
function WeaponTweakData:_init_data_ceiling_turret_module_npc()
	orig_init_data_ceiling_turret_module_npc(self)
	apply_sentry_stats(self.ceiling_turret_module)
	apply_sentry_stats(self.ceiling_turret_module_no_idle)
	apply_sentry_stats(self.ceiling_turret_module_longer_range)
end

local orig_init_data_aa_turret_module_npc = WeaponTweakData._init_data_aa_turret_module_npc
function WeaponTweakData:_init_data_aa_turret_module_npc()
	orig_init_data_aa_turret_module_npc(self)
	apply_sentry_stats(self.aa_turret_module)
end

local function multiply_all_sentry_health_and_damage(health_multiplier, damage_multiplier)
	--Levels with Helicopter sentries get nerfs on top of difficulty adjustments.
	local allow_autorepair = true
	local job = Global.level_data and Global.level_data.level_id
	if job == "chew" or job == "glace" then
		allow_autorepair = false
	end

	for i = 1, #known_sentry_guns do
		local sentry_gun = known_sentry_guns[i]
		sentry_gun.HEALTH_INIT = sentry_gun.HEALTH_INIT * health_multiplier
		sentry_gun.SHIELD_HEALTH_INIT = sentry_gun.SHIELD_HEALTH_INIT * health_multiplier
		sentry_gun.DAMAGE = sentry_gun.DAMAGE * damage_multiplier
		sentry_gun.AUTO_REPAIR = sentry_gun.AUTO_REPAIR and allow_autorepair
	end
	known_sentry_guns = nil
end

--Damage scaling on NPC guns is handled via CharacterTweakData on weapon handling presets.
function WeaponTweakData:_set_normal()
	multiply_all_sentry_health_and_damage(0.5, 0.3)
end

function WeaponTweakData:_set_hard()
	multiply_all_sentry_health_and_damage(0.625, 0.5)
end

function WeaponTweakData:_set_overkill()
	multiply_all_sentry_health_and_damage(0.75, 0.7)
end

function WeaponTweakData:_set_overkill_145()
	multiply_all_sentry_health_and_damage(0.875, 0.9)
end

function WeaponTweakData:_set_easy_wish()
end

function WeaponTweakData:_set_overkill_290()
end

function WeaponTweakData:_set_sm_wish()
end