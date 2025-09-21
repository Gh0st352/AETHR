--- @class __template
--- @field c table
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
        oldOwnedBy = AETHR.ENUMS.Coalition.NEUTRAL,
        shapeID = AETHR.ENUMS.MarkerTypes.Freeform,
        markerObject = {},
        readOnly = true,
        BorderingZones = {},
        Airbases = {},
        LinesVec2 = {},
        lastMarkColorOwner = AETHR.ENUMS.Coalition.NEUTRAL,
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
--- @field vec3Origin _vec3                       Origin point for the marker (vec3)
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
    local instance = {
        callsign = OBJ and OBJ:getCallsign() or nil,
        category = OBJ and OBJ:getCategory() or nil,
        categoryEx = OBJ and OBJ:getCategoryEx() or nil,
        coalition = OBJ and OBJ:getCoalition() or nil,
        country = OBJ and OBJ:getCountry() or nil,
        desc = OBJ and OBJ:getDesc() or nil,
        groupName = OBJ and OBJ:getGroup() and OBJ:getGroup():getName() or nil,
        groupUnitNames = {},
        id = OBJ and OBJ:getID() or nil,
        name = OBJ and OBJ:getName() or nil,
        ObjectID = OBJ and OBJ:getObjectID() or nil,
        isActive = OBJ and OBJ:isActive() or nil,
        isAlive = OBJ and OBJ:isAlive() or nil,
        isBroken = OBJ and OBJ:isBroken() or nil,
        isDead = OBJ and OBJ:isDead() or nil,
        isEffective = OBJ and OBJ:isEffective() or nil,
        sensors = OBJ and OBJ:getSensors() or nil,
        postition = OBJ and OBJ:getPoint() or nil,
        AETHR = {
            spawned = false,
            divisionID = nil,
            groundUnitID = 0,
        },
    }

    if instance.groupName then
        local _groupUnits = OBJ:getGroup():getUnits()
        if _groupUnits and #_groupUnits > 0 then
            for _, unit in pairs(_groupUnits) do
                table.insert(instance.groupUnitNames, unit:getName())
            end
        end
    end

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
            randomTransportable = randomTransportable or false,
        },                                         -- end of transportable
        skill = skill or AETHR.ENUMS.Skill.Random, -- string of the units skill level. Can be "Excellent", "High", "Good", "Average", "Random", "Player"
        y = y or 0,
        x = x or 0,
        name = name or nil,
        playerCanDrive = playerCanDrive or true,
        heading = heading or 0, -- number heading of the object in radians
    }
    if not instance.name then instance.name = "AETHR_" .. tostring(os.time) end

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
    }
    if not instance.name then instance.name = "AETHR_" .. tostring(os.time) end
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
--- @field numExtraTypes number
--- @field numExtraUnits number
AETHR._dynamicSpawner = {} ---@diagnostic disable-line
---
--- @return _dynamicSpawner instance
function AETHR._dynamicSpawner:New()
    local instance = {
        zones = {
            main = {}, -- single AETHR._zoneObject:New(),
            sub = {},  --array of AETHR._zoneObject:New(),
            restricted = {},
        },
        spawnTypes = {},
        LimitedSpawnTypes = {},
        extraTypes = {},
        numExtraTypes = 0,
        numExtraUnits = 0,
    }


    return instance ---@diagnostic disable-line
end

--- @class _spawnerZone
--- @field name string
--- @field minRadius number Minimum size of the main zone.
--- @field maxRadius number Maximum size of the main zone.
--- @field nominalRadius number Default size of the main zone.
--- @field nudgeFactor number Adjustment factor for the main zone size.
--- @field actualRadius number Actual calculated size of the main zone.
--- @field area number
--- @field weight number
--- @field center _vec2xz
--- @field triggerZone table
--- @field numSubZonesMin number
--- @field numSubZonesMax number
--- @field numSubZonesNominal number
--- @field numSubZonesNudgeFactor number
--- @field numSubZones number
--- @field avgDistribution number
--- @field worldDivisions _WorldDivision[]
--- @field staticObjects table
--- @field baseObjects table
--- @field sceneryObjects table
--- @field spawnGroups table
--- @field groupSizePrioMax number
--- @field groupSizePrioMin number
--- @field groupSizesPrio number[]
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
AETHR._spawnerZone = {} ---@diagnostic disable-line
---
--- @return _spawnerZone instance
function AETHR._spawnerZone:New()
    local instance = {
        name = nil,
        -- Minimum size of the main zone.
        minRadius = 1000,
        -- Maximum size of the main zone.
        maxRadius = 10000,
        -- Default size of the main zone.
        nominalRadius = 5000,
        -- Adjustment factor for the zone radius.
        nudgeFactor = 0.5,
        -- Actual calculated size of the main zone.
        actualRadius = 5000,
        area = 0,
        weight = 0,
        center = { x = 0, y = 0 },
        triggerZone = {},
        numSubZonesMin = 2,
        numSubZonesMax = 4,
        numSubZonesNominal = 3,
        numSubZonesNudgeFactor = 0.9,
        numSubZones = 3,
        avgDistribution = 0,
        worldDivisions = {},
        staticObjects = {},
        baseObjects = {},
        sceneryObjects = {},
        spawnGroups = {},
        groupSizePrioMax = 5,
        groupSizePrioMin = 1,
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
        groupSettings = {},
        spawnSettings = {
            base = AETHR._spawnSettings:New(),
            generated = AETHR._spawnSettings:New(),
        },
        seperationSettings = {
            minGroups = 0,
            maxGroups = 0,
            minUnits = 0,
            maxUnits = 0,
            minBuildings = 0,
        },
    }

    if not instance.name then instance.name = "Zone_" .. tostring(os.time) end

    local counter = 1
    for i = instance.groupSizePrioMax, instance.groupSizePrioMin, -1 do
        instance.groupSizesPrio[counter] = i
        counter = counter + 1
    end

    instance.actualRadius = math.ceil(AETHR.MATH:generateNominal(
        instance.nominalRadius,
        instance.minRadius,
        instance.maxRadius,
        instance.nudgeFactor))

    instance.area = math.pi * (instance.actualRadius ^ 2)

    instance.numSubZones = math.ceil(AETHR.MATH:generateNominal(
        instance.numSubZonesNominal,
        instance.numSubZonesMin,
        instance.numSubZonesMax,
        instance.numSubZonesNudgeFactor))

    ---Base spawn settings calculations
    local spawnSettings              = instance.spawnSettings.base
    spawnSettings.nudgeReciprocal    = spawnSettings.nudgeFactor ~= 0 and
        (1 / spawnSettings.nudgeFactor) or 0
    spawnSettings.nominal            = math.ceil(spawnSettings.nominal)
    spawnSettings.ratioMax           = spawnSettings.max / spawnSettings.nominal - 1
    spawnSettings.ratioMin           = spawnSettings.min / spawnSettings.nominal
    spawnSettings.weighted           = math.ceil(spawnSettings.nominal * instance.weight)
    spawnSettings.divisionFactor     = spawnSettings.nominal / spawnSettings.weighted
    spawnSettings.actual             = math.ceil(AETHR.MATH:generateNominal(
        spawnSettings.nominal,
        spawnSettings.min,
        spawnSettings.max,
        spawnSettings.nudgeFactor))
    spawnSettings.actualWeighted     = math.ceil(spawnSettings.actual * instance.weight)

    local thresholds                 = spawnSettings.thresholds
    thresholds.overNom               = math.max(0, spawnSettings.actual - spawnSettings.nominal)
    thresholds.underNom              = math.max(0, spawnSettings.nominal - spawnSettings.actual)
    thresholds.overMax               = math.max(0, spawnSettings.actual - spawnSettings.max)
    thresholds.underMax              = math.max(0, spawnSettings.max - spawnSettings.actual)
    thresholds.overMin               = math.max(0, spawnSettings.actual - spawnSettings.min)
    thresholds.underMin              = math.max(0, spawnSettings.min - spawnSettings.actual)

    --- generated spawn settings calculations
    local genSpawnSettings           = instance.spawnSettings.generated
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
    genSpawnSettings.weighted        = math.ceil(genSpawnSettings.nominal * instance.weight)
    genSpawnSettings.divisionFactor  = genSpawnSettings.nominal / genSpawnSettings.weighted
    genSpawnSettings.actual          = math.ceil(AETHR.MATH:generateNominal(
        genSpawnSettings.nominal,
        genSpawnSettings.min,
        genSpawnSettings.max,
        genSpawnSettings.nudgeFactor))
    genSpawnSettings.actualWeighted  = math.ceil(genSpawnSettings.actual * instance.weight)

    local genthresholds                 = genSpawnSettings.thresholds
    genthresholds.overNom               = math.max(0, genSpawnSettings.actual - spawnSettings.nominal)
    genthresholds.underNom              = math.max(0, spawnSettings.nominal - genSpawnSettings.actual)
    genthresholds.overMax               = math.max(0, genSpawnSettings.actual - spawnSettings.max)
    genthresholds.underMax              = math.max(0, spawnSettings.max - genSpawnSettings.actual)
    genthresholds.overMin               = math.max(0, genSpawnSettings.actual - spawnSettings.min)
    genthresholds.underMin              = math.max(0, spawnSettings.min - genSpawnSettings.actual)

    return instance ---@diagnostic disable-line
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
