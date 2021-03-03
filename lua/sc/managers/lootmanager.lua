function LootManager:set_mandatory_bags_data(carry_id, amount)
    self._global.mandatory_bags.carry_id = carry_id
    --self._global.mandatory_bags.amount = amount

    --forcing amount to 0
    self._global.mandatory_bags.amount = 0
end

function LootManager:show_small_loot_taken_hint(type, multiplier)
	local value = self:get_real_value(type, multiplier)
	local pro_job_bonus = managers.money:get_tweak_value("money_manager", "pro_job_new") or 1

    if pro_job_bonus > 1 then
        value = value * pro_job_bonus
    end

	managers.hint:show_hint("grabbed_small_loot", 2, nil, {
		MONEY = managers.experience:cash_string(value)

	})
end