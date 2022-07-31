local orig_init = PlayerTurretBase.init
function PlayerTurretBase:init(unit)
	orig_init(self, unit)
	self._current_stats_indices = self:weapon_tweak_data().stats
	self._check_skills = true
end

local orig_on_player_enter = PlayerTurretBase.on_player_enter
function PlayerTurretBase:on_player_enter(player_unit)
	orig_on_player_enter(self, player_unit)
	if self._check_skills then
		NewRaycastWeaponBase.heat_init(self) --Needed for various skill flags. Called in game since the player might have a different build than they did in the loading screen.
		self._shield_knock = managers.player:has_category_upgrade("player", "shield_knock")
		self._check_skills = false
	end
end

function PlayerTurretBase:_get_spread()
	return PlayerTurretBase.super._get_spread(self)
end

function PlayerTurretBase:fire_rate_multiplier()
	return NewRaycastWeaponBase.fire_rate_multiplier(self)
end

--Call this whenever the gun is fired to update to the latest values, since skills can change it in realtime.
function PlayerTurretBase:_compute_falloff_distance(user_unit)
	--Initialize base info.
	local falloff_info = tweak_data.weapon.stat_info.damage_falloff
	local current_state = user_unit:movement()._current_state
	local base_falloff = falloff_info.base
	local pm = managers.player

	base_falloff = base_falloff + falloff_info.acc_bonus * (self._current_stats_indices.spread + managers.blackmarket:accuracy_index_addend(self._name_id, self:categories(), self._silencer, current_state, self:fire_mode(), self._blueprint) - 1)

	--Apply global range multipliers.
	base_falloff = base_falloff * (1 + 1 - pm:get_property("desperado", 1))
	base_falloff = base_falloff * (1 + 1 - pm:temporary_upgrade_value("temporary", "silent_precision", 1))

	base_falloff = base_falloff * (self:weapon_tweak_data().range_mul or 1)
	for _, category in ipairs(self:categories()) do
		if tweak_data[category] and tweak_data[category].range_mul then
			base_falloff = base_falloff * tweak_data[category].range_mul
		end
	end

	--Cache falloff values for usage in hitmarkers and other range-related calculations.
	self.near_falloff_distance = base_falloff
	self.far_falloff_distance = base_falloff * 2
end

function PlayerTurretBase:weapon_range()
	if self.near_falloff_distance then
		return self.near_falloff_distance + self.far_falloff_distance
	else
		return self._weapon_range or 20000
	end
end