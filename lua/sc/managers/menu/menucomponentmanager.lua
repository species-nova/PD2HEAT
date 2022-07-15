function MenuComponentManager:play_transition(run_in_pause)
    if self._transition_panel then
        self._transition_panel:parent():remove(self._transition_panel)
    end

    self._transition_panel = self._fullscreen_ws:panel():panel({
        layer = 10000,
        name = "transition_panel"
    })

    self._transition_panel:rect({
        name = "fade1",
        valign = "scale ",
        halign = "scale",
        blend_mode = "sub",
        color = Color.white
    })

    local function animate_transition(o)
        local fade1 = o:child("fade1")
        local seconds = 0.5
        local t = 0
        local dt, p = nil

        while t < seconds do
            dt = coroutine.yield()

            if dt == 0 and run_in_pause then
                dt = TimerManager:main():delta_time()
            end

            t = t + dt
            p = t / seconds

            fade1:set_alpha(1 - p)
            --local oneminuspee = 1-p
            --fade1:set_color(oneminuspee,oneminuspee,oneminuspee)
        end
    end

    self._transition_panel:animate(animate_transition)
end
