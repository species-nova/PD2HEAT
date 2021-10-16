core:module("CoreMenuItemSlider")
core:import("CoreMenuItem")

ItemSlider = ItemSlider or class(CoreMenuItem.Item)
ItemSlider.TYPE = "slider"
function ItemSlider:setup_gui(node, row_item)
	row_item.gui_panel = node.item_panel:panel({
		w = node.item_panel:w()
	})
	row_item.gui_text = node:_text_item_part(row_item, row_item.gui_panel, node:_right_align())

	row_item.gui_text:set_layer(node.layers.items + 1)

	local _, _, w, h = row_item.gui_text:text_rect()

	row_item.gui_panel:set_h(h)

	local bar_w = 192
	row_item.gui_slider_bg = row_item.gui_panel:rect({
		visible = false,
		vertical = "center",
		h = 22,
		align = "center",
		halign = "center",
		x = node:_left_align() - bar_w,
		y = h / 2 - 11,
		w = bar_w,
		color = Color.black:with_alpha(0.5),
		layer = node.layers.items - 1
	})
	row_item.gui_slider_gfx = row_item.gui_panel:gradient({
		vertical = "center",
		align = "center",
		halign = "center",
		orientation = "vertical",
		gradient_points = {
			0,
			self._slider_color,
			1,
			self._slider_color
		},
		x = node:_left_align() - bar_w + 2,
		y = row_item.gui_slider_bg:y() + 2,
		w = (row_item.gui_slider_bg:w() - 4) * 0.23,
		h = row_item.gui_slider_bg:h() - 4,
		blend_mode = node.row_item_blend_mode or "normal",
		color = row_item.color,
		layer = node.layers.items
	})
	row_item.gui_slider = row_item.gui_panel:rect({
		w = 100,
		color = row_item.color:with_alpha(0),
		layer = node.layers.items,
		h = row_item.gui_slider_bg:h() - 4
	})
	row_item.gui_slider_marker = row_item.gui_panel:bitmap({
		texture = "guis/textures/menu_icons",
		visible = true,
		texture_rect = {
			0,
			0,
			24,
			28
		},
		layer = node.layers.items + 2
	})
	local slider_text_align = row_item.align == "left" and "right" or row_item.align == "right" and "left" or row_item.align
	local slider_text_halign = row_item.slider_text_halign == "left" and "right" or row_item.slider_text_halign == "right" and "left" or row_item.slider_text_halign
	local slider_text_vertical = row_item.vertical == "top" and "bottom" or row_item.vertical == "bottom" and "top" or row_item.vertical
	row_item.gui_slider_text = row_item.gui_panel:text({
		y = 0,
		font_size = row_item.font_size or _G.tweak_data.menu.stats_font_size,
		x = node:_right_align(),
		h = h,
		w = row_item.gui_slider_bg:w(),
		align = slider_text_align,
		halign = slider_text_halign,
		vertical = slider_text_vertical,
		valign = slider_text_vertical,
		font = node.font,
		color = row_item.color,
		layer = node.layers.items + 1,
		text = "" .. math.floor(0) .. "%",
		blend_mode = node.row_item_blend_mode or "normal",
		render_template = Idstring("VertexColorTextured"),
		visible = self._show_slider_text
	})

	if row_item.help_text then
		-- Nothing
	end

	self:_layout(node, row_item)

	return true
end