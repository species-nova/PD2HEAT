--From WolfHUD, provided by Test1.
--Make a new one later!

--Pulls the mod version from the mod.txt.
function getVersion()
    local mod = BLT and BLT.Mods:GetMod("modname")
    return tostring(mod and mod:GetVersion() or "(n/a)")
end

--Sets the new string.
if MenuNodeMainGui then
    Hooks:PostHook( MenuNodeMainGui , "_add_version_string" , "MenuNodeMainGuiPostAddVersionString_modname" , function( self )
        if alive(self._version_string) then
            self._version_string:set_text("PAYDAY 2 v" .. Application:version() .. " | HEAT Alpha Development | ...get ready for debugging!")
			--self._version_string:set_text("Payday 2 v" .. Application:version() .. " | ModName v" .. getVersion())
        end
    end)
end
