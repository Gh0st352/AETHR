AETHR = {
    LEARNED_DATA = {
        worldDivisions = {},
    },
    CONFIG = {
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
        STORAGE = {
            ROOT_FOLDER = "AETHR",
            CONFIG_FOLDER = "CONFIG",
            SUB_FOLDERS = {
                LEARNING_FOLDER = "LEARNING",
                TERRAIN_FOLDER = "TERRAIN",
                UNITS_FOLDER = "UNITS",
                OBJECTS_FOLDER = "OBJECTS",
                USER_FOLDER = "USER",
            },
            PATHS = {
                LEARNING_FOLDER = "",
                CONFIG_FOLDER = "",
                TERRAIN_FOLDER = "",
                UNITS_FOLDER = "",
                OBJECTS_FOLDER = "",
                USER_FOLDER = "",
            },
            FILENAMES = {
                AETHER_CONFIG_FILE = "AETHR_Config.json",
                WORLD_DIVISIONS_FILE = "worldDivisions.json"
            },
        },
        worldBounds = {
            AREA = 10000000000,     -- Area of each division in square meters
            TOLERANCE = 2560000, -- Tolerance for area division in square meters
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
    },
}

function AETHR:New(MISSION_ID)
    MISSION_ID = MISSION_ID or self.MISSION_ID
    local instance = {}
    setmetatable(instance, { __index = self })
    local lfs = require("lfs")
    local rt_path = lfs.writedir()
    local fullPath = rt_path .. instance.CONFIG.STORAGE.ROOT_FOLDER .. "/" .. instance.CONFIG.STORAGE.CONFIG_FOLDER
    self.CONFIG.STORAGE.PATHS.CONFIG_FOLDER = fullPath
    self.CONFIG.THEATER = env.mission.theatre
    return instance
end

function AETHR:loadExistingData()
    self:loadConfig()
    return self
end

function AETHR:loadConfig()
    local lfs = require("lfs")
    local rt_path = lfs.writedir()
    local fullPath = rt_path .. self.CONFIG.STORAGE.ROOT_FOLDER .. "/" .. self.CONFIG.STORAGE.CONFIG_FOLDER
    local fileExists = self.fileOps.fileExists(fullPath, self.CONFIG.STORAGE.FILENAMES.AETHER_CONFIG_FILE)
    if fileExists then
        -- Load existing config
        local configData = self.fileOps.loadTableFromJSON(fullPath, self.CONFIG.STORAGE.FILENAMES.AETHER_CONFIG_FILE)
        if configData then
            for k, v in pairs(configData) do
                self.CONFIG[k] = v
            end
        end
    end
    return self
end

function AETHR:loadWorldDivisions()
    local lfs = require("lfs")
    local rt_path = lfs.writedir()
    local fullPath = rt_path .. self.CONFIG.STORAGE.ROOT_FOLDER .. "/" .. self.CONFIG.STORAGE.CONFIG_FOLDER
    local fileExists = self.fileOps.fileExists(fullPath, self.CONFIG.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE)
    if fileExists then
        -- Load existing config
        self.LEARNED_DATA.worldDivisions = self.fileOps.loadTableFromJSON(fullPath, self.CONFIG.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE)
    else
        self.LEARNED_DATA.worldDivisions = self.math.dividePolygon(
            self.CONFIG.worldBounds[self.CONFIG.THEATER],
            self.CONFIG.worldBounds.AREA,
            self.CONFIG.worldBounds.TOLERANCE
        )
        -- Save the world divisions to file
        self.fileOps.saveTableAsPrettyJSON(
            fullPath,
            self.CONFIG.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE,
            self.LEARNED_DATA.worldDivisions
        )
    end
    return self
end

function AETHR:Init()
    local lfs = require("lfs")
    local rt_path = lfs.writedir()
    for folderName, folderPath in pairs(self.CONFIG.STORAGE.SUB_FOLDERS) do
        local fullPath = rt_path .. self.CONFIG.STORAGE.ROOT_FOLDER .. "/" .. self.CONFIG.MISSION_ID .. "/" .. folderPath
        self.CONFIG.STORAGE.PATHS[folderName] = fullPath
        self.fileOps.ensureDirectory(fullPath)
    end

    self:loadExistingData()
    self:loadWorldDivisions()

    return self
end

function AETHR:SaveConfig()
    self.fileOps.saveTableAsPrettyJSON(
        self.CONFIG.STORAGE.PATHS.CONFIG_FOLDER,
        self.CONFIG.STORAGE.FILENAMES.AETHER_CONFIG_FILE,
        self.CONFIG
    )
    return self
end
