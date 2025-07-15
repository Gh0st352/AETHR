AETHR = {
    USERSTORAGE = {},
    LEARNED_DATA = {
        worldDivisions = {},
        saveDivisions = {},
        divisionObjects = {},
    },
    AIRBASES = {},
    MIZ_ZONES = {},

}

function AETHR:New(MISSION_ID)
    MISSION_ID = MISSION_ID or self.MISSION_ID
    local instance = {}
    setmetatable(instance, { __index = self })
    local lfs = require("lfs")
    local rt_path = lfs.writedir()
    self.CONFIG.STORAGE.PATHS.CONFIG_FOLDER = AETHR.fileOps.joinPaths(rt_path, self.CONFIG.STORAGE.ROOT_FOLDER,
        self.CONFIG.STORAGE.CONFIG_FOLDER)
    self.CONFIG.THEATER = env.mission.theatre


    return instance
end


function AETHR:Init()
    local lfs = require("lfs")
    local rt_path = lfs.writedir()
    for folderName, folderPath in pairs(self.CONFIG.STORAGE.SUB_FOLDERS) do
        local fullPath = AETHR.fileOps.joinPaths(rt_path, self.CONFIG.STORAGE.ROOT_FOLDER, self.CONFIG.MISSION_ID,
            folderPath)
        self.CONFIG.STORAGE.PATHS[folderName] = fullPath
        self.fileOps.ensureDirectory(fullPath)
    end

    self:loadExistingData()
    self:loadWorldDivisions()
    self:loadUSERSTORAGE()
    self:SaveUSERSTORAGE()
    self:loadAirbases()
    self:getMizZoneData()
    self:SaveConfig()
    return self
end
