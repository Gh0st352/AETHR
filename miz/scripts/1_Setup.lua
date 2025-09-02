G_AETHR = AETHR:New()
G_AETHR.USERSTORAGE = {
    missionZones = { "Zone_ALPHA", "Zone_BRAVO", "Zone_CHARLIE", "Zone_DELTA", "Zone_ECHO", "Zone_FOXTROT" },
    RedStartZones = { "Zone_ALPHA", "Zone_BRAVO", },
    BlueStartZones = { "Zone_ECHO", },
}

G_AETHR:setMizZones(G_AETHR.USERSTORAGE.missionZones, G_AETHR.USERSTORAGE.RedStartZones, G_AETHR.USERSTORAGE.BlueStartZones)
    :Init()
    --:determineActiveDivisions():getActiveObjectsInDivisions(Object.Category.SCENERY)


G_AETHR.worldLearning._markWorldDivisions(G_AETHR)
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
