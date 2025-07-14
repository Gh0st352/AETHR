AETHR.AUTOSAVE = {}

-- -- pull globals into locals for speed
-- AETHR.AUTOSAVE.min = math.min
-- AETHR.AUTOSAVE.max = math.max

-- -- compute cross‐product for orientation tests
-- function AETHR.AUTOSAVE.orientation(a, b, c)
--     return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)
-- end

-- function AETHR.AUTOSAVE.onSegment(a, c, b)
--     return AETHR.AUTOSAVE.min(a.x, b.x) <= c.x and c.x <= AETHR.AUTOSAVE.max(a.x, b.x)
--         and AETHR.AUTOSAVE.min(a.y, b.y) <= c.y and c.y <= AETHR.AUTOSAVE.max(a.y, b.y)
-- end

-- function AETHR.AUTOSAVE.segmentsIntersect(p1, p2, q1, q2)
--     local o1, o2 = AETHR.AUTOSAVE.orientation(p1, p2, q1), AETHR.AUTOSAVE.orientation(p1, p2, q2)
--     local o3, o4 = AETHR.AUTOSAVE.orientation(q1, q2, p1), AETHR.AUTOSAVE.orientation(q1, q2, p2)
--     if (o1 == 0 and AETHR.AUTOSAVE.onSegment(p1, q1, p2))
--         or (o2 == 0 and AETHR.AUTOSAVE.onSegment(p1, q2, p2))
--         or (o3 == 0 and AETHR.AUTOSAVE.onSegment(q1, p1, q2))
--         or (o4 == 0 and AETHR.AUTOSAVE.onSegment(q1, p2, q2)) then
--         return true
--     end
--     return (o1 > 0 and o2 < 0 or o1 < 0 and o2 > 0)
--         and (o3 > 0 and o4 < 0 or o3 < 0 and o4 > 0)
-- end

-- -- ray‐cast point‐in‐polygon
-- function AETHR.AUTOSAVE.pointInPolygon(pt, poly)
--     local inside = false
--     local j = #poly
--     for i = 1, #poly do
--         local xi, yi = poly[i].x, poly[i].y
--         local xj, yj = poly[j].x, poly[j].y
--         if (yi > pt.y) ~= (yj > pt.y) then
--             local xint = (xj - xi) * (pt.y - yi) / (yj - yi) + xi
--             if xint > pt.x then inside = not inside end
--         end
--         j = i
--     end
--     return inside
-- end

-- -- full polygon overlap test
-- function AETHR.AUTOSAVE.polygonsOverlap(A, B)
--     for _, v in ipairs(A) do
--         if AETHR.AUTOSAVE.pointInPolygon(v, B) then return true end
--     end
--     for _, v in ipairs(B) do
--         if AETHR.AUTOSAVE.pointInPolygon(v, A) then return true end
--     end
--     for i = 1, #A do
--         local a1, a2 = A[i], A[i % #A + 1]
--         for j = 1, #B do
--             local b1, b2 = B[j], B[j % #B + 1]
--             if AETHR.AUTOSAVE.segmentsIntersect(a1, a2, b1, b2) then return true end
--         end
--     end
--     return false
-- end

-- -- AABB‐intersection test
-- function AETHR.AUTOSAVE.bboxesIntersect(a, b)
--     return not (a.maxx < b.minx or a.minx > b.maxx
--         or a.maxy < b.miny or a.miny > b.maxy)
-- end

-- -- quadtree node
-- AETHR.AUTOSAVE.Quadtree = {}
-- AETHR.AUTOSAVE.Quadtree.__index = AETHR.AUTOSAVE.Quadtree

-- -- create a new quadtree node
-- -- bounds = {minx,maxx,miny,maxy}, cap = capacity, depth = current depth, maxD = maxDepth
-- function AETHR.AUTOSAVE.Quadtree:new(bounds, cap, depth, maxD)
--     return setmetatable({
--         bounds = bounds,
--         capacity = cap,
--         depth = depth or 0,
--         maxDepth = maxD or 8,
--         zones = {},
--         children = nil
--     }, self)
-- end

-- -- subdivide a node into 4 quadrants
-- function AETHR.AUTOSAVE.Quadtree:subdivide()
--     local b = self.bounds
--     local midx = (b.minx + b.maxx) / 2
--     local midy = (b.miny + b.maxy) / 2
--     self.children = {
--         AETHR.AUTOSAVE.Quadtree:new({ minx = b.minx, maxx = midx, miny = b.miny, maxy = midy }, self.capacity,
--             self.depth + 1, self.maxDepth),
--         AETHR.AUTOSAVE.Quadtree:new({ minx = midx, maxx = b.maxx, miny = b.miny, maxy = midy }, self.capacity,
--             self.depth + 1, self.maxDepth),
--         AETHR.AUTOSAVE.Quadtree:new({ minx = b.minx, maxx = midx, miny = midy, maxy = b.maxy }, self.capacity,
--             self.depth + 1, self.maxDepth),
--         AETHR.AUTOSAVE.Quadtree:new({ minx = midx, maxx = b.maxx, miny = midy, maxy = b.maxy }, self.capacity,
--             self.depth + 1, self.maxDepth),
--     }
-- end

-- -- insert a zone (with zone.bbox and zone.poly) into the tree
-- function AETHR.AUTOSAVE.Quadtree:insert(zone)
--     -- if this node has children, try inserting into a child
--     if self.children then
--         for _, child in ipairs(self.children) do
--             -- if the child's bounds fully contain the zone's bbox, delegate
--             if zone.bbox.minx >= child.bounds.minx
--                 and zone.bbox.maxx <= child.bounds.maxx
--                 and zone.bbox.miny >= child.bounds.miny
--                 and zone.bbox.maxy <= child.bounds.maxy then
--                 return child:insert(zone)
--             end
--         end
--         -- else falls through to storing in this node
--     end

--     -- store here if under capacity or at max depth
--     if #self.zones < self.capacity or self.depth >= self.maxDepth then
--         self.zones[#self.zones + 1] = zone
--         return true
--     end

--     -- otherwise, split and redistribute
--     if not self.children then
--         self:subdivide()
--     end
--     -- reinsert existing zones
--     for i = #self.zones, 1, -1 do
--         local z = table.remove(self.zones, i)
--         self:insert(z)
--     end
--     -- now insert the new zone
--     return self:insert(zone)
-- end

-- -- collect all zones whose bbox might intersect qbbox
-- function AETHR.AUTOSAVE.Quadtree:query(qbbox, results)
--     if not AETHR.AUTOSAVE.bboxesIntersect(self.bounds, qbbox) then
--         return
--     end
--     -- check zones stored here
--     for _, z in ipairs(self.zones) do
--         if AETHR.AUTOSAVE.bboxesIntersect(z.bbox, qbbox) then
--             results[#results + 1] = z
--         end
--     end
--     -- recurse into children
--     if self.children then
--         for _, child in ipairs(self.children) do
--             child:query(qbbox, results)
--         end
--     end
-- end

-- -- build the quadtree over your static Zones
-- function AETHR.AUTOSAVE.buildZoneQuadtree(Zones)
--     -- first find overall world‐bounds
--     local wminx, wmaxx = 1 / 0, -1 / 0
--     local wminy, wmaxy = 1 / 0, -1 / 0
--     local zoneList = {}
--     for _, zone in pairs(Zones) do
--         local poly = {}
--         local minx, maxx = 1 / 0, -1 / 0
--         local miny, maxy = 1 / 0, -1 / 0
--         for _, v in ipairs(zone.verticies) do
--             local x, y = v.x, v.y
--             poly[#poly + 1] = { x = x, y = y }
--             if x < minx then minx = x end
--             if x > maxx then maxx = x end
--             if y < miny then miny = y end
--             if y > maxy then maxy = y end
--         end
--         -- track world bounds
--         if minx < wminx then wminx = minx end
--         if maxx > wmaxx then wmaxx = maxx end
--         if miny < wminy then wminy = miny end
--         if maxy > wmaxy then wmaxy = maxy end

--         zoneList[#zoneList + 1] = {
--             poly = poly,
--             bbox = { minx = minx, maxx = maxx, miny = miny, maxy = maxy }
--         }
--     end

--     -- make root tree
--     local root = AETHR.AUTOSAVE.Quadtree:new({ minx = wminx, maxx = wmaxx, miny = wminy, maxy = wmaxy }, 4, 0, 8)
--     for _, z in ipairs(zoneList) do
--         root:insert(z)
--     end
--     return root
-- end

-- -- main: uses the quadtree to cull most zones
-- function AETHR.AUTOSAVE.checkDivisionsInZones(Divisions, Zones)
--     local zoneTree = AETHR.AUTOSAVE.buildZoneQuadtree(Zones)

--     for _, div in ipairs(Divisions) do
--         -- build division poly + bbox
--         local poly, minx, maxx = {}, 1 / 0, -1 / 0
--         local miny, maxy = 1 / 0, -1 / 0
--         for _, v in ipairs(div.corners) do
--             local x, y = v.x, v.z
--             poly[#poly + 1] = { x = x, y = y }
--             if x < minx then minx = x end
--             if x > maxx then maxx = x end
--             if y < miny then miny = y end
--             if y > maxy then maxy = y end
--         end
--         local dbbox = { minx = minx, maxx = maxx, miny = miny, maxy = maxy }

--         -- query tree, then precise test
--         local candidates = {}
--         zoneTree:query(dbbox, candidates)

--         div.active = false
--         for _, z in ipairs(candidates) do
--             if AETHR.AUTOSAVE.polygonsOverlap(poly, z.poly) then
--                 div.active = true
--                 break
--             end
--         end
--     end
-- end


-- -- 1) Initialize grid from the uniform Divisions layout
-- function AETHR.AUTOSAVE.initGrid(divs)
--   local c = divs[1].corners
--   local minX = c[1].x
--   local maxZ = c[1].z
--   local dx   = c[2].x - c[1].x
--   local dz   = c[4].z - c[1].z
--   return {
--     minX   = minX,
--     minZ   = maxZ,
--     dx      = dx,
--     dz      = dz,
--     invDx   = 1 / dx,
--     invDz   = 1 / dz,
--   }
-- end

-- -- 2) Build a per-cell index of Zones
-- function AETHR.AUTOSAVE.buildZoneCellIndex(Zones, grid)
--   local cells = {}
--   for _, zone in pairs(Zones) do
--     -- compute zone bbox (in X/Z)
--     local zminX, zmaxX = math.huge, -math.huge
--     local zminZ, zmaxZ = math.huge, -math.huge
--     for _, v in ipairs(zone.verticies) do
--       local x, z = v.x, v.y
--       if x < zminX then zminX = x end
--       if x > zmaxX then zmaxX = x end
--       if z < zminZ then zminZ = z end
--       if z > zmaxZ then zmaxZ = z end
--     end

--     -- map to cell ranges
--     local col0 = math.floor((zminX - grid.minX) * grid.invDx) + 1
--     local col1 = math.floor((zmaxX - grid.minX) * grid.invDx) + 1
--     local row0 = math.floor((zminZ - grid.minZ) * grid.invDz) + 1
--     local row1 = math.floor((zmaxZ - grid.minZ) * grid.invDz) + 1

--     -- prepare the polygon and its bbox
--     local poly = {}
--     for _, v in ipairs(zone.verticies) do
--       poly[#poly+1] = { x = v.x, y = v.y }
--     end
--     local entry = {
--       bbox = { minx = zminX, maxx = zmaxX, miny = zminZ, maxy = zmaxZ },
--       poly = poly,
--     }

--     -- assign to each covered cell
--     for col = col0, col1 do
--       cells[col] = cells[col] or {}
--       for row = row0, row1 do
--         cells[col][row] = cells[col][row] or {}
--         cells[col][row][#cells[col][row] + 1] = entry
--       end
--     end
--   end
--   return cells
-- end

-- -- 3) The robust overlap test from your baseline
-- local min, max = math.min, math.max
-- local function orientation(a,b,c)
--   return (b.x-a.x)*(c.y-a.y) - (b.y-a.y)*(c.x-a.x)
-- end
-- local function onSegment(a,c,b)
--   return min(a.x,b.x)<=c.x and c.x<=max(a.x,b.x)
--      and min(a.y,b.y)<=c.y and c.y<=max(a.y,b.y)
-- end
-- local function segmentsIntersect(p1,p2,q1,q2)
--   local o1,o2 = orientation(p1,p2,q1), orientation(p1,p2,q2)
--   local o3,o4 = orientation(q1,q2,p1), orientation(q1,q2,p2)
--   if (o1==0 and onSegment(p1,q1,p2))
--   or (o2==0 and onSegment(p1,q2,p2))
--   or (o3==0 and onSegment(q1,p1,q2))
--   or (o4==0 and onSegment(q1,p2,q2)) then
--     return true
--   end
--   return (o1>0 and o2<0 or o1<0 and o2>0)
--      and (o3>0 and o4<0 or o3<0 and o4>0)
-- end
-- local function pointInPolygon(pt, poly)
--   local inside, j = false, #poly
--   for i=1,#poly do
--     local xi,yi = poly[i].x, poly[i].y
--     local xj,yj = poly[j].x, poly[j].y
--     if (yi>pt.y) ~= (yj>pt.y) then
--       local xint = (xj-xi)*(pt.y-yi)/(yj-yi) + xi
--       if xint > pt.x then inside = not inside end
--     end
--     j = i
--   end
--   return inside
-- end
-- function AETHR.AUTOSAVE.polygonsOverlap(A,B)
--   for _,v in ipairs(A) do
--     if pointInPolygon(v,B) then return true end
--   end
--   for _,v in ipairs(B) do
--     if pointInPolygon(v,A) then return true end
--   end
--   for i=1,#A do
--     local a1,a2 = A[i], A[i%#A+1]
--     for j=1,#B do
--       local b1,b2 = B[j], B[j%#B+1]
--       if segmentsIntersect(a1,a2,b1,b2) then return true end
--     end
--   end
--   return false
-- end

-- -- 4) The final check that ties it all together
-- function AETHR.AUTOSAVE.checkDivisionsInZones(Divisions, Zones)
--   local grid      = AETHR.AUTOSAVE.initGrid(Divisions)
--   local zoneCells = AETHR.AUTOSAVE.buildZoneCellIndex(Zones, grid)

--   for _, div in ipairs(Divisions) do
--     -- division center:
--     local sx, sz = 0,0
--     for _, v in ipairs(div.corners) do
--       sx = sx + v.x
--       sz = sz + v.z
--     end
--     local cx = sx / #div.corners
--     local cz = sz / #div.corners

--     -- cell coords
--     local col = math.floor((cx - grid.minX) * grid.invDx) + 1
--     local row = math.floor((cz - grid.minZ) * grid.invDz) + 1

--     div.active = false
--     local candidates = ((zoneCells[col] or {})[row]) or {}
--     -- test only those few zones
--     for _, z in ipairs(candidates) do
--       -- quick AABB check on center
--       if not (cx < z.bbox.minx or cx > z.bbox.maxx
--            or cz < z.bbox.miny or cz > z.bbox.maxy)
--       then
--         -- build div‐poly in {x,y}
--         local poly = {}
--         for _, v in ipairs(div.corners) do
--           poly[#poly+1] = { x = v.x, y = v.z }
--         end
--         if AETHR.AUTOSAVE.polygonsOverlap(poly, z.poly) then
--           div.active = true
--           break
--         end
--       end
--     end
--   end
-- end
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

function AETHR:InitAutoSave()
    local configData = self.fileOps.loadTableFromJSON(
        self.CONFIG.STORAGE.PATHS.MAP_FOLDER,
        self.CONFIG.STORAGE.FILENAMES.SAVE_DIVS_FILE
    )
    if configData then
        self.LEARNED_DATA.worldDivisions = {}
        for _, division in ipairs(configData) do
            if division.active then
                self.LEARNED_DATA.saveDivisions[division.ID] = division
            end
        end
    else
        self.LEARNED_DATA.worldDivisions = self.AUTOSAVE.checkDivisionsInZones(self.LEARNED_DATA.worldDivisions,
            self.MIZ_ZONES)
        for _, division in ipairs(self.LEARNED_DATA.worldDivisions) do
            if division.active then
                self.LEARNED_DATA.saveDivisions[division.ID] = division
            end
        end
        self.fileOps.saveTableAsPrettyJSON(
            self.CONFIG.STORAGE.PATHS.MAP_FOLDER,
            self.CONFIG.STORAGE.FILENAMES.SAVE_DIVS_FILE,
            self.LEARNED_DATA.saveDivisions
        )
    end

    return self
end
