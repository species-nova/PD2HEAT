ModifierNoTaserStun = ModifierNoTaserStun or class(BaseModifier)
ModifierNoTaserStun._type = "ModifierNoTaserStun"
ModifierNoTaserStun.name_id = "none"
ModifierNoTaserStun.desc_id = "menu_cs_modifier_unfinished"



function ModifierNoTaserStun:modify_value(id, value)
    --not yet implemented
	return value
end