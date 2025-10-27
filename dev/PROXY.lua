--- @class AETHR.PROXY
--- @brief Manages proximity detection and object lookups via division mapping for handling and changing game states based on unit locations.
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field UTILS AETHR.UTILS Utility functions submodule attached per-instance.
--- @field BRAIN AETHR.BRAIN
--- @field AI AETHR.AI
--- @field ENUMS AETHR.ENUMS Enumeration constants submodule attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field MATH AETHR.MATH Math helper table attached per-instance.
--- @field MARKERS AETHR.MARKERS
--- @field SPAWNER AETHR.SPAWNER Spawner submodule attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field DATA AETHR.PROXY.Data Container for zone management data.
--- @field divisionBaseObjects table<number, table<number, _FoundObject>>
AETHR.PROXY = {} ---@diagnostic disable-line


---@class AETHR.PROXY.Data
AETHR.PROXY.DATA = {}