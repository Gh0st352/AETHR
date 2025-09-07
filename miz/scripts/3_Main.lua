function _testFunc()
    G_AETHR.ZONE_MANAGER:drawGameBounds()
end

--  local    fillColor_ = { r = 0.1, g = 0.1, b = 0.1, a = 0.2 }
--  local lineColor = { r = 0, g = 0, b = 0, a = 0.1 }

-- G_AETHR.ZONE_MANAGER:drawOutOfBounds(
-- G_AETHR.ENUMS.Coalition.ALL,
-- fillColor_,
-- lineColor,
-- G_AETHR.ENUMS.LineTypes.Dashed,
-- G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS,
-- G_AETHR.CONFIG.MAIN.worldBounds.Caucasus -- ,{samplesPerEdge = 10, snapDistance = 70000}
-- )


--G_AETHR.ZONE_MANAGER:getMasterZonePolygon()
-- G_AETHR.ZONE_MANAGER.DATA.inBounds.masterPolyVerts = G_AETHR.POLY:convertLinesToPolygon(
-- G_AETHR.ZONE_MANAGER.DATA.inBounds.masterPolyLines,
-- G_AETHR.CONFIG.MAIN.Zone.BorderOffsetThreshold
-- )
-- local fillColor_ = { r = 1, g = 0, b = 0, a = 0.6 }
-- local lineColor = { r = 1, g = 0, b = 0, a = 0.8 }
-- G_AETHR.ZONE_MANAGER:drawPolygon(
--     G_AETHR.ENUMS.Coalition.ALL,
--     fillColor_,
--     lineColor,
--     G_AETHR.ENUMS.LineTypes.LongDash,
--     G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS,
--     G_AETHR.ZONE_MANAGER.DATA.inBounds.masterPolyVerts
-- )
-- G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS = G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS + 1

-- G_AETHR.ZONE_MANAGER:getOutOfBounds(
--     G_AETHR.ENUMS.Coalition.ALL,
--     { r = 0.1, g = 0.1, b = 0.1, a = 0.2 },
--     { r = 0, g = 0, b = 0, a = 0.1 },
--     G_AETHR.ENUMS.LineTypes.Dashed,
--     G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS,
--     G_AETHR.CONFIG.MAIN.worldBounds.Caucasus -- ,{samplesPerEdge = 10, snapDistance = 70000}
-- )
-- G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS = G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS + 1

-- G_AETHR.ZONE_MANAGER.DATA.boundsGaps = G_AETHR.POLY:findOverlaidPolygonGaps(
-- G_AETHR.ZONE_MANAGER.DATA.inBounds.masterPolyVerts, G_AETHR.ZONE_MANAGER.DATA.outOfBounds.oobCenterPoly)

-- G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS = G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS + 1



-- for index, value in ipairs(G_AETHR.ZONE_MANAGER.DATA.boundsGaps) do
--     local convex = {}
--     if #value == 4 then
--         convex = G_AETHR.POLY:reverseVertOrder(G_AETHR.POLY:ensureConvex(value))  --G_AETHR.POLY:ensureConvex(value)
--     elseif #value > 4 then
--         convex = G_AETHR.POLY:reverseVertOrder(G_AETHR.POLY:ensureConvexN(value)) --G_AETHR.POLY:ensureConvexN(value)
--     else
--         convex = G_AETHR.POLY:reverseVertOrder(G_AETHR.POLY:ensureConvex(value))  --value
--     end
--     --G_AETHR.POLY:ensureConvexN(value)
--     G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS = G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS + 1
--     G_AETHR.ZONE_MANAGER:drawPolygon(
--         G_AETHR.ENUMS.Coalition.ALL,
--         { r = 0.8, g = 0, b = 0.9, a = 1},
--         { r = 0.8, g = 0, b = 0.9, a = 1 },
--         G_AETHR.ENUMS.LineTypes.LongDash,
--         G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS,
--         convex
--     )
-- end

-- for index, value in ipairs(G_AETHR.ZONE_MANAGER.DATA.boundsGaps) do
--     local convex = {}
--     if #value == 4 then
--         convex = G_AETHR.POLY:ensureConvex(value)  --G_AETHR.POLY:ensureConvex(value)
--     elseif #value > 4 then
--         convex = G_AETHR.POLY:ensureConvexN(value) --G_AETHR.POLY:ensureConvexN(value)
--     else
--         convex = G_AETHR.POLY:ensureConvex(value)  --value
--     end
--     --G_AETHR.POLY:ensureConvexN(value)
--     G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS = G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS + 1
--     G_AETHR.ZONE_MANAGER:drawPolygon(
--         G_AETHR.ENUMS.Coalition.ALL,
--         { r = 0.8, g = 0, b = 0.9, a = 1 },
--         { r = 0.8, g = 0, b = 0.9, a = 1 },
--         G_AETHR.ENUMS.LineTypes.LongDash,
--         G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS,
--         convex
--     )
-- end

--end

local pause = ""
