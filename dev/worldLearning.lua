--- @module AETHR.worldLearning
--- @brief Provides functions to load and manage learning data for world divisions.
---@diagnostic disable: undefined-global

AETHR.worldLearning = {}


--- Displays active world divisions on the map with randomized colors.
--- @param AETHR AETHR containing learned world divisions.
function AETHR.worldLearning._markWorldDivisions(AETHR)
    local divisions = AETHR.LEARNED_DATA.worldDivisions
    local shapeID = 352352352     -- Base marker ID
    local r, g, b = 0.1, 0.1, 0.1 -- Initial RGB components

    for _, div in ipairs(divisions) do
        if div.active then
            -- Draw polygon on map
            trigger.action.markupToAll(
                7, -1, shapeID,
                { x = div.corners[4].x, y = 0, z = div.corners[4].z },
                { x = div.corners[3].x, y = 0, z = div.corners[3].z },
                { x = div.corners[2].x, y = 0, z = div.corners[2].z },
                { x = div.corners[1].x, y = 0, z = div.corners[1].z },
                { r, g, b, 0.8 },                   -- Fill color
                { r + 0.2, g + 0.4, b + 0.8, 0.3 }, -- Border color
                4, true
            )
            shapeID = shapeID + 1 -- Increment marker ID

            -- Randomize next color
            r = (r + math.random()) % 1
            g = (g + math.random()) % 1
            b = (b + math.random()) % 1
        end
    end
end



--- Searches for objects of a given category within a 3D box volume.
--- @param objectCategory any Category filter for search
--- @param corners table Array of base corner points (x,z)
--- @param height number Height of the search volume
--- @return table Found objects keyed by object ID
function AETHR.worldLearning.searchObjectsBox(objectCategory, corners, height)
    -- Compute box extents
    local box = AETHR.POLY.getBoxPoints(corners, height)
    local vol = AETHR.POLY.createBox(box.min, box.max)
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
        local objs = self.fileOps.loadData(dir, file)

        if not objs then
            objs = self:objectsInDivision(id, objectCategory)
            if next(objs) then
                self.fileOps.saveData(dir, file, objs)
            end
        end

        self.LEARNED_DATA.divisionObjects[id] = self.LEARNED_DATA.divisionObjects[id] or {}
        self.LEARNED_DATA.divisionObjects[id][objectCategory] = objs
    end
    return self
end
