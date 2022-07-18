local orig_init_finalize = SkirmishManager.init_finalize
function SkirmishManager:init_finalize()
	orig_init_finalize(self)
	if self:is_skirmish() then
		self._required_kills = 0 --Prevents potential nil crash.
		
		local load_list = {}
		for unit, data in pairs(tweak_data.character) do
			if type(data) == "table" and data.custom_voicework then
				if heat.projob_only_voicelines[data.custom_voicework] then
					load_list[#load_list + 1] = data.custom_voicework
				end
			end
		end

		heat.Voicelines:load(load_list)
	end
end

--Refresh kill count required to end new assault.
local orig_on_start_assault = SkirmishManager.on_start_assault
function SkirmishManager:on_start_assault()
	orig_on_start_assault(self)
	local groupai = managers.groupai:state()
	self._captain_active = nil
	self._required_kills = groupai:_get_balancing_multiplier(tweak_data.skirmish.required_kills_balance_mul) * managers.groupai:state():_get_difficulty_dependent_value(tweak_data.skirmish.required_kills)

	local spawn_group_index = self:current_wave_number()
	groupai._tweak_data.assault.groups = tweak_data.skirmish.spawn_group_waves[math.min(spawn_group_index, #tweak_data.skirmish.spawn_group_waves)]
end

--Update kill counter, end assault if kills required reached.
function SkirmishManager:do_kill()
	local groupai = managers.groupai:state()
	if not self._captain_active and groupai:chk_assault_active_atm() then
		self._required_kills = self._required_kills - 1
		if self._required_kills <= 0 then
			if self:current_wave_number() == 9 then
				groupai:force_spawn_group_hard(tweak_data.skirmish.captain.spawn_group)
				self._captain_active = true
			else
				groupai:force_end_assault_phase(true)
				groupai:free_tank_tokens() --Free all tank tokens.
			end
		end
	end
end

--Prevents a nil return that's really dumb and causes crashes.
function SkirmishManager:current_wave_number()
	if Network:is_server() then
		return managers.groupai and managers.groupai:state():get_assault_number() or 0
	else
		return self._synced_wave_number or 0
	end
end