local mvec3_dis_sq = mvector3.distance_sq

function TeamAIDamage:_apply_damage(attack_data, result)
	local damage = attack_data.damage
	
	if attack_data.attacker_unit and attack_data.attacker_unit:base().has_tag and not attack_data.attacker_unit:base():has_tag("sniper") then
		local enemy_unit = attack_data.attacker_unit 
		local dis = mvec3_dis_sq(enemy_unit:movement():m_pos(), self._unit:movement():m_pos()) 
		if dis > 3240000 then
			damage = 0
		elseif not enemy_unit:base():has_tag("tank") then
			if dis > 810000 then
				damage = damage * 0.75
			end
			
			local attacker_unit_key = enemy_unit:key()
			local attention_obj = self._unit:brain()._logic_data.attention_obj
	
			if attention_obj and attention_obj.unit and attention_obj.unit:key() ~= attack_data.attacker_unit:key() then
				damage = damage * 0.75
				--log("hell's bells.")
			end
		end
	end
	
	damage = math.clamp(damage, self._HEALTH_TOTAL_PERCENT, self._HEALTH_TOTAL)
	local damage_percent = math.ceil(damage / self._HEALTH_TOTAL_PERCENT)
	damage = damage_percent * self._HEALTH_TOTAL_PERCENT
	attack_data.damage = damage
	local dodged = self:inc_dodge_count(damage_percent / 2)
	attack_data.pos = attack_data.pos or attack_data.col_ray.position
	attack_data.result = result

	if dodged or self._unit:anim_data().dodge then
		result.type = "none"

		return 0, 0
	end

	local health_subtracted = nil

	if self._bleed_out then
		health_subtracted = self._bleed_out_health
		self._bleed_out_health = self._bleed_out_health - damage

		self:_check_fatal()

		if self._fatal then
			result.type = "fatal"
			self._health_ratio = 0
		else
			health_subtracted = damage
			result.type = "hurt"
			self._health_ratio = self._bleed_out_health / self._HEALTH_BLEEDOUT_INIT
		end
	else
		health_subtracted = self._health
		self._health = self._health - damage

		self:_check_bleed_out()

		if self._bleed_out then
			result.type = "bleedout"
			self._health_ratio = 1
		else
			health_subtracted = damage
			result.type = self:get_damage_type(damage_percent, "bullet") or "none"

			self:_on_hurt()

			self._health_ratio = self._health / self._HEALTH_INIT
		end
	end

	--managers.hud:set_mugshot_damage_taken(self._unit:unit_data().mugshot_id)

	return damage_percent, health_subtracted
end
