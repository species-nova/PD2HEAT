--Allow for host-side civvies to be unrendered.
local post_init_original = CivilianBase.post_init
function CivilianBase:post_init()
	self._allow_invisible = true

	post_init_original(self)
end
