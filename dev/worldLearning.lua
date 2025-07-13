AETHR.worldLearning = {}

-- Divide a rectangle into sub-rectangles of given area (with tolerance)
function AETHR.worldLearning.divideRectangle(bounds, area, tolerance)
    -- Example usage:
    --[[
        local bounds = { X = { min = -600000, max = 400000 }, Z = { min = -570000, max = 1130000 } }
        local area = 10000000000
        local tolerance = 2560000
        local Divisions = AETHR.worldLearning.divideRectangle(bounds, area, tolerance)
        -- Divisions is now an array of rectangles as specified
        ]]

    local x_min, x_max = bounds.X.min, bounds.X.max
    local z_min, z_max = bounds.Z.min, bounds.Z.max
    local width = x_max - x_min
    local height = z_max - z_min
    local total_area = width * height

    -- Estimate number of divisions
    local n_div = math.max(1, math.floor(total_area / area + 0.5))

    -- Try to find grid (nx, nz) such that each cell area is within tolerance
    local best_nx, best_nz, best_err = 1, n_div, math.huge
    for nx = 1, n_div do
        local nz = math.ceil(n_div / nx)
        local cell_w = width / nx
        local cell_h = height / nz
        local cell_area = cell_w * cell_h
        local err = math.abs(cell_area - area)
        if err <= tolerance and err < best_err then
            best_nx, best_nz, best_err = nx, nz, err
        end
    end

    -- If no grid found within tolerance, use closest found
    local nx, nz = best_nx, best_nz
    local cell_w = width / nx
    local cell_h = height / nz

    local divisions = {}
    local idx = 1
    for i = 0, nx - 1 do
        for j = 0, nz - 1 do
            local x0 = x_min + i * cell_w
            local x1 = x_min + (i + 1) * cell_w
            local z0 = z_min + j * cell_h
            local z1 = z_min + (j + 1) * cell_h
            divisions[idx] = {
                [1] = { x = x0, z = z0 },
                [2] = { x = x1, z = z0 },
                [3] = { x = x1, z = z1 },
                [4] = { x = x0, z = z1 }
            }
            idx = idx + 1
        end
    end
    return divisions
end
