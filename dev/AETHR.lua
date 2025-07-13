AETHR = {
    USERSTORAGE = {},
    LEARNED_DATA = {
        worldDivisions = {},
    },
}

function AETHR:New(MISSION_ID)
    MISSION_ID = MISSION_ID or self.MISSION_ID
    local instance = {}
    setmetatable(instance, { __index = self })
    local lfs = require("lfs")
    local rt_path = lfs.writedir()
    self.CONFIG.STORAGE.PATHS.CONFIG_FOLDER = AETHR.fileOps.joinPaths(rt_path, instance.CONFIG.STORAGE.ROOT_FOLDER, instance.CONFIG.STORAGE.CONFIG_FOLDER)
    self.CONFIG.THEATER = env.mission.theatre
    return instance
end

function AETHR:loadExistingData()
    self:loadConfig()
    return self
end

function AETHR:Init()
    local lfs = require("lfs")
    local rt_path = lfs.writedir()
    for folderName, folderPath in pairs(self.CONFIG.STORAGE.SUB_FOLDERS) do
        local fullPath = AETHR.fileOps.joinPaths(rt_path, self.CONFIG.STORAGE.ROOT_FOLDER, self.CONFIG.MISSION_ID, folderPath)
        self.CONFIG.STORAGE.PATHS[folderName] = fullPath
        self.fileOps.ensureDirectory(fullPath)
    end

    self:loadExistingData()
    self:loadWorldDivisions()
    self:loadUSERSTORAGE()
    self:SaveUSERSTORAGE()
    self:SaveConfig()
    return self
end

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

function AETHR:SaveConfig()
    self.fileOps.saveTableAsPrettyJSON(
        self.CONFIG.STORAGE.PATHS.CONFIG_FOLDER,
        self.CONFIG.STORAGE.FILENAMES.AETHER_CONFIG_FILE,
        self.CONFIG
    )
    return self
end
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

function AETHR:SaveUSERSTORAGE()
    self.fileOps.saveTableAsPrettyJSON(
        self.CONFIG.STORAGE.PATHS.USER_FOLDER,
        self.CONFIG.STORAGE.FILENAMES.USER_STORAGE_FILE,
        self.USERSTORAGE
    )
    return self
end
