--- @class AETHR.MATH
--- @brief 
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
AETHR.MATH = {} ---@diagnostic disable-line

function AETHR.MATH:New(c)
    local instance = {

    }
    return instance
end

--- Calculates the 2D cross product (determinant) of three points.
--- Used to determine orientation (clockwise, counterclockwise, or colinear).
--- @function crossProduct
--- @param p1 table First point with `.x`, `.z` or `.y`
--- @param p2 table Second point
--- @param p3 table Third point
--- @return number Determinant value (positive = CCW, negative = CW, zero = colinear)
function AETHR.MATH:crossProduct(p1, p2, p3)
    local z1 = p1.z or p1.y
    local z2 = p2.z or p2.y
    local z3 = p3.z or p3.y
    return (p2.x - p1.x) * (z3 - z1) - (z2 - z1) * (p3.x - p1.x)
end



--- Computes ratio of two values (min/max) safely handling zero.
--- @function computeRatio
--- @param A number First value
--- @param B number Second value
--- @return number Ratio in [0,1]
function AETHR.MATH:computeRatio(A, B)
    if A == 0 or B == 0 then return 0 end
    return (A > B) and (B/A) or (A/B)
end



--------------------------------------------------------------------------------
--- Computes the squared Euclidean distance between two 2D points.
--- This avoids the costly square-root when only comparison of distances is required.
--- @param ax number X coordinate of first point.
--- @param ay number Y coordinate of first point.
--- @param bx number X coordinate of second point.
--- @param by number Y coordinate of second point.
--- @return number Squared distance: (ax-bx)^2 + (ay-by)^2.
function AETHR.MATH:distanceSquared(ax, ay, bx, by)
    -- Calculate the differences in x and y coordinates between the two points
    local dx = ax - bx
    local dy = ay - by

    -- Return the squared distance using the Pythagorean theorem
    return dx * dx + dy * dy
end

--------------------------------------------------------------------------------
--- Computes the dot product of two 2D vectors.
--- @function AETHR.MATH.dot
--- @param ax number X component of first vector.
--- @param ay number Y component of first vector.
--- @param bx number X component of second vector.
--- @param by number Y component of second vector.
--- @return number Dot product: ax*bx + ay*by.
function AETHR.MATH:dot(ax, ay, bx, by)
    -- Return the dot product of the two vectors
    return ax * bx + ay * by
end


--------------------------------------------------------------------------------
--- Computes the orientation of the ordered triplet (a, b, c).
---
--- Returns values:
--- - 0 if collinear
--- - 1 if clockwise
--- - 2 if counterclockwise
---
--- Formula used (cross-product sign):
--- val = (b.y - a.y) * (c.x - b.x) - (b.x - a.x) * (c.y - b.y)
--- @function AETHR.MATH.direction
--- @param a table First point with numeric x and y.
--- @param b table Second point with numeric x and y.
--- @param c table Third point with numeric x and y.
--- @return integer 0 = collinear, 1 = clockwise, 2 = counterclockwise.
function AETHR.MATH:direction(a, b, c)
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

