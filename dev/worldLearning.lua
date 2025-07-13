AETHR.worldLearning = {}

function AETHR:loadWorldDivisions()
    local lfs = require("lfs")
    local rt_path = lfs.writedir()
    local fullPath = rt_path .. self.CONFIG.STORAGE.ROOT_FOLDER .. "/" .. self.CONFIG.STORAGE.CONFIG_FOLDER
    local fileExists = self.fileOps.fileExists(fullPath, self.CONFIG.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE)
    if fileExists then
        -- Load existing config
        local worldDivisions_ = self.fileOps.loadTableFromJSON(fullPath,
            self.CONFIG.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE)
        for i, division in ipairs(worldDivisions_) do

            self.LEARNED_DATA.worldDivisions[division.ID] = division
        end
    else
        local worldBounds_ = AETHR.math.convertBoundsToPolygon(self.CONFIG.worldBounds[self.CONFIG.THEATER])

        local worldDivisions_ = self.math.dividePolygon(
            worldBounds_,
            self.CONFIG.worldDivisionArea
        )

        for i, division in ipairs(worldDivisions_) do
            worldDivisions_[i].ID = i
            worldDivisions_[i].active = false
            self.LEARNED_DATA.worldDivisions[i] = division
        end

        -- Save the world divisions to file
        self.fileOps.saveTableAsPrettyJSON(
            fullPath,
            self.CONFIG.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE,
            self.LEARNED_DATA.worldDivisions
        )
    end
    return self
end

function AETHR.worldLearning._markWorldDivisions(AETHR)
    local divisions = AETHR.LEARNED_DATA.worldDivisions
    local _shapeID = 352352352
    local _divs = divisions
    local _R = 0.1
    local _G = 0.1
    local _B = 0.1

    for i = 1, #_divs do
        trigger.action.markupToAll(7, -1, _shapeID, { x = _divs[i][4].x, y = 0, z = _divs[i][4].z },
            { x = _divs[i][3].x, y = 0, z = _divs[i][3].z }, { x = _divs[i][2].x, y = 0, z = _divs[i][2].z },
            { x = _divs[i][1].x, y = 0, z = _divs[i][1].z }, { _R, _G, _B, 0.8 }, { _R + 0.2, _G + 0.4, _B + 0.8, 0.3 },
            4, true)
        _shapeID = _shapeID + 1

        _R = _R + math.random()
        _G = _G + math.random()
        _B = _B + math.random()

        if _R > 1 then _R = 0.1 end
        if _G > 1 then _G = 0.1 end
        if _B > 1 then _B = 0.1 end
    end
end
