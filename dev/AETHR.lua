--- @module AETHR
--- @brief Core AETHR framework for DCS World mission management.
--- @author Gh0st352
---@diagnostic disable: undefined-global

--- Top-level prototype table for the framework. Mutable per-instance tables are created
--- inside :New to avoid accidental shared-state mutation between instances.
--- @class AETHR
--- @field USERSTORAGE table Container for per-user saved data.
--- @field LEARNED_DATA table Holds learned data: worldDivisions, saveDivisions, divisionObjects.
--- @field AIRBASES table Collected airbase information.
--- @field MIZ_ZONES table<string, _MIZ_ZONE> Loaded mission trigger zones.
--- @field ROOT_DIR string Absolute path to the DCS savegame writable directory root.
AETHR = {
    USERSTORAGE  = {},          -- Holds per-user saved data tables.
    LEARNED_DATA = {            -- Stores learned datasets for world and divisions.
        worldDivisions  = {},   -- Grid division definitions keyed by ID.
        saveDivisions   = {},   -- Active divisions keyed by ID.
        divisionObjects = {},   -- Loaded objects per division.
    },
    MIZ_ZONES    = {},          -- Mission trigger zones keyed by name.
    AIRBASES     = {},          -- Airbase descriptors keyed by displayName.
    ROOT_DIR     = "",
}

--- Creates a new AETHR instance with optional mission ID override.
--- Returns a new table with a metatable pointing back to the prototype.
--- Mutable sub-tables are shallow-cloned so instance changes won't mutate the prototype.
--- @function AETHR:New
--- @param mission_id string|nil Optional mission identifier (defaults to configured ID).
--- @return AETHR instance New instance inheriting AETHR methods.
function AETHR:New(mission_id)
    local id = mission_id or (self.CONFIG and self.CONFIG.MISSION_ID) or "1"

    -- Instance inherits methods/values via metatable; we'll provide instance-specific
    -- copies of mutable tables (CONFIG.STORAGE.PATHS, MIZ_ZONES, USERSTORAGE, etc).
    local instance = setmetatable({}, { __index = self })

    -- Helper: shallow clone a table (one level). Defined inside function per constraints.
    local function shallowClone(tbl)
        if type(tbl) ~= "table" then return tbl end
        local out = {}
        for k, v in pairs(tbl) do
            out[k] = v
        end
        return out
    end

    -- Ensure instance-specific containers.
    instance.MIZ_ZONES = {}
    instance.USERSTORAGE = shallowClone(self.USERSTORAGE)
    instance.LEARNED_DATA = {
        worldDivisions  = shallowClone(self.LEARNED_DATA and self.LEARNED_DATA.worldDivisions or {}),
        saveDivisions   = shallowClone(self.LEARNED_DATA and self.LEARNED_DATA.saveDivisions or {}),
        divisionObjects = shallowClone(self.LEARNED_DATA and self.LEARNED_DATA.divisionObjects or {}),
    }
    instance.AIRBASES = shallowClone(self.AIRBASES)

    -- Clone CONFIG shallowly and ensure STORAGE/PATHS are separate tables for the instance.
    instance.CONFIG = shallowClone(self.CONFIG or {})
    if instance.CONFIG.STORAGE then
        instance.CONFIG.STORAGE = shallowClone(self.CONFIG.STORAGE)
        instance.CONFIG.STORAGE.PATHS = shallowClone(self.CONFIG.STORAGE.PATHS or {})
    else
        instance.CONFIG.STORAGE = { PATHS = {} }
    end

    -- Apply mission id for this instance.
    instance.CONFIG.MISSION_ID = id

    -- Resolve writable root directory and cache it on both prototype and instance.
    local lfs = require("lfs")
    local rt_path = lfs.writedir()
    AETHR.ROOT_DIR = rt_path
    instance.ROOT_DIR = rt_path

    -- Compute config folder path safely, prefer instance.fileOps if present.
    local joinPaths = (instance.fileOps and instance.fileOps.joinPaths) or (AETHR.fileOps and AETHR.fileOps.joinPaths)
    instance.CONFIG.STORAGE.PATHS.CONFIG_FOLDER = joinPaths(
        rt_path,
        instance.CONFIG.STORAGE.ROOT_FOLDER,
        instance.CONFIG.STORAGE.CONFIG_FOLDER
    )

    -- Capture the current theater for this instance if available.
    if env and env.mission then
        instance.CONFIG.THEATER = env.mission.theatre
    end

    return instance
end

--- Initializes AETHR by preparing directories and loading or saving mission data.
--- @function AETHR:Init
--- @return AETHR self Initialized framework instance.
function AETHR:Init()
    -- Defensive checks.
    if not (self.CONFIG and self.CONFIG.STORAGE) then
        return self
    end

    local subFolders = self.CONFIG.STORAGE.SUB_FOLDERS or {}
    local joinPaths = (self.fileOps and self.fileOps.joinPaths) or (AETHR.fileOps and AETHR.fileOps.joinPaths)
    local ensureDirectory = (self.fileOps and self.fileOps.ensureDirectory) or
    (AETHR.fileOps and AETHR.fileOps.ensureDirectory)

    -- Ensure storage subdirectories exist and cache their full paths.
    for folderName, folderPath in pairs(subFolders) do
        local fullPath = joinPaths(self.ROOT_DIR, self.CONFIG.STORAGE.ROOT_FOLDER, self.CONFIG.MISSION_ID, folderPath)

        self.CONFIG.STORAGE.PATHS[folderName] = fullPath -- Cache path.
        ensureDirectory(fullPath)                        -- Create directory if missing (best-effort).
    end

    -- Load or generate core configuration and data structures.
    self:initConfig()          -- Load config or write defaults.
    self:initMizZoneData()     -- Load or generate mission trigger zones.
    self:initWorldDivisions()  -- Generate or load world division grid.
    self:initActiveDivisions() -- Identify active divisions in mission.
    self:getAirbases()        -- Collect airbase data.

     self:initUSERSTORAGE()      -- Load per-user storage data.
    -- self:SaveUSERSTORAGE()      -- Persist current user storage data.

    -- self:SaveConfig()
    return self
end

--- Sets mission trigger zone names (all, red and blue start).
--- @function AETHR:setMizZones
--- @param zoneNames string[] List of all mission trigger zone names.
--- @param RedStartZones string[]|nil Optional list of Red start mission trigger zones.
--- @param BlueStartZones string[]|nil Optional list of Blue start mission trigger zones.
--- @return AETHR self
function AETHR:setMizZones(zoneNames, RedStartZones, BlueStartZones)
    if not self.CONFIG then self.CONFIG = {} end
    if not self.CONFIG.MIZ_ZONES then self.CONFIG.MIZ_ZONES = { ALL = {}, REDSTART = {}, BLUESTART = {} } end
    self.CONFIG.MIZ_ZONES.ALL = zoneNames or {}
    if RedStartZones then self:setRedStartMizZones(RedStartZones) end
    if BlueStartZones then self:setBlueStartMizZones(BlueStartZones) end
    return self
end

--- Sets Red start mission trigger zones.
--- @function AETHR:setRedStartMizZones
--- @param zoneNames string[] List of Red start mission trigger zone names.
--- @return AETHR self
function AETHR:setRedStartMizZones(zoneNames)
    if not self.CONFIG then self.CONFIG = {} end
    if not self.CONFIG.MIZ_ZONES then self.CONFIG.MIZ_ZONES = { ALL = {}, REDSTART = {}, BLUESTART = {} } end
    self.CONFIG.MIZ_ZONES.REDSTART = zoneNames or {}
    return self
end

--- Sets Blue start mission trigger zones.
--- @function AETHR:setBlueStartMizZones
--- @param zoneNames string[] List of Blue start mission trigger zone names.
--- @return AETHR self
function AETHR:setBlueStartMizZones(zoneNames)
    if not self.CONFIG then self.CONFIG = {} end
    if not self.CONFIG.MIZ_ZONES then self.CONFIG.MIZ_ZONES = { ALL = {}, REDSTART = {}, BLUESTART = {} } end
    self.CONFIG.MIZ_ZONES.BLUESTART = zoneNames or {}
    return self
end

--- Initializes mission trigger zone data, loading existing or generating defaults.
--- @function AETHR:initMizZoneData
--- @return AETHR self
function AETHR:initMizZoneData()
    local data = self:loadMizZoneData()
    if data and type(data) == "table" then
        self.MIZ_ZONES = data
    else
        self:generateMizZoneData()
        self:saveMizZoneData()
    end
    return self
end

--- Loads mission trigger zone data from storage file if available.
--- @function AETHR:loadMizZoneData
--- @return table<string, _MIZ_ZONE>|nil Data table of mission trigger zones or nil if not found.
function AETHR:loadMizZoneData()
    local mapPath = self.CONFIG.STORAGE.PATHS.MAP_FOLDER
    local saveFile = self.CONFIG.STORAGE.FILENAMES and self.CONFIG.STORAGE.FILENAMES.MIZ_ZONES_FILE
    local data = self.fileOps.loadData(mapPath, saveFile)
    if data then return data end
    return nil
end

--- Saves current mission trigger zone data to storage file.
--- @function AETHR:saveMizZoneData
--- @return nil
function AETHR:saveMizZoneData()
    local mapPath = self.CONFIG.STORAGE.PATHS.MAP_FOLDER
    local saveFile = self.CONFIG.STORAGE.FILENAMES and self.CONFIG.STORAGE.FILENAMES.MIZ_ZONES_FILE
    self.fileOps.saveData(mapPath, saveFile, self.MIZ_ZONES)
end

--- Generates mission trigger zone data based on configured zone names and environment data.
--- Guards against missing env structures and missing constructors.
--- @function AETHR:generateMizZoneData
--- @return AETHR self
function AETHR:generateMizZoneData()
    local zoneNames = (self.CONFIG and self.CONFIG.MIZ_ZONES and self.CONFIG.MIZ_ZONES.ALL) or {}
    if not zoneNames or #zoneNames == 0 then
        return self
    end

    local envZones = {}
    if env.mission.triggers.zones then envZones = env.mission.triggers.zones end

    local mzCtor = self._MIZ_ZONE or AETHR._MIZ_ZONE
    for _, zoneName in ipairs(zoneNames) do
        for _, envZone in ipairs(envZones) do
            if envZone and envZone.name == zoneName then
                self.MIZ_ZONES[zoneName] = mzCtor:New(envZone)
                break
            end
        end
    end
    self.MIZ_ZONES = self.ZONE_MANAGER.determineBorderingZones(self.MIZ_ZONES)
    return self
end

function AETHR:loadActiveDivisions()
    local mapPath = self.CONFIG.STORAGE.PATHS.MAP_FOLDER
    local saveFile = self.CONFIG.STORAGE.FILENAMES.SAVE_DIVS_FILE
    local data = self.fileOps.loadData(mapPath, saveFile)
    if data then
        return data
    end
    return nil
end

function AETHR:saveActiveDivisions()
    local mapPath = self.CONFIG.STORAGE.PATHS.MAP_FOLDER
    local saveFile = self.CONFIG.STORAGE.FILENAMES.SAVE_DIVS_FILE
    self.fileOps.saveData(mapPath, saveFile, self.LEARNED_DATA.saveDivisions)
end

function AETHR:generateActiveDivisions()
    -- Compute active flags by intersection
    local updated = self.AUTOSAVE.checkDivisionsInZones(
        self.LEARNED_DATA.worldDivisions,
        self.MIZ_ZONES
    )
    for _, div in ipairs(updated) do
        if div.active then
            self.LEARNED_DATA.saveDivisions[div.ID] = div
        end
    end
    return self
end

--- Loads existing world divisions if available; otherwise generates and saves new divisions.
--- @return AETHR Instance
function AETHR:initActiveDivisions()
    -- Attempt to read existing config from file.
    local data = self:loadActiveDivisions()
    if data then
        self.LEARNED_DATA.saveDivisions = data
    else
        self:generateActiveDivisions()
        -- Persist defaults to disk.
        self:saveActiveDivisions()
    end
    return self
end

function AETHR:loadWorldDivisions()
    local fullPath = AETHR.fileOps.joinPaths(
        self.ROOT_DIR,
        self.CONFIG.STORAGE.ROOT_FOLDER,
        self.CONFIG.STORAGE.CONFIG_FOLDER
    )
    local data = self.fileOps.loadData(
        fullPath,
        self.CONFIG.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE
    )
    if data then
        return data
    end
    return nil
end

function AETHR:saveWorldDivisions()
    local fullPath = AETHR.fileOps.joinPaths(
        self.ROOT_DIR,
        self.CONFIG.STORAGE.ROOT_FOLDER,
        self.CONFIG.STORAGE.CONFIG_FOLDER
    )
        self.fileOps.saveData(
            fullPath,
            self.CONFIG.STORAGE.FILENAMES.WORLD_DIVISIONS_FILE,
            self.LEARNED_DATA.worldDivisions
        )
end

function AETHR:generateWorldDivisions()
    -- Generate new divisions based on theater bounds and division area
    local boundsPoly = self.POLY.convertBoundsToPolygon(
        self.CONFIG.worldBounds[self.CONFIG.THEATER]
    )
    local worldDivs = self.POLY.dividePolygon(
        boundsPoly,
        self.CONFIG.worldDivisionArea
    )
    for i, div in ipairs(worldDivs) do
        div.ID = i             -- Assign unique ID
        div.active = false     -- Initial active flag
        self.LEARNED_DATA.worldDivisions[i] = div
    end
    return self
end

--- Loads existing world divisions if available; otherwise generates and saves new divisions.
--- @return AETHR Instance
function AETHR:initWorldDivisions()
    -- Attempt to read existing config from file.
    local data = self:loadWorldDivisions()
    if data then
        self.LEARNED_DATA.worldDivisions = data
    else
        self:generateWorldDivisions()
        -- Persist defaults to disk.
        self:saveWorldDivisions()
    end
    return self
end

--- Retrieves all airbases in the world and stores their data.
--- @return AETHR Instance
function AETHR:getAirbases()
    local bases = world.getAirbases() -- Array of airbase objects
    for _, ab in ipairs(bases) do
        local desc = ab:getDesc()
        local pos = ab:getPosition().p
        local data = {
            id = ab:getID(),
            id_ = ab.id_,
            coordinates = { x = pos.x, y = pos.y, z = pos.z },
            description = desc,
        }
        -- Map numeric category to text
        if desc.category == 0 then
            data.categoryText = "AIRDROME"
        elseif desc.category == 1 then
            data.categoryText = "HELIPAD"
        elseif desc.category == 2 then
            data.categoryText = "SHIP"
        end
        self.AIRBASES[desc.displayName] = data
    end
    return self
end

--- @function AETHR:loadUSERSTORAGE
--- @brief Loads user-specific data if available.
--- @return AETHR self Framework instance for chaining.
function AETHR:loadUSERSTORAGE()
    -- Attempt to load userStorage JSON file.
    local userData = self.fileOps.loadData(
        self.CONFIG.STORAGE.PATHS.USER_FOLDER,
        self.CONFIG.STORAGE.FILENAMES.USER_STORAGE_FILE
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
    self.fileOps.saveData(
        self.CONFIG.STORAGE.PATHS.USER_FOLDER,
        self.CONFIG.STORAGE.FILENAMES.USER_STORAGE_FILE,
        self.USERSTORAGE
    )
    return self
end
