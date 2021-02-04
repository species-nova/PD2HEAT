local deep_clone_g = deep_clone
local pairs_g = pairs

function CarryData:set_zipline_unit(zipline_unit)
	self._zipline_unit = zipline_unit

	if zipline_unit then
		if zipline_unit:zipline():ai_ignores_bag() then
			local att_ext = self._unit:attention()

			if att_ext then
				local att_data = att_ext:attention_data()

				--ensure that there's attention data to save
				if att_data then
					self._saved_attention_data = deep_clone_g(att_data)

					for attention_id, _ in pairs_g(self._saved_attention_data) do
						att_ext:remove_attention(attention_id)
					end
				end
			end
		end
	elseif self._saved_attention_data then
		local att_ext = self._unit:attention()

		for attention_id, attention_data in pairs_g(self._saved_attention_data) do
			att_ext:add_attention(attention_data)
		end

		self._saved_attention_data = nil
	end
end
