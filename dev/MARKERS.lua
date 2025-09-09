--- @class AETHR.MARKERS
--- @brief
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field MARKERS AETHR.MARKERS
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
AETHR.MARKERS = {} ---@diagnostic disable-line
AETHR.MARKERS.DATA = {
    ZONE_MANAGER = {
        OutOfBounds = {},
        InBounds = {},
        InOutBoundsGaps = {},
        MizZones = {},
    },
}
function AETHR.MARKERS:New(parent)
    local instance = {
        AETHR = parent,
        -- submodule-local caches/state can be initialized here
        _cache = {},
    }
    setmetatable(instance, { __index = self })
    return instance
end

--- Mark a freeform marker on the map and optionally store the marker object in a provided table.
--- @function AETHR.MARKERS:markFreeform
--- @param _Marker _Marker Marker object describing the freeform shape and styles.
--- @param storageLocation table|nil Optional table to store the marker object keyed by markID.
--- @return AETHR.MARKERS self Returns the MARKERS instance for chaining.
function AETHR.MARKERS:markFreeform(_Marker, storageLocation)
    -- Defensive guards: ensure expected fields exist
    if not _Marker or type(_Marker) ~= "table" then
        return self
    end
    storageLocation = storageLocation or nil

    local coalition = _Marker.coalition or -1
    local fillColor = _Marker.fillColor or { r = 0, g = 0, b = 0, a = 0 }
    local lineColor = _Marker.lineColor or { r = 0, g = 0, b = 0, a = 0 }
    local lineType = _Marker.lineType or 0
    local markID = _Marker.markID or 0
    local verts = _Marker.freeFormVec2Table or {}

    self:drawPolygon(
        coalition,
        fillColor,
        lineColor,
        lineType,
        markID,
        verts
    )

    if storageLocation and type(storageLocation) == "table" then
        storageLocation[markID] = _Marker
    end
    return self
end

--- Draws a polygon with an arbitrary number of vec2 vertices.
--- Supported call forms:
---   drawPolygon(coalition, fillColor, borderColor, linetype, markerID, {v1, v2, v3, ...})
---   drawPolygon(coalition, fillColor, borderColor, linetype, markerID, v1, v2, v3, ...)
--- markerID may be nil (defaults to 0).
--- @function AETHR.MARKERS:drawPolygon
--- @param coalition number Coalition id (e.g., -1 for all)
--- @param fillColor table Fill color table {r,g,b,a} or object with .r .g .b .a
--- @param borderColor table Border color table {r,g,b,a} or object with .r .g .b .a
--- @param linetype number Line type enum value
--- @param markerID number|nil Marker identifier (optional)
--- @param ... table|vec2 Either a single array of vec2 vertices or multiple vec2 arguments
--- @return AETHR.MARKERS self
function AETHR.MARKERS:drawPolygon(coalition, fillColor, borderColor, linetype, markerID, ...)
    local varargs = { ... }
    -- If no vertices provided, nothing to draw
    if not varargs or #varargs == 0 then
        return self
    end

    -- Normalize corners: support either a single array/table of vec2s or multiple vec2 args
    local corners = {}
    if #varargs == 1 and type(varargs[1]) == "table" and not (varargs[1].x and varargs[1].y) then
        -- single array-like table of vec2s
        corners = varargs[1]
    else
        corners = varargs
    end

    -- Need at least 3 vertices to draw a polygon
    if not corners or #corners < 3 then
        return self
    end

    local r1, g1, b1, a1 = fillColor.r, fillColor.g, fillColor.b, fillColor.a         -- Fill color RGBA
    local r2, g2, b2, a2 = borderColor.r, borderColor.g, borderColor.b, borderColor.a -- Border color RGBA
    local shapeTypeID    = 7                                                          -- Polygon shape type
    markerID             = markerID or 0

    -- Build argument list for trigger.action.markupToAll:
    -- shapeTypeID, coalition, markerID, <vec3 points...>, borderColor, fillColor, linetype, true
    local margs          = { shapeTypeID, coalition, markerID }

    -- Preserve original drawZone orientation by reversing corner order
    for i = #corners, 1, -1 do
        local v = corners[i]
        table.insert(margs, { x = v.x, y = 0, z = v.y })
    end

    table.insert(margs, { r2, g2, b2, a2 }) -- Border color
    table.insert(margs, { r1, g1, b1, a1 }) -- Fill color
    table.insert(margs, linetype)
    table.insert(margs, true)

    -- Call markupToAll with the constructed argument list
    trigger.action.markupToAll(unpack(margs))

    return self
end
