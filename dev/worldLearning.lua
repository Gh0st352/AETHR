AETHR.worldLearning = {}

function AETHR:loadWorldDivisions()
    local lfs = require("lfs")
    local rt_path = lfs.writedir()
    local fullPath = AETHR.fileOps.joinPaths(rt_path, self.CONFIG.STORAGE.ROOT_FOLDER, self.CONFIG.STORAGE.CONFIG_FOLDER)
    local fileExists = self.fileOps.fileExists(fullPath, self.CONFIG.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE)
    if fileExists then
        -- Load existing config
        local worldDivisions_ = self.fileOps.loadTableFromJSON(fullPath,
            self.CONFIG.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE)
        if worldDivisions_ then
            for _, division in ipairs(worldDivisions_) do
                self.LEARNED_DATA.worldDivisions[division.ID] = division
            end
        end
    else
        local worldBounds_ = AETHR.math.convertBoundsToPolygon(self.CONFIG.worldBounds[self.CONFIG.THEATER])
        local worldDivisions_ = self.math.dividePolygon(
            worldBounds_,
            self.CONFIG.worldDivisionArea
        )
        for i, division in ipairs(worldDivisions_) do
            self.LEARNED_DATA.worldDivisions[i] = division
            self.LEARNED_DATA.worldDivisions[i].ID = i
            self.LEARNED_DATA.worldDivisions[i].active = false
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
        if _divs[i]["active"] then
            trigger.action.markupToAll(7, -1, _shapeID,
                { x = _divs[i]["corners"][4].x, y = 0, z = _divs[i]["corners"][4].z },
                { x = _divs[i]["corners"][3].x, y = 0, z = _divs[i]["corners"][3].z },
                { x = _divs[i]["corners"][2].x, y = 0, z = _divs[i]["corners"][2].z },
                { x = _divs[i]["corners"][1].x, y = 0, z = _divs[i]["corners"][1].z }, { _R, _G, _B, 0.8 },
                { _R + 0.2, _G + 0.4, _B + 0.8, 0.3 },
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
end

function AETHR:getAirbases()
    local _airbases = world.getAirbases()

    for i = 1, #_airbases do
        local _airbase = _airbases[i]
        local _airbaseData = {
            id = _airbase:getID(),
            id_ = _airbase.id_,
            coordinates = {
                x = _airbase:getPosition().p.x,
                y = _airbase:getPosition().p.y,
                z = _airbase:getPosition().p.z,
            },
            description = _airbase:getDesc(),
        }
        if _airbaseData.description.category and _airbaseData.description.category == 0 then
            _airbaseData.categoryText =
            "AIRDROME"
        end
        if _airbaseData.description.category and _airbaseData.description.category == 1 then
            _airbaseData.categoryText =
            "HELIPAD"
        end
        if _airbaseData.description.category and _airbaseData.description.category == 2 then
            _airbaseData.categoryText =
            "SHIP"
        end

        self.AIRBASES[_airbaseData.description.displayName] = _airbaseData
    end
    return self
end

function AETHR:loadAirbases()
    local configData = self.fileOps.loadTableFromJSON(
        self.CONFIG.STORAGE.PATHS.MAP_FOLDER,
        self.CONFIG.STORAGE.FILENAMES.AIRBASES_FILE
    )
    if configData then
        for k, v in pairs(configData) do
            self.AIRBASES[k] = v
        end
    else
        self:getAirbases()
        -- If no config file exists, create a new one with default values
        self.fileOps.saveTableAsPrettyJSON(
            self.CONFIG.STORAGE.PATHS.MAP_FOLDER,
            self.CONFIG.STORAGE.FILENAMES.AIRBASES_FILE,
            self.AIRBASES
        )
    end
    return self
end

function AETHR.worldLearning.searchObjectsBox(objectCategory, corners, height)
    --       Object.Category.SCENERY
    --       Object.Category.STATIC
    --       Object.Category.UNIT

    local foundObjects = {}
    local boxVec = AETHR.worldLearning.getBoxPoints(corners, height)

    local _vol = AETHR.math.createBox(boxVec.min, boxVec.max)

    local ifFound = function(foundItem)
        local foundItemData = {
            id = foundItem.id_,
            desc = foundItem:getDesc(),
            position = foundItem:getPoint(),
        }
        foundObjects[foundItem.id_] = foundItemData
        return
    end

    world.searchObjects(objectCategory, _vol, ifFound)

    return foundObjects
end

function AETHR.worldLearning.getBoxPoints(corners, height)
    local min = {} -- min: vec3 coordinate located at the western-southern-lower vertex of the box
    local max = {} -- max: vec3 coordinate located at the eastern-northern-upper vertex of the box

    -- Initialize min and max with the first corner's values
    min.x = corners[1].x
    min.z = corners[1].z
    max.x = corners[1].x
    max.z = corners[1].z

    -- Find the minimum and maximum values for x and z
    for i = 1, #corners do
        if corners[i].x < min.x then
            min.x = corners[i].x
        end
        if corners[i].x > max.x then
            max.x = corners[i].x
        end

        if corners[i].z < min.z then
            min.z = corners[i].z
        end
        if corners[i].z > max.z then
            max.z = corners[i].z
        end
    end

    -- Add y-coordinate to convert to 3D points
    min.y = 0
    max.y = height

    return { min = min, max = max}
end
