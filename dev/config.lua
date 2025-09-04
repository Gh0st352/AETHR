--- @module AETHR.CONFIG
--- @brief Default configuration and storage settings for AETHR framework.
--- @author Gh0st352
--- @class AETHR.CONFIG
--- @field VERSION string Framework version identifier.
--- @field AUTHOR string Package author.
--- @field GITHUB string GitHub repository URL.
--- @field THEATER string Mission theater name (set at runtime).
--- @field DESCRIPTION table Array of description lines.
--- @field MISSION_ID string Default mission identifier.
--- @field MIZ_ZONES table Lists of trigger zone names by coalition or overall.
--- @field FLAGS table Runtime flags to toggle features.
--- @field COUNTERS table Numeric counters for marker IDs.
--- @field STORAGE table Directory and filename configuration for persistence.
--- @field worldDivisionArea number Target area in square meters for grid divisions.
--- @field worldBounds table Coordinate bounds for supported theaters.
--- @field Zone table Default rendering and arrow settings for zones.

AETHR.CONFIG = {
    VERSION = "0.1.0",                      -- Library version.
    AUTHOR = "Gh0st352",                    -- Package author.
    GITHUB = "https://github.com/Gh0st352", -- Repository URL.
    THEATER = "",                           -- Mission theater name, populated at runtime.
    DESCRIPTION = {                         -- Human-readable framework description.
        "Autonomous Environment for Theater Realism",
        "AETHR is a framework designed to enhance the realism and immersion of DCS World missions.",
        "It provides a set of tools and libraries to create dynamic and engaging scenarios.",
        "A high-fidelity simulation layer that weaves in adaptive machine learning decision-making across the whole theater.",
    },
    MISSION_ID = "1", -- Default mission identifier.
    MIZ_ZONES = {     -- Lists of mission trigger zone names.
        ALL = {},
        REDSTART = {},
        BLUESTART = {},
    },
    FLAGS = {                        -- Runtime feature flags.
        AETHR_FIRST_RUN     = true,  -- True on first mission run.
        AETHR_LEARNING_MODE = false, -- Enable learning mode.
        AETHR_DEBUG_MODE    = false, -- Enable debug mode.
    },
    COUNTERS = {                     -- Counters for generating unique IDs.
        MARKERS = 352352352,         -- Base ID for zone markers.
    },
    STORAGE = {                      -- Filesystem storage configuration.
        ROOT_FOLDER   = "AETHR",     -- Root directory under writable path.
        CONFIG_FOLDER = "CONFIG",    -- Subdirectory for config files.
        SUB_FOLDERS   = {            -- Additional subdirectories.
            LEARNING_FOLDER = "LEARNING",
            MAP_FOLDER      = "MAP",
            UNITS_FOLDER    = "UNITS",
            OBJECTS_FOLDER  = "OBJECTS",
            USER_FOLDER     = "USER",
        },
        PATHS         = { -- Populated at runtime with full paths.
            LEARNING_FOLDER = "",
            CONFIG_FOLDER   = "",
            MAP_FOLDER      = "",
            UNITS_FOLDER    = "",
            OBJECTS_FOLDER  = "",
            USER_FOLDER     = "",
        },
        FILENAMES     = { -- lua filenames for data persistence.
            AETHER_CONFIG_FILE   = "AETHR_Config.lua",
            WORLD_DIVISIONS_FILE = "worldDivisions.lua",
            USER_STORAGE_FILE    = "userStorage.lua",
            AIRBASES_FILE        = "airbases.lua",
            MIZ_ZONES_FILE       = "mizZones.lua",
            SAVE_DIVS_FILE       = "saveDivs.lua",
            OBJECTS_FILE         = "objects.lua",
        },
    },
    worldDivisionArea = 1862500000, -- Desired area (m²) per world division.
    worldBounds = {                 -- Coordinate bounds for supported theaters.
        Caucasus = {
            X = { min = -600000, max = 400000 },
            Z = { min = -570000, max = 1130000 },
        },
        NEVADA = { -- TODO: Update to real bounds.
            X = { min = 0, max = 0 },
            Z = { min = 0, max = 0 },
        },
        PersianGulf = {
            X = { min = -460000, max = 800000 },
            Z = { min = -900000, max = 800000 },
        },
        Syria = {
            X = { min = -380000, max = 291899 },
            Z = { min = -520000, max = 520000 },
        },
        MARIANAS_MODERN = {
            X = { min = -300000, max = 1000000 },
            Z = { min = -800000, max = 800000 },
        },
        MARIANAS_WWII = {
            X = { min = -300000, max = 1000000 },
            Z = { min = -1000000, max = 500000 },
        },
        Afghanistan = {
            X = { min = -1180000, max = 535000 },
            Z = { min = -534000, max = 760000 },
        },
        Iraq = {
            X = { min = -950000, max = 435000 },
            Z = { min = -500000, max = 850000 },
        },
        GermanyCW = {
            X = { min = -600000, max = 86000 },
            Z = { min = -1100000, max = -300000 },
        },
        SinaiMap = {
            X = { min = -500000, max = 490000 },
            Z = { min = -280000, max = 560000 },
        },
        Normandy = {
            X = { min = -130000, max = 255000 },
            Z = { min = -230000, max = 260000 },
        },
        Kola = {
            X = { min = -315000, max = 810000 },
            Z = { min = -900000, max = 860000 },
        },
    },
    Zone = { -- Default visualization settings for trigger zones.
        paintColors           = {
            LineColors  = {
                [0] = { 0, 0, 0 },
                [1] = { 1, 0, 0 },
                [2] = { 0, 0, 1 },
            },
            FillColors  = {
                [0] = { 0, 0, 0 },
                [1] = { 1, 0, 0 },
                [2] = { 0, 0, 1 },
            },
            ArrowColors = {
                [0] = { 0, 0, 0, 0.80 },
                [1] = { 1, 0, 0, 0.80 },
                [2] = { 0, 0, 1, 0.80 },
            },
            FillAlpha   = 0.20,        -- Transparency for filled zones.
            LineAlpha   = 0.80,        -- Transparency for zone borders.
            lineType    = 4,           -- Default line style.
        },
        BorderOffsetThreshold = 800,   -- Distance threshold for bordering detection.
        ArrowLength           = 20000, -- Length of directional arrows.
    },
}

-- --- @function AETHR:loadExistingData
-- --- @brief Loads configuration from JSON or writes defaults if none exist.
-- --- @return AETHR self Framework instance for chaining.
-- function AETHR:loadExistingData()
--     -- Load or create the AETHR configuration file.
--     self:loadConfig()
--     return self
-- end

--- @function AETHR:initConfig
--- @brief Reads config JSON and merges into `AETHR.CONFIG`; writes default if absent.
--- @return AETHR self Framework instance for chaining.
function AETHR:initConfig()
    -- Attempt to read existing config from file.
    local configData = self:loadConfig()
    if configData then
            self.CONFIG = configData
    else
        -- Persist defaults to disk.
        self:saveConfig()
    end
    return self
end

--- @function AETHR:loadConfig
--- @brief
--- @return
function AETHR:loadConfig()
    -- Attempt to read existing config from JSON file.
    local configData = self.fileOps.loadData(
        self.CONFIG.STORAGE.PATHS.CONFIG_FOLDER,
        self.CONFIG.STORAGE.FILENAMES.AETHER_CONFIG_FILE
    )
    if configData then
        return configData
    end
    return nil
end

--- @function AETHR:saveConfig
--- @brief
--- @return
function AETHR:saveConfig()
    -- Attempt to read existing config from JSON file.
    self.fileOps.saveData(
        self.CONFIG.STORAGE.PATHS.CONFIG_FOLDER,
        self.CONFIG.STORAGE.FILENAMES.AETHER_CONFIG_FILE,
        self.CONFIG
    )
end

