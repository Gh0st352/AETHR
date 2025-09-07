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
function AETHR.ZONE_MANAGER:drawOutOfBounds(coalition, fillColor, borderColor, linetype, markerID, zoneVertices, worldBounds, opts)
    opts = opts or {}
    local samplesPerEdge = opts.samplesPerEdge or 0
    markerID = markerID or 0

    -- Resolve world bounds
    worldBounds = worldBounds or (self.CONFIG and self.CONFIG.MAIN and self.CONFIG.MAIN.worldBounds and self.CONFIG.MAIN.worldBounds.Caucasus)
    if not worldBounds then
        -- Nothing to draw without bounds
        return self
    end

    -- Gather zone vertices into polygons list.
    -- Supported inputs:
    --  * nil -> use self.DATA.MIZ_ZONES (zone objects)
    --  * zone table mapping (zoneName -> zone object) -> use provided MIZ_ZONES-like table
    --  * array of polygons -> { { {x=..,y=..}, ... }, ... }
    --  * flat array of vec2s -> { {x=..,y=..}, ... } (treated as single polygon)
    local polygons = {}

    local function isZoneObjectTable(t)
        if type(t) ~= "table" then return false end
        for _, v in pairs(t) do
            if type(v) == "table" and (v.verticies or v.vertices or v.LinesVec2 or v.BorderingZones) then
                return true
            end
            break
        end
        return false
    end

    local zonesTable = self.DATA.MIZ_ZONES
    -- if not zoneVertices then
    --     zonesTable = self.DATA.MIZ_ZONES or {}
    -- elseif isZoneObjectTable(zoneVertices) then
    --     zonesTable = zoneVertices
    -- else
    --     -- zoneVertices is either an array of polygons or a flat array of vec2s
    --     if #zoneVertices > 0 and type(zoneVertices[1]) == "table" and zoneVertices[1][1] and type(zoneVertices[1][1]) == "table" then
    --         -- array of polygons already
    --         for _, poly in ipairs(zoneVertices) do
    --             local pcopy = {}
    --             for _, v in ipairs(poly) do
    --                 table.insert(pcopy, { x = v.x, y = v.y or v.z })
    --             end
    --             table.insert(polygons, pcopy)
    --         end
    --     else
    --         -- flat array of vec2s -> treat as single polygon
    --         local pcopy = {}
    --         for _, v in ipairs(zoneVertices) do
    --             table.insert(pcopy, { x = v.x, y = v.y or v.z })
    --         end
    --         table.insert(polygons, pcopy)
    --     end
    -- end

    -- If we have zone objects (zonesTable), build an exclude set from any BorderingZones
    if zonesTable then
        local function keyFor(p) return string.format("%.6f,%.6f", p.x, p.y or p.z) end

        local exclude = {}
        for zname, mz in pairs(zonesTable) do
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

        -- Collect vertices from all zones but exclude any vertex that is part of a bordering edge
        for zname, mz in pairs(zonesTable) do
            local verts = mz.verticies or mz.vertices or mz.Vertices or mz.Verticies
            if verts and #verts > 0 then
                local poly = {}
                for _, v in ipairs(verts) do
                    local x = v.x
                    local y = v.y or v.z
                    if not exclude[keyFor({ x = x, y = y })] then
                        table.insert(poly, { x = x, y = y })
                    end
                end
                if #poly >= 3 then table.insert(polygons, poly) end
            end
        end
    end

    -- Need at least one polygon with >=3 points
    local validPolyCount = 0
    for _, poly in ipairs(polygons) do
        if poly and #poly >= 3 then validPolyCount = validPolyCount + 1 end
    end
    if validPolyCount == 0 then
        -- Fallback: collect vertices from zonesTable ignoring excluded border points so we always have geometry to work with.
        local flat = {}
        if zonesTable then
            for zname, mz in pairs(zonesTable) do
                local verts = mz.verticies or mz.vertices or mz.Vertices or mz.Verticies
                if verts and #verts > 0 then
                    for _, v in ipairs(verts) do
                        local x = v.x
                        local y = v.y or v.z
                        table.insert(flat, { x = x, y = y })
                    end
                end
            end
        end

        -- If still empty, try flattening any polygons that might exist (defensive)
        if #flat == 0 then
            for _, poly in ipairs(polygons) do
                for _, p in ipairs(poly) do
                    table.insert(flat, { x = p.x, y = p.y })
                end
            end
        end

        if #flat >= 3 then
            table.insert(polygons, flat)
        else
            -- Nothing usable to draw
            return self
        end
    end

    -- Build a concave "shrinkwrap" (k-nearest heuristic) around all polygon vertices.
    -- Flatten unique points from all polygons
    local allPoints = {}
    local uniqp = {}
    for _, poly in ipairs(polygons) do
        for _, p in ipairs(poly) do
            local key = string.format("%.6f,%.6f", p.x, p.y)
            if not uniqp[key] then
                uniqp[key] = true
                table.insert(allPoints, { x = p.x, y = p.y })
            end
        end
    end

    -- If not enough points after removing bordering vertices, fall back to using all zone vertices (ignoring exclude)
    if #allPoints < 3 then
        local fallback = {}
        for zname, mz in pairs(zonesTable or {}) do
            local verts = mz and (mz.verticies or mz.vertices or mz.Vertices or mz.Verticies) or nil
            if verts then
                for _, v in ipairs(verts) do
                    local key = string.format("%.6f,%.6f", v.x, v.y or v.z)
                    if not uniqp[key] then
                        uniqp[key] = true
                        table.insert(fallback, { x = v.x, y = v.y or v.z })
                    end
                end
            end
        end
        for _, p in ipairs(fallback) do table.insert(allPoints, p) end
    end

    -- If still insufficient points, draw world bounds rectangle as a visible fallback
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

    -- Helpers
    local function ptEqual(a, b)
        return math.abs(a.x - b.x) < 1e-9 and math.abs(a.y - b.y) < 1e-9
    end

    local function pointInArray(pt, arr)
        for _, q in ipairs(arr) do if ptEqual(pt, q) then return true end end
        return false
    end

    local function kNearest(pt, pts, k)
        local list = {}
        for _, p in ipairs(pts) do
            if not ptEqual(p, pt) then
                local dx = p.x - pt.x
                local dy = p.y - pt.y
                table.insert(list, { p = p, d = dx*dx + dy*dy })
            end
        end
        table.sort(list, function(a, b) return a.d < b.d end)
        local res = {}
        for i = 1, math.min(k, #list) do table.insert(res, list[i].p) end
        return res
    end

    local function angle(prev, cur, cand)
        local v1x = cur.x - prev.x; local v1y = cur.y - prev.y
        local v2x = cand.x - cur.x; local v2y = cand.y - cur.y
        local a1 = math.atan2(v1y, v1x); local a2 = math.atan2(v2y, v2x)
        local d = a2 - a1
        if d <= -math.pi then d = d + 2 * math.pi end
        if d > math.pi then d = d - 2 * math.pi end
        if d < 0 then d = d + 2 * math.pi end
        return d
    end

    local function segmentIntersectsExisting(a, b, hull)
        for i = 1, #hull - 1 do
            local c = hull[i]; local d = hull[i + 1]
            if not (ptEqual(c, a) or ptEqual(d, a) or ptEqual(c, b) or ptEqual(d, b)) then
                if self.POLY:segmentsIntersect(a, b, c, d) then return true end
            end
        end
        return false
    end

    -- Build concave hull using k-nearest heuristic. If it fails or does not enclose all points,
    -- increase k and retry. Returns hull array or nil.
    local function buildConcave(pts, k)
        local N = #pts
        if N < 3 then return nil end
        k = math.max(3, k or 3)
        if k > N - 1 then k = N - 1 end

        while true do
            local hull = {}
            -- starting point: leftmost, then lowest y
            local startIdx = 1
            for i = 2, N do
                if pts[i].x < pts[startIdx].x or (pts[i].x == pts[startIdx].x and pts[i].y < pts[startIdx].y) then
                    startIdx = i
                end
            end

            local current = { x = pts[startIdx].x, y = pts[startIdx].y }
            table.insert(hull, current)
            local prev = { x = current.x - 1, y = current.y } -- initial heading to the right (east)
            local step = 1
            local finished = false
            local safety = 0

            while not finished do
                safety = safety + 1
                if safety > 10000 then return nil end

                local neighbors = kNearest(current, pts, k)
                table.sort(neighbors, function(a, b) return angle(prev, current, a) < angle(prev, current, b) end)

                local found = nil
                for _, cand in ipairs(neighbors) do
                    if ptEqual(cand, hull[1]) and step >= 3 then
                        if not segmentIntersectsExisting(current, cand, hull) then found = cand; break end
                    elseif not pointInArray(cand, hull) then
                        if not segmentIntersectsExisting(current, cand, hull) then found = cand; break end
                    end
                end

                if not found then
                    -- increase k and restart attempt
                    k = k + 1
                    if k > N - 1 then return nil end
                    break
                end

                if ptEqual(found, hull[1]) then
                    table.insert(hull, found)
                    finished = true
                    break
                else
                    table.insert(hull, found)
                    prev = current
                    current = found
                    step = step + 1
                end
            end

            if finished then
                -- remove duplicate trailing point if present
                if #hull > 1 and ptEqual(hull[1], hull[#hull]) then table.remove(hull) end

                -- verify all points are inside the hull
                local allInside = true
                for _, p in ipairs(pts) do
                    if not self.POLY:pointInPolygon(p, hull) then
                        allInside = false
                        break
                    end
                end
                if allInside then
                    return hull
                else
                    k = k + 1
                    if k > N - 1 then return nil end
                end
            end
            if k > N - 1 then return nil end
        end
    end

    -- initial k: from opts.k or opts.concavity or 10% of points (bounded)
    local initial_k = opts.k or opts.concavity or math.max(3, math.floor(#allPoints * 0.1))
    local hull = buildConcave(allPoints, initial_k)

    if not hull then
        -- fallback to convex hull (monotone chain)
        local points = {}
        for _, p in ipairs(allPoints) do table.insert(points, { x = p.x, y = p.y }) end
        table.sort(points, function(a, b) if a.x == b.x then return a.y < b.y end return a.x < b.x end)
        local function cross(a, b, c) return self.MATH:crossProduct(a, b, { x = c.x, y = c.y }) end
        local lower, upper = {}, {}
        for i = 1, #points do
            while #lower >= 2 and cross(lower[#lower - 1], lower[#lower], points[i]) <= 0 do table.remove(lower) end
            table.insert(lower, points[i])
        end
        for i = #points, 1, -1 do
            while #upper >= 2 and cross(upper[#upper - 1], upper[#upper], points[i]) <= 0 do table.remove(upper) end
            table.insert(upper, points[i])
        end
        local ch = {}
        for i = 1, #lower do table.insert(ch, lower[i]) end
        for i = 2, #upper - 1 do table.insert(ch, upper[i]) end
        hull = ch
    end

    -- Expose hull as the single loop to process (shrinkwrap)
    -- Intersect ray from point in direction (point - centroid) against world bounds rectangle
    local function intersectRayToBounds(pt, dir, bounds)
        local candidates = {}
        local eps = 1e-12

        -- X edges
        if math.abs(dir.x) > eps then
            for _, edgeX in ipairs({ bounds.X.min, bounds.X.max }) do
                local t = (edgeX - pt.x) / dir.x
                if t > 0 then
                    local y = pt.y + t * dir.y
                    if y >= bounds.Z.min - eps and y <= bounds.Z.max + eps then
                        table.insert(candidates, { t = t, x = edgeX, y = y })
                    end
                end
            end
        end

        -- Z edges (mapped to y)
        if math.abs(dir.y) > eps then
            for _, edgeZ in ipairs({ bounds.Z.min, bounds.Z.max }) do
                local t = (edgeZ - pt.y) / dir.y
                if t > 0 then
                    local x = pt.x + t * dir.x
                    if x >= bounds.X.min - eps and x <= bounds.X.max + eps then
                        table.insert(candidates, { t = t, x = x, y = edgeZ })
                    end
                end
            end
        end

        if #candidates == 0 then return nil end
        table.sort(candidates, function(a, b) return a.t < b.t end)
        return { x = candidates[1].x, y = candidates[1].y }
    end

    local loops = {}
    if hull and #hull >= 3 then
        table.insert(loops, hull)
    else
        return self
    end

    -- Process each stitched loop (there may be multiple disjoint loops).
    local function processLoop(loop)
        -- Build hull from the loop's points
        local hull = {}
        for _, p in ipairs(loop) do table.insert(hull, { x = p.x, y = p.y }) end
        if #hull < 3 then return end

        -- Optionally densify hull edges
        if samplesPerEdge and samplesPerEdge > 0 then
            local origLines = nil
            local densified = {}
            for i = 1, #hull do
                local j = (i % #hull) + 1
                table.insert(densified, hull[i])
                local line = { { x = hull[i].x, y = hull[i].y }, { x = hull[j].x, y = hull[j].y } }
                local samples = self.POLY:getEquallySpacedPoints(line, samplesPerEdge)
                -- Attempt to snap each sample to the nearest original polygon segment, if within tolerance.
                for _, s in ipairs(samples) do
                    -- build origLines on first use
                    if not origLines then
                        origLines = {}
                        for _, poly in ipairs(polygons) do
                            local segs = self.POLY:convertPolygonToLines(poly)
                            for _, seg in ipairs(segs) do table.insert(origLines, seg) end
                        end
                    end

                    local bestLine = nil
                    local bestDist2 = math.huge
                    for _, ln in ipairs(origLines) do
                        local ax, ay = ln[1].x, ln[1].y
                        local bx, by = ln[2].x, ln[2].y
                        local d2 = self.POLY:pointToSegmentSquared(s.x, s.y, ax, ay, bx, by)
                        if d2 < bestDist2 then
                            bestDist2 = d2
                            bestLine = ln
                        end
                    end

                    -- tolerance (meters) under which we snap samples to original polygon segments
                    local snapDistance = (opts and opts.snapDistance) and opts.snapDistance or 0.1
                    local snapThreshold2 = snapDistance * snapDistance

                    if bestLine and bestDist2 <= snapThreshold2 then
                        -- project sample onto bestLine
                        local ax, ay = bestLine[1].x, bestLine[1].y
                        local bx, by = bestLine[2].x, bestLine[2].y
                        local l2 = self.MATH:distanceSquared(ax, ay, bx, by)
                        local t = 0
                        if l2 > 0 then
                            t = self.MATH:dot(s.x - ax, s.y - ay, bx - ax, by - ay) / l2
                            if t < 0 then t = 0 end
                            if t > 1 then t = 1 end
                        end
                        local projx = ax + t * (bx - ax)
                        local projy = ay + t * (by - ay)
                        table.insert(densified, { x = projx, y = projy })
                    else
                        table.insert(densified, { x = s.x, y = s.y })
                    end
                end
            end
            hull = densified
        end

        -- Compute centroid of this hull
        local cx, cy = 0, 0
        for _, v in ipairs(hull) do
            cx = cx + v.x
            cy = cy + v.y
        end
        cx = cx / #hull
        cy = cy / #hull

        -- For each hull vertex compute outward intersection point
        local outPoints = {}
        for _, v in ipairs(hull) do
            local dx = v.x - cx
            local dy = v.y - cy
            local len = math.sqrt(dx*dx + dy*dy)
            if len == 0 then
                -- fallback: push to middle of world bounds
                table.insert(outPoints, { x = (worldBounds.X.min + worldBounds.X.max)/2, y = (worldBounds.Z.min + worldBounds.Z.max)/2 })
            else
                local dir = { x = dx / len, y = dy / len }
                local ip = intersectRayToBounds(v, dir, worldBounds)
                if not ip then
                    ip = intersectRayToBounds(v, { x = -dir.x, y = -dir.y }, worldBounds)
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

        -- Build and draw quads between hull edges and their outer intersections
        for i = 1, #hull do
            local j = (i % #hull) + 1
            local vi = hull[i]
            local vj = hull[j]
            local oi = outPoints[i]
            local oj = outPoints[j]

            if oi and oj then
                if not (math.abs(oi.x - oj.x) < 1e-6 and math.abs(oi.y - oj.y) < 1e-6) then
                    local poly = {
                        { x = vi.x, y = vi.y },
                        { x = vj.x, y = vj.y },
                        { x = oj.x, y = oj.y },
                        { x = oi.x, y = oi.y },
                    }
                    self:drawPolygon(coalition, fillColor, borderColor, linetype, markerID, poly)
                    markerID = markerID + 1
                end
            end
        end
    end

    -- Process all loops so every provided zone contributes to the inner hole(s)
    for _, loop in ipairs(loops) do
        processLoop(loop)
    end

    return self
end
