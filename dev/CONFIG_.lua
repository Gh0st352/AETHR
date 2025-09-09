--- @class AETHR.CONFIG
--- @brief
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
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
--- @field MAIN table General Config Data Table.
AETHR.CONFIG = {}
AETHR.CONFIG.MAIN = {
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
    DEBUG_ENABLED = true, -- Enable debug logging to DCS log.
    MIZ_ZONES = {     -- Lists of mission trigger zone names.
        ALL = {},
        REDSTART = {},
        BLUESTART = {},
    },
    FLAGS = {                        -- Runtime feature flags.
        AETHR_FIRST_RUN     = true,  -- True on first mission run.
        AETHR_LEARNING_MODE = false, -- Enable learning mode.
        AETHR_DEBUG_MODE    = false, -- Enable debug mode.
        LEARN_WORLD_OBJECTS    = false,  -- Enable world item learning.
    },
    COUNTERS = {                     -- Counters for generating unique IDs.
        MARKERS = 3523523,           -- Base ID for zone markers.
    },
    STORAGE = {                      -- Filesystem storage configuration.
        SAVEGAME_DIR  = "",          -- Absolute path to the DCS savegame writable directory root.
        ROOT_FOLDER   = "AETHR",     -- Root AETHR directory under writable path.
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
            SCENERY_OBJECTS_FILE = "sceneryObjects.lua",
            STATIC_OBJECTS_FILE  = "staticObjects.lua",
            BASE_OBJECTS_FILE    = "baseObjects.lua",
            GAME_BOUNDS_FILE     = "gameBounds.lua",
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
                [0] = {r = 0, g = 0, b = 0 },
                [1] = {r = 1, g = 0, b = 0 },
                [2] = {r = 0, g = 0, b = 1 },
            },
            FillColors  = {
                [0] = {r = 0, g = 0, b = 0 },
                [1] = {r = 1, g = 0, b = 0 },
                [2] = {r = 0, g = 0, b = 1 },
            },
            ArrowColors = {
                [0] = {r = 0, g = 0, b = 0, a = 0.8 },
                [1] = {r = 1, g = 0, b = 0, a = 0.8 },
                [2] = {r = 0, g = 0, b = 1, a = 0.8 },
            },
            FillAlpha   = 0.1, -- Transparency for filled zones.
            LineAlpha   = 0.6, -- Transparency for zone borders.
            lineType    = AETHR.ENUMS.LineTypes.DashDot,    -- Default line style.
        },
        gameBounds            = {
            LineColors  = {r = 0.1, g = 0.1, b = 0.1 },
            FillColors  = {r = 0.1, g = 0.1, b = 0.1 },
            FillAlpha   = 0.30,        -- Transparency for filled zones.
            LineAlpha   = 0.30,        -- Transparency for zone borders.
            lineType    = AETHR.ENUMS.LineTypes.NoLine,           -- Default line style.
            getOutOfBounds = {
                samplesPerEdge      = 20,   -- Number of samples to generate per edge of the world bounds.
                useHoleSinglePolygon = false, -- If true, generates a single polygon with a hole for the in-bounds area. Otherwise, generates multiple convex polygons.
                snapDistance        = 0, -- Distance (meters) under which densified samples will be snapped to the nearest original polygon segment to enforce colinearity.
            },
        },
        BorderOffsetThreshold = 800,   -- Distance threshold for bordering detection.
        ArrowLength           = 20000, -- Length of directional arrows.
    },
}

function AETHR.CONFIG:New(parent)
    local instance = {
        AETHR = parent,
        -- submodule-local caches/state can be initialized here
        _cache = {},
    }
    setmetatable(instance, { __index = self })
    return instance
end

--- @function AETHR:initConfig
--- @brief Reads config JSON and merges into `AETHR.CONFIG`; writes default if absent.
--- @return AETHR.CONFIG self Framework instance for chaining.
function AETHR.CONFIG:initConfig()
    -- Attempt to read existing config from storage; merge if present, otherwise persist defaults.
    local ok, configData = pcall(function() return self:loadConfig() end)
    if ok and type(configData) == "table" then
        -- Replace instance MAIN with loaded config (trusted source)
        self.MAIN = configData
    else
        -- Persist current defaults to disk (best-effort)
        pcall(function() self:saveConfig() end)
    end
    return self
end

function AETHR.CONFIG:loadConfig()
    -- Defensive guards
    if not (self and self.MAIN and self.MAIN.STORAGE and self.MAIN.STORAGE.PATHS) then
        return nil
    end

    local mapPath = self.MAIN.STORAGE.PATHS.CONFIG_FOLDER
    local filename = self.MAIN.STORAGE.FILENAMES and self.MAIN.STORAGE.FILENAMES.AETHER_CONFIG_FILE

    if not mapPath or not filename then return nil end

    local ok, data = pcall(function()
        return self.FILEOPS:loadData(mapPath, filename)
    end)

    if ok and type(data) == "table" then
        return data
    end
    return nil
end

function AETHR.CONFIG:saveConfig()
    -- Defensive guards
    if not (self and self.MAIN and self.MAIN.STORAGE and self.MAIN.STORAGE.PATHS) then
        return false
    end

    local mapPath = self.MAIN.STORAGE.PATHS.CONFIG_FOLDER
    local filename = self.MAIN.STORAGE.FILENAMES and self.MAIN.STORAGE.FILENAMES.AETHER_CONFIG_FILE
    if not mapPath or not filename then return false end

    local ok, err = pcall(function()
        self.FILEOPS:saveData(mapPath, filename, self.MAIN)
    end)
    if not ok then
        if type(self.AETHR) == "table" and self.AETHR.UTILS and type(self.AETHR.UTILS.debugInfo) == "function" then
            pcall(function() self.AETHR.UTILS:debugInfo("Failed saving config: " .. tostring(err)) end)
        end
        return false
    end
    return true
end
