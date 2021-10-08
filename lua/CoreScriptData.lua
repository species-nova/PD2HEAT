local mod_path = tostring(restoration._mod_path or "mods/PD2HEAT")

local environment_replacers = {
	branchbank = {
		{ --Mellow Day
			["environments/pd2_env_mid_day/pd2_env_mid_day"] = "scriptdata/mellowday.custom_xml"
		},
		{ --E3 2013
			["environments/pd2_env_mid_day/pd2_env_mid_day"] = "scriptdata/xbox_bank.custom_xml"
		},
		{ --Improved Default
			["environments/pd2_env_mid_day/pd2_env_mid_day"] = "scriptdata/bank_day.custom_xml"
		},
		{ --Trailer Bank
			["environments/pd2_env_mid_day/pd2_env_mid_day"] = "scriptdata/env_trailer_bank.custom_xml"
		}
	},
	rvd1 = {
		{ --Nightlife
			["units/pd2_dlc_rvd/environments/pd2_env_rvd/pd2_env_rvd_day1_exterior"] = "scriptdata/rvd1_alt1.custom_xml",
			["units/pd2_dlc_rvd/environments/pd2_env_rvd/pd2_env_rvd_day1_inside"] = "scriptdata/rvd1_alt1.custom_xml"
		},
		{ --Pink Smog
			["units/pd2_dlc_rvd/environments/pd2_env_rvd/pd2_env_rvd_day1_exterior"] = "scriptdata/rvd1_alt2.custom_xml",
			["units/pd2_dlc_rvd/environments/pd2_env_rvd/pd2_env_rvd_day1_inside"] = "scriptdata/rvd1_alt2.custom_xml"
		}
	},
	pbr2 = {
		{ --Pink Skies
			["environments/pd2_env_jry/pd2_env_jry"] = "scriptdata/bos_alt.custom_xml",
			["environments/pd2_env_jry_interior_01/pd2_env_jry_interior_01"] = "scriptdata/bos_alt.custom_xml"
		}
	},
	friend = {
		{}, --Default
		{ --Miami Night
			["environments/pd2_friend/pd2_friend"] = "scriptdata/scarfacenight.custom_xml"
		},
		{ --Pink Sunset
			["environments/pd2_friend/pd2_friend"] = "scriptdata/scarfacepink.custom_xml"
		}
	},
	crojob2 = {
		{}, --Default
		{ --Night Shift
			["environments/pd2_env_sunset/pd2_env_sunset"] = "scriptdata/dockyard_alt.custom_xml",
			["environments/pd2_env_jew_street/pd2_env_jew_street"] = "scriptdata/dockyard_alt.custom_xml",
			["environments/pd2_env_hox1_02/pd2_env_hox1_02"] = "scriptdata/dockyard_alt.custom_xml"
		}
	},
 	arm_und = {
 		{}, --Default
 		{ --Foggy Day
 			["environments/pd2_env_foggy_bright/pd2_env_foggy_bright"] = "scriptdata/underpass_foggyday.custom_xml"
 		}
 	},
 	--[[mallcrasher = {
 		{ --Afternoon Shopping
 			["environments/pd2_env_mid_day/pd2_env_mid_day"] = "scriptdata/mall_alt.custom_xml"
 		}
 	},]]--
 	mia_1 = {
 		{ --Morning Call
 			["environments/pd2_hlm1/pd2_hlm1"] = "scriptdata/hlm_morn.custom_xml"
 		},
 		{ --Retro
 			["environments/pd2_hlm1/pd2_hlm1"] = "scriptdata/funny_and_epic_synthwave_very_eighties.custom_xml"
 		}
 	},
 	watchdogs_1_night = {
 		{
 			["environments/pd2_env_night/pd2_env_night"] = "scriptdata/brightnight.custom_xml"
 		}
 	},
 	watchdogs_1 = {
 		{}, --Default
 		{ --Cloudy Day
 			["environments/pd2_env_mid_day/pd2_env_mid_day"] = "scriptdata/wd_d1_cloudy_day.custom_xml"
 		}
 	},
 	bronze = {
 		{
 			["environments/pd2_env_mid_day/pd2_env_mid_day"] = "scriptdata/bronze.custom_xml"
 		}
 	},
 	watchdogs_2_day = {
 		{
 			["environments/pd2_env_wd2_evening/pd2_env_wd2_evening"] = "scriptdata/docks.custom_xml"
 		}
 	},
 	alex_3 = {
 		{
 			["environments/pd2_env_rat_night_stage_3/pd2_env_rat_night_stage_3"] = "scriptdata/docks.custom_xml"
 		}
 	},
 	big = {
 		{
 			["environments/pd2_env_bigbank/pd2_env_bigbank"] = "scriptdata/xbox_bank.custom_xml"
 		}
 	},
 	four_stores = {
 		{ --Mellow Day
			["environments/pd2_env_mid_day/pd2_env_mid_day"] = "scriptdata/mellowday.custom_xml"
		},
		{ --E3 2013
			["environments/pd2_env_mid_day/pd2_env_mid_day"] = "scriptdata/xbox_bank.custom_xml"
		},
		{ --Improved Default
			["environments/pd2_env_mid_day/pd2_env_mid_day"] = "scriptdata/bank_day.custom_xml"
		},
		{ --Beta Green
			["environments/pd2_env_mid_day/pd2_env_mid_day"] = "scriptdata/bank_green.custom_xml"
		}
 	},
 	ukrainian_job_res = {
 		{ --Default
			["environments/pd2_env_mid_day/pd2_env_mid_day"] = "scriptdata/uk_job_new.custom_xml" 			
 		},
 		{ --Overcast
 			["environments/pd2_env_mid_day/pd2_env_mid_day"] = "scriptdata/cloudy_day.custom_xml"
 		}
 	},
 	escape_cafe_day = {
 		{
 			["environments/pd2_env_mid_day/pd2_env_mid_day"] = "scriptdata/cafe_escape_day_newdefault.custom_xml"
 		}
 	},
 	escape_cafe = {
 		{
 			["environments/env_cafe/env_cafe"] = "scriptdata/cafe_escape_night_newdefault.custom_xml"
 		}
 	},
 	skm_watchdogs_stage2 = {
 		{
 			["units/pd2_dlc_skm/environments/pd2_env_skm_watchdogs_2_exterior"] = "scriptdata/wd_d2_skm_new.custom_xml"
 		}
 	},
 	skm_big2 = {
 		{
 			["environments/pd2_env_bigbank/pd2_env_bigbank"] = "scriptdata/bb_skm_new.custom_xml"
 		}
 	},
 	kosugi = {
 		{
 			["environments/pd2_kosugi/pd2_kosugi"] = "scriptdata/shadowraid_darker.custom_xml"
 		}
 	},
 	run = {
 		{
 			["environments/pd2_run/run_outside"] = "scriptdata/heatstreettweak.custom_xml"
 		}
 	},
 	cult_murky = {
 		{
 			["core/environments/default"] = "scriptdata/cult_stage1.custom_xml"
 		}
 	},
 	peta = {
 		{},
 		{
 			["environments/pd2_peta1_outside/env_peta1_outside"] = "scriptdata/goat_cloudy_day.custom_xml"
 		}
 	},
 	family_res = {
 		{
 			["environments/pd2_env_jew_street/pd2_env_jew_street"] = "scriptdata/family.custom_xml"
 		}
 	},
	firestarter_1_res = {
		{
			["environments/pd2_env_night/pd2_env_night"] = "scriptdata/firestarter1_sunset.custom_xml"
		}
	},
	firestarter_2_res = {
		{
			["environments/pd2_env_night/pd2_env_night"] = "scriptdata/firestarter2.custom_xml"
		}
	},
	firestarter_3_res = {
		{
			["environments/pd2_env_mid_day/pd2_env_mid_day"] = "scriptdata/firestarter3_v2.custom_xml"
		}
	},
	alex_1_res = {
		{
			["environments/pd2_env_rat_night/pd2_env_rat_night"] = "scriptdata/rat1.custom_xml"
		}
	},
	alex_3_res = {
		{
			["environments/pd2_env_rat_night_stage_3/pd2_env_rat_night_stage_3"] = "scriptdata/rat3.custom_xml",
		}
	},
	man = {
		{
			["environments/pd2_man/pd2_man_main"] = "scriptdata/env_und.custom_xml",
			["environments/pd2_man/pd2_man_corridor"] = "scriptdata/env_und.custom_xml",
			["environments/pd2_man/pd2_man_corridor_nofog"] = "scriptdata/env_und.custom_xml",
			["environments/pd2_man/pd2_man_rooms"] = "scriptdata/env_und.custom_xml"
		}
	},
	flat = {
		{
			["environments/pd2_flat/pd2_flat"] = "scriptdata/env_flat_ext.custom_xml",
			["environments/pd2_flat_indoor/pd2_flat_indoor"] = "scriptdata/env_flat_int.custom_xml"
		}
	},
	--[[
	glace = {
		{
			["environments/pd2_glace/glace_outside"] = "scriptdata/env_glace_int.custom_xml",
			["environments/pd2_glace/glace_inside"] = "scriptdata/env_glace_int.custom_xml"
		}
	},
	]]
	jolly = {
		{
			["environments/pd2_lxa_river/pd2_lxa_river"] = "scriptdata/lxa_river_v4.custom_xml"
		}
	},
	jackal_surface_tension = {
		{
			["core/environments/default"] = "scriptdata/platinum.custom_xml"
		}
	}
}

--Checks the environment replacers table and replaces the environment if replacers are found.
--If multiple replacers exist, then it selects one at random.
--An empty replacer == load default environment.
function replaceEnvironment(level_id)
	local valid_envs = environment_replacers[level_id]
	if valid_envs then --Level has replacers defined.
		local selected_env = valid_envs[math.random(#valid_envs)]

		for default, replacement in pairs(selected_env) do
			BeardLib:ReplaceScriptData(mod_path .. replacement, "custom_xml", default, "environment")
		end
	end
end

Hooks:Add("BeardLibCreateScriptDataMods", "TODCallBeardLibSequenceFuncs", function()
	if Global.load_level == true then 
		replaceEnvironment(Global.game_settings.level_id)
	end
end)

--SC Level Edits
Hooks:Add("BeardLibCreateScriptDataMods", "SCLECallBeardLibSequenceFuncs", function()
	if Global.load_level == true then 
		if level_id == "safehouse" and SystemFS:exists(mod_path .. "scriptdata/missions/safehouse.mission") and SystemFS:exists(mod_path .. "scriptdata/missions/safehouse.continent") then
			BeardLib:ReplaceScriptData(mod_path .. "scriptdata/missions/safehouse.mission", "generic_xml", "levels/narratives/safehouse/world/world", "mission")
			BeardLib:ReplaceScriptData(mod_path .. "scriptdata/missions/safehouse.continent", "custom_xml", "levels/narratives/safehouse/world/world", "continent")
		end
		
		replaceEnvironment(Global.game_settings.level_id)
	end
end)

--Restoration Levels
Hooks:Add("BeardLibCreateScriptDataMods", "RESMapsCallBeardLibSequenceFuncs", function()
	if Global.load_level == true then 
		replaceEnvironment(Global.game_settings.level_id)
	end
end)

--Credits
Hooks:Add("BeardLibCreateScriptDataMods", "ResCreditsCallBeardLibSequenceFuncs", function()
	BeardLib:ReplaceScriptData(mod_path .. "assets/gamedata/rescredits.credits", "custom_xml", "gamedata/rescredits", "credits", true)
end)

--Environment skies loader
local skies = {
	"sky_1930_twillight",
	"sky_1930_sunset_heavy_clouds",
	"sky_1846_low_sun_nice_clouds",
	"sky_0902_overcast",
	"sky_1345_clear_sky",
	"sky_0200_night_moon_stars",
	"sky_2000_twilight_mad",
	"sky_2100_moon",
	"sky_1008_cloudy",
	"sky_0927_whispy_clouds",
	"sky_2335_night_moon",
	"sky_2100_moon",
	"sky_1313_cloudy_dark",
	"sky_2003_dusk_blue",
	"sky_2003_dusk_blue_high_color_scale"
}

Hooks:Add("BeardLibPreProcessScriptData", "RestorationCreateEnvironment", function(PackManager, path, raw_data)
    if managers.dyn_resource then
        for _, sky in ipairs(skies) do
            if not managers.dyn_resource:has_resource(Idstring("scene"), Idstring("core/environments/skies/" .. sky .. "/" .. sky), managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
                managers.dyn_resource:load(Idstring("scene"), Idstring("core/environments/skies/" .. sky .. "/" .. sky), managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)
            end
        end
    end
end)

--Blue Sapphire FIX
--OVK never finished the opening animation, and it was wrongly calling for to activate the diamond (probably leftover from PD:TH), thus this fix.  fix unfinished but works well enough
--probably update instances in heists where I want them to open with the PD:TH one raw.  someone port it correctly tyvm
Hooks:Add("BeardLibCreateScriptDataMods", "DiamondFixCallBeardLibSequenceFuncs", function()
	if SystemFS:exists(mod_path .. "scriptdata/diamondFIX.custom_xml") then
		BeardLib:ReplaceScriptData(mod_path .. "scriptdata/diamondFIX.custom_xml", "custom_xml", "units/pd2_dlc_dah/props/dah_props_diamond_stands/dah_prop_diamond_stand_01", "sequence_manager", true)
	end
end)
