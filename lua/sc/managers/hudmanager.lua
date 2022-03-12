core:import("CoreEvent")

local _setup_player_info_hud_pd2_original = HUDManager._setup_player_info_hud_pd2
function HUDManager:_setup_player_info_hud_pd2(...)
	self:_create_level_suspicion_hud(managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2))
	_setup_player_info_hud_pd2_original(self,...)
	self._dodge_meter = HUDDodgeMeter:new((managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)))
	self._skill_list = HUDSkill:new((managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)))
	self._effect_screen = HUDEffectScreen:new((managers.hud:script(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN_PD2)))
end


local NUM_SUSPICION_EFFECT_GHOSTS = 3
function HUDManager:_upd_animate_level_suspicion(t,amount,amount_max,amount_interpolated,is_whisper_mode)
	--got me thinking, do we want a noise indicator? one that plays when you perform an action that makes noise, whether by main hud item or by waypoint
	if not (amount and amount_max) then
		return
	end
	local panel = self._level_suspicion_panel
	if not panel then 
		return
	end
	if not (panel:visible() or is_whisper_mode) then 
		return
	end
	if is_whisper_mode then 
		if not panel:visible() then 
			panel:show()
		end 
		if panel:alpha() < 1 then 
			panel:set_alpha(math.min(math.abs(panel:alpha()) * 1.1,1))
		end
	else
		panel:set_alpha(panel:alpha() * 0.9)
		if panel:alpha() <= 0.01 then 
			panel:hide()
		end
	end
	
	local function interp_colors(one,two,percent) --interpolates colors based on a percentage
	--percent is [0,1]
		percent = math.clamp(percent,0,1)
		
	--color 1
		local r1 = one.red
		local g1 = one.green
		local b1 = one.blue
		
	--color 2
		local r2 = two.red
		local g2 = two.green
		local b2 = two.blue

	--delta
		local r3 = r2 - r1
		local g3 = g2 - g1
		local b3 = b2 - b1
		
		return Color(r1 + (r3 * percent),g1 + (g3 * percent), b1 + (b3 * percent))	
	end
	
	local base_icon_alpha = 0.5
	local ratio = math.min(1,amount/amount_max)
	local ratio_color = interp_colors(Color("45B5FF"),Color("FF6138"),ratio) --blue to red
	local suspicion_icon = panel:child("suspicion_icon")
	suspicion_icon:set_color(ratio == 0 and Color(0.5,0.5,0.5) or ratio_color)
	panel:child("suspicion_interp"):set_color(Color(amount_interpolated/amount_max,0,0))
	suspicion_icon:set_alpha(ratio + base_icon_alpha)
	panel:child("suspicion_circle"):set_color(Color(ratio,0,0)) --progress radial
	local alert_on = amount >= amount_max
	
	if alert_on then
		--not limited to a maximum of 1
		suspicion_icon:set_image("guis/textures/restoration/crimewar_skull_2")
		local interval = 2
		local time_scale = 1
		local icon_size = 32
		for i=1,NUM_SUSPICION_EFFECT_GHOSTS,1 do 
			local ghost = panel:child("suspicion_ghost_" .. tostring(i))
			if ghost then 
				local t_adjusted = time_scale * (t + (i / (NUM_SUSPICION_EFFECT_GHOSTS * interval)))
				local progress = 1 - (math.cos((90 * (t_adjusted % 1))))

				--raw equation: let a=2,b=0.5; y = 1/a - (cosine(modulo(x*b,1)*pi)/a)

				local new_w = icon_size * (progress + 1)
				local new_h = icon_size * (progress + 1)
				ghost:set_image("guis/textures/restoration/crimewar_skull_2")
				ghost:set_w(new_w)
				ghost:set_h(new_h)
				ghost:set_color(ratio_color)
				ghost:set_alpha(1 - progress)
				ghost:set_center(panel:center())
			end
		end
	end
	if ratio > 0 then 
		panel:child("suspicion_bg"):set_alpha(0.5)
	end
end

function HUDManager:_create_level_suspicion_hud(hud)
	local hud_panel = hud.panel
	local level_suspicion_panel = hud_panel:panel({
		name = "level_suspicion_panel",
		y = -140, --i wanted so badly for 128 to work
		alpha = Network:is_server() and 0.0001 or 1,
		visible = not Network:is_server()
	}) 
	--yeah i can't seem to change the size of this thing from its parent's without breaking its center() and its children's set_center()
	local icon_texture = "guis/textures/restoration/crimewar_skull" -- or "guis/textures/pd2/cn_minighost" or "guis/textures/pd2/hud_stealth_alarm01" or "guis/textures/pd2/hud_stealth_eye"
	local radial_texture = "guis/textures/pd2/hud_rip"
	local icon_size = 32
	local radial_size = 128
	
	self._level_suspicion_panel = level_suspicion_panel
	local suspicion_circle = level_suspicion_panel:bitmap({ --circle outline progress; set instantly
		name = "suspicion_circle",
		render_template = "VertexColorTexturedRadial",
		texture = radial_texture, -- "guis/dlcs/coco/textures/pd2/hud_absorb_shield", --for soft blue outline instead
		color = Color.black, --starts out invisible
		alpha = 0.5,
		layer = 3,
		w = radial_size,
		h = radial_size
	})
	local suspicion_interp = level_suspicion_panel:bitmap({ --circle outline progress.
		name = "suspicion_interp",
		render_template = "VertexColorTexturedRadial",
		texture = radial_texture,
		color = Color.black,
		alpha = 1,
		layer = 2,
		w = radial_size,
		h = radial_size
	})
	local suspicion_bg = level_suspicion_panel:bitmap({ --circle outline bg
		name = "suspicion_bg",
		texture = radial_texture,
		color = Color.black,
		alpha = 0.25,
		layer = 1,
		w = radial_size,
		h = radial_size
	})
	
	local suspicion_icon = level_suspicion_panel:bitmap({
		name = "suspicion_icon",
		texture = icon_texture,
		color = Color.white,
		alpha = 0, --set dynamically
		layer = 4,
		x = (level_suspicion_panel:w() - icon_size) / 2,
		y = (level_suspicion_panel:h() - icon_size) / 2,
		w = icon_size,
		h = icon_size
	})
	level_suspicion_panel:move(0,20)  --this is not the right way to do it but by god i'm doing it
	local center_x,center_y = level_suspicion_panel:center()
	suspicion_circle:set_center(center_x,center_y)
	suspicion_interp:set_center(center_x,center_y)
	suspicion_bg:set_center(center_x,center_y)
	suspicion_icon:set_center(center_x,center_y)
	for i=1,NUM_SUSPICION_EFFECT_GHOSTS,1 do 
		local suspicion_ghost = level_suspicion_panel:bitmap({
			name = "suspicion_ghost_" .. tostring(i),
			texture = icon_texture,
			color = Color.white,
			blend_mode = "add",
			alpha = 0, --set dynamically
			layer = 4 + i,
			w = icon_size,
			h = icon_size
		})
		suspicion_ghost:set_center(center_x,center_y)
	end
end

function HUDManager:set_dodge_value(value)
	--Sends current dodge meter level and players dodge stat to the dodge panel in HUDtemp.lua
	self._dodge_meter:set_dodge_value(value)
end

function HUDManager:unhide_dodge_panel(dodge_points)
	self._dodge_meter:unhide_dodge_panel(dodge_points)
end

function HUDManager:activate_effect_screen(duration, color)
	--Apply the effect screen with a color over a duration.
	self._effect_screen:do_effect_screen(duration, color)
end

--Functions to interface with the buff tracker.
function HUDManager:add_skill(name)
	if heat.Options:GetValue("INFOHUD/Info_Hud") and name and heat.Options:GetValue("INFOHUD/Info_" .. name) then
		self._skill_list:add_skill(name)
	end
end

function HUDManager:remove_skill(name)
	self._skill_list:destroy(name)
end

function HUDManager:clear_skills()
	self._skill_list:destroy(nil)
end

function HUDManager:start_cooldown(name, duration)
	if heat.Options:GetValue("INFOHUD/Info_Hud") and name and heat.Options:GetValue("INFOHUD/Info_" .. name) then
		self._skill_list:trigger_cooldown(name, duration)
	end
end

function HUDManager:change_cooldown(name, amount)
	self._skill_list:change_start_time(name, amount)
end

function HUDManager:start_buff(name, duration)
	if heat.Options:GetValue("INFOHUD/Info_Hud") and name and heat.Options:GetValue("INFOHUD/Info_" .. name) then
		self._skill_list:trigger_buff(name, duration)
	end
end

function HUDManager:set_stacks(name, stacks)
	if heat.Options:GetValue("INFOHUD/Info_Hud") and name and heat.Options:GetValue("INFOHUD/Info_" .. name) then
		self._skill_list:set_stacks(name, stacks)
	end
end

function HUDManager:add_stack(name)
	if heat.Options:GetValue("INFOHUD/Info_Hud") and name and heat.Options:GetValue("INFOHUD/Info_" .. name) then
		self._skill_list:add_stack(name)
	end
end

function HUDManager:remove_stack(name)
	self._skill_list:remove_stack(name)
end

function HUDManager:setup_anticipation(total_t)
	local exists = self._anticipation_dialogs and true or false
	self._anticipation_dialogs = {}

	if not exists and total_t == 45 then
		table.insert(self._anticipation_dialogs, {
			time = 45,
			dialog = 1
		})
		table.insert(self._anticipation_dialogs, {
			time = 30,
			dialog = 2
		})
	elseif exists and total_t == 45 then
		table.insert(self._anticipation_dialogs, {
			time = 30,
			dialog = 6
		})
	end

	if total_t == 45 then
		table.insert(self._anticipation_dialogs, {
			time = 20,
			dialog = 3
		})
		table.insert(self._anticipation_dialogs, {
			time = 10,
			dialog = 4
		})
	end

	if total_t == 35 then
		table.insert(self._anticipation_dialogs, {
			time = 20,
			dialog = 7
		})
		table.insert(self._anticipation_dialogs, {
			time = 10,
			dialog = 4
		})
	end

	if total_t == 25 then
		table.insert(self._anticipation_dialogs, {
			time = 10,
			dialog = 8
		})
	end
end

function HUDManager:check_anticipation_voice(t)
	if not self._anticipation_dialogs or self._anticipation_dialogs and not self._anticipation_dialogs[1] then
		return
	end

	if self._anticipation_dialogs and t < self._anticipation_dialogs[1].time then
		local data = table.remove(self._anticipation_dialogs, 1)

		self:sync_assault_dialog(data.dialog)
		managers.network:session():send_to_peers_synched("sync_assault_dialog", data.dialog)
	end
end