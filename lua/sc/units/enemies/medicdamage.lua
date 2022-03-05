local no_heal_anim = {
	taser_summers = true,
	boom_summers = true,
	medic_summers = true,
	tank_medic = true
}

--Refactored medic heal_unit stuff.
--Note: Medics in heat have no cooldown. Existing cooldown code is repurposed to throttle voiceline spam.
function MedicDamage:heal_unit(unit, override_cooldown)
	if self._unit:anim_data() and self._unit:anim_data().act then
		return false
	end

	local my_tweak_data = self._unit:base()._tweak_table
	local target_tweak_table = unit:base()._tweak_table

	if my_tweak_data == "medic" or my_tweak_data == "tank_medic" then
		if table.contains(tweak_data.medic.disabled_units, target_tweak_table) then
			return false
		end
	elseif my_tweak_data == "medic_summers" then
		if not table.contains(tweak_data.medic.whitelisted_units, target_tweak_table) then
			return false
		end
	else
		if not table.contains(tweak_data.medic.whitelisted_units_summer_squad, target_tweak_table) then
			return false
		end
	end

	local team = unit:movement().team and unit:movement():team()

	if team and team.id ~= "law1" then
		if not team.friends or not team.friends.law1 then
			return false
		end
	end

	if unit:brain() then
		if unit:brain().converted then
			if unit:brain():converted() then
				return false
			end
		elseif unit:brain()._logic_data and unit:brain()._logic_data.is_converted then
			return false
		end
	end

	local target_char_tweak = tweak_data.character[target_tweak_table]

	if not self._unit:character_damage():dead() then
		if self._unit:contour() then
			self._unit:contour():add("medic_show", false)
			self._unit:contour():flash("medic_show", 0.2)
		end

		--Use cooldown to throttle voiceline spam and animation jank.
		local t = Application:time()
		if t > (self._heal_cooldown_t or 0) + tweak_data.medic.cooldown then
			self._heal_cooldown_t = t
			if no_heal_anim[my_tweak_data] then				
				self._unit:sound():say("heal")
			else
				local action_data = {
					body_part = 1,
					type = "heal",
					client_interrupt = Network:is_client()
				}

				self._unit:movement():action_request(action_data)
			end
		end
	end

	--temporarily disabling buffs because there's no way to sync them properly when a client locally procs the heal
	--[[if Global.game_settings.difficulty == "sm_wish" then
		if my_tweak_data == "medic" or my_tweak_data == "tank_medic" then
			unit:base():add_buff("base_damage", 15 * 0.01)

			if unit:contour() then
				unit:contour():add("medic_buff", false)
			end
		end
	elseif Global.game_settings.difficulty == "overkill_290" then
		if my_tweak_data == "medic" or my_tweak_data == "tank_medic" then
			unit:base():add_buff("base_damage", 5 * 0.01)

			if unit:contour() then
				unit:contour():add("medic_buff", false)
			end
		end
	end]]

	managers.network:session():send_to_peers("sync_medic_heal", self._unit)
	MedicActionHeal:check_achievements()

	if self._unit:base():char_tweak()["custom_voicework"] then
		local voicelines = _G.voiceline_framework.BufferedSounds[self._unit:base():char_tweak().custom_voicework]
		if voicelines and voicelines["heal"] then
			local line_to_use = voicelines.heal[math.random(#voicelines.heal)]
			self._unit:base():play_voiceline(line_to_use)
		end
	end

	return true

end