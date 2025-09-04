--- @class AETHR.POLY
--- @brief Manages mission trigger zones and computes bordering relationships.
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field MATH AETHR.MATH Math helper table attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
AETHR.POLY = {}

--- @function AETHR.POLY.segmentsIntersect
--- @brief Determines if two line segments intersect or touch.
--- @param p1 table First segment endpoint `{x, y}`.
--- @param p2 table First segment endpoint `{x, y}`.
--- @param q1 table Second segment endpoint `{x, y}`.
--- @param q2 table Second segment endpoint `{x, y}`.
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
--- @param pt table Point `{x, y}` to test.
--- @param poly table Array of polygon vertices `{x, y}`.
--- @return boolean True if inside, false otherwise.
function AETHR.POLY.pointInPolygon(pt, poly)
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
--- @param A table Array of vertices `{x, y}` for polygon A.
--- @param B table Array of vertices `{x, y}` for polygon B.
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
--- @param a table Point `{x, y}`.
--- @param b table Point `{x, y}`.
--- @param c table Point `{x, y}`.
--- @return number >0 if counter-clockwise, <0 if clockwise, 0 if colinear.
function AETHR.POLY:orientation(a, b, c)
    return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)
end

--- @function AETHR.POLY.onSegment
--- @brief Checks if point `c` lies on segment `[a, b]` inclusive.
--- @param a table Endpoint `{x, y}`.
--- @param c table Point to test `{x, y}`.
--- @param b table Endpoint `{x, y}`.
--- @return boolean True if c lies on segment, false otherwise.
function AETHR.POLY:onSegment(a, c, b)
    return c.x >= math.min(a.x, b.x) and c.x <= math.max(a.x, b.x)
       and c.y >= math.min(a.y, b.y) and c.y <= math.max(a.y, b.y)
end

--- @function AETHR.POLY.getBoxPoints
--- @brief Calculates bounding box min/max points for a set of corners and height.
--- @param corners table Array of corner points (x,z)
--- @param height number Vertical extent
--- @return table { min={x,y,z}, max={x,y,z} }
function AETHR.POLY.getBoxPoints(corners, height)
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
--- Determines whether a 2D point lies strictly inside a polygon using the ray-casting algorithm.
---
--- Behavior and notes:
--- - Accepts polygons whose vertices may use fields y or z for the vertical coordinate; the function will
---   use P.y or P.z (preferring y) and uses the same coordinate in polygon vertices.
--- - If the polygon has fewer than 3 vertices, it cannot enclose an area and the function returns false.
--- - Ray-casting is done horizontally to a large positive X ("extreme") and counts edge intersections.
--- - If the point is collinear with an edge, the function uses onLine to decide if the point lies on that edge.
--- - Returns true for points strictly inside (odd number of intersections), false otherwise.
--- @function AETHR.POLY.PointWithinShape
--- @brief Determines whether a point lies strictly inside a polygon (including on-edge cases) using the ray-casting algorithm.
--- @param P table Point to test; expects numeric x and y (or z) field.
--- @param Polygon table Array of polygon vertices. Each vertex is a table with numeric x and y (or z) field.
--- @return boolean True if P is inside the polygon (or on an edge when onLine returns true), false otherwise.
function AETHR.POLY:PointWithinShape(P, Polygon)
    local n = #Polygon
    
    -- Get the appropriate vertical coordinate from P
    local vertCoord = P.y or P.z

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
            x = Polygon[i].x, 
            y = Polygon[i].y or Polygon[i].z 
        }
        
        local p2 = { 
            x = Polygon[next].x, 
            y = Polygon[next].y or Polygon[next].z 
        }
        
        local side = { p1 = p1, p2 = p2 }
        local normalizedP = { x = P.x, y = vertCoord }

        -- Check if the line segment formed by P and extreme intersects with the side of the polygon
        if self:isIntersect(side, { p1 = normalizedP, p2 = extreme }) then
            -- If the point P is collinear with the side of the polygon, check if it lies on the segment
            if self.MATH:direction(side.p1, normalizedP, side.p2) == 0 then
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
--- @param WS_Vec3 table Minimum corner vector (table with numeric x,y,z or equivalent fields).
--- @param EN_Vec3 table Maximum corner vector (table with numeric x,y,z or equivalent fields).
--- @return table Volume descriptor in the form { id = world.VolumeType.BOX, params = { min = WS_Vec3, max = EN_Vec3 } }.
function AETHR.POLY:createBox(WS_Vec3, EN_Vec3)
    local box = {
        id =  world.VolumeType.BOX,
        params = {
            min = WS_Vec3,
            max = EN_Vec3
        }
    }
    return box
end

--- Converts a polygon (list of points) into an array of line segments.
--- @function convertZoneToLines
--- @param zone table Array of points `{x,y}` or `{x,z}`
--- @return table Array of segments `{{x,y},{x,y}}`
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
--- @param polygon table Array of `{x,z}` four corners
--- @param targetArea number Desired area per sub-polygon
--- @return table Array of division tables `{ corners = {pt1,pt2,pt3,pt4} }`
function AETHR.POLY:dividePolygon(polygon, targetArea)
    local total = self:polygonArea(polygon)
    local count = math.max(1, math.floor(total / targetArea + 0.5))

    -- Define left and right edges
    local leftEdge  = { polygon[1], polygon[4] }
    local rightEdge = { polygon[2], polygon[3] }

    -- Determine grid shape by aspect ratio
    local width  = math.sqrt((polygon[2].x - polygon[1].x)^2 + (polygon[2].z - polygon[1].z)^2)
    local height = math.sqrt((polygon[4].x - polygon[1].x)^2 + (polygon[4].z - polygon[1].z)^2)
    local ratio  = width / height

    local cols = math.ceil(math.sqrt(count * ratio))
    local rows = math.ceil(count / cols)
    -- Adjust if grid smaller than needed
    while rows * cols < count do
        if width > height then cols = cols + 1 else rows = rows + 1 end
    end

    local divisions = {}
    -- Generate grid divisions
    for r = 0, rows - 1 do
        local tFrac, bFrac = (r+1)/rows, r/rows
        local bottomLeft  = { x = leftEdge[1].x  + bFrac*(leftEdge[2].x - leftEdge[1].x),
                              z = leftEdge[1].z  + bFrac*(leftEdge[2].z - leftEdge[1].z)}
        local bottomRight = { x = rightEdge[1].x + bFrac*(rightEdge[2].x - rightEdge[1].x),
                              z = rightEdge[1].z + bFrac*(rightEdge[2].z - rightEdge[1].z)}
        local topLeft     = { x = leftEdge[1].x  + tFrac*(leftEdge[2].x - leftEdge[1].x),
                              z = leftEdge[1].z  + tFrac*(leftEdge[2].z - leftEdge[1].z)}
        local topRight    = { x = rightEdge[1].x + tFrac*(rightEdge[2].x - rightEdge[1].x),
                              z = rightEdge[1].z + tFrac*(rightEdge[2].z - rightEdge[1].z)}

        for c = 0, cols - 1 do
            local lFrac, rFrac = c/cols, (c+1)/cols
            -- Interpolate four corners
            local poly = {
                { x = bottomLeft.x  + lFrac*(bottomRight.x - bottomLeft.x),
                  z = bottomLeft.z  + lFrac*(bottomRight.z - bottomLeft.z)},
                { x = bottomLeft.x  + rFrac*(bottomRight.x - bottomLeft.x),
                  z = bottomLeft.z  + rFrac*(bottomRight.z - bottomLeft.z)},
                { x = topLeft.x     + rFrac*(topRight.x     - topLeft.x),
                  z = topLeft.z     + rFrac*(topRight.z     - topLeft.z)},
                { x = topLeft.x     + lFrac*(topRight.x     - topLeft.x),
                  z = topLeft.z     + lFrac*(topRight.z     - topLeft.z)},
            }
            table.insert(divisions, { corners = poly })
        end
    end

    return divisions
end

--- Computes the area of a polygon using the Shoelace formula.
--- @function polygonArea
--- @param polygon table Array of `{x,z}` vertices
--- @return number Absolute area value
function AETHR.POLY:polygonArea(polygon)
    local n = #polygon
    if n < 3 then return 0 end
    local sum = 0
    for i = 1, n do
        local j = (i % n) + 1
        sum = sum + (polygon[i].x * polygon[j].z - polygon[j].x * polygon[i].z)
    end
    return math.abs(sum) / 2
end

--- Ensures a quadrilateral polygon is convex by checking cross product signs.
--- Swaps the last two vertices if orientation is inconsistent.
--- @function ensureConvex
--- @param coords table Array of four `{x,z}` points
--- @return table Possibly reordered convex polygon
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

--- Converts axis-aligned world bounds into a 4-point polygon.
--- Ensures convexity of the resulting polygon.
--- @function AETHR.POLY.convertBoundsToPolygon
--- @brief Converts world bounds into a convex quadrilateral polygon.
--- @param bounds table Structure with `X.min`, `X.max`, `Z.min`, `Z.max` coordinates.
--- @return table Array of four corner points `{x=number, z=number}` in clockwise order.
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
--- @param line table Two points `{ {x,y},{x,y} }`
--- @return number Length of the segment
function AETHR.POLY:lineLength(line)
    local dx = line[2].x - line[1].x
    local dy = line[2].y - line[1].y
    return math.sqrt(dx*dx + dy*dy)
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
--- @param InputLine table Two-element array of endpoints, each endpoint is a table with numeric x and y fields.
--- @param DesiredPoints integer Number of points to sample along the segment (interior points).
--- @return table OutputPoints Array of sampled points, each point being a table with x and y numeric fields.
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
--- @param LineA table Two-element array of endpoints for first line.
--- @param LineB table Two-element array of endpoints for second line.
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
--- @param line table Two-element array of endpoints, each with numeric x and y fields.
--- @return table A point with numeric fields x and y representing the midpoint of the segment.
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
--- @param line table Two-element array of endpoints, each with numeric x and y fields.
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
--- @param Point table Starting point for the perpendicular segment. Expects numeric fields x and y.
--- @param line table Two-element array of endpoints defining the reference line, each with numeric x and y fields.
--- @param length number Desired length of the perpendicular from Point to the endpoint.
--- @return table Endpoint point with numeric fields x and y located `length` away from Point along a perpendicular.
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
--- @param l1 table First line, with fields p1 and p2 (points with x and y).
--- @param l2 table Second line, with fields p1 and p2 (points with x and y).
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
--- @param l1 table Line with fields p1 and p2 (points with numeric x and y).
--- @param p table Point to test, with numeric x and y.
--- @return boolean True if p lies on the segment [l1.p1, l1.p2], false otherwise.
function AETHR.POLY:onLine(l1, p)
    -- Check if the x and y coordinates of the point are within the bounds of the line segment's endpoints
    if (p.x >= math.min(l1.p1.x, l1.p2.x) and p.x <= math.max(l1.p1.x, l1.p2.x)
            and p.y >= math.min(l1.p1.y, l1.p2.y) and p.y <= math.max(l1.p1.y, l1.p2.y)) then
        return true
    end

    return false
end
