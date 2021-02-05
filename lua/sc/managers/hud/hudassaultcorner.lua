Hooks:PostHook(HUDAssaultCorner, "init", "SCHUDAssaultInit", function(self)
	local buff_icon = "guis/textures/pd2/hud_buff_shield"
	local job = Global.level_data and Global.level_data.level_id        
	for _,j in ipairs(restoration.captain_teamwork) do
		if job == j then
			buff_icon = "guis/textures/pd2/hud_buff_fire"
			break
		end
	end
	for _,j2 in ipairs(restoration.captain_murderdozer) do
		 if job == j2 then
			buff_icon = "guis/textures/pd2/hud_buff_skull"
			break
		end
	end
	for _,j3 in ipairs(restoration.captain_stelf) do
		 if job == j3 then
			buff_icon = "guis/textures/pd2/hud_buff_spooc"
			break
		end
	end		
	for _,j4 in ipairs(restoration.what_a_horrible_heist_to_have_a_curse) do
		if job == j4 then
			buff_icon = "guis/textures/pd2/hud_buff_halloween"
			break
		end
	end	
	
	--Skirmish exclusive stuff
	if managers.skirmish:is_skirmish() then		
		buff_icon = "guis/textures/pd2/hud_buff_generic"
	end	
	
	if alive(self._vip_bg_box) and alive(self._vip_bg_box:child("vip_icon")) then
		self._vip_bg_box:child("vip_icon"):set_image(buff_icon)
	end
end)

if not restoration or not restoration:all_enabled("HUD/MainHUD", "HUD/AssaultPanel") then
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
end
