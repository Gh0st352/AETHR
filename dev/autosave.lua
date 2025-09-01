--- @module AETHR.AUTOSAVE
--- @brief Utilities for spatial grid indexing and polygon intersection checks to flag active world divisions.
--- @author Gh0st352

AETHR.AUTOSAVE = {}

--- @function AETHR.AUTOSAVE.initGrid
--- @brief Initializes grid metrics (origin and cell sizes) from division corners.
--- @param divs table Array of division objects; each has a `.corners` array of points `{x, z}`.
--- @return table Grid parameters:
---   * minX, minZ - grid origin coordinates
---   * dx, dz - width and height of each cell
---   * invDx, invDz - precomputed inverses for fast lookup
function AETHR.AUTOSAVE.initGrid(divs)
    -- Use first division's corners as reference origin and cell dimensions.
    local c    = divs[1].corners  -- Corner list of first division.
    local minX = c[1].x           -- X-coordinate of grid origin.
    local maxZ = c[1].z           -- Z-coordinate of grid origin.
    local dx   = c[2].x - c[1].x   -- Cell width.
    local dz   = c[4].z - c[1].z   -- Cell height.

    return {
        minX  = minX,
        minZ  = maxZ,
        dx    = dx,
        dz    = dz,
        invDx = 1 / dx,            -- Inverse widths for index computation.
        invDz = 1 / dz,            -- Inverse heights for index computation.
    }
end

--- @function AETHR.AUTOSAVE.buildZoneCellIndex
--- @brief Constructs a mapping of grid cells to zone entries for efficient spatial lookup.
--- @param Zones table Array or map of zone objects, each containing `.verticies` array of points `{x, y}`.
--- @param grid table Grid metrics returned by `initGrid`.
--- @return table cells Nested table `cells[col][row]` containing lists of zone entry tables.
function AETHR.AUTOSAVE.buildZoneCellIndex(Zones, grid)
    local cells = {}

    -- Iterate each zone and compute its bounding cells.
    for _, zone in pairs(Zones) do
        local zminX, zmaxX = math.huge, -math.huge
        local zminZ, zmaxZ = math.huge, -math.huge

        -- Compute raw bounding box in world coordinates.
        for _, v in ipairs(zone.verticies) do
            zminX = math.min(zminX, v.x)
            zmaxX = math.max(zmaxX, v.x)
            zminZ = math.min(zminZ, v.y)
            zmaxZ = math.max(zmaxZ, v.y)
        end

        -- Convert world extremes to grid indices.
        local col0 = math.floor((zminX - grid.minX) * grid.invDx) + 1
        local col1 = math.floor((zmaxX - grid.minX) * grid.invDx) + 1
        local row0 = math.floor((zminZ - grid.minZ) * grid.invDz) + 1
        local row1 = math.floor((zmaxZ - grid.minZ) * grid.invDz) + 1

        -- Prepare polygon for intersection tests.
        local poly = {}
        for _, v in ipairs(zone.verticies) do
            poly[#poly + 1] = { x = v.x, y = v.y }
        end

        local entry = {
            bbox = { minx = zminX, maxx = zmaxX, miny = zminZ, maxy = zmaxZ },
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

    return cells
end

--- @function AETHR.AUTOSAVE.orientation
--- @brief Computes the orientation determinant of three points.
--- @param a table Point `{x, y}`.
--- @param b table Point `{x, y}`.
--- @param c table Point `{x, y}`.
--- @return number >0 if counter-clockwise, <0 if clockwise, 0 if colinear.
function AETHR.AUTOSAVE.orientation(a, b, c)
    return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)
end

--- @function AETHR.AUTOSAVE.onSegment
--- @brief Checks if point `c` lies on segment `[a, b]` inclusive.
--- @param a table Endpoint `{x, y}`.
--- @param c table Point to test `{x, y}`.
--- @param b table Endpoint `{x, y}`.
--- @return boolean True if c lies on segment, false otherwise.
function AETHR.AUTOSAVE.onSegment(a, c, b)
    return c.x >= math.min(a.x, b.x) and c.x <= math.max(a.x, b.x)
       and c.y >= math.min(a.y, b.y) and c.y <= math.max(a.y, b.y)
end

--- @function AETHR.AUTOSAVE.segmentsIntersect
--- @brief Determines if two line segments intersect or touch.
--- @param p1 table First segment endpoint `{x, y}`.
--- @param p2 table First segment endpoint `{x, y}`.
--- @param q1 table Second segment endpoint `{x, y}`.
--- @param q2 table Second segment endpoint `{x, y}`.
--- @return boolean True if segments intersect or touch.
function AETHR.AUTOSAVE.segmentsIntersect(p1, p2, q1, q2)
    local o1 = AETHR.AUTOSAVE.orientation(p1, p2, q1)
    local o2 = AETHR.AUTOSAVE.orientation(p1, p2, q2)
    local o3 = AETHR.AUTOSAVE.orientation(q1, q2, p1)
    local o4 = AETHR.AUTOSAVE.orientation(q1, q2, p2)

    -- Colinear and on-segment checks.
    if o1 == 0 and AETHR.AUTOSAVE.onSegment(p1, q1, p2) then return true end
    if o2 == 0 and AETHR.AUTOSAVE.onSegment(p1, q2, p2) then return true end
    if o3 == 0 and AETHR.AUTOSAVE.onSegment(q1, p1, q2) then return true end
    if o4 == 0 and AETHR.AUTOSAVE.onSegment(q1, p2, q2) then return true end

    -- General intersection case.
    return (o1 > 0 and o2 < 0 or o1 < 0 and o2 > 0)
       and (o3 > 0 and o4 < 0 or o3 < 0 and o4 > 0)
end

--- @function AETHR.AUTOSAVE.pointInPolygon
--- @brief Tests if point lies inside polygon using ray-casting algorithm.
--- @param pt table Point `{x, y}` to test.
--- @param poly table Array of polygon vertices `{x, y}`.
--- @return boolean True if inside, false otherwise.
function AETHR.AUTOSAVE.pointInPolygon(pt, poly)
    local inside = false
    local j = #poly

    -- Cast a horizontal ray and count intersections.
    for i = 1, #poly do
        local xi, yi = poly[i].x, poly[i].y
        local xj, yj = poly[j].x, poly[j].y

        if ((yi > pt.y) ~= (yj > pt.y)) then
            local xint = (xj - xi) * (pt.y - yi) / (yj - yi) + xi
            if xint > pt.x then
                inside = not inside
            end
        end
        j = i
    end

    return inside
end

--- @function AETHR.AUTOSAVE.polygonsOverlap
--- @brief Determines if two polygons overlap by vertex-in-polygon or edge intersection.
--- @param A table Array of vertices `{x, y}` for polygon A.
--- @param B table Array of vertices `{x, y}` for polygon B.
--- @return boolean True if any overlap detected.
function AETHR.AUTOSAVE.polygonsOverlap(A, B)
    -- Check if any A vertex lies in B.
    for _, v in ipairs(A) do
        if AETHR.AUTOSAVE.pointInPolygon(v, B) then return true end
    end
    -- Check if any B vertex lies in A.
    for _, v in ipairs(B) do
        if AETHR.AUTOSAVE.pointInPolygon(v, A) then return true end
    end
    -- Check edge intersections.
    for i = 1, #A do
        local a1, a2 = A[i], A[i % #A + 1]
        for j = 1, #B do
            local b1, b2 = B[j], B[j % #B + 1]
            if AETHR.AUTOSAVE.segmentsIntersect(a1, a2, b1, b2) then
                return true
            end
        end
    end
    return false
end

--- @function AETHR.AUTOSAVE.checkDivisionsInZones
--- @brief Flags divisions as active if they spatially intersect any zone.
--- @param Divisions table Array of division objects with `.corners` points.
--- @param Zones table Indexed cells of zone entries (from `buildZoneCellIndex`).
--- @return table Updated Divisions array with `.active` flags.
function AETHR.AUTOSAVE.checkDivisionsInZones(Divisions, Zones)
    -- Initialize grid and compute zone cell index.
    local grid      = AETHR.AUTOSAVE.initGrid(Divisions)
    local zoneCells = AETHR.AUTOSAVE.buildZoneCellIndex(Zones, grid)

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
                if AETHR.AUTOSAVE.polygonsOverlap(divPoly, entry.poly) then
                    div.active = true
                    break
                end
            end
        end
    end

    return Divisions
end
