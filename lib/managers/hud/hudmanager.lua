function HUDManager:set_dodge_value(value, total_dodge)
		--Sends current dodge meter level and players dodge stat to the dodge panel in HUDtemp.lua
		self._hud_temp:set_dodge_value(value, total_dodge)
end
