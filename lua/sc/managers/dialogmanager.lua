local very_short_timers = {325, 310, 295, 280, 265, 250, 235, 210}
local short_timers = {410, 390, 370, 350, 330, 310, 290, 270}
local average_timers = {690, 660, 630, 600, 570, 540, 510, 480}
local long_timers = {1000, 960, 920, 880, 840, 800, 760, 720}
local very_long_timers = {1200, 1150, 1100, 1050, 1000, 950, 900}

--PONR timers:
local ponr_timers = {
	["Play_loc_chas_89"] = average_timers, --Dragon Heist
	["Play_loc_fex_58a"] = average_timers, --Buluc's Mansion
	["pln_framing_stage1_09"] = average_timers,	--Framing Frame Day 1
	["pln_framing_stage2_13"] = average_timers,	--Framing Frame Day 2
	["pln_framing_stage3_43"] = short_timers, --Framing Frame Day 3
	["Play_vld_ko1b_03"] = very_long_timers, --Meltdown
	["Play_loc_mex_66"] = very_long_timers,	--Border Crossing
	["Play_pln_brn_11"] = long_timers,	--Biker Heist 1
	["Play_pln_chw_01"] = long_timers,	--Biker Heist 2
	["Play_cpt_wwh_16"] = long_timers, --Alaskan Deal
	["Play_pln_al1_49"] = long_timers,	--Alesso Heist
	["Play_pln_hm1_52"] = long_timers, --Hotline Miami Day 1
	["Play_pln_hm2_15"] = short_timers,	--Hotline Miami Day 2
	["pln_fost_vh_01"] = short_timers,	--Four Stores
	["Play_cha_spa_14"] = short_timers,	--Brooklyn 10-10
	["Play_loc_brb_53"] = average_timers,	--Brooklyn Bank
	["Play_pln_ukranian_stage1_28"] = average_timers, --Jewelery Store & Ukrainian Job
	["Play_pln_fj1_07"] = average_timers, --Diamond Store
	["pln_mallcrash_stage1_14"] = average_timers, --Mallcrasher
	["Play_pln_tr1b_02"] = long_timers, --Train Heist
	["Play_loc_vit_137"] = long_timers, --White House
	["play_pln_gen_bfr_06"] = long_timers, --generic "that's enough but you can stay for more"
	["pln_nightclub_stage1_10"] = long_timers, --Nightclub
	["pln_fs1_11"] = very_long_timers, --Firestarter day 1
	["pln_fs2_20"] = short_timers, --Firestarter day 2
	["pln_fs3_07"] = short_timers, --Firestarter day 3
	["Play_vld_pt1_05b"] = average_timers, --Goat Sim Day 1
	["Play_pln_pt2_16"] = very_long_timers, --Goat Sim Day 2
	["Play_loc_rvd_14"] = short_timers, --Highland Mortuary
	["Play_pln_rvd_48a"] = average_timers, --Garnet Group Boutique
	["Play_loc_sah_85"] = average_timers, --Shacklethorne Auction
	["Play_loc_jr1_49"] = short_timers, --Beneath the Mountain
	["Play_loc_jr2_27"] = long_timers, --Birth of Sky
	["Play_pln_bb1_64"] = long_timers, --Big Bank
	["Play_pln_bb1_38"] = long_timers, --Big Bank
	["Play_pln_mad_45"] = average_timers, --Boiling Point
	["Play_loc_bex_108"] = average_timers, --San Martin Bank
	["Play_loc_pex_102"] = average_timers, --Breakfast in Tijuana
	["Play_loc_des_84"] = average_timers, --Henry's Rock
	["Play_pln_hd1_34"] = long_timers, --The Diamond
	["pln_watchdogs_new_stage1_21"] = average_timers, --Watchdogs Day 1 (if Twitch dies when Bile notes that bile is coming)
	["pln_watchdogs_new_stage2_10"] = very_long_timers, --Watchdogs Day 2.
	["Play_pln_cr3_34"] = average_timers, --Bomb forest
	["Play_pln_fri_36"] = average_timers, --Scarface Mansion
	["Play_pln_cr2_35"] = average_timers, --Bomb Dockyard
	["Play_pln_cr2_104"] = average_timers, --Bomb Dockyard
	["pln_bo1_05"] = very_short_timers, --Big Oil Day 1
	["pln_bo2_36"] = average_timers, --Big Oil Day 2
	["pln_bo2_40"] = average_timers, --Big Oil Day 2
	["pln_bo2_39"] = average_timers, --Big Oil Day 2
	["Play_pln_ed3_18"] = short_timers, --Breaking Ballot
	["Play_pln_ed3_17"] = short_timers, --Breaking Ballot
	["Play_pln_ed2_14"] = short_timers, --Swing Vote
	["Play_plt_as1_01"] = average_timers, --Aftershock
	["pln_branchbank_stage1_08"] = short_timers, --Bank Heist
	["pln_branchbank_stage1_13"] = short_timers, --Bank Heist
	["pln_branchbank_stage1_44"] = short_timers, --Bank Heist
	["pln_branchbank_stage1_29"] = short_timers, --Bank Heist
	["Play_pln_hb3_42"] = average_timers, --Hoxton's Revenge
	["Play_pln_moon_27"] = average_timers, --Stealing Xmas
	["Play_pln_hb2_19"] = very_short_timers, --Hoxout 2
	["Play_pln_dah_120"] = average_timers, --Diamond Heist
	["Play_pln_pal_59"] = very_short_timers, --Counterfeit
	["Play_pln_pal_76"] = very_short_timers, --Counterfeit
	["Play_pln_dn1_25"] = very_short_timers, --Slaughterhouse
}

--Maps with level script based PONRs:
--[[
	Golden Grin Casino (1200 scaling down to 1050)
	First World Bank (whatever it does)
]]
local old_queue_dialog = DialogManager.queue_dialog
function DialogManager:queue_dialog(id, ...)
	local difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
	local difficulty_index = tweak_data:difficulty_to_index(difficulty)
	
	--log("Playing line " .. id)
			
	if Global.game_settings and Global.game_settings.one_down then
		local escape_time = nil
		if ponr_timers[id] then
			escape_time = ponr_timers[id][difficulty_index]
		end
		
		if escape_time then
			if managers.groupai:state():whisper_mode() then
				--Could try PONR stuff for stealth heists, we'll see
			else
				managers.groupai:state():set_point_of_no_return_timer(escape_time, 0)
			end
		end
	end	
			
	return old_queue_dialog(self, id, ...)
end
