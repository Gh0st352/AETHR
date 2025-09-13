--- @class AETHR.SCHED
--- @brief
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field MATH AETHR.MATH Math helper table attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field ENUMS AETHR.ENUMS ENUMS submodule attached per-instance.
--- @field UTILS AETHR.UTILS Utility functions helper table attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field MARKERS AETHR.MARKERS Markers submodule attached per-instance.
--- @field DATA AETHR.BRAIN.Data Container for scheduling, coroutine, and timing data.
--- @field METRONOME AETHR.METRONOME Metronome submodule attached per-instance.
AETHR.SCHED = {} ---@diagnostic disable-line
--AETHR.SCHED.__index = AETHR.SCHED

--[[ Non-blocking Lua 5.1 Scheduler (no socket, no sleeps)
     - Call sched:step() regularly from main loop (frame/update/iteration).
     - step() runs due tasks and returns seconds until the next task (or nil if none).
     - API:
         local sched = Scheduler.new()
         sched:every(1.0, fn, {name="tick", first_in=0.0, times=math.huge})
         sched:after(5.0, fn, {name="once"})
         sched:cancel("tick")
         sched:stop()
         local next_in = sched:step()
--]]

AETHR.SCHED.DATA = {}


function AETHR.SCHED:New(parent, opts)
    local instance = {
        AETHR       = parent,
        -- submodule-local caches/state can be initialized here
        _cache      = {},
        tasks       = {},
        running     = true,
        on_error    = (opts and opts.on_error) or function(name, err)
            io.stderr:write(("[Scheduler] %s error: %s\n"):format(tostring(name), tostring(err)))
        end,
        -- Hybrid time base (sub-second precision) without socket:
        _last_wall  = os.time(),
        _base_wall  = 0,
        _base_clock = os.clock(),
    }
    instance._base_wall = instance._last_wall
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

-- Monotonic-ish current time in seconds using os.time + os.clock
function AETHR.SCHED:_now()
    local wall = os.time()
    if wall > self._last_wall then
        self._last_wall  = wall
        self._base_wall  = wall
        self._base_clock = os.clock()
        return wall
    else
        local frac = os.clock() - self._base_clock
        if frac < 0 then frac = 0 end
        if frac >= 0.999999 then frac = 0.999999 end
        return self._base_wall + frac
    end
end

function AETHR.SCHED:_add_task(name, fn, first_in, every, times)
    assert(type(fn) == "function", "fn must be a function")
    name = name or tostring(fn)
    local anchor = self:_now()
    self.tasks[name] = {
        name      = name,
        fn        = fn,
        next_time = anchor + (first_in or 0),
        every     = every,          -- nil for one-shot
        times     = times or math.huge, -- how many runs total
        ran       = 0,
        anchor    = anchor,         -- for drift-free repeating
    }
    return name
end

-- Repeating task: fn(now, runCount)
function AETHR.SCHED:every(interval, fn, opts)
    opts           = opts or {}
    local first_in = (opts.first_in ~= nil) and opts.first_in or interval
    local times    = opts.times or math.huge
    local name     = opts.name
    return self:_add_task(name, fn, first_in, interval, times)
end

-- One-shot after delay seconds
function AETHR.SCHED:after(delay, fn, opts)
    opts = opts or {}
    local name = opts.name
    return self:_add_task(name, fn, delay, nil, 1)
end

function AETHR.SCHED:cancel(name)
    if self.tasks[name] then
        self.tasks[name] = nil; return true
    end
    return false
end

function AETHR.SCHED:stop() self.running = false end

-- Non-blocking pump: run due tasks; return seconds until next task (or nil)
function AETHR.SCHED:step()
    if not self.running then return nil end
    local n = self:_now()
    local soonest

    for name, t in pairs(self.tasks) do
        if t.next_time <= n then
            local ok, err = pcall(t.fn, n, t.ran)
            t.ran = t.ran + 1
            if not ok then self.on_error(name, err) end

            if t.every and t.ran < t.times then
                -- Drift-free reschedule from anchor
                local elapsed = n - t.anchor
                local k = math.floor(elapsed / t.every) + 1
                t.next_time = t.anchor + k * t.every
                if t.next_time <= n then t.next_time = n + t.every end
            else
                self.tasks[name] = nil
            end
        end

        if self.tasks[name] then
            if not soonest or t.next_time < soonest then soonest = t.next_time end
        end
    end

    if not soonest then return nil end
    local next_in = soonest - n
    if next_in < 0 then next_in = 0 end
    return next_in
end
