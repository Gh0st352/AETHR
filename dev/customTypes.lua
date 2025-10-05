--- @class __template
--- @field placeholder table
AETHR.__template = {} ---@diagnostic disable-line
---
--- @param placeholder table
--- @return __template instance
function AETHR.__template:New(placeholder)
    local instance = {

    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- @class _ColorRGBA
--- @field r number Red channel (0..255)
--- @field g number Green channel (0..255)
--- @field b number Blue channel (0..255)
--- @field a number Alpha channel (0..255)
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
--- @field min number Minimum axis value
--- @field max number Maximum axis value
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
---@field ID number Unique division identifier
---@field active boolean Flag indicating if division intersects any zone
---@field corners _vec2xz[] Rectangle corners in world XZ coordinates (exactly 4 corners expected)
---@field height number|nil Optional search height in meters
AETHR._WorldDivision = {} ---@diagnostic disable-line
--- Create a new world division descriptor
--- @param ID number|nil Unique division identifier
--- @param active boolean|nil Flag indicating if division intersects any zone
--- @param corners _vec2xz[4]|nil Rectangle corners in world XZ coordinates
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
---@field id number
---@field desc table
---@field position _vec3
--- @field New fun(id:number|nil, desc:table|nil, position:_vec3|nil): _FoundObject
AETHR._FoundObject = {} ---@diagnostic disable-line
--- Create a new found object descriptor
--- @param id number|nil
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
--- @field OwnedByCoalition integer               Coalition that currently owns this border segment (0 = neutral)
--- @field ZoneLineLen number                        Zone edge length
--- @field ZoneLineMidP _vec2                        Midpoint of zone edge
--- @field ZoneLineSlope number|nil                  Slope (nil for vertical)
--- @field ZoneLinePerpendicularPoint _vec2|nil      Point offset perpendicular to ZoneLine
--- @field NeighborLine _LineVec2                    Neighbor's matching edge [p1,p2]
--- @field NeighborLineLen number                    Neighbor edge length
--- @field NeighborLineMidP _vec2                    Midpoint of neighbor edge
--- @field NeighborLineSlope number|nil              Neighbor slope (nil for vertical)
--- @field NeighborLinePerpendicularPoint _vec2|nil  Perpendicular offset for neighbor edge
--- @field ArrowTip _vec3                            Point defining the arrow tip
--- @field ArrowEnd _vec3                            Point defining the arrow base
--- @field MarkID table<integer, integer>            Map of segment index -> DCS mark ID(s)
--- @field ArrowObjects table<integer, table>      Map of segment index -> DCS marker objects for arrows
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
        OwnedByCoalition = 0,
        ZoneLinePerpendicularPoint = nil,
        NeighborLine = NeighborLine or {},
        NeighborLineLen = 0,
        NeighborLineMidP = nil,
        NeighborLineSlope = nil,
        NeighborLinePerpendicularPoint = nil,
        ArrowTip = {},
        ArrowEnd = {},
        MarkID = MarkID or {},
        ArrowObjects = {
            [0] = {},
            [1] = {},
            [2] = {},
        },
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
--- @field shapeID number                                     Marker shape type (AETHR.ENUMS.MarkerTypes)
--- @field markerObject table|_Marker                   Marker object used for drawing the zone
--- @field readOnly boolean                                   True if zone cannot be edited
--- @field BorderingZones table<string, _BorderInfo[]>        Map: neighbor zone name -> list of border segment descriptors
--- @field Airbases table<string, _airbase>                   Airbases within this zone keyed by displayName
--- @field LinesVec2 _LineVec2[]                              Precomputed line segments from verticies
--- @field lastMarkColorOwner number                           Coalition that last set the marker color (to avoid redundant updates)
--- @field activeDivsions table<number, _WorldDivision>        Map of division ID -> division info for divisions intersecting this zone
--- @field parentAETHR AETHR|nil                             Parent AETHR instance (for access to submodules/config)
AETHR._MIZ_ZONE = {}

--- Create a new mission zone instance from an env.mission trigger zone
--- @param envZone { name: string, zoneId: number, type: integer|string, verticies: (_vec2|_vec2xz)[] }
--- @param parentAETHR AETHR|nil Optional parent AETHR instance for config access
--- @return _MIZ_ZONE instance
function AETHR._MIZ_ZONE:New(envZone, parentAETHR)
    local instance = {
        name = envZone.name,
        zoneId = envZone.zoneId,
        type = envZone.type,
        BorderOffsetThreshold = parentAETHR and parentAETHR.CONFIG.MAIN.Zone.BorderOffsetThreshold or
            AETHR.CONFIG.MAIN.Zone.BorderOffsetThreshold,
        ArrowLength = parentAETHR and parentAETHR.CONFIG.MAIN.Zone.ArrowLength or AETHR.CONFIG.MAIN.Zone.ArrowLength,
        verticies = envZone.verticies, --AETHR.POLY:ensureConvex(envZone.verticies),
        ownedBy = parentAETHR and parentAETHR.ENUMS.Coalition.NEUTRAL or AETHR.ENUMS.Coalition.NEUTRAL,
        oldOwnedBy = parentAETHR and parentAETHR.ENUMS.Coalition.NEUTRAL or AETHR.ENUMS.Coalition.NEUTRAL,
        shapeID = parentAETHR and parentAETHR.ENUMS.MarkerTypes.Freeform or AETHR.ENUMS.MarkerTypes.Freeform,
        markerObject = {},
        readOnly = true,
        BorderingZones = {},
        Airbases = {},
        LinesVec2 = {},
        lastMarkColorOwner = parentAETHR and parentAETHR.ENUMS.Coalition.NEUTRAL or AETHR.ENUMS.Coalition.NEUTRAL,
        activeDivsions = {},
        parentAETHR = parentAETHR and parentAETHR or AETHR,
    }
    -- attach metatable so instance inherits methods from prototype
    setmetatable(instance, { __index = self })

    instance.LinesVec2 = instance.parentAETHR.POLY:convertPolygonToLines(instance.verticies)

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
--- @field vec2Origin _vec2                       Origin point for the marker (vec2)
--- @field readOnly boolean                            If true, marker is not editable
--- @field message string                              Optional message text
--- @field shapeId number                              Shape type enum (e.g., freeform, line, circle)
--- @field coalition number                            Coalition ID (-1 = neutral/all)
--- @field lineType number                             Line style enum
--- @field lineColor _ColorRGBA|number[]         Line color (preferred: {r,g,b,a}; legacy: {r,g,b,a} array)
--- @field fillColor _ColorRGBA|number[]         Fill color (preferred: {r,g,b,a}; legacy: {r,g,b,a} array)
--- @field freeFormVec2Table _vec2[]             Vertices used for freeform/drawn shapes
--- @field radius number                               Radius for circles (if shape is circle)
AETHR._Marker = {} ---@diagnostic disable-line

---
--- @param markID number
--- @param markString string|nil
--- @param vec2Origin _vec2|nil
--- @param readOnly boolean|nil
--- @param message string|nil
--- @param shapeId number|nil
--- @param coalition number|nil
--- @param lineType number|nil
--- @param lineColor AETHR.CONFIG.Color|number[]|nil
--- @param fillColor AETHR.CONFIG.Color|number[]|nil
--- @param freeFormVec2Table _vec2[]|nil
--- @param radius number|nil
--- @return _Marker instance
function AETHR._Marker:New(
    markID, markString, vec2Origin, readOnly,
    message, shapeId, coalition,
    lineType, lineColor, fillColor,
    freeFormVec2Table, radius)
    local instance = {
        markID = markID,
        string = markString or "",
        vec2Origin = vec2Origin or {},
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
--- @field coordinates _vec3                     World coordinates of the airbase
--- @field description table                            Engine description (e.g., from Airbase.getDescByName)
--- @field name string                                  Airbase name
--- @field category number                              Category enum
--- @field coalition number                             Current coalition
--- @field previousCoalition number                     Previous coalition
--- @field categoryText string                          Category text
--- @field zoneName string                              Zone name this airbase belongs to (if any)
--- @field zoneObject _MIZ_ZONE|nil               Zone object this airbase belongs to (if any)
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

--- @class _foundObject
--- @field callsign string|nil
--- @field category number|nil
--- @field categoryEx number|nil
--- @field coalition number|nil
--- @field country number|nil
--- @field desc table|nil
--- @field groupName string|nil
--- @field id number|nil
--- @field name string|nil
--- @field ObjectID number|nil
--- @field isActive boolean|nil
--- @field isAlive boolean|nil
--- @field isBroken boolean|nil
--- @field isDead boolean|nil
--- @field isEffective boolean|nil
--- @field sensors table|nil
--- @field postition _vec3|nil
--- @field groupUnitNames string[] List of unit names in the same group
--- @field AETHR table
--- @field spawned boolean
--- @field divisionID number|nil
--- @field groundUnitID number
AETHR._foundObject = {} ---@diagnostic disable-line
---
--- @param OBJ any
--- @return _foundObject instance
function AETHR._foundObject:New(OBJ)
AETHR.UTILS:debugInfo("AETHR._foundObject:New -> Start")
    local instance = {
        callsign = nil,
        category = nil,
        categoryEx = nil,
        coalition = nil,
        country = nil,
        desc = nil,
        groupName = nil,
        groupUnitNames = {},
        id = nil,
        name = nil,
        ObjectID = nil,
        isActive = nil,
        isAlive = nil,
        isBroken = nil,
        isDead = nil,
        isEffective = nil,
        sensors = nil,
        postition = nil,
        AETHR = {
            spawned = false,
            divisionID = nil,
            groundUnitID = 0,
        },
    }
    -- Set if available
    if type(OBJ.getCallsign) == "function" then
        local _okval, _val = pcall(OBJ.getCallsign, OBJ)
        if _okval then
            instance.callsign = _val
        end
    end
    -- Set if available
    if type(OBJ.getCategory) == "function" then
        local _okval, _val = pcall(OBJ.getCategory, OBJ)
        if _okval then
            instance.category = _val
        end
    end
        -- Set if available
    if type(OBJ.getCategoryEx) == "function" then
        local _okval, _val = pcall(OBJ.getCategoryEx, OBJ)
        if _okval then
            instance.categoryEx = _val
        end
    end
        -- Set if available
    if type(OBJ.getCoalition) == "function" then
        local _okval, _val = pcall(OBJ.getCoalition, OBJ)
        if _okval then
            instance.coalition = _val
        end
    end
        -- Set if available
    if type(OBJ.getPoint) == "function" then
        local _okval, _val = pcall(OBJ.getPoint, OBJ)
        if _okval then
            instance.country = _val
        end
    end
        -- Set if available
    if type(OBJ.getDesc) == "function" then
        local _okval, _val = pcall(OBJ.getDesc, OBJ)
        if _okval then
            instance.desc = _val
        end
    end
        -- Set if available
    if type(OBJ.getID) == "function" then
        local _okval, _val = pcall(OBJ.getID, OBJ)
        if _okval then
            instance.id = _val
        end
    end
        -- Set if available
    if type(OBJ.name) == "function" then
        local _okval, _val = pcall(OBJ.name, OBJ)
        if _okval then
            instance.name = _val
        end
    end

    -- Set if available
    if type(OBJ.getPoint) == "function" then
        local _okval, _val = pcall(OBJ.getPoint, OBJ)
        if _okval then
            instance.postition = _val
        end
    end
    -- Set getSensors if available
    if type(OBJ.getSensors) == "function" then
        local _okval, _val = pcall(OBJ.getSensors, OBJ)
        if _okval then
            instance.sensors = _val
        end
    end
    -- Set isEffective if available
    if type(OBJ.isEffective) == "function" then
        local _okval, _val = pcall(OBJ.isEffective, OBJ)
        if _okval then
            instance.isEffective = _val
        end
    end

    -- Set isDead if available
    if type(OBJ.isDead) == "function" then
        local _okval, _val = pcall(OBJ.isDead, OBJ)
        if _okval then
            instance.isDead = _val
        end
    end

    -- Set isBroken if available
    if type(OBJ.isBroken) == "function" then
        local _okval, _val = pcall(OBJ.isBroken, OBJ)
        if _okval then
            instance.isBroken = _val
        end
    end

    -- Set isAlive if available
    if type(OBJ.isAlive) == "function" then
        local _okval, _val = pcall(OBJ.isAlive, OBJ)
        if _okval then
            instance.isAlive = _val
        end
    end

    -- Set isActive if available
    if type(OBJ.isActive) == "function" then
        local _okval, _val = pcall(OBJ.isActive, OBJ)
        if _okval then
            instance.isActive = _val
        end
    end

    -- Set ObjectID if available
    if type(OBJ.getObjectID) == "function" then
        local _okval, _val = pcall(OBJ.getObjectID, OBJ)
        if _okval then
            instance.ObjectID = _val
        end
    end

    -- Safely resolve group information (OBJ may not implement getGroup)
    local _group = nil
    if OBJ and type(OBJ.getGroup) == "function" then
        local _okGroup, _result = pcall(OBJ.getGroup, OBJ)
        if _okGroup then
            _group = _result
        end
    end

    if _group then
        -- Set groupName if available
        if type(_group.getName) == "function" then
            local _okName, _name = pcall(_group.getName, _group)
            if _okName then
                instance.groupName = _name
            end
        end

        -- Collect unit names if available
        if type(_group.getUnits) == "function" then
            local _okUnits, _units = pcall(_group.getUnits, _group)
            if _okUnits and type(_units) == "table" then
                for _, unit in pairs(_units) do
                    if unit and type(unit.getName) == "function" then
                        local _okUName, _uName = pcall(unit.getName, unit)
                        if _okUName and _uName then
                            table.insert(instance.groupUnitNames, _uName)
                        end
                    end
                end
            end
        end
    end
AETHR.UTILS:debugInfo("AETHR._foundObject:New -> End")
    --setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- @class _groundUnit
--- @field type string
--- @field transportable table
--- @field transportable.randomTransportable boolean
--- @field skill string
--- @field y number
--- @field x number
--- @field name string
--- @field playerCanDrive boolean
--- @field heading number
AETHR._groundUnit = {} ---@diagnostic disable-line
---
--- @param type string|nil
--- @param skill string|nil
--- @param x number|nil
--- @param y number|nil
--- @param name string|nil
--- @param heading number|nil
--- @param playerCanDrive boolean|nil
--- @param randomTransportable boolean|nil
--- @return _groundUnit instance
function AETHR._groundUnit:New(type, skill, x, y, name, heading, playerCanDrive, randomTransportable)
    local instance = {
        type = type or nil,
        transportable =
        {
            randomTransportable = randomTransportable or true,
        },                                         -- end of transportable
        skill = skill or AETHR.ENUMS.Skill.Random, -- string of the units skill level. Can be "Excellent", "High", "Good", "Average", "Random", "Player"
        y = y or 0,
        x = x or 0,
        name = name or nil,
        playerCanDrive = playerCanDrive or true,
        heading = heading or 0, -- number heading of the object in radians
    }
    if not instance.name then instance.name = "AETHR_" .. tostring(os.time()) end

    return instance ---@diagnostic disable-line
end

--- @class _groundGroup
--- @field visible boolean
--- @field taskSelected boolean
--- @field lateActivation boolean
--- @field hidden boolean
--- @field hiddenOnPlanner boolean
--- @field hiddenOnMFD boolean
--- @field route table
--- @field tasks table
--- @field units _groundUnit[]
--- @field y number
--- @field x number
--- @field name string
--- @field start_time number
--- @field task string
--- @field uncontrollable boolean
--- @field countryID number
--- @field _engineAddTime number Internal timestamp when the group was added to the mission (for late activation)
AETHR._groundGroup = {} ---@diagnostic disable-line
---
--- @param visible boolean|nil
--- @param taskSelected boolean|nil
--- @param lateActivation boolean|nil
--- @param hidden boolean|nil
--- @param hiddenOnPlanner boolean|nil
--- @param hiddenOnMFD boolean|nil
--- @param route table|nil
--- @param tasks table|nil
--- @param units _groundUnit[]|nil
--- @param y number|nil
--- @param x number|nil
--- @param name string|nil
--- @param start_time number|nil
--- @param task string|nil
--- @param uncontrollable boolean|nil
--- @param countryID number|nil
--- @return _groundGroup instance
function AETHR._groundGroup:New(visible, taskSelected, lateActivation, hidden, hiddenOnPlanner, hiddenOnMFD,
                                route, tasks, units, y, x, name, start_time, task, uncontrollable, countryID)
    local instance = {
        visible         = visible or false,
        uncontrollable  = uncontrollable or false,
        taskSelected    = taskSelected or true,
        lateActivation  = lateActivation or true,
        hidden          = hidden or false,          --- boolean whether or not the group is visible on the F10 map view
        hiddenOnPlanner = hiddenOnPlanner or false, --- boolean if true the group will be hidden on the mission planner available in single player.
        hiddenOnMFD     = hiddenOnMFD or false,     --- boolean if true this group will not be auto populated on relevant aircraft map screens and avionics. For instance SAM rings in F-16/F-18 and AH-64 threats pages
        route           = route or
            {
            }, -- end of route
        tasks           = tasks or
            {
            }, -- end of tasks
        units           = units or
            {
            }, -- end of ipair units
        y               = y or 0,
        x               = x or 0,
        name            = name or nil,
        start_time      = start_time or 0, -- time in seconds from mission start when the group will be spawned
        task            = task or "Ground Nothing",
        countryID       = countryID or 0,
        _engineAddTime = 0,
    }
    if not instance.name then instance.name = "AETHR_" .. tostring(os.time()) end
    return instance ---@diagnostic disable-line
end

--- @class _GameBounds
--- @field outOfBounds table
--- @field outOfBounds.HullPolysNoSample _PolygonList
--- @field outOfBounds.HullPolysWithSample _PolygonList
--- @field outOfBounds.centerPoly _PolygonVec2
--- @field outOfBounds.masterPoly _PolygonVec2
--- @field inBounds table
--- @field inBounds.polyLines _LineVec2[]
--- @field inBounds.polyVerts _PolygonVec2
--- @field inOutBoundsGaps table
--- @field inOutBoundsGaps.overlaid _PolygonList
--- @field inOutBoundsGaps.convex _PolygonList
--- @field inOutBoundsGaps.concave _PolygonList
AETHR._GameBounds = {} ---@diagnostic disable-line

--- @alias PointLike table{x?: number, y?: number, z?: number}
--- @alias NormalizedPoint table{x: number, y: number}
--- @alias Color table{r: number, g: number, b: number, a?: number}
---
--- @class AirbaseDescriptor
--- @field displayName string Human-readable airbase name (display key used in DATA.AIRBASES)
--- @field coords table Optional coordinate descriptor (format may vary)
--- @field [any] any Additional provider-specific fields.
---

--- @class _dynamicSpawner
--- @field zones table
--- @field zones.main _spawnerZone|nil
--- @field zones.sub _spawnerZone[]
--- @field zones.restricted _spawnerZone[]
--- @field spawnTypes table
--- @field LimitedSpawnTypes table
--- @field extraTypes table
--- @field numSubZonesMin number
--- @field numSubZonesMax number
--- @field numSubZonesNominal number
--- @field numSubZonesNudgeFactor number
--- @field numSubZones number
--- @field subZoneOverlapFactor number
--- @field spawnAmountMin number
--- @field spawnAmountMax number
--- @field spawnAmountNominal number
--- @field spawnAmountNudgeFactor number
--- @field spawnAmount number
--- @field spawnAmountCounter number
--- @field averageDistribution number
--- @field name string
--- @field spawnedNamePrefix string
--- @field groupSizeMax number
--- @field groupSizeMin number
--- @field minRadius number
--- @field maxRadius number
--- @field nominalRadius number
--- @field nudgeFactorRadius number
--- @field vec2 _vec2|nil
--- @field _keys table
--- @field _spawnsManip table
--- @field _spawnsManipTotal number|integer
--- @field _confirmedTotal number|integer
--- @field _typesPool table
--- @field _limitedTypesPool table
--- @field _nonLimitedTypesPool table
--- @field worldDivisions table<number, _WorldDivision>
--- @field parentAETHR AETHR|nil
--- @field mizZones table<string, _MIZ_ZONE>
--- @field _cache table
--- @field _cache.worldDivAABB table<number, _BBox>
--- @field skill string|nil
--- @field _randSeed number
AETHR._dynamicSpawner = {} ---@diagnostic disable-line
---
--- @param name string Name of the dynamic spawner instance
--- @return _dynamicSpawner instance
function AETHR._dynamicSpawner:New(name, parentAETHR)
    local instance = {
        zones = {
            main = {}, -- single AETHR._spawnerZone:New(),
            sub = {},  --array of AETHR._spawnerZone:New(),
            restricted = {},
        },
        spawnTypes = {},
        LimitedSpawnTypes = {},
        extraTypes = {},
        name = name,
        vec2 = {},
        country = 0,
        coalition = 0,
        skill = nil,
        minRadius = 500,
        maxRadius = 2000,
        nominalRadius = 1000,
        nudgeFactorRadius = 0.5,
        numSubZonesMin = 2,
        numSubZonesMax = 4,
        numSubZonesNominal = 3,
        numSubZonesNudgeFactor = 0.9,
        numSubZones = 3,
        subZoneOverlapFactor = 0.9, -- 0 = no overlap, 1 = full overlap
        spawnAmountMin = 0,
        spawnAmountMax = 0,
        spawnAmountNominal = 0,
        spawnAmountNudgeFactor = 0.9,
        spawnAmount = 0,
        spawnAmountCounter = 0,
        averageDistribution = 0,
        spawnedNamePrefix = "",
        groupSizeMax = 5,
        groupSizeMin = 1,
        _keys = {},
        _spawnsManip = {},
        _spawnsManipTotal = 0,
        _confirmedTotal = 0,
        _typesPool = {},
        _limitedTypesPool = {},
        _nonLimitedTypesPool = {},
        worldDivisions = {},
        mizZones = {},
        _cache = {
            worldDivAABB = {},
        },
        parentAETHR = parentAETHR or AETHR,
        _randSeed = math.random(),
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- Set the number of sub-zones to generate
--- @param numSubZonesNominal number Nominal number of sub-zones
--- @param numSubZonesMin number|nil Minimum number of sub-zones
--- @param numSubZonesMax number|nil Maximum number of sub-zones
--- @param numSubZonesNudgeFactor number|nil Adjustment factor for randomization (0 = no variation, 1 = full variation)
--- @return self
function AETHR._dynamicSpawner:setNumSpawnZones(numSubZonesNominal, numSubZonesMin, numSubZonesMax,
                                                numSubZonesNudgeFactor)
    local instance = self
    local pAETHR = instance.parentAETHR
    instance.numSubZonesNominal = numSubZonesNominal
    instance.numSubZonesMin = numSubZonesMin and numSubZonesMin or numSubZonesNominal
    instance.numSubZonesMax = numSubZonesMax and numSubZonesMax or numSubZonesNominal
    instance.numSubZonesNudgeFactor = numSubZonesNudgeFactor and numSubZonesNudgeFactor or
        instance.numSubZonesNudgeFactor

    instance.numSubZones = math.ceil(pAETHR.MATH:generateNominal(
        instance.numSubZonesNominal,
        instance.numSubZonesMin,
        instance.numSubZonesMax,
        instance.numSubZonesNudgeFactor))
    return self
end

function AETHR._dynamicSpawner:setSpawnAmount(spawnAmountNominal, spawnAmountMin, spawnAmountMax, spawnAmountNudgeFactor)
    local instance = self
    local pAETHR = instance.parentAETHR
    instance.spawnAmountNominal = spawnAmountNominal
    instance.spawnAmountMin = spawnAmountMin and spawnAmountMin or spawnAmountNominal
    instance.spawnAmountMax = spawnAmountMax and spawnAmountMax or spawnAmountNominal
    instance.spawnAmountNudgeFactor = spawnAmountNudgeFactor and spawnAmountNudgeFactor or
        instance.spawnAmountNudgeFactor

    instance.spawnAmount = math.ceil(pAETHR.MATH:generateNominal(
        instance.spawnAmountNominal,
        instance.spawnAmountMin,
        instance.spawnAmountMax,
        instance.spawnAmountNudgeFactor))
    return self
end

function AETHR._dynamicSpawner:setNamePrefix(spawnedNamePrefix)
    local instance = self
    instance.spawnedNamePrefix = spawnedNamePrefix and spawnedNamePrefix or ""
    return self
end

function AETHR._dynamicSpawner:setSpawnTypeAmount(spawnTypeENUM, max, limited, min)
    local instance = self
    local pAETHR = instance.parentAETHR
    local spawnTypeConfig = pAETHR._spawnerTypeConfig:New(spawnTypeENUM, nil, min, max, nil, limited)
    instance.spawnTypes[spawnTypeENUM] = spawnTypeConfig
    return self
end

function AETHR._dynamicSpawner:setGroupSizes(max, min)
    self.groupSizeMax = max or 5
    self.groupSizeMin = min or 1
    return self
end

function AETHR._dynamicSpawner:addExtraTypeToGroups(typeENUM, numberToAdd)
    local instance = self
    local pAETHR = instance.parentAETHR
    local spawnTypeConfig = pAETHR._spawnerTypeConfig:New(typeENUM, nil, numberToAdd, nil, nil, true)
    self.extraTypes[typeENUM] = spawnTypeConfig
    --numberToAdd or 1
    return self
end

function AETHR._dynamicSpawner:_seedRollUpdates()
    self._keys = {}
    self._spawnsManip = {}
    self._spawnsManipTotal = 0
    for k, zoneObject in pairs(self.zones.sub) do
        table.insert(self._keys, k)
        ---@type _spawnSettings
        local spawnSettingsMainGenerated = zoneObject.spawnSettings.generated
        self._spawnsManip[k] = spawnSettingsMainGenerated.actual
        self._spawnsManipTotal = self._spawnsManipTotal + self._spawnsManip[k]
    end
    return self
end

function AETHR._dynamicSpawner:_introduceRandomness()
    ---@type _spawnerZone
    local mainZone = self.zones.main
    ---@type _spawnerZone[]
    local subZones = self.zones.sub
    ---@type _spawnSettings
    local spawnSettingsMainGenerated = mainZone.spawnSettings.generated
    local numSubZones = self.numSubZones
    -- Iterate over the zones as defined by the nudge reciprocation number
    for _ = 1, spawnSettingsMainGenerated.nudgeReciprocal do
        local subZoneKey_ = self._keys[math.random(numSubZones)]
        local random_value = math.random(-2, 2)
        local newActual = self._spawnsManip[subZoneKey_] + random_value
        local newTotal = self._spawnsManipTotal + random_value

        -- Check if the new actual value and the new total value are within the allowed range
        local subZone = subZones[subZoneKey_]
        ---@type _spawnSettings
        local spawnSettingsSubZone = subZone.spawnSettings.generated
        if newActual > spawnSettingsSubZone.min
            and newTotal <= spawnSettingsMainGenerated.max
            and newActual < spawnSettingsSubZone.max then
            -- Update the actual value and the total value with the new randomized numbers
            self._spawnsManip[subZoneKey_] = newActual
            self._spawnsManipTotal = newTotal
        end
    end
    return self
end

function AETHR._dynamicSpawner:_distributeDifference()
    ---@type _spawnerZone
    local mainZone = self.zones.main
    ---@type _spawnerZone[]
    local subZones = self.zones.sub
    ---@type _spawnSettings
    local spawnSettingsMainGenerated = mainZone.spawnSettings.generated
    local numSubZones = self.numSubZones

    -- Calculate the difference between the expected and current total spawn amount
    local difference = spawnSettingsMainGenerated.actual - self._spawnsManipTotal

    -- Distribute the difference across the subzones
    for _ = 1, math.abs(difference) do
        local subZoneKey_ = self._keys[math.random(numSubZones)]
        local _val = (difference > 0 and 1 or -1) -- Determine if we need to add or subtract
        -- Update the spawn amounts for the subzone and the total
        self._spawnsManip[subZoneKey_] = self._spawnsManip[subZoneKey_] + _val
        self._spawnsManipTotal = self._spawnsManipTotal + _val
    end
    return self
end

function AETHR._dynamicSpawner:_assignAndUpdateSubZones()
    ---@type _spawnerZone[]
    local subZones = self.zones.sub
    -- Assign computed values to subzones and update them
    for zoneName, newActual in pairs(self._spawnsManip) do
        ---@type _spawnerZone
        local zoneObject = subZones[zoneName]
        ---@type _spawnSettings
        local spawnSettingsZoneObject = zoneObject.spawnSettings.generated
        -- Assign new actual spawn value
        spawnSettingsZoneObject.actual = newActual
        -- Update generation thresholds and clamp them
        zoneObject:_UpdateGenThresholds()
        self:_thresholdClamp(zoneObject)
    end

    -- Confirm the updated totals
    self:_confirmTotals()

    return self
end

---@param zoneObject _spawnerZone
function AETHR._dynamicSpawner:_thresholdClamp(zoneObject)
    ---@type _spawnerZone[]
    local subZones = self.zones.sub
    ---@type _spawnSettings
    local spawnSettingsGenerated = zoneObject.spawnSettings.generated
    local thresholds = spawnSettingsGenerated.thresholds

    -- Check for threshold violations and adjust spawn values accordingly
    if thresholds.overMax > 0 or thresholds.underMin > 0 then
        local action
        if thresholds.overMax > 0 then
            action = -1
        elseif thresholds.underMin > 0 then
            action = 1
        elseif thresholds.overNom > 0 then
            action = -1
        elseif thresholds.underNom > 0 then
            action = 1
        end

        for _ = 1, math.abs(action * (thresholds.overMax + thresholds.underMin + thresholds.overNom + thresholds.underNom)) do
            local index = self._keys[math.random(#self._keys)]
            ---@type _spawnerZone
            local _zone = subZones[index]
            ---@type _spawnSettings
            local spawnSettings_zone = _zone.spawnSettings.generated
            spawnSettings_zone.actual = spawnSettings_zone.actual + action
        end
    end

    return self
end

function AETHR._dynamicSpawner:_confirmTotals()
    ---@type _spawnerZone[]
    local subZones = self.zones.sub
    local confirmedTotal = 0

    ---@param zoneObj _spawnerZone
    for zoneName, zoneObj in pairs(subZones) do
        ---@type _spawnSettings
        local spawnSettingsGenerated = zoneObj.spawnSettings.generated
        local currentZoneActual = spawnSettingsGenerated.actual
        -- Update the confirmed total
        confirmedTotal = confirmedTotal + currentZoneActual
    end
    self._confirmedTotal = confirmedTotal

    return self
end

--- @class _spawnerZone
--- @field name string
--- @field minRadius number|integer Minimum size of the main zone.
--- @field maxRadius number|integer Maximum size of the main zone.
--- @field nominalRadius number|integer Default size of the main zone.
--- @field nudgeFactor number|integer Adjustment factor for the main zone size.
--- @field actualRadius number|integer Actual calculated size of the main zone.
--- @field diameter number|integer
--- @field area number|integer
--- @field weight number
--- @field center _vec2
--- @field triggerZone table
--- @field avgDistribution number
--- @field worldDivisions table<number, _WorldDivision>
--- @field mizZones table<string, _MIZ_ZONE>
--- @field staticObjects table
--- @field baseObjects table
--- @field sceneryObjects table
--- @field spawnGroups table
--- @field groupSizePrioMax number
--- @field groupSizePrioMin number
--- @field groupSizesPrio number[]
--- @field groupSpacingSettings table
--- @field groupSettings table
--- @field spawnSettings table
--- @field spawnSettings.base _spawnSettings
--- @field spawnSettings.generated _spawnSettings
--- @field seperationSettings table
--- @field seperationSettings.minGroups number
--- @field seperationSettings.maxGroups number
--- @field seperationSettings.minUnits number
--- @field seperationSettings.maxUnits number
--- @field seperationSettings.minBuildings number
--- @field parentAETHR AETHR|nil
--- @field parentSpawner _dynamicSpawner|nil
--- @field zoneDivSceneryObjects table<number, _foundObject[]>
--- @field zoneDivStaticObjects table<number, _foundObject[]>
--- @field zoneDivBaseObjects table<number, _foundObject[]>
--- @field _randSeed number
AETHR._spawnerZone = {} ---@diagnostic disable-line
---
--- @param parentAETHR AETHR|nil
--- @param parentSpawner _dynamicSpawner|nil
--- @return _spawnerZone instance
function AETHR._spawnerZone:New(parentAETHR, parentSpawner)
    local instance = {
        name = nil,
        -- Minimum size of the main zone.
        minRadius = parentSpawner and parentSpawner.minRadius or 1000,
        -- Maximum size of the main zone.
        maxRadius = parentSpawner and parentSpawner.maxRadius or 10000,
        -- Default size of the main zone.
        nominalRadius = parentSpawner and parentSpawner.nominalRadius or 5000,
        -- Adjustment factor for the zone radius.
        nudgeFactor = parentSpawner and parentSpawner.nudgeFactorRadius or 0.5,
        -- Actual calculated size of the main zone.
        actualRadius = 5000,
        diameter = 10000,
        area = 0,
        weight = 0,
        center = parentSpawner and parentSpawner.vec2 or { x = 0, y = 0 },
        triggerZone = {},
        avgDistribution = 0,
        worldDivisions = {},
        mizZones = {},
        staticObjects = {},
        baseObjects = {},
        sceneryObjects = {},
        spawnGroups = {},
        groupSizePrioMax = parentSpawner and parentSpawner.groupSizeMax or 5,
        groupSizePrioMin = parentSpawner and parentSpawner.groupSizeMin or 1,
        groupSizesPrio = {
            -- [1] = 10,
            -- [2] = 9,
            -- [3] = 8,
            -- [4] = 7,
            -- [5] = 6,
            -- [6] = 5,
            -- [7] = 4,
            -- [8] = 3,
            -- [9] = 2,
            -- [10] = 1,
        },
        --groupSpacingSettings = {},
        groupSettings = {},
        spawnSettings = {
            base = parentAETHR and parentAETHR._spawnSettings:New() or AETHR._spawnSettings:New(),
            generated = parentAETHR and parentAETHR._spawnSettings:New() or AETHR._spawnSettings:New(),
        },
        seperationSettings = {
            minGroups = parentAETHR and parentAETHR.SPAWNER.DATA.CONFIG.seperationSettings.minGroups or 30,
            maxGroups = parentAETHR and parentAETHR.SPAWNER.DATA.CONFIG.seperationSettings.maxGroups or 45,
            minUnits = parentAETHR and parentAETHR.SPAWNER.DATA.CONFIG.seperationSettings.minUnits or 15,
            maxUnits = parentAETHR and parentAETHR.SPAWNER.DATA.CONFIG.seperationSettings.maxUnits or 30,
            minBuildings = parentAETHR and parentAETHR.SPAWNER.DATA.CONFIG.seperationSettings.minBuildings or 20,
        },
        parentAETHR = parentAETHR or AETHR,
        parentSpawner = parentSpawner or {},
        zoneDivSceneryObjects = {},
        zoneDivStaticObjects = {},
        zoneDivBaseObjects = {},
        _randSeed = math.random(),
    }
    setmetatable(instance, { __index = self })
    if not instance.name then instance.name = "Zone_" .. tostring(os.time()) end

    local counter = 1
    for i = instance.groupSizePrioMax, instance.groupSizePrioMin, -1 do
        instance.groupSizesPrio[counter] = i
        counter = counter + 1
    end

    for _, groupSize in ipairs(instance.groupSizesPrio) do
        instance:setGroupSpacing(groupSize)
    end

    instance.actualRadius = math.ceil(AETHR.MATH:generateNominal(
        instance.nominalRadius,
        instance.minRadius,
        instance.maxRadius,
        instance.nudgeFactor))

    instance.area = math.pi * (instance.actualRadius ^ 2)
    instance.diameter = instance.actualRadius * 2


    return instance ---@diagnostic disable-line
end

--- Set the spacing configurations for a specified group size within a zone.
---
--- This function configures the spacing settings for groups of a specific size within a zone.
--- It sets the minimum and maximum separation distances between groups and between units within those groups.
--- These configurations are vital for ensuring proper spacing and organization of spawned groups,
--- avoiding overcrowding and ensuring tactical effectiveness. Default values are used if specific
--- parameters are not provided.
---
--- @param groupSize number|integer The size of the group for which spacing settings are being configured.
--- @param groupMinSep number|integer|nil (Optional) The minimum separation distance between groups.
--- @param groupMaxSep number|integer|nil (Optional) The maximum separation distance between groups.
--- @param unitMinSep number|integer|nil (Optional) The minimum separation distance between units within a group.
--- @param unitMaxSep number|integer|nil (Optional) The maximum separation distance between units within a group.
--- @param distFromBuildings number|integer|nil (Optional) The minimum distance from nearby buildings.
function AETHR._spawnerZone:setGroupSpacing(groupSize, groupMinSep, groupMaxSep, unitMinSep, unitMaxSep,
                                            distFromBuildings)
    groupMinSep                        = groupMinSep or self.seperationSettings.minGroups
    groupMaxSep                        = groupMaxSep or self.seperationSettings.maxGroups
    unitMinSep                         = unitMinSep or self.seperationSettings.minUnits
    unitMaxSep                         = unitMaxSep or self.seperationSettings.maxUnits
    distFromBuildings                  = distFromBuildings or self.seperationSettings.minBuildings
    -- Initialize the spacing settings for the given group size
    self.groupSettings[groupSize]      = {}
    local settings                     = self.groupSettings[groupSize]
    settings.minGroups                 = groupMinSep
    settings.maxGroups                 = groupMaxSep
    settings.minUnits                  = unitMinSep
    settings.maxUnits                  = unitMaxSep
    settings.minBuildings              = distFromBuildings
    settings.size                      = settings.size or 0
    settings.numGroups                 = settings.numGroups or 0
    settings.generatedGroupTypes       = settings.generatedGroupTypes or {}
    settings.generatedGroupUnitTypes   = settings.generatedGroupUnitTypes or {}
    settings.generatedGroupCenterVec2s = settings.generatedGroupCenterVec2s or {}
    settings.generatedUnitVec2s        = settings.generatedUnitVec2s or {}



    return self
end

function AETHR._spawnerZone:setSpawnAmounts()
    ---Base spawn settings calculations
    local spawnSettings           = self.spawnSettings.base
    spawnSettings.nudgeReciprocal = spawnSettings.nudgeFactor ~= 0 and
        (1 / spawnSettings.nudgeFactor) or 0
    spawnSettings.nominal         = math.ceil(spawnSettings.nominal)
    spawnSettings.ratioMax        = spawnSettings.max / spawnSettings.nominal - 1
    spawnSettings.ratioMin        = spawnSettings.min / spawnSettings.nominal
    spawnSettings.weighted        = math.ceil(spawnSettings.nominal * self.weight)
    spawnSettings.divisionFactor  = spawnSettings.nominal / spawnSettings.weighted
    spawnSettings.actual          = math.ceil(AETHR.MATH:generateNominal(
        spawnSettings.nominal,
        spawnSettings.min,
        spawnSettings.max,
        spawnSettings.nudgeFactor))
    spawnSettings.actualWeighted  = math.ceil(spawnSettings.actual * self.weight)

    local thresholds              = spawnSettings.thresholds
    thresholds.overNom            = math.max(0, spawnSettings.actual - spawnSettings.nominal)
    thresholds.underNom           = math.max(0, spawnSettings.nominal - spawnSettings.actual)
    thresholds.overMax            = math.max(0, spawnSettings.actual - spawnSettings.max)
    thresholds.underMax           = math.max(0, spawnSettings.max - spawnSettings.actual)
    thresholds.overMin            = math.max(0, spawnSettings.actual - spawnSettings.min)
    thresholds.underMin           = math.max(0, spawnSettings.min - spawnSettings.actual)
    return self
end

function AETHR._spawnerZone:rollSpawnAmounts()
    --- generated spawn settings calculations
    local spawnSettings              = self.spawnSettings.base
    local genSpawnSettings           = self.spawnSettings.generated
    genSpawnSettings.nudgeFactor     = AETHR.MATH:generateNudge(spawnSettings.nudgeFactor)
    genSpawnSettings.nudgeReciprocal = genSpawnSettings.nudgeFactor ~= 0 and
        (1 / genSpawnSettings.nudgeFactor) or 0
    genSpawnSettings.nominal         = math.ceil(AETHR.MATH:generateNominal(spawnSettings.actual, spawnSettings.min,
        spawnSettings.max, genSpawnSettings.nudgeFactor))
    genSpawnSettings.ratioMax        = spawnSettings.ratioMax
    genSpawnSettings.ratioMin        = spawnSettings.ratioMin
    genSpawnSettings.max             = math.ceil(math.min(
        genSpawnSettings.nominal + (genSpawnSettings.nominal * genSpawnSettings.ratioMax), spawnSettings.max))
    genSpawnSettings.min             = math.ceil(math.max(
        genSpawnSettings.nominal - (genSpawnSettings.nominal * genSpawnSettings.ratioMin), spawnSettings.min))
    genSpawnSettings.weighted        = math.ceil(genSpawnSettings.nominal * self.weight)
    genSpawnSettings.divisionFactor  = genSpawnSettings.nominal / genSpawnSettings.weighted
    genSpawnSettings.actual          = math.ceil(AETHR.MATH:generateNominal(
        genSpawnSettings.nominal,
        genSpawnSettings.min,
        genSpawnSettings.max,
        genSpawnSettings.nudgeFactor))
    genSpawnSettings.actualWeighted  = math.ceil(genSpawnSettings.actual * self.weight)

    local genthresholds              = genSpawnSettings.thresholds
    genthresholds.overNom            = math.max(0, genSpawnSettings.actual - spawnSettings.nominal)
    genthresholds.underNom           = math.max(0, spawnSettings.nominal - genSpawnSettings.actual)
    genthresholds.overMax            = math.max(0, genSpawnSettings.actual - spawnSettings.max)
    genthresholds.underMax           = math.max(0, spawnSettings.max - genSpawnSettings.actual)
    genthresholds.overMin            = math.max(0, genSpawnSettings.actual - spawnSettings.min)
    genthresholds.underMin           = math.max(0, spawnSettings.min - genSpawnSettings.actual)

    return self
end

function AETHR._spawnerZone:_UpdateGenThresholds()
    local spawnSettings    = self.spawnSettings.base
    local genSpawnSettings = self.spawnSettings.generated
    local genthresholds    = genSpawnSettings.thresholds
    genthresholds.overNom  = math.max(0, genSpawnSettings.actual - spawnSettings.nominal)
    genthresholds.underNom = math.max(0, spawnSettings.nominal - genSpawnSettings.actual)
    genthresholds.overMax  = math.max(0, genSpawnSettings.actual - spawnSettings.max)
    genthresholds.underMax = math.max(0, spawnSettings.max - genSpawnSettings.actual)
    genthresholds.overMin  = math.max(0, genSpawnSettings.actual - spawnSettings.min)
    genthresholds.underMin = math.max(0, spawnSettings.min - genSpawnSettings.actual)
    return self
end

--- @class _spawnSettings
--- @field nudgeFactor number
--- @field nudgeReciprocal number
--- @field nominal number
--- @field ratioMax number
--- @field ratioMin number
--- @field max number
--- @field min number
--- @field weighted number
--- @field divisionFactor number
--- @field actual number
--- @field actualWeighted number
--- @field thresholds table
--- @field thresholds.overNom number
--- @field thresholds.underNom number
--- @field thresholds.overMax number
--- @field thresholds.underMax number
--- @field thresholds.overMin number
--- @field thresholds.underMin number
AETHR._spawnSettings = {} ---@diagnostic disable-line
---
--- @return _spawnSettings instance
function AETHR._spawnSettings:New()
    local instance = {
        nudgeFactor = 0.5,
        nudgeReciprocal = 0,
        nominal = 0,
        ratioMax = 0,
        ratioMin = 0,
        max = 0,
        min = 0,
        weighted = 0,
        divisionFactor = 0,
        actual = 0,
        actualWeighted = 0,
        thresholds = {
            overNom  = 0,
            underNom = 0,
            overMax  = 0,
            underMax = 0,
            overMin  = 0,
            underMin = 0,
        },
    }
    return instance ---@diagnostic disable-line
end

--- @class _spawnerTypeConfig
--- @field typeName table
--- @field count number
--- @field min number
--- @field max number
--- @field nominal number
--- @field limited boolean
--- @field actual number
--- @field typesDB table
--- @field ratioMax number
AETHR._spawnerTypeConfig = {} ---@diagnostic disable-line
---
--- @param typeName string
--- @param count number|nil
--- @param min number|nil
--- @param max number|nil
--- @param nominal number|nil
--- @param limited boolean|nil
--- @return _spawnerTypeConfig instance
function AETHR._spawnerTypeConfig:New(typeName, count, min, max, nominal, limited)
    local instance = {
        typeName = typeName,
        count = count or 0,
        min = min or 0,
        max = max or 0,
        nominal = nominal or 0,
        actual = 0,
        limited = limited or false,
        ratioMax = 0,
        typesDB = {},
    }

    return instance ---@diagnostic disable-line
end

--- @class _circle
--- @field center _vec2
--- @field radius number
--- @field diameter number
--- @field circumference number
--- @field area number
AETHR._circle = {} ---@diagnostic disable-line
---
--- @param center _vec2
--- @param radius number
--- @return _circle instance
function AETHR._circle:New(center, radius)
    local instance = {
        center = center,
        radius = radius,
        diameter = radius * 2,
        circumference = 2 * math.pi * radius,
        area = math.pi * (radius ^ 2),
    }
    return instance ---@diagnostic disable-line
end
