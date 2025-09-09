--- @class AETHR.AUTOSAVE
--- @brief Manages mission trigger zones and computes bordering relationships.
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @class AETHR.AUTOSAVE
--- @brief Autosave and persistence helpers for mission runtime.
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
AETHR.AUTOSAVE = {}

--- Create a new AUTOSAVE submodule instance.
--- @function AETHR.AUTOSAVE:New
--- @param parent AETHR Parent AETHR instance
--- @return AETHR.AUTOSAVE instance
function AETHR.AUTOSAVE:New(parent)
    local instance = {
        AETHR = parent,
        _cache = {},
    }
    setmetatable(instance, { __index = self })
    return instance
end
