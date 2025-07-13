AETHR.math = {}

-- Calculate area of a quadrilateral using the Shoelace formula
function AETHR.math.polygonArea(polygon)
    local sum = 0

    -- Check if polygon is in bounding box format (with X and Z min/max values)
    if polygon.X and polygon.Z then
        -- Convert bounding box to corner points
        local corners = {
            { x = polygon.X.min, z = polygon.Z.min }, -- bottom left
            { x = polygon.X.max, z = polygon.Z.min }, -- bottom right
            { x = polygon.X.max, z = polygon.Z.max }, -- top right
            { x = polygon.X.min, z = polygon.Z.max } -- top left
        }
        polygon = corners
    end

    for i = 1, 4 do
        local j = i % 4 + 1
        sum = sum + (polygon[i].x * polygon[j].z - polygon[j].x * polygon[i].z)
    end
    return math.abs(sum) / 2
end

-- Bilinear interpolation for mapping grid to polygon
function AETHR.math.bilinearInterpolation(u, v, polygon)
    if polygon.X and polygon.Z then
        -- Convert bounding box to corner points
        local corners = {
            { x = polygon.X.min, z = polygon.Z.min }, -- bottom left
            { x = polygon.X.max, z = polygon.Z.min }, -- bottom right
            { x = polygon.X.max, z = polygon.Z.max }, -- top right
            { x = polygon.X.min, z = polygon.Z.max } -- top left
        }
        polygon = corners
    end
    -- Bilinear interpolation formula for quadrilateral
    local x = (1 - u) * (1 - v) * polygon[1].x + u * (1 - v) * polygon[2].x + u * v * polygon[3].x + (1 - u) * v *
    polygon[4].x
    local z = (1 - u) * (1 - v) * polygon[1].z + u * (1 - v) * polygon[2].z + u * v * polygon[3].z + (1 - u) * v *
    polygon[4].z
    return { x = x, z = z }
end

-- Divide a 4-sided polygon into sub-polygons of given area (with tolerance)
function AETHR.math.dividePolygon(polygon, targetArea, tolerance)
    -- -- Example usage:
    -- --[
    --     local polygon = {
    --         {x = -600000, z = -570000},
    --         {x = 400000, z = -570000},
    --         {x = 400000, z = 1130000},
    --         {x = -600000, z = 1130000}
    --     }
    --     local targetArea = 10000000000
    --     local tolerance = 2560000
    --     local divisions = AETHR.math.dividePolygon(polygon, targetArea, tolerance)
    -- ]

    -- Calculate total area of the polygon
    local totalArea = AETHR.math.polygonArea(polygon)

    -- Estimate number of divisions needed
    local numDivisions = math.max(1, math.floor(totalArea / targetArea + 0.5))

    -- Find the best grid dimensions to achieve target area
    local bestNx, bestNz, bestError = 1, numDivisions, math.huge
    for nx = 1, numDivisions do
        local nz = math.ceil(numDivisions / nx)
        local cellArea = totalArea / (nx * nz)
        local error = math.abs(cellArea - targetArea)

        if error <= tolerance and error < bestError then
            bestNx, bestNz, bestError = nx, nz, error
        end
    end

    local nx, nz = bestNx, bestNz
    local divisions = {}
    local idx = 1

    -- Create grid using bilinear interpolation
    for i = 0, nx - 1 do
        for j = 0, nz - 1 do
            local u1 = i / nx
            local u2 = (i + 1) / nx
            local v1 = j / nz
            local v2 = (j + 1) / nz

            -- Calculate the four corners of this sub-polygon
            local p1 = AETHR.math.bilinearInterpolation(u1, v1, polygon)
            local p2 = AETHR.math.bilinearInterpolation(u2, v1, polygon)
            local p3 = AETHR.math.bilinearInterpolation(u2, v2, polygon)
            local p4 = AETHR.math.bilinearInterpolation(u1, v2, polygon)

            divisions[idx] = {
                [1] = p1,
                [2] = p2,
                [3] = p3,
                [4] = p4
            }
            idx = idx + 1
        end
    end

    return divisions
end
