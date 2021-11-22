if not ModCore then
	return
end

Month = os.date("%m")
Day = os.date("%d")	

heat._mod_path = heat:GetPath()
function heat:Init()
	--Winters
	heat.captain_camper = {
		"arena", --Alesso
		"welcome_to_the_jungle_1", --Big Oil Day 1
		"welcome_to_the_jungle_1_night", --Big Oil Day 1 Night
		"stage_1", --Big Oil Day 1 EDIT
		"welcome_to_the_jungle_2", --Big Oil Day 2
		"stage_2", --Big Oil Day 2 EDIT
		"election_day_1", --Election Day 1
		"election_day_2", --Election Day 2
		"election_day_3", --Election Day 3
		"election_day_3_skip1", --Election Day 3 (Skipped 1)
		"election_day_3_skip2", --Election Day 3 (Skipped 2)
		"firestarter_2", --firestarter day 2
		--"four_stores", --this absolutely does not need a captain, it's a beginner level
		"moon", --Stealing Xmas
		"mus",	--the diamond
		"gallery", --art gallery
		"crojob3", --bomb forest
		"red2", --fwb
		--Custom Heists--
		"office_strike", --office strike
		"firestarter_2_res" --firestarter day 2 res edit version
	}
	--Summers
	heat.captain_teamwork = {
		"pal", --counterfeit
		"mia_1", --Hotline Day 1
		"crojob2", --bomb dockyard
		"firestarter_3", --firestarter day 3
		"jolly", --aftershock
		"rvd1", --highland mortuary 
		"mad", --boiling point
		"wwh", --alaskan deal
		"run", --Heat Street
		"run_res", --Whurr's Heat Street Edit
		"watchdogs_2", --watch dogs 2
		"watchdogs_2_day", --Watchdogs Day 2 Daytime
		"jolly_CD", --jolly crackdown edit
		--custom heists		
		"firestarter_3_res" --firestarter day 3 res edit version
	}
	--Spring
	heat.captain_murderdozer = {
		"dah", --diamond heist
		"hox_2", --Hoxout Day 2
		"xmn_hox_2", --Hoxout Day 2, christmas
		"firestarter_1", --firestarter day 1
		"arm_for",	--train heist
		"arm_for_heat",	--train heist heat edit
		"big", --big bank
		"kenaz", --ggc
		"bex", --san martin bank
		"dinner", --Slaughterhouse
		"chas", --Dragon Heist
		--custom heists		
		"firestarter_1_res", --firestarter day 1 res edit version
		"lvl_friday" --Crashing Capitol
	}
	--Autumn
	heat.captain_stelf = {
		"alex_1", --Rats Day 1
		"rat",	--cook off
		"flat", --panic room
		"nightclub", --and Autumn stay off the dance floor
		"branchbank", --well the trees are orange
		"family", --diamond store
		"framing_frame_1", --art gallery but ff
		"framing_frame_3", --Powerbox simulator
		"jewelry_store", --Jewelry Store
		"ukrainian_job", --Ukrainian Job
		"pex", --police station mex
		"man", --undercover--
		"rvd2", --garnet group boutique 
		--"brb", --brooklyn bank THIS SUCKS CURRENTLY.  REDO THE SCRIPTED SPAWNS ON BRB BEFORE GIVING IT A CAPTAIN!!!
		--custom heists
		"wetwork", --res map package wetworks
		"alex_1_res", --Rats Day 1 res edit version
		"lvl_fourmorestores", --four more stores
		"ukrainian_job_res", --Ukrainian Job res edit version
		"hntn" --harvest and trustee north
	}
	--Headless
	heat.what_a_horrible_heist_to_have_a_curse = {
		"help", --Prison Nightmare
		"nail" --lab rats
		--"haunted", --safehouse nightmare
		--"hvh" --cursed kill room

	}
	
	if Month == "10" and heat.Options:GetValue("Holiday") then
		--No Spring During holidays
		heat.captain_murderdozer = {}
		--Autumn loses a few heists
		heat.captain_stelf = {
			"alex_1", --Rats Day 1
			"rat",	--cook off
			"nightclub", --and Autumn stay off the dance floor
			"family", --diamond store
			"framing_frame_1", --art gallery but ff
			"framing_frame_3", --Powerbox simulator
			"jewelry_store", --Jewelry Store
			"ukrainian_job", --Ukrainian Job
			--custom heists
			"wetwork", --res map package wetworks
			"alex_1_res", --Rats Day 1 res edit version
			"lvl_fourmorestores", --four more stores
			"ukrainian_job_res", --Ukrainian Job res edit version
			"hntn" --harvest and trustee north
		}		
		heat.what_a_horrible_heist_to_have_a_curse = {
			"dah", --diamond heist
			"hox_2", --Hoxout Day 2
			"xmn_hox_2", --Hoxout Day 2, christmas
			"firestarter_1", --firestarter day 1
			"arm_for",	--train heist
			"big", --big bank
			"dinner", --Slaughterhouse
			"branchbank", --Gets Branchbank from Autumn
			"help", --Prison Nightmare			
			"chas", --Dragon Heist
			--custom heists		
			"firestarter_1_res", --firestarter day 1 res edit version
			"lvl_friday" --Crashing Capitol
		}		
	end
	--Monsoon
	--[[heat.captain_viper = {
		"jackal_zero_day_stage7" --Zero Day 7
	}]]--
	--Increased spawns, should only be reserved for larger maps.
	heat.large_levels = {
		"friend", --Scarface Mansion
		"dah", --diamond heist
	}			
	--Slightly reduced spawns, generally use for heists with lengthy sections where players typically hold out in one smallish position, or 'early game' heists.
	heat.tiny_levels = {
		"welcome_to_the_jungle_2", --Big Oil 2. Scripted cloaker hell.
		"four_stores",
		"stage_2", --Big Oil Day 2 EDIT
		"cane", --Santa's Workshop
		"mus", --The Diamond
		"run", --Heat Street
		"run_res", --Whurr's Heat Street Edit
		"bph", --Hell's Island
		"glace", --Green Bridge
		"pbr", --Beneath the Mountain
		"dinner", --Slaughterhouse
		"born", --Biker 1
		"flat",--Panic Room
		"framing_frame_3", --Framing Frame 3
		"sah", --Shacklethorne
		"chill_combat",	--Safehouse Raid
		"man", --Undercover
		"jolly", --Aftershock
		"moon", --Stealing Xmas
		"branchbank", --Bank heist
		"firestarter_3", --firestarter day 3
		"firestarter_3_res", --firestarter day 3, res edit
		"mex_cooking", --Border Crystals
		"roberts", --Go Bank
		"family", --Diamond Store
		"jewelry_store", --Ukrainian job left off since its bag moving is optional, to compensate for the extra easiness.
		"fex", --Buluc's Mansion
		"rat",--Cook Off
		--"chca",--Black Cat
		"chas",--Dragon Heist
		--Custom Heists below--
		"junk",
		"wetwork_burn", --Burnout
		"spa_CD",
		"wwh_CD"
	}
	--For levels that have aggressive scripted spawns, or spawn placement such that enemies are constantly spawned next to players.
	heat.very_tiny_levels = {
		"help", --Prison Nightmare
		"pbr2", --Birth of Sky
		"rvd2", --Resivoir Dogs 2, has very aggressive scripted spawns.
		"spa", --Brooklyn 10-10
		"mia_2", --Hotline Miami 2
		"des",	--Henry's Rock
		"brb", --Brooklyn Bank
		"nail",	--Lab Rats. Fuck this heist	
		"hox_1",
		"xmn_hox_1",
		--Custom Heists below--
		"thechase"
	}	
	--Mostly for stuff like Cursed Killed Room and other crap puny heists
	heat.extremely_tiny_levels = {
		"vit", --White House
		"hvh", --CKR
		"chew", --Biker day 2
		"nmh", --No Mercy
		"nmh_res", --Resmod edit of no mercy.
		"peta2", --Goats day 2. Fuck this heist too		
		--Custom Heists below--
		"Victor Romeo"
	}

	--For custom heists that seem to be broken with our normal spawn setup
	heat.bad_spawn_heists = {
		"help",
		"fex", --Buluc's Mansion			
		--Custom Heists--
		"Victor Romeo",
		"hardware_store",
		"tj_htsb",
		"hntn",
		"bookmakers_office",
		"thechase",
		"office_strike",
		"santa_pain"
	}

	heat.street_levels = {
		glace = true, --Green Bridge
		run_res = true, --Heat Street
		run = true,
		mad = true, --boiling point
		hox_1 = true, --Hoxout D1
		xmn_hox_1 = true --Xmas edition
	}

	--Christmas Effects Heists
	heat.christmas_heists = {
		"roberts",
		"pines",
		"cane",
		"moon",
		--Custom Heists--
		"roberts_v2",
		"santa_pain"
	}	
	--heists to remove infinite assaults from
	heat.fuck_hunt = {
		"kenaz", --ggc
		"pines", --white xmas
		"spa", --brooklyn 10-10
		"jolly", --aftershock
		"ukrainian_job", --uk joj
		"ukrainian_job_res", --ditto
		"sah", --shacklethorne
		--"hox_1", --Hoxout D1
		--"xmn_hox_1" --Xmas edition
	}	

	_G.SC = _G.SC or {}
	SC._path = self.ModPath
	SC._data = {}

	if SystemFS:exists("mods/DMCWO/mod.txt") then
		SC._data.sc_player_weapon_toggle = false
	else
		SC._data.sc_player_weapon_toggle = true
	end

	local C = blt_class()
	VoicelineFramework = C
	VoicelineFramework.BufferedSounds = {}

	function C:register_unit(unit_name)
		--log("VF: Registering Unit, " .. unit_name)
		if _G.voiceline_framework then
			_G.voiceline_framework.BufferedSounds[unit_name] = {}
		end
	end

	function C:register_line_type(unit_name, line_type)
		if _G.voiceline_framework then
			if _G.voiceline_framework.BufferedSounds[unit_name] then
				--log("VF: Registering Type, " .. line_type .. " for Unit " .. unit_name)
				local fuck = _G.voiceline_framework.BufferedSounds[unit_name]
				fuck[line_type] = {}
			end
		end
	end

	function C:register_voiceline(unit_name, line_type, path)
		if _G.voiceline_framework then
			if _G.voiceline_framework.BufferedSounds[unit_name] then
				local fuck = _G.voiceline_framework.BufferedSounds[unit_name]
				if fuck[line_type] then
					--log("VF: Registering Path, " .. path .. " for Unit " .. unit_name)
					table.insert(fuck[line_type], XAudio.Buffer:new(path))
				end
			end
		end
	end

	if not _G.voiceline_framework then
		blt.xaudio.setup()
		_G.voiceline_framework = VoicelineFramework:new()
	end
end

function heat:all_enabled(...)
	for _, opt in pairs({...}) do
		if self.Options:GetValue(opt) == false then
			return false
		end
	end
	return true
end

function heat:LoadSCAssets()
	return true
end

function heat:LoadFonts()
	if not Idstring("russian"):key() == SystemInfo:language():key() then
		return true
	end
end