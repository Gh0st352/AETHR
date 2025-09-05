--- @class __template
--- @field minX number
AETHR.__template = {} ---@diagnostic disable-line
--- 
--- @param c table 
--- @return __template instance
function AETHR.__template:New(c)
    local instance = {

    }
    return instance ---@diagnostic disable-line
end


--- @class _MIZ_ZONE
--- @field name string
--- @field zoneId number
--- @field type number|string
--- @field BorderOffsetThreshold number
--- @field ArrowLength number
--- @field verticies table
--- @field ownedBy number
--- @field oldOwnedBy number
--- @field markID number
--- @field readOnly boolean
--- @field BorderingZones table
--- @field Airbases table
--- @field LinesVec2 table
AETHR._MIZ_ZONE = {}
--- Create a new mission zone instance from an env.mission trigger zone
--- @param envZone table
--- @return _MIZ_ZONE instance
function AETHR._MIZ_ZONE:New(envZone)
    
    local instance = {
        name = envZone.name,
        zoneId = envZone.zoneId,
        type = envZone.type,
        BorderOffsetThreshold = AETHR.CONFIG.MAIN.Zone.BorderOffsetThreshold,
        ArrowLength = AETHR.CONFIG.MAIN.Zone.ArrowLength,
        verticies = AETHR.POLY:ensureConvex(envZone.verticies),
        ownedBy = 0,
        oldOwnedBy = 0,
        markID = 0,
        readOnly = true,
        BorderingZones = {},
        Airbases = {},
        LinesVec2 = {},
    }
    instance.LinesVec2 = AETHR.POLY:convertPolygonToLines(instance.verticies)
    
    return instance ---@diagnostic disable-line
end

--- @class _Grid
--- @field minX number
--- @field minZ number
--- @field dx number
--- @field dz number
--- @field invDx number
--- @field invDz number
AETHR._Grid = {}
--- Create a new grid instance for spatial indexing.
--- @param c table Four corner points of the bounding box: { {x1,z1}, {x2,z2}, {x3,z3}, {x4,z4} }.
--- @param minX number X-coordinate of grid origin.
--- @param maxZ number Z-coordinate of grid origin.
--- @param dx number Cell width.
--- @param dz number Cell height.
--- @return _Grid instance
function AETHR._Grid:New(c, minX, maxZ, dx, dz)
    
    local instance = {
        minX  = minX,
        minZ  = maxZ,
        dx    = dx,
        dz    = dz,
        invDx = 1 / dx,            -- Inverse widths for index computation.
        invDz = 1 / dz,            -- Inverse heights for index computation.
    }
    
    return instance ---@diagnostic disable-line
end