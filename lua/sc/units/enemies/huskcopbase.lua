local post_init_original = HuskCopBase.post_init

local summers_crew = {
	taser_summers = true,
	boom_summers = true,
	medic_summers = true
}

function HuskCopBase:post_init()
	self._allow_invisible = true
	
	if self._tweak_table == "summers" then
		managers.enemy:register_summers(self._unit)
	end
	
	if summers_crew[self._tweak_table] then
		managers.enemy:register_summers_crew(self._unit)
	end

	post_init_original(self)
	
	--[[local spawn_state = nil

	if self._spawn_state then
		if self._spawn_state ~= "" then
			spawn_state = self._spawn_state
		end
	else
		spawn_state = "std/stand/still/idle/look"
	end

	if spawn_state then
		self._ext_movement:play_state(spawn_state)
	end]]
end
