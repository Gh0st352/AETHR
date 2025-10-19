G_AETHR = AETHR:New()
G_AETHR.CONFIG.MAIN.DEBUG_ENABLED = true -- Enable debug logging to DCS log.
G_AETHR.SPAWNER.DATA.CONFIG.Benchmark = true
G_AETHR.USERSTORAGE = {
    missionZones = { "Zone_ALPHA", "Zone_BRAVO", "Zone_CHARLIE", "Zone_DELTA", "Zone_ECHO", "Zone_FOXTROT" },
    RedStartZones = { "Zone_ALPHA", "Zone_BRAVO", "Zone_DELTA"},
    BlueStartZones = { "Zone_ECHO", "Zone_CHARLIE"},
}

G_AETHR.ZONE_MANAGER:setMizZones(G_AETHR.USERSTORAGE.missionZones, G_AETHR.USERSTORAGE.RedStartZones,
    G_AETHR.USERSTORAGE.BlueStartZones)
G_AETHR:Init():Start()

local spawnTypes = G_AETHR.ENUMS.spawnTypes
local airbaseSpawnerENUM = G_AETHR.ENUMS.dynamicSpawnerTypes.Airbase
local dynAirbaseSpawner1 = G_AETHR.SPAWNER:newDynamicSpawner(airbaseSpawnerENUM)
    :setNumSpawnZones(math.random(4, 6), math.random(1, 3), math.random(7, 9), 0.5)
    :setSpawnAmount(math.random(10, 20), math.random(5, 9), math.random(21, 30), 0.5)
    :setGroupSizes(math.random(3, 5), 1)
    :setNamePrefix("Airbase_")
    :addExtraTypeToGroups(spawnTypes.GroundUnits, 1)
    :setSpawnTypeAmount(spawnTypes.APC, 3, false)
    :setSpawnTypeAmount(spawnTypes.ModernTanks, 3, true)
    :setSpawnTypeAmount(spawnTypes.Artillery, 3, false)
    :setSpawnTypeAmount(spawnTypes.IFV, 3, false)
    :setSpawnTypeAmount(spawnTypes.Infantry_Carriers, 2, false)
    :setSpawnTypeAmount(spawnTypes.CRAM , 2, false)
    :setSpawnTypeAmount(spawnTypes.Infantry_Carriers, 2, false)

local townSpawnerENUM = G_AETHR.ENUMS.dynamicSpawnerTypes.Town
local dynATownSpawner1 = G_AETHR.SPAWNER:newDynamicSpawner(townSpawnerENUM)
    :setNumSpawnZones(math.random(4, 6), math.random(1, 3), math.random(7, 9), 0.5)
    :setSpawnAmount(math.random(10, 20), math.random(5, 9), math.random(21, 30), 0.5)
    :setGroupSizes(math.random(3, 5), 1)
    :setNamePrefix("Town_")
    :addExtraTypeToGroups(spawnTypes.GroundUnits, 1)
    :setSpawnTypeAmount(spawnTypes.APC, 3, false)
    :setSpawnTypeAmount(spawnTypes.ModernTanks, 3, true)
    :setSpawnTypeAmount(spawnTypes.Artillery, 3, false)
    :setSpawnTypeAmount(spawnTypes.IFV, 3, false)
    :setSpawnTypeAmount(spawnTypes.Infantry_Carriers, 2, false)
    :setSpawnTypeAmount(spawnTypes.CRAM , 2, false)
    :setSpawnTypeAmount(spawnTypes.Infantry_Carriers, 2, false)

--G_AETHR.SPAWNER:spawnAirbaseFill()

local pause = ""
