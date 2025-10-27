function _testFunc()
    G_AETHR.SPAWNER:enqueueGenerateDynamicSpawner(dynAirbaseSpawner1, { x = -278244, y = 649034 },
        math.random(2000, 3000), math.random(3000, 4000), math.random(4000, 5000), .5, country.id.CJTF_BLUE, true)

    -- G_AETHR.SPAWNER:enqueueGenerateDynamicSpawner(dynAirbaseSpawner1, { x = -278244, y = 649034 },
    --     math.random(2000, 3000), math.random(3000, 4000), math.random(4000, 5000), .5, country.id.CJTF_RED, true)

    -- G_AETHR.SPAWNER:generateDynamicSpawner(dynAirbaseSpawner1, { x = -278244, y = 649034 },
    --     math.random(2000, 3000), math.random(3000, 4000), math.random(4000, 5000), .5)

    -- G_AETHR.SPAWNER:spawnDynamicSpawner(dynAirbaseSpawner1, country.id.CJTF_BLUE)
    -- -------------------------------------------------------------------------------------------------------------------------------
    -- G_AETHR.SPAWNER:generateDynamicSpawner(dynAirbaseSpawner1, { x = -278244, y = 649034 },
    --     math.random(2000, 3000), math.random(3000, 4000), math.random(4000, 5000), .5)

    -- G_AETHR.SPAWNER:spawnDynamicSpawner(dynAirbaseSpawner1, country.id.CJTF_RED)

    local pause2 = ""
end

--G_AETHR.BRAIN:scheduleTask(_testFunc,15,5)

function _testFunc2()
    -- G_AETHR.MARKERS:drawCircle(-1,
    --     G_AETHR.CONFIG.MAIN.Zone.paintColors.CircleColors[0],
    --     G_AETHR.CONFIG.MAIN.Zone.paintColors.CircleColors[0],
    --     G_AETHR.CONFIG.MAIN.Zone.paintColors.lineType,
    --     G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS,
    --     { x = -27626, y = 457048 },
    --     6000
    -- )
    -- G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS = G_AETHR.CONFIG.MAIN.COUNTERS.MARKERS + 1

    for _, cluster in pairs(G_AETHR.WORLD.DATA.townClusterDB) do
        --if cluster.Radius >= 1000 then
        G_AETHR.MARKERS:drawGenericCircle(cluster.Center, cluster.Radius, G_AETHR.MARKERS.DATA.townClusters)
        -- end
    end
end

function _testFunc3()
    local pause = ""
end

function _testFunc4()
    local zones = G_AETHR.ZONE_MANAGER.DATA.MIZ_ZONES
    for zoneName, zoneObj in pairs(zones) do
        G_AETHR.UTILS:debugInfo("Zone: " .. zoneName)
        local airbases_ = zoneObj.Airbases
        for name, abObj in pairs(airbases_) do
            G_AETHR.UTILS:debugInfo("Airbase: " .. name)
            local vec2 = { x = abObj.coordinates.x, y = abObj.coordinates.z }
            local radius = 5000
            local coalition = abObj.coalition
            local countryID = coalition == 1 and country.id.CJTF_RED or country.id.CJTF_BLUE
            local dynamicSpawner = nil
            local minTownRadius = 300
            local maxTownRadius = nil
            local spawnChance = 0.5
            local concentricSpawnChanceMultiplier = 0.5
            local concentricRadiusMultipier = 2
            local concentricIterations = 3
            -- local minCircleRadius = 0
            -- local maxCircleRadius = 5000

            G_AETHR.ZONE_MANAGER:spawnTownsExpandingCircle(vec2, radius, countryID, minTownRadius, maxTownRadius,
                dynamicSpawner, spawnChance, concentricSpawnChanceMultiplier, concentricRadiusMultipier,
                concentricIterations)
        end

        -- G_AETHR.ZONE_MANAGER:spawnTownsCircle(vec2, radius, countryID, minTownRadius, maxTownRadius, dynamicSpawner,
        --     spawnChance, minCircleRadius, maxCircleRadius)

        -- minTownRadius = 300
        -- maxTownRadius = 2000
        -- spawnChance = 0.22
        -- minCircleRadius = 5001
        -- maxCircleRadius = 10000
        -- G_AETHR.ZONE_MANAGER:spawnTownsCircle(vec2, radius, countryID, minTownRadius, maxTownRadius, dynamicSpawner,
        --     spawnChance, minCircleRadius, maxCircleRadius)

        -- minTownRadius = 300
        -- maxTownRadius = 2000
        -- spawnChance = 0.11
        -- minCircleRadius = 10001
        -- maxCircleRadius = 15000
        -- G_AETHR.ZONE_MANAGER:spawnTownsCircle(vec2, radius, countryID, minTownRadius, maxTownRadius, dynamicSpawner,
        --     spawnChance, minCircleRadius, maxCircleRadius)
    end
end

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
-- :setNumSpawnZones(6, 4, 8, 0.5)
-- :setSpawnAmount(35, 20, 50, 0.5)

local pause = ""
