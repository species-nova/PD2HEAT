HUDManager._USE_BURST_MODE = true	

HUDManager.set_teammate_weapon_firemode_burst = HUDManager.set_teammate_weapon_firemode_burst or function(self, id)
	self._teammate_panels[HUDManager.PLAYER_PANEL]:set_weapon_firemode_burst(id)
end

if heat.Options:GetValue("RealAmmo") then
	local set_teammate_ammo_amount_original = HUDManager.set_teammate_ammo_amount
	function HUDManager:set_teammate_ammo_amount(id, selection_index, max_clip, current_clip, current_left, max)
	    if id == 4 then
	    	return set_teammate_ammo_amount_original(self, id, selection_index, max_clip, current_clip, math.max(current_left - current_clip, 0), math.max(current_left - current_clip, 0))
	    else
	    	return set_teammate_ammo_amount_original(self, id, selection_index, max_clip, current_clip, current_left, max)
	    end
	end
end