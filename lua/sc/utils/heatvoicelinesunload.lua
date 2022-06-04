--Trigger an unload for all loaded voicelines.
--Maximizing cross mod compatitibility is pretty important here, so use a posthook.
Hooks:PostHook(Setup, "unload_packages", "HeatVoicelineUnload", function(self)
	heat.Voicelines:unload()
end)