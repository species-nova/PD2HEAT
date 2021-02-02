--I feel bad for borrowing more stuff from Pixy, but I imagine he doesn't care as long as we credit.--
local image_transparency = 0.6
local adjust_aspect_ratio = true

function NewSkillTreeSkillItem:invest()
	local refresh = false
	local skill_id = self._skill_id

	if self._skilltree:has_enough_skill_points(skill_id) and self._skilltree:unlock(skill_id) then
		local skill_step = self._skilltree:skill_step(skill_id)
		local points = self._skilltree:get_skill_points(skill_id, skill_step, self._tier)
		local skill_points = self._skilltree:spend_points(points)

		self._gui:set_skill_point_text(skill_points)
		self._skilltree:_set_points_spent(self._tree, self._skilltree:points_spent(self._tree) + points)
		self:refresh(self._locked)

		refresh = true
	end

	return refresh
end

function NewSkillTreeSkillItem:refund()
	local skill_tree = self._skilltree
	local skill_id = self._skill_id
	local skill_level = skill_tree:skill_step(skill_id)
	local refresh = false

	if skill_level > 0 then
		local tier = self._tier
		local tree = self._tree

		if skill_tree:refund_skill(tree, tier, skill_id) then
			local cost = skill_tree:get_skill_points(skill_id, skill_level, tier)
			local skill_points = skill_tree:refund_points(cost)

			self._gui:set_skill_point_text(skill_points)
			self._skilltree:_set_points_spent(tree, skill_tree:points_spent(tree) - cost)
			self:refresh(self._locked)

			refresh = true
		end
	end

	return refresh
end

function NewSkillTreeGui:setbgimg(page, init)
	local bgpanels = { "_bg_image1", "_bg_image2", "_bg_image3", "_bg_image4", "_bg_image5" }

	if init then
		if self._fullscreen_ws then
			managers.gui_data:destroy_workspace(self._fullscreen_ws)
		end
		self._fullscreen_ws = nil
		self._fullscreen_panel = nil
		self._bg_image1 = nil
		self._bg_image2 = nil
		self._bg_image3 = nil
		self._bg_image4 = nil
		self._bg_image5 = nil

		self._fullscreen_ws = managers.gui_data:create_fullscreen_workspace()
		self._fullscreen_panel = self._fullscreen_ws:panel():panel({name = "fullscreen"})

		self._bg_image1 = self._fullscreen_panel:bitmap({
			name = "bg_image1",
			texture = "guis/textures/pd2/skilltree/bg_mastermind",
			w = self._fullscreen_panel:w(),
			h = self._fullscreen_panel:h(),
			layer = 1,
			blend_mode = "add"
		})

		self._bg_image2 = self._fullscreen_panel:bitmap({
			name = "bg_image2",
			texture = "guis/textures/pd2/skilltree/bg_enforcer",
			w = self._fullscreen_panel:w(),
			h = self._fullscreen_panel:h(),
			layer = 1,
			blend_mode = "add"
		})

		self._bg_image3 = self._fullscreen_panel:bitmap({
			name = "bg_image3",
			texture = "guis/textures/pd2/skilltree/bg_technician",
			w = self._fullscreen_panel:w(),
			h = self._fullscreen_panel:h(),
			layer = 1,
			blend_mode = "add"
		})

		self._bg_image4 = self._fullscreen_panel:bitmap({
			name = "bg_image4",
			texture = "guis/textures/pd2/skilltree/bg_ghost",
			w = self._fullscreen_panel:w(),
			h = self._fullscreen_panel:h(),
			layer = 1,
			blend_mode = "add"
		})

		self._bg_image5 = self._fullscreen_panel:bitmap({
			name = "bg_image5",
			texture = "guis/textures/pd2/skilltree/bg_fugitive",
			w = self._fullscreen_panel:w(),
			h = self._fullscreen_panel:h(),
			layer = 1,
			blend_mode = "add"
		})
	end


	for i, panel in ipairs(bgpanels) do
		self[panel]:set_alpha(image_transparency)
		local aspect = self._fullscreen_panel:w() / self._fullscreen_panel:h()
		local texture_width = self[panel]:texture_width()
		local texture_height = self[panel]:texture_height()

	if adjust_aspect_ratio == true then
		local correct_height = self._fullscreen_panel:w() / (16/9) -- actual menu aspect ratio
		self[panel]:set_size(correct_height, correct_height)
	else
		local sw = math.max(texture_width, texture_height * aspect)
		local sh = math.max(texture_height, texture_width / aspect)
		local dw = texture_width / sw
		local dh = texture_height / sh
		self[panel]:set_size(dw * self._fullscreen_panel:w(), dh * self._fullscreen_panel:h())
	end

		self[panel]:set_right(self._fullscreen_panel:w())
		self[panel]:set_center_y(self._fullscreen_panel:h() / 2)
	end

	for i, panel in ipairs(bgpanels) do
		self[panel]:set_visible(false)
	end

	if page == 1 then
		self._bg_image1:set_visible(true)
	elseif page == 2 then
		self._bg_image2:set_visible(true)
	elseif page == 3 then
		self._bg_image3:set_visible(true)
	elseif page == 4 then
		self._bg_image4:set_visible(true)
	elseif page == 5 then
		self._bg_image5:set_visible(true)
	end
end

Hooks:PreHook( NewSkillTreeGui , "init" , "gibskillbg_init" , function( self , params )
	NewSkillTreeGui:setbgimg(1, true)
end)

Hooks:PostHook( NewSkillTreeGui , "set_active_page" , "gibskillbg_setpage" , function( self , params )
	NewSkillTreeGui:setbgimg(self._active_page, false)
end)

Hooks:PostHook( NewSkillTreeGui , "close" , "gibtest2" , function( self , params )
	NewSkillTreeGui:setbgimg(0, false)
end)