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


function AETHR.UTILS:New(parent)
    local instance = {
        AETHR = parent,
        -- submodule-local caches/state can be initialized here
        _cache = {},
    }
    setmetatable(instance, { __index = self })
    return instance
end


function AETHR.UTILS:table_hasValue(tbl, val)
  for index, value in pairs(tbl) do
    if value == val then
      return true
    end
  end
  return false
end

function AETHR.UTILS.sumTable(t)
  local sum = 0
  for k, v in pairs(t) do
    sum = sum + 1
  end
  return sum
end

function AETHR.UTILS.getTime()
  return os.time()
end