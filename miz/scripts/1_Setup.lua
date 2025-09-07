G_AETHR = AETHR:New()
G_AETHR.USERSTORAGE = {
    missionZones = { "Zone_ALPHA", "Zone_BRAVO", "Zone_CHARLIE", "Zone_DELTA", "Zone_ECHO", "Zone_FOXTROT" },
    RedStartZones = { "Zone_ALPHA", "Zone_BRAVO", },
    BlueStartZones = { "Zone_ECHO", },
}

G_AETHR.ZONE_MANAGER:setMizZones(G_AETHR.USERSTORAGE.missionZones, G_AETHR.USERSTORAGE.RedStartZones,
    G_AETHR.USERSTORAGE.BlueStartZones)
G_AETHR:Init():Start()



local pause = ""
