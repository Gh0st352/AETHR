--- @class AETHR.UTILS
--- @brief Manages mission trigger zones and computes bordering relationships.
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field DATA table Container for zone management data.
--- @field DATA.AIRBASES table -- Airbase descriptors keyed by displayName.
AETHR.UTILS = {} ---@diagnostic disable-line
AETHR.UTILS.DATA = {

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

-- --- Checks whether a value exists in a table (legacy name).
-- --- @function AETHR.UTILS:table_hasValue
-- --- @param tbl table Table to search.
-- --- @param val any Value to search for.
-- --- @return boolean True if found, false otherwise.
-- function AETHR.UTILS:table_hasValue(tbl, val)
--   for index, value in pairs(tbl) do
--     if value == val then
--       return true
--     end
--   end
--   return false
-- end

--- Returns the number of entries in a table (non-nil keys).
--- @function AETHR.UTILS.sumTable
--- @param t table
--- @return integer count Number of keys in the table.
function AETHR.UTILS.sumTable(t)
  local sum = 0
  for k, v in pairs(t) do
    sum = sum + 1
  end
  return sum
end

--- Returns current time in milliseconds using os.time + os.clock fractional component.
--- @function AETHR.UTILS.getTime
--- @return number time_ms Current time in milliseconds (approx).
function AETHR.UTILS.getTime()
  local seconds_part = os.time()
  local fractional_seconds_part = os.clock() % 1 -- Get the fractional part of os.clock()

  local time_in_milliseconds = (seconds_part + fractional_seconds_part) * 1000
  return time_in_milliseconds
  --return os.time()
end

--- Log debug information if debugging is enabled.
---
--- Logs a given message when the SPECTRE.DebugEnabled flag is set to 1.
--- If additional data is provided, it's also logged.
---
--- @param message string The debug message to be logged.
--- @param data any|nil Optional data to be logged.
--- @usage AETHR.UTILS.debugInfo("Debug Message", {key="value"}) -- Logs the message and data if debugging is enabled.
function AETHR.UTILS:debugInfo(message, data)
  -- Guard against missing config or runtime env
  local enabled = false
  if type(self) == "table" and self.CONFIG and self.CONFIG.MAIN and self.CONFIG.MAIN.DEBUG_ENABLED then
    enabled = true
  end

  if not enabled then return end

  -- Safely call env.info if available
  if type(env) == "table" and type(env.info) == "function" then
    pcall(function() env.info(tostring(message)) end)
  end

  -- If structured data provided, attempt to log via BASE:E if available; fail silently otherwise
  if data and type(data) ~= "nil" then
    if type(BASE) == "table" and type(BASE.E) == "function" then
      pcall(function() BASE:E(data) end)
    end
  end
end

--- Return the vertical coordinate for a point-like table.
--- Accepts tables with either `.y` or `.z` fields (DCS uses z for map Y).
--- @param pt table|nil
--- @return number|nil y y-coordinate or nil if pt absent
function AETHR.UTILS:getPointY(pt)
  if not pt then return nil end
  return pt.y or pt.z
end

--- Normalize a point-like table into { x = number, y = number } form.
--- Does not modify the input table; returns a new table.
--- @param pt table|nil
--- @return table normalized point
function AETHR.UTILS:normalizePoint(pt)
  if not pt then return { x = 0, y = 0 } end
  return { x = pt.x or 0, y = (pt.y ~= nil) and pt.y or (pt.z or 0) }
end

--- Alias for legacy name table_hasValue -> hasValue
--- @param tbl table
--- @param val any
--- @return boolean
function AETHR.UTILS:hasValue(tbl, val)
  for index, value in pairs(tbl) do
    if value == val then
      return true
    end
  end
  return false
end

-- keep backward-compatible function name
function AETHR.UTILS:table_hasValue(tbl, val) return self:hasValue(tbl, val) end


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