function Drill:start()
	self:_start_drill_effect()

	if not self.started then
		self.started = true
		Drill.active_drills = Drill.active_drills + 1

		if Network:is_server() then
			if not self._nav_tracker and managers.navigation:is_data_ready() then
				if self._sabotage_align_obj_name then
					self._nav_tracker = managers.navigation:create_nav_tracker(self._unit:get_object(Idstring(self._sabotage_align_obj_name)):position())
				else
					self._nav_tracker = managers.navigation:create_nav_tracker(self._pos)
				end
			end

			self:_register_sabotage_SO()
		end

		if not managers.groupai:state():enemy_weapons_hot() then
			self:_set_attention_state(true)
			self:_set_alert_state(true)

			--only allow drill warnings during stealth if the drill isn't silent
			if not self.is_hacking_device and not self.is_saw and self._alert_radius then
				managers.dialog:queue_narrator_dialog("drl_wrn_snd", {})
			end

			if not self._ene_weap_hot_listen_id then
				self._ene_weap_hot_listen_id = "Drill_ene_w_hot" .. tostring(self._unit:key())

				managers.groupai:state():add_listener(self._ene_weap_hot_listen_id, {
					"enemy_weapons_hot"
				}, callback(self, self, "clbk_enemy_weapons_hot"))
			end
		end
	end
end

function Drill:clbk_enemy_weapons_hot()
	managers.groupai:state():remove_listener(self._ene_weap_hot_listen_id)

	self._ene_weap_hot_listen_id = nil

	--self:_set_attention_state(false)
	self:_set_alert_state(false)
end

function Drill:_set_attention_state(state)
	if self.ignore_detection then
		if self._attention_handler then
			self._attention_handler:set_attention(nil)
		end

		return
	end

	if state then
		if not self._attention_handler then
			self._attention_handler = AIAttentionObject:new(self._unit, true)

			if self._attention_obj_name then
				self._attention_handler:set_detection_object_name(self._attention_obj_name)
			end
		end

		local descriptor = self._alert_radius and "drill_civ_ene_ntl" or "drill_silent_civ_ene_ntl"
		local attention_setting = PlayerMovement._create_attention_setting_from_descriptor(self, tweak_data.attention.settings[descriptor], descriptor)

		self._attention_handler:set_attention(attention_setting)
	elseif self._attention_handler then
		self._attention_handler:set_attention(nil)
	end
end

function Drill:set_skill_upgrades(upgrades)
	if self._disable_upgrades then
		return
	end

	local background_icons = {}
	local timer_gui_ext = self._unit:timer_gui()
	local background_icon_template = {
		texture = "guis/textures/pd2/skilltree/",
		alpha = 1,
		h = 128,
		y = 100,
		w = 128,
		x = 30,
		layer = 2
	}
	local background_icon_x = 30

	local function add_bg_icon_func(bg_icon_table, texture_name, color)
		local icon_data = deep_clone(background_icon_template)
		icon_data.texture = icon_data.texture .. texture_name
		icon_data.color = color
		icon_data.x = background_icon_x

		table.insert(bg_icon_table, icon_data)

		background_icon_x = background_icon_x + icon_data.w + 2
	end

	if self.is_drill or self.is_saw then
		local drill_speed_multiplier = tweak_data.upgrades.values.player.drill_speed_multiplier
		local drill_alert_rad = tweak_data.upgrades.values.player.drill_alert_rad[1]
		local current_speed_upgrade = self._skill_upgrades.speed_upgrade_level or 0
		local timer_multiplier = 1

		if upgrades.speed_upgrade_level and upgrades.speed_upgrade_level >= 2 or current_speed_upgrade >= 2 then
			timer_multiplier = drill_speed_multiplier[2]

			add_bg_icon_func(background_icons, "drillgui_icon_faster", timer_gui_ext:get_upgrade_icon_color("upgrade_color_2"))

			upgrades.speed_upgrade_level = 2
		elseif upgrades.speed_upgrade_level and upgrades.speed_upgrade_level >= 1 or current_speed_upgrade >= 1 then
			timer_multiplier = drill_speed_multiplier[1]

			add_bg_icon_func(background_icons, "drillgui_icon_faster", timer_gui_ext:get_upgrade_icon_color("upgrade_color_1"))

			upgrades.speed_upgrade_level = 1
		else
			add_bg_icon_func(background_icons, "drillgui_icon_faster", timer_gui_ext:get_upgrade_icon_color("upgrade_color_0"))

			upgrades.speed_upgrade_level = 0
		end

		local got_reduced_alert = upgrades.reduced_alert or false
		local current_reduced_alert = self._skill_upgrades.reduced_alert or false
		local got_silent_drill = upgrades.silent_drill or false
		local current_silent_drill = self._skill_upgrades.silent_drill or false
		local auto_repair_level_1 = upgrades.auto_repair_level_1 or 0
		local auto_repair_level_2 = upgrades.auto_repair_level_2 or 0
		local current_auto_repair_level_1 = self._skill_upgrades.auto_repair_level_1 or 0
		local current_auto_repair_level_2 = self._skill_upgrades.auto_repair_level_2 or 0

		timer_gui_ext:set_timer_multiplier(timer_multiplier)

		if got_silent_drill or current_silent_drill then
			self:set_alert_radius(nil)
			timer_gui_ext:set_skill(BaseInteractionExt.SKILL_IDS.aced)

			upgrades.silent_drill = true
			upgrades.reduced_alert = true

			add_bg_icon_func(background_icons, "drillgui_icon_silent", timer_gui_ext:get_upgrade_icon_color("upgrade_color_2"))
		elseif got_reduced_alert or current_reduced_alert then
			self:set_alert_radius(drill_alert_rad)
			timer_gui_ext:set_skill(BaseInteractionExt.SKILL_IDS.basic)

			upgrades.reduced_alert = true

			add_bg_icon_func(background_icons, "drillgui_icon_silent", timer_gui_ext:get_upgrade_icon_color("upgrade_color_1"))
		else
			self:set_alert_radius(tweak_data.upgrades.drill_alert_radius or 2500)
			timer_gui_ext:set_skill(BaseInteractionExt.SKILL_IDS.none)
			add_bg_icon_func(background_icons, "drillgui_icon_silent", timer_gui_ext:get_upgrade_icon_color("upgrade_color_0"))
		end

		if auto_repair_level_1 > 0 or current_auto_repair_level_1 > 0 or auto_repair_level_2 > 0 or current_auto_repair_level_2 > 0 then
			upgrades.auto_repair_level_1 = current_auto_repair_level_1
			upgrades.auto_repair_level_2 = current_auto_repair_level_2
			local drill_autorepair_chance = 0

			if current_auto_repair_level_1 < auto_repair_level_1 then
				current_auto_repair_level_1 = auto_repair_level_1
				upgrades.auto_repair_level_1 = auto_repair_level_1
			end

			if current_auto_repair_level_2 < auto_repair_level_2 then
				current_auto_repair_level_2 = auto_repair_level_2
				upgrades.auto_repair_level_2 = auto_repair_level_2
			end

			if current_auto_repair_level_1 > 0 then
				drill_autorepair_chance = drill_autorepair_chance + tweak_data.upgrades.values.player.drill_autorepair_2[1]
			end

			if current_auto_repair_level_2 > 0 then
				drill_autorepair_chance = drill_autorepair_chance + tweak_data.upgrades.values.player.drill_autorepair_1[1]
			end

			if Network:is_server() and math.random() < drill_autorepair_chance then
				self:set_autorepair(true)
			end

			--use golden icon by default since there's only one skill for it
			add_bg_icon_func(background_icons, "drillgui_icon_restarter", timer_gui_ext:get_upgrade_icon_color("upgrade_color_2"))
		else
			add_bg_icon_func(background_icons, "drillgui_icon_restarter", timer_gui_ext:get_upgrade_icon_color("upgrade_color_0"))
		end

		self._skill_upgrades = deep_clone(upgrades)
	end

	timer_gui_ext:set_background_icons(background_icons)
	timer_gui_ext:update_sound_event()
end

local destroy_original = Drill.destroy
function Drill:destroy()
	destroy_original(self)

	local nav_tracker = self._nav_tracker

	if nav_tracker then
		managers.navigation:destroy_nav_tracker(nav_tracker)

		self._nav_tracker = nil
	end
end
