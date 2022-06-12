Hooks:PostHook(HUDAssaultCorner, "init", "SCHUDAssaultInit", function(self)
	local buff_icon = "guis/textures/pd2/hud_buff_generic"
	local job = Global.level_data and Global.level_data.level_id

	self._captain = heat.captain_spawns[job]
	if self._captain and self._captain.icon then
		buff_icon = self._captain.icon
	end

	if managers.skirmish:is_skirmish() then		
		buff_icon = "guis/textures/pd2/hud_buff_generic"
	end

	if alive(self._vip_bg_box) and alive(self._vip_bg_box:child("vip_icon")) then
		self._vip_bg_box:child("vip_icon"):set_image(buff_icon)
	end
end)

local us_cover = {
	hud_assault_cover_usds = true,
	hud_assault_cover_us = true
}

local ds_lines = { --easter egg lines that have death sentence variants
	hud_assault_cover_bs2 = true,
	hud_assault_cover_bs4 = true,
	hud_assault_cover_bs5 = true,
	hud_assault_cover_bs6 = true
}

function HUDAssaultCorner:_get_assault_strings()
	local difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
	local diff_index = tweak_data:difficulty_to_index(difficulty)
	local us = tweak_data.levels.ai_groups.america
	local r = tweak_data.levels.ai_groups.russia 
	local m = tweak_data.levels.ai_groups.murkywater
	local z = tweak_data.levels.ai_groups.zombie
	local f = tweak_data.levels.ai_groups.federales
	local ai_type = tweak_data.levels:get_ai_group_type()
	
	if self._assault_mode == "normal" then
		local assault_line = "hud_assault_assault"
		local cover_line = "hud_assault_cover_us"
		
		if ai_type == m then
			assault_line =  diff_index < 8 and "hud_assault_assault_murk" or "hud_assault_assault_omni"
			cover_line = diff_index == 8 and "hud_assault_cover_usds" or cover_line
		elseif ai_type == z then
			assault_line = diff_index < 8 and "hud_assault_assault_zm" or "hud_assault_assault_zmds"
			cover_line = diff_index < 8 and "hud_assault_cover_zm" or "hud_assault_cover_zmds"
		elseif ai_type == r then
			assault_line = diff_index < 8 and "hud_assault_assault_ru" or "hud_assault_assault_ruds"
			cover_line = diff_index < 8 and "hud_assault_cover_ru" or "hud_assault_cover_ruds"
		elseif ai_type == f then
			assault_line = diff_index < 8 and "hud_assault_assault_mex" or "hud_assault_assault_mexds"
			cover_line = diff_index < 8 and "hud_assault_cover_mex" or "hud_assault_cover_mexds"
		else
			if diff_index == 8 then
				assault_line = "hud_assault_assault_ds"
				cover_line = "hud_assault_cover_usds"
			end
		end
		
		if us_cover[cover_line] then
			if math.random() < 0.02 then
				local easter_egg_int = math.random(1, 10)
				cover_line = "hud_assault_cover_bs" .. easter_egg_int
				
				if ds_lines[cover_line] then
					cover_line = cover_line .. "ds"
				end
			end
		end
	
		if managers.job:current_difficulty_stars() > 0 then
			local ids_risk = Idstring("risk")

			return {
				assault_line,
				"hud_assault_end_line",
				ids_risk,
				"hud_assault_end_line",
				cover_line,
				"hud_assault_end_line",
				ids_risk,
				"hud_assault_end_line",
				assault_line,
				"hud_assault_end_line",
				ids_risk,
				"hud_assault_end_line",
				cover_line,
				"hud_assault_end_line",
				ids_risk,
				"hud_assault_end_line",
			}
		else
			return {
				assault_line,
				"hud_assault_end_line",
				cover_line,
				"hud_assault_end_line",
				assault_line,
				"hud_assault_end_line",
				cover_line,
				"hud_assault_end_line",
			}
		end
	end

	if self._assault_mode == "phalanx" then
		local vs_line =	self._captain.vs_line or "hud_assault_vip_winters"
		local captain_warn = self._captain.captain_warn or "hud_assault_vip"
		local padlock = "hud_assault_padlock"
		
		if managers.job:current_difficulty_stars() > 0 then
			local ids_risk = Idstring("risk")

			return {
				captain_warn,
				padlock,
				vs_line,
				padlock,
				ids_risk,
				padlock,
				captain_warn,
				padlock,
				vs_line,
				padlock,
				ids_risk,
				padlock
			}
		else
			return {
				captain_warn,
				padlock,
				vs_line,
				padlock,
				captain_warn,
				padlock,
				vs_line,
				padlock
			}
		end
	end
end

local math_sin = math.sin
local math_lerp = math.lerp

local feed_point_of_no_return_timer_original = HUDAssaultCorner.feed_point_of_no_return_timer
function HUDAssaultCorner:feed_point_of_no_return_timer(time, is_inside)
	feed_point_of_no_return_timer_original(self, time, is_inside)

	if self._is_inside_ponr ~= is_inside then
		local color = is_inside and self._assault_survived_color

		if not color then
			local noreturn_data = self._noreturn_data
			color = noreturn_data and noreturn_data.color or Color(1, 1, 0, 0)
		end

		local ponr_timer = self._noreturn_bg_box:child("point_of_no_return_timer")

		if ponr_timer.set_color then
			ponr_timer:set_color(color)
		end

		local ponr_text = self._noreturn_bg_box:child("point_of_no_return_text")

		if ponr_text.set_color then
			ponr_text:set_color(color)
		end
	end

	self._is_inside_ponr = is_inside
end