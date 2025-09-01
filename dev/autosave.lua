--- @module AETHR.AUTOSAVE
--- @brief Provides utilities for spatial grid indexing and polygon intersection checks to determine active world divisions.

AETHR.AUTOSAVE = {}

--- Initializes a spatial grid based on the first division's corner coordinates.
--- @param divs table Array of division objects; each has a `.corners` array of points {x,z}.
--- @return table Grid metrics: minX, minZ, dx, dz, invDx, invDz.
function AETHR.AUTOSAVE.initGrid(divs)
    local c    = divs[1].corners  -- Corner list of first division
    local minX = c[1].x           -- Western boundary
    local maxZ = c[1].z           -- Southern boundary
    local dx   = c[2].x - c[1].x   -- Width of one grid cell
    local dz   = c[4].z - c[1].z   -- Height of one grid cell
    return {
        minX  = minX,
        minZ  = maxZ,
        dx    = dx,
        dz    = dz,
        invDx = 1 / dx,            -- Precompute inverses for performance
        invDz = 1 / dz,
    }
end

--- Builds an index mapping grid cells to zone entries for efficient lookup.
--- @param Zones table Array or map of zone objects, each with `.verticies`.
--- @param grid table Grid metrics returned by `initGrid`.
--- @return table cells[cellX][cellZ] = { entries... }
function AETHR.AUTOSAVE.buildZoneCellIndex(Zones, grid)
    local cells = {}
    -- Iterate each zone and compute its bounding box in grid coordinates
    for _, zone in pairs(Zones) do
        local zminX, zmaxX = math.huge, -math.huge
        local zminZ, zmaxZ = math.huge, -math.huge
        -- Find raw coordinate extremes
        for _, v in ipairs(zone.verticies) do
            local x, z = v.x, v.y
            zminX = math.min(zminX, x); zmaxX = math.max(zmaxX, x)
            zminZ = math.min(zminZ, z); zmaxZ = math.max(zmaxZ, z)
        end
        -- Convert to grid indices
        local col0 = math.floor((zminX - grid.minX) * grid.invDx) + 1
        local col1 = math.floor((zmaxX - grid.minX) * grid.invDx) + 1
        local row0 = math.floor((zminZ - grid.minZ) * grid.invDz) + 1
        local row1 = math.floor((zmaxZ - grid.minZ) * grid.invDz) + 1

        -- Create polygon copy for intersection tests
        local poly = {}
        for _, v in ipairs(zone.verticies) do
            poly[#poly + 1] = { x = v.x, y = v.y }
        end

        local entry = {
            bbox = { minx = zminX, maxx = zmaxX, miny = zminZ, maxy = zmaxZ },
            poly = poly,
        }

        -- Populate each covered cell
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

--- Computes orientation determinant of three points.
--- @param a table Point with x,y
--- @param b table Point with x,y
--- @param c table Point with x,y
--- @return number Positive if counter-clockwise, negative if clockwise, zero if colinear
function AETHR.AUTOSAVE.orientation(a, b, c)
    return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)
end

--- Checks if point c lies on segment [a,b].
--- @param a table Endpoint a
--- @param c table Candidate point
--- @param b table Endpoint b
--- @return boolean True if c is on segment, false otherwise
function AETHR.AUTOSAVE.onSegment(a, c, b)
    return c.x >= math.min(a.x, b.x) and c.x <= math.max(a.x, b.x)
       and c.y >= math.min(a.y, b.y) and c.y <= math.max(a.y, b.y)
end

--- Determines if two line segments (p1-p2 and q1-q2) intersect.
--- @param p1 table Endpoint of first segment
--- @param p2 table Endpoint of first segment
--- @param q1 table Endpoint of second segment
--- @param q2 table Endpoint of second segment
--- @return boolean True if segments intersect or touch
function AETHR.AUTOSAVE.segmentsIntersect(p1, p2, q1, q2)
    local o1 = AETHR.AUTOSAVE.orientation(p1, p2, q1)
    local o2 = AETHR.AUTOSAVE.orientation(p1, p2, q2)
    local o3 = AETHR.AUTOSAVE.orientation(q1, q2, p1)
    local o4 = AETHR.AUTOSAVE.orientation(q1, q2, p2)
    -- Check colinear cases
    if o1 == 0 and AETHR.AUTOSAVE.onSegment(p1, q1, p2) then return true end
    if o2 == 0 and AETHR.AUTOSAVE.onSegment(p1, q2, p2) then return true end
    if o3 == 0 and AETHR.AUTOSAVE.onSegment(q1, p1, q2) then return true end
    if o4 == 0 and AETHR.AUTOSAVE.onSegment(q1, p2, q2) then return true end
    -- General intersection test
    return (o1 > 0 and o2 < 0 or o1 < 0 and o2 > 0)
       and (o3 > 0 and o4 < 0 or o3 < 0 and o4 > 0)
end

--- Determines if a point lies inside a polygon using ray casting algorithm.
--- @param pt table Point to test with x,y
--- @param poly table Array of points {x,y}
--- @return boolean True if inside, false otherwise
function AETHR.AUTOSAVE.pointInPolygon(pt, poly)
    local inside = false
    local j = #poly
    for i = 1, #poly do
        local xi, yi = poly[i].x, poly[i].y
        local xj, yj = poly[j].x, poly[j].y
        -- Check edge crossing
        if ((yi > pt.y) ~= (yj > pt.y)) then
            local xint = (xj - xi) * (pt.y - yi) / (yj - yi) + xi
            if xint > pt.x then inside = not inside end
        end
        j = i
    end
    return inside
end

--- Checks if two polygons overlap by point-in-polygon and edge intersection tests.
--- @param A table Array of vertices {x,y} for polygon A
--- @param B table Array of vertices {x,y} for polygon B
--- @return boolean True if any overlap detected
function AETHR.AUTOSAVE.polygonsOverlap(A, B)
    -- Test vertices of A in B
    for _, v in ipairs(A) do
        if AETHR.AUTOSAVE.pointInPolygon(v, B) then return true end
    end
    -- Test vertices of B in A
    for _, v in ipairs(B) do
        if AETHR.AUTOSAVE.pointInPolygon(v, A) then return true end
    end
    -- Test edge intersections
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

--- Flags divisions as active if they spatially intersect any zone vertices.
--- @param Divisions table Array of division objects with `.corners`
--- @param Zones table Indexed cells of zone entries (output of buildZoneCellIndex)
--- @return table Updated Divisions array with `.active` flags
function AETHR.AUTOSAVE.checkDivisionsInZones(Divisions, Zones)
    local grid      = AETHR.AUTOSAVE.initGrid(Divisions)
    local zoneCells = AETHR.AUTOSAVE.buildZoneCellIndex(Zones, grid)

    for _, div in ipairs(Divisions) do
        -- Compute division centroid
        local sx, sz = 0, 0
        for _, v in ipairs(div.corners) do
            sx, sz = sx + v.x, sz + v.z
        end
        local cx, cz = sx / #div.corners, sz / #div.corners

        -- Map centroid to grid
        local col = math.floor((cx - grid.minX) * grid.invDx) + 1
        local row = math.floor((cz - grid.minZ) * grid.invDz) + 1

        -- Bounding box of division
        local dminx, dmaxx, dminz, dmaxz = math.huge, -math.huge, math.huge, -math.huge
        local divPoly = {}
        for _, v in ipairs(div.corners) do
            table.insert(divPoly, { x = v.x, y = v.z })
            dminx, dmaxx = math.min(dminx, v.x), math.max(dmaxx, v.x)
            dminz, dmaxz = math.min(dminz, v.z), math.max(dmaxz, v.z)
        end
        local divBBox = { minx = dminx, maxx = dmaxx, miny = dminz, maxy = dmaxz }

        div.active = false
        local candidates = (zoneCells[col] or {})[row] or {}
        -- Test each candidate zone entry
        for _, entry in ipairs(candidates) do
            local bz = entry.bbox
            if not (divBBox.maxx < bz.minx or divBBox.minx > bz.maxx
                 or divBBox.maxy < bz.miny or divBBox.miny > bz.maxy) then
                -- Bounding boxes overlap; test detailed polygon overlap
                if AETHR.AUTOSAVE.polygonsOverlap(divPoly, entry.poly) then
                    div.active = true
                    break
                end
            end
        end
    end

    return Divisions
end
