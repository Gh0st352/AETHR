G_AETHR = AETHR:New()
G_AETHR.USERSTORAGE = {
    missionZones = { "Zone_ALPHA", "Zone_BRAVO", "Zone_CHARLIE", "Zone_DELTA", "Zone_ECHO", "Zone_FOXTROT" },
    RedStartZones = { "Zone_ALPHA", "Zone_BRAVO", },
    BlueStartZones = { "Zone_ECHO", },
}

G_AETHR:setMizZones(G_AETHR.USERSTORAGE.missionZones)
    :setRedStartMizZones(G_AETHR.USERSTORAGE.RedStartZones)
    :setBlueStartMizZones(G_AETHR.USERSTORAGE.BlueStartZones)
    :Init()

local pause = ""
