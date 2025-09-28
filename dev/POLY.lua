--- @class AETHR.POLY
--- @brief Manages mission trigger zones and computes bordering relationships.
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field MATH AETHR.MATH Math helper table attached per-instance.
--- @field MARKERS AETHR.MARKERS Markers submodule attached per-instance.
--- @field SPAWNER AETHR.SPAWNER Spawner submodule attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field UTILS AETHR.UTILS Utils submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
---
--- Type aliases used by EmmyLua aware editors to improve completion and linting:
--- @class Vec2
--- @field x number
--- @field y number
---
--- @class Vec3
--- @field x number
--- @field y number
--- @field z number
---
--- @alias Vec2Like Vec2|{ x: number, z: number }  -- supports y or z vertical coordinate
--- @alias Line2 table<number, Vec2>                -- { [1] = Vec2, [2] = Vec2 }
--- @class Line2Obj
--- @field p1 Vec2
--- @field p2 Vec2
---
--- @class BoundsXZ
--- @field X table
--- @field Z table
AETHR.POLY = {} ---@diagnostic disable-line

--- @function AETHR.POLY.segmentsIntersect
--- @brief Determines if two line segments intersect or touch.
--- @param p1 Vec2 First segment endpoint.
--- @param p2 Vec2 First segment endpoint.
--- @param q1 Vec2 Second segment endpoint.
--- @param q2 Vec2 Second segment endpoint.
--- @return boolean True if segments intersect or touch.
function AETHR.POLY:segmentsIntersect(p1, p2, q1, q2)
    local o1 = self:orientation(p1, p2, q1)
    local o2 = self:orientation(p1, p2, q2)
    local o3 = self:orientation(q1, q2, p1)
    local o4 = self:orientation(q1, q2, p2)

    -- Colinear and on-segment checks.
    if o1 == 0 and self:onSegment(p1, q1, p2) then return true end
    if o2 == 0 and self:onSegment(p1, q2, p2) then return true end
    if o3 == 0 and self:onSegment(q1, p1, q2) then return true end
    if o4 == 0 and self:onSegment(q1, p2, q2) then return true end

    -- General intersection case.
    return (o1 > 0 and o2 < 0 or o1 < 0 and o2 > 0)
        and (o3 > 0 and o4 < 0 or o3 < 0 and o4 > 0)
end

--- @function AETHR.POLY.pointInPolygon
--- @brief Tests if point lies inside polygon using ray-casting algorithm.
--- @param pt Vec2Like Point to test ({x,y} or {x,z}).
--- @param poly Vec2Like[] Array of polygon vertices.
--- @return boolean True if inside, false otherwise.
function AETHR.POLY:pointInPolygon(pt, poly)
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

--- @function AETHR.POLY.polygonsOverlap
--- @brief Determines if two polygons overlap by vertex-in-polygon or edge intersection.
--- @param A Vec2Like[] Array of vertices for polygon A.
--- @param B Vec2Like[] Array of vertices for polygon B.
--- @return boolean True if any overlap detected.
function AETHR.POLY:polygonsOverlap(A, B)
    -- Check if any A vertex lies in B.
    for _, v in ipairs(A) do
        if self:pointInPolygon(v, B) then return true end
    end
    -- Check if any B vertex lies in A.
    for _, v in ipairs(B) do
        if self:pointInPolygon(v, A) then return true end
    end
    -- Check edge intersections.
    for i = 1, #A do
        local a1, a2 = A[i], A[i % #A + 1]
        for j = 1, #B do
            local b1, b2 = B[j], B[j % #B + 1]
            if self:segmentsIntersect(a1, a2, b1, b2) then
                return true
            end
        end
    end
    return false
end

--- @function AETHR.POLY.orientation
--- @brief Computes the orientation determinant of three points.
--- @param a Vec2Like Point A.
--- @param b Vec2Like Point B.
--- @param c Vec2Like Point C.
--- @return number >0 if counter-clockwise, <0 if clockwise, 0 if colinear.
function AETHR.POLY:orientation(a, b, c)
    return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)
end

--- @function AETHR.POLY.onSegment
--- @brief Checks if point `c` lies on segment `[a, b]` inclusive.
--- @param a Vec2 Endpoint A.
--- @param c Vec2 Point to test.
--- @param b Vec2 Endpoint B.
--- @return boolean True if c lies on segment, false otherwise.
function AETHR.POLY:onSegment(a, c, b)
    return c.x >= math.min(a.x, b.x) and c.x <= math.max(a.x, b.x)
        and c.y >= math.min(a.y, b.y) and c.y <= math.max(a.y, b.y)
end

--- @function AETHR.POLY.getBoxPoints
--- @brief Calculates bounding box min/max points for a set of corners and height.
--- @param corners Vec3[] Array of corner points (expects x and z).
--- @param height number Vertical extent (y maximum).
--- @return table{ min = Vec3, max = Vec3 } Bounding box with min/max vectors.
function AETHR.POLY:getBoxPoints(corners, height)
    local minPt = { x = math.huge, y = 0, z = math.huge }
    local maxPt = { x = -math.huge, y = height, z = -math.huge }

    -- Determine min/max X,Z
    for _, c in ipairs(corners) do
        if c.x < minPt.x then minPt.x = c.x end
        if c.z < minPt.z then minPt.z = c.z end
        if c.x > maxPt.x then maxPt.x = c.x end
        if c.z > maxPt.z then maxPt.z = c.z end
    end

    -- Set Y extents
    minPt.y = 0
    maxPt.y = height
    return { min = minPt, max = maxPt }
end

--------------------------------------------------------------------------------
--- Return the vertical coordinate for a point-like table (supports .y or .z).
--- @function AETHR.POLY:getY
--- @param pt Vec2Like|Vec3|nil Point-like table with .y or .z fields.
--- @return number|nil Vertical coordinate (y or z) or nil if pt absent.
function AETHR.POLY:getY(pt)
    -- Return the vertical coordinate for a point-like table (supports .y or .z)
    if not pt then return nil end
    return pt.y or pt.z
end

--- Normalize a point-like table into { x = number, y = number } without mutating input.
--- @function AETHR.POLY:normalizePoint
--- @param pt Vec2Like|Vec3|nil Point-like table with x and y or z.
--- @return Vec2 Normalized point { x = number, y = number }.
function AETHR.POLY:normalizePoint(pt)
    -- Normalize a point-like table into { x = number, y = number } without mutating input.
    if not pt then return { x = 0, y = 0 } end
    return { x = pt.x or 0, y = (pt.y ~= nil) and pt.y or (pt.z or 0) }
end

--------------------------------------------------------------------------------
--- Determines whether a 2D point lies strictly inside a polygon using the ray-casting algorithm.
---
--- Behavior and notes:
--- - Accepts polygons whose vertices may use fields y or z for the vertical coordinate; the function will
---   use P.y or P.z (preferring y) and uses the same coordinate in polygon vertices.
--- - If the polygon has fewer than 3 vertices, it cannot enclose an area and the function returns false.
--- - Ray-casting is done horizontally to a large positive X ("extreme") and counts edge intersections.
--- - If the point is collinear with an edge, the function uses onLine to decide if the point lies on that edge.
--- - Returns true for points strictly inside (odd number of intersections), false otherwise.
--- @function AETHR.POLY:PointWithinShape
--- @param P Vec2Like Point to test; expects numeric x and y (or z) field.
--- @param Polygon Vec2Like[] Array of polygon vertices. Each vertex is a table with numeric x and y (or z) field.
--- @return boolean True if P is inside the polygon (or on an edge when onLine returns true), false otherwise.
function AETHR.POLY:PointWithinShape(P, Polygon)
    local n = #Polygon

    -- Resolve vertical coordinate consistently
    local vertCoord = self:getY(P)

    -- A polygon must have at least 3 vertices to enclose a space
    if n < 3 then
        return false
    end

    -- Create a point for line segment from P to infinite
    local extreme = { x = 99999999, y = vertCoord }

    -- Count intersections of the above line with sides of polygon
    local count = 0
    local i = 1

    -- Use a loop to iterate through all sides of the polygon
    repeat
        local next = (i % n) + 1

        -- Create normalized points with consistent coordinate naming
        local p1 = {
            x = Polygon[i].x, ---@diagnostic disable-line
            y = self:getY(Polygon[i])---@diagnostic disable-line
        }

        local p2 = {
            x = Polygon[next].x, ---@diagnostic disable-line
            y = self:getY(Polygon[next]) ---@diagnostic disable-line
        }
        
        local side = { p1 = p1, p2 = p2 }
        local normalizedP = { x = P.x, y = vertCoord }

        -- Check if the line segment formed by P and extreme intersects with the side of the polygon
        if self:isIntersect(side, { p1 = normalizedP, p2 = extreme }) then
            -- If the point P is collinear with the side of the polygon, check if it lies on the segment
            if self.MATH:direction(side.p1, normalizedP, side.p2) == 0 then ---@diagnostic disable-line
                return self:onLine(side, normalizedP)
            end

            -- Increment the count of intersections
            count = count + 1
        end

        i = next
    until i == 1

    -- Return `true` if count is odd, `false` otherwise
    return (count % 2) == 1
end

--------------------------------------------------------------------------------
--- Constructs a volume descriptor representing an axis-aligned box used by the runtime/world layer.
---
--- Notes:
--- - Expected that world.VolumeType.BOX is available in the runtime environment.
--- - WS_Vec3 and EN_Vec3 should be vector-like tables describing min and max coordinates respectively.
--- - Returns a simple table with id and params suitable for whatever world API consumes it.
--- @function AETHR.POLY.createBox
--- @param WS_Vec3 Vec3 Minimum corner vector (table with numeric x,y,z or equivalent fields).
--- @param EN_Vec3 Vec3 Maximum corner vector (table with numeric x,y,z or equivalent fields).
--- @return table Volume descriptor in the form { id = world.VolumeType.BOX, params = { min = WS_Vec3, max = EN_Vec3 } }.
function AETHR.POLY:createBox(WS_Vec3, EN_Vec3)
    local box = {
        id = world.VolumeType.BOX,
        params = {
            min = WS_Vec3,
            max = EN_Vec3
        }
    }
    return box
end

--- Convert unordered line segments into an ordered polygon vertex chain without mutating coordinates.
--- Behavior:
--- - Endpoints within `vertOffset` are considered connected (consecutive) but original coordinates are preserved.
--- - Walk the chain by following connected segments; if the chain closes, return the ordered list.
--- - Accepts vertices using `y` or `z` (prefers `y`).
--- Example:
--- local poly = AETHR.POLY:convertLinesToPolygon(masterPolyLines, 0.1)
--- @param lines Line2[] Array of unordered line segments, each segment is a pair of point-tables.
--- @param vertOffset number|nil tolerance to consider endpoints equal (units same as coordinates)
--- @return Vec2[]|nil Ordered polygon vertices or nil when a closed polygon could not be reconstructed.
function AETHR.POLY:convertLinesToPolygon(lines, vertOffset)
    if type(lines) ~= "table" or #lines == 0 then
        return nil
    end

    local offset = vertOffset or 0
    local offset2 = offset * offset

    local function getY(pt)
        if not pt then return nil end
        if pt.y ~= nil then return pt.y end
        return pt.z
    end

    local function dist2(a, b)
        local ax = (a and a.x) or 0
        local ay = getY(a) or 0
        local bx = (b and b.x) or 0
        local by = getY(b) or 0
        local dx = ax - bx
        local dy = ay - by
        return dx * dx + dy * dy
    end
    -- remove_duplicate_vertices(vertices, opts)
    -- vertices: table with numeric keys e.g. vertices = { [1] = {x=..., y=...}, ... }
    -- opts (optional):
    --   inplace   (boolean) - default true. If true, original table is modified and returned.
    --   precision (number)  - number of decimals to format coordinates for comparison (optional).
    local function remove_duplicate_vertices(vertices, opts)
        opts = opts or {}
        local inplace = (opts.inplace == nil) and true or not not opts.inplace
        local precision = opts.precision

        local seen = {}
        local result = {}

        -- collect numeric keys and sort to preserve order
        local indices = {}
        for k in pairs(vertices) do
            if type(k) == "number" then
                indices[#indices + 1] = k
            end
        end
        table.sort(indices)

        -- helper to build comparison key
        local function build_key(x, y)
            if precision then ---@diagnostic disable-line
                return string.format("%." .. tostring(precision) .. "f:%." .. tostring(precision) .. "f", x, y)
            else
                return tostring(x) .. ":" .. tostring(y)
            end
        end

        for _, k in ipairs(indices) do
            local v = vertices[k]
            if type(v) == "table" and v.x ~= nil and v.y ~= nil then
                local key = build_key(v.x, v.y)
                if not seen[key] then
                    seen[key] = true
                    result[#result + 1] = v
                end
            end
        end

        if inplace then
            -- clear original table
            for k in pairs(vertices) do vertices[k] = nil end
            -- write back unique entries starting at 1
            for i = 1, #result do vertices[i] = result[i] end
            return vertices
        else
            return result
        end
    end
    local totalLines = #lines

    -- Try every line as a starting segment, both orientations.
    for startIdx = 1, totalLines do
        for orient = 1, 2 do
            -- used array tracks which segments we've consumed; do NOT mutate `lines`.
            local used = {}
            for i = 1, totalLines do used[i] = false end
            used[startIdx] = true

            local startPt, curPt
            if orient == 1 then
                startPt = lines[startIdx][1]
                curPt   = lines[startIdx][2]
            else
                startPt = lines[startIdx][2]
                curPt   = lines[startIdx][1]
            end

            if not startPt or not curPt then
                -- malformed segment, skip this orientation
            else
                local polygonVerts = { startPt, curPt }
                local usedCount = 1
                local failed = false

                while usedCount < totalLines do
                    local found = false
                    for i = 1, totalLines do
                        if not used[i] then
                            local a = lines[i][1]
                            local b = lines[i][2]
                            if a and b then
                                if dist2(curPt, a) <= offset2 then
                                    used[i] = true
                                    table.insert(polygonVerts, a)
                                    table.insert(polygonVerts, b)

                                    curPt = b
                                    usedCount = usedCount + 1
                                    found = true
                                    break
                                elseif dist2(curPt, b) <= offset2 then
                                    used[i] = true
                                    table.insert(polygonVerts, b)
                                    table.insert(polygonVerts, a)

                                    curPt = a
                                    usedCount = usedCount + 1
                                    found = true
                                    break
                                end
                            end
                        end
                    end

                    if not found then
                        failed = true
                        break
                    end
                end

                -- If we used all segments and current point connects back to start, return polygon
                if not failed and dist2(polygonVerts[1], curPt) <= offset2 then
                    -- Explicitly close the polygon by appending the starting vertex (preserve original object)
                    --table.insert(polygonVerts, polygonVerts[1])
                    local dedup = remove_duplicate_vertices(polygonVerts, { precision = 3, inplace = false })
                    return dedup
                end
            end
        end
    end

    return nil
end

--- Converts a polygon (list of points) into an array of line segments.
--- @function convertPolygonToLines
--- @param zone Vec2Like[] Array of points `{x,y}` or `{x,z}`
--- @return Line2[] Array of segments `{{x,y},{x,y}}`
function AETHR.POLY:convertPolygonToLines(zone)
    local lines = {}
    for i = 1, #zone do
        local j = (i % #zone) + 1
        table.insert(lines, { { x = zone[i].x, y = zone[i].y or zone[i].z },
            { x = zone[j].x, y = zone[j].y or zone[j].z } })
    end
    return lines
end

--- Divides a quadrilateral polygon into sub-polygons of roughly equal area.
--- Calculates rows and columns based on aspect ratio.
--- @function dividePolygon
--- @param polygon Vec3[] Array of `{x,z}` four corners in clockwise order
--- @param targetArea number Desired area per sub-polygon
--- @return table[] Array of division tables `{ corners = {pt1,pt2,pt3,pt4} }`
function AETHR.POLY:dividePolygon(polygon, targetArea)
    local total     = self:polygonArea(polygon)
    local count     = math.max(1, math.floor(total / targetArea + 0.5))

    -- Define left and right edges
    local leftEdge  = { polygon[1], polygon[4] }
    local rightEdge = { polygon[2], polygon[3] }

    -- Determine grid shape by aspect ratio
    local width     = math.sqrt((polygon[2].x - polygon[1].x) ^ 2 + (polygon[2].z - polygon[1].z) ^ 2)
    local height    = math.sqrt((polygon[4].x - polygon[1].x) ^ 2 + (polygon[4].z - polygon[1].z) ^ 2)
    local ratio     = width / height

    local cols      = math.ceil(math.sqrt(count * ratio))
    local rows      = math.ceil(count / cols)
    -- Adjust if grid smaller than needed
    while rows * cols < count do
        if width > height then cols = cols + 1 else rows = rows + 1 end
    end

    local divisions = {}
    -- Generate grid divisions
    for r = 0, rows - 1 do
        local tFrac, bFrac = (r + 1) / rows, r / rows
        local bottomLeft   = {
            x = leftEdge[1].x + bFrac * (leftEdge[2].x - leftEdge[1].x),
            z = leftEdge[1].z + bFrac * (leftEdge[2].z - leftEdge[1].z)
        }
        local bottomRight  = {
            x = rightEdge[1].x + bFrac * (rightEdge[2].x - rightEdge[1].x),
            z = rightEdge[1].z + bFrac * (rightEdge[2].z - rightEdge[1].z)
        }
        local topLeft      = {
            x = leftEdge[1].x + tFrac * (leftEdge[2].x - leftEdge[1].x),
            z = leftEdge[1].z + tFrac * (leftEdge[2].z - leftEdge[1].z)
        }
        local topRight     = {
            x = rightEdge[1].x + tFrac * (rightEdge[2].x - rightEdge[1].x),
            z = rightEdge[1].z + tFrac * (rightEdge[2].z - rightEdge[1].z)
        }

        for c = 0, cols - 1 do
            local lFrac, rFrac = c / cols, (c + 1) / cols
            -- Interpolate four corners
            local poly = {
                {
                    x = bottomLeft.x + lFrac * (bottomRight.x - bottomLeft.x),
                    z = bottomLeft.z + lFrac * (bottomRight.z - bottomLeft.z)
                },
                {
                    x = bottomLeft.x + rFrac * (bottomRight.x - bottomLeft.x),
                    z = bottomLeft.z + rFrac * (bottomRight.z - bottomLeft.z)
                },
                {
                    x = topLeft.x + rFrac * (topRight.x - topLeft.x),
                    z = topLeft.z + rFrac * (topRight.z - topLeft.z)
                },
                {
                    x = topLeft.x + lFrac * (topRight.x - topLeft.x),
                    z = topLeft.z + lFrac * (topRight.z - topLeft.z)
                },
            }
            table.insert(divisions, { corners = poly })
        end
    end

    return divisions
end

--- Computes the area of a polygon using the Shoelace formula.
--- @function polygonArea
--- @param polygon Vec3[] Array of `{x,z}` vertices
--- @return number Absolute area value (non-negative)
function AETHR.POLY:polygonArea(polygon)
    local n = #polygon
    if n < 3 then return 0 end
    local sum = 0
    for i = 1, n do
        local j = (i % n) + 1
        sum = sum + (polygon[i].x * polygon[j].z - polygon[j].x * polygon[i].z) ---@diagnostic disable-line
    end
    return math.abs(sum) / 2
end

--- Ensures a quadrilateral polygon is convex by checking cross product signs.
--- Swaps the last two vertices if orientation is inconsistent.
--- @function ensureConvex
--- @param coords Vec3[] Array of four `{x,z}` points
--- @return Vec3[] Possibly reordered convex polygon
function AETHR.POLY:ensureConvex(coords)
    local signs = {
        self.MATH:crossProduct(coords[1], coords[2], coords[3]) >= 0,
        self.MATH:crossProduct(coords[2], coords[3], coords[4]) >= 0,
        self.MATH:crossProduct(coords[3], coords[4], coords[1]) >= 0,
        self.MATH:crossProduct(coords[4], coords[1], coords[2]) >= 0,
    }
    -- If any sign differs, swap to reorder vertices
    if not (signs[1] and signs[2] and signs[3] and signs[4]) then
        coords[3], coords[4] = coords[4], coords[3]
    end
    return coords
end

--- Ensure consistent orientation and remove self-intersections for N-point polygons.
--- @param coords Vec2Like[] Array of points
--- @return Vec2Like[] Ordered polygon with preserved vertices
function AETHR.POLY:ensureConvexN(coords)
    local n = #coords
    if n < 3 then return coords end
    local function getY(p) return p.y or p.z or 0 end

    local function signedArea2(tbl)
        local area = 0
        for i = 1, #tbl do
            local j = (i % #tbl) + 1
            local xi = tbl[i].x or 0
            local yi = getY(tbl[i])
            local xj = tbl[j].x or 0
            local yj = getY(tbl[j])
            area = area + (xi * yj - xj * yi) ---@diagnostic disable-line
        end
        return area
    end

    local function isConsistentlyOriented(tbl)
        local hasPos, hasNeg = false, false
        local m = #tbl
        for i = 1, m do
            local i2 = (i % m) + 1
            local i3 = ((i + 1) % m) + 1
            local cp = self.MATH:crossProduct(tbl[i], tbl[i2], tbl[i3])
            if cp > 0 then hasPos = true end
            if cp < 0 then hasNeg = true end
            if hasPos and hasNeg then
                return false
            end
        end
        return true
    end

    -- If already consistently oriented, just ensure CCW and return
    if isConsistentlyOriented(coords) then
        if signedArea2(coords) < 0 then
            local a, b = 1, n
            while a < b do
                coords[a], coords[b] = coords[b], coords[a]
                a = a + 1
                b = b - 1
            end
        end
        return coords
    end

    -- Build centroid-ordered polygon (preserves all points)
    local cx, cy = self.MATH:centroid(coords)
    local items = {}
    for i = 1, n do
        local p = coords[i]
        local x = p.x or 0
        local y = getY(p)
        items[i] = {
            pt = p,
            ang = math.atan2(y - cy, x - cx), ---@diagnostic disable-line
            r2 = (x - cx) * (x - cx) + (y - cy) * (y - cy)
        }
    end

    table.sort(items, function(a, b)
        if a.ang == b.ang then
            return a.r2 < b.r2
        end
        return a.ang < b.ang
    end)

    local order = {}
    for i = 1, n do order[i] = items[i].pt end

    -- Ensure CCW
    if signedArea2(order) < 0 then
        local a, b = 1, n
        while a < b do
            order[a], order[b] = order[b], order[a]
            a = a + 1
            b = b - 1
        end
    end

    -- If this ordering is already consistently oriented, return it
    if isConsistentlyOriented(order) then
        return order
    end

    -- Helper: on-segment test (works with .y or .z)
    local function onSegment(a, b, c)
        local ax, ay = a.x or 0, getY(a)
        local bx, by = b.x or 0, getY(b)
        local cx2, cy2 = c.x or 0, getY(c)
        if bx >= math.min(ax, cx2) and bx <= math.max(ax, cx2) and
            by >= math.min(ay, cy2) and by <= math.max(ay, cy2) then
            return true
        end
        return false
    end

    -- Helper: segment intersection test using crossProduct (ignores adjacent edges sharing endpoints)
    local function segmentsIntersect(p1, q1, p2, q2)
        -- treat shared endpoints as non-intersecting (we only want true crossings)
        if p1 == p2 or p1 == q2 or q1 == p2 or q1 == q2 then return false end


        local o1 = self.MATH:crossProduct(p1, q1, p2)
        local o2 = self.MATH:crossProduct(p1, q1, q2)
        local o3 = self.MATH:crossProduct(p2, q2, p1)
        local o4 = self.MATH:crossProduct(p2, q2, q1)

        local function sgn(v)
            if v > 0 then return 1 elseif v < 0 then return -1 else return 0 end
        end

        local s1, s2, s3, s4 = sgn(o1), sgn(o2), sgn(o3), sgn(o4)
        if s1 ~= s2 and s3 ~= s4 then
            return true
        end
        if s1 == 0 and onSegment(p1, p2, q1) then return true end
        if s2 == 0 and onSegment(p1, q2, q1) then return true end
        if s3 == 0 and onSegment(p2, p1, q2) then return true end
        if s4 == 0 and onSegment(p2, q1, q2) then return true end
        return false
    end

    -- 2-opt untangling: find crossing edges and reverse the subsequence between them
    local m = #order
    local maxIter = m * m
    local iter = 0
    local changed = true
    while changed and iter < maxIter do
        iter = iter + 1
        changed = false
        m = #order
        for i = 1, m do
            local i2 = (i % m) + 1
            for j = i + 2, m do
                local j2 = (j % m) + 1
                -- skip adjacent edges (including wrap-around)
                if not (i == j2 or i2 == j) then
                    if segmentsIntersect(order[i], order[i2], order[j], order[j2]) then
                        -- reverse vertices between i2 and j (inclusive) to remove crossing
                        local a, b = i2, j
                        while a < b do
                            order[a], order[b] = order[b], order[a]
                            a = a + 1
                            b = b - 1
                        end
                        changed = true
                        break
                    end
                end
            end
            if changed then break end ---@diagnostic disable-line
        end
    end

    -- Ensure CCW for the final result
    if signedArea2(order) < 0 then
        local a, b = 1, #order
        while a < b do
            order[a], order[b] = order[b], order[a]
            a = a + 1
            b = b - 1
        end
    end

    -- Return best-effort ordering that preserves all original vertices (does not remove collinear points)
    return order
end

--- Converts axis-aligned world bounds into a 4-point polygon.
--- Ensures convexity of the resulting polygon.
--- @function AETHR.POLY.convertBoundsToPolygon
--- @brief Converts world bounds into a convex quadrilateral polygon.
--- @param bounds BoundsXZ Structure with `X.min`, `X.max`, `Z.min`, `Z.max` coordinates.
--- @return Vec3[] Array of four corner points `{x=number, z=number}` in clockwise order.
function AETHR.POLY:convertBoundsToPolygon(bounds)
    -- Create initial polygon corners: bottom-left, bottom-right, top-right, top-left
    local polygon = {
        { x = bounds.X.min, z = bounds.Z.min },
        { x = bounds.X.max, z = bounds.Z.min },
        { x = bounds.X.max, z = bounds.Z.max },
        { x = bounds.X.min, z = bounds.Z.max },
    }

    -- Ensure polygon is convex by swapping vertices if needed
    return self:ensureConvex(polygon)
end

--- Calculates the Euclidean length of a line segment.
--- @function lineLength
--- @param line Line2 Two points `{ {x,y},{x,y} }`
--- @return number Length of the segment
function AETHR.POLY:lineLength(line)
    local dx = line[2].x - line[1].x
    local dy = line[2].y - line[1].y
    return math.sqrt(dx * dx + dy * dy)
end

--------------------------------------------------------------------------------
--- Samples `n` equally spaced points along a line segment (excluding endpoints).
--- Uses linear interpolation between the two endpoints.
---
--- Notes / inline behavior:
--- - InputLine is expected to be an array-like table with two points: { [1] = {x=..., y=...}, [2] = {x=..., y=...} }.
--- - DesiredPoints is the number of interior samples; points are spaced at t = i/(DesiredPoints+1) for i=1..DesiredPoints.
--- - Returns a list of points in the form { {x=..., y=...}, ... }.
--- @function AETHR.POLY.getEquallySpacedPoints
--- @param InputLine Line2 Two-element array of endpoints, each endpoint is a table with numeric x and y fields.
--- @param DesiredPoints integer Number of points to sample along the segment (interior points).
--- @return Vec2[] OutputPoints Array of sampled points, each point being a table with x and y numeric fields.
function AETHR.POLY:getEquallySpacedPoints(InputLine, DesiredPoints)
    local P1, P2 = InputLine[1], InputLine[2]
    local OutputPoints = {}
    -- Iterate from 1 to DesiredPoints to compute each equally spaced point
    for i = 1, DesiredPoints do
        -- Calculate the parameter t based on the current iteration and total number of desired points
        local t = i / (DesiredPoints + 1)
        -- Compute the x and y coordinates of each point using linear interpolation
        table.insert(OutputPoints, {
            x = (1 - t) * P1.x + t * P2.x,
            y = (1 - t) * P1.y + t * P2.y
        })
    end
    return OutputPoints
end

--------------------------------------------------------------------------------
--- Tests whether two line segments (provided as 2-element arrays) are within a given offset.
---
--- Behavior and notes:
--- - For robustness against different line lengths, this routine samples a fixed number of interior points
---   along each line (default 11) and computes a "confirmation rate" using a ratio of line lengths
---   (via computeRatio and lineLength helpers expected elsewhere in AETHR.MATH).
--- - A sampled point is considered close to the other line if the point-to-segment distance <= Offset.
--- - The function checks both directions: sampling LineA against LineB and LineB against LineA,
---   returning true if either direction has enough sample points within the offset threshold.
--- - This is an approximation: sampling density and the ratio calculation affect sensitivity.
--- @function AETHR.POLY.isWithinOffset
--- @param LineA Line2 Two-element array of endpoints for first line.
--- @param LineB Line2 Two-element array of endpoints for second line.
--- @param Offset number Distance threshold to consider a sampled point "within" the other line.
--- @return boolean bool True if lines are considered within Offset of each other (approximate via sampling), false otherwise.
function AETHR.POLY:isWithinOffset(LineA, LineB, Offset)
    local DesiredPoints = 11
    -- Compute the ratio of the lengths of LineA and LineB
    local PointConfirmRate = self.MATH:computeRatio(self:lineLength(LineA), self:lineLength(LineB))
    -- Compute the number of confirmation points needed based on the desired points and the computed ratio
    local threshold = DesiredPoints * PointConfirmRate
    -- Nested function to check if the sampled points on one line are within the offset of the other line
    local function checkPointsWithinOffset(lineToSample, lineToCheckAgainst)
        local ticker = 0
        -- Sample equally spaced points from the line
        local points = self:getEquallySpacedPoints(lineToSample, DesiredPoints)
        -- Check each sampled point against the other line to determine proximity
        for _, point in ipairs(points) do
            if math.sqrt(self:pointToSegmentSquared(point.x, point.y, lineToCheckAgainst[1].x, lineToCheckAgainst[1].y, lineToCheckAgainst[2].x, lineToCheckAgainst[2].y)) <= Offset then
                ticker = ticker + 1
                if ticker >= threshold then
                    return true
                end
            end
        end
        return false
    end
    -- Check both LineA against LineB and LineB against LineA to account for both possibilities
    return checkPointsWithinOffset(LineA, LineB) or checkPointsWithinOffset(LineB, LineA)
end

--------------------------------------------------------------------------------
--- Computes the squared distance from a point to a segment in 2D.
---
--- Notes / inline behavior:
--- - If the segment degenerates to a single point (both endpoints equal), returns distance squared to that point.
--- - Projects the point onto the infinite line defined by the segment, clamps the projection parameter t to [0,1],
---   and returns the squared distance to the clamped projection.
--- - This function returns squared distances to avoid unnecessary square roots in comparisons.
--- @function AETHR.POLY.pointToSegmentSquared
--- @param px number X coordinate of the point to measure.
--- @param py number Y coordinate of the point to measure.
--- @param ax number X coordinate of segment endpoint A.
--- @param ay number Y coordinate of segment endpoint A.
--- @param bx number X coordinate of segment endpoint B.
--- @param by number Y coordinate of segment endpoint B.
--- @return number Squared distance from (px,py) to the closest point on segment AB.
function AETHR.POLY:pointToSegmentSquared(px, py, ax, ay, bx, by)
    -- Calculate the squared distance between the endpoints of the segment
    local l2 = self.MATH:distanceSquared(ax, ay, bx, by)

    -- If the segment is a point, return the squared distance to the point
    if l2 == 0 then return self.MATH:distanceSquared(px, py, ax, ay) end

    -- Project the point onto the line segment and find the parameter t
    local t = self.MATH:dot(px - ax, py - ay, bx - ax, by - ay) / l2

    -- If t is outside [0, 1], the point lies outside the segment, so return the squared distance to the nearest endpoint
    if t < 0 then return self.MATH:distanceSquared(px, py, ax, ay) end
    if t > 1 then return self.MATH:distanceSquared(px, py, bx, by) end

    -- Compute the squared distance from the point to its projection on the segment
    return self.MATH:distanceSquared(px, py, ax + t * (bx - ax), ay + t * (by - ay))
end

--------------------------------------------------------------------------------
--- Returns the midpoint of a line segment.
--- @function AETHR.POLY.getMidpoint
--- @param line Line2 Two-element array of endpoints, each with numeric x and y fields.
--- @return Vec2|_vec2 A point with numeric fields x and y representing the midpoint of the segment.
function AETHR.POLY:getMidpoint(line)
    -- Calculate the x and y coordinates of the midpoint using the average of the endpoints' coordinates
    return {
        x = (line[1].x + line[2].x) / 2,
        y = (line[1].y + line[2].y) / 2
    }
end

--------------------------------------------------------------------------------
--- Calculates the slope (dy/dx) of a line segment.
---
--- Notes:
--- - If the line is vertical (dx == 0) the function returns math.huge to indicate an infinite slope.
--- - The slope is computed as (y2 - y1) / (x2 - x1).
--- @function AETHR.POLY.calculateLineSlope
--- @param line Line2 Two-element array of endpoints, each with numeric x and y fields.
--- @return number Slope of the line (dy/dx), or math.huge for a vertical line.
function AETHR.POLY:calculateLineSlope(line)
    -- Calculate the differences in x and y coordinates between the two points of the line
    local dx = line[2].x - line[1].x
    local dy = line[2].y - line[1].y
    -- If dx is 0, the line is vertical and slope is infinite
    if dx == 0 then
        return math.huge
    end
    -- Calculate the slope of the line using the formula (change in y) / (change in x)
    local slope = dy / dx
    return slope
end

--------------------------------------------------------------------------------
--- Given a point and a line, computes one endpoint of a perpendicular segment of given length
--- that starts at the point and extends in one perpendicular direction.
---
--- Behavior and notes:
--- - The provided `length` is the absolute linear distance from the starting Point to the returned endpoint.
--- - If the original line is vertical, the perpendicular is horizontal and the function returns a point
---   at (Point.x, Point.y + length).
--- - For non-vertical lines, the perpendicular slope is -1/m where m is the line slope; the function
---   computes a displacement along x such that the Euclidean length equals `length` and then computes y
---   using the perpendicular slope.
--- - The function returns a single endpoint in one perpendicular direction; to get both you may mirror the x displacement.
--- @function AETHR.POLY.findPerpendicularEndpoints
--- @param Point Vec2 Starting point for the perpendicular segment. Expects numeric fields x and y.
--- @param line Line2 Two-element array of endpoints defining the reference line, each with numeric x and y fields.
--- @param length number Desired length of the perpendicular from Point to the endpoint.
--- @return Vec2 Endpoint point with numeric fields x and y located `length` away from Point along a perpendicular.
function AETHR.POLY:findPerpendicularEndpoints(Point, line, length)
    -- Calculate the differences in x and y coordinates between the two points of the line
    local dx = line[2].x - line[1].x
    local dy = line[2].y - line[1].y
    -- If the dx is 0, then the line is vertical and the perpendicular line is horizontal
    if dx == 0 then
        return { x = Point.x, y = Point.y + length }
    end
    -- Calculate the slope of the line
    local m = dy / dx
    -- Calculate the slope of the perpendicular line
    local m_perpendicular = -1 / m
    -- Find the x-coordinate of the endpoint of the perpendicular line segment
    local x = Point.x + length / math.sqrt(1 + m_perpendicular ^ 2)
    -- Using the point-slope form of a line equation, calculate the y-coordinate of the endpoint
    local y = Point.y + m_perpendicular * (x - Point.x)
    return { x = x, y = y }
end

--------------------------------------------------------------------------------
--- Tests whether two line segments intersect.
---
--- Behavior and notes:
--- - Each line is supplied as a table with p1 and p2 fields, each being a point with numeric x and y.
--- - Uses orientation (direction) tests on point triplets to detect general intersection cases.
--- - Handles collinear overlap by checking whether endpoints of one segment lie on the other via onLine.
--- - Returns true if segments intersect or touch (including collinear overlapping or touching at endpoints).
--- @function AETHR.POLY.isIntersect
--- @param l1 Line2Obj First line, with fields p1 and p2 (points with x and y).
--- @param l2 Line2Obj Second line, with fields p1 and p2 (points with x and y).
--- @return boolean True if the segments intersect or touch, false otherwise.
function AETHR.POLY:isIntersect(l1, l2)
    -- Calculate orientation values for each pair of points from the two lines
    local dir1 = self.MATH:direction(l1.p1, l1.p2, l2.p1)
    local dir2 = self.MATH:direction(l1.p1, l1.p2, l2.p2)
    local dir3 = self.MATH:direction(l2.p1, l2.p2, l1.p1)
    local dir4 = self.MATH:direction(l2.p1, l2.p2, l1.p2)
    -- If orientations of the endpoints with respect to each line are different, the lines intersect
    if dir1 ~= dir2 and dir3 ~= dir4 then
        return true
    end
    -- Check for colinearity and if a point of one line lies on the other line
    if dir1 == 0 and self:onLine(l1, l2.p1) then
        return true
    end
    if dir2 == 0 and self:onLine(l1, l2.p2) then
        return true
    end
    if dir3 == 0 and self:onLine(l2, l1.p1) then
        return true
    end
    if dir4 == 0 and self:onLine(l2, l1.p2) then
        return true
    end
    -- If none of the above conditions are met, lines do not intersect
    return false
end

--------------------------------------------------------------------------------
--- Checks whether a point lies on the (closed) segment defined by l1.p1 and l1.p2.
---
--- Behavior:
--- - Assumes collinearity has already been established when used in conjunction with direction checks.
--- - Returns true if p.x and p.y are within the bounding box of the segment endpoints.
--- @function AETHR.POLY.onLine
--- @param l1 Line2Obj Line with fields p1 and p2 (points with numeric x and y).
--- @param p Vec2 Point to test, with numeric x and y.
--- @return boolean True if p lies on the segment [l1.p1, l1.p2], false otherwise.
function AETHR.POLY:onLine(l1, p)
    -- Check if the x and y coordinates of the point are within the bounds of the line segment's endpoints
    if (p.x >= math.min(l1.p1.x, l1.p2.x) and p.x <= math.max(l1.p1.x, l1.p2.x)
            and p.y >= math.min(l1.p1.y, l1.p2.y) and p.y <= math.max(l1.p1.y, l1.p2.y)) then
        return true
    end

    return false
end

--------------------------------------------------------------------------------
--- High-level geometry helpers extracted from ZONE_MANAGER:drawOutOfBounds
--- to keep zone management small and focused.
--- These include concave hull construction, convex hull fallback,
--- ray-vs-bounds intersection, and hull edge densification/snap logic.
--------------------------------------------------------------------------------

--- Build a concave hull using a k-nearest heuristic.
--- @function AETHR.POLY:concaveHull
--- @param pts Vec2[] Array of {x,y} points
--- @param opts table Optional parameters { k = int, concavity = int }
--- @return Vec2[]|nil hull array or nil on failure
function AETHR.POLY:concaveHull(pts, opts)
    if not pts or #pts < 3 then return nil end
    opts = opts or {}
    local N = #pts
    local k = opts.k or opts.concavity or math.max(3, math.floor(#pts * 0.1))
    if k > N - 1 then k = N - 1 end

    -- helper: point equality using MATH:pointsEqual (falls back to direct compare)
    local function ptEqual(a, b)
        if self.MATH and self.MATH.pointsEqual then ---@diagnostic disable-line
            return self.MATH:pointsEqual(a, b)
        end
        return math.abs(a.x - b.x) < 1e-9 and math.abs(a.y - b.y) < 1e-9
    end

    local function kNearest(pt, points, kk)
        local list = {}
        for _, p in ipairs(points) do
            if not ptEqual(p, pt) then
                local dx = p.x - pt.x
                local dy = p.y - pt.y
                table.insert(list, { p = p, d = dx * dx + dy * dy })
            end
        end
        table.sort(list, function(a, b) return a.d < b.d end)
        local res = {}
        for i = 1, math.min(kk, #list) do table.insert(res, list[i].p) end
        return res
    end

    local function segmentIntersectsExisting(a, b, hull)
        for i = 1, #hull - 1 do
            local c = hull[i]; local d = hull[i + 1]
            if not (ptEqual(c, a) or ptEqual(d, a) or ptEqual(c, b) or ptEqual(d, b)) then
                if self:segmentsIntersect(a, b, c, d) then return true end
            end
        end
        return false
    end

    -- Main loop: attempt increasing k until success
    while true do
        local hull = {}
        -- starting point: leftmost then lowest y
        local startIdx = 1
        for i = 2, N do
            if pts[i].x < pts[startIdx].x or (pts[i].x == pts[startIdx].x and pts[i].y < pts[startIdx].y) then ---@diagnostic disable-line
                startIdx = i
            end
        end
        ---@type Vec2
        local current = { x = pts[startIdx].x, y = pts[startIdx].y } ---@diagnostic disable-line
        table.insert(hull, current)
        ---@type Vec2
        local prev = { x = current.x - 1, y = current.y } ---@diagnostic disable-line
        local step = 1
        local finished = false
        local safety = 0

        while not finished do
            safety = safety + 1
            if safety > 10000 then return nil end

            local neighbors = kNearest(current, pts, k)
            table.sort(neighbors, function(a, b)
                -- use MATH:turnAngle if available
                if self.MATH and self.MATH.turnAngle then ---@diagnostic disable-line
                    return self.MATH:turnAngle(prev, current, a) < self.MATH:turnAngle(prev, current, b)
                end
                -- fallback angle computation
                local v1x = current.x - prev.x; local v1y = current.y - prev.y
                local a1 = math.atan2(v1y, v1x) ---@diagnostic disable-line
                local v2x = a.x - current.x; local v2y = a.y - current.y
                local aa = math.atan2(v2y, v2x) ---@diagnostic disable-line
                local d1 = aa - a1
                if d1 <= -math.pi then d1 = d1 + 2 * math.pi end
                if d1 > math.pi then d1 = d1 - 2 * math.pi end
                if d1 < 0 then d1 = d1 + 2 * math.pi end

                local v3x = current.x - prev.x; local v3y = current.y - prev.y
                local a2 = math.atan2(v3y, v3x) ---@diagnostic disable-line
                local v4x = b.x - current.x; local v4y = b.y - current.y
                local ab = math.atan2(v4y, v4x) ---@diagnostic disable-line
                local d2 = ab - a2
                if d2 <= -math.pi then d2 = d2 + 2 * math.pi end
                if d2 > math.pi then d2 = d2 - 2 * math.pi end
                if d2 < 0 then d2 = d2 + 2 * math.pi end
                return d1 < d2
            end)

            local found = nil
            for _, cand in ipairs(neighbors) do
                if ptEqual(cand, hull[1]) and step >= 3 then
                    if not segmentIntersectsExisting(current, cand, hull) then
                        found = cand; break
                    end
                elseif not (function()
                        for _, q in ipairs(hull) do if ptEqual(q, cand) then return true end end
                        return false
                    end)() then
                    if not segmentIntersectsExisting(current, cand, hull) then
                        found = cand; break
                    end
                end
            end

            if not found then
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
            if #hull > 1 and ptEqual(hull[1], hull[#hull]) then table.remove(hull) end

            -- verify all points inside hull
            local allInside = true
            for _, p in ipairs(pts) do
                if not self:pointInPolygon(p, hull) then
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

--------------------------------------------------------------------------------
--- Monotone-chain convex hull (fallback for concave hull failure)
--- @function AETHR.POLY:convexHull
--- @param points Vec2[] Array of {x,y}
--- @return Vec2[]|nil hull array
function AETHR.POLY:convexHull(points)
    if not points or #points < 3 then return nil end
    local pts = {}
    for _, p in ipairs(points) do table.insert(pts, { x = p.x, y = p.y }) end
    table.sort(pts, function(a, b)
        if a.x == b.x then return a.y < b.y end
        return a.x < b.x
    end)
    local function cross(a, b, c) return self.MATH:crossProduct(a, b, { x = c.x, y = c.y }) end ---@diagnostic disable-line
    local lower, upper = {}, {}
    for i = 1, #pts do
        while #lower >= 2 and cross(lower[#lower - 1], lower[#lower], pts[i]) <= 0 do table.remove(lower) end
        table.insert(lower, pts[i])
    end
    for i = #pts, 1, -1 do
        while #upper >= 2 and cross(upper[#upper - 1], upper[#upper], pts[i]) <= 0 do table.remove(upper) end
        table.insert(upper, pts[i])
    end
    local ch = {}
    for i = 1, #lower do table.insert(ch, lower[i]) end
    for i = 2, #upper - 1 do table.insert(ch, upper[i]) end
    return ch
end

--------------------------------------------------------------------------------
--- Intersect a ray from pt in direction dir against axis-aligned bounds.
--- @function AETHR.POLY:intersectRayToBounds
--- @param pt Vec2 {x,y}
--- @param dir Vec2 {x,y} normalized direction
--- @param bounds BoundsXZ { X={min,max}, Z={min,max} }
--- @return Vec2|nil intersection {x,y} or nil
function AETHR.POLY:intersectRayToBounds(pt, dir, bounds)
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

    -- Z edges
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

--------------------------------------------------------------------------------
--- Check whether segment (a,b) intersects any consecutive segment of hull.
--- @function AETHR.POLY:segmentIntersectsAny
--- @param a Vec2 point
--- @param b Vec2 point
--- @param hull Vec2[] array of points (closed or open)
--- @return boolean
function AETHR.POLY:segmentIntersectsAny(a, b, hull)
    for i = 1, #hull - 1 do
        local c = hull[i]; local d = hull[i + 1]
        if not ((math.abs(c.x - a.x) < 1e-9 and math.abs(c.y - a.y) < 1e-9) or
                (math.abs(d.x - a.x) < 1e-9 and math.abs(d.y - a.y) < 1e-9) or
                (math.abs(c.x - b.x) < 1e-9 and math.abs(c.y - b.y) < 1e-9) or
                (math.abs(d.x - b.x) < 1e-9 and math.abs(d.y - b.y) < 1e-9)) then
            if self:segmentsIntersect(a, b, c, d) then return true end
        end
    end
    return false
end

--------------------------------------------------------------------------------
--- Densify hull edges by sampling equally spaced interior points and optionally snapping
--- those samples to the nearest original polygon segment when within snapDistance.
--- Returns a new hull array with additional points inserted.
--- @function AETHR.POLY:densifyHullEdges
--- @param hull Vec2[] Array of {x,y} points (closed loop)
--- @param polygons Vec2[][] Array of polygons (each polygon = array of points)
--- @param samplesPerEdge integer Number of interior samples to generate per edge
--- @param snapDistance number Tolerance for snapping samples to original polygon segments
--- @return Vec2[] newHull
function AETHR.POLY:densifyHullEdges(hull, polygons, samplesPerEdge, snapDistance)
    if not samplesPerEdge or samplesPerEdge <= 0 then return hull end
    local newHull = {}
    local origLines = nil
    snapDistance = snapDistance or 0.1
    local snapThreshold2 = snapDistance * snapDistance

    for i = 1, #hull do
        local j = (i % #hull) + 1
        table.insert(newHull, hull[i])
        local line = { { x = hull[i].x, y = hull[i].y }, { x = hull[j].x, y = hull[j].y } }
        local samples = self:getEquallySpacedPoints(line, samplesPerEdge)
        if samples and #samples > 0 then
            if not origLines then
                origLines = {}
                for _, poly in ipairs(polygons) do
                    local segs = self:convertPolygonToLines(poly)
                    for _, seg in ipairs(segs) do table.insert(origLines, seg) end
                end
            end

            for _, s in ipairs(samples) do
                local bestLine = nil
                local bestDist2 = math.huge
                for _, ln in ipairs(origLines) do
                    local ax, ay = ln[1].x, ln[1].y
                    local bx, by = ln[2].x, ln[2].y
                    local d2 = self:pointToSegmentSquared(s.x, s.y, ax, ay, bx, by)
                    if d2 < bestDist2 then
                        bestDist2 = d2
                        bestLine = ln
                    end
                end

                if bestLine and bestDist2 <= snapThreshold2 then ---@diagnostic disable-line
                    local ax, ay = bestLine[1].x, bestLine[1].y
                    local bx, by = bestLine[2].x, bestLine[2].y
                    local l2 = self.MATH:distanceSquared(ax, ay, bx, by)
                    local t = 0
                    if l2 > 0 then
                        t = self.MATH:dot(s.x - ax, s.y - ay, bx - ax, by - ay) / l2 ---@diagnostic disable-line
                        if t < 0 then t = 0 end
                        if t > 1 then t = 1 end
                    end
                    local projx = ax + t * (bx - ax)
                    local projy = ay + t * (by - ay)
                    table.insert(newHull, { x = projx, y = projy })
                else
                    table.insert(newHull, { x = s.x, y = s.y })
                end
            end
        end
    end

    return newHull
end

--- Finds polygonal gaps where a smaller polygon overlays a larger polygon's edges within a tolerance.
--- @param smallerPolygon Vec2Like[] Polygon contained within largerPolygon (array of points)
--- @param largerPolygon Vec2Like[] Polygon to inspect for overlayed gaps (array of points)
--- @param offset number Tolerance distance to consider a vertex aligned; defaults to 1
--- @return table[] Array of assembled gap polygons (each an array of points)
function AETHR.POLY:findOverlaidPolygonGaps(smallerPolygon, largerPolygon, offset)
    offset = offset or 1

    local offset2 = offset * offset

    local function getY(pt)
        if not pt then return nil end
        if pt.y ~= nil then return pt.y end
        return pt.z
    end

    local function dist2(a, b)
        local ax = (a and a.x) or 0
        local ay = getY(a) or 0
        local bx = (b and b.x) or 0
        local by = getY(b) or 0
        local dx = ax - bx
        local dy = ay - by
        return dx * dx + dy * dy
    end


    local polygonGaps = {}
    local largerPolygonLines = self:convertPolygonToLines(largerPolygon)
    local smallIndexes = {}

    for i, LargePolyLine in ipairs(largerPolygonLines) do
        local largeA = LargePolyLine[1]
        local largeB = LargePolyLine[2]
        smallIndexes[i] = {}
        for j = #smallerPolygon, 1, -1 do
            if dist2(largeA, smallerPolygon[j]) <= offset2 or dist2(largeB, smallerPolygon[j]) <= offset2 then --smallPolyVert == largeA or smallPolyVert == largeB then
                smallIndexes[i][#smallIndexes[i] + 1] = j
            end
        end
    end
    local sanitizedSmallIndexes = {}
    for index, value in ipairs(smallIndexes) do
        if #value >= 2 then
            local _max = math.max(unpack(value)) ---@diagnostic disable-line
            local _min = math.min(unpack(value)) ---@diagnostic disable-line
            if _max - _min >= 2 then
                local checkCW = {}
                local checkCCW = {}

                for i = _max, _min, -1 do
                    checkCCW[#checkCCW + 1] = i
                end

                for i = _max, #smallerPolygon do
                    checkCW[#checkCW + 1] = i
                end
                for i = 1, _min do
                    checkCW[#checkCW + 1] = i
                end

                if #checkCCW <= #checkCW then
                    sanitizedSmallIndexes[index] = checkCCW
                else
                    sanitizedSmallIndexes[index] = checkCW
                end
            end
        end
    end
    for bigLineNumber, val in pairs(sanitizedSmallIndexes) do
        local assembledGap = {}
        for __, _val in ipairs(val) do
            assembledGap[#assembledGap + 1] = smallerPolygon[_val]
        end



        polygonGaps[#polygonGaps + 1] = self:reorderSlaveToMaster(assembledGap, smallerPolygon) --assembledGap
    end
    return polygonGaps
end

-- Reorders slaveVertTable to match the order of corresponding entries in masterVertTable.
-- Matching is done by x/y field equality (exact matches).
-- Behavior:
--   - Only entries in slave that also exist in master (by x,y) are included in the output.
--   - Duplicates are handled in the order they appear in master.
--   - Time complexity: O(#master + #slave)
--- @function AETHR.POLY:reorderSlaveToMaster
--- @param slaveVertTable Vec2Like[] Array of vertices to reorder
--- @param masterVertTable Vec2Like[] Reference array ordering
--- @return Vec2Like[] Reordered array of slave vertices matching master's order where possible
function AETHR.POLY:reorderSlaveToMaster(slaveVertTable, masterVertTable)
    -- Reorders entries from `slaveVertTable` to match the order they appear in `masterVertTable`.
    -- Matching uses rounded coordinates (x,y) to `precision` decimals to allow near-equality.
    -- Returns a new array containing slave vertices ordered by their first match in master.
    if type(slaveVertTable) ~= "table" or type(masterVertTable) ~= "table" then
        return {}
    end

    -- Number of decimal places to consider when comparing coordinates.
    -- Adjust as needed; using 3 decimals for typical spatial data is a reasonable default.
    local precision = 3
    local fmt = "%." .. tostring(precision) .. "f"

    local function keyOf(v)
        if not v then return nil end
        local x = v.x or 0
        local y = v.y or v.z or 0
        return string.format(fmt, x) .. ":" .. string.format(fmt, y)
    end

    -- Build buckets of slave vertices keyed by rounded coords.
    -- Each bucket keeps a list and a read index to avoid expensive table.remove at front.
    local buckets = {}
    for i = 1, #slaveVertTable do
        local v = slaveVertTable[i]
        if type(v) == "table" and (v.x ~= nil or v.y ~= nil or v.z ~= nil) then
            local k = keyOf(v)
            if k then
                if not buckets[k] then buckets[k] = { items = {}, pos = 1 } end
                buckets[k].items[#buckets[k].items + 1] = v
            end
        end
    end

    -- Walk master in order and pull a matching slave entry (if any) from the corresponding bucket.
    local out = {}
    local outIdx = 1
    for i = 1, #masterVertTable do
        local mv = masterVertTable[i]
        if type(mv) == "table" and (mv.x ~= nil or mv.y ~= nil or mv.z ~= nil) then
            local k = keyOf(mv)
            local b = buckets[k]
            if b and b.pos <= #b.items then
                out[outIdx] = b.items[b.pos]
                outIdx = outIdx + 1
                b.pos = b.pos + 1
            end
        end
    end

    return out
end

--- Reverse the order of vertices in a table (returns a new table).
--- @param vertTable Vec2Like[] Array of vertices
--- @return Vec2Like[] Reversed vertex array
function AETHR.POLY:reverseVertOrder(vertTable)
    local reverseVertTable = {}
    for i = #vertTable, 1, -1 do
        reverseVertTable[#reverseVertTable + 1] = vertTable[i]
    end
    return reverseVertTable
end

--- Returns a center point for a list of 2D vertices.
--- Behavior:
--- - 0 vertices: returns { x = 0, y = 0 }
--- - 1 vertex : returns that vertex (normalized to {x,y})
--- - 2 vertices: returns the midpoint between them
--- - 3+ vertices: returns the arithmetic centroid (average of vertex coordinates)
--- Accepts vertex tables that use .y or .z for the vertical coordinate; output uses .y.
--- @function AETHR.POLY:getCenterPoint
--- @param vertTable Vec2Like[] Array of points `{x,y}` or `{x,z}`
--- @return Vec2 { x = number, y = number }
function AETHR.POLY:getCenterPoint(vertTable)
    -- Validate input
    if type(vertTable) ~= "table" or #vertTable == 0 then
        return { x = 0, y = 0 }
    end

    -- Single point: normalize and return
    if #vertTable == 1 then
        local p = self:normalizePoint(vertTable[1])
        return { x = p.x, y = p.y }
    end

    -- Two points: midpoint
    if #vertTable == 2 then
        local a = self:normalizePoint(vertTable[1])
        local b = self:normalizePoint(vertTable[2])
        return { x = (a.x + b.x) / 2, y = (a.y + b.y) / 2 }
    end

    -- Three or more: treat as polygon vertices and return arithmetic centroid (average)
    local pts = {}
    for i = 1, #vertTable do
        pts[i] = self:normalizePoint(vertTable[i])
    end

    local cx, cy = 0, 0
    if self.MATH and self.MATH.centroid then
        cx, cy = self.MATH:centroid(pts)
    else
        for i = 1, #pts do
            cx = cx + (pts[i].x or 0)
            cy = cy + (pts[i].y or 0)
        end
        cx = cx / #pts
        cy = cy / #pts
    end

    return { x = cx, y = cy }
end

--- Computes the area-weighted centroid of a polygon using the shoelace formula.
--- Behavior:
--- - If fewer than 3 vertices are provided, falls back to simple rules:
---   * 0 vertices -> {x=0,y=0}
---   * 1 vertex  -> that vertex
---   * 2 vertices -> midpoint
--- - Accepts vertices that use .y or .z for the vertical coordinate; output uses .y.
--- @function AETHR.POLY:getCentroidPoint
--- @param vertTable Vec2Like[] Array of points `{x,y}` or `{x,z}`
--- @return Vec2 { x = number, y = number }
function AETHR.POLY:getCentroidPoint(vertTable)
    -- Validate input
    if type(vertTable) ~= "table" or #vertTable == 0 then
        return { x = 0, y = 0 }
    end

    -- 1 or 2 point fallbacks
    if #vertTable == 1 then
        local p = self:normalizePoint(vertTable[1])
        return { x = p.x, y = p.y }
    end
    if #vertTable == 2 then
        local a = self:normalizePoint(vertTable[1])
        local b = self:normalizePoint(vertTable[2])
        return { x = (a.x + b.x) / 2, y = (a.y + b.y) / 2 }
    end

    -- Normalize points to {x,y}
    local pts = {}
    for i = 1, #vertTable do
        pts[i] = self:normalizePoint(vertTable[i])
    end

    -- Shoelace accumulators
    local A2 = 0 -- 2 * area (signed)
    local cxAcc = 0
    local cyAcc = 0
    local n = #pts

    for i = 1, n do
        local j = (i % n) + 1
        local xi, yi = pts[i].x, pts[i].y
        local xj, yj = pts[j].x, pts[j].y
        local cross = xi * yj - xj * yi
        A2 = A2 + cross
        cxAcc = cxAcc + (xi + xj) * cross
        cyAcc = cyAcc + (yi + yj) * cross
    end

    local area = A2 / 2
    -- Degenerate polygon (area zero) fallback to arithmetic centroid
    if area == 0 then
        local sx, sy = 0, 0
        for i = 1, n do
            sx = sx + pts[i].x
            sy = sy + pts[i].y
        end
        return { x = sx / n, y = sy / n }
    end

    local cx = cxAcc / (6 * area)
    local cy = cyAcc / (6 * area)

    return { x = cx, y = cy }
end

--- Checks if a subcircle is completely within the boundaries of the main circle.
---
--- This function verifies whether the given `subCircle` is entirely contained within the main circle defined by `mainCircleVec2` and `mainRadius`.
---
--- @param subCircle _circle The subcircle to check.
--- @param mainCircleVec2 _vec2 The center coordinates of the main circle.
--- @param mainRadius number|integer The radius of the main circle.
--- @param threshold any The threshold for allowed proximity to the main circle's edge (0 to 1).
--- @return boolean true|false Returns true if the subcircle is entirely within the main circle; otherwise, false.
function AETHR.POLY:isSubCircleValidThreshold(subCircle, generatedSubCircles, mainCircleVec2, mainRadius, threshold)
  for _, existingSubCircle in ipairs(generatedSubCircles) do
    if self:doesCircleOverlapThreshold(subCircle, existingSubCircle, threshold) then
      return false
    end
  end
  return self:isWithinMainCircleThreshold(subCircle, mainCircleVec2, mainRadius, threshold)
end

--- Checks if two circles overlap with a specified threshold.
---
--- This function assesses whether two circles defined by `subCircle1` and `subCircle2` overlap with each other while considering a specified `threshold`. The `threshold` allows for some degree of non-overlapping.
---
--- @param subCircle1 _circle The first circle to check for overlap.
--- @param subCircle2 _circle The second circle to check for overlap.
--- @param threshold any The threshold for allowed overlap (0 to 1).
--- @return boolean true|false Returns true if the circles overlap within the given threshold; otherwise, false.
function AETHR.POLY:doesCircleOverlapThreshold(subCircle1, subCircle2, threshold)
  -- Normalize threshold to [0,1]
  local t = tonumber(threshold) or 0
  if t < 0 then t = 0 end
  if t > 1 then t = 1 end

  local dx = (subCircle1.center.x or 0) - (subCircle2.center.x or 0)
  local dy = (subCircle1.center.y or 0) - (subCircle2.center.y or 0)
  local distanceBetweenCenters = math.sqrt(dx * dx + dy * dy)

  local r1 = subCircle1.radius or 0
  local r2 = subCircle2.radius or 0
  local rSum = r1 + r2

  -- overlapDepth is how much the circles penetrate each other (0 = tangent or separated)
  local overlapDepth = math.max(0, rSum - distanceBetweenCenters)

  -- Interpret threshold `t` such that:
  --  t == 1.0 -> do not allow any overlap (allowedOverlap == 0)
  --  t == 0.0 -> allow full overlap up to rSum
  local allowedOverlap = (1 - t) * rSum

  -- Return true when the actual overlap depth exceeds the allowedOverlap.
  return overlapDepth > allowedOverlap
end



--- @return boolean true|false Returns true if the circles overlap; otherwise, false.
function AETHR.POLY:isWithinMainCircleThreshold(subCircle, mainCircleVec2, mainRadius, threshold)
  local dx = subCircle.center.x - mainCircleVec2.x
  local dy = subCircle.center.y - mainCircleVec2.y
  local distanceToCenter = math.sqrt(dx * dx + dy * dy)
  local allowedOutside = subCircle.diameter / 2 * threshold
  return distanceToCenter + subCircle.diameter / 2 - allowedOutside <= mainRadius
end

--- Generate sub circles within a main circles, avoiding no-go areas and excessive overlap.
--- @param numSubZones number Number of sub zones to generate.
--- @param subZoneMinRadius number Minimum radius for each sub zone in meters.
--- @param mainZoneCenter _vec2 Center point of the main zone.
--- @param mainZoneRadius number Radius of the main zone in meters.
--- @param overlapFactor number Overlap factor (0.0 = no overlap, 1.0 = full overlap allowed).
--- @param checkNOGO boolean|nil If true, avoid no-go areas. Defaults to false if nil.
--- @param restrictedZones table List of restricted zones to avoid
--- @return _circle[] generatedSubZones List of generated sub zones as _circle instances.
function AETHR.POLY:generateSubCircles(numSubZones, subZoneMinRadius, mainZoneCenter, mainZoneRadius, overlapFactor,
                                          checkNOGO, restrictedZones)

    checkNOGO = checkNOGO and checkNOGO or false
    local generatedSubZones = {}
    local attempts = 0
    local operationLimit = self.SPAWNER.DATA.CONFIG.operationLimit or 100
    local attemptLimit = numSubZones * operationLimit

    repeat
        local glassBreak = 0
        local subZone = {}
        local subZoneRadius

        repeat
            -- Try to find a valid non-NOGO coordinate within operationLimit attempts.
            local found = false
            -- Continuous random sampling (avoid integer-only math.random(a,b) truncation)
            subZoneRadius = ((subZoneMinRadius) + (mainZoneRadius - subZoneMinRadius) * math.random()) / 2
            local angle = 2 * math.pi * math.random()
            local maxDistFromCenter = mainZoneRadius - subZoneRadius
            local minDistFromCenter = subZoneRadius
            local distFromCenter = minDistFromCenter + (maxDistFromCenter - minDistFromCenter) * math.random()
            local subZoneCenter = {
                x = mainZoneCenter.x + distFromCenter * math.cos(angle),
                y = mainZoneCenter.y + distFromCenter * math.sin(angle)
            }

            if checkNOGO and not self.SPAWNER:checkIsInNOGO(subZoneCenter, restrictedZones) then
                subZone = self.AETHR._circle:New(subZoneCenter, subZoneRadius)
                found = true
            elseif not checkNOGO then
                subZone = self.AETHR._circle:New(subZoneCenter, subZoneRadius)
                found = true
            end

            glassBreak = glassBreak + 1
        until found or glassBreak >= operationLimit

        if self:isSubCircleValidThreshold(subZone, generatedSubZones, mainZoneCenter, mainZoneRadius, overlapFactor) then
            table.insert(generatedSubZones, subZone)
        end

        attempts = attempts + 1
    until #generatedSubZones == numSubZones or attempts >= attemptLimit -- budget exhausted; exit after this iteration

    return generatedSubZones
end