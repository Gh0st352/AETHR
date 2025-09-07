G_AETHR = AETHR:New()
G_AETHR.USERSTORAGE = {
    missionZones = { "Zone_ALPHA", "Zone_BRAVO", "Zone_CHARLIE", "Zone_DELTA", "Zone_ECHO", "Zone_FOXTROT" },
    RedStartZones = { "Zone_ALPHA", "Zone_BRAVO", },
    BlueStartZones = { "Zone_ECHO", },
}

G_AETHR.ZONE_MANAGER:setMizZones(G_AETHR.USERSTORAGE.missionZones, G_AETHR.USERSTORAGE.RedStartZones, G_AETHR.USERSTORAGE.BlueStartZones)
G_AETHR:Init()
    --:determineActiveDivisions():getActiveObjectsInDivisions(Object.Category.SCENERY)


G_AETHR.WORLD:markWorldDivisions()

local fillColor_ = { r = 0.6, g = 0.6, b = 0.6, a = 0.3 }
local lineColor = { r = 0, g = 0, b = 0, a = 0.6 }

for _, _zone in pairs(G_AETHR.ZONE_MANAGER.DATA.MIZ_ZONES) do
    G_AETHR.ZONE_MANAGER:drawZone(
        -1,
        fillColor_,
        lineColor,
        5,
        _zone.verticies
    )
end


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
