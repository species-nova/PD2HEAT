local mvec3_set = mvector3.set
local mvec3_set_z = mvector3.set_z
local mvec3_mul = mvector3.multiply
local mvec3_sub = mvector3.subtract
local mvec3_norm = mvector3.normalize
local mvec3_dir = mvector3.direction
local mvec3_dis = mvector3.distance
local mvec3_set_l = mvector3.set_length
local mvec3_add = mvector3.add
local mvec3_dot = mvector3.dot
local mvec3_cross = mvector3.cross
local mvec3_rot = mvector3.rotate_with
local mvec3_rand_orth = mvector3.random_orthogonal
local mvec3_lerp = mvector3.lerp
local mvec3_copy = mvector3.copy
local mrot_axis_angle = mrotation.set_axis_angle
local math_min = math.min
local math_max = math.max
local math_lerp = math.lerp
local math_round = math.round
local math_random = math.random
local math_clamp = math.clamp
local math_up = math.UP
local temp_vec2 = Vector3()
local temp_rot1 = Rotation()
local world_g = World

function CopActionShoot:init(action_desc, common_data)
	self._common_data = common_data
	self._ext_movement = common_data.ext_movement
	self._ext_anim = common_data.ext_anim
	self._ext_brain = common_data.ext_brain
	self._ext_inventory = common_data.ext_inventory
	self._ext_base = common_data.ext_base
	self._body_part = action_desc.body_part
	self._machine = common_data.machine
	self._unit = common_data.unit

	local weapon_unit = self._ext_inventory:equipped_unit()

	if not weapon_unit then
		return false
	end

	local weap_tweak = weapon_unit:base():weapon_tweak_data()
	local weapon_usage_tweak = common_data.char_tweak.weapon[weap_tweak.usage]
	self._weapon_unit = weapon_unit
	self._weapon_base = weapon_unit:base()
	self._weap_tweak = weap_tweak
	self._w_usage_tweak = weapon_usage_tweak

	self._hit_delay = tweak_data.player.damage.SINGLE_ENEMY_DAMAGE_INTERVAL --Delay between hits. All shots will miss during this delay. Does not apply to melee.
	self._next_hit_t = 0 --Tracker for delay between hits.

	self._shoot_t = 0 --Tracker for when trigger can be pulled next.
	self._aim_delay_minmax = managers.modifiers:modify_value("CopActionShoot:ModifierSniperAim", weapon_usage_tweak.aim_delay or {0, 0}) --Delay for how long it takes to start aiming.
	self._focus_delay = weapon_usage_tweak.focus_delay or 0 --How long it takes to reach full accuracy.
	self._focus_displacement = weapon_usage_tweak.focus_dis or 500 --Sadly a misnomer. Effectively how easy it is to aim vs moving targets or when hit. Movement outside of this range re-forces aim delays.
	self._spread = weapon_usage_tweak.spread or 20 --Innate weapon spread.
	self._miss_dis = weapon_usage_tweak.miss_dis or 30 --How much spread to apply to missed shots.
	self._automatic_weap = weap_tweak.auto and weap_tweak.auto.fire_rate and not weapon_usage_tweak.semi_auto_only and true or nil --Whether or not weapon is full auto.
	self._falloff = weapon_usage_tweak.FALLOFF --Determines firing behavior and damage multipliers over different ranges.

	self._variant = action_desc.variant
	self._body_part = action_desc.body_part
	self._shoot_from_pos = self._ext_movement:m_head_pos()

	self._shield = alive(self._ext_inventory._shield_unit) and self._ext_inventory._shield_unit or nil
	self._tank_animations = self._ext_movement._anim_global == "tank" and true or nil
	self._is_team_ai = managers.groupai:state():is_unit_team_AI(self._unit) and true or nil
	self._shield_slotmask = managers.slot:get_mask("enemy_shield_check")

	if not self._is_team_ai then
		if self._ext_brain.converted and self._ext_brain:converted() or managers.groupai:state():is_enemy_converted_to_criminal(self._unit) then
			self._is_converted = true
		end
	end

	--Determine melee ability.
	self._melee_timeout_t = 0 --Tracker for when next melee attack can be performed.
	if not self._shield then
		local melee_weapon = self._ext_base.melee_weapon and self._ext_base:melee_weapon()
		
		if melee_weapon then
			local melee_tweak = tweak_data.weapon.npc_melee[melee_weapon] or {}

			local hit_player = true
			local shield_knock = nil
			local slotmask = managers.slot:get_mask("bullet_impact_targets_no_police") + 3

			if self._is_team_ai then
				slotmask = managers.slot:get_mask("bullet_impact_targets_no_criminals")
				shield_knock = true
				hit_player = nil
			elseif self._is_converted then
				slotmask = managers.slot:get_mask("bullet_impact_targets_no_criminals")
				hit_player = nil
			end

			--Filled in table == unit can melee attack. Contains relevant data.
			self._melee_weapon_data = {
				melee_weapon = melee_weapon,
				damage = melee_tweak.damage or 6, --Base melee damage.
				dmg_mul = self._w_usage_tweak.melee_dmg or 1, --Difficulty dependent melee damage scaling.
				speed = self._w_usage_tweak.melee_speed or 1, --Animation speed for melee attack.
				retry_delay = self._w_usage_tweak.melee_retry_delay or {1, 1}, --Delay between melee attacks.
				knockback_mul = melee_tweak.knockback_mul or 1, --Scale of melee attack knockback.
				range = melee_tweak.range or 150, --Range of melee attacks.
				slotmask = slotmask, --Things melee attack can hit.
				hit_player = hit_player, --If melee attack can hit players.
				electrical = melee_tweak.electrical, --Whether or not melee attack can tase.
				armor_piercing = melee_tweak.armor_piercing, --Whether or not melee attack pierces armor.
				push_mul = melee_tweak.push_mul or 1,
				shield_knock = shield_knock, --Whether or not melee attack can knock down shields.
				anims = melee_tweak.animation_param or self._common_data.char_tweak.melee_anims or {"var1", "var2"}
			}
		end
	end

	self._is_server = Network:is_server()

	if self._is_server then
		self._ext_movement:set_stance_by_code(3)
		common_data.ext_network:send("action_aim_state", true)

		self._grenade = common_data.char_tweak.grenade or weapon_usage_tweak.grenade
		if self._grenade then
			if not self._ext_brain._grenade_t then
				self._ext_brain._grenade_t = 0
			end
		end
	else
		self._turn_allowed = true
	end

	local preset_name = self._ext_anim.base_aim_ik or "spine"
	local preset_data = self._ik_presets[preset_name]
	self._ik_preset = preset_data
	self[preset_data.start](self)

	self:on_attention(common_data.attention)

	CopActionAct._create_blocks_table(self, action_desc.blocks)

	self._skipped_frames = 1

	--Debug options.
	self._draw_melee_sphere_rays = nil
	self._draw_obstruction_checks = nil
	self._draw_focus_displacement = nil
	self._draw_focus_delay_vis_reset = nil
	self._draw_strict_grenade_attempts = nil

	return true
end

function CopActionShoot:on_exit()
	--More tactical looking animation behaviors.
	if self._is_server then
		if not self._exiting_to_reload then
			if not self._attention or not self._attention.reaction or self._attention.reaction < AIAttentionObject.REACT_AIM then
				self._ext_movement:set_stance_by_code(2)
			end
		end

		self._common_data.ext_network:send("action_aim_state", false)
	end

	if self._modifier_on then
		self[self._ik_preset.stop](self)
	end

	if self._autofiring then
		self:_stop_autofire(true)
	end

	if self._shooting_player and alive(self._attention.unit) then
		--on_targetted_for_attack is no longer called, since underdog now works purely off of proximity.

		--End sniper focus.
		if self._use_sniper_focus then
			self:set_sniper_focus_sound(0)
		end
	end

	--Disable laser.
	if self._w_usage_tweak.use_laser then
		self:disable_sniper_laser()
	end
end

function CopActionShoot:on_attention(attention, old_attention)
	if self._shooting_player and old_attention and alive(old_attention.unit) then

		if self._use_sniper_focus then
			self:set_sniper_focus_sound(0)
		end
	end

	self._shooting_player = nil
	self._shooting_husk_unit = nil
	self._next_vis_ray_t = nil
	self._charge_taser = nil

	if attention then
		local t = TimerManager:game():time()

		self[self._ik_preset.start](self)

		local vis_state = self._ext_base:lod_stage()

		if vis_state and vis_state < 3 and self[self._ik_preset.get_blend](self) > 0 then
			self._aim_transition = {
				duration = 0.7,
				start_t = t,
				start_vec = mvec3_copy(self._common_data.look_vec)
			}
			self._get_target_pos = self._get_transition_target_pos
		else
			self._aim_transition = nil
			self._get_target_pos = nil
		end

		self._mod_enable_t = t + 0.5

		if attention.unit then
			if attention.unit:base() and attention.unit:base().is_local_player then
				self._shooting_player = true
			else
				--Commenting this out for now until I can work out the actual purpose it serves.
				--[[if self._is_server then
					if attention.unit:base() and attention.unit:base().is_husk_player then
						self._shooting_husk_unit = true
						self._next_vis_ray_t = t - 1
					end
				else
					self._shooting_husk_unit = true
					self._next_vis_ray_t = t - 1
				end]]
				--Replacing with dumb/obvious shit.
				self._shooting_husk_unit = true
				self._next_vis_ray_t = t - 1
			end

			if self._w_usage_tweak.sniper_charge_attack then
				self._use_sniper_focus = true
				self._sniper_focus_start_t = t
			end

			self._line_of_sight_t = t - 2

			local target_pos, _, target_dis = self:_get_target_pos(self._shoot_from_pos, attention, t)
			local usage_tweak = self._w_usage_tweak

			local shoot_hist = self._shoot_history
			if shoot_hist and self._use_sniper_focus then --Snipers ignore focus displacement mechanics and have a fixed delay before firing.
				self._shoot_t = self._mod_enable_t + self._aim_delay_minmax[1]
				shoot_hist.focus_start_t = t
				shoot_hist.m_last_pos = mvec3_copy(target_pos)
			else
				local apply_aim_delay = nil
				if shoot_hist then --If shoot history exists, then check distance from where aiming was last done and see if aim delay needs to be reapplied.
					local displacement = mvec3_dis(target_pos, shoot_hist.m_last_pos) or 500
					if displacement > self._focus_displacement then --Enough distance was covered, re-apply aim delay.
						apply_aim_delay = true
						shoot_hist.focus_start_t = t
						shoot_hist.m_last_pos = mvec3_copy(target_pos)
					end
					
					self:debug_draw_focus_displacement(target_pos, shoot_hist.m_last_pos, distance)
				else --Otherwise, apply aim delay and create shoot history.
					apply_aim_delay = true

					self._shoot_history = {
						focus_start_t = t,
						focus_delay = self._focus_delay,
						m_last_pos = mvec3_copy(target_pos),
					}
				end

				--Apply aim delay.
				if apply_aim_delay then
					local aim_dis = math_min(1, target_dis / self._falloff[#self._falloff].r)
					aim_delay = math_lerp(self._aim_delay_minmax[1], self._aim_delay_minmax[2], aim_dis)
					
					if self._common_data.is_suppressed then
						aim_delay = aim_delay * 1.5
					end
					self._shoot_t = self._mod_enable_t + aim_delay
				end
			end
		else --Attention lost, stop sniper focus.
			self:disable_sniper_focus()
		end
	else
		self:disable_sniper_focus()

		self[self._ik_preset.stop](self)

		if self._aim_transition then
			self._aim_transition = nil
			self._get_target_pos = nil
		end
	end

	self._attention = attention
end

function CopActionShoot:disable_sniper_focus()
	if self._use_sniper_focus then
		self._use_sniper_focus = nil

		if self._w_usage_tweak.use_laser then
			self:disable_sniper_laser()
		end
	end
end

function CopActionShoot:debug_draw_focus_displacement(target_pos, prev_target_pos, distance)
	if self._draw_focus_displacement and distance then
		local line_1 = Draw:brush(Color.blue:with_alpha(0.5), 2)
		line_1:cylinder(self._shoot_from_pos, prev_target_pos, 0.5)

		local line_2 = Draw:brush(Color.blue:with_alpha(0.5), 2)
		line_2:cylinder(self._shoot_from_pos, target_pos, 0.5)

		if distance > self._focus_displacement then
			local line_3 = Draw:brush(Color.red:with_alpha(0.5), 2)
			line_3:cylinder(target_pos, prev_target_pos, 0.5)
		else
			local line_3 = Draw:brush(Color.green:with_alpha(0.5), 2)
			line_3:cylinder(target_pos, prev_target_pos, 0.5)
		end
	end
end

function CopActionShoot:_debug_draw_obstruction_checks(valid, fire_line, tagret_pos)
	if self._draw_obstruction_checks then
		local fire_line_pos = fire_line and fire_line.position or target_pos

		if fire_line_pos then
			local color = valid and Color.green or Color.red
			local draw_duration = self._shooting_husk_unit and 4 or 2
			local line = Draw:brush(color:with_alpha(0.5), draw_duration)
			line:cylinder(self._shoot_from_pos, fire_line_pos, 0.5)
		end
	end
end

function CopActionShoot:_debug_draw_strict_grenade(valid, shoot_from_pos, target_pos, obstructed)
	if self._draw_strict_grenade_attempts then
		local color = valid and Color.green or Color.red
		local draw_duration = 4
		local target_area = Draw:brush(color:with_alpha(0.25), draw_duration)
		target_area:sphere(target_pos, 500)

		if obstructed then
			local line = Draw:brush(Color.red:with_alpha(0.25), draw_duration)
			line:cylinder(self._shoot_from_pos, target_pos, 20)
		end
	end
end

function CopActionShoot:disable_sniper_laser()
	if self._is_server then
		if self._active_laser then
			self._weapon_base:set_laser_enabled(false)
			self._ext_brain._logic_data.internal_data.weapon_laser_on = nil
			managers.enemy:_create_unit_gfx_lod_data(self._unit)
			self._active_laser = nil
		end
	elseif self._ext_brain._weapon_laser_on then
		self._ext_brain:disable_weapon_laser()
	end
end

function CopActionShoot:enable_sniper_laser()
	if self._is_server then
		if not self._active_laser then
			self._weapon_base:set_laser_enabled(true)
			self._ext_brain._logic_data.internal_data.weapon_laser_on = true
			managers.enemy:_destroy_unit_gfx_lod_data(self._unit:key())
			self._active_laser = true
		end
	elseif not self._ext_brain._weapon_laser_on then
		self._ext_brain:enable_weapon_laser()
	end
end

function CopActionShoot:set_sniper_focus_sound(sound_progress)
	local player = managers.player:player_unit()

	if player then
		local p_dmg_ext = player:character_damage()
		local total_progression = p_dmg_ext._downed_progression or 0

		if sound_progress >= total_progression then
			if p_dmg_ext._tinnitus_data == nil or sound_progress >= p_dmg_ext._tinnitus_data.intensity then
				local set_sound = math_min(100, sound_progress * 100)

				SoundDevice:set_rtpc("downed_state_progression", set_sound)
			end
		end
	end
end

--Throws a grenade and plays relevant lines+animations.
function CopActionShoot:throw_grenade(shoot_from_pos, target_vec, target_pos, distance, force_mul)
	local throw_vec = target_vec * (distance * force_mul)
	if ProjectileBase.throw_projectile(self._grenade.type, shoot_from_pos, throw_vec, nil, self._unit) then
		if not self._grenade.no_anim then
			self._ext_movement:play_redirect("throw_grenade")
			managers.network:session():send_to_peers_synched("play_distance_interact_redirect", self._unit, "throw_grenade")
		end

		if self._grenade.voiceline then
			self._unit:sound():say(self._grenade.voiceline, true, nil, true)
		end

		self._shoot_t = self._shoot_t + 0.6

		return true
	end
end

--Returns true if a grenade is thrown. Otherwise, returns nothing.
function CopActionShoot:update_grenade(target_pos, target_vec, shoot_from_pos, target_dis, t)
	if not self._autofiring and self._common_data.allow_fire then
		--Attempt grenade throwing.
		local grenade = self._grenade
		if grenade and grenade.max_range > target_dis and grenade.min_range < target_dis and t > (self._ext_brain._grenade_t or 0) then --If unit has a grenade, and conditions are met, throw it.
			self._ext_brain._grenade_t = t + grenade.cooldown

			if math_random() <= grenade.chance then
				--Strict throw is a value used by teamai to determine when a good time to launch a grenade is.
				--If the number of 'points' (enemies that are good targets) exceeds the strict_throw value, it uses the grenade. Otherwise, it doesn't use it.
				--Shields count for double.
				--The throw attempt will be blocked by civilians or allies that are in the way.
				local points = 0
				local obstructed = false
				if grenade.strict_throw then --Apply stricter checks for Team AI to try and prevent them from hitting undesired targets or throwing bad grenades.
					local targets = world_g:find_units_quick("sphere", target_pos, 500, managers.slot:get_mask("persons"))

					for i = 1, #targets do
						local curr_target = targets[i]
						local curr_base = curr_target:base()
						if curr_target:in_slot(managers.slot:get_mask("enemies")) then
							if curr_base._tweak_table == "shield" then
								points = points + 2
							else 
								points = points + (curr_base:char_tweak().damage.explosion_damage_mul or 1)
							end
						else
							points = 0
							break
						end
					end

					if points >= grenade.strict_throw then
						local ray = self._unit:raycast("ray", shoot_from_pos, target_pos, "sphere_cast_radius", 20, "slot_mask", managers.slot:get_mask("world_geometry", "vehicles", "all_criminals", "civilians"), "report")
						if ray then
							points = 0
							obstructed = true
						end
					end

					self:_debug_draw_strict_grenade(points >= grenade.strict_throw or obstructed, shoot_from_pos, target_pos, obstructed)
				else --If strict throw is not enabled, use a more generous check to make sure there's no obstructions for the first 2/5ths of the throw path or the min range, whichever is bigger.
					local obstruction_vector = target_vec * (math_max(target_dis * 0.5, grenade.min_range)) --Allocate vector of correct length in direction of target.
					mvec3_add(obstruction_vector, shoot_from_pos) --Have it originate from the shoot pos.

					local ray = self._unit:raycast("ray", shoot_from_pos, obstruction_vector, "sphere_cast_radius", 20, "slot_mask", managers.slot:get_mask("world_geometry"), "report")

					if ray then
						obstructed = true
					end
				end

				local throw_vector = mvec3_copy(shoot_from_pos)
				if grenade.offset then
					mvec3_add(throw_vector, grenade.offset)
				end

				if not obstructed and points >= (grenade.strict_throw or 0) and self:throw_grenade(throw_vector, target_vec, target_pos, target_dis, grenade.throw_force) then
					self._ext_brain._grenade_t = self._ext_brain._grenade_t + (grenade.use_cooldown or 0)
					return true
				end
			end
		end
	end

	return nil
end

local melee_obstruction_vec = Vector3()
function CopActionShoot:_chk_start_melee(t, target_vec, target_dis, autotarget, target_pos, attention)
	--Unit cannot melee attack.
	if not self._melee_weapon_data then
		return false
	end


	--Target is out of range.
	if (self._is_server or autotarget) and target_dis > (self._melee_weapon_data.range - 20) then
		return false
	end

	--Timer state prevents melee attacks.
	if not self._common_data.allow_fire or self._melee_timeout_t > t or (self._common_data.melee_countered_t and t - self._common_data.melee_countered_t < 15) then
		return false
	end


	--Target is an unmeleeable unit.
	local target = attention.unit
	if not target or not target:base() or target:base().is_husk_player or target:base().sentry_gun then
		return false
	end


	--Target has a damage state that can't be meleed.
	local target_damage_ext = target:character_damage()
	if not target_damage_ext or not target_damage_ext.damage_melee or (target_damage_ext.dead and target_damage_ext:dead()) then
		return false
	end

	--Check that no geometry is in the way.
	local shoot_from_pos = self._shoot_from_pos
	local my_fwd = mvec3_copy(self._ext_movement:m_head_rot():z())
	mvec3_set(melee_obstruction_vec, my_fwd)
	mvec3_mul(melee_obstruction_vec, target_dis)
	mvec3_add(melee_obstruction_vec, shoot_from_pos)
	local obstructed_by_geometry = self._unit:raycast("ray", shoot_from_pos, melee_obstruction_vec, "sphere_cast_radius", 20, "slot_mask", managers.slot:get_mask("world_geometry", "vehicles"), "ray_type", "body melee", "report")
	if obstructed_by_geometry then
		return false
	end

	--Check that no shield is in the way. Or, if there is one, that the target unit can be knocked down.
	local target_is_covered_by_shield = self._unit:raycast("ray", shoot_from_pos, melee_obstruction_vec, "sphere_cast_radius", 20, "slot_mask", self._shield_slotmask, "ray_type", "body melee", "report")
	if target_is_covered_by_shield then
		if alive(target:inventory() and target:inventory()._shield_unit) then
			if not self._melee_weapon_data.shield_knock or not target_damage_ext:is_immune_to_shield_knockback() then
				if target:movement():chk_action_forbidden("hurt") then --Target already shield knocked.
					return
				end
			else --No shield knocking, attack blocked.
				return
			end
		end
	end

	--TODO: Clean up animation selection and move to init.
	local is_weapon = melee_weapon == "weapon"
	local redir_name = is_weapon and "melee" or "melee_item"
	local tank_melee = nil

	if self._weap_tweak.usage == "mini" then
		redir_name = "melee_bayonet" --bash with the front of the minigun's barrel like in first person
	elseif self._tank_animations then
		if melee_weapon == "fists_dozer" or melee_weapon == "fists" then
			redir_name = "melee" --use tank_melee unique punching animation as originally intended
			tank_melee = true
		end
	end

	--Attempt to perform melee attack animation.
	local melee_res = self._ext_movement:play_redirect(redir_name)
	if melee_res then
		if self._melee_weapon_data.speed ~= 1 then
			self._common_data.machine:set_speed(melee_res, self._melee_weapon_data.speed)
		end

		if not is_weapon and not tank_melee then
			if type(self._melee_weapon_data.anims) ~= "table" then
				self._common_data.machine:set_parameter(melee_res, self._melee_weapon_data.anims, 1) --Black box function, will need investigation to see what it does.
			else
				local melee_var = self:_pseudorandom(#self._melee_weapon_data.anims)
				self._common_data.machine:set_parameter(melee_res, self._melee_weapon_data.anims[melee_var], 1)
			end
		end

		--let other players see when NPCs attempt a melee attack instead of nothing (not actually cosmetic as melee attacks are tied to the animation, but the necessary checks to prevent issues with that are there)
		managers.network:session():send_to_peers_synched("play_distance_interact_redirect", self._unit, redir_name)

		--Set retry delay.
		if self._melee_weapon_data.retry_delay[1] == self._melee_weapon_data.retry_delay[2] then
			self._melee_timeout_t = t + self._melee_weapon_data.retry_delay[1]
		else
			self._melee_timeout_t = t + math_lerp(self._melee_weapon_data.retry_delay[1], self._melee_weapon_data.retry_delay[2], self:_pseudorandom())
		end

		return true
	end
end

--Stops autofiring gun.
function CopActionShoot:_stop_autofire(play_redirect)
	self._weapon_base:stop_autofire()
	self._autofiring = nil
	self._autoshots_fired = nil
	if play_redirect then
		self._ext_movement:play_redirect("up_idle")
	end
end

--Returns the lerp value used to interpolate between current falloff and previous falloff values.
function CopActionShoot:_get_dis_lerp(c_falloff, p_falloff, dis)
	if (c_falloff.r == p_falloff.r) then
		return dis / c_falloff.r
	end

	return math_min(1, (dis - p_falloff.r) / (c_falloff.r - p_falloff.r))
end

--Get focus progress based on shoot history. If none exist, then assume full focus.
function CopActionShoot:_get_focus_prog(t)
	local shoot_hist = self._shoot_history
	local focus_delay, focus_prog = nil

	--Determine focus progress. Lerps between low and high accuracy values.
	if shoot_hist and shoot_hist.focus_delay then
		--Get actual focus delay with multipliers.
		focus_delay = shoot_hist.focus_delay
		if self._attention.unit and self._attention.unit:character_damage() and self._attention.unit:character_damage().focus_delay_mul then
			focus_delay = self._attention.unit:character_damage():focus_delay_mul() * focus_delay
		end

		--If we have delay, then get the progress.
		if focus_delay > 0 then
			local time_passed = t - shoot_hist.focus_start_t
			focus_prog = time_passed / focus_delay
		end

		if not focus_prog or focus_prog >= 1 then
			shoot_hist.focus_delay = nil
			return 1
		else
			return focus_prog
		end
	end

	--If focus delay is not active, then we're fully focused.
	return 1
end

--Determines if attack is aimed such that it can hit.
--This function is currently called by copactionhurt multiple times, introducing unwanted coupling that can create really shit crash logs to debug.
--In the future, it would be ideal to simplify the code there (it re-implements a LOT of copactionshoot shit) and then change it to make less invasive calls to allegedly private (preceded by _) functions.
--Added dis_lerp and focus_prog parameters to reduce redundant computations.
function CopActionShoot:_get_unit_shoot_pos(t, pos, dis, falloff, i_range, shooting_local_player, dis_lerp, focus_prog)
	--Determine hit chance. Enemies cannot hit heisters more than once within the hit delay.
	local hit_chance = 0
	if not self._next_hit_t or self._next_hit_t < t then --Lets shots go by if nil because
		--Get base hit chance.
		local prev_falloff = self._falloff[math_max(i_range - 1, 1)]

		--Calculate nil values if we don't have them, this code should be cut once CopActionHurt is redone. 
		if not dis_lerp then
			dis_lerp = CopActionShoot:_get_dis_lerp(falloff, prev_falloff, dis)
		end

		--See above.
		if not focus_prog then
			focus_prog = CopActionShoot:_get_focus_prog(t)
		end
		
		local p_hit_chance = math_lerp(prev_falloff.acc[1], prev_falloff.acc[2], focus_prog)
		local c_hit_chance = math_lerp(falloff.acc[1], falloff.acc[2], focus_prog)
		hit_chance = math_lerp(p_hit_chance, c_hit_chance, dis_lerp)

		--Apply modifiers to hit chance.
		if self._common_data.is_suppressed then
			hit_chance = hit_chance * 0.5
		end

		if self._common_data.active_actions[2] and self._common_data.active_actions[2]:type() == "dodge" then
			hit_chance = hit_chance * self._common_data.active_actions[2]:accuracy_multiplier()
		end

		if self._unit:character_damage().accuracy_multiplier then
			hit_chance = hit_chance * self._unit:character_damage():accuracy_multiplier()
		end

		--anim_data and active_action checks don't quite work the same way
		--in this case, this one expires sooner to be more accurate with the dodging aspect of the animation
		if self._attention and self._attention.unit and self._attention.unit:anim_data() and self._attention.unit:anim_data().dodge then
			hit_chance = hit_chance * 0.5
		end
	end

	if math_random() < hit_chance then --Attack hit, set the last hit pos to the current one. Not using pseudorandom because fuck streaky rng.
		mvec3_set(self._shoot_history.m_last_pos, pos)
	else --Otherwise, determine vector to make the shot miss.
		local enemy_vec = temp_vec2

		mvec3_set(enemy_vec, pos)
		mvec3_sub(enemy_vec, self._shoot_from_pos)

		local error_vec = Vector3()

		mvec3_cross(error_vec, enemy_vec, math_up)
		mrot_axis_angle(temp_rot1, enemy_vec, math_random(360))
		mvec3_rot(error_vec, temp_rot1)

		local miss_min_dis = shooting_local_player and 31 or 150
		--Fix for spread rng sometimes causing shots that should miss to hit.
		local error_vec_len = miss_min_dis + self._spread + self._miss_dis * math_random() * (1 - focus_prog)

		mvec3_set_l(error_vec, error_vec_len)
		mvec3_add(error_vec, pos)
		mvec3_set(self._shoot_history.m_last_pos, error_vec)

		return error_vec
	end
end

function CopActionShoot:update(t)
	local vis_state = self._ext_base:lod_stage()

	--Update skipped frames counter when in a lower LOD state and not actively shooting.
	vis_state = vis_state or 4
	if not self._autofiring and vis_state ~= 1 then
		if self._skipped_frames < vis_state * 3 then
			self._skipped_frames = self._skipped_frames + 1

			return
		else
			self._skipped_frames = 1
		end
	end

	local shoot_from_pos = self._shoot_from_pos
	local ext_anim = self._ext_anim
	local attention = self._attention
	local target_pos, target_vec, target_dis, autotarget = nil
	if attention then
		target_pos, target_vec, target_dis, autotarget = self:_get_target_pos(shoot_from_pos, attention, t)

		local tar_vec_flat = temp_vec2
		mvec3_set(tar_vec_flat, target_vec)
		mvec3_set_z(tar_vec_flat, 0)
		mvec3_norm(tar_vec_flat)

		local fwd = self._common_data.fwd

		--Client sided unit turning to match where they're aiming.
		if self._turn_allowed then
			local active_actions = self._common_data.active_actions

			if not active_actions[2] or active_actions[2]:type() == "idle" then
				local queued_actions = self._common_data.queued_actions
				if not queued_actions or not queued_actions[1] and not queued_actions[2] then
					if not self._ext_movement:chk_action_forbidden("turn") then
						local fwd_dot_flat = mvec3_dot(tar_vec_flat, fwd)

						if fwd_dot_flat < 0.96 then
							local spin = tar_vec_flat:to_polar_with_reference(fwd, math_up).spin
							local new_action_data = {
								body_part = 2,
								type = "turn",
								angle = spin
							}

							self._ext_movement:action_request(new_action_data)
						end
					end
				end
			end
		end

		target_vec = self:_upd_ik(target_vec, mvec3_dot(fwd, tar_vec_flat), t)
	end

	if self._ext_anim.base_need_upd then
		self._ext_movement:upd_m_head_pos()
	end

	--If not performing some longer form action, go through the different possible actions and check that they can be done.
	if not ext_anim.reload and not ext_anim.equip and not ext_anim.melee then
		if self._weapon_base:clip_empty() then --Check if magazine is empty. If so, then reload. Given priority over all other actions to reward attentive players that count bullets fired.
			if self._autofiring then
				self:_stop_autofire(true)
			end
			if self._is_server then
				self._exiting_to_reload = true

				local reload_action = {
					body_part = 3,
					type = "reload"
				}

				self._ext_movement:action_request(reload_action)
			end
		elseif not target_vec then --All later actions require a target vector.
			if not self._unit:movement():is_cloaked() and self._shoot_t < t then --Can't perform aggressive action and isn't too preoccupied, will recloak.
				self._unit:movement():set_cloaked(true)
			end
			return
		elseif self:_chk_start_melee(t, target_vec, target_dis, autotarget, target_pos, attention) then --Check if melee attack is performed.
			if self._unit:movement():is_cloaked() then --All aggressive actions uncloak the attacker.
				self._unit:movement():set_cloaked(false)
			end

			if self._autofiring then
				self:_stop_autofire() --Melee animation redirect is active, so don't play idle redirect.
			end
			self._shoot_t = self._shoot_t + 1
		elseif self:update_grenade(target_pos, target_vec, shoot_from_pos, target_dis, t) then --If a grenade is thrown, stop immediately.
			if self._unit:movement():is_cloaked() then
				self._unit:movement():set_cloaked(false)
			end
			return
		elseif not self._common_data.allow_fire then
			if self._autofiring then
				self:_stop_autofire(true)
				self._shoot_t = self._shoot_t + 0.6
			end
		elseif self._autofiring then --Continue autofiring if doing so.
			--TODO: Refactor the autofire portion of update to a standalone function that can be more safely called externally.
			--Determine if attack is a miss and gather relevant locals.
			local falloff, i_range = self:_get_shoot_falloff(target_dis, self._falloff)
			local prev_falloff = self._falloff[math_max(i_range - 1, 1)]
			local dis_lerp = self:_get_dis_lerp(falloff, prev_falloff, target_dis)
			local focus_prog = self:_get_focus_prog(t)
			local new_target_pos = self._shoot_history and self:_get_unit_shoot_pos(t, target_pos, target_dis, falloff, i_range, autotarget, dis_lerp, focus_prog)
			local is_hit = true
			if new_target_pos then
				target_pos = new_target_pos
				is_hit = nil
			end

			--Apply spread.
			local spread = self._spread
			local spread_pos = temp_vec2
			mvec3_rand_orth(spread_pos, target_vec)
			mvec3_set_l(spread_pos, spread)
			mvec3_add(spread_pos, target_pos)
			mvec3_dir(target_vec, shoot_from_pos, spread_pos)

			--Get damage mul
			local dmg_mul = (1 + self._ext_base:get_total_buff("base_damage")) * self:_get_falloff_damage_mul(falloff, prev_falloff, dis_lerp)

			--Fire gun, then handle results.
			local fired = self._weapon_base:trigger_held(shoot_from_pos, target_vec, dmg_mul, autotarget, nil, nil, nil, attention.unit)
			if fired then
				--If in high lod, then play recoil animation.
				if vis_state == 1 and not ext_anim.recoil and not ext_anim.base_no_recoil and not ext_anim.move then
					if self._tank_animations then
						self._ext_movement:play_redirect("recoil_single")
					else
						self._ext_movement:play_redirect("recoil_auto")
					end
				end

				--Update shots fired counter.
				--Null checks are to handle special case where Second Wind ace could knock shooter into stagger state, resulting in the action being interrupted. 
				self._autoshots_fired = (self._autoshots_fired or 0) + 1
				--Check if autofiring has finished firing the planned number of bullets.
				if (self._autofiring or 0) <= self._autoshots_fired then
					self:_stop_autofire(true)
					local p_shoot_delay = math_lerp(prev_falloff.recoil[1], prev_falloff.recoil[2], focus_prog)
					local c_shoot_delay = math_lerp(falloff.recoil[1], falloff.recoil[2], focus_prog)
					local shoot_delay = math_lerp(p_shoot_delay, c_shoot_delay, dis_lerp)

					if self._common_data.is_suppressed then
						shoot_delay = shoot_delay * 1.5
					end

					self._shoot_t = t + shoot_delay
				end

				--If player was hit, miss all bullets until hit_delay is done.
				if fired.hit_player then
					self._next_hit_t = t + self._hit_delay
				end
			end
		elseif self._common_data.char_tweak.no_move_and_shoot and self._common_data.active_actions[2] and self._common_data.active_actions[2]:type() == "walk" then
			self._shoot_t = t + self._common_data.char_tweak.move_and_shoot_cooldown or 1
		elseif self._mod_enable_t < t then --Otherwise, see if starting to shoot is possible.
			local shoot = nil
			if self._line_of_sight_t then --Use self._line_of_sight_t to limit how often LOS is checked. Otherwise, assume we still have line of sight and can shoot.
				if not self._shooting_husk_unit or self._next_vis_ray_t < t then
					if self._shooting_husk_unit then --Only check LOS for husks once every 2 seconds.
						self._next_vis_ray_t = t + 2
					end

					local fire_line_is_obstructed = self._unit:raycast("ray", shoot_from_pos, target_pos, "slot_mask", managers.slot:get_mask("AI_visibility"), "ray_type", "ai_vision")
					if fire_line_is_obstructed then
						if self._use_sniper_focus then --Target left sniper LOS, reset values.
							self:_debug_draw_obstruction_checks(false, fire_line_is_obstructed, target_pos)
							if self._w_usage_tweak.use_laser then
								self:disable_sniper_laser()
							end

							self._sniper_focus_start_t = t
							self._shoot_t = t + self._aim_delay_minmax[1]
						elseif t - self._line_of_sight_t > 7 then --Enemy LOS broken.
							self:_debug_draw_obstruction_checks(false, fire_line_is_obstructed, target_pos)

							local lerp_dis = math_min(1, target_dis / self._falloff[#self._falloff].r)
							local aim_delay = math_lerp(self._aim_delay_minmax[1], self._aim_delay_minmax[2], lerp_dis)

							if self._common_data.is_suppressed then
								aim_delay = aim_delay * 1.5
							end

							self._shoot_t = t + aim_delay
						elseif fire_line_is_obstructed.distance > 300 then
							self:_debug_draw_obstruction_checks(true, fire_line_is_obstructed, target_pos)
							shoot = true
						end
					else
						local shield_in_the_way = nil

						if not self._weapon_base._use_armor_piercing or self._shooting_player then
							if self._shield then
								shield_in_the_way = self._unit:raycast("ray", shoot_from_pos, target_pos, "slot_mask", self._shield_slotmask, "ignore_unit", self._shield, "report")
							else
								shield_in_the_way = self._unit:raycast("ray", shoot_from_pos, target_pos, "slot_mask", self._shield_slotmask, "report")
							end
						end

						if not shield_in_the_way then
							self:_debug_draw_obstruction_checks(true, nil, target_pos)
							shoot = true
						else
							self:_debug_draw_obstruction_checks(false, nil, target_pos)
						end

						if not self._last_vis_check_status and t - self._line_of_sight_t > 1 then
							if self._draw_focus_delay_vis_reset then
								local draw_duration = self._shooting_husk_unit and 4 or 2

								local line_1 = Draw:brush(Color.green:with_alpha(0.5), draw_duration)
								line_1:cylinder(shoot_from_pos, self._shoot_history.m_last_pos, 0.5)

								local line_2 = Draw:brush(Color.green:with_alpha(0.5), draw_duration)
								line_2:cylinder(shoot_from_pos, target_pos, 0.5)

								local line_3 = Draw:brush(Color.green:with_alpha(0.5), draw_duration)
								line_3:cylinder(target_pos, self._shoot_history.m_last_pos, 0.5)
							end

							self._shoot_history.focus_start_t = t
						end

						self._shoot_history.m_last_pos = mvec3_copy(target_pos)
						self._line_of_sight_t = t
					end

					if self._use_sniper_focus then
						if shoot then
							if self._shoot_t < t then --Sniper is focused in, reset value since bullet will be fired.
								if self._shooting_player then
									self:set_sniper_focus_sound(0)
								end
							else --Sniper still focusing in.
								if self._w_usage_tweak.use_laser then
									self:enable_sniper_laser()
								end

								if self._shooting_player then
									local lerp_focus_t = math_min(1, (self._shoot_t - t) / (self._shoot_t - self._sniper_focus_start_t))
									self:set_sniper_focus_sound(1 - lerp_focus_t)
								end
							end
						else
							if self._shooting_player then
								self:set_sniper_focus_sound(0)
							end
						end
					end

					self._last_vis_check_status = shoot
				elseif self._shooting_husk_unit then
					shoot = self._last_vis_check_status
				end
			end

			if shoot and self._shoot_t < t then
				if self._unit:movement():is_cloaked() then
					self._unit:movement():set_cloaked(false)
				end

				local falloff, i_range = self:_get_shoot_falloff(target_dis, self._falloff)
				local prev_falloff = self._falloff[math_max(i_range - 1, 1)]
				local dis_lerp = self:_get_dis_lerp(falloff, prev_falloff, target_dis)
				local rounds_fired = self._automatic_weap and math_round(math_lerp(falloff.burst_size, prev_falloff.burst_size, dis_lerp)) or 1

				if rounds_fired > 1 then --Start autofire.
					self._weapon_base:start_autofire(rounds_fired < 4 and rounds_fired)
					self._autofiring = rounds_fired
					self._autoshots_fired = 0

					if vis_state == 1 and not ext_anim.recoil and not ext_anim.base_no_recoil and not ext_anim.move then
						if self._tank_animations then
							self._ext_movement:play_redirect("recoil_single")
						else
							self._ext_movement:play_redirect("recoil_auto")
						end
					end
				else --Semi Auto
				--TODO: Refactor the single shot portion of update to a standalone function that can be more safely called externally.
					local focus_prog = self:_get_focus_prog(t)

					local new_target_pos = self._shoot_history and self:_get_unit_shoot_pos(t, target_pos, target_dis, falloff, i_range, autotarget, dis_lerp, focus_prog)
					local is_hit = true
					if new_target_pos then
						target_pos = new_target_pos
						is_hit = nil
					end

					--Get damage mul
					local dmg_mul = (1 + self._ext_base:get_total_buff("base_damage")) * self:_get_falloff_damage_mul(falloff, prev_falloff, dis_lerp)

					--Apply spread.
					local spread = self._spread
					local spread_pos = temp_vec2
					mvec3_rand_orth(spread_pos, target_vec)
					mvec3_set_l(spread_pos, spread)
					mvec3_add(spread_pos, target_pos)
					mvec3_dir(target_vec, shoot_from_pos, spread_pos)

					local fired = self._weapon_base:singleshot(shoot_from_pos, target_vec, dmg_mul, autotarget, nil, nil, nil, attention.unit)
					if fired then
						if vis_state == 1 and not ext_anim.base_no_recoil and not ext_anim.move then
							self._ext_movement:play_redirect("recoil_single")
						end

						local fire_rate_multiplier = self._weap_tweak.fire_rate_multiplier or 1
						local c_recoil_1 = falloff.recoil[1] * fire_rate_multiplier
						local c_recoil_2 = falloff.recoil[2] * fire_rate_multiplier
						local p_recoil_1 = prev_falloff.recoil[1] * fire_rate_multiplier
						local p_recoil_2 = prev_falloff.recoil[2] * fire_rate_multiplier
						local p_shoot_delay = math_lerp(p_recoil_1, p_recoil_2, focus_prog)
						local c_shoot_delay = math_lerp(c_recoil_1, c_recoil_2, focus_prog)
						local shoot_delay = math_lerp(p_shoot_delay, c_shoot_delay, dis_lerp)

						if self._common_data.is_suppressed then
							shoot_delay = shoot_delay * 1.5
						end

						if self._use_sniper_focus then
							self._sniper_focus_start_t = t
						end

						if fired.hit_player then
							self._next_hit_t = t + self._hit_delay
						end

						self._shoot_t = t + shoot_delay
					end
				end
			end
		end
	end
end

--Round falloff damage to nearest 10%.
function CopActionShoot:_get_falloff_damage_mul(c_falloff, p_falloff, dis_lerp)
	return math_round(math_lerp(c_falloff.dmg_mul, p_falloff.dmg_mul, dis_lerp) * 10) * 0.1
end

--Enables NPC vs NPC melee.
local melee_hit_non_player_vec = Vector3()
local melee_hit_player_vec = Vector3()
local melee_player_direction_vec = Vector3()
function CopActionShoot:anim_clbk_melee_strike()
	if not self._melee_weapon_data then
		return
	end

	local shoot_from_pos = mvec3_copy(self._shoot_from_pos)
	local my_fwd = mvec3_copy(self._ext_movement:m_head_rot():z())

	--Attempt to hit the player.
	local col_ray
	local local_player = managers.player:player_unit()
	if self._melee_weapon_data.hit_player and alive(local_player) and not self._unit:character_damage():is_friendly_fire(local_player) then
		local player_head_pos = local_player:movement():m_head_pos()
		local player_distance = mvec3_dir(melee_hit_player_vec, shoot_from_pos, player_head_pos)

		if player_distance <= self._melee_weapon_data.range then
			if not self._unit:raycast("ray", shoot_from_pos, player_head_pos, "sphere_cast_radius", 20, "slot_mask", self._melee_weapon_data.slotmask, "ray_type", "body melee", "report") then
				mvec3_set(melee_player_direction_vec, melee_hit_player_vec)
				mvec3_set_z(melee_player_direction_vec, 0)
				mvec3_norm(melee_player_direction_vec)

				local min_dot = math_lerp(0, 0.4, player_distance / self._melee_weapon_data.range)
				local fwd_dot = mvec3_dot(my_fwd, melee_player_direction_vec)

				if fwd_dot >= min_dot then
					col_ray = {
						unit = local_player,
						position = player_head_pos,
						ray = mvec3_copy(melee_hit_player_vec:normalized())
					}

					if self._draw_melee_sphere_rays then
						local draw_duration = 3
						local new_brush = Draw:brush(Color.yellow:with_alpha(0.5), draw_duration)
						local sphere_draw_pos = player_head_pos
						local sphere_draw_size = 5
						new_brush:sphere(sphere_draw_pos, sphere_draw_size)
					end
				end
			end
		end
	end

	--If the player wasn't hit, then attempt to melee whereever the unit was pointing.
	if not col_ray then
		mvec3_set(melee_hit_non_player_vec, my_fwd)
		mvec3_mul(melee_hit_non_player_vec, self._melee_weapon_data.range)
		mvec3_add(melee_hit_non_player_vec, shoot_from_pos)
		col_ray = self._unit:raycast("ray", shoot_from_pos, melee_hit_non_player_vec, "sphere_cast_radius", 20, "slot_mask", self._melee_weapon_data.slotmask, "ray_type", "body melee")

		if self._draw_melee_sphere_rays then
			local draw_duration = 3
			local new_brush = col_ray and Draw:brush(Color.red:with_alpha(0.5), draw_duration) or Draw:brush(Color.white:with_alpha(0.5), draw_duration)
			local sphere_draw_pos = col_ray and col_ray.position or melee_hit_non_player_vec
			local sphere_draw_size = col_ray and 5 or 20
			new_brush:sphere(sphere_draw_pos, sphere_draw_size)
		end
	end

	if col_ray and alive(col_ray.unit) then
		local melee_weapon = self._melee_weapon_data.melee_weapon
		local is_weapon = melee_weapon == "weapon"
		local damage = self._melee_weapon_data.damage * self._melee_weapon_data.dmg_mul * (1 + self._ext_base:get_total_buff("base_damage"))

		managers.game_play_central:physics_push(col_ray) --the function already has sanity checks so it's fine to just use it like this

		local hit_unit = col_ray.unit
		local character_unit, shield_knock = nil

		if self._is_server and hit_unit:in_slot(self._shield_slotmask) and alive(hit_unit:parent())
			and self._melee_weapon_data.shield_knock and not hit_unit:parent():character_damage():is_immune_to_shield_knockback() then
			shield_knock = true
			character_unit = hit_unit:parent()
		end

		character_unit = character_unit or hit_unit
		if character_unit == local_player then
			local action_data = {
				variant = "melee",
				damage = damage,
				weapon_unit = self._weapon_unit,
				attacker_unit = self._unit,
				melee_weapon = melee_weapon,
				push_vel = mvec3_copy(col_ray.ray:with_z(0.1)) * 600 * self._melee_weapon_data.push_mul,
				armor_piercing = self._melee_weapon_data.armor_piercing,
				tase_player = self._melee_weapon_data.electrical,
				col_ray = col_ray
			}

			defense_data = character_unit:character_damage():damage_melee(action_data)
		else
			if self._is_server then --only allow melee damage against NPCs for the host (used in case an enemy targets a client locally but hits something else instead)
				if character_unit:character_damage() and character_unit:base() then
					if character_unit:base().sentry_gun then
						local action_data = {
							variant = "bullet",
							damage = damage,
							weapon_unit = self._weapon_unit,
							attacker_unit = self._unit,
							origin = shoot_from_pos,
							col_ray = col_ray
						}

						defense_data = character_unit:character_damage():damage_bullet(action_data) --sentries/turrets lack a melee damage function
					else
						if character_unit:character_damage().damage_melee and not character_unit:base().is_husk_player then --ignore player husks as the damage CAN be synced and dealt to them
							local variant = shield_knock and "melee" or self._melee_weapon_data.electrical and "taser_tased" or "melee"
							local action_data = {
								variant = variant,
								damage = shield_knock and 0 or damage,
								damage_effect = damage * 2,
								weapon_unit = is_weapon and self._weapon_unit or nil,
								attacker_unit = self._unit,
								shield_knock = shield_knock,
								name_id = melee_weapon,
								col_ray = col_ray
							}

							defense_data = character_unit:character_damage():damage_melee(action_data)
						end
					end
				end

				if character_unit:damage() and col_ray.body:extension() and col_ray.body:extension().damage then --damage objects with body extensions (like glass), just like players are able to
					damage = math_clamp(damage, 0, 63)

					col_ray.body:extension().damage:damage_melee(self._unit, col_ray.normal, col_ray.position, col_ray.ray, damage)
					managers.network:session():send_to_peers_synched("sync_body_damage_melee", col_ray.body, self._unit, col_ray.normal, col_ray.position, col_ray.ray, damage)
				end
			end
		end

		if defense_data and defense_data ~= "friendly_fire" then
			if defense_data == "countered" then
				self._common_data.melee_countered_t = TimerManager:game():time()
				local attack_dir = self._unit:movement():m_com() - character_unit:movement():m_head_pos()

				mvec3_norm(attack_dir)

				local counter_data = {
					damage = 0,
					damage_effect = 1,
					variant = "counter_spooc",
					attacker_unit = character_unit,
					attack_dir = attack_dir,
					col_ray = {
						position = mvector3.copy(self._unit:movement():m_com()),
						body = self._unit:body("body"),
						ray = attack_dir
					},
					name_id = melee_entry
				}

				self._unit:character_damage():damage_melee(counter_data)
			else
				if not shield_knock and character_unit ~= local_player and character_unit:character_damage() and not character_unit:character_damage()._no_blood then
					if character_unit:base().sentry_gun then
						managers.game_play_central:play_impact_sound_and_effects({
							no_decal = true,
							col_ray = col_ray
						})
					else
						managers.game_play_central:sync_play_impact_flesh(col_ray.position, col_ray.ray)
					end
				end
			end
		end
	end
end