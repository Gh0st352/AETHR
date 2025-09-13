--- @class AETHR.METRONOME
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
--- @field SCHED AETHR.SCHED Scheduler submodule attached per-instance.
AETHR.METRONOME = {} ---@diagnostic disable-line

AETHR.METRONOME.DATA = {}


-- step_fn   : function to call (e.g., function() sched:step() end)
-- period_s  : seconds between calls (e.g., 0.050 for 50 ms)
function AETHR.METRONOME:New(parent, step_fn, period_s, instr_n)
  -- basic validation with safe fallbacks
  if type(step_fn) ~= "function" then
    io.stderr:write("[Metronome] invalid step_fn passed to New(); expected function, got " .. type(step_fn) .. "\n")
  end
    local instance = {
        AETHR        = parent,
        -- submodule-local caches/state can be initialized here
        _cache       = {},
        step_fn      = step_fn,
        period       = period_s or 0.05,
        running      = false,
        _mode        = nil,          -- currently unused, kept for compatibility
        _timerId     = nil,
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

-- Debug hook fallback removed; using DCS timer exclusively.

-- Start the metronome: install hooks on current thread and future coroutines.
function AETHR.METRONOME:start()
  if self.running then return end
  -- Use DCS timer exclusively
  if not (type(timer) == "table" and type(timer.scheduleFunction) == "function" and type(timer.getTime) == "function") then
    local msg = "[Metronome] DCS timer API not available; cannot start."
    if env and env.info then env.info(msg) end
    if io and io.stderr then io.stderr:write(msg.."\n") end
    return
  end

  self.running = true
  local selfref = self
  local period = self.period
  local function driver(arg, time)
    if not selfref.running then return nil end
    local ok, err = pcall(selfref.step_fn)
    if not ok then
      if env and env.info then env.info("[Metronome] step error: "..tostring(err)) end
      if io and io.stderr then io.stderr:write("[Metronome] step error: "..tostring(err).."\n") end
    end
    return time + period
  end
  self._timerId = timer.scheduleFunction(driver, nil, timer.getTime() + period)
end


-- Stop the metronome: remove hook from current thread and restore coroutine funcs.
function AETHR.METRONOME:stop()
  if not self.running then return end
  -- Cancel future invocations (if removeFunction exists)
  if type(timer) == "table" and type(timer.removeFunction) == "function" and self._timerId then
    pcall(timer.removeFunction, self._timerId)
  end
  self._timerId = nil
  self.running = false
end