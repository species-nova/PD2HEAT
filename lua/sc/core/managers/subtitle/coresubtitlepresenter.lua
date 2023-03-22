-- you might be wondering what this stuff is, it's needed so the hook actually works.

core:module("CoreSubtitlePresenter")
core:import("CoreClass")
core:import("CoreCode")
core:import("CoreEvent")
core:import("CoreDebug")
core:import("CoreSubtitleSequence")

SubtitlePresenter = SubtitlePresenter or CoreClass.class()
DebugPresenter = DebugPresenter or CoreClass.class(SubtitlePresenter)
OverlayPresenter = OverlayPresenter or CoreClass.class(SubtitlePresenter)

function OverlayPresenter:show_text(text, duration)
	local label = self.__subtitle_panel:child("label") or self.__subtitle_panel:text({
		name = "label",
		vertical = "bottom",
		word_wrap = true,
		wrap = true,
		align = "center",
		y = 1,
		x = 1,
		layer = 1,
		font = self.__font_name,
		font_size = self.__font_size,
		color = Color.white
	})
	local shadow = self.__subtitle_panel:child("shadow") or self.__subtitle_panel:text({
		name = "shadow",
		vertical = "bottom",
		wrap = true,
		align = "center",
		word_wrap = true,
		y = 2,
		x = 2,
		layer = 0,
		font = self.__font_name,
		font_size = self.__font_size,
		color = Color.black
	})

	label:set_text(text)
	shadow:set_text(text)
end