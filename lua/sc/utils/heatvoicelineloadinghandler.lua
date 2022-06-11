--Loads any custom voicelines that have a chance of being used.
--Only loads bravo lines if pro job is enabled.
--Only loads a captain's lines if the current map spawns that captain.
local projob_only_voicelines = {
	bravo = true,
	bravo_elite = true,
	bravo_mex = true,
	bravo_murky = true
}
Hooks:PostHook(Setup, "load_packages", "HeatVoicelineLoad", function (self)
	local job = Global.level_data and Global.level_data.level_id
	if job then
		local map_captain = heat.captain_spawns[job]
		local load_list = {}
		for unit, data in pairs(tweak_data.character) do
			if type(data) == "table" and data.custom_voicework then
				if data.captain_type then
					if data.captain_type == map_captain then
						load_list[#load_list + 1] = data.custom_voicework					
					end
				elseif not projob_only_voicelines[data.custom_voicework] then
					load_list[#load_list + 1] = data.custom_voicework
				elseif Global.game_settings and Global.game_settings.one_down then
					load_list[#load_list + 1] = data.custom_voicework
				end
			end
		end

		heat.Voicelines:load(load_list)
	end
end)

--Trigger an unload for all loaded voicelines.
--Maximizing cross mod compatitibility is pretty important here, so use a posthook.
Hooks:PostHook(Setup, "unload_packages", "HeatVoicelineUnload", function(self)
	heat.Voicelines:unload()
end)