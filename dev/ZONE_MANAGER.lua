--- @class AETHR.ZONE_MANAGER
--- @brief Manages mission trigger zones and computes bordering relationships.
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field DATA table Container for zone management data.
--- @field DATA.MIZ_ZONES table<string, _MIZ_ZONE> Loaded mission trigger zones.
AETHR.ZONE_MANAGER = {} ---@diagnostic disable-line

AETHR.ZONE_MANAGER.DATA = {
    MIZ_ZONES = {},    -- Mission trigger zones keyed by name.
}


function AETHR.ZONE_MANAGER:New(parent)
    local instance = {
        AETHR = parent,
        -- submodule-local caches/state can be initialized here
        _cache = {},
    }
    setmetatable(instance, { __index = self })
    return instance
end

--- Sets mission trigger zone names (all, red and blue start).
--- @function AETHR:setMizZones
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
--- @function AETHR:setRedStartMizZones
--- @param zoneNames string[] List of Red start mission trigger zone names.
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:setRedStartMizZones(zoneNames)
    self.CONFIG.MAIN.MIZ_ZONES.REDSTART = zoneNames or {}
    return self
end

--- Sets Blue start mission trigger zones.
--- @function AETHR:setBlueStartMizZones
--- @param zoneNames string[] List of Blue start mission trigger zone names.
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:setBlueStartMizZones(zoneNames)
    self.CONFIG.MAIN.MIZ_ZONES.BLUESTART = zoneNames or {}
    return self
end

--- Initializes mission trigger zone data, loading existing or generating defaults.
--- @function AETHR:initMizZoneData
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:initMizZoneData()
    local data = self:getStoredMizZoneData()
    if data then
        self.DATA.MIZ_ZONES = data
    else
        self:generateMizZoneData()
        self:saveMizZoneData()
    end
    return self
end

--- Loads mission trigger zone data from storage file if available.
--- @function AETHR:getStoredMizZoneData
--- @return table<string, _MIZ_ZONE>|nil Data table of mission trigger zones or nil if not found.
function AETHR.ZONE_MANAGER:getStoredMizZoneData()
    local mapPath = self.CONFIG.MAIN.STORAGE.PATHS.MAP_FOLDER
    local saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.MIZ_ZONES_FILE
    local data = self.FILEOPS:loadData(mapPath, saveFile)
    if data then return data end
    return nil
end

--- Saves current mission trigger zone data to storage file.
--- @function AETHR:saveMizZoneData
--- @return nil
function AETHR.ZONE_MANAGER:saveMizZoneData()
    local mapPath = self.CONFIG.MAIN.STORAGE.PATHS.MAP_FOLDER
    local saveFile = self.CONFIG.MAIN.STORAGE.FILENAMES.MIZ_ZONES_FILE
    self.FILEOPS:saveData(mapPath, saveFile, self.DATA.MIZ_ZONES)
end

--- Generates mission trigger zone data based on configured zone names and environment data.
--- Guards against missing env structures and missing constructors.
--- @function AETHR:generateMizZoneData
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
                self.DATA.MIZ_ZONES[zoneName] = mzCtor:New(envZone)
                break
            end
        end
    end
    self.DATA.MIZ_ZONES = self:determineBorderingZones(self.DATA.MIZ_ZONES)
    return self
end

--- Determine bordering zones.
--- @param MIZ_ZONES table<string, _MIZ_ZONE> Map of mission trigger zones.
--- @return table Updated MIZ_ZONES with .BorderingZones populated.
function AETHR.ZONE_MANAGER:determineBorderingZones(MIZ_ZONES)
    --- @type AETHR.POLY
    local POLY = self.POLY
    for zoneName1, zone1 in pairs(MIZ_ZONES) do
        for zoneName2, zone2 in pairs(MIZ_ZONES) do
            -- Ensure we're not comparing a zone with itself
            if zoneName1 ~= zoneName2 then
                local borderIndex = 0 -- Initialize index for potential borders

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
                            if POLY:PointWithinShape(_ZoneLinePerpendicularPoint, MIZ_ZONES[zoneName1].verticies) then
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

function AETHR.ZONE_MANAGER:drawZone(coalition, fillColor, borderColor, linetype, cornerVec2s,markerID)
    local r1, g1, b1, a1 = fillColor.r, fillColor.g, fillColor.b, fillColor.a          --  RGBA components Fill
    local r2, g2, b2, a2 = borderColor.r, borderColor.g, borderColor.b, borderColor.a  --  RGBA components Fill
    local shapeTypeID    = 7                                                           --  Polygon shape type
    local vec3_1         = { x = cornerVec2s[4].x, y = 0, z = cornerVec2s[4].y }
    local vec3_2         = { x = cornerVec2s[3].x, y = 0, z = cornerVec2s[3].y }
    local vec3_3         = { x = cornerVec2s[2].x, y = 0, z = cornerVec2s[2].y }
    local vec3_4         = { x = cornerVec2s[1].x, y = 0, z = cornerVec2s[1].y }

    -- Draw polygon on map
    trigger.action.markupToAll(
        shapeTypeID, coalition, markerID,
        vec3_1,
        vec3_2,
        vec3_3,
        vec3_4,
        { r2, g2, b2, a2 },     -- Border color
        { r1, g1, b1, a1 },     -- Fill color
        linetype, true
    )
    return self
end

--- Draws a polygon with an arbitrary number of vec2 vertices.
--- Supported call forms:
---   drawPolygon(coalition, fillColor, borderColor, linetype, markerID, {v1, v2, v3, ...})
---   drawPolygon(coalition, fillColor, borderColor, linetype, markerID, v1, v2, v3, ...)
--- markerID may be nil (defaults to 0).
function AETHR.ZONE_MANAGER:drawPolygon(coalition, fillColor, borderColor, linetype, markerID, ...)
    local varargs = { ... }
    -- If no vertices provided, nothing to draw
    if not varargs or #varargs == 0 then
        return self
    end

    -- Normalize corners: support either a single array/table of vec2s or multiple vec2 args
    local corners = {}
    if #varargs == 1 and type(varargs[1]) == "table" and not (varargs[1].x and varargs[1].y) then
        -- single array-like table of vec2s
        corners = varargs[1]
    else
        corners = varargs
    end

    -- Need at least 3 vertices to draw a polygon
    if not corners or #corners < 3 then
        return self
    end

    local r1, g1, b1, a1 = fillColor.r, fillColor.g, fillColor.b, fillColor.a          -- Fill color RGBA
    local r2, g2, b2, a2 = borderColor.r, borderColor.g, borderColor.b, borderColor.a  -- Border color RGBA
    local shapeTypeID    = 7                                                           -- Polygon shape type
    markerID = markerID or 0

    -- Build argument list for trigger.action.markupToAll:
    -- shapeTypeID, coalition, markerID, <vec3 points...>, borderColor, fillColor, linetype, true
    local margs = { shapeTypeID, coalition, markerID }

    -- Preserve original drawZone orientation by reversing corner order
    for i = #corners, 1, -1 do
        local v = corners[i]
        table.insert(margs, { x = v.x, y = 0, z = v.y })
    end

    table.insert(margs, { r2, g2, b2, a2 })     -- Border color
    table.insert(margs, { r1, g1, b1, a1 })     -- Fill color
    table.insert(margs, linetype)
    table.insert(margs, true)

    -- Call markupToAll with the constructed argument list (support both table.unpack and unpack)
    -- if table.unpack then
    --     trigger.action.markupToAll(table.unpack(margs))
    -- else
        trigger.action.markupToAll(unpack(margs))
    -- end

    return self
end


function AETHR.ZONE_MANAGER:_buildBorderExclude(zonesTable)
    local function keyFor(p) return string.format("%.6f,%.6f", p.x, p.y or p.z) end
    local exclude = {}
    for zname, mz in pairs(zonesTable or {}) do
        if mz and mz.BorderingZones then
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

function AETHR.ZONE_MANAGER:_collectPolygonsFromZones(zonesTable, exclude)
    local polygons = {}
    for zname, mz in pairs(zonesTable or {}) do
        local verts = mz.verticies or mz.vertices or mz.Vertices or mz.Verticies
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
            local verts = mz and (mz.verticies or mz.vertices or mz.Vertices or mz.Verticies) or nil
            if verts then
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

function AETHR.ZONE_MANAGER:_processHullLoop(hull, polygons, worldBounds, opts, drawParams)
    if not hull or #hull < 3 then return drawParams.markerID end
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
        local len = math.sqrt(dx*dx + dy*dy)
        if len == 0 then
            table.insert(outPoints, { x = (worldBounds.X.min + worldBounds.X.max)/2, y = (worldBounds.Z.min + worldBounds.Z.max)/2 })
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
                    { x = vj.x, y = vj.y },
                    { x = oj.x, y = oj.y },
                    { x = oi.x, y = oi.y },
                }
                table.insert(hullPolys, poly)
                self:drawPolygon(drawParams.coalition, drawParams.fillColor, drawParams.borderColor, drawParams.linetype, drawParams.markerID, poly)
                drawParams.markerID = drawParams.markerID + 1
            end
        end
    end





local centerPoly = self:getPolygonCutout(hullPolys)


-- self:drawPolygon(drawParams.coalition, { r = 0, g = 0, b = 1, a = 0.3 }, { r = 0, g = 0, b = 1, a = 0.6 }, drawParams.linetype, drawParams.markerID, centerPoly)
--                 drawParams.markerID = drawParams.markerID + 1

    return drawParams.markerID
end

function AETHR.ZONE_MANAGER:getMasterPolygon(ChildPolygonTables, gapDistance)
end

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
        local A = 0
        local cx = 0
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
            for _, p in ipairs(pts) do sx = sx + p.x; sy = sy + p.y end
            return { x = sx / #pts, y = sy / #pts }
        end
        return { x = cx / (6 * A), y = cy / (6 * A) }
    end

    -- Normalize input polygons and collect edges
    local pointsByKey = {}
    local undirectedCount = {}           -- key: "A|B" (sorted) -> count
    local anyOriented = {}               -- store one oriented occurrence { from = keyA, to = keyB }
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
            local a,b = ukey:match("([^|]+)|([^|]+)")
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
        if L and L.centroid and outer and outer.points and #outer.points >= 3 then
            -- use POLY:pointInPolygon which expects {x,y} points
            local inside = false
            if self.POLY and self.POLY.pointInPolygon then
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


--- Draws an out-of-bounds convex ring surrounding provided zone vertices.
--- The routine computes a convex hull of the input zone vertices, shoots outward
--- rays from the hull centroid to the world bounds, and constructs quads between
--- each hull edge and its corresponding intersections on the world bounds.
--- This tiles the ring with convex quads and avoids overlapping the inner zone.
--- @function AETHR.ZONE_MANAGER:drawOutOfBounds
--- @param coalition number Coalition id for markup
--- @param fillColor table {r,g,b,a}
--- @param borderColor table {r,g,b,a}
--- @param linetype number Line style id
--- @param markerID number|nil Marker id
--- @param zoneVertices table|nil Array of vec2 vertices ({x,y} or {x,z}). If nil, pulled from self.DATA.MIZ_ZONES.
--- @param worldBounds table|nil Bounds structure with X.min/X.max and Z.min/Z.max. If nil, uses CONFIG.MAIN.worldBounds.Caucasus.
--- @param opts table|nil Options: { samplesPerEdge = int, useHoleSinglePolygon = bool, snapDistance = number } Optional: snapDistance (meters) under which densified samples will be snapped to the nearest original polygon segment to enforce colinearity. Default 0.1.
--- @return AETHR.ZONE_MANAGER self
function AETHR.ZONE_MANAGER:drawOutOfBounds(coalition, fillColor, borderColor, linetype, markerID, worldBounds, opts)
    opts = opts or {}
    local samplesPerEdge = opts.samplesPerEdge or 0
    markerID = markerID or 0

    -- Resolve world bounds (preserve original lookup)
    worldBounds = worldBounds or (self.CONFIG and self.CONFIG.MAIN and self.CONFIG.MAIN.worldBounds and self.CONFIG.MAIN.worldBounds.Caucasus)
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
            local verts = mz and (mz.verticies or mz.vertices or mz.Vertices or mz.Verticies) or nil
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
            self:drawPolygon(coalition, fillColor, borderColor, linetype, markerID, vp)
            return self
        end
        return self
    end

    -- Build hull (concave then convex fallback)
    local initial_k = opts.k or opts.concavity or math.max(3, math.floor(#allPoints * 0.1))
    local hull = nil
    if self.POLY and self.POLY.concaveHull then
        hull = self.POLY:concaveHull(allPoints, { k = initial_k, concavity = opts.concavity })
    end
    if not hull then
        hull = self.POLY:convexHull(allPoints) or nil
    end
    if not hull or #hull < 3 then return self end

    -- Process the hull (single loop)
    local drawParams = { coalition = coalition, fillColor = fillColor, borderColor = borderColor, linetype = linetype, markerID = markerID }
    markerID = self:_processHullLoop(hull, polygons, worldBounds, opts, drawParams)

    return self
end
