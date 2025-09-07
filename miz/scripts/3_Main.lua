function _testFunc()
 local    fillColor_ = { r = 0.1, g = 0.1, b = 0.1, a = 0.2 }
 local lineColor = { r = 0, g = 0, b = 0, a = 0.1 }

G_AETHR.ZONE_MANAGER:drawOutOfBounds(
G_AETHR.ENUMS.Coalition.ALL,
fillColor_,
lineColor,
G_AETHR.ENUMS.LineTypes.Dashed,
G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS,
G_AETHR.CONFIG.MAIN.worldBounds.Caucasus -- ,{samplesPerEdge = 10, snapDistance = 70000}
)
end

G_AETHR.ZONE_MANAGER:getMasterZonePolygon()
-- G_AETHR.ZONE_MANAGER.DATA.inBounds.masterPolyVerts = G_AETHR.POLY:convertLinesToPolygon(
-- G_AETHR.ZONE_MANAGER.DATA.inBounds.masterPolyLines,
-- G_AETHR.CONFIG.MAIN.Zone.BorderOffsetThreshold
-- )
local fillColor_ = { r = 1, g = 0, b = 0, a = 0.3 }
local lineColor = { r = 1, g = 0, b = 0, a = 0.6 }
    G_AETHR.ZONE_MANAGER:drawPolygon(
        G_AETHR.ENUMS.Coalition.ALL,
        fillColor_,
        lineColor,
        G_AETHR.ENUMS.LineTypes.LongDash,
        G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS,
        G_AETHR.ZONE_MANAGER.DATA.inBounds.masterPolyVerts
    )
    G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS = G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS + 1


local pause = ""