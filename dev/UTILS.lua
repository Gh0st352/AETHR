--- @class AETHR.UTILS
--- @brief Manages mission trigger zones and computes bordering relationships.
--- @diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field DATA table Container for zone management data.
AETHR.UTILS = {} ---@diagnostic disable-line

---@class AETHR.UTILS.DATA
--- @field _cache table Internal cache for UTILS instance.
--- @field _rateLog table Internal cache for rate-limited logging.
AETHR.UTILS.DATA = {
  _cache = {},
  _rateLog = {},
}


--- Creates a new AETHR.UTILS submodule instance.
--- @function AETHR.UTILS:New
--- @param parent AETHR Parent AETHR instance
--- @return AETHR.UTILS instance New instance inheriting AETHR.UTILS methods.
function AETHR.UTILS:New(parent)
  local instance = {
    AETHR = parent,
    -- submodule-local caches/state can be initialized here
    _cache = {},
  }
  setmetatable(instance, { __index = self })
  return instance ---@diagnostic disable-line
end

--- Returns the number of entries in a table (non-nil keys).
--- Performs a linear iteration over pairs(t) and counts entries.
--- @function AETHR.UTILS.sumTable
--- @param t table Table to count keys in.
--- @return integer count Number of keys in the table.
function AETHR.UTILS.sumTable(t)
  local sum = 0
  for k, v in pairs(t) do
    sum = sum + 1
  end
  return sum
end

--- timer.getTime( ) Returns the mission start time in seconds.
--- timer.getAbsTime( ) Returns the game world time in seconds relative to time the mission started.
--- Returns the elapsed mission time in seconds (timer.getAbsTime - timer.getTime0).
--- @function AETHR.UTILS.getTime
--- @return number time_s Current time in seconds (approx).
function AETHR.UTILS.getTime()
  return timer.getAbsTime() - timer.getTime0()
end

--- Log debug information if debugging is enabled.
---
--- Logs a given message when the CONFIG.MAIN.DEBUG_ENABLED flag is set on the instance.
--- If additional structured data is provided, attempts to log via global BASE:E if available.
--- Guards against missing global functions (env.info, BASE:E) and fails silently on errors.
---
--- @param message string The debug message to be logged.
--- @param data any|nil Optional structured data to be logged via BASE:E when available.
--- @usage AETHR.UTILS:debugInfo("Debug Message", {key="value"}) -- Logs the message and data if debugging is enabled.
--- Fast debug flag check (min overhead when disabled)
--- @return boolean
function AETHR.UTILS:isDebug()
  local cfg = self and self.CONFIG and self.CONFIG.MAIN
  return cfg and cfg.DEBUG_ENABLED == true
end

--- Log debug information if debugging is enabled (rate-unlimited).
--- Thin wrapper to minimize overhead when disabled.
--- @param message string
--- @param data any|nil
function AETHR.UTILS:debugInfo(message, data)
  if not self:isDebug() then return end

  -- Safely call env.info if available
  if type(env) == "table" and type(env.info) == "function" then
    pcall(function() env.info(tostring(message)) end)
  end

  -- If structured data provided, attempt to log via BASE:E if available; fail silently otherwise
  if data ~= nil then
    if type(BASE) == "table" and type(BASE.E) == "function" then
      pcall(function() BASE:E(data) end)
    end
  end
end

--- Rate-limited debug logger to reduce spam in hot loops.
--- Uses an in-instance cache to remember last emission per key.
--- @param key string Unique key for the log line (also used as message)
--- @param intervalSeconds number Minimum seconds between emissions for this key
--- @param data any|nil Optional structured data
function AETHR.UTILS:debugInfoRate(key, intervalSeconds, data)
  if not self:isDebug() then return end
  intervalSeconds = tonumber(intervalSeconds) or 1
  local _rateLog = self.DATA._rateLog
  self._cache = self._cache or {}
  self._cache._rateLog = self._cache._rateLog or {}

  local k = tostring(key or "")
  local last = self._cache._rateLog[k] or 0

  -- Prefer engine time if available; fall back to os.time()
  local now =
      (type(AETHR) == "table" and AETHR.UTILS and type(AETHR.UTILS.getTime) == "function" and AETHR.UTILS.getTime())
      or (type(self.getTime) == "function" and self.getTime())
      or (type(os) == "table" and type(os.time) == "function" and os.time())
      or 0
  if type(now) ~= "number" then now = 0 end

  if (now - last) >= intervalSeconds then
    self._cache._rateLog[k] = now
    self:debugInfo(k, data)
  end
end

--- Return the vertical coordinate for a point-like table.
--- Accepts tables with either `.y` or `.z` fields (DCS commonly uses `z` for map Y).
--- @param pt AETHR.PointLike|nil Point or nil.
--- @return number|nil y y-coordinate or nil if pt absent
function AETHR.UTILS:getPointY(pt)
  if not pt then return nil end
  return pt.y or pt.z
end

--- Normalize a point-like table into { x = number, y = number } form.
--- Does not modify the input table; returns a new table. Missing components default to 0.
--- @param pt AETHR.PointLike|nil
--- @return AETHR.NormalizedPoint normalized point
function AETHR.UTILS:normalizePoint(pt)
  if not pt then return { x = 0, y = 0 } end
  return { x = pt.x or 0, y = (pt.y ~= nil) and pt.y or (pt.z or 0) }
end

--- Alias for legacy name table_hasValue -> hasValue
--- Performs a linear search for value equality using pairs iteration.
--- @param tbl table Table to search through.
--- @param val any Value to search for.
--- @return boolean True if found, false otherwise.
function AETHR.UTILS:hasValue(tbl, val)
  for index, value in pairs(tbl) do
    if value == val then
      return true
    end
  end
  return false
end

-- keep backward-compatible function name
--- Backwards-compatible alias: calls :hasValue
--- @function AETHR.UTILS:table_hasValue
--- @param tbl table
--- @param val any
--- @return boolean
function AETHR.UTILS:table_hasValue(tbl, val) return self:hasValue(tbl, val) end

--- Safely resolve a dotted path against the global environment `_G`.
--- Example: "Object.Category.UNIT"
--- If any part is missing or an intermediate value is not a table, returns the provided fallback.
--- @param path string Dotted path string to resolve (e.g. "A.B.C")
--- @param fallback any Value to return when lookup fails.
--- @return any value Resolved value or `fallback` if not found.
function AETHR.UTILS.safe_lookup(path, fallback)
  -- path: string like "Object.Category.UNIT"
  -- fallback: value to return if lookup fails
  local cur = _G
  for part in string.gmatch(path, "[^%.]+") do
    if type(cur) ~= "table" then return fallback end
    cur = cur[part]
    if cur == nil then return fallback end
  end
  return cur
end

--- Update markup colors (line and fill) for a DCS markup object.
--- Wraps trigger.action.setMarkupColor and setMarkupColorFill for convenience and returns the instance for chaining.
--- @param markupID integer DCS markup object ID.
--- @param lineColor AETHR.Color Color table used for the outline/line.
--- @param fillColor AETHR.Color Color table used for the fill.
--- @return AETHR.UTILS self The UTILS instance (for method chaining).
function AETHR.UTILS:updateMarkupColors(markupID, lineColor, fillColor)
  trigger.action.setMarkupColor(markupID, lineColor)
  trigger.action.setMarkupColorFill(markupID, fillColor)
  return self
end

--- Pick a random key from a KV table.
---
--- Selects and returns a random key from the provided table.
---
--- @param t table The table from which to pick a random element.
--- @return any key The randomly selected element from the table.
--- @usage local randomElement = SPECTRE.UTILS.PickRandomFromTable({1, 2, 3, 4, 5}) -- Returns a random number from the input list.
function AETHR.UTILS:pickRandomKeyFromTable(t)
  local keys = {}
  for k in pairs(t) do
    table.insert(keys, k)
  end
  local keys = self:Shuffle(keys)
  local key = keys[math.random(#keys)]
  return key
end

--- Shuffle the elements of a table.
---
--- Creates a shuffled copy of the input table using the Fisher-Yates algorithm.
---
--- @param t table The table to be shuffled.
--- @return table s A shuffled copy of the input table.
--- @usage local shuffled = SPECTRE.UTILS.Shuffle({1, 2, 3, 4, 5}) -- Returns a shuffled version of the input list.
function AETHR.UTILS:Shuffle(t)
  local s = {}
  for i = 1, #t do
    s[i] = t[i]
  end
  for i = #s, 2, -1 do
    local j = math.random(i) -- Random index from 1 to i
    s[i], s[j] = s[j], s[i]  -- Swap elements at indices i and j
  end
  return s
end

--- Run a function within a deterministic RNG scope and optionally reseed afterward.
---
--- Notes:
--- - Lua 5.1 does not support saving/restoring RNG state, so this reseeds the global RNG.
--- - When reseedAfter is true, RNG is scrambled with a best-effort non-deterministic seed post-run.
--- - Warmup performs extra calls to math.random() to avoid low-entropy initial outputs.
--- @function AETHR.UTILS:withSeed
--- @param seed number Non-negative numeric seed.
--- @param fn function Callback to execute inside the deterministic scope.
--- @param warmup integer|nil Number of warmup calls to math.random() (default: 2).
--- @param reseedAfter boolean|nil When true, reseeds RNG with a mixed seed after fn (default: true).
--- @return any Returns fn(...) results or re-raises error thrown by fn.
function AETHR.UTILS:withSeed(seed, fn, warmup, reseedAfter)
  -- Guard inputs
  if type(fn) ~= "function" then return nil end
  local s = tonumber(seed) or 0
  if s < 0 then s = -s end

  -- Seed and warmup
  math.randomseed(s)
  local w = tonumber(warmup) or 2
  if w < 0 then w = 0 end
  for i = 1, w do math.random() end

  -- Execute protected
  local ok, res1, res2, res3, res4 = pcall(fn)

  -- Optional scramble/restore-ish RNG
  if reseedAfter == nil or reseedAfter == true then
    self._cache            = self._cache or {}
    self._cache._rng_nonce = (self._cache._rng_nonce or 0) + 1
    local tAbs             = (type(timer) == "table" and type(timer.getAbsTime) == "function") and
        (timer.getAbsTime() or 0) or 0
    local tNow             = (type(timer) == "table" and type(timer.getTime) == "function") and (timer.getTime() or 0) or
        0
    local mem              = (type(collectgarbage) == "function") and (collectgarbage("count") or 0) or 0
    local clk              = (type(os) == "table" and type(os.clock) == "function") and (os.clock() or 0) or 0
    local mix              = math.floor((tAbs * 1e6) + (tNow * 1e3) + (mem * 10) + (clk * 1e5) + self._cache._rng_nonce)
    math.randomseed(mix)
    -- Stir a bit
    for i = 1, 3 do math.random() end
  end

  if not ok then error(res1) end
  return res1, res2, res3, res4
end