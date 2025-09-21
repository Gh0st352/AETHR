function _testFunc()
    local UnitArr = {}
    table.insert(UnitArr, G_AETHR.SPAWNER:buildGroundUnit("Gepard", -27626, 457048))
    table.insert(UnitArr, G_AETHR.SPAWNER:buildGroundUnit("M 818", -27624, 457046))
    table.insert(UnitArr, G_AETHR.SPAWNER:buildGroundUnit("Leopard1A3", -27622, 457042))
    local assembledUnits = AETHR.SPAWNER:assembleUnitsForGroup(UnitArr)
    local groupName = AETHR.SPAWNER:buildGroundGroup(country.id.CJTF_RED, nil, -27626, 457048, assembledUnits)
    --G_AETHR.SPAWNER:activateGroup(groupName)
    -- G_AETHR.SPAWNER:updateDBGroupInfo(groupName)

--     G_AETHR.SPAWNER:activateGroup("AETHR_GROUND_GROUP#1")
-- G_AETHR.SPAWNER:deactivateGroup("AETHR_GROUND_GROUP#1")


-- _testFunc()

-- G_AETHR.SPAWNER:activateGroup("AETHR_GROUND_GROUP#1")
-- G_AETHR.SPAWNER:updateDBGroupInfo("AETHR_GROUND_GROUP#1")
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
