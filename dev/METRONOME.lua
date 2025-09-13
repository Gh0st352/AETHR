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
-- instr_n   : instruction budget between hook checks (e.g., 20000)
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
        instr_n      = instr_n or 20000,
        next_at      = os.clock(),
        running      = false,
        _guard       = false,
        _orig_create = coroutine.create,
    _orig_wrap   = coroutine.wrap,
    }
    instance.next_at      = instance.next_at + instance.period
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

-- Internal: hook body (called every instr_n VM instructions)
function AETHR.METRONOME:_hook()
  -- Avoid reentrancy if step_fn itself causes more instructions
  if self._guard or not self.running then return end
  local t = os.clock()
  if t < self.next_at then return end

  self._guard = true
  -- Reduce drift: move forward in whole periods
  local behind = t - self.next_at
  local k = (behind >= 0) and (math.floor(behind / self.period) + 1) or 1
  self.next_at = self.next_at + k * self.period

  local ok, err = pcall(self.step_fn)
  if not ok then io.stderr:write("[Metronome] step error: "..tostring(err).."\n") end
  self._guard = false
end

-- Install hook on a specific thread (or current if nil)
function AETHR.METRONOME:_install_on(thread)
  -- If thread is nil, set hook on the current thread; otherwise set on the given coroutine thread.
  local hook = function() self:_hook() end
  if thread ~= nil then
    debug.sethook(thread, hook, "", self.instr_n)
  else
    -- use the variant without explicit thread to attach to current thread
    debug.sethook(hook, "", self.instr_n)
  end
end

-- Start the metronome: install hooks on current thread and future coroutines.
function AETHR.METRONOME:start()
  if self.running then return end
  self.running = true
  self.next_at = os.clock() + self.period

  -- Hook current thread
  self:_install_on()

  -- Ensure newly created coroutines also get the hook
  local selfref = self
  coroutine.create = function(f)
    local co = selfref._orig_create(f)
    selfref:_install_on(co)
    return co
  end
  coroutine.wrap = function(f)
    local co = selfref._orig_create(f)
    selfref:_install_on(co)
    return function(...)
      local ok, a, b, c, d, e = coroutine.resume(co, ...)
      if not ok then error(a, 2) end
      return a, b, c, d, e
    end
  end
end


-- Stop the metronome: remove hook from current thread and restore coroutine funcs.
function AETHR.METRONOME:stop()
  if not self.running then return end
  self.running = false
  debug.sethook()  -- remove from current thread
  coroutine.create = self._orig_create
  coroutine.wrap   = self._orig_wrap
  -- Note: existing coroutines that already received a hook will keep it.
  -- If you track them, you can call debug.sethook(co, nil) for each.
end