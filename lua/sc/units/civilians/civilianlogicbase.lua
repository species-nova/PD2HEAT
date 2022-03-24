--Searches for nearby sentry guns, and returns the first one within range that's found.
--Used by CivilianLogicSurrender and CivilianLogicFlee to make civilians go down to the floor when sentries are near.
function CivilianLogicBase.check_sentry_suppression(data)
	local civ_pos = data.unit:movement():m_head_pos()	
	local all_deployables = World:find_units_quick("all",25)
	local dis_sentry = tweak_data.upgrades.sentry_gun_intimidate_range
	for _,unit in pairs(all_deployables) do 
		if unit and alive(unit) then
			local this_dis = mvector3.distance_sq(unit:position(), civ_pos)
			if this_dis < dis_sentry then 
				return unit
			end
		end
	end

	return nil
end