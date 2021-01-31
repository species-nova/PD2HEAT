local post_init_original = HuskCopBase.post_init
function HuskCopBase:post_init()
	self._allow_invisible = true

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
