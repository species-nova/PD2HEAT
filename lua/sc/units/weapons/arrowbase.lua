--Allow body armor piercing
local orig_setup_from_tweak_data = ArrowBase._setup_from_tweak_data
function ArrowBase:_setup_from_tweak_data(arrow_entry)
	orig_setup_from_tweak_data(self, arrow_entry)
	self._slot_mask = self._slot_mask - World:make_slot_mask(16)
end

--Apply perk deck damage bonus to impact.
local orig_set_weapon_unit = ArrowBase.set_weapon_unit
function ArrowBase:set_weapon_unit(weapon_unit)
	orig_set_weapon_unit(self, weapon_unit)

	self._weapon_damage_mult = self._weapon_damage_mult * managers.player:get_perk_damage_bonus(self._thrower_unit)
end