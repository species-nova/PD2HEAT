PlayerAction.TriggerHappy = {
	Priority = 1,
	Function = function (player_manager, damage_bonus, max_stacks, max_time)
		local co = coroutine.running()
		local current_time = Application:time()
		local current_stacks = 1
		local add_time = player_manager:upgrade_value("pistol", "stacking_hit_damage_multiplier", nil).max_time
		local hud_manager = managers.hud

		--Headshot stacking + refresh.
		local function on_headshot(unit, attack_data)
			local attacker_unit = attack_data.attacker_unit
			local variant = attack_data.variant
			
			--Extra checks that you're actually *shooting* enemies with your *pistol*
			if attacker_unit == player_manager:player_unit() and variant == "bullet" and player_manager:is_current_weapon_of_category("pistol") then
				current_stacks = current_stacks + 1

				if current_stacks <= max_stacks then
					player_manager:add_to_property("trigger_happy", damage_bonus - 1)
					hud_manager:add_stack("trigger_happy")
				end
				max_time = current_time + add_time

				hud_manager:start_buff("trigger_happy", add_time)
			end
		end

		player_manager:set_property("trigger_happy", damage_bonus)
		player_manager:register_message(Message.OnHeadShot, co, on_headshot)

		hud_manager:start_buff("trigger_happy", add_time)
		hud_manager:add_stack("trigger_happy")

		while current_time < max_time do
			current_time = Application:time()
			coroutine.yield(co)
		end

		player_manager:remove_property("trigger_happy")
		player_manager:unregister_message(Message.OnHeadShot, co)
		if player_manager:has_category_upgrade("player", "trigger_happy_bodyshot_refresh") then
			player_manager:unregister_message(Message.OnEnemyShot, co)
		end
	end
}