BurglarLoot = BurglarLoot or class(Pickup)

local HEALTH_BONUS = 4
local ARMOR_BONUS = 4
local MONEY_BONUS = 1500

function BurglarLoot:init(unit)
	BurglarLoot.super.init(self, unit)
	self:reload_contour()
end

function BurglarLoot:reload_contour()
	local contour_ext = self._unit:contour()

	if not contour_ext then
		return
	end

	if managers.user:get_setting("ammo_contour") then
		log("ADD CONTOUR!")
		contour_ext:add("deployable_selected")
	else
		contour_ext:remove("deployable_selected")
	end
end

function BurglarLoot:_pickup(unit)
	if self._picked_up then
		return
	end

	local damage_ext = unit:character_damage()

	if damage_ext and not damage_ext:dead() then
		local curr_health = damage_ext:get_real_health()
		local curr_armor = damage_ext:get_real_armor()
		damage_ext:restore_health(HEALTH_BONUS, true)
		damage_ext:restore_armor(ARMOR_BONUS)

		if curr_health ~= damage_ext:get_real_health() or curr_armor ~= damage_ext:get_real_armor() then
			managers.money:_add_to_total(MONEY_BONUS, {no_offshore = true}, "Stole it from a rich uncle.")

			managers.hud:present_mid_text({
				time = 4,
				text = managers.localization:text("hud_loot_secured", {
					CARRY_TYPE = "Supplies Stolen",
					AMOUNT = managers.experience:cash_string(MONEY_BONUS)
				}),
				title = managers.localization:text("hud_loot_secured_title"),
				icon = nil,
				event = managers.loot:get_loot_stinger()
			})

			self._picked_up = true

			if Network:is_client() then
				local server_peer = session:server_peer()

				if server_peer then
					--queuing this message along with the (potential) ones above will ensure
					--it arrives in the correct order, as the send_to_host function doesn't do this normally
					session:send_to_peer_synched(server_peer, "sync_pickup", self._unit)
				end
			end

			unit:sound():play("pickup_ammo_health_boost", nil, true)
			self:consume()

			return true
		end
	end

	return false
end