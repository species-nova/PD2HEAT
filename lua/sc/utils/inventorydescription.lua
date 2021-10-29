WeaponDescription._stats_shown = {
	{
		round_value = true,
		name = "magazine",
		stat_name = "extra_ammo"
	},
	{
		round_value = true,
		name = "totalammo",
		stat_name = "total_ammo_mod"
	},
	{
		round_value = true,
		name = "fire_rate"
	},
	{
		round_value = true,
		present_multiplier = 10,
		name = "damage"
	},
	{
		use_index = true,
		present_multiplier = 4,
		name = "spread"
	},
	{
		use_index = true,
		present_multiplier = 4,
		name = "recoil"
	},
	{
		use_index = true,
		present_multiplier = 4,
		name = "concealment"
	},
	{
		name = "reload"
	},
	{
		derived = true,
		name = "swap_speed"
	},
	{
		derived = true,
		present_multiplier = 0.01,
		name = "range"
	},
	{
		derived = true,
		name = "pickup"
	}
}

function get_range_mul(weapon_tweak)
	local category_mul = 1
	for i = 1, #weapon_tweak.categories do
		local category = weapon_tweak.categories[i]
		if category == "rocket_frag" or category == "grenade_launcher" or category == "bow" or category == "saw" or category == "crossbow" then
			return nil
		elseif tweak_data[category] and tweak_data[category].range_mul then
			category_mul = category_mul * tweak_data[category].range_mul
		end
	end
	return category_mul
end

function get_swap_mul(weapon_tweak)
	local multiplier = 1
	local skill_multiplier = 1
	skill_multiplier = skill_multiplier + managers.player:upgrade_value("weapon", "swap_speed_multiplier", 1) - 1
	skill_multiplier = skill_multiplier + managers.player:upgrade_value("weapon", "passive_swap_speed_multiplier", 1) - 1

	for _, category in ipairs(weapon_tweak.categories) do
		if tweak_data[category] and tweak_data[category].swap_bonus then
			multiplier = multiplier * tweak_data[category].swap_bonus
			skill_multiplier = skill_multiplier + managers.player:upgrade_value(category, "swap_speed_multiplier", 1) - 1
		end
	end

	multiplier = multiplier * (weapon_tweak.swap_speed_multiplier or 1)

	return multiplier, skill_multiplier
end

--Add support for .reload_speed_multiplier
function WeaponDescription._get_base_stats(name)
	local base_stats = {}
	local index = nil
	local weapon_tweak = tweak_data.weapon[name]
	local tweak_stats = tweak_data.weapon.stats

	function getGenericStatValue(stat)
		index = math.clamp(tweak_data.weapon[name].stats[stat.name], 1, #tweak_stats[stat.name])
		base_stats[stat.name].index = index
		base_stats[stat.name].value = stat.use_index and index or tweak_stats[stat.name][index]
	end

	--Get primary stat raw values.
	for _, stat in pairs(WeaponDescription._stats_shown) do
		base_stats[stat.name] = {}

		if stat.name == "magazine" then
			base_stats.magazine.index = 0
			base_stats.magazine.value = tweak_data.weapon[name].CLIP_AMMO_MAX
		elseif stat.name == "totalammo" then
			index = math.clamp(weapon_tweak.stats.total_ammo_mod, 1, #tweak_stats.total_ammo_mod)
			base_stats.totalammo.index = weapon_tweak.stats.total_ammo_mod
			base_stats.totalammo.value = weapon_tweak.AMMO_MAX
		elseif stat.name == "fire_rate" then
			local fire_rate = 60 * (weapon_tweak.fire_rate_multiplier or 1) / weapon_tweak.fire_mode_data.fire_rate
			base_stats.fire_rate.value = fire_rate / 10 * 10
		elseif stat.name == "reload" then
			index = math.clamp(weapon_tweak.stats.reload, 1, #tweak_stats[stat.name])
			base_stats[stat.name].index = tweak_data.weapon[name].stats.reload
			local reload_time = managers.blackmarket:get_reload_time(name) / (weapon_tweak.reload_speed_multiplier or 1)
			local mult = 1 / tweak_data.weapon.stats.reload[index]
			base_stats.reload.value = reload_time * mult
		elseif stat.name == "damage" then
			getGenericStatValue(stat)
			local modifier_stats = weapon_tweak.stats_modifiers
			base_stats.damage.value = base_stats.damage.value * (modifier_stats and modifier_stats.damage or 1)
		elseif not stat.derived then
			getGenericStatValue(stat)
		end
	end

	--Get derived stat raw values.
	for _, stat in pairs(WeaponDescription._stats_shown) do
		if stat.name == "swap_speed" then --Swap speed is derived from mobility (concealment).
			local multiplier = get_swap_mul(weapon_tweak)
			multiplier = multiplier * tweak_stats.mobility[base_stats.concealment.index]
			base_stats.swap_speed.value = (weapon_tweak.timers.equip + weapon_tweak.timers.unequip) / multiplier
		elseif stat.name == "pickup" then
			base_stats.pickup.value = (weapon_tweak.AMMO_PICKUP[1] + weapon_tweak.AMMO_PICKUP[2]) * 0.5
		elseif stat.name == "range" then --Range is derived from accuracy.
			local category_mul = get_range_mul(weapon_tweak)

			if category_mul then
				local falloff_info = tweak_data.weapon.stat_info.damage_falloff
				local base_falloff = falloff_info.base
				local acc_bonus = falloff_info.acc_bonus * base_stats.spread.index

				local range = (base_falloff + acc_bonus) * category_mul
				if weapon_tweak.rays and weapon_tweak.rays > 1 then
					range = range * falloff_info.shotgun_penalty
				end

				base_stats.range.value = range
			else
				base_stats.range.value = -1 --Set the text for this to be blank.
			end
		end
	end

	return base_stats
end

function WeaponDescription._get_mods_stats(name, base_stats, equipped_mods, bonus_stats, blueprint)
	local mods_stats = {}
	for _, stat in pairs(WeaponDescription._stats_shown) do
		mods_stats[stat.name] = {}
		mods_stats[stat.name].index = 0
		mods_stats[stat.name].value = 0
	end

	if equipped_mods then
		local weapon_tweak = tweak_data.weapon[name]
		local tweak_stats = tweak_data.weapon.stats
		local tweak_factory = tweak_data.weapon.factory.parts
		local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(name)
		local default_blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)
		local ammo_data = managers.weapon_factory:get_ammo_data_from_weapon(factory_id, blueprint) or {}

		if bonus_stats then
			for _, stat in pairs(WeaponDescription._stats_shown) do
				if stat.name == "magazine" then
					local ammo = mods_stats.magazine.index
					ammo = ammo and ammo + (tweak_data.weapon[name].stats.extra_ammo or 0)
					mods_stats.magazine.value = mods_stats.magazine.value + (ammo and tweak_data.weapon.stats.extra_ammo[ammo] or 0)
				elseif stat.name == "totalammo" then
					local ammo = bonus_stats.total_ammo_mod
					mods_stats.totalammo.index = mods_stats.totalammo.index + (ammo or 0)
				elseif not stat.derived then
					mods_stats[stat.name].index = mods_stats[stat.name].index + (bonus_stats[stat.name] or 0)
				end
			end
		end

		local part_data, reload_total_index
		for _, mod in ipairs(equipped_mods) do
			part_data = managers.weapon_factory:get_part_data_by_part_id_from_weapon(mod, factory_id, default_blueprint)
			if part_data then
				for _, stat in pairs(WeaponDescription._stats_shown) do
					if part_data.stats and not stat.derived then
						if stat.name == "magazine" then
							local ammo = part_data.stats.extra_ammo
							ammo = ammo and ammo + (weapon_tweak.stats.extra_ammo or 0)
							mods_stats.magazine.value = mods_stats.magazine.value + (ammo and tweak_data.weapon.stats.extra_ammo[ammo] or 0)
						elseif stat.name == "totalammo" then
							local ammo = part_data.stats.total_ammo_mod
							mods_stats.totalammo.index = mods_stats.totalammo.index + (ammo or 0)
						elseif stat.name == "reload" then
							local chosen_index = part_data.stats.reload or 0
							chosen_index = chosen_index and chosen_index + (weapon_tweak.stats.reload or 0)
							reload_total_index = (reload_total_index and reload_total_index + (chosen_index - weapon_tweak.stats.reload)) or (chosen_index - weapon_tweak.stats.reload)
							local mult = 1 / tweak_data.weapon.stats.reload[weapon_tweak.stats.reload + reload_total_index]
							mods_stats.reload.value = base_stats.reload.value * mult
							mods_stats.reload.index = reload_total_index
						else
							mods_stats[stat.name].index = mods_stats[stat.name].index + (part_data.stats[stat.name] or 0)
						end
					end
				end
			end
		end

		local index
		for _, stat in pairs(WeaponDescription._stats_shown) do
			if mods_stats[stat.name].index and tweak_stats[stat.name] and not stat.derived then
				index = math.clamp(base_stats[stat.name].index + mods_stats[stat.name].index, 1, #tweak_stats[stat.name])

				if stat.name ~= "reload" then
					mods_stats[stat.name].value = stat.use_index and index or tweak_stats[stat.name][index]
				end

				if stat.name == "damage" then
					local modifier_stats = tweak_data.weapon[name].stats_modifiers
					mods_stats.damage.value = mods_stats.damage.value * (modifier_stats and modifier_stats.damage or 1)
				end
				
				mods_stats[stat.name].value = mods_stats[stat.name].value - base_stats[stat.name].value
			end
		end
			
		for _, stat in pairs(WeaponDescription._stats_shown) do
			if stat.name == "swap_speed" then
				local multiplier = get_swap_mul(weapon_tweak)				
				multiplier = multiplier * tweak_data.weapon.stats.mobility[base_stats.concealment.value + mods_stats.concealment.value]
				mods_stats.swap_speed.value = (weapon_tweak.timers.equip + weapon_tweak.timers.unequip) / multiplier - base_stats.swap_speed.value
			elseif stat.name == "range" then
				local category_mul = get_range_mul(weapon_tweak)

				if category_mul then
					local falloff_info = tweak_data.weapon.stat_info.damage_falloff
					local base_falloff = falloff_info.base
					local acc_bonus = falloff_info.acc_bonus * (base_stats.spread.value + mods_stats.spread.value)
					local base_range = base_stats.range.value

					local range = (base_falloff + acc_bonus) * category_mul

					if weapon_tweak.rays and weapon_tweak.rays > 1 and not (ammo_data.rays and ammo_data.rays == 1) then
						range = range * falloff_info.shotgun_penalty
					end

					if ammo_data.damage_near_mul then
						range = range * ammo_data.damage_near_mul
					end

					mods_stats.range.value = range - base_range
				else
					mods_stats.range.value = 0
				end
			elseif stat.name == "pickup" then
				local min_pickup = weapon_tweak.AMMO_PICKUP[1] * (ammo_data.ammo_pickup_min_mul or 1)
				local max_pickup = weapon_tweak.AMMO_PICKUP[2] * (ammo_data.ammo_pickup_max_mul or 1)
				local average_pickup = (min_pickup + max_pickup) * 0.5
				mods_stats.pickup.value = average_pickup - base_stats.pickup.value
			end
		end
	end

	return mods_stats
end

function WeaponDescription._get_weapon_mod_stats(mod_name, weapon_name, base_stats, mods_stats, equipped_mods)
	local tweak_stats = tweak_data.weapon.stats
	local tweak_factory = tweak_data.weapon.factory.parts
	local weapon_tweak = tweak_data.weapon[weapon_name]
	local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(weapon_name)
	local default_blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)
	local part_data = nil
	local mod_stats = {
		chosen = {},
		equip = {}
	}

	for _, stat in pairs(WeaponDescription._stats_shown) do
		mod_stats.chosen[stat.name] = 0
		mod_stats.equip[stat.name] = 0
	end

	mod_stats.chosen.name = mod_name

	if equipped_mods then
		for _, mod in ipairs(equipped_mods) do
			if tweak_factory[mod] and tweak_factory[mod_name].type == tweak_factory[mod].type then
				mod_stats.equip.name = mod

				break
			end
		end
	end

	local index, wanted_index = nil

	local function getGenericStatValue(mod, part_data, stat)
		if part_data.stats[stat.name] then
			wanted_index = base_stats[stat.name].index + part_data.stats[stat.name]
			index = math.clamp(wanted_index, 1, #tweak_stats[stat.name])
			mod[stat.name] = stat.use_index and wanted_index - base_stats[stat.name].index or tweak_stats[stat.name][index] - tweak_stats[stat.name][base_stats[stat.name].index]
		end
	end

	for _, mod in pairs(mod_stats) do
		part_data = nil

		if mod.name then
			if tweak_data.blackmarket.weapon_skins[mod.name] and tweak_data.blackmarket.weapon_skins[mod.name].bonus and tweak_data.economy.bonuses[tweak_data.blackmarket.weapon_skins[mod.name].bonus] then
				part_data = {
					stats = tweak_data.economy.bonuses[tweak_data.blackmarket.weapon_skins[mod.name].bonus].stats
				}
			else
				part_data = managers.weapon_factory:get_part_data_by_part_id_from_weapon(mod.name, factory_id, default_blueprint)
			end
		end

		--Calculate main stats.
		for _, stat in pairs(WeaponDescription._stats_shown) do
			if part_data and part_data.stats then
				if stat.name == "magazine" then
					local ammo = part_data.stats.extra_ammo
					ammo = ammo and ammo + (weapon_tweak.stats.extra_ammo or 0)
					mod[stat.name] = ammo and tweak_data.weapon.stats.extra_ammo[ammo] or 0
				elseif stat.name == "totalammo" then
					local chosen_index = part_data.stats.total_ammo_mod or 0
					chosen_index = math.clamp(base_stats.totalammo.index + chosen_index, 1, #tweak_stats.total_ammo_mod)
					mod.totalammo = base_stats.totalammo.value * tweak_stats.total_ammo_mod[chosen_index]
				elseif stat.name == "reload" then
					local chosen_index = part_data.stats.reload or 0
					chosen_index = math.clamp(base_stats.reload.index + chosen_index, 1, #tweak_stats.reload)
					local reload_time = managers.blackmarket:get_reload_time(weapon_name)
					local mult = 1 / tweak_data.weapon.stats.reload[chosen_index]
					local mod_value = reload_time * mult
					mod.reload = mod_value - base_stats.reload.value
				elseif stat.name == "damage" then
					getGenericStatValue(mod, part_data, stat)
					local modifier_stats = weapon_tweak.stats_modifiers
					mod.damage = mod.damage * (modifier_stats and modifier_stats.damage or 1)
				elseif not stat.derived and stat.name ~= "fire_rate" then
					getGenericStatValue(mod, part_data, stat)
				end
			end
		end

		--Calculate derived stats.
		for _, stat in pairs(WeaponDescription._stats_shown) do
			if part_data and part_data.stats then
				if stat.name == "range" then
					local category_mul = get_range_mul(weapon_tweak)
					local falloff_info = tweak_data.weapon.stat_info.damage_falloff
					local base_falloff = falloff_info.base
					local acc_bonus = falloff_info.acc_bonus * (base_stats.spread.value + mod.spread)
					local base_range = base_stats.range.value

					local range = (base_falloff + acc_bonus) * category_mul

					if weapon_tweak.rays and weapon_tweak.rays > 1 and not (part_data.custom_stats and part_data.custom_stats.rays == 1) then
						range = range * falloff_info.shotgun_penalty
					end

					if part_data.custom_stats and part_data.custom_stats.damage_near_mul then
						range = range * part_data.custom_stats.damage_near_mul
					end

					mod.range = range - base_range
				elseif stat.name == "pickup" then
					local min_pickup = weapon_tweak.AMMO_PICKUP[1] * (part_data.custom_stats and part_data.custom_stats.ammo_pickup_min_mul or 1)
					local max_pickup = weapon_tweak.AMMO_PICKUP[2] * (part_data.custom_stats and part_data.custom_stats.ammo_pickup_max_mul or 1)
					local average_pickup = (min_pickup + max_pickup) * 0.5
					mod.pickup = average_pickup - base_stats.pickup.value
				elseif stat.name == "swap_speed" then
					local multiplier = get_swap_mul(weapon_tweak)
					multiplier = multiplier * tweak_stats.mobility[base_stats.concealment.index + mod.concealment]
					local modded_swap_speed = (weapon_tweak.timers.equip + weapon_tweak.timers.unequip) / multiplier
					mod.swap_speed = modded_swap_speed - base_stats.swap_speed.value
				end
			end
		end

		--Apply present multipliers.
		for _, stat in pairs(WeaponDescription._stats_shown) do
			if part_data and part_data.stats then
				mod[stat.name] = mod[stat.name] * (stat.present_multiplier or 1)

				if stat.round then
					mod[stat.name] = math.round(mod[stat.name])
				end
			end
		end
	end

	return mod_stats
end

function WeaponDescription._get_skill_stats(name, category, slot, base_stats, mods_stats, silencer, single_mod, auto_mod, blueprint)
	local skill_stats = {}
	local tweak_stats = tweak_data.weapon.stats
	for _, stat in pairs(WeaponDescription._stats_shown) do
		skill_stats[stat.name] = {}
		skill_stats[stat.name].value = 0
		skill_stats[stat.name].skill_in_effect = false
	end

	--[[
	if true then
		return skill_stats
	end
	]]

	--TODO: Adjust to reflect "mobility" and exclude armor in stat calcs.
	local detection_risk = 0
	if category then
		local custom_data = {}
		custom_data[category] = managers.blackmarket:get_crafted_category_slot(category, slot)
		detection_risk = managers.blackmarket:get_suspicion_offset_from_custom_data(custom_data, tweak_data.player.SUSPICION_OFFSET_LERP or 0.75)
		detection_risk = detection_risk * 100
	end

	local base_value, base_index, modifier, multiplier
	local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(name)
	local weapon_tweak = tweak_data.weapon[name]
	local primary_category = weapon_tweak.categories[1]

	--Get main stats.
	for _, stat in ipairs(WeaponDescription._stats_shown) do
		if weapon_tweak.stats[stat.stat_name or stat.name] or stat.name == "totalammo" or stat.name == "fire_rate" then
			if stat.name == "magazine" then
				skill_stats.magazine.value = (managers.player:upgrade_value(name, "clip_ammo_increase", 1) - 1) * (weapon_tweak.CLIP_AMMO_MAX + (mods_stats.magazine.value or 0))
				if not weapon_tweak.upgrade_blocks or not weapon_tweak.upgrade_blocks.weapon or not table.contains(weapon_tweak.upgrade_blocks.weapon, "clip_ammo_increase") then
					skill_stats.magazine.value = skill_stats.magazine.value + (managers.player:upgrade_value("weapon", "clip_ammo_increase", 1) - 1) * (weapon_tweak.CLIP_AMMO_MAX + (mods_stats.magazine.value or 0))
				end
			   
				if not weapon_tweak.upgrade_blocks or not weapon_tweak.upgrade_blocks[weapon_tweak.category] or not table.contains(weapon_tweak.upgrade_blocks[weapon_tweak.category], "clip_ammo_increase") then
					skill_stats.magazine.value = skill_stats.magazine.value + (managers.player:upgrade_value(weapon_tweak.category, "clip_ammo_increase", 1) - 1) * (weapon_tweak.CLIP_AMMO_MAX + (mods_stats.magazine.value or 0))
				end
				skill_stats[stat.name].skill_in_effect = managers.player:has_category_upgrade(name, "clip_ammo_increase") or managers.player:has_category_upgrade("weapon", "clip_ammo_increase")
			elseif stat.name == "totalammo" then
			elseif stat.name == "reload" then
				local skill_in_effect = false
				local mult = 1
				for _, category in ipairs(weapon_tweak.categories) do
					if managers.player:has_category_upgrade(category, "reload_speed_multiplier") then
						mult = mult + (1 - managers.player:upgrade_value(category, "reload_speed_multiplier", 1))
						skill_in_effect = true
					end
				end
				mult = 1 / managers.blackmarket:_convert_add_to_mul(mult)
				local diff = base_stats.reload.value * mult - base_stats.reload.value
				skill_stats.reload.value = skill_stats.reload.value + diff
				skill_stats.reload.skill_in_effect = skill_in_effect
			elseif not stat.derived then
				base_value = math.max(base_stats[stat.name].value + mods_stats[stat.name].value, 0)
				if base_stats[stat.name].index and mods_stats[stat.name].index then
					base_index = base_stats[stat.name].index + mods_stats[stat.name].index
				end
				multiplier = 1
				modifier = 0
				local is_single_shot = managers.weapon_factory:has_perk("fire_mode_single", factory_id, blueprint)
				if stat.name == "damage" then
					multiplier = managers.blackmarket:damage_multiplier(name, weapon_tweak.categories, silencer, detection_risk, nil, blueprint)
				elseif stat.name == "spread" then
					--No passive accuracy buffing skills exist.
				elseif stat.name == "recoil" then
					modifier = managers.blackmarket:recoil_addend(name, weapon_tweak.categories, base_index, silencer, blueprint, nil, is_single_shot) / tweak_data.weapon.stat_info.recoil_per_stability
				elseif stat.name == "concealment" then
					if silencer then
						modifier = managers.player:upgrade_value("player", "silencer_concealment_increase", 0)
					end
				elseif stat.name == "fire_rate" then
					multiplier = managers.blackmarket:fire_rate_multiplier(name, weapon_tweak.categories, silencer, detection_risk, nil, blueprint)
				end
				
				skill_stats[stat.name].skill_in_effect = multiplier ~= 1 or modifier ~= 0
				skill_stats[stat.name].value = modifier + base_value * multiplier - base_value
			end
		end
	end

	--Get derived stats.
	local ammo_data = managers.weapon_factory:get_ammo_data_from_weapon(factory_id, blueprint) or {}

	for _, stat in ipairs(WeaponDescription._stats_shown) do
		local skill_value = 0
		
		if stat.name == "swap_speed" then
			local base_multiplier, skill_multiplier = get_swap_mul(weapon_tweak)
			if silencer then
				skill_multiplier = skill_multiplier + managers.player:upgrade_value("player", "silencer_swap_increase", 1) - 1
			end

			local multiplier = base_multiplier * skill_multiplier * tweak_data.weapon.stats.mobility[math.max(base_stats.concealment.value + mods_stats.concealment.value + skill_stats.concealment.value, 0)]
			skill_value = ((tweak_data.weapon[name].timers.equip + tweak_data.weapon[name].timers.unequip) / multiplier) - base_stats.swap_speed.value - mods_stats.swap_speed.value
		elseif stat.name == "range" then
			local category_mul = get_range_mul(weapon_tweak)
			if category_mul then
				local falloff_info = tweak_data.weapon.stat_info.damage_falloff
				local base_falloff = falloff_info.base
				local acc_bonus = falloff_info.acc_bonus * math.max(base_stats.spread.value + mods_stats.spread.value + skill_stats.spread.value, 0)
				local range = (base_falloff + acc_bonus) * category_mul

				if weapon_tweak.rays and weapon_tweak.rays > 1 and not (ammo_data.rays and ammo_data.rays == 1) then
					range = range * falloff_info.shotgun_penalty
				end

				if ammo_data.damage_near_mul then
					range = range * ammo_data.damage_near_mul
				end

				skill_value = range - base_stats.range.value - mods_stats.range.value
			end
		elseif stat.name == "pickup" then
			local pickup_multiplier = managers.player:upgrade_value("player", "fully_loaded_pick_up_multiplier", 1)

			local weapon_tweak = tweak_data.weapon[name]
			for _, category in ipairs(weapon_tweak.categories) do
				pickup_multiplier = pickup_multiplier + managers.player:upgrade_value(category, "pick_up_multiplier", 1) - 1
			end

			if pickup_multiplier ~= 1 then
				local min_pickup = weapon_tweak.AMMO_PICKUP[1] * (ammo_data.ammo_pickup_min_mul or 1) * pickup_multiplier
				local max_pickup = weapon_tweak.AMMO_PICKUP[2] * (ammo_data.ammo_pickup_max_mul or 1) * pickup_multiplier
				local average_pickup = (min_pickup + max_pickup) * 0.5
				skill_value = average_pickup - mods_stats.pickup.value - base_stats.pickup.value
			end
		end

		if skill_value ~= 0 then
			skill_stats[stat.name].skill_in_effect = true
			skill_stats[stat.name].value = skill_value
		end
	end


	return skill_stats
end

function WeaponDescription._apply_present_tweaks(stat_table, decrement_index)
	for _, stat in pairs(WeaponDescription._stats_shown) do
		stat_table[stat.name].value = (stat_table[stat.name].value - (decrement_index and stat.use_index and 1 or 0)) * (stat.present_multiplier or 1)

		if stat.round then
			stat_table[stat.name].value = math.round(stat_table[stat.name].value)
		end
	end
end

function WeaponDescription._get_stats(name, category, slot, blueprint)
	local equipped_mods = nil
	local silencer = false
	local single_mod = false
	local auto_mod = false
	local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(name)
	local blueprint = blueprint or slot and managers.blackmarket:get_weapon_blueprint(category, slot) or managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)
	local cosmetics = managers.blackmarket:get_weapon_cosmetics(category, slot)
	local bonus_stats = {}

	if cosmetics and cosmetics.id and cosmetics.bonus and not managers.job:is_current_job_competitive() and not managers.weapon_factory:has_perk("bonus", factory_id, blueprint) then
		bonus_stats = tweak_data:get_raw_value("economy", "bonuses", tweak_data.blackmarket.weapon_skins[cosmetics.id].bonus, "stats") or {}
	end

	if blueprint then
		equipped_mods = deep_clone(blueprint)
		local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(name)
		local default_blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)

		if equipped_mods then
			silencer = managers.weapon_factory:has_perk("silencer", factory_id, equipped_mods)
			single_mod = managers.weapon_factory:has_perk("fire_mode_single", factory_id, equipped_mods)
			auto_mod = managers.weapon_factory:has_perk("fire_mode_auto", factory_id, equipped_mods)
		end
	end

	local base_stats = WeaponDescription._get_base_stats(name)
	local mods_stats = WeaponDescription._get_mods_stats(name, base_stats, equipped_mods, bonus_stats, blueprint)
	local skill_stats = WeaponDescription._get_skill_stats(name, category, slot, base_stats, mods_stats, silencer, single_mod, auto_mod, blueprint)

	local clip_ammo, max_ammo, ammo_data = WeaponDescription.get_weapon_ammo_info(name, tweak_data.weapon[name].stats.extra_ammo, base_stats.totalammo.index + mods_stats.totalammo.index)
	base_stats.totalammo.value = ammo_data.base
	mods_stats.totalammo.value = ammo_data.mod
	skill_stats.totalammo.value = ammo_data.skill
	skill_stats.totalammo.skill_in_effect = ammo_data.skill_in_effect

	local my_clip = base_stats.magazine.value + mods_stats.magazine.value + skill_stats.magazine.value
	if max_ammo < my_clip then
		mods_stats.magazine.value = mods_stats.magazine.value + max_ammo - my_clip
	end

	WeaponDescription._apply_present_tweaks(base_stats, true)
	WeaponDescription._apply_present_tweaks(mods_stats)
	WeaponDescription._apply_present_tweaks(skill_stats)

	return base_stats, mods_stats, skill_stats
end

function WeaponDescription.get_stats_for_mod(mod_name, weapon_name, category, slot)
	local equipped_mods = nil
	local blueprint = managers.blackmarket:get_weapon_blueprint(category, slot)
	local bonus_stats = {}

	if cosmetics and cosmetics.id and cosmetics.bonus and not managers.job:is_current_job_competitive() and not managers.weapon_factory:has_perk("bonus", factory_id, blueprint) then
		bonus_stats = tweak_data:get_raw_value("economy", "bonuses", tweak_data.blackmarket.weapon_skins[cosmetics.id].bonus, "stats") or {}
	end

	if blueprint then
		equipped_mods = deep_clone(blueprint)
		local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(weapon_name)
		local default_blueprint = managers.weapon_factory:get_default_blueprint_by_factory_id(factory_id)

		for _, default_part in ipairs(default_blueprint) do
			table.delete(equipped_mods, default_part)
		end
	end

	local base_stats = WeaponDescription._get_base_stats(weapon_name)
	local mods_stats = WeaponDescription._get_mods_stats(weapon_name, base_stats, equipped_mods, bonus_stats, blueprint)

	--[[
	WeaponDescription._apply_present_tweaks(base_stats, true)
	WeaponDescription._apply_present_tweaks(mods_stats)
	]]

	return WeaponDescription._get_weapon_mod_stats(mod_name, weapon_name, base_stats, mods_stats, equipped_mods)
end