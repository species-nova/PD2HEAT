ModifierHeavies.default_value = "spawn_chance"
ModifierHeavies.america = {
	Idstring("units/payday2/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
	Idstring("units/payday2/characters/ene_city_swat_1/ene_city_swat_1"),
	Idstring("units/payday2/characters/ene_city_swat_1_sc/ene_city_swat_1_sc"),
	Idstring("units/pd2_mod_nypd/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
	Idstring("units/pd2_mod_lapd/characters/ene_fbi_swat_1/ene_fbi_swat_1"),	
	Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_city_1/ene_zeal_city_1")
}
ModifierHeavies.russia = {
	Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_ak47_ass/ene_akan_fbi_swat_ak47_ass"),
	Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ak47_ass/ene_akan_fbi_swat_dw_ak47_ass"),
	Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ak47_ass_sc/ene_akan_fbi_swat_dw_ak47_ass_sc")
}
ModifierHeavies.zombie = {
	Idstring("units/pd2_dlc_hvh/characters/ene_fbi_swat_hvh_1/ene_fbi_swat_hvh_1"),
	Idstring("units/pd2_mod_halloween/characters/ene_city_swat_1/ene_city_swat_1"),
	Idstring("units/pd2_mod_halloween/characters/ene_zeal_city_1/ene_zeal_city_1")
}	
ModifierHeavies.murky = {
	Idstring("units/pd2_mod_sharks/characters/ene_fbi_swat_1/ene_fbi_swat_1"),
	Idstring("units/pd2_mod_sharks/characters/ene_city_swat_1/ene_city_swat_1"),
	Idstring("units/pd2_mod_omnia/characters/ene_omnia_city/ene_omnia_city")
}	
ModifierHeavies.federales = {
	Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_fbi/ene_swat_policia_federale_fbi"),
	Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city/ene_swat_policia_federale_city"),
	Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_zeal/ene_swat_policia_federale_zeal")
}	
--just to make sure the original doesn't do anything
ModifierHeavies.unit_swaps = {}


function ModifierHeavies:modify_value(id, value)
	if id == "GroupAIStateBesiege:SpawningUnit" then
		local difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
		local difficulty_index = tweak_data:difficulty_to_index(difficulty)
		local is_america = table.contains(ModifierHeavies.america, value)
		local is_russia = table.contains(ModifierHeavies.russia, value)
		local is_zombie = table.contains(ModifierHeavies.zombie, value)
		local is_murky = table.contains(ModifierHeavies.murky, value)
		local is_federales = table.contains(ModifierHeavies.federales, value)

			if difficulty_index <= 7 then
				--death wish and below
				if is_america and math.random(0,100) < 15 then
					return Idstring("units/payday2/characters/ene_city_swat_3/ene_city_swat_3")
				elseif is_russia and math.random(0,100) < 15 then
					return Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ump/ene_akan_fbi_swat_dw_ump")
				elseif is_zombie and math.random(0,100) < 15 then
					return Idstring("units/pd2_mod_halloween/characters/ene_city_swat_3/ene_city_swat_3")	
				elseif is_murky and math.random(0,100) < 15 then
					return Idstring("units/pd2_mod_sharks/characters/ene_city_swat_3/ene_city_swat_3")	
				elseif is_federales and math.random(0,100) < 15 then
					return Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_city_ump/ene_swat_policia_federale_city_ump")
				end
			else 
				--death sentence	
				if is_america and math.random(0,100) < 15 then
					return Idstring("units/pd2_dlc_gitgud/characters/ene_zeal_city_3/ene_zeal_city_3")
				elseif is_russia and math.random(0,100) < 15 then
					return Idstring("units/pd2_dlc_mad/characters/ene_akan_fbi_swat_dw_ump/ene_akan_fbi_swat_dw_ump")
				elseif is_zombie and math.random(0,100) < 15 then
					return Idstring("units/pd2_mod_halloween/characters/ene_zeal_city_3/ene_zeal_city_3")	
				elseif is_murky and math.random(0,100) < 15 then
					return Idstring("units/pd2_mod_omnia/characters/ene_omnia_city_3/ene_omnia_city_3")	
				elseif is_federales and math.random(0,100) < 15 then
					return Idstring("units/pd2_dlc_bex/characters/ene_swat_policia_federale_zeal_ump/ene_swat_policia_federale_zeal_ump")					
				end
			end
	end
	return value
end