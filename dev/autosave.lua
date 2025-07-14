AETHR.AUTOSAVE = {}

function AETHR.AUTOSAVE.initGrid(divs)
    local c    = divs[1].corners
    local minX = c[1].x
    local maxZ = c[1].z
    local dx   = c[2].x - c[1].x
    local dz   = c[4].z - c[1].z
    return {
        minX  = minX,
        minZ  = maxZ,
        dx    = dx,
        dz    = dz,
        invDx = 1 / dx,
        invDz = 1 / dz,
    }
end

function AETHR.AUTOSAVE.buildZoneCellIndex(Zones, grid)
    local cells = {}
    for _, zone in pairs(Zones) do
        local zminX, zmaxX = math.huge, -math.huge
        local zminZ, zmaxZ = math.huge, -math.huge
        for _, v in ipairs(zone.verticies) do
            local x, z = v.x, v.y
            if x < zminX then zminX = x end
            if x > zmaxX then zmaxX = x end
            if z < zminZ then zminZ = z end
            if z > zmaxZ then zmaxZ = z end
        end
        local col0 = math.floor((zminX - grid.minX) * grid.invDx) + 1
        local col1 = math.floor((zmaxX - grid.minX) * grid.invDx) + 1
        local row0 = math.floor((zminZ - grid.minZ) * grid.invDz) + 1
        local row1 = math.floor((zmaxZ - grid.minZ) * grid.invDz) + 1

        local poly = {}
        for _, v in ipairs(zone.verticies) do
            poly[#poly + 1] = { x = v.x, y = v.y }
        end
        local entry = {
            bbox = { minx = zminX, maxx = zmaxX, miny = zminZ, maxy = zmaxZ },
            poly = poly,
        }

        for col = col0, col1 do
            cells[col] = cells[col] or {}
            for row = row0, row1 do
                cells[col][row] = cells[col][row] or {}
                cells[col][row][#cells[col][row] + 1] = entry
            end
        end
    end
    return cells
end

function AETHR.AUTOSAVE.orientation(a, b, c)
    return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)
end

function AETHR.AUTOSAVE.onSegment(a, c, b)
    return math.min(a.x, b.x) <= c.x and c.x <= math.max(a.x, b.x)
        and math.min(a.y, b.y) <= c.y and c.y <= math.max(a.y, b.y)
end

function AETHR.AUTOSAVE.segmentsIntersect(p1, p2, q1, q2)
    local o1 = AETHR.AUTOSAVE.orientation(p1, p2, q1)
    local o2 = AETHR.AUTOSAVE.orientation(p1, p2, q2)
    local o3 = AETHR.AUTOSAVE.orientation(q1, q2, p1)
    local o4 = AETHR.AUTOSAVE.orientation(q1, q2, p2)
    if (o1 == 0 and AETHR.AUTOSAVE.onSegment(p1, q1, p2))
        or (o2 == 0 and AETHR.AUTOSAVE.onSegment(p1, q2, p2))
        or (o3 == 0 and AETHR.AUTOSAVE.onSegment(q1, p1, q2))
        or (o4 == 0 and AETHR.AUTOSAVE.onSegment(q1, p2, q2)) then
        return true
    end
    return (o1 > 0 and o2 < 0 or o1 < 0 and o2 > 0)
        and (o3 > 0 and o4 < 0 or o3 < 0 and o4 > 0)
end

function AETHR.AUTOSAVE.pointInPolygon(pt, poly)
    local inside = false
    local j = #poly
    for i = 1, #poly do
        local xi, yi = poly[i].x, poly[i].y
        local xj, yj = poly[j].x, poly[j].y
        if (yi > pt.y) ~= (yj > pt.y) then
            local xint = (xj - xi) * (pt.y - yi) / (yj - yi) + xi
            if xint > pt.x then inside = not inside end
        end
        j = i
    end
    return inside
end

function AETHR.AUTOSAVE.polygonsOverlap(A, B)
    for _, v in ipairs(A) do
        if AETHR.AUTOSAVE.pointInPolygon(v, B) then return true end
    end
    for _, v in ipairs(B) do
        if AETHR.AUTOSAVE.pointInPolygon(v, A) then return true end
    end
    for i = 1, #A do
        local a1, a2 = A[i], A[i % #A + 1]
        for j = 1, #B do
            local b1, b2 = B[j], B[j % #B + 1]
            if AETHR.AUTOSAVE.segmentsIntersect(a1, a2, b1, b2) then return true end
        end
    end
    return false
end

function AETHR.AUTOSAVE.checkDivisionsInZones(Divisions, Zones)
    local grid      = AETHR.AUTOSAVE.initGrid(Divisions)
    local zoneCells = AETHR.AUTOSAVE.buildZoneCellIndex(Zones, grid)

    for _, div in ipairs(Divisions) do
        local sx, sz = 0, 0
        for _, v in ipairs(div.corners) do
            sx = sx + v.x; sz = sz + v.z
        end
        local cx = sx / #div.corners
        local cz = sz / #div.corners

        local col = math.floor((cx - grid.minX) * grid.invDx) + 1
        local row = math.floor((cz - grid.minZ) * grid.invDz) + 1

        local divPoly = {}
        local dminx, dmaxx = math.huge, -math.huge
        local dminz, dmaxz = math.huge, -math.huge
        for _, v in ipairs(div.corners) do
            local x, z = v.x, v.z
            divPoly[#divPoly + 1] = { x = x, y = z }
            if x < dminx then dminx = x end
            if x > dmaxx then dmaxx = x end
            if z < dminz then dminz = z end
            if z > dmaxz then dmaxz = z end
        end
        local divBBox = { minx = dminx, maxx = dmaxx, miny = dminz, maxy = dmaxz }

        div.active = false
        local candidates = ((zoneCells[col] or {})[row]) or {}
        for _, z in ipairs(candidates) do
            if not (divBBox.maxx < z.bbox.minx or divBBox.minx > z.bbox.maxx
                    or divBBox.maxy < z.bbox.miny or divBBox.miny > z.bbox.maxy) then
                if AETHR.AUTOSAVE.polygonsOverlap(divPoly, z.poly) then
                    div.active = true
                    break
                end
            end
        end
    end
    return Divisions
end

