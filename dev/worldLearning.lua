AETHR.worldLearning = {}

function AETHR:loadWorldDivisions()
    local lfs = require("lfs")
    local rt_path = lfs.writedir()
    local fullPath = rt_path .. self.CONFIG.STORAGE.ROOT_FOLDER .. "/" .. self.CONFIG.STORAGE.CONFIG_FOLDER
    local fileExists = self.fileOps.fileExists(fullPath, self.CONFIG.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE)
    if fileExists then
        -- Load existing config
        self.LEARNED_DATA.worldDivisions = self.fileOps.loadTableFromJSON(fullPath, self.CONFIG.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE)
    else
        local worldBounds_ = AETHR.math.convertBoundsToPolygon(self.CONFIG.worldBounds[self.CONFIG.THEATER])
        
        self.LEARNED_DATA.worldDivisions = self.math.dividePolygon(
            worldBounds_,
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

