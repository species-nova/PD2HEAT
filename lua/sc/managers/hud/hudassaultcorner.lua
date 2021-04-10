Hooks:PostHook(HUDAssaultCorner, "init", "SCHUDAssaultInit", function(self)
	self._captain = nil
	local buff_icon = "guis/textures/pd2/hud_buff_shield"
	local job = Global.level_data and Global.level_data.level_id        
	for _,j in ipairs(restoration.captain_teamwork) do
		if job == j then
			self._captain = "summers"
			buff_icon = "guis/textures/pd2/hud_buff_fire"
			break
		end
	end
	for _,j2 in ipairs(restoration.captain_murderdozer) do
		 if job == j2 then
			self._captain = "spring"
			buff_icon = "guis/textures/pd2/hud_buff_skull"
			break
		end
	end
	for _,j3 in ipairs(restoration.captain_stelf) do
		 if job == j3 then
			self._captain = "autumn"
			buff_icon = "guis/textures/pd2/hud_buff_spooc"
			break
		end
	end		
	for _,j4 in ipairs(restoration.what_a_horrible_heist_to_have_a_curse) do
		if job == j4 then
			self._captain = "hellfire"
			buff_icon = "guis/textures/pd2/hud_buff_halloween"
			break
		end
	end	
	
	--job specific overrides here in case the map spawns a captain
	--white house, spring
	if job == "vit" then
		buff_icon = "guis/textures/pd2/hud_buff_skull"
	end
	
	--Skirmish exclusive stuff
	if managers.skirmish:is_skirmish() then		
		buff_icon = "guis/textures/pd2/hud_buff_generic"
	end

	if buff_icon == "guis/textures/pd2/hud_buff_shield" then
		self._captain = "winters"
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
		local captain_warn = "hud_assault_vip"
		local vs_line = "hud_assault_vip_winters"
		local padlock = "hud_assault_padlock"
		
		if self._captain == "autumn" then
			vs_line = "hud_assault_vip_autumn"
		elseif self._captain == "spring" then
			vs_line = "hud_assault_vip_spring"
		elseif self._captain == "summers" then
			vs_line = "hud_assault_vip_summers"
		elseif self._captain == "hellfire" then
			vs_line = "hud_assault_vip_hvh"
			captain_warn = "hud_assault_vip_hvhwarn"
		end
		
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
		local color = is_inside and self._assault_survived_color or self._noreturn_color
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

function HUDAssaultCorner:flash_point_of_no_return_timer(beep)
	local font_size = tweak_data.hud_corner.noreturn_size

	local function flash_timer(o)
		local t = 0

		while t < 0.5 do
			t = t + coroutine.yield()
			local n = 1 - math_sin(t * 180)
			local color = self._is_inside_ponr and self._assault_survived_color or self._noreturn_color
			local r = math_lerp(color.r, 1, n)
			local g = math_lerp(color.g, 0.8, n)
			local b = math_lerp(color.b, 0.2, n)

			o:set_color(Color(r, g, b))
			o:set_font_size(math_lerp(font_size, font_size * 1.25, n))
		end
	end

	local point_of_no_return_timer = self._noreturn_bg_box:child("point_of_no_return_timer")

	point_of_no_return_timer:animate(flash_timer)
end
