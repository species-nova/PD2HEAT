local ids_face_plate = Idstring("body_helmet_plate")
local ids_visor = Idstring("body_helmet_glass")

--Makes hit detection on dozers with shotguns less obnoxious
function TankCopDamage:is_head(body)
	return body and (body:name() == ids_face_plate or body:name() == ids_visor or TankCopDamage.super.is_head(self, body))
end

--Damage bonus on DS for Dozers when their visor breaks
function TankCopDamage:seq_clbk_vizor_shatter()
	if not self._unit:character_damage():dead() then
		
		if self._unit:base()._tweak_table == "tank_biker" then
			self._unit:sound():say("g90")
		else
			self._unit:sound():say("visor_lost")
		end		
		managers.modifiers:run_func("OnTankVisorShatter", self._unit)
			
	end
end