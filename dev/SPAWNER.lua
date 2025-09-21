--- @class AETHR.SPAWNER
--- @brief Manages mission trigger zones and computes bordering relationships.
---@diagnostic disable: undefined-global
--- @field AETHR AETHR Parent AETHR instance (injected by AETHR:New)
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
--- @field MARKERS AETHR.MARKERS
--- @field DATA table Container for zone management data.
--- @field DATA.MIZ_ZONES table<string, _MIZ_ZONE> Loaded mission trigger zones.
AETHR.SPAWNER = {} ---@diagnostic disable-line

--- Container for zone management data.
AETHR.SPAWNER.DATA = {
    generatedGroups = {},
    generatedUnits = {},
    spawnQueue = {},
}


--- Creates a new AETHR.SPAWNER submodule instance.
--- @function AETHR.SPAWNER:New
--- @param parent AETHR Parent AETHR instance
--- @return AETHR.SPAWNER instance New instance inheriting AETHR.SPAWNER methods.
function AETHR.SPAWNER:New(parent)
    local instance = {
        AETHR = parent,
        -- submodule-local caches/state can be initialized here
        _cache = {},
    }
    setmetatable(instance, { __index = self })
    return instance ---@diagnostic disable-line
end

--- Builds and registers a ground unit with the spawner system.
--- @function AETHR.SPAWNER:buildGroundUnit
--- @param type string Unit type, e.g. "T-80UD".
--- @param x number X coordinate in meters.
--- @param y number Y coordinate in meters.
--- @param skill string|nil Skill level, e.g. "Average".
--- @param name string Unit name. Appends unique number to the end, eg. "#123". If nil, a unique name will be generated: "AETHR_GROUND_UNIT#123".
--- @param heading number|nil Optional heading in degrees.  If nil, defaults to 0.
--- @param playerCanDrive boolean|nil Optional flag to allow player to drive the unit. Defaults to true if nil.
--- @param randomTransportable boolean|nil Optional flag to make the unit randomly transportable by helicopters. Defaults to false if nil.
--- @return string groundUnitName The unique name of the created ground unit.
function AETHR.SPAWNER:buildGroundUnit(type, x, y, skill, name, heading, playerCanDrive, randomTransportable)
    skill = skill or nil
    heading = heading or nil
    playerCanDrive = playerCanDrive or nil
    randomTransportable = randomTransportable or nil

    local groundUnitName = name and name .. "#" .. tostring(self.CONFIG.MAIN.COUNTERS.UNITS) or
        "AETHR_GROUND_UNIT#" .. tostring(self.CONFIG.MAIN.COUNTERS.UNITS)
    self.CONFIG.MAIN.COUNTERS.UNITS = self.CONFIG.MAIN.COUNTERS.UNITS + 1

    local groundUnit = self.AETHR._groundUnit:New(type, skill, x, y, groundUnitName, heading, playerCanDrive,
        randomTransportable)
    self.DATA.generatedUnits[groundUnitName] = groundUnit

    return groundUnitName
end

--- Builds and registers a ground group with the spawner system.
--- @function AETHR.SPAWNER:buildGroundGroup
--- @param countryID number Country ID as per DCS scripting API.
--- @param name string|nil Optional group name. If nil, a unique name will be generated: "AETHR_GROUND_GROUP#123".
--- @param x number X coordinate in meters.
--- @param y number Y coordinate in meters.
--- @param units table List of ground unit names created with AETHR.SPAWNER:buildGroundUnit.
--- @param lateActivation boolean|nil Optional flag to delay group activation until explicitly activated. Defaults to true if nil.
--- @param visible boolean|nil Optional flag to set group visibility on the map. Defaults to false if nil.
--- @param taskSelected boolean|nil Optional flag to set group as task selected. Defaults to true if nil.
--- @param hidden boolean|nil Optional flag to hide the group from the mission editor. Defaults to false if nil.
--- @param hiddenOnPlanner boolean|nil Optional flag to hide the group from the in-game planner. Defaults to false if nil.
--- @param hiddenOnMFD boolean|nil Optional flag to hide the group from the in-game MFD. Defaults to false if nil.
--- @param route table|nil Optional route table as per DCS scripting API. If nil, the group will have no route.
--- @param tasks table|nil Optional tasks table as per DCS scripting API. If nil, the group will have no tasks.
--- @param start_time number|nil Optional start time in seconds. If nil, defaults to 0, immediate
--- @param task string|nil Optional initial task as per DCS scripting API. If nil, the group will have "Ground Nothing" task.
--- @param uncontrollable boolean|nil Optional flag to make the group uncontrollable by anyone but Game Masters. Defaults to false if nil.
--- @return string groundGroupName The unique name of the created ground group.
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

    local groundGroup = self.AETHR._groundGroup:New(visible, taskSelected, lateActivation, hidden, hiddenOnPlanner,
        hiddenOnMFD,
        route, tasks, units, y, x, groundGroupName, start_time, task, uncontrollable, countryID)

    self.DATA.generatedGroups[groundGroupName] = groundGroup

    coalition.addGroup(countryID, Group.Category.GROUND, groundGroup)

    return groundGroupName
end

function AETHR.SPAWNER:assembleUnitsForGroup(UnitNames)
    local units = {}
    for _, unitName in ipairs(UnitNames) do
        local unitData = self.DATA.generatedUnits[unitName]
        if unitData then
            table.insert(units, unitData)
        end
    end
    return units
end

function AETHR.SPAWNER:activateGroup(groupName)
    Group.activate(Group.getByName(groupName))
    return self
end

function AETHR.SPAWNER:deactivateGroup(groupName)
    self:updateDBGroupInfo(groupName)
    trigger.action.deactivateGroup(Group.getByName(groupName))
    return self
end

function AETHR.SPAWNER:updateDBGroupInfo(Name)
    local groupObj = Group.getByName(Name)
    local unitsObj = groupObj:getUnits()
    local DB = self.DATA.generatedGroups[Name]

    local unitPoints = {}

    for index, _unit in pairs(unitsObj) do
        local unitName = _unit:getName()
        local unitPos = _unit:getPoint()
        local unitLife = _unit:getLife()
        if unitLife > 1 then
            table.insert(unitPoints, { x = unitPos.x, y = unitPos.z })
        end
        DB.units[index].x = unitPos.x
        DB.units[index].y = unitPos.z
    end

    local groupCenter = self.POLY:getCenterPoint(unitPoints)
    DB.x = groupCenter.x
    DB.y = groupCenter.y

    return self
end

function AETHR.SPAWNER:spawnGroup(groupName)
    local _group = self.DATA.generatedGroups[groupName]
    coalition.addGroup(_group.countryID, Group.Category.GROUND, _group)
    table.insert(self.DATA.spawnQueue, groupName)
    return self
end
