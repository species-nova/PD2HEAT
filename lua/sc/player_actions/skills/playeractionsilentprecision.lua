PlayerAction.SilentPrecision = {
	Priority = 1,
	Function = function (player_manager, min_time)
		local co = coroutine.running()
		local target_time = Application:time() + min_time
		--Start off with buff active.
		local is_active = true
		managers.player:activate_temporary_upgrade_indefinitely("temporary", "silent_precision")

		local function on_damage_taken()
			if is_active then
				player_manager:activate_temporary_upgrade("temporary", "silent_precision")
				is_active = nil
			end
			target_time = Application:time() + min_time
		end

		player_manager:register_message(Message.OnPlayerDamage, co, on_damage_taken)

		while true do
			--Reapply buff after not taking damage for a long enough time.
			--Have it last 'forever' until damage is taken.
			if target_time <= Application:time() then
				managers.player:activate_temporary_upgrade_indefinitely("temporary", "silent_precision")
				is_active = true
			end

			coroutine.yield(co)
		end

		managers.player:deactivate_temporary_upgrade("temporary", "silent_precision")
		player_manager:unregister_message(Message.OnPlayerDamage, co)
	end
}