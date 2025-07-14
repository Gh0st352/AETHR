AETHR.math = {}

-- Convert bounds (min/max X and Z values) to a 4-point polygon array
-- This function takes a bounds object with min/max X and Z values and converts it into a polygon array
-- representing the corners of the bounding box.
function AETHR.math.convertBoundsToPolygon(bounds)
    -- Convert min/max X and Z values to a 4-point polygon array
    local polygon = {
        { x = bounds.X.min, z = bounds.Z.min }, -- bottom left
        { x = bounds.X.max, z = bounds.Z.min }, -- bottom right
        { x = bounds.X.max, z = bounds.Z.max }, -- top right
        { x = bounds.X.min, z = bounds.Z.max }  -- top left
    }

    polygon = AETHR.math.ensureConvex(polygon)

    return polygon
end

-- Calculate the cross product (determinant) of three points in 3D space
-- This is used to determine the orientation of the polygon formed by the points
function AETHR.math.crossProduct(p1, p2, p3)
    -- Get the appropriate z coordinate (using y as fallback) for each point
    local z1 = p1.z or p1.y
    local z2 = p2.z or p2.y
    local z3 = p3.z or p3.y

    -- Calculate and return the cross product (determinant) of the vectors formed by the three points
    return (p2.x - p1.x) * (z3 - z1) - (z2 - z1) * (p3.x - p1.x)
end

-- Ensure a 4-sided polygon is convex by checking the signs of the cross products
-- If not convex, swap the last two vertices to make it convex
function AETHR.math.ensureConvex(coords)
    -- Calculate the signs of the cross products of consecutive vertices
    local signs = {
        AETHR.math.crossProduct(coords[1], coords[2], coords[3]) >= 0,
        AETHR.math.crossProduct(coords[2], coords[3], coords[4]) >= 0,
        AETHR.math.crossProduct(coords[3], coords[4], coords[1]) >= 0,
        AETHR.math.crossProduct(coords[4], coords[1], coords[2]) >= 0
    }

    -- If the signs are not consistent, swap the last two vertices
    if not (signs[1] == signs[2] and signs[2] == signs[3] and signs[3] == signs[4]) then
        coords[3], coords[4] = coords[4], coords[3]
    end

    return coords
end

-- Calculate area of a polygon using the Shoelace formula
function AETHR.math.polygonArea(polygon)
    local numVertices = #polygon
    if numVertices < 3 then
        return 0 -- A polygon with less than 3 vertices has no area
    end

    local sum = 0
    for i = 1, numVertices do
        local j = i % numVertices + 1 -- Next vertex, with wrap-around
        sum = sum + (polygon[i].x * polygon[j].z - polygon[j].x * polygon[i].z)
    end
    return math.abs(sum) / 2
end

-- Divide a 4-sided polygon into sub-polygons of given area
function AETHR.math.dividePolygon(polygon, targetArea)
    -- Calculate total area of the polygon
    local totalArea = AETHR.math.polygonArea(polygon)
    local numDivisions = math.max(1, math.floor(totalArea / targetArea + 0.5))

    -- Create vertices for left and right edges of the polygon
    local leftEdge = { polygon[1], polygon[4] }
    local rightEdge = { polygon[2], polygon[3] }

    -- Calculate rows and columns based on aspect ratio
    local width = math.sqrt((polygon[2].x - polygon[1].x) ^ 2 + (polygon[2].z - polygon[1].z) ^ 2)
    local height = math.sqrt((polygon[4].x - polygon[1].x) ^ 2 + (polygon[4].z - polygon[1].z) ^ 2)
    local aspectRatio = width / height

    local cols = math.ceil(math.sqrt(numDivisions * aspectRatio))
    local rows = math.ceil(numDivisions / cols)

    -- Ensure we have at least the required number of divisions
    while rows * cols < numDivisions do
        if width > height then
            cols = cols + 1
        else
            rows = rows + 1
        end
    end

    local divisions = {}

    for row = 0, rows - 1 do
        -- Calculate top and bottom points for this row
        local topFraction = (row + 1) / rows
        local bottomFraction = row / rows

        local bottomLeft = {
            x = leftEdge[1].x + bottomFraction * (leftEdge[2].x - leftEdge[1].x),
            z = leftEdge[1].z + bottomFraction * (leftEdge[2].z - leftEdge[1].z)
        }
        local bottomRight = {
            x = rightEdge[1].x + bottomFraction * (rightEdge[2].x - rightEdge[1].x),
            z = rightEdge[1].z + bottomFraction * (rightEdge[2].z - rightEdge[1].z)
        }
        local topLeft = {
            x = leftEdge[1].x + topFraction * (leftEdge[2].x - leftEdge[1].x),
            z = leftEdge[1].z + topFraction * (leftEdge[2].z - leftEdge[1].z)
        }
        local topRight = {
            x = rightEdge[1].x + topFraction * (rightEdge[2].x - rightEdge[1].x),
            z = rightEdge[1].z + topFraction * (rightEdge[2].z - rightEdge[1].z)
        }

        for col = 0, cols - 1 do
            local leftFraction = col / cols
            local rightFraction = (col + 1) / cols

            local subPoly = {
                { -- Bottom left
                    x = bottomLeft.x + leftFraction * (bottomRight.x - bottomLeft.x),
                    z = bottomLeft.z + leftFraction * (bottomRight.z - bottomLeft.z)
                },
                { -- Bottom right
                    x = bottomLeft.x + rightFraction * (bottomRight.x - bottomLeft.x),
                    z = bottomLeft.z + rightFraction * (bottomRight.z - bottomLeft.z)
                },
                { -- Top right
                    x = topLeft.x + rightFraction * (topRight.x - topLeft.x),
                    z = topLeft.z + rightFraction * (topRight.z - topLeft.z)
                },
                { -- Top left
                    x = topLeft.x + leftFraction * (topRight.x - topLeft.x),
                    z = topLeft.z + leftFraction * (topRight.z - topLeft.z)
                }
            }
            divisions[#divisions + 1] = {}
            divisions[#divisions].corners = subPoly
        end
    end

    return divisions
end

function AETHR.math.convertZoneToLines(zone)
    local lines = {}

    -- Iterate through the points in the zone
    for i = 1, #zone do
        -- Determine the next point (if the current point is the last one, the next is the first)
        local nextIndex = (i == #zone) and 1 or (i + 1)

        -- Create a line segment between the current point and the next point
        table.insert(lines, { { x = zone[i].x, y = zone[i].y }, { x = zone[nextIndex].x, y = zone[nextIndex].y } })
    end

    return lines
end

function AETHR.math.computeRatio(A, B)
    if A == 0 or B == 0 then
        return 0.00
    end
    return (A > B) and (B / A) or (A / B)
end

function AETHR.math.lineLength(line)
    -- Calculate the differences in x and y coordinates between the two endpoints of the line
    local dx = line[2].x - line[1].x
    local dy = line[2].y - line[1].y
    -- Use the Pythagorean theorem to compute the length of the line segment
    return math.sqrt(dx ^ 2 + dy ^ 2)
end

function AETHR.math.getEquallySpacedPoints(InputLine, DesiredPoints)
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

function AETHR.math.distanceSquared(ax, ay, bx, by)
    -- Calculate the differences in x and y coordinates between the two points
    local dx = ax - bx
    local dy = ay - by

    -- Return the squared distance using the Pythagorean theorem
    return dx * dx + dy * dy
end

function AETHR.math.dot(ax, ay, bx, by)
    -- Return the dot product of the two vectors
    return ax * bx + ay * by
end

function AETHR.math.pointToSegmentSquared(px, py, ax, ay, bx, by)
    -- Calculate the squared distance between the endpoints of the segment
    local l2 = AETHR.math.distanceSquared(ax, ay, bx, by)

    -- If the segment is a point, return the squared distance to the point
    if l2 == 0 then return AETHR.math.distanceSquared(px, py, ax, ay) end

    -- Project the point onto the line segment and find the parameter t
    local t = AETHR.math.dot(px - ax, py - ay, bx - ax, by - ay) / l2

    -- If t is outside [0, 1], the point lies outside the segment, so return the squared distance to the nearest endpoint
    if t < 0 then return AETHR.math.distanceSquared(px, py, ax, ay) end
    if t > 1 then return AETHR.math.distanceSquared(px, py, bx, by) end

    -- Compute the squared distance from the point to its projection on the segment
    return AETHR.math.distanceSquared(px, py, ax + t * (bx - ax), ay + t * (by - ay))
end

function AETHR.math.isWithinOffset(LineA, LineB, Offset)
    local DesiredPoints = 11
    -- Compute the ratio of the lengths of LineA and LineB
    local PointConfirmRate = AETHR.math.computeRatio(AETHR.math.lineLength(LineA), AETHR.math.lineLength(LineB))
    -- Compute the number of confirmation points needed based on the desired points and the computed ratio
    local threshold = DesiredPoints * PointConfirmRate
    -- Nested function to check if the sampled points on one line are within the offset of the other line
    local function checkPointsWithinOffset(lineToSample, lineToCheckAgainst)
        local ticker = 0
        -- Sample equally spaced points from the line
        local points = AETHR.math.getEquallySpacedPoints(lineToSample, DesiredPoints)
        -- Check each sampled point against the other line to determine proximity
        for _, point in ipairs(points) do
            if math.sqrt(AETHR.math.pointToSegmentSquared(point.x, point.y, lineToCheckAgainst[1].x, lineToCheckAgainst[1].y, lineToCheckAgainst[2].x, lineToCheckAgainst[2].y)) <= Offset then
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

function AETHR.math.getMidpoint(line)
    -- Calculate the x and y coordinates of the midpoint using the average of the endpoints' coordinates
    return {
        x = (line[1].x + line[2].x) / 2,
        y = (line[1].y + line[2].y) / 2
    }
end

function AETHR.math.calculateLineSlope(line)
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

function AETHR.math.findPerpendicularEndpoints(Point, line, length)
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

function AETHR.math.PointWithinShape(P, Polygon)
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
        if AETHR.math.isIntersect(side, { p1 = normalizedP, p2 = extreme }) then
            -- If the point P is collinear with the side of the polygon, check if it lies on the segment
            if AETHR.math.direction(side.p1, normalizedP, side.p2) == 0 then
                return AETHR.math.onLine(side, normalizedP)
            end

            -- Increment the count of intersections
            count = count + 1
        end

        i = next
    until i == 1

    -- Return `true` if count is odd, `false` otherwise
    return (count % 2) == 1
end

function AETHR.math.isIntersect(l1, l2)
    -- Calculate orientation values for each pair of points from the two lines
    local dir1 = AETHR.math.direction(l1.p1, l1.p2, l2.p1)
    local dir2 = AETHR.math.direction(l1.p1, l1.p2, l2.p2)
    local dir3 = AETHR.math.direction(l2.p1, l2.p2, l1.p1)
    local dir4 = AETHR.math.direction(l2.p1, l2.p2, l1.p2)
    -- If orientations of the endpoints with respect to each line are different, the lines intersect
    if dir1 ~= dir2 and dir3 ~= dir4 then
        return true
    end
    -- Check for colinearity and if a point of one line lies on the other line
    if dir1 == 0 and AETHR.math.onLine(l1, l2.p1) then
        return true
    end
    if dir2 == 0 and AETHR.math.onLine(l1, l2.p2) then
        return true
    end
    if dir3 == 0 and AETHR.math.onLine(l2, l1.p1) then
        return true
    end
    if dir4 == 0 and AETHR.math.onLine(l2, l1.p2) then
        return true
    end
    -- If none of the above conditions are met, lines do not intersect
    return false
end

function AETHR.math.direction(a, b, c)
    local val = (b.y - a.y) * (c.x - b.x) - (b.x - a.x) * (c.y - b.y)

    -- Check if the points are collinear
    if val == 0 then
        return 0
        -- Check if the direction is counterclockwise
    elseif val < 0 then
        return 2
        -- If not collinear and not counterclockwise, then it's clockwise
    else
        return 1
    end
end

function AETHR.math.onLine(l1, p)
    -- Check if the x and y coordinates of the point are within the bounds of the line segment's endpoints
    if (p.x >= math.min(l1.p1.x, l1.p2.x) and p.x <= math.max(l1.p1.x, l1.p2.x)
            and p.y >= math.min(l1.p1.y, l1.p2.y) and p.y <= math.max(l1.p1.y, l1.p2.y)) then
        return true
    end

    return false
end
