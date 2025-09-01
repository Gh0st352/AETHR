--- @module AETHR.CONFIG
--- @brief Default configuration and storage settings for AETHR framework.
--- @class AETHR.CONFIG
AETHR.CONFIG = {
    VERSION = "0.1.0",
    AUTHOR = "Gh0st352",
    GITHUB = "https://github.com/Gh0st352",
    THEATER = "",
    DESCRIPTION = {
        "Autonomous Environment for Theater Realism",
        "AETHR is a framework designed to enhance the realism and immersion of DCS World missions.",
        "It provides a set of tools and libraries to create dynamic and engaging scenarios.",
        "A high-fidelity simulation layer that weaves in adaptive machine learning decision-making across the whole theater.",
    },
    MISSION_ID = "1",
    MIZ_ZONES = {
        ALL = {},
        REDSTART = {},
        BLUESTART = {},
    },
    FLAGS = {
        AETHR_FIRST_RUN = true,      -- Flag to check if this is the first run of the mission
        AETHR_LEARNING_MODE = false, -- Flag to enable learning mode
        AETHR_DEBUG_MODE = false,    -- Flag to enable debug mode
    },
    COUNTERS = {
        MARKERS = 352352352, -- Counter for markers
    },
    STORAGE = {
        ROOT_FOLDER = "AETHR",
        CONFIG_FOLDER = "CONFIG",
        SUB_FOLDERS = {
            LEARNING_FOLDER = "LEARNING",
            MAP_FOLDER = "MAP",
            UNITS_FOLDER = "UNITS",
            OBJECTS_FOLDER = "OBJECTS",
            USER_FOLDER = "USER",
        },
        PATHS = {
            LEARNING_FOLDER = "",
            CONFIG_FOLDER = "",
            MAP_FOLDER = "",
            UNITS_FOLDER = "",
            OBJECTS_FOLDER = "",
            USER_FOLDER = "",
        },
        FILENAMES = {
            AETHER_CONFIG_FILE = "AETHR_Config.json",
            WORLD_DIVISIONS_FILE = "worldDivisions.json",
            USER_STORAGE_FILE = "userStorage.json",
            AIRBASES_FILE = "airbases.json",
            MIZ_ZONES_FILE = "mizZones.json",
            SAVE_DIVS_FILE = "saveDivs.json",
            OBJECTS_FILE = "objects.json",
        },
    },
    worldDivisionArea = 1862500000, -- Area of each division in square meters, 1862500000 is approximately a 43km x 43km square
    worldBounds = {
        Caucasus = {
            X = { min = -600000, max = 400000 },
            Z = { min = -570000, max = 1130000 },
        },
        NEVADA = { --TODO: Update to real bounds
            X = { min = -0, max = 0 },
            Z = { min = -0, max = 0 },
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
    Zone = {
        paintColors = {
            LineColors = {
                [0] = { 0, 0, 0 },
                [1] = { 1, 0, 0 },
                [2] = { 0, 0, 1 }
            },
            FillColors = {
                [0] = { 0, 0, 0 },
                [1] = { 1, 0, 0 },
                [2] = { 0, 0, 1 }
            },
            ArrowColors = {
                [0] = { 0, 0, 0, 0.80 },
                [1] = { 1, 0, 0, 0.80 },
                [2] = { 0, 0, 1, 0.80 }
            },
            FillAlpha = 0.20,
            LineAlpha = 0.80,
            lineType = 4, -- Default line type for zones
        },
        BorderOffsetThreshold = 800,
        ArrowLength = 20000,
    },
}


--- Loads existing configuration from JSON or creates a default config file.
--- @return AETHR self
function AETHR:loadExistingData()
    self:loadConfig()
    return self
end

--- Loads configuration values from JSON file and merges into defaults.
--- If no file exists, writes default configuration to disk.
--- @return AETHR self
function AETHR:loadConfig()
    local configData = self.fileOps.loadTableFromJSON(
        self.CONFIG.STORAGE.PATHS.CONFIG_FOLDER,
        self.CONFIG.STORAGE.FILENAMES.AETHER_CONFIG_FILE
    )
    if configData then
        for k, v in pairs(configData) do
            self.CONFIG[k] = v
        end
    else
        -- If no config file exists, create a new one with default values
        self.fileOps.saveTableAsPrettyJSON(
            self.CONFIG.STORAGE.PATHS.CONFIG_FOLDER,
            self.CONFIG.STORAGE.FILENAMES.AETHER_CONFIG_FILE,
            self.CONFIG
        )
    end
    return self
end

--- Saves current configuration table to JSON file.
--- @return AETHR self
function AETHR:SaveConfig()
    self.fileOps.saveTableAsPrettyJSON(
        self.CONFIG.STORAGE.PATHS.CONFIG_FOLDER,
        self.CONFIG.STORAGE.FILENAMES.AETHER_CONFIG_FILE,
        self.CONFIG
    )
    return self
end

--- Loads user-specific storage data from JSON if available.
--- @return AETHR self
function AETHR:loadUSERSTORAGE()
    local userData = self.fileOps.loadTableFromJSON(
        self.CONFIG.STORAGE.PATHS.USER_FOLDER,
        self.CONFIG.STORAGE.FILENAMES.USER_STORAGE_FILE
    )
    if userData then
        self.USERSTORAGE = userData
    end
    return self
end

--- Saves current user storage table to JSON file.
--- @return AETHR self
function AETHR:SaveUSERSTORAGE()
    self.fileOps.saveTableAsPrettyJSON(
        self.CONFIG.STORAGE.PATHS.USER_FOLDER,
        self.CONFIG.STORAGE.FILENAMES.USER_STORAGE_FILE,
        self.USERSTORAGE
    )
    return self
end
