function MenuCallbackHandler:on_visit_res_guide()
	if SystemInfo:distribution() == Idstring("STEAM") and Idstring("english"):key() == SystemInfo:language():key() then
		if MenuCallbackHandler:is_overlay_enabled() then
			Steam:overlay_activate("url", "https://steamcommunity.com/sharedfiles/filedetails/?id=1366254667")
		else
			managers.menu:show_enable_steam_overlay()
		end
	elseif SystemInfo:distribution() == Idstring("STEAM") and Idstring("russian"):key() == SystemInfo:language():key() then
		if MenuCallbackHandler:is_overlay_enabled() then
			Steam:overlay_activate("url", "https://steamcommunity.com/sharedfiles/filedetails/?id=1923528592")
		else
			managers.menu:show_enable_steam_overlay()
		end
	end
end

function MenuCallbackHandler:open_crew_management()
	managers.menu:open_node("crew_management")
end

function MenuCallbackHandler:open_side_jobs()
	managers.menu:open_node("side_jobs")
end

--Functions below relate to long cut functionality, but seem to be load bearing.
--TODO: Find them and remove them.
function MenuCallbackHandler:SCEnabled()
	return true
end

function MenuManager:keep_overhaul_on()
	local option = true

	managers.menu:post_event("menu_enter")
end

function MenuManager:keep_overhaul_off()
	local option = false
end