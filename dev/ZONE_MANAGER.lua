--- @class AETHR.ZONE_MANAGER
--- @brief Manages mission trigger zones and computes bordering relationships.
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field SPAWNER AETHR.SPAWNER Spawner submodule attached per-instance.
--- @field UTILS AETHR.UTILS Utility helper table attached per-instance.
--- @field BRAIN AETHR.BRAIN Brain submodule attached per-instance.
--- @field MATH AETHR.MATH Math helper table attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field ENUMS AETHR.ENUMS ENUMS submodule attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field MARKERS AETHR.MARKERS Markers helper submodule attached per-instance.
--- @field DATA table Container for zone management data.
--- @field DATA.MIZ_ZONES table<string, _MIZ_ZONE> Loaded mission trigger zones.
--- @field DATA.GAME_BOUNDS _GameBounds In/out-of-bounds and gap polygons computed from mission zones.
AETHR.ZONE_MANAGER = {} ---@diagnostic disable-line

--- Container for zone management data.
AETHR.ZONE_MANAGER.DATA = {
    --- @type table<string, _MIZ_ZONE>
    MIZ_ZONES = {}, -- Mission trigger zones keyed by name.
    GAME_BOUNDS = {
        outOfBounds = {
            HullPolysNoSample = {},   -- _PolygonList
            HullPolysWithSample = {}, -- _PolygonList
            centerPoly = {},          -- _PolygonVec2
            masterPoly = {},          -- _PolygonVec2
        },
        inBounds = {
            polyLines = {}, -- _LineVec2[]
            polyVerts = {}, -- _PolygonVec2
        },
        inOutBoundsGaps = {
            overlaid = {}, -- _PolygonList
            convex = {},   -- _PolygonList
            concave = {},  -- _PolygonList
        },
    },
}

--- Normalize loaded MIZ_ZONES to unified field names and recompute derived fields when missing.
--- Converts:
---   - verticies -> vertices
---   - activeDivsions -> activeDivisions
--- Recomputes LinesVec2 when absent.
--- @function AETHR.ZONE_MANAGER:_normalizeMizZones
--- @param zones table<string, _MIZ_ZONE>|nil Table of zones to normalize
--- @return boolean changed True if any fields were modified or recomputed
function AETHR.ZONE_MANAGER:_normalizeMizZones(zones)
    local changed = false
    for name, z in pairs(zones or {}) do
        if z.verticies and not z.vertices then
            z.vertices = z.verticies
            z.verticies = nil
            changed = true
        end
        if z.activeDivsions and not z.activeDivisions then
            z.activeDivisions = z.activeDivsions
            z.activeDivsions = nil
            changed = true
        end
        if (not z.LinesVec2 or #z.LinesVec2 == 0) and z.vertices and self.POLY and self.POLY.convertPolygonToLines then
            z.LinesVec2 = self.POLY:convertPolygonToLines(z.vertices)
        end
    end
    return changed
end

--- Creates a new AETHR.ZONE_MANAGER submodule instance.
--- @function AETHR.ZONE_MANAGER:New
--- @param parent AETHR Parent AETHR instance
--- @return AETHR.ZONE_MANAGER instance New instance inheriting AETHR.ZONE_MANAGER methods.
function AETHR.ZONE_MANAGER:New(parent)
    local instance = {
        AETHR = parent,
        -- submodule-local caches/state can be initialized here
        _cache = {},
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- Sets mission trigger zone names (all, red and blue start).
--- @function AETHR.ZONE_MANAGER:setMizZones
--- @param zoneNames string[] List of all mission trigger zone names.
--- @param RedStartZones string[]|nil Optional list of Red start mission trigger zones.
--- @param BlueStartZones string[]|nil Optional list of Blue start mission trigger zones.
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:setMizZones(zoneNames, RedStartZones, BlueStartZones)
    if not self.CONFIG.MAIN.MIZ_ZONES then self.CONFIG.MAIN.MIZ_ZONES = { ALL = {}, REDSTART = {}, BLUESTART = {} } end
    self.CONFIG.MAIN.MIZ_ZONES.ALL = zoneNames or {}
    if RedStartZones then self:setRedStartMizZones(RedStartZones) end
    if BlueStartZones then self:setBlueStartMizZones(BlueStartZones) end
    return self
end

--- Sets Red start mission trigger zones.
--- @function AETHR.ZONE_MANAGER:setRedStartMizZones
--- @param zoneNames string[] List of Red start mission trigger zone names.
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:setRedStartMizZones(zoneNames)
    self.CONFIG.MAIN.MIZ_ZONES.REDSTART = zoneNames or {}
    return self
end

--- Sets Blue start mission trigger zones.
--- @function AETHR.ZONE_MANAGER:setBlueStartMizZones
--- @param zoneNames string[] List of Blue start mission trigger zone names.
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:setBlueStartMizZones(zoneNames)
    self.CONFIG.MAIN.MIZ_ZONES.BLUESTART = zoneNames or {}
    return self
end

--- Initializes mission trigger zone data, loading existing or generating defaults.
--- @function AETHR.ZONE_MANAGER:initMizZoneData
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:initMizZoneData()
    local data = self:getStoredMizZoneData()
    if data then
        self.DATA.MIZ_ZONES = data
        local changed = self:_normalizeMizZones(self.DATA.MIZ_ZONES)
        if changed then
            self:saveMizZoneData()
        end
    else
        self:generateMizZoneData()
        self.WORLD:getAirbases() -- Collect airbase data.
        self:saveMizZoneData()
    end
    return self
end

--- Loads mission trigger zone data from storage file if available.
--- @function AETHR.ZONE_MANAGER:getStoredMizZoneData
--- @return table<string, _MIZ_ZONE>|nil Data table of mission trigger zones or nil if not found.
function AETHR.ZONE_MANAGER:getStoredMizZoneData()
    local mapPath = self.CONFIG.MAIN.STORAGE.PATHS.MAP_FOLDER
    local saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.MIZ_ZONES_FILE
    local data = self.FILEOPS:loadData(mapPath, saveFile)
    if data then return data end
    return nil
end

--- Saves current mission trigger zone data to storage file.
--- @function AETHR.ZONE_MANAGER:saveMizZoneData
--- @return nil
function AETHR.ZONE_MANAGER:saveMizZoneData()
    local mapPath = self.CONFIG.MAIN.STORAGE.PATHS.MAP_FOLDER
    local saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.MIZ_ZONES_FILE
    self.FILEOPS:saveData(mapPath, saveFile, self.DATA.MIZ_ZONES)
end

--- Determines active world divisions for each zone by polygon overlap and stores them on zone.activeDivisions.
--- @function AETHR.ZONE_MANAGER:pairActiveDivisions
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:pairActiveDivisions()
    local globalActiveDivisions = self.WORLD.DATA.saveDivisions
    ---@param zone _MIZ_ZONE
    for zoneName, zone in pairs(self.DATA.MIZ_ZONES) do
        local divsInZone = {}
        local zoneVerts = zone.vertices
        ---@param div _WorldDivision
        for divID, div in pairs(globalActiveDivisions) do
            local divVerts = div.corners
            if self.POLY:polygonsOverlap(zoneVerts, divVerts) then
                divsInZone[divID] = div
            end
        end
        zone.activeDivisions = divsInZone
    end
    return self
end

--- Determines towns contained within each zone (cluster center inside polygon) and stores them on zone.townsDB.
--- @function AETHR.ZONE_MANAGER:pairTowns
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:pairTowns()
    local townClusters = self.WORLD.DATA.townClusterDB
    ---@param zone _MIZ_ZONE
    for zoneName, zone in pairs(self.DATA.MIZ_ZONES) do
        local townsInZone = {}
        local zoneVerts = zone.vertices
        ---@param cluster _dbCluster
        for ID, cluster in pairs(townClusters) do
            local clusterCenter = cluster.Center
            if self.POLY:pointInPolygon(clusterCenter, zoneVerts) then
                townsInZone[ID] = cluster
            end
        end
        zone.townsDB = townsInZone
    end
    return self
end

--- Generates mission trigger zone data based on configured zone names and environment data.
--- Guards against missing env structures and missing constructors.
--- @function AETHR.ZONE_MANAGER:generateMizZoneData
--- @param allZoneNames string[]|nil Optional list of zone names to generate (defaults to config list)
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:generateMizZoneData(allZoneNames)
    local zoneNames = allZoneNames or self.CONFIG.MAIN.MIZ_ZONES.ALL
    if not zoneNames or #zoneNames == 0 then
        return self
    end

    local envZones = {}
    if env.mission.triggers.zones then envZones = env.mission.triggers.zones end

    local mzCtor = self.AETHR._MIZ_ZONE or AETHR._MIZ_ZONE
    for _, zoneName in ipairs(zoneNames) do
        for _, envZone in ipairs(envZones) do
            if envZone and envZone.name == zoneName then
                self.DATA.MIZ_ZONES[zoneName] = mzCtor:New(envZone, self.AETHR)
                break
            end
        end
    end
    self.DATA.MIZ_ZONES = self:determineBorderingZones(self.DATA.MIZ_ZONES)
    return self
end

--- Determine bordering zones.
--- Compares every pair of zones and populates BorderingZones for each zone with arrays of _BorderInfo objects.
--- @function AETHR.ZONE_MANAGER:determineBorderingZones
--- @param MIZ_ZONES table<string, _MIZ_ZONE> Map of mission trigger zones.
--- @return table<string, _MIZ_ZONE> Updated MIZ_ZONES with .BorderingZones populated.
function AETHR.ZONE_MANAGER:determineBorderingZones(MIZ_ZONES)
    --- @type AETHR.POLY
    local POLY = self.POLY
    for zoneName1, zone1 in pairs(MIZ_ZONES) do
        for zoneName2, zone2 in pairs(MIZ_ZONES) do
            -- Ensure we're not comparing a zone with itself
            if zoneName1 ~= zoneName2 then
                local borderIndex = 0 -- Initialize index for potential borders

                -- Ensure BorderingZones tables exist
                MIZ_ZONES[zoneName1].BorderingZones = MIZ_ZONES[zoneName1].BorderingZones or {}

                -- Compare borders of zone1 with zone2
                for _, lineA in ipairs(zone1.LinesVec2) do
                    for _, lineB in ipairs(zone2.LinesVec2) do
                        -- Check if two lines are close enough to be considered bordering
                        if self.POLY:isWithinOffset(lineA, lineB, zone1.BorderOffsetThreshold) then
                            borderIndex = borderIndex + 1 -- Increment the index for borders found

                            -- Initialize border data structure if it doesn't exist
                            local zoneBorder = MIZ_ZONES[zoneName1].BorderingZones[zoneName2] or {}
                            zoneBorder[borderIndex] = zoneBorder[borderIndex] or {}

                            -- Populate border details
                            zoneBorder[borderIndex] = self.AETHR._BorderInfo:New()
                            local currentBorder = zoneBorder[borderIndex]
                            currentBorder.OwnedByCoalition = 0
                            currentBorder.ZoneLine = lineA
                            currentBorder.ZoneLineLen = POLY:lineLength(lineA)
                            currentBorder.ZoneLineMidP = POLY:getMidpoint(lineA)
                            currentBorder.ZoneLineSlope = POLY:calculateLineSlope(lineA)
                            currentBorder.ZoneLinePerpendicularPoint = {}
                            currentBorder.NeighborLine = lineB
                            currentBorder.NeighborLineLen = POLY:lineLength(lineB)
                            currentBorder.NeighborLineMidP = POLY:getMidpoint(lineB)
                            currentBorder.NeighborLineSlope = POLY:calculateLineSlope(lineB)
                            currentBorder.NeighborLinePerpendicularPoint = {}
                            currentBorder.MarkID = {
                                [0] = 0,
                                [1] = 0,
                                [2] = 0,
                            }

                            -- Determine the perpendicular points and update them
                            local ArrowMP, line_, NeighborLine_, length_, NeighborLength_
                            if currentBorder.ZoneLineLen <= currentBorder.NeighborLineLen then
                                ArrowMP = currentBorder.ZoneLineMidP
                                line_ = currentBorder.ZoneLine
                                NeighborLine_ = { [1] = line_[2], [2] = line_[1] }
                                length_ = MIZ_ZONES[zoneName1].ArrowLength
                                NeighborLength_ = -(length_)
                            else
                                ArrowMP = currentBorder.NeighborLineMidP
                                line_ = currentBorder.NeighborLine
                                NeighborLine_ = { [1] = line_[2], [2] = line_[1] }
                                length_ = MIZ_ZONES[zoneName1].ArrowLength
                                NeighborLength_ = -(length_)
                            end

                            local _ZoneLinePerpendicularPoint = POLY:findPerpendicularEndpoints(ArrowMP, line_,
                                length_)
                            local _NeighborLinePerpendicularPoint = POLY:findPerpendicularEndpoints(ArrowMP,
                                NeighborLine_, NeighborLength_)

                            -- Adjust perpendicular points if needed to ensure they are within the zone shape
                            if POLY:PointWithinShape(_ZoneLinePerpendicularPoint, MIZ_ZONES[zoneName1].vertices) then
                                currentBorder.ZoneLinePerpendicularPoint = POLY:findPerpendicularEndpoints(ArrowMP,
                                    line_, length_)
                                currentBorder.NeighborLinePerpendicularPoint = POLY:findPerpendicularEndpoints(
                                    ArrowMP, NeighborLine_, NeighborLength_)
                            else
                                currentBorder.ZoneLinePerpendicularPoint = POLY:findPerpendicularEndpoints(ArrowMP,
                                    NeighborLine_, NeighborLength_)
                                currentBorder.NeighborLinePerpendicularPoint = POLY:findPerpendicularEndpoints(
                                    ArrowMP, line_, length_)
                            end

                            -- Save back the updated border data
                            MIZ_ZONES[zoneName1].BorderingZones[zoneName2] = zoneBorder
                        end
                    end
                end
            end
        end
    end
    return MIZ_ZONES
end

--- Draws a polygon marker on the F10 map.
--- @function AETHR.ZONE_MANAGER:drawZone
--- @param coalition integer Coalition ID (-1 all, or DCS coalition)
--- @param fillColor _ColorRGBA Fill color (r,g,b,a in 0..255)
--- @param borderColor _ColorRGBA Border color (r,g,b,a in 0..255)
--- @param linetype integer DCS line type enum
--- @param cornerVec2s _PolygonVec2 Four corner points in Vec2 space (x,y)
--- @param markerID integer Unique marker identifier
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:drawZone(coalition, fillColor, borderColor, linetype, cornerVec2s, markerID)
    local r1, g1, b1, a1 = fillColor.r, fillColor.g, fillColor.b, fillColor.a         --  RGBA components Fill
    local r2, g2, b2, a2 = borderColor.r, borderColor.g, borderColor.b, borderColor.a --  RGBA components Fill
    local shapeTypeID    = 7                                                          --  Polygon shape type
    local vec3_1         = { x = cornerVec2s[4].x, y = 0, z = cornerVec2s[4].y }      --- @diagnostic disable-line
    local vec3_2         = { x = cornerVec2s[3].x, y = 0, z = cornerVec2s[3].y }      --- @diagnostic disable-line
    local vec3_3         = { x = cornerVec2s[2].x, y = 0, z = cornerVec2s[2].y }      --- @diagnostic disable-line
    local vec3_4         = { x = cornerVec2s[1].x, y = 0, z = cornerVec2s[1].y }      --- @diagnostic disable-line

    -- Draw polygon on map
    trigger.action.markupToAll(
        shapeTypeID, coalition, markerID,
        vec3_1,
        vec3_2,
        vec3_3,
        vec3_4,
        { r2, g2, b2, a2 }, -- Border color
        { r1, g1, b1, a1 }, -- Fill color
        linetype, true
    )
    return self
end

--- Builds a set of vertex keys to exclude (those that belong to shared/bordering edges).
--- @function AETHR.ZONE_MANAGER:_buildBorderExclude
--- @param zonesTable table<string, _MIZ_ZONE>
--- @return table<string, boolean> exclude Map keyed by "x,y" -> true
function AETHR.ZONE_MANAGER:_buildBorderExclude(zonesTable)
    local function keyFor(p) return string.format("%.6f,%.6f", p.x, p.y or p.z) end
    local exclude = {}
    for zname, mz in pairs(zonesTable or {}) do
        if mz and mz.BorderingZones then --- @diagnostic disable-line
            for neighborName, zoneBorders in pairs(mz.BorderingZones) do
                for _, border in ipairs(zoneBorders or {}) do
                    if border.ZoneLine then
                        local l = border.ZoneLine
                        if l[1] then exclude[keyFor(l[1])] = true end
                        if l[2] then exclude[keyFor(l[2])] = true end
                    end
                    if border.NeighborLine then
                        local l = border.NeighborLine
                        if l[1] then exclude[keyFor(l[1])] = true end
                        if l[2] then exclude[keyFor(l[2])] = true end
                    end
                end
            end
        end
    end
    return exclude
end

--- Collects polygons (Vec2 arrays) from zones, skipping vertices present in the exclude set.
--- @function AETHR.ZONE_MANAGER:_collectPolygonsFromZones
--- @param zonesTable table<string, _MIZ_ZONE>
--- @param exclude table<string, boolean>|nil
--- @return _PolygonList polygons
function AETHR.ZONE_MANAGER:_collectPolygonsFromZones(zonesTable, exclude)
    local polygons = {}
    ---@param mz _MIZ_ZONE
    for zname, mz in pairs(zonesTable or {}) do
        local verts = mz and mz.vertices or nil
        if verts and #verts > 0 then
            local poly = {}
            for _, v in ipairs(verts) do
                local x = v.x
                local y = v.y or v.z
                if not exclude or not exclude[string.format("%.6f,%.6f", x, y)] then
                    table.insert(poly, { x = x, y = y })
                end
            end
            if #poly >= 3 then table.insert(polygons, poly) end
        end
    end
    return polygons
end

--- Flattens polygons into a unique set of points, with fallback to zone vertices.
--- @function AETHR.ZONE_MANAGER:_flattenUniquePoints
--- @param polygons _PolygonList
--- @param zonesTable table<string, _MIZ_ZONE>
--- @return _vec2[] uniquePoints
function AETHR.ZONE_MANAGER:_flattenUniquePoints(polygons, zonesTable)
    local allPoints = {}
    local uniqp = {}
    for _, poly in ipairs(polygons or {}) do
        for _, p in ipairs(poly) do
            local key = string.format("%.6f,%.6f", p.x, p.y)
            if not uniqp[key] then
                uniqp[key] = true
                table.insert(allPoints, { x = p.x, y = p.y })
            end
        end
    end

    -- fallback: include any zone vertices not already included
    if #allPoints < 3 then
        for zname, mz in pairs(zonesTable or {}) do
            local verts = mz and mz.vertices or nil
            if verts then --- @diagnostic disable-line
                for _, v in ipairs(verts) do
                    local key = string.format("%.6f,%.6f", v.x, v.y or v.z)
                    if not uniqp[key] then
                        uniqp[key] = true
                        table.insert(allPoints, { x = v.x, y = v.y or v.z })
                    end
                end
            end
        end
    end

    return allPoints
end

--- Processes a perimeter hull to produce out-of-bounds quads and stores them on DATA.GAME_BOUNDS.outOfBounds.
--- @function AETHR.ZONE_MANAGER:_processHullLoop
--- @param hull _PolygonVec2 Hull polygon loop to process
--- @param polygons _PolygonList List of contributing polygons (used for densify)
--- @param worldBounds _WorldBounds World bounds for ray-clipping
--- @param opts table Options: { samplesPerEdge: integer|nil, snapDistance: number|nil }
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:_processHullLoop(hull, polygons, worldBounds, opts)
    if not hull or #hull < 3 then return self end
    local samplesPerEdge = opts.samplesPerEdge or 0
    local snapDistance = (opts and opts.snapDistance) and opts.snapDistance or 0.1
    local POLY = self.POLY
    local MATH = self.MATH

    -- optionally densify
    if samplesPerEdge and samplesPerEdge > 0 and POLY.densifyHullEdges then
        hull = POLY:densifyHullEdges(hull, polygons, samplesPerEdge, snapDistance)
    end

    -- centroid
    local cx, cy = MATH:centroid(hull)

    -- compute outward intersection points
    local outPoints = {}
    for _, v in ipairs(hull) do
        local dx = v.x - cx
        local dy = v.y - cy
        local len = math.sqrt(dx * dx + dy * dy)
        if len == 0 then
            table.insert(outPoints,
                { x = (worldBounds.X.min + worldBounds.X.max) / 2, y = (worldBounds.Z.min + worldBounds.Z.max) / 2 })
        else
            local dir = { x = dx / len, y = dy / len }
            local ip = POLY:intersectRayToBounds(v, dir, worldBounds)
            if not ip then
                ip = POLY:intersectRayToBounds(v, { x = -dir.x, y = -dir.y }, worldBounds)
            end
            if ip then
                table.insert(outPoints, ip)
            else
                local clampX = (dir.x >= 0) and worldBounds.X.max or worldBounds.X.min
                local clampY = (dir.y >= 0) and worldBounds.Z.max or worldBounds.Z.min
                table.insert(outPoints, { x = clampX, y = clampY })
            end
        end
    end
    local hullPolys = {}
    -- draw quads
    for i = 1, #hull do
        local j = (i % #hull) + 1
        local vi = hull[i]; local vj = hull[j]
        local oi = outPoints[i]; local oj = outPoints[j]
        if oi and oj then
            if not (math.abs(oi.x - oj.x) < 1e-6 and math.abs(oi.y - oj.y) < 1e-6) then
                local poly = {
                    { x = vi.x, y = vi.y },
                    { x = vj.x, y = vj.y }, --- @diagnostic disable-line
                    { x = oj.x, y = oj.y },
                    { x = oi.x, y = oi.y },
                }
                table.insert(hullPolys, poly)
            end
        end
    end
    if samplesPerEdge and samplesPerEdge > 0 then
        self.DATA.GAME_BOUNDS.outOfBounds.HullPolysWithSample = hullPolys
    else
        self.DATA.GAME_BOUNDS.outOfBounds.HullPolysNoSample = hullPolys
    end
    ---self.DATA.GAME_BOUNDS.outOfBounds.HullPolys = hullPolys

    return self
end

--- Computes and stores the master in-bounds polygon from child zones, excluding shared borders.
--- Populates DATA.GAME_BOUNDS.inBounds.polyLines and polyVerts.
--- @function AETHR.ZONE_MANAGER:getMasterZonePolygon
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:getMasterZonePolygon()
    -- New logic flow implementing user's specification:
    -- 1) Determine bordering polygons (edges within offset)
    -- 2) Exclude those bordering edges from the master perimeter
    -- 3) Walk remaining perimeter edges, cluster/snap nearby endpoints and create joining edges for gaps
    -- 4) Return the largest closed perimeter loop as the Master Polygon (array of {x,y})

    local ChildZoneTables = self.DATA.MIZ_ZONES
    local zoneOffset = self.CONFIG.MAIN.Zone.BorderOffsetThreshold

    local masterPolyLines = {}

    for _, _zone in pairs(ChildZoneTables) do
        local lines = _zone.LinesVec2
        local BorderingZones = _zone.BorderingZones
        for _, line in ipairs(lines or {}) do
            local isBorder = false
            for _, borderZone in pairs(BorderingZones or {}) do
                for _, _arr in pairs(borderZone or {}) do
                    local _zoneLine = _arr.ZoneLine
                    if _zoneLine and (_zoneLine == line) then
                        isBorder = true
                        break
                    end
                    if isBorder then break end
                end
                if isBorder then break end
            end
            if not isBorder then table.insert(masterPolyLines, line) end
        end
    end

    self.DATA.GAME_BOUNDS.inBounds.polyLines = masterPolyLines
    self.DATA.GAME_BOUNDS.inBounds.polyVerts = self.POLY:convertLinesToPolygon(
        masterPolyLines,
        zoneOffset
    )

    return self
end

--- Constructs the inner "hole" polygon from a list of contributing polygons.
--- @function AETHR.ZONE_MANAGER:getPolygonCutout
--- @param PolyTable _PolygonList List of polygons (each polygon is an array of { x: number, y: number })
--- @return _PolygonVec2|nil Hollow inner polygon or nil if none
function AETHR.ZONE_MANAGER:getPolygonCutout(PolyTable)
    -- Returns the inner "hole" polygon constructed from a list of contributing polygons.
    -- PolyTable is expected to be an array of polygons where each polygon is an array of points { x = number, y = number }.
    -- Algorithm:
    -- 1. Normalize input points and build a map of undirected edges.
    -- 2. Any edge that occurs only once is a boundary edge. Collect those.
    -- 3. Walk the boundary edges to construct closed loops (there may be more than one).
    -- 4. Identify the outer loop (largest area). Any remaining loop whose centroid lies inside the outer loop
    --    is considered a hole. Return the largest such hole (or second-largest loop if containment test fails).
    --
    -- Returns: table|nil Array of points { x = number, y = number } describing the inner hollow polygon, or nil.
    if not PolyTable or type(PolyTable) ~= "table" then return nil end

    -- helpers
    local function toXY(p)
        if not p then return nil end
        return { x = tonumber(p.x) or 0, y = tonumber(p.y or p.z) or 0 }
    end

    local function keyFor(p)
        return string.format("%.6f,%.6f", p.x, p.y)
    end

    local function polygonArea(pts)
        local n = #pts
        if n < 3 then return 0 end
        ---@type any
        local sum = 0
        for i = 1, n do
            local j = (i % n) + 1
            sum = sum + (pts[i].x * pts[j].y - pts[j].x * pts[i].y)
        end
        return math.abs(sum) * 0.5
    end

    local function polygonCentroid(pts)
        local n = #pts
        if n < 1 then return { x = 0, y = 0 } end
        ---@type any
        local A = 0
        ---@type any
        local cx = 0
        ---@type any
        local cy = 0
        for i = 1, n do
            local j = (i % n) + 1
            local cross = pts[i].x * pts[j].y - pts[j].x * pts[i].y
            A = A + cross
            cx = cx + (pts[i].x + pts[j].x) * cross
            cy = cy + (pts[i].y + pts[j].y) * cross
        end
        A = A * 0.5
        if math.abs(A) < 1e-12 then
            -- fallback to simple average
            local sx, sy = 0, 0
            for _, p in ipairs(pts) do
                sx = sx + p.x; sy = sy + p.y
            end
            return { x = sx / #pts, y = sy / #pts }
        end
        return { x = cx / (6 * A), y = cy / (6 * A) }
    end

    -- Normalize input polygons and collect edges
    local pointsByKey = {}
    local undirectedCount = {} -- key: "A|B" (sorted) -> count
    local anyOriented = {}     -- store one oriented occurrence { from = keyA, to = keyB }
    local polygons = {}

    for _, poly in ipairs(PolyTable) do
        if type(poly) == "table" and #poly >= 3 then
            local pnorm = {}
            for _, v in ipairs(poly) do
                local pt = toXY(v)
                table.insert(pnorm, pt)
            end
            if #pnorm >= 3 then table.insert(polygons, pnorm) end
        end
    end

    if #polygons == 0 then return nil end

    for _, poly in ipairs(polygons) do
        for i = 1, #poly do
            local j = (i % #poly) + 1
            local a = poly[i]; local b = poly[j]
            local ka = keyFor(a); local kb = keyFor(b)
            pointsByKey[ka] = { x = a.x, y = a.y }
            pointsByKey[kb] = { x = b.x, y = b.y }
            local ukey = (ka < kb) and (ka .. "|" .. kb) or (kb .. "|" .. ka)
            undirectedCount[ukey] = (undirectedCount[ukey] or 0) + 1
            if not anyOriented[ukey] then anyOriented[ukey] = { from = ka, to = kb } end
        end
    end

    -- Boundary edges are undirected edges that occur only once
    local boundaryEdgeSet = {}
    local adjacency = {} -- adjacency list keyed by point-key -> { neighborKey, ... }
    for ukey, cnt in pairs(undirectedCount) do
        if cnt == 1 then
            boundaryEdgeSet[ukey] = true
            -- parse the two endpoints
            local a, b = ukey:match("([^|]+)|([^|]+)")
            if a and b then
                adjacency[a] = adjacency[a] or {}
                adjacency[b] = adjacency[b] or {}
                table.insert(adjacency[a], b)
                table.insert(adjacency[b], a)
            end
        end
    end

    if not next(boundaryEdgeSet) then
        -- no boundary edges -> no cutout
        return nil
    end

    -- Walk boundary edges to form closed loops
    local usedEdge = {}
    local loops = {}

    for edgeKey, _ in pairs(boundaryEdgeSet) do
        if not usedEdge[edgeKey] then
            local a, b = edgeKey:match("([^|]+)|([^|]+)")
            if a and b then
                -- prefer starting at the endpoint that still has unused adjacent edges
                local start = a
                if not adjacency[start] or #adjacency[start] == 0 then start = b end

                -- mark the starting undirected edge as used (if present)
                usedEdge[edgeKey] = true

                local pathKeys = { start }
                local curr = start
                local safety = 0
                while true do
                    safety = safety + 1
                    if safety > 20000 then break end
                    local neighs = adjacency[curr] or {}
                    local nextKey = nil
                    for _, nk in ipairs(neighs) do
                        local cand = (curr < nk) and (curr .. "|" .. nk) or (nk .. "|" .. curr)
                        if boundaryEdgeSet[cand] and not usedEdge[cand] then
                            nextKey = nk
                            usedEdge[cand] = true
                            break
                        end
                    end

                    if not nextKey then
                        -- attempt to close the loop by checking if there's an adjacent neighbor that's the start
                        local closed = false
                        for _, nk in ipairs(neighs) do
                            if nk == pathKeys[1] then
                                closed = true
                                break
                            end
                        end
                        break
                    end

                    table.insert(pathKeys, nextKey)
                    curr = nextKey
                    if curr == pathKeys[1] then break end
                end

                -- build points array from keys
                if #pathKeys >= 3 then
                    local pts = {}
                    -- ensure unique sequential points (do not duplicate last==first)
                    for _, k in ipairs(pathKeys) do
                        local p = pointsByKey[k]
                        if p then table.insert(pts, { x = p.x, y = p.y }) end
                    end
                    -- If last point equals first, remove duplicate last
                    if #pts >= 2 and math.abs(pts[1].x - pts[#pts].x) < 1e-9 and math.abs(pts[1].y - pts[#pts].y) < 1e-9 then
                        table.remove(pts, #pts)
                    end
                    if #pts >= 3 then
                        table.insert(loops, { points = pts, area = polygonArea(pts), centroid = polygonCentroid(pts) })
                    end
                end
            end
        end
    end

    if #loops == 0 then return nil end

    -- Sort loops by area descending (largest first)
    table.sort(loops, function(a, b) return (a.area or 0) > (b.area or 0) end)

    -- Outer loop is assumed to be the largest by area
    local outer = loops[1]

    -- Find hole loops whose centroid is inside the outer loop
    local holeCandidates = {}
    for i = 2, #loops do
        local L = loops[i]
        if L and L.centroid and outer and outer.points and #outer.points >= 3 then ---@diagnostic disable-line
            -- use POLY:pointInPolygon which expects {x,y} points
            local inside = false
            if self.POLY and self.POLY.pointInPolygon then ---@diagnostic disable-line
                inside = self.POLY:pointInPolygon(L.centroid, outer.points)
            else
                -- fallback simple winding check via centroid-in-outer using our polygonArea-based ray-cast
                inside = self.POLY and self.POLY:PointWithinShape(L.centroid, outer.points) or false
            end
            if inside then table.insert(holeCandidates, L) end
        end
    end

    local chosen = nil
    if #holeCandidates > 0 then
        -- choose largest hole candidate by area
        table.sort(holeCandidates, function(a, b) return (a.area or 0) > (b.area or 0) end)
        chosen = holeCandidates[1]
    else
        -- containment test failed; fallback to second largest loop if exists
        if #loops >= 2 then chosen = loops[2] end
    end

    if not chosen then return nil end

    -- return a copy of vertices (x,y)
    local out = {}
    for _, p in ipairs(chosen.points) do table.insert(out, { x = p.x, y = p.y }) end
    return out
end

--- Computes out-of-bounds quads around the union of mission zones and stores them on DATA.GAME_BOUNDS.outOfBounds.
--- Uses concave hull (fallback to convex hull) and optional edge densification.
--- @function AETHR.ZONE_MANAGER:getOutOfBounds
--- @param opts table|nil Options: { samplesPerEdge: integer|nil, useHoleSinglePolygon: boolean|nil, snapDistance: number|nil, k: integer|nil, concavity: number|nil }
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:getOutOfBounds(opts)
    opts = opts or {}
    local samplesPerEdge = opts.samplesPerEdge or 0

    -- Resolve world bounds (preserve original lookup)
    local worldBounds = (self.CONFIG and self.CONFIG.MAIN and self.CONFIG.MAIN.worldBounds and self.CONFIG.MAIN.worldBounds[self.CONFIG.MAIN.THEATER]) or
        nil
    if not worldBounds then return self end

    -- Use zones from stored data by default
    local zonesTable = self.DATA.MIZ_ZONES or {}

    -- Build exclude map and collect polygons
    local exclude = self:_buildBorderExclude(zonesTable)
    local polygons = self:_collectPolygonsFromZones(zonesTable, exclude)

    -- If no valid polygons, fallback to collecting all zone vertices (preserve prior behavior)
    local validPolyCount = 0
    for _, poly in ipairs(polygons) do if poly and #poly >= 3 then validPolyCount = validPolyCount + 1 end end
    if validPolyCount == 0 then
        local flat = {}
        for zname, mz in pairs(zonesTable) do
            local verts = mz and mz.vertices or nil
            if verts then
                for _, v in ipairs(verts) do
                    table.insert(flat, { x = v.x, y = v.y or v.z })
                end
            end
        end
        if #flat >= 3 then table.insert(polygons, flat) end
    end

    -- Build unique point list
    local allPoints = self:_flattenUniquePoints(polygons, zonesTable)
    if #allPoints < 3 then
        local boundsPoly = self.POLY:convertBoundsToPolygon(worldBounds)
        if boundsPoly and #boundsPoly == 4 then
            local vp = {}
            for _, c in ipairs(boundsPoly) do table.insert(vp, { x = c.x, y = c.z }) end
            return self
        end
        return self
    end

    -- Build hull (concave then convex fallback)
    local initial_k = opts.k or opts.concavity or math.max(3, math.floor(#allPoints * 0.1))
    local hull = nil
    if self.POLY and self.POLY.concaveHull then ---@diagnostic disable-line
        hull = self.POLY:concaveHull(allPoints, { k = initial_k, concavity = opts.concavity })
    end
    if not hull then
        hull = self.POLY:convexHull(allPoints) or nil
    end
    if not hull or #hull < 3 then return self end
    self:_processHullLoop(hull, polygons, worldBounds, opts)
    return self
end

--- Initializes in/out-of-bounds and gaps data by loading from storage or generating it.
--- @function AETHR.ZONE_MANAGER:initGameZoneBoundaries
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:initGameZoneBoundaries()
    local data = self:getStoredGameBoundData()
    if data then
        self.DATA.GAME_BOUNDS = data
    else
        self:generateGameBoundData()
        self:saveGameBoundData()
    end
    return self
end

--- Loads previously saved game bound data from storage if present.
--- @function AETHR.ZONE_MANAGER:getStoredGameBoundData
--- @return _GameBounds|nil
function AETHR.ZONE_MANAGER:getStoredGameBoundData()
    local mapPath = self.CONFIG.MAIN.STORAGE.PATHS.MAP_FOLDER
    local saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.GAME_BOUNDS_FILE
    local data = self.FILEOPS:loadData(mapPath, saveFile)
    if data then return data end
    return nil
end

--- Persists current DATA.GAME_BOUNDS to storage.
--- @function AETHR.ZONE_MANAGER:saveGameBoundData
--- @return nil
function AETHR.ZONE_MANAGER:saveGameBoundData()
    local mapPath = self.CONFIG.MAIN.STORAGE.PATHS.MAP_FOLDER
    local saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.GAME_BOUNDS_FILE
    self.FILEOPS:saveData(mapPath, saveFile, self.DATA.GAME_BOUNDS)
end

--- Computes master zone polygon, out-of-bounds tiles, and gap polygons and stores them under DATA.GAME_BOUNDS.
--- @function AETHR.ZONE_MANAGER:generateGameBoundData
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:generateGameBoundData()
    self:getMasterZonePolygon()
    self:getOutOfBounds({
        samplesPerEdge = 0,
        useHoleSinglePolygon = false,
        snapDistance = 0,
    })
    self.DATA.GAME_BOUNDS.outOfBounds.centerPoly = self:getPolygonCutout(self.DATA.GAME_BOUNDS.outOfBounds
        .HullPolysNoSample)

    self:getOutOfBounds({
        samplesPerEdge = self.CONFIG.MAIN.Zone.gameBounds.getOutOfBounds.samplesPerEdge,
        useHoleSinglePolygon = self.CONFIG.MAIN.Zone.gameBounds.getOutOfBounds.useHoleSinglePolygon,
        snapDistance = self.CONFIG.MAIN.Zone.gameBounds.getOutOfBounds.snapDistance,
    })


    self.DATA.GAME_BOUNDS.inOutBoundsGaps.overlaid = self.POLY:findOverlaidPolygonGaps(
        self.DATA.GAME_BOUNDS.inBounds.polyVerts,
        self.DATA.GAME_BOUNDS.outOfBounds.centerPoly
    )

    for _, val in ipairs(self.DATA.GAME_BOUNDS.inOutBoundsGaps.overlaid) do
        self.DATA.GAME_BOUNDS.inOutBoundsGaps.convex[#self.DATA.GAME_BOUNDS.inOutBoundsGaps.convex + 1] = self.POLY
            :ensureConvexN(val)
    end
    for _, val in ipairs(self.DATA.GAME_BOUNDS.inOutBoundsGaps.convex) do
        self.DATA.GAME_BOUNDS.inOutBoundsGaps.concave[#self.DATA.GAME_BOUNDS.inOutBoundsGaps.concave + 1] = self.POLY
            :reverseVertOrder(val)
    end
    return self
end

--- Renders computed game bound polygons as freeform markers.
--- @function AETHR.ZONE_MANAGER:drawGameBounds
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:drawGameBounds()
    local function markerGen(poly)
        local _Marker = self.AETHR._Marker:New(
            self.CONFIG.MAIN.COUNTERS.MARKERS,
            nil,
            nil,
            true,
            nil,
            self.ENUMS.MarkerTypes.Freeform,
            -1, --_zone.ownedBy,
            self.CONFIG.MAIN.Zone.gameBounds.lineType,
            {
                r = self.CONFIG.MAIN.Zone.gameBounds.LineColors.r,
                g = self.CONFIG.MAIN.Zone.gameBounds.LineColors.g,
                b = self.CONFIG.MAIN.Zone.gameBounds.LineColors.b,
                a = self.CONFIG.MAIN.Zone.gameBounds.LineAlpha
            },
            {
                r = self.CONFIG.MAIN.Zone.gameBounds.FillColors.r,
                g = self.CONFIG.MAIN.Zone.gameBounds.FillColors.g,
                b = self.CONFIG.MAIN.Zone.gameBounds.FillColors.b,
                a = self.CONFIG.MAIN.Zone.gameBounds.FillAlpha
            },
            poly,
            nil
        )
        self.CONFIG.MAIN.COUNTERS.MARKERS = self.CONFIG.MAIN.COUNTERS.MARKERS + 1
        return _Marker
    end

    for _, poly in pairs(self.DATA.GAME_BOUNDS.outOfBounds.HullPolysWithSample or self.DATA.GAME_BOUNDS.outOfBounds.HullPolysNoSample) do
        local _Marker = markerGen(poly)
        self.MARKERS:markFreeform(
            _Marker,
            self.MARKERS.DATA.ZONE_MANAGER.OutOfBounds
        )
    end
    for _, poly in pairs(self.DATA.GAME_BOUNDS.inOutBoundsGaps.convex) do
        local _Marker = markerGen(poly)
        self.MARKERS:markFreeform(
            _Marker,
            self.MARKERS.DATA.ZONE_MANAGER.InOutBoundsGaps
        )
    end
    return self
end

--- Renders all mission zones as freeform markers colored by coalition.
--- @function AETHR.ZONE_MANAGER:drawMissionZones
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:drawMissionZones()
    ---@param _ string
    ---@param _zone _MIZ_ZONE
    for _, _zone in pairs(self.DATA.MIZ_ZONES) do
        --local tempMarkerID = self.CONFIG.MAIN.COUNTERS.MARKERS
        local _Marker = self.AETHR._Marker:New(
            self.CONFIG.MAIN.COUNTERS.MARKERS,
            nil,
            nil,
            _zone.readOnly,
            nil,
            _zone.shapeID,
            -1, --_zone.ownedBy,
            self.CONFIG.MAIN.Zone.paintColors.lineType,
            {
                r = self.CONFIG.MAIN.Zone.paintColors.LineColors[_zone.ownedBy].r,
                g = self.CONFIG.MAIN.Zone.paintColors.LineColors[_zone.ownedBy].g,
                b = self.CONFIG.MAIN.Zone.paintColors.LineColors[_zone.ownedBy].b,
                a = self.CONFIG.MAIN.Zone.paintColors.LineAlpha
            },
            {
                r = self.CONFIG.MAIN.Zone.paintColors.FillColors[_zone.ownedBy].r,
                g = self.CONFIG.MAIN.Zone.paintColors.FillColors[_zone.ownedBy].g,
                b = self.CONFIG.MAIN.Zone.paintColors.FillColors[_zone.ownedBy].b,
                a = self.CONFIG.MAIN.Zone.paintColors.FillAlpha
            },
            _zone.vertices,
            nil
        )
        self.CONFIG.MAIN.COUNTERS.MARKERS = self.CONFIG.MAIN.COUNTERS.MARKERS + 1

        ---@type _Marker _Marker
        _zone.markerObject = _Marker

        self.MARKERS:markFreeform(
            _Marker,
            self.MARKERS.DATA.ZONE_MANAGER.MizZones
        )
    end
    return self
end

--- Draws border-direction arrows for each bordering pair for all coalitions.
--- @function AETHR.ZONE_MANAGER:drawZoneArrows
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:drawZoneArrows()
    local _zones = self.DATA.MIZ_ZONES
    local ArrowColors = self.CONFIG.MAIN.Zone.paintColors.ArrowColors
    for zName, zObj in pairs(_zones) do
        local ownedBy = zObj.ownedBy
        for bzName, bzObj in pairs(zObj.BorderingZones) do
            local borderCoalition = _zones[bzName] and _zones[bzName].ownedBy
            for _, borderDetail in ipairs(bzObj) do
                for currentCoalition = 0, 2 do
                    local lineColor = {
                        r = ArrowColors[currentCoalition].r,
                        g = ArrowColors[currentCoalition].g,
                        b = ArrowColors[currentCoalition].b,
                        a = 0
                    }
                    local fillColor = {
                        r = ArrowColors[currentCoalition].r,
                        g = ArrowColors[currentCoalition].g,
                        b = ArrowColors[currentCoalition].b,
                        a = 0
                    }
                    local _Marker = self.AETHR._Marker:New(
                        borderDetail.MarkID[currentCoalition],
                        nil,
                        nil,
                        zObj.readOnly,
                        nil,
                        self.ENUMS.MarkerTypes.Arrow,
                        currentCoalition,
                        self.ENUMS.LineTypes.Solid,
                        { r = lineColor.r, g = lineColor.g, b = lineColor.b, a = lineColor.a },
                        { r = fillColor.r, g = fillColor.g, b = fillColor.b, a = fillColor.a },
                        { borderDetail.ArrowTip, borderDetail.ArrowEnd },
                        nil
                    )
                    borderDetail.ArrowObjects[currentCoalition] = _Marker
                    self.MARKERS:markArrow(
                        _Marker,
                        self.MARKERS.DATA.ZONE_MANAGER.ZoneArrows
                    )
                end
            end
        end
    end
    return self
end

--- Initializes arrow markers per border segment and assigns MarkIDs and endpoints.
--- @function AETHR.ZONE_MANAGER:initZoneArrows
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:initZoneArrows()
    local _zones = self.DATA.MIZ_ZONES
    for zName, zObj in pairs(_zones) do
        local ownedBy = zObj.ownedBy
        for bzName, bzObj in pairs(zObj.BorderingZones) do
            --Assign Arrow MarkID if not already assigned
            for _, borderDetail in ipairs(bzObj) do
                for currentCoalition = 0, 2 do
                    if borderDetail.MarkID[currentCoalition] == 0 then
                        borderDetail.MarkID[currentCoalition] = self.CONFIG.MAIN.COUNTERS.MARKERS
                        self.CONFIG.MAIN.COUNTERS.MARKERS = self.CONFIG.MAIN.COUNTERS.MARKERS + 1
                    end
                end
                -- Define the start and end points of the arrow.
                local NLPP = borderDetail.NeighborLinePerpendicularPoint
                local ZLPP = borderDetail.ZoneLinePerpendicularPoint
                borderDetail.ArrowTip = NLPP
                borderDetail.ArrowEnd = ZLPP
            end
        end
    end
    return self
end

--- Builds watchers for airbase coalition changes within each zone.
--- @function AETHR.ZONE_MANAGER:initWatcher_AirbaseOwnership
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:initWatcher_AirbaseOwnership()
    local _zones = self.DATA.MIZ_ZONES
    for zName, zObj in pairs(_zones) do
        self.BRAIN:buildWatcher(zObj.Airbases, "coalition", self.WORLD.airbaseOwnershipChanged, zName, self)
    end
    return self
end

--- Builds a watcher for zone ownership changes (ownedBy field) across all zones.
--- @function AETHR.ZONE_MANAGER:initWatcher_ZoneOwnership
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:initWatcher_ZoneOwnership()
    local _zones = self.DATA.MIZ_ZONES
    self.BRAIN:buildWatcher(_zones, "ownedBy", self.WORLD.zoneOwnershipChanged, self)
    return self
end

--- Spawns airbase filler groups for all airbases within a zone using SPAWNER.
--- @function AETHR.ZONE_MANAGER:spawnAirbasesZone
--- @param zoneName string Zone name key
--- @param countryID integer Engine country id
--- @param dynamicSpawner _dynamicSpawner|nil Optional dynamic spawner instance
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:spawnAirbasesZone(zoneName, countryID, dynamicSpawner)
    local _zones = self.DATA.MIZ_ZONES
    ---@type _MIZ_ZONE
    local zone = _zones[zoneName]
    local airBaseSpawners = self.SPAWNER.DATA.dynamicSpawners.Airbase
    if not zone then return self end
    ---@param airbase _airbase
    for _, airbase in pairs(zone.Airbases or {}) do
        if not dynamicSpawner then dynamicSpawner = airBaseSpawners[self.UTILS:pickRandomKeyFromTable(airBaseSpawners)] end
        self.SPAWNER:spawnAirbaseFill(airbase, countryID, dynamicSpawner)
    end
    return self
end

--- Spawns airbase filler groups for all airbases across all zones using SPAWNER.
--- Uses RED and BLUE Start Zones to determine country of spawns for airbases.
--- @function AETHR.ZONE_MANAGER:spawnAirbasesAllZones
--- @param dynamicSpawner _dynamicSpawner|nil Optional dynamic spawner instance
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:spawnAirbasesAllZones(dynamicSpawner)
    --local _zones = self.CONFIG.MAIN.MIZ_ZONES.ALL--self.DATA.MIZ_ZONES
    local redZones = self.CONFIG.MAIN.MIZ_ZONES.REDSTART
    local blueZones = self.CONFIG.MAIN.MIZ_ZONES.BLUESTART
    local redCountry = self.CONFIG.MAIN.DefaultRedCountry
    local blueCountry = self.CONFIG.MAIN.DefaultBlueCountry

    for _, zName in ipairs(redZones) do
        self:spawnAirbasesZone(zName, redCountry, dynamicSpawner)
    end
    for _, zName in ipairs(blueZones) do
        self:spawnAirbasesZone(zName, blueCountry, dynamicSpawner)
    end

    return self
end

--- Spawns town filler groups for all towns within a zone using SPAWNER.
--- @function AETHR.ZONE_MANAGER:spawnTownsZone
--- @param zoneName string Zone name key
--- @param countryID integer Engine country id
--- @param minTownRadius number|nil Minimum radius to consider a town for spawning (inclusive)
--- @param dynamicSpawner _dynamicSpawner|nil Optional dynamic spawner instance
--- @param spawnChance number|nil Chance (0-1) to spawn each town
--- @param maxTownRadius number|nil Maximum town cluster radius to include (inclusive, default math.huge)
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:spawnTownsZone(zoneName, countryID, minTownRadius, dynamicSpawner, spawnChance, maxTownRadius)
    self.UTILS:debugInfo("AETHR.ZONE_MANAGER:spawnTownsZone | ZONE: " .. zoneName)
    local _zones = self.DATA.MIZ_ZONES
    ---@type _MIZ_ZONE
    local zone = _zones[zoneName]
    if not zone then return self end
    local townSpawners = self.SPAWNER.DATA.dynamicSpawners.Town
    local townsDB = zone.townsDB or {}
    local spawnChance_

    local minR = (minTownRadius ~= nil) and tonumber(minTownRadius) or 0
    local maxR = (maxTownRadius ~= nil) and tonumber(maxTownRadius) or math.huge

    ---@param town _dbCluster
    for _, town in pairs(townsDB) do
        local townRad = tonumber(town.Radius) or 0
        if townRad >= minR and townRad <= maxR then
            spawnChance_ = spawnChance or math.random()
            local rolledChance = math.random()
            if rolledChance <= spawnChance_ then
                if not dynamicSpawner then
                    dynamicSpawner = townSpawners[self.UTILS:pickRandomKeyFromTable(townSpawners)]
                end
                self.SPAWNER:spawnDBClusterFill(town, countryID, dynamicSpawner)
            end
        end
    end
    return self
end

--- Spawns town filler groups for all towns across all zones using SPAWNER.
--- Uses RED and BLUE Start Zones to determine country of spawns for towns.
--- @function AETHR.ZONE_MANAGER:spawnTownsAllZones
--- @param minTownRadius number|nil Minimum radius to consider a town for spawning
--- @param dynamicSpawner _dynamicSpawner|nil Optional dynamic spawner instance
--- @param spawnChance number|nil Chance (0-1) to spawn each town
--- @param maxTownRadius number|nil Maximum town cluster radius to include (inclusive, default math.huge)
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:spawnTownsAllZones(minTownRadius, dynamicSpawner, spawnChance, maxTownRadius)
    local redZones = self.CONFIG.MAIN.MIZ_ZONES.REDSTART
    local blueZones = self.CONFIG.MAIN.MIZ_ZONES.BLUESTART
    local redCountry = self.CONFIG.MAIN.DefaultRedCountry
    local blueCountry = self.CONFIG.MAIN.DefaultBlueCountry

    self.UTILS:debugInfo("AETHR.ZONE_MANAGER:spawnTownsAllZones")
    for _, zName in ipairs(redZones) do
        self.UTILS:debugInfo("AETHR.ZONE_MANAGER:spawnTownsAllZones | RED ZONE: " .. zName)
        self:spawnTownsZone(zName, redCountry, minTownRadius, dynamicSpawner, spawnChance, maxTownRadius)
    end
    for _, zName in ipairs(blueZones) do
        self.UTILS:debugInfo("AETHR.ZONE_MANAGER:spawnTownsAllZones | BLUE ZONE: " .. zName)
        self:spawnTownsZone(zName, blueCountry, minTownRadius, dynamicSpawner, spawnChance, maxTownRadius)
    end
    return self
end

--- Spawns town filler groups for all eligible towns within a circle or annulus using SPAWNER.
--- Similar to spawnTownsZone but selects by geographic circle/annulus and filters by town radius range.
--- @function AETHR.ZONE_MANAGER:spawnTownsCircle
--- @param vec2 _vec2 Center of the selection circle
--- @param radius number|nil Circle radius in meters (used when annulus bounds are omitted)
--- @param countryID integer Engine country id
--- @param minTownRadius number|nil Minimum town cluster radius to include (inclusive, default 0)
--- @param maxTownRadius number|nil Maximum town cluster radius to include (inclusive, default math.huge)
--- @param dynamicSpawner _dynamicSpawner|nil Optional dynamic spawner instance (Town type). When nil, one is chosen from SPAWNER.DATA.dynamicSpawners.Town.
--- @param spawnChance number|nil Chance (0-1) to spawn each eligible town; when nil, a per-town threshold is drawn randomly.
--- @param minCircleRadius number|nil Inner radial bound for annulus selection (inclusive). When provided (with or without max), annulus selection is used.
--- @param maxCircleRadius number|nil Outer radial bound for annulus selection (inclusive). When omitted, falls back to 'radius'.
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:spawnTownsCircle(vec2, radius, countryID, minTownRadius, maxTownRadius, dynamicSpawner,
                                             spawnChance, minCircleRadius, maxCircleRadius)
    local center = self.UTILS:normalizePoint(vec2)
    local r = tonumber(radius) or 0

    -- Determine annulus bounds if provided; fallback to circle radius when omitted
    local innerR = (minCircleRadius ~= nil) and tonumber(minCircleRadius) or 0
    local outerR = (maxCircleRadius ~= nil) and tonumber(maxCircleRadius) or r
    if (outerR or 0) <= 0 then outerR = r end
    if innerR < 0 then innerR = 0 end
    if innerR > outerR then innerR, outerR = outerR, innerR end
    local useAnnulus = (minCircleRadius ~= nil) or (maxCircleRadius ~= nil)

    if useAnnulus then
        self.UTILS:debugInfo("AETHR.ZONE_MANAGER:spawnTownsCircle | center: (" ..
            tostring(center.x) ..
            "," .. tostring(center.y) .. ") ring: [" .. tostring(innerR) .. "," .. tostring(outerR) .. "]")
    else
        self.UTILS:debugInfo("AETHR.ZONE_MANAGER:spawnTownsCircle | center: (" ..
            tostring(center.x) .. "," .. tostring(center.y) .. ") radius: " .. tostring(r))
    end

    local minR = (minTownRadius ~= nil) and tonumber(minTownRadius) or 0
    local maxR = (maxTownRadius ~= nil) and tonumber(maxTownRadius) or math.huge

    local townSpawners = self.SPAWNER.DATA.dynamicSpawners.Town
    local townsDB = (self.WORLD and self.WORLD.DATA and self.WORLD.DATA.townClusterDB) or {}
    local spawnChance_

    local r2 = r * r
    local inner2 = innerR * innerR
    local outer2 = outerR * outerR

    for _, town in pairs(townsDB) do
        local tc = town and town.Center and self.UTILS:normalizePoint(town.Center) or nil
        local townRad = town and tonumber(town.Radius) or 0
        if tc and townRad >= minR and townRad <= maxR then
            local dx = tc.x - center.x
            local dy = tc.y - center.y
            local d2 = dx * dx + dy * dy
            if (useAnnulus and d2 >= inner2 and d2 <= outer2) or (not useAnnulus and d2 <= r2) then
                spawnChance_ = spawnChance or math.random()
                local rolledChance = math.random()
                if rolledChance <= spawnChance_ then
                    if not dynamicSpawner then
                        dynamicSpawner = townSpawners[self.UTILS:pickRandomKeyFromTable(townSpawners)]
                    end
                    self.SPAWNER:spawnDBClusterFill(town, countryID, dynamicSpawner)
                end
            end
        end
    end

    return self
end

--- Performs concentrically expanding spawns of town filler groups using non-overlapping annuli.
--- Each iteration i selects ring [prevOuter+epsilon, baseR*radiusMultiplier^(i-1)] to avoid duplicate spawns on
--- inclusive bounds used by spawnTownsCircle. Chance per ring is clamped to [0,1] and decreases (or increases)
--- by chanceMultiplier each iteration. Early exits occur for non-positive radius, degenerate radii, or chance==0.
--- Epsilon used on inner boundary: 0.01 meters.
--- @function AETHR.ZONE_MANAGER:spawnTownsExpandingCircle
--- @param vec2 _vec2 Center of the expanding circle
--- @param radius number Base circle radius in meters (used for first ring)
--- @param countryID integer Engine country id
--- @param minTownRadius number|nil Minimum town cluster radius to include (inclusive, default
--- @param maxTownRadius number|nil Maximum town cluster radius to include (inclusive, default math.huge)
--- @param dynamicSpawner _dynamicSpawner|nil Optional dynamic spawner instance (Town type). When nil, one is chosen from SPAWNER.DATA.dynamicSpawners.Town.
--- @param spawnChance number|nil Base chance (0-1) to spawn each eligible town in the first ring; when nil, a per-town threshold is drawn randomly.
--- @param concentricSpawnChanceMultiplier number|nil Multiplier applied to spawnChance per iteration (default 0.8)
--- @param concentricRadiusMultipier number|nil Multiplier applied to radius per iteration (default 1.5)
--- @param concentricIterations integer|nil Number of concentric rings to spawn (default 1)
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:spawnTownsExpandingCircle(vec2, radius, countryID, minTownRadius, maxTownRadius,
                                                      dynamicSpawner, spawnChance, concentricSpawnChanceMultiplier,
                                                      concentricRadiusMultipier, concentricIterations)
    local center = self.UTILS:normalizePoint(vec2)
    local baseR = tonumber(radius) or 0
    local minR = (minTownRadius ~= nil) and tonumber(minTownRadius) or 0
    local maxR = (maxTownRadius ~= nil) and tonumber(maxTownRadius) or math.huge
    local iterations = math.floor(tonumber(concentricIterations) or 1)
    if iterations < 1 then iterations = 1 end

    local radiusMultiplier = tonumber(concentricRadiusMultipier) or 1.5
    local chanceMultiplier = tonumber(concentricSpawnChanceMultiplier) or 0.8

    -- Normalize and validate inputs
    if baseR <= 0 then
        self.UTILS:debugInfo("AETHR.ZONE_MANAGER:spawnTownsExpandingCircle | aborted: radius <= 0")
        return self
    end

    if radiusMultiplier <= 1 and iterations > 1 then
        self.UTILS:debugInfo("AETHR.ZONE_MANAGER:spawnTownsExpandingCircle | radiusMultiplier (" ..
            tostring(radiusMultiplier) ..
            ") ≤ 1 with iterations=" .. tostring(iterations) .. "; reducing to a single ring")
        iterations = 1
    end

    local baseChance = (spawnChance ~= nil) and tonumber(spawnChance) or 1.0
    if baseChance < 0 then baseChance = 0 elseif baseChance > 1 then baseChance = 1 end

    local EPS = 0.01
    local prevOuter = 0

    for i = 1, iterations do
        local currentRadius = baseR * (radiusMultiplier ^ (i - 1))
        if currentRadius <= (prevOuter + EPS) then
            self.UTILS:debugInfo(
                "AETHR.ZONE_MANAGER:spawnTownsExpandingCircle | stopping: non-increasing radius at iter " ..
                tostring(i) ..
                " (prevOuter=" .. tostring(prevOuter) .. ", current=" .. tostring(currentRadius) .. ")")
            break
        end

        local currentChance = baseChance * (chanceMultiplier ^ (i - 1))
        if currentChance < 0 then currentChance = 0 elseif currentChance > 1 then currentChance = 1 end
        if currentChance <= 0 then
            self.UTILS:debugInfo("AETHR.ZONE_MANAGER:spawnTownsExpandingCircle | stopping: chance ≤ 0 at iter " ..
                tostring(i))
            break
        end

        local inner = (i == 1) and 0 or (prevOuter + EPS)
        local outer = currentRadius

        self.UTILS:debugInfo("AETHR.ZONE_MANAGER:spawnTownsExpandingCircle | Iteration " .. tostring(i) ..
            " | center: (" ..
            tostring(center.x) ..
            "," .. tostring(center.y) .. ") ring: [" .. tostring(inner) .. "," .. tostring(outer) .. "]" ..
            " chance: " .. tostring(currentChance))

        -- Use annulus to avoid overlap with prior iterations
        self:spawnTownsCircle(
            center,
            currentRadius,
            countryID,
            minR,
            maxR,
            dynamicSpawner,
            currentChance,
            inner,
            outer
        )

        prevOuter = currentRadius
    end

    return self
end

--- Spawns airbase filler groups in towns near for all airbases across all zones using SPAWNER.
--- Uses RED and BLUE Start Zones to determine country of spawns for airbase towns.
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:spawnTownsAtAirbasesAllZones(initialRadius, dynamicSpawner, minTownRadius,
                                                         maxTownRadius, spawnChance, concentricSpawnChanceMultiplier,
                                                         concentricRadiusMultipier, concentricIterations)
    local redZones = self.CONFIG.MAIN.MIZ_ZONES.REDSTART
    local blueZones = self.CONFIG.MAIN.MIZ_ZONES.BLUESTART
    local redCountry = self.CONFIG.MAIN.DefaultRedCountry
    local blueCountry = self.CONFIG.MAIN.DefaultBlueCountry
    local zones = self.DATA.MIZ_ZONES
    local radius = initialRadius or 5000
    dynamicSpawner = dynamicSpawner or nil
    minTownRadius = minTownRadius or 300
    maxTownRadius = maxTownRadius or nil
    spawnChance = spawnChance or 0.5
    concentricSpawnChanceMultiplier = concentricSpawnChanceMultiplier or 0.4
    concentricRadiusMultipier = concentricRadiusMultipier or 2
    concentricIterations = concentricIterations or 3

    local function _spawn(zoneObj, zoneName, countryID)
        self.UTILS:debugInfo("Zone: " .. zoneName)
        local airbases_ = zoneObj.Airbases
        for name, abObj in pairs(airbases_) do
            self.UTILS:debugInfo("Airbase: " .. name)
            local vec2 = { x = abObj.coordinates.x, y = abObj.coordinates.z }
            self:spawnTownsExpandingCircle(vec2, radius, countryID, minTownRadius, maxTownRadius,
                dynamicSpawner, spawnChance, concentricSpawnChanceMultiplier, concentricRadiusMultipier,
                concentricIterations)
        end
    end

    for _, zName in ipairs(redZones) do
        local zoneObj_ = zones[zName]
        _spawn(zoneObj_, zName, redCountry)
    end
    for _, zName in ipairs(blueZones) do
        local zoneObj_ = zones[zName]
        _spawn(zoneObj_, zName, blueCountry)
    end

    return self
end
