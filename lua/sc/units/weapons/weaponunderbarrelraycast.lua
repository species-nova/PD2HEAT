--Use original functions for these since these wrappers do literally nothing except complicate shit.
WeaponUnderbarrelRaycast._get_tweak_data_weapon_animation = WeaponUnderbarrel._get_tweak_data_weapon_animation
WeaponUnderbarrelRaycast._get_sound_event = WeaponUnderbarrel._get_sound_event
WeaponUnderbarrelRaycast.fire_mode = WeaponUnderbarrel.fire_mode
WeaponUnderbarrelRaycast.reload_prefix = WeaponUnderbarrel.reload_prefix
WeaponUnderbarrelRaycast._check_alert = RaycastWeaponBase._check_alert
WeaponUnderbarrelRaycast._build_suppression = RaycastWeaponBase._build_suppression
WeaponUnderbarrelShotgunRaycast._get_tweak_data_weapon_animation = WeaponUnderbarrel._get_tweak_data_weapon_animation
WeaponUnderbarrelShotgunRaycast.can_toggle_firemode = WeaponUnderbarrel.can_toggle_firemode
WeaponUnderbarrelShotgunRaycast.reload_prefix = WeaponUnderbarrel.reload_prefix
WeaponUnderbarrelShotgunRaycast.is_single_shot = WeaponUnderbarrel.is_single_shot
WeaponUnderbarrelShotgunRaycast._check_alert = ShotgunBase._check_alert
WeaponUnderbarrelShotgunRaycast._build_suppression = ShotgunBase._build_suppression

--Leave these untouched since launchers require knowledge about the parent weapon base to be passed in.
--WeaponUnderbarrelRaycast._fire_raycast = RaycastWeaponBase._fire_raycast
--WeaponUnderbarrelShotgunRaycast._fire_raycast = ShotgunBase._fire_raycast

function WeaponUnderbarrelRaycast:holds_single_round()
	return self._ammo:get_ammo_max_per_clip() == 1
end

function WeaponUnderbarrelShotgunRaycast:holds_single_round()
	return self._ammo:get_ammo_max_per_clip() == 1
end