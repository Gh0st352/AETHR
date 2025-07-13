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
    -- Calculate and return the cross product (determinant) of the vectors formed by the three points
    return (p2.x - p1.x) * (p3.z - p1.z) - (p2.z - p1.z) * (p3.x - p1.x)
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



-- Divide a 4-sided polygon into sub-polygons of given area (with tolerance)
function AETHR.math.dividePolygon(polygon, targetArea, tolerance)
    -- Calculate total area of the polygon
    local totalArea = AETHR.math.polygonArea(polygon)
    local numDivisions = math.max(1, math.floor(totalArea / targetArea + 0.5))

    local divisions = {}
    local stepX = (polygon[2].x - polygon[1].x) / numDivisions
    local stepZ = (polygon[4].z - polygon[1].z) / numDivisions

    for i = 0, numDivisions - 1 do
        local xStart = polygon[1].x + i * stepX
        local xEnd = xStart + stepX
        local zStart = polygon[1].z + i * stepZ
        local zEnd = zStart + stepZ

        divisions[#divisions + 1] = {
            { x = xStart, z = zStart },
            { x = xEnd, z = zStart },
            { x = xEnd, z = zEnd },
            { x = xStart, z = zEnd }
        }
    end
    return divisions
end
