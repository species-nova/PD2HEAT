if not ModCore then
	return
end

Month = os.date("%m")
Day = os.date("%d")	

heat._mod_path = heat:GetPath()
function heat:Init()
	heat.captain_types = {
		winter = {
			spawn_group = "Cap_Winters",
			icon = "guis/textures/pd2/hud_buff_shield",
			vs_line = "hud_assault_vip_winters"
		},
		spring = {
			spawn_group = "Cap_Spring",
			icon = "guis/textures/pd2/hud_buff_skull",
			vs_line = "hud_assault_vip_spring"
		},
		summer = {
			spawn_group = "Cap_Summers",
			icon = "guis/textures/pd2/hud_buff_fire",
			vs_line = "hud_assault_vip_summers"
		},
		autumn = {
			spawn_group = "Cap_Autumn",
			icon = "guis/textures/pd2/hud_buff_spooc",
			vs_line = "hud_assault_vip_autumn"
		},
		hvh = {
			spawn_group = "HVH_Boss",
			icon = "guis/textures/pd2/hud_buff_halloween",
			vs_line = "hud_assault_vip_hvh",
			captain_warn = "hud_assault_vip_hvhwarn"
		}
	}

	--Defines what captains spawn on what heists.
	heat.captain_spawns = {
		arena = heat.captain_types.winter, --Alesso
		welcome_to_the_jungle_1 = heat.captain_types.winter, --Big Oil Day 1
		welcome_to_the_jungle_1_night = heat.captain_types.winter, --Big Oil Day 1 Night
		stage_1 = heat.captain_types.winter, --Big Oil Day 1 EDIT
		welcome_to_the_jungle_2 = heat.captain_types.winter, --Big Oil Day 2
		stage_2 = heat.captain_types.winter, --Big Oil Day 2 EDIT
		election_day_1 = heat.captain_types.winter, --Election Day 1
		election_day_2 = heat.captain_types.winter, --Election Day 2
		election_day_3 = heat.captain_types.winter, --Election Day 3
		election_day_3_skip1 = heat.captain_types.winter, --Election Day 3 (Skipped 1)
		election_day_3_skip2 = heat.captain_types.winter, --Election Day 3 (Skipped 2)
		firestarter_2 = heat.captain_types.winter, --firestarter day 2
		four_stores = heat.captain_types.winter, --Four Stores
		moon = heat.captain_types.winter, --Stealing Xmas
		mus = heat.captain_types.winter,	--the diamond
		gallery = heat.captain_types.winter, --art gallery
		crojob3 = heat.captain_types.winter, --bomb forest
		red2 = heat.captain_types.winter, --fwb
		pal = heat.captain_types.summer, --counterfeit
		mia_1 = heat.captain_types.summer, --Hotline Day 1
		crojob2 = heat.captain_types.summer, --bomb dockyard
		firestarter_3 = heat.captain_types.summer, --firestarter day 3
		jolly = heat.captain_types.summer, --aftershock
		rvd1 = heat.captain_types.summer, --highland mortuary 
		mad = heat.captain_types.summer, --boiling point
		wwh = heat.captain_types.summer, --alaskan deal
		run = heat.captain_types.summer, --Heat Street
		run_res = heat.captain_types.summer, --Whurr's Heat Street Edit
		watchdogs_2 = heat.captain_types.summer, --watch dogs 2
		watchdogs_2_day = heat.captain_types.summer, --Watchdogs Day 2 Daytime
		jolly_CD = heat.captain_types.summer, --jolly crackdown edit
		dah = heat.captain_types.spring, --diamond heist
		hox_2 = heat.captain_types.spring, --Hoxout Day 2
		xmn_hox_2 = heat.captain_types.spring, --Hoxout Day 2, christmas
		firestarter_1 = heat.captain_types.spring, --firestarter day 1
		arm_for = heat.captain_types.spring, --train heist
		arm_for_heat = heat.captain_types.spring,	--train heist heat edit
		big = heat.captain_types.spring, --big bank
		kenaz = heat.captain_types.spring, --ggc
		bex = heat.captain_types.spring, --san martin bank
		dinner = heat.captain_types.spring, --Slaughterhouse
		chas = heat.captain_types.spring, --Dragon Heist
		alex_1 = heat.captain_types.autumn, --Rats Day 1
		rat = heat.captain_types.autumn,	--cook off
		flat = heat.captain_types.autumn, --panic room
		nightclub = heat.captain_types.autumn, --Night Club
		branchbank = heat.captain_types.autumn, --Bank Heist
		family = heat.captain_types.autumn, --diamond store
		framing_frame_1 = heat.captain_types.autumn, --art gallery but ff
		framing_frame_3 = heat.captain_types.autumn, --Powerbox simulator
		jewelry_store = heat.captain_types.autumn, --Jewelry Store
		ukrainian_job = heat.captain_types.autumn, --Ukrainian Job
		pex = heat.captain_types.autumn, --police station mex
		man = heat.captain_types.autumn, --undercover--
		rvd2 = heat.captain_types.autumn, --garnet group boutique 
		brb = heat.captain_types.autumn, --brooklyn bank
		help = heat.captain_types.hvh, --Prison Nightmare
		nail = heat.captain_types.hvh, --lab rats
		--Custom Heists--
		office_strike = heat.captain_types.winter, --office strike
		firestarter_2_res = heat.captain_types.winter, --firestarter day 2 edit
		firestarter_3_res = heat.captain_types.summer, --firestarter day 3 edit
		firestarter_1_res = heat.captain_types.spring, --firestarter day 1 edit
		lvl_friday = heat.captain_types.spring, --Crashing Capitol
		bnktower = heat.captain_types.spring, --GenSec HIVE
		alex_1_res = heat.captain_types.autumn, --Rats Day 1 edit
		lvl_fourmorestores = heat.captain_types.autumn, --four more stores
		ukrainian_job_res = heat.captain_types.autumn, --Ukrainian Job res edit version
		hntn = heat.captain_types.autumn --harvest and trustee north
	}

	if Month == "10" and heat.Options:GetValue("Holiday") then
		for heist, captain in pairs(heat.captain_spawns) do
			if captain == heat.captain_types.spring then
				heat.captain_spawns[heist] = heat.captain_types.hvh
			end
		end
	end

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
		"run", --Heat Street
		"run_res", --Whurr's Heat Street Edit
		"bph", --Hell's Island
		"pbr", --Beneath the Mountain
		"dinner", --Slaughterhouse
		"born", --Biker 1
		"flat",--Panic Room
		"framing_frame_3", --Framing Frame 3
		"sah", --Shacklethorne
		"chill_combat",	--Safehouse Raid
		"man", --Undercover
		"des",	--Henry's Rock
		"brb", --Brooklyn Bank
		"rvd2", --Resivoir Dogs 2
		"branchbank", --Bank heist
		"spa", --Brooklyn 10-10
		"firestarter_3", --firestarter day 3
		"firestarter_3_res", --firestarter day 3, res edit
		"mex_cooking", --Border Crystals
		"roberts", --Go Bank
		"family", --Diamond Store
		"jewelry_store", --Ukrainian job left off since its bag moving is optional, to compensate for the extra easiness.
		"rat",--Cook Off
		"chas",--Dragon Heist
		--Custom Heists below--
		"junk",
		"wetwork_burn", --Burnout
		"spa_CD",
		"wwh_CD"
	}
	--For levels that have aggressive scripted spawns, or spawn placement such that enemies are constantly spawned next to players.
	heat.very_tiny_levels = {
		"hox_1", --Hoxout 1. Not nessecarily 'extra tiny,' but its assault setup makes it more important to 
		"xmn_hox_1",
		"help", --Prison Nightmare
		"vit", --White House
		"pbr2", --Birth of Sky
		"mia_2", --Hotline Miami 2
		"nail",	--Lab Rats. Fuck this heist	
		--Custom Heists below--
		"thechase"
	}	
	--Mostly for stuff like Cursed Killed Room and other crap puny heists
	heat.extremely_tiny_levels = {
		"hvh", --CKR
		"chew", --Biker day 2
		"nmh", --No Mercy
		"nmh_res", --Resmod edit of no mercy.
		"peta2", --Goats day 2. Fuck this heist too		
		--Custom Heists below--
		"Victor Romeo"
	}

	heat.street_levels = {
		glace = true, --Green Bridge
		run_res = true, --Heat Street
		run = true,
		mad = true, --boiling point
		hox_1 = true, --Hoxout D1
		xmn_hox_1 = true,		--Xmas edition
		bnktower = true
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