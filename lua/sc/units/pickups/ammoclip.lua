AmmoClip.EVENT_IDS = {
	bonnie_share_ammo = 1
}

local math_random = math.random
local math_floor = math.floor
local math_clamp = math.clamp

local pairs_g = pairs

local alive_g = alive

local ammo_pickup_ids = Idstring("units/pickups/ammo/ammo_pickup")

function AmmoClip:init(unit)
	AmmoClip.super.init(self, unit)

	self._ammo_type = ""

	if self._unit:name() ~= ammo_pickup_ids then
		return
	end

	self._ammo_box = true

	self:reload_contour()
end

function AmmoClip:reload_contour()
	if not self._ammo_box then
		return
	end

	local contour_ext = self._unit:contour()

	if not contour_ext then
		return
	end

	if managers.user:get_setting("ammo_contour") then
		contour_ext:add("deployable_selected")
	else
		contour_ext:remove("deployable_selected")
	end
end

function AmmoClip:_pickup(unit)
	if self._picked_up then
		return
	end

	local damage_ext = unit:character_damage()

	if not damage_ext or damage_ext:dead() then
		return
	end

	local inventory = unit:inventory()

	if not inventory then
		return
	end

	local player_manager = managers.player
	local throwable_id = self._projectile_id
	local picked_up, is_projectile_or_throwable = false

	if throwable_id then
		is_projectile_or_throwable = true

		if not player_manager:got_max_grenades() and managers.blackmarket:equipped_projectile() == throwable_id then
			player_manager:add_grenade_amount(self._ammo_count or 1, true)

			picked_up = true
		end
	else
		local projectile_category = self._weapon_category
		is_projectile_or_throwable = projectile_category and true

		local valid_weapons = {}

		for id, weapon in pairs_g(inventory:available_selections()) do
			if inventory:is_equipped(id) then
				if not projectile_category or projectile_category == weapon.unit:base():weapon_tweak_data().categories[1] then
					if #valid_weapons > 0 then
						local new_table = {
							weapon
						}

						for idx = 1, #valid_weapons do
							new_table[#new_table + 1] = valid_weapons[idx]
						end

						valid_weapons = new_table
					else
						valid_weapons[#valid_weapons + 1] = weapon
					end
				end
			elseif not projectile_category or projectile_category == weapon.unit:base():weapon_tweak_data().categories[1] then
				valid_weapons[#valid_weapons + 1] = weapon
			end
		end

		local ammo_count = self._ammo_count

		if ammo_count then
			for i = 1, #valid_weapons do
				local weapon = valid_weapons[i]

				if ammo_count > 0 then
					local success, add_amount = weapon.unit:base():add_ammo(1, ammo_count)

					if success then
						picked_up = true

						ammo_count = math_floor(ammo_count - add_amount)
						ammo_count = ammo_count < 0 and 0 or ammo_count
					end
				end
			end

			self._ammo_count = ammo_count
		else
			for i = 1, #valid_weapons do
				local weapon = valid_weapons[i]

				if weapon.unit:base():add_ammo(1) then
					picked_up = true
				end
			end
		end

		if picked_up and projectile_category then
			local achiev_data = tweak_data.achievement.pickup_sticks

			if achiev_data and projectile_category == achiev_data.weapon_category then
				managers.achievment:award_progress(achiev_data.stat)
			end
		end
	end

	if picked_up then
		self._picked_up = true

		local session = managers.network:session()
		local my_unit = self._unit
		local is_ammo_box = nil

		if not is_projectile_or_throwable then
			is_ammo_box = self._ammo_box

			if is_ammo_box then
				local cable_tie_chance = player_manager:has_category_upgrade("cable_tie", "pickup_chance") and 0.3 or 0.05

				if math_random() <= cable_tie_chance then
					player_manager:add_cable_ties(1)
				end
			end

			local restored_health = nil

			--Gambler effects. Refactored from vanilla code for simplicity.
			if player_manager:has_inactivate_temporary_upgrade("temporary", "loose_ammo_restore_health") then
				player_manager:activate_temporary_upgrade("temporary", "loose_ammo_restore_health") --Activate effect cooldown.

				local values = player_manager:temporary_upgrade_value("temporary", "loose_ammo_restore_health", 0) --Get player healing range for gambler.

				if values ~= 0 then
					local heal_amount = math_random(values[1], values[2]) --Determine healing amount

					--Apply healing
					if not damage_ext:need_revive() and not damage_ext:dead() and not damage_ext:is_berserker() then
						damage_ext:restore_health(heal_amount * 0.1, true) --0.1 done to convert integer healing amount to values actually used by playerdamage.lua
						damage_ext:restore_armor(player_manager:upgrade_value("player", "loose_ammo_give_armor", 0)) --Armor regen ability
						damage_ext:fill_dodge_meter(player_manager:upgrade_value("player", "loose_ammo_give_dodge", 0) * damage_ext:get_dodge_points()) --Dodge regen ability
						unit:sound():play("pickup_ammo_health_boost")
					end

					--Give team ammo, no reason to have this use an independently tracked cooldown.
					if player_manager:has_category_upgrade("temporary", "loose_ammo_give_team") then
						session:send_to_peers_synched("sync_unit_event_id_16", my_unit, "pickup", AmmoClip.EVENT_IDS.bonnie_share_ammo)
					end

					--Apply team healing.
					if player_manager:has_category_upgrade("player", "loose_ammo_restore_health_give_team") then
						--Make 100% sure that if you change the values on Gambler that this remains between 2 and 16 such that it never triggers event 1.
						local sync_value = math_clamp(heal_amount, 2, 16)

						session:send_to_peers_synched("sync_unit_event_id_16", my_unit, "pickup", sync_value)
					end
				end
			elseif player_manager:has_activate_temporary_upgrade("temporary", "loose_ammo_restore_health") then --Cooldown reduction
				local restore_upgrade_values = tweak_data.upgrades.loose_ammo_restore_health_values
				local cooldown_reduction = -math_random(restore_upgrade_values.cdr[1], restore_upgrade_values.cdr[2]) --Gambler gotta gamble.
				player_manager:extend_temporary_upgrade("temporary", "loose_ammo_restore_health", cooldown_reduction)
			end
		end

		if Network:is_client() then
			local server_peer = session:server_peer()

			if server_peer then
				--queuing this message along with the (potential) ones above will ensure
				--it arrives in the correct order, as the send_to_host function doesn't do this normally
				session:send_to_peer_synched(server_peer, "sync_pickup", my_unit)
			end
		end

		unit:sound():play(self._pickup_event or "pickup_ammo")
		self:consume()

		if is_ammo_box then
			player_manager:send_message(Message.OnAmmoPickup, nil, unit)
		end

		return true
	end

	return false
end

function AmmoClip:sync_net_event(event, peer)
	local player = managers.player:local_player()

	if not alive_g(player) then
		return
	end

	local damage_ext = player:character_damage()

	if not damage_ext or damage_ext:dead() then
		return
	end

	if event == AmmoClip.EVENT_IDS.bonnie_share_ammo then
		local inventory = player:inventory()

		if not inventory then
			return
		end

		local add_ratio = tweak_data.upgrades.loose_ammo_give_team_ratio or 0.25
		local hud_manager = managers.hud
		local hud_set_ammo_f = hud_manager.set_ammo_amount
		local picked_up = false

		for id, weapon in pairs_g(inventory:available_selections()) do
			local weap_base = weapon.unit:base()

			if weap_base:add_ammo(add_ratio) then
				picked_up = true

				hud_set_ammo_f(hud_manager, id, weap_base:ammo_info())
			end
		end

		if picked_up then
			player:sound():play(self._pickup_event or "pickup_ammo")
		end
	elseif AmmoClip.EVENT_IDS.bonnie_share_ammo < event and not damage_ext:need_revive() and not damage_ext:is_berserker() then
		--multiplied by 0.1 to convert integer healing amount to values actually used by playerdamage.lua
		local restore_value = event * tweak_data.upgrades.loose_ammo_give_team_health_ratio * 0.1

		if damage_ext:restore_health(restore_value, true, true) then
			player:sound():play("pickup_ammo_health_boost")
		end
	end
end
