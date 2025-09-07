G_AETHR = AETHR:New()
G_AETHR.USERSTORAGE = {
    missionZones = { "Zone_ALPHA", "Zone_BRAVO", "Zone_CHARLIE", "Zone_DELTA", "Zone_ECHO", "Zone_FOXTROT" },
    RedStartZones = { "Zone_ALPHA", "Zone_BRAVO", },
    BlueStartZones = { "Zone_ECHO", },
}

G_AETHR.ZONE_MANAGER:setMizZones(G_AETHR.USERSTORAGE.missionZones, G_AETHR.USERSTORAGE.RedStartZones,
    G_AETHR.USERSTORAGE.BlueStartZones)
G_AETHR:Init()
--:determineActiveDivisions():getActiveObjectsInDivisions(Object.Category.SCENERY)


G_AETHR.WORLD:markWorldDivisions()

local fillColor_ = { r = 0.6, g = 0.6, b = 0.6, a = 0.3 }
local lineColor = { r = 0, g = 0, b = 0, a = 0.6 }


for _, _zone in pairs(G_AETHR.ZONE_MANAGER.DATA.MIZ_ZONES) do
    -- G_AETHR.ZONE_MANAGER:drawZone(
    --     -1,
    --     fillColor_,
    --     lineColor,
    --     5,
    --     _zone.verticies
    -- )
    G_AETHR.ZONE_MANAGER:drawPolygon(
        G_AETHR.ENUMS.Coalition.ALL,
        fillColor_,
        lineColor,
        G_AETHR.ENUMS.LineTypes.LongDash,
        G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS,
        _zone.verticies
    )
    G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS = G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS + 1
end
 fillColor_ = { r = 0.1, g = 0.1, b = 0.1, a = 0.4 }
 lineColor = { r = 0, g = 0, b = 0, a = 0.1 }

local zoneVerts = {}

 for _, _zone in pairs(G_AETHR.ZONE_MANAGER.DATA.MIZ_ZONES) do
        table.insert(zoneVerts, _zone.verticies)
 end

G_AETHR.ZONE_MANAGER:drawOutOfBounds(
G_AETHR.ENUMS.Coalition.ALL,
fillColor_,
lineColor,
G_AETHR.ENUMS.LineTypes.Dashed,
G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS,
zoneVerts,
G_AETHR.CONFIG.MAIN.worldBounds.Caucasus,
{samplesPerEdge = 20}
)


-- local corners = {
--     {
--         x = -58333.333333333,
--         z = 694102.56410256
--       },
--       {
--         x = -16666.666666667,
--         z = 694102.56410256
--       },
--       {
--         x = -16666.666666667,
--         z = 737692.30769231
--       },
--       {
--         x = -58333.333333333,
--         z = 737692.30769231
--       }
-- }
-- AETHR.worldLearning.searchObjectsBox(Object.Category.SCENERY, corners, 2000)

local pause = ""
