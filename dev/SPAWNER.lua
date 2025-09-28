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

--- @class AETHR.SPAWNER.DATA.dynamicSpawners
--- @field dynamicSpawners.Airbase table<string, _dynamicSpawner> Dynamic spawners of type "Airbase" keyed by name.
--- @field dynamicSpawners.Zone table<string, _dynamicSpawner> Dynamic spawners of type "Zone" keyed by name.
--- @field dynamicSpawners.Point table<string, _dynamicSpawner> Dynamic spawners of type "Point" keyed by name.

--- @class AETHR.SPAWNER.DATA.CONFIG
--- @field operationLimit number Maximum number of spawn/despawn operations to process per WORLD cycle (

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
    CONFIG = {
        operationLimit = 50,
        NoGoSurfaces = {
            AETHR.ENUMS.SurfaceType.WATER,
            AETHR.ENUMS.SurfaceType.RUNWAY,
            AETHR.ENUMS.SurfaceType.SHALLOW_WATER
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
--- @param heading number|nil Heading in degrees. Defaults to 0 if nil.
--- @param playerCanDrive boolean|nil If true, players can drive this unit. Defaults to true if nil.
--- @param randomTransportable boolean|nil If true, unit is randomly transportable by helicopters. Defaults to false if nil.
--- @return string groundUnitName Unique name of the created ground unit (key in DATA.generatedUnits).
function AETHR.SPAWNER:buildGroundUnit(type, x, y, skill, name, heading, playerCanDrive, randomTransportable)
    skill = skill or nil
    heading = heading or nil
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

    coalition.addGroup(countryID, Group.Category.GROUND, groundGroup)

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
--- @return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:spawnGroup(groupName)
    local _group = self.DATA.generatedGroups[groupName]
    coalition.addGroup(_group.countryID, Group.Category.GROUND, _group)
    table.insert(self.DATA.spawnQueue, groupName)
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
function AETHR.SPAWNER:generateDynamicSpawner(dynamicSpawner, vec2, minRadius, nominalRadius, maxRadius,
                                              nudgeFactorRadius)
    dynamicSpawner.minRadius = minRadius or dynamicSpawner.minRadius
    dynamicSpawner.nominalRadius = nominalRadius or dynamicSpawner.nominalRadius
    dynamicSpawner.maxRadius = maxRadius or dynamicSpawner.maxRadius
    dynamicSpawner.nudgeFactorRadius = nudgeFactorRadius or dynamicSpawner.nudgeFactorRadius
    dynamicSpawner.vec2 = vec2
    self:generateSpawnerZones(dynamicSpawner)
    self:weightZones(dynamicSpawner)
    self:generateSpawnAmounts(dynamicSpawner)

    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:generateSpawnAmounts(dynamicSpawner)
    ---@type _spawnerZone
    local mainZone = dynamicSpawner.zones.main
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
    if self.CONFIG.MAIN.DEBUG_ENABLED then
        self.MARKERS:removeMarksByID(self.DATA.debugMarkers)
        self.DATA.debugMarkers = {}
    end

    local mainZone = dynamicSpawner.zones.main
    local subZones = dynamicSpawner.zones.sub
    mainZone = self.AETHR._spawnerZone:New(self.AETHR, dynamicSpawner)

    local mainZoneCenter = mainZone.center
    local mainZoneRadius = mainZone.actualRadius

    if self.CONFIG.MAIN.DEBUG_ENABLED then
        self.MARKERS:drawGenericCircle(mainZoneCenter, mainZoneRadius, self.DATA.debugMarkers)
    end

    local numSubZones = dynamicSpawner.numSubZones
    local subZoneMinRadius = (mainZoneRadius / numSubZones) --/ 2
    local overlapFactor = dynamicSpawner.subZoneOverlapFactor or 0.75
    local restrictedZones = dynamicSpawner.zones.restricted or {}
    local checkNOGO = true

    local generatedSubZones = self.POLY:generateSubCircles(numSubZones, subZoneMinRadius, mainZoneCenter,
        mainZoneRadius, overlapFactor, checkNOGO, restrictedZones)

    if self.CONFIG.MAIN.DEBUG_ENABLED then
        for _, subZone in ipairs(generatedSubZones) do
            self.MARKERS:drawGenericCircle(subZone.center, subZone.radius, self.DATA.debugMarkers)
        end
    end

    --- @param subZone _circle
    for _, subZone in ipairs(generatedSubZones) do
        local _subZone = self.AETHR._spawnerZone:New(self.AETHR, dynamicSpawner)
        _subZone.center = subZone.center
        _subZone.actualRadius = subZone.radius
        _subZone.area = subZone.area
        _subZone.diameter = subZone.diameter
        subZones[#subZones + 1] = _subZone
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
    for _, zoneObject_ in pairs(subZones) do
        zoneObject_.weight = zoneObject_.area / mainZone.area
        totalWeight = totalWeight + zoneObject_.weight
    end

    -- Adjust main zone's weight
    mainZone.weight = 1 - totalWeight

    return self
end
