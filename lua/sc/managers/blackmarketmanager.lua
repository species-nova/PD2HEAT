function BlackMarketManager:equipped_armor(chk_armor_kit, chk_player_state)
	if chk_player_state and managers.player:current_state() == "civilian" then
		return self._defaults.armor
	end
	local armor
	for armor_id, data in pairs(tweak_data.blackmarket.armors) do
		armor = Global.blackmarket_manager.armors[armor_id]
		if armor.equipped and armor.unlocked and armor.owned then
			local forced_armor = self:forced_armor()
			if forced_armor then
				return forced_armor
			end
			return armor_id
		end
	end
	return self._defaults.armor
end

--fire rate multiplier blackmarket statchart stuff	
function BlackMarketManager:fire_rate_multiplier(name, categories, silencer, detection_risk, current_state, blueprint)
	local factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(name)
	local tweak_data = tweak_data.weapon
	local weapon = tweak_data[name]
	local factory = tweak_data.factory[factory_id]
	local default_blueprint = factory.default_blueprint			
	local custom_stats = managers.weapon_factory:get_custom_stats_from_weapon(factory_id, blueprint or default_blueprint)
	local multiplier = 1
	local rof_multiplier = 1
	self._block_eq_aced = nil

	for part_id, stats in pairs(custom_stats) do
		if stats.rof_mult then
			rof_multiplier = rof_multiplier * stats.rof_mult
		end
	end
	multiplier = rof_multiplier

	multiplier = multiplier + (1 - managers.player:upgrade_value(name, "fire_rate_multiplier", 1))
	multiplier = multiplier + (1 - managers.player:upgrade_value("weapon", "fire_rate_multiplier", 1))
	for _, category in ipairs(categories) do
		multiplier = multiplier * managers.player:upgrade_value(category, "fire_rate_multiplier", 1)
	end
								
	return multiplier
end

function BlackMarketManager:damage_multiplier(name, categories, silencer, detection_risk, current_state, blueprint)
	local multiplier = managers.player:upgrade_value("weapon", "passive_damage_multiplier", 1)
	if categories[1] then
		if categories[1] == "saw" then
			multiplier = multiplier * managers.player:upgrade_value("player", "melee_damage_health_ratio_multiplier", 1)
		elseif categories[1] ~= "grenade_launcher" and categories[1] ~= "bow" and categories[1] ~= "crossbow" then
			multiplier = multiplier * managers.player:upgrade_value("player", "damage_health_ratio_multiplier", 1)
		end
	end

	return multiplier
end

function BlackMarketManager:_calculate_weapon_concealment(weapon)
	local factory_id = weapon.factory_id
	local weapon_id = weapon.weapon_id or managers.weapon_factory:get_weapon_id_by_factory_id(factory_id)
	local blueprint = weapon.blueprint
	local base_stats = tweak_data.weapon[weapon_id].stats
	local modifiers_stats = tweak_data.weapon[weapon_id].stats_modifiers
	local bonus = 0

	if not base_stats or not base_stats.concealment then
		return 0
	end

	local bonus_stats = {}

	if weapon.cosmetics and weapon.cosmetics.id and weapon.cosmetics.bonus and not managers.job:is_current_job_competitive() and not managers.weapon_factory:has_perk("bonus", factory_id, blueprint) then
		bonus_stats = tweak_data:get_raw_value("economy", "bonuses", tweak_data.blackmarket.weapon_skins[weapon.cosmetics.id].bonus, "stats") or {}
	end

	local parts_stats = managers.weapon_factory:get_stats(factory_id, blueprint)

	return math.min((base_stats.concealment + bonus + (parts_stats.concealment or 0) + (bonus_stats.concealment or 0)) * (modifiers_stats and modifiers_stats.concealment or 1), #tweak_data.weapon.stats.concealment)
end

Hooks:RegisterHook("BlackMarketManagerModifyGetInventoryCategory")
function BlackMarketManager.get_inventory_category(self, category)

	local t = {}

	for global_value, categories in pairs(self._global.inventory) do
		if categories[category] then

			for id, amount in pairs(categories[category]) do
				table.insert(t, {
					id = id,
					global_value = global_value,
					amount = amount
				})
			end

		end
	end

	Hooks:Call("BlackMarketManagerModifyGetInventoryCategory", self, category, t)

	return t

end

--Returns bonus to the stability stat from skills.
function BlackMarketManager:stability_index_addend(categories, silencer)
	local pm = managers.player

	--Weapon category specific buffs.
	local index = pm:upgrade_value("weapon", "recoil_index_addend", 0)

	for _, category in ipairs(categories) do
		index = index + pm:upgrade_value(category, "recoil_index_addend", 0)
	end

	--Teamwide buffs.
	if managers.player:has_team_category_upgrade("weapon", "recoil_index_addend") then
		index = index + pm:team_upgrade_value("weapon", "recoil_index_addend", 0)
	end

	for _, category in ipairs(categories) do
		if managers.player:has_team_category_upgrade(category, "recoil_index_addend") then
			index = index + pm:team_upgrade_value(category, "recoil_index_addend", 0)
		end
	end

	--Silencer stability boost.
	if self._silencer then
		index = index + pm:upgrade_value("weapon", "silencer_recoil_index_addend", 0)
	end

	return index
end

function BlackMarketManager:accuracy_index_addend(name, categories, silencer, current_state, fire_mode, blueprint)
	local pm = managers.player
	local index = 0

	for _, category in ipairs(categories) do
		index = index + pm:upgrade_value(category, "spread_index_addend", 0)
	end
	
	index = index + pm:temporary_upgrade_value("temporary", "headshot_accuracy_addend", 0)

	return index
end

--Clamp melee mobility stat to be between 0-100
function BlackMarketManager:visibility_modifiers()
	local skill_bonuses = 0
	skill_bonuses = skill_bonuses - managers.player:upgrade_value("player", "passive_concealment_modifier", 0)
	skill_bonuses = skill_bonuses - managers.player:upgrade_value("player", "concealment_modifier", 0)
	
	local equipped_melee_weapon = self:equipped_melee_weapon()
	local melee_concealment = managers.blackmarket:_calculate_melee_weapon_concealment(equipped_melee_weapon)
	local melee_skill_bonus = math.max(math.min(melee_concealment + managers.player:upgrade_value("player", "melee_concealment_modifier", 0), 21) - melee_concealment, 0)
	skill_bonuses = skill_bonuses - melee_skill_bonus

	local armor_data = tweak_data.blackmarket.armors[managers.blackmarket:equipped_armor(true, true)]
	if armor_data.upgrade_level == 2 or armor_data.upgrade_level == 3 or armor_data.upgrade_level == 4 then
		skill_bonuses = skill_bonuses - managers.player:upgrade_value("player", "ballistic_vest_concealment", 0)
	end

	return skill_bonuses
end

--Clamp melee mobility stat to be between 0-100
function BlackMarketManager:concealment_modifier(type, upgrade_level, melee_override)
	local modifier = 0

	if type == "armors" then
		modifier = modifier + managers.player:upgrade_value("player", "passive_concealment_modifier", 0)
		modifier = modifier + managers.player:upgrade_value("player", "concealment_modifier", 0)

		if upgrade_level == 2 or upgrade_level == 3 or upgrade_level == 4 then
			modifier = modifier + managers.player:upgrade_value("player", "ballistic_vest_concealment", 0)
		end
	elseif type == "melee_weapons" then
		local equipped_melee_weapon = melee_override or self:equipped_melee_weapon()
		local melee_concealment = managers.blackmarket:_calculate_melee_weapon_concealment(equipped_melee_weapon)
		local melee_skill_bonus = math.max(math.min(melee_concealment + managers.player:upgrade_value("player", "melee_concealment_modifier", 0), 21) - melee_concealment, 0)
		modifier = modifier + melee_skill_bonus
	end

	return modifier
end

--Let bots use pistols.
local ALLOWED_CREW_WEAPON_CATEGORIES = {
    assault_rifle = true,
    shotgun = true,
    snp = true,
    akimbo = false,
    lmg = true,
    smg = true,
    pistol = true,
    minigun = false,
    grenade_launcher = false,
    flamethrower = false,
    bow = false,
    crossbow = false
}

function BlackMarketManager:is_weapon_category_allowed_for_crew(weapon_category)
	return ALLOWED_CREW_WEAPON_CATEGORIES[weapon_category]
end