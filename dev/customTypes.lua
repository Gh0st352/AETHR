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
--- @field shapeID number
--- @field markerObject _Marker
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
        invDx = 1 / dx, -- Inverse widths for index computation.
        invDz = 1 / dz, -- Inverse heights for index computation.
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- @class _Marker
--- @field markID number
--- @field string string
--- @field vec3Origin table Vec3 defining the marker origin.
--- @field readOnly boolean
--- @field message string
--- @field shapeId number
--- @field coalition number
--- @field lineType number
--- @field lineColor table
--- @field fillColor table
--- @field freeFormVec2Table table
--- @field radius number
AETHR._Marker = {} ---@diagnostic disable-line

---
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
        lineColor = lineColor or { 0, 0, 0, 0 },     --r,g,b,a
        fillColor = fillColor or { 0, 0, 0, 0 },     --r,g,b,a
        freeFormVec2Table = freeFormVec2Table or {}, --ipair of vec2 for freeform or drawn shapes
        radius = radius or 0,                        --radius for drawn circles
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- @class _airbase
--- @field id table
--- @field id_ number
--- @field coordinates table
--- @field description table
--- @field name string
--- @field category number
--- @field coalition number
--- @field previousCoalition number
--- @field categoryText string
--- @field zoneName string
--- @field zoneObject table
AETHR._airbase = {} ---@diagnostic disable-line
---
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

--- @class _task
--- @field stopAfterTime number|nil
--- @field stopAfterIterations number|nil
--- @field repeatInterval number|nil
--- @field delay number|nil
--- @field taskFunction function
--- @field functionArgs table
--- @field iterations number
--- @field lastRun number
--- @field nextRun number
--- @field stopTime number|nil
--- @field running boolean
--- @field active boolean
--- @field schedulerID number
--- @field repeating boolean
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
