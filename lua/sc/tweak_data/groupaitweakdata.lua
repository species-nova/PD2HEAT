local job = Global.level_data and Global.level_data.level_id

function GroupAITweakData:_init_chatter_data()
	self.enemy_chatter = {}
	--[[
	notes:
	radius seems to do nothing, game theory how many cops in a radius can say a certain chatter (should test this)
	max_nr how many chatter calls can go off at once
	duration ??? longer ones i grabbed from v009/pdth
	interval is cooldown
	group_min how many cops need to be in a group for the line to play
	queue what call is used in chatter
	]]--
	self.enemy_chatter.clear = {
		radius = 2000,
	    max_nr = 1,
	    duration = {60, 60},
	    interval = {3, 8},
	    group_min = 1,
	    queue = "clr"
	}
	self.enemy_chatter.csalpha = {
		radius = 6000,
	    max_nr = 1,
	    duration = {3, 4},
		interval = {2, 4},
		group_min = 0,
	    queue = "gr2a"
	}
	self.enemy_chatter.csbravo = {
		radius = 6000,
	    max_nr = 1,
	    duration = {3, 4},
		interval = {2, 4},
		group_min = 0,
	    queue = "gr2b"
	}
	self.enemy_chatter.cscharlie = {
		radius = 6000,
	    max_nr = 1,
	    duration = {3, 4},
		interval = {2, 4},
		group_min = 0,
	    queue = "gr2c"
	}
	self.enemy_chatter.csdelta = {
		radius = 6000,
	    max_nr = 1,
	    duration = {3, 4},
		interval = {2, 4},
		group_min = 0,
	    queue = "gr2d"
	}
	self.enemy_chatter.hrtalpha = {
		radius = 6000,
	    max_nr = 1,
	    duration = {3, 4},
		interval = {2, 4},
		group_min = 0,
	    queue = "gr1a"
	}
	self.enemy_chatter.hrtbravo = {
		radius = 6000,
	    max_nr = 1,
	    duration = {3, 4},
		interval = {2, 4},
		group_min = 0,
	    queue = "gr1b"
	}
	self.enemy_chatter.hrtcharlie = {
		radius = 6000,
	    max_nr = 1,
	    duration = {3, 4},
		interval = {2, 4},
		group_min = 0,
	    queue = "gr1c"
	}
	self.enemy_chatter.hrtdelta = {
		radius = 6000,
	    max_nr = 1,
	    duration = {3, 4},
		interval = {2, 4},
		group_min = 0,
	    queue = "gr1d"
	}
	self.enemy_chatter.dodge = {
		radius = 2000,
	    max_nr = 1,
	    duration = {0.5, 0.5},
	    interval = {0.75, 1.5},
	    group_min = 0,
	    queue = "lk3b"
	}
	self.enemy_chatter.csalpha = {
		radius = 6000,
		max_nr = 1,
		duration = {3, 4},
		interval = {2, 4},
		group_min = 0,
		queue = "gr2a"
	}
	self.enemy_chatter.csbravo = {
		radius = 6000,
		max_nr = 1,
		duration = {3, 4},
		interval = {2, 4},
		group_min = 0,
		queue = "gr2b"
	}
	self.enemy_chatter.cscharlie = {
		radius = 6000,
		max_nr = 1,
		duration = {3, 4},
		interval = {2, 4},
		group_min = 0,
		queue = "gr2c"
	}
	self.enemy_chatter.csdelta = {
		radius = 6000,
		max_nr = 1,
		duration = {3, 4},
		interval = {2, 4},
		group_min = 0,
		queue = "gr2d"
	}
	self.enemy_chatter.hrtalpha = {
		radius = 6000,
		max_nr = 1,
		duration = {3, 4},
		interval = {2, 4},
		group_min = 0,
		queue = "gr1a"
	}
	self.enemy_chatter.hrtbravo = {
		radius = 6000,
		max_nr = 1,
		duration = {3, 4},
		interval = {2, 4},
		group_min = 0,
		queue = "gr1b"
	}
	self.enemy_chatter.hrtcharlie = {
		radius = 6000,
		max_nr = 1,
		duration = {3, 4},
		interval = {2, 4},
		group_min = 0,
		queue = "gr1c"
	}
	self.enemy_chatter.hrtdelta = {
		radius = 6000,
		max_nr = 1,
		duration = {3, 4},
		interval = {2, 4},
		group_min = 0,
		queue = "gr1d"
	}
	self.enemy_chatter.aggressive = {
		radius = 700,
		max_nr = 10,
		duration = {3, 4},
		interval = {1.5, 2},
		group_min = 0,
		queue = "g90"
	}
	self.enemy_chatter.aggressive_assault = {--cops use less idle chatter during assaults
		radius = 700,
		max_nr = 10,
		duration = {3, 4},
		interval = {2, 2.5},
		group_min = 0,
		queue = "g90"
	}
	self.enemy_chatter.open_fire = {
		radius = 1000,
		max_nr = 10,
		duration = {2, 4},
		interval = {0.75, 1.5},
		group_min = 0,
		queue = "att"
	}
	self.enemy_chatter.aggressive_captain = {
		radius = 700,
		max_nr = 20,
		duration = {2, 4},
		interval = {0.75, 1.5},
		group_min = 0,
		queue = "a05"
	}
	self.enemy_chatter.retreat = {
		radius = 700,
		max_nr = 10,
		duration = {2, 4},
		interval = {2, 4},
		group_min = 0,
		queue = "m01"
	}
	self.enemy_chatter.deathguard = { --this isnt actually kill lines those are done in playerdamage
		radius = 700,
		max_nr = 5,
		duration = {2, 4},
		interval = {2, 3},
		group_min = 0,
		queue = "r01"
	}
	self.enemy_chatter.contact = {
		radius = 700,
		max_nr = 5,
		duration = {1, 3},
		interval = {0.75, 1.5},
		group_min = 2,
		queue = "c01"
	}
	self.enemy_chatter.clear = {
		radius = 700,
		max_nr = 3,
		duration = {60, 60},
		interval = {0.75, 1.5},
		group_min = 3,
		queue = "clr"
	}
	self.enemy_chatter.clear_whisper = {
		radius = 700,
		max_nr = 2,
		duration = {60, 60},
		interval = {5, 5},
		group_min = 0,
		queue = "a05"
	}
	self.enemy_chatter.clear_whisper_2 = {
		radius = 700,
		max_nr = 2,
		duration = {60, 60},
		interval = {5, 5},
		group_min = 0,
		queue = "a06"
	}
	self.enemy_chatter.go_go = {
		radius =  1000,
		max_nr = 20,
		duration = {2, 2},
		interval = {0.75, 1},
		group_min = 0,
		queue = "mov"
	}
	self.enemy_chatter.push = {
		radius = 1000,
		max_nr = 20,
		duration = {2, 4},
		interval = {0.75, 1.5},
		group_min = 0,
		queue = "pus"
	}
	self.enemy_chatter.reload = {
		radius = 700,
		max_nr = 4,
		duration = {2, 4},
		interval = {4, 5},
		group_min = 0,
		queue = "rrl"
	}
	self.enemy_chatter.look_for_angle = {
		radius = 700,
		max_nr = 20,
		duration = {2, 4},
		interval = {2, 4},
		group_min = 0,
		queue = "t01"
	}
	self.enemy_chatter.ready = {
		radius = 1000,
		max_nr = 20,
		duration = {2, 4},
		interval = {0.75, 1.5},
		group_min = 0,
		queue = "rdy"
	}
	self.enemy_chatter.smoke = {
		radius = 1000,
		max_nr = 3,
		duration = {2, 2},
		interval = {0.1, 0.1},
		group_min = 0,
		queue = "d01"
	}
	self.enemy_chatter.flash_grenade = {
		radius = 1000,
		max_nr = 3,
		duration = {2, 2},
		interval = {0.1, 0.1},
		group_min = 0,
		queue = "d02"
	}
	self.enemy_chatter.ecm = {
		radius = 1000,
		max_nr = 20,
		duration = {2, 4},
		interval = {0.75, 1.5},
		group_min = 0,
		queue = "ch3"
	}
	self.enemy_chatter.saw = {
		radius = 1000,
		max_nr = 20,
		duration = {2, 4},
		interval = {0.75, 1.5},
		group_min = 0,
		queue = "ch4"
	}
	self.enemy_chatter.trip_mines = {
		radius = 1000,
		max_nr = 20,
		duration = {2, 4},
		interval = {0.75, 1.5},
		group_min = 0,
		queue = "ch1"
	}
	self.enemy_chatter.sentry = {
		radius = 1000,
		max_nr = 20,
		duration = {2, 4},
		interval = {0.75, 1.5},
		group_min = 0,
		queue = "ch2"
	}
	self.enemy_chatter.incomming_captain = {
		radius = 1500,
		max_nr = 1,
		duration = {10, 10},
		interval = {0.5, 1},
		group_min = 0,
		queue = "att"
	}
	self.enemy_chatter.incomming_gren = {
		radius = 1500,
		max_nr = 1,
		duration = {10, 10},
		interval = {0.5, 1},
		group_min = 0,
		queue = "bak"
	}
	self.enemy_chatter.incomming_tank = {
		radius = 1500,
		max_nr = 1,
		duration = {10, 10},
		interval = {0.5, 1},
		group_min = 0,
		queue = "lk3b"
	}
	self.enemy_chatter.incomming_spooc = {
		radius = 1200,
		max_nr = 1,
		duration = {10, 10},
		interval = {0.5, 1},
		group_min = 0,
		queue = "r01"
	}
	self.enemy_chatter.incomming_shield = {
		radius = 1500,
		max_nr = 1,
		duration = {10, 10},
		interval = {0.5, 1},
		group_min = 0,
		queue = "pos"
	}
	self.enemy_chatter.incomming_taser = {
		radius = 1500,
		max_nr = 1,
		duration = {60, 60},
		interval = {0.5, 1},
		group_min = 0,
		queue = "bak"
	}
	self.enemy_chatter.heal_chatter = {
		radius = 700,
		max_nr = 10,
		duration = {2, 4},
		interval = {1.5, 3.5},
		group_min = 0,
		queue = "heal"
	}
	self.enemy_chatter.heal_chatter_winters = {
		radius = 700,
		max_nr = 10,
		duration = {2, 4},
		interval = {8.5, 10.5},
		group_min = 0,
		queue = "a05"
	}
	self.enemy_chatter.aggressive = {
		radius = 2000,
		max_nr = 40,
		duration = {3, 4},
		interval = {4, 6},
		group_min = 0,
		queue = "g90"
	}
	self.enemy_chatter.approachingspecial = {
		radius = 4000,
		max_nr = 4,
		duration = {1, 1},
		interval = {6, 10},
		group_min = 0,
		queue = "g90"
	}
	self.enemy_chatter.lotusapproach = {
		radius = 4000,
		max_nr = 40,
		duration = {1, 1},
		interval = {1, 4},
		group_min = 0,
		queue = "ch3"
	}
	self.enemy_chatter.aggressivecontrolsurprised1 = {
		radius = 2000,
	    max_nr = 4,
	    duration = {0.5, 0.5},
	    interval = {4, 5},
	    group_min = 0,
	    queue = "lk3b"
	}
	self.enemy_chatter.aggressivecontrolsurprised2 = {
		radius = 2000,
	    max_nr = 4,
	    duration = {0.5, 0.5},
	    interval = {4, 5},
	    group_min = 0,
	    queue = "hlp"
	}
	self.enemy_chatter.aggressivecontrol = {
		radius = 2000,
	    max_nr = 40,
	    duration = {0.5, 0.5},
	    interval = {1.75, 2.5},
	    group_min = 0,
	    queue = "c01"
	}
	self.enemy_chatter.assaultpanic = {
		radius = 2000,
		max_nr = 40,
		duration = {3, 4},
		interval = {3, 6},
		group_min = 0,
		queue = "g90"
	}
	self.enemy_chatter.assaultpanicsuppressed1 = {
		radius = 2000,
		max_nr = 40,
		duration = {3, 4},
		interval = {3, 6},
		group_min = 0,
		queue = "hlp"
	}
	self.enemy_chatter.assaultpanicsuppressed2 = {
		radius = 2000,
	    max_nr = 40,
	    duration = {3, 4},
		interval = {3, 6},
	    group_min = 0,
	    queue = "lk3b"
	}
	self.enemy_chatter.open_fire = {
		radius = 2000,
		max_nr = 40,
		duration = {2, 4},
		interval = {2, 4},
		group_min = 0,
		queue = "att"
	}
	self.enemy_chatter.retreat = {
		radius = 2000,
		max_nr = 20,
		duration = {2, 4},
		interval = {0.25, 0.75},
		group_min = 0,
		queue = "m01"
	}
	self.enemy_chatter.cuffed = {
		radius = 1000,
	    max_nr = 1,
	    duration = {0.5, 0.5},
	    interval = {2, 6},
	    group_min = 0,
	    queue = "hr01 "
	}
	self.enemy_chatter.contact = {
		radius = 2000,
		max_nr = 20,
		duration = {1, 3},
		interval = {4, 6},
		group_min = 0,
		queue = "c01"
	}
	self.enemy_chatter.cloakercontact = {
		radius = 1500,
		max_nr = 4,
		duration = {1, 1},
		interval = {2, 4},
		group_min = 0,
		queue = "c01x_plu"
	}
	self.enemy_chatter.cloakeravoidance = {
		radius = 4000,
		max_nr = 4,
		duration = {1, 1},
		interval = {2, 4},
		group_min = 0,
		queue = "m01x_plu"
	}
	self.enemy_chatter.controlpanic = {
		radius = 2000,
	    max_nr = 40,
	    duration = {3, 6},
	    interval = {6, 8},
	    group_min = 1,
	    queue = "g90"
	}
	self.enemy_chatter.sabotagepower = {
		radius = 2000,
	    max_nr = 10,
	    duration = {1, 1},
	    interval = {8, 16},
	    group_min = 1,
	    queue = "e03"
	}
	self.enemy_chatter.sabotagedrill = {
		radius = 2000,
	    max_nr = 10,
	    duration = {1, 1},
	    interval = {8, 16},
	    group_min = 1,
	    queue = "e01"
	}
	self.enemy_chatter.sabotagegeneric = {
		radius = 2000,
	    max_nr = 10,
	    duration = {1, 1},
	    interval = {8, 16},
	    group_min = 1,
	    queue = "e04"
	}
	self.enemy_chatter.sabotagebags = {
		radius = 2000,
	    max_nr = 10,
	    duration = {1, 1},
	    interval = {8, 16},
	    group_min = 1,
	    queue = "l01"
	}
	self.enemy_chatter.sabotagehostages = {
		radius = 2000,
	    max_nr = 40,
	    duration = {1, 1},
	    interval = {8, 16},
	    group_min = 1,
	    queue = "civ"
	}
	self.enemy_chatter.hostagepanic1 = {
		radius = 2000,
	    max_nr = 40,
	    duration = {1, 1},
	    interval = {8, 12},
	    group_min = 1,
	    queue = "p01"
	}
	self.enemy_chatter.hostagepanic2 = {
		radius = 2000,
	    max_nr = 40,
	    duration = {1, 1},
	    interval = {8, 12},
	    group_min = 1,
	    queue = "p02"
	}
	self.enemy_chatter.hostagepanic3 = {
		radius = 2000,
	    max_nr = 40,
	    duration = {1, 1},
	    interval = {8, 12},
	    group_min = 1,
	    queue = "p03"
	}
	self.enemy_chatter.civilianpanic = {
		radius = 2000,
	    max_nr = 40,
	    duration = {1, 1},
	    interval = {6, 8},
	    group_min = 1,
	    queue = "bak"
	}
end

function GroupAITweakData:_init_unit_categories(difficulty_index)
	local access_type_walk_only = {walk = true}
	local access_type_all = {walk = true, acrobatic = true}
	local Net = _G.LuaNetworking
	local job_id = managers.job and managers.job:current_job_id()
	local tweak = job_id and tweak_data.narrative.jobs[job_id]
	local job = Global.level_data and Global.level_data.level_id
	Month = os.date("%m")
	Day = os.date("%d")
	self.unit_categories = {}


	if difficulty_index <= 7 then
		self.unit_categories.spooc = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_spook_1/ene_spook_1")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_spook_hvh_1/ene_spook_hvh_1")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_murky_spook/ene_murky_spook")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_cloaker_policia_federale_sc/ene_swat_cloaker_policia_federale_sc")
				},
				nypd = {
					Idstring("units/pd2_mod_nypd/characters/ene_spook_1/ene_spook_1")
				},
				lapd = {
					Idstring("units/payday2/characters/ene_spook_1/ene_spook_1")
				},
				omnia_skm = {
					Idstring("units/pd2_mod_omnia/characters/ene_omnia_spook/ene_omnia_spook")
				}
			},
			access = access_type_all,
			special_type = "spooc"
		}
	else --Upgrade some to OMNIA/ZEAL on DS.
		self.unit_categories.spooc = {
			unit_types = {
				america = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_zeal_cloaker/ene_zeal_cloaker")
				},
				murkywater = {
					Idstring("units/pd2_mod_omnia/characters/ene_omnia_spook/ene_omnia_spook")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_cloaker_policia_federale_sc/ene_swat_cloaker_policia_federale_sc")
				},
				nypd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker")
				},
				lapd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker")
				},
				omnia_skm = {
					Idstring("units/pd2_mod_omnia/characters/ene_omnia_spook/ene_omnia_spook")
				}
			},
			access = access_type_all,
			special_type = "spooc"
		}
	end

	self.unit_categories.Titan_spooc = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			zombie = {
				Idstring("units/payday2/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			federales = {
				Idstring("units/payday2/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			nypd = {
				Idstring("units/payday2/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			lapd = {
				Idstring("units/payday2/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			}
		},
		access = access_type_all,
		special_type = "spooc"
	}

	self.unit_categories.CS_cop_C45_R870 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_3/ene_cop_3"),
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_c45_sc/ene_akan_cs_cop_c45_sc"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg_sc/ene_akan_cs_cop_akmsu_smg_sc"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_r870/ene_akan_cs_cop_r870")
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_1/ene_cop_hvh_1"),
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3"),
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4")
			},
			murkywater = {
				Idstring("units/pd2_mod_sharks/characters/ene_murky_cs_cop_c45/ene_murky_cs_cop_c45"),
				Idstring("units/pd2_mod_sharks/characters/ene_murky_cs_cop_mp5/ene_murky_cs_cop_mp5"),
				Idstring("units/pd2_mod_sharks/characters/ene_murky_cs_cop_r870/ene_murky_cs_cop_r870")
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"),
				Idstring("units/pd2_dlc_bex/characters/ene_policia_03/ene_policia_03"),
				Idstring("units/pd2_dlc_bex/characters/ene_policia_04/ene_policia_04")
			},
			nypd = {
				Idstring("units/pd2_mod_nypd/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/pd2_mod_nypd/characters/ene_cop_3/ene_cop_3"),
				Idstring("units/pd2_mod_nypd/characters/ene_cop_4/ene_cop_4")
			},
			lapd = {
				Idstring("units/pd2_mod_lapd/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/pd2_mod_lapd/characters/ene_cop_2/ene_cop_2"),
				Idstring("units/pd2_mod_lapd/characters/ene_cop_4/ene_cop_4")
			},
			omnia_skm = {
				Idstring("units/pd2_mod_sharks/characters/ene_murky_cs_cop_c45/ene_murky_cs_cop_c45"),
				Idstring("units/pd2_mod_sharks/characters/ene_murky_cs_cop_mp5/ene_murky_cs_cop_mp5"),
				Idstring("units/pd2_mod_sharks/characters/ene_murky_cs_cop_r870/ene_murky_cs_cop_r870")
			}
		},
		access = access_type_all
	}

	self.unit_categories.CS_cop_C45_MP5 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/payday2/characters/ene_cop_3/ene_cop_3")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_c45_sc/ene_akan_cs_cop_c45_sc"),
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg_sc/ene_akan_cs_cop_akmsu_smg_sc"),
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_1/ene_cop_hvh_1"),
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3")
			},
			murkywater = {
				Idstring("units/pd2_mod_sharks/characters/ene_murky_cs_cop_c45/ene_murky_cs_cop_c45"),
				Idstring("units/pd2_mod_sharks/characters/ene_murky_cs_cop_mp5/ene_murky_cs_cop_mp5")
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_policia_01/ene_policia_01"),
				Idstring("units/pd2_dlc_bex/characters/ene_policia_03/ene_policia_03")
			},
			nypd = {
				Idstring("units/pd2_mod_nypd/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/pd2_mod_nypd/characters/ene_cop_3/ene_cop_3")
			},
			lapd = {
				Idstring("units/pd2_mod_lapd/characters/ene_cop_1/ene_cop_1"),
				Idstring("units/pd2_mod_lapd/characters/ene_cop_3/ene_cop_3")
			},
			omnia_skm = {
				Idstring("units/pd2_mod_sharks/characters/ene_murky_cs_cop_c45/ene_murky_cs_cop_c45"),
				Idstring("units/pd2_mod_sharks/characters/ene_murky_cs_cop_mp5/ene_murky_cs_cop_mp5")
			}
		},
		access = access_type_all
	}

	self.unit_categories.CS_cop_R870 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_cop_4/ene_cop_4")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_r870/ene_akan_cs_cop_r870")
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4")
			},
			murkywater = {
				Idstring("units/pd2_mod_sharks/characters/ene_murky_cs_cop_r870/ene_murky_cs_cop_r870")
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_policia_04/ene_policia_04")
			},
			nypd = {
				Idstring("units/pd2_mod_nypd/characters/ene_cop_4/ene_cop_4")
			},
			lapd = {
				Idstring("units/pd2_mod_lapd/characters/ene_cop_4/ene_cop_4"),
			},
			omnia_skm = {
				Idstring("units/pd2_mod_sharks/characters/ene_murky_cs_cop_r870/ene_murky_cs_cop_r870")
			}
		},
		access = access_type_all
	}

	self.unit_categories.CS_cop_stealth_MP5 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_cop_2/ene_cop_2")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_cop_raging_bull_sc/ene_akan_cs_cop_raging_bull_sc")
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_cop_hvh_2/ene_cop_hvh_2")
			},
			murkywater = {
				Idstring("units/pd2_mod_sharks/characters/ene_murky_cs_cop_raging_bull/ene_murky_cs_cop_raging_bull")
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_policia_02/ene_policia_02")
			},
			nypd = {
				Idstring("units/pd2_mod_nypd/characters/ene_cop_2/ene_cop_2")
			},
			lapd = {
				Idstring("units/pd2_mod_lapd/characters/ene_cop_2/ene_cop_2")
			},
			omnia_skm = {
				Idstring("units/pd2_mod_sharks/characters/ene_murky_cs_cop_raging_bull/ene_murky_cs_cop_raging_bull")
			}
		},
		access = access_type_all
	}

	self.unit_categories.omnia_LPF = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_vip/characters/ene_omnia_lpf/ene_omnia_lpf")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_akan_lpf/ene_akan_lpf")
			},
			zombie = {
				Idstring("units/pd2_mod_halloween/characters/ene_omnia_lpf/ene_omnia_lpf")
			},
			murkywater = {
				Idstring("units/pd2_dlc_vip/characters/ene_omnia_lpf/ene_omnia_lpf")
			},
			federales = {
				Idstring("units/pd2_dlc_vip/characters/ene_omnia_lpf/ene_omnia_lpf")
			},
			nypd = {
				Idstring("units/pd2_dlc_vip/characters/ene_omnia_lpf/ene_omnia_lpf")
			},
			lapd = {
				Idstring("units/pd2_dlc_vip/characters/ene_omnia_lpf/ene_omnia_lpf")
			},
			omnia_skm = {
				Idstring("units/pd2_dlc_vip/characters/ene_omnia_lpf/ene_omnia_lpf")
			}
		},
		special_type = "medic_lpf",
		access = access_type_all
	}

	self.unit_categories.fbi_vet = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_veteran_cop_1/ene_veteran_cop_1"),
				Idstring("units/payday2/characters/ene_veteran_cop_2/ene_veteran_cop_2")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_akan_veteran_2/ene_akan_veteran_2")
			},
			zombie = {
				Idstring("units/pd2_mod_halloween/characters/ene_veteran_cop_1/ene_veteran_cop_1")
			},
			murkywater = {
				Idstring("units/pd2_mod_sharks/characters/ene_murky_veteran_1/ene_murky_veteran_1"),
				Idstring("units/pd2_mod_sharks/characters/ene_murky_veteran_2/ene_murky_veteran_2")
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_veteran_enrique_1/ene_veteran_enrique_1"),
				Idstring("units/pd2_dlc_bex/characters/ene_veteran_enrique_2/ene_veteran_enrique_2")
			},
			nypd = {
				Idstring("units/payday2/characters/ene_veteran_cop_1/ene_veteran_cop_1"),
				Idstring("units/payday2/characters/ene_veteran_cop_2/ene_veteran_cop_2")
			},
			lapd = {
				Idstring("units/payday2/characters/ene_veteran_cop_1/ene_veteran_cop_1"),
				Idstring("units/payday2/characters/ene_veteran_cop_2/ene_veteran_cop_2")
			},
			omnia_skm = {
				Idstring("units/pd2_mod_sharks/characters/ene_murky_veteran_1/ene_murky_veteran_1")
			}
		},
		access = access_type_all
	}

	if difficulty_index <= 7 then
		self.unit_categories.CS_swat_MP5 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_swat_1/ene_swat_1")
				},
				russia = {
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_swat_1/ene_swat_1")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_sc/ene_swat_policia_federale_sc")
				},
				nypd = {
					Idstring("units/pd2_mod_nypd/characters/ene_nypd_swat_1/ene_nypd_swat_1")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_swat_1/ene_swat_1")
				},
				omnia_skm = {
					Idstring("units/pd2_mod_omnia/characters/ene_omnia_hrt_1/ene_omnia_hrt_1")
				}
			},
			access = access_type_all
		}
	else
		self.unit_categories.CS_swat_MP5 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				russia = {
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_hvh_2/ene_fbi_hvh_2"),
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_hvh_3/ene_fbi_hvh_3")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/pd2_mod_sharks/characters/ene_fbi_3/ene_fbi_3")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/pd2_dlc_bex/characters/ene_fbi_3/ene_fbi_3")
				},
				nypd = {
					Idstring("units/pd2_mod_nypd/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/pd2_mod_nypd/characters/ene_fbi_3/ene_fbi_3")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/pd2_mod_lapd/characters/ene_fbi_3/ene_fbi_3")
				},
				omnia_skm = {
					Idstring("units/pd2_mod_omnia/characters/ene_omnia_hrt_2/ene_omnia_hrt_2"),
					Idstring("units/pd2_mod_omnia/characters/ene_omnia_hrt_1/ene_omnia_hrt_1")
				}
			},
			access = access_type_all
		}
	end

	self.unit_categories.CS_swat_R870 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_swat_2/ene_swat_2")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_swat_r870/ene_akan_cs_swat_r870")
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_swat_hvh_2/ene_swat_hvh_2")
			},
			murkywater = {
				Idstring("units/pd2_mod_sharks/characters/ene_swat_2/ene_swat_2")
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_r870/ene_swat_policia_federale_r870")
			},
			nypd = {
				Idstring("units/pd2_mod_nypd/characters/ene_nypd_swat_2/ene_nypd_swat_2")
			},
			lapd = {
				Idstring("units/pd2_mod_lapd/characters/ene_swat_2/ene_swat_2")
			},
			omnia_skm = {
				Idstring("units/pd2_mod_sharks/characters/ene_swat_2/ene_swat_2")
			}
		},
		access = access_type_all
	}

	self.unit_categories.CS_heavy_M4 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_ak47_ass/ene_akan_cs_heavy_ak47_ass")
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1")
			},
			murkywater = {
				Idstring("units/pd2_mod_sharks/characters/ene_swat_heavy_1/ene_swat_heavy_1")
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale")
			},
			nypd = {
				Idstring("units/pd2_mod_nypd/characters/ene_nypd_heavy_m4/ene_nypd_heavy_m4")
			},
			lapd = {
				Idstring("units/pd2_mod_lapd/characters/ene_swat_heavy_1/ene_swat_heavy_1")
			},
			omnia_skm = {
				Idstring("units/pd2_mod_sharks/characters/ene_swat_heavy_1/ene_swat_heavy_1")
			}
		},
		access = access_type_all
	}

	self.unit_categories.CS_heavy_R870 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_r870/ene_akan_cs_heavy_r870")
			},
			zombie = {
				Idstring("units/pd2_mod_halloween/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc")
			},
			murkywater = {
				Idstring("units/pd2_mod_sharks/characters/ene_swat_heavy_r870/ene_swat_heavy_r870")
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_r870/ene_swat_heavy_policia_federale_r870")
			},
			nypd = {
				Idstring("units/pd2_mod_nypd/characters/ene_nypd_heavy_r870/ene_nypd_heavy_r870")
			},
			lapd = {
				Idstring("units/pd2_mod_lapd/characters/ene_swat_heavy_r870/ene_swat_heavy_r870")
			},
			omnia_skm = {
				Idstring("units/pd2_mod_sharks/characters/ene_swat_heavy_r870/ene_swat_heavy_r870")
			}
		},
		access = access_type_all
	}

	self.unit_categories.CS_heavy_M4_w = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_heavy_ak47_ass/ene_akan_cs_heavy_ak47_ass")
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1")
			},
			murkywater = {
				Idstring("units/pd2_mod_sharks/characters/ene_swat_heavy_1/ene_swat_heavy_1")
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale/ene_swat_heavy_policia_federale")
			},
			nypd = {
				Idstring("units/pd2_mod_nypd/characters/ene_nypd_heavy_m4/ene_nypd_heavy_m4")
			},
			lapd = {
				Idstring("units/pd2_mod_lapd/characters/ene_swat_heavy_1/ene_swat_heavy_1")
			},
			omnia_skm = {
				Idstring("units/pd2_mod_sharks/characters/ene_swat_heavy_1/ene_swat_heavy_1")
			}
		},
		access = access_type_all
	}

	if difficulty_index <= 7 then
		self.unit_categories.CS_tazer = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_tazer_ak47_ass/ene_akan_cs_tazer_ak47_ass")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_tazer_hvh_1/ene_tazer_hvh_1")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_murky_tazer/ene_murky_tazer")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_tazer_policia_federale/ene_swat_tazer_policia_federale")
				},
				nypd = {
					Idstring("units/pd2_mod_nypd/characters/ene_tazer_1/ene_tazer_1")
				},
				lapd = {
					Idstring("units/payday2/characters/ene_tazer_1/ene_tazer_1")
				},
				omnia_skm = {
					Idstring("units/pd2_mod_omnia/characters/ene_omnia_taser/ene_omnia_taser")
				}
			},
			access = access_type_all,
			special_type = "taser"
		}
	else --Upgrade some to OMNIA/ZEAL on DS.
		self.unit_categories.CS_tazer = {
			unit_types = {
				america = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_tazer_ak47_ass/ene_akan_cs_tazer_ak47_ass")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_zeal_tazer/ene_zeal_tazer")
				},
				murkywater = {
					Idstring("units/pd2_mod_omnia/characters/ene_omnia_taser/ene_omnia_taser")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_tazer_policia_federale/ene_swat_tazer_policia_federale")
				},
				nypd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer")
				},
				lapd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer")
				},
				omnia_skm = {
					Idstring("units/pd2_mod_omnia/characters/ene_omnia_taser/ene_omnia_taser")
				}
			},
			access = access_type_all,
			special_type = "taser"
		}
	end

	self.unit_categories.Titan_taser = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_vip/characters/ene_titan_taser/ene_titan_taser")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_titan_taser/ene_titan_taser")
			},
			zombie = {
				Idstring("units/pd2_mod_halloween/characters/ene_titan_taser/ene_titan_taser")
			},
			murkywater = {
				Idstring("units/pd2_dlc_vip/characters/ene_titan_taser/ene_titan_taser")
			},
			federales = {
				Idstring("units/pd2_dlc_vip/characters/ene_titan_taser/ene_titan_taser")
			},
			nypd = {
				Idstring("units/pd2_dlc_vip/characters/ene_titan_taser/ene_titan_taser")
			},
			lapd = {
				Idstring("units/pd2_dlc_vip/characters/ene_titan_taser/ene_titan_taser")
			},
			omnia_skm = {
				Idstring("units/pd2_dlc_vip/characters/ene_titan_taser/ene_titan_taser")
			}
		},
		access = access_type_all,
		special_type = "taser_titan"
	}

	self.unit_categories.CS_shield = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_shield_2/ene_shield_2")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_akan_cs_shield_c45/ene_akan_cs_shield_c45")
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_shield_hvh_2/ene_shield_hvh_2")
			},
			murkywater = {
				Idstring("units/pd2_mod_sharks/characters/ene_murky_shield_yellow/ene_murky_shield_yellow")
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_c45/ene_swat_shield_policia_federale_c45")
			},
			nypd = {
				Idstring("units/pd2_mod_nypd/characters/ene_nypd_shield/ene_nypd_shield")
			},
			lapd = {
				Idstring("units/pd2_mod_lapd/characters/ene_shield_2/ene_shield_2")
			},
			omnia_skm = {
				Idstring("units/pd2_mod_sharks/characters/ene_murky_shield_yellow/ene_murky_shield_yellow")
			}
		},
		access = access_type_all,
		special_type = "shield"
	}

	if difficulty_index <= 7 then
		self.unit_categories.FBI_suit_C45 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")					
				},
				russia = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				federales = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				nypd = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				lapd = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				omnia_skm = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				}
			},
			access = access_type_all
		}
	else 
		self.unit_categories.FBI_suit_C45 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				russia = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				federales = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				nypd = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				},
				lapd = {
					Idstring("units/payday2/characters/ene_fbi_1/ene_fbi_1"),
					Idstring("units/payday2/characters/ene_fbi_2/ene_fbi_2"),
					Idstring("units/payday2/characters/ene_fbi_3/ene_fbi_3")
				}
			},
			access = access_type_all
		}
	end

	self.unit_categories.FBI_suit_C45_M4 = self.unit_categories.FBI_suit_C45
	self.unit_categories.FBI_suit_M4_MP5 = self.unit_categories.FBI_suit_C45
	self.unit_categories.FBI_suit_stealth_MP5 = self.unit_categories.FBI_suit_C45
			

	self.unit_categories.FBI_swat_M4 = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass")
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1")
			},
			murkywater = {
				Idstring("units/pd2_mod_sharks/characters/ene_fbi_swat_1/ene_fbi_swat_1")
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi/ene_swat_policia_federale_fbi")
			},
			nypd = {
				Idstring("units/pd2_mod_nypd/characters/ene_fbi_swat_1/ene_fbi_swat_1")
			},
			lapd = {
				Idstring("units/pd2_mod_lapd/characters/ene_fbi_swat_1/ene_fbi_swat_1")
			}
		},
		access = access_type_all
	}

	--GenSec SWATs (rifle)
	if difficulty_index <= 7 then
		self.unit_categories.GS_swat_M4 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_city_swat_1_sc/ene_city_swat_1_sc")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ak47_ass_sc/ene_akan_fbi_swat_dw_ak47_ass_sc")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_city_swat_1/ene_city_swat_1")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_city_swat_1/ene_city_swat_1")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city/ene_swat_policia_federale_city")
				},
				nypd = {
					Idstring("units/payday2/characters/ene_city_swat_1_sc/ene_city_swat_1_sc")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_city_swat_1/ene_city_swat_1")
				}
			},
			access = access_type_all
		}
	else --Upgrade some to OMNIA/ZEAL on DS.
		self.unit_categories.GS_swat_M4 = {
			unit_types = {
				america = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ak47_ass_sc/ene_akan_fbi_swat_dw_ak47_ass_sc")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_zeal_city_1/ene_zeal_city_1")
				},
				murkywater = {
					Idstring("units/pd2_mod_omnia/characters/ene_omnia_city/ene_omnia_city")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_zeal/ene_swat_policia_federale_zeal")
				},
				nypd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1")
				},
				lapd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1")
				}
			},
			access = access_type_all
		}
	end

	--Bravo Support Lights
	self.unit_categories.Bravo_rifle_swat = {
		unit_types = {
			america = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_rifle/ene_bravo_rifle")		
			},
			russia = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_rifle_ru/ene_bravo_rifle_ru")		
			},
			zombie = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_rifle/ene_bravo_rifle")
			},						
			murkywater = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_rifle_murky/ene_bravo_rifle_murky")		
			},
			federales = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_rifle_mex/ene_bravo_rifle_mex")		
			},					
			nypd = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_rifle/ene_bravo_rifle")
			},	
			lapd = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_rifle/ene_bravo_rifle")
			}					
		},
		access = access_type_all
	}	

	self.unit_categories.Bravo_lmg_swat = {
		unit_types = {
			america = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_lmg/ene_bravo_lmg")				
			},
			russia = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_lmg_ru/ene_bravo_lmg_ru")				
			},
			zombie = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_lmg/ene_bravo_lmg")	
			},						
			murkywater = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_lmg_murky/ene_bravo_lmg_murky")				
			},
			federales = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_lmg_mex/ene_bravo_lmg_mex"),				
			},					
			nypd = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_lmg/ene_bravo_lmg")	
			},	
			lapd = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_lmg/ene_bravo_lmg")	
			}					
		},
		access = access_type_all
	}

	--FBI Shotgunners/SMG Units
	if difficulty_index <= 4 then
		self.unit_categories.FBI_swat_R870 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
					Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ump/ene_akan_fbi_swat_ump")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2"),
					Idstring("units/pd2_mod_halloween/characters/ene_fbi_swat_3/ene_fbi_swat_3")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
					Idstring("units/pd2_mod_sharks/characters/ene_fbi_swat_3/ene_fbi_swat_3")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_ump/ene_swat_policia_federale_fbi_ump")
				},
				nypd = {
					Idstring("units/pd2_mod_nypd/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
					Idstring("units/pd2_mod_nypd/characters/ene_fbi_swat_3/ene_fbi_swat_3")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
					Idstring("units/pd2_mod_lapd/characters/ene_fbi_swat_3/ene_fbi_swat_3")
				}
			},
			access = access_type_all
		}
	elseif difficulty_index == 5 then
		self.unit_categories.FBI_swat_R870 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
					Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ump/ene_akan_fbi_swat_ump")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2"),
					Idstring("units/pd2_mod_halloween/characters/ene_fbi_swat_3/ene_fbi_swat_3")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
					Idstring("units/pd2_mod_sharks/characters/ene_fbi_swat_3/ene_fbi_swat_3")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_ump/ene_swat_policia_federale_fbi_ump")
				},
				nypd = {
					Idstring("units/pd2_mod_nypd/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
					Idstring("units/pd2_mod_nypd/characters/ene_fbi_swat_3/ene_fbi_swat_3")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
					Idstring("units/pd2_mod_lapd/characters/ene_fbi_swat_3/ene_fbi_swat_3")
				}
			},
			access = access_type_all
		}
	else
		self.unit_categories.FBI_swat_R870 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
					Idstring("units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ump/ene_akan_fbi_swat_ump")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2"),
					Idstring("units/pd2_mod_halloween/characters/ene_fbi_swat_3/ene_fbi_swat_3")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
					Idstring("units/pd2_mod_sharks/characters/ene_fbi_swat_3/ene_fbi_swat_3")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_ump/ene_swat_policia_federale_fbi_ump")
				},
				nypd = {
					Idstring("units/pd2_mod_nypd/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
					Idstring("units/pd2_mod_nypd/characters/ene_fbi_swat_3/ene_fbi_swat_3")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
					Idstring("units/pd2_mod_lapd/characters/ene_fbi_swat_3/ene_fbi_swat_3")
				}
			},
			access = access_type_all
		}
	end

	self.unit_categories.Bravo_shotgun_swat = {
		unit_types = {
			america = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_shotgun/ene_bravo_shotgun")			
			},
			russia = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_shotgun_ru/ene_bravo_shotgun_ru")
			},
			zombie = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_shotgun/ene_bravo_shotgun")
			},						
			murkywater = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_shotgun_murky/ene_bravo_shotgun_murky")
			},
			federales = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_shotgun_mex/ene_bravo_shotgun_mex")	
			},					
			nypd = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_shotgun/ene_bravo_shotgun")
			},
			lapd = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_shotgun/ene_bravo_shotgun")
			}					
		},
		access = access_type_all
	}	

	--GenSec Shotgunners/SMG units
	if difficulty_index <= 6 then
		self.unit_categories.GS_swat_R870 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
					Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ump/ene_akan_fbi_swat_dw_ump")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2"),
					Idstring("units/pd2_mod_halloween/characters/ene_city_swat_3/ene_city_swat_3")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
					Idstring("units/pd2_mod_sharks/characters/ene_city_swat_3/ene_city_swat_3")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi_r870/ene_swat_policia_federale_fbi_r870"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_ump/ene_swat_policia_federale_city_ump")
				},
				nypd = {
					Idstring("units/pd2_mod_nypd/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
					Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_fbi_swat_2/ene_fbi_swat_2"),
					Idstring("units/pd2_mod_lapd/characters/ene_city_swat_3/ene_city_swat_3")
				}
			},
			access = access_type_all
		}
	elseif difficulty_index == 7 then
		self.unit_categories.GS_swat_R870 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"),
					Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_r870_sc/ene_akan_fbi_swat_dw_r870_sc"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ump/ene_akan_fbi_swat_dw_ump")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_city_swat_2/ene_city_swat_2"),
					Idstring("units/pd2_mod_halloween/characters/ene_city_swat_3/ene_city_swat_3")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_city_swat_2/ene_city_swat_2"),
					Idstring("units/pd2_mod_sharks/characters/ene_city_swat_3/ene_city_swat_3")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_r870/ene_swat_policia_federale_city_r870"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_ump/ene_swat_policia_federale_city_ump")
				},
				nypd = {
					Idstring("units/payday2/characters/ene_city_swat_2/ene_city_swat_2"),
					Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_city_swat_2/ene_city_swat_2"),
					Idstring("units/pd2_mod_lapd/characters/ene_city_swat_3/ene_city_swat_3")
				}
			},
			access = access_type_all
		}
	else
		self.unit_categories.GS_swat_R870 = {
			unit_types = {
				america = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_city_2/ene_zeal_city_2"),
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_city_3/ene_zeal_city_3")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_r870_sc/ene_akan_fbi_swat_dw_r870_sc"),
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ump/ene_akan_fbi_swat_dw_ump")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_zeal_city_2/ene_zeal_city_2"),
					Idstring("units/pd2_mod_halloween/characters/ene_zeal_city_3/ene_zeal_city_3")
				},
				murkywater = {
					Idstring("units/pd2_mod_omnia/characters/ene_omnia_city_2/ene_omnia_city_2"),
					Idstring("units/pd2_mod_omnia/characters/ene_omnia_city_3/ene_omnia_city_3")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_zeal_r870/ene_swat_policia_federale_zeal_r870"),
					Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_zeal_ump/ene_swat_policia_federale_zeal_ump")
				},
				nypd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_city_2/ene_zeal_city_2"),
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_city_3/ene_zeal_city_3")
				},
				lapd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_city_2/ene_zeal_city_2"),
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_city_3/ene_zeal_city_3")
				}
			},
			access = access_type_all
		}
	end

	--FBI Heavies (Rifle)
	if difficulty_index <= 6 then
		self.unit_categories.FBI_heavy_G36 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_fbi_heavy_1/ene_fbi_heavy_1")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_g36/ene_swat_heavy_policia_federale_fbi_g36")
				},
				nypd = {
					Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1")
				},
				lapd = {
					Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1")
				}
			},
			access = access_type_all
		}
	elseif difficulty_index == 7 then
		self.unit_categories.FBI_heavy_G36 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw/ene_akan_fbi_heavy_dw")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_city_heavy_g36/ene_city_heavy_g36")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_fbi_heavy_1/ene_fbi_heavy_1")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_city_g36/ene_swat_heavy_policia_federale_city_g36")
				},
				nypd = {
					Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_city_heavy_g36/ene_city_heavy_g36")
				}
			},
			access = access_type_all
		}
	else
		self.unit_categories.FBI_heavy_G36 = {
			unit_types = {
				america = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw/ene_akan_fbi_heavy_dw")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc")
				},
				murkywater = {
					Idstring("units/pd2_mod_omnia/characters/ene_omnia_heavy/ene_omnia_heavy")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_zeal_g36/ene_swat_heavy_policia_federale_zeal_g36")
				},
				nypd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc")
				},
				lapd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc")
				}
			},
			access = access_type_all
		}
	end

	if difficulty_index <= 6 then
		self.unit_categories.FBI_heavy_R870 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_r870/ene_akan_fbi_heavy_r870")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_r870/ene_swat_heavy_policia_federale_fbi_r870")
				},
				nypd = {
					Idstring("units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc")
				}
			},
			access = access_type_all
		}
	elseif difficulty_index == 7 then
		self.unit_categories.FBI_heavy_R870 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw_r870/ene_akan_fbi_heavy_dw_r870")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_city_r870/ene_swat_heavy_policia_federale_city_r870")
				},
				nypd = {
					Idstring("units/payday2/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc")
				}
			},
			access = access_type_all
		}
	else
		self.unit_categories.FBI_heavy_R870 = {
			unit_types = {
				america = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_r870_sc/ene_zeal_swat_heavy_r870_sc")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw_r870/ene_akan_fbi_heavy_dw_r870")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_zeal_swat_heavy_r870_sc/ene_zeal_swat_heavy_r870_sc")
				},
				murkywater = {
					Idstring("units/pd2_mod_omnia/characters/ene_omnia_heavy_r870/ene_omnia_heavy_r870")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_zeal_r870/ene_swat_heavy_policia_federale_zeal_r870")
				},
				nypd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_r870_sc/ene_zeal_swat_heavy_r870_sc")
				},
				lapd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_r870_sc/ene_zeal_swat_heavy_r870_sc")
				}
			},
			access = access_type_all
		}
	end

	self.unit_categories.marshal_marksman = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_usm1/characters/ene_male_marshal_marksman_1/ene_male_marshal_marksman_1")
			},
			russia = {
				Idstring("units/pd2_dlc_usm1/characters/ene_male_marshal_marksman_2/ene_male_marshal_marksman_2")
			},
			zombie = {
				Idstring("units/pd2_dlc_usm1/characters/ene_male_marshal_marksman_2/ene_male_marshal_marksman_2")
			},
			murkywater = {
				Idstring("units/pd2_dlc_usm1/characters/ene_male_marshal_marksman_2/ene_male_marshal_marksman_2")
			},
			federales = {
				Idstring("units/pd2_dlc_usm1/characters/ene_male_marshal_marksman_2/ene_male_marshal_marksman_2")
			},
			nypd = {
				Idstring("units/pd2_dlc_usm1/characters/ene_male_marshal_marksman_1/ene_male_marshal_marksman_1")
			},
			lapd = {
				Idstring("units/pd2_dlc_usm1/characters/ene_male_marshal_marksman_1/ene_male_marshal_marksman_1")
			}
		},
		access = access_type_all
	}

	self.unit_categories.marshal_marksman_boss = deep_clone(self.unit_categories.marshal_marksman)
	self.unit_categories.marshal_marksman_boss.ignore_spawn_cap = true

	self.unit_categories.Bravo_sharpshooter = {
		unit_types = {
			america = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_dmr/ene_bravo_dmr")				
			},
			russia = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_dmr_ru/ene_bravo_dmr_ru")				
			},
			zombie = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_dmr/ene_bravo_dmr")					
			},							
			murkywater = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_dmr_murky/ene_bravo_dmr_murky")						
			},
			federales = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_dmr_mex/ene_bravo_dmr_mex")				
			},						
			nypd = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_dmr/ene_bravo_dmr")	
			},	
			lapd = {
				Idstring("units/pd2_mod_bravo/characters/ene_bravo_dmr/ene_bravo_dmr")	
			}					
		},
		access = access_type_all
	}

	--FBI Heavy (Rifle, Walk only)
	if difficulty_index <= 6 then
		self.unit_categories.FBI_heavy_G36_w = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_fbi_heavy_1/ene_fbi_heavy_1")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_fbi_g36/ene_swat_heavy_policia_federale_fbi_g36")
				},
				nypd = {
					Idstring("units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_fbi_heavy_1/ene_fbi_heavy_1")
				}
			},
			access = access_type_all
		}
	elseif difficulty_index == 7 then
		self.unit_categories.FBI_heavy_G36_w = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw/ene_akan_fbi_heavy_dw")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_city_heavy_g36/ene_city_heavy_g36")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_fbi_heavy_1/ene_fbi_heavy_1")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_city_g36/ene_swat_heavy_policia_federale_city_g36")
				},
				nypd = {
					Idstring("units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_city_heavy_g36/ene_city_heavy_g36")
				}
			},
			access = access_type_all
		}
	else
		self.unit_categories.FBI_heavy_G36_w = {
			unit_types = {
				america = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw/ene_akan_fbi_heavy_dw")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc")
				},
				murkywater = {
					Idstring("units/pd2_mod_omnia/characters/ene_omnia_heavy/ene_omnia_heavy")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_heavy_policia_federale_zeal_g36/ene_swat_heavy_policia_federale_zeal_g36")
				},
				nypd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc")
				},
				lapd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc")
				}
			},
			access = access_type_all
		}
	end

	if difficulty_index <= 4 then
		self.unit_categories.FBI_shield = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_shield_1/ene_shield_1")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_sr2_smg/ene_akan_fbi_shield_sr2_smg")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_murky_shield_fbi/ene_murky_shield_fbi")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9_fbi/ene_swat_shield_policia_federale_mp9_fbi")
				},
				nypd = {
					Idstring("units/pd2_mod_nypd/characters/ene_shield_1/ene_shield_1")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_shield_1/ene_shield_1")
				}
			},
			access = access_type_all,
			special_type = "shield"
		}
	elseif difficulty_index == 5 then
		self.unit_categories.FBI_shield = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_shield_1/ene_shield_1")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_sr2_smg/ene_akan_fbi_shield_sr2_smg")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_murky_shield_fbi/ene_murky_shield_fbi")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9_fbi/ene_swat_shield_policia_federale_mp9_fbi")
				},
				nypd = {
					Idstring("units/pd2_mod_nypd/characters/ene_shield_1/ene_shield_1")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_shield_1/ene_shield_1")
				}
			},
			access = access_type_all,
			special_type = "shield"
		}
	elseif difficulty_index == 6 then
		self.unit_categories.FBI_shield = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_shield_1/ene_shield_1")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_sr2_smg/ene_akan_fbi_shield_sr2_smg")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_murky_shield_fbi/ene_murky_shield_fbi")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9_fbi/ene_swat_shield_policia_federale_mp9_fbi")
				},
				nypd = {
					Idstring("units/pd2_mod_nypd/characters/ene_shield_1/ene_shield_1")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_shield_1/ene_shield_1")
				}
			},
			access = access_type_all,
			special_type = "shield"
		}
	elseif difficulty_index == 7 then
		self.unit_categories.FBI_shield = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_shield_gensec/ene_shield_gensec")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_dw_sr2_smg/ene_akan_fbi_shield_dw_sr2_smg")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_shield_gensec/ene_shield_gensec")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_murky_shield_fbi/ene_murky_shield_fbi")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9_sc/ene_swat_shield_policia_federale_mp9_sc")
				},
				nypd = {
					Idstring("units/payday2/characters/ene_shield_gensec/ene_shield_gensec")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_city_shield/ene_city_shield")
				}
			},
			access = access_type_all,
			special_type = "shield"
		}
	else
		self.unit_categories.FBI_shield = {
			unit_types = {
				america = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_shield_dw_sr2_smg/ene_akan_fbi_shield_dw_sr2_smg")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_zeal_swat_shield/ene_zeal_swat_shield")
				},
				murkywater = {
					Idstring("units/pd2_mod_omnia/characters/ene_omnia_shield/ene_omnia_shield")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_shield_policia_federale_mp9_zeal/ene_swat_shield_policia_federale_mp9_zeal")
				},
				nypd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield")
				},
				lapd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield")
				}
			},
			access = access_type_all,
			special_type = "shield"
		}
	end

	--Titan Shield
	self.unit_categories.Titan_shield = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1_assault/ene_phalanx_1_assault")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_phalanx_1_assault/ene_phalanx_1_assault")
			},
			zombie = {
				Idstring("units/pd2_mod_halloween/characters/ene_phalanx_1_assault/ene_phalanx_1_assault")
			},
			murkywater = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1_assault/ene_phalanx_1_assault")
			},
			federales = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1_assault/ene_phalanx_1_assault")
			},
			nypd = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1_assault/ene_phalanx_1_assault")
			},
			lapd = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1_assault/ene_phalanx_1_assault")
			}
		},
		access = access_type_all,
		special_type = "shield_titan"
	}

	if difficulty_index <= 7 then
		self.unit_categories.FBI_tank = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_murky_fbi_tank_r870/ene_murky_fbi_tank_r870")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870")
				},
				nypd = {
					Idstring("units/pd2_mod_nypd/characters/ene_bulldozer_1/ene_bulldozer_1")
				},
				lapd = {
					Idstring("units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1")
				}
			},
			access = access_type_all,
			special_type = "tank"
		}
	else --Upgrade some to OMNIA/ZEAL on DS.
		self.unit_categories.FBI_tank = {
			unit_types = {
				america = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2")
				},
				murkywater = {
					Idstring("units/pd2_mod_omnia/characters/ene_bulldozer_1/ene_bulldozer_1")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870")
				},
				nypd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2")
				},
				lapd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2")
				}
			},
			access = access_type_all,
			special_type = "tank"
		}
	end

	if difficulty_index <= 7 then
		self.unit_categories.BLACK_tank = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_2/ene_bulldozer_hvh_2")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_murky_fbi_tank_saiga/ene_murky_fbi_tank_saiga")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_saiga/ene_swat_dozer_policia_federale_saiga")
				},
				nypd = {
					Idstring("units/pd2_mod_nypd/characters/ene_bulldozer_2/ene_bulldozer_2")
				},
				lapd = {
					Idstring("units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2")
				}
			},
			access = access_type_all,
			special_type = "tank"
		}
	else --Upgrade some to OMNIA/ZEAL on DS.
		self.unit_categories.BLACK_tank = {
			unit_types = {
				america = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3")
				},
				murkywater = {
					Idstring("units/pd2_mod_omnia/characters/ene_bulldozer_2/ene_bulldozer_2")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_saiga/ene_swat_dozer_policia_federale_saiga")
				},
				nypd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3")
				},
				lapd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3")
				}
			},
			access = access_type_all,
			special_type = "tank"
		}
	end

	if difficulty_index <= 7 then
		self.unit_categories.SKULL_tank = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg")
				},
				zombie = {
					Idstring("units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_murky_fbi_tank_m249/ene_murky_fbi_tank_m249")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_m249/ene_swat_dozer_policia_federale_m249")
				},
				nypd = {
					Idstring("units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3")
				},
				lapd = {
					Idstring("units/pd2_mod_lapd/characters/ene_bulldozer_3/ene_bulldozer_3")
				}
			},
			access = access_type_all,
			special_type = "tank"
		}
	else --Upgrade some to OMNIA/ZEAL on DS.
		self.unit_categories.SKULL_tank = {
			unit_types = {
				america = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_zeal_bulldozer/ene_zeal_bulldozer")
				},
				murkywater = {
					Idstring("units/pd2_mod_omnia/characters/ene_bulldozer_3/ene_bulldozer_3")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_m249/ene_swat_dozer_policia_federale_m249")
				},
				nypd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer")
				},
				lapd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer")
				}
			},
			access = access_type_all,
			special_type = "tank"
		}
	end

	self.unit_categories.Titan_tank = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_2_assault/ene_vip_2_assault")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_vip_2/ene_vip_2")
			},
			zombie = {
				Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4")
			},
			murkywater = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_2_assault/ene_vip_2_assault")
			},
			federales = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_2/ene_vip_2_assault")
			},
			nypd = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_2_assault/ene_vip_2_assault")
			},
			lapd = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_2_assault/ene_vip_2_assault")
			}
		},
		access = access_type_all,
		special_type = "tank"
	}

	--April 1st, sucker!
	if Month == "04" and Day == "01" and heat.Options:GetValue("Holiday") then
		self.unit_categories.Titan_tank = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_mememan_1/ene_mememan_1"),
					Idstring("units/payday2/characters/ene_mememan_2/ene_mememan_2")
				},
				russia = {
					Idstring("units/payday2/characters/ene_mememan_1/ene_mememan_1"),
					Idstring("units/payday2/characters/ene_mememan_2/ene_mememan_2")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_mememan_1/ene_mememan_1"),
					Idstring("units/payday2/characters/ene_mememan_2/ene_mememan_2")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_mememan_1/ene_mememan_1"),
					Idstring("units/payday2/characters/ene_mememan_2/ene_mememan_2")
				},
				federales = {
					Idstring("units/payday2/characters/ene_mememan_1/ene_mememan_1"),
					Idstring("units/payday2/characters/ene_mememan_2/ene_mememan_2")
				},
				nypd = {
					Idstring("units/payday2/characters/ene_mememan_1/ene_mememan_1"),
					Idstring("units/payday2/characters/ene_mememan_2/ene_mememan_2")
				},
				lapd = {
					Idstring("units/payday2/characters/ene_mememan_1/ene_mememan_1"),
					Idstring("units/payday2/characters/ene_mememan_2/ene_mememan_2")
				}
			},
			access = access_type_all,
			special_type = "tank"
		}
	end

	if difficulty_index <= 7 then
	    self.unit_categories.boom_M4203 = {
		    unit_types = {
			    america = {
			    	Idstring("units/payday2/characters/ene_grenadier_1/ene_grenadier_1")
			    },
			    russia = {
			    	Idstring("units/pd2_dlc_mad/characters/ene_akan_grenadier_1/ene_akan_grenadier_1")
			    },
			    zombie = {
			    	Idstring("units/pd2_mod_halloween/characters/ene_grenadier_1/ene_grenadier_1")
			    },
			    murkywater = {
			    	Idstring("units/pd2_mod_sharks/characters/ene_grenadier_1/ene_grenadier_1")
			    },
			    federales = {
			    	Idstring("units/pd2_dlc_bex/characters/ene_grenadier_1/ene_grenadier_1")
			    },
			    nypd = {
			    	Idstring("units/payday2/characters/ene_grenadier_1/ene_grenadier_1")
			    },
			    lapd = {
			    	Idstring("units/payday2/characters/ene_grenadier_1/ene_grenadier_1")
			    }
		    },
		    access = access_type_all,
		    special_type = "boom"
	    }
	else --Upgrade some to OMNIA/ZEAL on DS.
	    self.unit_categories.boom_M4203 = {
		    unit_types = {
			    america = {
			    	Idstring("units/pd2_dlc_gitgud/characters/ene_grenadier_1/ene_grenadier_1")
			    },
			    russia = {
			    	Idstring("units/pd2_dlc_mad/characters/ene_akan_grenadier_1/ene_akan_grenadier_1")
			    },
			    zombie = {
			    	Idstring("units/pd2_mod_halloween/characters/ene_grenadier_1/ene_grenadier_1")
			    },
			    murkywater = {
			    	Idstring("units/pd2_mod_omnia/characters/ene_grenadier_1/ene_grenadier_1")
			    },
			    federales = {
			    	Idstring("units/pd2_dlc_bex/characters/ene_grenadier_1/ene_grenadier_1")
			    },
			    nypd = {
			    	Idstring("units/pd2_dlc_gitgud/characters/ene_grenadier_1/ene_grenadier_1")
			    },
			    lapd = {
			    	Idstring("units/pd2_dlc_gitgud/characters/ene_grenadier_1/ene_grenadier_1")
			    }
		    },
		    access = access_type_all,
		    special_type = "boom"
	    }
	end

	if difficulty_index <= 7 then
		self.unit_categories.medic_M4 = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_medic_mp5/ene_medic_mp5")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_medic_bob/ene_akan_medic_bob")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_medic_mp5/ene_medic_mp5")
				},
				murkywater = {
					Idstring("units/pd2_mod_sharks/characters/ene_murky_medic_m4/ene_murky_medic_m4")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale/ene_swat_medic_policia_federale")
				},
				nypd = {
					Idstring("units/pd2_mod_nypd/characters/ene_nypd_medic/ene_nypd_medic")
				},
				lapd = {
					Idstring("units/payday2/characters/ene_medic_mp5/ene_medic_mp5")
				}
			},
			access = access_type_all,
			special_type = "medic"
		}
	else --Upgrade some to OMNIA/ZEAL on DS. Or ZDANN.
		self.unit_categories.medic_M4 = {
			unit_types = {
				america = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic/ene_zeal_medic")
				},
				russia = {
					Idstring("units/pd2_dlc_mad/characters/ene_akan_medic_zdann/ene_akan_medic_zdann")
				},
				zombie = {
					Idstring("units/pd2_mod_halloween/characters/ene_zeal_medic/ene_zeal_medic")
				},
				murkywater = {
					Idstring("units/pd2_mod_omnia/characters/ene_omnia_medic/ene_omnia_medic")
				},
				federales = {
					Idstring("units/pd2_dlc_bex/characters/ene_swat_medic_policia_federale/ene_swat_medic_policia_federale")
				},
				nypd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic/ene_zeal_medic")
				},
				lapd = {
					Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_medic/ene_zeal_medic")
				}
			},
			access = access_type_all,
			special_type = "medic"
		}
	end

	--Medics should only spawn with M4s.
	self.unit_categories.medic_R870 = deep_clone(self.unit_categories.medic_M4)

	--New Winters
	self.unit_categories.Phalanx_vip_new = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_1/ene_vip_1")
			},
			russia = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_1/ene_vip_1")
			},
			zombie = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_1/ene_vip_1")
			},
			murkywater = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_1/ene_vip_1")
			},
			federales = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_1/ene_vip_1")
			},
			nypd = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_1/ene_vip_1")
			},
			lapd = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_1/ene_vip_1")
			}
		},
		max_amount = 1,
		access = access_type_all,
		special_type = "captain"
	}

	--Titan shields that spawn with Winters. Ignores spawn caps.
	self.unit_categories.Phalanx_minion_new = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")
			},
			russia = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")
			},
			zombie = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")
			},
			murkywater = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")
			},
			federales = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")
			},
			nypd = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")
			},
			lapd = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_1/ene_phalanx_1")
			}
		},
		access = access_type_all,
		special_type = "shield",
		ignore_spawn_cap = true
	}

	--Captain Autumn
	self.unit_categories.Cap_Autumn = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_autumn/ene_vip_autumn")
			},
			russia = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_autumn/ene_vip_autumn")
			},
			zombie = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_autumn/ene_vip_autumn")
			},
			murkywater = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_autumn/ene_vip_autumn")
			},
			federales = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_autumn/ene_vip_autumn")
			},
			nypd = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_autumn/ene_vip_autumn")
			},
			lapd = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_autumn/ene_vip_autumn")
			}
		},
		max_amount = 1,
		access = access_type_all,
		special_type = "captain"
	}

	--Cloakers that spawn with Autumn, ignores spawncaps
	self.unit_categories.Spooc_Boss = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_spook_1/ene_spook_1")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg")
			},
			zombie = {
				Idstring("units/pd2_dlc_hvh/characters/ene_spook_hvh_1/ene_spook_hvh_1")
			},
			murkywater = {
				Idstring("units/pd2_mod_sharks/characters/ene_murky_spook/ene_murky_spook")
			},
			federales = {
				Idstring("units/pd2_dlc_bex/characters/ene_swat_cloaker_policia_federale_sc/ene_swat_cloaker_policia_federale_sc")
			},
			nypd = {
				Idstring("units/pd2_mod_nypd/characters/ene_spook_1/ene_spook_1")
			},
			lapd = {
				Idstring("units/payday2/characters/ene_spook_1/ene_spook_1")
			},
			omnia_skm = {
				Idstring("units/pd2_mod_omnia/characters/ene_omnia_spook/ene_omnia_spook")
			}
		},
		access = access_type_all,
		special_type = "spooc",
		ignore_spawn_cap = true
	}

	self.unit_categories.Titan_Spooc_Boss = {
		unit_types = {
			america = {
				Idstring("units/payday2/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			zombie = {
				Idstring("units/payday2/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			murkywater = {
				Idstring("units/payday2/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			federales = {
				Idstring("units/pd2_dlc_mad/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			nypd = {
				Idstring("units/payday2/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			lapd = {
				Idstring("units/payday2/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			}
		},
		access = access_type_all,
		special_type = "spooc",
		ignore_spawn_cap = true
	}
	--Captain Summers
	self.unit_categories.Cap_Summers = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_vip/characters/ene_summers/ene_summers")
			},
			russia = {
				Idstring("units/pd2_dlc_vip/characters/ene_summers/ene_summers")
			},
			zombie = {
				Idstring("units/pd2_dlc_vip/characters/ene_summers/ene_summers")
			},
			murkywater = {
				Idstring("units/pd2_dlc_vip/characters/ene_summers/ene_summers")
			},
			federales = {
				Idstring("units/pd2_dlc_vip/characters/ene_summers/ene_summers")
			},
			nypd = {
				Idstring("units/pd2_dlc_vip/characters/ene_summers/ene_summers")
			},
			lapd = {
				Idstring("units/pd2_dlc_vip/characters/ene_summers/ene_summers")
			}
		},
		max_amount = 1,
		access = access_type_all,
		special_type = "captain"
	}

	--Molly
	self.unit_categories.boom_summers = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_grenadier/ene_phalanx_grenadier")
			},
			russia = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_grenadier/ene_phalanx_grenadier")
			},
			zombie = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_grenadier/ene_phalanx_grenadier")
			},
			murkywater = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_grenadier/ene_phalanx_grenadier")
			},
			federales = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_grenadier/ene_phalanx_grenadier")
			},
			nypd = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_grenadier/ene_phalanx_grenadier")
			},
			lapd = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_grenadier/ene_phalanx_grenadier")
			}
		},
		access = access_type_all
	}

	--Doc
	self.unit_categories.medic_summers = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_medic/ene_phalanx_medic")
			},
			russia = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_medic/ene_phalanx_medic")
			},
			zombie = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_medic/ene_phalanx_medic")
			},
			murkywater = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_medic/ene_phalanx_medic")
			},
			federales = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_medic/ene_phalanx_medic")
			},
			nypd = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_medic/ene_phalanx_medic")
			},
			lapd = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_medic/ene_phalanx_medic")
			}
		},
		access = access_type_all
	}

	--Elektra
	self.unit_categories.taser_summers = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_taser/ene_phalanx_taser")
			},
			russia = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_taser/ene_phalanx_taser")
			},
			zombie = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_taser/ene_phalanx_taser")
			},
			murkywater = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_taser/ene_phalanx_taser")
			},
			federales = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_taser/ene_phalanx_taser")
			},
			nypd = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_taser/ene_phalanx_taser")
			},
			lapd = {
				Idstring("units/pd2_dlc_vip/characters/ene_phalanx_taser/ene_phalanx_taser")
			}
		},
		access = access_type_all
	}

	--Captain Spring
	self.unit_categories.Cap_Spring = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_vip/characters/ene_spring/ene_spring")
			},
			russia = {
				Idstring("units/pd2_dlc_vip/characters/ene_spring/ene_spring")
			},
			zombie = {
				Idstring("units/pd2_dlc_vip/characters/ene_spring/ene_spring")
			},
			murkywater = {
				Idstring("units/pd2_dlc_vip/characters/ene_spring/ene_spring")
			},
			federales = {
				Idstring("units/pd2_dlc_vip/characters/ene_spring/ene_spring")
			},
			nypd = {
				Idstring("units/pd2_dlc_vip/characters/ene_spring/ene_spring")
			},
			lapd = {
				Idstring("units/pd2_dlc_vip/characters/ene_spring/ene_spring")
			},
		},
		max_amount = 1,
		access = access_type_all,
		special_type = "captain"
	}

	--Titan Dozers that specifically spawn with Spring (Ignores Spawncaps)
	self.unit_categories.Tank_Titan = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_2/ene_vip_2")
			},
			zombie = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_2/ene_vip_2")
			},
			russia = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_2/ene_vip_2")
			},
			murkywater = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_2/ene_vip_2")
			},
			federales = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_2/ene_vip_2")
			},
			nypd = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_2/ene_vip_2")
			},
			lapd = {
				Idstring("units/pd2_dlc_vip/characters/ene_vip_2/ene_vip_2")
			}
		},
		access = access_type_all,
		special_type = "tank_titan", 
		ignore_spawn_cap = true
	}

	--titan tasers that spawn with spring
	self.unit_categories.Titan_taser_boss = {
		unit_types = {
			america = {
				Idstring("units/pd2_dlc_vip/characters/ene_titan_taser/ene_titan_taser")
			},
			russia = {
				Idstring("units/pd2_dlc_mad/characters/ene_titan_taser/ene_titan_taser")
			},
			zombie = {
				Idstring("units/pd2_mod_halloween/characters/ene_titan_taser/ene_titan_taser")
			},
			murkywater = {
				Idstring("units/pd2_dlc_vip/characters/ene_titan_taser/ene_titan_taser")
			},
			federales = {
				Idstring("units/pd2_dlc_vip/characters/ene_titan_taser/ene_titan_taser")
			},
			nypd = {
				Idstring("units/pd2_dlc_vip/characters/ene_titan_taser/ene_titan_taser")
			},
			lapd = {
				Idstring("units/pd2_dlc_vip/characters/ene_titan_taser/ene_titan_taser")
			},
			omnia_skm = {
				Idstring("units/pd2_dlc_vip/characters/ene_titan_taser/ene_titan_taser")
			}
		},
		access = access_type_all,
		special_type = "taser_titan",
		ignore_spawn_cap = true
	}

	--Headless Titandozer Boss
	self.unit_categories.HVH_Boss = {
		unit_types = {
			america = {
				Idstring("units/pd2_mod_halloween/characters/ene_headless_hatman/ene_headless_hatman")
			},
			russia = {
				Idstring("units/pd2_mod_halloween/characters/ene_headless_hatman/ene_headless_hatman")
			},
			zombie = {
				Idstring("units/pd2_mod_halloween/characters/ene_headless_hatman/ene_headless_hatman")
			},
			murkywater = {
				Idstring("units/pd2_mod_halloween/characters/ene_headless_hatman/ene_headless_hatman")
			},
			federales = {
				Idstring("units/pd2_mod_halloween/characters/ene_headless_hatman/ene_headless_hatman")
			},
			nypd = {
				Idstring("units/pd2_mod_halloween/characters/ene_headless_hatman/ene_headless_hatman")
			},
			lapd = {
				Idstring("units/pd2_mod_halloween/characters/ene_headless_hatman/ene_headless_hatman")
			},
		},
		max_amount = 1,
		access = access_type_all,
		special_type = "captain"
	}

	--Headless Titandozers that spawn with boss
	if difficulty_index <= 6 then
		self.unit_categories.HVH_Boss_Headless = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw")
				},
				russia = {
					Idstring("units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw")
				},
				federales = {
					Idstring("units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw")
				},
				nypd = {
					Idstring("units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw")
				},
				lapd = {
					Idstring("units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw")
				}
			},
			access = access_type_all,
			special_type = "tank",
			ignore_spawn_cap = true
		}
	else
		self.unit_categories.HVH_Boss_Headless = {
			unit_types = {
				america = {
					Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4")
				},
				zombie = {
					Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4")
				},
				russia = {
					Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4")
				},
				murkywater = {
					Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4")
				},
				federales = {
					Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4")
				},
				nypd = {
					Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4")
				},
				lapd = {
					Idstring("units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4")
				}
			},
			access = access_type_all,
			special_type = "tank",
			ignore_spawn_cap = true
		}
	end

	--Ghost Titancloakers that spawn with boss
	self.unit_categories.HVH_Boss_Spooc = {
		unit_types = {
			america = {
				Idstring("units/pd2_mod_halloween/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			zombie = {
				Idstring("units/pd2_mod_halloween/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			russia = {
				Idstring("units/pd2_mod_halloween/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			murkywater = {
				Idstring("units/pd2_mod_halloween/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			federales = {
				Idstring("units/pd2_mod_halloween/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			nypd = {
				Idstring("units/pd2_mod_halloween/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			},
			lapd = {
				Idstring("units/pd2_mod_halloween/characters/ene_spook_cloak_1/ene_spook_cloak_1")
			}
		},
		access = access_type_all,
		special_type = "spooc",
		ignore_spawn_cap = true
	}
end

function GroupAITweakData:_init_enemy_spawn_groups(difficulty_index)
	--The below summarizes the functions of new or revised tactics in heat.
	--charge
	--unit moves to player position and engages per conventional rules. Primary driver for most units.
	--enemies will go into the room and get into sight of you.
	--ranged_fire
	--unit engages from longer range location with line of sight, but not far away enough to lose effective weapon damage. Will eventually close with player if no LOS is found.
	--elite_ranged_fire
	--Ranged_fire but with a forced retreat if player closer than closer than a certain amount based on their weapon usage range.
	--obstacle
	--Unit attempts to position themselves in neighboring room near entrance closest to player.
	--reloadingretreat
	--if player is visible and unit is reloading, attempt to retreat into cover.
	--hitnrun
	--Approach enemies and engage for a short time, then, back away from the fight. Uses 10m retreat range.
	--Tunnel
	--Unit almost entirely targets one player until down, then moves on to next. Special-oriented.
	--spoocavoidance
	--If enemy aimed at or seen within 20m, they retreat away from the fight.
	--harass
	--Player entering non-combat state (such as task interactions or reloading) become priority target.
	--hunter
	--If a player is not within 15 meters of another player, becomes target. MUST NOT be used with deathguard - will cause crashes.
	--deathguard
	--Camps downed player. MUST NOT be used with Hunter - will cause crashes.
	--shield_cover
	--Unit attempts to place leader between self and player, stays close to leader. Can be employed for non-shield units.
	--legday
	--unit can only move by sprinting
	--lonewolf
	--Unit will copy the leader's objective, but behave separately from the group. Useful for pinch groups and to separate flankers from chargers, but still technically have them be part of the same group.
	--skirmish
	--system function for retreating in holdout mode. MUST be last tactic for all units. Do not touch.
	--flank
	--flank enemies will get around you and try to either, run past you, or to your side, so that you're not facing them. if they are walking, and they're within 15-10 meters, they'll crouch.
	--Haste
	--Unit will always have a cover_wait_time of 0
	self._tactics = {
		--Cloaker tactics, static. Tries to avoid confrontation
		spooc = {
			"hunter",
			"flank",
			"lonewolf",
			"spoocavoidance",
			"smoke_grenade",
			"flash_grenade"
		},
		--Normal/Hard Tactics below
		--Standard Beat Cop, prefers to stay at range unless they spawn with a shotgunner
		CS_cop = {
			"provide_coverfire",
			"provide_support",
			"elite_ranged_fire",
			"groupcsr"
		},
		--Shotgunner variant of Beat Cops, only real difference is they'll charge in
		CS_cop_shotgun = {
			"provide_coverfire",
			"provide_support",
			"charge",
			"groupcsr"
		},
		--Beat Cop, flank variant. Will take control of the squad if they spawn and lead them to flank
		CS_cop_flank = {
			"flank",
			"provide_coverfire",
			"provide_support",
			"ranged_fire",
			"groupcsr"
		},
		--Beat Cop, stealth variant. Prefers hit n run tactics and avoiding the front to prioritize hostages
		CS_cop_stealth = {
			"flank",
			"provide_coverfire",
			"provide_support",
			"hitnrun",
			"grouphrtr"
		},
		--Standard Blue SWAT, upgraded from Beat Cops and will now use smoke grenades.
		CS_swat_rifle = {
			"smoke_grenade",
			"provide_coverfire",
			"provide_support",
			"ranged_fire",
			"deathguard",
			"groupcsr"
		},
		--SWAT shotgunner, will lead charges with his squad
		CS_swat_shotgun = {
			"smoke_grenade",
			"charge",
			"provide_coverfire",
			"provide_support",
			"deathguard",
			"groupcsr"
		},
		--Blue SWAT, flank variant. Will take control and flank with his squad
		CS_swat_rifle_flank = {
			"flank",
			"smoke_grenade",
			"provide_coverfire",
			"provide_support",
			"ranged_fire",
			"charge",
			"deathguard",
			"groupcsr"
		},
		--Heavy SWAT, act similar to Blue SWATs.
		CS_swat_heavy = {
			"smoke_grenade",
			"provide_coverfire",
			"provide_support",
			"ranged_fire",
			"deathguard",
			"groupcsr"
		},
		--Heavy SWAT Shotgunner. Leads charges
		CS_swat_heavy_shotgun = {
			"smoke_grenade",
			"charge",
			"provide_coverfire",
			"provide_support",
			"deathguard",
			"groupcsr"
		},
		--Heavy SWAT flanker, leads flank maneuvers.
		CS_swat_heavy_flank = {
			"flank",
			"smoke_grenade",
			"provide_coverfire",
			"provide_support",
			"ranged_fire",
			"charge",
			"deathguard",
			"groupcsr"
		},
		--Standard SWAT Shield, will charge forward against player positions
		CS_shield = {
			"charge",
			"provide_coverfire",
			"provide_support",
			"shield",
			"deathguard"
		},
		--Back up ranged units to Shields. Will prefer to stay behind the shield and give fire support at range
		CS_shield_ranged_support = {
			"ranged_fire",
			"provide_coverfire",
			"provide_support",
			"shield_cover",
			"deathguard"
		},
		--Tazer, flank around and charge to take down players one at a time.
		CS_tazer = {
			"flank",
			"charge",
			"smoke_grenade",
			"shield_cover",
			"murder",
			"tunnel",
			"hunter"
		},
		--Ranged backup for Tazers
		CS_tazer_ranged_support = {
			"flank",
			"charge",
			"smoke_grenade",
			"provide_coverfire",
			"provide_support",
			"ranged_fire"
		},
		--Greendozers on Normal/Hard, will try to flank the player
		CS_tank = {
			"flank",
			"reloadingretreat",
			"murder",
			"tunnel",
			"harass",
			"hitnrun",
			"provide_coverfire",
			"provide_support",
			"shield"
		},
		--Beat Cop/Blue SWAT/Heavy SWAT defend. Used for reinforce groups
		CS_defend = {
			"flank",
			"elite_ranged_fire",
			"provide_support"
		},
		--FBI tier stuff below. Very Hard/Overkill mainly
		--FBI HRT tactics, for when participating in assaults
		FBI_suit_stealth = {
			"flank",
			"hunter",
			"reloadingretreat",
			"provide_coverfire",
			"provide_support",
			"flash_grenade",
			"hitnrun",
			"elite_ranged_fire",
			"grouphrtr"
		},
		--FBI Rifle SWATs, can now use flash grenades
		FBI_swat_rifle = {
			"smoke_grenade",
			"flash_grenade",
			"provide_coverfire",
			"provide_support",
			"ranged_fire",
			"deathguard",
			"groupcsr"
		},
		--FBI Shotgun SWATs, leads charges
		FBI_swat_shotgun = {
			"smoke_grenade",
			"flash_grenade",
			"charge",
			"provide_coverfire",
			"provide_support",
			"deathguard",
			"groupcsr",
			"haste"
		},
		--FBI Rifle SWATs, flank the player
		FBI_swat_rifle_flank = {
			"flank",
			"smoke_grenade",
			"flash_grenade",
			"ranged_fire",
			"charge",
			"provide_coverfire",
			"provide_support",
			"deathguard",
			"groupcsr"
		},
		--FBI Heavy, now with flash grenades
		FBI_heavy = {
			"smoke_grenade",
			"flash_grenade",
			"provide_coverfire",
			"provide_support",
			"ranged_fire",
			"deathguard",
			"groupcsr"
		},
		--FBI Heavy Shotgun, leads charges
		FBI_heavy_shotgun = {
			"smoke_grenade",
			"flash_grenade",
			"charge",
			"provide_coverfire",
			"provide_support",
			"deathguard",
			"groupcsr"
		},
		--FBI Heavy, flanker
		FBI_heavy_flank = {
			"flank",
			"smoke_grenade",
			"flash_grenade",
			"provide_coverfire",
			"provide_support",
			"ranged_fire",
			"charge",
			"deathguard",
			"groupcsr"
		},
		--FBI Shield, basically the same as the CS shield.
		FBI_shield = {
			"charge",
			"provide_coverfire",
			"provide_support",
			"shield",
			"deathguard"
		},
		--FBI shield backup units, passive. Now use support grenades
		FBI_shield_ranged_support = {
			"ranged_fire",
			"smoke_grenade",
			"flash_grenade",
			"provide_coverfire",
			"provide_support",
			"shield_cover",
			"deathguard"
		},
		--FBI Shield, passive. Covers whoever they spawned with
		FBI_shield_flank = {
			"flank",
			"ranged_fire",
			"provide_coverfire",
			"provide_support",
			"shield"
		},
		--Grenadier, passive. Tries to hide behind shields/other units when possible
		FBI_Boom = {
			"harass",
			"elite_ranged_fire",
			"provide_coverfire",
			"flash_grenade",
			"smoke_grenade",
			"shield_cover",
			"deathguard"
		},
		--Ranged backup for Tazers
		FBI_boom_ranged_support = {
			"flank",
			"smoke_grenade",
			"provide_coverfire",
			"provide_support",
			"ranged_fire"
		},
		--Medics, passive. Avoids confrontations.
		FBI_medic = {
			"provide_coverfire",
			"hitnrun",
			"reloadingretreat",
			"elite_ranged_fire",
			"shield_cover"
		},
		--Flank Medic tactics, avoid confrontations and flanks. Hugs squad leader
		--Reinforce groups
		FBI_defend = {
			"flank",
			"elite_ranged_fire",
			"provide_support",
			"reloadingretreat"
		},
		--Greendozer on FBI tier and above, hitnrun tactics and flank a lot
		GREEN_tank = {
			"flank",
			"reloadingretreat",
			"murder",
			"tunnel",
			"harass",
			"hitnrun",
			"provide_coverfire",
			"provide_support",
			"shield"
		},
		--Blackdozers, hyper aggressive and unload on the player.
		BLACK_tank = {
			"murder",
			"tunnel",
			"charge",
			"harass",
			"shield",
			"haste"
		},
		--Mayhem tactics below
		--Mayhem rifle SWAT
		MH_swat_rifle = {
			"elite_ranged_fire",
			"smoke_grenade",
			"flash_grenade",
			"provide_coverfire",
			"provide_support",
			"deathguard",
			"groupcsr"
		},
		--Mayhem SWAT Shotgunners, leads charges
		MH_swat_shotgun = {
			"smoke_grenade",
			"flash_grenade",
			"charge",
			"provide_coverfire",
			"provide_support",
			"deathguard",
			"groupcsr",
			"haste"
		},
		--Mayhem SWAT Flankers, will disengage when targeted
		MH_swat_rifle_flank = {
			"flank",
			"charge",
			"smoke_grenade",
			"flash_grenade",
			"ranged_fire",
			"provide_coverfire",
			"provide_support",
			"deathguard",
			"groupcsr"
		},
		--Mayhem Heavy
		MH_heavy = {
			"elite_ranged_fire",
			"smoke_grenade",
			"flash_grenade",
			"provide_coverfire",
			"provide_support",
			"deathguard",
			"groupcsr"
		},
		--Mayhem Heavy Flank, disengage when targeted
		MH_heavy_flank = {
			"flank",
			"charge",
			"smoke_grenade",
			"flash_grenade",
			"ranged_fire",
			"provide_coverfire",
			"provide_support",
			"deathguard",
			"groupcsr"
		},
		--Mayhem Shield, now moves much faster into position
		MH_shield = {
			"legday",
			"charge",
			"ranged_fire",
			"provide_coverfire",
			"provide_support",
			"shield",
			"deathguard"
		},
		--Passive MH Shield
		MH_shield_flank = {
			"legday",
			"flank",
			"ranged_fire",
			"provide_coverfire",
			"provide_support",
			"shield",
			"deathguard"
		},
		--Mayhem shield backup units, passive. Now have legday to keep up
		MH_shield_ranged_support = {
			"legday",
			"ranged_fire",
			"smoke_grenade",
			"flash_grenade",
			"provide_coverfire",
			"provide_support",
			"shield_cover",
			"deathguard"
		},
		--Deathwish Tactics below
		--hunter hrt tactics
		HRT_attack = { --sneaks up and targets players in bad positions
			"flank",
			"hunter",
			"harass",
			"provide_coverfire",
			"provide_support",
			"smoke_grenade",
			"flash_grenade",
			"hitnrun",
			"grouphrtr",
			"haste"
		},
		--slightly more passive than the other dozers will stand his ground if charged
		SKULL_tank = {
			"reloadingretreat",
			"ranged_fire",
			"murder",
			"tunnel",
			"harass",
			"shield"
		},
		--DW+ Tactics below.
		--Adds in harass to target reloading players, greater proliferation of deathguard, murder, legday, lonewolf, and elite_ranged_fire.
		ELITE_tazer = {
			"legday",
			"charge",
			"flash_grenade",
			"smoke_grenade",
			"shield_cover",
			"murder",
			"tunnel",
			"haste",
			"hunter"
		},
		ELITE_flank_tazer = {
			"legday",
			"charge",
			"flash_grenade",
			"smoke_grenade",
			"shield_cover",
			"murder",
			"tunnel",
			"flank",
			"lonewolf",
			"hunter"
		},
		ELITE_medic = {
			"obstacle",
			"provide_coverfire",
			"spoocavoidance",
			"hitnrun",
			"reloadingretreat",
			"elite_ranged_fire",
			"shield_cover"
		},
		ELITE_boom = {
			"spoocavoidance",
			"flash_grenade",
			"smoke_grenade",
			"harass",
			"elite_ranged_fire",
			"provide_coverfire",
			"hitnrun",
			"shield_cover",
			"deathguard"
		},
		--harass removed here so titandozers are more passive outside of ds
		Titan_tank = {
			"obstacle",
			"hitnrun",
			"reloadingretreat",
			"spoocavoidance",
			"elite_ranged_fire"
		},
		ELITE_Titan_tank = {
			"obstacle",
			"hitnrun",
			"reloadingretreat",
			"murder",
			"elite_ranged_fire",
			"harass"
		},
		ELITE_spooc = {
			"flank",
			"elite_ranged_fire",
			"lonewolf",
			"spoocavoidance",
			"smoke_grenade",
			"flash_grenade",
			"deathguard"
		},
		ELITE_spooc_tac = {
			"hunter",
			"lonewolf",
			"spoocavoidance",
			"smoke_grenade",
			"flash_grenade",
			"harass"
		},
		ELITE_suit_stealth = { --sneaky as fuck
			"flank",
			"smoke_grenade",
			"flash_grenade",
			"hunter",
			"legday",
			"reloadingretreat",
			"spoocavoidance",
			"provide_coverfire",
			"provide_support",
			"hitnrun",
			"grouphrtr"
		},
		ELITE_swat_rifle = {
			"elite_ranged_fire",
			"smoke_grenade",
			"flash_grenade",
			"provide_coverfire",
			"harass",
			"provide_support",
			"shield_cover",
			"groupcsr"
		},
		ELITE_swat_shotgun = {
			"legday",
			"smoke_grenade",
			"flash_grenade",
			"charge",
			"harass",
			"provide_coverfire",
			"shield_cover",
			"provide_support",
			"groupcsr",
			"haste"
		},
		ELITE_heavy = {
			"elite_ranged_fire",
			"smoke_grenade",
			"flash_grenade",
			"harass",
			"provide_coverfire",
			"provide_support",
			"shield_cover",
			"deathguard",
			"groupcsr"
		},
		ELITE_heavy_shotgun = {
			"smoke_grenade",
			"flash_grenade",
			"harass",
			"charge",
			"provide_coverfire",
			"provide_support",
			"shield_cover",
			"deathguard",
			"groupcsr",
			"haste"
		},
		ELITE_swat_rifle_flank = {
			"flank",
			"smoke_grenade",
			"flash_grenade",
			"ranged_fire",
			"charge",
			"harass",
			"provide_coverfire",
			"provide_support",
			"shield_cover"
		},
		ELITE_heavy_flank = {
			"flank",
			"smoke_grenade",
			"flash_grenade",
			"elite_ranged_fire",
			"charge",
			"harass",
			"provide_coverfire",
			"provide_support",
			"shield_cover"
		},
		ELITE_heavy_shotgun_flank = {
			"flank",
			"smoke_grenade",
			"flash_grenade",
			"harass",
			"charge",
			"provide_coverfire",
			"provide_support",
			"shield_cover",
			"haste"
		},
		ELITE_rush = {
			"flash_grenade",
			"charge",
			"murder",
			"elite_ranged_fire",
			"harass"
		},

		--Captains
		Cap_spring = {
			"shield",
			"charge"
		},
		HVH_boss = {
			"shield",
			"charge"
		},
		Cap_summers_minion = {
			"shield_cover",
			"charge",
			"haste" --Might help them keep up with Summers a little better.
		},
		Cap_summers = {
			"shield",
			"charge"
		},
		Cap_autumn = {
			"sneaky",
			"flank",
			"hunter",
			"spoocavoidance",
			"shield_cover",
			"smoke_grenade",
			"provide_coverfire",
			"provide_support",
			"flash_grenade",
			"hitnrun"
		},
		Cap_winters = {
			"shield",
			"charge"
		},
		Cap_winters_minion = {
			"shield",
			"charge"
		},
		--Old Winters
		Phalanx_minion = {
			--"smoke_grenade",
			"charge",
			"provide_coverfire",
			"provide_support",
			"shield",
			"deathguard"
		},
		Phalanx_vip = {
			--"smoke_grenade",
			"charge",
			"provide_coverfire",
			"provide_support",
			"shield",
			"deathguard"
		}
	}

	self.enemy_spawn_groups = {}

	self.enemy_spawn_groups.CS_defend_a = {
		amount = {3, 4},
		spawn = {
			{
				unit = "CS_cop_C45_R870",
				freq = 1,
				tactics = self._tactics.CS_defend,
				rank = 1
			}
		}
	}
	self.enemy_spawn_groups.CS_defend_b = {
		amount = {3, 4},
		spawn = {
			{
				unit = "CS_swat_MP5",
				freq = 1,
				amount_min = 1,
				tactics = self._tactics.CS_defend,
				rank = 1
			}
		}
	}
	self.enemy_spawn_groups.CS_defend_c = {
		amount = {3, 4},
		spawn = {
			{
				unit = "CS_heavy_M4",
				freq = 1,
				amount_min = 1,
				tactics = self._tactics.CS_defend,
				rank = 1
			}
		}
	}
	self.enemy_spawn_groups.CS_cops = {
		amount = {3, 4},
		spawn = {
			{
				unit = "CS_cop_C45_MP5",
				freq = 1,
				tactics = self._tactics.CS_cop,
				rank = 1
			},
			{
				unit = "CS_cop_R870",
				freq = 0.5,
				amount_max = 1,
				tactics = self._tactics.CS_cop_shotgun,
				rank = 2
			},
			{
				unit = "CS_cop_C45_MP5",
				freq = 0.33,
				tactics = self._tactics.CS_cop_flank,
				rank = 3
			}
		}
	}
	self.enemy_spawn_groups.CS_stealth_a = {
		amount = {2, 3},
		spawn = {
			{
				unit = "CS_cop_C45_MP5",
				freq = 1,
				amount_min = 1,
				tactics = self._tactics.CS_cop_stealth,
				rank = 2
			},
			{
				unit = "CS_cop_stealth_MP5",
				freq = 1,
				amount_max = 1,
				tactics = self._tactics.CS_cop_stealth,
				rank = 1
			}
		}
	}
	self.enemy_spawn_groups.CS_swats = {
		amount = {3, 4},
		spawn = {
			{
				unit = "CS_swat_MP5",
				freq = 1,
				tactics = self._tactics.CS_swat_rifle,
				rank = 1
			},
			{
				unit = "CS_swat_R870",
				freq = 0.5,
				amount_max = 1,
				tactics = self._tactics.CS_swat_shotgun,
				rank = 2
			},
			{
				unit = "CS_swat_MP5",
				freq = 0.33,
				tactics = self._tactics.CS_swat_rifle_flank,
				rank = 3
			}
		}
	}

	self.enemy_spawn_groups.CS_shields = {
		amount = {2, 3},
		spawn = {
			{
				unit = "CS_shield",
				freq = 1,
				amount_min = 1,
				amount_max = 2,
				tactics = self._tactics.CS_shield,
				rank = 3
			},
			{
				unit = "CS_cop_stealth_MP5",
				freq = 0.5,
				amount_max = 1,
				tactics = self._tactics.CS_shield_ranged_support,
				rank = 1
			},
			{
				unit = "CS_swat_MP5",
				freq = 0.75,
				amount_max = 1,
				tactics = self._tactics.CS_shield_ranged_support,
				rank = 2
			}
		}
	}

	self.enemy_spawn_groups.FBI_defend_a = {
		amount = {3, 4},
		spawn = {
			{
				unit = "FBI_suit_C45",
				freq = 1,
				amount_min = 1,
				tactics = self._tactics.FBI_defend,
				rank = 2
			},
			{
				unit = "CS_cop_C45_R870",
				freq = 1,
				tactics = self._tactics.FBI_defend,
				rank = 1
			},
			{
				unit = "medic_M4",
				freq = 0.2,
				amount_max = 1,
				tactics = self._tactics.FBI_defend,
				rank = 2
			}
		}
	}
	self.enemy_spawn_groups.FBI_defend_b = {
		amount = {3, 4},
		spawn = {
			{
				unit = "FBI_suit_C45",
				freq = 1,
				amount_min = 1,
				tactics = self._tactics.FBI_defend,
				rank = 2
			},
			{
				unit = "FBI_swat_M4",
				freq = 1,
				tactics = self._tactics.FBI_defend,
				rank = 1
			},
			{
				unit = "medic_M4",
				freq = 0.2,
				amount_max = 1,
				tactics = self._tactics.FBI_defend,
				rank = 2
			}
		}
	}
	self.enemy_spawn_groups.GS_defend_b = {
		amount = {3, 4},
		spawn = {
			{
				unit = "FBI_suit_C45",
				freq = 1,
				amount_min = 1,
				tactics = self._tactics.FBI_defend,
				rank = 2
			},
			{
				unit = "GS_swat_M4",
				freq = 1,
				tactics = self._tactics.FBI_defend,
				rank = 1
			},
			{
				unit = "medic_M4",
				freq = 0.2,
				amount_max = 1,
				tactics = self._tactics.FBI_defend,
				rank = 2
			}
		}
	}
	self.enemy_spawn_groups.FBI_defend_c = {
		amount = {3, 4},
		spawn = {
			{
				unit = "FBI_swat_M4",
				freq = 1,
				tactics = self._tactics.FBI_defend,
				rank = 1
			},
			{
				unit = "medic_M4",
				freq = 0.2,
				amount_max = 1,
				tactics = self._tactics.FBI_defend,
				rank = 2
			}
		}
	}
	self.enemy_spawn_groups.GS_defend_c = {
		amount = {3, 4},
		spawn = {
			{
				unit = "GS_swat_M4",
				freq = 1,
				tactics = self._tactics.FBI_defend,
				rank = 1
			},
			{
				unit = "medic_M4",
				freq = 0.2,
				amount_max = 1,
				tactics = self._tactics.FBI_defend,
				rank = 2
			}
		}
	}
	self.enemy_spawn_groups.FBI_defend_d = {
		amount = {3, 4},
		spawn = {
			{
				unit = "FBI_heavy_G36",
				freq = 1,
				tactics = self._tactics.FBI_defend,
				rank = 1
			},
			{
				unit = "medic_M4",
				freq = 0.2,
				amount_max = 1,
				tactics = self._tactics.FBI_defend,
				rank = 2
			}
		}
	}

	--Fodder spawn groups.
	--These are generally pretty spammable and make up about half of an assault.
	--Contain infrequent specials and LPFs.
		--Cops, low difficulty fodder. Spawns in small groups to differentiate from the more tactical swats and better fit with the very low spawn caps at low diff values.
		self.enemy_spawn_groups.cops_n = {
			amount = {1, 3},
			spawn = {
				{
					unit = "CS_cop_C45_MP5",
					freq = 0.75,
					amount_min = 1,
					tactics = self._tactics.CS_cop,
					rank = 1
				},
				{
					unit = "CS_cop_C45_MP5",
					freq = 0.25,
					tactics = self._tactics.CS_cop_flank,
					rank = 3
				}
			}
		}

		self.enemy_spawn_groups.cops_h = {
			amount = {1, 3},
			spawn = {
				{
					unit = "CS_cop_C45_MP5",
					freq = 0.5,
					amount_min = 1,
					tactics = self._tactics.CS_cop,
					rank = 1
				},
				{
					unit = "CS_cop_R870",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.CS_cop_shotgun,
					rank = 2
				},
				{
					unit = "CS_cop_C45_MP5",
					freq = 0.25,
					tactics = self._tactics.CS_cop_flank,
					rank = 3
				}
			}
		}

		--Light SWATs. General purpose cannon fodder for most difficulties.
		self.enemy_spawn_groups.swats_n = {
			amount = {3, 4},
			spawn = {
				{
					unit = "CS_swat_MP5",
					freq = 1,
					amount_min = 1,
					tactics = self._tactics.CS_swat_rifle,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.swats_h = {
			amount = {3, 4},
			spawn = {
				{
					unit = "CS_swat_MP5",
					freq = 0.8,
					amount_min = 1,
					tactics = self._tactics.CS_swat_rifle,
					rank = 1
				},
				{
					unit = "FBI_swat_M4",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.CS_swat_rifle_flank,
					rank = 3
				}
			}
		}

		self.enemy_spawn_groups.swats_vh = {
			amount = {3, 4},
			spawn = {
				{
					unit = "FBI_swat_M4",
					freq = 0.6,
					amount_min = 1,
					tactics = self._tactics.FBI_swat_rifle,
					rank = 1
				},
				{
					unit = "FBI_swat_M4",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.FBI_swat_rifle_flank,
					rank = 3
				},
				{
					unit = "FBI_swat_R870",
					freq = 0.2,
					tactics = self._tactics.FBI_swat_shotgun,
					rank = 3
				}
			}
		}

		self.enemy_spawn_groups.swats_ovk = {
			amount = {3, 4},
			spawn = {
				{
					unit = "FBI_swat_M4",
					freq = 0.3,
					amount_min = 1,
					tactics = self._tactics.FBI_swat_rifle,
					rank = 1
				},
				{
					unit = "FBI_swat_M4",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.FBI_swat_rifle_flank,
					rank = 3
				},
				{
					unit = "FBI_swat_R870",
					freq = 0.25,
					tactics = self._tactics.FBI_swat_shotgun,
					rank = 3
				},
				{
					unit = "medic_M4",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.swats_mh = {
			amount = {3, 4},
			spawn = {
				{
					unit = "GS_swat_M4",
					freq = 0.25,
					amount_min = 1,
					tactics = self._tactics.MH_swat_rifle,
					rank = 1
				},
				{
					unit = "GS_swat_M4",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.MH_swat_rifle_flank,
					rank = 3
				},
				{
					unit = "GS_swat_R870",
					freq = 0.25,
					tactics = self._tactics.MH_swat_shotgun,
					rank = 3
				},
				{
					unit = "medic_M4",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.swats_dw = {
			amount = {4, 5},
			spawn = {
				{
					unit = "GS_swat_M4",
					freq = 0.25,
					amount_min = 1,
					tactics = self._tactics.ELITE_swat_rifle,
					rank = 1
				},
				{
					unit = "GS_swat_M4",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.ELITE_swat_rifle_flank,
					rank = 3
				},
				{
					unit = "GS_swat_R870",
					freq = 0.25,
					tactics = self._tactics.ELITE_swat_shotgun,
					rank = 3
				},
				{
					unit = "medic_M4",
					freq = 0.24,
					amount_max = 2,
					tactics = self._tactics.FBI_medic,
					rank = 1
				},
				{
					unit = "omnia_LPF",
					freq = 0.01,
					amount_max = 1,
					tactics = self._tactics.ELITE_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.swats_ds = {
			amount = {4, 5},
			spawn = {
				{
					unit = "GS_swat_M4",
					freq = 0.25,
					amount_min = 1,
					tactics = self._tactics.ELITE_swat_rifle,
					rank = 1
				},
				{
					unit = "GS_swat_M4",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.ELITE_swat_rifle_flank,
					rank = 3
				},
				{
					unit = "GS_swat_R870",
					freq = 0.2,
					tactics = self._tactics.ELITE_swat_shotgun,
					rank = 3
				},
				{
					unit = "medic_M4",
					freq = 0.28,
					amount_max = 2,
					tactics = self._tactics.FBI_medic,
					rank = 1
				},
				{
					unit = "omnia_LPF",
					freq = 0.02,
					amount_max = 1,
					tactics = self._tactics.ELITE_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.swats_skm = {
			amount = 5,
			spawn = {
				{
					unit = "Bravo_rifle_swat",
					freq = 0.2,
					amount_min = 1,
					tactics = self._tactics.ELITE_swat_rifle,
					rank = 1
				},
				{
					unit = "Bravo_rifle_swat",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.ELITE_swat_rifle_flank,
					rank = 3
				},
				{
					unit = "Bravo_shotgun_swat",
					freq = 0.25,
					tactics = self._tactics.ELITE_swat_shotgun,
					rank = 3
				},
				{
					unit = "medic_M4",
					freq = 0.28,
					amount_max = 2,
					tactics = self._tactics.FBI_medic,
					rank = 1
				},
				{
					unit = "omnia_LPF",
					freq = 0.02,
					amount_max = 1,
					tactics = self._tactics.ELITE_medic,
					rank = 1
				}
			}
		}

		--GS/Zeal Heavys. Slightly tankier cannon fodder. Should get a bit in the way.
		self.enemy_spawn_groups.heavys_n = {
			amount = {2, 3},
			spawn = {
				{
					unit = "CS_heavy_M4_w",
					freq = 1,
					amount_min = 1,
					tactics = self._tactics.CS_swat_heavy,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.heavys_h = {
			amount = {2, 3},
			spawn = {
				{
					unit = "CS_heavy_M4_w",
					freq = 0.8,
					amount_min = 1,
					tactics = self._tactics.CS_swat_heavy,
					rank = 2
				},
				{
					unit = "CS_swat_MP5",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.CS_swat_heavy_flank,
					rank = 3
				}
			}
		}

		self.enemy_spawn_groups.heavys_vh = {
			amount = {3, 4},
			spawn = {
				{
					unit = "FBI_heavy_G36_w",
					freq = 0.6,
					amount_min = 1,
					tactics = self._tactics.FBI_heavy,
					rank = 2
				},
				{
					unit = "FBI_swat_M4",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.FBI_heavy_flank,
					rank = 3
				},
				{
					unit = "FBI_heavy_R870",
					freq = 0.2,
					tactics = self._tactics.FBI_heavy_shotgun,
					rank = 3
				}
			}
		}

		self.enemy_spawn_groups.heavys_ovk = {
			amount = {3, 4},
			spawn = {
				{
					unit = "FBI_heavy_G36_w",
					freq = 0.3,
					amount_min = 1,
					tactics = self._tactics.FBI_heavy,
					rank = 2
				},
				{
					unit = "FBI_swat_M4",
					freq = 0.3,
					amount_max = 1,
					tactics = self._tactics.FBI_heavy_flank,
					rank = 3
				},
				{
					unit = "FBI_heavy_R870",
					freq = 0.3,
					tactics = self._tactics.FBI_heavy_shotgun,
					rank = 3
				},
				{
					unit = "medic_M4",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.heavys_mh = {
			amount = {3, 4},
			spawn = {
				{
					unit = "FBI_heavy_G36_w",
					freq = 0.3,
					amount_min = 1,
					tactics = self._tactics.MH_heavy,
					rank = 2
				},
				{
					unit = "GS_swat_M4",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.MH_swat_rifle_flank,
					rank = 3
				},
				{
					unit = "FBI_heavy_R870",
					freq = 0.25,
					tactics = self._tactics.MH_heavy_flank,
					rank = 3
				},
				{
					unit = "medic_M4",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.heavys_dw = {
			amount = {4, 5},
			spawn = {
				{
					unit = "FBI_heavy_G36_w",
					freq = 0.3,
					amount_min = 1,
					tactics = self._tactics.ELITE_heavy,
					rank = 2
				},
				{
					unit = "GS_swat_M4",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.ELITE_swat_rifle_flank,
					rank = 3
				},
				{
					unit = "FBI_heavy_R870",
					freq = 0.25,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 3
				},
				{
					unit = "medic_M4",
					freq = 0.24,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				},
				{
					unit = "omnia_LPF",
					freq = 0.01,
					amount_max = 1,
					tactics = self._tactics.ELITE_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.heavys_ds = {
			amount = {4, 5},
			spawn = {
				{
					unit = "FBI_heavy_G36_w",
					freq = 0.3,
					amount_min = 1,
					tactics = self._tactics.ELITE_heavy,
					rank = 2
				},
				{
					unit = "GS_swat_M4",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.ELITE_swat_rifle_flank,
					rank = 3
				},
				{
					unit = "FBI_heavy_R870",
					freq = 0.25,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 3
				},
				{
					unit = "medic_M4",
					freq = 0.23,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				},
				{
					unit = "omnia_LPF",
					freq = 0.02,
					amount_max = 1,
					tactics = self._tactics.ELITE_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.heavys_skm = {
			amount = 5,
			spawn = {
				{
					unit = "FBI_heavy_G36",
					freq = 0.25,
					amount_min = 1,
					tactics = self._tactics.ELITE_heavy,
					rank = 2
				},
				{
					unit = "Bravo_lmg_swat",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.ELITE_swat_rifle_flank,
					rank = 3
				},
				{
					unit = "FBI_heavy_R870",
					freq = 0.25,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 3
				},
				{
					unit = "medic_M4",
					freq = 0.23,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				},
				{
					unit = "omnia_LPF",
					freq = 0.02,
					amount_max = 1,
					tactics = self._tactics.ELITE_medic,
					rank = 1
				}
			}
		}

		--HRTs. Should be annoying and apply pressure to hostages.
		self.enemy_spawn_groups.hostage_rescue_n = {
			amount = {2, 3},
			spawn = {
				{
					unit = "FBI_suit_C45",
					freq = 1,
					tactics = self._tactics.FBI_suit_stealth,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.hostage_rescue_h = {
			amount = {2, 4},
			spawn = {
				{
					unit = "FBI_suit_C45",
					freq = 1,
					tactics = self._tactics.FBI_suit_stealth,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.hostage_rescue_vh = {
			amount = {3, 4},
			spawn = {
				{
					unit = "FBI_suit_C45",
					freq = 1,
					tactics = self._tactics.FBI_suit_stealth,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.hostage_rescue_ovk = {
			amount = {3, 4},
			spawn = {
				{
					unit = "FBI_suit_C45",
					freq = 0.9,
					tactics = self._tactics.FBI_suit_stealth,
					rank = 1
				},
				{
					unit = "spooc",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.spooc,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.hostage_rescue_mh = {
			amount = {4, 4},
			spawn = {
				{
					unit = "FBI_suit_C45",
					freq = 0.9,
					tactics = self._tactics.ELITE_suit_stealth,
					rank = 1
				},
				{
					unit = "spooc",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.spooc,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.hostage_rescue_dw = {
			amount = {4, 5},
			spawn = {
				{
					unit = "FBI_suit_C45",
					freq = 0.89,
					tactics = self._tactics.ELITE_suit_stealth,
					rank = 2
				},
				{
					unit = "spooc",
					freq = 0.09,
					amount_max = 1,
					tactics = self._tactics.ELITE_spooc,
					rank = 5
				},
				{
					unit = "omnia_LPF",
					freq = 0.01,
					amount_max = 1,
					tactics = self._tactics.ELITE_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.hostage_rescue_ds = {
			amount = {4, 5},
			spawn = {
				{
					unit = "FBI_suit_C45",
					freq = 0.9,
					tactics = self._tactics.ELITE_suit_stealth,
					rank = 2
				},
				{
					unit = "spooc",
					freq = 0.08,
					amount_max = 1,
					tactics = self._tactics.ELITE_spooc,
					rank = 5
				},
				{
					unit = "omnia_LPF",
					freq = 0.02,
					amount_max = 1,
					tactics = self._tactics.ELITE_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.hostage_rescue_skm = {
			amount = 5,
			spawn = {
				{
					unit = "fbi_vet",
					freq = 0.9,
					tactics = self._tactics.ELITE_suit_stealth,
					rank = 4
				},
				{
					unit = "spooc",
					freq = 0.08,
					amount_max = 1,
					tactics = self._tactics.ELITE_spooc,
					rank = 5
				},
				{
					unit = "omnia_LPF",
					freq = 0.02,
					amount_max = 1,
					tactics = self._tactics.ELITE_medic,
					rank = 1
				}
			}
		}

		--Mixed group of shotgunners. Aim to charge down and kill players if let too close.
		self.enemy_spawn_groups.shotguns_h = {
			amount = 3,
			spawn = {
				{
					unit = "CS_heavy_R870",
					freq = 0.4,
					tactics = self._tactics.CS_swat_heavy_shotgun,
					rank = 2
				},
				{
					unit = "CS_swat_R870",
					freq = 0.6,
					tactics = self._tactics.CS_swat_shotgun,
					rank = 3
				}
			}
		}

		self.enemy_spawn_groups.shotguns_vh = {
			amount = 3,
			spawn = {
				{
					unit = "FBI_heavy_R870",
					freq = 0.4,
					tactics = self._tactics.FBI_heavy_shotgun,
					rank = 2
				},
				{
					unit = "FBI_swat_R870",
					freq = 0.6,
					tactics = self._tactics.FBI_swat_shotgun,
					rank = 3
				}
			}
		}

		self.enemy_spawn_groups.shotguns_ovk = {
			amount = 3,
			spawn = {
				{
					unit = "FBI_heavy_R870",
					freq = 0.4,
					tactics = self._tactics.CS_tazer_ranged_support,
					rank = 2
				},
				{
					unit = "FBI_swat_R870",
					freq = 0.35,
					tactics = self._tactics.CS_tazer_ranged_support,
					rank = 3
				},
				{
					unit = "Titan_taser",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.CS_Tazer,
					rank = 4
				}
			}
		}

		self.enemy_spawn_groups.shotguns_mh = {
			amount = {3, 4},
			spawn = {
				{
					unit = "FBI_heavy_R870",
					freq = 0.4,
					tactics = self._tactics.MH_swat_shotgun,
					rank = 2
				},
				{
					unit = "GS_swat_R870",
					freq = 0.35,
					tactics = self._tactics.MH_swat_shotgun,
					rank = 3
				},
				{
					unit = "Titan_taser",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.ELITE_tazer,
					rank = 4
				}
			}
		}

		self.enemy_spawn_groups.shotguns_dw = {
			amount = {4, 5},
			spawn = {
				{
					unit = "FBI_heavy_R870",
					freq = 0.4,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 2
				},
				{
					unit = "GS_swat_R870",
					freq = 0.35,
					tactics = self._tactics.ELITE_swat_shotgun,
					rank = 3
				},
				{
					unit = "Titan_taser",
					freq = 0.24,
					amount_max = 1,
					tactics = self._tactics.ELITE_tazer,
					rank = 4
				},
				{
					unit = "omnia_LPF",
					freq = 0.01,
					amount_max = 1,
					tactics = self._tactics.ELITE_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.shotguns_ds = {
			amount = {4, 5},
			spawn = {
				{
					unit = "FBI_heavy_R870",
					freq = 0.4,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 2
				},
				{
					unit = "GS_swat_R870",
					freq = 0.35,
					tactics = self._tactics.ELITE_swat_shotgun,
					rank = 3
				},
				{
					unit = "Titan_taser",
					freq = 0.23,
					amount_max = 1,
					tactics = self._tactics.ELITE_tazer,
					rank = 4
				},
				{
					unit = "omnia_LPF",
					freq = 0.02,
					amount_max = 1,
					tactics = self._tactics.ELITE_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.shotguns_skm = {
			amount = 5,
			spawn = {
				{
					unit = "FBI_heavy_R870",
					freq = 0.35,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 2
				},
				{
					unit = "Bravo_shotgun_swat",
					freq = 0.4,
					tactics = self._tactics.ELITE_swat_shotgun,
					rank = 3
				},
				{
					unit = "Titan_taser",
					freq = 0.23,
					amount_max = 1,
					tactics = self._tactics.ELITE_tazer,
					rank = 4
				},
				{
					unit = "omnia_LPF",
					freq = 0.02,
					amount_max = 1,
					tactics = self._tactics.ELITE_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.bomb_squad_ovk = {
			amount = 3,
			spawn = {
				{
					unit = "FBI_heavy_R870",
					freq = 0.4,
					tactics = self._tactics.FBI_heavy,
					rank = 1
				},
				{
					unit = "FBI_heavy_G36",
					freq = 0.4,
					tactics = self._tactics.FBI_heavy_shotgun,
					rank = 2
				},
				{
					unit = "boom_M4203",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.FBI_Boom,
					rank = 3
				}
			}
		}

		self.enemy_spawn_groups.bomb_squad_mh = {
			amount = {3, 4},
			spawn = {
				{
					unit = "FBI_heavy_G36",
					freq = 0.375,
					tactics = self._tactics.MH_heavy,
					rank = 2
				},
				{
					unit = "FBI_heavy_R870",
					freq = 0.375,
					tactics = self._tactics.MH_heavy_flank,
					rank = 1
				},
				{
					unit = "Titan_shield",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.MH_shield,
					rank = 4
				},
				{
					unit = "boom_M4203",
					freq = 0.15,
					amount_max = 1,
					tactics = self._tactics.ELITE_boom,
					rank = 3
				}
			}
		}

		self.enemy_spawn_groups.bomb_squad_dw = {
			amount = {4, 5},
			spawn = {
				{
					unit = "FBI_heavy_G36",
					freq = 0.3,
					tactics = self._tactics.ELITE_heavy,
					rank = 2
				},
				{
					unit = "FBI_heavy_R870",
					freq = 0.3,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 1
				},
				{
					unit = "Titan_shield",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.MH_shield,
					rank = 4
				},
				{
					unit = "boom_M4203",
					freq = 0.19,
					amount_max = 1,
					tactics = self._tactics.ELITE_boom,
					rank = 3
				},
				{
					unit = "omnia_LPF",
					freq = 0.01,
					amount_max = 1,
					tactics = self._tactics.ELITE_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.bomb_squad_ds = {
			amount = {4, 5},
			spawn = {
				{
					unit = "FBI_heavy_G36",
					freq = 0.3,
					tactics = self._tactics.ELITE_heavy,
					rank = 2
				},
				{
					unit = "FBI_heavy_R870",
					freq = 0.3,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 1
				},
				{
					unit = "Titan_shield",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.MH_shield,
					rank = 4
				},
				{
					unit = "boom_M4203",
					freq = 0.18,
					amount_max = 1,
					tactics = self._tactics.ELITE_boom,
					rank = 3
				},
				{
					unit = "omnia_LPF",
					freq = 0.02,
					amount_max = 1,
					tactics = self._tactics.ELITE_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.bomb_squad_skm = {
			amount = 5,
			spawn = {
				{
					unit = "Bravo_lmg_swat",
					freq = 0.3,
					tactics = self._tactics.ELITE_swat_rifle,
					rank = 2
				},
				{
					unit = "Bravo_shotgun_swat",
					freq = 0.3,
					tactics = self._tactics.ELITE_swat_shotgun,
					rank = 3
				},
				{
					unit = "Titan_shield",
					freq = 0.2,
					amount_max = 2,
					tactics = self._tactics.MH_shield,
					rank = 4
				},
				{
					unit = "boom_M4203",
					freq = 0.18,
					amount_max = 1,
					tactics = self._tactics.ELITE_boom,
					rank = 3
				},
				{
					unit = "omnia_LPF",
					freq = 0.02,
					amount_max = 1,
					tactics = self._tactics.ELITE_medic,
					rank = 1
				}
			}
		}

	--Special spawn groups.
	--These are spawn groups focused around one or more specials.
		--Typical cloaker group. Gets meaner tactics on DS.
		if difficulty_index <= 7 then
			self.enemy_spawn_groups.single_spooc = {
				amount = {1, 1},
				spawn = {
					{
						unit = "spooc",
						freq = 1,
						amount_min = 1,
						tactics = self._tactics.spooc,
						rank = 1
					}
				}
			}
		else
			self.enemy_spawn_groups.single_spooc = {
				amount = {1, 1},
				spawn = {
					{
						unit = "spooc",
						freq = 1,
						amount_min = 1,
						tactics = self._tactics.ELITE_spooc,
						rank = 1
					}
				}
			}
		end

		self.enemy_spawn_groups.FBI_spoocs = self.enemy_spawn_groups.single_spooc

		--Titan Cloakers.
			self.enemy_spawn_groups.cloak_spooc_dw = {
				amount = 1,
				spawn = {
					{
						unit = "Titan_spooc",
						freq = 1,
						amount_min = 1,
						tactics = self._tactics.ELITE_spooc_tac,
						rank = 1
					}
				}
			}
			--Greater variety in AI behavior here including some meaner tactics. May spawn in duos.
			self.enemy_spawn_groups.cloak_spooc_ds = {
				amount = {1, 2},
				spawn = {
					{
						unit = "Titan_spooc",
						freq = 1,
						tactics = self._tactics.ELITE_spooc,
						rank = 1
					},
					{
						unit = "Titan_spooc",
						freq = 1,
						tactics = self._tactics.ELITE_spooc_tac,
						rank = 1
					}
				}
			}

		--Weaker shield squad. Focused on just taking up space.
		self.enemy_spawn_groups.shield_n = {
			amount = {3, 4},
			spawn = {
				{
					unit = "CS_heavy_M4_w",
					freq = 0.5,
					tactics = self._tactics.CS_shield_ranged_support,
					rank = 1
				},
				{
					unit = "CS_shield",
					freq = 0.5,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.CS_shield,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.shield_h = {
			amount = {3, 4},
			spawn = {
				{
					unit = "CS_heavy_M4_w",
					freq = 0.4,
					tactics = self._tactics.CS_shield_ranged_support,
					rank = 2
				},
				{
					unit = "CS_shield",
					freq = 0.5,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.CS_shield,
					rank = 3
				},
				{
					unit = "medic_M4",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.shield_vh = {
			amount = {3, 4},
			spawn = {
				{
					unit = "FBI_heavy_G36_w",
					freq = 0.4,
					tactics = self._tactics.FBI_shield_ranged_support,
					rank = 2
				},
				{
					unit = "FBI_shield",
					freq = 0.4,
					amount_min = 1,
					amount_max = 3,
					tactics = self._tactics.FBI_shield,
					rank = 3
				},
				{
					unit = "boom_M4203",
					freq = 0.1,
					amount_max = 2,
					tactics = self._tactics.FBI_Boom,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.shield_ovk = {
			amount = {4, 5},
			spawn = {
				{
					unit = "FBI_heavy_G36_w",
					freq = 0.4,
					tactics = self._tactics.FBI_shield_ranged_support,
					rank = 2
				},
				{
					unit = "Titan_shield",
					freq = 0.05,
					amount_max = 1,
					tactics = self._tactics.FBI_shield,
					rank = 3
				},
				{
					unit = "FBI_shield",
					freq = 0.35,
					amount_min = 1,
					amount_max = 3,
					tactics = self._tactics.FBI_shield,
					rank = 3
				},
				{
					unit = "boom_M4203",
					freq = 0.1,
					amount_max = 2,
					tactics = self._tactics.FBI_Boom,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.shield_mh = {
			amount = {4, 5},
			spawn = {
				{
					unit = "FBI_heavy_G36_w",
					freq = 0.4,
					tactics = self._tactics.MH_shield_ranged_support,
					rank = 2
				},
				{
					unit = "Titan_shield",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.MH_shield,
					rank = 3
				},
				{
					unit = "FBI_shield",
					freq = 0.3,
					amount_min = 1,
					amount_max = 3,
					tactics = self._tactics.MH_shield,
					rank = 3
				},
				{
					unit = "boom_M4203",
					freq = 0.1,
					amount_max = 2,
					tactics = self._tactics.MH_shield_ranged_support,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.shield_dw = {
			amount = {4, 5},
			spawn = {
				{
					unit = "FBI_heavy_G36_w",
					freq = 0.35,
					tactics = self._tactics.ELITE_heavy,
					rank = 2
				},
				{
					unit = "Titan_shield",
					freq = 0.15,
					amount_max = 1,
					tactics = self._tactics.MH_shield,
					rank = 3
				},
				{
					unit = "FBI_shield",
					freq = 0.3,
					amount_min = 1,
					amount_max = 3,
					tactics = self._tactics.MH_shield,
					rank = 3
				},
				{
					unit = "boom_M4203",
					freq = 0.1,
					amount_max = 2,
					tactics = self._tactics.MH_shield_ranged_support,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.shield_ds = {
			amount = {4, 5},
			spawn = {
				{
					unit = "FBI_heavy_G36_w",
					freq = 0.3,
					tactics = self._tactics.ELITE_heavy,
					rank = 2
				},
				{
					unit = "Titan_shield",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.MH_shield,
					rank = 3
				},
				{
					unit = "FBI_shield",
					freq = 0.25,
					amount_min = 1,
					amount_max = 3,
					tactics = self._tactics.MH_shield_flank,
					rank = 3
				},
				{
					unit = "boom_M4203",
					freq = 0.1,
					amount_max = 3,
					tactics = self._tactics.MH_shield_ranged_support,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.15,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.shield_skm = {
			amount = 5,
			spawn = {
				{
					unit = "FBI_heavy_G36",
					freq = 0.3,
					tactics = self._tactics.ELITE_heavy,
					rank = 2
				},
				{
					unit = "Titan_shield",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.MH_shield,
					rank = 3
				},
				{
					unit = "FBI_shield",
					freq = 0.2,
					amount_min = 1,
					amount_max = 3,
					tactics = self._tactics.MH_shield_flank,
					rank = 3
				},
				{
					unit = "boom_M4203",
					freq = 0.1,
					amount_max = 3,
					tactics = self._tactics.MH_shield_ranged_support,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.15,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		--Long range burst damage harrass squad.
		self.enemy_spawn_groups.shield_sniper_mh = {
			amount = {4, 5},
			spawn = {
				{
					unit = "marshal_marksman",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.MH_shield_ranged_support,
					rank = 1
				},
				{
					unit = "GS_swat_M4",
					freq = 0.6,
					tactics = self._tactics.MH_shield_ranged_support,
					rank = 1
				},
				{
					unit = "Titan_shield",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.MH_shield,
					rank = 2
				},
				{
					unit = "FBI_shield",
					freq = 0.3,
					amount_max = 2,
					tactics = self._tactics.MH_shield,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.shield_sniper_dw = {
			amount = {4, 5},
			spawn = {
				{
					unit = "marshal_marksman",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.ELITE_swat_rifle_flank,
					rank = 1
				},
				{
					unit = "GS_swat_M4",
					freq = 0.3,
					tactics = self._tactics.ELITE_swat_rifle,
					rank = 1
				},
				{
					unit = "Titan_shield",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.MH_shield,
					rank = 2
				},
				{
					unit = "FBI_shield",
					freq = 0.3,
					amount_max = 2,
					tactics = self._tactics.MH_shield,
					rank = 2
				},
				{
					unit = "medic_M4",
					freq = 0.3,
					amount_max = 2,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.shield_sniper_ds = {
			amount = {4, 5},
			spawn = {
				{
					unit = "marshal_marksman",
					freq = 0.2,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.ELITE_swat_rifle_flank,
					rank = 1
				},
				{
					unit = "Titan_shield",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.MH_shield,
					rank = 2
				},
				{
					unit = "FBI_shield",
					freq = 0.3,
					amount_max = 2,
					tactics = self._tactics.MH_shield_flank,
					rank = 2
				},
				{
					unit = "medic_M4",
					freq = 0.3,
					amount_max = 2,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.shield_sniper_skm = {
			amount = 5,
			spawn = {
				{
					unit = "Bravo_sharpshooter",
					freq = 1,
					amount_min = 2,
					amount_max = 2,
					tactics = self._tactics.ELITE_swat_rifle_flank,
					rank = 1
				},
				{
					unit = "Titan_shield",
					freq = 0.3,
					amount_max = 1,
					tactics = self._tactics.MH_shield,
					rank = 2
				},
				{
					unit = "FBI_shield",
					freq = 0.3,
					amount_max = 2,
					tactics = self._tactics.MH_shield_flank,
					rank = 2
				},
				{
					unit = "medic_M4",
					freq = 0.4,
					amount_max = 2,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		--Weaker taser group. Includes a taser + enemies that deal damage or make escaping trickier.
		self.enemy_spawn_groups.taser_n = {
			amount = {3, 4},
			spawn = {
				{
					unit = "CS_tazer",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.CS_Tazer,
					rank = 3
				},
				{
					unit = "CS_swat_MP5",
					freq = 1,
					tactics = self._tactics.CS_swat_rifle,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.taser_h = {
			amount = {3, 4},
			spawn = {
				{
					unit = "CS_tazer",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.CS_Tazer,
					rank = 3
				},
				{
					unit = "CS_heavy_M4_w",
					freq = 0.8,
					tactics = self._tactics.CS_swat_heavy,
					rank = 2
				},
				{
					unit = "medic_M4",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.taser_vh = {
			amount = {3, 4},
			spawn = {
				{
					unit = "CS_tazer",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.CS_Tazer,
					rank = 3
				},
				{
					unit = "FBI_heavy_G36",
					freq = 0.6,
					tactics = self._tactics.FBI_heavy,
					rank = 2
				},
				{
					unit = "FBI_heavy_R870",
					freq = 0.2,
					tactics = self._tactics.FBI_heavy_shotgun,
					rank = 2
				},
				{
					unit = "medic_M4",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.taser_ovk = {
			amount = {4, 5},
			spawn = {
				{
					unit = "CS_tazer",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.CS_Tazer,
					rank = 3
				},
				{
					unit = "FBI_heavy_G36",
					freq = 0.35,
					tactics = self._tactics.FBI_heavy,
					rank = 2
				},
				{
					unit = "FBI_heavy_R870",
					freq = 0.35,
					tactics = self._tactics.FBI_heavy_shotgun,
					rank = 2
				},
				{
					unit = "FBI_shield",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.FBI_shield_flank,
					rank = 4
				},
				{
					unit = "medic_M4",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.taser_mh = {
			amount = {4, 5},
			spawn = {
				{
					unit = "CS_tazer",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.ELITE_tazer,
					rank = 3
				},
				{
					unit = "FBI_heavy_R870",
					freq = 0.5,
					tactics = self._tactics.MH_heavy,
					rank = 2
				},
				{
					unit = "marshal_marksman",
					freq = 0.2,
					tactics = self._tactics.MH_swat_rifle,
					rank = 2
				},
				{
					unit = "FBI_shield",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.MH_shield,
					rank = 2
				},
				{
					unit = "medic_M4",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.taser_dw = {
			amount = {4, 5},
			spawn = {
				{
					unit = "CS_tazer",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.ELITE_tazer,
					rank = 3
				},
				{
					unit = "FBI_heavy_R870",
					freq = 0.3,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 2
				},
				{
					unit = "marshal_marksman",
					freq = 0.3,
					tactics = self._tactics.ELITE_swat_rifle,
					rank = 2
				},
				{
					unit = "FBI_shield",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.MH_shield,
					rank = 2
				},
				{
					unit = "medic_M4",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.taser_ds = {
			amount = {4, 5},
			spawn = {
				{
					unit = "CS_tazer",
					freq = 0.4,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.ELITE_tazer,
					rank = 3
				},
				{
					unit = "marshal_marksman",
					freq = 0.6,
					tactics = self._tactics.ELITE_swat_rifle,
					rank = 2
				},
				{
					unit = "FBI_shield",
					freq = 0.1,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.MH_shield,
					rank = 2
				},
				{
					unit = "medic_M4",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.taser_skm = {
			amount = 5,
			spawn = {
				{
					unit = "CS_tazer",
					freq = 0.4,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.ELITE_tazer,
					rank = 3
				},
				{
					unit = "Bravo_shotgun_swat",
					freq = 0.4,
					tactics = self._tactics.ELITE_swat_shotgun,
					rank = 2
				},
				{
					unit = "FBI_shield",
					freq = 0.1,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.MH_shield,
					rank = 2
				},
				{
					unit = "medic_M4",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				}
			}
		}

		--Built around tasers and grenadiers. Aims to swarm players and either force them away, or lock them inside of gas.
			self.enemy_spawn_groups.boom_taser_vh = {
				amount = 3,
				spawn = {
					{
						unit = "CS_tazer",
						freq = 0.3,
						amount_min = 1,
						amount_max = 2,
						tactics = self._tactics.CS_Tazer,
						rank = 3
					},
					{
						unit = "boom_M4203",
						freq = 0.3,
						amount_min = 1,
						amount_max = 2,
						tactics = self._tactics.FBI_Boom,
						rank = 1
					},
					{
						unit = "FBI_swat_m4",
						freq = 0.4,
						tactics = self._tactics.FBI_swat_rifle,
						rank = 2
					}
				}
			}

			self.enemy_spawn_groups.boom_taser_ovk = {
				amount = 3,
				spawn = {
					{
						unit = "CS_tazer",
						freq = 0.5,
						amount_min = 1,
						amount_max = 2,
						tactics = self._tactics.CS_Tazer,
						rank = 3
					},
					{
						unit = "boom_M4203",
						freq = 0.4,
						amount_min = 1,
						amount_max = 2,
						tactics = self._tactics.FBI_Boom,
						rank = 1
					},
					{
						unit = "FBI_shield",
						freq = 0.1,
						amount_max = 1,
						tactics = self._tactics.FBI_shield_flank,
						rank = 2
					}
				}
			}

			self.enemy_spawn_groups.boom_taser_mh = {
				amount = 3,
				spawn = {
					{
						unit = "CS_tazer",
						freq = 0.4,
						amount_min = 1,
						amount_max = 2,
						tactics = self._tactics.ELITE_tazer,
						rank = 3
					},
					{
						unit = "boom_M4203",
						freq = 0.4,
						amount_min = 1,
						amount_max = 2,
						tactics = self._tactics.ELITE_boom,
						rank = 1
					},
					{
						unit = "FBI_shield",
						freq = 0.1,
						amount_max = 1,
						tactics = self._tactics.MH_shield,
						rank = 2
					},
					{
						unit = "Titan_taser",
						freq = 0.1,
						amount_max = 1,
						tactics = self._tactics.ELITE_flank_tazer,
						rank = 4
					}
				}
			}

			self.enemy_spawn_groups.boom_taser_dw = {
				amount = {3, 4},
				spawn = {
					{
						unit = "CS_tazer",
						freq = 0.4,
						amount_min = 1,
						amount_max = 2,
						tactics = self._tactics.ELITE_tazer,
						rank = 3
					},
					{
						unit = "boom_M4203",
						freq = 0.35,
						amount_min = 1,
						amount_max = 2,
						tactics = self._tactics.ELITE_boom,
						rank = 1
					},
					{
						unit = "FBI_shield",
						freq = 0.1,
						amount_max = 1,
						tactics = self._tactics.MH_shield,
						rank = 2
					},
					{
						unit = "Titan_taser",
						freq = 0.15,
						amount_max = 1,
						tactics = self._tactics.ELITE_flank_tazer,
						rank = 4
					}
				}
			}

			self.enemy_spawn_groups.boom_taser_ds = {
				amount = {4, 5},
				spawn = {
					{
						unit = "CS_tazer",
						freq = 1,
						amount_min = 1,
						tactics = self._tactics.ELITE_tazer,
						rank = 3
					},
					{
						unit = "CS_tazer",
						freq = 0.4,
						amount_max = 1,
						tactics = self._tactics.ELITE_flank_tazer,
						rank = 3
					},
					{
						unit = "boom_M4203",
						freq = 0.3,
						amount_min = 1,
						amount_max = 3,
						tactics = self._tactics.ELITE_boom,
						rank = 1
					},
					{
						unit = "FBI_shield",
						freq = 0.1,
						amount_max = 1,
						tactics = self._tactics.MH_shield,
						rank = 2
					},
					{
						unit = "Titan_taser",
						freq = 0.2,
						amount_max = 1,
						tactics = self._tactics.ELITE_flank_tazer,
						rank = 4
					}
				}
			}

			self.enemy_spawn_groups.boom_taser_skm = {
				amount = 5,
				spawn = {
					{
						unit = "CS_tazer",
						freq = 1,
						amount_min = 1,
						tactics = self._tactics.ELITE_tazer,
						rank = 3
					},
					{
						unit = "CS_tazer",
						freq = 0.4,
						amount_max = 1,
						tactics = self._tactics.ELITE_flank_tazer,
						rank = 3
					},
					{
						unit = "boom_M4203",
						freq = 0.3,
						amount_min = 1,
						amount_max = 3,
						tactics = self._tactics.ELITE_boom,
						rank = 1
					},
					{
						unit = "FBI_shield",
						freq = 0.1,
						amount_max = 1,
						tactics = self._tactics.MH_shield,
						rank = 2
					},
					{
						unit = "Titan_taser",
						freq = 0.2,
						amount_max = 2,
						tactics = self._tactics.ELITE_flank_tazer,
						rank = 4
					}
				}
			}

		--HRTs, but like, 50 of them. And they have an LPF + sometimes other specials support. Aim to just outright overwhelm players and rush them and their hostages down at all costs.
		self.enemy_spawn_groups.common_wave_rush_ds = {
			amount = {6, 8},
			spawn = {
				{
					unit = "GS_swat_M4",
					freq = 0.5,
					tactics = self._tactics.ELITE_rush,
					rank = 3
				},
				{
					unit = "FBI_heavy_G36",
					freq = 0.2,
					tactics = self._tactics.ELITE_rush,
					rank = 3
				},
				{
					unit = "boom_M4203",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.ELITE_swat_rifle,
					rank = 2
				},
				{
					unit = "CS_tazer",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.ELITE_tazer,
					rank = 3
				},
				{
					unit = "medic_M4",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				},
				{ --Tries to make HRTs beefy enough to do things.
					unit = "omnia_LPF",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.ELITE_medic,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.common_wave_rush_skm = {
			amount = 8,
			spawn = {
				{
					unit = "Bravo_rifle_swat",
					freq = 0.3,
					tactics = self._tactics.ELITE_rush,
					rank = 3
				},
				{
					unit = "FBI_heavy_R870",
					freq = 0.2,
					tactics = self._tactics.ELITE_rush,
					rank = 3
				},
				{
					unit = "Bravo_lmg_swat",
					freq = 0.2,
					tactics = self._tactics.ELITE_rush,
					rank = 3
				},
				{
					unit = "boom_M4203",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.ELITE_swat_rifle,
					rank = 2
				},
				{
					unit = "CS_tazer",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.ELITE_tazer,
					rank = 3
				},
				{
					unit = "medic_M4",
					freq = 0.1,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 1
				},
				{ --Tries to make HRTs beefy enough to do things.
					unit = "omnia_LPF",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.ELITE_medic,
					rank = 1
				}
			}
		}

	--Dozer spawn groups.
	--I think it should be clear what these are for.
		self.enemy_spawn_groups.GREEN_tanks_n = {
			amount = 1,
			spawn = {
				{
					unit = "FBI_tank",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.CS_tank,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.GREEN_tanks_h = {
			amount = 2,
			spawn = {
				{
					unit = "FBI_tank",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.CS_tank,
					rank = 2
				},
				{
					unit = "CS_swat_MP5",
					freq = 1,
					tactics = self._tactics.CS_swat_heavy,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.GREEN_tanks_vh = {
			amount = 3,
			spawn = {
				{
					unit = "FBI_tank",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.GREEN_tank,
					rank = 2
				},
				{
					unit = "FBI_swat_M4",
					freq = 1,
					tactics = self._tactics.FBI_heavy,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.GREEN_tanks_ovk = {
			amount = {3, 4},
			spawn = {
				{
					unit = "FBI_tank",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.GREEN_tank,
					rank = 2
				},
				{
					unit = "FBI_swat_M4",
					freq = 1,
					tactics = self._tactics.FBI_heavy,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.GREEN_tanks_mh = {
			amount = {4, 5},
			spawn = {
				{
					unit = "FBI_tank",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.GREEN_tank,
					rank = 3
				},
				{
					unit = "GS_swat_M4",
					freq = 0.8,
					tactics = self._tactics.ELITE_heavy,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.GREEN_tanks_dw = {
			amount = {4, 5},
			spawn = {
				{
					unit = "FBI_tank",
					freq = 0.1,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.GREEN_tank,
					rank = 3
				},
				{
					unit = "GS_swat_M4",
					freq = 0.6,
					tactics = self._tactics.ELITE_heavy,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.3,
					amount_max = 2,
					tactics = self._tactics.FBI_medic,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.GREEN_tanks_ds = {
			amount = {4, 5},
			spawn = {
				{
					unit = "FBI_tank",
					freq = 0.1,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.GREEN_tank,
					rank = 3
				},
				{
					unit = "GS_swat_M4",
					freq = 0.5,
					tactics = self._tactics.ELITE_heavy,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.4,
					amount_max = 2,
					tactics = self._tactics.FBI_medic,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.GREEN_tanks_skm = {
			amount = {5, 6},
			spawn = {
				{
					unit = "FBI_tank",
					freq = 0.1,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.GREEN_tank,
					rank = 3
				},
				{
					unit = "GS_swat_M4",
					freq = 0.5,
					tactics = self._tactics.ELITE_heavy,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.4,
					amount_max = 2,
					tactics = self._tactics.FBI_medic,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.BLACK_tanks_vh = {
			amount = 2,
			spawn = {
				{
					unit = "BLACK_tank",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.BLACK_tank,
					rank = 3
				},
				{
					unit = "FBI_swat_R870",
					freq = 1,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.BLACK_tanks_ovk = {
			amount = {2, 3},
			spawn = {
				{
					unit = "BLACK_tank",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.BLACK_tank,
					rank = 3
				},
				{
					unit = "FBI_swat_R870",
					freq = 1,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.BLACK_tanks_mh = {
			amount = {3, 4},
			spawn = {
				{
					unit = "BLACK_tank",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.BLACK_tank,
					rank = 3
				},
				{
					unit = "FBI_swat_R870",
					freq = 0.8,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 1
				},
				{
					unit = "CS_tazer",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.ELITE_tazer,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.BLACK_tanks_dw = {
			amount = {3, 4},
			spawn = {
				{
					unit = "BLACK_tank",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.BLACK_tank,
					rank = 3
				},
				{
					unit = "CS_tazer",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.ELITE_tazer,
					rank = 2
				},
				{
					unit = "FBI_swat_R870",
					freq = 0.6,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.BLACK_tanks_ds = {
			amount = {3, 4},
			spawn = {
				{
					unit = "BLACK_tank",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.BLACK_tank,
					rank = 3
				},
				{
					unit = "CS_tazer",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.ELITE_tazer,
					rank = 2
				},
				{
					unit = "FBI_swat_R870",
					freq = 0.5,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.BLACK_tanks_skm = {
			amount = 4,
			spawn = {
				{
					unit = "BLACK_tank",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.BLACK_tank,
					rank = 3
				},
				{
					unit = "CS_tazer",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.ELITE_tazer,
					rank = 2
				},
				{
					unit = "Bravo_shotgun_swat",
					freq = 0.5,
					tactics = self._tactics.ELITE_swat_shotgun,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.SKULL_tanks_mh = {
			amount = {3, 4},
			spawn = {
				{
					unit = "SKULL_tank",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.SKULL_tank,
					rank = 3
				},
				{
					unit = "Titan_taser",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.CS_tazer,
					rank = 2
				},
				{
					unit = "GS_swat_R870",
					freq = 0.6,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 1
				}
			}
		}

		self.enemy_spawn_groups.SKULL_tanks_dw = {
			amount = {3, 4},
			spawn = {
				{
					unit = "SKULL_tank",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.SKULL_tank,
					rank = 3
				},
				{
					unit = "Titan_taser",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.ELITE_tazer,
					rank = 2
				},
				{
					unit = "GS_swat_R870",
					freq = 0.6,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.2,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.SKULL_tanks_ds = {
			amount = 4,
			spawn = {
				{
					unit = "SKULL_tank",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.SKULL_tank,
					rank = 3
				},
				{
					unit = "Titan_taser",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.ELITE_tazer,
					rank = 2
				},
				{
					unit = "GS_swat_R870",
					freq = 0.5,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.SKULL_tanks_skm = {
			amount = 4,
			spawn = {
				{
					unit = "SKULL_tank",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.SKULL_tank,
					rank = 3
				},
				{
					unit = "Titan_taser",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.ELITE_tazer,
					rank = 2
				},
				{
					unit = "Bravo_rifle_swat",
					freq = 0.25,
					tactics = self._tactics.ELITE_swat_rifle,
					rank = 1
				},
				{
					unit = "Bravo_shotgun_swat",
					freq = 0.25,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.Titan_tanks_dw = {
			amount = {2, 3},
			spawn = {
				{
					unit = "Titan_tank",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.Titan_tank,
					rank = 3
				},
				{
					unit = "FBI_heavy_R870",
					freq = 0.75,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.25,
					amount_max = 2,
					tactics = self._tactics.FBI_medic,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.Titan_tanks_ds = {
			amount = {3, 4},
			spawn = {
				{
					unit = "Titan_tank",
					freq = 0.25,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.ELITE_Titan_tank,
					rank = 3
				},
				{
					unit = "FBI_heavy_R870",
					freq = 0.75,
					tactics = self._tactics.ELITE_heavy_shotgun,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.25,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 2
				}
			}
		}

		self.enemy_spawn_groups.Titan_tanks_skm = {
			amount = {3, 4},
			spawn = {
				{
					unit = "Titan_tank",
					freq = 0.5,
					amount_min = 1,
					amount_max = 2,
					tactics = self._tactics.ELITE_Titan_tank,
					rank = 3
				},
				{
					unit = "Bravo_lmg_swat",
					freq = 0.25,
					tactics = self._tactics.ELITE_swat_rifle,
					rank = 1
				},
				{
					unit = "medic_M4",
					freq = 0.5,
					amount_max = 1,
					tactics = self._tactics.FBI_medic,
					rank = 2
				}
			}
		}

	--New Winters
	if difficulty_index <= 5 then
		self.enemy_spawn_groups.Cap_Winters = {
			amount = 5,
			force = true,
			spawn = {
				{
					unit = "Phalanx_vip_new",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.Cap_winters,
					rank = 1
				},
				{
					unit = "Phalanx_minion_new",
					freq = 1,
					amount_min = 4,
					amount_max = 4,
					tactics = self._tactics.Cap_winters_minion,
					rank = 2
				}
			}
		}
	elseif difficulty_index <= 7 then
		self.enemy_spawn_groups.Cap_Winters = {
			amount = 7,
			force = true,
			spawn = {
				{
					unit = "Phalanx_vip_new",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.Cap_winters,
					rank = 2
				},
				{
					unit = "Phalanx_minion_new",
					freq = 1,
					amount_min = 6,
					amount_max = 6,
					tactics = self._tactics.Cap_winters_minion,
					rank = 3
				}
			}
		}
	else
		self.enemy_spawn_groups.Cap_Winters = {
			amount = 9,
			force = true,
			spawn = {
				{
					unit = "Phalanx_vip_new",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.Cap_winters,
					rank = 2
				},
				{
					unit = "marshal_marksman_boss",
					freq = 1,
					amount_min = 2,
					amount_max = 2,
					tactics = self._tactics.MH_shield_ranged_support,
					rank = 1
				},
				{
					unit = "Phalanx_minion_new",
					freq = 1,
					amount_min = 6,
					amount_max = 6,
					tactics = self._tactics.Cap_winters_minion,
					rank = 3
				}
			}
		}
	end

	--Captain Spring
	if difficulty_index <= 5 then
		self.enemy_spawn_groups.Cap_Spring = {
			amount = 1,
			force = true,
			spawn = {
				{
					unit = "Cap_Spring",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.Cap_spring,
					rank = 1
				}
			}
		}
	elseif difficulty_index <= 7 then
		self.enemy_spawn_groups.Cap_Spring = {
			amount = 3,
			force = true,
			spawn = {
				{
					unit = "Cap_Spring",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.Cap_spring,
					rank = 1
				},
				{
					unit = "Tank_Titan",
					freq = 1,
					amount_min = 2,
					amount_max = 2,
					tactics = self._tactics.Cap_spring,
					rank = 2
				}
			}
		}
	else
		self.enemy_spawn_groups.Cap_Spring = {
			amount = 5,
			force = true,
			spawn = {
				{
					unit = "Cap_Spring",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.Cap_spring,
					rank = 1
				},
				{
					unit = "Tank_Titan",
					freq = 1,
					amount_min = 2,
					amount_max = 2,
					tactics = self._tactics.Cap_spring,
					rank = 2
				},
				{
					unit = "Titan_taser_boss",
					freq = 1,
					amount_min = 2,
					amount_max = 2,
					tactics = self._tactics.Cap_spring,
					rank = 2
				},
			}
		}
	end

	--HVH boss
	if difficulty_index <= 5 then
		self.enemy_spawn_groups.HVH_Boss = {
			amount = 1,
			force = true,
			spawn = {
				{
					unit = "HVH_Boss",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.HVH_boss,
					rank = 1
				}
			}
		}
	elseif difficulty_index <= 7 then
		self.enemy_spawn_groups.HVH_Boss = {
			amount = 3,
			force = true,
			spawn = {
				{
					unit = "HVH_Boss",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.HVH_boss,
					rank = 1
				},
				{
					unit = "HVH_Boss_Headless",
					freq = 1,
					amount_min = 2,
					amount_max = 2,
					tactics = self._tactics.HVH_boss,
					rank = 2
				}
			}
		}
	else
		self.enemy_spawn_groups.HVH_Boss = {
			amount = 5,
			force = true,
			spawn = {
				{
					unit = "HVH_Boss",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.HVH_boss,
					rank = 1
				},
				{
					unit = "HVH_Boss_Headless",
					freq = 1,
					amount_min = 2,
					amount_max = 2,
					tactics = self._tactics.HVH_boss,
					rank = 2
				},
				{
					unit = "HVH_Boss_Spooc",
					freq = 1,
					amount_min = 2,
					amount_max = 2,
					tactics = self._tactics.HVH_boss,
					rank = 2
				},
			}
		}
	end

	--Captain Autumn
	if difficulty_index <= 5 then
		self.enemy_spawn_groups.Cap_Autumn = {
			amount = 1,
			force = true,
			spawn = {
				{
					unit = "Cap_Autumn",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.Cap_autumn,
					rank = 1
				}
			}
		}
	elseif difficulty_index <= 7 then
		self.enemy_spawn_groups.Cap_Autumn = {
			amount = 4,
			force = true,
			spawn = {
				{
					unit = "Cap_Autumn",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.Cap_autumn,
					rank = 1
				},
				{
					unit = "Spooc_Boss",
					freq = 1,
					amount_min = 3,
					amount_max = 3,
					tactics = self._tactics.Cap_autumn,
					rank = 2
				}
			}
		}
	else
		self.enemy_spawn_groups.Cap_Autumn = {
			amount = 4,
			force = true,
			spawn = {
				{
					unit = "Cap_Autumn",
					freq = 1,
					amount_min = 1,
					amount_max = 1,
					tactics = self._tactics.Cap_autumn,
					rank = 1
				},
				{
					unit = "Titan_Spooc_Boss",
					freq = 1,
					amount_min = 3,
					amount_max = 3,
					tactics = self._tactics.Cap_autumn,
					rank = 2
				}
			}
		}
	end

	--Captain Summers
	self.enemy_spawn_groups.Cap_Summers = {
		amount = 4, --you can actually just kinda do this.
		force = true,
		spawn = {
			{
				unit = "Cap_Summers",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.Cap_summers,
				rank = 4
			},
			{
				unit = "medic_summers",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.Cap_summers_minion,
				rank = 1
			},
			{
				unit = "boom_summers",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.Cap_summers_minion,
				rank = 1
			},
			{
				unit = "taser_summers",
				freq = 1,
				amount_min = 1,
				amount_max = 1,
				tactics = self._tactics.Cap_summers_minion,
				rank = 1
			}
		}
	}
end

function GroupAITweakData:_init_task_data(difficulty_index, difficulty)
	local is_console = SystemInfo:platform() ~= Idstring("WIN32")
	self.max_nr_simultaneous_boss_types = 0
	self.difficulty_curve_points = {0.5}
	self.skirmish_difficulty_curve_points = {
		--0 unused
		0.05, --wave 1
		0.1, --wave 2
		0.15, --wave 3
		0.2, --wave 4
		0.25, --wave 5
		0.3, --wave 6
		0.35, --wave 7
		0.4, --wave 8
		0.45, --wave 9
		0.5, --wave 10
		--1 eventually
	}

	if difficulty_index <= 2 then
		self.smoke_and_flash_grenade_timeout = {20, 20}
	elseif difficulty_index == 3 then
		self.smoke_and_flash_grenade_timeout = {19, 19}
	elseif difficulty_index == 4 then
		self.smoke_and_flash_grenade_timeout = {18, 18}
	elseif difficulty_index == 5 then
		self.smoke_and_flash_grenade_timeout = {17, 17}
	elseif difficulty_index == 6 or difficulty_index == 7 then
		self.smoke_and_flash_grenade_timeout = {16, 16}
	else
		self.smoke_and_flash_grenade_timeout = {15, 15}
	end

	self.smoke_grenade_lifetime = 12
	self.flash_grenade_lifetime = 7.5
	self.flash_grenade = {
		timer = 2.5,
		light_range = 300,
		range = 1000,
		light_specular = 1,
		beep_fade_speed = 4,
		beep_multi = 0.3,
		light_color = Vector3(255, 0, 0),
		beep_speed = {
			0.1,
			0.025
		}
	}
	self.optimal_trade_distance = {0, 0}
	self.bain_assault_praise_limits = {1, 3}
	if difficulty_index <= 3 then
		self.besiege.recurring_group_SO = {
			recurring_cloaker_spawn = {
				interval = {180, 180},
				retire_delay = 30
			},
			recurring_spawn_1 = {
				interval = {60, 60}
			}
		}
	elseif difficulty_index == 4 then
		self.besiege.recurring_group_SO = {
			recurring_cloaker_spawn = {
				interval = {150, 150},
				retire_delay = 30
			},
			recurring_spawn_1 = {
				interval = {60, 60}
			}
		}
	elseif difficulty_index == 5 then
		self.besiege.recurring_group_SO = {
			recurring_cloaker_spawn = {
				interval = {120, 120},
				retire_delay = 30
			},
			recurring_spawn_1 = {
				interval = {60, 60}
			}
		}
	else
		self.besiege.recurring_group_SO = {
			recurring_cloaker_spawn = {
				interval = {90, 90},
				retire_delay = 30
			},
			recurring_spawn_1 = {
				interval = {60, 60}
			}
		}
	end
	self.besiege.regroup.duration = {15, 15, 15}
	self.besiege.assault = {}
	self.besiege.assault.anticipation_duration = {
		{30, 1},
		{30, 1},
		{30, 1}
	}
	self.besiege.assault.build_duration = 35
	self.besiege.assault.sustain_duration_min = {40, 70, 100}
	self.besiege.assault.sustain_duration_max = {40, 70, 100}
	self.besiege.assault.sustain_duration_balance_mul = {1, 1, 1, 1}
	self.besiege.assault.fade_duration = 35
	self.besiege.assault.delay = {30, 25, 20}

	if difficulty_index <= 7 then
		self.besiege.assault.hostage_hesitation_delay = {30, 30, 30}
	else
		self.besiege.assault.hostage_hesitation_delay = {15, 15, 15}
	end

	local map_scale_factor = 1
	for _,t in pairs(heat.large_levels) do
		if job == t then
			map_scale_factor = 1.2
		end
	end
	for _,t in pairs(heat.tiny_levels) do
		if job == t then
			map_scale_factor = 0.9
		end
	end
	for _,vt in pairs(heat.very_tiny_levels) do
		if job == vt then
			map_scale_factor = 0.8
		end
	end
	for _,vt in pairs(heat.extremely_tiny_levels) do
		if job == vt then
			map_scale_factor = 0.65
		end
	end

	self.besiege.assault.force_balance_mul = {
		0.55 * map_scale_factor,
		0.7 * map_scale_factor,
		0.85 * map_scale_factor,
		1.0 * map_scale_factor
	}
	self.besiege.assault.force_pool_balance_mul = {
		0.55,
		0.7,
		0.85,
		1.0
	}

	self.besiege.multiple_tank_token_cooldown_mul = 1.2
	if difficulty_index <= 2 then
		self.besiege.assault.force = {12, 15, 18}
		self.besiege.tank_tokens = {0, 1, 1}
		self.besiege.tank_token_cooldown = {120, 120, 120}
		self.special_unit_spawn_limits = {
			tank = 1,
			taser = 1,
			taser_titan = 0,
			boom = 0,
			spooc = 0,
			shield = math.max(math.round(2 * map_scale_factor), 1),
			shield_titan = 0,
			medic = 0,
			medic_lpf = 0,
			captain = 0
		}
	elseif difficulty_index == 3 then
		self.besiege.assault.force = {
			13,
			16,
			19
		}
		self.besiege.tank_tokens = {1, 1, 1}
		self.besiege.tank_token_cooldown = {135, 110, 90}
		self.special_unit_spawn_limits = {
			tank = 1,
			taser = math.max(math.round(2 * map_scale_factor), 1),
			taser_titan = 0,
			boom = 0,
			spooc = 1,
			shield = math.max(math.round(2 * map_scale_factor), 1),
			shield_titan = 0,
			medic = math.max(math.round(2 * map_scale_factor), 1),
			medic_lpf = 0,
			captain = 0
		}
	elseif difficulty_index == 4 then
		self.besiege.assault.force = {14, 18, 21}
		self.besiege.tank_tokens = {0, 1, 2}
		self.besiege.tank_token_cooldown = {90, 75, 60}
		self.special_unit_spawn_limits = {
			tank = 1,
			taser = math.max(math.round(2 * map_scale_factor), 1),
			taser_titan = 0,
			boom = math.max(math.round(2 * map_scale_factor), 1),
			spooc = math.max(math.round(2 * map_scale_factor), 1),
			shield = math.max(math.round(3 * map_scale_factor), 1),
			shield_titan = 0,
			medic = math.max(math.round(2 * map_scale_factor), 1),
			medic_lpf = 0,
			captain = 1
		}
	elseif difficulty_index == 5 then
		self.besiege.assault.force = {15, 19, 22}
		self.besiege.tank_tokens = {1, 1.5, 2}
		self.besiege.tank_token_cooldown = {90, 75, 60}
		self.special_unit_spawn_limits = {
			tank = math.max(math.round(2 * map_scale_factor), 1),
			taser = math.max(math.round(3 * map_scale_factor), 1),
			taser_titan = math.max(math.round(2 * map_scale_factor), 1),
			boom = math.max(math.round(3 * map_scale_factor), 1),
			spooc = math.max(math.round(2 * map_scale_factor), 1),
			shield = math.max(math.round(3 * map_scale_factor), 1),
			shield_titan = 1,
			medic = math.max(math.round(3 * map_scale_factor), 1),
			medic_lpf = 0,
			captain = 1
		}
	elseif difficulty_index == 6 then
		self.besiege.assault.force = {16, 20, 24}
		self.besiege.tank_tokens = {1, 2, 3}
		self.besiege.tank_token_cooldown = {85, 65, 50}
		self.special_unit_spawn_limits = {
			tank = math.max(math.round(2 * map_scale_factor), 1),
			taser = math.max(math.round(3 * map_scale_factor), 1),
			taser_titan = math.max(math.round(2 * map_scale_factor), 1),
			boom = math.max(math.round(3 * map_scale_factor), 1),
			spooc = math.max(math.round(3 * map_scale_factor), 1),
			shield = math.max(math.round(3 * map_scale_factor), 1),
			shield_titan = 1,
			medic = math.max(math.round(3 * map_scale_factor), 1),
			medic_lpf = 0,
			captain = 1
		}
	elseif difficulty_index == 7 then
		self.besiege.assault.force = {17, 21, 26}
		self.besiege.tank_tokens = {1, 2, 3}
		self.besiege.tank_token_cooldown = {85, 65, 50}
		self.special_unit_spawn_limits = {
			tank = math.max(math.round(3 * map_scale_factor), 1),
			taser = math.max(math.round(3 * map_scale_factor), 1),
			taser_titan = math.max(math.round(2 * map_scale_factor), 1),
			boom = math.max(math.round(3 * map_scale_factor), 1),
			spooc = math.max(math.round(4 * map_scale_factor), 1),
			shield = math.max(math.round(4 * map_scale_factor), 1),
			shield_titan = math.max(math.round(2 * map_scale_factor), 1),
			medic = math.max(math.round(4 * map_scale_factor), 1),
			medic_lpf = 1,
			captain = 1
		}
	else
		self.besiege.assault.force = {18, 23, 28}
		self.besiege.tank_tokens = {1, 2.5, 4}
		self.besiege.tank_token_cooldown = {95, 65, 45}
		self.special_unit_spawn_limits = {
			tank = math.max(math.round(3 * map_scale_factor), 1),
			taser = math.max(math.round(3 * map_scale_factor), 1),
			taser_titan = math.max(math.round(2 * map_scale_factor), 1),
			boom = math.max(math.round(3 * map_scale_factor), 1),
			spooc = math.max(math.round(4 * map_scale_factor), 1),
			shield = math.max(math.round(3 * map_scale_factor), 1),
			shield_titan = math.max(math.round(3 * map_scale_factor), 1),
			medic = math.max(math.round(4 * map_scale_factor), 1),
			medic_lpf = 1,
			captain = 1
		}
	end

	local assault_pool_mul = 2.5
	self.besiege.assault.force_pool = {
		self.besiege.assault.force[1] * assault_pool_mul,
		self.besiege.assault.force[2] * assault_pool_mul,
		self.besiege.assault.force[3] * assault_pool_mul
	}
	
	--Assault groups
	if difficulty_index <= 2 then
		self.besiege.assault.groups = {
			cops_n =           {0.50, 0.25, 0.00},
			swats_n =          {0.24, 0.38, 0.53},
			heavys_n =         {0.11, 0.18, 0.18},
			hostage_rescue_n = {0.05, 0.03, 0.03},
			shield_n =         {0.10, 0.12, 0.15},
			taser_n =          {0.00, 0.04, 0.08},
			GREEN_tanks_n =    {0.00, 0.00, 0.03}
		}
	elseif difficulty_index == 3 then
		self.besiege.assault.groups = {
			cops_h =           {0.18, 0.11, 0.00},
			swats_h =          {0.32, 0.32, 0.38},
			heavys_h =         {0.20, 0.18, 0.18},
			hostage_rescue_h = {0.05, 0.02, 0.02},
			shotguns_h =       {0.00, 0.06, 0.07},
			shield_h =         {0.12, 0.15, 0.15},
			FBI_spoocs =       {0.04, 0.05, 0.06},
			taser_h =          {0.06, 0.08,	0.10},
			GREEN_tanks_h =    {0.02, 0.03, 0.04}
		}
	elseif difficulty_index == 4 then
		self.besiege.assault.groups = {
			swats_vh = 			{0.32, 0.31, 0.30},
			heavys_vh =         {0.21, 0.18, 0.15},
			hostage_rescue_vh = {0.06, 0.03, 0.03},
			bomb_squad_vh =     {0.06, 0.06, 0.06},
			shotguns_vh =       {0.06, 0.06, 0.06},
			shield_vh =         {0.12, 0.15, 0.15},
			FBI_spoocs =        {0.05, 0.06, 0.07},
			taser_vh =          {0.08, 0.08, 0.08},
			boom_taser_vh =     {0.00, 0.02, 0.04},
			GREEN_tanks_vh =    {0.02,0.025, 0.03},
			BLACK_tanks_vh =    {0.02,0.025, 0.03}
		}
	elseif difficulty_index == 5 then
		self.besiege.assault.groups = {
			swats_ovk =          {0.26, 0.24, 0.20},
			heavys_ovk =         {0.13, 0.11, 0.11},
			hostage_rescue_ovk = {0.06, 0.03, 0.03},
			bomb_squad_ovk =     {0.10, 0.10, 0.10},
			shotguns_ovk =       {0.10, 0.10, 0.10},
			shield_ovk =         {0.12, 0.15, 0.15},
			FBI_spoocs =         {0.07, 0.07, 0.07},
			taser_ovk =          {0.10, 0.10, 0.10},
			boom_taser_ovk =     {0.00, 0.02, 0.04},
			GREEN_tanks_ovk =    {0.03, 0.04, 0.05},
			BLACK_tanks_ovk =    {0.03, 0.04, 0.05}
		}
	elseif difficulty_index == 6 then
		self.besiege.assault.groups = {
			swats_mh =          {0.25,0.225, 0.22},
			heavys_mh =         {0.12, 0.12, 0.10},
			hostage_rescue_mh = {0.06, 0.03, 0.02},
			bomb_squad_mh =     {0.09, 0.09, 0.09},
			shotguns_mh =       {0.09, 0.09, 0.09},
			shield_mh =         {0.105,0.10,0.075},
			shield_sniper_mh =  {0.025,0.05,0.075},
			FBI_spoocs =        {0.07, 0.07, 0.07},
			taser_mh =          {0.10, 0.10, 0.07},
			boom_taser_mh =     {0.00, 0.02, 0.07},
			GREEN_tanks_mh =    {0.03,0.035, 0.04},
			BLACK_tanks_mh =    {0.03,0.035, 0.04},
			SKULL_tanks_mh =    {0.03,0.035, 0.04}
		}
	elseif difficulty_index == 7 then
		self.besiege.assault.groups = {
			swats_dw =          {0.22,0.215, 0.20},
			heavys_dw =         {0.11, 0.11, 0.11},
			hostage_rescue_dw = {0.06, 0.02, 0.02},
			bomb_squad_dw =     {0.09, 0.09, 0.09},
			shotguns_dw =       {0.09, 0.09, 0.09},
			shield_dw =         {0.10,0.075, 0.05},
			shield_sniper_dw =  {0.05,0.075, 0.10},
			FBI_spoocs =        {0.07, 0.07, 0.05},
			cloak_spooc_dw =    {0.00, 0.00, 0.02},
			taser_dw =          {0.10, 0.07, 0.03},
			boom_taser_dw =     {0.02, 0.07, 0.10},
			GREEN_tanks_dw =    {0.03,0.035, 0.04},
			BLACK_tanks_dw =    {0.03,0.035, 0.04},
			SKULL_tanks_dw =    {0.03,0.035, 0.04},
			Titan_tanks_dw =    {0.00, 0.01, 0.02}
		}
	else
		--death sentence assaults below, intentionally fairly mean. Later difficulties will scale down from this.
		self.besiege.assault.groups = {
			swats_ds =            {0.19, 0.19, 0.19},
			heavys_ds =           {0.10, 0.09, 0.08},
			hostage_rescue_ds =   {0.10,0.035, 0.00},
			bomb_squad_ds =       {0.09, 0.09, 0.09},
			shotguns_ds =         {0.09, 0.09, 0.09},
			shield_ds =           {0.10,0.075, 0.05},
			shield_sniper_ds =    {0.05,0.075, 0.10},
			FBI_spoocs =          {0.07, 0.05, 0.03},
			cloak_spooc_ds =      {0.00, 0.02, 0.04},
			taser_ds =            {0.10, 0.07, 0.03},
			boom_taser_ds =       {0.02, 0.07, 0.10},
			common_wave_rush_ds = {0.00, 0.02, 0.04},
			GREEN_tanks_ds =      {0.03,0.035, 0.04},
			BLACK_tanks_ds =      {0.03,0.035, 0.04},
			SKULL_tanks_ds =      {0.03,0.035, 0.04},
			Titan_tanks_ds =      {0.00, 0.02, 0.03}
		}
	end

	self.besiege.assault.groups.single_spooc = {
		0,
		0,
		0
	}
	self.besiege.assault.groups.Phalanx = {
		0,
		0,
		0
	}

	--Add the relevant captain to the assault groups, if able to.
	local captain_type = heat.captain_spawns[job]
	if captain_type then
		if difficulty_index == 4 then
			self.besiege.assault.groups[captain_type.spawn_group] = {0,0.05, 0.1}
		elseif difficulty_index == 5 then
			self.besiege.assault.groups[captain_type.spawn_group] = {0, 0.1,0.15}
		else
			self.besiege.assault.groups[captain_type.spawn_group] = {0, 0.1, 0.2}
		end
	end

	self.besiege.reenforce.interval = {10, 20, 30}
	if difficulty_index <= 2 then
		self.besiege.reenforce.groups = {
			CS_defend_a = {1.00, 0.20, 0.00},
			CS_defend_b = {0.00, 0.80, 1.00}
		}
	elseif difficulty_index == 3 then
		self.besiege.reenforce.groups = {
			CS_defend_a = {0.35, 0.00, 0.00},
			CS_defend_b = {0.65, 1.00, 0.00},
			CS_defend_c = {0.00, 0.00, 1.00}
		}
	elseif difficulty_index == 4 then
		self.besiege.reenforce.groups = {
			CS_defend_a =  {0.35, 0.00, 0.00},
			CS_defend_b =  {0.65, 0.50, 0.00},
			CS_defend_c =  {0.00, 0.00, 0.50},
			FBI_defend_a = {0.00, 0.50, 0.00},
			FBI_defend_b = {0.00, 0.00, 0.50}
		}
	elseif difficulty_index == 5 then
		self.besiege.reenforce.groups = {
			CS_defend_a =  {0.10, 0.00, 0.00},
			FBI_defend_b = {0.90, 0.50, 0.00},
			FBI_defend_c = {0.00, 0.50, 0.00},
			FBI_defend_d = {0.00, 0.00, 1.00}
		}
	elseif difficulty_index == 6 then
		self.besiege.reenforce.groups = {
			CS_defend_a =  {0.10, 0.00, 0.00},
			FBI_defend_b = {0.90, 0.50, 0.00},
			FBI_defend_c = {0.00, 0.50, 0.00},
			FBI_defend_d = {0.00, 0.00, 1.00}
		}
	else
		self.besiege.reenforce.groups = {
			CS_defend_a =  {0.10, 0.00, 0.00},
			GS_defend_b =  {0.90, 0.50, 0.00},
			GS_defend_c =  {0.00, 0.50, 0.00},
			FBI_defend_d = {0.00, 0.00, 1.00}
		}
	end

	self.besiege.recon.interval = {5, 5, 5}
	self.besiege.recon.interval_variation = 40
	self.besiege.recon.force = {
		4 * map_scale_factor,
		5 * map_scale_factor,
		6 * map_scale_factor
	}
	if difficulty_index <= 2 then
		--normal
		self.besiege.recon.groups = {
			hostage_rescue_n = {0.33, 0.66, 1.00},
			cops_n =           {0.66, 0.33, 0.00}
		}
	elseif difficulty_index == 3 then
		--hard
		self.besiege.recon.groups = {
			hostage_rescue_h = {0.66, 1.00, 1.00},
			cops_h =           {0.33, 0.00, 0.00}
		}
	elseif difficulty_index == 4 then
		--very hard
		self.besiege.recon.groups = {
			hostage_rescue_vh = {1.00, 1.00, 1.00}
		}
	elseif difficulty_index == 5 then
		--overkill
		self.besiege.recon.groups = {
			hostage_rescue_ovk = {1.00, 1.00, 1.00}
		}
	elseif difficulty_index == 6 then
		--mayhem
		--gets lone recon cloakers
		self.besiege.recon.groups = {
			hostage_rescue_mh = {1.00, 0.90, 0.80},
			single_spooc =      {0.00, 0.10, 0.20}
		}
	elseif difficulty_index == 7 then
		--death wish
		self.besiege.recon.groups = {
			hostage_rescue_dw = {1.00, 0.90, 0.80},
			single_spooc =      {0.00, 0.10, 0.20}
		}
	else
		--death sentence
		--gets rare titan cloakers
		self.besiege.recon.groups = {
			hostage_rescue_ds = {1.00, 0.90, 0.80},
			single_spooc =      {0.00, 0.08, 0.15},
			cloak_spooc =       {0.00, 0.02, 0.05}
		}
	end

	self.besiege.cloaker.groups = {
		single_spooc = {1.00, 1.00, 1.00}
	}

	local captain_cooldown = 1800 --30 minutes
	local captain_min_diff = 0.3 
	if Global.game_settings and Global.game_settings.one_down then
		captain_cooldown = 1200 --20 minutes
	end

	--Table to define various restrictions for how different spawn groups can appear.
	self.besiege.group_constraints = {
		Cap_Winters = {
			cooldown = captain_cooldown,
			min_diff = captain_min_diff,
			sustain_only = true
		},
		Cap_Spring = {
			cooldown = captain_cooldown,
			min_diff = captain_min_diff,
			sustain_only = true
		},
		HVH_Boss = {
			cooldown = captain_cooldown,
			min_diff = captain_min_diff,
			sustain_only = true
		},
		Cap_Summers = {
			cooldown = captain_cooldown,
			min_diff = captain_min_diff,
			sustain_only = true
		},
		Cap_Autumn = {
			cooldown = captain_cooldown,
			min_diff = captain_min_diff,
			sustain_only = true
		},
		common_wave_rush_ds = {
			cooldown = 90,
			min_diff = 0.5,
			sustain_only = true
		},
		common_wave_rush_skm = {
			cooldown = 90,
			sustain_only = true
		}
	}

	self.street = deep_clone(self.besiege)
	self.phalanx.minions.min_count = 0
	self.phalanx.minions.amount = 10
	self.phalanx.minions.distance = 100
	self.phalanx.vip.health_ratio_flee = 0.1
	self.phalanx.vip.force_sprint = nil
	self.phalanx.vip.assault_force_multiplier = {1}
	self.phalanx.vip.damage_reduction = {
		start = 0,
		increase = 0,
		max = 0,
		increase_intervall = 0
	}
	self.phalanx.check_spawn_intervall = 120
	self.phalanx.chance_increase_intervall = 120
	self.phalanx.spawn_chance = {
		start = 0,
		increase = 0,
		decrease = 0,
		max = 0,
		respawn_delay = 120
	}
	self.safehouse = deep_clone(self.besiege)
end
