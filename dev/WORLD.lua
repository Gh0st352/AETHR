--- @class AETHR.WORLD
--- @brief Manages mission trigger zones and computes bordering relationships.
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field UTILS AETHR.UTILS Utility functions submodule attached per-instance.
--- @field BRAIN AETHR.BRAIN
--- @field AI AETHR.AI
--- @field ENUMS AETHR.ENUMS Enumeration constants submodule attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field MATH AETHR.MATH Math helper table attached per-instance.
--- @field MARKERS AETHR.MARKERS
--- @field SPAWNER AETHR.SPAWNER Spawner submodule attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field DATA AETHR.WORLD.Data Container for zone management data.
--- @field AIRBASES table<string, _airbase> Airbase descriptors keyed by displayName
--- @field worldDivisions table<number, _WorldDivision> Grid division definitions keyed by ID
--- @field saveDivisions table<number, _WorldDivision> Active divisions keyed by ID
--- @field divisionSceneryObjects table<number, table<number, _FoundObject>> DivisionID -> (objectID -> _FoundObject)
--- @field divisionStaticObjects table<number, table<number, _FoundObject>>
--- @field divisionBaseObjects table<number, table<number, _FoundObject>>
AETHR.WORLD = {} ---@diagnostic disable-line

---
--- World subsystem for grid divisions, spatial search, zone ownership, and MIZ-file caches.
--- Usage:
---   local world = AETHR.WORLD:New(self)
---   world:initWorldDivisions():initActiveDivisions():initMizFileCache()
--- Notes:
--- - Many update methods may yield via BRAIN.DATA.coroutines.* when configured.
--- - See also: dev/customTypes.lua, dev/ENUMS.lua
---


---@class AETHR.WORLD.Data
--- @field AIRBASES table<string, _airbase>                       Airbase descriptors keyed by displayName
--- @field worldDivisions table<number, _WorldDivision>          Grid division definitions keyed by ID
--- @field saveDivisions table<number, _WorldDivision>           Active divisions keyed by ID
--- @field divisionSceneryObjects table<integer, table<integer, _FoundObject>>  DivisionID -> (objectID -> _FoundObject)
--- @field divisionStaticObjects table<integer, table<integer, _FoundObject>>
--- @field divisionBaseObjects table<integer, table<integer, _FoundObject>>
--- @field groundUnitsDB table<string, _foundObject>             Ground units keyed by object name/id
--- @field groundGroupsDB table<string, table<string>>           Ground groups keyed by group name -> unit name list
--- @field mizCacheDB table<string, table>                       Cached mission file group objects keyed by group name
--- @field spawnerTemplateDB table<string, table>                Cached spawn template groups keyed by template name
--- @field spawnerAttributesDB table<string, table<string, table>> Attributes -> (typeName -> unitDesc)
--- @field _spawnerAttributesDB table<string, table<string, table>> Internal use only, do not modify directly, filtered and prioritized spawnerAttributesDB
--- @field spawnerUnitInfoCache table<string, table>             Cached unit descriptor keyed by typeName
--- @field worldDivAABB table<number, table>                     Cached division AABB keyed by division ID
--- @field townClusterDB _dbCluster[]          Towns clusters database keyed by cluster ID
AETHR.WORLD.DATA = {
    AIRBASES               = {}, -- Airbase descriptors keyed by displayName.
    worldDivisions         = {}, -- Grid division definitions keyed by ID.
    worldDivAABB           = {}, -- Division AABB data keyed by ID.
    saveDivisions          = {}, -- Active divisions keyed by ID.
    divisionSceneryObjects = {}, -- Loaded scenery per division.
    divisionStaticObjects  = {}, -- Loaded statics per division.
    divisionBaseObjects    = {}, -- Loaded Base per division.
    townClusterDB          = {}, -- Towns clusters database.
    groundUnitsDB          = {}, -- Ground units database keyed by unit name.
    groundGroupsDB         = {}, -- Ground groups database keyed by group name.
    mizCacheDB             = {}, -- Cached MIZ file groups keyed by groupname.
    spawnerTemplateDB      = {}, -- Cached group templates keyed by template name.
    spawnerAttributesDB    = {}, -- Cached spawner attributes keyed by attribute, value is unit info object.
    _spawnerAttributesDB   = {}, -- Internal use only, do not modify directly, filtered and prioritized spawner attributesDB.
    spawnerUnitInfoCache   = {}, -- Cached spawner unit info keyed by unit typeName.
}


--- Create a new WORLD instance attached to parent AETHR.
--- @param parent AETHR Parent AETHR instance (owner)
--- @return AETHR.WORLD instance
function AETHR.WORLD:New(parent)
    local instance = {
        AETHR = parent,
        -- submodule-local caches/state can be initialized here
        _cache = {},
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- Initializes MIZ-file related caches by loading from storage or generating defaults.
--- If no stored cache is found, this will generate and persist a new cache.
--- Side-effects: Reads from and may write to storage via FILEOPS; mutates DATA.mizCacheDB, DATA.spawnerTemplateDB, DATA.spawnerAttributesDB, DATA.spawnerUnitInfoCache.
--- @return AETHR.WORLD self (for chaining)
function AETHR.WORLD:initMizFileCache()
    local data = self:getStoredMizFileCache()
    if data then
        self.DATA.mizCacheDB           = data.MIZ_CACHE_DB
        self.DATA.spawnerTemplateDB    = data.SPAWNER_TEMPLATE_DB
        self.DATA.spawnerAttributesDB  = data.SPAWNER_ATTRIBUTE_DB
        self.DATA._spawnerAttributesDB = data._SPAWNER_ATTRIBUTE_DB
        self.DATA.spawnerUnitInfoCache = data.SPAWNER_UNIT_CACHE_DB
    else
        self:generateMizFileCache()
        self:saveMizFileCache()
    end
    return self
end

--- Attempts to load persisted MIZ file-derived caches from disk.
--- Returns nil when any of the expected files is missing or invalid.
--- Side-effects: Reads from CONFIG.MAIN.STORAGE.PATHS.LEARNING_FOLDER via FILEOPS; no in-memory mutation besides return value.
--- @return table|nil data Table with keys: MIZ_CACHE_DB, SPAWNER_TEMPLATE_DB, SPAWNER_ATTRIBUTE_DB, SPAWNER_UNIT_CACHE_DB, or nil if incomplete
function AETHR.WORLD:getStoredMizFileCache()
    local data = {}
    local mapPath = self.CONFIG.MAIN.STORAGE.PATHS.LEARNING_FOLDER

    local saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.MIZ_CACHE_DB
    data.MIZ_CACHE_DB = self.FILEOPS:loadData(mapPath, saveFile)

    saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.SPAWNER_TEMPLATE_DB
    data.SPAWNER_TEMPLATE_DB = self.FILEOPS:loadData(mapPath, saveFile)

    saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.SPAWNER_ATTRIBUTE_DB
    data.SPAWNER_ATTRIBUTE_DB = self.FILEOPS:loadData(mapPath, saveFile)

    saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES._SPAWNER_ATTRIBUTE_DB
    data._SPAWNER_ATTRIBUTE_DB = self.FILEOPS:loadData(mapPath, saveFile)

    saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.SPAWNER_UNIT_CACHE_DB
    data.SPAWNER_UNIT_CACHE_DB = self.FILEOPS:loadData(mapPath, saveFile)


    if data
        and data.MIZ_CACHE_DB
        and data.SPAWNER_TEMPLATE_DB
        and data.SPAWNER_ATTRIBUTE_DB
        and data._SPAWNER_ATTRIBUTE_DB
        and data.SPAWNER_UNIT_CACHE_DB
    then
        return data
    end
    return nil
end

--- Persists current MIZ-file caches to disk.
--- Uses configured storage paths and filenames.
--- Side-effects: Writes cache files under CONFIG.MAIN.STORAGE.PATHS.LEARNING_FOLDER.
--- @return nil
function AETHR.WORLD:saveMizFileCache()
    local mapPath = self.CONFIG.MAIN.STORAGE.PATHS.LEARNING_FOLDER

    local saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.MIZ_CACHE_DB
    local ok1 = self.FILEOPS:saveData(mapPath, saveFile, self.DATA.mizCacheDB)
    if not ok1 and self.CONFIG.MAIN.DEBUG_ENABLED then
        self.UTILS:debugInfo("AETHR.WORLD:saveMizFileCache failed saving " .. tostring(saveFile))
    end

    saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.SPAWNER_TEMPLATE_DB
    local ok2 = self.FILEOPS:saveData(mapPath, saveFile, self.DATA.spawnerTemplateDB)
    if not ok2 and self.CONFIG.MAIN.DEBUG_ENABLED then
        self.UTILS:debugInfo("AETHR.WORLD:saveMizFileCache failed saving " .. tostring(saveFile))
    end

    saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.SPAWNER_ATTRIBUTE_DB
    local ok3 = self.FILEOPS:saveData(mapPath, saveFile, self.DATA.spawnerAttributesDB)
    if not ok3 and self.CONFIG.MAIN.DEBUG_ENABLED then
        self.UTILS:debugInfo("AETHR.WORLD:saveMizFileCache failed saving " .. tostring(saveFile))
    end

    saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES._SPAWNER_ATTRIBUTE_DB
    local ok5 = self.FILEOPS:saveData(mapPath, saveFile, self.DATA._spawnerAttributesDB)
    if not ok5 and self.CONFIG.MAIN.DEBUG_ENABLED then
        self.UTILS:debugInfo("AETHR.WORLD:saveMizFileCache failed saving " .. tostring(saveFile))
    end

    saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.SPAWNER_UNIT_CACHE_DB
    local ok4 = self.FILEOPS:saveData(mapPath, saveFile, self.DATA.spawnerUnitInfoCache)
    if not ok4 and self.CONFIG.MAIN.DEBUG_ENABLED then
        self.UTILS:debugInfo("AETHR.WORLD:saveMizFileCache failed saving " .. tostring(saveFile))
    end
end

--- Scans env.mission structure to build caches of groups and unit descriptors for spawner usage.
--- Populates:
---   * DATA.mizCacheDB (group objects from mission file)
---   * DATA.spawnerTemplateDB (groups matching configured spawn template string)
---   * DATA.spawnerUnitInfoCache (typeName -> desc)
---   * DATA.spawnerAttributesDB (attribute -> typeName -> desc)
--- Side-effects: Populates DATA.mizCacheDB, DATA.spawnerTemplateDB, DATA.spawnerUnitInfoCache, DATA.spawnerAttributesDB; may query engine groups at runtime.
--- @return AETHR.WORLD self
function AETHR.WORLD:generateMizFileCache()
    self.UTILS:debugInfo("AETHR.WORLD:initMizFileCache -------------")
    local mizCache = self.DATA.mizCacheDB
    for coalition, coalitionObj in pairs(env.mission.coalition) do
        local _coal = coalition == "blue" and self.ENUMS.Coalition.BLUE or
            coalition == "red" and self.ENUMS.Coalition.RED or
            self.ENUMS.Coalition.NEUTRAL
        for _, countryObj in ipairs(coalitionObj.country) do
            local _countryID = countryObj.id
            local _countryName = countryObj.name
            for k, v in pairs(countryObj) do
                if k ~= "id" and k ~= "name" then
                    local typeKey = k -- "plane", "vehicle", "static", "ship", "helicopter"
                    local groups = (type(v) == "table") and v.group or nil
                    if type(groups) == "table" then
                        for __, groupObj in ipairs(groups) do
                            -- Attach metadata used by spawner logic
                            groupObj.AETHR = {
                                coalition   = _coal,
                                countryID   = _countryID,
                                countryName = _countryName,
                                typeKey     = typeKey,
                            }
                            mizCache[groupObj.name] = groupObj
                        end
                    end
                end
            end
        end
    end
    local searchString = self.AETHR.CONFIG.MAIN.spawnTemplateSearchString
    for groupName, groupObj in pairs(mizCache) do
        if searchString and searchString ~= "" and string.find(groupName, searchString, 1, true) then
            self.DATA.spawnerTemplateDB[groupName] = groupObj
        end
    end

    local spawnerTemplateDB = self.DATA.spawnerTemplateDB
    local spawnerUnitInfoCache = self.DATA.spawnerUnitInfoCache
    local spawnerAttributesDB = self.DATA.spawnerAttributesDB
    local _spawnerAttributesDB = self.DATA._spawnerAttributesDB
    for groupName, groupObj in pairs(spawnerTemplateDB) do
        local _gObj = Group.getByName(groupName)
        local _gUnits = nil
        if _gObj and type(_gObj.getUnits) == "function" then
            local ok, units = pcall(_gObj.getUnits, _gObj)
            if ok then _gUnits = units end
        end
        if _gUnits and #_gUnits >= 1 then
            for _, unitObj in ipairs(_gUnits) do
                local descUnit = unitObj:getDesc()
                if descUnit then
                    local typeName = descUnit.typeName
                    if typeName and not spawnerUnitInfoCache[typeName] then
                        spawnerUnitInfoCache[typeName] = descUnit
                    end
                    if descUnit.attributes and type(typeName) == "string" then
                        local prioValue_ = 0
                        local prioAttrib_ = nil

                        for attrib, _ in pairs(descUnit.attributes) do
                            if attrib then
                                spawnerAttributesDB[attrib] = spawnerAttributesDB[attrib] or {}
                                if not spawnerAttributesDB[attrib][typeName] then
                                    spawnerAttributesDB[attrib][typeName] = descUnit
                                end
                            end
                            local attribPrioLookup = nil
                            for enumKey, enumVal in pairs(self.ENUMS.spawnTypes) do
                                if enumVal == attrib then
                                    attribPrioLookup = self.ENUMS.spawnTypesPrio[enumKey]
                                    break
                                end
                            end
                            if attribPrioLookup and attribPrioLookup > prioValue_ then
                                prioValue_ = attribPrioLookup
                                prioAttrib_ = attrib
                            end
                        end
                        --- Determine Highest Attributes Prio Score
                        _spawnerAttributesDB[prioAttrib_] = _spawnerAttributesDB[prioAttrib_] or {}
                        if not _spawnerAttributesDB[prioAttrib_][typeName] then
                            _spawnerAttributesDB[prioAttrib_][typeName] = descUnit
                        end
                    end
                end
            end
        end
    end
    return self
end

--- @function AETHR.WORLD:markWorldDivisions
--- @brief Displays active world divisions on the map with randomized colors.
--- Draws polygon markers for each active division and advances the global marker counter.
--- Side-effects: Draws map markups and increments CONFIG.MAIN.COUNTERS.MARKERS.
--- @return AETHR.WORLD self
function AETHR.WORLD:markWorldDivisions()
    local divisions = self.DATA.saveDivisions
    local shapeID = self.CONFIG.MAIN.COUNTERS.MARKERS -- 352352352     -- Base marker ID
    local r, g, b = 0.1, 0.1, 0.1                     -- Initial RGB components
    local alpha1 = 0.8
    local alpha2 = 0.3
    local linetype = 4 -- Dot Dash

    ---@param div _WorldDivision
    for _, div in pairs(divisions) do
        local shapeTypeID = 7 -- Polygon shape type
        local coalition = -1  -- All coalitions
        local vec3_1 = { x = div.corners[4].x, y = 0, z = div.corners[4].z }
        local vec3_2 = { x = div.corners[3].x, y = 0, z = div.corners[3].z }
        local vec3_3 = { x = div.corners[2].x, y = 0, z = div.corners[2].z }
        local vec3_4 = { x = div.corners[1].x, y = 0, z = div.corners[1].z }


        -- if div.active then
        -- Draw polygon on map
        local borderR = math.min(1, r + 0.2)
        local borderG = math.min(1, g + 0.4)
        local borderB = math.min(1, b + 0.8)
        trigger.action.markupToAll(
            shapeTypeID, coalition, shapeID,
            vec3_1,
            vec3_2,
            vec3_3,
            vec3_4,
            { r, g, b, alpha1 },                   -- Fill color
            { borderR, borderG, borderB, alpha2 }, -- Border color (clamped)
            linetype, true
        )
        shapeID = shapeID + 1 -- Increment marker ID

        -- Randomize next color
        r = (r + math.random()) % 1
        g = (g + math.random()) % 1
        b = (b + math.random()) % 1
        --  end
    end
    self.CONFIG.MAIN.COUNTERS.MARKERS = shapeID
    return self
end

--- Searches for objects of a given category within a 3D box volume.
--- @param objectCategory integer Category filter (AETHR.ENUMS.ObjectCategory)
--- @param corners _vec2xz[] Array of base corner points (x,z) used to compute the box
--- @param height number Height of the search volume in meters
--- @return table<string|number, _FoundObject> found Found objects keyed by unit name when available, otherwise numeric engine ID or tostring fallback
function AETHR.WORLD:searchObjectsBox(objectCategory, corners, height)
    -- Compute box extents
    local box = self.POLY:getBoxPoints(corners, height) ---@diagnostic disable-line
    local vol = self.POLY:createBox(box.min, box.max)
    local found = {} ---@type table<number, _FoundObject>

    -- Derive a stable key (prefer name, then ID, then engine id_, then tostring)
    local function safeKey(item)
        local key
        if type(item.getName) == "function" then
            local ok, val = pcall(item.getName, item)
            if ok and val and val ~= "" then key = val end
        end
        if not key and type(item.getID) == "function" then
            local ok, val = pcall(item.getID, item)
            if ok and val then key = val end
        end
        if not key and item and item.id_ then key = item.id_ end
        if not key then key = tostring(item) end
        return key
    end
    local function safeObj(item)
        return self.AETHR._foundObject:New(item)
    end
    -- Callback for world.searchObjects
    local function ifFound(item)
        local key = safeKey(item)
        local _okval, _val = pcall(safeObj, item)
        if _okval then
            found[key] = _val
        end
    end

    local ok, err = pcall(world.searchObjects, objectCategory, vol, ifFound)
    if not ok then
        if self.CONFIG and self.CONFIG.MAIN and self.CONFIG.MAIN.DEBUG_ENABLED and self.UTILS and self.UTILS.debugInfo then
            self.UTILS:debugInfo("AETHR.WORLD:searchObjectsBox world.searchObjects error: " .. tostring(err))
        end
    end
    -- if dbg and self.UTILS and self.UTILS.debugInfo then
    --     self.UTILS:debugInfo("AETHR.WORLD:searchObjectsBox ---------END")
    -- end
    return found
end

--- Searches for objects of a given category within a sphere volume.
--- @param centerVec2 _vec2|_vec2xz Center point of the sphere ({x,y} or {x,z}).
--- @param radius number Sphere radius (> 0).
--- @param yHeight number|nil Optional vertical coordinate (y) for the sphere center; defaults to 0 if nil.
--- @return table<string|number, _FoundObject> found Found objects keyed by unit name when available, otherwise numeric engine ID or tostring fallback
function AETHR.WORLD:searchObjectsSphere(objectCategory, centerVec2, radius, yHeight)
    local vol = self.POLY:createSphere(centerVec2, radius, yHeight)
    local found = {} ---@type table<number, _FoundObject>

    -- Derive a stable key (prefer name, then ID, then engine id_, then tostring)
    local function safeKey(item)
        local key
        if type(item.getName) == "function" then
            local ok, val = pcall(item.getName, item)
            if ok and val and val ~= "" then key = val end
        end
        if not key and type(item.getID) == "function" then
            local ok, val = pcall(item.getID, item)
            if ok and val then key = val end
        end
        if not key and item and item.id_ then key = item.id_ end
        if not key then key = tostring(item) end
        return key
    end

    local function safeObj(item)
        return self.AETHR._foundObject:New(item)
    end

    -- Callback for world.searchObjects
    local function ifFound(item)
        local key = safeKey(item)
        local _okval, _val = pcall(safeObj, item)
        if _okval then
            found[key] = _val
        end
    end

    local ok, err = pcall(world.searchObjects, objectCategory, vol, ifFound)
    if not ok and self.UTILS and self.UTILS.debugInfo then
        self.UTILS:debugInfo("AETHR.WORLD:searchObjectsSphere ERROR world.searchObjects: " .. tostring(err))
    end
    return found
end

--- Retrieves all airbases in the world and stores their data in DATA.AIRBASES.
--- Populates AETHR._airbase objects and assigns them to corresponding MIZ zones when found.
--- Side-effects: Reads engine airbases; populates DATA.AIRBASES and zone linkages.
--- @return AETHR.WORLD self
function AETHR.WORLD:getAirbases()
    local bases = world.getAirbases() -- Array of airbase objects
    for _, ab in ipairs(bases) do
        local desc = ab:getDesc()
        local pos = ab:getPosition().p
        local coalitionNow = ab:getCoalition()
        local data = {
            id = ab:getID(),
            id_ = ab.id_,
            coordinates = self.AETHR._vec3:New(pos.x, pos.y, pos.z),
            description = desc,
            zoneName = "",
            ---@type _MIZ_ZONE
            zoneObject = {}, ---@diagnostic disable-line
            ---@type string
            categoryText = "",
        }
        -- Map numeric category to text
        if desc.category == 0 then
            data.categoryText = "AIRDROME"
        elseif desc.category == 1 then
            data.categoryText = "HELIPAD"
        elseif desc.category == 2 then
            data.categoryText = "SHIP"
        end


        if self.UTILS.sumTable(self.ZONE_MANAGER.DATA.MIZ_ZONES) >= 1 then
            for zoneName, zone in pairs(self.ZONE_MANAGER.DATA.MIZ_ZONES) do
                if self.POLY:PointWithinShape( --P, Polygon)
                        { x = pos.x, y = pos.z },
                        zone.vertices
                    ) then
                    data.zoneName = zoneName
                    data.zoneObject = zone
                    break
                end
            end
        end

        local _airbase = self.AETHR._airbase:New(
            data.id, data.id_, data.coordinates,
            data.description, data.zoneName, data.zoneObject,
            desc.displayName, desc.category,
            data.categoryText, coalitionNow, -- currentCoalition
            coalitionNow                     -- previousCoalition (initially same)
        )

        if self.UTILS.sumTable(data.zoneObject) >= 1 and data.zoneObject.Airbases then
            data.zoneObject.Airbases[desc.displayName] = _airbase
        end
        self.DATA.AIRBASES[desc.displayName] = _airbase
    end
    return self
end

--- Updates airbase coalition ownership by comparing stored ownership against current engine state.
--- Uses coroutine yield hints from BRAIN.DATA.coroutines.updateAirfieldOwnership to avoid long blocking runs.
--- Side-effects: Mutates zone airbase objects' coalition fields; may yield when configured.
--- @return AETHR.WORLD self
function AETHR.WORLD:updateAirbaseOwnership()
    self.UTILS:debugInfo("AETHR.WORLD:updateAirbaseOwnership -------------")
    local _zones = self.ZONE_MANAGER.DATA.MIZ_ZONES
    local co_ = self.BRAIN.DATA.coroutines.updateAirfieldOwnership


    for zName, zObj in pairs(_zones) do
        for abName, abObj in pairs(zObj.Airbases) do
            local updatedABObj = Airbase.getByName(abName)
            local updatedABObjCoalition = nil
            if updatedABObj and type(updatedABObj.getCoalition) == "function" then
                local ok, coal = pcall(updatedABObj.getCoalition, updatedABObj)
                if ok then updatedABObjCoalition = coal end
            end

            if updatedABObjCoalition and abObj.coalition ~= updatedABObjCoalition then
                abObj.previousCoalition = abObj.coalition
                abObj.coalition = updatedABObjCoalition
            end

            if co_ and co_.thread then
                co_.yieldCounter = co_.yieldCounter + 1
                if co_.yieldCounter >= co_.yieldThreshold then
                    co_.yieldCounter = 0
                    self.UTILS:debugInfo("AETHR.WORLD:updateAirbaseOwnership --> YIELD")
                    coroutine.yield()
                end
            end
        end
    end
    return self
end

--- Activates queued ground groups by name using Group.activate.
--- Processes SPAWNER.DATA.spawnQueue and yields periodically when a coroutine is configured.
--- Side-effects: Activates engine groups; mutates SPAWNER.DATA.spawnQueue.
--- @return AETHR.WORLD self
function AETHR.WORLD:spawnGroundGroups()
    self.UTILS:debugInfo("AETHR.WORLD:spawnGroundGroups -------------")
    local co_ = self.BRAIN.DATA.coroutines.spawnGroundGroups

    local queue = self.SPAWNER.DATA.spawnQueue
    if type(queue) ~= "table" then return self end

    for i = #queue, 1, -1 do
        local name = queue[i]
        if name then
            self.UTILS:debugInfoRate("AETHR.WORLD:spawnGroundGroups|" .. tostring(name), 2)
            local curTime = self.UTILS:getTime()
            local groupObj = self.SPAWNER.DATA.generatedGroups[name]
            local groupAddTime = (groupObj and groupObj._engineAddTime) or 0
            local waitTime = (self.SPAWNER.DATA.CONFIG and self.SPAWNER.DATA.CONFIG.SPAWNER_WAIT_TIME) or 0

            if (curTime - groupAddTime) < waitTime then
                self.UTILS:debugInfoRate("AETHR.WORLD:spawnGroundGroups|skip|" ..
                    tostring(name), 2)
            else
                local activated = false
                local safeOk = pcall(function()
                    local g = Group.getByName(name)
                    if g then
                        Group.activate(g)
                        activated = true
                    end
                end)
                if safeOk and activated then
                    table.remove(queue, i)
                else
                    self.UTILS:debugInfoRate("AETHR.WORLD:spawnGroundGroups|activateFail|" .. tostring(name), 2)
                end
            end

            if co_ and co_.thread then
                co_.yieldCounter = co_.yieldCounter + 1
                if co_.yieldCounter >= co_.yieldThreshold then
                    co_.yieldCounter = 0
                    self.UTILS:debugInfo("AETHR.WORLD:spawnGroundGroups --> YIELD")
                    coroutine.yield()
                end
            end
        end
    end
    return self
end

--- Deactivates queued ground groups by name using trigger.action.deactivateGroup.
--- Processes SPAWNER.DATA.despawnQueue and yields periodically when a coroutine is configured.
--- Side-effects: Deactivates engine groups; mutates SPAWNER.DATA.despawnQueue.
--- @return AETHR.WORLD self
function AETHR.WORLD:despawnGroundGroups()
    self.UTILS:debugInfo("AETHR.WORLD:despawnGroundGroups -------------")
    local co_ = self.BRAIN.DATA.coroutines.despawnGroundGroups

    local queue = self.SPAWNER.DATA.despawnQueue
    if type(queue) ~= "table" then return self end

    for i = #queue, 1, -1 do
        local name = queue[i]
        if name then
            self.UTILS:debugInfoRate("AETHR.WORLD:despawnGroundGroups|" .. tostring(name), 2)

            local deactivated = false
            local safeOk = pcall(function()
                local g = Group.getByName(name)
                if g then
                    trigger.action.deactivateGroup(g)
                    deactivated = true
                end
            end)
            if safeOk and deactivated then
                table.remove(queue, i)
            else
                self.UTILS:debugInfoRate("AETHR.WORLD:despawnGroundGroups|deactivateFail|" .. tostring(name), 2)
            end

            if co_ and co_.thread then
                co_.yieldCounter = co_.yieldCounter + 1
                if co_.yieldCounter >= co_.yieldThreshold then
                    co_.yieldCounter = 0
                    self.UTILS:debugInfo("AETHR.WORLD:despawnGroundGroups --> YIELD")
                    coroutine.yield()
                end
            end
        end
    end
    return self
end

--- Recomputes zone ownership based on airbase counts within each zone.
--- Uses configured enums and yields to avoid long blocking runs.
--- Side-effects: Mutates zone ownership fields (zObj.ownedBy/oldOwnedBy); may yield when configured.
--- @return AETHR.WORLD self
function AETHR.WORLD:updateZoneOwnership()
    self.UTILS:debugInfo("AETHR.WORLD:updateZoneOwnership -------------")
    local _zones = self.ZONE_MANAGER.DATA.MIZ_ZONES
    local co_ = self.BRAIN.DATA.coroutines.updateZoneOwnership
    local ENUM_RED = self.ENUMS.Coalition.RED
    local ENUM_BLUE = self.ENUMS.Coalition.BLUE
    local ENUM_NEUTRAL = self.ENUMS.Coalition.NEUTRAL

    for zName, zObj in pairs(_zones) do
        local numRed = 0
        local numBlue = 0
        local owner_ = 0
        for abName, abObj in pairs(zObj.Airbases) do
            if abObj.coalition == ENUM_RED then
                numRed = numRed + 1
            elseif abObj.coalition == ENUM_BLUE then
                numBlue = numBlue + 1
            end

            if co_.thread then
                co_.yieldCounter = co_.yieldCounter + 1
                if co_.yieldCounter >= co_.yieldThreshold then
                    co_.yieldCounter = 0
                    self.UTILS:debugInfo("AETHR.WORLD:updateZoneOwnership --> YIELD")
                    coroutine.yield()
                end
            end
        end

        if numRed > numBlue then
            owner_ = ENUM_RED
        elseif numBlue > numRed then
            owner_ = ENUM_BLUE
        else
            owner_ = ENUM_NEUTRAL
        end

        if zObj.ownedBy ~= owner_ then
            zObj.oldOwnedBy = zObj.ownedBy
            zObj.ownedBy = owner_
        end
    end

    return self
end

--- Updates zone marker colors to reflect ownership changes.
--- Uses UTILS:updateMarkupColors to change map markers; may yield when a coroutine is configured.
--- Side-effects: Updates DCS map markups; writes zObj.lastMarkColorOwner.
--- @return AETHR.WORLD self
function AETHR.WORLD:updateZoneColors()
    self.UTILS:debugInfo("AETHR.WORLD:updateZoneColors -------------")
    local _zones = self.ZONE_MANAGER.DATA.MIZ_ZONES
    local co_ = self.BRAIN.DATA.coroutines.updateZoneColors

    for zName, zObj in pairs(_zones) do
        local ownedBy = zObj.ownedBy
        local oldOwnedBy = zObj.lastMarkColorOwner

        if ownedBy ~= oldOwnedBy then
            self.UTILS:debugInfo("AETHR.WORLD:updateZoneColors --> Update " ..
                zName .. " from " .. oldOwnedBy .. " to " .. ownedBy)
            local _LineColors = self.CONFIG.MAIN.Zone.paintColors.LineColors[ownedBy] or
                self.CONFIG.MAIN.Zone.paintColors.LineColors[0]
            local _FillColors = self.CONFIG.MAIN.Zone.paintColors.FillColors[ownedBy] or
                self.CONFIG.MAIN.Zone.paintColors.FillColors[0]
            local lineColor = {
                _LineColors.r, _LineColors.g, _LineColors.b, self.CONFIG.MAIN.Zone.paintColors.LineAlpha
            }
            local fillColor = {
                _FillColors.r, _FillColors.g, _FillColors.b, self.CONFIG.MAIN.Zone.paintColors.FillAlpha
            }

            if zObj.markerObject and zObj.markerObject.markID then
                self.UTILS:updateMarkupColors(zObj.markerObject.markID, lineColor, fillColor)
            end
            zObj.lastMarkColorOwner = ownedBy
        end


        if co_.thread then
            co_.yieldCounter = co_.yieldCounter + 1
            if co_.yieldCounter >= co_.yieldThreshold then
                co_.yieldCounter = 0
                self.UTILS:debugInfo("AETHR.WORLD:updateZoneColors --> YIELD")
                coroutine.yield()
            end
        end
    end

    return self
end

--- Updates the visibility of border arrows between zones based on ownership differences.
--- Iterates BorderingZones on each zone and shows/hides arrows for the coalition that should be displayed; may yield when configured.
--- Side-effects: Updates arrow markups visibility; writes borderDetail.lastShownCoalition.
--- @return AETHR.WORLD self
function AETHR.WORLD:updateZoneArrows()
    self.UTILS:debugInfo("AETHR.WORLD:updateZoneArrows -------------")
    local _zones = self.ZONE_MANAGER.DATA.MIZ_ZONES
    local co_ = self.BRAIN.DATA.coroutines.updateZoneArrows
    local ArrowColors = self.CONFIG.MAIN.Zone.paintColors.ArrowColors

    for zName, zObj in pairs(_zones) do
        local ownedBy = zObj.ownedBy
        for bzName, bzObj in pairs(zObj.BorderingZones) do
            local borderCoalition = _zones[bzName] and _zones[bzName].ownedBy
            for _, borderDetail in ipairs(bzObj) do
                -- Decide which coalition’s arrow should be visible (if any).
                local desiredShown = nil
                if ownedBy ~= nil and borderCoalition ~= nil and ownedBy ~= borderCoalition then
                    desiredShown = ownedBy
                end

                local lastShown = borderDetail.lastShownCoalition

                if desiredShown ~= lastShown then
                    -- Hide previously shown arrow (if any).
                    if lastShown ~= nil and borderDetail.MarkID and borderDetail.MarkID[lastShown] then
                        local c = ArrowColors[lastShown]
                        if c then
                            self.UTILS:updateMarkupColors(
                                borderDetail.MarkID[lastShown],
                                { c.r, c.g, c.b, 0 },
                                { c.r, c.g, c.b, 0 }
                            )
                        end
                        if co_.thread then
                            co_.yieldCounter = (co_.yieldCounter or 0) + 1
                            if co_.yieldCounter >= (co_.yieldThreshold or 0) then
                                co_.yieldCounter = 0
                                self.UTILS:debugInfo("AETHR.WORLD:updateZoneArrows --> YIELD")
                                coroutine.yield()
                            end
                        end
                    end

                    -- Show new arrow (if needed).
                    if desiredShown ~= nil and borderDetail.MarkID and borderDetail.MarkID[desiredShown] then
                        local c = ArrowColors[desiredShown]
                        if c then
                            self.UTILS:updateMarkupColors(
                                borderDetail.MarkID[desiredShown],
                                { c.r, c.g, c.b, c.a or 1 },
                                { c.r, c.g, c.b, c.a or 1 }
                            )
                        end
                        if co_.thread then
                            co_.yieldCounter = (co_.yieldCounter or 0) + 1
                            if co_.yieldCounter >= (co_.yieldThreshold or 0) then
                                co_.yieldCounter = 0
                                self.UTILS:debugInfo("AETHR.WORLD:updateZoneArrows --> YIELD")
                                coroutine.yield()
                            end
                        end
                    end

                    borderDetail.lastShownCoalition = desiredShown
                end
            end
        end
    end
    return self
end

--- Coroutine body executed by BRAIN:doRoutine to process generation jobs.
--- Runs one job at a time; heavy sub-steps yield via _maybeYield inside pipeline functions.
---@return AETHR.WORLD self
function AETHR.WORLD:spawnerGenerationQueue()
    self.UTILS:debugInfo("AETHR.WORLD:spawnerGenerationQueue -------------")
    local state = self.SPAWNER.DATA._genState or { currentJobId = nil }
    self.SPAWNER.DATA._genState = state
    local jobs = self.SPAWNER.DATA.GenerationJobs or {}
    local q = self.SPAWNER.DATA.GenerationQueue or {}

    -- If a job is currently running (we yield inside generateDynamicSpawner), just return.
    if state.currentJobId and jobs[state.currentJobId] and jobs[state.currentJobId].status == "running" then
        return self
    end

    -- Start next job if available
    local jobId = table.remove(q, 1)
    if not jobId then
        return self
    end

    local job = jobs[jobId]
    if not job then return self end

    state.currentJobId = jobId
    job.status = "running"
    job.startedAt = (self.UTILS and self.UTILS.getTime) and self.UTILS:getTime() or os.time()

    -- Run generation synchronously within this coroutine; heavy functions will yield via _maybeYield.
    self.SPAWNER:generateDynamicSpawner(
        job.params.dynamicSpawner,
        job.params.vec2,
        job.params.minRadius,
        job.params.nominalRadius,
        job.params.maxRadius,
        job.params.nudgeFactorRadius,
        job.params.countryID
    )

    -- Optional auto-spawn after prototypes are built
    if job.params.autoSpawn then
        pcall(function()
            self.SPAWNER:spawnDynamicSpawner(job.params.dynamicSpawner, job.params.countryID)
        end)
    end

    job.completedAt = (self.UTILS and self.UTILS.getTime) and self.UTILS:getTime() or os.time()
    job.status = "done"
    state.currentJobId = nil

    -- Light yield between jobs
    self.SPAWNER:_maybeYield(1)
    return self
end

--- Rebuilds the ground unit database by scanning active divisions for UNIT objects.
--- This function is designed to run incrementally across coroutine invocations.
--- The coroutine `co_` holds persistent state in `co_.state` to remember progress across runs.
--- Keys in DATA.groundUnitsDB are unit names when available, otherwise numeric IDs/tostring fallbacks.
--- Updates DATA.groundGroupsDB to map groupName -> unit name list on each full pass.
--- Side-effects: Populates DATA.groundUnitsDB and DATA.groundGroupsDB; mutates coroutine state; may yield when configured.
--- @return AETHR.WORLD self
function AETHR.WORLD:updateGroundUnitsDB()
    self.UTILS:debugInfo("AETHR.WORLD:updateGroundUnitsDB -------------")
    local UTILS = self.UTILS
    local saveDivs = self.DATA.saveDivisions
    if not saveDivs or next(saveDivs) == nil then
        -- No active divisions: nothing to scan this tick
        return self
    end
    local groundDB = self.DATA.groundUnitsDB
    local co_ = self.BRAIN.DATA.coroutines.updateGroundUnitsDB
    local yieldThreshold = (co_ and co_.yieldThreshold) or 10
    local ObjectCategory = self.ENUMS.ObjectCategory

    -- Persistent state across coroutine runs; support running without a coroutine
    local state
    if co_ then
        co_.state = co_.state or { ids = nil, idx = 1 }
        state = co_.state
    else
        self._cache = self._cache or {}
        self._cache._groundUnitsDB_state = self._cache._groundUnitsDB_state or { ids = nil, idx = 1 }
        state = self._cache._groundUnitsDB_state
    end

    if not state.ids then
        state.ids = {}
        for divID, _ in pairs(saveDivs) do state.ids[#state.ids + 1] = divID end
        table.sort(state.ids, function(a, b) return a < b end)
        state.idx = 1
    end

    local divisionsPerRun = (self.CONFIG.MAIN.Background and self.CONFIG.MAIN.Background.divisionsPerRun) or 3
    local startIdx = state.idx
    local endIdx = math.min(startIdx + divisionsPerRun - 1, #state.ids)

    local processed = 0
    -- progress logging is rate-limited via UTILS:debugInfoRate; removed addedLogEvery

    local function maybeYield(inc)
        if co_ and co_.thread then
            co_.yieldCounter = (co_.yieldCounter or 0) + (inc or 1)
            if co_.yieldCounter >= yieldThreshold then
                co_.yieldCounter = 0
                UTILS:debugInfo("AETHR.WORLD:updateGroundUnitsDB --> YIELD")
                coroutine.yield()
            end
        end
    end

    -- Process a slice of divisions this run
    for i = startIdx, endIdx do
        local divID = state.ids[i]
        local div = saveDivs[divID]
        if div then
            local foundUnits = self:searchObjectsBox(
                ObjectCategory.UNIT,
                div.corners,
                div.height or 2000
            )
            for fuID, fuObj in pairs(foundUnits) do
                if not fuObj.AETHR then fuObj.AETHR = {} end
                fuObj.AETHR.spawned = fuObj.isActive
                fuObj.AETHR.divisionID = divID
                groundDB[fuID] = fuObj

                processed = processed + 1
                UTILS:debugInfoRate("AETHR.WORLD:updateGroundUnitsDB:progress", 2, { processed = processed })
                maybeYield(1)
            end
            -- light yield between divisions
            maybeYield(1)
        end
    end

    -- Advance index and, if we've completed a full pass, prune and rebuild groups
    state.idx = endIdx + 1
    if state.idx > #state.ids then
        local newGroups = {}
        for id, obj in pairs(groundDB) do
            if obj.isDead then
                if UTILS and type(UTILS.debugInfo) == "function" then
                    UTILS:debugInfo("AETHR.WORLD:updateGroundUnitsDB --> Removed dead unit " .. id)
                end
                groundDB[id] = nil
            else
                local gname = obj.groupName
                if gname and not newGroups[gname] then
                    newGroups[gname] = obj.groupUnitNames or {}
                end
            end
            maybeYield(1)
        end
        self.DATA.groundGroupsDB = newGroups

        -- Reset for next full cycle
        state.ids = nil
        state.idx = 1
    end

    return self
end

--- Callback invoked when an airbase changes ownership.
--- This function uses the signature (airbaseName, newOwner, zoneName, self) so it can be used as an event callback
--- where `self` is passed explicitly as the last argument.
--- @param airbaseName string Display name of the airbase
--- @param newOwner integer Coalition id (AETHR.ENUMS.Coalition)
--- @param zoneName string Name of the zone the airbase belongs to
--- @param self AETHR.WORLD The world instance (passed explicitly)
--- @return AETHR.WORLD self
function AETHR.WORLD.airbaseOwnershipChanged(airbaseName, newOwner, zoneName, self)
    local oldOwner = self.ZONE_MANAGER and
        self.ZONE_MANAGER.DATA.MIZ_ZONES[zoneName].Airbases[airbaseName].previousCoalition or
        self.AETHR.ZONE_MANAGER.DATA.MIZ_ZONES[zoneName].Airbases[airbaseName].previousCoalition
    local ENUM_RED = self.ENUMS.Coalition.RED
    local ENUM_BLUE = self.ENUMS.Coalition.BLUE
    local ENUM_CONTESTED = self.ENUMS.Coalition.CONTESTED

    -- Only announce if ownership actually changed
    if newOwner ~= oldOwner then
        local oldOwnerText = (oldOwner == ENUM_RED and "Red") or (oldOwner == ENUM_BLUE and "Blue") or
            (oldOwner == ENUM_CONTESTED and "Contested") or "Neutral"
        local newOwnerText = (newOwner == ENUM_RED and "Red") or (newOwner == ENUM_BLUE and "Blue") or
            (newOwner == ENUM_CONTESTED and "Contested") or "Neutral"


        self.UTILS:debugInfo("AETHR.WORLD.airbaseOwnershipChanged: " ..
            airbaseName .. " from " .. oldOwner .. " to " .. newOwner)

        local outText = newOwner == ENUM_CONTESTED and
            airbaseName .. " " .. self.ENUMS.TextStrings.contestedBy .. self.ENUMS.TextStrings.Teams.CONTESTED or
            airbaseName .. " " .. self.ENUMS.TextStrings.capturedBy .. self.ENUMS.TextStrings.Teams[
            (newOwner == ENUM_RED and "REDFOR") or (newOwner == ENUM_BLUE and "BLUFOR") or "NEUTRAL"]

        trigger.action.outText(outText, self.CONFIG.MAIN.outTextSettings.airbaseOwnershipChange.displayTime,
            self.CONFIG.MAIN.outTextSettings.airbaseOwnershipChange.clearView)
    end
    return self
end

--- Callback invoked when a zone changes ownership.
--- Signature: zoneOwnershipChanged(zoneName, newOwner, self)
--- @param zoneName string Zone display name
--- @param newOwner integer Coalition id (AETHR.ENUMS.Coalition)
--- @param self AETHR.WORLD The world instance (passed explicitly)
--- @return AETHR.WORLD self
function AETHR.WORLD.zoneOwnershipChanged(zoneName, newOwner, self)
    local oldOwner = self.ZONE_MANAGER and self.ZONE_MANAGER.DATA.MIZ_ZONES[zoneName].oldOwnedBy or
        self.AETHR.ZONE_MANAGER.DATA.MIZ_ZONES[zoneName].oldOwnedBy
    local ENUM_RED = self.ENUMS.Coalition.RED
    local ENUM_BLUE = self.ENUMS.Coalition.BLUE
    local ENUM_CONTESTED = self.ENUMS.Coalition.CONTESTED
    local ENUM_NEUTRAL = self.ENUMS.Coalition.NEUTRAL

    -- Only announce if ownership actually changed
    if newOwner ~= oldOwner then
        local oldOwnerText = (oldOwner == ENUM_RED and "Red") or (oldOwner == ENUM_BLUE and "Blue") or
            (oldOwner == ENUM_CONTESTED and "Contested") or "Neutral"
        local newOwnerText = (newOwner == ENUM_RED and "Red") or (newOwner == ENUM_BLUE and "Blue") or
            (newOwner == ENUM_CONTESTED and "Contested") or "Neutral"


        self.UTILS:debugInfo("AETHR.WORLD.zoneOwnershipChanged: " ..
            zoneName .. " from " .. oldOwner .. " to " .. newOwner)

        local outText
        if newOwner == ENUM_CONTESTED or newOwner == ENUM_NEUTRAL then
            outText = zoneName .. " " .. self.ENUMS.TextStrings.contestedBy .. self.ENUMS.TextStrings.Teams.CONTESTED
        else
            local teamKey = (newOwner == ENUM_RED and "REDFOR") or (newOwner == ENUM_BLUE and "BLUFOR") or "NEUTRAL"
            outText = zoneName .. " " .. self.ENUMS.TextStrings.capturedBy .. self.ENUMS.TextStrings.Teams[teamKey]
        end



        trigger.action.outText(outText, self.CONFIG.MAIN.outTextSettings.zoneOwnershipChange.displayTime,
            self.CONFIG.MAIN.outTextSettings.zoneOwnershipChange.clearView)
    end

    return self
end

--- Loads saved active divisions from storage.
--- @return table<number, _WorldDivision>|nil data Loaded saveDivisions or nil if none found
function AETHR.WORLD:loadActiveDivisions()
    local mapPath = self.CONFIG.MAIN.STORAGE.PATHS.MAP_FOLDER
    local saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.SAVE_DIVS_FILE
    local data = self.FILEOPS:loadData(mapPath, saveFile)
    if data then
        return data
    end
    return nil
end

--- Persists current active divisions to configured storage location.
--- Side-effects: Writes DATA.saveDivisions to CONFIG.MAIN.STORAGE.PATHS.MAP_FOLDER.
--- @return nil
function AETHR.WORLD:saveActiveDivisions()
    local mapPath = self.CONFIG.MAIN.STORAGE.PATHS.MAP_FOLDER
    local saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.SAVE_DIVS_FILE
    self.FILEOPS:saveData(mapPath, saveFile, self.DATA.saveDivisions)
end

--- Evaluates worldDivisions against zones to populate saveDivisions map.
--- Uses checkDivisionsInZones to compute active flags for each division.
--- Side-effects: Populates DATA.saveDivisions with active division entries.
--- @return AETHR.WORLD self
function AETHR.WORLD:generateActiveDivisions()
    -- Compute active flags by intersection
    local updated = self:checkDivisionsInZones(
        self.DATA.worldDivisions,
        self.ZONE_MANAGER.DATA.MIZ_ZONES
    )
    for _, div in pairs(updated) do
        if div.active then
            self.DATA.saveDivisions[div.ID] = div
        end
    end
    return self
end

--- Loads existing world divisions if available; otherwise generates and saves new divisions.
--- @return AETHR.WORLD self
function AETHR.WORLD:initActiveDivisions()
    -- Attempt to read existing config from file.
    local data = self:loadActiveDivisions()
    if data then
        self.DATA.saveDivisions = data
    else
        self:generateActiveDivisions()
        -- Persist defaults to disk.
        self:saveActiveDivisions()
    end
    return self
end

--- Loads world division definitions from config if present.
--- @return table<number, _WorldDivision>|nil data
function AETHR.WORLD:loadWorldDivisions()
    local data = self.FILEOPS:loadData(
        self.CONFIG.MAIN.STORAGE.PATHS.CONFIG_FOLDER,
        self.CONFIG.MAIN.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE
    )
    if data then
        return data
    end
    return nil
end

--- Saves world division definitions to config storage.
--- Side-effects: Writes DATA.worldDivisions to CONFIG.MAIN.STORAGE.PATHS.CONFIG_FOLDER.
--- @return nil
function AETHR.WORLD:saveWorldDivisions()
    --- Divs
    local ok = self.FILEOPS:saveData(
        self.CONFIG.MAIN.STORAGE.PATHS.CONFIG_FOLDER,
        self.CONFIG.MAIN.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE,
        self.DATA.worldDivisions
    )
    if not ok and self.CONFIG.MAIN.DEBUG_ENABLED then
        self.UTILS:debugInfo("AETHR.WORLD:saveWorldDivisions failed")
    end
end

--- Loads world division AABB from config if present.
--- @return table<number, { minX: number, maxX: number, minZ: number, maxZ: number }>|nil data
function AETHR.WORLD:loadWorldDivisionsAABB()
    local data = self.FILEOPS:loadData(
        self.CONFIG.MAIN.STORAGE.PATHS.CONFIG_FOLDER,
        self.CONFIG.MAIN.STORAGE.FILENAMES.WORLD_DIVISIONS_AABB
    )
    if data then
        return data
    end
    return nil
end

--- Saves world division AABB to config storage.
--- Side-effects: Writes DATA.worldDivAABB to CONFIG.MAIN.STORAGE.PATHS.CONFIG_FOLDER.
--- @return nil
function AETHR.WORLD:saveWorldDivisionsAABB()
    ---AABB
    local ok = self.FILEOPS:saveData(
        self.CONFIG.MAIN.STORAGE.PATHS.CONFIG_FOLDER,
        self.CONFIG.MAIN.STORAGE.FILENAMES.WORLD_DIVISIONS_AABB,
        self.DATA.worldDivAABB
    )
    if not ok and self.CONFIG.MAIN.DEBUG_ENABLED then
        self.UTILS:debugInfo("AETHR.WORLD:saveWorldDivisionsAABB failed")
    end
end

--- Generates world divisions from theater bounds and configured division area.
--- Each division will be a rectangle with .corners and an assigned numeric ID.
--- Side-effects: Populates DATA.worldDivisions with generated rectangles keyed by ID.
--- @return AETHR.WORLD self
function AETHR.WORLD:generateWorldDivisions()
    -- Generate new divisions based on theater bounds and division area
    local boundsPoly = self.POLY:convertBoundsToPolygon(
        self.CONFIG.MAIN.worldBounds[self.CONFIG.MAIN.THEATER]
    )
    local worldDivs = self.POLY:dividePolygon(
        boundsPoly,
        self.CONFIG.MAIN.worldDivisionArea
    )
    for i, div in ipairs(worldDivs) do
        div.ID = i         -- Assign unique ID
        div.active = false -- Initial active flag
        self.DATA.worldDivisions[i] = div
    end
    return self
end

--- Loads existing world divisions if available; otherwise generates and saves new divisions.
--- Side-effects: Reads/writes world division files, builds AABB cache when missing; mutates DATA.worldDivisions and DATA.worldDivAABB.
--- @return AETHR.WORLD self
function AETHR.WORLD:initWorldDivisions()
    -- Attempt to read existing config from file.
    local divData = self:loadWorldDivisions()
    if divData then
        self.DATA.worldDivisions = divData
    else
        self:generateWorldDivisions()
        -- Persist defaults to disk.
        self:saveWorldDivisions()
    end
    -- Attempt to load precomputed AABB data
    local aabbData = self:loadWorldDivisionsAABB()
    if aabbData then
        self.DATA.worldDivAABB = aabbData
    else
        -- Precompute static AABBs for all world divisions (used by SPAWNER placement fast paths)
        self:buildWorldDivAABBCache()
        self:saveWorldDivisionsAABB()
    end



    return self
end

--- Precompute and cache axis-aligned bounding boxes for all world divisions.
--- Stored in self.DATA.worldDivAABB[divID] = { minX, maxX, minZ, maxZ }
--- Called once from initWorldDivisions; divisions are static across the mission.
--- Side-effects: Populates DATA.worldDivAABB with per-division bounds.
--- @return AETHR.WORLD self
function AETHR.WORLD:buildWorldDivAABBCache()
    self.DATA.worldDivAABB = self.DATA.worldDivAABB or {}
    local cache = {}
    local divs = self.DATA.worldDivisions or {}

    for id, div in pairs(divs) do
        if div and div.corners then
            local minX, maxX = math.huge, -math.huge
            local minZ, maxZ = math.huge, -math.huge
            for _, c in ipairs(div.corners) do
                if c.x < minX then minX = c.x end
                if c.x > maxX then maxX = c.x end
                if c.z < minZ then minZ = c.z end
                if c.z > maxZ then maxZ = c.z end
            end
            cache[id] = { minX = minX, maxX = maxX, minZ = minZ, maxZ = maxZ }
        end
    end

    self.DATA.worldDivAABB = cache
    return self
end

--- @function AETHR.WORLD:initGrid
--- @brief Initializes grid metrics (origin and cell sizes) from division corners.
--- @param divs table<number, _WorldDivision>|_WorldDivision[] Array or map of division objects; each has a `.corners` array of points `{x, z}`.
--- @return _Grid Grid parameters:
---   * minX, minZ - grid origin coordinates
---   * dx, dz - width and height of each cell
---   * invDx, invDz - precomputed inverses for fast lookup
function AETHR.WORLD:initGrid(divs)
    -- Support either array-style or map-style Divisions.
    local firstDiv = (divs and divs[1]) or nil
    if not firstDiv then
        for _, v in pairs(divs or {}) do
            firstDiv = v
            break
        end
    end
    if not firstDiv then
        error("initGrid: no divisions supplied")
    end

    local c = firstDiv.corners or {}
    if not c or not c[1] then
        error("initGrid: division corners not available")
    end

    local minX = c[1].x or 0
    local minZ = c[1].z or 0
    local dx   = (c[2] and (c[2].x - c[1].x)) or 1
    local dz   = (c[4] and (c[4].z - c[1].z)) or 1

    local Grid = self.AETHR._Grid:New(c, minX, minZ, dx, dz)
    return Grid
end

--- @function AETHR.WORLD:buildZoneCellIndex
--- @brief Constructs a mapping of grid cells to zone entries for efficient spatial lookup.
--- @param Zones table<string, _MIZ_ZONE> Array or map of zone objects; each contains `.vertices` (or legacy `.verticies`) points `{x, y|z}`.
--- @param grid _Grid Grid metrics returned by `initGrid`.
--- @return table<number, table<number, _ZoneCellEntry[]>> cells Nested table `cells[col][row]` containing lists of zone entries.
function AETHR.WORLD:buildZoneCellIndex(Zones, grid)
    local cells = {}

    local function getY(v)
        if not v then return 0 end
        return (v.y ~= nil) and v.y or (v.z or 0)
    end

    -- Iterate each zone and compute its bounding cells.
    for _, zone in pairs(Zones or {}) do
        local zminX, zmaxX = math.huge, -math.huge
        local zminY, zmaxY = math.huge, -math.huge

        -- Compute raw bounding box in world coordinates using flexible Y/Z access.
        for _, v in ipairs(zone.vertices or {}) do
            local vy = getY(v)
            zminX = math.min(zminX, v.x or zminX)
            zmaxX = math.max(zmaxX, v.x or zmaxX)
            zminY = math.min(zminY, vy)
            zmaxY = math.max(zmaxY, vy)
        end

        -- If zone had no valid points, skip processing this zone (Lua 5.1 does not support goto/labels).
        if not (zminX == math.huge or zminY == math.huge) then
            -- Convert world extremes to grid indices.
            local col0 = math.floor((zminX - grid.minX) * grid.invDx) + 1
            local col1 = math.floor((zmaxX - grid.minX) * grid.invDx) + 1
            local row0 = math.floor((zminY - grid.minZ) * grid.invDz) + 1
            local row1 = math.floor((zmaxY - grid.minZ) * grid.invDz) + 1

            -- Prepare polygon for intersection tests.
            local poly = {}
            for _, v in ipairs(zone.vertices or {}) do
                table.insert(poly, { x = v.x or 0, y = getY(v) })
            end

            local entry = {
                bbox = { minx = zminX, maxx = zmaxX, miny = zminY, maxy = zmaxY },
                poly = poly,
            }

            -- Assign entry into each grid cell it overlaps.
            for col = col0, col1 do
                cells[col] = cells[col] or {}
                for row = row0, row1 do
                    cells[col][row] = cells[col][row] or {}
                    table.insert(cells[col][row], entry)
                end
            end
        end
    end

    return cells
end

--- @function AETHR.WORLD:checkDivisionsInZones
--- @brief Flags divisions as active if they spatially intersect any zone.
--- @param Divisions table<number, _WorldDivision>|_WorldDivision[] Array (or map) of divisions with `.corners` points.
--- @param Zones table<string, _MIZ_ZONE> Zones keyed by name used to construct the zone cell index.
--- @return table<number, _WorldDivision> Updated Divisions map/array with `.active` flags.
function AETHR.WORLD:checkDivisionsInZones(Divisions, Zones)
    -- Initialize grid and compute zone cell index.
    local grid      = self:initGrid(Divisions)
    local zoneCells = self:buildZoneCellIndex(Zones, grid)

    -- Iterate through each division to determine activity.
    for _, div in pairs(Divisions) do
        -- Compute centroid for grid lookup.
        local sx, sz = 0, 0
        for _, v in ipairs(div.corners) do
            sx, sz = sx + v.x, sz + v.z
        end
        local cx, cz = sx / #div.corners, sz / #div.corners

        -- Convert centroid to cell index.
        local col = math.floor((cx - grid.minX) * grid.invDx) + 1
        local row = math.floor((cz - grid.minZ) * grid.invDz) + 1

        -- Build division polygon and bounding box.
        local dminx, dmaxx = math.huge, -math.huge
        local dminz, dmaxz = math.huge, -math.huge
        local divPoly = {}
        for _, v in ipairs(div.corners) do
            divPoly[#divPoly + 1] = { x = v.x, y = v.z }
            dminx, dmaxx = math.min(dminx, v.x), math.max(dmaxx, v.x)
            dminz, dmaxz = math.min(dminz, v.z), math.max(dmaxz, v.z)
        end
        local divBBox = { minx = dminx, maxx = dmaxx, miny = dminz, maxy = dmaxz }

        div.active = false
        local candidates = (zoneCells[col] or {})[row] or {}

        -- Test each candidate zone for detailed overlap.
        for _, entry in ipairs(candidates) do
            local bz = entry.bbox
            -- Quick bounding-box check.
            if not (divBBox.maxx < bz.minx or divBBox.minx > bz.maxx
                    or divBBox.maxy < bz.miny or divBBox.miny > bz.maxy) then
                -- Polygon overlap test.
                if self.POLY:polygonsOverlap(divPoly, entry.poly) then
                    div.active = true
                    break
                end
            end
        end
    end

    return Divisions
end

--- Retrieves objects of a specific category within a division.
--- @param divisionID integer ID of the division
--- @param objectCategory integer Category filter (AETHR.ENUMS.ObjectCategory)
--- @return table<string|number, _FoundObject> found Found objects keyed by unit name when available, otherwise numeric engine ID
function AETHR.WORLD:objectsInDivision(divisionID, objectCategory)
    local div = self.DATA.worldDivisions[divisionID]
    if not div then return {} end
    return self:searchObjectsBox(objectCategory, div.corners, div.height or 2000)
end

--- Internal helper to initialize objects for any category across active divisions.
--- Reduces duplication across initSceneryInDivisions, initBaseInDivisions, initStaticInDivisions.
--- Side-effects: Reads existing per-division object files; may write discovered objects; populates DATA[targetField][divisionID].
--- @param objectCategory integer Category id (AETHR.ENUMS.ObjectCategory)
--- @param filename string Save file basename
--- @param targetField "divisionSceneryObjects"|"divisionStaticObjects"|"divisionBaseObjects"
--- @return AETHR.WORLD self
function AETHR.WORLD:_initObjectsInDivisions(objectCategory, filename, targetField)
    local storage = self.CONFIG.MAIN.STORAGE
    local root = storage.PATHS.OBJECTS_FOLDER
    local saveDivs = self.DATA.saveDivisions

    -- Ensure target container exists
    self.DATA[targetField] = self.DATA[targetField] or {}

    for id, _ in pairs(saveDivs) do
        local dir = root .. "/" .. id
        local file = objectCategory .. "_" .. filename
        local objs = self.FILEOPS:loadData(dir, file)

        if not objs then
            objs = self:objectsInDivision(id, objectCategory)
            if next(objs) then
                self.FILEOPS:saveData(dir, file, objs)
            end
        end

        -- Always assign a table (prevents nil lookups later)
        self.DATA[targetField][id] = objs or {}
    end

    return self
end

--- Initialize scenery objects cache for active divisions.
--- @return AETHR.WORLD self
function AETHR.WORLD:initSceneryInDivisions()
    return self:_initObjectsInDivisions(
        self.AETHR.ENUMS.ObjectCategory.SCENERY,
        self.CONFIG.MAIN.STORAGE.FILENAMES.SCENERY_OBJECTS_FILE,
        "divisionSceneryObjects"
    )
end

--- Initialize base objects cache for active divisions.
--- @return AETHR.WORLD self
function AETHR.WORLD:initBaseInDivisions()
    return self:_initObjectsInDivisions(
        self.AETHR.ENUMS.ObjectCategory.BASE,
        self.CONFIG.MAIN.STORAGE.FILENAMES.BASE_OBJECTS_FILE,
        "divisionBaseObjects"
    )
end

--- Initialize static objects cache for active divisions.
--- @return AETHR.WORLD self
function AETHR.WORLD:initStaticInDivisions()
    return self:_initObjectsInDivisions(
        self.AETHR.ENUMS.ObjectCategory.STATIC,
        self.CONFIG.MAIN.STORAGE.FILENAMES.STATIC_OBJECTS_FILE,
        "divisionStaticObjects"
    )
end

function AETHR.WORLD:determineTowns()
    local buildingPoints = {}
   -- local test = {}
    for div, buildingObjects in pairs(self.DATA.divisionSceneryObjects) do
        for buildObjID, buildObj in pairs(buildingObjects) do
            local desc = buildObj.desc or nil
            local attributes = desc and desc.attributes or nil
            local isBuilding = attributes and attributes.Buildings or nil
            if isBuilding then
                if not self.ENUMS.restrictedTownTypes[desc.typeName] then
                    --test[desc.typeName] = desc.typeName
                    buildingPoints[#buildingPoints + 1] = {
                        x = buildObj.position.x,
                        y = buildObj.position.z
                    }
                end
            end
        end
    end
    for div, buildingObjects in pairs(self.DATA.divisionBaseObjects) do
        for buildObjID, buildObj in pairs(buildingObjects) do
            local desc = buildObj.desc or nil
            local attributes = desc and desc.attributes or nil
            local isBuilding = attributes and attributes.Buildings or nil
            if isBuilding then
                if not self.ENUMS.restrictedTownTypes[desc.typeName] then
               --     test[desc.typeName] = desc.typeName
                    buildingPoints[#buildingPoints + 1] = {
                        x = buildObj.position.x,
                        y = buildObj.position.z
                    }
                end
            end
        end
    end
    local area = 0 
    
    ---@param div _WorldDivision
    for divID, div in pairs(self.DATA.saveDivisions) do
        area = area + self.POLY:polygonArea(div.corners)
    end
    

    --self.POLY:polygonArea(self.ZONE_MANAGER.DATA.GAME_BOUNDS.inBounds.polyVerts)
    local clusters = self.AI:clusterPoints(buildingPoints, area)
    self.DATA.townClusterDB = clusters

    return self
end

--- Loads existing world divisions if available; otherwise generates and saves new divisions.
--- Side-effects: Reads/writes world division files, builds AABB cache when missing; mutates DATA.worldDivisions and DATA.worldDivAABB.
--- @return AETHR.WORLD self
function AETHR.WORLD:initTowns()
    -- Attempt to read existing config from file.
    local divData = self:loadTowns()
    if divData then
        self.DATA.townClusterDB = divData
    else
        self:determineTowns()
        -- Persist defaults to disk.
        self:saveTowns()
    end
    return self
end


--- Loads world division definitions from config if present.
--- @return _dbCluster[]|nil data
function AETHR.WORLD:loadTowns()
    local data = self.FILEOPS:loadData(
        self.CONFIG.MAIN.STORAGE.PATHS.LEARNING_FOLDER,
        self.CONFIG.MAIN.STORAGE.FILENAMES.TOWN_CLUSTERS_FILE
    )
    if data then
        return data
    end
    return nil
end

--- Saves world division definitions to config storage.
--- Side-effects: Writes DATA.worldDivisions to CONFIG.MAIN.STORAGE.PATHS.CONFIG_FOLDER.
--- @return nil
function AETHR.WORLD:saveTowns()
    --- Divs
    local ok = self.FILEOPS:saveData(
        self.CONFIG.MAIN.STORAGE.PATHS.LEARNING_FOLDER,
        self.CONFIG.MAIN.STORAGE.FILENAMES.TOWN_CLUSTERS_FILE,
        self.DATA.townClusterDB
    )
    if not ok and self.CONFIG.MAIN.DEBUG_ENABLED then
        self.UTILS:debugInfo("AETHR.WORLD:saveTowns failed")
    end
end