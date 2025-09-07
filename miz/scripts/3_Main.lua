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