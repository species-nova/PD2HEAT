local _G = _G
local io = io
local file = file

if not _G.finalmix then
	_G.finalmix = {}
	_G.finalmix.ModPath = ModPath
	blt.xaudio.setup()
	local finalmix_mod_instance = ModInstance
	--log("==============Loading Final Mix Assets==============")
end

