local flashbang_test_offset = Vector3(0, 0, 150)

local ids_dof_near_plane = Idstring("near_plane")
local ids_dof_far_plane = Idstring("far_plane")
local ids_dof_settings = Idstring("settings")
local mvec1 = Vector3()
local mvec2 = Vector3()
local temp_vec_1 = Vector3()
local temp_vec_2 = Vector3()

local init_orig = CoreEnvironmentControllerManager.init
function CoreEnvironmentControllerManager:init()
    init_orig(self)
	self._effect_manager = World:effect_manager()
	self._base_chromatic_amount = -0.4
    self._GAME_DEFAULT_COLOR_GRADING = "color_payday"
end

function CoreEnvironmentControllerManager:set_chromatic_enabled(enabled)
	self._chromatic_enabled = enabled

	if self._material then
		if self._chromatic_enabled then
			self._material:set_variable(Idstring("chromatic_amount"), self._base_chromatic_amount)
		else
			self._material:set_variable(Idstring("chromatic_amount"), 0)
		end
	end
end

local hurt_screen_ids = Idstring("effects/pd2_mod_heatgen/particles/character/playerscreen/hurt_screen")
local pain_ids = Idstring("pain")
local pain_flash_ids = Idstring("painflash")
local opacity_ids = Idstring("opacity")

function CoreEnvironmentControllerManager:start_player_hurt_screen()
	if not self._hurt_effect then
		self._hurt_effect = self._effect_manager:spawn({
			effect = hurt_screen_ids,
			position = Vector3(),
			rotation = Rotation()
		})
		local value = self._health_effect_value
		local pain = math.lerp(255, 0, value)
		local painflash = math.lerp(255, 0, value + value)
		
		self._effect_manager:set_simulator_var_float(self._hurt_effect, pain_ids, opacity_ids, opacity_ids, pain)
		self._effect_manager:set_simulator_var_float(self._hurt_effect, pain_flash_ids, opacity_ids, opacity_ids, painflash)
	end
end

function CoreEnvironmentControllerManager:kill_player_hurt_screen()
	if self._hurt_effect then
		self._effect_manager:kill(self._hurt_effect)
		self._hurt_effect = nil
	end
end

local ids_radial_pos = Idstring("radial_pos")
local ids_radial_offset = Idstring("radial_offset")
local ids_tgl_r = Idstring("tgl_r")
local hit_feedback_rlu = Idstring("hit_feedback_rlu")
local hit_feedback_d = Idstring("hit_feedback_d")
local ids_hdr_post_processor = Idstring("hdr_post_processor")
local ids_hdr_post_composite = Idstring("post_DOF")
local ids_anti_aliasing_processor = Idstring("anti_aliasing_post_processor")
local ids_ao_post_processor = Idstring("ao_post_processor")
local ids_ao_mask_post_processor = Idstring("ao_mask_post_processor")
local new_cam_fwd = Vector3()
local new_cam_up = Vector3()
local new_cam_right = Vector3()
local ids_LUT_post = Idstring("color_grading_post")
local ids_LUT_settings = Idstring("lut_settings")
local ids_LUT_settings_a = Idstring("LUT_settings_a")
local ids_LUT_settings_b = Idstring("LUT_settings_b")
local ids_LUT_contrast = Idstring("contrast")

function CoreEnvironmentControllerManager:set_post_composite(t, dt)
	local vp = managers.viewport:first_active_viewport()

	if not vp then
		return
	end

	if self._occ_dirty then
		self._occ_dirty = false

		self:_refresh_occ_params(vp)
	end

	if self._fov_ratio_dirty then
		self:_refresh_fov_ratio_params(vp)

		self._fov_ratio_dirty = false
	end

	if self._vp ~= vp or not alive(self._material) then
		local hdr_post_processor = vp:vp():get_post_processor_effect("World", ids_hdr_post_processor)

		if hdr_post_processor then
			local post_composite = hdr_post_processor:modifier(ids_hdr_post_composite)

			if not post_composite then
				return
			end

			self._material = post_composite:material()

			if not self._material then
				return
			end

			self._vp = vp

			self:_update_post_effects()
		end
	end

	local camera = vp:camera()
	local color_tweak = mvec1

	if camera then
		-- Nothing
	end

	if self._old_vp ~= vp then
		self._occ_dirty = true
		self._fov_ratio_dirty = true

		self:refresh_render_settings()

		self._old_vp = vp
	end

	local blur_zone_val = 0
	blur_zone_val = self:_blurzones_update(t, dt, camera:position())

	if self._hit_some > 0 then
		local hit_fade = dt * 1.5
		self._hit_some = math.max(self._hit_some - hit_fade, 0)
		self._hit_right = math.max(self._hit_right - hit_fade, 0)
		self._hit_left = math.max(self._hit_left - hit_fade, 0)
		self._hit_up = math.max(self._hit_up - hit_fade, 0)
		self._hit_down = math.max(self._hit_down - hit_fade, 0)
		self._hit_front = math.max(self._hit_front - hit_fade, 0)
		self._hit_back = math.max(self._hit_back - hit_fade, 0)
	end

	local flashbang = 0
	local flashbang_flash = 0

	if self._current_flashbang > 0 then
		local flsh = self._current_flashbang
		self._current_flashbang = math.max(self._current_flashbang - dt * 0.08 * self._flashbang_multiplier * self._flashbang_duration, 0)
		flashbang = math.min(self._current_flashbang, 1)
		self._current_flashbang_flash = math.max(self._current_flashbang_flash - dt * 0.9, 0)
		flashbang_flash = math.min(self._current_flashbang_flash, 1)
	end

	local concussion = 0

	if self._current_concussion > 0 then		
		local dt_mul = 0.16 / self._concussion_duration
		
		if self._current_concussion < 1 then
			dt_mul = 0.32
		end
		
		self._current_concussion = math.max(self._current_concussion - dt * dt_mul, 0)
		concussion = self._current_concussion
	end

	local hit_some_mod = 1 - self._hit_some
	hit_some_mod = hit_some_mod * hit_some_mod * hit_some_mod
	hit_some_mod = 1 - hit_some_mod
	local downed_value = self._downed_value / 100
	local death_mod = math.max(1 - self._health_effect_value - 0.5, 0) * 2
	local blur_zone_flashbang = blur_zone_val + flashbang
	local flash_1 = math.pow(flashbang, 0.4)
	flash_1 = flash_1 + math.pow(concussion, 0.4)
	local flash_2 = math.pow(flashbang, 16) + flashbang_flash

	if self._custom_dof_settings then
		self._material:set_variable(ids_dof_settings, self._custom_dof_settings)
	elseif flash_1 > 0 then
		self._material:set_variable(ids_dof_settings, Vector3(math.min(self._hit_some * 10, 1) + blur_zone_flashbang * 0.4, math.min(blur_zone_val + downed_value * 2 + flash_1, 1), 10 + math.abs(math.sin(t * 10) * 40) + downed_value * 3))
	else
		self._material:set_variable(ids_dof_settings, Vector3(math.min(self._hit_some * 10, 1) + blur_zone_flashbang * 0.4, math.min(blur_zone_val + downed_value * 2, 1), 1 + downed_value * 3))
	end

	self._material:set_variable(ids_radial_offset, Vector3((self._hit_left - self._hit_right) * 0.2, (self._hit_up - self._hit_down) * 0.2, self._hit_front - self._hit_back + blur_zone_flashbang * 0.1))
	self._material:set_variable(Idstring("contrast"), self._base_contrast + self._hit_some * 0.25)

	if self._chromatic_enabled then
		self._material:set_variable(Idstring("chromatic_amount"), self._base_chromatic_amount + blur_zone_val * 0.3 + flash_1 * 0.5)
	else
		self._material:set_variable(Idstring("chromatic_amount"), 0)
	end

	self:_update_dof(t, dt)

	local lut_post = vp:vp():get_post_processor_effect("World", ids_LUT_post)

	if lut_post then
		local lut_modifier = lut_post:modifier(ids_LUT_settings)

		if not lut_modifier then
			return
		end

		self._lut_modifier_material = lut_modifier:material()

		if not self._lut_modifier_material then
			return
		end
	end

	local hurt_mod = 1 - self._health_effect_value
	local health_diff = math.clamp((self._old_health_effect_value - self._health_effect_value) * 4, 0, 1)
	self._old_health_effect_value = self._health_effect_value

	if self._health_effect_value_diff < health_diff then
		self._health_effect_value_diff = health_diff
	end

	self._health_effect_value_diff = math.max(self._health_effect_value_diff - dt * 0.5, 0)
	self._buff_effect_value = math.min(self._buff_effect_value + dt * 0.5, 0)

	mvector3.set(temp_vec_1, Vector3(math.clamp(self._health_effect_value_diff * 1.3 * (1 + hurt_mod * 1.3), 0, 1.2), 0, math.min(blur_zone_val + self._HE_blinding, 1)))
	mvector3.add(temp_vec_1, Vector3(self._buff_effect_value, self._buff_effect_value, self._buff_effect_value, 0.5))
	self._lut_modifier_material:set_variable(ids_LUT_settings_a, temp_vec_1)

	if self._hurt_effect then
		local value = self._health_effect_value
		local pain = math.lerp(200, 0, value)
		local painflash = math.lerp(255, 0, value + value)
		
		self._effect_manager:set_simulator_var_float(self._hurt_effect, pain_ids, opacity_ids, opacity_ids, pain)
		self._effect_manager:set_simulator_var_float(self._hurt_effect, pain_flash_ids, opacity_ids, opacity_ids, painflash)
	end

	local last_life = 0

	if self._last_life then
		if self._hurt_effect then
			last_life = math.clamp((hurt_mod - 0.5) * 2, 0, 0.75)
		else
			last_life = math.clamp((hurt_mod - 0.5) * 2, 0, 1)
		end
	end

	self._lut_modifier_material:set_variable(ids_LUT_settings_b, Vector3(last_life, flash_2 + math.clamp(hit_some_mod * 2, 0, 1) * 0.25 + blur_zone_val * 0.15, 0))
	self._lut_modifier_material:set_variable(ids_LUT_contrast, flashbang * 0.5)
end

Hooks:PostHook(CoreEnvironmentControllerManager, "set_post_composite", "alt_down", function(self, t, dt)
    if not heat.Options:GetValue("AltLastDownColor") then
        return --you people were running this function twice, causing double the amount of updates
    end
	
    local vp = managers.viewport:first_active_viewport()

	if not vp then
		return
    end

    if not alive(self._vp) then
		return
	end

	local last_life = 0

    if self._last_life then
        last_life = 0 and self._vp:vp():set_post_processor_effect("World", Idstring("color_grading_post"), Idstring("color_sin_classic"))
        self._ignore_user_color_grading = true
    else
        local color_grading = self._default_color_grading

        if not self._ignore_user_color_grading then
            color_grading = managers.user:get_setting("video_color_grading") or self._default_color_grading
        end
        self._vp:vp():set_post_processor_effect("World", Idstring("color_grading_post"), Idstring(color_grading))
	end
end)

function CoreEnvironmentControllerManager:test_line_of_sight(test_pos, min_distance, dot_distance, max_distance, is_flashbang)
	local tmp_vec1 = Vector3()
	local tmp_vec2 = Vector3()
	local tmp_vec3 = Vector3()
	local vp = managers.viewport:first_active_viewport()

	if not vp then
		return 0
	end

	local camera = vp:camera()
	local cam_pos = tmp_vec1

	camera:m_position(cam_pos)

	local test_vec = tmp_vec2
	local dis = mvector3.direction(test_vec, cam_pos, test_pos)

	if max_distance < dis then
		return 0
	end

	if dis < min_distance then
		if is_flashbang then
			managers.player:player_unit():sound():say("g41x_any", true)
		end

		return 1
	end

	local dot_mul = 1
	local max_dot = math.cos(75)
	local cam_rot = camera:rotation()
	local cam_fwd = camera:rotation():y()
	local dot_to_cam = mvector3.dot(cam_fwd, test_vec)

	if dot_to_cam < max_dot then
		--log("dot_to_cam: " .. tostring(dot_to_cam) .. "")
		if dis < dot_distance then
		
			if dot_to_cam < 0 then
				dot_distance = dot_distance * 0.5
			end
			
			dot_mul = 0.75 * math.lerp(1, 0.5, dis / (dot_distance - min_distance))
			--log(tostring(dot_mul))
		else
			return 0
		end
	end

	local ray_hit = World:raycast("ray", cam_pos, test_pos, "slot_mask", managers.slot:get_mask("AI_visibility"), "ray_type", "ai_vision", "report")

	if ray_hit then
		return 0
	end

	local flash = math.max(dis - min_distance, 0) / (max_distance - min_distance)
	flash = (1 - flash) * dot_mul

	if is_flashbang and dot_mul == 1 then
		managers.player:player_unit():sound():say("g41x_any", true)
	end

	return flash
end

function CoreEnvironmentControllerManager:set_flashbang(flashbang_pos, line_of_sight, travel_dis, linear_dis, duration)
	local concussion = self:test_line_of_sight(flashbang_pos + flashbang_test_offset, 200, 1500, 3000, true)
	
	self._concussion_duration = duration
	
	if concussion > 0 then
		concussion = concussion + concussion
		if self._old_concussion_t then	
			local t = TimerManager:game():time()
			local conc_duration = 6.5 * self._concussion_duration
			local duration_lerp = math.min(t - self._old_concussion_t, conc_duration) / conc_duration
			concussion = concussion * duration_lerp
			
			self._current_concussion = math.min(self._current_concussion + concussion, 2)	
		else
			self._current_concussion = concussion
		end
		
		self._old_concussion_t = TimerManager:game():time()
	end
	
	if self._current_concussion > 1 and not self._concussion_effect then
		--log("fuck")
		
		if BLT.Mods:GetModByName("PDTH Contours") then
			self._pdth_conc = true
			self._concussion_effect = self._effect_manager:spawn({
				effect = Idstring("effects/pd2_mod_heatgen/particles/character/playerscreen/conc_floaties_pdth"),
				position = Vector3(),
				rotation = Rotation()
			})
		else
			self._concussion_effect = self._effect_manager:spawn({
				effect = Idstring("effects/pd2_mod_heatgen/particles/character/playerscreen/conc_floaties"),
				position = Vector3(),
				rotation = Rotation()
			})
		end
	end
	
	self._effect_manager:spawn({
		effect = Idstring("effects/particles/explosions/explosion_grenade"),
		position = flashbang_pos,
		normal = Vector3(0, 0, 1)
	})
end

local opacity_ids = Idstring("opacity")
local blindness_ids = Idstring("blindness")

function CoreEnvironmentControllerManager:update(t, dt)
	self:_update_values(t, dt)
	self:set_post_composite(t, dt)
	
	if self._concussion_effect and self._current_concussion <= 0.8 then
		if self._pdth_conc then
			local lerp = self._current_concussion / 0.8
			local value = math.lerp(0, 255, lerp)
			
			self._effect_manager:set_simulator_var_float(self._concussion_effect, blindness_ids, opacity_ids, opacity_ids, value)
			
			if value == 0 then
				self._effect_manager:fade_kill(self._concussion_effect)
				self._concussion_effect = nil
			end
		else
			self._effect_manager:fade_kill(self._concussion_effect)
			self._concussion_effect = nil
			self._pdth_conc = nil
		end
	end
end