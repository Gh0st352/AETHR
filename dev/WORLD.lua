--- @class AETHR.WORLD
--- @brief Manages mission trigger zones and computes bordering relationships.
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field UTILS AETHR.UTILS Utility functions submodule attached per-instance.
--- @field BRAIN AETHR.BRAIN
--- @field ENUMS AETHR.ENUMS Enumeration constants submodule attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field DATA AETHR.WORLD.Data Container for zone management data.
--- @field AIRBASES table<string, _airbase>                       Airbase descriptors keyed by displayName
--- @field worldDivisions table<number, _WorldDivision>          Grid division definitions keyed by ID
--- @field saveDivisions table<number, _WorldDivision>           Active divisions keyed by ID
--- @field divisionSceneryObjects table<number, table<number, _FoundObject>>  DivisionID -> (objectID -> _FoundObject)
--- @field divisionStaticObjects table<number, table<number, _FoundObject>>
--- @field divisionBaseObjects table<number, table<number, _FoundObject>>
AETHR.WORLD = {} ---@diagnostic disable-line


---@class AETHR.WORLD.Data
--- @field AIRBASES table<string, _airbase>                       Airbase descriptors keyed by displayName
--- @field worldDivisions table<number, _WorldDivision>          Grid division definitions keyed by ID
--- @field saveDivisions table<number, _WorldDivision>           Active divisions keyed by ID
--- @field divisionSceneryObjects table<integer, table<integer, _FoundObject>>  DivisionID -> (objectID -> _FoundObject)
--- @field divisionStaticObjects table<integer, table<integer, _FoundObject>>
--- @field divisionBaseObjects table<integer, table<integer, _FoundObject>>
AETHR.WORLD.DATA = {
    AIRBASES               = {}, -- Airbase descriptors keyed by displayName.
    worldDivisions         = {}, -- Grid division definitions keyed by ID.
    saveDivisions          = {}, -- Active divisions keyed by ID.
    divisionSceneryObjects = {}, -- Loaded scenery per division.
    divisionStaticObjects  = {}, -- Loaded statics per division.
    divisionBaseObjects    = {}, -- Loaded Base per division.
}


--- @param parent AETHR
--- @return AETHR.WORLD
function AETHR.WORLD:New(parent)
    local instance = {
        AETHR = parent,
        -- submodule-local caches/state can be initialized here
        _cache = {},
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- @function AETHR.WORLD:markWorldDivisions
--- @brief Displays active world divisions on the map with randomized colors.
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
        trigger.action.markupToAll(
            shapeTypeID, coalition, shapeID,
            vec3_1,
            vec3_2,
            vec3_3,
            vec3_4,
            { r, g, b, alpha1 },                   -- Fill color
            { r + 0.2, g + 0.4, b + 0.8, alpha2 }, -- Border color
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
--- @param corners _vec2xz[] Array of base corner points (x,z)
--- @param height number Height of the search volume in meters
--- @return table<number, _FoundObject> found Found objects keyed by object ID
function AETHR.WORLD:searchObjectsBox(objectCategory, corners, height)
    -- Compute box extents
    local box = self.POLY:getBoxPoints(corners, height) ---@diagnostic disable-line
    local vol = self.POLY:createBox(box.min, box.max)
    local found = {} ---@type table<number, _FoundObject>

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

--- Retrieves all airbases in the world and stores their data.
--- @return AETHR.WORLD self
function AETHR.WORLD:getAirbases()
    local bases = world.getAirbases() -- Array of airbase objects
    for _, ab in ipairs(bases) do
        local desc = ab:getDesc()
        local pos = ab:getPosition().p
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
                        zone.verticies
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
            desc.categoryText, data.coalition, ---@diagnostic disable-line
            desc.coalition -- previousCoalition
        )

        if self.UTILS.sumTable(data.zoneObject) >= 1 then
            data.zoneObject.Airbases[desc.displayName] = _airbase
        end
        self.DATA.AIRBASES[desc.displayName] = _airbase
    end
    return self
end

function AETHR.WORLD:updateAirbaseOwnership()
    self.UTILS:debugInfo("AETHR.WORLD:updateAirbaseOwnership -------------")
    local _zones = self.ZONE_MANAGER.DATA.MIZ_ZONES
    local co_ = self.BRAIN.DATA.coroutines.updateAirfieldOwnership


    for zName, zObj in pairs(_zones) do
        for abName, abObj in pairs(zObj.Airbases) do
            local updatedABObj = Airbase.getByName(abName)
            local updatedABObjCoalition = updatedABObj:getCoalition()

            if abObj.coalition ~= updatedABObjCoalition then
                abObj.previousCoalition = abObj.coalition
                abObj.coalition = updatedABObjCoalition
            end

            if co_.thread then
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
            local _LineColors = self.CONFIG.MAIN.Zone.paintColors.LineColors[ownedBy]
            local _FillColors = self.CONFIG.MAIN.Zone.paintColors.FillColors[ownedBy]
            local lineColor = {
                _LineColors.r, _LineColors.g, _LineColors.b, self.CONFIG.MAIN.Zone.paintColors.LineAlpha
            }
            local fillColor = {
                _FillColors.r, _FillColors.g, _FillColors.b, self.CONFIG.MAIN.Zone.paintColors.FillAlpha
            }

            self.UTILS:updateMarkupColors(zObj.markerObject.markID, lineColor, fillColor)
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

function AETHR.WORLD:updateZoneArrows()
    self.UTILS:debugInfo("AETHR.WORLD:updateZoneArrows -------------")
    local _zones = self.ZONE_MANAGER.DATA.MIZ_ZONES
    local co_ = self.BRAIN.DATA.coroutines.updateZoneArrows
    for zName, zObj in pairs(_zones) do
        local ownedBy = zObj.ownedBy
        for bzName, bzObj in pairs(zObj.BorderingZones) do
            local borderCoalition = _zones[bzName] and _zones[bzName].ownedBy
            if borderCoalition ~= currentCoalition then
            for _, borderDetail in ipairs(bzObj) do
                for currentCoalition = 0, 2 do


                    local lineColor = {
                        r = self.CONFIG.MAIN.Zone.paintColors.ArrowColors[currentCoalition].r,
                        g = self.CONFIG.MAIN.Zone.paintColors.ArrowColors[currentCoalition].g,
                        b = self.CONFIG.MAIN.Zone.paintColors.ArrowColors[currentCoalition].b,
                        a = self.CONFIG.MAIN.Zone.paintColors.ArrowColors[currentCoalition].a
                    }
                    local fillColor = {
                        r = self.CONFIG.MAIN.Zone.paintColors.ArrowColors[currentCoalition].r,
                        g = self.CONFIG.MAIN.Zone.paintColors.ArrowColors[currentCoalition].g,
                        b = self.CONFIG.MAIN.Zone.paintColors.ArrowColors[currentCoalition].b,
                        a = self.CONFIG.MAIN.Zone.paintColors.ArrowColors[currentCoalition].a
                    }
                    if borderCoalition == currentCoalition then
                        lineColor.a = 0
                        fillColor.a = 0
                    end
                    if ownedBy ~= currentCoalition then
                        lineColor.a = 0
                        fillColor.a = 0
                    end


                    self.UTILS:updateMarkupColors(borderDetail.MarkID[currentCoalition],
                        { lineColor.r, lineColor.g, lineColor.b, lineColor.a },
                        { fillColor.r, fillColor.g, fillColor.b, fillColor.a })
                    --lineColor, fillColor)

                    if co_.thread then
                        co_.yieldCounter = co_.yieldCounter + 1
                        if co_.yieldCounter >= co_.yieldThreshold then
                            co_.yieldCounter = 0
                            self.UTILS:debugInfo("AETHR.WORLD:updateZoneArrows --> YIELD")
                            coroutine.yield()
                        end
                    end
                end
            end
            en
        end
    end
    return self
end

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

        local outText = newOwner == ENUM_CONTESTED or
            newOwner == ENUM_NEUTRAL and
            zoneName .. " " .. self.ENUMS.TextStrings.contestedBy .. self.ENUMS.TextStrings.Teams.CONTESTED or
            zoneName .. " " .. self.ENUMS.TextStrings.capturedBy .. self.ENUMS.TextStrings.Teams[
            (newOwner == ENUM_RED and "REDFOR") or (newOwner == ENUM_BLUE and "BLUFOR") or "NEUTRAL"]



        trigger.action.outText(outText, self.CONFIG.MAIN.outTextSettings.zoneOwnershipChange.displayTime,
            self.CONFIG.MAIN.outTextSettings.zoneOwnershipChange.clearView)
    end

    return self
end

--- Loads saved active divisions from storage.
--- @return table<number, _WorldDivision>|nil data
function AETHR.WORLD:loadActiveDivisions()
    local mapPath = self.CONFIG.MAIN.STORAGE.PATHS.MAP_FOLDER
    local saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.SAVE_DIVS_FILE
    local data = self.FILEOPS:loadData(mapPath, saveFile)
    if data then
        return data
    end
    return nil
end

--- Persists current active divisions to storage.
--- @return nil
function AETHR.WORLD:saveActiveDivisions()
    local mapPath = self.CONFIG.MAIN.STORAGE.PATHS.MAP_FOLDER
    local saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.SAVE_DIVS_FILE
    self.FILEOPS:saveData(mapPath, saveFile, self.DATA.saveDivisions)
end

--- Evaluates worldDivisions against zones to populate saveDivisions map.
--- @return AETHR.WORLD self
function AETHR.WORLD:generateActiveDivisions()
    -- Compute active flags by intersection
    local updated = self:checkDivisionsInZones(
        self.DATA.worldDivisions,
        self.ZONE_MANAGER.DATA.MIZ_ZONES
    )
    for _, div in ipairs(updated) do
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
--- @return nil
function AETHR.WORLD:saveWorldDivisions()
    self.FILEOPS:saveData(
        self.CONFIG.MAIN.STORAGE.PATHS.CONFIG_FOLDER,
        self.CONFIG.MAIN.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE,
        self.DATA.worldDivisions
    )
end

--- Generates world divisions from theater bounds and configured division area.
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
--- @return AETHR.WORLD self
function AETHR.WORLD:initWorldDivisions()
    -- Attempt to read existing config from file.
    local data = self:loadWorldDivisions()
    if data then
        self.DATA.worldDivisions = data
    else
        self:generateWorldDivisions()
        -- Persist defaults to disk.
        self:saveWorldDivisions()
    end
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
    local maxZ = c[1].z or 0
    local dx   = (c[2] and (c[2].x - c[1].x)) or 1
    local dz   = (c[4] and (c[4].z - c[1].z)) or 1

    local Grid = self.AETHR._Grid:New(c, minX, maxZ, dx, dz)
    return Grid
end

--- @function AETHR.WORLD:buildZoneCellIndex
--- @brief Constructs a mapping of grid cells to zone entries for efficient spatial lookup.
--- @param Zones table<string, _MIZ_ZONE> Array or map of zone objects; each contains `.verticies` points `{x, y|z}`.
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
        for _, v in ipairs(zone.verticies or {}) do
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
            for _, v in ipairs(zone.verticies or {}) do
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
    for _, div in ipairs(Divisions) do
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
--- @return table<number, _FoundObject> found Found objects keyed by object ID
function AETHR.WORLD:objectsInDivision(divisionID, objectCategory)
    local div = self.DATA.worldDivisions[divisionID]
    if not div then return {} end
    return self:searchObjectsBox(objectCategory, div.corners, div.height or 2000)
end

--- Internal helper to initialize objects for any category across active divisions.
--- Reduces duplication across initSceneryInDivisions, initBaseInDivisions, initStaticInDivisions.
---@param objectCategory integer Category id (AETHR.ENUMS.ObjectCategory)
---@param filename string Save file basename
---@param targetField "divisionSceneryObjects"|"divisionStaticObjects"|"divisionBaseObjects"
---@return AETHR.WORLD self
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

--- @return AETHR.WORLD self
function AETHR.WORLD:initSceneryInDivisions()
    return self:_initObjectsInDivisions(
        self.AETHR.ENUMS.ObjectCategory.SCENERY,
        self.CONFIG.MAIN.STORAGE.FILENAMES.SCENERY_OBJECTS_FILE,
        "divisionSceneryObjects"
    )
end

--- @return AETHR.WORLD self
function AETHR.WORLD:initBaseInDivisions()
    return self:_initObjectsInDivisions(
        self.AETHR.ENUMS.ObjectCategory.BASE,
        self.CONFIG.MAIN.STORAGE.FILENAMES.BASE_OBJECTS_FILE,
        "divisionBaseObjects"
    )
end

--- @return AETHR.WORLD self
function AETHR.WORLD:initStaticInDivisions()
    return self:_initObjectsInDivisions(
        self.AETHR.ENUMS.ObjectCategory.STATIC,
        self.CONFIG.MAIN.STORAGE.FILENAMES.STATIC_OBJECTS_FILE,
        "divisionStaticObjects"
    )
end
