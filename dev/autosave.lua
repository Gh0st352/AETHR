--- @module AETHR.AUTOSAVE
--- @brief 
--- @author Gh0st352

AETHR.AUTOSAVE = {}

--- @function AETHR.AUTOSAVE.initGrid
--- @brief Initializes grid metrics (origin and cell sizes) from division corners.
--- @param divs table Array of division objects; each has a `.corners` array of points `{x, z}`.
--- @return _Grid Grid parameters:
---   * minX, minZ - grid origin coordinates
---   * dx, dz - width and height of each cell
---   * invDx, invDz - precomputed inverses for fast lookup
function AETHR.AUTOSAVE.initGrid(divs)
    -- Use first division's corners as reference origin and cell dimensions.
    local c    = divs[1].corners -- Corner list of first division.
    local minX = c[1].x          -- X-coordinate of grid origin.
    local maxZ = c[1].z          -- Z-coordinate of grid origin.
    local dx   = c[2].x - c[1].x -- Cell width.
    local dz   = c[4].z - c[1].z -- Cell height.

    local Grid = AETHR._Grid:New(c, minX, maxZ, dx, dz)

    return Grid
end

--- @function AETHR.AUTOSAVE.buildZoneCellIndex
--- @brief Constructs a mapping of grid cells to zone entries for efficient spatial lookup.
--- @param Zones table<string, _MIZ_ZONE> Array or map of zone objects, each containing `.verticies` array of points `{x, y}`.
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

--- @function AETHR.AUTOSAVE.checkDivisionsInZones
--- @brief Flags divisions as active if they spatially intersect any zone.
--- @param Divisions table Array of division objects with `.corners` points.
--- @param Zones table<string, _MIZ_ZONE> Indexed cells of zone entries (from `buildZoneCellIndex`).
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
                if AETHR.POLY.polygonsOverlap(divPoly, entry.poly) then
                    div.active = true
                    break
                end
            end
        end
    end

    return Divisions
end
