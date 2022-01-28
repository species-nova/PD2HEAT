HeatSubmoduleFramework = HeatSubmoduleFramework or class(MapFramework)

HeatSubmoduleFramework._directory = ModPath .. "sub_mods"
HeatSubmoduleFramework.type_name = "heat"

HeatSubmoduleFramework:init()
HeatSubmoduleFramework:InitMods()
if not PackageManager:loaded("packages/scassets") then
	PackageManager:load("packages/scassets")
end
if not PackageManager:loaded("packages/outfitassets") then
	PackageManager:load("packages/outfitassets")
end	

-- Always load
if not PackageManager:loaded("packages/addhudmisc") then
	PackageManager:load("packages/addhudmisc")
end
