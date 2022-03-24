function CivilianBrain:on_intimidated(n, unit)
	CivilianBrain.super.on_intimidated(self, n, unit)

	--Send out alert, in addition to normal logic from CopBrain.
	if Network:is_server() then
		managers.groupai:state():propagate_alert({
			"vo_distress",
			unit:movement():m_head_pos(),
			0,
			managers.groupai:state():get_unit_type_filter("civilians_enemies"),
			unit
		})
	end
end

--Let alerted civvies hear loud stuff other than just gunfire. 
function CivilianBrain:on_cool_state_changed(state)
	if self._logic_data then
		self._logic_data.cool = state
	end

	if self._alert_listen_key then
		managers.groupai:state():remove_alert_listener(self._alert_listen_key)
	else
		self._alert_listen_key = "CopBrain" .. tostring(self._unit:key())
	end

	local alert_listen_filter, alert_types = nil

	if state then
		alert_listen_filter = managers.groupai:state():get_unit_type_filter("criminals_enemies_civilians")
		alert_types = {
			vo_distress = true,
			aggression = true,
			bullet = true,
			vo_intimidate = true,
			explosion = true,
			footstep = true,
			vo_cbt = true,
			fire = true --Add additional fire alert type.
		}
	else
		alert_listen_filter = managers.groupai:state():get_unit_type_filter("criminal")
		alert_types = {
			explosion = true, --Add additional alert types for non-bullets.
			fire = true,
			aggression = true,
			bullet = true
		}
	end

	managers.groupai:state():add_alert_listener(self._alert_listen_key, callback(self, self, "on_alert"), alert_listen_filter, alert_types, self._unit:movement():m_head_pos())
end
