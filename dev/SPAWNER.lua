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
--- @field DATA AETHR.SPAWNER.Data Container for spawner-managed data.
AETHR.SPAWNER = {} ---@diagnostic disable-line

--- Spawner-managed data container.
--- @class AETHR.SPAWNER.Data
--- @field generatedGroups table<string, _groundGroup> Generated ground groups keyed by name.
--- @field generatedUnits table<string, _groundUnit> Generated ground units keyed by name.
--- @field spawnQueue string[] Names of groups scheduled to spawn (processed by WORLD:spawnGroundGroups).
--- @field despawnQueue string[] Names of groups scheduled to despawn (processed by WORLD:despawnGroundGroups).

--- Container for spawner-managed data.
---@type AETHR.SPAWNER.Data
AETHR.SPAWNER.DATA = {
    ---@type table<string, _groundGroup>
    generatedGroups = {},
    ---@type table<string, _groundUnit>
    generatedUnits = {},
    ---@type string[]
    spawnQueue = {},
    ---@type string[]
    despawnQueue = {},
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

