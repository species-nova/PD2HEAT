local old_init = HuskCopDamage.init
function HuskCopDamage:init(...)
	old_init(self, ...)
	
	--HACK: Until the issues with loading the custom .unit files can be resolved. Enable the head hitbox on Yufu Wang via lua.
	if self._unit:base()._tweak_table == "triad_boss" then
		self._head_body_name = "head"
		self._ids_head_body_name = Idstring(self._head_body_name)
		self._head_body_key = self._unit:body(self._head_body_name):key()
	end
end

local old_death = HuskCopDamage.die
function HuskCopDamage:die(attack_data)
	old_death(self, attack_data)

	if self._unit:base():char_tweak().ends_assault_on_death then
		managers.hud:set_buff_enabled("vip", false)
	end

	if self._unit:contour() then
		self._unit:contour():remove("omnia_heal", false)
		self._unit:contour():remove("medic_show", false)
	end

	if self._unit:base():has_tag("tank_titan") or self._unit:base():has_tag("shield_titan") or self._unit:base():has_tag("captain") or self._unit:base():has_tag("lpf") then
		self._unit:sound():play(self._unit:base():char_tweak().die_sound_event_2, nil, nil)
	end

	if self._unit:base():char_tweak().die_sound_event then
		self._unit:sound():play(self._unit:base():char_tweak().die_sound_event, nil, nil)
	else
		heat.Voicelines:say(self._unit, "death")
	end

	if self._char_tweak.do_autumn_blackout then --clear all equipment and re-enable them when autumn dies
		managers.groupai:state():unregister_blackout_source(self._unit)
	end

	--client sided boomboom
	if self._unit:base()._tweak_table == "boom" then
		local boom_boom = false
		boom_boom = managers.modifiers:modify_value("CopDamage:CanBoomBoom", boom_boom)
		if boom_boom then
			MutatorExplodingEnemies._detonate(MutatorExplodingEnemies, self, attack_data, true, 20, 500)
		end
	end
end

function HuskCopDamage:heal_unit(...)
	return CopDamage.heal_unit(self, ...)
end