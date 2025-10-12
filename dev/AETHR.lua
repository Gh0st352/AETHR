--- Top-level prototype table for the framework. Mutable per-instance tables are created
--- inside :New to avoid accidental shared-state mutation between instances.
--- @class AETHR
--- @brief Core AETHR framework for DCS World mission management.
--- @author Gh0st352
--- @diagnostic disable: undefined-global
---
--- Type aliases (partial shapes) used by this file to improve editor IntelliSense.
--- These are intentionally minimal and describe only the fields accessed by AETHR.lua.
---@alias AETHR_ConfigMainStoragePaths table<string, string> Map of named storage paths (computed at runtime)
---@alias AETHR_ConfigMainStorageFILENAMES table<string, string> Map of filenames used for persisted data
---@alias AETHR_ConfigMainStorage table{
---  SAVEGAME_DIR?: string,
---  ROOT_FOLDER?: string,
---  CONFIG_FOLDER?: string,
---  PATHS?: AETHR_ConfigMainStoragePaths,
---  FILENAMES?: AETHR_ConfigMainStorageFILENAMES,
---  SUB_FOLDERS?: table<string, string>
---}
---@alias AETHR_ConfigMainFlags table{ LEARN_WORLD_OBJECTS?: boolean }
---@alias AETHR_ConfigMain table{
---  MISSION_ID?: string,
---  THEATER?: string,
---  STORAGE?: AETHR_ConfigMainStorage,
---  FLAGS?: AETHR_ConfigMainFlags
---}
---
--- Top-level prototype fields.
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field CONFIG AETHR.CONFIG Config manager submodule attached per-instance.
--- @field MATH AETHR.MATH Math helper table attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field MARKERS AETHR.MARKERS Marker helper submodule attached per-instance.
--- @field BRAIN AETHR.BRAIN Task scheduler and coroutine manager.
--- @field FILEOPS AETHR.FILEOPS Filesystem utilities used to load/save JSON and manage paths.
--- @field MODULES string[] Names of module tables on the prototype which will be auto-wired into instances.
--- @field USERSTORAGE table<string, any> Container for per-user saved data.
AETHR = {
    MODULES     = {
        "AUTOSAVE",
        "ZONE_MANAGER",
        "WORLD",
        "FILEOPS",
        "POLY",
        "MATH",
        "ENUMS",
        "CONFIG",
        "UTILS",
        "MARKERS",
        "BRAIN",
        "SPAWNER",
        "FSM",
        "AI",
    },
    USERSTORAGE = {}, -- Holds per-user saved data tables.

}

--- Creates a new AETHR instance with optional mission ID override.
--- Returns a new table with a metatable pointing back to the prototype.
--- Mutable sub-tables are shallow-cloned so instance changes won't mutate the prototype.
---@param mission_id string|nil Optional mission identifier (defaults to configured ID).
---@return AETHR instance New instance inheriting AETHR methods.
function AETHR:New(mission_id)
    ---@type AETHR
    local instance = setmetatable({}, { __index = self })

    -- Safe shallow-copy helper to avoid shared mutable state between instances.
    ---@generic T
    ---@param t T|any
    ---@return T|any
    local function shallow_copy(t)
        if type(t) ~= "table" then return t end
        local out = {}
        for k, v in pairs(t) do out[k] = v end
        return out
    end

    -- Apply mission id (prefer provided id, then prototype config, then "1")
    ---@type string
    local id = mission_id or
        ((self.CONFIG and self.CONFIG.MAIN and self.CONFIG.MAIN.MISSION_ID) and self.CONFIG.MAIN.MISSION_ID) or "1"

    -- Create instance-local copies of mutable configuration subtables to prevent prototype mutation.
    if type(self.CONFIG) == "table" then
        instance.CONFIG = shallow_copy(self.CONFIG)
        if type(self.CONFIG.MAIN) == "table" then
            instance.CONFIG.MAIN = shallow_copy(self.CONFIG.MAIN)
            -- STORAGE contains nested mutable tables we want instance-scoped
            if type(self.CONFIG.MAIN.STORAGE) == "table" then
                instance.CONFIG.MAIN.STORAGE = shallow_copy(self.CONFIG.MAIN.STORAGE)
                instance.CONFIG.MAIN.STORAGE.PATHS = shallow_copy(self.CONFIG.MAIN.STORAGE.PATHS or {})
                instance.CONFIG.MAIN.STORAGE.FILENAMES = shallow_copy(self.CONFIG.MAIN.STORAGE.FILENAMES or {})
            else
                instance.CONFIG.MAIN.STORAGE = {}
                instance.CONFIG.MAIN.STORAGE.PATHS = {}
                instance.CONFIG.MAIN.STORAGE.FILENAMES = {}
            end
        else
            instance.CONFIG.MAIN = {}
            instance.CONFIG.MAIN.STORAGE = { PATHS = {}, FILENAMES = {} }
        end
    else
        instance.CONFIG = { MAIN = { STORAGE = { PATHS = {}, FILENAMES = {} } } } ---@diagnostic disable-line
    end

    -- Set mission id on the instance config
    instance.CONFIG.MAIN.MISSION_ID = id

    -- Resolve writable directory. Do NOT mutate prototype; write only to instance.
    ---@type boolean, table|nil
    local ok, lfs = pcall(require, "lfs")
    if ok and type(lfs.writedir) == "function" then
        local rt_path = lfs.writedir()
        instance.CONFIG.MAIN.STORAGE.SAVEGAME_DIR = rt_path
    else
        instance.CONFIG.MAIN.STORAGE.SAVEGAME_DIR = instance.CONFIG.MAIN.STORAGE.SAVEGAME_DIR or ""
    end

    -- Ensure CONFIG.PATHS.CONFIG_FOLDER is computed using available FILEOPS (prototype methods are reachable via metatable)
    ---@type AETHR.FILEOPS|table|nil
    local joiner = instance.FILEOPS or self.FILEOPS
    if joiner and type(joiner.joinPaths) == "function" then
        instance.CONFIG.MAIN.STORAGE.PATHS.CONFIG_FOLDER = joiner:joinPaths(
            instance.CONFIG.MAIN.STORAGE.SAVEGAME_DIR,
            instance.CONFIG.MAIN.STORAGE.ROOT_FOLDER or "",
            instance.CONFIG.MAIN.STORAGE.CONFIG_FOLDER or ""
        )
    else
        -- fallback to simple concat using package.config separator
        local sep = package.config:sub(1, 1)
        instance.CONFIG.MAIN.STORAGE.PATHS.CONFIG_FOLDER = table.concat({
            instance.CONFIG.MAIN.STORAGE.SAVEGAME_DIR,
            instance.CONFIG.MAIN.STORAGE.ROOT_FOLDER or "",
            instance.CONFIG.MAIN.STORAGE.CONFIG_FOLDER or ""
        }, sep)
    end

    -- Capture the current theater for this instance if available (do not mutate prototype)
    if env and env.mission and env.mission.theatre then
        instance.CONFIG.MAIN.THEATER = env.mission.theatre
    end

    -- Attach instance-scoped helpers/submodules so submodules can reference parent resources.
    -- Use the master AETHR.MODULES list so new modules can be registered by updating that list only.
    ---@type string[]
    local modulesList = {}
    if type(self.MODULES) == "table" then
        for _, modName in ipairs(self.MODULES) do
            table.insert(modulesList, modName)
        end
    end

    -- Phase 1: Construct instance-scoped submodules (call :New(instance) where present).
    for _, name in ipairs(modulesList) do
        local mod = self[name]
        if instance[name] == nil and type(mod) == "table" then
            if type(mod.New) == "function" then
                local ok, sub = pcall(function() return mod:New(instance) end)
                if ok and type(sub) == "table" then
                    instance[name] = sub
                else
                    instance[name] = mod
                end
            else
                instance[name] = mod
            end
        end
    end

    -- Phase 2: Ensure each constructed submodule has direct back-references to the parent AETHR
    -- and convenient references to sibling submodules (so submodules can call each other via self.<module>).
    for _, name in ipairs(modulesList) do
        local sub = instance[name]
        if type(sub) == "table" then
            -- Ensure parent reference exists
            if sub.AETHR == nil then sub.AETHR = instance end

            -- Copy sibling module references into the submodule for direct access (shallow references only)
            for _, siblingName in ipairs(modulesList) do
                if siblingName ~= name and type(instance[siblingName]) == "table" then
                    if sub[siblingName] == nil then
                        sub[siblingName] = instance[siblingName]
                    end
                end
            end
        end
    end

    return instance
end

--- Initializes AETHR by preparing directories and loading or saving mission data.
--- This method creates required storage folders, caches their resolved paths, and
--- invokes submodule init routines (CONFIG, ZONE_MANAGER, WORLD).
--- @function AETHR:Init
--- @return AETHR self Initialized framework instance.
function AETHR:Init()
    -- Defensive checks.
    if not (self.CONFIG.MAIN and self.CONFIG.MAIN.STORAGE) then
        return self
    end

    ---@type table<string, string>
    local subFolders = self.CONFIG.MAIN.STORAGE.SUB_FOLDERS or {}

    -- Ensure storage subdirectories exist and cache their full paths.
    for folderName, folderPath in pairs(subFolders) do
        ---@type string
        local fullPath = self.FILEOPS:joinPaths(self.CONFIG.MAIN.STORAGE.SAVEGAME_DIR,
            self.CONFIG.MAIN.STORAGE.ROOT_FOLDER, self.CONFIG.MAIN.MISSION_ID, folderPath)

        self.CONFIG.MAIN.STORAGE.PATHS[folderName] = fullPath -- Cache path.
        self.FILEOPS:ensureDirectory(fullPath)                -- Create directory if missing (best-effort).
    end

    -- Load or generate core configuration and data structures.
    self.CONFIG:initConfig()            -- Load or generate or config defaults.
    self.ZONE_MANAGER:initMizZoneData() -- Load or generate mission trigger zones.
    self.WORLD:initWorldDivisions()     -- Load or generate world division grid.
    self.WORLD:initActiveDivisions()    -- Load or generate active divisions in mission.
    self.WORLD:initMizFileCache()      -- Cache MIZ file data for world learning.

    if self.CONFIG.MAIN.FLAGS.LEARN_WORLD_OBJECTS then
        self.WORLD:initSceneryInDivisions()
        self.WORLD:initBaseInDivisions()
        self.WORLD:initStaticInDivisions()
    end
    if self.UTILS.sumTable(self.ZONE_MANAGER.DATA.MIZ_ZONES) > 0 then
        self.ZONE_MANAGER:initZoneArrows()
        self.ZONE_MANAGER:initGameZoneBoundaries() -- Load or generate out of bounds information.
        self.ZONE_MANAGER:drawMissionZones()
        self.ZONE_MANAGER:drawGameBounds()
        self.ZONE_MANAGER:drawZoneArrows()
        self.ZONE_MANAGER:pairActiveDivisions()
        self.WORLD:initTowns()
        self.ZONE_MANAGER:pairTowns()
    end

    self:loadUSERSTORAGE() -- Load per-user storage data.
    self:saveUSERSTORAGE() -- Persist current user storage data.
    self.CONFIG:saveConfig()


    return self
end

--- Starts the AETHR framework and schedules background processes.
--- @function AETHR:Start
--- @return AETHR self Framework instance (for chaining).
function AETHR:Start()

    self.WORLD:updateAirbaseOwnership()
    timer.scheduleFunction(self.BackgroundProcesses, self, timer.getTime() + self.BRAIN.DATA.BackgroundLoopInterval)

    self:setupWatchers()
    return self
end

--- Starts or re-schedules background processes for the framework.
--- Schedules BRAIN:runScheduledTasks to be invoked periodically and triggers an immediate run.
--- IMPORTANT: This function is intended to be scheduled by DCS timer.scheduleFunction and must
--- return the absolute mission time (number) for the next invocation.
--- @function AETHR:BackgroundProcesses
--- @return number nextTime Absolute mission time for the next invocation.
function AETHR:BackgroundProcesses()
    --self.UTILS:debugInfo("AETHR:BackgroundProcesses         -------------")
    local now = timer.getTime()

    -- COROUTINES

    --Airfield Ownership
    ---@param parentAETHR AETHR
    self.BRAIN:doRoutine(self.BRAIN.DATA.coroutines.updateAirfieldOwnership, function(parentAETHR)
        parentAETHR.WORLD:updateAirbaseOwnership()
    end, self)

    --Zone Ownership
    ---@param parentAETHR AETHR
    self.BRAIN:doRoutine(self.BRAIN.DATA.coroutines.updateZoneOwnership, function(parentAETHR)
        parentAETHR.WORLD:updateZoneOwnership()
    end, self)

    --Update Zone Color
    ---@param parentAETHR AETHR
    self.BRAIN:doRoutine(self.BRAIN.DATA.coroutines.updateZoneColors, function(parentAETHR)
        parentAETHR.WORLD:updateZoneColors()
    end, self)

    --Update Zone Arrows
    ---@param parentAETHR AETHR
    self.BRAIN:doRoutine(self.BRAIN.DATA.coroutines.updateZoneArrows, function(parentAETHR)
        parentAETHR.WORLD:updateZoneArrows()
    end, self)

    --Update groundUnits DB
    ---@param parentAETHR AETHR
    self.BRAIN:doRoutine(self.BRAIN.DATA.coroutines.updateGroundUnitsDB, function(parentAETHR)
        parentAETHR.WORLD:updateGroundUnitsDB()
    end, self)

    --Spawn queued ground Groups
    ---@param parentAETHR AETHR
    self.BRAIN:doRoutine(self.BRAIN.DATA.coroutines.spawnGroundGroups, function(parentAETHR)
        parentAETHR.WORLD:spawnGroundGroups()
    end, self)

    --deSpawn queued ground Groups
    ---@param parentAETHR AETHR
    self.BRAIN:doRoutine(self.BRAIN.DATA.coroutines.despawnGroundGroups, function(parentAETHR)
        parentAETHR.WORLD:despawnGroundGroups()
    end, self)
    
    --Spawner generation job queue
    ---@param parentAETHR AETHR
    self.BRAIN:doRoutine(self.BRAIN.DATA.coroutines.spawnerGenerationQueue, function(parentAETHR)
        parentAETHR.WORLD:spawnerGenerationQueue()
    end, self)

    -- FSM Queue Processor: progress queued and async FSM transitions
    ---@param parentAETHR AETHR
    self.BRAIN:doRoutine(self.BRAIN.DATA.coroutines.processFSMQueue, function(parentAETHR)
        parentAETHR.FSM:processQueue(parentAETHR)
    end, self)

    self.BRAIN:runScheduledTasks(2)
    return now + (self.BRAIN and self.BRAIN.DATA and self.BRAIN.DATA.BackgroundLoopInterval or 0.5)
end

--- Initializes various watchers used by AETHR to observe game / mission state events.
--- @function AETHR:setupWatchers
--- @return AETHR self For chaining.
function AETHR:setupWatchers()
    self.ZONE_MANAGER:initWatcher_AirbaseOwnership()
    self.ZONE_MANAGER:initWatcher_ZoneOwnership()
    return self
end

--- @function AETHR:loadUSERSTORAGE
--- @brief Loads user-specific data if available.
--- Attempts to load a JSON user storage file from configured USER_FOLDER.
--- @return AETHR self Framework instance for chaining.
function AETHR:loadUSERSTORAGE()
    -- Attempt to load userStorage JSON file.
    ---@type table|nil
    local userData = self.FILEOPS:loadData(
        self.CONFIG.MAIN.STORAGE.PATHS.USER_FOLDER,
        self.CONFIG.MAIN.STORAGE.FILENAMES.USER_STORAGE_FILE
    )
    if userData then
        self.USERSTORAGE = userData -- Update in-memory storage.
    end
    return self
end

--- @function AETHR:saveUSERSTORAGE
--- @brief Saves the `USERSTORAGE` table to file.
--- Delegates to FILEOPS:saveData which should accept (folder, filename, table).
--- @return AETHR self Framework instance for chaining.
function AETHR:saveUSERSTORAGE()
    self.FILEOPS:saveData(
        self.CONFIG.MAIN.STORAGE.PATHS.USER_FOLDER,
        self.CONFIG.MAIN.STORAGE.FILENAMES.USER_STORAGE_FILE,
        self.USERSTORAGE
    )
    return self
end
