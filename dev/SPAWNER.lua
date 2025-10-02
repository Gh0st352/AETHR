--- @class AETHR.SPAWNER
--- @brief Spawns and manages DCS ground units/groups, maintains a local DB, and provides spawn/despawn queues processed by WORLD.
---@diagnostic disable: undefined-global
--- Submodule wiring (set by AETHR:New):
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New).
--- @field CONFIG AETHR.CONFIG Configuration table attached per-instance.
--- @field FILEOPS AETHR.FILEOPS File operations helper table attached per-instance.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field UTILS AETHR.UTILS Utility helper table attached per-instance.
--- @field BRAIN AETHR.BRAIN Brain submodule attached per-instance.
--- @field MATH AETHR.MATH Math helper table attached per-instance.
--- @field AUTOSAVE AETHR.AUTOSAVE Autosave submodule attached per-instance.
--- @field ENUMS AETHR.ENUMS ENUMS submodule attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field MARKERS AETHR.MARKERS Marker utilities submodule attached per-instance.
--- @field DATA AETHR.SPAWNER.DATA Container for spawner-managed data.
AETHR.SPAWNER = {} ---@diagnostic disable-line

--- Spawner-managed data container.
--- @class AETHR.SPAWNER.DATA
--- @field generatedGroups table<string, _groundGroup> Generated ground groups keyed by name.
--- @field generatedUnits table<string, _groundUnit> Generated ground units keyed by name.
--- @field spawnQueue string[] Names of groups scheduled to spawn (processed by WORLD:spawnGroundGroups).
--- @field despawnQueue string[] Names of groups scheduled to despawn (processed by WORLD:despawnGroundGroups).
--- @field dynamicSpawners table<string, table<string, _dynamicSpawner>> Dynamic spawners keyed by type and name.
--- @field CONFIG table Configuration for spawner-managed data.
--- @field BenchmarkLog table<string, table> Internal container for benchmark logs.

--- @class AETHR.SPAWNER.DATA.dynamicSpawners
--- @field dynamicSpawners.Airbase table<string, _dynamicSpawner> Dynamic spawners of type "Airbase" keyed by name.
--- @field dynamicSpawners.Zone table<string, _dynamicSpawner> Dynamic spawners of type "Zone" keyed by name.
--- @field dynamicSpawners.Point table<string, _dynamicSpawner> Dynamic spawners of type "Point" keyed by name.

--- @class AETHR.SPAWNER.DATA.CONFIG
--- @field operationLimit number Maximum number of spawn/despawn operations to process per WORLD cycle (>0).
--- @field UseDivisionAABBReject boolean If true, use division AABB rejection to speed up placement (may skip some valid placements).
--- @field UseDivisionAABBFullInclude boolean If true, use division AABB full inclusion to speed up placement (may skip some valid placements).
--- @field Benchmark boolean If true, enables benchmarking logs for spawner operations.
--- @field NoGoSurfaces AETHR.ENUMS.SurfaceType[] List of surface types that are not valid for spawning.
--- @field seperationSettings table Settings for minimum separation of spawned groups/units from each other and buildings.
--- @field seperationSettings.minGroups number Minimum distance in meters between spawned groups.
--- @field seperationSettings.maxGroups number Maximum distance in meters between spawned groups.
--- @field seperationSettings.minUnits number Minimum distance in meters between spawned units within a group.
--- @field seperationSettings.maxUnits number Maximum distance in meters between spawned units within a group.
--- @field seperationSettings.minBuildings number Minimum distance in meters between spawned units and buildings.
--- @field debugMarkers table<number, _Marker> Internal container for debug markers keyed by marker ID.

--- Container for spawner-managed data.
---@type AETHR.SPAWNER.DATA
AETHR.SPAWNER.DATA = {
    ---@type table<string, _groundGroup>
    generatedGroups = {},
    ---@type table<string, _groundUnit>
    generatedUnits = {},
    ---@type string[]
    spawnQueue = {},
    ---@type string[]
    despawnQueue = {},
    dynamicSpawners = {
        Airbase = {},
        Zone = {},
        Point = {},
    },
    BenchmarkLog = {},
    CONFIG = {
        UseDivisionAABBReject = true,
        UseDivisionAABBFullInclude = true,
        operationLimit = 50,
        Benchmark = true,
        NoGoSurfaces = {
            AETHR.ENUMS.SurfaceType.WATER,
            AETHR.ENUMS.SurfaceType.RUNWAY,
            AETHR.ENUMS.SurfaceType.SHALLOW_WATER
        },
        seperationSettings = {
            minGroups = 35,
            maxGroups = 70,
            minUnits = 15,
            maxUnits = 30,
            minBuildings = 35,
        },
    },
    debugMarkers = {}
}



--- Creates a new AETHR.SPAWNER submodule instance.
--- @function AETHR.SPAWNER:New
--- @param parent AETHR Parent AETHR instance.
--- @return AETHR.SPAWNER instance New instance inheriting AETHR.SPAWNER methods.
function AETHR.SPAWNER:New(parent)
    local instance = {
        AETHR = parent,
        --- Internal cache for ad-hoc memoization.
        ---@type table<string, any>
        _cache = {},
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- Builds and registers a ground unit prototype with the spawner system.
--- Stores the constructed _groundUnit in DATA.generatedUnits and returns its unique name.
--- @function AETHR.SPAWNER:buildGroundUnit
--- @param type string Unit type, e.g. "T-80UD".
--- @param x number X coordinate in meters.
--- @param y number Y coordinate in meters (used as DCS Z when grouped).
--- @param skill string|nil Skill level ("Excellent"|"High"|"Good"|"Average"|"Random"|"Player"). Defaults to ENUMS.Skill.Random if nil.
--- @param name string|nil Unit name prefix. A unique counter will be appended, e.g. "foo#123". If nil, "AETHR_GROUND_UNIT#123" is used.
--- @param heading number|nil Heading in degrees. Defaults to random if nil.
--- @param playerCanDrive boolean|nil If true, players can drive this unit. Defaults to true if nil.
--- @param randomTransportable boolean|nil If true, unit is randomly transportable by helicopters. Defaults to true if nil.
--- @return string groundUnitName Unique name of the created ground unit (key in DATA.generatedUnits).
function AETHR.SPAWNER:buildGroundUnit(type, x, y, skill, name, heading, playerCanDrive, randomTransportable)
    skill = skill or nil
    heading = heading and heading or self.MATH:degreeToRadian(math.random(0, 360))
    playerCanDrive = playerCanDrive or nil
    randomTransportable = randomTransportable or nil

    local groundUnitName = name and name .. "#" .. tostring(self.CONFIG.MAIN.COUNTERS.UNITS) or
        "AETHR_GROUND_UNIT#" .. tostring(self.CONFIG.MAIN.COUNTERS.UNITS)
    self.CONFIG.MAIN.COUNTERS.UNITS = self.CONFIG.MAIN.COUNTERS.UNITS + 1

    ---@type _groundUnit
    local groundUnit = self.AETHR._groundUnit:New(type, skill, x, y, groundUnitName, heading, playerCanDrive,
        randomTransportable)
    self.DATA.generatedUnits[groundUnitName] = groundUnit

    return groundUnitName
end

--- Builds and registers a ground group with the spawner system and immediately adds it to the mission.
--- Stores the constructed _groundGroup in DATA.generatedGroups and calls coalition.addGroup.
--- To build units from names first, use :assembleUnitsForGroup(unitNameList) and pass the result here.
--- @function AETHR.SPAWNER:buildGroundGroup
--- @param countryID number Country ID as per DCS scripting API (coalition side depends on this id).
--- @param name string|nil Optional group name prefix. A unique counter will be appended, e.g. "foo#123". If nil, "AETHR_GROUND_GROUP#123" is used.
--- @param x number Group X coordinate in meters.
--- @param y number Group Y coordinate in meters (DCS Z).
--- @param units _groundUnit[] List of ground unit prototypes (see AETHR._groundUnit). Use :assembleUnitsForGroup(...) to resolve from names if needed.
--- @param route table|nil Optional route table as per DCS scripting API (nil = no route).
--- @param tasks table|nil Optional tasks table as per DCS scripting API (nil = no tasks).
--- @param lateActivation boolean|nil If true, group remains inactive until activated. Defaults to true if nil.
--- @param visible boolean|nil If true, group is visible on the F10 map. Defaults to false if nil.
--- @param taskSelected boolean|nil If true, group is task-selected. Defaults to true if nil.
--- @param hidden boolean|nil If true, group is hidden in the mission editor. Defaults to false if nil.
--- @param hiddenOnPlanner boolean|nil If true, group is hidden in the in-game planner. Defaults to false if nil.
--- @param hiddenOnMFD boolean|nil If true, group is hidden from in-game MFDs. Defaults to false if nil.
--- @param start_time number|nil Start time in seconds from mission start. Defaults to 0 (immediate).
--- @param task string|nil Initial task string (DCS ground task). Defaults to "Ground Nothing" if nil.
--- @param uncontrollable boolean|nil If true, group is uncontrollable by players (except GMs). Defaults to false if nil.
--- @return string groundGroupName Unique name of the created ground group (key in DATA.generatedGroups).
function AETHR.SPAWNER:buildGroundGroup(countryID, name, x, y, units, route, tasks, lateActivation, visible, taskSelected,
                                        hidden,
                                        hiddenOnPlanner, hiddenOnMFD,
                                        start_time, task, uncontrollable)
    lateActivation = lateActivation or nil
    visible = visible or nil
    taskSelected = taskSelected or nil
    hidden = hidden or nil
    hiddenOnPlanner = hiddenOnPlanner or nil
    hiddenOnMFD = hiddenOnMFD or nil
    route = route or nil
    tasks = tasks or nil
    start_time = start_time or nil
    task = task or nil
    uncontrollable = uncontrollable or nil

    local groundGroupName = name and name .. "#" .. tostring(self.CONFIG.MAIN.COUNTERS.GROUPS) or
        "AETHR_GROUND_GROUP#" .. tostring(self.CONFIG.MAIN.COUNTERS.GROUPS)
    self.CONFIG.MAIN.COUNTERS.GROUPS = self.CONFIG.MAIN.COUNTERS.GROUPS + 1

    ---@type _groundGroup
    local groundGroup = self.AETHR._groundGroup:New(visible, taskSelected, lateActivation, hidden, hiddenOnPlanner,
        hiddenOnMFD,
        route, tasks, units, y, x, groundGroupName, start_time, task, uncontrollable, countryID)

    self.DATA.generatedGroups[groundGroupName] = groundGroup

    --coalition.addGroup(countryID, Group.Category.GROUND, groundGroup)

    return groundGroupName
end

--- Resolve unit names (created via :buildGroundUnit) to unit prototypes (_groundUnit) for grouping.
--- Unknown names are ignored.
--- @function AETHR.SPAWNER:assembleUnitsForGroup
--- @param UnitNames string[] List of ground unit names.
--- @return _groundUnit[] units Resolved ground unit prototypes in the same order (missing names skipped).
function AETHR.SPAWNER:assembleUnitsForGroup(UnitNames)
    local units = {}
    for _, unitName in ipairs(UnitNames) do
        ---@type _groundUnit|nil
        local unitData = self.DATA.generatedUnits[unitName]
        if unitData then
            table.insert(units, unitData)
        end
    end
    return units
end

--- Activates an already present group by name.
--- @function AETHR.SPAWNER:activateGroup
--- @param groupName string Group name.
--- @return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:activateGroup(groupName)
    Group.activate(Group.getByName(groupName))
    return self
end

--- Deactivates a group by name.
--- @function AETHR.SPAWNER:deactivateGroup
--- @param groupName string Group name.
--- @return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:deactivateGroup(groupName)
    -- self:updateDBGroupInfo(groupName)
    trigger.action.deactivateGroup(Group.getByName(groupName))
    return self
end

--- Updates cached DB info for a group: writes each unit's latest x/y (x/z from DCS), and computes group center.
--- @function AETHR.SPAWNER:updateDBGroupInfo
--- @param Name string Group name to update.
--- @return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:updateDBGroupInfo(Name)
    local groupObj = Group.getByName(Name)
    local unitsObj = groupObj:getUnits()
    ---@type _groundGroup
    local DB = self.DATA.generatedGroups[Name]

    local unitPoints = {} ---@type _vec2[]

    for index, _unit in pairs(unitsObj) do
        local unitName = _unit:getName()
        local unitPos = _unit:getPoint()
        local unitLife = _unit:getLife()
        if unitLife > 1 then
            table.insert(unitPoints, { x = unitPos.x, y = unitPos.z })
        end
        -- Persist the unit's last known ground X/Z into our DB as x/y.
        DB.units[index].x = unitPos.x
        DB.units[index].y = unitPos.z
    end

    local groupCenter = self.POLY:getCenterPoint(unitPoints)
    DB.x = groupCenter.x
    DB.y = groupCenter.y

    return self
end

--- Spawns a prepared group (from DATA.generatedGroups) and enqueues it for bookkeeping.
--- @function AETHR.SPAWNER:spawnGroup
--- @param groupName string Name of the prepared group (key in DATA.generatedGroups).
--- @param countryID number|nil Optional country ID to override the group's countryID (as per DCS scripting API).
--- @return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:spawnGroup(groupName, countryID)
    local _group = self.DATA.generatedGroups[groupName]
    coalition.addGroup(countryID and countryID or _group.countryID, Group.Category.GROUND, _group)
    table.insert(self.DATA.spawnQueue, groupName)
    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
--- @param countryID number|nil Optional country ID to override the group's countryID (as per DCS scripting API).
function AETHR.SPAWNER:spawnDynamicSpawner(dynamicSpawner, countryID)
    local subZones = dynamicSpawner.zones.sub
    ---@param subZone _spawnerZone
    for indexSubZone, subZone in pairs(subZones) do
        local spawnGroups = subZone.spawnGroups
        for indexGroup, groupName in ipairs(spawnGroups) do
            local _group = self.DATA.generatedGroups[groupName]
            coalition.addGroup(countryID and countryID or _group.countryID, Group.Category.GROUND, _group)
            table.insert(self.DATA.spawnQueue, groupName)
        end
    end
    return self
end

--- Despawns a live group by name by enqueuing it for WORLD processing after updating the DB snapshot.
--- @function AETHR.SPAWNER:despawnGroup
--- @param groupName string Group name.
--- @return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:despawnGroup(groupName)
    self:updateDBGroupInfo(groupName)
    table.insert(self.DATA.despawnQueue, groupName)
    return self
end

--- @return _dynamicSpawner dynamicSpawner created dynamic spawner.
function AETHR.SPAWNER:newDynamicSpawner(dynamicSpawnerType)
    local name = "AETHR_DYNAMIC_SPAWNER#" .. tostring(self.CONFIG.MAIN.COUNTERS.DYNAMIC_SPAWNERS)
    self.CONFIG.MAIN.COUNTERS.DYNAMIC_SPAWNERS = self.CONFIG.MAIN.COUNTERS.DYNAMIC_SPAWNERS + 1

    local dynamicSpawner = self.AETHR._dynamicSpawner:New(name, self.AETHR)


    self.DATA.dynamicSpawners[dynamicSpawnerType][dynamicSpawner.name] = dynamicSpawner
    return dynamicSpawner
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
---@param vec2 _vec2 Center point for the spawner to generate around.
---@param minRadius number|nil Minimum radius in meters. Defaults to dynamicSpawner.minRadius if nil.
---@param nominalRadius number|nil Nominal radius in meters. Defaults to dynamicSpawner.nominal if nil.
---@param maxRadius number|nil Maximum radius in meters. Defaults to dynamicSpawner.maxRadius if nil.
---@param nudgeFactorRadius number|nil Nudge factor for radius adjustment (0.0-1.0). Defaults to dynamicSpawner.nudgeFactorRadius if nil.
---@param countryID number|nil Country ID for spawned groups. Defaults to dynamicSpawner.countryID (0) if nil.
function AETHR.SPAWNER:generateDynamicSpawner(dynamicSpawner, vec2, minRadius, nominalRadius, maxRadius,
                                              nudgeFactorRadius, countryID)
    if self.DATA.CONFIG.Benchmark then
        self.UTILS:debugInfo(
            "BENCHMARK - - - AETHR.SPAWNER:generateDynamicSpawner started for --------------------------------------- : " ..
            dynamicSpawner.name)
        self.DATA.BenchmarkLog.generateDynamicSpawner = { Time = {}, }
        self.DATA.BenchmarkLog.generateDynamicSpawner.Time.start = os.clock()
    end

    dynamicSpawner.minRadius = minRadius or dynamicSpawner.minRadius
    dynamicSpawner.nominalRadius = nominalRadius or dynamicSpawner.nominalRadius
    dynamicSpawner.maxRadius = maxRadius or dynamicSpawner.maxRadius
    dynamicSpawner.nudgeFactorRadius = nudgeFactorRadius or dynamicSpawner.nudgeFactorRadius
    dynamicSpawner.vec2 = vec2
    if self.UTILS.sumTable(self.ZONE_MANAGER.DATA.MIZ_ZONES) > 0 then
        self:pairSpawnerActiveZones(dynamicSpawner)
    else
        self:pairSpawnerWorldDivisions(dynamicSpawner)
    end
    self:generateSpawnerZones(dynamicSpawner)
    self:weightZones(dynamicSpawner)
    self:generateSpawnAmounts(dynamicSpawner)
    self:rollSpawnGroupSizes(dynamicSpawner)

    self:generateSpawnerGroups(dynamicSpawner)
    self:buildSpawnGroups(dynamicSpawner, countryID)

    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.generateDynamicSpawner.Time.stop = os.clock()
        self.DATA.BenchmarkLog.generateDynamicSpawner.Time.total =
            self.DATA.BenchmarkLog.generateDynamicSpawner.Time.stop -
            self.DATA.BenchmarkLog.generateDynamicSpawner.Time.start
        self.UTILS:debugInfo("BENCHMARK - D - AETHR.SPAWNER:generateDynamicSpawner ------------- completed in : " ..
            tostring(self.DATA.BenchmarkLog.generateDynamicSpawner.Time.total) .. " seconds.")
        self.UTILS:debugInfo("BENCHMARK - D -           Generated Units       : " .. tostring(dynamicSpawner._confirmedTotal))
        self.UTILS:debugInfo("BENCHMARK - D -           Spawn Area Radius (m) : " .. tostring(dynamicSpawner.zones.main.actualRadius))
        self.UTILS:debugInfo("BENCHMARK - D -          Number Spawn Zones     : " .. tostring(dynamicSpawner.numSubZones))
        self.UTILS:debugInfo("BENCHMARK - D - Avg Spawn Zone Unit Distrib     : " .. tostring(dynamicSpawner.averageDistribution))
        for type, typeVal in pairs(dynamicSpawner.spawnTypes) do
        self.UTILS:debugInfo("BENCHMARK - D -                # Spawn Type     : " .. tostring(type) .. ": " .. tostring(typeVal.actual))
        end
        for type, typeVal in pairs(dynamicSpawner.extraTypes) do
        self.UTILS:debugInfo("BENCHMARK - D -      # Extra Type Per Group     : " .. tostring(type) .. ": " .. tostring(typeVal.min))
        end

        --self.UTILS:debugInfo("BENCHMARK - - - Generated Units: " .. tostring(dynamicSpawner._confirmedTotal))
    end
    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:generateSpawnerGroups(dynamicSpawner)
    self:rollSpawnGroups(dynamicSpawner)
    self:rollGroupPlacement(dynamicSpawner)
    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:rollGroupPlacement(dynamicSpawner)
    self:pairSpawnerZoneDivisions(dynamicSpawner)
    self:determineZoneDivObjects(dynamicSpawner)
    self:generateVec2GroupCenters(dynamicSpawner)
    self:generateVec2UnitPos(dynamicSpawner)
    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
---@param countryID number|nil Country ID for spawned groups. Defaults to dynamicSpawner.countryID (0) if nil.
function AETHR.SPAWNER:buildSpawnGroups(dynamicSpawner, countryID)
    local subZones = dynamicSpawner.zones.sub

    ---@param subZone _spawnerZone
    for indexSubZone, subZone in pairs(subZones) do
        local spawnGroups = {}
        local groupSettings = subZone.groupSettings
        for indexGroupSetting, groupSetting in pairs(groupSettings) do
            if groupSetting.numGroups > 0 then
                local generatedGroupUnitTypes = groupSetting.generatedGroupUnitTypes
                local generatedGroupCenterVec2s = groupSetting.generatedGroupCenterVec2s
                local generatedUnitVec2s = groupSetting.generatedUnitVec2s
                local generatedGroupTypes = groupSetting.generatedGroupTypes
                for indexGroup, UnitList in ipairs(generatedGroupUnitTypes) do
                    local groupCenterVec2 = generatedGroupCenterVec2s[indexGroup]
                    local groupUnitNames = {}
                    for indexUnit, unitType in ipairs(UnitList) do
                        local unitTypeName = unitType
                        local unitName = dynamicSpawner.spawnedNamePrefix .. generatedGroupTypes[indexGroup][indexUnit]
                        local unitVec2 = generatedUnitVec2s[indexGroup][indexUnit]
                        groupUnitNames[#groupUnitNames + 1] = self:buildGroundUnit(unitTypeName, unitVec2.x, unitVec2.y,
                            dynamicSpawner.skill, unitName, nil, true, false)
                    end
                    spawnGroups[#spawnGroups + 1] = self:buildGroundGroup(countryID,
                        dynamicSpawner.spawnedNamePrefix .. "Group_", groupCenterVec2.x, groupCenterVec2.y,
                        self:assembleUnitsForGroup(groupUnitNames), nil, nil, true, false, true, false, false, false, 0,
                        "Ground Nothing", false)
                end
            end
        end
        subZone.spawnGroups = spawnGroups
    end
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:pairSpawnerWorldDivisions(dynamicSpawner)
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.pairSpawnerWorldDivisions = { Time = {}, }
        self.DATA.BenchmarkLog.pairSpawnerWorldDivisions.Time.start = os.clock()
    end


    local spawnerActiveDivisions = {}
    local mainZoneRadius = dynamicSpawner.maxRadius
    local mainZoneCenter = dynamicSpawner.vec2
    ---@type table<number, _WorldDivision>
    local worldDivisions = self.WORLD.DATA.worldDivisions

    ---@param div _WorldDivision
    for _ID, div in pairs(worldDivisions) do
        if self.POLY:circleOverlapPoly(mainZoneRadius, mainZoneCenter, div.corners) then
            spawnerActiveDivisions[_ID] = div
        end
    end
    dynamicSpawner.worldDivisions = spawnerActiveDivisions

    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.pairSpawnerWorldDivisions.Time.stop = os.clock()
        self.DATA.BenchmarkLog.pairSpawnerWorldDivisions.Time.total =
            self.DATA.BenchmarkLog.pairSpawnerWorldDivisions.Time.stop -
            self.DATA.BenchmarkLog.pairSpawnerWorldDivisions.Time.start
        self.UTILS:debugInfo("BENCHMARK - - - AETHR.SPAWNER:pairSpawnerWorldDivisions completed in " ..
            tostring(self.DATA.BenchmarkLog.pairSpawnerWorldDivisions.Time.total) .. " seconds.")
    end
    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:pairSpawnerActiveZones(dynamicSpawner)
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.pairSpawnerActiveZones = { Time = {}, }
        self.DATA.BenchmarkLog.pairSpawnerActiveZones.Time.start = os.clock()
    end

    ---@type table<string, _MIZ_ZONE>
    local mizZones = self.ZONE_MANAGER.DATA.MIZ_ZONES

    local _MizZones = {}
    local spawnerActiveDivisions = {}
    ---@param mizZoneName string
    ---@param mizZone _MIZ_ZONE
    for mizZoneName, mizZone in pairs(mizZones) do
        local mizZoneVerts = mizZone.verticies
        local mainZoneRadius = dynamicSpawner.maxRadius
        local mainZoneCenter = dynamicSpawner.vec2

        if self.POLY:circleOverlapPoly(mainZoneRadius, mainZoneCenter, mizZoneVerts) then
            table.insert(_MizZones, mizZone)
            for _ID, div in pairs(mizZone.activeDivsions) do
                spawnerActiveDivisions[_ID] = div
            end
        end
    end
    dynamicSpawner.mizZones = _MizZones
    dynamicSpawner.worldDivisions = spawnerActiveDivisions

    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.pairSpawnerActiveZones.Time.stop = os.clock()
        self.DATA.BenchmarkLog.pairSpawnerActiveZones.Time.total =
            self.DATA.BenchmarkLog.pairSpawnerActiveZones.Time.stop -
            self.DATA.BenchmarkLog.pairSpawnerActiveZones.Time.start
        self.UTILS:debugInfo("BENCHMARK - - - AETHR.SPAWNER:pairSpawnerActiveZones completed in " ..
            tostring(self.DATA.BenchmarkLog.pairSpawnerActiveZones.Time.total) .. " seconds.")
    end
    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:pairSpawnerZoneDivisions(dynamicSpawner)
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.pairSpawnerZoneDivisions = { Time = {}, }
        self.DATA.BenchmarkLog.pairSpawnerZoneDivisions.Time.start = os.clock()
    end

    ---@type _spawnerZone
    local mainZone = dynamicSpawner.zones.main
    ---@type _spawnerZone[]
    local subZones = dynamicSpawner.zones.sub
    ---@type table<number, _WorldDivision>
    local spawnerActiveDivisions = dynamicSpawner.worldDivisions
    local mainZoneActiveDivisions = {}
    local mainZoneRadius = mainZone.actualRadius
    local mainZoneCenter = mainZone.center
    ---@param div _WorldDivision
    for _ID, div in pairs(spawnerActiveDivisions) do
        if self.POLY:circleOverlapPoly(mainZoneRadius, mainZoneCenter, div.corners) then
            mainZoneActiveDivisions[_ID] = div
        end
    end
    mainZone.worldDivisions = mainZoneActiveDivisions

    ---@param subZone _spawnerZone
    for _, subZone in pairs(subZones) do
        local subZoneActiveDivisions = {}
        local subZoneRadius = subZone.actualRadius
        local subZoneCenter = subZone.center
        ---@param div _WorldDivision
        for id, div in pairs(mainZoneActiveDivisions) do
            local divVerts = div.corners
            if self.POLY:circleOverlapPoly(subZoneRadius, subZoneCenter, divVerts) then
                subZoneActiveDivisions[id] = div
            end
        end
        subZone.worldDivisions = subZoneActiveDivisions
    end
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.pairSpawnerZoneDivisions.Time.stop = os.clock()
        self.DATA.BenchmarkLog.pairSpawnerZoneDivisions.Time.total =
            self.DATA.BenchmarkLog.pairSpawnerZoneDivisions.Time.stop -
            self.DATA.BenchmarkLog.pairSpawnerZoneDivisions.Time.start
        self.UTILS:debugInfo("BENCHMARK - - - AETHR.SPAWNER:pairSpawnerZoneDivisions completed in " ..
            tostring(self.DATA.BenchmarkLog.pairSpawnerZoneDivisions.Time.total) .. " seconds.")
    end
    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:determineZoneDivObjects(dynamicSpawner)
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.determineZoneDivObjects = { Time = {}, }
        self.DATA.BenchmarkLog.determineZoneDivObjects.Time.start = os.clock()
    end

    ---@type _spawnerZone[]
    local subZones = dynamicSpawner.zones.sub
    local sceneryObjectsDB = self.WORLD.DATA.divisionSceneryObjects -- Loaded scenery per division.
    local staticObjectsDB = self.WORLD.DATA.divisionStaticObjects   -- Loaded statics per division.
    local baseObjectsDB = self.WORLD.DATA.divisionBaseObjects       -- Loaded Base per division.

    -- initialize per-division AABB cache
    dynamicSpawner._cache.worldDivAABB = {} --dynamicSpawner._cache.worldDivAABB or {}
    local aabbCache = dynamicSpawner._cache.worldDivAABB

    -- configuration toggles (default: enabled unless explicitly false)
    local useAABB = (self.DATA.CONFIG.UseDivisionAABBReject ~= false)
    local useFullInclude = (self.DATA.CONFIG.UseDivisionAABBFullInclude ~= false)

    ---@param subZone _spawnerZone
    for _, subZone in ipairs(subZones) do
        local subZoneDivisions = subZone.worldDivisions
        local subZoneRadius = subZone.actualRadius
        local subZoneCenter = subZone.center

        local zoneDivSceneryObjects = {}
        local zoneDivStaticObjects = {}
        local zoneDivBaseObjects = {}

        -- fast-path: if no divisions, set empty lists and continue
        if not subZoneDivisions or next(subZoneDivisions) == nil then
            subZone.zoneDivSceneryObjects = zoneDivSceneryObjects
            subZone.zoneDivStaticObjects = zoneDivStaticObjects
            subZone.zoneDivBaseObjects = zoneDivBaseObjects
        else
            -- localize for performance
            local cx = subZoneCenter and subZoneCenter.x or 0
            local cy = subZoneCenter and subZoneCenter.y or 0
            local r = tonumber(subZoneRadius) or 0
            local r2 = r * r

            -- iterate each division once and test objects from all three DBs
            for divID, div in pairs(subZoneDivisions) do
                -- compute or retrieve cached AABB for division
                local aabb = aabbCache[divID]
                if not aabb and div and div.corners then
                    local minX, maxX = math.huge, -math.huge
                    local minZ, maxZ = math.huge, -math.huge
                    for _, c in ipairs(div.corners) do
                        if c.x < minX then minX = c.x end
                        if c.x > maxX then maxX = c.x end
                        if c.z < minZ then minZ = c.z end
                        if c.z > maxZ then maxZ = c.z end
                    end
                    aabb = { minX = minX, maxX = maxX, minZ = minZ, maxZ = maxZ }
                    aabbCache[divID] = aabb
                end

                local skip = false
                local fullInclude = false

                -- early reject: circle vs AABB distance test (safe)
                if useAABB and aabb then
                    local qx = cx
                    if qx < aabb.minX then qx = aabb.minX elseif qx > aabb.maxX then qx = aabb.maxX end
                    local qz = cy
                    if qz < aabb.minZ then qz = aabb.minZ elseif qz > aabb.maxZ then qz = aabb.maxZ end
                    local dx = qx - cx
                    local dz = qz - cy
                    if dx * dx + dz * dz > r2 then
                        skip = true
                    end
                end

                -- quick full-include check: if all four AABB corners are inside the circle, include entire division
                if (not skip) and useFullInclude and aabb then
                    local corners = {
                        { x = aabb.minX, z = aabb.minZ },
                        { x = aabb.maxX, z = aabb.minZ },
                        { x = aabb.maxX, z = aabb.maxZ },
                        { x = aabb.minX, z = aabb.maxZ },
                    }
                    local allInside = true
                    for i = 1, 4 do
                        local dx = corners[i].x - cx
                        local dz = corners[i].z - cy
                        if dx * dx + dz * dz > r2 then
                            allInside = false
                            break
                        end
                    end
                    fullInclude = allInside
                end

                if not skip then
                    if fullInclude then
                        -- append all objects from this division without per-object distance checks
                        local list = sceneryObjectsDB and sceneryObjectsDB[divID]
                        if list then
                            for _, obj in pairs(list) do zoneDivSceneryObjects[#zoneDivSceneryObjects + 1] = obj end
                        end
                        list = staticObjectsDB and staticObjectsDB[divID]
                        if list then
                            for _, obj in pairs(list) do zoneDivStaticObjects[#zoneDivStaticObjects + 1] = obj end
                        end
                        list = baseObjectsDB and baseObjectsDB[divID]
                        if list then
                            for _, obj in pairs(list) do zoneDivBaseObjects[#zoneDivBaseObjects + 1] = obj end
                        end
                    else
                        -- per-object checks (pairs-based to support non-array tables)
                        local list = sceneryObjectsDB and sceneryObjectsDB[divID]
                        if list then
                            for _, obj in pairs(list) do
                                local p = obj and obj.position
                                if p and p.x and p.z then
                                    local dx = p.x - cx
                                    local dz = p.z - cy
                                    if dx * dx + dz * dz <= r2 then
                                        zoneDivSceneryObjects[#zoneDivSceneryObjects + 1] = obj
                                    end
                                end
                            end
                        end

                        list = staticObjectsDB and staticObjectsDB[divID]
                        if list then
                            for _, obj in pairs(list) do
                                local p = obj and obj.position
                                if p and p.x and p.z then
                                    local dx = p.x - cx
                                    local dz = p.z - cy
                                    if dx * dx + dz * dz <= r2 then
                                        zoneDivStaticObjects[#zoneDivStaticObjects + 1] = obj
                                    end
                                end
                            end
                        end

                        list = baseObjectsDB and baseObjectsDB[divID]
                        if list then
                            for _, obj in pairs(list) do
                                local p = obj and obj.position
                                if p and p.x and p.z then
                                    local dx = p.x - cx
                                    local dz = p.z - cy
                                    if dx * dx + dz * dz <= r2 then
                                        zoneDivBaseObjects[#zoneDivBaseObjects + 1] = obj
                                    end
                                end
                            end
                        end
                    end
                end
            end

            subZone.zoneDivSceneryObjects = zoneDivSceneryObjects
            subZone.zoneDivStaticObjects = zoneDivStaticObjects
            subZone.zoneDivBaseObjects = zoneDivBaseObjects
        end
    end

    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.determineZoneDivObjects.Time.stop = os.clock()
        self.DATA.BenchmarkLog.determineZoneDivObjects.Time.total =
            self.DATA.BenchmarkLog.determineZoneDivObjects.Time.stop -
            self.DATA.BenchmarkLog.determineZoneDivObjects.Time.start
        self.UTILS:debugInfo("BENCHMARK - - - AETHR.SPAWNER:determineZoneDivObjects completed in " ..
            tostring(self.DATA.BenchmarkLog.determineZoneDivObjects.Time.total) .. " seconds.")
    end
    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:generateVec2GroupCenters(dynamicSpawner)
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.generateVec2GroupCenters = { Time = {}, Counters = {} }
        self.DATA.BenchmarkLog.generateVec2GroupCenters.Time.start = os.clock()
    end

    local groupsDB = self.WORLD.DATA.groundGroupsDB -- Loaded units per division (not used directly for positions)
    ---@type _spawnerZone[]
    local subZones = dynamicSpawner.zones.sub

    -- Local helpers (fast, local scope)
    local function extractXY(obj)
        if not obj then return nil end
        if obj.x and obj.y then return { x = obj.x, y = obj.y } end
        if obj.position and obj.position.x and (obj.position.z or obj.position.y) then
            return { x = obj.position.x, y = (obj.position.z or obj.position.y) }
        end
        if obj.postition and obj.postition.x and (obj.postition.z or obj.postition.y) then
            return { x = obj.postition.x, y = (obj.postition.z or obj.postition.y) }
        end
        -- support nested fields like obj.getPoint result
        if obj.getPoint and type(obj.getPoint) == "function" then
            local p = obj:getPoint()
            if p and p.x and (p.y or p.z) then return { x = p.x, y = (p.z or p.y) } end
        end
        return nil
    end

    local function toCell(x, y, s)
        local cx = math.floor(x / s)
        local cy = math.floor(y / s)
        return cx, cy
    end

    local function cellKey(cx, cy)
        return tostring(cx) .. ":" .. tostring(cy)
    end

    local function gridInsert(grid, s, x, y)
        local cx, cy = toCell(x, y, s)
        local key = cellKey(cx, cy)
        grid[key] = grid[key] or {}
        table.insert(grid[key], { x = x, y = y })
    end

    local function gridQuery(grid, s, x, y, r2, neighborRange)
        -- neighborRange is number of cells to check in each direction
        local cx, cy = toCell(x, y, s)
        local r = neighborRange or math.ceil(math.sqrt(r2) / s)
        for dx = -r, r do
            for dy = -r, r do
                local key = cellKey(cx + dx, cy + dy)
                local cell = grid[key]
                if cell then
                    for _, pt in ipairs(cell) do
                        local dx_ = pt.x - x
                        local dy_ = pt.y - y
                        if dx_ * dx_ + dy_ * dy_ <= r2 then
                            return true
                        end
                    end
                end
            end
        end
        return false
    end

    -- Process each subZone
    for _, subZone in pairs(subZones) do
        local subZoneRadius = subZone.actualRadius
        local subZoneCenter = subZone.center
        local baseObjects = subZone.zoneDivBaseObjects or {}
        local staticObjects = subZone.zoneDivStaticObjects or {}
        local sceneryObjects = subZone.zoneDivSceneryObjects or {}
        local freshScannedUnits = self.WORLD:searchObjectsSphere(self.ENUMS.ObjectCategory.UNIT, subZoneCenter,
            subZoneRadius) or {}

        -- Compute a sensible cell size from group settings for this subZone
        local cellSize = 1
        do
            local minSep = math.huge
            for _, gs in pairs(subZone.groupSettings or {}) do
                if gs and gs.minGroups and gs.minBuildings then
                    minSep = math.min(minSep, math.min(gs.minGroups, gs.minBuildings))
                elseif gs and gs.minGroups then
                    minSep = math.min(minSep, gs.minGroups)
                elseif gs and gs.minBuildings then
                    minSep = math.min(minSep, gs.minBuildings)
                end
            end
            if minSep == math.huge or not minSep then
                cellSize = 1
            else
                cellSize = math.max(1, math.floor(minSep))
            end
        end

        -- Build grids: structuresGrid (bases/statics/scenery), groupsGrid (nearby units), centersGrid (accepted centers)
        local structuresGrid = {}
        local groupsGrid = {}
        local centersGrid = {}

        -- Helper to populate a list of objects into a grid using extractXY
        local function populateGridFromList(list, grid, s)
            for _, obj in pairs(list or {}) do
                local p = extractXY(obj)
                if p then gridInsert(grid, s, p.x, p.y) end
            end
        end

        -- Populate structuresGrid from base/static/scenery objects
        populateGridFromList(baseObjects, structuresGrid, cellSize)
        populateGridFromList(staticObjects, structuresGrid, cellSize)
        populateGridFromList(sceneryObjects, structuresGrid, cellSize)

        -- Populate groupsGrid from freshScannedUnits and db (pairs because returned table is a map)
        for _, obj in pairs(freshScannedUnits or {}) do
            local p = extractXY(obj)
            if p then gridInsert(groupsGrid, cellSize, p.x, p.y) end
        end
        for _, obj in pairs(groupsDB or {}) do
            local p = extractXY(obj)
            if p then gridInsert(groupsGrid, cellSize, p.x, p.y) end
        end

        -- selectedCoords kept for compatibility (not used for linear scans anymore)
        local selectedCoords = {}

        -- For each groupSetting, place group centers
        for _, groupSetting in pairs(subZone.groupSettings or {}) do
            local groupCenterVec2s = {}
            local minGroups = groupSetting.minGroups or self.DATA.CONFIG.seperationSettings.minGroups or 30
            local minBuildings = groupSetting.minBuildings or self.DATA.CONFIG.seperationSettings.minBuildings or 20
            local mg2 = (minGroups) * (minGroups)
            local mb2 = (minBuildings) * (minBuildings)
            local neighborRangeGroups = math.ceil(minGroups / cellSize)
            local neighborRangeBuildings = math.ceil(minBuildings / cellSize)

            for i = 1, (groupSetting.numGroups or 0) do
                local glassBreak = 0
                local possibleVec2 = nil
                local accepted = false
                local operationLimit = self.DATA.CONFIG.operationLimit or 100

                repeat
                    possibleVec2 = self.POLY:getRandomVec2inCircle(subZoneRadius, subZoneCenter)


                    -- Fast proximity checks using grids (squared distances)
                    local reject = false

                    -- Check against already accepted centers
                    if next(centersGrid) ~= nil then
                        if gridQuery(centersGrid, cellSize, possibleVec2.x, possibleVec2.y, mg2, neighborRangeGroups) then
                            reject = true
                        end
                    end

                    -- Check against nearby units/groups
                    if not reject and next(groupsGrid) ~= nil then
                        if gridQuery(groupsGrid, cellSize, possibleVec2.x, possibleVec2.y, mg2, neighborRangeGroups) then
                            reject = true
                        end
                    end

                    -- Check against nearby structures
                    if not reject and next(structuresGrid) ~= nil then
                        if gridQuery(structuresGrid, cellSize, possibleVec2.x, possibleVec2.y, mb2, neighborRangeBuildings) then
                            reject = true
                        end
                    end

                    -- Only if we passed all cheap spatial checks, call expensive NOGO check
                    if not reject then
                        reject = self:checkIsInNOGO(possibleVec2, dynamicSpawner.zones.restricted)
                    end

                    if not reject then
                        accepted = true
                    else
                        accepted = false
                    end

                    if glassBreak >= operationLimit then
                        -- Respect existing behavior: accept last candidate when budget exhausts
                        accepted = true
                    end

                    glassBreak = glassBreak + 1
                until accepted

                -- Accept candidate
                groupCenterVec2s[i] = possibleVec2
                table.insert(selectedCoords, possibleVec2)
                gridInsert(centersGrid, cellSize, possibleVec2.x, possibleVec2.y)
            end

            groupSetting.generatedGroupCenterVec2s = groupCenterVec2s
        end
    end

    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.generateVec2GroupCenters.Time.stop = os.clock()
        self.DATA.BenchmarkLog.generateVec2GroupCenters.Time.total =
            self.DATA.BenchmarkLog.generateVec2GroupCenters.Time.stop -
            self.DATA.BenchmarkLog.generateVec2GroupCenters.Time.start
        self.UTILS:debugInfo("BENCHMARK - - - AETHR.SPAWNER:generateVec2GroupCenters completed in " ..
            tostring(self.DATA.BenchmarkLog.generateVec2GroupCenters.Time.total) .. " seconds.")
    end
    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:generateVec2UnitPos(dynamicSpawner)
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.generateVec2UnitPos = { Time = {}, }
        self.DATA.BenchmarkLog.generateVec2UnitPos.Time.start = os.clock()
    end



    local unitsDB = self.WORLD.DATA.groundUnitsDB -- Loaded units per division (not used directly for positions)
    ---@type _spawnerZone[]
    local subZones = dynamicSpawner.zones.sub

    -- Local helpers (fast, local scope)
    local function extractXY(obj)
        if not obj then return nil end
        if obj.x and obj.y then return { x = obj.x, y = obj.y } end
        if obj.position and obj.position.x and (obj.position.z or obj.position.y) then
            return { x = obj.position.x, y = (obj.position.z or obj.position.y) }
        end
        if obj.postition and obj.postition.x and (obj.postition.z or obj.postition.y) then
            return { x = obj.postition.x, y = (obj.postition.z or obj.postition.y) }
        end
        -- support nested fields like obj.getPoint result
        if obj.getPoint and type(obj.getPoint) == "function" then
            local p = obj:getPoint()
            if p and p.x and (p.y or p.z) then return { x = p.x, y = (p.z or p.y) } end
        end
        return nil
    end

    local function toCell(x, y, s)
        local cx = math.floor(x / s)
        local cy = math.floor(y / s)
        return cx, cy
    end

    local function cellKey(cx, cy)
        return tostring(cx) .. ":" .. tostring(cy)
    end

    local function gridInsert(grid, s, x, y)
        local cx, cy = toCell(x, y, s)
        local key = cellKey(cx, cy)
        grid[key] = grid[key] or {}
        table.insert(grid[key], { x = x, y = y })
    end

    local function gridQuery(grid, s, x, y, r2, neighborRange)
        -- neighborRange is number of cells to check in each direction
        local cx, cy = toCell(x, y, s)
        local r = neighborRange or math.ceil(math.sqrt(r2) / s)
        for dx = -r, r do
            for dy = -r, r do
                local key = cellKey(cx + dx, cy + dy)
                local cell = grid[key]
                if cell then
                    for _, pt in ipairs(cell) do
                        local dx_ = pt.x - x
                        local dy_ = pt.y - y
                        if dx_ * dx_ + dy_ * dy_ <= r2 then
                            return true
                        end
                    end
                end
            end
        end
        return false
    end

    -- Process each subZone
    for _, subZone in pairs(subZones) do
        local subZoneRadius = subZone.actualRadius
        local subZoneCenter = subZone.center
        local baseObjects = subZone.zoneDivBaseObjects or {}
        local staticObjects = subZone.zoneDivStaticObjects or {}
        local sceneryObjects = subZone.zoneDivSceneryObjects or {}
        local freshScannedUnits = self.WORLD:searchObjectsSphere(self.ENUMS.ObjectCategory.UNIT, subZoneCenter,
            subZoneRadius) or {}

        -- Compute a sensible cell size from group settings for this subZone
        local cellSize = 1
        do
            local minSep = math.huge
            for _, gs in pairs(subZone.groupSettings or {}) do
                if gs and gs.minGroups and gs.minBuildings and gs.minUnits then
                    minSep = math.min(minSep, gs.minGroups, gs.minBuildings, gs.minUnits)
                elseif gs and gs.minGroups then
                    minSep = math.min(minSep, gs.minGroups)
                elseif gs and gs.minBuildings then
                    minSep = math.min(minSep, gs.minBuildings)
                elseif gs and gs.minUnits then
                    minSep = math.min(minSep, gs.minUnits)
                end
            end
            if minSep == math.huge or not minSep then
                cellSize = 1
            else
                cellSize = math.max(1, math.floor(minSep))
            end
        end

        -- Build grids: structuresGrid (bases/statics/scenery), groupsGrid (nearby units), centersGrid (accepted centers)
        local structuresGrid = {}
        local groupsGrid = {}
        local centersGrid = {}

        -- Helper to populate a list of objects into a grid using extractXY
        local function populateGridFromList(list, grid, s)
            for _, obj in pairs(list or {}) do
                local p = extractXY(obj)
                if p then gridInsert(grid, s, p.x, p.y) end
            end
        end

        -- Populate structuresGrid from base/static/scenery objects
        populateGridFromList(baseObjects, structuresGrid, cellSize)
        populateGridFromList(staticObjects, structuresGrid, cellSize)
        populateGridFromList(sceneryObjects, structuresGrid, cellSize)

        -- Populate groupsGrid from freshScannedUnits and global db (pairs because returned table is a map)
        for _, obj in pairs(freshScannedUnits or {}) do
            local p = extractXY(obj)
            if p then gridInsert(groupsGrid, cellSize, p.x, p.y) end
        end
        for _, obj in pairs(unitsDB or {}) do
            local p = extractXY(obj)
            if p then gridInsert(groupsGrid, cellSize, p.x, p.y) end
        end

        -- selectedCoords kept for compatibility (not used for linear scans anymore)
        local selectedCoords = {}

        -- For each groupSetting, place group centers
        for _, groupSetting in pairs(subZone.groupSettings or {}) do
            local groupUnitVec2s = {}
            local minUnits = groupSetting.minUnits or self.DATA.CONFIG.seperationSettings.minUnits or 10
            local maxUnits = groupSetting.maxUnits or self.DATA.CONFIG.seperationSettings.maxUnits or 20
            local maxGroups = groupSetting.maxGroups or self.DATA.CONFIG.seperationSettings.maxGroups or 30
            local minBuildings = groupSetting.minBuildings or self.DATA.CONFIG.seperationSettings.minBuildings or 20
            local mg2 = (minUnits) * (minUnits)
            local mb2 = (minBuildings) * (minBuildings)
            local neighborRangeGroups = math.ceil(minUnits / cellSize)
            local neighborRangeBuildings = math.ceil(minBuildings / cellSize)

            for i = 1, (groupSetting.numGroups or 0) do
                local unitVec2 = {}
                local unitTypesForGroup = (groupSetting.generatedGroupUnitTypes and groupSetting.generatedGroupUnitTypes[i]) or
                    {}
                for j = 1, #unitTypesForGroup do
                    local glassBreak = 0
                    local possibleVec2 = nil
                    local accepted = false
                    local operationLimit = self.DATA.CONFIG.operationLimit or 100
                    repeat
                        possibleVec2 = self.POLY:getRandomVec2inCircle(maxGroups,
                            groupSetting.generatedGroupCenterVec2s[i] or subZoneCenter)


                        -- Fast proximity checks using grids (squared distances)
                        local reject = false

                        -- Check against already accepted centers
                        if next(centersGrid) ~= nil then
                            if gridQuery(centersGrid, cellSize, possibleVec2.x, possibleVec2.y, mg2, neighborRangeGroups) then
                                reject = true
                            end
                        end

                        -- Check against nearby units/groups
                        if not reject and next(groupsGrid) ~= nil then
                            if gridQuery(groupsGrid, cellSize, possibleVec2.x, possibleVec2.y, mg2, neighborRangeGroups) then
                                reject = true
                            end
                        end

                        -- Check against nearby structures
                        if not reject and next(structuresGrid) ~= nil then
                            if gridQuery(structuresGrid, cellSize, possibleVec2.x, possibleVec2.y, mb2, neighborRangeBuildings) then
                                reject = true
                            end
                        end

                        -- Only if we passed all cheap spatial checks, call expensive NOGO check
                        if not reject then
                            reject = self:checkIsInNOGO(possibleVec2, dynamicSpawner.zones.restricted)
                        end

                        if not reject then
                            accepted = true
                        else
                            accepted = false
                        end

                        if glassBreak >= operationLimit then
                            -- Respect existing behavior: accept last candidate when budget exhausts
                            accepted = true
                        end

                        glassBreak = glassBreak + 1
                    until accepted

                    -- Accept candidate
                    unitVec2[j] = possibleVec2
                    table.insert(selectedCoords, possibleVec2)
                    gridInsert(centersGrid, cellSize, possibleVec2.x, possibleVec2.y)
                end
                groupUnitVec2s[i] = unitVec2
            end
            groupSetting.generatedUnitVec2s = groupUnitVec2s
        end
    end
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.generateVec2UnitPos.Time.stop = os.clock()
        self.DATA.BenchmarkLog.generateVec2UnitPos.Time.total =
            self.DATA.BenchmarkLog.generateVec2UnitPos.Time.stop -
            self.DATA.BenchmarkLog.generateVec2UnitPos.Time.start
        self.UTILS:debugInfo("BENCHMARK - - - AETHR.SPAWNER:generateVec2UnitPos completed in " ..
            tostring(self.DATA.BenchmarkLog.generateVec2UnitPos.Time.total) .. " seconds.")
    end
    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:rollSpawnGroups(dynamicSpawner)
    self:seedTypes(dynamicSpawner)
    self:generateGroupTypes(dynamicSpawner)
    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:generateGroupTypes(dynamicSpawner)
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.generateGroupTypes = { Time = {}, }
        self.DATA.BenchmarkLog.generateGroupTypes.Time.start = os.clock()
    end

    ---@type _spawnerZone[]
    local subZones = dynamicSpawner.zones.sub
    local spawnTypes = dynamicSpawner.spawnTypes
    local typesPool = dynamicSpawner._typesPool
    local nonLimitedTypesPool = dynamicSpawner._nonLimitedTypesPool
    local extraTypes = dynamicSpawner.extraTypes
    ---@param zoneObject _spawnerZone
    for _, zoneObject in ipairs(subZones) do
        -- Loop through each group setting.
        ---@param groupSizeConfig _spawnerTypeConfig
        for groupSize, groupSizeConfig in ipairs(zoneObject.groupSettings) do
            local _groupTypes = {}
            local _specificGroupTypes = {}
            -- Loop for the number of groups specified in the current setting.
            for _ = 1, groupSizeConfig.numGroups do
                -- List to store types for this group.
                local _UnitTypes = {}
                local _specificUnitTypes = {}
                -- Loop for the size of the group + extra units.
                for _Unit = 1, groupSizeConfig.size do
                    local typeToAdd -- Variable to store the type to add for this iteration.
                    local _TypeK

                    -- -- Pick a random type.
                    if self.UTILS.sumTable(typesPool) > 0 then
                        _TypeK = self.UTILS:pickRandomKeyFromTable(typesPool)
                    else
                        _TypeK = self.UTILS:pickRandomKeyFromTable(nonLimitedTypesPool)
                    end

                    local randType = spawnTypes[_TypeK]
                    -- Increment the number used count for this type.
                    randType.actual = randType.actual + 1

                    if (randType.actual >= randType.max) then
                        typesPool[_TypeK] = nil
                    end
                    typeToAdd = _TypeK
                    -- Add the selected type to the group types list, all types list, and the main AllTypes list.
                    table.insert(_UnitTypes, typeToAdd)
                    table.insert(_specificUnitTypes, self.UTILS:pickRandomKeyFromTable(spawnTypes[typeToAdd].typesDB))
                end

                for extraType, extraTypeInfo in pairs(extraTypes) do
                    for _i = 1, extraTypeInfo.min, 1 do
                        --local _TypeK = self.UTILS:pickRandomKeyFromTable(extraTypeInfo.typesDB)
                        table.insert(_UnitTypes, extraType)
                        table.insert(_specificUnitTypes, self.UTILS:pickRandomKeyFromTable(extraTypeInfo.typesDB))
                    end
                end
                if _UnitTypes and #_UnitTypes > 0 then
                    table.insert(_groupTypes, _UnitTypes)
                    table.insert(_specificGroupTypes, _specificUnitTypes)
                end
            end
            -- Add the group types list to the main group list for this iteration.
            if _groupTypes and #_groupTypes > 0 then
                groupSizeConfig.generatedGroupTypes = _groupTypes --[#groupSizeConfig.generatedGroupTypes + 1]
                groupSizeConfig.generatedGroupUnitTypes = _specificGroupTypes
            end
        end
    end
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.generateGroupTypes.Time.stop = os.clock()
        self.DATA.BenchmarkLog.generateGroupTypes.Time.total =
            self.DATA.BenchmarkLog.generateGroupTypes.Time.stop -
            self.DATA.BenchmarkLog.generateGroupTypes.Time.start
        self.UTILS:debugInfo("BENCHMARK - - - AETHR.SPAWNER:generateGroupTypes completed in " ..
            tostring(self.DATA.BenchmarkLog.generateGroupTypes.Time.total) .. " seconds.")
    end
    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:seedTypes(dynamicSpawner)
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.seedTypes = { Time = {}, }
        self.DATA.BenchmarkLog.seedTypes.Time.start = os.clock()
    end
    local typesPool = dynamicSpawner._typesPool
    local spawnTypes = dynamicSpawner.spawnTypes
    local extraTypes = dynamicSpawner.extraTypes
    local spawnerAttributesDB = self.WORLD.DATA.spawnerAttributesDB
    ---@param typeName string
    ---@param typeData _spawnerTypeConfig
    for typeName, typeData in pairs(spawnTypes) do
        typeData.typesDB = spawnerAttributesDB[typeName] or {}
        typesPool[typeName] = typeName
    end
    ---@param typeName string
    ---@param typeData _spawnerTypeConfig
    for typeName, typeData in pairs(extraTypes) do
        typeData.typesDB = spawnerAttributesDB[typeName] or {}
    end

    for k, v in pairs(typesPool) do
        local _type = spawnTypes[k]
        if _type.limited then
            dynamicSpawner._limitedTypesPool[k] = k
        else
            dynamicSpawner._nonLimitedTypesPool[k] = k
        end
    end
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.seedTypes.Time.stop = os.clock()
        self.DATA.BenchmarkLog.seedTypes.Time.total =
            self.DATA.BenchmarkLog.seedTypes.Time.stop -
            self.DATA.BenchmarkLog.seedTypes.Time.start
        self.UTILS:debugInfo("BENCHMARK - - - AETHR.SPAWNER:seedTypes completed in " ..
            tostring(self.DATA.BenchmarkLog.seedTypes.Time.total) .. " seconds.")
    end
    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:rollSpawnGroupSizes(dynamicSpawner)
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.rollSpawnGroupSizes = { Time = {}, }
        self.DATA.BenchmarkLog.rollSpawnGroupSizes.Time.start = os.clock()
    end

    ---@type _spawnerZone[]
    local subZones = dynamicSpawner.zones.sub
    ---@param zoneObject_ _spawnerZone
    for zoneName_, zoneObject_ in pairs(subZones) do
        local groupSizes_ = zoneObject_.groupSizesPrio
        local SpacingSettings_ = zoneObject_.groupSpacingSettings
        ---@type _spawnSettings
        local spawnSettingsGeneratedZO = zoneObject_.spawnSettings.generated
        local numTypesZone = spawnSettingsGeneratedZO.actual
        for i = 1, #groupSizes_ do
            local size = groupSizes_[i]
            local numGroupSize = math.floor(numTypesZone / size)
            if numGroupSize > 0 then
                numTypesZone = numTypesZone - (numGroupSize * size)
                --local index_ = self.UTILS.sumTable(zoneObject_.groupSettings) + 1
                zoneObject_.groupSettings[size].size =
                    size --= self:_createGroupSettings(size, numGroupSize, SpacingSettings_)
                zoneObject_.groupSettings[size].numGroups = numGroupSize
            end
        end
    end
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.rollSpawnGroupSizes.Time.stop = os.clock()
        self.DATA.BenchmarkLog.rollSpawnGroupSizes.Time.total =
            self.DATA.BenchmarkLog.rollSpawnGroupSizes.Time.stop -
            self.DATA.BenchmarkLog.rollSpawnGroupSizes.Time.start
        self.UTILS:debugInfo("BENCHMARK - - - AETHR.SPAWNER:rollSpawnGroupSizes completed in " ..
            tostring(self.DATA.BenchmarkLog.rollSpawnGroupSizes.Time.total) .. " seconds.")
    end
    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:generateSpawnAmounts(dynamicSpawner)
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.generateSpawnAmounts = { Time = {}, }
        self.DATA.BenchmarkLog.generateSpawnAmounts.Time.start = os.clock()
    end
    ---@type _spawnerZone
    local mainZone = dynamicSpawner.zones.main
    ---@type _spawnSettings
    local spawnSettingsMainBase = mainZone.spawnSettings.base
    spawnSettingsMainBase.nominal = dynamicSpawner.spawnAmountNominal
    spawnSettingsMainBase.min = dynamicSpawner.spawnAmountMin
    spawnSettingsMainBase.max = dynamicSpawner.spawnAmountMax
    spawnSettingsMainBase.nudgeFactor = dynamicSpawner.spawnAmountNudgeFactor
    ---@type _spawnerZone[]
    local subZones = dynamicSpawner.zones.sub
    local numSubZones = dynamicSpawner.numSubZones
    mainZone:setSpawnAmounts():rollSpawnAmounts()
    ---@type _spawnSettings
    local spawnSettingsMainGenerated = mainZone.spawnSettings.generated


    -- Calculate spawn configurations for subzones
    local avgDistribution = spawnSettingsMainGenerated.actual / numSubZones
    dynamicSpawner.averageDistribution = avgDistribution

    local spawnsMax = math.min(
        avgDistribution + avgDistribution * spawnSettingsMainGenerated.ratioMax,
        spawnSettingsMainGenerated.max / numSubZones)
    local spawnsMin = math.max(
        avgDistribution - avgDistribution * spawnSettingsMainGenerated.ratioMin,
        spawnSettingsMainGenerated.min / numSubZones)

    -- Set spawn amounts for each subzone
    ---@param zoneObject_ _spawnerZone
    for _, zoneObject_ in pairs(subZones) do
        ---@type _spawnSettings
        local spawnSettingsZO = zoneObject_.spawnSettings.base
        spawnSettingsZO.nominal = avgDistribution
        spawnSettingsZO.min = spawnsMin
        spawnSettingsZO.max = spawnsMax
        spawnSettingsZO.nudgeFactor = self.MATH:generateNudge(spawnSettingsMainGenerated.nudgeFactor)
        zoneObject_:setSpawnAmounts():rollSpawnAmounts()
    end
    self:_Jiggle(dynamicSpawner)
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.generateSpawnAmounts.Time.stop = os.clock()
        self.DATA.BenchmarkLog.generateSpawnAmounts.Time.total =
            self.DATA.BenchmarkLog.generateSpawnAmounts.Time.stop -
            self.DATA.BenchmarkLog.generateSpawnAmounts.Time.start
        self.UTILS:debugInfo("BENCHMARK - - - AETHR.SPAWNER:generateSpawnAmounts completed in " ..
            tostring(self.DATA.BenchmarkLog.generateSpawnAmounts.Time.total) .. " seconds.")
    end
    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:_Jiggle(dynamicSpawner)
    ---@type _spawnerZone
    local mainZone = dynamicSpawner.zones.main
    ---@type _spawnSettings
    local spawnSettingsMainGenerated = mainZone.spawnSettings.generated

    for _ = 1, spawnSettingsMainGenerated.nudgeReciprocal do
        self:_RollUpdates(dynamicSpawner)
    end
    return self
end

--- Execute a sequence of updates on the _dynamicSpawner object.
--
-- This function orchestrates a series of method calls to update the `_dynamicSpawner` object.
-- It sequentially executes the following methods:
-- 1. `_seedRollUpdates` - Initiates updates based on seed rolls.
-- 2. `_introduceRandomness` - Injects randomness into the spawning process.
-- 3. `_distributeDifference` - Balances spawn distribution across subzones.
-- 4. `_assignAndUpdateSubZones` - Assigns spawns and updates subzone details.
-- This method chain is crucial for maintaining the operational integrity and dynamic behavior of the spawner.
--
---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:_RollUpdates(dynamicSpawner)
    dynamicSpawner:_seedRollUpdates():_introduceRandomness():_distributeDifference():_assignAndUpdateSubZones()
    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:generateSpawnerZones(dynamicSpawner)
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.generateSpawnerZones = { Time = {}, }
        self.DATA.BenchmarkLog.generateSpawnerZones.Time.start = os.clock()
    end
    -- if self.CONFIG.MAIN.DEBUG_ENABLED then
    --     self.MARKERS:removeMarksByID(self.DATA.debugMarkers)
    --     self.DATA.debugMarkers = {}
    -- end


    local subZones = dynamicSpawner.zones.sub
    dynamicSpawner.zones.main = self.AETHR._spawnerZone:New(self.AETHR, dynamicSpawner)
    local mainZone = dynamicSpawner.zones.main
    local mainZoneCenter = mainZone.center
    local mainZoneRadius = mainZone.actualRadius

    -- if self.CONFIG.MAIN.DEBUG_ENABLED then
    --     self.MARKERS:drawGenericCircle(mainZoneCenter, mainZoneRadius, self.DATA.debugMarkers)
    -- end

    local numSubZones = dynamicSpawner.numSubZones
    local subZoneMinRadius = (mainZoneRadius / numSubZones) --/ 2
    local overlapFactor = dynamicSpawner.subZoneOverlapFactor or 0.75
    local restrictedZones = dynamicSpawner.zones.restricted or {}
    local checkNOGO = true

    local generatedSubZones = self.POLY:generateSubCircles(numSubZones, subZoneMinRadius, mainZoneCenter,
        mainZoneRadius, overlapFactor, checkNOGO, restrictedZones)

    -- if self.CONFIG.MAIN.DEBUG_ENABLED then
    --     for _, subZone in ipairs(generatedSubZones) do
    --         self.MARKERS:drawGenericCircle(subZone.center, subZone.radius, self.DATA.debugMarkers)
    --     end
    -- end

    --- @param subZone _circle
    for _, subZone in ipairs(generatedSubZones) do
        local _subZone = self.AETHR._spawnerZone:New(self.AETHR, dynamicSpawner)
        _subZone.center = subZone.center
        _subZone.actualRadius = subZone.radius
        _subZone.area = subZone.area
        _subZone.diameter = subZone.diameter
        subZones[#subZones + 1] = _subZone
    end
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.generateSpawnerZones.Time.stop = os.clock()
        self.DATA.BenchmarkLog.generateSpawnerZones.Time.total =
            self.DATA.BenchmarkLog.generateSpawnerZones.Time.stop -
            self.DATA.BenchmarkLog.generateSpawnerZones.Time.start
        self.UTILS:debugInfo("BENCHMARK - - - AETHR.SPAWNER:generateSpawnerZones completed in " ..
            tostring(self.DATA.BenchmarkLog.generateSpawnerZones.Time.total) .. " seconds.")
    end
    return self
end

--- Check if a vector position is within a no-go area.
---
--- This function determines whether a given vector position (`vec2`) falls within any restricted
--- areas or surfaces defined in the SPAWNER system. It first checks against no-go surfaces and then against
--- restricted zones. The function returns a flag indicating whether the position is suitable (not within
--- no-go areas) for spawning purposes.
---
--- @param vec2 _vec2 The vector position to be checked.
--- @param restrictedZones table A list of restricted zones to check against.
--- @return boolean isNOGO A boolean flag indicating if the position is outside no-go areas (true if unsuitable, false otherwise).
function AETHR.SPAWNER:checkIsInNOGO(vec2, restrictedZones)
    local isNOGO = false
    if self:vec2AtNoGoSurface(vec2) then isNOGO = true end
    -- if not isNOGO then
    --     if self:Vec2inZones(vec2, restrictedZones) then
    --         isNOGO = true
    --     end
    -- end
    return isNOGO
end

--- Check if a given vector position is on a no-go surface.
---
--- This function evaluates the surface type at a specified vector position (`vec2`) and determines whether
--- it matches any of the defined no-go surface types in the SPAWNER. If the surface type at the vector position
--- is listed as a no-go surface, the function returns true, indicating that the location is unsuitable for certain
--- operations like spawning. This check is crucial for ensuring that activities such as spawning occur only in
--- appropriate areas.
---
--- @param vec2 _vec2 The vector position to be checked.
--- @return boolean true if the vector position is on a no-go surface, false otherwise.
function AETHR.SPAWNER:vec2AtNoGoSurface(vec2)
    local surfaceType = land.getSurfaceType(vec2)
    for _, noGoSurface in ipairs(self.DATA.CONFIG.NoGoSurfaces) do
        if noGoSurface == surfaceType then
            return true
        end
    end
    return false
end

--- Calculate and assign weight to the main zone and its subzones.
---
--- This function is responsible for computing and assigning weights to both the main zone and its subzones
--- within the SPAWNER system. The weight of each subzone is calculated based on its area relative to the main zone's area.
--- After determining the weights for all subzones, the main zone's weight is adjusted accordingly to ensure
--- that the total of all weights equals 1. This ensures a balanced distribution of importance or influence among
--- the zones.
---
--- @param dynamicSpawner _dynamicSpawner The dynamic spawner instance containing the zones to be weighted.
--- @return self
function AETHR.SPAWNER:weightZones(dynamicSpawner)
    local mainZone = dynamicSpawner.zones.main
    local subZones = dynamicSpawner.zones.sub
    local totalWeight = 0

    -- Calculate weights for each subzone
    ---@param zoneObject_ _spawnerZone
    for _, zoneObject_ in pairs(subZones) do
        zoneObject_.weight = zoneObject_.area / mainZone.area
        totalWeight = totalWeight + zoneObject_.weight
    end

    -- Adjust main zone's weight
    mainZone.weight = 1 - totalWeight

    return self
end
