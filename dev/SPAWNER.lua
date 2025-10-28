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
---@brief-module Overview:
--- This module builds and manages dynamic spawners which:
--- 1) seed type pools from WORLD data,
--- 2) compute spawn amounts and zone partitions,
--- 3) roll group types and sizes,
--- 4) generate spatial placements (group centers and unit positions),
--- 5) build group/unit prototypes and optionally instantiate them into the mission.
--- Key risks:
--- - Restricted-zone polygon checks are currently disabled in per-placement checks (see checkIsInNOGO).
--- - Placement falls back to accepting last candidate after operationLimit is reached, which can violate separation constraints under high density.
--- - AABB optimizations (UseDivisionAABBReject/FullInclude) can skip valid placements when enabled but are important for performance.
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
--- @field GenerationQueue string[] FIFO list of job IDs for async spawner generation.
--- @field GenerationJobs table<string, table> jobId -> job descriptor for async spawner generation.
--- @field GenerationJobCounter number Incremental job ID counter for async spawner generation.
--- @field _genState table Internal state for async spawner generation runner.

--- @class AETHR.SPAWNER.DATA.dynamicSpawners
--- @field Airbase table<string, _dynamicSpawner> Dynamic spawners of type "Airbase" keyed by name.
--- @field Zone table<string, _dynamicSpawner> Dynamic spawners of type "Zone" keyed by name.
--- @field Point table<string, _dynamicSpawner> Dynamic spawners of type "Point" keyed by name.
--- @field Town table<string, _dynamicSpawner> Dynamic spawners of type "Town" keyed by name.

--- @class AETHR.SPAWNER.DATA.CONFIG
--- @field BUILD_PAD number Meters of extra padding around buildings for center placement (>0).
--- @field EXTRA_ATTEMPTS_BUILDING number Extra attempts to place group centers away from buildings (>0).
--- @field SPAWNER_WAIT_TIME number Seconds to wait before a group is eligible for spawning after adding to mission engine (>0).
--- @field operationLimit number Maximum number of spawn/despawn operations to process per WORLD cycle (>0).
--- @field UseDivisionAABBReject boolean If true, use division AABB rejection to speed up placement (may skip some valid placements).
--- @field UseDivisionAABBFullInclude boolean If true, use division AABB full inclusion to speed up placement (may skip some valid placements).
--- @field Benchmark boolean If true, enables benchmarking logs for spawner operations.
--- @field UseRestrictedZonePolys boolean If true, apply restricted-zone polygon checks in addition to surface checks (default false for performance).
--- @field Deterministic table Deterministic generation controls: { Enabled:boolean, Warmup:number, ReseedAfter:boolean }.
--- @field Deterministic.Enabled boolean When true, and when a dynamicSpawner.deterministicSeed is provided, generation runs inside a seeded RNG scope.
--- @field Deterministic.Warmup number Extra math.random() calls after seeding to avoid low-entropy draws (default 2).
--- @field Deterministic.ReseedAfter boolean If true, reseeds RNG to a mixed, best-effort entropy after generation (default true).
--- @field NoGoSurfaces AETHR.ENUMS.SurfaceType[] List of surface types that are not valid for spawning.
--- @field separationSettings table Settings for minimum separation of spawned groups/units from each other and buildings.
--- @field separationSettings.minGroups number Minimum distance in meters between spawned groups.
--- @field separationSettings.maxGroups number Maximum distance in meters between spawned groups.
--- @field separationSettings.minUnits number Minimum distance in meters between spawned units within a group.
--- @field separationSettings.maxUnits number Maximum distance in meters between spawned units within a group.
--- @field separationSettings.minBuildings number Minimum distance in meters between spawned units and buildings.
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
        Town = {},
    },
    BenchmarkLog = {},
    CONFIG = {
        BUILD_PAD = 5,                -- Strict building separation constants
        EXTRA_ATTEMPTS_BUILDING = 50, -- Extra attempts to place group centers away from buildings
        SPAWNER_WAIT_TIME = 10,       -- Seconds to wait before a group is elligible for spawning after adding to mission engine to prevent DCS crashes
        UseDivisionAABBReject = true,
        UseDivisionAABBFullInclude = true,
        operationLimit = 50,
        Benchmark = false,
        -- Optional polygon NOGO checks (default: disabled for performance)
        UseRestrictedZonePolys = false,
        -- Deterministic pipeline controls
        Deterministic = {
            Enabled = false,   -- When true, generation runs inside a seeded RNG scope if a seed is provided on the spawner
            Warmup = 2,        -- Number of math.random() warmups after seeding
            ReseedAfter = true -- When true, RNG is scrambled after deterministic section to restore unpredictability
        },
        NoGoSurfaces = {
            AETHR.ENUMS.SurfaceType.WATER,
            AETHR.ENUMS.SurfaceType.RUNWAY,
            AETHR.ENUMS.SurfaceType.SHALLOW_WATER
        },
        separationSettings = {
            minGroups = 35,
            maxGroups = 75,
            minUnits = 15,
            maxUnits = 50,
            minBuildings = 55,
        },
        spawnAIOff = false,       -- When true, spawned ground groups AI are turned off after spawning
        spawnEmissionOff = false, -- When true, spawned ground groups radar emissions are turned on after spawning
    },
    debugMarkers = {},
    -- Async spawner generation job queue/state
    GenerationQueue = {},              -- FIFO list of job IDs
    GenerationJobs = {},               -- jobId -> job descriptor
    GenerationJobCounter = 1,          -- incremental job id
    _genState = { currentJobId = nil } -- internal runner state
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

--------------------------------------------------------------------------------
-- Shared spatial/grid helpers (used by group center and unit placement)
--------------------------------------------------------------------------------

--- Normalize a number of possible object shapes to {x, y}
--- Supports:
---  - obj.{x,y}
---  - obj.position.{x,z|y}
---  - obj:getPoint() returning {x,y|z}
--- @param obj any
--- @return _vec2|nil
function AETHR.SPAWNER:_extractXY(obj)
    if not obj then return nil end
    if obj.x and obj.y then return { x = obj.x, y = obj.y } end
    if obj.position and obj.position.x and (obj.position.z or obj.position.y) then
        return { x = obj.position.x, y = (obj.position.z or obj.position.y) }
    end
    if obj.getPoint and type(obj.getPoint) == "function" then
        local p = obj:getPoint()
        if p and p.x and (p.y or p.z) then return { x = p.x, y = (p.z or p.y) } end
    end
    return nil
end

--- Convert a world point to grid cell indices at scale s
function AETHR.SPAWNER:_toCell(x, y, s)
    local cx = math.floor(x / s)
    local cy = math.floor(y / s)
    return cx, cy
end

--- Build a grid cell key
function AETHR.SPAWNER:_cellKey(cx, cy)
    return tostring(cx) .. ":" .. tostring(cy)
end

--- Insert a point into a grid (optional extra fields like radius r)
function AETHR.SPAWNER:_gridInsert(grid, s, x, y, extra)
    local cx, cy = self:_toCell(x, y, s)
    local key = self:_cellKey(cx, cy)
    grid[key] = grid[key] or {}
    local pt = { x = x, y = y }
    if type(extra) == "table" then
        for k, v in pairs(extra) do pt[k] = v end
    end
    table.insert(grid[key], pt)
end

--- Query a grid for any point within radius^2 of (x,y)
function AETHR.SPAWNER:_gridQuery(grid, s, x, y, r2, neighborRange)
    local cx, cy = self:_toCell(x, y, s)
    local r = neighborRange or math.ceil(math.sqrt(r2) / s)
    for dx = -r, r do
        for dy = -r, r do
            local key = self:_cellKey(cx + dx, cy + dy)
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

--- Return an approximate horizontal radius for an object based on its descriptor box, if available.
function AETHR.SPAWNER:_approxObjectRadius(obj)
    local desc = obj and obj.desc
    local box = desc and desc.box
    if box and box.min and box.max then
        local dx = (box.max.x or 0) - (box.min.x or 0)
        -- Prefer horizontal Z span; fall back to Y if Z not present.
        local dz = ((box.max.z ~= nil) and (box.max.z - (box.min.z or 0))) or ((box.max.y or 0) - (box.min.y or 0))
        local r = 0.5 * math.sqrt((dx * dx) + (dz * dz))
        if r and r > 0 then return r end
    end
    return 0
end

--- Direct, strict building proximity check within neighbor cells.
--- Returns true when (distance(candidate, object) <= minDist + objectRadius)
function AETHR.SPAWNER:_directCellStructureReject(grid, s, x, y, minDist, neighborRange)
    local cx, cy = self:_toCell(x, y, s)
    local rCells = neighborRange or math.ceil((minDist or 0) / s)
    for dx = -rCells, rCells do
        for dy = -rCells, rCells do
            local cell = grid[self:_cellKey(cx + dx, cy + dy)]
            if cell then
                for _, pt in ipairs(cell) do
                    local dx_ = (pt.x or 0) - x
                    local dy_ = (pt.y or 0) - y
                    local th = (minDist or 0) + (pt.r or 0)
                    if (dx_ * dx_) + (dy_ * dy_) <= (th * th) then
                        return true
                    end
                end
            end
        end
    end
    return false
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
--- @param allowProxySpawn boolean|nil If true, group is eligible for proxy spawning by the PROXY submodule. Defaults to false if nil.
--- @return string groundGroupName Unique name of the created ground group (key in DATA.generatedGroups).
function AETHR.SPAWNER:buildGroundGroup(countryID, name, x, y, units, route, tasks, lateActivation, visible, taskSelected,
                                        hidden,
                                        hiddenOnPlanner, hiddenOnMFD,
                                        start_time, task, uncontrollable, allowProxySpawn)
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
    allowProxySpawn = allowProxySpawn or false

    local groundGroupName = name and name .. "#" .. tostring(self.CONFIG.MAIN.COUNTERS.GROUPS) or
        "AETHR_GROUND_GROUP#" .. tostring(self.CONFIG.MAIN.COUNTERS.GROUPS)
    self.CONFIG.MAIN.COUNTERS.GROUPS = self.CONFIG.MAIN.COUNTERS.GROUPS + 1

    ---@type _groundGroup
    local groundGroup = self.AETHR._groundGroup:New(visible, taskSelected, lateActivation, hidden, hiddenOnPlanner,
        hiddenOnMFD,
        route, tasks, units, y, x, groundGroupName, start_time, task, uncontrollable, countryID, allowProxySpawn)

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
    if not groupObj then
        self.UTILS:debugInfo("AETHR.SPAWNER:updateDBGroupInfo: No group found for name '" .. tostring(Name) .. "'")
        return self
    end
    local unitsObj = groupObj:getUnits()
    ---@type _groundGroup
    local DB = self.DATA.generatedGroups[Name]

    if not DB then
        self.UTILS:debugInfo("AETHR.SPAWNER:updateDBGroupInfo: No generatedGroups entry for group '" ..
            tostring(Name) .. "'")
        return self
    end

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
    _group._engineAddTime = self.UTILS:getTime()
    coalition.addGroup(countryID and countryID or _group.countryID, Group.Category.GROUND, _group)
    table.insert(self.DATA.spawnQueue, groupName)
    return self
end

--- Spawns all groups prepared in the provided dynamic spawner instance into the world and enqueues them.
--- @function AETHR.SPAWNER:spawnDynamicSpawner
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance containing subzones and spawnGroups.
--- @param countryID number|nil Optional country ID to override spawned groups' country (DCS API). Defaults to dynamicSpawner.countryID when nil.
--- @return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:spawnDynamicSpawner(dynamicSpawner, countryID)
    local subZones = dynamicSpawner.zones.sub
    ---@param subZone _spawnerZone
    for indexSubZone, subZone in pairs(subZones) do
        local spawnGroups = subZone.spawnGroups
        for indexGroup, groupName in ipairs(spawnGroups) do
            local _group = self.DATA.generatedGroups[groupName]
            _group._engineAddTime = self.UTILS:getTime()
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

--- Creates and registers a new dynamic spawner instance.
--- @function AETHR.SPAWNER:newDynamicSpawner
--- @param dynamicSpawnerType string Type of dynamic spawner ("Airbase"|"Zone"|"Point").
--- @return _dynamicSpawner dynamicSpawner Created dynamic spawner instance.
function AETHR.SPAWNER:newDynamicSpawner(dynamicSpawnerType)
    local name = "AETHR_DYNAMIC_SPAWNER#" .. tostring(self.CONFIG.MAIN.COUNTERS.DYNAMIC_SPAWNERS)
    self.CONFIG.MAIN.COUNTERS.DYNAMIC_SPAWNERS = self.CONFIG.MAIN.COUNTERS.DYNAMIC_SPAWNERS + 1

    local dynamicSpawner = self.AETHR._dynamicSpawner:New(name, self.AETHR)


    self.DATA.dynamicSpawners[dynamicSpawnerType][dynamicSpawner.name] = dynamicSpawner
    return dynamicSpawner
end

--- Generate a dynamic spawner configuration and build spawn prototypes for later instantiation.
--- Pipeline:
---  1) Pair to world/MIZ zones
---  2) Generate circles (main/sub), weight zones
---  3) Compute spawn amounts and jiggle
---  4) Allocate group sizes
---  5) Roll group types
---  6) Determine zone divisions and collect objects (AABB-optimized)
---  7) Place group centers, then unit positions (grid-accelerated checks + progressive relaxation)
---  8) Build group/unit prototypes
---
--- Deterministic mode:
---  - When either SPAWNER.DATA.CONFIG.Deterministic.Enabled is true, or dynamicSpawner.deterministicEnabled is true,
---    and a numeric dynamicSpawner.deterministicSeed is provided, this function runs its entire generation pipeline
---    inside a deterministic RNG scope via [AETHR.UTILS:withSeed()](dev/UTILS.lua:192).
---  - Warmup calls (CONFIG.Deterministic.Warmup, default 2) are executed after seeding to avoid low-entropy first draws.
---  - If CONFIG.Deterministic.ReseedAfter is true (default), math.random is reseeded to a mixed, best-effort entropy after
---    the deterministic section to restore unpredictability in the rest of the mission.
---  - Trade-offs: Lua 5.1 RNG is global; seeding affects all math.random usage in the same frame. We minimize impact by
---    scoping strictly to this function. For full isolation, refactor random sources to accept an injected RNG interface.
---
--- Separation behavior under load:
---  - Candidate placement loops for centers and units use an operation budget (CONFIG.operationLimit).
---  - Before accepting the last candidate at the limit, the algorithm progressively relaxes separation thresholds
---    (up to roughly 30%) to find a valid point. The hard fallback remains only at budget exhaustion.
---
--- Restricted zones:
---  - Surface NOGO is always enforced. Polygon NOGO checks can be enabled by SPAWNER.DATA.CONFIG.UseRestrictedZonePolys
---    and are performed in [AETHR.SPAWNER:checkIsInNOGO()](dev/SPAWNER.lua:1607) using an AABB prefilter + point-in-polygon.
---    Default is off for performance.
---

--- Enqueue an async dynamic spawner generation job. Returns jobId.
---@param dynamicSpawner _dynamicSpawner
---@param vec2 _vec2
---@param minRadius number|nil
---@param nominalRadius number|nil
---@param maxRadius number|nil
---@param nudgeFactorRadius number|nil
---@param countryID number|nil
---@param autoSpawn boolean|nil When true, auto-spawn groups after generation
---@return integer jobId
function AETHR.SPAWNER:enqueueGenerateDynamicSpawner(dynamicSpawner, vec2, minRadius, nominalRadius, maxRadius,
                                                     nudgeFactorRadius, countryID, autoSpawn)
    self.DATA.GenerationJobCounter = (self.DATA.GenerationJobCounter or 1)
    local id = self.DATA.GenerationJobCounter
    self.DATA.GenerationJobCounter = id + 1

    local job = {
        id = id,
        status = "queued",
        enqueuedAt = (self.UTILS and self.UTILS.getTime) and self.UTILS:getTime() or os.time(),
        params = {
            dynamicSpawner = dynamicSpawner,
            vec2 = vec2,
            minRadius = minRadius,
            nominalRadius = nominalRadius,
            maxRadius = maxRadius,
            nudgeFactorRadius = nudgeFactorRadius,
            countryID = countryID,
            autoSpawn = autoSpawn and true or false,
        }
    }
    self.UTILS:debugInfo("AETHR.SPAWNER:enqueueGenerateDynamicSpawner -- Enqueuing job for " ..
        dynamicSpawner.name .. " - ID#" .. tostring(id))
    self.DATA.GenerationJobs[id] = job
    table.insert(self.DATA.GenerationQueue, id)
    return id
end

--- Get async generation job status by id.
---@param jobId integer
---@return table|nil job
function AETHR.SPAWNER:getGenerationJobStatus(jobId)
    return self.DATA.GenerationJobs and self.DATA.GenerationJobs[jobId] or nil
end

--- @function AETHR.SPAWNER:generateDynamicSpawner
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance to configure (supports .deterministicSeed, .deterministicEnabled).
--- @param vec2 _vec2 Center point for the spawner to generate around.
--- @param minRadius number|nil Minimum radius in meters. Defaults to dynamicSpawner.minRadius if nil.
--- @param nominalRadius number|nil Nominal radius in meters. Defaults to dynamicSpawner.nominalRadius if nil.
--- @param maxRadius number|nil Maximum radius in meters. Defaults to dynamicSpawner.maxRadius if nil.
--- @param nudgeFactorRadius number|nil Nudge factor for radius adjustment (0.0-1.0). Defaults to dynamicSpawner.nudgeFactorRadius if nil.
--- @param countryID number|nil Country ID for spawned groups. Defaults to dynamicSpawner.countryID (0) if nil.
--- @return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:generateDynamicSpawner(dynamicSpawner, vec2, minRadius, nominalRadius, maxRadius,
                                              nudgeFactorRadius, countryID)
    local function runPipeline()
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
        -- Reset per-run tallies to avoid carry-over between generations
        dynamicSpawner._confirmedTotal = 0
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
            local gen_ = 0
            self.UTILS:debugInfo("BENCHMARK - D - AETHR.SPAWNER:generateDynamicSpawner ------------- completed in : " ..
                tostring(self.DATA.BenchmarkLog.generateDynamicSpawner.Time.total) .. " seconds.")
            self.UTILS:debugInfo("BENCHMARK - D -           Spawn Area Radius (m) : " ..
                tostring(dynamicSpawner.zones.main.actualRadius))
            self.UTILS:debugInfo("BENCHMARK - D -          Number Spawn Zones     : " ..
                tostring(dynamicSpawner.numSubZones))
            self.UTILS:debugInfo("BENCHMARK - D - Avg Spawn Zone Unit Distrib     : " ..
                tostring(dynamicSpawner.averageDistribution))
            -- Diagnostic: verify summed subzone generated.actual aligns with expectations
            local sumActualAcrossSubZones = 0
            do
                local _subs = (dynamicSpawner.zones and dynamicSpawner.zones.sub) or {}
                for _, _sz in pairs(_subs) do
                    if _sz and _sz.spawnSettings and _sz.spawnSettings.generated then
                        sumActualAcrossSubZones = sumActualAcrossSubZones + (_sz.spawnSettings.generated.actual or 0)
                    end
                end
            end
            self.UTILS:debugInfo("BENCHMARK - D - Sum SubZone Generated(actual)    : " ..
                tostring(sumActualAcrossSubZones))
            for type, typeVal in pairs(dynamicSpawner.spawnTypes) do
                self.UTILS:debugInfo("BENCHMARK - D -                # Spawn Type     : " ..
                    tostring(type) .. ": " .. tostring(typeVal.actual))
                gen_ = gen_ + typeVal.actual
            end
            self.UTILS:debugInfo("BENCHMARK - D -           Generated Units       : " ..
                tostring(gen_))

            for type, typeVal in pairs(dynamicSpawner.extraTypes) do
                self.UTILS:debugInfo("BENCHMARK - D -      # Extra Type Per Group     : " ..
                    tostring(type) .. ": " .. tostring(typeVal.min))
            end

            --self.UTILS:debugInfo("BENCHMARK - - - Generated Units: " .. tostring(dynamicSpawner._confirmedTotal))
        end
    end

    -- Deterministic wrapper (optional)
    local detConfig = self.DATA.CONFIG.Deterministic or {}
    local enabledDefault = detConfig.Enabled == true
    local detEnabled = (dynamicSpawner.deterministicEnabled ~= nil) and dynamicSpawner.deterministicEnabled or
        enabledDefault
    local detSeed = dynamicSpawner.deterministicSeed

    if detEnabled and detSeed then
        local warm = detConfig.Warmup or 2
        local reseedAfter = (detConfig.ReseedAfter ~= false)
        self.UTILS:withSeed(detSeed, runPipeline, warm, reseedAfter)
    else
        runPipeline()
    end

    return self
end

--- High-level pipeline: roll types and place groups for the given dynamic spawner.
--- Calls internal routines to determine group types and spatial placement.
--- @function AETHR.SPAWNER:generateSpawnerGroups
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
--- @return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:generateSpawnerGroups(dynamicSpawner)
    self:rollSpawnGroups(dynamicSpawner)
    self:rollGroupPlacement(dynamicSpawner)
    return self
end

--- Determine placement (divisions, objects, centers, unit positions) for groups within the dynamic spawner.
--- @function AETHR.SPAWNER:rollGroupPlacement
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
--- @return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:rollGroupPlacement(dynamicSpawner)
    self:pairSpawnerZoneDivisions(dynamicSpawner)
    self:determineZoneDivObjects(dynamicSpawner)
    self:generateVec2GroupCenters(dynamicSpawner)
    self:generateVec2UnitPos(dynamicSpawner)
    return self
end

--- Build ground unit and group prototypes for all spawnGroups in the dynamic spawner's subzones.
--- Units and groups are registered into SPAWNER.DATA.generatedUnits/generatedGroups but groups are not yet instantiated unless coalition.addGroup is called.
--- @function AETHR.SPAWNER:buildSpawnGroups
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
--- @param countryID number|nil Optional country ID to override groups' country on build.
--- @return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:buildSpawnGroups(dynamicSpawner, countryID)
    local subZones = dynamicSpawner.zones.sub
    local allowProxySpawn = dynamicSpawner._allowProxySpawn

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
                        "Ground Nothing", false, allowProxySpawn)
                end
            end
        end
        subZone.spawnGroups = spawnGroups
    end
    return self
end

--- Determine world divisions that overlap the dynamic spawner area and store them on the spawner.
--- Uses main radius and center to find overlapping WORLD divisions.
--- @function AETHR.SPAWNER:pairSpawnerWorldDivisions
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
--- @return AETHR.SPAWNER self For chaining.
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

--- Pair the dynamic spawner with active MIZ zones and their divisions.
--- Populates dynamicSpawner.mizZones and dynamicSpawner.worldDivisions for later usage.
--- @function AETHR.SPAWNER:pairSpawnerActiveZones
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
--- @return AETHR.SPAWNER self For chaining.
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
        local mizZoneVerts = mizZone.vertices
        local mainZoneRadius = dynamicSpawner.maxRadius
        local mainZoneCenter = dynamicSpawner.vec2

        if self.POLY:circleOverlapPoly(mainZoneRadius, mainZoneCenter, mizZoneVerts) then
            table.insert(_MizZones, mizZone)
            for _ID, div in pairs(mizZone.activeDivisions) do
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

--- For each subzone, determine which world divisions intersect it and cache them on the subzone object.
--- @function AETHR.SPAWNER:pairSpawnerZoneDivisions
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
--- @return AETHR.SPAWNER self For chaining.
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

--- Collect scenery/static/base objects for each subzone by scanning divisions and applying AABB filters.
--- Populates subZone.zoneDivSceneryObjects, zoneDivStaticObjects and zoneDivBaseObjects.
--- Uses AABB early-reject and full-include optimizations controlled by DATA.CONFIG flags.
--- @function AETHR.SPAWNER:determineZoneDivObjects
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
--- @return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:determineZoneDivObjects(dynamicSpawner)
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.determineZoneDivObjects = { Time = {}, Counters = {} }
        self.DATA.BenchmarkLog.determineZoneDivObjects.Time.start = os.clock()
    end
    local coroutine_ = self.BRAIN.DATA.coroutines.spawnerGenerationQueue

    ---@type _spawnerZone[]
    local subZones = dynamicSpawner.zones.sub
    local sceneryObjectsDB = self.WORLD.DATA.divisionSceneryObjects -- Loaded scenery per division.
    local staticObjectsDB = self.WORLD.DATA.divisionStaticObjects   -- Loaded statics per division.
    local baseObjectsDB = self.WORLD.DATA.divisionBaseObjects       -- Loaded Base per division.

    -- init benchmark counters
    local _divCounters = self.DATA.BenchmarkLog.determineZoneDivObjects and
        self.DATA.BenchmarkLog.determineZoneDivObjects.Counters
    if _divCounters then
        _divCounters.scannedDivs = _divCounters.scannedDivs or 0
        _divCounters.earlyRejectedDivs = _divCounters.earlyRejectedDivs or 0
        _divCounters.fullIncludedDivs = _divCounters.fullIncludedDivs or 0
    end

    -- initialize per-division AABB cache (WORLD-level, shared)
    self.WORLD.DATA.worldDivisionsCache = self.WORLD.DATA.worldDivisionsCache or {}
    self.WORLD.DATA.worldDivAABB = self.WORLD.DATA.worldDivAABB or {}
    local aabbCache = self.WORLD.DATA.worldDivAABB

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

                if _divCounters then _divCounters.scannedDivs = _divCounters.scannedDivs + 1 end

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

                if skip and _divCounters then _divCounters.earlyRejectedDivs = _divCounters.earlyRejectedDivs + 1 end

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
                    if fullInclude and _divCounters then
                        _divCounters.fullIncludedDivs = _divCounters.fullIncludedDivs +
                            1
                    end
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
                self.BRAIN:maybeYield(coroutine_, "SPAWNER:determineZoneDivObjects Inner", 1)
            end
            self.BRAIN:maybeYield(coroutine_, "SPAWNER:determineZoneDivObjects outer", 1)

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
        local c = self.DATA.BenchmarkLog.determineZoneDivObjects.Counters or {}
        self.UTILS:debugInfo("BENCHMARK - D - determineZoneDivObjects scannedDivs        : " ..
            tostring(c.scannedDivs or 0))
        self.UTILS:debugInfo("BENCHMARK - D - determineZoneDivObjects earlyRejectedDivs  : " ..
            tostring(c.earlyRejectedDivs or 0))
        self.UTILS:debugInfo("BENCHMARK - D - determineZoneDivObjects fullIncludedDivs   : " ..
            tostring(c.fullIncludedDivs or 0))
    end
    return self
end

--- Generate candidate center positions for groups inside each subzone, respecting separation and NOGO checks.
--- Uses spatial hashing (grid) to accelerate neighbor queries against units and structures.
--- Generated centers are stored in groupSetting.generatedGroupCenterVec2s.
--- @function AETHR.SPAWNER:generateVec2GroupCenters
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
--- @return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:generateVec2GroupCenters(dynamicSpawner)
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.generateVec2GroupCenters = { Time = {}, Counters = {} }
        self.DATA.BenchmarkLog.generateVec2GroupCenters.Time.start = os.clock()
    end

    -- Performance notes:
    -- - Squared-distance checks with grid hashing (no sqrt) keep hot loops cheap.
    -- - neighborRange* are computed in cell units to bound grid lookups tightly.
    -- - Building separation is strict (never relaxed). Group separation relaxes up to ~30% as glassBreak approaches operationLimit.
    -- - Benchmark logging is gated; no per-iteration logging in hot loops.
    local BUILD_PAD = self.DATA.CONFIG
        .BUILD_PAD               -- meters of extra padding around buildings for center placement
    local EXTRA_ATTEMPTS_BUILDING = self.DATA.CONFIG
        .EXTRA_ATTEMPTS_BUILDING --- extra attempts if building rejection occurs

    -- init counters view
    local _centerCounters = self.DATA.BenchmarkLog.generateVec2GroupCenters and
        self.DATA.BenchmarkLog.generateVec2GroupCenters.Counters
    if _centerCounters then
        _centerCounters.Attempts = _centerCounters.Attempts or 0
        _centerCounters.RelaxationSteps = _centerCounters.RelaxationSteps or 0
        _centerCounters.BuildingRejects = _centerCounters.BuildingRejects or 0
    end
    local groupsDB = self.WORLD.DATA.groundGroupsDB -- Loaded units per division (not used directly for positions)
    ---@type _spawnerZone[]
    local subZones = dynamicSpawner.zones.sub
    local coroutine_ = self.BRAIN.DATA.coroutines.spawnerGenerationQueue
    -- Local helper aliases to shared SPAWNER routines
    local extractXY = function(obj) return self:_extractXY(obj) end
    local toCell = function(x, y, s) return self:_toCell(x, y, s) end
    local cellKey = function(cx, cy) return self:_cellKey(cx, cy) end
    local gridInsert = function(grid, s, x, y, extra) return self:_gridInsert(grid, s, x, y, extra) end
    local gridQuery = function(grid, s, x, y, r2, neighborRange) return self:_gridQuery(grid, s, x, y, r2, neighborRange) end
    local directReject = function(grid, s, x, y, minDist, neighborRange)
        return self:_directCellStructureReject(grid, s, x, y, minDist, neighborRange)
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
        -- cache per-subzone for reuse in unit position placement
        subZone._nearbyUnits = freshScannedUnits
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
                if p then
                    gridInsert(grid, s, p.x, p.y, { r = self:_approxObjectRadius(obj) })
                end
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
            local sepCfg = self.DATA.CONFIG.separationSettings or {}
            local minGroups = groupSetting.minGroups or sepCfg.minGroups or 30
            local minBuildings = groupSetting.minBuildings or sepCfg.minBuildings or 20
            local mg2 = (minGroups) * (minGroups)
            local mb2 = (minBuildings) * (minBuildings)
            local neighborRangeGroups = math.ceil(minGroups / cellSize)
            local neighborRangeBuildings = math.ceil((minBuildings + BUILD_PAD) / cellSize)
            for i = 1, (groupSetting.numGroups or 0) do
                local glassBreak = 0
                local possibleVec2 = nil
                local accepted = false
                local operationLimit = self.DATA.CONFIG.operationLimit or 100
                local emergencyRadiusIncrement = 50
                local emergencyRadiusIncrementCounter = 0
                local emergencyCTR = 0
                repeat
                    possibleVec2 = self.POLY:getRandomVec2inCircle(
                        subZoneRadius + (emergencyRadiusIncrement * emergencyRadiusIncrementCounter), subZoneCenter)

                    -- Fast proximity checks using grids (squared distances)
                    local reject = false
                    local relaxMax = 0.3
                    local relax = math.min(relaxMax, (glassBreak / operationLimit) * relaxMax)
                    if _centerCounters and relax > 0 then
                        _centerCounters.RelaxationSteps = _centerCounters
                            .RelaxationSteps + 1
                    end
                    local _mg = minGroups * (1 - relax)
                    local _mb = minBuildings * (1 - relax)
                    local mg2eff = _mg * _mg
                    local mb2eff = _mb * _mb
                    -- Check against already accepted centers
                    if next(centersGrid) ~= nil then
                        if gridQuery(centersGrid, cellSize, possibleVec2.x, possibleVec2.y, mg2eff, neighborRangeGroups) then
                            reject = true
                        end
                    end
                    -- Check against nearby units/groups
                    if not reject and next(groupsGrid) ~= nil then
                        if gridQuery(groupsGrid, cellSize, possibleVec2.x, possibleVec2.y, mg2eff, neighborRangeGroups) then
                            reject = true
                        end
                    end
                    -- Fast prune against nearby structures (kept for performance)
                    if not reject and next(structuresGrid) ~= nil then
                        if gridQuery(structuresGrid, cellSize, possibleVec2.x, possibleVec2.y, mb2eff, neighborRangeBuildings) then
                            reject = true
                        end
                    end
                    -- Strict building check (per-object radius + padding, never relaxed)
                    local buildingRejectDirect = false
                    if next(structuresGrid) ~= nil then
                        buildingRejectDirect = directReject(
                            structuresGrid, cellSize, possibleVec2.x, possibleVec2.y,
                            (minBuildings + BUILD_PAD), neighborRangeBuildings
                        )
                        if buildingRejectDirect and _centerCounters then
                            _centerCounters.BuildingRejects = (_centerCounters.BuildingRejects or 0) + 1
                        end
                    end
                    if buildingRejectDirect then
                        reject = true
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
                        -- At budget: keep strict on buildings; allow fallback only when NOT a building violation.
                        if not buildingRejectDirect then
                            accepted = true
                        elseif glassBreak < operationLimit + EXTRA_ATTEMPTS_BUILDING then
                            accepted = false
                        else
                            accepted = false
                        end
                    end

                    -- Enforce strict building rejection even after operationLimit fallback.
                    if accepted then
                        local strictBuildingReject = false
                        if next(structuresGrid) ~= nil then
                            strictBuildingReject = directReject(
                                structuresGrid, cellSize, possibleVec2.x, possibleVec2.y,
                                (minBuildings + BUILD_PAD), neighborRangeBuildings
                            )
                        end
                        if strictBuildingReject then
                            accepted = false
                            if _centerCounters then
                                _centerCounters.BuildingRejects = (_centerCounters.BuildingRejects or 0) + 1
                            end
                        end
                    end

                    glassBreak = glassBreak + 1
                    if (glassBreak % math.max(1, math.floor(operationLimit / 5))) == 0 then
                        if glassBreak > operationLimit then
                            emergencyCTR = emergencyCTR + 1
                            if emergencyCTR >= 100 then
                                emergencyCTR = 0
                                emergencyRadiusIncrementCounter = emergencyRadiusIncrementCounter + 1
                            end
                        end
                        self.BRAIN:maybeYield(coroutine_, "SPAWNER:generateVec2GroupCenters Inner", 1)
                    end
                until accepted
                if _centerCounters then _centerCounters.Attempts = (_centerCounters.Attempts or 0) + glassBreak end
                -- Accept candidate
                groupCenterVec2s[i] = possibleVec2
                table.insert(selectedCoords, possibleVec2)
                gridInsert(centersGrid, cellSize, possibleVec2.x, possibleVec2.y)
                self.BRAIN:maybeYield(coroutine_, "SPAWNER:generateVec2GroupCenters Outer", 1)
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
        local cc = self.DATA.BenchmarkLog.generateVec2GroupCenters.Counters or {}
        self.UTILS:debugInfo("BENCHMARK - D - generateVec2GroupCenters Attempts(sum)   : " .. tostring(cc.Attempts or 0))
        self.UTILS:debugInfo("BENCHMARK - D - generateVec2GroupCenters RelaxationSteps : " ..
            tostring(cc.RelaxationSteps or 0))
        self.UTILS:debugInfo("BENCHMARK - D - generateVec2GroupCenters BuildingRejects   : " ..
            tostring(cc.BuildingRejects or 0))
    end
    return self
end

--- Generate per-unit positions relative to accepted group centers, respecting unit separation and NOGO checks.
--- Results stored in groupSetting.generatedUnitVec2s.
--- @function AETHR.SPAWNER:generateVec2UnitPos
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
--- @return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:generateVec2UnitPos(dynamicSpawner)
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.generateVec2UnitPos = { Time = {}, Counters = {} }
        self.DATA.BenchmarkLog.generateVec2UnitPos.Time.start = os.clock()
    end
    -- Performance notes:
    -- - Mirrors center-placement loop: grid hashed neighbor checks, squared-distance thresholds.
    -- - Unit-vs-building separation remains strict; unit-vs-unit separation may relax up to ~30% as budget depletes.
    -- - Avoids hot-loop logging; rely on benchmark flags for summary timing.
    local BUILD_PAD = self.DATA.CONFIG
        .BUILD_PAD               -- meters of extra padding around buildings for center placement
    local EXTRA_ATTEMPTS_BUILDING = self.DATA.CONFIG
        .EXTRA_ATTEMPTS_BUILDING --- extra attempts if building rejection occurs
    -- init counters view
    local _unitCounters = self.DATA.BenchmarkLog.generateVec2UnitPos and
        self.DATA.BenchmarkLog.generateVec2UnitPos.Counters
    if _unitCounters then
        _unitCounters.Attempts = _unitCounters.Attempts or 0
        _unitCounters.RelaxationSteps = _unitCounters.RelaxationSteps or 0
        _unitCounters.BuildingRejects = _unitCounters.BuildingRejects or 0
    end



    local unitsDB = self.WORLD.DATA.groundUnitsDB -- Loaded units per division (not used directly for positions)
    local coroutine_ = self.BRAIN.DATA.coroutines.spawnerGenerationQueue
    ---@type _spawnerZone[]
    local subZones = dynamicSpawner.zones.sub

    -- Local helper aliases to shared SPAWNER routines
    local extractXY = function(obj) return self:_extractXY(obj) end
    local toCell = function(x, y, s) return self:_toCell(x, y, s) end
    local cellKey = function(cx, cy) return self:_cellKey(cx, cy) end
    local gridInsert = function(grid, s, x, y, extra) return self:_gridInsert(grid, s, x, y, extra) end
    local gridQuery = function(grid, s, x, y, r2, neighborRange) return self:_gridQuery(grid, s, x, y, r2, neighborRange) end
    local directReject = function(grid, s, x, y, minDist, neighborRange)
        return self:_directCellStructureReject(grid, s, x, y, minDist, neighborRange)
    end

    -- Process each subZone
    for _, subZone in pairs(subZones) do
        local subZoneRadius = subZone.actualRadius
        local subZoneCenter = subZone.center
        local baseObjects = subZone.zoneDivBaseObjects or {}
        local staticObjects = subZone.zoneDivStaticObjects or {}
        local sceneryObjects = subZone.zoneDivSceneryObjects or {}
        local freshScannedUnits = subZone._nearbyUnits or
            self.WORLD:searchObjectsSphere(self.ENUMS.ObjectCategory.UNIT, subZoneCenter,
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

        -- Build grids: baseGrid, staticGrid, sceneryGrid for direct checks; structuresGrid for fast prune; groupsGrid (nearby units); centersGrid (accepted)
        local structuresGrid = {}
        local baseGrid = {}
        local staticGrid = {}
        local sceneryGrid = {}
        local groupsGrid = {}
        local centersGrid = {}

        -- Helper to populate a list of objects into a grid using extractXY
        local function populateGridFromList(list, grid, s)
            for _, obj in pairs(list or {}) do
                local p = extractXY(obj)
                if p then
                    gridInsert(grid, s, p.x, p.y, { r = self:_approxObjectRadius(obj) })
                end
            end
        end

        -- Populate structuresGrid from base/static/scenery objects
        -- Aggregate into structuresGrid for fast prune
        populateGridFromList(baseObjects, structuresGrid, cellSize)
        populateGridFromList(staticObjects, structuresGrid, cellSize)
        populateGridFromList(sceneryObjects, structuresGrid, cellSize)
        -- Also populate per-type grids for strict direct checks
        populateGridFromList(baseObjects, baseGrid, cellSize)
        populateGridFromList(staticObjects, staticGrid, cellSize)
        populateGridFromList(sceneryObjects, sceneryGrid, cellSize)

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
            local sepCfg = self.DATA.CONFIG.separationSettings or {}
            local minUnits = groupSetting.minUnits or sepCfg.minUnits or 10
            local maxUnits = groupSetting.maxUnits or sepCfg.maxUnits or 20
            local maxGroups = groupSetting.maxGroups or sepCfg.maxGroups or 30
            local minBuildings = groupSetting.minBuildings or sepCfg.minBuildings or 20
            local mg2 = (minUnits) * (minUnits)
            local mb2 = (minBuildings) * (minBuildings)
            local neighborRangeGroups = math.ceil(minUnits / cellSize)
            local neighborRangeBuildings = math.ceil((minBuildings + BUILD_PAD) / cellSize)

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
                        local relaxMax = 0.3
                        local relax = math.min(relaxMax, (glassBreak / operationLimit) * relaxMax)
                        if _unitCounters and relax > 0 then
                            _unitCounters.RelaxationSteps = _unitCounters
                                .RelaxationSteps + 1
                        end
                        local _mu = minUnits * (1 - relax)
                        local _mbu = minBuildings * (1 - relax)
                        local mg2eff = _mu * _mu
                        local mb2eff = _mbu * _mbu

                        -- Check against already accepted centers
                        if next(centersGrid) ~= nil then
                            if gridQuery(centersGrid, cellSize, possibleVec2.x, possibleVec2.y, mg2eff, neighborRangeGroups) then
                                reject = true
                            end
                        end

                        -- Check against nearby units/groups
                        if not reject and next(groupsGrid) ~= nil then
                            if gridQuery(groupsGrid, cellSize, possibleVec2.x, possibleVec2.y, mg2eff, neighborRangeGroups) then
                                reject = true
                            end
                        end

                        -- Fast prune against nearby structures (kept for performance)
                        if not reject and next(structuresGrid) ~= nil then
                            if gridQuery(structuresGrid, cellSize, possibleVec2.x, possibleVec2.y, mb2eff, neighborRangeBuildings) then
                                reject = true
                            end
                        end

                        -- Strict building check (per-object radius + padding, never relaxed)
                        local buildingRejectDirect = false
                        -- Direct checks per object class using nearby grid cells
                        if next(baseGrid) ~= nil then
                            if directReject(baseGrid, cellSize, possibleVec2.x, possibleVec2.y,
                                    (minBuildings + BUILD_PAD), neighborRangeBuildings) then
                                buildingRejectDirect = true
                            end
                        end
                        if not buildingRejectDirect and next(staticGrid) ~= nil then
                            if directReject(staticGrid, cellSize, possibleVec2.x, possibleVec2.y,
                                    (minBuildings + BUILD_PAD), neighborRangeBuildings) then
                                buildingRejectDirect = true
                            end
                        end
                        if not buildingRejectDirect and next(sceneryGrid) ~= nil then
                            if directReject(sceneryGrid, cellSize, possibleVec2.x, possibleVec2.y,
                                    (minBuildings + BUILD_PAD), neighborRangeBuildings) then
                                buildingRejectDirect = true
                            end
                        end
                        if buildingRejectDirect then
                            if _unitCounters then
                                _unitCounters.BuildingRejects = (_unitCounters.BuildingRejects or 0) + 1
                            end
                            reject = true
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
                            -- At budget: keep strict on buildings; allow fallback only when NOT a building violation.
                            if not buildingRejectDirect then
                                accepted = true
                            elseif glassBreak < operationLimit + EXTRA_ATTEMPTS_BUILDING then
                                accepted = false
                            else
                                accepted = false
                            end
                        end

                        -- Enforce strict building rejection even after operationLimit fallback.
                        if accepted then
                            local strictBuildingReject = false
                            if next(baseGrid) ~= nil and directReject(
                                    baseGrid, cellSize, possibleVec2.x, possibleVec2.y,
                                    (minBuildings + BUILD_PAD), neighborRangeBuildings
                                ) then
                                strictBuildingReject = true
                            elseif next(staticGrid) ~= nil and directReject(
                                    staticGrid, cellSize, possibleVec2.x, possibleVec2.y,
                                    (minBuildings + BUILD_PAD), neighborRangeBuildings
                                ) then
                                strictBuildingReject = true
                            elseif next(sceneryGrid) ~= nil and directReject(
                                    sceneryGrid, cellSize, possibleVec2.x, possibleVec2.y,
                                    (minBuildings + BUILD_PAD), neighborRangeBuildings
                                ) then
                                strictBuildingReject = true
                            end
                            if strictBuildingReject then
                                accepted = false
                                if _unitCounters then
                                    _unitCounters.BuildingRejects = (_unitCounters.BuildingRejects or 0) + 1
                                end
                            end
                        end

                        glassBreak = glassBreak + 1
                        if (glassBreak % math.max(1, math.floor(operationLimit / 5))) == 0 then
                            self.BRAIN:maybeYield(
                                coroutine_, "SPAWNER:generateVec2UnitPos Inner", 1)
                        end
                    until accepted

                    if _unitCounters then _unitCounters.Attempts = (_unitCounters.Attempts or 0) + glassBreak end
                    -- Accept candidate
                    unitVec2[j] = possibleVec2
                    table.insert(selectedCoords, possibleVec2)
                    gridInsert(centersGrid, cellSize, possibleVec2.x, possibleVec2.y)
                    self.BRAIN:maybeYield(coroutine_, "SPAWNER:generateVec2UnitPos Outer", 1)
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
        local cc = self.DATA.BenchmarkLog.generateVec2UnitPos.Counters or {}
        self.UTILS:debugInfo("BENCHMARK - D - generateVec2UnitPos Attempts(sum)         : " .. tostring(cc.Attempts or 0))
        self.UTILS:debugInfo("BENCHMARK - D - generateVec2UnitPos RelaxationSteps       : " ..
            tostring(cc.RelaxationSteps or 0))
        self.UTILS:debugInfo("BENCHMARK - D - generateVec2UnitPos BuildingRejects       : " ..
            tostring(cc.BuildingRejects or 0))
    end
    return self
end

--- Prepare spawn type pools and generate group type selections for the dynamic spawner.
--- @function AETHR.SPAWNER:rollSpawnGroups
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
--- @return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:rollSpawnGroups(dynamicSpawner)
    self:seedTypes(dynamicSpawner)
    self:generateGroupTypes(dynamicSpawner)
    return self
end

--- Determine concrete unit types for each group based on spawnType pools and extraTypes configuration.
--- Populates groupSizeConfig.generatedGroupTypes and generatedGroupUnitTypes.
--- @function AETHR.SPAWNER:generateGroupTypes
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
--- @return AETHR.SPAWNER self For chaining.
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
        -- Iterate group sizes in priority order; fall back to sorted keys when missing.
        local order = zoneObject.groupSizesPrio or {}
        if not order or #order == 0 then
            order = {}
            for k, _ in pairs(zoneObject.groupSettings or {}) do table.insert(order, k) end
            table.sort(order, function(a, b) return (a or 0) < (b or 0) end)
        end

        for _, size in ipairs(order) do
            ---@type _spawnerTypeConfig groupSizeConfig
            local groupSizeConfig = zoneObject.groupSettings and zoneObject.groupSettings[size]
            if groupSizeConfig then
                local _groupTypes = {}
                local _specificGroupTypes = {}
                -- Loop for the number of groups specified in the current setting.
                for _ = 1, groupSizeConfig.numGroups do
                    -- List to store types for this group.
                    local _UnitTypes = {}
                    local _specificUnitTypes = {}
                    -- Loop for the size of the group + extra units.
                    for _Unit = 1, groupSizeConfig.size do
                        -- If no draw pools available, stop filling this group
                        if (self.UTILS.sumTable(typesPool) == 0) and (self.UTILS.sumTable(nonLimitedTypesPool) == 0) then
                            break
                        end

                        -- Prefer limited pool; fall back to non-limited when exhausted
                        local _TypeK = nil
                        if self.UTILS.sumTable(typesPool) > 0 then
                            _TypeK = self.UTILS:pickRandomKeyFromTable(typesPool)
                        elseif self.UTILS.sumTable(nonLimitedTypesPool) > 0 then
                            _TypeK = self.UTILS:pickRandomKeyFromTable(nonLimitedTypesPool)
                        end
                        if not _TypeK then break end

                        local randType = spawnTypes[_TypeK]
                        -- Defensive: ensure we have candidates for the chosen type
                        if not (randType and randType.typesDB and next(randType.typesDB)) then
                            typesPool[_TypeK] = nil
                            nonLimitedTypesPool[_TypeK] = nil
                        else
                            randType.actual = (randType.actual or 0) + 1
                            if randType.actual >= randType.max then
                                typesPool[_TypeK] = nil
                            end
                            local specific = self.UTILS:pickRandomKeyFromTable(randType.typesDB)
                            if specific then
                                table.insert(_UnitTypes, _TypeK)
                                table.insert(_specificUnitTypes, specific)
                            else
                                -- Remove empty/invalid to avoid repeat nil picks
                                typesPool[_TypeK] = nil
                                nonLimitedTypesPool[_TypeK] = nil
                            end
                        end
                    end

                    -- Append extras only when their candidate pools are non-empty
                    for extraType, extraTypeInfo in pairs(extraTypes) do
                        local tdb = extraTypeInfo and extraTypeInfo.typesDB
                        if tdb and next(tdb) then
                            local minCount = extraTypeInfo.min or 0
                            for _i = 1, minCount do
                                local specific = self.UTILS:pickRandomKeyFromTable(tdb)
                                if specific then
                                    table.insert(_UnitTypes, extraType)
                                    table.insert(_specificUnitTypes, specific)
                                end
                            end
                        end
                    end

                    if _UnitTypes and #_UnitTypes > 0 then
                        table.insert(_groupTypes, _UnitTypes)
                        table.insert(_specificGroupTypes, _specificUnitTypes)
                    end
                end
                -- Add the group types list to the main group list for this iteration.
                if _groupTypes and #_groupTypes > 0 then
                    groupSizeConfig.generatedGroupTypes = _groupTypes
                    groupSizeConfig.generatedGroupUnitTypes = _specificGroupTypes
                end
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

--- Helper: normalize a spawn type key or attribute into the canonical attribute string (e.g. "Armed vehicles")
---@param keyOrAttr string
---@return string|nil
function AETHR.SPAWNER:_toSpawnAttr(keyOrAttr)
    if not keyOrAttr then return nil end
    return (self.ENUMS and self.ENUMS.spawnTypes and self.ENUMS.spawnTypes[keyOrAttr]) or keyOrAttr
end

--- Helper: reverse-map an attribute string back to its ENUM key (e.g. "Armed vehicles" -> "ArmedVehicles")
--- Uses a tiny cache to avoid repeated scans.
---@param attr string
---@return string|nil enumKey
function AETHR.SPAWNER:_attrToEnumKey(attr)
    if not attr then return nil end
    self._cache = self._cache or {}
    self._cache._attrToKey = self._cache._attrToKey or {}
    local cached = self._cache._attrToKey[attr]
    if cached ~= nil then return (cached ~= false) and cached or nil end
    for k, v in pairs(self.ENUMS and self.ENUMS.spawnTypes or {}) do
        if v == attr then
            self._cache._attrToKey[attr] = k
            return k
        end
    end
    self._cache._attrToKey[attr] = false
    return nil
end

--- Internal: resolve concrete unit types for a target spawn attribute using prioritized fallbacks.
--- Strategy:
--- 1) Primary: WORLD.DATA._spawnerAttributesDB[targetAttr] (units whose top attribute is targetAttr)
--- 2) Cross-bucket scan: iterate other prioritized buckets (high -> low by ENUMS.spawnTypesPrio)
---    and collect units whose desc.attributes include targetAttr
--- 3) Last resort: WORLD.DATA.spawnerAttributesDB[targetAttr] (unfiltered attribute map)
---
--- Returns a map typeName -> unitDesc, plus a source tag: "primary"|"cross"|"global"|"empty"
---@param targetKeyOrAttr string
---@return table<string, table> typesDB
---@return string sourceTag
function AETHR.SPAWNER:_resolveTypesForAttribute(targetKeyOrAttr)
    local attrName = self:_toSpawnAttr(targetKeyOrAttr)
    local prioritizedDB = (self.WORLD and self.WORLD.DATA and self.WORLD.DATA._spawnerAttributesDB) or {}
    local fullDB = (self.WORLD and self.WORLD.DATA and self.WORLD.DATA.spawnerAttributesDB) or {}

    if not attrName then return {}, "empty" end

    -- Primary bucket (units whose highest-priority attribute == attrName)
    local primary = prioritizedDB[attrName]
    if primary and next(primary) then
        return primary, "primary"
    end

    -- Cross-bucket scan by descending priority
    local prioMap = self.ENUMS and self.ENUMS.spawnTypesPrio or {}
    local keys = {}
    for k, _ in pairs(prioritizedDB) do
        if k ~= attrName then keys[#keys + 1] = k end
    end
    table.sort(keys, function(a, b)
        local ka = self:_attrToEnumKey(a)
        local kb = self:_attrToEnumKey(b)
        local pa = (ka and prioMap[ka]) or 0
        local pb = (kb and prioMap[kb]) or 0
        return pa > pb
    end)

    local collected = {}
    for _, otherAttr in ipairs(keys) do
        local bucket = prioritizedDB[otherAttr]
        if bucket then
            for typeName, desc in pairs(bucket) do
                local at = desc and desc.attributes
                if at and at[attrName] then
                    collected[typeName] = desc
                end
            end
            if next(collected) then
                return collected, "cross"
            end
        end
    end

    -- Last resort: global attribute table
    local global = fullDB[attrName]
    if global and next(global) then
        return global, "global"
    end

    return {}, "empty"
end

--- Seed the spawner's type pools using prioritized fallback resolution and classify limited vs non-limited.
--- @function AETHR.SPAWNER:seedTypes
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
--- @return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:seedTypes(dynamicSpawner)
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.seedTypes = { Time = {}, }
        self.DATA.BenchmarkLog.seedTypes.Time.start = os.clock()
    end

    -- Reinitialize pools to ensure no carry-over between runs
    dynamicSpawner._typesPool = {}
    dynamicSpawner._limitedTypesPool = {}
    dynamicSpawner._nonLimitedTypesPool = {}

    local typesPool = dynamicSpawner._typesPool
    local spawnTypes = dynamicSpawner.spawnTypes or {}
    local extraTypes = dynamicSpawner.extraTypes or {}

    -- Resolve spawnTypes via prioritized fallback; include only non-empty
    for typeName, typeData in pairs(spawnTypes) do
        local resolvedDB, source = self:_resolveTypesForAttribute(typeName)
        typeData.typesDB = resolvedDB or {}
        typeData.actual = 0
        typeData._typesDBSource = source
        if next(typeData.typesDB) then
            typesPool[typeName] = typeName
            if self.CONFIG and self.CONFIG.MAIN and self.CONFIG.MAIN.DEBUG_ENABLED then
                if source ~= "primary" then
                    self.UTILS:debugInfo("SPAWNER.seedTypes: fallback '" ..
                        tostring(source) .. "' used for " .. tostring(typeName))
                end
            end
        else
            if self.CONFIG and self.CONFIG.MAIN and self.CONFIG.MAIN.DEBUG_ENABLED then
                self.UTILS:debugInfo("SPAWNER.seedTypes: excluded empty type " .. tostring(typeName))
            end
        end
    end

    -- Resolve extraTypes similarly; keep counters but do not add to draw pools
    for typeName, typeData in pairs(extraTypes) do
        local resolvedDB, source = self:_resolveTypesForAttribute(typeName)
        typeData.typesDB = resolvedDB or {}
        if typeData.actual ~= nil then typeData.actual = 0 end
        typeData._typesDBSource = source
        if (not next(typeData.typesDB)) and (self.CONFIG and self.CONFIG.MAIN and self.CONFIG.MAIN.DEBUG_ENABLED) then
            self.UTILS:debugInfo("SPAWNER.seedTypes: extraType '" ..
                tostring(typeName) .. "' has no candidates (source=" .. tostring(source) .. ")")
        end
    end

    -- Classify limited vs non-limited for this generation based on filtered pool
    for k, _ in pairs(typesPool) do
        local _type = spawnTypes[k]
        if _type and _type.limited then
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

--- Convert the total spawn count into discrete group sizes/counts per subzone according to configured priorities.
--- Writes into zoneObject_.groupSettings[size].numGroups and .size.
--- @function AETHR.SPAWNER:rollSpawnGroupSizes
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
--- @return AETHR.SPAWNER self For chaining.
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

--- Calculate spawn amounts for main zone and distribute to subzones. Applies nudging and then calls _Jiggle to rebalance.
--- @function AETHR.SPAWNER:generateSpawnAmounts
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
--- @return AETHR.SPAWNER self For chaining.
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

--- Apply multiple small random update iterations to settle spawn amounts across subzones.
--- Calls _RollUpdates N times where N = spawnSettingsMainGenerated.nudgeReciprocal.
--- @function AETHR.SPAWNER:_Jiggle
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
--- @return AETHR.SPAWNER self For chaining.
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
---@return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:_RollUpdates(dynamicSpawner)
    dynamicSpawner:_seedRollUpdates():_introduceRandomness():_distributeDifference():_assignAndUpdateSubZones()
    return self
end

--- Generate main and subzones (circles) for the dynamic spawner using POLY:generateSubCircles.
--- Stores resulting _spawnerZone objects in dynamicSpawner.zones.sub and dynamicSpawner.zones.main.
--- @function AETHR.SPAWNER:generateSpawnerZones
--- @param dynamicSpawner _dynamicSpawner Dynamic spawner instance.
--- @return AETHR.SPAWNER self For chaining.
function AETHR.SPAWNER:generateSpawnerZones(dynamicSpawner)
    if self.DATA.CONFIG.Benchmark then
        self.DATA.BenchmarkLog.generateSpawnerZones = { Time = {}, }
        self.DATA.BenchmarkLog.generateSpawnerZones.Time.start = os.clock()
    end
    -- if self.CONFIG.MAIN.DEBUG_ENABLED then
    --     self.MARKERS:removeMarksByID(self.DATA.debugMarkers)
    --     self.DATA.debugMarkers = {}
    -- end


    -- Reset subzones each generation to prevent accumulation across runs
    dynamicSpawner.zones.sub = {}
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
--- Behavior:
---  - Always checks against no-go surfaces (e.g., WATER, RUNWAY, SHALLOW_WATER) configured in SPAWNER.DATA.CONFIG.NoGoSurfaces.
---  - When SPAWNER.DATA.CONFIG.UseRestrictedZonePolys == true, also checks polygonal restricted zones using an AABB prefilter
---    followed by [AETHR.POLY:pointInPolygon()](dev/POLY.lua:61). If the point lies within any restricted polygon, it is NOGO.
---
--- Performance/trade-offs:
---  - Surface checks are cheap and always enabled.
---  - Polygon checks are more expensive; they are disabled by default for performance parity with prior behavior.
---    Enable them when spatial accuracy near mission-defined restricted areas is more important than raw generation speed.
---
--- @param vec2 _vec2 The vector position to be checked.
--- @param restrictedZones table A list of restricted zones to check against (tables with .vertices or raw vertex arrays).
--- @return boolean isNOGO True if vec2 lies on a NOGO surface or inside a restricted polygon (when enabled), false otherwise.
function AETHR.SPAWNER:checkIsInNOGO(vec2, restrictedZones)
    local isNOGO = false
    if self:vec2AtNoGoSurface(vec2) then isNOGO = true end

    if not isNOGO and (self.DATA.CONFIG.UseRestrictedZonePolys == true) and type(restrictedZones) == "table" then
        local p = self.POLY:normalizePoint(vec2)
        for _, zone in pairs(restrictedZones) do
            local verts = (type(zone) == "table" and (zone.vertices or zone)) or nil
            if type(verts) == "table" and #verts >= 3 then
                -- AABB prefilter
                local minx, maxx = math.huge, -math.huge
                local miny, maxy = math.huge, -math.huge
                for i = 1, #verts do
                    local vx = verts[i].x or 0
                    local vy = verts[i].y or verts[i].z or 0
                    if vx < minx then minx = vx end
                    if vx > maxx then maxx = vx end
                    if vy < miny then miny = vy end
                    if vy > maxy then maxy = vy end
                end
                if p.x >= minx and p.x <= maxx and p.y >= miny and p.y <= maxy then
                    if self.POLY:pointInPolygon(p, verts) then
                        isNOGO = true
                        break
                    end
                end
            end
        end
    end

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

---@param airbase _airbase
---@param countryID  number
---@param dynamicSpawner _dynamicSpawner
function AETHR.SPAWNER:spawnAirbaseFill(airbase, countryID, dynamicSpawner)
    local airbaseVec2 = { x = airbase.longestRunway.position.x, y = airbase.longestRunway.position.z }
    local minRad = airbase.longestRunway.length / 2
    local maxRad = airbase.longestRunway.length
    local nominalRadius = (minRad + maxRad) / 2
    self:enqueueGenerateDynamicSpawner(dynamicSpawner, airbaseVec2,
        minRad, nominalRadius, maxRad, .5, countryID, true)
    --  return self
end

---@param cluster _dbCluster
---@param countryID  number
---@param dynamicSpawner _dynamicSpawner
function AETHR.SPAWNER:spawnDBClusterFill(cluster, countryID, dynamicSpawner)
    local vec2 = cluster.Center
    local minRad = cluster.Radius
    local maxRad = (cluster.Radius * 2)
    local nominalRadius = (minRad + maxRad) / 2
    self:enqueueGenerateDynamicSpawner(dynamicSpawner, vec2,
        minRad, nominalRadius, maxRad, .5, countryID, true)
end
