--- @class AETHR.CONFIG
--- @brief Configuration submodule for the AETHR framework. Contains default runtime
--- values, storage paths, visual preferences and helpers for persisting/merging config.
---@diagnostic disable: undefined-global
--- Existing injected submodules (attached by AETHR:New)
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field MARKERS AETHR.MARKERS Markers submodule attached per-instance.
--- @field MATH AETHR.MATH Math helper table attached per-instance.
--- Additional top-level convenience fields (documented in MAIN below)
AETHR.CONFIG = {} ---@diagnostic disable-line

--- @class AETH.CONFIG.MAIN AETHR.CONFIG.MAIN General Config Data Table (defaults)
--- @field VERSION string Framework version identifier.
--- @field AUTHOR string Package author.
--- @field GITHUB string GitHub repository URL.
--- @field THEATER string Mission theater name (set at runtime).
--- @field DESCRIPTION string[] Array of description lines.
--- @field MISSION_ID string Default mission identifier.
--- @field MIZ_ZONES AETHR.CONFIG.MizZones Lists of trigger zone names by coalition or overall.
--- @field FLAGS AETHR.CONFIG.Flags Runtime flags to toggle features.
--- @field COUNTERS AETHR.CONFIG.Counters Numeric counters for marker IDs.
--- @field STORAGE AETHR.CONFIG.Storage Directory and filename configuration for persistence.
--- @field worldDivisionArea number Target area in square meters for grid divisions.
--- @field worldBounds table Coordinate bounds for supported theaters.
--- @field Zone table Default rendering and arrow settings for zones.
--- @field _cache table Instance-local cache (initialized in :New)

--- @class AETHR.CONFIG.Color
--- @field r number Red channel (0..1)
--- @field g number Green channel (0..1)
--- @field b number Blue channel (0..1)
--- @field a number|nil Alpha channel (0..1), optional

--- @class AETHR.CONFIG.SubFolders
--- @field LEARNING_FOLDER string
--- @field MAP_FOLDER string
--- @field UNITS_FOLDER string
--- @field OBJECTS_FOLDER string
--- @field USER_FOLDER string

--- @class AETHR.CONFIG.Paths
--- @field LEARNING_FOLDER string Full path (populated at runtime)
--- @field CONFIG_FOLDER string Full path (populated at runtime)
--- @field MAP_FOLDER string Full path (populated at runtime)
--- @field UNITS_FOLDER string Full path (populated at runtime)
--- @field OBJECTS_FOLDER string Full path (populated at runtime)
--- @field USER_FOLDER string Full path (populated at runtime)

--- @class AETHR.CONFIG.Filenames
--- @field AETHER_CONFIG_FILE string Filename for main config persistence
--- @field WORLD_DIVISIONS_FILE string
--- @field USER_STORAGE_FILE string
--- @field AIRBASES_FILE string
--- @field MIZ_ZONES_FILE string
--- @field SAVE_DIVS_FILE string
--- @field OBJECTS_FILE string
--- @field SCENERY_OBJECTS_FILE string
--- @field STATIC_OBJECTS_FILE string
--- @field BASE_OBJECTS_FILE string
--- @field GAME_BOUNDS_FILE string
--- @field MIZ_CACHE_DB string
--- @field SPAWNER_TEMPLATE_DB string
--- @field SPAWNER_ATTRIBUTE_DB string
--- @field SPAWNER_UNIT_CACHE_DB string

--- @class AETHR.CONFIG.Storage
--- @field SAVEGAME_DIR string Absolute path to the DCS savegame writable directory root.
--- @field ROOT_FOLDER string Root AETHR directory under writable path.
--- @field CONFIG_FOLDER string Subdirectory for config files.
--- @field SUB_FOLDERS AETHR.CONFIG.SubFolders Named subfolders (constants).
--- @field PATHS AETHR.CONFIG.Paths Runtime-populated full paths.
--- @field FILENAMES AETHR.CONFIG.Filenames Lua filenames used for persistence.

--- @class AETHR.CONFIG.AxisRange
--- @field min number Minimum coordinate
--- @field max number Maximum coordinate

--- @class AETHR.CONFIG.BoundsCoord
--- @field X AETHR.CONFIG.AxisRange
--- @field Z AETHR.CONFIG.AxisRange

--- @class AETHR.CONFIG.MizZones
--- @field ALL string[] List of all trigger zone names (strings)
--- @field REDSTART string[] Red coalition start zones
--- @field BLUESTART string[] Blue coalition start zones

--- @class AETHR.CONFIG.Flags
--- @field AETHR_FIRST_RUN boolean True on first mission run.
--- @field AETHR_LEARNING_MODE boolean Enable learning mode.
--- @field AETHR_DEBUG_MODE boolean Enable debug mode.
--- @field LEARN_WORLD_OBJECTS boolean Enable world item learning.

--- @class AETHR.CONFIG.Counters
--- @field MARKERS number Base ID for zone markers.
--- @field UNITS number Base ID for dynamically spawned units.
--- @field GROUPS number Base ID for dynamically spawned groups.
--- @field OBJECTS number Base ID for dynamically spawned objects.
--- @field SCENERY_OBJECTS number Base ID for dynamically spawned scenery objects.
--- @field STATIC_OBJECTS number Base ID for dynamically spawned static objects.
--- @field DYNAMIC_SPAWNERS number Base ID for dynamic spawners.

--- @class AETHR.CONFIG.PaintColors
--- @field LineColors table<number, AETHR.CONFIG.Color> Indexed mapping for line color sets
--- @field FillColors table<number, AETHR.CONFIG.Color> Indexed mapping for fill color sets
--- @field ArrowColors table<number, AETHR.CONFIG.Color> Indexed mapping for arrow colors (may include alpha)
--- @field CircleColors table<number, AETHR.CONFIG.Color> Indexed mapping for circle colors (may include alpha)
--- @field FillAlpha number Default fill transparency (0..1)
--- @field LineAlpha number Default line transparency (0..1)
--- @field lineType number Enum value from AETHR.ENUMS.LineTypes

--- @class AETHR.CONFIG.GameBoundsSettings
--- @field LineColors AETHR.CONFIG.Color
--- @field FillColors AETHR.CONFIG.Color
--- @field FillAlpha number
--- @field LineAlpha number
--- @field lineType number Enum for line style
--- @field getOutOfBounds table Settings used to generate out-of-bounds polygons

--- @class AETHR.CONFIG.ZoneSettings
--- @field paintColors AETHR.CONFIG.PaintColors Default paint settings for zones
--- @field gameBounds AETHR.CONFIG.GameBoundsSettings Settings when rendering world bounds
--- @field BorderOffsetThreshold number Distance threshold for bordering detection (meters)
--- @field ArrowLength number Default arrow length (meters)

--- @class AETHR.CONFIG.OutTextSection
--- @field displayTime number Seconds to display the message.
--- @field clearView boolean Whether to clear previous messages before showing new one.

--- @class AETHR.CONFIG.OutTextSettings
--- @field airbaseOwnershipChange AETHR.CONFIG.OutTextSection
--- @field zoneOwnershipChange AETHR.CONFIG.OutTextSection

--- @class AETHR.CONFIG.MAIN
--- @field VERSION string
--- @field AUTHOR string
--- @field GITHUB string
--- @field THEATER string
--- @field DESCRIPTION string[]
--- @field MISSION_ID string
--- @field DEBUG_ENABLED boolean
--- @field DefaultRedCountry number country.id constant for red (default mapping)
--- @field DefaultBlueCountry number country.id constant for blue (default mapping)
--- @field spawnTemplateSearchString string Search token for spawner templates.
--- @field MIZ_ZONES AETHR.CONFIG.MizZones
--- @field FLAGS AETHR.CONFIG.Flags
--- @field COUNTERS AETHR.CONFIG.Counters
--- @field STORAGE AETHR.CONFIG.Storage
--- @field worldDivisionArea number Desired area (m²) per world division.
--- @field worldBounds table<string, AETHR.CONFIG.BoundsCoord>
--- @field Zone AETHR.CONFIG.ZoneSettings
--- @field outTextSettings AETHR.CONFIG.OutTextSettings


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
    MISSION_ID = "1",     -- Default mission identifier.
    DEBUG_ENABLED = true, -- Enable debug logging to DCS log.
    DefaultRedCountry = country.id.CJTF_BLUE,
    DefaultBlueCountry = country.id.CJTF_RED,
    spawnTemplateSearchString = "SPECTRESPAWNERTemplate",
    MIZ_ZONES = { -- Lists of mission trigger zone names.
        ALL = {},
        REDSTART = {},
        BLUESTART = {},
    },
    FLAGS = {                        -- Runtime feature flags.
        AETHR_FIRST_RUN     = true,  -- True on first mission run.
        AETHR_LEARNING_MODE = false, -- Enable learning mode.
        AETHR_DEBUG_MODE    = false, -- Enable debug mode.
        LEARN_WORLD_OBJECTS = false, -- Enable world item learning.
    },
    COUNTERS = {                     -- Counters for generating unique IDs.
        MARKERS = 3523523,           -- Base ID for zone markers.
        UNITS = 1,                   -- Base ID for dynamically spawned units.
        GROUPS = 1,                  -- Base ID for dynamically spawned groups.
        OBJECTS = 1,                 -- Base ID for dynamically spawned objects.
        SCENERY_OBJECTS = 1,         -- Base ID for dynamically spawned scenery objects.
        STATIC_OBJECTS = 1,          -- Base ID for dynamically spawned static objects
        DYNAMIC_SPAWNERS = 1,        -- Base ID for dynamic spawners.
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
            AETHER_CONFIG_FILE    = "AETHR_Config.lua",
            WORLD_DIVISIONS_FILE  = "worldDivisions.lua",
            USER_STORAGE_FILE     = "userStorage.lua",
            AIRBASES_FILE         = "airbases.lua",
            MIZ_ZONES_FILE        = "mizZones.lua",
            SAVE_DIVS_FILE        = "saveDivs.lua",
            OBJECTS_FILE          = "objects.lua",
            SCENERY_OBJECTS_FILE  = "sceneryObjects.lua",
            STATIC_OBJECTS_FILE   = "staticObjects.lua",
            BASE_OBJECTS_FILE     = "baseObjects.lua",
            GAME_BOUNDS_FILE      = "gameBounds.lua",
            MIZ_CACHE_DB          = "mizCacheDB.lua",
            SPAWNER_TEMPLATE_DB   = "spawnerTemplateDB.lua",
            SPAWNER_ATTRIBUTE_DB  = "spawnerAttributesDB.lua",
            SPAWNER_UNIT_CACHE_DB = "spawnerUnitInfoCache.lua",
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
            LineColors   = {
                [0] = { r = 0, g = 0, b = 0 },
                [1] = { r = 1, g = 0, b = 0 },
                [2] = { r = 0, g = 0, b = 1 },
            },
            FillColors   = {
                [0] = { r = 0, g = 0, b = 0 },
                [1] = { r = 1, g = 0, b = 0 },
                [2] = { r = 0, g = 0, b = 1 },
            },
            ArrowColors  = {
                [0] = { r = 0, g = 0, b = 0, a = 0.5 },
                [1] = { r = 1, g = 0, b = 0, a = 0.5 },
                [2] = { r = 0, g = 0, b = 1, a = 0.5 },
            },
            CircleColors = {
                [0] = { r = 0.941, g = 0.941, b = 0.941, a = 0.15 },
                [1] = { r = 0.941, g = 0.941, b = 0.941, a = 0.15 },
                [2] = { r = 0.941, g = 0.941, b = 0.941, a = 0.15 },
            },
            FillAlpha    = 0.20,                         -- Transparency for filled zones.
            LineAlpha    = 0.5,                          -- Transparency for zone borders.
            lineType     = AETHR.ENUMS.LineTypes.DashDot, -- Default line style.
        },
        gameBounds            = {
            LineColors     = { r = 0.1, g = 0.1, b = 0.1 },
            FillColors     = { r = 0.1, g = 0.1, b = 0.1 },
            FillAlpha      = 0.4,                          -- Transparency for filled zones.
            LineAlpha      = 0.30,                         -- Transparency for zone borders.
            lineType       = AETHR.ENUMS.LineTypes.NoLine, -- Default line style.
            getOutOfBounds = {
                samplesPerEdge       = 20,                 -- Number of samples to generate per edge of the world bounds.
                useHoleSinglePolygon = false,              -- If true, generates a single polygon with a hole for the in-bounds area. Otherwise, generates multiple convex polygons.
                snapDistance         = 0,                  -- Distance (meters) under which densified samples will be snapped to the nearest original polygon segment to enforce colinearity.
            },
        },
        BorderOffsetThreshold = 800,  -- Distance threshold for bordering detection.
        ArrowLength           = 15000 --20000, -- Length of directional arrows.
    },
    outTextSettings = {
        airbaseOwnershipChange = {
            displayTime = 10,    -- Seconds to display the message.
            clearView   = false, -- Clear previous messages before displaying new one.
        },
        zoneOwnershipChange = {
            displayTime = 10,    -- Seconds to display the message.
            clearView   = false, -- Clear previous messages before displaying new one.
        },
    },
}
--- Create a new instance of the CONFIG submodule for a specific AETHR parent instance.
--- @param parent AETHR Parent AETHR instance (used to access injected helpers like FILEOPS)
--- @return AETHR.CONFIG instance New instance bound to `parent`
function AETHR.CONFIG:New(parent)
    local instance = {
        AETHR = parent,
        -- submodule-local caches/state can be initialized here
        _cache = {},
    }
    setmetatable(instance, { __index = self })
    return instance
end

--- Initialize configuration for this instance.
--- Reads persisted config from storage (if available) and replaces the in-memory defaults.
--- If no persisted config is found, persists the current defaults to disk as a best-effort fallback.
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

--- Load persisted config from disk using FILEOPS helper.
--- Defensive guards ensure required STORAGE PATHS and FILENAMES exist before attempting load.
--- @return table|nil configData The loaded config table, or nil if not present/failed.
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

--- Persist current MAIN configuration to disk via FILEOPS.
--- Performs defensive checks and logs debug information via AETHR.UTILS on failure (best-effort).
--- @return boolean True on success, false on failure.
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
