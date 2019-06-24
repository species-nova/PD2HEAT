function HUDTemp:dodge_init()
		self._dodge_panel = self._temp_panel:panel({
			visible = true,
			name = "dodge_panel",
			layer = 0,
			w = 16,
			h = 128,
			halign = "right",
			valign = "center",
			alpha = 0
		})
		local dodge_bar_bg = self._dodge_panel:rect({
			name = "dodge_bar_bg",
			color = Color(0.6, 0.6, 0.6),
			alpha = 0.25
		})
		local dodge_bar = self._dodge_panel:rect({
			name = "dodge_bar",
			color = Color(0.5, 0.5, 0.8),
			layer = 1
		})
		local dodge_threshold = self._dodge_panel:rect({
			name = "dodge_threshold",
			color = Color(1, 1, 1),
			layer = 2,
			h = 2
		})
		self._dodge_panel:rect({
			name = "top_border",
			color = Color(0.0, 0.0, 0.0),
			layer = 3,
			h = 2
		}):set_top(0)
		self._dodge_panel:rect({
			name = "bottom_border",
			color = Color(0.0, 0.0, 0.0),
			layer = 3,
			h = 2
		}):set_bottom(128)
		self._dodge_panel:rect({
			name = "left_border",
			color = Color(0.0, 0.0, 0.0),
			layer = 3,
			w = 2
		}):set_left(0)
		self._dodge_panel:rect({
			name = "right_border",
			color = Color(0.0, 0.0, 0.0),
			layer = 3,
			w = 2
		}):set_right(16)
		--Move slightly closer to center of screen for readability and so it doesn't overlap with stamina.
		self._dodge_panel:set_right(self._temp_panel:w() - 16)
		self._dodge_panel:set_center_y(self._temp_panel:center_y())
		self._dodge_panel:set_alpha(0) --Hide dodge panel until players actually get dodge.
	end

	function HUDTemp:set_dodge_value(value, total_dodge)
		self._dodge_panel:set_alpha(1) --Display dodge panel when needed.
		self._dodge_panel:child("dodge_bar"):set_h((value / (1.0 - (total_dodge / 2.0))) * self._dodge_panel:h())
		self._dodge_panel:child("dodge_bar"):set_bottom(self._dodge_panel:h())
		if value >= 1.0 - (total_dodge / 2.0) then
			self._dodge_panel:animate(callback(self, self, "_animate_high_dodge"))
		else
			self._dodge_panel:stop()
			self._dodge_panel:child("dodge_bar"):set_color(Color(0.5, 0.5, 0.8))
		end
	end

	function HUDTemp:_animate_high_dodge(input_panel)
		--Flashing animation for when next hit will be dodged.
		local dodge_bar = input_panel:child("dodge_bar")
		while true do
			local a = (math.sin(Application:time() * 750) + 1) / 4
			dodge_bar:set_color(Color(0.5 + a, 0.5 + a, 0.8))
			coroutine.yield()
		end
	end


function HUDTemp:init(hud)
	self._hud_panel = hud.panel
	self:dodge_init()
	if self._hud_panel:child("temp_panel") then
		self._hud_panel:remove(self._hud_panel:child("temp_panel"))
	end

	self._temp_panel = self._hud_panel:panel({
		y = 0,
		name = "temp_panel",
		layer = 0,
		visible = true,
		valign = "scale"
	})
	local throw_instruction = self._temp_panel:text({
		visible = false,
		vertical = "bottom",
		h = 40,
		w = 300,
		alpha = 0.85,
		align = "right",
		name = "throw_instruction",
		layer = 1,
		text = "",
		font = "fonts/font_medium_mf",
		y = 2,
		halign = "right",
		font_size = 24,
		x = 8,
		valign = "bottom",
		color = Color.white
	})

	self:set_throw_bag_text()

	local bag_panel = self._temp_panel:panel({
		halign = "right",
		name = "bag_panel",
		layer = 10,
		visible = false,
		valign = "bottom"
	})
	self._bg_box = HUDBGBox_create(bag_panel, {
		w = 204,
		x = 0,
		h = 56,
		y = 0
	})

	bag_panel:set_size(self._bg_box:size())
	self._bg_box:text({
		layer = 1,
		name = "bag_text",
		vertical = "left",
		font_size = 24,
		text = "CARRYING:\nCIRCUIT BOARDS",
		font = "fonts/font_medium_mf",
		y = 2,
		x = 8,
		valign = "center",
		color = Color.white
	})

	local bag_text = bag_panel:text({
		visible = false,
		vertical = "center",
		h = 128,
		w = 256,
		font_size = 42,
		align = "center",
		name = "bag_text",
		text = "HEJ",
		font = "fonts/font_large_mf",
		halign = "scale",
		valign = "scale",
		color = Color.black
	})

	bag_text:set_size(bag_panel:size())
	bag_text:set_position(0, 4)

	self._bag_panel_w = bag_panel:w()
	self._bag_panel_h = bag_panel:h()

	bag_panel:set_right(self._temp_panel:w())
	bag_panel:set_bottom(self:_bag_panel_bottom())
	throw_instruction:set_bottom(bag_panel:top())
	throw_instruction:set_right(bag_panel:right())

	self._curr_stamina = 0
	self._max_stamina = 0
	self._stamina_panel = self._temp_panel:panel({
		layer = 0,
		name = "stamina_panel",
		h = 128,
		halign = "right",
		w = 16,
		valign = "center",
		alpha = 0,
		visable = true
	})
	local stamina_bar_bg = self._stamina_panel:rect({
		name = "stamina_bar_bg",
		alpha = 0.25,
		color = Color(0.6, 0.6, 0.6)
	})
	local low_stamina_bar = self._stamina_panel:rect({
		name = "low_stamina_bar",
		alpha = 0,
		color = Color(0.6, 0.6, 0.6)
	})
	local stamina_bar = self._stamina_panel:rect({
		name = "stamina_bar",
		layer = 1,
		color = Color(0.6, 0.6, 0.6)
	})
	local stamina_threshold = self._stamina_panel:rect({
		name = "stamina_threshold",
		h = 2,
		layer = 2,
		color = Color(1, 1, 1)
	})

	self._stamina_panel:rect({
		name = "top_border",
		h = 2,
		layer = 3,
		color = Color()
	}):set_top(0)
	self._stamina_panel:rect({
		name = "bottom_border",
		h = 2,
		layer = 3,
		color = Color()
	}):set_bottom(128)
	self._stamina_panel:rect({
		name = "left_border",
		w = 2,
		layer = 3,
		color = Color()
	}):set_left(0)
	self._stamina_panel:rect({
		name = "right_border",
		w = 2,
		layer = 3,
		color = Color()
	}):set_right(16)
	self._stamina_panel:set_right(self._temp_panel:w())
	self._stamina_panel:set_center_y(self._temp_panel:center_y())
end
