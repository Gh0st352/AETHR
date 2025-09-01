--- @module AETHR
--- @brief Core AETHR framework for DCS World mission management.

--- @class AETHR
--- @field USERSTORAGE table Container for per-user saved data
--- @field LEARNED_DATA table Holds learned information (worldDivisions, saveDivisions, divisionObjects)
--- @field AIRBASES table Collected airbase information
--- @field MIZ_ZONES table Loaded mission trigger zones
AETHR = {
    USERSTORAGE    = {},
    LEARNED_DATA   = {
        worldDivisions    = {},
        saveDivisions     = {},
        divisionObjects   = {},
    },
    AIRBASES       = {},
    MIZ_ZONES      = {},
}

--- Creates a new AETHR instance with optional mission ID override.
--- @param MISSION_ID string|nil Optional mission identifier (defaults to configured ID)
--- @return AETHR New instance inheriting AETHR methods
function AETHR:New(MISSION_ID)
    -- Use provided mission ID or fallback to default
    MISSION_ID = MISSION_ID or self.MISSION_ID

    -- Create instance table and set inheritance
    local instance = {}
    setmetatable(instance, { __index = self })

    -- Determine and store config folder path
    local lfs     = require("lfs")           -- LuaFileSystem for IO paths
    local rt_path = lfs.writedir()           -- DCS root writable directory
    self.CONFIG.STORAGE.PATHS.CONFIG_FOLDER = AETHR.fileOps.joinPaths(
        rt_path,
        self.CONFIG.STORAGE.ROOT_FOLDER,
        self.CONFIG.STORAGE.CONFIG_FOLDER
    )

    -- Capture current theater name from mission environment
    self.CONFIG.THEATER = env.mission.theatre

    return instance
end

--- Initializes AETHR by setting up directories and loading/saving mission data.
--- @return AETHR self
function AETHR:Init()
    local lfs     = require("lfs")
    local rt_path = lfs.writedir()  -- Base writable path

    -- Create required subdirectories based on configuration
    for folderName, folderPath in pairs(self.CONFIG.STORAGE.SUB_FOLDERS) do
        local fullPath = AETHR.fileOps.joinPaths(
            rt_path,
            self.CONFIG.STORAGE.ROOT_FOLDER,
            self.CONFIG.MISSION_ID,
            folderPath
        )
        -- Cache computed paths and ensure they exist on disk
        self.CONFIG.STORAGE.PATHS[folderName] = fullPath
        self.fileOps.ensureDirectory(fullPath)
    end

    -- Load or generate core data
    self:loadExistingData()     -- Loads config JSON or creates defaults
    self:loadWorldDivisions()   -- Loads or creates the world division grid
    self:loadUSERSTORAGE()      -- Loads per-user storage JSON
    self:SaveUSERSTORAGE()      -- Saves current user storage state

    -- Map and zone data
    self:loadAirbases()         -- Loads or generates airbase information
    self:getMizZoneData()       -- Loads or generates mission trigger zones

    -- Persist final configuration
    self:SaveConfig()

    return self
end
