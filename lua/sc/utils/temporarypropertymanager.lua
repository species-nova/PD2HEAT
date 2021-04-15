--Adds infohud hooks for property based skills (IE: Overkill).
Hooks:PostHook(TemporaryPropertyManager, "activate_property", "ResPropertyToHud", function(self, prop, time, value)
	managers.hud:start_buff(prop, time)
end)

--Vanilla has inconsistent and less than useful handling for the time portion of temporary properties.
--Now, property duration gets reset when a new stack is applied.
function TemporaryPropertyManager:add_to_property(prop, time, value)
	if not self:has_active_property(prop) then
		self:activate_property(prop, time, value)
	else
		self._properties[prop][1] = self._properties[prop][1] + value
		self._properties[prop][2] = Application:time() + time
	end
	managers.hud:start_buff(prop, time)
end

function TemporaryPropertyManager:mul_to_property(prop, time, value)
	if not self:has_active_property(prop) then
		self:activate_property(prop, time, value)
	else
		self._properties[prop][1] = self._properties[prop][1] * value
		self._properties[prop][2] = Application:time() + time
	end
	managers.hud:start_buff(prop, time)
end

function TemporaryPropertyManager:set_time(prop, time)
	if self:has_active_property(prop) then
		self._properties[prop][2] = Application:time() + time
		managers.hud:start_buff(prop, time)
	end
end