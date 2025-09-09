--- @class __template
--- @field minX number
AETHR.__template = {} ---@diagnostic disable-line
---
--- @param c table
--- @return __template instance
function AETHR.__template:New(c)
    local instance = {

    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end


--- @class _ColorRGBA
--- @field r number
--- @field g number
--- @field b number
--- @field a number
AETHR._ColorRGBA = {} ---@diagnostic disable-line
--- Create a new RGBA color
--- @param r number|nil
--- @param g number|nil
--- @param b number|nil
--- @param a number|nil
--- @return _ColorRGBA instance
function AETHR._ColorRGBA:New(r, g, b, a)
    local instance = {
        r = r or 0,
        g = g or 0,
        b = b or 0,
        a = a or 0,
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- @alias _LineVec2 _vec2[]        -- 2-length array representing a line segment
--- @alias _PolygonVec2 _vec2[]     -- 3+ length array of vertices
--- @alias _PolygonList _PolygonVec2[]


--- @class _WorldBoundsAxis
--- @field min number
--- @field max number
AETHR._WorldBoundsAxis = {} ---@diagnostic disable-line
--- Create a new axis bounds descriptor
--- @param min number|nil
--- @param max number|nil
--- @return _WorldBoundsAxis instance
function AETHR._WorldBoundsAxis:New(min, max)
    local instance = {
        min = min or 0,
        max = max or 0,
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end


--- @class _WorldBounds
--- @field X _WorldBoundsAxis
--- @field Z _WorldBoundsAxis
AETHR._WorldBounds = {} ---@diagnostic disable-line
--- Create new world bounds (XZ axes)
--- @param X _WorldBoundsAxis|nil
--- @param Z _WorldBoundsAxis|nil
--- @return _WorldBounds instance
function AETHR._WorldBounds:New(X, Z)
    local instance = {
        X = X or AETHR._WorldBoundsAxis:New(0, 0),
        Z = Z or AETHR._WorldBoundsAxis:New(0, 0),
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end


--- @class _ZoneBorder
--- @field OwnedByCoalition integer Coalition that currently owns this border segment (0 = neutral)
--- @field ZoneLine _LineVec2
--- @field ZoneLineLen number
--- @field ZoneLineMidP _vec2
--- @field ZoneLineSlope number|nil
--- @field ZoneLinePerpendicularPoint _vec2|nil
--- @field NeighborLine _LineVec2
--- @field NeighborLineLen number
--- @field NeighborLineMidP _vec2
--- @field NeighborLineSlope number|nil
--- @field NeighborLinePerpendicularPoint _vec2|nil
--- @field MarkID table<integer, integer> Map 0..2 -> mark IDs
AETHR._ZoneBorder = {} ---@diagnostic disable-line
--- Create a new zone border descriptor
--- @param OwnedByCoalition integer|nil
--- @param ZoneLine _LineVec2|nil
--- @param NeighborLine _LineVec2|nil
--- @param MarkID table<integer, integer>|nil
--- @return _ZoneBorder instance
function AETHR._ZoneBorder:New(OwnedByCoalition, ZoneLine, NeighborLine, MarkID)
    local instance = {
        OwnedByCoalition = OwnedByCoalition or 0,
        ZoneLine = ZoneLine or {},
        ZoneLineLen = 0,
        ZoneLineMidP = nil,
        ZoneLineSlope = nil,
        ZoneLinePerpendicularPoint = nil,
        NeighborLine = NeighborLine or {},
        NeighborLineLen = 0,
        NeighborLineMidP = nil,
        NeighborLineSlope = nil,
        NeighborLinePerpendicularPoint = nil,
        MarkID = MarkID or {},
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end



--- 3D point (vec3)
--- @class _vec3
--- @field x number
--- @field y number
--- @field z number
AETHR._vec3 = {} ---@diagnostic disable-line
--- @param x number|nil
--- @param y number|nil
--- @param z number|nil
--- @return _vec3 instance
function AETHR._vec3:New(x, y, z)
    local instance = {
        x = x or 0,
        y = y or 0,
        z = z or 0,
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

---@class _BBox
---@field minx number
---@field maxx number
---@field miny number
---@field maxy number
AETHR._BBox = {} ---@diagnostic disable-line
--- Create a new bounding box instance
--- @param minx number|nil
--- @param maxx number|nil
--- @param miny number|nil
--- @param maxy number|nil
--- @return _BBox instance
function AETHR._BBox:New(minx, maxx, miny, maxy)
    local instance = {
        minx = minx or 0,
        maxx = maxx or 0,
        miny = miny or 0,
        maxy = maxy or 0,
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

---@class _WorldDivision
---@field ID integer Unique division identifier
---@field active boolean Flag indicating if division intersects any zone
---@field corners _vec2xz[] Rectangle corners in world XZ coordinates
---@field height number|nil Optional search height in meters
AETHR._WorldDivision = {} ---@diagnostic disable-line
--- Create a new world division descriptor
--- @param ID integer|nil Unique division identifier
--- @param active boolean|nil Flag indicating if division intersects any zone
--- @param corners _vec2xz[]|nil Rectangle corners in world XZ coordinates
--- @param height number|nil Optional search height in meters
--- @return _WorldDivision instance
function AETHR._WorldDivision:New(ID, active, corners, height)
    local instance = {
        ID = ID or 0,
        active = (active ~= nil) and active or false,
        corners = corners or {},
        height = height,
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

---@class _ZoneCellEntry
---@field bbox _BBox Bounding box of the zone polygon
---@field poly _vec2[] Zone polygon in XY plane
AETHR._ZoneCellEntry = {} ---@diagnostic disable-line
--- Create a new zone cell entry
--- @param bbox _BBox|nil Bounding box of the zone polygon
--- @param poly _vec2[]|nil Zone polygon in XY plane
--- @return _ZoneCellEntry instance
function AETHR._ZoneCellEntry:New(bbox, poly)
    local instance = {
        bbox = bbox or AETHR._BBox:New(0, 0, 0, 0),
        poly = poly or {},
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

---@class _FoundObject
---@field id integer
---@field desc table
---@field position _vec3
AETHR._FoundObject = {} ---@diagnostic disable-line
--- Create a new found object descriptor
--- @param id integer|nil
--- @param desc table|nil
--- @param position _vec3|nil
--- @return _FoundObject instance
function AETHR._FoundObject:New(id, desc, position)
    local instance = {
        id = id or 0,
        desc = desc or {},
        position = position or AETHR._vec3:New(0, 0, 0),
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end



--- Data describing a shared border segment between two zones
--- This structure is used in ZONE_MANAGER:determineBorderingZones.
--- @class _BorderInfo
--- @field ZoneLine _LineVec2                        Zone's edge line segment [p1,p2]
--- @field ZoneLineLen number                        Zone edge length
--- @field ZoneLineMidP _vec2                        Midpoint of zone edge
--- @field ZoneLineSlope number|nil                  Slope (nil for vertical)
--- @field ZoneLinePerpendicularPoint _vec2|nil      Point offset perpendicular to ZoneLine
--- @field NeighborLine _LineVec2                    Neighbor's matching edge [p1,p2]
--- @field NeighborLineLen number                    Neighbor edge length
--- @field NeighborLineMidP _vec2                    Midpoint of neighbor edge
--- @field NeighborLineSlope number|nil              Neighbor slope (nil for vertical)
--- @field NeighborLinePerpendicularPoint _vec2|nil  Perpendicular offset for neighbor edge
--- @field MarkID table<integer, integer>            Map of segment index -> DCS mark ID(s)
AETHR._BorderInfo = {} ---@diagnostic disable-line
--- Create a new border info descriptor
--- @param ZoneLine _LineVec2|nil Zone's edge line segment [p1,p2]
--- @param NeighborLine _LineVec2|nil Neighbor's matching edge [p1,p2]
--- @param MarkID table<integer, integer>|nil Map of segment index -> DCS mark ID(s)
--- @return _BorderInfo instance
function AETHR._BorderInfo:New(ZoneLine, NeighborLine, MarkID)
    local instance = {
        ZoneLine = ZoneLine or {},
        ZoneLineLen = 0,
        ZoneLineMidP = nil,
        ZoneLineSlope = nil,
        ZoneLinePerpendicularPoint = nil,
        NeighborLine = NeighborLine or {},
        NeighborLineLen = 0,
        NeighborLineMidP = nil,
        NeighborLineSlope = nil,
        NeighborLinePerpendicularPoint = nil,
        MarkID = MarkID or {},
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- @class _MIZ_ZONE
--- @field name string                                        Unique zone name from env.mission
--- @field zoneId number                                      Unique numeric ID from env.mission
--- @field type number|string                                 Zone type (env.mission format)
--- @field BorderOffsetThreshold number                       Offset threshold used for arrow placement (CONFIG.MAIN.Zone.BorderOffsetThreshold)
--- @field ArrowLength number                                 Length of arrow when visualizing borders (CONFIG.MAIN.Zone.ArrowLength)
--- @field verticies (_vec2|_vec2xz)[]                        Polygon vertices; accepts {x,y} or {x,z}
--- @field ownedBy number                                     Current owning coalition (AETHR.ENUMS.Coalition)
--- @field oldOwnedBy number                                  Previous owning coalition
--- @field markID number                                      Legacy mark ID (if used for text marks)
--- @field shapeID number                                     Marker shape type (AETHR.ENUMS.MarkerTypes)
--- @field markerObject _Marker                               Marker object used for drawing the zone
--- @field readOnly boolean                                   True if zone cannot be edited
--- @field BorderingZones table<string, _BorderInfo[]>        Map: neighbor zone name -> list of border segment descriptors
--- @field Airbases table<string, _airbase>                   Airbases within this zone keyed by displayName
--- @field LinesVec2 _LineVec2[]                              Precomputed line segments from verticies
AETHR._MIZ_ZONE = {}
--- Create a new mission zone instance from an env.mission trigger zone
--- @param envZone { name: string, zoneId: number, type: integer|string, verticies: (_vec2|_vec2xz)[] }
--- @return _MIZ_ZONE instance
function AETHR._MIZ_ZONE:New(envZone)
    local instance = {
        name = envZone.name,
        zoneId = envZone.zoneId,
        type = envZone.type,
        BorderOffsetThreshold = AETHR.CONFIG.MAIN.Zone.BorderOffsetThreshold,
        ArrowLength = AETHR.CONFIG.MAIN.Zone.ArrowLength,
        verticies = envZone.verticies, --AETHR.POLY:ensureConvex(envZone.verticies),
        ownedBy = AETHR.ENUMS.Coalition.NEUTRAL,
        oldOwnedBy = 0,
        markID = 0,
        shapeID = AETHR.ENUMS.MarkerTypes.Freeform,
        markerObject = {},
        readOnly = true,
        BorderingZones = {},
        Airbases = {},
        LinesVec2 = {},
    }
    -- attach metatable so instance inherits methods from prototype
    setmetatable(instance, { __index = self })

    instance.LinesVec2 = AETHR.POLY:convertPolygonToLines(instance.verticies)

    return instance ---@diagnostic disable-line
end

--- Grid parameters for spatial indexing / cell mapping
--- @class _Grid
--- @field minX number      Grid origin X
--- @field minZ number      Grid origin Z (note: derived from maxZ input)
--- @field dx number        Cell width
--- @field dz number        Cell height
--- @field invDx number     1/dx (cached)
--- @field invDz number     1/dz (cached)
AETHR._Grid = {}
--- Create a new grid instance for spatial indexing.
--- @param c _vec2xz[] Four corner points of the bounding box: { {x1,z1}, {x2,z2}, {x3,z3}, {x4,z4} }.
--- @param minX number X-coordinate of grid origin.
--- @param maxZ number Z-coordinate reference (stored as minZ internally).
--- @param dx number Cell width.
--- @param dz number Cell height.
--- @return _Grid instance
function AETHR._Grid:New(c, minX, maxZ, dx, dz)
    local instance = {
        minX  = minX,
        minZ  = maxZ,
        dx    = dx,
        dz    = dz,
        invDx = 1 / dx, -- Inverse widths for index computation.
        invDz = 1 / dz, -- Inverse heights for index computation.
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- Description of a DCS drawing/markup element
--- @class _Marker
--- @field markID number                               Unique marker ID
--- @field string string                               Label/text shown with the marker
--- @field vec3Origin _vec3                            Origin point for the marker (vec3)
--- @field readOnly boolean                            If true, marker is not editable
--- @field message string                              Optional message text
--- @field shapeId number                              Shape type enum (e.g., freeform, line, circle)
--- @field coalition number                            Coalition ID (-1 = neutral/all)
--- @field lineType number                             Line style enum
--- @field lineColor _ColorRGBA|number[]               Line color (preferred: {r,g,b,a}; legacy: {r,g,b,a} array)
--- @field fillColor _ColorRGBA|number[]               Fill color (preferred: {r,g,b,a}; legacy: {r,g,b,a} array)
--- @field freeFormVec2Table _vec2[]                   Vertices used for freeform/drawn shapes
--- @field radius number                               Radius for circles (if shape is circle)
AETHR._Marker = {} ---@diagnostic disable-line

---
--- @param markID number
--- @param markString string|nil
--- @param vec3Origin _vec3|nil
--- @param readOnly boolean|nil
--- @param message string|nil
--- @param shapeId number|nil
--- @param coalition number|nil
--- @param lineType number|nil
--- @param lineColor _ColorRGBA|number[]|nil
--- @param fillColor _ColorRGBA|number[]|nil
--- @param freeFormVec2Table _vec2[]|nil
--- @param radius number|nil
--- @return _Marker instance
function AETHR._Marker:New(
    markID, markString, vec3Origin, readOnly,
    message, shapeId, coalition,
    lineType, lineColor, fillColor,
    freeFormVec2Table, radius)
    local instance = {
        markID = markID,
        string = markString or "",
        vec3Origin = vec3Origin or {},
        readOnly = readOnly or true,
        message = message or "",
        shapeId = shapeId or 0,
        lineType = lineType or 0,
        coalition = coalition or -1,
        lineColor = lineColor or { 0, 0, 0, 0 },     -- r,g,b,a
        fillColor = fillColor or { 0, 0, 0, 0 },     -- r,g,b,a
        freeFormVec2Table = freeFormVec2Table or {}, -- ipairs of vec2 for freeform or drawn shapes
        radius = radius or 0,                        -- radius for drawn circles
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- Airbase descriptor stored by AETHR
--- @class _airbase
--- @field id table                                    Raw engine-provided airbase identifier object
--- @field id_ number                                  Numeric ID
--- @field coordinates _vec3                           World coordinates of the airbase
--- @field description table                            Engine description (e.g., from Airbase.getDescByName)
--- @field name string                                  Airbase name
--- @field category number                              Category enum
--- @field coalition number                             Current coalition
--- @field previousCoalition number                     Previous coalition
--- @field categoryText string                          Category text
--- @field zoneName string                              Zone name this airbase belongs to (if any)
--- @field zoneObject _MIZ_ZONE|nil                     Zone object this airbase belongs to (if any)
AETHR._airbase = {} ---@diagnostic disable-line
--- Create a new airbase descriptor
--- @param id table|nil Raw engine-provided airbase identifier object
--- @param id_ number|nil Numeric ID
--- @param coordinates _vec3|nil World coordinates of the airbase
--- @param description table|nil Engine description (e.g., from Airbase.getDescByName)
--- @param zoneName string|nil Zone name this airbase belongs to (if any)
--- @param zoneObject _MIZ_ZONE|nil Zone object this airbase belongs to (if any)
--- @param name string|nil Airbase name
--- @param category number|nil Category enum
--- @param categoryText string|nil Category text
--- @param coalition number|nil Current coalition
--- @param previousCoalition number|nil Previous coalition
--- @return _airbase instance
function AETHR._airbase:New(id, id_, coordinates, description, zoneName, zoneObject, name, category, categoryText,
                            coalition, previousCoalition)
    local instance = {
        id = id or {},
        id_ = id_ or 0,
        coordinates = coordinates or { x = 0, y = 0, z = 0 },
        description = description or {},
        zoneName = zoneName or "",
        zoneObject = zoneObject or {},
        name = name or "",
        category = category or 0,
        categoryText = categoryText or "",
        coalition = coalition or 0,
        previousCoalition = previousCoalition or 0,

    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- Scheduled task descriptor used by BRAIN scheduler
--- @class _task
--- @field stopAfterTime number|nil             Max runtime in seconds (nil = no time limit)
--- @field stopAfterIterations number|nil       Max number of iterations (nil = no iteration limit)
--- @field repeatInterval number|nil            Interval between runs in seconds (nil = run once)
--- @field delay number|nil                     Initial delay before first run
--- @field taskFunction fun(...: any): any|nil  Function to execute
--- @field functionArgs table                   Arguments passed to taskFunction
--- @field iterations number                    Number of completed iterations
--- @field lastRun number                       Last execution timestamp
--- @field nextRun number                       Next scheduled execution timestamp
--- @field stopTime number|nil                  Absolute time to stop (computed from stopAfterTime)
--- @field running boolean                      True while the task is executing
--- @field active boolean                       Set false to disable scheduling
--- @field schedulerID number                   Unique ID assigned by the scheduler
--- @field repeating boolean                    True if the task will repeat
AETHR._task = {} ---@diagnostic disable-line

---
--- @param stopAfterTime number|nil Maximum time in seconds to run the task (nil = infinite).
--- @param stopAfterIterations number|nil Maximum number of iterations to run the task (nil = infinite).
--- @param repeatInterval number|nil Time in seconds between task executions (nil = run once).
--- @param delay number|nil Initial delay in seconds before first execution (default = 0).
--- @param taskFunction function Function to execute.
--- @param functionArgs table Arguments to pass to the task function.
--- @param schedulerID number Unique ID assigned by the scheduler.
--- @return _task instance
function AETHR._task:New(stopAfterTime, stopAfterIterations, repeatInterval, delay, taskFunction, functionArgs,
                         schedulerID)
    local now = AETHR.UTILS.getTime()
    local instance = {
        stopAfterTime = stopAfterTime or nil,
        -- Keep stopAfterIterations nil by default to mean "no iteration limit"
        stopAfterIterations = stopAfterIterations,
        repeatInterval = repeatInterval or nil,
        delay = delay or 0,
        taskFunction = taskFunction or nil,
        functionArgs = functionArgs or {},
        iterations = 0,
        lastRun = 0,
        nextRun = now + (delay or 0),
        stopTime = (stopAfterTime and (now + stopAfterTime)) or nil,
        running = false,
        active = true,
        schedulerID = schedulerID or 0,
        repeating = false,
    }

    if (repeatInterval and repeatInterval > 0) or (stopAfterIterations and stopAfterIterations > 1) or stopAfterTime then
        instance.repeating = true
    end
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- 2D point with x,y components
--- Represents the canonical 2D type used by POLY/MATH helpers.
--- Many functions also accept {x,z}; see _vec2xz alias below.
--- @class _vec2
--- @field x number
--- @field y number
AETHR._vec2 = {} ---@diagnostic disable-line

--- @param x number
--- @param y number
--- @return _vec2 instance
function AETHR._vec2:New(x, y)
    local instance = {
        x = x or 0,
        y = y or 0,
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- 2D point with x,y components
--- Represents the canonical 2D type used by POLY/MATH helpers.
--- Many functions also accept {x,z}; see _vec2xz alias below.
--- @class _vec2xz
--- @field x number
--- @field z number
AETHR._vec2xz = {} ---@diagnostic disable-line

--- @param x number
--- @param z number
--- @return _vec2xz instance
function AETHR._vec2xz:New(x, z)
    local instance = {
        x = x or 0,
        z = z or 0,
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end
