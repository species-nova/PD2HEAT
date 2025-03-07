--US Spawns
local america = {
		["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = "units/payday2/characters/ene_sniper_1/ene_sniper_1",
		["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/payday2/characters/ene_city_swat_1_sc/ene_city_swat_1_sc",
		["units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"] = "units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw"
	}
local america_very_hard = {
		["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = "units/payday2/characters/ene_sniper_2/ene_sniper_2",
		["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/payday2/characters/ene_city_swat_1_sc/ene_city_swat_1_sc",
		["units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"] = "units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw"
	}	
local america_mayhem = {
		["units/payday2/characters/ene_swat_1/ene_swat_1"] = "units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1",
		["units/payday2/characters/ene_swat_2/ene_swat_2"] = "units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2",
		["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/payday2/characters/ene_city_swat_1_sc/ene_city_swat_1_sc",
		["units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"] = "units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",
		["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = "units/payday2/characters/ene_sniper_2/ene_sniper_2",
		["units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"] = "units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2",
		["units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"] = "units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw"
	}			
local america_dw = {
		["units/payday2/characters/ene_swat_1/ene_swat_1"] = "units/payday2/characters/ene_city_swat_1_sc/ene_city_swat_1_sc",
		["units/payday2/characters/ene_swat_2/ene_swat_2"] = "units/payday2/characters/ene_city_swat_2/ene_city_swat_2",
		["units/payday2/characters/ene_shield_1/ene_shield_1"] = "units/payday2/characters/ene_shield_gensec/ene_shield_gensec",
		["units/payday2/characters/ene_shield_2/ene_shield_2"] = "units/payday2/characters/ene_shield_gensec/ene_shield_gensec",
		["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/payday2/characters/ene_city_swat_1_sc/ene_city_swat_1_sc",
		["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = "units/payday2/characters/ene_city_swat_1_sc/ene_city_swat_1_sc",
		["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = "units/payday2/characters/ene_city_swat_2/ene_city_swat_2",
		["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = "units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36",
		["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = "units/payday2/characters/ene_sniper_3/ene_sniper_3",	
		["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = "units/payday2/characters/ene_sniper_3/ene_sniper_3",
		["units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw"] = "units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"

	}		
local america_zeal = {
		["units/payday2/characters/ene_swat_1/ene_swat_1"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/payday2/characters/ene_swat_2/ene_swat_2"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_2/ene_zeal_city_2",
		["units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"] = "units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer",
		["units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"] = "units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer",
		["units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"] = "units/pd2_dlc_vip/characters/ene_vip_2_assault/ene_vip_2_assault", --sshh don't tell anyone i did this :>
		["units/payday2/characters/ene_tazer_1/ene_tazer_1"] = "units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer",
		["units/payday2/characters/ene_spook_1/ene_spook_1"] = "units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker",
		["units/payday2/characters/ene_shield_1/ene_shield_1"] = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield",
		["units/payday2/characters/ene_shield_2/ene_shield_2"] = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield",
		["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc",
		["units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"] = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc",
		["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_2/ene_zeal_city_2",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"] = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc",
		["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/payday2/characters/ene_city_swat_2/ene_city_swat_2"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_2/ene_zeal_city_2",
		["units/payday2/characters/ene_city_swat_3/ene_city_swat_3"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_3/ene_zeal_city_3",
		["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = "units/pd2_dlc_gitgud/characters/ene_zeal_sniper/ene_zeal_sniper",	
		["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = "units/pd2_dlc_gitgud/characters/ene_zeal_sniper/ene_zeal_sniper",
		["units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw"] = "units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"
	}	
		
--Murkywater Scripted Spawn Replacements, try to use these as templates to work from
local murkywater = {
		["units/payday2/characters/ene_spook_1/ene_spook_1"] = "units/pd2_mod_sharks/characters/ene_murky_spook/ene_murky_spook",
		["units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker"] = "units/pd2_mod_omnia/characters/ene_omnia_spook/ene_omnia_spook",
		["units/payday2/characters/ene_cop_1/ene_cop_1"] = "units/pd2_mod_sharks/characters/ene_murky_cs_cop_c45/ene_murky_cs_cop_c45",
		["units/payday2/characters/ene_cop_2/ene_cop_2"] = "units/pd2_mod_sharks/characters/ene_murky_cs_cop_raging_bull/ene_murky_cs_cop_raging_bull",
		["units/payday2/characters/ene_cop_3/ene_cop_3"] = "units/pd2_mod_sharks/characters/ene_murky_cs_cop_mp5/ene_murky_cs_cop_mp5",
		["units/payday2/characters/ene_cop_4/ene_cop_4"] = "units/pd2_mod_sharks/characters/ene_murky_cs_cop_r870/ene_murky_cs_cop_r870",
		["units/payday2/characters/ene_swat_1/ene_swat_1"] = "units/pd2_mod_sharks/characters/ene_swat_1/ene_swat_1",
		["units/payday2/characters/ene_swat_2/ene_swat_2"] = "units/pd2_mod_sharks/characters/ene_swat_2/ene_swat_2",
		["units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"] = "units/pd2_mod_sharks/characters/ene_swat_heavy_1/ene_swat_heavy_1",
		["units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"] = "units/pd2_mod_sharks/characters/ene_swat_heavy_r870/ene_swat_heavy_r870",		
		["units/payday2/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc"] = "units/pd2_mod_sharks/characters/ene_swat_heavy_r870/ene_swat_heavy_r870",
		["units/payday2/characters/ene_tazer_1/ene_tazer_1"] = "units/pd2_mod_sharks/characters/ene_murky_tazer/ene_murky_tazer",
		["units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"] = "units/pd2_mod_omnia/characters/ene_omnia_taser/ene_omnia_taser",
		["units/payday2/characters/ene_shield_2/ene_shield_2"] = "units/pd2_mod_sharks/characters/ene_murky_shield_yellow/ene_murky_shield_yellow",
		["units/payday2/characters/ene_fbi_1/ene_fbi_1"] = "units/payday2/characters/ene_fbi_1/ene_fbi_1",
		["units/payday2/characters/ene_fbi_2/ene_fbi_2"] = "units/payday2/characters/ene_fbi_2/ene_fbi_2",
		["units/payday2/characters/ene_fbi_3/ene_fbi_3"] = "units/payday2/characters/ene_fbi_3/ene_fbi_3",
		["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = "units/pd2_mod_sharks/characters/ene_fbi_swat_1/ene_fbi_swat_1",
		["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/pd2_mod_sharks/characters/ene_city_swat_1/ene_city_swat_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"] = "units/pd2_mod_omnia/characters/ene_omnia_city/ene_omnia_city",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1"] = "units/pd2_mod_omnia/characters/ene_omnia_city/ene_omnia_city",
		["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = "units/pd2_mod_sharks/characters/ene_fbi_swat_2/ene_fbi_swat_2",
		["units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"] = "units/pd2_mod_sharks/characters/ene_fbi_swat_3/ene_fbi_swat_3",
		["units/payday2/characters/ene_city_swat_2/ene_city_swat_2"] = "units/pd2_mod_sharks/characters/ene_city_swat_2/ene_city_swat_2",
		["units/payday2/characters/ene_city_swat_3/ene_city_swat_3"] = "units/pd2_mod_sharks/characters/ene_city_swat_3/ene_city_swat_3",		
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_2/ene_zeal_city_2"] = "units/pd2_mod_omnia/characters/ene_omnia_city_2/ene_omnia_city_2",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_3/ene_zeal_city_3"] = "units/pd2_mod_omnia/characters/ene_omnia_city_3/ene_omnia_city_3",
		["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = "units/pd2_mod_sharks/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",	
		["units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"] = "units/pd2_mod_sharks/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",	
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc"] = "units/pd2_mod_omnia/characters/ene_omnia_heavy/ene_omnia_heavy",	
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"] = "units/pd2_mod_omnia/characters/ene_omnia_heavy/ene_omnia_heavy",	
		["units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"] = "units/pd2_mod_sharks/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870",	
		["units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc"] = "units/pd2_mod_sharks/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870",	
		["units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"] = "units/pd2_mod_sharks/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870",	
		["units/payday2/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc"] = "units/pd2_mod_sharks/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_r870_sc/ene_zeal_swat_heavy_r870_sc"] = "units/pd2_mod_omnia/characters/ene_omnia_heavy_r870/ene_omnia_heavy_r870",
		["units/payday2/characters/ene_shield_1/ene_shield_1"] = "units/pd2_mod_sharks/characters/ene_murky_shield_fbi/ene_murky_shield_fbi",
		["units/payday2/characters/ene_city_shield/ene_city_shield"] = "units/pd2_mod_sharks/characters/ene_murky_shield_fbi/ene_murky_shield_fbi",
		["units/payday2/characters/ene_shield_gensec/ene_shield_gensec"] = "units/pd2_mod_sharks/characters/ene_murky_shield_fbi/ene_murky_shield_fbi",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield"] = "units/pd2_mod_omnia/characters/ene_omnia_shield/ene_omnia_shield",
		["units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"] = "units/pd2_mod_sharks/characters/ene_murky_fbi_tank_r870/ene_murky_fbi_tank_r870",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2"] = "units/pd2_mod_omnia/characters/ene_bulldozer_1/ene_bulldozer_1",
		["units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"] = "units/pd2_mod_sharks/characters/ene_murky_fbi_tank_saiga/ene_murky_fbi_tank_saiga",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3"] = "units/pd2_mod_omnia/characters/ene_bulldozer_2/ene_bulldozer_2",
		["units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"] = "units/pd2_mod_sharks/characters/ene_murky_fbi_tank_m249/ene_murky_fbi_tank_m249",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"] = "units/pd2_mod_omnia/characters/ene_bulldozer_3/ene_bulldozer_3",		
		["units/payday2/characters/ene_medic_m4/ene_medic_m4"] = "units/pd2_mod_sharks/characters/ene_murky_medic_m4/ene_murky_medic_m4",
		["units/payday2/characters/ene_medic_r870/ene_medic_r870"] = "units/pd2_mod_sharks/characters/ene_murky_medic_m4/ene_murky_medic_m4",
		["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = "units/pd2_mod_sharks/characters/ene_murky_sniper/ene_murky_sniper",	
		["units/pd2_dlc_bph/characters/ene_murkywater_sniper/ene_murkywater_sniper"] = "units/pd2_mod_sharks/characters/ene_murky_sniper/ene_murky_sniper",	
		["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = "units/pd2_mod_sharks/characters/ene_murky_sniper/ene_murky_sniper",
		["units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light"] = "units/pd2_mod_sharks/characters/ene_swat_heavy_1/ene_swat_heavy_1",
		--Scripted Spawns Only
		["units/payday2/characters/ene_murkywater_1/ene_murkywater_1"] = "units/pd2_mod_sharks/characters/ene_swat_1/ene_swat_1",	
		["units/payday2/characters/ene_murkywater_2/ene_murkywater_2"] = "units/pd2_mod_sharks/characters/ene_swat_2/ene_swat_2",	
		["units/pd2_dlc_des/characters/ene_murkywater_no_light_not_security/ene_murkywater_no_light_not_security"] = "units/pd2_mod_sharks/characters/ene_swat_1/ene_swat_1",	
		["units/pd2_dlc_des/characters/ene_murkywater_not_security_1/ene_murkywater_not_security_1"] = "units/pd2_mod_sharks/characters/ene_swat_1/ene_swat_1",	
		["units/pd2_dlc_des/characters/ene_murkywater_not_security_2/ene_murkywater_not_security_2"] = "units/pd2_mod_sharks/characters/ene_swat_heavy_1/ene_swat_heavy_1",	
		["units/pd2_dlc_berry/characters/ene_murkywater_no_light/ene_murkywater_no_light"] = "units/pd2_mod_sharks/characters/ene_swat_heavy_r870/ene_swat_heavy_r870",	
		["units/payday2/characters/ene_security_1/ene_security_1"] = "units/pd2_mod_sharks/characters/ene_murky_security_c45/ene_murky_security_c45",
		["units/payday2/characters/ene_security_2/ene_security_2"] = "units/pd2_mod_sharks/characters/ene_murky_security_mp5/ene_murky_security_mp5",
		["units/payday2/characters/ene_security_3/ene_security_3"] = "units/pd2_mod_sharks/characters/ene_murky_security_r870/ene_murky_security_r870",
		["units/payday2/characters/ene_security_4/ene_security_4"] = "units/pd2_mod_sharks/characters/ene_murky_security_raging_bull/ene_murky_security_raging_bull"		
	}
local murkywater_2 = {
		["units/payday2/characters/ene_spook_1/ene_spook_1"] = "units/pd2_mod_sharks/characters/ene_murky_spook/ene_murky_spook",
		["units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker"] = "units/pd2_mod_omnia/characters/ene_omnia_spook/ene_omnia_spook",
		["units/payday2/characters/ene_swat_1/ene_swat_1"] = "units/pd2_mod_sharks/characters/ene_swat_1/ene_swat_1",
		["units/payday2/characters/ene_swat_2/ene_swat_2"] = "units/pd2_mod_sharks/characters/ene_swat_2/ene_swat_2",
		["units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"] = "units/pd2_mod_sharks/characters/ene_murky_yellow_m4/ene_murky_yellow_m4",
		["units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"] = "units/pd2_mod_sharks/characters/ene_murky_yellow_r870/ene_murky_yellow_r870",		
		["units/payday2/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc"] = "units/pd2_mod_sharks/characters/ene_murky_yellow_r870/ene_murky_yellow_r870",
		["units/payday2/characters/ene_tazer_1/ene_tazer_1"] = "units/pd2_mod_sharks/characters/ene_murky_tazer/ene_murky_tazer",
		["units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"] = "units/pd2_mod_omnia/characters/ene_omnia_taser/ene_omnia_taser",
		["units/payday2/characters/ene_shield_2/ene_shield_2"] = "units/pd2_mod_sharks/characters/ene_murky_shield_yellow/ene_murky_shield_yellow",
		["units/payday2/characters/ene_fbi_1/ene_fbi_1"] = "units/payday2/characters/ene_fbi_1/ene_fbi_1",
		["units/payday2/characters/ene_fbi_2/ene_fbi_2"] = "units/payday2/characters/ene_fbi_2/ene_fbi_2",
		["units/payday2/characters/ene_fbi_3/ene_fbi_3"] = "units/payday2/characters/ene_fbi_3/ene_fbi_3",
		["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = "units/pd2_mod_sharks/characters/ene_fbi_swat_1/ene_fbi_swat_1",
		["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/pd2_mod_sharks/characters/ene_city_swat_1/ene_city_swat_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"] = "units/pd2_mod_omnia/characters/ene_omnia_city/ene_omnia_city",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1"] = "units/pd2_mod_omnia/characters/ene_omnia_city/ene_omnia_city",
		["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = "units/pd2_mod_sharks/characters/ene_fbi_swat_2/ene_fbi_swat_2",
		["units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"] = "units/pd2_mod_sharks/characters/ene_fbi_swat_3/ene_fbi_swat_3",
		["units/payday2/characters/ene_city_swat_2/ene_city_swat_2"] = "units/pd2_mod_sharks/characters/ene_city_swat_2/ene_city_swat_2",
		["units/payday2/characters/ene_city_swat_3/ene_city_swat_3"] = "units/pd2_mod_sharks/characters/ene_city_swat_3/ene_city_swat_3",		
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_2/ene_zeal_city_2"] = "units/pd2_mod_omnia/characters/ene_omnia_city_2/ene_omnia_city_2",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_3/ene_zeal_city_3"] = "units/pd2_mod_omnia/characters/ene_omnia_city_3/ene_omnia_city_3",
		["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = "units/pd2_mod_sharks/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",	
		["units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"] = "units/pd2_mod_sharks/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",	
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc"] = "units/pd2_mod_omnia/characters/ene_omnia_heavy/ene_omnia_heavy",	
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"] = "units/pd2_mod_omnia/characters/ene_omnia_heavy/ene_omnia_heavy",	
		["units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"] = "units/pd2_mod_sharks/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870",	
		["units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc"] = "units/pd2_mod_sharks/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870",	
		["units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"] = "units/pd2_mod_sharks/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870",	
		["units/payday2/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc"] = "units/pd2_mod_sharks/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_r870_sc/ene_zeal_swat_heavy_r870_sc"] = "units/pd2_mod_omnia/characters/ene_omnia_heavy_r870/ene_omnia_heavy_r870",
		["units/payday2/characters/ene_shield_1/ene_shield_1"] = "units/pd2_mod_sharks/characters/ene_murky_shield_fbi/ene_murky_shield_fbi",
		["units/payday2/characters/ene_city_shield/ene_city_shield"] = "units/pd2_mod_sharks/characters/ene_murky_shield_fbi/ene_murky_shield_fbi",
		["units/payday2/characters/ene_shield_gensec/ene_shield_gensec"] = "units/pd2_mod_sharks/characters/ene_murky_shield_fbi/ene_murky_shield_fbi",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield"] = "units/pd2_mod_omnia/characters/ene_omnia_shield/ene_omnia_shield",
		["units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"] = "units/pd2_mod_sharks/characters/ene_murky_fbi_tank_r870/ene_murky_fbi_tank_r870",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2"] = "units/pd2_mod_omnia/characters/ene_bulldozer_1/ene_bulldozer_1",
		["units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"] = "units/pd2_mod_sharks/characters/ene_murky_fbi_tank_saiga/ene_murky_fbi_tank_saiga",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3"] = "units/pd2_mod_omnia/characters/ene_bulldozer_2/ene_bulldozer_2",
		["units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"] = "units/pd2_mod_sharks/characters/ene_murky_fbi_tank_m249/ene_murky_fbi_tank_m249",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"] = "units/pd2_mod_omnia/characters/ene_bulldozer_3/ene_bulldozer_3",		
		["units/payday2/characters/ene_medic_m4/ene_medic_m4"] = "units/pd2_mod_sharks/characters/ene_murky_medic_m4/ene_murky_medic_m4",
		["units/payday2/characters/ene_medic_r870/ene_medic_r870"] = "units/pd2_mod_sharks/characters/ene_murky_medic_m4/ene_murky_medic_m4",
		["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = "units/pd2_mod_sharks/characters/ene_murky_sniper/ene_murky_sniper",	
		["units/pd2_dlc_bph/characters/ene_murkywater_sniper/ene_murkywater_sniper"] = "units/pd2_mod_sharks/characters/ene_murky_sniper/ene_murky_sniper",			
		["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = "units/pd2_mod_sharks/characters/ene_murky_sniper/ene_murky_sniper",
		["units/pd2_dlc_bph/characters/ene_murkywater_light/ene_murkywater_light"] = "units/pd2_mod_sharks/characters/ene_swat_heavy_1/ene_swat_heavy_1",
		--Scripted Spawns Only
		--Elite Murky Guards
		["units/payday2/characters/ene_murkywater_1/ene_murkywater_1"] = "units/pd2_mod_nypd/characters/ene_nypd_murky_1/ene_nypd_murky_1",	
		["units/payday2/characters/ene_murkywater_2/ene_murkywater_2"] = "units/pd2_mod_nypd/characters/ene_nypd_murky_2/ene_nypd_murky_2",	
		["units/pd2_dlc_des/characters/ene_murkywater_no_light_not_security/ene_murkywater_no_light_not_security"] = "units/pd2_mod_nypd/characters/ene_nypd_murky_2/ene_nypd_murky_2",	
		["units/pd2_dlc_des/characters/ene_murkywater_not_security_1/ene_murkywater_not_security_1"] = "units/pd2_mod_nypd/characters/ene_nypd_murky_2/ene_nypd_murky_2",	
		["units/pd2_dlc_des/characters/ene_murkywater_not_security_2/ene_murkywater_not_security_2"] = "units/pd2_mod_nypd/characters/ene_nypd_murky_2/ene_nypd_murky_2",	
		["units/pd2_dlc_berry/characters/ene_murkywater_no_light/ene_murkywater_no_light"] = "units/pd2_mod_nypd/characters/ene_nypd_murky_2/ene_nypd_murky_2",	
		["units/payday2/characters/ene_secret_service_1/ene_secret_service_1"] = "units/pd2_mod_sharks/characters/ene_murky_security_c45/ene_murky_security_c45",	
		["units/payday2/characters/ene_secret_service_2/ene_secret_service_2"] = "units/pd2_mod_sharks/characters/ene_murky_security_mp5/ene_murky_security_mp5",
		["units/payday2/characters/ene_security_1/ene_security_1"] = "units/pd2_mod_sharks/characters/ene_murky_security_c45/ene_murky_security_c45",
		["units/payday2/characters/ene_security_2/ene_security_2"] = "units/pd2_mod_sharks/characters/ene_murky_security_mp5/ene_murky_security_mp5",
		["units/payday2/characters/ene_security_3/ene_security_3"] = "units/pd2_mod_sharks/characters/ene_murky_security_r870/ene_murky_security_r870",
		["units/payday2/characters/ene_security_4/ene_security_4"] = "units/pd2_mod_sharks/characters/ene_murky_security_raging_bull/ene_murky_security_raging_bull"		
	}
	
--Reaper Scripted Spawn Replacements
local russia = {
		["units/payday2/characters/ene_spook_1/ene_spook_1"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg",
		["units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg",
		["units/payday2/characters/ene_cop_1/ene_cop_1"] = "units/pd2_dlc_mad/characters/ene_akan_cs_cop_c45_sc/ene_akan_cs_cop_c45_sc",
		["units/payday2/characters/ene_cop_2/ene_cop_2"] = "units/pd2_dlc_mad/characters/ene_akan_cs_cop_raging_bull_sc/ene_akan_cs_cop_raging_bull_sc",
		["units/payday2/characters/ene_cop_3/ene_cop_3"] = "units/pd2_dlc_mad/characters/ene_akan_cs_cop_akmsu_smg_sc/ene_akan_cs_cop_akmsu_smg_sc",
		["units/payday2/characters/ene_cop_4/ene_cop_4"] = "units/pd2_dlc_mad/characters/ene_akan_cs_cop_r870/ene_akan_cs_cop_r870",
		["units/payday2/characters/ene_swat_1/ene_swat_1"] = "units/pd2_dlc_mad/characters/ene_akan_cs_swat_zeal/ene_akan_cs_swat_zeal",
		["units/payday2/characters/ene_swat_2/ene_swat_2"] = "units/pd2_dlc_mad/characters/ene_akan_cs_swat_r870/ene_akan_cs_swat_r870",
		["units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"] = "units/pd2_dlc_mad/characters/ene_akan_cs_heavy_ak47_ass/ene_akan_cs_heavy_ak47_ass",
		["units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"] = "units/pd2_dlc_mad/characters/ene_akan_cs_heavy_r870/ene_akan_cs_heavy_r870",		
		["units/payday2/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc"] = "units/pd2_dlc_mad/characters/ene_akan_cs_heavy_r870/ene_akan_cs_heavy_r870",
		["units/payday2/characters/ene_tazer_1/ene_tazer_1"] = "units/pd2_dlc_mad/characters/ene_akan_cs_tazer_ak47_ass/ene_akan_cs_tazer_ak47_ass",
		["units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"] = "units/pd2_dlc_mad/characters/ene_akan_cs_tazer_ak47_ass/ene_akan_cs_tazer_ak47_ass",
		["units/payday2/characters/ene_shield_2/ene_shield_2"] = "units/pd2_dlc_mad/characters/ene_akan_cs_shield_c45/ene_akan_cs_shield_c45",
		["units/payday2/characters/ene_fbi_1/ene_fbi_1"] = "units/payday2/characters/ene_fbi_1/ene_fbi_1",
		["units/payday2/characters/ene_fbi_2/ene_fbi_2"] = "units/payday2/characters/ene_fbi_2/ene_fbi_2",
		["units/payday2/characters/ene_fbi_3/ene_fbi_3"] = "units/payday2/characters/ene_fbi_3/ene_fbi_3",
		["units/payday2/characters/ene_fbi_3/ene_fbi_3"] = "units/pd2_dlc_mad/characters/ene_akan_cs_swat_zeal/ene_akan_cs_swat_zeal",
		["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass",
		["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ak47_ass_sc/ene_akan_fbi_swat_dw_ak47_ass_sc",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ak47_ass_sc/ene_akan_fbi_swat_dw_ak47_ass_sc",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ak47_ass_sc/ene_akan_fbi_swat_dw_ak47_ass_sc",
		["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870",
		["units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ump/ene_akan_fbi_swat_ump",
		["units/payday2/characters/ene_city_swat_2/ene_city_swat_2"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_r870_sc/ene_akan_fbi_swat_dw_r870_sc",
		["units/payday2/characters/ene_city_swat_3/ene_city_swat_3"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ump/ene_akan_fbi_swat_dw_ump",		
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_2/ene_zeal_city_2"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_r870_sc/ene_akan_fbi_swat_dw_r870_sc",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_3/ene_zeal_city_3"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ump/ene_akan_fbi_swat_dw_ump",	
		["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36",	
		["units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw/ene_akan_fbi_heavy_dw",	
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw/ene_akan_fbi_heavy_dw",	
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw/ene_akan_fbi_heavy_dw",	
		["units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_r870/ene_akan_fbi_heavy_r870",	
		["units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw_r870/ene_akan_fbi_heavy_dw_r870",	
		["units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw_r870/ene_akan_fbi_heavy_dw_r870",	
		["units/payday2/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw_r870/ene_akan_fbi_heavy_dw_r870",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_r870_sc/ene_zeal_swat_heavy_r870_sc"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw_r870/ene_akan_fbi_heavy_dw_r870",
		["units/payday2/characters/ene_shield_1/ene_shield_1"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_shield_sr2_smg/ene_akan_fbi_shield_sr2_smg",
		["units/payday2/characters/ene_city_shield/ene_city_shield"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_shield_dw_sr2_smg/ene_akan_fbi_shield_dw_sr2_smg",
		["units/payday2/characters/ene_shield_gensec/ene_shield_gensec"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_shield_dw_sr2_smg/ene_akan_fbi_shield_dw_sr2_smg",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_shield_dw_sr2_smg/ene_akan_fbi_shield_dw_sr2_smg",
		["units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870",
		["units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga",
		["units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg",		
		["units/payday2/characters/ene_medic_m4/ene_medic_m4"] = "units/pd2_dlc_mad/characters/ene_akan_medic_bob/ene_akan_medic_bob",
		["units/payday2/characters/ene_medic_r870/ene_medic_r870"] = "units/pd2_dlc_mad/characters/ene_akan_medic_bob/ene_akan_medic_bob",
		["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = "units/pd2_dlc_mad/characters/ene_akan_cs_swat_sniper_svd_snp/ene_akan_cs_swat_sniper_svd_snp",	
		["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = "units/pd2_dlc_mad/characters/ene_akan_cs_swat_sniper_svd_snp/ene_akan_cs_swat_sniper_svd_snp"		
	}	
local russia_2 = {
		["units/payday2/characters/ene_spook_1/ene_spook_1"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg",
		["units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_spooc_asval_smg/ene_akan_fbi_spooc_asval_smg",
		["units/payday2/characters/ene_cop_1/ene_cop_1"] = "units/payday2/characters/ene_cop_1_forest/ene_cop_1_forest",
		["units/payday2/characters/ene_cop_2/ene_cop_2"] = "units/payday2/characters/ene_cop_2_forest/ene_cop_2_forest",
		["units/payday2/characters/ene_cop_3/ene_cop_3"] = "units/payday2/characters/ene_cop_1_forest/ene_cop_1_forest",
		["units/payday2/characters/ene_cop_4/ene_cop_4"] = "units/payday2/characters/ene_cop_2_forest/ene_cop_2_forest",
		["units/payday2/characters/ene_swat_1/ene_swat_1"] = "units/pd2_dlc_mad/characters/ene_akan_cs_swat_zeal/ene_akan_cs_swat_zeal",
		["units/payday2/characters/ene_swat_2/ene_swat_2"] = "units/pd2_dlc_mad/characters/ene_akan_cs_swat_r870/ene_akan_cs_swat_r870",
		["units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"] = "units/pd2_dlc_mad/characters/ene_akan_cs_heavy_ak47_ass/ene_akan_cs_heavy_ak47_ass",
		["units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"] = "units/pd2_dlc_mad/characters/ene_akan_cs_heavy_r870/ene_akan_cs_heavy_r870",		
		["units/payday2/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc"] = "units/pd2_dlc_mad/characters/ene_akan_cs_heavy_r870/ene_akan_cs_heavy_r870",
		["units/payday2/characters/ene_tazer_1/ene_tazer_1"] = "units/pd2_dlc_mad/characters/ene_akan_cs_tazer_ak47_ass/ene_akan_cs_tazer_ak47_ass",
		["units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"] = "units/pd2_dlc_mad/characters/ene_akan_cs_tazer_ak47_ass/ene_akan_cs_tazer_ak47_ass",
		["units/payday2/characters/ene_shield_2/ene_shield_2"] = "units/pd2_dlc_mad/characters/ene_akan_cs_shield_c45/ene_akan_cs_shield_c45",
		["units/payday2/characters/ene_fbi_1/ene_fbi_1"] = "units/payday2/characters/ene_fbi_1/ene_fbi_1",
		["units/payday2/characters/ene_fbi_2/ene_fbi_2"] = "units/payday2/characters/ene_fbi_2/ene_fbi_2",
		["units/payday2/characters/ene_fbi_3/ene_fbi_3"] = "units/payday2/characters/ene_fbi_3/ene_fbi_3",
		["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass",
		["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ak47_ass_sc/ene_akan_fbi_swat_dw_ak47_ass_sc",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ak47_ass_sc/ene_akan_fbi_swat_dw_ak47_ass_sc",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ak47_ass_sc/ene_akan_fbi_swat_dw_ak47_ass_sc",
		["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_r870/ene_akan_fbi_swat_r870",
		["units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ump/ene_akan_fbi_swat_ump",
		["units/payday2/characters/ene_city_swat_2/ene_city_swat_2"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_r870_sc/ene_akan_fbi_swat_dw_r870_sc",
		["units/payday2/characters/ene_city_swat_3/ene_city_swat_3"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ump/ene_akan_fbi_swat_dw_ump",		
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_2/ene_zeal_city_2"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_r870_sc/ene_akan_fbi_swat_dw_r870_sc",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_3/ene_zeal_city_3"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ump/ene_akan_fbi_swat_dw_ump",	
		["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_g36/ene_akan_fbi_heavy_g36",	
		["units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw/ene_akan_fbi_heavy_dw",	
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw/ene_akan_fbi_heavy_dw",	
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw/ene_akan_fbi_heavy_dw",	
		["units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_r870/ene_akan_fbi_heavy_r870",	
		["units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw_r870/ene_akan_fbi_heavy_dw_r870",	
		["units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw_r870/ene_akan_fbi_heavy_dw_r870",	
		["units/payday2/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw_r870/ene_akan_fbi_heavy_dw_r870",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_r870_sc/ene_zeal_swat_heavy_r870_sc"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_heavy_dw_r870/ene_akan_fbi_heavy_dw_r870",
		["units/payday2/characters/ene_shield_1/ene_shield_1"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_shield_sr2_smg/ene_akan_fbi_shield_sr2_smg",
		["units/payday2/characters/ene_city_shield/ene_city_shield"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_shield_dw_sr2_smg/ene_akan_fbi_shield_dw_sr2_smg",
		["units/payday2/characters/ene_shield_gensec/ene_shield_gensec"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_shield_dw_sr2_smg/ene_akan_fbi_shield_dw_sr2_smg",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_shield_dw_sr2_smg/ene_akan_fbi_shield_dw_sr2_smg",
		["units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870",
		["units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga",
		["units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"] = "units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg",		
		["units/payday2/characters/ene_medic_m4/ene_medic_m4"] = "units/pd2_dlc_mad/characters/ene_akan_medic_bob/ene_akan_medic_bob",
		["units/payday2/characters/ene_medic_r870/ene_medic_r870"] = "units/pd2_dlc_mad/characters/ene_akan_medic_bob/ene_akan_medic_bob",
		["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = "units/pd2_dlc_mad/characters/ene_akan_cs_swat_sniper_svd_snp/ene_akan_cs_swat_sniper_svd_snp",	
		["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = "units/pd2_dlc_mad/characters/ene_akan_cs_swat_sniper_svd_snp/ene_akan_cs_swat_sniper_svd_snp"		
	}	
	
	--Zombie Scripted Spawn Replacements
	local zombie = {
		["units/payday2/characters/ene_spook_1/ene_spook_1"] = "units/pd2_dlc_hvh/characters/ene_spook_hvh_1/ene_spook_hvh_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker"] = "units/pd2_mod_halloween/characters/ene_zeal_cloaker/ene_zeal_cloaker",
		["units/payday2/characters/ene_cop_1/ene_cop_1"] = "units/pd2_dlc_hvh/characters/ene_cop_hvh_1/ene_cop_hvh_1",
		["units/payday2/characters/ene_cop_2/ene_cop_2"] = "units/pd2_dlc_hvh/characters/ene_cop_hvh_2/ene_cop_hvh_2",
		["units/payday2/characters/ene_cop_3/ene_cop_3"] = "units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3",
		["units/payday2/characters/ene_cop_4/ene_cop_4"] = "units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4",
		["units/payday2/characters/ene_swat_1/ene_swat_1"] = "units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1",
		["units/payday2/characters/ene_swat_2/ene_swat_2"] = "units/pd2_dlc_hvh/characters/ene_swat_hvh_2/ene_swat_hvh_2",
		["units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"] = "units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1",
		["units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"] = "units/pd2_mod_halloween/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc",		
		["units/payday2/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc"] = "units/pd2_mod_halloween/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc",
		["units/payday2/characters/ene_tazer_1/ene_tazer_1"] = "units/pd2_dlc_hvh/characters/ene_tazer_hvh_1/ene_tazer_hvh_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"] = "units/pd2_mod_halloween/characters/ene_zeal_tazer/ene_zeal_tazer",
		["units/payday2/characters/ene_shield_2/ene_shield_2"] = "units/pd2_dlc_hvh/characters/ene_shield_hvh_2/ene_shield_hvh_2",
		["units/payday2/characters/ene_fbi_1/ene_fbi_1"] = "units/payday2/characters/ene_fbi_1/ene_fbi_1",
		["units/payday2/characters/ene_fbi_2/ene_fbi_2"] = "units/payday2/characters/ene_fbi_2/ene_fbi_2",
		["units/payday2/characters/ene_fbi_3/ene_fbi_3"] = "units/payday2/characters/ene_fbi_3/ene_fbi_3",
		["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = "units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1",
		["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/pd2_mod_halloween/characters/ene_city_swat_1/ene_city_swat_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"] = "units/pd2_mod_halloween/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1"] = "units/pd2_mod_halloween/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = "units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2",
		["units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"] = "units/pd2_mod_halloween/characters/ene_fbi_swat_3/ene_fbi_swat_3",
		["units/payday2/characters/ene_city_swat_2/ene_city_swat_2"] = "units/pd2_mod_halloween/characters/ene_city_swat_2/ene_city_swat_2",
		["units/payday2/characters/ene_city_swat_3/ene_city_swat_3"] = "units/pd2_mod_halloween/characters/ene_city_swat_3/ene_city_swat_3",		
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_2/ene_zeal_city_2"] = "units/pd2_mod_halloween/characters/ene_zeal_city_2/ene_zeal_city_2",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_3/ene_zeal_city_3"] = "units/pd2_mod_halloween/characters/ene_zeal_city_3/ene_zeal_city_3",	
		["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = "units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1",	
		["units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"] = "units/pd2_mod_halloween/characters/ene_city_heavy_g36/ene_city_heavy_g36",	
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc"] = "units/pd2_mod_halloween/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc",	
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"] = "units/pd2_mod_halloween/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc",	
		["units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"] = "units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870",	
		["units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc"] = "units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870",	
		["units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"] = "units/pd2_mod_halloween/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc",	
		["units/payday2/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc"] = "units/pd2_mod_halloween/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_r870_sc/ene_zeal_swat_heavy_r870_sc"] = "units/pd2_mod_halloween/characters/ene_zeal_swat_heavy_r870_sc/ene_zeal_swat_heavy_r870_sc",
		["units/payday2/characters/ene_shield_1/ene_shield_1"] = "units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1",
		["units/payday2/characters/ene_city_shield/ene_city_shield"] = "units/pd2_mod_halloween/characters/ene_shield_gensec/ene_shield_gensec",
		["units/payday2/characters/ene_shield_gensec/ene_shield_gensec"] = "units/pd2_mod_halloween/characters/ene_shield_gensec/ene_shield_gensec",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield"] = "units/pd2_mod_halloween/characters/ene_zeal_swat_shield/ene_zeal_swat_shield",
		["units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"] = "units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2"] = "units/pd2_mod_halloween/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2",
		["units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"] = "units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_2/ene_bulldozer_hvh_2",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3"] = "units/pd2_mod_halloween/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3",
		["units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"] = "units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"] = "units/pd2_mod_halloween/characters/ene_zeal_bulldozer/ene_zeal_bulldozer",		
		["units/payday2/characters/ene_medic_m4/ene_medic_m4"] = "units/pd2_mod_halloween/characters/ene_medic_mp5/ene_medic_mp5",
		["units/payday2/characters/ene_medic_r870/ene_medic_r870"] = "units/pd2_mod_halloween/characters/ene_medic_mp5/ene_medic_mp5",
		["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = "units/pd2_dlc_hvh/characters/ene_sniper_hvh_2/ene_sniper_hvh_2",	
		["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = "units/pd2_dlc_hvh/characters/ene_sniper_hvh_2/ene_sniper_hvh_2",
		--Scripted Spawns Only
		["units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"] = "units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw",
		["units/pd2_dlc_help/characters/ene_zeal_bulldozer_halloween/ene_zeal_bulldozer_halloween"] = "units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw"
	}
	
	local zombie_dw = {
		["units/payday2/characters/ene_spook_1/ene_spook_1"] = "units/pd2_dlc_hvh/characters/ene_spook_hvh_1/ene_spook_hvh_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker"] = "units/pd2_mod_halloween/characters/ene_zeal_cloaker/ene_zeal_cloaker",
		["units/payday2/characters/ene_cop_1/ene_cop_1"] = "units/pd2_dlc_hvh/characters/ene_cop_hvh_1/ene_cop_hvh_1",
		["units/payday2/characters/ene_cop_2/ene_cop_2"] = "units/pd2_dlc_hvh/characters/ene_cop_hvh_2/ene_cop_hvh_2",
		["units/payday2/characters/ene_cop_3/ene_cop_3"] = "units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3",
		["units/payday2/characters/ene_cop_4/ene_cop_4"] = "units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4",
		["units/payday2/characters/ene_swat_1/ene_swat_1"] = "units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1",
		["units/payday2/characters/ene_swat_2/ene_swat_2"] = "units/pd2_dlc_hvh/characters/ene_swat_hvh_2/ene_swat_hvh_2",
		["units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"] = "units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1",
		["units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"] = "units/pd2_mod_halloween/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc",		
		["units/payday2/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc"] = "units/pd2_mod_halloween/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc",
		["units/payday2/characters/ene_tazer_1/ene_tazer_1"] = "units/pd2_dlc_hvh/characters/ene_tazer_hvh_1/ene_tazer_hvh_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"] = "units/pd2_mod_halloween/characters/ene_zeal_tazer/ene_zeal_tazer",
		["units/payday2/characters/ene_shield_2/ene_shield_2"] = "units/pd2_dlc_hvh/characters/ene_shield_hvh_2/ene_shield_hvh_2",
		["units/payday2/characters/ene_fbi_1/ene_fbi_1"] = "units/payday2/characters/ene_fbi_1/ene_fbi_1",
		["units/payday2/characters/ene_fbi_2/ene_fbi_2"] = "units/payday2/characters/ene_fbi_2/ene_fbi_2",
		["units/payday2/characters/ene_fbi_3/ene_fbi_3"] = "units/payday2/characters/ene_fbi_3/ene_fbi_3",
		["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = "units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1",
		["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/pd2_mod_halloween/characters/ene_city_swat_1/ene_city_swat_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"] = "units/pd2_mod_halloween/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1"] = "units/pd2_mod_halloween/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = "units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2",
		["units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"] = "units/pd2_mod_halloween/characters/ene_fbi_swat_3/ene_fbi_swat_3",
		["units/payday2/characters/ene_city_swat_2/ene_city_swat_2"] = "units/pd2_mod_halloween/characters/ene_city_swat_2/ene_city_swat_2",
		["units/payday2/characters/ene_city_swat_3/ene_city_swat_3"] = "units/pd2_mod_halloween/characters/ene_city_swat_3/ene_city_swat_3",		
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_2/ene_zeal_city_2"] = "units/pd2_mod_halloween/characters/ene_zeal_city_2/ene_zeal_city_2",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_3/ene_zeal_city_3"] = "units/pd2_mod_halloween/characters/ene_zeal_city_3/ene_zeal_city_3",	
		["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = "units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1",	
		["units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"] = "units/pd2_mod_halloween/characters/ene_city_heavy_g36/ene_city_heavy_g36",	
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc"] = "units/pd2_mod_halloween/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc",	
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"] = "units/pd2_mod_halloween/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc",	
		["units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"] = "units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870",	
		["units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc"] = "units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870",	
		["units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"] = "units/pd2_mod_halloween/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc",	
		["units/payday2/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc"] = "units/pd2_mod_halloween/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_r870_sc/ene_zeal_swat_heavy_r870_sc"] = "units/pd2_mod_halloween/characters/ene_zeal_swat_heavy_r870_sc/ene_zeal_swat_heavy_r870_sc",
		["units/payday2/characters/ene_shield_1/ene_shield_1"] = "units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1",
		["units/payday2/characters/ene_city_shield/ene_city_shield"] = "units/pd2_mod_halloween/characters/ene_shield_gensec/ene_shield_gensec",
		["units/payday2/characters/ene_shield_gensec/ene_shield_gensec"] = "units/pd2_mod_halloween/characters/ene_shield_gensec/ene_shield_gensec",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield"] = "units/pd2_mod_halloween/characters/ene_zeal_swat_shield/ene_zeal_swat_shield",
		["units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"] = "units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2"] = "units/pd2_mod_halloween/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2",
		["units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"] = "units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_2/ene_bulldozer_hvh_2",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3"] = "units/pd2_mod_halloween/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3",
		["units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"] = "units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3",
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"] = "units/pd2_mod_halloween/characters/ene_zeal_bulldozer/ene_zeal_bulldozer",		
		["units/payday2/characters/ene_medic_m4/ene_medic_m4"] = "units/pd2_mod_halloween/characters/ene_medic_mp5/ene_medic_mp5",
		["units/payday2/characters/ene_medic_r870/ene_medic_r870"] = "units/pd2_mod_halloween/characters/ene_medic_mp5/ene_medic_mp5",
		["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = "units/pd2_dlc_hvh/characters/ene_sniper_hvh_2/ene_sniper_hvh_2",	
		["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = "units/pd2_dlc_hvh/characters/ene_sniper_hvh_2/ene_sniper_hvh_2",
		--Scripted Spawns Only
		["units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw"] = "units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4",
		["units/pd2_dlc_help/characters/ene_zeal_bulldozer_halloween/ene_zeal_bulldozer_halloween"] = "units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"
	}		
	
	--Haunted
	local haunted_normal = {
			["units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"] = "units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw",
			["units/payday2/characters/ene_spook_1/ene_spook_1"] = "units/pd2_mod_halloween/characters/ene_skele_swat_haunted/ene_skele_swat_haunted"
		}		
	local haunted_black = {
			["units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"] = "units/pd2_mod_halloween/characters/ene_skele_swat_haunted/ene_skele_swat_haunted",
			["units/payday2/characters/ene_spook_1/ene_spook_1"] = "units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw"
		}		
	local haunted_white = {
			["units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"] = "units/pd2_mod_halloween/characters/ene_skele_swat_haunted/ene_skele_swat_haunted",
			["units/payday2/characters/ene_spook_1/ene_spook_1"] = "units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"
		}	

	--Nail
	local nail = {
			["units/payday2/characters/ene_spook_1/ene_spook_1"] = "units/pd2_dlc_hvh/characters/ene_spook_hvh_1/ene_spook_hvh_1",
			["units/pd2_dlc_gitgud/characters/ene_zeal_cloaker/ene_zeal_cloaker"] = "units/pd2_mod_halloween/characters/ene_zeal_cloaker/ene_zeal_cloaker",
			["units/payday2/characters/ene_cop_1/ene_cop_1"] = "units/pd2_dlc_hvh/characters/ene_cop_hvh_1/ene_cop_hvh_1",
			["units/payday2/characters/ene_cop_2/ene_cop_2"] = "units/pd2_dlc_hvh/characters/ene_cop_hvh_2/ene_cop_hvh_2",
			["units/payday2/characters/ene_cop_3/ene_cop_3"] = "units/pd2_dlc_hvh/characters/ene_cop_hvh_3/ene_cop_hvh_3",
			["units/payday2/characters/ene_cop_4/ene_cop_4"] = "units/pd2_dlc_hvh/characters/ene_cop_hvh_4/ene_cop_hvh_4",
			["units/payday2/characters/ene_swat_1/ene_swat_1"] = "units/pd2_dlc_hvh/characters/ene_swat_hvh_1/ene_swat_hvh_1",
			["units/payday2/characters/ene_swat_2/ene_swat_2"] = "units/pd2_dlc_hvh/characters/ene_swat_hvh_2/ene_swat_hvh_2",
			["units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"] = "units/pd2_dlc_hvh/characters/ene_swat_heavy_hvh_1/ene_swat_heavy_hvh_1",
			["units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"] = "units/pd2_mod_halloween/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc",		
			["units/payday2/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc"] = "units/pd2_mod_halloween/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc",
			["units/payday2/characters/ene_tazer_1/ene_tazer_1"] = "units/pd2_dlc_hvh/characters/ene_tazer_hvh_1/ene_tazer_hvh_1",
			["units/pd2_dlc_gitgud/characters/ene_zeal_tazer/ene_zeal_tazer"] = "units/pd2_mod_halloween/characters/ene_zeal_tazer/ene_zeal_tazer",
			["units/payday2/characters/ene_shield_2/ene_shield_2"] = "units/pd2_dlc_hvh/characters/ene_shield_hvh_2/ene_shield_hvh_2",
		["units/payday2/characters/ene_fbi_1/ene_fbi_1"] = "units/payday2/characters/ene_fbi_1/ene_fbi_1",
		["units/payday2/characters/ene_fbi_2/ene_fbi_2"] = "units/payday2/characters/ene_fbi_2/ene_fbi_2",
		["units/payday2/characters/ene_fbi_3/ene_fbi_3"] = "units/payday2/characters/ene_fbi_3/ene_fbi_3",
			["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = "units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1",
			["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/pd2_mod_halloween/characters/ene_city_swat_1/ene_city_swat_1",
			["units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"] = "units/pd2_mod_halloween/characters/ene_zeal_city_1/ene_zeal_city_1",
			["units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1"] = "units/pd2_mod_halloween/characters/ene_zeal_city_1/ene_zeal_city_1",
			["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = "units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_2/ene_fbi_swat_hvh_2",
			["units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"] = "units/pd2_mod_halloween/characters/ene_fbi_swat_3/ene_fbi_swat_3",
			["units/payday2/characters/ene_city_swat_2/ene_city_swat_2"] = "units/pd2_mod_halloween/characters/ene_city_swat_2/ene_city_swat_2",
			["units/payday2/characters/ene_city_swat_3/ene_city_swat_3"] = "units/pd2_mod_halloween/characters/ene_city_swat_3/ene_city_swat_3",		
			["units/pd2_dlc_gitgud/characters/ene_zeal_city_2/ene_zeal_city_2"] = "units/pd2_mod_halloween/characters/ene_zeal_city_2/ene_zeal_city_2",
			["units/pd2_dlc_gitgud/characters/ene_zeal_city_3/ene_zeal_city_3"] = "units/pd2_mod_halloween/characters/ene_zeal_city_3/ene_zeal_city_3",	
			["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = "units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_1/ene_fbi_heavy_hvh_1",	
			["units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"] = "units/pd2_mod_halloween/characters/ene_city_heavy_g36/ene_city_heavy_g36",	
			["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc"] = "units/pd2_mod_halloween/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc",	
			["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"] = "units/pd2_mod_halloween/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc",	
			["units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"] = "units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870",	
			["units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc"] = "units/pd2_dlc_hvh/characters/ene_fbi_heavy_hvh_r870/ene_fbi_heavy_hvh_r870",	
			["units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"] = "units/pd2_mod_halloween/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc",	
			["units/payday2/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc"] = "units/pd2_mod_halloween/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc",
			["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_r870_sc/ene_zeal_swat_heavy_r870_sc"] = "units/pd2_mod_halloween/characters/ene_zeal_swat_heavy_r870_sc/ene_zeal_swat_heavy_r870_sc",
			["units/payday2/characters/ene_shield_1/ene_shield_1"] = "units/pd2_dlc_hvh/characters/ene_shield_hvh_1/ene_shield_hvh_1",
			["units/payday2/characters/ene_city_shield/ene_city_shield"] = "units/pd2_mod_halloween/characters/ene_shield_gensec/ene_shield_gensec",
			["units/payday2/characters/ene_shield_gensec/ene_shield_gensec"] = "units/pd2_mod_halloween/characters/ene_shield_gensec/ene_shield_gensec",
			["units/pd2_dlc_gitgud/characters/ene_zeal_swat_shield/ene_zeal_swat_shield"] = "units/pd2_mod_halloween/characters/ene_zeal_swat_shield/ene_zeal_swat_shield",
			["units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"] = "units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1",
			["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2"] = "units/pd2_mod_halloween/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2",
			["units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"] = "units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_2/ene_bulldozer_hvh_2",
			["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3"] = "units/pd2_mod_halloween/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3",
			["units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"] = "units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3",
			["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"] = "units/pd2_mod_halloween/characters/ene_zeal_bulldozer/ene_zeal_bulldozer",		
			["units/payday2/characters/ene_medic_m4/ene_medic_m4"] = "units/pd2_mod_halloween/characters/ene_medic_mp5/ene_medic_mp5",
			["units/payday2/characters/ene_medic_r870/ene_medic_r870"] = "units/pd2_mod_halloween/characters/ene_medic_mp5/ene_medic_mp5",
			["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = "units/pd2_dlc_hvh/characters/ene_sniper_hvh_2/ene_sniper_hvh_2",	
			["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = "units/pd2_dlc_hvh/characters/ene_sniper_hvh_2/ene_sniper_hvh_2",
			--Scripted Spawns Only
			["units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"] = "units/pd2_mod_halloween/characters/ene_skele_swat/ene_skele_swat",
			["units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw"] = "units/pd2_mod_halloween/characters/ene_skele_swat/ene_skele_swat"
		}				
	
--NYPD Scripted Spawn Replacements
local nypd = {
		["units/payday2/characters/ene_spook_1/ene_spook_1"] = "units/pd2_mod_nypd/characters/ene_spook_1/ene_spook_1",
		["units/payday2/characters/ene_cop_1/ene_cop_1"] = "units/pd2_mod_nypd/characters/ene_cop_1/ene_cop_1",
		["units/payday2/characters/ene_cop_2/ene_cop_2"] = "units/pd2_mod_nypd/characters/ene_cop_2/ene_cop_2",
		["units/payday2/characters/ene_cop_3/ene_cop_3"] = "units/pd2_mod_nypd/characters/ene_cop_3/ene_cop_3",
		["units/payday2/characters/ene_cop_4/ene_cop_4"] = "units/pd2_mod_nypd/characters/ene_cop_4/ene_cop_4",
		["units/payday2/characters/ene_swat_1/ene_swat_1"] = "units/pd2_mod_nypd/characters/ene_nypd_swat_1/ene_nypd_swat_1",
		["units/payday2/characters/ene_swat_2/ene_swat_2"] = "units/pd2_mod_nypd/characters/ene_nypd_swat_2/ene_nypd_swat_2",
		["units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"] = "units/pd2_mod_nypd/characters/ene_nypd_heavy_m4/ene_nypd_heavy_m4",
		["units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"] = "units/pd2_mod_nypd/characters/ene_nypd_heavy_r870/ene_nypd_heavy_r870",		
		["units/payday2/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc"] = "units/pd2_mod_nypd/characters/ene_nypd_heavy_r870/ene_nypd_heavy_r870",
		["units/payday2/characters/ene_tazer_1/ene_tazer_1"] = "units/pd2_mod_nypd/characters/ene_tazer_1/ene_tazer_1",
		["units/payday2/characters/ene_shield_2/ene_shield_2"] = "units/pd2_mod_nypd/characters/ene_nypd_shield/ene_nypd_shield",
		["units/payday2/characters/ene_fbi_2/ene_fbi_2"] = "units/pd2_mod_nypd/characters/ene_fbi_2/ene_fbi_2",
		["units/payday2/characters/ene_fbi_3/ene_fbi_3"] = "units/pd2_mod_nypd/characters/ene_fbi_3/ene_fbi_3",
		["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = "units/pd2_mod_nypd/characters/ene_fbi_swat_1/ene_fbi_swat_1",
		["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/payday2/characters/ene_city_swat_1_sc/ene_city_swat_1_sc",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = "units/pd2_mod_nypd/characters/ene_fbi_swat_2/ene_fbi_swat_2",
		["units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"] = "units/pd2_mod_nypd/characters/ene_fbi_swat_3/ene_fbi_swat_3",
		["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = "units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",		
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"] = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc",	
		["units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"] = "units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc",	
		["units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc"] = "units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc",	
		["units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"] = "units/payday2/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc",	
		["units/payday2/characters/ene_shield_1/ene_shield_1"] = "units/pd2_mod_nypd/characters/ene_shield_1/ene_shield_1",
		["units/payday2/characters/ene_city_shield/ene_city_shield"] = "units/payday2/characters/ene_shield_gensec/ene_shield_gensec",
		["units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"] = "units/pd2_mod_nypd/characters/ene_bulldozer_1/ene_bulldozer_1",
		["units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"] = "units/pd2_mod_nypd/characters/ene_bulldozer_2/ene_bulldozer_2",
		["units/payday2/characters/ene_medic_m4/ene_medic_m4"] = "units/pd2_mod_nypd/characters/ene_nypd_medic/ene_nypd_medic",
		["units/payday2/characters/ene_medic_r870/ene_medic_r870"] = "units/pd2_mod_nypd/characters/ene_nypd_medic/ene_nypd_medic",
		["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = "units/pd2_mod_nypd/characters/ene_sniper_1/ene_sniper_1",	
		["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = "units/pd2_mod_nypd/characters/ene_sniper_1/ene_sniper_1",
		--Scripted Spawns Only
		--Green Guys For SH
		["units/payday2/characters/ene_murkywater_1/ene_murkywater_1"] = "units/pd2_mod_sharks/characters/ene_fbi_swat_1/ene_fbi_swat_1",	
		["units/payday2/characters/ene_murkywater_2/ene_murkywater_2"] = "units/pd2_mod_sharks/characters/ene_fbi_swat_3/ene_fbi_swat_3"		
	}
local nypd_dw = {
		["units/payday2/characters/ene_spook_1/ene_spook_1"] = "units/pd2_mod_nypd/characters/ene_spook_1/ene_spook_1",
		["units/payday2/characters/ene_cop_1/ene_cop_1"] = "units/pd2_mod_nypd/characters/ene_cop_1/ene_cop_1",
		["units/payday2/characters/ene_cop_2/ene_cop_2"] = "units/pd2_mod_nypd/characters/ene_cop_2/ene_cop_2",
		["units/payday2/characters/ene_cop_3/ene_cop_3"] = "units/pd2_mod_nypd/characters/ene_cop_3/ene_cop_3",
		["units/payday2/characters/ene_cop_4/ene_cop_4"] = "units/pd2_mod_nypd/characters/ene_cop_4/ene_cop_4",
		["units/payday2/characters/ene_swat_1/ene_swat_1"] = "units/pd2_mod_nypd/characters/ene_nypd_swat_1/ene_nypd_swat_1",
		["units/payday2/characters/ene_swat_2/ene_swat_2"] = "units/pd2_mod_nypd/characters/ene_nypd_swat_2/ene_nypd_swat_2",
		["units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"] = "units/pd2_mod_nypd/characters/ene_nypd_heavy_m4/ene_nypd_heavy_m4",
		["units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"] = "units/pd2_mod_nypd/characters/ene_nypd_heavy_r870/ene_nypd_heavy_r870",		
		["units/payday2/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc"] = "units/pd2_mod_nypd/characters/ene_nypd_heavy_r870/ene_nypd_heavy_r870",
		["units/payday2/characters/ene_tazer_1/ene_tazer_1"] = "units/pd2_mod_nypd/characters/ene_tazer_1/ene_tazer_1",
		["units/payday2/characters/ene_shield_2/ene_shield_2"] = "units/pd2_mod_nypd/characters/ene_nypd_shield/ene_nypd_shield",
		["units/payday2/characters/ene_fbi_2/ene_fbi_2"] = "units/pd2_mod_nypd/characters/ene_fbi_2/ene_fbi_2",
		["units/payday2/characters/ene_fbi_3/ene_fbi_3"] = "units/pd2_mod_nypd/characters/ene_fbi_3/ene_fbi_3",
		["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = "units/pd2_mod_nypd/characters/ene_fbi_swat_1/ene_fbi_swat_1",
		["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/payday2/characters/ene_city_swat_1_sc/ene_city_swat_1_sc",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = "units/pd2_mod_nypd/characters/ene_fbi_swat_2/ene_fbi_swat_2",
		["units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"] = "units/pd2_mod_nypd/characters/ene_fbi_swat_3/ene_fbi_swat_3",
		["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = "units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",		
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"] = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc",	
		["units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"] = "units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc",	
		["units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc"] = "units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc",	
		["units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"] = "units/payday2/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc",	
		["units/payday2/characters/ene_shield_1/ene_shield_1"] = "units/pd2_mod_nypd/characters/ene_shield_1/ene_shield_1",
		["units/payday2/characters/ene_city_shield/ene_city_shield"] = "units/payday2/characters/ene_shield_gensec/ene_shield_gensec",
		["units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"] = "units/pd2_mod_nypd/characters/ene_bulldozer_1/ene_bulldozer_1",
		["units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"] = "units/pd2_mod_nypd/characters/ene_bulldozer_2/ene_bulldozer_2",
		["units/payday2/characters/ene_medic_m4/ene_medic_m4"] = "units/pd2_mod_nypd/characters/ene_nypd_medic/ene_nypd_medic",
		["units/payday2/characters/ene_medic_r870/ene_medic_r870"] = "units/pd2_mod_nypd/characters/ene_nypd_medic/ene_nypd_medic",
		--Need to add NYPD Snipers at some point
		["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = "units/pd2_mod_nypd/characters/ene_sniper_1/ene_sniper_1",	
		["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = "units/pd2_mod_nypd/characters/ene_sniper_1/ene_sniper_1",
		--Scripted Spawns Only
		--Green Guys For SH
		["units/payday2/characters/ene_murkywater_1/ene_murkywater_1"] = "units/pd2_mod_sharks/characters/ene_fbi_swat_1/ene_fbi_swat_1",	
		["units/payday2/characters/ene_murkywater_2/ene_murkywater_2"] = "units/pd2_mod_sharks/characters/ene_fbi_swat_3/ene_fbi_swat_3"
	}	
local nypd_ds = {
		["units/payday2/characters/ene_spook_1/ene_spook_1"] = "units/pd2_mod_nypd/characters/ene_spook_1/ene_spook_1",
		["units/payday2/characters/ene_cop_1/ene_cop_1"] = "units/pd2_mod_nypd/characters/ene_cop_1/ene_cop_1",
		["units/payday2/characters/ene_cop_2/ene_cop_2"] = "units/pd2_mod_nypd/characters/ene_cop_2/ene_cop_2",
		["units/payday2/characters/ene_cop_3/ene_cop_3"] = "units/pd2_mod_nypd/characters/ene_cop_3/ene_cop_3",
		["units/payday2/characters/ene_cop_4/ene_cop_4"] = "units/pd2_mod_nypd/characters/ene_cop_4/ene_cop_4",
		["units/payday2/characters/ene_swat_1/ene_swat_1"] = "units/pd2_mod_nypd/characters/ene_nypd_swat_1/ene_nypd_swat_1",
		["units/payday2/characters/ene_swat_2/ene_swat_2"] = "units/pd2_mod_nypd/characters/ene_nypd_swat_2/ene_nypd_swat_2",
		["units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"] = "units/pd2_mod_nypd/characters/ene_nypd_heavy_m4/ene_nypd_heavy_m4",
		["units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"] = "units/pd2_mod_nypd/characters/ene_nypd_heavy_r870/ene_nypd_heavy_r870",		
		["units/payday2/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc"] = "units/pd2_mod_nypd/characters/ene_nypd_heavy_r870/ene_nypd_heavy_r870",
		["units/payday2/characters/ene_tazer_1/ene_tazer_1"] = "units/pd2_mod_nypd/characters/ene_tazer_1/ene_tazer_1",
		["units/payday2/characters/ene_shield_2/ene_shield_2"] = "units/pd2_mod_nypd/characters/ene_nypd_shield/ene_nypd_shield",
		["units/payday2/characters/ene_fbi_2/ene_fbi_2"] = "units/pd2_mod_nypd/characters/ene_fbi_2/ene_fbi_2",
		["units/payday2/characters/ene_fbi_3/ene_fbi_3"] = "units/pd2_mod_nypd/characters/ene_fbi_3/ene_fbi_3",
		["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = "units/pd2_mod_nypd/characters/ene_fbi_swat_1/ene_fbi_swat_1",
		["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/payday2/characters/ene_city_swat_1_sc/ene_city_swat_1_sc",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = "units/pd2_mod_nypd/characters/ene_fbi_swat_2/ene_fbi_swat_2",
		["units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"] = "units/pd2_mod_nypd/characters/ene_fbi_swat_3/ene_fbi_swat_3",
		["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = "units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",		
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"] = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc",	
		["units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"] = "units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc",	
		["units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc"] = "units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc",	
		["units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"] = "units/payday2/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc",	
		["units/payday2/characters/ene_shield_1/ene_shield_1"] = "units/pd2_mod_nypd/characters/ene_shield_1/ene_shield_1",
		["units/payday2/characters/ene_city_shield/ene_city_shield"] = "units/payday2/characters/ene_shield_gensec/ene_shield_gensec",
		["units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"] = "units/pd2_mod_nypd/characters/ene_bulldozer_1/ene_bulldozer_1",
		["units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"] = "units/pd2_mod_nypd/characters/ene_bulldozer_2/ene_bulldozer_2",
		["units/payday2/characters/ene_medic_m4/ene_medic_m4"] = "units/pd2_mod_nypd/characters/ene_nypd_medic/ene_nypd_medic",
		["units/payday2/characters/ene_medic_r870/ene_medic_r870"] = "units/pd2_mod_nypd/characters/ene_nypd_medic/ene_nypd_medic",
		--Need to add NYPD Snipers at some point
		["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = "units/pd2_mod_nypd/characters/ene_sniper_1/ene_sniper_1",	
		["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = "units/pd2_mod_nypd/characters/ene_sniper_1/ene_sniper_1",
		--Scripted Spawns Only
		--Green Guys For SH
		["units/payday2/characters/ene_murkywater_1/ene_murkywater_1"] = "units/pd2_mod_sharks/characters/ene_fbi_swat_1/ene_fbi_swat_1",	
		["units/payday2/characters/ene_murkywater_2/ene_murkywater_2"] = "units/pd2_mod_sharks/characters/ene_fbi_swat_3/ene_fbi_swat_3"
	}		

--LAPD Scripted Spawn Replacements
local lapd = {
		["units/payday2/characters/ene_cop_1/ene_cop_1"] = "units/pd2_mod_lapd/characters/ene_cop_1/ene_cop_1",
		["units/payday2/characters/ene_cop_2/ene_cop_2"] = "units/pd2_mod_lapd/characters/ene_cop_2/ene_cop_2",
		["units/payday2/characters/ene_cop_3/ene_cop_3"] = "units/pd2_mod_lapd/characters/ene_cop_3/ene_cop_3",
		["units/payday2/characters/ene_cop_4/ene_cop_4"] = "units/pd2_mod_lapd/characters/ene_cop_4/ene_cop_4",
		["units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"] = "units/pd2_mod_lapd/characters/ene_cop_1/ene_cop_1",
		["units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2"] = "units/pd2_mod_lapd/characters/ene_cop_2/ene_cop_2",
		["units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"] = "units/pd2_mod_lapd/characters/ene_cop_3/ene_cop_3",
		["units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"] = "units/pd2_mod_lapd/characters/ene_cop_4/ene_cop_4",
		["units/payday2/characters/ene_swat_1/ene_swat_1"] = "units/pd2_mod_lapd/characters/ene_swat_1/ene_swat_1",
		["units/payday2/characters/ene_swat_2/ene_swat_2"] = "units/pd2_mod_lapd/characters/ene_swat_2/ene_swat_2",
		["units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"] = "units/pd2_mod_lapd/characters/ene_swat_heavy_1/ene_swat_heavy_1",
		["units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"] = "units/pd2_mod_lapd/characters/ene_swat_heavy_r870/ene_swat_heavy_r870",		
		["units/payday2/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc"] = "units/pd2_mod_lapd/characters/ene_swat_heavy_r870/ene_swat_heavy_r870",
		["units/payday2/characters/ene_shield_2/ene_shield_2"] = "units/pd2_mod_lapd/characters/ene_shield_2/ene_shield_2",
		["units/payday2/characters/ene_fbi_2/ene_fbi_2"] = "units/pd2_mod_lapd/characters/ene_fbi_2/ene_fbi_2",
		["units/payday2/characters/ene_fbi_3/ene_fbi_3"] = "units/pd2_mod_lapd/characters/ene_fbi_3/ene_fbi_3",
		["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = "units/pd2_mod_lapd/characters/ene_fbi_swat_1/ene_fbi_swat_1",
		["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/pd2_mod_lapd/characters/ene_city_swat_1/ene_city_swat_1",
		["units/payday2/characters/ene_city_swat_2/ene_city_swat_2"] = "units/pd2_mod_lapd/characters/ene_city_swat_2/ene_city_swat_2",
		["units/payday2/characters/ene_city_swat_3/ene_city_swat_3"] = "units/pd2_mod_lapd/characters/ene_city_swat_3/ene_city_swat_3",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = "units/pd2_mod_lapd/characters/ene_fbi_swat_2/ene_fbi_swat_2",
		["units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"] = "units/pd2_mod_lapd/characters/ene_fbi_swat_3/ene_fbi_swat_3",
		["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = "units/pd2_mod_lapd/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",		
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"] = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc",	
		["units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"] = "units/pd2_mod_lapd/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc",	
		["units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc"] = "units/pd2_mod_lapd/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc",	
		["units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"] = "units/pd2_mod_lapd/characters/ene_city_heavy_g36/ene_city_heavy_g36",	
		["units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"] = "units/pd2_mod_lapd/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc",	
		["units/payday2/characters/ene_shield_1/ene_shield_1"] = "units/pd2_mod_lapd/characters/ene_shield_1/ene_shield_1",
		["units/payday2/characters/ene_city_shield/ene_city_shield"] = "units/pd2_mod_lapd/characters/ene_city_shield/ene_city_shield",
		-- snipers
		["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = "units/pd2_mod_lapd/characters/ene_sniper_1/ene_sniper_1",	
		["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = "units/pd2_mod_lapd/characters/ene_sniper_1/ene_sniper_1",
		-- fortnite
		["units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"] = "units/pd2_mod_lapd/characters/ene_bulldozer_3/ene_bulldozer_3",		
		--Scripted Spawns Only
		["units/payday2/characters/ene_murkywater_1/ene_murkywater_1"] = "units/pd2_mod_nypd/characters/ene_nypd_murky_1/ene_nypd_murky_1",	
		["units/payday2/characters/ene_murkywater_2/ene_murkywater_2"] = "units/pd2_mod_nypd/characters/ene_nypd_murky_2/ene_nypd_murky_2"		
	}	
local lapd_dw = {
		["units/payday2/characters/ene_cop_1/ene_cop_1"] = "units/pd2_mod_lapd/characters/ene_cop_1/ene_cop_1",
		["units/payday2/characters/ene_cop_2/ene_cop_2"] = "units/pd2_mod_lapd/characters/ene_cop_2/ene_cop_2",
		["units/payday2/characters/ene_cop_3/ene_cop_3"] = "units/pd2_mod_lapd/characters/ene_cop_3/ene_cop_3",
		["units/payday2/characters/ene_cop_4/ene_cop_4"] = "units/pd2_mod_lapd/characters/ene_cop_4/ene_cop_4",
		["units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"] = "units/pd2_mod_lapd/characters/ene_cop_1/ene_cop_1",
		["units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2"] = "units/pd2_mod_lapd/characters/ene_cop_2/ene_cop_2",
		["units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"] = "units/pd2_mod_lapd/characters/ene_cop_3/ene_cop_3",
		["units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"] = "units/pd2_mod_lapd/characters/ene_cop_4/ene_cop_4",
		["units/payday2/characters/ene_swat_1/ene_swat_1"] = "units/pd2_mod_lapd/characters/ene_swat_1/ene_swat_1",
		["units/payday2/characters/ene_swat_2/ene_swat_2"] = "units/pd2_mod_lapd/characters/ene_swat_2/ene_swat_2",
		["units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"] = "units/pd2_mod_lapd/characters/ene_swat_heavy_1/ene_swat_heavy_1",
		["units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"] = "units/pd2_mod_lapd/characters/ene_swat_heavy_r870/ene_swat_heavy_r870",		
		["units/payday2/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc"] = "units/pd2_mod_lapd/characters/ene_swat_heavy_r870/ene_swat_heavy_r870",
		["units/payday2/characters/ene_shield_2/ene_shield_2"] = "units/pd2_mod_lapd/characters/ene_shield_2/ene_shield_2",
		["units/payday2/characters/ene_fbi_2/ene_fbi_2"] = "units/pd2_mod_lapd/characters/ene_fbi_2/ene_fbi_2",
		["units/payday2/characters/ene_fbi_3/ene_fbi_3"] = "units/pd2_mod_lapd/characters/ene_fbi_3/ene_fbi_3",
		["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = "units/pd2_mod_lapd/characters/ene_fbi_swat_1/ene_fbi_swat_1",
		["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/pd2_mod_lapd/characters/ene_city_swat_1/ene_city_swat_1",
		["units/payday2/characters/ene_city_swat_2/ene_city_swat_2"] = "units/pd2_mod_lapd/characters/ene_city_swat_2/ene_city_swat_2",
		["units/payday2/characters/ene_city_swat_3/ene_city_swat_3"] = "units/pd2_mod_lapd/characters/ene_city_swat_3/ene_city_swat_3",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = "units/pd2_mod_lapd/characters/ene_fbi_swat_2/ene_fbi_swat_2",
		["units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"] = "units/pd2_mod_lapd/characters/ene_fbi_swat_3/ene_fbi_swat_3",
		["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = "units/pd2_mod_lapd/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",		
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"] = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc",	
		["units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"] = "units/pd2_mod_lapd/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc",	
		["units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc"] = "units/pd2_mod_lapd/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc",	
		["units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"] = "units/pd2_mod_lapd/characters/ene_city_heavy_g36/ene_city_heavy_g36",	
		["units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"] = "units/pd2_mod_lapd/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc",	
		["units/payday2/characters/ene_shield_1/ene_shield_1"] = "units/pd2_mod_lapd/characters/ene_shield_1/ene_shield_1",
		["units/payday2/characters/ene_city_shield/ene_city_shield"] = "units/pd2_mod_lapd/characters/ene_city_shield/ene_city_shield",
		-- snipers
		["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = "units/pd2_mod_lapd/characters/ene_sniper_1/ene_sniper_1",	
		["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = "units/pd2_mod_lapd/characters/ene_sniper_1/ene_sniper_1",
		-- fortnite
		["units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"] = "units/pd2_mod_lapd/characters/ene_bulldozer_3/ene_bulldozer_3",		
		--Scripted Spawns Only
		["units/payday2/characters/ene_murkywater_1/ene_murkywater_1"] = "units/pd2_mod_nypd/characters/ene_nypd_murky_1/ene_nypd_murky_1",	
		["units/payday2/characters/ene_murkywater_2/ene_murkywater_2"] = "units/pd2_mod_nypd/characters/ene_nypd_murky_2/ene_nypd_murky_2"
	}		
local lapd_ds = {
		["units/payday2/characters/ene_cop_1/ene_cop_1"] = "units/pd2_mod_lapd/characters/ene_cop_1/ene_cop_1",
		["units/payday2/characters/ene_cop_2/ene_cop_2"] = "units/pd2_mod_lapd/characters/ene_cop_2/ene_cop_2",
		["units/payday2/characters/ene_cop_3/ene_cop_3"] = "units/pd2_mod_lapd/characters/ene_cop_3/ene_cop_3",
		["units/payday2/characters/ene_cop_4/ene_cop_4"] = "units/pd2_mod_lapd/characters/ene_cop_4/ene_cop_4",
		["units/pd2_dlc_rvd/characters/ene_la_cop_1/ene_la_cop_1"] = "units/pd2_mod_lapd/characters/ene_cop_1/ene_cop_1",
		["units/pd2_dlc_rvd/characters/ene_la_cop_2/ene_la_cop_2"] = "units/pd2_mod_lapd/characters/ene_cop_2/ene_cop_2",
		["units/pd2_dlc_rvd/characters/ene_la_cop_3/ene_la_cop_3"] = "units/pd2_mod_lapd/characters/ene_cop_3/ene_cop_3",
		["units/pd2_dlc_rvd/characters/ene_la_cop_4/ene_la_cop_4"] = "units/pd2_mod_lapd/characters/ene_cop_4/ene_cop_4",
		["units/payday2/characters/ene_swat_1/ene_swat_1"] = "units/pd2_mod_lapd/characters/ene_swat_1/ene_swat_1",
		["units/payday2/characters/ene_swat_2/ene_swat_2"] = "units/pd2_mod_lapd/characters/ene_swat_2/ene_swat_2",
		["units/payday2/characters/ene_swat_heavy_1/ene_swat_heavy_1"] = "units/pd2_mod_lapd/characters/ene_swat_heavy_1/ene_swat_heavy_1",
		["units/payday2/characters/ene_swat_heavy_r870/ene_swat_heavy_r870"] = "units/pd2_mod_lapd/characters/ene_swat_heavy_r870/ene_swat_heavy_r870",		
		["units/payday2/characters/ene_swat_heavy_r870_sc/ene_swat_heavy_r870_sc"] = "units/pd2_mod_lapd/characters/ene_swat_heavy_r870/ene_swat_heavy_r870",
		["units/payday2/characters/ene_shield_2/ene_shield_2"] = "units/pd2_mod_lapd/characters/ene_shield_2/ene_shield_2",
		["units/payday2/characters/ene_fbi_2/ene_fbi_2"] = "units/pd2_mod_lapd/characters/ene_fbi_2/ene_fbi_2",
		["units/payday2/characters/ene_fbi_3/ene_fbi_3"] = "units/pd2_mod_lapd/characters/ene_fbi_3/ene_fbi_3",
		["units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"] = "units/pd2_mod_lapd/characters/ene_fbi_swat_1/ene_fbi_swat_1",
		["units/payday2/characters/ene_city_swat_1/ene_city_swat_1"] = "units/pd2_mod_lapd/characters/ene_city_swat_1/ene_city_swat_1",
		["units/payday2/characters/ene_city_swat_2/ene_city_swat_2"] = "units/pd2_mod_lapd/characters/ene_city_swat_2/ene_city_swat_2",
		["units/payday2/characters/ene_city_swat_3/ene_city_swat_3"] = "units/pd2_mod_lapd/characters/ene_city_swat_3/ene_city_swat_3",
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat/ene_zeal_swat"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1"] = "units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1",
		["units/payday2/characters/ene_fbi_swat_2/ene_fbi_swat_2"] = "units/pd2_mod_lapd/characters/ene_fbi_swat_2/ene_fbi_swat_2",
		["units/payday2/characters/ene_fbi_swat_3/ene_fbi_swat_3"] = "units/pd2_mod_lapd/characters/ene_fbi_swat_3/ene_fbi_swat_3",
		["units/payday2/characters/ene_fbi_heavy_1/ene_fbi_heavy_1"] = "units/pd2_mod_lapd/characters/ene_fbi_heavy_1/ene_fbi_heavy_1",		
		["units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy/ene_zeal_swat_heavy"] = "units/pd2_dlc_gitgud/characters/ene_zeal_swat_heavy_sc/ene_zeal_swat_heavy_sc",	
		["units/payday2/characters/ene_fbi_heavy_r870/ene_fbi_heavy_r870"] = "units/pd2_mod_lapd/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc",	
		["units/payday2/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc"] = "units/pd2_mod_lapd/characters/ene_fbi_heavy_r870_sc/ene_fbi_heavy_r870_sc",	
		["units/payday2/characters/ene_city_heavy_g36/ene_city_heavy_g36"] = "units/pd2_mod_lapd/characters/ene_city_heavy_g36/ene_city_heavy_g36",	
		["units/payday2/characters/ene_city_heavy_r870/ene_city_heavy_r870"] = "units/pd2_mod_lapd/characters/ene_city_heavy_r870_sc/ene_city_heavy_r870_sc",	
		["units/payday2/characters/ene_shield_1/ene_shield_1"] = "units/pd2_mod_lapd/characters/ene_shield_1/ene_shield_1",
		["units/payday2/characters/ene_city_shield/ene_city_shield"] = "units/pd2_mod_lapd/characters/ene_city_shield/ene_city_shield",
		-- snipers
		["units/payday2/characters/ene_sniper_1/ene_sniper_1"] = "units/pd2_mod_lapd/characters/ene_sniper_1/ene_sniper_1",	
		["units/payday2/characters/ene_sniper_2/ene_sniper_2"] = "units/pd2_mod_lapd/characters/ene_sniper_1/ene_sniper_1",
		-- fortnite death sentence dozers
		["units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"] = "units/pd2_dlc_vip/characters/ene_vip_2_assault/ene_vip_2_assault",				
		["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"] = "units/pd2_dlc_vip/characters/ene_vip_2_assault/ene_vip_2_assault",				
		["units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"] = "units/pd2_mod_lapd/characters/ene_bulldozer_3/ene_bulldozer_3",				
		["units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"] = "units/pd2_mod_lapd/characters/ene_bulldozer_3/ene_bulldozer_3",				
		--Scripted Spawns Only
		["units/payday2/characters/ene_murkywater_1/ene_murkywater_1"] = "units/pd2_mod_nypd/characters/ene_nypd_murky_1/ene_nypd_murky_1",	
		["units/payday2/characters/ene_murkywater_2/ene_murkywater_2"] = "units/pd2_mod_nypd/characters/ene_nypd_murky_2/ene_nypd_murky_2"       
	}	
	
local federales = {
		--Scripted Spawns Only
		["units/pd2_dlc_bph/characters/ene_murkywater_sniper/ene_murkywater_sniper"] = "units/pd2_dlc_bex/characters/ene_swat_policia_sniper/ene_swat_policia_sniper",					
		["units/pd2_dlc_fex/characters/ene_secret_service_fex/ene_secret_service_fex"] = "units/pd2_dlc_fex/characters/ene_thug_outdoor_fex/ene_thug_outdoor_fex",
		["units/payday2/characters/ene_secret_service_1/ene_secret_service_1"] = "units/pd2_dlc_fex/characters/ene_thug_outdoor_fex/ene_thug_outdoor_fex",	
		["units/payday2/characters/ene_secret_service_2/ene_secret_service_2"] = "units/pd2_dlc_fex/characters/ene_thug_outdoor_fex/ene_thug_outdoor_fex"	
	}	

function ElementSpawnEnemyDummy:init(...)
	ElementSpawnEnemyDummy.super.init(self, ...)
	local ai_type = tweak_data.levels:get_ai_group_type()
	local difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
	local difficulty_index = tweak_data:difficulty_to_index(difficulty)
	local job = Global.level_data and Global.level_data.level_id
	self._needs_replacements = true --basically, this enables the replacement system for dozers, 

	--Murkywater
	if ai_type == "murkywater" then
		if job == "crojob2" or job == "vit" or job == "dark" then
			if murkywater_2[self._values.enemy] then
				self._values.enemy = murkywater_2[self._values.enemy]
			end
			self._values.enemy = murkywater_2[self._values.enemy] or self._values.enemy
		else
			if murkywater[self._values.enemy] then
				self._values.enemy = murkywater[self._values.enemy]
			end
			self._values.enemy = murkywater[self._values.enemy] or self._values.enemy		
		end
	--Reapers
	elseif ai_type == "russia" then
		--Three Way Combat on Bomb Forest
		if job == "crojob3" or job == "crojob3_night" then
			if russia_2[self._values.enemy] then
				self._values.enemy = russia_2[self._values.enemy]
			end
			self._values.enemy = russia_2[self._values.enemy] or self._values.enemy			
		else
			if russia[self._values.enemy] then
				self._values.enemy = russia[self._values.enemy]
			end
			self._values.enemy = russia[self._values.enemy] or self._values.enemy		
		end
	--Zombies
	elseif ai_type == "zombie" then
		if job == "haunted" then
			if difficulty_index <= 2 then
				if haunted_normal[self._values.enemy] then
					self._values.enemy = haunted_normal[self._values.enemy]
				end
				self._values.enemy = haunted_normal[self._values.enemy] or self._values.enemy		
			elseif difficulty_index == 3 or difficulty_index == 4 or difficulty_index == 5 or difficulty_index == 6 then
				if haunted_black[self._values.enemy] then
					self._values.enemy = haunted_black[self._values.enemy]
				end
				self._values.enemy = haunted_black[self._values.enemy] or self._values.enemy
			else
				if haunted_white[self._values.enemy] then
					self._values.enemy = haunted_white[self._values.enemy]
				end
				self._values.enemy = haunted_white[self._values.enemy] or self._values.enemy		
			end	
		elseif job == "nail" then
			if nail[self._values.enemy] then
				self._values.enemy = nail[self._values.enemy]
			end
			self._values.enemy = nail[self._values.enemy] or self._values.enemy		
		else
			if difficulty_index <= 6 then
				if zombie[self._values.enemy] then
					self._values.enemy = zombie[self._values.enemy]
				end
				self._values.enemy = zombie[self._values.enemy] or self._values.enemy		
			else
				if zombie_dw[self._values.enemy] then
					self._values.enemy = zombie_dw[self._values.enemy]
				end
				self._values.enemy = zombie_dw[self._values.enemy] or self._values.enemy				
			end
		end		
	--NYPD
	elseif ai_type == "nypd" then
		if difficulty_index <= 6 then
			if nypd[self._values.enemy] then
				self._values.enemy = nypd[self._values.enemy]
			end
			self._values.enemy = nypd[self._values.enemy] or self._values.enemy	
		elseif difficulty_index == 7 then
			if nypd_dw[self._values.enemy] then
				self._values.enemy = nypd_dw[self._values.enemy]
			end
			self._values.enemy = nypd_dw[self._values.enemy] or self._values.enemy			
		else
			if nypd_ds[self._values.enemy] then
				self._values.enemy = nypd_ds[self._values.enemy]
			end
			self._values.enemy = nypd_ds[self._values.enemy] or self._values.enemy			
		end
	--LAPD
	elseif ai_type == "lapd" then
		if difficulty_index <= 6 then
			if lapd[self._values.enemy] then
				self._values.enemy = lapd[self._values.enemy]
			end
			self._values.enemy = lapd[self._values.enemy] or self._values.enemy			
		elseif difficulty_index == 7 then
			if lapd_dw[self._values.enemy] then
				self._values.enemy = lapd_dw[self._values.enemy]
			end
			self._values.enemy = lapd_dw[self._values.enemy] or self._values.enemy		
		else
			if lapd_ds[self._values.enemy] then
				self._values.enemy = lapd_ds[self._values.enemy]
			end
			self._values.enemy = lapd_ds[self._values.enemy] or self._values.enemy			
		end			
	elseif ai_type == "federales" then
		if federales[self._values.enemy] then
			self._values.enemy = federales[self._values.enemy]
		end
		self._values.enemy = federales[self._values.enemy] or self._values.enemy	
	--America (default)
	else
		--Hard and Below
		if difficulty_index <= 3 then
			if america[self._values.enemy] then
				self._values.enemy = america[self._values.enemy]
			end
			self._values.enemy = america[self._values.enemy] or self._values.enemy
		--Very Hard and Overkill			
		elseif difficulty_index <= 5 then
			if america_very_hard[self._values.enemy] then
				self._values.enemy = america_very_hard[self._values.enemy]
			end
			self._values.enemy = america_very_hard[self._values.enemy] or self._values.enemy
		--Mayhem	
		elseif difficulty_index == 6 then
			if america_mayhem[self._values.enemy] then
				self._values.enemy = america_mayhem[self._values.enemy]
			end
			self._values.enemy = america_mayhem[self._values.enemy] or self._values.enemy				
		--Deathwish		
		elseif difficulty_index == 7 then
			if america_dw[self._values.enemy] then
				self._values.enemy = america_dw[self._values.enemy]
			end
			self._values.enemy = america_dw[self._values.enemy] or self._values.enemy			
		--deaf sentence XD						
		elseif difficulty_index == 8 then
			if america_zeal[self._values.enemy] then
				self._values.enemy = america_zeal[self._values.enemy]
			end
			self._values.enemy = america_zeal[self._values.enemy] or self._values.enemy							
		end
	end

	--[[if self._values.enemy then
		log(self._values.enemy)
	end--]]
	
	self._enemy_name = self._values.enemy and Idstring(self._values.enemy) or Idstring("units/payday2/characters/ene_swat_1/ene_swat_1")
	self._values.enemy = nil
	self._units = {}
	self._events = {}
	self:_finalize_values()
end

local dozers = {
	["units/payday2/characters/ene_bulldozer_1/ene_bulldozer_1"] = true,
	["units/payday2/characters/ene_bulldozer_2/ene_bulldozer_2"] = true,
	["units/payday2/characters/ene_bulldozer_2_hw/ene_bulldozer_2_hw"] = true,
	["units/payday2/characters/ene_bulldozer_3/ene_bulldozer_3"] = true,
	["units/payday2/characters/ene_bulldozer_4/ene_bulldozer_4"] = true,
	["units/payday2/characters/ene_bulldozer_biker_1/ene_bulldozer_biker_1"] = true,
	["units/pd2_dlc_drm/characters/ene_bulldozer_medic/ene_bulldozer_medic"] = true,
	["units/pd2_dlc_drm/characters/ene_bulldozer_medic_classic/ene_bulldozer_medic_classic"] = true,
	["units/pd2_dlc_drm/characters/ene_bulldozer_minigun/ene_bulldozer_minigun"] = true,
	["units/pd2_dlc_drm/characters/ene_bulldozer_minigun_classic/ene_bulldozer_minigun_classic"] = true,
	["units/pd2_dlc_vip/characters/ene_vip_2_assault/ene_vip_2_assault"] = true,
	["units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_1/ene_bulldozer_hvh_1"] = true,
	["units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_2/ene_bulldozer_hvh_2"] = true,
	["units/pd2_dlc_hvh/characters/ene_bulldozer_hvh_3/ene_bulldozer_hvh_3"] = true,
	["units/pd2_dlc_bex/characters/ene_swat_dozer_medic_policia_federale/ene_swat_dozer_medic_policia_federale"] = true,
	["units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_r870/ene_swat_dozer_policia_federale_r870"] = true,
	["units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_saiga/ene_swat_dozer_policia_federale_saiga"] = true,
	["units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_m249/ene_swat_dozer_policia_federale_m249"] = true,
	["units/pd2_dlc_bex/characters/ene_swat_dozer_policia_federale_minigun/ene_swat_dozer_policia_federale_minigun"] = true,
	["units/pd2_mod_omnia/characters/ene_bulldozer_1/ene_bulldozer_1"] = true,
	["units/pd2_mod_omnia/characters/ene_bulldozer_2/ene_bulldozer_2"] = true,
	["units/pd2_mod_omnia/characters/ene_bulldozer_3/ene_bulldozer_3"] = true,
	["units/pd2_mod_nypd/characters/ene_bulldozer_1/ene_bulldozer_1"] = true,
	["units/pd2_mod_nypd/characters/ene_bulldozer_2/ene_bulldozer_2"] = true,
	["units/pd2_mod_lapd/characters/ene_bulldozer_3/ene_bulldozer_3"] = true,
	["units/pd2_mod_halloween/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"] = true,
	["units/pd2_mod_halloween/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2"] = true,
	["units/pd2_mod_halloween/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3"] = true,
	["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer/ene_zeal_bulldozer"] = true,
	["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_2/ene_zeal_bulldozer_2"] = true,
	["units/pd2_dlc_gitgud/characters/ene_zeal_bulldozer_3/ene_zeal_bulldozer_3"] = true,
	["units/pd2_dlc_mad/characters/ene_akan_fbi_tank_r870/ene_akan_fbi_tank_r870"] = true,
	["units/pd2_dlc_mad/characters/ene_akan_fbi_tank_rpk_lmg/ene_akan_fbi_tank_rpk_lmg"] = true,
	["units/pd2_dlc_mad/characters/ene_akan_fbi_tank_saiga/ene_akan_fbi_tank_saiga"] = true,
	["units/pd2_mod_sharks/characters/ene_murky_fbi_tank_m249/ene_murky_fbi_tank_m249"] = true,
	["units/pd2_mod_sharks/characters/ene_murky_fbi_tank_saiga/ene_murky_fbi_tank_saiga"] = true,
	["units/pd2_mod_sharks/characters/ene_murky_fbi_tank_r870/ene_murky_fbi_tank_r870"] = true
}

local captains = {
	["units/pd2_dlc_vip/characters/ene_vip_autumn/ene_vip_autumn"] = true,
	["units/pd2_dlc_vip/characters/ene_summers/ene_summers"] = true,
	["units/pd2_dlc_vip/characters/ene_spring/ene_spring"] = true,
	["units/pd2_mod_halloween/characters/ene_headless_hatman/ene_headless_hatman"] = true,
	["units/pd2_dlc_vip/characters/ene_vip_1/ene_vip_1"] = true
}

function ElementSpawnEnemyDummy:produce(params)
	if not managers.groupai:state():is_AI_enabled() then
		return
	end

	local unit = nil
	local groupai = managers.groupai:state()

	--[[if self._unit_name then
		log("spawned: " .. self._unit_name .. "")
	end]]

	if params and params.name then
		local enemy_name = params.name
		
		if self._needs_replacements then --if replacements are enabled, run the checks			
			if dozers[params.name] and not (Global.level_data and Global.level_data.level_id == "modders_devmap") then --cant use local enemy_name for the above since it causes problems
				--log("get funky")
				local spawn_limit = managers.job:current_spawn_limit("tank") --gets the actual spawn cap of dozers
				local current_active_count = groupai:_get_special_unit_type_count("tank") --current active dozer count
				
				if spawn_limit <= current_active_count then --if adding one more dozer to the active dozer count would go above the spawn cap, replace the unit
					local difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
					local diff_index = tweak_data:difficulty_to_index(difficulty)
					if diff_index < 4 then
						enemy_name = Idstring("units/payday2/characters/ene_tazer_1")
					else
						enemy_name = Idstring("units/pd2_dlc_vip/characters/ene_titan_taser/ene_titan_taser") 
					end
				else
					groupai:reserve_tank_token()
				end
			elseif captains[params.name] then
				groupai:reserve_tank_token()
			end
		end
		
		unit = safe_spawn_unit(enemy_name, self:get_orientation())
		local spawn_ai = self:_create_spawn_AI_parametric(params.stance, params.objective, self._values)

		unit:brain():set_spawn_ai(spawn_ai)
	else
		local enemy_name = self:value("enemy") or self._enemy_name
		
		if self._needs_replacements then --if replacements are enabled, run the checks
			if dozers[enemy_name] and not (Global.level_data and Global.level_data.level_id == "modders_devmap") then --cant use local enemy_name for the above since it causes problems
				--log("get funky")
				local spawn_limit = managers.job:current_spawn_limit("tank") --gets the actual spawn cap of dozers
				local current_active_count = groupai:_get_special_unit_type_count("tank") --current active dozer count

				if spawn_limit <= current_active_count then --if adding one more dozer to the active dozer count would go above the spawn cap, replace the unit
					local difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
					local diff_index = tweak_data:difficulty_to_index(difficulty)
					if diff_index < 4 then
						enemy_name = Idstring("units/payday2/characters/ene_tazer_1")
					else
						enemy_name = Idstring("units/pd2_dlc_vip/characters/ene_titan_taser/ene_titan_taser") 
					end
				else
					groupai:reserve_tank_token()
				end
			elseif captains[enemy_name] then
				groupai:reserve_tank_token()
			end
		end
		
		unit = safe_spawn_unit(enemy_name, self:get_orientation())
		local objective = nil
		local action = self._create_action_data(CopActionAct._act_redirects.enemy_spawn[self._values.spawn_action])
		local stance = managers.groupai:state():enemy_weapons_hot() and "cbt" or "ntl"

		if action.type == "act" then
			objective = {
				type = "act",
				action = action,
				stance = stance
			}
		end

		local spawn_ai = {
			init_state = "idle",
			objective = objective
		}

		unit:brain():set_spawn_ai(spawn_ai)

		local team_id = params and params.team or self._values.team or tweak_data.levels:get_default_team_ID(unit:base():char_tweak().access == "gangster" and "gangster" or "combatant")

		if self._values.participate_to_group_ai then
			managers.groupai:state():assign_enemy_to_group_ai(unit, team_id)
		else
			managers.groupai:state():set_char_team(unit, team_id)
		end

		if self._values.voice then
			unit:sound():set_voice_prefix(self._values.voice)
		end
	end

	unit:base():add_destroy_listener(self._unit_destroy_clbk_key, callback(self, self, "clbk_unit_destroyed"))

	unit:unit_data().mission_element = self

	table.insert(self._units, unit)
	self:event("spawn", unit)

	if self._values.force_pickup and self._values.force_pickup ~= "none" then
		local pickup_name = self._values.force_pickup ~= "no_pickup" and self._values.force_pickup or nil

		unit:character_damage():set_pickup(pickup_name)
	end

	return unit
end