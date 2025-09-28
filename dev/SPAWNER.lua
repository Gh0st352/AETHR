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

    return self
end

---@param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
function AETHR.SPAWNER:generateSpawnerZones(dynamicSpawner)
    -------------------------------------------------------------------
    if self.CONFIG.MAIN.DEBUG_ENABLED then
        for markID, Marker in pairs(self.DATA.debugMarkers) do
            self.MARKERS:removeMarksByID(markID)
            self.DATA.debugMarkers[markID] = nil
        end
    end
    -------------------------------------------------------------------

    local mainZone = dynamicSpawner.zones.main
    mainZone = self.AETHR._spawnerZone:New(self.AETHR, dynamicSpawner)


    local mainZoneCenter = mainZone.center
    local mainZoneRadius = mainZone.actualRadius
    local numSubZones = dynamicSpawner.numSubZones
    local subZoneMinRadius = (mainZoneRadius / numSubZones) / 2

    -------------------------------------------------------------------
    if self.CONFIG.MAIN.DEBUG_ENABLED then
        local circleMarker = self.AETHR._Marker:New(
            self.CONFIG.MAIN.COUNTERS.MARKERS,
            nil,
            mainZoneCenter,
            true,
            nil,
            nil,
            -1,
            self.CONFIG.MAIN.Zone.paintColors.lineType,
            self.CONFIG.MAIN.Zone.paintColors.CircleColors[0],
            self.CONFIG.MAIN.Zone.paintColors.CircleColors[0],
            nil,
            mainZoneRadius
        )
        self.CONFIG.MAIN.COUNTERS.MARKERS = self.CONFIG.MAIN.COUNTERS.MARKERS + 1
        self.MARKERS:markCircle(circleMarker, self.DATA.debugMarkers)
    end
    -------------------------------------------------------------------

    local generatedSubZones = {}
    local attempts = 0
    local operationLimit = self.DATA.CONFIG.operationLimit
    local attemptLimit = numSubZones * operationLimit

    repeat
        local flagGoodCoord = true
        local glassBreak = 0
        local subZone = {}
        local subZoneRadius

        repeat
            flagGoodCoord = true
            subZoneRadius = math.random(subZoneMinRadius, mainZoneRadius) / 2
            local angle = math.random() * 2 * math.pi
            local maxDistFromCenter = math.floor(mainZoneRadius - subZoneRadius)
            local minDistFromCenter = math.floor(subZoneRadius)
            local distFromCenter = math.random(minDistFromCenter, maxDistFromCenter)
            local subZoneCenter = {
                x = mainZoneCenter.x + distFromCenter * math.cos(angle),
                y = mainZoneCenter.y + distFromCenter * math.sin(angle)
            }

            flagGoodCoord = not self:checkIsInNOGO(subZoneCenter, dynamicSpawner.zones.restricted)

            if glassBreak >= operationLimit then flagGoodCoord = true end

            if flagGoodCoord then subZone = self.AETHR._circle:New(subZoneCenter, subZoneRadius) end

            glassBreak = glassBreak + 1
        until flagGoodCoord

        if self.POLY.isSubCircleValidThreshold(subZone, generatedSubZones, mainZoneCenter, mainZoneRadius, 0.75) then
            table.insert(generatedSubZones, subZone)
            -------------------------------------------------------------------
            if self.CONFIG.MAIN.DEBUG_ENABLED then
                local circleMarker = self.AETHR._Marker:New(
                    self.CONFIG.MAIN.COUNTERS.MARKERS,
                    nil,
                    subZone.center,
                    true,
                    nil,
                    nil,
                    -1,
                    self.CONFIG.MAIN.Zone.paintColors.lineType,
                    self.CONFIG.MAIN.Zone.paintColors.CircleColors[0],
                    self.CONFIG.MAIN.Zone.paintColors.CircleColors[0],
                    nil,
                    subZone.radius
                )
                self.CONFIG.MAIN.COUNTERS.MARKERS = self.CONFIG.MAIN.COUNTERS.MARKERS + 1
                self.MARKERS:markCircle(circleMarker, self.DATA.debugMarkers)
            end
            -------------------------------------------------------------------
        end

        if attempts >= attemptLimit then
            flagGoodCoord = true
        end
        attempts = attempts + 1
    until #generatedSubZones == numSubZones and flagGoodCoord




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
