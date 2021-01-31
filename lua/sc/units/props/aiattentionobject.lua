local att_str = Idstring("attention")

function AIAttentionObject:set_update_enabled(state)
	if not self._attention_data then
		state = false
	end

	self._unit:set_extension_update_enabled(att_str, state)
end

function AIAttentionObject:_do_late_update()
	if not self._attention_obj or not self._observer_info then
		return
	end

	self:update()
end
