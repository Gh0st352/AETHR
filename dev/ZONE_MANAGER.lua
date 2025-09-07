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
--- @param opts table|nil Options: { samplesPerEdge = int, useHoleSinglePolygon = bool }
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

    -- Gather zone vertices if not provided
    -- Accept either:
    --  * nil -> gather from self.DATA.MIZ_ZONES
    --  * flat array of vec2s -> { {x=..,y=..}, ... }
    --  * array of polygons -> { { {x=..,y=..}, ... }, { ... } }
    local points = {}
    if not zoneVertices then
        for _, mz in pairs(self.DATA.MIZ_ZONES or {}) do
            local verts = mz.verticies or mz.vertices or mz.Vertices or mz.Verticies
            if verts and #verts > 0 then
                for _, v in ipairs(verts) do
                    table.insert(points, { x = v.x, y = v.z or v.y })
                end
            end
        end
    else
        -- Detect whether zoneVertices is a list of polygons (each entry is a table of points)
        if #zoneVertices > 0 and type(zoneVertices[1]) == "table" and zoneVertices[1][1] and type(zoneVertices[1][1]) == "table" then
            -- zoneVertices is an array of polygons; flatten all polygon points
            for _, poly in ipairs(zoneVertices) do
                if poly and type(poly) == "table" then
                    for _, v in ipairs(poly) do
                        if v and (v.x or v.y or v.z) then
                            table.insert(points, { x = v.x, y = v.y or v.z })
                        end
                    end
                end
            end
        else
            -- zoneVertices is a flat array of vec2s
            for _, v in ipairs(zoneVertices) do
                if v and (v.x or v.y or v.z) then
                    table.insert(points, { x = v.x, y = v.y or v.z })
                end
            end
        end
    end

    if #points < 3 then
        return self
    end

    -- Deduplicate points (string-key based)
    local uniq = {}
    local clean = {}
    for _, p in ipairs(points) do
        local key = tostring(p.x) .. "," .. tostring(p.y)
        if not uniq[key] then
            uniq[key] = true
            table.insert(clean, { x = p.x, y = p.y })
        end
    end
    points = clean

    -- Convex hull (Monotone chain / Andrew)
    local function cross(a, b, c)
        -- use MATH:crossProduct which accepts .x and .y/.z
        return self.MATH:crossProduct(a, b, { x = c.x, y = c.y })
    end

    table.sort(points, function(a, b)
        if a.x == b.x then return a.y < b.y end
        return a.x < b.x
    end)

    local lower, upper = {}, {}
    for i = 1, #points do
        while #lower >= 2 and cross(lower[#lower-1], lower[#lower], points[i]) <= 0 do
            table.remove(lower)
        end
        table.insert(lower, points[i])
    end
    for i = #points, 1, -1 do
        while #upper >= 2 and cross(upper[#upper-1], upper[#upper], points[i]) <= 0 do
            table.remove(upper)
        end
        table.insert(upper, points[i])
    end

    -- Concatenate lower and upper to get full hull, removing duplicate endpoints
    local hull = {}
    for i = 1, #lower do table.insert(hull, lower[i]) end
    for i = 2, #upper-1 do table.insert(hull, upper[i]) end

    if #hull < 3 then
        return self
    end

    -- Optionally densify hull edges
    if samplesPerEdge and samplesPerEdge > 0 then
        local densified = {}
        for i = 1, #hull do
            local j = (i % #hull) + 1
            table.insert(densified, hull[i])
            local line = { { x = hull[i].x, y = hull[i].y }, { x = hull[j].x, y = hull[j].y } }
            local samples = self.POLY:getEquallySpacedPoints(line, samplesPerEdge)
            for _, s in ipairs(samples) do
                table.insert(densified, { x = s.x, y = s.y })
            end
        end
        hull = densified
    end

    -- Compute centroid of hull
    local cx, cy = 0, 0
    for _, v in ipairs(hull) do
        cx = cx + v.x
        cy = cy + v.y
    end
    cx = cx / #hull
    cy = cy / #hull

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
                -- try opposite direction (shouldn't happen often)
                ip = intersectRayToBounds(v, { x = -dir.x, y = -dir.y }, worldBounds)
            end
            if ip then
                table.insert(outPoints, ip)
            else
                -- as a last resort clamp to nearest bound box corner
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

        -- Validate uniqueness and area to avoid degenerate polygons
        if oi and oj then
            -- Skip if any two consecutive outer points are identical
            if not (math.abs(oi.x - oj.x) < 1e-6 and math.abs(oi.y - oj.y) < 1e-6) then
                local poly = {
                    { x = vi.x, y = vi.y },
                    { x = vj.x, y = vj.y },
                    { x = oj.x, y = oj.y },
                    { x = oi.x, y = oi.y },
                }
                -- Convert to expected vec2 form (x,y) is fine; drawPolygon will convert to vec3
                self:drawPolygon(coalition, fillColor, borderColor, linetype, markerID, poly)
                markerID = markerID + 1
            end
        end
    end

    return self
end
