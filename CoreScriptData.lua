--THIS MUST ALWAYS HOOK TO core/lib/managers/coresequencemanager

--Environment skies loader (not needed until we do stuff to skies)
--[[
Hooks:Add("BeardLibPreProcessScriptData", "FinalMixCreateEnvironment", function(PackManager, path, raw_data)
    if managers.dyn_resource then
        local skies = {
            "sky_1930_twillight",
			"sky_1930_sunset_heavy_clouds",
            "sky_1846_low_sun_nice_clouds",
            "sky_0902_overcast",
			"sky_0200_night_moon_stars",
			"sky_2000_twilight_mad",
			"sky_2100_moon",
			"sky_1008_cloudy",
			"sky_0927_whispy_clouds",
			"sky_2335_night_moon",
			"sky_2100_moon",
			"sky_1313_cloudy_dark"
			
        }
        for _, sky in ipairs(skies) do
            if not managers.dyn_resource:has_resource(Idstring("scene"), Idstring("core/environments/skies/" .. sky .. "/" .. sky), managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
                RestorationCore.log_shit("not loaded")
                managers.dyn_resource:load(Idstring("scene"), Idstring("core/environments/skies/" .. sky .. "/" .. sky), managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)
            end
        end
    end
end)
]]--	
--Paintings

Hooks:Add("BeardLibCreateScriptDataMods", "MorePaintingsCallBeardLibSequenceFuncs", function()
	BeardLib:ReplaceScriptData("mods/PD2FinalMix/scriptdata/paint.custom_xml", "custom_xml", "units/payday2/architecture/com_int_gallery/com_int_gallery_wall_painting_bars", "sequence_manager", true)
end)


--Blue Sapphire FIX
--OVK never finished the opening animation, and it was wrongly calling for to activate the diamond (probably leftover from PD:TH), thus this fix
--probably update instances in heists where I want them to open with the PD:TH one raw
Hooks:Add("BeardLibCreateScriptDataMods", "DiamondFixCallBeardLibSequenceFuncs", function()
	BeardLib:ReplaceScriptData("mods/PD2FinalMix/scriptdata/diamondFIX.custom_xml", "custom_xml", "units/pd2_dlc_dah/props/dah_props_diamond_stands/dah_prop_diamond_stand_01", "sequence_manager", true)
end)
