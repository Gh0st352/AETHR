--- Top-level prototype table for the framework. Mutable per-instance tables are created
--- inside :New to avoid accidental shared-state mutation between instances.
--- @class AETHR
--- @brief Core AETHR framework for DCS World mission management.
--- @author Gh0st352
--- @diagnostic disable: undefined-global
--- @field POLY AETHR.POLY Geometry helper table attached per-instance.
--- @field WORLD AETHR.WORLD World learning submodule attached per-instance.
--- @field CONFIG AETHR.CONFIG World learning submodule attached per-instance.
--- @field MATH AETHR.MATH Math helper table attached per-instance.
--- @field ZONE_MANAGER AETHR.ZONE_MANAGER Zone management submodule attached per-instance.
--- @field MARKERS AETHR.MARKERS
--- @field MODULES string[] Names of module tables on the prototype which will be auto-wired into instances.
--- @field USERSTORAGE table Container for per-user saved data.
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
    },
    USERSTORAGE = {}, -- Holds per-user saved data tables.

}

--- Creates a new AETHR instance with optional mission ID override.
--- Returns a new table with a metatable pointing back to the prototype.
--- Mutable sub-tables are shallow-cloned so instance changes won't mutate the prototype.
--- @function AETHR:New
--- @param mission_id string|nil Optional mission identifier (defaults to configured ID).
--- @return AETHR instance New instance inheriting AETHR methods.
function AETHR:New(mission_id)
    ---@type AETHR
    local instance = setmetatable({}, { __index = self })

    -- Safe shallow-copy helper to avoid shared mutable state between instances.
    local function shallow_copy(t)
        if type(t) ~= "table" then return t end
        local out = {}
        for k, v in pairs(t) do out[k] = v end
        return out
    end

    -- Apply mission id (prefer provided id, then prototype config, then "1")
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
        instance.CONFIG = { MAIN = { STORAGE = { PATHS = {}, FILENAMES = {} } } }
    end

    -- Set mission id on the instance config
    instance.CONFIG.MAIN.MISSION_ID = id

    -- Resolve writable directory. Do NOT mutate prototype; write only to instance.
    local ok, lfs = pcall(require, "lfs")
    if ok and type(lfs.writedir) == "function" then
        local rt_path = lfs.writedir()
        instance.CONFIG.MAIN.STORAGE.SAVEGAME_DIR = rt_path
    else
        instance.CONFIG.MAIN.STORAGE.SAVEGAME_DIR = instance.CONFIG.MAIN.STORAGE.SAVEGAME_DIR or ""
    end

    -- Ensure CONFIG.PATHS.CONFIG_FOLDER is computed using available FILEOPS (prototype methods are reachable via metatable)
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
--- @function AETHR:Init
--- @return AETHR self Initialized framework instance.
function AETHR:Init()
    -- Defensive checks.
    if not (self.CONFIG.MAIN and self.CONFIG.MAIN.STORAGE) then
        return self
    end

    local subFolders = self.CONFIG.MAIN.STORAGE.SUB_FOLDERS or {}

    -- Ensure storage subdirectories exist and cache their full paths.
    for folderName, folderPath in pairs(subFolders) do
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

    self.WORLD:initSceneryInDivisions()
    self.WORLD:initBaseInDivisions()
    self.WORLD:initStaticInDivisions()



    if self.UTILS.sumTable(self.ZONE_MANAGER.DATA.MIZ_ZONES) > 0 then
        self.ZONE_MANAGER:initGameZoneBoundaries()  -- Load or generate out of bounds information.
        self.ZONE_MANAGER:drawMissionZones()
        self.ZONE_MANAGER:drawGameBounds()
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
    self:BackgroundProcesses()
    return self
end

--- Starts or re-schedules background processes for the framework.
--- Schedules BRAIN:runScheduledTasks to be invoked periodically and triggers an immediate run.
--- @function AETHR:BackgroundProcesses
--- @return AETHR self Framework instance (for chaining).
function AETHR:BackgroundProcesses()
    -- Schedule periodic execution of runScheduledTasks using a bound closure
    self.BRAIN:scheduleTask(
        function() self:BackgroundProcesses() end,
        0,
        self.BRAIN.DATA.mainScheduleLoopInterval
    )
    -- Run once immediately
    self.BRAIN:runScheduledTasks()
    return self
end

--- @function AETHR:loadUSERSTORAGE
--- @brief Loads user-specific data if available.
--- @return AETHR self Framework instance for chaining.
function AETHR:loadUSERSTORAGE()
    -- Attempt to load userStorage JSON file.
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
--- @return AETHR self Framework instance for chaining.
function AETHR:saveUSERSTORAGE()
    self.FILEOPS:saveData(
        self.CONFIG.MAIN.STORAGE.PATHS.USER_FOLDER,
        self.CONFIG.MAIN.STORAGE.FILENAMES.USER_STORAGE_FILE,
        self.USERSTORAGE
    )
    return self
end
