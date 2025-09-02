--- @module AETHR
--- @brief Core AETHR framework for DCS World mission management.
--- @author Gh0st352
---@diagnostic disable: undefined-global

--- @class AETHR
--- @field USERSTORAGE table Container for per-user saved data.
--- @field LEARNED_DATA table Holds learned data: worldDivisions, saveDivisions, divisionObjects.
--- @field AIRBASES table Collected airbase information.
--- @field MIZ_ZONES table Loaded mission trigger zones.
AETHR = {
    USERSTORAGE    = {},     -- Holds per-user saved data tables.
    LEARNED_DATA   = {       -- Stores learned datasets for world and divisions.
        worldDivisions    = {}, -- Grid division definitions keyed by ID.
        saveDivisions     = {}, -- Active divisions keyed by ID.
        divisionObjects   = {}, -- Loaded objects per division.
    },
    AIRBASES       = {},     -- Airbase descriptors keyed by displayName.
    MIZ_ZONES      = {},     -- Mission trigger zones keyed by zone name.
}

--- Creates a new AETHR instance with optional mission ID override.
--- @function AETHR:New
--- @param mission_id string|nil Optional mission identifier (defaults to configured ID).
--- @return AETHR instance New instance inheriting AETHR methods.
function AETHR:New(mission_id)
    -- choose or default mission ID
    local id = mission_id or self.CONFIG.MISSION_ID

    -- shallow‐clone prototype to avoid mutating shared tables
    ---@type AETHR
    local instance = {}
    for k, v in pairs(self) do
        instance[k] = v
    end
    setmetatable(instance, { __index = self })

    -- assign instance‐specific fields
    instance.CONFIG.MISSION_ID = id

    -- ensure STORAGE.PATHS is a clone so it's safe to modify per instance
    local basePaths = self.CONFIG.STORAGE.PATHS or {}
    instance.CONFIG.STORAGE.PATHS = {}
    for name, path in pairs(basePaths) do
        instance.CONFIG.STORAGE.PATHS[name] = path
    end

    -- compute the config folder path under DCS writable directory
    local lfs     = require("lfs")
    local rt_path = lfs.writedir()
    instance.CONFIG.STORAGE.PATHS.CONFIG_FOLDER = AETHR.fileOps.joinPaths(
        rt_path,
        instance.CONFIG.STORAGE.ROOT_FOLDER,
        instance.CONFIG.STORAGE.CONFIG_FOLDER
    )

    -- capture the current theater for this instance
    instance.CONFIG.THEATER = env.mission.theatre

    return instance
end

--- Initializes AETHR by preparing directories and loading or saving mission data.
--- @function AETHR:Init
--- @return AETHR self Initialized framework instance.
function AETHR:Init()
    local lfs     = require("lfs")           -- LuaFileSystem for directory checks.
    local rt_path = lfs.writedir()           -- Base writable path.

    -- Ensure storage subdirectories exist and cache their full paths.
    for folderName, folderPath in pairs(self.CONFIG.STORAGE.SUB_FOLDERS) do
        local fullPath = AETHR.fileOps.joinPaths(
            rt_path,
            self.CONFIG.STORAGE.ROOT_FOLDER,
            self.CONFIG.MISSION_ID,
            folderPath
        )
        self.CONFIG.STORAGE.PATHS[folderName] = fullPath -- Cache path.
        self.fileOps.ensureDirectory(fullPath)           -- Create directory if missing.
    end

    -- Load or generate core configuration and data structures.
    self:loadExistingData()     -- Load config JSON or write defaults.
    self:loadWorldDivisions()   -- Generate or load world division grid.
    self:loadUSERSTORAGE()      -- Load per-user storage data.
    self:SaveUSERSTORAGE()      -- Persist current user storage data.

    -- Prepare map and trigger zone datasets.
    self:loadAirbases()         -- Load or generate airbases information.
    self:getMizZoneData()       -- Load or generate mission trigger zones.

    -- Persist the final configuration back to JSON.
    self:SaveConfig()

    -- Return self for chaining.
    return self
end
