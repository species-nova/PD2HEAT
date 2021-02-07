SkillTreeManager.VERSION = 69

--In case we want to retry skill pools for some reason.
--[[
local function get_skill_costs()
	local t = {
		{
			1,
			3
		},
		{
			2,
			4
		},
		{
			3,
			6
		},
		{
			4,
			6
		}
	}

	return t
end

function SkillTreeManager:get_skill_points_number(skill, index, tier)
	local tier = tweak_data.skilltree:get_tier_position_from_skill_name(skill)
	local cost = tweak_data.skilltree.tier_cost[tier][index]	
	
	if tweak_data.skilltree.skills[skill] then
		--log("step1")
		if tweak_data.skilltree.skills[skill][index] then
			--log("step2")
			if tweak_data.skilltree.skills[skill][index].skill_cost then
				--log("wee")
				cost = tweak_data.skilltree.skills[skill][index].skill_cost
			end
		end
	end

	return cost
end

function SkillTreeManager:get_skill_points(skill, index, tier)
	local tier = tweak_data.skilltree:get_tier_position_from_skill_name(skill)
	local cost = tweak_data.skilltree.tier_cost[tier][index]	
	
	if tweak_data.skilltree.skills[skill] then
		--log("step1")
		if tweak_data.skilltree.skills[skill][index] then
			--log("step2")
			if tweak_data.skilltree.skills[skill][index].skill_cost then
				--log("wee")
				cost = tweak_data.skilltree.skills[skill][index].skill_cost
			end
		end
	end
	
	
	local points = cost
	local total_points = cost

	return total_points, points
end

function SkillTreeManager:skill_cost(tier, skill_level, skill_cost)
	local t = skill_cost or 1
	
	if type(skill_cost) == "table" then
		--log("augh")
		return skill_cost[1]
	end
	
	return t
end

function SkillTreeManager:_points_spent_skill(tier, skill_id)
	local points = 0
	local skill_level = self._global.skills[skill_id].unlocked
	local skill_costs = self:get_skill_points(skill_id, skill_level, tier)
	
	if skill_level and skill_level >= 1 then
		for j = skill_level, 1, -1 do
			points = points + self:get_skill_points(skill_id, j, tier)
		end
	end

	return points
end

function SkillTreeManager:get_points_spent_in_tier(tier, tier_idx)
	local skills = self._global.skills
	local skill_costs = get_skill_costs()
	local points = 0

	return points
end

function SkillTreeManager:get_points_spent_until_tier(tiers, target_tier_idx)
	local skills = self._global.skills
	local skill_costs = get_skill_costs()
	local points = 0

	return points
end

function SkillTreeManager:skill_can_be_removed(tree, tier, skill_id)
	local skill_step = self:skill_step(skill_id)

	if skill_step == 0 then
		return false
	end

	local tiers = tweak_data.skilltree:get_tiers(tree)
	local points_to_remove = self:skill_cost(tier, skill_step)
	local points_left, points_spent_until_tier, tier_index, tier_data = nil

	if not points_to_remove then
		return false
	end

	if points_to_remove == 0 then
		return true
	end

	return true
end
]]