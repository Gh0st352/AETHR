function _testFunc()
    -- local UnitArr = {}
    -- table.insert(UnitArr, G_AETHR.SPAWNER:buildGroundUnit("Gepard", -27626, 457048))
    -- table.insert(UnitArr, G_AETHR.SPAWNER:buildGroundUnit("M 818", -27624, 457046))
    -- table.insert(UnitArr, G_AETHR.SPAWNER:buildGroundUnit("Leopard1A3", -27622, 457042))
    -- local assembledUnits = G_AETHR.SPAWNER:assembleUnitsForGroup(UnitArr)
    -- local groupName = G_AETHR.SPAWNER:buildGroundGroup(country.id.CJTF_RED, nil, -27626, 457048, assembledUnits)

    -- local UnitArr2 = {}
    -- table.insert(UnitArr2, G_AETHR.SPAWNER:buildGroundUnit("Gepard", -27616, 457018))
    -- table.insert(UnitArr2, G_AETHR.SPAWNER:buildGroundUnit("M 818", -27614, 457016))
    -- table.insert(UnitArr2, G_AETHR.SPAWNER:buildGroundUnit("Leopard1A3", -27612, 457012))
    -- local assembledUnits2 = G_AETHR.SPAWNER:assembleUnitsForGroup(UnitArr2)
    -- local groupName2 = G_AETHR.SPAWNER:buildGroundGroup(country.id.CJTF_RED, nil, -27616, 457018, assembledUnits2)

    -- local UnitArr3 = {}
    -- table.insert(UnitArr3, G_AETHR.SPAWNER:buildGroundUnit("Gepard", -27636, 457038))
    -- table.insert(UnitArr3, G_AETHR.SPAWNER:buildGroundUnit("M 818", -27634, 457036))
    -- table.insert(UnitArr3, G_AETHR.SPAWNER:buildGroundUnit("Leopard1A3", -27632, 457032))
    -- local assembledUnits3 = G_AETHR.SPAWNER:assembleUnitsForGroup(UnitArr3)
    -- local groupName3 = G_AETHR.SPAWNER:buildGroundGroup(country.id.CJTF_RED, nil, -27636, 457038, assembledUnits3)

    -- G_AETHR.SPAWNER:activateGroup("AETHR_GROUND_GROUP#1")
    -- G_AETHR.SPAWNER:deactivateGroup("AETHR_GROUND_GROUP#1")


    -- _testFunc()

    -- G_AETHR.SPAWNER:activateGroup("AETHR_GROUND_GROUP#1")
    -- G_AETHR.SPAWNER:updateDBGroupInfo("AETHR_GROUND_GROUP#1")

    -- AETHR.SPAWNER:spawnGroup("AETHR_GROUND_GROUP#1")
    -- AETHR.SPAWNER:spawnGroup("AETHR_GROUND_GROUP#2")
    -- AETHR.SPAWNER:spawnGroup("AETHR_GROUND_GROUP#3")

    -- AETHR.SPAWNER:despawnGroup("AETHR_GROUND_GROUP#1")
    -- AETHR.SPAWNER:despawnGroup("AETHR_GROUND_GROUP#2")
    -- AETHR.SPAWNER:despawnGroup("AETHR_GROUND_GROUP#3")


    local spawnTypes = G_AETHR.ENUMS.spawnTypes
    local airbaseSpawnerENUM = G_AETHR.ENUMS.dynamicSpawnerTypes.Airbase
    local dynAirbaseSpawner1 = G_AETHR.SPAWNER:newDynamicSpawner(airbaseSpawnerENUM)
        :setNumSpawnZones(5, 3, 7, 0.9)
        :setSpawnAmount(85, 70, 100, 0.5)
        :setGroupSizes(5, 1)
        :setNamePrefix("Airbase_")
        :addExtraTypeToGroups(spawnTypes.GroundUnits, 1)
        :setSpawnTypeAmount(spawnTypes.APC, 3, false)
        :setSpawnTypeAmount(spawnTypes.ModernTanks, 3, true)
        :setSpawnTypeAmount(spawnTypes.Artillery, 3, false)
        :setSpawnTypeAmount(spawnTypes.IFV, 3, false)


    G_AETHR.SPAWNER:generateDynamicSpawner(dynAirbaseSpawner1, { x = -278244, y = 649034 },
        6000, 8000, 10000, .5, country.id.CJTF_RED, G_AETHR.ENUMS.Coalition.RED)
end

function _testFunc2()
    G_AETHR.MARKERS:drawCircle(-1,
        G_AETHR.CONFIG.MAIN.Zone.paintColors.CircleColors[0],
        G_AETHR.CONFIG.MAIN.Zone.paintColors.CircleColors[0],
        G_AETHR.CONFIG.MAIN.Zone.paintColors.lineType,
        G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS,
        { x = -27626, y = 457048 },
        6000
    )
    G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS = G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS + 1
end

local pause = ""
