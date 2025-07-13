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



-- Divide a 4-sided polygon into sub-polygons of given area
function AETHR.math.dividePolygon(polygon, targetArea)
    
    -- Calculate total area of the polygon
    local totalArea = AETHR.math.polygonArea(polygon)
    local numDivisions = math.max(1, math.floor(totalArea / targetArea + 0.5))
    
    -- Create vertices for left and right edges of the polygon
    local leftEdge = { polygon[1], polygon[4] }
    local rightEdge = { polygon[2], polygon[3] }
    
    -- Calculate rows and columns based on aspect ratio
    local width = math.sqrt((polygon[2].x - polygon[1].x)^2 + (polygon[2].z - polygon[1].z)^2)
    local height = math.sqrt((polygon[4].x - polygon[1].x)^2 + (polygon[4].z - polygon[1].z)^2)
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
                {  -- Bottom left
                    x = bottomLeft.x + leftFraction * (bottomRight.x - bottomLeft.x),
                    z = bottomLeft.z + leftFraction * (bottomRight.z - bottomLeft.z)
                },
                {  -- Bottom right
                    x = bottomLeft.x + rightFraction * (bottomRight.x - bottomLeft.x),
                    z = bottomLeft.z + rightFraction * (bottomRight.z - bottomLeft.z)
                },
                {  -- Top right
                    x = topLeft.x + rightFraction * (topRight.x - topLeft.x),
                    z = topLeft.z + rightFraction * (topRight.z - topLeft.z)
                },
                {  -- Top left
                    x = topLeft.x + leftFraction * (topRight.x - topLeft.x),
                    z = topLeft.z + leftFraction * (topRight.z - topLeft.z)
                }
            }
            
            divisions[#divisions + 1] = subPoly
        end
    end
    
    return divisions
end
