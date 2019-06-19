local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_sub = mvector3.subtract
local mvec3_dir = mvector3.direction
local mvec3_dot = mvector3.dot
local mvec3_dis = mvector3.distance
local mvec3_dis_sq = mvector3.distance_sq
local mvec3_lerp = mvector3.lerp
local mvec3_norm = mvector3.normalize
local temp_vec1 = Vector3()
local temp_vec2 = Vector3()
local temp_vec3 = Vector3()

function CopLogicAttack._upd_combat_movement(data)
	local my_data = data.internal_data
	local t = data.t
	local unit = data.unit
	local focus_enemy = data.attention_obj
	local in_cover = my_data.in_cover
	local best_cover = my_data.best_cover
	local enemy_visible = focus_enemy.verified
	local enemy_visible_soft = focus_enemy.verified_t and t - focus_enemy.verified_t < 2
	local enemy_visible_mild_soft = focus_enemy.verified_t and t - focus_enemy.verified_t < 7
	local flank_cover_charge_time = focus_enemy.verified_t and t - focus_enemy.verified_t < 4
	local enemy_visible_softer = focus_enemy.verified_t and t - focus_enemy.verified_t < 15
	local alert_soft = data.is_suppressed
	local action_taken = data.logic.action_taken(data, my_data)
  
  if not data.unit:in_slot(16) and focus_enemy and focus_enemy.is_person and focus_enemy.verified and focus_enemy.dis <= 2000 and  managers.groupai:state():chk_assault_active_atm() then
		if focus_enemy.is_local_player then
			local e_movement_state = focus_enemy.unit:movement():current_state()
			if e_movement_state:_is_reloading() or e_movement_state:_interacting() or e_movement_state:is_equipping() then
				pantsdownchk = true
			end
		else
			local e_anim_data = focus_enemy.unit:anim_data()
			if not (e_anim_data.move or e_anim_data.idle) or e_anim_data.reload then
				pantsdownchk = true
			end
		end
	end
	
	--hitnrun: approach enemies, back away once the enemy is visible, creating a variating degree of aggressiveness
	--eliterangedfire: open fire at enemies from longer distances, back away if the enemy gets too close for comfort
	--spoocavoidance: attempt to approach enemies, if aimed at/seen, retreat away into cover and disengage until ready to try again
	local hitnrunmovementqualify = data.tactics and data.tactics.hitnrun and focus_enemy and focus_enemy.verified and focus_enemy.verified_dis <= 1000 and math.abs(data.m_pos.z - data.attention_obj.m_pos.z) < 200
	local spoocavoidancemovementqualify = data.tactics and data.tactics.spoocavoidance and focus_enemy and focus_enemy.verified and focus_enemy.verified_dis <= 2000 and focus_enemy.aimed_at
	local eliterangedfiremovementqualify = data.tactics and data.tactics.elite_ranged_fire and focus_enemy and focus_enemy.verified and focus_enemy.verified_dis <= 1500
	local want_to_take_cover = my_data.want_to_take_cover
	action_taken = action_taken or CopLogicAttack._upd_pose(data, my_data)
	local move_to_cover, want_flank_cover, taken_flank_cover = nil

	if my_data.cover_test_step ~= 1 and not enemy_visible_softer and (action_taken or want_to_take_cover or not in_cover) then
		my_data.cover_test_step = 1
	end

	if my_data.stay_out_time and (enemy_visible_soft or not my_data.at_cover_shoot_pos or action_taken or want_to_take_cover) then
		my_data.stay_out_time = nil
	elseif my_data.attitude == "engage" and not my_data.stay_out_time and not enemy_visible_soft and my_data.at_cover_shoot_pos and not action_taken and not want_to_take_cover then
		my_data.stay_out_time = t + 7
	end

--added some extra stuff here to make sure other enemy groups get in on the fight, also added a new system so that once a flanking position is acquired for flanking teams, they'll charge, in order for flanking to actually happen instead of them just standing around in the flank cover 
	if action_taken then
		-- Nothing
	elseif want_to_take_cover then
		move_to_cover = true
	elseif not enemy_visible_soft then 
		if data.tactics and data.tactics.charge and data.objective and data.objective.grp_objective and data.objective.grp_objective.charge and (not my_data.charge_path_failed_t or data.t - my_data.charge_path_failed_t > 6) or not enemy_visible_mild_soft and data.objective and data.objective.grp_objective and data.objective.grp_objective.charge and (not my_data.charge_path_failed_t or data.t - my_data.charge_path_failed_t > 6) or data.tactics and data.tactics.flank and my_data.flank_cover and in_cover and focus_enemy and focus_enemy.dis <= 1500 and not want_to_take_cover and taken_flank_cover and not flank_cover_charge_time and (not my_data.charge_path_failed_t or data.t - my_data.charge_path_failed_t > 4) then
			if my_data.charge_path then
				local path = my_data.charge_path
				my_data.charge_path = nil
				action_taken = CopLogicAttack._chk_request_action_walk_to_cover_shoot_pos(data, my_data, path)
        taken_flank_cover = nil
			elseif not my_data.charge_path_search_id and data.attention_obj.nav_tracker then
				my_data.charge_pos = CopLogicTravel._get_pos_on_wall(data.attention_obj.nav_tracker:field_position(), my_data.weapon_range.optimal, 45, nil)

				if my_data.charge_pos then
					my_data.charge_path_search_id = "charge" .. tostring(data.key)

					unit:brain():search_for_path(my_data.charge_path_search_id, my_data.charge_pos, nil, nil, nil)
          taken_flank_cover = nil
				else
					debug_pause_unit(data.unit, "failed to find charge_pos", data.unit)

					my_data.charge_path_failed_t = TimerManager:game():time()
				end
			end
		elseif in_cover then
			if my_data.cover_test_step <= 2 then
				local height = nil

				if in_cover[4] then
					height = 150
				else
					height = 80
				end

				local my_tracker = unit:movement():nav_tracker()
				local shoot_from_pos = CopLogicAttack._peek_for_pos_sideways(data, my_data, my_tracker, focus_enemy.m_head_pos, height)

				if shoot_from_pos then
					local path = {
						my_tracker:position(),
						shoot_from_pos
					}
					action_taken = CopLogicAttack._chk_request_action_walk_to_cover_shoot_pos(data, my_data, path, math.random() < 0.5 and "run" or "walk")
				else
					my_data.cover_test_step = my_data.cover_test_step + 1
				end
			elseif not enemy_visible_softer and math.random() < 0.05 or data.tactics and data.tactics.flank then
				move_to_cover = true
				want_flank_cover = true
			end
		elseif my_data.walking_to_cover_shoot_pos then
			-- Nothing
		elseif my_data.at_cover_shoot_pos then
			if my_data.stay_out_time < t then
				if data.tactics and data.tactics.flank then
					want_flank_cover = true 
					--i went ahead and included these to make sure flankers are always getting flanking positions instead of regular ones, it helps them stay predictable in regards to their choices of movement, you can tell a flank team by 1. smoke grenades being present 2. their chatter (which isnt here because im not sure if thats a-ok just yet) and 3. how they prefer to move around the map.
				end
				move_to_cover = true
			end				
		else
      if data.tactics and data.tactics.flank then
				want_flank_cover = true
			end
			move_to_cover = true
		end
	end

	if not my_data.processing_cover_path and not my_data.cover_path and not my_data.charge_path_search_id and not action_taken and best_cover and (not in_cover or best_cover[1] ~= in_cover[1]) and (not my_data.cover_path_failed_t or data.t - my_data.cover_path_failed_t > 5) then
		CopLogicAttack._cancel_cover_pathing(data, my_data)

		local search_id = tostring(unit:key()) .. "cover"

		if data.unit:brain():search_for_path_to_cover(search_id, best_cover[1], best_cover[5]) then
			my_data.cover_path_search_id = search_id
			my_data.processing_cover_path = best_cover
		end
	end

	if not action_taken and move_to_cover and my_data.cover_path then
		action_taken = CopLogicAttack._chk_request_action_walk_to_cover(data, my_data)
	end

	if want_flank_cover then
		if not my_data.flank_cover then
			local sign = math.random() < 0.5 and -1 or 1
			local step = 30
			my_data.flank_cover = {
				step = step,
				angle = step * sign,
				sign = sign
			}
      taken_flank_cover = true --this helps them qualify for charging behavior after acquiring a flank, which is not vanilla behavior btw
      want_flank_cover = nil
		end
	else
    taken_flank_cover = nil
		my_data.flank_cover = nil
	end

	if data.important and not my_data.turning and not data.unit:movement():chk_action_forbidden("walk") and CopLogicAttack._can_move(data) and data.attention_obj.verified and (not in_cover or not in_cover[4]) then
		if data.is_suppressed and data.t - data.unit:character_damage():last_suppression_t() < 0.7 then
			action_taken = CopLogicBase.chk_start_action_dodge(data, "scared")
		end

		if not action_taken and focus_enemy.is_person and focus_enemy.dis < 2000 and (data.group and data.group.size > 1 or math.random() < 0.5) then
			local dodge = nil

			if focus_enemy.is_local_player then
				local e_movement_state = focus_enemy.unit:movement():current_state()

				if not e_movement_state:_is_reloading() and not e_movement_state:_interacting() and not e_movement_state:is_equipping() then
					dodge = true
				end
			else
				local e_anim_data = focus_enemy.unit:anim_data()

				if (e_anim_data.move or e_anim_data.idle) and not e_anim_data.reload then
					dodge = true
				end
			end

			if dodge and focus_enemy.aimed_at then
				action_taken = CopLogicBase.chk_start_action_dodge(data, "preemptive")
			end
		end
	end

	if not action_taken and want_to_take_cover and not best_cover or hitnrunmovementqualify and not pantsdownchk or eliterangedfiremovementqualify and not pantsdownchk or spoocavoidancemovementqualify and not pantsdownchk then
		action_taken = CopLogicAttack._chk_start_action_move_back(data, my_data, focus_enemy, false)
	end

	action_taken = action_taken or CopLogicAttack._chk_start_action_move_out_of_the_way(data, my_data)
end

function CopLogicAttack._chk_start_action_move_back(data, my_data, focus_enemy, engage)

	local pantsdownchk = nil
	
	if not data.unit:in_slot(16) and focus_enemy and focus_enemy.is_person and focus_enemy.dis <= 2000 then
		if focus_enemy.is_local_player then
			local e_movement_state = focus_enemy.unit:movement():current_state()

			if e_movement_state:_is_reloading() or e_movement_state:_interacting() or e_movement_state:is_equipping() then
				pantsdownchk = true
			end
		else
			local e_anim_data = focus_enemy.unit:anim_data()

			if not (e_anim_data.move or e_anim_data.idle) or e_anim_data.reload then
				pantsdownchk = true
			end
		end
	end
	
	--what the, censored expletive because this isnt my mod, is my code rn tbh
	if focus_enemy and focus_enemy.nav_tracker and focus_enemy.verified and focus_enemy.dis < 250 and CopLogicAttack._can_move(data) or data.tactics and data.tactics.elite_ranged_fire and focus_enemy and focus_enemy.nav_tracker and focus_enemy.verified and focus_enemy.verified_dis <= 1500 and CopLogicAttack._can_move(data) or data.tactics and data.tactics.hitnrun and focus_enemy and focus_enemy.verified and focus_enemy.verified_dis <= 1000 and CopLogicAttack._can_move(data) or data.tactics and data.tactics.spoocavoidance and focus_enemy.verified and focus_enemy.aimed_at then
		
		local from_pos = mvector3.copy(data.m_pos)
		local threat_tracker = focus_enemy.nav_tracker
		local threat_head_pos = focus_enemy.m_head_pos
		local max_walk_dis = nil
		local vis_required = engage
			
		if data.tactics and data.tactics.hitnrun then
			max_walk_dis = 800
		elseif data.tactics and data.tactics.elite_ranged_fire then
			max_walk_dis = 1000
		elseif data.tactics and data.tactics.spoocavoidance then
			max_walk_dis = 1500
		else
			max_walk_dis = 400
		end
			
		local retreat_to = CopLogicAttack._find_retreat_position(from_pos, focus_enemy.m_pos, threat_head_pos, threat_tracker, max_walk_dis, vis_required)

		if retreat_to then
			CopLogicAttack._cancel_cover_pathing(data, my_data)
				
			--if data.tactics and data.tactics.hitnrun or data.tactics and data.tactics.elite_ranged_fire then
				--log("hitnrun or eliteranged just backed up properly")
			--end
				
			if data.tactics and data.tactics.elite_ranged_fire then
				if not data.unit:in_slot(16) and data.char_tweak.chatter.dodge then
					managers.groupai:state():chk_say_enemy_chatter(data.unit, data.m_pos, "dodge")
				end
			end

			local new_action_data = {
				variant = "walk",
				body_part = 2,
				type = "walk",
				nav_path = {
					from_pos,
					retreat_to
				}
			}
			my_data.advancing = data.unit:brain():action_request(new_action_data)
				
			if my_data.advancing then
				my_data.surprised = true

				return true
			end
		end
	end
end



function CopLogicAttack._upd_aim(data, my_data)
	local shoot, aim, expected_pos = nil
	local focus_enemy = data.attention_obj

	if focus_enemy and AIAttentionObject.REACT_AIM <= focus_enemy.reaction then
		local last_sup_t = data.unit:character_damage():last_suppression_t()

		if focus_enemy.verified or focus_enemy.nearly_visible then
			if data.unit:anim_data().run and math.lerp(my_data.weapon_range.close, my_data.weapon_range.optimal, 0) < focus_enemy.dis then
				local walk_to_pos = data.unit:movement():get_walk_to_pos()

				if walk_to_pos then
					mvector3.direction(temp_vec1, data.m_pos, walk_to_pos)
					mvector3.direction(temp_vec2, data.m_pos, focus_enemy.m_pos)

					local dot = mvector3.dot(temp_vec1, temp_vec2)

					if dot < 0.6 then
						shoot = false
						aim = false
					end
				end
			end
      
      if not data.unit:in_slot(16) and focus_enemy and focus_enemy.is_person and focus_enemy.verified and focus_enemy.dis <= 2000 and  managers.groupai:state():chk_assault_active_atm() then
				if focus_enemy.is_local_player then
					local e_movement_state = focus_enemy.unit:movement():current_state()
					if e_movement_state:_is_reloading() or e_movement_state:_interacting() or e_movement_state:is_equipping() then
						pantsdownchk = true
					end
				else
					local e_anim_data = focus_enemy.unit:anim_data()
					if not (e_anim_data.move or e_anim_data.idle) or e_anim_data.reload then
						pantsdownchk = true
					end
				end
			end
				
			if not shoot and focus_enemy and focus_enemy.verified and data.tactics and data.tactics.harass and pantsdownchk and not outoffov then 
				shoot = true
			end

			if aim == nil and AIAttentionObject.REACT_AIM <= focus_enemy.reaction then
				if AIAttentionObject.REACT_SHOOT <= focus_enemy.reaction then
					local running = my_data.advancing and not my_data.advancing:stopping() and my_data.advancing:haste() == "run"
					local firing_range = 500

					if data.internal_data.weapon_range then
						firing_range = running and data.internal_data.weapon_range.close or data.internal_data.weapon_range.far
					else
						debug_pause_unit(data.unit, "[CopLogicAttack]: Unit doesn't have data.internal_data.weapon_range")
					end

					if last_sup_t and data.t - last_sup_t < 7 * (running and 0.3 or 1) * (focus_enemy.verified and 1 or focus_enemy.vis_ray and firing_range < focus_enemy.vis_ray.distance and 0.5 or 0.2) then
						shoot = true
					elseif focus_enemy.verified and data.internal_data.weapon_range and focus_enemy.verified_dis < firing_range then
						shoot = true
					elseif focus_enemy.verified and focus_enemy.criminal_record and focus_enemy.criminal_record.assault_t and data.t - focus_enemy.criminal_record.assault_t < 2 then
						shoot = true
					end

					if not shoot and my_data.attitude == "engage" then
						if focus_enemy.verified then
							if focus_enemy.verified_dis < firing_range or focus_enemy.reaction == AIAttentionObject.REACT_SHOOT then
								shoot = true
							end
						else
							local time_since_verification = focus_enemy.verified_t and data.t - focus_enemy.verified_t

							if my_data.firing and time_since_verification and time_since_verification < 3.5 then
								shoot = true
							else
								data.brain:search_for_path_to_unit("hunt" .. tostring(my_data.key), focus_enemy.unit)
							end
						end
					end

					aim = aim or shoot

					if not aim and focus_enemy.verified_dis < firing_range then
						aim = true
					end
				else
					aim = true
				end
			end
		elseif AIAttentionObject.REACT_AIM <= focus_enemy.reaction then
			local time_since_verification = focus_enemy.verified_t and data.t - focus_enemy.verified_t
			local running = my_data.advancing and not my_data.advancing:stopping() and my_data.advancing:haste() == "run"
			local same_z = math.abs(focus_enemy.verified_pos.z - data.m_pos.z) < 250

			if running then
				if time_since_verification and time_since_verification < math.lerp(5, 1, math.max(0, focus_enemy.verified_dis - 500) / 600) then
					aim = true
				end
			else
				aim = true
			end

			if aim and my_data.shooting and AIAttentionObject.REACT_SHOOT <= focus_enemy.reaction and time_since_verification and time_since_verification < (running and 2 or 3) then
				shoot = true
			end

			if not aim then
				expected_pos = CopLogicAttack._get_expected_attention_position(data, my_data)

				if expected_pos then
					if running then
						local watch_dir = temp_vec1

						mvec3_set(watch_dir, expected_pos)
						mvec3_sub(watch_dir, data.m_pos)
						mvec3_set_z(watch_dir, 0)

						local watch_pos_dis = mvec3_norm(watch_dir)
						local walk_to_pos = data.unit:movement():get_walk_to_pos()
						local walk_vec = temp_vec2

						mvec3_set(walk_vec, walk_to_pos)
						mvec3_sub(walk_vec, data.m_pos)
						mvec3_set_z(walk_vec, 0)
						mvec3_norm(walk_vec)

						local watch_walk_dot = mvec3_dot(watch_dir, walk_vec)

						if watch_pos_dis < 500 or watch_pos_dis < 1000 and watch_walk_dot > 0.85 then
							aim = true
						end
					else
						aim = true
					end
				end
			end
		else
			expected_pos = CopLogicAttack._get_expected_attention_position(data, my_data)

			if expected_pos then
				aim = true
				
				--cops will open fire on expected player positions if they hear player alerts and the player has been seen in the last 5 seconds, and they're harassers, for large bursts of suppressive fire.
				
				if focus_enemy and aim and focus_enemy.alert_t and data.t - focus_enemy.alert_t < 1 and focus_enemy.verified_t and t - focus_enemy.verified_t < 5 and data.tactics and data.tactics.harass then
					shoot = true
				end
			end
		end
	end

	if not aim and data.char_tweak.always_face_enemy and focus_enemy and AIAttentionObject.REACT_COMBAT <= focus_enemy.reaction then
		aim = true
	end

	if data.logic.chk_should_turn(data, my_data) and (focus_enemy or expected_pos) then
		local enemy_pos = expected_pos or (focus_enemy.verified or focus_enemy.nearly_visible) and focus_enemy.m_pos or focus_enemy.verified_pos

		CopLogicAttack._chk_request_action_turn_to_enemy(data, my_data, data.m_pos, enemy_pos)
	end

	if aim or shoot then
		if expected_pos then
			if my_data.attention_unit ~= expected_pos then
				CopLogicBase._set_attention_on_pos(data, mvector3.copy(expected_pos))

				my_data.attention_unit = mvector3.copy(expected_pos)
			end
		elseif focus_enemy.verified or focus_enemy.nearly_visible then
			if my_data.attention_unit ~= focus_enemy.u_key then
				CopLogicBase._set_attention(data, focus_enemy)

				my_data.attention_unit = focus_enemy.u_key
			end
		else
			local look_pos = focus_enemy.last_verified_pos or focus_enemy.verified_pos

			if my_data.attention_unit ~= look_pos then
				CopLogicBase._set_attention_on_pos(data, mvector3.copy(look_pos))

				my_data.attention_unit = mvector3.copy(look_pos)
			end
		end

		if not my_data.shooting and not my_data.spooc_attack and not data.unit:anim_data().reload and not data.unit:movement():chk_action_forbidden("action") then
			local shoot_action = {
				body_part = 3,
				type = "shoot"
			}

			if data.unit:brain():action_request(shoot_action) then
				my_data.shooting = true
			end
		end
	else
		if my_data.shooting then
			local new_action = nil

			if data.unit:anim_data().reload then
				new_action = {
					body_part = 3,
					type = "reload"
				}
			else
				new_action = {
					body_part = 3,
					type = "idle"
				}
			end

			data.unit:brain():action_request(new_action)
		end

		if my_data.attention_unit then
			CopLogicBase._reset_attention(data)

			my_data.attention_unit = nil
		end
	end

	CopLogicAttack.aim_allow_fire(shoot, aim, data, my_data)
end
