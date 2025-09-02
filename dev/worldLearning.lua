--- @module AETHR.worldLearning
--- @brief Provides functions to load and manage learning data for world divisions.
---@diagnostic disable: undefined-global

AETHR.worldLearning = {}

--- Loads existing world divisions from JSON if available; otherwise generates and saves new divisions.
--- @return AETHR Instance
function AETHR:loadWorldDivisions()
    local lfs = require("lfs")  -- LuaFileSystem for directory operations
    local rt_path = lfs.writedir()  -- Root writable path
    local fullPath = AETHR.fileOps.joinPaths(
        rt_path,
        self.CONFIG.STORAGE.ROOT_FOLDER,
        self.CONFIG.STORAGE.CONFIG_FOLDER
    )
    local fileExists = self.fileOps.fileExists(
        fullPath,
        self.CONFIG.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE
    )

    if fileExists then
        -- Load existing divisions from file
        local divisions = self.fileOps.loadTableFromJSON(
            fullPath,
            self.CONFIG.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE
        )
        if divisions then
            for _, div in ipairs(divisions) do
                self.LEARNED_DATA.worldDivisions[div.ID] = div
            end
        end
    else
        -- Generate new divisions based on theater bounds and division area
        local boundsPoly = AETHR.math.convertBoundsToPolygon(
            self.CONFIG.worldBounds[self.CONFIG.THEATER]
        )
        local worldDivs = self.math.dividePolygon(
            boundsPoly,
            self.CONFIG.worldDivisionArea
        )
        for i, div in ipairs(worldDivs) do
            div.ID = i                -- Assign unique ID
            div.active = false        -- Initial active flag
            self.LEARNED_DATA.worldDivisions[i] = div
        end
        -- Persist generated divisions
        self.fileOps.saveTableAsPrettyJSON(
            fullPath,
            self.CONFIG.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE,
            self.LEARNED_DATA.worldDivisions
        )
    end

    return self
end

--- Displays active world divisions on the map with randomized colors.
--- @param AETHR AETHR containing learned world divisions.
function AETHR.worldLearning._markWorldDivisions(AETHR)
    local divisions = AETHR.LEARNED_DATA.worldDivisions
    local shapeID = 352352352      -- Base marker ID
    local r, g, b = 0.1, 0.1, 0.1  -- Initial RGB components

    for _, div in ipairs(divisions) do
        if div.active then
            -- Draw polygon on map
            trigger.action.markupToAll(
                7, -1, shapeID,
                { x = div.corners[4].x, y = 0, z = div.corners[4].z },
                { x = div.corners[3].x, y = 0, z = div.corners[3].z },
                { x = div.corners[2].x, y = 0, z = div.corners[2].z },
                { x = div.corners[1].x, y = 0, z = div.corners[1].z },
                { r, g, b, 0.8 },       -- Fill color
                { r + 0.2, g + 0.4, b + 0.8, 0.3 }, -- Border color
                4, true
            )
            shapeID = shapeID + 1  -- Increment marker ID

            -- Randomize next color
            r = (r + math.random()) % 1
            g = (g + math.random()) % 1
            b = (b + math.random()) % 1
        end
    end
end

--- Retrieves all airbases in the world and stores their data.
--- @return AETHR Instance
function AETHR:getAirbases()
    local bases = world.getAirbases()  -- Array of airbase objects
    for _, ab in ipairs(bases) do
        local desc = ab:getDesc()
        local pos = ab:getPosition().p
        local data = {
            id = ab:getID(),
            id_ = ab.id_,
            coordinates = { x = pos.x, y = pos.y, z = pos.z },
            description = desc,
        }
        -- Map numeric category to text
        if desc.category == 0 then
            data.categoryText = "AIRDROME"
        elseif desc.category == 1 then
            data.categoryText = "HELIPAD"
        elseif desc.category == 2 then
            data.categoryText = "SHIP"
        end
        self.AIRBASES[desc.displayName] = data
    end
    return self
end

--- Loads airbase data from JSON or collects and saves new data.
--- @return AETHR Instance
function AETHR:loadAirbases()
    local mapPath = self.CONFIG.STORAGE.PATHS.MAP_FOLDER
    local fileName = self.CONFIG.STORAGE.FILENAMES.AIRBASES_FILE
    local data = self.fileOps.loadTableFromJSON(mapPath, fileName)

    if data then
        -- Populate from existing JSON
        for name, info in pairs(data) do
            self.AIRBASES[name] = info
        end
    else
        -- Gather and persist new data
        self:getAirbases()
        self.fileOps.saveTableAsPrettyJSON(mapPath, fileName, self.AIRBASES)
    end
    return self
end

--- Searches for objects of a given category within a 3D box volume.
--- @param objectCategory any Category filter for search
--- @param corners table Array of base corner points (x,z)
--- @param height number Height of the search volume
--- @return table Found objects keyed by object ID
function AETHR.worldLearning.searchObjectsBox(objectCategory, corners, height)
    -- Compute box extents
    local box = AETHR.worldLearning.getBoxPoints(corners, height)
    local vol = AETHR.math.createBox(box.min, box.max)
    local found = {}

    -- Callback for world.searchObjects
    local function ifFound(item)
        found[item.id_] = {
            id = item.id_,
            desc = item:getDesc(),
            position = item:getPoint()
        }
    end

    world.searchObjects(objectCategory, vol, ifFound)
    return found
end

--- Calculates bounding box min/max points for a set of corners and height.
--- @param corners table Array of corner points (x,z)
--- @param height number Vertical extent
--- @return table { min={x,y,z}, max={x,y,z} }
function AETHR.worldLearning.getBoxPoints(corners, height)
    local minPt = { x = math.huge, y = 0, z = math.huge }
    local maxPt = { x = -math.huge, y = height, z = -math.huge }

    -- Determine min/max X,Z
    for _, c in ipairs(corners) do
        if c.x < minPt.x then minPt.x = c.x end
        if c.z < minPt.z then minPt.z = c.z end
        if c.x > maxPt.x then maxPt.x = c.x end
        if c.z > maxPt.z then maxPt.z = c.z end
    end

    -- Set Y extents
    minPt.y = 0
    maxPt.y = height
    return { min = minPt, max = maxPt }
end

--- Determines active world divisions via saved data or spatial intersection.
--- @return AETHR self
function AETHR:determineActiveDivisions()
    local mapPath = self.CONFIG.STORAGE.PATHS.MAP_FOLDER
    local saveFile = self.CONFIG.STORAGE.FILENAMES.SAVE_DIVS_FILE
    local data = self.fileOps.loadTableFromJSON(mapPath, saveFile)

    if data then
        -- Use saved active flags
        self.LEARNED_DATA.saveDivisions = {}
        for _, div in ipairs(data) do
            if div.active then
                self.LEARNED_DATA.saveDivisions[div.ID] = div
            end
        end
    else
        -- Compute active flags by intersection
        local updated = self.AUTOSAVE.checkDivisionsInZones(
            self.LEARNED_DATA.worldDivisions,
            self.MIZ_ZONES
        )
        for _, div in ipairs(updated) do
            if div.active then
                self.LEARNED_DATA.saveDivisions[div.ID] = div
            end
        end
        self.fileOps.saveTableAsPrettyJSON(mapPath, saveFile, self.LEARNED_DATA.saveDivisions)
    end

    return self
end

--- Retrieves objects of a specific category within a division.
--- @param divisionID number ID of the division
--- @param objectCategory any Category filter
--- @return table Found objects
function AETHR:objectsInDivision(divisionID, objectCategory)
    local div = self.LEARNED_DATA.worldDivisions[divisionID]
    if not div then return {} end
    return self.worldLearning.searchObjectsBox(objectCategory, div.corners, div.height or 2000)
end

--- Loads or collects objects for all active divisions and saves them.
--- @param objectCategory any Category (e.g., "SCENERY", "STATIC", "UNIT")
--- @return AETHR self
function AETHR:getActiveObjectsInDivisions(objectCategory)
    for id, _ in pairs(self.LEARNED_DATA.saveDivisions) do
        local dir = self.CONFIG.STORAGE.PATHS.OBJECTS_FOLDER .. "/" .. id
        local file = objectCategory .. "_" .. self.CONFIG.STORAGE.FILENAMES.OBJECTS_FILE
        local objs = self.fileOps.loadTableFromPrettyJSON(dir, file)

        if not objs then
            objs = self:objectsInDivision(id, objectCategory)
            if next(objs) then
                self.fileOps.saveTableAsPrettyJSON(dir, file, objs)
            end
        end

        self.LEARNED_DATA.divisionObjects[id] = self.LEARNED_DATA.divisionObjects[id] or {}
        self.LEARNED_DATA.divisionObjects[id][objectCategory] = objs
    end
    return self
end
